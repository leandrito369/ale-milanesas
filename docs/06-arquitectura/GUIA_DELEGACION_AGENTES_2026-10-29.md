# Guía para delegar desarrollo a agentes IA (Antigravity, OpenCode y equivalentes)

**Fecha:** 29/10/2026 · **Carácter:** instrucciones de trabajo delegadas aprobables, subordinadas a decisiones funcionales del proyecto.  
**Marco rector:** `../01-gobierno/PLAN_RECTOR_IMPLEMENTACION_2026-10-29.md` y `AGENTS.md`. Ninguna herramienta externa posee autoridad para inventar reglas de negocio.

## 1. Principio de fidelidad metodológica

Seguir Proceso Unificado adaptado, iteración por CU/operación, UML/Larman, contratos de operaciones y pruebas. La cadena debe conservar:
**Objetivo/RF/RNF → CU vigente (Alto/Extendido/Real) → DSS → DS → contrato (pre/post/invariantes) → clase/servicio → persistencia/API/UI → test + evidencia**.

Una clase, nombre de método, endpoint o tabla es **propuesta técnica** hasta su cotejo con el contrato. Un CU diseñado no está «implementado» por tener archivos generados. Si falta la fuente, detener solo la tarea afectada y abrir RP/Issue.

## 2. ¿Qué delegar y a quién?

| Trabajo delegable | Tipo de agente sugerido | Resultado exigido | Supervisión |
|---|---|---|---|
| Inventario de 64 CU, DSS/DS/contratos, traza y dependencias | OpenCode/Antigravity en modo análisis | Matriz + brechas con rutas exactas | Revisión humana de excepciones |
| Scaffold Spring Boot, carpetas de módulos, Docker dev, CI | OpenCode o agente programador | PR pequeña con build/tests ejecutables | ADR previa si hay decisiones arquitectónicas |
| PostgreSQL: migraciones desde MR-5/F01 sin modificar históricos; pruebas | Agente backend/SQL | Diff, migración, rollback y CI PostgreSQL | CR + revisión SQL y seguridad |
| Servicios de aplicación, controladores, DTO y repositorios | Agente backend | Contrato→método→test, API/RBAC | Revisar transacciones, idempotencia y fuentes |
| UI web/Android, navegación, accesibilidad | Antigravity o agente UI | Capturas/artefactos más E2E y rutas CU | Verificar que no cambie reglas |
| Room/offline y resolución de conflictos | Agente Android/backend coordinados | Suite de reintentos, deduplicación y conciliación | Bloqueada por F04 técnico a ratificar |
| Mercado Pago, WhatsApp, OSRM | Agente de integraciones | Adaptadores con mocks/sandbox, logs sanitizados | Sin producción/credenciales reales |
| Pruebas y revisión independiente | OpenCode subagente auditor u otra IA | Fallos por severidad, archivo/línea, test reproducible | Integrador humano acepta o devuelve |
| Manuales, matrices y paquetes para defensa | Agente documental | Fuentes, trazabilidad y diferencias | Validación del negocio/cátedra |

La herramienta es intercambiable; el **contrato de trabajo del repositorio** manda, no las convenciones implícitas de un producto.

## 3. Límites de autonomía

**Delegado sin nueva decisión de negocio:** documentación de trazabilidad, pruebas reproducibles, scaffolding, refactor interno que preserve comportamiento, implementación de contrato aprobado, mocks, validación de compilación/CI. Siempre rama y PR.

**Exige consulta y CR/RD/ADR antes del cambio:** nuevas columnas/tablas, alterar 60/453/125, migraciones irreversibles, ajustar pre/postcondiciones, cambiar actores/RBAC, números de CU, porcentajes, redondeo, políticas de negocio, estados, exclusión de requisitos o integraciones con efectos reales. Los detalles técnicos que no afecten negocio pueden proponerse como ADR para ratificación en B0/B1.

**Prohibido sin autorización operativa específica:** push a `main`, merge automático, migración a BD real, despliegue a producción, pagos o reembolsos reales, envíos reales a Clientes, exponer credenciales/datos privados, borrar historial aprobado, declarar pruebas no ejecutadas.

## 4. Protocolo de asignación de una tarea

