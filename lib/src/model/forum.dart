/// 吧主页：吧头信息、精品分类与帖子列表。
library;

import 'thread.dart';

/// 精品贴分类。
class TiebaGoodPostClassify {
  late String classId;
  late String className;

  TiebaGoodPostClassify({required this.classId, required this.className});
}

/// 吧页页签的二级菜单项（排序或分区）。
///
/// [value] 是提交回服务端的值。
class TiebaForumMenuItem {
  final String text;
  final int value;

  /// 子菜单（如分区「全部」下的「回复 / 发布」）。
  final List<TiebaForumMenuItem> subMenu;

  const TiebaForumMenuItem({
    required this.text,
    required this.value,
    this.subMenu = const <TiebaForumMenuItem>[],
  });
}

/// 吧页的一个页签。
///
/// 页签由实现方按服务端数据生成，界面按列表顺序展示，并在请求时原样传回。
/// [netTabType] / [isGeneralTab] / [type] 是协议值，界面不解释。
class TiebaForumTab {
  /// `tab_id` / `tab_type` / `tab_name`。
  final String id;
  final String type;
  final String name;

  /// 协议字段，原样回传。
  final int netTabType;
  final bool isGeneralTab;

  /// 是否默认选中（协议 `frs_tab_default`）。
  final bool isDefault;

  /// 精品页签：请求时要带 `is_good=1` + [subTabs] 选中的 `cid`。
  final bool isGoodTab;

  /// 排序菜单 / 分区菜单 / 子分类（精品分类或分区）。
  final List<TiebaForumMenuItem> sortMenu;
  final List<TiebaForumMenuItem> partitionMenu;
  final List<TiebaGoodPostClassify> subTabs;

  const TiebaForumTab({
    required this.id,
    required this.type,
    required this.name,
    this.netTabType = 0,
    this.isGeneralTab = false,
    this.isDefault = false,
    this.isGoodTab = false,
    this.sortMenu = const <TiebaForumMenuItem>[],
    this.partitionMenu = const <TiebaForumMenuItem>[],
    this.subTabs = const <TiebaGoodPostClassify>[],
  });
}

/// 吧头卡片所需信息。
class TiebaForumHeader {
  /// 吧头像。
  String avatar;

  /// 吧名。
  String name;

  /// 当前经验 / 升级所需经验。
  String levelupScore;
  String curScore;

  /// 是否已关注 / 已签到。
  bool isLike;
  bool isSigned;

  /// 吧 id / 等级 / 等级名 / 成员数 / 帖子数。
  String fid;
  String levelId;
  String levelName;
  String memberNum;
  String postNum;

  /// 精品分类。
  List<TiebaGoodPostClassify> goodClassify;

  TiebaForumHeader({
    required this.avatar,
    required this.name,
    required this.levelupScore,
    required this.curScore,
    required this.isLike,
    required this.isSigned,
    required this.fid,
    required this.levelId,
    required this.levelName,
    required this.memberNum,
    required this.postNum,
    required this.goodClassify,
  });
}

/// 吧主页一页：吧头 + 帖子列表 + 分页 + 页签。
class ForumPage {
  final List<TiebaThreadInfo> threads;
  final TiebaForumHeader forum;
  final TiebaPageInfo page;

  /// 可用页签，顺序即展示顺序。
  final List<TiebaForumTab> tabs;

  /// 默认选中的页签 id（空串表示取 [tabs] 第一项）。
  final String defaultTabId;

  /// 本页是否来自卡片流，界面据此选择卡片形态。
  final bool isCardFeed;

  /// 服务端上下文，翻页 / 切页签时原样回传。
  final String frsCommonInfo;
  final String topCardId;

  const ForumPage({
    required this.threads,
    required this.forum,
    required this.page,
    this.tabs = const <TiebaForumTab>[],
    this.defaultTabId = '',
    this.isCardFeed = false,
    this.frsCommonInfo = '',
    this.topCardId = '',
  });
}

/// 首页推荐流一页。
class RecommendPage {
  final List<TiebaThreadInfo> threads;

  const RecommendPage({required this.threads});
}
