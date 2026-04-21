import 'package:flutter/material.dart';

/// Outer scaffold shell that wraps screen content.
///
/// This is the canonical host widget for bottom navigation bars, drawers,
/// and other persistent chrome. Expand it in STORY-13 when navigation is wired.
class AppScaffold extends StatelessWidget {
  const AppScaffold({required this.child, super.key});

  final Widget child;

  @override
  Widget build(final BuildContext context) => Scaffold(body: child);
}
