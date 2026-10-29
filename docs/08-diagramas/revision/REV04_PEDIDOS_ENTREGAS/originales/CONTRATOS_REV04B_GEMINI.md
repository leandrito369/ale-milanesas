# Contratos de Operación del Sistema (DSS — REV-04B) — Preparación, Entrega, Cancelación y Excedentes (7 Contratos Individuales)

**Proyecto:** Sistema de Gestión para Ale Milanesas (UNaM-FCEQyN)  

**Lote de revisión:** `REV-04B` (`UC-28`, `UC-05`, `UC-06`, `UC-61`, `UC-07` desagrupado en Oferta y Respuesta, `UC-41`)  

**Decisiones incorporadas:** `RD-F04-001..007` y `RD-RP004/RP028` (`H-03`, `H-09`: declaración de efectivo recibido por el Repartidor bajo `UC-05` como **efectivo en tránsito validado** y validación en servidor para operación offline bajo «El Reparto Manda»), más relaciones `include` aprobadas el 25/10/2026 (`UC-07→UC-61` y `UC-41→UC-61`).

---

## 1. Contrato de la Operación `registrarPreparacionPedido` (`UC-28` «include» `UC-34`)

1. **Nombre:** `registrarPreparacionPedido(idPedido: Long, idProducto: Long, cantidadPreparada: BigDecimal)`

2. **Responsabilidades:** Registrar la producción propia de un `Producto` de `tipoProducto = ELABORADO` para un `Pedido` `PENDIENTE` (localizado mediante `UC-34`), verificando que la preparación propia acumulada no supere la `cantidadOriginal` solicitada, escalando proporcionalmente la `VersionReceta` vigente, descontando las existencias de cada `Insumo`, congelando sus costos históricos y evaluando el proceso `PRA-01`.

3. **Tipo:** `Sistema`

4. **Referencias cruzadas:** Caso de Uso `UC-28 — Registrar Preparación de Pedido`; incluye `UC-34 — Buscar Pedido`; Proceso `PRA-01`; Objetivo `OBJE-07`; Requisitos `RF-04`, `RF-05`, `RF-21`.

5. **Notas:** Las cantidades adicionales recibidas por reasignación de Excedentes (`UC-07`) **no reducen** el límite de preparación propia (`cantidadOriginal - cantidadPreparadaPropiaAcumulada`) ni vuelven a prepararse. Prohibido utilizar costo cero si falta fuente de costo histórico válida.

6. **Excepciones:**

   * **A1 — `Pedido` no `PENDIENTE`:** Impedir el registro de preparación.

   * **A2 — `cantidadPreparada <= 0` o `cantidadPreparadaPropiaAcumulada \+ cantidadPreparada > cantidadOriginal`:** Solicitar corrección sin registrar preparación.

   * **A3 — No existe `VersionReceta` aplicable válida o el Producto es de tipo `REVENTA`:** Bloquear la operación.

   * **A4 — Stock disponible insuficiente en algún `Insumo` o falta de fuente válida de `CostoInsumoHistorico`:** Rechazar atómicamente la preparación sin descontar stock parcial.

7. **Salida:**

   * Confirmación de la `Preparacion` registrada (`idPreparacion`), consumos de `Insumo`, costos históricos congelados y stock resultante; o mensajes de las excepciones A1–A4.

8. **Precondiciones:**

   * El `Responsable de Producción` se encuentra autenticado y autorizado.

   * El `Pedido` seleccionado mediante `UC-34` está en estado `PENDIENTE`, el `Producto` es `ELABORADO` con preparación propia pendiente y posee `VersionReceta` vigente.

9. **Postcondiciones:**

   * Se creó una instancia `unaPreparacion` de `Preparacion` con `cantidadPreparada` y `fechaHoraPreparacion`, asociada al `DetallePedido` y a la `VersionReceta` aplicada.

   * Para cada `DetalleVersionReceta` de la versión aplicada, se decrementó `Insumo.stockActual` y se creó una instancia de `MovimientoInsumo` (`CONSUMO_PRODUCCION`) asociada a `unaPreparacion`, al `Insumo` y al `CostoInsumoHistorico` vigente (`vigenteDesdeCosto`).

   * Si algún `Insumo` quedó con `stockActual < umbralMinimo` y `automatizacionCompraActiva = true`, se activó la evaluación de `PRA-01`.

