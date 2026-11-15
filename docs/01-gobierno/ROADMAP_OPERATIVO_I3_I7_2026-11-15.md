# Roadmap operativo I3–I7 — Ale Milanesas

**ID:** ROADMAP-OPERATIVO-2026-11-15  
**Fecha de adopción por el responsable:** 15/11/2026.  
**Objetivo de finalización académica:** 12/12/2026.  
**Estado:** ADOPTADO COMO PLAN DE SEGUIMIENTO por decisión expresa del responsable; integración documental pendiente de revisión de esta PR.  
**Autoridad:** complementa, **no sustituye**, `docs/01-gobierno/PLAN_RECTOR_IMPLEMENTACION_2026-10-29.md`, G0, las RD ratificadas y los contratos vigentes. No autoriza por sí solo códigos, DDL, merges, despliegues, cambios en RBAC ni reducción del alcance de 64 CU/67 operaciones.

## 1. Propósito y forma de seguimiento

Hacer visible lo implementado, lo pendiente y lo bloqueante hasta la fecha objetivo. Operar con Proceso Unificado adaptado, iterativo e incremental, y recorridos verticales **contrato → diseño → persistencia → servicio → API/interfaz → pruebas → trazabilidad**. Separar:
- **RATIFICADO** (decisión de gobierno).
- **INTEGRADO** (merge en main).
- **PROBADO** (evidencia de ejecución en SHA concreto).
- **CERRADO TÉCNICAMENTE** (acta de incremento).
- **ACEPTADO** (validación funcional/humana).
- **DESPLEGADO** (infraestructura certificada y autorizado).

**Fuente de foto inicial (verificar los HEAD antes de cada corte):**
- Gobierno main: `cdd57ed194268f1f5ab29aa0f55781ddddebdfb5`.
- Aplicación main: `4dbe38668fc5cbc08d04e10920e3bf165c71be11`.
- Source-lock G0: `1263ffc17bd0eb7f3c69faaa9ff5ae556cf9de7e`; 64 CU y 67 operaciones principales.
- Los documentos de estado del 09/11 son snapshots históricos y no acreditan por sí solos cierres posteriores.

## 2. Estado de bloques B0–B10

| Bloque | Estado al corte | Trabajo faltante relevante |
|---|---|---|
| B0 Gobierno | G0 aprobado | RD/CR de pendientes nuevos, trazabilidad y auditoría cruzada |
| B1 Arquitectura/entorno | Base integrada | Configuración por ambientes, reproducibilidad operativa y certificación posterior |
| B2 PostgreSQL | Flyway V1–V3 integrado | Cambios físicos autorizados; pruebas de permisos, históricos, backups/restauración |
| B3 Servicios | Parcial | I3-02/I3-03 y operaciones pendientes I4–I6 |
| B4 HTTP/seguridad | Parcial | Adaptadores restantes, permisos, idempotencia, errores |
| B5 Interfaces | Parcial | UI web/móvil y recorridos E2E; comenzar por APIs ya integradas |
| B6 Integraciones | Pendiente integral | Pagos, mensajería y rutas con mocks/sandbox y reintentos |
| B7 Offline | Reglas F04 funcionales aprobadas, físico pendiente | Persistencia local, cola, sincronización y conflictos |
| B8 Pruebas | Activa e incompleta | BC06 (18), UC54 (4 E2E humanos), regresiones, concurrencia, aceptación |
| B9 Despliegue | PAUSADO, app Issue #28 OPEN | Certificar host, TLS, firewall, backup/restore; autorización expresa |
| B10 Documentación | Continua, incompleta | Manuales, matriz final, evidencias, demostración y defensa |

## 3. Estado de iteraciones e hitos

