# SuliJoy 字符串处理记录

本次沿用 `SuliJoyPalmGlyphWeaver` / `suliJoyPalmUnfurled`，不新增 App 类型、方法或属性，不更改既有解码器。

## 修改范围

- 44 个 Swift 源文件、1,407 处原未处理字符串表达式（含插值字符串）。逐文件数量见 [summary.json](summary.json)。
- UI 文案、资源名称、接口路径、字典字段、缓存键、日志静态内容在使用时还原。
- 插值字符串只处理静态片段；动态插值表达式及求值顺序保留。
- 三处字符分隔符显式使用 `Character`，保持原来的字符类型和系统 API 重载。
- 已处理的字符串不重复处理；空字符串不处理。
- 310 处枚举原始值等编译期字面量保留。尤其保留 CodingKeys 原始字段，避免影响 JSON 编解码和本地数据。它们不能直接替换成运行时解码表达式。
- 不处理 Pods、网站文件、Info.plist、资源文件和历史报告。

## 可追溯与验证

- `before-source/` 保存本次转换前的 47 个文件（包括之前已完成的命名迁移）。不得当作旧版本代码覆盖使用。
- `tools/EncodeProjectStrings.swift`：语法树转换、Swift Character 逐项往返校验；重复运行基于本次快照，勿用于覆盖后续人工改动。
- `tools/AuditProjectStrings.swift`：将新旧字符串统一归一化，并比较全部语法 token。47 个文件一致，不仅仅检查字符串数量。
- Debug、Release 的通用 iOS Simulator 构建均通过，日志分别为 `/private/tmp/sulijoy-strings-debug.log`、`/private/tmp/sulijoy-strings-release.log`。
- 测试用 iPhone 17 模拟器成功启动 App，画面见 `launch-after.png`。未执行登录、付费、发布或发送消息等真实服务器操作；未实际遍历各页面的大小屏和键盘回归。

## 手动回归建议

1. 冷启动检查 EULA、欢迎页、登录注册文案与图片。
2. 使用已有测试账号，检查登录请求字段和响应解析；不改登录流程。
3. 检查首页、直播、动态、他人主页、活动及聊天的文字和图片。
4. 检查动态中的多行文案、emoji、插值计数、评论输入和键盘避让。
5. 杀进程重启，确认登录状态和已有本地数据继续可读。
