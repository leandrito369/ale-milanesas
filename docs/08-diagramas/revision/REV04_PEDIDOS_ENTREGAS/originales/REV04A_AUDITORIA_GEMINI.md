# REV-04A — Auditoría Transversal y Corrección: Pedidos, Canal Online, Asignación y Ruteo (UC-34, UC-03, UC-21, UC-43, UC-04, UC-25)

**Fecha:** 28/10/2026  

**Rama de trabajo propuesta:** `revision/rev04a-pedidos-reparto-2026-10-28`  

**Alcance (`REV-04A`):** `UC-34`, `UC-03` («include» `UC-33`, `UC-35`, `UC-16`→`UC-15`), `UC-21` («include» `UC-16`→`UC-15`, `UC-29`), `UC-43` («include» `UC-34`), `UC-04`, `UC-25`.  

**Estado de los artefactos entregados:** `PROPUESTO / CORREGIDO EN REVISIÓN ESTÁTICA` (pendiente de inspección visual humana en Draw.io y aprobación para fusión a `main`).

---

## 1. Ejecución de las 8 Etapas Metodológicas (M-0 a M-7)

### M-0 — Autoridad y alcance congelados

* **Catálogo funcional vigente:** 64 CU consecutivos (`UC-01`..`UC-64`) en 3 niveles (`ALE_MILANESAS_FASE_4_CU_01_A_64_TRES_NIVELES.docx`).

* **Relaciones UML aprobadas en este sublote:** `UC-03 → UC-33` (`include`), `UC-03 → UC-35` (`include`), `UC-03 → UC-16` (`include`), `UC-16 → UC-15` (`include`), `UC-21 → UC-16` (`include`), `UC-21 → UC-29` (`include`) y `UC-43 → UC-34` (`include`). El archivo `DIAGRAMA DE CASOS DE USO.drawio (1).xml` permanece intacto.

* **Decisiones posteriores incorporadas (Corte 27/10/2026):**

  * **`RD-RP001/RP019` (resuelve Hallazgo de Prioridad Alta `H-05`):** En `UC-21 — Realizar Pedido Online`, el Cliente Online selecciona la `fechaReparto` entre las **fechas habilitadas** presentadas por el sistema y el servidor **valida que la fecha seleccionada continúe habilitada antes de confirmar e iniciar el pago** (dejando de tratar la fecha de reparto online como pendiente abierto).

  * **`RD-RP023-001` (resuelve Hallazgo de Prioridad Alta `H-06` en `UC-21`):** Cuando concurren múltiples promociones vigentes para un mismo Producto y Cliente destinatario en `UC-21`, **no se acumulan descuentos sobre las mismas unidades**; el sistema evalúa las promociones elegibles, selecciona automáticamente la de **mayor beneficio aplicable (mayor porcentaje de descuento elegible)** y la congela en el detalle del Pedido.

  * **`RD-RP002-001` (resuelve Hallazgo de Prioridad Alta `H-21`):** En `UC-43 — Asignar y Reasignar Pedidos a Repartidores`, se explicitan las **6 reglas obligatorias**:

    1. El `Pedido` debe estar en estado `PENDIENTE` (tanto de canal `INTERNO` como `ONLINE`).

    2. El Repartidor elegido debe poseer cuenta de `Usuario` en estado `HABILITADO`.

    3. El Repartidor elegido debe poseer el Rol vigente `REPARTIDOR`.

    4. Unicidad transaccional: existe a lo sumo una única `AsignacionReparto` vigente por `Pedido` (al reasignar se cierra la anterior y se activa la nueva atómicamente).

    5. Operación **exclusivamente online** (no se admite asignar ni reasignar Repartidores en modo offline).

    6. En toda reasignación es obligatorio informar `motivoReasignacion` y revalidar ausencia de conflicto concurrente (que el Pedido no haya sido entregado/cancelado ni reasignado por otro usuario).

  * **`RD-F04-001..007` (resuelve Hallazgo `H-09` en `UC-03`):** En `UC-03 — Cargar Pedido`, cuando el Vendedor opera sin conectividad, el Pedido puede registrarse localmente con clave de idempotencia y snapshot comercial, quedando sujeto a **validación y conciliación idempotente por el servidor** al recuperar conectividad sin duplicar Pedidos.

  * **`RD-RP020-001` (resuelve Hallazgo `H-23`):** Se incorpora la secuencia y contrato de **reprogramación de `fechaReparto` sobre un Pedido `PENDIENTE`** (dentro del alcance de gestión del Pedido sin crear un CU 65), la cual registra el historial de cambio de fecha con motivo obligatorio, **invalida automáticamente la `AsignacionReparto` vigente (`UC-43`)** para exigir nueva asignación y deja sin efecto cualquier `RutaReparto` sugerida previa (`UC-25`).