Cada encargo/Issue o PR de agente debe incluir:
1. **ID y alcance:** Bx/WBS, CU, operación contractual, objetivo y archivos permitidos/vedados.
2. **Fuentes canónicas:** enlaces/rutas y corte; `AGENTS.md` → `docs/ESTADO_ACTUAL.md` → RD/RP más recientes → CU/DSS/DS/contrato → MR5/MR6.
3. **Condiciones:** pre/post, invariantes, casos alternativos, Roles, transacciones, idempotencia y no funcionales.
4. **Entregables:** archivos, tests, migración si corresponde, documentación y matriz de trazabilidad actualizada.
5. **Cómo probar:** comandos reales al disponer de build, datos iniciales ficticios, resultado esperado, límites de pruebas/no ejecutadas.
6. **Cierre:** diff, evidencia, decisiones solicitadas, hallazgos y siguiente dependencia; pedir revisión humana.
7. **Instrucción segura:** no inventar fuentes ni desplazar un CU para ajustar un diseño técnico.

### Plantilla de prompt de trabajo

> Trabajá en `leandrito369/ale-milanesas`, rama específica + PR. Leé `AGENTS.md`, `docs/ESTADO_ACTUAL.md`, protocolo y plan rector. Encargo: **[ID B0/WBS o CU]**. Fuente de contrato: **[ruta verificable]**; archivos permitidos: **[...]**. Primero proponé un mapa CU→DS→operaciones→servicios→DB→pruebas y señalá faltantes. No cambies reglas, estados, permisos ni esquema sin CR/ADR y aprobación. Implementá solo lo que esté aprobado, con pruebas y logs reales (o marcá NO EJECUTADO). Entregá PR con alcance, diff, evidencia, riesgos y pendientes. No tocar `main` ni entornos productivos.

## 5. Acuerdos de arquitectura para agentes

- Preferir monolito modular; separar **dominio / aplicación / puertos y adaptadores / HTTP e interfaces / persistencia**. No acoplar reglas al controlador ni a una vista.
- Reutilizar operaciones compartidas; no crear un servicio/microservicio por cada CU. Clases de dominio ≠ tablas físicas; el modelado conceptual no se copia de 60 relaciones.
- SQL MR-3/MR-5 y scripts MR-6 son evidencia histórica: **no editar in situ**. Nueva migración o test en ruta/versionado propio y CI aislado.
- Para operaciones monetarias, compras, stock y sincronización, **definir transacción y locking**; rollback íntegro; deduplicación en reintento; no «arreglar» excepciones ignorándolas.
- Autorización en servidor por identidad y Rol actuales; no confiar en `idUsuario` de payload, rol/UI o dispositivo.
- F04: UC-03/05 offline donde aprobados, asignación/reasignación online; declaración de efectivo UC-05 ≠ COBRO confirmado; pago en tránsito afecta exigibilidad provisional sin Caja; rendición exige Administrador. No derivar permiso de UC-29 para Repartidor.
- MR-6 prueba estructura y casos seleccionados de PostgreSQL, **no** funcionalidad integral. No suponer que F04/PRA-01/MercadoPago están implementados.

## 6. Integración con herramientas

**OpenCode:** reconoce instrucciones de proyecto en `AGENTS.md`; se incluye subagente de revisión `.opencode/agents/ale-revisor.md` (sin privilegios de edición). Usar agente de planificación primero, implementación después y auditoría independiente al finalizar.

**Antigravity:** reconoce `AGENTS.md` y reglas `.agents/rules/*.md`. Se incluye `.agents/rules/metodologia-ale.md` con activación `always_on`. Antes de editar, proporcionar el Issue y fuentes exactas; pedir plan, diff y evidencias del navegador/IDE si corresponde.

**Otros agentes:** leer los mismos archivos del repositorio; si no reconocen reglas automáticamente, suministrar explícitamente `AGENTS.md` y el Issue. **No** asumir sincronización automática entre conversaciones, servicios o herramientas; cada agente trabaja sobre un commit/base determinado.

Referencias técnicas de formatos: https://antigravity.google/docs/rules/ y https://dev.opencode.ai/v2/docs/instructions/ ; https://docs.opencode.ai/docs/agents/.

## 7. Normas de PR, revisión y aceptación

- Una tarea acotada por rama/PR. Especificar base commit; conservar un solo integrador que revisa y fusiona tras controles. Evitar que dos agentes editen los mismos archivos maestros simultáneamente.
- PR debe indicar: objetivo, CU/contrato/RD/CR, fuentes, diff, pruebas realmente corridas, resultados, archivos no tocados, riesgos, cambios de seguridad, migración/rollback, pendiente de aprobación.
- Revisión independiente obligatoria de **dinero/stock/roles/offline/SQL**. Fallos críticos o falta de trazabilidad ⇒ no fusionar.
- Historial: toda mejora registra `APROBADO / PROPUESTO / IMPLEMENTADO / PROBADO / PENDIENTE` sin degradar evidencia MR-6.
