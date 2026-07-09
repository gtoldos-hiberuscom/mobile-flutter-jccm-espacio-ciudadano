import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Formulario de aportación de documentos a un expediente de terceros.
/// Figma node 41906:26110.
class GestionAportacionPage extends StatefulWidget {
  const GestionAportacionPage({super.key});

  @override
  State<GestionAportacionPage> createState() => _GestionAportacionPageState();
}

class _GestionAportacionPageState extends State<GestionAportacionPage> {
  _DocType _selectedDocType = _DocType.dni;
  final _docNumberController = TextEditingController();
  final _numRegistroController = TextEditingController();
  final _codIdentificadorController = TextEditingController();

  @override
  void dispose() {
    _docNumberController.dispose();
    _numRegistroController.dispose();
    _codIdentificadorController.dispose();
    super.dispose();
  }

  void _showInfoSheet(final BuildContext context, final AppLocalizations l10n) {
    // ignore: discarded_futures
    AppBottomSheet.show<void>(
      context: context,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.gestionAportacionInfoHeading,
            style: AppTypography.bodyRegular.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppDimensions.space8),
          Text(
            l10n.gestionAportacionInfoBody,
            style: AppTypography.bodyRegular.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppDimensions.space8),
          AppBulletItem(text: l10n.gestionAportacionInfoBullet1),
          AppBulletItem(text: l10n.gestionAportacionInfoBullet2),
          AppBulletItem(text: l10n.gestionAportacionInfoBullet3),
        ],
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
        padding: const EdgeInsets.fromLTRB(
          AppDimensions.space16,
          AppDimensions.space16,
          AppDimensions.space16,
          AppDimensions.space24,
        ),
        child: AppButton(
          label: l10n.gestionAportacionFindButton,
          onPressed: () {},
          isExpanded: true,
          leadingIcon: AppIcons.check,
        ),
      ),
      appBar: AppNavBar(
        type: AppNavBarType.level2,
        title: l10n.gestionAportacionTitle,
        onBack: () => context.go(Routes.gestion),
        actions: [
          IconButton(
            icon: const Icon(AppIcons.info),
            tooltip: 'Más información',
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
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.space16,
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
                        label: l10n.gestionAportacionTipoIdLabel,
                        controller: _docNumberController,
                        countryLabel: _selectedDocType.label(l10n),
                        hint: l10n.gestionAportacionTipoIdHint,
                        helperText: l10n.gestionAportacionTipoIdHelper,
                        onSelectorTap: () => _showDocTypePicker(context, l10n),
                        inputFormatters: const [],
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: AppDimensions.space16),
                      _SectionLabel(text: l10n.gestionAportacionExpedienteLabel),
                      const SizedBox(height: AppDimensions.space4),
                      Text(
                        l10n.gestionAportacionExpedienteNote,
                        style: AppTypography.smallRegular.copyWith(color: AppColors.textBase),
                      ),
                      const SizedBox(height: AppDimensions.space8),
                      AppInputCase(
                        label: l10n.gestionAportacionNumRegistroLabel,
                        hint: l10n.gestionAportacionNumRegistroHint,
                        controller: _numRegistroController,
                        helperText: l10n.gestionAportacionNumRegistroHelper,
                        prefixIcon: const Icon(AppIcons.docs),
                      ),
                      const SizedBox(height: AppDimensions.space8),
                      AppInputCase(
                        label: l10n.gestionAportacionCodIdentificadorLabel,
                        hint: l10n.gestionAportacionCodIdentificadorHint,
                        controller: _codIdentificadorController,
                        helperText: l10n.gestionAportacionCodIdentificadorHelper,
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
}
