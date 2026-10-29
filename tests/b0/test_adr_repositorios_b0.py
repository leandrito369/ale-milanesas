"""Validación B0 de decisiones documentadas; NO es prueba de implementación."""
import pathlib
import unittest

BASE = pathlib.Path(__file__).resolve().parents[2]
B0 = BASE / "docs" / "01-gobierno" / "b0"
ARQ = BASE / "docs" / "06-arquitectura"


class DecisionesADR(unittest.TestCase):
    def test_cinco_adr_ratificadas_y_b105_pendiente(self):
        acta = (B0 / "RD_B0_ADR_ARQUITECTURA_APROBADA_2026-10-29.md").read_text(encoding="utf-8")
        for n in ("01", "02", "03", "04", "06"):
            with self.subTest(adr=n):
                self.assertIn(f"ADR-B1-{n}", acta)
        self.assertIn("RATIFICADA", acta)
        self.assertIn("ADR-B1-05", acta)
        self.assertIn("NO RATIFICADA COMO DISEÑO FÍSICO", acta)
        self.assertIn("CR_B0_F04_001", acta)

    def test_cr_f04_no_aprueba_sql(self):
        cr = (B0 / "CR_B0_F04_001_DISENO_FISICO_SINCRONIZACION_PENDIENTE_2026-10-29.md").read_text(encoding="utf-8")
        self.assertIn("PENDIENTE DE PROPUESTA TÉCNICA", cr)
        self.assertIn("NO AUTORIZADO", cr)
        self.assertIn("RD-F04-001", cr)
        self.assertIn("COBRO.estadoCobro", cr)

    def test_repositorio_de_implementacion_pendiente_y_regla_de_espera(self):
        rd = (B0 / "RD_B0_SEPARACION_REPOSITORIOS_2026-10-29.md").read_text(encoding="utf-8")
        handoff = (ARQ / "HANDOFF_REPOSITORIO_IMPLEMENTACION_PENDIENTE_2026-10-29.md").read_text(encoding="utf-8")
        self.assertIn("AÚN NO CREADO/NO INFORMADO", rd)
        self.assertIn("NO crear repositorio", rd)
        self.assertIn("G0 formalmente aprobado", rd)
        self.assertIn("nuevo repositorio de implementación", handoff)

    def test_g0_d02_resuelto_pero_gate_no_aprobado(self):
        gate = (B0 / "B0_INFORME_GATE_G0_PARA_APROBACION_2026-10-29.md").read_text(encoding="utf-8")
        self.assertIn("**G0-D02** — ADR de arquitectura | **RESUELTA**", gate)
        for id in ("G0-D01", "G0-D03", "G0-D04", "G0-D05"):
            self.assertIn(id, gate)
        self.assertIn("G0 NO APROBADO", gate)


if __name__ == "__main__":
    unittest.main()
