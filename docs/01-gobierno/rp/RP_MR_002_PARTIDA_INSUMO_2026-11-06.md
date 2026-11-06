# RP-MR-002 — Ampliación del Modelo Relacional a 62 tablas

## Identificación

| Campo | Valor |
| --- | --- |
| **RP ID** | **RP-MR-002** |
| **Fecha** | 2026-11-06 |
| **Estado** | **PROPUESTA** (lista para homologación) |
| **Autoridad solicitante** | **Victor Leandro Machado** (`leandrito369`), Responsable del proyecto |
| **Origen** | **4.ª devolución del profesor de cátedra** (05/11/2026) |
| **RD asociada** | **RD-MR-PARTIDAS-001** (a registrar al aprobar este RP) |
| **Base actual** | **MR-5 / F01 (60 tablas)** — inmutable en **G0** |
| **Propuesta** | **MR-6 (62 tablas)** — ampliación por migración **V3** |
| **source_commit (G0)** | `1263ffc17bd0eb7f3c69faaa9ff5ae556cf9de7e` (**inmutable**) |
| **governance_commit** | `27738b089afdd2698cdae915f75c0e8089a6248a` (acta **RD-B0-G0-001**) |
| **RD-UC30-001** | `4971625a215d94a8b9f6439d9b0836e0925ea1ad` |
| **Repo de implementación** | `leandrito369/ale-milanesas-app @ main` |

---

## 1. Contexto y motivación

### 1.1 Origen de la propuesta

La **4.ª devolución del profesor de cátedra** señala una insuficiencia funcional real del Modelo Relacional actual (**MR-5**):

> *"El sistema controla stock agregado pero no puede determinar exactamente de qué lote o envase proviene ese consumo."*

Las **5 exigencias funcionales** del profesor son:

| Exigencia | Estado en MR-5 |
| --- | --- |
| Conocer la cantidad total disponible de cada insumo | ✅ **Contemplado** (`INSUMO.stockActual`) |
| Registrar la fecha de adquisición y procedencia de cada existencia | ⚠️ **Parcial** (`RECEPCION_COMPRA`) |
| Identificar lotes y sus respectivos vencimientos | ❌ **No contemplado** |
| Registrar cuándo se abre un envase o unidad de insumo | ❌ **No contemplado** |
| Identificar qué lote se usó en una preparación y cuál conviene usar primero | ❌ **No contemplado** |

### 1.2 Análisis de la limitación actual

El diseño actual distingue **dos niveles**:

1. **Identidad del insumo**: qué es el pan rallado (**INSUMO**).
2. **Movimiento agregado**: cuánto ingresó o se consumió (**MOVIMIENTO_INSUMO**).

Falta un **tercer nivel**: la **identidad física de la existencia** (de qué envase/bolsa proviene, cuándo vence, cuándo se abrió, cuánto queda).

### 1.3 Marco normativo

* **G0 es inmutable** (`source_commit=1263ffc...`). No se modifica.
* **MR-5/F01 son inmutables** (adenda **RD-UC30-001**).
* La ampliación se tramita como **MR-6** con nueva migración **Flyway V3**.
* El cambio **no toca las 60 tablas existentes**, solo agrega **2 nuevas**.
* Los contratos, UCs y tests existentes se preservan (con **ajustes aditivos en 8 UCs**).

---

## 2. Alcance

### 2.1 Dentro del alcance

* Incorporar **PARTIDA_INSUMO** (existencia física controlable).
* Incorporar **DETALLE_MOVIMIENTO_PARTIDA** (desglose de cada movimiento entre partidas).
* Ajustar **8 UCs existentes** (aditivo, sin romper flujos).
* Documentar **D1-D4** y las **5 preguntas abiertas** resueltas.
* Definir el plan de migración **Flyway V3**.

### 2.2 Fuera del alcance

* **NO** modificar las **60 tablas existentes**.
* **NO** modificar `source_commit` de **G0**.
* **NO** introducir eventos de auditoría de Producto (**RD-UC30-001**).
* **NO** cambiar el mecanismo de costeo histórico (se mantiene `MOVIMIENTO_INSUMO` a `COSTO_INSUMO_HISTORICO`).
* **NO** agregar campos a **INSUMO** ni **MOVIMIENTO_INSUMO**.
* **NO** crear nuevos UCs (se amplían los existentes).

---

## 3. Diseño propuesto

### 3.1 Decisiones arquitectónicas D1-D4

