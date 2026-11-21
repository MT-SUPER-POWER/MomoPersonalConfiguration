# Clash Verge Rev 扩展脚本配置 (AI 智能分流与区域优选)

本目录归档用于 **Clash Verge Rev** 的订阅扩展脚本 (`script.js`)，实现日常流量与 AI 开发环境（ChatGPT、Claude、Google Gemini、Antigravity 反重力等）的全自动智能分流。

---

## 核心设计与解决痛点

1. **告别手动频繁切换**：
   - 传统使用中，平时网页浏览喜欢用低延迟的香港节点，但切换到 ChatGPT / Gemini / Claude 时会直接报错，需要频繁在客户端手动选节点。
   - 本脚本通过 **置顶分流规则** 与 **专属策略组**，让 AI 流量全自动重定向至可用地区，普通流量依然保留原有默认节点。
2. **严格过滤受限与风控区域**：
   - **官方不支持区域**：严格过滤香港（HK）、澳门（MO）、俄罗斯（RU）等地区。
   - **开发工具/API 高风险区域**：台湾（TW）与新加坡（SG）的机房广播 IP 经常触发 Google Gemini API 与 Antigravity（反重力）的 `403 Forbidden` 或 `User location is not supported for the API use`，本脚本一并将其从 AI 优选池中剔除。
3. **自动测速与选优**：优先从 **美 / 日 / 英 / 欧** 等地区挑选测速节点。订阅缺少优选地区时，测速池使用其余通过筛选的节点。
4. **AI 专用出口失效时断网**：测速尚未完成、测速池为空或所有候选均测速失败时，自动优选走 `REJECT`。手动选中的专用节点连接失败时，请求也会失败。专用节点不支持 UDP 时，紧随其后的同条件 `REJECT` 会拦截该请求。
5. **DNS Fake-IP 过滤保护**：自动补充 `fake-ip-filter`，防止 Atlassian（Jira、Bitbucket 等）及系统/网络连通性检测服务被 Fake-IP 拦截，确保 CLI/API 开发者工具与客户端正常解析真实 IP。

---

## 策略组架构

| 策略组名称 | 类型 | 说明 |
| --- | --- | --- |
| **`🤖 AI-自动优选(美/日/英)`** | `url-test` | 在筛选后的节点中测速选优，无可用候选时走 `REJECT` |
| **`🤖 AI 平台`** | `select` | 默认走 AI 自动优选，可手动选择专用节点或 `REJECT` |

断网保护适用于 Clash Verge Rev **规则模式**下，由当前脚本覆盖且经过 Mihomo 的连接。普通流量继续使用订阅原有分流规则。

### 覆盖的 AI 规则集

- **Google Gemini & Antigravity (反重力)**：`gemini.google.com`、`generativelanguage.googleapis.com`、`aistudio.google.com`、`makersuite.google.com`、`deepmind`、`GEOSITE,google-gemini` 等
- **OpenAI / ChatGPT**：`chatgpt.com`、`openai.com`、`oaistatic.com`、`oaiusercontent.com`、`GEOSITE,openai` 等
- **Anthropic / Claude**：`claude.ai`、`anthropic.com`、`claudeusercontent.com`、`GEOSITE,anthropic` 等
- **其他常用服务**：Perplexity、Microsoft Copilot、Mistral 等

---

## 本机生效路径与同步方式

| 仓库文件 | 系统 | 本机生效位置 | 说明 |
| --- | --- | --- | --- |
| `clash/script.js` | Windows | `%APPDATA%\io.github.clash-verge-rev.clash-verge-rev\profiles\Script.js` | 全局扩展脚本 |
| `clash/script.js` | macOS | `~/Library/Application Support/io.github.clash-verge-rev.clash-verge-rev/profiles/Script.js` | 全局扩展脚本 |
| `clash/script.js` | 全平台 | 订阅配置中的 Script | 单个订阅绑定的扩展脚本 |

### 如何在 Clash Verge Rev 中手动应用/更新？

1. **GUI 方式**：
   - 打开 Clash Verge Rev -> 点击左侧 **「订阅」**（Profiles）；
   - 右键点击正在使用的订阅卡片 -> 选择 **「脚本配置」**（Script）；
   - 将 `clash/script.js` 中的代码粘贴进去并保存；
   - 回到订阅列表，右键点击卡片选择 **「刷新」**（或重新点选订阅一次）即刻生效。
2. **查看生效效果**：
   - 点击左侧 **「代理」**（Proxies），顶部出现 **`🤖 AI 平台`** 和 **`🤖 AI-自动优选(美/日/英)`** 即代表成功。
