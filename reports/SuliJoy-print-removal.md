# 删除 App 自有打印

## 修改文件

- `JOiySuizoy/JOiySuizoy/SuliJoyLagoonRemoteClient.swift`：移除五处 DEBUG 日志块，包括请求头、请求体、上传信息、响应、解码异常打印，以及仅用于这些打印的临时计算。不改变请求、回调、错误传递。
- `room-shell-h5/src/core/debug/mobile-console.ts`：移除诊断初始化失败打印。
- `room-shell-h5/src/features/rooms/live-pk-session.ts`：移除两处 PK 警告，保留失败状态和恢复逻辑。
- `room-shell-h5/src/features/party/remote-party-repository.ts`：移除七处房间通信日志，保留重试、心跳、连接恢复与媒体发布降级处理；去掉日志专用未使用异常参数。
- `room-shell-h5/scripts/generate-opi-registry.mjs`、`tools/verify-opi-registry.mjs`：密钥匹配不再依赖被用户改过的固定变量名，保留当前 Swift 命名和密钥。
- `JOiySuizoy/JOiySuizoy/RoomShellH5/index.html`、`webapp-manifest.json`：同步重新构建的 H5 产物。
- `JOiySuizoy/JOiySuizoy/SuliJoyOpiRegistry.json`：正常构建时随机 nonce 重新生成的密文，解密内容哈希未变。

## 验证及范围

- 原生 Swift 与 H5 自有源码中的 print/debugPrint/NSLog/os_log/dump/console 输出调用扫描无剩余。
- H5 三个修改文件 ESLint、完整类型检查、构建和产物验证通过。
- iOS Debug 通用模拟器构建通过。
- 接口映射解密 SHA-256 仍为 `dc842bffd3576d86d8890d30bf42c5921f8d13837c0a036a3e40dbffa96a4624`。
- 第三方 SDK 源码和内部日志、系统输出，以及仅用于开发的 CLI 构建/验证工具输出未改动。不使用全局 stdout/stderr 重定向。
- 未修改登录注册逻辑、UI 布局、安全区域、键盘逻辑和本地用户数据；未进行全页面业务回归。

手动验证：启动 App，使用测试账号检查登录、列表和房间加载，确认 Xcode 控制台不再出现 App 自有请求/响应打印；检查网络失败时仍有正常 UI 提示和恢复行为。
