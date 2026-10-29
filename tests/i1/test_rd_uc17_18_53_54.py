"""PATCH RD-I1: verificaciones de contenido y XML; no sustituye revisión visual."""
from pathlib import Path
import unittest
import xml.etree.ElementTree as ET
ROOT = Path(__file__).resolve().parents[2]
SEC = ROOT / "docs/08-diagramas/revision/REV02_SEGURIDAD/propuestos"
ACT = ROOT / "docs/01-gobierno/i1"

class RevisionI1Test(unittest.TestCase):
    def test_rd_registradas(self):
        for name in ("RD_UC17_001_POLITICA_CREDENCIAL_INICIAL_2026-10-29.md",
                     "RD_UC18_001_GESTION_ROLES_EVENTOS_2026-10-29.md",
                     "RD_UC53_001_CREDENCIAL_ACTUAL_CONDICIONAL_2026-10-29.md",
                     "RD_UC54_001_VERIFICACION_PROVEEDOR_2026-10-29.md",
                     "IC_UC18_MR5_001_EVENTOS_ROL_2026-10-29.md"):
            with self.subTest(acta=name):
                self.assertIn("APROBADA" if name.startswith("RD_") else "RESUELTA",
                              (ACT / name).read_text(encoding="utf-8"))

    def test_contratos_actualizados(self):
        content = {cu:(SEC / f"contratos/CONTRATO_UC{cu}_REV02.md").read_text(encoding="utf-8")
                   for cu in ("17","18","53","54")}
        for cu, text in content.items():
            with self.subTest(cu=cu):
                self.assertEqual(sum(f"\n{n}. **" in text for n in range(1,10)),9)
        self.assertIn("cambioCredencialPendiente=false",content["17"])
        self.assertIn("cambioCredencialPendiente=true",content["17"])
        self.assertIn("ASIGNACION",content["17"])
        self.assertIn("REVOCACION",content["18"])
        self.assertNotIn("ALTA/BAJA",content["18"])
        self.assertIn("credencialActual: String[0..1]",content["53"])
        self.assertIn("identidadComercialVerificada: Boolean",content["54"])
        self.assertIn("A1", content["54"])
        self.assertIn("A2", content["54"])

    def test_dss_ds_xml_y_mensajes(self):
        files = ["DSS_REV02_SEGURIDAD_CORREGIDO.drawio.xml",
                 "DS_REV02_SEGURIDAD_CORREGIDO.drawio.xml"]
        for filename in files:
            with self.subTest(xml=filename):
                path = SEC / filename
                tree = ET.parse(path)
                # IDs '0'/'1' se repiten legítimamente entre páginas Draw.io;
                # la unicidad se exige dentro de cada <diagram>, no del mxfile.
                for page in tree.findall(".//diagram"):
                    ids = [x.get("id") for x in page.findall(".//mxCell") if x.get("id")]
                    self.assertEqual(len(ids),len(set(ids)), page.get("name"))
                values = " ".join(x.get("value","") for x in tree.findall(".//mxCell"))
                for marker in ("RD-UC17-001", "ASIGNACION", "REVOCACION",
                               "identidadComercialVerificada", "credencialActual"):
                    self.assertIn(marker,values)
                self.assertNotIn("ALTA/BAJA",values)
                self.assertNotIn("POLITICA_PENDIENTE",values)
        assert (SEC / files[0]).exists()

    def test_mr5_eventos_se_conservan(self):
        sql = (ROOT / "docs/05-modelo-relacional/sql/MR5_DDL_NO_EJECUTADO.sql").read_text(encoding="utf-8")
        ini = sql.index('CREATE TABLE "EVENTO_ASIGNACION_ROL"')
        fin = sql.index("\n);",ini)
        section = sql[ini:fin]
        self.assertIn("ASIGNACION",section)
        self.assertIn("REVOCACION",section)
        self.assertNotIn("'ALTA'"," ".join(section.splitlines()))
        self.assertNotIn("'BAJA'"," ".join(section.splitlines()))

if __name__ == "__main__":
    unittest.main()
