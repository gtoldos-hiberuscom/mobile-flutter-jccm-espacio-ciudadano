import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/discapacidad/2_presentation/discapacidad_detail_page.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/discapacidad/3_data/discapacidad_repository_impl.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/discapacidad/3_data/discapacidad_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

Widget _wrap(final Widget child, {required final DiscapacidadMockVariant variant}) => ProviderScope(
  overrides: [
    discapacidadRepositoryProvider.overrideWithValue(
      DiscapacidadRepositoryImpl(mockVariant: variant),
    ),
  ],
  child: MaterialApp(
    localizationsDelegates: const <LocalizationsDelegate<Object>>[
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('es'),
    home: child,
  ),
);

void main() {
  testWidgets('vigente renders header, grado badge and the PKPass action bar', (final tester) async {
    await tester.pumpWidget(_wrap(const DiscapacidadDetailPage(), variant: DiscapacidadMockVariant.vigente));
    await tester.pumpAndSettle();

    // AppBar / page title.
    expect(find.text('Carnet de discapacidad'), findsWidgets);
    // Holder name visible.
    expect(find.text('Antonio Pérez Soto'), findsOneWidget);
    // Grado badge present and shows "65%".
    expect(find.byKey(const ValueKey('discapacidadGradoBadge')), findsOneWidget);
    expect(find.text('65%'), findsOneWidget);
    // The available body and the PKPass action bar are mounted.
    expect(find.byKey(const ValueKey('discapacidadAvailableBody')), findsOneWidget);
    expect(find.byKey(const ValueKey('discapacidadActionBar-pkpass')), findsOneWidget);
    // No-vigente / no-data / error surfaces are NOT rendered.
    expect(find.byKey(const ValueKey('discapacidadNotValidBody')), findsNothing);
    expect(find.byKey(const ValueKey('discapacidadErrorBody')), findsNothing);
  });

  testWidgets('noVigente renders explicit message and no action bar', (final tester) async {
    await tester.pumpWidget(_wrap(const DiscapacidadDetailPage(), variant: DiscapacidadMockVariant.noVigente));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('discapacidadNotValidBody')), findsOneWidget);
    expect(find.text('Carnet no vigente'), findsOneWidget);
    // The PKPass action bar must not be rendered.
    expect(find.byKey(const ValueKey('discapacidadActionBar-pkpass')), findsNothing);
    expect(find.byKey(const ValueKey('discapacidadAvailableBody')), findsNothing);
  });

  testWidgets('parseError renders the recoverable error widget with retry CTA', (final tester) async {
    await tester.pumpWidget(_wrap(const DiscapacidadDetailPage(), variant: DiscapacidadMockVariant.parseError));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('discapacidadErrorBody')), findsOneWidget);
    // Retry button label is present.
    expect(find.text('Reintentar'), findsOneWidget);
    // No action bar on the error surface.
    expect(find.byKey(const ValueKey('discapacidadActionBar-pkpass')), findsNothing);
  });
}
