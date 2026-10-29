> **Versión consolidada B0 — REV-05, 29/10/2026.** Archivo derivado de la propuesta del commit `64af3c3baa571c2d512242e396267a31f0da3efd`; no reemplaza el original REV. Se aplicaron exclusivamente RD-B0-BC01/02/03 y referencias editoriales BC-04. No constituye integración aprobada de PR #10–#19 ni prueba ejecutada.

Este archivo contiene los **8 Contratos individuales desagrupados** (`UC-14`, `registrarCobro` de `UC-29`, `anularCobroManual` de `UC-29`, `UC-22`, `UC-23`, `UC-26`, `UC-49`, y `UC-27`) con las **9 secciones estándar**, firmas 100% homologadas y aplicación estricta de `RD-RP004/RP028-001` (`H-03`, `H-04`) y `RD-F01` (`H-10`):

# Contratos de Operación del Sistema (DSS — REV-05) — Finanzas y Consultas (8 Contratos Individuales)

**Proyecto:** Sistema de Gestión para Ale Milanesas (UNaM-FCEQyN)  

**Lote de revisión:** `REV-05` (`UC-14`, `UC-29` alta y anulación manual, `UC-22`, `UC-23`, `UC-26`, `UC-49`, `UC-27`)  

**Decisiones incorporadas:** `RD-RP004/RP028-001` (`H-03` en `UC-14`: diferenciación de `saldoConfirmado`, `pagosEnTransitoValidados` y `saldoExigibleProvisional`; `H-04` en `UC-27`: consulta de margen bruto por período y por venta individual), `RD-F01` (`H-10` en `UC-29`: `COBRO.estadoCobro` restringido a `CONFIRMADO` y `ANULADO` y reversión por contraasiento) y desagrupamiento total de contratos (`H-11`).

---

## 1. Contrato de la Operación `consultarCuentaCorriente` (`UC-14` «include» `UC-33`)

1. **Nombre:** `consultarCuentaCorriente(idCliente: Long, fechaDesde: LocalDate[0..1], fechaHasta: LocalDate[0..1])`

2. **Responsabilidades:** Recuperar y presentar en modo solo lectura para un `Cliente` (localizado mediante `UC-33`) su **saldo confirmado**, los **pagos en tránsito validados** (declarados en `UC-05`, **sincronizados y aceptados por el servidor**, pendientes de rendición o conciliación conforme RD-F04-005) y el **saldo exigible provisional** (`RD-RP004/RP028-001`), junto con el historial completo o filtrado por período de sus `MovimientoCuenta`.

3. **Tipo:** `Sistema`

4. **Referencias cruzadas:** Caso de Uso `UC-14 — Consultar Cuenta Corriente`; incluye `UC-33 — Buscar Cliente`; Caso de Uso `UC-05 — Registrar Entrega`; Decisiones `RD-RP004/RP028-001` y `RD-F04` (`H-03`); Objetivo `OBJE-10`; Requisito `RF-06`.

5. **Notas:** Operación estrictamente de solo lectura. El pago en tránsito sigue fuera de `COBRO`, `MOVIMIENTO_CUENTA` y `MOVIMIENTO_CAJA` hasta rendición autorizada; en las 60 tablas vigentes no hay persistencia física aprobada para el concepto. La proyección no reconoce capturas solo locales y no debe aplicar dos veces un pago al convertirse en Cobro definitivo. Un faltante pendiente de conciliación no restaura automáticamente la deuda del Cliente (RD-F04-005). Filtrar el historial de movimientos por un rango `[fechaDesde, fechaHasta]` restringe únicamente las filas exhibidas en pantalla y **mantiene inalterados `saldoConfirmado`, `pagosEnTransitoValidados` y `saldoExigibleProvisional`**.

6. **Excepciones:**

   * **A1 — `Cliente` no encontrado:** Solicitar repetir la búsqueda mediante `UC-33`.

   * **A2 — Cuenta sin movimientos o con saldo a favor:** Mostrar explícitamente la condición verificable (`saldoConfirmado = 0` o saldo a favor) sin inventar deuda.

   * **A3 — Rango de fechas inválido (`fechaDesde > fechaHasta`) o permiso insuficiente:** Solicitar corrección o rechazar el acceso sin exponer datos erróneos.

