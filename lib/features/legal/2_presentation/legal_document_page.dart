import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/empty_state_widget.dart';
import 'package:jccm_espacio_ciudadano/features/legal/0_entity/legal_document.dart';
import 'package:jccm_espacio_ciudadano/features/legal/1_domain/legal_documents_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Renders one bundled [LegalDocument] as scrollable typography.
///
/// AC: offline-first because content is bundled.
///
/// The body is a tiny subset of Markdown — paragraphs separated by blank
/// lines and bullet lines starting with `- `. We render them inline
/// without any third-party Markdown dependency (canon §28 — no new deps).
class LegalDocumentPage extends ConsumerWidget {
  const LegalDocumentPage({required this.documentId, super.key});

  final LegalDocumentId documentId;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final repo = ref.watch(legalDocumentsRepositoryProvider);
    final doc = repo.findById(documentId);

    if (doc == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.legalNotFoundTitle)),
        body: EmptyStateWidget(
          icon: Icons.description_outlined,
          message: l10n.legalNotFoundMessage,
        ),
      );
    }

    final title = _resolveLegalTitle(l10n, doc.titleKey);
    final blocks = _parseBody(doc.bodyMarkdown);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Semantics(
        label: title,
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.space24,
              vertical: AppDimensions.space24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: blocks
                  .map((final b) => _BlockWidget(block: b))
                  .toList(growable: false),
            ),
          ),
        ),
      ),
    );
  }
}

String _resolveLegalTitle(final AppLocalizations l10n, final String key) {
  switch (key) {
    case 'legalTermsTitle':
      return l10n.legalTermsTitle;
    case 'legalPrivacyTitle':
      return l10n.legalPrivacyTitle;
    case 'legalAccessibilityTitle':
      return l10n.legalAccessibilityTitle;
    case 'legalNoticeTitle':
      return l10n.legalNoticeTitle;
    default:
      return key;
  }
}

// ── Mini-Markdown rendering ──────────────────────────────────────────────────

@immutable
sealed class _LegalBlock {
  const _LegalBlock();
}

class _ParagraphBlock extends _LegalBlock {
  const _ParagraphBlock(this.text);
  final String text;
}

class _BulletBlock extends _LegalBlock {
  const _BulletBlock(this.items);
  final List<String> items;
}

List<_LegalBlock> _parseBody(final String markdown) {
  final List<_LegalBlock> result = <_LegalBlock>[];
  final segments = markdown.trim().split(RegExp(r'\n\s*\n'));
  for (final raw in segments) {
    final lines = raw.split('\n');
    final allBullets = lines.every((final l) => l.trimLeft().startsWith('- '));
    if (allBullets) {
      result.add(
        _BulletBlock(
          lines
              .map((final l) => l.trimLeft().substring(2).trim())
              .toList(growable: false),
        ),
      );
    } else {
      result.add(_ParagraphBlock(raw.trim()));
    }
  }
  return result;
}

class _BlockWidget extends StatelessWidget {
  const _BlockWidget({required this.block});
  final _LegalBlock block;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final body = theme.textTheme.bodyMedium?.copyWith(height: 1.6);
    switch (block) {
      case _ParagraphBlock(text: final t):
        return Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.space16),
          child: Text(t, style: body),
        );
      case _BulletBlock(items: final items):
        return Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: items
                .map(
                  (final item) => Padding(
                    padding:
                        const EdgeInsets.only(bottom: AppDimensions.space4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 6),
                          child: Icon(Icons.circle, size: 6),
                        ),
                        const SizedBox(width: AppDimensions.space8),
                        Expanded(child: Text(item, style: body)),
                      ],
                    ),
                  ),
                )
                .toList(growable: false),
          ),
        );
    }
  }
}
