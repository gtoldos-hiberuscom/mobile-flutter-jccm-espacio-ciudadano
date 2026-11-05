import 'dart:async' show unawaited;

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Enlace «soporte técnico» con el que terminan los avisos de error de
/// servicio («…contacta con soporte técnico.»). Abre el formulario de soporte
/// de la app.
AppAlertMessageLink technicalSupportMessageLink(final BuildContext context) => AppAlertMessageLink(
  text: AppLocalizations.of(context).technicalSupportLink,
  onTap: () => unawaited(context.push<void>(Routes.supportForm)),
);
