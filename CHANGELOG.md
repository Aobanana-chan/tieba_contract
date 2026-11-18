# Changelog

## 1.2.0

- `TiebaImageContent` 新增可选字段 `animated`，支持后端显式标记动图。
- `isAnimated` 只使用显式标记和地址里的明确动图信号，不再用 `origin_size`
  与像素数推断，避免高分辨率静态图误判。
- `first_gif` 仅在值为 `1` / `true` 时算动图，`0` 和空值不算。
- 新增 `TiebaImageContent.isAnimatedUrl`，供图片加载后的动图探测复用同一套地址判断。
- 新增私信模型：`TiebaConversation`、`TiebaChatMessage`、`ChatMessagePage`、
  `ChatDraft`、`ChatSendResult`、`ChatBlockInfo` 与 `ChatMaskSettings`。
- 新增可选接口 `TiebaChatApi`，覆盖会话、消息分页、发送、未读、已读与
  IM 免打扰/屏蔽；不改变 `TiebaApi` 的抽象成员。
- `DemoTiebaApi` 同时实现 `TiebaChatApi`，提供可交互的内存会话、发送失败重试、
  未读与已读状态。
- `TiebaConversation` 新增可选 `userType` 与 `isReadOnly`：官方账号 3/4 只接收消息，
  对齐官方隐藏输入栏的行为。
- 新增通知中心模型：`TiebaNotificationOverview`、`TiebaMutualHelpNotice`、
  `TiebaBroadcastNotice`、`TiebaBroadcastItem`、`TiebaBroadcastPage` 与
  `TiebaBroadcastQuota`。
- 新增可选接口 `TiebaNotificationApi`：通知概览、互助屏蔽开关
  （`switch_type=45`）、按吧广播历史、广播聚合流、广播阅读数刷新与发布额度；
  不改变 `TiebaApi` 的抽象成员。
- `TiebaBroadcastItem` 增加评论 / 点赞 / 分享数，供吧广播聚合流展示。
- `DemoTiebaApi` 同时实现 `TiebaNotificationApi`，提供演示用的互助未读、
  广播红点、历史列表、跨吧聚合流与本月配额。

## 1.1.0

- `TiebaImageContent.isAnimated`：根据 CDN 地址、`first_gif` 参数与原图大小识别动图。
- `TiebaImageContent.originSize`：保留 `origin_size`，用于判断 `.jpg` 地址下的动图原图。
- `resolveAvatarUrl` 支持内置图片的 `data:` URI，演示头像离线可显示。
- 演示数据补充离线头像，不改变 `TiebaApi` 接口。

## 1.0.0

首个版本。

- 界面数据模型：帖子、楼层、楼中楼、吧、用户、消息、搜索、收藏与话题等页面数据。
- 端点结果类型，以及分页、投票、上传、签到等公共值类型。
- `TiebaApi` 后端契约与 `TiebaApiHost` 宿主服务抽象。
- `resolveAvatarUrl`：兼容官方头像 id 与绝对 URL。
- `testing.dart`：不联网的 `DemoTiebaApi`，用于测试与演示。
