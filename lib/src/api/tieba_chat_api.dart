/// 私信（个人聊天）可选接口。
///
/// 私信走独立的 IM 长连接协议，和 [TiebaApi] 的 HTTP protobuf 通道生命周期
/// 不同。为了避免给所有后端增加抽象成员（主版本变更），这里采用独立接口：
/// 界面用 `api is TiebaChatApi` 判断是否支持，不支持时隐藏入口或显示对应状态。
library;

import '../model/chat.dart';

abstract interface class TiebaChatApi {
  /// 会话列表。返回本地缓存 + 最近一次 1001 / 202003 同步结果。
  ///
  /// 首次登录必须等 1001 响应才能拿到完整列表；有缓存时可以先返回本地数据。
  Future<List<TiebaConversation>> getConversations();

  /// 会话消息。只从本机缓存分页，[cursor] 为空时返回最新一页。
  ///
  /// 没有更早的本机记录时 `hasMore = false`，不要伪造服务端翻页。
  Future<ChatMessagePage> getChatMessages(
    String conversationId, {
    ChatCursor? cursor,
    int limit = 30,
  });

  /// 发送文本。先本地插入 `sending`，响应后返回 `sent` 或 `failed`。
  ///
  /// 失败时调用方应保留 [ChatDraft.recordId]（为空则由实现分配并回填），
  /// 重试时复用同一个 recordId，避免服务端产生两条消息。
  Future<ChatSendResult> sendChatMessage(
    String conversationId,
    ChatDraft draft,
  );

  /// 私信未读总数（本地会话 `unread` 求和）。
  Future<int> getChatUnread();

  /// 把会话已读位置推进到 [lastMessageId]。
  ///
  /// 本地未读先清零；上报失败不回滚本地状态，下次进入会再次对齐。
  Future<void> markChatRead(String conversationId, String lastMessageId);

  /// 读取某个会话的 IM 屏蔽 / 免打扰设置。
  Future<ChatMaskSettings> getChatMask(String conversationId);

  /// 更新 IM 免打扰设置。
  ///
  /// [ChatMaskSettings.blocked] 只作只读镜像；屏蔽用户应走
  /// [TiebaApi.setBlockSettings]（`TiebaBlockSettings.chat`），避免双写。
  Future<void> updateChatMask(ChatMaskSettings settings);

  /// 打开会话时补全对方资料（205003）；拿不到时返回 null。
  Future<TiebaConversation?> getChatPeer(String conversationId);
}
