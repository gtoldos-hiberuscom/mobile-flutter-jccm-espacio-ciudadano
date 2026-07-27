import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';

void main() {
  testWidgets('renders the recommendation card from the current design', (
    final tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppRecommendationCard(
            title: 'Nombre del trámite recomendado que puede ser muy largo pero con elipsis a la tercera línea',
            categoryLabels: const [
              'Últimos días',
              'Tramitación inmediata',
            ],
            detailLabel: 'Hechos vitales asociados',
            detailText: 'Quiero acoger - Busco trabajo - Quiero vivir en un pueblo - Quiero estudiar',
            statusLabel: 'Estado',
            statusText: 'Abierto permanentemente',
            onTap: () {},
          ),
        ),
      ),
    );

    expect(find.text('#ÚLTIMOS DÍAS'), findsOneWidget);
    expect(find.text('#TRAMITACIÓN INMEDIATA'), findsOneWidget);
    expect(find.text('HECHOS VITALES ASOCIADOS'), findsOneWidget);
    expect(find.text('ESTADO'), findsOneWidget);
    expect(find.text('Abierto permanentemente'), findsOneWidget);
    expect(find.byIcon(Icons.open_in_new), findsOneWidget);

    final title = tester.widget<Text>(
      find.textContaining('Nombre del trámite recomendado'),
    );
    expect(title.maxLines, 3);
    expect(title.overflow, TextOverflow.ellipsis);
  });
}
