# RD-F04-001 — Alcance de captura offline de pedidos y entregas

**Proyecto:** Sistema de Gestión para Ale Milanesas  
**Fecha de aprobación:** 26/10/2026  
**Autoridad:** decisión explícita del responsable del proyecto en la conversación de trabajo.  
**Estado funcional:** **APROBADA**.  
**Estado de implementación:** **PENDIENTE**; no hay servicio offline implementado ni pruebas de integración de red.

## Decisión

1. **UC-03 — Cargar Pedido:** se autoriza la **captura local sin conexión**. La operación solo se considera aplicada al sistema central cuando el servidor la recibe, valida y confirma. La captura local no garantiza por sí misma aceptación, reserva de inventario ni impacto financiero.
2. **UC-05 — Registrar Entrega:** se autoriza la **captura local sin conexión**. La entrega informada offline no se considera aplicada/confirmada en el servidor hasta su validación; no equivale por sí misma a registrar un Cobro.
3. **UC-43 — Asignación de reparto:** se exige **conexión al servidor** para crear o modificar asignaciones de reparto. No se autoriza la asignación ni reasignación offline.
4. No se modifica la decisión **RD-F01**: `COBRO.estadoCobro` conserva solo `CONFIRMADO` y `ANULADO`; las operaciones pendientes de sincronización permanecen fuera de `COBRO`.

## Alcance excluido / decisiones aún no tomadas

- **UC-29 Registrar Cobro:** esta decisión **no habilita** un nuevo flujo de cobro offline ni concede permiso directo a Repartidor.
- **RP-006:** la rendición de efectivo transportado por el Repartidor, sus responsables y el momento de conciliación siguen **[A CONFIRMAR]**.
- **RP-007:** la matriz de permisos de UC-29 sigue **[A CONFIRMAR]**.
- Si hubo revocación de roles, reasignación o cancelación durante la desconexión, la operación requiere validación central y manejo explícito de conflictos; la política definitiva de conciliación no se inventa.
- Retención, caducidad, reintentos de cola, identificación de operación, contrato API e inbox transaccional continúan en especificación técnica.

## Restricciones previas que permanecen vigentes

- `AGENTS.md`; S-01 de `MR5_CONTRATOS_SERVICIOS.md`; RD-F01.
- Idempotencia por identificador de origen, trazabilidad de identidad, preservación de instantáneas históricas y prohibición de doble efecto monetario.
- No existe permiso automático de UC-29 para Repartidor.
- Los 64 CU conservan su numeración; no se introduce un nuevo CU de sincronización por esta aprobación.

## Propagación y trazabilidad

- **F04 / MR4-F04**, **RP-003:** la pregunta **sobre alcance de captura de UC-03/05 y exclusividad online de UC-43 queda resuelta** por esta RD. Otros puntos de RP-003 relacionados con concurrencia y aplicación central requieren diseño/pruebas.
- **RP-006**, **RP-007**, **RP-009:** siguen abiertos.
- **UC afectados:** UC-03, UC-05 y UC-43; UC-29 solo como restricción de alcance y permisos.
- [Documento F04 de análisis](../06-arquitectura/F04_ANALISIS_SINCRONIZACION_OFFLINE_2026-10-26.md).
- [Issue #6 — registro de seguimiento](https://github.com/leandrito369/ale-milanesas/issues/6).
- [PR #5 — documentación en revisión](https://github.com/leandrito369/ale-milanesas/pull/5).

**No se aprueba en esta RD ninguna alteración física del modelo relacional, nueva tabla, migración ni cambio de RBAC.**