---

## 2. Contrato de la Operación `registrarEntrega` (`UC-05` «include» `UC-34`, `UC-15`)

1. **Nombre:** `registrarEntrega(idPedido: Long, detallesEntrega: List<ItemEntregaDTO>, efectivoDeclaradoRecibido: BigDecimal[0..1], claveIdempotencia: UUID)`

2. **Responsabilidades:** Registrar de forma definitiva e idempotente las cantidades efectivamente entregadas de un `Pedido` `PENDIENTE` asignado al `Repartidor` autenticado (localizado mediante `UC-34`), imputando comercialmente primero las unidades originales y luego las adicionales aceptadas (`UC-07`), descontando stock `REVENTA`, generando `Excedente` por los productos elaborados disponibles no entregados, registrando el `CARGO_POR_VENTA` efectivo en Cuenta Corriente, ejecutando `UC-15` y **registrando la declaración de efectivo recibido por el Repartidor como efectivo en tránsito validado (`RD-F04` / `RD-RP028`)**.

3. **Tipo:** `Sistema`

4. **Referencias cruzadas:** Caso de Uso `UC-05 — Registrar Entrega`; incluye `UC-34 — Buscar Pedido` y `UC-15 — Evaluar y Actualizar Categoría Comercial`; Decisiones `RD-F04-001..007` y `RD-RP004/RP028` (`H-03`, `H-09`); Objetivos `OBJE-01`, `OBJE-05`, `OBJE-10`, `OBJE-14`; Requisitos `RF-02`, `RF-04`, `RF-06`, `RF-13`, `RF-19`.

5. **Notas:**

   * **Efectivo en tránsito (`RD-F04` / `RD-RP028`):** El Repartidor **no ejecuta `UC-29 — Registrar Cobro`**. Cuando el Cliente entrega dinero en efectivo al Repartidor durante el reparto, el monto informado en `efectivoDeclaradoRecibido` queda registrado como **efectivo/pago en tránsito validado**: reduce el **saldo exigible provisional** consultable en `UC-14`, pero no modifica el **saldo confirmado** de Cuenta Corriente ni genera `Cobro` ni `MovimientoCaja` (`INGRESO`) hasta su rendición y registración mediante `UC-29` por Vendedor o Administrador.

   * **Operación offline y «El Reparto Manda» (`RD-F04`):** Si la entrega se ejecutó en modo offline dentro de una sesión y asignación válidas, al sincronizar con el servidor se reconcilia idempotentemente mediante `claveIdempotencia` respetando el snapshot comercial congelado («El Reparto Manda»).

6. **Excepciones:**

   * **A1 — `Pedido` no `PENDIENTE` o sin asignación válida al Repartidor autenticado:** Rechazar el registro de la entrega.

   * **A2 — Cantidades negativas, todas iguales a cero, superiores al límite comercial (`cantidadOriginal \+ adicionalesAceptados`) o `efectivoDeclaradoRecibido < 0`:** Solicitar corrección sin confirmar.

   * **A3 — Cantidad entregada superior a la disponibilidad física (`ELABORADO` preparado/reasignado o stock `REVENTA`):** Impedir la confirmación.

   * **A4 — Falta de valoración válida de costo histórico en `ELABORADO` o `REVENTA`:** No utilizar costo cero; bloquear o marcar para regularización.

   * **A5 — `claveIdempotencia` ya procesada en sincronización previa (`RD-F04`):** Reconocer la `Entrega` existente sin duplicar cargos, salidas de stock, Excedentes ni efectivo en tránsito.

7. **Salida:**

   * Confirmación de la `Entrega` definitiva (`idEntrega`), importe efectivo cargado en Cuenta Corriente, monto de `efectivoDeclaradoRecibido` registrado en tránsito y detalle de `Excedente` generados; o mensajes de las excepciones A1–A5.

