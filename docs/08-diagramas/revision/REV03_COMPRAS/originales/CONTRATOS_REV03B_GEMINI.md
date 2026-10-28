# Contratos de Operación del Sistema (DSS — REV-03B) — Proveedores, Órdenes de Compra y Recepción (7 Contratos Individuales)

**Proyecto:** Sistema de Gestión para Ale Milanesas (UNaM-FCEQyN)  

**Lote de revisión:** `REV-03B` (`UC-37`, `UC-11`, `UC-45`, `UC-46`, `UC-40`, `UC-39`, `UC-08`)  

**Decisiones y criterios incorporados:** `RD-RP022-001` (separación de inventarios `INSUMO` y `REVENTA` y promedio ponderado móvil), corrección de secuencia `Costo → Movimiento` (`H01`/`H02` de `REV-01`) y desagrupamiento total de contratos (`H-11`).

---

## 1. Contrato de la Operación `buscarProveedor` (`UC-37`)

1. **Nombre:** `buscarProveedor(idProveedor: Long[0..1], cuit: String[0..1], razonSocial: String[0..1], nombreComercial: String[0..1], estado: String[0..1])`

2. **Responsabilidades:** Localizar Proveedores activos o inactivos que cumplan los criterios indicados y devolver el Proveedor seleccionado al caso de uso invocante sin modificar su información.

3. **Tipo:** `Sistema`

4. **Referencias cruzadas:** Caso de Uso `UC-37 — Buscar Proveedor`; incluido por `UC-45 — Modificar Proveedor` y `UC-46 — Cambiar Estado de Proveedor`; Objetivo `OBJE-09`; Requisito `RF-11`.

5. **Notas:** Operación estrictamente de solo lectura. Si el caso de uso invocante exige que el Proveedor se encuentre `ACTIVO`, dicha condición es validada por ese caso de uso.

6. **Excepciones:**

   * **A1 — Sin coincidencias:** Informar que no se encontraron Proveedores que cumplan los criterios.

   * **A2 — Criterios con formato inválido:** Solicitar corrección sin ejecutar la búsqueda.

7. **Salida:**

   * Listado de Proveedores coincidentes (`idProveedor`, `cuit`, `razonSocial`, `nombreComercial`, contacto principal, `estado` `ACTIVO` \| `INACTIVO`) y referencia del `Proveedor` seleccionado; o mensajes de las excepciones A1–A2.

8. **Precondiciones:**

   * El actor interno se encuentra autenticado y autorizado.

9. **Postcondiciones:**

   * **(Sin cambios de estado en el sistema: no se crean ni modifican instancias de `Proveedor` ni `ProveedorInsumo`)**.

---

## 2. Contrato de la Operación `gestionarProveedor` (`UC-11`)

1. **Nombre:** `gestionarProveedor(cuit: String, razonSocial: String, nombreComercial: String[0..1], contacto: ContactoDTO, insumosVigencias: List<VigenciaInsumoDTO>)`

2. **Responsabilidades:** Registrar un Proveedor comercial verificando la unicidad de su CUIT normalizado y estableciendo las vigencias históricas de los Insumos que suministra (`ProveedorInsumo`).

3. **Tipo:** `Sistema`

4. **Referencias cruzadas:** Caso de Uso `UC-11 — Gestionar Proveedor` **(denominación canónica Fase 4)**; Objetivo `OBJE-09`; Requisito `RF-11`.

5. **Notas:** El registro comercial del `Proveedor` es independiente de la creación de su cuenta de `Usuario` (`UC-17`/`UC-18`). No se admiten períodos de vigencia superpuestos para el mismo par `Proveedor`–`Insumo`.

6. **Excepciones:**

   * **A1 — CUIT duplicado (en Proveedor activo o inactivo):** Rechazar el registro de una nueva identidad duplicada.

   * **A2 — Datos comerciales o de contacto inválidos o ausentes:** Solicitar corrección antes de confirmar.

   * **A3 — Asociación `ProveedorInsumo` superpuesta o vigencia inválida:** Rechazar el período incompatible.

7. **Salida:**

   * Confirmación del `Proveedor` registrado (`idProveedor`, `estado = ACTIVO`) y de sus asociaciones `ProveedorInsumo` vigentes; o mensajes de las excepciones A1–A3.

