# REV-03B — Auditoría Transversal y Corrección: Proveedores, Órdenes de Compra y Recepción (UC-11, UC-37, UC-45, UC-46, UC-40, UC-39, UC-08)

**Fecha:** 28/10/2026  

**Rama de trabajo propuesta:** `revision/rev03b-proveedores-ordenes-2026-10-28`  

**Alcance (`REV-03B`):** `UC-37`, `UC-11`, `UC-45` («include» `UC-37`), `UC-46` («include» `UC-37`), `UC-40`, `UC-39` («include» `UC-40`), `UC-08` («extend» condicional `UC-40`).  

**Estado de los artefactos entregados:** `PROPUESTO / CORREGIDO EN REVISIÓN ESTÁTICA` (pendiente de inspección visual humana en Draw.io y aprobación para fusión a `main`).

---

## 1. Ejecución de las 8 Etapas Metodológicas (M-0 a M-7)

### M-0 — Autoridad y alcance congelados

* **Catálogo funcional vigente:** 64 CU consecutivos (`UC-01`..`UC-64`) en 3 niveles (`ALE_MILANESAS_FASE_4_CU_01_A_64_TRES_NIVELES.docx`), respetando el título canónico de Fase 4 **`UC-11 Gestionar Proveedor`**.

* **Relaciones UML aprobadas en este sublote:** `UC-45 → UC-37` (`include`), `UC-46 → UC-37` (`include`), `UC-39 → UC-40` (`include`) y `UC-40 → UC-08` (`extend` condicional cuando el ingreso responde a una Orden de Compra). El archivo `DIAGRAMA DE CASOS DE USO.drawio (1).xml` permanece intacto.

* **Decisiones y criterios transversales incorporados (`REV-01` y Corte 27/10/2026):**

  * **Corrección preventiva de `H01` y `H02` (`REV-01`) en `UC-08 — Registrar Ingreso de Stock por Compra`:**

    1. **Orden estricto Costo $\rightarrow$ Movimiento (`H01`):** Al ingresar un `Insumo` por compra, se registra **primero** la nueva vigencia en `CostoInsumoHistorico` (`fuenteCosto = COMPRA`) y **después** se crea la instancia de `MovimientoInsumo` (`INGRESO_COMPRA`) que referencia ese `vigenteDesdeCosto` válido.

    2. **Separación de ramas en fragmento `alt` (`H02` y `RD-RP022-001`):** El fragmento `alt` de `UC-08` separa en tres operandos mutuamente excluyentes con sus divisorias explícitas: (Op. 1\) Ingreso de `INSUMO` (con actualización opcional de `OrdenCompra` vía `«extend» UC-40` y evaluación de cierre de `EpisodioFaltante`), (Op. 2\) Ingreso de `PRODUCTO` de `REVENTA` (calculando el **promedio ponderado móvil** de costo antes de registrar `MovimientoStockReventa`, `RD-RP022-001`), y (Op. 3\) Rechazo atómico.

  * **Separación estricta de responsabilidades entre `UC-11`, `UC-45` y `UC-46` (Fichas Reales/Extendidas Fase 4):**

    * `UC-45 — Modificar Proveedor` actualiza datos comerciales/contacto y períodos de `ProveedorInsumo` conservando vigencias históricas, pero **no modifica el estado `ACTIVO`/`INACTIVO`** (que pertenece a `UC-46`) ni administra cuentas de `Usuario` (que pertenecen a `UC-17`/`UC-18`).

    * `UC-46 — Cambiar Estado de Proveedor` transiciona lógicamente `Proveedor.estado` (`ACTIVO` \| `INACTIVO`) sin eliminar invitaciones, respuestas ni órdenes históricas y **sin cancelar automáticamente las `OrdenCompra` abiertas**. Se elimina del DSS y del DS la tabla inexistente `HISTORIAL_ESTADO_PROVEEDOR`.

### M-1 — Proveniencia, integridad y matriz de diferencias (Antes → Después)

\| ID Hallazgo \| Artefacto / Celda Original \| Antes (Borrador 26–27/10) \| Después (Versión Corregida `REV03B`) \| Fundamento \|

\| :--- \| :--- \| :--- \| :--- \| :--- \|

\| **`H01` y `H02` (`REV-01` aplicado a `UC-08`)** \| `DS UC-08` (`u08_m3`, `u08_alt`) \| Agrupaba en un solo mensaje `incrementarStockYActualizarCosto` tanto `INSUMO` como `REVENTA` sin separar operandos ni mostrar que el costo precede al movimiento. \| Reconstruye el `alt` en **3 operandos excluyentes** (`INSUMO`, `REVENTA`, `RECHAZO`) y, en `INSUMO`, crea **primero** `CostoInsumoHistorico` y **luego** `MovimientoInsumo` con `vigenteDesdeCosto`. \| `REV-01` (`H01`, `H02`), `RD-RP022-001` \|

