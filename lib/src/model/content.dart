/// 帖子内容段：帖子正文由若干段拼成，界面按内容段的运行时类型分派渲染。
library;

/// 内容段类型，与贴吧客户端的 `PbContent.type` / `Abstract.type` 原始值对应。
///
/// - `30`–`33` 归并为文字；`52` 是投票阵营徽章；`35` / `36` 都表示吧内嵌应用；
/// - 无法识别的原始值（如 `6`、`8`、`1284`）归为 [unknown]；
/// - 字段来源不同的类型（如 `14` 图文链接、`20` 表情包大图）保留独立枚举值，
///   转换层据此选择字段，[TiebaPostContent.type] 保留原始语义。
enum TiebaContentType {
  /// 文字（原始值 `0`；`30`–`33` 归并为此值）。
  text(0),

  /// 链接（`1`，`text` + `link`）。
  link(1),

  /// 贴吧表情（`2`，`text` = 表情资源名，`c` = 表情名）。
  emoji(2),

  /// 图片（`3`）。
  image(3),

  /// 投票阵营徽章（`52`）；图案按主题取自 `theme_color`。
  voteBadge(52),

  /// @某人（`4`，`text` = 昵称，`uid` = 用户 id）。
  at(4),

  /// 视频（`5`）。
  video(5),

  /// 电话（`9`，官方以 `phonetype` 作为拨打链接）。
  phone(9),

  /// 语音（`10`，`voice_md5` + `during_time`）。
  voice(10),

  /// 动态表情（`11`，`c` = 表情名，`dynamic` / `_static` 为动图 / 静图地址）。
  gifEmotion(11),

  /// 链接按钮（`13`，`btn_type`）。
  linkButton(13),

  /// 图文链接（`14`，`src` = 配图，`link` = 跳转地址）。
  linkImage(14),

  /// 话题（`18`，`text` + `link`）。
  topic(18),

  /// 表情包大图（`20`，`meme_info`）。
  meme(20),

  /// 道具（`27`，`item_id` / `item_forum_name`，官方按图标 + 可点文字渲染）。
  item(27),

  /// 吧内嵌应用（`35`；卡片变体 `36` 归并为此值，`tiebaplus_info`）。
  tiebaPlus(35),

  /// 道具卡片（`37`，`item` 消息，官方按纯文本渲染）。
  itemCard(37),

  /// 热议话题（`40`，搜索词跳转）。
  hotTopic(40),

  /// 带图标链接（`51`，`target_scheme` 跳转）。
  iconLink(51),

  /// 视频播放链接（`53`，`text` = 标题，`link` = 播放页地址）。
  videoLink(53),

  /// 内联图标（`1536`，`icon` 字段，无文字）。
  inlineIcon(1536),

  /// 节日 / 活动提示（`1282`，官方按话题样式渲染）。
  festivalTip(1282),

  /// 文字插件（`1283`，`text_plugin.plugins_txt`）。
  textPlugin(1283),

  /// 未识别类型（按文字处理）。
  unknown(-1);

  const TiebaContentType(this.rawValue);

  /// 官方协议里的原始类型值（[unknown] 无对应原始值，恒为 `-1`）。
  final int rawValue;

  /// 官方原始类型值 → 枚举（归并规则见各枚举项文档）。
  static TiebaContentType fromRaw(int raw) {
    switch (raw) {
      case 0:
      case 30:
      case 31:
      case 32:
      case 33:
        return TiebaContentType.text;
      case 1:
        return TiebaContentType.link;
      case 2:
        return TiebaContentType.emoji;
      case 3:
        return TiebaContentType.image;
      case 52:
        return TiebaContentType.voteBadge;
      case 4:
        return TiebaContentType.at;
      case 5:
        return TiebaContentType.video;
      case 9:
        return TiebaContentType.phone;
      case 10:
        return TiebaContentType.voice;
      case 11:
        return TiebaContentType.gifEmotion;
      case 13:
        return TiebaContentType.linkButton;
      case 14:
        return TiebaContentType.linkImage;
      case 18:
        return TiebaContentType.topic;
      case 20:
        return TiebaContentType.meme;
      case 27:
        return TiebaContentType.item;
      case 35:
      case 36:
        return TiebaContentType.tiebaPlus;
      case 37:
        return TiebaContentType.itemCard;
      case 40:
        return TiebaContentType.hotTopic;
      case 51:
        return TiebaContentType.iconLink;
      case 53:
        return TiebaContentType.videoLink;
      case 1536:
        return TiebaContentType.inlineIcon;
      case 1282:
        return TiebaContentType.festivalTip;
      case 1283:
        return TiebaContentType.textPlugin;
      default:
        return TiebaContentType.unknown;
    }
  }
}

/// 内容段基类，界面按运行时类型分派渲染；[type] 保留官方原始类型语义，
/// 供界面做次级样式区分（如道具链接、表情包大图）。
abstract class TiebaPostContent {
  final TiebaContentType type;

  const TiebaPostContent({required this.type});
}

/// 文字。
class TiebaTextContent extends TiebaPostContent {
  String text;
  String? uid;

  TiebaTextContent({required this.text, this.uid, TiebaContentType? type})
      : super(type: type ?? TiebaContentType.text);
}

/// 图片段（原始类型 `3`）。
///
/// 同一张图可能有多个候选地址（缩略、大图、原图等），界面按场景选择。
class TiebaImageContent extends TiebaPostContent {
  ///大图 CDN（`big_cdn_src`）。
  String? bigCdnSrc;

