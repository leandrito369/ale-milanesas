# Contratos de Operación del Sistema (DSS — REV-04A) — Pedidos, Canal Online, Asignación y Ruteo (7 Contratos Individuales)

**Proyecto:** Sistema de Gestión para Ale Milanesas (UNaM-FCEQyN)  

**Lote de revisión:** `REV-04A` (`UC-34`, `UC-03`, `UC-21`, `UC-43`, `UC-04`, `UC-25` \+ operación de reprogramación `RD-RP020-001`)  

**Decisiones incorporadas:** `RD-RP001/RP019` (`H-05`: selección y validación en servidor de `fechaReparto` habilitada en `UC-21`), `RD-RP023-001` (`H-06`: mejor beneficio aplicable sin acumulación de promociones simultáneas), `RD-RP002-001` (`H-21`: 6 reglas obligatorias en `UC-43`), `RD-F04-001..007` (`H-09`: validación idempotente en servidor para carga offline en `UC-03`) y `RD-RP020-001` (`H-23`: reprogramación de Pedido pendiente con invalidación de asignación `UC-43`).

---

## 1. Contrato de la Operación `buscarPedido` (`UC-34`)

1. **Nombre:** `buscarPedido(idPedido: Long[0..1], idCliente: Long[0..1], fechaReparto: LocalDate[0..1], estado: String[0..1], canalOrigen: String[0..1])`

2. **Responsabilidades:** Localizar y presentar en modo solo lectura los `Pedido` registrados que cumplan los criterios indicados y devolver el `Pedido` seleccionado al caso de uso invocante.

3. **Tipo:** `Sistema`

4. **Referencias cruzadas:** Caso de Uso `UC-34 — Buscar Pedido`; incluido por `UC-05 — Registrar Entrega`, `UC-06 — Cancelar Pedido`, `UC-28 — Registrar Preparación de Pedido` y `UC-43 — Asignar y Reasignar Pedidos a Repartidores`; permisos `RD-RP007-002`; Objetivo `OBJE-01`; Requisito `RF-01`.

5. **Notas:** Operación estrictamente de solo lectura. `RD-RP007-002`: `Administrador` acceso directo; `Vendedor` directo/contextual; `Responsable de Producción` **solo contextual**; `Repartidor` **solo contextual a sus Pedidos con asignación vigente**. Ni búsqueda general ni visualización de campos sensibles se infiere de una consulta contextual. No modifica el estado ni el contenido de ningún Pedido.

6. **Excepciones:**

   * **A1 — Sin coincidencias:** Informar que no existen Pedidos que cumplan los criterios ingresados.

   * **A2 — Criterios con formato inválido:** Solicitar corrección sin ejecutar la consulta.

   * **A3 — Actor sin permiso, consulta fuera del CU contextual permitido o `Repartidor` intentando consultar un Pedido sin asignación vigente a su nombre:** Denegar la consulta y no exponer información ni datos sensibles del Pedido.

7. **Salida:**

   * Listado de `Pedido` coincidentes (`idPedido`, `Cliente`, `fechaHoraCarga`, `fechaReparto`, `canalOrigen` `INTERNO` \| `ONLINE`, `estado` `PENDIENTE` \| `ENTREGADO` \| `CANCELADO`) y referencia del `Pedido` seleccionado; o mensajes de las excepciones A1–A3.

8. **Precondiciones:**

   * El actor interno se encuentra autenticado y autorizado según `RD-RP007-002`: `Administrador` (directo), `Vendedor` (directo/contextual), `Responsable de Producción` (solo contextual) o `Repartidor` (solo contextual de Pedidos propios asignados). La consulta efectiva verifica dicho ámbito antes de devolver resultados.

9. **Postcondiciones:**

   * *(Sin cambios de estado en el sistema: no se crean ni modifican instancias de `Pedido` ni `AsignacionReparto`)*.

---

