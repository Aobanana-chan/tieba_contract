/// 通知中心（吧友互助 / 吧广播）可选接口。
///
/// 与 [TiebaApi] 分开定义：互助未读和广播红点依赖官方 IM，不是所有后端都能
/// 提供；界面用 `api is TiebaNotificationApi` 判断后再启用对应表面。
///
/// 没有 IM 的后端也应实现开关读取 / 写入与广播历史；概览返回
/// [TiebaNotificationOverview.empty] 即可。
library;

import '../model/notification.dart';

abstract interface class TiebaNotificationApi {
  /// 通知中心概览。
  ///
  /// 实时互助未读与广播红点来自官方 IM；没有 IM 时返回空概览，
  /// 不要用本地计时器或缓存猜测红点。
  Future<TiebaNotificationOverview> getNotificationOverview();

  /// 读取吧友互助的账号级屏蔽状态（`switch_type=45`）。
  Future<bool> getMutualHelpMasked();

  /// 写入吧友互助的账号级屏蔽状态。
  ///
  /// [masked] 为 true 表示「已屏蔽」：卡片保留，但隐藏未读数字。
  Future<void> setMutualHelpMasked(bool masked);

  /// 按吧读取吧广播历史（`getForumBroadcastList`）。
  ///
  /// [cursor] 为上一页最后一条广播 id，首页传 0；[count] 固定 15 与官方一致。
  Future<TiebaBroadcastPage> getBroadcastHistory({
    required String forumId,
    int cursor = 0,
    int count = 15,
  });

  /// 聚合「吧广播」信息流。
  ///
  /// 官方客户端的聚合来自 IM 官方历史；没有 IM 的后端可以用关注吧的
  /// 广播历史合并出同一套卡片，但不要伪造不存在的广播。
  Future<List<TiebaBroadcastItem>> getBroadcastFeed({int limit = 80});

  /// 批量刷新已加载广播的阅读数。
  ///
  /// 协议只保证 `pv` 可用，返回 `bcast_id -> pv`；失败时调用方保留旧值。
  Future<Map<String, int>> refreshBroadcastPv({
    required String forumId,
    required List<String> bcastIds,
  });

  /// 本月吧广播剩余次数；无权限或接口失败时返回 null。
  Future<TiebaBroadcastQuota?> getBroadcastQuota(String forumId);
}
