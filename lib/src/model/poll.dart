/// 投票数据；null 表示服务端未提供。
class TiebaPoll {
  final String title;
  final bool? multiple;
  final int? participantCount;
  final int? totalVotes;
  final int? optionCount;
  final bool? hasVoted;
  final Set<int> selectedIds;
  final int? endTime;
  final int? remainingSeconds;
  final List<TiebaPollOption> options;

  /// 正反方（`two_options`）；与 [options] 是两套表示。
  final TiebaPollOption? pros;
  final TiebaPollOption? cons;

  TiebaPoll({
    this.title = '',
    this.multiple,
    this.participantCount,
    this.totalVotes,
    this.optionCount,
    this.hasVoted,
    Set<int> selectedIds = const {},
    this.endTime,
    this.remainingSeconds,
    List<TiebaPollOption> options = const [],
    this.pros,
    this.cons,
  })  : selectedIds = Set.unmodifiable(selectedIds),
        options = List.unmodifiable(options);

  bool? endedAt(DateTime now) {
    if (endTime != null &&
        endTime! > 0 &&
        now.millisecondsSinceEpoch ~/ 1000 >= endTime!) {
      return true;
    }
    if (remainingSeconds == null) return null;
    return remainingSeconds! <= 0 && remainingSeconds != -1;
  }
}

class TiebaPollOption {
  final int? id;
  final String text;
  final String imageUrl;
  final int? votes;
  final bool? hasVoted;

  const TiebaPollOption(
      {this.id, this.text = '', this.imageUrl = '', this.votes, this.hasVoted});
}