## 2. Contrato de la Operación `cargarPedido` (`UC-03` «include» `UC-33`, `UC-35`, `UC-16`→`UC-15`)

1. **Nombre:** `cargarPedido(idCliente: Long, fechaReparto: LocalDate, items: List<ItemPedidoDTO>, direccionEntrega: DireccionDTO, claveIdempotencia: UUID)`

2. **Responsabilidades:** Registrar de manera unificada e idempotente un nuevo `Pedido` multiproducto de `canalOrigen = INTERNO` en estado `PENDIENTE` para un `Cliente` `ACTIVO` (localizado mediante `UC-33`), incorporando `Producto` activos (`UC-35`), congelando los precios unitarios vigentes y el ajuste comercial según la categoría evaluada del Cliente (`UC-16` incluyendo `UC-15`), y admitiendo su sincronización validada por el servidor cuando se originó en modo offline (`RD-F04`).

3. **Tipo:** `Sistema`

4. **Referencias cruzadas:** Caso de Uso `UC-03 — Cargar Pedido`; incluye `UC-33 — Buscar Cliente`, `UC-35 — Buscar Producto`, `UC-16 — Aplicar Ajuste Comercial según Categoría` y `UC-15 — Evaluar y Actualizar Categoría Comercial`; Decisión `RD-F04-001..007`; Objetivos `OBJE-01`, `OBJE-02`, `OBJE-04`, `OBJE-11`; Requisitos `RF-01`, `RF-09`, `RF-12`.

5. **Notas:** Conforme a `RD-F04`, si el Vendedor opera sin conectividad, la operación se captura localmente con su snapshot comercial y `claveIdempotencia`; al recuperar conectividad, el servidor valida y reconcilia idempotentemente el registro sin duplicar el Pedido.

6. **Excepciones:**

   * **A1 — `Cliente` no localizado o en estado `INACTIVO`:** No permitir confirmar un Pedido nuevo para ese Cliente.

   * **A2 — `fechaReparto` inválida:** Solicitar corrección.

   * **A3 — Ningún ítem informado, `Producto` inexistente/inactivo (`activo = false`), sin `PrecioProducto` vigente o `cantidadSolicitada <= 0`:** No incorporar el detalle ni confirmar el Pedido.

   * **A4 — Categoría comercial o `PoliticaCategoriaComercial` no determinable:** Aplicar las excepciones de `UC-15`/`UC-16` sin inventar porcentajes.

   * **A5 — `claveIdempotencia` ya procesada en sincronización previa (`RD-F04`):** Reconocer el `Pedido` existente sin crear un duplicado.

7. **Salida:**

   * Confirmación del `Pedido` registrado (`idPedido`, `canalOrigen = INTERNO`, `estado = PENDIENTE`, `categoriaComercialAplicada`, `tipoAjuste`, `porcentajeAjuste`, `totalOriginal`), o mensajes provocados por las excepciones A1–A5.

8. **Precondiciones:**

   * El `Vendedor` se encuentra autenticado y autorizado.

   * El `Cliente` seleccionado mediante `UC-33` se encuentra `ACTIVO`, los `Producto` seleccionados mediante `UC-35` están activos con precio vigente y existe `PoliticaCategoriaComercial` vigente.

9. **Postcondiciones:**

   * Se ejecutaron las postcondiciones de `UC-15` (evaluación/actualización de `Cliente.categoriaComercial`) y `UC-16` (determinación del ajuste según `PoliticaCategoriaComercial` vigente).

   * Se creó una única instancia `nuevoPedido` de `Pedido` con `canalOrigen = INTERNO`, `estado = PENDIENTE`, `fechaHoraCarga`, `fechaReparto`, `direccionEntrega` congelada, `categoriaComercialAplicada`, `tipoAjuste`, `porcentajeAjuste` y `totalOriginal`.

   * Se asoció `nuevoPedido` con el `Cliente`, con el `Usuario` Vendedor y con la `PoliticaCategoriaComercial` aplicada.

   * Para cada elemento en `items`, se creó una instancia de `DetallePedido` asociada a `nuevoPedido` y al `Producto`, con `cantidadSolicitada` original, `codigoUnidadVenta` y `precioUnitario` congelado.

