# Roadmap operativo I3–I7 — Ale Milanesas

**ID:** ROADMAP-OPERATIVO-2026-11-15  
**Fecha de adopción por el responsable:** 15/11/2026.  
**Revisión operativa controlada:** 15/11/2026 — PR #49, commit incremental posterior a `d08decb8a88195c1b4e9b1fa1b84d490b46af9e5`.  
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

1. **R01 — Evidencia local L0.5:** la app ya tiene PR #87 OPEN/DRAFT en rama `docs/l05-local-synthetic-2026-11-15`, HEAD `72860a5` (`72860a530c9366863fe2f40f3af1f8c8c2fab98d`), con CI exitoso (B1 Maven/Testcontainers y SonarCloud). Resultados informados 9/9 HTTP, 6/6 concurrencia, un pedido sintético coherente. No equivale a aceptación humana.
2. **R02–R03 — C3-A.2 / H/RT-UC07-04:** inventario de locks, writers, advisory namespaces, FKs/triggers, luego intercalados reproductibles con evidencia R/P; la regresión del advisory UC-19 `(1919,1)` en app PR #86 ya está integrada. **H permanece abierta**.
3. **R04–R07 — UC-07 gobierno:** CR-C gobierno PR #47 y CR-F gobierno PR #48 siguen draft; A–C ratificadas en corte C1; el responsable ratificó D/E de UC-07 el 15/11/2026 según la evidencia comunicada en la auditoría (asiento y conciliación documental todavía pendientes en CR-C/CR-F), manteniendo 1 MiB, 2 MiB y 4096×4096 como parámetros experimentales de E sujetos a calibración; F/G pendientes de autorización y H pendiente de pruebas/decisión. Pendiente: conciliación documental en CR-C/CR-F, calibración E y pruebas de implementación futuras. No implementar DDL ni UC-07 antes de autorización.
4. **R08–R09 — UC-05 y rendición UC-29:** R08.1–R08.3 (PR gobierno #50–#52) inventarian contratos y diseño candidato; **R08.4 PR #53** define alternativas de cálculo/IMP-01; **R08.5 PR #54** audita y prioriza P0/P1/P2; **R08.6** será el expediente integrado de diseño/CR física bajo autorización propia. El plan detallado **R09.1–R09.5** consta en **R09-PRE app PR #92**, solo documental; está BLOQUEADO para código/DDL hasta decisiones, enmiendas E-01..E-07, C3/CR y autorización expresa. Distinguir declaración de Repartidor (`D_e`), anticipo confirmado aplicado (`P_e`), reconocimiento provisional (`V_e`) y Cobro/Caja definitiva; conservar RD-I302-001 PR #44 y G0.
5. **R10–R13 — I3-02:** cuando se autorice UC-07 (CR-C #47/CR-F #48 y H/RT-UC07-04), tramitar migración nueva no disruptiva, tests físicos, servicios y API; UC-41 y UC-61, control de Excedentes y acta de cierre. **Dependencia DC-03-B:** el cálculo final de `C_e` debe incorporar adicionales UC-07 realmente entregados, una vez autorizado su contrato y valorización, sin doble ajuste. Si un primer incremento online de UC-05 solo cubre originales, debe bloquear pedidos con adicionales no integrados y **no** declarar UC-05/I3-02 completos.
6. **R14 — I3-03:** cuenta corriente, Cobro y rendición, Caja y Libro Diario con F01/F04, roles y contraasientos. A la fecha de revisión, **app PR #90 (UC-23) y #91 (UC-22) son drafts independientes**, no hitos integrados; #91 modifica `CobroManualService` y exige revisión de compatibilidad con IMP-01, D7-A y orden C3 antes de R09.1.
7. **R15–R18 — Interfaces, I4–I6:** trabajo en paralelo acotado por equipos/agentes, sin afirmar que servicios ausentes estén terminados.
8. **R19–R20 — Calidad y entrega:** BC06, UC-54 E2E, integraciones simuladas, manuales, certificación B9 cuando se autorice.

## 5. Calendario objetivo de ejecución (sujeto a capacidad y gates)

| Ventana | Meta dominante | Salida necesaria |
|---|---|---|
| **15–21/11** | Congelar hoja de ruta, seguimiento PR #87 (L0.5), C3-A.2, conciliación documental D/E en CR-C/CR-F, calibración E, resolver gobierno UC-05 y F/G/H en el alcance posible; prototipo UI de servicios ya integrados | PR/actas de decisión, conciliación documental, matriz locks y plan de intercalados, backlog de implementación autorizado |
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

**Ruta crítica de gobierno:** C3/H + conciliación documental D/E + calibración E + decisiones F/G → revisión CR-C/CR-F → autorización → pruebas de implementación futuras y UC-07.  
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
- E conserva 1 MiB, 2 MiB y 4096×4096 como parámetros experimentales sujetos a calibración; no son límites numéricos definitivos.
- Triple gate no-prod para escrituras HTTP experimentales y RBAC del contrato.
- B8 y B10 continuas; test documentado ≠ test ejecutado ≠ aceptación humana.
- Issue app #28 abierta; entorno de despliegue PAUSADO.
- Cada **entregable/incremento** termina en rama+PR identificable, CI/evidencia, revisión y autorización cuando corresponda; **no** es necesario abrir una PR por cada microdecisión. Consolidar decisiones funcionales por paquete con trazabilidad a RD previas y sin reescritura de historia; ningún merge automático.

**Seguimiento:** revisar este roadmap con cada avance y al menos semanalmente, registrar desvíos, bloqueantes y replanificación vinculada a la fecha 12/12 sin sobrescribir la historia de decisiones.

**Autoridad final:** el Plan Rector adoptado el 29/10, G0 y las RD vigentes prevalecen ante discrepancias. Este documento es una hoja de ruta de ejecución, no una nueva RD comercial.

## 9. Revisión controlada de R08–R09 e I3-02/I3-03 (15/11/2026)

**Naturaleza:** actualización **operativa del roadmap** tras R08.4/R08.5, el registro funcional de P0 y las primeras decisiones P1. **No sustituye** el Plan Rector del 29/10, G0, contratos canónicos, RD ratificadas, las CR abiertas ni source-lock. **No autoriza** SQL, esquema, migraciones, `src/**`, permisos ni despliegue. Los estados indicados corresponden a la revisión del 15/11 y deben contrastarse en GitHub antes del siguiente corte; una PR draft no equivale a integración en `main`.

### 9.1. Correspondencia verificable entre roadmap y subcortes

| Frente del roadmap | Subcorte/expediente ya existente | Estado de referencia | Puerta de salida y consecuencia |
|---|---|---|---|
| **R02–R03** | Campaña C3-A.3 de concurrencia, **app PR #89**; matriz de locks H/RT-UC07-04 | PR draft; resultados R/P no prueban protocolo final UC-05↔UC-29↔UC-07 | Completar C3 de servicios reales y dependencias CR-C/CR-F; no cerrar H prematuramente |
| **R04–R07** | Gobierno UC-07: **PR #47 (CR-C)** y **#48 (CR-F)** | Draft; A–E según ratificaciones comunicadas, F/G/H pendientes de cierre y prueba | Conciliar D/E, calibrar E, validar F/G/H, luego CR y pruebas; no generar adicionales ficticios |
| **R08** | **R08.1/R08.2/R08.3**: antecedentes de gobierno en **PR #50–#52** | Diseño y auditorías previas, no autorización física | Conservar decisiones expresas D5-B/ANT-01/D6-1/D7-A |
| **R08** | **R08.4 PR #53** y **R08.5 PR #54** | Contratos propuestos/auditoría; ambos draft | Completar P1/P2, conciliación E-01..07 y paquete contractual |
| **R08** | **RD-I302-003..011, gobierno PR #55–#63** | Asientos de decisiones funcionales, PR draft; **no fusionados** | Referenciar y consolidar por paquete; no confundir CI documental con prueba de negocio |
| **R08** | **R08.6** bajo **CR-B0-F04-001** | Bloqueado para trabajo físico | Integrar diseño PE-1+PE-2+IMP-01 y prueba propuesta C3; aprobación específica de CR antes de cualquier DDL/laboratorio |
| **R09** | **R09-PRE, app PR #92** | Preparación documental, no implementación | Gate P0/P1/P2 + contratos + R08.6; solo después iniciar R09.1–R09.5 |
| **R10–R13** | Integración UC-07, UC-41, UC-61 y cierre técnico I3-02 | Condicionado a CR-C/CR-F, concurrencia y cálculo UC-05 | Completar la Entrega también con adicionales efectivamente entregados; H3 no se marca por prototipo |
| **R14** | I3-03, app PR #90 UC-23 y #91 UC-22; UC-14/29 en R09.3 | PR #90/#91 draft, dependencias financieras activas | No dar por integrado; conciliar PR #91 con UC-29/C3 y proteger el hito H4 |
| **R15–R20** | Interfaces, vertical H5, BC06, UC54 E2E, documentación | Deben avanzar en paralelo sobre servicios integrados | Acreditar pruebas reales, revisión humana, sin desplegar con Issue app #28 abierta |

**Relación con Plan Rector:** los microcortes R08.1–R08.6 y R09.1–R09.5 **son desglose operativo de R08–R09**, no incrementos que lo sustituyan. I3-02 e I3-03 continúan subordinados a H3/H4/H5, y B5/B8/B10 requieren avance paralelo. El Plan Rector mantiene **64 casos de uso / 67 operaciones**: no hay recorte tácito por el desdoblamiento PE-3 offline.

### 9.2. Registro consolidado de decisiones de negocio (fotografía del corte)

| Paquete | Decisiones funcionales aprobadas por el responsable | Evidencia documental y límite |
|---|---|---|
| Regla de Entrega/rendición | **D5-B, ANT-01, D6-1, D7-A** | R08.3/R08.4 y RD previas; **no** autorizan reconocimiento `V_e` ni migraciones |
| Anticipos/IMP-01 (**P0**) | **DC05-01/02-A, DC05-03-A, DC05-04-B, DC05-05/06-A, DC05-07-A, DC05-09-A** | Gobierno **PR #56/#57/#55/#58/#59/#60**, respectivamente; IMP-B fuente canónica append-only, IMP-A proyección, IMP-C solo contención |
| Alcance F04 (**P0**) | **D12-C:** CR-B0-F04-001 articulada por fases: **online PE-1+PE-2+IMP-01**; **offline PE-3 diferida** con gate propio | Gobierno **PR #61**; la CR **sigue ABIERTA** y no está autorizada físicamente |
| Cargo de Entrega (**P1**) | **DC-01-C1** (cantidades entregadas y precios/promociones congelados); **DC-02-A** (porcentaje de ajuste histórico sobre base entregada); **DC-04-A** (dos redondeos `HALF_UP` a escala 2, base agregada y ajuste, como UC-16) | Gobierno **PR #62/#63**; controles de reconciliación por detalle; C3 solo evidencia candidata, no DDL |
| Adicionales y sobrantes (**P1**) | **DC-03-B** (adicional UC-07 entregado, histórico, único y sin reajustar dos veces); **DC05-08-A** (consolidar hasta `C_e`, liberar excedente a crédito libre/FIFO) | **Aprobación funcional expresa comunicada por el responsable en este corte; asiento documental consolidado todavía pendiente.** Dependen de UC-07 autorizado y del evento IMP-B, respectivamente |
| Otras reglas | **D2=B** (declaración `D_e` íntegra, incluso exceso) y **EX-01** (sin crédito/Cobro/Caja por exceso automático) | Asiento/conciliación integral pendiente; no da por resuelto `C_e=0` o diferencias |

**Importante:** `COBRO.idPedido` **no** demuestra por sí solo una imputación monetaria; `P_e` requiere evidencia verificable. Una reserva no es `P_e` definitivo hasta su consolidación en UC-05. El cambio a UC-15 requiere respetar imputaciones explícitas primero y solo después FIFO sobre **créditos libres**; tránsito no rendido **no** constituye Cobro confirmado. Liberar remanente de anticipo a crédito libre puede cambiar la mora histórica según reglas vigentes, y debe probarse.

### 9.3. Secuencia R09.1–R09.5 alineada con H3/H4/H5

| Paso | Función vertical | Dependencia de entrada | Salida verificable; NO extrapolar |
|---|---|---|---|
| **R09.1** | Fundaciones físicas PE-1/PE-2/IMP-01, evidencias, identidad/idempotencia, guarda anulación, reconciliación UC-15 | R08.6 físico autorizado, DC-10/C3, C-04 y E-01..07 ratificados | Migración y tests **solo cuando autorizados**, regresiones UC-29; sin inferir H3 |
| **R09.2** | UC-05 online: `C_e/P_e/D_e/V_e`, cantidades, Cuenta, stock y excedentes, API/seguridad | R09.1 y DC-06/DC-07/DC-03, snapshot comercial ratificados | UC-05 para originales con tests; **si adicionales UC-07 no integrados, rechazar expresamente esas Entregas**. No declarar cierre funcional UC-05 |
| **R09.3** | UC-14 (VENDEDOR), rendición UC-29 (ADMIN), proyección D9 y cese atómico de tránsito | DEC-GRAN-D6, D9/BC-07, D10/diferencias, D4 | Pruebas D56, antifuga RBAC, conciliación PE-2 sin doble descuento; ruta hacia H4 |
| **R09.4** | Integración UC-06, UC-07 y UC-15: cancelación y liberación IMP-B, adicionales, mora explícita, posibles cruces UC-03 | CR-C/#47 y CR-F/#48 autorizadas, H/RT-UC07-04/C3 certificada, DC05-08 y DC05-04 | Entrega original/adicional con T12/T24/IMP-T15, UC-06 sin crédito fantasma; H3 exige integración UC-41/UC-61 del frente R10–R13 |
| **R09.5** | Regresión RBAC 67×8, BC-07, BC06 (18 escenarios), HTTP/E2E y trazabilidad | R09.1–R09.4 integradas, hito H4 estabilizado | Evidencia CI/Testcontainers por SHA y pruebas humanas; no presentar BC06/E2E como ejecutados hasta su corrida |

**Dependencia cruzada crítica:** UC-07 no es una nota para «más adelante» si DC-03-B forma parte de UC-05 completo. Se permite **secuenciar** originales antes de adicionales para reducir riesgo únicamente con **guardia explícita** para pedidos con ofertas aceptadas/adicionales todavía no soportados. No se modifica el alcance aprobado ni se marca H3/I3-02 completos hasta la integración de UC-07 y UC-41/UC-61 aplicables.

### 9.4. Decisiones bloqueantes, trabajos delegables y puerta formal

| Tipo | Pendiente | Autoridad/acción necesaria |
|---|---|---|
| **Negocio/alcance** | **DC-06:** tope `V_e^0` y persistencia de reconocimiento; **DC-07:** `C_e=0,D_e>0`/EX-01; **DC-08/D10:** diferencias tipadas y sobrerendición; **DEC-GRAN-D6:** unidad de rendición; **D9/BC-07:** visibilidad por rol | Responsable revisa **un paquete P1 consolidado** con ejemplos, impactos y recomendación integral |
| **Seguridad/contratos** | **D3/D4**, **C-04** anulación idempotente, **DC05-11/12** históricos/idPedido, ratificación **E-01..07** para REV04B/REV05/RD-I302-001 y evaluación G0/RBAC | Documentar cambios contractuales y riesgos; autorización expresa donde cambie regla/permiso |
| **Ingeniería delegable** | `DC05-10/DC-10` orden de locks, proyección IMP-A, conservación/unique/FK, asignación centavos de detalle, recuperación idempotente, diseño SQL y estrategia de tests | Arquitectura prepara **una propuesta integrada** y evidencia; no pide voto humano sobre nombres de tablas o locks, salvo cambio de regla o CR |
| **CR física** | `CR-B0-F04-001` sigue ABIERTA, PE-3 offline diferida (D12-C) | Autorización humana **específica** para R08.6 SQL/laboratorio, luego para migración/implementación. **Ninguna autorización inferida de P0/P1** |
| **Integración** | UC-07 F/G/H, PR app #91 toca CobroManualService, C3 de servicios reales, interfaz y aceptación | Integrador revisa compatibilidad de las ramas sin rebase/amend/force-push y ejecuta tests por SHA |

### 9.5. Seguimiento de capacidad, riesgos y decisiones de integración

| Riesgo | Estado y señal | Acción/criterio de control |
|---|---|---|
| **R-CAL — Plazo 12/12** | **ALTO**: P1/P2, CR y R09 físico pendientes; ventana 22–28/11 dependiente | Medir semanalmente lead time real, PR integradas, H3/H4/H5 ejecutables y capacidad por agente; no afirmar factibilidad de 64/67 sin evidencia |
| **R-FIN — Modelo de obligación** | **ALTO**: `P_e` no está representado canónicamente en V1–V3; FIFO anterior contradice destino explícito | Contrato IMP-B + pruebas de no doble uso y mora antes de V4/UC-05; fallback IMP-C sin `V_e^0` cuando falte evidencia |
| **R-CON — Concurrencia C3** | **ALTO**: orden `COBRO U→CLIENTE U` en anulación y cruces UC-05/07/29, R/P no suficiente | Protocolo global ratificado y PostgreSQL real con intercalados; cero `40P01` nuevos en suite requerida |
| **R-UC07 — Dependencia transversal** | **ALTO**: CR-C/CR-F draft, F/G/H no cerrados; UC-05 con adicionales puede cargar mal | No aprobar conclusión UC-05 con adicionales antes de CR autorizada y pruebas reales de valorización parcial |
| **R-GOB — Deuda de decisión fragmentada** | **ALTO**: gobierno PR #55–#63 draft, riesgo de documentación no integrada | Consolidar por paquete (no micro-PR), auditar duplicaciones/contradicciones y sincronizar backlog; no fusionar PR antiguas indiscriminadamente |
| **R-TEST — Aceptación** | **ALTO**: CI documental no prueba E2E humano, BC06 completo ni operación segura | Iniciar UI y pruebas sobre servicios existentes; constatar 18 BC06 + 4 UC54 E2E reales cuando corresponda |
| **R-DEP — Despliegue** | PAUSADO por Issue app #28 | Mantener veto hasta autorización explícita; el merge de este roadmap **no cambia** ese estado |

**Revisión por avance (y como mínimo semanal):** registrar hito `H3/H4/H5` involucrado, SHA, prueba ejecutada vs propuesta, ruta crítica, desvío frente a ventana 15–21/11 o 22–28/11, dueño técnico y decisión solicitada (solo si es comercial/CR). Los hallazgos técnicos se corrigen mediante integración y tests, sin ratificación de cada detalle. Si el alcance/fecha académicos resultan inviables, elevar anticipadamente propuesta formal a la cátedra; no reducir unilateralmente los 64 CU ni ocultar el desvío.

### 9.6. Puerta de integración documental de esta revisión

**Esta actualización del roadmap es únicamente B10/B0 de seguimiento.** Integrarla en `main` significa disponer de un plan actualizado; **no equivale a ratificar ni fusionar** las PR #44, #47/#48, #53–#63, #90–#92 del repositorio de aplicación, ni modifica el Plan Rector, source-lock, G0, permisos, migraciones, código o entorno. Mantener `PE-3` fuera de R09.1–R09.5 por D12-C, sin eliminarlo de I6/B7. El hito H5 sigue requiriendo recorrido `Pedido→Preparación→Entrega→Cuenta→Cobro/Caja` con interfaz, pruebas y validación.
