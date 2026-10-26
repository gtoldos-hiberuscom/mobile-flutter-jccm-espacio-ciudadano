import 'package:jccm_espacio_ciudadano/core/demo/demo_session.dart';

/// Datos ficticios de «Mis datos» para la persona del modo demostración.
///
/// Cada fixture replica la forma **real** que devuelve el organismo y que
/// parsea su repositorio —la misma que fijan los tests de
/// `test/features/my_data/`—, no el `required` del swagger: bienestar social y
/// ofertas de empleo viajan dentro de `respuesta.datosespecificos`, educación
/// como `elemento[]`, vehículos como `listavehiculos.vehiculo[]` y catastro con
/// la estructura SVD anidada. Lo que tiene vigencia (títulos, tarjetas,
/// ofertas) se calcula desde `now` para que la demo no caduque sola.
///
/// Nada es real: personas, números de título y expediente, referencias
/// catastrales y matrícula. Las instituciones (SESCAM, UCLM, consejerías) son
/// las reales de Castilla-La Mancha para que las pantallas resulten creíbles.
abstract final class DemoMyDataFixtures {
  const DemoMyDataFixtures._();

  /// Fecha de nacimiento ficticia de la titular; aparece en familia numerosa y
  /// en el reconocimiento de discapacidad.
  static const String holderBirthDate = '12/06/1985';

  // ── Bienestar social ───────────────────────────────────────────────────────

  /// Título de familia numerosa general vigente, con la titular y tres hijos.
  static Map<String, Object?> familiaNumerosa(final DateTime now) => {
    'respuesta': {
      'codestado': '0',
      'mensaje': 'Existe el título de familia numerosa.',
      'datosespecificos': {
        'datos_titulo': {
          'row': [
            {
              'codigo_comunidad_automa': '8',
              'numero_titulo': '45/001234/2023.1',
              'categoria': 'G',
              'titulo_vigente': 'S',
              'fecha_efecto': demoShortDate(DateTime(now.year - 3, now.month, now.day)),
              'fecha_caducidad': demoShortDate(DateTime(now.year + 2, now.month, now.day)),
              'numero_hijos': 3,
            },
          ],
        },
        'beneficiarios': {
          'row': [
            {
              'documentacion': DemoSession.personIdentifier,
              'fecha_nacimiento': holderBirthDate,
              'nombre': DemoSession.givenName,
              'apellido1': DemoSession.firstSurname,
              'apellido2': DemoSession.secondSurname,
              'titular': 'S',
            },
            {'documentacion': null, 'fecha_nacimiento': '03/02/2014', 'nombre': 'Mario', 'apellido1': 'Prueba', 'apellido2': 'Ejemplo', 'titular': 'N'},
            {'documentacion': null, 'fecha_nacimiento': '21/09/2016', 'nombre': 'Sara', 'apellido1': 'Prueba', 'apellido2': 'Ejemplo', 'titular': 'N'},
            {'documentacion': null, 'fecha_nacimiento': '08/05/2020', 'nombre': 'Daniel', 'apellido1': 'Prueba', 'apellido2': 'Ejemplo', 'titular': 'N'},
          ],
        },
      },
    },
  };

  /// Grado de discapacidad reconocido con validez definitiva y movilidad
  /// reducida (la que da derecho a la tarjeta de estacionamiento).
  static const Map<String, Object?> discapacidad = {
    'respuesta': {
      'codestado': '0',
      'mensaje': 'Existe reconocimiento de grado de discapacidad.',
      'datosespecificos': {
        'grado_discapacidad': 42,
        'fecha_efectos': '20/05/2019',
        'validez_definitiva': 'S',
        'numero_expediente': '45/2019/004321',
        'fecha_nacimiento': holderBirthDate,
        'procede_movilidad': 'S',
        'reconocido_concurso_tercera_persona': 'N',
        'real_decreto': '1',
      },
    },
  };

  /// Plaza del programa de termalismo para una estancia próxima. Las fechas
  /// llegan en el formato `dd-MMM-yy` de Oracle, como en el servicio real.
  static Map<String, Object?> termalismo(final DateTime now) {
    final entrada = DateTime(now.year, now.month, now.day + 40);
    return {
      'respuesta': {
        'codestado': '0',
        'datosespecificos': {
          'Balneario': 'BALNEARIO AGUAS DE EJEMPLO',
          'FechaEntrada': demoOracleDate(entrada),
          'FechaSalida': demoOracleDate(DateTime(entrada.year, entrada.month, entrada.day + 9)),
        },
      },
    };
  }

