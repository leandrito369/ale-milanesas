# REV-06B.2 — Auditoría transversal de Recetas, Insumos y Consultas de Inventario

**Fecha:** 29/10/2026. **Sistema:** Gestión para Ale Milanesas.  
**Alcance:** `UC-36`, `UC-10`, `UC-31`, `UC-52`, `UC-09`, `UC-64` (seis contratos), y adenda de diseño **UC-42 H01/H02** sin nueva operación pública.  
**Rama de trabajo:** `revision/rev06b2-recetas-inventario-2026-10-29`, apilada sobre PR #18 de REV-06B.1.  
**Dictamen:** **CONFORME en cotejo estático y documental de 6/6 firmas DSS–DS–Contrato, con 7 páginas DS y recuperación H01/H02 de UC-42 por estructura y geometría.** Pendiente inspección visual de estos **nuevos** artefactos Draw.io por el responsable; ninguna prueba de ejecución de SQL o servicios.

## M-0 — Autoridades y alcance congelados

- [Fase 4 — 64 CU, tres niveles](https://docs.google.com/document/d/1BMF2Yfsh2ki353fU2dS5eZtIsYrOntpkjjAzulNy1uY/edit), cotejada para UC-36/10/31/52/09/64 y UC-42.
- [Contratos 13 CU REV-06B](../REV06B_CLIENTES_RECETAS_INVENTARIO/propuestos/CONTRATOS_REV06B_TRECE_CORREGIDOS.md), apartados 8 a 13: autoridad de nombres, tipos, multiplicidades y excepciones; y [Contrato UC-42](../REV01_UC42/propuestos/CONTRATO_UC42_REV01.md) aprobado como referente de firma de los lotes anteriores.
- [Diccionario MR-5/MR-6 (60 tablas)](../../05-modelo-relacional/Diccionario_Explicativo_60_Tablas_MR5_MR6_26-10-2026.md), [RD-RP007-002](../../01-gobierno/RD_RP007_002_PERMISOS_BUSQUEDAS_2026-10-27.md) y RD-RP022-001.
- [Adenda histórica de UC-42 H01/H02](../REV01_ADENDA_H01_H02_UC42_2026-10-28.md) y DS REV-01 de UC-42 ya corregido geométricamente. No se alteró ni sustituyó su artefacto original.

La relación `«include»` se conserva donde está respaldada: UC-10 con UC-35 y UC-36; UC-31/52 con UC-36. El hecho de consultar stock o movimientos no crea nuevas relaciones UML. La matriz RD-RP007-002 permite UC-36 directo/contextual a **Administrador y Producción**; esta autorización de búsqueda **no** otorga permisos para editar UC-31 a Administrador.

## M-1 — Riesgos controlados

| Hallazgo | Severidad | Evidencia / medida |
|---|---|---|
| B2-01: firma e identidad de Receta | Alta | UC-10 crea `VERSION_RECETA(idReceta,numeroVersion)` y `DETALLE_VERSION_RECETA(idReceta,numeroVersion,idInsumo)`, sin recrear Receta estable ni alterar versiones usadas por Preparaciones históricas. |
| B2-02: configuraciones prospectivas | Alta | UC-31 **solo Responsable de Producción**, validación `objetivo > umbral >= 0`; configurar parámetros no emite rondas/Solicitudes/Órdenes retroactivas, no cierra EpisodioFaltante ni altera stock. |
| B2-03: alcance de consultas | Alta | UC-09 **solo Producción**, UC-36 **Administrador/Producción** directo-contextual y UC-64 **Administrador/Producción** con campos sensibles sujetos a rol. |
| B2-04: baja lógica | Media | UC-52 **solo Administrador**, preserva stock/costos, Solicitudes/Órdenes históricas y no aplica cancelación implícita. Estado igual se informa como ausencia de cambio. |
| B2-05: inventarios separados | Media | UC-09 muestra stock cero y no usa umbrales de Insumo para REVENTA; UC-64 conserva movimientos INSUMO y REVENTA separados, sin inventar stock comercial de ELABORADO. |
| B2-06: consistencia del contrato UC-09 | Baja | Se corrigió la salida del contrato a **excepciones A1–A5** en lugar de A1–A2. Firma pública y nueve apartados intactos. |
| B2-07: H01/H02 de UC-42 | Alta | Se reutilizó la adenda REV-01 ya corregida: creación de costo SALDO_INICIAL antes del MovimientoInsumo y separación de tres bandas UML. En la **séptima página** se completan extremos de mensajes y actor solo Producción. |

## M-2 — DSS de sistema

[**DSS REV-06B.2 — seis casos, dos páginas**](./propuestos/DSS_REV06B2_RECETAS_INVENTARIO_UC09_10_31_36_52_64.drawio.xml).

Los seis marcos `sd` contienen un único receptor de frontera `:Sistema`, la firma completa `1:`, respuesta válida, rechazo y nota de regla. Los sistemas de Inventario/Compras no se fusionan: UC-09 separa INSUMO de REVENTA, y UC-64 ofrece historiales separados. No se exponen controladores internos ni repositorios como receptor de los mensajes públicos.

## M-3 — Cotejo triple de las seis firmas nuevas

| CU | Operación pública coincidente en DSS, DS (mensaje 1:) y contrato |
|---|---|
| UC-36 | `buscarInsumo(idInsumo: Long[0..1], nombre: String[0..1], activo: Boolean[0..1])` |
| UC-10 | `configurarRecetaProducto(idProducto: Long, cantidadRendimientoBase: BigDecimal, codigoUnidadRendimiento: String, vigenteDesde: Timestamp, vigenteHasta: Timestamp[0..1], itemsInsumo: List<ItemRecetaDTO>)` |
| UC-31 | `configurarParametrosReposicionInsumo(idInsumo: Long, umbralMinimo: BigDecimal, nivelObjetivoReposicion: BigDecimal, automatizacionCompraActiva: Boolean)` |
| UC-52 | `cambiarEstadoInsumo(idInsumo: Long, nuevoActivo: Boolean)` |
| UC-09 | `consultarStock(tipoInventario: String[0..1], idElemento: Long[0..1], soloBajoUmbral: Boolean[0..1])` |
| UC-64 | `consultarMovimientosInventario(tipoInventario: String, idElemento: Long[0..1], tipoMovimiento: String[0..1], fechaDesde: LocalDate[0..1], fechaHasta: LocalDate[0..1])` |

**Resultado automático:** **6/6** cotejos de operación+parámetros coincidentes textualmente, normalizando espacios y la entidad XML `&lt;`/`&gt;`; se permite que el DS muestre un nombre de variable local de retorno, no se altera la firma. Los contratos conservan los nueve apartados. UC-42 no suma un séptimo contrato: conserva `registrarAjusteInventario(...)` ya homologado en REV-01.

## M-4 — Estructura del XML y conectividad

| Control de calidad | DSS | DS |
|---|---:|---:|
| Páginas `diagram` | **2** | **7** (6 CU nuevos + UC-42) |
| Celdas `mxCell` por página | 42 + 42 = **84** | 15, 31, 21, 22, 20, 21 y 49 = **179** |
| Identificadores duplicados por página | **0** | **0** |
| Mensajes numerados sin `source`/`target` | **0** | **0** |
| Referencias a celdas inexistentes | **0** | **0** |
| Valores con `<` literal o `&` mal escapado | **0** | **0** |
| Balance de apertura/cierre de etiquetas (análisis léxico) | **Conforme** | **Conforme** |

Los diagramas se generaron como XML editable de diagrams.net. La verificación fue por inspección automatizada de etiquetas, referencias y valores; **no constituye una prueba de apertura y representación visual en Draw.io ni de rendimiento de implementación**.

## M-5 — DS de diseño y las siete páginas

[**DS REV-06B.2 — seis CU y UC-42**](./propuestos/DS_REV06B2_RECETAS_INVENTARIO_UC09_10_31_36_52_64.drawio.xml).

| Página | Caso | Contenido de diseño |
|---|---|---|
| 1 | UC-36 | Controlador/RepositorioInsumos; búsqueda solo lectura; Admin y Producción según matriz de permisos |
| 2 | UC-10 | Refs UC-35/UC-36, validación de Producto ELABORADO e Insumos activos/unidades; Receta estable, nueva Versión y un Detalle por Insumo; transacción atómica |
| 3 | UC-31 | Ref UC-36; `umbralMinimo`, `nivelObjetivoReposicion`, `automatizacionCompraActiva`; solo Producción; con `opt` de advertencia al actor si hay faltante, sin ronda retroactiva |
| 4 | UC-52 | Ref UC-36; dependencias existentes, cambio ACTIVO/INACTIVO, conservación de historia y control F09 |
| 5 | UC-09 | Consultas separadas por tipo de inventario; stock cero visible, REVENTA sin umbral de Insumo |
| 6 | UC-64 | Consultas separadas de `MOVIMIENTO_INSUMO` y `MOVIMIENTO_STOCK_REVENTA`; control de campos por rol |
| 7 | UC-42 | Reutiliza la geometría de la adenda H01/H02 y completa enlaces de mensajes de diseño; actor corregido exclusivamente a Responsable de Producción |

**Regla Larman:** el controlador mantiene repositorios visibles por atributo; entidades recuperadas por retorno local; `VersionReceta`/`DetalleVersionReceta` por creación local; parámetros por mensaje; no se afirma existencia de código ejecutado. Los DTO son tipos de diseño y no tablas.

## M-6 — H01/H02 UC-42: control dimensional, mensaje y autoridad

Se parte de la corrección anterior y se conserva intacto el DS del lote REV-01 en su ruta histórica. En la **página 7 de este sublote**:

- **H01:** `u42_mcost` crea `CostoInsumoHistorico` a **y=470** y ahora apunta a `u42_cost_bar` desde el controlador; `u42_m3_new` crea `MovimientoInsumo` a **y=540** con referencia a `vigenteDesdeCosto` (mismo Insumo), apuntando a `u42_mov_bar`. Se verifica `470 < 540`. El `opt SALDO_INICIAL` se extiende de **y=420 a y=520**, contiene el costo pero no la creación del Movimiento ordinario, que viene después.
- **H02:** `u42_alt` ocupa **y=280..1590**, y sus divisorias están en **y=880** y **y=1370**. Las guardas INSUMO (**y=305**), REVENTA (**y=905**) y rechazo (**y=1390**) caen en bandas distintas. Los extremos de siete mensajes internos que antes eran meramente puntos geométricos ahora se vinculan con celdas participantes existentes.
- **Actor:** la ficha de Fase 4 y el contrato UC-42 requieren **Responsable de Producción**; la antigua etiqueta mezclaba indebidamente “Admin”. Se corrigió en esta pestaña, no en el archivo REV-01 original.
- **Firma pública:** `registrarAjusteInventario(tipoElemento: String, idElemento: Long, tipoMovimiento: String, cantidad: Decimal, motivo: String, costoValuacion: Decimal[0..1])`. Se eliminó el sufijo decorativo `[UC-42]` del mensaje 1 para garantizar cotejo literal; **sin cambiar parámetros, tipos, cantidad de operaciones ni reglas de costo**.

**Dictamen H01/H02:** **subsanados en revisión geométrica y de conectividad, pendientes únicamente de inspección visual y validación académica de la página revisada**. No se confunden controles estáticos con prueba de programa ni se agrega un CU nuevo.

## M-7 — Dictamen transversal y puerta de integración

**Resultado documental:** los seis contratos nuevos quedaron homologados en sus firmas públicas con sus DSS y DS. Se suman a los **61/67** previamente cotejados en REV-01…REV-06B.1: **67/67 operaciones contractuales con firma triple cotejada para los 64 CU**. Los tres casos con dos operaciones (UC-03, UC-07, UC-29) continúan correctamente contabilizados.

**Resultado técnico limitado:** integridad de referencias, consistencia de firmas y modelo relacional evaluadas. **No** se ejecutaron pruebas de base de datos, cálculos FIFO/stock, autorización real, concurrencia, rollback, renderizado Draw.io ni integración al documento académico.

**Para integrar:** descargar e inspeccionar visualmente los **dos archivos nuevos**, incluida pestaña UC-42, en diagrams.net; ratificar legibilidad y edición. Después revisar PR Draft, aprobar la integración documental y fusionar ordenadamente la cadena de PR si corresponde. No se modifica el documento maestro ni el DDL ni `main` automáticamente.
