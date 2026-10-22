part 'sac2100_data.dart';
part 'cotxes2100_data.dart';
part 'imatges2100_data.dart';
part 'sac2100_ux.dart';
part 'sac2100_operativa.dart';

class OpcioSac {
  final String text, desti;
  final String? causaADescartar;
  const OpcioSac(this.text, this.desti, {this.causaADescartar});
}

class PasoDiagnostico {
  final String id;
  final String preguntaOInstruccion;
  final bool esPregunta;
  final String? botonSiDestino;
  final String? botonNoDestino;
  final String? advertencia;
  final String? causaDescartadaAlSi;
  final String? causaDescartadaAlNo;
  final String? imagenPath;
  final List<ImatgePasManual> imatgesManual;
  final bool separarTextoTrenStop;
  final List<OpcioSac> opcions;

  PasoDiagnostico({
    required this.id,
    required this.preguntaOInstruccion,
    required this.esPregunta,
    this.botonSiDestino,
    this.botonNoDestino,
    this.advertencia,
    this.causaDescartadaAlSi,
    this.causaDescartadaAlNo,
    this.imagenPath,
    this.imatgesManual = const [],
    this.separarTextoTrenStop = false,
    this.opcions = const [],
  });
}

final Map<String, List<String>> causasPorRama = {
  "no_desfrena": [
    "Bolet de cabina / Selector",
    "ATP (sense codis)",
    "Home mort",
    "Aire (Baixa pressió TDP -8)",
    "STOP (Tren Stop activat)",
    "Tirador d’alarma actiu",
    "Estacionaments aplicats",
  ],
  "no_tracciona": [
    "Portes obertes",
    "Estacionaments aplicats",
    "Disjuntor (Obert)",
    "EED (Tirador verd fora de posició)",
    "Tensió nul·la (0V)",
  ],
  "modo_especial": ["Connexió del mode especial de conducció"],
  "apertura_cierre_pupitre": [
    "Fallada dels comandaments del pupitre principal",
  ],
};

// Diccionario de enlazado directo desde el panel de causas superior
final Map<String, String> enlacesCausasAIr = {
  // Rama No Desfrena
  "Tirador d’alarma actiu": "inicio_no_desfrena",
  "Bolet de cabina / Selector": "pregunta_seta",
  "ATP (sense codis)": "pregunta_modo_atp",
  "Home mort": "pregunta_hom_muerto",
  "Aire (Baixa pressió TDP -8)": "pregunta_tdp",
  "STOP (Tren Stop activat)": "pregunta_tren_stop_iris",
  "Estacionaments aplicats": "pregunta_maniobra_estacionamiento",

  // Rama No Tracciona
  "Portes obertes": "inicio_no_tracciona",
  "EED (Tirador verd fora de posició)": "pregunta_eed",
  "Tensió nul·la (0V)": "pregunta_tension",
  "Disjuntor (Obert)": "pregunta_disyuntores_abierto",

  // Ramas de causa única
  "Connexió del mode especial de conducció": "inicio_modo_especial",
  "Fallada dels comandaments del pupitre principal": "inicio_pupitre_fallo",
};

