/// Carnet Joven (EPIC-7 / STORY-50) — full-page presentation.
///
/// Per-card detail page reachable via `Routes.cardJovenDetail`. The
/// catalog (STORY-48) opens the modal variant instead — this page is
/// kept as the canonical surface for deep links and for any future
/// home/menu shortcut that prefers a full screen.
///
/// // TODO(future-sprint): wire home shortcut / app menu entry once
///   navigation surfaces ask for the page variant explicitly.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/connectivity/offline_banner.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/joven/2_presentation/joven_detail_body.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

class JovenDetailPage extends ConsumerWidget {
  const JovenDetailPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.jovenDetailTitle)),
      body: const OfflineBanner(child: JovenDetailBody()),
    );
  }
}