| Incremento | Estado | Evidencia / próximo objetivo |
|---|---|---|
| I0 | Infraestructura técnica integrada | Backend/PostgreSQL/CI; laboratorio L0 informado 619 tests sin fallos |
| I1 | **6/6 paquetes cerrados técnicamente** | Usuarios, clientes, productos, precios, categorías e insumos; aceptación E2E sigue pendiente |
| I2 | **3/3 paquetes cerrados técnicamente** | UC-03/34/43; reservas como reprogramación UC-03 |
| I3-01 | Cerrado técnicamente | UC-09/10/28; idempotencia UC-28 y rutas UC-25 siguen reservadas |
| I3-02 | **Prioridad inmediata P0** | UC-05 Entrega; UC-07 Oferta/Reasignación; UC-41 Descarte; UC-61 contextual |
| I3-03 | Siguiente P0 | UC-14 Cuenta Corriente; UC-29 Cobro; UC-22 Caja; UC-23 Libro Diario |
| I4 | Pendiente | Cancelación UC-06, consultas/complementarios comerciales, margen UC-27, movimientos UC-64, reservas; conciliación del alcance con Plan Rector |
| I5 | Pendiente | Proveedores, cotizaciones, reposición y órdenes; reutilizar UC-08/UC-42 ya integradas |
| I6 | Pendiente | ONLINE, promociones, Mercado Pago, WhatsApp, OSRM y F04 offline; requiere CR/decisiones aplicables |
| I7 | Pendiente | Regresión, UI/E2E, seguridad, operación autorizada, aceptación y defensa |

**Nota de interpretación:** el Plan Rector original presenta I4 con cancelaciones/excedentes/cuenta/cobro; el backlog posterior adelantó excedentes y finanzas a I3-02 e I3-03. Mantener esta descomposición operativa **sin duplicar UC** ni alterar el catálogo. La partición detallada I4–I7 aquí es una **planificación operativa**, no una ratificación de nuevos contratos.

## 4. Frentes activos y bloqueos inmediatos

1. **R01 — Evidencia local L0.5:** la app tiene rama `docs/l05-local-synthetic-2026-11-15` con documento y commit `72860a530c9366863fe2f40f3af1f8c8c2fab98d`; abrir PR documental draft y validar CI. Resultados informados 9/9 HTTP, 6/6 concurrencia, un pedido sintético coherente. No equivale a aceptación humana.
2. **R02–R03 — C3-A.2 / H/RT-UC07-04:** inventario de locks, writers, advisory namespaces, FKs/triggers, luego intercalados reproductibles con evidencia R/P; la regresión del advisory UC-19 `(1919,1)` en app PR #86 ya está integrada. **H permanece abierta**.
3. **R04–R07 — UC-07 gobierno:** CR-C gobierno PR #47 y CR-F gobierno PR #48 siguen draft; A–C ratificadas en corte C1; D/E especificadas y pendientes de ratificación, límites numéricos E sujetos a calibración; F/G pendientes de autorización y H pendiente de pruebas/decisión. No implementar DDL ni UC-07 antes de autorización.
4. **R08–R09 — UC-05:** revisar/ratificar RD-I302-001 en gobierno PR #44; distinguir dinero declarado en reparto de Cobro/Caja definitiva; después implementar servicio/API/tests según decisiones.
5. **R10–R13 — I3-02:** cuando se autorice UC-07: migración nueva no disruptiva, tests físicos, servicios y API; UC-41 y UC-61 integrados con exclusión de stock; acta de cierre técnico del incremento.
6. **R14 — I3-03:** cuenta corriente, cobro, caja y libro diario con F01/F04, roles y contraasientos.
7. **R15–R18 — Interfaces, I4–I6:** trabajo en paralelo acotado por equipos/agentes, sin afirmar que servicios ausentes estén terminados.
8. **R19–R20 — Calidad y entrega:** BC06, UC-54 E2E, integraciones simuladas, manuales, certificación B9 cuando se autorice.

## 5. Calendario objetivo de ejecución (sujeto a capacidad y gates)

| Ventana | Meta dominante | Salida necesaria |
|---|---|---|
| **15–21/11** | Congelar hoja de ruta, PR L0.5, C3-A.2, resolver gobierno UC-05 y D/E/F/G/H en el alcance posible; prototipo UI de servicios ya integrados | PR/actas de decisión, matriz locks y plan de intercalados, backlog de implementación autorizado |
| **22–28/11** | I3-02: UC-05/UC-41 y UC-07 por cortes autorizados; levantar pruebas/CI y avance UI paralelo | Primer circuito Entrega/Excedentes comprobable, sin dar cierre ficticio a H |
| **29/11–05/12** | I3-03 e I4/I5 prioritarios; integraciones por mocks/sandbox; interfaces del vertical comercial | Pedido → Preparación → Entrega → Cuenta/Cobro/Caja de extremo a extremo, con riesgos explícitos |
| **06–12/12** | Congelamiento funcional temprano, correcciones, E2E/BC06, documentación y defensa; B9 solo si se habilita | Release candidate reproducible + evidencia y acta de alcance realmente terminado |

