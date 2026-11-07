# RD-UC08-002 — Decisiones de implementación de UC-08 REVENTA

**Fecha:** 07/11/2026
**Estado:** RATIFICADA. Desbloquea la implementación de UC-08 REVENTA.
**Autoridad:** Victor Leandro Machado (`leandrito369`), Responsable del proyecto.
**CU y operación:** UC-08 `registrarIngresoStockPorCompra` — rama REVENTA.
**Predecesora:** `RD-UC08-001` (INSUMO, merge `ee555ba9d020aaf66f1f95e1e4e73d99a9235448`).
**Contrato canónico:** `CONTRATOS_REV03B_CORREGIDOS.md §7`.

## Registro formal §10.4

| Campo | Valor |
|---|---|
| `decision_id` | `RD-UC08-002` |
| `fecha` | `2026-11-07` |
| `estado` | `RATIFICADA` |
| `autoridad` | Victor Leandro Machado |
| `regla_aprobada` | Las 5 decisiones A-E de la sección siguiente, necesarias para implementar UC-08 REVENTA sin contradecir `RD-RP022-001` ni `RD-UC08-001`. |
| `alternativas_descartadas` | Ver cada decisión. |
| `justificacion` | La auditoría previa (Codex, 07/11/2026) detectó que estas 5 decisiones no están respaldadas por documentación existente. Ratificarlas cierra la brecha antes de implementar. |
| `artefactos_afectados` | `ale-milanesas-app` (implementación futura de UC-08 REVENTA). Cero cambios en G0/MR-5/F01/MR-6. |
| `fuente_chat` | Trabajo del 07/11/2026. Auditoría de Codex + ratificación del Responsable. |
| `fecha_propagacion` | 07/11/2026 |
| `pruebas` | Pendientes: se ejecutarán en el PR de implementación de UC-08 REVENTA. |

## Decisiones ratificadas

### Decisión A — Manejo de `stockActualReventa = NULL`

**Contexto:** `PRODUCTO.stockActualReventa` (`NUMERIC(18,3)`) y `PRODUCTO.costoPromedioActualReventa` (`NUMERIC(18,4)`) son **nullable** en `V1__baseline_mr5.sql` (líneas 33–34). Solo existen `ck_producto_0` (`tipoProducto IN ('ELABORADO','REVENTA')`), `ck_producto_1` (`stockActualReventa IS NULL OR stockActualReventa >= 0`) y `ck_producto_2` (`costoPromedioActualReventa IS NULL OR costoPromedioActualReventa >= 0`, líneas 37–39). **`ck_producto_3` NO existe** (aclaración explícita: en borradores previos se asumió su existencia; no aplica).

**Decisión:** tratar `stockActualReventa = NULL` como "producto sin stock inicializado". En el primer ingreso REVENTA (cuando `stockActualReventa IS NULL` o `stockActualReventa = 0` sin existencias físicas previas):
- `cantidadAnterior = 0` (solo para el cálculo del promedio móvil)
- `costoPromedioActualReventa = NULL` → `nuevoCostoPromedio = costoUnitarioCompra` (fórmula con denominador = `cantidadNueva`, numerador = `cantidadNueva × costoUnitarioNuevo`; resultado = `costoUnitarioNuevo`)
- Si en cambio existiera stock físico positivo (`stockActualReventa > 0`) con costo inválido (`costoPromedioActualReventa IS NULL` o `<= 0`), se rechaza la recepción conforme a la Regla 11 de `RD-RP022-001` ("Si existe stock físico de REVENTA sin costo válido, usar el mecanismo de valoración extraordinaria justificada; no asignar automáticamente costo cero").

**Justificación:** la regla 11 de `RD-RP022-001` (línea 17) prohíbe asignar costo cero automáticamente cuando existe stock físico sin costo válido. Tratar `stockActualReventa = NULL` como ausencia de stock previo permite inicializar stock y costo promedio en la primera compra real sin inventar costo cero.

**Alternativa descartada:** rechazar la operación si `stockActualReventa = NULL`. Requeriría cambiar UC-30 (alta de producto) para que siempre cree con stock=0.

### Decisión B — `numeroSecuenciaProducto = MAX+1`

**Contexto:** `MOVIMIENTO_STOCK_REVENTA.numeroSecuenciaProducto` es `BIGINT NOT NULL` (V1 línea 726) con `uq_movimiento_stock_reventa_0 UNIQUE ("idProducto", "numeroSecuenciaProducto")` (línea 741) y `ck_movimiento_stock_reventa_0 CHECK ("numeroSecuenciaProducto" > 0)` (línea 745). El diccionario (`Diccionario_Explicativo_60_Tablas_MR5_MR6_26-10-2026.md` línea 926) lo describe como "Número correlativo de movimientos físicos del Producto REVENTA". **No hay implementación Java previa para REVENTA.**

