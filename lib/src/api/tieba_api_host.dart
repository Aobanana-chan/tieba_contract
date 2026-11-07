/// 宿主服务：存储、屏幕与提示回调的抽象。
library;

/// 最小键值存储。
///
/// 用于持久化设备标识等少量键值，宿主可用 `SharedPreferences`、文件或内存实现。
abstract class KeyValueStore {
  /// 读取；不存在返回 `null`。
  String? getString(String key);

  /// 写入并持久化。
  Future<void> setString(String key, String value);
}

/// 内存实现：用于测试或首次启动前的占位（不跨进程持久化）。
class MemoryKeyValueStore implements KeyValueStore {
  final Map<String, String> _values;

  MemoryKeyValueStore([Map<String, String>? initial])
      : _values = <String, String>{...?initial};

  @override
  String? getString(String key) => _values[key];

  @override
  Future<void> setString(String key, String value) async {
    _values[key] = value;
  }

  /// 当前内容快照（只读用途，如断言/调试）。
  Map<String, String> get snapshot => Map.unmodifiable(_values);
}

/// 设备屏幕信息。
class ScreenInfo {
  final int width;
  final int height;
  final double dip;

  const ScreenInfo(this.width, this.height, this.dip);
}

/// 宿主提供给后端实现的依赖。
class TiebaApiHost {
  /// cookie 持久化目录（宿主提供，如 `<documents>/cookies/`）。
  final String cookieStoragePath;

  /// 设备指纹持久化（由宿主提供实现）。
  final KeyValueStore deviceIdStore;

  /// 屏幕信息。
  final ScreenInfo Function() screen;

  /// 通用提示回调（宿主决定呈现方式，如 Toast）；为空则静默。
  final void Function(String message)? onMessage;

  /// 一键签到进度回调（宿主可借此更新通知）。
  final void Function(int current, int total, String title, String body)?
      onSignProgress;

  /// 一键签到结束回调（宿主可借此关闭/取消通知）。
  final void Function()? onSignProgressDone;

  /// 单个吧签到结果回调；每个吧结束时触发一次。
  final void Function(String forumName, bool success)? onForumSigned;

  TiebaApiHost({
    required this.cookieStoragePath,
    required this.deviceIdStore,
    ScreenInfo Function()? screen,
    this.onMessage,
    this.onSignProgress,
    this.onSignProgressDone,
    this.onForumSigned,
  }) : screen = screen ?? _defaultScreen;

  static const ScreenInfo _fallbackScreen = ScreenInfo(1080, 2340, 2.75);

  static ScreenInfo _defaultScreen() => _fallbackScreen;
}
