# RD-F04-006 — Uso del saldo exigible provisional al evaluar deuda para nuevos Pedidos

**Fecha:** 26/10/2026. **Estado funcional:** **APROBADA**. **Estado técnico:** pendiente de diseño físico, API y pruebas.  
**Autoridad:** aprobación explícita del responsable del proyecto en la conversación F04.

## Regla aprobada

Cuando el sistema evalúe la **deuda del Cliente para cargar un nuevo Pedido**, utilizará el **saldo exigible provisional** ya definido en RD-F04-003. Este saldo contempla exclusivamente pagos en tránsito **sincronizados y validados por el servidor**, sin modificar el saldo contable confirmado de `MOVIMIENTO_CUENTA` ni originar entradas en `MOVIMIENTO_CAJA`.

La **categoría comercial** de `CLIENTE` (`CUMPLIDOR`/`EN_MORA`) se mantiene **separada**. La evaluación de deuda con pagos provisionales **no actualiza ni recategoriza automáticamente** al Cliente.

La decisión se aplica a la verificación de deuda del flujo de nuevos Pedidos; **no constituye autorización para omitir otras condiciones** de admisión (por ejemplo, Cliente inactivo), ni aprueba un nuevo criterio de descuento/recargo. La política de ajustes comerciales por categoría se conserva hasta nueva decisión.

## Precondiciones y consistencia

- El cálculo debe realizarse **en servidor**, con un conjunto de pagos en tránsito vigentes validados e identificados de forma idempotente. Cada pago se descuenta provisionalmente una sola vez.
- Las capturas aún almacenadas únicamente en dispositivos offline **no alteran la consulta ni la elegibilidad central**. Para UC-03 capturado offline, la evaluación central debe repetirse al sincronizar.
- Al convertirse un pago en tránsito en Cobro definitivo, retirar su contribución provisional de forma atómica con la contabilización definitiva; **no duplicar descuento**.
- Una rendición pendiente de conciliación por diferencia conserva el reconocimiento provisional aprobado en RD-F04-005, sin reintegrar automáticamente como exigible al Cliente el importe validado.
- Al aceptar el nuevo Pedido, conservar las condiciones comerciales históricas aplicadas al Pedido según las reglas ya vigentes. No recalcular importes de Pedidos históricos.

## Alcance que esta aprobación NO determina

1. **Umbrales de deuda, condiciones particulares de bloqueo y prioridad de reglas:** permanecen sujetos a las políticas existentes; no se inventan límites ni se aprueba automáticamente cualquier nuevo Pedido por tener saldo exigible provisional igual a cero.
2. **Categoría y precios del nuevo Pedido:** mantener separada `CLIENTE.categoriaComercial` y las reglas de ajustes vigentes; no suponer que cubrir provisionalmente deuda concede categoría `CUMPLIDOR`. Conviene evaluar en una decisión posterior si se quiere mantener o revisar el ajuste por categoría cuando hay pago en tránsito.
3. **Saldos negativos, excedentes, pagos parciales y disputas:** requieren detalle funcional y técnico propio. No introducir crédito definitivo por pagos sin rendir.
4. **Alcance físico/endpoint:** ninguna tabla, columna, índice, trigger o migración aprobada implícitamente.

## Pruebas requeridas para implementación

- Deuda confirmada positiva + pago en tránsito validado, sin movimiento contable: la evaluación de deuda del nuevo Pedido utiliza saldo exigible provisional.
- Evento solo local o rechazado: no altera evaluación central.
- Evento duplicado o rendición simultánea: no doble reducción de deuda.
- Cliente `EN_MORA` con deuda provisional cubierta: la categoría no cambia automáticamente, y el ajuste comercial aplicable se evalúa según regla vigente distinta de esta decisión.
- Pedido offline sincronizado luego de cambios de permisos o pagos: el servidor revisa condiciones actuales y aplica manejo de conflictos sin alterar instantáneas históricas.

## Trazabilidad

F04 / RP-003 / UC-03, UC-05 (declaración) y UC-16/17 (categoría y ajustes, sin modificar alcance); referencia a UC-22 solo cuando reutilice la misma evaluación de deuda, sujeto a coherencia de su flujo.

RD-F01, RD-F04-001 (captura offline), RD-F04-002 (rendición), RD-F04-003 (saldo provisional), RD-F04-004 (declaración), RD-F04-005 (diferencia pendiente).

[PR #5](https://github.com/leandrito369/ale-milanesas/pull/5) · [Issue #6](https://github.com/leandrito369/ale-milanesas/issues/6).

**Esta RD no significa que el servicio exista, que el SQL se haya migrado o que las pruebas estén ejecutadas.**

## Actualización RD-F04-007 — ajuste EN_MORA aprobado

El ajuste de precio de la categoría `EN_MORA` **permanece vigente hasta la reevaluación formal de la categoría**, incluso cuando un pago en tránsito ya validado reduce a cero el saldo exigible provisional. La evaluación de deuda del nuevo Pedido usa dicho saldo provisional; el ajuste comercial utiliza la categoría vigente, sin suspensión de recargo ni reclasificación automática. Ver [RD-F04-007](../01-gobierno/RD_F04_007_AJUSTE_EN_MORA_PAGO_TRANSITO_2026-10-26.md). No se alteran porcentajes ni políticas históricas.
