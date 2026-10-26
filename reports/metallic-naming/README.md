# 发布选择页面自主命名直接替换

## 修改文件

- `JOiySuizoy/JOiySuizoy/SuliJoymetallicThreadController.swift`：唯一修改的 App 源文件，26 个自主标识符直接替换为原项目提取的名称，未添加前后缀。
- `tools/plan_metallic_naming.py`：按目标文件声明、旧项目词池和编译符号生成无冲突替换计划，快照仅用于审计，不应覆盖未来的人工修改。
- `tools/AuditScopedNaming.swift`：严格比较替换前后所有语法 token，仅允许标识符变更。
- 本目录：替换清单、源码快照和验证结果；均不加入 App target。

## 替换范围与例外

- 7 个自定义方法及其全部调用、参数标签、本地变量、常量和局部参数名均已替换；包括 `#selector` 中引用的方法和生命周期方法的本地 `animated` 参数。
- 保留类名 `SuliJoymetallicThreadController`，保留系统覆盖方法 `viewDidLoad`、`viewWillAppear`、`viewWillDisappear`。
- UIKit 属性、方法和外部参数标签保持原样，例如 `action:`、`named:`、`animated:`；本类自定义方法中的同名参数标签则已替换。
- 两处闭包使用的 `$0` 是 Swift 隐式参数，不是自主命名，保留。
- 本文件没有自主结构体、枚举、全局变量或存储属性，不新增这些声明。

## 完整性验证

- `mapping.csv` 列出全部 26 组直接替换；目标名称全部来自 `reports/original-names/inventory.json`，且均未在替换前的目标文件中出现。
- 替换后声明扫描：26 个可修改旧标识符无剩余；未替换声明只剩类名和三个 UIKit 系统覆盖方法。
- 反向恢复标识符后，语法 token 完全相同，详见 `syntax-audit.json`；未修改任何字符串字面量、资源名称、布局常量或方法执行流程。
- 五处按钮 selector 引用与对应方法同步替换；目标页面类型和入栈/出栈逻辑不变。
- 对照上一任务完成时 48 个源文件的哈希，只有本次目标文件变化。
- Debug 和 Release 通用 iOS Simulator 全项目编译均通过，日志：`/private/tmp/sulijoy-metallic-naming-debug.log`、`/private/tmp/sulijoy-metallic-naming-release.log`。

## 业务影响与手动测试

不影响登录注册、本地用户数据，不修改 UI 布局、安全区域及键盘逻辑。未进行真机或完整页面交互回归。

建议进入发布选择页面，检查图片和布局；依次点击 Go Live、Start a Room、Post Moment、Shorts Video，确认目标页面正确。检查关闭按钮返回及 TabBar 隐藏/恢复；大小屏布局应与修改前一致。
