import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/ui_states/error_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/ui_states/loading_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/files/file_save.dart';
import 'package:jccm_espacio_ciudadano/core/logger/logger.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion_detalle.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion_estado.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/providers/gestion_notificaciones_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Detalle de notificación — Figma node 44641:24980 (expirada).
class GestionNotificacionDetallePage extends ConsumerStatefulWidget {
  const GestionNotificacionDetallePage({
    required this.notificacionId,
    required this.resumen,
    super.key,
  });

  final int notificacionId;

  /// Elemento del listado desde el que se abrió el detalle, o `null` si no se
  /// conocía (deep link, restauración de estado).
  ///
  /// Lo consume el repositorio como respaldo de lo que el detalle no informe
  /// —estado, procedimiento, fecha de expiración, organismo, sistema de
  /// origen—, porque el listado está tipado por contrato
  /// (`NotificacionIndexaDto`) y la respuesta del detalle no.
  final Notificacion? resumen;

  @override
  ConsumerState<GestionNotificacionDetallePage> createState() => _GestionNotificacionDetallePageState();
}

class _GestionNotificacionDetallePageState extends ConsumerState<GestionNotificacionDetallePage> {
  bool _accepting = false;

  /// Orden del documento que se está descargando, o `null` si ninguno: una
  /// descarga a la vez, para no encadenar dos selectores nativos.
  int? _downloadingOrden;

  /// Si ya se ha comparecido en esta pantalla. Manda sobre el respaldo del
  /// resumen y sobre el mensaje de error de la relectura.
  bool _accepted = false;

  /// Argumentos del detalle. Tras comparecer, el respaldo del resumen no puede
  /// seguir diciendo "pendiente": si el detalle recargado no informa estado, el
  /// repositorio aplicaría ese respaldo y la CTA resucitaría sobre una
  /// notificación ya aceptada.
  NotificacionDetalleArgs get _args {
    final resumen = widget.resumen;
    return (
      id: widget.notificacionId,
      resumen: _accepted ? resumen?.withEstado(NotificacionEstado.aceptada) : resumen,
    );
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final args = _args;
    final detail = ref.watch(gestionNotificacionDetalleProvider(args));
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppNavBar(
        type: AppNavBarType.detail,
        title: l10n.notificationDetailTitle,
        leading: IconButton(
          icon: const AppIcon(AppIcons.arrowBack, size: AppDimensions.iconLarge, color: AppColors.textPrimary),
          onPressed: () => context.canPop() ? context.pop() : context.go(Routes.gestionNotificaciones),
        ),
      ),
      body: SafeArea(
        child: detail.when(
          loading: () => const LoadingStateWidget(),
          error: (final _, final _) => ErrorStateWidget(
            // La comparecencia ya está registrada: si lo que falla es la
            // relectura del detalle, el mensaje no puede sugerir que la
            // aceptación no llegó a producirse.
            message: _accepted ? l10n.gestionNotificacionDetalleAcceptedReloadError : l10n.notificationDetailErrorMessage,
            onRetry: () => ref.invalidate(gestionNotificacionDetalleProvider(args)),
          ),
          data: (final value) => _DetalleContent(
            value: value,
            downloadingOrden: _downloadingOrden,
            onDownload: (final document) => _download(document, value.sistemaOrigen),
          ),
        ),
      ),
      // La comparecencia se decide con el estado del detalle cargado, no con el
      // del resumen: en "Todo" el resumen no trae estado y la acción con
      // efectos jurídicos desaparecía de la pantalla.
      //
      // El respaldo del resumen lo aplica el repositorio (ver `loadNotificacion`),
      // que es quien distingue "el detalle no informa estado" de "informa uno
      // que no sabemos leer". Repetirlo aquí con `?? widget.estado` resucitaba
      // la acción en el segundo caso, y la ofrecía con el detalle en carga o en
      // error.
      bottomNavigationBar: detail.asData?.value.estado == NotificacionEstado.pendiente
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
    final l10n = AppLocalizations.of(context);
    // Comparecer es irreversible y con efectos jurídicos, así que se confirma
    // antes, igual que en la web. El diálogo es modal y no se descarta tocando
    // fuera, de modo que no puede encadenarse con otro.
    final confirmed = await AppAlertDialog.show(
      context,
      title: l10n.gestionNotificacionDetalleConfirmTitle,
      description: l10n.gestionNotificacionDetalleConfirmDescription,
      cancelLabel: l10n.gestionNotificacionDetalleConfirmCancel,
      confirmLabel: l10n.gestionNotificacionDetalleConfirmAccept,
    );
    if (confirmed != true || !mounted) {
      return;
    }
    setState(() => _accepting = true);
    // La CTA solo se ofrece con el detalle cargado y pendiente, así que su
    // valor está disponible ya: se captura ANTES de la transición. Releer el
    // provider después (`.future`) convertía un fallo de esa relectura —el
    // detalle invalidado y caído por un microcorte justo tras comparecer— en
    // «no hemos podido aceptar» sobre una comparecencia YA registrada, y el
    // «inténtalo de nuevo» habría repetido la transición.
    final detail = ref.read(gestionNotificacionDetalleProvider(_args)).asData?.value;
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
            sistemaOrigen: widget.resumen?.sistemaOrigen,
          );

