/// 测试与演示用的内存后端。
///
/// 实现 [TiebaApi]，返回一组可交互的本地数据，覆盖首页、吧、贴、消息、
/// 搜索、收藏、话题与个人资料等场景，不访问网络。
/// 通过 `package:tieba_contract/testing.dart` 导出。
library;

import 'dart:math' as math;

import '../../tieba_contract.dart';

part 'demo_seed.dart';

/// 不联网的 [TiebaApi] 实现。
///
/// [loggedIn] 控制初始登录态；接上 [TiebaApiHost] 的回调后，可接收签到、
/// 回复等操作的通知。
class DemoTiebaApi implements TiebaApi {
  DemoTiebaApi({
    this.loggedIn = true,
    this.latency = const Duration(milliseconds: 120),
    TiebaApiHost? host,
  }) : _host = host {
    final KeyValueStore? store = host?.deviceIdStore;
    if (store != null) {
      // 用户主动退出后保持未登录，不再自动登录。
      final bool hasAccountList =
          store.getString('tiebanana.accounts.v1') != null;
      final bool hasCurrentUid = store.getString('uid') != null;
      if (store.getString('demo.loggedOut') == '1' ||
          (hasAccountList && !hasCurrentUid)) {
        loggedIn = false;
      }
    }
    _seedThreads = _buildThreadSeeds();
    for (final _ThreadSeed seed in _seedThreads) {
      _catalog[seed.tid] = seed;
    }
    _likes = <String, LikeForumInfo>{
      for (final _ForumSeed forum in _forums.take(6))
        forum.fid: LikeForumInfo(
          forumId: forum.fid,
          forumName: forum.name,
          avatar: forum.avatar,
          levelId: '${forum.level}',
          isSign: forum.name == '孙笑川' || forum.name == '碧蓝航线' ? '1' : '0',
        ),
    };
    _storedTids.addAll(<String>[
      '8301124590',
      '8324419027',
      '8334012580',
      '8347721055',
    ]);
  }

  /// 演示用登录态（可通过 [logout] / [applyWebviewLogin] 切换）。
  bool loggedIn;

  /// 每个接口的模拟延迟；设为 [Duration.zero] 可立即返回。
  final Duration latency;

  final TiebaApiHost? _host;

  late final List<_ThreadSeed> _seedThreads;
  final Map<String, _ThreadSeed> _catalog = <String, _ThreadSeed>{};
  final Map<String, _ForumSeed> _extraForums = <String, _ForumSeed>{};
  final Map<String, List<_ThreadSeed>> _forumThreadCache =
      <String, List<_ThreadSeed>>{};
  final Map<String, List<_ThreadSeed>> _topicThreadCache =
      <String, List<_ThreadSeed>>{};
  final Map<String, TiebaTopicDetail> _topicMeta = <String, TiebaTopicDetail>{};
  final Set<String> _storedTids = <String>{};
  final Set<String> _likedPosts = <String>{};
  final Set<String> _dislikedPosts = <String>{};
  final Map<String, Set<int>> _pollSelections = <String, Set<int>>{};
  late final Map<String, LikeForumInfo> _likes;

  List<_ThreadSeed>? _recommendSeeds;

  String _profileName = _me.name;
  String _profileIntro = _me.intro;
  String _profileSex = '${_me.sex}';
  String _profileAvatar = _me.avatar;

  List<_ThreadSeed> _ensureForumThreads(String rawKeyword,
      {bool good = false}) {
    final String kw = _normalizeForum(rawKeyword);
    final String key = '$kw|$good';
    return _forumThreadCache.putIfAbsent(key, () {
      final List<_ThreadSeed> seeds = <_ThreadSeed>[
        for (final _ThreadSeed seed in _seedThreads)
          if (seed.forumName == kw && seed.isGood == good) seed,
      ];
      for (int i = 0; i < 24; i++) {
        seeds.add(_generatedSeed(kw, i, good: good));
      }
      seeds.sort((_ThreadSeed a, _ThreadSeed b) {
        if (a.isTop != b.isTop) {
          return a.isTop ? -1 : 1;
        }
        return a.lastReplyAgo.compareTo(b.lastReplyAgo);
      });
      return seeds;
    });
  }

  List<_ThreadSeed> _recommendPool() {
    final List<_ThreadSeed>? cached = _recommendSeeds;
    if (cached != null) return cached;
    final List<_ThreadSeed> seeds = <_ThreadSeed>[..._seedThreads];
    for (int i = 0; i < 40; i++) {
      final _ForumSeed forum = _forums[i % _forums.length];
      seeds.add(_generatedSeed(forum.name, 100 + i));
    }
    seeds.sort((_ThreadSeed a, _ThreadSeed b) =>
        a.lastReplyAgo.compareTo(b.lastReplyAgo));
    _recommendSeeds = seeds;
    return seeds;
  }

  _ThreadSeed _seedFor(String tid) {
    final _ThreadSeed? cached = _catalog[tid];
    if (cached != null) return cached;
    final _ThreadSeed seed = _standaloneSeed(tid);
    _catalog[tid] = seed;
    return seed;
  }

  _ThreadSeed _standaloneSeed(String tid) {
    final int salt = _stableHash(tid);
    final _Persona author = _personas[salt % _personas.length];
    return _ThreadSeed(
      tid: tid,
      fid: '1',
      forumName: '生活',
      title: '最近整理的一些碎片',
      author: author,
      createdAgo: Duration(hours: 2 + salt % 30),
      lastReplyAgo: Duration(minutes: 3 + salt % 40),
      views: 420 + salt % 3200,
      replies: 12 + salt % 24,
      agrees: 18 + salt % 80,
      disagrees: salt % 3,
      simplePostIds: true,
      posts: <_PostSeed>[
        _post(
          author,
          <TiebaPostContent>[
            _text('把最近拍到的、想到的随手记在这里，不一定有主题。'),
          ],
          agree: 18 + salt % 40,
          ip: _ipLocations[salt % _ipLocations.length],
        ),
        _post(
          _personas[(salt + 3) % _personas.length],
          <TiebaPostContent>[_text('先坐下了，等更新。')],
          agree: 6,
          ip: '浙江',
        ),
        _post(
          _personas[(salt + 7) % _personas.length],
          <TiebaPostContent>[_text('这个视角挺有意思的。')],
          agree: 4,
          ip: '江苏',
        ),
        _post(
          _personas[(salt + 11) % _personas.length],
          <TiebaPostContent>[_text('收藏了，慢慢看。')],
          agree: 2,
          ip: '上海',
        ),
        _post(
          _personas[(salt + 13) % _personas.length],
          <TiebaPostContent>[_text('有没有后续？')],
          agree: 1,
          ip: '四川',
        ),
        _post(
          _personas[(salt + 17) % _personas.length],
          <TiebaPostContent>[_text('帮顶。')],
          agree: 0,
          ip: '北京',
        ),
      ],
    );
  }

