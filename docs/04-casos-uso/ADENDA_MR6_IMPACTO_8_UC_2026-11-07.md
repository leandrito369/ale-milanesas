# Adenda MR-6 — Impacto de PARTIDA_INSUMO en 8 UCs

**Fecha:** 07/11/2026
**Autoridad:** RD-MR-PARTIDAS-001 (merge `cd603d25addb4312d9bee62ec03514760f7e2894`)
**RP:** RP-MR-002 (merge `e3e60e9f59e1d149f65959cf5c84376c1eea2935`)
**Implementación:** V3 `ab648c0` en `ale-milanesas-app`
**Estado:** adenda documental; no modifica fichas Fase 4 ni contratos canónicos de G0

## Contexto

MR-6 amplía el Modelo Relacional de 60 a 62 tablas incorporando `PARTIDA_INSUMO` y `DETALLE_MOVIMIENTO_PARTIDA` para trazabilidad física de existencias de Insumos (lotes, vencimientos, aperturas, procedencia de consumos). Esta adenda documenta el impacto en los 8 UCs afectados sin modificar las fichas Fase 4 (`.docx` bajo candado SHA de G0) ni los contratos canónicos.

## Impacto en UCs

### UC-08 — Registrar Ingreso de Stock por Compra {#uc-08}

**Cambio funcional:** al registrar una `RECEPCION_COMPRA`, el Responsable de Producción informa el desglose de envases/partidas recibidas (o una única partida por el total recibido), indicando para cada una: `cantidadInicial`, `codigoLote` (opcional), `fechaFabricacion` (opcional) y `fechaVencimiento` (opcional según tipo de insumo).

**Postcondiciones añadidas:**
- Se crearon N instancias en `PARTIDA_INSUMO` vinculadas a `idRecepcionCompra` e `idInsumo`, con `cantidadDisponible = cantidadInicial`, `fechaHoraRegistro = fechaHoraRecepcion` y `fechaHoraApertura = NULL`.
- Por cada partida creada, se registró su vínculo en `DETALLE_MOVIMIENTO_PARTIDA` asociado al `MOVIMIENTO_INSUMO` de tipo `INGRESO_COMPRA`, cumpliéndose `Σ cantidadAplicada = RECEPCION_COMPRA.cantidadRecibida`.

**Tablas afectadas:**
- `PARTIDA_INSUMO` (nueva)
- `DETALLE_MOVIMIENTO_PARTIDA` (nueva)
- `RECEPCION_COMPRA`, `MOVIMIENTO_INSUMO`, `COSTO_INSUMO_HISTORICO`, `INSUMO` (existentes)

**Compatibilidad:** aditivo, no rompe flujos existentes.

**Estado de implementación:** contrato `REV03B §7` (`registrarIngresoStockPorCompra`). PR en curso: B4-04 (solo INSUMO). REVENTA en PR posterior.

