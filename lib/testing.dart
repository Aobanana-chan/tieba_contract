/// 测试与演示用的内存后端入口。
///
/// 导出 `TiebaApi` 的本地实现 `DemoTiebaApi`，不发起网络请求。
/// 主入口 `tieba_contract.dart` 不包含演示数据，需要时单独导入本文件。
library;

export 'src/testing/demo_tieba_api.dart';
