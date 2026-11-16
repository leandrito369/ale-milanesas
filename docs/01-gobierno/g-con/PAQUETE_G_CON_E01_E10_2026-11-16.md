# Paquete G-CON — Integración editorial E-01..E-10

**Proyecto:** Sistema de Gestión para Ale Milanesas  
**Corte:** 16/11/2026 (Argentina). **Estado:** **PR DRAFT PARA REVISIÓN EDITORIAL; NO APROBADA PARA MERGE**.  
**Autoridad funcional:** [ACT-G-COM-001 — ratificada con salvedades 16/11/2026](https://github.com/leandrito369/ale-milanesas/blob/main/docs/01-gobierno/ACTA_G_COM_001_RATIFICADA_CON_SALVEDADES_2026-11-16.md), incorporación inicial `0a414600a17ceba1d75548ad5e22263a63480a95`, en [PR #64](https://github.com/leandrito369/ale-milanesas/pull/64), **MERGED en `main`**, commit de merge [`9076570ff3329864fe85c990bcc6f4ff7a63d6e5`](https://github.com/leandrito369/ale-milanesas/commit/9076570ff3329864fe85c990bcc6f4ff7a63d6e5). El estado OPEN/DRAFT era correcto **al crear** esta rama, pero ya fue superado.  
**Nota de precedencia:** dependencia de **PR #64 CUMPLIDA** (acta integrada en `main` por merge `9076570ff3329864fe85c990bcc6f4ff7a63d6e5`). G-CON mantiene una rama independiente derivada de `main` previo a ese merge para aislar su diff; **su aprobación editorial y fusión siguen pendientes y NO se autorizan automáticamente**. Las adendas se proponen para revisión sin tocar fuentes G0 inmutables.

## 1. Inventario completo de enmiendas

| ID | Contrato/operación de origen según G0 | Archivo de adenda de este paquete | Decisión ratificada | Revisión obligatoria |
|---|---|---|---|---|
| **E-01** | REV04B §2, UC-05/Entrega | [REV04B E-01..03](ADENDA_REV04B_E01_E02_E03_2026-11-16.md) | RCG-04, D6-1, RD-F04-002 | Repartidor declara; **ADMIN** rinde; no otorgar UC-14 |
| **E-02** | REV04B §2 y §§5–6, UC-05/07 | [REV04B E-01..03](ADENDA_REV04B_E01_E02_E03_2026-11-16.md) | RCG-01/02/03, DC-01-C1, DC-02-A/DC-04-A | Cargo por real, adicional **por oferta**, reserva + FIFO + `V_e` atómicos, idempotencia y CR-C/CR-F |
| **E-03** | REV04B §3, UC-06/Cancelación | [REV04B E-01..03](ADENDA_REV04B_E01_E02_E03_2026-11-16.md) | RCG-01, DC05-05/06-A | Liberar reservas elegibles una vez; no duplicar saldo/Caja/reembolso |
| **E-04** | REV05 §2, UC-29/registrarCobro y rendición | [REV05 E-04..06](ADENDA_REV05_E04_E05_E06_2026-11-16.md) | RCG-01/03/04/06, D6-1 | `REPARTO` vs `ADMINISTRACION` vs `ONLINE`; evidencia, custodia, permisos |
| **E-05** | REV05 §3, UC-29/anularCobroManual | [REV05 E-04..06](ADENDA_REV05_E04_E05_E06_2026-11-16.md) | RCG-05, D7-A, DC05-07-A | Veto rendición; reserva/aplicación activa; contraasiento e idempotencia |
| **E-06** | REV05 §1, UC-14/Cuenta Corriente | [REV05 E-04..06](ADENDA_REV05_E04_E05_E06_2026-11-16.md) | RCG-03/04, RD-F04-003/005 | Saldo confirmado ≠ tránsito validado ≠ exigible provisional; **UC-14 solo VENDEDOR** |
| **E-07** | RD-I302-001 (PR #44), F04 y R08.4/08.5 | [RD-I302 E-07](ADENDA_RD_I302_E07_2026-11-16.md) | RCG-01..08, D12-C, DC05-09-A | Conciliar anteriores propuestas de PE-1 aislado; **PE1+PE2+IMP01 online integrados**, V3 sí existe |
| **E-08** | REV06B §§6–7, UC-15/16 | [REV06B E-08](ADENDA_REV06B_E08_2026-11-16.md) | RCG-03/07, DC05-04-B, DC-COM-FIFO-001, DC-04-A | Evaluación de mora confirmada, aplicación FIFO efectiva y **ajuste histórico** |
| **E-09** | REV04A §§2/4, UC-03/21 | [REV04A E-09](ADENDA_REV04A_E09_2026-11-16.md) | RCG-05/06/07, RD-F04-006/007 | No nuevo veto 409, fingerprint completo, `UC-21` reserva ONLINE recuperable |
| **E-10** | BC07 15 proyecciones y matriz RBAC G0 | [BC07 E-10](ADENDA_BC07_E10_2026-11-16.md) | RCG-04/08, DC05-03-A, RD-F04-002 | ADMIN solo proyección UC-29; REPARTIDOR solo UC-05 propio; UC-14 VENDEDOR |

**Cobertura:** 10/10 enmiendas **redactadas** y asociadas a fuente/operación/decisión. **No significa aprobadas editorialmente ni probadas en ejecución.**

## 2. Fuentes G0 que NO se editan en este lote

| Archivo canónico | Blob G0 verificado | Uso |
|---|---|---|
| `docs/08-diagramas/consolidacion-b0/CONTRATOS_REV04B_CORREGIDOS_B0_ACTUALIZADO.md` | `09b0cec33a7074adec33bc7510bc5c15aed87359` | UC-05, UC-06, UC-07 |
| `docs/08-diagramas/consolidacion-b0/CONTRATOS_REV05_CORREGIDOS_B0_ACTUALIZADO.md` | `fd6af871224f23b4a0a545de9155f07bfdbd991a` | UC-14 y UC-29 |
| `docs/08-diagramas/revision/REV06B_CLIENTES_RECETAS_INVENTARIO/propuestos/CONTRATOS_REV06B_TRECE_CORREGIDOS.md` | `af5dae3e09562f925092a44784152ec552d855b2` | Fuente **preferente G0** UC-15/16 según manifiesto (aunque la ruta diga `propuestos`) |
| `docs/08-diagramas/consolidacion-b0/CONTRATOS_REV04A_CORREGIDOS_B0_ACTUALIZADO.md` | `7eb98db65eb3d31fa4f18a386e570854ef2b6340` | UC-03 y UC-21 |
| `docs/01-gobierno/b0/BC07_PROYECCIONES_MINIMAS_RATIFICADAS_2026-10-29.csv` | `f123e8fb7884d685854ea9bb19a718cfc8a02f5c` | 15 proyecciones históricas sin modificar |
| `docs/01-gobierno/b0/B0_MATRIZ_RBAC_67_OPERACIONES_CIERRE_2026-10-29.csv` | `eb4f882fd75e4f48ae32a8ce674c2327b53e1bf4` | 67×8 RBAC sin concesión indirecta |
| `docs/01-gobierno/b0/G0_MANIFIESTO_CANONICO_67_OPERACIONES_2026-10-29.csv` | `7cad937c5a9d8678dda7355029532a7348469766` | 64 CU/67 operaciones, fuente preferente por operación |
| `docs/01-gobierno/b0/RD_I302_001_PROPUESTA_ENTREGA_EFECTIVO_TRANSITO_IDEMPOTENCIA_2026-11-09.md` | `a181abaeb4225a4c20fc9f63b0aaf7fe8ff86fcf` | **Solo PR #44 draft**, no está integrada en main; E-07 es concordancia, no edición de dicha PR |

**Source-lock:** `source_commit=1263ffc17bd0eb7f3c69faaa9ff5ae556cf9de7e`; `governance_commit=27738b089afdd2698cdae915f75c0e8089a6248a`. No cambiar por `main` ni editar G0 retrospectivamente.

## 3. Dudas documentales resueltas sin reabrir negocio

1. **UC-07:** método por oferta/versión y diferencia temporal de recotización vs menor Entrega real expresamente ratificados por RCG-02; diseño físico y CR-C/CR-F aún necesitan autorización, no falsear línea `DETALLE_PEDIDO`.
2. **RCG-01 vs FIFO:** primero reservar/aplicar por antigüedad y reglas aprobadas, después FIFO solo sobre crédito verdaderamente libre; una misma porción no puede estar asignada a dos obligaciones ni generar Pago/Caja dos veces.
3. **UC-15 vs UC-03:** RD-F04-006 requiere **calcular saldo exigible provisional**, **no** introduce automáticamente veto al Pedido por deuda ni 409; provisional no recategoriza al Cliente (RD-F04-007).
4. **UC-29 rendición:** ADMIN exclusivo aunque VENDEDOR pueda registrar Cobro general. `REPARTO` es origen de Cobro rendido; no confundirse con actor REPARTIDOR.
5. **Cobro ONLINE:** Mercado Pago confirmado y Pedido ONLINE deben conducir a reserva IMP-B **explícita y recuperable**, sin simular ACID distribuido con proveedor.
6. **Cargos y centavos:** UC-16 aplica política actual al **crear Pedido**; UC-05 usa histórico y cantidad real; adicional UC-07 por oferta separada. No reaplicar ajuste ni agrupar ofertas por centavos.
7. **Referencias:** los textos previos de R08.5/PRs drafts son contexto histórico del corte, no autorizaciones SQL. La ratificación G-COM fija la decisión comercial, la PR G-CON propone la propagación editorial.

## 4. Lista de revisión editorial y evidencias

| Control | Requisito para aprobar **esta PR** | Estado actual |
|---|---|---|
| **GC-01** | Ratificación de ACT-G-COM-001 en fuente accesible desde main o formalmente integrada antes de merge G-CON | **CUMPLIDA: PR #64 MERGED** (commit `9076570ff3329864fe85c990bcc6f4ff7a63d6e5`); falta autorización editorial autónoma de PR #65 |
| **GC-02** | Verificar fuente preferente de cada operación en manifiesto G0 | **VERIFICADA estáticamente** |
| **GC-03** | E-01..E-10 completos, con actor, pre/post, excepciones y limitación de implementación | **REDACCIÓN E01..10 REVISADA (GC-03, §7); autorización editorial pendiente** |
| **GC-04** | Contrastar los adendos con CR-C/CR-F, RT-UC07-04, notas REV05/F01 y RD-F04-002/005/006/007 | **CONTRASTADA (§7): incompatibilidad física CR-F §15.12 abierta y señalizada en E-02; no autoriza CR-F** |
| **GC-05** | No cambiar G0, RBAC, BC07 original, diagramas ni contratos en main | **VERIFICADA ESTÁTICAMENTE (§7): diff exclusivo de 7 archivos nuevos Markdown G-CON** |
| **GC-06** | No inventar nueva operación CU-65, permisos de UC-14, umbral de deuda ni política de contraaplicación D7-B | **VERIFICADA ESTÁTICAMENTE (§7): firmas/roles G0, sin CU-65 ni nuevas autorizaciones** |
| **GC-07** | No aprobar CR/DDL/V4, desarrollo, CI no ejecutado ni levantar Issue #28 | **Restricción explícita** |
| **GC-08** | Diseñar tests SEM/CON/FIN, E2E, caso centavos, 409 y negatividad RBAC en etapa posterior | **NO EJECUTADOS** |
| **GC-09** | Revisar cambios en SHA de HEAD de #64/#47/#48/#44 y cualquier nueva RD antes de firma editorial | **Pendiente al gate de merge** |
| **GC-10** | Aprobar adendas versionadas como un solo paquete, con resolución editorial explícita | **PENDIENTE autorización editorial del responsable; PR DRAFT, sin merge** |

**Puertas:** G-COM **cerrada funcionalmente e integrada en `main`** por PR #64; G-CON **preparada para revisión**; G-ARQ permite solo analizar/diseñar; G-FIS, G-DEV y despliegue permanecen bloqueados. `PE-3` offline y contraaplicaciones D7-B diferidas. Issue app #28 abierta.

## 5. Estrategia de integración segura

1. **PR #64 ya revisada e integrada**: merge commit [`9076570ff3329864fe85c990bcc6f4ff7a63d6e5`](https://github.com/leandrito369/ale-milanesas/commit/9076570ff3329864fe85c990bcc6f4ff7a63d6e5). Verificar que su acta sigue idéntica en lo sustancial y que el historial G0 permanece intacto.
2. Revisar **una única PR G-CON** con este índice y **seis adendas**; aprobar editorialmente la propagación por fuente/operación y actualizar, si corresponde, un índice canónico de adendas con un cambio trazable. No reescribir archivos originales G0 ni sus blob SHAs.
3. Después de G-CON, llevar las obligaciones técnicas a G-ARQ, presentar CR física online integral `PE-1+PE-2+IMP-01`, autorizar o no `V4` separadamente y ejecutar tests reales antes de desarrollo/despliegue.
4. **Nunca** presumir que un merge documental habilita app, migraciones, permisos, E2E o producción.

**No se ejecutaron pruebas Java/PostgreSQL/CI/E2E en esta creación documental.** Toda evidencia técnica futura tendrá resultado, fecha, SHA y entorno específico.


---

## 6. Cotejo contra ACT-G-COM-001 ya integrada en main

**Fuente comprobada:** [ACT-G-COM-001 en main](https://github.com/leandrito369/ale-milanesas/blob/main/docs/01-gobierno/ACTA_G_COM_001_RATIFICADA_CON_SALVEDADES_2026-11-16.md) de PR [#64](https://github.com/leandrito369/ale-milanesas/pull/64), merge `9076570ff3329864fe85c990bcc6f4ff7a63d6e5`. Se contrastó la **sustancia** de cada salvedad ratificada con las seis adendas; esto **no** es un dictamen de compatibilidad del DDL/servicio ni reemplaza la revisión editorial de la #65.

| Acta | Cláusulas ratificadas a preservar | Adendas que las propagan | Dictamen de cotejo |
|---|---|---|---|
| RCG-01 | Reserva elegible más antigua, liberación atómica, rechazo de reembolso no bloquea por sí solo y FIFO solo libre | E-02, E-03, E-04, E-08 | **Cubierto documentalmente**; transacciones/locks y filtros SQL pendientes |
| RCG-02 | Por oferta+versión; dos ofertas 15,05⇒27,08; antes/después de aceptación; sin línea original ficticia | E-02, E-08, E-07 | **Cubierto documentalmente**; CR-C/CR-F, trigger y FKs por validar |
| RCG-03 | `P_e^{exp}`+`F_e^{FIFO}` disjuntos, IMP-B vinculante, `V_e^0=min(D_e,E_e)`, `IMP-C`, diferencias no aditivas | E-02, E-04, E-06, E-08 | **Cubierto documentalmente**; pruebas financieras y datos heredados pendientes |
| RCG-04 | Rendición ADMIN, `COBRO.origen='REPARTO'`, custodia y arqueo en tres vistas, campos BC07 mínimos | E-01, E-04, E-06, E-10 | **Cubierto documentalmente**; modelo físico de custodia/visibilidad aún no autorizado |
| RCG-05 | Huella completa, replay del recibo histórico tras ANULADO, anulación idempotente y no duplicación | E-02, E-05, E-09 | **Cubierto documentalmente**; la implementación actual de UC-03/anulación no se considera conforme |
| RCG-06 | `COBRO.idPedido` no prueba imputación; preflight por cinco señales no exhaustivas y reserva ONLINE explícita | E-04, E-07, E-09 | **Cubierto documentalmente**; reconcile/contención de legados y webhook sin ACID pendiente |
| RCG-07 | UC-03 evalúa saldo exigible provisional, categoría sin variación por tránsito, sin veto nuevo/409; D7-B y PE-3 diferidos | E-06, E-07, E-08, E-09 | **Cubierto documentalmente**; ejecutar RD-F04-006 antes de activar tránsito |
| RCG-08 | Lote único E-01..10, preservar G0/RBAC/BC07/SHAs; no merge/DDL/V4/DEV automático | Índice G-CON, E-01..E-10, E-10 | **Cubierto documentalmente**, sujeto a autorización editorial específica |

**Resultado:** **8/8 cláusulas cubiertas en el diseño editorial, 10/10 enmiendas redactadas, 0 servicios certificados y 0 migraciones autorizadas**. No se detectó contradicción comercial bloqueante respecto al **texto de ACT-G-COM-001**. Persisten como **obstáculos para aprobar ejecución o integrar contratos de forma definitiva**: cotejo CR-C/CR-F, confirmación de todas las garantías de identidad/costo de UC-07, compatibilidad de firmas API, alcance BC07, concurrencia global C3 y pruebas negativas RBAC. El análisis no autoriza usar el mecanismo técnico de propuesta como implementación validada.

**Estado G-CON:** listo para **revisión editorial** en PR #65, **DRAFT / SIN MERGE**. El merge de PR #64 satisface GC-01, **no** implica aprobar automáticamente GC-03..10 ni G-FIS/G-DEV.

---

## 7. Auditoría de cierre editorial GC-03..GC-10 — 16/11/2026

**Objeto:** control previo a pedir autorización de merge de [PR #65](https://github.com/leandrito369/ale-milanesas/pull/65), cotejando las **siete piezas de esta PR** con [ACT-G-COM-001 ya integrada en main](https://github.com/leandrito369/ale-milanesas/blob/main/docs/01-gobierno/ACTA_G_COM_001_RATIFICADA_CON_SALVEDADES_2026-11-16.md), G0 y las CR auxiliares de UC-07 **en sus HEAD reales de GitHub**.  
**Regla de competencia:** el merge documental de G-CON, si se autoriza posteriormente, **NO** autorizará por implicación CR-C/CR-F, D/E/F/G/H, SQL, firma HTTP, RBAC adicional, G-FIS/G-DEV, CI/E2E ni despliegue.  
**Nivel de evidencia:** revisión **estática de contenido, rutas, roles y diff**; no se ejecutó software, base de datos ni pruebas humanas. Los estados `GC` de esta sección **sustituyen a la fotografía provisional de §4**, que fue redactada antes del cotejo exhaustivo.

### 7.1 Dictamen por puerta

| Control | Resultado al cierre de este cotejo | Fundamento verificable | Acción de liberación |
|---|---|---|---|
| **GC-03 — Adendas contractuales completas** | **CONFORME EDITORIAL CON RESERVAS** | E-01..E-10 están redactadas, cada una con operación, autoridad, invariantes, excepciones/guardas y casos de aceptación; remiten a firmas G0. Las nuevas firmas de anulación y auxiliares no se presentan como API implementada ni homologada. | Comprobación final editorial de semántica, entradas/salidas y actor; **no** editar firmas G0 por inferencia. |
| **GC-04 — CR-C/CR-F/RT/RD y conflictos** | **CONTRASTADO, CONFLICTO CRÍTICO FÍSICO ABIERTO** | [CR-C #47](https://github.com/leandrito369/ale-milanesas/pull/47) y [CR-F #48](https://github.com/leandrito369/ale-milanesas/pull/48): **OPEN/DRAFT/NO AUTORIZADAS**. A–C parcialmente ratificadas; D/E por ratificar, F/G solo especificadas para revisión y H/RT-UC07-04 abiertas. **CR-F §15.12 admite línea técnica con `cantidadOriginal=0`; ACT-G-COM-001 RCG-02 §2.3 exige resolver sin depender de ella.** E-02 ahora señala expresamente el conflicto y prohíbe presentar ese DDL candidato como compatible. RD-F04-002/005/006/007 se preservan. | Para **merge editorial**, dejar constancia explícita de incompatibilidad y de gate UC-07 (cumplido en E-02 y aquí); para **CR-F/G-FIS**, resolver físicamente la contradicción y aprobar A–H/RT de forma independiente. **No declarar UC-07 ejecutable.** |
| **GC-05 — Integridad de G0 y diff** | **CONFORME A REVISIÓN ESTÁTICA** | El diff de #65 afecta exclusivamente **7 Markdown nuevos en `docs/01-gobierno/g-con/`**; no modifica G0, CSV RBAC/BC07, código, migraciones ni source-lock. | Reconfirmar que no se sumaron archivos ajenos al abrir gate de merge. |
| **GC-06 — No crear permisos/operaciones/reglas** | **CONFORME** | Manifiesto G0: 64 CU/67 operaciones. No se agrega UC-65, no se concede UC-14 a ADMIN/REPARTIDOR, no se habilita PE-3 ni contraaplicación D7-B, no se introduce veto comercial por deuda/409. E-10 es proyección contextual, no nueva operación G0. | Pruebas RBAC negativas en G-DEV; toda nueva API/firma exige adenda expresa antes de implementación. |
| **GC-07 — No anticipar G-FIS/G-DEV/despliegue** | **CONFORME DOCUMENTAL** | No hay DDL, V4, SQL ejecutado, flags alterados ni cambios en repo app. [Issue app #28](https://github.com/leandrito369/ale-milanesas-app/issues/28) **OPEN** al cotejo. | Mantener gates cerrados; futuras autorizaciones específicas y comprobaciones. |
| **GC-08 — Pruebas de aceptación** | **PLANIFICADAS; NO EJECUTADAS** | Escenarios SEM, CON, FIN, UC-07 por oferta, reserva múltiple, idempotencia, F8, preflight, C3 y RBAC negativo citados en adendas/acta. No hay informe de ejecución de la vertical que convalide reglas. | La ausencia de ejecución **no bloquea redactar/fusionar un contrato**, pero **sí** cualquier certificación técnica/funcional del circuito. Exigir pruebas con SHA, entorno, fixtures y resultados antes de G-VAL. |
| **GC-09 — Frescura y conflictos de fuente** | **VERIFICADO AL CORTE, RECONTROL OBLIGATORIO EN MERGE** | HEAD [#47](https://github.com/leandrito369/ale-milanesas/pull/47) `9c0a54e4a2147f5f048f7827f26a21b1bfeecf1b`; HEAD [#48](https://github.com/leandrito369/ale-milanesas/pull/48) `fda51c929258dc42e71c40c95bbcd89d0324c306`; HEAD [#44](https://github.com/leandrito369/ale-milanesas/pull/44) `e5e82f843f8a579e3201a332c645f62680d56832`; acta #64 integrada por `9076570ff3329864fe85c990bcc6f4ff7a63d6e5`. La rama #65 fue creada **antes** de #64, por eso la comparación con `main` reportó **ahead 18 / behind 33** pese a **mergeable=true**; no se atribuye un conflicto Git inexistente. | Antes de aprobar/fusionar: verificar HEAD/base frescos, diff limitado, CR-F/CR-C si cambiaron, revisiones y checks realmente existentes. **Sin rebase/amend/force-push.** |
| **GC-10 — Aprobación editorial/merge** | **PENDIENTE DE AUTORIZACIÓN EXPRESA DEL RESPONSABLE** | `G-COM` sí está ratificada e integrada; RCG-08 permitió **preparar** G-CON, no fusionarla automáticamente. PR #65 sigue **OPEN/DRAFT/NO MERGEADA**, sin revisión editorial aprobatoria. | Emitir dictamen del responsable de **aprobar G-CON para integración con reservas explícitas** (sin aprobar CR-F física), o devolver por conflicto. Solo después verificar HEAD/checks y ejecutar merge autorizado. |

**Interpretación:** `GC-04` queda **satisfecha como auditoría y señalización de dependencia**, pero **la discrepancia física no se considera cerrada**. No confundir aptitud de publicación de adendas **condicionada a autorización editorial** con aptitud para autorizar CR-F, SQL o implementación UC-07.

### 7.2 CR-C y CR-F: decisiones parciales vs autorización integral

| Bloque A–H | Estado corroborado en CR-C #47 / CR-F #48 (HEAD anterior) | Implicación para E-02 y G-CON |
|---|---|---|
| **A** | **RATIFICADA**: Parte A crea Oferta + cotización inicial V1 **en una transacción**; O1 nuevas versiones ≥2 **solo** cantidades parciales estrictas; consulta/replay separados | E-02 lo preserva ahora explícitamente; no producir O1 nueva para cantidad total ni dar por aprobada una ruta de consulta |
| **B** | **RATIFICADA**: UUID servidor cotización/evidencia/comando; evento BIGINT identidad; pertenencia compuesta | E-02 no redefine identificadores ni FK; mantener política dentro de CR hasta autorización |
| **C** | **RATIFICADA**: numeroIntentoEvidencia positivo, secuencial por oferta, sin consumir en prevalidación/replay | No modificar versiones comerciales al contar evidencia |
| **D** | **ESPECIFICADA, NO RATIFICADA**: idempotencia y huella específica UC07 | La idempotencia comercial G-COM no aprueba automáticamente la serialización/canonización UC07-IDEM/1 de CR-C/F |
| **E** | **ESPECIFICADA, NO RATIFICADA**: P2b archivo/decodificación/umbrales experimentales | No presentar límites 1 MiB / 2 MiB / 4096² como configuración final |
| **F** | **ESPECIFICADA, NO RATIFICADA; F8 BLOQUEANTE**: SQL de eventos/guardas, P2b/transferencia/entrega y frontera de confianza gateway | CR-F §13.6 reconoce que PostgreSQL no autentica Bearer y que el pool confiable no está aislado aún; no certificar rol SQL por FK de usuario ni usar DDL candidato |
| **G** | **ESPECIFICADA, NO RATIFICADA**: preflight de históricos y migración uniforme candidata | No asumir BD vacía, no inventar precio histórico ni elegir ruta automática |
| **H** | **ABIERTA, NO RATIFICADA**: RT-UC07-04, orden global y test real de intercalados | No declarar fin del riesgo concurrencia por el cierre de un subcaso UC-03/UC-19 |

**Incompatibilidad UC-07 específica:** en CR-F [§15.12](https://github.com/leandrito369/ale-milanesas/blob/fda51c929258dc42e71c40c95bbcd89d0324c306/docs/01-gobierno/b0/CR_B0_UC07_002_EVIDENCIA_ACEPTACION_OFERTA_2026-11-11.md), `fn_uc07_padre_guard` permite el `INSERT DETALLE_PEDIDO` de `cantidadOriginal=0` si el contexto es `PARTE_B`. El acta G-COM `RCG-02` exige **no depender de esa inserción** y prohíbe líneas originales ficticias. La solución técnica se decide en **CR-F/arquitectura**, demostrando integridad de `DETALLE_ENTREGA→DETALLE_PEDIDO`, unicidad de producto por Pedido, Producto históricamente inactivo y multiplicidad de ofertas. **Esta G-CON no cambia la regla comercial ni aprueba un sustituto físico.**

### 7.3 Matriz de firmas canónicas y pertenencia RBAC — invariancia G0

Las firmas siguientes proceden de los contratos **preferentes en el manifiesto G0**, no de sugerencias de backend. El paquete G-CON **no cambia sus parámetros ni el conteo de operaciones**; una modificación futura de firma/DTO/HTTP requiere autorización contractual específica.

| UC / operación G0 | Firma preservada (abreviada, tipos clave) | Autorización RBAC G0 / efecto de la adenda |
|---|---|---|
| **UC-03** `cargarPedido` | `(idCliente:Long, fechaReparto:LocalDate, items:List<ItemPedidoDTO>, direccionEntrega:DireccionDTO, claveIdempotencia:UUID)` | **VENDEDOR D**. E-09 exige fingerprint semántico completo, sin agregar parámetro aquí |
| **UC-05** `registrarEntrega` | `(idPedido:Long, detallesEntrega:List<ItemEntregaDTO>, efectivoDeclaradoRecibido:BigDecimal[0..1], claveIdempotencia:UUID)` | **REPARTIDOR D**, solo asignación vigente; G-CON no agrega firma de rendición |
| **UC-06** `cancelarPedido` | `(idPedido:Long, motivoCancelacion:String)` | **VENDEDOR D, REPARTIDOR D**, por Pedido autorizado. E-03 precisa ambos, sin ADMIN directo |
| **UC-07** `registrarOfertaExcedente` | `(idExcedente:Long,idPedidoReceptor:Long,cantidadOfrecida:BigDecimal)` | **VENDEDOR D**; dos auxiliares CR-C son subordinadas y aún no autorizadas integralmente |
| **UC-07** `registrarRespuestaOfertaExcedente` | `(idOfertaExcedente:Long,aceptada:Boolean,cantidadAceptada:BigDecimal[0..1])` | **VENDEDOR D**; evidencia se resuelve por contexto, **no** nuevos parámetros G0 |
| **UC-14** `consultarCuentaCorriente` | `(idCliente:Long,fechaDesde:LocalDate[0..1],fechaHasta:LocalDate[0..1])` | **VENDEDOR D exclusivo**, ADMIN **X**; E-06/E-10 preservan este límite |
| **UC-15** `evaluarYActualizarCategoriaComercial` | `(idCliente:Long)` | **AUTOMATISMO I**; E-08 no crea endpoint humano directo |
| **UC-16** `aplicarAjusteComercialSegunCategoria` | `(idCliente:Long,subtotalBaseLuegoPromocion:BigDecimal)` | **AUTOMATISMO I**, invoca UC-15; no invocar política actual para recalcular Entrega histórica |
| **UC-21** `realizarPedidoOnline` | `(idDesafioVerificado:UUID,items:List<ItemPedidoDTO>,direccionEntrega:DireccionDTO,fechaReparto:LocalDate)` | **CLIENTE_ONLINE D**; reserva IMP-B externa recuperable sin modificar esta firma automáticamente |
| **UC-29** `registrarCobro` | `(idCliente:Long,idPedido:Long[0..1],importe:BigDecimal,medioPago:String,origen:String,referenciaExterna:String[0..1])` | **ADMIN D / VENDEDOR D**, rendición exclusivamente ADMIN como **subflujo**, no nueva operación G0 |
| **UC-29** `anularCobroManual` | `(idCobro:Long,motivoAnulacion:String)` | **ADMIN D exclusivo**; la nueva `claveIdempotenciaAnulacion` y salidas de contraasientos son **candidaturas de adenda de firma**, no parte de esta firma congelada |

**Notas de interfaz y comportamiento no aprobados como firma:** el `[0..1]` de `efectivoDeclaradoRecibido` en UC-05 sigue siendo **opcional en G0**; el adaptador debe distinguir ausencia de declaración de importe declarado cero antes de fijar su semántica externa. Los auxiliares CR-C `emitirCotizacionOfertaExcedente(idOfertaExcedente, cantidadCotizada)` y `registrarEvidenciaAceptacionOferta(idCotizacion, ...)` todavía son **propuestas subordinadas** que no cuentan como operaciones 68/69 del manifiesto.

### 7.4 Proyecciones BC07 y separación real de permisos

- **Fuente base ratificada:** `BC07_PROYECCIONES_MINIMAS_RATIFICADAS_2026-10-29.csv` tiene **15 proyecciones** de UC-33/34/35/36/37/40/64, **no** una fila original específica de UC-14 ni de subflujo UC-29. E-10 es **adenda posterior** para los contextos ya autorizados; no falsificar que el CSV G0 preveía esos campos.
- **ADMIN (rendición UC-29):** cabecera/recorrido y Entregas/Clientes necesarios para la atribución; `C_e,K_e,D_e,V_e^0,V_e^{vig},A_e` cuando correspondan y custodia/observación del propio circuito, con límites por objeto. **No UC-14**, no lectura genérica de Cuenta Corriente.
- **VENDEDOR (UC-14, Cobro general):** saldo confirmado, tránsito validado y saldo exigible provisional para Cliente autorizado; consulta por UC-14, Cobro general por UC-29. **No rendición administrativa**, ni anulación de Cobro, ni liberación excepcional de reserva.
- **REPARTIDOR (UC-05 / UC-34 contextual):** solo Pedido asignado vigente, datos operativos indispensables y declaración/acuse de su Entrega; **no deuda global de Cliente, Caja ni rendición UC-29**.
- **AUTOMATISMO (UC-15/16):** invocación interna, no concesión de nueva pantalla o ruta directa a otros actores. El origen `REPARTO` de Cobro **no** habilita al rol REPARTIDOR a crearlo.
- **Pruebas pendientes:** acceso negativo por rol, relación de Cliente/recorrido, campos excluidos, intento de usar identificadores ajenos y reintento tras revocación. La matriz E-10 es evidencia de **especificación**, no de verificación de endpoint.

### 7.5 Integración y disposición para dictamen del responsable

**Conclusión de auditoría:** **CONFORMIDAD DOCUMENTAL CON UNA SALVEDAD FÍSICA CRÍTICA ABIERTA**. No se encontró una concesión indebida de operación/rol ni edición de G0 en #65. El diseño físico candidato de CR-F **no es conforme todavía** a `RCG-02`; queda explícitamente fuera del alcance de autorización editorial. La rama #65 sigue **DRAFT**.

**No hay permiso de merge aún:** `GC-10` necesita la aprobación editorial independiente del responsable; antes del acto deben reconfirmarse diff, HEAD, estado real de revisiones y checks (`GC-09`). **La autorización editorial, si llegara, debe mencionar que no ratifica CR-C/CR-F, ni la línea técnica `cantidadOriginal=0`, y que mantiene cerradas G-FIS/G-DEV y el despliegue.**

**Pendiente técnico separado:** resolver CR-F §15.12/§13.6/F8 y RT-UC07-04 con evidencia PostgreSQL/Java/autorizaciones; documentar cambios de firmas adaptadoras y nueva proyección mediante G-ARQ/CR posterior; completar pruebas semánticas de dinero, cantidades, costo, concurrencia, RBAC y devolución de custodia antes de habilitar ejecución. **No crear nuevas decisiones comerciales por defecto.**
