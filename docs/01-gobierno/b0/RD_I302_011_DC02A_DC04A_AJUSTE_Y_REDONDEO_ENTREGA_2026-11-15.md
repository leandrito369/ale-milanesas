# RD-I302-011 — DC-02-A / DC-04-A: ajuste congelado sobre base entregada y redondeo compatible con UC-16

**Fecha de decisión:** 15/11/2026 (hora local Argentina).  
**Estado funcional:** **DC-02-A y DC-04-A APROBADAS EXPRESAMENTE por el responsable**.  
**Estado documental:** **ASIENTO PROPUESTO / PR OPEN-DRAFT / NO MERGE / SIN AUTORIZACIÓN FÍSICA NI DE IMPLEMENTACIÓN**.  
**Gobierno main de referencia:** `cdd57ed194268f1f5ab29aa0f55781ddddebdfb5`. **Aplicación main:** `4dbe38668fc5cbc08d04e10920e3bf165c71be11`.  
**Fuentes:** PR #53 R08.4 §4/§6/§12 @ `7448e123c3c43c51d48def6a22d10b58679efb2d`; PR #54 R08.5-C §10.5 @ `cc948fcde1ac2dbfe0a78febff6fd2326b8de258`; PR #62 RD-I302-010 DC-01-C1 @ `a3bd12d552f2f45baffca147f6cafdaa84284bcb`; PR #61 D12-C; P0 PR #55–#60; `ale-milanesas-app/src/main/java/ar/edu/unam/alemilanesas/finanzas/AplicarAjusteComercialService.java` en main; REV04B/REV05, RD-F04, CR-B0-F04-001 y G0.

## 1. Decisiones comerciales expresas

**DC-02-A — APROBADA:**

> Al calcular el cargo de una Entrega parcial mediante **DC-01-C1**, se **reaplica el porcentaje de ajuste comercial histórico congelado** del Pedido —y su tipo `DESCUENTO`, `RECARGO` o `SIN_AJUSTE`— a la **base comercial correspondiente a las cantidades efectivamente entregadas después de las promociones históricas aplicables**. No se reevalúan categoría comercial, política vigente, precios ni promociones al entregar. No se prorratea como método principal el importe monetario total original del ajuste.

**DC-04-A — APROBADA:**

> Mantener la secuencia de redondeo implementada actualmente en **UC-16** para la base y el ajuste comercial: (1) **redondear la base comercial agregada luego de promociones a dos decimales con `HALF_UP`**, (2) **calcular el porcentaje de ajuste sobre esa base redondeada y redondear el importe del ajuste a dos decimales con `HALF_UP`**, (3) **sumar/restar el ajuste ya redondeado** según su tipo; `SIN_AJUSTE` equivale a cero. Requerir **controles de reconciliación por detalle**, manteniendo un único resultado monetario canónico para `C_e`.

**No elegidas:** DC-02-B (prorratear el importe monetario histórico total del ajuste) y DC-04-B (único redondeo al final sobre todos los intermedios sin respetar la secuencia UC-16).

**Aclaración técnica de alcance:** este asiento **no** decide un mecanismo físico de reparto de centavos por cada detalle, ni autoriza redondear cada línea independientemente y después sumar (podría divergir del cálculo sobre base agregada). La **regla vinculante** es el total agregado calculado según UC-16, más un requisito de reconciliación reproducible de la eventual descomposición por detalle. C3 persiste como **opción de evidencia no ratificada**.

## 2. Algoritmo conceptual a nivel de subtotal original entregado

Definiciones simbólicas, sujetas a fuentes históricas válidas de promoción y precios:

