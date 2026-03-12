## 如何随时清空／重开会话，避免 Token 堆积

即时手动重置
在当前聊天窗口直接发送 /new 或 /reset（独立成一条消息）。
可以写成 /new gpt-5.1-codex 这类形式顺便切模型；如果只发 /new、/reset，系统会回复一个简短问候确认会话已刷新。
这些指令默认已经启用（参考文档：docs/zh-CN/concepts/session.md）。
自定义触发词（适合想用中文口令）
修改 ~/.openclaw/openclaw.json，在 messages.resetTriggers 里加入你喜欢的别名，例如：
{
"messages": {
"resetTriggers": ["/new", "/reset", "清空会话", "重新开始"]
}
}
用 openclaw config edit 或 openclaw config set messages.resetTriggers '["/new","/reset","清空会话"]' 编辑后，openclaw gateway restart 让配置生效。
限制历史长度，自动截断
DM 历史：针对 WebChat / 本地 UI，可在配置里加
{
"channels": {
"webchat": {
"dmHistoryLimit": 25
}
}
}
让每次调用只携带最近 25 轮对话（换成你能接受的数字）。

群聊历史：统一用 messages.groupChat.historyLimit（默认 50）或逐个渠道覆盖，例如 Telegram/Discord 里的 channels.<provider>.historyLimit。
自动压缩旧上下文（建议保留，减 Token）
你已经启用 agents.defaults.compaction.mode: "safeguard"，可以再补充目标阈值：
{
"agents": {
"defaults": {
"compaction": {
"mode": "safeguard",
"triggerTokens": 32000,
"targetTokens": 24000
}
}
}
}
接近触发阈值时会自动总结老内容、保留最近对话，继续聊也不会重新发送整段历史。

在重置前自动做笔记（可选）
通过 openclaw hooks enable session-memory 启用官方提供的 session-memory hook。这样每次 /new 之前它会把关键信息写进工作区的 memory/ 文件，再启动全新会话，既防止 Token 超限也不丢记忆。
多主题平行处理
如果你希望不同联系人（或不同群）互不影响，再确认 session.dmScope 设置为 "per-channel-peer"（你的配置里已经是这个值），就能保证别人触发 /new 时不会污染你和我目前的私聊。
只要按上面任意一种方式操作，就能及时清空上下文或自动控制历史长度，避免 token 消耗失控。需要我替你改 openclaw.json 或启用某个 hook，直接告诉我。