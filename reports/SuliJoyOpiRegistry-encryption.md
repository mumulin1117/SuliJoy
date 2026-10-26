# 接口映射资源加密

## 修改文件

- `JOiySuizoy/JOiySuizoy/SuliJoyOpiRegistry.json`：原明文映射替换为 `version` 与 `payload` 两个字段。payload 为 AES-256-GCM 的 nonce + ciphertext + tag，经 Base64 保存；Base64 本身不是加密。
- `JOiySuizoy/JOiySuizoy/SuliJoyOpiRegistry.swift`：使用系统 CryptoKit 认证解密，在内存解析 JSON，仍静态缓存一次。无明文文件回落，不写入沙盒，不记录密钥或解密内容。资源异常保持原有空字典回退行为。
- `room-shell-h5/scripts/generate-opi-registry.mjs`：生成加密 iOS 资源，随机 12 字节 nonce，读取现有 Swift 密钥；不再覆盖维护中的 Swift 实现。`--verify` 只验证、不写文件。H5 TypeScript 输出逻辑不变。
- `tools/VerifyOpiRegistry.swift`、`tools/verify-opi-registry.mjs`：验证实际 Swift 加载器与递归字段映射、密文篡改及缺失资源处理。

## 内容不变验证

- 原始文件 SHA-256：`dc842bffd3576d86d8890d30bf42c5921f8d13837c0a036a3e40dbffa96a4624`。
- 解密后字节 SHA-256 与上述完全相同。
- 实际 Swift 加载器验证：279 条路径、7438 项请求/响应字段递归映射、所有请求头和外层响应字段均通过。
- 认证标签篡改、文件缺失时不会被当作明文读取，沿用原有空映射回退。
- Debug、Release 构建均通过；两种产物内 JSON 均与加密源文件相同，不含明文路径列表。
- 未发送真实网络请求，不改变登录注册业务规则、UI、安全区域、键盘或本地数据。

## 使用

更新接口方案后，仍运行：`node room-shell-h5/scripts/generate-opi-registry.mjs`。

校验内容：`node room-shell-h5/scripts/generate-opi-registry.mjs --verify`。

验证 Swift 加载及异常分支：`node tools/verify-opi-registry.mjs`。测试明文仅写入系统临时测试目录，不进入 App 包。

## 安全边界

这是客户端静态资源保护，不是服务器秘密管理。App 必须携带解密材料，因此无法保证抵抗反编译、运行时抓取或有针对性的密钥提取。不得在此文件存放服务端私钥、长期凭证或用户 Token；服务端鉴权仍不可省略。

原始方案仍在 H5 开发配置中用于生成，未删除源配置或重写 H5 网络层。本次处理范围是 iOS 的该映射文件及其加载/生成链路，不代表整个 App 或 H5 不含任何可观察的接口信息。
