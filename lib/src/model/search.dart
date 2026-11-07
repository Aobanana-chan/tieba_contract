/// 搜索：吧 / 贴 / 用户。
library;

/// 搜索结果的吧。
class TiebaSearchForum {
  late String name;
  late String img;
  late String brief;
  late int member;
  late int post;
  late bool isLike;

  TiebaSearchForum({
    required this.brief,
    required this.img,
    required this.isLike,
    required this.member,
    required this.name,
    required this.post,
  });
}

/// 搜索结果的吧列表。
class SearchForumResult {
  final List<TiebaSearchForum> forums;

  const SearchForumResult({required this.forums});
}

/// 搜索结果的贴。
class TiebaSearchPost {
  /// `1` = 主题帖，`2` = 楼层回复（`filter = 0` 时才会出现）。
  late int type;
  late String tid;

  /// 命中的楼层 id。主题帖为主线 pid，回复为所在楼层 pid；拿不到时空串。
  late String pid;
  late String userAvatar;
  late String username;
  late String title;
  late String forumName;
  late String time;
  late String content;

  TiebaSearchPost({
    required this.content,
    required this.forumName,
    required this.tid,
    required this.time,
    required this.title,
    required this.type,
    required this.userAvatar,
    required this.username,
    this.pid = "",
  });
}

/// 搜索贴一页。
class SearchPostPage {
  final List<TiebaSearchPost> posts;
  final bool hasMore;

  const SearchPostPage({required this.posts, required this.hasMore});
}

/// 搜索结果的用户。
class TiebaUserMatch {
  final String id;
  final String name;
  final String? userNickname;
  final String? showNickname;
  final String portrait;
  final String intro;

  TiebaUserMatch({
    required this.id,
    required this.name,
    required this.userNickname,
    required this.showNickname,
    required this.portrait,
    required this.intro,
  });

  /// 显示名：优先昵称，其次用户名。
  String get displayName =>
      (showNickname?.isNotEmpty ?? false)
          ? showNickname!
          : (userNickname?.isNotEmpty ?? false)
              ? userNickname!
              : name;
}

/// 搜索用户结果。
class SearchUserResult {
  final List<TiebaUserMatch> users;

  const SearchUserResult({required this.users});
}

/// 综合搜索结果里的一张卡。
enum SearchMixedKind { forum, thread }

/// 综合结果卡：吧卡与贴卡共用同一个列表，保持服务端下发的顺序。
class SearchMixedCard {
  final SearchMixedKind kind;
  final TiebaSearchForum? forum;
  final TiebaSearchPost? post;

  SearchMixedCard.forum(TiebaSearchForum this.forum)
      : kind = SearchMixedKind.forum,
        post = null;

  SearchMixedCard.thread(TiebaSearchPost this.post)
      : kind = SearchMixedKind.thread,
        forum = null;
}

/// 综合搜索一页。
class SearchMixedPage {
  final List<SearchMixedCard> cards;
  final bool hasMore;

  const SearchMixedPage({required this.cards, required this.hasMore});
}