\| **`H06` (`REV-01` aplicado a `UC-08`)** \| `DS UC-08` y `Contrato 6B.5` \| Mencionaba promedio ponderado móvil de `REVENTA` en texto general sin desglosar la operación. \| Explicita el cálculo de promedio ponderado móvil (`nuevoCostoPromedio = (stockActual * costoActual \+ cantRecibida * costoCompra) / (stockActual \+ cantRecibida)`) antes del `MovimientoStockReventa`. \| `RD-RP022-001` / `H06` \|

\| **`M-5` (Tabla inexistente en `UC-46`)** \| `DSS Admin 6B` (`a2_r3`) y `DS UC-46` (`u46_r4`) \| Mencionaba `HISTORIAL_ESTADO_PROVEEDOR`, que no forma parte de las 60 tablas de MR-3. \| Se elimina la referencia a la tabla inexistente y se alinea con la Ficha Real/Extendida de `UC-46` (`Proveedor.estado = ACTIVO \| INACTIVO` conservando historial de invitaciones, respuestas y compras). \| Ficha Fase 4 `UC-46` y Diccionario MR-3 \|

\| **`H-11` (Contratos compuestos)** \| `Contrato 6B.1` (`UC-11`\+`45`\+`46`), `Contrato 6B.5` (`UC-08`\+`39`) y `Contrato 4.5` (`UC-40`) \| Agrupaba múltiples CU con pre/postcondiciones distintas bajo un mismo contrato. \| Se desagrupan en **7 Contratos individuales** (`UC-37`, `UC-11`, `UC-45`, `UC-46`, `UC-40`, `UC-39`, `UC-08`), cada uno con sus 9 secciones estándar. \| Puerta `G4` / `H-11` \|

\| **`H-12`, `H-19` y `H05`** \| `DSS Admin 6B`, `DS` y `Contratos` \| Secuencia continua en el DSS y firmas divergentes entre DSS, DS y Contrato. \| Marcos `sd` independientes por CU en el DSS, lenguaje de caja negra y homologación 1:1 de las 7 firmas públicas entre DSS, DS (`1:`) y Contratos. \| `M-3`, `H-12`, `H-19`, `H05` \|

---

## 2. Matriz de Trazabilidad Vertical y Visibilidad de Larman Mensaje por Mensaje (M-3 y M-6)

\| CU \| Paso / Mensaje en DS \| Emisor $\rightarrow$ Receptor \| Tipo de Visibilidad (Larman) \| Origen verificable de la referencia \|

\| :--- \| :--- \| :--- \| :--- \| :--- \|

\| **`UC-37`** \| `1: buscarProveedor(idProveedor, cuit, razonSocial, nombreComercial, estado)` \| `Actor Interno Autorizado` $\rightarrow$ `:ControladorProveedores` \| Frontera de sistema \| Operación pública homologada del DSS (`UC-37`). \|

\| **`UC-37`** \| `2: lista = consultarProveedoresPorCriterios(filtro)` \| `:ControladorProveedores` $\rightarrow$ `:CatalogoProveedores` \| **Por Atributo** \| Repositorio de Proveedores inyectado en el controlador. \|

\| **`UC-11`** \| `1: gestionarProveedor(cuit, razonSocial, nombreComercial, contacto, insumosVigencias)` \| `Administrador` $\rightarrow$ `:ControladorProveedores` \| Frontera de sistema \| Operación pública homologada del DSS (`UC-11`). \|

\| **`UC-11`** \| `2: validacion = validarUnicidadCuitYVigenciasInsumo(cuitNormalizado, insumosVigencias)` \| `:ControladorProveedores` $\rightarrow$ `:CatalogoProveedores` \| **Por Atributo** \| Verifica que el CUIT no esté duplicado y que no existan vigencias superpuestas en `ProveedorInsumo`. \|

\| **`UC-11`** \| `3: «create» new(cuitNormalizado, razonSocial, nombreComercial, contacto, estado=ACTIVO)` \| `:ControladorProveedores` $\rightarrow$ `unProveedor : Proveedor` \| **Por Creación Local (`new`)** \| Instancia el `Proveedor` comercial. \|

\| **`UC-11`** \| `4: «create» new(unProveedor, unInsumo, vigenteDesde, vigenteHasta)` \| `unProveedor : Proveedor` $\rightarrow$ `rel : ProveedorInsumo` \| **Por Creación Local (`new`) \+ Atributo** \| `Proveedor` crea y mantiene sus relaciones históricas `ProveedorInsumo`. \|

