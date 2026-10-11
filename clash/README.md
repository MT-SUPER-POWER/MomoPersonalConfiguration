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
3. **黄金地区自动测速与选优**：
   - 将 AI 测速池收敛至官方支持最全、基础设施最稳定的 **美 / 日 / 英 / 欧** 节点。
   - 优先通过日本（东京/大阪，30~50ms 超低延迟）或美国节点提供极速且稳定的 AI 访问。
4. **订阅更新永不失效**：
   - 基于 Clash Verge Rev 扩展脚本规范编写，机场订阅无论是定时自动更新还是手动拉取，脚本都会动态重新运算注入，永不被覆盖。

---

## 策略组架构

| 策略组名称 | 类型 | 说明 |
| --- | --- | --- |
| **`🤖 AI-自动优选(美/日/英)`** | `url-test` | 仅在美、日、英、德等合规且无限制的黄金节点中自动测速选优 |
| **`🤖 AI 平台`** | `select` | 主控策略组，默认走自动优选；同时提供纯净节点供随时手动指定 |

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
