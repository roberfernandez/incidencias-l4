part of 's2100_data.dart';
class ImatgePasManual {
  final String path, titol, variant;
  final int? pagina;
  final List<String> cotxes;
  const ImatgePasManual(this.path, this.titol, this.pagina, this.variant, [this.cotxes = const []]);
}
const imatgesManual2100 = <String, List<ImatgePasManual>>{
  "procedimiento_rearme_disyuntor": [
    ImatgePasManual("manual/s2100/sac_01/pupitre-disjuntor.png", "Pupitre: comandament del disjuntor", 16, "S2100 · variant no diferenciada a la fitxa", []),
    ImatgePasManual("manual/s2100/sac_01/detall-con-des.png", "Disjuntor: detall CON / DES", 16, "S2100 · variant no diferenciada a la fitxa", []),
  ],
  "sac01_reset": [
    ImatgePasManual("manual/s2100/connexio/bateries-pma.png", "Bateries i posada en marxa automàtica (PMA)", 15, "S2100 · variant no diferenciada a la fitxa", []),
    ImatgePasManual("manual/s2100/connexio/display-pma.png", "DISPLAY: estat dels equips a la posada en marxa", 15, "S2100 · variant no diferenciada a la fitxa", []),
  ],
  "sac02_reset": [
    ImatgePasManual("manual/s2100/connexio/bateries-pma.png", "Bateries i posada en marxa automàtica (PMA)", 15, "S2100 · variant no diferenciada a la fitxa", []),
    ImatgePasManual("manual/s2100/connexio/display-pma.png", "DISPLAY: estat dels equips a la posada en marxa", 15, "S2100 · variant no diferenciada a la fitxa", []),
  ],
  "sac04_terminal": [
    ImatgePasManual("manual/s2100/connexio/bateries-pma.png", "Bateries i posada en marxa automàtica (PMA)", 15, "S2100 · variant no diferenciada a la fitxa", []),
    ImatgePasManual("manual/s2100/connexio/display-pma.png", "DISPLAY: estat dels equips a la posada en marxa", 15, "S2100 · variant no diferenciada a la fitxa", []),
  ],
  "sac02_un": [
    ImatgePasManual("manual/s2100/sac_02/display-un-inhibit.png", "Exemple del DISPLAY: un equip inhibit", 18, "S2100 · variant no diferenciada a la fitxa", []),
  ],
  "sac02_seguiment": [
    ImatgePasManual("manual/s2100/sac_02/cofre-motor.png", "Cofre motor: 1F17 / 1F12; intervenció coordinada amb Portacotxeres", 18, "S2100 · variant no diferenciada a la fitxa", []),
  ],
  "sac16_continua": [
    ImatgePasManual("manual/s2100/sac_02/cofre-motor.png", "Cofre motor: 1F17 / 1F12; intervenció coordinada amb Portacotxeres", 18, "S2100 · variant no diferenciada a la fitxa", []),
    ImatgePasManual("manual/s2100/sac_19/armari-1f09.png", "1F09; només si correspon al cotxe", 38, "S2100 · variant no diferenciada a la fitxa", []),
    ImatgePasManual("manual/s2100/sac_14/termic-1f11.png", "1F11; només si correspon al cotxe", 35, "S2100 · variant no diferenciada a la fitxa", []),
    ImatgePasManual("manual/s2100/sac_19/armari-1f13.png", "1F13; exclusiu MA1 / MA2", 40, "S2100 · variant no diferenciada a la fitxa", ["MA1", "MA2"]),
  ],
  "sac02_tots": [
    ImatgePasManual("manual/s2100/sac_02/display-tots-inhibits.png", "Exemple del DISPLAY: tots inhibits", 19, "S2100 · variant no diferenciada a la fitxa", []),
    ImatgePasManual("manual/s2100/compartits/bolet-emergencia.png", "Bolet d’emergència de la cabina habilitada", 52, "S2100 · variant no diferenciada a la fitxa", []),
  ],
  "sac03_un": [
    ImatgePasManual("manual/s2100/sac_03/display-un-aillat.png", "Exemple del DISPLAY: un equip aïllat", 20, "S2100 · variant no diferenciada a la fitxa", []),
  ],
  "sac03_tots": [
    ImatgePasManual("manual/s2100/sac_03/display-tots-aillats.png", "Exemple del DISPLAY: tots aïllats", 21, "S2100 · variant no diferenciada a la fitxa", []),
    ImatgePasManual("manual/s2100/sac_03/cofre-exterior.png", "Cofre de tracció: ubicació exterior", 21, "S2100 · variant no diferenciada a la fitxa", []),
    ImatgePasManual("manual/s2100/sac_03/cofre-interior.png", "Cofre de tracció: detall interior", 21, "S2100 · variant no diferenciada a la fitxa", []),
  ],
  "sac06_pendent": [
    ImatgePasManual("manual/s2100/sac_06/instruments-bateria.png", "Instruments A / B de bateria; identificació, procediment pendent", 23, "S2100 · variant no diferenciada a la fitxa", []),
    ImatgePasManual("manual/s2100/sac_06/comandament-convertidor.png", "Convertidor P.M.M.; identificació, procediment pendent", 23, "S2100 · variant no diferenciada a la fitxa", []),
  ],
  "inicio_pupitre_fallo": [
    ImatgePasManual("manual/s2100/sac_07/controla-claxon.png", "Controla lateral: clàxon abans de tancar", 25, "S2100 · variant no diferenciada a la fitxa", []),
    ImatgePasManual("manual/s2100/sac_07/botonera-portes.png", "Botonera de portes: selecció de costat", 25, "S2100 · variant no diferenciada a la fitxa", []),
  ],
  "procedimiento_puertas_fallo": [
    ImatgePasManual("manual/s2100/sac_08/pilot-exterior.png", "Pilot exterior: localitzar la porta afectada", 26, "S2100 · variant no diferenciada a la fitxa", []),
    ImatgePasManual("manual/s2100/sac_08/selector-ma.png", "Absència de tensió: selector MA1 / MA2", 27, "S2100 · variant no diferenciada a la fitxa", ["MA1", "MA2"]),
    ImatgePasManual("manual/s2100/sac_08/selector-mb-r.png", "Absència de tensió: selector MB1 / R / MB2", 27, "S2100 · variant no diferenciada a la fitxa", ["MB1", "R", "MB2"]),
    ImatgePasManual("manual/s2100/sac_08/remodelat-pinyo.png", "Accés al pinyó inferior; retirada d’objectes només sense tensió", 64, "S2100 remodelat · només en aquesta variant", []),
  ],
  "sac12": [
    ImatgePasManual("manual/s2100/sac_12/comandament-pantograf.png", "Connexió del pantògraf a posada en marxa", 30, "S2100 · variant no diferenciada a la fitxa", []),
  ],
  "sac13_tots_pressio": [
    ImatgePasManual("manual/s2100/sac_13/display-tots-estacionaments.png", "Exemple del DISPLAY: estacionaments a tots els cotxes", 32, "S2100 · variant no diferenciada a la fitxa", []),
    ImatgePasManual("manual/s2100/sac_21/manometre-tdp.png", "Manòmetre: pressió real", 42, "S2100 · variant no diferenciada a la fitxa", []),
  ],
  "sac13_un_pressio": [
    ImatgePasManual("manual/s2100/sac_13/display-un-estacionament.png", "Exemple del DISPLAY: estacionament a un cotxe", 33, "S2100 · variant no diferenciada a la fitxa", []),
    ImatgePasManual("manual/s2100/sac_21/manometre-tdp.png", "Manòmetre: pressió real", 42, "S2100 · variant no diferenciada a la fitxa", []),
  ],
  "procedimiento_tirador": [
    ImatgePasManual("manual/s2100/sac_22/pilot-taronja.png", "Localització del cotxe: pilot exterior taronja", 43, "S2100 · variant no diferenciada a la fitxa", []),
    ImatgePasManual("manual/s2100/sac_22/tirador-rearme.png", "Tirador d’alarma: rearme amb clau", 43, "S2100 · variant no diferenciada a la fitxa", []),
  ],
  "sac23_remodelat": [
    ImatgePasManual("manual/s2100/sac_23/remodelat-pilot.png", "Pilot Tren Stop del pupitre", 64, "S2100 remodelat · només en aquesta variant", []),
  ],
  "sac25_pendent": [
    ImatgePasManual("manual/s2100/sac_25/termic-iris.png", "IRIS: identificació del tèrmic; procediment pendent", 47, "S2100 · variant no diferenciada a la fitxa", []),
    ImatgePasManual("manual/s2100/sac_25/termic-edp-ma2.png", "EDP a MA2: identificació; procediment pendent", 48, "S2100 · variant no diferenciada a la fitxa", ["MA2"]),
    ImatgePasManual("manual/s2100/sac_25/equip-posicio-ma1.png", "Equip de detecció de posició a MA1: identificació; procediment pendent", 48, "S2100 · variant no diferenciada a la fitxa", ["MA1"]),
  ],
  "pregunta_seta": [
    ImatgePasManual("manual/s2100/compartits/bolet-emergencia.png", "Bolet d’emergència de la cabina habilitada", 52, "S2100 · variant no diferenciada a la fitxa", []),
  ],
  "procedimiento_seta": [
    ImatgePasManual("manual/s2100/compartits/bolet-emergencia.png", "Bolet d’emergència de la cabina habilitada", 52, "S2100 · variant no diferenciada a la fitxa", []),
  ],
  "sac13_tots_persisteix": [
    ImatgePasManual("manual/s2100/compartits/bolet-emergencia.png", "Bolet d’emergència de la cabina habilitada", 52, "S2100 · variant no diferenciada a la fitxa", []),
  ],
  "inicio_modo_especial": [
    ImatgePasManual("manual/s2100/mode_especial/manipulador.png", "Manipulador marxa / fre", 8, "S2100 · variant no diferenciada a la fitxa", []),
    ImatgePasManual("manual/s2100/mode_especial/selector-marxes.png", "Selector de marxes", 8, "S2100 · variant no diferenciada a la fitxa", []),
    ImatgePasManual("manual/s2100/mode_especial/clau-govern.png", "Clau de govern", 8, "S2100 · variant no diferenciada a la fitxa", []),
  ],
  "procedimiento_modo_especial": [
    ImatgePasManual("manual/s2100/mode_especial/manipulador.png", "Manipulador marxa / fre", 8, "S2100 · variant no diferenciada a la fitxa", []),
    ImatgePasManual("manual/s2100/mode_especial/selector-marxes.png", "Selector de marxes", 8, "S2100 · variant no diferenciada a la fitxa", []),
    ImatgePasManual("manual/s2100/mode_especial/clau-govern.png", "Clau de govern", 8, "S2100 · variant no diferenciada a la fitxa", []),
    ImatgePasManual("manual/s2100/mode_especial/clau-atc.png", "Bombí de desconnexió ATC / mode especial", 8, "S2100 · variant no diferenciada a la fitxa", []),
    ImatgePasManual("manual/s2100/mode_especial/pilot-me.png", "Pilot de mode especial", 8, "S2100 · variant no diferenciada a la fitxa", []),
  ],
  "procedimiento_modo_especial_llave": [
    ImatgePasManual("manual/s2100/mode_especial/clau-atc.png", "Bombí de desconnexió ATC / mode especial", 8, "S2100 · variant no diferenciada a la fitxa", []),
    ImatgePasManual("manual/s2100/mode_especial/pilot-me.png", "Pilot de mode especial", 8, "S2100 · variant no diferenciada a la fitxa", []),
  ],
  "pregunta_tdp": [
    ImatgePasManual("manual/s2100/sac_21/manometre-tdp.png", "Manòmetre: pressió real", 42, "S2100 · variant no diferenciada a la fitxa", []),
  ],
  "sac_aire": [
    ImatgePasManual("manual/s2100/sac_21/manometre-tdp.png", "Manòmetre: pressió real", 42, "S2100 · variant no diferenciada a la fitxa", []),
  ],
  "sac_aire_pendent": [
    ImatgePasManual("manual/s2100/sac_21/manometre-tdp.png", "Manòmetre: pressió real", 42, "S2100 · variant no diferenciada a la fitxa", []),
  ],
  "sac21_intermitent": [
    ImatgePasManual("manual/s2100/sac_21/manometre-tdp.png", "Manòmetre: pressió real", 42, "S2100 · variant no diferenciada a la fitxa", []),
  ],
  "procedimiento_quitar_estacionamiento_cabina": [
    ImatgePasManual("manual/s2100/sac_13/des-con-des.png", "Estacionament: CON / DES", 32, "S2100 · variant no diferenciada a la fitxa", []),
  ],
};
