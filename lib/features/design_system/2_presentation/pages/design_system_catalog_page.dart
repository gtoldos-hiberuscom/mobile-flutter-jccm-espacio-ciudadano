import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';

/// Interactive design-system catalog.
///
/// Shows every token category and component with live previews.
/// Intended as a developer/designer reference, not a production screen.
class DesignSystemCatalogPage extends StatefulWidget {
  const DesignSystemCatalogPage({super.key});

  @override
  State<DesignSystemCatalogPage> createState() =>
      _DesignSystemCatalogPageState();
}

class _DesignSystemCatalogPageState extends State<DesignSystemCatalogPage>
    with SingleTickerProviderStateMixin {
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
    'Botones',
    'Tags',
    'Inputs',
    'Alertas',
    'Navegación',
    'Listas & Cards',
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
          tabs: _sections.map((s) => Tab(text: s)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ColorsSection(),
          _TypographySection(),
          _SpacingSection(),
          _ButtonsSection(),
          _TagsSection(),
          _InputsSection(controller: _emailController),
          _AlertsSection(),
          _NavigationSection(),
          _ListsCardsSection(
            checkValue: _checkValue,
            checkError: _checkError,
            onCheckChanged: (v) => setState(() => _checkValue = v ?? false),
            onCheckError: () =>
                setState(() => _checkError = !_checkError),
          ),
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
    child: Text(title, style: AppTypography.h5),
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
  Widget build(final BuildContext context) => _CatalogSection(
    children: [
      const _SectionTitle('Primitivas — Blue'),
      _Palette(colors: [
        ('blue100', AppColors.blue100),
        ('blue200', AppColors.blue200),
        ('blue300', AppColors.blue300),
        ('blue400', AppColors.blue400),
        ('blue500', AppColors.blue500),
        ('blue600', AppColors.blue600),
        ('blue700', AppColors.blue700),
        ('blue800', AppColors.blue800),
        ('blue900', AppColors.blue900),
      ]),
      const _SectionTitle('Primitivas — Neutral'),
      _Palette(colors: [
        ('neutral100', AppColors.neutral100),
        ('neutral200', AppColors.neutral200),
        ('neutral300', AppColors.neutral300),
        ('neutral400', AppColors.neutral400),
        ('neutral500', AppColors.neutral500),
        ('neutral600', AppColors.neutral600),
        ('neutral700', AppColors.neutral700),
        ('neutral800', AppColors.neutral800),
        ('neutral900', AppColors.neutral900),
      ]),
      const _SectionTitle('Semánticas'),
      _Palette(colors: [
        ('primary', AppColors.primary),
        ('secondary', AppColors.secondary),
        ('success', AppColors.success),
        ('warning', AppColors.warning),
        ('error', AppColors.error),
        ('background', AppColors.background),
        ('surface', AppColors.surface),
        ('outline', AppColors.outline),
        ('textPrimary', AppColors.textPrimary),
        ('textSecondary', AppColors.textSecondary),
        ('disabled', AppColors.disabled),
      ]),
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
          (c) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 44,
                decoration: BoxDecoration(
                  color: c.$2,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusSmall),
                  border: Border.all(color: AppColors.outlineVariant),
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 60,
                child: Text(
                  c.$1,
                  style: AppTypography.small,
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
      const _SectionTitle('Estilos de texto Figma'),
      ...[
        ('H1', AppTypography.h1),
        ('H2', AppTypography.h2),
        ('H3', AppTypography.h3),
        ('H4', AppTypography.h4),
        ('H5', AppTypography.h5),
        ('H6', AppTypography.h6),
        ('LargeText', AppTypography.largeText),
        ('BodyBold', AppTypography.bodyBold),
        ('Body L', AppTypography.bodyL),
        ('Body Base', AppTypography.bodyBase),
        ('Body S', AppTypography.bodyS),
        ('Caption', AppTypography.caption),
        ('Small', AppTypography.small),
      ].map(
        (t) => Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.space8),
          child: Row(
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  t.$1,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              Expanded(child: Text('Texto de ejemplo', style: t.$2)),
            ],
          ),
        ),
      ),
    ],
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
        (s) => Padding(
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
              Text('${s.$2.toInt()} dp',
                  style: AppTypography.caption),
            ],
          ),
        ),
      ),
      const _SectionTitle('Border radius'),
      Wrap(
        spacing: AppDimensions.space8,
        runSpacing: AppDimensions.space8,
        children: [
          ('xs (4)', AppDimensions.radiusSmall),
          ('md (8)', AppDimensions.radiusMedium),
          ('lg (12)', AppDimensions.radiusLarge),
          ('xl (16)', AppDimensions.radiusXLarge),
          ('999', AppDimensions.radiusRound),
        ]
            .map(
              (r) => Column(
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
                  Text(r.$1, style: AppTypography.small),
                ],
              ),
            )
            .toList(),
      ),
    ],
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// 4. Buttons
// ─────────────────────────────────────────────────────────────────────────────

