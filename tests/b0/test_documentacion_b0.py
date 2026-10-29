"""B0: comprobación documental. NO es prueba de backend ni autorizaciones reales."""
import csv
import pathlib
import unittest
from collections import Counter

ROOT = pathlib.Path(__file__).resolve().parents[2]
B0 = ROOT / "docs" / "01-gobierno" / "b0"
CONSOLIDADO = ROOT / "docs" / "08-diagramas" / "consolidacion-b0"
ROLES = ("ADMIN", "VENDEDOR", "PRODUCCION", "REPARTIDOR",
         "PROVEEDOR", "CLIENTE_ONLINE", "AUTOMATISMO", "MERCADOPAGO")


def csvrows(name):
    with (B0 / name).open(encoding="utf-8", newline="") as f:
        return list(csv.DictReader(f))


class DocumentacionB0(unittest.TestCase):
    def test_67_operaciones_y_0_pendientes(self):
        rows = csvrows("B0_MATRIZ_RBAC_67_OPERACIONES_CIERRE_2026-10-29.csv")
        self.assertEqual(len(rows), 67)
        self.assertEqual(len({r["CU"] for r in rows}), 64)
        self.assertTrue(all(set(ROLES).issubset(r) for r in rows))
        self.assertEqual(sum(r[rol] == "P" for r in rows for rol in ROLES), 0)

    def test_tres_decisiones_de_autorizacion(self):
        rows = csvrows("B0_MATRIZ_RBAC_67_OPERACIONES_CIERRE_2026-10-29.csv")
        lookup = {(r["CU"], r["Operación"]): r for r in rows}
        for cu, op, a, v in (
            ("UC-14", "consultarCuentaCorriente", "X", "D"),
            ("UC-03", "reprogramarFechaRepartoPedido", "X", "D"),
            ("UC-29", "anularCobroManual", "D", "X"),
            ("UC-29", "registrarCobro", "D", "D"),
        ):
            with self.subTest(cu=cu, operacion=op):
                self.assertEqual(lookup[cu, op]["ADMIN"], a)
                self.assertEqual(lookup[cu, op]["VENDEDOR"], v)
        self.assertEqual(lookup["UC-29", "registrarCobro"]["REPARTIDOR"], "X")

    def test_quince_proyecciones_ratificadas(self):
        rows = csvrows("BC07_PROYECCIONES_MINIMAS_RATIFICADAS_2026-10-29.csv")
        self.assertEqual(len(rows), 15)
        self.assertEqual(len({(r["cu"], r["rol"]) for r in rows}), 15)
        self.assertTrue(all(r["estado_proyeccion"] == "RATIFICADA_BC07_2026-10-29" for r in rows))

    def test_veintiuna_referencias_propagadas(self):
        rows = csvrows("BC05_PROPAGACION_21_OPERACIONES_2026-10-29.csv")
        self.assertEqual(len(rows), 21)
        self.assertEqual(len({(r["cu"], r["operacion"]) for r in rows}), 21)
        self.assertTrue(all(r["estado_propagacion"] == "PROPAGADA_EN_COPIA_B0" for r in rows))
        count = Counter(r["contrato_consolidado_B0"] for r in rows)
        self.assertEqual(len(count), 8)
        for rel, expected in count.items():
            with self.subTest(contract=rel):
                path = ROOT / rel
                self.assertTrue(path.is_file())
                self.assertEqual(path.read_text(encoding="utf-8").count("Adenda B0-BC05"), expected)

    def test_regla_bc09_y_plan_bc06(self):
        rule = (B0 / "BC09_REGLA_INVOCACION_INTERNA_EXTERNA_2026-10-29.md").read_text(encoding="utf-8")
        for op in ("UC-05", "UC-15", "UC-16", "UC-21", "UC-26", "UC-29", "UC-49"):
            self.assertIn(op, rule)
        tests = csvrows("BC06_CASOS_PRUEBA_IMPLEMENTACION_18.csv")
        self.assertEqual(len(tests), 18)
        self.assertTrue(all(r["estado_ejecucion"] == "NO_EJECUTADO_SIN_BACKEND" for r in tests))


if __name__ == "__main__":
    unittest.main()
