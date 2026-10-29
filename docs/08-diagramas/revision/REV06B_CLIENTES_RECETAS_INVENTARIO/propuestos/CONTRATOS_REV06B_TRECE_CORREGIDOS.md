# Contratos de Operación del Sistema (DSS — REV-06B) — Clientes, Categoría Comercial, Recetas e Inventario (13 Contratos Individuales)

**Proyecto:** Sistema de Gestión para Ale Milanesas (UNaM-FCEQyN)  
**Estado:** Propuesta corregida contra Fase 4 y MR-5/MR-6; inspección UML gráfica de lotes anteriores cerrada, sin certificación de las firmas REV-06B frente a diagramas.  
**Lote de revisión:** `REV-06B` (`UC-02`, `UC-33`, `UC-32`, `UC-38`, `UC-57`, `UC-15`, `UC-16`, `UC-36`, `UC-10`, `UC-31`, `UC-52`, `UC-09`, `UC-64`)  
**Cobertura nominal:** 13 operaciones públicas propuestas para los 13 CU no cubiertos en REV-01 a REV-06A. Al agregarlas a las 54 operaciones existentes se obtiene **67 contratos documentales para 64 CU distintos**; las 13 firmas de REV-06B **no se declaran homologadas a DSS/DS**, pues no hay DS/DSS de REV-06B publicados. Las firmas y los DTO son propuestas de interfaz, no API implementada.

---

## 1. Contrato de la Operación `registrarCliente` (`UC-02`)

1. **Nombre:** `registrarCliente(nombre: String, telefonoPrincipal: String, direccion: DireccionDTO, zona: String[0..1], diaHabitualReparto: Short[0..1])`

2. **Responsabilidades:** Registrar Cliente ACTIVO y categoría inicial CUMPLIDOR; validar campos de identidad/contacto/domicilio, controlar duplicación exacta por nombre y teléfono normalizados entre Clientes activos e inactivos y advertir coincidencias parciales sin bloquearlas automáticamente.

3. **Tipo:** `Sistema`
4. **Referencias cruzadas:** Caso de Uso `UC-02 — Registrar Cliente`; Objetivo `OBJE-01`; Requisito `RF-10`.
5. **Notas:** El `nombre` ingresado es un dato lógico de interfaz que debe mapearse a la identidad física vigente (`CLIENTE.nombres`, `apellidos` cuando corresponda); `direccion: DireccionDTO` se descompone en los campos atómicos existentes del domicilio. `nombreNormalizado` y `telefonoNormalizado` son valores calculados para búsqueda/validación, **no columnas nuevas**. `zona` y `diaHabitualReparto` son opcionales. Las coincidencias parciales se advierten y el teléfono puede compartirse si la identidad normalizada es distinta; la coincidencia exacta de nombre y teléfono impide crear un duplicado.

6. **Excepciones:** A1 — Datos identificatorios, teléfono o domicilio obligatorios inválidos: solicitar corrección sin confirmar alta. A2 — Coincidencia exacta con Cliente ACTIVO: presentar identidad existente sin crear otra. A3 — Coincidencia exacta con Cliente INACTIVO: no duplicar; informar que solo el Administrador puede reactivarlo mediante UC-38, nunca el Vendedor. A4 — Coincidencia parcial o teléfono compartido con otro nombre: advertir para verificación; no rechazar automáticamente por similitud. A5 — Desistimiento o error de persistencia: no crear registro parcial.

7. **Salida:**
   * Confirmación del `Cliente` registrado (`idCliente`, `estado = ACTIVO`, `categoriaComercial = CUMPLIDOR`); o mensajes de las excepciones A1–A3.
8. **Precondiciones:**
   * El actor autorizado (`Vendedor` o `Administrador`) se encuentra autenticado.
9. **Postcondiciones:** Se creó un `Cliente` ACTIVO, `categoriaComercial=CUMPLIDOR`, `fechaHoraAlta` y datos de identificación/contacto/domicilio mapeados a las columnas existentes (`nombres`, `apellidos` cuando proceda, `telefonoPrincipal`, `calle`, `numeroPuerta`, `piso`, `unidadFuncional`, `localidad`, `provincia`, `referenciaDomicilio`, `zona`, `diaHabitualReparto`). La normalización no implica almacenar `nombreNormalizado` como columna. No se crea Cliente ante coincidencia exacta o fallo.
---

