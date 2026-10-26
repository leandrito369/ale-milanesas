# Diccionario explicativo del Modelo Relacional — Ale Milanesas

**Corte documental:** 26/10/2026 · **Diseño físico:** MR-3 + MR-5 validado parcialmente por MR-6 en PostgreSQL 17.11.

**Cobertura:** 60 tablas, 453 atributos físicos y 125 claves foráneas. El modelo no equivale a un sistema implementado ni a certificación de producción.

## Criterio de lectura

- **PK:** clave primaria, simple o compuesta, que identifica cada fila. En una PK compuesta la unicidad corresponde al conjunto de columnas.
- **FK:** clave foránea (columna o grupo de columnas) cuyos valores referencian una clave de otra tabla. No es herencia entre entidades; mantiene la integridad referencial.
- **NN:** NOT NULL, el atributo se exige en cada fila. Una FK sin NN es opcional para el registro hijo, aunque puede existir una regla condicional adicional.
- **Fuentes:** diccionario MR-3 (60 tablas), DDL MR-5, informe MR-6 y guía explicativa del modelo de 59 tablas del 23/10. Las notas de función son explicaciones de estudio, no requisitos nuevos.
- **Pendiente vigente:** F01 — catálogo literal completo de `COBRO.estadoCobro`. No inferir sus valores a partir de datos sintéticos de laboratorio.

## Índice de áreas

- 1. Productos, insumos, recetas y producción
- 2. Pedidos, entregas y excedentes
- 3. Precios, promociones y políticas comerciales
- 4. Clientes, usuarios y autenticación
- 5. Proveedores, abastecimiento y compras
- 6. Inventario de productos de reventa
- 7. Cobros, cuenta corriente, caja y reembolsos

## Área 1 — Productos, insumos, recetas y producción

### 01. `UNIDAD_MEDIDA`

Catálogo común de unidades de medida; evita registrar la misma unidad con nombres diferentes.

**PK:** `codigoUnidad`. Identifica una fila de esta tabla.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `codigoUnidad` | `VARCHAR(20)` · PK/NN | Código estable para identificar unidad dentro del proceso correspondiente. PK: identifica de forma única cada fila de UNIDAD_MEDIDA; impide dos registros con la misma clave. |
| `nombre` | `VARCHAR(100)` · NN | Denominación utilizada para reconocer el registro en operaciones y consultas.  |


### 02. `PRODUCTO`

Catálogo de productos ELABORADOS y de REVENTA; conserva su identidad, estado y, para REVENTA, stock y costo promedio vigentes.

