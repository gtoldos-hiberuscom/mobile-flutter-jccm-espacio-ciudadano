import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/app/routing/route_registry.dart' show Routes;
import 'package:jccm_espacio_ciudadano/app/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart' show AppButton;
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart' show AppButton;
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_loading_indicator.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_state.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/session_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/widgets/session_error_widget.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/landing_page.dart' show LandingPage;
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Login screen for the Cl@ve authentication flow.
///
/// ## Responsibilities
/// - On mount, auto-initiates the Cl@ve login by opening the portal URL in the
///   platform browser via [SessionNotifier.login].
/// - Shows a loading indicator + status message while the browser is open.
/// - Shows [SessionErrorWidget] if the login initiation fails, with a retry
///   option.
/// - Actual token delivery happens via deep-link callback to
///   `/auth/clave/callback`, which GoRouter routes to
///   [SessionNotifier.handleCallback].
///
/// ## Navigation
/// - `context.go(Routes.login)` is called from [LandingPage] CTA.
/// - On successful callback the GoRouter guard redirects to [Routes.home].
///
/// ## Accessibility
/// - Uses [Semantics] live regions on status / error messages.
/// - Minimum touch targets enforced by [AppButton].
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  // The Cl@ve portal URL — in Sprint 1 this is a well-known placeholder.
  // Sprint 2 (TASK-21) will retrieve this from AppConfig / backend.
  static const String _clavePortalUrl = 'https://clave.gob.es/clave_Home/inicio.html';

  bool _hasInitiated = false;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    // Delay until after first frame so the widget tree is fully built before
    // the async login call touches Riverpod state.
    WidgetsBinding.instance.addPostFrameCallback((_) => _initiateLogin());
  }

  Future<void> _initiateLogin() async {
    setState(() {
      _hasInitiated = true;
      _hasError = false;
      _errorMessage = '';
    });
    // SessionNotifier.login opens the browser and stays in AuthLoading.
    // If the URL cannot be opened it surfaces an error via state.
    await ref.read(sessionProvider.notifier).login(_clavePortalUrl);
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authState = ref.watch(sessionProvider);

    // Derive display state from the async notifier value.
    final currentAuthState = authState.value;
    final isError = (currentAuthState is AuthError) || _hasError;
    final errorMsg = currentAuthState is AuthError ? currentAuthState.message : _errorMessage;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          l10n.loginPageTitle,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.primary,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space24,
            vertical: AppDimensions.space32,
          ),
          child: Center(
            child: isError
                ? SessionErrorWidget(
                    message: errorMsg,
                    onRetry: _initiateLogin,
                  )
                : _LoadingContent(
                    hasInitiated: _hasInitiated,
                    statusMessage: l10n.loginPageLoading,
                  ),
          ),
        ),
      ),
    );
  }
}

// ── Loading content ───────────────────────────────────────────────────────────

class _LoadingContent extends StatelessWidget {
  const _LoadingContent({
    required this.hasInitiated,
    required this.statusMessage,
  });

  final bool hasInitiated;
  final String statusMessage;

  @override
  Widget build(final BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // JCCM logo placeholder.
        Semantics(
          excludeSemantics: true,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(AppDimensions.radiusXLarge),
            ),
            child: const Icon(
              Icons.lock_outlined,
              size: 40,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.space32),

        // Spinner — shown when login has been initiated.
        if (hasInitiated) ...[
          const AppLoadingIndicator(
            semanticsLabel: 'Iniciando autenticación con Cl@ve',
          ),
          const SizedBox(height: AppDimensions.space24),
        ],

        // Status message.
        Semantics(
          liveRegion: true,
          child: Text(
            statusMessage,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: AppDimensions.space16),

        // Informational note.
        Text(
          'Se abrirá el portal Cl@ve en el navegador para completar '
          'la autenticación. Vuelve a la aplicación cuando termines.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textDisabled,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
