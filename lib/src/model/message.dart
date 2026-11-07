/// 消息页（回复 / @我 / 给我点赞）。
library;

import 'common.dart';

/// 各分类的未读计数。
class MessageUnreadCounts {
  const MessageUnreadCounts({this.reply = 0, this.at = 0, this.like = 0});

  final int reply;
  final int at;
  final int like;
  int get total => reply + at + like;

  int count(TiebaMessageKind kind) => switch (kind) {
        TiebaMessageKind.reply => reply,
        TiebaMessageKind.at => at,
        TiebaMessageKind.like => like,
      };

  MessageUnreadCounts clear(TiebaMessageKind kind) => MessageUnreadCounts(
        reply: kind == TiebaMessageKind.reply ? 0 : reply,
        at: kind == TiebaMessageKind.at ? 0 : at,
        like: kind == TiebaMessageKind.like ? 0 : like,
      );
}

/// 消息分类。
enum TiebaMessageKind {
  /// 回复我的：引用行是「回复我的主题：标题」，正文是对方的回复。
  reply,

  /// @我的：引用行是「提到我的主题：标题」，正文是提到我的那条内容。
  at,

  /// 给我点赞：引用行表示被赞的是主题还是回复，正文为被赞内容。
  like,
}

/// 消息页的一页结果。
class MessagePage {
  final List<TiebaMessage> items;

  /// 是否还有下一页。
  final bool hasMore;

  /// 该分类的未读数；实现方拿不到时为 null，界面按当前页未读条数兜底。
  final int? unread;

  const MessagePage({
    required this.items,
    required this.hasMore,
    this.unread,
  });
}

/// 回复、@我或点赞消息。
class TiebaMessage extends TiebaUser {
  /// 时间。
  DateTime time;

  /// 消息正文；回复和 @我 为对方的内容，点赞消息为被赞内容。
  String content;

  /// 点赞消息中被赞的原文；回复与 @我 的引用行使用 [title]。
  String quoteContent;

  String fname;
  String title;

  /// 消息所属分类。
  final TiebaMessageKind kind;

  /// 是否未读。
  bool unread;

  /// 点赞消息专用：赞的是主题（true）还是某条回复（false）。
  final bool likedThread;

  /// 跳转目标的帖子 id；空串表示无跳转目标。
  String threadId;

  /// 跳转目标的楼层 id；空串表示主题首页。
  String postId;

  TiebaMessage({
    required this.kind,
    required this.unread,
    required this.likedThread,
    required this.time,
    required this.content,
    required this.quoteContent,
    required this.fname,
    required this.title,
    required this.threadId,
    required this.postId,
    required super.portrait,
    required super.uid,
    required super.nameShow,
    required super.username,
  });

  /// 引用行文案，包含关联主题标题或点赞目标类型。
  String get quoteLine {
    switch (kind) {
      case TiebaMessageKind.reply:
        return title.isEmpty ? "回复我的主题" : "回复我的主题：$title";
      case TiebaMessageKind.at:
        return title.isEmpty ? "提到我的主题" : "提到我的主题：$title";
      case TiebaMessageKind.like:
        return likedThread ? "赞了我的主题" : "赞了我的回复";
    }
  }

  /// 点赞消息的展示正文：主题优先取标题，回复优先取引用原文。
  String get likedText {
    if (likedThread) {
      return title.isNotEmpty ? title : content;
    }
    if (quoteContent.isNotEmpty) {
      return quoteContent;
    }
    if (content.isNotEmpty) {
      return content;
    }
    return title;
  }

  /// 时间是否有效。
  bool get hasTime => time.millisecondsSinceEpoch > 0;
}
