import 'dart:async' show unawaited;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/ui_states/error_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/logger/logger.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/authentication_level.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/authentication_level_required.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/authentication_level_elevation_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/citizen_endpoint_ids_provider.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/hospital_appointment.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/my_data_authorization_required.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/my_data_health_cip_missing.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/1_domain/repositories/my_data_health_repository.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_authorization_provider.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_health_provider.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_appointment_date_filter.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_appointment_sections.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_authorization_contextual_helper.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_service_unavailable.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Citas hospitalarias del SESCAM.
///
/// Requisito funcional de JCCM (septiembre de 2026), apartados 2.1, 2.2 y 6.3:
/// enlace propio desde Mis datos → Salud, dos pestañas con «Citas pendientes»
/// por defecto, y los siete campos por cita. El CIP se muestra en el menú de
/// Salud, no aquí (Figma `45045:57735`).
///
/// Es de **solo consulta**: no se contempla solicitar, modificar ni anular.
class MyDataHospitalAppointmentsPage extends ConsumerStatefulWidget {
  const MyDataHospitalAppointmentsPage({super.key});

  @override
  ConsumerState<MyDataHospitalAppointmentsPage> createState() => _MyDataHospitalAppointmentsPageState();
}

class _MyDataHospitalAppointmentsPageState extends ConsumerState<MyDataHospitalAppointmentsPage> {
  HealthAppointmentFilter _filter = HealthAppointmentFilter.pending;
  AppListFilters _filters = const AppListFilters();

  /// Filtros cuyo provider ya se ha retenido, para no suscribirse dos veces.
  final Set<HealthAppointmentFilter> _retained = <HealthAppointmentFilter>{};

  @override
  void initState() {
    super.initState();
    _retain(HealthAppointmentFilter.pending);
  }

  /// Mantiene vivo el listado de un filtro mientras la pantalla esté montada.
  ///
  /// `myDataHospitalAppointmentsProvider` es `autoDispose`: sin esto, cambiar de
  /// pestaña y volver destruiría el listado anterior y **volvería a pedirlo al
  /// SESCAM**, que es justo lo que el apartado 2.2 prohíbe («alternar sin
  /// recargar toda la pantalla»). Con la retención, la primera visita a cada
  /// pestaña cuesta una petición y las siguientes ninguna.
  ///
  /// Se retiene de forma perezosa —solo la pestaña que se abre— para no pedir
  /// las pasadas a quien únicamente mira las pendientes. Al salir de la
  /// pantalla todo se libera: son datos de salud y no se cachean entre
  /// sesiones.
  void _retain(final HealthAppointmentFilter filter) {
    if (!_retained.add(filter)) {
      return;
    }
    ref.listenManual(myDataHospitalAppointmentsProvider(filter), (final _, final _) {});
  }

  void _selectFilter(final int index) {
    final filter = index == 0 ? HealthAppointmentFilter.pending : HealthAppointmentFilter.past;
    if (filter == _filter) {
      return;
    }
    _retain(filter);
    setState(() => _filter = filter);
  }

  Future<void> _showFilters() async {
    final result = await showMyDataAppointmentDateFilter(
      context: context,
      sheetTitle: AppLocalizations.of(context).myDataHealthFilterHospitalTitle,
      initialFilters: _filters,
    );
    if (result != null && mounted) {
      setState(() => _filters = result);
    }
  }

  Future<void> _showInfoSheet() async {
    final l10n = AppLocalizations.of(context);
    await AppInfoSheet.show(
      context: context,
      title: l10n.myDataHealthHospitalNavTitle,
      bodyText: l10n.myDataHealthHospitalLinkDescription,
      footerText: l10n.myDataHealthHospitalContactHint,
    );
  }