\| **`UC-45`** \| `1: modificarProveedor(idProveedor, datosComerciales, cambiosVigenciasInsumo)` \| `Administrador` $\rightarrow$ `:ControladorProveedores` \| Frontera de sistema \| Operación pública homologada del DSS (`UC-45`, precedida por `«include» UC-37`). \|

\| **`UC-45`** \| `2: ok = validarCompatibilidadInsumosYVigencias(idProveedor, datosComerciales, cambiosVigenciasInsumo)` \| `:ControladorProveedores` $\rightarrow$ `:CatalogoProveedores` \| **Por Atributo** \| Valida formato, Insumos registrados y no solapamiento de períodos `[vigenteDesde, vigenteHasta)`. \|

\| **`UC-45`** \| `3: actualizarDatosComercialesYVigencias(datosComerciales, cambiosVigenciasInsumo)` \| `:ControladorProveedores` $\rightarrow$ `unProveedor : Proveedor` \| **Por Variable Local** \| Actualiza datos vigentes y preserva la historia de `ProveedorInsumo` sin cambiar `estado`. \|

\| **`UC-46`** \| `1: cambiarEstadoProveedor(idProveedor, nuevoEstado, motivo)` \| `Administrador` $\rightarrow$ `:ControladorProveedores` \| Frontera de sistema \| Operación pública homologada del DSS (`UC-46`, precedida por `«include» UC-37`). \|

\| **`UC-46`** \| `2: admisible = revalidarTransicionEstadoProveedor(idProveedor, nuevoEstado, motivo)` \| `:ControladorProveedores` $\rightarrow$ `:CatalogoProveedores` \| **Por Atributo** \| Revalida en concurrencia (`F09`) que el estado difiera del actual y tenga motivo cuando corresponde. \|

\| **`UC-46`** \| `3: establecerEstadoComercial(nuevoEstado)` \| `:ControladorProveedores` $\rightarrow$ `unProveedor : Proveedor` \| **Por Variable Local** \| Actualiza `Proveedor.estado` (`ACTIVO` \| `INACTIVO`) sin cancelar Órdenes abiertas ni borrar invitaciones/respuestas previas. \|

\| **`UC-40`** \| `1: buscarOrdenCompra(idOrdenCompra, idProveedor, idInsumo, estado, fechaEmision)` \| `Actor Interno Autorizado` $\rightarrow$ `:ControladorCotizacionesCompras` \| Frontera de sistema \| Operación pública homologada del DSS (`UC-40`). \|

\| **`UC-40`** \| `2: ordenes = consultarOrdenesPorCriterios(filtro)` \| `:ControladorCotizacionesCompras` $\rightarrow$ `:RepositorioCotizaciones` \| **Por Atributo** \| Recupera `OrdenCompra` con cantidad ordenada, acumulada recibida y referencia a la cotización. \|

\| **`UC-39`** \| `1: cancelarOrdenCompra(idOrdenCompra, motivoCancelacion, cancelacionAtribuibleProveedor)` \| `Administrador` $\rightarrow$ `:ControladorCotizacionesCompras` \| Frontera de sistema \| Operación pública homologada del DSS (`UC-39`, precedida por `«include» UC-40`). \|

\| **`UC-39`** \| `2: cancelarSaldoPendiente(motivoCancelacion, cancelacionAtribuibleProveedor, idAdmin, fechaHoraCancelacion)` \| `:ControladorCotizacionesCompras` $\rightarrow$ `unaOrden : OrdenCompra` \| **Por Variable Local** \| Pasa `unaOrden.estado` a `CANCELADA` conservando recepciones previas y manteniendo abierto el episodio si persiste el faltante. \|

\| **`UC-08`** \| `1: registrarIngresoStockPorCompra(tipoElemento, idElemento, idOrdenCompra, cantidadRecibida, costoUnitarioCompra, comprobante)` \| `Actor Autorizado` $\rightarrow$ `:ControladorInventario` \| Frontera de sistema \| Operación pública homologada del DSS (`UC-08`, con `«extend»` condicional `UC-40`). \|

\| **`UC-08`** \| `2: «create» new(idOrdenCompra[0..1], idElemento, cantidadRecibida, costoUnitarioCompra, fechaHoraRecepcion)` \| `:ControladorInventario` $\rightarrow$ `unaRecepcion : RecepcionCompra` \| **Por Creación Local (`new`)** \| Registra el documento de recepción física. \|

\| **`UC-08`** \| `3 (Rama INSUMO): «create» new(unInsumo, vigenteDesde, costoUnitarioCompra, fuenteCosto=COMPRA, unaRecepcion)` \| `:ControladorInventario` $\rightarrow$ `nuevoCosto : CostoInsumoHistorico` \| **Por Creación Local (`new`) \+ Parámetro** \| **Orden obligatorio `H01`:** Crea **primero** la vigencia de costo histórico originada en la compra. \|

