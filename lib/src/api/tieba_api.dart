/// Tiebanana 的后端契约。
///
/// 实现方把协议数据转换成契约中的数据模型。接口不包含网络、签名或序列化细节；
/// 实现所需的存储、屏幕与提示回调由 [TiebaApiHost] 提供。
///
/// - 网络与业务错误通过 [NetAPIError] 抛出；发帖、举报另有专用异常。
/// - 返回的数据模型只需填界面用到的字段，协议冗余由实现方处理。
library;

import 'thread_publish.dart';
import 'moderation.dart';

import 'exceptions.dart';
import 'value_types.dart';
import '../model/forum.dart';
import '../model/floor.dart';
import '../model/media.dart';
import '../model/topic.dart';
import '../model/message.dart';
import '../model/search.dart';
import '../model/store.dart';
import '../model/thread.dart';
import '../model/user.dart';

/// 贴吧功能入口。
abstract class TiebaApi {
  Future<TiebaReportForm> getReportForm(TiebaReportTarget target);
  Future<void> submitReport(TiebaReportForm form, TiebaReportInput input);
  Future<List<TiebaReportThread>> getReportThreads(String portrait);
  Future<TiebaBlockSettings> getBlockSettings(String uid);
  Future<void> setBlockSettings(String uid, TiebaBlockSettings settings);

  // ── 登录态 ──────────────────────────────────────────────────────────────

  /// 当前是否已登录。
  bool get isLogin;

  /// 初始化：加载持久化凭证、探测登录态。
  Future<void> init();

  /// 检查是否登录（不发起业务请求）。
  Future<bool> checkLogin();

  /// 退出登录（清空本地凭证）。
  void logout();

  /// 网页登录：把 WebView 持有的凭证写入本地。
  ///
  /// [hostCookies]：key 为站点 url，value 为该站点下的 cookie 串
  /// （如 `"BDUSS=xx; yy=zz"`）。返回凭证是否有效。
  Future<bool> applyWebviewLogin(Map<String, String> hostCookies);

  /// 获取本人信息。
  Future<MyUserData> getMyInfo();

  // ── 读取 ────────────────────────────────────────────────────────────────

  /// 帖子页。
  Future<TiebaThreadPage> getThreadPage(
    String kz, {
    String? pid,
    int pn = 1,
    int rn = 30,
    bool onlyLz = false,
  });

