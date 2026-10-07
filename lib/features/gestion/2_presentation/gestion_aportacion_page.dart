import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/logger/logger.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/citizen_endpoint_ids_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/1_domain/usecases/buscar_expediente_tercero_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/providers/gestion_expedientes_provider.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/tercero_identificacion.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Formulario de aportación de documentos a un expediente de terceros.
/// Figma node 41906:26110.
class GestionAportacionPage extends ConsumerStatefulWidget {
  const GestionAportacionPage({super.key});

  @override
  ConsumerState<GestionAportacionPage> createState() => _GestionAportacionPageState();
}

class _GestionAportacionPageState extends ConsumerState<GestionAportacionPage> {
  _DocType _selectedDocType = _DocType.dni;
  _ExpedienteIdentifier _selectedExpedienteIdentifier = _ExpedienteIdentifier.registro;
  final _docNumberController = TextEditingController();
  final _numRegistroController = TextEditingController();
  final _codIdentificadorController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _docNumberController.dispose();
    _numRegistroController.dispose();
    _codIdentificadorController.dispose();
    super.dispose();
  }

  Future<void> _onFindExpediente(final AppLocalizations l10n) async {
    final documentNumber = _docNumberController.text.trim();
    if (documentNumber.isEmpty) {
      AppAlertSnackbar.show(context, message: l10n.gestionAportacionDocNumberRequiredError, severity: AppAlertSeverity.error);
      return;
    }

    final claims = ref.read(jwtClaimsProvider);
    final authenticatedDocuments = <String?>[
      claims?.effectivePersonIdentifier,
      claims?.normalizedPersonIdentifier,
      claims?.preferredUsername,
      claims?.sub,
    ];
    final isOwnDocument = authenticatedDocuments.whereType<String>().any(
      (final candidate) => _normalizedDocument(documentNumber) == _normalizedDocument(candidate),
    );
    if (isOwnDocument) {
      AppAlertSnackbar.show(
        context,
        message: l10n.gestionAportacionOwnExpedienteError,
        severity: AppAlertSeverity.error,
      );
      return;
    }

    final expedienteIdentifier = _selectedExpedienteIdentifier == _ExpedienteIdentifier.registro ? _numRegistroController.text.trim() : _codIdentificadorController.text.trim();
    if (expedienteIdentifier.isEmpty) {
      AppAlertSnackbar.show(context, message: l10n.gestionAportacionCamposExpedienteError, severity: AppAlertSeverity.error);
      return;
    }

    setState(() => _isSearching = true);
    final usecase = ref.read(buscarExpedienteTerceroUsecaseProvider);
    final result = await usecase.execute(
      // El path /ciudadanos/{sid} lleva al ciudadano autenticado; el documento
      // del formulario (posible tercero) viaja en el cuerpo.
      citizenId: ref.read(citizenEndpointIdsProvider).requireIdAgente(),
      documentNumber: documentNumber,
      tipodoc: _selectedDocType.tipodoc,
      numRegistro: _selectedExpedienteIdentifier == _ExpedienteIdentifier.registro ? expedienteIdentifier : null,
      numExpediente: _selectedExpedienteIdentifier == _ExpedienteIdentifier.codigo ? expedienteIdentifier : null,
    );
    if (!mounted) {
      return;
    }
    setState(() => _isSearching = false);

    switch (result) {
      case BuscarExpedienteTerceroSuccess(:final expediente):
        context.go(
          '${Routes.gestionExpedientes}/${Uri.encodeComponent(expediente.numexp)}',
          extra: TerceroIdentificacion(tipodoc: _selectedDocType.tipodoc, documentNumber: documentNumber),
        );
      case BuscarExpedienteTerceroFailed(:final reason, :final cause):
        logger.e('Error al buscar expediente de terceros (${reason.name})', error: cause);
        if (context.mounted) {
          AppAlertSnackbar.show(
            context,
            message: switch (reason) {
              BuscarExpedienteTerceroFailureReason.notFound => l10n.gestionAportacionExpedienteNotFoundError,
              BuscarExpedienteTerceroFailureReason.unauthorized => l10n.gestionAportacionExpedienteUnauthorizedError,
              BuscarExpedienteTerceroFailureReason.unavailable => l10n.gestionAportacionExpedienteUnavailableError,
            },
            severity: AppAlertSeverity.error,
          );
        }
    }
  }

  void _showInfoSheet(final BuildContext context, final AppLocalizations l10n) {
    // ignore: discarded_futures
    AppBottomSheet.show<void>(
      context: context,
      title: l10n.gestionAportacionInfoHeading,
      body: Text(
        l10n.gestionAportacionInfoBody,
        style: AppTypography.bodyRegular.copyWith(color: AppColors.primary),
      ),
    );
  }

  void _showDocTypePicker(final BuildContext context, final AppLocalizations l10n) {
    // ignore: discarded_futures
    AppBottomSheet.show<void>(
      context: context,
      title: l10n.gestionAportacionSeleccionarTipo,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ..._DocType.values.map((final type) {
            return ListTile(
              title: Text(
                type.label(l10n),
                style: AppTypography.bodyRegular.copyWith(color: AppColors.textBase),
              ),
              onTap: () {
                Navigator.of(context).pop();
                setState(() => _selectedDocType = type);
              },
            );
          }),
        ],
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.backgroundWhite,
          border: Border(
            top: BorderSide(color: AppColors.borderNeutralLight),
          ),
          boxShadow: AppShadows.low,
        ),
        padding: appPagePadding(context, top: AppDimensions.space16, bottom: AppDimensions.space24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButton(
              label: l10n.gestionAportarDocumentacionCancelarButton,
              hierarchy: AppButtonHierarchy.tertiary,
              onPressed: () => context.go(Routes.gestion),
              isExpanded: true,
              leadingIcon: AppIcons.close,
            ),
            const SizedBox(height: AppDimensions.space8),
            AppButton(
              label: l10n.gestionAportacionFindButton,
              onPressed: _isSearching ? null : () => _onFindExpediente(l10n),
              isLoading: _isSearching,
              isExpanded: true,
              leadingIcon: AppIcons.check,
            ),
          ],
        ),
      ),
      appBar: AppNavBar(
        type: AppNavBarType.level2,
        title: l10n.gestionAportacionTitle,
        onBack: () => context.go(Routes.gestion),
        actions: [
          IconButton(
            icon: const Icon(AppIcons.info),
            tooltip: l10n.gestionMasInformacionTooltip,
            onPressed: () => _showInfoSheet(context, l10n),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.backgroundBlueLighter,
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: appPageHorizontalPadding(context),
              vertical: AppDimensions.space24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.gestionAportacionIntroText,
                  style: AppTypography.bodyRegular.copyWith(color: AppColors.textBase),
                ),
                const SizedBox(height: AppDimensions.space16),
                AppSurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionLabel(text: l10n.gestionAportacionPersonaLabel),
                      const SizedBox(height: AppDimensions.space8),
                      AppPhoneInputCase(
                        label: l10n.gestionAportacionTipoIdShortLabel,
                        controller: _docNumberController,
                        countryLabel: _selectedDocType.label(l10n),
                        hint: _selectedDocType.hint(l10n),
                        helperText: l10n.gestionAportacionTipoIdHelper,
                        onSelectorTap: () => _showDocTypePicker(context, l10n),
                        inputFormatters: const [],
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: AppDimensions.space16),
                      _SectionLabel(text: l10n.gestionAportacionExpedienteLabel),
                      const SizedBox(height: AppDimensions.space8),
                      _CaseIdentifierSelector(
                        value: _selectedExpedienteIdentifier,
                        onChanged: (final value) => setState(() => _selectedExpedienteIdentifier = value),
                      ),
                      const SizedBox(height: AppDimensions.space8),
                      AppInputCase(
                        label: _selectedExpedienteIdentifier.fieldLabel(l10n),
                        hint: _selectedExpedienteIdentifier.hint(l10n),
                        controller: _selectedExpedienteIdentifier == _ExpedienteIdentifier.registro ? _numRegistroController : _codIdentificadorController,
                        helperText: _selectedExpedienteIdentifier.helper(l10n),
                        prefixIcon: const Icon(AppIcons.docs),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _normalizedDocument(final String value) => value.replaceAll(RegExp('[^A-Za-z0-9]'), '').toUpperCase();

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});

  final String text;

  @override
  Widget build(final BuildContext context) {
    return Text(
      text,
      style: AppTypography.captionUppercase.copyWith(color: AppColors.borderBlueMutedBase),
    );
  }
}