## 2. Contrato de la Operación `buscarCliente` (`UC-33`)

1. **Nombre:** `buscarCliente(idCliente: Long[0..1], nombre: String[0..1], telefonoPrincipal: String[0..1], zona: String[0..1], estado: String[0..1])`
2. **Responsabilidades:** Localizar y presentar en modo solo lectura los `Cliente` registrados (activos o inactivos) que coincidan con los criterios informados, devolviendo la referencia seleccionada al caso de uso invocante.
3. **Tipo:** `Sistema`
4. **Referencias cruzadas:** Caso de Uso `UC-33 — Buscar Cliente`; referencias funcionales `UC-03`, `UC-14`, `UC-32` y `UC-38`; permisos RD-RP007-002; Objetivos `OBJE-01`, `OBJE-10`; Requisito `RF-10`.
5. **Notas:** Operación de solo lectura, directa/contextual para Administrador y Vendedor por RD-RP007-002. `nombre` del filtro y salida es una representación lógica derivada de `CLIENTE.nombres` y `apellidos` (sin atributo físico `nombre` ni `nombreNormalizado`); otros datos se consultan solo dentro del alcance autorizado y bajo mínimo privilegio.

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
4. **Referencias cruzadas:** Caso de Uso `UC-32 — Modificar Cliente`; incluye `UC-33 — Buscar Cliente`; Objetivos `OBJE-01`, `OBJE-10`; Requisito `RF-10`.
5. **Notas:** El actor principal de los tres niveles Fase 4 es el **Vendedor** autorizado para modificar datos permitidos; el permiso de búsqueda UC-33 del Administrador no equivale por sí mismo a una habilitación adicional de UC-32. UC-38 (solo Administrador) modifica estado, y UC-15 actualiza categoría. Si cambia `telefonoPrincipal`, invalidar los desafíos OTP **pendientes** del teléfono anterior sin revocar sesiones ONLINE previamente activas, de acuerdo con la ficha; conservar direcciones históricas congeladas de Pedidos. El DTO agrupa exclusivamente columnas existentes de CLIENTE, no estado/categoría.

6. **Excepciones:** A1 — UC-33 sin selección válida: no modificar. A2 — Datos obligatorios inválidos o coincidencia exacta de nombre y teléfono con otro Cliente, excluyendo el propio: rechazar sin modificar. A3 — Intento de alterar `estado` o `categoriaComercial` mediante UC-32: rechazar; corresponden a UC-38/UC-15. A4 — Coincidencia parcial de identidad/contacto: advertir sin bloquear automáticamente. A5 — Modificación de teléfono: invalidar OTP pendientes del número anterior, manteniendo sesiones ONLINE ya activas; toda la actualización es atómica. A6 — Cancelación, error o conflicto concurrente: conservar datos anteriores y no invalidar OTP parcialmente.

7. **Salida:**
   * Confirmación de la actualización de los datos comerciales del `Cliente`; o mensajes de las excepciones A1–A4.
8. **Precondiciones:** El **Vendedor** autenticado y autorizado identificó un Cliente existente mediante UC-33; la autorización concreta de UC-32 no se infiere de la mera capacidad de búsqueda del Administrador.

9. **Postcondiciones:** Se actualizaron únicamente los datos permitidos de `CLIENTE` (identidad/contacto/domicilio/zona/día habitual); se conservaron `estado`, `categoriaComercial` y las direcciones históricas de `PEDIDO`. Si el teléfono cambió, los desafíos OTP pendientes ligados al número anterior quedaron inutilizables por validación de negocio, **sin revocar sesiones ONLINE activas**; en fallo no hay cambios parciales. El DTO no agrega columnas.
---

## 4. Contrato de la Operación `cambiarEstadoCliente` (`UC-38` «include» `UC-33`)