  /// Dependencia reconocida en grado I con una prestación económica.
  static const Map<String, Object?> atencionDependencia = {
    'respuesta': {
      'codestado': '0',
      'datosespecificos': {
        'FechaSolicitud': '10/01/2023',
        'FechaResolucion': '22/06/2023',
        'GradoReconocido': '1',
        'Baremo': '38',
        'prestaciones': [
          {
            'Prestacion': 'Prestación económica para cuidados en el entorno familiar',
            'TipoPrestacion': 'Prestación económica',
            'FechaResolucion': '22/06/2023',
            'FechaEfecto': '01/07/2023',
            'Importe': '268,79 €',
          },
        ],
      },
    },
  };

  /// Fin de vigencia de la tarjeta de estacionamiento. Caduca pronto a
  /// propósito, para que la agenda general tenga un aviso de caducidad dentro
  /// de su horizonte y coincida con lo que muestra bienestar social.
  static DateTime parkingCardValidUntil(final DateTime now) => DateTime(now.year, now.month, now.day + 45);

  /// Tarjeta de estacionamiento para personas con movilidad reducida.
  static Map<String, Object?> tarjetaEstacionamiento(final DateTime now) {
    final hasta = parkingCardValidUntil(now);
    return {
      'respuesta': {
        'codestado': '0',
        'datosespecificos': {
          'CodigoTarjeta': '45-2021-000777',
          'Modalidad': 'Titular',
          'FechaVigenciaDesde': demoShortDate(DateTime(hasta.year - 5, hasta.month, hasta.day)),
          'FechaVigenciaHasta': demoShortDate(hasta),
        },
      },
    };
  }

  // ── Educación ──────────────────────────────────────────────────────────────

  /// Un título universitario (`DTEDUTUORES`).
  static const Map<String, Object?> titulosUniversitarios = {
    'resul': '0',
    'mensaje': 'TRAMITADA',
    'elemento': [
      {
        'univers': 'Universidad de Castilla-La Mancha',
        'centro': 'Escuela Universitaria de Enfermería y Fisioterapia de Toledo',
        'nomcar': 'Diplomada en Enfermería',
        'tipotit': 'Diplomado/a',
        'fecfin': '20/06/2008',
        'numtit': '2008045001',
        'fecexpedicion': '14/11/2009',
      },
    ],
  };

  /// Dos títulos no universitarios (`DTEDUTNURES`).
  static const Map<String, Object?> titulosNoUniversitarios = {
    'resul': '0',
    'mensaje': 'TRAMITADA',
    'elemento': [
      {
        'titulacion': 'Nivel Intermedio B1 del idioma inglés',
        'centro': 'Escuela Oficial de Idiomas de Toledo',
        'numlib': '12',
        'nordlib': '345',
        'numfol': '078',
        'provtit': 'Toledo',
        'fecfin': '15/06/2012',
        'fecexp': '03/10/2012',
      },
      {
        'titulacion': 'Bachiller (Ciencias de la Naturaleza y de la Salud)',
        'centro': 'IES Castillo de Ejemplo',
        'numlib': '4',
        'nordlib': '112',
        'numfol': '031',
        'provtit': 'Toledo',
        'fecfin': '20/06/2003',
        'fecexp': '17/11/2003',
      },
    ],
  };

  // ── Empleo ─────────────────────────────────────────────────────────────────

  /// Demanda de empleo activa (`DTSEPESVDIDEFARES`), con la fecha de la última
  /// inscripción ininterrumpida en `yyyyMMdd`.
  static const Map<String, Object?> demandanteEmpleo = {
    'resul': '0',
    'mensaje': 'Tramitada',
    'idpeticion': 'demo-0000000001',
    'inscrito': 'S',
    'ultimainscrip': '20240315',
  };

  /// Dos ofertas inscritas: una en selección y otra con fecha de cierre.
  static Map<String, Object?> ofertasEmpleo(final DateTime now) => {
    'respuesta': {
      'codestado': '0',
      'datosespecificos': [
        {
          'NombreOfertaEmpleo': 'ENFERMERO/A - CENTRO RESIDENCIAL',
          'EstadoCandidatura': 'Inscrita',
          'FechaPublicacion': demoIsoDate(DateTime(now.year, now.month, now.day - 20)),
          'FechaInscripcion': demoIsoDate(DateTime(now.year, now.month, now.day - 15)),
          'FechaFinalizacionProceso': '',
        },
        {
          'NombreOfertaEmpleo': 'AUXILIAR ADMINISTRATIVO/A',
          'EstadoCandidatura': 'Inscrita',
          'FechaPublicacion': demoIsoDate(DateTime(now.year, now.month, now.day - 40)),
          'FechaInscripcion': demoIsoDate(DateTime(now.year, now.month, now.day - 32)),
          'FechaFinalizacionProceso': demoIsoDate(DateTime(now.year, now.month, now.day + 30)),
        },
      ],
    },
  };

  // ── Vivienda ───────────────────────────────────────────────────────────────

