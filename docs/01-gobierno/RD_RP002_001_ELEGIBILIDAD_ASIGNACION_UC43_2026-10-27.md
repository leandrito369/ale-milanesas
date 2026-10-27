# RD-RP002-001 — Elegibilidad para asignar y reasignar Pedidos (UC-43)

**Fecha:** 27/10/2026. **Estado funcional:** APROBADA expresamente por el responsable del proyecto. **Implementación/pruebas:** PENDIENTES.

## Reglas aprobadas

1. Solo se puede asignar un **Pedido en estado `PENDIENTE`**.
2. El **Repartidor** debe tener **cuenta habilitada** y el **Rol Repartidor** correspondiente.
3. Un Pedido no puede tener **dos asignaciones vigentes simultáneamente**.
4. Una reasignación debe **conservar el historial de asignaciones anteriores**.
5. No se puede asignar un nuevo Pedido a un **Repartidor deshabilitado**.
6. La asignación y la reasignación mediante **UC-43 se realizan exclusivamente online**.

Las seis reglas son las aprobadas por el usuario; no se crean restricciones adicionales por zona, capacidad, turno, itinerario ni horarios.

## Coherencia

- **RD-RP009-001:** UC-55 no puede deshabilitar un Repartidor que conserva Pedidos `PENDIENTES` asignados. Primero deben reasignarse mediante UC-43.
- **RD-F04-001:** UC-43 online; UC-03/05 admiten captura offline, validada posteriormente en servidor.
- **UC-05:** registrar Entrega exige comprobación de asignación vigente para el Repartidor correspondiente; no basta una asignación histórica.
- Los registros históricos de asignación no equivalen a asignaciones vigentes.
- **No se cambia** la numeración UC-01…64 ni se incorpora un estado nuevo a Pedido.

## Controles técnicos previstos (no implementados)

Aplicar las seis reglas en servidor con verificación de permisos, restricciones de unicidad/consistencia e integridad transaccional. Serializar la asignación y la deshabilitación de Repartidor para impedir que operaciones concurrentes de UC-43 y UC-55 dejen un Pedido asignado a una cuenta deshabilitada. Una colisión debe producir rechazo o conflicto explícito, no dos asignaciones vigentes.

No implica aprobación de estructura, índices o migración específica. Se requieren pruebas de concurrencia reales.

## Estado de RP-002

**Resuelto funcionalmente** para elegibilidad básica aprobada. El diseño físico, las verificaciones API y las pruebas siguen pendientes. Nuevas reglas de zonas, capacidad u horarios exigirán decisión separada.

**Trazabilidad:** RP-002, UC-43, UC-55, UC-05; RD-RP009-001 y RD-F04-001. [PR #9](https://github.com/leandrito369/ale-milanesas/pull/9).
