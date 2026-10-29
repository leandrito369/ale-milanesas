# Contratos de Operación del Sistema (DSS — REV-06B) — Clientes, Categoría Comercial, Recetas e Inventario (13 Contratos Individuales)

**Proyecto:** Sistema de Gestión para Ale Milanesas (UNaM-FCEQyN)  
**Lote de revisión:** `REV-06B` (`UC-02`, `UC-33`, `UC-32`, `UC-38`, `UC-57`, `UC-15`, `UC-16`, `UC-36`, `UC-10`, `UC-31`, `UC-52`, `UC-09`, `UC-64`)  
**Cobertura alcanzada:** Con estos 13 contratos individuales se completan los **67 contratos correspondientes a la totalidad de los 64 Casos de Uso vigentes (`UC-01` a `UC-64`)**.

---

## 1. Contrato de la Operación `registrarCliente` (`UC-02`)

1. **Nombre:** `registrarCliente(nombre: String, telefonoPrincipal: String, direccion: DireccionDTO, zona: String, diaHabitualReparto: Short[0..1], observacion: String[0..1])`
2. **Responsabilidades:** Registrar un nuevo `Cliente` en estado `ACTIVO` y con categoría comercial inicial `CUMPLIDOR`, verificando la ausencia de un duplicado exacto por nombre normalizado y `telefonoPrincipal`.
3. **Tipo:** `Sistema`
4. **Referencias cruzadas:** Caso de Uso `UC-02 — Registrar Cliente`; Objetivo `OBJE-02`; Requisito `RF-03`.
5. **Notas:** Se admite que distintos Clientes compartan número telefónico siempre que posean distinto nombre identificatorio normalizado (advirtiendo tal circunstancia para resguardar la desambiguación en el canal online `UC-21`).
6. **Excepciones:**
   * **A1 — Datos obligatorios ausentes o con formato inválido (`nombre`, `telefonoPrincipal`, `direccion`, `zona`):** Solicitar corrección sin registrar el Cliente.
   * **A2 — Duplicado exacto (`nombreNormalizado` + `telefonoPrincipal` ya registrados):** Rechazar el alta e informar el Cliente existente.
   * **A3 — Cancelación del actor o fallo de persistencia:** Conservar el catálogo de Clientes sin altas parciales.
7. **Salida:**
   * Confirmación del `Cliente` registrado (`idCliente`, `estado = ACTIVO`, `categoriaComercial = CUMPLIDOR`); o mensajes de las excepciones A1–A3.
8. **Precondiciones:**
   * El actor autorizado (`Vendedor` o `Administrador`) se encuentra autenticado.
9. **Postcondiciones:**
   * Se creó una instancia `nuevoCliente` de `Cliente` con `nombre`, `nombreNormalizado`, `telefonoPrincipal`, `direccion`, `zona`, `diaHabitualReparto` (`0..1`), `estado = ACTIVO`, `categoriaComercial = CUMPLIDOR` y `fechaHoraAlta`.

---

## 2. Contrato de la Operación `buscarCliente` (`UC-33`)

1. **Nombre:** `buscarCliente(idCliente: Long[0..1], nombre: String[0..1], telefonoPrincipal: String[0..1], zona: String[0..1], estado: String[0..1])`
2. **Responsabilidades:** Localizar y presentar en modo solo lectura los `Cliente` registrados (activos o inactivos) que coincidan con los criterios informados, devolviendo la referencia seleccionada al caso de uso invocante.
3. **Tipo:** `Sistema`
4. **Referencias cruzadas:** Caso de Uso `UC-33 — Buscar Cliente`; incluido por `UC-03 — Cargar Pedido`, `UC-14 — Consultar Cuenta Corriente`, `UC-32 — Modificar Cliente` y `UC-38 — Cambiar Estado de Cliente`; Objetivo `OBJE-02`; Requisito `RF-03`.
5. **Notas:** Conforme a §6.1 del Documento Maestro, el acceso directo y contextual a `UC-33` corresponde a **Administrador y Vendedor**. Operación estrictamente de solo lectura.
6. **Excepciones:**
   * **A1 — Criterios de búsqueda inválidos:** Solicitar corrección sin ejecutar la consulta.
   * **A2 — Sin Clientes coincidentes:** Informar ausencia de resultados sin crear ni modificar registros.
   * **A3 — El actor finaliza la búsqueda sin seleccionar un Cliente:** Concluir la operación sin referencia seleccionada.
