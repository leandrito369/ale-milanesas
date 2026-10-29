# Contratos de Operación del Sistema (DSS — REV-03A) — Compras y Cotizaciones (6 Contratos Individuales)

**Proyecto:** Sistema de Gestión para Ale Milanesas (UNaM-FCEQyN)  

**Lote de revisión:** `REV-03A` (`UC-58`, `UC-44`, `UC-62`, `UC-63`, `UC-13`, `UC-12`)  

**Decisiones incorporadas:** `RD-RP013-001` (`H-02`, `H-08`: suma de pesos activos = 100 %, identificación expresa de cotizaciones incompletas, aplicación de `ordenDesempate` y desempate final por Administrador), `RD-RP012-001` (`H-16`: fuente del plazo por parámetro global con vencimiento congelado y firma de `UC-58` desacoplada) y relación `include` aprobada el 25/10/2026 (`UC-12→UC-62`).

---

## 1. Contrato de la Operación `configurarPoliticaCompra` (`UC-58`)

1. **Nombre:** `configurarPoliticaCompra(vigenteDesde: Timestamp, vigenteHasta: Timestamp[0..1], periodoCalculoDias: Integer, criterios: List<CriterioPoliticaDTO>)`

2. **Responsabilidades:** Registrar una nueva versión verificable de `PoliticaCompra` y sus `CriterioPoliticaCompra` asociados, validando que la suma de `pesoRelativo` de los criterios activos sea exactamente igual al **100 %** y que cada criterio posea un `ordenDesempate` válido, sin modificar decisiones de compra ni evaluaciones pasadas.

3. **Tipo:** `Sistema`

4. **Referencias cruzadas:** Caso de Uso `UC-58 — Configurar Política de Compra`; Caso de Uso `UC-12 — Evaluar Cotizaciones y Resolver Compra`; Decisiones `RD-RP013-001` y `RD-RP012-001`; Objetivo `OBJE-09`; Requisitos `RF-05`, `RF-11`; Información `IRQ-08`.

5. **Notas:** Conforme a `RD-RP013-001`, los pesos relativos de los criterios activos deben sumar **100 %**; en la evaluación (`UC-12`), toda cotización u oferta con datos faltantes se identifica como **incompleta** (sin asignarle puntaje cero silencioso ni imponer un desempate fijo por precio total al margen de `ordenDesempate`). Conforme a `RD-RP012-001`, `periodoCalculoDias` delimita la ventana histórica de indicadores (confiabilidad/habitualidad) y no fija el plazo de respuesta de `SolicitudCotizacion`.

6. **Excepciones:**

   * **A1 — Suma de pesos distinta de 100 % (`sumaPesosActivos \!= 100`):** Rechazar la configuración y solicitar ajustar las ponderaciones (`RD-RP013-001`).

   * **A2 — `codigoCriterio` repetido, `pesoRelativo < 0` u `ordenDesempate <= 0` o duplicado:** Impedir la confirmación.

   * **A3 — Fechas inválidas, `periodoCalculoDias <= 0` o intervalo `[vigenteDesde, vigenteHasta)` superpuesto con otra versión:** Rechazar la configuración conservando la versión vigente previa.

7. **Salida:**

   * Confirmación del `numeroVersion` y vigencia de la nueva `PoliticaCompra` registrada, o mensajes de rechazo provocados por las excepciones A1–A3.

8. **Precondiciones:**

   * El `Administrador` se encuentra autenticado y autorizado.

9. **Postcondiciones:**

   * Si existía una versión vigente anterior de `PoliticaCompra`, se acotó su `vigenteHasta` sin generar solapamiento temporal ni alterar `DecisionCompra` históricas.

   * Se creó una instancia `nuevaPolitica` de `PoliticaCompra` con `numeroVersion` correlativo, `vigenteDesde`, `vigenteHasta` y `periodoCalculoDias`.

   * Para cada criterio configurado en `criterios` (cuya suma de `pesoRelativo` es igual a 100 %), se creó una instancia de `CriterioPoliticaCompra` asociada a `nuevaPolitica` con `codigoCriterio`, `pesoRelativo` y `ordenDesempate`.

---

## 2. Contrato de la Operación `iniciarRondaManualCotizacion` (`UC-44`)

1. **Nombre:** `iniciarRondaManualCotizacion(idInsumo: Long, idSolicitudAnterior: Long[0..1], idsProveedoresInvitados: List<Long>)`