8. **Precondiciones:**

   * El `Repartidor` se encuentra autenticado y autorizado, y el `Pedido` identificado por `idPedido` está en estado `PENDIENTE` con asignación vigente a ese Repartidor (o respaldado por un snapshot offline válido según `RD-F04`).

9. **Postcondiciones:**

   * Se creó una única instancia `unaEntrega` de `Entrega` (y sus `DetalleEntrega` e `ImputacionEntregaAdicional`) asociada al `Pedido` y al `Repartidor`, con `fechaHoraEntrega` e `importeEfectivoVenta`.

   * Si `efectivoDeclaradoRecibido > 0`, se registró en `unaEntrega` / registro de tránsito el importe de **efectivo en tránsito validado** atribuido al `Repartidor` y al `Cliente` (`RD-F04` / `RD-RP028`), sin crear instancias de `Cobro` ni de `MovimientoCaja`.

   * Para cada ítem de `Producto` `REVENTA` entregado, se decrementó `Producto.stockActualReventa` y se creó una instancia de `MovimientoStockReventa` (`EGRESO_VENTA`) con su costo histórico congelado.

   * Para cada ítem de `Producto` `ELABORADO` con sobrante físico disponible no entregado, se creó una instancia de `Excedente` en estado `DISPONIBLE` (`origenGeneracion = ENTREGA`) conservando su costo histórico.

   * Se creó una instancia de `MovimientoCuenta` de tipo `CARGO_POR_VENTA` por el importe efectivo entregado (imputando primero unidades originales y luego adicionales aceptadas en `UC-07` por orden cronológico), actualizando el **saldo confirmado** de Cuenta Corriente y el **saldo exigible provisional** (descontando los pagos en tránsito validados).

   * Se ejecutaron las postcondiciones de `UC-15` y se modificó `unPedido.estado` a `ENTREGADO`.

---

## 3. Contrato de la Operación `cancelarPedido` (`UC-06` «include» `UC-34`, «extend» `UC-26`)

1. **Nombre:** `cancelarPedido(idPedido: Long, motivoCancelacion: String)`

2. **Responsabilidades:** Cancelar un `Pedido` en estado `PENDIENTE` (localizado mediante `UC-34`) registrando su motivo obligatorio, preservar como `Excedente` toda cantidad de Producto `ELABORADO` ya preparada o reasignada para dicho Pedido y activar por extensión condicional `UC-26` únicamente cuando exista un `Cobro` electrónico reembolsable.

3. **Tipo:** `Sistema`

4. **Referencias cruzadas:** Caso de Uso `UC-06 — Cancelar Pedido`; incluye `UC-34 — Buscar Pedido`; extendido condicionalmente por `UC-26 — Procesar Reembolso Electrónico`; Objetivos `OBJE-01`, `OBJE-05`, `OBJE-13`; Requisitos `RF-01`, `RF-13`, `RF-20`.

5. **Notas:** No revierte consumos de Insumos (`CONSUMO_PRODUCCION`). Si el Pedido tenía un Cobro manual previo, dicho monto permanece como saldo a favor en Cuenta Corriente sin salida automática de Caja.

6. **Excepciones:**

   * **A1 — `Pedido` ya `ENTREGADO` o `CANCELADO`:** Impedir cancelar nuevamente.

   * **A2 — `motivoCancelacion` ausente o vacío:** Solicitar el motivo obligatorio antes de confirmar.

7. **Salida:**

   * Confirmación del `Pedido` en estado `CANCELADO`, detalle de `Excedente` preservados y estado del eventual inicio de reembolso electrónico (`UC-26`); o mensajes de las excepciones A1–A2.

8. **Precondiciones:**

   * El actor interno autorizado se encuentra autenticado y el `Pedido` seleccionado mediante `UC-34` está en estado `PENDIENTE`.

9. **Postcondiciones:**

   * Se modificaron `unPedido.estado` a `CANCELADO`, `unPedido.motivoCancelacion` y `unPedido.fechaHoraCancelacion`.

   * Para cada `Producto` `ELABORADO` del Pedido que poseía unidades disponibles (preparadas en `UC-28` o recibidas en `UC-07`), se creó una instancia de `Excedente` en estado `DISPONIBLE` (`origenGeneracion = CANCELACION`) conservando su costo histórico ponderado.

   * Si existía un `Cobro` electrónico reembolsable asociado a `unPedido`, se invocó por extensión `UC-26`.

