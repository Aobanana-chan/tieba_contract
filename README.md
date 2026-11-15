# tieba_contract

Tiebanana 的契约包，纯 Dart。

## 内容

- **数据模型**：界面直接消费的结构，覆盖帖子、楼层、吧、用户、消息、搜索、收藏与话题。
- **端点结果类型**：每个接口一页或一次调用的返回值。
- **`TiebaApi`**：后端需要实现的接口，负责把协议数据转换成上述模型。
- **宿主服务**：`TiebaApiHost` 提供存储、屏幕与提示回调。
- **测试与演示**：`package:tieba_contract/testing.dart` 提供不联网的 `DemoTiebaApi`。

实现 `TiebaApi` 即可替换 Tiebanana 的后端，界面无需改动。

## 使用

主入口提供接口与数据模型：

```dart
import 'package:tieba_contract/tieba_contract.dart';

Future<TiebaThreadPage> loadThread(TiebaApi api, String threadId) {
  return api.getThreadPage(threadId, pn: 1, rn: 30);
}
```

测试或演示时单独导入 `testing.dart`：

```dart
import 'package:tieba_contract/testing.dart';

Future<void> main() async {
  final api = DemoTiebaApi(latency: Duration.zero);
  await api.init();
  final page = await api.getRecommThread(10, 1);
  print(page.threads.first.title);
}
```

## 约定

- 网络请求、序列化、签名与登录流程由后端实现。
- 数据模型只保留界面需要的字段，协议冗余由实现方处理。
- `testing.dart` 是独立入口，主入口不包含演示数据。
- 演示用户头像为内置 PNG data URI；图片消费者需支持 `data:image/png;base64,`。
  `resolveAvatarUrl` 原样保留该地址。帖子配图与吧头像使用网络地址。

## 版本与兼容

版本号遵循语义化版本，tag 为 `vX.Y.Z`，与 `pubspec.yaml` 的 `version` 一致。

- **主版本 `X`**：不兼容变更。删除/重命名字段、修改字段类型、增加必填构造参数、
  给 `TiebaApi` 增删抽象成员或修改方法签名、改变接口语义。
- **次版本 `Y`**：向后兼容扩展。新增带默认值的可选字段、数据类、枚举值或辅助函数。
- **补丁 `Z`**：不改变公开 API 与语义的修复、注释和文档。

给 `TiebaApi` 增加抽象方法也属于主版本变更，因为所有后端实现都必须补上实现。
如果只是可选能力，优先新增独立接口，由界面按能力判断后启用。

实现后端时，请选择目标 Tiebanana 版本要求的契约范围，并直接依赖本包，不要复制
契约源码。各 Tiebanana 版本对应的契约版本见主仓库的
[契约兼容表](https://github.com/Aobanana-chan/Tiebanana/blob/main/docs/contract-versioning.md)。

## 许可证

[MIT](LICENSE)
