"""G0 pre-gate: check immutable source references and non-approval state.
Does not inspect diagram semantics, review PRs, or test application services.
"""
import csv
import pathlib
import re
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[2]
B0 = ROOT / "docs" / "01-gobierno" / "b0"
BASE_SOURCE = "64af3c3baa571c2d512242e396267a31f0da3efd"
BASE_B0 = "56a9fb2cff90bad58fca5d91b4a3abbbc339b8e7"
BASE_MAIN = "ccf4030438f48a9ac39e305a9e73a1bfbdc61545"
HEX = re.compile(r"^[0-9a-f]{40}$")


def rows(name):
    with (B0 / name).open(encoding="utf-8", newline="") as stream:
        return list(csv.DictReader(stream))


class GateG0Fuentes(unittest.TestCase):
    def test_fuentes_67_ops_64_cu_sin_refs_móviles(self):
        all_rows = rows("G0_MANIFIESTO_67_OPERACIONES_FUENTES_INMUTABLES_2026-10-29.csv")
        self.assertEqual(len(all_rows), 67)
        self.assertEqual(len({r["cu"] for r in all_rows}), 64)
        self.assertEqual(len({(r["cu"], r["operacion"]) for r in all_rows}), 67)
        for r in all_rows:
            with self.subTest(cu=r["cu"], op=r["operacion"]):
                self.assertTrue(r["ref_dss"].startswith(BASE_SOURCE + ":"))
                self.assertTrue(r["ref_ds"].startswith(BASE_SOURCE + ":"))
                self.assertIn(r["ref_contrato_preferente"].split(":")[0], {BASE_SOURCE, BASE_B0})
                self.assertTrue(r["url_cu_3_niveles_git_inmutable"].find("/blob/" + BASE_MAIN + "/") > 0)
                for key in ("blob_git_dss", "blob_git_ds", "blob_git_contrato",
                            "blob_git_cu_docx", "blob_git_rbac",
                            "blob_git_proyecciones_bc07"):
                    self.assertRegex(r[key], HEX)
                self.assertEqual(r["estado_rbac"], "RATIFICADO_RBAC")
                self.assertEqual(r["estado_canonicidad_g0"],
                                 "CANDIDATO_G0_PENDIENTE_RATIFICACION_Y_MERGE")

    def test_precedencia_40_b0_27_rev(self):
        entries = rows("G0_MANIFIESTO_67_OPERACIONES_FUENTES_INMUTABLES_2026-10-29.csv")
        self.assertEqual(sum(r["tipo_contrato"] == "B0_CONSOLIDADO_DERIVADO_REV"
                             for r in entries), 40)
        self.assertEqual(sum(r["tipo_contrato"] == "REV_PROPUESTA_COMPROMETIDA"
                             for r in entries), 27)

    def test_repositorio_nuevo_y_bloqueo_de_implementacion(self):
        handoff = (B0 / "G0_ALTA_REPO_IMPLEMENTACION_2026-10-29.md").read_text(encoding="utf-8")
        acta = (B0 / "G0_ACTA_PARA_RATIFICACION_2026-10-29.md").read_text(encoding="utf-8")
        self.assertIn("https://github.com/leandrito369/ale-milanesas-app", handoff)
        self.assertIn("403", handoff)
        self.assertIn("repository_selection=selected", handoff)
        self.assertIn("G0 NO APROBADO", acta)
        self.assertIn("G0-D01", acta)
        self.assertIn("G0-D03", acta)
        self.assertIn("G0-D04", acta)
        self.assertIn("G0-D05", acta)

    def test_handoff_plantillas_no_son_codigo(self):
        agents = (ROOT / "docs" / "06-arquitectura" /
                  "G0_PLANTILLA_AGENTS_REPO_APP_2026-10-29.md").read_text(encoding="utf-8")
        lock = (ROOT / "docs" / "06-arquitectura" /
                "G0_PLANTILLA_SOURCE_LOCK_REPO_APP_2026-10-29.md").read_text(encoding="utf-8")
        self.assertIn("NO PUBLICADA EN APP", agents)
        self.assertIn("NO GENERAR CÓDIGO", agents)
        self.assertIn("PENDIENTE COMMIT CANÓNICO DE G0", lock)


if __name__ == "__main__":
    unittest.main()
