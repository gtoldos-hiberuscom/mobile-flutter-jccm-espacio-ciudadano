import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_health_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Identificador CIP del ciudadano ante el SESCAM.
///
/// Se muestra una sola vez, en el menú de Salud y encima de las dos consultas
/// de citas (Figma `45045:57735`): es un dato del ciudadano, no de una de ellas.
///
/// Sin CIP, o sin poder consultarlo, se muestra «CIP: -» y nada más: el menú no
/// afirma que el CIP no exista ni deshabilita las consultas, porque cada una
/// tiene su propio servicio y cuenta su propio error al entrar. Hospitalaria ni
/// siquiera depende del CIP.
const _noCip = '-';

class MyDataHealthCipField extends ConsumerWidget {
  const MyDataHealthCipField({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    // Figma 45049:59358: Body/Caption sobre ColorBrand/Primary/Base.
    final style = AppTypography.bodyCaption.copyWith(color: AppColors.primary);

    return ref.watch(myDataHealthCipProvider).when(
      loading: () => Text(l10n.myDataHealthCipLabel('…'), style: style),
      error: (final _, final _) => Text(l10n.myDataHealthCipLabel(_noCip), style: style),
      data: (final cip) => Text(l10n.myDataHealthCipLabel(cip == null || cip.isEmpty ? _noCip : cip), style: style),
    );
  }
}