1. **Nombre:** `cambiarEstadoCliente(idCliente: Long, nuevoEstado: String, motivo: String[0..1])`
2. **Responsabilidades:** Activar o desactivar lógicamente un `Cliente` previamente localizado mediante `UC-33`, impidiendo nuevas cargas de Pedidos y revocando desafíos/sesiones online cuando pasa a `INACTIVO`, pero conservando su identidad, su Cuenta Corriente y sus Pedidos `PENDIENTE` abiertos.
3. **Tipo:** `Sistema`
4. **Referencias cruzadas:** Caso de Uso `UC-38 — Cambiar Estado de Cliente`; incluye `UC-33 — Buscar Cliente`; F09; Objetivos `OBJE-01`, `OBJE-10`; Requisito `RF-10`.
5. **Notas:** Baja/reactivación lógica exclusiva del Administrador. `HISTORIAL_ESTADO_CLIENTE` es tabla **existente** en MR-5/MR-6, con clave compuesta (`idCliente`, `numeroCambio`) y estado anterior/nuevo, fecha, motivo y `idUsuarioAdministrador`. No cancelar automáticamente Pedidos PENDIENTE, no borrar Cuenta Corriente ni impedir Cobros de regularización. La desactivación bloquea nuevas ventas/promociones/ofertas; el estado vigente se revalida al confirmar.

6. **Excepciones:**
   * **A1 — `UC-33` finalizó sin selección válida:** No ejecutar cambios.
   * **A2 — El `Cliente` ya posee el `nuevoEstado` solicitado:** Informar ausencia de cambio.
   * **A3 — Reactivación (`nuevoEstado = ACTIVO`) solicitada cuando los datos obligatorios del Cliente están incompletos o inválidos:** Exigir corrección previa en `UC-32`.
   * **A4 — Conflicto concurrente o falla de persistencia (`F09`):** Conservar el estado anterior sin alteraciones parciales.
7. **Salida:**
   * Confirmación del nuevo `Cliente.estado` (`ACTIVO` | `INACTIVO`); o mensajes provocados por las excepciones A1–A4.
8. **Precondiciones:**
   * El `Administrador` se encuentra autenticado y autorizado, y existe el `Cliente` seleccionado mediante `UC-33`.
9. **Postcondiciones:** Tras confirmar un cambio real, `CLIENTE.estado` se actualizó a `ACTIVO` o `INACTIVO` y se creó **una fila distinta** de `HISTORIAL_ESTADO_CLIENTE` con `idCliente`, `numeroCambio`, `estadoAnterior`, `estadoNuevo`, `fechaHoraCambio`, `motivo` opcional e `idUsuarioAdministrador`. La inactivación impide nuevas operaciones comerciales y desafíos/sesiones ONLINE según reglas de autorización; preserva Pedidos PENDIENTE, Cobros de deuda e historial. Si ya estaba en el estado solicitado, o hay cancelación/fallo, no se genera un cambio histórico artificial.
---

## 5. Contrato de la Operación `configurarPoliticaCategoriaComercial` (`UC-57`)

1. **Nombre:** `configurarPoliticaCategoriaComercial(diasToleranciaMora: Integer, vigenteDesde: Timestamp, vigenteHasta: Timestamp[0..1], ajusteCumplidor: AjusteCategoriaDTO, ajusteEnMora: AjusteCategoriaDTO)`

2. **Responsabilidades:** Registrar una nueva versión temporal mediante una **nueva fila** de `POLITICA_CATEGORIA_COMERCIAL` (tolerancia y vigencias) y **exactamente dos filas** de `AJUSTE_POLITICA_CATEGORIA`, una para CUMPLIDOR y otra para EN_MORA, configurando `tipoAjuste`/`porcentajeAjuste` por categoría. Validar todo transaccionalmente sin recalcular Pedidos históricos.

3. **Tipo:** `Sistema`
4. **Referencias cruzadas:** Caso de Uso `UC-57 — Configurar Política de Categoría Comercial`; casos relacionados `UC-15` y `UC-16`; Objetivo `OBJE-11`; Requisito `RF-12`.
5. **Notas:** MR-5/MR-6 registra `diasToleranciaMora`, `vigenteDesde`, `vigenteHasta`, `fechaHoraRegistro`, `idUsuarioRegistro` en `POLITICA_CATEGORIA_COMERCIAL`; **no** tiene columnas `porcentajeDescuentoCumplidor` ni `porcentajeRecargoMora` ni `numeroVersion`. Cada porcentaje y tipo se almacena en `AJUSTE_POLITICA_CATEGORIA` (`idPoliticaComercial`, `categoriaComercial`, `tipoAjuste`, `porcentajeAjuste`). Los dos `AjusteCategoriaDTO` son entradas lógicas, **no tablas**. `tipoAjuste ∈ {DESCUENTO, RECARGO, SIN_AJUSTE}`; `SIN_AJUSTE` exige porcentaje 0; DESCUENTO/RECARGO requieren porcentaje positivo válido; ambos porcentajes respetan el rango 0–100 establecido por Fase 4. Ningún umbral de mora se inventa por defecto. No se alteran vigencias históricas consolidadas ni Pedidos confirmados.