7. **Salida:**
   * Listado de `Cliente` coincidentes (`idCliente`, `nombre`, `telefonoPrincipal`, `direccion`, `zona`, `estado` `ACTIVO` | `INACTIVO`, `categoriaComercial` `CUMPLIDOR` | `EN_MORA`) y referencia del `Cliente` seleccionado; o mensajes de las excepciones A1–A3.
8. **Precondiciones:**
   * El actor autorizado (`Vendedor` o `Administrador`) se encuentra autenticado.
9. **Postcondiciones:**
   * *(Sin cambios de estado en el sistema: no se modifican instancias de `Cliente` ni de `MovimientoCuenta`)*.

---

## 3. Contrato de la Operación `modificarCliente` (`UC-32` «include» `UC-33`)

1. **Nombre:** `modificarCliente(idCliente: Long, nuevosDatos: DatosClienteDTO)`
2. **Responsabilidades:** Actualizar los datos identificatorios, de contacto, domicilio, zona y/o día habitual de reparto de un `Cliente` previamente localizado mediante `UC-33`, sin modificar su estado `ACTIVO`/`INACTIVO` ni su `categoriaComercial` y preservando las direcciones ya congeladas en Pedidos históricos.
3. **Tipo:** `Sistema`
4. **Referencias cruzadas:** Caso de Uso `UC-32 — Modificar Cliente`; incluye `UC-33 — Buscar Cliente`; Objetivo `OBJE-02`; Requisito `RF-03`.
5. **Notas:** El cambio de estado `ACTIVO`/`INACTIVO` corresponde exclusivamente a `UC-38` (Administrador). Si se modifica `telefonoPrincipal`, se invalidan los desafíos temporales (`DesafioAutenticacionCliente`) pendientes para ese Cliente.
6. **Excepciones:**
   * **A1 — `UC-33` finalizó sin selección válida:** No modificar información.
   * **A2 — Duplicado exacto con otro Cliente (`nombreNormalizado` + `telefonoPrincipal`) o datos obligatorios inválidos:** Rechazar la modificación y solicitar corrección.
   * **A3 — Intento de modificar `Cliente.estado` o `Cliente.categoriaComercial` desde `UC-32`:** Rechazar el cambio por corresponder a `UC-38` y `UC-15`.
   * **A4 — Cancelación o error de persistencia:** Conservar intactos los datos vigentes del Cliente.
7. **Salida:**
   * Confirmación de la actualización de los datos comerciales del `Cliente`; o mensajes de las excepciones A1–A4.
8. **Precondiciones:**
   * El actor autorizado (`Vendedor` o `Administrador`) se encuentra autenticado y existe el `Cliente` seleccionado mediante `UC-33`.
9. **Postcondiciones:**
   * Se modificaron los atributos comerciales y de contacto permitidos de `unCliente` (manteniendo inalterados `unCliente.estado`, `unCliente.categoriaComercial` y las direcciones congeladas en `Pedido` previos).
   * Si cambió `unCliente.telefonoPrincipal`, se invalidaron los `DesafioAutenticacionCliente` pendientes asociados a `unCliente`.

---

## 4. Contrato de la Operación `cambiarEstadoCliente` (`UC-38` «include» `UC-33`)

