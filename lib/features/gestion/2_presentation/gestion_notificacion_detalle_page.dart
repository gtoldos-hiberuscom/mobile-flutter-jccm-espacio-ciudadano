import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/ui_states/error_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/ui_states/loading_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion_detalle.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/providers/gestion_notificaciones_provider.dart';

/// Detalle de notificación — Figma node 44641:24980 (expirada).
class GestionNotificacionDetallePage extends ConsumerStatefulWidget {
  const GestionNotificacionDetallePage({
    required this.notificacionId,
    required this.estado,
    this.sistemaOrigen,
    super.key,
  });

  final int notificacionId;
  final String estado;
  final String? sistemaOrigen;

  @override
  ConsumerState<GestionNotificacionDetallePage> createState() => _GestionNotificacionDetallePageState();
}

class _GestionNotificacionDetallePageState extends ConsumerState<GestionNotificacionDetallePage> {
  bool _accepting = false;

  @override
  Widget build(final BuildContext context) {
    final args = (id: widget.notificacionId, estado: widget.estado, sistemaOrigen: widget.sistemaOrigen);
    final detail = ref.watch(gestionNotificacionDetalleProvider(args));
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppNavBar(
        type: AppNavBarType.detail,
        title: 'Detalle de notificación',
        leading: IconButton(
          icon: const AppIcon(AppIcons.arrowBack, size: AppDimensions.iconLarge, color: AppColors.textPrimary),
          onPressed: () => context.canPop() ? context.pop() : context.go(Routes.gestionNotificaciones),
        ),
      ),
      body: SafeArea(
        child: detail.when(
          loading: () => const LoadingStateWidget(),
          error: (final _, final _) => ErrorStateWidget(
            message: 'No hemos podido cargar el detalle de la notificación.',
            onRetry: () => ref.invalidate(gestionNotificacionDetalleProvider(args)),
          ),
          data: (final value) => _DetalleContent(value: value),
        ),
      ),
      bottomNavigationBar: widget.estado.toLowerCase() == 'pendiente'
          ? _PendingActionBar(
              accepting: _accepting,
              onAccept: _accept,
            )
          : null,
    );
  }

  Future<void> _accept() async {
    if (_accepting) {
      return;
    }
    setState(() => _accepting = true);
    try {
      final citizenId = ref.read(gestionNotificacionesTransitionCitizenIdProvider);
      if (citizenId.isEmpty) {
        throw StateError('No hay ciudadano identificado.');
      }
      await ref
          .read(gestionNotificacionesRepositoryProvider)
          .transitionNotificacion(
            citizenId: citizenId,
            notificacionId: widget.notificacionId,
            accion: 'ACEPTAR',
            sistemaOrigen: widget.sistemaOrigen,
          );

      final args = (id: widget.notificacionId, estado: widget.estado, sistemaOrigen: widget.sistemaOrigen);
      final detail = await ref.read(gestionNotificacionDetalleProvider(args).future);
      ref
          .read(gestionNotificacionesOptimisticAcceptedProvider.notifier)
          .add(
            citizenId: citizenId,
            notification: Notificacion(
              id: widget.notificacionId,
              concepto: detail.titulo,
              procedimientoDenominacion: detail.procedimiento ?? '',
              fechaCaducidad: detail.fechaExpiracion,
              unidadOrganicaNombre: detail.organismo,
              sistemaOrigen: detail.sistemaOrigen ?? widget.sistemaOrigen,
              estado: 'aceptada',
            ),
          );

      ref
        ..invalidate(gestionNotificacionesProvider(null))
        ..invalidate(gestionNotificacionesProvider('pendiente'))
        ..invalidate(gestionNotificacionesProvider('aceptada'));
      if (!mounted) {
        return;
      }
      AppAlertSnackbar.show(
        context,
        message: 'Has aceptado la notificación.',
        severity: AppAlertSeverity.success,
      );
      context.pop();
    } on Object {
      if (!mounted) {
        return;
      }
      AppAlertSnackbar.show(
        context,
        message: 'No hemos podido aceptar la notificación. Inténtalo de nuevo.',
        severity: AppAlertSeverity.error,
      );
    } finally {
      if (mounted) {
        setState(() => _accepting = false);
      }
    }
  }
}

class _DetalleContent extends StatelessWidget {
  const _DetalleContent({required this.value});
  final NotificacionDetalle value;