  _ThreadSeed _generatedSeed(String rawKeyword, int index,
      {bool good = false}) {
    final String kw = _normalizeForum(rawKeyword);
    final _ForumSeed forum = _ensureForum(kw);
    final int salt = _stableHash('$kw|$index|$good');
    final _Persona author = _personas[salt % _personas.length];
    final String title = _titleFor(kw, index, good: good);
    final String tid = _stableTid('$kw|$index|$good');
    final _ThreadSeed seed = _ThreadSeed(
      tid: tid,
      fid: forum.fid,
      forumName: forum.name,
      title: title,
      author: author,
      createdAgo: Duration(minutes: 40 + (index * 137) % (60 * 24 * 5)),
      lastReplyAgo: Duration(minutes: 2 + (index * 13) % (60 * 24)),
      views: 320 + (index * 937) % 26000,
      replies: 6 + (index * 11) % 180,
      agrees: 8 + (index * 19) % 360,
      disagrees: index % 7,
      isGood: good,
      posts: <_PostSeed>[
        _post(
          author,
          <TiebaPostContent>[
            _text(_openingFor(kw, index)),
            if (index % 3 == 0)
              _photo(_photoKeys[(index + _stableHash(kw)) % _photoKeys.length]),
          ],
          subs: <_SubSeed>[
            _SubSeed(
              _personas[(salt + 5) % _personas.length],
              _fillerSubReplies[index % _fillerSubReplies.length],
              agree: index % 9,
            ),
          ],
          agree: 8 + (index * 19) % 360,
          ip: _ipLocations[index % _ipLocations.length],
        ),
        _post(
          _personas[(salt + 3) % _personas.length],
          <TiebaPostContent>[
            _text(_fillerReplies[index % _fillerReplies.length]),
          ],
          agree: index % 30,
          ip: _ipLocations[(index + 2) % _ipLocations.length],
        ),
        _post(
          _personas[(salt + 8) % _personas.length],
          <TiebaPostContent>[
            _text(_fillerReplies[(index + 6) % _fillerReplies.length]),
          ],
          agree: index % 18,
          ip: _ipLocations[(index + 5) % _ipLocations.length],
        ),
      ],
    );
    _catalog[tid] = seed;
    return seed;
  }

  _ForumSeed _ensureForum(String rawKeyword) {
    final String kw = _normalizeForum(rawKeyword);
    for (final _ForumSeed forum in _forums) {
      if (forum.name == kw) return forum;
    }
    final _ForumSeed? extra = _extraForums[kw];
    if (extra != null) return extra;
    final int salt = _stableHash(kw);
    final _ForumSeed created = _ForumSeed(
      fid: '${9000 + salt % 999}',
      name: kw,
      avatar: 'https://picsum.photos/seed/tieba-${salt % 997}/200/200',
      brief: '$kw相关的话题与日常',
      member: 12000 + salt % 980000,
      post: 30000 + salt % 4200000,
      level: salt % 12 + 1,
      levelName: '${salt % 12 + 1}级',
    );
    _extraForums[kw] = created;
    return created;
  }

  _Persona _personaByUid(String uid) {
    if (uid == _me.uid) {
      return _Persona(
        uid: _me.uid,
        username: _me.username,
        name: _profileName,
        avatar: _profileAvatar,
        intro: _profileIntro,
        sex: int.tryParse(_profileSex) ?? _me.sex,
        level: _me.level,
      );
    }
    for (final _Persona persona in _personas) {
      if (persona.uid == uid) return persona;
    }
    final int salt = _stableHash(uid);
    return _Persona(
      uid: uid,
      username: 'tb_${uid.hashCode.abs()}',
      name: '贴吧用户_${salt % 9999}',
      avatar: '$_avatarHost${1 + salt % 70}',
      intro: '',
      sex: salt.isEven ? 1 : 2,
      level: 1 + salt % 12,
    );
  }

  List<_PostSeed> _postsFor(_ThreadSeed seed) {
    final int total =
        math.max(seed.posts.length, math.min(seed.replies + 1, 240));
    final List<_PostSeed> posts = <_PostSeed>[...seed.posts];
    for (int i = posts.length; i < total; i++) {
      posts.add(_fillerPost(seed, i));
    }
    return posts;
  }

  _PostSeed _fillerPost(_ThreadSeed seed, int index) {
    final int salt = _stableHash('${seed.tid}-$index');
    final _Persona author = _personas[salt % _personas.length];
    final int agree = salt % 24;
    return _post(
      author,
      <TiebaPostContent>[
        _text(_fillerReplies[salt % _fillerReplies.length]),
      ],
      agree: agree,
      ip: _ipLocations[(salt ~/ 3) % _ipLocations.length],
    );
  }

  String _postId(_ThreadSeed seed, int index) => seed.simplePostIds
      ? '${index + 1}'
      : '${seed.tid}${(index + 1).toString().padLeft(3, '0')}';

  TiebaThreadPagePost _buildPost(
      _ThreadSeed seed, int index, _PostSeed source) {
    final String id = _postId(seed, index);
    final bool liked = _likedPosts.contains(id);
    final bool disliked = _dislikedPosts.contains(id);
    final List<TiebaSubPost> subs = _buildSubPosts(seed, id, index, source);
    return TiebaThreadPagePost(
      id: id,
      title: '',
      floor: '${index + 1}',
      lbsInfo: source.lbs,
      ipLocation: source.ip,
      poll: index == 0 ? _pollOf(seed) : null,
      hasPoll: index == 0 && seed.poll != null,
      subPostList: subs,
      subPostNumber: '${subs.length}',
      agreeNum: '${source.agree + (liked ? 1 : 0)}',
      disagreeNum: '${source.disagree + (disliked ? 1 : 0)}',
      hasAgree: liked ? '1' : '0',
      agreeType: disliked ? '5' : (liked ? '2' : '0'),
      content: source.parts,
      createTime: _unixAgo(seed.createdAgo + Duration(minutes: index * 4)),
      isFirstFloor: index == 0,
      isInnerFloor: false,
      portrait: source.author.avatar,
      uid: source.author.uid,
      nameShow: source.author.name,
      username: source.author.username,
    );
  }

  List<TiebaSubPost> _buildSubPosts(
      _ThreadSeed seed, String postId, int index, _PostSeed source) {
    final List<_SubSeed> sources = source.subs.isNotEmpty
        ? source.subs
        : <_SubSeed>[
            for (int i = 0; i < 3; i++)
              _SubSeed(
                _personas[(index + i + 2) % _personas.length],
                _fillerSubReplies[(index + i) % _fillerSubReplies.length],
                agree: (index * 3 + i) % 12,
              ),
          ];
    return <TiebaSubPost>[
      for (int i = 0; i < sources.length; i++)
        TiebaSubPost(
          id: '${postId}_s${i + 1}',
          title: '',
          isVoice: false,
          agreeNum: '${sources[i].agree}',
          disagreeNum: '0',
          hasAgree: '0',
          agreeType: '0',
          content: <TiebaPostContent>[
            TiebaTextContent(
              text: sources[i].text,
              uid: sources[i].author.uid,
            ),
          ],
          createTime:
              _unixAgo(seed.createdAgo + Duration(minutes: index * 4 + i + 1)),
          isInnerFloor: true,
          portrait: sources[i].author.avatar,
          uid: sources[i].author.uid,
          nameShow: sources[i].author.name,
          username: sources[i].author.username,
        ),
    ];
  }

  TiebaPoll? _pollOf(_ThreadSeed seed) {
    final _PollSeed? source = seed.poll;
    if (source == null) return null;
    final Set<int> selected =
        _pollSelections.putIfAbsent(seed.tid, () => <int>{});
    final int totalVotes = source.options
        .fold<int>(0, (int sum, _PollOptionSeed o) => sum + o.votes);
    return TiebaPoll(
      title: source.title,
      multiple: source.multiple,
      participantCount: source.participants,
      totalVotes: totalVotes,
      optionCount: source.options.length,
      hasVoted: selected.isNotEmpty,
      selectedIds: selected,
      endTime:
          DateTime.now().add(const Duration(days: 3)).millisecondsSinceEpoch ~/
              1000,
      options: <TiebaPollOption>[
        for (final _PollOptionSeed option in source.options)
          TiebaPollOption(
            id: option.id,
            text: option.text,
            votes: option.votes,
            hasVoted: selected.contains(option.id),
          ),
      ],
    );
  }

  TiebaThreadInfo _threadInfo(_ThreadSeed seed) => TiebaThreadInfo(
        id: seed.tid,
        title: seed.title,
        fname: seed.forumName,
        createTime: _unixAgo(seed.createdAgo),
        lastTimeInt: _unixAgo(seed.lastReplyAgo),
        viewNum: '${seed.views}',
        replyNum: '${seed.replies}',
        agreeNum: '${seed.agrees}',
        disagreeNum: '${seed.disagrees}',
        isTop: seed.isTop,
        author: seed.author.author(),
        firstPostContent: seed.posts.first.parts,
      );

