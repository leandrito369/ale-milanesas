# F04 — Análisis de sincronización offline (S-01)

**Fecha:** 26/10/2026. **Estado:** RD-F04-001 **APROBADA** para el alcance UC-03/05/43; diseño e implementación F04 todavía **PENDIENTES**.  
**Seguimiento:** [Issue #6](https://github.com/leandrito369/ale-milanesas/issues/6); [RD-F04-001](../01-gobierno/RD_F04_001_ALCANCE_OFFLINE_2026-10-26.md). El primer intento de crear un Issue devolvió HTTP 410; tras habilitar el servicio, se creó el Issue #6 correctamente.

## Fuentes vigentes

- `AGENTS.md`, `docs/ESTADO_ACTUAL.md`.
- `docs/05-modelo-relacional/MR5_CONTRATOS_SERVICIOS.md`, sección S-01.
- `docs/01-gobierno/RP_01_REGISTRO_PENDIENTES_v1.1_2026-10-25.md` (RP-003, RP-006, RP-007, RP-009).
- `docs/01-gobierno/RD_F01_ESTADOS_COBRO_2026-10-26.md`.
- **Decisión aprobada 26/10:** [RD-F04-001](../01-gobierno/RD_F04_001_ALCANCE_OFFLINE_2026-10-26.md): UC-03/UC-05 capturables offline; UC-43 exclusivamente online.
- MR4-F04: integración offline y verificación de permisos/snapshots todavía no implementadas.

## Reglas ya establecidas

1. La operación capturada debe poseer un identificador UUID inmutable, usuario autenticado, marca temporal, referencia al Pedido/asignación si corresponde, y condiciones e importes congelados.
2. Idempotencia de extremo a extremo: el mismo evento reintentado no genera dos Pedidos, Entregas, Cobros ni efectos Caja/Cuenta Corriente.
3. Validar habilitación, asignación, vigencias y autorización al aplicar la operación; conflicto explícito si cambian de forma incompatible. No conceder permisos retroactivos.
4. El Repartidor no obtiene permiso directo para UC-29 por registrar una Entrega; los cobros de efectivo requieren registro/conciliación por actor autorizado.
5. `COBRO.estadoCobro` tiene solamente `CONFIRMADO` y `ANULADO`, conforme a RD-F01. Una captura offline pendiente de sincronizar permanece fuera de COBRO y no materializa efectos financieros.
6. La persistencia de eventos de entrada, snapshots y conciliación es una **brecha de implementación**. MR-6 validó restricciones físicas seleccionadas, no un servicio offline.

## Matriz de alcance — decisión funcional aprobada (RD-F04-001)

| CU | Evento | Estado de captura | Aplicación central y límites |
|---|---|---|---|
| UC-03 | Cargar Pedido | **OFFLINE PERMITIDA** | Se registra como captura local pendiente; el servidor debe revalidar permiso, datos y condiciones antes de confirmar. Conflictos de stock, precios o vigencia se tratan explícitamente; la política detallada sigue pendiente. |
| UC-05 | Registrar Entrega | **OFFLINE PERMITIDA** | Se registra captura local pendiente; solo el servidor confirma la aplicación tras validar Pedido y asignación. No implica registrar Cobro. |
| UC-29 | Registrar Cobro | **NO DEFINIDA por RD-F04-001** | Se conserva el RBAC existente: Repartidor sin permiso directo. El Administrador recibe y autoriza la rendición de efectivo (RD-F04-002). Si hay diferencias, el Administrador las registra y deja la rendición pendiente de conciliación, sin confirmar importes no recibidos. Evidencias y permisos generales UC-29 pendientes (RP-006/RP-007). |
| UC-43 | Gestionar asignación de reparto | **EXCLUSIVAMENTE ONLINE** | La creación, cambio y reasignación necesitan conectividad con servidor; no se autorizan colas de asignación offline. |

## Escenarios obligatorios de diseño y prueba

- **Doble envío:** mismo UUID en dos sesiones simultáneas ⇒ una aplicación monetaria.
- **Pérdida de conexión:** respuesta perdida tras COMMIT ⇒ reintento devuelve resultado original sin efectos duplicados.
- **Conflicto de permisos:** usuario deshabilitado o Rol revocado durante desconexión ⇒ no se confirma silenciosamente.
- **Cambio de asignación:** Repartidor anterior sincroniza una Entrega después de la reasignación ⇒ conflicto y conciliación, sin permitir entrega duplicada.
- **Cambios históricos:** precio/categoría/promoción actualizados luego de captura válida ⇒ no sustituir instantáneas aprobadas.
- **Falla parcial:** error entre Pedido, Cobro, Caja o Cuenta Corriente ⇒ rollback de efectos inseparables.
- **Mensajes tardíos/fuera de orden:** estados divergentes ⇒ respuesta explícita y auditoría; no procesar por fecha local como única fuente de verdad.

## Cuestiones [A CONFIRMAR] con usuario

1. **RP-006 (parcialmente resuelto):** el **Administrador recibe la rendición, que ocurre al finalizar cada recorrido de reparto, y autoriza su registro** (RD-F04-002). Las diferencias se registran y la rendición permanece pendiente de conciliación, sin confirmar un Cobro por efectivo no recibido. Falta definir evidencia y resolución detallada.
2. **RP-007:** ¿ratificar acceso directo a UC-29 solo para Administrador y Vendedor?
3. ¿Una operación capturada antes de revocar un permiso puede aceptarse después, o debe ir siempre a revisión?
4. ¿Qué plazo/retención aplica a eventos pendientes? Sin valor predeterminado aprobado.

**RP-006 — responsabilidad aprobada por [RD-F04-002](../01-gobierno/RD_F04_002_RENDICION_EFECTIVO_2026-10-26.md):** solo el Administrador recibe y autoriza el registro de rendiciones de efectivo del Repartidor. El momento es el final de cada recorrido; si hay diferencias se registran y la rendición queda pendiente de conciliación, sin confirmar automáticamente Cobros por importes no recibidos. Falta definir comprobantes y mecanismo de resolución.

**RP-003 — decisión de alcance cerrada por RD-F04-001:** UC-03 y UC-05 admiten captura offline; UC-43 requiere conexión. La política operativa de conflictos continúa pendiente.

## Diseño técnico siguiente, condicionado a decisiones

- Proponer contrato `POST /sincronizaciones` con UUID de operación, payload versionado, actor, referencia, instantánea y respuesta estable de éxito/conflicto/reintento.
- Evaluar inbox persistente, esquema de deduplicación, bitácora de errores y estados de sincronización **sin confundirlos con estados de COBRO**.
- Definir orden de bloqueos y atomicidad con transacciones; verificar RBAC a nivel API.
- Preparar pruebas de integración con conectividad intermitente, concurrencia y rollback.

**RD-F04-001 fue aprobada exclusivamente sobre modalidades de captura. No se aprueba en este documento ninguna migración, nueva tabla ni permiso adicional.**
