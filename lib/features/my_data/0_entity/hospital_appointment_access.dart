import 'package:jccm_espacio_ciudadano/features/auth/0_entity/authentication_level.dart';

/// Nivel de autenticación mínimo para consultar las citas hospitalarias.
///
/// Lo fija el requisito funcional de JCCM (septiembre de 2026, apartados 4 y 5)
/// por la naturaleza del dato tratado: salud, categoría especial del RGPD.
///
/// Vive en la feature que lo exige, no en `auth`: el umbral es una decisión de
/// negocio de esta consulta, y otra funcionalidad podría pedir otro.
const AuthenticationLevel kHospitalAppointmentsMinimumLevel = AuthenticationLevel.substantial;
