import 'package:flutter/widgets.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';

/// Shortest-side breakpoint from which the app uses the tablet layout.
const double appTabletBreakpoint = 600;

/// Whether the current window should use the tablet layout.
bool isTabletLayout(final BuildContext context) => MediaQuery.sizeOf(context).shortestSide >= appTabletBreakpoint;

/// Horizontal page margin shared by every screen: 40 dp on tablet (same as
/// the home dashboard), 16 dp on phone.
double appPageHorizontalPadding(final BuildContext context) => isTabletLayout(context) ? AppDimensions.space40 : AppDimensions.space16;

/// Page-level insets using [appPageHorizontalPadding] on both sides.
EdgeInsets appPagePadding(final BuildContext context, {final double top = 0, final double bottom = 0}) {
  final horizontal = appPageHorizontalPadding(context);
  return EdgeInsets.fromLTRB(horizontal, top, horizontal, bottom);
}