- `S_e`: suma precisa de bases de líneas originales efectivamente entregadas después de promociones históricas válidas, sin adicionales UC-07 hasta resolver DC-03.
- `B_e = round_HALF_UP(S_e, 2)`: **base comercial agregada redondeada** de la Entrega.
- `r`: porcentaje histórico congelado del Pedido; `t`: tipo de ajuste histórico (`DESCUENTO`/`RECARGO`/`SIN_AJUSTE`).
- `J_e = round_HALF_UP(B_e × r / 100, 2)` para descuentos y recargos; `J_e = 0.00` para `SIN_AJUSTE`.
- **Subtotal original de entrega luego de ajuste:** `O_e = B_e - J_e` si `DESCUENTO`; `O_e = B_e + J_e` si `RECARGO`; `O_e = B_e` si `SIN_AJUSTE`.
- `C_e` incorpora también adicionales UC-07 **únicamente bajo la política posterior DC-03 y contrato UC-07 ratificado**, sin duplicar ni aplicarles por inferencia el ajuste histórico del Pedido. Por tanto, `O_e` es la parte original del futuro `C_e`, no necesariamente el total definitivo.

No se recalcula `UC-16` con políticas actuales. Se **reproduce la secuencia matemática usando los atributos del ajuste congelados**. El servicio UC-16 de main actualmente efectúa `base.setScale(2,HALF_UP)`, calcula `base.multiply(porcentaje).divide(100,2,HALF_UP)` y suma/resta. Esta elección requiere verificar que el mismo tipo, porcentaje y subtotal histórico sean recuperables en el snapshot del Pedido; si faltan, **no** inventarlos.

## 3. Ejemplos de control (solo ilustraciones matemáticas, NO pruebas ejecutadas)

### Ejemplo A — Parcial

- Subtotal histórico después de promociones: `100.05`, tipo `DESCUENTO`, porcentaje congelado `10%`.
- Base correspondiente a lo entregado (después de promociones): `60.03`.
- `B_e = 60.03`; `J_e = round_HALF_UP(60.03 × 10 / 100,2) = 6.00`; subtotal `O_e = 54.03`.
- **No** prorratear el ajuste original de `10.01` como `6.01` sobre la entrega; ese es el método alternativo no elegido.

### Ejemplo B — Entrega completa y paridad UC-16

- Base histórica `100.05`, descuento `10%` congelado.
- UC-16: `B_e=100.05`, `J_e=10.01` por `HALF_UP`, `O_e=90.04`.
- Si se aplicara erróneamente un único redondeo final de `100.05 - 10.005=90.045`, resultaría `90.05`; **no** es la decisión aprobada.
- **Criterio:** para entrega completa, con los mismos componentes históricos y sin adicional, `O_e` debe conciliar exactamente a dos decimales con `PEDIDO.totalOriginal` congelado. Una inconsistencia debe investigarse, no ajustarse tácitamente.

### Ejemplo C — Reconciliación por detalle

- Si tres líneas generan importes de alta precisión cuya suma requiere distribuir un centavo residual, **el total `O_e` definido por la regla agregada prevalece**. La estrategia de asignación y evidencia de ese residuo deberá especificarse y probarse antes de un snapshot C3/DDL; ninguna línea adquiere un segundo cargo o importe adicional.
- Una entrega parcial no debe imputar como cargo las cantidades no entregadas, incluso si el Pedido original ya tenía un descuento global congelado.

## 4. Invariantes para contrato, diseño y pruebas

