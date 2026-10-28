part of 's2100_data.dart';

class CasellaSac {
  final int numero;
  final String text;
  final String? desti;
  const CasellaSac(this.numero, this.text, this.desti);
}

const casellesSac2100 = <CasellaSac>[
  CasellaSac(1, "Disjuntor", "procedimiento_rearme_disyuntor"),
  CasellaSac(2, "Equip tracció inhibit", "sac02"),
  CasellaSac(3, "Equip tracció aïllat", "sac03"),
  CasellaSac(4, "Tensió nul·la", "procedimiento_tension_nula"),
  CasellaSac(5, "Fusible convertidor", "sac05"),
  CasellaSac(6, "Faltà convertidor", "sac06"),
  CasellaSac(7, "Comandament portes", "sac07"),
  CasellaSac(8, "Porta oberta", "procedimiento_puertas_fallo"),
  CasellaSac(9, "Miralls retrovisor", "sac09"),
  CasellaSac(10, "", null),
  CasellaSac(11, "", null),
  CasellaSac(12, "Fallada pantògraf", "sac12"),
  CasellaSac(13, "Fre estacionament", "sac13"),
  CasellaSac(14, "Fallada fre pneumàtic", "sac14"),
  CasellaSac(15, "Anul·lació fre de servei", "sac15"),
  CasellaSac(16, "(Anomalia) antipatinatge / antibloqueig", "sac16"),
  CasellaSac(17, "Suspensió pneumàtica", "sac17_pendent"),
  CasellaSac(18, "Aire condicionat", "sac18_pendent"),
  CasellaSac(19, "Tèrmics", "sac19"),
  CasellaSac(20, "Tèrmic compressor", "sac20"),
  CasellaSac(21, "Avaria compressor", "sac21"),
  CasellaSac(22, "Tirador alarma accionat", "procedimiento_tirador"),
  CasellaSac(23, "Equip tren-stop", "procedimiento_tren_stop_rearme"),
  CasellaSac(24, "Llaç d’emergència", "sac24"),
  CasellaSac(25, "Avaria megafonia", "sac25"),
  CasellaSac(26, "Avaria caixa negra", "sac26"),
  CasellaSac(27, "Avaria Agate Link", "sac27"),
  CasellaSac(28, "Absència d’enllumenat", "sac28_pendent"),
  CasellaSac(29, "Unitat seccionada", "sac29_pendent"),
  CasellaSac(30, "", null),
];

