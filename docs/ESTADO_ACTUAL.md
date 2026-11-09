# Estado general vigente — corte técnico 08/11/2026 (Argentina)

**Carácter:** seguimiento informativo del [Plan Rector B0–B10](01-gobierno/PLAN_RECTOR_IMPLEMENTACION_2026-10-29.md); **no es acta de aceptación, autorización de despliegue ni nueva RD**. La sección «Histórico de estado» al final conserva los cortes anteriores como antecedentes. En caso de discrepancia, prevalecen G0, las RD ratificadas y los resultados verificables de los repositorios.

**Fuentes del corte:** `leandrito369/ale-milanesas` `main` en `1f6a4c7` y [`leandrito369/ale-milanesas-app`](https://github.com/leandrito369/ale-milanesas-app) `main` en `df9b2e2`. Estas referencias son un *snapshot*, no una afirmación de que las ramas sigan inmóviles.

## 1. Dictamen y línea base

- **B0/G0 APROBADOS documentalmente** por [RD-B0-G0-001](01-gobierno/b0/RD_B0_G0_001_CIERRE_LINEA_BASE_2026-10-29.md). `source_commit = 1263ffc17bd0eb7f3c69faaa9ff5ae556cf9de7e`, `governance_commit = 27738b089afdd2698cdae915f75c0e8089a6248a`; 64 CU y manifiesto de 67 operaciones. Las fuentes G0 no se reescriben.
- **I0:** base técnica B1/B2 y GitHub Actions implantadas. PostgreSQL/Flyway utiliza V1 (MR5), V2 (F01) y **V3 (MR-6, `PARTIDA_INSUMO` y `DETALLE_MOVIMIENTO_PARTIDA`)**, incorporada mediante [app PR #67](https://github.com/leandrito369/ale-milanesas-app/pull/67) (`ab648c0`), conforme [RD-MR-PARTIDAS-001](01-gobierno/b0/RD_MR_PARTIDAS_001_AMPLIACION_MR_PARTIDA_INSUMO_2026-11-06.md). El modelo de aplicación incorpora **62 tablas**. Validación en PostgreSQL descartable ≠ certificación del host/BD de aceptación o de producción.
- **I1:** **6/6 paquetes integrados y cerrados técnicamente**, no aceptados integralmente. [Acta técnica I1](https://github.com/leandrito369/ale-milanesas-app/blob/51f8ff5/docs/traceability/ACTA_CIERRE_TECNICO_I1_2026-11-10.md) fusionada en app PR #75 (`51f8ff5`).
- **I2:** **3/3 paquetes integrados y cerrados técnicamente**, no aceptados integralmente. [Acta técnica I2](https://github.com/leandrito369/ale-milanesas-app/blob/ebbc398/docs/traceability/ACTA_CIERRE_TECNICO_I2_2026-11-11.md) fusionada en app PR #79 (`ebbc398`).
- **I3:** **iniciada, sin cierre de incremento**. `I3-01a` UC-09 Consultar Stock (`GET /api/v1/stock`) se integró por [app PR #80](https://github.com/leandrito369/ale-milanesas-app/pull/80) (`aae5c3c`); `I3-01b` UC-10 Configurar Receta (`POST /api/v1/productos/{idProducto}/receta`, ADMIN y triple gate) por [app PR #81](https://github.com/leandrito369/ale-milanesas-app/pull/81) (`df9b2e2`). `I3-01c` UC-28 Preparación **pendiente**. [RD-I301-001](01-gobierno/b0/RD_I301_001_DECISIONES_I3_01_RECETAS_PREPARACION_2026-11-11.md) ratificó definiciones de receta, preparación y búsqueda contextual de Producción; **no equivale a implementar UC-28**.

| Incremento del backlog | Alcance y evidencia | Estado técnico del corte |
|---|---|---|
| I1-01 — Usuarios | UC-01/17/18/53/54/55/56; seguridad, sesiones, servicios y HTTP | **INTEGRADO**; E2E UC-54 pendientes |
| I1-02 — Clientes | UC-02/32/33/38 | **INTEGRADO** |
| I1-03 — Productos | UC-30/35/47/48 | **INTEGRADO** |
| I1-04 — Precios | UC-19/20, [PR #72](https://github.com/leandrito369/ale-milanesas-app/pull/72), merge `15f4b6c` | **INTEGRADO** |
| I1-05 — Categorías | UC-15/16 como servicios internos y UC-57 HTTP, [PR #73](https://github.com/leandrito369/ale-milanesas-app/pull/73), merge `12e30c5` | **INTEGRADO** |
| I1-06 — Insumos | UC-50/51/52 y consulta UC-36 preexistente, [PR #74](https://github.com/leandrito369/ale-milanesas-app/pull/74), merge `f4a89db` | **INTEGRADO** |
| I2-01/02/03 — Pedidos | UC-03/34/43, [PR #76](https://github.com/leandrito369/ale-milanesas-app/pull/76), [#78](https://github.com/leandrito369/ale-milanesas-app/pull/78), [#77](https://github.com/leandrito369/ale-milanesas-app/pull/77) | **INTEGRADO** con reservas documentadas |
| I3-01 — Recetas, preparación y stock | UC-09 y UC-10 integrados; UC-28 no implementado | **PARCIAL** |
| I3-02/03; I4–I7 | Entrega, Excedentes, Cobro/Caja, Compras, ONLINE, integraciones, offline y aceptación | **PENDIENTE** según alcance de cada iteración, con adelantos puntuales |

**Adelantos respecto del Plan Rector:** [app PR #68](https://github.com/leandrito369/ale-milanesas-app/pull/68) y [#69](https://github.com/leandrito369/ale-milanesas-app/pull/69) integraron UC-08 Insumo y REVENTA (prevista en I5), y [#70](https://github.com/leandrito369/ale-milanesas-app/pull/70) incorporó UC-42 Insumo (I4–I7). Son cortes motivados por la validación funcional de MR-6; no implican completar I5 ni todo UC-42. [RD-UC42-001](01-gobierno/b0/RD_UC42_001_DECISIONES_PENDIENTES_AJUSTE_INVENTARIO_2026-11-07.md) resolvió cuatro gaps; la idempotencia **RD-UC42-002** permanece pendiente.

## 2. Madurez de B0–B10 y límites de validación

| Bloque | Estado diferenciado |
|---|---|
| B0 | **APROBADO**: G0, 64 CU y decisiones canónicas; nuevas RD se registran por separado |
| B1/B2 | **IMPLEMENTADOS/PROBADOS EN CI**: arquitectura Spring Boot, GitHub Actions, migraciones y PostgreSQL efímero |
| B3/B4 | **IMPLEMENTADOS POR RECORRIDO** en I1, I2 e I3-01a/b; no implica 64 CU completos |
| B5 | **PARCIAL**: pantallas web básicas de acceso; no UI integral web/Android ni E2E de usuario |
| B6/B7 | **PENDIENTES**: integraciones externas y sincronización offline; F04 aprobada funcionalmente no equivale a S-01 implementado |
| B8 | **PARCIAL**: tests unitarios, integración PostgreSQL, API, RBAC y workflows; aceptación humana y BC06 pendientes |
| B9 | **BLOQUEADO**: artefacto/runbook disponibles, sin infraestructura certificada ni despliegue autorizado |
| B10 | **EN CURSO**: trazabilidad y actas técnicas; falta entrega/demostración/aceptación final |

**No confundir:** el éxito de GitHub Actions, SonarCloud o Testcontainers acredita su ámbito; **no** demuestra un E2E humano ni habilita despliegue. La [Issue app #35](https://github.com/leandrito369/ale-milanesas-app/issues/35) de duplicación de advice fue **cerrada tras el refactor #63**, pero ello no acredita una calidad o cobertura global del 100 %.

## 3. Bloqueos y deuda viva

1. **[App Issue #28](https://github.com/leandrito369/ale-milanesas-app/issues/28) ABIERTA:** entorno pausado por el responsable; faltan host/FQDN/TLS, operador/revisor y certificación. No desplegar ni habilitar escrituras productivas. Los endpoints mutables recientes conservan `@Profile("!prod")`, flags false por defecto y veto de `PrecondicionesDespliegue`. Los GET tienen controles de autorización pero no necesariamente esos mismos tres gates.
2. **[App Issue #10](https://github.com/leandrito369/ale-milanesas-app/issues/10) ABIERTA:** UC-54, **0/4 E2E humanos acreditados**.
3. **[App Issue #13](https://github.com/leandrito369/ale-milanesas-app/issues/13) ABIERTA:** **0/18 escenarios funcionales BC06 acreditados**; un workflow que marca escenarios como *skipped* no los ejecuta.
4. **I2 con reservas:** saldo exigible provisional `RD-F04-006` diferido al diseño F04; invalidación de rutas UC-25 diferida; segunda operación de UC-03 (reprogramar reparto) pendiente por persistencia; UC-21 ONLINE se reserva a I6. El rol `RESPONSABLE_PRODUCCION` en UC-34 está previsto por RD-I301-001 para integrarse junto con UC-28.
5. **F04/S-01:** [CR-B0-F04-001](01-gobierno/b0/CR_B0_F04_001_DISENO_FISICO_SINCRONIZACION_PENDIENTE_2026-10-29.md) sin ratificación física; [Issue documental #6](https://github.com/leandrito369/ale-milanesas/issues/6) conserva el seguimiento de offline y conciliación. No conceder UC-29 al Repartidor por inferencia.
6. **Modelo y coherencia documental:** [Issue documental #32](https://github.com/leandrito369/ale-milanesas/issues/32) sobre `nombreComercial` UC-37 vs MR5/MR6 **sin decisión formal**. No agregar columnas, derivar alias ni retirar el campo del contrato por cuenta propia. `RD-UC28-002` para idempotencia de preparación sigue como reserva futura.

**Higiene de PR históricos:** en la app permanecen abiertos #9, #11, #12 y #20/#22/#24. Los últimos tres ya tienen B4 integrados en otros PR, pero su posible cierre exige nuevo contraste por **contenido propio** y decisión de conservación; no fusionarlos automáticamente.

**Higiene de fechas:** las actas I1 e I2 tienen títulos/fechas **10/11 y 11/11/2026**, pese a que los commits `51f8ff5` y `ebbc398` fueron registrados el **08/11/2026**; la RD-I301-001 también está fechada 11/11 y ya figura fusionada en el corte. Se deja constancia del desfase **sin alterar esas fuentes ratificadas**. Proponer corrección editorial/adenda en PR independiente y con revisión del responsable.

## 4. Siguiente secuencia de trabajo

1. **I3-01c / UC-28:** implementar Registrar Preparación y la proyección contextual de UC-34 conforme RD-I301-001, contratos y MR-6; crear Issue/PR propios, tests B3/B4 y gate no-prod. Revisar expresamente el riesgo de repetición parcial (futura RD-UC28-002).
2. **I3-02:** UC-05/07/41 (Entrega, Excedentes y Descarte), sin confundir declaración/captura offline con confirmación de servidor ni Entrega con Cobro.
3. **I3-03:** UC-14/29/22/23 (Cuenta Corriente, Cobro/Caja), preservando RBAC y reglas F01/F04.
4. Seguir I4–I7; realizar aceptación humana/BC06 y certificación B9 **solo** cuando el responsable levante formalmente la pausa de #28 y se cumplan los gates.

**Criterio de estado:** `INTEGRADO` = código en `main`; `PROBADO EN CI` = pruebas del SHA indicado; `ACEPTADO` = evidencia funcional y humana requerida; `DESPLEGADO` = infraestructura certificada y autorización del responsable. **I1/I2 están cerrados técnicamente, no aceptados ni desplegados.**

---

# Histórico de estado — cortes 26/10 a 29/10/2026 (conservado)

> Los párrafos siguientes documentan la evolución histórica. Las frases anteriores a la ratificación G0, al alta de `ale-milanesas-app` y a la implementación I1/I2/I3 describen el estado **en su fecha**, no el actual. El corte vigente está al inicio de este archivo.

**Hito anterior:** corte documental del 25/10/2026. Este archivo agrega el estado de MR-5 y la habilitación de GitHub.

| Frente | Estado | Nota |
|---|---|---|
| Requisitos y dominio | Línea base histórica 23/10/2026 | Revisar contra cambios aprobados posteriores |
| Fases 1–4 / 64 CU | Consolidación documental terminada | Entregable maestro en **DOCX** fuera de este commit; no fingir que el extracto equivale al Word |
| Relaciones UML | 7 nuevas `include` aprobadas | El diagrama nuevo fue rechazado; no publicar como vigente |
| PRA-01 | Especificación acordada | Servicio aún no implementado |
| MR-1/MR-2 | Auditoría y dictamen | 53 hallazgos clasificados; evidencia en fuentes |
| MR-3 | Esquema propuesto | 60 tablas / 453 columnas / 125 FK; DDL sin ejecutar |
| MR-4 | Auditoría estática | 10 hallazgos F01–F10; no hay prueba PostgreSQL |
| MR-5 | Corrección propuesta | Patch y DDL, funciones/triggers no ejecutados |
| MR-6 | **Ejecutado — pruebas de BD satisfactorias** | PostgreSQL 17.11; DDL directo e incremental 59→60, catálogo, rollback, concurrencia e igualdad de huellas; ver informe MR-6 |

## Restricciones de avance
- Las correcciones MR-5 **compilaron y superaron pruebas seleccionadas en PostgreSQL 17.11** (MR-6). No equivalen a validación funcional de toda la aplicación.
- F01 (`COBRO.estadoCobro`) conserva definición incompleta de catálogo literal.
- Servicios para offline, PRA-01 y Reembolsos exigen lógica transaccional fuera del DDL.
- El alta del repositorio no implica desplegar sistema o cargar datos reales.

## Actualización
Editar solo mediante PR con evidencia. Para cambios posteriores registrar fecha, CR, artefactos y prueba. Seguir [protocolo](01-gobierno/PROTOCOLO_CAMBIOS_Y_CHATS.md).

## Evidencia MR-6 — 26/10/2026

- [Informe técnico](05-modelo-relacional/MR6_INFORME_EJECUCION_2026-10-26.md).
- [Resultado real GitHub Actions #40337106012](https://github.com/leandrito369/ale-milanesas/actions/runs/40337106012): éxito.
- Las pruebas de concurrencia y migración trabajan únicamente sobre contenedores y bases descartables.
- **Próximo frente:** cerrar F01 y los servicios F04/F05/F06/F07/F09 y, después, revisar el Diagrama Relacional; mantener sin cambios el Diagrama de CU rechazado.

## Adenda 29/10/2026 — Plan de implementación

El responsable adoptó el [plan rector B0–B10](01-gobierno/PLAN_RECTOR_IMPLEMENTACION_2026-10-29.md) y priorizó [B0](01-gobierno/B0_LINEA_BASE_IMPLEMENTACION_2026-10-29.md). Declaró terminados los DSS, DS y contratos de 64 CU; **queda por localizar/importar y verificar esos artefactos en Git**. El documento DOCX de 64 CU sí está en el repositorio. Las pruebas de BD MR-6 siguen siendo evidencia válida del 26/10; no hay afirmación de sistema completo ni de servicios implementados. La [delegación de programación](06-arquitectura/GUIA_DELEGACION_AGENTES_2026-10-29.md) requiere rama+PR, contratos, trazabilidad y pruebas reproducibles. Esta adenda no reemplaza las RD vigentes ni autoriza cambios de reglas o migraciones productivas.

## B0 en ejecución — 29/10/2026

Se recuperaron fuentes 64 CU / 67 operaciones DSS–DS–Contrato en ramas de revisión PR #10–#19; la cobertura de firmas de PR #19 es **estática/documental**, no API ni ejecución de negocio. Se generó el inventario [B0](01-gobierno/b0/B0_INVENTARIO_FUENTES_2026-10-29.md) y matriz [64/67](01-gobierno/b0/B0_MATRIZ_64_CU_67_OPERACIONES.csv) en rama apilada sobre PR #20. **G0 permanece NO APROBADO** hasta cotejo semántico exhaustivo, RBAC y ratificación de ADR, e integración controlada. Las pruebas MR-6 de PostgreSQL siguen válidas y no fueron reejecutadas aquí.

## Adenda 29/10/2026 — Consolidación contractual RBAC

Se ratificaron BC-01/02/03 como RD individuales, se corrigió BC-04 y BC-10 en versiones derivadas, y se verificó [RBAC 67 operaciones con 0 P](01-gobierno/b0/B0_MATRIZ_RBAC_67_OPERACIONES_CIERRE_2026-10-29.csv). El [dictamen residual](01-gobierno/b0/B0_DICTAMEN_CIERRE_CONTRACTUAL_Y_SEGURIDAD_2026-10-29.md) registra BC-05 con 21 trazas RF y [BC-07 propuesta de 15 proyecciones](01-gobierno/b0/BC07_PROYECCIONES_MINIMAS_15_ROL_CU.csv) **pendiente de ratificación**, más origen de documentos REV y condiciones de integración. **G0 sigue NO APROBADO**; no se ejecutaron pruebas de aplicación.

## Adenda 29/10/2026 — RD-B0-BC05 y RD-B0-BC07

El responsable aprobó la adenda **BC-05** y las 15 proyecciones de **BC-07** en el alcance exactamente propuesto. Nuevas fuentes de autoridad: [RD BC05](01-gobierno/b0/RD_B0_BC05_2026-10-29.md), [21 RF propagados](01-gobierno/b0/BC05_PROPAGACION_21_OPERACIONES_2026-10-29.csv), [RD BC07](01-gobierno/b0/RD_B0_BC07_2026-10-29.md), [15 campos/proyecciones ratificadas](01-gobierno/b0/BC07_PROYECCIONES_MINIMAS_RATIFICADAS_2026-10-29.csv), [regla BC09](01-gobierno/b0/BC09_REGLA_INVOCACION_INTERNA_EXTERNA_2026-10-29.md). BC-06 tiene [suite definida](01-gobierno/b0/BC06_CASOS_PRUEBA_IMPLEMENTACION_18.csv) pero **0/18 pruebas implementadas/ejecutadas**, al faltar código. La documentación histórica que dice «propuesta pendiente» queda superada por la RD más reciente; **G0 no aprobado** por restantes B0.3/B0.5/B0.7 y PR apiladas.

## B0 — Mapeo técnico completo a nivel candidato (29/10/2026)

Se preparó el [mapa técnico de 67 operaciones](01-gobierno/b0/B0_MAPA_TECNICO_67_OPERACIONES_2026-10-29.csv), [diccionario inverso de 60 tablas](01-gobierno/b0/B0_COBERTURA_60_TABLAS_Y_OPERACIONES_2026-10-29.csv), [reconciliación MR5/MR6](01-gobierno/b0/B0_MR5_MR6_CONCILIACION_TECNICA_2026-10-29.md), [6 ADR candidatas](06-arquitectura/B0_ADR_CANDIDATAS_PARA_G0_2026-10-29.md), [backlog I0–I3](01-gobierno/b0/B0_BACKLOG_I0_I1_PRIMER_VERTICAL_2026-10-29.md) y [Gate G0](01-gobierno/b0/B0_INFORME_GATE_G0_PARA_APROBACION_2026-10-29.md). Se conservan **7 módulos arquitectónicos candidatos**, con 12 subdominios para organización. B0.3/B0.5 **no** son decisiones aprobadas ni implementación. **G0 = NO APROBADO** por decisiones de ADR, fuentes y revisión de PR; MR6 válido solo como evidencia SQL.

## Ejecución real de CI documental E01-C (29/10/2026)

El [workflow B0 documental de GitHub Actions #40908456777](https://github.com/leandrito369/ale-milanesas/actions/runs/40908456777) terminó **SUCCESS**. El job `verificar-documentos` ejecutó `python -m unittest discover -s tests/b0 -p 'test_*.py' -v`: **9 tests ejecutados / 9 aprobados / 0 fallos**, según logs. Cuatro son específicos de mapeo (67 operaciones, 64 CU, 7 módulos, 60 tablas existentes, consistencia de RBAC y carácter candidato); cinco verifican RD/BC previos. **Es comprobación documental automatizada, no test de aplicación, transacción ni PostgreSQL nuevo**. BC-06 de implementación sigue **0/18**.

## Estado actual ratificado — 29/10/2026 (actualización posterior)

**Arquitectura:** [ADR-B1-01/02/03/04/06 RATIFICADAS](01-gobierno/b0/RD_B0_ADR_ARQUITECTURA_APROBADA_2026-10-29.md). **ADR-B1-05 / F04/S01: CR abierta y NO aprobada** ([CR](01-gobierno/b0/CR_B0_F04_001_DISENO_FISICO_SINCRONIZACION_PENDIENTE_2026-10-29.md)). **G0-D02 RESUELTO**, G0 general sigue pendiente de D01/D03/D04/D05, validación de fuentes y PR.

**Repositorios:** `leandrito369/ale-milanesas` se mantiene **solo como repositorio de análisis y diseño**. El nuevo repositorio de programación/documentación de implementación **no existe aún en el contexto disponible**: lo creará el responsable y comunicará su URL. [RD de separación](01-gobierno/b0/RD_B0_SEPARACION_REPOSITORIOS_2026-10-29.md) y [handoff](06-arquitectura/HANDOFF_REPOSITORIO_IMPLEMENTACION_PENDIENTE_2026-10-29.md). **No programar ni iniciar B1 hasta G0 + alta del repo**. SQL MR6 probado solo en laboratorio; BC06 de implementación 0/18.

## Actualización G0 y alta del repositorio de implementación — 29/10/2026

**Repositorio nuevo confirmado**: [ale-milanesas-app](https://github.com/leandrito369/ale-milanesas-app) creado por responsable, `main` inicial, **sin implementación**. La instalación GitHub actual permite leer pero **rechaza la escritura (403)** hasta añadir el repo seleccionado. Ver [acta de alta](01-gobierno/b0/G0_ALTA_REPO_IMPLEMENTACION_2026-10-29.md).

**Expediente Gate:** [manifiesto 67 operaciones](01-gobierno/b0/G0_MANIFIESTO_67_OPERACIONES_FUENTES_INMUTABLES_2026-10-29.csv), [dictamen](01-gobierno/b0/G0_DICTAMEN_APTITUD_CIERRE_2026-10-29.md), [plan PR](01-gobierno/b0/G0_PLAN_INTEGRACION_CONTROLADA_PR_2026-10-29.md), [acta para ratificación](01-gobierno/b0/G0_ACTA_PARA_RATIFICACION_2026-10-29.md). **D02 resuelta; D01/D03/D04/D05 y revisión/merge pendientes**. Fuentes origen verificadas, **no aprobadas como paquete canónico final**.

**G0 NO APROBADO.** No iniciar B1 hasta resolución formal.

## Estado final de la línea base — 29/10/2026 (última actualización)

**B0 y G0: APROBADOS DOCUMENTALMENTE**, conforme [RD-B0-G0-001](01-gobierno/b0/RD_B0_G0_001_CIERRE_LINEA_BASE_2026-10-29.md) después de las fusiones controladas #9, #10–#19 y #20–#26. Las decisiones D01–D05 están ratificadas y la fuente queda fijada en `1263ffc17bd0eb7f3c69faaa9ff5ae556cf9de7e`. La [bitácora de 18 merges](01-gobierno/b0/G0_BITACORA_FUSION_18_PR_2026-10-29.md) identifica cada operación. [Manifiesto canónico 67 operaciones](01-gobierno/b0/G0_MANIFIESTO_CANONICO_67_OPERACIONES_2026-10-29.csv) con **40 B0 + 27 REV**, todas integradas, reemplaza el uso del manifiesto provisional como fuente para implementar. Se espera CI final de este paquete para registrar su aprobación operativa.

**Sin programación en este repo.** `ale-milanesas-app` recibe B1 y `source-lock` vinculado a G0. **BC06 0/18 ejecutadas**, CR física F04 sigue pendiente; validación académica y pruebas de aplicación son posteriores.
