# ALE MILANESAS — MODELO RELACIONAL MR-3 (VERSIÓN DE DISEÑO)

**Fecha:** 25/10/2026. **Estado:** NO EJECUTADO / NO CERTIFICADO en PostgreSQL.

> Este catálogo físico se reconstruye desde el DDL base y las modificaciones MR-3. No reemplaza las justificaciones de dominio de 23/10; el DDL consolidado adjunto es la referencia normativa de constraints.

**Inventario previsto:** 60 tablas; 453 columnas; 125 FK (base 120, nuevas 5).

## Cambios acordados

- **MR3-01:** SALDO_INICIAL (apertura física; UC-42), sin recepción inventada.

- **MR3-02:** Índices UNIQUE por nombres normalizados; Cliente conserva teléfonos compartidos.

- **MR3-03:** EXCLUDE GiST con vigencias [desde,hasta), sin solapamientos.

- **MR3-04:** Catálogo de cinco estados acordado, sin modificación de pedidos previos.

- **MR3-05:** Configuración global sin duración inventada; plazo aplicado congelado en episodio/solicitud.

- **MR3-06:** Respuesta sin plazo informado válida; puntaje mínimo cero para criterio sin dato, sin pesos fijos.

- **MR3-07:** Contraasiento de Cobro con FK diferenciada, movimiento negativo de Caja como EGRESO.

- **MR3-08:** Responsable opcional para primer intento automático; obligatorio en reintentos administrativos.

## Catálogo físico completo (tablas y columnas)

### UNIDAD_MEDIDA

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| codigoUnidad | VARCHAR(20) | 1 | 0 | 1 |
| nombre | VARCHAR(100) | 0 | 0 | 1 |

**Claves del origen:** pk_unidad_medida, uq_unidad_medida_0.

### PRODUCTO

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idProducto | BIGINT | 1 | 0 | 1 |
| nombre | VARCHAR(150) | 0 | 0 | 1 |
| nombreNormalizado | VARCHAR(150) | 0 | 0 | 1 |
| descripcion | TEXT | 0 | 0 | 0 |
| tipoProducto | VARCHAR(20) | 0 | 0 | 1 |
| codigoUnidadVenta | VARCHAR(20) | 0 | 1 | 1 |
| activo | BOOLEAN | 0 | 0 | 1 |
| stockActualReventa | NUMERIC(18,3) | 0 | 0 | 0 |
| costoPromedioActualReventa | NUMERIC(18,4) | 0 | 0 | 0 |

**Claves del origen:** pk_producto, uq_producto_0.

### INSUMO

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idInsumo | BIGINT | 1 | 0 | 1 |
| nombre | VARCHAR(150) | 0 | 0 | 1 |
| codigoUnidadMedida | VARCHAR(20) | 0 | 1 | 1 |
| stockActual | NUMERIC(18,3) | 0 | 0 | 1 |
| umbralMinimo | NUMERIC(18,3) | 0 | 0 | 1 |
| nivelObjetivoReposicion | NUMERIC(18,3) | 0 | 0 | 1 |
| automatizacionCompraActiva | BOOLEAN | 0 | 0 | 1 |
| activo | BOOLEAN | 0 | 0 | 1 |

**Claves del origen:** pk_insumo.

**Modificaciones MR-3:** MR3-02.

### RECETA

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idReceta | BIGINT | 1 | 0 | 1 |
| idProducto | BIGINT | 0 | 1 | 1 |

**Claves del origen:** pk_receta, uq_receta_0.

### VERSION_RECETA

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idReceta | BIGINT | 1 | 1 | 1 |
| numeroVersion | INTEGER | 1 | 0 | 1 |
| vigenteDesde | TIMESTAMPTZ | 0 | 0 | 1 |
| vigenteHasta | TIMESTAMPTZ | 0 | 0 | 0 |
| cantidadRendimientoBase | NUMERIC(18,3) | 0 | 0 | 1 |
| codigoUnidadRendimiento | VARCHAR(20) | 0 | 1 | 1 |

**Claves del origen:** pk_version_receta.

**Modificaciones MR-3:** MR3-03.

### DETALLE_VERSION_RECETA

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idReceta | BIGINT | 1 | 1 | 1 |
| numeroVersion | INTEGER | 1 | 1 | 1 |
| idInsumo | BIGINT | 1 | 1 | 1 |
| cantidadNecesaria | NUMERIC(18,3) | 0 | 0 | 1 |
| codigoUnidadCantidad | VARCHAR(20) | 0 | 1 | 1 |

**Claves del origen:** pk_detalle_version_receta.

### PREPARACION

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idPreparacion | BIGINT | 1 | 0 | 1 |
| idPedido | BIGINT | 0 | 1 | 1 |
| numeroDetalle | INTEGER | 0 | 1 | 1 |
| idReceta | BIGINT | 0 | 1 | 1 |
| numeroVersion | INTEGER | 0 | 1 | 1 |
| fechaHoraPreparacion | TIMESTAMPTZ | 0 | 0 | 1 |
| cantidadPreparada | NUMERIC(18,3) | 0 | 0 | 1 |

**Claves del origen:** pk_preparacion.

### COSTO_INSUMO_HISTORICO

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idInsumo | BIGINT | 1 | 1 | 1 |
| vigenteDesde | TIMESTAMPTZ | 1 | 0 | 1 |
| vigenteHasta | TIMESTAMPTZ | 0 | 0 | 0 |
| costoUnitario | NUMERIC(18,4) | 0 | 0 | 1 |
| fuenteCosto | VARCHAR(30) | 0 | 0 | 1 |
| referenciaOrigen | VARCHAR(100) | 0 | 0 | 0 |
| idRecepcionCompra | BIGINT | 0 | 1 | 0 |

**Claves del origen:** pk_costo_insumo_historico, uq_costo_insumo_historico_0.

### MOVIMIENTO_INSUMO

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idMovimientoInsumo | BIGINT | 1 | 0 | 1 |
| idInsumo | BIGINT | 0 | 1 | 1 |
| numeroSecuenciaInsumo | BIGINT | 0 | 0 | 1 |
| idPreparacion | BIGINT | 0 | 1 | 0 |
| idRecepcionCompra | BIGINT | 0 | 1 | 0 |
| vigenteDesdeCosto | TIMESTAMPTZ | 0 | 1 | 1 |
| idUsuarioResponsable | BIGINT | 0 | 1 | 1 |
| tipoMovimiento | VARCHAR(30) | 0 | 0 | 1 |
| cantidad | NUMERIC(18,3) | 0 | 0 | 1 |
| fechaHora | TIMESTAMPTZ | 0 | 0 | 1 |
| stockResultante | NUMERIC(18,3) | 0 | 0 | 1 |
| origen | VARCHAR(30) | 0 | 0 | 1 |
| referenciaOrigen | VARCHAR(100) | 0 | 0 | 0 |
| motivo | TEXT | 0 | 0 | 0 |
| observacion | TEXT | 0 | 0 | 0 |

**Claves del origen:** pk_movimiento_insumo, uq_movimiento_insumo_0, uq_movimiento_insumo_1.

**Modificaciones MR-3:** MR3-01.

