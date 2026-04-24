import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/features/casework/aportacion/0_entity/aportacion_failure.dart';
import 'package:jccm_espacio_ciudadano/features/casework/aportacion/0_entity/interested_party_identification.dart';
import 'package:jccm_espacio_ciudadano/features/casework/aportacion/1_domain/aportacion_session_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/casework/aportacion/2_presentation/widgets/aportacion_failure_banner.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Step 2 of the aportación wizard — identification of the interested
/// party (STORY-37).
class AportacionIdentificationStep extends ConsumerStatefulWidget {
  const AportacionIdentificationStep({super.key});

  @override
  ConsumerState<AportacionIdentificationStep> createState() =>
      _AportacionIdentificationStepState();
}

class _AportacionIdentificationStepState
    extends ConsumerState<AportacionIdentificationStep> {
  final _controller = TextEditingController();
  InterestedPartyIdType _idType = InterestedPartyIdType.nif;

  @override
  void initState() {
    super.initState();
    final existing =
        ref.read(aportacionSessionProvider).identificacion;
    if (existing != null) {
      _idType = existing.idType;
      _controller.text = existing.idNumber;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _idTypeLabel(
    final AppLocalizations l10n,
    final InterestedPartyIdType type,
  ) {
    switch (type) {
      case InterestedPartyIdType.nif:
        return l10n.caseworkAportacionIdentificationTypeNif;
      case InterestedPartyIdType.nie:
        return l10n.caseworkAportacionIdentificationTypeNie;
      case InterestedPartyIdType.passport:
        return l10n.caseworkAportacionIdentificationTypePassport;
      case InterestedPartyIdType.cif:
        return l10n.caseworkAportacionIdentificationTypeCif;
    }
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final session = ref.watch(aportacionSessionProvider);
    final notifier = ref.read(aportacionSessionProvider.notifier);
    final failure = session.failure;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.space16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            l10n.caseworkAportacionIdentificationHeadline,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: AppDimensions.space8),
          Text(
            l10n.caseworkAportacionIdentificationBody,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppDimensions.space16),
          Text(
            l10n.caseworkAportacionIdentificationTypeLabel,
            style: theme.textTheme.labelLarge,
          ),
          const SizedBox(height: AppDimensions.space8),
          SegmentedButton<InterestedPartyIdType>(
            segments: <ButtonSegment<InterestedPartyIdType>>[
              for (final t in InterestedPartyIdType.values)
                ButtonSegment<InterestedPartyIdType>(
                  value: t,
                  label: Text(_idTypeLabel(l10n, t)),
                ),
            ],
            selected: <InterestedPartyIdType>{_idType},
            onSelectionChanged: (final s) =>
                setState(() => _idType = s.first),
          ),
          const SizedBox(height: AppDimensions.space16),
          TextField(
            controller: _controller,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              labelText:
                  l10n.caseworkAportacionIdentificationNumberLabel,
              hintText:
                  l10n.caseworkAportacionIdentificationNumberHint,
              border: const OutlineInputBorder(),
              errorText: failure ==
                      AportacionFailure.invalidIdentification
                  ? l10n.caseworkAportacionFailureInvalidIdentification
                  : null,
            ),
          ),
          const SizedBox(height: AppDimensions.space12),
          if (failure != null &&
              failure != AportacionFailure.invalidIdentification)
            AportacionFailureBanner(failure: failure),
          const SizedBox(height: AppDimensions.space16),
          FilledButton(
            onPressed: () {
              notifier.setIdentification(
                InterestedPartyIdentification(
                  idType: _idType,
                  idNumber: _controller.text,
                ),
              );
            },
            child: Text(l10n.caseworkAportacionIdentificationNextCta),
          ),
        ],
      ),
    );
  }
}