7. **Salida:**

   * `saldoConfirmado` (deudor o a favor), `pagosEnTransitoValidados` (efectivo declarado en `UC-05`, sincronizado y validado por servidor, pendiente de rendición/conciliación en `UC-29` bajo autorización del Administrador), `saldoExigibleProvisional = saldoConfirmado - pagosEnTransitoValidados` e historial de `MovimientoCuenta` con sus orígenes; o mensajes de las excepciones A1–A3.

8. **Precondiciones:**

   * El actor autorizado (`Vendedor`, exclusivamente conforme a Fase 4 y `RD-B0-BC01`) se encuentra autenticado y el `Cliente` fue identificado mediante `UC-33`.

9. **Postcondiciones:**

   * *(Sin cambios de estado en el sistema: no se generan instancias de `Cobro`, `MovimientoCuenta` ni `MovimientoCaja`)*.

---

## 2. Contrato de la Operación `registrarCobro` (`UC-29` — Alta de Cobro, «include» `UC-15`)

1. **Nombre:** `registrarCobro(idCliente: Long, idPedido: Long[0..1], importe: BigDecimal, medioPago: String, origen: String, referenciaExterna: String[0..1])`

2. **Responsabilidades:** Registrar de manera atómica e idempotente un `Cobro` con `estadoCobro = CONFIRMADO` (`RD-F01`) recibido de un `Cliente` (manualmente por Vendedor/Administrador o electrónicamente por `MercadoPago` en `UC-21`), acreditar el `PAGO` en `MovimientoCuenta` (conciliando el efectivo en tránsito validado cuando corresponde a la rendición de un reparto de `UC-05`), registrar el `INGRESO` en `MovimientoCaja` y ejecutar `UC-15`.

3. **Tipo:** `Sistema`

4. **Referencias cruzadas:** Caso de Uso `UC-29 — Registrar Cobro`; incluye `UC-15 — Evaluar y Actualizar Categoría Comercial`; Decisiones `RD-F01`, `RD-F04` y `RD-RP028` (`H-10`); Objetivos `OBJE-10`, `OBJE-12`; Requisitos `RF-06`, `RF-09`, `RF-12`.

**Adenda B0-BC05 (referencias canónicas de Fase 4):** RF-06,RF-15,RF-20. Referencias contenidas en el contrato anterior: RF-06,RF-09,RF-12. Esta adenda complementa/rectifica la trazabilidad del apartado 4, sin incorporar requisitos, pre/postcondiciones, roles ni operaciones nuevos. Cualquier dependencia transversal se identifica en el contrato del CU invocado.

5. **Notas:** El cobro manual general puede ser registrado por **Administrador o Vendedor** conforme permisos ratificados, pero la **rendición de efectivo de un Repartidor al cierre del recorrido** es recibida, verificada y autorizada **exclusivamente por el Administrador** (RD-F04-002); una diferencia permanece **pendiente de conciliación** y no confirma Cobro por dinero no recibido. El Repartidor no ejecuta `UC-29`. `Cobro.estadoCobro` solo admite `CONFIRMADO` y `ANULADO` (RD-F01). El reconocimiento de pago en tránsito se retira atómicamente al contabilizar el definitivo, para evitar doble reducción del exigible. La idempotencia general necesita `claveIdempotenciaOrigen`/referencias del esquema y controles de servicio; la firma pública por sí sola no certifica su ejecución.

6. **Excepciones:**

   * **A1 — `importe <= 0` o `medioPago` inválido:** Rechazar el registro del Cobro.

   * **A2 — Se informó `idPedido` pero el Pedido no pertenece al `Cliente` o se encuentra `CANCELADO`:** Rechazar la operación sin registrar el Cobro.

   * **A3 — `referenciaExterna` de pago electrónico ya procesada previamente:** Reconocer el `Cobro` existente por idempotencia sin duplicar movimientos en Caja ni en Cuenta Corriente.

7. **Salida:**

   * Confirmación del `Cobro` (`idCobro`, `estadoCobro = CONFIRMADO`), nuevo `saldoConfirmado` de Cuenta Corriente y `categoriaComercial` resultante tras ejecutar `UC-15`; o mensajes de las excepciones A1–A3.

8. **Precondiciones:**

   * El actor autorizado (`Vendedor` o `Administrador`, o el flujo verificado de `UC-21`) se encuentra autenticado y existe el `Cliente` identificado por `idCliente`.