---

## 4. Contrato de la Operación `buscarExcedente` (`UC-61`)

1. **Nombre:** `buscarExcedente(idProducto: Long[0..1], idPedidoOrigen: Long[0..1], fechaGeneracion: LocalDate[0..1], soloDisponibles: Boolean)`

2. **Responsabilidades:** Consultar y presentar los `Excedente` de Productos `ELABORADO` distinguiendo los remanentes disponibles (`cantidadDisponible > 0`) de los agotados (`cantidadDisponible = 0`), y devolver la referencia seleccionada al caso de uso invocante (`UC-07` o `UC-41`) sin reservar ni modificar existencias.

3. **Tipo:** `Sistema`

4. **Referencias cruzadas:** Caso de Uso `UC-61 — Buscar Excedente`; incluido por `UC-07 — Ofrecer y Reasignar Excedente` y `UC-41 — Registrar Descarte de Excedente` *(relaciones aprobadas el 25/10/2026)*; Objetivo `OBJE-05`; Requisito `RF-13`.

5. **Notas:** Operación estrictamente de solo lectura. No reserva saldo ni expone costos internos restringidos al Vendedor.

6. **Excepciones:**

   * **A1 — Criterios inválidos o Producto no `ELABORADO`:** Solicitar corrección sin ejecutar cambios.

   * **A2 — Sin coincidencias:** Informar lista vacía.

   * **A3 — Selección de un Excedente con `cantidadDisponible = 0` para consumo comercial o descarte:** Informar indisponibilidad operativa.

7. **Salida:**

   * Listado de `Excedente` coincidentes (`idExcedente`, `Producto` `ELABORADO`, `idPedidoOrigen`, `fechaHoraGeneracion`, `cantidadInicial`, `cantidadDisponible`) y referencia seleccionada; o mensajes de las excepciones A1–A3.

8. **Precondiciones:**

   * El actor (`Vendedor` o `Responsable de Producción`) se encuentra autenticado y autorizado.

9. **Postcondiciones:**

   * *(Sin cambios de estado en el sistema: `Excedente.cantidadDisponible` y los movimientos históricos permanecen inalterados)*.

---

## 5. Contrato de la Operación `registrarOfertaExcedente` (`UC-07` — Parte A, «include» `UC-61`)

1. **Nombre:** `registrarOfertaExcedente(idExcedente: Long, idPedidoReceptor: Long, cantidadOfrecida: BigDecimal)`

2. **Responsabilidades:** Registrar una propuesta comercial (`OfertaExcedente`) para destinar una `cantidadOfrecida` de un `Excedente` disponible (previamente localizado mediante `UC-61`) a un `Pedido` receptor candidato en estado `PENDIENTE`, calculando el `importeInformado` sin reservar existencias ni modificar el Pedido receptor.

3. **Tipo:** `Sistema`

4. **Referencias cruzadas:** Caso de Uso `UC-07 — Ofrecer y Reasignar Excedente`; incluye `UC-61 — Buscar Excedente` *(relación aprobada el 25/10/2026)*; Objetivo `OBJE-05`; Requisito `RF-13`.

5. **Notas:** Se separa como contrato individual (`H-11`) porque el registro de la oferta aún no transfiere unidades ni descuenta `Excedente.cantidadDisponible`.

6. **Excepciones:**

   * **A1 — `Excedente` sin disponibilidad (`cantidadDisponible <= 0`) o `cantidadOfrecida <= 0` o superior a `cantidadDisponible`:** Rechazar la oferta.

   * **A2 — `Pedido` receptor no `PENDIENTE` o sin `PrecioProducto` vigente válido para calcular el importe:** Impedir el registro de la oferta.

7. **Salida:**

   * Confirmación de la `OfertaExcedente` registrada (`idOfertaExcedente`) y del `importeInformado` al Cliente; o mensajes de las excepciones A1–A2.

8. **Precondiciones:**

   * El `Vendedor` se encuentra autenticado y autorizado, el `Excedente` seleccionado mediante `UC-61` está `DISPONIBLE` con `cantidadDisponible > 0` y el `Pedido` receptor está `PENDIENTE`.

