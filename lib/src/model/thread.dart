/// 帖子页、楼层、列表项与分页信息。
library;

import 'dart:collection';

import 'author.dart';
import 'common.dart';
import 'content.dart';
import 'poll.dart';

/// 分页信息（界面只关心这三项）。
class TiebaPageInfo {
  /// 当前页码。
  final int currentPage;

  /// 是否还有下一页 / 上一页。
  final bool hasMore;
  final bool hasPrev;

  const TiebaPageInfo({
    required this.currentPage,
    required this.hasMore,
    required this.hasPrev,
  });
}

/// 帖子列表里的一条（吧主页列表 / 推荐流共用）。
class TiebaThreadInfo {
  /// 帖子 id / 标题 / 吧名。
  String id;
  String title;
  String fname;

  /// 创建时间与最近回复时间（unix 秒的字符串形态）。
  String createTime;
  String lastTimeInt;

  /// 浏览数 / 回复数 / 赞 / 踩。
  String viewNum;
  String replyNum;
  String agreeNum;
  String disagreeNum;

  /// 是否置顶。
  bool isTop;

  /// 作者。
  TiebaAuthor author;

  /// 一楼内容段（列表卡片摘要用）。
  List<TiebaPostContent> firstPostContent;

  TiebaThreadInfo({
    required this.id,
    required this.title,
    required this.fname,
    required this.createTime,
    required this.lastTimeInt,
    required this.viewNum,
    required this.replyNum,
    required this.agreeNum,
    required this.disagreeNum,
    required this.isTop,
    required this.author,
    required this.firstPostContent,
  });
}

/// 帖子页：一次 `getThreadPage` 的响应与界面聚合的页面状态。
///
/// 响应字段由实现方填充；`postPage` / `topPn` / `bottomPn` 等分页聚合字段
/// 由界面维护。
class TiebaThreadPage implements TiebaForum {
  // ── 本次响应 ──────────────────────────────────────────────────────────

  /// 本次请求的楼层。
  List<TiebaThreadPagePost> posts;

  /// 本次请求的分页信息。
  TiebaPageInfo page;

  /// 帖元信息。
  TiebaThreadData thread;

  /// 楼层作者（uid → 作者）。
  Map<String, TiebaAuthor> userListSet;

  /// 视频信息。
  TiebaVideoInfo? videoInfo;

  /// 帖是否收藏。
  bool isStored;

  // ── 帖 / 吧 ───────────────────────────────────────────────────────────

  @override
  String fid;

  /// 吧名 / 吧头像。
  @override
  String forumName;

  @override
  String avatar;

  /// 帖子 id。
  String tid;

  /// 标题。
  String title;

  // ── 界面聚合（由界面维护）────────────────────────────────────────────

  /// 按页保存的楼层；正数键为正常页面，负数键为「只看楼主」页面。
  SplayTreeMap<int, List<TiebaThreadPagePost>> postPage = SplayTreeMap();

  /// 正常页面 List。
  List<TiebaThreadPagePost> get postList {
    final l = <TiebaThreadPagePost>[];
    for (final i in postPage.keys) {
      if (i > 0) {
        l.addAll(postPage[i]!);
      }
    }
    return l;
  }

  /// 只看楼主页面 List。
  ///
  /// 只看楼主的页码以负数作键（第 1 页为 -1，第 2 页为 -2），
  /// 此处按页码从 1 开始依次拼回。
  List<TiebaThreadPagePost> get lzPostList {
    final List<int> pages = postPage.keys
        .where((int key) => key < 0)
        .toList(growable: false)
      ..sort((int a, int b) => b.compareTo(a));
    final l = <TiebaThreadPagePost>[];
    for (final i in pages) {
      l.addAll(postPage[i]!);
    }
    return l;
  }

  /// 两端的页码。
  int? topPn;
  int? bottomPn;

  bool hasMore;
  bool hasPrev;

  /// 本页所有图片 / 高清图片。
  List<String> imgs = [];
  List<String> imgsOrgSrc = [];

  /// 只看楼主。
  bool onlyLz;

  /// 使用 pid 进入帖子时的定位楼层。
  String? initPid;

  TiebaThreadPage({
    required this.posts,
    required this.page,
    required this.thread,
    required this.userListSet,
    required this.videoInfo,
    required this.isStored,
    required this.tid,
    required this.title,
    required this.fid,
    required this.forumName,
    required this.avatar,
    this.topPn,
    this.bottomPn,
    this.hasMore = false,
    this.hasPrev = false,
    this.onlyLz = false,
    this.initPid,
  });
}

/// 帖子页里的一个楼层。
class TiebaThreadPagePost extends TiebaPost {
  /// 仅属于本楼层的投票，不从主楼复制。
  final TiebaPoll? poll;
  final bool hasPoll;

  /// 楼层数 / 定位信息。
  String? floor;
  String? lbsInfo;

  /// 服务端返回的 IP 属地，与发帖时主动选择的地点 [lbsInfo] 不同。
  final String ipLocation;

  /// 楼中楼。
  List<TiebaSubPost> subPostList;

  /// 楼中楼数。
  String subPostNumber;

  TiebaThreadPagePost({
    required super.id,
    required super.title,
    required this.floor,
    required this.lbsInfo,
    this.ipLocation = '',
    this.poll,
    this.hasPoll = false,
    required this.subPostList,
    required this.subPostNumber,
    super.agreeNum,
    super.disagreeNum,
    required super.content,
    required super.createTime,
    required super.isFirstFloor,
    required super.isInnerFloor,
    super.hasAgree,
    super.agreeType,
    required super.portrait,
    required super.uid,
    required super.nameShow,
    required super.username,
  });
}

/// 楼中楼里的一条回复。
class TiebaSubPost extends TiebaPost {
  /// 是否为音频回复。
  bool isVoice;

  TiebaSubPost({
    required super.id,
    required super.title,
    required this.isVoice,
    super.agreeNum,
    super.disagreeNum,
    required super.content,
    required super.createTime,
    super.isFirstFloor = false,
    required super.isInnerFloor,
    super.hasAgree,
    super.agreeType,
    required super.portrait,
    required super.uid,
    required super.nameShow,
    required super.username,
  });
}

/// 吧信息（帖子页用）。
class TiebaForumData implements TiebaForum {
  @override
  String avatar;

  @override
  String fid;

  @override
  String forumName;

  TiebaForumData({
    required this.avatar,
    required this.fid,
    required this.forumName,
  });
}

/// 帖元信息。
class TiebaThreadData {
  final TiebaPoll? poll;
  final bool hasPoll;
  String? agreeType;

  /// 主题收藏总数。
  final int storeCount;
  final String authorUid;

  TiebaThreadData(
      {required this.agreeType,
      this.storeCount = 0,
      this.authorUid = '',
      this.poll,
      this.hasPoll = false});
}
