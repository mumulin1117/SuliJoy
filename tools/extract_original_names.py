#!/usr/bin/env python3
"""Read Swift source using the compiler's parse tree and export a naming inventory."""
import argparse
import csv
import hashlib
import json
import re
import subprocess
from collections import Counter
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

KINDS = {
    'class_decl': 'class', 'struct_decl': 'struct', 'enum_decl': 'enum',
    'protocol': 'protocol', 'protocol_decl': 'protocol',
    'typealias': 'typealias', 'typealias_decl': 'typealias',
    'extension_decl': 'extension', 'func_decl': 'function',
    'constructor_decl': 'initializer', 'destructor_decl': 'deinitializer',
    'subscript_decl': 'subscript', 'var_decl': 'variable',
    'enum_element_decl': 'enum_case', 'parameter': 'parameter',
    'generic_type_param_decl': 'generic_parameter', 'pattern_named': 'binding_pattern',
}
TYPE_KINDS = {'class', 'struct', 'enum', 'protocol', 'extension'}
CALL_KINDS = {'function', 'initializer', 'deinitializer', 'subscript'}
FIELDS = ['kind', 'name', 'base_name', 'owner', 'file', 'line', 'column',
          'location_basis', 'classification', 'is_override', 'is_static']


def parse_file(path):
    data = path.read_bytes()
    source = data.decode('utf-8-sig').splitlines()
    result = subprocess.run(['xcrun', 'swiftc', '-frontend', '-dump-parse', str(path)],
                            capture_output=True, text=True)
    if result.returncode:
        raise RuntimeError(f'Swift parse failed: {path.name}\n{result.stderr[:1800]}')
    tree = result.stdout if '(source_file' in result.stdout else result.stderr
    if '(source_file' not in tree:
        raise RuntimeError(f'No Swift parse tree: {path.name}')
    rows, stack = [], []
    for text in tree.splitlines():
        node = re.match(r'^(\s*)\(([\w_]+)\b', text)
        if not node:
            continue
        indent, raw_kind = len(node[1]), node[2]
        while stack and stack[-1]['indent'] >= indent:
            stack.pop()
        location = re.search(r'range=\[.*?:(\d+):(\d+)\s+-', text)
        line = int(location[1]) if location else (stack[-1]['line'] if stack else 1)
        col = int(location[2]) if location else 0
        kind = KINDS.get(raw_kind)
        name = ''
        # Declaration names follow their source range, not attributes such as inherits.
        tail = text[location.end():] if location else text
        if location:
            tail = text.split(']', 1)[-1]
        quoted = re.search(r'"([^"\n]+)"', tail)
        if kind and quoted:
            name = quoted[1]
        owners = [x['name'] for x in stack if x['name'] and
                  (x['kind'] in TYPE_KINDS or x['kind'] in CALL_KINDS)]
        if kind and name and name != 'self' and name != '_' and not name.startswith('$'):
            in_callable = any(x['kind'] in CALL_KINDS or x['raw_kind'] == 'closure_expr' for x in stack)
            if kind == 'variable':
                kind = 'local_variable' if in_callable else ('property' if owners else 'global_variable')
            src_line = source[line - 1] if 0 < line <= len(source) else ''
            is_override = bool(re.search(r'\boverride\b', src_line)) if location else False
            if kind in {'initializer', 'deinitializer', 'subscript'}:
                classification = 'language_defined_base_name'
            elif kind == 'extension':
                classification = 'extension_target_not_new_type'
            elif is_override:
                classification = 'override_name_not_independent'
            elif kind == 'function':
                classification = 'source_declared_protocol_callback_or_custom'
            else:
                classification = 'source_declared'
            row = dict(kind=kind, name=name, base_name=name.split('(')[0],
                       owner='.'.join(owners), line=line, column=col,
                       location_basis='compiler_range' if location else 'enclosing_declaration',
                       classification=classification, is_override=is_override,
                       is_static=bool(re.search(r'\bstatic\b', text)))
            rows.append(row)
            if kind in CALL_KINDS and '(' in name:
                labels = name.split('(', 1)[1].rsplit(')', 1)[0].split(':')
                for label in labels:
                    if label and label != '_':
                        rows.append(dict(row, kind='argument_label', name=label,
                                         base_name=label, owner='.'.join(owners + [name]),
                                         classification='source_declared_argument_label'))
        stack.append(dict(indent=indent, raw_kind=raw_kind, kind=kind,
                          name=name, line=line))
    # Swift's untyped tree repeats enum cases and original/processed expression trees.
    unique = {}
    for row in rows:
        key = (row['kind'], row['name'], row['owner'], row['line'], row['column'])
        unique[key] = row
    return list(unique.values()), hashlib.sha256(data).hexdigest()


