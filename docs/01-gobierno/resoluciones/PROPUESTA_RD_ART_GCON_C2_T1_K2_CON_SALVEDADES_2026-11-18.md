# PROPUESTA RD-ART-GCON-C2-001 — Protocolo de rendición T1-C2 + cardinalidad K2

**Fecha de propuesta:** 18/11/2026 (Argentina).  
**Proyecto:** Sistema de Gestión para Ale Milanesas.  
**Autoridad reservada:** responsable del proyecto.  
**ESTADO CONTRACTUAL:** **RATIFICADA POR DECLARACIÓN EXPRESA EN CONVERSACIÓN** el 19/11/2026 02:49:39 UTC (18/11/2026 23:49:39 Argentina), **T1-C2 + K2 CON LAS DIEZ SALVEDADES S01–S10**. **ESTADO EDITORIAL:** PR DRAFT / SIN MERGE / NO INCORPORADA A GOBIERNO MAIN. La declaración en chat no es GitHub Review APPROVED ni firma digital certificada; tampoco certifica G-ARQ/G-FIS.  
**Puerta de elaboración:** R08.6 Puerta 1 (18/11/2026), solo análisis/documentación, sin cambios físicos.  
**Línea base de gobierno consultada:** `leandrito369/ale-milanesas` main @ `9076570ff3329864fe85c990bcc6f4ff7a63d6e5`.  
**Línea base de app consultada (solo lectura):** `leandrito369/ale-milanesas-app` main @ `f5c9af3f76723d5364d44647cfd43ea13a9fd7b5`.  
**Source-lock inmutable:** source_commit `1263ffc17bd0eb7f3c69faaa9ff5ae556cf9de7e`; governance_commit `27738b089afdd2698cdae915f75c0e8089a6248a`.

> El responsable **aprobó expresamente T1 + K2 con las diez salvedades**. La decisión es vinculante en su **alcance conceptual** y queda pendiente de incorporación editorial con preflight y autorización de merge independiente. No certifica diseño físico, migraciones, pruebas, API, despliegue ni corrección del código existente.

## 1. Objeto, autoridad y diagnóstico

**Decisión ratificada en alcance conceptual:** seleccionar para la rendición administrativa del recorrido `T1-C2` (confirmación financiera agregada en una sola transacción) frente a `T2-C2` (aplicaciones financieras con COMMIT individual), y seleccionar `K2` (Cobro por Cliente/cierre y aplicaciones trazables a sus Entregas) frente a `K1` (Cobro por Entrega). `K3`, Cobro único multicliente, está descartado por RCG-04.

**No confundir:** `T1-C2/T2-C2` son alternativas de ART-GCON-C2. Las etiquetas `T1=UC-05`, `T2=UC-29`, `T3=anularCobroManual` utilizadas en R08.5 son **operaciones concurrentes**, no alternativas de este voto.

**Autoridad de referencia:**
- **RD-F04-002**: ADMINISTRADOR recibe/verifica/rinde al finalizar recorrido; ante diferencias, rendición **PENDIENTE DE CONCILIACIÓN** hasta resolución motivada del ADMINISTRADOR. No inventar nuevos estados de `COBRO`.
- **RD-F04-005**: faltante en tránsito validado no genera Cobro/Caja ni deuda exigible restaurada automáticamente; su investigación/recuperación queda fuera del alcance decidido.
- **ACT-G-COM-001** RCG-01..08 ratificada y vigente: fórmula `K_e`, `V_e^0`, `V_e^{vig}`, `A_e`, FIFO vinculante, custodia y BC-07, Cobros `origen='REPARTO'`, idempotencia.
- **ART-GCON-C1-a** aprobada en declaración original de PR #66: cierre único por recorrido, `claveIdempotenciaCierre: UUID`, huella semántica versionada, recibo histórico de replay y conflictos.
- **ART-GCON-C2** en PR #66: **NO VOTADO / DIFERIDO**, hasta nueva decisión expresa. La autorización editorial de PR #66 registrada en su conversación no decide C2.
- **ART-GCON-A1/B1/D1** ratificadas en el alcance de la declaración: evidencia fallida post-rollback, 422 cobertura insuficiente y adenda de anulación; no se reabren.
- **PR #69**, documento `EXPEDIENTE_ART_GCON_C2_T1_VS_T2_2026-11-18.md`: comparación de alternativas y ejemplos, **no un test ni una decisión**.
- **PR #68**: matriz de conciliación R08.6, DRAFT. **PR #65**: adendas E-01..10, DRAFT. Ninguna se integra por este acto.