### PEDIDO

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idPedido | BIGINT | 1 | 0 | 1 |
| idCliente | BIGINT | 0 | 1 | 1 |
| idUsuarioCreador | BIGINT | 0 | 1 | 0 |
| idSesionOnline | UUID | 0 | 1 | 0 |
| fechaHoraCarga | TIMESTAMPTZ | 0 | 0 | 1 |
| fechaReparto | DATE | 0 | 0 | 1 |
| canalOrigen | VARCHAR(10) | 0 | 0 | 1 |
| estado | VARCHAR(15) | 0 | 0 | 1 |
| categoriaComercialAplicada | VARCHAR(20) | 0 | 0 | 1 |
| idPoliticaComercialAplicada | BIGINT | 0 | 1 | 1 |
| tipoAjuste | VARCHAR(15) | 0 | 0 | 1 |
| porcentajeAjuste | NUMERIC(5,2) | 0 | 0 | 1 |
| totalOriginal | NUMERIC(18,2) | 0 | 0 | 1 |
| motivoCancelacion | TEXT | 0 | 0 | 0 |
| fechaHoraCancelacion | TIMESTAMPTZ | 0 | 0 | 0 |
| idOperacionOrigen | UUID | 0 | 0 | 0 |
| direccionEntregaCalle | VARCHAR(150) | 0 | 0 | 1 |
| direccionEntregaNumero | VARCHAR(20) | 0 | 0 | 0 |
| direccionEntregaPiso | VARCHAR(10) | 0 | 0 | 0 |
| direccionEntregaUnidadFuncional | VARCHAR(20) | 0 | 0 | 0 |
| direccionEntregaLocalidad | VARCHAR(100) | 0 | 0 | 1 |
| direccionEntregaProvincia | VARCHAR(100) | 0 | 0 | 0 |
| direccionEntregaReferencia | VARCHAR(250) | 0 | 0 | 0 |
| direccionEntregaZona | VARCHAR(100) | 0 | 0 | 0 |

**Claves del origen:** pk_pedido, uq_pedido_0, uq_pedido_1.

### DETALLE_PEDIDO

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idPedido | BIGINT | 1 | 1 | 1 |
| numeroDetalle | INTEGER | 1 | 0 | 1 |
| idProducto | BIGINT | 0 | 1 | 1 |
| codigoUnidadVenta | VARCHAR(20) | 0 | 1 | 1 |
| cantidadOriginal | NUMERIC(18,3) | 0 | 0 | 1 |
| precioUnitarioOriginal | NUMERIC(18,4) | 0 | 0 | 0 |
| porcentajePromocionOriginal | NUMERIC(5,2) | 0 | 0 | 1 |
| idPromocionAplicada | BIGINT | 0 | 1 | 0 |

**Claves del origen:** pk_detalle_pedido, uq_detalle_pedido_0, uq_detalle_pedido_1.

### ASIGNACION_REPARTO

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idPedido | BIGINT | 1 | 1 | 1 |
| numeroAsignacion | INTEGER | 1 | 0 | 1 |
| idUsuarioRepartidor | BIGINT | 0 | 1 | 1 |
| idUsuarioVendedor | BIGINT | 0 | 1 | 1 |
| fechaHoraInicio | TIMESTAMPTZ | 0 | 0 | 1 |
| fechaHoraFin | TIMESTAMPTZ | 0 | 0 | 0 |
| motivoReasignacion | TEXT | 0 | 0 | 0 |

**Claves del origen:** pk_asignacion_reparto.

### ENTREGA

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idPedido | BIGINT | 1 | 1 | 1 |
| fechaHoraEntrega | TIMESTAMPTZ | 0 | 0 | 1 |
| idUsuarioRepartidor | BIGINT | 0 | 1 | 1 |

**Claves del origen:** pk_entrega.

### DETALLE_ENTREGA

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idPedido | BIGINT | 1 | 1 | 1 |
| numeroDetalle | INTEGER | 1 | 1 | 1 |
| cantidadEntregada | NUMERIC(18,3) | 0 | 0 | 1 |
| costoHistoricoElaboradoVendido | NUMERIC(18,4) | 0 | 0 | 0 |

**Claves del origen:** pk_detalle_entrega.

### EXCEDENTE

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idExcedente | BIGINT | 1 | 0 | 1 |
| idPedidoOrigen | BIGINT | 0 | 1 | 1 |
| numeroDetalleOrigen | INTEGER | 0 | 1 | 1 |
| origenGeneracion | VARCHAR(15) | 0 | 0 | 1 |
| fechaHoraGeneracion | TIMESTAMPTZ | 0 | 0 | 1 |
| cantidadInicial | NUMERIC(18,3) | 0 | 0 | 1 |
| cantidadDisponible | NUMERIC(18,3) | 0 | 0 | 1 |
| costoHistoricoInicial | NUMERIC(18,4) | 0 | 0 | 1 |
| costoHistoricoDisponible | NUMERIC(18,4) | 0 | 0 | 1 |
| idMovimientoExcedenteOrigen | BIGINT | 0 | 1 | 0 |

**Claves del origen:** pk_excedente.

### OFERTA_EXCEDENTE

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idOfertaExcedente | BIGINT | 1 | 0 | 1 |
| idExcedente | BIGINT | 0 | 1 | 1 |
| idPedidoReceptor | BIGINT | 0 | 1 | 1 |
| idUsuarioVendedor | BIGINT | 0 | 1 | 1 |
| fechaHoraOferta | TIMESTAMPTZ | 0 | 0 | 1 |
| cantidadOfrecida | NUMERIC(18,3) | 0 | 0 | 1 |
| importeInformado | NUMERIC(18,2) | 0 | 0 | 1 |
| respuesta | VARCHAR(15) | 0 | 0 | 1 |
| fechaHoraRespuesta | TIMESTAMPTZ | 0 | 0 | 0 |
| cantidadAceptada | NUMERIC(18,3) | 0 | 0 | 0 |
| importeAceptado | NUMERIC(18,2) | 0 | 0 | 0 |

**Claves del origen:** pk_oferta_excedente, uq_oferta_excedente_0.

### MOVIMIENTO_EXCEDENTE

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idMovimientoExcedente | BIGINT | 1 | 0 | 1 |
| idExcedente | BIGINT | 0 | 1 | 1 |
| idOfertaExcedente | BIGINT | 0 | 1 | 0 |
| tipoMovimiento | VARCHAR(15) | 0 | 0 | 1 |
| cantidad | NUMERIC(18,3) | 0 | 0 | 1 |
| costoHistoricoSalida | NUMERIC(18,4) | 0 | 0 | 1 |
| fechaHoraMovimiento | TIMESTAMPTZ | 0 | 0 | 1 |
| motivoDescarte | TEXT | 0 | 0 | 0 |

**Claves del origen:** pk_movimiento_excedente, uq_movimiento_excedente_0.

### IMPUTACION_ENTREGA_ADICIONAL

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idPedido | BIGINT | 1 | 1 | 1 |
| numeroDetalle | INTEGER | 1 | 1 | 1 |
| idMovimientoExcedente | BIGINT | 1 | 1 | 1 |
| cantidadImputada | NUMERIC(18,3) | 0 | 0 | 1 |
| importeImputado | NUMERIC(18,2) | 0 | 0 | 1 |

**Claves del origen:** pk_imputacion_entrega_adicional, uq_imputacion_entrega_adicional_0.

### PRECIO_PRODUCTO

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idPrecio | BIGINT | 1 | 0 | 1 |
| idProducto | BIGINT | 0 | 1 | 1 |
| precioBase | NUMERIC(18,4) | 0 | 0 | 1 |
| vigenteDesde | TIMESTAMPTZ | 0 | 0 | 1 |
| vigenteHasta | TIMESTAMPTZ | 0 | 0 | 0 |
| fechaHoraRegistro | TIMESTAMPTZ | 0 | 0 | 1 |
| idUsuarioRegistro | BIGINT | 0 | 1 | 1 |
| fechaHoraCancelacion | TIMESTAMPTZ | 0 | 0 | 0 |
| idUsuarioCancelacion | BIGINT | 0 | 1 | 0 |

**Claves del origen:** pk_precio_producto.

**Modificaciones MR-3:** MR3-03.

### AUDITORIA_PRECIO

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idAuditoriaPrecio | BIGINT | 1 | 0 | 1 |
| idPrecio | BIGINT | 0 | 1 | 1 |
| idUsuario | BIGINT | 0 | 1 | 1 |
| fechaHoraEvento | TIMESTAMPTZ | 0 | 0 | 1 |
| tipoEvento | VARCHAR(30) | 0 | 0 | 1 |
| precioAnterior | NUMERIC(18,4) | 0 | 0 | 0 |
| precioNuevo | NUMERIC(18,4) | 0 | 0 | 0 |
| vigenteDesdeAnterior | TIMESTAMPTZ | 0 | 0 | 0 |
| vigenteDesdeNuevo | TIMESTAMPTZ | 0 | 0 | 0 |
| vigenteHastaAnterior | TIMESTAMPTZ | 0 | 0 | 0 |
| vigenteHastaNuevo | TIMESTAMPTZ | 0 | 0 | 0 |

