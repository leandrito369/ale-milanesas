# RD-MR-PARTIDAS-001 — Ampliación del Modelo Relacional a 62 tablas (PARTIDA_INSUMO)

**Fecha:** 06/11/2026. **Estado:** RATIFICADA POR EL RESPONSABLE MEDIANTE APROBACIÓN FORMAL DEL RP-MR-002 (PR #34); **incorporación documental pendiente de revisión y merge**.
**Responsable:** Víctor Leandro Machado (`leandrito369`).
**MR y operación:** Ampliación de MR-5 (60 tablas) a MR-6 (62 tablas) para trazabilidad física de existencias de Insumos. UCs afectados: UC-08, UC-09, UC-28, UC-31, UC-36, UC-42, UC-51, UC-64 (aditivo).

**Anclas inmutables:** `source_commit=1263ffc17bd0eb7f3c69faaa9ff5ae556cf9de7e`; `governance_commit=27738b089afdd2698cdae915f75c0e8089a6248a`.
**RD padre:** `RD-UC30-001` (`4971625a215d94a8b9f6439d9b0836e0925ea1ad`).
**RP asociado:** `RP-MR-002` (PR #34 en `leandrito369/ale-milanesas`, merge commit `<SHA_MERGE_RP>`).
**Fuentes:** 4.ª devolución del profesor de cátedra (05/11/2026); ficha Fase4 de UC-08/09/28/31/36/42/51/64; contratos REV-06A; MR-5/F01 (`V1__baseline_mr5.sql`, `V2__f01_cobro_estados.sql`).

## Registro formal §10.4

| Campo | Valor |
|---|---|
| `decision_id` | `RD-MR-PARTIDAS-001` |
| `fecha` | `2026-11-06` |
| `estado` | `RATIFICADA POR APROBACIÓN FORMAL DE RP-MR-002; PENDIENTE INTEGRACIÓN DOCUMENTAL` |
| `autoridad` | Víctor Leandro Machado, responsable del proyecto |
| `regla_aprobada` | Ampliación del MR de 60 a 62 tablas (MR-6) incorporando `PARTIDA_INSUMO` y `DETALLE_MOVIMIENTO_PARTIDA`, con las decisiones D1-D4, el DDL aprobado y las resoluciones de las 5 preguntas abiertas, sin modificar las 60 tablas existentes ni la línea base G0. |
| `alternativas_descartadas` | (1) Agregar `fechaVencimiento` a `INSUMO`: no distingue envases individuales; (2) solo `PARTIDA_INSUMO` sin `DETALLE_MOVIMIENTO_PARTIDA`: no permite consumo distribuido; (3) separar `LOTE_FABRICACION` + `ENVASE_INSUMO` + `MOVIMIENTO_ENVASE`: sobreingeniería para el alcance académico. |
| `justificacion` | Resuelve la insuficiencia funcional del MR-5 sin invalidar las 60 tablas, contratos, UCs ni tests de integración existentes. Satisface las 5 exigencias del profesor. |
| `artefactos_afectados` | RD nueva; migración Flyway `V3__trazabilidad_partidas_insumo.sql`; 8 UCs ampliados (UC-08, 09, 28, 31, 36, 42, 51, 64); contratos; diagrama Draw.io; diccionario; `source-lock.md` en `ale-milanesas-app`. G0/MR-5/F01 sin cambios. |
| `fuente_chat` | 4.ª devolución del profesor de cátedra (05/11/2026); conversación de trabajo del 06/11/2026. No es una exportación íntegra. |
| `fecha_propagacion` | Pendiente de incorporación de la RD por PR documental y PR posterior de aplicación en `ale-milanesas-app`. |
| `pruebas` | No ejecutadas para esta RD; se requieren los casos de la sección final y evidencia de CI/aceptación en el PR de aplicación. |

## Decisiones ratificadas

1. **D1 — Identidad física de la existencia (`PARTIDA_INSUMO`).** Cada registro representa una unidad o envase físicamente controlable perteneciente a un `INSUMO`. Dos envases del mismo `codigoLote` con apertura independiente se registran como partidas separadas. `idRecepcionCompra` es **nullable** (origen por `UC-08` o `UC-42`). `fechaVencimiento` es **nullable** (insumos no perecederos: envases, bolsas, bandejas). `fechaHoraRegistro` es **obligatorio**.

2. **D2 — Trazabilidad de movimientos (`DETALLE_MOVIMIENTO_PARTIDA`).** Todo `MOVIMIENTO_INSUMO` se desglosa en ≥1 fila de `DETALLE_MOVIMIENTO_PARTIDA`. La FK compuesta `(idPartidaInsumo, idInsumo)` y `(idMovimientoInsumo, idInsumo)` garantiza que partida y movimiento correspondan al mismo insumo **por construcción relacional**. Apertura implícita en el primer consumo sobre partida con `fechaHoraApertura IS NULL`. Apertura explícita permitida en `UC-28` y `UC-42`. El costeo se mantiene en `MOVIMIENTO_INSUMO → COSTO_INSUMO_HISTORICO`; el costo específico por partida queda recuperable por join (`PARTIDA_INSUMO → RECEPCION_COMPRA.costoUnitarioReal`), sin materializarse en esta versión.

3. **D3 — Vencimiento y aptitud (`stockUtilizable`).** `stockUtilizable` = `cantidadDisponible > 0 AND (fechaVencimiento IS NULL OR fechaVencimiento >= fechaActual)`. Partidas vencidas: bloqueadas para consumo en `UC-28`, visibles en `UC-09`, se descuentan solo vía `UC-42` (`AJUSTE_NEGATIVO`). `EPISODIO_FALTANTE` mantiene su semántica actual (sobre `stockActual` físico). Umbral sobre `stockUtilizable` requiere RD separada (`RD-MR-UMBRAL-UTILIZABLE-001`), fuera del alcance de este corte.

4. **D4 — Selección FEFO.** Orden de propuesta en `UC-28`: (1) envases abiertos por `fechaHoraApertura ASC`; (2) FEFO por `fechaVencimiento ASC NULLS LAST`; (3) antigüedad por `fechaHoraRegistro ASC`. Override manual permitido sobre partidas utilizables. Nunca consumir partidas vencidas ni superar `cantidadDisponible`.

5. **Resoluciones de las 5 preguntas abiertas del RP.** (1) Backfill obligatorio `BACKFILL_V2` por insumo con `stockActual > 0`; (2) `pg_advisory_xact_lock(idInsumo)` para MVP; (3) `EPISODIO_FALTANTE` sobre `stockActual` físico; (4) apertura explícita permitida en `UC-28`/`UC-42`; (5) costeo histórico intacto, materialización por partida como deuda evolutiva (`RD-MR-COSTEO-POR-PARTIDA-001`).

6. **DDL aprobado.** Dos tablas nuevas + 1 `UNIQUE` compuesto en `MOVIMIENTO_INSUMO` (`uq_movimiento_insumo_insumo`). `CHECK` de cantidades, fechas y apertura. `FK` a `INSUMO` y `RECEPCION_COMPRA`. Sin cambios a las 60 tablas existentes.

## Alcance y salvaguardas

- **G0 y MR-5/F01 permanecen inmutables.** La ampliación se tramita como MR-6 vía nueva migración `V3__trazabilidad_partidas_insumo.sql` (no se edita `V1` ni `V2`).
- **8 UCs ampliados aditivamente.** Sin romper flujos existentes ni UCs no listados.
- **Cero cambios al código de implementación** hasta que esta RD sea propagada a `source-lock.md` y el PR de aplicación esté aprobado.
- **Cero cambios al mecanismo de costeo histórico** (`MOVIMIENTO_INSUMO → COSTO_INSUMO_HISTORICO`).
- **Triple gate no-prod intacto.** Los flags `productos-uc*-enabled` y `usuarios-uc*-enabled` permanecen `false` por defecto; `@Profile("!prod")` y vetos en `PrecondicionesDespliegue` sin cambios.
- **Issue #28 (pausa de despliegue) permanece ABIERTA.** La implementación de MR-6 puede avanzar; el despliegue no.
- **La `RD-UC30-001`** sigue vigente y esta RD no la sustituye; se referencian mutuamente.

## Pruebas requeridas para su implementación

Escenario demostrativo de las 5 bolsas de pan rallado (`RP-MR-002` §8.2): ingreso por `UC-08`/`UC-42`; consumo parcial de P-001 (1.000 g) + P-002 (300 g) en `UC-28`; verificación de apertura implícita; bloqueo de partida vencida en `UC-28`; disparo de `EPISODIO_FALTANTE` al cruzar `umbralMinimo`; conciliación `SUM(cantidadDisponible) = INSUMO.stockActual`; backfill de partidas históricas.

Evidencia requerida en PR de implementación: versiones, tests reales con Testcontainers PostgreSQL 17.11, estado de CI (10/11 o 11/11 verde), ausencia de regresiones en los workflows `uc*-http-real` existentes.

**Gobernanza:** esta RD registra únicamente las decisiones ratificadas por el Responsable el 06/11/2026 mediante aprobación formal del RP-MR-002. No sustituye ni reescribe G0 ni actualiza el `source_commit` de la aplicación; su efecto documental queda sometido a la revisión e integración del PR correspondiente. Cualquier cambio al alcance, a las decisiones D1-D4 o al DDL aprobado requiere nueva RD.