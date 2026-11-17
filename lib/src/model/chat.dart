/// 私信（个人聊天）的展示模型。
///
/// 只承载界面能直接消费的字段：群聊、图片、语音、大表情等首版不做的内容
/// 不会出现在这些类型里。所有 id 都使用 String，和契约里其它模型保持一致。
library;

/// 一条私信在界面上可能处于的状态。
enum TiebaChatMessageStatus {
  /// 已插入本地列表，等待服务端响应。
  sending,

  /// 服务端已确认。
  sent,

  /// 发送失败（网络或服务端拒绝），可复用同一个 recordId 重试。
  failed,
}

/// 会话（首版只有 `groupType = 6` 的个人私信）。
class TiebaConversation {
  const TiebaConversation({
    required this.id,
    required this.peerUid,
    required this.title,
    required this.groupType,
    this.avatar = '',
    this.lastMessage = '',
    this.lastMessageIsMine = false,
    this.lastMessageRead = true,
    this.lastMessageType = 1,
    this.lastTime,
    this.unread = 0,
    this.isMuted = false,
    this.isBlocked = false,
    this.userType = 0,
  });

  /// 会话 id。个人会话里等于对方 uid（协议强推断）。
  final String id;

  /// 对方 uid。
  final String peerUid;

  /// 会话标题（对方昵称）。
  final String title;

  /// 对方头像。
  final String avatar;

  /// 本机最后一条消息摘要；没有本机记录时为空。
  final String lastMessage;

  /// 最后一条消息是否由本人发出（列表摘要加「我：」）。
  final bool lastMessageIsMine;

  /// 本人发出的最后一条消息是否已被对方读到。
  ///
  /// 只在 [lastMessageIsMine] 为 true 时有意义；对方发来的消息统一为 true，
  /// 避免把「他还没读自己的消息」误画成己方未读。无法确认时也按已读处理，
  /// 不臆造「未读」。
  final bool lastMessageRead;

  /// 最后一条消息类型；首版只渲染 1（文本）。
  final int lastMessageType;

  /// 最后消息时间。
  final DateTime? lastTime;

  /// 本地未读数。
  final int unread;

  /// 会话类型，首版为 6。
  final int groupType;

  /// 是否免打扰。
  final bool isMuted;

  /// 是否已屏蔽（只读镜像；以服务端下一次响应为准）。
  final bool isBlocked;

  /// 官方账号类型（IM `UserInfo.userType`）。0 表示未知/普通用户。
  final int userType;

  /// 个人会话。
  bool get isPrivate => groupType == 6;

  /// 官方只读会话：`userType` 3/4 的账号只接收消息，界面不提供输入框。
  /// 对齐官方 `OfficialBarChatActivity.initView`：3 与 4 都会隐藏底部输入栏。
  bool get isReadOnly => userType == 3 || userType == 4;

  TiebaConversation copyWith({
    String? id,
    String? peerUid,
    String? title,
    String? avatar,
    String? lastMessage,
    bool? lastMessageIsMine,
    bool? lastMessageRead,
    int? lastMessageType,
    DateTime? lastTime,
    int? unread,
    int? groupType,
    bool? isMuted,
    bool? isBlocked,
    int? userType,
  }) {
    return TiebaConversation(
      id: id ?? this.id,
      peerUid: peerUid ?? this.peerUid,
      title: title ?? this.title,
      avatar: avatar ?? this.avatar,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageIsMine: lastMessageIsMine ?? this.lastMessageIsMine,
      lastMessageRead: lastMessageRead ?? this.lastMessageRead,
      lastMessageType: lastMessageType ?? this.lastMessageType,
      lastTime: lastTime ?? this.lastTime,
      unread: unread ?? this.unread,
      groupType: groupType ?? this.groupType,
      isMuted: isMuted ?? this.isMuted,
      isBlocked: isBlocked ?? this.isBlocked,
      userType: userType ?? this.userType,
    );
  }
}

/// 私信消息。
class TiebaChatMessage {
  const TiebaChatMessage({
    required this.id,
    required this.localId,
    required this.recordId,
    required this.conversationId,
    required this.senderUid,
    required this.content,
    required this.time,
    this.type = 1,
    this.status = TiebaChatMessageStatus.sent,
    this.isRead = true,
    this.duration = 0,
    this.raw = '',
  });

  /// 服务端 mid；本地未确认的消息为空串。
  final String id;

  /// 本地 mid（服务端 mid * 100）；本地消息可使用 recordId。
  final String localId;

  /// 客户端生成的记录 id，用于失败重试与去重。
  final String recordId;

  /// 会话 id。
  final String conversationId;

  /// 发送者 uid。
  final String senderUid;

  /// 消息类型，首版只处理文本 `1`。
  final int type;