**Claves del origen:** pk_auditoria_precio.

### PROMOCION

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idPromocion | BIGINT | 1 | 0 | 1 |
| descripcion | VARCHAR(300) | 0 | 0 | 1 |
| porcentajeDescuento | NUMERIC(5,2) | 0 | 0 | 1 |
| vigenteDesde | TIMESTAMPTZ | 0 | 0 | 1 |
| vigenteHasta | TIMESTAMPTZ | 0 | 0 | 1 |
| estado | VARCHAR(30) | 0 | 0 | 1 |
| fechaHoraCreacion | TIMESTAMPTZ | 0 | 0 | 1 |
| idUsuarioCreador | BIGINT | 0 | 1 | 1 |
| codigoAccesoOnline | UUID | 0 | 0 | 1 |

**Claves del origen:** pk_promocion, uq_promocion_0.

**Modificaciones MR-3:** MR3-04.

### PROMOCION_PRODUCTO

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idPromocion | BIGINT | 1 | 1 | 1 |
| idProducto | BIGINT | 1 | 1 | 1 |

**Claves del origen:** pk_promocion_producto.

### DESTINATARIO_PROMOCION

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idPromocion | BIGINT | 1 | 1 | 1 |
| idCliente | BIGINT | 1 | 1 | 1 |
| fechaHoraSeleccion | TIMESTAMPTZ | 0 | 0 | 1 |

**Claves del origen:** pk_destinatario_promocion.

### INTENTO_COMUNICACION

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idPromocion | BIGINT | 1 | 1 | 1 |
| idCliente | BIGINT | 1 | 1 | 1 |
| numeroIntento | INTEGER | 1 | 0 | 1 |
| fechaHoraIntento | TIMESTAMPTZ | 0 | 0 | 1 |
| canal | VARCHAR(30) | 0 | 0 | 1 |
| resultado | VARCHAR(30) | 0 | 0 | 1 |
| fechaHoraResultado | TIMESTAMPTZ | 0 | 0 | 0 |
| claveIdempotencia | UUID | 0 | 0 | 1 |
| referenciaExterna | VARCHAR(150) | 0 | 0 | 0 |

**Claves del origen:** pk_intento_comunicacion, uq_intento_comunicacion_0, uq_intento_comunicacion_1.

### POLITICA_CATEGORIA_COMERCIAL

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idPoliticaComercial | BIGINT | 1 | 0 | 1 |
| diasToleranciaMora | INTEGER | 0 | 0 | 1 |
| vigenteDesde | TIMESTAMPTZ | 0 | 0 | 1 |
| vigenteHasta | TIMESTAMPTZ | 0 | 0 | 0 |
| fechaHoraRegistro | TIMESTAMPTZ | 0 | 0 | 1 |
| idUsuarioRegistro | BIGINT | 0 | 1 | 1 |

**Claves del origen:** pk_politica_categoria_comercial.

**Modificaciones MR-3:** MR3-03.

### AJUSTE_POLITICA_CATEGORIA

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idPoliticaComercial | BIGINT | 1 | 1 | 1 |
| categoriaComercial | VARCHAR(20) | 1 | 0 | 1 |
| tipoAjuste | VARCHAR(15) | 0 | 0 | 1 |
| porcentajeAjuste | NUMERIC(5,2) | 0 | 0 | 1 |

**Claves del origen:** pk_ajuste_politica_categoria.

### CLIENTE

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idCliente | BIGINT | 1 | 0 | 1 |
| nombres | VARCHAR(120) | 0 | 0 | 1 |
| apellidos | VARCHAR(120) | 0 | 0 | 0 |
| telefonoPrincipal | VARCHAR(20) | 0 | 0 | 1 |
| calle | VARCHAR(150) | 0 | 0 | 0 |
| numeroPuerta | VARCHAR(20) | 0 | 0 | 0 |
| piso | VARCHAR(10) | 0 | 0 | 0 |
| unidadFuncional | VARCHAR(20) | 0 | 0 | 0 |
| localidad | VARCHAR(100) | 0 | 0 | 0 |
| provincia | VARCHAR(100) | 0 | 0 | 0 |
| referenciaDomicilio | VARCHAR(250) | 0 | 0 | 0 |
| zona | VARCHAR(100) | 0 | 0 | 0 |
| diaHabitualReparto | SMALLINT | 0 | 0 | 0 |
| estado | VARCHAR(10) | 0 | 0 | 1 |
| categoriaComercial | VARCHAR(20) | 0 | 0 | 1 |
| fechaHoraAlta | TIMESTAMPTZ | 0 | 0 | 1 |

**Claves del origen:** pk_cliente.

**Modificaciones MR-3:** MR3-02.

### HISTORIAL_ESTADO_CLIENTE

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idCliente | BIGINT | 1 | 1 | 1 |
| numeroCambio | INTEGER | 1 | 0 | 1 |
| estadoAnterior | VARCHAR(10) | 0 | 0 | 1 |
| estadoNuevo | VARCHAR(10) | 0 | 0 | 1 |
| fechaHoraCambio | TIMESTAMPTZ | 0 | 0 | 1 |
| motivo | TEXT | 0 | 0 | 0 |
| idUsuarioAdministrador | BIGINT | 0 | 1 | 1 |

**Claves del origen:** pk_historial_estado_cliente.

### USUARIO

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idUsuario | BIGINT | 1 | 0 | 1 |
| nombreUsuario | VARCHAR(80) | 0 | 0 | 1 |
| credencialProtegida | VARCHAR(255) | 0 | 0 | 1 |
| estado | VARCHAR(15) | 0 | 0 | 1 |
| cambioCredencialPendiente | BOOLEAN | 0 | 0 | 1 |
| fechaHoraAlta | TIMESTAMPTZ | 0 | 0 | 1 |
| fechaHoraDeshabilitacion | TIMESTAMPTZ | 0 | 0 | 0 |

**Claves del origen:** pk_usuario.

### ROL

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| codigoRol | VARCHAR(30) | 1 | 0 | 1 |
| nombreMostrado | VARCHAR(100) | 0 | 0 | 1 |

**Claves del origen:** pk_rol, uq_rol_0.

### USUARIO_ROL

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idUsuario | BIGINT | 1 | 1 | 1 |
| codigoRol | VARCHAR(30) | 1 | 1 | 1 |
| fechaHoraAsignacion | TIMESTAMPTZ | 0 | 0 | 1 |

**Claves del origen:** pk_usuario_rol.

### EVENTO_ASIGNACION_ROL

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idEventoRol | BIGINT | 1 | 0 | 1 |
| idUsuario | BIGINT | 0 | 1 | 1 |
| codigoRol | VARCHAR(30) | 0 | 1 | 1 |
| tipoEvento | VARCHAR(15) | 0 | 0 | 1 |
| fechaHoraEvento | TIMESTAMPTZ | 0 | 0 | 1 |
| idUsuarioAdministrador | BIGINT | 0 | 1 | 1 |

**Claves del origen:** pk_evento_asignacion_rol.

### USUARIO_PROVEEDOR

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idUsuario | BIGINT | 1 | 1 | 1 |
| idProveedor | BIGINT | 0 | 1 | 1 |
| fechaHoraVinculacion | TIMESTAMPTZ | 0 | 0 | 1 |

**Claves del origen:** pk_usuario_proveedor.

### SESION_USUARIO

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idSesionUsuario | UUID | 1 | 0 | 1 |
| idUsuario | BIGINT | 0 | 1 | 1 |
| tokenProtegido | BYTEA | 0 | 0 | 1 |
| fechaHoraInicio | TIMESTAMPTZ | 0 | 0 | 1 |
| fechaHoraExpiracion | TIMESTAMPTZ | 0 | 0 | 1 |
| fechaHoraRevocacion | TIMESTAMPTZ | 0 | 0 | 0 |

