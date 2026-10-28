# REV-01 — Matriz final de homologación y visibilidad de Larman (preintegración)

**Fecha:** 28/10/2026 · **PR:** #10 (DRAFT) · **Estado:** MATRIZ AUDITADA, **visibilidad total NO certificada**.  
**Fuente canónica disponible:** catálogo UC-01..64 del contexto maestro, RDs aprobadas 27/10, diccionario MR-5/MR-6 de 60 tablas y versiones originales/propuestas de Gemini preservadas.  
**Fuente canónica faltante:** `ALE_MILANESAS_FASE_4_CU_01_A_64_TRES_NIVELES.docx` con las 192 fichas nativas. Su ausencia impide cotejo literal de nivel Real, permisos, excepciones y firma académica. **No utilizar** el anexo histórico del 23/10 de 49 CU como si fuera el documento actual de 64.

## Método aplicado (trazabilidad sin inferir autoridad)

- Localizar la operación **pública** Actor → :Sistema del DSS agrupado por actor. Cotejar con el primer evento actor/controlador del DS y el campo **Nombre** de su contrato.
- Revisar tipos y parámetros **de la propuesta de diseño**. «Coincide» significa que los **tres artefactos propuestos** son iguales, no que el Word Fase 4 confirmó esa firma.
- Para cada mensaje interior del DS registrar **emisor, receptor, origen de referencia** (parámetro, atributo/asociación, local, creación) y evidencia representada. «Posible» no equivale a «demostrado».
- Cotejar postcondiciones y excepciones con RDs y MR-5/MR-6, sin sustituir entidades de dominio por supuestas tablas nuevas ni exponer una llamada interna en el DSS.
- Marcar `OK interno`, `PARCIAL` o `PENDIENTE AUTORIDAD`, conservando las versiones originales.

## A. Contrato público homologado — firmas en los tres artefactos propuestos

| CU | DSS (evento actor→sistema) | DS (primer evento del actor) | Contrato de operación | Resultado |
|---|---|---|---|---|
| UC-50 | `registrarInsumo(nombre:String, codigoUnidadMedida:String, umbralMinimo:BigDecimal, nivelObjetivoReposicion:BigDecimal, automatizacionCompraActiva:Boolean)` | **Mismo nombre/argumentos**, DS `u50_m1` | **Mismo nombre/argumentos**, apartado 1 | **OK interno**; firma académica por confirmar |
| UC-42 | `registrarAjusteInventario(tipoElemento:String, idElemento:Long, tipoMovimiento:String, cantidad:Decimal, motivo:String, costoValuacion:Decimal[0..1])` | **Mismo nombre/argumentos**, DS `u42_m1` | **Mismo nombre/argumentos**, apartado 1 | **OK interno**; definición de `costoValuacion` de CU Real por confirmar |
| UC-51 | `buscarYModificarInsumo(criterio:FiltroInsumoDTO, datosNoHistoricosPermitidos:DatosInsumo, codigoUnidadMedidaPropuesto:CodigoUnidadMedida?)` | **Mismo nombre/argumentos**, DS `u51_m1`; UC-36 resuelto en paso interior | **Mismo nombre/argumentos**, apartado 1 | **OK interno**; definición de `DatosInsumo` y contrato de búsqueda por confirmar |

**Control:** no interpretar `BigDecimal`, `FiltroInsumoDTO` ni `CodigoUnidadMedida?` como una tecnología o tipo persistente aprobado. Son notaciones de la propuesta DS/DSS/contrato, distintas de los tipos físicos SQL. Ninguna implementación de API está certificada.

## B. Matriz de mensajes y visibilidad de Larman

**Criterios de evidencia:** (P) visibilidad por parámetro/variable local devuelta; (C) por creación; (A) por atributo/asociación estructural; (I) interfaz/actor→sistema; (ND) no demostrada. Visibilidad por «tener un id» **no** implica visibilidad del objeto receptor. La existencia de una tabla tampoco acredita (A) para una clase de diseño.

