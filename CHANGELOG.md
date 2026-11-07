# Changelog

## 1.0.0

首个版本。

- 界面数据模型：帖子、楼层、楼中楼、吧、用户、消息、搜索、收藏与话题等页面数据。
- 端点结果类型，以及分页、投票、上传、签到等公共值类型。
- `TiebaApi` 后端契约与 `TiebaApiHost` 宿主服务抽象。
- `resolveAvatarUrl`：兼容官方头像 id 与绝对 URL。
- `testing.dart`：不联网的 `DemoTiebaApi`，用于测试与演示。
