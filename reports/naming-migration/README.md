# 旧版与现有项目命名对比及替换结果

旧版来源：/Users/linqian/Desktop/JOiySuizoy（仅只读，未修改）。
现有目标：JOiySuizoy/JOiySuizoy（48 个 Swift 文件）。
范围：App target 的类型、方法、属性、参数、标签、局部变量与绑定名称；不重命名外部协议、API 字段、资源、文件路径、第三方代码及工具脚本。

## 类、结构体、枚举对比

- class：旧版 76 个声明，现有重命名前 107 个声明，重命名后 107 个声明。
  按名称去重比较：保留 69，新增 38，减少 7。
- struct：旧版 58 个声明，现有重命名前 157 个声明，重命名后 157 个声明。
  按名称去重比较：保留 52，新增 104，减少 6。
- enum：旧版 62 个声明，现有重命名前 153 个声明，重命名后 175 个声明。
  按名称去重比较：保留 44，新增 34，减少 7。

旧版 62 个枚举声明去重后是 51 个名称，现有重命名前 153 个枚举声明去重后是 78 个名称；CodingKeys 等嵌套同名类型会重复声明。结构体也有嵌套同名。
重命名后新增的 22 个枚举声明均使用旧版已有的 CodingKeys，用来保留自动 Codable 的原有字段，不增加新命名词汇；不减少现有功能或类型数量。

## 替换规则

旧版已有名称均不进入替换映射。仅替换旧版命名池外的自主标识符；从旧版声明词汇池随机抽取，固定随机种子 20261026，并检查目标名称在受影响文件中的冲突与系统名称遮蔽。
取名池包含旧版所有自主声明名称，不限于旧版同种类型名称；因此新类可能使用旧版变量或方法名，大小写可能与惯例不同。
映射共 1432 项，实际有 1415 个原先非旧版名称不再作为源码声明出现。176 个原先非旧版类型名称均已替换。
保留的剩余名称均为系统类型扩展、override、协议要求或外部参数标签，详见 framework_required_names.csv。这些名称不是自主新增词汇，不能任意替换。
保留已有字符串、JSON 键、枚举字符串 rawValue、资源名与持久化键。Codable 模型通过显式 CodingKeys 保留旧数据格式。Objective-C selector 引用随代码符号同步。

## 对比与映射文件

- type_comparison.csv：按类型名称比较保留、新增和减少，并给出替换目标。
- rename_mapping.csv：每个当前名称对应的旧版名称及涉及文件。
- framework_required_names.csv：未出现在旧词汇池但必须保留的系统要求名称及位置。
- summary.json：数量、影响文件和验证结果。
- ../current-names-before/ 与 ../current-names-after/：替换前后的完整声明清单。
- before-source/：重命名前源码快照，仅作本次恢复和审计使用，包含工程配置，不应作为公开附件。

## 验证证据

- Debug 构建通过：True。
- Release 构建通过：True。
- 48/48 文件通过逆向命名 token 等价检查；仅允许显式编码键、原始枚举值、系统回调局部参数及等价绑定兼容语法。
- 12 个请求模型进行真实 Foundation JSON 编码，修改前后结果逐字一致：登录、刷新凭证、个人资料、空请求、用户 ID、关注、会话列表、历史、发送、已读、打开会话和拉黑。
- iPhone 17 / iOS 26.5 模拟器成功安装并启动，显示首次 EULA，进程持续运行；截图 launch-after.png。
- 未操作真实账号登录、购买、发布、私信或直播，也未完成所有页面的 UI 自动回归。编译与静态等价不等于所有线上流程均已实测。

## 影响文件

- JOiySuizoy/JOiySuizoy/SuliJoyLagoonProfileRemoteService.swift
- JOiySuizoy/JOiySuizoy/SuliJoyShareBroadcastDraftControllers.swift
- JOiySuizoy/JOiySuizoy/SuliJoyruffleHem.swift
- JOiySuizoy/JOiySuizoy/SuliJoyLagoonBoardControllers.swift
- JOiySuizoy/JOiySuizoy/SuliJoyAgentKeyBarController.swift
- JOiySuizoy/JOiySuizoy/SuliJoyTideCardCell.swift
- JOiySuizoy/JOiySuizoy/SuliJoyRoomShellWebController.swift
- JOiySuizoy/JOiySuizoy/SuliJoyOpiRegistry.swift
- JOiySuizoy/JOiySuizoy/SuliJoyLagoonRemoteConfiguration.swift
- JOiySuizoy/JOiySuizoy/SuliJoyTideCoastalDetailController.swift
- JOiySuizoy/JOiySuizoy/SuliJoyMusiInDoController.swift
- JOiySuizoy/JOiySuizoy/suliJoyShorelineIntent.swift
- JOiySuizoy/JOiySuizoy/SuliJoyLagoonRemoteClient.swift
- JOiySuizoy/JOiySuizoy/SuliJoyShoreReportSheetController.swift
- JOiySuizoy/JOiySuizoy/SuliJoyLagoonProfileCoveController.swift
- JOiySuizoy/JOiySuizoy/SuliJoyLagoonSessionStore.swift
- JOiySuizoy/JOiySuizoy/SuliJoyShellPearlStore.swift
- JOiySuizoy/JOiySuizoy/SuliJoyChallengeShareLookController.swift
- JOiySuizoy/JOiySuizoy/SuliJoysequinedGlimmerController.swift
- JOiySuizoy/JOiySuizoy/SuliJoyMainUI.swift
- JOiySuizoy/JOiySuizoy/SuliJoyRoomShellBridge.swift
- JOiySuizoy/JOiySuizoy/SuliJoyShoortController.swift
- JOiySuizoy/JOiySuizoy/SuliJoyLagoonLettersViewController.swift
- JOiySuizoy/JOiySuizoy/SuliJoyCoveMockService.swift
- JOiySuizoy/JOiySuizoy/SuliJoyReefMotionTideController.swift
- JOiySuizoy/JOiySuizoy/SuliJoyIslandVisitorProfileViewController.swift
- JOiySuizoy/JOiySuizoy/SuliJoyTideCurationDraftController.swift
- JOiySuizoy/JOiySuizoy/SuliJoyJokerAuthUserService.swift
- JOiySuizoy/JOiySuizoy/SuliJoyPearlHarborViewController.swift
- JOiySuizoy/JOiySuizoy/SuliJoyShellelasticWaistController.swift
- JOiySuizoy/JOiySuizoy/SuliJoyShoreSkeleton.swift
- JOiySuizoy/JOiySuizoy/SuliJoyLagoonMirrorController.swift
- JOiySuizoy/JOiySuizoy/SuliJoymetallicThreadController.swift
- JOiySuizoy/JOiySuizoy/SuliJoyForinController.swift
- JOiySuizoy/JOiySuizoy/SuliJoyLagoonHarborService.swift
- JOiySuizoy/JOiySuizoy/SuliJoyLagoonImageShelf.swift
- JOiySuizoy/JOiySuizoy/SuliJoyShoreRoomLoadingView.swift