8. **Precondiciones:**

   * El `Administrador` se encuentra autenticado y autorizado, y existen los `Insumo` referenciados en `insumosVigencias`.

9. **Postcondiciones:**

   * Se creó una instancia `unProveedor` de `Proveedor` con `cuit` normalizado único, `razonSocial`, `nombreComercial`, datos de contacto, `estado = ACTIVO` y `fechaHoraAlta`.

   * Para cada elemento en `insumosVigencias`, se creó una instancia de `ProveedorInsumo` asociada a `unProveedor` y al `Insumo`, con `vigenteDesde` y `vigenteHasta` (`0..1`).

---

## 3. Contrato de la Operación `modificarProveedor` (`UC-45` «include» `UC-37`)

1. **Nombre:** `modificarProveedor(idProveedor: Long, datosComerciales: DatosProveedorDTO, cambiosVigenciasInsumo: List<VigenciaInsumoDTO>)`

2. **Responsabilidades:** Actualizar los datos comerciales/contacto y las asociaciones vigentes de `ProveedorInsumo` de un `Proveedor` previamente localizado mediante `UC-37`, preservando su historial de vigencias anteriores.

3. **Tipo:** `Sistema`

4. **Referencias cruzadas:** Caso de Uso `UC-45 — Modificar Proveedor`; incluye `UC-37 — Buscar Proveedor`; Objetivo `OBJE-09`; Requisitos `RF-11`, `IRQ-08`.

5. **Notas:** Los cambios de estado `ACTIVO`/`INACTIVO` corresponden exclusivamente a `UC-46`, y la administración de cuentas de acceso con Rol `PROVEEDOR` corresponde a `UC-17`/`UC-18`.

6. **Excepciones:**

   * **A1 — `UC-37` finalizó sin selección válida:** No modificar información.

   * **A2 — Vínculo con `Insumo` inexistente, vigencia `[vigenteDesde, vigenteHasta)` superpuesta o datos comerciales inválidos:** Solicitar corrección y conservar los datos anteriores.

7. **Salida:**

   * Confirmación de la modificación de los datos comerciales y de las asociaciones `ProveedorInsumo` del `Proveedor`; o mensajes de las excepciones A1–A2.

8. **Precondiciones:**

   * El `Administrador` se encuentra autenticado y autorizado, existe el `Proveedor` seleccionado mediante `UC-37` y existen los `Insumo` involucrados.

9. **Postcondiciones:**

   * Se modificaron los atributos comerciales y de contacto vigentes de `unProveedor` (conservando inalterado `unProveedor.estado`).

   * Se crearon nuevas instancias y/o se cerraron períodos vigentes en `ProveedorInsumo` conforme a `cambiosVigenciasInsumo`, sin eliminar los períodos históricos anteriores.

---

## 4. Contrato de la Operación `cambiarEstadoProveedor` (`UC-46` «include» `UC-37`)

1. **Nombre:** `cambiarEstadoProveedor(idProveedor: Long, nuevoEstado: String, motivo: String[0..1])`

2. **Responsabilidades:** Activar o desactivar lógicamente un `Proveedor` (previamente localizado mediante `UC-37`), conservando su identidad comercial y la totalidad de sus invitaciones, respuestas, órdenes de compra y vigencias históricas.

3. **Tipo:** `Sistema`

4. **Referencias cruzadas:** Caso de Uso `UC-46 — Cambiar Estado de Proveedor`; incluye `UC-37 — Buscar Proveedor`; Pendiente `F09`; Objetivo `OBJE-09`; Requisitos `RF-11`, `IRQ-08`.

5. **Notas:** Si el `Proveedor` pasa a `INACTIVO`, deja de ser elegible para nuevas `InvitacionCotizacion` (`UC-44` / `PRA-01`), no admite nuevas respuestas (`UC-13`) ni nuevas confirmaciones de compra (`UC-12`), pero **no se eliminan sus respuestas previas ni se cancelan automáticamente sus `OrdenCompra` abiertas** (las cuales quedan sujetas a resolución manual autorizada en `UC-08` o `UC-39`).

