import 'package:flutter/cupertino.dart' show IconData;
import 'package:flutter/material.dart' show IconData;
import 'package:flutter/widgets.dart' show IconData;

/// Pure domain entity for the public landing screen.
///
/// No Flutter, Riverpod, Dio, or any infrastructure imports — this layer
/// belongs to the entity zone and must remain pure Dart.
class LandingContent {
  const LandingContent({
    required this.appTitle,
    required this.tagline,
    required this.features,
    required this.accessSteps,
    required this.links,
  });

  /// Application display title shown in the hero section.
  final String appTitle;

  /// Short tagline describing the app value proposition.
  final String tagline;

  /// "Qué encontrarás" — list of available service categories.
  final List<LandingFeatureItem> features;

  /// "Cómo acceder" — numbered onboarding steps.
  final List<LandingAccessStep> accessSteps;

  /// Footer links for legal, help, and accessibility pages.
  final LandingLinks links;
}

/// A single service category shown in the "Qué encontrarás" grid.
class LandingFeatureItem {
  const LandingFeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  /// Semantic icon name (e.g. 'notifications', 'health') — not an [IconData].
  /// The presentation layer resolves the actual icon from this identifier.
  final String icon;

  /// Localised card title.
  final String title;

  /// Localised short description.
  final String description;
}

/// A single numbered step in the "Cómo acceder" section.
class LandingAccessStep {
  const LandingAccessStep({
    required this.stepNumber,
    required this.title,
    required this.description,
  });

  /// 1-based position shown in the step indicator.
  final int stepNumber;

  /// Localised step title.
  final String title;

  /// Localised step description.
  final String description;
}

/// URLs for the landing page footer links.
class LandingLinks {
  const LandingLinks({
    required this.helpUrl,
    required this.accessibilityUrl,
    required this.legalUrl,
    required this.privacyUrl,
  });

  /// URL for the help / support page.
  final String helpUrl;

  /// URL for the accessibility statement.
  final String accessibilityUrl;

  /// URL for the legal notice.
  final String legalUrl;

  /// URL for the data protection / privacy policy.
  final String privacyUrl;
}