6. **Excepciones:** A1 — Sin autorización Administrador: rechazar. A2 — Tolerancia negativa, fechas inválidas o fin no posterior a inicio: solicitar corrección. A3 — Falta el ajuste de alguna categoría, categorías repetidas o tipo/porcentaje incompatible: rechazar. A4 — Solapamiento de vigencia o necesidad de alterar historial consolidado: impedir. A5 — Cancelación antes de confirmar: conservar versiones previas. A6 — Concurrencia/fallo al grabar: revertir en una sola transacción la política y ambos ajustes, sin registros parciales.

7. **Salida:** Id de `POLITICA_CATEGORIA_COMERCIAL`, vigencia y constancia de sus dos `AJUSTE_POLITICA_CATEGORIA`; o rechazo A1–A6.

8. **Precondiciones:**
   * El `Administrador` se encuentra autenticado y autorizado.
9. **Postcondiciones:** Se creó una fila de `POLITICA_CATEGORIA_COMERCIAL` con `diasToleranciaMora`, `vigenteDesde`, `vigenteHasta`, `fechaHoraRegistro` e `idUsuarioRegistro`, junto con exactamente dos filas hijas de `AJUSTE_POLITICA_CATEGORIA` para CUMPLIDOR y EN_MORA con `tipoAjuste` y `porcentajeAjuste` válidos. Si era legal, se acotó prospectivamente el intervalo previo sin tocar políticas históricas consolidadas. Se conservaron ajustes y precios de Pedidos anteriores; ante fallo se revierte el conjunto.
---

## 6. Contrato de la Operación `evaluarYActualizarCategoriaComercial` (`UC-15`)

1. **Nombre:** `evaluarYActualizarCategoriaComercial(idCliente: Long)`
2. **Responsabilidades:** Evaluar automáticamente la situación de deuda de un `Cliente` en su Cuenta Corriente imputando pagos/créditos contra las deudas más antiguas (FIFO), contrastar la antigüedad de la deuda impaga más antigua contra `diasToleranciaMora` de la `PoliticaCategoriaComercial` vigente y actualizar `Cliente.categoriaComercial` (`CUMPLIDOR` o `EN_MORA`) únicamente cuando corresponda un cambio real.
3. **Tipo:** `Sistema`
4. **Referencias cruzadas:** Caso de Uso `UC-15 — Evaluar y Actualizar Categoría Comercial`; `UC-16 «include» UC-15` según Fase 4; reevaluaciones ligadas a hechos comerciales de `UC-05`, `UC-26`, `UC-29`, `UC-49` sin establecer nuevas relaciones UML «include» por inferencia; decisiones RD-F04-003/006/007; Objetivo `OBJE-11`; Requisitos `RF-06`, `RF-12`.
5. **Notas:** La evaluación es de sistema, no acción nueva de Cliente. La antigüedad de la deuda impaga se determina por imputación FIFO de créditos contra cargos confirmados, con fecha de origen `ENTREGA.fechaHoraEntrega` del cargo correspondiente; el efectivo declarado en tránsito no se contabiliza como Cobro confirmado para esta evaluación (RD-F04-003/006/007). La categoría EN_MORA exige saldo deudor confirmado positivo y edad **estrictamente mayor** que `diasToleranciaMora`, no igualdad. Si no existe política vigente no se usan umbrales por defecto.

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
4. **Referencias cruzadas:** Caso de Uso `UC-16 — Aplicar Ajuste Comercial según Categoría`; incluye `UC-15 — Evaluar y Actualizar Categoría Comercial`; utilizado por `UC-03 — Cargar Pedido` y `UC-21 — Realizar Pedido Online`; Objetivo `OBJE-11`; Requisitos `RF-01`, `RF-12`, `RF-14`.
5. **Notas:** UC-15 obtiene primero la categoría. La política y el ajuste se recuperan de `POLITICA_CATEGORIA_COMERCIAL` y su fila hija `AJUSTE_POLITICA_CATEGORIA` de la categoría resultante, no de columnas de porcentaje directamente en POLITICA. El parámetro lógico `subtotalBaseLuegoPromocion` significa **subtotal base sin descuento en canal INTERNO**, y **subtotal posterior al único mayor beneficio promocional elegible en canal ONLINE** (RD-RP023-001). El canal se conoce del Pedido invocante. `SIN_AJUSTE` conserva dicha base; no se reescriben precios unitarios históricos ni Pedidos anteriores.