class _CaseIdentifierSelector extends StatelessWidget {
  const _CaseIdentifierSelector({required this.value, required this.onChanged});

  final _ExpedienteIdentifier value;
  final ValueChanged<_ExpedienteIdentifier> onChanged;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.gestionAportacionExpedienteIdentifierTypeLabel,
          style: AppTypography.captionUppercase.copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: AppDimensions.space8),
        DropdownButtonFormField<_ExpedienteIdentifier>(
          key: ValueKey(value),
          initialValue: value,
          isExpanded: true,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: AppDimensions.space8, vertical: AppDimensions.space4),
            filled: true,
            fillColor: AppColors.backgroundWhite,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
              borderSide: const BorderSide(color: AppColors.borderBlueMutedBase),
            ),
          ),
          items: _ExpedienteIdentifier.values.map((final identifier) => DropdownMenuItem(value: identifier, child: Text(identifier.optionLabel(l10n)))).toList(growable: false),
          onChanged: (final selected) {
            if (selected != null) {
              onChanged(selected);
            }
          },
        ),
      ],
    );
  }
}

enum _ExpedienteIdentifier {
  registro,
  codigo;

  String optionLabel(final AppLocalizations l10n) => switch (this) {
    _ExpedienteIdentifier.registro => l10n.gestionAportacionRegistroOption,
    _ExpedienteIdentifier.codigo => l10n.gestionAportacionCodigoOption,
  };

