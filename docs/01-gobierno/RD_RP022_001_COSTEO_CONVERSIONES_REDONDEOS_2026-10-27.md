# RD-RP022-001 — Costeo, conversiones y redondeos del inventario

**Fecha:** 27/10/2026. **Estado funcional:** APROBADA expresamente por el responsable. **Implementación y pruebas:** PENDIENTES.

## Doce reglas aprobadas

1. La unidad de medida definida para el Insumo o Producto determina la unidad base de su inventario.
2. Las cantidades recibidas en otras unidades se convierten a la unidad base **antes** de actualizar el stock.
3. El **factor de conversión efectivamente utilizado** queda congelado en cada Recepción.
4. El **costo unitario convertido** se expresa por unidad base y se conserva el costo original de la Recepción.
5. Los ingresos de Productos de **REVENTA** actualizan su costo promedio móvil mediante promedio ponderado por cantidades.
6. Las salidas por venta de REVENTA utilizan el **costo promedio vigente inmediatamente antes** de la salida; dicho costo queda histórico.
7. Los consumos de Insumos utilizan el **costo histórico aplicable a la operación**, sin alterar consumos anteriores.
8. Rechazar cantidades inválidas, conversiones imposibles y factores de conversión **nulos o negativos**.
9. Calcular importes monetarios con precisión **decimal**, no con punto flotante binario.
10. **Redondeo comercial a dos decimales** para importes monetarios finales; **cuatro decimales** para costos unitarios internos, conforme a las columnas del modelo actual.
11. Si existe stock físico de REVENTA sin costo válido, usar el mecanismo de **valoración extraordinaria justificada**; no asignar automáticamente costo cero.
12. Registrar ajustes y conversiones con trazabilidad; no modificar movimientos históricos de inventario.

## Interpretación, límites y ejemplos

- Costo promedio móvil de REVENTA ante un ingreso válido con existencias y costo conocido: `(cantidadAnterior * costoPromedioAnterior + cantidadNueva * costoUnitarioNuevo)/(cantidadAnterior + cantidadNueva)`. Esta expresión ilustra el promedio ponderado aprobado, sin introducir una política de revaluación retroactiva.
- El período e instantánea de costos consumidos, vendidos o de preparación deben conservarse; un cambio posterior de costo nunca recalcula operaciones anteriores.
- El uso de dos decimales es para **importe monetario final**, no implica convertir anticipadamente todos los costos internos a dos decimales. Los costos unitarios internos conservan cuatro.
- Los residuos de conversión, puntos exactos de redondeo dentro de operaciones compuestas y reglas de exceso de precisión merecen casos de prueba antes del servicio; **no se alteran capacidades NUMERIC del SQL por esta RD**.
- Esta decisión no aprueba movimientos de stock o Caja ficticios, ni transferencias automáticas entre Insumos con distintas unidades ni cambio retroactivo de unidades con historial (RD-RP017-001).
- Se conserva `SALDO_INICIAL` real y trazable de UC-42, sujeto al costo histórico aplicable (F03 / RP-015).
- Se mantiene la distinción de inventario: Insumo para elaboración; Producto REVENTA con promedio móvil y existencias; Producto ELABORADO sin stock general de REVENTA.

## Criterios para implementación y pruebas

Verificar conversiones hacia unidad base, congelamiento de factor/costo, cálculo ponderado con ingresos consecutivos, salida sin costo retroactivo, stock no negativo, rechazo de factor cero/negativo, valorización extraordinaria sin valores ficticios, redondeos de importes monetarios finales y de costos unitarios, historia inmutable y concurrencia de movimientos. Distinguir QA documental de pruebas ejecutadas.

## Trazabilidad

RP-022, UC-08, UC-42, UC-28, UC-05, UC-27; MR-3/MR-5/MR-6; RD-RP016-001, RD-RP017-001.

**Estado RP-022:** reglas funcionales aprobadas; políticas numéricas de casos límite, implementación y pruebas concretas pendientes. **No se modificó DDL ni se ejecutaron servicios.**
