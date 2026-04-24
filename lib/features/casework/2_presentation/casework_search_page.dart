import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/empty_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/error_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/loading_state_widget.dart';
import 'package:jccm_espacio_ciudadano/features/casework/0_entity/casework_item.dart';
import 'package:jccm_espacio_ciudadano/features/casework/0_entity/casework_search_query.dart';
import 'package:jccm_espacio_ciudadano/features/casework/0_entity/casework_search_result.dart';
import 'package:jccm_espacio_ciudadano/features/casework/1_domain/casework_search_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/casework/2_presentation/widgets/casework_item_tile.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Casework search page (STORY-39).
///
/// Renders three independent inputs (identification, número de expediente,
/// número de registro), validates them through the notifier (validation
/// itself lives in `0_entity/CaseworkSearchQuery`) and surfaces the
/// loading / no-results / error / results states via `core/ui_states/`.
class CaseworkSearchPage extends ConsumerStatefulWidget {
  const CaseworkSearchPage({super.key});

  @override
  ConsumerState<CaseworkSearchPage> createState() => _CaseworkSearchPageState();
}

class _CaseworkSearchPageState extends ConsumerState<CaseworkSearchPage> {
  final TextEditingController _idCtrl = TextEditingController();
  final TextEditingController _expCtrl = TextEditingController();
  final TextEditingController _regCtrl = TextEditingController();

