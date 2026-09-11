import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_page_layout.dart';

void main() {
  Future<BuildContext> pumpContext(final WidgetTester tester, final Size size) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size;
    addTearDown(tester.view.reset);
    late BuildContext captured;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (final context) {
            captured = context;
            return const SizedBox();
          },
        ),
      ),
    );
    return captured;
  }

  testWidgets('phone keeps the 16 dp page margin', (final tester) async {
    final context = await pumpContext(tester, const Size(390, 844));
    expect(isTabletLayout(context), isFalse);
    expect(appPageHorizontalPadding(context), AppDimensions.space16);
    expect(
      appPagePadding(context, top: AppDimensions.space24, bottom: 112),
      const EdgeInsets.fromLTRB(AppDimensions.space16, AppDimensions.space24, AppDimensions.space16, 112),
    );
  });

  for (final size in [const Size(800, 1100), const Size(1100, 800)]) {
    testWidgets('tablet uses the 40 dp home margin at $size', (final tester) async {
      final context = await pumpContext(tester, size);
      expect(isTabletLayout(context), isTrue);
      expect(appPageHorizontalPadding(context), AppDimensions.space40);
      expect(
        appPagePadding(context, top: AppDimensions.space24, bottom: 112),
        const EdgeInsets.fromLTRB(AppDimensions.space40, AppDimensions.space24, AppDimensions.space40, 112),
      );
    });
  }
}