1. **Nombre:** `cambiarEstadoCliente(idCliente: Long, nuevoEstado: String, motivo: String[0..1])`
2. **Responsabilidades:** Activar o desactivar lógicamente un `Cliente` previamente localizado mediante `UC-33`, impidiendo nuevas cargas de Pedidos y revocando desafíos/sesiones online cuando pasa a `INACTIVO`, pero conservando su identidad, su Cuenta Corriente y sus Pedidos `PENDIENTE` abiertos.
3. **Tipo:** `Sistema`
4. **Referencias cruzadas:** Caso de Uso `UC-38 — Cambiar Estado de Cliente`; incluye `UC-33 — Buscar Cliente`; Pendiente `F09`; Objetivo `OBJE-02`; Requisito `RF-03`.
5. **Notas:** Exclusivo del `Administrador`. La inactivación no cancela automáticamente los Pedidos abiertos ni impide registrar cobros (`UC-29`) para cancelar deuda previa.
6. **Excepciones:**
   * **A1 — `UC-33` finalizó sin selección válida:** No ejecutar cambios.
   * **A2 — El `Cliente` ya posee el `nuevoEstado` solicitado:** Informar ausencia de cambio.
   * **A3 — Reactivación (`nuevoEstado = ACTIVO`) solicitada cuando los datos obligatorios del Cliente están incompletos o inválidos:** Exigir corrección previa en `UC-32`.
   * **A4 — Conflicto concurrente o falla de persistencia (`F09`):** Conservar el estado anterior sin alteraciones parciales.
7. **Salida:**
   * Confirmación del nuevo `Cliente.estado` (`ACTIVO` | `INACTIVO`); o mensajes provocados por las excepciones A1–A4.
8. **Precondiciones:**
   * El `Administrador` se encuentra autenticado y autorizado, y existe el `Cliente` seleccionado mediante `UC-33`.
9. **Postcondiciones:**
   * Se modificó el atributo `unCliente.estado` al valor `nuevoEstado` (`ACTIVO` o `INACTIVO`).
   * Si `nuevoEstado == INACTIVO`, se revocaron los `DesafioAutenticacionCliente` y sesiones online pendientes del Cliente, conservando intactos sus `Pedido` abiertos y su Cuenta Corriente.

---

## 5. Contrato de la Operación `configurarPoliticaCategoriaComercial` (`UC-57`)

1. **Nombre:** `configurarPoliticaCategoriaComercial(diasToleranciaMora: Integer, porcentajeDescuentoCumplidor: BigDecimal, porcentajeRecargoMora: BigDecimal, vigenteDesde: Timestamp, vigenteHasta: Timestamp[0..1])`
2. **Responsabilidades:** Registrar una nueva versión histórica de `PoliticaCategoriaComercial` con su umbral `diasToleranciaMora` y sus porcentajes de descuento para `CUMPLIDOR` y recargo para `EN_MORA`, cerrando la vigencia anterior sin solapamientos y sin alterar ajustes ya congelados en Pedidos previos.
3. **Tipo:** `Sistema`
4. **Referencias cruzadas:** Caso de Uso `UC-57 — Configurar Política de Categoría Comercial`; Caso de Uso `UC-15 — Evaluar y Actualizar Categoría Comercial`; Caso de Uso `UC-16 — Aplicar Ajuste Comercial según Categoría`; Objetivos `OBJE-10`, `OBJE-11`; Requisitos `RF-12`, `RF-15`.
5. **Notas:** No existen valores numéricos predeterminados por defecto (como «15 días» fijos) si no fueron configurados explícitamente en `PoliticaCategoriaComercial`.
6. **Excepciones:**
   * **A1 — Actor sin autorización administrativa:** Rechazar la configuración.
   * **A2 — `diasToleranciaMora < 0`, `porcentajeDescuentoCumplidor < 0` o `>= 100`, o `porcentajeRecargoMora < 0`:** Solicitar corrección de los parámetros.
   * **A3 — Intervalo `[vigenteDesde, vigenteHasta)` inválido o superpuesto con otra versión:** Rechazar la configuración conservando la versión vigente previa.
   * **A4 — Cancelación o conflicto concurrente de persistencia:** Revertir la operación sin cambios parciales.
7. **Salida:**
   * Confirmación de la nueva versión de `PoliticaCategoriaComercial` registrada y su período de vigencia; o mensajes de las excepciones A1–A4.
8. **Precondiciones:**
   * El `Administrador` se encuentra autenticado y autorizado.
