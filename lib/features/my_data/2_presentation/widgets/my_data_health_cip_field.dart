import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/my_data_health_cip_missing.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_health_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Identificador CIP del ciudadano ante el SESCAM.
///
/// Lo muestran las dos consultas de citas —primaria y hospitalaria—, así que
/// vive aquí y no dentro de una de ellas.
///
/// Se resuelve con `when` y **nunca** con `asData?.value`: con lo segundo, un
/// fallo del servicio se presentaba como «no tienes CIP», que es justo el tipo
/// de mensaje falso que prohíbe el apartado 2.2 del requisito. Son tres cosas
/// distintas y se cuentan distinto: no hay CIP registrado, no se ha podido
/// consultar, o aquí está.
class MyDataHealthCipField extends ConsumerWidget {
  const MyDataHealthCipField({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final style = AppTypography.captionRegular.copyWith(color: AppColors.primary);

    return ref.watch(myDataHealthCipProvider).when(
      loading: () => Text(l10n.myDataHealthCipValue('…'), style: style),
      error: (final error, final _) => error is MyDataHealthCipMissing
          ? AppAlertContextual(
              message: l10n.agendaHealthCipMissing,
              size: AppAlertContextualSize.small,
              announce: true,
            )
          : Text(l10n.myDataHealthCipUnavailable, style: style),
      data: (final cip) => cip == null || cip.isEmpty
          ? Text(l10n.myDataHealthCipUnavailable, style: style)
          : Text(l10n.myDataHealthCipValue(cip), style: style),
    );
  }
}
