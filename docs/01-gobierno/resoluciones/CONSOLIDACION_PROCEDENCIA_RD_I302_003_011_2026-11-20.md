# Consolidación documental y matriz de procedencia — `RD-I302-003` a `RD-I302-011` (`#55–#63`)

**Fecha:** 20/11/2026 (UTC−03)  
**Repositorio:** `leandrito369/ale-milanesas`  
**Base verificada `main`:** `57590500f3b64f521c8e36d3a62206f4619f6174`  
**Source-lock G0 (intacto):** `source_commit = 1263ffc17bd0eb7f3c69faaa9ff5ae556cf9de7e` · `governance_commit = 27738b089afdd2698cdae915f75c0e8089a6248a`  
**Estado de esta PR:** **`OPEN / DRAFT / NO MERGE`** — preservación íntegra y auditoría de procedencia para revisión editorial; **NO** otorga autorización física (`G-FIS`), DDL (`V4`), ni implementación (`G-DEV / R09.1`), **NO** cierra `#55–#63` ni otras PR históricas, **NO** modifica `G0`, `source-lock`, `RBAC` ni contratos originales.

---

## 1. Propósito y método de preservación

Esta PR única preserva **byte a byte** el contenido íntegro de los nueve archivos `RD_I302_003`..`RD_I302_011` recuperados directamente desde el **HEAD real de cada PR `#55–#63`**, sin alterar ni reescribir sus textos originales.

Toda diferencia cronológica, superación parcial o matiz editorial frente a documentos posteriores integrados en `main` (`ACTA_G_COM_001`, `PAQUETE_G_CON_E01_E10` `#65`, `ACT_GCON_R08_6` `#66`, `ART-GCON-C2` `#70`, `G_ARQ_N2_01` `#71`, `G_ARQ_N2_02` `#72`) se documenta exclusivamente en esta matriz de procedencia para revisión del responsable.

**Regla de autoridad:**
- `APROBADA FUNCIONALMENTE` **≠** `AUTORIZADA FÍSICAMENTE` **≠** `AUTORIZADA PARA IMPLEMENTACIÓN` **≠** `PROBADA EN RUNTIME`.
- `S10` (respaldo original de G-ARQ Nivel 1) permanece **`NO ACREDITADO`**; la aceptación autónoma de G-ARQ Nivel 2 del 19/11/2026 no certifica retrospectivamente Nivel 1.

---

## 2. Matriz de procedencia de las nueve RD preservadas