### M-1 — Proveniencia, integridad y matriz de diferencias (Antes → Después)

\| ID Hallazgo \| Artefacto / Celda Original \| Antes (Borrador 26–27/10) \| Después (Versión Corregida `REV04A`) \| Fundamento \|

\| :--- \| :--- \| :--- \| :--- \| :--- \|

\| **`H-05` (Alta)** \| `DS UC-21` y `Contrato 2.2` \| El DSS tenía `fechaReparto`, pero el DS no validaba fechas habilitadas y el contrato lo declaraba pendiente. \| `DS UC-21` incorpora la consulta/validación en servidor de `fechaReparto` dentro de las **fechas habilitadas** antes de confirmar, y `CONTRATO_UC21` lo formaliza en Pre/Postcondiciones y Excepciones. \| `RD-RP001/RP019` \|

\| **`H-06` (Alta)** \| `DS UC-21` (`u21_m6`) y `Contrato 2.2` \| Aplica una promoción única sin especificar la regla de no acumulación ante promociones simultáneas. \| Explicita que ante promociones simultáneas **no se acumulan descuentos sobre las mismas unidades**, sino que se elige y congela el **mejor beneficio aplicable**. \| `RD-RP023-001` \|

\| **`H-21` (Alta)** \| `DS UC-43` (`u43_m2`, `u43_g1`) y `Contrato 5.3` \| Validaba solo `Pedido PENDIENTE` y asignación previa, dejando la elegibilidad y el modo offline como `[A CONFIRMAR]`. \| Incorpora en el DS y en `CONTRATO_UC43` las **6 reglas obligatorias** de `RD-RP002-001` (cuenta `HABILITADO`, Rol `REPARTIDOR`, asignación vigente única, operación **exclusivamente online**, motivo en reasignación y control de concurrencia). \| `RD-RP002-001` \|

\| **`H-09` (Media/Alta)** \| `DS UC-03` y `Contrato 5.2` \| Citaba `F04` como pendiente abierto sin detallar la validación del servidor. \| Incorpora la regla aprobada `RD-F04`: captura local con `claveIdempotencia` y validación/conciliación idempotente en servidor al sincronizar. \| `RD-F04-001..007` \|

\| **`H-23` (Media)** \| `DS UC-03`/`UC-43` y Contratos \| No representaba la reprogramación de fecha de reparto de un Pedido `PENDIENTE` ni la invalidación de la asignación `UC-43`. \| Se incorpora la secuencia `reprogramarFechaRepartoPedido` (con historial de fecha e invalidación automática de `AsignacionReparto` vigente y ruta sugerida) y su Contrato explícito. \| `RD-RP020-001` \|

\| **`H-11`, `H-12`, `H-19`, `H05`** \| `DSS`, `DS` y `Contratos` \| Contratos agrupados en `UC-21` y firmas distintas entre DSS, DS y Contrato. \| Marcos `sd` independientes en DSS, lenguaje de caja negra, firmas 1:1 homologadas y **7 Contratos individuales** con 9 secciones estándar. \| `M-3`, `H-11`, `H-12`, `H-19`, `H05` \|

---

## 2. Matriz de Trazabilidad Vertical y Visibilidad de Larman Mensaje por Mensaje (M-3 y M-6)

\| CU \| Paso / Mensaje en DS \| Emisor \$\\rightarrow\$ Receptor \| Tipo de Visibilidad (Larman) \| Origen verificable de la referencia \|

\| :--- \| :--- \| :--- \| :--- \| :--- \|

\| **`UC-34`** \| `1: buscarPedido(idPedido, idCliente, fechaReparto, estado, canalOrigen)` \| `Actor Interno Autorizado` \$\\rightarrow\$ `:ControladorPedidos` \| Frontera de sistema \| Operación pública homologada del DSS (`UC-34`). \|

\| **`UC-34`** \| `2: lista = consultarPedidosPorCriterios(filtro)` \| `:ControladorPedidos` \$\\rightarrow\$ `:RepositorioPedidos` \| **Por Atributo** \| Repositorio de Pedidos inyectado en el controlador. \|

\| **`UC-03`** \| `1: cargarPedido(idCliente, fechaReparto, items, direccionEntrega, claveIdempotencia)` \| `Vendedor` \$\\rightarrow\$ `:ControladorPedidos` \| Frontera de sistema \| Operación pública homologada del DSS (`UC-03`, precedida por `«include» UC-33` y `UC-35`). \|