**Claves del origen:** pk_sesion_usuario, uq_sesion_usuario_0.

### DESAFIO_AUTENTICACION_CLIENTE

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idDesafio | UUID | 1 | 0 | 1 |
| idCliente | BIGINT | 0 | 1 | 1 |
| telefonoDestino | VARCHAR(20) | 0 | 0 | 1 |
| codigoProtegido | BYTEA | 0 | 0 | 1 |
| fechaHoraCreacion | TIMESTAMPTZ | 0 | 0 | 1 |
| fechaHoraAceptacionEnvio | TIMESTAMPTZ | 0 | 0 | 0 |
| fechaHoraExpiracion | TIMESTAMPTZ | 0 | 0 | 1 |
| intentosFallidos | SMALLINT | 0 | 0 | 1 |
| fechaHoraValidacion | TIMESTAMPTZ | 0 | 0 | 0 |
| fechaHoraBloqueo | TIMESTAMPTZ | 0 | 0 | 0 |

**Claves del origen:** pk_desafio_autenticacion_cliente.

### SESION_CLIENTE_ONLINE

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idSesionOnline | UUID | 1 | 0 | 1 |
| idDesafio | UUID | 0 | 1 | 1 |
| tokenProtegido | BYTEA | 0 | 0 | 1 |
| fechaHoraInicio | TIMESTAMPTZ | 0 | 0 | 1 |
| fechaHoraExpiracion | TIMESTAMPTZ | 0 | 0 | 1 |
| fechaHoraRevocacion | TIMESTAMPTZ | 0 | 0 | 0 |

**Claves del origen:** pk_sesion_cliente_online, uq_sesion_cliente_online_0, uq_sesion_cliente_online_1.

### PROVEEDOR

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idProveedor | BIGINT | 1 | 0 | 1 |
| cuit | CHAR(11) | 0 | 0 | 1 |
| razonSocial | VARCHAR(180) | 0 | 0 | 1 |
| telefonoContacto | VARCHAR(20) | 0 | 0 | 0 |
| emailContacto | VARCHAR(254) | 0 | 0 | 0 |
| calle | VARCHAR(150) | 0 | 0 | 0 |
| numeroPuerta | VARCHAR(20) | 0 | 0 | 0 |
| localidad | VARCHAR(100) | 0 | 0 | 0 |
| provincia | VARCHAR(100) | 0 | 0 | 0 |
| estado | VARCHAR(10) | 0 | 0 | 1 |
| fechaHoraAlta | TIMESTAMPTZ | 0 | 0 | 1 |

**Claves del origen:** pk_proveedor, uq_proveedor_0.

### HISTORIAL_ESTADO_PROVEEDOR

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idProveedor | BIGINT | 1 | 1 | 1 |
| numeroCambio | INTEGER | 1 | 0 | 1 |
| estadoAnterior | VARCHAR(10) | 0 | 0 | 1 |
| estadoNuevo | VARCHAR(10) | 0 | 0 | 1 |
| fechaHoraCambio | TIMESTAMPTZ | 0 | 0 | 1 |
| idUsuarioAdministrador | BIGINT | 0 | 1 | 1 |
| motivo | TEXT | 0 | 0 | 0 |

**Claves del origen:** pk_historial_estado_proveedor.

### PROVEEDOR_INSUMO

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idProveedor | BIGINT | 1 | 1 | 1 |
| idInsumo | BIGINT | 1 | 1 | 1 |
| vigenteDesde | TIMESTAMPTZ | 1 | 0 | 1 |
| vigenteHasta | TIMESTAMPTZ | 0 | 0 | 0 |

**Claves del origen:** pk_proveedor_insumo.

### EPISODIO_FALTANTE

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idEpisodio | BIGINT | 1 | 0 | 1 |
| idInsumo | BIGINT | 0 | 1 | 1 |
| fechaHoraInicio | TIMESTAMPTZ | 0 | 0 | 1 |
| fechaHoraCierre | TIMESTAMPTZ | 0 | 0 | 0 |
| idMovimientoApertura | BIGINT | 0 | 1 | 0 |
| plazoRespuestaHorasAplicado | INTEGER | 0 | 0 | 0 |
| idUsuarioAjustePlazo | BIGINT | 0 | 1 | 0 |

**Claves del origen:** pk_episodio_faltante, uq_episodio_faltante_0.

**Modificaciones MR-3:** MR3-05.

### SOLICITUD_COTIZACION

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idSolicitud | BIGINT | 1 | 0 | 1 |
| idEpisodio | BIGINT | 0 | 1 | 1 |
| idSolicitudAnterior | BIGINT | 0 | 1 | 0 |
| idUsuarioEmisor | BIGINT | 0 | 1 | 0 |
| cantidadSolicitada | NUMERIC(18,3) | 0 | 0 | 1 |
| fechaHoraEmision | TIMESTAMPTZ | 0 | 0 | 1 |
| fechaHoraVencimiento | TIMESTAMPTZ | 0 | 0 | 1 |
| fechaHoraFinRecepcion | TIMESTAMPTZ | 0 | 0 | 0 |
| modalidadInicio | VARCHAR(15) | 0 | 0 | 1 |
| estado | VARCHAR(30) | 0 | 0 | 1 |
| motivoCierre | VARCHAR(40) | 0 | 0 | 0 |
| fechaHoraResolucion | TIMESTAMPTZ | 0 | 0 | 0 |

**Claves del origen:** pk_solicitud_cotizacion, uq_solicitud_cotizacion_0, uq_solicitud_cotizacion_1.

### INVITACION_COTIZACION

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idSolicitud | BIGINT | 1 | 1 | 1 |
| idProveedor | BIGINT | 1 | 1 | 1 |

**Claves del origen:** pk_invitacion_cotizacion.

### RESPUESTA_COTIZACION

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idRespuesta | BIGINT | 1 | 0 | 1 |
| idSolicitud | BIGINT | 0 | 1 | 1 |
| idProveedor | BIGINT | 0 | 1 | 1 |
| idUsuarioRegistrador | BIGINT | 0 | 1 | 1 |
| cantidadOfrecida | NUMERIC(18,3) | 0 | 0 | 1 |
| precioUnitario | NUMERIC(18,4) | 0 | 0 | 0 |
| tiempoEntregaEstimado | INTERVAL | 0 | 0 | 0 |
| fechaHoraRespuesta | TIMESTAMPTZ | 0 | 0 | 1 |

**Claves del origen:** pk_respuesta_cotizacion, uq_respuesta_cotizacion_0, uq_respuesta_cotizacion_1.

**Modificaciones MR-3:** MR3-06.

### POLITICA_COMPRA

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idPoliticaCompra | BIGINT | 1 | 0 | 1 |
| numeroVersion | INTEGER | 0 | 0 | 1 |
| vigenteDesde | TIMESTAMPTZ | 0 | 0 | 1 |
| vigenteHasta | TIMESTAMPTZ | 0 | 0 | 0 |
| periodoCalculoDias | INTEGER | 0 | 0 | 0 |
| fechaHoraRegistro | TIMESTAMPTZ | 0 | 0 | 1 |
| idUsuarioRegistro | BIGINT | 0 | 1 | 1 |

**Claves del origen:** pk_politica_compra, uq_politica_compra_0.

**Modificaciones MR-3:** MR3-03.

### CRITERIO_POLITICA_COMPRA

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idPoliticaCompra | BIGINT | 1 | 1 | 1 |
| codigoCriterio | VARCHAR(40) | 1 | 0 | 1 |
| pesoRelativo | NUMERIC(12,6) | 0 | 0 | 0 |
| ordenDesempate | SMALLINT | 0 | 0 | 0 |

**Claves del origen:** pk_criterio_politica_compra, uq_criterio_politica_compra_0.

