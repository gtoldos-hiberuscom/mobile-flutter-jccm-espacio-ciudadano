import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/technical_support_link.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Sustituye el contenido de «Mis datos» cuando la sesión pertenece a un
/// representante, manteniendo accesible la pestaña «Información y servicios».
class MyDataRepresentativeUnavailable extends StatelessWidget {
  const MyDataRepresentativeUnavailable({super.key});

  @override
  Widget build(final BuildContext context) {
    return SingleChildScrollView(
      padding: appPagePadding(
        context,
        top: AppDimensions.space24,
        bottom: AppDimensions.space24,
      ),
      child: const MyDataRepresentativeUnavailableAlert(),
    );
  }
}

/// Aviso de información no disponible con certificado de representante, con
/// el enlace a «soporte técnico» al final de la frase.
class MyDataRepresentativeUnavailableAlert extends StatelessWidget {
  const MyDataRepresentativeUnavailableAlert({super.key});

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppAlertContextual(
      size: AppAlertContextualSize.small,
      message: l10n.representativeUnavailableMessage,
      messageLink: technicalSupportMessageLink(context),
    );
  }
}