  /// 消息正文。贴吧表情以 `#(…)` token 形式存在于正文里。
  final String content;

  /// 消息时间。
  final DateTime time;

  /// 发送状态。
  final TiebaChatMessageStatus status;

  /// 是否已读。
  ///
  /// 对方发来的消息：本人是否已经读到；本人发出的消息：对方是否已经读到。
  /// 己方消息在收到 22 已读回执前保持 false，界面显示「未读」。
  final bool isRead;

  /// 语音时长（秒），首版不使用。
  final int duration;

  /// 分享卡片等原始结构，首版不渲染。
  final String raw;

  bool get isText => type == 1;

  TiebaChatMessage copyWith({
    String? id,
    String? localId,
    String? recordId,
    String? conversationId,
    String? senderUid,
    int? type,
    String? content,
    DateTime? time,
    TiebaChatMessageStatus? status,
    bool? isRead,
    int? duration,
    String? raw,
  }) {
    return TiebaChatMessage(
      id: id ?? this.id,
      localId: localId ?? this.localId,
      recordId: recordId ?? this.recordId,
      conversationId: conversationId ?? this.conversationId,
      senderUid: senderUid ?? this.senderUid,
      type: type ?? this.type,
      content: content ?? this.content,
      time: time ?? this.time,
      status: status ?? this.status,
      isRead: isRead ?? this.isRead,
      duration: duration ?? this.duration,
      raw: raw ?? this.raw,
    );
  }
}

/// 消息分页游标：指向当前页之前的一条消息。
class ChatCursor {
  const ChatCursor({this.beforeId = ''});

  /// 早于这条消息 id 的记录。空串表示从最新一页开始。
  final String beforeId;

  bool get isEmpty => beforeId.isEmpty;
}

/// 一页私信消息（按时间升序）。
class ChatMessagePage {
  const ChatMessagePage({
    required this.messages,
    this.hasMore = false,
    this.nextCursor,
  });

  final List<TiebaChatMessage> messages;

  /// 是否还有更早的本机记录。
  final bool hasMore;

  /// 继续向前翻页的游标；[hasMore] 为 false 时为 null。
  final ChatCursor? nextCursor;
}

/// 发送草稿。
class ChatDraft {
  const ChatDraft({
    required this.text,
    this.type = 1,
    this.recordId = '',
  });

  /// 文本草稿。表情是正文里的 `#(…)` token。
  const ChatDraft.text(this.text)
      : type = 1,
        recordId = '';

  /// 消息类型；首版固定为 1。
  final int type;

  /// 正文。
  final String text;

  /// 失败重试时复用同一个 recordId；为空时由后端分配。
  final String recordId;

  ChatDraft withRecordId(String value) =>
      ChatDraft(text: text, type: type, recordId: value);
}

/// 发送被拦截时，服务端给出的提示。
class ChatBlockInfo {
  const ChatBlockInfo({
    this.errno = 0,
    this.message = '',
    this.dealUrl = '',
    this.confirm = '',
    this.cancel = '',
  });

  final int errno;
  final String message;
  final String dealUrl;
  final String confirm;
  final String cancel;
}

/// 发送结果。被拦截时 [message] 停在 failed，[block] 非空。
class ChatSendResult {
  const ChatSendResult({required this.message, this.block});

  final TiebaChatMessage message;
  final ChatBlockInfo? block;

  bool get blocked => block != null;
}

/// IM 屏蔽 / 免打扰设置。
class ChatMaskSettings {
  const ChatMaskSettings({
    required this.userId,
    this.muteNotifications = false,
    this.blocked = false,
    this.remindMask = 0,
    this.maskedUids = const <String>{},
  });

  /// 设置目标用户（个人会话等于对方 uid）。
  final String userId;

  /// 免打扰：只影响提醒，不影响未读计数。
  final bool muteNotifications;

  /// 是否已屏蔽该用户（只读镜像）。
  ///
  /// 屏蔽写入走贴吧的用户拉黑/私信权限（`TiebaBlockSettings.chat`），
  /// IM 侧只同步展示，不通过 [ChatMaskSettings] 双写。
  final bool blocked;

  /// 服务端原始 remindMask。
  final int remindMask;

  /// 服务端下发的屏蔽 uid 列表（只读镜像）。
  final Set<String> maskedUids;

  ChatMaskSettings copyWith({
    String? userId,
    bool? muteNotifications,
    bool? blocked,
    int? remindMask,
    Set<String>? maskedUids,
  }) {
    return ChatMaskSettings(
      userId: userId ?? this.userId,
      muteNotifications: muteNotifications ?? this.muteNotifications,
      blocked: blocked ?? this.blocked,
      remindMask: remindMask ?? this.remindMask,
      maskedUids: maskedUids ?? this.maskedUids,
    );
  }
}