  TiebaForumHeader _forumHeader(_ForumSeed forum) {
    final LikeForumInfo? liked = _likes[forum.fid];
    return TiebaForumHeader(
      avatar: forum.avatar,
      name: forum.name,
      levelupScore: '${1200 + forum.level * 80}',
      curScore: '${3400 + forum.level * 120}',
      isLike: liked != null,
      isSigned: liked?.isSign == '1',
      fid: forum.fid,
      levelId: '${liked == null ? 1 : forum.level}',
      levelName: '${liked == null ? 1 : forum.level}级',
      memberNum: '${forum.member}',
      postNum: '${forum.post}',
      goodClassify: <TiebaGoodPostClassify>[
        TiebaGoodPostClassify(classId: '1', className: '公告'),
        TiebaGoodPostClassify(classId: '2', className: '攻略'),
        TiebaGoodPostClassify(classId: '3', className: '晒图'),
      ],
    );
  }

  List<TiebaForumTab> _forumTabs() => <TiebaForumTab>[
        const TiebaForumTab(
          id: 'main',
          type: 'main',
          name: '看帖',
          isDefault: true,
          isGeneralTab: true,
        ),
        const TiebaForumTab(
          id: 'hot',
          type: 'hot',
          name: '热门',
          isGeneralTab: true,
          sortMenu: <TiebaForumMenuItem>[
            TiebaForumMenuItem(text: '最新回复', value: 0),
            TiebaForumMenuItem(text: '最新发布', value: 1),
          ],
        ),
        TiebaForumTab(
          id: 'good',
          type: 'good',
          name: '精品',
          isGoodTab: true,
          subTabs: <TiebaGoodPostClassify>[
            TiebaGoodPostClassify(classId: '1', className: '公告'),
            TiebaGoodPostClassify(classId: '2', className: '攻略'),
            TiebaGoodPostClassify(classId: '3', className: '晒图'),
          ],
        ),
      ];

  TiebaUserLikeForum _likeForumView(_ForumSeed forum, {String level = '6'}) =>
      TiebaUserLikeForum(
        forumId: forum.fid,
        forumName: forum.name,
        avatar: forum.avatar,
        memberCount: '${forum.member}',
        levelId: level,
      );

  TiebaUserPost _userPostView(_ThreadSeed seed, {bool isThread = true}) {
    final List<TiebaMedia> images = <TiebaMedia>[
      for (final TiebaPostContent content in seed.posts.first.parts)
        if (content is TiebaImageContent && content.originalSrc.isNotEmpty)
          TiebaMedia(
            bigPic: content.displaySrc,
            originPic: content.originalSrc,
          ),
    ];
    return TiebaUserPost(
      threadId: seed.tid,
      userId: seed.author.uid,
      userPortrait: seed.author.avatar,
      username: seed.author.name,
      title: seed.title,
      createTime: _unixAgo(seed.createdAgo),
      forumName: seed.forumName,
      isThread: isThread,
      agreeNum: '${seed.agrees}',
      disagreeNum: '${seed.disagrees}',
      replyNum: '${seed.replies}',
      quotaContent: isThread ? null : '引用自：${seed.title}',
      content: seed.posts.first.parts,
      images: images,
      videoInfo: seed.video,
    );
  }

  TiebaStoredThread _storedThreadView(_ThreadSeed seed) {
    final List<TiebaStoredThreadMedia> media = <TiebaStoredThreadMedia>[
      for (final TiebaPostContent content in seed.posts.first.parts)
        if (content is TiebaImageContent && content.displaySrc.isNotEmpty)
          TiebaStoredThreadMedia(
            type: 'pic',
            bigPic: content.displaySrc,
          )
        else if (content is TiebaVideoContent &&
            (content.cover ?? '').isNotEmpty)
          TiebaStoredThreadMedia(type: 'flash', vpic: content.cover),
    ];
    final int newCount = seed.replies % 4;
    return TiebaStoredThread(
      id: seed.tid,
      pid: _postId(seed, 0),
      isFollowed: true,
      isDeleted: false,
      postNo: '${seed.replies + 1}',
      postNoMsg: '更新到第 ${seed.replies + 1} 楼',
      title: seed.title,
      media: media,
      count: '$newCount',
      portrait: seed.author.avatar,
      uid: seed.author.uid,
      nameShow: seed.author.name,
      username: seed.author.username,
    );
  }

  List<TiebaMessage> _messagesOf(TiebaMessageKind kind, int pn) {
    if (pn > 1) return <TiebaMessage>[];
    final List<_ThreadSeed> pool = _seedThreads;
    final List<TiebaMessage> messages = <TiebaMessage>[];
    for (int i = 0; i < 5; i++) {
      final _ThreadSeed seed = pool[(i * 3 + kind.index) % pool.length];
      final _Persona actor = _personas[(i + kind.index + 2) % _personas.length];
      final String content;
      final String quote;
      final String title;
      switch (kind) {
        case TiebaMessageKind.reply:
          content = <String>[
            '这个我也有同感，最近下班之后完全不想动。',
            '图拍得不错，第二张的光线很好。',
            '请问后来解决了吗？我也遇到了一样的问题。',
            '刚看到，先收藏了，回头慢慢看。',
            '细节补充一下：我这边用的是另一套配置，也能跑。',
          ][i];
          quote = '';
          title = seed.title;
        case TiebaMessageKind.at:
          content = <String>[
            '@$_profileName 你之前说的那家店我去吃了，确实不错。',
            '@$_profileName 这组照片的后期思路能分享一下吗？',
            '@$_profileName 周末有空一起去看展吗？',
            '@$_profileName 上次那个问题后来怎么处理的？',
            '@$_profileName 这个帖子你应该会感兴趣。',
          ][i];
          quote = '';
          title = seed.title;
        case TiebaMessageKind.like:
          content = '觉得你的这条内容挺有帮助的。';
          quote = i.isEven
              ? seed.title
              : seed.posts.first.parts
                  .whereType<TiebaTextContent>()
                  .map((TiebaTextContent c) => c.text)
                  .join(' ')
                  .split('。')
                  .first;
          title = seed.title;
      }
      messages.add(TiebaMessage(
        kind: kind,
        unread: i < (kind == TiebaMessageKind.reply ? 3 : 2),
        likedThread: kind == TiebaMessageKind.like && i.isEven,
        time: DateTime.now().subtract(Duration(hours: i * 3 + kind.index + 1)),
        content: content,
        quoteContent: quote,
        fname: seed.forumName,
        title: title,
        threadId: seed.tid,
        postId: kind == TiebaMessageKind.like ? '' : _postId(seed, i + 1),
        portrait: actor.avatar,
        uid: actor.uid,
        nameShow: actor.name,
        username: actor.username,
      ));
    }
    return messages;
  }

