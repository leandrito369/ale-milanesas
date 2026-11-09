# RD-I301-001 — Decisiones consolidadas de I3-01 (UC-10 + UC-28 + BuscarPedido contextual)

**Fecha:** 11/11/2026  
**Estado:** RATIFICADA  
**Autoridad:** Victor Leandro Machado (`leandrito369`), Responsable del proyecto.  
**CU y operaciones:** `UC-10` (`configurarRecetaProducto`), `UC-28` (`registrarPreparacionPedido`), `UC-34` (`buscarPedido` contextual `PRODUCCION`).  
**Alcance:** decisión documental consolidada para el bloque `I3-01`; complementa `CONTRATOS_REV06B`, `CONTRATOS_REV04B`, `RD-MR-PARTIDAS-001`, `RD-RP022-001`, `RD-UC19-002`, `RD-UC08-001` y `RD-UC42-001` sin modificarlos.

---

## 1. Registro formal §10.4

| Campo | Valor |
|---|---|
| `decision_id` | `RD-I301-001` |
| `fecha` | `2026-11-11` |
| `estado` | `RATIFICADA` |
| `autoridad` | Victor Leandro Machado |
| `regla_aprobada` | Consolidar las decisiones técnicas de implementación del bloque `I3-01`: (D-U10-1 y D-U10-2) coincidencia obligatoria de unidades y acotamiento prospectivo de vigencias en `UC-10`; (G1, G2, G4, G5 y G6) selección automática D4 con override opcional y apertura implícita/explícita D2, fórmula `BigDecimal` con redondeo `HALF_UP` a escala 3, literal `origen = 'PRODUCCION'`, invocación de `EpisodioFaltanteService` y orden canónico de locks en `UC-28` (dejando idempotencia reservada a `RD-UC28-002`); y habilitación del ámbito contextual `RESPONSABLE_PRODUCCION` en `BuscarPedidoService` (`UC-34`). |
| `alternativas_descartadas` | (1) Inventar una tabla de factores de conversión para `VERSION_RECETA` / `DETALLE_VERSION_RECETA`; (2) truncar vigencias futuras programadas de recetas; (3) modificar las firmas canónicas de G0 o los contratos consolidados; (4) duplicar la lógica de `EpisodioFaltanteService` o emitir `SOLICITUD_COTIZACION` desde `UC-28` antes de I5; (5) permitir a `RESPONSABLE_PRODUCCION` consultar pedidos arbitrarios fuera del contexto de preparación. |
| `justificacion` | Cerrar en un único instrumento normativo las definiciones técnicas detectadas en la auditoría de `I3-01` antes de codificar `UC-10` y `UC-28`, preservando intactos los contratos canónicos G0, las 60 tablas MR-5/F01 y las 2 tablas MR-6 (`V3`). |
| `artefactos_afectados` | `ale-milanesas-app` (implementación futura de `UC-10`, `UC-28` y extensión contextual de `BuscarPedidoService`). Cero cambios en G0, MR-5/F01, MR-6 ni `source-lock.md`. |
| `fuente_chat` | Auditoría previa de `I3-01` y ratificación expresa del Responsable del 11/11/2026. |
| `fecha_propagacion` | 11/11/2026 (registro documental; implementación en `ale-milanesas-app` en PRs posteriores de `I3-01`). |
| `pruebas` | Comprobaciones documentales `tests/b0/test_documentacion_b0.py` (21 tests). Pruebas de integración B3 y HTTP B4 exigidas en los PRs de implementación en `ale-milanesas-app`. |

---

## 2. Firma de `UC-10` y semántica de vigencias (`D-U10-1` y `D-U10-2`)

