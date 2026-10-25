// lib/data/s9000_data.dart

import 's2100_data.dart'; // Reutilizamos la clase PasoDiagnostico

final Map<String, List<String>> causasPorRamaS9000 = {
  "no_desfrena": [
    "Bolet d’emergència",
    "ATP (sense codis)",
    "Home mort",
    "Aire (Baixa pressió TDP)",
    "STOP (Tren Stop activat)",
    "Tirador d’alarma",
    "Estacionaments aplicats",
  ],
  "no_tracciona": [
    "Portes obertes",
    "Estacionaments aplicats",
    "Disjuntor (Obert)",
    "EED (Tirador verd fora de posició)",
    "Tensió nul·la (0V)",
  ],
  "modos_conduccion": [
    "Connexió del mode especial",
    "Connexió del mode socors",
  ],
  "avaries_s9000": [],
  "operativa_basica": [
    "Posada en marxa (P.A.)",
    "Reset de bateries (final de línia)",
    "Desconnexió (portes tancades)",
    "Desconnexió (portes obertes)",
    "Introduir número de tren",
  ],
};

final Map<String, String> enlacesCausasAIrS9000 = {
  "Fre de servei bloquejat": "s9000_pregunta_fre",
  "Govern / selector de marxa": "s9000_govern",
  "Avaria DDU": "s9000_ddu",
  "Cabina habilitada": "s9000_cabina",
  "Avaria cadena de tracció (IOS86)": "s9000_traccio",
  // Rama No Desfrena
  "Tirador d’alarma": "inicio_no_desfrena_s9000",
  "Bolet d’emergència": "pregunta_seta_s9000",
  "Home mort": "pregunta_hm_s9000",
  "ATP (sense codis)": "pregunta_atp_s9000",
  "STOP (Tren Stop activat)": "pregunta_tren_stop_s9000",
  "Aire (Baixa pressió TDP)": "pregunta_tdp_s9000",
  "Estacionaments aplicats": "pregunta_estacionamiento_s9000",

  // Rama No Tracciona
  "Portes obertes": "inicio_no_tracciona_s9000",
  "EED (Tirador verd fora de posició)": "pregunta_eed_s9000",
  "Tensió nul·la (0V)": "pregunta_tension_s9000",
  "Disjuntor (Obert)": "pregunta_disyuntores_s9000",

  // Modos y Operativa
  "Connexió del mode especial": "inicio_modo_especial_s9000",
  "Connexió del mode socors": "inicio_modo_socorro",
  "Posada en marxa (P.A.)": "inicio_puesta_marcha",
  "Reset de bateries (final de línia)": "inicio_reset_baterias",
  "Desconnexió (portes tancades)": "inicio_desc_cerradas",
  "Desconnexió (portes obertes)": "inicio_desc_abiertas",
  "Introduir número de tren": "inicio_num_tren",
};