  List<TiebaSearchPost> _searchResults(String keywords, {String? fname}) {
    final String kw = keywords.trim();
    final List<TiebaSearchPost> results = <TiebaSearchPost>[];
    for (final _ThreadSeed seed in _seedThreads) {
      final String firstText = seed.posts.first.parts
          .whereType<TiebaTextContent>()
          .map((TiebaTextContent c) => c.text)
          .join(' ');
      if (kw.isEmpty ||
          seed.title.contains(kw) ||
          firstText.contains(kw) ||
          seed.forumName.contains(kw)) {
        results.add(TiebaSearchPost(
          type: 1,
          tid: seed.tid,
          pid: _postId(seed, 0),
          userAvatar: seed.author.avatar,
          username: seed.author.name,
          title: seed.title,
          forumName: fname ?? seed.forumName,
          time: _unixAgo(seed.createdAgo),
          content: firstText,
        ));
      }
    }
    for (int i = 0; results.length < 8; i++) {
      final _ForumSeed forum = _forums[(i + _stableHash(kw)) % _forums.length];
      final _ThreadSeed seed = _generatedSeed(forum.name, 60 + i);
      final String firstText = seed.posts.first.parts
          .whereType<TiebaTextContent>()
          .map((TiebaTextContent c) => c.text)
          .join(' ');
      results.add(TiebaSearchPost(
        type: i.isEven ? 1 : 2,
        tid: seed.tid,
        pid: _postId(seed, i.isEven ? 0 : 1),
        userAvatar: seed.author.avatar,
        username: seed.author.name,
        title: i.isEven ? seed.title : '回复：${seed.title}',
        forumName: fname ?? seed.forumName,
        time: _unixAgo(seed.createdAgo),
        content:
            i.isEven ? firstText : _fillerReplies[i % _fillerReplies.length],
      ));
    }
    return results;
  }

  List<_ThreadSeed> _topicSeeds(String name) {
    return _topicThreadCache.putIfAbsent(name, () {
      final String fid = _topicMeta[name]?.fid ?? '5';
      final String forumName = _topicMeta[name]?.forumName ?? '抗压背锅';
      final List<String> titles = <String>[
        '$name：大家觉得这次主要问题出在哪？',
        '$name 之后，队伍需要补强哪个位置',
        '理性讨论：$name 这场的几个关键节点',
        '看了三遍回放，$name 其实没有那么糟',
        '关于 $name，我有一点不同的看法',
        '$name 数据整理（截至今天）',
        '如果只能改一个地方，$name 应该先动哪里',
        '$name 相关，想听听大家怎么看',
      ];
      final List<_ThreadSeed> seeds = <_ThreadSeed>[];
      for (int i = 0; i < titles.length; i++) {
        final _Persona author = _personas[(i + 2) % _personas.length];
        final String tid = _stableTid('topic|$name|$i');
        final _ThreadSeed seed = _ThreadSeed(
          tid: tid,
          fid: fid,
          forumName: forumName,
          title: titles[i],
          author: author,
          createdAgo: Duration(hours: i * 2 + 1),
          lastReplyAgo: Duration(minutes: i * 7 + 3),
          views: 2400 + i * 1730,
          replies: 18 + i * 11,
          agrees: 40 + i * 27,
          disagrees: i % 4,
          posts: <_PostSeed>[
            _post(
              author,
              <TiebaPostContent>[
                _text(
                  '主要是想听听不同意见，先把几个关键时间点列一下。\n'
                  '如果只看结果很容易下结论，但过程里其实还有不少细节。',
                ),
              ],
              subs: <_SubSeed>[
                _SubSeed(
                  _personas[(i + 7) % _personas.length],
                  _fillerSubReplies[i % _fillerSubReplies.length],
                  agree: i * 2,
                ),
              ],
              agree: 40 + i * 27,
              ip: _ipLocations[i % _ipLocations.length],
            ),
            _post(
              _personas[(i + 5) % _personas.length],
              <TiebaPostContent>[
                _text(_fillerReplies[(i * 4) % _fillerReplies.length]),
              ],
              agree: 12 + i * 3,
              ip: _ipLocations[(i + 2) % _ipLocations.length],
            ),
          ],
        );
        _catalog[tid] = seed;
        seeds.add(seed);
      }
      return seeds;
    });
  }

  Future<void> _wait() => latency == Duration.zero
      ? Future<void>.value()
      : Future<void>.delayed(latency);

  NetAPIError _error(String message) => NetAPIError(
        type: NetAPIErrorType.actionFalied,
        redoTimes: 0,
        errorMessage: message,
      );

  void _requireLogin() {
    if (!loggedIn) throw _error('请先登录');
  }

  // ── 登录态 ──────────────────────────────────────────────────────────────

  @override
  bool get isLogin => loggedIn;

  @override
  Future<void> init() async => _wait();

  @override
  Future<bool> checkLogin() async {
    await _wait();
    return loggedIn;
  }

  @override
  void logout() {
    loggedIn = false;
    _host?.deviceIdStore.setString('demo.loggedOut', '1');
  }

  @override
  Future<bool> applyWebviewLogin(Map<String, String> hostCookies) async {
    await _wait();
    loggedIn = true;
    _host?.deviceIdStore.setString('demo.loggedOut', '0');
    return true;
  }

  @override
  Future<MyUserData> getMyInfo() async {
    await _wait();
    _requireLogin();
    return MyUserData(
      id: int.parse(_me.uid),
      uid: int.parse(_me.uid),
      name: _me.username,
      nameShow: _profileName,
      isLogin: true,
      isVerify: false,
      portrait: _profileAvatar,
      portraitUrl: _profileAvatar,
      likeForumNum: _likes.length,
      postNum: 128,
      concernNum: 186,
      fansNum: 624,
      intro: _profileIntro,
      userSex: int.tryParse(_profileSex),
    );
  }

  @override
  Future<TiebaProfileUpdateResult> updateUserProfile({
    String? nickname,
    String? intro,
    String? sex,
  }) async {
    await _wait();
    _requireLogin();
    if (nickname != null && nickname.trim().isNotEmpty) {
      _profileName = nickname.trim();
    }
    if (intro != null) {
      _profileIntro = intro;
    }
    if (sex != null && (sex == '1' || sex == '2')) {
      _profileSex = sex;
    }
    return const TiebaProfileUpdateResult(message: '资料已保存');
  }

  @override
  Future<TiebaAvatarUpdateResult> updateAvatar(UploadFile image) async {
    await _wait();
    _requireLogin();
    _profileAvatar =
        '$_avatarHost${1 + _stableHash(image.resourceId) % 70}&v=${DateTime.now().millisecondsSinceEpoch}';
    return TiebaAvatarUpdateResult(
      portraitUrl: _profileAvatar,
      message: '头像已更新',
    );
  }

  // ── 读取 ────────────────────────────────────────────────────────────────

  @override
  Future<TiebaThreadPage> getThreadPage(
    String kz, {
    String? pid,
    int pn = 1,
    int rn = 30,
    bool onlyLz = false,
  }) async {
    await _wait();
    final _ThreadSeed seed = _seedFor(kz);
    final List<_PostSeed> all = _postsFor(seed);
    final List<MapEntry<int, _PostSeed>> indexed = <MapEntry<int, _PostSeed>>[
      for (int i = 0; i < all.length; i++) MapEntry<int, _PostSeed>(i, all[i]),
    ];
    final List<MapEntry<int, _PostSeed>> selected = onlyLz
        ? indexed
            .where((MapEntry<int, _PostSeed> entry) =>
                entry.value.author.uid == seed.author.uid)
            .toList()
        : indexed;
    final int pageSize = rn < 1 ? 30 : rn;
    int page = pn < 1 ? 1 : pn;
    if (pid != null && pid.isNotEmpty) {
      final int at = selected.indexWhere(
          (MapEntry<int, _PostSeed> entry) => _postId(seed, entry.key) == pid);
      if (at >= 0) page = at ~/ pageSize + 1;
    }
    final int start = (page - 1) * pageSize;
    final int end = math.min(start + pageSize, selected.length);
    final List<TiebaThreadPagePost> posts = <TiebaThreadPagePost>[
      for (final MapEntry<int, _PostSeed> entry
          in selected.sublist(math.min(start, selected.length), end))
        _buildPost(seed, entry.key, entry.value),
    ];
    final Map<String, TiebaAuthor> authors = <String, TiebaAuthor>{
      seed.author.uid: seed.author.author(),
    };
    for (final TiebaThreadPagePost post in posts) {
      authors[post.uid] = _personaByUid(post.uid).author();
      for (final TiebaSubPost sub in post.subPostList) {
        authors[sub.uid] = _personaByUid(sub.uid).author();
      }
    }
    return TiebaThreadPage(
      posts: posts,
      page: TiebaPageInfo(
        currentPage: page,
        hasMore: end < selected.length,
        hasPrev: page > 1,
      ),
      thread: TiebaThreadData(
        agreeType: '0',
        authorUid: seed.author.uid,
        poll: seed.poll == null ? null : _pollOf(seed),
        hasPoll: seed.poll != null,
      ),
      userListSet: authors,
      videoInfo: seed.video,
      isStored: _storedTids.contains(seed.tid),
      tid: seed.tid,
      title: seed.title,
      fid: seed.fid,
      forumName: seed.forumName,
      avatar: _ensureForum(seed.forumName).avatar,
      topPn: page,
      bottomPn: page,
      hasMore: end < selected.length,
      hasPrev: page > 1,
      onlyLz: onlyLz,
    );
  }

