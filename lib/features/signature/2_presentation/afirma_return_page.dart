import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/app/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/features/signature/1_domain/signature_handoff_controller.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Landing screen for the Afirma return deep-link (STORY-46).
///
/// Mounted on [Routes.afirmaReturn]. On its first frame it forwards the
/// incoming deep-link [returnUri] to the
/// [signatureHandoffControllerProvider], which:
///   * parses it via the pure `SignatureDeepLinkParser`,
///   * updates the in-flight outcome accordingly, and
///   * triggers a refresh of the signature inbox.
///
/// The screen itself only renders a brief "Procesando firma…" surface;
/// once the outcome has been recorded it navigates back to
/// [Routes.signatureInbox] so the citizen lands on the inbox where the
/// outcome SnackBar is shown by the inbox page.
///
/// Navigation is injected via [onProcessed] so widget tests can mount
/// the page without a `GoRouter`.
class AfirmaReturnPage extends ConsumerStatefulWidget {
  const AfirmaReturnPage({required this.returnUri, this.onProcessed, super.key});

  /// The deep-link URI that triggered the navigation. The router
  /// extracts it from `GoRouterState.uri`.
  final Uri returnUri;

  /// Optional override for the post-processing navigation. When `null`,
  /// the page calls `context.go(Routes.signatureInbox)`. Tests inject a
  /// no-op so the absence of a `GoRouter` is not fatal.
  final VoidCallback? onProcessed;

  @override
  ConsumerState<AfirmaReturnPage> createState() => _AfirmaReturnPageState();
}

class _AfirmaReturnPageState extends ConsumerState<AfirmaReturnPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((final _) {
      if (!mounted) {
        return;
      }
      ref.read(signatureHandoffControllerProvider.notifier).completeFromDeepLink(widget.returnUri);
      // Defer navigation so the controller state update has a chance to
      // settle before the inbox page rebuilds and reads it.
      unawaited(
        Future<void>.microtask(() {
          if (!mounted) {
            return;
          }
          if (widget.onProcessed != null) {
            widget.onProcessed!();
          } else {
            context.go(Routes.signatureInbox);
          }
        }),
      );
    });
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.signatureAfirmaReturnTitle)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const CircularProgressIndicator(),
            const SizedBox(height: AppDimensions.space16),
            Text(
              l10n.signatureAfirmaReturnProcessing,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