  /// Domicilio de empadronamiento (`DTINECDRFRES`) en sus componentes INE; el
  /// repositorio compone la dirección a partir de ellos.
  static const Map<String, Object?> datosResidencia = {
    'tipvia': 'CALLE',
    'nomvia': 'DE LA DEMOSTRACIÓN',
    'numres': '12',
    'plares': '02',
    'pueres': 'B',
    'codpos': '45003',
    'denmun': 'TOLEDO',
    'denpro': 'TOLEDO',
    'denencol': '',
    'denensin': 'TOLEDO',
    'dennuc': 'TOLEDO',
    'descvar': 'Alta por cambio de residencia',
    'fecvar': '14/09/2021',
  };

  /// Dos inmuebles en la estructura SVD de Catastro: la vivienda habitual
  /// (urbana, en Toledo) y una parcela rústica compartida en Cuenca.
  ///
  /// Sin `finca.infgraf` a propósito: la cartografía enlazaría a la sede
  /// electrónica del Catastro con una referencia que no existe, y la pantalla
  /// de detalle oculta el botón cuando no hay URL.
  static const Map<String, Object?> datosCatastrales = {
    'atributos': {
      'numElementos': 2,
      'estado': {'literalError': 'Tramitada'},
    },
    'transmisiones': {
      'transmisionDatos': {
        'datosEspecificos': {
          'listaBienesInmuebles': {
            'datosInmueble': [
              {
                'bienInmuebleUrbano': {
                  'idine': {
                    'cn': 'UR',
                    'rc': {'pc1': '0000001', 'pc2': 'VK1111S', 'car': '0002', 'cc1': 'D', 'cc2': 'M'},
                  },
                  'ldt': 'CL DE LA DEMOSTRACION 12 Pl:02 Pt:B 45003 TOLEDO (TOLEDO)',
                  'debi': {'vcat': '68420,15', 'vcs': '21350,40', 'vcc': '47069,75', 'luso': 'RESIDENCIAL'},
                },
                'listaTitulares': {
                  'titular': [
                    {
                      'idpOut': {'nom': 'EJEMPLO DEMO LUCIA'},
                      'lder': '100,00% de Propiedad',
                    },
                  ],
                },
              },
              {
                'bienInmuebleRustico': {
                  'idine': {
                    'cn': 'RU',
                    'rc': {'pc1': '16079A0', 'pc2': '1700123', 'car': '0000', 'cc1': 'F', 'cc2': 'X'},
                  },
                  'ldt': 'Polígono 17 Parcela 123. PARAJE DE EJEMPLO. 16001 CUENCA (CUENCA)',
                  'debi': {'vcat': '1245,60', 'vcs': '1245,60', 'vcc': '0,00', 'luso': 'AGRARIO'},
                },
                'listaTitulares': {
                  'titular': [
                    {
                      'idpOut': {'nom': 'EJEMPLO DEMO LUCIA'},
                      'lder': '50,00% de Propiedad',
                    },
                    {
                      'idpOut': {'nom': 'EJEMPLO DEMO ANDRES'},
                      'lder': '50,00% de Propiedad',
                    },
                  ],
                },
              },
            ],
          },
        },
      },
    },
  };

  // ── Vehículos ──────────────────────────────────────────────────────────────

  /// Un vehículo (`DTDGTLISTADOVEHICULOSRES`). La matrícula lleva una vocal a
  /// propósito: ninguna matrícula española real la tiene.
  static const Map<String, Object?> vehiculos = {
    'listavehiculos': {
      'vehiculo': [
        {'matricula': '1234DEM'},
      ],
    },
  };
}

// ── Formatos de fecha de los organismos ──────────────────────────────────────
//
// Sin `intl`: son cuatro formatos fijos y así las fixtures no dependen de la
// inicialización de locales en los tests.

String _two(final int value) => value.toString().padLeft(2, '0');

/// `dd/MM/yyyy`, la forma de las fechas de intermediación y de SESCAM.
String demoShortDate(final DateTime date) => '${_two(date.day)}/${_two(date.month)}/${date.year}';

/// `HH:mm`, la hora de las citas de SESCAM.
String demoTime(final DateTime date) => '${_two(date.hour)}:${_two(date.minute)}';

/// `yyyy-MM-dd`, la forma de las fechas de las ofertas de empleo.
String demoIsoDate(final DateTime date) => '${date.year}-${_two(date.month)}-${_two(date.day)}';

/// `yyyy-MM-ddTHH:mm:ss` en hora local y sin zona, como publica la agenda
/// general sus `fechaVencimiento`.
String demoIsoDateTime(final DateTime date) => '${demoIsoDate(date)}T${demoTime(date)}:${_two(date.second)}';

/// `dd-MMM-yy` con el mes en inglés y mayúsculas: el formato Oracle con el que
/// llegan las fechas de termalismo.
String demoOracleDate(final DateTime date) {
  const months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
  return '${_two(date.day)}-${months[date.month - 1]}-${_two(date.year % 100)}';
}