**D1 — Identidad física de la existencia (PARTIDA_INSUMO)**
Cada registro representa una **unidad o envase físicamente controlable** (bolsa, paquete, bandeja, envase) perteneciente a un **INSUMO**.

* Dos envases del mismo `codigoLote` con apertura independiente generan **partidas separadas**.
* `idRecepcionCompra` **nullable**: permite origen por **UC-08** (compra) o **UC-42** (saldo inicial/ajuste positivo).
* `fechaVencimiento` **nullable**: insumos no perecederos (envases, bolsas, bandejas).
* `fechaHoraRegistro` **obligatorio**: cuándo se incorporó al inventario.

**D2 — Trazabilidad de movimientos (DETALLE_MOVIMIENTO_PARTIDA)**
Todo **MOVIMIENTO_INSUMO** se desglosa en **1 o más filas** de **DETALLE_MOVIMIENTO_PARTIDA**.

* **FK compuesta** `(idPartidaInsumo, idInsumo)` y `(idMovimientoInsumo, idInsumo)` garantiza que partida y movimiento correspondan al **mismo insumo por construcción relacional** (no solo por trigger).
* **Apertura implícita**: primer consumo sobre partida con `fechaHoraApertura IS NULL` la fija automáticamente.
* **Apertura explícita**: **UC-28** y **UC-42** permiten marcar apertura sin consumo.
* **Costeo**: se mantiene `MOVIMIENTO_INSUMO` a `COSTO_INSUMO_HISTORICO`. El costo específico por partida queda recuperable por join (`PARTIDA_INSUMO` a `RECEPCION_COMPRA.costoUnitarioReal`).

**D3 — Vencimiento, aptitud y umbrales (Stock Físico vs Stock Utilizable)**

* **stockUtilizable** = `cantidadDisponible` mayor que 0 `AND (fechaVencimiento IS NULL OR fechaVencimiento` mayor o igual que `fechaActual)`.
* **Partidas vencidas**: bloqueadas para consumo en **UC-28**, visibles en **UC-09**, se descuentan solo vía **UC-42** (`AJUSTE_NEGATIVO`).
* **EPISODIO_FALTANTE**: mantiene su semántica actual (sobre `stockActual` físico). **UC-09** y **UC-31** exponen `stockUtilizable` como dato adicional.
* **Umbral sobre stockUtilizable**: requiere RD separada (**RD-MR-UMBRAL-UTILIZABLE-001**) — fuera del alcance de este RP.

**D4 — Selección FEFO + prelación de abiertos**
Orden de propuesta en **UC-28**:

1. **Envases abiertos**: `fechaHoraApertura ASC`
2. **FEFO**: `fechaVencimiento ASC NULLS LAST`
3. **Antigüedad**: `fechaHoraRegistro ASC`

**Override manual** permitido sobre partidas utilizables. **Nunca consumir vencidas** ni superar `cantidadDisponible`.

### 3.2 DDL propuesto

