# 原始项目命名提取清单

读取来源：`/Users/linqian/Desktop/JOiySuizoy`

使用 Swift 编译器 `-frontend -dump-parse` 解析项目源文件；不修改原工程，不包含 Pods、构建产物或第三方库声明。
所有拼写及大小写均保留原样。按源文件中的声明提取，不根据文件名推测类名。

Swift 文件：37；类声明：76；声明记录：7157；去重名称：2772；资源名称：123。

## 分类统计

- argument_label: 569
- binding_pattern: 2187
- class: 76
- deinitializer: 7
- enum: 62
- enum_case: 143
- extension: 11
- function: 907
- initializer: 147
- local_variable: 813
- parameter: 993
- property: 1183
- struct: 58
- typealias: 1

## 文件说明

- `class_names.txt`：去重类名，每行一个。
- `classes.csv`：类及所在源文件和行号，包含私有/嵌套类。
- `types.csv`：类、结构体、枚举、协议、类型别名及扩展目标。扩展系统类型不等于自主创建该类型。
- `functions.csv`：函数、方法、构造/析构及下标，保留参数标签组成的完整名称。
- `properties_and_variables.csv`：属性、全局变量和局部变量。
- `parameters_and_enum_cases.csv`：具名参数、编译器显式泛型参数、外部参数标签及枚举成员；排除隐式 $0 / $1。
- `binding_patterns.csv`：额外保留编译器的绑定模式名称，补充 for/catch、闭包等绑定；与变量清单有重叠，位置按外层范围定位。
- `declared_names.txt`：声明基础名称去重集合，移除语言固定基础名称、扩展目标和显式 override 名称；协议方法仍可能在其中。
- `all_declarations.csv` / `inventory.json`：完整声明、分类、作用域及可复查位置；JSON 含源文件 SHA-256。
- `asset_names.csv` / `source_filenames.txt`：资源目录名称及 Swift 文件名称。

## 自主命名的边界

源文件内存在的名字不必然都是自主创造：UIKit 协议回调、CodingKeys、AppDelegate、通用属性名等也可能由系统约定。
保留这些声明便于完整核对；classification 字段标记显式 override、语言固定名及扩展目标。未进行完整类型检查，不能自动证明每个协议方法的命名来源。
参数若没有独立源码范围，行号指向其外层声明，location_basis 标记为 enclosing_declaration；同名/同一行参数可能合并。
不将调用到的 UIKit 方法、注释和字符串当成自主声明。不提取密码、Token、请求内容、文案或资源文件内容。
此清单基于编译器输出的声明和绑定模式；不包含编译器未作为显式声明输出的语法名称或条件编译中未激活分支的完整语义。

## 所有类

