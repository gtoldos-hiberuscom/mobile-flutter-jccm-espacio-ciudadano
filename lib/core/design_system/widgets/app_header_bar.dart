import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_icons.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_focus_ring.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

class AppHeaderBar extends StatelessWidget implements PreferredSizeWidget {
  const AppHeaderBar({
    required this.title,
    required this.onBack,
    super.key,
    this.onInfo,
    this.actions = const [],
    this.backgroundColor = AppColors.backgroundWhite,
    this.leadingIcon = AppIcons.arrowBack,
    this.leadingTooltip,
    this.infoTooltip,
    this.titleSemanticsLabel,
  }) : assert(title != '', 'title must not be empty'),
       assert(
         leadingTooltip == null || leadingTooltip != '',
         'leadingTooltip must not be empty',
       ),
       assert(infoTooltip == null || infoTooltip != '', 'infoTooltip must not be empty'),
       assert(
         titleSemanticsLabel == null || titleSemanticsLabel != '',
         'titleSemanticsLabel must not be empty',
       );

  final String title;
  final VoidCallback onBack;
  final VoidCallback? onInfo;
  final List<Widget> actions;
  final Color backgroundColor;
  final IconData leadingIcon;
  final String? leadingTooltip;
  final String? infoTooltip;
  final String? titleSemanticsLabel;

  static const double _baseHeight = 64;

  /// Margen vertical del título dentro de la barra.
  static const double _titleVerticalPadding = AppDimensions.space8;

  /// Altura de la barra para que el título quepa entero, en tantas líneas
  /// como necesite, con el texto ampliado (WCAG 1.4.4). Se mide el título al
  /// ancho que le dejan los iconos; sin ampliación la barra conserva sus
  /// 64 dp de diseño.
  double _heightFor({required final TextScaler textScaler, required final double screenWidth}) {
    final iconCount = 1 + actions.length + (onInfo == null ? 0 : 1);
    final titleWidth = screenWidth - iconCount * AppDimensions.minTouchTarget - AppDimensions.space8 * 2;
    final painter = TextPainter(
      text: TextSpan(text: title, style: AppTypography.h3),
      textDirection: TextDirection.ltr,
      textScaler: textScaler,
    )..layout(maxWidth: titleWidth > 0 ? titleWidth : 0);
    final needed = painter.height.ceilToDouble() + _titleVerticalPadding * 2;
    painter.dispose();
    return needed > _baseHeight ? needed : _baseHeight;
  }

  /// Altura de la barra, sin el margen superior del sistema, para el
  /// contexto dado. La usan las pantallas que la desplazan con el contenido.
  double toolbarHeightOf(final BuildContext context) => _heightFor(
    textScaler: MediaQuery.textScalerOf(context),
    screenWidth: MediaQuery.sizeOf(context).width,
  );

  /// `Scaffold` recorta la barra a esta altura. El getter no recibe contexto:
  /// la ampliación y el ancho se leen de la vista, de donde los deriva
  /// `MediaQuery` en la app.
  @override
  Size get preferredSize {
    final dispatcher = WidgetsBinding.instance.platformDispatcher;
    final view = dispatcher.implicitView ?? dispatcher.views.first;
    return Size.fromHeight(
      _heightFor(
        textScaler: TextScaler.linear(dispatcher.textScaleFactor),
        screenWidth: view.physicalSize.width / view.devicePixelRatio,
      ),
    );
  }

  /// Los iconos de la barra llevan el anillo de foco común (WCAG 1.4.11 /
  /// 2.4.7), circular como el propio botón.
  static Widget _withFocusRing(final Widget child) => AppFocusRing(
    borderRadius: const BorderRadius.all(Radius.circular(AppDimensions.minTouchTarget / 2)),
    child: child,
  );

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final semanticTitle = titleSemanticsLabel ?? title;
    final systemTextScaler = MediaQuery.textScalerOf(context);

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: toolbarHeightOf(context),
      titleSpacing: 0,
      shape: const Border(
        bottom: BorderSide(color: AppColors.backgroundBlueMutedLight),
      ),
      title: Row(
        children: [
          Semantics(
            header: true,
            headingLevel: 1,
            sortKey: const OrdinalSortKey(0),
            label: semanticTitle,
            child: const SizedBox(width: 1, height: 1),
          ),
          _withFocusRing(
            IconButton(
              icon: AppIcon(leadingIcon, size: AppDimensions.iconLarge, color: AppColors.textPrimary),
              onPressed: onBack,
              tooltip: leadingTooltip ?? l10n.a11yBack,
            ),
          ),
          const SizedBox(width: AppDimensions.space8),
          Expanded(
            child: ExcludeSemantics(
              // Sin límite de líneas: la barra crece con el título. `AppBar`
              // limita la ampliación del título a 1,34; se recupera la del
              // sistema para que llegue al 200 % (WCAG 1.4.4).
              // `AppBar` impone además un título de una sola línea con puntos
              // suspensivos: se permite el salto de línea.
              child: Text(
                title,
                softWrap: true,
                overflow: TextOverflow.visible,
                textScaler: systemTextScaler,
                style: AppTypography.h3.copyWith(color: AppColors.primary),
              ),
            ),
          ),
          ...actions.map(_withFocusRing),
          if (onInfo != null)
            _withFocusRing(
              IconButton(
                icon: const AppIcon(AppIcons.info, color: AppColors.textPrimary),
                onPressed: onInfo,
                tooltip: infoTooltip ?? l10n.a11yInformation,
              ),
            ),
        ],
      ),
    );
  }
}