  @override
  Future<ForumPage> getForumPage({
    required String kw,
    required int pn,
    int rn = 20,
    int sortType = 0,
    bool isgood = false,
    int cid = 0,
    TiebaForumTab? tab,
    int partitionType = 0,
    String frsCommonInfo = '',
    String topCardId = '',
  }) async {
    await _wait();
    final String keyword = _normalizeForum(kw);
    final _ForumSeed forum = _ensureForum(keyword);
    final List<_ThreadSeed> all =
        _ensureForumThreads(keyword, good: isgood || (tab?.isGoodTab ?? false));
    final List<_ThreadSeed> ordered = List<_ThreadSeed>.of(all);
    if (sortType == 1) {
      ordered.sort((_ThreadSeed a, _ThreadSeed b) {
        if (a.isTop != b.isTop) {
          return a.isTop ? -1 : 1;
        }
        return a.createdAgo.compareTo(b.createdAgo);
      });
    }
    final int page = pn < 1 ? 1 : pn;
    final int pageSize = rn < 1 ? 20 : rn;
    final int start = (page - 1) * pageSize;
    final int end = math.min(start + pageSize, ordered.length);
    return ForumPage(
      threads: <TiebaThreadInfo>[
        for (final _ThreadSeed seed
            in ordered.sublist(math.min(start, ordered.length), end))
          _threadInfo(seed),
      ],
      forum: _forumHeader(forum),
      page: TiebaPageInfo(
        currentPage: page,
        hasMore: end < ordered.length,
        hasPrev: page > 1,
      ),
      tabs: _forumTabs(),
      defaultTabId: 'main',
      isCardFeed: keyword == '图片',
      frsCommonInfo: 'demo-frs-$keyword',
      topCardId: '',
    );
  }

  @override
  Future<RecommendPage> getRecommThread(int pageThreadCount, int pn) async {
    await _wait();
    final List<_ThreadSeed> pool = _recommendPool();
    final int pageSize = pageThreadCount < 1 ? 15 : pageThreadCount;
    final int page = pn < 1 ? 1 : pn;
    final int start = (page - 1) * pageSize;
    final int end = math.min(start + pageSize, pool.length);
    if (start >= pool.length) return const RecommendPage(threads: []);
    return RecommendPage(
      threads: <TiebaThreadInfo>[
        for (final _ThreadSeed seed
            in pool.sublist(math.min(start, pool.length), end))
          _threadInfo(seed),
      ],
    );
  }

  @override
  Future<InnerFloor> getInnerFloor(
    String kz,
    String pid, {
    String spid = "",
    int pn = 1,
    int rn = 20,
  }) async {
    await _wait();
    final _ThreadSeed seed = _seedFor(kz);
    final List<_PostSeed> all = _postsFor(seed);
    int index = -1;
    for (int i = 0; i < all.length; i++) {
      if (_postId(seed, i) == pid) {
        index = i;
        break;
      }
    }
    if (index < 0) {
      index = 0;
    }
    final int safeIndex = index.clamp(0, all.length - 1);
    final _PostSeed parent = all[safeIndex];
    final TiebaThreadPagePost post = _buildPost(seed, safeIndex, parent);
    final Map<String, TiebaAuthor> authors = <String, TiebaAuthor>{
      parent.author.uid: parent.author.author(),
    };
    for (final TiebaSubPost sub in post.subPostList) {
      authors[sub.uid] = _personaByUid(sub.uid).author();
    }
    return InnerFloor(
      post: post,
      subposts: post.subPostList,
      page: TiebaPageInfo(currentPage: pn, hasMore: false, hasPrev: false),
      thread: TiebaThreadData(
        agreeType: '0',
        authorUid: seed.author.uid,
        poll: seed.poll == null ? null : _pollOf(seed),
        hasPoll: seed.poll != null,
      ),
      authors: authors,
    );
  }

  @override
  Future<TiebaUserProfile> getUserInfo({
    required String uid,
    int pn = 1,
  }) async {
    await _wait();
    final _Persona persona = _personaByUid(uid);
    final int salt = _stableHash(uid);
    final bool self = uid == _me.uid;
    final List<TiebaUserLikeForum> forums = self
        ? <TiebaUserLikeForum>[
            for (final LikeForumInfo info in _likes.values.take(6))
              _likeForumView(
                _ensureForum(info.forumName),
                level: info.levelId,
              ),
          ]
        : <TiebaUserLikeForum>[
            for (final _ForumSeed forum in _forums.take(4))
              _likeForumView(forum, level: '${forum.level}'),
          ];
    return TiebaUserProfile(
      uid: uid,
      nameShow: persona.name,
      username: persona.username,
      nicknameEditing: false,
      editingNickname: '',
      portraitUrl: persona.avatar,
      intro: persona.intro,
      sex: '${persona.sex}',
      tbAge: '${3 + salt % 12}.${salt % 10}年',
      concernNum: '${60 + salt % 220}',
      fansNum: '${120 + salt % 1800}',
      likeForumNum: '${self ? _likes.length : 4 + salt % 20}',
      postNum: '${self ? 128 : 30 + salt % 400}',
      rePostNum: '${self ? 860 : 200 + salt % 3200}',
      totalAgreeNum: '${self ? 12480 : 800 + salt % 30000}',
      likeForums: forums,
    );
  }

  @override
  Future<TiebaUserPostPage> getUserPost({
    required String uid,
    int pn = 1,
    int rn = 20,
  }) async {
    await _wait();
    final List<_ThreadSeed> seeds = <_ThreadSeed>[
      for (final _ThreadSeed seed in _seedThreads)
        if (seed.author.uid == uid) seed,
    ];
    for (int i = seeds.length; i < 8; i++) {
      final _ForumSeed forum = _forums[(i + _stableHash(uid)) % _forums.length];
      final _ThreadSeed generated = _generatedSeed(forum.name, 140 + i);
      if (generated.author.uid != uid) {
        seeds.add(_ThreadSeed(
          tid: generated.tid,
          fid: generated.fid,
          forumName: generated.forumName,
          title: generated.title,
          author: _personaByUid(uid),
          createdAgo: generated.createdAgo,
          lastReplyAgo: generated.lastReplyAgo,
          views: generated.views,
          replies: generated.replies,
          agrees: generated.agrees,
          disagrees: generated.disagrees,
          posts: generated.posts,
        ));
      } else {
        seeds.add(generated);
      }
    }
    return TiebaUserPostPage(
      hidePost: false,
      posts: <TiebaUserPost>[
        for (final _ThreadSeed seed in seeds)
          _userPostView(seed, isThread: true),
      ],
    );
  }

