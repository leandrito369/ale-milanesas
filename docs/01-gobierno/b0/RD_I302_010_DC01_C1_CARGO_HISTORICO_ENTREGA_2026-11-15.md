# RD-I302-010 — DC-01-C1: cargo comercial calculado sobre cantidades efectivamente entregadas y valores congelados

**Fecha:** 15/11/2026.  
**Estado funcional:** **DC-01-C1 APROBADA EXPRESAMENTE POR EL RESPONSABLE**.  
**Estado documental:** **ASIENTO PROPUESTO / PR OPEN-DRAFT / NO MERGE / SIN AUTORIZACIÓN DDL NI IMPLEMENTACIÓN**.  
**Gobierno main de referencia:** `cdd57ed194268f1f5ab29aa0f55781ddddebdfb5`; **app main:** `4dbe38668fc5cbc08d04e10920e3bf165c71be11`.  
**Fuentes:** R08.4 PR #53 @ `7448e123c3c43c51d48def6a22d10b58679efb2d` §4.1, §6 y §§10–15; R08.5-C PR #54 @ `cc948fcde1ac2dbfe0a78febff6fd2326b8de258` §10.5; D12-C PR #61 @ `3abfff88ff3744fb02f4336c60ce17c65653a765`; decisiones P0 PR #55–#60; `AplicarAjusteComercialService` (app main); Flyway V1 `ENTREGA/DETALLE_ENTREGA` y contratos REV04B/REV05; RD-F01/F04 y CR-B0-F04-001.

## 1. Decisión comercial expresa

**DC-01-C1 — APROBADA FUNCIONALMENTE (15/11/2026):**

> El importe comercial de cargo `C_e` de una Entrega debe calcularse a partir de las **cantidades realmente entregadas**, los **precios históricos congelados**, las **promociones históricas aplicables** y los **ajustes comerciales congelados del Pedido**, de acuerdo con reglas de reparto y redondeo que deberán ratificarse por separado. **No** se utiliza `PEDIDO.totalOriginal` completo como cargo de una entrega parcial ni se recalculan precios o políticas comerciales vigentes al momento de la entrega. Los adicionales `UC-07` solo podrán incorporarse en la medida en que exista aceptación, valorización histórica y autorización contractual específica.

**C1 es el criterio algorítmico seleccionado.** El patrón `C3` (snapshot persistido de importes canónicos por detalle) **se admite únicamente para evaluación técnica en R08.6 documental**; no se aprobó la estructura física ni se obliga a introducir tablas nuevas. `C2` (prorrateo de `totalOriginal` como algoritmo principal) no es la alternativa elegida.

## 2. Separación obligatoria de magnitudes

- `C_e`: cargo real por unidades entregadas, calculado con componentes históricos y reglas todavía pendientes de `DC-02/DC-03/DC-04`.
- `P_e`: porciones previas de **Cobros confirmados** y **efectivamente aplicadas a la misma obligación**, según IMP-01/DC05-09-A; una reserva previa en Pedido no equivale automáticamente a `P_e` consolidado.
- `D_e`: totalidad del efectivo declarado por Repartidor, íntegra y conservada; no es pago confirmado ni `C_e`.
- `V_e^0`: reconocimiento provisional que requiere fórmula propia en `DC-06`; **DC-01-C1 no aprueba V1**.
- `Q_e`: diferencias tipadas sin creación automática de crédito/Cobro/Caja por exceso.

El importe resultante deberá reconciliarse con el movimiento **único** `MOVIMIENTO_CUENTA(CARGO_POR_VENTA)` atribuible a esa Entrega cuando la integración sea autorizada; no duplicar el cargo, el saldo ni la valorización de adicionales.

## 3. Secuencia conceptual candidata y límites

1. Leer bajo una instantánea comercial verificable los detalles del Pedido, cantidades, precios históricos, promociones y ajuste `UC-16` **congelados**, sin consultar nuevos valores comerciales maestros.
2. Validar que la Entrega concierne al Pedido autorizado y que cada cantidad efectivamente entregada está dentro de los límites del detalle y del circuito autorizado.
3. Calcular bases de los detalles originales entregados con precisión decimal suficiente, usando únicamente su historia comercial aplicable.
4. Aplicar el ajuste histórico conforme a la futura **DC-02**, sin volver a determinar categoría comercial ni política de ajuste en la Entrega.
5. Incorporar componentes adicionales `UC-07` una sola vez **si y solo si** están contractualmente aprobados e integrados; en caso contrario dejar el tratamiento pendiente, no inventar precio.
6. Aplicar escala/momento/modo de redondeo conforme a **DC-04** y verificar que `C_e` es no negativo y reconciliable con sus componentes.
7. Conservar identidad de Entrega, snapshot canónico y resultado de cálculo en replays según el futuro contrato y CR; **C3** puede ser una alternativa de evidencia, no fuente comercial adicional.

