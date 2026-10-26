# HairwrapKnotDrape：H5 双层压缩加密与运行时加载

## 结果与范围

- 原 `JOiySuizoy/JOiySuizoy/RoomShellH5/` 的 237 个文件已完整移动到 `room-shell-h5/HairwrapKnotDrape/`，不是删除；逐文件与 Git 原版本对比，字节完全一致。
- App 中只携带 `JOiySuizoy/JOiySuizoy/HairwrapKnotDrape/CoastalWeave.dat`，没有明文 HTML、JS、字体和旧目录。
- 原文件合计 11,035,762 bytes，双层压缩加密包为 6,633,190 bytes。
- 使用 48 位随机字符密钥材料，分别派生两个 AES-256-GCM 密钥。每层独立随机 nonce 和认证标签；密钥不写入日志或本报告。
- 链路为：原文件与逐文件 SHA-256 → JSON 归档 → zlib 压缩 → AES-GCM 第一层 → zlib 第二次压缩 → AES-GCM 第二层。不是仅改扩展名或 Base64 混淆。
- 新增 Swift 自主命名全部来自修改前的现有项目；声明清单检查没有新增词汇。继续使用已有字符串处理方式。

## 修改文件

- `JOiySuizoy/JOiySuizoy/HairwrapKnotDrape.swift`：扩展现有 `joinTide`，后台解密/解压、边界验证、路径检查、SHA-256 校验、缓存修复和原子提交。
- `JOiySuizoy/JOiySuizoy/SuliJoyReemShellBridge.swift`：使用新包和缓存目录，房间入场前后台准备资源；路由和登录参数保持不变。
- `JOiySuizoy/JOiySuizoy/sectionHeadlineGlyph.swift`：WebView 使用解包目录作为最小读取范围；原有桥接、权限、关闭及充值行为不变。
- `JOiySuizoy/JOiySuizoy/SuliJoyPalmGlyphWeaver.swift`：纯字符串解码函数与属性标记为 `nonisolated`，支持后台调用，不改解码算法和输出。
- `JOiySuizoy/JOiySuizoy.xcodeproj/project.pbxproj`：移除旧明文复制阶段，排除自动重复复制的资源；显式只复制加密包。
- `tools/copy-hairwrap.sh`：构建时复制密文；仅将旧构建产物内残留的明文目录/重复包移至构建临时目录，未删除源文件或用户数据。
- `room-shell-h5/scripts/pack-hairwrap.mjs`、`room-shell-h5/package.json`：增加可重复打包和只读验证命令；相同内容不反复生成不同包，避免无意义缓存版本变化。
- `tools/VerifyHairwrap.swift`、`tools/verify-hairwrap.mjs`、`tools/HairwrapWebCheck.swift`：离线测试工具，不进入 App target。

## 受保护的边界清单

### API

H5 文件未重建、未修改，现有域名、请求头、接口映射、消息和支付调用均不变。验证工具屏蔽 HTTP/HTTPS；未调用真实登录、发言、充值或直播接口。

### 页面和路由

`#/live/{roomId}` 与 `#/voice/{roomId}` 的房间号、token、userId、appVersion、deviceNo、locale 参数保持不变。仅入口 `index.html` 的文件位置改为已校验缓存；TabBar、SafeArea、返回和充值路由不变。

### 持久化

原生登录态、Token、UserDefaults、Keychain、账号资料均未修改。派生资源位于 `Library/Caches/HairwrapKnotDrape/<加密包SHA256>/`，不备份。每次入房后台校验，缓存缺失或损坏会重建；同版本内由锁保护并发访问。解压至 UUID 临时目录，全部校验后再提交。旧版本缓存不主动删除，由系统按缓存策略回收；解压失败不会退回不匹配版本。

### JS Bridge

保留协议版本 1，H5 → Native 的 `room.ready`、`room.close`、`recharge.open`，以及 Native → H5 的 `recharge.succeeded`。既有 WKScriptMessageHandler 注册、媒体权限和会话传递逻辑未改。没有加入下载或远程更新可执行逻辑的能力。

## 验证

- Node 和实际 Swift 解码器均通过两层往返验证；237 个原始文件逐字节相同。
- 覆盖缓存命中、损坏文件重建、缺失文件重建、符号链接修复、并发加载、密文篡改、路径越界、解压尺寸上限和缺失包。
- iOS 26.5 独立测试 App：相同有效 voice 路由下，原目录和解包目录均成功完成 WKWebView 离线加载；背景、字体、文案和加载状态一致，详见 `webview-offline-result.json`。测试所有 HTTP/HTTPS 请求被屏蔽，所以展示的是相同网络不可用状态，不等于真实直播全流程通过。
- 两个路径共享同一独立 WKWebsiteDataStore，先由原版写入 localStorage/IndexedDB，再由解包版读取，虚拟数据连续性验证通过；未读取或修改业务 App 存储。
- Debug、Release 通用模拟器构建及真机架构 Release 编译均通过；真机架构构建未签名、未安装到实体设备、未提交 Apple。
- 三个构建产物都仅有一份 `HairwrapKnotDrape/CoastalWeave.dat`，没有旧目录、明文 HTML/JS；包内容与源加密包一致。
- 新 Swift 自主名称集合相对修改前为空增量；没有新增运行时打印。
- 原先用户已暂存的 `SuliJoyGuestActionButton.swift` 文件重命名及工作区 UI 状态未处理。

日志：`/private/tmp/sulijoy-hairwrap-debug.log`、`/private/tmp/sulijoy-hairwrap-release.log`、`/private/tmp/sulijoy-hairwrap-device.log`。

独立测试 App 仅用于本任务的 iPhone 17 测试模拟器，不触碰 iPhone 17 Pro 或业务 App 登录资料；测试完成后移除，测试源码保留、可重建。

## 更新与维护

在项目根目录执行：

```sh
node room-shell-h5/scripts/pack-hairwrap.mjs
node room-shell-h5/scripts/pack-hairwrap.mjs --verify
node tools/verify-hairwrap.mjs
```

默认输入为 `room-shell-h5/HairwrapKnotDrape`。需要封装新的 H5 构建产物时，使用 `node room-shell-h5/scripts/pack-hairwrap.mjs --input dist`，并将该输入版本作为之后验证基线。原生 Xcode 编译不依赖 Node 或明文文件存在，只依赖已生成并纳入版本管理的加密包。

已有的 H5 全量构建阻塞：`generate-opi-registry.mjs` 仍引用已被重命名的 `SuliJoyOpiRegistry.swift`，只读验证确认报 ENOENT。此次未修改现有接口映射以免改变业务结果；独立打包命令不受影响。`npm run build` 虽接入打包后置步骤，但其原有接口生成阻塞需另行修正。

## 剩余回归和安全边界

需在正式测试环境/实体设备回归真实入房、语音视频、麦克风/摄像头授权、充值往返、退房和 WebContent 崩溃重载；还需进行大小屏和键盘交互回归，本次未改这些 UI 约束。

加密包和客户端密钥材料均随 App 分发，运行时必须产生可读缓存，因此不能抵抗有针对性的反编译、密钥提取或运行时抓取。不得在包内存放服务端秘密或长期用户凭证。此机制用于静态资源保护，不用于隐藏实际功能或规避 App Store 审核；编译通过不代表 Apple 审核保证通过。
