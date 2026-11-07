/// 发帖输入与结果。
class TiebaPublishPoll {
  const TiebaPublishPoll(
      {required this.title,
      required this.options,
      this.multiple = false,
      this.days = -1});
  final String title;
  final List<String> options;
  final bool multiple;
  final int days;
}

class TiebaPublishResult {
  const TiebaPublishResult(
      {required this.tid, this.pid = '', this.message = ''});
  final String tid;
  final String pid;

  /// 服务端提示，如“审核中”；为空串表示无提示。
  final String message;
}

class TiebaComposeTopic {
  const TiebaComposeTopic(
      {required this.id, required this.name, this.description = ''});
  final String id;
  final String name;
  final String description;
}

/// 发布器配置；声明文案按服务端下发的原文提交。
class TiebaPublisherConfig {
  const TiebaPublisherConfig(
      {required this.statements, this.scoreEnabled = false});
  final List<String> statements;
  final bool scoreEnabled;
}

class TiebaPublishScoreItem {
  const TiebaPublishScoreItem(
      {required this.title,
      required this.content,
      required this.image,
      required this.imageSource});
  final String title;
  final String content;
  final String image;
  final String imageSource;
}

class TiebaPublishScore {
  const TiebaPublishScore({required this.items, this.levelLimit = 0});
  final List<TiebaPublishScoreItem> items;
  final int levelLimit;
}

/// 请求可能已经被服务端处理，禁止自动重试。
class TiebaPublishUncertain implements Exception {
  const TiebaPublishUncertain(this.message);
  final String message;
  @override
  String toString() => message;
}