\| **`UC-03`** \| `2: ctx = validarClienteActivoFechaProductosYIdempotencia(idCliente, fechaReparto, items, claveIdempotencia)` \| `:ControladorPedidos` \$\\rightarrow\$ `:RepositorioPedidos` \| **Por Atributo** \| Valida en servidor Cliente `ACTIVO`, Productos `ACTIVO` con precio vigente, `fechaReparto` válida y no duplicación por `claveIdempotencia` (`RD-F04`). \|

\| **`UC-03`** \| `3: «create» new(unCliente, fechaReparto, direccionEntrega, canalOrigen=INTERNO, estado=PENDIENTE)` \| `:ControladorPedidos` \$\\rightarrow\$ `nuevoPedido : Pedido` \| **Por Creación Local (`new`) \+ Parámetro** \| Instancia el `Pedido` interno y crea sus `det : DetallePedido` congelando `precioUnitarioOriginal`. \|

\| **`UC-03`→`UC-16`** \| `4: aplicarAjusteComercialSegunCategoria(unCliente, nuevoPedido)` \| `:ControladorPedidos` \$\\rightarrow\$ `:ControladorClientes` (`UC-16`→`UC-15`) \| **Por Atributo \+ Parámetro** \| Ejecuta el caso incluido `UC-16` (que incluye `UC-15`) congelando categoría, tipo y porcentaje de ajuste y `totalOriginal`. \|

\| **`UC-03` (`RP-020`)** \| `1b: reprogramarFechaRepartoPedido(idPedido, nuevaFechaReparto, motivo)` \| `Vendedor` \$\\rightarrow\$ `:ControladorPedidos` \| Frontera de sistema \| Operación de reprogramación sobre Pedido `PENDIENTE` (`RD-RP020-001`). \|

\| **`UC-03` (`RP-020`)** \| `2b: actualizarFechaRegistrarHistorialEInvalidarAsignacion(nuevaFechaReparto, motivo)` \| `:ControladorPedidos` \$\\rightarrow\$ `unPedido : Pedido` \| **Por Variable Local** \| Registra el cambio en el historial de fecha del Pedido e **invalida la `AsignacionReparto` vigente (`UC-43`)** (`RD-RP020-001`). \|

\| **`UC-21`** \| `1: realizarPedidoOnline(idDesafioVerificado, items, direccionEntrega, fechaReparto)` \| `Cliente Online` \$\\rightarrow\$ `:ControladorPedidos` \| Frontera de sistema \| Operación pública homologada del DSS (`UC-21`). \|

\| **`UC-21`** \| `2: okFecha = validarClienteActivoYFechaRepartoHabilitada(idDesafioVerificado, fechaReparto)` \| `:ControladorPedidos` \$\\rightarrow\$ `:RepositorioPedidos` \| **Por Atributo** \| Valida desafío OTP verificado de Cliente `ACTIVO` y que `fechaReparto` pertenezca a las **fechas habilitadas en servidor** (`RD-RP001/RP019`). \|

\| **`UC-21`** \| `3: «create» new(unCliente, fechaReparto, direccionEntrega, canalOrigen=ONLINE, estado=PENDIENTE)` \| `:ControladorPedidos` \$\\rightarrow\$ `pedidoOnline : Pedido` \| **Por Creación Local (`new`)** \| Crea el Pedido y evalúa promociones elegibles seleccionando el **mejor beneficio aplicable sin acumular descuentos sobre las mismas unidades** (`RD-RP023-001`), seguido de `UC-16`→`UC-15` y `UC-29`. \|

\| **`UC-43`** \| `1: asignarOReasignarPedidoARepartidor(idPedido, idUsuarioRepartidor, motivoReasignacion)` \| `Vendedor` \$\\rightarrow\$ `:ControladorReparto` \| Frontera de sistema \| Operación pública homologada del DSS (`UC-43`, precedida por `«include» UC-34`). \|

\| **`UC-43`** \| `2: val = revalidarReglasAsignacionOnline(idPedido, idUsuarioRepartidor, motivoReasignacion)` \| `:ControladorReparto` \$\\rightarrow\$ `:RepositorioPedidos` \| **Por Atributo** \| Verifica las **6 reglas de `RD-RP002-001`**: operación online, Pedido `PENDIENTE`, Repartidor `HABILITADO` con Rol `REPARTIDOR`, cambio real, motivo obligatorio si reasigna y sin conflicto concurrente. \|

\| **`UC-43`** \| `3: «create» new(unPedido, repElegido, fechaHoraInicio, vigente=true, motivoReasignacion)` \| `unPedido : Pedido` \$\\rightarrow\$ `nuevaAsig : AsignacionReparto` \| **Por Creación Local (`new`) \+ Atributo** \| Cierra la asignación vigente previa (si existía), crea la única `AsignacionReparto` vigente e invalida cualquier `RutaReparto` previa de esa fecha. \|

