import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
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
      child: AppAlertContextual(
        size: AppAlertContextualSize.small,
        message: AppLocalizations.of(context).representativeUnavailableMessage,
      ),
    );
  }
}
