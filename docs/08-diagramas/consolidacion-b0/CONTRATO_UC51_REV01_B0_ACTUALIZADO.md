> **Consolidación de referencias B0-BC05 — 29/10/2026:** 1 operación(es). Fuentes Fase 4 y propuesta revisión `64af3c3baa571c2d512242e396267a31f0da3efd`. Original REV no modificado; adenda aceptada por el responsable y propagada como anotación de trazabilidad. **No** certifica API ni contrato gráfico. 

# REV-01 — Contrato de operación de UC-51: Modificar Insumo

**Estado:** PROPUESTA PARA VALIDACIÓN; no sustituye aún la ficha académica original. **Procedencia:** contrato conjunto Gemini 6A.3, separado para UC-51, y RD-RP017-001 del 27/10/2026.

## 1. Nombre
`buscarYModificarInsumo(criterio: FiltroInsumoDTO, datosNoHistoricosPermitidos: DatosInsumo, codigoUnidadMedidaPropuesto: CodigoUnidadMedida?)`.

El evento público queda homologado al DSS del Administrador y al DS revisado; la búsqueda UC-36 se representa internamente. La firma es una abstracción de análisis/diseño, no una API implementada ni un conjunto de columnas nuevas. Las claves exactas de `DatosInsumo` deben cotejarse con el CU Real y el diccionario.

## 2. Responsabilidades
Modificar información permitida de un Insumo existente y, solo si no registra **ningún movimiento de inventario ni ningún registro histórico de costo**, permitir el cambio de su unidad de medida. Preservar el historial y rechazar modificaciones que pretendan alterar existencias, costos pasados o relaciones históricas.

## 3. Tipo
Sistema.

## 4. Referencias cruzadas
UC-51 — Modificar Insumo; «include» UC-36 — Buscar Insumo (aprobado 25/10); RD-RP017-001; RD-RP016-001; RD-RP022-001; UC-42; UC-31; diccionario MR-5/MR-6 de `INSUMO`, `MOVIMIENTO_INSUMO` y `COSTO_INSUMO_HISTORICO`.

**Adenda B0-BC05 (referencias canónicas de Fase 4):** RF-04,RF-05. Referencias contenidas en el contrato anterior: sin RF literal. Esta adenda complementa/rectifica la trazabilidad del apartado 4, sin incorporar requisitos, pre/postcondiciones, roles ni operaciones nuevos. Cualquier dependencia transversal se identifica en el contrato del CU invocado.

## 5. Notas
- La restricción de unidad de medida se activa **si existe al menos un movimiento O al menos un registro de costo histórico**, independientemente del stock actual.
- La ausencia de movimientos no basta: deben faltar también los costos históricos. El bloqueo se revalida en el servidor y dentro del control transaccional de la operación; la información consultada antes podría haber cambiado.
- Cuando exista historia, un cambio de unidad exige **crear otro Insumo**, sin migración silenciosa de cantidad, historial, receta, costo o referencias.
- Se puede modificar descripción y otros datos no históricos permitidos, sujetos a autorización y validación. Esta RD no define por sí misma todos los campos editables.
- La edición no registra `SALDO_INICIAL`, no crea `MovimientoInsumo` ni `CostoInsumoHistorico` y no cambia `stockActual`. Los parámetros de reposición se gestionan por UC-31 cuando corresponda.
- La condición previa de Gemini «Recetas, Compras o Movimientos» se reemplaza **para la regla específica de unidad** por el criterio aprobado «Movimientos o Costos históricos». Cualquier restricción adicional por dependencias de Recetas/Compras requiere referencia específica de la ficha vigente; no se deroga ni se aprueba por inferencia.

## 6. Excepciones
- **E1:** Insumo inexistente o no seleccionable mediante UC-36: no modificar.
- **E2:** Usuario sin autorización o datos no admisibles: no modificar.
- **E3:** Cambio de unidad solicitado cuando existe al menos un movimiento o costo histórico: rechazar el cambio de unidad, sin alterar el registro.
- **E4:** Unidad propuesta inexistente/incompatible o dato no histórico inválido: rechazar.
- **E5:** Nombre duplicado según la política vigente: rechazar.
- **E6:** Concurrencia: se crea un movimiento o costo histórico antes de confirmar el cambio de unidad: rechazar de manera atómica.
- **E7:** Se intenta cambiar stock, costos históricos o campos no autorizados a través de UC-51: rechazar esa operación.

## 7. Salida
Confirmación de la modificación permitida o rechazo con causa específica. No se devuelve un movimiento ni una transferencia de inventario.

## 8. Precondiciones
**Administrador** autenticado y autorizado; Insumo existente y seleccionado mediante UC-36; datos editables y unidad propuesta, si existe, conforme a restricciones vigentes. Para modificar unidad, ausencia de movimientos y costos históricos verificada a la confirmación.

## 9. Postcondiciones
**Éxito:** se actualizan únicamente atributos autorizados de la instancia `unInsumo:Insumo`. Si se solicitó cambio de `codigoUnidadMedida`, se modifica únicamente cuando **no existe movimiento ni costo histórico** y esa condición fue verificada al confirmar. `stockActual`, movimientos y costos históricos existentes permanecen intactos. No se crean otras instancias de Insumo ni transferencias.

**Rechazo:** los atributos y asociaciones de `unInsumo` permanecen sin cambios. La información histórica permanece intacta.

## Glosario
**Historial de inventario:** cualquier movimiento registrado del Insumo, aunque el saldo actual sea cero. **Costo histórico:** registro de costo del Insumo, independiente de que haya movimientos. **Unidad de medida:** atributo base que expresa existencias y costos por unidad. **Modificación no histórica:** cambio permitido que no reinterpreta movimientos o costos previos.

## Pendencias
Validación literal con las fichas Real/Extendida UC-51; alcance exacto de atributos modificables; rol/permiso efectivo y dependencias adicionales de recetas y compras; precisión del mecanismo transaccional; QA visual/editabilidad Draw.io y coherencia secuencial completa DSS–DS–Contrato. **No se ejecutaron servicios ni SQL.**