6. **Excepciones:**

   * **A1 — Sin `Proveedor` seleccionado en `UC-37`:** No ejecutar operación.

   * **A2 — El `Proveedor` ya posee el `nuevoEstado` solicitado:** Informar ausencia de cambio.

   * **A3 — Estado o dependencias modificados concurrentemente de modo inválido:** Detener la transición sin alterar el historial.

7. **Salida:**

   * Confirmación del nuevo `Proveedor.estado` (`ACTIVO` \| `INACTIVO`), o mensajes provocados por las excepciones A1–A3.

8. **Precondiciones:**

   * El `Administrador` se encuentra autenticado y autorizado, y existe el `Proveedor` seleccionado mediante `UC-37`.

9. **Postcondiciones:**

   * Se modificó el atributo `unProveedor.estado` al valor `nuevoEstado` (`ACTIVO` o `INACTIVO`).

   * Se conservaron íntegramente todas las instancias históricas de `InvitacionCotizacion`, `RespuestaCotizacion`, `DecisionCompra`, `OrdenCompra` y `ProveedorInsumo` asociadas a `unProveedor`.

---

## 5. Contrato de la Operación `buscarOrdenCompra` (`UC-40`)

1. **Nombre:** `buscarOrdenCompra(idOrdenCompra: Long[0..1], idProveedor: Long[0..1], idInsumo: Long[0..1], estado: String[0..1], fechaEmision: LocalDate[0..1])`

2. **Responsabilidades:** Localizar y presentar las `OrdenCompra` que cumplan los criterios informados y devolver la Orden seleccionada al caso de uso invocante (`UC-08`, `UC-39` o consulta de seguimiento).

3. **Tipo:** `Sistema`

4. **Referencias cruzadas:** Caso de Uso `UC-40 — Buscar Orden de Compra`; incluido por `UC-39 — Cancelar Orden de Compra`; extiende condicionalmente a `UC-08 — Registrar Ingreso de Stock por Compra`; Objetivo `OBJE-09`; Requisito `RF-11`.

5. **Notas:** Operación estrictamente de solo lectura. Si el caso invocante exige un estado específico (`PENDIENTE` o `PARCIALMENTE_RECIBIDA`), dicha validación se ejecuta en el caso invocante.

6. **Excepciones:**

   * **A1 — Sin coincidencias:** Informar que no existen Órdenes de Compra que cumplan los criterios.

   * **A2 — Criterios inválidos:** Solicitar corrección sin modificar registros.

7. **Salida:**

   * Listado de `OrdenCompra` coincidentes (`idOrdenCompra`, `fechaHoraEmision`, `Proveedor`, `Insumo`, `cantidadOrdenada`, `codigoUnidadMedida`, `estado`, referencia a la decisión/cotización) y referencia de la Orden seleccionada; o mensajes de las excepciones A1–A2.

8. **Precondiciones:**

   * El actor interno (`Administrador` o `Responsable de Producción`) se encuentra autenticado y autorizado.

9. **Postcondiciones:**

   * **(Sin cambios de estado en el sistema: operación de solo lectura)**.

---

## 6. Contrato de la Operación `cancelarOrdenCompra` (`UC-39` «include» `UC-40`)

1. **Nombre:** `cancelarOrdenCompra(idOrdenCompra: Long, motivoCancelacion: String, cancelacionAtribuibleProveedor: Boolean)`

2. **Responsabilidades:** Cancelar de forma trazable el saldo pendiente de recepción de una `OrdenCompra` en estado `PENDIENTE` o `PARCIALMENTE_RECIBIDA` (previamente localizada mediante `UC-40`), registrando su motivo obligatorio y si el incumplimiento es atribuible al Proveedor.

3. **Tipo:** `Sistema`

4. **Referencias cruzadas:** Caso de Uso `UC-39 — Cancelar Orden de Compra`; incluye `UC-40 — Buscar Orden de Compra`; Caso de Uso `UC-44 — Iniciar Ronda Manual de Cotización`; Objetivos `OBJE-07`, `OBJE-09`; Requisitos `RF-05`, `RF-11`.

5. **Notas:** Exclusivo del `Administrador`. Las `RecepcionCompra` y el stock ya ingresados antes de la cancelación no se revierten. Si tras cancelar la Orden el `Insumo` permanece con `stockActual < umbralMinimo`, el `EpisodioFaltante` conserva su alerta abierta para que el Administrador pueda iniciar una ronda manual mediante `UC-44` (**sin producir un nuevo disparo automático**).

