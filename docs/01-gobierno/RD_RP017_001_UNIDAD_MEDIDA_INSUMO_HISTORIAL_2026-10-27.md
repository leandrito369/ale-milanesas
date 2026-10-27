# RD-RP017-001 — Modificación de unidad de medida de Insumo con historial

**Fecha:** 27/10/2026. **Estado funcional:** APROBADA por el responsable. **Implementación/pruebas:** PENDIENTES.

## Cuatro reglas aprobadas

1. La **unidad de medida** de un Insumo puede modificarse mientras **no tenga movimientos de inventario ni registros históricos de costos**.
2. Cuando exista **al menos un movimiento o registro histórico de costo**, su unidad de medida **queda bloqueada**.
3. Para trabajar con una unidad diferente en ese supuesto, debe registrarse un **nuevo Insumo**, conservando el anterior y todo su historial.
4. Mediante UC-51 pueden seguir modificándose **descripción y otros datos no históricos**, sujetos a sus permisos y validaciones.

## Límites e invariantes

- No convertir retrospectivamente cantidades ni costos ni reescribir movimientos anteriores.
- El nuevo Insumo es un registro independiente: esta RD no autoriza transferencias automáticas de stock, duplicación ficticia de existencias o sustitución silenciosa de referencias históricas.
- Validar el bloqueo en servidor de forma consistente con transacciones de inventario y costo concurrentes; una verificación visual de formulario no basta.
- No inferir qué otros campos son editables: se respetan restricciones existentes y UC-51.
- No se modifican los 64 CU, estados, estructura SQL o diagrama por esta ratificación.

## Trazabilidad

RP-017, UC-51, UC-50, UC-42, RD-RP016-001, MR-5/MR-6.

**Estado del pendiente:** regla funcional resuelta. Pendiente implementar validaciones de servicio y pruebas de concurrencia/historial.