**Limitación de planificación:** finalizar íntegramente los 64 CU, interfaces, integraciones, offline, E2E, certificación y defensa en 27 días es una meta de alto riesgo. Este calendario es una **hipótesis de ejecución**, no una promesa ni evidencia de factibilidad. Medir capacidad y replanificar semanalmente. Si no se puede completar el alcance académico exigido, tramitar cambio/acuerdo formal con la cátedra; **nunca declarar 64/67 implementados sin evidencia**. La pausa de despliegue puede afectar la aceptación independientemente del avance local.

## 6. Hitos y condiciones de salida

- **H0:** backend/DB/CI reproducibles (evidencia existente).
- **H1:** pedido registrado, precio/ajuste congelado, consultable; UI por verificar.
- **H2:** preparación y stock con costo histórico (I3-01 técnico).
- **H3:** entrega y excedentes I3-02 integrados con pruebas de concurrencia.
- **H4:** cuenta/cobro/caja I3-03 integrados con trazabilidad de movimientos.
- **H5 (primer vertical comercial evaluable):** Pedido → Preparación → Entrega → Cuenta Corriente → Cobro/Caja con interfaz y pruebas.
- **H6:** ciclo compras y recepción con decisión humana.
- **H7:** ONLINE, integraciones y offline conforme a contratos.
- **H8:** regresión y aceptación por operaciones.
- **H9:** certificación autorizada de entorno y entrega académica.

## 7. Priorización, paralelismo y métricas

**Ruta crítica de gobierno:** C3/H + decisiones D/E/F/G → revisión CR-C/CR-F → autorización → UC-07.  
**Ruta crítica de negocio:** RD-I302-001 → UC-05 → I3-03 → H5.  
**Ruta crítica posterior:** proveedores/reposición/compra → canales/integraciones/offline → aceptación y defensa.

Frentes paralelos permitidos sin contradicciones:
- Gobernanza y pruebas C3 sobre infraestructura efímera.
- Desarrollo de UI sobre APIs ya integradas.
- Diseño y, tras decisión, UC-05.
- Preparación de escenarios BC06/E2E y documentación.

**Métricas por corte semanal:** operaciones de 67 implementadas con SHA, operaciones con pruebas, PR/CI, bloqueantes RD/CR, cobertura de flujos/UI, BC06 acreditados de 18, E2E de UC54 acreditados de 4, deuda técnica, riesgos y fecha de cierre. No usar un porcentaje global artificial sin ponderación justificada.

## 8. Reglas duras y mecanismo de revisión

- G0 y 64/67 congelados; sin rebase, amend, force-push o pushes a main.
- CR-C/CR-F abiertas y no autorizadas; no fusionar ni inferir aprobación.
- No ejecutar SQL candidato de CR-F en bases persistentes, ni crear V4 por cuenta propia.
- H/RT-UC07-04 abierta; 6 tests concurrentes aprobados no certifican ausencia global de deadlocks.
- E no tiene límites numéricos definitivos sin calibración.
- Triple gate no-prod para escrituras HTTP experimentales y RBAC del contrato.
- B8 y B10 continuas; test documentado ≠ test ejecutado ≠ aceptación humana.
- Issue app #28 abierta; entorno de despliegue PAUSADO.
- Cada corte termina en rama+PR independiente, CI/evidencia, revisión y decisión expresa; ningún merge automático.

**Seguimiento:** revisar este roadmap con cada avance y al menos semanalmente, registrar desvíos, bloqueantes y replanificación vinculada a la fecha 12/12 sin sobrescribir la historia de decisiones.

**Autoridad final:** el Plan Rector adoptado el 29/10, G0 y las RD vigentes prevalecen ante discrepancias. Este documento es una hoja de ruta de ejecución, no una nueva RD comercial.
