# OpenClaw 常用命令速查

## 安装
curl -fsSL https://openclaw.ai/install.sh | bash
// 如果上面的不行就直接安装 npm install -g openclaw@latest
openclaw onboard --install-daemon
openclaw gateway status
openclaw dashboard


## 基本信息
- 查看整体运行状态：`openclaw status`
- 查看 CLI 帮助：`openclaw help`（或对任意子命令追加 `--help`）

## Gateway 管理
| 目的 | 命令 |
| --- | --- |
| 启动服务 | `openclaw gateway start`
| 停止服务 | `openclaw gateway stop`
| 重启服务（常用于加载新配置） | `openclaw gateway restart`
| 查看服务状态 | `openclaw gateway status`
| 查看最近日志 | `openclaw gateway logs`（可加 `-f` 持续跟踪）

提示：若只想结束某个对话会话，直接在控制 UI 里关闭或刷新会话即可，无需停整个 Gateway。

## 配置与凭证
- 所有核心配置集中在：`~/.openclaw/openclaw.json`
  - 包含 API key、Discord/Telegram token、默认模型、技能配置等。
- 快捷编辑配置：`openclaw config edit`
- 添加/更新认证信息：`openclaw config auth add <provider>`
  - 支持 openai、anthropic、google 等 provider，按提示输入 key。
- 设置默认模型：
  1. 确保在 `auth.profiles` 里写好了对应 provider 的 key。
  2. 用 `openclaw config set agents.defaults.model.primary <provider/model>`（示例：`openai/gpt-5.1-codex`）。
  3. `openclaw gateway restart` 让改动生效。
- 指定技能或自定义路径：在 `openclaw.json` 中的 `skills` 节点添加/修改，或用 `openclaw config skills add <skill-name>`。

## 文件与目录
- 主配置：`~/.openclaw/openclaw.json`
- 运行时日志：`~/.openclaw/logs/`（子目录按日期划分）
- 工作区（当前会话的文件操作目录）：`~/.openclaw/workspace/`
- 自定义技能目录：通常放在 `~/.openclaw/skills/` 下（也可在配置文件里指定其他路径）。

## 常见排错动作
- 检查 Gateway 是否在运行：`openclaw gateway status`
- 查看更详细的服务输出：`openclaw gateway logs -f`
- 启动前验证配置：`openclaw config validate`
- 更新 CLI 本体（如官方文档提到的升级方式）：`npm install -g openclaw`（或你环境里的包管理器）。

## 快速流程示例
1. 修改配置或新增 key：`openclaw config edit`
2. 保存 `~/.openclaw/openclaw.json`
3. 重启服务：`openclaw gateway restart`
4. 用 `openclaw status` 或 UI 确认一切正常

保持这份速查在手，常用操作基本覆盖。需要更深入的参数或进阶功能，再去官方文档（`docs.openclaw.ai`）按章节查阅即可。


## Skills库
https://github.com/VoltAgent/awesome-openclaw-skills

https://clawhub.ai/