final Map<String, PasoDiagnostico> procedimientosSac2100 = {
  "sac05": PasoDiagnostico(
    id: "sac05",
    preguntaOInstruccion:
        "SAC 05 · Fusible convertidor\n\nEl fusible s’ha fos: el convertidor NO rearmarà. Retira el tren al més aviat possible. Circular amb un únic convertidor és crític en S2100: desallotja al moment. Desconnecta llums, aire condicionat i megafonia i coordina la retirada amb CCM/Portacotxeres.\n\nFont: L4 Avaries tècniques, pàg. 23.",
    esPregunta: false,
  ),
  "sac06": PasoDiagnostico(
    id: "sac06",
    preguntaOInstruccion:
        "SAC 06 · Fallada convertidor\n\nComprova degradació d’aire condicionat / enllumenat, amperímetre de bateria a descàrrega (A) i voltímetre de bateria inferior a 87 V (B) a la unitat afectada.\n\nAmb un únic convertidor, desallotja al moment i coordina retirada al més aviat possible. Desconnecta llums, aire condicionat i megafonia.\n\nFont: L4 Avaries tècniques, pàg. 23.",
    esPregunta: false,
    botonSiDestino: "sac06_con",
    imagenPath: "manual/s2100/sac_06/instruments-bateria.png",
  ),
  "sac09": PasoDiagnostico(
    id: "sac09",
    preguntaOInstruccion:
        "SAC 09 · Miralls retrovisors\n\nAmb fuita al quadre pneumàtic de cabina pot faltar aire per obrir el mirall. Identifica i gira l’aixeta corresponent del quadre pneumàtic. No és la prova de velocitat del SAC 26.\n\nFont: L4 Avaries tècniques, pàg. 57.",
    esPregunta: false,
    botonSiDestino: "sac09_ok",
  ),
  "sac15": PasoDiagnostico(
    id: "sac15",
    preguntaOInstruccion:
        "SAC 15 · Anul·lació fre de servei\n\nEl fre de servei és el fre pneumàtic. L’avís informa que està anul·lat; no ordena tornar-lo a anul·lar. Conserva les condicions d’aïllament i llaç de fre de la maniobra realitzada.\n\nFont: criteri operatiu confirmat; actuació B12 a la pàg. 35.",
    esPregunta: false,
    opcions: [
      OpcioSac("Hi ha una fallada de fre pneumàtic per resoldre", "sac14"),
      OpcioSac(
        "L’anul·lació ja s’ha realitzat · informar CCM",
        "sac15_informat",
      ),
      OpcioSac("No es coneix la causa de l’anul·lació", "sac_pendent"),
    ],
  ),
  "sac17_pendent": PasoDiagnostico(
    id: "sac17_pendent",
    preguntaOInstruccion:
        "SAC 17 · Suspensió pneumàtica\n\nProcediment pendent d’incorporar. Identifica el cotxe i la informació del DISPLAY i comunica el cas al CCM/Portacotxeres. No s’assigna una maniobra automàtica.",
    esPregunta: false,
  ),
  "sac18_pendent": PasoDiagnostico(
    id: "sac18_pendent",
    preguntaOInstruccion:
        "SAC 18 · Aire condicionat\n\nProcediment pendent d’incorporar. Identifica el cotxe i la informació del DISPLAY i comunica el cas al CCM/Portacotxeres. No s’assigna una maniobra automàtica.",
    esPregunta: false,
  ),
  "sac25": PasoDiagnostico(
    id: "sac25",
    preguntaOInstruccion:
        "SAC 25 · Avaria megafonia\n\nQuin símptoma presenta?\n\nFont: L4 Avaries tècniques, pàg. 46–48.",
    esPregunta: false,
    opcions: [
      OpcioSac("No funciona el bip-bip de portes", "sac25_iris"),
      OpcioSac("No anuncia correctament les estacions", "sac25_edp"),
      OpcioSac("No identificat", "sac_pendent"),
    ],
  ),
  "sac26": PasoDiagnostico(
    id: "sac26",
    preguntaOInstruccion:
        "SAC 26 · Avaria caixa negra\n\nProva de miralls: estacionat a l’andana i amb selecció de portes, inicia la marxa amb el mirall obert. Aproximadament a 5 km/h s’ha de tancar.\n\nLa prova comprova que el tren reconeix que ja no està a velocitat 0; no és la fuita pneumàtica del SAC 09.\n\nFont: L4 Avaries tècniques, pàg. 49.",
    esPregunta: false,
    botonSiDestino: "sac26_mirall",
  ),
  "sac27": PasoDiagnostico(
    id: "sac27",
    preguntaOInstruccion:
        "SAC 27 · Avaria Agate Link\n\nQuin comportament addicional observes? No es fa reset de bateries de manera habitual: una RIOM afectada pot influir en la PMA.\n\nFont: L4 Avaries tècniques, pàg. 50.",
    esPregunta: false,
    opcions: [
      OpcioSac("DISPLAY congelat", "sac27_display"),
      OpcioSac("El tren no tracciona", "sac27_traccio"),
      OpcioSac("DISPLAY marca pèrdua RIOM", "sac27_riom"),
      OpcioSac("RIOM afecta PMA / equips desconnectats", "sac27_pma"),
      OpcioSac("No identificat", "sac_pendent"),
    ],
  ),
  "sac28_pendent": PasoDiagnostico(
    id: "sac28_pendent",
    preguntaOInstruccion:
        "SAC 28 · Absència d’enllumenat\n\nProcediment pendent d’incorporar. Identifica el cotxe i la informació del DISPLAY i comunica el cas al CCM/Portacotxeres. No s’assigna una maniobra automàtica.",
    esPregunta: false,
  ),
  "sac29_pendent": PasoDiagnostico(
    id: "sac29_pendent",
    preguntaOInstruccion:
        "SAC 29 · Unitat seccionada\n\nProcediment pendent d’incorporar. Identifica el cotxe i la informació del DISPLAY i comunica el cas al CCM/Portacotxeres. No s’assigna una maniobra automàtica.",
    esPregunta: false,
  ),
  "sac_pendent": PasoDiagnostico(
    id: "sac_pendent",
    preguntaOInstruccion:
        "No s’ha confirmat la resolució. Conserva les condicions de les actuacions realitzades i comunica al CCM/Portacotxeres els avisos i el cotxe identificat. No es dona autorització de marxa.\n\nFont: L4 Avaries tècniques, pàg. 3–5.",
    esPregunta: false,
  ),
  "sac_resultat_confirmat": PasoDiagnostico(
    id: "sac_resultat_confirmat",
    preguntaOInstruccion:
        "Has confirmat la resolució del símptoma comprovat. Això no normalitza els aïllaments ni elimina les condicions operatives: comunica les actuacions al CCM. No equival a una autorització de marxa normal.\n\nFont: L4 Avaries tècniques, pàg. 3–5.",
    esPregunta: false,
  ),
  "sac_identificada": PasoDiagnostico(
    id: "sac_identificada",
    preguntaOInstruccion:
        "Selecciona l’alarma concreta que veus al SAC. No la dedueixis únicament del símptoma.",
    esPregunta: false,
    opcions: [
      OpcioSac("01 · Disjuntor", "procedimiento_rearme_disyuntor"),
      OpcioSac("02 · Equip tracció inhibit", "sac02"),
      OpcioSac("03 · Equip tracció aïllat", "sac03"),
      OpcioSac("04 · Tensió nul·la", "procedimiento_tension_nula"),
      OpcioSac("05 · Fusible convertidor", "sac05"),
      OpcioSac("06 · Faltà convertidor", "sac06"),
      OpcioSac("07 · Comandament portes", "sac07"),
      OpcioSac("08 · Porta oberta", "procedimiento_puertas_fallo"),
      OpcioSac("09 · Miralls retrovisor", "sac09"),
      OpcioSac("12 · Fallada pantògraf", "sac12"),
      OpcioSac("13 · Fre estacionament", "sac13"),
      OpcioSac("14 · Fallada fre pneumàtic", "sac14"),
      OpcioSac("15 · Anul·lació fre de servei", "sac15"),
      OpcioSac("16 · (Anomalia) antipatinatge / antibloqueig", "sac16"),
      OpcioSac("17 · Suspensió pneumàtica", "sac17_pendent"),
      OpcioSac("18 · Aire condicionat", "sac18_pendent"),
      OpcioSac("19 · Tèrmics", "sac19"),
      OpcioSac("20 · Tèrmic compressor", "sac20"),
      OpcioSac("21 · Avaria compressor", "sac21"),
      OpcioSac("22 · Tirador alarma accionat", "procedimiento_tirador"),
      OpcioSac("23 · Equip tren-stop", "procedimiento_tren_stop_rearme"),
      OpcioSac("24 · Llaç d’emergència", "sac24"),
      OpcioSac("25 · Avaria megafonia", "sac25"),
      OpcioSac("26 · Avaria caixa negra", "sac26"),
      OpcioSac("27 · Avaria Agate Link", "sac27"),
      OpcioSac("28 · Absència d’enllumenat", "sac28_pendent"),
      OpcioSac("29 · Unitat seccionada", "sac29_pendent"),
    ],
  ),
  "sac_bahaste_identificada": PasoDiagnostico(
    id: "sac_bahaste_identificada",
    preguntaOInstruccion: "El SAC o el DISPLAY identifica una avaria concreta?",
    esPregunta: true,
    botonSiDestino: "sac_identificada",
    botonNoDestino: "inicio_no_desfrena",
  ),
  "sac_pedet_identificada": PasoDiagnostico(
    id: "sac_pedet_identificada",
    preguntaOInstruccion: "El SAC o el DISPLAY identifica una avaria concreta?",
    esPregunta: true,
    botonSiDestino: "sac_identificada",
    botonNoDestino: "inicio_no_tracciona",
  ),
  "sac01_comprova": PasoDiagnostico(
    id: "sac01_comprova",
    preguntaOInstruccion: "S’ha connectat el disjuntor?",
    esPregunta: true,
    botonSiDestino: "sac01_recuperacio",
    botonNoDestino: "sac01_reset",
  ),
  "sac01_recuperacio": PasoDiagnostico(
    id: "sac01_recuperacio",
    preguntaOInstruccion:
        "Comprova el DISPLAY i la recuperació de la tracció. S’ha recuperat el funcionament?",
    esPregunta: true,
    botonSiDestino: "sac_resultat_confirmat",
    botonNoDestino: "sac_pendent",
  ),
  "sac01_reset": PasoDiagnostico(
    id: "sac01_reset",
    preguntaOInstruccion:
        "Reset de bateries, coordinat amb Portacotxeres; preferiblement a final de línia o via de maniobra pel risc de no reconnectar.\n\n1. DES P.M.A. i espera la desconnexió dels equips.\n2. DES Bateria.\n3. CON Bateria.\n4. CON P.M.A. i espera la connexió dels equips.\n5. Amb clau de govern, comprova al DISPLAY la connexió dels equips. Si algun resta desconnectat, connecta l’element individualment d’acord amb Portacotxeres.\n\nFont: L4 Avaries tècniques, pàg. 15–16.",
    esPregunta: false,
    botonSiDestino: "sac01_despres_reset",
    imatgesManual: imatgesManual2100["sac01_reset"]!,
  ),
  "sac01_despres_reset": PasoDiagnostico(
    id: "sac01_despres_reset",
    preguntaOInstruccion:
        "Després del reset de bateries, s’ha connectat el disjuntor?",
    esPregunta: true,
    botonSiDestino: "sac01_recuperacio",
    botonNoDestino: "sac_pendent",
  ),
  "sac02": PasoDiagnostico(
    id: "sac02",
    preguntaOInstruccion:
        "SAC 02 · Equip tracció inhibit\n\nQuin abast mostra el DISPLAY?",
    esPregunta: false,
    opcions: [
      OpcioSac("Un cotxe inhibit", "sac02_un"),
      OpcioSac("Tots els cotxes inhibits", "sac02_tots"),
      OpcioSac("No identificat", "sac_pendent"),
    ],
  ),
  "sac02_un": PasoDiagnostico(
    id: "sac02_un",
    preguntaOInstruccion:
        "Passa tot per 0, incloent govern.\n\nAmb un únic cotxe inhibit, el tren pot continuar amb passatge; cal avisar Portacotxeres. No extrapolar a diversos cotxes.\n\nFont: L4 Avaries tècniques, pàg. 18.",
    esPregunta: false,
    botonSiDestino: "sac02_un_ok",
    imatgesManual: imatgesManual2100["sac02_un"]!,
  ),
  "sac02_un_ok": PasoDiagnostico(
    id: "sac02_un_ok",
    preguntaOInstruccion:
        "El cotxe ha deixat d’aparèixer inhibit després de passar tot per 0?",
    esPregunta: true,
    botonSiDestino: "sac02_recuperat",
    botonNoDestino: "sac02_seguiment",
  ),
  "sac02_seguiment": PasoDiagnostico(
    id: "sac02_seguiment",
    preguntaOInstruccion:
        "Amb un únic cotxe inhibit, el tren pot continuar amb passatge i cal avisar Portacotxeres. La recuperació de la cadena es fa d’acord amb aquest personal, habitualment per ells.\n\nSi la inhibició repetitiva s’ha produït 3 vegades, correspon aïllar la cadena de tracció afectada.\n\nFont: L4 Avaries tècniques, pàg. 18.",
    esPregunta: false,
    opcions: [
      OpcioSac("Portacotxeres acorda recuperar la cadena", "sac02_recuperar"),
      OpcioSac("La inhibició es repeteix 3 vegades", "sac02_tres_inhibicions"),
      OpcioSac(
        "No es decideix recuperar / pendent d’acord",
        "sac02_continuitat",
      ),
    ],
  ),
  "sac02_recuperar": PasoDiagnostico(
    id: "sac02_recuperar",
    preguntaOInstruccion:
        "Recuperació de la cadena de tracció del cotxe identificat, d’acord amb Portacotxeres:\n\n1. Baixa 1F17 (A.C. cofre motor tracció).\n2. Polsa 1F12 vermell (alimentació equip fre).\n3. Polsa 1F12 verd (alimentació equip fre).\n4. Puja 1F17.\n\nFont: L4 Avaries tècniques, pàg. 18.",
    esPregunta: false,
    botonSiDestino: "sac02_recuperar_ok",
    imatgesManual: imatgesManual2100["sac02_seguiment"]!,
  ),
  "sac02_recuperar_ok": PasoDiagnostico(
    id: "sac02_recuperar_ok",
    preguntaOInstruccion: "El cotxe ha deixat d’aparèixer inhibit?",
    esPregunta: true,
    botonSiDestino: "sac02_recuperat",
    botonNoDestino: "sac02_persisteix",
  ),
  "sac02_recuperat": PasoDiagnostico(
    id: "sac02_recuperat",
    preguntaOInstruccion:
        "El cotxe ja no apareix inhibit. La inhibició s’ha repetit 3 vegades?",
    esPregunta: true,
    botonSiDestino: "sac02_tres_inhibicions",
    botonNoDestino: "sac_resultat_confirmat",
  ),
  "sac02_persisteix": PasoDiagnostico(
    id: "sac02_persisteix",
    preguntaOInstruccion:
        "El cotxe continua inhibit. La inhibició s’ha repetit 3 vegades?",
    esPregunta: true,
    botonSiDestino: "sac02_tres_inhibicions",
    botonNoDestino: "sac02_continuitat",
  ),
  "sac02_tres_inhibicions": PasoDiagnostico(
    id: "sac02_tres_inhibicions",
    preguntaOInstruccion:
        "La inhibició repetitiva 3 vegades comporta aïllar la cadena de tracció afectada. Coordina l’actuació amb Portacotxeres. No és un aïllament automàtic d’una semiunitat.\n\nFont: L4 Avaries tècniques, pàg. 18.",
    esPregunta: false,
  ),
  "sac02_continuitat": PasoDiagnostico(
    id: "sac02_continuitat",
    preguntaOInstruccion:
        "Amb un únic cotxe inhibit, el manual permet continuar amb passatge i avisar Portacotxeres. Mantén registrada la incidència: no s’ha confirmat recuperació. Si arriba a 3 inhibicions repetitives, correspon aïllar la cadena afectada d’acord amb Portacotxeres.\n\nFont: L4 Avaries tècniques, pàg. 18.",
    esPregunta: false,
  ),
  "sac02_tots": PasoDiagnostico(
    id: "sac02_tots",
    preguntaOInstruccion:
        "Tots els cotxes inhibits. Si apareix SAC 01, resol primer el disjuntor. Si apareix SAC 13, revisa el fre d’estacionament i la causa corresponent.\n\nFont: L4 Avaries tècniques, pàg. 19.",
    esPregunta: false,
    imatgesManual: imatgesManual2100["sac02_tots"]!,
    opcions: [
      OpcioSac("SAC 01 · Disjuntor", "procedimiento_rearme_disyuntor"),
      OpcioSac("SAC 13 · Fre estacionament", "sac13"),
      OpcioSac("Cap dels anteriors · revisar selector", "sac02_selector"),
    ],
  ),
  "sac02_selector": PasoDiagnostico(
    id: "sac02_selector",
    preguntaOInstruccion:
        "El selector de marxa és en una posició diferent de 0?",
    esPregunta: true,
    botonSiDestino: "sac02_reset",
    botonNoDestino: "sac02_selector_normalitzar",
  ),
  "sac02_selector_normalitzar": PasoDiagnostico(
    id: "sac02_selector_normalitzar",
    preguntaOInstruccion:
        "Revisa i situa el selector de marxa en una posició diferent de 0.\n\nFont: L4 Avaries tècniques, pàg. 19.",
    esPregunta: false,
    botonSiDestino: "sac02_selector_ok",
  ),
  "sac02_selector_ok": PasoDiagnostico(
    id: "sac02_selector_ok",
    preguntaOInstruccion:
        "S’han recuperat els equips després de revisar el selector?",
    esPregunta: true,
    botonSiDestino: "sac_resultat_confirmat",
    botonNoDestino: "sac02_reset",
  ),
  "sac02_reset": PasoDiagnostico(
    id: "sac02_reset",
    preguntaOInstruccion:
        "Reset de bateries, coordinat amb Portacotxeres; preferiblement a final de línia o via de maniobra pel risc de no reconnectar.\n\n1. DES P.M.A. i espera la desconnexió dels equips.\n2. DES Bateria.\n3. CON Bateria.\n4. CON P.M.A. i espera la connexió dels equips.\n5. Amb clau de govern, comprova al DISPLAY la connexió dels equips. Si algun resta desconnectat, connecta l’element individualment d’acord amb Portacotxeres.\n\nFont: L4 Avaries tècniques, pàg. 15–16.\n\nSi després de les proves resten dos o tres equips inhibits, continuar sense passatge, coordinat amb CCM/Portacotxeres (pàg. 19).",
    esPregunta: false,
    botonSiDestino: "sac02_reset_resultat",
    imatgesManual: imatgesManual2100["sac02_reset"]!,
  ),
  "sac02_reset_resultat": PasoDiagnostico(
    id: "sac02_reset_resultat",
    preguntaOInstruccion: "Quin estat mostra ara el DISPLAY?",
    esPregunta: false,
    opcions: [
      OpcioSac(
        "Tots recuperats i funcionament comprovat",
        "sac_resultat_confirmat",
      ),
      OpcioSac("Resta un cotxe inhibit", "sac02_un"),
      OpcioSac("Resten dos o tres equips inhibits", "sac02_sense_passatge"),
      OpcioSac("Un altre resultat / no identificat", "sac_pendent"),
    ],
  ),
  "sac02_sense_passatge": PasoDiagnostico(
    id: "sac02_sense_passatge",
    preguntaOInstruccion:
        "Després de les proves resten dos o tres equips inhibits: continuar SENSE PASSATGE segons el manual, coordinat amb CCM/Portacotxeres. No es considera recuperació confirmada.\n\nFont: L4 Avaries tècniques, pàg. 19.",
    esPregunta: false,
  ),
  "sac03": PasoDiagnostico(
    id: "sac03",
    preguntaOInstruccion:
        "SAC 03 · Aïllat no és inhibit. Quin abast mostra el DISPLAY?\n\nFont: L4 Avaries tècniques, pàg. 20–21.",
    esPregunta: false,
    opcions: [
      OpcioSac("Un cotxe", "sac03_un"),
      OpcioSac("Dos cotxes", "sac03_dos"),
      OpcioSac("Tots els cotxes", "sac03_tots"),
      OpcioSac("No identificat", "sac_pendent"),
    ],
  ),
  "sac03_un": PasoDiagnostico(
    id: "sac03_un",
    preguntaOInstruccion:
        "El DISPLAY identifica un cotxe motor en vermell: avaria important de la cadena de tracció. Amb un sol cotxe motor aïllat es pot continuar amb passatge; avisa Portacotxeres. Habitualment es va a canvi de motors a Trinitat Nova per normalitzar el cofre ONIX. Si apareix un segon cotxe aïllat, desallotjar i anar a canvi.\n\nFont: L4 Avaries tècniques, pàg. 20.",
    esPregunta: false,
    opcions: [
      OpcioSac(
        "Valorar reset en terminal amb Portacotxeres",
        "sac03_reset_acord",
      ),
      OpcioSac("Apareix un segon cotxe aïllat", "sac03_dos"),
      OpcioSac(
        "Continuïtat amb un únic cotxe motor aïllat",
        "sac03_continuitat",
      ),
    ],
    imatgesManual: imatgesManual2100["sac03_un"]!,
  ),
  "sac03_dos": PasoDiagnostico(
    id: "sac03_dos",
    preguntaOInstruccion:
        "Quan s’aïlla un segon cotxe, el manual recomana desallotjar i anar a canvi. Coordina amb CCM/Portacotxeres.\n\nFont: L4 Avaries tècniques, pàg. 20.",
    esPregunta: false,
  ),
  "sac03_tots": PasoDiagnostico(
    id: "sac03_tots",
    preguntaOInstruccion:
        "Tots els cotxes apareixen aïllats al DISPLAY. Pot passar durant la posada en marxa si es mou el selector sense prou pressió TDP.\n\nDesconnecta PMA per baixar pantògrafs i comprova el voltímetre de línia.\n\nFont: L4 Avaries tècniques, pàg. 21.",
    esPregunta: false,
    botonSiDestino: "sac03_zero",
    imatgesManual: imatgesManual2100["sac03_tots"]!.take(1).toList(),
  ),
  "sac04_externa": PasoDiagnostico(
    id: "sac04_externa",
    preguntaOInstruccion:
        "Espera normalització. Si algun equip no recupera, la fitxa preveu connexió manual a P.M.M., coordinada amb CCM/Portacotxeres.\n\nFont: L4 Avaries tècniques, pàg. 22.",
    esPregunta: false,
    botonSiDestino: "sac04_ok",
  ),
  "sac04_terminal": PasoDiagnostico(
    id: "sac04_terminal",
    imatgesManual: imatgesManual2100["sac04_terminal"]!,
    preguntaOInstruccion:
        "Possible desconnexió involuntària en treure govern: reconnecta mitjançant PMA d’acord amb CCM/Portacotxeres.\n\nFont: L4 Avaries tècniques, pàg. 22.",
    esPregunta: false,
    botonSiDestino: "sac04_ok",
  ),
  "sac04_ok": PasoDiagnostico(
    id: "sac04_ok",
    preguntaOInstruccion:
        "S’ha resolt el símptoma després de l’actuació?\n\nFont: L4 Avaries tècniques, pàg. 22.",
    esPregunta: true,
    botonSiDestino: "sac_resultat_confirmat",
    botonNoDestino: "sac_pendent",
  ),
  "sac07_ok": PasoDiagnostico(
    id: "sac07_ok",
    preguntaOInstruccion:
        "S’ha resolt el símptoma després de l’actuació?\n\nFont: L4 Avaries tècniques, pàg. 25.",
    esPregunta: true,
    botonSiDestino: "sac_resultat_confirmat",
    botonNoDestino: "sac_pendent",
  ),
  "sac22_ok": PasoDiagnostico(
    id: "sac22_ok",
    preguntaOInstruccion:
        "S’ha resolt el símptoma després de l’actuació?\n\nFont: L4 Avaries tècniques, pàg. 43.",
    esPregunta: true,
    botonSiDestino: "sac_resultat_confirmat",
    botonNoDestino: "sac_pendent",
  ),
  "sac08_persisteix": PasoDiagnostico(
    id: "sac08_persisteix",
    preguntaOInstruccion:
        "Si continua marcant portes, el manual indica desallotjar, anul·lar llaç de portes i canvi/retirada amb CCM. No es dona una sortida de marxa normal.\n\nFont: L4 Avaries tècniques, pàg. 26.",
    esPregunta: false,
  ),
  "sac12": PasoDiagnostico(
    id: "sac12",
    imatgesManual: imatgesManual2100["sac12"]!,
    preguntaOInstruccion:
        "SAC 12 · Identifica el cotxe al DISPLAY. Comprova connexió del pantògraf a posada en marxa i la seva aixeta. Quan sigui possible, verifica visualment la posició.\n\nFont: L4 Avaries tècniques, pàg. 30.",
    esPregunta: false,
    botonSiDestino: "sac12_ok",
  ),
  "sac12_ok": PasoDiagnostico(
    id: "sac12_ok",
    preguntaOInstruccion:
        "S’ha resolt el símptoma després de l’actuació?\n\nFont: L4 Avaries tècniques, pàg. 30.",
    esPregunta: true,
    botonSiDestino: "sac_resultat_confirmat",
    botonNoDestino: "sac12_persisteix",
  ),
  "sac12_persisteix": PasoDiagnostico(
    id: "sac12_persisteix",
    preguntaOInstruccion:
        "Comprova amb CCM/Portacotxeres que cada semiunitat està alimentada almenys per un pantògraf. No pressuposis una avaria externa de catenària.\n\nFont: L4 Avaries tècniques, pàg. 30.",
    esPregunta: false,
  ),
  "sac13": PasoDiagnostico(
    id: "sac13",
    preguntaOInstruccion:
        "SAC 13 · Identifica al DISPLAY l’abast de l’avaria.\n\nFont: L4 Avaries tècniques, pàg. 32–34.",
    esPregunta: false,
    opcions: [
      OpcioSac("Tots els cotxes", "sac13_tots_pressio"),
      OpcioSac("Un cotxe", "sac13_un_pressio"),
      OpcioSac("No queda clar l’abast", "sac_pendent"),
    ],
  ),
  "sac13_tots_pressio": PasoDiagnostico(
    id: "sac13_tots_pressio",
    imatgesManual: imatgesManual2100["sac13_tots_pressio"]!,
    preguntaOInstruccion:
        "La pressió de canonada general és superior a 7 kg/cm²?\n\nFont: L4 Avaries tècniques, pàg. 32–33.",
    esPregunta: true,
    botonSiDestino: "sac13_tots_cabina",
    botonNoDestino: "sac_aire",
  ),
  "sac13_tots_cabina": PasoDiagnostico(
    id: "sac13_tots_cabina",
    imagenPath: "manual/s2100/sac_13/des-con-des.png",
    preguntaOInstruccion:
        "Repeteix DES. Si continua aplicat, prova CON i després DES. Comprova l’alliberament.\n\nFont: L4 Avaries tècniques, pàg. 32–33.",
    esPregunta: false,
    botonSiDestino: "sac13_tots_ok",
  ),
  "sac13_tots_ok": PasoDiagnostico(
    id: "sac13_tots_ok",
    preguntaOInstruccion:
        "S’ha alliberat realment l’estacionament i resolt el símptoma?\n\nFont: L4 Avaries tècniques, pàg. 32–33.",
    esPregunta: true,
    botonSiDestino: "sac_resultat_confirmat",
    botonNoDestino: "sac13_tots_persisteix",
  ),
  "sac13_un_pressio": PasoDiagnostico(
    id: "sac13_un_pressio",
    imatgesManual: imatgesManual2100["sac13_un_pressio"]!,
    preguntaOInstruccion:
        "La pressió de canonada general és superior a 7 kg/cm²?\n\nFont: L4 Avaries tècniques, pàg. 32–33.",
    esPregunta: true,
    botonSiDestino: "sac13_un_cabina",
    botonNoDestino: "sac_aire",
  ),
  "sac13_un_cabina": PasoDiagnostico(
    id: "sac13_un_cabina",
    imagenPath: "manual/s2100/sac_13/des-con-des.png",
    preguntaOInstruccion:
        "Repeteix DES. Si continua aplicat, prova CON i després DES. Comprova l’alliberament.\n\nFont: L4 Avaries tècniques, pàg. 32–33.",
    esPregunta: false,
    botonSiDestino: "sac13_un_ok",
  ),
  "sac13_un_ok": PasoDiagnostico(
    id: "sac13_un_ok",
    preguntaOInstruccion:
        "S’ha alliberat realment l’estacionament i resolt el símptoma?\n\nFont: L4 Avaries tècniques, pàg. 32–33.",
    esPregunta: true,
    botonSiDestino: "sac_resultat_confirmat",
    botonNoDestino: "pregunta_b19_es_ma",
  ),
  "sac13_tots_persisteix": PasoDiagnostico(
    id: "sac13_tots_persisteix",
    preguntaOInstruccion:
        "Revisa el bolet d’emergència de la cabina habilitada i rearma’l si està activat. Comprova de nou l’estacionament.\n\nFont: L4 Avaries tècniques, pàg. 32.",
    esPregunta: false,
    botonSiDestino: "sac13_bolet_ok",
    imatgesManual: imatgesManual2100["sac13_tots_persisteix"]!,
  ),
  "sac14": PasoDiagnostico(
    id: "sac14",
    preguntaOInstruccion:
        "SAC 14 · Localitza al DISPLAY el cotxe amb fallada de fre pneumàtic.\n\nFont: L4 Avaries tècniques, pàg. 35.",
    esPregunta: false,
  ),
  "sac14_1f11": PasoDiagnostico(
    id: "sac14_1f11",
    imagenPath: "manual/s2100/sac_14/termic-1f11.png",
    preguntaOInstruccion:
        "Al cotxe identificat, la fitxa preveu tirar el tèrmic 1F11. Coordina l’actuació i comprova el resultat.\n\nFont: L4 Avaries tècniques, pàg. 35.",
    esPregunta: false,
    botonSiDestino: "sac14_ok",
  ),
  "sac14_b12": PasoDiagnostico(
    id: "sac14_b12",
    preguntaOInstruccion:
        "Amb el cotxe identificat i coordinació CCM, utilitza les B12. El cotxe queda sense fre pneumàtic; aquest supòsit requereix anul·lar el llaç de fre per desfrenar.\n\nFont: L4 Avaries tècniques, pàg. 35.",
    esPregunta: false,
    botonSiDestino: "procedimiento_b12_esquema",
  ),
  "sac14_ok": PasoDiagnostico(
    id: "sac14_ok",
    preguntaOInstruccion:
        "S’ha resolt el símptoma després de l’actuació?\n\nFont: L4 Avaries tècniques, pàg. 35.",
    esPregunta: true,
    botonSiDestino: "sac_resultat_confirmat",
    botonNoDestino: "sac_pendent",
  ),
  "sac16": PasoDiagnostico(
    id: "sac16",
    preguntaOInstruccion:
        "SAC 16 · L’alarma és intermitent o contínua?\n\nFont: L4 Avaries tècniques, pàg. 36.",
    esPregunta: false,
    opcions: [
      OpcioSac("Intermitent", "sac16_observar"),
      OpcioSac("Contínua", "sac16_continua"),
      OpcioSac("No identificat", "sac_pendent"),
    ],
  ),
  "sac16_observar": PasoDiagnostico(
    id: "sac16_observar",
    preguntaOInstruccion:
        "Mantén en observació i avisa Portacotxeres.\n\nFont: L4 Avaries tècniques, pàg. 36.",
    esPregunta: false,
  ),
  "sac16_continua": PasoDiagnostico(
    id: "sac16_continua",
    preguntaOInstruccion:
        "Identifica el cotxe al DISPLAY. No és una incidència crítica: preferiblement a final de línia, reinicia l’electrònica de fre amb els tèrmics aplicables 1F09 / 1F11 / 1F13 (aquest últim exclusiu MA). No actuïs sobre elements que no corresponguin al cotxe.\n\nFont: L4 Avaries tècniques, pàg. 36.",
    esPregunta: false,
    botonSiDestino: "sac16_ok",
    imatgesManual: imatgesManual2100["sac16_continua"]!
        .where((i) => !i.path.contains("cofre-motor"))
        .toList(),
  ),
  "sac19": PasoDiagnostico(
    id: "sac19",
    preguntaOInstruccion:
        "SAC 19 · El tren detecta un tèrmic caigut. Consulta el DISPLAY per identificar el cotxe afectat i el tèrmic, si hi consta. Localitza l’armari corresponent i comprova quin tèrmic està caigut. Si no es pot rearmar o torna a disparar-se, no hi insisteixis: comunica-ho al CCM. Els procediments de 1F09 i 1F13 només s’apliquen si s’han identificat aquests tèrmics.\n\nFont: L4 Avaries tècniques, pàg. 37–40.",
    esPregunta: false,
    opcions: [
      OpcioSac("1F09 identificat · 19 + 13", "sac19_09"),
      OpcioSac("1F13 identificat al DISPLAY", "sac19_13"),
      OpcioSac("Un altre tèrmic identificat", "sac19_altre"),
      OpcioSac("No identificat", "sac_pendent"),
    ],
  ),
  "sac19_altre": PasoDiagnostico(
    id: "sac19_altre",
    preguntaOInstruccion:
        "Comunica al CCM el cotxe i la referència del tèrmic identificat al DISPLAY o a l'armari. No apliquis els procediments de 1F09, 1F13 ni de compressor a un tèrmic diferent. Si no es manté rearmat, no hi insisteixis. Consulta la identificació dels armaris a TÈRMICS de la pantalla inicial.",
    esPregunta: false,
  ),
  "sac19_09": PasoDiagnostico(
    id: "sac19_09",
    imagenPath: "manual/s2100/sac_19/armari-1f09.png",
    preguntaOInstruccion:
        "Confirma cotxe i 1F09. Prova de rearmar el tèrmic identificat.\n\nFont: L4 Avaries tècniques, pàg. 38.",
    esPregunta: false,
    botonSiDestino: "sac19_09_ok",
  ),
  "sac19_09_ok": PasoDiagnostico(
    id: "sac19_09_ok",
    preguntaOInstruccion:
        "S’ha resolt el símptoma després de l’actuació?\n\nFont: L4 Avaries tècniques, pàg. 38.",
    esPregunta: true,
    botonSiDestino: "sac_resultat_confirmat",
    botonNoDestino: "sac19_09_pendent",
  ),
  "sac19_11": PasoDiagnostico(
    id: "sac19_11",
    imagenPath: "manual/s2100/sac_14/termic-1f11.png",
    preguntaOInstruccion:
        "Confirma cotxe i 1F11. Prova de rearmar el tèrmic identificat.\n\nFont: L4 Avaries tècniques, pàg. 39.",
    esPregunta: false,
    botonSiDestino: "sac19_11_ok",
  ),
  "sac19_11_ok": PasoDiagnostico(
    id: "sac19_11_ok",
    preguntaOInstruccion:
        "S’ha resolt el símptoma després de l’actuació?\n\nFont: L4 Avaries tècniques, pàg. 39.",
    esPregunta: true,
    botonSiDestino: "sac_resultat_confirmat",
    botonNoDestino: "sac19_11_pendent",
  ),
  "sac19_13": PasoDiagnostico(
    id: "sac19_13",
    imagenPath: "manual/s2100/sac_19/armari-1f13.png",
    preguntaOInstruccion:
        "Confirma cotxe i 1F13 (exclusiu MA1 / MA2). Prova de rearmar el tèrmic identificat.\n\nFont: L4 Avaries tècniques, pàg. 40.",
    esPregunta: false,
    botonSiDestino: "sac19_13_ok",
  ),
  "sac19_13_ok": PasoDiagnostico(
    id: "sac19_13_ok",
    preguntaOInstruccion:
        "S’ha resolt el símptoma després de l’actuació?\n\nFont: L4 Avaries tècniques, pàg. 40.",
    esPregunta: true,
    botonSiDestino: "sac_resultat_confirmat",
    botonNoDestino: "sac19_13_pendent",
  ),
  "sac19_09_pendent": PasoDiagnostico(
    id: "sac19_09_pendent",
    preguntaOInstruccion:
        "Si 1F09 no rearma: desallotjar i alliberar estacionament mecànicament. Reutilitza B19 i, si no entra aire, B17/sirgues. El SAC pot mantenir l’avís malgrat alliberament real. Cal llaç de portes per traccionar, coordinat amb CCM.\n\nFont: L4 Avaries tècniques, pàg. 38.",
    esPregunta: false,
    botonSiDestino: "pregunta_b19_es_ma",
  ),
  "sac19_11_pendent": PasoDiagnostico(
    id: "sac19_11_pendent",
    preguntaOInstruccion:
        "No anul·lis el llaç sense localitzar el cotxe: podria continuar frenat. Comunica DISPLAY i resultat a CCM/Portacotxeres. Sense informació del DISPLAY cal diagnòstic de causes, no atribuir-ho automàticament a 1F11.\n\nFont: L4 Avaries tècniques, pàg. 39.",
    esPregunta: false,
  ),
  "sac19_13_pendent": PasoDiagnostico(
    id: "sac19_13_pendent",
    preguntaOInstruccion:
        "Si 1F13 no rearma, el tren queda frenat per emergència. És possible desfrenar des de cabina contrària, d’acord amb CCM?\n\nFont: L4 Avaries tècniques, pàg. 40.",
    esPregunta: true,
    botonSiDestino: "sac19_13_cabina",
    botonNoDestino: "sac19_13_remolcada",
  ),
  "sac20": PasoDiagnostico(
    id: "sac20",
    imagenPath: "manual/s2100/sac_20/rearme-compressor.png",
    preguntaOInstruccion:
        "SAC 20 · Visualitza el compressor afectat al DISPLAY. A l’armari de tèrmics de qualsevol testera, prem «rearme tèrmic compressor»; la reposició és independent del compressor afectat.\n\nFont: L4 Avaries tècniques, pàg. 41.",
    esPregunta: false,
    botonSiDestino: "sac20_ok",
  ),
  "sac20_ok": PasoDiagnostico(
    id: "sac20_ok",
    preguntaOInstruccion:
        "Ha reposat i has comprovat el funcionament correcte?\n\nFont: L4 Avaries tècniques, pàg. 41.",
    esPregunta: true,
    botonSiDestino: "sac_resultat_confirmat",
    botonNoDestino: "sac20_verificar",
  ),
  "sac20_verificar": PasoDiagnostico(
    id: "sac20_verificar",
    imagenPath: "manual/s2100/sac_21/manometre-tdp.png",
    preguntaOInstruccion:
        "Si no reposa, comprova funcionament real dels compressors observant l’evolució de TDP: pot haver-hi fallada de comunicació. Contacta Portacotxeres i valora la situació; no assumeixis compressor aturat només per l’avís.\n\nFont: L4 Avaries tècniques, pàg. 41.",
    esPregunta: false,
  ),
  "sac21": PasoDiagnostico(
    id: "sac21",
    imagenPath: "manual/s2100/sac_21/manometre-tdp.png",
    preguntaOInstruccion:
        "SAC 21 · Comprova pressió real de canonada general (òptima 8–11 kg/cm² segons fitxa) i evolució de l’alarma durant la càrrega.\n\nFont: L4 Avaries tècniques, pàg. 42.",
    esPregunta: false,
    opcions: [
      OpcioSac("Puntual / intermitent", "sac21_intermitent"),
      OpcioSac("Fixa durant tota la càrrega", "sac21_fixa"),
      OpcioSac("No puc determinar-ho", "sac_pendent"),
    ],
  ),
  "sac21_intermitent": PasoDiagnostico(
    id: "sac21_intermitent",
    imatgesManual: imatgesManual2100["sac21_intermitent"]!,
    preguntaOInstruccion:
        "Pot aparèixer amb pressió insuficient i normalitzar en arribar a la desitjada. Monitoritza l’agulla del manòmetre i parla amb Portacotxeres. No s’ha confirmat recuperació només per seleccionar aquest cas.\n\nFont: L4 Avaries tècniques, pàg. 42.",
    esPregunta: false,
  ),
  "sac21_fixa": PasoDiagnostico(
    id: "sac21_fixa",
    preguntaOInstruccion:
        "Compressor que no treballa o manca de pressió. Parla amb Portacotxeres i valora retirada/canvi. El manual contempla un sol compressor fins a retirar, vigilant pressió; no és autorització automàtica de continuïtat.\n\nFont: L4 Avaries tècniques, pàg. 42.",
    esPregunta: false,
  ),
  "sac23_original": PasoDiagnostico(
    id: "sac23_original",
    preguntaOInstruccion:
        "La fitxa indica que al 2100 original no afecta la conducció. Si persisteix el símptoma, cal identificar una altra causa; no aplicar la seqüència del remodelat.\n\nFont: L4 Avaries tècniques, pàg. 44.",
    esPregunta: false,
  ),
  "sac23_remodelat": PasoDiagnostico(
    id: "sac23_remodelat",
    imatgesManual: imatgesManual2100["sac23_remodelat"]!,
    imagenPath: "manual/s2100/sac_23/remodelat-armari-tren-stop.png",
    preguntaOInstruccion:
        "Rearma amb TR de l’IRIS o amb el polsador verd de rearme a la part inferior de l’armari. El pilot també pot indicar IRIS sense alimentació.\n\nFont: L4 Avaries tècniques, pàg. 44, 64.",
    esPregunta: false,
    botonSiDestino: "sac23_ok",
  ),
  "sac23_ok": PasoDiagnostico(
    id: "sac23_ok",
    preguntaOInstruccion:
        "S’ha resolt el símptoma després de l’actuació?\n\nFont: L4 Avaries tècniques, pàg. 44, 64.",
    esPregunta: true,
    botonSiDestino: "sac_resultat_confirmat",
    botonNoDestino: "sac23_anullar",
  ),
  "sac23_anullar": PasoDiagnostico(
    id: "sac23_anullar",
    imagenPath: "manual/s2100/sac_23/remodelat-rearme-anullacio.png",
    preguntaOInstruccion:
        "Si no rearma, la fitxa identifica el polsador vermell d’anul·lació Tren Stop. Confirma l’element i coordina amb CCM; no és un tèrmic genèric.\n\nFont: L4 Avaries tècniques, pàg. 44, 64.",
    esPregunta: false,
    botonSiDestino: "sac23_anullat_ok",
    advertencia:
        "Tren Stop anul·lat: conserva aquesta condició i les indicacions del CCM.",
  ),
  "sac23_anullat_ok": PasoDiagnostico(
    id: "sac23_anullat_ok",
    preguntaOInstruccion:
        "S’ha resolt el símptoma mantenint registrada l’anul·lació de Tren Stop?\n\nFont: L4 Avaries tècniques, pàg. 44, 64.",
    esPregunta: true,
    botonSiDestino: "sac_resultat_confirmat",
    botonNoDestino: "sac_pendent",
  ),
  "sac24": PasoDiagnostico(
    id: "sac24",
    preguntaOInstruccion:
        "SAC 24 · El llaç obert no identifica per si sol la causa. Pot ser tirador, home mort, punt 7, bolet, pressió mínima, Tren Stop, tèrmics o absència de mode. Prioritza la causa concreta al DISPLAY. Si no normalitza, el manual indica desallotjar i anul·lar llaç de fre quan correspongui, amb CCM i sense deixar un cotxe frenat.\n\nFont: L4 Avaries tècniques, pàg. 45.",
    esPregunta: false,
    opcions: [
      OpcioSac("13 · Fre estacionament", "sac13"),
      OpcioSac("14 · fre pneumàtic", "sac14"),
      OpcioSac("19 · Tèrmic identificat", "sac19"),
      OpcioSac("1F11 caigut identificat al DISPLAY", "sac19_11"),
      OpcioSac("22 · tirador", "procedimiento_tirador"),
      OpcioSac("23 · Tren Stop", "procedimiento_tren_stop_rearme"),
      OpcioSac("Una altra alarma concreta", "sac_identificada"),
      OpcioSac("24 sol · diagnosticar causa", "inicio_no_desfrena"),
    ],
  ),
  "sac_aire": PasoDiagnostico(
    id: "sac_aire",
    imatgesManual: imatgesManual2100["sac_aire"]!,
    preguntaOInstruccion:
        "TDP baixa no implica fallada de fre pneumàtic. Hi ha alarma de compressor identificada?\n\nFont: L4 Avaries tècniques, pàg. 41–42, 45.",
    esPregunta: false,
    opcions: [
      OpcioSac("20 · Tèrmic compressor", "sac20"),
      OpcioSac("21 · Avaria compressor", "sac21"),
      OpcioSac("Cap alarma concreta / possible fuita", "sac_aire_pendent"),
    ],
  ),
  "sac_aire_pendent": PasoDiagnostico(
    id: "sac_aire_pendent",
    imatgesManual: imatgesManual2100["sac_aire_pendent"]!,
    preguntaOInstruccion:
        "Comprova evolució de la pressió i possibles fuites. Comunica dades reals a CCM/Portacotxeres. No passar a B12 només perquè hi hagi poca pressió.\n\nFont: L4 Avaries tècniques, pàg. 41–42, 45, 53–55.",
    esPregunta: false,
  ),
  "sac_des_comprova": PasoDiagnostico(
    id: "sac_des_comprova",
    preguntaOInstruccion:
        "S’ha afluixat realment l’estacionament?\n\nFont: L4 Avaries tècniques, pàg. 32–34.",
    esPregunta: true,
    botonSiDestino: "pregunta_disyuntores_abierto",
    botonNoDestino: "sac13",
  ),
  "sac_portes_reconegudes": PasoDiagnostico(
    id: "sac_portes_reconegudes",
    preguntaOInstruccion:
        "Amb portes físicament tancades, el SAC/DISPLAY també les reconeix tancades?\n\nFont: L4 Avaries tècniques, pàg. 26.",
    esPregunta: true,
    causaDescartadaAlSi: "Portes obertes",
    botonSiDestino: "pregunta_estacionamiento",
    botonNoDestino: "procedimiento_puertas_fallo",
  ),

  "sac03_continuitat": PasoDiagnostico(
    id: "sac03_continuitat",
    preguntaOInstruccion:
        "Continua amb passatge només en el supòsit d’un únic cotxe motor aïllat, amb avís i seguiment de Portacotxeres. Acorda el canvi de motors / normalització ONIX. No s’ha confirmat recuperació.\n\nFont: L4 Avaries tècniques, pàg. 20.",
    esPregunta: false,
  ),
  "sac03_reset_acord": PasoDiagnostico(
    id: "sac03_reset_acord",
    preguntaOInstruccion:
        "Sou en terminal i Portacotxeres acorda fer el reset de bateries?\n\nFont: L4 Avaries tècniques, pàg. 20.",
    esPregunta: true,
    botonSiDestino: "sac03_reset",
    botonNoDestino: "sac03_continuitat",
  ),
  "sac03_reset_ok": PasoDiagnostico(
    id: "sac03_reset_ok",
    preguntaOInstruccion:
        "Després del reset, s’ha recuperat l’equip i comprovat el funcionament?\n\nFont: L4 Avaries tècniques, pàg. 20.",
    esPregunta: true,
    botonSiDestino: "sac_resultat_confirmat",
    botonNoDestino: "sac03",
  ),
  "sac03_zero": PasoDiagnostico(
    id: "sac03_zero",
    preguntaOInstruccion:
        "Els pantògrafs estan baixats i el voltímetre de línia marca 0?\n\nFont: L4 Avaries tècniques, pàg. 21.",
    esPregunta: true,
    botonSiDestino: "sac03_cofres",
    botonNoDestino: "sac_pendent",
  ),
  "sac03_cofres": PasoDiagnostico(
    id: "sac03_cofres",
    preguntaOInstruccion:
        "Amb les condicions anteriors confirmades, rearma els cofres de tracció de tots els cotxes, coordinat amb Portacotxeres.\n\nFont: L4 Avaries tècniques, pàg. 21.",
    esPregunta: false,
    botonSiDestino: "sac03_ok",
    imatgesManual: imatgesManual2100["sac03_tots"]!.skip(1).toList(),
  ),
  "sac06_con": PasoDiagnostico(
    id: "sac06_con",
    preguntaOInstruccion:
        "Intenta connectar CONVERTIDOR des de la P.M.M.\n\nFont: L4 Avaries tècniques, pàg. 23.",
    esPregunta: false,
    botonSiDestino: "sac06_fusible",
    imagenPath: "manual/s2100/sac_06/comandament-convertidor.png",
  ),
  "sac06_fusible": PasoDiagnostico(
    id: "sac06_fusible",
    preguntaOInstruccion:
        "S’il·lumina SAC 05 · Fusible convertidor?\n\nFont: L4 Avaries tècniques, pàg. 23.",
    esPregunta: true,
    botonSiDestino: "sac05",
    botonNoDestino: "sac06_ok",
  ),
  "sac06_ok": PasoDiagnostico(
    id: "sac06_ok",
    preguntaOInstruccion:
        "Ha rearmat el convertidor i s’ha comprovat la recuperació?\n\nFont: L4 Avaries tècniques, pàg. 23.",
    esPregunta: true,
    botonSiDestino: "sac_resultat_confirmat",
    botonNoDestino: "sac06_reset_acord",
  ),
  "sac06_reset_acord": PasoDiagnostico(
    id: "sac06_reset_acord",
    preguntaOInstruccion:
        "Sense SAC 05, Portacotxeres acorda provar un reset incloent bateries?\n\nFont: L4 Avaries tècniques, pàg. 23.",
    esPregunta: true,
    botonSiDestino: "sac06_reset",
    botonNoDestino: "sac06_retirada",
  ),
  "sac06_reset_ok": PasoDiagnostico(
    id: "sac06_reset_ok",
    preguntaOInstruccion:
        "Després del reset, s’ha recuperat el convertidor?\n\nFont: L4 Avaries tècniques, pàg. 23.",
    esPregunta: true,
    botonSiDestino: "sac_resultat_confirmat",
    botonNoDestino: "sac06_retirada",
  ),
  "sac06_retirada": PasoDiagnostico(
    id: "sac06_retirada",
    preguntaOInstruccion:
        "Amb un únic convertidor: desallotja al moment, desconnecta llums, aire condicionat i megafonia. Retira al més aviat possible amb CCM/Portacotxeres; situació crítica en S2100.\n\nFont: L4 Avaries tècniques, pàg. 23.",
    esPregunta: false,
  ),
  "sac07": PasoDiagnostico(
    id: "sac07",
    preguntaOInstruccion:
        "SAC 07 · Comandament portes\n\nIdentifica la porta afectada. És costat andana?\n\nFont: criteri operatiu confirmat per l’usuari; no és el procediment de controla.",
    esPregunta: true,
    botonSiDestino: "sac07_andana",
    botonNoDestino: "sac07_via",
  ),
  "sac07_andana": PasoDiagnostico(
    id: "sac07_andana",
    preguntaOInstruccion:
        "A la següent estació, comprova si el passatge obre aquesta porta. Això permet comprovar si té tensió.\n\nFont: criteri operatiu confirmat.",
    esPregunta: false,
    botonSiDestino: "sac07_tensio",
  ),
  "sac07_via": PasoDiagnostico(
    id: "sac07_via",
    preguntaOInstruccion:
        "Amb el tren correctament estacionat, desplaça’t a la porta afectada del costat via i acciona el comandament per comprovar si té tensió.\n\nFont: criteri operatiu confirmat.",
    esPregunta: false,
    botonSiDestino: "sac07_tensio",
  ),
  "sac07_tensio": PasoDiagnostico(
    id: "sac07_tensio",
    preguntaOInstruccion: "La porta disposa de tensió?",
    esPregunta: true,
    botonSiDestino: "sac07_normal",
    botonNoDestino: "sac07_iris",
  ),
  "sac07_normal": PasoDiagnostico(
    id: "sac07_normal",
    preguntaOInstruccion:
        "Amb tensió comprovada, continua la marxa normal. Habitualment desapareix l’avís de comandament.\n\nFont: criteri operatiu confirmat.",
    esPregunta: false,
  ),
  "sac07_recomprova": PasoDiagnostico(
    id: "sac07_recomprova",
    preguntaOInstruccion:
        "Després de rearmar IRIS, la porta disposa de tensió?",
    esPregunta: true,
    botonSiDestino: "sac07_normal",
    botonNoDestino: "procedimiento_puertas_fallo",
  ),
  "sac08_no_tanquen": PasoDiagnostico(
    id: "sac08_no_tanquen",
    preguntaOInstruccion:
        "Pot fallar el bip-bip o el polsador de tancament. Utilitza la controla amb el costat seleccionat, clau de capçalera d’andana i clàxon abans de tancar.\n\nFont: L4 Avaries tècniques, pàg. 25.",
    esPregunta: false,
    opcions: [
      OpcioSac("Utilitzar controla", "sac08_controla"),
      OpcioSac("No funciona el bip-bip", "sac25_iris"),
    ],
  ),
  "sac08_tancament_ok": PasoDiagnostico(
    id: "sac08_tancament_ok",
    preguntaOInstruccion:
        "Les portes han tancat i el SAC/DISPLAY les reconeix tancades?\n\nFont: L4 Avaries tècniques, pàg. 25.",
    esPregunta: true,
    botonSiDestino: "sac_resultat_confirmat",
    botonNoDestino: "sac08_persisteix",
  ),
  "sac08_oberta": PasoDiagnostico(
    id: "sac08_oberta",
    preguntaOInstruccion:
        "Localitza la porta al DISPLAY o pel pilot exterior blanc; revisa també la porta de testera. Dona permissió, agafa claus i walkie, desplaça’t a la porta i obre-la per comprovar obstacles. Torna a cabina i tanca. Si hi ha un objecte, aplica les condicions del procediment d’obstrucció abans de retirar-lo.\n\nFont: L4 Avaries tècniques, pàg. 26.",
    esPregunta: false,
    opcions: [
      OpcioSac("Comprovar el tancament", "sac08_tancament_ok"),
      OpcioSac("Hi ha un objecte", "sac08_objecte"),
    ],
    imagenPath: "manual/s2100/sac_08/pilot-exterior.png",
  ),
  "sac08_objecte": PasoDiagnostico(
    id: "sac08_objecte",
    preguntaOInstruccion:
        "Identifica el cotxe i el costat de la porta bloquejada. Retira tensió al costat/cotxe mitjançant el selector, retira l’objecte, restitueix tensió i tanca.\n\nLa fitxa també contempla retirar l’objecte amb permissió de portes seleccionada. En S2100 remodelat, la manipulació s’ha de fer amb ABSÈNCIA DE TENSIÓ.\n\nFont: L4 Avaries tècniques, pàg. 27, 64.",
    esPregunta: false,
    botonSiDestino: "sac08_tancament_ok",
    imatgesManual: imatgesManual2100["procedimiento_puertas_fallo"]!
        .where((i) => i.path.contains("selector-") || i.path.contains("pinyo"))
        .toList(),
  ),
  "sac08_seleccio": PasoDiagnostico(
    id: "sac08_seleccio",
    preguntaOInstruccion:
        "Prova la seqüència normal d’obertura. Encara que el pilot groc no s’encengui, permet autoritzar permissió?\n\nFont: L4 Avaries tècniques, pàg. 28.",
    esPregunta: true,
    botonSiDestino: "sac08_bombeta",
    botonNoDestino: "sac08_seleccio_zero",
  ),
  "sac08_bombeta": PasoDiagnostico(
    id: "sac08_bombeta",
    preguntaOInstruccion:
        "Continua la marxa amb normalitat i comunica a Portacotxeres que la bombeta de selecció està fosa.\n\nFont: L4 Avaries tècniques, pàg. 28.",
    esPregunta: false,
  ),
  "sac08_seleccio_zero": PasoDiagnostico(
    id: "sac08_seleccio_zero",
    preguntaOInstruccion:
        "Passa tot per 0 i comprova de nou. Ara permet la selecció/permissió?\n\nFont: L4 Avaries tècniques, pàg. 28.",
    esPregunta: true,
    botonSiDestino: "sac_resultat_confirmat",
    botonNoDestino: "sac08_evacuacio_ma",
  ),
  "sac08_evacuacio_ma": PasoDiagnostico(
    id: "sac08_evacuacio_ma",
    preguntaOInstruccion:
        "Retira tensió de portes costat andana des de l’armari del cotxe MA de capçalera. Anuncia al passatge que el desallotjament serà únicament pel primer cotxe. Desallotja per aquest cotxe i coordina canvi/retirada. En remodelats es pot desbloquejar una porta del costat/cotxe corresponent.\n\nFont: L4 Avaries tècniques, pàg. 28.",
    esPregunta: false,
    imagenPath: "manual/s2100/sac_08/selector-ma.png",
  ),
  "sac08_permissio": PasoDiagnostico(
    id: "sac08_permissio",
    preguntaOInstruccion:
        "Passa tot per 0 i comprova de nou. Ara permet la permissió de portes?\n\nFont: L4 Avaries tècniques, pàg. 29.",
    esPregunta: true,
    botonSiDestino: "sac_resultat_confirmat",
    botonNoDestino: "sac08_permissio_controla",
  ),
  "sac08_permissio_ok": PasoDiagnostico(
    id: "sac08_permissio_ok",
    preguntaOInstruccion:
        "La controla del costat corresponent permet l’obertura/permissió?\n\nFont: L4 Avaries tècniques, pàg. 29.",
    esPregunta: true,
    botonSiDestino: "sac08_auxiliar",
    botonNoDestino: "sac08_km0",
  ),
  "sac08_auxiliar": PasoDiagnostico(
    id: "sac08_auxiliar",
    preguntaOInstruccion:
        "Problema de botonera: utilitza el sistema auxiliar de portes per autoritzar permissió i avalua/planifica canvi de motors amb Portacotxeres.\n\nFont: L4 Avaries tècniques, pàg. 29.",
    esPregunta: false,
  ),
  "sac08_km0": PasoDiagnostico(
    id: "sac08_km0",
    preguntaOInstruccion:
        "Probable avaria del relé km0. Amb CCM/Portacotxeres, valora reset de bateries o desallotjar retirant tensió de portes costat andana d’un cotxe.\n\nFont: L4 Avaries tècniques, pàg. 29.",
    esPregunta: false,
    opcions: [
      OpcioSac("Reset de bateries acordat", "sac08_reset"),
      OpcioSac(
        "Desallotjar retirant tensió costat andana",
        "sac08_evacuacio_cotxe",
      ),
      OpcioSac("Pendent d’instruccions", "sac_pendent"),
    ],
  ),
  "sac08_evacuacio_cotxe": PasoDiagnostico(
    id: "sac08_evacuacio_cotxe",
    preguntaOInstruccion:
        "Al cotxe identificat, retira tensió de les portes del costat andana mitjançant el selector i desallotja coordinat amb CCM. No és una recuperació del servei.\n\nFont: L4 Avaries tècniques, pàg. 29.",
    esPregunta: false,
    imatgesManual: imatgesManual2100["procedimiento_puertas_fallo"]!
        .where((i) => i.path.contains("selector-"))
        .toList(),
  ),
  "sac08_reset_ok": PasoDiagnostico(
    id: "sac08_reset_ok",
    preguntaOInstruccion:
        "Després del reset es permet permissió i es comprova el funcionament de portes?\n\nFont: L4 Avaries tècniques, pàg. 29.",
    esPregunta: true,
    botonSiDestino: "sac_resultat_confirmat",
    botonNoDestino: "sac08_km0",
  ),
  "sac09_ok": PasoDiagnostico(
    id: "sac09_ok",
    preguntaOInstruccion:
        "Ha cessat la fuita després d’actuar sobre l’aixeta identificada?\n\nFont: L4 Avaries tècniques, pàg. 57.",
    esPregunta: true,
    botonSiDestino: "sac_resultat_confirmat",
    botonNoDestino: "sac_pendent",
  ),
  "sac15_informat": PasoDiagnostico(
    id: "sac15_informat",
    preguntaOInstruccion:
        "Informa CCM de l’anul·lació del fre de servei i mantén les limitacions de l’actuació realitzada. No es dona per recuperat el fre ni per autoritzada marxa normal.\n\nFont: L4 Avaries tècniques, pàg. 35.",
    esPregunta: false,
  ),
  "sac13_bolet_ok": PasoDiagnostico(
    id: "sac13_bolet_ok",
    preguntaOInstruccion:
        "S’ha alliberat l’estacionament de tots els cotxes?\n\nFont: L4 Avaries tècniques, pàg. 32.",
    esPregunta: true,
    botonSiDestino: "sac_resultat_confirmat",
    botonNoDestino: "sac13_alternatives",
  ),
  "sac13_alternatives": PasoDiagnostico(
    id: "sac13_alternatives",
    preguntaOInstruccion:
        "Possible problema de polsador. Coordina amb CCM l’alternativa aplicable: canvi de cabina quan es pot retrocedir, o electrovàlvules de tots els cotxes.\n\nFont: L4 Avaries tècniques, pàg. 32.",
    esPregunta: false,
    opcions: [
      OpcioSac("Es pot canviar de cabina i retrocedir", "sac13_canvi_cabina"),
      OpcioSac("Electrovàlvules de tots els cotxes", "sac13_b19_MA1"),
      OpcioSac("No es pot determinar", "sac_pendent"),
    ],
  ),
  "sac13_canvi_cabina": PasoDiagnostico(
    id: "sac13_canvi_cabina",
    preguntaOInstruccion:
        "Amb la maniobra acordada, canvia de cabina i retira els estacionaments des d’allà.\n\nFont: L4 Avaries tècniques, pàg. 32.",
    esPregunta: false,
    botonSiDestino: "sac13_tots_final",
  ),
  "sac13_tots_final": PasoDiagnostico(
    id: "sac13_tots_final",
    preguntaOInstruccion:
        "S’ha comprovat l’alliberament real de tots els estacionaments?\n\nFont: L4 Avaries tècniques, pàg. 32.",
    esPregunta: true,
    botonSiDestino: "sac_resultat_confirmat",
    botonNoDestino: "sac_pendent",
  ),
  "sac16_ok": PasoDiagnostico(
    id: "sac16_ok",
    preguntaOInstruccion:
        "S’ha normalitzat l’alarma després de reiniciar l’electrònica de fre?\n\nFont: L4 Avaries tècniques, pàg. 36.",
    esPregunta: true,
    botonSiDestino: "sac_resultat_confirmat",
    botonNoDestino: "sac16_cofre_acord",
  ),
  "sac16_cofre_acord": PasoDiagnostico(
    id: "sac16_cofre_acord",
    preguntaOInstruccion:
        "Portacotxeres acorda recuperar la cadena de tracció del cotxe motor afectat?\n\nFont: L4 Avaries tècniques, pàg. 36.",
    esPregunta: true,
    botonSiDestino: "sac16_recuperar",
    botonNoDestino: "sac16_observar",
  ),
  "sac16_recuperar_ok": PasoDiagnostico(
    id: "sac16_recuperar_ok",
    preguntaOInstruccion:
        "S’ha normalitzat l’alarma després de recuperar la cadena de tracció?\n\nFont: L4 Avaries tècniques, pàg. 36.",
    esPregunta: true,
    botonSiDestino: "sac_resultat_confirmat",
    botonNoDestino: "sac16_observar",
  ),
  "sac19_13_cabina": PasoDiagnostico(
    id: "sac19_13_cabina",
    preguntaOInstruccion:
        "Realitza el desfrenament des de la cabina acordada. Cal anul·lar el llaç de fre per poder desfrenar i iniciar la marxa; mantén aquesta condició i les instruccions CCM.\n\nFont: L4 Avaries tècniques, pàg. 40.",
    esPregunta: false,
    botonSiDestino: "sac19_13_cabina_ok",
  ),
  "sac19_13_cabina_ok": PasoDiagnostico(
    id: "sac19_13_cabina_ok",
    preguntaOInstruccion:
        "S’ha pogut desfrenar des d’aquesta cabina?\n\nFont: L4 Avaries tècniques, pàg. 40.",
    esPregunta: true,
    botonSiDestino: "sac_resultat_confirmat",
    botonNoDestino: "sac19_13_remolcada",
  ),
  "sac19_13_remolcada": PasoDiagnostico(
    id: "sac19_13_remolcada",
    preguntaOInstruccion:
        "Si no es pot desfrenar des de l’altra cabina: B12 i REMOLCADA, amb anul·lació del llaç de fre. Coordina el procediment amb CCM. La remolcada continua essent necessària encara que les B12 alliberin el fre.\n\nFont: L4 Avaries tècniques, pàg. 40.",
    esPregunta: false,
    botonSiDestino: "sac19_13_b12",
  ),
  "sac22_marxa": PasoDiagnostico(
    id: "sac22_marxa",
    preguntaOInstruccion:
        "No t’aturis al túnel per aquest motiu: continua fins a la següent estació i estaciona correctament a l’andana abans d’anar a rearmar. Si t’atures al túnel, pot obrir el llaç i no desfrenar fins al rearme. Pregunta el motiu i coordina els recursos necessaris amb CCM.\n\nFont: L4 Avaries tècniques, pàg. 43.",
    esPregunta: false,
    botonSiDestino: "sac22_estacio",
  ),
  "sac22_estacio": PasoDiagnostico(
    id: "sac22_estacio",
    preguntaOInstruccion:
        "Amb el tren parat, identifica el tirador al DISPLAY 22 o pel pilot exterior taronja. Pregunta el motiu i demana recursos a CCM quan correspongui. Emporta’t claus i walkie, dirigeix-te al cotxe identificat i rearma el tirador. Si el tren és aturat al túnel, coordina l’actuació amb CCM.\n\nFont: L4 Avaries tècniques, pàg. 43.",
    esPregunta: false,
    botonSiDestino: "sac22_ok",
    imatgesManual: imatgesManual2100["procedimiento_tirador"]!,
  ),
  "sac25_despres_iris": PasoDiagnostico(
    id: "sac25_despres_iris",
    preguntaOInstruccion:
        "Si cal, utilitza controla: el tancament des d’allà és independent d’IRIS. Tot seguit prova la megafonia del tren.\n\nFont: L4 Avaries tècniques, pàg. 47.",
    esPregunta: false,
    opcions: [
      OpcioSac("Cal utilitzar controla", "sac25_controla"),
      OpcioSac("Provar la megafonia", "sac25_megafonia_ok"),
    ],
  ),
  "sac25_megafonia_ok": PasoDiagnostico(
    id: "sac25_megafonia_ok",
    preguntaOInstruccion:
        "Funciona la megafonia del tren?\n\nFont: L4 Avaries tècniques, pàg. 47.",
    esPregunta: true,
    botonSiDestino: "sac25_bip_ok",
    botonNoDestino: "sac25_iris_ko",
  ),
  "sac25_bip_ok": PasoDiagnostico(
    id: "sac25_bip_ok",
    preguntaOInstruccion:
        "També s’ha recuperat el bip-bip i el tancament de portes?\n\nFont: L4 Avaries tècniques, pàg. 47.",
    esPregunta: true,
    botonSiDestino: "sac_resultat_confirmat",
    botonNoDestino: "sac25_canvi",
  ),
  "sac25_iris_ko": PasoDiagnostico(
    id: "sac25_iris_ko",
    preguntaOInstruccion:
        "IRIS KO: també falla la megafonia. Desallotja i comunica la incidència al CCM.\n\nFont: L4 Avaries tècniques, pàg. 47.",
    esPregunta: false,
  ),
  "sac25_canvi": PasoDiagnostico(
    id: "sac25_canvi",
    preguntaOInstruccion:
        "Si únicament falla el bip-bip, es pot anar amb passatge a canvi de motors utilitzant el sistema auxiliar. Valora amb CCM desallotjar si provoca molt retard a la línia.\n\nFont: L4 Avaries tècniques, pàg. 47.",
    esPregunta: false,
  ),
  "sac25_edp": PasoDiagnostico(
    id: "sac25_edp",
    preguntaOInstruccion:
        "Quin equip EDP cal recuperar?\n\nFont: L4 Avaries tècniques, pàg. 48.",
    esPregunta: false,
    opcions: [
      OpcioSac("MA1", "sac25_edp_ma1"),
      OpcioSac("MA2", "sac25_edp_ma2"),
      OpcioSac("No identificat", "sac_pendent"),
    ],
  ),
  "sac25_edp_ma1": PasoDiagnostico(
    id: "sac25_edp_ma1",
    preguntaOInstruccion:
        "Atura manualment l’equip de detecció de posició mantenint polsat fins que s’apagui ON. Torna a encendre’l polsant marxa.\n\nFont: L4 Avaries tècniques, pàg. 48.",
    esPregunta: false,
    botonSiDestino: "sac25_edp_ok",
    imagenPath: "manual/s2100/sac_25/equip-posicio-ma1.png",
  ),
  "sac25_edp_ma2": PasoDiagnostico(
    id: "sac25_edp_ma2",
    preguntaOInstruccion:
        "Tira el tèrmic EDP i deixa’l baixat 2/3 estacions. Recupera’l amb el tren parat/estacionat. La detecció automàtica es pot recuperar a Trinitat Nova, Urquinaona i La Pau.\n\nFont: L4 Avaries tècniques, pàg. 48.",
    esPregunta: false,
    botonSiDestino: "sac25_edp_ok",
    imagenPath: "manual/s2100/sac_25/termic-edp-ma2.png",
  ),
  "sac25_edp_ok": PasoDiagnostico(
    id: "sac25_edp_ok",
    preguntaOInstruccion:
        "Un cop recuperat l’equip, torna a anunciar correctament?\n\nFont: L4 Avaries tècniques, pàg. 48.",
    esPregunta: true,
    botonSiDestino: "sac_resultat_confirmat",
    botonNoDestino: "sac_pendent",
  ),
  "sac26_mirall": PasoDiagnostico(
    id: "sac26_mirall",
    preguntaOInstruccion:
        "El mirall es tanca aproximadament als 5 km/h?\n\nFont: L4 Avaries tècniques, pàg. 49.",
    esPregunta: true,
    botonSiDestino: "sac26_cesis",
    botonNoDestino: "sac26_retirada",
  ),
  "sac26_cesis": PasoDiagnostico(
    id: "sac26_cesis",
    preguntaOInstruccion:
        "L’avaria no sembla real. Tira/rearma el tèrmic CESIS per normalitzar l’alarma.\n\nFont: L4 Avaries tècniques, pàg. 49.",
    esPregunta: false,
    botonSiDestino: "sac26_ok",
  ),
  "sac26_ok": PasoDiagnostico(
    id: "sac26_ok",
    preguntaOInstruccion:
        "S’ha normalitzat l’alarma?\n\nFont: L4 Avaries tècniques, pàg. 49.",
    esPregunta: true,
    botonSiDestino: "sac_resultat_confirmat",
    botonNoDestino: "sac_pendent",
  ),
  "sac26_retirada": PasoDiagnostico(
    id: "sac26_retirada",
    preguntaOInstruccion:
        "Possible fallada de detecció de velocitat 0: no es garanteixen les seguretats de portes lligades a tren parat. Desallotja i retira el tren.\n\nFont: L4 Avaries tècniques, pàg. 49.",
    esPregunta: false,
  ),
  "sac27_display": PasoDiagnostico(
    id: "sac27_display",
    preguntaOInstruccion:
        "Tira i rearma el tèrmic del DISPLAY.\n\nFont: L4 Avaries tècniques, pàg. 50.",
    esPregunta: false,
    botonSiDestino: "sac27_display_ok",
  ),
  "sac27_display_ok": PasoDiagnostico(
    id: "sac27_display_ok",
    preguntaOInstruccion:
        "El DISPLAY torna a respondre correctament?\n\nFont: L4 Avaries tècniques, pàg. 50.",
    esPregunta: true,
    botonSiDestino: "sac_resultat_confirmat",
    botonNoDestino: "sac_pendent",
  ),
  "sac27_traccio": PasoDiagnostico(
    id: "sac27_traccio",
    preguntaOInstruccion:
        "Possible RIOM núm. 1. La fitxa indica provar anul·lació de llaç i prova de tracció, seguida de desallotjament i retirada. La fitxa no precisa aquí quin llaç: confirma la maniobra concreta amb CCM/Portacotxeres abans d’actuar. No es dona una anul·lació genèrica automàtica.\n\nFont: L4 Avaries tècniques, pàg. 50.",
    esPregunta: false,
    opcions: [
      OpcioSac("Maniobra confirmada i prova realitzada", "sac27_retirada"),
      OpcioSac("Pendent de concreció CCM", "sac_pendent"),
    ],
  ),
  "sac27_riom": PasoDiagnostico(
    id: "sac27_riom",
    preguntaOInstruccion:
        "Observa la tensió i comprova si el tren tracciona i desfrena. Comunica el resultat a CCM; la fitxa indica desallotjar i composició a retirada.\n\nFont: L4 Avaries tècniques, pàg. 50.",
    esPregunta: false,
    botonSiDestino: "sac27_retirada",
  ),
  "sac27_retirada": PasoDiagnostico(
    id: "sac27_retirada",
    preguntaOInstruccion:
        "Desallotja i coordina composició a retirada. Una resposta a la prova no elimina aquesta conseqüència de la fitxa.\n\nFont: L4 Avaries tècniques, pàg. 50.",
    esPregunta: false,
  ),
  "sac27_pma": PasoDiagnostico(
    id: "sac27_pma",
    preguntaOInstruccion:
        "Possible desconnexió d’equips per RIOM: connecta mitjançant PMA. No substitueixis aquesta actuació per un reset de bateries.\n\nFont: L4 Avaries tècniques, pàg. 50.",
    esPregunta: false,
    botonSiDestino: "sac27_pma_ok",
    imagenPath: "manual/s2100/connexio/bateries-pma.png",
  ),
  "sac27_pma_ok": PasoDiagnostico(
    id: "sac27_pma_ok",
    preguntaOInstruccion:
        "S’han reconnectat els equips i comprovat el funcionament?\n\nFont: L4 Avaries tècniques, pàg. 50.",
    esPregunta: true,
    botonSiDestino: "sac_resultat_confirmat",
    botonNoDestino: "sac_pendent",
  ),

  "sac03_ok": PasoDiagnostico(
    id: "sac03_ok",
    preguntaOInstruccion:
        "S’han recuperat els equips i comprovat el funcionament després del rearme dels cofres?\n\nFont: L4 Avaries tècniques, pàg. 21.",
    esPregunta: true,
    botonSiDestino: "sac_resultat_confirmat",
    botonNoDestino: "sac_pendent",
  ),
  "b12_resultat": PasoDiagnostico(
    id: "b12_resultat",
    preguntaOInstruccion:
        "S’ha comprovat l’alliberament amb B12, mantenint l’anul·lació del llaç de fre i la coordinació CCM?",
    esPregunta: true,
    botonSiDestino: "b12_condicions",
    botonNoDestino: "sac_pendent",
  ),
  "b12_condicions": PasoDiagnostico(
    id: "b12_condicions",
    preguntaOInstruccion:
        "El cotxe continua sense fre pneumàtic. Mantén l’anul·lació del llaç de fre i les condicions acordades amb CCM; no és recuperació del fre ni marxa normal.\n\nFont: L4 Avaries tècniques, pàg. 35.",
    esPregunta: false,
  ),
};