## 2. Revisión crítica del expediente PR #69 y salvedades

| Salvedad | Hallazgo verificable | Carácter en esta propuesta | Condición de aceptación |
|---|---|---|---|
| S01 — diferencias | PR #69 ilustra 170,00 aplicados, 10,00 de custodia y 10,00 de `V_e^{vig}` remanente; eso **no prueba** cierre conciliado. RD-F04-002/005 exigen pendencia o resolución motivada ADMIN. | **Bloqueo de cierre automático** | No emitir recibo de **cierre definitivo** si existen diferencias no resueltas. Si ADMIN las resuelve con motivo, registrar resolución y no extinguir por ficción el tránsito. |
| S02 — saldo remanente | `V_e^{vig}>0` tras aplicación parcial; el recorrido se cierra una sola vez C1-a. RD-F04-005 **no decide** recuperación/efecto después de conciliación. | **Límite de alcance explícito** | Conservar saldo y evidencia íntegros; no permitir segunda clausura, restitución automática de deuda, Cobro ficticio ni nueva operación G0. Procedimiento posterior requiere RD propia si se necesita. |
| S03 — claves | K2 implica varios Cobros del mismo cierre y V1 `COBRO.claveIdempotenciaOrigen` tiene UNIQUE global. | **Obligación de G-ARQ** | Una clave de cierre no puede reutilizarse indistintamente en todos los Cobros; identidades por Cobro/Cliente unívocas, vinculadas y recuperables, sin algoritmo elegido ahora. |
| S04 — K2 | V1 `COBRO.idCliente NOT NULL`, `idPedido` nullable, y `ORIGEN_MOVIMIENTO_CUENTA` no representa porción de Cobro por Entrega. | **Brecha física** | Vínculo verificable cierre–Cobro–Cliente–Entrega–aplicación–importe; Σ aplicaciones positivas por Cobro = importe Cobro; sin mezclar Clientes ni inferir aplicaciones desde idPedido. |
| S05 — concurrencia | `CobroManualService` actual usa advisory `2929001`, CLIENTE y COBRO en distinto orden entre alta y anulación; C3-08 registró 40P01 al invertir Pedido/Cliente. | **Bloqueo de G-FIS** | Grafo global de locks/generadores y pruebas C3 reales, incluyendo función SQL, triggers, UC-05/29/03/07/15/19/28/43; una corrida favorable no certifica todo. |
| S06 — atomicidad/replay | T1 permite rollback integral; ACK perdido requiere recuperar recibo histórico sin duplicar Cobro/PAGO/Caja. | **Obligación contractual** | Identidad y huella durables junto con efectos finales; fallos antes COMMIT sin efecto aplicado, COMMIT+ACK perdido con replay histórico y revalidación de autorización. |
| S07 — cobertura y cero | Falta de evidencia puede ser 422 (B1), no permiso para fabricar `V_e`, Cobro o Caja. El cierre con 0 aplicaciones/custodia sola no está completamente definido. | **Caso fuera del «happy path»** | Prohibir Cobros de importe cero y cierre automático sin cobertura. Diseñar atención motivada según RD-F04-002; excepciones sin regla suficiente no pueden certificarse como completas. |
| S08 — custodia | El efectivo físico no imputable no es venta ni crédito automático; sumar Caja+custodia como arqueo simple sería incorrecto. | **Vinculante RCG-04** | Custodia vinculada a recepción original, sin segundo ingreso; tres vistas de arqueo y controles por rol/objeto. |
| S09 — tiempo de locks | T1 prolonga bloqueos para recorridos masivos y toca Cliente(s) múltiples. | **Riesgo técnico medible** | Ensayo de carga y timeout; si T1 no es viable, devolver C2 a decisión, no cambiar por T2 unilateralmente ni crear límite comercial nuevo. |
| S10 — G-ARQ N1 | PR #66 informa que una resolución G-ARQ Nivel 1 fue reportada pero no respaldada allí con texto original/SHA. | **Dependencia documental** | Obtener fuente y SHA exactos o dejar «no acreditada» sin dar por cerradas puertas basadas en ella. |

