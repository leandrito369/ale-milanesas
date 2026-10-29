# REV-06B.1 — Auditoría transversal y homologación DSS ↔ DS ↔ Contrato

**Fecha:** 29/10/2026 (Argentina) · **Proyecto:** Sistema de Gestión para Ale Milanesas.  
**Sublote:** Clientes y Categoría Comercial (`UC-02, UC-33, UC-32, UC-38, UC-57, UC-15, UC-16`).  
**Estado:** **CONFORME en revisión documental y estática de las 7 firmas corregidas**; pendiente aprobación explícita para integrar/fusionar ramas, e inspección visual final del nuevo material en diagrams.net por parte del responsable. No es prueba de implementación.  
**Base:** REV-06B, PR #17, sobre auditoría PR #16 y decisiones funcionales ratificadas.

## M-0. Autoridad y material contrastado

1. [Paquete original recibido](./originales/PAQUETE_REV06B1_RECIBIDO_2026-10-29.md): acta provisional M-0..M-7, DSS de dos páginas y DS de siete páginas. Se conserva íntegro como evidencia, **sin aceptar sus autodeclaraciones**.
2. [Contratos vigentes corregidos de REV-06B](../REV06B_CLIENTES_RECETAS_INVENTARIO/propuestos/CONTRATOS_REV06B_TRECE_CORREGIDOS.md): los contratos 1 a 7 son referencia para nombre, orden, tipo y opcionalidad de cada operación pública.
3. [Fase 4: 64 CU, tres niveles](https://docs.google.com/document/d/1BMF2Yfsh2ki353fU2dS5eZtIsYrOntpkjjAzulNy1uY/edit): actor principal, flujo normal y alternativas, en particular UC-02, UC-32, UC-38 y UC-57.
4. [Diccionario MR-5/MR-6, 60 tablas](../../../05-modelo-relacional/Diccionario_Explicativo_60_Tablas_MR5_MR6_26-10-2026.md): `CLIENTE`, `HISTORIAL_ESTADO_CLIENTE`, `DESAFIO_AUTENTICACION_CLIENTE`, `SESION_CLIENTE_ONLINE`, `POLITICA_CATEGORIA_COMERCIAL`, `AJUSTE_POLITICA_CATEGORIA` y `PEDIDO`.
5. [RD-RP007-002](../../../01-gobierno/RD_RP007_002_PERMISOS_BUSQUEDAS_2026-10-27.md) y RD-RP023-001: búsqueda UC-33 Admin/Vendedor (directa/contextual), aplicación de promoción única elegible y restricciones de diseño.

**Precedencia:** una firma que coincide entre dos diagramas pero contradice contrato/Fase 4/MR-5 **no se homologa**; debe corregirse en ambos diagramas. No se agrega columna, tabla, estado ni `«include»` por inferencia.

## M-1. Discrepancias encontradas en la entrega original

| ID | Severidad | Evidencia y causa | Corrección en los artefactos |
|---|---|---|---|
| **B1-01** | Alta | UC-02 usaba `zona: String` obligatoria y `observacion: String[0..1]`, que no pertenece a la firma corregida ni es columna de CLIENTE | `zona: String[0..1]`; se elimina `observacion` de DSS, DS y creación de entidad. La normalización del nombre/teléfono se trata como cálculo transitorio |
| **B1-02** | Alta | UC-57 exponía `porcentajeDescuentoCumplidor` y `porcentajeRecargoMora` como si fueran columnas de POLITICA, cuando los porcentajes pertenecen a la tabla hija | Nueva firma con `ajusteCumplidor: AjusteCategoriaDTO` y `ajusteEnMora: AjusteCategoriaDTO`; DS separa los dos objetos `AjustePoliticaCategoria` de `PoliticaCategoriaComercial`, con alta transaccional conjunta |
| **B1-03** | Alta | DSS de UC-32 indicaba “Vendedor/Administrador”, aunque la ficha extendida define Vendedor autorizado (UC-33 no confiere facultad de editar) | Se acota el DSS a Vendedor. DS mantiene su actor Vendedor y muestra repositorio separado de desafíos OTP; cambiar teléfono invalida desafíos pendientes sin revocar sesiones ONLINE activas |
| **B1-04** | Alta | DS de UC-38 actualizaba `Cliente.estado` sin mensaje explícito para crear `HISTORIAL_ESTADO_CLIENTE` | Se incorpora repositorio histórico y registro con `idCliente`, `numeroCambio`, `estadoAnterior`, `estadoNuevo`, `fechaHoraCambio`, `motivo` e `idUsuarioAdministrador`; todo dentro de la misma transacción; los Pedidos PENDIENTE no se cancelan |
| **B1-05** | Media | DSS/acta presentaban UC-15 como incluido por UC-05/26/29/49, sin respaldo de relación UML aprobada en el contraste anterior | Se deja explícito únicamente `UC-16 «include» UC-15`; otros hechos pueden motivar reevaluación de categoría **sin añadir aristas UML** |
| **B1-06** | Media | DS UC-16 daba cálculo de negocio al repositorio y utilizaba `polVigente.idPolitica` en vez de `idPoliticaComercial` | Repositorio recupera `AJUSTE_POLITICA_CATEGORIA`; la responsabilidad de calcular/congelar total se asigna al objeto Pedido, respetando datos históricos |
| **B1-07** | Bloqueante técnico | DSS recibido contenía el literal `<` sin escapar dentro del atributo XML de `uc57_g1`: el archivo no podía parsearse como XML válido | Se normalizó el XML de ese guard y los caracteres especiales de atributos sin alterar las 2 páginas ni los 7 marcos `sd` |

## M-2. DSS de sistema (caja negra)

[**DSS corregido — 2 páginas y 7 marcos de caso de uso**](./propuestos/DSS_REV06B1_CLIENTES_CATEGORIA_UC02_15_16_32_33_38_57_CORREGIDO.drawio.xml).

Los mensajes públicos van del actor/proceso invocante a `:Sistema`; no se exponen métodos del repositorio, controladores ni nombres físicos en los mensajes de frontera. Los siete `sd` siguen independientes, agrupados en la página 1 (UC-02, 33, 32, 38) y página 2 (UC-57, 15, 16). Los términos de negocio presentes como notas no introducen una nueva API.

## M-3. Homologación triple nominal (7/7)

| CU | Firma pública idéntica en DSS, DS (mensaje `1:`) y contrato |
|---|---|
| UC-02 | `registrarCliente(nombre: String, telefonoPrincipal: String, direccion: DireccionDTO, zona: String[0..1], diaHabitualReparto: Short[0..1])` |
| UC-33 | `buscarCliente(idCliente: Long[0..1], nombre: String[0..1], telefonoPrincipal: String[0..1], zona: String[0..1], estado: String[0..1])` |
| UC-32 | `modificarCliente(idCliente: Long, nuevosDatos: DatosClienteDTO)` |
| UC-38 | `cambiarEstadoCliente(idCliente: Long, nuevoEstado: String, motivo: String[0..1])` |
| UC-57 | `configurarPoliticaCategoriaComercial(diasToleranciaMora: Integer, vigenteDesde: Timestamp, vigenteHasta: Timestamp[0..1], ajusteCumplidor: AjusteCategoriaDTO, ajusteEnMora: AjusteCategoriaDTO)` |
| UC-15 | `evaluarYActualizarCategoriaComercial(idCliente: Long)` |
| UC-16 | `aplicarAjusteComercialSegunCategoria(idCliente: Long, subtotalBaseLuegoPromocion: BigDecimal)` |

**Control aplicado:** extraer el contrato `1. Nombre` y comparar contra cada `1:` del DSS y DS, omitiendo únicamente el nombre local de retorno (`ok =`, `idCliente =`, etc.) y espacios; se conservaron los tipos, orden, nombres y multiplicidades. Resultado **7/7**.

## M-4. Integridad estática de los XML

| Chequeo | DSS | DS |
|---|---:|---:|
| Páginas Draw.io (`diagram`) | **2** | **7** |
| Celdas por página | 51 + 38 = **89** | 25 + 20 + 29 + 32 + 31 + 31 + 26 = **194** |
| IDs de `mxCell` duplicados dentro de una página | **0** | **0** |
| Referencias `source`/`target` a ID inexistente | **0** | **0** |
| Mensajes de operación pública coincidentes con el contrato | **7/7** | **7/7** |
| Escapes literales `<` inválidos en valores de atributo | **0** | **0** |

En DS, siete aristas `*_div` son separadores visuales entre ramas (trazados por puntos geométricos), **no mensajes de secuencia**: no requieren `source`/`target` como sí los mensajes enlazados. No se observaron pérdidas de identificadores ni cortes de archivo. Las páginas editadas UC-32, UC-38 y UC-57 aumentaron su ancho para incorporar participantes sin reutilizar ID.

**Límite:** el control estático de estructura y referencias no sustituye la inspección de distribución gráfica en diagrams.net por el responsable.

## M-5. DS de diseño y efectos históricos

[**DS corregido — 7 páginas**](./propuestos/DS_REV06B1_CLIENTES_CATEGORIA_UC02_15_16_32_33_38_57_CORREGIDO.drawio.xml).

- **UC-02:** crear `Cliente` con atributos existentes; `nombreNormalizado` es cálculo para deduplicación y no se registra como columna.
- **UC-32:** `RepositorioDesafioAutenticacion` recibe la invalidación del desafío pendiente por cambio de teléfono; no se revocan sesiones ONLINE ya activas.
- **UC-38:** `RepositorioSesionesYDesafios` gestiona revocación ante INACTIVO; `RepositorioHistorialEstadoCliente` conserva una fila por cambio real, atómicamente con el estado.
- **UC-57:** `PoliticaCategoriaComercial` y dos objetos `AjustePoliticaCategoria` (uno por categoría) son instancias distintas; no se agregan columnas `porcentajeDescuentoCumplidor` ni `porcentajeRecargoMora`.
- **UC-15:** la deuda confirmada sigue imputación FIFO; igualdad con `diasToleranciaMora` no es mora.
- **UC-16:** se recupera el ajuste de categoría y se calcula sobre subtotal base para INTERNO o subtotal pospromoción válida para ONLINE; se congelan referencias y total en PEDIDO, sin modificar `precioUnitario` de Detalles.

## M-6. Visibilidad de Larman y trazabilidad de mensajes principales

| CU | Mensaje de diseño | Emisor → Receptor | Visibilidad / fundamento |
|---|---|---|---|
| UC-02 | `verificarDuplicadosActivosEInactivos`, `«create» Cliente` | ControladorClientes → Catálogo / Cliente nuevo | Repositorio por atributo, entidad por creación local |
| UC-33 | `consultarClientesPorCriterios` | ControladorClientes → CatálogoClientes | Por atributo; solo lectura |
| UC-32 | `obtenerYVerificarDuplicadoExcluyendoPropio`, `invalidarDesafiosOTPPendientes` | ControladorClientes → Catálogo / RepositorioDesafioAutenticacion | Ambos repositorios por atributo; Cliente obtenido por retorno y actualización local |
| UC-38 | `revocarDesafiosYSesionesOnline`, `registrarCambioEstado` | ControladorClientes → Repositorios de sesiones y de historial | Por atributo; estado e historia en una transacción |
| UC-57 | `«create» Politica`, `«create» AjusteCumplidor`, `«create» AjusteEnMora`, `registrarPoliticaYDosAjustesAtomicos` | Controlador → tres objetos nuevos y RepositorioPolitica | Creación local y repositorio por atributo |
| UC-15 | `calcularAntiguedadDeudaImpagaMasAntiguaFIFO` | ServicioCategoriaComercial → LibroCuentaCorriente | Receptor por atributo, criterio FIFO |
| UC-16 | `obtenerAjusteCategoria`, `calcularYCongelarAjuste` | ServicioCategoriaComercial → RepositorioPolitica / Pedido | Repositorio por atributo, Pedido por referencia local del CU invocante |

La visibilidad aquí es la **justificación del diseño propuesto**, no prueba de implementación. Los DTO siguen siendo tipos de aplicación, no tablas físicas.

## M-7. Dictamen y puerta de integración

**CONFORME para cerrar la homologación documental/estática del sublote REV-06B.1:** **7/7 firmas idénticas**, actores corregidos, efectos críticos históricos representados, modelo relacional respetado y XML sin bloqueantes estructurales detectados.

**Inventario global:** anteriormente **54/67** operaciones con firma homologada; ahora **61/67**. Restan exclusivamente las seis nuevas operaciones de **REV-06B.2** (`UC-36, UC-10, UC-31, UC-52, UC-09, UC-64`) y correcciones H01/H02 de UC-42 en DS, que **no incrementan el número de operaciones contractuales** porque UC-42 ya está contabilizado. Ver [matriz global actualizada](../MATRIZ_GLOBAL_COBERTURA_64_CU_67_CONTRATOS_2026-10-29.md).

**Gobierno:** conservar los archivos del paquete original; no modificar el DOCX maestro, el diagrama global de CU, DDL, PR #16/#17 ni `main`; publicar los corregidos en PR Draft apilada. El cierre de la auditoría de firmas no prueba seguridad RBAC en ejecución, historial persistente en BD o transacciones reales. Antes de fusionar, el responsable podrá inspeccionar los archivos revisados visualmente y aprobar su incorporación al documento académico.