6. **Excepciones:**

   * **A1 — `OrdenCompra` inexistente, ya `RECIBIDA` o ya `CANCELADA`:** Rechazar la cancelación.

   * **A2 — Falta `motivoCancelacion` obligatorio o no se indicó `cancelacionAtribuibleProveedor`:** Solicitar completar los datos antes de confirmar.

7. **Salida:**

   * Confirmación de la `OrdenCompra` en estado `CANCELADA` y aviso de alerta de stock bajo persistente cuando corresponda; o mensajes de las excepciones A1–A2.

8. **Precondiciones:**

   * El `Administrador` se encuentra autenticado y autorizado, y la `OrdenCompra` seleccionada mediante `UC-40` se encuentra en estado `PENDIENTE` o `PARCIALMENTE_RECIBIDA`.

9. **Postcondiciones:**

   * Se modificaron en la instancia `unaOrden` de `OrdenCompra` los atributos `estado = CANCELADA`, `fechaHoraCancelacion`, `motivoCancelacion` y `cancelacionAtribuibleProveedor`, asociando al `Usuario` Administrador responsable.

   * Se conservaron inalteradas las instancias previas de `RecepcionCompra`, `MovimientoInsumo` y `CostoInsumoHistorico`.

   * Si `Insumo.stockActual < Insumo.umbralMinimo`, el `EpisodioFaltante` permaneció abierto sin emitir automáticamente una nueva `SolicitudCotizacion`.

---

## 7. Contrato de la Operación `registrarIngresoStockPorCompra` (`UC-08` «extend» `UC-40`)

1. **Nombre:** `registrarIngresoStockPorCompra(tipoElemento: String, idElemento: Long, idOrdenCompra: Long[0..1], cantidadRecibida: BigDecimal, costoUnitarioCompra: BigDecimal, comprobante: String)`

2. **Responsabilidades:** Registrar la recepción física por compra de un `Insumo` o de un `Producto` de `tipoProducto = REVENTA` manteniendo separados ambos inventarios (`RD-RP022-001`), actualizando **primero la valoración histórica y luego el movimiento de entrada** (`H01`/`H02`), y actualizando el grado de cumplimiento de la `OrdenCompra` cuando se vinculó mediante la extensión `UC-40`.

3. **Tipo:** `Sistema`

4. **Referencias cruzadas:** Caso de Uso `UC-08 — Registrar Ingreso de Stock por Compra`; extendido condicionalmente por `UC-40 — Buscar Orden de Compra`; Decisión `RD-RP022-001`; Objetivos `OBJE-05`, `OBJE-07`, `OBJE-09`; Requisitos `RF-04`, `RF-05`, `RF-11`.

5. **Notas:**

   * Conforme a `RD-RP022-001`, el inventario de `Insumo` y el inventario de `Producto` `REVENTA` son independientes y nunca se mezclan.

   * En el ingreso de `Insumo`, la creación de la nueva vigencia en `CostoInsumoHistorico` (`fuenteCosto = COMPRA`) precede obligatoriamente a la creación del `MovimientoInsumo` que referencia `vigenteDesdeCosto` (`H01`).

   * En el ingreso de `Producto` `REVENTA`, se recalcula el costo promedio ponderado móvil antes de registrar el `MovimientoStockReventa` (`H06`).

6. **Excepciones:**

   * **A1 — `cantidadRecibida <= 0` o `costoUnitarioCompra <= 0`:** Rechazar la recepción sin alterar existencias ni costos.

   * **A2 — `idOrdenCompra` informada pero la Orden está `CANCELADA` o `RECIBIDA`, corresponde a otro `Insumo`, o `cantidadRecibida` supera el saldo pendiente de recepción:** Rechazar la operación.

   * **A3 — Se intenta registrar ingreso por compra sobre un `Producto` de `tipoProducto = ELABORADO`:** Rechazar la operación.

7. **Salida:**

   * Confirmación de la `RecepcionCompra` (`idRecepcion`), nuevo stock resultante, nuevo costo histórico o promedio ponderado móvil vigente y estado actualizado de la `OrdenCompra` (`PARCIALMENTE_RECIBIDA` o `RECIBIDA`) cuando aplica; o mensajes de las excepciones A1–A3.

