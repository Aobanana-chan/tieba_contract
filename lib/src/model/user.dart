/// 用户主页：个人资料、用户帖、关注吧。
library;

import 'content.dart';
import 'media.dart';
import 'author.dart';

/// 当前账号资料修改结果。接受修改不等于审核通过。
class TiebaProfileUpdateResult {
  const TiebaProfileUpdateResult(
      {this.message = '', this.nicknamePending = false});

  final String message;
  final bool nicknamePending;
}

/// 官方头像设置已接受。响应通常不含地址，调用方刷新资料取得最终头像。
class TiebaAvatarUpdateResult {
  const TiebaAvatarUpdateResult(
      {required this.portraitUrl,
      this.message = '头像已更新',
      this.pendingReview = false});
  final String portraitUrl;
  final String message;

  /// 文件已被服务端接收，但头像仍需审核，不能当作已经生效。
  final bool pendingReview;
}

/// 用户资料（本人与访客共用）。
class TiebaUserProfile {
  /// 用户 id。
  String uid;

  /// 昵称（`name_show`）与用户名（`name`）。
  String? nameShow;
  String? username;

  /// 昵称审核状态；已生效昵称仍由 [nameShow] 提供。
  bool nicknameEditing;
  String editingNickname;

  /// 头像完整 URL。
  String portraitUrl;
  String intro;

  /// 官方性别：`"1"` 男 / `"2"` 女，未知为 null。
  String? sex;

  /// 吧龄（如 `"5.6年"`）。
  String tbAge;

  /// 关注 / 粉丝 / 关注的吧 / 主题帖数 / 回复数 / 获赞。
  String concernNum;
  String fansNum;
  String likeForumNum;
  String postNum;
  String rePostNum;
  String totalAgreeNum;

  /// 资料接口携带的关注吧预览，可能少于 [likeForumNum]，并非完整列表。
  final List<TiebaUserLikeForum> likeForums;

  TiebaUserProfile({
    required this.uid,
    this.nameShow,
    this.username,
    this.nicknameEditing = false,
    this.editingNickname = '',
    required this.portraitUrl,
    required this.intro,
    required this.sex,
    required this.tbAge,
    required this.concernNum,
    required this.fansNum,
    required this.likeForumNum,
    required this.postNum,
    required this.rePostNum,
    required this.totalAgreeNum,
    this.likeForums = const <TiebaUserLikeForum>[],
  });

  /// 显示名：优先昵称，其次用户名。
  String get name =>
      (nameShow?.isNotEmpty ?? false) ? nameShow! : (username ?? "");

  /// 获赞数（缺失按 `"0"`）。
  String get displayTotalAgreeNum =>
      totalAgreeNum.isEmpty ? "0" : totalAgreeNum;
}

/// 用户主页里的一条帖子 / 回复。
class TiebaUserPost {
  final String threadId;
  final String userId;
  final String userPortrait;
  final String username;
  final String title;
  final String createTime;
  final String forumName;
  final bool isThread;
  final String agreeNum;
  final String disagreeNum;
  final String replyNum;
  final String? quotaContent;
  final List<TiebaPostContent> content;
  final List<TiebaMedia> images;
  final TiebaVideoInfo? videoInfo;

  TiebaUserPost({
    required this.threadId,
    required this.userId,
    required this.userPortrait,
    required this.username,
    required this.title,
    required this.createTime,
    required this.forumName,
    required this.isThread,
    required this.agreeNum,
    required this.disagreeNum,
    required this.replyNum,
    required this.quotaContent,
    required this.content,
    required this.images,
    required this.videoInfo,
  });
}

/// 用户主页的一页帖子 / 回复。
class TiebaUserPostPage {
  /// 接口是否要求隐藏（`hide_post`）。
  final bool hidePost;
  final List<TiebaUserPost> posts;

  const TiebaUserPostPage({required this.hidePost, required this.posts});
}

/// 用户主页「关注的吧」一栏。
class TiebaUserLikeForum {
  late String forumId;
  late String forumName;
  late String avatar;
  late String memberCount;
  late String levelId;

  TiebaUserLikeForum({
    required this.forumId,
    required this.forumName,
    required this.avatar,
    required this.memberCount,
    required this.levelId,
  });
}

/// 用户关注吧一页。
class UserForumLikePage {
  final List<TiebaUserLikeForum> forums;

  /// 接口成功但未提供列表，与返回空列表不同。
  final bool unavailable;
  final bool? hasMore;

  const UserForumLikePage({
    required this.forums,
    this.unavailable = false,
    this.hasMore,
  });
}
