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
| **GC-03** | E-01..E-10 completos, con actor, pre/post, excepciones y limitación de implementación | **ADENDAS REDACTADAS; revisión editorial pendiente** |
| **GC-04** | Contrastar los adendos con CR-C/CR-F, RT-UC07-04, notas REV05/F01 y RD-F04-002/005/006/007 | **REVISIÓN de conflicto pendiente** |
| **GC-05** | No cambiar G0, RBAC, BC07 original, diagramas ni contratos en main | **A verificar por diff de PR** |
| **GC-06** | No inventar nueva operación CU-65, permisos de UC-14, umbral de deuda ni política de contraaplicación D7-B | **Restricción explícita** |
| **GC-07** | No aprobar CR/DDL/V4, desarrollo, CI no ejecutado ni levantar Issue #28 | **Restricción explícita** |
| **GC-08** | Diseñar tests SEM/CON/FIN, E2E, caso centavos, 409 y negatividad RBAC en etapa posterior | **NO EJECUTADOS** |
| **GC-09** | Revisar cambios en SHA de HEAD de #64/#47/#48/#44 y cualquier nueva RD antes de firma editorial | **Pendiente al gate de merge** |
| **GC-10** | Aprobar adendas versionadas como un solo paquete, con resolución editorial explícita | **PR DRAFT, sin aprobar merge** |

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
