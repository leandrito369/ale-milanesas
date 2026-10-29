# RD-RP023-001 — Promociones simultáneas y elegibilidad

**Fecha:** 27/10/2026. **Estado funcional:** APROBADA expresamente por el responsable. **Implementación y pruebas:** PENDIENTES.

## Seis reglas aprobadas

1. Un Producto puede participar en **varias Promociones vigentes**.
2. No se acumulan descuentos de varias Promociones **sobre las mismas unidades**.
3. Cuando varias Promociones sean aplicables, se utiliza **la que otorgue mayor beneficio económico al Cliente**.
4. Una Promoción se aplica únicamente si satisface sus condiciones de **vigencia, Producto, destinatario y disponibilidad de uso**.
5. La Promoción aplicada y su descuento **quedan congelados en el Pedido confirmado**.
6. Desactivar o finalizar una Promoción **no modifica Pedidos históricos**.

## Límites

- Estas reglas no aprueban una fórmula nueva para descuentos ni modifican el orden comercial ya previsto para los canales INTERNO y ONLINE.
- No se redefine la política de ajuste por categoría `CUMPLIDOR` / `EN_MORA`; RD-F04-007 mantiene el ajuste `EN_MORA` hasta reevaluación formal.
- La selección de mayor beneficio debe respetar las condiciones de elegibilidad y los descuentos no se superponen sobre las mismas unidades.
- No se crea un nuevo CU, estado de Promoción, tabla o campo por este acuerdo.
- Reactivar una Promoción `PAUSADA` no queda aprobado por esta decisión; permanece el límite de F08.

## Trazabilidad y pendientes

RP-023; UC-24, UC-59, UC-60, UC-03 y UC-21; MR-5 S-05; F08; RD-F04-007.

**RP-023 queda resuelto en cuanto a estas reglas funcionales**, permaneciendo pendientes implementación, tratamiento concurrente de cupos/uso, pruebas y especificaciones complementarias que se detecten.

**No se modificaron diagramas ni SQL.**
