part of 'demo_tieba_api.dart';

// ── 演示数据集 ────────────────────────────────────────────────────────────
//
// 用户资料与帖子为演示数据，吧名仅用于展示。

class _Persona {
  const _Persona({
    required this.uid,
    required this.username,
    required this.name,
    required this.avatar,
    required this.intro,
    required this.sex,
    required this.level,
    this.role,
  });

  final String uid;
  final String username;
  final String name;
  final String avatar;
  final String intro;
  final int sex;
  final int level;
  final TiebaForumRole? role;

  TiebaAuthor author() => TiebaAuthor(
        icons: const <String>[],
        levelID: '$level',
        forumRole: role,
        nameShow: name,
        portrait: avatar,
        uid: uid,
        username: username,
      );
}

const _Persona _me = _Persona(
  uid: '10001',
  username: 'toast_edge',
  name: '烤面包边',
  avatar: _demoAvatar0,
  intro: '白天写代码，晚上补番。记录一些生活里的小事。',
  sex: 1,
  level: 12,
);

const _Persona _nana = _Persona(
  uid: '20001',
  username: 'aoki_nana',
  name: '青葉ナナ',
  avatar: _demoAvatar1,
  intro: 'Flutter / 设计系统 / 偶尔做饭',
  sex: 2,
  level: 11,
);

const _Persona _lateCat = _Persona(
  uid: '20002',
  username: 'cat_at_4am',
  name: '凌晨四点的猫',
  avatar: _demoAvatar2,
  intro: '猫派。拍照片比修照片多。',
  sex: 2,
  level: 9,
);

const _Persona _oldRadio = _Persona(
  uid: '20003',
  username: 'old_radio',
  name: '旧收音机',
  avatar: _demoAvatar3,
  intro: '听歌、看球、修旧东西。',
  sex: 1,
  level: 8,
);

const _Persona _southWind = _Persona(
  uid: '20004',
  username: 'south_wind',
  name: '南风过境',
  avatar: _demoAvatar4,
  intro: '在读研究生，研究方向是城市规划。',
  sex: 2,
  level: 7,
);

const _Persona _pencilBox = _Persona(
  uid: '20005',
  username: 'pencil_box',
  name: '铅笔盒',
  avatar: _demoAvatar5,
  intro: '钢笔、手帐、纸质书。',
  sex: 1,
  level: 6,
);

const _Persona _fries = _Persona(
  uid: '20006',
  username: 'fries_no_salt',
  name: '薯条不加盐',
  avatar: _demoAvatar6,
  intro: '今天也没有好好吃饭。',
  sex: 2,
  level: 5,
);

const _Persona _summerRoll = _Persona(
  uid: '20007',
  username: 'summer_roll',
  name: '夏卷',
  avatar: _demoAvatar7,
  intro: '游戏打得一般，攻略写得还行。',
  sex: 1,
  level: 10,
);

const _Persona _mountainSleep = _Persona(
  uid: '20008',
  username: 'mountain_sleep',
  name: '山眠',
  avatar: _demoAvatar8,
  intro: '周末在山里，工作日在地铁里。',
  sex: 1,
  level: 8,
);

const _Persona _blueScreen = _Persona(
  uid: '20009',
  username: 'blue_screen',
  name: '蓝屏',
  avatar: _demoAvatar9,
  intro: '摄影入门，器材党退散。',
  sex: 1,
  level: 6,
);

const _Persona _gardenGhost = _Persona(
  uid: '20010',
  username: 'garden_ghost',
  name: '花园里的幽灵',
  avatar: _demoAvatar10,
  intro: '植物、猫、旧电影。',
  sex: 2,
  level: 9,
);

const _Persona _ticketStub = _Persona(
  uid: '20011',
  username: 'ticket_stub',
  name: '票根',
  avatar: _demoAvatar11,
  intro: '看球十年，主队还没夺冠。',
  sex: 2,
  level: 7,
);

const _Persona _keycapThief = _Persona(
  uid: '20012',
  username: 'keycap_thief',
  name: '键帽小偷',
  avatar: _demoAvatar12,
  intro: '65 配列爱好者，桌面永远缺一把键盘。',
  sex: 1,
  level: 6,
);

const _Persona _noodleSoup = _Persona(
  uid: '20013',
  username: 'noodle_soup',
  name: '面汤',
  avatar: _demoAvatar13,
  intro: '夜宵研究员。',
  sex: 1,
  level: 6,
);

const _Persona _whiteNoise = _Persona(
  uid: '20014',
  username: 'white_noise',
  name: '白噪音',
  avatar: _demoAvatar14,
  intro: '睡前听雨声。',
  sex: 2,
  level: 5,
);

const _Persona _moderator = _Persona(
  uid: '20015',
  username: 'sun_bar_staff',
  name: '吧务组',
  avatar: _demoAvatar15,
  intro: '孙笑川吧吧务，处理举报与违规内容。',
  sex: 1,
  level: 14,
  role: TiebaForumRole.manager,
);

const List<_Persona> _personas = <_Persona>[
  _nana,
  _lateCat,
  _oldRadio,
  _southWind,
  _pencilBox,
  _fries,
  _summerRoll,
  _mountainSleep,
  _blueScreen,
  _gardenGhost,
  _ticketStub,
  _keycapThief,
  _noodleSoup,
  _whiteNoise,
];

class _ForumSeed {
  const _ForumSeed({
    required this.fid,
    required this.name,
    required this.avatar,
    required this.brief,
    required this.member,
    required this.post,
    required this.level,
    required this.levelName,
  });

