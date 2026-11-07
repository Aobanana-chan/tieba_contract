/// 话题页的数据模型。
library;

import 'thread.dart';

/// 话题头信息。
class TiebaTopicDetail {
  /// 解析后的真实话题 ID。旧帖链接里的 `topic_id=0` 不能直接使用。
  final String id;

  final String name;
  final String desc;
  final String cover;

  /// 帖子数（`total_post_num`）。
  final String postNum;

  /// 讨论数（`real_discuss_num`，可能为 0，界面不画 0）。
  final String discussNum;

  /// 热度（`hot_value`，可能为 0，界面不画 0）。
  final String hotValue;

  /// 话题关联吧（可能为空；发帖兜底用）。
  final String fid;
  final String forumName;

  final String createTime;
  final String shareTitle;

  const TiebaTopicDetail({
    required this.id,
    required this.name,
    this.desc = '',
    this.cover = '',
    this.postNum = '',
    this.discussNum = '',
    this.hotValue = '',
    this.fid = '',
    this.forumName = '',
    this.createTime = '',
    this.shareTitle = '',
  });

  bool get hasCover => cover.trim().isNotEmpty;
  bool get hasDescription => desc.trim().isNotEmpty;
  bool get hasDiscuss => _positive(discussNum);
  bool get hasHot => _positive(hotValue);
  bool get hasPostNum => _positive(postNum);

  static bool _positive(String value) => (int.tryParse(value) ?? 0) > 0;
}

/// 话题讨论流的一页。
class TiebaTopicThreadPage {
  final List<TiebaThreadInfo> threads;
  final bool hasMore;

  /// 下一页游标（官方 `page.last_id`）。
  final String lastId;
  final int currentPage;

  const TiebaTopicThreadPage({
    required this.threads,
    required this.hasMore,
    required this.lastId,
    required this.currentPage,
  });
}