### DECISION_COMPRA

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idDecisionCompra | BIGINT | 1 | 0 | 1 |
| idSolicitud | BIGINT | 0 | 1 | 1 |
| idPoliticaCompra | BIGINT | 0 | 1 | 1 |
| idUsuarioAdministrador | BIGINT | 0 | 1 | 1 |
| idRespuestaSeleccionada | BIGINT | 0 | 1 | 0 |
| fechaHoraDecision | TIMESTAMPTZ | 0 | 0 | 1 |
| resultado | VARCHAR(15) | 0 | 0 | 1 |
| justificacion | TEXT | 0 | 0 | 1 |

**Claves del origen:** pk_decision_compra, uq_decision_compra_0.

### DETALLE_DECISION

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idDecisionCompra | BIGINT | 1 | 1 | 1 |
| idRespuesta | BIGINT | 1 | 1 | 1 |
| fechaHoraEvaluacion | TIMESTAMPTZ | 0 | 0 | 1 |
| elegible | BOOLEAN | 0 | 0 | 1 |
| estadoProveedorEvaluado | VARCHAR(10) | 0 | 0 | 1 |
| motivoInelegibilidad | TEXT | 0 | 0 | 0 |

**Claves del origen:** pk_detalle_decision.

### DETALLE_DECISION_CRITERIO

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idDecisionCompra | BIGINT | 1 | 1 | 1 |
| idRespuesta | BIGINT | 1 | 1 | 1 |
| codigoCriterio | VARCHAR(40) | 1 | 0 | 1 |
| valorNumerico | NUMERIC(18,6) | 0 | 0 | 0 |
| valorTexto | VARCHAR(200) | 0 | 0 | 0 |
| puntajeEvaluado | NUMERIC(18,6) | 0 | 0 | 0 |

**Claves del origen:** pk_detalle_decision_criterio.

**Modificaciones MR-3:** MR3-06.

### ORDEN_COMPRA

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idOrdenCompra | BIGINT | 1 | 0 | 1 |
| idDecisionCompra | BIGINT | 0 | 1 | 1 |
| cantidadOrdenada | NUMERIC(18,3) | 0 | 0 | 1 |
| precioUnitarioAcordado | NUMERIC(18,4) | 0 | 0 | 1 |
| fechaHoraEmision | TIMESTAMPTZ | 0 | 0 | 1 |
| fechaHoraComprometida | TIMESTAMPTZ | 0 | 0 | 0 |
| estado | VARCHAR(30) | 0 | 0 | 1 |
| fechaHoraCancelacion | TIMESTAMPTZ | 0 | 0 | 0 |
| idUsuarioCancelacion | BIGINT | 0 | 1 | 0 |
| motivoCancelacion | TEXT | 0 | 0 | 0 |
| cancelacionAtribuibleProveedor | BOOLEAN | 0 | 0 | 0 |

**Claves del origen:** pk_orden_compra, uq_orden_compra_0.

### RECEPCION_COMPRA

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idRecepcionCompra | BIGINT | 1 | 0 | 1 |
| idOrdenCompra | BIGINT | 0 | 1 | 0 |
| idProveedorDirecto | BIGINT | 0 | 1 | 0 |
| idInsumoRecibido | BIGINT | 0 | 1 | 0 |
| idProductoReventa | BIGINT | 0 | 1 | 0 |
| idUsuarioResponsable | BIGINT | 0 | 1 | 1 |
| fechaHoraRecepcion | TIMESTAMPTZ | 0 | 0 | 1 |
| cantidadRecibida | NUMERIC(18,3) | 0 | 0 | 1 |
| codigoUnidadMedida | VARCHAR(20) | 0 | 1 | 1 |
| costoUnitarioReal | NUMERIC(18,4) | 0 | 0 | 1 |
| factorConversionAplicado | NUMERIC(24,12) | 0 | 0 | 1 |
| referenciaComercial | VARCHAR(200) | 0 | 0 | 0 |

**Claves del origen:** pk_recepcion_compra, uq_recepcion_compra_0, uq_recepcion_compra_1.

### MOVIMIENTO_STOCK_REVENTA

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idMovimientoStockReventa | BIGINT | 1 | 0 | 1 |
| idProducto | BIGINT | 0 | 1 | 1 |
| numeroSecuenciaProducto | BIGINT | 0 | 0 | 1 |
| idRecepcionCompra | BIGINT | 0 | 1 | 0 |
| idPedidoEntrega | BIGINT | 0 | 1 | 0 |
| numeroDetalleEntrega | INTEGER | 0 | 1 | 0 |
| idValoracionReventa | BIGINT | 0 | 1 | 0 |
| idUsuarioResponsable | BIGINT | 0 | 1 | 1 |
| tipoMovimiento | VARCHAR(20) | 0 | 0 | 1 |
| cantidad | NUMERIC(18,3) | 0 | 0 | 1 |
| fechaHoraMovimiento | TIMESTAMPTZ | 0 | 0 | 1 |
| stockResultante | NUMERIC(18,3) | 0 | 0 | 1 |
| costoPromedioResultante | NUMERIC(18,4) | 0 | 0 | 0 |
| costoTotalHistoricoVenta | NUMERIC(18,4) | 0 | 0 | 0 |
| motivo | TEXT | 0 | 0 | 0 |
| observacion | TEXT | 0 | 0 | 0 |

**Claves del origen:** pk_movimiento_stock_reventa, uq_movimiento_stock_reventa_0, uq_movimiento_stock_reventa_1, uq_movimiento_stock_reventa_2, uq_movimiento_stock_reventa_3.

### VALORACION_EXTRAORDINARIA_REVENTA

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idValoracionReventa | BIGINT | 1 | 0 | 1 |
| idProducto | BIGINT | 0 | 1 | 1 |
| tipoValoracion | VARCHAR(20) | 0 | 0 | 1 |
| costoUnitario | NUMERIC(18,4) | 0 | 0 | 1 |
| fechaHoraValoracion | TIMESTAMPTZ | 0 | 0 | 1 |
| motivo | TEXT | 0 | 0 | 1 |
| idUsuarioResponsable | BIGINT | 0 | 1 | 1 |

**Claves del origen:** pk_valoracion_extraordinaria_reventa, uq_valoracion_extraordinaria_reventa_0.

### COBRO

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idCobro | BIGINT | 1 | 0 | 1 |
| idCliente | BIGINT | 0 | 1 | 1 |
| idPedido | BIGINT | 0 | 1 | 0 |
| idUsuarioRegistrador | BIGINT | 0 | 1 | 0 |
| fechaHoraCobro | TIMESTAMPTZ | 0 | 0 | 1 |
| importe | NUMERIC(18,2) | 0 | 0 | 1 |
| medioPago | VARCHAR(20) | 0 | 0 | 1 |
| origen | VARCHAR(20) | 0 | 0 | 1 |
| referenciaExterna | VARCHAR(150) | 0 | 0 | 0 |
| claveIdempotenciaOrigen | UUID | 0 | 0 | 0 |
| estadoCobro | VARCHAR(20) | 0 | 0 | 1 |

**Claves del origen:** pk_cobro, uq_cobro_0, uq_cobro_1, uq_cobro_2.

### MOVIMIENTO_CUENTA

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idMovimientoCuenta | BIGINT | 1 | 0 | 1 |
| idCliente | BIGINT | 0 | 1 | 1 |
| numeroSecuenciaCliente | BIGINT | 0 | 0 | 1 |
| tipoMovimiento | VARCHAR(20) | 0 | 0 | 1 |
| importe | NUMERIC(18,2) | 0 | 0 | 1 |
| fechaHoraMovimiento | TIMESTAMPTZ | 0 | 0 | 1 |
| saldoResultante | NUMERIC(18,2) | 0 | 0 | 1 |
| idUsuarioAjuste | BIGINT | 0 | 1 | 0 |
| observacion | TEXT | 0 | 0 | 0 |

**Claves del origen:** pk_movimiento_cuenta, uq_movimiento_cuenta_0.

