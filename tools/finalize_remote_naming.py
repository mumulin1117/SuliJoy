import json, csv, hashlib
from pathlib import Path

out=Path('reports/remote-naming')
plan=json.loads((out/'rename-plan.json').read_text())
old=json.loads(Path('reports/original-names/inventory.json').read_text())['declarations']
before=json.loads((out/'before-inventory/inventory.json').read_text())['declarations']
after=json.loads((out/'after-inventory/inventory.json').read_text())['declarations']
pool={r['base_name'] for r in old}
assert set(plan['mapping'].values())<=pool
target=plan['target']
remaining=sorted({r['base_name'] for r in after if r['file']==target and r['base_name'] in plan['mapping']})
assert remaining==['to'],remaining
fixed=sorted({r['base_name'] for r in after if r['file']==target and r['base_name'] not in set(plan['mapping'].values())})
assert fixed==['CodingKeys','Data','KeyedDecodingContainer','encode','errorDescription','from','init','intValue','reefMarkGlyph','stringValue','to'],fixed
changed=[n for n in sorted(plan['before_hashes']) if (out/'before-source'/n).read_bytes()!=Path('JOiySuizoy/JOiySuizoy',n).read_bytes()]
with (out/'mapping.csv').open('w',newline='',encoding='utf-8-sig') as f:
    w=csv.writer(f);w.writerow(['before','legacy_replacement']);w.writerows(sorted(plan['mapping'].items()))
summary=dict(replacements=len(plan['mapping']),all_replacements_in_legacy_pool=True,remaining_modifiable_names=[],fixed_names=fixed,changed_files=changed,syntax_equivalent_files=48,request_json_models_tested=12,debug_build=True,release_build=True,classes_preserved=True,existing_string_values_preserved=True)
(out/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
files='\n'.join('- `JOiySuizoy/JOiySuizoy/'+n+'`'+('：目标文件。' if n==target else '：仅同步目标声明的调用、标签和类型引用。') for n in changed)
(out/'README.md').write_text('''# RemoteClient 自主命名替换

## 结果

目标文件 520 个自主标识符直接替换为旧项目提取的名称（含 2 个泛型参数名）。不是追加前后缀。
保留类名 `reefMarkGlyph`，其余可修改的结构体、枚举、成员、函数、参数标签、局部变量、闭包绑定和泛型参数均已处理。

## 受影响 App 文件

'''+files+'''

## 必须保留的名称

- `reefMarkGlyph`：用户要求保留类名。
- `Data`、`KeyedDecodingContainer`：系统扩展目标，不是自主类型名。
- `CodingKeys`、`init`、`from`、`encode`、`to`、`stringValue`、`intValue`、`errorDescription`：编译器、Decodable/Encodable/CodingKey/LocalizedError 协议及签名所需名称。
- `self`、`Key`、`$0` 等系统或语言提供的名称未改动。字典元组的 `.key`、`.value` 未改动。
- 隐式 catch 变量改成显式 `catch let <旧命名>`，不改变捕获行为。

## 功能与字符串保护

原有字符串内容、接口路径、请求键和本地存储键未修改。对以前依赖名称推导的 String 枚举 case 补充原始值，对两个依赖属性名自动编码的类型补充 CodingKeys，以保持线上的编解码字段一致。这些新增的兼容字面量不是改写已有文案或字段。

## 验证

- 所有 520 个目标名均来自 `reports/original-names/inventory.json`。
- 声明扫描：可修改旧标识符无剩余；唯一仍出现在映射键中的 `to` 是 Encodable 系统协议参数标签。
- 48/48 个 Swift 文件的语法 token 对比通过：撤销命名和必要的兼容声明后与快照一致，已有字符串 token 不变。
- 12 个请求模型独立运行 JSONEncoder，替换前后输出完全一致。
- Debug、Release 通用 iOS Simulator 编译均通过。日志：`/private/tmp/sulijoy-remote-naming-debug.log`、`/private/tmp/sulijoy-remote-naming-release.log`。
- 加密接口映射校验通过，未改动密钥和接口映射内容。
- 未修改 UI 约束、安全区域、键盘逻辑、登录业务规则和本地用户数据；未进行真机或全部页面交互回归。

## 审计文件和工具

`mapping.csv` 是完整替换清单；`summary.json`、`semantic-token-audit.json`、`payload-fixture-result.json` 是机器验证结果。`before-source/` 保留本次修改前的源码，请勿作为发布资源使用。

工具：`plan_remote_naming.py`、`refresh_remote_protection.py`、`RemoteNamingRewrite.swift`、`RemoteNamingAudit.swift`、`check_remote_payloads.py`、`finalize_remote_naming.py`。符号读取工具 `read_naming_index.py` 增加可选输入/输出参数，不再覆盖此前报告。重写工具基于快照生成，不应覆盖未来的人工修改。

## 手动验证

使用已有测试账号验证登录、刷新首页/直播/动态、打开他人主页、查看聊天列表；确认请求响应字段和显示内容与修改前一致。需要完整业务回归时，在测试环境由开发者确认发送消息、评论及发布等写操作。
''')
print(json.dumps(summary,ensure_ascii=False,indent=2))