9. **Postcondiciones:**
   * Si existía una versión vigente previa de `PoliticaCategoriaComercial`, se acotó su `vigenteHasta` sin solapamiento.
   * Se creó una nueva instancia vigente de `PoliticaCategoriaComercial` con `diasToleranciaMora`, `porcentajeDescuentoCumplidor`, `porcentajeRecargoMora`, `vigenteDesde` y `vigenteHasta` (`0..1`), preservando inalterados los ajustes congelados en `Pedido` históricos.

---

## 6. Contrato de la Operación `evaluarYActualizarCategoriaComercial` (`UC-15`)

1. **Nombre:** `evaluarYActualizarCategoriaComercial(idCliente: Long)`
2. **Responsabilidades:** Evaluar automáticamente la situación de deuda de un `Cliente` en su Cuenta Corriente imputando pagos/créditos contra las deudas más antiguas (FIFO), contrastar la antigüedad de la deuda impaga más antigua contra `diasToleranciaMora` de la `PoliticaCategoriaComercial` vigente y actualizar `Cliente.categoriaComercial` (`CUMPLIDOR` o `EN_MORA`) únicamente cuando corresponda un cambio real.
3. **Tipo:** `Sistema`
4. **Referencias cruzadas:** Caso de Uso `UC-15 — Evaluar y Actualizar Categoría Comercial`; incluido por `UC-05 — Registrar Entrega`, `UC-16 — Aplicar Ajuste Comercial según Categoría`, `UC-26 — Procesar Reembolso Electrónico`, `UC-29 — Registrar Cobro` y `UC-49 — Registrar Resultado de Reembolso Electrónico`; Objetivos `OBJE-10`, `OBJE-11`; Requisitos `RF-06`, `RF-12`, `RF-15`.
5. **Notas:** Las únicas categorías válidas son `CUMPLIDOR` y `EN_MORA`. El Cliente queda `EN_MORA` sí y solo sí `saldoDeudorConfirmado > 0` y `antiguedadDeudaImpagaMasAntiguaDias > diasToleranciaMora` (la igualdad exacta no constituye mora); en cualquier otro caso queda `CUMPLIDOR`. El origen de antigüedad de cada deuda es la `fechaHoraEntrega` de la `Entrega` confirmada (`CARGO_POR_VENTA`).
6. **Excepciones:**
   * **A1 — `Cliente` inexistente:** Rechazar la evaluación.
   * **A2 — Ausencia de `PoliticaCategoriaComercial` vigente:** Informar la incidencia de configuración sin inventar umbrales de mora por defecto.
   * **A3 — La categoría determinada coincide con la `Cliente.categoriaComercial` actual:** Conservar el valor actual sin registrar cambios de estado artificiales.
7. **Salida:**
   * Categoría comercial vigente resultante del `Cliente` (`CUMPLIDOR` | `EN_MORA`); o mensajes de las excepciones A1–A3.
8. **Precondiciones:**
   * Existe el `Cliente` identificado por `idCliente` y existe una `PoliticaCategoriaComercial` vigente.
9. **Postcondiciones:**
   * Se determinó la categoría comercial conforme a la imputación FIFO de créditos sobre cargos y al umbral `diasToleranciaMora` vigente.
   * Si la categoría determinada difirió de `unCliente.categoriaComercial`, se modificó `unCliente.categoriaComercial` al nuevo valor (`CUMPLIDOR` o `EN_MORA`) registrando su trazabilidad.

---

## 7. Contrato de la Operación `aplicarAjusteComercialSegunCategoria` (`UC-16` «include» `UC-15`)

