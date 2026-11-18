/// 通知中心里的「吧友互助」与「吧广播」。
///
/// 这两个功能的数据边界不同：
/// - 互助只暴露可见标记、未读数、最近时间和账号级屏蔽开关；
/// - 广播只暴露红点语义（不显示数字）与按吧的只读历史。
///
/// 界面只消费这些模型，不读取原始 IM 或 protobuf 字段。
library;

/// 吧友互助提醒。
///
/// [visible] 是「曾经出现过」的本地可见标记；没有这个标记时不要渲染互助卡片。
/// [unread] 是本地计数，屏蔽（[masked]）时界面必须隐藏数字，且不计入消息总数。
class TiebaMutualHelpNotice {
  const TiebaMutualHelpNotice({
    this.visible = false,
    this.unread = 0,
    this.latestTime,
    this.masked = false,
  });

  /// 是否有本地可见标记。
  final bool visible;

  /// 未读数；[masked] 为 true 时仍可能是非 0，但界面不显示。
  final int unread;

  /// 最近一条互助提醒的时间。
  final DateTime? latestTime;

  /// 账号级屏蔽（`switch_type=45`，`is_mask=1`）。
  final bool masked;

  TiebaMutualHelpNotice copyWith({
    bool? visible,
    int? unread,
    DateTime? latestTime,
    bool? masked,
  }) {
    return TiebaMutualHelpNotice(
      visible: visible ?? this.visible,
      unread: unread ?? this.unread,
      latestTime: latestTime ?? this.latestTime,
      masked: masked ?? this.masked,
    );
  }

  static const TiebaMutualHelpNotice empty = TiebaMutualHelpNotice();
}

/// 吧广播提醒。
///
/// [unread] 只是「有新广播」的布尔语义；合并会话即使返回 37，也只能画红点。
class TiebaBroadcastNotice {
  const TiebaBroadcastNotice({
    this.unread = false,
    this.latestTime,
    this.title = '',
    this.summary = '',
  });

  /// 是否有未读广播。
  final bool unread;

  /// 合并会话的 `last_content_time`。
  final DateTime? latestTime;

  /// 最新广播的标题（可能为空）。
  final String title;

  /// 最新广播的正文摘要（可能为空）。
  final String summary;

  TiebaBroadcastNotice copyWith({
    bool? unread,
    DateTime? latestTime,
    String? title,
    String? summary,
  }) {
    return TiebaBroadcastNotice(
      unread: unread ?? this.unread,
      latestTime: latestTime ?? this.latestTime,
      title: title ?? this.title,
      summary: summary ?? this.summary,
    );
  }

  /// 入口摘要：标题优先，空则正文。
  String get displaySummary => title.isNotEmpty ? title : summary;

  bool get hasData =>
      latestTime != null || title.isNotEmpty || summary.isNotEmpty;

  static const TiebaBroadcastNotice empty = TiebaBroadcastNotice();
}

/// 通知中心概览。
///
/// 没有 IM 的后端返回空概览：互助不出现、广播入口退化为固定副标题，
/// 不伪造红点、摘要和时间。
class TiebaNotificationOverview {
  const TiebaNotificationOverview({
    this.mutualHelp = TiebaMutualHelpNotice.empty,
    this.broadcast = TiebaBroadcastNotice.empty,
    this.systemNotificationsEnabled = true,
  });

  final TiebaMutualHelpNotice mutualHelp;
  final TiebaBroadcastNotice broadcast;

  /// 系统通知权限是否开启；广播红点还需要这个条件。
  final bool systemNotificationsEnabled;

  /// 广播红点：只有未读且系统通知开启时显示。
  bool get broadcastDot => broadcast.unread && systemNotificationsEnabled;

  static const TiebaNotificationOverview empty = TiebaNotificationOverview();
}

/// 吧广播历史条目。
class TiebaBroadcastItem {
  const TiebaBroadcastItem({
    required this.id,
    this.title = '',
    this.content = '',
    this.picUrl = '',
    this.publishTime,
    this.pushUserCount = 0,
    this.pv = 0,
    this.commentCount = 0,
    this.likeCount = 0,
    this.shareCount = 0,
    this.auditStatus = 0,
    this.threadId,
    this.forumId = '',
    this.forumName = '',
    this.forumAvatar = '',
  });

  /// 广播 id；同时是历史分页游标。
  final String id;

  final String title;
  final String content;
  final String picUrl;

  /// 发布时间（已从秒转换为本地时间）。
  final DateTime? publishTime;

  /// 推送人数。
  final int pushUserCount;

  /// 阅读数。
  final int pv;

  /// 评论数 / 点赞数 / 分享数；来自关联帖子的统计，缺失时为 0。
  final int commentCount;
  final int likeCount;
  final int shareCount;

  /// 审核状态。协议没有给值域，界面不显示。
  final int auditStatus;

  /// 关联帖子 id；为空表示只能原地展开正文。
  final String? threadId;

  final String forumId;
  final String forumName;
  final String forumAvatar;

  bool get hasThread => threadId != null && threadId!.isNotEmpty;

  bool get hasImage => picUrl.isNotEmpty;

  bool get hasTitle => title.isNotEmpty;

  bool get hasContent => content.isNotEmpty;

  TiebaBroadcastItem copyWith({int? pv}) {
    return TiebaBroadcastItem(
      id: id,
      title: title,
      content: content,
      picUrl: picUrl,
      publishTime: publishTime,
      pushUserCount: pushUserCount,
      pv: pv ?? this.pv,
      commentCount: commentCount,
      likeCount: likeCount,
      shareCount: shareCount,
      auditStatus: auditStatus,
      threadId: threadId,
      forumId: forumId,
      forumName: forumName,
      forumAvatar: forumAvatar,
    );
  }
}

/// 吧广播历史的一页。
class TiebaBroadcastPage {
  const TiebaBroadcastPage({
    required this.items,
    required this.hasMore,
    this.nextCursor = 0,
  });

  final List<TiebaBroadcastItem> items;
  final bool hasMore;

  /// 下一页游标：本页最后一条广播 id；0 表示从头开始。
  final int nextCursor;

  static const TiebaBroadcastPage empty =
      TiebaBroadcastPage(items: <TiebaBroadcastItem>[], hasMore: false);
}

/// 吧广播发布额度。
class TiebaBroadcastQuota {
  const TiebaBroadcastQuota({required this.used, required this.total});

  /// 本月已用次数。
  final int used;

  /// 本月总额度。
  final int total;

  /// 剩余次数；`total` 为 0 时视为没有额度。
  int get remaining => total <= 0 ? 0 : (total - used).clamp(0, total);

  bool get canPublish => remaining > 0;
}