2. **Responsabilidades:** Emitir por decisión administrativa una `SolicitudCotizacion` con `modalidadInicio = MANUAL` dentro de un `EpisodioFaltante` abierto y sin operaciones en curso, congelando la `cantidadSolicitada` y la `fechaHoraVencimiento` (determinada a partir del parámetro global vigente) y publicando las `InvitacionCotizacion` para los Proveedores invitables seleccionados.

3. **Tipo:** `Sistema`

4. **Referencias cruzadas:** Caso de Uso `UC-44 — Iniciar Ronda Manual de Cotización`; Decisión `RD-RP012-001`; Objetivos `OBJE-07`, `OBJE-09`; Requisitos `RF-05`, `RF-11`; Información `IRQ-07`, `IRQ-08`.

5. **Notas:** Existe a lo sumo una primera ronda `AUTOMATICA` por episodio (`PRA-01`); toda ronda ulterior se emite mediante `UC-44` manteniendo una cadena lineal (`idSolicitudAnterior` `0..1`) sin bifurcaciones. Un `Proveedor` es invitable solo si está `ACTIVO`, tiene vínculo vigente en `ProveedorInsumo` para el `Insumo` y posee cuenta de `Usuario` habilitada en `UsuarioProveedor`. El plazo de respuesta se toma de la configuración global (`RD-RP012-001`), sin asumir «48 horas» como defecto fijo.

6. **Excepciones:**

   * **A1 — `Insumo` inactivo, sin faltante vigente (`stockActual >= umbralMinimo`) o `cantidadSolicitada <= 0`:** Rechazar el inicio de la ronda.

   * **A2 — Existe otra `SolicitudCotizacion` abierta u `OrdenCompra` pendiente para el mismo episodio, o `idSolicitudAnterior` intenta bifurcar la cadena:** Bloquear la emisión.

   * **A3 — Lista `idsProveedoresInvitados` vacía o algún destinatario seleccionado carece de condición `ACTIVO` o de cuenta `Usuario` habilitada al confirmar:** Rechazar la emisión sin crear Solicitud parcial.

7. **Salida:**

   * Confirmación del `idSolicitud`, `cantidadSolicitada`, `fechaHoraVencimiento` congelada y Proveedores invitados habilitados en el portal; o mensajes provocados por las excepciones A1–A3.

8. **Precondiciones:**

   * El `Administrador` se encuentra autenticado y autorizado.

   * El `Insumo` está `ACTIVO` con `stockActual < umbralMinimo`, existe un `EpisodioFaltante` abierto sin Solicitud abierta ni Orden pendiente, y está configurado el parámetro global del plazo de respuesta a cotizaciones (`RD-RP012-001`).

9. **Postcondiciones:**

   * Se creó una instancia `nuevaSolicitud` de `SolicitudCotizacion` con `modalidadInicio = MANUAL`, `estado = RECEPCION_ABIERTA`, `cantidadSolicitada = nivelObjetivoReposicion - stockActual`, `fechaHoraEmision` y `fechaHoraVencimiento` congeladas.

   * Se asoció `nuevaSolicitud` con el `EpisodioFaltante`, con el `Insumo`, con el `Usuario` Administrador y con la `SolicitudCotizacion` antecedente (`idSolicitudAnterior` `0..1`).

   * Para cada Proveedor en `idsProveedoresInvitados`, se creó una instancia histórica e irrevocable de `InvitacionCotizacion` asociada a `nuevaSolicitud` y al `Proveedor`.

---

## 3. Contrato de la Operación `buscarSolicitudCotizacion` (`UC-62`)

1. **Nombre:** `buscarSolicitudCotizacion(idSolicitud: Long[0..1], idInsumo: Long[0..1], idEpisodio: Long[0..1], modalidadInicio: String[0..1], estado: String[0..1])`

2. **Responsabilidades:** Localizar y presentar en modo solo lectura las `SolicitudCotizacion` que cumplan los criterios indicados junto con su estado de recepción, invitaciones y eslabón antecedente, devolviendo la referencia seleccionada al flujo invocante (`UC-12` o seguimiento administrativo).

3. **Tipo:** `Sistema`

4. **Referencias cruzadas:** Caso de Uso `UC-62 — Buscar Solicitud de Cotización`; incluido por `UC-12 — Evaluar Cotizaciones y Resolver Compra` **(relación aprobada el 25/10/2026)**; Objetivo `OBJE-09`; Requisitos `RF-05`, `RF-11`.

