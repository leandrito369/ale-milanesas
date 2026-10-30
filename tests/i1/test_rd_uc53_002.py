"""Pruebas documentales de RD-UC53-002 vs MR5: unitaria y trazabilidad.

No es prueba de servidor ni aceptación B4.
"""
from pathlib import Path
import unittest
import xml.etree.ElementTree as ET

ROOT=Path(__file__).resolve().parents[2]
G=ROOT/"docs/01-gobierno/i1"
S=ROOT/"docs/08-diagramas/revision/REV02_SEGURIDAD/propuestos"

class PruebaRDUC53_002(unittest.TestCase):
    def test_rd_explicita(self):
        text=(G/"RD_UC53_002_REVOCAR_SESIONES_TRAS_CAMBIO_2026-10-29.md").read_text()
        for v in ("RATIFICADA", "todas", "sesión invocante", "nuevo inicio de sesión", "MR-5"):
            self.assertIn(v,text)

    def test_contrato_prioridad_y_sesion(self):
        t=(S/"contratos/CONTRATO_UC53_REV02.md").read_text()
        for v in ("RD-UC53-001", "RD-UC53-002", "todas las sesiones", "nuevo inicio de sesión", "credencialActual"):
            self.assertIn(v,t)
        self.assertNotIn("y habilita en la sesión",t)
        self.assertNotIn("y sesión válida (sin ampliación",t)

    def test_diagramas_parseables_con_correcta_postcondicion(self):
        for n in ("DS_REV02_SEGURIDAD_CORREGIDO.drawio.xml",
                  "DSS_REV02_SEGURIDAD_CORREGIDO.drawio.xml"):
            root=ET.parse(S/n).getroot()
            xml=" ".join(x.attrib.get("value","") for x in root.findall(".//mxCell"))
            self.assertIn("RD-UC53-002",xml)
            self.assertIn("sesiones",xml)
            self.assertNotIn("habilita en la sesión los permisos",xml)

    def test_trigger_mr5_inmutable_declara_revocacion(self):
        t=(ROOT/"docs/05-modelo-relacional/sql/MR5_DDL_NO_EJECUTADO.sql").read_text()
        inicio=t.index('CREATE OR REPLACE FUNCTION "fn_mr5_revocar_sesiones_usuario"')
        f=t[inicio:t.index('CREATE TRIGGER "tg_mr5_revocar_sesiones_usuario"',inicio)]
        self.assertIn('NEW."credencialProtegida" IS DISTINCT FROM OLD."credencialProtegida"',f)
        self.assertIn('"fechaHoraRevocacion"=clock_timestamp()',f)

if __name__=="__main__":
    unittest.main()
