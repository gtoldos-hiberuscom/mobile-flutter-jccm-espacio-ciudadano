import 'package:meta/meta.dart';

enum RecommendationBadge {
  recent,
  news,
  immediate,
}

@immutable
final class Recommendation {
  const Recommendation({
    required this.id,
    required this.title,
    required this.lifeEventId,
    required this.lifeEventName,
    required this.badge,
    this.responsibleUnit,
    this.submissionStartDate,
    this.submissionEndDate,
    this.detailUrl,
  });

  final String id;
  final String title;
  final int lifeEventId;
  final String lifeEventName;
  final RecommendationBadge badge;
  final String? responsibleUnit;
  final DateTime? submissionStartDate;
  final DateTime? submissionEndDate;
  final Uri? detailUrl;

  bool get isImmediate => badge == RecommendationBadge.immediate;
}