9. **Postcondiciones:**

   * Se creó una instancia `unCobro` de `Cobro` con `fechaHoraCobro`, `importe`, `medioPago`, `origen` (`MANUAL` | `ONLINE`), `referenciaExterna` y `estadoCobro = CONFIRMADO` (`RD-F01`), asociada al `Cliente`, al `Usuario` registrador y opcionalmente al `Pedido` (`0..1`).

   * Se creó una instancia de `MovimientoCuenta` de tipo `PAGO` por `importe` (y su `OrigenMovimientoCuenta` vinculado a `unCobro`), actualizando el `saldoConfirmado` del `Cliente` (retirando el efecto provisional del importe realmente rendido, **solo tras validación y autorización del Administrador**, y dejando diferencias pendientes de conciliación sin asientos por efectivo no recibido).

   * Se creó una instancia de `MovimientoCaja` de `tipoMovimiento = INGRESO` y `origen = COBRO` asociada a `unCobro`.

   * Se ejecutaron las postcondiciones de `UC-15` (reevaluación y eventual actualización de `Cliente.categoriaComercial`).

---

## 3. Contrato de la Operación `anularCobroManual` (`UC-29` — Reversión por Contraasiento, «include» `UC-15`)

1. **Nombre:** `anularCobroManual(idCobro: Long, motivoAnulacion: String)`

2. **Responsabilidades:** Revertir de manera trazable un `Cobro` de `origen = MANUAL` que se encontraba en `estadoCobro = CONFIRMADO`, cambiando su estado a `ANULADO` y generando los contraasientos compensatorios en `MovimientoCuenta` y `MovimientoCaja` enlazados mediante `idCobroAnulado` (`RD-F01` / `MR1-33`), seguidos de la reevaluación de `UC-15`.

3. **Tipo:** `Sistema`

4. **Referencias cruzadas:** Caso de Uso `UC-29 — Registrar Cobro`; incluye `UC-15 — Evaluar y Actualizar Categoría Comercial`; Decisiones `RD-F01` (`H-10`), `RD-RP007-001` y `RD-B0-BC03`; Objetivos `OBJE-10`, `OBJE-12`; Requisitos de UC-29 `RF-06`, `RF-15`, `RF-20`; `RF-12` como referencia complementaria por la ejecución interna de UC-15. La referencia original `RF-09` se conserva en el registro de correcciones BC-05, no como requisito vigente de esta operación.

**Adenda B0-BC05 (referencias canónicas de Fase 4):** RF-06,RF-15,RF-20. Referencias contenidas en el contrato anterior: RF-06,RF-09. Esta adenda complementa/rectifica la trazabilidad del apartado 4, sin incorporar requisitos, pre/postcondiciones, roles ni operaciones nuevos. Cualquier dependencia transversal se identifica en el contrato del CU invocado.

5. **Notas:** Se trata de una **segunda operación pública independiente dentro del UC-29**, no de un paso opcional inmediatamente posterior a cada alta. Exige autorización comprobada en servidor y motivo, contraasientos trazables e idempotencia. Nunca se elimina físicamente un `Cobro` ni sus movimientos originales. Los cobros electrónicos (`origen = ONLINE`) no se anulan por esta vía sino mediante el circuito de reembolso electrónico (`UC-26` / `UC-49`).

6. **Excepciones:**

   * **A1 — `Cobro` inexistente, de `origen = ONLINE` o ya en `estadoCobro = ANULADO`:** Rechazar la anulación manual.

   * **A2 — `motivoAnulacion` ausente o vacío:** Exigir el motivo obligatorio antes de confirmar.

7. **Salida:**

   * Confirmación del `Cobro` en `estadoCobro = ANULADO`, identificadores de los contraasientos generados y nuevo `saldoConfirmado` del Cliente; o mensajes de las excepciones A1–A2.

8. **Precondiciones:**

   * El actor autorizado (`Administrador`, exclusivamente conforme a `RD-B0-BC03`) está autenticado y existe el `Cobro` manual con `estadoCobro = CONFIRMADO`. El `Vendedor` no está autorizado a ejecutar la anulación.

9. **Postcondiciones:**

   * Se modificó el atributo `unCobro.estadoCobro` a `ANULADO` (`RD-F01`).

   * Se creó una instancia de `MovimientoCuenta` de contraasiento (`ANULACION_COBRO`) por `unCobro.importe` vinculada en `OrigenMovimientoCuenta` mediante `idCobroAnulado = unCobro.idCobro`, recomponiendo el `saldoConfirmado` del `Cliente`.

   * Se creó una instancia de `MovimientoCaja` (`tipoMovimiento = EGRESO`) vinculada mediante `idCobroAnulado = unCobro.idCobro` con `motivoAnulacion`.

   * Se ejecutaron las postcondiciones de `UC-15`.