1. **Nombre:** `aplicarAjusteComercialSegunCategoria(idCliente: Long, subtotalBaseLuegoPromocion: BigDecimal)`
2. **Responsabilidades:** Ejecutar `UC-15` para obtener la `categoriaComercial` actualizada del `Cliente`, recuperar la regla de ajuste de la `PoliticaCategoriaComercial` vigente (`DESCUENTO` para `CUMPLIDOR`, `RECARGO` para `EN_MORA` o `SIN_AJUSTE` si el porcentaje configurado es 0) y calcular/congelar el ajuste comercial y el `totalOriginal` del Pedido en formación (`UC-03` o `UC-21`).
3. **Tipo:** `Sistema`
4. **Referencias cruzadas:** Caso de Uso `UC-16 — Aplicar Ajuste Comercial según Categoría`; incluye `UC-15 — Evaluar y Actualizar Categoría Comercial`; incluido por `UC-03 — Cargar Pedido` y `UC-21 — Realizar Pedido Online`; Objetivo `OBJE-11`; Requisitos `RF-12`, `RF-15`.
5. **Notas:** En `UC-21` se aplica sobre el subtotal resultante luego de restar el mejor descuento promocional sin acumulación (`RD-RP023-001`). En `UC-07` (reasignación de excedentes) no se vuelve a ejecutar `UC-16`.
6. **Excepciones:**
   * **A1 — Fallo o falta de `PoliticaCategoriaComercial` vigente al ejecutar `UC-15`:** Impedir confirmar el Pedido con porcentajes inventados.
   * **A2 — `subtotalBaseLuegoPromocion < 0`:** Rechazar el cálculo por inconsistencia de importes.
7. **Salida:**
   * Resumen comercial con `categoriaComercialAplicada`, `tipoAjuste` (`DESCUENTO` | `RECARGO` | `SIN_AJUSTE`), `porcentajeAjuste`, `importeAjuste` y `totalOriginal` resultante; o mensajes de las excepciones A1–A2.
8. **Precondiciones:**
   * Existe el `Cliente` en estado `ACTIVO`, existe un `Pedido` en construcción (`UC-03` o `UC-21`) con `subtotalBaseLuegoPromocion >= 0` y existe una `PoliticaCategoriaComercial` vigente.
9. **Postcondiciones:**
   * Se ejecutaron las postcondiciones de `UC-15`.
   * Quedaron determinados y congelados para el `Pedido` los atributos `categoriaComercialAplicada`, `tipoAjuste`, `porcentajeAjuste` y `totalOriginal` vinculados a la `PoliticaCategoriaComercial` vigente.

---

## 8. Contrato de la Operación `buscarInsumo` (`UC-36`)

1. **Nombre:** `buscarInsumo(idInsumo: Long[0..1], nombre: String[0..1], activo: Boolean[0..1])`
2. **Responsabilidades:** Localizar y presentar en modo solo lectura los `Insumo` registrados (activos o inactivos) que cumplan los criterios informados, devolviendo el `Insumo` seleccionado al caso de uso invocante.
3. **Tipo:** `Sistema`
4. **Referencias cruzadas:** Caso de Uso `UC-36 — Buscar Insumo`; incluido por `UC-10 — Configurar Receta de Producto`, `UC-31 — Configurar Parámetros de Reposición de Insumo`, `UC-51 — Modificar Insumo` *(aprobada 25/10)* y `UC-52 — Cambiar Estado de Insumo` *(aprobada 25/10)*; Objetivo `OBJE-07`; Requisitos `RF-04`, `RF-05`.
5. **Notas:** Conforme a §6.1 del Documento Maestro, los actores autorizados para `UC-36` son **Administrador y Responsable de Producción**. Operación estrictamente de solo lectura.
6. **Excepciones:**
   * **A1 — Criterios inválidos o actor sin autorización:** Solicitar corrección o rechazar la consulta.
   * **A2 — Sin Insumos coincidentes:** Informar ausencia de resultados sin modificar el catálogo.
   * **A3 — Finalización sin selección:** Concluir la búsqueda sin referencia seleccionada.
7. **Salida:**
   * Listado de `Insumo` coincidentes (`idInsumo`, `nombre`, `codigoUnidadMedida`, `stockActual`, `umbralMinimo`, `nivelObjetivoReposicion`, `activo`) y referencia del `Insumo` seleccionado; o mensajes de las excepciones A1–A3.
8. **Precondiciones:**
   * El actor autorizado (`Administrador` o `Responsable de Producción`) se encuentra autenticado.
9. **Postcondiciones:**
   * *(Sin cambios de estado en el sistema: no se modifican existencias, costos ni datos maestros de `Insumo`)*.

---

## 9. Contrato de la Operación `configurarRecetaProducto` (`UC-10` «include» `UC-35`, `UC-36`)

