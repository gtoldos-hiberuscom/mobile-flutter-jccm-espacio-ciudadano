import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_status.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/2_presentation/notification_detail_page.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/3_data/notification_detail_repository_impl.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/3_data/notification_detail_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

GoRouter _buildRouter({final String initialId = 'NOT-0001'}) => GoRouter(
  initialLocation: '/notifications/$initialId',
  routes: <RouteBase>[
    GoRoute(
      path: '/notifications',
      builder: (final context, final state) => const Scaffold(
        body: Text('NOTIFICATIONS_INBOX'),
      ),
      routes: <RouteBase>[
        GoRoute(
          path: ':id',
          builder: (final context, final state) => NotificationDetailPage(
            notificationId: state.pathParameters['id']!,
          ),
        ),
      ],
    ),
  ],
);

Widget _wrap({
  final bool conflictOnDecision = false,
  final NotificationStatus conflictCurrentStatus = NotificationStatus.aceptada,
  final bool failOnDownload = false,
  final String initialId = 'NOT-0001',
}) {
  return ProviderScope(
    overrides: [
      notificationDetailRepositoryProvider.overrideWith(
        (final ref) => NotificationDetailRepositoryImpl(
          simulatedNetworkDelay: Duration.zero,
          conflictOnDecision: conflictOnDecision,
          conflictCurrentStatus: conflictCurrentStatus,
          failOnDownload: failOnDownload,
        ),
      ),
    ],
    child: MaterialApp.router(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('es'),
      routerConfig: _buildRouter(initialId: initialId),
    ),
  );
}

void main() {
  testWidgets('renders pending detail with accept and reject CTAs', (
    final tester,
  ) async {
    await tester.pumpWidget(_wrap());
    await tester.pump(); // first build → loading
    await tester.pump(); // mock future resolves

    expect(find.text('Detalle de notificación'), findsOneWidget);
    expect(find.text('Pendiente'), findsOneWidget);
    expect(find.text('Aceptar'), findsOneWidget);
    expect(find.text('Rechazar'), findsOneWidget);
    expect(find.textContaining('EXP-2025-00451'), findsOneWidget);
  });

  testWidgets('tapping reject opens the confirmation dialog; cancel keeps state', (
    final tester,
  ) async {
    await tester.pumpWidget(_wrap());
    await tester.pump();
    await tester.pump();

    await tester.tap(find.text('Rechazar'));
    await tester.pump();

    expect(find.text('Confirmar rechazo'), findsOneWidget);
    expect(find.text('Rechazar definitivamente'), findsOneWidget);

    await tester.tap(find.text('Cancelar'));
    await tester.pump();

    // Dialog dismissed, header chip still shows pendiente.
    expect(find.text('Confirmar rechazo'), findsNothing);
    expect(find.text('Pendiente'), findsOneWidget);
  });

  testWidgets('confirming reject submits the decision and shows the rejected toast', (
    final tester,
  ) async {
    await tester.pumpWidget(_wrap());
    await tester.pump();
    await tester.pump();

    await tester.tap(find.text('Rechazar'));
    await tester.pump();
    await tester.tap(find.text('Rechazar definitivamente'));
    // Frame after dialog pop, then submit completes (Duration.zero delay).
    await tester.pump();
    await tester.pump();

    expect(find.text('Has rechazado la notificación.'), findsOneWidget);
    // Drain the 800ms post-toast pop timer so the test exits cleanly.
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pump();
  });

  testWidgets('tapping accept submits directly without a confirmation dialog', (
    final tester,
  ) async {
    await tester.pumpWidget(_wrap());
    await tester.pump();
    await tester.pump();

    await tester.tap(find.text('Aceptar'));
    await tester.pump();
    await tester.pump();

    // No confirmation dialog for accept.
    expect(find.text('Confirmar rechazo'), findsNothing);
    expect(find.text('Has aceptado la notificación.'), findsOneWidget);
    // Drain the 800ms post-toast pop timer so the test exits cleanly.
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pump();
  });

  testWidgets('conflict surfaces the conflict snackbar and refreshes the chip', (
    final tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        conflictOnDecision: true,
        conflictCurrentStatus: NotificationStatus.caducada,
      ),
    );
    await tester.pump();
    await tester.pump();

    await tester.tap(find.text('Aceptar'));
    await tester.pump();
    await tester.pump();

    expect(
      find.text('Esta notificación ya no admite cambios. Hemos actualizado su estado.'),
      findsOneWidget,
    );
    expect(find.text('Caducada'), findsOneWidget);
    // Decision bar disappears because status is no longer pendiente.
    expect(find.text('Aceptar'), findsNothing);
  });

  // ── STORY-44 — variant + documents surfaces ─────────────────────────────

  testWidgets('aceptada variant renders documents list and Leída badge', (
    final tester,
  ) async {
    await tester.pumpWidget(_wrap(initialId: 'acc-1'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Aceptada'), findsOneWidget);
    expect(find.textContaining('Leída el'), findsOneWidget);
    expect(find.text('Documentos asociados'), findsOneWidget);
    expect(find.text('Resolucion-firmada.pdf'), findsOneWidget);
    expect(find.text('Anexos-tecnicos.zip'), findsOneWidget);
    expect(find.text('No disponible'), findsOneWidget);
    // No decision bar for non-pending variants.
    expect(find.text('Aceptar'), findsNothing);
    expect(find.text('Rechazar'), findsNothing);
  });

  testWidgets('caducada variant renders the empty documents state', (
    final tester,
  ) async {
    await tester.pumpWidget(_wrap(initialId: 'exp-1'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Caducada'), findsOneWidget);
    expect(find.text('Documentos asociados'), findsOneWidget);
    expect(
      find.text('No hay documentos asociados a esta notificación.'),
      findsOneWidget,
    );
    expect(find.byTooltip('Descargar documento'), findsNothing);
  });

  testWidgets('tapping download on an available document shows the success snackbar', (
    final tester,
  ) async {
    await tester.pumpWidget(_wrap(initialId: 'rej-1'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Acuse-rechazo.pdf'), findsOneWidget);
    final downloadButton = find.byTooltip('Descargar documento');
    expect(downloadButton, findsOneWidget);

    await tester.ensureVisible(downloadButton);
    await tester.pumpAndSettle();
    await tester.tap(downloadButton);
    // pump for setState (loading flag) + repo future + post-state update.
    await tester.pump();
    await tester.pump();
    await tester.pump();

    expect(find.text('Documento listo'), findsOneWidget);
  });
}