**Referencias específicas:** [CONTRATOS_REV03B_CORREGIDOS.md §7](https://github.com/leandrito369/ale-milanesas/blob/1263ffc17bd0eb7f3c69faaa9ff5ae556cf9de7e/docs/08-diagramas/revision/REV03_COMPRAS/propuestos/CONTRATOS_REV03B_CORREGIDOS.md)

---

### UC-09 — Consultar Stock {#uc-09}

**Cambio funcional:** exponer `stockUtilizable` (suma de `cantidadDisponible` de partidas no vencidas: `cantidadDisponible > 0 AND (fechaVencimiento IS NULL OR fechaVencimiento >= fechaActual)`) junto a `stockActual`. Listar las partidas activas (`cantidadDisponible > 0`) ordenadas según la regla D4: (1) envases abiertos por `fechaHoraApertura ASC`, (2) FEFO por `fechaVencimiento ASC NULLS LAST`, (3) antigüedad por `fechaHoraRegistro ASC`.

**Postcondiciones añadidas:**
- La proyección de consulta incluye `stockUtilizable` además de `stockActual` y el detalle de partidas activas ordenadas por D4 (sin alterar registros persistidos).

**Tablas afectadas:**
- `PARTIDA_INSUMO` (nueva)
- `DETALLE_MOVIMIENTO_PARTIDA` (nueva)
- `INSUMO`, `PRODUCTO` (existentes)

**Compatibilidad:** aditivo, no rompe flujos existentes.

**Estado de implementación:** contrato `REV06B §12` (`consultarStock`). Migración V3 aplicada en `ale-milanesas-app` (`ab648c0`); ajuste de consulta por partidas en curso.

**Referencias específicas:** [CONTRATOS_REV06B_TRECE_CORREGIDOS.md §12](https://github.com/leandrito369/ale-milanesas/blob/1263ffc17bd0eb7f3c69faaa9ff5ae556cf9de7e/docs/08-diagramas/revision/REV06B_CLIENTES_RECETAS_INVENTARIO/propuestos/CONTRATOS_REV06B_TRECE_CORREGIDOS.md)

---

### UC-28 — Registrar Preparación de Pedido {#uc-28}

**Cambio funcional:** verificar `stockUtilizable` (no solo `stockActual`). Proponer automáticamente las partidas a consumir ordenadas por la regla D4: (1) envases abiertos por `fechaHoraApertura ASC`, (2) FEFO por `fechaVencimiento ASC NULLS LAST`, (3) antigüedad por `fechaHoraRegistro ASC`, permitiendo override manual sobre otras partidas utilizables. Excepción nueva: rechazar el consumo si `stockUtilizable < requerido` aunque `stockActual` físico alcance (las partidas vencidas quedan bloqueadas para producción). Apertura implícita: el primer consumo sobre una partida con `fechaHoraApertura IS NULL` fija automáticamente `fechaHoraApertura = fechaHoraPreparacion` (admitiéndose también apertura explícita).

**Postcondiciones añadidas:**
- Por cada `MOVIMIENTO_INSUMO` de tipo `CONSUMO_PRODUCCION`, se registraron una o más filas en `DETALLE_MOVIMIENTO_PARTIDA` tales que `Σ cantidadAplicada = MOVIMIENTO_INSUMO.cantidad`.
- Se actualizó `PARTIDA_INSUMO.cantidadDisponible` en cada partida imputada y se fijó `fechaHoraApertura` en las partidas que se encontraban cerradas.

**Tablas afectadas:**
- `PARTIDA_INSUMO` (nueva)
- `DETALLE_MOVIMIENTO_PARTIDA` (nueva)
- `PREPARACION`, `PEDIDO`, `DETALLE_PEDIDO`, `VERSION_RECETA`, `DETALLE_VERSION_RECETA`, `INSUMO`, `MOVIMIENTO_INSUMO`, `COSTO_INSUMO_HISTORICO`, `PRODUCTO`, `MOVIMIENTO_STOCK_REVENTA` (existentes)

**Compatibilidad:** aditivo, no rompe flujos existentes.

**Estado de implementación:** contrato `REV04B §1` (`registrarPreparacionPedido`). Migración V3 aplicada en `ale-milanesas-app` (`ab648c0`). Ajuste de B3 para emitir `DETALLE_MOVIMIENTO_PARTIDA` y selección FEFO en curso.

**Referencias específicas:** [CONTRATOS_REV04B_CORREGIDOS_B0_ACTUALIZADO.md §1](https://github.com/leandrito369/ale-milanesas/blob/1263ffc17bd0eb7f3c69faaa9ff5ae556cf9de7e/docs/08-diagramas/consolidacion-b0/CONTRATOS_REV04B_CORREGIDOS_B0_ACTUALIZADO.md)

---

### UC-31 — Configurar Parámetros de Reposición de Insumo {#uc-31}

**Cambio funcional:** informar las partidas vencidas que reducen el `stockUtilizable` frente a `umbralMinimo`. La apertura y gestión de `EPISODIO_FALTANTE` continúa disparándose y evaluándose sobre `INSUMO.stockActual` físico, sin cambios en la especificación de `PRA-01` (cualquier evaluación de umbral sobre `stockUtilizable` queda reservada a `RD-MR-UMBRAL-UTILIZABLE-001`).

**Postcondiciones añadidas:**
- La vista/respuesta de configuración expone de forma informativa `stockUtilizable` y la cantidad retenida en partidas vencidas junto a `stockActual`, manteniendo intactas las reglas de disparo de `EPISODIO_FALTANTE`.

**Tablas afectadas:**
- `PARTIDA_INSUMO` (nueva)
- `DETALLE_MOVIMIENTO_PARTIDA` (nueva)
- `INSUMO`, `EPISODIO_FALTANTE`, `CONFIGURACION_OPERATIVA` (existentes)

**Compatibilidad:** aditivo, no rompe flujos existentes.

**Estado de implementación:** contrato `REV06B §10` (`configurarParametrosReposicionInsumo`). Migración V3 aplicada en `ale-milanesas-app` (`ab648c0`); ajuste de B3 en curso.

**Referencias específicas:** [CONTRATOS_REV06B_TRECE_CORREGIDOS.md §10](https://github.com/leandrito369/ale-milanesas/blob/1263ffc17bd0eb7f3c69faaa9ff5ae556cf9de7e/docs/08-diagramas/revision/REV06B_CLIENTES_RECETAS_INVENTARIO/propuestos/CONTRATOS_REV06B_TRECE_CORREGIDOS.md)

---

### UC-36 — Buscar Insumo {#uc-36}

**Cambio funcional:** mostrar en los resultados de búsqueda el resumen de partidas del insumo: total de partidas disponibles (`cantidadDisponible > 0`), cuántas se encuentran abiertas (`fechaHoraApertura IS NOT NULL`) y cuántas están próximas a vencer (en ventanas de 7, 15 y 30 días), respetando las proyecciones de visibilidad `BC-07`.

**Postcondiciones añadidas:**
- La proyección de búsqueda incorpora los indicadores agregados de partidas disponibles, abiertas y próximas a vencer sin alterar datos persistidos ni exponer costos históricos no autorizados.

**Tablas afectadas:**
- `PARTIDA_INSUMO` (nueva)
- `DETALLE_MOVIMIENTO_PARTIDA` (nueva)
- `INSUMO`, `UNIDAD_MEDIDA` (existentes)

**Compatibilidad:** aditivo, no rompe flujos existentes.

**Estado de implementación:** contrato `REV06B §8` (`buscarInsumo`). Migración V3 aplicada en `ale-milanesas-app` (`ab648c0`); ajuste de proyecciones de consulta en curso.

**Referencias específicas:** [CONTRATOS_REV06B_TRECE_CORREGIDOS.md §8](https://github.com/leandrito369/ale-milanesas/blob/1263ffc17bd0eb7f3c69faaa9ff5ae556cf9de7e/docs/08-diagramas/revision/REV06B_CLIENTES_RECETAS_INVENTARIO/propuestos/CONTRATOS_REV06B_TRECE_CORREGIDOS.md)

---

### UC-42 — Registrar Ajuste de Inventario {#uc-42}

**Cambio funcional:** los movimientos de tipo `SALDO_INICIAL` y `AJUSTE_POSITIVO` crean nuevas partidas en `PARTIDA_INSUMO` con `idRecepcionCompra = NULL` y sus correspondientes filas en `DETALLE_MOVIMIENTO_PARTIDA`. Los movimientos de tipo `AJUSTE_NEGATIVO` descuentan de la partida específica seleccionada por el actor (incluyendo el descarte de partidas vencidas). Se permite registrar apertura explícita en mermas parciales sobre envases cerrados.

**Postcondiciones añadidas:**
- En `SALDO_INICIAL` / `AJUSTE_POSITIVO`, se crearon N filas en `PARTIDA_INSUMO` (`idRecepcionCompra = NULL`) y N filas en `DETALLE_MOVIMIENTO_PARTIDA` con `Σ cantidadAplicada = MOVIMIENTO_INSUMO.cantidad`.
- En `AJUSTE_NEGATIVO`, se registraron las filas en `DETALLE_MOVIMIENTO_PARTIDA` sobre las partidas seleccionadas, actualizándose `PARTIDA_INSUMO.cantidadDisponible` (y `fechaHoraApertura` cuando corresponda).

**Tablas afectadas:**
- `PARTIDA_INSUMO` (nueva)
- `DETALLE_MOVIMIENTO_PARTIDA` (nueva)
- `INSUMO`, `MOVIMIENTO_INSUMO`, `COSTO_INSUMO_HISTORICO`, `PRODUCTO`, `MOVIMIENTO_STOCK_REVENTA`, `VALORACION_EXTRAORDINARIA_REVENTA` (existentes)

**Compatibilidad:** aditivo, no rompe flujos existentes.

**Estado de implementación:** contrato `REV01 UC-42` (`registrarAjusteInventario`). Migración V3 aplicada en `ale-milanesas-app` (`ab648c0`, incluyendo soporte de `SALDO_INICIAL` en el trigger de `cantidadDisponible`). Ajuste de B3 para emitir `DETALLE_MOVIMIENTO_PARTIDA` en curso.

**Referencias específicas:** [CONTRATO_UC42_REV01_B0_ACTUALIZADO.md](https://github.com/leandrito369/ale-milanesas/blob/1263ffc17bd0eb7f3c69faaa9ff5ae556cf9de7e/docs/08-diagramas/consolidacion-b0/CONTRATO_UC42_REV01_B0_ACTUALIZADO.md)

---

### UC-51 — Modificar Insumo {#uc-51}

**Cambio funcional:** `PARTIDA_INSUMO` se incorpora al conjunto de referencias históricas que bloquean la modificación de `codigoUnidadMedida` del insumo. Si el insumo registra partidas asociadas, el sistema impide cambiar su unidad de medida base.

**Postcondiciones añadidas:**
- La verificación de dependencias históricas previa al cambio de `codigoUnidadMedida` incluye la existencia de registros en `PARTIDA_INSUMO` además de recetas, movimientos, recepciones, costos, proveedores y episodios.

**Tablas afectadas:**
- `PARTIDA_INSUMO` (nueva)
- `DETALLE_MOVIMIENTO_PARTIDA` (nueva)
- `INSUMO`, `UNIDAD_MEDIDA` (existentes)

**Compatibilidad:** aditivo, no rompe flujos existentes.

**Estado de implementación:** contrato `REV01 UC-51` (`buscarYModificarInsumo`). Migración V3 aplicada en `ale-milanesas-app` (`ab648c0`). Ajuste de verificación de dependencias en B3 en curso.

**Referencias específicas:** [CONTRATO_UC51_REV01_B0_ACTUALIZADO.md](https://github.com/leandrito369/ale-milanesas/blob/1263ffc17bd0eb7f3c69faaa9ff5ae556cf9de7e/docs/08-diagramas/consolidacion-b0/CONTRATO_UC51_REV01_B0_ACTUALIZADO.md)

---

### UC-64 — Consultar Movimientos de Inventario {#uc-64}

**Cambio funcional:** expandir cada `MOVIMIENTO_INSUMO` con su desglose en `DETALLE_MOVIMIENTO_PARTIDA` (`idPartidaInsumo`, `codigoLote`, `fechaVencimiento`, `cantidadAplicada`), permitiendo auditar el origen o destino físico exacto de cada ingreso, ajuste o consumo de inventario.

**Postcondiciones añadidas:**
- La consulta retorna para cada `MOVIMIENTO_INSUMO` las filas asociadas de `DETALLE_MOVIMIENTO_PARTIDA` junto con los metadatos de trazabilidad de `PARTIDA_INSUMO`, respetando las reglas de visibilidad `BC-07`.

**Tablas afectadas:**
- `PARTIDA_INSUMO` (nueva)
- `DETALLE_MOVIMIENTO_PARTIDA` (nueva)
- `MOVIMIENTO_INSUMO`, `MOVIMIENTO_STOCK_REVENTA`, `INSUMO`, `PRODUCTO` (existentes)

**Compatibilidad:** aditivo, no rompe flujos existentes.

**Estado de implementación:** contrato `REV06B §13` (`consultarMovimientosInventario`). Migración V3 aplicada en `ale-milanesas-app` (`ab648c0`). Ajuste de consulta en B3 en curso.

**Referencias específicas:** [CONTRATOS_REV06B_TRECE_CORREGIDOS.md §13](https://github.com/leandrito369/ale-milanesas/blob/1263ffc17bd0eb7f3c69faaa9ff5ae556cf9de7e/docs/08-diagramas/revision/REV06B_CLIENTES_RECETAS_INVENTARIO/propuestos/CONTRATOS_REV06B_TRECE_CORREGIDOS.md)

## Referencias

- [RD-MR-PARTIDAS-001](https://github.com/leandrito369/ale-milanesas/blob/cd603d25addb4312d9bee62ec03514760f7e2894/docs/01-gobierno/b0/RD_MR_PARTIDAS_001_AMPLIACION_MR_PARTIDA_INSUMO_2026-11-06.md)
- [RP-MR-002](https://github.com/leandrito369/ale-milanesas/blob/e3e60e9f59e1d149f65959cf5c84376c1eea2935/docs/01-gobierno/rp/RP_MR_002_PARTIDA_INSUMO_2026-11-06.md)
- [Migración V3](https://github.com/leandrito369/ale-milanesas-app/blob/ab648c0/src/main/resources/db/migration/V3__trazabilidad_partidas_insumo.sql)
- [source-lock.md con adenda RD-MR-PARTIDAS-001](https://github.com/leandrito369/ale-milanesas-app/blob/ab648c0/docs/traceability/source-lock.md)