---

## 4. Contrato de la Operación `registrarMovimientoCaja` (`UC-22`)

1. **Nombre:** `registrarMovimientoCaja(tipoMovimiento: String, importe: BigDecimal, concepto: String, observacion: String[0..1])`

2. **Responsabilidades:** Registrar un ingreso o egreso manual de Caja con su fecha/hora, importe positivo y concepto obligatorio, sin crear Cobros, Reembolsos ni movimientos en Cuenta Corriente.

3. **Tipo:** `Sistema`

4. **Referencias cruzadas:** Caso de Uso `UC-22 — Registrar Movimiento de Caja`; Objetivo `OBJE-12`; Requisito `RF-15` (corrección editorial BC-04; `RF-09` era la referencia histórica equivocada).

**Adenda B0-BC05 (referencias canónicas de Fase 4):** RF-15. Referencias contenidas en el contrato anterior: RF-09. Esta adenda complementa/rectifica la trazabilidad del apartado 4, sin incorporar requisitos, pre/postcondiciones, roles ni operaciones nuevos. Cualquier dependencia transversal se identifica en el contrato del CU invocado.

5. **Notas:** Los pagos de Clientes y las devoluciones automáticas no pueden registrarse como movimientos manuales aislados en `UC-22` (corresponden a `UC-29` y `UC-26`).

6. **Excepciones:**

   * **A1 — `tipoMovimiento` distinto de `INGRESO`/`EGRESO`, `importe <= 0` o `concepto` vacío:** Solicitar corrección sin registrar el movimiento.

   * **A2 — Intento de registrar un pago de Cliente como movimiento manual aislado:** Rechazar la operación e indicar el uso de `UC-29`.

7. **Salida:**

   * Confirmación del `MovimientoCaja` manual registrado (`idMovimientoCaja`); o mensajes de las excepciones A1–A2.

8. **Precondiciones:**

   * El `Administrador` se encuentra autenticado y autorizado.

9. **Postcondiciones:**

   * Se creó una instancia de `MovimientoCaja` con `tipoMovimiento` (`INGRESO` | `EGRESO`), `fechaHoraMovimiento`, `importe`, `concepto`, `observacion` (`0..1`) y `origen = MANUAL`, asociada al `Usuario` Administrador.

---

## 5. Contrato de la Operación `consultarLibroDiario` (`UC-23`)

1. **Nombre:** `consultarLibroDiario(fechaInicial: LocalDate, fechaFinal: LocalDate)`

2. **Responsabilidades:** Recuperar todos los `MovimientoCaja` manuales y automáticos registrados dentro del intervalo `[fechaInicial, fechaFinal]`, sumar los ingresos y egresos del período y presentar el resultado monetario (`ingresos - egresos`) en modo solo lectura.

3. **Tipo:** `Sistema`

4. **Referencias cruzadas:** Caso de Uso `UC-23 — Consultar Libro Diario`; Objetivo `OBJE-12`; Requisito `RF-15` (corrección editorial BC-04; `RF-09` era la referencia histórica equivocada).

**Adenda B0-BC05 (referencias canónicas de Fase 4):** RF-15. Referencias contenidas en el contrato anterior: RF-09. Esta adenda complementa/rectifica la trazabilidad del apartado 4, sin incorporar requisitos, pre/postcondiciones, roles ni operaciones nuevos. Cualquier dependencia transversal se identifica en el contrato del CU invocado.

5. **Notas:** El resultado monetario del período (`ingresos - egresos`) no representa un saldo físico de arqueo de Caja ni una medida de utilidad contable.

6. **Excepciones:**

   * **A1 — Período inválido (`fechaInicial > fechaFinal`):** Solicitar corrección de las fechas.

   * **A2 — Sin movimientos en el intervalo:** Mostrar lista vacía y totales del período nulos sin afirmar que el saldo físico de Caja sea cero.

7. **Salida:**

   * Listado cronológico de `MovimientoCaja` del período (`tipoMovimiento`, `fechaHoraMovimiento`, `importe`, `concepto`, `origen`, referencia), `totalIngresos`, `totalEgresos` y `resultadoMonetario`; o mensajes de las excepciones A1–A2.