  final String fid;
  final String name;
  final String avatar;
  final String brief;
  final int member;
  final int post;
  final int level;
  final String levelName;
}

const List<_ForumSeed> _forums = <_ForumSeed>[
  _ForumSeed(
    fid: '1',
    name: '孙笑川',
    avatar: 'https://picsum.photos/seed/tieba-sun/200/200',
    brief: '互联网情感与生活杂谈',
    member: 5832104,
    post: 128904331,
    level: 9,
    levelName: '9级',
  ),
  _ForumSeed(
    fid: '2',
    name: '碧蓝航线',
    avatar: 'https://picsum.photos/seed/tieba-azur/200/200',
    brief: '手机游戏《碧蓝航线》玩家社区',
    member: 1204882,
    post: 45221930,
    level: 7,
    levelName: '7级',
  ),
  _ForumSeed(
    fid: '3',
    name: '宫漫',
    avatar: 'https://picsum.photos/seed/tieba-anime/200/200',
    brief: '动画、漫画与轻小说讨论',
    member: 2341556,
    post: 67112044,
    level: 8,
    levelName: '8级',
  ),
  _ForumSeed(
    fid: '4',
    name: '核战避难所',
    avatar: 'https://picsum.photos/seed/tieba-shelter/200/200',
    brief: '深夜闲聊与生活避难所',
    member: 912330,
    post: 21445783,
    level: 6,
    levelName: '6级',
  ),
  _ForumSeed(
    fid: '5',
    name: '抗压背锅',
    avatar: 'https://picsum.photos/seed/tieba-esport/200/200',
    brief: '电竞赛事与赛后讨论',
    member: 6112487,
    post: 190224776,
    level: 10,
    levelName: '10级',
  ),
  _ForumSeed(
    fid: '6',
    name: '图片',
    avatar: 'https://picsum.photos/seed/tieba-photo/200/200',
    brief: '分享你拍到的瞬间',
    member: 1778309,
    post: 38902115,
    level: 7,
    levelName: '7级',
  ),
  _ForumSeed(
    fid: '7',
    name: '猫',
    avatar: _photoCatAvatar,
    brief: '吸猫、养猫与猫咪救助',
    member: 3204118,
    post: 88231004,
    level: 8,
    levelName: '8级',
  ),
  _ForumSeed(
    fid: '8',
    name: '钢笔',
    avatar: 'https://picsum.photos/seed/tieba-pen/200/200',
    brief: '钢笔、墨水与手写日常',
    member: 402876,
    post: 9882341,
    level: 5,
    levelName: '5级',
  ),
  _ForumSeed(
    fid: '9',
    name: '摄影',
    avatar: 'https://picsum.photos/seed/tieba-camera/200/200',
    brief: '摄影作品与技术交流',
    member: 1045633,
    post: 30118274,
    level: 6,
    levelName: '6级',
  ),
  _ForumSeed(
    fid: '10',
    name: '单机游戏',
    avatar: 'https://picsum.photos/seed/tieba-game/200/200',
    brief: '单机游戏推荐与通关心得',
    member: 2889021,
    post: 72882190,
    level: 9,
    levelName: '9级',
  ),
  _ForumSeed(
    fid: '11',
    name: '足球',
    avatar: 'https://picsum.photos/seed/tieba-football/200/200',
    brief: '足球赛事与球队讨论',
    member: 4102556,
    post: 120441028,
    level: 8,
    levelName: '8级',
  ),
  _ForumSeed(
    fid: '12',
    name: '机械键盘',
    avatar: 'https://picsum.photos/seed/tieba-keyboard/200/200',
    brief: '键盘、轴体与客制化',
    member: 871224,
    post: 18772309,
    level: 6,
    levelName: '6级',
  ),
];

const String _photoCatAvatar =
    'https://images.unsplash.com/photo-1518791841217-8f162f1e1131'
    '?auto=format&fit=crop&w=200&q=70';