  @override
  Future<TiebaUserPostPage> getUserPostLowVersion({
    required String uid,
    int pn = 1,
    int rn = 20,
  }) async {
    await _wait();
    final _Persona persona = _personaByUid(uid);
    return TiebaUserPostPage(
      hidePost: false,
      posts: <TiebaUserPost>[
        for (int i = 0; i < 6; i++)
          TiebaUserPost(
            threadId: _seedThreads[(i * 3) % _seedThreads.length].tid,
            userId: uid,
            userPortrait: persona.avatar,
            username: persona.name,
            title: _seedThreads[(i * 3) % _seedThreads.length].title,
            createTime: _unixAgo(Duration(hours: i * 7 + 1)),
            forumName: _seedThreads[(i * 3) % _seedThreads.length].forumName,
            isThread: false,
            agreeNum: '${i * 3}',
            disagreeNum: '0',
            replyNum: '0',
            quotaContent: _seedThreads[(i * 3) % _seedThreads.length].title,
            content: <TiebaPostContent>[
              _text(_fillerReplies[(i * 4) % _fillerReplies.length]),
            ],
            images: const <TiebaMedia>[],
            videoInfo: null,
          ),
      ],
    );
  }

  @override
  Future<UserForumLikePage> getUserForumnLike(
    String uid,
    String myUid,
    int pn,
    int pageSize,
  ) async {
    await _wait();
    if (uid == _me.uid || uid == myUid) {
      return UserForumLikePage(
        forums: <TiebaUserLikeForum>[
          for (final LikeForumInfo info in _likes.values)
            _likeForumView(
              _ensureForum(info.forumName),
              level: info.levelId,
            ),
        ],
      );
    }
    return UserForumLikePage(
      forums: <TiebaUserLikeForum>[
        for (final _ForumSeed forum in _forums.take(6))
          _likeForumView(forum, level: '${forum.level}'),
      ],
    );
  }

  @override
  Future<MessagePage> getReply(int pn) async {
    await _wait();
    return MessagePage(
      items: _messagesOf(TiebaMessageKind.reply, pn),
      hasMore: false,
      unread: 3,
    );
  }

  @override
  Future<MessagePage> getAtMe(int pn) async {
    await _wait();
    return MessagePage(
      items: _messagesOf(TiebaMessageKind.at, pn),
      hasMore: false,
      unread: 1,
    );
  }

  @override
  Future<MessagePage> getLike(int pn) async {
    await _wait();
    return MessagePage(
      items: _messagesOf(TiebaMessageKind.like, pn),
      hasMore: false,
      unread: 2,
    );
  }

  @override
  Future<MessageUnreadCounts> getMessageUnread() async =>
      const MessageUnreadCounts(reply: 3, at: 1, like: 2);

  @override
  Future<SearchForumResult> searchForum(String keywords, int pn,
      {int rn = 10}) async {
    await _wait();
    final String kw = keywords.trim();
    final List<TiebaSearchForum> forums = <TiebaSearchForum>[
      for (final _ForumSeed forum in _forums)
        if (kw.isEmpty || forum.name.contains(kw) || forum.brief.contains(kw))
          TiebaSearchForum(
            name: forum.name,
            img: forum.avatar,
            brief: forum.brief,
            member: forum.member,
            post: forum.post,
            isLike: _likes.containsKey(forum.fid),
          ),
    ];
    if (forums.isEmpty && kw.isNotEmpty) {
      final _ForumSeed generated = _ensureForum(kw);
      forums.add(TiebaSearchForum(
        name: generated.name,
        img: generated.avatar,
        brief: generated.brief,
        member: generated.member,
        post: generated.post,
        isLike: false,
      ));
    }
    return SearchForumResult(forums: forums);
  }

  @override
  Future<SearchMixedPage> searchMixed(String keywords,
      {int pn = 1, int rn = 20}) async {
    await _wait();
    final List<TiebaSearchPost> posts = _searchResults(keywords);
    final String kw = keywords.trim();
    _ForumSeed? forum;
    for (final _ForumSeed candidate in _forums) {
      if (candidate.name.contains(kw) || kw.contains(candidate.name)) {
        forum = candidate;
        break;
      }
    }
    return SearchMixedPage(
      cards: <SearchMixedCard>[
        if (forum != null)
          SearchMixedCard.forum(TiebaSearchForum(
            name: forum.name,
            img: forum.avatar,
            brief: forum.brief,
            member: forum.member,
            post: forum.post,
            isLike: _likes.containsKey(forum.fid),
          )),
        for (final TiebaSearchPost post in posts.take(6))
          SearchMixedCard.thread(post),
      ],
      hasMore: false,
    );
  }

  @override
  Future<SearchPostPage> searchPost(
    String keywords, {
    int pn = 1,
    int order = 0,
    int filter = 1,
    int ct = 2,
    String? fname,
  }) async {
    await _wait();
    final List<TiebaSearchPost> all = _searchResults(keywords, fname: fname);
    final int start = ((pn < 1 ? 1 : pn) - 1) * 20;
    final int end = math.min(start + 20, all.length);
    return SearchPostPage(
      posts: start >= all.length
          ? const <TiebaSearchPost>[]
          : all.sublist(start, end),
      hasMore: end < all.length,
    );
  }

  @override
  Future<SearchUserResult> searchUser(String keyword) async {
    await _wait();
    final String kw = keyword.trim();
    final List<TiebaUserMatch> users = <TiebaUserMatch>[
      for (final _Persona persona in <_Persona>[_me, ..._personas])
        if (kw.isEmpty ||
            persona.name.contains(kw) ||
            persona.username.contains(kw) ||
            persona.intro.contains(kw))
          TiebaUserMatch(
            id: persona.uid,
            name: persona.username,
            userNickname: persona.name,
            showNickname: persona.name,
            portrait: persona.avatar,
            intro: persona.intro,
          ),
    ];
    return SearchUserResult(users: users.take(12).toList());
  }

  @override
  Future<ThreadStorePage> getThreadStore(int offset, String myUid,
      {int rn = 20}) async {
    await _wait();
    final List<TiebaStoredThread> threads = <TiebaStoredThread>[
      for (final String tid in _storedTids)
        if (_catalog[tid] != null) _storedThreadView(_catalog[tid]!),
    ];
    return ThreadStorePage(threads: threads);
  }

  @override
  Future<List<LikeForumInfo>> getLikes() async {
    await _wait();
    return _likes.values.toList(growable: false);
  }

  @override
  Future<void> refreshLikes() async => _wait();

  @override
  int? get cachedUid => loggedIn ? int.parse(_me.uid) : null;

  @override
  Future<int?> getUID() async {
    await _wait();
    return loggedIn ? int.parse(_me.uid) : null;
  }

  @override
  Future<TiebaTopicDetail> getTopicDetail({
    required String name,
    String topicId = '',
    String fid = '',
    String forumName = '',
  }) async {
    await _wait();
    final String id = topicId.isNotEmpty
        ? topicId
        : 'topic_${_stableTid(name).substring(0, 8)}';
    final TiebaTopicDetail detail = TiebaTopicDetail(
      id: id,
      name: name,
      desc: '这里汇总了吧友关于「$name」的讨论：比赛复盘、数据整理和一些不太成熟的想法都在里面，'
          '欢迎补充自己的视角。',
      cover: '',
      postNum: '${1200 + _stableHash(name) % 6000}',
      discussNum: '${180 + _stableHash(name) % 1200}',
      hotValue: '${80 + _stableHash(name) % 900}',
      fid: fid.isNotEmpty ? fid : '5',
      forumName: forumName.isNotEmpty ? _normalizeForum(forumName) : '抗压背锅',
      createTime: _unixAgo(const Duration(days: 3)),
      shareTitle: '#$name#',
    );
    _topicMeta[name] = detail;
    return detail;
  }

  @override
  Future<TiebaTopicThreadPage> getTopicThreads({
    required String name,
    String topicId = '',
    int page = 1,
    int sort = 1,
    String lastId = '',
  }) async {
    await _wait();
    final List<_ThreadSeed> all = _topicSeeds(name);
    final List<_ThreadSeed> ordered = sort == 2 ? all.reversed.toList() : all;
    final int current = page < 1 ? 1 : page;
    final int start = (current - 1) * 6;
    final int end = math.min(start + 6, ordered.length);
    return TiebaTopicThreadPage(
      threads: start >= ordered.length
          ? const <TiebaThreadInfo>[]
          : <TiebaThreadInfo>[
              for (final _ThreadSeed seed
                  in ordered.sublist(start, math.min(end, ordered.length)))
                _threadInfo(seed),
            ],
      hasMore: end < ordered.length,
      lastId: '',
      currentPage: current,
    );
  }