---

## 3. Contrato de la Operación `reprogramarFechaRepartoPedido` (`UC-03` / `RD-RP020-001`)

1. **Nombre:** `reprogramarFechaRepartoPedido(idPedido: Long, nuevaFechaReparto: LocalDate, motivoReprogramacion: String)`

2. **Responsabilidades:** Modificar la `fechaReparto` de un `Pedido` que se encuentra en estado `PENDIENTE`, registrando el historial de cambio de fecha con su motivo obligatorio e **invalidando automáticamente cualquier `AsignacionReparto` vigente (`UC-43`) y cualquier `RutaReparto` sugerida previa (`UC-25`)** (`RD-RP020-001`).

3. **Tipo:** `Sistema`

4. **Referencias cruzadas:** Caso de Uso `UC-03 — Cargar Pedido`; Caso de Uso `UC-34 — Buscar Pedido`; Caso de Uso `UC-43 — Asignar y Reasignar Pedidos a Repartidores`; Caso de Uso `UC-25 — Generar Ruta Sugerida de Reparto`; Decisión `RD-RP020-001` (`H-23`); Objetivo `OBJE-01`; Requisito `RF-01`.

5. **Notas:** Esta operación resuelve la reprogramación de un Pedido pendiente dentro del ciclo de gestión del Pedido sin crear un caso de uso adicional fuera de los 64 canónicos (`RD-RP020-001`). No altera los precios, promociones ni el ajuste comercial congelados originalmente. **Nota de diseño:** RD-RP020 exige historial y cierre atómico de la asignación; el diccionario vigente de 60 tablas no define una tabla específica de historial de fechas ni de rutas, por lo que el mecanismo de persistencia queda pendiente y no se presume una tabla nueva.

6. **Excepciones:**

   * **A1 — `Pedido` inexistente o en estado `ENTREGADO` o `CANCELADO`:** Impedir la reprogramación.

   * **A2 — `nuevaFechaReparto` inválida o igual a la `Pedido.fechaReparto` actual:** Solicitar una fecha válida distinta o informar ausencia de cambio.

   * **A3 — `motivoReprogramacion` ausente o vacío:** Exigir el motivo obligatorio antes de confirmar.

7. **Salida:**

   * Confirmación de la `nuevaFechaReparto` vigente del `Pedido` y aviso de que la asignación de Repartidor previa (si existía) quedó invalidada y requiere nueva asignación en `UC-43`; o mensajes de las excepciones A1–A3.

8. **Precondiciones:**

   * El actor autorizado (`Vendedor` o `Administrador`) se encuentra autenticado y el `Pedido` identificado por `idPedido` se encuentra en estado `PENDIENTE`.

9. **Postcondiciones:**

   * Se registró en el historial de fechas del `Pedido` la `fechaRepartoAnterior`, la `nuevaFechaReparto`, la fecha/hora del cambio, el `motivoReprogramacion` y el `Usuario` responsable (`RD-RP020-001`).

   * Se modificó el atributo `unPedido.fechaReparto` al valor `nuevaFechaReparto` (conservando inalterados `unPedido.estado = PENDIENTE`, sus `DetallePedido` y `unPedido.totalOriginal`).

   * Si existía una instancia vigente de `AsignacionReparto` asociada a `unPedido`, se cerró su vigencia (`fechaHoraFin = fechaHoraActual`), quedando `unPedido` sin Repartidor asignado hasta una nueva ejecución de `UC-43` e invalidando las `RutaReparto` sugeridas que lo incluían.

---

## 4. Contrato de la Operación `realizarPedidoOnline` (`UC-21` «include» `UC-16`→`UC-15`, `UC-29`)

