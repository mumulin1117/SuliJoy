# 原始项目命名提取清单

读取来源：`/Users/linqian/Documents/SuliJoy/JOiySuizoy/JOiySuizoy`

使用 Swift 编译器 `-frontend -dump-parse` 解析项目源文件；不修改原工程，不包含 Pods、构建产物或第三方库声明。
所有拼写及大小写均保留原样。按源文件中的声明提取，不根据文件名推测类名。

Swift 文件：48；类声明：107；声明记录：12392；去重名称：2772；资源名称：137。

## 分类统计

- argument_label: 1078
- binding_pattern: 3828
- class: 107
- deinitializer: 11
- enum: 175
- enum_case: 505
- extension: 18
- function: 1273
- initializer: 250
- local_variable: 1433
- parameter: 1657
- property: 1899
- struct: 157
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

- `AppDelegate` — `AppDelegate.swift:11`
- `SuliJoyAgentKeyBarController` — `SuliJoyAgentKeyBarController.swift:3`
- `dateTimeStack` — `SuliJoyChallengeShareLookController.swift:3`
- `SuliJoyCoveMockService` — `SuliJoyCoveMockService.swift:3`
- `SuliJoyForinController` — `SuliJoyForinController.swift:3`
- `shoreBriefMeter` — `SuliJoyForinController.swift:366`
- `SuliJoyGuestMomentPreviewCard` — `SuliJoyForinController.swift:515`
- `SuliJoyIslandGuestProfileViewController` — `SuliJoyIslandVisitorProfileViewController.swift:25`
- `shorelineOptionRail` — `SuliJoyIslandVisitorProfileViewController.swift:514`
- `reefLaunchEntries` — `SuliJoyIslandVisitorProfileViewController.swift:567`
- `SuliJoyGuestFollowButton` — `SuliJoyIslandVisitorProfileViewController.swift:605`
- `SuliJoyGuestSegmentButton` — `SuliJoyIslandVisitorProfileViewController.swift:654`
- `SuliJoyGuestMetricView` — `SuliJoyIslandVisitorProfileViewController.swift:699`
- `SuliJoyGuestPreviewControl` — `SuliJoyIslandVisitorProfileViewController.swift:750`
- `sizeInput` — `SuliJoyIslandVisitorProfileViewController.swift:769`
- `SuliJoyGuestClipPreviewCard` — `SuliJoyIslandVisitorProfileViewController.swift:821`
- `SuliJoyGuestActivityPreviewCard` — `SuliJoyIslandVisitorProfileViewController.swift:874`
- `SuliJoyIslanddeckView` — `SuliJoyIslanddeckView.swift:8`
- `SuliJoyGradientButton` — `SuliJoyIslanddeckView.swift:71`
- `SuliJoyAuthTextField` — `SuliJoyIslanddeckView.swift:146`
- `SuliJoyLagoonConsentRibbon` — `SuliJoyIslanddeckView.swift:176`
- `SuliJoyReefEntryCanvasController` — `SuliJoyIslanddeckView.swift:261`
- `SuliJoyLagoonGateService` — `SuliJoyJokerAuthUserService.swift:3`
- `makeLagoonBackReefControl` — `SuliJoyLagoonBoardControllers.swift:16`
- `resortThemeControls` — `SuliJoyLagoonBoardControllers.swift:118`
- `subreefHeadline` — `SuliJoyLagoonBoardControllers.swift:222`
- `gatherReefLaunchCrown` — `SuliJoyLagoonBoardControllers.swift:496`
- `markShellSide` — `SuliJoyLagoonBoardControllers.swift:813`
- `reefPass` — `SuliJoyLagoonBoardControllers.swift:942`
- `validateSignupDraft` — `SuliJoyLagoonBoardControllers.swift:1086`
- `discoverDrop` — `SuliJoyLagoonBoardControllers.swift:1149`
- `chosenShoreTime` — `SuliJoyLagoonBoardControllers.swift:1332`
- `titleInput` — `SuliJoyLagoonBoardControllers.swift:1345`
- `SuliJoyLagoonConsentScrollController` — `SuliJoyLagoonConsentScrollController.swift:3`
- `SuliJoyLagoonHarborService` — `SuliJoyLagoonHarborService.swift:19`
- `startResonanceEngine` — `SuliJoyLagoonImageShelf.swift:125`
- `SuliJoyLagoonLettersViewController` — `SuliJoyLagoonLettersViewController.swift:3`
- `isCover` — `SuliJoyLagoonLettersViewController.swift:111`
- `subtitleGlyph` — `SuliJoyLagoonLettersViewController.swift:362`
- `shorelineStyleControls` — `SuliJoyLagoonLettersViewController.swift:409`
- `onCoverSlotRemove` — `SuliJoyLagoonLettersViewController.swift:483`
- `SuliJoyLagoonMirrorController` — `SuliJoyLagoonMirrorController.swift:3`
- `SuliJoyLagoonProfileCoveController` — `SuliJoyLagoonProfileCoveController.swift:3`
- `suliJoyPalmRankingaccount` — `SuliJoyLagoonProfileRemoteService.swift:196`
- `cardSideInset` — `SuliJoyLagoonProfileRemoteService.swift:1620`
- `reefMarkGlyph` — `SuliJoyLagoonRemoteClient.swift:1449`
- `SuliJoyLagoonScrollTextController` — `SuliJoyLagoonScrollTextController.swift:8`
- `SuliJoyTideSessionVault` — `SuliJoyLagoonSessionStore.swift:3`
- `SuliJoyIslandAccountStore` — `SuliJoyLagoonSessionStore.swift:90`
- `SuliJoyLocalProfileStore` — `SuliJoyLagoonSessionStore.swift:135`
- `SuliJoyCoveCapsuleIconButton` — `SuliJoyMainUI.swift:69`
- `SuliJoyShellGemPillButton` — `SuliJoyMainUI.swift:107`
- `SuliJoyGradientCapsuleView` — `SuliJoyMainUI.swift:158`
- `SuliJoyTropicCanvasController` — `SuliJoyMainUI.swift:186`
- `SuliJoySimplePlaceholderViewController` — `SuliJoyMainUI.swift:517`
- `SuliJoyMusiInDoController` — `SuliJoyMusiInDoController.swift:4`
- `SuliJoyClipCommentCard` — `SuliJoyMusiInDoController.swift:588`
- `SuliJoyPearlHarborViewController` — `SuliJoyPearlHarborViewController.swift:3`
- `SuliJoyPearlPackCell` — `SuliJoyPearlHarborViewController.swift:325`
- `SuliJoyReefMotionTideController` — `SuliJoyReefMotionTideController.swift:5`
- `setShoreValue` — `SuliJoyRoomShellWebController.swift:4`
- `sectionHeadlineGlyph` — `SuliJoyRoomShellWebController.swift:150`
- `coralMood` — `SuliJoyShareBroadcastDraftControllers.swift:5`
- `typeWrap` — `SuliJoyShareBroadcastDraftControllers.swift:450`
- `anchorCoverPhotoSlots` — `SuliJoyShareBroadcastDraftControllers.swift:1048`
- `SuliJoyShellPearlStore` — `SuliJoyShellPearlStore.swift:3`
- `SuliJoyShellPearlStorecontroller` — `SuliJoyShellPearlStorecontroller.swift:3`
- `SuliJoyShellelasticWaistController` — `SuliJoyShellelasticWaistController.swift:3`
- `SuliJoyShellCoveActionRow` — `SuliJoyShellelasticWaistController.swift:398`
- `SuliJoyShellCoveHairline` — `SuliJoyShellelasticWaistController.swift:456`
- `SuliJoyReefMutedVisitorCoveController` — `SuliJoyShellelasticWaistController.swift:469`
- `SuliJoyWaveResonanceHarbor` — `SuliJoyShoortController.swift:4`
- `SuliJoyShoortController` — `SuliJoyShoortController.swift:319`
- `SuliJoyFeedFollowBadgeButton` — `SuliJoyShoortController.swift:906`
- `SuliJoyWaveRhythmView` — `SuliJoyShoortController.swift:941`
- `SuliJoyStylistCard` — `SuliJoyShoortController.swift:961`
- `suliJoyCoastalDiary` — `SuliJoyShoortController.swift:1073`
- `SuliJoyShoreMomentReefController` — `SuliJoyShoortController.swift:1373`
- `SuliJoyShoreReportRadioView` — `SuliJoyShoreReportSheetController.swift:3`
- `SuliJoyShoreReportReasonRow` — `SuliJoyShoreReportSheetController.swift:58`
- `SuliJoyShoreReportSheetController` — `SuliJoyShoreReportSheetController.swift:111`
- `SuliJoyHarborGuardSheetController` — `SuliJoyShoreReportSheetController.swift:521`
- `shoreTimeCapsule` — `SuliJoyShoreReportSheetController.swift:631`
- `toggleAuthorFollow` — `SuliJoyShoreRoomLoadingView.swift:3`
- `SuliJoyGuestActionButton` — `SuliJoyShoreRoomLoadingView.swift:191`
- `lagoonLetterCanvas` — `SuliJoyShoreSkeleton.swift:3`
- `makeCurationChoiceRail` — `SuliJoyShoreSkeleton.swift:47`
- `coverPreviewImages` — `SuliJoyShoreSkeleton.swift:99`
- `LagoonLetterMeasure` — `SuliJoyShoreSkeleton.swift:153`
- `reefLettersButton` — `SuliJoyShoreSkeleton.swift:194`
- `SuliJoyTideCardCell` — `SuliJoyTideCardCell.swift:3`
- `SuliJoyTideCoastalDetailController` — `SuliJoyTideCoastalDetailController.swift:3`
- `SuliJoyCoastalSuggestionCard` — `SuliJoyTideCoastalDetailController.swift:582`
- `SuliJoyTideTalkSpaceViewController` — `SuliJoyTideCoastalDetailController.swift:678`
- `SuliJoyLagoonSeatShellControl` — `SuliJoyTideCoastalDetailController.swift:1206`
- `SuliJoyShoreNoteBubbleCell` — `SuliJoyTideCoastalDetailController.swift:1293`
- `SuliJoyTideCurationDraftController` — `SuliJoyTideCurationDraftController.swift:3`
- `ReefLaunchCrown` — `SuliJoyTideCurationDraftController.swift:426`
- `SuliJoymetallicThreadController` — `SuliJoymetallicThreadController.swift:3`
- `SuliJoypaperbagWaistController` — `SuliJoypaperbagWaistController.swift:3`
- `SuliJoysequinedGlimmerController` — `SuliJoysequinedGlimmerController.swift:4`
- `SuliJoyReefPhotoSlotControl` — `SuliJoysequinedGlimmerController.swift:412`
- `SuliJoyWaveDraftReefOverlay` — `SuliJoysequinedGlimmerController.swift:480`
- `suliJoyShorelineAesthetic` — `suliJoyShorelineAesthetic.swift:3`
- `suliJoyShorelineEnsemble` — `suliJoyShorelineEnsemble.swift:3`
- `suliJoyShorelineIntent` — `suliJoyShorelineIntent.swift:4`
- `SuliJoyShortsClipCell` — `suliJoyShorelineIntent.swift:375`
