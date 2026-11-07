/// 收藏贴。
library;

import 'common.dart';

/// 收藏贴里的一条媒体（界面取图需要的最小字段）。
class TiebaStoredThreadMedia {
  /// `"pic"` 图片 / `"flash"` 视频。
  final String type;
  final String? bigPic;
  final String? vpic;

  const TiebaStoredThreadMedia({required this.type, this.bigPic, this.vpic});
}

/// 一条收藏的贴。
class TiebaStoredThread extends TiebaUser {
  /// 帖子 id。
  String id;

  /// 观看到的 post 的 id。
  String pid;

  bool isFollowed;
  bool isDeleted;
  String? postNo;
  String? postNoMsg;
  String title;

  List<TiebaStoredThreadMedia>? media;

  /// 新楼层数（`"0"` 表示没有更新）。
  String? count;

  TiebaStoredThread({
    required this.id,
    required this.pid,
    required this.isFollowed,
    required this.isDeleted,
    required this.postNo,
    required this.postNoMsg,
    required this.title,
    required this.media,
    required this.count,
    required super.portrait,
    required super.uid,
    required super.nameShow,
    required super.username,
  });

  /// 列表缩略图：图片取大图，视频取封面。
  String? get getImage {
    for (final i in media ?? <TiebaStoredThreadMedia>[]) {
      if (i.type == "pic") {
        return i.bigPic;
      } else if (i.type == "flash") {
        return i.vpic;
      }
    }
    return null;
  }

  /// 新楼层数；解析失败或未返回时按 0 处理。
  int get newCount => int.tryParse(count ?? "") ?? 0;

  /// 是否有新楼层更新。
  bool get haveNew => newCount > 0;

  /// 底部消息。
  String get bottomMsg => isDeleted ? "该贴子已被删除" : (postNoMsg ?? "");

  /// 底部消息可见性。
  bool get bottomVisiable => haveNew || isDeleted;

  @override
  bool operator ==(Object other) =>
      other is TiebaStoredThread && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// 收藏贴一页。
class ThreadStorePage {
  final List<TiebaStoredThread> threads;

  const ThreadStorePage({required this.threads});
}
