import 'package:flutter/material.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(final BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Página no encontrada')),
    body: const Center(child: Text('404 — La ruta solicitada no existe.')),
  );
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
