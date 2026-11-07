/// 跨页面复用的界面基类：用户 / 帖子 / 吧。
library;

import 'content.dart';

/// 用户（作者、回复者、本人等）。
///
/// 实现方可以继承本类以获得默认的 [name]。
abstract class TiebaUser {
  /// 头像 id 或完整 URL；用 `resolveAvatarUrl(portrait)` 得到可加载地址。
  String portrait;

  /// 昵称（`name_show`）。
  String? nameShow;

  /// 用户名（`name`）。
  String? username;

  /// 用户 id。
  String uid;

  TiebaUser({
    required this.portrait,
    required this.uid,
    this.nameShow,
    this.username,
  });

  /// 显示名：优先昵称，其次用户名，都为空则空串。
  String get name =>
      (nameShow?.isNotEmpty ?? false) ? nameShow! : (username ?? "");
}

/// 一条帖子 / 楼层。
abstract class TiebaPost extends TiebaUser {
  /// 帖子 / 楼层 id（pid / spid）。
  String id;

  /// 标题（楼层通常为空）。
  String title;

  /// 创建时间（unix 秒的字符串形态，界面自行格式化）。
  String createTime;

  /// 内容段。
  List<TiebaPostContent> content;

  /// 是否为一楼。
  bool isFirstFloor;

  /// 是否为楼中楼。
  bool isInnerFloor;

  /// 服务端已不再返回、仅从本地缓存恢复的楼层或回复。
  /// 新网络响应中的内容为 false。
  bool isDeleted;

  /// 点赞数 / 反对数 / 是否点赞 / 点赞类型（未知时为 `"0"`）。
  String agreeNum;
  String disagreeNum;
  String hasAgree;
  String agreeType;

  TiebaPost({
    required this.id,
    required this.title,
    required this.createTime,
    required this.content,
    required this.isFirstFloor,
    required this.isInnerFloor,
    this.isDeleted = false,
    this.agreeNum = '0',
    this.disagreeNum = '0',
    this.hasAgree = '0',
    this.agreeType = '0',
    required super.portrait,
    required super.uid,
    super.nameShow,
    super.username,
  });
}

/// 一个吧。
abstract class TiebaForum {
  /// 吧 id。
  late String fid;

  /// 吧名。
  late String forumName;

  /// 吧头像。
  late String avatar;
}

/// 带图标的用户（吧等级等角标）。
abstract class TiebaUserIconData {
  late List<String> icons;
}