| RD | PR origen | HEAD SHA origen | Ruta preservada (idéntica byte a byte) | SHA-256 contenido | Decisión comercial efectivamente aprobada | Estado funcional | Estado documental | Autorización física / implementación | Dependencias y salvedades | Conflictos editoriales / desfases detectados |
|---|---|---|---|---|---|---|---|---|---|---|
| **RD-I302-003** | `#55` | `9aa8a48ca936dcc9244fcb4da2de6d6262d276ed` | `docs/01-gobierno/b0/RD_I302_003_DC05_04B_PRECEDENCIA_IMPUTACION_MORA_2026-11-15.md` | `e7e9583bc92bcf19cd32ccc1304f856ed898d47c10d9023d6d2e91cd91183acb` | `DC05-04-B`: respetar imputaciones explícitas vigentes antes de aplicar FIFO sobre créditos libres al evaluar deuda/mora (`UC-15`) | **APROBADA FUNCIONALMENTE** (15/11) | Preservada en PR `DRAFT` | **NO** (`G-FIS` / `G-DEV` pendientes) | Depende de `IMP-B` canónico y reconciliación futura de `EvaluadorCategoriaComercialInterno` | Referencia PRs `#53/#54` (DRAFT) y marca pendientes decisiones luego resueltas en `ACTA_G_COM_001` (`RCG-01`/`RCG-03`) |
| **RD-I302-004** | `#56` | `3047e1a327c5447cae3a6538a2712d29a303f4ff` | `docs/01-gobierno/b0/RD_I302_004_DC05_01_02A_RESERVA_ANTICIPO_PEDIDO_2026-11-15.md` | `79ea65ed22dabdffc10703dc51524c1b6cf5468ff9edfc1d9ed112c1e8d8b476` | `DC05-01/02-A`: reserva explícita de anticipo por Pedido excluida de FIFO libre y consolidación al entregar (`UC-05`) | **APROBADA FUNCIONALMENTE** (15/11) | Preservada en PR `DRAFT` | **NO** | Depende de `IMP-B`, `RCG-01` (orden por antigüedad y liberación de sobrante en entrega parcial) | **Matiz editorial M-01:** `ACTA_G_COM_001` `RCG-01` §4 precisó posteriormente la elegibilidad frente a `REEMBOLSO` (`RECHAZADO` no veta disponibilidad; `PENDIENTE`/`PROCESADO` sí descuenta) |
| **RD-I302-005** | `#57` | `bffb510658bb7d0916426165a714446a9fb59812` | `docs/01-gobierno/b0/RD_I302_005_DC05_03A_PERMISOS_RESERVAS_ANTICIPOS_2026-11-15.md` | `5c9355317ecdcac3462116e0d17fd631f58f18d29a1d80b9e1f6cb4c6e273b5c` | `DC05-03-A`: `ADMINISTRADOR` y `VENDEDOR` crean reservas en contexto de Cobro manual; solo `ADMINISTRADOR` corrige/libera excepcionalmente | **APROBADA FUNCIONALMENTE** (15/11) | Preservada en PR `DRAFT` | **NO** (no altera RBAC físico G0 por sí sola) | Requiere pruebas negativas de roles en `G-DEV` y adenda contractual `E-04`/`E-10` | **Matiz editorial M-02:** menciona contrato candidato de permisos; contrastar siempre contra `B0_MATRIZ_RBAC_67_OPERACIONES_CIERRE_2026-10-29.csv` y `ADENDA_BC07_E10` (`#65`) sin ampliar matriz 67×8 |
| **RD-I302-006** | `#58` | `4a72197a626e840ba9e81547f9e5571ee73d9c08` | `docs/01-gobierno/b0/RD_I302_006_DC05_05_06A_LIBERACION_RESERVAS_UC06_2026-11-15.md` | `00df9709ad4b56ef3603ee305f93ddab6b8213599e0070c215cbed2020bea0c8` | `DC05-05/06-A`: liberación automática y obligatoria de reservas elegibles al cancelar Pedido (`UC-06`) hacia crédito libre sin reasignación explícita automática | **APROBADA FUNCIONALMENTE** (15/11) | Preservada en PR `DRAFT` | **NO** | Afecta `UC-06` (planificado en `R09.4`/I4), `IMP-B`, `UC-26` (reembolso electrónico en I6) | **Matiz editorial M-01:** elegibilidad del crédito liberado frente a `REEMBOLSO` queda regida por la precisión posterior de `ACTA_G_COM_001` `RCG-01` §4; enumera pendientes (`DC-01..08`, `D9/D10`) luego cerrados el 16/11 |
| **RD-I302-007** | `#59` | `84ea674df6f151792b628b7cd7ca6317814c3f10` | `docs/01-gobierno/b0/RD_I302_007_DC05_07A_ANULACION_COBROS_CON_RESERVAS_2026-11-15.md` | `fc91e8dca2f1633cd21293f89867812b06c1ebe89f635737df14ff5eead032e4` | `DC05-07-A`: bloquear anulación manual de Cobro con reservas o imputaciones activas; permitir si los vínculos fueron liberados; conservar `D7-A` | **APROBADA FUNCIONALMENTE** (15/11) | Preservada en PR `DRAFT` | **NO** | Coordinada con `ADENDA_REV05_E05` (`#65`), hallazgo `L02` en `fn_mr3_anular_cobro_manual` y `C-04` (idempotencia de anulación pendiente en firma) | Sin contradicción de fondo con `ACTA_G_COM_001` ni `#65/#72`; requiere adenda de firma `claveIdempotenciaAnulacion` (`E-05`) antes de certificar `UC-29/anular` completo |
| **RD-I302-008** | `#60` | `3bbb6187141255c472e246aa5fcfdb836c0a6dcb` | `docs/01-gobierno/b0/RD_I302_008_DC05_09A_MODELO_EVIDENCIA_IMPB_IMPA_IMPC_2026-11-15.md` | `7e0777de5c6a0639d7b55b00df5b92b5ae305edffcca748b60e8f96d0dc62e9d` | `DC05-09-A`: `IMP-B` append-only como fuente canónica inmutable, `IMP-A` proyección derivada, `IMP-C` contención selectiva sin inventar `V_e^0` | **APROBADA FUNCIONALMENTE** (15/11) | Preservada en PR `DRAFT` | **NO** | Base de `RCG-03`, `RCG-06` y prototipo `G-FIS` (`app #101`) | Su §3 marca pendientes fórmulas `C_e/P_e/V_e` que fueron fijadas al día siguiente en `ACTA_G_COM_001` (`RCG-03`) |
| **RD-I302-009** | `#61` | `3abfff88ff3744fb02f4336c60ce17c65653a765` | `docs/01-gobierno/b0/RD_I302_009_D12C_F04_CR_FASE_ONLINE_OFFLINE_2026-11-15.md` | `69c93799adf90a4109310fb8b81fa9dfee9eb37be594766f6b521add89d42115` | `D12-C`: articular `CR-B0-F04-001` en fase online (`PE-1`, `PE-2`, `IMP-01`) y diferir `PE-3` offline a I6/B7 sin eliminarlo del alcance | **APROBADA FUNCIONALMENTE** (15/11) | Preservada en PR `DRAFT` | **NO** (`CR-B0-F04-001` sigue ABIERTA) | Fija el límite de `G-FIS` y `R09.1–R09.5` (sin `PE-3`) | Su §4 cita PR app `#91` como draft (ya integrado en `28bc24e4` como avance parcial de UC-22) y marca pendientes `DC-01..04` luego resueltos |
| **RD-I302-010** | `#62` | `a3bd12d552f2f45baffca147f6cafdaa84284bcb` | `docs/01-gobierno/b0/RD_I302_010_DC01_C1_CARGO_HISTORICO_ENTREGA_2026-11-15.md` | `5dd1bdda4aebf9dde629f333dd9fce842e8d4537958aa46c0158095de3fa8788` | `DC-01-C1`: cargo `C_e` calculado sobre cantidades efectivamente entregadas y valores históricos congelados; bloqueo de adicionales `UC-07` no autorizados | **APROBADA FUNCIONALMENTE** (15/11) | Preservada en PR `DRAFT` | **NO** | Guardia explícita `SOLO_ORIGINALES` / `409` ante adicionales `UC-07` hasta `CR-C`/`CR-F`/`H` | Marca `DC-03` y `DC05-08` como pendientes (resueltos posteriormente el 16/11 en `ACTA_G_COM_001` `RCG-01`/`RCG-02`) |
| **RD-I302-011** | `#63` | `78f9dd6b6a3cb2e9caa193f5bc2b483cfd9ed6be` | `docs/01-gobierno/b0/RD_I302_011_DC02A_DC04A_AJUSTE_Y_REDONDEO_ENTREGA_2026-11-15.md` | `6f2f4c320a84042660baca73ef97ae2d21747ffe899ded034aefa1fa89c6f327` | `DC-02-A` y `DC-04-A`: ajuste comercial histórico congelado aplicado sobre base entregada y redondeo `HALF_UP(2)` compatible con `UC-16` para el tramo original | **APROBADA FUNCIONALMENTE** (15/11) | Preservada en PR `DRAFT` | **NO** | Aplica exclusivamente al tramo original (`RCG-02` rige por separado las ofertas `UC-07`) | **Matiz editorial M-03:** `ACTA_G_COM_001` `RCG-02` precisó posteriormente que `DC-04-A` permanece únicamente para el tramo original y que las ofertas `UC-07` se valoran separadamente (regresión 15,05 × 2 con 10 % = 27,08) |