**Decisión:** calcular `SELECT COALESCE(MAX("numeroSecuenciaProducto"), 0) + 1 FROM "MOVIMIENTO_STOCK_REVENTA" WHERE "idProducto" = :producto`, dentro de la transacción, serializando la concurrencia mediante lock transaccional (`pg_advisory_xact_lock`) y bloqueo de fila `SELECT ... FROM "PRODUCTO" WHERE "idProducto" = :producto FOR UPDATE` (coherente con `RD-UC30-001`).

**Justificación:** es el mismo patrón exacto que usa `numeroSecuenciaInsumo` en `RegistrarIngresoStockInsumoService` (líneas 90–93, rama INSUMO). Mantiene consistencia técnica en el proyecto y previene condiciones de carrera sobre `uq_movimiento_stock_reventa_0`.

**Alternativa descartada:** secuencia PostgreSQL (`CREATE SEQUENCE`). Requeriría DDL nuevo (V4) y no garantizaría correlatividad por `idProducto`, violando el alcance del corte.

### Decisión C — `idProveedorDirecto` obligatorio

**Contexto:** `RECEPCION_COMPRA.idProveedorDirecto` es **nullable** en `V1__baseline_mr5.sql` (línea 703) con `fk_recepcion_compra_1` hacia `PROVEEDOR(idProveedor)` (línea 974). El constraint `ck_recepcion_compra_4` (`CHECK ("idOrdenCompra" IS NULL OR ("idInsumoRecibido" IS NOT NULL AND "idProductoReventa" IS NULL AND "idProveedorDirecto" IS NULL))`, línea 720) exige `idOrdenCompra IS NULL` para toda recepción de REVENTA, pero no impone `idProveedorDirecto IS NOT NULL` cuando `idOrdenCompra IS NULL`. El diccionario (línea 902) lo declara `BIGINT · FK/NULL`. En `RD-UC08-001` D4 se dejó constancia de que incorporar `idProveedorDirecto` para reventa requería decisión expresa.

**Decisión:** exigir `idProveedorDirecto` en la entrada de UC-08 REVENTA y validar en B3 que `idProveedorDirecto` no sea `NULL` ni `<= 0` (y que referencie un `PROVEEDOR` existente y `ACTIVO`). Si falta o es `<= 0` → 400 `PROVEEDOR_DIRECTO_REQUERIDO`.

**Justificación:** dado que REVENTA no utiliza `ORDEN_COMPRA` (`idOrdenCompra = NULL` por `ck_recepcion_compra_4`), una recepción REVENTA sin `idProveedorDirecto` carecería de trazabilidad comercial del origen de la compra. Aunque el modelo físico admite `NULL`, la regla de negocio de la operación lo requiere.

**Alternativa descartada:** permitir `idProveedorDirecto = NULL`. Deja recepciones de reventa sin proveedor asociado ni trazabilidad comercial.

**Nota:** el constraint SQL (`ck_recepcion_compra_4`) **NO cambia** (la columna sigue siendo nullable en DDL). La obligatoriedad se aplica en la capa de aplicación/negocio.

### Decisión D — Redondeo y precisión (reglas 9/10 de RD-RP022-001)

**Contexto:** en `RD-RP022-001`, la regla 9 (línea 15) establece *"Calcular importes monetarios con precisión **decimal**, no con punto flotante binario"* y la regla 10 (línea 16, ampliada en línea 24) establece *"**Redondeo comercial a dos decimales** para importes monetarios finales; **cuatro decimales** para costos unitarios internos, conforme a las columnas del modelo actual"*.

**Decisión:**
- `cantidadRecibida` (REVENTA): `BigDecimal` compatible con `NUMERIC(18,3)` (consistente con schema)
- `costoUnitarioReal`: `BigDecimal` compatible con `NUMERIC(18,4)` (consistente con schema)
- `costoPromedioActualReventa` calculado en `PRODUCTO`: `BigDecimal` con `setScale(4, RoundingMode.HALF_UP)` para almacenar en `NUMERIC(18,4)`
- `costoPromedioResultante` en `MOVIMIENTO_STOCK_REVENTA`: mismo `setScale(4, RoundingMode.HALF_UP)` (cumpliendo `ck_movimiento_stock_reventa_4`: `costoPromedioResultante > 0`)
- Si en el futuro se expone un importe monetario final al exterior (HTTP response), `setScale(2, RoundingMode.HALF_UP)`
- **NO usar `double` ni `float` en ninguna parte del cálculo**

**Justificación:** cumplimiento estricto de la regla 9 (precisión decimal) y la regla 10 (escala 4 para costos unitarios internos y 2 para importes monetarios finales) de `RD-RP022-001`.

### Decisión E — Políticas numéricas límite

**Contexto:** en `RD-RP022-001`, la línea 25 declara: *"Los residuos de conversión, puntos exactos de redondeo dentro de operaciones compuestas y reglas de exceso de precisión merecen casos de prueba antes del servicio; **no se alteran capacidades NUMERIC del SQL por esta RD**"* y la línea 38 declara: *"**Estado RP-022:** reglas funcionales aprobadas; políticas numéricas de casos límite, implementación y pruebas concretas pendientes. **No se modificó DDL ni se ejecutaron servicios.**"*