\| **`UC-08`** \| `4 (Rama INSUMO): «create» new(unInsumo, tipo=INGRESO_COMPRA, cantidadRecibida, stockResultante, nuevoCosto.vigenteDesde, unaRecepcion)` \| `:ControladorInventario` $\rightarrow$ `movIns : MovimientoInsumo` \| **Por Creación Local (`new`) \+ Parámetro** \| Crea **después** el `MovimientoInsumo` referenciando `nuevoCosto.vigenteDesde`, actualiza `unInsumo.stockActual` y `unaOrden`. \|

\| **`UC-08`** \| `3b (Rama REVENTA): recalcularCostoPromedioPonderadoMovilEIncrementarStock(cantidadRecibida, costoUnitarioCompra)` \| `:ControladorInventario` $\rightarrow$ `prodRev : Producto` \| **Por Variable Local** \| Actualiza el costo promedio ponderado móvil (`RD-RP022-001`) y el stock de reventa. \|

\| **`UC-08`** \| `4b (Rama REVENTA): «create» new(prodRev, tipo=INGRESO_COMPRA, cantidadRecibida, stockResultante, costoUnitarioCompra, unaRecepcion)` \| `:ControladorInventario` $\rightarrow$ `movRev : MovimientoStockReventa` \| **Por Creación Local (`new`) \+ Parámetro** \| Registra el movimiento de entrada en el inventario separado de `REVENTA` (`RD-RP022-001`). \|

---

## 3. Matriz Transversal de Invariantes y Puertas de Aceptación (M-4 y M-7)

\| ID \| Invariante ratificada \| DSS \| DS \| Contrato \| Dictamen \|

\| :--- \| :--- \| :--- \| :--- \| :--- \| :--- \|

\| **`I-01`** \| `H01` (`REV-01`) en `UC-08`: En recepción de `INSUMO`, se crea primero `CostoInsumoHistorico` (`COMPRA`) y recién después `MovimientoInsumo` referenciando `vigenteDesdeCosto` \| Respuesta de caja negra consistente \| `u08_m3_cost` precede estrictamente a `u08_m4_mov` dentro del operando `INSUMO` \| Postcondiciones ordenadas en `CONTRATO_UC08` \| **PASÓ (Trazabilidad estática)** \|

\| **`I-02`** \| `H02` y `H06` (`REV-01` / `RD-RP022-001`) en `UC-08`: Operandos `alt` mutuamente excluyentes (`INSUMO`, `REVENTA` con promedio ponderado móvil, `RECHAZO`) manteniendo inventarios separados \| Guardas diferenciadas \| 3 operandos con divisorias explícitas en `DS UC-08` \| Postcondiciones separadas por tipo de inventario en `CONTRATO_UC08` \| **PASÓ (Trazabilidad estática)** \|

\| **`I-03`** \| Fichas Fase 4 `UC-11`, `UC-37`, `UC-45`, `UC-46`: Conservación histórica de `ProveedorInsumo`; inactivación de Proveedor no cancela de oficio `OrdenCompra` abiertas ni usa tablas inexistentes \| Marcos independientes `UC-37`, `UC-11`, `UC-45`, `UC-46` \| `DS UC-37`, `UC-11`, `UC-45`, `UC-46` alineados a MR-3 \| Contratos individuales 1 a 4 \| **PASÓ (Trazabilidad estática)** \|

\| **`I-04`** \| `UC-39` («include» `UC-40`): Cancela saldo pendiente con motivo y flag `cancelacionAtribuibleProveedor`, conservando recepciones previas y manteniendo episodio abierto sin disparo automático \| Marco `UC-39` con `ref UC-40` \| `DS UC-39` con operandos `alt` \| `CONTRATO_UC39` individual \| **PASÓ (Trazabilidad estática)** \|

\| **`I-05`** \| Homologación 1:1 de firmas públicas DSS ↔ DS ↔ Contrato y desagrupamiento en 7 contratos individuales (`H-11`, `H05`) \| 7 firmas canónicas \| Mensaje `1:` idéntico en las 7 páginas DS \| 7 Contratos individuales con las mismas 7 firmas \| **PASÓ** \|

\| **`I-06`** \| Inspección visual y prueba de desplazamiento (`round-trip`) en editor gráfico Draw.io (`M-6` / `G5`) \| XML bien formado \| XML bien formado con 3 operandos en `UC-08` \| N/A \| **PENDIENTE DE VALIDACIÓN HUMANA EN DRAW.IO** \|