1. `C_e` se refiere exclusivamente a unidades realmente entregadas a precios/promociones/ajustes históricos, **no** al `totalOriginal` de una entrega parcial.
2. Tipo y porcentaje del ajuste son **históricos del Pedido**, no se recalculan desde la categoría actual al confirmar UC-05.
3. **Dos redondeos definidos** (base agregada y ajuste monetario porcentual), escala 2, `HALF_UP`; la suma/resta de importes ya a escala 2 no añade un nuevo criterio de redondeo.
4. En entrega completa original sin adicionales, el cálculo debe reproducir `PEDIDO.totalOriginal` al centavo, siempre que el snapshot comercial sea idéntico; si no, identificar la causa y rechazar o conciliar de acuerdo con contrato posterior, sin crear un ajuste silencioso.
5. La presentación por detalle, si se adopta, debe reconciliar con la base y ajuste agregados. **No** se autorizó redondeo autónomo por línea ni una regla para repartir residuos que modifique el resultado total.
6. No recalcular promociones ni incluir adicionales UC-07 dos veces; `DC-03` sigue abierta sobre su incorporación y orden de descuentos.
7. `P_e` (anticipos imputados), `D_e` (declaración íntegra) y `V_e^0` (reconocimiento provisional) son magnitudes distintas y no alteran `C_e`.
8. Los replays idempotentes deben conservar el mismo snapshot y resultado económico de la aceptación original; no usar políticas o precios nuevos en replay.
9. Sumas, tipos, escalas, precisión y compatibilidad con `NUMERIC(18,2)` deben validarse antes de persistir o contabilizar; no hay ejecución por esta PR.
10. Las diferencias entre propuesta inicial R08.4 (redondeo único al final) y **DC-04-A aprobada** se documentan como **decisión superadora** a conciliar en E-02/E-07; no editar canónicos en este corte.

## 5. Matriz de aceptación futura — NO EJECUTADA

| Caso | Escenario | Resultado esperado |
|---|---|---|
| AJR-01 | Entrega parcial con descuento 10% sobre `60.03` | Ajuste `6.00` y total original de entrega `54.03` |
| AJR-02 | Entrega completa con base `100.05`, descuento 10% | Ajuste `10.01` y total `90.04`, compatible con UC-16 |
| AJR-03 | Entrega con `RECARGO` histórico | Base redondeada + ajuste porcentual redondeado sin reevaluar categoría |
| AJR-04 | `SIN_AJUSTE` histórico | `O_e=B_e` y ajuste monetario `0.00` |
| AJR-05 | Promoción/precio vigente cambió después del Pedido | Usar componentes congelados exclusivamente |
| AJR-06 | Tres detalles con fracciones que dejan residuo de un centavo | Agregado canónico, subdetalle conciliado sin doble cargo |
| AJR-07 | Entrega completa sin adicionales | `O_e=PEDIDO.totalOriginal` al centavo, o inconsistencia explicitada/bloqueada |
| AJR-08 | Entrega parcial y reserva de anticipo mayor que cargo | `P_e` y remanente según DC05-08; sin restar dos veces del cargo |
| AJR-09 | Adicional UC-07 no autorizado/integrado | No fabricar componente adicional ni cambiar algoritmo histórico |
| AJR-10 | Reenvío idéntico de UC-05 tras cambio de política | Mismo `O_e` y `C_e` originales |
| AJR-11 | Escala/puntos medios decimal positivos en `HALF_UP` | Centavos reproducibles con BigDecimal y sin coma flotante |
| AJR-12 | Cargo + movimientos Cuenta Corriente | Un único cargo por Entrega por monto autorizado, no duplicación |

## 6. Estado de decisiones y gates

| Identificador | Estado |
|---|---|
| **DC-02-A** | **APROBADA FUNCIONALMENTE** — reaplicar porcentaje histórico al subtotal realmente entregado |
| **DC-04-A** | **APROBADA FUNCIONALMENTE** — base y ajuste redondeados por separado a 2 decimales `HALF_UP` |
| **DC-01-C1** | APROBADA (PR #62) |
| **DC-03** | **PENDIENTE** — adicional UC-07 y su tratamiento relativo al ajuste histórico |
| **DC05-08** | **PENDIENTE** — reserva superior al cargo en entrega parcial, destino remanente |
| **DC-06, DC-07/08, DEC-GRAN-D6, D9/D10** | PENDIENTES — reconocimiento provisional, diferencias y rendición |
| **DC05-10/11/12, E-01..E-07, CR-B0-F04-001** | PENDIENTES de conciliación/autoridad, sin autorización de DDL |

**Dictamen:** no se autorizan DDL/migración/laboratorio, implementación, RBAC/G0, cambios en `REV04B`/`REV05`, `UC-16`, `UC-05`, `UC-07`, Cobro, Cuenta ni despliegue. PR documental nueva y única, **OPEN/DRAFT/NO MERGE**.