  // ── 写入 ────────────────────────────────────────────────────────────────

  @override
  Future<void> agreePost(
    String postID,
    String threadID,
    int objType, {
    String? forumId,
    int agreeType = 2,
    int opType = 0,
  }) async {
    await _wait();
    _requireLogin();
    if (opType == 1) {
      _likedPosts.remove(postID);
      _dislikedPosts.remove(postID);
      return;
    }
    if (agreeType == 5) {
      _likedPosts.remove(postID);
      _dislikedPosts.add(postID);
    } else {
      _dislikedPosts.remove(postID);
      _likedPosts.add(postID);
    }
  }

  @override
  Future<void> voteThreadPoll(
    String threadID,
    String forumId,
    Set<int> optionIds,
  ) async {
    await _wait();
    _requireLogin();
    final _ThreadSeed? seed = _catalog[threadID];
    if (seed?.poll == null) {
      throw _error('这个帖子没有投票');
    }
    final Set<int> selected =
        _pollSelections.putIfAbsent(threadID, () => <int>{});
    final bool multiple = seed!.poll!.multiple;
    if (!multiple) selected.clear();
    for (final int id in optionIds) {
      if (!selected.add(id)) continue;
      for (final _PollOptionSeed option in seed.poll!.options) {
        if (option.id == id) {
          option.votes += 1;
          seed.poll!.participants += 1;
        }
      }
    }
    _host?.onMessage?.call('投票成功');
  }

  @override
  Future<TiebaPublishResult> publishThread({
    required String fid,
    required String forumName,
    required String title,
    required String content,
    int imageCount = 0,
    TiebaPublishPoll? poll,
    String? topicId,
    bool? hideFromProfile,
    String? contentStatement,
    TiebaPublishScore? score,
  }) async {
    await _wait();
    _requireLogin();
    final String forum = _normalizeForum(forumName);
    final String tid = _stableTid(
        'publish|$forum|$title|${DateTime.now().microsecondsSinceEpoch}');
    final List<TiebaPostContent> parts = <TiebaPostContent>[
      TiebaTextContent(text: content, uid: _me.uid),
      if (topicId != null && topicId.isNotEmpty) _topic(topicId),
    ];
    final _ThreadSeed seed = _ThreadSeed(
      tid: tid,
      fid: fid,
      forumName: forum,
      title: title,
      author: _me,
      createdAgo: Duration.zero,
      lastReplyAgo: Duration.zero,
      views: 0,
      replies: 0,
      agrees: 0,
      disagrees: 0,
      posts: <_PostSeed>[
        _post(_me, parts, ip: '广东'),
      ],
      poll: poll == null
          ? null
          : _PollSeed(
              poll.title,
              <_PollOptionSeed>[
                for (int i = 0; i < poll.options.length; i++)
                  _PollOptionSeed(i + 1, poll.options[i], 0),
              ],
              multiple: poll.multiple,
            ),
    );
    _catalog[tid] = seed;
    _forumThreadCache.remove('$forum|false');
    _forumThreadCache.remove('$forum|true');
    return TiebaPublishResult(tid: tid, message: '发布成功');
  }

  @override
  Future<TiebaPublisherConfig> getPublisherConfig({required String fid}) async {
    await _wait();
    return const TiebaPublisherConfig(
      statements: <String>['本贴为原创内容', '本贴含 AI 生成内容'],
      scoreEnabled: true,
    );
  }

  @override
  Future<List<TiebaComposeTopic>> searchComposeTopics({
    required String fid,
    String prefix = '',
  }) async {
    await _wait();
    final List<TiebaComposeTopic> topics = <TiebaComposeTopic>[
      const TiebaComposeTopic(id: '1001', name: '周末去哪儿'),
      const TiebaComposeTopic(id: '1002', name: '今日份随手拍'),
      const TiebaComposeTopic(id: '1003', name: '我的桌面'),
      const TiebaComposeTopic(id: '1004', name: '深夜碎碎念'),
      const TiebaComposeTopic(id: '1005', name: '最近在玩什么'),
    ];
    return prefix.isEmpty
        ? topics
        : topics
            .where((TiebaComposeTopic topic) => topic.name.contains(prefix))
            .toList();
  }

  @override
  Future<String> replyThread(
    String content,
    String kw,
    String fid,
    String tid, {
    List<String>? photos,
  }) async {
    await _wait();
    _requireLogin();
    final _ThreadSeed? seed = _catalog[tid];
    if (seed != null) {
      seed.replies += 1;
      seed.posts.add(_post(
        _me,
        <TiebaPostContent>[
          TiebaTextContent(text: content, uid: _me.uid),
          for (final String photo in photos ?? const <String>[])
            if (photo.isNotEmpty) _image(photo),
        ],
        ip: '广东',
      ));
    }
    _host?.onMessage?.call('回复成功');
    return '回复成功';
  }

  @override
  Future<String> replyFloor(
    String content,
    String kw,
    String fid,
    String tid,
    String floorId, {
    List<String>? photos,
    String replyUID = "",
  }) async {
    await _wait();
    _requireLogin();
    _host?.onMessage?.call('回复成功');
    return '回复成功';
  }

  @override
  Future<void> favoForum(String fid, String forumName) async {
    await _wait();
    _requireLogin();
    final String name = _normalizeForum(forumName);
    final _ForumSeed forum = _ensureForum(name);
    _likes[fid] = LikeForumInfo(
      forumId: fid,
      forumName: name,
      avatar: forum.avatar,
      levelId: '1',
      isSign: '0',
    );
  }

  @override
  Future<void> unfavoForum({
    required String fid,
    required String forumName,
  }) async {
    await _wait();
    _requireLogin();
    _likes.remove(fid);
  }

  @override
  Future<void> threadAddStore(String tid, String pid, {int status = 1}) async {
    await _wait();
    _requireLogin();
    if (status == 1) {
      _storedTids.add(tid);
    } else {
      _storedTids.remove(tid);
    }
  }

  @override
  Future<void> threadRemoveStore(String tid) async {
    await _wait();
    _requireLogin();
    _storedTids.remove(tid);
  }

  @override
  Future<void> signAll() async {
    await _wait();
    _requireLogin();
    final List<LikeForumInfo> all = _likes.values.toList(growable: false);
    for (int i = 0; i < all.length; i++) {
      final LikeForumInfo forum = all[i];
      _host?.onSignProgress
          ?.call(i + 1, all.length, '正在签到', '${forum.forumName}吧');
      _likes[forum.forumId] = LikeForumInfo(
        forumId: forum.forumId,
        forumName: forum.forumName,
        avatar: forum.avatar,
        levelId: forum.levelId,
        isSign: '1',
      );
      _host?.onForumSigned?.call(forum.forumName, true);
    }
    _host?.onSignProgressDone?.call();
    _host?.onMessage?.call('签到完成，共 ${all.length} 个吧');
  }

  @override
  Future<SignResult> signOneForum(String kw, {String? fid}) async {
    await _wait();
    _requireLogin();
    final String name = _normalizeForum(kw);
    bool already = false;
    for (final MapEntry<String, LikeForumInfo> entry in _likes.entries) {
      if (entry.value.forumName == name) {
        already = entry.value.isSign == '1';
        _likes[entry.key] = LikeForumInfo(
          forumId: entry.value.forumId,
          forumName: entry.value.forumName,
          avatar: entry.value.avatar,
          levelId: entry.value.levelId,
          isSign: '1',
        );
        _host?.onForumSigned?.call(name, true);
      }
    }
    return SignResult(
      ok: true,
      message: already ? '今天已经签到过了' : '签到成功，经验 +8',
      bonusPoint: already ? '0' : '8',
    );
  }