1. **Nombre:** `configurarRecetaProducto(idProducto: Long, cantidadRendimientoBase: BigDecimal, codigoUnidadRendimiento: String, vigenteDesde: Timestamp, vigenteHasta: Timestamp[0..1], itemsInsumo: List<ItemRecetaDTO>)`
2. **Responsabilidades:** Registrar una nueva `VersionReceta` para un `Producto` de `tipoProducto = ELABORADO` (localizado mediante `UC-35`) junto con sus `DetalleVersionReceta` compuestos por `Insumo` activos (localizados mediante `UC-36`), cerrando la vigencia de la versión anterior sin sobrescribirla y preservando la trazabilidad de las `Preparacion` históricas.
3. **Tipo:** `Sistema`
4. **Referencias cruzadas:** Caso de Uso `UC-10 — Configurar Receta de Producto`; incluye `UC-35 — Buscar Producto` y `UC-36 — Buscar Insumo`; Objetivo `OBJE-07`; Requisito `RF-05`.
5. **Notas:** Los Productos con `tipoProducto = REVENTA` no admiten Receta. Este caso de uso no modifica los parámetros de reposición de los Insumos (administrados en `UC-31`).
6. **Excepciones:**
   * **A1 — El `Producto` seleccionado no existe o su `tipoProducto` es `REVENTA`:** Rechazar la configuración de Receta.
   * **A2 — `cantidadRendimientoBase <= 0`, lista `itemsInsumo` vacía, `Insumo` repetido/inactivo (`activo = false`) o `cantidadNecesaria <= 0`:** Solicitar corrección sin confirmar la versión.
   * **A3 — Intervalo `[vigenteDesde, vigenteHasta)` inválido o superpuesto con otra versión de la misma Receta:** Rechazar la confirmación conservando la versión vigente previa.
   * **A4 — Cancelación o fallo de persistencia:** Revertir toda la operación sin crear versiones parciales.
7. **Salida:**
   * Confirmación de la `Receta` y del nuevo `numeroVersion` de `VersionReceta` registrado con su vigencia e Insumos asociados; o mensajes de las excepciones A1–A4.
8. **Precondiciones:**
   * El `Administrador` se encuentra autenticado y autorizado, el `Producto` seleccionado mediante `UC-35` es de `tipoProducto = ELABORADO` y los `Insumo` seleccionados mediante `UC-36` tienen `activo = true`.
9. **Postcondiciones:**
   * Se creó (si era la primera versión) o recuperó la instancia de `Receta` asociada al `Producto` `ELABORADO`, cerrando `vigenteHasta` de la `VersionReceta` previa sin solapamiento.
   * Se creó una nueva instancia `nuevaVersion` de `VersionReceta` con `numeroVersion` correlativo, `cantidadRendimientoBase`, `codigoUnidadRendimiento`, `vigenteDesde` y `vigenteHasta` (`0..1`).
   * Para cada elemento en `itemsInsumo`, se creó una instancia de `DetalleVersionReceta` asociada a `nuevaVersion` y al `Insumo`, con `cantidadNecesaria` y unidad compatible.

---

## 10. Contrato de la Operación `configurarParametrosReposicionInsumo` (`UC-31` «include» `UC-36`)

1. **Nombre:** `configurarParametrosReposicionInsumo(idInsumo: Long, umbralMinimo: BigDecimal, nivelObjetivoReposicion: BigDecimal, automatizacionCompraActiva: Boolean)`
2. **Responsabilidades:** Actualizar los parámetros de control de reposición (`umbralMinimo`, `nivelObjetivoReposicion` y `automatizacionCompraActiva`) de un `Insumo` previamente localizado mediante `UC-36` para futuras evaluaciones de stock.
3. **Tipo:** `Sistema`
4. **Referencias cruzadas:** Caso de Uso `UC-31 — Configurar Parámetros de Reposición de Insumo`; incluye `UC-36 — Buscar Insumo`; Proceso `PRA-01`; Objetivo `OBJE-07`; Requisito `RF-05`.
5. **Notas:** Actualizar `umbralMinimo` en `UC-31` **no dispara una ronda automática retroactiva** (`PRA-01`). Un `EpisodioFaltante` abierto solo se cierra si `stockActual >= umbralMinimo` y no existen `SolicitudCotizacion` abiertas ni `OrdenCompra` pendientes.
6. **Excepciones:**
   * **A1 — `UC-36` finalizó sin selección válida:** No modificar parámetros.
   * **A2 — `umbralMinimo < 0` o `nivelObjetivoReposicion <= umbralMinimo`:** Solicitar corrección y conservar los parámetros vigentes.
   * **A3 — Cancelación o error de persistencia:** Mantener sin cambios los parámetros anteriores.
