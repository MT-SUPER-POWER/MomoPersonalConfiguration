/**
 * Clash Verge Rev 订阅扩展脚本 (Script.js)
 *
 * 功能：
 * 1. 自动分流 AI 与开发者服务（Google Gemini / 反重力 Antigravity / OpenAI ChatGPT / Anthropic Claude / Perplexity / Copilot 等）
 * 2. 严格剔除受限地区（香港 HK、澳门 MO、台湾 TW、新加坡 SG、大陆 CN、俄罗斯 RU、伊朗、朝鲜等易被风控或报 403 / Location unsupported 的区域）
 * 3. 自动筛选并测速「美 / 日 / 英 / 欧」黄金优质节点，时刻保证低延迟与 100% 可用性
 * 4. 无论机场订阅如何自动更新、节点名称如何改变，均自动动态匹配，无需手动切换
 */

function main(config, profileName) {
  // 1. 判断是否为机场提示、公告、测试等无效节点
  function isInvalidProxy(name) {
    if (!name) return true;
    return /(请|提示|失效|复制|导入|官网|网站|过期|到期|剩余|流量|订阅|套餐|通知|公告|维护|重置|群|返利|防失联|教程|客户端|只显示|0\.1x)/i.test(
      name,
    );
  }

  // 2. 判断受限及容易报 403 / Location unsupported 的区域
  function isRestrictedOrProblematic(name) {
    // 香港 (Hong Kong)、澳门 (Macau) - 官方不支持
    if (/(香港|HK|Hong\s*Kong|🇭🇰|澳门|MO|Macau|Macao|🇲🇴)/i.test(name))
      return true;
    // 台湾 (Taiwan) & 新加坡 (Singapore) - 反重力(Antigravity)与Gemini API常报未支持地区/403
    if (
      /(台湾|TW|Tai\s*wan|🇹🇼|台北|新竹|新加坡|SG|Singapore|🇸🇬|狮城)/i.test(name)
    )
      return true;
    // 俄罗斯、白俄罗斯 (受制裁地区)
    if (/(俄罗斯|俄国|RU|Russia|🇷🇺|白俄罗斯|BY|Belarus|🇧🇾)/i.test(name))
      return true;
    // 伊朗、朝鲜、古巴、叙利亚、委内瑞拉、缅甸 (受国际禁运与制裁地区)
    if (
      /(伊朗|IR|Iran|🇮🇷|朝鲜|北朝鲜|KP|North\s*Korea|🇰🇵|古巴|CU|Cuba|🇨🇺|叙利亚|SY|Syria|🇸🇾|委内瑞拉|VE|Venezuela|🇻🇪|缅甸|MM|Myanmar|🇲🇲)/i.test(
        name,
      )
    )
      return true;
    // 中国大陆/国内
    if (/(中国|国内|内地|China|CN)/i.test(name)) return true;

    return false;
  }

  // 3. 判断是否为 AI 最稳定的黄金地区（美、日、英、加、德等欧美日主流节点）
  function isPrimeAiRegion(name) {
    return /(日本|东京|大阪|JP|Japan|🇯🇵|美国|美|US|USA|United\s*States|🇺🇸|英国|伦敦|UK|GB|Great\s*Britain|🇬🇧|德国|DE|Germany|🇩🇪|加拿大|CA|Canada|🇨🇦|法国|FR|France|🇫🇷)/i.test(
      name,
    );
  }

  // 获取所有真实代理节点
  const allProxies = (config.proxies || [])
    .map((p) => p.name)
    .filter((name) => !isInvalidProxy(name));

  // 筛选出完全排除问题区域的节点
  const cleanProxies = allProxies.filter(
    (name) => !isRestrictedOrProblematic(name),
  );

  // 优选池：美/日/英/加/德等黄金节点
  let primeProxies = cleanProxies.filter((name) => isPrimeAiRegion(name));
  if (primeProxies.length === 0) {
    primeProxies = cleanProxies.length > 0 ? cleanProxies : allProxies;
  }

  // 4. 构建策略组
  // (1) 黄金自动优选组（仅在美/日/英/欧等无限制地区测速，彻底解决反重力和Gemini报地区受限）
  const aiAutoPrime = {
    name: "🤖 AI-自动优选(美/日/英)",
    type: "url-test",
    url: "https://www.gstatic.com/generate_204",
    interval: 300,
    tolerance: 50,
    proxies: primeProxies,
  };

  // (2) AI 主控策略组：默认使用黄金自动优选，同时提供所有干净节点供随时手动切换
  const aiSelectGroup = {
    name: "🤖 AI 平台",
    type: "select",
    proxies: [
      "🤖 AI-自动优选(美/日/英)",
      ...primeProxies,
      ...cleanProxies.filter((p) => !primeProxies.includes(p)),
      "DIRECT",
    ],
  };

  if (!config["proxy-groups"]) {
    config["proxy-groups"] = [];
  }

  // 移除旧策略组避免重复
  config["proxy-groups"] = config["proxy-groups"].filter(
    (g) =>
      g.name !== "🤖 AI 平台" &&
      g.name !== "🤖 AI-自动优选(非HK)" &&
      g.name !== "🤖 AI-自动优选(支持地区)" &&
      g.name !== "🤖 AI-自动优选(美/日/英)",
  );

  // 插入到最顶端
  config["proxy-groups"].unshift(aiAutoPrime);
  config["proxy-groups"].unshift(aiSelectGroup);

  // 5. 注入 AI 分流规则（置顶优先命中）
  const aiRules = [
    // --- Google Gemini & Antigravity (反重力) & AI Studio & DeepMind ---
    "DOMAIN-SUFFIX,gemini.google.com,🤖 AI 平台",
    "DOMAIN-SUFFIX,generativelanguage.googleapis.com,🤖 AI 平台",
    "DOMAIN-SUFFIX,proactivebackend-pa.googleapis.com,🤖 AI 平台",
    "DOMAIN-SUFFIX,alkalimakersuite-pa.googleapis.com,🤖 AI 平台",
    "DOMAIN-SUFFIX,aistudio.google.com,🤖 AI 平台",
    "DOMAIN-SUFFIX,makersuite.google.com,🤖 AI 平台",
    "DOMAIN-SUFFIX,deepmind.google,🤖 AI 平台",
    "DOMAIN-SUFFIX,deepmind.com,🤖 AI 平台",
    "DOMAIN-KEYWORD,generativelanguage,🤖 AI 平台",
    "DOMAIN-KEYWORD,makersuite,🤖 AI 平台",

    // --- OpenAI / ChatGPT ---
    "DOMAIN-SUFFIX,openai.com,🤖 AI 平台",
    "DOMAIN-SUFFIX,chatgpt.com,🤖 AI 平台",
    "DOMAIN-SUFFIX,oaistatic.com,🤖 AI 平台",
    "DOMAIN-SUFFIX,oaiusercontent.com,🤖 AI 平台",
    "DOMAIN-KEYWORD,openai,🤖 AI 平台",
    "DOMAIN-KEYWORD,chatgpt,🤖 AI 平台",

    // --- Anthropic / Claude ---
    "DOMAIN-SUFFIX,anthropic.com,🤖 AI 平台",
    "DOMAIN-SUFFIX,claude.ai,🤖 AI 平台",
    "DOMAIN-SUFFIX,claudeusercontent.com,🤖 AI 平台",
    "DOMAIN-KEYWORD,anthropic,🤖 AI 平台",
    "DOMAIN-KEYWORD,claude,🤖 AI 平台",

    // --- 其它常用 AI 服务 (Perplexity, Copilot, Mistral 等) ---
    "DOMAIN-SUFFIX,perplexity.ai,🤖 AI 平台",
    "DOMAIN-SUFFIX,copilot.microsoft.com,🤖 AI 平台",
    "DOMAIN-SUFFIX,mistral.ai,🤖 AI 平台",

    // --- Mihomo 核心 Geosite 全量规则 ---
    "GEOSITE,openai,🤖 AI 平台",
    "GEOSITE,anthropic,🤖 AI 平台",
    "GEOSITE,google-gemini,🤖 AI 平台",
  ];

  if (!config.rules) {
    config.rules = [];
  }

  config.rules = config.rules.filter((r) => !r.includes("🤖 AI 平台"));
  config.rules.unshift(...aiRules);

  return config;
}