8. **Precondiciones:**

   * El `Administrador` se encuentra autenticado y autorizado.

9. **Postcondiciones:**

   * *(Sin cambios de estado en el sistema: operación de solo lectura)*.

---

## 6. Contrato de la Operación `procesarReembolsoElectronico` (`UC-26` «extend» `UC-06`)

1. **Nombre:** `procesarReembolsoElectronico(idCobroOriginal: Long, idReembolsoReintento: Long[0..1], idUsuarioReintento: Long[0..1])`

2. **Responsabilidades:** Gestionar de manera idempotente ante `MercadoPago` la devolución monetaria de un `Cobro` electrónico reembolsable correspondiente a un `Pedido` `CANCELADO` (ya sea en su inicio automático desde `UC-06` o en un reintento manual exclusivo del `Administrador` sobre un `Reembolso` en estado `RECHAZADO`), registrando los efectos financieros internos en Caja y Cuenta Corriente **únicamente cuando la devolución resulta `PROCESADO`**.

3. **Tipo:** `Sistema`

4. **Referencias cruzadas:** Caso de Uso `UC-26 — Procesar Reembolso Electrónico`; extiende condicionalmente a `UC-06 — Cancelar Pedido`; efectos de reevaluación de categoría comercial conforme `UC-15` cuando pasa a `PROCESADO` (**sin añadir relación UML «include»**); Pendiente `F06`; Objetivos `OBJE-10`, `OBJE-13`, `OBJE-17`; Requisitos `RF-06`, `RF-15`, `RF-18`.

5. **Notas:** Existe a lo sumo un único `Reembolso` por `Cobro` electrónico. El reintento manual sobre un `Reembolso` `RECHAZADO` es exclusivo del `Administrador`, opera sobre la misma instancia de `Reembolso` y exige `idUsuarioReintento` **contrastado con la identidad autenticada y su Rol, no confiado desde el cliente sin validación**. `UC-26` no incluye ni extiende `UC-49`. Cuando `UC-26` obtiene una confirmación inmediata, y `UC-49` recibe luego el webhook, se aplican los efectos **solo en la primera transición a `PROCESADO`**; la atomicidad e idempotencia requieren pruebas y control concurrente de servidor.

6. **Excepciones:**

   * **A1 — `Cobro` no reembolsable, ya reembolsado (`PROCESADO`) o con intento externo en curso:** Impedir iniciar una nueva devolución.

   * **A2 — Reintento solicitado sin Rol `Administrador` o sobre un `Reembolso` cuyo estado no es `RECHAZADO`:** Rechazar el reintento.

   * **A3 — `MercadoPago` no disponible o resultado `PENDIENTE` / `RECHAZADO`:** Conservar el `Reembolso` en `PENDIENTE` o establecerlo en `RECHAZADO` sin generar egreso en Caja ni ajuste en Cuenta Corriente.

7. **Salida:**

   * Estado actualizado del `Reembolso` (`PROCESADO`, `PENDIENTE` o `RECHAZADO`) y comprobante de los asientos internos cuando resultó `PROCESADO`; o mensajes de las excepciones A1–A3.

8. **Precondiciones:**

   * En inicio automático: el `Pedido` fue `CANCELADO` (`UC-06`) y posee un `Cobro` electrónico `CONFIRMADO` reembolsable. En reintento manual: el actor es `Administrador` y existe el `Reembolso` en estado `RECHAZADO`.

9. **Postcondiciones:**

   * Se creó (en el primer intento) o recuperó (en reintento) la única instancia `unReembolso` de `Reembolso` asociada al `Cobro` original.

   * Se creó una instancia de `IntentoReembolso` asociada a `unReembolso` con `numeroIntento` correlativo, nueva `claveIdempotencia` e `idUsuarioReintento` (nulo en inicio automático; obligatorio con el `idUsuario` del Administrador en reintento manual).

   * **Únicamente si `MercadoPago` confirmó la devolución (`estado = PROCESADO`):** se modificó `unReembolso.estado` a `PROCESADO`, se creó por única vez una instancia de `MovimientoCaja` (`EGRESO`), se creó por única vez una instancia de `MovimientoCuenta` (`AJUSTE_DEBITO`) actualizando el `saldoConfirmado` del `Cliente`, y se ejecutaron las postcondiciones de `UC-15`.

---

