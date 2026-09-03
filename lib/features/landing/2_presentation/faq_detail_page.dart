import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';

class FaqEntry {
  const FaqEntry({required this.id, required this.question, required this.answer});

  final String id;
  final String question;
  final String answer;
}

const faqEntries = <FaqEntry>[
  FaqEntry(
    id: 'espacio-ciudadano',
    question: '¿Qué es y qué podré encontrar en el Espacio ciudadano?',
    answer: 'Espacio Ciudadano reúne en un único lugar información y servicios de la Junta de Comunidades de Castilla-La Mancha. Podrás consultar tus datos, expedientes, notificaciones, citas y otros servicios disponibles.',
  ),
  FaqEntry(
    id: 'acceso',
    question: '¿Qué necesito para acceder?',
    answer: 'Necesitas identificarte con Cl@ve, certificado electrónico o el sistema de acceso habilitado. Puedes usar Cl@ve Móvil, Cl@ve Permanente, DNI electrónico o un certificado electrónico.',
  ),
  FaqEntry(
    id: 'datos-personales',
    question: '¿Qué datos personales se almacenan en Espacio Ciudadano?',
    answer: 'Se muestran los datos necesarios para prestar los servicios disponibles en la aplicación.',
  ),
  FaqEntry(
    id: 'corregir-datos',
    question: 'Los datos mostrados contienen algún error, ¿puedo corregirlo?',
    answer: 'Contacta con el órgano responsable del trámite o expediente para solicitar la corrección.',
  ),
  FaqEntry(
    id: 'agenda',
    question: '¿Qué eventos se muestran en Mi Agenda?',
    answer: 'Se muestran citas, avisos y eventos administrativos relacionados con tus servicios.',
  ),
  // Las preguntas nuevas se añaden aquí cuando el cliente entregue su
  // contenido definitivo — nunca como entradas placeholder: tres «Preguntas a
  // trabajar para app» llegaron a verse en producción (N-08).
];

FaqEntry? faqEntryById(final String id) {
  for (final entry in faqEntries) {
    if (entry.id == id) {
      return entry;
    }
  }
  return null;
}

class FaqDetailPage extends StatelessWidget {
  const FaqDetailPage({required this.entry, super.key});

  final FaqEntry entry;

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBlueLighter,
      appBar: AppNavBar(
        title: 'Preguntas frecuentes',
        leading: IconButton(
          icon: const AppIcon(
            AppIcons.arrowBack,
            size: AppDimensions.iconLarge,
            color: AppColors.textPrimary,
          ),
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(Routes.helpContact);
            }
          },
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.space16,
            AppDimensions.space24,
            AppDimensions.space16,
            AppDimensions.space48,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSectionHeading(entry.question),
              const SizedBox(height: AppDimensions.space24),
              Text(
                entry.answer,
                style: AppTypography.bodyL.copyWith(color: AppColors.textPrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
