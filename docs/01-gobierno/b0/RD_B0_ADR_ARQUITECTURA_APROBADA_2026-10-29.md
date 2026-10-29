# Acta de decisión — Ratificación de arquitectura para línea base B0

**Proyecto:** Sistema de Gestión para Ale Milanesas (UNaM-FCEQyN)  
**Fecha de ratificación:** 29/10/2026  
**Autoridad:** responsable del proyecto, decisión expresa en conversación del 29/10/2026 a las 16:26:59 UTC  
**Estado:** **APROBADA EN SU ALCANCE DOCUMENTADO** para ADR-B1-01, -02, -03, -04 y -06.  
**Fuente técnica previa:** [B0_ADR_CANDIDATAS_PARA_G0_2026-10-29.md](../../06-arquitectura/B0_ADR_CANDIDATAS_PARA_G0_2026-10-29.md), PR #24, commit `682f9d1b4e469ed7aca38da95fbe8f2e11351a9a`.

## 1. Ratificación literal del responsable

> «Ratifico ADR B1-01, B1-02, B1-03, B1-04 y B1-06 tal como quedaron propuestas, manteniendo B1-05 sujeta a una CR específica. Recordar documentar cuestiones de implementación en un nuevo repositorio, o desarrollarlo si pero esperar al alta del nuevo repositorio por mi parte».

Esta acta **registra la decisión**; no constituye un permiso para crear repositorios, generar código de aplicación en el repositorio de análisis, ejecutar una migración o iniciar producción.

## 2. Decisiones ratificadas

| ADR | Estado | Alcance aprobado y límites explícitos |
|---|---|---|
| **ADR-B1-01** | **RATIFICADA** | **Monolito modular Java/Spring Boot**, una base PostgreSQL y **7 módulos lógicos**; 12 subdominios funcionales para ordenar el trabajo, **no** 12 procesos desplegables. **Maven** continúa como propuesta de herramienta de build, según texto original; versión exacta de Java/Spring y dependencias se resuelve reproduciblemente durante B1. |
| **ADR-B1-02** | **RATIFICADA** | Web servidor **Thymeleaf**, Android **Kotlin/Room**, API HTTP/JSON tipada, manejo formal de errores, sesiones y controles de identidad en servidor, con proyecciones ratificadas **BC-07** por rol/objeto. **No** se aprueban rutas de endpoints ni nombres de DTO físicos. |
| **ADR-B1-03** | **RATIFICADA** | **PostgreSQL** con referencia de laboratorio **17.11 MR-6** y migraciones versionadas (Flyway **candidato**, no instalación ya ejecutada). Partir del esquema MR-5 consolidado y aplicar F01 en orden verificado; mantener SQL histórico intacto, bases efímeras y ensayos de backup/restauración. No habilita producción ni actualización de datos reales. |
| **ADR-B1-04** | **RATIFICADA** | Estrategia de pruebas con **JUnit 5 / Spring Test / Testcontainers PostgreSQL y CI** como opciones tecnológicas del diseño, fixtures ficticios, API/E2E, concurrencia, rendimiento y trazabilidad CU→prueba→evidencia. No implica que esas herramientas ya estén configuradas ni que BC-06 haya pasado. |
| **ADR-B1-06** | **RATIFICADA** | Integraciones aisladas mediante adaptadores para **Mercado Pago, WhatsApp (proveedor aún por elegir) y OSRM**; mock/sandbox, gestión segura de credenciales, verificación de origen, idempotencia, recuperación y logs sanitizados. No habilita operaciones externas con efectos reales. |
| **ADR-B1-05** | **NO RATIFICADA COMO DISEÑO FÍSICO** | **Sujeta a CR específica** para S-01/F04. Las RD-F04-001..007 funcionales permanecen aprobadas; **no** se aprueba por inferencia inbox, tablas de eventos, columnas ni motor de sincronización. |

La ratificación corresponde **exactamente al nivel de detalle de las ADR candidatas**; decisiones técnicas aún presentadas allí como *candidatas* (Maven, Flyway, versiones concretas, DTO/endpoints y migraciones nuevas) **no se convierten automáticamente en hechos implantados**. Para precisarlas se emitirá ADR derivada durante B1, sin alterar la arquitectura ratificada.

## 3. Efectos sobre el gobierno de B0

- **G0-D02 (selección de ADR de arranque): RESUELTO POR ESTA RD** para cinco ADR; B1-05 queda diferida bajo [CR-B0-F04-001](CR_B0_F04_001_DISENO_FISICO_SINCRONIZACION_PENDIENTE_2026-10-29.md).
- Se mantienen **64 CU, 67 operaciones**, RD-B0-BC01/02/03/05/07 y matriz RBAC **0 P**; sin cambios de comportamiento.
- La autorización de arquitectura **no equivale a aprobar Gate G0**: integrar/ratificar versiones canónicas, revisar PR, aceptar alcance de backlog y cerrar los controles de G0 que correspondan.
- Se aprueba como regla de trabajo que la **implementación y su documentación operativa vivan en otro repositorio**, cuyo alta hará el responsable. Ver [política entre repositorios](RD_B0_SEPARACION_REPOSITORIOS_2026-10-29.md). Hasta esa alta, **no iniciar scaffold ni código de aplicación** en el repositorio actual ni crear otro por cuenta propia.

**Evidencia de implementación:** no existe todavía; las pruebas documentales B0 y MR-6 no prueban el backend, servicios, UI ni integración. **BC-06 sigue 0/18 ejecutadas.**