```sql
-- ─── Tabla #61: PARTIDA_INSUMO ─────────────────────────────────────────────
CREATE TABLE "PARTIDA_INSUMO" (
    "idPartidaInsumo" BIGINT NOT NULL,
    "idInsumo" BIGINT NOT NULL,
    "idRecepcionCompra" BIGINT,
    "codigoLote" VARCHAR(80),
    "fechaFabricacion" DATE,
    "fechaVencimiento" DATE,
    "fechaHoraRegistro" TIMESTAMPTZ NOT NULL,
    "fechaHoraApertura" TIMESTAMPTZ,
    "cantidadInicial" NUMERIC(18,3) NOT NULL,
    "cantidadDisponible" NUMERIC(18,3) NOT NULL,
    CONSTRAINT "pk_partida_insumo" PRIMARY KEY ("idPartidaInsumo"),
    CONSTRAINT "uq_partida_insumo_insumo" UNIQUE ("idPartidaInsumo", "idInsumo"),
    CONSTRAINT "ck_partida_insumo_cantidades" CHECK (
        "cantidadInicial" > 0
        AND "cantidadDisponible" >= 0
        AND "cantidadDisponible" <= "cantidadInicial"
    ),
    CONSTRAINT "ck_partida_insumo_fechas" CHECK (
        "fechaFabricacion" IS NULL OR "fechaVencimiento" IS NULL
        OR "fechaVencimiento" >= "fechaFabricacion"
    ),
    CONSTRAINT "ck_partida_insumo_apertura" CHECK (
        "fechaHoraApertura" IS NULL OR "fechaHoraApertura" >= "fechaHoraRegistro"
    )
);

ALTER TABLE "PARTIDA_INSUMO"
    ADD CONSTRAINT "fk_partida_insumo_insumo"
    FOREIGN KEY ("idInsumo") REFERENCES "INSUMO" ("idInsumo")
    MATCH SIMPLE ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE "PARTIDA_INSUMO"
    ADD CONSTRAINT "fk_partida_insumo_recepcion"
    FOREIGN KEY ("idRecepcionCompra") REFERENCES "RECEPCION_COMPRA" ("idRecepcionCompra")
    MATCH SIMPLE ON UPDATE RESTRICT ON DELETE RESTRICT;

-- ─── UNIQUE compuesto en MOVIMIENTO_INSUMO para FK compuesta de D2 ────────
ALTER TABLE "MOVIMIENTO_INSUMO"
    ADD CONSTRAINT "uq_movimiento_insumo_insumo"
    UNIQUE ("idMovimientoInsumo", "idInsumo");

-- ─── Tabla #62: DETALLE_MOVIMIENTO_PARTIDA ────────────────────────────────
CREATE TABLE "DETALLE_MOVIMIENTO_PARTIDA" (
    "idMovimientoInsumo" BIGINT NOT NULL,
    "idPartidaInsumo" BIGINT NOT NULL,
    "idInsumo" BIGINT NOT NULL,
    "cantidadAplicada" NUMERIC(18,3) NOT NULL,
    CONSTRAINT "pk_detalle_movimiento_partida"
        PRIMARY KEY ("idMovimientoInsumo", "idPartidaInsumo"),
    CONSTRAINT "ck_detalle_movimiento_partida_cantidad" CHECK ("cantidadAplicada" > 0)
);

ALTER TABLE "DETALLE_MOVIMIENTO_PARTIDA"
    ADD CONSTRAINT "fk_detalle_mov_partida_movimiento"
    FOREIGN KEY ("idMovimientoInsumo", "idInsumo")
    REFERENCES "MOVIMIENTO_INSUMO" ("idMovimientoInsumo", "idInsumo")
    MATCH SIMPLE ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE "DETALLE_MOVIMIENTO_PARTIDA"
    ADD CONSTRAINT "fk_detalle_mov_partida_partida"
    FOREIGN KEY ("idPartidaInsumo", "idInsumo")
    REFERENCES "PARTIDA_INSUMO" ("idPartidaInsumo", "idInsumo")
    MATCH SIMPLE ON UPDATE RESTRICT ON DELETE RESTRICT;

```

### 3.3 Materialización de cantidadDisponible

Se materializa con **trigger de auditoría** en **DETALLE_MOVIMIENTO_PARTIDA** (`INSERT`/`UPDATE`/`DELETE`) que recalcula `PARTIDA_INSUMO.cantidadDisponible`.
**Job de reconciliación periódica** valida `SUM(cantidadDisponible) = INSUMO.stockActual`. El job se implementa fuera de la migración **V3** (en **B3**).

---

## 4. Resolución de las 5 preguntas abiertas

| # | Pregunta | Resolución | Justificación |
| --- | --- | --- | --- |
| **1** | **Backfill de partidas históricas** | **Obligatorio**: partida legacy `BACKFILL_V2` por insumo con `stockActual` mayor que 0, `codigoLote='BACKFILL_V2'`, `idRecepcionCompra=NULL`. Todos los `MOVIMIENTO_INSUMO` históricos vinculados. | Preserva el **invariante D2** desde el día 1. |
| **2** | **Estrategia de concurrencia** | `pg_advisory_xact_lock(idInsumo)` para **MVP**, consistente con **UC-47/48**. `SELECT ... FOR UPDATE` ordenado por **D4** como evolución futura. | El dominio no exige paralelismo intra-insumo. |
| **3** | **EPISODIO_FALTANTE sobre físico o utilizable** | Mantener sobre `stockActual` **físico**. Exponer `stockUtilizable` en **UC-09** y **UC-31**. Umbral sobre utilizable = **RD evolutiva**. | No rompe **PRA-01** existente. |
| **4** | **Apertura explícita sin consumo** | **Permitida** en **UC-28** y **UC-42** con checkbox. Apertura implícita al consumir sigue automática. | Realidad operativa de cocina. |
| **5** | **Costo por partida** | Mantener `MOVIMIENTO_INSUMO` a `COSTO_INSUMO_HISTORICO` intacto. Costo específico recuperable por join. Materialización en `DETALLE_MOVIMIENTO_PARTIDA` = **RD evolutiva** (`RD-MR-COSTEO-POR-PARTIDA-001`). | Fuera del alcance de **MR-6**, no bloquea el **MVP**. |