**Dictamen de revisión:** T1-C2 + K2 es una opción **arquitectónicamente preferible para el primer corte ONLINE**, si y solo si se respetan S01–S10. El diseño no está probado: S01/S02 delimitan comportamiento y S03–S10 se elevan a contratos, diseño físico y C3. El ejemplo de PR #69 es una **ilustración económica**, nunca evidencia de que una rendición con diferencias quedó lícitamente cerrada.

## 3. Texto de resolución — ratificado en alcance conceptual por declaración del responsable

**ART-GCON-C2-001 / Decisión declarada: APROBAR CON SALVEDADES EXPRESAS (T1-C2 + K2, S01–S10).**

**C2-R01 — Elección transaccional.** Adoptar para el **primer incremento online de rendición UC-29** la alternativa `T1-C2`: el acto de cierre **autorizado** de un recorrido confirma dentro de una **sola transacción ACID** el conjunto completo de aplicaciones definitivas, sus Cobros `REPARTO`, movimientos de Cuenta, ingresos de Caja de venta, reducción equivalente de `V_e^{vig}`, huella y recibo de cierre. Un error anterior al COMMIT revierte **todos esos efectos del intento**, sin considerar la clave como aplicada. Esta decisión no exige que la validación de interfaz o la preparación documental ocurran dentro de la transacción, pero exige revalidación vinculante al confirmar.

**C2-R02 — Elección de cardinalidad K2.** Adoptar conceptualmente `K2`: **a lo sumo un Cobro de rendición confirmado por Cliente con importe positivo y por cierre de recorrido**, con **una o varias aplicaciones** explícitas a Entregas del **mismo Cliente**; cada aplicación positiva pertenece a exactamente un Cobro y una Entrega elegible. Un cierre puede generar cero o varios Cobros, siempre segregados por Cliente; un Cobro de distintos Clientes está prohibido. El importe de cada Cobro es exactamente la suma de sus aplicaciones. No se determina aquí cómo se distribuyen futuras regularizaciones, múltiples medios de pago ni una forma SQL concreta.

**C2-R03 — Preservación de decisiones vigentes.** Mantener D6-1 (ADMIN rendición), C1-a (único cierre por recorrido y replay histórico), D7-A (veto de anulación de Cobros vinculados), RCG-01..08, RD-F04-002/003/005 y el RBAC/BC-07 G0. `COBRO.estadoCobro` continúa solo `CONFIRMADO`/`ANULADO`; la rendición pendiente no añade un estado a Cobro. `COBRO.idPedido` no equivale a una aplicación financiera.

**C2-R04 — Diferencias y condición de cierre.** Si se detecta una diferencia, **la rendición permanece pendiente de conciliación**: no emitir recibo de cierre definitivo ni declarar Caja cuadrada por omisión. Solo el ADMINISTRADOR puede resolver y cerrar una rendición con diferencias, con **motivo registrado**, evidencia y distinción entre efectivo recibido, atribuido, faltante constatado, tránsito remanente y custodia. No crear Cobro/Caja de venta por dinero faltante o no imputable; no restaurar automáticamente deuda exigible del Cliente. El tratamiento posterior de faltantes o de un `V_e^{vig}` remanente no se ratifica mediante C2 y exige RD posterior si excede F04. **T1-C2 no autoriza «cierre con diferencia abierta sin resolución».**

