# F04 — Análisis de sincronización offline (S-01)

**Fecha:** 26/10/2026. **Estado:** ANÁLISIS / PROPUESTA; sin servicio implementado ni decisión nueva de negocio aprobada.  
**Motivo:** el usuario autorizó avanzar con F04 después de aprobar F01. En este repositorio, GitHub Issues está deshabilitado (HTTP 410), por lo que el registro de pendientes se versiona mediante este PR.

## Fuentes vigentes

- `AGENTS.md`, `docs/ESTADO_ACTUAL.md`.
- `docs/05-modelo-relacional/MR5_CONTRATOS_SERVICIOS.md`, sección S-01.
- `docs/01-gobierno/RP_01_REGISTRO_PENDIENTES_v1.1_2026-10-25.md` (RP-003, RP-006, RP-007, RP-009).
- `docs/01-gobierno/RD_F01_ESTADOS_COBRO_2026-10-26.md`.
- MR4-F04: integración offline y verificación de permisos/snapshots todavía no implementadas.

## Reglas ya establecidas

1. La operación capturada debe poseer un identificador UUID inmutable, usuario autenticado, marca temporal, referencia al Pedido/asignación si corresponde, y condiciones e importes congelados.
2. Idempotencia de extremo a extremo: el mismo evento reintentado no genera dos Pedidos, Entregas, Cobros ni efectos Caja/Cuenta Corriente.
3. Validar habilitación, asignación, vigencias y autorización al aplicar la operación; conflicto explícito si cambian de forma incompatible. No conceder permisos retroactivos.
4. El Repartidor no obtiene permiso directo para UC-29 por registrar una Entrega; los cobros de efectivo requieren registro/conciliación por actor autorizado.
5. `COBRO.estadoCobro` tiene solamente `CONFIRMADO` y `ANULADO`, conforme a RD-F01. Una captura offline pendiente de sincronizar permanece fuera de COBRO y no materializa efectos financieros.
6. La persistencia de eventos de entrada, snapshots y conciliación es una **brecha de implementación**. MR-6 validó restricciones físicas seleccionadas, no un servicio offline.

## Matriz inicial de operaciones (NO autorización implícita)

| CU | Evento | Criterio actual | Límite / decisión pendiente |
|---|---|---|---|
| UC-03 | Cargar Pedido | La documentación S-01 prevé ID de operación, instantánea y validación al sincronizar | Definir exactamente si captura offline está habilitada y qué ocurre con stock/precio/permisos modificados |
| UC-05 | Registrar Entrega | Requiere Pedido y asignación legítima; la entrega no equivale a Cobro | Definir momento de confirmación del servidor, rechazo por reasignación y conflictos con entrega/cancelación |
| UC-29 | Registrar Cobro | RBAC: Repartidor sin permiso directo; CONFIRMADO solo tras operación validada | Definir rendición de efectivo, responsable, conciliación y secuencia offline |
| UC-43 | Gestionar asignación de reparto | RP-003 no ratifica asignación offline | Decidir si UC-43 exige conectividad continua o qué resolución de colisiones se acepta |

## Escenarios obligatorios de diseño y prueba

- **Doble envío:** mismo UUID en dos sesiones simultáneas ⇒ una aplicación monetaria.
- **Pérdida de conexión:** respuesta perdida tras COMMIT ⇒ reintento devuelve resultado original sin efectos duplicados.
- **Conflicto de permisos:** usuario deshabilitado o Rol revocado durante desconexión ⇒ no se confirma silenciosamente.
- **Cambio de asignación:** Repartidor anterior sincroniza una Entrega después de la reasignación ⇒ conflicto y conciliación, sin permitir entrega duplicada.
- **Cambios históricos:** precio/categoría/promoción actualizados luego de captura válida ⇒ no sustituir instantáneas aprobadas.
- **Falla parcial:** error entre Pedido, Cobro, Caja o Cuenta Corriente ⇒ rollback de efectos inseparables.
- **Mensajes tardíos/fuera de orden:** estados divergentes ⇒ respuesta explícita y auditoría; no procesar por fecha local como única fuente de verdad.

## Cuestiones [A CONFIRMAR] con usuario

1. **RP-003:** ¿qué UC se podrán capturar sin internet y UC-43 deberá ser exclusivamente online?
2. **RP-006:** ¿quién recibe la rendición del efectivo transportado por Repartidor, cuándo confirma y qué evidencia deja?
3. **RP-007:** ¿ratificar acceso directo a UC-29 solo para Administrador y Vendedor?
4. ¿Una operación capturada antes de revocar un permiso puede aceptarse después, o debe ir siempre a revisión?
5. ¿Qué plazo/retención aplica a eventos pendientes? Sin valor predeterminado aprobado.

## Diseño técnico siguiente, condicionado a decisiones

- Proponer contrato `POST /sincronizaciones` con UUID de operación, payload versionado, actor, referencia, instantánea y respuesta estable de éxito/conflicto/reintento.
- Evaluar inbox persistente, esquema de deduplicación, bitácora de errores y estados de sincronización **sin confundirlos con estados de COBRO**.
- Definir orden de bloqueos y atomicidad con transacciones; verificar RBAC a nivel API.
- Preparar pruebas de integración con conectividad intermitente, concurrencia y rollback.

**No se aprueba en este documento ninguna migración, nueva tabla o permiso.**