const Map<String, String> _photos = <String, String>{
  'cat': 'https://images.unsplash.com/photo-1518791841217-8f162f1e1131'
      '?auto=format&fit=crop&w=900&q=70',
  'kitten': 'https://images.unsplash.com/photo-1592194996308-7b43878e84a6'
      '?auto=format&fit=crop&w=900&q=70',
  'dog': 'https://images.unsplash.com/photo-1552053831-71594a27632d'
      '?auto=format&fit=crop&w=900&q=70',
  'coffee': 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085'
      '?auto=format&fit=crop&w=900&q=70',
  'keyboard': 'https://images.unsplash.com/photo-1587829741301-dc798b83add3'
      '?auto=format&fit=crop&w=900&q=70',
  'camera': 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32'
      '?auto=format&fit=crop&w=900&q=70',
  'night': 'https://images.unsplash.com/photo-1519501025264-65ba15a82390'
      '?auto=format&fit=crop&w=900&q=70',
  'sea': 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e'
      '?auto=format&fit=crop&w=900&q=70',
  'forest': 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e'
      '?auto=format&fit=crop&w=900&q=70',
  'books': 'https://images.unsplash.com/photo-1512820790803-83ca734da794'
      '?auto=format&fit=crop&w=900&q=70',
  'ramen': 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624'
      '?auto=format&fit=crop&w=900&q=70',
  'pen': 'https://images.unsplash.com/photo-1583485088034-697b5bc54ccd'
      '?auto=format&fit=crop&w=900&q=70',
  'game': 'https://images.unsplash.com/photo-1493711662062-fa541adb3fc8'
      '?auto=format&fit=crop&w=900&q=70',
  'football': 'https://images.unsplash.com/photo-1579952363873-27f3bade9f55'
      '?auto=format&fit=crop&w=900&q=70',
  'plants': 'https://images.unsplash.com/photo-1416879595882-3373a0480b5b'
      '?auto=format&fit=crop&w=900&q=70',
  'train': 'https://images.unsplash.com/photo-1474487548417-781cb71495f3'
      '?auto=format&fit=crop&w=900&q=70',
  'city': 'https://images.unsplash.com/photo-1477959858617-67f85cf4f1df'
      '?auto=format&fit=crop&w=900&q=70',
  'food': 'https://images.unsplash.com/photo-1504674900247-0877df9cc836'
      '?auto=format&fit=crop&w=900&q=70',
  'desk': 'https://images.unsplash.com/photo-1498050108023-c5249f4df085'
      '?auto=format&fit=crop&w=900&q=70',
  'rain': 'https://images.unsplash.com/photo-1515694346937-94d85e41e6f0'
      '?auto=format&fit=crop&w=900&q=70',
  'window': 'https://images.unsplash.com/photo-1489514354504-1653aa90e34e'
      '?auto=format&fit=crop&w=900&q=70',
  'phone': 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9'
      '?auto=format&fit=crop&w=900&q=70',
  'flowers': 'https://images.unsplash.com/photo-1490750967868-88aa4486c946'
      '?auto=format&fit=crop&w=900&q=70',
};

const List<String> _ipLocations = <String>[
  '广东',
  '浙江',
  '江苏',
  '上海',
  '四川',
  '北京',
  '湖北',
  '山东',
  '福建',
  '湖南',
];

const List<String> _fillerReplies = <String>[
  '前排，先坐下了。',
  '同感，最近也有类似的感觉。',
  '先收藏了，回头慢慢看。',
  '这个确实，之前我也踩过坑。',
  '图拍得挺好看的。',
  '有没有后续？蹲一个更新。',
  '说得很中肯，比那些标题党强多了。',
  '我倒觉得还好，看个人习惯。',
  '楼上说得有道理。',
  '帮顶，希望更多人看到。',
  '笑死，太真实了。',
  '我也想问这个问题，等一个回答。',
  '细节挺多的，感谢整理。',
  '这个价位已经算可以了。',
  '先别急，过两天再看看。',
  '原来不止我一个人这么想。',
  '收藏了，周末试试。',
  '看完了，感觉还挺治愈的。',
];

const List<String> _fillerSubReplies = <String>[
  '确实。',
  '我也是这么觉得。',
  '哈哈，太真实了。',
  '有道理。',
  '蹲一个后续。',
  '楼上说出了我想说的。',
  '这角度可以。',
  '学到了。',
];

TiebaTextContent _text(String text, {String? uid}) =>
    TiebaTextContent(text: text, uid: uid);

TiebaEmojiContent _emoji(String name) => TiebaEmojiContent(
      c: name,
      text: _emojiResource(name),
    );

String _emojiResource(String name) {
  switch (name) {
    case '滑稽':
      return 'image_emoticon25';
    case '吃瓜':
      return 'image_emoticon86';
    case '笑哭':
      return 'image_emoticon72';
    case '赞':
      return 'image_emoticon48';
    case '托腮':
      return 'image_emoticon92';
    case '狗头':
      return 'image_emoticon94';
    default:
      return 'image_emoticon2';
  }
}

TiebaAtContent _at(String name, String uid) =>
    TiebaAtContent(text: name, uid: uid);

TiebaTopicContent _topic(String name) => TiebaTopicContent(
      text: '#$name#',
      link: 'https://tieba.baidu.com/hottopic/browse/hottopic?topic_name=$name',
    );

TiebaImageContent _image(String url, {int width = 900, int height = 600}) =>
    TiebaImageContent(
      src: url,
      cdnSrc: url,
      bigSrc: url,
      bigCdnSrc: url,
      originSrc: url,
      cdnSrcActive: url,
      bsize: '$width,$height',
    );

TiebaImageContent _photo(String key) =>
    _image(_photos[key] ?? _photos['city']!);

class _SubSeed {
  const _SubSeed(this.author, this.text, {this.agree = 0});

  final _Persona author;
  final String text;
  final int agree;
}

class _PostSeed {
  const _PostSeed(
    this.author,
    this.parts, {
    this.subs = const <_SubSeed>[],
    this.agree = 0,
    this.disagree = 0,
    this.ip = '广东',
    this.lbs = '',
  });

  final _Persona author;
  final List<TiebaPostContent> parts;
  final List<_SubSeed> subs;
  final int agree;
  final int disagree;
  final String ip;
  final String lbs;
}

class _PollOptionSeed {
  _PollOptionSeed(this.id, this.text, this.votes);

  final int id;
  final String text;
  int votes;
}

class _PollSeed {
  _PollSeed(
    this.title,
    this.options, {
    this.multiple = false,
    this.participants = 0,
  });

  final String title;
  final List<_PollOptionSeed> options;
  final bool multiple;
  int participants;
}

class _ThreadSeed {
  _ThreadSeed({
    required this.tid,
    required this.fid,
    required this.forumName,
    required this.title,
    required this.author,
    required this.createdAgo,
    required this.lastReplyAgo,
    required this.views,
    required this.replies,
    required this.agrees,
    required this.disagrees,
    required this.posts,
    this.isTop = false,
    this.isGood = false,
    this.poll,
    this.video,
    this.simplePostIds = false,
  });