**C2-R05 — Regla monetaria de conservación.** Para cada Entrega `e`, `0 <= A_e <= V_e^0` y, sin D7-B, `V_e^{vig}=V_e^0-A_e`; el mismo COMMIT que confirma la aplicación reduce exactamente el tránsito vinculado y registra una sola vez Cobro/PAGO/Caja del importe recibido y atribuido. La porción `P_e^{exp}` y `F_e^{FIFO}` ya acreditada en IMP-B **no** genera un segundo Pago al rendir. Diferencias `Q` tipadas no se suman como dos pérdidas/ingresos.

**C2-R06 — Idempotencia por cierre y por Cobro.** La clave UUID de C1-a y su huella semántica versionada gobiernan **un único resultado de cierre** por recorrido. Cada Cobro de K2 tendrá identidad idempotente única, trazable a ese cierre/Cliente, compatible con el UNIQUE actual de `COBRO.claveIdempotenciaOrigen`; **no reutilizar una misma UUID en dos Cobros**. Replay con misma clave y misma huella retorna recibo histórico sin efectos, aunque cambie posteriormente el estado de recursos por acciones permitidas; misma clave/payload diferente -> 409; clave nueva sobre recorrido cerrado -> `RECORRIDO_YA_CERRADO`, sin exponer el recibo previo. Autorización/ámbito se revalidan también en replay.

**C2-R07 — Evidencia y recibo.** Exigir como mínimo Repartidor, identidad del recorrido, momento, importe esperado, recibido, diferencia, ADMIN responsable y observación ante discrepancias (RD-F04-002), más aplicaciones por Cliente/Entrega y rastro de cobros. La custodia física no imputable queda separada del Cobro/Caja de venta y conserva procedencia y tratamiento sin doble ingreso. Arqueo en tres vistas, nunca suma ingenua `UC-23 + custodia` como billetes contados.

**C2-R08 — T2 no autorizado para el primer online.** No adoptar `T2-C2` con COMMIT financiero por aplicación para este incremento: deja potenciales Cobros definitivos antes del cierre, complica C1-a y D7-A, y necesita protocolo específico de recuperación. Una futura variante de staging de propuestas/evidencia sin Cobro/Cuenta/Caja previo no sustituye T1 en el efecto financiero y requeriría diseño/aprobación propia. Esta decisión **no rechaza T2 para siempre**.

**C2-R09 — Puerta técnica.** Esta selección conceptual **no aprueba** mecanismo de locks, namespace advisory, generación UUID/ID/secuencias, aislamiento SQL, nombres de tablas/columnas, FKs, constraints, funciones, endpoints, tamaño de lote, triggers, DDL ni Flyway V4. G-ARQ Nivel 2 debe derivar una propuesta verificable con grafo global, preflight por base destino y pruebas C3, regresión/seguridad y compatibilidad con `CobroManualService`/PR app #91. Si las pruebas contradicen T1/K2, elevar nueva evaluación, **no sustituirlo silenciosamente**.

**C2-R10 — Sin autorización de implementación.** No fusionar PRs, no tocar V1–V3, G0, source-lock, RBAC original, BC-07 original, `src/**`, Demo, bases persistentes, infraestructura ni despliegue. La selección solo podrá incorporarse a contratos y ADR posteriores mediante autorizaciones editoriales específicas; G-FIS, G-DEV, G-VAL, CR-F04 y despliegue requieren **puertas independientes**. `PE-3` offline y `D7-B` siguen diferidas.

## 4. Ejemplo de aceptación económica (NO PRUEBA EJECUTADA)

**Escenario ilustrativo PR #69**: Recorrido R con Entregas A1, A2, B1; `V^0` agregado ARS **180,00**. Efectivo físicamente recibido **180,00**: se atribuyen ARS **110,00** al Cliente A y ARS **60,00** al Cliente B, con **ARS 10,00** de custodia no imputada a ventas. Queda `V^{vig}` de **ARS 10,00** en A2. Si se confirma lícitamente el cierre **tras la resolución motivada requerida de la discrepancia**, K2 propone dos Cobros REPARTO, A=ARS 110,00 y B=ARS 60,00, con aplicaciones A1=70,00, A2=40,00 y B1=60,00.