def write_csv(path, rows, fields=FIELDS):
    with path.open('w', encoding='utf-8-sig', newline='') as stream:
        writer = csv.DictWriter(stream, fieldnames=fields, extrasaction='ignore')
        writer.writeheader()
        writer.writerows(rows)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--source', required=True, type=Path)
    parser.add_argument('--output', required=True, type=Path)
    args = parser.parse_args()
    root, out = args.source.resolve(), args.output.resolve()
    files = sorted(p for p in root.rglob('*.swift') if not any(
        part in {'Pods', '.git', 'build', 'DerivedData', '.build'} for part in p.relative_to(root).parts))
    rows, manifest = [], []
    with ThreadPoolExecutor(max_workers=4) as executor:
        for path, (symbols, digest) in zip(files, executor.map(parse_file, files)):
            rel = str(path.relative_to(root))
            for symbol in symbols:
                symbol['file'] = rel
            rows.extend(symbols)
            manifest.append({'file': rel, 'sha256': digest})
    rows.sort(key=lambda r: (r['file'], r['line'], r['column'], r['kind'], r['name']))
    out.mkdir(parents=True, exist_ok=True)
    write_csv(out / 'all_declarations.csv', rows)
    classes = [r for r in rows if r['kind'] == 'class']
    write_csv(out / 'classes.csv', classes)
    types = [r for r in rows if r['kind'] in TYPE_KINDS | {'typealias'}]
    write_csv(out / 'types.csv', types)
    write_csv(out / 'functions.csv', [r for r in rows if r['kind'] in CALL_KINDS])
    write_csv(out / 'properties_and_variables.csv', [r for r in rows if r['kind'] in
              {'property', 'global_variable', 'local_variable'}])
    write_csv(out / 'parameters_and_enum_cases.csv', [r for r in rows if r['kind'] in
              {'parameter', 'generic_parameter', 'enum_case', 'argument_label'}])
    write_csv(out / 'binding_patterns.csv', [r for r in rows if r['kind'] == 'binding_pattern'])
    names = sorted(set(r['base_name'] for r in rows if r['classification'] not in
                       {'language_defined_base_name', 'extension_target_not_new_type',
                        'override_name_not_independent'}))
    (out / 'declared_names.txt').write_text('\n'.join(names) + '\n', encoding='utf-8')
    (out / 'class_names.txt').write_text('\n'.join(sorted(set(r['name'] for r in classes))) + '\n', encoding='utf-8')
    asset_rows = [{'name': p.stem, 'kind': p.suffix.lstrip('.'),
                   'file': str(p.relative_to(root))} for p in root.rglob('*')
                  if p.is_dir() and p.suffix in {'.imageset', '.colorset', '.dataset'}
                  and 'Pods' not in p.relative_to(root).parts]
    asset_rows.sort(key=lambda x: x['file'])
    write_csv(out / 'asset_names.csv', asset_rows, ['kind', 'name', 'file'])
    (out / 'source_filenames.txt').write_text('\n'.join(str(p.relative_to(root)) for p in files) + '\n', encoding='utf-8')
    counts = dict(sorted(Counter(r['kind'] for r in rows).items()))
    inventory = dict(source=str(root), swift_file_count=len(files), counts=counts,
                     distinct_declared_names=len(names), asset_count=len(asset_rows),
                     source_manifest=manifest, declarations=rows, assets=asset_rows)
    (out / 'inventory.json').write_text(json.dumps(inventory, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    report = [
        '# 原始项目命名提取清单', '', f'读取来源：`{root}`', '',
        '使用 Swift 编译器 `-frontend -dump-parse` 解析项目源文件；不修改原工程，不包含 Pods、构建产物或第三方库声明。',
        '所有拼写及大小写均保留原样。按源文件中的声明提取，不根据文件名推测类名。', '',
        f'Swift 文件：{len(files)}；类声明：{len(classes)}；声明记录：{len(rows)}；去重名称：{len(names)}；资源名称：{len(asset_rows)}。', '',
        '## 分类统计', '',
    ] + [f'- {k}: {v}' for k, v in counts.items()] + [
        '', '## 文件说明', '',
        '- `class_names.txt`：去重类名，每行一个。',
        '- `classes.csv`：类及所在源文件和行号，包含私有/嵌套类。',
        '- `types.csv`：类、结构体、枚举、协议、类型别名及扩展目标。扩展系统类型不等于自主创建该类型。',
        '- `functions.csv`：函数、方法、构造/析构及下标，保留参数标签组成的完整名称。',
        '- `properties_and_variables.csv`：属性、全局变量和局部变量。',
        '- `parameters_and_enum_cases.csv`：具名参数、编译器显式泛型参数、外部参数标签及枚举成员；排除隐式 $0 / $1。',
        '- `binding_patterns.csv`：额外保留编译器的绑定模式名称，补充 for/catch、闭包等绑定；与变量清单有重叠，位置按外层范围定位。',
        '- `declared_names.txt`：声明基础名称去重集合，移除语言固定基础名称、扩展目标和显式 override 名称；协议方法仍可能在其中。',
        '- `all_declarations.csv` / `inventory.json`：完整声明、分类、作用域及可复查位置；JSON 含源文件 SHA-256。',
        '- `asset_names.csv` / `source_filenames.txt`：资源目录名称及 Swift 文件名称。',
        '', '## 自主命名的边界', '',
        '源文件内存在的名字不必然都是自主创造：UIKit 协议回调、CodingKeys、AppDelegate、通用属性名等也可能由系统约定。',
        '保留这些声明便于完整核对；classification 字段标记显式 override、语言固定名及扩展目标。未进行完整类型检查，不能自动证明每个协议方法的命名来源。',
        '参数若没有独立源码范围，行号指向其外层声明，location_basis 标记为 enclosing_declaration；同名/同一行参数可能合并。',
        '不将调用到的 UIKit 方法、注释和字符串当成自主声明。不提取密码、Token、请求内容、文案或资源文件内容。',
        '此清单基于编译器输出的声明和绑定模式；不包含编译器未作为显式声明输出的语法名称或条件编译中未激活分支的完整语义。',
        '', '## 所有类', '',
    ]
    report.extend(f'- `{r["owner"] + "." if r["owner"] else ""}{r["name"]}` — `{r["file"]}:{r["line"]}`' for r in classes)
    (out / 'README.md').write_text('\n'.join(report) + '\n', encoding='utf-8')
    print(json.dumps({k: v for k, v in inventory.items() if k not in
                      {'declarations', 'source_manifest', 'assets'}}, ensure_ascii=False, indent=2))


if __name__ == '__main__':
    main()
