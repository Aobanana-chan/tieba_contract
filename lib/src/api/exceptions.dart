/// 契约层的统一异常类型。
///
/// 实现方在遇到网络或业务错误时抛出，界面据此呈现错误态、重试或提示。
library;

/// 异常类型。
enum NetAPIErrorType {
  /// 初始化失败（如构建上下文、加载凭证）。
  initFailed,

  /// 动作失败（接口报错、未登录等）。
  actionFalied,
}

/// 网络 API 错误。[redoTimes] / [redoFunction] 供宿主实现重试策略。
class NetAPIError implements Exception {
  final NetAPIErrorType type;
  final int redoTimes;
  Function? redoFunction;
  String? errorMessage;

  NetAPIError({
    required this.type,
    required this.redoTimes,
    this.redoFunction,
    this.errorMessage,
  });

  @override
  String toString() =>
      'NetAPIError(${type.name}, redoTimes=$redoTimes)${errorMessage == null ? '' : ': $errorMessage'}';
}