**PK:** `idProducto`. Identifica una fila de esta tabla.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idProducto` | `BIGINT` · PK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK: identifica de forma única cada fila de PRODUCTO; impide dos registros con la misma clave. |
| `nombre` | `VARCHAR(150)` · NN | Denominación utilizada para reconocer el registro en operaciones y consultas.  |
| `nombreNormalizado` | `VARCHAR(150)` · NN | Nombre normalizado utilizado para detectar duplicados; se genera a partir del nombre y no debe editarse de manera independiente.  |
| `descripcion` | `TEXT` · NULL | Texto descriptivo del elemento, mostrado para identificar su contenido o condiciones.  |
| `tipoProducto` | `VARCHAR(20)` · NN | Distingue Producto ELABORADO de Producto de REVENTA; determina qué modalidad de inventario se aplica.  |
| `codigoUnidadVenta` | `VARCHAR(20)` · FK/NN | Unidad en la que se expresa la venta de un Producto; en el Detalle se congela la unidad aplicada a esa operación. FK: se almacena para referenciar UNIDAD_MEDIDA(`codigoUnidad`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `activo` | `BOOLEAN` · NN | Permite o impide nuevas operaciones con el catálogo sin borrar su historial previo.  |
| `stockActualReventa` | `NUMERIC(18,3)` · NULL | Cantidad actualmente disponible del Producto de REVENTA; no se utiliza como stock para ELABORADOS.  |
| `costoPromedioActualReventa` | `NUMERIC(18,4)` · NULL | Costo promedio móvil vigente de unidades REVENTA, separado de los costos históricos ya aplicados.  |


### 03. `INSUMO`

Materias primas usadas en producción; registra existencias, mínimo y objetivo de reposición.

**PK:** `idInsumo`. Identifica una fila de esta tabla.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idInsumo` | `BIGINT` · PK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK: identifica de forma única cada fila de INSUMO; impide dos registros con la misma clave. |
| `nombre` | `VARCHAR(150)` · NN | Denominación utilizada para reconocer el registro en operaciones y consultas.  |
| `codigoUnidadMedida` | `VARCHAR(20)` · FK/NN | Unidad de medida utilizada para expresar el insumo o la cantidad efectivamente recibida, según la tabla. FK: se almacena para referenciar UNIDAD_MEDIDA(`codigoUnidad`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `stockActual` | `NUMERIC(18,3)` · NN | Saldo físico actual del Insumo, actualizado por los movimientos de inventario.  |
| `umbralMinimo` | `NUMERIC(18,3)` · NN | Nivel mínimo de Insumo cuya superación a la baja puede iniciar la reposición.  |
| `nivelObjetivoReposicion` | `NUMERIC(18,3)` · NN | Cantidad objetivo de Insumo hacia la que se procura recuperar el inventario.  |
| `automatizacionCompraActiva` | `BOOLEAN` · NN | Indica si el Insumo puede activar la primera ronda automática de cotización.  |
| `activo` | `BOOLEAN` · NN | Permite o impide nuevas operaciones con el catálogo sin borrar su historial previo.  |


### 04. `RECETA`

Identidad estable de la receta asociada a un Producto ELABORADO; sus cambios se expresan en versiones.

**PK:** `idReceta`. Identifica una fila de esta tabla.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idReceta` | `BIGINT` · PK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK: identifica de forma única cada fila de RECETA; impide dos registros con la misma clave. |
| `idProducto` | `BIGINT` · FK/NN | Asocia la Receta a un único Producto ELABORADO; su UNIQUE impide más de una identidad de receta por Producto. FK: se almacena para referenciar PRODUCTO(`idProducto`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |


### 05. `VERSION_RECETA`

Cada versión histórica de una receta, con vigencia y rendimiento; evita sobrescribir fórmulas anteriores.

**PK:** `idReceta` + `numeroVersion`. Clave compuesta: el identificador es la combinación de estos campos.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idReceta` | `BIGINT` · PK/FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK compuesta: participa con `numeroVersion` para distinguir inequívocamente cada fila; esta columna sola no tiene por qué ser única. FK: se almacena para referenciar RECETA(`idReceta`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `numeroVersion` | `INTEGER` · PK/NN | Número de versión histórica de Receta o Política, que evita sobrescribir versiones anteriores. PK compuesta: participa con `idReceta` para distinguir inequívocamente cada fila; esta columna sola no tiene por qué ser única. |
| `vigenteDesde` | `TIMESTAMPTZ` · NN | Comienzo inclusivo del intervalo de validez de la versión o asociación.  |
| `vigenteHasta` | `TIMESTAMPTZ` · NULL | Final exclusivo, opcional, del intervalo de validez; NULL puede expresar vigencia abierta.  |
| `cantidadRendimientoBase` | `NUMERIC(18,3)` · NN | Rendimiento de referencia de la receta en esa versión, utilizado para escalar cantidades.  |
| `codigoUnidadRendimiento` | `VARCHAR(20)` · FK/NN | Unidad en la que se mide el rendimiento de una Versión de Receta. FK: se almacena para referenciar UNIDAD_MEDIDA(`codigoUnidad`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |


### 06. `DETALLE_VERSION_RECETA`

Insumos y cantidades necesarios para una versión específica de receta; resuelve una relación muchos a muchos.

**PK:** `idReceta` + `numeroVersion` + `idInsumo`. Clave compuesta: el identificador es la combinación de estos campos.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idReceta` | `BIGINT` · PK/FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK compuesta: participa con `numeroVersion`, `idInsumo` para distinguir inequívocamente cada fila; esta columna sola no tiene por qué ser única. FK: se almacena para referenciar VERSION_RECETA(`idReceta`, `numeroVersion`) mediante la FK compuesta (`idReceta`, `numeroVersion`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `numeroVersion` | `INTEGER` · PK/FK/NN | Número de versión histórica de Receta o Política, que evita sobrescribir versiones anteriores. PK compuesta: participa con `idReceta`, `idInsumo` para distinguir inequívocamente cada fila; esta columna sola no tiene por qué ser única. FK: se almacena para referenciar VERSION_RECETA(`idReceta`, `numeroVersion`) mediante la FK compuesta (`idReceta`, `numeroVersion`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `idInsumo` | `BIGINT` · PK/FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK compuesta: participa con `idReceta`, `numeroVersion` para distinguir inequívocamente cada fila; esta columna sola no tiene por qué ser única. FK: se almacena para referenciar INSUMO(`idInsumo`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `cantidadNecesaria` | `NUMERIC(18,3)` · NN | Cantidad de Insumo que requiere la receta para su rendimiento de referencia.  |
| `codigoUnidadCantidad` | `VARCHAR(20)` · FK/NN | Unidad aplicable a la cantidad de Insumo que consume una Versión de Receta. FK: se almacena para referenciar UNIDAD_MEDIDA(`codigoUnidad`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |


### 07. `PREPARACION`

Producción efectuada para un detalle de pedido; conserva cantidad preparada y versión de receta utilizada.

**PK:** `idPreparacion`. Identifica una fila de esta tabla.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idPreparacion` | `BIGINT` · PK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK: identifica de forma única cada fila de PREPARACION; impide dos registros con la misma clave. |
| `idPedido` | `BIGINT` · FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar DETALLE_PEDIDO(`idPedido`, `numeroDetalle`) mediante la FK compuesta (`idPedido`, `numeroDetalle`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `numeroDetalle` | `INTEGER` · FK/NN | Número de línea dentro de un Pedido, que la distingue de las otras líneas del mismo Pedido. FK: se almacena para referenciar DETALLE_PEDIDO(`idPedido`, `numeroDetalle`) mediante la FK compuesta (`idPedido`, `numeroDetalle`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `idReceta` | `BIGINT` · FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar VERSION_RECETA(`idReceta`, `numeroVersion`) mediante la FK compuesta (`idReceta`, `numeroVersion`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `numeroVersion` | `INTEGER` · FK/NN | Número de versión histórica de Receta o Política, que evita sobrescribir versiones anteriores. FK: se almacena para referenciar VERSION_RECETA(`idReceta`, `numeroVersion`) mediante la FK compuesta (`idReceta`, `numeroVersion`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `fechaHoraPreparacion` | `TIMESTAMPTZ` · NN | Instante en que se produjo la cantidad del Pedido mediante una Versión de Receta concreta.  |
| `cantidadPreparada` | `NUMERIC(18,3)` · NN | Cantidad realmente elaborada en una Preparación, limitada por la cantidad original del Detalle de Pedido.  |


### 08. `COSTO_INSUMO_HISTORICO`

Costos unitarios de un Insumo a través del tiempo y su procedencia; permite costear consumos sin usar costos actuales.

**PK:** `idInsumo` + `vigenteDesde`. Clave compuesta: el identificador es la combinación de estos campos.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idInsumo` | `BIGINT` · PK/FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK compuesta: participa con `vigenteDesde` para distinguir inequívocamente cada fila; esta columna sola no tiene por qué ser única. FK: se almacena para referenciar INSUMO(`idInsumo`) y RECEPCION_COMPRA(`idRecepcionCompra`, `idInsumoRecibido`) mediante la FK compuesta (`idRecepcionCompra`, `idInsumo`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `vigenteDesde` | `TIMESTAMPTZ` · PK/NN | Comienzo inclusivo del intervalo de validez de la versión o asociación. PK compuesta: participa con `idInsumo` para distinguir inequívocamente cada fila; esta columna sola no tiene por qué ser única. |
| `vigenteHasta` | `TIMESTAMPTZ` · NULL | Final exclusivo, opcional, del intervalo de validez; NULL puede expresar vigencia abierta.  |
| `costoUnitario` | `NUMERIC(18,4)` · NN | Costo unitario histórico de Insumo o valorización de REVENTA según el registro.  |
| `fuenteCosto` | `VARCHAR(30)` · NN | Origen que justificó la valoración del Insumo, incluido el saldo inicial cuando corresponda.  |
| `referenciaOrigen` | `VARCHAR(100)` · NULL | Identificador descriptivo de la operación que originó el movimiento o costo.  |
| `idRecepcionCompra` | `BIGINT` · FK/NULL | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar RECEPCION_COMPRA(`idRecepcionCompra`, `idInsumoRecibido`) mediante la FK compuesta (`idRecepcionCompra`, `idInsumo`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |


### 09. `MOVIMIENTO_INSUMO`

Ingresos, consumos de preparación y ajustes de Insumos; deja rastros de cantidad, stock resultante y costo histórico.

**PK:** `idMovimientoInsumo`. Identifica una fila de esta tabla.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idMovimientoInsumo` | `BIGINT` · PK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK: identifica de forma única cada fila de MOVIMIENTO_INSUMO; impide dos registros con la misma clave. |
| `idInsumo` | `BIGINT` · FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar INSUMO(`idInsumo`) y RECEPCION_COMPRA(`idRecepcionCompra`, `idInsumoRecibido`) mediante la FK compuesta (`idRecepcionCompra`, `idInsumo`) y COSTO_INSUMO_HISTORICO(`idInsumo`, `vigenteDesde`) mediante la FK compuesta (`idInsumo`, `vigenteDesdeCosto`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `numeroSecuenciaInsumo` | `BIGINT` · NN | Número correlativo de movimientos para un Insumo, usado para ordenar y conciliar stock.  |
| `idPreparacion` | `BIGINT` · FK/NULL | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar PREPARACION(`idPreparacion`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `idRecepcionCompra` | `BIGINT` · FK/NULL | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar RECEPCION_COMPRA(`idRecepcionCompra`, `idInsumoRecibido`) mediante la FK compuesta (`idRecepcionCompra`, `idInsumo`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `vigenteDesdeCosto` | `TIMESTAMPTZ` · FK/NN | Dato de vigente desde costo utilizado para describir, consultar o controlar la operación de esta tabla. FK: se almacena para referenciar COSTO_INSUMO_HISTORICO(`idInsumo`, `vigenteDesde`) mediante la FK compuesta (`idInsumo`, `vigenteDesdeCosto`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `idUsuarioResponsable` | `BIGINT` · FK/NN | Identifica al Usuario que ejecutó o autorizó esta operación, conservando su responsabilidad histórica. FK: se almacena para referenciar USUARIO(`idUsuario`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `tipoMovimiento` | `VARCHAR(30)` · NN | Clasifica el efecto de la operación sobre el stock, cuenta corriente o Caja según la tabla.  |
| `cantidad` | `NUMERIC(18,3)` · NN | Magnitud positiva del movimiento; el tipo de movimiento determina ingreso, consumo, salida o ajuste.  |
| `fechaHora` | `TIMESTAMPTZ` · NN | Fecha o instante asociado con hora, conservado como evidencia temporal de la operación.  |
| `stockResultante` | `NUMERIC(18,3)` · NN | Existencias físicas registradas inmediatamente después de aplicar el movimiento.  |
| `origen` | `VARCHAR(30)` · NN | Procedencia funcional del registro o movimiento, necesaria para diferenciar flujos automáticos y manuales.  |
| `referenciaOrigen` | `VARCHAR(100)` · NULL | Identificador descriptivo de la operación que originó el movimiento o costo.  |
| `motivo` | `TEXT` · NULL | Justificación textual de la operación, ajuste, transición o excepción registrada.  |
| `observacion` | `TEXT` · NULL | Nota explicativa opcional del operador sin alterar el efecto monetario o de inventario.  |


## Área 2 — Pedidos, entregas y excedentes

### 10. `PEDIDO`

Operación comercial de un Cliente; conserva canal, condiciones aplicadas, total original, estado y dirección histórica de entrega.

**PK:** `idPedido`. Identifica una fila de esta tabla.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idPedido` | `BIGINT` · PK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK: identifica de forma única cada fila de PEDIDO; impide dos registros con la misma clave. |
| `idCliente` | `BIGINT` · FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar CLIENTE(`idCliente`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `idUsuarioCreador` | `BIGINT` · FK/NULL | Identifica al Usuario que ejecutó o autorizó esta operación, conservando su responsabilidad histórica. FK: se almacena para referenciar USUARIO(`idUsuario`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `idSesionOnline` | `UUID` · FK/NULL | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar SESION_CLIENTE_ONLINE(`idSesionOnline`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `fechaHoraCarga` | `TIMESTAMPTZ` · NN | Fecha y hora en que fue registrado el Pedido.  |
| `fechaReparto` | `DATE` · NN | Fecha prevista de entrega, congelada como dato operativo del Pedido; los límites admitidos siguen sujetos a reglas por canal.  |
| `canalOrigen` | `VARCHAR(10)` · NN | Distingue el Pedido registrado internamente del registrado ONLINE.  |
| `estado` | `VARCHAR(15)` · NN | Estado operativo actual de este registro; las transiciones permitidas se controlan según el proceso de la tabla.  |
| `categoriaComercialAplicada` | `VARCHAR(20)` · NN | Categoría comercial del Cliente congelada en el Pedido al confirmar la operación.  |
| `idPoliticaComercialAplicada` | `BIGINT` · FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar POLITICA_CATEGORIA_COMERCIAL(`idPoliticaComercial`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `tipoAjuste` | `VARCHAR(15)` · NN | Identifica si corresponde un descuento, recargo o ningún ajuste comercial.  |
| `porcentajeAjuste` | `NUMERIC(5,2)` · NN | Porcentaje de descuento o recargo aplicable según la categoría comercial y política elegidas.  |
| `totalOriginal` | `NUMERIC(18,2)` · NN | Importe comercial inicial del Pedido congelado al crearlo, sin incorporar adiciones posteriores.  |
| `motivoCancelacion` | `TEXT` · NULL | Justificación de la cancelación, conservada para auditoría y revisión comercial.  |
| `fechaHoraCancelacion` | `TIMESTAMPTZ` · NULL | Instante de cancelación efectiva del precio programado, Pedido u Orden, según la tabla.  |
| `idOperacionOrigen` | `UUID` · NULL | UUID que identifica de forma estable una operación de Pedido, especialmente durante sincronización offline.  |
| `direccionEntregaCalle` | `VARCHAR(150)` · NN | Calle de entrega congelada en el Pedido, independiente de posteriores cambios del Cliente.  |
| `direccionEntregaNumero` | `VARCHAR(20)` · NULL | Altura de entrega histórica consignada para ese Pedido.  |
| `direccionEntregaPiso` | `VARCHAR(10)` · NULL | Piso de entrega congelado para ese Pedido.  |
| `direccionEntregaUnidadFuncional` | `VARCHAR(20)` · NULL | Departamento o unidad funcional de entrega congelada en el Pedido.  |
| `direccionEntregaLocalidad` | `VARCHAR(100)` · NN | Localidad de entrega histórica del Pedido.  |
| `direccionEntregaProvincia` | `VARCHAR(100)` · NULL | Provincia de entrega histórica del Pedido.  |
| `direccionEntregaReferencia` | `VARCHAR(250)` · NULL | Indicaciones de llegada vigentes al confirmar ese Pedido, conservadas históricamente.  |
| `direccionEntregaZona` | `VARCHAR(100)` · NULL | Zona de distribución aplicada a ese Pedido, preservada aunque cambie el Cliente.  |


### 11. `DETALLE_PEDIDO`

Cada producto solicitado dentro del Pedido; conserva cantidad original y precio/promoción congelados.

**PK:** `idPedido` + `numeroDetalle`. Clave compuesta: el identificador es la combinación de estos campos.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idPedido` | `BIGINT` · PK/FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK compuesta: participa con `numeroDetalle` para distinguir inequívocamente cada fila; esta columna sola no tiene por qué ser única. FK: se almacena para referenciar PEDIDO(`idPedido`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `numeroDetalle` | `INTEGER` · PK/NN | Número de línea dentro de un Pedido, que la distingue de las otras líneas del mismo Pedido. PK compuesta: participa con `idPedido` para distinguir inequívocamente cada fila; esta columna sola no tiene por qué ser única. |
| `idProducto` | `BIGINT` · FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar PRODUCTO(`idProducto`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `codigoUnidadVenta` | `VARCHAR(20)` · FK/NN | Unidad en la que se expresa la venta de un Producto; en el Detalle se congela la unidad aplicada a esa operación. FK: se almacena para referenciar UNIDAD_MEDIDA(`codigoUnidad`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `cantidadOriginal` | `NUMERIC(18,3)` · NN | Cantidad inicialmente pedida, inmutable frente a reasignaciones de Excedentes posteriores.  |
| `precioUnitarioOriginal` | `NUMERIC(18,4)` · NULL | Precio unitario congelado para el producto del Detalle cuando se cargó el Pedido.  |
| `porcentajePromocionOriginal` | `NUMERIC(5,2)` · NN | Descuento promocional congelado en el Detalle de Pedido original.  |
| `idPromocionAplicada` | `BIGINT` · FK/NULL | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar PROMOCION(`idPromocion`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |


### 12. `ASIGNACION_REPARTO`

Historial de quién fue asignado a repartir un Pedido y sus posibles reasignaciones.

**PK:** `idPedido` + `numeroAsignacion`. Clave compuesta: el identificador es la combinación de estos campos.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idPedido` | `BIGINT` · PK/FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK compuesta: participa con `numeroAsignacion` para distinguir inequívocamente cada fila; esta columna sola no tiene por qué ser única. FK: se almacena para referenciar PEDIDO(`idPedido`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `numeroAsignacion` | `INTEGER` · PK/NN | Secuencia de asignaciones y reasignaciones registrada para el Pedido; diferencia cada vínculo histórico. PK compuesta: participa con `idPedido` para distinguir inequívocamente cada fila; esta columna sola no tiene por qué ser única. |
| `idUsuarioRepartidor` | `BIGINT` · FK/NN | Identifica al Usuario que ejecutó o autorizó esta operación, conservando su responsabilidad histórica. FK: se almacena para referenciar USUARIO(`idUsuario`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `idUsuarioVendedor` | `BIGINT` · FK/NN | Identifica al Usuario que ejecutó o autorizó esta operación, conservando su responsabilidad histórica. FK: se almacena para referenciar USUARIO(`idUsuario`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `fechaHoraInicio` | `TIMESTAMPTZ` · NN | Momento en que comenzó la vigencia de la asignación, episodio o sesión.  |
| `fechaHoraFin` | `TIMESTAMPTZ` · NULL | Momento en que terminó la asignación, cuando ya no estaba vigente.  |
| `motivoReasignacion` | `TEXT` · NULL | Explicación exigida cuando se reemplaza el Repartidor de un Pedido.  |


### 13. `ENTREGA`

Confirmación única y definitiva de la entrega de un Pedido; identifica fecha y repartidor.

**PK:** `idPedido`. Identifica una fila de esta tabla.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idPedido` | `BIGINT` · PK/FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK: identifica de forma única cada fila de ENTREGA; impide dos registros con la misma clave. FK: se almacena para referenciar PEDIDO(`idPedido`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `fechaHoraEntrega` | `TIMESTAMPTZ` · NN | Momento de la única entrega definitiva registrada para el Pedido.  |
| `idUsuarioRepartidor` | `BIGINT` · FK/NN | Identifica al Usuario que ejecutó o autorizó esta operación, conservando su responsabilidad histórica. FK: se almacena para referenciar USUARIO(`idUsuario`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |


### 14. `DETALLE_ENTREGA`

Cantidad efectivamente entregada de cada línea del Pedido y costo histórico vendido de elaborados.

**PK:** `idPedido` + `numeroDetalle`. Clave compuesta: el identificador es la combinación de estos campos.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idPedido` | `BIGINT` · PK/FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK compuesta: participa con `numeroDetalle` para distinguir inequívocamente cada fila; esta columna sola no tiene por qué ser única. FK: se almacena para referenciar ENTREGA(`idPedido`) y DETALLE_PEDIDO(`idPedido`, `numeroDetalle`) mediante la FK compuesta (`idPedido`, `numeroDetalle`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `numeroDetalle` | `INTEGER` · PK/FK/NN | Número de línea dentro de un Pedido, que la distingue de las otras líneas del mismo Pedido. PK compuesta: participa con `idPedido` para distinguir inequívocamente cada fila; esta columna sola no tiene por qué ser única. FK: se almacena para referenciar DETALLE_PEDIDO(`idPedido`, `numeroDetalle`) mediante la FK compuesta (`idPedido`, `numeroDetalle`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `cantidadEntregada` | `NUMERIC(18,3)` · NN | Cantidad realmente entregada de un Producto en el cierre definitivo del Pedido.  |
| `costoHistoricoElaboradoVendido` | `NUMERIC(18,4)` · NULL | Costo histórico de producción atribuible a los productos ELABORADOS entregados.  |


### 15. `EXCEDENTE`

Unidades elaboradas no entregadas, disponibles para reutilización, con cantidad y costo históricos y procedencia.

**PK:** `idExcedente`. Identifica una fila de esta tabla.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idExcedente` | `BIGINT` · PK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK: identifica de forma única cada fila de EXCEDENTE; impide dos registros con la misma clave. |
| `idPedidoOrigen` | `BIGINT` · FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar DETALLE_PEDIDO(`idPedido`, `numeroDetalle`) mediante la FK compuesta (`idPedidoOrigen`, `numeroDetalleOrigen`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `numeroDetalleOrigen` | `INTEGER` · FK/NN | Dato de numero detalle origen utilizado para describir, consultar o controlar la operación de esta tabla. FK: se almacena para referenciar DETALLE_PEDIDO(`idPedido`, `numeroDetalle`) mediante la FK compuesta (`idPedidoOrigen`, `numeroDetalleOrigen`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `origenGeneracion` | `VARCHAR(15)` · NN | Causa por la que se produjeron unidades excedentes sin destinatario definitivo.  |
| `fechaHoraGeneracion` | `TIMESTAMPTZ` · NN | Momento en que se identificó y registró el Excedente.  |
| `cantidadInicial` | `NUMERIC(18,3)` · NN | Total de unidades con que nace el Excedente antes de aceptar ofertas o descartar unidades.  |
| `cantidadDisponible` | `NUMERIC(18,3)` · NN | Remanente físico del Excedente aún disponible para ofrecer o descartar.  |
| `costoHistoricoInicial` | `NUMERIC(18,4)` · NN | Costo histórico de las unidades presentes al generar el Excedente.  |
| `costoHistoricoDisponible` | `NUMERIC(18,4)` · NN | Costo histórico imputable a las unidades de Excedente que aún permanecen disponibles.  |
| `idMovimientoExcedenteOrigen` | `BIGINT` · FK/NULL | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar MOVIMIENTO_EXCEDENTE(`idMovimientoExcedente`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |


### 16. `OFERTA_EXCEDENTE`

Propuesta de unidades excedentes a un Pedido receptor; conserva cantidad, importe y aceptación o rechazo.

**PK:** `idOfertaExcedente`. Identifica una fila de esta tabla.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idOfertaExcedente` | `BIGINT` · PK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK: identifica de forma única cada fila de OFERTA_EXCEDENTE; impide dos registros con la misma clave. |
| `idExcedente` | `BIGINT` · FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar EXCEDENTE(`idExcedente`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `idPedidoReceptor` | `BIGINT` · FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar PEDIDO(`idPedido`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `idUsuarioVendedor` | `BIGINT` · FK/NN | Identifica al Usuario que ejecutó o autorizó esta operación, conservando su responsabilidad histórica. FK: se almacena para referenciar USUARIO(`idUsuario`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `fechaHoraOferta` | `TIMESTAMPTZ` · NN | Instante de comunicación de la propuesta de reasignación de Excedente.  |
| `cantidadOfrecida` | `NUMERIC(18,3)` · NN | Unidades de Excedente ofrecidas en esta propuesta, antes de la respuesta.  |
| `importeInformado` | `NUMERIC(18,2)` · NN | Importe que se comunicó al Cliente al ofrecer un Excedente.  |
| `respuesta` | `VARCHAR(15)` · NN | Situación PENDIENTE, ACEPTADA o RECHAZADA de la oferta de Excedente.  |
| `fechaHoraRespuesta` | `TIMESTAMPTZ` · NULL | Instante de aceptación/rechazo de la oferta o llegada de la cotización, según el caso.  |
| `cantidadAceptada` | `NUMERIC(18,3)` · NULL | Unidades que el Cliente aceptó incorporar a su Pedido receptor.  |
| `importeAceptado` | `NUMERIC(18,2)` · NULL | Importe adicional confirmado por el Cliente al aceptar la oferta de Excedente.  |


### 17. `MOVIMIENTO_EXCEDENTE`

Reasignación aceptada o descarte físico de un Excedente; descuenta saldo y conserva costo transferido.

**PK:** `idMovimientoExcedente`. Identifica una fila de esta tabla.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idMovimientoExcedente` | `BIGINT` · PK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK: identifica de forma única cada fila de MOVIMIENTO_EXCEDENTE; impide dos registros con la misma clave. |
| `idExcedente` | `BIGINT` · FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar EXCEDENTE(`idExcedente`) y OFERTA_EXCEDENTE(`idOfertaExcedente`, `idExcedente`) mediante la FK compuesta (`idOfertaExcedente`, `idExcedente`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `idOfertaExcedente` | `BIGINT` · FK/NULL | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar OFERTA_EXCEDENTE(`idOfertaExcedente`, `idExcedente`) mediante la FK compuesta (`idOfertaExcedente`, `idExcedente`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `tipoMovimiento` | `VARCHAR(15)` · NN | Clasifica el efecto de la operación sobre el stock, cuenta corriente o Caja según la tabla.  |
| `cantidad` | `NUMERIC(18,3)` · NN | Magnitud positiva del movimiento; el tipo de movimiento determina ingreso, consumo, salida o ajuste.  |
| `costoHistoricoSalida` | `NUMERIC(18,4)` · NN | Registra el costo que abandona el Excedente mediante reasignación o descarte, sin repetir consumo de Insumos.  |
| `fechaHoraMovimiento` | `TIMESTAMPTZ` · NN | Instante en que se asentó el movimiento monetario o de inventario.  |
| `motivoDescarte` | `TEXT` · NULL | Causa del descarte físico de unidades excedentes no vendidas.  |


### 18. `IMPUTACION_ENTREGA_ADICIONAL`

Determina qué unidades e importes de reasignaciones terminaron efectivamente en una Entrega, después del tramo original.

**PK:** `idPedido` + `numeroDetalle` + `idMovimientoExcedente`. Clave compuesta: el identificador es la combinación de estos campos.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idPedido` | `BIGINT` · PK/FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK compuesta: participa con `numeroDetalle`, `idMovimientoExcedente` para distinguir inequívocamente cada fila; esta columna sola no tiene por qué ser única. FK: se almacena para referenciar DETALLE_ENTREGA(`idPedido`, `numeroDetalle`) mediante la FK compuesta (`idPedido`, `numeroDetalle`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `numeroDetalle` | `INTEGER` · PK/FK/NN | Número de línea dentro de un Pedido, que la distingue de las otras líneas del mismo Pedido. PK compuesta: participa con `idPedido`, `idMovimientoExcedente` para distinguir inequívocamente cada fila; esta columna sola no tiene por qué ser única. FK: se almacena para referenciar DETALLE_ENTREGA(`idPedido`, `numeroDetalle`) mediante la FK compuesta (`idPedido`, `numeroDetalle`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `idMovimientoExcedente` | `BIGINT` · PK/FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK compuesta: participa con `idPedido`, `numeroDetalle` para distinguir inequívocamente cada fila; esta columna sola no tiene por qué ser única. FK: se almacena para referenciar MOVIMIENTO_EXCEDENTE(`idMovimientoExcedente`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `cantidadImputada` | `NUMERIC(18,3)` · NN | Unidades de la reasignación aceptada que terminaron efectivamente entregadas.  |
| `importeImputado` | `NUMERIC(18,2)` · NN | Parte del valor adicional atribuida a las unidades efectivamente entregadas.  |


## Área 3 — Precios, promociones y políticas comerciales

### 19. `PRECIO_PRODUCTO`

Historial de precios base de cada Producto, con vigencias actuales y futuras sin superposición.

**PK:** `idPrecio`. Identifica una fila de esta tabla.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idPrecio` | `BIGINT` · PK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK: identifica de forma única cada fila de PRECIO_PRODUCTO; impide dos registros con la misma clave. |
| `idProducto` | `BIGINT` · FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar PRODUCTO(`idProducto`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `precioBase` | `NUMERIC(18,4)` · NN | Precio de catálogo base válido durante el intervalo histórico indicado.  |
| `vigenteDesde` | `TIMESTAMPTZ` · NN | Comienzo inclusivo del intervalo de validez de la versión o asociación.  |
| `vigenteHasta` | `TIMESTAMPTZ` · NULL | Final exclusivo, opcional, del intervalo de validez; NULL puede expresar vigencia abierta.  |
| `fechaHoraRegistro` | `TIMESTAMPTZ` · NN | Instante en que se registró el hecho, precio, política o movimiento.  |
| `idUsuarioRegistro` | `BIGINT` · FK/NN | Identifica al Usuario que ejecutó o autorizó esta operación, conservando su responsabilidad histórica. FK: se almacena para referenciar USUARIO(`idUsuario`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `fechaHoraCancelacion` | `TIMESTAMPTZ` · NULL | Instante de cancelación efectiva del precio programado, Pedido u Orden, según la tabla.  |
| `idUsuarioCancelacion` | `BIGINT` · FK/NULL | Identifica al Usuario que ejecutó o autorizó esta operación, conservando su responsabilidad histórica. FK: se almacena para referenciar USUARIO(`idUsuario`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |


### 20. `AUDITORIA_PRECIO`

Eventos de cambios o cancelación de precios programados; registra lo anterior y lo nuevo para trazabilidad.

**PK:** `idAuditoriaPrecio`. Identifica una fila de esta tabla.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idAuditoriaPrecio` | `BIGINT` · PK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK: identifica de forma única cada fila de AUDITORIA_PRECIO; impide dos registros con la misma clave. |
| `idPrecio` | `BIGINT` · FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar PRECIO_PRODUCTO(`idPrecio`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `idUsuario` | `BIGINT` · FK/NN | Identifica al Usuario que ejecutó o autorizó esta operación, conservando su responsabilidad histórica. FK: se almacena para referenciar USUARIO(`idUsuario`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `fechaHoraEvento` | `TIMESTAMPTZ` · NN | Instante del evento auditado, distinto de la fecha de vigencia comercial cuando corresponda.  |
| `tipoEvento` | `VARCHAR(30)` · NN | Distingue un evento de alta, actualización o cancelación de Precio para conservar una auditoría inmutable.  |
| `precioAnterior` | `NUMERIC(18,4)` · NULL | Precio registrado antes del cambio auditado.  |
| `precioNuevo` | `NUMERIC(18,4)` · NULL | Precio informado después del cambio auditado.  |
| `vigenteDesdeAnterior` | `TIMESTAMPTZ` · NULL | Inicio de vigencia que tenía el precio antes de modificarse.  |
| `vigenteDesdeNuevo` | `TIMESTAMPTZ` · NULL | Inicio de vigencia establecido después del cambio.  |
| `vigenteHastaAnterior` | `TIMESTAMPTZ` · NULL | Fin de vigencia que tenía el precio antes de modificarse.  |
| `vigenteHastaNuevo` | `TIMESTAMPTZ` · NULL | Fin de vigencia establecido después del cambio.  |


### 21. `PROMOCION`

Condiciones, porcentaje de descuento y vigencia de una promoción destinada al canal ONLINE.

**PK:** `idPromocion`. Identifica una fila de esta tabla.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idPromocion` | `BIGINT` · PK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK: identifica de forma única cada fila de PROMOCION; impide dos registros con la misma clave. |
| `descripcion` | `VARCHAR(300)` · NN | Texto descriptivo del elemento, mostrado para identificar su contenido o condiciones.  |
| `porcentajeDescuento` | `NUMERIC(5,2)` · NN | Descuento porcentual definido para una Promoción en su período de vigencia.  |
| `vigenteDesde` | `TIMESTAMPTZ` · NN | Comienzo inclusivo del intervalo de validez de la versión o asociación.  |
| `vigenteHasta` | `TIMESTAMPTZ` · NN | Final exclusivo, opcional, del intervalo de validez; NULL puede expresar vigencia abierta.  |
| `estado` | `VARCHAR(30)` · NN | Controla BORRADOR, ACTIVA, PAUSADA, FINALIZADA y CANCELADA, preservando descuentos ya aplicados.  |
| `fechaHoraCreacion` | `TIMESTAMPTZ` · NN | Instante en que se creó el registro o desafío, antes de procesos posteriores.  |
| `idUsuarioCreador` | `BIGINT` · FK/NN | Identifica al Usuario que ejecutó o autorizó esta operación, conservando su responsabilidad histórica. FK: se almacena para referenciar USUARIO(`idUsuario`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `codigoAccesoOnline` | `UUID` · NN | Código asociado al acceso mediante Promoción; no constituye autenticación de identidad del Cliente.  |


### 22. `PROMOCION_PRODUCTO`

Relaciona cada Promoción con los Productos a los que aplica; resuelve una asociación muchos a muchos.

**PK:** `idPromocion` + `idProducto`. Clave compuesta: el identificador es la combinación de estos campos.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idPromocion` | `BIGINT` · PK/FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK compuesta: participa con `idProducto` para distinguir inequívocamente cada fila; esta columna sola no tiene por qué ser única. FK: se almacena para referenciar PROMOCION(`idPromocion`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `idProducto` | `BIGINT` · PK/FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK compuesta: participa con `idPromocion` para distinguir inequívocamente cada fila; esta columna sola no tiene por qué ser única. FK: se almacena para referenciar PRODUCTO(`idProducto`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |


### 23. `DESTINATARIO_PROMOCION`

Relaciona una Promoción con los Clientes seleccionados para recibirla o utilizarla.

**PK:** `idPromocion` + `idCliente`. Clave compuesta: el identificador es la combinación de estos campos.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idPromocion` | `BIGINT` · PK/FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK compuesta: participa con `idCliente` para distinguir inequívocamente cada fila; esta columna sola no tiene por qué ser única. FK: se almacena para referenciar PROMOCION(`idPromocion`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `idCliente` | `BIGINT` · PK/FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK compuesta: participa con `idPromocion` para distinguir inequívocamente cada fila; esta columna sola no tiene por qué ser única. FK: se almacena para referenciar CLIENTE(`idCliente`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `fechaHoraSeleccion` | `TIMESTAMPTZ` · NN | Instante en que el Cliente fue seleccionado como destinatario de la Promoción.  |


### 24. `INTENTO_COMUNICACION`

Cada intento de enviar una Promoción a un destinatario, con fecha y resultado; permite reintentos auditables.

**PK:** `idPromocion` + `idCliente` + `numeroIntento`. Clave compuesta: el identificador es la combinación de estos campos.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idPromocion` | `BIGINT` · PK/FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK compuesta: participa con `idCliente`, `numeroIntento` para distinguir inequívocamente cada fila; esta columna sola no tiene por qué ser única. FK: se almacena para referenciar DESTINATARIO_PROMOCION(`idPromocion`, `idCliente`) mediante la FK compuesta (`idPromocion`, `idCliente`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `idCliente` | `BIGINT` · PK/FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK compuesta: participa con `idPromocion`, `numeroIntento` para distinguir inequívocamente cada fila; esta columna sola no tiene por qué ser única. FK: se almacena para referenciar DESTINATARIO_PROMOCION(`idPromocion`, `idCliente`) mediante la FK compuesta (`idPromocion`, `idCliente`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `numeroIntento` | `INTEGER` · PK/NN | Número correlativo de cada intento enviado o gestionado sin crear una operación comercial nueva. PK compuesta: participa con `idPromocion`, `idCliente` para distinguir inequívocamente cada fila; esta columna sola no tiene por qué ser única. |
| `fechaHoraIntento` | `TIMESTAMPTZ` · NN | Momento en que se ejecutó un intento de comunicación a un Cliente.  |
| `canal` | `VARCHAR(30)` · NN | Canal de mensajería empleado en el intento de comunicar la Promoción.  |
| `resultado` | `VARCHAR(30)` · NN | Resultado de la comunicación, evaluación o decisión, según los valores válidos del proceso.  |
| `fechaHoraResultado` | `TIMESTAMPTZ` · NULL | Instante en que se conoció el resultado del intento de comunicación.  |
| `claveIdempotencia` | `UUID` · NN | Identificador único del intento o comunicación para impedir duplicados al reintentar.  |
| `referenciaExterna` | `VARCHAR(150)` · NULL | Referencia informada por el servicio o pasarela externa.  |


### 25. `POLITICA_CATEGORIA_COMERCIAL`

Versiones históricas de las reglas de categoría comercial y tolerancia de mora.

**PK:** `idPoliticaComercial`. Identifica una fila de esta tabla.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idPoliticaComercial` | `BIGINT` · PK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK: identifica de forma única cada fila de POLITICA_CATEGORIA_COMERCIAL; impide dos registros con la misma clave. |
| `diasToleranciaMora` | `INTEGER` · NN | Cantidad de días de tolerancia de mora definida por esta versión de política comercial.  |
| `vigenteDesde` | `TIMESTAMPTZ` · NN | Comienzo inclusivo del intervalo de validez de la versión o asociación.  |
| `vigenteHasta` | `TIMESTAMPTZ` · NULL | Final exclusivo, opcional, del intervalo de validez; NULL puede expresar vigencia abierta.  |
| `fechaHoraRegistro` | `TIMESTAMPTZ` · NN | Instante en que se registró el hecho, precio, política o movimiento.  |
| `idUsuarioRegistro` | `BIGINT` · FK/NN | Identifica al Usuario que ejecutó o autorizó esta operación, conservando su responsabilidad histórica. FK: se almacena para referenciar USUARIO(`idUsuario`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |


### 26. `AJUSTE_POLITICA_CATEGORIA`

Descuento, recargo o ausencia de ajuste correspondiente a cada categoría dentro de una política.

**PK:** `idPoliticaComercial` + `categoriaComercial`. Clave compuesta: el identificador es la combinación de estos campos.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idPoliticaComercial` | `BIGINT` · PK/FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK compuesta: participa con `categoriaComercial` para distinguir inequívocamente cada fila; esta columna sola no tiene por qué ser única. FK: se almacena para referenciar POLITICA_CATEGORIA_COMERCIAL(`idPoliticaComercial`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `categoriaComercial` | `VARCHAR(20)` · PK/NN | Categoría vigente del Cliente o categoría a la que se asigna un ajuste de política. PK compuesta: participa con `idPoliticaComercial` para distinguir inequívocamente cada fila; esta columna sola no tiene por qué ser única. |
| `tipoAjuste` | `VARCHAR(15)` · NN | Identifica si corresponde un descuento, recargo o ningún ajuste comercial.  |
| `porcentajeAjuste` | `NUMERIC(5,2)` · NN | Porcentaje de descuento o recargo aplicable según la categoría comercial y política elegidas.  |


## Área 4 — Clientes, usuarios y autenticación

### 27. `CLIENTE`

Identidad comercial, datos de contacto y domicilio actual, estado y categoría comercial del comprador.

**PK:** `idCliente`. Identifica una fila de esta tabla.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idCliente` | `BIGINT` · PK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK: identifica de forma única cada fila de CLIENTE; impide dos registros con la misma clave. |
| `nombres` | `VARCHAR(120)` · NN | Nombres actuales de la persona identificada como Cliente.  |
| `apellidos` | `VARCHAR(120)` · NULL | Apellidos actuales de la persona identificada como Cliente.  |
| `telefonoPrincipal` | `VARCHAR(20)` · NN | Número de contacto registrado para el Cliente y empleado en la autenticación ONLINE si resulta inequívoco.  |
| `calle` | `VARCHAR(150)` · NULL | Nombre actual de la calle del domicilio o dirección comercial.  |
| `numeroPuerta` | `VARCHAR(20)` · NULL | Altura/número del domicilio actual; se conserva separado para mantener atomicidad.  |
| `piso` | `VARCHAR(10)` · NULL | Piso asociado al domicilio o punto de entrega, cuando corresponda.  |
| `unidadFuncional` | `VARCHAR(20)` · NULL | Departamento o unidad funcional del domicilio, si existe.  |
| `localidad` | `VARCHAR(100)` · NULL | Localidad del domicilio o sede registrada.  |
| `provincia` | `VARCHAR(100)` · NULL | Provincia correspondiente al domicilio o dirección de referencia.  |
| `referenciaDomicilio` | `VARCHAR(250)` · NULL | Indicaciones adicionales para localizar el domicilio del Cliente.  |
| `zona` | `VARCHAR(100)` · NULL | Zona operativa para organizar el reparto.  |
| `diaHabitualReparto` | `SMALLINT` · NULL | Día habitual de distribución del Cliente, usado como dato operativo orientativo.  |
| `estado` | `VARCHAR(10)` · NN | Estado operativo actual de este registro; las transiciones permitidas se controlan según el proceso de la tabla.  |
| `categoriaComercial` | `VARCHAR(20)` · NN | Categoría vigente del Cliente o categoría a la que se asigna un ajuste de política.  |
| `fechaHoraAlta` | `TIMESTAMPTZ` · NN | Momento de alta original del registro.  |


### 28. `HISTORIAL_ESTADO_CLIENTE`

Cada inactivación o reactivación del Cliente, con fecha, responsable y motivo cuando corresponde.

**PK:** `idCliente` + `numeroCambio`. Clave compuesta: el identificador es la combinación de estos campos.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idCliente` | `BIGINT` · PK/FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK compuesta: participa con `numeroCambio` para distinguir inequívocamente cada fila; esta columna sola no tiene por qué ser única. FK: se almacena para referenciar CLIENTE(`idCliente`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `numeroCambio` | `INTEGER` · PK/NN | Ordinal del evento de cambio de estado para esa entidad; forma parte de su clave histórica. PK compuesta: participa con `idCliente` para distinguir inequívocamente cada fila; esta columna sola no tiene por qué ser única. |
| `estadoAnterior` | `VARCHAR(10)` · NN | Estado que tenía la entidad antes de una transición auditada.  |
| `estadoNuevo` | `VARCHAR(10)` · NN | Estado establecido después de la transición auditada.  |
| `fechaHoraCambio` | `TIMESTAMPTZ` · NN | Instante del cambio de estado, sin sobrescribir el evento anterior.  |
| `motivo` | `TEXT` · NULL | Justificación textual de la operación, ajuste, transición o excepción registrada.  |
| `idUsuarioAdministrador` | `BIGINT` · FK/NN | Identifica al Usuario que ejecutó o autorizó esta operación, conservando su responsabilidad histórica. FK: se almacena para referenciar USUARIO(`idUsuario`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |


### 29. `USUARIO`

Cuenta que accede al sistema interno o portal de Proveedor; gestiona nombre de acceso, credencial protegida y estado.

**PK:** `idUsuario`. Identifica una fila de esta tabla.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idUsuario` | `BIGINT` · PK/NN | Identifica al Usuario que ejecutó o autorizó esta operación, conservando su responsabilidad histórica. PK: identifica de forma única cada fila de USUARIO; impide dos registros con la misma clave. |
| `nombreUsuario` | `VARCHAR(80)` · NN | Identificador de acceso con el que un Usuario se autentica en el sistema.  |
| `credencialProtegida` | `VARCHAR(255)` · NN | Huella criptográfica/credencial protegida, nunca contraseña almacenada en texto claro.  |
| `estado` | `VARCHAR(15)` · NN | Estado operativo actual de este registro; las transiciones permitidas se controlan según el proceso de la tabla.  |
| `cambioCredencialPendiente` | `BOOLEAN` · NN | Indica si el Usuario debe reemplazar su contraseña temporal antes de acceder a las operaciones correspondientes.  |
| `fechaHoraAlta` | `TIMESTAMPTZ` · NN | Momento de alta original del registro.  |
| `fechaHoraDeshabilitacion` | `TIMESTAMPTZ` · NULL | Momento de deshabilitación de la cuenta de Usuario, si ocurrió.  |


### 30. `ROL`

Catálogo de responsabilidades autorizadas: Administrador, Vendedor, Producción, Repartidor y Proveedor.

**PK:** `codigoRol`. Identifica una fila de esta tabla.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `codigoRol` | `VARCHAR(30)` · PK/NN | Código estable para identificar rol dentro del proceso correspondiente. PK: identifica de forma única cada fila de ROL; impide dos registros con la misma clave. |
| `nombreMostrado` | `VARCHAR(100)` · NN | Etiqueta legible del Rol que se muestra al personal autorizado.  |


### 31. `USUARIO_ROL`

Asigna uno o más Roles a un Usuario; materializa la relación muchos a muchos.

**PK:** `idUsuario` + `codigoRol`. Clave compuesta: el identificador es la combinación de estos campos.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idUsuario` | `BIGINT` · PK/FK/NN | Identifica al Usuario que ejecutó o autorizó esta operación, conservando su responsabilidad histórica. PK compuesta: participa con `codigoRol` para distinguir inequívocamente cada fila; esta columna sola no tiene por qué ser única. FK: se almacena para referenciar USUARIO(`idUsuario`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `codigoRol` | `VARCHAR(30)` · PK/FK/NN | Código estable para identificar rol dentro del proceso correspondiente. PK compuesta: participa con `idUsuario` para distinguir inequívocamente cada fila; esta columna sola no tiene por qué ser única. FK: se almacena para referenciar ROL(`codigoRol`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `fechaHoraAsignacion` | `TIMESTAMPTZ` · NN | Fecha o instante asociado con hora asignacion, conservado como evidencia temporal de la operación.  |


### 32. `EVENTO_ASIGNACION_ROL`

Audita cada asignación o revocación de Roles, sin alterar el historial al actualizar los Roles vigentes.

**PK:** `idEventoRol`. Identifica una fila de esta tabla.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idEventoRol` | `BIGINT` · PK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK: identifica de forma única cada fila de EVENTO_ASIGNACION_ROL; impide dos registros con la misma clave. |
| `idUsuario` | `BIGINT` · FK/NN | Identifica al Usuario que ejecutó o autorizó esta operación, conservando su responsabilidad histórica. FK: se almacena para referenciar USUARIO(`idUsuario`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `codigoRol` | `VARCHAR(30)` · FK/NN | Código estable para identificar rol dentro del proceso correspondiente. FK: se almacena para referenciar ROL(`codigoRol`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `tipoEvento` | `VARCHAR(15)` · NN | Identifica si un Rol fue asignado o revocado al Usuario; forma el historial de permisos.  |
| `fechaHoraEvento` | `TIMESTAMPTZ` · NN | Instante del evento auditado, distinto de la fecha de vigencia comercial cuando corresponda.  |
| `idUsuarioAdministrador` | `BIGINT` · FK/NN | Identifica al Usuario que ejecutó o autorizó esta operación, conservando su responsabilidad histórica. FK: se almacena para referenciar USUARIO(`idUsuario`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |


### 33. `USUARIO_PROVEEDOR`

Vincula una cuenta con el Proveedor que representa; conserva cuentas históricas y exige máximo una habilitada.

**PK:** `idUsuario`. Identifica una fila de esta tabla.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idUsuario` | `BIGINT` · PK/FK/NN | Identifica al Usuario que ejecutó o autorizó esta operación, conservando su responsabilidad histórica. PK: identifica de forma única cada fila de USUARIO_PROVEEDOR; impide dos registros con la misma clave. FK: se almacena para referenciar USUARIO(`idUsuario`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `idProveedor` | `BIGINT` · FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar PROVEEDOR(`idProveedor`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `fechaHoraVinculacion` | `TIMESTAMPTZ` · NN | Momento histórico en que el Usuario fue vinculado al Proveedor.  |


### 34. `SESION_USUARIO`

Sesiones de acceso de Usuarios, con expiración y revocación de credenciales de sesión.

**PK:** `idSesionUsuario`. Identifica una fila de esta tabla.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idSesionUsuario` | `UUID` · PK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK: identifica de forma única cada fila de SESION_USUARIO; impide dos registros con la misma clave. |
| `idUsuario` | `BIGINT` · FK/NN | Identifica al Usuario que ejecutó o autorizó esta operación, conservando su responsabilidad histórica. FK: se almacena para referenciar USUARIO(`idUsuario`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `tokenProtegido` | `BYTEA` · NN | Representación protegida del token de sesión; permite validar acceso sin exponer el valor original.  |
| `fechaHoraInicio` | `TIMESTAMPTZ` · NN | Momento en que comenzó la vigencia de la asignación, episodio o sesión.  |
| `fechaHoraExpiracion` | `TIMESTAMPTZ` · NN | Límite temporal a partir del cual deja de ser válida la sesión o el desafío.  |
| `fechaHoraRevocacion` | `TIMESTAMPTZ` · NULL | Momento de revocación anticipada de la sesión antes de su expiración.  |


### 35. `DESAFIO_AUTENTICACION_CLIENTE`

Código temporal protegido enviado al teléfono del Cliente para verificar su identidad ONLINE.

**PK:** `idDesafio`. Identifica una fila de esta tabla.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idDesafio` | `UUID` · PK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK: identifica de forma única cada fila de DESAFIO_AUTENTICACION_CLIENTE; impide dos registros con la misma clave. |
| `idCliente` | `BIGINT` · FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar CLIENTE(`idCliente`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `telefonoDestino` | `VARCHAR(20)` · NN | Número al que se dirigió el código temporal; preserva el destino usado en ese intento.  |
| `codigoProtegido` | `BYTEA` · NN | Representación protegida del código temporal enviado al teléfono del Cliente.  |
| `fechaHoraCreacion` | `TIMESTAMPTZ` · NN | Instante en que se creó el registro o desafío, antes de procesos posteriores.  |
| `fechaHoraAceptacionEnvio` | `TIMESTAMPTZ` · NULL | Momento en que el proveedor de mensajería aceptó el envío del código temporal.  |
| `fechaHoraExpiracion` | `TIMESTAMPTZ` · NN | Límite temporal a partir del cual deja de ser válida la sesión o el desafío.  |
| `intentosFallidos` | `SMALLINT` · NN | Recuento de verificaciones incorrectas del código temporal, usado para limitar ataques.  |
| `fechaHoraValidacion` | `TIMESTAMPTZ` · NULL | Instante en que el Cliente confirmó correctamente el código.  |
| `fechaHoraBloqueo` | `TIMESTAMPTZ` · NULL | Momento de bloqueo por demasiados intentos de autenticación.  |


### 36. `SESION_CLIENTE_ONLINE`

Sesión emitida tras validar un desafío; permite vincular el Pedido ONLINE al Cliente autenticado.

**PK:** `idSesionOnline`. Identifica una fila de esta tabla.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idSesionOnline` | `UUID` · PK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK: identifica de forma única cada fila de SESION_CLIENTE_ONLINE; impide dos registros con la misma clave. |
| `idDesafio` | `UUID` · FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar DESAFIO_AUTENTICACION_CLIENTE(`idDesafio`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `tokenProtegido` | `BYTEA` · NN | Representación protegida del token de sesión; permite validar acceso sin exponer el valor original.  |
| `fechaHoraInicio` | `TIMESTAMPTZ` · NN | Momento en que comenzó la vigencia de la asignación, episodio o sesión.  |
| `fechaHoraExpiracion` | `TIMESTAMPTZ` · NN | Límite temporal a partir del cual deja de ser válida la sesión o el desafío.  |
| `fechaHoraRevocacion` | `TIMESTAMPTZ` · NULL | Momento de revocación anticipada de la sesión antes de su expiración.  |


## Área 5 — Proveedores, abastecimiento y compras

### 37. `PROVEEDOR`

Identidad comercial del suministrador, CUIT, contacto y estado.

**PK:** `idProveedor`. Identifica una fila de esta tabla.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idProveedor` | `BIGINT` · PK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK: identifica de forma única cada fila de PROVEEDOR; impide dos registros con la misma clave. |
| `cuit` | `CHAR(11)` · NN | CUIT identificador del Proveedor; se controla su unicidad para evitar registros duplicados.  |
| `razonSocial` | `VARCHAR(180)` · NN | Denominación legal o comercial del Proveedor.  |
| `telefonoContacto` | `VARCHAR(20)` · NULL | Número informado para contactar al Proveedor.  |
| `emailContacto` | `VARCHAR(254)` · NULL | Correo informado para comunicaciones con el Proveedor.  |
| `calle` | `VARCHAR(150)` · NULL | Nombre actual de la calle del domicilio o dirección comercial.  |
| `numeroPuerta` | `VARCHAR(20)` · NULL | Altura/número del domicilio actual; se conserva separado para mantener atomicidad.  |
| `localidad` | `VARCHAR(100)` · NULL | Localidad del domicilio o sede registrada.  |
| `provincia` | `VARCHAR(100)` · NULL | Provincia correspondiente al domicilio o dirección de referencia.  |
| `estado` | `VARCHAR(10)` · NN | Estado operativo actual de este registro; las transiciones permitidas se controlan según el proceso de la tabla.  |
| `fechaHoraAlta` | `TIMESTAMPTZ` · NN | Momento de alta original del registro.  |


### 38. `HISTORIAL_ESTADO_PROVEEDOR`

Registro histórico de activaciones e inactivaciones de cada Proveedor.

**PK:** `idProveedor` + `numeroCambio`. Clave compuesta: el identificador es la combinación de estos campos.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idProveedor` | `BIGINT` · PK/FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK compuesta: participa con `numeroCambio` para distinguir inequívocamente cada fila; esta columna sola no tiene por qué ser única. FK: se almacena para referenciar PROVEEDOR(`idProveedor`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `numeroCambio` | `INTEGER` · PK/NN | Ordinal del evento de cambio de estado para esa entidad; forma parte de su clave histórica. PK compuesta: participa con `idProveedor` para distinguir inequívocamente cada fila; esta columna sola no tiene por qué ser única. |
| `estadoAnterior` | `VARCHAR(10)` · NN | Estado que tenía la entidad antes de una transición auditada.  |
| `estadoNuevo` | `VARCHAR(10)` · NN | Estado establecido después de la transición auditada.  |
| `fechaHoraCambio` | `TIMESTAMPTZ` · NN | Instante del cambio de estado, sin sobrescribir el evento anterior.  |
| `idUsuarioAdministrador` | `BIGINT` · FK/NN | Identifica al Usuario que ejecutó o autorizó esta operación, conservando su responsabilidad histórica. FK: se almacena para referenciar USUARIO(`idUsuario`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `motivo` | `TEXT` · NULL | Justificación textual de la operación, ajuste, transición o excepción registrada.  |


### 39. `PROVEEDOR_INSUMO`

Asociación histórica de qué Insumos puede suministrar cada Proveedor y durante qué período.

**PK:** `idProveedor` + `idInsumo` + `vigenteDesde`. Clave compuesta: el identificador es la combinación de estos campos.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idProveedor` | `BIGINT` · PK/FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK compuesta: participa con `idInsumo`, `vigenteDesde` para distinguir inequívocamente cada fila; esta columna sola no tiene por qué ser única. FK: se almacena para referenciar PROVEEDOR(`idProveedor`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `idInsumo` | `BIGINT` · PK/FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK compuesta: participa con `idProveedor`, `vigenteDesde` para distinguir inequívocamente cada fila; esta columna sola no tiene por qué ser única. FK: se almacena para referenciar INSUMO(`idInsumo`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `vigenteDesde` | `TIMESTAMPTZ` · PK/NN | Comienzo inclusivo del intervalo de validez de la versión o asociación. PK compuesta: participa con `idProveedor`, `idInsumo` para distinguir inequívocamente cada fila; esta columna sola no tiene por qué ser única. |
| `vigenteHasta` | `TIMESTAMPTZ` · NULL | Final exclusivo, opcional, del intervalo de validez; NULL puede expresar vigencia abierta.  |


### 40. `CONFIGURACION_OPERATIVA`

Conserva los parámetros operativos globales vigentes, como el plazo de respuesta de cotización. Identifica al Administrador que modifica su valor; no conserva en esta tabla todas las versiones anteriores.

**PK:** `clave`. Identifica una fila de esta tabla.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `clave` | `VARCHAR(80)` · PK/NN | Nombre estable del parámetro operativo; permite identificar un único valor vigente por clave. PK: identifica de forma única cada fila de CONFIGURACION_OPERATIVA; impide dos registros con la misma clave. |
| `valorEntero` | `INTEGER` · NN | Valor entero positivo del parámetro operativo, sin cargar por defecto un plazo no acordado.  |
| `fechaHoraModificacion` | `TIMESTAMPTZ` · NN | Instante de la última modificación del parámetro operativo.  |
| `idUsuarioAdministrador` | `BIGINT` · FK/NN | Identifica al Usuario que ejecutó o autorizó esta operación, conservando su responsabilidad histórica. FK: se almacena para referenciar USUARIO(`idUsuario`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |


### 41. `EPISODIO_FALTANTE`

Identifica un período de stock insuficiente para controlar las rondas de cotización y su concurrencia.

**PK:** `idEpisodio`. Identifica una fila de esta tabla.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idEpisodio` | `BIGINT` · PK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK: identifica de forma única cada fila de EPISODIO_FALTANTE; impide dos registros con la misma clave. |
| `idInsumo` | `BIGINT` · FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar INSUMO(`idInsumo`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `fechaHoraInicio` | `TIMESTAMPTZ` · NN | Momento en que comenzó la vigencia de la asignación, episodio o sesión.  |
| `fechaHoraCierre` | `TIMESTAMPTZ` · NULL | Momento de cierre formal del episodio o ciclo.  |
| `idMovimientoApertura` | `BIGINT` · FK/NULL | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar MOVIMIENTO_INSUMO(`idMovimientoInsumo`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `plazoRespuestaHorasAplicado` | `INTEGER` · NULL | Horas de respuesta fijadas para este Episodio. No deben confundirse con el período estadístico de POLITICA_COMPRA.  |
| `idUsuarioAjustePlazo` | `BIGINT` · FK/NULL | Identifica al Usuario que ejecutó o autorizó esta operación, conservando su responsabilidad histórica. FK: se almacena para referenciar USUARIO(`idUsuario`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |


### 42. `SOLICITUD_COTIZACION`

Ronda concreta de pedido de precios: cantidad, vencimiento, modalidad y enlace con rondas anteriores.

**PK:** `idSolicitud`. Identifica una fila de esta tabla.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idSolicitud` | `BIGINT` · PK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK: identifica de forma única cada fila de SOLICITUD_COTIZACION; impide dos registros con la misma clave. |
| `idEpisodio` | `BIGINT` · FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar EPISODIO_FALTANTE(`idEpisodio`) y SOLICITUD_COTIZACION(`idSolicitud`, `idEpisodio`) mediante la FK compuesta (`idSolicitudAnterior`, `idEpisodio`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `idSolicitudAnterior` | `BIGINT` · FK/NULL | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar SOLICITUD_COTIZACION(`idSolicitud`, `idEpisodio`) mediante la FK compuesta (`idSolicitudAnterior`, `idEpisodio`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `idUsuarioEmisor` | `BIGINT` · FK/NULL | Identifica al Usuario que ejecutó o autorizó esta operación, conservando su responsabilidad histórica. FK: se almacena para referenciar USUARIO(`idUsuario`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `cantidadSolicitada` | `NUMERIC(18,3)` · NN | Cantidad solicitada en la ronda de cotización; base para comparar ofertas.  |
| `fechaHoraEmision` | `TIMESTAMPTZ` · NN | Fecha y hora de emisión de Solicitud u Orden, desde la cual se controla su vida operativa.  |
| `fechaHoraVencimiento` | `TIMESTAMPTZ` · NN | Límite explícito para admitir Respuestas de Cotización; respuestas posteriores se rechazan.  |
| `fechaHoraFinRecepcion` | `TIMESTAMPTZ` · NULL | Instante de cierre de admisión de respuestas de la ronda, si ya terminó.  |
| `modalidadInicio` | `VARCHAR(15)` · NN | Indica si la Solicitud de Cotización fue iniciada automáticamente o manualmente.  |
| `estado` | `VARCHAR(30)` · NN | Situación de la ronda de cotización desde apertura hasta resolución; no equivale a emisión automática de Orden.  |
| `motivoCierre` | `VARCHAR(40)` · NULL | Causa registrada del fin de recepción o de la decisión sin ofertas elegibles.  |
| `fechaHoraResolucion` | `TIMESTAMPTZ` · NULL | Momento de resolución del estado de la Solicitud una vez evaluada.  |


### 43. `INVITACION_COTIZACION`

Proveedores invitados a cada Solicitud; conserva a quién se invitó aunque luego cambie su estado.

**PK:** `idSolicitud` + `idProveedor`. Clave compuesta: el identificador es la combinación de estos campos.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idSolicitud` | `BIGINT` · PK/FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK compuesta: participa con `idProveedor` para distinguir inequívocamente cada fila; esta columna sola no tiene por qué ser única. FK: se almacena para referenciar SOLICITUD_COTIZACION(`idSolicitud`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `idProveedor` | `BIGINT` · PK/FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK compuesta: participa con `idSolicitud` para distinguir inequívocamente cada fila; esta columna sola no tiene por qué ser única. FK: se almacena para referenciar PROVEEDOR(`idProveedor`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |


### 44. `RESPUESTA_COTIZACION`

Respuesta definitiva de cada invitado: cantidad ofrecida, precio y plazo; puede declarar cantidad cero.

**PK:** `idRespuesta`. Identifica una fila de esta tabla.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idRespuesta` | `BIGINT` · PK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK: identifica de forma única cada fila de RESPUESTA_COTIZACION; impide dos registros con la misma clave. |
| `idSolicitud` | `BIGINT` · FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar INVITACION_COTIZACION(`idSolicitud`, `idProveedor`) mediante la FK compuesta (`idSolicitud`, `idProveedor`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `idProveedor` | `BIGINT` · FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar INVITACION_COTIZACION(`idSolicitud`, `idProveedor`) mediante la FK compuesta (`idSolicitud`, `idProveedor`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `idUsuarioRegistrador` | `BIGINT` · FK/NN | Identifica al Usuario que ejecutó o autorizó esta operación, conservando su responsabilidad histórica. FK: se almacena para referenciar USUARIO(`idUsuario`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `cantidadOfrecida` | `NUMERIC(18,3)` · NN | Unidades de Excedente ofrecidas en esta propuesta, antes de la respuesta.  |
| `precioUnitario` | `NUMERIC(18,4)` · NULL | Precio por unidad informado por el Proveedor en su Respuesta de Cotización.  |
| `tiempoEntregaEstimado` | `INTERVAL` · NULL | Plazo de entrega comunicado en una Respuesta de Cotización; puede faltar en una oferta positiva según MR-3.  |
| `fechaHoraRespuesta` | `TIMESTAMPTZ` · NN | Instante de aceptación/rechazo de la oferta o llegada de la cotización, según el caso.  |


### 45. `POLITICA_COMPRA`

Versiones de parámetros de evaluación de ofertas, conservadas históricamente.

**PK:** `idPoliticaCompra`. Identifica una fila de esta tabla.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idPoliticaCompra` | `BIGINT` · PK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK: identifica de forma única cada fila de POLITICA_COMPRA; impide dos registros con la misma clave. |
| `numeroVersion` | `INTEGER` · NN | Número de versión histórica de Receta o Política, que evita sobrescribir versiones anteriores.  |
| `vigenteDesde` | `TIMESTAMPTZ` · NN | Comienzo inclusivo del intervalo de validez de la versión o asociación.  |
| `vigenteHasta` | `TIMESTAMPTZ` · NULL | Final exclusivo, opcional, del intervalo de validez; NULL puede expresar vigencia abierta.  |
| `periodoCalculoDias` | `INTEGER` · NULL | Período de observación usado para métricas; no establece el plazo para recibir respuestas de cotización.  |
| `fechaHoraRegistro` | `TIMESTAMPTZ` · NN | Instante en que se registró el hecho, precio, política o movimiento.  |
| `idUsuarioRegistro` | `BIGINT` · FK/NN | Identifica al Usuario que ejecutó o autorizó esta operación, conservando su responsabilidad histórica. FK: se almacena para referenciar USUARIO(`idUsuario`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |


### 46. `CRITERIO_POLITICA_COMPRA`

Criterios, pesos y desempates configurados para una versión de Política de Compra.

**PK:** `idPoliticaCompra` + `codigoCriterio`. Clave compuesta: el identificador es la combinación de estos campos.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idPoliticaCompra` | `BIGINT` · PK/FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK compuesta: participa con `codigoCriterio` para distinguir inequívocamente cada fila; esta columna sola no tiene por qué ser única. FK: se almacena para referenciar POLITICA_COMPRA(`idPoliticaCompra`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `codigoCriterio` | `VARCHAR(40)` · PK/NN | Código estable que identifica el criterio de comparación dentro de una Política de Compra. PK compuesta: participa con `idPoliticaCompra` para distinguir inequívocamente cada fila; esta columna sola no tiene por qué ser única. |
| `pesoRelativo` | `NUMERIC(12,6)` · NULL | Ponderación configurada para el criterio en la política de compra; el cálculo normalizado sigue sujeto a reglas definidas.  |
| `ordenDesempate` | `SMALLINT` · NULL | Prioridad con que se utiliza este criterio si existen ofertas con resultados equivalentes.  |


### 47. `DECISION_COMPRA`

Resolución del Administrador de comprar o no comprar, basada en una Solicitud y ofertas evaluadas.

**PK:** `idDecisionCompra`. Identifica una fila de esta tabla.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idDecisionCompra` | `BIGINT` · PK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK: identifica de forma única cada fila de DECISION_COMPRA; impide dos registros con la misma clave. |
| `idSolicitud` | `BIGINT` · FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar SOLICITUD_COTIZACION(`idSolicitud`) y RESPUESTA_COTIZACION(`idRespuesta`, `idSolicitud`) mediante la FK compuesta (`idRespuestaSeleccionada`, `idSolicitud`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `idPoliticaCompra` | `BIGINT` · FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar POLITICA_COMPRA(`idPoliticaCompra`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `idUsuarioAdministrador` | `BIGINT` · FK/NN | Identifica al Usuario que ejecutó o autorizó esta operación, conservando su responsabilidad histórica. FK: se almacena para referenciar USUARIO(`idUsuario`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `idRespuestaSeleccionada` | `BIGINT` · FK/NULL | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar RESPUESTA_COTIZACION(`idRespuesta`, `idSolicitud`) mediante la FK compuesta (`idRespuestaSeleccionada`, `idSolicitud`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `fechaHoraDecision` | `TIMESTAMPTZ` · NN | Momento de la decisión humana del Administrador sobre las ofertas.  |
| `resultado` | `VARCHAR(15)` · NN | Resultado de la comunicación, evaluación o decisión, según los valores válidos del proceso.  |
| `justificacion` | `TEXT` · NN | Razón documentada del resultado de la decisión de compra del Administrador.  |


### 48. `DETALLE_DECISION`

Evaluación histórica de cada Respuesta considerada: elegibilidad y razones de exclusión.

**PK:** `idDecisionCompra` + `idRespuesta`. Clave compuesta: el identificador es la combinación de estos campos.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idDecisionCompra` | `BIGINT` · PK/FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK compuesta: participa con `idRespuesta` para distinguir inequívocamente cada fila; esta columna sola no tiene por qué ser única. FK: se almacena para referenciar DECISION_COMPRA(`idDecisionCompra`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `idRespuesta` | `BIGINT` · PK/FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK compuesta: participa con `idDecisionCompra` para distinguir inequívocamente cada fila; esta columna sola no tiene por qué ser única. FK: se almacena para referenciar RESPUESTA_COTIZACION(`idRespuesta`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `fechaHoraEvaluacion` | `TIMESTAMPTZ` · NN | Momento en que se evaluó una respuesta para fundamentar la decisión.  |
| `elegible` | `BOOLEAN` · NN | Señala si la cotización satisface las condiciones de elegibilidad para comprar.  |
| `estadoProveedorEvaluado` | `VARCHAR(10)` · NN | Estado del Proveedor conservado en el momento de evaluar la oferta, sin depender de cambios futuros.  |
| `motivoInelegibilidad` | `TEXT` · NULL | Causa por la cual una respuesta no fue elegible para comparar ofertas.  |


### 49. `DETALLE_DECISION_CRITERIO`

Valor y puntaje registrados para cada criterio aplicado a una respuesta evaluada.

**PK:** `idDecisionCompra` + `idRespuesta` + `codigoCriterio`. Clave compuesta: el identificador es la combinación de estos campos.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idDecisionCompra` | `BIGINT` · PK/FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK compuesta: participa con `idRespuesta`, `codigoCriterio` para distinguir inequívocamente cada fila; esta columna sola no tiene por qué ser única. FK: se almacena para referenciar DETALLE_DECISION(`idDecisionCompra`, `idRespuesta`) mediante la FK compuesta (`idDecisionCompra`, `idRespuesta`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `idRespuesta` | `BIGINT` · PK/FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK compuesta: participa con `idDecisionCompra`, `codigoCriterio` para distinguir inequívocamente cada fila; esta columna sola no tiene por qué ser única. FK: se almacena para referenciar DETALLE_DECISION(`idDecisionCompra`, `idRespuesta`) mediante la FK compuesta (`idDecisionCompra`, `idRespuesta`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `codigoCriterio` | `VARCHAR(40)` · PK/NN | Código estable que identifica el criterio de comparación dentro de una Política de Compra. PK compuesta: participa con `idDecisionCompra`, `idRespuesta` para distinguir inequívocamente cada fila; esta columna sola no tiene por qué ser única. |
| `valorNumerico` | `NUMERIC(18,6)` · NULL | Dato numérico observado para el criterio evaluado, cuando corresponde.  |
| `valorTexto` | `VARCHAR(200)` · NULL | Dato textual del criterio evaluado, cuando no se expresa numéricamente.  |
| `puntajeEvaluado` | `NUMERIC(18,6)` · NULL | Valor de puntuación documentado para el criterio de una oferta específica.  |


### 50. `ORDEN_COMPRA`

Compromiso de compra de un Insumo, emitido solo tras una Decisión administrativa aprobada.

**PK:** `idOrdenCompra`. Identifica una fila de esta tabla.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idOrdenCompra` | `BIGINT` · PK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK: identifica de forma única cada fila de ORDEN_COMPRA; impide dos registros con la misma clave. |
| `idDecisionCompra` | `BIGINT` · FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar DECISION_COMPRA(`idDecisionCompra`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `cantidadOrdenada` | `NUMERIC(18,3)` · NN | Cantidad comprometida en la Orden de Compra emitida por decisión administrativa.  |
| `precioUnitarioAcordado` | `NUMERIC(18,4)` · NN | Precio por unidad confirmado en la Orden de Compra tras la decisión del Administrador.  |
| `fechaHoraEmision` | `TIMESTAMPTZ` · NN | Fecha y hora de emisión de Solicitud u Orden, desde la cual se controla su vida operativa.  |
| `fechaHoraComprometida` | `TIMESTAMPTZ` · NULL | Fecha y hora de entrega comprometidas en la Orden de Compra.  |
| `estado` | `VARCHAR(30)` · NN | Controla ciclo de la orden desde emisión hasta recepción parcial/completa o cancelación.  |
| `fechaHoraCancelacion` | `TIMESTAMPTZ` · NULL | Instante de cancelación efectiva del precio programado, Pedido u Orden, según la tabla.  |
| `idUsuarioCancelacion` | `BIGINT` · FK/NULL | Identifica al Usuario que ejecutó o autorizó esta operación, conservando su responsabilidad histórica. FK: se almacena para referenciar USUARIO(`idUsuario`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `motivoCancelacion` | `TEXT` · NULL | Justificación de la cancelación, conservada para auditoría y revisión comercial.  |
| `cancelacionAtribuibleProveedor` | `BOOLEAN` · NULL | Señala si el motivo de cancelación de la Orden es atribuible al Proveedor y puede afectar su evaluación.  |


### 51. `RECEPCION_COMPRA`

Ingreso físico recibido, con cantidad, unidad original, factor de conversión y costo real; admite recepciones parciales.

**PK:** `idRecepcionCompra`. Identifica una fila de esta tabla.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idRecepcionCompra` | `BIGINT` · PK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK: identifica de forma única cada fila de RECEPCION_COMPRA; impide dos registros con la misma clave. |
| `idOrdenCompra` | `BIGINT` · FK/NULL | Asocia opcionalmente una Recepción con Orden de Compra; una compra de REVENTA puede recibirse sin Orden. FK: se almacena para referenciar ORDEN_COMPRA(`idOrdenCompra`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `idProveedorDirecto` | `BIGINT` · FK/NULL | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar PROVEEDOR(`idProveedor`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `idInsumoRecibido` | `BIGINT` · FK/NULL | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar INSUMO(`idInsumo`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `idProductoReventa` | `BIGINT` · FK/NULL | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar PRODUCTO(`idProducto`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `idUsuarioResponsable` | `BIGINT` · FK/NN | Identifica al Usuario que ejecutó o autorizó esta operación, conservando su responsabilidad histórica. FK: se almacena para referenciar USUARIO(`idUsuario`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `fechaHoraRecepcion` | `TIMESTAMPTZ` · NN | Momento de registro de la mercadería recibida físicamente.  |
| `cantidadRecibida` | `NUMERIC(18,3)` · NN | Cantidad física recibida en la recepción de compra, antes de aplicar el factor de conversión.  |
| `codigoUnidadMedida` | `VARCHAR(20)` · FK/NN | Unidad de medida utilizada para expresar el insumo o la cantidad efectivamente recibida, según la tabla. FK: se almacena para referenciar UNIDAD_MEDIDA(`codigoUnidad`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `costoUnitarioReal` | `NUMERIC(18,4)` · NN | Costo unitario efectivamente aplicado en la recepción, preservado junto a cantidades y unidad recibidas.  |
| `factorConversionAplicado` | `NUMERIC(24,12)` · NN | Factor de conversión usado en esa recepción para pasar de la unidad recibida a la unidad base; se congela.  |
| `referenciaComercial` | `VARCHAR(200)` · NULL | Número o referencia documental de la compra recibida.  |


## Área 6 — Inventario de productos de reventa

### 52. `MOVIMIENTO_STOCK_REVENTA`

Entradas, ventas y ajustes de stock de REVENTA; conserva saldo y costo histórico de cada movimiento.

**PK:** `idMovimientoStockReventa`. Identifica una fila de esta tabla.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idMovimientoStockReventa` | `BIGINT` · PK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK: identifica de forma única cada fila de MOVIMIENTO_STOCK_REVENTA; impide dos registros con la misma clave. |
| `idProducto` | `BIGINT` · FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar PRODUCTO(`idProducto`) y RECEPCION_COMPRA(`idRecepcionCompra`, `idProductoReventa`) mediante la FK compuesta (`idRecepcionCompra`, `idProducto`) y DETALLE_PEDIDO(`idPedido`, `numeroDetalle`, `idProducto`) mediante la FK compuesta (`idPedidoEntrega`, `numeroDetalleEntrega`, `idProducto`) y VALORACION_EXTRAORDINARIA_REVENTA(`idValoracionReventa`, `idProducto`) mediante la FK compuesta (`idValoracionReventa`, `idProducto`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `numeroSecuenciaProducto` | `BIGINT` · NN | Número correlativo de movimientos físicos del Producto REVENTA.  |
| `idRecepcionCompra` | `BIGINT` · FK/NULL | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar RECEPCION_COMPRA(`idRecepcionCompra`, `idProductoReventa`) mediante la FK compuesta (`idRecepcionCompra`, `idProducto`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `idPedidoEntrega` | `BIGINT` · FK/NULL | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar DETALLE_ENTREGA(`idPedido`, `numeroDetalle`) mediante la FK compuesta (`idPedidoEntrega`, `numeroDetalleEntrega`) y DETALLE_PEDIDO(`idPedido`, `numeroDetalle`, `idProducto`) mediante la FK compuesta (`idPedidoEntrega`, `numeroDetalleEntrega`, `idProducto`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `numeroDetalleEntrega` | `INTEGER` · FK/NULL | Dato de numero detalle entrega utilizado para describir, consultar o controlar la operación de esta tabla. FK: se almacena para referenciar DETALLE_ENTREGA(`idPedido`, `numeroDetalle`) mediante la FK compuesta (`idPedidoEntrega`, `numeroDetalleEntrega`) y DETALLE_PEDIDO(`idPedido`, `numeroDetalle`, `idProducto`) mediante la FK compuesta (`idPedidoEntrega`, `numeroDetalleEntrega`, `idProducto`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `idValoracionReventa` | `BIGINT` · FK/NULL | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar VALORACION_EXTRAORDINARIA_REVENTA(`idValoracionReventa`, `idProducto`) mediante la FK compuesta (`idValoracionReventa`, `idProducto`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `idUsuarioResponsable` | `BIGINT` · FK/NN | Identifica al Usuario que ejecutó o autorizó esta operación, conservando su responsabilidad histórica. FK: se almacena para referenciar USUARIO(`idUsuario`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `tipoMovimiento` | `VARCHAR(20)` · NN | Clasifica el efecto de la operación sobre el stock, cuenta corriente o Caja según la tabla.  |
| `cantidad` | `NUMERIC(18,3)` · NN | Magnitud positiva del movimiento; el tipo de movimiento determina ingreso, consumo, salida o ajuste.  |
| `fechaHoraMovimiento` | `TIMESTAMPTZ` · NN | Instante en que se asentó el movimiento monetario o de inventario.  |
| `stockResultante` | `NUMERIC(18,3)` · NN | Existencias físicas registradas inmediatamente después de aplicar el movimiento.  |
| `costoPromedioResultante` | `NUMERIC(18,4)` · NULL | Costo promedio móvil del Producto REVENTA después del movimiento, con valor histórico conservado.  |
| `costoTotalHistoricoVenta` | `NUMERIC(18,4)` · NULL | Costo histórico del inventario REVENTA que salió por la venta realizada.  |
| `motivo` | `TEXT` · NULL | Justificación textual de la operación, ajuste, transición o excepción registrada.  |
| `observacion` | `TEXT` · NULL | Nota explicativa opcional del operador sin alterar el efecto monetario o de inventario.  |


### 53. `VALORACION_EXTRAORDINARIA_REVENTA`

Justificación y costo de inicializar o regularizar el valor de un Producto REVENTA cuando falta costo válido.

**PK:** `idValoracionReventa`. Identifica una fila de esta tabla.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idValoracionReventa` | `BIGINT` · PK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK: identifica de forma única cada fila de VALORACION_EXTRAORDINARIA_REVENTA; impide dos registros con la misma clave. |
| `idProducto` | `BIGINT` · FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar PRODUCTO(`idProducto`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `tipoValoracion` | `VARCHAR(20)` · NN | Motivo o modalidad de valoración extraordinaria del inventario REVENTA.  |
| `costoUnitario` | `NUMERIC(18,4)` · NN | Costo unitario histórico de Insumo o valorización de REVENTA según el registro.  |
| `fechaHoraValoracion` | `TIMESTAMPTZ` · NN | Momento de la valoración extraordinaria aplicada a un Producto REVENTA.  |
| `motivo` | `TEXT` · NN | Justificación textual de la operación, ajuste, transición o excepción registrada.  |
| `idUsuarioResponsable` | `BIGINT` · FK/NN | Identifica al Usuario que ejecutó o autorizó esta operación, conservando su responsabilidad histórica. FK: se almacena para referenciar USUARIO(`idUsuario`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |


## Área 7 — Cobros, cuenta corriente, caja y reembolsos

### 54. `COBRO`

Pago realmente recibido de un Cliente, vinculado opcionalmente con un Pedido; su registro origina Cuenta Corriente y Caja.

**PK:** `idCobro`. Identifica una fila de esta tabla.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idCobro` | `BIGINT` · PK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK: identifica de forma única cada fila de COBRO; impide dos registros con la misma clave. |
| `idCliente` | `BIGINT` · FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar CLIENTE(`idCliente`) y PEDIDO(`idPedido`, `idCliente`) mediante la FK compuesta (`idPedido`, `idCliente`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `idPedido` | `BIGINT` · FK/NULL | Vincula opcionalmente un Cobro con un Pedido; el pago puede registrarse sin Pedido concreto. FK: se almacena para referenciar PEDIDO(`idPedido`, `idCliente`) mediante la FK compuesta (`idPedido`, `idCliente`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `idUsuarioRegistrador` | `BIGINT` · FK/NULL | Identifica al Usuario que ejecutó o autorizó esta operación, conservando su responsabilidad histórica. FK: se almacena para referenciar USUARIO(`idUsuario`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `fechaHoraCobro` | `TIMESTAMPTZ` · NN | Momento real de recepción del pago del Cliente.  |
| `importe` | `NUMERIC(18,2)` · NN | Valor monetario positivo del cobro o movimiento, interpretado según el tipo y el origen.  |
| `medioPago` | `VARCHAR(20)` · NN | Medio de pago realmente utilizado para registrar el Cobro.  |
| `origen` | `VARCHAR(20)` · NN | Canal o procedencia de registración del pago (interno/electrónico), independiente del Pedido al que pueda asociarse.  |
| `referenciaExterna` | `VARCHAR(150)` · NULL | Referencia de la transacción comunicada por la pasarela, útil para auditar el Cobro electrónico.  |
| `claveIdempotenciaOrigen` | `UUID` · NULL | Clave UUID de la operación de origen para evitar registrar dos veces el mismo Cobro.  |
| `estadoCobro` | `VARCHAR(20)` · NN | Representa el estado administrativo del Cobro. Solo ANULADO consta expresamente; los restantes estados requieren decisión de negocio F01.  |


### 55. `MOVIMIENTO_CUENTA`

Cargos por venta, pagos y ajustes que determinan el saldo deudor o a favor de cada Cliente.

**PK:** `idMovimientoCuenta`. Identifica una fila de esta tabla.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idMovimientoCuenta` | `BIGINT` · PK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK: identifica de forma única cada fila de MOVIMIENTO_CUENTA; impide dos registros con la misma clave. |
| `idCliente` | `BIGINT` · FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar CLIENTE(`idCliente`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `numeroSecuenciaCliente` | `BIGINT` · NN | Número correlativo de asientos de Cuenta Corriente de un Cliente.  |
| `tipoMovimiento` | `VARCHAR(20)` · NN | Diferencia cargos por venta, pagos y ajustes que afectan el saldo del Cliente.  |
| `importe` | `NUMERIC(18,2)` · NN | Valor monetario positivo del cobro o movimiento, interpretado según el tipo y el origen.  |
| `fechaHoraMovimiento` | `TIMESTAMPTZ` · NN | Instante en que se asentó el movimiento monetario o de inventario.  |
| `saldoResultante` | `NUMERIC(18,2)` · NN | Saldo de Cuenta Corriente resultante tras el movimiento, materializado para consulta y sujeto a conciliación.  |
| `idUsuarioAjuste` | `BIGINT` · FK/NULL | Identifica al Usuario que ejecutó o autorizó esta operación, conservando su responsabilidad histórica. FK: se almacena para referenciar USUARIO(`idUsuario`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `observacion` | `TEXT` · NULL | Nota explicativa opcional del operador sin alterar el efecto monetario o de inventario.  |

### 56. `ORIGEN_MOVIMIENTO_CUENTA`

Vincula un movimiento automático de Cuenta Corriente con su Entrega, Cobro o Reembolso de origen.

**PK:** `idMovimientoCuenta`. Identifica una fila de esta tabla.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idMovimientoCuenta` | `BIGINT` · PK/FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK: identifica de forma única cada fila de ORIGEN_MOVIMIENTO_CUENTA; impide dos registros con la misma clave. FK: se almacena para referenciar MOVIMIENTO_CUENTA(`idMovimientoCuenta`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `idPedidoEntrega` | `BIGINT` · FK/NULL | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar ENTREGA(`idPedido`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `idCobro` | `BIGINT` · FK/NULL | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar COBRO(`idCobro`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `idReembolso` | `BIGINT` · FK/NULL | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar REEMBOLSO(`idReembolso`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `idCobroAnulado` | `BIGINT` · FK/NULL | Apunta al Cobro que originó la anulación mediante contra-asiento, preservando el asiento original. FK: se almacena para referenciar COBRO(`idCobro`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |


### 57. `MOVIMIENTO_CAJA`

Entradas y salidas monetarias, manuales o automáticas; base del Libro Diario.

**PK:** `idMovimientoCaja`. Identifica una fila de esta tabla.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idMovimientoCaja` | `BIGINT` · PK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK: identifica de forma única cada fila de MOVIMIENTO_CAJA; impide dos registros con la misma clave. |
| `tipoMovimiento` | `VARCHAR(10)` · NN | Señala INGRESO o EGRESO; el signo económico se interpreta desde el tipo con importe positivo.  |
| `importe` | `NUMERIC(18,2)` · NN | Valor monetario positivo del cobro o movimiento, interpretado según el tipo y el origen.  |
| `fechaHoraMovimiento` | `TIMESTAMPTZ` · NN | Instante en que se asentó el movimiento monetario o de inventario.  |
| `origen` | `VARCHAR(15)` · NN | Clasifica el asiento como manual, Cobro, Reembolso o anulación conforme al esquema MR-3.  |
| `concepto` | `VARCHAR(200)` · NULL | Descripción breve del motivo económico del movimiento de Caja.  |
| `referencia` | `VARCHAR(150)` · NULL | Dato de referencia comercial o administrativa del movimiento.  |
| `observacion` | `TEXT` · NULL | Nota explicativa opcional del operador sin alterar el efecto monetario o de inventario.  |
| `idUsuarioRegistro` | `BIGINT` · FK/NULL | Identifica al Usuario que ejecutó o autorizó esta operación, conservando su responsabilidad histórica. FK: se almacena para referenciar USUARIO(`idUsuario`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `idCobro` | `BIGINT` · FK/NULL | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar COBRO(`idCobro`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `idReembolso` | `BIGINT` · FK/NULL | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar REEMBOLSO(`idReembolso`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `idCobroAnulado` | `BIGINT` · FK/NULL | Señala el Cobro cuyo ingreso se revierte con un EGRESO, sin borrar el registro anterior. FK: se almacena para referenciar COBRO(`idCobro`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |


### 58. `REEMBOLSO`

Devolución electrónica completa y única de un Cobro, con estado PENDIENTE, PROCESADO o RECHAZADO.

**PK:** `idReembolso`. Identifica una fila de esta tabla.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idReembolso` | `BIGINT` · PK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK: identifica de forma única cada fila de REEMBOLSO; impide dos registros con la misma clave. |
| `idCobro` | `BIGINT` · FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar COBRO(`idCobro`) y COBRO(`idCobro`, `importe`) mediante la FK compuesta (`idCobro`, `importeReembolso`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `importeReembolso` | `NUMERIC(18,2)` · FK/NN | Monto completo del Cobro que se solicita devolver; no implica devolución parcial. FK: se almacena para referenciar COBRO(`idCobro`, `importe`) mediante la FK compuesta (`idCobro`, `importeReembolso`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `fechaHoraCreacion` | `TIMESTAMPTZ` · NN | Instante en que se creó el registro o desafío, antes de procesos posteriores.  |
| `fechaHoraProcesamiento` | `TIMESTAMPTZ` · NULL | Instante en que el Reembolso alcanzó el estado PROCESADO y originó efectos financieros.  |
| `motivo` | `TEXT` · NN | Justificación textual de la operación, ajuste, transición o excepción registrada.  |
| `estado` | `VARCHAR(15)` · NN | Controla PENDIENTE, PROCESADO o RECHAZADO; solo PROCESADO dispara ajustes monetarios exactamente una vez.  |


### 59. `INTENTO_REEMBOLSO`

Cada solicitud o reintento de un mismo Reembolso ante MercadoPago, con clave de idempotencia.

**PK:** `idReembolso` + `numeroIntento`. Clave compuesta: el identificador es la combinación de estos campos.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idReembolso` | `BIGINT` · PK/FK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK compuesta: participa con `numeroIntento` para distinguir inequívocamente cada fila; esta columna sola no tiene por qué ser única. FK: se almacena para referenciar REEMBOLSO(`idReembolso`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `numeroIntento` | `INTEGER` · PK/NN | Número correlativo de cada intento enviado o gestionado sin crear una operación comercial nueva. PK compuesta: participa con `idReembolso` para distinguir inequívocamente cada fila; esta columna sola no tiene por qué ser única. |
| `fechaHoraSolicitud` | `TIMESTAMPTZ` · NN | Momento de envío o generación de un intento de Reembolso.  |
| `claveIdempotencia` | `UUID` · NN | Identificador único del intento o comunicación para impedir duplicados al reintentar.  |
| `referenciaOperacionExterna` | `VARCHAR(150)` · NULL | Identificador de la operación gestionada por MercadoPago, conservado para correlación e idempotencia.  |
| `idUsuarioReintento` | `BIGINT` · FK/NULL | Identifica al Administrador que ordenó un reintento manual; NULL en el intento automático inicial. FK: se almacena para referenciar USUARIO(`idUsuario`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |


### 60. `EVENTO_RESULTADO_REEMBOLSO`

Respuestas o notificaciones de MercadoPago, válidas o incidencias, para aplicar resultados sin duplicar efectos.

**PK:** `idEventoResultado`. Identifica una fila de esta tabla.

| Atributo | Tipo / nulabilidad / rol | Descripción y función de la clave |
|---|---|---|
| `idEventoResultado` | `BIGINT` · PK/NN | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. PK: identifica de forma única cada fila de EVENTO_RESULTADO_REEMBOLSO; impide dos registros con la misma clave. |
| `idReembolso` | `BIGINT` · FK/NULL | Identificador de la entidad o hecho relacionado, utilizado para vincular y auditar esta operación. FK: se almacena para referenciar INTENTO_REEMBOLSO(`idReembolso`, `numeroIntento`) mediante la FK compuesta (`idReembolso`, `numeroIntento`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `numeroIntento` | `INTEGER` · FK/NULL | Número correlativo de cada intento enviado o gestionado sin crear una operación comercial nueva. FK: se almacena para referenciar INTENTO_REEMBOLSO(`idReembolso`, `numeroIntento`) mediante la FK compuesta (`idReembolso`, `numeroIntento`), mantener integridad referencial y recuperar el registro vinculado; no representa herencia de clases. |
| `identificadorEventoExterno` | `VARCHAR(150)` · NULL | Identificador único de la notificación recibida desde MercadoPago, útil para detectar duplicados.  |
| `referenciaOperacionExterna` | `VARCHAR(150)` · NULL | Identificador de la operación gestionada por MercadoPago, conservado para correlación e idempotencia.  |
| `origenResultado` | `VARCHAR(25)` · NN | Dato de origen resultado utilizado para describir, consultar o controlar la operación de esta tabla.  |
| `resultadoInformado` | `VARCHAR(15)` · NULL | Estado notificado por MercadoPago para el intento de Reembolso.  |
| `fechaHoraRecepcion` | `TIMESTAMPTZ` · NN | Momento de registro de la mercadería recibida físicamente.  |
| `autenticado` | `BOOLEAN` · NN | Registra si se verificó la autenticidad del evento recibido de MercadoPago.  |
| `aplicable` | `BOOLEAN` · NN | Señala si el evento validado debe aplicar un cambio de estado o efecto, evitando duplicados.  |
| `motivoNoAplicacion` | `TEXT` · NULL | Explicación de por qué una notificación externa no puede modificar el Reembolso.  |


## Observaciones de alcance

**Versión y procedencia.** El documento corresponde al diseño MR-3/MR-5. MR-6 probó DDL, estructura y pruebas seleccionadas en PostgreSQL 17.11 con bases descartables; no se ha probado por completo la aplicación, los webhooks ni el flujo offline.

**Cardinalidad.** La PK/FK materializa un vínculo de referencia, pero la participación mínima y la regla de negocio pueden requerir UNIQUE, CHECK, triggers, bloqueos o servicios transaccionales adicionales; no deducir ambas solo por el sufijo `id`.

**Datos históricos.** Cuando se conservan precios, categorías, costos y direcciones congelados, se documenta su uso como instantáneas históricas o materializaciones controladas; no debe aplicarse automáticamente el catálogo actual a hechos pasados.
