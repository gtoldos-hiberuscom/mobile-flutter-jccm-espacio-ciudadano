import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';

/// Interactive design-system catalog.
///
/// Shows every token category and component with live previews.
/// Intended as a developer/designer reference, not a production screen.
class DesignSystemCatalogPage extends StatefulWidget {
  const DesignSystemCatalogPage({super.key});

  @override
  State<DesignSystemCatalogPage> createState() => _DesignSystemCatalogPageState();
}

class _DesignSystemCatalogPageState extends State<DesignSystemCatalogPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _emailController = TextEditingController();
  bool _checkValue = false;
  bool _checkError = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _sections.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  static const _sections = [
    'Colores',
    'Tipografía',
    'Espaciado',
    'Sombras',
    'Iconos',
    'Botones',
    'Tags',
    'Inputs',
    'Alertas',
    'Navegación',
    'Listas & Cards',
    'Bottom Sheet',
    'Calendario',
    'Drawer Menu',
  ];

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        title: const Text('Design System Catalog'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: AppColors.textOnPrimary,
          labelColor: AppColors.textOnPrimary,
          unselectedLabelColor: AppColors.textOnPrimary.withValues(alpha: 0.65),
          tabAlignment: TabAlignment.start,
          tabs: _sections.map((final s) => Tab(text: s)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ColorsSection(),
          _TypographySection(),
          _SpacingSection(),
          _ShadowsSection(),
          const _IconsSection(),
          _ButtonsSection(),
          _TagsSection(),
          _InputsSection(controller: _emailController),
          _AlertsSection(),
          _NavigationSection(),
          _ListsCardsSection(
            checkValue: _checkValue,
            checkError: _checkError,
            onCheckChanged: (final v) => setState(() => _checkValue = v ?? false),
            onCheckError: () => setState(() => _checkError = !_checkError),
          ),
          _BottomSheetSection(),
          _CalendarSection(),
          _DrawerMenuSection(),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);
  final String title;

  @override
  Widget build(final BuildContext context) => Padding(
    padding: const EdgeInsets.only(
      top: AppDimensions.space24,
      bottom: AppDimensions.space8,
    ),
    child: Text(title, style: AppTypography.h3),
  );
}

class _CatalogSection extends StatelessWidget {
  const _CatalogSection({required this.children});
  final List<Widget> children;

