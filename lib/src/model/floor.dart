/// 楼中楼（内层楼）。
library;

import 'author.dart';
import 'thread.dart';

/// 一次 `getInnerFloor` 的结果：父楼层 + 楼中楼列表 + 分页。
class InnerFloor {
  /// 父楼层。
  final TiebaThreadPagePost post;

  /// 楼中楼回复。
  final List<TiebaSubPost> subposts;

  /// 分页。
  final TiebaPageInfo page;

  /// 帖元信息。
  final TiebaThreadData thread;

  /// 作者：父楼层与楼中楼作者的集合（uid → 作者）。
  final Map<String, TiebaAuthor> authors;

  const InnerFloor({
    required this.post,
    required this.subposts,
    required this.page,
    required this.thread,
    required this.authors,
  });
}