**Decisión (alineada con los tres puntos de la línea 25 de `RD-RP022-001`):**
- **Residuos de conversión:** en este corte rige `factorConversionAplicado = 1` con validación de unidad base (`codigoUnidadMedidaRecibida == PRODUCTO.codigoUnidadVenta`, heredado de `RD-UC08-001 D3`), por lo que no existen residuos de conversión (`cantidadBaseConvertida = cantidadRecibida` y `costoUnitarioBaseConvertido = costoUnitarioCompra`).
- **Punto exacto de redondeo en la operación compuesta (promedio ponderado móvil):** las multiplicaciones intermedias (`cantidadAnterior * costoPromedioAnterior` y `cantidadNueva * costoUnitarioNuevo`) y su suma en el numerador se evalúan con precisión exacta en `BigDecimal` sin redondeo intermedio; el redondeo se aplica **únicamente en la división final** `.divide(stockResultante, 4, RoundingMode.HALF_UP)` al obtener el nuevo costo unitario promedio (`NUMERIC(18,4)`).
- **Reglas de exceso de precisión y capacidad `NUMERIC` del SQL (sin alterar DDL):** no se truncan ni redondean silenciosamente entradas con exceso de escala; se rechaza con 400 (`SOLICITUD_INVALIDA`) toda entrada cuya escala o dígitos enteros excedan la capacidad de las columnas `NUMERIC` del modelo (`cantidadRecibida`: máximo 3 decimales y 15 dígitos enteros para `NUMERIC(18,3)`; `costoUnitarioCompra`: máximo 4 decimales y 14 dígitos enteros para `NUMERIC(18,4)`), así como cualquier resultado `stockResultante` que exceda los 15 dígitos enteros de `NUMERIC(18,3)` (mismo criterio `positivo(n, escala, enteros)` aplicado en `RegistrarIngresoStockInsumoService`).
- **Positividad posredondeo (`ck_movimiento_stock_reventa_4`):** dado que `cantidadRecibida > 0` y `costoUnitarioCompra > 0` (con hasta 4 decimales), el promedio ponderado resultante con `RoundingMode.HALF_UP` a 4 decimales es siempre `> 0`, preservando `ck_movimiento_stock_reventa_4`.

**Justificación:** las líneas 25 y 38 de `RD-RP022-001` dejaron explícitamente pendientes los puntos exactos de redondeo en operaciones compuestas y las reglas de exceso de precisión sin alterar las capacidades `NUMERIC` del SQL. Esta decisión los cierra formalmente para UC-08 REVENTA en total consistencia con la rama INSUMO.

**Alternativa descartada:** (1) no ratificar y dejar pendiente como dice `RD-RP022-001` (bloquearía la implementación); (2) aceptar entradas con escala arbitraria y truncarlas/redondearlas silenciosamente a la entrada (ocultaría pérdida de precisión y contradiría la validación de capacidades `NUMERIC` del modelo usada en INSUMO).

## Aclaraciones heredadas de RD-UC08-001 (no se re-ratifican)

- **`factorConversionAplicado = 1` con validación de unidad base:** hereda de `RD-UC08-001 D3` (`codigoUnidadMedidaRecibida == PRODUCTO.codigoUnidadVenta`). Aplica a REVENTA también porque `RECEPCION_COMPRA.factorConversionAplicado` es `NOT NULL` para ambos tipos.
- **`codigoLote` y `fechaVencimiento`:** NO aplican a REVENTA (las tablas `PARTIDA_INSUMO` y `DETALLE_MOVIMIENTO_PARTIDA` de MR-6 solo se utilizan para `INSUMO`).

## Invariantes preservados

- **NO modifica G0** (`source_commit=1263ffc17bd0eb7f3c69faaa9ff5ae556cf9de7e`)
- **NO modifica MR-5/F01/MR-6**
- **NO modifica `source-lock.md`**
- **NO modifica manifiesto G0**
- **NO modifica `RD-RP022-001`** (la complementa, no la sustituye)
- **NO modifica `RD-UC08-001`** (la complementa)

## Dependencias

- `RD-UC08-001`: merge `ee555ba9d020aaf66f1f95e1e4e73d99a9235448`
- `RD-RP022-001`: `docs/01-gobierno/RD_RP022_001_COSTEO_CONVERSIONES_REDONDEOS_2026-10-27.md`
- `RD-MR-PARTIDAS-001`: merge `cd603d25addb4312d9bee62ec03514760f7e2894`
- `RP-MR-002`: merge `e3e60e9f59e1d149f65959cf5c84376c1eea2935`

## Firmas

**Decisión ratificada por:** Victor Leandro Machado — Responsable del proyecto.
**Fecha:** 07/11/2026.