---

## 5. Impacto en Casos de Uso

**8 UCs existentes** se amplían (**aditivo**, sin romper flujos):

| UC | Cambio | Tipo |
| --- | --- | --- |
| **UC-08 Registrar Ingreso de Stock por Compra** | Registrar **N partidas** al recibir compra. Postcondición: N filas en `PARTIDA_INSUMO` + N en `DETALLE_MOVIMIENTO_PARTIDA`. | **Aditivo** |
| **UC-09 Consultar Stock** | Exponer `stockUtilizable` + lista de partidas activas ordenadas por **D4**. | **Aditivo** |
| **UC-28 Registrar Preparación de Pedido** | Verificar `stockUtilizable`. Proponer partidas por **D4**. Override manual. Excepción nueva: rechazar consumo si `stockUtilizable` es menor al requerido. | **Aditivo** |
| **UC-31 Configurar Parámetros de Reposición** | Informar **partidas vencidas** que reducen stock utilizable. | **Aditivo** |
| **UC-36 Buscar Insumo** | Mostrar resumen: partidas disponibles, abiertas, próximas a vencer. | **Aditivo** |
| **UC-42 Registrar Ajuste de Inventario** | `SALDO_INICIAL`/`AJUSTE_POSITIVO` crean partidas. `AJUSTE_NEGATIVO` descuenta de partida específica. | **Aditivo** |
| **UC-51 Modificar Insumo** | `PARTIDA_INSUMO` entra en referencias históricas que bloquean cambio de `codigoUnidadMedida`. | **Aditivo** |
| **UC-64 Consultar Movimientos de Inventario** | Expandir cada `MOVIMIENTO_INSUMO` con su `DETALLE_MOVIMIENTO_PARTIDA`. | **Aditivo** |

**No se crean UCs nuevos**. La apertura de envase se cubre como parte de **UC-28** y **UC-42**.

---

## 6. Plan de implementación

### 6.1 Fases

| Fase | Qué | Quién | Duración |
| --- | --- | --- | --- |
| **A** | Aprobación del RP + registro de **RD-MR-PARTIDAS-001** | **Responsable** | 2-3 días |
| **B** | Actualización de `source-lock.md` con nuevo `governance_commit` | **Responsable + Codex** | 1 día |
| **C** | Creación de `V3__trazabilidad_partidas_insumo.sql` (backfill + DDL) | **Antigravity** | 1 día |
| **D** | Actualización de **8 UCs** en documentación + contratos | **Codex** | 2 días |
| **E** | Ajuste de **B3** para emitir `DETALLE_MOVIMIENTO_PARTIDA` en movimientos | **Antigravity** | 2 días |
| **F** | Tests de integración con escenario de las **5 bolsas de pan rallado** | **Antigravity** | 1-2 días |
| **G** | Actualización de diagrama **Draw.io** + diccionario de atributos | **Codex** | 1 día |
| **H** | Merge + CI verde + tag **MR-6** | **Responsable** | 1 día |

**Duración total estimada**: **10-15 días hábiles** desde la aprobación del RP.

### 6.2 Precondiciones

* **Aprobación formal** del RP por el responsable.
* `source-lock.md` actualizado con el nuevo `governance_commit`.
* Confirmación de que `V2__f01_cobro_estados.sql` ya existe en `main` (para no duplicar número de versión).
* Ningún PR abierto que modifique `V1__baseline_mr5.sql` (evita conflictos de migración).

### 6.3 Riesgos

| Riesgo | Mitigación |
| --- | --- |
| **Backfill de datos históricos** | Estrategia `BACKFILL_V2` documentada en **§4.1**. |
| **Regresión en UCs existentes** | Tests de integración por UC + tests de las **5 bolsas**. |
| **Deadlock por concurrencia** | `pg_advisory_xact_lock(idInsumo)` desde el **MVP**. |
| **Divergencia entre stockActual y SUM(cantidadDisponible)** | Job de reconciliación + trigger de auditoría. |
| **Costo por partida no materializado** | Documentado como deuda evolutiva (**RD-MR-COSTEO-POR-PARTIDA-001**). |