  ///原图（`origin_src`）。
  String? originSrc;

  ///尺寸 `"宽,高"`。
  String? bsize;

  ///缩略图（`src`）。
  String? src;

  ///缩略图 CDN（`cdn_src`）。
  String? cdnSrc;

  ///大图（`big_src`）。
  String? bigSrc;

  ///首楼 / 动图专用 CDN（`cdn_src_active`）。
  String? cdnSrcActive;

  TiebaImageContent({
    this.bigCdnSrc,
    this.bsize,
    this.originSrc,
    this.src,
    this.cdnSrc,
    this.bigSrc,
    this.cdnSrcActive,
    TiebaContentType? type,
  }) : super(type: type ?? TiebaContentType.image);

  ///楼层 / 卡片显示用的地址。
  ///
  ///选择顺序：`cdn_src_active` → `big_cdn_src`(回退 `big_src`) →
  ///`cdn_src`(回退 `src`)；末尾补 `origin_src` 兜底。
  String get displaySrc =>
      _first([cdnSrcActive, bigCdnSrc, bigSrc, cdnSrc, src, originSrc]);

  ///省流量 / 无图档用的地址（优先缩略图那条链）。
  String get lowFlowSrc =>
      _first([cdnSrcActive, cdnSrc, src, bigCdnSrc, bigSrc, originSrc]);

  ///查看大图用的原图地址。
  String get originalSrc =>
      _first([originSrc, bigCdnSrc, bigSrc, cdnSrc, src, cdnSrcActive]);

  ///`bsize` 按 `"宽,高"` 拼接后的数值，缺失或非法时为 0。
  int get bsizeValue => int.tryParse((bsize ?? '').replaceAll(',', '')) ?? 0;

  static String _first(List<String?> candidates) {
    for (final String? candidate in candidates) {
      if (candidate != null && candidate.isNotEmpty) {
        return candidate;
      }
    }
    return '';
  }
}

/// 投票阵营徽章（原始类型 `52`）。
///
/// 界面根据 [imageUrl] 识别阵营并渲染对应样式。
class TiebaVoteBadgeContent extends TiebaPostContent {
  final String imageUrl;

  TiebaVoteBadgeContent({this.imageUrl = ''})
      : super(type: TiebaContentType.voteBadge);

  bool get isEmpty => imageUrl.isEmpty;
}

/// @某人。
class TiebaAtContent extends TiebaPostContent {
  String text;
  String uid;

  TiebaAtContent({required this.text, required this.uid})
      : super(type: TiebaContentType.at);
}

/// 表情（原始类型 `2` 贴吧表情 / `11` 动态表情）。
class TiebaEmojiContent extends TiebaPostContent {
  ///渲染用的表情资源名（如 `image_emoticon25`）。
  String text;

  ///纯文本回退（`#(c)`）用的表情名。
  String c;

  ///动态表情动图地址（原始类型 `11` 的 `dynamic`）。
  String? dynamicUrl;

  ///动态表情静图地址（原始类型 `11` 的 `_static`）。
  String? staticUrl;

  TiebaEmojiContent({
    required this.c,
    required this.text,
    this.dynamicUrl,
    this.staticUrl,
    TiebaContentType? type,
  }) : super(type: type ?? TiebaContentType.emoji);
}

/// 视频。
class TiebaVideoContent extends TiebaPostContent {
  String? link;
  String? cover;

  /// 视频画面像素尺寸，用于首帧前的预排版；未知时为 null。
  int? width;
  int? height;

  TiebaVideoContent({this.link, this.cover, this.width, this.height})
      : super(type: TiebaContentType.video);
}

/// 链接（原始类型 `1`；`13` 链接按钮、`27` 道具、`35` / `36` 吧内嵌应用、
/// `40` 热议话题、`51` 带图标链接官方也按链接渲染，[type] 保留原始语义）。
class TiebaLinkContent extends TiebaPostContent {
  String link;
  String text;

  TiebaLinkContent({
    required this.link,
    required this.text,
    TiebaContentType? type,
  }) : super(type: type ?? TiebaContentType.link);
}

/// 电话号码。
class TiebaPhoneContent extends TiebaPostContent {
  String text;

  TiebaPhoneContent({required this.text})
      : super(type: TiebaContentType.phone);
}

/// 语音。
class TiebaVoiceContent extends TiebaPostContent {
  String text;

  ///语音文件 md5（`voice_md5`），可用于拼装下载地址。
  String? voiceMd5;

  ///时长（秒，`during_time`）。
  int? duringTime;

  TiebaVoiceContent({required this.text, this.voiceMd5, this.duringTime})
      : super(type: TiebaContentType.voice);
}

/// 话题（原始类型 `18`；`1282` 节日 / 活动提示官方按话题样式渲染）。
class TiebaTopicContent extends TiebaPostContent {
  String text;
  String link;

  TiebaTopicContent({
    required this.text,
    required this.link,
    TiebaContentType? type,
  }) : super(type: type ?? TiebaContentType.topic);
}

/// 视频播放链接（原始类型 `53`，`text` = 标题，`link` = 播放页地址）。
class TiebaVideoLinkContent extends TiebaPostContent {
  String text;
  String link;

  TiebaVideoLinkContent({required this.text, required this.link})
      : super(type: TiebaContentType.videoLink);
}
