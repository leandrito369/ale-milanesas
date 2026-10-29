# Matriz global de cobertura contractual — 64 CU / 67 contratos

**Fecha:** 29/10/2026. **Base:** 54 operaciones de REV-01 a REV-06A más 13 contratos REV-06B. Todas las rutas se han verificado en la rama `revision/rev06b-contratos-restantes-2026-10-29`. Fuente de CU: [Fase 4, tres niveles](https://docs.google.com/document/d/1BMF2Yfsh2ki353fU2dS5eZtIsYrOntpkjjAzulNy1uY/edit).

**Leyenda:** `Firma DSS/DS corroborada` significa el cotejo previo de las 54 operaciones de REV-01 a REV-06A. `Sin DSS/DS REV-06B` no es un error gráfico; declara que esas 13 firmas contractuales aún no pudieron homologarse con mensajes UML propios.

| CU | Operación(es) documentada(s) | Contrato(s) | Trazabilidad de firma DSS/DS |
|---|---|---|---|
| UC-01 | `iniciarSesion` | [`CONTRATO_UC01_REV02.md`](./REV02_SEGURIDAD/propuestos/contratos/CONTRATO_UC01_REV02.md) | 54 anteriores: firma cotejada |
| UC-02 | `registrarCliente` | [`CONTRATOS_REV06B_TRECE_CORREGIDOS.md`](./REV06B_CLIENTES_RECETAS_INVENTARIO/propuestos/CONTRATOS_REV06B_TRECE_CORREGIDOS.md) | 13 nuevas: sin DSS/DS propios |
| UC-03 | `cargarPedido`; `reprogramarFechaRepartoPedido` | [`CONTRATOS_REV04A_CORREGIDOS.md`](./REV04_PEDIDOS_ENTREGAS/propuestos/CONTRATOS_REV04A_CORREGIDOS.md) | 54 anteriores: firma cotejada |
| UC-04 | `consultarPedidosAsignados` | [`CONTRATOS_REV04A_CORREGIDOS.md`](./REV04_PEDIDOS_ENTREGAS/propuestos/CONTRATOS_REV04A_CORREGIDOS.md) | 54 anteriores: firma cotejada |
| UC-05 | `registrarEntrega` | [`CONTRATOS_REV04B_CORREGIDOS.md`](./REV04_PEDIDOS_ENTREGAS/propuestos/CONTRATOS_REV04B_CORREGIDOS.md) | 54 anteriores: firma cotejada |
| UC-06 | `cancelarPedido` | [`CONTRATOS_REV04B_CORREGIDOS.md`](./REV04_PEDIDOS_ENTREGAS/propuestos/CONTRATOS_REV04B_CORREGIDOS.md) | 54 anteriores: firma cotejada |
| UC-07 | `registrarOfertaExcedente`; `registrarRespuestaOfertaExcedente` | [`CONTRATOS_REV04B_CORREGIDOS.md`](./REV04_PEDIDOS_ENTREGAS/propuestos/CONTRATOS_REV04B_CORREGIDOS.md) | 54 anteriores: firma cotejada |
| UC-08 | `registrarIngresoStockPorCompra` | [`CONTRATOS_REV03B_CORREGIDOS.md`](./REV03_COMPRAS/propuestos/CONTRATOS_REV03B_CORREGIDOS.md) | 54 anteriores: firma cotejada |
| UC-09 | `consultarStock` | [`CONTRATOS_REV06B_TRECE_CORREGIDOS.md`](./REV06B_CLIENTES_RECETAS_INVENTARIO/propuestos/CONTRATOS_REV06B_TRECE_CORREGIDOS.md) | 13 nuevas: sin DSS/DS propios |
| UC-10 | `configurarRecetaProducto` | [`CONTRATOS_REV06B_TRECE_CORREGIDOS.md`](./REV06B_CLIENTES_RECETAS_INVENTARIO/propuestos/CONTRATOS_REV06B_TRECE_CORREGIDOS.md) | 13 nuevas: sin DSS/DS propios |
| UC-11 | `gestionarProveedor` | [`CONTRATOS_REV03B_CORREGIDOS.md`](./REV03_COMPRAS/propuestos/CONTRATOS_REV03B_CORREGIDOS.md) | 54 anteriores: firma cotejada |
| UC-12 | `evaluarCotizacionesYResolverCompra` | [`CONTRATOS_REV03A_CORREGIDOS.md`](./REV03_COMPRAS/propuestos/CONTRATOS_REV03A_CORREGIDOS.md) | 54 anteriores: firma cotejada |
| UC-13 | `responderSolicitudCotizacion` | [`CONTRATOS_REV03A_CORREGIDOS.md`](./REV03_COMPRAS/propuestos/CONTRATOS_REV03A_CORREGIDOS.md) | 54 anteriores: firma cotejada |
| UC-14 | `consultarCuentaCorriente` | [`CONTRATOS_REV05_CORREGIDOS.md`](./REV05_FINANZAS_CONSULTAS/propuestos/CONTRATOS_REV05_CORREGIDOS.md) | 54 anteriores: firma cotejada |
| UC-15 | `evaluarYActualizarCategoriaComercial` | [`CONTRATOS_REV06B_TRECE_CORREGIDOS.md`](./REV06B_CLIENTES_RECETAS_INVENTARIO/propuestos/CONTRATOS_REV06B_TRECE_CORREGIDOS.md) | 13 nuevas: sin DSS/DS propios |
| UC-16 | `aplicarAjusteComercialSegunCategoria` | [`CONTRATOS_REV06B_TRECE_CORREGIDOS.md`](./REV06B_CLIENTES_RECETAS_INVENTARIO/propuestos/CONTRATOS_REV06B_TRECE_CORREGIDOS.md) | 13 nuevas: sin DSS/DS propios |
| UC-17 | `crearUsuario` | [`CONTRATO_UC17_REV02.md`](./REV02_SEGURIDAD/propuestos/contratos/CONTRATO_UC17_REV02.md) | 54 anteriores: firma cotejada |
| UC-18 | `gestionarAsignacionesRoles` | [`CONTRATO_UC18_REV02.md`](./REV02_SEGURIDAD/propuestos/contratos/CONTRATO_UC18_REV02.md) | 54 anteriores: firma cotejada |
| UC-19 | `actualizarPrecioVigente` | [`CONTRATOS_REV06A_NUEVE_OPERACIONES.md`](./REV06A_COMERCIAL_PROMOCIONES/propuestos/CONTRATOS_REV06A_NUEVE_OPERACIONES.md) | 54 anteriores: firma cotejada |
| UC-20 | `consultarHistorialPrecios` | [`CONTRATOS_REV06A_NUEVE_OPERACIONES.md`](./REV06A_COMERCIAL_PROMOCIONES/propuestos/CONTRATOS_REV06A_NUEVE_OPERACIONES.md) | 54 anteriores: firma cotejada |
| UC-21 | `realizarPedidoOnline` | [`CONTRATOS_REV04A_CORREGIDOS.md`](./REV04_PEDIDOS_ENTREGAS/propuestos/CONTRATOS_REV04A_CORREGIDOS.md) | 54 anteriores: firma cotejada |
| UC-22 | `registrarMovimientoCaja` | [`CONTRATOS_REV05_CORREGIDOS.md`](./REV05_FINANZAS_CONSULTAS/propuestos/CONTRATOS_REV05_CORREGIDOS.md) | 54 anteriores: firma cotejada |
| UC-23 | `consultarLibroDiario` | [`CONTRATOS_REV05_CORREGIDOS.md`](./REV05_FINANZAS_CONSULTAS/propuestos/CONTRATOS_REV05_CORREGIDOS.md) | 54 anteriores: firma cotejada |
| UC-24 | `crearYComunicarPromocion` | [`CONTRATOS_REV06A_NUEVE_OPERACIONES.md`](./REV06A_COMERCIAL_PROMOCIONES/propuestos/CONTRATOS_REV06A_NUEVE_OPERACIONES.md) | 54 anteriores: firma cotejada |
| UC-25 | `generarRutaSugeridaReparto` | [`CONTRATOS_REV04A_CORREGIDOS.md`](./REV04_PEDIDOS_ENTREGAS/propuestos/CONTRATOS_REV04A_CORREGIDOS.md) | 54 anteriores: firma cotejada |
| UC-26 | `procesarReembolsoElectronico` | [`CONTRATOS_REV05_CORREGIDOS.md`](./REV05_FINANZAS_CONSULTAS/propuestos/CONTRATOS_REV05_CORREGIDOS.md) | 54 anteriores: firma cotejada |
| UC-27 | `consultarMargenBruto` | [`CONTRATOS_REV05_CORREGIDOS.md`](./REV05_FINANZAS_CONSULTAS/propuestos/CONTRATOS_REV05_CORREGIDOS.md) | 54 anteriores: firma cotejada |
| UC-28 | `registrarPreparacionPedido` | [`CONTRATOS_REV04B_CORREGIDOS.md`](./REV04_PEDIDOS_ENTREGAS/propuestos/CONTRATOS_REV04B_CORREGIDOS.md) | 54 anteriores: firma cotejada |
| UC-29 | `registrarCobro`; `anularCobroManual` | [`CONTRATOS_REV05_CORREGIDOS.md`](./REV05_FINANZAS_CONSULTAS/propuestos/CONTRATOS_REV05_CORREGIDOS.md) | 54 anteriores: firma cotejada |
| UC-30 | `gestionarProducto` | [`CONTRATOS_REV06A_NUEVE_OPERACIONES.md`](./REV06A_COMERCIAL_PROMOCIONES/propuestos/CONTRATOS_REV06A_NUEVE_OPERACIONES.md) | 54 anteriores: firma cotejada |
| UC-31 | `configurarParametrosReposicionInsumo` | [`CONTRATOS_REV06B_TRECE_CORREGIDOS.md`](./REV06B_CLIENTES_RECETAS_INVENTARIO/propuestos/CONTRATOS_REV06B_TRECE_CORREGIDOS.md) | 13 nuevas: sin DSS/DS propios |
| UC-32 | `modificarCliente` | [`CONTRATOS_REV06B_TRECE_CORREGIDOS.md`](./REV06B_CLIENTES_RECETAS_INVENTARIO/propuestos/CONTRATOS_REV06B_TRECE_CORREGIDOS.md) | 13 nuevas: sin DSS/DS propios |
| UC-33 | `buscarCliente` | [`CONTRATOS_REV06B_TRECE_CORREGIDOS.md`](./REV06B_CLIENTES_RECETAS_INVENTARIO/propuestos/CONTRATOS_REV06B_TRECE_CORREGIDOS.md) | 13 nuevas: sin DSS/DS propios |
| UC-34 | `buscarPedido` | [`CONTRATOS_REV04A_CORREGIDOS.md`](./REV04_PEDIDOS_ENTREGAS/propuestos/CONTRATOS_REV04A_CORREGIDOS.md) | 54 anteriores: firma cotejada |
| UC-35 | `buscarProducto` | [`CONTRATOS_REV06A_NUEVE_OPERACIONES.md`](./REV06A_COMERCIAL_PROMOCIONES/propuestos/CONTRATOS_REV06A_NUEVE_OPERACIONES.md) | 54 anteriores: firma cotejada |
| UC-36 | `buscarInsumo` | [`CONTRATOS_REV06B_TRECE_CORREGIDOS.md`](./REV06B_CLIENTES_RECETAS_INVENTARIO/propuestos/CONTRATOS_REV06B_TRECE_CORREGIDOS.md) | 13 nuevas: sin DSS/DS propios |
| UC-37 | `buscarProveedor` | [`CONTRATOS_REV03B_CORREGIDOS.md`](./REV03_COMPRAS/propuestos/CONTRATOS_REV03B_CORREGIDOS.md) | 54 anteriores: firma cotejada |
| UC-38 | `cambiarEstadoCliente` | [`CONTRATOS_REV06B_TRECE_CORREGIDOS.md`](./REV06B_CLIENTES_RECETAS_INVENTARIO/propuestos/CONTRATOS_REV06B_TRECE_CORREGIDOS.md) | 13 nuevas: sin DSS/DS propios |
| UC-39 | `cancelarOrdenCompra` | [`CONTRATOS_REV03B_CORREGIDOS.md`](./REV03_COMPRAS/propuestos/CONTRATOS_REV03B_CORREGIDOS.md) | 54 anteriores: firma cotejada |
| UC-40 | `buscarOrdenCompra` | [`CONTRATOS_REV03B_CORREGIDOS.md`](./REV03_COMPRAS/propuestos/CONTRATOS_REV03B_CORREGIDOS.md) | 54 anteriores: firma cotejada |
| UC-41 | `registrarDescarteExcedente` | [`CONTRATOS_REV04B_CORREGIDOS.md`](./REV04_PEDIDOS_ENTREGAS/propuestos/CONTRATOS_REV04B_CORREGIDOS.md) | 54 anteriores: firma cotejada |
| UC-42 | `registrarAjusteInventario` | [`CONTRATO_UC42_REV01.md`](./REV01_UC42/propuestos/CONTRATO_UC42_REV01.md) | 54 anteriores: firma cotejada |
| UC-43 | `asignarOReasignarPedidoARepartidor` | [`CONTRATOS_REV04A_CORREGIDOS.md`](./REV04_PEDIDOS_ENTREGAS/propuestos/CONTRATOS_REV04A_CORREGIDOS.md) | 54 anteriores: firma cotejada |
| UC-44 | `iniciarRondaManualCotizacion` | [`CONTRATOS_REV03A_CORREGIDOS.md`](./REV03_COMPRAS/propuestos/CONTRATOS_REV03A_CORREGIDOS.md) | 54 anteriores: firma cotejada |
| UC-45 | `modificarProveedor` | [`CONTRATOS_REV03B_CORREGIDOS.md`](./REV03_COMPRAS/propuestos/CONTRATOS_REV03B_CORREGIDOS.md) | 54 anteriores: firma cotejada |
| UC-46 | `cambiarEstadoProveedor` | [`CONTRATOS_REV03B_CORREGIDOS.md`](./REV03_COMPRAS/propuestos/CONTRATOS_REV03B_CORREGIDOS.md) | 54 anteriores: firma cotejada |
| UC-47 | `modificarProducto` | [`CONTRATOS_REV06A_NUEVE_OPERACIONES.md`](./REV06A_COMERCIAL_PROMOCIONES/propuestos/CONTRATOS_REV06A_NUEVE_OPERACIONES.md) | 54 anteriores: firma cotejada |
| UC-48 | `cambiarEstadoProducto` | [`CONTRATOS_REV06A_NUEVE_OPERACIONES.md`](./REV06A_COMERCIAL_PROMOCIONES/propuestos/CONTRATOS_REV06A_NUEVE_OPERACIONES.md) | 54 anteriores: firma cotejada |
| UC-49 | `registrarResultadoReembolsoElectronico` | [`CONTRATOS_REV05_CORREGIDOS.md`](./REV05_FINANZAS_CONSULTAS/propuestos/CONTRATOS_REV05_CORREGIDOS.md) | 54 anteriores: firma cotejada |
| UC-50 | `Contrato` | [`CONTRATO_UC50_REV01.md`](./REV01_UC50/propuestos/CONTRATO_UC50_REV01.md) | 54 anteriores: firma cotejada |
| UC-51 | `buscarYModificarInsumo` | [`CONTRATO_UC51_REV01.md`](./REV01_UC51/propuestos/CONTRATO_UC51_REV01.md) | 54 anteriores: firma cotejada |
| UC-52 | `cambiarEstadoInsumo` | [`CONTRATOS_REV06B_TRECE_CORREGIDOS.md`](./REV06B_CLIENTES_RECETAS_INVENTARIO/propuestos/CONTRATOS_REV06B_TRECE_CORREGIDOS.md) | 13 nuevas: sin DSS/DS propios |
| UC-53 | `cambiarContrasena` | [`CONTRATO_UC53_REV02.md`](./REV02_SEGURIDAD/propuestos/contratos/CONTRATO_UC53_REV02.md) | 54 anteriores: firma cotejada |
| UC-54 | `restablecerAccesoUsuario` | [`CONTRATO_UC54_REV02.md`](./REV02_SEGURIDAD/propuestos/contratos/CONTRATO_UC54_REV02.md) | 54 anteriores: firma cotejada |
| UC-55 | `cambiarEstadoUsuario` | [`CONTRATO_UC55_REV02.md`](./REV02_SEGURIDAD/propuestos/contratos/CONTRATO_UC55_REV02.md) | 54 anteriores: firma cotejada |
| UC-56 | `buscarUsuario` | [`CONTRATO_UC56_REV02.md`](./REV02_SEGURIDAD/propuestos/contratos/CONTRATO_UC56_REV02.md) | 54 anteriores: firma cotejada |
| UC-57 | `configurarPoliticaCategoriaComercial` | [`CONTRATOS_REV06B_TRECE_CORREGIDOS.md`](./REV06B_CLIENTES_RECETAS_INVENTARIO/propuestos/CONTRATOS_REV06B_TRECE_CORREGIDOS.md) | 13 nuevas: sin DSS/DS propios |
| UC-58 | `configurarPoliticaCompra` | [`CONTRATOS_REV03A_CORREGIDOS.md`](./REV03_COMPRAS/propuestos/CONTRATOS_REV03A_CORREGIDOS.md) | 54 anteriores: firma cotejada |
| UC-59 | `consultarPromociones` | [`CONTRATOS_REV06A_NUEVE_OPERACIONES.md`](./REV06A_COMERCIAL_PROMOCIONES/propuestos/CONTRATOS_REV06A_NUEVE_OPERACIONES.md) | 54 anteriores: firma cotejada |
| UC-60 | `desactivarPromocion` | [`CONTRATOS_REV06A_NUEVE_OPERACIONES.md`](./REV06A_COMERCIAL_PROMOCIONES/propuestos/CONTRATOS_REV06A_NUEVE_OPERACIONES.md) | 54 anteriores: firma cotejada |
| UC-61 | `buscarExcedente` | [`CONTRATOS_REV04B_CORREGIDOS.md`](./REV04_PEDIDOS_ENTREGAS/propuestos/CONTRATOS_REV04B_CORREGIDOS.md) | 54 anteriores: firma cotejada |
| UC-62 | `buscarSolicitudCotizacion` | [`CONTRATOS_REV03A_CORREGIDOS.md`](./REV03_COMPRAS/propuestos/CONTRATOS_REV03A_CORREGIDOS.md) | 54 anteriores: firma cotejada |
| UC-63 | `consultarSolicitudesCotizacionRecibidas` | [`CONTRATOS_REV03A_CORREGIDOS.md`](./REV03_COMPRAS/propuestos/CONTRATOS_REV03A_CORREGIDOS.md) | 54 anteriores: firma cotejada |
| UC-64 | `consultarMovimientosInventario` | [`CONTRATOS_REV06B_TRECE_CORREGIDOS.md`](./REV06B_CLIENTES_RECETAS_INVENTARIO/propuestos/CONTRATOS_REV06B_TRECE_CORREGIDOS.md) | 13 nuevas: sin DSS/DS propios |

**Resultados:** 64 CU con al menos un contrato; 67 operaciones; duplicidad esperada de UC-03/UC-07/UC-29. La cobertura contractual se cierra **documentalmente**. Las 13 firmas nuevas siguen siendo propuestas sin homologación DSS/DS; no se modifica el diagrama de CU ni los diagramas de secuencia cerrados.