\| **`UC-04`** \| `1: consultarPedidosAsignados()` \| `Repartidor` \$\\rightarrow\$ `:ControladorReparto` \| Frontera de sistema \| Operación pública homologada del DSS (`UC-04`). \|

\| **`UC-04`** \| `2: misPedidos = obtenerPedidosPendientesConAsignacionVigente(idRepartidorAutenticado)` \| `:ControladorReparto` \$\\rightarrow\$ `:RepositorioPedidos` \| **Por Atributo \+ Parámetro** \| Recupera solo Pedidos `PENDIENTE` con asignación vigente al Repartidor autenticado, incluyendo adicionales de `UC-07`. \|

\| **`UC-25`** \| `1: generarRutaSugeridaReparto(fechaReparto)` \| `Repartidor` \$\\rightarrow\$ `:ControladorReparto` \| Frontera de sistema \| Operación pública homologada del DSS (`UC-25`). \|

\| **`UC-25`** \| `2: respRuteo = solicitarSecuenciaVisita(ubicacionesValidas)` \| `:ControladorReparto` \$\\rightarrow\$ `:AdaptadorRuteo` \| **Por Atributo \+ Parámetro** \| Indirección hacia `:ServicioDeRuteo`; si responde válidamente, instancia `unaRuta : RutaReparto` (**Creación Local**). \|

---

## 3. Matriz Transversal de Invariantes y Puertas de Aceptación (M-4 y M-7)

\| ID \| Invariante ratificada \| DSS \| DS \| Contrato \| Dictamen \|

\| :--- \| :--- \| :--- \| :--- \| :--- \| :--- \|

\| **`I-01`** \| `RD-RP001/RP019` (`H-05`): Selección de `fechaReparto` entre fechas habilitadas y validación del servidor antes de confirmar en `UC-21` \| Mensaje y guarda explícitos en `DSS UC-21` \| Paso `2:` y guarda en `DS UC-21` \| Pre/Postcondiciones y Excepción A2 en `CONTRATO_UC21` \| **PASÓ (Trazabilidad estática)** \|

\| **`I-02`** \| `RD-RP023-001` (`H-06`): Promociones simultáneas no acumulan descuentos sobre las mismas unidades; se elige y congela el mejor beneficio aplicable antes del ajuste `UC-16` \| Respuesta explícita en `DSS UC-21` \| Selección del mejor descuento elegible en `DS UC-21` \| Notas y Postcondiciones en `CONTRATO_UC21` \| **PASÓ (Trazabilidad estática)** \|

\| **`I-03`** \| `RD-RP002-001` (`H-21`): Las 6 reglas obligatorias en `UC-43` (Pedido `PENDIENTE`, Repartidor `HABILITADO` con Rol `REPARTIDOR`, asignación vigente única, operación exclusivamente online, motivo en reasignación y concurrencia) \| Guardas completas en `DSS UC-43` \| Revalidación explícita en `DS UC-43` \| Pre/Postcondiciones y Excepciones en `CONTRATO_UC43` \| **PASÓ (Trazabilidad estática)** \|

\| **`I-04`** \| `RD-RP020-001` (`H-23`): Reprogramar `fechaReparto` de un Pedido `PENDIENTE` registra historial de fecha e invalida la `AsignacionReparto` vigente (`UC-43`) y la ruta sugerida (`UC-25`) \| Bloque `opt` de reprogramación en `DSS Vendedor` \| Bloque de reprogramación en `DS UC-03` \| `CONTRATO_REPROGRAMAR_FECHA` individual con 9 secciones \| **PASÓ (Trazabilidad estática)** \|

\| **`I-05`** \| `RD-F04-001..007` (`H-09`): Registro offline de `UC-03` con clave de idempotencia y validación/reconciliación del servidor al sincronizar \| Nota y guarda idempotente en `DSS UC-03` \| Verificación de `claveIdempotencia` en `DS UC-03` \| Notas, Excepciones y Postcondiciones en `CONTRATO_UC03` \| **PASÓ (Trazabilidad estática)** \|

\| **`I-06`** \| Homologación 1:1 de firmas públicas DSS ↔ DS ↔ Contrato y desagrupamiento en contratos individuales (`H-11`, `H05`) \| Firmas canónicas \| Mensaje `1:` idéntico en las 6 páginas DS \| 7 Contratos individuales con 9 secciones \| **PASÓ** \|

\| **`I-07`** \| Inspección visual y prueba de desplazamiento (`round-trip`) en editor gráfico Draw.io (`M-6` / `G5`) \| XML bien formado \| XML bien formado \| N/A \| **PENDIENTE DE VALIDACIÓN HUMANA EN DRAW.IO** \|