| Verificación económica | Cálculo esperado |
|---|---|
| Conservación tránsito | `sum(A_e)+sum(V_e^{vig}) = 170,00+10,00 = 180,00 = sum(V_e^0)` |
| Cobros ventas por Cliente | `110,00 + 60,00 = 170,00` |
| Efectivo físico atribuido + custodia | `170,00 + 10,00 = 180,00` (sin doble reconocimiento) |
| Cobro del faltante de A2 | **0,00** (no recibido); no restaurar deuda automáticamente |
| Estado del recorrido antes de resolver diferencia | **PENDIENTE DE CONCILIACIÓN**, no «cerrado» |
| Respuesta ante falla antes de COMMIT T1 | Todo efecto de cierre del intento revierte; sin Cobros ni recibo definitivo |
| Respuesta ante ACK perdido después de COMMIT | Mismo recibo histórico y los mismos dos Cobros, sin crear otros |

**No equiparar:** ARS 10,00 de custodia y ARS 10,00 de `V_e^{vig}` pendiente representan causas distintas. Las categorías `Q_e^{decl}`, `Q_e^{rend}`, `Q_e^{falt}` y `Q^{exc}` tampoco son magnitudes aditivas sin atribución.

## 5. Pruebas de salida propuestas (futuras; ninguna ejecutada)

- **C2-S01**: cierre limpio con 2 Clientes/3 Entregas K2 y conservación por Cliente; escenario con discrepancia exige resolución motivada previa a cerrar.
- **C2-S02**: falta A2=10,00, recepción parcial legítima, RD-F04-005; no Cobro faltante ni restitución de deuda exigible automática.
- **C2-S03**: cero importe atribuible, `V_e^0=0`, custodia sola y cobertura insuficiente; no Cobro de cero, no cierre automático, diagnóstico separado B1.
- **C2-S04**: falla entre aplicaciones bajo T1; no Cobro/Cuenta/Caja/recibo parcial durable.
- **C2-S05**: COMMIT confirmado + ACK perdido; replay histórico sin duplicación; misma clave/payload distinto 409, UUID nuevo sobre cerrado RECORRIDO_YA_CERRADO.
- **C2-S06**: cierre con Cobros de dos Clientes; claves por Cobro únicas pese al UUID único de cierre, vínculo exacto y sumas verificables, sin colisiones de UNIQUE.
- **C2-S07**: dos ADMIN simultáneos, revalidación después de espera y sin fuga BC-07 ni acceso UC-14 a ADMIN.
- **C2-S08**: matriz C3 de UC-05/UC-29/UC-03/UC-07/UC-15/UC-19/UC-28/UC-43/función anulación/triggers, incluidos C3-08 y pares de inversión COBRO→CLIENTE; sin doble aplicación ni deadlock no recuperado.
- **C2-S09**: T1 recorrido grande y dos Clientes invertidos; medir bloqueo/latencia, límites y reintentos.
- **C2-S10**: arqueo efectivo/otros medios y custodia separada; no simular que `MOVIMIENTO_CAJA` de venta es ingreso nuevo de custodia.

**Cada test futuro exige** SHA de app y gobierno, datos sintéticos, versión de PostgreSQL, sesiones e intercalados, estado antes/después, SQLSTATE, recibos y regresión JUnit/Testcontainers. C3 anterior y SonarCloud documental NO certifican estos tests.

## 6. Voto reservado al responsable y condiciones de publicación

**Registro de decisión posterior a la redacción inicial:**

- [x] **APROBAR CON SALVEDADES** `T1-C2 + K2`, comprendiendo la propuesta C2-R01..C2-R10 y las **diez salvedades S01..S10**, sin autorizar trabajo físico.
- [ ] **DEVOLVER PARA AJUSTES**.
- [ ] **RECHAZAR T1/K2**.
- [ ] **DIFERIR**.