class _ButtonsSection extends StatelessWidget {
  @override
  Widget build(final BuildContext context) => _CatalogSection(
    children: [
      const _SectionTitle('Jerarquías (Medium)'),
      ...AppButtonHierarchy.values.map(
        (h) => Padding(
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
      const _SectionTitle('Tamaños'),
      Row(
        children: [
          AppButton(
            label: 'Medium',
            onPressed: () {},
            size: AppButtonSize.medium,
          ),
          const SizedBox(width: AppDimensions.space12),
          AppButton(
            label: 'Small',
            onPressed: () {},
            size: AppButtonSize.small,
          ),
        ],
      ),
      const _SectionTitle('Con icono'),
      AppButton(
        label: 'Con icono',
        onPressed: () {},
        icon: const Icon(Icons.fingerprint_rounded, size: 18),
      ),
      const _SectionTitle('Cargando'),
      AppButton(label: 'Cargando', onPressed: () {}, isLoading: true),
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
        children: AppTagState.values
            .map((s) => AppTag(state: s, label: s.name))
            .toList(),
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
        (s) => Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.space16),
          child: AppInputCase(
            label: s.name,
            hint: 'Ejemplo de ${s.name}',
            state: s,
            enabled: s != AppInputState.disabled,
            errorText:
                s == AppInputState.error ? 'Valor no válido' : null,
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

class _AlertsSection extends StatelessWidget {
  @override
  Widget build(final BuildContext context) => _CatalogSection(
    children: [
      const _SectionTitle('AlertBanner'),
      ...AppAlertSeverity.values.map(
        (s) => Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.space12),
          child: AppAlertBanner(
            severity: s,
            title: s.name,
            message: 'Mensaje informativo de tipo ${s.name}.',
          ),
        ),
      ),
      const _SectionTitle('AlertContextual'),
      Wrap(
        spacing: AppDimensions.space8,
        runSpacing: AppDimensions.space8,
        children: [
          AppAlertContextual(
            severity: AppAlertSeverity.neutral,
            message: 'Información relevante',
            horizontal: true,
          ),
          AppAlertContextual(
            severity: AppAlertSeverity.error,
            message: 'Error en el campo',
            size: AppAlertContextualSize.small,
            horizontal: true,
          ),
          AppAlertContextual(
            severity: AppAlertSeverity.success,
            message: 'Guardado',
            horizontal: true,
          ),
        ],
      ),
      const _SectionTitle('Toast (imperativo)'),
      Wrap(
        spacing: AppDimensions.space8,
        children: AppAlertSeverity.values
            .map(
              (s) => ElevatedButton(
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
      const _SectionTitle('Dividers'),
      ...AppDividerStrength.values.map(
        (s) => Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                s.name,
                style: AppTypography.caption.copyWith(
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
        ...AppNavBarType.values.map(
          (t) => Padding(
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
          (t) => Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.space12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.name,
                  style: AppTypography.caption
                      .copyWith(color: AppColors.textSecondary),
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
        Wrap(
          spacing: AppDimensions.space16,
          children: const [
            AppAvatar(size: AppAvatarSize.small),
            AppAvatar(
              initials: 'JG',
              size: AppAvatarSize.medium,
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

class _ListsCardsSection extends StatelessWidget {
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
  Widget build(final BuildContext context) => _CatalogSection(
    children: [
      const _SectionTitle('Cards — clases'),
      AppCard(
        title: 'Tarjeta básica',
        subtitle: 'Subtítulo informativo',
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () {},
      ),
      const SizedBox(height: AppDimensions.space8),
      AppCard(
        cardClass: AppCardClass.agenda,
        title: 'Cita médica',
        subtitle: 'Centro de Salud Palomarejos',
        date: '15',
        month: 'ENE',
        onTap: () {},
      ),
      const SizedBox(height: AppDimensions.space8),
      const AppCard(
        title: 'Aviso importante',
        subtitle: 'Requiere atención',
        state: AppCardState.warning,
      ),
      const SizedBox(height: AppDimensions.space8),
      const AppCard(
        title: 'Tarjeta desactivada',
        state: AppCardState.disabled,
      ),
      const _SectionTitle('Progress Bar'),
      const AppProgressBar(value: 0.3),
      const SizedBox(height: AppDimensions.space8),
      const AppProgressBar(value: 0.7, color: AppColors.success),
      const SizedBox(height: AppDimensions.space8),
      const AppProgressBar(
        value: null,
        semanticsLabel: 'Cargando datos',
      ),
      const _SectionTitle('Checkbox'),
      AppCheckbox(
        label: 'Acepto los términos y condiciones',
        value: checkValue,
        onChanged: onCheckChanged,
        isError: checkError,
        errorText: checkError ? 'Debes aceptar los términos' : null,
      ),
      const SizedBox(height: AppDimensions.space8),
      ElevatedButton(
        onPressed: onCheckError,
        child: const Text('Toggle error'),
      ),
      const SizedBox(height: AppDimensions.space8),
      const AppCheckbox(
        label: 'Checkbox desactivado',
        value: false,
        onChanged: null,
      ),
      const _SectionTitle('List Items'),
      const AppListItem(
        title: 'Ítem con subtítulo y flecha',
        subtitle: 'Descripción adicional',
        leading: Icon(Icons.folder_outlined),
      ),
      const AppDivider(),
      const AppListItem(
        title: 'Ítem sin acción',
        leading: Icon(Icons.info_outline_rounded),
      ),
      const AppDivider(),
      const AppListItem(
        title: 'Ítem desactivado',
        subtitle: 'No disponible',
        isDisabled: true,
        leading: Icon(Icons.lock_outline_rounded),
      ),
    ],
  );
}