6. **Excepciones:** A1 — UC-15 no determina categoría o falta Política vigente: no inventar categoría ni porcentaje. A2 — Base comercial negativa: rechazar. A3 — La fila de ajuste de la categoría está ausente, mal tipificada o con porcentaje inválido: rechazar, sin suponer descuento o recargo. A4 — Falta precio histórico válido de algún Detalle: no confirmar total. A5 — Política declara SIN_AJUSTE: total igual a base (rama válida, no error), conservando referencia de política.

7. **Salida:**
   * Resumen comercial con `categoriaComercialAplicada`, `tipoAjuste` (`DESCUENTO` | `RECARGO` | `SIN_AJUSTE`), `porcentajeAjuste`, `importeAjuste` y `totalOriginal` resultante; o mensajes de las excepciones A1–A2.
8. **Precondiciones:**
   * Existe el `Cliente` en estado `ACTIVO`, existe un `Pedido` en construcción (`UC-03` o `UC-21`) con `subtotalBaseLuegoPromocion >= 0` y existe una `PoliticaCategoriaComercial` vigente.
9. **Postcondiciones:** Se ejecutó UC-15 según reglas confirmadas. En el Pedido nuevo, sin alterar precios unitarios de sus Detalles, se congelaron `categoriaComercialAplicada`, `idPoliticaComercialAplicada`, `tipoAjuste`, `porcentajeAjuste` y `totalOriginal` mediante el ajuste aplicable a la base del canal correspondiente; no se modificaron Pedidos confirmados previamente.
---

## 8. Contrato de la Operación `buscarInsumo` (`UC-36`)

1. **Nombre:** `buscarInsumo(idInsumo: Long[0..1], nombre: String[0..1], activo: Boolean[0..1])`
2. **Responsabilidades:** Localizar y presentar en modo solo lectura los `Insumo` registrados (activos o inactivos) que cumplan los criterios informados, devolviendo el `Insumo` seleccionado al caso de uso invocante.
3. **Tipo:** `Sistema`
4. **Referencias cruzadas:** Caso de Uso `UC-36 — Buscar Insumo`; incluido por `UC-10`, `UC-31`, `UC-51` y `UC-52` conforme relaciones vigentes; permisos RD-RP007-002; Objetivos `OBJE-07`, `OBJE-09`; Requisitos `RF-04`, `RF-05`, `RF-11`.
5. **Notas:** Solo lectura. `RD-RP007-002` autoriza **Administrador y Responsable de Producción** tanto en acceso directo como contextual. El CU invocante valida, cuando corresponda, que el Insumo esté `activo=true`; la búsqueda puede mostrar inactivos a quienes tienen permiso, sin cambiar valores de stock.

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
5. **Notas:** Los Productos de tipo REVENTA no admiten Receta. `RECETA` tiene identidad estable; `VERSION_RECETA` usa clave compuesta (`idReceta`, `numeroVersion`) y `DETALLE_VERSION_RECETA` usa (`idReceta`, `numeroVersion`, `idInsumo`). Cada detalle conserva `cantidadNecesaria` y `codigoUnidadCantidad` compatible, columnas **existentes**. No se inventa una Receta nueva por cada versión ni se alteran Preparaciones históricas. No se modifican parámetros de reposición UC-31.

