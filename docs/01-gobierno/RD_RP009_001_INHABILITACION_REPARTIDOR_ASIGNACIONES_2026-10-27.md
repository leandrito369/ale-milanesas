# RD-RP009-001 — Deshabilitación de Repartidor con Pedidos asignados

**Fecha:** 27/10/2026. **Estado funcional:** APROBADA expresamente por el responsable del proyecto. **Implementación y pruebas:** pendientes.

## Decisión aprobada

1. El sistema **impide ejecutar UC-55 para deshabilitar la cuenta de un Repartidor mientras tenga Pedidos PENDIENTES asignados**.
2. Debe informar al Administrador cuáles son esos Pedidos pendientes vinculados a la asignación vigente.
3. El Administrador debe **reasignar esos Pedidos mediante UC-43**, que requiere conectividad (RD-F04-001).
4. Únicamente cuando no queden Pedidos PENDIENTES asignados al Repartidor podrá confirmarse su deshabilitación.
5. Las asignaciones y Entregas ya realizadas conservan su historial; no se borran registros ni se modifican Pedidos entregados.

## Salvaguardas técnicas necesarias (propuesta de implementación)

- Comprobar las asignaciones **vigentes**, no cualquier asignación histórica, al decidir si hay bloqueo.
- Revalidar la ausencia de Pedidos pendientes en la **misma transacción** que deshabilita al Usuario, con bloqueo/serialización compatible con UC-43 para impedir asignaciones concurrentes.
- Deshabilitar efectivamente y revocar sesiones según contrato de cuentas S-04, sin conceder permiso de reasignación por el hecho de poder administrar Usuarios.
- Rechazar una operación intentada offline: UC-43 permanece online y el estado central es autoritativo.

## Trazabilidad

RP-009; UC-55, UC-43, UC-05; RD-F04-001; contratos S-01/S-04; F07/F09. Preservar los 64 CU y el modelo relacional aprobado.

No se establece una reasignación automática, un plazo ni una categoría nueva de estado de Pedido; tampoco se aprueba una migración SQL concreta. Las salvaguardas técnicas requieren pruebas de API y concurrencia antes de declarar implementación completa.