5. **Notas:** Operación estrictamente de solo lectura. No emite ni cierra Solicitudes ni Órdenes de Compra.

6. **Excepciones:**

   * **A1 — Criterios de búsqueda inválidos:** Solicitar corrección sin ejecutar la consulta.

   * **A2 — Sin Solicitudes coincidentes:** Informar resultado vacío.

7. **Salida:**

   * Listado de `SolicitudCotizacion` coincidentes y detalle de la seleccionada (`Insumo`, `cantidadSolicitada`, `fechaHoraEmision`, `fechaHoraVencimiento`, `fechaHoraFinRecepcion`, `estado`, `modalidadInicio`, `motivoCierre`, `idSolicitudAnterior` e invitaciones); o mensajes de las excepciones A1–A2.

8. **Precondiciones:**

   * El `Administrador` se encuentra autenticado y autorizado.

9. **Postcondiciones:**

   * **(Sin cambios de estado en el sistema: no se crean ni modifican instancias de `SolicitudCotizacion`, `RespuestaCotizacion` ni `OrdenCompra`)**.

---

## 4. Contrato de la Operación `consultarSolicitudesCotizacionRecibidas` (`UC-63`)

1. **Nombre:** `consultarSolicitudesCotizacionRecibidas(idSolicitudSeleccionada: Long[0..1])`

2. **Responsabilidades:** Mostrar exclusivamente las `SolicitudCotizacion` para las que consta una `InvitacionCotizacion` histórica dirigida al `Proveedor` vinculado al `Usuario` `PROVEEDOR` autenticado, distinguiendo las abiertas sin respuesta de las cerradas, vencidas o ya respondidas por ese mismo Proveedor.

3. **Tipo:** `Sistema`

4. **Referencias cruzadas:** Caso de Uso `UC-63 — Consultar Solicitudes de Cotización Recibidas`; Caso de Uso `UC-13 — Responder Solicitud de Cotización`; Objetivo `OBJE-09`; Requisito `RF-11`.

5. **Notas:** Operación estrictamente de solo lectura. Jamás expone invitaciones ni respuestas de otros Proveedores.

6. **Excepciones:**

   * **A1 — Cuenta no habilitada, sin Rol exclusivo `PROVEEDOR` o con `cambioCredencialPendiente = true`:** Negar la consulta operativa.

   * **A2 — Sin invitaciones registradas para el Proveedor autenticado:** Informar resultado vacío.

   * **A3 — `idSolicitudSeleccionada` no fue dirigida al Proveedor autenticado:** Negar el acceso al detalle aunque se conozca el identificador.

7. **Salida:**

   * Listado de `SolicitudCotizacion` invitadas (`Insumo`, `cantidadSolicitada`, `UnidadMedida`, `fechaHoraVencimiento`, `estado`, existencia de `RespuestaCotizacion` propia) y detalle de la seleccionada con la respuesta propia si existe; o mensajes de las excepciones A1–A3.

8. **Precondiciones:**

   * El actor se encuentra autenticado con cuenta `HABILITADO` de Rol exclusivo `PROVEEDOR`, vinculada a un único `Proveedor`, y con `cambioCredencialPendiente = false`.

9. **Postcondiciones:**

   * **(Sin cambios de estado en el sistema: ninguna `RespuestaCotizacion` ni `SolicitudCotizacion` fue creada o modificada)**.

---

## 5. Contrato de la Operación `responderSolicitudCotizacion` (`UC-13`)

1. **Nombre:** `responderSolicitudCotizacion(idSolicitud: Long, precioUnitario: BigDecimal, cantidadOfrecida: BigDecimal, tiempoEntregaEstimado: Interval)`

2. **Responsabilidades:** Registrar por única vez y con carácter definitivo e inmutable las condiciones estructuradas de suministro informadas en el portal web por un `Proveedor` invitado frente a una `SolicitudCotizacion` en `RECEPCION_ABIERTA` y dentro de su `fechaHoraVencimiento`.

3. **Tipo:** `Sistema`

4. **Referencias cruzadas:** Caso de Uso `UC-13 — Responder Solicitud de Cotización`; Caso de Uso `UC-12 — Evaluar Cotizaciones y Resolver Compra`; Objetivo `OBJE-09`; Requisito `RF-11`.

5. **Notas:** No se admiten cargas por teléfono/mensajería ni interpretación de texto libre. Cada invitación admite a lo sumo una única `RespuestaCotizacion` definitiva e inmutable; su elegibilidad comercial e integridad de datos para cubrir la solicitud se evalúan en `UC-12`.