- `AppDelegate` — `JOiySuizoy/AppDelegate.swift:11`
- `SuliJoyAgentKeyBarController` — `JOiySuizoy/SuliJoyAgentKeyBarController.swift:3`
- `SuliJoyMineLiteViewController` — `JOiySuizoy/SuliJoyAgentKeyBarController.swift:164`
- `SuliJoyCoveMockService` — `JOiySuizoy/SuliJoyCoveMockService.swift:3`
- `SuliJoyForinController` — `JOiySuizoy/SuliJoyForinController.swift:3`
- `SuliJoyTideCardCell` — `JOiySuizoy/SuliJoyForinController.swift:425`
- `SuliJoyIslandGuestProfileViewController` — `JOiySuizoy/SuliJoyIslandVisitorProfileViewController.swift:20`
- `SuliJoyGuestFollowButton` — `JOiySuizoy/SuliJoyIslandVisitorProfileViewController.swift:477`
- `SuliJoyGuestSegmentButton` — `JOiySuizoy/SuliJoyIslandVisitorProfileViewController.swift:518`
- `SuliJoyGuestMetricView` — `JOiySuizoy/SuliJoyIslandVisitorProfileViewController.swift:558`
- `SuliJoyGuestActionButton` — `JOiySuizoy/SuliJoyIslandVisitorProfileViewController.swift:590`
- `SuliJoyGuestPreviewControl` — `JOiySuizoy/SuliJoyIslandVisitorProfileViewController.swift:625`
- `SuliJoyGuestMomentPreviewCard` — `JOiySuizoy/SuliJoyIslandVisitorProfileViewController.swift:644`
- `SuliJoyGuestClipPreviewCard` — `JOiySuizoy/SuliJoyIslandVisitorProfileViewController.swift:705`
- `SuliJoyGuestActivityPreviewCard` — `JOiySuizoy/SuliJoyIslandVisitorProfileViewController.swift:747`
- `SuliJoyIslanddeckView` — `JOiySuizoy/SuliJoyIslanddeckView.swift:8`
- `SuliJoyGradientButton` — `JOiySuizoy/SuliJoyIslanddeckView.swift:71`
- `SuliJoyAuthTextField` — `JOiySuizoy/SuliJoyIslanddeckView.swift:146`
- `SuliJoyLagoonConsentRibbon` — `JOiySuizoy/SuliJoyIslanddeckView.swift:176`
- `SuliJoyReefEntryCanvasController` — `JOiySuizoy/SuliJoyIslanddeckView.swift:261`
- `SuliJoyLagoonGateService` — `JOiySuizoy/SuliJoyJokerAuthUserService.swift:3`
- `SuliJoyLagoonConsentScrollController` — `JOiySuizoy/SuliJoyLagoonConsentScrollController.swift:3`
- `SuliJoyLagoonHarborService` — `JOiySuizoy/SuliJoyLagoonHarborService.swift:14`
- `SuliJoyLagoonLettersViewController` — `JOiySuizoy/SuliJoyLagoonLettersViewController.swift:3`
- `SuliJoyLagoonMirrorController` — `JOiySuizoy/SuliJoyLagoonMirrorController.swift:3`
- `SuliJoyLagoonProfileCoveController` — `JOiySuizoy/SuliJoyLagoonProfileCoveController.swift:3`
- `SuliJoyLagoonScrollTextController` — `JOiySuizoy/SuliJoyLagoonScrollTextController.swift:8`
- `SuliJoyTideSessionVault` — `JOiySuizoy/SuliJoyLagoonSessionStore.swift:3`
- `SuliJoyIslandAccountStore` — `JOiySuizoy/SuliJoyLagoonSessionStore.swift:75`
- `SuliJoyLocalProfileStore` — `JOiySuizoy/SuliJoyLagoonSessionStore.swift:132`
- `SuliJoyCoveCapsuleIconButton` — `JOiySuizoy/SuliJoyMainUI.swift:62`
- `SuliJoyShellGemPillButton` — `JOiySuizoy/SuliJoyMainUI.swift:100`
- `SuliJoyGradientCapsuleView` — `JOiySuizoy/SuliJoyMainUI.swift:151`
- `SuliJoyTropicCanvasController` — `JOiySuizoy/SuliJoyMainUI.swift:179`
- `SuliJoySimplePlaceholderViewController` — `JOiySuizoy/SuliJoyMainUI.swift:510`
- `SuliJoyMusiInDoController` — `JOiySuizoy/SuliJoyMusiInDoController.swift:4`
- `SuliJoyClipCommentCard` — `JOiySuizoy/SuliJoyMusiInDoController.swift:522`
- `SuliJoyPearlHarborViewController` — `JOiySuizoy/SuliJoyPearlHarborViewController.swift:3`
- `SuliJoyPearlPackCell` — `JOiySuizoy/SuliJoyPearlHarborViewController.swift:314`
- `SuliJoyReefMotionTideController` — `JOiySuizoy/SuliJoyReefMotionTideController.swift:5`
- `SuliJoyShellPearlStore` — `JOiySuizoy/SuliJoyShellPearlStore.swift:3`
- `SuliJoyShellPearlStorecontroller` — `JOiySuizoy/SuliJoyShellPearlStorecontroller.swift:3`
- `SuliJoyShellelasticWaistController` — `JOiySuizoy/SuliJoyShellelasticWaistController.swift:3`
- `SuliJoyShellCoveActionRow` — `JOiySuizoy/SuliJoyShellelasticWaistController.swift:391`
- `SuliJoyShellCoveHairline` — `JOiySuizoy/SuliJoyShellelasticWaistController.swift:449`
- `SuliJoyReefMutedVisitorCoveController` — `JOiySuizoy/SuliJoyShellelasticWaistController.swift:462`
- `SuliJoyWaveResonanceHarbor` — `JOiySuizoy/SuliJoyShoortController.swift:4`
- `SuliJoyShoortController` — `JOiySuizoy/SuliJoyShoortController.swift:91`
- `SuliJoyFeedFollowBadgeButton` — `JOiySuizoy/SuliJoyShoortController.swift:594`
- `SuliJoyWaveRhythmView` — `JOiySuizoy/SuliJoyShoortController.swift:629`
- `SuliJoyStylistCard` — `JOiySuizoy/SuliJoyShoortController.swift:649`
- `suliJoyCoastalDiary` — `JOiySuizoy/SuliJoyShoortController.swift:749`
- `SuliJoyShoreMomentReefController` — `JOiySuizoy/SuliJoyShoortController.swift:1041`
- `SuliJoyShoreReportRadioView` — `JOiySuizoy/SuliJoyShoreReportSheetController.swift:3`
- `SuliJoyShoreReportReasonRow` — `JOiySuizoy/SuliJoyShoreReportSheetController.swift:58`
- `SuliJoyShoreReportSheetController` — `JOiySuizoy/SuliJoyShoreReportSheetController.swift:111`
- `SuliJoyHarborGuardSheetController` — `JOiySuizoy/SuliJoyShoreReportSheetController.swift:512`
- `SuliJoyTideCoastalDetailController` — `JOiySuizoy/SuliJoyTideCoastalDetailController.swift:3`
- `SuliJoyCoastalSuggestionCard` — `JOiySuizoy/SuliJoyTideCoastalDetailController.swift:609`
- `SuliJoyTideTalkSpaceViewController` — `JOiySuizoy/SuliJoyTideCoastalDetailController.swift:728`
- `SuliJoyLagoonSeatShellControl` — `JOiySuizoy/SuliJoyTideCoastalDetailController.swift:1266`
- `SuliJoyShoreNoteBubbleCell` — `JOiySuizoy/SuliJoyTideCoastalDetailController.swift:1353`
- `SuliJoyTideCurationDraftController` — `JOiySuizoy/SuliJoyTideCurationDraftController.swift:3`
- `SuliJoyTideCalendarCapsuleButton` — `JOiySuizoy/SuliJoyTideCurationDraftController.swift:581`
- `SuliJoyTideCoverSlotControl` — `JOiySuizoy/SuliJoyTideCurationDraftController.swift:620`
- `SuliJoymetallicThreadController` — `JOiySuizoy/SuliJoymetallicThreadController.swift:3`
- `SuliJoyReefLaunchEntryCard` — `JOiySuizoy/SuliJoymetallicThreadController.swift:146`
- `SuliJoypaperbagWaistController` — `JOiySuizoy/SuliJoypaperbagWaistController.swift:3`
- `SuliJoysequinedGlimmerController` — `JOiySuizoy/SuliJoysequinedGlimmerController.swift:4`
- `SuliJoyReefPhotoSlotControl` — `JOiySuizoy/SuliJoysequinedGlimmerController.swift:412`
- `SuliJoyWaveDraftReefOverlay` — `JOiySuizoy/SuliJoysequinedGlimmerController.swift:480`
- `suliJoyShorelineAesthetic` — `JOiySuizoy/suliJoyShorelineAesthetic.swift:3`
- `suliJoyShorelineEnsemble` — `JOiySuizoy/suliJoyShorelineEnsemble.swift:3`
- `suliJoyShorelineIntent` — `JOiySuizoy/suliJoyShorelineIntent.swift:4`
- `SuliJoyShortsClipCell` — `JOiySuizoy/suliJoyShorelineIntent.swift:370`
- `suliJoySunsetBoardController` — `JOiySuizoy/suliJoySunsetBoardController.swift:3`