**Modificaciones MR-3:** MR3-07.

### ORIGEN_MOVIMIENTO_CUENTA

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idMovimientoCuenta | BIGINT | 1 | 1 | 1 |
| idPedidoEntrega | BIGINT | 0 | 1 | 0 |
| idCobro | BIGINT | 0 | 1 | 0 |
| idReembolso | BIGINT | 0 | 1 | 0 |
| idCobroAnulado | BIGINT | 0 | 1 | 0 |

**Claves del origen:** pk_origen_movimiento_cuenta, uq_origen_movimiento_cuenta_0, uq_origen_movimiento_cuenta_1, uq_origen_movimiento_cuenta_2.

**Modificaciones MR-3:** MR3-07.

### MOVIMIENTO_CAJA

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idMovimientoCaja | BIGINT | 1 | 0 | 1 |
| tipoMovimiento | VARCHAR(10) | 0 | 0 | 1 |
| importe | NUMERIC(18,2) | 0 | 0 | 1 |
| fechaHoraMovimiento | TIMESTAMPTZ | 0 | 0 | 1 |
| origen | VARCHAR(15) | 0 | 0 | 1 |
| concepto | VARCHAR(200) | 0 | 0 | 0 |
| referencia | VARCHAR(150) | 0 | 0 | 0 |
| observacion | TEXT | 0 | 0 | 0 |
| idUsuarioRegistro | BIGINT | 0 | 1 | 0 |
| idCobro | BIGINT | 0 | 1 | 0 |
| idReembolso | BIGINT | 0 | 1 | 0 |
| idCobroAnulado | BIGINT | 0 | 1 | 0 |

**Claves del origen:** pk_movimiento_caja, uq_movimiento_caja_0, uq_movimiento_caja_1.

**Modificaciones MR-3:** MR3-07.

### REEMBOLSO

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idReembolso | BIGINT | 1 | 0 | 1 |
| idCobro | BIGINT | 0 | 1 | 1 |
| importeReembolso | NUMERIC(18,2) | 0 | 1 | 1 |
| fechaHoraCreacion | TIMESTAMPTZ | 0 | 0 | 1 |
| fechaHoraProcesamiento | TIMESTAMPTZ | 0 | 0 | 0 |
| motivo | TEXT | 0 | 0 | 1 |
| estado | VARCHAR(15) | 0 | 0 | 1 |

**Claves del origen:** pk_reembolso, uq_reembolso_0.

### INTENTO_REEMBOLSO

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idReembolso | BIGINT | 1 | 1 | 1 |
| numeroIntento | INTEGER | 1 | 0 | 1 |
| fechaHoraSolicitud | TIMESTAMPTZ | 0 | 0 | 1 |
| claveIdempotencia | UUID | 0 | 0 | 1 |
| referenciaOperacionExterna | VARCHAR(150) | 0 | 0 | 0 |
| idUsuarioReintento | BIGINT | 0 | 1 | 0 |

**Claves del origen:** pk_intento_reembolso, uq_intento_reembolso_0, uq_intento_reembolso_1.

**Modificaciones MR-3:** MR3-08.

### EVENTO_RESULTADO_REEMBOLSO

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| idEventoResultado | BIGINT | 1 | 0 | 1 |
| idReembolso | BIGINT | 0 | 1 | 0 |
| numeroIntento | INTEGER | 0 | 1 | 0 |
| identificadorEventoExterno | VARCHAR(150) | 0 | 0 | 0 |
| referenciaOperacionExterna | VARCHAR(150) | 0 | 0 | 0 |
| origenResultado | VARCHAR(25) | 0 | 0 | 1 |
| resultadoInformado | VARCHAR(15) | 0 | 0 | 0 |
| fechaHoraRecepcion | TIMESTAMPTZ | 0 | 0 | 1 |
| autenticado | BOOLEAN | 0 | 0 | 1 |
| aplicable | BOOLEAN | 0 | 0 | 1 |
| motivoNoAplicacion | TEXT | 0 | 0 | 0 |

**Claves del origen:** pk_evento_resultado_reembolso, uq_evento_resultado_reembolso_0.

### CONFIGURACION_OPERATIVA

| Columna | Tipo | PK | FK | NOT NULL |
|---|---|:---:|:---:|:---:|
| clave | VARCHAR(80) | 1 | 0 | 1 |
| valorEntero | INTEGER | 0 | 0 | 1 |
| fechaHoraModificacion | TIMESTAMPTZ | 0 | 0 | 1 |
| idUsuarioAdministrador | BIGINT | 0 | 1 | 1 |

**Claves del origen:** pk_configuracion_operativa.

**Modificaciones MR-3:** MR3-05.

## Límites de integridad pendientes de procedimientos y pruebas
- La migración aporta SQL concreto para aperturas de Inventario, vigencias, normalización, estados y contraasientos manuales.
- No certifica la integridad de todas las transacciones del catálogo (Pedidos, Reparto, Excedentes, compras, Reembolsos). Se requieren servicios con bloqueos y pruebas MR-4.
- Las cuentas de Proveedor y las reglas del último Administrador requieren ejecución atómica y controles de autorización adicionales.
- La política offline conserva snapshots confirmados y nunca acepta pagos duplicados ni accesos sin autorización.
- Plazo global definido en CONFIGURACION_OPERATIVA; duración no precargada. Para solicitudes emitidas, fechaHoraVencimiento es inmutable por el servicio.
- Puntaje mínimo si faltan datos; sumatoria ponderada configurable; empate residual por menor PRECIO TOTAL. Falta normalizar criterios con escala consensuada.
- Deuda originada en ENTREGA.fechaHoraEntrega. Sin asignación de Cobros por deuda, la antigüedad exacta de saldo por Pedido requiere política de imputación.
- idUsuarioReintento identifica al Administrador de intentos > 1; FK y CHECK documentan la elección solicitada.
- PAUSADA admite retorno a ACTIVA en el motor de estados, pero esa acción todavía necesita autorizaciones/UC documentado; UC-60 desactiva sin reactivar.
- Ni CU UML ni modelo gráfico fueron modificados.

## Reglas SQL adicionales MR3-16 a MR3-19

- **MR3-16:** INSERT nuevos de PEDIDO, DETALLE_PEDIDO, INVITACION_COTIZACION y ORDEN_COMPRA filtran Clientes, Productos y Proveedores activos. UPDATE y recepción de Órdenes ya emitidas no se cancelan en automático.
- **MR3-17:** las fechas y cantidad de SOLICITUD_COTIZACION emitida son inmutables; su estado sí transita.
- **MR3-18:** tres constraint triggers diferidos garantizan que la marca de Cobro ANULADO tenga un contraasiento de Caja y Cuenta Corriente al final de la transacción.
- **MR3-19:** la autorización específica del Repartidor para registrar Cobros permanece **no aprobada** en la matriz RBAC; el ejemplo offline no equivale a nueva asignación de permisos.


## Referencias FK por tabla (versión MR-3)

### AJUSTE_POLITICA_CATEGORIA
- `fk_ajuste_politica_categoria_0`: ("idPoliticaComercial") → POLITICA_CATEGORIA_COMERCIAL("idPoliticaComercial")

### ASIGNACION_REPARTO
- `fk_asignacion_reparto_0`: ("idPedido") → PEDIDO("idPedido")
- `fk_asignacion_reparto_1`: ("idUsuarioRepartidor") → USUARIO("idUsuario")
- `fk_asignacion_reparto_2`: ("idUsuarioVendedor") → USUARIO("idUsuario")

### AUDITORIA_PRECIO
- `fk_auditoria_precio_0`: ("idPrecio") → PRECIO_PRODUCTO("idPrecio")
- `fk_auditoria_precio_1`: ("idUsuario") → USUARIO("idUsuario")

### COBRO
- `fk_cobro_0`: ("idCliente") → CLIENTE("idCliente")
- `fk_cobro_1`: ("idUsuarioRegistrador") → USUARIO("idUsuario")
- `fk_cobro_2`: ("idPedido", "idCliente") → PEDIDO("idPedido", "idCliente")