final Map<String, PasoDiagnostico> arbolS9000 = {
  // ==========================================
  // === RAMA: NO DESFRENA S9000 (LLAÇ D'EMERGÈNCIA)
  // ==========================================
  "inicio_no_desfrena_s9000": PasoDiagnostico(
    id: "inicio_no_desfrena_s9000",
    preguntaOInstruccion:
        "Tens un altaveu que parpelleja a la pantalla d’alarmes de la DDU indicant un tirador d’alarma accionat?",
    esPregunta: true,
    botonSiDestino: "inicio_tirador",
    botonNoDestino: "pregunta_estacionamiento_s9000",
    causaDescartadaAlNo: "Tirador d’alarma",
    imagenPath: "assets/resolucion/s9000_tirador_alarma.jpg",
  ),

  "pregunta_seta_s9000": PasoDiagnostico(
    id: "pregunta_seta_s9000",
    preguntaOInstruccion:
        "El bolet d’emergència està accionat en alguna testera?\n\nFont: L4 Avaries tècniques, pàg. 82.",
    esPregunta: true,
    botonSiDestino: "procedimiento_seta_s9000",
    botonNoDestino: "pregunta_atp_s9000",
    imagenPath: "assets/resolucion/s9000_manual_p082.jpg",
    causaDescartadaAlNo: "Bolet d’emergència",
  ),
  "procedimiento_seta_s9000": PasoDiagnostico(
    id: "procedimiento_seta_s9000",
    preguntaOInstruccion:
        "Rearma el bolet girant-lo en sentit antihorari. Comprova també el bolet de la testera oposada. El bolet aplica fre d’emergència i d’estacionament; afluixa l’estacionament després de rearmar-lo. Pot aparèixer IOS14.\n\nFont: L4 Avaries tècniques, pàg. 82.",
    esPregunta: false,
    botonSiDestino: "s9000_comprova",
    imagenPath: "assets/resolucion/s9000_seta_emergencia.jpg",
  ),

  "pregunta_hm_s9000": PasoDiagnostico(
    id: "pregunta_hm_s9000",
    preguntaOInstruccion: "Fa més de 5 segons que no prems l’home mort?",
    esPregunta: true,
    botonSiDestino: "procedimiento_hm_s9000",
    botonNoDestino: "pregunta_tdp_s9000",
    causaDescartadaAlNo: "Home mort",
  ),
  "procedimiento_hm_s9000": PasoDiagnostico(
    id: "procedimiento_hm_s9000",
    preguntaOInstruccion:
        "Torna a prémer el dispositiu de seguretat del manipulador per rearmar el llaç d’emergència.",
    esPregunta: false,
  ),

  "pregunta_atp_s9000": PasoDiagnostico(
    id: "pregunta_atp_s9000",
    preguntaOInstruccion:
        "Quin estat mostra l’equip de conducció?\n\nFont: L4 Avaries tècniques, pàg. 5.",
    esPregunta: false,
    opcions: [
      OpcioSac("No hi ha mode de conducció", "s9000_mode_absent"),
      OpcioSac("No rep codis ATP", "procedimiento_atp_s9000"),
      OpcioSac(
        "Mode i codis correctes",
        "pregunta_hm_s9000",
        causaADescartar: "ATP (sense codis)",
      ),
    ],
    imagenPath: "assets/resolucion/s9000_reset_tbs.jpg",
  ),
  "procedimiento_atp_s9000": PasoDiagnostico(
    id: "procedimiento_atp_s9000",
    preguntaOInstruccion:
        "RESET TBS: reinicia l'equip ATC. Gira el comandament RESET TBS; el polsador torna a la seva posició original.",
    esPregunta: false,
    botonSiDestino: "pregunta_codis_recuperats_s9000",
    imagenPath: "assets/resolucion/s9000_reset_tbs.jpg",
  ),

  "pregunta_codis_recuperats_s9000": PasoDiagnostico(
    id: "pregunta_codis_recuperats_s9000",
    preguntaOInstruccion: "Has recuperat els codis ATP?",
    esPregunta: true,
    causaDescartadaAlSi: "ATP (sense codis)",
    botonSiDestino: "fi_atp_recuperat_s9000",
    botonNoDestino: "procedimiento_m25_s9000",
  ),

  "fi_atp_recuperat_s9000": PasoDiagnostico(
    id: "fi_atp_recuperat_s9000",
    preguntaOInstruccion:
        "Codis ATP recuperats. Comprova també el mode de conducció i la resolució del símptoma abans de donar l’avaria per resolta.",
    esPregunta: false,
    botonSiDestino: "s9000_comprova",
  ),

  "procedimiento_m25_s9000": PasoDiagnostico(
    id: "procedimiento_m25_s9000",
    preguntaOInstruccion:
        "Sol·licita autorització al CCM per circular en Manual +25 (M+25).",
    esPregunta: false,
  ),

  "pregunta_tdp_s9000": PasoDiagnostico(
    id: "pregunta_tdp_s9000",
    preguntaOInstruccion:
        "La TDP té pressió baixa? IOS218 indica TDP < 8 bar; IOS24 i FE per pressòstat de mínima, TDP < 6,5 bar.\n\nFont: L4 Avaries tècniques, pàg. 88.",
    esPregunta: true,
    botonSiDestino: "s9000_aire",
    botonNoDestino: "pregunta_tren_stop_s9000",
    imagenPath: "assets/resolucion/s9000_manual_p088.jpg",
    causaDescartadaAlNo: "Aire (Baixa pressió TDP)",
  ),

  "pregunta_tren_stop_s9000": PasoDiagnostico(
    id: "pregunta_tren_stop_s9000",
    preguntaOInstruccion: "Tens un avis de STOP (Tren Stop activat) a la DDU?",
    esPregunta: true,
    botonSiDestino: "procedimiento_tren_stop_s9000",
    botonNoDestino: "inicio_no_desfrena_s9000",
    causaDescartadaAlNo: "STOP (Tren Stop activat)",
    imagenPath: "assets/resolucion/s9000_tren_stop_cesares.jpg",
  ),

  "procedimiento_tren_stop_s9000": PasoDiagnostico(
    id: "procedimiento_tren_stop_s9000",
    preguntaOInstruccion:
        "Rearma el Tren Stop amb TR al CESARES. A L4 el document indica que no està instal·lat com a sistema de seguretat, però poden existir balises que l’activin per error. L’app anterior també recull REBA per al depassament autoritzat; no és el botó de rearme TR.\n\nFont: L4 Avaries tècniques, pàg. 94.",
    esPregunta: false,
    botonSiDestino: "s9000_comprova",
    imagenPath: "assets/resolucion/s9000_manual_p094.jpg",
  ),

  "pregunta_estacionamiento_s9000": PasoDiagnostico(
    id: "pregunta_estacionamiento_s9000",
    preguntaOInstruccion:
        "T’apareix el fre d’estacionament aplicat a la DDU (pictograma 'P') i no aconsegueixes afluixar-lo des de la botonera verda?",
    esPregunta: true,
    botonSiDestino: "inicio_b19",
    botonNoDestino: "fin_no_desfrena_ccm_s9000",
    causaDescartadaAlNo: "Estacionaments aplicats",
    imagenPath: "assets/resolucion/s9000_estacionamiento.jpg",
  ),

  "fin_no_desfrena_ccm_s9000": PasoDiagnostico(
    id: "fin_no_desfrena_ccm_s9000",
    preguntaOInstruccion:
        "No s’ha identificat la causa. Comunica-ho al CCM i segueix les seves indicacions.",
    esPregunta: false,
    imagenPath: "assets/resolucion/s9000_manual_p005.jpg",
  ),

  // ==========================================
  // === RAMA: NO TRACCIONA S9000 (LLAÇ DE TRACCIÓ)
  // ==========================================
  "inicio_no_tracciona_s9000": PasoDiagnostico(
    id: "inicio_no_tracciona_s9000",
    preguntaOInstruccion: "Tens alguna indicació de portes obertes a la DDU?",
    esPregunta: true,
    botonSiDestino: "inicio_lazo_puertas",
    botonNoDestino: "pregunta_estacionamiento_trac_s9000",
    causaDescartadaAlNo: "Portes obertes",
    imagenPath: "assets/resolucion/s9000_lazo_puertas.jpg",
  ),

  "pregunta_estacionamiento_trac_s9000": PasoDiagnostico(
    id: "pregunta_estacionamiento_trac_s9000",
    preguntaOInstruccion:
        "T’indica estacionament aplicat i impedeix la tracció?",
    esPregunta: true,
    botonSiDestino: "inicio_b19",
    botonNoDestino: "pregunta_disyuntores_s9000",
    causaDescartadaAlNo: "Estacionaments aplicats",
    imagenPath: "assets/resolucion/s9000_estacionamiento.jpg",
  ),

  "pregunta_eed_s9000": PasoDiagnostico(
    id: "pregunta_eed_s9000",
    preguntaOInstruccion:
        "Tens algun tirador verd de desbloqueig de portes fora de posició o alguna porta desbloquejada manualment?",
    esPregunta: true,
    botonSiDestino: "procedimiento_eed_s9000",
    botonNoDestino: "pregunta_tension_s9000",
    causaDescartadaAlNo: "EED (Tirador verd fora de posició)",
    imagenPath: "assets/resolucion/s9000_desbloqueo_puertas.jpg",
  ),
  "procedimiento_eed_s9000": PasoDiagnostico(
    id: "procedimiento_eed_s9000",
    preguntaOInstruccion:
        "Porta desbloquejada amb tirador verd (EED): identifica el costat.\n\nFont: L4 Avaries tècniques, pàg. 80.",
    esPregunta: false,
    opcions: [
      OpcioSac("Costat via", "s9000_eed_via"),
      OpcioSac("Costat andana", "s9000_eed_andana"),
      OpcioSac("Costat no identificat", "s9000_pendent"),
    ],
    imagenPath: "assets/resolucion/s9000_desbloqueo_puertas.jpg",
  ),

  "pregunta_tension_s9000": PasoDiagnostico(
    id: "pregunta_tension_s9000",
    preguntaOInstruccion: "Tens tensió nul·la (0V) al voltímetre?",
    esPregunta: true,
    botonSiDestino: "procedimiento_tension_nula_s9000",
    botonNoDestino: "fin_no_tracciona_ccm_s9000",
    causaDescartadaAlNo: "Tensió nul·la (0V)",
    imagenPath: "assets/resolucion/s9000_voltimetro_manometro.jpg",
  ),
  "procedimiento_tension_nula_s9000": PasoDiagnostico(
    id: "procedimiento_tension_nula_s9000",
    preguntaOInstruccion:
        "Comunica al CCM la manca de tensió a la catenària.\n\nNo intentis recuperar la tracció fins que es confirmi que hi ha tensió disponible i que el tren està autoritzat a continuar.",
    esPregunta: false,
    imagenPath: "assets/resolucion/s9000_voltimetro_manometro.jpg",
  ),

  "pregunta_disyuntores_s9000": PasoDiagnostico(
    id: "pregunta_disyuntores_s9000",
    preguntaOInstruccion:
        "Els disjuntors principals estan oberts en una o en totes dues unitats?",
    esPregunta: true,
    botonSiDestino: "procedimiento_disyuntores_s9000",
    botonNoDestino: "pregunta_eed_s9000",
    causaDescartadaAlNo: "Disjuntor (Obert)",
    imagenPath: "assets/resolucion/s9000_disyuntores.jpg",
  ),
  "procedimiento_disyuntores_s9000": PasoDiagnostico(
    id: "procedimiento_disyuntores_s9000",
    preguntaOInstruccion:
        "IOS112/113: passa manipulador, selector i govern per 0. Torna a posar el selector ENDAV. i comprova si tanquen. Si no, amb govern CON i manipulador a 0, prem CONNEXIÓ DISJUNTOR a la part inferior de DDU1 segons el document. No accionis la clau de posada a terra. Passa MARXA-FRE per 0 abans de recuperar tracció.\n\nFont: L4 Avaries tècniques, pàg. 69.",
    esPregunta: false,
    botonSiDestino: "s9000_disj_ok",
    imagenPath: "assets/resolucion/s9000_manual_p069.jpg",
  ),

  "fin_no_tracciona_ccm_s9000": PasoDiagnostico(
    id: "fin_no_tracciona_ccm_s9000",
    preguntaOInstruccion:
        "No s’ha identificat la causa. Comunica-ho al CCM i segueix les seves indicacions.",
    esPregunta: false,
    imagenPath: "assets/resolucion/s9000_manual_p095.jpg",
  ),

  // ==========================================
  // === MENÚS DE ENTRADA (MODOS Y OPERATIVA)
  // ==========================================
  "inicio_menu_modos": PasoDiagnostico(
    id: "inicio_menu_modos",
    preguntaOInstruccion: "Necessites connectar el mode especial (M.E.)?",
    esPregunta: true,
    botonSiDestino: "inicio_modo_especial_s9000",
    botonNoDestino: "inicio_modo_socorro",
    causaDescartadaAlNo: "Connexió del mode especial",
  ),
  "inicio_menu_operativa_1": PasoDiagnostico(
    id: "inicio_menu_operativa_1",
    preguntaOInstruccion: "Vols fer la posada en marxa automàtica (P.A.)?",
    esPregunta: true,
    botonSiDestino: "inicio_puesta_marcha",
    botonNoDestino: "inicio_menu_operativa_2",
    causaDescartadaAlNo: "Posada en marxa (P.A.)",
  ),
  "inicio_menu_operativa_2": PasoDiagnostico(
    id: "inicio_menu_operativa_2",
    preguntaOInstruccion:
        "Necessites fer un reset de bateries a final de línia?",
    esPregunta: true,
    botonSiDestino: "inicio_reset_baterias",
    botonNoDestino: "inicio_menu_operativa_3",
    causaDescartadaAlNo: "Reset de bateries (final de línia)",
  ),
  "inicio_menu_operativa_3": PasoDiagnostico(
    id: "inicio_menu_operativa_3",
    preguntaOInstruccion: "Faràs una desconnexió del tren?",
    esPregunta: true,
    botonSiDestino: "inicio_menu_operativa_desc_cerradas",
    botonNoDestino: "inicio_num_tren",
  ),
  "inicio_menu_operativa_desc_cerradas": PasoDiagnostico(
    id: "inicio_menu_operativa_desc_cerradas",
    preguntaOInstruccion: "La desconnexió és amb les portes tancades?",
    esPregunta: true,
    botonSiDestino: "inicio_desc_cerradas",
    botonNoDestino: "inicio_desc_abiertas",
    causaDescartadaAlNo: "Desconnexió (portes tancades)",
  ),

  // ==========================================
  // === PROCEDIMIENTOS DE AISLAMIENTO (9000)
  // ==========================================
  "inicio_freno_servicio": PasoDiagnostico(
    id: "inicio_freno_servicio",
    preguntaOInstruccion:
        "Fre de servei aplicat i bloquejat: identifica el cotxe a la DDU (IOS207–211). Pot haver-hi forta olor de sabata o fum sota el tren. Aquesta fitxa no correspon a baixa pressió TDP sense diagnòstic de fre bloquejat. Al cotxe identificat, obre l’armari de tèrmics amb la clau Southco.\n\nFont: L4 Avaries tècniques, pàg. 72.",
    esPregunta: false,
    botonSiDestino: "procedimiento_freno_16f70",
    imagenPath: "assets/resolucion/s9000_16f70_freno_servicio.jpg",
  ),
  "procedimiento_freno_16f70": PasoDiagnostico(
    id: "procedimiento_freno_16f70",
    preguntaOInstruccion:
        "Al cotxe afectat: baixa 16F70 CONTROL DE FRENO PNEUMATICO i prem el botó vermell 30S1 ANULACIÓ FRE DE SERVEI. Amb la coordinació del CCM, anul·la els llaços d’Equip de fre i de Tracció. En baixar 16F70 es perd la lectura de pressió de fre de la DDU: no la utilitzis per donar per confirmat el desfrenament.\n\nFont: L4 Avaries tècniques, pàg. 72.",
    esPregunta: false,
    botonSiDestino: "s9000_fre_ok",
    imagenPath: "assets/resolucion/s9000_16f70_freno_servicio.jpg",
  ),
  "fin_freno_servicio": PasoDiagnostico(
    id: "fin_freno_servicio",
    preguntaOInstruccion:
        "Desfrenament confirmat. Es mantenen les condicions d’anul·lació dels llaços d’Equip de fre i de Tracció. Comunica al CCM els equips aïllats i les maniobres; no equival a recuperar marxa normal.\n\nFont: L4 Avaries tècniques, pàg. 72.",
    esPregunta: false,
    imagenPath: "assets/resolucion/s9000_manual_p072.jpg",
  ),

  "inicio_b19": PasoDiagnostico(
    id: "inicio_b19",
    preguntaOInstruccion:
        "Aïllament per ELECTROVÀLVULA B19 (Quadrat vermell):\n\n1. A la caixa de passatge, localitza el panell pneumàtic auxiliar senyalitzat amb el pictograma d’estacionament o pantògraf i obre’l amb la clau Southco.\n2. Busca l’electrovàlvula B19.",
    esPregunta: false,
    botonSiDestino: "fin_b19",
    imagenPath: "assets/resolucion/s9000_panel_neumatico_auxiliar.jpg",
  ),
  "fin_b19": PasoDiagnostico(
    id: "fin_b19",
    preguntaOInstruccion:
        "Gira B19 a la posició A (Anul·lada). C significa Connectada. Comprova la indicació d’estacionament i el resultat de la maniobra.\n\nFont: L4 Avaries tècniques, pàg. 73.",
    esPregunta: false,
    botonSiDestino: "pregunta_confirma_b19_s9000",
    imagenPath: "assets/resolucion/s9000_panel_neumatico_auxiliar.jpg",
  ),
  "pregunta_confirma_b19_s9000": PasoDiagnostico(
    id: "pregunta_confirma_b19_s9000",
    preguntaOInstruccion:
        "S’ha apagat l’avís de fre d’estacionament després d’utilitzar la B19?",
    esPregunta: true,
    botonSiDestino: "fin_freno_liberado_s9000",
    botonNoDestino: "inicio_b17",
    imagenPath: "assets/resolucion/s9000_estacionamiento.jpg",
  ),

  "inicio_b17": PasoDiagnostico(
    id: "inicio_b17",
    preguntaOInstruccion:
        "Aïllament mecànic per AIXETA B17 + SIRGUES (Quadrat vermell):\n\n1. Localitza l’armari del panell pneumàtic auxiliar i obre’l amb la clau Southco.\n2. Gira l’aixeta B17 per buidar el circuit d’aire i aïllar-lo.",
    esPregunta: false,
    botonSiDestino: "paso2_b17_sirgas",
    imagenPath: "assets/resolucion/s9000_panel_neumatico_auxiliar.jpg",
  ),
  "paso2_b17_sirgas": PasoDiagnostico(
    id: "paso2_b17_sirgas",
    preguntaOInstruccion:
        "3. Ves al cotxe MB1, obre l’armari situat davant de l’extintor i agafa el tirador (clau en forma de T) del material d’emergència.",
    esPregunta: false,
    botonSiDestino: "fin_b17",
    imagenPath: "assets/resolucion/s9000_sirgas_estacionamiento.jpg",
  ),
  "fin_b17": PasoDiagnostico(
    id: "fin_b17",
    preguntaOInstruccion:
        "Estira completament les quatre sirgues del cotxe afectat amb l’estri i comprova l’alliberament de l’estacionament. Després d’actuar B17 + sirgues cal anul·lar el LLAÇ DE TRACCIÓ, coordinat amb el CCM.\n\nFont: L4 Avaries tècniques, pàg. 73.",
    esPregunta: false,
    botonSiDestino: "s9000_b17_ok",
    imagenPath: "assets/resolucion/s9000_sirgas_estacionamiento.jpg",
  ),
  "fin_freno_liberado_s9000": PasoDiagnostico(
    id: "fin_freno_liberado_s9000",
    preguntaOInstruccion:
        "Alliberament per B19 confirmat. Informa el CCM i conserva les condicions de l’actuació. Aquest resultat no normalitza altres aïllaments ni autoritza per si mateix la marxa.\n\nFont: L4 Avaries tècniques, pàg. 73.",
    esPregunta: false,
    imagenPath: "assets/resolucion/s9000_detall_p073.jpg",
  ),

  // ==========================================
  // === MODE ESPECIAL / SOCORRO
  // ==========================================
  "inicio_modo_especial_s9000": PasoDiagnostico(
    id: "inicio_modo_especial_s9000",
    preguntaOInstruccion:
        "Connexió del mode especial S9000:\n\n1. Desconnecta l’equip ATC introduint i girant la clau M.E. a DES.\n2. Posa el manipulador M/F a 0.\n3. Selector de marxes a 0.\n4. Clau de govern a 0.\n5. Comprova que el llum M.E. estigui encès.",
    esPregunta: false,
    botonSiDestino: "fin_modo_especial_s9000",
    imagenPath: "assets/resolucion/s9000_modo_especial.jpg",
  ),
  "fin_modo_especial_s9000": PasoDiagnostico(
    id: "fin_modo_especial_s9000",
    preguntaOInstruccion:
        "6. Connecta la clau de govern, posa el selector endavant i treu l’estacionament.\n\nRecorda: velocitat màxima de 25 km/h amb passatge (35 km/h sense passatge). Si no veus la velocitat al velocímetre, busca-la a MANT -> CXA NEGRA -> BB01/BB02.",
    esPregunta: false,
    advertencia: "⚠️ ATENCIÓ: No el connectis sense autorització del CCM.",
    imagenPath: "assets/resolucion/s9000_modo_especial.jpg",
  ),

  "inicio_modo_socorro": PasoDiagnostico(
    id: "inicio_modo_socorro",
    preguntaOInstruccion:
        "Avís de mode socors / RIOM KO o pèrdua de les dues DDU de la mateixa cabina. Amb govern CON, selecciona sentit de marxa i mode de conducció i prem MODE SOCORS. Coordina l’actuació amb CCM.\n\nFont: L4 Avaries tècniques, pàg. 102.",
    esPregunta: false,
    botonSiDestino: "paso2_modo_socorro",
    imagenPath: "assets/resolucion/s9000_lazos_anulacion.jpg",
  ),
  "paso2_modo_socorro": PasoDiagnostico(
    id: "paso2_modo_socorro",
    preguntaOInstruccion:
        "Espera 40 segons o fins que tanquin els disjuntors. Afluixa el fre d’estacionament. Pantògrafs, convertidors, compressors, enllumenat i AACC es connecten automàticament; els compressors funcionen automàticament.\n\nFont: L4 Avaries tècniques, pàg. 102.",
    esPregunta: false,
    botonSiDestino: "fin_modo_socorro",
    imagenPath: "assets/resolucion/s9000_detall_p102.jpg",
  ),
  "fin_modo_socorro": PasoDiagnostico(
    id: "fin_modo_socorro",
    preguntaOInstruccion:
        "Mantén premut l’home mort 3 segons abans de traccionar. El manipulador no modula: tracció al 75 % i fre únicament pneumàtic al 100 %. Velocitat limitada a 40 km/h. La informació de DDU i voltímetre pot ser errònia. L’app anterior recull desconnexió normalitzant el botó i esperant 20 segons; és informació addicional que no figura a la pàg. 102.\n\nFont: L4 Avaries tècniques, pàg. 102.",
    esPregunta: false,
    imagenPath: "assets/resolucion/s9000_manual_p102.jpg",
  ),

  // ==========================================
  // === PUERTAS / ALARMAS
  // ==========================================
  "inicio_lazo_puertas": PasoDiagnostico(
    id: "inicio_lazo_puertas",
    preguntaOInstruccion:
        "Porta no tanca: identifica cotxe i porta a la DDU i comprova les càmeres. Prova un nou cicle d’obertura/tancament. Si no es resol, agafa claus i walkie i comprova la guia; retira un possible objecte i torna a provar. Conserva la comprovació de tancament i enclavament i passa MARXA-FRE per 0 després de normalitzar.\n\nFont: L4 Avaries tècniques, pàg. 76.",
    esPregunta: false,
    opcions: [
      OpcioSac("Porta tancada i avís normalitzat", "s9000_comprova"),
      OpcioSac("Continua oberta / DDU marca oberta", "s9000_porta_no_tanca"),
      OpcioSac("Tirador EED accionat", "procedimiento_eed_s9000"),
      OpcioSac("Cal condemnar una porta", "s9000_condemnar"),
    ],
    imagenPath: "assets/resolucion/s9000_lazo_puertas.jpg",
  ),

  "inicio_tirador": PasoDiagnostico(
    id: "inicio_tirador",
    preguntaOInstruccion:
        "Abans de gestionar el tirador: segons el manual (pàg. 83), si s’acciona en marxa cal continuar fins a la següent estació i rearmar estacionat a l’andana; aturar-se al túnel obre el llaç. En arrencar d’estació, actua abans de superar 15 km/h o aproximadament 45 m.\n\nGestió del tirador d’alarma S9000:\n\n1. Utilitza el micròfon: prem el botó PTT per parlar i deixa’l anar per escoltar.\n2. Ves a la pantalla d’alarmes de la DDU: hi veuràs un altaveu que parpelleja al cotxe afectat.\n3. Utilitza la icona de la càmera per veure el passatger.",
    esPregunta: false,
    botonSiDestino: "paso2_tirador",
    imagenPath: "assets/resolucion/s9000_tirador_alarma.jpg",
  ),
  "paso2_tirador": PasoDiagnostico(
    id: "paso2_tirador",
    preguntaOInstruccion:
        "Si trigues a prémer el PTT, la trucada es desviarà al CCM i veuràs el pilot blau o el missatge 'INTERCOM. ACTIVO' a la ràdio. Mentre continuï així, no podràs comunicar-te amb el CCM.\n\nPrem la tecla 5 o la fletxa, segons la composició, per NORMALITZAR i alliberar el radiotelèfon. Això no recupera la conversa amb el passatger.",
    esPregunta: false,
    botonSiDestino: "fin_tirador",
    imagenPath: "assets/resolucion/s9000_intercomunicador.jpg",
  ),
  "fin_tirador": PasoDiagnostico(
    id: "fin_tirador",
    botonSiDestino: "s9000_tirador_condicions",
    preguntaOInstruccion:
        "4. Després de rebre la informació, finalitza la comunicació prement 'ANU' al CESARES. Un cop anul·lada, la comunicació amb aquell intercomunicador no es pot recuperar.\n5. Si hi ha més tiradors actius, atén-los tots seguint la mateixa seqüència.\n6. Informa el CCM del que ha passat.\n7. Rearma el tirador des de la pantalla d’alarmes de la DDU o presencialment amb la clau de quadradet.\n\nSi surts de la cabina, deixa-la tancada i emporta’t la clau de govern, la clau de quadradet i el walkie.",
    esPregunta: false,
    imagenPath: "assets/resolucion/s9000_tirador_alarma.jpg",
  ),

  // ==========================================
  // === PUESTA EN MARCHA / RESET / ETC
  // ==========================================
  "inicio_puesta_marcha": PasoDiagnostico(
    id: "inicio_puesta_marcha",
    preguntaOInstruccion:
        "Posada en marxa S9000:\n\n1. Prem el botó físic de connexió de bateries.\n2. Espera que el sistema informàtic de les DDU es carregui del tot.",
    esPregunta: false,
    botonSiDestino: "paso2_puesta_marcha",
    imagenPath: "assets/resolucion/s9000_puesta_marcha_1.jpg",
  ),
  "paso2_puesta_marcha": PasoDiagnostico(
    id: "paso2_puesta_marcha",
    preguntaOInstruccion:
        "3. A la DDU, prem la bandera verda 'PA' (posada automàtica).\n4. Observa com les icones passen de gris a groc pàl·lid, indicant la connexió (pantògrafs, convertidors, compressors, il·luminació i HVAC).",
    esPregunta: false,
    botonSiDestino: "fin_puesta_marcha",
    imagenPath: "assets/resolucion/s9000_puesta_marcha_2.jpg",
  ),
  "fin_puesta_marcha": PasoDiagnostico(
    id: "fin_puesta_marcha",
    preguntaOInstruccion:
        "5. Verifica la pressió de TDP al manòmetre: si és baixa (< 8.5 bar), espera que el compressor carregui aire fins a la zona verda (8.5 - 10 bar).\n6. Posa la clau de govern, el selector endavant i treu l’estacionament.\n\n(Avís: Si apareix IOS 216, indica que algun equip bàsic no està operatiu).",
    esPregunta: false,
    imagenPath: "assets/resolucion/s9000_puesta_marcha_3.jpg",
  ),

  "inicio_reset_baterias": PasoDiagnostico(
    id: "inicio_reset_baterias",
    preguntaOInstruccion:
        "Reset incloent bateries, sol·licitat/coordinat amb Portacotxeres. Preferentment a final de línia o via de maniobra pel risc de no reconnectar. A DDU1 → PMA, desconnecta automàticament i espera que tots els equips estiguin en gris. Amb govern a 0, prem DESCONNEXIÓ BATERIES a DDU2 i espera que acabi el procés.\n\nFont: L4 Avaries tècniques, pàg. 68.",
    esPregunta: false,
    botonSiDestino: "fin_reset_baterias",
    imagenPath: "assets/resolucion/s9000_manual_p068.jpg",
  ),
  "fin_reset_baterias": PasoDiagnostico(
    id: "fin_reset_baterias",
    preguntaOInstruccion:
        "Prem CONNEXIÓ BATERIES a la columna dreta. Atenció: les portes es tanquen lentament. Espera la càrrega de les DDU; a PMA connecta automàticament i espera els equips. Selecciona govern CON, selector ENDAV. i mode de conducció. Ordre manual: bateria → pantògraf → convertidor → compressor → enllumenat → aire; desconnexió en ordre invers.\n\nFont: L4 Avaries tècniques, pàg. 68.",
    esPregunta: false,
    botonSiDestino: "s9000_comprova",
    imagenPath: "assets/resolucion/s9000_manual_p068.jpg",
  ),

  "inicio_desc_cerradas": PasoDiagnostico(
    id: "inicio_desc_cerradas",
    preguntaOInstruccion:
        "Desconnexió amb les portes tancades:\n\n1. A DDU -> Posada en marxa -> prem desconnexió automàtica.\n2. Selecciona a la pantalla el costat de portes per sortir.\n3. Obre la porta de cortesia prement el botó verd situat a la mateixa porta.",
    esPregunta: false,
    botonSiDestino: "fin_desc_cerradas",
    imagenPath: "assets/resolucion/s9000_desconexion_1.jpg",
  ),
  "fin_desc_cerradas": PasoDiagnostico(
    id: "fin_desc_cerradas",
    preguntaOInstruccion:
        "4. Posa el manipulador i el selector a 0, i retira la clau de govern.\n5. Surt per la porta de cortesia i prem el botó exterior de tancament.\n\nEl tren detectarà la sortida i desconnectarà les bateries.",
    esPregunta: false,
    imagenPath: "assets/resolucion/s9000_desconexion_2.jpg",
  ),

  "inicio_desc_abiertas": PasoDiagnostico(
    id: "inicio_desc_abiertas",
    preguntaOInstruccion:
        "Desconnexió amb les portes obertes:\n\n1. A DDU -> Posada en marxa -> prem desconnexió automàtica.\n2. Selecciona l’obertura del tren per tots dos costats.",
    esPregunta: false,
    botonSiDestino: "fin_desc_abiertas",
    imagenPath: "assets/resolucion/s9000_desconexion_1.jpg",
  ),
  "fin_desc_abiertas": PasoDiagnostico(
    id: "fin_desc_abiertas",
    preguntaOInstruccion:
        "3. Posa el manipulador i el selector a 0, i retira la clau de govern.\n4. Prem físicament el botó vermell de desconnexió de bateries al panell lateral.",
    esPregunta: false,
    imagenPath: "assets/resolucion/s9000_desconexion_2.jpg",
  ),

  "inicio_num_tren": PasoDiagnostico(
    id: "inicio_num_tren",
    preguntaOInstruccion:
        "Introduir el número de circulació:\n\n1. A la DDU, prem el botó de paràmetres.\n2. Amb la fletxa dreta cap avall, baixa de número de conductor a número de circulació.\n3. Prem el botó Enter per accedir al teclat de pantalla.",
    esPregunta: false,
    botonSiDestino: "fin_num_tren",
    imagenPath: "assets/resolucion/s9000_numero_circulacion_1.jpg",
  ),
  "fin_num_tren": PasoDiagnostico(
    id: "fin_num_tren",
    preguntaOInstruccion:
        "4. Utilitza els cursors intermedis per desplaçar-te pels números i prem Enter per seleccionar cada dígit.\n5. Quan acabis, desplaça’t a la icona d’acceptar (marca verda) i prem Enter per desar.",
    esPregunta: false,
    imagenPath: "assets/resolucion/s9000_numero_circulacion_2.jpg",
  ),

  // Ampliació S9000 contrastada amb el manual (2026-10-19).
  "s9000_pendent": PasoDiagnostico(
    id: "s9000_pendent",
    preguntaOInstruccion:
        "No s’ha confirmat la resolució. Comunica al CCM/Portacotxeres el cotxe, els avisos i les actuacions realitzades. Conserva les condicions dels aïllaments efectuats; aquest resultat no autoritza una marxa normal.",
    esPregunta: false,
  ),

  "s9000_comprova": PasoDiagnostico(
    id: "s9000_comprova",
    preguntaOInstruccion:
        "S’ha resolt el símptoma i s’han comprovat els equips afectats?",
    esPregunta: true,
    botonSiDestino: "s9000_resolt",
    botonNoDestino: "s9000_pendent",
  ),

  "s9000_resolt": PasoDiagnostico(
    id: "s9000_resolt",
    preguntaOInstruccion:
        "Símptoma resolt i comprovat. Informa el CCM de les actuacions i mantén les condicions dels aïllaments existents. La desaparició d’un avís no normalitza els llaços ni els equips anul·lats.",
    esPregunta: false,
  ),

  "s9000_govern": PasoDiagnostico(
    id: "s9000_govern",
    preguntaOInstruccion:
        "La clau de govern està connectada i el selector de marxa està correctament posicionat?\n\nFont: L4 Avaries tècniques, pàg. 5.",
    esPregunta: true,
    botonSiDestino: "pregunta_atp_s9000",
    botonNoDestino: "s9000_govern_accio",
    imagenPath: "assets/resolucion/s9000_manual_p005.jpg",
  ),

  "s9000_govern_accio": PasoDiagnostico(
    id: "s9000_govern_accio",
    preguntaOInstruccion:
        "Comprova la clau de govern i la posició del selector de marxa. Si el tren no respon a les ordres, comprova si una altra cabina resta habilitada.\n\nFont: L4 Avaries tècniques, pàg. 5.",
    esPregunta: false,
    opcions: [
      OpcioSac("Comprovar si s’ha resolt", "s9000_comprova"),
      OpcioSac("Cabina habilitada / no respon", "s9000_cabina"),
    ],
    imagenPath: "assets/resolucion/s9000_manual_p005.jpg",
  ),

  "s9000_mode_absent": PasoDiagnostico(
    id: "s9000_mode_absent",
    preguntaOInstruccion:
        "Comprova i selecciona el mode de conducció. Si no es recupera, comunica l’estat al CCM i coordina el mode degradat que correspongui. No confonguis absència de mode amb absència de codis.\n\nFont: L4 Avaries tècniques, pàg. 5.",
    esPregunta: false,
    opcions: [
      OpcioSac("Comprovar recuperació", "s9000_comprova"),
      OpcioSac("Mode especial autoritzat", "inicio_modo_especial_s9000"),
    ],
    imagenPath: "assets/resolucion/s9000_manual_p005.jpg",
  ),

  "s9000_pregunta_fre": PasoDiagnostico(
    id: "s9000_pregunta_fre",
    preguntaOInstruccion:
        "La DDU identifica un cotxe amb fre de servei aplicat i bloquejat (IOS207–211), o hi ha olor de sabata/fum sota el tren?\n\nFont: L4 Avaries tècniques, pàg. 72.",
    esPregunta: true,
    botonSiDestino: "inicio_freno_servicio",
    botonNoDestino: "pregunta_tren_stop_s9000",
    imagenPath: "assets/resolucion/s9000_manual_p072.jpg",
  ),

  "s9000_aire": PasoDiagnostico(
    id: "s9000_aire",
    preguntaOInstruccion:
        "Baixa pressió TDP: identifica l’origen. Una pressió baixa no és, per si sola, una avaria de fre de servei bloquejat.\n\nFont: L4 Avaries tècniques, pàg. 88.",
    esPregunta: false,
    opcions: [
      OpcioSac("Fuita localitzada / soroll de fuita", "s9000_fuita"),
      OpcioSac("Compressor en avaria (IOS221–223)", "s9000_compressor"),
      OpcioSac("Origen no identificat", "s9000_pendent"),
    ],
    imagenPath: "assets/resolucion/s9000_manual_p088.jpg",
  ),

  "s9000_fre_ok": PasoDiagnostico(
    id: "s9000_fre_ok",
    preguntaOInstruccion:
        "S’ha confirmat que el cotxe ha quedat desfrenat, tenint en compte que la DDU pot haver perdut la lectura?\n\nFont: L4 Avaries tècniques, pàg. 72.",
    esPregunta: true,
    botonSiDestino: "fin_freno_servicio",
    botonNoDestino: "s9000_fre_b4",
    imagenPath: "assets/resolucion/s9000_manual_p072.jpg",
  ),

  "s9000_fre_b4": PasoDiagnostico(
    id: "s9000_fre_b4",
    preguntaOInstruccion:
        "Si no es normalitza, el document preveu accedir a vies pel costat de V1 i girar B4 del cofre del cotxe afectat. Coordina amb CCM l’accés a vies i la maniobra.\n\nFont: L4 Avaries tècniques, pàg. 72.",
    esPregunta: false,
    botonSiDestino: "s9000_fre_b4_ok",
    imagenPath: "assets/resolucion/s9000_manual_p072.jpg",
  ),

  "s9000_fre_b4_ok": PasoDiagnostico(
    id: "s9000_fre_b4_ok",
    preguntaOInstruccion:
        "S’ha normalitzat el fre amb B4?\n\nFont: L4 Avaries tècniques, pàg. 72.",
    esPregunta: true,
    botonSiDestino: "fin_freno_servicio",
    botonNoDestino: "s9000_fre_b7",
    imagenPath: "assets/resolucion/s9000_manual_p072.jpg",
  ),

  "s9000_fre_b7": PasoDiagnostico(
    id: "s9000_fre_b7",
    preguntaOInstruccion:
        "Si B4 no normalitza el fre, el document preveu també B7.1 i B7.2 del cotxe afectat. Coordina la maniobra i verifica el resultat.\n\nFont: L4 Avaries tècniques, pàg. 72.",
    esPregunta: false,
    botonSiDestino: "s9000_fre_final_ok",
    imagenPath: "assets/resolucion/s9000_manual_p072.jpg",
  ),

  "s9000_fre_final_ok": PasoDiagnostico(
    id: "s9000_fre_final_ok",
    preguntaOInstruccion:
        "S’ha confirmat el desfrenament després de les maniobres?\n\nFont: L4 Avaries tècniques, pàg. 72.",
    esPregunta: true,
    botonSiDestino: "fin_freno_servicio",
    botonNoDestino: "s9000_pendent",
    imagenPath: "assets/resolucion/s9000_manual_p072.jpg",
  ),

  "s9000_b17_ok": PasoDiagnostico(
    id: "s9000_b17_ok",
    preguntaOInstruccion:
        "S’ha comprovat que l’estacionament està alliberat?\n\nFont: L4 Avaries tècniques, pàg. 73.",
    esPregunta: true,
    botonSiDestino: "s9000_b17_final",
    botonNoDestino: "s9000_pendent",
    imagenPath: "assets/resolucion/s9000_manual_p073.jpg",
  ),

  "s9000_b17_final": PasoDiagnostico(
    id: "s9000_b17_final",
    preguntaOInstruccion:
        "Alliberament mecànic confirmat. Mantén registrada B17 + sirgues i l’anul·lació del laç de tracció; coordina les condicions de circulació amb CCM. No és una sortida de marxa normal.\n\nFont: L4 Avaries tècniques, pàg. 73.",
    esPregunta: false,
    imagenPath: "assets/resolucion/s9000_manual_p073.jpg",
  ),

  "s9000_porta_no_tanca": PasoDiagnostico(
    id: "s9000_porta_no_tanca",
    preguntaOInstruccion:
        "Si la porta no tanca o la DDU continua indicant oberta, el document preveu desallotjar i anul·lar el llaç de portes, coordinat amb CCM. Indica que, si no s’ha aconseguit tancar, es tancarà automàticament en iniciar la marxa sense passatge. Comunica l’estat real i mantén les condicions de la maniobra.\n\nFont: L4 Avaries tècniques, pàg. 76.",
    esPregunta: false,
    imagenPath: "assets/resolucion/s9000_manual_p076.jpg",
  ),

  "s9000_eed_via": PasoDiagnostico(
    id: "s9000_eed_via",
    preguntaOInstruccion:
        "Comunica al CCM i dirigeix-te a normalitzar la porta. Assegura’t que cap passatger ha baixat a vies; pregunta al passatge si és necessari. Comprova la normalització de l’EED i del laç de portes; passa el manipulador per 0 abans de recuperar tracció.\n\nFont: L4 Avaries tècniques, pàg. 80.",
    esPregunta: false,
    botonSiDestino: "s9000_comprova",
    imagenPath: "assets/resolucion/s9000_detall_p080.jpg",
  ),

  "s9000_eed_andana": PasoDiagnostico(
    id: "s9000_eed_andana",
    preguntaOInstruccion:
        "A la pantalla d’alarmes de DDU1 corresponent al tirador, prem RECON. Si no hi ha visió de càmera, normalitza localment. Comprova EED, porta i laç; passa el manipulador per 0 abans de recuperar tracció.\n\nFont: L4 Avaries tècniques, pàg. 80.",
    esPregunta: false,
    botonSiDestino: "s9000_comprova",
    imagenPath: "assets/resolucion/s9000_detall_p080.jpg",
  ),

  "s9000_tirador_condicions": PasoDiagnostico(
    id: "s9000_tirador_condicions",
    preguntaOInstruccion:
        "Tirador d’alarma: el document indica que, en arrencar d’estació, obre el llaç si no s’han superat 15 km/h o no han transcorregut aproximadament 45 m. Si s’acciona en marxa, preveu continuar fins a la següent estació i rearmar estacionat a l’andana; una aturada al túnel obrirà el llaç fins a reposar-lo.\n\nFont: L4 Avaries tècniques, pàg. 83.",
    esPregunta: false,
    botonSiDestino: "s9000_tirador_ok",
    imagenPath: "assets/resolucion/s9000_manual_p083.jpg",
  ),

  "s9000_tirador_ok": PasoDiagnostico(
    id: "s9000_tirador_ok",
    preguntaOInstruccion:
        "S’ha pogut reposar el tirador i comprovar el resultat?\n\nFont: L4 Avaries tècniques, pàg. 83.",
    esPregunta: true,
    botonSiDestino: "s9000_comprova",
    botonNoDestino: "s9000_tirador_no_reposa",
    imagenPath: "assets/resolucion/s9000_manual_p083.jpg",
  ),

  "s9000_tirador_no_reposa": PasoDiagnostico(
    id: "s9000_tirador_no_reposa",
    preguntaOInstruccion:
        "Si algun tirador no es pot reposar, el document preveu desallotjar i anul·lar el laç de tiradors, coordinat amb CCM. Un tirador trencat no es resol repetint la reposició.\n\nFont: L4 Avaries tècniques, pàg. 83.",
    esPregunta: false,
    imagenPath: "assets/resolucion/s9000_manual_p083.jpg",
  ),

  "s9000_disj_ok": PasoDiagnostico(
    id: "s9000_disj_ok",
    preguntaOInstruccion:
        "Els disjuntors s’han connectat i es mantenen tancats?\n\nFont: L4 Avaries tècniques, pàg. 69.",
    esPregunta: true,
    botonSiDestino: "s9000_comprova",
    botonNoDestino: "s9000_disj_alternatives",
    imagenPath: "assets/resolucion/s9000_manual_p069.jpg",
  ),

  "s9000_disj_alternatives": PasoDiagnostico(
    id: "s9000_disj_alternatives",
    preguntaOInstruccion:
        "Coordina amb CCM/Portacotxeres. El document preveu valorar els tèrmics 16F66 i 16F67 del MB de la semiunitat afectada i tornar a provar el rearme; com a últim recurs, mode socors. No és un aïllament automàtic de la semiunitat.\n\nFont: L4 Avaries tècniques, pàg. 69.",
    esPregunta: false,
    opcions: [
      OpcioSac("Comprovar després de l’actuació", "s9000_disj_final"),
      OpcioSac("Mode socors acordat", "inicio_modo_socorro"),
      OpcioSac("Pendent d’indicacions", "s9000_pendent"),
    ],
    imagenPath: "assets/resolucion/s9000_manual_p069.jpg",
  ),

  "s9000_disj_final": PasoDiagnostico(
    id: "s9000_disj_final",
    preguntaOInstruccion:
        "S’han recuperat els disjuntors després de l’actuació acordada?\n\nFont: L4 Avaries tècniques, pàg. 69.",
    esPregunta: true,
    botonSiDestino: "s9000_comprova",
    botonNoDestino: "s9000_pendent",
    imagenPath: "assets/resolucion/s9000_manual_p069.jpg",
  ),

  "s9000_convertidor": PasoDiagnostico(
    id: "s9000_convertidor",
    preguntaOInstruccion:
        "IOS25/26/27: identifica el convertidor auxiliar que no carrega bateria. El document preveu tirar el tèrmic corresponent 16F10 o 16F11 al remolc. Si no es normalitza, reset de bateries a final de línia. Amb un convertidor es mantenen els serveis al 100 % i cal anar a canvi aviat. Amb tots dos perduts, tracció i serveis de bateria són temporals; comunica l’abast al CCM.\n\nFont: L4 Avaries tècniques, pàg. 70.",
    esPregunta: false,
    opcions: [
      OpcioSac("Comprovar resultat", "s9000_comprova"),
      OpcioSac("Reset de bateries acordat", "inicio_reset_baterias"),
      OpcioSac("Dos convertidors perduts / pendent", "s9000_pendent"),
    ],
    imagenPath: "assets/resolucion/s9000_manual_p070.jpg",
  ),

  "s9000_compressor": PasoDiagnostico(
    id: "s9000_compressor",
    preguntaOInstruccion:
        "IOS221/222/223: identifica el compressor i el MA afectat. Si falla el master, l’altre entra automàticament. El document preveu tirar 11F4 Compressor Aire del MA afectat. TDP normal: 8–10 bar. Per sota de 6,5 bar aplica FE; si no es recupera cap compressor, cal remolcar. Nota del document: master 1 en dies imparells i master 2 en dies parells, segons data DDU.\n\nFont: L4 Avaries tècniques, pàg. 71.",
    esPregunta: false,
    opcions: [
      OpcioSac("Pressió recuperada i comprovada", "s9000_comprova"),
      OpcioSac("Cap compressor recuperat", "s9000_remolcada"),
      OpcioSac("Hi ha una fuita", "s9000_fuita"),
      OpcioSac("Origen no confirmat", "s9000_pendent"),
    ],
    imagenPath: "assets/resolucion/s9000_detall_p071.jpg",
  ),

  "s9000_fre_electric": PasoDiagnostico(
    id: "s9000_fre_electric",
    preguntaOInstruccion:
        "IOS88: pèrdua de fre elèctric en un o dos cotxes. Selecciona ATP o fes reset TBS si no es pot seleccionar. Si s’han perdut codis, el document preveu M+25 autoritzat i avançar uns metres per recuperar-los. Si no es normalitza, comprova equips de tracció inhibits i tracta-ho com a avaria de tracció.\n\nFont: L4 Avaries tècniques, pàg. 74.",
    esPregunta: false,
    opcions: [
      OpcioSac("Comprovar resultat", "s9000_comprova"),
      OpcioSac("Equip de tracció afectat", "s9000_traccio"),
      OpcioSac("Pèrdua de codis", "procedimiento_atp_s9000"),
    ],
    imagenPath: "assets/resolucion/s9000_manual_p074.jpg",
  ),

  "s9000_portes_seleccio": PasoDiagnostico(
    id: "s9000_portes_seleccio",
    preguntaOInstruccion:
        "No es permet seleccionar costat de portes (botó groc). Amb autorització del CCM, prem Tren Stop Deslocalitzat i torna a seleccionar el costat andana. Un cop seleccionat, normalitza Tren Stop Deslocalitzat. El document descriu que pot passar puntualment a L4 malgrat no disposar del sistema de control del costat d’obertura.\n\nFont: L4 Avaries tècniques, pàg. 77.",
    esPregunta: false,
    botonSiDestino: "s9000_comprova",
    imagenPath: "assets/resolucion/s9000_detall_p077.jpg",
  ),

  "s9000_portes_permis": PasoDiagnostico(
    id: "s9000_portes_permis",
    preguntaOInstruccion:
        "No hi ha permissió ATP: comprova la selecció del costat andana. Amb autorització CCM, passa a M+25 i prova; si no funciona, el document preveu moure el tren 1 metre i tornar a provar. Última opció: ME autoritzat. Si no funciona, desallotjament amb obertura local. Si tampoc obren amb els tiradors, tracta l’avaria KM0.\n\nFont: L4 Avaries tècniques, pàg. 78.",
    esPregunta: false,
    opcions: [
      OpcioSac("Comprovar resultat", "s9000_comprova"),
      OpcioSac("Tampoc obren amb tiradors", "s9000_km0"),
      OpcioSac("Mode especial autoritzat", "inicio_modo_especial_s9000"),
      OpcioSac("No resolt", "s9000_pendent"),
    ],
    imagenPath: "assets/resolucion/s9000_manual_p078.jpg",
  ),

  "s9000_km0": PasoDiagnostico(
    id: "s9000_km0",
    preguntaOInstruccion:
        "IOS75: discrepància V=0; el tren parat detecta moviment i no obren portes ni tiradors. El document preveu deixar caigut 16F120 Circuito V=0 km/h al remolc: només es podran obrir localment les portes del remolc amb tiradors/LOPS. Desallotjar i retirar el tren. Alternativa del document: desconnectar bateries per obrir totes les portes amb EED. Coordina l’opció amb CCM.\n\nFont: L4 Avaries tècniques, pàg. 79.",
    esPregunta: false,
    imagenPath: "assets/resolucion/s9000_manual_p079.jpg",
  ),

  "s9000_condemnar": PasoDiagnostico(
    id: "s9000_condemnar",
    preguntaOInstruccion:
        "Condemnar una porta: identifica la porta i obre el faldó. Si cal obrir-la, el document preveu desconnectar l’alimentació i fer un cicle d’obertura/tancament amb clau de quadradet sobre la lleva del motor. Per deixar-la condemnada: connector de comunicació desconnectat i alimentació connectada. Col·loca els adhesius de fora de servei. Comprova tancament i estat del laç.\n\nFont: L4 Avaries tècniques, pàg. 81.",
    esPregunta: false,
    botonSiDestino: "s9000_comprova",
    imagenPath: "assets/resolucion/s9000_detall_p081.jpg",
  ),

  "s9000_traccio": PasoDiagnostico(
    id: "s9000_traccio",
    preguntaOInstruccion:
        "IOS86: cotxe sense tracció i/o fre elèctric, sense obertura de disjuntors. Identifica el cotxe i la semiunitat. El document preveu tirar i rearmar 16F66 Equipo de Tracción 1 o 16F67 Equipo de Tracción 2 del MB de la semiunitat afectada.\n\nFont: L4 Avaries tècniques, pàg. 95.",
    esPregunta: false,
    botonSiDestino: "s9000_comprova",
    imagenPath: "assets/resolucion/s9000_manual_p095.jpg",
  ),

  "s9000_pantograf": PasoDiagnostico(
    id: "s9000_pantograf",
    preguntaOInstruccion:
        "IOS167–172: identifica el pantògraf no elevat amb ordre de pujar o aïllat. Comprova primer problemes elèctrics/catenària. Una creu vermella indica inhibició manual: a la pantalla corresponent, prem la icona de la semiunitat inhibida. Per baixar un sol pantògraf, el document preveu 16F60 del cotxe afectat o U21 del panell pneumàtic auxiliar.\n\nFont: L4 Avaries tècniques, pàg. 96.",
    esPregunta: false,
    botonSiDestino: "s9000_comprova",
    imagenPath: "assets/resolucion/s9000_detall_p096.jpg",
  ),

  "s9000_hvac": PasoDiagnostico(
    id: "s9000_hvac",
    preguntaOInstruccion:
        "Aire condicionat: desconnecta durant dues o tres estacions i reconnecta a PMM de DDU1. Si no es recupera, tira i rearma 16F38 del cotxe afectat. Després es pot provar 11F1 Climatización Línea 1 o 11F2 Línea 2. Si persisteix, valora temperatura interior i canvi de motors amb CCM.\n\nFont: L4 Avaries tècniques, pàg. 97.",
    esPregunta: false,
    botonSiDestino: "s9000_comprova",
    imagenPath: "assets/resolucion/s9000_manual_p097.jpg",
  ),

  "s9000_video": PasoDiagnostico(
    id: "s9000_video",
    preguntaOInstruccion:
        "Identifica les càmeres/equips afectats. Reseteja els equips corresponents amb 16F43 Pantallas video difusión, 16F44 Controlador Multimedia / Video Difusión o 16F47 Video Grabador. Comprova el resultat.\n\nFont: L4 Avaries tècniques, pàg. 98.",
    esPregunta: false,
    botonSiDestino: "s9000_comprova",
    imagenPath: "assets/resolucion/s9000_manual_p098.jpg",
  ),

  "s9000_anunciador": PasoDiagnostico(
    id: "s9000_anunciador",
    preguntaOInstruccion:
        "Anunciador o termòmetres no funcionen: el document preveu tirar 16F40 Megafonía e Interfonía del remolc o del MA corresponent. La central inclou costat de portes, termòmetres, interfonia, altaveus, micròfon, CESARES i bip-bip de portes.\n\nFont: L4 Avaries tècniques, pàg. 99.",
    esPregunta: false,
    botonSiDestino: "s9000_comprova",
    imagenPath: "assets/resolucion/s9000_manual_p099.jpg",
  ),

  "s9000_ddu": PasoDiagnostico(
    id: "s9000_ddu",
    preguntaOInstruccion:
        "DDU en negre: prova primer el botó d’encendre pantalla. El document preveu el tèrmic del MA corresponent: 16F103 = DDU1; 16F102 = DDU2. Atenció: el primer físicament és el de DDU2. Si la DDU no accepta ordres, comprova cabina habilitada. Si fallen les dues DDU i no es recuperen, mode socors.\n\nFont: L4 Avaries tècniques, pàg. 100.",
    esPregunta: false,
    opcions: [
      OpcioSac("Comprovar recuperació", "s9000_comprova"),
      OpcioSac("Cabina habilitada", "s9000_cabina"),
      OpcioSac("Dues DDU perdudes: mode socors", "inicio_modo_socorro"),
    ],
    imagenPath: "assets/resolucion/s9000_detall_p100.jpg",
  ),

  "s9000_cabina": PasoDiagnostico(
    id: "s9000_cabina",
    preguntaOInstruccion:
        "Missatge cabina habilitada i el tren no respon a les ordres: possible govern oblidat/trencat o commutador avariat. El document preveu tirar 16F50 al MA amb la cabina habilitada. Si manipulador o selector no són a 0, també 16F52 Órdenes de marcha. Si és necessari, mode socors.\n\nFont: L4 Avaries tècniques, pàg. 101.",
    esPregunta: false,
    opcions: [
      OpcioSac("Comprovar resultat", "s9000_comprova"),
      OpcioSac("Mode socors acordat", "inicio_modo_socorro"),
    ],
    imagenPath: "assets/resolucion/s9000_manual_p101.jpg",
  ),

  "s9000_fuita": PasoDiagnostico(
    id: "s9000_fuita",
    preguntaOInstruccion:
        "Localitza la fuita abans d’escollir les aixetes i anul·lacions. IOS218: TDP < 8 bar; IOS24/FE: TDP < 6,5 bar. L’anul·lació dels pressòstats de mínima només pot estar activada en una semiunitat.\n\nFont: L4 Avaries tècniques, pàg. 88.",
    esPregunta: false,
    opcions: [
      OpcioSac("Entre cotxes / enganxalls", "s9000_fuita_enganxall"),
      OpcioSac("En cotxe MB", "s9000_fuita_mb"),
      OpcioSac("En remolc R", "s9000_fuita_r"),
      OpcioSac("En cotxe MA", "s9000_fuita_ma"),
      OpcioSac("No localitzada", "s9000_pendent"),
    ],
    imagenPath: "assets/resolucion/s9000_manual_p088.jpg",
  ),

  "s9000_fuita_enganxall": PasoDiagnostico(
    id: "s9000_fuita_enganxall",
    preguntaOInstruccion:
        "Fuita entre cotxes/enganxalls: gira a horitzontal les aixetes col·laterals a la fuita per aïllar el tram. Ambdues parts queden alimentades pels dos compressors. Segons el document, aquest cas no requereix anul·lar llaços. Comprova que la pressió es recupera.\n\nFont: L4 Avaries tècniques, pàg. 89.",
    esPregunta: false,
    botonSiDestino: "s9000_comprova",
    imagenPath: "assets/resolucion/s9000_manual_p089.jpg",
  ),

  "s9000_fuita_mb": PasoDiagnostico(
    id: "s9000_fuita_mb",
    preguntaOInstruccion:
        "Fuita en MB: gira a horitzontal les aixetes col·laterals per aïllar el tram. Al cotxe afectat, gira B17 del panell inferior lateral costat V1 i allibera les sirgues. En actuar B17 cal anul·lar el llaç de tracció. No donis per normalitzat l’aïllament en desaparèixer l’avís.\n\nFont: L4 Avaries tècniques, pàg. 89.",
    esPregunta: false,
    botonSiDestino: "s9000_pendent",
    imagenPath: "assets/resolucion/s9000_manual_p089.jpg",
  ),

  "s9000_fuita_r": PasoDiagnostico(
    id: "s9000_fuita_r",
    preguntaOInstruccion:
        "Fuita en R: aïlla el tram amb les aixetes col·laterals horitzontals. Gira B17 i allibera sirgues del cotxe afectat. Cal anul·lar el llaç de tracció i el llaç d’Equip de fre perquè la lectura de TDP és al remolc. Coordina les condicions amb CCM.\n\nFont: L4 Avaries tècniques, pàg. 90.",
    esPregunta: false,
    botonSiDestino: "s9000_pendent",
    imagenPath: "assets/resolucion/s9000_manual_p090.jpg",
  ),

  "s9000_fuita_ma": PasoDiagnostico(
    id: "s9000_fuita_ma",
    preguntaOInstruccion:
        "Fuita en MA: aïlla el tram amb les aixetes col·laterals horitzontals. Gira B17 i allibera sirgues. Cal anul·lar tracció, Equip de fre i pressòstat de la semiunitat afectada (A/B) des del remolc. Només es pot anul·lar el pressòstat d’una semiunitat.\n\nFont: L4 Avaries tècniques, pàg. 90.",
    esPregunta: false,
    botonSiDestino: "s9000_pendent",
    imagenPath: "assets/resolucion/s9000_manual_p090.jpg",
  ),

  "s9000_remolcada": PasoDiagnostico(
    id: "s9000_remolcada",
    preguntaOInstruccion:
        "Remolcada: selecciona el tren sobre el qual s’actua. El tren de socors ha de circular en ME i iniciar mitjançant bloqueig telefònic centralitzat amb el tren que precedeix l’avariat. No acoblar mai elèctricament.\n\nFont: L4 Avaries tècniques, pàg. 92.",
    esPregunta: false,
    opcions: [
      OpcioSac("Tren de socors", "s9000_remolc_socors"),
      OpcioSac("Tren avariat", "s9000_remolc_avariat"),
      OpcioSac("Desacoblament", "s9000_desacoblament"),
    ],
    imagenPath: "assets/resolucion/s9000_manual_p092.jpg",
  ),

  "s9000_remolc_socors": PasoDiagnostico(
    id: "s9000_remolc_socors",
    preguntaOInstruccion:
        "Acosta’t marxa a la vista a 1 metre. Anul·la tracció per eliminar fre de retenció. Avança alternant punts 1 i 0 de tracció i dona punt enrere per assegurar l’acoblament. No acoblar elèctricament. Coordina totes les maniobres amb CCM i l’altre tren.\n\nFont: L4 Avaries tècniques, pàg. 92.",
    esPregunta: false,
    imagenPath: "assets/resolucion/s9000_manual_p092.jpg",
  ),

  "s9000_remolc_avariat": PasoDiagnostico(
    id: "s9000_remolc_avariat",
    preguntaOInstruccion:
        "Immobilitza amb estacionament; seccionadors a 0 a la testera d’acoblament. Espera confirmació d’acoblament. Segons l’avaria, connecta o no pneumàticament amb les aixetes. Anul·la tracció per eliminar retenció. Circula amb manipulador a 0, home mort premut i mode de conducció, segons coordinació del remolc.\n\nFont: L4 Avaries tècniques, pàg. 92.",
    esPregunta: false,
    imagenPath: "assets/resolucion/s9000_manual_p092.jpg",
  ),

  "s9000_desacoblament": PasoDiagnostico(
    id: "s9000_desacoblament",
    preguntaOInstruccion:
        "Prem el botó de desacoblament del panell esquerre i, mentre el mantens, acciona breument el manipulador entre 1 i 0 de tracció. El tren retrocedeix lleugerament fent el desacoblament mecànic. El document també preveu l’operació marxa enrere. Coordina la maniobra i comprova el desacoblament.\n\nFont: L4 Avaries tècniques, pàg. 93.",
    esPregunta: false,
    imagenPath: "assets/resolucion/s9000_manual_p093.jpg",
  ),

  "s9000_termics": PasoDiagnostico(
    id: "s9000_termics",
    preguntaOInstruccion:
        "Taules de tèrmics: selecciona el tipus de cotxe. Identifica sempre cotxe i tèrmic abans de l’actuació.\n\nFont: L4 Avaries tècniques, pàg. 84.",
    esPregunta: false,
    opcions: [
      OpcioSac("MA", "s9000_termics_ma"),
      OpcioSac("MB", "s9000_termics_mb"),
      OpcioSac("R", "s9000_termics_r"),
    ],
    imagenPath: "assets/resolucion/s9000_manual_p084.jpg",
    imatgesManual: const [
      ImatgePasManual(
        "assets/resolucion/s9000_manual_p067.jpg",
        "Localització dels armaris de tèrmics · manual original",
        null,
        "Armaris de tèrmics",
      ),
    ],
  ),

  "s9000_termics_ma": PasoDiagnostico(
    id: "s9000_termics_ma",
    preguntaOInstruccion:
        "Taula original de tèrmics del cotxe MA. A sota tens també la fotografia real dels tèrmics dels cotxes A. Amplia les imatges per identificar la referència.\n\nFont: L4 Avaries tècniques, pàg. 85.",
    esPregunta: false,
    imagenPath: "assets/resolucion/s9000_manual_p085.jpg",
    imatgesManual: const [
      ImatgePasManual(
        "assets/resolucion/termicos_9000.jpg",
        "Tèrmics dels cotxes A · fotografia real",
        null,
        "Cotxe MA",
      ),
    ],
  ),

  "s9000_termics_mb": PasoDiagnostico(
    id: "s9000_termics_mb",
    preguntaOInstruccion:
        "Taula original de tèrmics del cotxe MB. Amplia la imatge per identificar la referència.\n\nFont: L4 Avaries tècniques, pàg. 86.",
    esPregunta: false,
    imagenPath: "assets/resolucion/s9000_manual_p086.jpg",
  ),

  "s9000_termics_r": PasoDiagnostico(
    id: "s9000_termics_r",
    preguntaOInstruccion:
        "Taula original de tèrmics del cotxe R. Amplia la imatge per identificar la referència.\n\nFont: L4 Avaries tècniques, pàg. 87.",
    esPregunta: false,
    imagenPath: "assets/resolucion/s9000_manual_p087.jpg",
  ),

  "s9000_esquema": PasoDiagnostico(
    id: "s9000_esquema",
    preguntaOInstruccion:
        "Situació dels tiradors/intercomunicadors i localització d’armaris de tèrmics del S9000.\n\nFont: L4 Avaries tècniques, pàg. 67.",
    esPregunta: false,
    imagenPath: "assets/resolucion/s9000_manual_p067.jpg",
  ),

  "s9000_resum_fuites": PasoDiagnostico(
    id: "s9000_resum_fuites",
    preguntaOInstruccion:
        "Resum original de maniobres i llaços segons la ubicació de la fuita. Els números de la taula indiquen l’ordre d’actuació; una X indica que no correspon.\n\nFont: L4 Avaries tècniques, pàg. 91.",
    esPregunta: false,
    imagenPath: "assets/resolucion/s9000_manual_p091.jpg",
  ),

  "s9000_menu_0": PasoDiagnostico(
    id: "s9000_menu_0",
    preguntaOInstruccion: "Equips i serveis",
    esPregunta: false,
    opcions: [
      OpcioSac("Convertidor auxiliar", "s9000_convertidor"),
      OpcioSac("Compressor", "s9000_compressor"),
      OpcioSac("Fre elèctric", "s9000_fre_electric"),
      OpcioSac("Tracció sense obertura disjuntors", "s9000_traccio"),
      OpcioSac("Pantògraf", "s9000_pantograf"),
      OpcioSac("Aire condicionat", "s9000_hvac"),
      OpcioSac("Videovigilància", "s9000_video"),
      OpcioSac("Anunciador / termòmetres", "s9000_anunciador"),
      OpcioSac("DDU", "s9000_ddu"),
      OpcioSac("Cabina habilitada", "s9000_cabina"),
      OpcioSac("Esquema equips", "s9000_esquema"),
    ],
  ),

  "s9000_menu_1": PasoDiagnostico(
    id: "s9000_menu_1",
    preguntaOInstruccion: "Portes",
    esPregunta: false,
    opcions: [
      OpcioSac("Una porta no tanca", "inicio_lazo_puertas"),
      OpcioSac("No selecciona costat", "s9000_portes_seleccio"),
      OpcioSac("No permet permissió / obertura", "s9000_portes_permis"),
      OpcioSac("Relé KM0", "s9000_km0"),
      OpcioSac("Porta desbloquejada / EED", "procedimiento_eed_s9000"),
      OpcioSac("Condemnar una porta", "s9000_condemnar"),
    ],
  ),

  "s9000_menu_2": PasoDiagnostico(
    id: "s9000_menu_2",
    preguntaOInstruccion: "Aire i frens",
    esPregunta: false,
    opcions: [
      OpcioSac("Baixa pressió TDP", "s9000_aire"),
      OpcioSac("Fuita d’aire", "s9000_fuita"),
      OpcioSac("Resum de llaços per fuita", "s9000_resum_fuites"),
      OpcioSac("Fre de servei bloquejat", "inicio_freno_servicio"),
      OpcioSac("Estacionament aplicat", "pregunta_estacionamiento_s9000"),
    ],
  ),

  "s9000_menu_3": PasoDiagnostico(
    id: "s9000_menu_3",
    preguntaOInstruccion: "Remolcada i desacoblament",
    esPregunta: false,
    opcions: [
      OpcioSac("Remolcada", "s9000_remolcada"),
      OpcioSac("Desacoblament", "s9000_desacoblament"),
    ],
  ),
};