---

## 3. Regla de precedencia cronológica y contradicciones auditadas

No se hallaron contradicciones comerciales bloqueantes entre las 9 RD (`15/11/2026`) y el paquete integrado en `main@57590500f3b6`. Se registran **tres matices cronológicos explícitos** (sin alterar los textos originales preservados):

1. **Precedencia cronológica (`M-01`, `M-02`, `M-03`):** donde `ACTA_G_COM_001` (`16/11`, `RCG-01..08`), `PAQUETE_G_CON_E01_E10` (`#65`), `ACT_GCON_R08_6` (`#66`) o `ART-GCON-C2` (`#70`, `19/11`) precisan un punto que el 15/11 figuraba como pendiente (ej. elegibilidad de `REEMBOLSO RECHAZADO` en `RCG-01` §4, valoración separada de ofertas `UC-07` en `RCG-02`, `T1 + K2` con `S01–S10` en `#70`), **prevalece la resolución posterior integrada en `main`**, conservando las 9 RD como respaldo íntegro de sus decisiones fundacionales del 15/11.
2. **Referencias a PRs todavía `DRAFT`:** varias de las 9 RD citan `#53` (R08.4) y `#54` (R08.5-C), que continúan abiertas como `DRAFT` históricas; dicha cita es antecedente de origen y no equivale a integración de `#53`/`#54`.
3. **Ninguna autorización física ni de implementación implícita:** todas las 9 RD declaran explícitamente en sus encabezados/dictámenes que no autorizan DDL, `V4`, código `src/main/**`, cambios a `G0`/`RBAC`/`REV04B`/`REV05` ni despliegue.

---

## 4. Clasificación de PR históricas relacionadas (SIN ejecutar cierres)

Esta tabla es exclusivamente informativa para una futura decisión **individual** del responsable (ninguna PR fue cerrada en este corte):

| PR(s) | Categoría propuesta | Condición obligatoria antes de cualquier cierre futuro |
|---|---|---|
| **`#55–#63`** | **Candidatas a cierre tras integración de esta PR** | Solo después de aprobar e integrar esta PR consolidada en `main`, verificando coincidencia exacta de SHA-256 de los 9 archivos. |
| **`#47`, `#48`** | **CONSERVAR ABIERTAS (UC-07)** | Bloqueadas por `CR-C`/`CR-F` (`#48` §15.12 choca con `RCG-02`) y `H/RT-UC07-04`. Fuera del primer incremento de Pedidos originales. |
| **`#44`, `#50–#54`, `#68`, `#69`** | **Revisión individual posterior** | Requieren verificación individual por equivalencia de contenido y preservación de referencias históricas antes de decidir cierre o archivo; no cerrar por coincidencia temática. |
| **`#7`, `#8`** | **Revisión individual posterior** | PRs históricas de octubre en conflicto; evaluar individualmente fuera de la ruta crítica `R08.6`. |