6. **Excepciones:**

   * **A1 — La Solicitud no existe o no posee `InvitacionCotizacion` para el Proveedor autenticado:** Rechazar la operación.

   * **A2 — Campos estructurados inválidos (`precioUnitario`, `cantidadOfrecida` o `tiempoEntregaEstimado`):** Solicitar corrección antes de confirmar.

   * **A3 — Ya consta una `RespuestaCotizacion` definitiva previa del mismo Proveedor para esa Solicitud:** Rechazar el registro de una segunda respuesta.

   * **A4 — La Solicitud ya no está en `RECEPCION_ABIERTA`, superó `fechaHoraVencimiento` o el Proveedor dejó de estar `ACTIVO` al confirmar:** Rechazar el registro sin crear respuesta tardía.

7. **Salida:**

   * Confirmación del registro definitivo de la `RespuestaCotizacion` con su `idRespuesta` y `fechaHoraRespuesta`, o mensajes provocados por las excepciones A1–A4.

8. **Precondiciones:**

   * El actor está autenticado con su Usuario `PROVEEDOR` habilitado (`cambioCredencialPendiente = false`), su `Proveedor` comercial está `ACTIVO`, consta `InvitacionCotizacion` para `idSolicitud` y no existe respuesta definitiva previa de ese Proveedor para dicha Solicitud.

9. **Postcondiciones:**

   * Se creó una única instancia `unaRespuesta` de `RespuestaCotizacion` con carácter definitivo e inmutable.

   * Se inicializaron `unaRespuesta.precioUnitario`, `unaRespuesta.cantidadOfrecida`, `unaRespuesta.tiempoEntregaEstimado` y `unaRespuesta.fechaHoraRespuesta` (validada `<= SolicitudCotizacion.fechaHoraVencimiento`).

   * Se asoció `unaRespuesta` con la `SolicitudCotizacion`, con el `Proveedor` comercial y con el `Usuario` `PROVEEDOR` registrador.

---

## 6. Contrato de la Operación `evaluarCotizacionesYResolverCompra` (`UC-12` «include» `UC-62`)

1. **Nombre:** `evaluarCotizacionesYResolverCompra(idSolicitud: Long, decision: String, idRespuestaElegida: Long[0..1], justificacionOMotivo: String)`

2. **Responsabilidades:** Evaluar las `RespuestaCotizacion` recibidas para una `SolicitudCotizacion` con recepción cerrada (localizada mediante `UC-62`) aplicando la `PoliticaCompra` vigente (**identificando expresamente las cotizaciones incompletas, aplicando el `ordenDesempate` configurado y dejando al Administrador la decisión final si persiste el empate — `RD-RP013-001`**), y registrar la resolución comercial humana emitiendo una `OrdenCompra` `PENDIENTE` (`decision = COMPRAR`) o cerrando justificadamente la Solicitud `SIN_COMPRA` (`decision = NO_COMPRAR`).

3. **Tipo:** `Sistema`

4. **Referencias cruzadas:** Caso de Uso `UC-12 — Evaluar Cotizaciones y Resolver Compra`; incluye `UC-62 — Buscar Solicitud de Cotización` *(relación aprobada el 25/10/2026)*; Decisión `RD-RP013-001`; Objetivos `OBJE-07`, `OBJE-09`; Requisitos `RF-05`, `RF-11`; Información `IRQ-08`.

5. **Notas:** **Ninguna `OrdenCompra` se emite sin confirmación humana expresa del Administrador.** Conforme a `RD-RP013-001`, el sistema no adjudica por sí mismo ni oculta datos faltantes: señala expresamente toda cotización incompleta, ordena las ofertas elegibles según los pesos (100 %) y el `ordenDesempate` configurado en `PoliticaCompra`, y ante empate persistente o elección de otra alternativa elegible exige la decisión y justificación del Administrador.