  @override
  Widget build(final BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(AppDimensions.space16, AppDimensions.space8, AppDimensions.space16, AppDimensions.space24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTag(status: _tagStatus(value.estado), label: _statusLabel(value.estado)),
        const SizedBox(height: AppDimensions.space8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space4, vertical: AppDimensions.space8),
          child: Text(value.titulo, style: AppTypography.h2.copyWith(color: AppColors.textBase)),
        ),
        _SectionTitle(_isPending(value.estado) ? 'Datos del expediente' : 'Datos del Registro'),
        if (value.organismo != null)
          _DetailField(
            label: 'Organismo emisor',
            value: value.organismo!,
            stacked: true,
          ),
        if (value.procedimiento != null)
          _DetailField(
            label: 'Procedimiento',
            value: value.procedimiento!,
            stacked: value.procedimiento!.length > 18,
          ),
        if (value.expediente != null) _DetailField(label: 'Nº Expediente', value: value.expediente!),
        const _SectionTitle('Estado notificación'),
        if (value.fechaPuestaDisposicion != null) _DetailField(label: 'Fecha de puesta a disposición', value: _formatDate(context, value.fechaPuestaDisposicion!)),
        if (_showsExpiration(value.estado) && value.fechaExpiracion != null)
          _DetailField(
            label: 'Fecha de expiración',
            value: _formatDate(context, value.fechaExpiracion!),
          )
        else if (!_showsExpiration(value.estado) && value.fechaLectura != null)
          _DetailField(
            label: 'Fecha de lectura',
            value: _formatDate(context, value.fechaLectura!),
          ),
        if (!_isPending(value.estado) && value.documentos.isNotEmpty) ...[
          const _SectionTitle('Documentos'),
          ...value.documentos.map((final document) => _DocumentCard(document: document)),
        ],
      ],
    ),
  );
}

class _PendingActionBar extends StatelessWidget {
  const _PendingActionBar({required this.accepting, required this.onAccept});

  final bool accepting;
  final VoidCallback onAccept;

  @override
  Widget build(final BuildContext context) => SafeArea(
    top: false,
    child: Container(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.space16,
        AppDimensions.space16,
        AppDimensions.space16,
        AppDimensions.space24,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.borderNeutralLight)),
        boxShadow: AppShadows.low,
      ),
      child: AppButton(
        label: 'Aceptar notificación',
        onPressed: accepting ? null : onAccept,
        isLoading: accepting,
        isExpanded: true,
        leadingIcon: AppIcons.check,
      ),
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;
  @override
  Widget build(final BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(AppDimensions.space4, AppDimensions.space12, AppDimensions.space4, AppDimensions.space8),
    child: Text(text, style: AppTypography.h3.copyWith(color: AppColors.textBase)),
  );
}

class _DetailField extends StatelessWidget {
  const _DetailField({required this.label, required this.value, this.stacked = false});
  final String label;
  final String value;
  final bool stacked;

  @override
  Widget build(final BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppDimensions.space8),
    child: stacked
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label(),
              const SizedBox(height: AppDimensions.space8),
              Text(value, style: AppTypography.bodyRegular.copyWith(color: AppColors.primary)),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: _label()),
              const SizedBox(width: AppDimensions.space8),
              Expanded(
                flex: 2,
                child: Text(
                  value,
                  textAlign: TextAlign.end,
                  style: AppTypography.bodyRegular.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
  );

  Widget _label() => Text(
    label.toUpperCase(),
    style: AppTypography.captionUppercase.copyWith(color: AppColors.primary),
  );
}

class _DocumentCard extends StatelessWidget {
  const _DocumentCard({required this.document});
  final NotificacionDocumento document;
  @override
  Widget build(final BuildContext context) => Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: AppDimensions.space8),
    padding: const EdgeInsets.all(AppDimensions.space16),
    decoration: const BoxDecoration(
      color: AppColors.surface,
      border: Border(
        left: BorderSide(color: AppColors.borderBlueMutedLight, width: 4),
        top: BorderSide(color: AppColors.borderBlueMutedLight),
        right: BorderSide(color: AppColors.borderBlueMutedLight),
        bottom: BorderSide(color: AppColors.borderBlueMutedLight),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: AppDimensions.space4),
              child: AppIcon(AppIcons.draft, color: AppColors.primary),
            ),
            const SizedBox(width: AppDimensions.space8),
            Expanded(
              child: Text(
                document.nombre,
                style: AppTypography.bodyBold.copyWith(
                  color: AppColors.primary,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        if (document.tamanoBytes != null) ...[
          const SizedBox(height: AppDimensions.space12),
          Text(
            _formatSize(document.tamanoBytes!),
            style: AppTypography.smallRegular.copyWith(color: AppColors.primary),
          ),
        ],
      ],
    ),
  );
}

AppTagStatus _tagStatus(final String estado) => switch (estado.toLowerCase()) {
  'aceptada' => AppTagStatus.success,
  'pendiente' => AppTagStatus.warning,
  'rechazada' => AppTagStatus.error,
  _ => AppTagStatus.infoInactive,
};
String _statusLabel(final String estado) => estado.isEmpty ? 'Expirada' : '${estado[0].toUpperCase()}${estado.substring(1).toLowerCase()}';
bool _showsExpiration(final String estado) => const {'pendiente', 'expirada'}.contains(estado.toLowerCase());
bool _isPending(final String estado) => estado.toLowerCase() == 'pendiente';
String _formatDate(final BuildContext context, final DateTime date) => DateFormat('d MMM yyyy', Localizations.localeOf(context).languageCode).format(date);
String _formatSize(final int bytes) => bytes >= 1048576 ? '${(bytes / 1048576).toStringAsFixed(1)} MB' : '${(bytes / 1024).ceil()} KB';