1. **Nombre:** `realizarPedidoOnline(idDesafioVerificado: UUID, items: List<ItemPedidoDTO>, direccionEntrega: DireccionDTO, fechaReparto: LocalDate)`

2. **Responsabilidades:** Validar en el servidor que el `Cliente` `ACTIVO` posea un desafío temporal verificado y que la `fechaReparto` elegida pertenezca a las **fechas de reparto habilitadas (`RD-RP001/RP019`)**, aplicar y congelar por cada Producto el **mejor beneficio promocional elegible sin acumular descuentos sobre las mismas unidades (`RD-RP023-001`)**, aplicar luego el ajuste comercial por categoría (`UC-16` incluyendo `UC-15`), solicitar y verificar el cobro electrónico en `MercadoPago` (`UC-29`) y, únicamente ante su confirmación, registrar el `Pedido` con `canalOrigen = ONLINE` y `estado = PENDIENTE`.

3. **Tipo:** `Sistema`

4. **Referencias cruzadas:** Caso de Uso `UC-21 — Realizar Pedido Online`; incluye `UC-16 — Aplicar Ajuste Comercial según Categoría`, `UC-15 — Evaluar y Actualizar Categoría Comercial` y `UC-29 — Registrar Cobro`; Decisiones `RD-RP001/RP019` (`H-05`) y `RD-RP023-001` (`H-06`); Objetivos `OBJE-01`, `OBJE-10`, `OBJE-11`, `OBJE-13`, `OBJE-16`; Requisitos `RF-01`, `RF-06`, `RF-10`, `RF-12`, `RF-15`, `RF-16`, `RF-20`.

5. **Notas:**

   * Conforme a `RD-RP001/RP019`, la `fechaReparto` debe seleccionarse entre las opciones habilitadas y es revalidada por el servidor antes de iniciar el cobro.

   * Conforme a `RD-RP023-001`, si un mismo Producto y Cliente destinatario están alcanzados por más de una `Promocion` `ACTIVA` simultánea, **nunca se suman ni acumulan porcentajes de descuento sobre las mismas unidades**: el sistema selecciona automáticamente la promoción elegible que otorgue el mayor beneficio y la congela en el detalle, aplicando después sobre el subtotal resultante el ajuste por categoría comercial (`UC-16` → `UC-15`).

6. **Excepciones:**

   * **A1 — Desafío temporal no verificado, expirado o `Cliente` no `ACTIVO` o con teléfono ambiguo:** Bloquear la confirmación del Pedido online.

   * **A2 (`RD-RP001/RP019`) — La `fechaReparto` seleccionada no pertenece a las fechas habilitadas o perdió disponibilidad en el servidor:** Rechazar la fecha e informar las fechas de reparto habilitadas actualizadas sin iniciar el cobro.

   * **A3 — Ningún ítem seleccionado, `Producto` inactivo, sin precio vigente o cantidad `<= 0`:** Solicitar corrección antes de iniciar el pago.

   * **A4 — Pago electrónico rechazado, cancelado o fallo de comunicación con `MercadoPago`:** No confirmar el `Pedido` ni registrar `Cobro`, `MovimientoCuenta` ni `MovimientoCaja`.

7. **Salida:**

   * Comprobante del `Pedido` online confirmado (`idPedido`, `idCobro`, `fechaReparto` validada, mejor promoción aplicada por ítem sin acumulación, ajuste por categoría comercial y `totalOriginal` congelado); o mensajes de las excepciones A1–A4.

8. **Precondiciones:**

   * El `Cliente` preexistente se encuentra en estado `ACTIVO` y superó la verificación del código temporal (`idDesafioVerificado`).

   * Existen fechas de reparto habilitadas, Productos activos con precio vigente y una `PoliticaCategoriaComercial` vigente.

