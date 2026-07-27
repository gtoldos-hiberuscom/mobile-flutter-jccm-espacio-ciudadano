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
    required this.badges,
    this.responsibleUnit,
    this.submissionStartDate,
    this.submissionEndDate,
    this.submissionStatusText,
    this.detailUrl,
  });

  final String id;
  final String title;
  final int lifeEventId;
  final String lifeEventName;
  final Set<RecommendationBadge> badges;
  RecommendationBadge? get badge {
    if (badges.contains(RecommendationBadge.immediate)) {
      return RecommendationBadge.immediate;
    }
    if (badges.contains(RecommendationBadge.news)) {
      return RecommendationBadge.news;
    }
    if (badges.contains(RecommendationBadge.recent)) {
      return RecommendationBadge.recent;
    }
    return null;
  }

  final String? responsibleUnit;
  final DateTime? submissionStartDate;
  final DateTime? submissionEndDate;
  final String? submissionStatusText;
  final Uri? detailUrl;

  bool get isImmediate => badges.contains(RecommendationBadge.immediate);
}