| CU / mensaje | Emisor → receptor | Fundamento posible | Evidencia realmente observada | Resultado |
|---|---|---|---|---|
| 50 / `u50_m1` | Administrador → `:ControladorInsumos` | I | Evento de entrada de UC-50 homologado | OK interno |
| 50 / `u50_m2` | ControladorInsumos → `:CatalogoInsumos` | A o P, por definir | El DS llama a `existeInsumoPorNombre`, **no** dibuja cómo se obtiene referencia al catálogo | **ND** |
| 50 / `u50_m3_new` | ControladorInsumos → `nuevoInsumo:Insumo` | C | Mensaje `«create»` y objeto `nuevoInsumo` | OK estructura; verificar responsabilidad |
| 50 / `u50_m5` | ControladorInsumos → `:CatalogoInsumos` | A/P | Envía `nuevoInsumo` como parámetro, pero referencia al catálogo sigue sin justificarse | **ND** |
| 50 / `u50_r1_ok` / `u50_r1_err` | ControladorInsumos → Administrador | I | Retornos de éxito/rechazo sin crear inventario ficticio | OK interno |
| 42 / `u42_m1` | Responsable de Producción/actor autorizado → `:ControladorInventario` | I | Operación UC-42 homologada; rol compuesto requiere comprobación RBAC | PARCIAL |
| 42 / `u42_m2` | ControladorInventario → `unInsumo:Insumo` | P/A por resolver | **Solo se pasa `idElemento`**; no está representada su búsqueda/recuperación de referencia | **ND** |
| 42 / `u42_mcost` | ControladorInventario → `costo:CostoInsumoHistorico` | C para SALDO_INICIAL | Creación condicional después de validación y antes de movimiento | OK conceptual; verificar source/campo |
| 42 / `u42_m3_new` | ControladorInventario → `movInsumo:MovimientoInsumo` | C | `«create»`, `vigenteDesdeCosto` de costo aplicable, misma identidad Insumo | OK conceptual; origen de `vigenteDesdeCosto` aún debe explicitarse |
| 42 / `rev01_u42_insaldo` | ControladorInventario → `unInsumo:Insumo` | P/A pendiente | Se representa mutación de saldo, pero **no** obtención de referencia de Insumo | **ND** |
| 42 / `u42_r1_ok` | ControladorInventario → actor | I | Retorno posterior a mutación de stock, sin Compra/Caja ficticia | OK textual |
| 42 / `u42_mrev1` | ControladorInventario → `prod:Producto(REVENTA)` | P/A pendiente | Se pasa `idElemento`, no se muestra localización del objeto Producto | **ND** |
| 42 / `u42_mrev2` | ControladorInventario → `val:ValoracionExtraordinariaReventa` | C | `«create»` en rama condicional si falta costo válido | OK conceptual; verificar campos permitidos |
| 42 / `u42_mrev3` | ControladorInventario → `movRev:MovimientoStockReventa` | C | `«create»` posterior a evaluación/valoración | OK conceptual; revisar costo resultante |
| 42 / `rev01_u42_revsaldo` | ControladorInventario → `prod:Producto(REVENTA)` | P/A pendiente | Se representa cambio de stock/costo, pero referencia al Producto no está acreditada | **ND** |
| 42 / `u42_rrev` / `u42_r1_err` | ControladorInventario → actor | I | Retornos en regiones REVENTA y rechazo | OK interno |
| 51 / `u51_m1` | Administrador → `:ControladorInsumos` | I | **Una única entrada pública** `buscarYModificarInsumo` con referencia «include» UC-36 | OK interno |
| 51 / `u51_m2` | ControladorInsumos → `:CatalogoInsumos` | A/P pendiente | Búsqueda por criterio; referencia a catálogo sin origen explícito | **ND** |
| 51 / `u51_m3` | ControladorInsumos → `:CatalogoInsumos` | A/P pendiente | Consulta de ambos historiales; revalidación transaccional descrita, **no demostrada por interacción** | **ND** |
| 51 / `u51_m4` | ControladorInsumos → `unInsumo:Insumo` | P/local devuelta | `unInsumo` es retorno de `buscarInsumo` en `u51_m2`; suficiente como referencia local **si** catálogo está accesible | PARCIAL |
| 51 / `u51_r4` | `unInsumo:Insumo` → ControladorInsumos | P/retorno | Resultado de actualización al controlador | OK interno |
| 51 / `u51_r3_ok` / `u51_r3_err` | ControladorInsumos → Administrador | I | Éxito o rechazo tras validaciones | OK interno |

