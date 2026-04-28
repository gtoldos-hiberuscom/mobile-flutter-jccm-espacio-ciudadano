import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/app/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/features/casework/2_presentation/widgets/casework_breadcrumb.dart';
import 'package:jccm_espacio_ciudadano/features/casework/aportacion/0_entity/aportacion_session.dart';
import 'package:jccm_espacio_ciudadano/features/casework/aportacion/0_entity/aportacion_step.dart';
import 'package:jccm_espacio_ciudadano/features/casework/aportacion/1_domain/aportacion_session_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/casework/aportacion/2_presentation/widgets/aportacion_complete_step.dart';
import 'package:jccm_espacio_ciudadano/features/casework/aportacion/2_presentation/widgets/aportacion_detail_step.dart';
import 'package:jccm_espacio_ciudadano/features/casework/aportacion/2_presentation/widgets/aportacion_identification_step.dart';
import 'package:jccm_espacio_ciudadano/features/casework/aportacion/2_presentation/widgets/aportacion_intro_step.dart';
import 'package:jccm_espacio_ciudadano/features/casework/aportacion/2_presentation/widgets/aportacion_search_step.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Routed page for the third-party aportación wizard (STORY-37).
///
/// Owns the AppBar, the back/exit affordances and the step indicator.
/// Each inner step is a dedicated widget under `widgets/` so this page
/// stays a thin shell.
class AportacionWizardPage extends ConsumerWidget {
  const AportacionWizardPage({super.key});

  String _stepLabel(final AppLocalizations l10n, final AportacionStep step) {
    switch (step) {
      case AportacionStep.intro:
        return l10n.caseworkAportacionStepIntro;
      case AportacionStep.identificacion:
        return l10n.caseworkAportacionStepIdentificacion;
      case AportacionStep.searchExpediente:
        return l10n.caseworkAportacionStepSearch;
      case AportacionStep.detail:
        return l10n.caseworkAportacionStepDetail;
      case AportacionStep.uploadComplete:
        return l10n.caseworkAportacionStepComplete;
    }
  }

  Widget _stepBody(final AportacionSession session) {
    switch (session.currentStep) {
      case AportacionStep.intro:
        return const AportacionIntroStep();
      case AportacionStep.identificacion:
        return const AportacionIdentificationStep();
      case AportacionStep.searchExpediente:
        return const AportacionSearchStep();
      case AportacionStep.detail:
        return AportacionDetailStep(
          expedienteRef: session.expedienteRef ?? '',
        );
      case AportacionStep.uploadComplete:
        return AportacionCompleteStep(
          expedienteRef: session.expedienteRef ?? '',
        );
    }
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final session = ref.watch(aportacionSessionProvider);
    final notifier = ref.read(aportacionSessionProvider.notifier);
    final canGoBack = !session.completed && session.currentStep != AportacionStep.intro;

    return Scaffold(
      appBar: AppBar(
        leading: canGoBack
            ? IconButton(
                tooltip: l10n.caseworkAportacionBack,
                icon: const Icon(Icons.arrow_back),
                onPressed: notifier.back,
              )
            : IconButton(
                tooltip: l10n.caseworkAportacionExit,
                icon: const Icon(Icons.close),
                onPressed: () {
                  notifier.start();
                  if (GoRouter.of(context).canPop()) {
                    GoRouter.of(context).pop();
                  } else {
                    GoRouter.of(context).go(Routes.casework);
                  }
                },
              ),
        title: Text(l10n.caseworkAportacionTitle),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CaseworkBreadcrumb(
            segments: <CaseworkBreadcrumbSegment>[
              CaseworkBreadcrumbSegment(label: l10n.caseworkBreadcrumbHome),
              CaseworkBreadcrumbSegment(
                label: l10n.caseworkAportacionBreadcrumb,
              ),
              CaseworkBreadcrumbSegment(
                label: _stepLabel(l10n, session.currentStep),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.space16,
              vertical: AppDimensions.space8,
            ),
            child: Text(
              l10n.caseworkAportacionStepIndicator(
                session.currentStep.oneBasedIndex,
                AportacionStep.total,
              ),
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ),
          Expanded(child: _stepBody(session)),
        ],
      ),
    );
  }
}