**Atención a la compatibilidad:** el servicio actual `AplicarAjusteComercialService` redondea la base a dos decimales con `HALF_UP`, calcula el ajuste porcentual redondeándolo a dos decimales con `HALF_UP` y luego suma/resta; por ello el concepto de “redondeo único final” de la propuesta R08.4 **no coincide necesariamente con la secuencia ya integrada**. La decisión `DC-04` debe resolver esto expresamente para evitar que una Entrega completa difiera del `totalOriginal` histórico por centavos. Este asiento **no** cambia `UC-16` ni selecciona el redondeo futuro.

## 4. Ejemplos ilustrativos, no resultados de pruebas

**C1-EX01 — Parcial simple:** Pedido de 5 unidades a $2.000 históricos, sin promoción ni ajuste, entrega 3 unidades. Base entregada: $6.000. El importe total original de $10.000 **no** es el cargo de esta Entrega parcial.

**C1-EX02 — Precio cambiado luego del Pedido:** 3 unidades entregadas a precio histórico $2.000 aunque el maestro de producto ahora marque $2.500. La base por esas unidades sigue siendo $6.000 antes de promociones y ajuste congelado.

**C1-EX03 — Descuento de categoría:** Pedido con subtotal original luego de promoción y porcentaje congelado. La parte de descuento aplicable a las cantidades parciales y el momento exacto de redondeo requieren **DC-02/DC-04**, aunque el algoritmo base sea C1.

**C1-EX04 — UC-07 adicional:** una cantidad adicional sin contrato valorizado y CR integrada **no** autoriza fabricar un importe en `C_e`; `DC-03` deberá indicar inclusión y orden de cálculo.

**C1-EX05 — Pago adelantado:** `C_e` permanece el valor de venta efectivamente entregada; el anticipo consolidado `P_e` se descuenta solo del pendiente elegible del reconocimiento provisional cuando `DC-06` sea ratificada, sin alterar retroactivamente `C_e`.

## 5. Pruebas a diseñar, NO EJECUTADAS

| Caso | Criterio |
|---|---|
| CAL-C1-01 | Entrega parcial: no se carga cantidad no entregada |
| CAL-C1-02 | Cambio de lista de precios posterior al Pedido: conserva precio histórico |
| CAL-C1-03 | Promociones históricas: no reevalúa vigencia actual |
| CAL-C1-04 | Ajuste comercial congelado: no reevaluación UC-15/UC-16 en el cálculo |
| CAL-C1-05 | Entrega completa: reconciliación al centavo con cargo/total histórico según política de redondeo ratificada |
| CAL-C1-06 | Paridad de replay: misma identidad y payload devuelven mismo resultado económico |
| CAL-C1-07 | UC-07 aprobado/no aprobado: componente adicional único o guardia, sin doble cargo |
| CAL-C1-08 | Cobro previo y cantidad parcial: `P_e` no modifica `C_e` |
| CAL-C1-09 | Múltiples detalles de precisión 3/4: controlar redondeo y límite `NUMERIC(18,2)` |
| CAL-C1-10 | Dos UC-05 concurrentes: no dobla `CARGO_POR_VENTA` |

## 6. Pendientes y autorización

| Decisión | Estado |
|---|---|
| **DC-01-C1** | **APROBADA FUNCIONALMENTE** (este asiento) |
| **DC-02** | **PENDIENTE** — regla de reparto de ajuste congelado ante entrega parcial |
| **DC-04** | **PENDIENTE** — momento, escala y modo de redondeo, compatibilidad UC-16 |
| **DC-03 / DC05-08** | **PENDIENTE** — adicionales UC-07 y remanentes de anticipos ante entrega parcial |
| **DC-06** | **PENDIENTE** — reconocimiento provisional `V_e^0` y evidencia de cálculo |
| **C3 persistente** | **SOLO CANDIDATO** para evidencia en R08.6; no autorización de esquema |
| **D12-C, DC05-09-A y P0 previas** | APROBADAS FUNCIONALMENTE en PR #55–#61; sin cambios físicos |

**Dictamen:** DC-01-C1 no aprueba fórmula financiera completa, ajuste ni redondeo; no autoriza modificar `AplicarAjusteComercialService`, `UC-05`, `UC-29`, `UC-16`, `UC-07`, `REV04B/REV05`, G0/RBAC, Flyway ni la aplicación. No se ejecutan SQL ni pruebas de integración; sin merge ni despliegue.