  String fieldLabel(final AppLocalizations l10n) => optionLabel(l10n);

  String hint(final AppLocalizations l10n) => switch (this) {
    _ExpedienteIdentifier.registro => l10n.gestionAportacionNumRegistroHint,
    _ExpedienteIdentifier.codigo => l10n.gestionAportacionCodIdentificadorHint,
  };

  String helper(final AppLocalizations l10n) => switch (this) {
    _ExpedienteIdentifier.registro => l10n.gestionAportacionNumRegistroHelper,
    _ExpedienteIdentifier.codigo => l10n.gestionAportacionCodIdentificadorHelper,
  };
}

enum _DocType {
  dni,
  nie,
  cif,
  pasaporte,
  cee;

  String label(final AppLocalizations l10n) => switch (this) {
    _DocType.dni => l10n.gestionAportacionDni,
    _DocType.nie => l10n.gestionAportacionNie,
    _DocType.cif => l10n.gestionAportacionCif,
    _DocType.pasaporte => l10n.gestionAportacionPasaporte,
    _DocType.cee => l10n.gestionAportacionCee,
  };

  String hint(final AppLocalizations l10n) => switch (this) {
    _DocType.dni => '00000000A',
    _DocType.nie => 'X0000000A',
    _DocType.cif => 'A00000000',
    _DocType.pasaporte => l10n.gestionAportacionPasaporteHint,
    _DocType.cee => l10n.gestionAportacionCeeHint,
  };

  /// Valor enviado al backend en `ptipodoc`/`identificacion.category`. Sin
  /// enum documentado para NIE/CIF/PASAPORTE/CEE en el swagger — se envía
  /// el tipo seleccionado tal cual, a petición explícita.
  String get tipodoc => switch (this) {
    _DocType.dni => 'DNI',
    _DocType.nie => 'NIE',
    _DocType.cif => 'CIF',
    _DocType.pasaporte => 'PASAPORTE',
    _DocType.cee => 'CEE',
  };
}