**Declaración textual del responsable:** «Apruebo T1 + K2 con las diez salvedades. Con que seguimos ahora?» (se transcribe sin formato Markdown).  
**Fecha/hora del mensaje fuente:** `2026-11-19T02:49:39Z` (Argentina: 18/11/2026 23:49:39, UTC−03:00).  
**Canal y autoridad:** conversación del responsable con ChatGPT; ratificación declarativa, no firma digital ni revisión aprobatoria en GitHub.  
**Observación:** esta declaración resuelve **ART-GCON-C2** conceptualmente y mantiene todas las reservas **S01–S10**. No declara resuelto G-ARQ Nivel 1 ni pruebas C3/RT-UC07-04.
**Incorporación editorial:** pendiente de preflight, revisión y autorización específica de ejecución de merge. **No hay autorización de merge en esta declaración.**

**Efectos de la aprobación expresa ya recibida:** este archivo registra la opción T1-C2 + K2 con S01–S10, debe enlazarse a la constancia del mensaje fuente y conciliarse con la matriz R08.6 en un corte documental independiente. El siguiente trabajo autorizado es **análisis/diseño conceptual G-ARQ Nivel 2** dentro de Puerta 1; la aprobación conceptual **no equivale** a autorización editorial de merge ni a ejecutar experimentos físicos, migraciones, app o deployment.

**Puertas bloqueadas hasta actos distintos:** PR #69 y este borrador DRAFT; PR #65 GC-10, #66, #67, #68; UC-07 CR-C #47/CR-F #48; RT-UC07-04/C3; CR-B0-F04-001; G-FIS/V4; G-DEV/R09; G-VAL; B9. La aprobación documental previa de #66/#67 no constituye ejecución de merge ni habilitación de estos gates.

## 7. Fuentes exactas y comprobación

- RD-F04-002: `docs/01-gobierno/RD_F04_002_RENDICION_EFECTIVO_2026-10-26.md`, main.
- RD-F04-005: `docs/01-gobierno/RD_F04_005_DIFERENCIA_PAGO_EN_TRANSITO_2026-10-26.md`, main.
- RD-F04-003: `docs/01-gobierno/RD_F04_003_PAGO_EN_TRANSITO_SALDO_PROVISIONAL_2026-10-26.md`, main.
- ACT-G-COM-001: `docs/01-gobierno/ACTA_G_COM_001_RATIFICADA_CON_SALVEDADES_2026-11-16.md`, main.
- PR #66: `docs/01-gobierno/resoluciones/ACT_GCON_R08_6_RESOLUCION_PARCIAL_2026-11-17.md` y `ANEXO_CHAT_FIRMA_GCON_R08_6_2026-11-17.md`, HEAD e923332096c40620fa4f88f34e76a5d0c2e9213f.
- PR #69: `docs/01-gobierno/g-con/EXPEDIENTE_ART_GCON_C2_T1_VS_T2_2026-11-18.md`, HEAD 012b961396646691dda6a3d6092ecde9d68af09d.
- PR #68: `docs/01-gobierno/g-con/R086_PUERTA1_CONCILIACION_UC05_UC07_UC29_2026-11-18.md`, HEAD c7e1b14d0925022158920de7dc26124aa5f1707f.
- App: `src/main/java/ar/edu/unam/alemilanesas/finanzas/CobroManualService.java`; `src/main/resources/db/migration/V1__baseline_mr5.sql` @ f5c9af3f76723d5364d44647cfd43ea13a9fd7b5.
- Roadmap operativo `ROADMAP_OPERATIVO_I3_I7_2026-11-15.md`; implementación futura R09-PRE (app PR #92), sin ejecución habilitada.
- Gobierno G-ARQ Nivel 1: **estado reportado, documento original/commit SHA no acreditados** en la fuente PR #66; esta propuesta no afirma cierre Nivel 1.

**Alcance de auditoría:** revisión estática de documentación, código fuente y esquema versionado. No hubo pruebas SQL, migraciones, seguridad, runtime, rendimiento ni acceso a Demo. El texto fue preparado como propuesta y **ratificado posteriormente por declaración expresa** en el alcance indicado; permanecen pendientes la revisión e incorporación editoriales, las validaciones técnicas y las puertas físicas.