  @override
  Future<TiebaUploadedImage> uploadPicture(
    String forumName,
    bool saveOrigin,
    UploadFile file,
  ) async {
    await _wait();
    _requireLogin();
    return TiebaUploadedImage(
      picId: 'pic_${file.resourceId}',
      width: file.width,
      height: file.height,
    );
  }

  // ── 举报 / 拉黑 ─────────────────────────────────────────────────────────

  @override
  Future<TiebaReportForm> getReportForm(TiebaReportTarget target) async {
    await _wait();
    return TiebaReportForm(
      url: Uri.parse('https://tieba.baidu.com/mo/q/report'),
      objectType: switch (target.kind) {
        TiebaReportKind.user => 5,
        TiebaReportKind.thread => 3,
        _ => 1,
      },
      threadId: target.threadId,
      postId: target.postId,
      portrait: target.portrait,
      scene: 3,
      groups: <TiebaReportGroup>[
        const TiebaReportGroup(
          title: '违规内容',
          reasons: <TiebaReportReason>[
            TiebaReportReason(
              id: 1,
              groupId: 1,
              title: '广告或垃圾信息',
              fields: <TiebaReportField>[
                TiebaReportField(
                  component: 'content-input',
                  title: '补充说明',
                  required: false,
                  tips: <String>['请描述广告内容或引流方式'],
                ),
              ],
            ),
            TiebaReportReason(
              id: 2,
              groupId: 1,
              title: '色情低俗',
              fields: <TiebaReportField>[
                TiebaReportField(
                  component: 'content-input',
                  title: '补充说明',
                  required: false,
                ),
              ],
            ),
            TiebaReportReason(
              id: 3,
              groupId: 1,
              title: '人身攻击或辱骂',
              fields: <TiebaReportField>[
                TiebaReportField(
                  component: 'content-input',
                  title: '补充说明',
                  required: false,
                ),
              ],
            ),
          ],
        ),
        const TiebaReportGroup(
          title: '其他',
          reasons: <TiebaReportReason>[
            TiebaReportReason(
              id: 9,
              groupId: 2,
              title: '其他问题',
              fields: <TiebaReportField>[
                TiebaReportField(
                  component: 'content-input',
                  title: '请描述问题',
                  required: true,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  @override
  Future<void> submitReport(
      TiebaReportForm form, TiebaReportInput input) async {
    await _wait();
    _requireLogin();
    _host?.onMessage?.call('举报已提交，我们会尽快处理');
  }

  @override
  Future<List<TiebaReportThread>> getReportThreads(String portrait) async {
    await _wait();
    return <TiebaReportThread>[
      for (final _ThreadSeed seed in _seedThreads
          .where((_ThreadSeed seed) => seed.author.avatar == portrait)
          .take(5))
        TiebaReportThread(id: seed.tid, title: seed.title),
    ];
  }

  @override
  Future<TiebaBlockSettings> getBlockSettings(String uid) async {
    await _wait();
    return const TiebaBlockSettings(
      extended: false,
      follow: true,
      interact: false,
      chat: true,
    );
  }

  @override
  Future<void> setBlockSettings(String uid, TiebaBlockSettings settings) async {
    await _wait();
    _requireLogin();
    _host?.onMessage?.call('设置已保存');
  }

  // ── 数据辅助 ────────────────────────────────────────────────────────────

  static String _normalizeForum(String value) {
    String name = value.trim();
    if (name.endsWith('吧') && name.length > 1) {
      name = name.substring(0, name.length - 1);
    }
    return name;
  }

  static int _stableHash(String value) {
    int hash = 0;
    for (final int code in value.codeUnits) {
      hash = (hash * 31 + code) & 0x7fffffff;
    }
    return hash;
  }

  static String _stableTid(String key) =>
      '${1000000000 + _stableHash(key) % 8000000000}';

  static String _unixAgo(Duration ago) =>
      '${DateTime.now().subtract(ago).millisecondsSinceEpoch ~/ 1000}';

  static String _titleFor(String kw, int index, {bool good = false}) {
    if (good) {
      final String template =
          _goodTitleTemplates[index % _goodTitleTemplates.length];
      return template.replaceAll('{kw}', kw);
    }
    final String topic = _forumTopics[kw] ?? kw;
    final String template =
        _generalTitleTemplates[index % _generalTitleTemplates.length];
    return template.replaceAll('{kw}', topic);
  }

  static String _openingFor(String kw, int index) {
    final String opening =
        _openings[index % _openings.length].replaceAll('{kw}', kw);
    return opening;
  }
}

const List<String> _goodTitleTemplates = <String>[
  '【整理】{kw}常用资料汇总（持续更新）',
  '【新手向】{kw}入门避坑指南',
  '【长期更新】{kw}每周见闻记录',
  '【经验】用了半年{kw}，留下这些体会',
  '【合集】{kw}值得收藏的十个帖子',
  '【讨论】{kw}接下来会往哪个方向走',
  '【实测】{kw}的几个常见误区',
  '【总结】{kw}这一年的变化',
];

const List<String> _generalTitleTemplates = <String>[
  '关于{kw}，想听听大家的意见',
  '最近在{kw}上踩的一个坑',
  '整理了一份{kw}入门资料，给需要的人',
  '第一次认真尝试{kw}，有几个问题',
  '{kw}有什么值得推荐的吗',
  '说说我为什么开始关注{kw}',
  '{kw}新手最容易忽略的几件事',
  '今天在{kw}遇到一件挺有意思的事',
  '有没有人和我一样，对{kw}又爱又恨',
  '{kw}相关，伸手党求个方向',
  '记录一下这周在{kw}上的收获',
  '有没有{kw}的老手，帮忙看看这个思路',
  '关于{kw}，我可能一直都做错了',
  '最近在{kw}上花的时间有点多',
  '{kw}小白的第一周，慢慢摸索',
  '分享一个{kw}的小技巧，亲测有效',
  '大家平时是怎么安排{kw}的',
  '{kw}做到现在，最大的感受是什么',
  '想入坑{kw}，先从哪里开始比较好',
  '关于{kw}，有几个问题想请教',
  '最近{kw}的体验有点不太好，是我的问题吗',
  '{kw}相关，整理了一些常见误区',
  '聊聊{kw}里那些看起来简单其实很难的事',
  '有没有人愿意交流一下{kw}的经验',
];

const List<String> _openings = <String>[
  '先把背景说一下：这件事在我这里已经持续了一段时间，最近终于有空整理。',
  '这个问题困扰我挺久了，自己查了一些资料，还是想听听有经验的人怎么说。',
  '周末整理东西的时候翻出来的，觉得有点意思，就顺手记一下。',
  '第一次发帖，如果有说得不对的地方，大家轻点拍。',
  '看到前面有人问类似的问题，干脆单独开一帖，把自己的做法写清楚。',
  '简单记录一下最近的一段经历，不一定对所有人都有用。',
];

const Map<String, String> _forumTopics = <String, String>{
  '猫': '养猫',
  '图片': '拍照',
  '钢笔': '玩笔',
  '摄影': '拍照片',
  '机械键盘': '键盘',
  '单机游戏': '单机游戏',
  '碧蓝航线': '碧蓝航线',
  '孙笑川': '孙笑川',
  '宫漫': '宫漫',
  '核战避难所': '核战避难所',
  '抗压背锅': '抗压背锅',
  '足球': '看球',
};

const List<String> _photoKeys = <String>[
  'coffee',
  'cat',
  'city',
  'desk',
  'food',
  'forest',
  'game',
  'keyboard',
  'night',
  'plants',
  'sea',
  'train',
  'camera',
  'books',
  'rain',
];
