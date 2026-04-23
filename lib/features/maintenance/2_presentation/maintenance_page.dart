import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Full-screen maintenance page shown when the service is unavailable.
class MaintenancePage extends StatelessWidget {
  const MaintenancePage({super.key, this.message, this.expectedEnd});

  /// Optional override message (from push notification / remote config).
  final String? message;
  final DateTime? expectedEnd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.build_circle_outlined,
                size: 72,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                l10n.maintenanceTitle,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                message ?? l10n.maintenanceSubtitle,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/');
                  }
                },
                child: Text(l10n.maintenanceRetry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
