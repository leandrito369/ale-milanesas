"""Gate G0 canónico. Comprueba artefactos GIT; no prueba servicios ni docencia."""
import csv
import hashlib
import pathlib
import re
import unittest
from functools import lru_cache
from urllib.parse import unquote

ROOT = pathlib.Path(__file__).resolve().parents[2]
B0 = ROOT / "docs" / "01-gobierno" / "b0"
SOURCE = "1263ffc17bd0eb7f3c69faaa9ff5ae556cf9de7e"
MANIFEST = "G0_MANIFIESTO_CANONICO_67_OPERACIONES_2026-10-29.csv"
BLOB_COLUMNS = (
    ("url_cu_3_niveles_git_inmutable", "blob_git_cu_docx"),
    ("ref_dss", "blob_git_dss"),
    ("ref_ds", "blob_git_ds"),
    ("ref_contrato_preferente", "blob_git_contrato"),
    ("ref_rbac", "blob_git_rbac"),
    ("ref_proyecciones_bc07", "blob_git_proyecciones_bc07"),
)

@lru_cache(maxsize=None)
def content_git_sha(path):
    """Calcula SHA-1 del objeto blob Git sobre los bytes íntegros del árbol."""
    data = (ROOT / path).read_bytes()
    return hashlib.sha1(b"blob " + str(len(data)).encode("ascii") + b"\0" + data).hexdigest()

def source_path(value):
    if "/blob/" in value:
        left, rest = value.split("/blob/", 1)
        sha, path = rest.split("/", 1)
    else:
        sha, path = value.split(":", 1)
    if sha != SOURCE:
        raise ValueError("Referencia no fijada al commit canónico: " + sha)
    return unquote(path)

class ManifiestoCanonico(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        with (B0 / MANIFEST).open(encoding="utf-8", newline="") as stream:
            cls.rows = list(csv.DictReader(stream))

    def test_cobertura_67_operaciones_y_64_cu(self):
        self.assertEqual(len(self.rows), 67)
        self.assertEqual(len({r["cu"] for r in self.rows}), 64)
        self.assertEqual(len({(r["cu"], r["operacion"]) for r in self.rows}), 67)
        self.assertTrue(all(r["source_commit"] == SOURCE for r in self.rows))
        self.assertTrue(all(r["estado_canonicidad_g0"] == "RATIFICADO_E_INTEGRADO_G0_2026-10-29"
                            for r in self.rows))

    def test_precedencia_y_contratos_originales_preservados(self):
        self.assertEqual(sum(r["tipo_contrato"] == "B0_CONSOLIDADO_INTEGRADO_MAIN"
                             for r in self.rows), 40)
        self.assertEqual(sum(r["tipo_contrato"] == "REV_REVISADO_INTEGRADO_MAIN"
                             for r in self.rows), 27)
        for r in self.rows:
            if r["tipo_contrato"] == "B0_CONSOLIDADO_INTEGRADO_MAIN":
                self.assertIn("/consolidacion-b0/", r["ref_contrato_preferente"])
            else:
                self.assertIn("/propuestos/", r["ref_contrato_preferente"])

    def test_402_asociaciones_con_sha_git(self):
        """Validación real de bytes: 67 × 6 campos, sin acceso a web/servicios."""
        count = 0
        for r in self.rows:
            for ref, blob in BLOB_COLUMNS:
                with self.subTest(cu=r["cu"], op=r["operacion"], source=ref):
                    path = source_path(r[ref])
                    self.assertTrue((ROOT / path).is_file(), path)
                    self.assertEqual(content_git_sha(path), r[blob], path)
                    count += 1
            self.assertEqual(r["estado_rbac"], "RATIFICADO_RBAC")
        self.assertEqual(count, 402)

    def test_acta_ratif_Y_estado_bc06(self):
        acta = (B0 / "RD_B0_G0_001_CIERRE_LINEA_BASE_2026-10-29.md").read_text(encoding="utf-8")
        self.assertIn("CIERRE DOCUMENTAL DE B0 / GATE G0", acta)
        self.assertIn("CR-B0-F04-001", acta)
        self.assertIn("0/18", acta)
        self.assertIn(SOURCE, acta)
        self.assertIn("responsable", acta.lower())

if __name__ == "__main__":
    unittest.main()