6. **Excepciones:**
   * **A1 — El `Producto` seleccionado no existe o su `tipoProducto` es `REVENTA`:** Rechazar la configuración de Receta.
   * **A2 — `cantidadRendimientoBase <= 0`, lista `itemsInsumo` vacía, `Insumo` repetido/inactivo (`activo = false`) o `cantidadNecesaria <= 0`:** Solicitar corrección sin confirmar la versión.
   * **A3 — Intervalo `[vigenteDesde, vigenteHasta)` inválido o superpuesto con otra versión de la misma Receta:** Rechazar la confirmación conservando la versión vigente previa.
   * **A4 — Cancelación o fallo de persistencia:** Revertir toda la operación sin crear versiones parciales.
7. **Salida:**
   * Confirmación de la `Receta` y del nuevo `numeroVersion` de `VersionReceta` registrado con su vigencia e Insumos asociados; o mensajes de las excepciones A1–A4.
8. **Precondiciones:**
   * El `Administrador` se encuentra autenticado y autorizado, el `Producto` seleccionado mediante `UC-35` es de `tipoProducto = ELABORADO` y los `Insumo` seleccionados mediante `UC-36` tienen `activo = true`.
9. **Postcondiciones:** Se creó/recuperó la única `RECETA` del Producto ELABORADO. En la rama de confirmación válida se acotó, si correspondía, la vigencia previa sin solapamientos y se creó `VERSION_RECETA` (`idReceta`, `numeroVersion`, `vigenteDesde`, `vigenteHasta`, `cantidadRendimientoBase`, `codigoUnidadRendimiento`). Se creó un `DETALLE_VERSION_RECETA` por Insumo distinto, con su `cantidadNecesaria` y `codigoUnidadCantidad` compatible; las Preparaciones históricas mantienen sus versiones. Ante error se revierte íntegramente.
---

## 10. Contrato de la Operación `configurarParametrosReposicionInsumo` (`UC-31` «include» `UC-36`)

1. **Nombre:** `configurarParametrosReposicionInsumo(idInsumo: Long, umbralMinimo: BigDecimal, nivelObjetivoReposicion: BigDecimal, automatizacionCompraActiva: Boolean)`
2. **Responsabilidades:** Actualizar los parámetros de control de reposición (`umbralMinimo`, `nivelObjetivoReposicion` y `automatizacionCompraActiva`) de un `Insumo` previamente localizado mediante `UC-36` para futuras evaluaciones de stock.
3. **Tipo:** `Sistema`
4. **Referencias cruzadas:** Caso de Uso `UC-31 — Configurar Parámetros de Reposición de Insumo`; incluye `UC-36 — Buscar Insumo`; Proceso PRA-01; Objetivos `OBJE-07`, `OBJE-09`; Requisitos `RF-05`, `RF-11`.
5. **Notas:** UC-31 pertenece exclusivamente al **Responsable de Producción** en Fase 4. La actualización no dispara nuevas rondas automáticas retroactivas ni modifica/cancela Solicitudes, Órdenes o Episodios existentes. Si el nuevo umbral muestra un faltante, informar para intervención administrativa **sin iniciar ronda automática**. No confundir esta operación de configuración con cierre automático de EpisodioFaltante (PRA-01): no hay evento físico de stock que lo justifique.

6. **Excepciones:**
   * **A1 — `UC-36` finalizó sin selección válida:** No modificar parámetros.
   * **A2 — `umbralMinimo < 0` o `nivelObjetivoReposicion <= umbralMinimo`:** Solicitar corrección y conservar los parámetros vigentes.
   * **A3 — Cancelación o error de persistencia:** Mantener sin cambios los parámetros anteriores.
7. **Salida:**
   * Confirmación de los nuevos parámetros de reposición registrados en el `Insumo`; o mensajes de las excepciones A1–A3.
8. **Precondiciones:** El **Responsable de Producción** autenticado y autorizado seleccionó un Insumo existente mediante UC-36, en el alcance funcional permitido.