8. **Precondiciones:**

   * El actor autorizado (`Responsable de Producción` o `Administrador`) se encuentra autenticado.

   * Existe el `Insumo` o el `Producto` con `tipoProducto = REVENTA` identificado por `idElemento` (y, si se vinculó mediante `UC-40`, existe la `OrdenCompra` en estado `PENDIENTE` o `PARCIALMENTE_RECIBIDA`).

9. **Postcondiciones:**

   * Se creó una instancia `unaRecepcion` de `RecepcionCompra` con `fechaHoraRecepcion`, `cantidadRecibida`, `costoUnitarioCompra` y `comprobante`, asociada al `Usuario` registrador y opcionalmente a la `OrdenCompra` (`0..1`).

   * **Si `tipoElemento = INSUMO` (Operando 1):**

     * Se cerró la vigencia previa y se creó **primero** una nueva instancia `nuevoCosto` de `CostoInsumoHistorico` con `vigenteDesde = fechaHoraRecepcion`, `costoUnitario = costoUnitarioCompra` y `fuenteCosto = COMPRA`, asociada a `unInsumo` y a `unaRecepcion`.

     * Se incrementó `unInsumo.stockActual` en `cantidadRecibida`.

     * Se creó **después** una instancia de `MovimientoInsumo` con `tipoMovimiento = INGRESO_COMPRA`, `cantidad = cantidadRecibida` y `stockResultante`, asociada a `unInsumo`, a `unaRecepcion` y a `nuevoCosto` (`vigenteDesdeCosto`).

     * Si estuvo asociada a `unaOrden`, se incrementó su acumulado recibido y se actualizó `unaOrden.estado` a `PARCIALMENTE_RECIBIDA` (si resta saldo) o `RECIBIDA` (si completó `cantidadOrdenada`); y si `unInsumo.stockActual >= unInsumo.umbralMinimo` sin Solicitudes ni Órdenes pendientes, se cerró el `EpisodioFaltante`.

   * **Si `tipoElemento = REVENTA` (Operando 2 — `RD-RP022-001`):**

     * Se recalculó y actualizó el costo promedio ponderado móvil del `Producto` de reventa (`CostoReventaHistorico` / `costoPromedioActualReventa`) combinando el stock previo valorizado y la nueva entrada `cantidadRecibida * costoUnitarioCompra`.

     * Se incrementó `Producto.stockActualReventa` en `cantidadRecibida`.

     * Se creó una instancia de `MovimientoStockReventa` con `tipoMovimiento = INGRESO_COMPRA`, `cantidad = cantidadRecibida`, `stockResultante` y costo asociado a `unaRecepcion`.

---

## 8. Glosario de Términos Asociados (`REV-03B`)

* **`Proveedor` (Tipo / Concepto — Tabla `PROVEEDOR`):** Entidad comercial externa identificada por su `cuit` normalizado único, con `razonSocial`, datos de contacto y `estado` (`ACTIVO` \| `INACTIVO`).

* **`ProveedorInsumo` (Tipo / Concepto — Tabla `PROVEEDOR*_INSUMO`):** Relación histórica con intervalo `[vigenteDesde, vigenteHasta)` que acredita qué `Insumo` suministra un `Proveedor`.***

** **`OrdenCompra` (Tipo / Concepto — Tabla `ORDEN_COMPRA`):** Compromiso formal de compra emitido en `UC-12` con `cantidadOrdenada`, `precioUnitarioAcordado` y estados `PENDIENTE`, `PARCIALMENTE_RECIBIDA`, `RECIBIDA` o `CANCELADA`.***

** **`RecepcionCompra` (Tipo / Concepto — Tabla `RECEPCION_COMPRA`):** Registro de ingreso físico de mercadería comprada, vinculable opcionalmente a una `OrdenCompra`.***

** **`CostoInsumoHistorico` (Tipo / Concepto — Tabla `COSTO_INSUMO_HISTORICO`):** Vigencia histórica del costo unitario de un `Insumo` (`SALDO_INICIAL` o `COMPRA`), que precede y respalda todo `MovimientoInsumo`.***
