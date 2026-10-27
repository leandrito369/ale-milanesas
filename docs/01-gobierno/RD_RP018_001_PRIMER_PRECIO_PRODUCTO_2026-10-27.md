# RD-RP018-001 — Primer precio e historial de precios de Producto

**Fecha:** 27/10/2026. **Estado:** APROBADA funcionalmente por el responsable. **Implementación y pruebas:** pendientes.

## Cinco reglas aprobadas

1. Un Producto nuevo **puede registrarse sin precio vigente**, pero **no puede comercializarse** hasta disponer de uno válido.
2. El **primer precio** se registra por **UC-19 — Actualizar Precio Vigente**.
3. Para cada Producto existe **como máximo un precio vigente en un mismo instante**.
4. Toda actualización de precio **preserva el precio anterior y su período de vigencia**.
5. Un cambio de precio **no modifica los importes de Pedidos ya confirmados**.

## Alcance y requisitos de coherencia

- El registro de Producto como maestro (UC-30) y su habilitación para comercialización son hechos distintos: carecer de precio no significa inventar un valor inicial.
- Los períodos de precios no deben solaparse de modo que existan dos valores simultáneamente vigentes para un mismo Producto.
- Se preservan las instantáneas comerciales de los Pedidos y sus ajustes/promociones aplicados; no recalcular importes históricos.
- No se aprueba automáticamente un nuevo literal de estado de Precio, columna, tabla o migración SQL; la enumeración física exacta debe contrastarse con el modelo vigente.
- La condición de precio válido se verificará en el servidor en operaciones de comercialización y también al validar capturas offline.

## Trazabilidad

RP-018; UC-19, UC-20, UC-30, UC-03, UC-21; MR-3/MR-5; RD-F04-001 y RD-F04-007.

**Pendiente técnico:** validación de primer precio, períodos sin solapamiento y concurrencia; servicio y pruebas de no retroactividad.