9. **Postcondiciones:**

   * El servidor validó que `fechaReparto` pertenece al conjunto vigente de fechas de reparto habilitadas (`RD-RP001/RP019`).

   * Para cada ítem alcanzado por una o más `Promocion` vigentes para ese `Cliente`, se seleccionó sin acumulación la `Promocion` que produce el **mayor beneficio económico elegible** (`RD-RP023-001`), no simplemente el mayor porcentaje sin evaluar condiciones y unidades alcanzadas.

   * Se ejecutaron las postcondiciones de `UC-15` y `UC-16` sobre el subtotal resultante tras aplicar el descuento promocional.

   * Tras constatar la acreditación de `MercadoPago`, el sistema registró consistentemente las postcondiciones internas de `UC-29` (no se afirma una transacción ACID distribuida con el proveedor externo): creación de `Cobro` (`origen = ONLINE`, `estadoCobro = CONFIRMADO`), creación de `MovimientoCuenta` (`PAGO`), creación de `MovimientoCaja` (`INGRESO`) y reevaluación de `UC-15`.

   * Se creó una instancia `pedidoOnline` de `Pedido` con `canalOrigen = ONLINE`, `estado = PENDIENTE`, `fechaReparto`, `direccionEntrega`, ajuste comercial y `totalOriginal` congelados, junto con sus instancias de `DetallePedido` (con `precioUnitario` y descuento promocional congelados).

---

## 5. Contrato de la Operación `asignarOReasignarPedidoARepartidor` (`UC-43` «include» `UC-34`)

1. **Nombre:** `asignarOReasignarPedidoARepartidor(idPedido: Long, idUsuarioRepartidor: Long, motivoReasignacion: String[0..1])`

2. **Responsabilidades:** Registrar en modo **exclusivamente online** la asignación inicial de un `Pedido` `PENDIENTE` (localizado mediante `UC-34`) a un Repartidor elegible, o sustituir su asignación vigente antes de la Entrega registrando el motivo obligatorio y preservando la unicidad transaccional y la trazabilidad histórica (`RD-RP002-001`).

3. **Tipo:** `Sistema`

4. **Referencias cruzadas:** Caso de Uso `UC-43 — Asignar y Reasignar Pedidos a Repartidores`; incluye `UC-34 — Buscar Pedido`; Decisión `RD-RP002-001` (`H-21`); Objetivos `OBJE-01`, `OBJE-06`; Requisitos `RF-01`, `RF-17`.

5. **Notas:** Conforme a `RD-RP002-001`, las **seis reglas aprobadas** son: (1) solo `Pedido.estado = PENDIENTE`; (2) cuenta de Repartidor habilitada con Rol `REPARTIDOR`; (3) no más de una `AsignacionReparto` vigente por Pedido; (4) preservar historial de asignaciones previas al reasignar; (5) prohibición de asignar a Repartidor deshabilitado; (6) ejecutar UC-43 exclusivamente online. **Controles adicionales presentes en el CU y el modelo:** `motivoReasignacion` obligatorio cuando hay reemplazo, no registrar cambios redundantes y revalidar concurrencia/estado actual. No se presentan estos controles adicionales como reemplazo de las seis reglas ratificadas. Se invalida cualquier ruta sugerida dependiente de la asignación reemplazada; su mecanismo técnico aún está pendiente.

6. **Excepciones:**

   * **A1 — Intento de ejecutar la asignación/reasignación en modo offline (`RD-RP002-001`):** Rechazar la operación e exigir conectividad con el servidor.

   * **A2 — `Pedido` en estado `ENTREGADO` o `CANCELADO`:** Impedir asignarlo o reasignarlo.

   * **A3 — El `Usuario` seleccionado no está en estado `HABILITADO` o no posee el Rol vigente `REPARTIDOR` (`RD-RP002-001`):** Rechazar la selección.

   * **A4 — Se selecciona el mismo Repartidor que ya posee la asignación vigente:** Informar que no hay cambio real y no registrar reasignación redundante.

   * **A5 — El Pedido ya poseía asignación vigente y no se informó `motivoReasignacion`:** Rechazar la confirmación hasta completar el motivo obligatorio.

   * **A6 — Conflicto de concurrencia (el Pedido o su asignación cambiaron durante la operación):** Detener la confirmación y solicitar revisar la información actualizada.