## 7. Contrato de la Operación `registrarResultadoReembolsoElectronico` (`UC-49`)

1. **Nombre:** `registrarResultadoReembolsoElectronico(referenciaExternaIntento: String, estadoInformado: String, firmaVerificacion: String)`

2. **Responsabilidades:** Verificar la autenticidad, correspondencia e idempotencia de una notificación asíncrona remitida por `MercadoPago` respecto de un `IntentoReembolso` registrado, actualizar el estado del `Reembolso` (`PROCESADO` o `RECHAZADO`) y aplicar por única vez los efectos financieros en Caja y Cuenta Corriente (más `UC-15`) exclusivamente cuando el resultado sea `PROCESADO`.

3. **Tipo:** `Sistema`

4. **Referencias cruzadas:** Caso de Uso `UC-49 — Registrar Resultado de Reembolso Electrónico`; Caso de Uso `UC-26 — Procesar Reembolso Electrónico`; reevaluación de categoría conforme `UC-15` al confirmar `PROCESADO` (**sin nueva relación UML «include»**); Pendiente `F06`; Objetivo `OBJE-17`; Requisitos `RF-18`, `RNF-04`.

5. **Notas:** Actor principal: `MercadoPago` (sistema externo). La firma y correlación deben verificarse antes de aplicar cambios; un evento inválido puede conservarse como incidencia sin atribuirlo a un Reembolso ajeno. `EVENTO_RESULTADO_REEMBOLSO` permite asociación opcional de intento y campos `autenticado`, `aplicable`, `motivoNoAplicacion`; el nombre recibido `estadoInformado` corresponde al campo persistido `resultadoInformado`, mientras la referencia se coteja con `referenciaOperacionExterna`/`identificadorEventoExterno` según la notificación real. No se crean columnas. Un resultado `RECHAZADO` habilita un eventual reintento administrativo posterior mediante `UC-26` sobre la misma instancia de `Reembolso`, pero nunca dispara un reintento automático dentro de `UC-49`.

6. **Excepciones:**

   * **A1 — Comunicación externa con firma inválida, sin correspondencia con un `IntentoReembolso` existente o inconsistente:** Registrar la incidencia de auditoría sin asociarla a un Reembolso ajeno ni producir efecto financiero.

   * **A2 — Notificación repetida de un resultado ya `PROCESADO` (idempotencia):** Reconocer el procesamiento previo sin duplicar `MovimientoCaja` ni `MovimientoCuenta`.

   * **A3 — Resultado informado `RECHAZADO` o no definitivo (`PENDIENTE`):** Actualizar el estado sin generar movimientos monetarios en Caja ni en Cuenta Corriente.

7. **Salida:**

   * Acuse de procesamiento idempotente hacia `MercadoPago` y notificación al Cliente cuando el reembolso quedó `PROCESADO`.

8. **Precondiciones:**

   * Existe una instancia de `Reembolso` e `IntentoReembolso` pendiente de resultado definitivo asociada a un `Cobro` electrónico.

9. **Postcondiciones:**

   * Se creó una instancia de `EventoResultadoReembolso` con `fechaHoraRecepcion`, `resultadoInformado`, `autenticado` y `aplicable`, asociada al `IntentoReembolso` solo cuando la correlación es válida; ante incidencia no aplicable se utiliza `motivoNoAplicacion` sin imputación indebida.

   * **Si `estadoInformado == PROCESADO` (por primera y única vez para ese `Reembolso`):** se modificó `unReembolso.estado` a `PROCESADO`, se creó una única instancia de `MovimientoCaja` (`EGRESO`), se creó una única instancia de `MovimientoCuenta` (`AJUSTE_DEBITO`) actualizando el `saldoConfirmado` del `Cliente`, y se ejecutaron las postcondiciones de `UC-15`.

   * **Si `estadoInformado == RECHAZADO`:** se modificó `unReembolso.estado` a `RECHAZADO` sin crear movimientos en Caja ni en Cuenta Corriente.

---

## 8. Contrato de la Operación `consultarMargenBruto` (`UC-27`)

1. **Nombre:** `consultarMargenBruto(modoConsulta: String, fechaHoraDesde: Timestamp[0..1], fechaHoraHasta: Timestamp[0..1], idVentaIndividual: Long[0..1])`