7. **Salida:**
   * Confirmación de los nuevos parámetros de reposición registrados en el `Insumo`; o mensajes de las excepciones A1–A3.
8. **Precondiciones:**
   * El actor autorizado (`Responsable de Producción` o `Administrador`) se encuentra autenticado y existe el `Insumo` seleccionado mediante `UC-36`.
9. **Postcondiciones:**
   * Se modificaron en `unInsumo` los atributos `umbralMinimo`, `nivelObjetivoReposicion` y `automatizacionCompraActiva` (sin alterar `stockActual` ni `codigoUnidadMedida`).
   * Si existía un `EpisodioFaltante` abierto para `unInsumo`, `unInsumo.stockActual >= umbralMinimo` y no existían Solicitudes abiertas ni Órdenes pendientes, se registró el cierre del episodio (`fechaHoraCierre`).

---

## 11. Contrato de la Operación `cambiarEstadoInsumo` (`UC-52` «include» `UC-36`)

1. **Nombre:** `cambiarEstadoInsumo(idInsumo: Long, nuevoActivo: Boolean)`
2. **Responsabilidades:** Desactivar o reactivar lógicamente un `Insumo` (previamente localizado mediante `UC-36`), actualizando su condición `activo` sin borrar costos, consumos, compras ni vínculos históricos e impidiendo nuevas rondas automáticas (`PRA-01`) mientras permanezca inactivo.
3. **Tipo:** `Sistema`
4. **Referencias cruzadas:** Caso de Uso `UC-52 — Cambiar Estado de Insumo`; incluye `UC-36 — Buscar Insumo` *(relación aprobada el 25/10/2026)*; Pendiente `F09`; Objetivo `OBJE-07`; Requisitos `RF-04`, `RF-05`.
5. **Notas:** Conforme a la ficha Extendida y Real de `UC-52`, antes de confirmar el cambio el sistema presenta las dependencias vigentes (Solicitudes, Órdenes u otras referencias) sin cancelarlas implícitamente ni producir movimientos de inventario.
6. **Excepciones:**
   * **A1 — No se identifica o selecciona el `Insumo` en `UC-36`:** No realizar cambios.
   * **A2 — El estado `nuevoActivo` solicitado coincide con el `Insumo.activo` actual:** Informar ausencia de cambio.
   * **A3 — Cancelación del Administrador o error/conflicto concurrente de persistencia (`F09`):** Mantener el estado original del Insumo.
7. **Salida:**
   * Confirmación del estado `Insumo.activo` resultante (`true` | `false`) y exposición de sus dependencias históricas conservadas; o mensajes de las excepciones A1–A3.
8. **Precondiciones:**
   * El `Administrador` se encuentra autenticado y autorizado, y existe el `Insumo` seleccionado mediante `UC-36`.
9. **Postcondiciones:**
   * Se modificó el atributo `unInsumo.activo` al valor `nuevoActivo`.
   * Se conservaron íntegramente su identidad, `stockActual`, `CostoInsumoHistorico`, `MovimientoInsumo`, `SolicitudCotizacion` y `OrdenCompra` históricas, quedando excluido de nuevas operaciones y de nuevas rondas automáticas mientras `activo == false`.

---

## 12. Contrato de la Operación `consultarStock` (`UC-09`)