9. **Postcondiciones:** Se actualizaron en `INSUMO` `umbralMinimo`, `nivelObjetivoReposicion`, `automatizacionCompraActiva`, con validación de unidad y `nivelObjetivoReposicion > umbralMinimo`. No cambia `stockActual` ni `codigoUnidadMedida`, ni se emite una Solicitud automática retroactiva, ni se cancela o cierra como efecto de esta configuración un Episodio, Solicitud u Orden abierta. Si queda un faltante, se informa para intervención administrativa; se conserva la trazabilidad de fecha/actor conforme mecanismo ya existente, **sin crear columna nueva**.
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
4. **Referencias cruzadas:** Caso de Uso `UC-09 — Consultar Stock`; referencia informativa a UC-64 (consulta histórica); RD-RP022-001; Objetivo `OBJE-07`; Requisito `RF-04`.
5. **Notas:** Solo el **Responsable de Producción** está identificado como actor de UC-09 en sus tres niveles Fase 4; esta búsqueda de stock no concede por inferencia permiso al Administrador. Separar INSUMO de REVENTA (RD-RP022-001): Productos ELABORADO no tienen stock general y los Productos REVENTA no poseen los mismos umbrales mínimos de INSUMO. El filtro lógico `soloBajoUmbral` solo es aplicable al inventario de INSUMO. Mostrar explícitamente los valores de stock cero, sin ocultarlos.

6. **Excepciones:** A1 — Inventario o filtros inválidos, o acceso no autorizado: rechazar/no mostrar datos. A2 — Se selecciona REVENTA: mostrar stock y unidad de venta propios de cada Producto REVENTA, sin umbral de Insumo. A3 — Stock cero: presentar `0` (no omitir por inexistencia). A4 — Sin registros coincidentes: informar resultado vacío. A5 — Falla de consulta: informar sin producir movimientos ni alterar existencias.

7. **Salida:**
   * Estado actual de existencias separadas por tipo de inventario (`INSUMO` con unidad, stock, umbrales y alerta de faltante; `PRODUCTO REVENTA` con unidad y stock actual); o mensajes de las excepciones A1–A2.
8. **Precondiciones:** El **Responsable de Producción** se encuentra autenticado y autorizado para consulta de existencias UC-09.

9. **Postcondiciones:**
   * *(Sin cambios de estado en el sistema: operación de solo lectura)*.

---

## 13. Contrato de la Operación `consultarMovimientosInventario` (`UC-64`)

1. **Nombre:** `consultarMovimientosInventario(tipoInventario: String, idElemento: Long[0..1], tipoMovimiento: String[0..1], fechaDesde: LocalDate[0..1], fechaHasta: LocalDate[0..1])`
2. **Responsabilidades:** Consultar en modo solo lectura el historial cronológico de movimientos de `MOVIMIENTO_INSUMO` o de `MOVIMIENTO_STOCK_REVENTA` según el inventario elegido, presentando cantidades, `stockResultante` y referencias de origen (`Preparacion`, `RecepcionCompra`, `Entrega`, ajustes o `SALDO_INICIAL`), manteniendo estrictamente separados ambos inventarios y ocultando costos si el rol no tiene autorización para verlos.
3. **Tipo:** `Sistema`
4. **Referencias cruzadas:** Caso de Uso `UC-64 — Consultar Movimientos de Inventario`; consulta relacionada UC-09; RD-RP022-001; Objetivo `OBJE-07`; Requisitos `RF-04`, `RF-05`.
5. **Notas:** Consulta de solo lectura por Responsable de Producción o Administrador (Fase 4); se aplican filtros de alcance y visibilidad de campos sensibles, sin inferir permisos adicionales. `MOVIMIENTO_INSUMO` y `MOVIMIENTO_STOCK_REVENTA` son hechos separados y no se suman como un solo saldo; los Productos ELABORADO se gestionan mediante Preparaciones/Excedentes. No se editan costos históricos ni movimientos desde UC-64.

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

## Límite de validación y precedencia

- Fase 4 vigente: 64 CU en Alto Nivel, Extendido y Real, cotejados para estos 13 contratos.
- Se conservan como conceptos lógicos `DireccionDTO`, `DatosClienteDTO`, `ItemRecetaDTO` y `AjusteCategoriaDTO`; son tipos de entrada propuestos, no tablas ni atributos físicos.
- Se verifican denominaciones contra las 60 tablas MR-5/MR-6. Esta revisión no agrega columnas, relaciones ni estados.
- Las 13 firmas son contratos nuevos **sin DSS/DS propios disponibles**; no se afirma coincidencia de mensajes UML ni implementación.
- Los diagramas de REV-01 a REV-06A no se modifican. La incorporación al documento maestro o a `main` requiere una decisión posterior de integración.