---

## 7. Defensa de PREPARACION.idReceta

La observación del profesor sobre eliminar `idReceta` de **PREPARACION** **no procede** por razones técnicas:

* **VERSION_RECETA** es una **entidad débil** con PK compuesta `(idReceta, numeroVersion)`.
* `numeroVersion` es **correlativo por receta** (1, 2, 3...). La Receta 1 y la Receta 2 ambas tienen `numeroVersion=1`.
* Eliminar `idReceta` de **PREPARACION** haría que `numeroVersion` por sí solo sea **ambiguo** (violaría integridad referencial en SQL).
* La **FK compuesta** `(idReceta, numeroVersion)` hacia **VERSION_RECETA** es **relacionalmente correcta**.

**Acción en Draw.io**: representar la relación como un **único conector de FK compuesta**, para eliminar la apariencia de redundancia visual que probablemente indujo la observación.

**Decisión**: **mantener la FK compuesta actual**. No introducir `idVersionReceta` global (requeriría modificar otras relaciones sin beneficio funcional).

---

## 8. Anexos

### 8.1 Documento de conclusiones

`leandrito369/ale-milanesas-app`: `docs/traceability/CONCLUSIONES_CAMBIO_MR_PARTIDA_INSUMO_2026-11-05.md` (**PR #51 mergeado**).

### 8.2 Escenario demostrativo: las 5 bolsas de pan rallado

| Partida | Disponible | Vencimiento | Apertura |
| --- | --- | --- | --- |
| **P-001** | **1.000 g** | 30/11/26 | **01/11/26 (abierta)** |
| **P-002** | **1.000 g** | 15/12/26 | Sin abrir |
| **P-003** | **1.000 g** | 20/12/26 | Sin abrir |
| **P-004** | **1.000 g** | 10/01/27 | Sin abrir |
| **P-005** | **1.000 g** | 25/01/27 | Sin abrir |

**Preparación de 1.300 g de pan rallado**:

* Se consumen **1.000 g de P-001** (ya abierta, **FEFO**).
* Se consumen **300 g de P-002** (primera apertura, **FEFO**).
* `MOVIMIENTO_INSUMO` de **1.300 g** con **2 filas** en `DETALLE_MOVIMIENTO_PARTIDA`.
* **Stock total restante**: **3.700 g**.
* **P-002** queda con **700 g disponibles**.

**Consultas resolubles con el diseño**:

* **¿Cuánto pan rallado tenemos?** → `SUM(cantidadDisponible)` por insumo.
* **¿Cuántas bolsas están abiertas?** → `WHERE fechaHoraApertura IS NOT NULL`.
* **¿Qué bolsa vence primero?** → `ORDER BY fechaVencimiento ASC`.
* **¿Cuánto queda en cada bolsa?** → `SELECT * FROM PARTIDA_INSUMO WHERE idInsumo=?`.
* **¿Qué bolsa se usó en la preparación?** → `DETALLE_MOVIMIENTO_PARTIDA`.

### 8.3 Referencias

* **Contrato canónico**: `CONTRATOS_REV06A_NUEVE_OPERACIONES_B0_ACTUALIZADO.md`
* **Ficha Fase 4**: `UC-08`, `UC-09`, `UC-28`, `UC-31`, `UC-36`, `UC-42`, `UC-51`, `UC-64`
* **RD-UC30-001**: `4971625a215d94a8b9f6439d9b0836e0925ea1ad`
* **MR-5/F01**: `V1__baseline_mr5.sql` + `V2__f01_cobro_estados.sql`
* **Source-lock**: `docs/traceability/source-lock.md` en `ale-milanesas-app`

---

## 9. Solicitud de aprobación

Se solicita al **Responsable del proyecto**:

1. **Aprobación del diseño D1-D4** propuesto.
2. **Aprobación del DDL** (**2 tablas + 1 UNIQUE compuesto**).
3. **Aprobación de las 5 resoluciones** de las preguntas abiertas.
4. **Registro de RD-MR-PARTIDAS-001** en el manifiesto de RDs.
5. **Actualización de `source-lock.md**` con el nuevo `governance_commit` que autoriza **MR-6**.
6. **Autorización para iniciar la implementación** en `ale-milanesas-app`.

**Firma**: **Victor Leandro Machado** — Responsable del proyecto

**Fecha de aprobación**: `_____________`
