# RD-F04-007 — Ajuste comercial EN_MORA con pago en tránsito

**Fecha:** 26/10/2026. **Estado funcional:** APROBADA. **Implementación:** pendiente.

## Decisión

Cuando el Cliente tenga un pago en tránsito sincronizado y validado, el sistema utilizará el saldo exigible provisional para evaluar su deuda al cargar nuevos Pedidos, conforme a RD-F04-006. Sin embargo, **el ajuste de precio asociado a la categoría comercial EN_MORA se mantiene hasta que se realice la reevaluación formal de la categoría**.

El pago en tránsito **no suspende el recargo ni cambia automáticamente** `CLIENTE.categoriaComercial`. El Pedido nuevo conserva la categoría comercial aplicada y las condiciones de precio calculadas bajo las reglas vigentes; estas condiciones se congelan al confirmar válidamente el Pedido. Las condiciones históricas no se modifican después.

## Ejemplo funcional

Un Cliente con categoría `EN_MORA` tiene deuda confirmada, pero un pago en tránsito validado reduce su saldo exigible provisional a cero. Para evaluar la deuda del nuevo Pedido se utiliza ese saldo provisional. **Para determinar el ajuste comercial de precio se utiliza la categoría todavía vigente `EN_MORA`**. No se infiere una recategorización automática a `CUMPLIDOR`.

## Límites

- No se fija ni modifica porcentaje de recargo, descuento, umbral o criterio de reevaluación.
- No se autoriza al Repartidor a registrar Cobros (UC-29).
- No se altera `COBRO.estadoCobro` (`CONFIRMADO`, `ANULADO`), Caja ni el saldo contable definitivo.
- Si el nuevo Pedido fue capturado offline, debe revalidarse al sincronizar; esta regla no elimina validaciones vigentes.
- No se implementa ni aprueba una migración SQL por esta decisión.

## Trazabilidad

RD-F04-003 (pago en tránsito), RD-F04-006 (evaluación de deuda para nuevos Pedidos), RD-F01 y políticas comerciales vigentes. F04/S-01; UC-03 y requisitos de categoría comercial y precio diferenciado.

[PR #5](https://github.com/leandrito369/ale-milanesas/pull/5) · [Issue #6](https://github.com/leandrito369/ale-milanesas/issues/6).
