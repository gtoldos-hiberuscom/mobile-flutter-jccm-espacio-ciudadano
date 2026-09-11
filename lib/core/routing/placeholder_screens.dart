import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.notFoundPageTitle)),
      body: Center(child: Text(l10n.notFoundPageMessage)),
    );
  }
}

class DomainLandingPlaceholder extends StatelessWidget {
  const DomainLandingPlaceholder({required this.title, super.key});

  final String title;

  @override
  Widget build(final BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: Center(child: Text('$title (placeholder)')),
  );
}
