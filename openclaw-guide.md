> 引言：全文概要

OpenClaw 是 2026 年初爆火的开源个人 AI 助手项目（GitHub 两周突破 15 万 Star），它能在你自己的设备上运行，并接入 WhatsApp、Telegram、飞书、钉钉等十余种消息平台，充当 7×24 小时的全能 AI Agent。本文综合 20 余篇中英文技术资料，从部署、成本、安全三个维度对 OpenClaw 做了系统性梳理。以下是核心要点速览：

![](https://pic4.zhimg.com/v2-d9148c8bab9fed61049d80eb0a22fb17_1440w.jpg)

### 部署方式

本文覆盖了 **11 种部署路径**，可归纳为四大类：

* **本地一键安装**（`curl | bash` 或 `npm install -g openclaw`）：5 分钟上手，零基础设施成本，适合个人体验。
* **Mac Mini 本地部署**：以 800–2,000 美金的一次性硬件投入换取零云端费用——搭配 Ollama 运行本地模型后，日常使用成本可降至 **0 美金/月**。64GB 的 M4 Pro 可流畅运行 32B 参数模型。
* **云服务器 / 在线虚拟机**：阿里云（68 元/年起）、腾讯云（99 元/年起）均提供预装镜像一键部署；海外用户可选 DigitalOcean 1-Click、Railway、Render 等平台，最低免费起步。
* **Docker 容器化 / macOS VM（Lume）**：安全性与隔离性最优的方案，适合生产环境和需要 iMessage 集成的场景。

### Token 成本

OpenClaw 本身免费开源，**真正的成本来自 LLM API 调用**，且极易超支：

* 一个配置不当的”心跳”检查（每 30 分钟一次），一晚可烧掉 **18.75 美金**；有用户单日”待机”消耗 5000 万 Tokens（约 11 美金）。
* 成本六大来源：上下文累积（40–50%）、工具输出存储（20–30%）、系统提示词（10–15%）、多轮推理、模型选择、心跳任务。
* **优化组合可降低 77%**——通过会话重置、智能模型路由（Haiku/Gemini Flash 处理日常任务）、上下文窗口限制、本地模型回退等策略，实测从 150 美金/月降至 35 美金/月。

### 安全风险

安全是 OpenClaw 当前最大的短板，已发生多起严重事件：

* **CVE-2026-25253**（CVSS 8.8）：跨站 WebSocket 劫持导致一键远程代码执行，攻击者仅需受害者点击一个恶意链接，即可在毫秒内接管整个 Gateway 并在宿主机上执行任意命令。已在 v2026.1.29 修复。
* **923 个网关暴露**：Shodan 扫描发现近千个 OpenClaw 实例以零认证模式暴露在公网上，API Key 和对话记录均可被窃取。
* **恶意 VS Code 扩展**：名为 “ClawdBot Agent” 的扩展被植入远程访问木马。
* 此外还有第三方技能包钓鱼、Moltbook 数据库泄露、1600 万美金加密货币诈骗等事件。

### 官方安全方案

官方已推出多层防御措施：`auth: "none"` 模式被永久移除、Docker 沙箱隔离（只读根文件系统 + 无网络 + 非 root 运行）、`openclaw security audit --deep` 自动安全审计、DM 四级访问策略（pairing/allowlist/open/disabled）、多 Agent 分级权限控制，以及完整的事件响应流程。

> **一句话建议**：OpenClaw 功能强大但安全形势严峻——部署前请务必升级到最新版本、启用 Token 认证、开启 Docker 沙箱、在供应商侧设置硬性 API 支出限制，并定期运行安全审计。

---

## 目录

* [一、项目概述](https://zhuanlan.zhihu.com/p/2004187601276540473/edit#%E4%B8%80%E9%A1%B9%E7%9B%AE%E6%A6%82%E8%BF%B0)
* [二、系统架构](https://zhuanlan.zhihu.com/p/2004187601276540473/edit#%E4%BA%8C%E7%B3%BB%E7%BB%9F%E6%9E%B6%E6%9E%84)
* [三、快速部署方式总览](https://zhuanlan.zhihu.com/p/2004187601276540473/edit#%E4%B8%89%E5%BF%AB%E9%80%9F%E9%83%A8%E7%BD%B2%E6%96%B9%E5%BC%8F%E6%80%BB%E8%A7%88)
* [四、Mac Mini 本地部署详解](https://zhuanlan.zhihu.com/p/2004187601276540473/edit#%E5%9B%9Bmac-mini-%E6%9C%AC%E5%9C%B0%E9%83%A8%E7%BD%B2%E8%AF%A6%E8%A7%A3)
* [五、在线虚拟机/云服务器部署详解](https://zhuanlan.zhihu.com/p/2004187601276540473/edit#%E4%BA%94%E5%9C%A8%E7%BA%BF%E8%99%9A%E6%8B%9F%E6%9C%BA%E4%BA%91%E6%9C%8D%E5%8A%A1%E5%99%A8%E9%83%A8%E7%BD%B2%E8%AF%A6%E8%A7%A3)
* [六、Docker 容器化部署](https://zhuanlan.zhihu.com/p/2004187601276540473/edit#%E5%85%ADdocker-%E5%AE%B9%E5%99%A8%E5%8C%96%E9%83%A8%E7%BD%B2)
* [七、macOS 虚拟机部署（Lume）](https://zhuanlan.zhihu.com/p/2004187601276540473/edit#%E4%B8%83macos-%E8%99%9A%E6%8B%9F%E6%9C%BA%E9%83%A8%E7%BD%B2lume)
* [八、Token 成本深度分析](https://zhuanlan.zhihu.com/p/2004187601276540473/edit#%E5%85%ABtoken-%E6%88%90%E6%9C%AC%E6%B7%B1%E5%BA%A6%E5%88%86%E6%9E%90)
* [九、安全风险与漏洞全解析](https://zhuanlan.zhihu.com/p/2004187601276540473/edit#%E4%B9%9D%E5%AE%89%E5%85%A8%E9%A3%8E%E9%99%A9%E4%B8%8E%E6%BC%8F%E6%B4%9E%E5%85%A8%E8%A7%A3%E6%9E%90)
* [十、官方安全解决方案](https://zhuanlan.zhihu.com/p/2004187601276540473/edit#%E5%8D%81%E5%AE%98%E6%96%B9%E5%AE%89%E5%85%A8%E8%A7%A3%E5%86%B3%E6%96%B9%E6%A1%88)
* [十一、参考资源](https://zhuanlan.zhihu.com/p/2004187601276540473/edit#%E5%8D%81%E4%B8%80%E5%8F%82%E8%80%83%E8%B5%84%E6%BA%90)

---

## 一、项目概述

### 什么是 OpenClaw？

**OpenClaw**（原名 Clawdbot → Moltbot → OpenClaw）是一个开源的个人 AI 助手运行时，由 PSPDFKit 创始人 **Peter Steinberger** 于 2026 年初发起。项目在 **72 小时内增长超过 6 万 Star**，2 周内突破 **15 万 Star**，成为 GitHub 史上增长最快的开源项目之一。

![](https://picx.zhimg.com/v2-94263d74a796254e988ce842ba5f158f_1440w.jpg)

2026.3.3 更新：OpenClaw 已经登顶全球、史上第一

核心定位：**在你自己的设备上运行的 AI Agent**，连接各种消息平台（WhatsApp、Telegram、Slack、Discord、Signal、iMessage、飞书、钉钉等），提供 24⁄7 全天候的 AI 助手体验。

### 核心特性

| 特性 | 说明 |
| --- | --- |
| 多渠道收件箱 | 统一接入 WhatsApp、Telegram、Slack、Discord、Google Chat、Signal、BlueBubbles (iMessage)、飞书、钉钉 |
| 本地 Gateway | 基于 WebSocket 的控制平面，运行在 localhost:18789，管理会话、渠道、工具和事件 |
| 语音能力 | macOS/iOS/Android 上通过 ElevenLabs 实现始终在线语音（Voice Wake + Talk Mode） |
| 可视化工作区 (Canvas) | Agent 驱动的可视化工作区，支持 A2UI 交互式 Agent 控制 |
| 设备集成 | iOS/Android 节点可暴露摄像头、屏幕录制、位置服务等设备能力 |
| 灵活工具 | 浏览器控制、定时任务、Webhooks、技能注册表 (ClawHub)，100+ 预配置 AgentSkills |
| 开源许可 | MIT 协议，完全免费 |

---

## 二、系统架构

OpenClaw 采用五大功能模块的微服务架构：

```
┌─────────────────────────────────────────────────────────┐
│                    消息渠道层                              │
│  WhatsApp │ Telegram │ Slack │ Discord │ 飞书 │ 钉钉      │
└────────────────────────┬────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────┐
│              Gateway（核心控制平面）                       │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌───────────┐  │
│  │ Sessions │ │ Channels │ │  Tools   │ │  Events   │  │
│  └──────────┘ └──────────┘ └──────────┘ └───────────┘  │
│                    localhost:18789                       │
└────────────┬───────────────────┬────────────────────────┘
             │                   │
     ┌───────▼───────┐   ┌──────▼──────┐
     │   Agent 层     │   │  Nodes 层   │
     │ (LLM 决策引擎) │   │ (设备端点)   │
     │ Claude/GPT/    │   │ iOS/Android │
     │ Ollama/Qwen    │   │ Camera/GPS  │
     └───────┬───────┘   └─────────────┘
             │
     ┌───────▼───────┐
     │   Skills 层    │
     │  (插件工具包)   │
     │ Shell/Browser/ │
     │ File/Web/API   │
     └───────────────┘
```

**关键组件说明**：

* **Gateway**: 单一控制平面，所有消息经由此路由，管理认证和会话
* **Agent**: 连接 LLM（Claude、GPT、Ollama 等），理解上下文并制定执行计划
* **Skills**: JS/TS 可扩展工具包，支持 Shell 命令、文件操作、浏览器控制等
* **Channels**: 连接各消息平台，提供统一消息接口
* **Nodes**: 在用户设备上运行的传感器/端点，暴露设备能力

---

## 三、快速部署方式总览

### 部署方式对比表

| 部署方式 | 难度 | 成本 | 适用场景 | 设置时间 |
| --- | --- | --- | --- | --- |
| 一键脚本安装 | ⭐ 最低 | 免费 + API费用 | 本地快速体验 | ~5 分钟 |
| npm 全局安装 | ⭐⭐ 低 | 免费 + API费用 | 开发者日常使用 | ~5 分钟 |
| Mac Mini 本地部署 | ⭐⭐⭐ 中 | 800-2000 美金硬件 | 零云端费用、隐私优先 | ~30 分钟 |
| Docker 容器化 | ⭐⭐⭐ 中 | 免费 + API费用 | 隔离运行、安全优先 | ~15 分钟 |
| 阿里云轻量服务器 | ⭐⭐ 低 | 68元/年起 + API | 国内用户快速上手 | ~10 分钟 |
| 腾讯云 Lighthouse | ⭐⭐ 低 | 99元/年起 + API | 国内用户快速上手 | ~10 分钟 |
| DigitalOcean 1-Click | ⭐ 最低 | 5-12 美金/月 + API | 海外用户一键部署 | ~5 分钟 |
| Emergent.sh | ⭐ 最低 | 免费层可用 | 零配置体验 | ~5 分钟 |
| Railway / Render | ⭐⭐ 低 | 0-7 美金/月 + API | 开发者云部署 | ~8-12 分钟 |
| macOS VM (Lume) | ⭐⭐⭐⭐ 高 | 0 美金（本地VM） | iMessage集成、完全隔离 | ~20 分钟 |
| Cloudflare Workers | ⭐⭐⭐⭐ 高 | 5 美金/月起 | 无服务器、高可扩展 | ~15 分钟 |

### 系统最低要求

| 项目 | 最低要求 | 推荐配置 |
| --- | --- | --- |
| CPU | 2 核 | 4 核+ |
| 内存 | 2 GB | 4-8 GB |
| 磁盘 | 10 GB | 40 GB+ |
| Node.js | >= 22.0.0 | 最新 LTS |
| 操作系统 | macOS / Linux / Windows (WSL2) | macOS (Apple Silicon) |
| 核心端口 | TCP 18789 | TCP 18789 + 80 |

---

## 四、Mac Mini 本地部署详解

Mac Mini 是运行 OpenClaw 的理想本地硬件方案——低功耗（20-40W）、高性能、零云端费用。

### 4.1 硬件选型推荐

| 方案 | 硬件配置 | 价格 | 本地模型能力 |
| --- | --- | --- | --- |
| 预算方案 | Mac Mini M4 (24GB) | 约 800 美金 | 运行 7B-13B 参数模型 |
| 推荐方案 | Mac Mini M4 Pro (64GB) | 约 2,000 美金 | 运行 32B 参数模型，如 Qwen2.5-Coder-32B |
| 旗舰方案 | Mac Mini M4 Max (128GB) | 约 3,500+ 美金 | 运行 70B+ 参数模型 |

> **性能参考**: GLM-4.7-Flash 在 24GB 系统上可达 15-20 tokens/秒；Qwen3-Coder-30B 在 32GB 模型上可达 10-15 tokens/秒。

### 4.2 安装步骤

### 步骤 1：安装基础依赖

```
# 安装 Homebrew（如未安装）
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 安装 Node.js 22+
brew install node@22

# 验证 Node.js 版本
node --version  # 应显示 v22.x.x 或更高

# （可选）安装 Ollama 用于本地模型推理
brew install ollama
```

### 步骤 2：安装 OpenClaw

```
# 方式一：一键脚本（推荐）
curl -fsSL https://openclaw.ai/install.sh | bash

# 方式二：npm 全局安装
npm install -g openclaw@latest

# 方式三：从源码编译
git clone https://github.com/openclaw/openclaw.git && cd openclaw
pnpm install && pnpm ui:build && pnpm build
```

### 步骤 3：运行配置向导

```
openclaw onboard --install-daemon
```

配置向导会引导你完成：

1. **选择 AI 模型提供商**：Anthropic (Claude)、OpenAI、Google Gemini、本地 Ollama 等
2. **配置 API Key**：输入对应提供商的 API 密钥
3. **选择消息渠道**：Telegram（推荐新手）、WhatsApp、飞书等
4. **安装守护进程**：使 Gateway 作为系统服务运行

### 步骤 4：配置本地模型（零成本方案）

```
# 启动 Ollama
ollama serve

# 拉取推荐模型
ollama pull qwen2.5-coder:32b   # 编程优化模型
ollama pull llama3.3:70b          # 通用大模型

# 配置 OpenClaw 使用本地 Ollama
# 编辑 ~/.openclaw/openclaw.json
```

在 `~/.openclaw/openclaw.json` 中配置 Ollama：

```
{
  "agent": {
    "model": "ollama/qwen2.5-coder:32b",
    "providers": {
      "ollama": {
        "baseUrl": "http://localhost:11434/v1"
      }
    }
  }
}
```

### 步骤 5：验证并启动

```
# 检查 Gateway 状态
openclaw gateway status

# 启动 Gateway
openclaw gateway start

# 打开控制面板
openclaw dashboard

# 健康检查
openclaw doctor
```

### 4.3 Mac Mini 7×24 小时运行配置

```
# 禁用睡眠
sudo pmset -a sleep 0 displaysleep 0 disksleep 0

# 使用 caffeinate 保持运行（可选）
caffeinate -d -i -s &

# 设置开机自动启动（通过 launchd）
# openclaw onboard --install-daemon 已自动完成此步骤
```

### 4.4 接入飞书/钉钉（国内用户）

```
# 飞书接入
openclaw configure
# 选择 Feishu 渠道 -> 输入 App ID 和 App Secret -> 配置 Webhook

# 钉钉接入（需创建钉钉应用）
# 1. 创建钉钉开放平台应用
# 2. 创建 AI 消息卡片
# 3. 授予 Card.Streaming.Write 和 Card.Instance.Write 权限
# 4. 创建 AppFlow 连接流
# 5. 配置 HTTP 模式机器人
```

---

## 五、在线虚拟机/云服务器部署详解

### 5.1 国内云服务商方案

### 方案 A：阿里云轻量应用服务器（推荐国内用户）

**优势**: 预装 OpenClaw 应用镜像，一键部署

```
费用: 68元/年起 (2核2G + 200Mbps带宽 + 40GB磁盘)
系统: Alibaba Cloud Linux 3.2104 LTS 64位
默认地域: 美国（弗吉尼亚）
```

**部署步骤**:

1. 登录阿里云控制台 → 轻量应用服务器 → 选择 **OpenClaw 应用镜像**
2. 选择套餐（内存必须 2GiB 及以上）
3. 进入服务器概览 → 应用详情 → 点击 **“一键放通”** 开启防火墙（放行端口 18789/TCP）
4. 配置百炼 API Key（标准按量计费 或 Coding Plan 固定月费）
5. 执行获取 Token 命令
6. 通过 `http://<服务器IP>:18789/?token=xxx` 访问控制面板

### 方案 B：腾讯云 Lighthouse

```
费用: 99元/年 (2核2G + 50Mbps带宽 + 50GB)
预装: 最新版 OpenClaw (2026.2.3-1)
特点: 支持 QQ/企业微信/钉钉/飞书全接入
```

**部署步骤**:

1. 腾讯云控制台 → Lighthouse → AI 智能体 → **Clawdbot/OpenClaw 模板**
2. 选择规格（建议 2核2G 及以上）
3. SSH 连接后执行：

```
openclaw onboard        # 启动配置向导
openclaw gateway start  # 启动 Gateway
```

### 方案 C：手动部署到任意 VPS

适用于已有 VPS 或非主流云商用户：

```
# 1. SSH 连接到服务器
ssh -i ~/pub.pem root@<server-ip>

# 2. 创建非 root 用户
adduser openclaw
usermod -aG sudo openclaw
su - openclaw

# 3. 创建 Swap 空间（2G内存建议创建4GB Swap）
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# 4. 安装 Node.js 22+
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
source ~/.bashrc
nvm install 22
nvm use 22

# 5. 安装 OpenClaw
curl -fsSL https://openclaw.ai/install.sh | bash

# 6. 运行配置向导
openclaw onboard --install-daemon

# 7. 防火墙放行
sudo ufw allow 18789/tcp
```

### 5.2 海外云服务商方案

### DigitalOcean 1-Click Deploy

```
费用: 5-12 美金/月
特点: 一键部署，预配置安全镜像
支持模型: Gradient AI, OpenAI, Anthropic
```

通过 DigitalOcean Marketplace 搜索 “OpenClaw” → 选择 1-Click Deploy。

### 其他平台

| 平台 | 起步价 | 设置时间 | 特点 |
| --- | --- | --- | --- |
| Emergent.sh | 免费层 | ~5 分钟 | 预构建 “chip”，无需终端 |
| Hostinger VPS | 2.99 美金/月 | ~10 分钟 | 独立 IP，99.9% SLA |
| Railway.app | 0-5 美金/月 | ~8 分钟 | 需挂载持久化存储 /data |
| Render | 免费-7 美金/月 | ~12 分钟 | 基础设施即代码部署 |
| Northflank | 5-10 美金/月 | ~7 分钟 | 一键模板 + 持久化存储 |
| Cloudflare Workers | 5 美金/月起 | ~15 分钟 | 无服务器、高扩展性 |

### 5.3 国内云成本对比

| 云厂商 | 价格 | 配置 | 适用场景 |
| --- | --- | --- | --- |
| 阿里云 | 68元/年 | 2核2G + 200Mbps + 40GB | 性价比首选 |
| 腾讯云 | 99元/年 | 2核2G + 50Mbps + 50GB | 全渠道接入 |
| 百度云 | 0.01元首月 | 2核4G + 200GB | 试用体验 |
| AWS | 免费半年 + 100 美金额度 | t3.small 2核2G + 30GB | 海外用户 |

---

## 六、Docker 容器化部署

![](https://picx.zhimg.com/v2-22a7dcb81564124a6565572a6e2c51d7_1440w.jpg)

Docker 部署是安全性和隔离性最好的方案，强烈推荐用于生产环境。

### 6.1 快速启动

```
# 克隆仓库
git clone https://github.com/openclaw/openclaw.git
cd openclaw

# 一键部署（推荐）
./docker-setup.sh

# Gateway 将运行在 http://127.0.0.1:18789/
```

`docker-setup.sh` 自动完成：构建 Gateway 镜像 → 运行 Onboarding → 启动 Docker Compose → 生成认证 Token。

### 6.2 手动 Docker Compose 部署

```
# 1. 构建镜像
docker build -t openclaw:local -f Dockerfile .

# 2. 运行配置向导
docker compose run --rm openclaw-cli onboard

# 3. 启动 Gateway
docker compose up -d openclaw-gateway

# 4. 获取控制面板链接
docker compose run --rm openclaw-cli dashboard --no-open

# 5. 查看并授权设备
docker compose run --rm openclaw-cli devices list
docker compose run --rm openclaw-cli devices approve <requestId>
```

### 6.3 环境变量配置

```
# 自定义系统包
export OPENCLAW_DOCKER_APT_PACKAGES="ffmpeg build-essential"

# 额外挂载目录
export OPENCLAW_EXTRA_MOUNTS="$HOME/.codex:/home/node/.codex:ro"

# 持久化 home 目录
export OPENCLAW_HOME_VOLUME="openclaw_home"

# 运行
./docker-setup.sh
```

### 6.4 Agent 沙箱配置

OpenClaw 支持为 Agent 创建隔离的 Docker 沙箱容器：

```
{
  "agents": {
    "defaults": {
      "sandbox": {
        "mode": "non-main",
        "scope": "agent",
        "workspaceAccess": "none",
        "docker": {
          "image": "openclaw-sandbox:bookworm-slim",
          "network": "none",
          "user": "1000:1000"
        }
      }
    }
  }
}
```

**沙箱镜像构建**:

```
scripts/sandbox-setup.sh              # 基础镜像
scripts/sandbox-common-setup.sh       # 含 Node, Go, Rust 等
scripts/sandbox-browser-setup.sh      # 含 Chromium CDP 浏览器
```

### 6.5 Docker 安全加固

默认安全配置：

* `readOnlyRoot: true` — 只读根文件系统
* `capDrop: ["ALL"]` — 丢弃所有 Linux capabilities
* `pidsLimit: 256` — 进程数限制
* `memory: "1g"` / `memorySwap: "2g"` — 内存限制
* `network: "none"` — 无出站网络
* `seccompProfile` + `apparmorProfile` 支持
* 容器以非 root 用户运行 (uid 1000)

---

## 七、macOS 虚拟机部署（Lume）

适合需要 **iMessage 集成** 或 **完全隔离** 环境的场景。

### 7.1 系统要求

* Apple Silicon Mac (M1/M2/M3/M4)
* macOS Sequoia 或更高版本
* ~60GB 可用磁盘空间
* ~20 分钟初始设置时间

### 7.2 部署步骤

```
# 1. 安装 Lume
curl -fsSL https://lume.dev/install.sh | bash

# 2. 创建 macOS 虚拟机
lume create openclaw --os macos --ipsw latest

# 3. 在 VNC 窗口完成 macOS 设置助手
#    - 启用"远程登录"(SSH)

# 4. 获取 VM IP 地址
lume get openclaw

# 5. SSH 进入 VM
ssh user@<vm-ip>

# 6. 在 VM 中安装 OpenClaw
npm install -g openclaw@latest
openclaw onboard --install-daemon

# 7. 配置渠道 (~/.openclaw/openclaw.json)
# 8. 无头运行
lume run openclaw --no-display
```

### 7.3 iMessage 集成（BlueBubbles）

1. 在 VM 中安装并配置 BlueBubbles
2. 启用 BlueBubbles Web API
3. 配置 Webhook 指向 Gateway
4. 在 `openclaw.json` 中添加 BlueBubbles 渠道凭证

### 7.4 VM 快照与恢复

```
# 创建金色快照（配置完成后）
lume clone openclaw openclaw-golden

# 重置 VM
lume delete openclaw
lume clone openclaw-golden openclaw
```

---

## 八、Token 成本深度分析

> ⚠️ **重要警告**: OpenClaw 的 Token 消耗可能远超预期！有用户报告一晚上”待机”就花了 18.75 美金，也有用户单日消耗 5000 万 Tokens。

### 8.1 成本构成分析

Token 消耗的六大来源：

| 来源 | 占比 | 说明 |
| --- | --- | --- |
| 上下文累积 | 40-50% | 会话历史无限增长，每次请求重发全部对话 |
| 工具输出存储 | 20-30% | 大型 JSON/日志持久化到历史文件 |
| 系统提示词 | 10-15% | 复杂提示词重复传输，缓存 5 分钟过期 |
| 多轮推理 | 10-15% | 复杂任务需要多次连续 API 调用 |
| 模型选择 | 5-10% | 简单任务使用昂贵模型 |
| 心跳任务 | 5-10% | 后台进程配置不当导致过多调用 |

### 8.2 各模型价格对比

| 模型 | 输入成本 | 输出成本 | 相对成本 |
| --- | --- | --- | --- |
| Claude Opus 4.5 | 15 美金/百万 tokens | 75 美金/百万 tokens | 基线（最贵） |
| Claude Sonnet 4.5 | 3 美金/百万 tokens | 15 美金/百万 tokens | 标准 |
| Claude Haiku 4.5 | 1 美金/百万 tokens | 5 美金/百万 tokens | ~Sonnet 的 1⁄3 |
| Gemini 3.0 Flash | 0.075 美金/百万 | 0.30 美金/百万 | ~Sonnet 的 1⁄40 |
| Deepseek V3 | 0.27 美金/百万 | 类似 | ~Sonnet 的 1⁄11 |

### 8.3 真实用户月费基准

| 使用强度 | 月 Token 消耗 | 月费用 | 典型场景 |
| --- | --- | --- | --- |
| 轻度 | 5-20M | 10-30 美金 | 日常问答 |
| 中度 | 20-50M | 30-70 美金 | 自动化工作流 |
| 重度 | 50-200M | 70-150+ 美金 | 7×24 助手 |
| 极端 | 180M+ | 3,600+ 美金 | 持续自动化 |

### 8.4 🔴 Token “烧钱”真实案例

**案例 1：18.75 美金的一夜**

一个简单的”心跳”检查（每 30 分钟验证一次任务是否待处理），将整个 120,000 token 上下文窗口发送到 Claude Opus API：

* 每次请求：~0.75 美金
* 一晚 25 次请求：**18.75 美金**
* 一周成本：~**250 美金**

**案例 2：11 美金/天的”待机”状态**

即使使用轻量级的 Gemini 3 Flash 模型处于近乎”待机”状态：

* 单日 Token 消耗：4000-5000 万 Tokens
* 单日成本：**11 美金**

**案例 3：380 美金/天的社交媒体监控**

Reddit 用户报告让 AI 助手仅阅读社交媒体：

* 每 30 分钟处理新帖：8 美金
* 每天成本：**超过 380 美金**

### 8.5 Token 成本优化策略

![](https://pic2.zhimg.com/v2-51c70db2018c9c1fbed1f12a8c5d3c3f_1440w.jpg)

### 策略 1：会话重置（节省 40-60%）

```
{
  "agent": {
    "sessionReset": "after-task",
    "maxContextTokens": 50000
  }
}
```

独立任务完成后重置会话，防止上下文膨胀。

### 策略 2：智能模型路由（节省 50-80%）

“日常任务使用 Haiku 或 Gemini Flash，仅在复杂推理时切换到 Sonnet/Opus。”

### 策略 3：隔离大型操作（节省 20-30%）

将产生大量输出的命令在独立会话中执行，防止上下文污染。

### 策略 4：缓存优化（节省 30-50%）

配置低 temperature (0.2)，心跳间隔设在 TTL 限制以下，保持缓存有效。

### 策略 5：上下文窗口限制（节省 20-40%）

将默认的 400K 上下文缩减到 50-100K tokens。

### 策略 6：本地模型回退（节省 60-80%）

使用 Ollama + 本地模型处理简单任务，彻底消除 API 成本。

### 🎯 综合优化效果

真实用户通过组合策略实现 **77% 总成本降低**：

* 优化前：150 美金/月
* 优化后：35 美金/月
* 年节省：**1,380 美金**

### 8.6 预算建议

| 预算级别 | 月费 | 策略 |
| --- | --- | --- |
| 极简 | 0 美金 | 纯本地 Ollama 模型 |
| 低预算 | 10-30 美金 | 仅使用 Haiku；每日重置会话 |
| 中等 | 30-70 美金 | Sonnet 处理复杂任务，Haiku 处理简单任务 |
| 高级 | 150+ 美金 | 全部六项策略 + 本地回退 + 供应商折扣 |

---

## 九、安全风险与漏洞全解析

> ⚠️ **安全警告**: OpenClaw 的安全问题非常严重。在生产环境部署前务必充分了解并加固。

### 9.1 CVE-2026-25253：一键远程代码执行

**这是 OpenClaw 迄今最严重的安全漏洞。**

| 项目 | 详情 |
| --- | --- |
| CVE 编号 | CVE-2026-25253 |
| CVSS 评分 | 8.8（高危） |
| 影响版本 | 2026.1.29 之前所有版本 |
| 修复版本 | 2026.1.29（2026年1月30日发布） |
| 发现者 | Mav Levin (DepthFirst) |
| 公告编号 | GHSA-g8p2-7wf7-98mq |

**漏洞类型**: Token 泄露 → 完整 Gateway 接管 → 未认证远程代码执行

**攻击链详解**:

```
1. 受害者点击恶意链接或访问钓鱼网站
         ↓
2. 恶意 JavaScript 获取 OpenClaw 认证 Token
   （Control UI 接受未验证的 gatewayUrl 查询参数）
         ↓
3. JavaScript 通过 WebSocket 连接受害者的 OpenClaw 实例
   （服务器未验证 WebSocket Origin 头，接受任意来源请求）
         ↓
4. 攻击者使用窃取的 Token 绕过认证
         ↓
5. 禁用用户确认 (exec.approvals.set → "off")
         ↓
6. 逃逸容器沙箱 (tools.exec.host → "gateway")
         ↓
7. 通过 node.invoke 在宿主机上执行任意命令
```

**影响范围**:

* 一键远程代码执行（整个过程仅需毫秒级）
* 获得操作员级 Gateway API 访问权限
* 任意修改配置
* 即使绑定到 localhost 也可执行宿主机代码

### 9.2 Moltbook 数据库暴露事件

| 项目 | 详情 |
| --- | --- |
| 时间 | 2026年1月31日 |
| 项目 | Moltbook（OpenClaw 生态社交平台） |
| 严重性 | 高 |
| 问题 | 底层数据库配置错误，API Keys 公开可访问 |
| 影响 | 攻击者可冒充平台上任何已注册的 AI Agent（包括 Andrej Karpathy 等知名账号） |

### 9.3 923 个网关完全暴露事件

通过 Shodan 扫描发现 **923 个 OpenClaw Gateway 完全暴露在互联网上**：

* 无认证、无密码
* 攻击者可劫持这些实例
* 可提取所有存储的 API Key 和对话历史
* OpenClaw 通常被授予 Shell 访问、浏览器控制等高权限

### 9.4 恶意 VS Code 扩展事件

**时间**: 2026年1月27日

名为 **“ClawdBot Agent”** 的 VS Code 扩展被发现包含 **ScreenConnect RAT（远程访问木马）**。安装后攻击者可完全控制用户计算机。

### 9.5 加密货币诈骗

在 Moltbot → OpenClaw 更名窗口期，出现了假冒的 **$CLAWD 代币**，市值一度达到 **1600 万美金**。

### 9.6 六大安全攻击向量

| 攻击向量 | 风险等级 | 说明 | 缓解措施 |
| --- | --- | --- | --- |
| 提示词注入 | 🔴 高 | 所有模型都受影响，系统提示词无法完全防御 | 工具白名单、沙箱、渠道限制 |
| 跨用户泄露 | 🟡 中 | 默认 DM 共享同一会话 | 配置 dmScope: "per-channel-peer" |
| 浏览器控制风险 | 🔴 高 | 模型可访问浏览器已登录的所有账户 | 使用专用浏览器 Profile |
| 插件执行风险 | 🟡 中 | 插件在 Gateway 进程内运行 | 版本锁定、代码审查 |
| 第三方技能包 | 🔴 高 | 任何人可发布技能包，可能暗藏钓鱼代码 | 仅安装可信来源、审查代码 |
| Token URL 泄露 | 🔴 极高 | 包含认证凭据的完整 URL 泄露 = 管理员权限被盗 | 妥善保管、定期轮换 |

### 9.7 真实受害案例

> 有用户反映 OpenClaw 在执行”清理任务”时，**误删了电脑中所有重要照片**。

这个案例说明：

* AI Agent 拥有的系统权限必须严格限制
* 人工确认机制对于破坏性操作至关重要
* 沙箱隔离是保护主系统的最后防线

---

![](https://pic3.zhimg.com/v2-8e0987caae350256690c60ce141004d6_1440w.jpg)

## 十、官方安全解决方案

### 10.1 认证加固（v2026.1.29 重大变更）

**`auth: "none"` 模式已被永久移除。** 所有实例必须使用以下认证方式之一：

```
// 方式一：Token 认证（推荐）
{
  "gateway": {
    "auth": "token"
  }
}

// 方式二：密码认证
{
  "gateway": {
    "auth": "password"
  }
}

// 方式三：Tailscale Serve 身份认证
```

### 10.2 DM 访问策略

OpenClaw 支持四种 DM 策略：

| 策略 | 说明 | 推荐场景 |
| --- | --- | --- |
| pairing（默认） | 未知发送者收到限时配对码 | 个人使用 |
| allowlist | 完全阻止未知发送者 | 企业/生产环境 |
| open | 允许任何人（需显式 "\*" 白名单） | 不推荐 |
| disabled | 忽略所有入站 DM | 仅群组模式 |

### 10.3 沙箱隔离架构

```
{
  "agents": {
    "defaults": {
      "sandbox": {
        "mode": "non-main",
        "scope": "agent",
        "workspaceAccess": "none",
        "docker": {
          "image": "openclaw-sandbox:bookworm-slim",
          "network": "none",
          "user": "1000:1000"
        }
      }
    }
  }
}
```

**工作区访问控制**:

* `workspaceAccess: "none"` — Agent 工作区不可访问（最安全）
* `workspaceAccess: "ro"` — 只读挂载到 `/agent`
* `workspaceAccess: "rw"` — 完全读写访问

**会话隔离**:

* `dmScope: "main"` — 所有 DM 共享一个会话（默认，有跨用户泄露风险）
* `dmScope: "per-channel-peer"` — 每个发送者+渠道对隔离
* `dmScope: "per-account-channel-peer"` — 多账户进一步隔离

### 10.4 安全审计工具

```
# 基本审计
openclaw security audit

# 深度审计（含 Gateway 实时探测）
openclaw security audit --deep

# 自动修复安全配置
openclaw security audit --fix
```

审计检测项目：

* DM/群组策略配置错误
* 开放房间中的过高工具权限
* 网络暴露（LAN 绑定、Funnel、弱认证）
* 浏览器控制远程暴露
* 凭据/配置/状态的文件权限问题
* 未签名插件
* 过时模型配置

### 10.5 网络安全加固清单

```
# ✅ 使用 loopback 绑定（默认）
gateway.bind: "loopback"

# ✅ 远程访问优先使用 Tailscale Serve
# ❌ 永远不要在 0.0.0.0 上暴露未认证的 Gateway

# ✅ 配置反向代理时设置可信代理
gateway.trustedProxies: ["10.0.0.1"]

# ✅ mDNS 设为最小模式
discovery.mdns.mode: "minimal"

# ✅ 全盘加密
# ✅ 专用 OS 用户账户
# ✅ 日志中的敏感模式脱敏
logging.redactPatterns: ["sk-*", "Bearer *"]
```

### 10.6 多 Agent 安全分级

```
{
  "agents": {
    "personal": {
      "sandbox": { "mode": "off" },
      "tools": ["*"]
    },
    "family": {
      "sandbox": { "mode": "always" },
      "tools": ["messaging", "calendar"],
      "workspaceAccess": "ro"
    },
    "public": {
      "sandbox": { "mode": "always" },
      "tools": ["messaging"],
      "workspaceAccess": "none"
    }
  }
}
```

### 10.7 事件响应流程

**发现异常后的紧急处理**:

**立即遏制**:

```
# 停止 Gateway openclaw gateway stop 
# 限制为 loopback gateway.bind: "loopback" 
# 禁用公网访问
```

**轮换凭据**:

+ Gateway 认证 Token/密码
+ 远程客户端凭据
+ 所有 Provider/API 凭据

```
调查:
# 查看 Gateway 日志 cat /tmp/openclaw/openclaw-YYYY-MM-DD.log 

# 分析会话记录中的异常工具调用 

# 检查未授权的插件/配置变更
# 报告漏洞: security@openclaw.ai
```

---

## 十一、参考资源

### 英文资源

1. [Getting Started - OpenClaw Official Docs](https://link.zhihu.com/?target=https%3A//docs.openclaw.ai/start/getting-started)
2. [Unleashing OpenClaw: Ultimate Guide to Local AI Agents - DEV Community](https://link.zhihu.com/?target=https%3A//dev.to/mechcloud_academy/unleashing-openclaw-the-ultimate-guide-to-local-ai-agents-for-developers-in-2026-3k0h)
3. [OpenClaw Tutorial: Installation to First Chat Setup - Codecademy](https://link.zhihu.com/?target=https%3A//www.codecademy.com/article/open-claw-tutorial-installation-to-first-chat-setup)
4. [What is OpenClaw: Open-Source AI Agent in 2026 - Medium](https://link.zhihu.com/?target=https%3A//medium.com/%40gemQueenx/what-is-openclaw-open-source-ai-agent-in-2026-setup-features-8e020db20e5e)
5. [OpenClaw Complete Guide 2026 - NxCode](https://link.zhihu.com/?target=https%3A//www.nxcode.io/resources/news/openclaw-complete-guide-2026)
6. [What is OpenClaw? Your Open-Source AI Assistant - DigitalOcean](https://link.zhihu.com/?target=https%3A//www.digitalocean.com/resources/articles/what-is-openclaw)
7. [Install OpenClaw in 5 Minutes - OpenClawAGI](https://link.zhihu.com/?target=https%3A//openclawagi.com/install-openclaw-in-5-minutes-fast-secure-setup-guide-2026/)
8. [Set Up OpenClaw in Minutes: 6 Easy Deployment Options - The Tool Nerd](https://link.zhihu.com/?target=https%3A//www.thetoolnerd.com/p/set-up-openclawclawdbot-in-minutes)
9. [How to Run OpenClaw - DigitalOcean Community](https://link.zhihu.com/?target=https%3A//www.digitalocean.com/community/tutorials/how-to-run-openclaw)
10. [OpenClaw Token Cost Optimization Guide - APIYI](https://link.zhihu.com/?target=https%3A//help.apiyi.com/en/openclaw-token-cost-optimization-guide-en.html)

### 中文资源

1. [部署OpenClaw镜像并构建钉钉AI员工 - 阿里云文档](https://link.zhihu.com/?target=https%3A//help.aliyun.com/zh/simple-application-server/use-cases/quickly-deploy-and-use-openclaw)
2. [一文读懂：openClaw 分析与教程 - 知乎](https://zhuanlan.zhihu.com/p/2000850539936765122)
3. [OpenClaw安装部署及国产平替实在Agent - AI-Indeed](https://link.zhihu.com/?target=https%3A//www.ai-indeed.com/article/15272.html)
4. [OpenClaw (Clawdbot) 教程 - 菜鸟教程](https://link.zhihu.com/?target=https%3A//www.runoob.com/ai-agent/openclaw-clawdbot-tutorial.html)
5. [0元搭建7×24h AI助手 OpenClaw云部署完全指南 - DEV Community](https://link.zhihu.com/?target=https%3A//dev.to/yang_ella_f2a3e16ccb54550/0yuan-da-jian-7x24h-aizhu-shou-openclawyun-fu-wu-qi-bu-shu-wan-quan-zhi-nan-5hlf)
6. [2026年OpenClaw极速部署教程及常见问题 - 阿里云开发者社区](https://link.zhihu.com/?target=https%3A//developer.aliyun.com/article/1710373)
7. [手把手教你部署OpenClaw - 博客园](https://link.zhihu.com/?target=https%3A//www.cnblogs.com/whuanle/p/19558535)
8. [openclaw-cn 中文版 - GitHub](https://link.zhihu.com/?target=https%3A//github.com/jiulingyun/openclaw-cn)
9. [OpenClaw Mac Mini完全指南 - Marc0.dev](https://link.zhihu.com/?target=https%3A//www.marc0.dev/en/blog/openclaw-mac-mini-the-complete-guide-to-running-your-own-ai-agent-in-2026-1770057455419)
10. [OpenClaw 18.75 美金一夜成本分析 - Notebookcheck](https://link.zhihu.com/?target=https%3A//www.notebookcheck-cn.com/18-75-OpenClaw.1220271.0.html)

### 安全相关资源

1. [CVE-2026-25253 详情 - GHSA-g8p2-7wf7-98mq](https://link.zhihu.com/?target=https%3A//github.com/openclaw/openclaw/security/advisories/GHSA-g8p2-7wf7-98mq)
2. [OpenClaw 安全最佳实践](https://link.zhihu.com/?target=https%3A//docs.openclaw.ai/security)
3. [The Register: OpenClaw Security Issues](https://link.zhihu.com/?target=https%3A//www.theregister.com/2026/02/02/openclaw_security_issues/)
4. 漏洞报告邮箱：[security@openclaw.ai](mailto:security@openclaw.ai)

### 官方资源

1. [GitHub 仓库](https://link.zhihu.com/?target=https%3A//github.com/openclaw/openclaw)
2. [官方文档](https://link.zhihu.com/?target=https%3A//docs.openclaw.ai/)
3. [中文文档](https://link.zhihu.com/?target=https%3A//clawd.org.cn/docs/start/getting-started)
4. [中文版仓库](https://link.zhihu.com/?target=https%3A//github.com/jiulingyun/openclaw-cn)

---

> **免责声明**: 本文档基于公开资料整理，仅供学习参考。OpenClaw 为开源 AI 助手，请在使用前充分评估其安全性与稳定性，并严格遵循许可协议。部署前务必阅读官方安全文档并运行 `openclaw security audit --deep` 进行安全检查。  
> (文章结束)