      // A partir de aquí la comparecencia está registrada: nada de lo que
      // sigue puede presentarse como fallo de la aceptación. Con la pantalla
      // desmontada tampoco se toca `ref` (lanzaría sobre un State difunto).
      if (!mounted) {
        return;
      }
      if (detail != null) {
        ref
            .read(gestionNotificacionesOptimisticAcceptedProvider.notifier)
            .add(
              citizenId: citizenId,
              notification: Notificacion(
                id: widget.notificacionId,
                concepto: detail.titulo,
                procedimientoDenominacion: detail.procedimiento ?? '',
                fechaCaducidad: detail.fechaExpiracion,
                procedimientoIdFicha: widget.resumen?.procedimientoIdFicha,
                unidadOrganicaNombre: detail.organismo,
                sistemaOrigen: detail.sistemaOrigen ?? widget.resumen?.sistemaOrigen,
                estado: NotificacionEstado.aceptada,
              ),
            );
      }

      ref
        ..invalidate(gestionNotificacionesProvider(null))
        ..invalidate(gestionNotificacionesProvider(NotificacionEstado.pendiente))
        ..invalidate(gestionNotificacionesProvider(NotificacionEstado.aceptada));
      AppAlertSnackbar.show(
        context,
        message: l10n.notificationDetailDecisionAcceptedToast,
        severity: AppAlertSeverity.success,
      );
      // Como en la web, no se vuelve al listado: la pantalla se queda y
      // repinta el detalle ya aceptado, con su etiqueta y sus documentos —que
      // es lo que la comparecencia desbloquea—. El respaldo del resumen pasa a
      // "aceptada" (ver `_args`) y el invalidate fuerza la relectura aunque los
      // args no hubieran cambiado (resumen ya desactualizado a "aceptada" con
      // el detalle todavía en pendiente).
      setState(() => _accepted = true);
      ref.invalidate(gestionNotificacionDetalleProvider(_args));
    } on Object {
      if (!mounted) {
        return;
      }
      AppAlertSnackbar.show(
        context,
        message: l10n.gestionNotificacionDetalleAcceptError,
        severity: AppAlertSeverity.error,
      );
    } finally {
      if (mounted) {
        setState(() => _accepting = false);
      }
    }
  }

  /// Descarga un documento de la notificación y lo guarda donde elija la
  /// persona. El backend solo identifica el documento por su `orden`
  /// (`GET .../notificaciones/{id}/documentos/{orden}`).
  Future<void> _download(final NotificacionDocumento document, final String? sistemaOrigen) async {
    if (_downloadingOrden != null) {
      return;
    }
    final l10n = AppLocalizations.of(context);
    setState(() => _downloadingOrden = document.orden);
    try {
      final citizenId = ref.read(gestionNotificacionesTransitionCitizenIdProvider);
      if (citizenId.isEmpty) {
        throw StateError('No hay ciudadano identificado.');
      }
      final bytes = await ref
          .read(gestionNotificacionesRepositoryProvider)
          .downloadDocumento(
            citizenId: citizenId,
            notificacionId: widget.notificacionId,
            orden: document.orden,
            sistemaOrigen: sistemaOrigen ?? widget.resumen?.sistemaOrigen,
          );
      if (!mounted) {
        return;
      }
      final ruta = await saveBytesWithPicker(
        bytes: bytes,
        fileName: _documentFileName(document),
        dialogTitle: l10n.documentDownload,
      );
      if (!mounted || ruta == null) {
        // `null` = selector cancelado: la persona ya sabe lo que ha hecho.
        return;
      }
      AppAlertSnackbar.show(context, message: l10n.gestionNotificacionDetalleDocumentoDescargado, severity: AppAlertSeverity.success);
    } on Object catch (error, stackTrace) {
      // El nombre del documento es dato personal: a la traza solo van el id de
      // la notificación y el orden.
      logger.e('Error al descargar el documento ${document.orden} de la notificación ${widget.notificacionId}', error: error, stackTrace: stackTrace);
      if (!mounted) {
        return;
      }
      AppAlertSnackbar.show(context, message: l10n.gestionNotificacionDetalleDocumentoDescargaError, severity: AppAlertSeverity.error);
    } finally {
      if (mounted) {
        setState(() => _downloadingOrden = null);
      }
    }
  }
}

