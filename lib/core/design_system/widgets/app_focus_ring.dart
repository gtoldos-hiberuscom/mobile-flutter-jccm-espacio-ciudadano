import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';

/// Indicador de foco de teclado común a toda la app (técnica C40 del W3C).
///
/// Pinta dos bordes de 2 dp alrededor de [child] mientras este, o cualquiera
/// de sus descendientes, tiene el foco del teclado: uno oscuro y otro claro,
/// de modo que al menos uno alcanza 3:1 sobre cualquier fondo (WCAG 1.4.11) y
/// el foco no se transmite sólo mediante color (1.4.1, 2.4.7). Se dibuja en
/// primer plano, sin alterar el layout: enfocar un control no lo desplaza.
///
/// Sólo se muestra al navegar con teclado ([FocusHighlightMode.traditional]):
/// un control que recibe el foco por programa (p. ej. con `autofocus`) mientras
/// se usa la pantalla táctil no se marca.
///
/// No crea una parada nueva en el orden del foco ni un nodo semántico: sólo
/// escucha.
///
/// Con [trackEnclosingFocus] se observa el [FocusNode] más cercano *por encima*
/// del widget en lugar de sus descendientes. Lo necesitan los contenidos que
/// Material envuelve en su propio `InkWell` (p. ej. las pestañas de un
/// `TabBar`), cuyo nodo de foco es un ancestro del contenido.
class AppFocusRing extends StatefulWidget {
  const AppFocusRing({
    required this.child,
    super.key,
    this.borderRadius = const BorderRadius.all(Radius.circular(AppDimensions.radiusXs)),
    this.trackEnclosingFocus = false,
    this.enabled = true,
  });

  /// Grosor de cada uno de los dos bordes.
  static const double strokeWidth = 2;

  /// Borde exterior: contrasta con fondos claros.
  static const Color darkColor = AppColors.neutral1000;

  /// Borde interior: contrasta con fondos oscuros y con el borde exterior.
  static const Color lightColor = AppColors.surface;

  final Widget child;

  /// Radio del anillo; debe seguir al del control envuelto.
  final BorderRadius borderRadius;

  /// Observa el nodo de foco ancestro más cercano en lugar de los descendientes.
  final bool trackEnclosingFocus;

  /// Permite apagar el anillo (p. ej. en controles deshabilitados).
  final bool enabled;

  @override
  State<AppFocusRing> createState() => _AppFocusRingState();
}

class _AppFocusRingState extends State<AppFocusRing> {
  bool _hasFocus = false;
  FocusNode? _enclosingNode;
  bool _isKeyboardMode = FocusManager.instance.highlightMode == FocusHighlightMode.traditional;

  @override
  void initState() {
    super.initState();
    FocusManager.instance.addHighlightModeListener(_handleHighlightModeChange);
  }

  void _handleHighlightModeChange(final FocusHighlightMode mode) {
    final isKeyboardMode = mode == FocusHighlightMode.traditional;
    if (!mounted || isKeyboardMode == _isKeyboardMode) {
      return;
    }
    setState(() => _isKeyboardMode = isKeyboardMode);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncEnclosingNode();
  }

  @override
  void didUpdateWidget(covariant final AppFocusRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.trackEnclosingFocus != widget.trackEnclosingFocus) {
      _syncEnclosingNode();
    }
  }

  @override
  void dispose() {
    FocusManager.instance.removeHighlightModeListener(_handleHighlightModeChange);
    _enclosingNode?.removeListener(_handleEnclosingFocusChange);
    super.dispose();
  }

  void _syncEnclosingNode() {
    FocusNode? node;
    if (widget.trackEnclosingFocus) {
      // Un scope tiene el foco siempre que algo de la pantalla lo tenga: no
      // sirve como referencia del control concreto.
      final candidate = Focus.maybeOf(context, scopeOk: true);
      node = candidate is FocusScopeNode ? null : candidate;
    }
    if (identical(node, _enclosingNode)) {
      return;
    }
    _enclosingNode?.removeListener(_handleEnclosingFocusChange);
    _enclosingNode = node?..addListener(_handleEnclosingFocusChange);
    _hasFocus = node?.hasFocus ?? false;
  }

  void _handleEnclosingFocusChange() => _setFocus(_enclosingNode?.hasFocus ?? false);

  void _setFocus(final bool value) {
    if (!mounted || value == _hasFocus) {
      return;
    }
    setState(() => _hasFocus = value);
  }

  @override
  Widget build(final BuildContext context) {
    final ring = CustomPaint(
      foregroundPainter: widget.enabled && _hasFocus && _isKeyboardMode ? AppFocusRingPainter(borderRadius: widget.borderRadius) : null,
      child: widget.child,
    );
    if (widget.trackEnclosingFocus) {
      return ring;
    }
    return Focus(
      canRequestFocus: false,
      skipTraversal: true,
      includeSemantics: false,
      onFocusChange: _setFocus,
      child: ring,
    );
  }
}

/// Pinta el doble borde de [AppFocusRing] dentro de los límites del control.
///
/// Se dibuja hacia dentro para que ningún `ClipRRect` o lista lo recorte.
class AppFocusRingPainter extends CustomPainter {
  const AppFocusRingPainter({required this.borderRadius});

  final BorderRadius borderRadius;

  @override
  void paint(final Canvas canvas, final Size size) {
    const stroke = AppFocusRing.strokeWidth;
    final bounds = borderRadius.toRRect(Offset.zero & size);
    final outer = bounds.deflate(stroke / 2);
    final inner = bounds.deflate(stroke * 1.5);
    canvas
      ..drawRRect(
        outer,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke
          ..color = AppFocusRing.darkColor,
      )
      ..drawRRect(
        inner,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke
          ..color = AppFocusRing.lightColor,
      );
  }

  @override
  bool shouldRepaint(covariant final AppFocusRingPainter oldDelegate) => oldDelegate.borderRadius != borderRadius;
}