6. **Excepciones:**

   * ***A1 — Recepción aún `ABIERTA`, Solicitud ya resuelta o sin ofertas elegibles:** Impedir la resolución mediante `UC-12` (si cerró con 0 respuestas o 0 ofertas elegibles, rige el cierre automático `SIN_RESPUESTAS` / `SIN_OFERTAS_ELEGIBLES`).

   * ***A2 — En `COMPRAR`, la oferta seleccionada es tardía, parcial, incompleta para cubrir la solicitud o su `Proveedor` dejó de estar `ACTIVO`:** Impedir confirmar la compra y solicitar revisar alternativas.

   * ***A3 — Falta `justificacionOMotivo` obligatorio (justificación de la elección al comprar o motivo de cierre al no comprar):** Rechazar la confirmación.

   * ***A4 — La necesidad de reposición desapareció antes de confirmar (`stockActual >= umbralMinimo`):** Informar el cambio y bloquear la emisión de una `OrdenCompra` innecesaria, permitiendo cerrar justificadamente `SIN_COMPRA`.

7. **Salida:**

   * En `COMPRAR`: confirmación de la `SolicitudCotizacion` resuelta `CON_COMPRA` e identificación de la `OrdenCompra` emitida en estado `PENDIENTE`.

   * En `NO_COMPRAR`: confirmación del cierre `SIN_COMPRA` (conservando la alerta del episodio si persiste el faltante para eventual ronda manual en `UC-44`); o mensajes de las excepciones A1–A4.

8. **Precondiciones:**

   * El `Administrador` se encuentra autenticado y autorizado.

   * Existe una `SolicitudCotizacion` (localizada mediante `UC-62`) con recepción finalizada, evaluación disponible conforme a `PoliticaCompra` vigente, al menos una `RespuestaCotizacion` elegible y sin resolución comercial previa.

9. **Postcondiciones:**

   * ***Si `decision = COMPRAR`:

     ** Se creó una instancia `unaDecision` de `DecisionCompra` con `resultado = CON_COMPRA`, `fechaHoraDecision` y `justificacion = justificacionOMotivo`, asociada a la `SolicitudCotizacion`, a la `PoliticaCompra` aplicada, a la `RespuestaCotizacion` elegida y al `Usuario` Administrador.

     ** Se crearon las instancias de `DetalleDecision` y `DetalleDecisionCriterio` preservando los valores, ponderaciones, identificación de cotizaciones incompletas y puntajes evaluados (`RD-RP013-001`).

     ** Se creó una única instancia `unaOrden` de `OrdenCompra` en estado `PENDIENTE` asociada a `unaDecision`, congelando `cantidadOrdenada`, `precioUnitarioAcordado`, `fechaHoraEmision` y `fechaHoraComprometidaEntrega`.

     ** Se modificó el estado de la `SolicitudCotizacion` a resuelta `CON_COMPRA`.

   * ***Si `decision = NO_COMPRAR`:

     ** Se modificó el estado de la `SolicitudCotizacion` a finalizada `SIN_COMPRA` registrando `motivoCierre = justificacionOMotivo`, fecha/hora y `Usuario` Administrador responsable, sin crear `OrdenCompra`.

---

## 7. Glosario de Términos Asociados (`REV-03A`)

** **`PoliticaCompra` (Tipo / Concepto — Tabla `POLITICA_COMPRA`):** Versión histórica de reglas de evaluación de cotizaciones con intervalo `[vigenteDesde, vigenteHasta)` y ventana `periodoCalculoDias`.

** **`CriterioPoliticaCompra` (Tipo / Concepto — Tabla `CRITERIO_***POLITICA*_COMPRA`):** Criterio integrante de una `PoliticaCompra` con `codigoCriterio`, `pesoRelativo` (cuya suma entre criterios activos es 100 % según `RD-RP013-001`) y `ordenDesempate`.

** **`SolicitudCotizacion` (Tipo / Concepto — Tabla `SOLICITUD_COTIZACION`):** Requerimiento formal de cotización de un `Insumo` dentro de un `EpisodioFaltante`, con `cantidadSolicitada` y `fechaHoraVencimiento` congeladas al emitirse (`RD-RP012-001`).

** **`InvitacionCotizacion` (Tipo / Concepto — Tabla `INVITACION_COTIZACION`):** Vínculo histórico e irrevocable entre una `SolicitudCotizacion` y un `Proveedor` invitable al momento de la emisión.

** **`RespuestaCotizacion` (Tipo / Concepto — Tabla `RESPUESTA_COTIZACION`):** Oferta estructurada única, definitiva e inmutable registrada por un `Proveedor` invitado dentro del plazo de recepción.

** **`DecisionCompra` (Tipo / Concepto — Tabla `DECISION_COMPRA`):** Resolución comercial humana tomada por el `Administrador` en `UC-12` que fundamenta la elección y origina una `OrdenCompra`.