9. **Postcondiciones:**

   * Se creó una instancia `unaOferta` de `OfertaExcedente` con `cantidadOfrecida`, `importeInformado`, `fechaHoraOferta` y respuesta pendiente, asociada al `Excedente`, al `Pedido` receptor y al `Usuario` Vendedor.

   * Se conservaron inalterados `Excedente.cantidadDisponible` y el `Pedido` receptor.

---

## 6. Contrato de la Operación `registrarRespuestaOfertaExcedente` (`UC-07` — Parte B, «include» `UC-61`)

1. **Nombre:** `registrarRespuestaOfertaExcedente(idOfertaExcedente: Long, aceptada: Boolean, cantidadAceptada: BigDecimal[0..1])`

2. **Responsabilidades:** Registrar la respuesta del Cliente a una `OfertaExcedente` y, cuando es aceptada, revalidar disponibilidad bajo control de concurrencia, incorporar las unidades aceptadas como adicionales al `Pedido` receptor con su `importeAceptado` (sin alterar `cantidadOriginal` ni `totalOriginal` y sin volver a preparar ni ejecutar `UC-15`/`UC-16`), transferir el costo histórico mediante `MovimientoExcedente` (`REASIGNACION`) y descontar `Excedente.cantidadDisponible`.

3. **Tipo:** `Sistema`

4. **Referencias cruzadas:** Caso de Uso `UC-07 — Ofrecer y Reasignar Excedente`; incluye `UC-61 — Buscar Excedente` *(relación aprobada el 25/10/2026)*; Objetivo `OBJE-05`; Requisito `RF-13`.

5. **Notas:** Si `cantidadAceptada` cambia respecto de `cantidadOfrecida`, se recalcula el importe y se exige aceptación del nuevo importe antes de confirmar.

6. **Excepciones:**

   * **A1 — `aceptada == false` (Rechazo del Cliente):** Registrar la respuesta rechazada en `OfertaExcedente` sin transferir unidades ni modificar `Excedente.cantidadDisponible`.

   * **A2 — `cantidadAceptada <= 0`, superior a `Excedente.cantidadDisponible` actual (por concurrencia) o importe recalculado sin nueva aceptación:** Rechazar la confirmación de transferencia.

   * **A3 — El `Pedido` receptor dejó de estar `PENDIENTE` o el costo histórico no es determinable:** Impedir la transferencia parcial.

7. **Salida:**

   * Confirmación de la reasignación trazable, nuevo `totalVigente` derivado del `Pedido` receptor y estado resultante del `Excedente` (`DISPONIBLE` o `AGOTADO`); o constancia de rechazo / mensajes de las excepciones A1–A3.

8. **Precondiciones:**

   * El `Vendedor` se encuentra autenticado y autorizado, y existe la `OfertaExcedente` pendiente de resolución.

9. **Postcondiciones:**

   * **Si `aceptada == true`:**

     * Se modificaron en `unaOferta` los atributos de respuesta aceptada, `cantidadAceptada`, `importeAceptado` y `fechaHoraRespuesta`.

     * Se incorporaron las unidades adicionales y su `importeAceptado` al `Pedido` receptor sin modificar `DetallePedido.cantidadOriginal`, `Pedido.totalOriginal`, Promoción original ni ajuste comercial global, permitiendo derivar `Pedido.totalVigente`.

     * Se creó una instancia de `MovimientoExcedente` con `tipoMovimiento = REASIGNACION`, `cantidad = cantidadAceptada`, `costoHistoricoSalida` proporcional y `fechaHoraMovimiento`, asociada a `unExcedente` y a `unaOferta`.

     * Se decrementó `unExcedente.cantidadDisponible` en `cantidadAceptada` y se actualizó su estado a `DISPONIBLE` (si `> 0`) o `AGOTADO` (si `= 0`).

   * **Si `aceptada == false`:**

     * Se modificó `unaOferta` registrando el rechazo y su `fechaHoraRespuesta`, conservando intactos `unExcedente.cantidadDisponible` y el `Pedido` receptor.

