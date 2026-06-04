import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/controllers/consent_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/1_domain/external_link_launcher.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/providers/external_links_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Data-protection information screen from Figma node `41775:12413`.
class PrivacyPage extends ConsumerStatefulWidget {
  const PrivacyPage({super.key});

  @override
  ConsumerState<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends ConsumerState<PrivacyPage> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }
    final position = _scrollController.position;
    if (position.pixels < position.maxScrollExtent - AppDimensions.space64) {
      return;
    }
    final idAgente = ref.read(jwtClaimsProvider)?.idAgente ?? '';
    ref.read(consentProvider(idAgente).notifier).onScrollReachedEnd();
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final idAgente = ref.watch(jwtClaimsProvider)?.idAgente ?? '';
    final consentState = ref.watch(consentProvider(idAgente));
    final consentNotifier = ref.read(consentProvider(idAgente).notifier);
    final canAccept = consentState.status == ConsentStatus.step1Unlocked;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppNavBar(
        type: AppNavBarType.detail,
        title: l10n.legalPrivacyTitle,
        showLeading: false,
        actions: [
          IconButton(
            icon: const AppIcon(
              AppIcons.info,
              color: AppColors.textPrimary,
            ),
            tooltip: l10n.legalPrivacyTitle,
            onPressed: () {
              if (_scrollController.hasClients) {
                _scrollController.jumpTo(0);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: NotificationListener<ScrollUpdateNotification>(
              onNotification: (final notification) {
                if (notification.metrics.pixels >= notification.metrics.maxScrollExtent - AppDimensions.space64) {
                  _onScroll();
                }
                return false;
              },
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.space16,
                  vertical: AppDimensions.space8,
                ),
                child: _ContentColumn(
                  children: [
                    const _SectionTitle('¿Quién es el responsable del tratamiento?'),
                    const _BodyBlock(
                      'La Viceconsejería de Administración Local y Coordinación Administrativa es responsable del tratamiento de datos de los servicios que se prestan directamente desde Espacio Ciudadano y que son los siguientes:',
                    ),
                    const _BulletList(
                      items: [
                        'Sección de perfil usuario',
                        'Visualizaciones de los datos seleccionados de la Administración regional y de la Otras temas de interés',
                        'Recomendaciones realizadas en base a los hechos vitales marcados.',
                        'Descargas de los carnés seleccionados',
                      ],
                    ),
                    const _BodyBlock(
                      'Una vez se seleccione cada una de las opciones proporcionadas por espacio ciudadano, el responsable del tratamiento será cada uno de los órganos y organismos competentes en ese procedimiento u hecho administrativo.',
                    ),
                    const _BodyBlock(
                      'Los datos de contacto de este responsable son los siguientes:',
                    ),
                    const _ContactBlock(
                      children: [
                        TextSpan(
                          text: 'Dirección Postal:\n',
                          style: AppTypography.bodyBold,
                        ),
                        TextSpan(
                          text:
                              'Viceconsejería de Administración Local y Coordinación Administrativa\n'
                              'Avda. de Portugal s/n\n'
                              '45071 Toledo\n'
                              'Dirección de correo electrónico:\n'
                              'vicealyca@jccm.es',
                        ),
                      ],
                    ),
                    const _SectionTitle(
                      '¿Cuál es la denominación y finalidad del tratamiento?',
                    ),
                    const _BodyBlock(
                      'Las finalidades de los tratamientos con los datos personales que se llevan a cabo directamente en el tratamiento de Espacio Ciudadano son las siguientes:',
                    ),
                    const _BulletList(
                      items: [
                        'Gestionar los datos identificativos del ciudadano',
                        'Visualizar los datos seleccionados de la Administración regional y de la Otras temas de interés',
                      ],
                    ),
                    const _SectionTitle(
                      '¿Puedo reclamar ante la Agencia Española de Protección de Datos?',
                    ),
                    _AepdBlock(onTap: () => _openAepd(context)),
                    const _SectionTitle(
                      '¿Qué medidas de seguridad se encuentran implantadas?',
                    ),
                    const _BodyBlock(
                      'Las medidas de seguridad implantadas para garantizar la seguridad de los datos de carácter personal se corresponden con las previstas en el Anexo II (Medidas de seguridad) del Real Decreto 311/2022, de 3 de mayo, por el que se regula el Esquema Nacional de Seguridad.',
                    ),
                    const _SectionTitle(
                      'Decisiones automatizadas incluida la elaboración de perfiles',
                    ),
                    const _BodyBlock(
                      'En el caso de las recomendaciones de trámites en base a los hechos vitales marcados por una persona interesada, existe la elaboración de perfiles.',
                    ),
                    const _SectionTitle(
                      'Datos de contacto con la delegada de protección de datos',
                    ),
                    const _BodyBlock(
                      'Para cualquier cuestión relacionada con la protección de datos se puede dirigir a la delegada de protección de datos de la Administración de la Junta de Comunidades de Castilla-La Mancha, cuyos datos de contacto son los siguientes:',
                    ),
                    const _ContactBlock(
                      children: [
                        TextSpan(
                          text: 'Dirección postal:\n',
                          style: AppTypography.bodyBold,
                        ),
                        TextSpan(
                          text:
                              'Delegada de protección de datos\n'
                              'Oficina del Dato\n'
                              'Vicepresidencia Primera\n'
                              'C/ Río Cabriel, 12 – Edificio CIE III\n'
                              '45071 - Toledo\n\n',
                        ),
                        TextSpan(
                          text: 'Dirección de correo electrónico:\n',
                          style: AppTypography.bodyBold,
                        ),
                        TextSpan(text: 'protecciondatos@jccm.es'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          AppStickyBar(
            type: AppStickyBarType.dicotomy,
            secondaryLabel: l10n.consentRejectButton,
            secondaryHierarchy: AppButtonHierarchy.tertiary,
            secondaryLeadingIcon: AppIcons.cancel,
            onSecondary: () {
              consentNotifier.reject();
              context.go(Routes.landing);
            },
            primaryLabel: l10n.consentFinalAcceptButton,
            primaryLeadingIcon: AppIcons.check,
            onPrimary: canAccept
                ? () {
                    consentNotifier.proceedToStep2();
                    context.go(Routes.consentOnboarding);
                  }
                : null,
          ),
        ],
      ),
    );
  }

  Future<void> _openAepd(final BuildContext context) async {
    final catalog = ref.read(externalLinkCatalogProvider);
    final link = catalog.findById('aepd');
    if (link == null) {
      return;
    }

    final result = await ref.read(externalLinkLauncherProvider).launch(link);
    if (!context.mounted || result is! ExternalLinkLaunchFailure) {
      return;
    }
    AppAlertSnackbar.show(
      context,
      message: AppLocalizations.of(context).externalLinkOpenFailed,
      severity: AppAlertSeverity.error,
    );
  }
}

class _ContentColumn extends StatelessWidget {
  const _ContentColumn({required this.children});

  final List<Widget> children;

  @override
  Widget build(final BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      for (final (index, child) in children.indexed) ...[
        if (index > 0) const SizedBox(height: AppDimensions.space8),
        child,
      ],
    ],
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(final BuildContext context) => Semantics(
    header: true,
    headingLevel: 2,
    child: AppTextBlock(
      text: text,
      variant: AppTextBlockVariant.h2,
      showLeadingIcon: false,
      showTrailingIcon: false,
      color: AppColors.textBase,
    ),
  );
}

class _BodyBlock extends StatelessWidget {
  const _BodyBlock(this.text);

  final String text;

  @override
  Widget build(final BuildContext context) => AppTextBlock(
    text: text,
    showLeadingIcon: false,
    showTrailingIcon: false,
    color: AppColors.textBase,
  );
}

class _ContactBlock extends StatelessWidget {
  const _ContactBlock({required this.children});

  final List<InlineSpan> children;

  @override
  Widget build(final BuildContext context) => Padding(
    padding: const EdgeInsets.all(AppDimensions.space4),
    child: Text.rich(
      TextSpan(
        style: AppTypography.bodyRegular.copyWith(color: AppColors.textBase),
        children: children,
      ),
    ),
  );
}

class _BulletList extends StatelessWidget {
  const _BulletList({required this.items});

  final List<String> items;

  @override
  Widget build(final BuildContext context) => Padding(
    padding: const EdgeInsets.all(AppDimensions.space4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final item in items)
          Semantics(
            label: item,
            child: ExcludeSemantics(
              child: Padding(
                padding: const EdgeInsets.only(left: AppDimensions.space8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ',
                      style: AppTypography.bodyRegular.copyWith(color: AppColors.textBase),
                    ),
                    Expanded(
                      child: Text(
                        item,
                        style: AppTypography.bodyRegular.copyWith(color: AppColors.textBase),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    ),
  );
}

class _AepdBlock extends StatelessWidget {
  const _AepdBlock({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) => Padding(
    padding: const EdgeInsets.all(AppDimensions.space4),
    child: Text.rich(
      TextSpan(
        style: AppTypography.smallRegular.copyWith(color: AppColors.textBase),
        children: [
          const TextSpan(
            text: 'Si dispone de pruebas o indicios que acrediten la vulneración de su derecho a la protección de datos en Espacio Ciudadano, puede presentar una reclamación ante la Agencia Española de Protección de Datos, ',
          ),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: Semantics(
              link: true,
              button: true,
              label: 'https://www.aepd.es/',
              child: InkWell(
                onTap: onTap,
                child: Text(
                  'https://www.aepd.es/ ⇲',
                  style: AppTypography.smallLink.copyWith(
                    color: AppColors.textLinkOnLight,
                  ),
                ),
              ),
            ),
          ),
          const TextSpan(
            text: '. También puede reclamar ante la delegada de protección de datos cuyos datos de contacto están en esta información.',
          ),
        ],
      ),
    ),
  );
}