  @override
  void dispose() {
    _idCtrl.dispose();
    _expCtrl.dispose();
    _regCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(caseworkSearchProvider);
    final notifier = ref.read(caseworkSearchProvider.notifier);

    // Sync controllers if the notifier was reset externally.
    if (_idCtrl.text != state.query.identification) {
      _idCtrl.value = TextEditingValue(
        text: state.query.identification,
        selection: TextSelection.collapsed(
          offset: state.query.identification.length,
        ),
      );
    }
    if (_expCtrl.text != state.query.expedienteNumber) {
      _expCtrl.value = TextEditingValue(
        text: state.query.expedienteNumber,
        selection: TextSelection.collapsed(
          offset: state.query.expedienteNumber.length,
        ),
      );
    }
    if (_regCtrl.text != state.query.registroNumber) {
      _regCtrl.value = TextEditingValue(
        text: state.query.registroNumber,
        selection: TextSelection.collapsed(
          offset: state.query.registroNumber.length,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.caseworkSearchTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                l10n.caseworkSearchIntro,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppDimensions.space16),
              _buildField(
                context: context,
                controller: _idCtrl,
                label: l10n.caseworkSearchFieldIdentificationLabel,
                helper: l10n.caseworkSearchFieldIdentificationHelper,
                errorText: state.showValidation
                    ? _fieldError(
                        l10n,
                        state.validation,
                        CaseworkSearchField.identification,
                      )
                    : null,
                onChanged: (final v) => notifier.updateField(
                  CaseworkSearchField.identification,
                  v,
                ),
              ),
              const SizedBox(height: AppDimensions.space12),
              _buildField(
                context: context,
                controller: _expCtrl,
                label: l10n.caseworkSearchFieldExpedienteLabel,
                helper: l10n.caseworkSearchFieldExpedienteHelper,
                errorText: state.showValidation
                    ? _fieldError(
                        l10n,
                        state.validation,
                        CaseworkSearchField.expedienteNumber,
                      )
                    : null,
                onChanged: (final v) => notifier.updateField(
                  CaseworkSearchField.expedienteNumber,
                  v,
                ),
              ),
              const SizedBox(height: AppDimensions.space12),
              _buildField(
                context: context,
                controller: _regCtrl,
                label: l10n.caseworkSearchFieldRegistroLabel,
                helper: l10n.caseworkSearchFieldRegistroHelper,
                errorText: state.showValidation
                    ? _fieldError(
                        l10n,
                        state.validation,
                        CaseworkSearchField.registroNumber,
                      )
                    : null,
                onChanged: (final v) => notifier.updateField(
                  CaseworkSearchField.registroNumber,
                  v,
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => notifier.submit(),
              ),
              if (state.showValidation && state.validation.generalError != null)
                Padding(
                  padding: const EdgeInsets.only(top: AppDimensions.space8),
                  child: Text(
                    l10n.caseworkSearchErrorAtLeastOne,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              const SizedBox(height: AppDimensions.space16),
              AppButton(
                label: l10n.caseworkSearchSubmit,
                onPressed: state.result.status == CaseworkSearchStatus.searching ? null : notifier.submit,
                isLoading: state.result.status == CaseworkSearchStatus.searching,
              ),
              const SizedBox(height: AppDimensions.space24),
              _buildResults(context, state, l10n, notifier),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required final BuildContext context,
    required final TextEditingController controller,
    required final String label,
    required final String helper,
    required final void Function(String) onChanged,
    final String? errorText,
    final TextInputAction textInputAction = TextInputAction.next,
    final void Function(String)? onSubmitted,
  }) => TextField(
    controller: controller,
    onChanged: onChanged,
    onSubmitted: onSubmitted,
    textInputAction: textInputAction,
    decoration: InputDecoration(
      labelText: label,
      helperText: helper,
      errorText: errorText,
      border: const OutlineInputBorder(),
    ),
  );
  Widget _buildResults(
    final BuildContext context,
    final CaseworkSearchState state,
    final AppLocalizations l10n,
    final CaseworkSearchNotifier notifier,
  ) {
    switch (state.result.status) {
      case CaseworkSearchStatus.idle:
        return const SizedBox.shrink();
      case CaseworkSearchStatus.searching:
        return LoadingStateWidget(message: l10n.loadingStateDefault);
      case CaseworkSearchStatus.noResults:
        return EmptyStateWidget(
          message: l10n.caseworkSearchNoResults,
          subtitle: l10n.caseworkSearchNoResultsHint,
          action: AppButton(
            label: l10n.caseworkSearchAnother,
            onPressed: notifier.reset,
          ),
        );
      case CaseworkSearchStatus.error:
        return ErrorStateWidget(
          message: l10n.caseworkSearchError,
          onRetry: notifier.submit,
        );
      case CaseworkSearchStatus.results:
        return _buildResultsList(context, state, l10n, notifier);
    }
  }

  Widget _buildResultsList(
    final BuildContext context,
    final CaseworkSearchState state,
    final AppLocalizations l10n,
    final CaseworkSearchNotifier notifier,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space16,
          vertical: AppDimensions.space8,
        ),
        child: Text(
          l10n.caseworkSearchResultsCount(state.result.items.length),
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
      for (final item in state.result.items)
        CaseworkItemTile(
          item: item,
          onTap: () => _openDetail(context, item),
        ),
      // TODO(STORY-37): wire aportación documental CTA through the
      // search result once STORY-37 / STORY-38 land.
      Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: AppButton(
          label: l10n.caseworkSearchAportar,
          variant: AppButtonVariant.outlined,
          onPressed: () => _showAportarPlaceholder(context, l10n),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space16,
          vertical: AppDimensions.space8,
        ),
        child: AppButton(
          label: l10n.caseworkSearchAnother,
          variant: AppButtonVariant.text,
          onPressed: notifier.reset,
        ),
      ),
    ],
  );

  void _openDetail(final BuildContext context, final CaseworkItem item) {
    GoRouter.of(context).go('/casework/item/${item.id}');
  }

  void _showAportarPlaceholder(
    final BuildContext context,
    final AppLocalizations l10n,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.caseworkSearchAportarPending)),
    );
  }

  static String? _fieldError(
    final AppLocalizations l10n,
    final CaseworkSearchValidation validation,
    final CaseworkSearchField field,
  ) {
    final err = validation.errors[field];
    if (err == null) {
      return null;
    }
    switch (err) {
      case CaseworkSearchValidationError.invalidIdentification:
        return l10n.caseworkSearchErrorInvalidIdentification;
      case CaseworkSearchValidationError.invalidNumberFormat:
        return l10n.caseworkSearchErrorInvalidNumber;
      case CaseworkSearchValidationError.noInputProvided:
        return null;
    }
  }
}
