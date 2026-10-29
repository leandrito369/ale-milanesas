"""B0 E01-C: verifica trazabilidad documental, NO servicios ni transacciones."""
import csv
import pathlib
import re
import unittest

ROOT=pathlib.Path(__file__).resolve().parents[2]
B0=ROOT / "docs" / "01-gobierno" / "b0"
FISICO=ROOT / "docs" / "05-modelo-relacional" / "MR3_ESQUEMA_MAESTRO.md"
ROLES=("ADMIN","VENDEDOR","PRODUCCION","REPARTIDOR","PROVEEDOR",
       "CLIENTE_ONLINE","AUTOMATISMO","MERCADOPAGO")
MODULOS={"acceso","maestros","ventas","produccion_inventario",
         "abastecimiento","finanzas","canales_integraciones"}

def read_csv(file):
    with (B0 / file).open("r", encoding="utf-8", newline="") as f:
        return list(csv.DictReader(f))

class MapeoB0(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.maps=read_csv("B0_MAPA_TECNICO_67_OPERACIONES_2026-10-29.csv")
        cls.cobertura=read_csv("B0_COBERTURA_60_TABLAS_Y_OPERACIONES_2026-10-29.csv")
        cls.rbac=read_csv("B0_MATRIZ_RBAC_67_OPERACIONES_CIERRE_2026-10-29.csv")
        cls.catalogo=set(re.findall(r"^###\s+([A-Z][A-Z0-9_]+)\s*$", FISICO.read_text(encoding="utf-8"), re.M))

    def test_67_operaciones_64_cu_y_7_modulos(self):
        self.assertEqual(len(self.maps),67)
        self.assertEqual(len({x["cu"] for x in self.maps}),64)
        self.assertEqual(len({(x["cu"],x["operacion_contrato"]) for x in self.maps}),67)
        self.assertEqual({x["modulo_arquitectonico_candidato"] for x in self.maps},MODULOS)
        self.assertTrue(all(x["estado_diseno_tecnico"]=="DISEÑO_TECNICO_PROPUESTO_NO_RATIFICADO" for x in self.maps))
        self.assertTrue(all(x["estado_software"]=="NO_IMPLEMENTADO_NO_PROBADO" for x in self.maps))

    def test_tablas_existen_en_esquema_mr3_mr5(self):
        self.assertEqual(len(self.catalogo),60)
        self.assertEqual(len(self.cobertura),60)
        self.assertEqual({x["tabla_fisica_mr3_mr5"] for x in self.cobertura}, self.catalogo)
        for x in self.maps:
            with self.subTest(op=x["operacion_contrato"]):
                candidate=set(x["tablas_fisicas_mr3_mr5_existentes"].split("|"))
                self.assertTrue(candidate)
                self.assertTrue(candidate.issubset(self.catalogo))
                self.assertIn(x["estado_cotejo_db"],["TABLES_EXIST_VERIFIED;COLS_SQL_NOT_FULLY_AUDITED"])

    def test_matriz_coincide_con_rbac_ratificada_sin_p(self):
        lookup={(r["CU"],r["Operación"]):r for r in self.rbac}
        self.assertEqual(len(lookup),67)
        for x in self.maps:
            with self.subTest(op=x["operacion_contrato"]):
                match=lookup[(x["cu"],x["operacion_contrato"])]
                expected=";".join(k+"="+match[k] for k in ROLES)
                self.assertEqual(x["rbac_67_ratificado"],expected)
                self.assertNotIn("=P",expected)

    def test_candidato_no_afirma_sql_ni_api_ejecutada(self):
        for x in self.maps:
            self.assertIn("CANDIDATO",x["responsable_servicio_candidato"])
            self.assertIn(x["unidad_transaccional_propuesta"].split("_")[0],("TX","LECTURA"))
            self.assertIn(x["contrato_fuente_preferente"].split("/")[0],"docs")
            self.assertNotEqual(x["pruebas_base"],"PROBADO")
        for x in self.cobertura:
            self.assertIn(x["estado"],("REFERENCIA_CONCEPTUAL_B0_NO_ES_GRANT_SQL","SIN_MAPEO_DIRECTO_REQUIERE_EVALUACION_ADAPTADOR"))

if __name__=="__main__":
    unittest.main()
