import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/app/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/empty_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/error_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/loading_state_widget.dart';
import 'package:jccm_espacio_ciudadano/features/casework/registro/0_entity/registro_detail.dart';
import 'package:jccm_espacio_ciudadano/features/casework/registro/0_entity/registro_kind.dart';
import 'package:jccm_espacio_ciudadano/features/casework/registro/1_domain/registro_detail_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/casework/registro/2_presentation/widgets/registro_breadcrumb.dart';
import 'package:jccm_espacio_ciudadano/features/casework/registro/2_presentation/widgets/registro_fichero_tile.dart';
import 'package:jccm_espacio_ciudadano/features/casework/registro/2_presentation/widgets/registro_metadata_block.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Detail screen for a registro entrada / salida (STORY-36).
///
/// Read-only surface — STORY-36 does not own any aportación zone, so an
/// informational banner reminds the citizen this view is for
/// consultation only.
class RegistroDetailPage extends ConsumerWidget {
  const RegistroDetailPage({
    required this.numreg,
    required this.kind,
    super.key,
  });

  final String numreg;
  final RegistroKind kind;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final asyncDetail = ref.watch(
      registroDetailProvider(numreg, kind),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitle(l10n)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: l10n.caseworkRegistroDetailBackToList,
          onPressed: () => _backToList(context),
        ),
      ),
      body: asyncDetail.when(
        loading: () => LoadingStateWidget(message: l10n.loadingStateDefault),
        error: (final err, final st) => ErrorStateWidget(
          message: l10n.caseworkRegistroDetailLoadError,
          onRetry: () => ref.read(registroDetailProvider(numreg, kind).notifier).refresh(),
        ),
        data: (final detail) => _DetailBody(detail: detail, kind: kind),
      ),
    );
  }

  String _pageTitle(final AppLocalizations l10n) {
    switch (kind) {
      case RegistroKind.entrada:
        return l10n.caseworkRegistroDetailTitleEntrada;
      case RegistroKind.salida:
        return l10n.caseworkRegistroDetailTitleSalida;
    }
  }

  void _backToList(final BuildContext context) {
    final router = GoRouter.of(context);
    if (router.canPop()) {
      router.pop();
    } else {
      router.go(Routes.casework);
    }
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.detail, required this.kind});

  final RegistroDetail detail;
  final RegistroKind kind;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final kindLabel = _kindLabel(l10n, kind);

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space8),
      children: <Widget>[
        RegistroBreadcrumb(
          segments: <RegistroBreadcrumbSegment>[
            RegistroBreadcrumbSegment(
              label: l10n.caseworkRegistroDetailBreadcrumbHome,
            ),
            RegistroBreadcrumbSegment(
              label: l10n.caseworkRegistroDetailBreadcrumbCasework,
            ),
            RegistroBreadcrumbSegment(label: kindLabel),
            RegistroBreadcrumbSegment(label: detail.numero),
          ],
        ),
        RegistroMetadataBlock(detail: detail),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space16,
            vertical: AppDimensions.space8,
          ),
          child: Text(
            l10n.caseworkRegistroDetailFicherosTitle,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (detail.ficheros.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.space16,
              vertical: AppDimensions.space8,
            ),
            child: EmptyStateWidget(
              icon: Icons.attach_file_outlined,
              message: l10n.caseworkRegistroDetailFicherosEmpty,
            ),
          )
        else
          for (var i = 0; i < detail.ficheros.length; i++) ...<Widget>[
            RegistroFicheroTile(fichero: detail.ficheros[i]),
            if (i < detail.ficheros.length - 1) const RegistroFicheroDivider(),
          ],
        Padding(
          padding: const EdgeInsets.all(AppDimensions.space16),
          child: _ReadOnlyBanner(
            message: l10n.caseworkRegistroDetailReadOnlyBanner,
          ),
        ),
      ],
    );
  }

  static String _kindLabel(final AppLocalizations l10n, final RegistroKind k) {
    switch (k) {
      case RegistroKind.entrada:
        return l10n.caseworkRegistroDetailKindEntrada;
      case RegistroKind.salida:
        return l10n.caseworkRegistroDetailKindSalida;
    }
  }
}

class _ReadOnlyBanner extends StatelessWidget {
  const _ReadOnlyBanner({required this.message});
  final String message;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      container: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.space16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(
                Icons.info_outline,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: AppDimensions.space8),
              Expanded(
                child: Text(
                  message,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