final Map<String, PasoDiagnostico> ramaNoDesfrenaS2100 = configurarCotxes2100({
  // ==========================================
  // === RAMA 1: NO DESFRENA (LAZO EMERGENCIA)
  // ==========================================
  "inicio_no_desfrena": PasoDiagnostico(
    id: "inicio_no_desfrena",
    preguntaOInstruccion:
        "Tens un avís de tirador d’alarma al pupitre de conducció?",
    esPregunta: true,
    botonSiDestino: "procedimiento_tirador",
    botonNoDestino: "pregunta_maniobra_estacionamiento",
    causaDescartadaAlNo: "Tirador d’alarma actiu",
  ),

  "procedimiento_tirador": PasoDiagnostico(
    id: "procedimiento_tirador",
    preguntaOInstruccion:
        "SAC 22 · Tirador d’alarma\n\nEn quina situació s’ha accionat?\n\nFont: L4 Avaries tècniques, pàg. 43.",
    esPregunta: false,
    opcions: [
      OpcioSac("En marxa", "sac22_marxa"),
      OpcioSac("En estació / tren parat", "sac22_estacio"),
      OpcioSac("No identificat", "sac_pendent"),
    ],
  ),

  "pregunta_seta": PasoDiagnostico(
    id: "pregunta_seta",
    imatgesManual: imatgesManual2100["pregunta_seta"]!,
    preguntaOInstruccion:
        "El bolet d’emergència està activat o el selector de marxes és a zero?",
    esPregunta: true,
    botonSiDestino: "procedimiento_seta",
    botonNoDestino: "pregunta_modo_atp",
    causaDescartadaAlNo: "Bolet de cabina / Selector",
  ),

  "procedimiento_seta": PasoDiagnostico(
    id: "procedimiento_seta",
    imatgesManual: imatgesManual2100["procedimiento_seta"]!,
    preguntaOInstruccion:
        "1. Gira el bolet d’emergència per rearmar-lo (desactivar-lo).\n"
        "2. Assegura’t que el selector de marxes no sigui a la posició zero.\n"
        "3. Comprova si el tren ja desfrena.",
    esPregunta: false,
  ),

  "pregunta_modo_atp": PasoDiagnostico(
    id: "pregunta_modo_atp",
    preguntaOInstruccion: "Tens el mode ATP seleccionat correctament i respon?",
    esPregunta: true,
    botonSiDestino: "pregunta_hom_muerto",
    botonNoDestino: "atp_reset_tbs",
    causaDescartadaAlSi: "ATP (sense codis)",
  ),

  "atp_reset_tbs": PasoDiagnostico(
    id: "atp_reset_tbs",
    preguntaOInstruccion: "Pèrdua de codis ATP\n\nFes RESET TBS durant 2–3 s.\n\nS’ha normalitzat?",
    esPregunta: false,
    opcions: [OpcioSac("S’HA NORMALITZAT", "atp_normalitzat"), OpcioSac("NO ES NORMALITZA", "atp_m25")],
  ),
  "atp_normalitzat": PasoDiagnostico(
    id: "atp_normalitzat", preguntaOInstruccion: "Comprova la recuperació del funcionament. Si el tren continua sense desfrenar, continua la comprovació de causes.", esPregunta: false,
    opcions: [OpcioSac("RECUPERAT", "atp_recuperat"), OpcioSac("CONTINUA SENSE DESFRENAR", "pregunta_hom_muerto")],
  ),
  "atp_recuperat": PasoDiagnostico(
    id: "atp_recuperat", preguntaOInstruccion: "Funcionament recuperat. Comunica el resultat al CCM.", esPregunta: false,
  ),
  "atp_m25": PasoDiagnostico(
    id: "atp_m25", preguntaOInstruccion: "Selecciona M+25 i comprova el resultat.\n\nHas pogut seleccionar M+25?", esPregunta: false,
    opcions: [OpcioSac("M+25 SELECCIONAT", "atp_normalitzat"), OpcioSac("NO ES POT SELECCIONAR M+25", "procedimiento_modo_especial")],
  ),
  "procedimiento_modo_especial": PasoDiagnostico(
    id: "procedimiento_modo_especial",
    preguntaOInstruccion: "No es pot seleccionar M+25: desallotja el tren abans d’entrar en Mode Especial. Coordina l’actuació amb el CCM.",
    esPregunta: false,
    botonSiDestino: "inicio_modo_especial",
    advertencia: "No circular amb passatge en Mode Especial.",
  ),

  "pregunta_hom_muerto": PasoDiagnostico(
    id: "pregunta_hom_muerto",
    preguntaOInstruccion:
        "Estàs prement correctament l’home mort al manipulador i el tren continua sense desfrenar?",
    esPregunta: true,
    botonSiDestino: "pregunta_tdp",
    botonNoDestino: "procedimiento_hom_muerto_error",
    causaDescartadaAlSi: "Home mort",
  ),

  "procedimiento_hom_muerto_error": PasoDiagnostico(
    id: "procedimiento_hom_muerto_error",
    preguntaOInstruccion:
        "Assegura’t de mantenir premut el dispositiu de seguretat del manipulador de manera constant i torna-ho a provar.",
    esPregunta: false,
  ),

  "pregunta_tdp": PasoDiagnostico(
    id: "pregunta_tdp",
    imatgesManual: imatgesManual2100["pregunta_tdp"]!,
    preguntaOInstruccion:
        "La pressió de la canonada principal (TDP) és inferior als mínims (8 bar) als manòmetres?",
    esPregunta: true,
    botonSiDestino: "sac_aire",
    botonNoDestino: "pregunta_tren_stop_iris",
    causaDescartadaAlNo: "Aire (Baixa pressió TDP -8)",
  ),

  "procedimiento_b12_esquema": PasoDiagnostico(
    id: "procedimiento_b12_esquema",
    preguntaOInstruccion:
        "Anul·lar el fre de servei (B12) (▼ Triangle vermell):\n\n"
        "El cotxe afectat al qual aïllaràs el fre pneumàtic és un cotxe MA (motor amb cabina)?",
    esPregunta: true,
    botonSiDestino: "procedimiento_b12_ma",
    botonNoDestino: "procedimiento_b12_mb_r",
    imagenPath: "manual/s2100/sac_14/grifos-b12.jpg",
  ),

  "procedimiento_b12_ma": PasoDiagnostico(
    id: "procedimiento_b12_ma",
    preguntaOInstruccion:
        "Ubicació al MA1 / MA2:\n\n"
        "Un es troba sota els seients del passatge i l’altre és a l’armari del costat del passadís d’intercirculació entre cotxes.\n\n"
        "Un cop tancats, comprova des del pupitre si el tren ja desfrena.",
    esPregunta: false,
    botonSiDestino: "b12_resultat",
    imagenPath: "manual/s2100/sac_14/b12-2.jpg",
    advertencia:
        "⚠️ RECORDA: En tancar l’aixeta B12, el cotxe es queda COMPLETAMENT sense fre pneumàtic. Cal anul·lar el llaç de fre. Coordina l’actuació amb el CCM.",
  ),

  "procedimiento_b12_mb_r": PasoDiagnostico(
    id: "procedimiento_b12_mb_r",
    preguntaOInstruccion:
        "Ubicació als MB1 / R / MB2:\n\n"
        "Totes dues aixetes es troben sota els seients del passatge; aixeca les tapes del cofre amb la clau de quadradet.\n\n"
        "Un cop tancats, comprova des del pupitre si el tren ja desfrena.",
    esPregunta: false,
    botonSiDestino: "b12_resultat",
    imagenPath: "manual/s2100/sac_14/b12.jpg",
    advertencia:
        "⚠️ RECORDA: En tancar l’aixeta B12, el cotxe es queda COMPLETAMENT sense fre pneumàtic. Cal anul·lar el llaç de fre. Coordina l’actuació amb el CCM.",
  ),

  "pregunta_tren_stop_iris": PasoDiagnostico(
    id: "pregunta_tren_stop_iris",
    preguntaOInstruccion:
        "Tens un avís al display IRIS de tren deslocalitzat per Tren Stop?\n\n"
        "(És una fallada molt habitual per pèrdua de codi en zones de maniobres o terminals de l’L4 com La Pau o Trinitat Nova).",
    esPregunta: true,
    botonSiDestino: "procedimiento_tren_stop_rearme",
    botonNoDestino: "inicio_no_desfrena",
    causaDescartadaAlNo: "STOP (Tren Stop activat)",
  ),

  "procedimiento_tren_stop_rearme": PasoDiagnostico(
    id: "procedimiento_tren_stop_rearme",
    preguntaOInstruccion:
        "SAC 23 · Confirma variant. No abaixis cap tèrmic genèric.\n\nFont: L4 Avaries tècniques, pàg. 44, 64.",
    esPregunta: false,
    opcions: [
      OpcioSac("2100 original", "sac23_original"),
      OpcioSac("2100 remodelat", "sac23_remodelat"),
      OpcioSac("No identificat", "sac_pendent"),
    ],
  ),

  "pregunta_maniobra_estacionamiento": PasoDiagnostico(
    id: "pregunta_maniobra_estacionamiento",
    preguntaOInstruccion:
        "El fre d’estacionament està aplicat en algun dels cotxes i no el pots treure des del pupitre?",
    esPregunta: true,
    botonSiDestino: "sac13",
    botonNoDestino: "fin_no_desfrena_llamar_ccm",
    causaDescartadaAlNo: "Estacionaments aplicats",
  ),

  "fin_no_desfrena_llamar_ccm": PasoDiagnostico(
    id: "fin_no_desfrena_llamar_ccm",
    preguntaOInstruccion:
        "No s’ha identificat cap de les causes habituals de fallada de desfrenament.\n\n"
        "Truca al CCM per sol·licitar assistència de taller o instruccions addicionals.",
    esPregunta: false,
  ),

  "pregunta_b19_es_ma": PasoDiagnostico(
    id: "pregunta_b19_es_ma",
    preguntaOInstruccion:
        "Aïllament per ELECTROVÀLVULA B19 (🟥 Quadrat vermell):\n\n"
        "El cotxe afectat que aïllaràs és un cotxe MA (amb cabina)?",
    esPregunta: true,
    botonSiDestino: "procedimiento_b19_ma",
    botonNoDestino: "procedimiento_b19_mb_r",
  ),

  "procedimiento_b19_ma": PasoDiagnostico(
    id: "procedimiento_b19_ma",
    preguntaOInstruccion:
        "Anul·lació per B19 al MA1 / MA2:\n\n"
        "1. Obre l’armari pneumàtic situat a la paret de la testera (marcat amb el pictograma del quadrat vermell).\n"
        "2. Gira en sentit ANTIHORARI la roda negra de l’electrovàlvula B19 per obrir el pas d’aire.\n"
        "3. Comprova al SAC si el fre d’estacionament continua apareixent aplicat.",
    esPregunta: false,
    botonSiDestino: "pregunta_confirma_b19",
    imagenPath: "manual/s2100/sac_13/b19-coches-a.jpg",
  ),

  "procedimiento_b19_mb_r": PasoDiagnostico(
    id: "procedimiento_b19_mb_r",
    preguntaOInstruccion:
        "Anul·lació per B19 als MB1 / R / MB2:\n\n"
        "1. Obre el cofre sota els seients amb la clau de quadradet.\n"
        "2. Gira en sentit ANTIHORARI la roda negra de l’electrovàlvula B19.\n"
        "3. Comprova al SAC si el fre d’estacionament continua apareixent aplicat.",
    esPregunta: false,
    botonSiDestino: "pregunta_confirma_b19",
    imagenPath: "manual/s2100/sac_13/b19.jpg",
  ),

  "pregunta_confirma_b19": PasoDiagnostico(
    id: "pregunta_confirma_b19",
    preguntaOInstruccion:
        "Has comprovat l’alliberament real de l’estacionament? En el cas 1F09, el SAC pot continuar indicant-lo encara que entri aire i el cotxe estigui desfrenat.\n\nFont: L4 Avaries tècniques, pàg. 33, 38.",
    esPregunta: true,
    botonSiDestino: "fin_freno_liberado",
    botonNoDestino: "pregunta_b17_es_ma",
  ),

  "pregunta_b17_es_ma": PasoDiagnostico(
    id: "pregunta_b17_es_ma",
    preguntaOInstruccion:
        "L’aïllament per B19 no ha alliberat el fre. Passem a l’aïllament mecànic per AIXETA B17 + SIRGUES (🟥 Quadrat vermell):\n\n"
        "El cotxe afectat al qual buidaràs el circuit pneumàtic és un cotxe MA (amb cabina)?",
    esPregunta: true,
    botonSiDestino: "procedimiento_b17_ma",
    botonNoDestino: "procedimiento_b17_mb_r",
  ),

  "procedimiento_b17_ma": PasoDiagnostico(
    id: "procedimiento_b17_ma",
    preguntaOInstruccion:
        "Pas 1: Tancar B17 al MA1 / MA2:\n\n"
        "1. Obre l’armari de la testera.\n"
        "2. Gira l’aixeta B17 en sentit antihorari amb la clau de quadradet per tallar l’aire.",
    esPregunta: false,
    botonSiDestino: "procedimiento_sirgas_accion",
    imagenPath: "manual/s2100/sac_13/b17-ma.jpg",
  ),

  "procedimiento_b17_mb_r": PasoDiagnostico(
    id: "procedimiento_b17_mb_r",
    preguntaOInstruccion:
        "Pas 1: Tancar B17 als MB1 / R / MB2:\n\n"
        "1. Obre l’armari sota els seients del passatge.\n"
        "2. Gira l’aixeta B17 en sentit antihorari amb la clau de quadradet.",
    esPregunta: false,
    botonSiDestino: "procedimiento_sirgas_accion",
    imagenPath: "manual/s2100/sac_13/b17-mb-remolque.jpg",
  ),

  "procedimiento_sirgas_accion": PasoDiagnostico(
    id: "procedimiento_sirgas_accion",
    preguntaOInstruccion:
        "Pas 2: Estirar les SIRGUES (exterior del bogi - 🟥 Quadrat vermell):\n\n"
        "1. Coordina amb CCM qualsevol accés a la via abans de baixar.\n"
        "2. Localitza a l’exterior el pictograma de la balança al lateral.\n"
        "3. Estira amb força la sirga cap amunt en tot el seu recorregut per alliberar mecànicament la molla.\n"
        "4. Puja a la cabina i comprova-ho al SAC.\n\n"
        "Has comprovat l’alliberament real del fre?",
    advertencia:
        "B17/sirgues: desallotjament i llaç de portes per traccionar segons la fitxa. No és marxa normal.",
    esPregunta: true,
    botonSiDestino: "fin_freno_liberado",
    botonNoDestino: "procedimiento_ccm_final",
    imagenPath: "manual/s2100/sac_13/sirgas.jpg",
    causaDescartadaAlSi: "Estacionaments aplicats",
  ),

  "fin_freno_liberado": PasoDiagnostico(
    id: "fin_freno_liberado",
    preguntaOInstruccion:
        "Has confirmat l’alliberament de l’estacionament comprovat. Revisa actuacions i condicions amb CCM: B17/sirgues requereix desallotjament i llaç de portes; el cas 1F09 també té aquestes condicions. No equival a marxa normal.\n\nFont: L4 Avaries tècniques, pàg. 33, 38.",
    esPregunta: false,
  ),

  // ==========================================
  // === RAMA 2: NO TRACCIONA
  // ==========================================
  "inicio_no_tracciona": PasoDiagnostico(
    id: "inicio_no_tracciona",
    preguntaOInstruccion: "Tens les portes tancades físicament a tot el tren?",
    esPregunta: true,
    botonSiDestino: "sac_portes_reconegudes",
    botonNoDestino: "procedimiento_puertas_fallo",
  ),

  "procedimiento_puertas_fallo": PasoDiagnostico(
    id: "procedimiento_puertas_fallo",
    preguntaOInstruccion:
        "SAC 08 · Porta oberta / avaria de portes\n\nQuin és el símptoma?\n\nFont: L4 Avaries tècniques, pàg. 24–29.",
    esPregunta: false,
    opcions: [
      OpcioSac("Les portes no tanquen", "sac08_no_tanquen"),
      OpcioSac("SAC marca porta oberta / no tracciona", "sac08_oberta"),
      OpcioSac("Porta bloquejada per objecte", "sac08_objecte"),
      OpcioSac("No es pot seleccionar costat", "sac08_seleccio"),
      OpcioSac("No permet permissió de portes", "sac08_permissio"),
      OpcioSac("No identificat", "sac_pendent"),
    ],
  ),

  "pregunta_estacionamiento": PasoDiagnostico(
    id: "pregunta_estacionamiento",
    preguntaOInstruccion:
        "L’estacionament està realment afluixat, després d’actuar DES?",
    esPregunta: true,
    botonSiDestino: "pregunta_disyuntores_abierto",
    botonNoDestino: "procedimiento_quitar_estacionamiento_cabina",
    causaDescartadaAlSi: "Estacionaments aplicats",
  ),

  "procedimiento_quitar_estacionamiento_cabina": PasoDiagnostico(
    id: "procedimiento_quitar_estacionamiento_cabina",
    imatgesManual:
        imatgesManual2100["procedimiento_quitar_estacionamiento_cabina"]!,
    preguntaOInstruccion:
        "Afluixament des de cabina:\n\n"
        "1. Prem fermament el polsador 'DES' al panell de comandaments.\n"
        "2. Comprova si l’indicador d’aplicat s’apaga.\n"
        "3. Si continua bloquejat, prem CONTINUAR per comprovar el resultat i identificar l’abast al SAC 13.",
    esPregunta: false,
    botonSiDestino: "sac_des_comprova",
  ),

  "pregunta_eed": PasoDiagnostico(
    id: "pregunta_eed",
    preguntaOInstruccion:
        "Tens algun tirador verd de desbloqueig d’emergència de portes (EED) fora de posició?",
    esPregunta: true,
    botonSiDestino: "procedimiento_eed_rearmar",
    botonNoDestino: "pregunta_tension",
    causaDescartadaAlNo: "EED (Tirador verd fora de posició)",
  ),

  "procedimiento_eed_rearmar": PasoDiagnostico(
    id: "procedimiento_eed_rearmar",
    preguntaOInstruccion:
        "Normalitza o rearma el tirador verd (EED) afectat al cotxe corresponent.\n\n"
        "Comprova a cabina que el pilot de portes s’apaga i el tren torna a traccionar.",
    esPregunta: false,
  ),

  "pregunta_tension": PasoDiagnostico(
    id: "pregunta_tension",
    preguntaOInstruccion:
        "El voltímetre de línia indica tensió nul·la (0V) a cabina?",
    esPregunta: true,
    botonSiDestino: "procedimiento_tension_nula",
    botonNoDestino: "procedimiento_ccm_final",
    causaDescartadaAlNo: "Tensió nul·la (0V)",
  ),

  "procedimiento_tension_nula": PasoDiagnostico(
    id: "procedimiento_tension_nula",
    preguntaOInstruccion:
        "SAC 04 · Contrasta amb CCM/operadors d’energia si hi ha hagut caiguda de tensió. 0 V també pot correspondre a desconnexió involuntària.\n\nFont: L4 Avaries tècniques, pàg. 22.",
    esPregunta: false,
    opcions: [
      OpcioSac("Caiguda externa confirmada", "sac04_externa"),
      OpcioSac("Caiguda negada i tren a final", "sac04_terminal"),
      OpcioSac("No confirmat", "sac_pendent"),
    ],
  ),

  // ==========================================
  // === APERTURA DISYUNTOR / FEEDER
  // ==========================================
  "pregunta_disyuntores_abierto": PasoDiagnostico(
    id: "pregunta_disyuntores_abierto",
    preguntaOInstruccion: "S’ha obert el disjuntor per un dispar del Feeder?",
    esPregunta: true,
    botonSiDestino: "procedimiento_rearme_disyuntor",
    botonNoDestino: "pregunta_eed",
    causaDescartadaAlNo: "Disjuntor (Obert)",
  ),

  "procedimiento_rearme_disyuntor": PasoDiagnostico(
    id: "procedimiento_rearme_disyuntor",
    imatgesManual: imatgesManual2100["procedimiento_rearme_disyuntor"]!,
    preguntaOInstruccion:
        "SAC 01 · Disjuntor\n\nDes de la cabina habilitada per conduir, preferiblement amb el tren estacionat:\n1. Posa el manipulador M/F a 0.\n2. Polsa CON DISJUNTOR.\n\nFont: L4 Avaries tècniques, pàg. 16.",
    esPregunta: false,
    botonSiDestino: "sac01_comprova",
  ),

  "procedimiento_ccm_final": PasoDiagnostico(
    id: "procedimiento_ccm_final",
    preguntaOInstruccion:
        "Si tot l’anterior és correcte, truca directament al CCM per sol·licitar assistència de taller o tracció avançada.",
    esPregunta: false,
  ),

  // ==========================================
  // === RAMA 3: MODE ESPECIAL
  // ==========================================
  "inicio_modo_especial": PasoDiagnostico(
    id: "inicio_modo_especial",
    imatgesManual: imatgesManual2100["inicio_modo_especial"]!,
    preguntaOInstruccion:
        "Mode Especial: cal autorització del CCM i tren sense passatge.\n\nPas 1: Preparació del pupitre\n\n"
        "1. Situa el manipulador M/F en posició 0.\n"
        "2. Posa el selector de marxes a 0.\n"
        "3. Gira la clau de govern a 0.",
    esPregunta: false,
    botonSiDestino: "procedimiento_modo_especial_llave",
    imagenPath: "manual/s2100/compartits/preparacio-pupitre.jpg",
  ),

  "procedimiento_modo_especial_llave": PasoDiagnostico(
    id: "procedimiento_modo_especial_llave",
    imatgesManual: imatgesManual2100["procedimiento_modo_especial_llave"]!,
    preguntaOInstruccion: "Amb M/F, selector i clau de govern ja a 0, desconnecta l’equip ATC amb la clau M.E.\n\nEl pilot M.E. parpelleja?",
    esPregunta: false,
    opcions: [OpcioSac("EL PILOT PARPELLEJA", "me_establert"), OpcioSac("NO PARPELLEJA", "me_repetir")],
    advertencia: "Cal autorització del CCM. No circular amb passatge en Mode Especial.",
  ),
  "me_repetir": PasoDiagnostico(
    id: "me_repetir",
    preguntaOInstruccion: "Repeteix l’operació: posa M/F, selector i clau de govern a 0 abans de desconnectar ATC amb la clau M.E.\n\nEl pilot M.E. parpelleja?",
    esPregunta: false,
    opcions: [OpcioSac("EL PILOT PARPELLEJA", "me_establert"), OpcioSac("NO PARPELLEJA", "me_testera_contraria")],
  ),
  "me_testera_contraria": PasoDiagnostico(
    id: "me_testera_contraria",
    preguntaOInstruccion: "Fes l’operació a la testera contrària: primer M/F, selector i clau de govern a 0; després desconnecta ATC amb la clau M.E.\n\nEl pilot M.E. parpelleja?",
    esPregunta: false,
    opcions: [OpcioSac("EL PILOT PARPELLEJA", "me_retorn"), OpcioSac("NO PARPELLEJA", "me_no_establert")],
  ),
  "me_retorn": PasoDiagnostico(
    id: "me_retorn",
    preguntaOInstruccion: "Un cop establert el Mode Especial a la testera contrària, torna a la cabina de conducció segons el procediment. Comprova que el pilot M.E. parpelleja abans de continuar.",
    esPregunta: false,
    opcions: [OpcioSac("EL PILOT PARPELLEJA", "me_establert"), OpcioSac("NO PARPELLEJA", "me_no_establert")],
  ),
  "me_no_establert": PasoDiagnostico(
    id: "me_no_establert", preguntaOInstruccion: "Mode Especial no establert. No iniciïs la marxa; comunica el resultat al CCM i segueix les seves instruccions.", esPregunta: false,
  ),
  "me_establert": PasoDiagnostico(
    id: "me_establert",
    preguntaOInstruccion: "Amb el pilot M.E. parpellejant, connecta la clau de govern, posa el selector endavant i prem el botó verd DES. Coordina la circulació amb el CCM. Velocitat màxima: 25 km/h, sense passatge.",
    esPregunta: false,
    advertencia: "No circular amb passatge en Mode Especial.",
  ),

  // ==========================================
  // === RAMA 4: FALLO APERTURA/CIERRE PUPITRE
  // ==========================================
  "inicio_pupitre_fallo": PasoDiagnostico(
    id: "inicio_pupitre_fallo",
    imatgesManual: imatgesManual2100["inicio_pupitre_fallo"]!,
    preguntaOInstruccion:
        "Costat d’andana seleccionat. Prem el clàxon de la controla abans de tancar.\n\nSolució amb CONTROLAS AUXILIARS:\n\nSi el tren no obre o tanca portes des dels comandaments del pupitre principal, utilitza la botonera lateral.\n\n1. Introdueix la clau de capçalera al bombí lateral.\n2. Obre la tapa metàl·lica per alliberar els polsadors auxiliars.\n3. Executa l’obertura, el bip-bip o el tancament local des de la controla.\n\nFont: L4 Avaries tècniques, pàg. 25.",
    esPregunta: false,
    botonSiDestino: "sac07_ok",
    imagenPath: "manual/s2100/compartits/controla-existent.jpg",
  ),
  ...procedimientosSac2100,
});