---

## 7. Contrato de la Operación `registrarDescarteExcedente` (`UC-41` «include» `UC-61`)

1. **Nombre:** `registrarDescarteExcedente(idExcedente: Long, cantidadDescartada: BigDecimal, motivoDescarte: String)`

2. **Responsabilidades:** Registrar un `MovimientoExcedente` de tipo `DESCARTE` sobre un `Excedente` disponible (previamente localizado mediante `UC-61`) con su motivo obligatorio y su costo histórico proporcional, reduciendo atómicamente `Excedente.cantidadDisponible`.

3. **Tipo:** `Sistema`

4. **Referencias cruzadas:** Caso de Uso `UC-41 — Registrar Descarte de Excedente`; incluye `UC-61 — Buscar Excedente` *(relación aprobada el 25/10/2026)*; Objetivos `OBJE-05`, `OBJE-07`; Requisito `RF-13`.

5. **Notas:** No revierte la `Preparacion` histórica ni reintegra `Insumo` al inventario.

6. **Excepciones:**

   * **A1 — `cantidadDescartada <= 0` o superior a `Excedente.cantidadDisponible` actual (por concurrencia):** Solicitar corrección sin registrar descarte parcial.

   * **A2 — `motivoDescarte` ausente o vacío:** Impedir confirmar el descarte.

   * **A3 — Costo histórico no determinable:** Rechazar la operación sin inventar costo cero.

7. **Salida:**

   * Confirmación del descarte registrado (`idMovimiento`), cantidad remanente, estado del `Excedente` (`DISPONIBLE` \| `AGOTADO`), motivo y costo histórico trazado; o mensajes de las excepciones A1–A3.

8. **Precondiciones:**

   * El `Responsable de Producción` se encuentra autenticado y autorizado, y existe el `Excedente` `DISPONIBLE` seleccionado mediante `UC-61` con `cantidadDisponible > 0`.

9. **Postcondiciones:**

   * Se creó una instancia de `MovimientoExcedente` con `tipoMovimiento = DESCARTE`, `cantidad = cantidadDescartada`, `motivoDescarte`, `costoHistoricoSalida` proporcional y `fechaHoraMovimiento`, asociada a `unExcedente`.

   * Se decrementó `unExcedente.cantidadDisponible` en `cantidadDescartada` y se redujo proporcionalmente `unExcedente.costoHistoricoDisponible`.

   * Si `unExcedente.cantidadDisponible == 0`, su estado quedó en `AGOTADO`; si permaneció `> 0`, quedó en `DISPONIBLE`.

---

## 8. Glosario de Términos Asociados (`REV-04B`)

* **`Entrega` (Tipo / Concepto — Tabla `ENTREGA`):** Registro definitivo de las cantidades entregadas al Cliente en `UC-05` que origina el `CARGO_POR_VENTA` efectivo en Cuenta Corriente.

* **`Efectivo en Tránsito Validado` (Concepto de Dominio — `RD-F04` / `RD-RP028`):** Importe en efectivo declarado por el `Repartidor` al registrar la `Entrega` (`UC-05`) que reduce el saldo exigible provisional del Cliente (`UC-14`), pero que no constituye un `Cobro` confirmado (`UC-29`) ni ingresa en `Caja` hasta su rendición formal ante Vendedor o Administrador.

* **`Excedente` (Tipo / Concepto — Tabla `EXCEDENTE`):** Remanente trazable de un Producto `ELABORADO` ya preparado originado por entrega parcial (`UC-05`) o cancelación (`UC-06`), con estado `DISPONIBLE` o `AGOTADO`.

* **`OfertaExcedente` (Tipo / Concepto — Tabla `OFERTA_EXCEDENTE`):** Propuesta comercial registrada en `UC-07` para ofrecer unidades de un `Excedente` a un `Pedido` receptor en estado `PENDIENTE`.

* **`MovimientoExcedente` (Tipo / Concepto — Tabla `MOVIMIENTO_EXCEDENTE`):** Salida trazable de un `Excedente` por `REASIGNACION` (`UC-07`) o por `DESCARTE` (`UC-41`) que conserva el costo histórico proporcional afectado.
