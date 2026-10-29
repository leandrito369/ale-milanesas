# B0.5 / E02 — ADR candidatas y decisiones de arquitectura para G0

**Fecha:** 29/10/2026 · **Estado:** 6 **PROPUESTAS TÉCNICAS PARA RATIFICACIÓN**; ninguna se presenta como aprobación del responsable. Permanecen sujetas a revisión de diseño DS/contrato y compatibilidad con instalación académica. No se ejecuta código ni SQL.

| ADR | Decisión candidata y alcance | Alternativa considerada | Riesgo / prueba de aceptación | Estado |
|---|---|---|---|---|
| **ADR-B1-01** | **Monolito modular Java/Spring Boot** y una única base PostgreSQL; **7 módulos** lógicos según arquitectura B0, con 12 subdominios internos, **no** 12 microservicios. Propuesta de herramienta de build: Maven (no ratificada); fijar JDK/Spring compatible en B1. | Microservicios o monolito sin fronteras. | Estructura reproducible, compilación, reglas de dependencia de módulos y contrato de transacción claro | **PENDIENTE_APROBACION** |
| **ADR-B1-02** | Web servidor Thymeleaf; Android Kotlin/Room para movilidad; API HTTP/JSON tipada para operaciones autorizadas y errores formales, con proyección BC07 por rol/objeto. Identidad del lado servidor y sesiones revocables. **No fijar endpoints concretos aquí.** | SPA+API completa o UI acoplada a DB. | Pruebas RBAC negativas/positivas, cliente online OTP ≠ Usuario interno; autenticación contextual | **PENDIENTE_APROBACION** |
| **ADR-B1-03** | PostgreSQL 17 como referente del laboratorio MR6, **migraciones versionadas** (Flyway candidato) desde MR5 consolidado + parche F01 en orden probado, sin alterar scripts históricos; bases efímeras, backup/restore y plan rollback. | Ejecutar DDL histórico a mano en producción. | Instalación desde cero y migración de ensayo reproducibles y sin diferencias estructurales; no producción | **PENDIENTE_APROBACION** |
| **ADR-B1-04** | JUnit5/Spring Test + Testcontainers PostgreSQL y CI (candidatos), fixtures ficticios, tests API/E2E, concurrencia, rendimiento, regresión, reporte por CU. | Pruebas solo manuales y tests sobre mocks de DB. | CI levanta app+BD efímeras; trazabilidad CU→test, resultados y locks reales | **PENDIENTE_APROBACION** |
| **ADR-B1-05** | **F04 S-01 propuesta**: cola Room, UUID origen estable, ingreso/deduplicación transaccional en API, pago en tránsito/rendición separados de COBRO y Caja hasta conciliación. **Requiere CR explícita si se agregan tablas/columnas, sin aprobar esquema ahora.** | Procesar petición repetida sin inbox ni reconocimiento de resultados. | Reenvío duplicado, red intermitente, reasignación revocada, pago en tránsito sin Caja, conciliación | **PENDIENTE_DISENO_CR_FISICO** |
| **ADR-B1-06** | Integraciones externas en adaptadores aislados de dominio (Mercado Pago, WhatsApp proveedor por decidir, OSRM), mock/sandbox, secretos fuera de Git, verificación origen, reintentos idempotentes y logging sin datos personales. | SDK/proveedor usado directamente por controlador o servicio de dominio. | Doble webhook sin doble asiento, simulación error proveedor, OSRM degradado sin romper entrega | **PENDIENTE_APROBACION** |

## Límites de ratificación

- Adoptar una ADR **no** aprueba las APIs, nombres de clases, DTO, tablas nuevas o decisiones comerciales no citadas. Una ADR documenta una alternativa técnica seleccionada con fecha, autoridad y evidencia.
- **BC-07** sí está ratificada en su alcance de 15 proyecciones; no conceder campos nuevos por definición de DTO.
- Las decisiones de usuario sobre RBAC BC-01/02/03 y los 64 CU prevalecen.
- F04 funcional aprobado; **S-01 y persistencia no**. MR6 no autoriza migrar bases reales.
- El usuario/responsable debe aprobar expresamente el conjunto de ADR-B1-01/02/03/04/06 o sus ajustes; ADR-B1-05 queda como estudio/CR separado antes de I6/B7. Esto permite que la arquitectura inicial se cierre sin simular que el offline ya tiene diseño físico aprobado.

## Formato de aprobación posterior

Registrar un acta `RD_B0_ADR_ARQUITECTURA_APROBADA_YYYY-MM-DD.md` con **ADR, alternativa aceptada, autoridad, fecha, cambios y restricciones**, actualizar `AGENTS.md` y el Gate G0. **No marcar ADR aprobadas por el hecho de abrir esta PR.**