7. **Salida:**

   * Confirmación de la `AsignacionReparto` vigente registrada (referencia compuesta `idPedido` + `numeroAsignacion`) para el `Pedido` y el `Repartidor` elegido; o mensajes provocados por las excepciones A1–A6.

8. **Precondiciones:**

   * El `Vendedor` se encuentra autenticado y operando **online** contra el servidor (`RD-RP002-001`).

   * El `Pedido` seleccionado mediante `UC-34` está en estado `PENDIENTE` y el `Usuario` elegido está `HABILITADO` con Rol `REPARTIDOR`.

9. **Postcondiciones:**

   * Si existía una instancia previa de `AsignacionReparto` vigente para el `Pedido`, se modificó su atributo `fechaHoraFin` con la marca temporal actual, cerrando su vigencia sin eliminarla del historial.

   * Se creó una única instancia vigente `nuevaAsignacion` de `AsignacionReparto` con `fechaHoraInicio`, `fechaHoraFin = NULL` y `motivoReasignacion` (cuando fue reasignación), asociada al `Pedido`, al `Usuario` Repartidor y al `Usuario` Vendedor.

   * Se conservaron inalterados `Pedido.estado = PENDIENTE`, sus `DetallePedido`, precios, inventario, Caja y Cuenta Corriente; y quedó invalidada cualquier `RutaReparto` sugerida previa que dependiera de la asignación reemplazada.

---

## 6. Contrato de la Operación `consultarPedidosAsignados` (`UC-04`)

1. **Nombre:** `consultarPedidosAsignados()`

2. **Responsabilidades:** Mostrar en modo solo lectura exclusivamente el conjunto de `Pedido` en estado `PENDIENTE` que poseen una `AsignacionReparto` vigente vinculada al `Repartidor` autenticado, incluyendo las cantidades originales y las unidades adicionales aceptadas en `UC-07`.

3. **Tipo:** `Sistema`

4. **Referencias cruzadas:** Caso de Uso `UC-04 — Consultar Pedidos Asignados`; Caso de Uso `UC-43 — Asignar y Reasignar Pedidos a Repartidores`; Objetivo `OBJE-01`; Requisito `RF-01`.

5. **Notas:** Operación estrictamente de solo lectura. No expone Pedidos asignados a otros Repartidores ni confunde el estado comercial del Pedido con su asignación.

6. **Excepciones:**

   * **A1 — El Repartidor no posee asignaciones vigentes:** Informar lista vacía.

   * **A2 — Intento de acceder a Pedidos de otro Repartidor o sin autorización:** Rechazar el acceso.

7. **Salida:**

   * Listado y detalle de los `Pedido` `PENDIENTE` asignados al Repartidor autenticado (`idPedido`, `Cliente`, `fechaReparto`, dirección de entrega, `Producto`, `cantidadOriginal` y adicionales aceptadas en `UC-07`); o mensajes de las excepciones A1–A2.

8. **Precondiciones:**

   * El `Repartidor` se encuentra autenticado y autorizado.

9. **Postcondiciones:**

   * *(Sin cambios de estado en el sistema: no se modifican `Pedido` ni `AsignacionReparto`)*.

---

## 7. Contrato de la Operación `generarRutaSugeridaReparto` (`UC-25`)

1. **Nombre:** `generarRutaSugeridaReparto(fechaReparto: LocalDate)`

2. **Responsabilidades:** Recuperar los `Pedido` en estado `PENDIENTE` para la `fechaReparto` indicada con `AsignacionReparto` vigente al `Repartidor` autenticado, validar sus datos de ubicación, solicitar al `Servicio de Ruteo` externo una secuencia sugerida de visita y registrar/presentar dicha secuencia sin alterar el estado de los Pedidos.