  /// 吧主页。
  ///
  /// [tab] 为要拉取的页签（空则不指定，由服务端给默认流）；页签的
  /// `sort_menu` / `sub_tabs` 选中项分别用 [sortType] / [cid] 传回。
  /// [isgood] 为精品贴，[cid] 为精品分类，[sortType] 为排序。
  /// [frsCommonInfo] / [topCardId] 是上一次响应带回的上下文，原样回传。
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
  });

  /// 首页推荐流（[pageThreadCount] 为一页帖子数，[pn] 从 1 起）。
  Future<RecommendPage> getRecommThread(int pageThreadCount, int pn);

  /// 楼中楼。
  Future<InnerFloor> getInnerFloor(
    String kz,
    String pid, {
    String spid = "",
    int pn = 1,
    int rn = 20,
  });

  /// 用户资料（个人页 / 访客页）。
  Future<TiebaUserProfile> getUserInfo({required String uid, int pn = 1});

  /// 用户发的主题帖。
  Future<TiebaUserPostPage> getUserPost({
    required String uid,
    int pn = 1,
    int rn = 20,
  });

  /// 用户回复（低版本接口）。
  Future<TiebaUserPostPage> getUserPostLowVersion({
    required String uid,
    int pn = 1,
    int rn = 20,
  });

  /// 用户关注的吧。
  Future<UserForumLikePage> getUserForumnLike(
    String uid,
    String myUid,
    int pn,
    int pageSize,
  );

  /// 回复我的。
  Future<MessagePage> getReply(int pn);

  /// @我的。
  Future<MessagePage> getAtMe(int pn);

  /// 给我点赞。
  Future<MessagePage> getLike(int pn);

  /// 官方 `c/s/msg` 分类提醒数。
  Future<MessageUnreadCounts> getMessageUnread();

  /// 搜索吧。
  Future<SearchForumResult> searchForum(String keywords, int pn, {int rn = 10});

  /// 搜索贴。[order]：0 旧贴在前 / 1 新贴在前 / 2 相关度；
  /// [filter]：1 只看主题帖 / 0 全部。
  ///
  /// [fname] 非空时限定在该吧内搜索（吧内搜索）；为空为全站搜索。
  Future<SearchPostPage> searchPost(
    String keywords, {
    int pn = 1,
    int order = 0,
    int filter = 1,
    int ct = 2,
    String? fname,
  });

  /// 话题头（官方聚合页 `PageData.topic`）。
  ///
  /// [topicId] / [fid] / [forumName] 为调用方已知的兜底值。
  /// `topic_id=0` 时按 [name] 解析真实 ID；解析失败且已有 [topicId]
  /// 时返回最小话题头，使讨论流仍可加载。
  Future<TiebaTopicDetail> getTopicDetail({
    required String name,
    String topicId = '',
    String fid = '',
    String forumName = '',
  });

  /// 话题讨论流。
  ///
  /// [sort]：1 热门 / 2 最新；[lastId] 为上一页的游标，首页传空串。
  Future<TiebaTopicThreadPage> getTopicThreads({
    required String name,
    String topicId = '',
    int page = 1,
    int sort = 1,
    String lastId = '',
  });

  /// 综合搜索：吧卡与贴卡混排（官方 `mo/q/search/multsearch`）。
  Future<SearchMixedPage> searchMixed(String keywords,
      {int pn = 1, int rn = 20});

  /// 搜索用户。
  Future<SearchUserResult> searchUser(String keyword);

  /// 收藏贴。
  Future<ThreadStorePage> getThreadStore(int offset, String myUid,
      {int rn = 20});

  /// 关注的吧（带登录态缓存；调用 [refreshLikes] 强制刷新）。
  Future<List<LikeForumInfo>> getLikes();

  /// 刷新关注的吧缓存。
  Future<void> refreshLikes();

  /// 已缓存的本人 uid（未登录/未加载为 null）。
  int? get cachedUid;

  /// 取本人 uid（可能触发加载）。
  Future<int?> getUID();

  // ── 写入 ────────────────────────────────────────────────────────────────

  /// 修改当前登录账号资料；null 表示不修改，空签名表示清空。
  /// 频率限制、审核与校验失败通过 [NetAPIError] 返回。
  /// 实现方应保留未修改及界面未展示的资料字段。
  Future<TiebaProfileUpdateResult> updateUserProfile({
    String? nickname,
    String? intro,
    String? sex,
  });

  /// 上传并设置当前账号头像。[image] 为已裁切的正方形图片。
  Future<TiebaAvatarUpdateResult> updateAvatar(UploadFile image);

  /// 点赞 / 点踩。
  ///
  /// [objType]：1 楼层 / 2 楼中楼 / 3 主题；
  /// [opType]：0 点赞或踩 / 1 取消；
  /// [agreeType]：2 赞 / 5 踩。
  /// [forumId]：所在吧 ID，主题操作应传入。
  Future<void> agreePost(
    String postID,
    String threadID,
    int objType, {
    String? forumId,
    int agreeType = 2,
    int opType = 0,
  });

  /// 参与主楼投票。
  ///
  /// [optionIds] 为选中的选项 ID；单选传一个，多选传多个。
  /// [forumId] 为帖所在吧 ID。成功后调用方应重新拉取帖子页刷新票数。
  Future<void> voteThreadPoll(
    String threadID,
    String forumId,
    Set<int> optionIds,
  );

  /// 新建主题。配图标记已包含在 content 中；不支持的选项会明确报错。
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
  });

  Future<TiebaPublisherConfig> getPublisherConfig({required String fid});

  Future<List<TiebaComposeTopic>> searchComposeTopics(
      {required String fid, String prefix = ''});

  /// 回帖。返回服务端提示文案（可能为空串）。
  Future<String> replyThread(
    String content,
    String kw,
    String fid,
    String tid, {
    List<String>? photos,
  });

  /// 回复楼层。返回服务端提示文案（可能为空串）。
  Future<String> replyFloor(
    String content,
    String kw,
    String fid,
    String tid,
    String floorId, {
    List<String>? photos,
    String replyUID = "",
  });

  /// 关注一个吧。
  Future<void> favoForum(String fid, String forumName);

  /// 取消关注一个吧。
  Future<void> unfavoForum({required String fid, required String forumName});

  /// 收藏一个贴。
  Future<void> threadAddStore(String tid, String pid, {int status = 1});

  /// 取消收藏贴。
  Future<void> threadRemoveStore(String tid);

  /// 一键签到所有关注的吧。
  Future<void> signAll();

  /// 单吧签到。
  Future<SignResult> signOneForum(String kw, {String? fid});

  /// 上传图片（回帖配图）。
  Future<TiebaUploadedImage> uploadPicture(
    String forumName,
    bool saveOrigin,
    UploadFile file,
  );
}
