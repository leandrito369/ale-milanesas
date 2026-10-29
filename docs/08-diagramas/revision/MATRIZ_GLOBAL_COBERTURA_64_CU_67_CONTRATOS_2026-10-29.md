# Matriz global de cobertura contractual — 64 CU / 67 contratos

**Fecha:** 29/10/2026. **Base:** 54 operaciones de REV-01 a REV-06A más 13 contratos REV-06B. Rama de consolidación de este corte: `revision/rev06b2-recetas-inventario-2026-10-29` (apilada sobre REV-06B.1). Fuente de CU: [Fase 4, tres niveles](https://docs.google.com/document/d/1BMF2Yfsh2ki353fU2dS5eZtIsYrOntpkjjAzulNy1uY/edit).

**Leyenda:** las 54 operaciones de REV-01 a REV-06A conservan su cotejo; las 7 de REV-06B.1 quedaron homologadas contra su DSS revisado, DS revisado y contrato corregido; las 6 de REV-06B.2 se homologaron mediante el DSS y DS publicados en el sublote posterior.

| CU | Operación(es) documentada(s) | Contrato(s) | Trazabilidad de firma DSS/DS |
|---|---|---|---|
| UC-01 | `iniciarSesion` | [`CONTRATO_UC01_REV02.md`](./REV02_SEGURIDAD/propuestos/contratos/CONTRATO_UC01_REV02.md) | 54 anteriores: firma cotejada |
| UC-02 | `registrarCliente` | [`CONTRATOS_REV06B_TRECE_CORREGIDOS.md`](./REV06B_CLIENTES_RECETAS_INVENTARIO/propuestos/CONTRATOS_REV06B_TRECE_CORREGIDOS.md) | REV-06B.1: firma DSS–DS–Contrato homologada (29/10/2026) |
| UC-03 | `cargarPedido`; `reprogramarFechaRepartoPedido` | [`CONTRATOS_REV04A_CORREGIDOS.md`](./REV04_PEDIDOS_ENTREGAS/propuestos/CONTRATOS_REV04A_CORREGIDOS.md) | 54 anteriores: firma cotejada |
| UC-04 | `consultarPedidosAsignados` | [`CONTRATOS_REV04A_CORREGIDOS.md`](./REV04_PEDIDOS_ENTREGAS/propuestos/CONTRATOS_REV04A_CORREGIDOS.md) | 54 anteriores: firma cotejada |
| UC-05 | `registrarEntrega` | [`CONTRATOS_REV04B_CORREGIDOS.md`](./REV04_PEDIDOS_ENTREGAS/propuestos/CONTRATOS_REV04B_CORREGIDOS.md) | 54 anteriores: firma cotejada |
| UC-06 | `cancelarPedido` | [`CONTRATOS_REV04B_CORREGIDOS.md`](./REV04_PEDIDOS_ENTREGAS/propuestos/CONTRATOS_REV04B_CORREGIDOS.md) | 54 anteriores: firma cotejada |
| UC-07 | `registrarOfertaExcedente`; `registrarRespuestaOfertaExcedente` | [`CONTRATOS_REV04B_CORREGIDOS.md`](./REV04_PEDIDOS_ENTREGAS/propuestos/CONTRATOS_REV04B_CORREGIDOS.md) | 54 anteriores: firma cotejada |
| UC-08 | `registrarIngresoStockPorCompra` | [`CONTRATOS_REV03B_CORREGIDOS.md`](./REV03_COMPRAS/propuestos/CONTRATOS_REV03B_CORREGIDOS.md) | 54 anteriores: firma cotejada |
| UC-09 | `consultarStock` | [`CONTRATOS_REV06B_TRECE_CORREGIDOS.md`](./REV06B_CLIENTES_RECETAS_INVENTARIO/propuestos/CONTRATOS_REV06B_TRECE_CORREGIDOS.md) | REV-06B.2: firma DSS–DS–Contrato homologada (29/10/2026) |
| UC-10 | `configurarRecetaProducto` | [`CONTRATOS_REV06B_TRECE_CORREGIDOS.md`](./REV06B_CLIENTES_RECETAS_INVENTARIO/propuestos/CONTRATOS_REV06B_TRECE_CORREGIDOS.md) | REV-06B.2: firma DSS–DS–Contrato homologada (29/10/2026) |
| UC-11 | `gestionarProveedor` | [`CONTRATOS_REV03B_CORREGIDOS.md`](./REV03_COMPRAS/propuestos/CONTRATOS_REV03B_CORREGIDOS.md) | 54 anteriores: firma cotejada |
| UC-12 | `evaluarCotizacionesYResolverCompra` | [`CONTRATOS_REV03A_CORREGIDOS.md`](./REV03_COMPRAS/propuestos/CONTRATOS_REV03A_CORREGIDOS.md) | 54 anteriores: firma cotejada |
| UC-13 | `responderSolicitudCotizacion` | [`CONTRATOS_REV03A_CORREGIDOS.md`](./REV03_COMPRAS/propuestos/CONTRATOS_REV03A_CORREGIDOS.md) | 54 anteriores: firma cotejada |
| UC-14 | `consultarCuentaCorriente` | [`CONTRATOS_REV05_CORREGIDOS.md`](./REV05_FINANZAS_CONSULTAS/propuestos/CONTRATOS_REV05_CORREGIDOS.md) | 54 anteriores: firma cotejada |
| UC-15 | `evaluarYActualizarCategoriaComercial` | [`CONTRATOS_REV06B_TRECE_CORREGIDOS.md`](./REV06B_CLIENTES_RECETAS_INVENTARIO/propuestos/CONTRATOS_REV06B_TRECE_CORREGIDOS.md) | REV-06B.1: firma DSS–DS–Contrato homologada (29/10/2026) |
| UC-16 | `aplicarAjusteComercialSegunCategoria` | [`CONTRATOS_REV06B_TRECE_CORREGIDOS.md`](./REV06B_CLIENTES_RECETAS_INVENTARIO/propuestos/CONTRATOS_REV06B_TRECE_CORREGIDOS.md) | REV-06B.1: firma DSS–DS–Contrato homologada (29/10/2026) |
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
| UC-31 | `configurarParametrosReposicionInsumo` | [`CONTRATOS_REV06B_TRECE_CORREGIDOS.md`](./REV06B_CLIENTES_RECETAS_INVENTARIO/propuestos/CONTRATOS_REV06B_TRECE_CORREGIDOS.md) | REV-06B.2: firma DSS–DS–Contrato homologada (29/10/2026) |
| UC-32 | `modificarCliente` | [`CONTRATOS_REV06B_TRECE_CORREGIDOS.md`](./REV06B_CLIENTES_RECETAS_INVENTARIO/propuestos/CONTRATOS_REV06B_TRECE_CORREGIDOS.md) | REV-06B.1: firma DSS–DS–Contrato homologada (29/10/2026) |
| UC-33 | `buscarCliente` | [`CONTRATOS_REV06B_TRECE_CORREGIDOS.md`](./REV06B_CLIENTES_RECETAS_INVENTARIO/propuestos/CONTRATOS_REV06B_TRECE_CORREGIDOS.md) | REV-06B.1: firma DSS–DS–Contrato homologada (29/10/2026) |
| UC-34 | `buscarPedido` | [`CONTRATOS_REV04A_CORREGIDOS.md`](./REV04_PEDIDOS_ENTREGAS/propuestos/CONTRATOS_REV04A_CORREGIDOS.md) | 54 anteriores: firma cotejada |
| UC-35 | `buscarProducto` | [`CONTRATOS_REV06A_NUEVE_OPERACIONES.md`](./REV06A_COMERCIAL_PROMOCIONES/propuestos/CONTRATOS_REV06A_NUEVE_OPERACIONES.md) | 54 anteriores: firma cotejada |
| UC-36 | `buscarInsumo` | [`CONTRATOS_REV06B_TRECE_CORREGIDOS.md`](./REV06B_CLIENTES_RECETAS_INVENTARIO/propuestos/CONTRATOS_REV06B_TRECE_CORREGIDOS.md) | REV-06B.2: firma DSS–DS–Contrato homologada (29/10/2026) |
| UC-37 | `buscarProveedor` | [`CONTRATOS_REV03B_CORREGIDOS.md`](./REV03_COMPRAS/propuestos/CONTRATOS_REV03B_CORREGIDOS.md) | 54 anteriores: firma cotejada |
| UC-38 | `cambiarEstadoCliente` | [`CONTRATOS_REV06B_TRECE_CORREGIDOS.md`](./REV06B_CLIENTES_RECETAS_INVENTARIO/propuestos/CONTRATOS_REV06B_TRECE_CORREGIDOS.md) | REV-06B.1: firma DSS–DS–Contrato homologada (29/10/2026) |
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
| UC-52 | `cambiarEstadoInsumo` | [`CONTRATOS_REV06B_TRECE_CORREGIDOS.md`](./REV06B_CLIENTES_RECETAS_INVENTARIO/propuestos/CONTRATOS_REV06B_TRECE_CORREGIDOS.md) | REV-06B.2: firma DSS–DS–Contrato homologada (29/10/2026) |
| UC-53 | `cambiarContrasena` | [`CONTRATO_UC53_REV02.md`](./REV02_SEGURIDAD/propuestos/contratos/CONTRATO_UC53_REV02.md) | 54 anteriores: firma cotejada |
| UC-54 | `restablecerAccesoUsuario` | [`CONTRATO_UC54_REV02.md`](./REV02_SEGURIDAD/propuestos/contratos/CONTRATO_UC54_REV02.md) | 54 anteriores: firma cotejada |
| UC-55 | `cambiarEstadoUsuario` | [`CONTRATO_UC55_REV02.md`](./REV02_SEGURIDAD/propuestos/contratos/CONTRATO_UC55_REV02.md) | 54 anteriores: firma cotejada |
| UC-56 | `buscarUsuario` | [`CONTRATO_UC56_REV02.md`](./REV02_SEGURIDAD/propuestos/contratos/CONTRATO_UC56_REV02.md) | 54 anteriores: firma cotejada |
| UC-57 | `configurarPoliticaCategoriaComercial` | [`CONTRATOS_REV06B_TRECE_CORREGIDOS.md`](./REV06B_CLIENTES_RECETAS_INVENTARIO/propuestos/CONTRATOS_REV06B_TRECE_CORREGIDOS.md) | REV-06B.1: firma DSS–DS–Contrato homologada (29/10/2026) |
| UC-58 | `configurarPoliticaCompra` | [`CONTRATOS_REV03A_CORREGIDOS.md`](./REV03_COMPRAS/propuestos/CONTRATOS_REV03A_CORREGIDOS.md) | 54 anteriores: firma cotejada |
| UC-59 | `consultarPromociones` | [`CONTRATOS_REV06A_NUEVE_OPERACIONES.md`](./REV06A_COMERCIAL_PROMOCIONES/propuestos/CONTRATOS_REV06A_NUEVE_OPERACIONES.md) | 54 anteriores: firma cotejada |
| UC-60 | `desactivarPromocion` | [`CONTRATOS_REV06A_NUEVE_OPERACIONES.md`](./REV06A_COMERCIAL_PROMOCIONES/propuestos/CONTRATOS_REV06A_NUEVE_OPERACIONES.md) | 54 anteriores: firma cotejada |
| UC-61 | `buscarExcedente` | [`CONTRATOS_REV04B_CORREGIDOS.md`](./REV04_PEDIDOS_ENTREGAS/propuestos/CONTRATOS_REV04B_CORREGIDOS.md) | 54 anteriores: firma cotejada |
| UC-62 | `buscarSolicitudCotizacion` | [`CONTRATOS_REV03A_CORREGIDOS.md`](./REV03_COMPRAS/propuestos/CONTRATOS_REV03A_CORREGIDOS.md) | 54 anteriores: firma cotejada |
| UC-63 | `consultarSolicitudesCotizacionRecibidas` | [`CONTRATOS_REV03A_CORREGIDOS.md`](./REV03_COMPRAS/propuestos/CONTRATOS_REV03A_CORREGIDOS.md) | 54 anteriores: firma cotejada |
| UC-64 | `consultarMovimientosInventario` | [`CONTRATOS_REV06B_TRECE_CORREGIDOS.md`](./REV06B_CLIENTES_RECETAS_INVENTARIO/propuestos/CONTRATOS_REV06B_TRECE_CORREGIDOS.md) | REV-06B.2: firma DSS–DS–Contrato homologada (29/10/2026) |

**Resultados:** 64 CU con al menos un contrato; 67 operaciones; duplicidad esperada de UC-03/UC-07/UC-29. La cobertura contractual se cierra **documentalmente**. Las **13/13 firmas** de REV-06B están homologadas en dos sublotes (7 en REV-06B.1 y 6 en REV-06B.2). Resultado global: **67/67 operaciones DSS–DS–Contrato** cotejadas estáticamente para los 64 CU; continúa pendiente la inspección visual y la aprobación de integración del material nuevo. no se modifica el diagrama de CU ni los diagramas de secuencia cerrados.


## Adenda REV-06B.1 — 29/10/2026

Siete contratos (`UC-02`, `UC-33`, `UC-32`, `UC-38`, `UC-57`, `UC-15`, `UC-16`) cuentan con DSS y DS **revisados** y firmas alineadas con los contratos corregidos de REV-06B.1. Ver [acta M-0 a M-7](./REV06B1_CLIENTES_CATEGORIA/REV06B1_AUDITORIA_TRANSVERSAL_Y_HOMOLOGACION_2026-10-29.md). Los únicos CU de este sublote modificados en la firma respecto de la propuesta original fueron UC-02 (eliminar `observacion`, `zona` opcional) y UC-57 (dos `AjusteCategoriaDTO`, sin columnas inexistentes). El resto de las 54 firmas previamente cotejadas y de los contratos permaneció intacto. Estado global **61/67**. Pendientes exclusivamente de homologación triple: `UC-36, UC-10, UC-31, UC-52, UC-09, UC-64` (REV-06B.2), incluido el tratamiento de H01/H02 de UC-42 en su DS, sin inventar firmas.


## Adenda REV-06B.2 — 29/10/2026

**Resultado global: 67/67 firmas públicas cotejadas DSS ↔ DS ↔ Contrato**, incluidos los seis contratos de UC-36/10/31/52/09/64. Ver [auditoría M-0 a M-7 REV-06B.2](./REV06B2_RECETAS_INVENTARIO/REV06B2_AUDITORIA_TRANSVERSAL_RECETAS_INVENTARIO_2026-10-29.md), [DSS](./REV06B2_RECETAS_INVENTARIO/propuestos/DSS_REV06B2_RECETAS_INVENTARIO_UC09_10_31_36_52_64.drawio.xml) y [DS (siete pestañas)](./REV06B2_RECETAS_INVENTARIO/propuestos/DS_REV06B2_RECETAS_INVENTARIO_UC09_10_31_36_52_64.drawio.xml). **UC-42** figura por la corrección estructural de H01/H02 en la séptima pestaña del DS, **sin sumar otra operación**: ya estaba entre las 54 previas. Los controles de H01/H02 se superaron estáticamente pero requieren validación visual. No se han ejecutado SQL, API ni flujos transaccionales. Ningún diagrama anterior, DDL ni `main` fue sobrescrito; se conserva la necesidad de aceptación final e integración controlada.