**Dictamen de Larman:** no se certifica visibilidad del conjunto. Falta justificar la obtención de `:CatalogoInsumos` por `:ControladorInsumos` y de `Insumo`/`Producto` por `:ControladorInventario`. Las referencias temporales creadas por `«create»` sí tienen fundamento local, pero se debe verificar que el mensaje sea realmente la responsabilidad adecuada del receptor y que las asociaciones del dominio den soporte.

## C. Coherencia entre postcondiciones y decisiones ratificadas

| Requisito/decisión | Estado funcional entre DSS/DS/contrato | Límite |
|---|---|---|
| UC-50, RP-016: alta con `stockActual=0`; sin movimientos ni costos ficticios | **COHERENTE textual** | No sustituye el cotejo con ficha Real |
| UC-42, RP-015: `SALDO_INICIAL` físicamente justificado con costo histórico del mismo Insumo y movimiento vinculado | **COHERENTE conceptual** en DS/contrato | No hay prueba de servicio ni de origen de datos |
| UC-42, RP-022: costo promedio REVENTA, valoración extraordinaria y no retroactividad | **COHERENTE textual**, detalle de cálculo/validación de ajustes **PARCIAL** | Fórmula y operaciones físicas por caso requieren contrato de implementación |
| UC-51, RP-017: unidad editable solo sin movimiento **ni** costo histórico; nuevo Insumo si hay historia | **COHERENTE textual** | Revalidación atómica y permisos aún pendientes de prueba |
| CU-51 incluye UC-36 | **REFERENCIA conservada** | Revisión del flujo académico UC-36 pendiente |
| Control por roles | **NO CERTIFICADO** | Falta ficha Real y matriz de campos sensibles/permiso exacto |

## D. Defectos corregidos durante la homologación

1. **UC-51:** había dos llamadas del actor en DS (búsqueda y modificación) mientras el DSS ofrecía una operación agrupada. Se unificó la **entrada pública** en `u51_m1`; `u51_m2` y `u51_m3` quedaron como operaciones internas hacia `:CatalogoInsumos` (búsqueda e historial).
2. **UC-51:** se homologó `a1_m7` en DSS del Administrador y Nombre en contrato.
3. **UC-50:** se unificó la firma textual con `BigDecimal` en contrato; su tipificación no se presenta como decisión tecnológica aprobada.
4. **UC-42:** se homologó evento público `u42_m1` con `rp_m8` y contrato; se agregaron mensajes de actualización de stock en Insumo y REVENTA, posteriores al registro del movimiento correspondiente.
5. **UC-42:** las líneas de vida de objetos creados quedaron iniciadas en sus eventos de creación y acotadas a la alternativa pertinente; los mensajes de costo/stock mantienen orden creciente.

## E. Puntos de autoridad pendientes, que NO se pueden resolver mediante inferencia

1. **DOCX nativo de 64 CU:** cotejar nombres y firmas reales de operaciones, actores, excepciones y pre/postcondiciones.
2. **Visibilidad P/A:** evidenciar los vínculos y orígenes de referencias de controladores a catálogos y a entidades existentes mediante el diseño de clases aprobado; no afirmar que ya están demostrados.
3. **UC-42:** detallar si se habilitan conversiones de unidades en ajustes, fuentes admisibles de valoración, atributos/efectos obligatorios por tipo y atomicidad transaccional.
4. **UC-51:** definir literalmente qué atributos no históricos son editables y su matriz RBAC. No autorizar cambios por el solo nombre `DatosInsumo`.
5. **Herramienta:** comprobar abrir, ver, editar y reabrir los XML en Draw.io; el control de sintaxis hecho por analizador de etiquetas **no sustituye** pruebas en la herramienta ni un parser XML estricto independiente.

**Conclusión:** las firmas y reglas básicas están homologadas **entre los tres artefactos propuestos**. La visibilidad de Larman y la fidelidad académica completa no tienen evidencia suficiente para aprobarse.