1. **Nombre:** `consultarStock(tipoInventario: String[0..1], idElemento: Long[0..1], soloBajoUmbral: Boolean[0..1])`
2. **Responsabilidades:** Consultar y presentar en modo solo lectura las existencias actuales separadas del inventario de `Insumo` (`stockActual`, `umbralMinimo`, `nivelObjetivoReposicion` y alertas de `EpisodioFaltante`) y del inventario de `Producto` de `REVENTA` (`stockActualReventa`), sin combinarlos como una única existencia.
3. **Tipo:** `Sistema`
4. **Referencias cruzadas:** Caso de Uso `UC-09 — Consultar Stock`; Caso de Uso `UC-64 — Consultar Movimientos de Inventario`; Decisión `RD-RP022-001`; Objetivos `OBJE-05`, `OBJE-07`; Requisitos `RF-04`, `RF-05`.
5. **Notas:** Los Productos `ELABORADO` no poseen stock general de producto terminado (se gestionan por `Preparacion` en `UC-28` y `Excedente` en `UC-61`). Operación estrictamente de solo lectura.
6. **Excepciones:**
   * **A1 — Filtros inválidos o actor sin permiso para el inventario solicitado:** Solicitar corrección o rechazar el acceso.
   * **A2 — Sin elementos coincidentes:** Informar lista vacía sin modificar registros.
7. **Salida:**
   * Estado actual de existencias separadas por tipo de inventario (`INSUMO` con unidad, stock, umbrales y alerta de faltante; `PRODUCTO REVENTA` con unidad y stock actual); o mensajes de las excepciones A1–A2.
8. **Precondiciones:**
   * El actor autorizado (`Responsable de Producción` o `Administrador`) se encuentra autenticado.
9. **Postcondiciones:**
   * *(Sin cambios de estado en el sistema: operación de solo lectura)*.

---

## 13. Contrato de la Operación `consultarMovimientosInventario` (`UC-64`)

1. **Nombre:** `consultarMovimientosInventario(tipoInventario: String, idElemento: Long[0..1], tipoMovimiento: String[0..1], fechaDesde: LocalDate[0..1], fechaHasta: LocalDate[0..1])`
2. **Responsabilidades:** Consultar en modo solo lectura el historial cronológico de movimientos de `MOVIMIENTO_INSUMO` o de `MOVIMIENTO_STOCK_REVENTA` según el inventario elegido, presentando cantidades, `stockResultante` y referencias de origen (`Preparacion`, `RecepcionCompra`, `Entrega`, ajustes o `SALDO_INICIAL`), manteniendo estrictamente separados ambos inventarios y ocultando costos si el rol no tiene autorización para verlos.
3. **Tipo:** `Sistema`
4. **Referencias cruzadas:** Caso de Uso `UC-64 — Consultar Movimientos de Inventario`; Caso de Uso `UC-09 — Consultar Stock`; Decisión `RD-RP022-001`; Objetivo `OBJE-07`; Requisitos `RF-04`, `RF-05`.
5. **Notas:** Conforme a la ficha Extendida y Real de `UC-64`, `MOVIMIENTO_INSUMO` y `MOVIMIENTO_STOCK_REVENTA` jamás se combinan como un saldo único, y los movimientos de `Excedente` se consultan en su propio contexto (`UC-61`).
6. **Excepciones:**
   * **A1 — (pasos 2–4) `tipoInventario` o filtros inválidos:** Solicitar corrección y no ejecutar la consulta.
   * **A2 — (pasos 4–5) No existen movimientos coincidentes:** Informar ausencia de resultados (lista vacía).
   * **A3 — (paso 6) Datos de costo u origen restringidos para el rol del actor:** Ocultar exclusivamente esos campos restringidos sin revelar información adicional.
   * **A4 — (pasos 7–8) Movimiento seleccionado inexistente o fuera del alcance autorizado:** Impedir la consulta de su detalle.
7. **Salida:**
   * Listado cronológico y detalle autorizado de movimientos (`fechaHoraMovimiento`, `tipoMovimiento`, `cantidad`, `stockResultante`, origen/referencia histórica y costo cuando el rol esté autorizado); o mensajes de las excepciones A1–A4.
8. **Precondiciones:**
   * El actor autorizado (`Responsable de Producción` o `Administrador`) se encuentra autenticado.
9. **Postcondiciones:**
   * *(Sin cambios de estado en el sistema: no se registran nuevos movimientos ni se alteran las existencias ni los costos históricos)*.