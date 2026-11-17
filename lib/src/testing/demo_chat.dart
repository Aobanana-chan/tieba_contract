part of 'demo_tieba_api.dart';

/// 演示后端里一个个人会话的内存状态。
class _DemoChatState {
  _DemoChatState({
    required this.peer,
    this.unread = 0,
    this.muted = false,
  });

  final _Persona peer;
  int unread;
  bool muted;
  bool blocked = false;
  final List<TiebaChatMessage> messages = <TiebaChatMessage>[];
}

/// 演示消息种子：正文、是否本人发送、距今分钟数。
class _ChatSeedLine {
  const _ChatSeedLine(this.text, this.mine, this.minutesAgo);

  final String text;
  final bool mine;
  final int minutesAgo;
}
