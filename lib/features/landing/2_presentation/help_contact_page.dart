import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/1_domain/external_link_launcher.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/providers/external_links_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

/// Help and contact screen from Figma node `41911:6750`.
class HelpContactPage extends ConsumerStatefulWidget {
  const HelpContactPage({super.key});

  @override
  ConsumerState<HelpContactPage> createState() => _HelpContactPageState();
}

class _HelpContactPageState extends ConsumerState<HelpContactPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBlueLighter,
      appBar: AppNavBar(
        title: 'Ayuda y contacto',
        leading: IconButton(
          icon: const AppIcon(
            AppIcons.arrowBack,
            size: AppDimensions.iconLarge,
            color: AppColors.textPrimary,
          ),
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(Routes.homeFromDrawer);
            }
          },
        ),
      ),
      body: Column(
        children: [
          ColoredBox(
            color: AppColors.backgroundBlueMutedLight,
            child: AppTabBar(
              controller: _tabController,
              level: AppTabBarLevel.nivel2,
              tabs: const [
                AppTabItem(label: 'Preguntas frecuentes'),
                AppTabItem(label: 'Contacto'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _FaqTab(onOpenGuides: () => _openExternalLink('help_guides')),
                _ContactTab(
                  onCallPhone: _callPhone,
                  onOpenOffices: () => _openExternalLink('jccm_offices_oir'),
                  onOpenSupport: () => _openExternalLink('technical_support'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _callPhone(final String number) async {
    final accepted = await launchUrl(
      Uri(scheme: 'tel', path: number.replaceAll(' ', '')),
      mode: LaunchMode.externalApplication,
    );
    if (!mounted || accepted) {
      return;
    }
    AppAlertSnackbar.show(
      context,
      message: AppLocalizations.of(context).externalLinkOpenFailed,
      severity: AppAlertSeverity.error,
    );
  }

  Future<void> _openExternalLink(final String id) async {
    final link = ref.read(externalLinkCatalogProvider).findById(id);
    if (link == null) {
      return;
    }

    final result = await ref.read(externalLinkLauncherProvider).launch(link);
    if (!mounted || result is! ExternalLinkLaunchFailure) {
      return;
    }

    AppAlertSnackbar.show(
      context,
      message: AppLocalizations.of(context).externalLinkOpenFailed,
      severity: AppAlertSeverity.error,
    );
  }
}

class _FaqTab extends StatelessWidget {
  const _FaqTab({required this.onOpenGuides});

  final VoidCallback onOpenGuides;

  @override
  Widget build(final BuildContext context) => ListView(
    padding: const EdgeInsets.all(AppDimensions.space16),
    children: [
      const _SectionTitle('Preguntas frecuentes'),
      const SizedBox(height: AppDimensions.space16),
      const AppList(
        padding: EdgeInsets.all(AppDimensions.space8),
        variant: AppListVariant.expandable,
        children: [
          AppListExpandableItem(
            title: '¿Qué dispositivos puedo utilizar para acceder a Espacio Ciudadano?',
            initiallyExpanded: true,
            children: [
              Text('Lorem ipsum'),
            ],
          ),
          AppListExpandableItem(
            title: '¿Qué necesito para acceder?',
            children: [
              Text('Necesitas identificarte con Cl@ve, certificado electrónico o el sistema de acceso habilitado.'),
            ],
          ),
          AppListExpandableItem(
            title: '¿Qué datos personales se almacenan en Espacio Ciudadano?',
            children: [
              Text('Se muestran los datos necesarios para prestar los servicios disponibles en la aplicación.'),
            ],
          ),
          AppListExpandableItem(
            title: 'Los datos mostrados contienen algún error, ¿puedo corregirlo?',
            children: [
              Text('Contacta con el órgano responsable del trámite o expediente para solicitar la corrección.'),
            ],
          ),
          AppListExpandableItem(
            title: '¿Qué eventos se muestran en Mi Agenda?',
            children: [
              Text('Se muestran citas, avisos y eventos administrativos relacionados con tus servicios.'),
            ],
          ),
          AppListExpandableItem(
            title: 'Lorem ipsum',
            children: [
              Text('Lorem ipsum'),
            ],
          ),
          AppListExpandableItem(
            title: 'Lorem ipsum',
            children: [
              Text('Lorem ipsum'),
            ],
          ),
          AppListExpandableItem(
            title: 'Lorem ipsum',
            children: [
              Text('Lorem ipsum'),
            ],
          ),
        ],
      ),
      const SizedBox(height: AppDimensions.space24),
      const _SectionTitle('Guías de ayuda'),
      const SizedBox(height: AppDimensions.space16),
      const _InfoRow(
        icon: AppIcons.help,
        text: 'Si necesitas ayuda adicional tienes a tu disposición estas Guías de Ayuda',
      ),
      const SizedBox(height: AppDimensions.space24),
      _NavCard(
        title: 'Guías de ayuda',
        subtitle: 'Ir al portal web JCCM',
        onTap: onOpenGuides,
      ),
    ],
  );
}

class _ContactTab extends StatelessWidget {
  const _ContactTab({
    required this.onCallPhone,
    required this.onOpenOffices,
    required this.onOpenSupport,
  });

  final ValueChanged<String> onCallPhone;
  final VoidCallback onOpenOffices;
  final VoidCallback onOpenSupport;

  @override
  Widget build(final BuildContext context) => ListView(
    padding: const EdgeInsets.all(AppDimensions.space16),
    children: [
      const _SectionTitle('Información de contacto'),
      const SizedBox(height: AppDimensions.space24),
      const _InfoRow(
        icon: AppIcons.drafts,
        text: 'Para consultas generales e información administrativa puedes contactar a través de los teléfonos de atención ciudadana.',
        boldParts: ['consultas generales e información administrativa', 'teléfonos de atención ciudadana'],
      ),
      const SizedBox(height: AppDimensions.space24),
      _PhoneCard(
        number: '012',
        onTap: () => onCallPhone('012'),
      ),
      const SizedBox(height: AppDimensions.space16),
      _PhoneCard(
        number: '952 274 552',
        onTap: () => onCallPhone('952 274 552'),
      ),
      const SizedBox(height: AppDimensions.space24),
      const _InfoRow(
        icon: AppIcons.drafts,
        text: 'Si necesitas conocer más detalles sobre un expediente ponte en contacto con la oficina tramitadora o consejería competente.',
        boldParts: ['conocer más detalles sobre un expediente'],
      ),
      const SizedBox(height: AppDimensions.space24),
      _NavCard(
        title: 'Listado de Oficina de Información y registro',
        subtitle: 'Ir al portal web JCCM',
        onTap: onOpenOffices,
      ),
      const SizedBox(height: AppDimensions.space24),
      const _InfoRow(
        icon: AppIcons.settings,
        text: 'Si necesitas asistencia técnica ponte en contacto con nosotros a través del formulario de Soporte Técnico.',
        boldParts: ['asistencia técnica'],
      ),
      const SizedBox(height: AppDimensions.space24),
      _NavCard(
        title: 'Soporte técnico',
        subtitle: 'Abrir formulario en Espacio web',
        onTap: onOpenSupport,
      ),
    ],
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(final BuildContext context) => Text(
    text,
    style: AppTypography.h2.copyWith(color: AppColors.primary),
  );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.text,
    this.boldParts = const [],
  });

  final IconData icon;
  final String text;
  final List<String> boldParts;

  @override
  Widget build(final BuildContext context) {
    final style = AppTypography.leadingMedium.copyWith(color: AppColors.primary);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppIcon(icon, color: AppColors.secondary, size: AppDimensions.iconLarge),
        const SizedBox(width: AppDimensions.space16),
        Expanded(
          child: Text.rich(
            TextSpan(
              style: style,
              children: _spansWithBoldParts(text, style, boldParts),
            ),
          ),
        ),
      ],
    );
  }

  List<TextSpan> _spansWithBoldParts(
    final String value,
    final TextStyle style,
    final List<String> boldParts,
  ) {
    if (boldParts.isEmpty) {
      return [TextSpan(text: value)];
    }
    final spans = <TextSpan>[];
    var cursor = 0;
    while (cursor < value.length) {
      final next = boldParts
          .map((final part) => (part: part, index: value.indexOf(part, cursor)))
          .where((final match) => match.index >= 0)
          .fold<({String part, int index})?>(
            null,
            (final current, final match) => current == null || match.index < current.index ? match : current,
          );
      if (next == null) {
        spans.add(TextSpan(text: value.substring(cursor)));
        break;
      }
      if (cursor < next.index) {
        spans.add(TextSpan(text: value.substring(cursor, next.index)));
      }
      spans.add(
        TextSpan(
          text: next.part,
          style: style.copyWith(fontWeight: FontWeight.w700),
        ),
      );
      cursor = next.index + next.part.length;
    }
    return spans;
  }
}

class _PhoneCard extends StatelessWidget {
  const _PhoneCard({
    required this.number,
    required this.onTap,
  });

  final String number;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) => Semantics(
    button: true,
    label: 'Llamar al $number',
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          border: Border.all(color: AppColors.borderBlueMutedLight),
          borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
          boxShadow: AppShadows.low,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.space16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      number,
                      style: AppTypography.leadingMedium.copyWith(color: AppColors.primary),
                    ),
                    const SizedBox(height: AppDimensions.space4),
                    Text(
                      'Llamar a Atención a la Ciudadanía',
                      style: AppTypography.bodyRegular.copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
              ),
              const AppIcon(AppIcons.call, color: AppColors.textBase),
            ],
          ),
        ),
      ),
    ),
  );
}

class _NavCard extends StatelessWidget {
  const _NavCard({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        border: Border.all(color: AppColors.borderBlueMutedLight),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
        boxShadow: AppShadows.low,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.leadingMedium.copyWith(color: AppColors.primary),
                  ),
                  const SizedBox(height: AppDimensions.space4),
                  Text(
                    subtitle,
                    style: AppTypography.bodyRegular.copyWith(color: AppColors.primary),
                  ),
                ],
              ),
            ),
            const AppIcon(AppIcons.openInNew, color: AppColors.textBase),
          ],
        ),
      ),
    ),
  );
}
