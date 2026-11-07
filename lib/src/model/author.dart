/// 作者与视频信息。
library;

import 'common.dart';

/// 当前吧内的管理身份；未知职务不展示标签。
enum TiebaForumRole {
  assistant,
  manager;

  static TiebaForumRole? fromBawuType(String? value) => switch (value) {
        'assist' => assistant,
        'manager' => manager,
        _ => null,
      };
}

/// 一条内容的作者。
class TiebaAuthor extends TiebaUser implements TiebaUserIconData {
  /// 吧等级。
  String? levelID;

  final TiebaForumRole? forumRole;

  @override
  List<String> icons;

  TiebaAuthor({
    required this.icons,
    required this.levelID,
    this.forumRole,
    required super.nameShow,
    required super.portrait,
    required super.uid,
    required super.username,
  });

  /// 用户在帖子/列表里的 id（[uid] 的别名）。
  String get id => uid;
}

/// 帖子/消息携带的视频信息。
class TiebaVideoInfo {
  String? videoUrl;
  String thumbnailUrl;

  /// 视频画面像素尺寸，用于首帧前按真实比例排版。
  int? width;
  int? height;

  TiebaVideoInfo(
      {this.videoUrl, required this.thumbnailUrl, this.width, this.height});
}