  final String tid;
  final String fid;
  final String forumName;
  final String title;
  final _Persona author;
  final Duration createdAgo;
  final Duration lastReplyAgo;
  final int views;
  int replies;
  final int agrees;
  final int disagrees;
  final List<_PostSeed> posts;
  final bool isTop;
  final bool isGood;
  final _PollSeed? poll;
  final TiebaVideoInfo? video;
  final bool simplePostIds;
}

_PostSeed _post(
  _Persona author,
  List<TiebaPostContent> parts, {
  List<_SubSeed> subs = const <_SubSeed>[],
  int agree = 0,
  int disagree = 0,
  String ip = '广东',
  String lbs = '',
}) =>
    _PostSeed(author, parts,
        subs: subs, agree: agree, disagree: disagree, ip: ip, lbs: lbs);

List<_ThreadSeed> _buildThreadSeeds() => <_ThreadSeed>[
      _ThreadSeed(
        tid: '8293617401',
        fid: '1',
        forumName: '孙笑川',
        title: '吧规补充：关于灌水、挖坟和广告的处理（2026.11）',
        author: _moderator,
        createdAgo: const Duration(days: 2, hours: 4),
        lastReplyAgo: const Duration(minutes: 18),
        views: 12482,
        replies: 86,
        agrees: 312,
        disagrees: 8,
        isTop: true,
        posts: <_PostSeed>[
          _post(
            _moderator,
            <TiebaPostContent>[
              _text(
                '最近一段时间吧里灌水帖和广告回复明显变多，先把规则更新一下：\n\n'
                '1. 与吧主题无关的纯水帖直接删除；\n'
                '2. 超过三个月的旧帖不要无意义顶起；\n'
                '3. 广告、拉群、引流一律封禁。\n\n'
                '有异议可以在本帖下面提，规则从今晚开始执行。',
              ),
            ],
            subs: const <_SubSeed>[
              _SubSeed(_lateCat, '收到，辛苦吧务。', agree: 12),
              _SubSeed(_oldRadio, '支持，最近广告确实有点多。', agree: 8),
            ],
            agree: 312,
            ip: '四川',
          ),
          _post(
            _lateCat,
            <TiebaPostContent>[_text('收到，辛苦吧务。')],
            agree: 24,
            ip: '浙江',
          ),
          _post(
            _oldRadio,
            <TiebaPostContent>[_text('支持，最近广告确实有点多。')],
            agree: 17,
            ip: '江苏',
          ),
          _post(
            _fries,
            <TiebaPostContent>[
              _text('问一下，那种很久以前的技术贴被顶上来算挖坟吗？'),
            ],
            subs: const <_SubSeed>[
              _SubSeed(_moderator, '有实质补充就不算，纯「顶」「马克」会处理。', agree: 6),
            ],
            agree: 9,
            ip: '上海',
          ),
        ],
      ),
      _ThreadSeed(
        tid: '8294021877',
        fid: '1',
        forumName: '孙笑川',
        title: '终于把用了六年的旧手机里的照片导完了，说点废话',
        author: _lateCat,
        createdAgo: const Duration(hours: 9),
        lastReplyAgo: const Duration(minutes: 42),
        views: 6841,
        replies: 64,
        agrees: 186,
        disagrees: 4,
        posts: <_PostSeed>[
          _post(
            _lateCat,
            <TiebaPostContent>[
              _text(
                '从大一用到现在，屏幕碎了两次，电池换了三回。\n'
                '今晚终于把里面七千多张照片导出来了，翻到很多已经想不起来的事情。\n'
                '有几张是毕业那天在校门口拍的，当时觉得天气很差，现在看反而挺喜欢。',
              ),
              _photo('phone'),
              _text('新手机还在路上，先用旧相机顶几天。'),
            ],
            subs: const <_SubSeed>[
              _SubSeed(_nana, '七千多张，导出来那一刻应该挺感慨的。', agree: 9),
              _SubSeed(_summerRoll, '旧照片真的会突然把人拉回去。', agree: 5),
            ],
            agree: 186,
            ip: '浙江',
          ),
          _post(
            _nana,
            <TiebaPostContent>[
              _text('我上次也导了一次，最后发现最舍不得的是那些拍糊了的。'),
            ],
            agree: 31,
            ip: '广东',
          ),
          _post(
            _summerRoll,
            <TiebaPostContent>[_text('旧照片真的会突然把人拉回去。'), _emoji('托腮')],
            agree: 12,
            ip: '湖北',
          ),
        ],
      ),
      _ThreadSeed(
        tid: '8301124590',
        fid: '2',
        forumName: '碧蓝航线',
        title: '这次活动 EX 关的配队分享（低配也能过）',
        author: _summerRoll,
        createdAgo: const Duration(hours: 5),
        lastReplyAgo: const Duration(minutes: 7),
        views: 9820,
        replies: 112,
        agrees: 264,
        disagrees: 3,
        posts: <_PostSeed>[
          _post(
            _summerRoll,
            <TiebaPostContent>[
              _text(
                '试了几套阵容，最后这套比较稳，装备不用全满，主要吃一个手操节奏。\n'
                '道中清杂用常规队，BOSS 队留两轮空袭，第三波再交技能。\n'
                '如果练度偏低，可以把前排换成生存向的，时间会紧一点但能过。',
              ),
              _photo('game'),
              _text('具体配装我放在下面，欢迎补充。'),
            ],
            subs: const <_SubSeed>[
              _SubSeed(_whiteNoise, '新手刚入坑，这套能抄吗？', agree: 4),
              _SubSeed(_summerRoll, '能，装备差一点就多打两轮。', agree: 3),
            ],
            agree: 264,
            ip: '湖北',
          ),
          _post(
            _whiteNoise,
            <TiebaPostContent>[
              _text('新手刚入坑，这套能抄吗？船我只有一半。'),
            ],
            agree: 8,
            ip: '山东',
          ),
          _post(
            _oldRadio,
            <TiebaPostContent>[
              _text('低配的话建议道中多带一个奶，不然很容易在第三波翻车。'),
            ],
            agree: 19,
            ip: '江苏',
          ),
        ],
      ),
      _ThreadSeed(
        tid: '8305721048',
        fid: '3',
        forumName: '宫漫',
        title: '求推荐几部节奏慢一点的番，最近有点看不进去',
        author: _southWind,
        createdAgo: const Duration(hours: 13),
        lastReplyAgo: const Duration(minutes: 26),
        views: 5210,
        replies: 78,
        agrees: 93,
        disagrees: 2,
        posts: <_PostSeed>[
          _post(
            _southWind,
            <TiebaPostContent>[
              _text(
                '最近下班之后完全不想看打打杀杀的东西，想找几部节奏慢、日常感强一点的。\n'
                '最好是那种看完会想去泡杯茶的，不要太用力煽情。\n'
                '新旧都行，谢谢。',
              ),
            ],
            subs: const <_SubSeed>[
              _SubSeed(_nana, '《悠哉日常大王》可以试试，适合睡前看。', agree: 11),
              _SubSeed(_gardenGhost, '《虫师》，节奏很慢，配乐也好。', agree: 8),
            ],
            agree: 93,
            ip: '四川',
          ),
          _post(
            _nana,
            <TiebaPostContent>[
              _text('《悠哉日常大王》可以试试，适合睡前看。'),
              _emoji('赞'),
            ],
            agree: 22,
            ip: '广东',
          ),
          _post(
            _gardenGhost,
            <TiebaPostContent>[
              _text('《虫师》，节奏很慢，配乐也好。'),
            ],
            agree: 16,
            ip: '浙江',
          ),
        ],
      ),
      _ThreadSeed(
        tid: '8310042763',
        fid: '4',
        forumName: '核战避难所',
        title: '半夜楼下一直有猫叫，要不要下去看看',
        author: _gardenGhost,
        createdAgo: const Duration(hours: 3),
        lastReplyAgo: const Duration(minutes: 11),
        views: 3420,
        replies: 51,
        agrees: 64,
        disagrees: 1,
        posts: <_PostSeed>[
          _post(
            _gardenGhost,
            <TiebaPostContent>[
              _text(
                '已经叫了快半个小时，听着不像发情，像是被什么东西卡住了。\n'
                '我住六楼，下去一趟有点犹豫，现在穿着睡衣在门口站了半天。',
              ),
              _photo('cat'),
            ],
            subs: const <_SubSeed>[
              _SubSeed(_lateCat, '带个手电和纸箱下去看看吧，真卡住了越早越好。', agree: 15),
              _SubSeed(_me, '先确认位置，别贸然伸手。', agree: 7),
            ],
            agree: 64,
            ip: '浙江',
          ),
          _post(
            _lateCat,
            <TiebaPostContent>[
              _text('带个手电和纸箱下去看看吧，真卡住了越早越好。'),
            ],
            agree: 28,
            ip: '浙江',
          ),
          _post(
            _me,
            <TiebaPostContent>[_text('先确认位置，别贸然伸手。'), _emoji('滑稽')],
            agree: 13,
            ip: '广东',
          ),
        ],
      ),
      _ThreadSeed(
        tid: '8315298810',
        fid: '5',
        forumName: '抗压背锅',
        title: '工作第三年，第一次觉得开会比加班还累',
        author: _noodleSoup,
        createdAgo: const Duration(hours: 20),
        lastReplyAgo: const Duration(minutes: 3),
        views: 18420,
        replies: 203,
        agrees: 421,
        disagrees: 12,
        posts: <_PostSeed>[
          _post(
            _noodleSoup,
            <TiebaPostContent>[
              _text(
                '项目本身不算难，难的是每天下午那两个小时的会。\n'
                '每个人都在说，但没人在听，最后问题还是回到原样。\n'
                '加班至少还能看到东西在往前走。',
              ),
            ],
            subs: const <_SubSeed>[
              _SubSeed(_oldRadio, '开会最怕没有结论，散会等于没开。', agree: 20),
              _SubSeed(_fries, '我们组现在改成站着开了，效率高不少。', agree: 14),
            ],
            agree: 421,
            ip: '湖北',
          ),
          _post(
            _oldRadio,
            <TiebaPostContent>[_text('开会最怕没有结论，散会等于没开。')],
            agree: 56,
            ip: '江苏',
          ),
          _post(
            _fries,
            <TiebaPostContent>[_text('我们组现在改成站着开了，效率高不少。')],
            agree: 31,
            ip: '上海',
          ),
        ],
      ),
      _ThreadSeed(
        tid: '8320001145',
        fid: '6',
        forumName: '图片',
        title: '周末去郊区拍的几张照片，求轻喷',
        author: _mountainSleep,
        createdAgo: const Duration(hours: 8),
        lastReplyAgo: const Duration(minutes: 15),
        views: 7620,
        replies: 59,
        agrees: 218,
        disagrees: 3,
        isGood: true,
        posts: <_PostSeed>[
          _post(
            _mountainSleep,
            <TiebaPostContent>[
              _text('周六起了个大早，雾还没散。用的是很普通的套机镜头，后期只拉了曲线。'),
              _photo('forest'),
              _photo('sea'),
              _photo('train'),
              _text('最后一张是在回程的车上拍的，手有点抖。'),
            ],
            subs: const <_SubSeed>[
              _SubSeed(_blueScreen, '第二张的层次很好，构图再往下压一点会更稳。', agree: 12),
              _SubSeed(_lateCat, '喜欢最后一张，抖得刚好。', agree: 7),
            ],
            agree: 218,
            ip: '四川',
          ),
          _post(
            _blueScreen,
            <TiebaPostContent>[
              _text('第二张的层次很好，构图再往下压一点会更稳。'),
            ],
            agree: 26,
            ip: '湖北',
          ),
          _post(
            _lateCat,
            <TiebaPostContent>[_text('喜欢最后一张，抖得刚好。'), _emoji('赞')],
            agree: 15,
            ip: '浙江',
          ),
        ],
      ),
      _ThreadSeed(
        tid: '8324419027',
        fid: '7',
        forumName: '猫',
        title: '捡到一只小橘，去医院检查完了，记录一下',
        author: _nana,
        createdAgo: const Duration(days: 1, hours: 3),
        lastReplyAgo: const Duration(minutes: 9),
        views: 11280,
        replies: 146,
        agrees: 387,
        disagrees: 1,
        posts: <_PostSeed>[
          _post(
            _nana,
            <TiebaPostContent>[
              _text(
                '晚上倒垃圾的时候在车底下看到的，大概两个月大，身上有点脏。\n'
                '带去做了基础检查，没有猫瘟，就是有点营养不良。\n'
                '医生说过一周再来驱虫，先给它弄了个小窝。',
              ),
              _photo('kitten'),
              _text('刚到家的时候一直躲在角落，现在已经会自己出来了。'),
            ],
            subs: const <_SubSeed>[
              _SubSeed(_gardenGhost, '眼睛很亮，养一阵子就好看了。', agree: 18),
              _SubSeed(_lateCat, '注意保暖，小猫这个季节最容易感冒。', agree: 11),
            ],
            agree: 387,
            ip: '广东',
          ),
          _post(
            _gardenGhost,
            <TiebaPostContent>[_text('眼睛很亮，养一阵子就好看了。')],
            agree: 45,
            ip: '浙江',
          ),
          _post(
            _lateCat,
            <TiebaPostContent>[_text('注意保暖，小猫这个季节最容易感冒。')],
            agree: 33,
            ip: '浙江',
          ),
        ],
        video: TiebaVideoInfo(
          videoUrl:
              'https://interactive-examples.mdn.mozilla.net/media/cc0-videos/flower.mp4',
          thumbnailUrl: _photos['flowers']!,
          width: 1280,
          height: 720,
        ),
      ),
      _ThreadSeed(
        tid: '8329917642',
        fid: '8',
        forumName: '钢笔',
        title: '百乐 78G 换了墨胆之后下水有点大，正常吗',
        author: _pencilBox,
        createdAgo: const Duration(hours: 17),
        lastReplyAgo: const Duration(minutes: 33),
        views: 2840,
        replies: 42,
        agrees: 58,
        disagrees: 0,
        posts: <_PostSeed>[
          _post(
            _pencilBox,
            <TiebaPostContent>[
              _text(
                '之前一直用原装上墨器，换成墨胆之后明显粗了一圈，纸上偶尔会洇。\n'
                '纸是普通的 80g 复印纸，墨是百乐自家的黑。\n'
                '是墨胆的问题还是我这支本来就这样？',
              ),
              _photo('pen'),
            ],
            subs: const <_SubSeed>[
              _SubSeed(_me, '墨胆刚插上会有一小段下水偏大，写两页再看看。', agree: 6),
              _SubSeed(_noodleSoup, '也可能是个体差异，78G 品控一直比较随缘。', agree: 4),
            ],
            agree: 58,
            ip: '江苏',
          ),
          _post(
            _me,
            <TiebaPostContent>[
              _text('墨胆刚插上会有一小段下水偏大，写两页再看看。'),
              _at('铅笔盒', _pencilBox.uid),
            ],
            agree: 12,
            ip: '广东',
          ),
          _post(
            _noodleSoup,
            <TiebaPostContent>[_text('也可能是个体差异，78G 品控一直比较随缘。'), _emoji('吃瓜')],
            agree: 7,
            ip: '湖北',
          ),
        ],
      ),
      _ThreadSeed(
        tid: '8334012580',
        fid: '9',
        forumName: '摄影',
        title: '入了一台二手 A7M3，第一次拍夜景',
        author: _blueScreen,
        createdAgo: const Duration(hours: 11),
        lastReplyAgo: const Duration(minutes: 21),
        views: 5960,
        replies: 73,
        agrees: 141,
        disagrees: 2,
        posts: <_PostSeed>[
          _post(
            _blueScreen,
            <TiebaPostContent>[
              _text(
                '快门数一万出头，成色比预期好。昨晚在江边试了一组，手持 ISO 开到 3200。\n'
                '第一次用全画幅，高感确实比之前那台残幅安心很多。',
              ),
              _photo('night'),
              _photo('city'),
            ],
            subs: const <_SubSeed>[
              _SubSeed(_mountainSleep, '夜景可以试试稍微欠曝一点，后期再拉回来。', agree: 9),
              _SubSeed(_lateCat, '江边风大，记得带块小毛巾擦镜头。', agree: 3),
            ],
            agree: 141,
            ip: '湖北',
          ),
          _post(
            _mountainSleep,
            <TiebaPostContent>[
              _text('夜景可以试试稍微欠曝一点，后期再拉回来。'),
            ],
            agree: 18,
            ip: '四川',
          ),
          _post(
            _lateCat,
            <TiebaPostContent>[_text('江边风大，记得带块小毛巾擦镜头。')],
            agree: 8,
            ip: '浙江',
          ),
        ],
      ),
      _ThreadSeed(
        tid: '8338820194',
        fid: '10',
        forumName: '单机游戏',
        title: '《星露谷》玩到第三年，终于把社区中心修好了',
        author: _summerRoll,
        createdAgo: const Duration(days: 1, hours: 9),
        lastReplyAgo: const Duration(minutes: 47),
        views: 8710,
        replies: 96,
        agrees: 203,
        disagrees: 1,
        posts: <_PostSeed>[
          _post(
            _summerRoll,
            <TiebaPostContent>[
              _text(
                '断断续续玩了快一百个小时，最后差一个红叶卷心菜，等了一整年。\n'
                '修好那天在社区中心站了半天，音乐一响还挺舍不得的。\n'
                '现在准备慢慢把农场重新布局一下。',
              ),
              _photo('game'),
            ],
            subs: const <_SubSeed>[
              _SubSeed(_fries, '红叶卷心菜真的是卡进度神器。', agree: 16),
              _SubSeed(_oldRadio, '建议先别急着布局，等冬天再说。', agree: 6),
            ],
            agree: 203,
            ip: '湖北',
          ),
          _post(
            _fries,
            <TiebaPostContent>[_text('红叶卷心菜真的是卡进度神器。'), _emoji('笑哭')],
            agree: 38,
            ip: '上海',
          ),
          _post(
            _oldRadio,
            <TiebaPostContent>[_text('建议先别急着布局，等冬天再说。')],
            agree: 11,
            ip: '江苏',
          ),
        ],
      ),
      _ThreadSeed(
        tid: '8342290671',
        fid: '11',
        forumName: '足球',
        title: '昨晚这场球的后腰问题是不是被放大了',
        author: _ticketStub,
        createdAgo: const Duration(hours: 6),
        lastReplyAgo: const Duration(minutes: 5),
        views: 24310,
        replies: 318,
        agrees: 512,
        disagrees: 47,
        poll: _PollSeed(
          '你觉得这场主要问题在哪？',
          <_PollOptionSeed>[
            _PollOptionSeed(1, '后腰覆盖不足', 1832),
            _PollOptionSeed(2, '边路回防太慢', 942),
            _PollOptionSeed(3, '换人调整偏保守', 1216),
            _PollOptionSeed(4, '前锋把握机会差', 764),
          ],
          participants: 4754,
        ),
        posts: <_PostSeed>[
          _post(
            _ticketStub,
            <TiebaPostContent>[
              _text(
                '赛后很多人盯着后腰说，但我觉得上半场的问题更多在边路回防。\n'
                '后腰已经被拉得很开了，再要求他一个人覆盖两个肋部不现实。\n'
                '当然，下半场换人确实慢了一拍。',
              ),
              _photo('football'),
            ],
            subs: const <_SubSeed>[
              _SubSeed(_oldRadio, '同意，第三个丢球边后卫根本没回来。', agree: 24),
              _SubSeed(_noodleSoup, '换人这个我保留意见，替补席上也没更好的人。', agree: 2),
            ],
            agree: 512,
            ip: '湖南',
          ),
          _post(
            _oldRadio,
            <TiebaPostContent>[
              _text('同意，第三个丢球边后卫根本没回来。'),
            ],
            agree: 87,
            ip: '江苏',
          ),
          _post(
            _noodleSoup,
            <TiebaPostContent>[
              _text('换人这个我保留意见，替补席上也没更好的人。'),
            ],
            agree: 34,
            ip: '湖北',
          ),
        ],
      ),
      _ThreadSeed(
        tid: '8347721055',
        fid: '12',
        forumName: '机械键盘',
        title: '客制化第一把，65 配列手感分享',
        author: _keycapThief,
        createdAgo: const Duration(days: 1, hours: 1),
        lastReplyAgo: const Duration(minutes: 29),
        views: 4380,
        replies: 57,
        agrees: 112,
        disagrees: 2,
        posts: <_PostSeed>[
          _post(
            _keycapThief,
            <TiebaPostContent>[
              _text(
                '套件是铝坨坨，轴用的线性轴，卫星轴自己润了一遍。\n'
                '第一次装花了两个晚上，最麻烦的是调卫星轴，空格按下去终于不响了。\n'
                '键帽暂时先用便宜的 PBT，等以后有预算再换。',
              ),
              _photo('keyboard'),
              _photo('desk'),
            ],
            subs: const <_SubSeed>[
              _SubSeed(_blueScreen, '空格调好之后那种干脆的声音确实上头。', agree: 8),
              _SubSeed(_pencilBox, '桌面挺干净的，线走得也好。', agree: 4),
            ],
            agree: 112,
            ip: '浙江',
          ),
          _post(
            _blueScreen,
            <TiebaPostContent>[_text('空格调好之后那种干脆的声音确实上头。')],
            agree: 19,
            ip: '湖北',
          ),
          _post(
            _pencilBox,
            <TiebaPostContent>[_text('桌面挺干净的，线走得也好。')],
            agree: 9,
            ip: '江苏',
          ),
        ],
      ),
      _ThreadSeed(
        tid: '8351009928',
        fid: '1',
        forumName: '孙笑川',
        title: '有没有人和我一样，越到年底越不想社交',
        author: _me,
        createdAgo: const Duration(hours: 16),
        lastReplyAgo: const Duration(minutes: 13),
        views: 9320,
        replies: 88,
        agrees: 197,
        disagrees: 6,
        posts: <_PostSeed>[
          _post(
            _me,
            <TiebaPostContent>[
              _text(
                '以前还会主动约人吃饭，现在下班只想回家。\n'
                '不是讨厌谁，就是觉得说话很费劲。\n'
                '周末把手机静音放一天，反而轻松很多。',
              ),
              _emoji('托腮'),
            ],
            subs: const <_SubSeed>[
              _SubSeed(_fries, '同感，年底的饭局能推就推了。', agree: 14),
              _SubSeed(_oldRadio, '偶尔独处一下挺好的，别把自己关太久就行。', agree: 9),
            ],
            agree: 197,
            ip: '广东',
          ),
          _post(
            _fries,
            <TiebaPostContent>[_text('同感，年底的饭局能推就推了。')],
            agree: 36,
            ip: '上海',
          ),
          _post(
            _oldRadio,
            <TiebaPostContent>[
              _text('偶尔独处一下挺好的，别把自己关太久就行。'),
            ],
            agree: 21,
            ip: '江苏',
          ),
        ],
      ),
      _ThreadSeed(
        tid: '8356630142',
        fid: '2',
        forumName: '碧蓝航线',
        title: '新人刚入坑，先练哪几艘船比较合适',
        author: _whiteNoise,
        createdAgo: const Duration(hours: 4),
        lastReplyAgo: const Duration(minutes: 19),
        views: 3120,
        replies: 36,
        agrees: 45,
        disagrees: 1,
        posts: <_PostSeed>[
          _post(
            _whiteNoise,
            <TiebaPostContent>[
              _text(
                '刚玩三天，船坞里乱七八糟的，不知道先练谁。\n'
                '现在主要用初始几艘在推图，打到第三章有点吃力了。',
              ),
            ],
            subs: const <_SubSeed>[
              _SubSeed(_summerRoll, '先练一艘奶和一艘战列，别平均分资源。', agree: 7),
            ],
            agree: 45,
            ip: '山东',
          ),
          _post(
            _summerRoll,
            <TiebaPostContent>[
              _text('先练一艘奶和一艘战列，别平均分资源。'),
            ],
            agree: 15,
            ip: '湖北',
          ),
        ],
      ),
      _ThreadSeed(
        tid: '8360042290',
        fid: '6',
        forumName: '图片',
        title: '拍了一组雨天窗户，颜色有点脏，想听听意见',
        author: _southWind,
        createdAgo: const Duration(hours: 7),
        lastReplyAgo: const Duration(minutes: 37),
        views: 4120,
        replies: 28,
        agrees: 76,
        disagrees: 1,
        posts: <_PostSeed>[
          _post(
            _southWind,
            <TiebaPostContent>[
              _text('隔着玻璃拍的，对焦有点犹豫。后期只降了一点饱和，还是很闷。'),
              _photo('rain'),
              _photo('window'),
            ],
            subs: const <_SubSeed>[
              _SubSeed(_mountainSleep, '可以试试把白平衡往冷里拉一点，雾感会更干净。', agree: 6),
            ],
            agree: 76,
            ip: '四川',
          ),
          _post(
            _mountainSleep,
            <TiebaPostContent>[
              _text('可以试试把白平衡往冷里拉一点，雾感会更干净。'),
            ],
            agree: 13,
            ip: '四川',
          ),
        ],
      ),
      _ThreadSeed(
        tid: '8364417008',
        fid: '7',
        forumName: '猫',
        title: '小橘第一次学会用猫砂盆，录了一段',
        author: _lateCat,
        createdAgo: const Duration(hours: 2),
        lastReplyAgo: const Duration(minutes: 8),
        views: 5210,
        replies: 33,
        agrees: 144,
        disagrees: 0,
        posts: <_PostSeed>[
          _post(
            _lateCat,
            <TiebaPostContent>[
              _text('折腾了半天，终于知道要往里刨了。视频有点糊，将就看。'),
              TiebaVideoContent(
                link:
                    'https://interactive-examples.mdn.mozilla.net/media/cc0-videos/flower.mp4',
                cover: _photos['flowers'],
                width: 1280,
                height: 720,
              ),
            ],
            subs: const <_SubSeed>[
              _SubSeed(_nana, '哈哈，小猫第一次都这样。', agree: 5),
            ],
            agree: 144,
            ip: '浙江',
          ),
          _post(
            _nana,
            <TiebaPostContent>[_text('哈哈，小猫第一次都这样。'), _emoji('笑哭')],
            agree: 22,
            ip: '广东',
          ),
        ],
        video: TiebaVideoInfo(
          videoUrl:
              'https://interactive-examples.mdn.mozilla.net/media/cc0-videos/flower.mp4',
          thumbnailUrl: _photos['flowers']!,
          width: 1280,
          height: 720,
        ),
      ),
    ];
