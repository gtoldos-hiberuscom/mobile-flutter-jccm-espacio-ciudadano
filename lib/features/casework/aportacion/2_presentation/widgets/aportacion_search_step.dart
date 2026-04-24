import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/features/casework/aportacion/0_entity/aportacion_search_query.dart';
import 'package:jccm_espacio_ciudadano/features/casework/aportacion/1_domain/aportacion_session_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/casework/aportacion/2_presentation/widgets/aportacion_failure_banner.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

enum _SearchMode { byExpediente, byRegistro }

/// Step 3 of the aportación wizard — search by número de expediente or
/// número de registro (STORY-37).
class AportacionSearchStep extends ConsumerStatefulWidget {
  const AportacionSearchStep({super.key});

  @override
  ConsumerState<AportacionSearchStep> createState() =>
      _AportacionSearchStepState();
}

class _AportacionSearchStepState extends ConsumerState<AportacionSearchStep> {
  _SearchMode _mode = _SearchMode.byExpediente;
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final raw = _controller.text.trim();
    final notifier = ref.read(aportacionSessionProvider.notifier);
    final query = _mode == _SearchMode.byExpediente
        ? AportacionSearchQuery.byExpediente(raw)
        : AportacionSearchQuery.byRegistro(raw);
    await notifier.resolveQuery(query);
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final session = ref.watch(aportacionSessionProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.space16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            l10n.caseworkAportacionSearchHeadline,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: AppDimensions.space8),
          Text(
            l10n.caseworkAportacionSearchBody,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppDimensions.space16),
          SegmentedButton<_SearchMode>(
            segments: <ButtonSegment<_SearchMode>>[
              ButtonSegment<_SearchMode>(
                value: _SearchMode.byExpediente,
                label: Text(l10n.caseworkAportacionSearchTabExpediente),
              ),
              ButtonSegment<_SearchMode>(
                value: _SearchMode.byRegistro,
                label: Text(l10n.caseworkAportacionSearchTabRegistro),
              ),
            ],
            selected: <_SearchMode>{_mode},
            onSelectionChanged: (final s) {
              setState(() {
                _mode = s.first;
                _controller.clear();
              });
            },
          ),
          const SizedBox(height: AppDimensions.space16),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: _mode == _SearchMode.byExpediente
                  ? l10n.caseworkAportacionSearchExpedienteLabel
                  : l10n.caseworkAportacionSearchRegistroLabel,
              hintText: _mode == _SearchMode.byExpediente
                  ? l10n.caseworkAportacionSearchExpedienteHint
                  : l10n.caseworkAportacionSearchRegistroHint,
              border: const OutlineInputBorder(),
            ),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: AppDimensions.space12),
          if (session.failure != null)
            AportacionFailureBanner(failure: session.failure!),
          const SizedBox(height: AppDimensions.space16),
          FilledButton.icon(
            onPressed: session.isResolving ? null : _submit,
            icon: session.isResolving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.search),
            label: Text(l10n.caseworkAportacionSearchSubmitCta),
          ),
        ],
      ),
    );
  }
}