/// Nombre con el que se propone guardar el documento.
///
/// El contrato no informa ni tipo MIME ni extensión, y los documentos de
/// Notifica son PDF: si el nombre no trae una extensión reconocible se le
/// añade `.pdf`. Se limpian los separadores de ruta, que romperían el guardado.
String _documentFileName(final NotificacionDocumento document) {
  final limpio = document.nombre.trim().replaceAll(RegExp(r'[/\\]'), '-');
  if (limpio.isEmpty) {
    return 'Documento_${document.orden}.pdf';
  }
  final punto = limpio.lastIndexOf('.');
  final tieneExtension = punto > 0 && punto < limpio.length - 1 && RegExp(r'^[A-Za-z0-9]{1,5}$').hasMatch(limpio.substring(punto + 1));
  return tieneExtension ? limpio : '$limpio.pdf';
}

class _DetalleContent extends StatelessWidget {
  const _DetalleContent({required this.value, required this.onDownload, this.downloadingOrden});
  final NotificacionDetalle value;
  final ValueChanged<NotificacionDocumento> onDownload;
  final int? downloadingOrden;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SingleChildScrollView(
      padding: appPagePadding(context, top: AppDimensions.space8, bottom: AppDimensions.space24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sin estado conocido no se etiqueta la notificación: antes se pintaba
          // "Expirada" por defecto, justo lo contrario de lo que le pasa a una
          // notificación pendiente.
          if (value.estado case final estado?) ...[
            AppTag(status: _tagStatus(estado), label: _statusLabel(l10n, estado)),
            const SizedBox(height: AppDimensions.space8),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space4, vertical: AppDimensions.space8),
            child: Text(value.titulo, style: AppTypography.h2.copyWith(color: AppColors.textBase)),
          ),
          _SectionTitle(_isPending(value.estado) ? l10n.gestionNotificacionDetalleDatosExpedienteTitle : l10n.gestionRegistrosDatosRegistroTitle),
          if (value.organismo != null)
            _DetailField(
              label: l10n.gestionNotificacionDetalleOrganismoEmisorLabel,
              value: value.organismo!,
              stacked: true,
            ),
          if (value.procedimiento != null)
            _DetailField(
              label: l10n.gestionNotificacionesProcedimientoLabel,
              value: value.procedimiento!,
              stacked: value.procedimiento!.length > 18,
            ),
          if (value.expediente != null) _DetailField(label: l10n.gestionNotificacionDetalleNumExpedienteLabel, value: value.expediente!),
          _SectionTitle(l10n.gestionNotificacionDetalleEstadoTitle),
          if (value.fechaPuestaDisposicion != null) _DetailField(label: l10n.gestionNotificacionDetalleFechaPuestaDisposicionLabel, value: _formatDate(context, value.fechaPuestaDisposicion!)),
          if (_showsExpiration(value.estado) && value.fechaExpiracion != null)
            _DetailField(
              label: l10n.gestionNotificacionesFechaExpiracionLabel,
              value: _formatDate(context, value.fechaExpiracion!),
            )
          else if (!_showsExpiration(value.estado) && value.fechaLectura != null)
            _DetailField(
              label: l10n.gestionNotificacionDetalleFechaLecturaLabel,
              value: _formatDate(context, value.fechaLectura!),
            ),
          if (!_isPending(value.estado) && value.documentos.isNotEmpty) ...[
            _SectionTitle(l10n.gestionNotificacionDetalleDocumentosTitle),
            ...value.documentos.map(
              (final document) => _DocumentCard(
                document: document,
                downloading: downloadingOrden == document.orden,
                onTap: downloadingOrden == null ? () => onDownload(document) : null,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PendingActionBar extends StatelessWidget {
  const _PendingActionBar({required this.accepting, required this.onAccept});

  final bool accepting;
  final VoidCallback onAccept;

  @override
  Widget build(final BuildContext context) => SafeArea(
    top: false,
    child: Container(
      padding: appPagePadding(context, top: AppDimensions.space16, bottom: AppDimensions.space24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.borderNeutralLight)),
        boxShadow: AppShadows.low,
      ),
      child: AppButton(
        label: AppLocalizations.of(context).gestionNotificacionDetalleAceptarButton,
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
  const _DocumentCard({required this.document, required this.downloading, this.onTap});
  final NotificacionDocumento document;
  final bool downloading;

  /// `null` mientras otra descarga está en curso: la tarjeta se sigue viendo
  /// igual, pero no admite pulsación.
  final VoidCallback? onTap;

  @override
  Widget build(final BuildContext context) => Semantics(
    button: true,
    child: InkWell(
      onTap: onTap,
      child: Container(
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                downloading
                    ? const SizedBox(
                        width: AppDimensions.iconMedium,
                        height: AppDimensions.iconMedium,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                      )
                    : const AppIcon(AppIcons.draft, color: AppColors.textPrimary),
                const SizedBox(width: AppDimensions.space8),
                Expanded(
                  child: Text(
                    _documentFileName(document),
                    style: AppTypography.leadingBold.copyWith(
                      color: AppColors.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.space16),
            Text(
              [
                _documentFileName(document).split('.').last.toUpperCase(),
                if (document.tamanoBytes != null) _formatSize(document.tamanoBytes!),
              ].join(', '),
              style: AppTypography.bodyRegular.copyWith(color: AppColors.primary),
            ),
          ],
        ),
      ),
    ),
  );
}

AppTagStatus _tagStatus(final NotificacionEstado estado) => switch (estado) {
  NotificacionEstado.aceptada => AppTagStatus.success,
  NotificacionEstado.pendiente => AppTagStatus.warning,
  NotificacionEstado.rechazada => AppTagStatus.error,
  NotificacionEstado.expirada => AppTagStatus.infoInactive,
};
String _statusLabel(final AppLocalizations l10n, final NotificacionEstado estado) => switch (estado) {
  NotificacionEstado.pendiente => l10n.gestionNotificacionesTagPendiente,
  NotificacionEstado.aceptada => l10n.gestionNotificacionesTagAceptada,
  NotificacionEstado.rechazada => l10n.gestionNotificacionesTagRechazada,
  NotificacionEstado.expirada => l10n.gestionNotificacionesTagExpirada,
};
bool _showsExpiration(final NotificacionEstado? estado) => estado == NotificacionEstado.pendiente || estado == NotificacionEstado.expirada;
bool _isPending(final NotificacionEstado? estado) => estado == NotificacionEstado.pendiente;
String _formatDate(final BuildContext context, final DateTime date) => DateFormat('d MMM yyyy', Localizations.localeOf(context).languageCode).format(date);
String _formatSize(final int bytes) => bytes >= 1048576 ? '${(bytes / 1048576).toStringAsFixed(1)} MB' : '${(bytes / 1024).ceil()} KB';
