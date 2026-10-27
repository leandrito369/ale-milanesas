# RD-RP020-001 — Reprogramación de fecha de reparto

**Fecha:** 27/10/2026. **Estado funcional:** APROBADA expresamente por el responsable. **Implementación/pruebas:** PENDIENTES.

## Reglas ratificadas

1. Solo puede reprogramarse un **Pedido en estado `PENDIENTE`**.
2. Reprogramar requiere un **Usuario interno autorizado**; el Cliente ONLINE **no modifica directamente** la fecha.
3. El servidor valida la nueva fecha con los criterios de admisibilidad aplicables a un Pedido nuevo (RD-RP001/RP019).
4. Si el Pedido tiene Repartidor asignado, la reprogramación **invalida la asignación vigente** y requiere una nueva asignación por **UC-43**, exclusivamente online.
5. Se conserva el **historial de fecha anterior, identidad de quien cambió la fecha y momento del cambio**.
6. No se alteran importes, promociones ni condiciones comerciales históricas del Pedido.

## Integración y controles previstos, todavía no implementados

- Reprogramación y cierre de asignación vigente deben ser **atómicos** para evitar que un Pedido con fecha cambiada conserve accidentalmente la asignación anterior.
- UC-43 debe revalidar estado de Pedido, habilitación/rol de Repartidor y unicidad de asignación vigente (RD-RP002-001).
- UC-05 debe validar asignación actual. Una captura offline hecha con asignación invalidada no obtiene aceptación automática al sincronizar (RD-F04-001).
- El **modelo técnico de historial de fechas y asignaciones** debe contrastarse con el modelo relacional vigente; esta decisión no autoriza automáticamente columnas o tablas adicionales.
- El alcance concreto de «Usuario interno autorizado» se decidirá en la matriz RBAC; **no se asigna un nuevo permiso nominal por inferencia**.

## Trazabilidad

RP-020; UC-03, UC-05, UC-21, UC-43; RD-RP001/RP019, RD-RP002-001, RD-RP009-001 y RD-F04-001.

No se modifica la numeración de 64 CU, los estados de Pedido ni las reglas comerciales. No se ejecutaron migraciones ni pruebas.