  @override
  Widget build(final BuildContext context) => ListView(
    padding: const EdgeInsets.all(AppDimensions.space16),
    children: children,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// 1. Colors
// ─────────────────────────────────────────────────────────────────────────────

class _ColorsSection extends StatelessWidget {
  @override
  Widget build(final BuildContext context) => const _CatalogSection(
    children: [
      // ── Primitivas ────────────────────────────────────────────────────────
      _SectionTitle('Primitivas — Blue'),
      _Palette(
        colors: [
          ('blue100', AppColors.blue100),
          ('blue200', AppColors.blue200),
          ('blue300', AppColors.blue300),
          ('blue400', AppColors.blue400),
          ('blue500', AppColors.blue500),
          ('blue600', AppColors.blue600),
          ('blue700', AppColors.blue700),
          ('blue800', AppColors.blue800),
          ('blue900', AppColors.blue900),
        ],
      ),
      _SectionTitle('Primitivas — Neutral'),
      _Palette(
        colors: [
          ('neutral000', AppColors.neutral000),
          ('neutral100', AppColors.neutral100),
          ('neutral200', AppColors.neutral200),
          ('neutral300', AppColors.neutral300),
          ('neutral400', AppColors.neutral400),
          ('neutral500', AppColors.neutral500),
          ('neutral600', AppColors.neutral600),
          ('neutral700', AppColors.neutral700),
          ('neutral800', AppColors.neutral800),
          ('neutral900', AppColors.neutral900),
          ('neutral1000', AppColors.neutral1000),
        ],
      ),
      _SectionTitle('Primitivas — Green'),
      _Palette(
        colors: [
          ('green100', AppColors.green100),
          ('green500', AppColors.green500),
          ('green900', AppColors.green900),
        ],
      ),
      _SectionTitle('Primitivas — Yellow'),
      _Palette(
        colors: [
          ('yellow100', AppColors.yellow100),
          ('yellow500', AppColors.yellow500),
          ('yellow900', AppColors.yellow900),
        ],
      ),
      _SectionTitle('Primitivas — Red'),
      _Palette(
        colors: [
          ('red100', AppColors.red100),
          ('red500', AppColors.red500),
          ('red900', AppColors.red900),
        ],
      ),
      _SectionTitle('Primitivas — Blue Muted'),
      _Palette(
        colors: [
          ('blueMuted100', AppColors.blueMuted100),
          ('blueMuted500', AppColors.blueMuted500),
          ('blueMuted700', AppColors.blueMuted700),
          ('blueMuted900', AppColors.blueMuted900),
        ],
      ),
      // ── Semánticas ────────────────────────────────────────────────────────
      _SectionTitle('Semánticas — Primary'),
      _Palette(
        colors: [
          ('primaryLight', AppColors.primaryLight),
          ('primary', AppColors.primary),
          ('primaryDark', AppColors.primaryDark),
        ],
      ),
      _SectionTitle('Semánticas — Secondary'),
      _Palette(
        colors: [
          ('secLight100', AppColors.secondaryLight100),
          ('secLight200', AppColors.secondaryLight200),
          ('secLight300', AppColors.secondaryLight300),
          ('secLight400', AppColors.secondaryLight400),
          ('secondary', AppColors.secondary),
          ('secDark', AppColors.secondaryDark),
        ],
      ),
      _SectionTitle('Semánticas — Status'),
      _Palette(
        colors: [
          ('errorLight', AppColors.errorLight),
          ('error', AppColors.error),
          ('errorDark', AppColors.errorDark),
          ('warnLight', AppColors.warningLight),
          ('warning', AppColors.warning),
          ('warnDark', AppColors.warningDark),
          ('succLight', AppColors.successLight),
          ('success', AppColors.success),
          ('succDark', AppColors.successDark),
        ],
      ),
      _SectionTitle('Semánticas — Background'),
      _Palette(
        colors: [
          ('background', AppColors.background),
          ('bgLightBlue', AppColors.backgroundLightBlue),
          ('bgSuccess', AppColors.backgroundSuccess),
          ('bgWarning', AppColors.backgroundWarning),
          ('bgError', AppColors.backgroundError),
          ('bgWhite', AppColors.backgroundWhite),
          ('bgDkPrimary', AppColors.backgroundDarkPrimary),
          ('bgDkSecond.', AppColors.backgroundDarkSecondary),
        ],
      ),
      _SectionTitle('Semánticas — Border'),
      _Palette(
        colors: [
          ('borderDkPrim.', AppColors.borderDarkPrimary),
          ('borderError', AppColors.borderError),
          ('borderWarn', AppColors.borderWarning),
          ('borderSucc.', AppColors.borderSuccess),
        ],
      ),
      _SectionTitle('Semánticas — Text'),
      _Palette(
        colors: [
          ('textPrimary', AppColors.textPrimary),
          ('textBlack', AppColors.textBlack),
          ('textWhite', AppColors.textWhite),
          ('textLinkLight', AppColors.textLinkOnLight),
          ('textLinkDark', AppColors.textLinkOnDark),
          ('textSecondary', AppColors.textSecondary),
          ('textDisabled', AppColors.textDisabled),
        ],
      ),
    ],
  );
}

class _Palette extends StatelessWidget {
  const _Palette({required this.colors});
  final List<(String, Color)> colors;

  @override
  Widget build(final BuildContext context) => Wrap(
    spacing: AppDimensions.space8,
    runSpacing: AppDimensions.space8,
    children: colors
        .map(
          (final c) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 44,
                decoration: BoxDecoration(
                  color: c.$2,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                  border: Border.all(color: AppColors.outlineVariant),
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 60,
                child: Text(
                  c.$1,
                  style: AppTypography.smallRegular,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        )
        .toList(),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// 2. Typography
// ─────────────────────────────────────────────────────────────────────────────

class _TypographySection extends StatelessWidget {
  @override
  Widget build(final BuildContext context) => _CatalogSection(
    children: [
      // ── Headings ──────────────────────────────────────────────────────────
      const _SectionTitle('Headings'),
      ...[
        ('H1  · Inter 600 · 28/36', AppTypography.h1),
        ('H2  · Inter 600 · 24/32', AppTypography.h2),
        ('H3  · Inter 600 · 20/28', AppTypography.h3),
      ].map((final t) => _TypeRow(label: t.$1, style: t.$2)),

      // ── Leading (Body/Large, 18 px) ───────────────────────────────────────
      const _SectionTitle('Leading — 18 px'),
      ...[
        ('Leading/Medium · w500', AppTypography.leadingMedium),
        ('Leading/Bold · w700', AppTypography.leadingBold),
        ('Leading/Link · w500 + u̲', AppTypography.leadingLink),
      ].map((final t) => _TypeRow(label: t.$1, style: t.$2)),

      // ── Body (Body/Base, 16 px) ───────────────────────────────────────────
      const _SectionTitle('Body — 16 px'),
      ...[
        ('Body/Regular · w400', AppTypography.bodyRegular),
        ('Body/Bold · w700', AppTypography.bodyBold),
        ('Body/Link · w400 + u̲', AppTypography.bodyLink),
      ].map((final t) => _TypeRow(label: t.$1, style: t.$2)),

      // ── Small (Body/Small, 14 px) ─────────────────────────────────────────
      const _SectionTitle('Small — 14 px'),
      ...[
        ('Small/Regular · w400', AppTypography.smallRegular),
        ('Small/Bold · w700', AppTypography.smallBold),
        ('Small/Link · w400 + u̲', AppTypography.smallLink),
      ].map((final t) => _TypeRow(label: t.$1, style: t.$2)),

      // ── Caption (12 px) ───────────────────────────────────────────────────
      const _SectionTitle('Caption — 12 px'),
      ...[
        ('Caption/Regular · w700', AppTypography.captionRegular),
        ('Caption/Uppercase · w700 · UPPER', AppTypography.captionUppercase),
      ].map(
        (final t) => _TypeRow(
          label: t.$1,
          style: t.$2,
          textTransform: t.$1.contains('UPPER'),
        ),
      ),
    ],
  );
}

class _TypeRow extends StatelessWidget {
  const _TypeRow({
    required this.label,
    required this.style,
    this.textTransform = false,
  });

  final String label;
  final TextStyle style;
  final bool textTransform;

  @override
  Widget build(final BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppDimensions.space8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        SizedBox(
          width: 200,
          child: Text(
            label,
            style: AppTypography.captionRegular.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            textTransform ? 'TEXTO DE EJEMPLO' : 'Texto de ejemplo',
            style: style,
          ),
        ),
      ],
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// 3. Spacing
// ─────────────────────────────────────────────────────────────────────────────

class _SpacingSection extends StatelessWidget {
  @override
  Widget build(final BuildContext context) => _CatalogSection(
    children: [
      const _SectionTitle('Escala de espaciado (4pt grid)'),
      ...[
        ('space4', AppDimensions.space4),
        ('space8', AppDimensions.space8),
        ('space12', AppDimensions.space12),
        ('space16', AppDimensions.space16),
        ('space20', AppDimensions.space20),
        ('space24', AppDimensions.space24),
        ('space32', AppDimensions.space32),
        ('space40', AppDimensions.space40),
        ('space48', AppDimensions.space48),
        ('space64', AppDimensions.space64),
      ].map(
        (final s) => Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.space8),
          child: Row(
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  s.$1,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              Container(
                width: s.$2,
                height: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text('${s.$2.toInt()} dp', style: AppTypography.caption),
            ],
          ),
        ),
      ),
      const _SectionTitle('Border radius'),
      Wrap(
        spacing: AppDimensions.space8,
        runSpacing: AppDimensions.space8,
        children:
            [
                  ('xs (4)', AppDimensions.radiusSmall),
                  ('md (8)', AppDimensions.radiusMedium),
                  ('lg (12)', AppDimensions.radiusLarge),
                  ('xl (16)', AppDimensions.radiusXLarge),
                  ('999', AppDimensions.radiusRound),
                ]
                .map(
                  (final r) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(r.$2),
                          border: Border.all(color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(r.$1, style: AppTypography.smallRegular),
                    ],
                  ),
                )
                .toList(),
      ),
    ],
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// 4. Shadows
// ─────────────────────────────────────────────────────────────────────────────

class _ShadowsSection extends StatelessWidget {
  @override
  Widget build(final BuildContext context) => const _CatalogSection(
    children: [
      _SectionTitle('Sombras'),
      _ShadowRow(
        label: 'Shadow / Low',
        description: 'Botones e inputs en reposo',
        shadows: AppShadows.low,
        borderRadius: AppDimensions.radiusSmall,
      ),
      _ShadowRow(
        label: 'Shadow / Medium',
        description: 'Cards interactivas y menús',
        shadows: AppShadows.medium,
        borderRadius: AppDimensions.radiusMedium,
      ),
      _ShadowRow(
        label: 'Shadow / High',
        description: 'FABs, popovers y diálogos',
        shadows: AppShadows.high,
        borderRadius: AppDimensions.radiusLarge,
      ),
      _ShadowRow(
        label: 'Shadow / OverAll',
        description: 'Modales, Alerts y elementos críticos',
        shadows: AppShadows.overAll,
        borderRadius: AppDimensions.radiusLarge,
      ),
    ],
  );
}

class _ShadowRow extends StatelessWidget {
  const _ShadowRow({
    required this.label,
    required this.description,
    required this.shadows,
    required this.borderRadius,
  });

  final String label;
  final String description;
  final List<BoxShadow> shadows;
  final double borderRadius;

  @override
  Widget build(final BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppDimensions.space12),
    child: Row(
      children: [
        // Preview box
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: shadows,
            border: Border.all(color: AppColors.borderNeutralLight),
          ),
        ),
        const SizedBox(width: AppDimensions.space16),
        // Labels
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTypography.smallBold),
              const SizedBox(height: AppDimensions.space4),
              Text(description, style: AppTypography.smallRegular.copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: AppDimensions.space4),
              // Pill showing blur / offset
              Text(
                'blur ${shadows.first.blurRadius.toInt()} · offset (${shadows.first.offset.dx.toInt()}, ${shadows.first.offset.dy.toInt()})',
                style: AppTypography.captionRegular.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// 5. Icons
// ─────────────────────────────────────────────────────────────────────────────

class _IconsSection extends StatelessWidget {
  const _IconsSection();

  static const _icons = <(String, IconData)>[
    // Navigation & direction
    ('add', AppIcons.add),
    ('remove', AppIcons.remove),
    ('close', AppIcons.close),
    ('check', AppIcons.check),
    ('more_horiz', AppIcons.more),
    ('dehaze', AppIcons.dehaze),
    ('arrow_back', AppIcons.arrowBack),
    ('arrow_forward', AppIcons.arrowForward),
    ('arrow_upward', AppIcons.arrowUpward),
    ('arrow_downward', AppIcons.arrowDownward),
    ('chevron_left', AppIcons.chevronLeft),
    ('chevron_right', AppIcons.chevronRight),
    ('keyboard_arrow_up', AppIcons.keyboardArrowUp),
    ('keyboard_arrow_down', AppIcons.keyboardArrowDown),
    // Actions
    ('edit', AppIcons.edit),
    ('delete', AppIcons.delete),
    ('share', AppIcons.share),
    ('search', AppIcons.search),
    ('settings', AppIcons.settings),
    ('link', AppIcons.link),
    ('open_in_new', AppIcons.openInNew),
    ('attachment', AppIcons.attachment),
    ('upload', AppIcons.upload),
    ('download', AppIcons.download),
    ('download_done', AppIcons.downloadDone),
    ('autorenew', AppIcons.autorenew),
    ('call_made', AppIcons.callMade),
    ('backspace', AppIcons.backspace),
    ('visibility', AppIcons.visibility),
    // Communication
    ('mail', AppIcons.mail),
    ('drafts', AppIcons.drafts),
    ('alternate_email', AppIcons.alternateEmail),
    ('call', AppIcons.call),
    ('notifications', AppIcons.notifications),
    ('notifications_active', AppIcons.notificationsActive),
    ('notifications_off', AppIcons.notificationsOff),
    // Files & documents
    ('docs', AppIcons.docs),
    ('draft', AppIcons.draft),
    ('license', AppIcons.license),
    // Status & feedback
    ('info', AppIcons.info),
    ('help', AppIcons.help),
    ('warning', AppIcons.warning),
    ('check_circle', AppIcons.checkCircle),
    ('cancel', AppIcons.cancel),
    ('verified', AppIcons.verified),
    ('hourglass', AppIcons.hourglass),
    ('graph', AppIcons.graph),
    // Identity & people
    ('person', AppIcons.person),
    ('fingerprint', AppIcons.fingerprint),
    ('login', AppIcons.login),
    ('logout', AppIcons.logout),
    // Places & organisations
    ('account_balance', AppIcons.accountBalance),
    ('corporate_fare', AppIcons.corporateFare),
    ('globe_location_pin', AppIcons.globeLocationPin),
    // Misc
    ('apps', AppIcons.apps),
    ('calendar_today', AppIcons.calendarToday),
    ('schedule', AppIcons.schedule),
    ('lock', AppIcons.lock),
  ];

  @override
  Widget build(final BuildContext context) => _CatalogSection(
    children: [
      const _SectionTitle('Iconos · 24 dp'),
      Padding(
        padding: const EdgeInsets.only(top: AppDimensions.space8),
        child: Wrap(
          spacing: AppDimensions.space8,
          runSpacing: AppDimensions.space8,
          children: _icons
              .map(
                (final e) => SizedBox(
                  width: 88,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(e.$2, size: AppDimensions.iconMedium, color: AppColors.textPrimary),
                      const SizedBox(height: AppDimensions.space4),
                      Text(
                        e.$1,
                        style: AppTypography.captionRegular.copyWith(color: AppColors.textSecondary),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    ],
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// 6. Buttons
// ─────────────────────────────────────────────────────────────────────────────

class _ButtonsSection extends StatelessWidget {
  @override
  Widget build(final BuildContext context) => _CatalogSection(
    children: [
      // ── Hierarchies ──
      const _SectionTitle('Jerarquías (Medium)'),
      ...AppButtonHierarchy.values.map(
        (final h) => Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.space12),
          child: Row(
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  h.name,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              AppButton(
                label: h.name,
                onPressed: () {},
                hierarchy: h,
              ),
            ],
          ),
        ),
      ),

      // ── Sizes ──
      const _SectionTitle('Tamaños'),
      Row(
        children: [
          AppButton(
            label: 'Medium',
            onPressed: () {},
          ),
          const SizedBox(width: AppDimensions.space12),
          AppButton(
            label: 'Small',
            onPressed: () {},
            size: AppButtonSize.small,
          ),
        ],
      ),

      // ── Leading icon ──
      const _SectionTitle('Con leading icon'),
      AppButton(
        label: 'Fingerprint',
        onPressed: () {},
        leadingIcon: Icons.fingerprint_rounded,
      ),
      const SizedBox(height: AppDimensions.space8),
      AppButton(
        label: 'Legacy icon widget',
        onPressed: () {},
        icon: const Icon(Icons.fingerprint_rounded, size: 18),
      ),

      // ── Trailing icon ──
      const _SectionTitle('Con trailing icon'),
      AppButton(
        label: 'Siguiente',
        onPressed: () {},
        trailingIcon: Icons.arrow_forward_rounded,
      ),

      // ── Leading + Trailing ──
      const _SectionTitle('Leading + Trailing'),
      AppButton(
        label: 'Descargar',
        onPressed: () {},
        leadingIcon: Icons.download_rounded,
        trailingIcon: Icons.open_in_new_rounded,
      ),

      // ── Full width ──
      const _SectionTitle('Full width (isExpanded)'),
      AppButton(
        label: 'Continuar',
        onPressed: () {},
        isExpanded: true,
        trailingIcon: Icons.arrow_forward_rounded,
      ),
      const SizedBox(height: AppDimensions.space8),
      AppButton(
        label: 'Secondary expanded',
        onPressed: () {},
        hierarchy: AppButtonHierarchy.secondary,
        isExpanded: true,
      ),

      // ── Intent: Destructive ──
      const _SectionTitle('Intent: Destructive'),
      Wrap(
        spacing: AppDimensions.space8,
        runSpacing: AppDimensions.space8,
        children: [
          AppButton(
            label: 'Eliminar',
            onPressed: () {},
            intent: AppButtonIntent.destructive,
          ),
          AppButton(
            label: 'Eliminar',
            onPressed: () {},
            hierarchy: AppButtonHierarchy.secondary,
            intent: AppButtonIntent.destructive,
          ),
          AppButton(
            label: 'Eliminar',
            onPressed: () {},
            hierarchy: AppButtonHierarchy.ghost,
            intent: AppButtonIntent.destructive,
          ),
        ],
      ),

      // ── Intent: Success ──
      const _SectionTitle('Intent: Success'),
      Wrap(
        spacing: AppDimensions.space8,
        runSpacing: AppDimensions.space8,
        children: [
          AppButton(
            label: 'Confirmar',
            onPressed: () {},
            intent: AppButtonIntent.success,
          ),
          AppButton(
            label: 'Confirmar',
            onPressed: () {},
            hierarchy: AppButtonHierarchy.secondary,
            intent: AppButtonIntent.success,
          ),
        ],
      ),

      // ── Loading ──
      const _SectionTitle('Loading'),
      Wrap(
        spacing: AppDimensions.space8,
        runSpacing: AppDimensions.space8,
        children: [
          AppButton(label: 'Primary', onPressed: () {}, isLoading: true),
          AppButton(
            label: 'Secondary',
            onPressed: () {},
            hierarchy: AppButtonHierarchy.secondary,
            isLoading: true,
          ),
          AppButton(
            label: 'Ghost',
            onPressed: () {},
            hierarchy: AppButtonHierarchy.ghost,
            isLoading: true,
          ),
        ],
      ),

      // ── Disabled ──
      const _SectionTitle('Disabled (onPressed: null)'),
      const Wrap(
        spacing: AppDimensions.space8,
        runSpacing: AppDimensions.space8,
        children: [
          AppButton(label: 'Primary', onPressed: null),
          AppButton(
            label: 'Secondary',
            onPressed: null,
            hierarchy: AppButtonHierarchy.secondary,
          ),
          AppButton(
            label: 'Ghost',
            onPressed: null,
            hierarchy: AppButtonHierarchy.ghost,
          ),
          AppButton(
            label: 'Tertiary',
            onPressed: null,
            hierarchy: AppButtonHierarchy.tertiary,
          ),
        ],
      ),

      // ── Icon-only buttons ──
      const _SectionTitle('Icon-only (AppIconButton)'),
      Wrap(
        spacing: AppDimensions.space8,
        runSpacing: AppDimensions.space8,
        children: [
          AppIconButton(
            icon: Icons.add,
            onPressed: () {},
            semanticsLabel: 'Añadir',
          ),
          AppIconButton(
            icon: Icons.edit,
            onPressed: () {},
            hierarchy: AppButtonHierarchy.secondary,
            semanticsLabel: 'Editar',
          ),
          AppIconButton(
            icon: Icons.close,
            onPressed: () {},
            hierarchy: AppButtonHierarchy.ghost,
            semanticsLabel: 'Cerrar',
          ),
          AppIconButton(
            icon: Icons.delete,
            onPressed: () {},
            intent: AppButtonIntent.destructive,
            semanticsLabel: 'Eliminar',
          ),
          AppIconButton(
            icon: Icons.check,
            onPressed: () {},
            intent: AppButtonIntent.success,
            semanticsLabel: 'Confirmar',
          ),
          const AppIconButton(
            icon: Icons.more_vert,
            onPressed: null,
            semanticsLabel: 'Deshabilitado',
          ),
        ],
      ),
      const SizedBox(height: AppDimensions.space8),
      const Text('Small icon buttons:'),
      const SizedBox(height: AppDimensions.space4),
      Wrap(
        spacing: AppDimensions.space8,
        children: [
          AppIconButton(
            icon: Icons.add,
            onPressed: () {},
            size: AppButtonSize.small,
            semanticsLabel: 'Añadir pequeño',
          ),
          AppIconButton(
            icon: Icons.close,
            onPressed: () {},
            hierarchy: AppButtonHierarchy.ghost,
            size: AppButtonSize.small,
            semanticsLabel: 'Cerrar pequeño',
          ),
        ],
      ),

      // ── Icon-only loading ──
      const _SectionTitle('Icon-only loading'),
      AppIconButton(
        icon: Icons.refresh,
        onPressed: () {},
        isLoading: true,
        semanticsLabel: 'Refrescando',
      ),
    ],
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// 5. Tags
// ─────────────────────────────────────────────────────────────────────────────

class _TagsSection extends StatelessWidget {
  @override
  Widget build(final BuildContext context) => _CatalogSection(
    children: [
      const _SectionTitle('Estados'),
      Wrap(
        spacing: AppDimensions.space8,
        runSpacing: AppDimensions.space8,
        children: AppTagStatus.values.map((final s) => AppTag(status: s, label: s.name)).toList(),
      ),
    ],
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// 6. Inputs
// ─────────────────────────────────────────────────────────────────────────────

class _InputsSection extends StatelessWidget {
  const _InputsSection({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(final BuildContext context) => _CatalogSection(
    children: [
      const _SectionTitle('InputCase — estados'),
      ...AppInputState.values.map(
        (final s) => Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.space16),
          child: AppInputCase(
            label: s.name,
            hint: 'Ejemplo de ${s.name}',
            state: s,
            enabled: s != AppInputState.disabled,
            errorText: s == AppInputState.error ? 'Valor no válido' : null,
          ),
        ),
      ),
      const _SectionTitle('Label'),
      const AppLabel(text: 'Campo obligatorio', required: true),
      const SizedBox(height: AppDimensions.space8),
      const AppLabel(text: 'Campo opcional', size: AppLabelSize.s),
    ],
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// 7. Alerts
// ─────────────────────────────────────────────────────────────────────────────

class _AlertsSection extends StatefulWidget {
  @override
  State<_AlertsSection> createState() => _AlertsSectionState();
}

class _AlertsSectionState extends State<_AlertsSection> {
  bool _dialogChecked = false;

  @override
  Widget build(final BuildContext context) => _CatalogSection(
    children: [
      // ── Banner ──
      const _SectionTitle('AlertBanner'),
      ...AppAlertSeverity.values
          .where((final s) => s != AppAlertSeverity.success)
          .map(
            (final s) => Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.space12),
              child: AppAlertBanner(
                severity: s,
                message: s == AppAlertSeverity.warning
                    ? 'Comprueba tu conexión a internet antes de continuar.'
                    : s == AppAlertSeverity.error
                    ? 'No hemos podido verificar tu identidad.'
                    : 'El día 23 de abril se realizarán tareas de mantenimiento.',
                onDismiss: () {},
              ),
            ),
          ),

      // ── Contextual helper ──
      const _SectionTitle('AlertContextual — vertical / horizontal'),
      const AppAlertContextual(
        message: 'Introduce tu NIF sin guiones ni espacios.',
        size: AppAlertContextualSize.small,
      ),
      const AppAlertContextual(
        message: 'Aviso del sistema',
        horizontal: true,
      ),

      // ── Toast ──
      const _SectionTitle('Toast (imperativo)'),
      Wrap(
        spacing: AppDimensions.space8,
        children: AppAlertSeverity.values
            .where((final s) => s != AppAlertSeverity.warning)
            .map(
              (final s) => ElevatedButton(
                onPressed: () => AppAlertToast.show(
                  context,
                  message: 'Toast ${s.name}',
                  severity: s,
                ),
                child: Text(s.name),
              ),
            )
            .toList(),
      ),

      // ── Snackbar ──
      const _SectionTitle('Snackbar (imperativo)'),
      Wrap(
        spacing: AppDimensions.space8,
        children: [
          ElevatedButton(
            onPressed: () => AppAlertSnackbar.show(
              context,
              message: 'Cambios guardados',
              actionLabel: 'Deshacer',
            ),
            child: const Text('Neutral'),
          ),
          ElevatedButton(
            onPressed: () => AppAlertSnackbar.show(
              context,
              message: 'Descarga completada',
              severity: AppAlertSeverity.success,
              actionLabel: 'Abrir',
            ),
            child: const Text('Success'),
          ),
          ElevatedButton(
            onPressed: () => AppAlertSnackbar.show(
              context,
              message: 'El archivo no se ha descargado',
              severity: AppAlertSeverity.error,
              actionLabel: 'Reintentar',
            ),
            child: const Text('Error'),
          ),
        ],
      ),

      // ── Dialog ──
      const _SectionTitle('AlertDialog'),
      ElevatedButton(
        onPressed: () async {
          await AppAlertDialog.show(
            context,
            title: 'Cerrar sesión',
            description: 'Vas a cerrar la sesión en este dispositivo. Lorem ipsum dolor sit amet.',
            infoLabel: 'Más información',
            checkboxLabel: 'Lorem ipsum',
            isChecked: _dialogChecked,
            onCheckboxChanged: (final v) => setState(() => _dialogChecked = v),
            confirmLabel: 'Aceptar',
            cancelLabel: 'Cancelar',
          );
        },
        child: const Text('Mostrar diálogo'),
      ),

      // ── Dividers ──
      const _SectionTitle('Dividers'),
      ...AppDividerStrength.values.map(
        (final s) => Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                s.name,
                style: AppTypography.captionRegular.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              AppDivider(strength: s),
            ],
          ),
        ),
      ),
    ],
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// 8. Navigation
// ─────────────────────────────────────────────────────────────────────────────

class _NavigationSection extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return _CatalogSection(
      children: [
        const _SectionTitle('NavBar — tipos'),
        // Inicio type with login (logo + notifications + avatar)
        Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.space8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            child: const AppNavBar(
              type: AppNavBarType.inicio,
              isLoggedIn: true,
            ),
          ),
        ),
        ...AppNavBarType.values.map(
          (final t) => Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.space8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              child: AppNavBar(
                type: t,
                title: t.name,
                onBack: () {},
              ),
            ),
          ),
        ),
        const _SectionTitle('StickyBar — tipos'),
        ...AppStickyBarType.values.map(
          (final t) => Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.space12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.name,
                  style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 4),
                AppStickyBar(
                  type: t,
                  primaryLabel: 'Continuar',
                  onPrimary: () {},
                  secondaryLabel: 'Cancelar',
                  onSecondary: () {},
                ),
              ],
            ),
          ),
        ),
        const _SectionTitle('NavCard'),
        Column(
          children: [
            AppNavCard(
              label: 'Cita Previa',
              icon: Icons.calendar_today_rounded,
              onTap: () {},
              description: 'Gestionar citas',
            ),
            const SizedBox(height: AppDimensions.space8),
            AppNavCard(
              label: 'Notificaciones',
              icon: Icons.notifications_outlined,
              onTap: () {},
            ),
            const SizedBox(height: AppDimensions.space8),
            AppNavCard(
              label: 'Biométrico',
              icon: Icons.fingerprint_rounded,
              onTap: () {},
            ),
            const SizedBox(height: AppDimensions.space8),
            const AppNavCard(
              label: 'Desactivado',
              icon: Icons.lock_outline_rounded,
              onTap: null,
              isDisabled: true,
            ),
          ],
        ),
        const _SectionTitle('Avatar'),
        const Wrap(
          spacing: AppDimensions.space16,
          children: [
            AppAvatar(size: AppAvatarSize.small),
            AppAvatar(
              initials: 'JG',
              hasStatus: true,
            ),
            AppAvatar(initials: 'AB', size: AppAvatarSize.large),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 9. Lists & Cards
// ─────────────────────────────────────────────────────────────────────────────

class _ListsCardsSection extends StatefulWidget {
  const _ListsCardsSection({
    required this.checkValue,
    required this.checkError,
    required this.onCheckChanged,
    required this.onCheckError,
  });

  final bool checkValue;
  final bool checkError;
  final ValueChanged<bool?> onCheckChanged;
  final VoidCallback onCheckError;

  @override
  State<_ListsCardsSection> createState() => _ListsCardsSectionState();
}

class _ListsCardsSectionState extends State<_ListsCardsSection> {
  // ignore: unused_field
  String? _selectedOption = 'opt1';
  final Set<String> _checkedItems = {'chk2'};

  @override
  Widget build(final BuildContext context) => _CatalogSection(
    children: [
      const _SectionTitle('Cards — clases'),
      AppCard(
        title: 'Familia numerosa',
        categoryLabel: 'Tag | Categoría',
        statusTag: const AppTag(status: AppTagStatus.infoActive, label: 'Actualizado'),
        titleIcon: const Icon(Icons.badge_outlined, size: 32, color: AppColors.primary),
        refNumber: '0000000000000000',
        expiryDate: '30 Dic 2029',
        attachmentLabel: 'Archivos adjuntos al expediente',
        lastUpdateText: 'Actualizado el 21 abr 2026 a las 23:00h',
        onTap: () {},
      ),
      const SizedBox(height: AppDimensions.space8),
      const AppCard(
        title: 'Familia numerosa',
        state: AppCardState.warning,
        isInteractive: false,
        categoryLabel: 'Tag | Categoría',
        statusTag: AppTag(status: AppTagStatus.warning, label: 'Atención'),
        titleIcon: Icon(Icons.badge_outlined, size: 32, color: AppColors.primary),
        refNumber: '0000000000000000',
        expiryDate: '30 Dic 2029',
        expiryWarning: true,
        attachmentLabel: 'Archivos adjuntos al expediente',
        lastUpdateText: 'Actualizado el 21 abr 2026 a las 23:00h',
      ),
      const SizedBox(height: AppDimensions.space8),
      const AppCard(
        title: 'Familia numerosa',
        state: AppCardState.disabled,
        isInteractive: false,
        categoryLabel: 'Tag | Categoría',
        statusTag: AppTag(status: AppTagStatus.infoInactive, label: 'Caducado'),
        titleIcon: Icon(Icons.badge_outlined, size: 32, color: AppColors.textDisabled),
        refNumber: '0000000000000000',
        expiryDate: '30 Dic 2029',
        attachmentLabel: 'Archivos adjuntos al expediente',
        lastUpdateText: 'Actualizado el 21 abr 2026 a las 23:00h',
      ),
      const SizedBox(height: AppDimensions.space8),
      const AppCard(
        cardClass: AppCardClass.agenda,
        title: 'Cita en Atención Primaria',
        isInteractive: false,
        date: '21 dic 2026',
        time: '10:30h',
        description: 'Texto de la descripción del evento de la Agenda, que puede ser largo, corto o mediano.',
        lastUpdateText: 'Actualizado el 21 abr 2026 a las 23:00h',
      ),
      const SizedBox(height: AppDimensions.space8),
      const AppCard(
        cardClass: AppCardClass.agenda,
        title: 'Cita en Atención Primaria',
        state: AppCardState.disabled,
        isInteractive: false,
        date: '21 dic 2026',
        time: '10:30h',
        description: 'Descripción de la cita (deshabilitada).',
        lastUpdateText: 'Actualizado el 21 abr 2026 a las 23:00h',
      ),
      const _SectionTitle('Progress Bar'),
      const AppProgressBar(value: 0.3),
      const SizedBox(height: AppDimensions.space8),
      const AppProgressBar(value: 0.7, color: AppColors.success),
      const SizedBox(height: AppDimensions.space8),
      const AppProgressBar(
        semanticsLabel: 'Cargando datos',
      ),
      const _SectionTitle('Checkbox'),
      AppCheckbox(
        label: 'Acepto los términos y condiciones',
        value: widget.checkValue,
        onChanged: widget.onCheckChanged,
        isError: widget.checkError,
        errorText: widget.checkError ? 'Debes aceptar los términos' : null,
      ),
      const SizedBox(height: AppDimensions.space8),
      ElevatedButton(
        onPressed: widget.onCheckError,
        child: const Text('Toggle error'),
      ),
      const SizedBox(height: AppDimensions.space8),
      const AppCheckbox(
        label: 'Checkbox desactivado',
        value: false,
        onChanged: null,
      ),

      // ── Basic List ──
      const _SectionTitle('List — Basic'),
      const AppList(
        header: 'Información',
        children: [
          AppListItem(
            title: 'Ítem con subtítulo y flecha',
            subtitle: 'Descripción adicional',
            leading: Icon(Icons.folder_outlined),
          ),
          AppListItem(
            title: 'Ítem sin acción',
            leading: Icon(Icons.info_outline_rounded),
          ),
          AppListItem(
            title: 'Ítem desactivado',
            subtitle: 'No disponible',
            isDisabled: true,
            leading: Icon(Icons.lock_outline_rounded),
          ),
        ],
      ),

      // ── DropDownList (radio select) ──
      const _SectionTitle('List — DropDownList (single select)'),
      AppList(
        title: 'Búsquedas recientes',
        subtitle: 'Selecciona una opción',
        variant: AppListVariant.dropDownList,
        children: [
          AppListOptionItem(
            title: 'Español',
            leading: const Icon(Icons.schedule_outlined, size: 24),
            onTap: () => setState(() => _selectedOption = 'opt1'),
          ),
          AppListOptionItem(
            title: 'English',
            leading: const Icon(Icons.schedule_outlined, size: 24),
            onTap: () => setState(() => _selectedOption = 'opt2'),
          ),
          AppListOptionItem(
            title: 'Français',
            leading: const Icon(Icons.schedule_outlined, size: 24),
            onTap: () => setState(() => _selectedOption = 'opt3'),
          ),
          const AppListOptionItem(
            title: 'Sin icono, sin acción',
          ),
        ],
      ),

      // ── Checklist (multi select) ──
      const _SectionTitle('List — Checklist (multi select)'),
      AppList(
        title: 'Preferencias',
        variant: AppListVariant.checklist,
        children: [
          AppListCheckItem(
            title: 'Notificaciones push',
            isChecked: _checkedItems.contains('chk1'),
            onChanged: (final v) => setState(() {
              v ? _checkedItems.add('chk1') : _checkedItems.remove('chk1');
            }),
          ),
          AppListCheckItem(
            title: 'Boletín semanal',
            isChecked: _checkedItems.contains('chk2'),
            onChanged: (final v) => setState(() {
              v ? _checkedItems.add('chk2') : _checkedItems.remove('chk2');
            }),
          ),
          AppListCheckItem(
            title: 'Modo oscuro',
            isChecked: _checkedItems.contains('chk3'),
            onChanged: (final v) => setState(() {
              v ? _checkedItems.add('chk3') : _checkedItems.remove('chk3');
            }),
          ),
          const AppListCheckItem(
            title: 'Desactivado',
            isDisabled: true,
          ),
        ],
      ),

      // ── Expandable ──
      const _SectionTitle('List — Expandable'),
      const AppList(
        header: 'Preguntas frecuentes',
        variant: AppListVariant.expandable,
        children: [
          AppListExpandableItem(
            title: '¿Cómo puedo registrarme?',
            leading: Icon(
              Icons.help_outline_rounded,
              color: AppColors.primary,
            ),
            children: [
              Text(
                'Accede a la sección de registro desde la pantalla principal '
                'y completa el formulario con tus datos personales.',
              ),
            ],
          ),
          AppListExpandableItem(
            title: '¿Es seguro?',
            subtitle: 'Información de seguridad',
            initiallyExpanded: true,
            children: [
              Text(
                'Toda la comunicación se cifra con TLS 1.3 y los datos '
                'se almacenan según el RGPD.',
              ),
            ],
          ),
          AppListExpandableItem(
            title: 'Sección desactivada',
            isDisabled: true,
            children: [Text('No visible')],
          ),
        ],
      ),
    ],
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// BOTTOM SHEET SECTION
// ═══════════════════════════════════════════════════════════════════════════════

class _BottomSheetSection extends StatelessWidget {
  @override
  Widget build(final BuildContext context) => _CatalogSection(
    children: [
      const _SectionTitle('Bottom Sheet'),
      const Text('Modal con scrim oscuro, drag handle y close.'),
      const SizedBox(height: 16),
      ElevatedButton(
        onPressed: () => AppBottomSheet.show<void>(
          context: context,
          title: '¿Para qué se usan estos datos?',
          body: const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              '1. Tu email y teléfono se usarán únicamente para avisarte de nuevas notificaciones electrónicas.\n'
              '2. Podrás modificar estos datos siempre que quieras.\n'
              '3. Para aceptar una notificación, entra en ella y pulsa "aceptar".',
              style: AppTypography.bodyRegular,
            ),
          ),
        ),
        child: const Text('Abrir BottomSheet'),
      ),
    ],
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// CALENDAR SECTION
// ═══════════════════════════════════════════════════════════════════════════════

class _CalendarSection extends StatelessWidget {
  @override
  Widget build(final BuildContext context) => _CatalogSection(
    children: [
      const _SectionTitle('Calendario'),
      const Text('Selector de mes con días seleccionables.'),
      const SizedBox(height: 16),
      AppCalendar(
        initialDate: DateTime(2026, 3, 17),
        selectedDates: {DateTime(2026, 3, 12), DateTime(2026, 3, 25)},
        onDateSelected: (final date) {},
      ),
    ],
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// DRAWER MENU SECTION
// ═══════════════════════════════════════════════════════════════════════════════

class _DrawerMenuSection extends StatelessWidget {
  @override
  Widget build(final BuildContext context) => _CatalogSection(
    children: [
      const _SectionTitle('Drawer Menu'),
      const Text(
        'Menú lateral deslizante con sección oscura (perfil + navegación '
        'principal) y sección clara (enlaces secundarios + acción externa).',
      ),
      const SizedBox(height: 16),
      ElevatedButton(
        onPressed: () => showAppDrawerMenu(
          context: context,
          userName: 'María del Pilar',
          nif: '00000000Z',
          primaryItems: [
            AppDrawerMenuItem(
              label: 'Mi perfil',
              icon: Icons.settings_outlined,
              onTap: () {},
            ),
            AppDrawerMenuItem(
              label: 'Mis carnets digitales',
              icon: Icons.person_outline_rounded,
              onTap: () {},
            ),
          ],
          secondaryLinks: [
            AppDrawerLinkItem(label: 'Ayuda y Contacto', onTap: () {}),
            AppDrawerLinkItem(label: 'Accesibilidad', onTap: () {}),
            AppDrawerLinkItem(label: 'Aviso Legal', onTap: () {}),
            AppDrawerLinkItem(label: 'Privacidad', onTap: () {}),
          ],
          onLogout: () {},
          actionButtonLabel: 'Ir a Sede Electrónica',
          onActionButton: () {},
        ),
        child: const Text('Abrir Drawer Menu'),
      ),
    ],
  );
}
