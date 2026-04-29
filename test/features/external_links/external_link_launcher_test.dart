import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/analytics/analytics_event.dart';
import 'package:jccm_espacio_ciudadano/core/analytics/analytics_screen.dart';
import 'package:jccm_espacio_ciudadano/core/analytics/analytics_service.dart';
import 'package:jccm_espacio_ciudadano/core/logging/app_logger.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/0_entity/external_link.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/0_entity/external_link_category.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/1_domain/external_link_launcher.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/3_data/external_link_catalog_impl.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/3_data/url_launcher_external_link_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  group('UrlLauncherExternalLinkLauncher', () {
    late _RecordingAnalytics analytics;
    late _NoopLogger logger;
    const catalog = ExternalLinkCatalogImpl();

    setUp(() {
      analytics = _RecordingAnalytics();
      logger = _NoopLogger();
    });

    UrlLauncherExternalLinkLauncher buildLauncher({
      required final LaunchUrlFn launch,
    }) => UrlLauncherExternalLinkLauncher(
      catalog: catalog,
      analytics: analytics,
      logger: logger,
      launchUrlFn: launch,
    );

    test('rejects non-https schemes without calling the platform', () async {
      var called = false;
      final launcher = buildLauncher(
        launch: (final url, {final mode = LaunchMode.platformDefault}) async {
          called = true;
          return true;
        },
      );

      final link = ExternalLink(
        id: 'educamos_clm',
        displayKey: 'externalLinkEducamosClmLabel',
        url: Uri.parse('http://educamosclm.castillalamancha.es/'),
        category: ExternalLinkCategory.educationCLM,
      );

      final result = await launcher.launch(link);

      expect(called, isFalse);
      expect(result, isA<ExternalLinkLaunchFailure>());
      expect(
        (result as ExternalLinkLaunchFailure).reason,
        ExternalLinkLaunchFailureReason.invalidScheme,
      );
      expect(
        analytics.failedReasons,
        contains('invalidScheme'),
      );
    });

    test('rejects hosts not in the catalog (open-redirect guard)', () async {
      var called = false;
      final launcher = buildLauncher(
        launch: (final url, {final mode = LaunchMode.platformDefault}) async {
          called = true;
          return true;
        },
      );

      final link = ExternalLink(
        id: 'educamos_clm',
        displayKey: 'externalLinkEducamosClmLabel',
        url: Uri.parse('https://evil.example.com/phish'),
        category: ExternalLinkCategory.educationCLM,
      );

      final result = await launcher.launch(link);

      expect(called, isFalse);
      expect(result, isA<ExternalLinkLaunchFailure>());
      expect(
        (result as ExternalLinkLaunchFailure).reason,
        ExternalLinkLaunchFailureReason.hostMismatch,
      );
      expect(analytics.failedReasons, contains('hostMismatch'));
    });

    test('rejects ids not present in the catalog', () async {
      final launcher = buildLauncher(
        launch: (final url, {final mode = LaunchMode.platformDefault}) async => true,
      );

      final link = ExternalLink(
        id: 'unknown_id',
        displayKey: 'externalLinkSomethingLabel',
        url: Uri.parse('https://educamosclm.castillalamancha.es/'),
        category: ExternalLinkCategory.educationCLM,
      );

      final result = await launcher.launch(link);

      expect(result, isA<ExternalLinkLaunchFailure>());
      expect(
        (result as ExternalLinkLaunchFailure).reason,
        ExternalLinkLaunchFailureReason.hostMismatch,
      );
    });

    test('returns success and emits opened event when platform accepts', () async {
      var seenMode = LaunchMode.platformDefault;
      final launcher = buildLauncher(
        launch: (final url, {final mode = LaunchMode.platformDefault}) async {
          seenMode = mode;
          return true;
        },
      );

      final link = catalog.findById('sede_dgt')!;

      final result = await launcher.launch(link);

      expect(result, isA<ExternalLinkLaunchSuccess>());
      expect(seenMode, LaunchMode.externalApplication);

      expect(analytics.openedSuccess, contains(link.id));
      // Failure event never emitted on success.
      expect(analytics.failedReasons, isEmpty);
    });

    test('returns platformRejected when launchUrl returns false', () async {
      final launcher = buildLauncher(
        launch: (final url, {final mode = LaunchMode.platformDefault}) async => false,
      );

      final link = catalog.findById('sede_dgt')!;

      final result = await launcher.launch(link);

      expect(result, isA<ExternalLinkLaunchFailure>());
      expect(
        (result as ExternalLinkLaunchFailure).reason,
        ExternalLinkLaunchFailureReason.platformRejected,
      );
      expect(analytics.failedReasons, contains('platformRejected'));
    });

    test('returns unknown failure when launchUrl throws', () async {
      final launcher = buildLauncher(
        launch: (final url, {final mode = LaunchMode.platformDefault}) async {
          throw StateError('platform crashed');
        },
      );

      final link = catalog.findById('sede_dgt')!;

      final result = await launcher.launch(link);

      expect(result, isA<ExternalLinkLaunchFailure>());
      expect(
        (result as ExternalLinkLaunchFailure).reason,
        ExternalLinkLaunchFailureReason.unknown,
      );
      expect(analytics.failedReasons, contains('unknown'));
    });

    test('analytics payload never contains the full URL or query string', () async {
      final launcher = buildLauncher(
        launch: (final url, {final mode = LaunchMode.platformDefault}) async => true,
      );

      final link = catalog.findById('educamos_clm')!;

      await launcher.launch(link);

      for (final event in analytics.events) {
        final repr = event.toString();
        expect(repr, isNot(contains(link.url.toString())));
        expect(repr, isNot(contains(link.url.path)));
      }
    });
  });
}

class _RecordingAnalytics implements AnalyticsService {
  final List<AnalyticsEvent> events = <AnalyticsEvent>[];

  List<String> get openedSuccess => events.whereType<ExternalLinkOpenedEvent>().where((final e) => e.success).map((final e) => e.linkId).toList();

  List<String> get failedReasons => events.whereType<ExternalLinkOpenFailedEvent>().map((final e) => e.reason).toList();

  @override
  void logEvent(final AnalyticsEvent event) => events.add(event);

  @override
  void setCurrentScreen(final AnalyticsScreen screen) {}
}

class _NoopLogger implements AppLogger {
  @override
  void debug(final String message, {final Map<String, Object?>? context}) {}

  @override
  void info(final String message, {final Map<String, Object?>? context}) {}

  @override
  void warning(final String message, {final Map<String, Object?>? context}) {}

  @override
  void error(
    final String message, {
    final Object? exception,
    final StackTrace? stackTrace,
    final Map<String, Object?>? context,
  }) {}
}