### CONFIGURACION_OPERATIVA
- `fk_configuracion_operativa_usuario`: idUsuarioAdministrador → USUARIO(idUsuario)

### COSTO_INSUMO_HISTORICO
- `fk_costo_insumo_historico_0`: ("idInsumo") → INSUMO("idInsumo")
- `fk_costo_insumo_historico_1`: ("idRecepcionCompra", "idInsumo") → RECEPCION_COMPRA("idRecepcionCompra", "idInsumoRecibido")

### CRITERIO_POLITICA_COMPRA
- `fk_criterio_politica_compra_0`: ("idPoliticaCompra") → POLITICA_COMPRA("idPoliticaCompra")

### DECISION_COMPRA
- `fk_decision_compra_0`: ("idSolicitud") → SOLICITUD_COTIZACION("idSolicitud")
- `fk_decision_compra_1`: ("idPoliticaCompra") → POLITICA_COMPRA("idPoliticaCompra")
- `fk_decision_compra_2`: ("idUsuarioAdministrador") → USUARIO("idUsuario")
- `fk_decision_compra_3`: ("idRespuestaSeleccionada", "idSolicitud") → RESPUESTA_COTIZACION("idRespuesta", "idSolicitud")

### DESAFIO_AUTENTICACION_CLIENTE
- `fk_desafio_autenticacion_cliente_0`: ("idCliente") → CLIENTE("idCliente")

### DESTINATARIO_PROMOCION
- `fk_destinatario_promocion_0`: ("idPromocion") → PROMOCION("idPromocion")
- `fk_destinatario_promocion_1`: ("idCliente") → CLIENTE("idCliente")

### DETALLE_DECISION
- `fk_detalle_decision_0`: ("idDecisionCompra") → DECISION_COMPRA("idDecisionCompra")
- `fk_detalle_decision_1`: ("idRespuesta") → RESPUESTA_COTIZACION("idRespuesta")

### DETALLE_DECISION_CRITERIO
- `fk_detalle_decision_criterio_0`: ("idDecisionCompra", "idRespuesta") → DETALLE_DECISION("idDecisionCompra", "idRespuesta")

### DETALLE_ENTREGA
- `fk_detalle_entrega_0`: ("idPedido") → ENTREGA("idPedido")
- `fk_detalle_entrega_1`: ("idPedido", "numeroDetalle") → DETALLE_PEDIDO("idPedido", "numeroDetalle")

### DETALLE_PEDIDO
- `fk_detalle_pedido_0`: ("idPedido") → PEDIDO("idPedido")
- `fk_detalle_pedido_1`: ("idProducto") → PRODUCTO("idProducto")
- `fk_detalle_pedido_2`: ("codigoUnidadVenta") → UNIDAD_MEDIDA("codigoUnidad")
- `fk_detalle_pedido_3`: ("idPromocionAplicada") → PROMOCION("idPromocion")

### DETALLE_VERSION_RECETA
- `fk_detalle_version_receta_0`: ("idReceta", "numeroVersion") → VERSION_RECETA("idReceta", "numeroVersion")
- `fk_detalle_version_receta_1`: ("idInsumo") → INSUMO("idInsumo")
- `fk_detalle_version_receta_2`: ("codigoUnidadCantidad") → UNIDAD_MEDIDA("codigoUnidad")

### ENTREGA
- `fk_entrega_0`: ("idPedido") → PEDIDO("idPedido")
- `fk_entrega_1`: ("idUsuarioRepartidor") → USUARIO("idUsuario")

### EPISODIO_FALTANTE
- `fk_episodio_faltante_0`: ("idInsumo") → INSUMO("idInsumo")
- `fk_episodio_faltante_1`: ("idMovimientoApertura") → MOVIMIENTO_INSUMO("idMovimientoInsumo")
- `fk_episodio_usuario_ajuste_plazo`: idUsuarioAjustePlazo → USUARIO(idUsuario)

### EVENTO_ASIGNACION_ROL
- `fk_evento_asignacion_rol_0`: ("idUsuario") → USUARIO("idUsuario")
- `fk_evento_asignacion_rol_1`: ("codigoRol") → ROL("codigoRol")
- `fk_evento_asignacion_rol_2`: ("idUsuarioAdministrador") → USUARIO("idUsuario")

### EVENTO_RESULTADO_REEMBOLSO
- `fk_evento_resultado_reembolso_0`: ("idReembolso", "numeroIntento") → INTENTO_REEMBOLSO("idReembolso", "numeroIntento")

### EXCEDENTE
- `fk_excedente_0`: ("idPedidoOrigen", "numeroDetalleOrigen") → DETALLE_PEDIDO("idPedido", "numeroDetalle")
- `fk_excedente_1`: ("idMovimientoExcedenteOrigen") → MOVIMIENTO_EXCEDENTE("idMovimientoExcedente")

### HISTORIAL_ESTADO_CLIENTE
- `fk_historial_estado_cliente_0`: ("idCliente") → CLIENTE("idCliente")
- `fk_historial_estado_cliente_1`: ("idUsuarioAdministrador") → USUARIO("idUsuario")

### HISTORIAL_ESTADO_PROVEEDOR
- `fk_historial_estado_proveedor_0`: ("idProveedor") → PROVEEDOR("idProveedor")
- `fk_historial_estado_proveedor_1`: ("idUsuarioAdministrador") → USUARIO("idUsuario")

### IMPUTACION_ENTREGA_ADICIONAL
- `fk_imputacion_entrega_adicional_0`: ("idPedido", "numeroDetalle") → DETALLE_ENTREGA("idPedido", "numeroDetalle")
- `fk_imputacion_entrega_adicional_1`: ("idMovimientoExcedente") → MOVIMIENTO_EXCEDENTE("idMovimientoExcedente")

### INSUMO
- `fk_insumo_0`: ("codigoUnidadMedida") → UNIDAD_MEDIDA("codigoUnidad")

### INTENTO_COMUNICACION
- `fk_intento_comunicacion_0`: ("idPromocion", "idCliente") → DESTINATARIO_PROMOCION("idPromocion", "idCliente")

### INTENTO_REEMBOLSO
- `fk_intento_reembolso_0`: ("idReembolso") → REEMBOLSO("idReembolso")
- `fk_intento_reembolso_usuario_reintento`: idUsuarioReintento → USUARIO(idUsuario)

### INVITACION_COTIZACION
- `fk_invitacion_cotizacion_0`: ("idSolicitud") → SOLICITUD_COTIZACION("idSolicitud")
- `fk_invitacion_cotizacion_1`: ("idProveedor") → PROVEEDOR("idProveedor")

### MOVIMIENTO_CAJA
- `fk_movimiento_caja_0`: ("idUsuarioRegistro") → USUARIO("idUsuario")
- `fk_movimiento_caja_1`: ("idCobro") → COBRO("idCobro")
- `fk_movimiento_caja_2`: ("idReembolso") → REEMBOLSO("idReembolso")
- `fk_caja_cobro_anulado`: idCobroAnulado → COBRO(idCobro)

### MOVIMIENTO_CUENTA
- `fk_movimiento_cuenta_0`: ("idCliente") → CLIENTE("idCliente")
- `fk_movimiento_cuenta_1`: ("idUsuarioAjuste") → USUARIO("idUsuario")

### MOVIMIENTO_EXCEDENTE
- `fk_movimiento_excedente_0`: ("idExcedente") → EXCEDENTE("idExcedente")
- `fk_movimiento_excedente_1`: ("idOfertaExcedente", "idExcedente") → OFERTA_EXCEDENTE("idOfertaExcedente", "idExcedente")

