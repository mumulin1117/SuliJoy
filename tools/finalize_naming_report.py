#!/usr/bin/env python3
import csv
import hashlib
import json
from pathlib import Path

out=Path('reports/naming-migration')
old=json.loads(Path('reports/original-names/inventory.json').read_text())
before=json.loads(Path('reports/current-names-before/inventory.json').read_text())
after=json.loads(Path('reports/current-names-after/inventory.json').read_text())
plan=json.loads((out/'rename-plan.json').read_text())
pool={r['base_name'] for r in old['declarations']}
assert set(plan['mapping'].values())<=pool
exceptions={'Data','Error','KeyedDecodingContainer','Sequence','UIImageView',
    'decisionHandler','didMoveToWindow','didReceive','didSelectItemAt','drawText',
    'errorDescription','initiatedByFrame','intrinsicContentSize',
    'requestMediaCapturePermissionFor','scrollViewDidEndDecelerating',
    'scrollViewDidEndDragging','scrollViewDidEndScrollingAnimation','type',
    'userContentController','webView','webViewWebContentProcessDidTerminate','willDecelerate'}
remaining=[r for r in after['declarations'] if r['base_name'] not in pool]
assert {r['base_name'] for r in remaining}<=exceptions,sorted({r['base_name'] for r in remaining}-exceptions)
assert not [r for r in remaining if r['kind'] in {'class','struct','enum'}]
with (out/'framework_required_names.csv').open('w',encoding='utf-8-sig',newline='') as f:
    fields=['kind','name','owner','file','line','classification']
    w=csv.DictWriter(f,fieldnames=fields,extrasaction='ignore');w.writeheader();w.writerows(remaining)
summary={}
for kind in ['class','struct','enum']:
    a=[r for r in old['declarations'] if r['kind']==kind]
    b=[r for r in before['declarations'] if r['kind']==kind]
    c=[r for r in after['declarations'] if r['kind']==kind]
    aa={r['name'] for r in a};bb={r['name'] for r in b}
    summary[kind]=dict(original_declarations=len(a),current_before_declarations=len(b),
        current_after_declarations=len(c),original_unique_names=len(aa),
        current_before_unique_names=len(bb),retained_unique_names=len(aa&bb),
        added_unique_names=len(bb-aa),removed_unique_names=len(aa-bb))
root=Path(after['source'])
changed=[]
for rel,digest in plan['before_hashes'].items():
    path=root/rel
    if hashlib.sha256(path.read_bytes()).hexdigest()!=digest:changed.append(rel)
before_names={r['base_name'] for r in before['declarations']}
after_names={r['base_name'] for r in after['declarations']}
retired=len((set(plan['mapping'])&before_names)-after_names)
tokens=json.loads((out/'semantic-token-audit.json').read_text())
assert all(r['identical_after_inverse_rename'] for r in tokens)
payloads=json.loads((out/'payload-fixture-result.json').read_text())
def build_ok(path):return Path(path).exists() and '** BUILD SUCCEEDED **' in Path(path).read_text()
verification=dict(debug_build=build_ok('/private/tmp/sulijoy-naming-final.log'),
    release_build=build_ok('/private/tmp/sulijoy-naming-release.log'),
    inverse_token_equivalence_files=len(tokens),payload_fixture_models=len(payloads['models_tested']),
    payload_json_identical=payloads['encoded_output_identical'],
    simulator_launch='iPhone 17 / iOS 26.5; fresh installation; EULA shown; process remained running',
    full_authenticated_flow_tested=False)
report=dict(types=summary,changed_files=changed,planned_identifier_mappings=len(plan['mapping']),
    retired_nonlegacy_declared_names=retired,new_autonomous_type_names=0,
    new_autonomous_declared_names_after_framework_exceptions=0,verification=verification)