2. **Responsabilidades:** Calcular y presentar en modo solo lectura el margen bruto de las ventas efectivas (derivadas exclusivamente de Pedidos en estado `ENTREGADO`), tanto **por período** (delimitado por `Entrega.fechaHoraEntrega`) como **por venta individual** (identificada mediante `idPedido`, que es la **PK real de `ENTREGA`**; no existe columna `idEntrega`), restando de los ingresos efectivos conciliados con `CARGO_POR_VENTA` los costos históricos atribuibles de Productos `ELABORADO` y `REVENTA` e informando el estado de completitud.

3. **Tipo:** `Sistema`

4. **Referencias cruzadas:** Caso de Uso `UC-27 — Consultar Margen Bruto`; Decisión `RD-RP004/RP028-001` (`H-04`); Objetivo `OBJE-14`; Requisito `RF-19`.

5. **Notas:**

   * **Doble modalidad aprobada (`RD-RP004/RP028-001`):** `idVentaIndividual` es el argumento lógico público y debe resolverse a `ENTREGA.idPedido` / `PEDIDO.idPedido`; no se añade `idEntrega` al esquema.  Soporta `modoConsulta = PERIODO` (agregando todas las `Entrega` definitivas cuya `fechaHoraEntrega` pertenezca al intervalo) y `modoConsulta = VENTA_INDIVIDUAL` (desglosando una `Entrega` / `Pedido` `ENTREGADO` específico).

   * En ambas modalidades, el ingreso efectivo suma el tramo original entregado (con su precio histórico, Promoción congelada y ajuste global congelado) más el tramo adicional entregado (a su importe aceptado en `UC-07`, sin aplicarle Promoción ni segundo ajuste global).

   * Si falta algún costo histórico de `ELABORADO` o `REVENTA`, **jamás se sustituye por costo cero ni por costo actual**: el resultado se marca expresamente como **incompleto**.

6. **Excepciones:**

   * **A1 — Período inválido (`fechaHoraDesde > fechaHoraHasta`), `idVentaIndividual` inexistente/no `ENTREGADO` o sin ventas efectivas:** Informar la situación sin asumir margen ficticio.

   * **A2 — Falta algún costo histórico en una o más entregas incluidas:** Marcar expresamente el cálculo como **incompleto** identificando la causa, sin utilizar costo cero.

7. **Salida:**

   * En `PERIODO`: intervalo consultado, ingresos efectivos totales, costos históricos atribuibles (`ELABORADO` y `REVENTA`), margen bruto del período y estado de completitud.

   * En `VENTA_INDIVIDUAL`: identificación del Pedido/Entrega, ingreso efectivo del tramo original y del tramo adicional, costos históricos atribuibles por ítem (`ELABORADO` y `REVENTA`), margen bruto individual y estado de completitud; o mensajes de las excepciones A1–A2.

8. **Precondiciones:**

   * El `Administrador` se encuentra autenticado y autorizado.

9. **Postcondiciones:**

   * *(Sin cambios de estado en el sistema: operación estrictamente de solo lectura)*.

---

## 9. Glosario de Términos Asociados (`REV-05`)

* **`Saldo Confirmado` (Concepto Financiero — `UC-14` / `RD-RP028`):** Saldo contable firme de la Cuenta Corriente de un `Cliente` resultante de los `MovimientoCuenta` definitivos (`CARGO_POR_VENTA`, `PAGO`, `AJUSTE_DEBITO`, `ANULACION_COBRO`).

* **`Pagos en Tránsito Validados` (Concepto Financiero — `UC-05` / `UC-14` / `RD-RP028`):** Efectivo declarado como recibido por el `Repartidor` al confirmar una `Entrega` (`UC-05`), pendiente de rendición y registración en `UC-29`.

* **`Saldo Exigible Provisional` (Magnitud Derivada — `UC-14` / `RD-RP028`):** Importe neto exigible al `Cliente` calculado como `saldoConfirmado - pagosEnTransitoValidados`.

* **`Cobro` (Tipo / Concepto — Tabla `COBRO`):** Percepción monetaria asociada a un `Cliente` cuyo atributo `estadoCobro` admite exclusivamente los valores `CONFIRMADO` o `ANULADO` (`RD-F01`).

* **`Margen Bruto` (Magnitud de Gestión — `UC-27` / `RD-RP004`):** Diferencia entre el ingreso efectivo de ventas entregadas (conciliado con `CARGO_POR_VENTA`) y los costos históricos atribuibles de los productos `ELABORADO` y `REVENTA` efectivamente entregados, consultable por período o por venta individual.