### MOVIMIENTO_INSUMO
- `fk_movimiento_insumo_0`: ("idInsumo") → INSUMO("idInsumo")
- `fk_movimiento_insumo_1`: ("idPreparacion") → PREPARACION("idPreparacion")
- `fk_movimiento_insumo_2`: ("idRecepcionCompra", "idInsumo") → RECEPCION_COMPRA("idRecepcionCompra", "idInsumoRecibido")
- `fk_movimiento_insumo_3`: ("idInsumo", "vigenteDesdeCosto") → COSTO_INSUMO_HISTORICO("idInsumo", "vigenteDesde")
- `fk_movimiento_insumo_4`: ("idUsuarioResponsable") → USUARIO("idUsuario")

### MOVIMIENTO_STOCK_REVENTA
- `fk_movimiento_stock_reventa_0`: ("idProducto") → PRODUCTO("idProducto")
- `fk_movimiento_stock_reventa_1`: ("idRecepcionCompra", "idProducto") → RECEPCION_COMPRA("idRecepcionCompra", "idProductoReventa")
- `fk_movimiento_stock_reventa_2`: ("idPedidoEntrega", "numeroDetalleEntrega") → DETALLE_ENTREGA("idPedido", "numeroDetalle")
- `fk_movimiento_stock_reventa_3`: ("idPedidoEntrega", "numeroDetalleEntrega", "idProducto") → DETALLE_PEDIDO("idPedido", "numeroDetalle", "idProducto")
- `fk_movimiento_stock_reventa_4`: ("idValoracionReventa", "idProducto") → VALORACION_EXTRAORDINARIA_REVENTA("idValoracionReventa", "idProducto")
- `fk_movimiento_stock_reventa_5`: ("idUsuarioResponsable") → USUARIO("idUsuario")

### OFERTA_EXCEDENTE
- `fk_oferta_excedente_0`: ("idExcedente") → EXCEDENTE("idExcedente")
- `fk_oferta_excedente_1`: ("idPedidoReceptor") → PEDIDO("idPedido")
- `fk_oferta_excedente_2`: ("idUsuarioVendedor") → USUARIO("idUsuario")

### ORDEN_COMPRA
- `fk_orden_compra_0`: ("idDecisionCompra") → DECISION_COMPRA("idDecisionCompra")
- `fk_orden_compra_1`: ("idUsuarioCancelacion") → USUARIO("idUsuario")

### ORIGEN_MOVIMIENTO_CUENTA
- `fk_origen_movimiento_cuenta_0`: ("idMovimientoCuenta") → MOVIMIENTO_CUENTA("idMovimientoCuenta")
- `fk_origen_movimiento_cuenta_1`: ("idPedidoEntrega") → ENTREGA("idPedido")
- `fk_origen_movimiento_cuenta_2`: ("idCobro") → COBRO("idCobro")
- `fk_origen_movimiento_cuenta_3`: ("idReembolso") → REEMBOLSO("idReembolso")
- `fk_origen_cuenta_cobro_anulado`: idCobroAnulado → COBRO(idCobro)

### PEDIDO
- `fk_pedido_0`: ("idCliente") → CLIENTE("idCliente")
- `fk_pedido_1`: ("idUsuarioCreador") → USUARIO("idUsuario")
- `fk_pedido_2`: ("idSesionOnline") → SESION_CLIENTE_ONLINE("idSesionOnline")
- `fk_pedido_3`: ("idPoliticaComercialAplicada") → POLITICA_CATEGORIA_COMERCIAL("idPoliticaComercial")

### POLITICA_CATEGORIA_COMERCIAL
- `fk_politica_categoria_comercial_0`: ("idUsuarioRegistro") → USUARIO("idUsuario")

### POLITICA_COMPRA
- `fk_politica_compra_0`: ("idUsuarioRegistro") → USUARIO("idUsuario")

### PRECIO_PRODUCTO
- `fk_precio_producto_0`: ("idProducto") → PRODUCTO("idProducto")
- `fk_precio_producto_1`: ("idUsuarioRegistro") → USUARIO("idUsuario")
- `fk_precio_producto_2`: ("idUsuarioCancelacion") → USUARIO("idUsuario")

### PREPARACION
- `fk_preparacion_0`: ("idPedido", "numeroDetalle") → DETALLE_PEDIDO("idPedido", "numeroDetalle")
- `fk_preparacion_1`: ("idReceta", "numeroVersion") → VERSION_RECETA("idReceta", "numeroVersion")

### PRODUCTO
- `fk_producto_0`: ("codigoUnidadVenta") → UNIDAD_MEDIDA("codigoUnidad")

### PROMOCION
- `fk_promocion_0`: ("idUsuarioCreador") → USUARIO("idUsuario")

### PROMOCION_PRODUCTO
- `fk_promocion_producto_0`: ("idPromocion") → PROMOCION("idPromocion")
- `fk_promocion_producto_1`: ("idProducto") → PRODUCTO("idProducto")

### PROVEEDOR_INSUMO
- `fk_proveedor_insumo_0`: ("idProveedor") → PROVEEDOR("idProveedor")
- `fk_proveedor_insumo_1`: ("idInsumo") → INSUMO("idInsumo")

### RECEPCION_COMPRA
- `fk_recepcion_compra_0`: ("idOrdenCompra") → ORDEN_COMPRA("idOrdenCompra")
- `fk_recepcion_compra_1`: ("idProveedorDirecto") → PROVEEDOR("idProveedor")
- `fk_recepcion_compra_2`: ("idInsumoRecibido") → INSUMO("idInsumo")
- `fk_recepcion_compra_3`: ("idProductoReventa") → PRODUCTO("idProducto")
- `fk_recepcion_compra_4`: ("idUsuarioResponsable") → USUARIO("idUsuario")
- `fk_recepcion_compra_5`: ("codigoUnidadMedida") → UNIDAD_MEDIDA("codigoUnidad")

### RECETA
- `fk_receta_0`: ("idProducto") → PRODUCTO("idProducto")

### REEMBOLSO
- `fk_reembolso_0`: ("idCobro") → COBRO("idCobro")
- `fk_reembolso_1`: ("idCobro", "importeReembolso") → COBRO("idCobro", "importe")

### RESPUESTA_COTIZACION
- `fk_respuesta_cotizacion_0`: ("idSolicitud", "idProveedor") → INVITACION_COTIZACION("idSolicitud", "idProveedor")
- `fk_respuesta_cotizacion_1`: ("idUsuarioRegistrador") → USUARIO("idUsuario")

### SESION_CLIENTE_ONLINE
- `fk_sesion_cliente_online_0`: ("idDesafio") → DESAFIO_AUTENTICACION_CLIENTE("idDesafio")

### SESION_USUARIO
- `fk_sesion_usuario_0`: ("idUsuario") → USUARIO("idUsuario")

### SOLICITUD_COTIZACION
- `fk_solicitud_cotizacion_0`: ("idEpisodio") → EPISODIO_FALTANTE("idEpisodio")
- `fk_solicitud_cotizacion_1`: ("idUsuarioEmisor") → USUARIO("idUsuario")
- `fk_solicitud_cotizacion_2`: ("idSolicitudAnterior", "idEpisodio") → SOLICITUD_COTIZACION("idSolicitud", "idEpisodio")

### USUARIO_PROVEEDOR
- `fk_usuario_proveedor_0`: ("idUsuario") → USUARIO("idUsuario")
- `fk_usuario_proveedor_1`: ("idProveedor") → PROVEEDOR("idProveedor")

### USUARIO_ROL
- `fk_usuario_rol_0`: ("idUsuario") → USUARIO("idUsuario")
- `fk_usuario_rol_1`: ("codigoRol") → ROL("codigoRol")

### VALORACION_EXTRAORDINARIA_REVENTA
- `fk_valoracion_extraordinaria_reventa_0`: ("idProducto") → PRODUCTO("idProducto")
- `fk_valoracion_extraordinaria_reventa_1`: ("idUsuarioResponsable") → USUARIO("idUsuario")

### VERSION_RECETA
- `fk_version_receta_0`: ("idReceta") → RECETA("idReceta")
- `fk_version_receta_1`: ("codigoUnidadRendimiento") → UNIDAD_MEDIDA("codigoUnidad")