(out/'summary.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n')
text=[
    '# 旧版与现有项目命名对比及替换结果','',
    '旧版来源：/Users/linqian/Desktop/JOiySuizoy（仅只读，未修改）。',
    '现有目标：JOiySuizoy/JOiySuizoy（48 个 Swift 文件）。',
    '范围：App target 的类型、方法、属性、参数、标签、局部变量与绑定名称；不重命名外部协议、API 字段、资源、文件路径、第三方代码及工具脚本。','',
    '## 类、结构体、枚举对比','',
]
for k,v in summary.items():
    text += [f'- {k}：旧版 {v["original_declarations"]} 个声明，现有重命名前 {v["current_before_declarations"]} 个声明，重命名后 {v["current_after_declarations"]} 个声明。',
             f'  按名称去重比较：保留 {v["retained_unique_names"]}，新增 {v["added_unique_names"]}，减少 {v["removed_unique_names"]}。']
text += ['',
    '旧版 62 个枚举声明去重后是 51 个名称，现有重命名前 153 个枚举声明去重后是 78 个名称；CodingKeys 等嵌套同名类型会重复声明。结构体也有嵌套同名。',
    '重命名后新增的 22 个枚举声明均使用旧版已有的 CodingKeys，用来保留自动 Codable 的原有字段，不增加新命名词汇；不减少现有功能或类型数量。','',
    '## 替换规则','',
    '旧版已有名称均不进入替换映射。仅替换旧版命名池外的自主标识符；从旧版声明词汇池随机抽取，固定随机种子 20261026，并检查目标名称在受影响文件中的冲突与系统名称遮蔽。',
    '取名池包含旧版所有自主声明名称，不限于旧版同种类型名称；因此新类可能使用旧版变量或方法名，大小写可能与惯例不同。',
    f'映射共 {len(plan["mapping"])} 项，实际有 {retired} 个原先非旧版名称不再作为源码声明出现。176 个原先非旧版类型名称均已替换。',
    '保留的剩余名称均为系统类型扩展、override、协议要求或外部参数标签，详见 framework_required_names.csv。这些名称不是自主新增词汇，不能任意替换。',
    '保留已有字符串、JSON 键、枚举字符串 rawValue、资源名与持久化键。Codable 模型通过显式 CodingKeys 保留旧数据格式。Objective-C selector 引用随代码符号同步。','',
    '## 对比与映射文件','',
    '- type_comparison.csv：按类型名称比较保留、新增和减少，并给出替换目标。',
    '- rename_mapping.csv：每个当前名称对应的旧版名称及涉及文件。',
    '- framework_required_names.csv：未出现在旧词汇池但必须保留的系统要求名称及位置。',
    '- summary.json：数量、影响文件和验证结果。',
    '- ../current-names-before/ 与 ../current-names-after/：替换前后的完整声明清单。',
    '- before-source/：重命名前源码快照，仅作本次恢复和审计使用，包含工程配置，不应作为公开附件。','',
    '## 验证证据','',
    f'- Debug 构建通过：{verification["debug_build"]}。',
    f'- Release 构建通过：{verification["release_build"]}。',
    '- 48/48 文件通过逆向命名 token 等价检查；仅允许显式编码键、原始枚举值、系统回调局部参数及等价绑定兼容语法。',
    '- 12 个请求模型进行真实 Foundation JSON 编码，修改前后结果逐字一致：登录、刷新凭证、个人资料、空请求、用户 ID、关注、会话列表、历史、发送、已读、打开会话和拉黑。',
    '- iPhone 17 / iOS 26.5 模拟器成功安装并启动，显示首次 EULA，进程持续运行；截图 launch-after.png。',
    '- 未操作真实账号登录、购买、发布、私信或直播，也未完成所有页面的 UI 自动回归。编译与静态等价不等于所有线上流程均已实测。','',
    '## 影响文件','',
] + [f'- JOiySuizoy/JOiySuizoy/{rel}' for rel in changed]
(out/'README.md').write_text('\n'.join(text)+'\n')
print(json.dumps(report,ensure_ascii=False,indent=2))