**Firma canónica** ([CONTRATOS_REV06B_TRECE_CORREGIDOS.md §9, L168](../../08-diagramas/revision/REV06B_CLIENTES_RECETAS_INVENTARIO/propuestos/CONTRATOS_REV06B_TRECE_CORREGIDOS.md#L168)):

```text
configurarRecetaProducto(
    idProducto: Long,
    cantidadRendimientoBase: BigDecimal,
    codigoUnidadRendimiento: String,
    vigenteDesde: Timestamp,
    vigenteHasta: Timestamp[0..1],
    itemsInsumo: List<ItemRecetaDTO>
)
```

Se mantiene sin extensión.

### `D-U10-1` — Coincidencia obligatoria de unidades (sin tabla de conversión)
- `VERSION_RECETA.codigoUnidadRendimiento` debe coincidir con `PRODUCTO.codigoUnidadVenta`.
- `DETALLE_VERSION_RECETA.codigoUnidadCantidad` debe coincidir con `INSUMO.codigoUnidadMedida` del insumo referenciado.
- Si alguna unidad no coincide → rechazar con **400 `UNIDAD_NO_COINCIDE`**.
- **Justificación:** `UNIDAD_MEDIDA` (`V1__baseline_mr5.sql` L18–23) no posee tabla de factores de conversión y ni `VERSION_RECETA` ni `DETALLE_VERSION_RECETA` tienen columna `factorConversion`. `RD-RP022-001` (Reglas 1 y 8) exige operar sobre la unidad base definida en el maestro sin inventar conversiones.

### `D-U10-2` — Acotamiento de `VERSION_RECETA` previa
- Reutilizar el patrón ratificado en `RD-UC19-002` (acotamiento prospectivo sobre intervalos `[vigenteDesde, vigenteHasta)` normalizados a microsegundos).
- Exigir `vigenteDesde >= clock_timestamp()` (no se admiten versiones retroactivas) y `vigenteHasta == null || vigenteHasta > vigenteDesde`.
- Si existe una versión vigente en curso (`desde < vigenteDesde` y `(hasta IS NULL OR hasta > vigenteDesde)`) que no sea una versión futura programada, cerrarla atómicamente con `UPDATE "VERSION_RECETA" SET "vigenteHasta" = :vigenteDesde`.
- Si la nueva versión solapa con una versión futura programada (`desde >= vigenteDesde`), rechazar la operación (Excepción A3) sin truncar la programación futura.
- La constraint GiST `ex_version_receta_no_solape` (`V1__baseline_mr5.sql` L1038–1040) actúa como resguardo relacional definitivo.

---

## 3. Firma de `UC-28` + override manual y apertura de partidas (`G1`)

**Firma canónica** ([CONTRATOS_REV04B_CORREGIDOS_B0_ACTUALIZADO.md §1, L15](../../08-diagramas/consolidacion-b0/CONTRATOS_REV04B_CORREGIDOS_B0_ACTUALIZADO.md#L15)):

```text
registrarPreparacionPedido(
    idPedido: Long,
    idProducto: Long,
    cantidadPreparada: BigDecimal
)
```

### Decisión (`G1`)
Extender el DTO de comando en la capa B3/B4 con un campo **opcional** `List<PartidaAjustePreparacion> partidas` (siguiendo el precedente de `RD-UC42-001` `G2`):
- **Si no se informa (o es nulo/vacío):** selección e imputación automática de partidas utilizables (`cantidadDisponible > 0 AND (fechaVencimiento IS NULL OR fechaVencimiento >= CURRENT_DATE)`) de cada insumo requerido según el orden **D4** de `RD-MR-PARTIDAS-001`:
  `fechaHoraApertura ASC NULLS LAST → fechaVencimiento ASC NULLS LAST → fechaHoraRegistro ASC → idPartidaInsumo ASC`.
- **Si se informa override manual:** validar para cada insumo que las partidas indicadas pertenezcan al insumo, no estén vencidas (`fechaVencimiento IS NULL OR fechaVencimiento >= CURRENT_DATE`), posean `cantidadDisponible >= cantidadAplicada` y cumplan exactamente `SUM(cantidadAplicada) = cantidadInsumoNecesaria`.
- **Preservación de G0:** nunca se sobrescribe ni altera la firma canónica de 3 parámetros del contrato G0; el parámetro opcional de override pertenece a la representación técnica B3/B4 autorizada por `RD-MR-PARTIDAS-001` (D4).

### Apertura implícita y explícita (`D2`)
- **Apertura implícita:** toda partida consumida que tenga `fechaHoraApertura IS NULL` recibe automáticamente `fechaHoraApertura = GREATEST(fechaHoraPreparacion, fechaHoraRegistro)` (respetando `ck_partida_insumo_apertura`).
- **Apertura explícita:** el DTO de partida admite el booleano opcional `marcarApertura` para fijar `fechaHoraApertura = COALESCE(fechaHoraApertura, GREATEST(fechaHoraPreparacion, fechaHoraRegistro))` en envases abiertos durante la preparación.

---

## 4. Fórmula de escalado `BigDecimal`, redondeo y aptitud (`G2`)

**Fórmula de consumo por insumo:**

```text
cantidadConsumida = (cantidadNecesaria × cantidadPreparada) ÷ cantidadRendimientoBase
```

### Reglas ratificadas (`G2`)
1. **Aritmética decimal exacta:** usar `BigDecimal` en toda la cadena de cálculo (prohibido `double`/`float`, conforme a la Regla 9 de `RD-RP022-001`).
2. **Redondeo a escala del modelo:** multiplicar primero `cantidadNecesaria.multiply(cantidadPreparada)` y dividir por `cantidadRendimientoBase` con escala `3` y modo `RoundingMode.HALF_UP`, acorde a `NUMERIC(18,3)` de `MOVIMIENTO_INSUMO.cantidad` y `DETALLE_MOVIMIENTO_PARTIDA.cantidadAplicada`.
3. **Cota inferior positiva:** si el resultado redondeado a escala 3 es `<= 0.000` (violando `ck_movimiento_insumo_1`: `"cantidad" > 0`), rechazar la operación con **400 `CANTIDAD_INSUFICIENTE`**.
4. **Verificación de unidades:** comprobar previamente que `VERSION_RECETA.codigoUnidadRendimiento == PRODUCTO.codigoUnidadVenta` y `DETALLE_VERSION_RECETA.codigoUnidadCantidad == INSUMO.codigoUnidadMedida` (`D-U10-1`).
5. **Validación sobre `stockUtilizable` (D3 de `RD-MR-PARTIDAS-001`):** para cada insumo de la receta, la suma de `cantidadDisponible` de sus partidas no vencidas (`fechaVencimiento IS NULL OR fechaVencimiento >= CURRENT_DATE`) debe ser `>= cantidadConsumida`. En caso contrario (incluso si `INSUMO.stockActual` físico fuera suficiente por existir partidas vencidas), rechazar atómicamente con **409 `STOCK_UTILIZABLE_INSUFICIENTE`** (Excepción A4).

---

## 5. Literal de `origen` en `MOVIMIENTO_INSUMO` (`G4`)

**Decisión (`G4`):** para todo movimiento generado por `UC-28` (`tipoMovimiento = 'CONSUMO_PRODUCCION'`), registrar:
- `MOVIMIENTO_INSUMO.origen = 'PRODUCCION'` (consistente con `TrazabilidadPartidasMigrationTest:204`).
- `idPreparacion = <idPreparacion creada>`, `idRecepcionCompra = NULL`.
- `referenciaOrigen = NULL`, `motivo = NULL`, `observacion = NULL`.

---

## 6. Evaluación de `PRA-01` mediante `EpisodioFaltanteService` (`G5`)

**Decisión (`G5`):**
- Tras registrar cada `MOVIMIENTO_INSUMO` de tipo `CONSUMO_PRODUCCION` y actualizar `INSUMO.stockActual`, `UC-28` invoca `EpisodioFaltanteService.evaluarApertura(idInsumo, nuevoStock, umbralMinimo, idMovimientoInsumo)`.
- **No emite `SOLICITUD_COTIZACION`:** la emisión de la primera ronda automática de cotización corresponde al bloque de Compras/Cotizaciones (`I5`), manteniendo la separación de responsabilidades ya implementada en `EpisodioFaltanteService` (`I1-06` / `B4-06`).
- Reutiliza el servicio existente en `main` sin duplicar SQL ni lógica de apertura/cierre de `EPISODIO_FALTANTE` (por simetría, `evaluarCierre` permanece disponible en el mismo servicio para operaciones de incremento de stock).

---

## 7. Orden canónico de locks e idempotencia en `UC-28` (`G6`)

### Orden de adquisición de locks (`G6`)
Para impedir condiciones de carrera sobre el límite de preparación del pedido y evitar deadlocks con `UC-08`, `UC-42`, `UC-05` y `UC-06`:
1. Bloquear la cabecera y el detalle del pedido:
   `SELECT ... FROM "PEDIDO" WHERE "idPedido" = :idPedido FOR UPDATE` (+ `DETALLE_PEDIDO FOR UPDATE`).
2. Adquirir el advisory lock transaccional de inventario/secuencias:
   `SELECT pg_advisory_xact_lock(808, 0)` (serializa los generadores `MAX+1` de `PREPARACION`, `MOVIMIENTO_INSUMO`, `PARTIDA_INSUMO` y `EPISODIO_FALTANTE`).
3. Para cada `idInsumo` de `DETALLE_VERSION_RECETA` **ordenado por `idInsumo ASC`**:
   - `SELECT pg_advisory_xact_lock(idInsumo)`
   - `SELECT ... FROM "INSUMO" WHERE "idInsumo" = :idInsumo FOR UPDATE`
   - `SELECT ... FROM "PARTIDA_INSUMO" WHERE "idInsumo" = :idInsumo ... FOR UPDATE` (ordenadas por criterio D4).

### Criterio de idempotencia
- La firma canónica de `UC-28` no incluye clave de idempotencia (es una operación online de producción según `RD-F04-001`).
- Se aplica el mismo criterio ratificado para `UC-42` en `RD-UC42-001` (`G4`): la deduplicación por clave de operación queda pendiente para una eventual `RD-UC28-002` futura.
- La validación transaccional bajo `PEDIDO FOR UPDATE` de `cantidadPreparadaPropiaAcumulada + cantidadPreparada <= cantidadOriginal` (Excepción A2 del contrato) garantiza que jamás se supere el total original solicitado del ítem, aunque no impide duplicar un registro parcial si la suma acumulada aún cabe dentro de `cantidadOriginal`.

---

## 8. Actualización de `BuscarPedidoService` (`UC-34`) para `RESPONSABLE_PRODUCCION`

### Contexto
En `I2-02` (`BuscarPedidoService`), `GET /api/v1/pedidos` habilitó a `ADMINISTRADOR`, `VENDEDOR` y `REPARTIDOR` (contextual), postergando `RESPONSABLE_PRODUCCION` hasta la existencia de `UC-28`. Conforme a `B0_MATRIZ_RBAC_67_OPERACIONES_CIERRE_2026-10-29.csv` (L38) y `BC07_PROYECCIONES_MINIMAS_RATIFICADAS_2026-10-29.csv` (L6), `PRODUCCION` posee permiso contextual `C` en `UC-34` exclusivamente para `UC-28`.

### Decisión
El corte de implementación de `UC-28` actualizará `BuscarPedidoService` (`UC-34`) para:
1. Aceptar sesiones con rol `RESPONSABLE_PRODUCCION` aplicando la proyección mínima `BC-07` contextual (restringida a pedidos en estado `PENDIENTE` que posean al menos un `DETALLE_PEDIDO` de producto `ELABORADO` con preparación propia pendiente: `cantidadOriginal > COALESCE(SUM(cantidadPreparada), 0)`).
2. Si un actor que solo posee ámbito de `PRODUCCION` intenta consultar por `idPedido` un pedido que no pertenece al contexto de preparación (no `PENDIENTE` o sin ítems `ELABORADO` pendientes de preparar), rechazar con **403 `FUERA_DE_CONTEXTO`**.
3. Si la búsqueda general o filtrada dentro del contexto de preparación no arroja pedidos elegibles, retornar **200 `[]`** (contexto válido sin resultados).

---

## 9. Invariantes, dependencias y firmas

### Invariantes de gobernanza
- **NO modifica G0:** `source_commit = 1263ffc17bd0eb7f3c69faaa9ff5ae556cf9de7e` y `governance_commit = 27738b089afdd2698cdae915f75c0e8089a6248a` permanecen inmutables.
- **NO modifica MR-5/F01 ni MR-6 (`V1`, `V2`, `V3`).**
- **NO modifica `source-lock.md`** en `ale-milanesas-app` (no introduce cambios de esquema ni nuevas migraciones Flyway).
- **NO modifica ni reescribe** `CONTRATOS_REV06B_TRECE_CORREGIDOS.md`, `CONTRATOS_REV04B_CORREGIDOS_B0_ACTUALIZADO.md`, `RD-MR-PARTIDAS-001`, `RD-RP022-001`, `RD-UC19-002`, `RD-UC08-001` ni `RD-UC42-001`.
- **Issue #28 (pausa de despliegue) permanece ABIERTA:** los endpoints de escritura de `UC-10` y `UC-28` deberán incorporar el triple gate no-prod (`@Profile("!prod")` + `@ConditionalOnProperty(..., havingValue = "true", matchIfMissing = false)` + veto en `PrecondicionesDespliegue`).

### Dependencias (RDs predecesoras en `main`)
- `RD-B0-G0-001` (`1263ffc17bd0eb7f3c69faaa9ff5ae556cf9de7e`)
- `RD-RP022-001` (costeo, conversiones y redondeos)
- `RD-UC19-002` (`255f679` — acotamiento prospectivo de vigencias sin truncar futuras)
- `RD-MR-PARTIDAS-001` (`cd603d25addb4312d9bee62ec03514760f7e2894` — `PARTIDA_INSUMO` y `DETALLE_MOVIMIENTO_PARTIDA`, reglas D1–D4) + `ADENDA_MR6_IMPACTO_8_UC_2026-11-07.md` (`6bea1c0`)
- `RD-UC08-001` (`ee555ba9d020aaf66f1f95e1e4e73d99a9235448`)
- `RD-UC42-001` (`d7762f6` — desglose por partidas, apertura de envases y `EpisodioFaltanteService`)

### Firmas

**Decisión ratificada por:** Victor Leandro Machado (`leandrito369`) — Responsable del proyecto.  
**Fecha:** 11/11/2026.
