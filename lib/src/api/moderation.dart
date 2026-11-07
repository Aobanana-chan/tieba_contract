/// 举报目标由业务入口确定，不在表单中切换。
enum TiebaReportKind { thread, reply, subReply, user }

class TiebaReportTarget {
  const TiebaReportTarget(
      {required this.kind,
      required this.userId,
      required this.name,
      this.portrait = '',
      this.threadId = '',
      this.postId = '',
      this.summary = '',
      this.source = ''});
  final TiebaReportKind kind;
  final String userId, name, portrait, threadId, postId, summary, source;
  bool get isUser => kind == TiebaReportKind.user;
  String get label => isUser
      ? '用户'
      : kind == TiebaReportKind.thread
          ? '帖子'
          : '回复';
}

class TiebaReportField {
  const TiebaReportField(
      {required this.component,
      required this.title,
      required this.required,
      this.tips = const []});
  final String component, title;
  final bool required;
  final List<String> tips;
  bool get supported => const [
        'content-input',
        'select-images',
        'select-content'
      ].contains(component);
}

class TiebaReportReason {
  const TiebaReportReason(
      {required this.id,
      required this.groupId,
      required this.title,
      this.fields = const []});
  final int id, groupId;
  final String title;
  final List<TiebaReportField> fields;
}

class TiebaReportGroup {
  const TiebaReportGroup({required this.title, required this.reasons});
  final String title;
  final List<TiebaReportReason> reasons;
}

class TiebaReportForm {
  const TiebaReportForm(
      {required this.url,
      required this.objectType,
      required this.threadId,
      required this.postId,
      required this.portrait,
      required this.groups,
      this.authToken = '',
      this.scene = 0});
  final Uri url;
  final int objectType;

  /// 官方 H5 的 `scene`：1 home、2 frs、3 pb、4 pbComment、
  /// 5 subPbComment、6 pbFold、0 unknown。
  final int scene;
  final String threadId, postId, portrait, authToken;
  final List<TiebaReportGroup> groups;
}

class TiebaReportInput {
  const TiebaReportInput(
      {required this.reason,
      this.detail = '',
      this.imageUrls = const [],
      this.threadIds = const [],
      this.replyDate});
  final TiebaReportReason reason;
  final String detail;
  final List<String> imageUrls, threadIds;
  final DateTime? replyDate;

  bool get isValid =>
      reason.fields.every((field) =>
          field.supported &&
          (!field.required ||
              switch (field.component) {
                'content-input' => detail.trim().isNotEmpty,
                'select-images' => imageUrls.isNotEmpty,
                'select-content' => threadIds.isNotEmpty || replyDate != null,
                _ => false,
              })) &&
      detail.length <= 200 &&
      imageUrls.length <= 4;
}

/// 风控或当前宿主不支持的证据类型，需交给官方页面继续处理。
class TiebaReportVerification implements Exception {
  const TiebaReportVerification(this.message, this.url);
  final String message;
  final Uri url;
  @override
  String toString() => message;
}

/// 写操作已发出但没有可确认结果，不应自动重试。
class TiebaModerationUncertain implements Exception {
  const TiebaModerationUncertain(this.message);
  final String message;
  @override
  String toString() => message;
}

class TiebaBlockSettings {
  const TiebaBlockSettings(
      {required this.extended,
      required this.follow,
      required this.interact,
      required this.chat});
  final bool extended, follow, interact, chat;
}

class TiebaReportThread {
  const TiebaReportThread({required this.id, required this.title});
  final String id, title;
}