  /// Lleva a Preferencias y, al volver, recupera la consulta.
  ///
  /// El requisito pide que tras aceptar las cláusulas se pueda retomar la
  /// consulta con el flujo habitual de la app, así que a la vuelta se invalidan
  /// la comprobación de autorización y los listados ya retenidos. Es el
  /// mismo patrón que `MyDataAuthorizationRequiredState.onAuthorized`.
  Future<void> _openConsentSettings() async {
    await context.push<void>(
      Uri(
        path: Routes.consent,
        queryParameters: const {
          'mode': 'preferences',
          'returnTo': Routes.myDataHealthHospitalAppointments,
        },
      ).toString(),
    );
    if (!mounted) {
      return;
    }
    ref.invalidate(jccmDataAuthorizationProvider);
    for (final filter in _retained) {
      ref.invalidate(myDataHospitalAppointmentsProvider(filter));
    }
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // La comprobación de autorización se observa **aquí**, por encima del área
    // que conmuta, para que cambiar de pestaña no la revalide.
    final authorizationAsync = ref.watch(jccmDataAuthorizationProvider);

    return AppDetailScaffold(
      title: l10n.myDataHealthHospitalAppointmentsTitle,
      onBack: () => context.go(Routes.myDataHealth),
      onInfo: _showInfoSheet,
      actions: [
        myDataAppointmentDateFilterAction(context: context, filters: _filters, onPressed: _showFilters),
      ],
      body: SingleChildScrollView(
        padding: appPagePadding(context, top: AppDimensions.space16, bottom: AppDimensions.space64),
        child: authorizationAsync.when(
          loading: () => const Center(child: Padding(padding: EdgeInsets.all(AppDimensions.space32), child: AppLoadingIndicator())),
          // Un fallo de la comprobación no es «no estás autorizado»: se ofrece
          // reintentar en vez de acusar al ciudadano de no haber autorizado.
          error: (final _, final _) => ErrorStateWidget(
            message: l10n.authorizationCheckFailedMessage,
            onRetry: () => ref.invalidate(jccmDataAuthorizationProvider),
          ),
          data: (final hasAuthorization) {
            if (!hasAuthorization) {
              return MyDataAuthorizationContextualHelper(onOpenSettings: _openConsentSettings);
            }
            // La entradilla y el aviso de contacto **no van aquí**: viven en la
            // (i), como en atención primaria. El §2.1 los cita como textos de
            // referencia de la web, pero ese mismo apartado pide adaptar la
            // composición a los patrones de la APP en vez de reproducirla.
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSegmentedControl(
                  segments: [l10n.myDataHealthHospitalPendingTab, l10n.myDataHealthHospitalPastTab],
                  selectedIndex: _filter == HealthAppointmentFilter.pending ? 0 : 1,
                  onSelected: _selectFilter,
                  semanticLabel: l10n.myDataHealthHospitalAppointmentsTitle,
                ),
                const SizedBox(height: AppDimensions.space16),
                _HospitalAppointmentsList(filter: _filter, filters: _filters, onOpenConsentSettings: _openConsentSettings),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Listado del filtro activo. Es la única parte de la pantalla que conmuta.
class _HospitalAppointmentsList extends ConsumerWidget {
  const _HospitalAppointmentsList({required this.filter, required this.filters, required this.onOpenConsentSettings});

  final HealthAppointmentFilter filter;
  final AppListFilters filters;
  final VoidCallback onOpenConsentSettings;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return ref.watch(myDataHospitalAppointmentsProvider(filter)).when(
      loading: () => const Center(child: Padding(padding: EdgeInsets.all(AppDimensions.space32), child: AppLoadingIndicator())),
      error: (final error, final _) => switch (error) {
        MyDataAuthorizationRequired() => MyDataAuthorizationContextualHelper(onOpenSettings: onOpenConsentSettings),
        // Apartados 4 y 5: nivel insuficiente se explica, se distingue de un
        // fallo de servicio, y se ofrece elevarlo.
        AuthenticationLevelRequired(current: final reading, minimum: final minimum) => _LevelBlockedState(
          reading: reading,
          minimum: minimum,
        ),
        MyDataHealthCipMissing() => AppAlertContextual(
          message: l10n.agendaHealthCipMissing,
          size: AppAlertContextualSize.small,
          announce: true,
        ),
        // Reintenta **solo el filtro activo**: un fallo en pasadas no debe
        // obligar a recargar las pendientes que ya están en pantalla.
        _ => MyDataServiceUnavailable(
          message: l10n.myDataHealthHospitalAppointmentsServiceUnavailableMessage,
          actionLabel: l10n.myDataServiceUnavailableUpdate,
          onRetry: () => ref.invalidate(myDataHospitalAppointmentsProvider(filter)),
          scrollable: false,
        ),
      },
      // Mensaje propio de cada pestaña: el apartado 2.2 pide no dejar la
      // pantalla vacía sin explicación, y «no tienes pendientes» no dice lo
      // mismo que «no tienes pasadas».
      data: (final appointments) => MyDataAppointmentSections(
        entries: _entries(appointments, filters),
        emptyMessage: filter == HealthAppointmentFilter.pending ? l10n.myDataHealthHospitalPendingEmpty : l10n.myDataHealthHospitalPastEmpty,
      ),
    );
  }
}

List<MyDataAppointmentEntry> _entries(final List<HospitalAppointment> appointments, final AppListFilters filters) {
  final range = filters.range(myDataAppointmentDateFilterFieldId);
  return [
    for (final appointment in appointments)
      if (appFilterDateInRange(appointment.dateTime, range))
        (
          dateTime: appointment.dateTime,
          // Una tarjeta por cita, sin indexar por fecha en ningún punto del
          // camino: el apartado 6.3 exige que varias citas del mismo día
          // —incluso de la misma hora— se vean todas.
          card: HospitalAppointmentCard(
            key: ValueKey(appointment.id ?? '${appointment.dateTime}|${appointment.service}|${appointment.provision}|${appointment.room}'),
            appointment: appointment,
          ),
        ),
  ];
}

/// Bloqueo por nivel de seguridad.
///
/// El aviso es un **diálogo bloqueante** ([AppIdentityVerificationDialog],
/// Figma `Alerts/Dialog`) y no un bloque en línea: detrás no hay nada que
/// consultar hasta que se eleve, y sus dos botones son dicotómicos — volver a
/// Salud o ir a Cl@ve.
///
/// **Cl@ve se intenta una sola vez por decisión del ciudadano.** El desenlace de
/// la elevación es una señal de un solo uso que consume el bloqueo que esté
/// montado — también uno recién montado: al volver de Cl@ve la pantalla pasa
/// por `loading` y este widget se crea de nuevo, así que no basta con escuchar
/// cambios. Por desenlace:
///
/// - **cancelado** (cerró Cl@ve con la X o volvió atrás) → a Salud. Relanzar
///   Cl@ve aquí era el bucle: cerrar, reabrir, cerrar…
/// - **insuficiente** o **fallido** → el diálogo con el motivo, **siempre**,
///   aunque se marcara «No volver a mostrar»: es otro mensaje, y saltárselo
///   relanzaría Cl@ve sin que el ciudadano lo pida.
///
/// Quien marcó «No volver a mostrar» —con cualquiera de los dos botones— se
/// salta la explicación en las siguientes entradas y va directo a Cl@ve, una
/// vez: si lo cierra, vuelve a Salud. Omite **la explicación, no el control**:
/// el gate sigue decidiendo.
class _LevelBlockedState extends ConsumerStatefulWidget {
  const _LevelBlockedState({required this.reading, required this.minimum});

  final AuthenticationLevelReading reading;
  final AuthenticationLevel minimum;

  @override
  ConsumerState<_LevelBlockedState> createState() => _LevelBlockedStateState();
}

class _LevelBlockedStateState extends ConsumerState<_LevelBlockedState> {
  bool _isShowing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((final _) => _start());
  }

  /// Al montarse: si hay una elevación en curso, su desenlace llegará por el
  /// `listen`; si ya llegó y nadie lo consumió, se atiende ahora; si no hay
  /// nada pendiente, es una entrada nueva.
  void _start() {
    if (!mounted) {
      return;
    }
    final elevation = ref.read(elevationProvider);
    if (elevation.isElevating) {
      return;
    }
    if (elevation.outcome case final outcome?) {
      _handleOutcome(outcome);
      return;
    }
    unawaited(_open());
  }

  void _handleOutcome(final ElevationOutcome outcome) {
    final l10n = AppLocalizations.of(context);
    ref.read(elevationProvider.notifier).acknowledge();
    switch (outcome) {
      case ElevationOutcome.cancelled:
        context.go(Routes.myDataHealth);
      case ElevationOutcome.stillInsufficient:
        unawaited(_open(message: l10n.myDataHealthLevelStillInsufficientMessage));
      case ElevationOutcome.failed:
        unawaited(_open(message: l10n.myDataHealthLevelElevationFailedMessage));
      // `succeeded` deja de bloquear y la pantalla pinta el listado por
      // derivación, e `identityChanged` cierra sesión: si aun así hay bloqueo
      // montado, es una entrada nueva.
      case ElevationOutcome.succeeded:
      case ElevationOutcome.identityChanged:
        unawaited(_open());
    }
  }

  String? get _suppressionKey {
    final idAgente = ref.read(citizenEndpointIdsProvider).idAgente;
    return idAgente == null || idAgente.isEmpty
        ? null
        : '${StorageKeys.identityVerificationNoticeSuppressedPrefix}$idAgente';
  }

  bool get _isSuppressed {
    final key = _suppressionKey;
    return key != null && (ref.read(appStorageProvider).read<bool>(key) ?? false);
  }

  void _elevate() {
    final notifier = ref.read(elevationProvider.notifier)..acknowledge();
    // El notifier lleva su propia guarda de reentrada y traza sus fallos.
    unawaited(notifier.elevate(minimum: widget.minimum));
  }

  /// [message] es el motivo de un intento anterior; con él el diálogo sale
  /// siempre, aunque el ciudadano pidiera no volver a verlo.
  Future<void> _open({final String? message}) async {
    if (_isShowing || !mounted) {
      return;
    }

    // El diseño da un solo texto para cualquier bloqueo por nivel, así que un
    // literal que no sepamos leer se ve igual que un nivel bajo. La distinción
    // se conserva en la traza: sin ella, un `authNLevel` nuevo de Cerbero sería
    // indistinguible de un ciudadano con Cl@ve PIN.
    if (widget.reading is! KnownAuthenticationLevel) {
      logger.w({'event': 'auth_level_not_readable', 'reading': widget.reading.toString()});
    }

    if (message == null && _isSuppressed) {
      _elevate();
      return;
    }

    _isShowing = true;
    final choice = await AppIdentityVerificationDialog.show(context, message: message);
    _isShowing = false;
    if (!mounted) {
      return;
    }
    // La preferencia se guarda con cualquiera de los dos botones: es sobre el
    // aviso, no sobre la decisión de ir o no a Cl@ve.
    if (choice?.suppressFuture ?? false) {
      final key = _suppressionKey;
      if (key != null) {
        unawaited(ref.read(appStorageProvider).write(key, true));
      }
    }
    // Sin elección es el botón atrás del sistema, que cierra el diálogo: es
    // «Volver», y como tal lleva a Salud. Quedarse dejaba la pantalla vacía y
    // el aviso volvía a salir.
    if (choice == null || !choice.accepted) {
      context.go(Routes.myDataHealth);
      return;
    }
    _elevate();
  }

  @override
  Widget build(final BuildContext context) {
    ref.listen<ElevationState>(elevationProvider, (final previous, final next) {
      final outcome = next.outcome;
      if (outcome == null || outcome == previous?.outcome) {
        return;
      }
      _handleOutcome(outcome);
    });

    // Mientras el diálogo decide, detrás no hay nada que enseñar. Durante la
    // elevación sí se indica que algo está pasando, que es cierto.
    return ref.watch(elevationProvider).isElevating
        ? const Center(
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.space32),
              child: AppLoadingIndicator(),
            ),
          )
        : const SizedBox.shrink();
  }
}

/// Tarjeta de cita hospitalaria.
///
/// Usa el mismo componente del sistema de diseño que las citas de atención
/// primaria, [AppAgendaInfoCard], para que las dos consultas se vean igual. La
/// diferencia es que hospitalaria tiene más campos que huecos en el cuerpo, así
/// que los que no caben van en las filas etiquetadas de `details`.
///
/// Reparto de los siete campos del apartado 6.3:
/// - día de la semana, fecha y hora → raíl de fecha, más la cabecera de mes/año
///   de la sección que la contiene;
/// - servicio → título, el hueco prominente (el papel que en primaria hace la
///   descripción de la cita);
/// - prestación → línea de tipo, en mayúsculas pequeñas;
/// - sala, centro y agenda → filas etiquetadas.
///
/// No se pintan `estadoCita` —la pestaña ya lo comunica—, `agendaCode`, `id`
/// ni el **NHC**: es un dato de salud que no debe salir en pantalla, y no es el
/// CIP.
class HospitalAppointmentCard extends StatelessWidget {
  const HospitalAppointmentCard({required this.appointment, super.key});

  final HospitalAppointment appointment;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final date = appointment.dateTime;
    final formattedTime = '${_two(date.hour)}:${_two(date.minute)}';

    // Se filtran los vacíos en vez de pintar «null» o un guion: los campos
    // opcionales que no vengan simplemente no ocupan fila. `service` y
    // `provision` son obligatorios en la entidad, pero el mapeo los rellena con
    // cadena vacía cuando el backend no los manda, así que se tratan igual.
    final details = <AppAgendaInfoCardDetail>[
      if (_present(appointment.room)) (label: l10n.myDataHealthHospitalFieldRoom, value: appointment.room!),
      if (_present(appointment.center)) (label: l10n.myDataHealthHospitalFieldCenter, value: appointment.center!),
      if (_present(appointment.agendaDescription)) (label: l10n.myDataHealthHospitalFieldAgenda, value: appointment.agendaDescription!),
    ];

    return AppAgendaInfoCard(
      type: AppAgendaInfoCardType.health,
      day: date.day.toString(),
      weekday: l10n.commonWeekdayName(weekdayKey(date.weekday)),
      time: formattedTime,
      title: _present(appointment.service) ? appointment.service : l10n.myDataHealthHospitalAppointmentsTitle,
      channel: _present(appointment.provision) ? appointment.provision : null,
      details: details,
    );
  }
}

bool _present(final String? value) => value != null && value.trim().isNotEmpty;

String _two(final int value) => value.toString().padLeft(2, '0');