3. **Tipo:** `Sistema`

4. **Referencias cruzadas:** Caso de Uso `UC-25 — Generar Ruta Sugerida de Reparto`; Caso de Uso `UC-43 — Asignar y Reasignar Pedidos a Repartidores`; Objetivo `OBJE-06`; Requisito `RF-17`.

5. **Notas:** La secuencia constituye una ruta sugerida de apoyo operativo y no un óptimo matemático garantizado. `RutaReparto` y `DetalleRutaReparto` se tratan aquí como objetos **conceptuales de diseño**: no son tablas del diccionario MR-5/MR-6 de 60 tablas; la persistencia y su invalidación deberán definirse sin crear estructuras por inferencia. Una reasignación posterior en `UC-43` o una reprogramación de fecha (`RD-RP020-001`) invalida la ruta sugerida y exige su regeneración.

6. **Excepciones:**

   * **A1 — No existen `Pedido` `PENDIENTE` asignados al Repartidor para `fechaReparto`:** Informar que no hay entregas pendientes y no invocar al `Servicio de Ruteo`.

   * **A2 — Uno o más Pedidos carecen de ubicación suficiente:** Identificarlos expresamente (sin omitirlos silenciosamente) y presentar el listado pendiente sin afirmar ruta optimizada.

   * **A3 — `Servicio de Ruteo` no disponible, con error o con respuesta inconsistente respecto de las ubicaciones enviadas:** Informar la contingencia y conservar disponible el listado de entregas pendientes sin secuencia optimizada.

7. **Salida:**

   * Entregas ordenadas según la secuencia sugerida (`ordenVisita`, `idPedido`, `Cliente`, dirección y marca temporal de generación), o listado de contingencia sin optimizar según las excepciones A1–A3.

8. **Precondiciones:**

   * El `Repartidor` se encuentra autenticado y autorizado, y existen `Pedido` `PENDIENTE` asignados a él para la `fechaReparto`.

9. **Postcondiciones:**

   * Cuando las ubicaciones fueron válidas y el `Servicio de Ruteo` devolvió una respuesta consistente, se generó la representación conceptual `unaRuta` de `RutaReparto` (su persistencia física queda pendiente) (con sus `DetalleRutaReparto` indicando el orden sugerido y las asignaciones consideradas) asociada al `Repartidor` y a la `fechaHoraGeneracion`.

   * El atributo `Pedido.estado` de todos los Pedidos considerados permaneció inalterado en `PENDIENTE`.

---

## 8. Glosario de Términos Asociados (`REV-04A`)

* **`Pedido` (Tipo / Concepto — Tabla `PEDIDO`):** Orden comercial de un `Cliente` para una `fechaReparto`, con `canalOrigen` (`INTERNO` \| `ONLINE`), `estado` (`PENDIENTE` \| `ENTREGADO` \| `CANCELADO`) y `totalOriginal` congelado.

* **`DetallePedido` (Tipo / Concepto — Tabla `DETALLE_PEDIDO`):** Ítem de un `Pedido` que conserva inmutables `cantidadOriginal`, `precioUnitarioOriginal` y el mejor descuento promocional aplicable sin acumulación (`RD-RP023-001`).

* **`AsignacionReparto` (Tipo / Concepto — Tabla `ASIGNACION_REPARTO`):** Asociación trazable regida por las 6 reglas de `RD-RP002-001` que vincula un `Pedido` `PENDIENTE` con un único `Repartidor` vigente (`fechaHoraFin = NULL`).

* **`RutaReparto` (Tipo / Concepto — Tabla `RUTA_REPARTO`):** Secuencia sugerida de visita generada en `UC-25` para los Pedidos `PENDIENTE` asignados a un `Repartidor` en una `fechaReparto`.
