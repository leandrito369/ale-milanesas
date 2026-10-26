# B — Dominio y diseño — Ale Milanesas
**Corte vigente:** 23/10/2026. **Importante:** el Modelo de Dominio es conceptual; **el Modelo Relacional de 59 tablas es una transformación física/lógica** y no debe copiarse como 59 clases UML de dominio. `MDALE.drawio` original sirve como antecedente conceptual; el diagrama relacional único es el artefacto vigente para la defensa del lunes 26/10.

## Estado actualizado de decisiones
- **Pedidos y Excedentes:** cantidadOriginal es inmutable; adicionales aceptados preservan identidad, cantidad e importe; Preparación propia limitada a original; Entrega total limitada a original + aceptaciones y disponibilidad física. Orden comercial de imputación: original, después aceptaciones por fecha. No repetir consumos de Insumo al transferir Excedentes.
- **Procedencia de remanentes reasignados:** se APROBÓ el 22/10–23/10 la FK `EXCEDENTE.idMovimientoExcedenteOrigen` (opcional) → `MOVIMIENTO_EXCEDENTE(idMovimientoExcedente)`; valida mismo Producto, Pedido receptor, cantidad y costo transaccionalmente. No agrega tabla.
- **Acceso ONLINE:** Cliente y Usuario distintos. Código temporal al teléfono verificado; sesión de Cliente separada de sesión de Usuario, sin Rol CLIENTE. Ambigüedad de teléfono compartido bloquea login ONLINE; datos actuales de Cliente vs snapshots de Pedido separados.
- **Versionado:** RECETA 1:N VERSION_RECETA; detalle de Insumos por versión; PREPARACION referencia PK compuesta de versión; MOVIMIENTO_INSUMO conserva consumos y costos históricos.
- **Reposición:** EPISODIO_FALTANTE persistido como entidad técnica que ancla las rondas; asociaciones PROVEEDOR_INSUMO temporales; una respuesta definitiva por invitación, respuestas fuera de plazo no ingresan.
- **Inventarios:** movimientos de Insumos y REVENTA independientes. Solo Productos REVENTA mantienen stock de producto; elaborados por Preparación/Excedentes. Recepciones congelan unidad recibida y factor aplicado. Costos promedio móviles de REVENTA; costos históricos de Insumos/Producción.
- **Finanzas:** COBRO puede no asociarse a Pedido. Cuenta Corriente y Libro Diario como vistas derivadas; movimientos financieros idempotentes; REEMBOLSO único por Cobro, completo, con intentos y eventos diferenciados. Solo PROCESADO provoca un AJUSTE_DEBITO y EGRESO de Caja.
- **Modelo Relacional:** 59 tablas distintas, 444 atributos y 120 vínculos FK después de aprobar la FK de procedencia. Ficheros fuente: Esquema_Maestro_Relacional_59_Tablas_ACTUALIZADO_23-10-2026.md y diagramas. DDL sigue referencial, no ejecutado ni validado para producción.

## Criterios formales aplicables a todos los bloques
1FN atomizar nombres/direcciones; 2FN sin dependencias parciales; 3FN sin transitivas indebidas, justificando snapshots y saldos derivados cuando sean materializaciones controladas. Tipos físicos, PK, FK, AK/UNIQUE, nulabilidad, `CHECK` conscientes de SQL NULL, ON DELETE/UPDATE y triggers diferidos cuando se requiera existencia de hijos/validación entre tablas. Siempre distinguiendo aprobado vs propuesta vs pendiente.

---
## Antecedente conceptual íntegro del 21/10 (usar con precedencia de actualización superior)

# **B. DOMINIO Y DISEÑO — Sistema de Gestión «Ale Milanesas»**

> **Versión consolidada de trabajo: 19/10/2026.** Incorpora las decisiones de la conversación 11/10–19/10/2026 y sustituye las formulaciones incompatibles de la línea base del 13/10. Es fuente conceptual del proyecto: **no equivale todavía a un DER ni a un diagrama UML definitivo**, y las decisiones pendientes se mantienen señaladas.

## **1\. Alcance, metodología y arquitectura prevista**

* Negocio único de elaboración y venta de milanesas de pollo, con entrega a domicilio, productos ELABORADOS y de REVENTA, pedidos internos y online.  
* Proceso Unificado adaptado, UML y análisis orientado a objetos (criterios de Larman). **Modelo de Dominio:** conceptos, propiedades y asociaciones del negocio; no controladores, repositorios, pantallas, servicios de Spring ni esquema físico PostgreSQL.  
* **Tecnologías previstas, no entidades de dominio:** Android Kotlin \+ Room \+ cola offline; backend Java/Spring Boot; web Thymeleaf; PostgreSQL; MercadoPago; servicio de ruteo OSRM; mensajería WhatsApp mediante proveedor por definir. La selección tecnológica es un contexto de diseño, no determina la ontología conceptual.  
* **Fuera de alcance:** ERP general, SaaS multiempresa, facturación fiscal, contabilidad formal, cuentas a pagar a proveedores, optimización exacta de rutas y utilidad/margen neto.  
* **Notación de evidencia en este archivo:** `APROBADO` \= decisión expresa del usuario; `BASE` \= descrito en fuentes previas o en las fichas históricas; `MODELO CANDIDATO` \= concepto presente cuya representación exacta todavía no fue aprobada; `PENDIENTE` \= falta definición o ratificación. Las etiquetas no deben interpretarse como clases UML de implementación.

## **2\. Núcleo de Pedidos, Clientes y Reparto**

### **Cliente — BASE \+ aprobación DEC-P2-004**

Atributos documentados: `id`, `nombre`, datos de `contacto` (incluido teléfono para detección de duplicados), `direccion`, `zona`, `diaHabitual`, `activo`, `categoriaComercial`, `fechaAlta` y datos suficientes para calcular antigüedad de deuda. **No se asume que `categoriaComercial` esté físicamente almacenada en lugar de derivarse.**

* Un Cliente puede originar múltiples Pedidos; cada Pedido pertenece a un Cliente. La cardinalidad funcional se deduce de RF-01 e IRQ-01/05; se verificará gráficamente en UML.  
* `UC-33 — Modificar Cliente` (antes UC-38): Vendedor, con intervención administrativa según permisos; modifica identidad/contacto/reparto, **no** estado, categoría ni saldo. Previene duplicados por combinación normalizada de nombre \+ teléfono (excluyendo la misma identidad); si los datos son insuficientes solo advierte posible coincidencia.  
* `UC-39 — Cambiar Estado de Cliente` (antes UC-44): Administrador; al inactivar exige motivo, conserva historia y Pedidos pendientes; Cliente inactivo no admite nuevos Pedidos, Promociones ni ofertas de Excedente, pero sí regularización de Cuenta Corriente. No confundir `activo` con `categoriaComercial`.

### **Pedido — BASE \+ DEC-P2-005/006/008 \+ actualización 14/10**

Atributos identificados: `id`, `cliente`, `fechaCarga` o `fechaHoraCarga`, `fechaReparto`, `estado` (`PENDIENTE | ENTREGADO | CANCELADO`), `canalOrigen` (`INTERNO | ONLINE`), `tipoAjuste`, `porcentajeAjuste`, `total` confirmado y motivo de cancelación cuando proceda. **La denominación `canalOrigen` reemplaza al atributo ambiguo `origen` únicamente en Pedido.** Sincronización offline y estado de Preparación constituyen dimensiones diferentes, no nuevos valores de `Pedido.estado`.

* Un Pedido tiene **uno o más** Detalles, cada Detalle pertenece a un Pedido y referencia un Producto.  
* `Pedido.totalOriginal` y los ajustes/Promociones originalmente aplicables quedan congelados al registrarse; no recalcular ni reescribir ese total al entregar. Por EXC-05 aprobado, las reasignaciones de Excedente aceptadas registran incrementos comerciales y `totalVigente = totalOriginal + suma(incrementosConfirmados)`; los incrementos no alteran el precio ni el ajuste histórico originales.  
* Un Pedido **PENDIENTE** de `canalOrigen` INTERNO u ONLINE puede asignarse/reasignarse por el Vendedor; ENTREGADO o CANCELADO no se asignan ni reasignan.  
* Existe **como máximo un Repartidor vigente por Pedido**, aunque puede estar temporalmente sin asignar. Un Repartidor puede tener muchos Pedidos.  
* El historial de asignaciones se representa mediante la clase conceptual aprobada `AsignacionReparto`, conservando fecha/hora, Vendedor responsable, Repartidor anterior, Repartidor nuevo y motivo obligatorio de reasignación.  
* UC-04 recupera los Pedidos asignados al Repartidor autenticado; UC-26 genera rutas solo con los PENDIENTE de ese Repartidor y fecha. Un cambio de asignación invalida la ruta sugerida previa; UC-05 comprueba la vigencia de la asignación antes de registrar Entrega.

### **DetallePedido — BASE \+ DEC-P2-005**

Atributos: `id`, `pedido`, `producto`, `cantidadSolicitada`, `cantidadEntregada`, unidad relevante, `precioUnitario` **histórico congelado** y `subtotal`. Debe persistir o ser reproducible la Promoción porcentual congelada por Detalle, para calcular la venta efectiva sin consultar una Promoción modificada con posterioridad.

* `cantidadEntregada <= cantidadSolicitada` y no negativa.  
* La Entrega es **única y definitiva** por Pedido: si se entrega menos que lo solicitado, el Pedido finaliza en `ENTREGADO`, sin remanente abierto como entrega futura.  
* La venta efectiva usa cantidad realmente entregada × precio congelado, menos el descuento promocional congelado; luego se aplica el ajuste global congelado del Pedido.  
* Si un Pedido ONLINE tenía prepago superior a la venta efectiva, la diferencia permanece como saldo a favor; no nace un Reembolso automático por esa sola diferencia.



**EXC-DET-01 — RECTIFICACIÓN APROBADA 21/10.** Conservar cantidad originalmente solicitada (para imputación comercial), además de incrementos históricos por MovimientoExcedente; en Entrega parcial imputar primero unidades originales y luego añadidas, sin extender la promoción original a las añadidas. No se aprobó imponer `cantidadVigente` como atributo derivado ni redefinir automáticamente PROD-03. Fórmula exacta de UC-05 y cota de UC-29: control de conciliación pendiente.
### **Entrega — CLASE CONCEPTUAL APROBADA**

`Entrega` representa el hecho comercial definitivo por el que se registran las cantidades efectivamente entregadas de un Pedido. Mantiene fecha/hora, Pedido, cantidades efectivas por Detalle y las referencias necesarias para conservar los efectos de Cuenta Corriente, inventario REVENTA, costos históricos y Excedentes. **No es un mero estado del Pedido.**

### **AsignacionReparto — CLASE CONCEPTUAL APROBADA**

Representa el historial de asignación y reasignación de un Pedido a Repartidores. Debe conservar el Pedido, el Repartidor asignado, el Vendedor responsable, fecha/hora y el motivo cuando exista una reasignación. La existencia de esta clase conceptual está aprobada; su traducción a tablas y claves pertenece al Modelo de Datos posterior.

Multiplicidad funcional vigente: un Pedido puede poseer `0..*` registros históricos de AsignacionReparto y **0..1 Repartidor vigente**; un Repartidor puede tener `0..*` Pedidos vigentes o históricos asociados.

### **RutaSugerida — CLASE CONCEPTUAL APROBADA 20/10/2026**

Concepto de resultado que conserva la secuencia sugerida, fecha/hora de generación, Repartidor y asignaciones de Pedidos consideradas. Debe conservar su identidad conceptual e historial de generación y quedar obsoleta si cambian asignaciones; **la forma de persistencia pertenece al Modelo de Datos y no se garantiza una optimización matemática exacta**. Relaciona Pedidos, direcciones y referencias geográficas; el proveedor OSRM pertenece a infraestructura, no al dominio.

## **3\. Usuarios, roles y autorizaciones**

### **Usuario — BASE \+ decisiones 17/10**

Atributos documentados: `id`, `nombreUsuario`, `credencialProtegida`, `estado`, `fechaAlta`. La credencial se conserva protegida conforme RNF-02.

* **Todo Usuario debe tener al menos un Rol durante toda su existencia.** La política anterior que admitía Usuarios sin Roles queda reemplazada.  
* El Administrador crea el Usuario junto con su asignación inicial de uno o más Roles. UC-19 puede agregar, quitar o sustituir Roles, pero no dejar al Usuario con cero Roles.  
* Autenticación y autorización continúan siendo conceptos distintos: autenticarse no concede permisos ajenos a los Roles asignados.

### **Rol — BASE \+ actualización 17/10**

Roles documentados: Administrador, Vendedor, Responsable de Producción, Repartidor y `PROVEEDOR`. El catálogo exacto de permisos internos sigue sujeto a validación detallada.

* Asociación: cada `Usuario` se vincula con `1..* Rol`; un `Rol` puede estar vinculado con `0..* Usuario`.  
* El actor Administrador es un Rol operativo de Usuario; no una identidad independiente.  
* El Cliente ONLINE no se fuerza como Rol del mismo mecanismo mientras su autenticación no haya sido definida.

### **Cuenta de acceso de Proveedor — REGLAS APROBADAS**

Proveedor comercial y Usuario de acceso son conceptos distintos.

* Un Proveedor puede tener `0..*` Usuarios históricos vinculados, con **como máximo uno habilitado simultáneamente**.  
* Todo Usuario con Rol `PROVEEDOR` representa exactamente un Proveedor y no combina ese Rol con Roles internos.  
* El Administrador crea la cuenta de Proveedor con contraseña temporal; el Proveedor debe cambiarla antes de registrar respuestas de cotización.  
* La recuperación es asistida por el Administrador después de verificar identidad y emite una nueva credencial temporal.  
* Revocar el acceso deshabilita la cuenta e invalida las sesiones activas, sin borrar la trazabilidad.  
* La RespuestaCotizacion conserva tanto el Proveedor comercial como el Usuario que la registró.

## **4\. Catálogo comercial, Recetas, Producción y Costos de Insumos**

### **Producto — BASE \+ P03**

Atributos: `id`, `nombre`, `descripcion` cuando conste, `tipoProducto` (`ELABORADO | REVENTA`), `unidadVenta`, `activo` e información de catálogo. **Insumo no es una subclase ni un tipo de Producto.**

* Si Producto carece de referencias dependientes, tipo y unidad de venta pueden corregirse; si tiene referencias históricas dependientes, se bloquean y la nueva modalidad comercial requiere un Producto nuevo.  
* Desactivar Producto no elimina precios, Recetas, movimientos, existencias ni Pedidos anteriores.  
* Para Producto `REVENTA`, `stockActual` y `costoPromedioActual` se modelan como propiedades conceptuales del Producto; no se incorpora `ExistenciaReventa` como clase conceptual independiente.

### **Precio — BASE \+ P09 y DEC-UC20/21**

`producto`, `precioBase`, `vigenteDesde`, `vigenteHasta`, `estado` cuando corresponda. Cada Producto puede conservar `0..*` versiones de Precio, pero como máximo una aplicable por instante.

* Altas inmediatas y programadas futuras; sin retroactividad; importes estrictamente positivos; intervalos sin solapamiento.  
* Una programación futura puede modificarse o cancelarse antes de entrar en vigor, dejando auditoría.  
* UC-21 diferencia históricos, vigente y futuros, incluso para Producto inactivo.

### **Insumo — BASE \+ P01 \+ reglas de episodio 18–19/10**

`id`, `nombre`, `unidadMedida`, `stockActual`, `umbralMinimo`, `nivelObjetivoReposicion`, `automatizacionCompraActiva`, `activo`.

* `nivelObjetivoReposicion > umbralMinimo`.  
* La cantidad requerida por una ronda se calcula como `nivelObjetivoReposicion - stockActual` con el stock vigente al iniciarla y queda congelada al emitir la Solicitud.  
* Un **episodio de faltante** es una regla transversal, no una clase aprobada. Se reconoce cuando el stock queda por debajo del umbral y se cierra cuando vuelve a `>= umbralMinimo` y no quedan Solicitudes en curso ni Órdenes pendientes de recepción asociadas.  
* Solo el flanco de bajada causado por un movimiento de stock puede disparar la primera ronda automática, y como máximo una por episodio, siempre que la automatización esté activa, el Insumo activo y exista al menos un Proveedor invitable.  
* Cambios de umbral, activación de automatización o habilitación posterior de un Proveedor **no generan rondas retroactivas**.  
* Cambiar `nivelObjetivoReposicion` no altera Solicitudes ya emitidas.  
* Si no existen destinatarios invitables, se conserva el faltante y una alerta, sin crear Solicitud ficticia ni consumir la ronda automática.

### **Receta y DetalleReceta — BASE \+ P01**

* `Receta`: `id`, Producto ELABORADO, `version`, `vigenteDesde`, `vigenteHasta`, `rendimientoBase` y datos de identificación necesarios.  
* `DetalleReceta`: Receta, Insumo, `cantidadNecesaria`, UnidadMedida.  
* Modificar una Receta crea una nueva versión sin mutar la utilizada históricamente.  
* UC-10 configura Recetas; UC-32 configura parámetros de reposición.

### **Preparacion — CLASE CONCEPTUAL APROBADA**

Representa cada preparación parcial o total de un Producto ELABORADO para un Pedido/DetallePedido. Conserva `cantidadPreparada`, `fechaHora` y la versión de Receta empleada. Puede haber múltiples Preparaciones acumulativas dentro de los límites del Pedido; su estado operativo se deriva de los registros y **no agrega estados a Pedido**.

* Únicamente UC-29 consume Insumos por producción.  
* El consumo se registra como `MovimientoInsumo` de tipo `CONSUMO_PRODUCCION` asociado a la Preparacion y al Insumo, congelando cantidad y costo histórico.  
* **No se crea la clase conceptual `ConsumoPreparacion`.**  
* Una reasignación de Excedente no crea Preparación ficticia ni doble consumo.

### **CostoInsumoHistorico — CLASE CONCEPTUAL APROBADA**

Representa la valoración temporal del Insumo y permite reproducir costos históricos. Conserva Insumo, costo unitario, vigencia/fecha desde, fuente y referencia de origen. La recepción efectiva de una compra puede establecer un nuevo costo; emitir una OrdenCompra por sí sola no lo hace.

La necesidad de registrar una valoración inicial está reconocida, pero **no se crea por defecto una clase `ValoracionInicialInventario`** sin justificación adicional.

## **5\. Inventarios independientes, movimientos y recepciones**

### **MovimientoInsumo — CLASE/CONCEPTO CONSOLIDADO**

Relaciona Insumo, `tipo`, `cantidad`, `fechaHora`, `origen`, `referencia`, observación, motivo cuando corresponda y datos históricos de costo. Tipos funcionales: `INGRESO_COMPRA | CONSUMO_PRODUCCION | AJUSTE_POSITIVO | AJUSTE_NEGATIVO`.

* Recepción efectiva → ingreso.  
* Preparacion → consumo `CONSUMO_PRODUCCION`.  
* UC-43 → ajuste con motivo.  
* La cantidad se registra positiva y el tipo determina el efecto; no se permite stock negativo.

### **Inventario REVENTA — DECISIÓN CONCEPTUAL APROBADA**

No se modela `ExistenciaReventa` como clase conceptual independiente. Para un Producto de tipo `REVENTA`, `stockActual` y `costoPromedioActual` son propiedades conceptuales del Producto. Esta decisión **no impide** que el futuro Modelo de Datos normalice físicamente la información.

### **MovimientoStockReventa — CONCEPTO HISTÓRICO VIGENTE**

Conserva Producto, tipo de movimiento, cantidad, UnidadMedida, stock anterior/resultante, fecha/hora, origen/referencia, motivo/observación, Usuario responsable y costos históricos cuando correspondan.

* Ingreso por compra recalcula costo promedio ponderado móvil con la información efectiva recibida.  
* Entrega descuenta la cantidad realmente entregada y congela el costo promedio vigente como costo histórico del egreso.  
* Productos ELABORADOS no usan inventario general de REVENTA.

### **RecepcionCompra — CLASE CONCEPTUAL APROBADA**

Representa la recepción física de mercadería. Puede vincularse a una OrdenCompra o, cuando el proceso permitido lo contemple, a una compra registrada sin Orden previa. Conserva cantidad efectivamente recibida, fecha/hora y referencias a los movimientos de inventario generados.

Una OrdenCompra puede tener varias recepciones parciales. La recepción, y no la mera emisión de la Orden, es el hecho que incrementa existencias.

## **6\. Proveedores, cotizaciones y resolución de compras**



**DECISIÓN VIGENTE 21/10 — REC-PROV-01.** Cada RecepcionCompra se vincula opcionalmente a 0..1 Proveedor y el Proveedor conserva 0..* recepciones históricas. Si hay OrdenCompra, coincide el Proveedor de ambos. Sin Orden se informa Proveedor registrado, o una referencia comercial suficiente del origen si no está identificado. No crear CompraSinOrden. OrdenCompra de UC-12 refiere Insumo; REVENTA se recibe sin Orden en el alcance documentado de UC-08.
### **Proveedor y ProveedorInsumo — CLASES CONCEPTUALES APROBADAS**

* `Proveedor`: identidad comercial, contacto, estado y antecedentes.  
* `ProveedorInsumo`: asociación histórica/vigente entre Proveedor e Insumo. Su vigencia importa para la invitabilidad y para conservar qué podía proveer en cada momento.  
* Proveedor y Usuario de acceso son conceptos distintos; ver sección 3\.

### **Invitabilidad e invitaciones — REGLAS APROBADAS**

Al emitir una `SolicitudCotizacion`, un Proveedor es invitable si:

1. `Proveedor.estado = ACTIVO`;  
2. existe `ProveedorInsumo` vigente para el Insumo;  
3. existe un Usuario habilitado vinculado al Proveedor.

Los antecedentes de cumplimiento **no** filtran la invitación; intervienen en `PoliticaCompra`.

* Los destinatarios se fijan al emitir y no se recalculan después.  
* Una ronda automática invita a todos los invitables.  
* Una ronda manual permite al Administrador seleccionar un subconjunto no vacío; los Proveedores sin cuenta habilitada pueden mostrarse como no invitables por falta de acceso.  
* Una suspensión posterior no borra la invitación histórica.  
* Una cuenta deshabilitada no puede responder.  
* Una oferta de un Proveedor que ya no está ACTIVO al momento de decidir la compra no es elegible.

La invitación histórica puede modelarse como asociación con datos propios; **no se obliga aquí a crear una clase conceptual adicional** si el UML puede expresar adecuadamente la información.

### **SolicitudCotizacion — CLASE CONCEPTUAL APROBADA**

Conserva Insumo, cantidad solicitada congelada al emitir, fecha/hora, plazo, destinatarios y la información necesaria para distinguir inicio automático/manual y encadenamiento de rondas.

* Cada episodio puede tener cero o una cadena de Solicitudes; cada cadena corresponde a un único episodio.  
* La primera Solicitud de una cadena no tiene antecedente.  
* Una ronda manual posterior se enlaza con la última Solicitud de la cadena.  
* La autoasociación antecedente/sucesora [0..1]/[0..1] lineal, sin ciclos y para el mismo Insumo quedó aprobada el 20/10; queda pendiente reflejarla gráficamente en MDALE.  
* `modalidadInicio = AUTOMATICA | MANUAL` es un **atributo conceptual aprobado el 20/10/2026**. Si una Solicitud tiene antecedente, es MANUAL; la primera puede ser AUTOMATICA o MANUAL.



**COT-MOT-01 APROBADA 21/10.** `estado` conceptual: RECEPCION_ABIERTA | PENDIENTE_DECISION | RESUELTA_CON_COMPRA | RESUELTA_SIN_COMPRA; `motivoCierre` opcional fuera de cierre sin compra, con SIN_RESPUESTAS | SIN_OFERTAS_ELEGIBLES | DECISION_ADMINISTRATIVA_SIN_COMPRA. `estado=RESUELTA_SIN_COMPRA ⇔ motivoCierre` toma exactamente uno de esos tres. Cierre administrativo ⇔ DecisionCompra.resultado=SIN_COMPRA; compra confirmada ⇔ DecisionCompra.resultado=COMPRA y OrdenCompra. Cierres automáticos carecen de DecisionCompra. Si una reevaluación desde PENDIENTE_DECISION deja cero ofertas elegibles, cierre automático SIN_OFERTAS_ELEGIBLES. No aceptar respuesta extemporánea.
### **RespuestaCotizacion — CLASE CONCEPTUAL APROBADA**

Conserva Solicitud, Proveedor, Usuario que registró la respuesta, precio, disponibilidad/cantidad, tiempo/plazo de entrega y fecha/hora.

* El portal es el único canal de respuesta documentado.  
* Toda Respuesta proviene de un Proveedor invitado.  
* Como máximo una respuesta definitiva e inmutable por Proveedor y Solicitud.  
* **COT-17 (20/10):** la confirmación posterior al vencimiento es rechazada y no crea RespuestaCotizacion. Sustituye la antigua admisión histórica de tardías. El cierre no se reabre.

### **PoliticaCompra, DecisionCompra y DetalleDecision — CLASES CONCEPTUALES APROBADAS**

* `PoliticaCompra` conserva la configuración de criterios de comparación, incluyendo precio, disponibilidad/plazo, confiabilidad e habitualidad cuando correspondan. Los pesos `40/25/25/10` fueron ilustrativos y **no están aprobados**.  
* El sistema puede evaluar/rankear ofertas, pero **no decide ni autoriza la compra**.  
* `DecisionCompra` representa la resolución adoptada por el Administrador, con fecha/hora, alternativa elegida o cierre sin compra, política aplicada y justificación.  
* `DetalleDecision` preserva los valores/puntajes de cada alternativa para auditoría.  
* Si no hay respuestas, la Solicitud se cierra automáticamente sin compra con `SIN_RESPUESTAS`.  
* Si hay respuestas pero ninguna oferta es elegible, se cierra automáticamente con `SIN_OFERTAS_ELEGIBLES`.  
* Si existen ofertas elegibles, la Solicitud queda pendiente de decisión del Administrador: puede seleccionar una, justificar y confirmar la compra, o cerrar sin compra con justificación.  
* Ninguna `OrdenCompra` se emite sin confirmación expresa del Administrador.

### **OrdenCompra — CLASE CONCEPTUAL APROBADA**

Conserva Proveedor, Insumo, cantidad, fecha de emisión, fecha comprometida cuando corresponda, estado, vínculo con la DecisionCompra y Recepciones.

* Cancelar una Orden no reescribe la Solicitud que históricamente la originó.  
* Si tras cancelarla el stock continúa bajo, no hay nuevo disparo automático; se alerta y el Administrador puede iniciar UC-45.  
* Una Orden completamente recibida tampoco cierra necesariamente el episodio: si el stock sigue bajo y no existe otra Solicitud u Orden pendiente, el Administrador puede iniciar otra ronda manual.  
* Las cancelaciones atribuibles al Proveedor forman parte de sus antecedentes de confiabilidad según la política finalmente definida.



**INV-04 APROBADA 21/10.** Estados `PENDIENTE`, `PARCIALMENTE_RECIBIDA`, `RECIBIDA`, `CANCELADA`. PENDIENTE puede pasar directamente a RECIBIDA o parcialmente recibida; parcial puede acumular hasta completa o cancelarse. Se cancela solo desde PENDIENTE/PARCIALMENTE_RECIBIDA, con motivo/fecha/responsable; RECIBIDA y CANCELADA son finales. Recepciones acumuladas <= cantidad ordenada; cancelar no revierte ingresos previos ni dispara nueva ronda automática. `VENCIDA` no es estado.
### **Distribución funcional vigente**

* **Comportamiento automático:** detectar el flanco de faltante y, si se cumplen condiciones, emitir la primera ronda del episodio.  
* **UC-13:** Proveedor registra su respuesta.  
* **UC-12 — Evaluar Cotizaciones y Resolver Compra:** Administrador revisa la evaluación, decide comprar o cerrar justificadamente y confirma toda Orden.  
* **UC-45 — Iniciar Ronda Manual de Cotización:** Administrador inicia la primera ronda manual si no pudo emitirse la automática o una ronda posterior dentro del episodio.  
* **UC-08:** registra recepción física.  
* **UC-40:** cancela una Orden existente.  
* **UC-14:** histórico/no vigente; su código no se reutiliza.

## **7\. Clientes: categoría comercial y política de ajustes**

* `CategoriaComercial`: `CUMPLIDOR | EN_MORA`; deriva de saldo, historial de MovimientoCuenta y antigüedad de deuda. No inventar umbrales numéricos ni asimilar Cuenta Corriente a Caja.  
* `PoliticaCategoriaComercial` (concepto del historial): `diasToleranciaMora`, `ajusteCumplidor`, `ajusteEnMora`, `vigenciaDesde`, `vigenciaHasta`. Existe una propuesta histórica para imputar primero a deudas antiguas y reevaluar al crear un Pedido y ante cambios relevantes; **verificar aprobación expresa y regla exacta antes de fijar el algoritmo como definitiva**.  
* Ajuste global `DESCUENTO | RECARGO | SIN_AJUSTE`, con porcentaje congelado en `Pedido` al registrar nuevo Pedido INTERNO u ONLINE; no modifica el `Precio` base de Producto ni los Pedidos pasados.

## **8\. Finanzas: Cuenta Corriente, Cobros, Caja y Reembolsos**

### **MovimientoCuenta / CuentaCorriente — BASE**

`MovimientoCuenta`: `cliente`, `pedido` **opcional**, `tipo` (`CARGO_POR_VENTA | PAGO | AJUSTE_DEBITO | AJUSTE_CREDITO`), `importe`, `fechaHora`, `saldoResultante`, `observacion`.

* `CuentaCorriente` es concepto agregado/saldo calculado a partir de Movimientos de Cliente. **No imponer una clase persistente autónoma sin justificación conceptual adicional.** Un Cobro anticipado, parcial o excedente puede originar saldo a favor. UC-15 presenta saldo actual y movimientos completos, con filtro por período que **no altera el saldo actual** (DEC-UC15-001).  
* Entrega → `CARGO_POR_VENTA` de venta efectiva. Cobro → `PAGO`. Reembolso PROCESADO → contramovimiento que revierte el efecto financiero del Cobro original, sin eliminar asientos previos.

### **Cobro — BASE**

`cliente`, `fechaHora`, `importe`, `medioPago` (`EFECTIVO | TRANSFERENCIA | MERCADOPAGO | OTRO`), `origen` (`REPARTO | ONLINE | ADMINISTRACION`), `referenciaExterna`, `estado`. **Pedido no es obligatorio**. Cobro puede ser anticipado/parcial/exacto/superior al saldo; su registro y sus efectos en Cuenta Corriente/Caja son transaccionales e idempotentes cuando corresponde.

### **MovimientoCaja / Caja — BASE \+ DEC-UC23-001**

`MovimientoCaja`: `tipo` (`INGRESO | EGRESO`), `importe`, `fechaHora`, `concepto`, `origen`, `referencia` y **`observacion` opcional** (APROBADO). Para **movimientos manuales** el `concepto` es obligatorio; no extender esta regla a todos los automáticos sin respaldo. Caja/LibroDiario es resultado de movimientos monetarios y no equivale a CuentaCorriente.

* UC-23 registra ingresos/egresos manuales; UC-30 origina `INGRESO` por Cobro; UC-27 origina `EGRESO` únicamente con Reembolso `PROCESADO`. Un mismo Cobro/Reembolso no genera dos movimientos por reintentos.  
* UC-24 consulta movimientos manuales y automáticos del período y calcula `totalIngresos - totalEgresos` como **resultado monetario del período**, no utilidad neta ni saldo acumulado de Caja. No se inventa una entidad separada `LibroDiario` si es una vista/consulta.

### **Reembolso — BASE \+ P06**

`cobroOriginal`, `importe`, `fechaHora`, `motivo`, `estado` (`PENDIENTE | PROCESADO | RECHAZADO`), `referenciaExterna`. Se relaciona con Cobro original y contramovimientos financieros.

* Un Reembolso pendiente/rechazado no invalida la Cancelación del Pedido; se conserva el estado y se permite tratamiento posterior sin duplicados.  
* UC-27 se activa condicionalmente cuando existe Cobro electrónico reembolsable en contexto de cancelación, pero puede existir otra causal admitida en el alcance general del proceso. No presuponer exclusividad del vínculo con UC-06.

## **9\. Excedentes, ofertas, reasignaciones y descartes**



**FIN-03/04 y B4 CERRADOS 21/10.** Cada Cobro electrónico tiene 0..1 Reembolso lógico, cada Reembolso pertenece exactamente a 1 Cobro. No hay devoluciones parciales; suma de importes PENDIENTES+PROCESADOS <= cobroOriginal. Los reintentos sobre RECHAZADO reutilizan la misma instancia y conservan el historial de resultado/referencia; resultado incierto mantiene PENDIENTE. Solo PROCESADO genera una vez sus efectos de Caja y CuentaCorriente. RF-18/RNF-04 NO se derogan: idempotencia de negocio, no tokens en diagrama conceptual.
### **Excedente — CLASE CONCEPTUAL APROBADA**

Producto ELABORADO, Pedido origen, cantidad inicial, cantidad disponible, costo histórico atribuible, fecha y estado. Surge de producto preparado que queda sin destino después de Entrega o Cancelación.

* Cancelar no revierte consumos de Insumos ya efectuados.  
* Un Excedente puede repartirse entre varios Pedidos receptores.  
* El Pedido receptor recibe producto ya preparado: no ejecuta UC-29 sobre esa cantidad ni duplica consumo o costo.



**EXC-CANC-01 VIGENTE 21/10.** Al cancelar un Pedido receptor, el ELABORADO previamente reasignado aún disponible se conserva como un nuevo Excedente vinculado al Pedido cancelado, con costo histórico transferido; no reabrir Excedente original ni duplicar Insumos consumidos. No agregar por esta decisión una restricción adicional `{xor}`.
### **OfertaExcedente — CLASE CONCEPTUAL APROBADA**

Representa la oferta comercial de una cantidad disponible a un Cliente/Pedido candidato y su respuesta. **Ofrecer no reduce la cantidad disponible**.



**EXC-OFER-01 VIGENTE 21/10.** La oferta conserva cantidad, importe informado, fecha/hora y respuesta del Cliente; ante cambio de cantidad antes de confirmar se recalcula importe y se obtiene nueva aceptación. MovimientoExcedente conserva el incremento económico aceptado y costo histórico. No se exige una Oferta nueva por toda variación de importe ni se decide aquí el versionado físico.
### **MovimientoExcedente — CLASE CONCEPTUAL APROBADA**

Registra la salida efectiva de Excedente por `REASIGNACION` o `DESCARTE`, con cantidad, fecha/hora, destino o motivo según corresponda y costo histórico transferido/conservado.

* Reasignar o descartar sí reduce `cantidadDisponible`.  
* Descarte total → Excedente agotado; parcial → mantiene remanente.  
* El descarte no se imputa automáticamente como costo de venta de una Entrega.

**Pendiente comercial P-001:** definir de forma definitiva cómo se preserva/recalcula el total histórico/comercial del Pedido receptor cuando UC-07 agrega una cantidad por reasignación de Excedente.

## **10\. Promociones, canal ONLINE y comunicaciones**



**EXC-CC-01 VIGENTE 21/10.** UC-07 registra incremento comercial y saldo pendiente del Pedido sin generar MovimientoCuenta. La entrega por UC-05 genera CARGO_POR_VENTA por cantidades efectivamente entregadas, integrando incrementos confirmados; no se altera Cobro ONLINE original. No se impone saldoPendiente como atributo necesariamente derivado. Sobrepago ONLINE y prorrateo promocional se verifican en UC-05.
### **Promocion — CLASE CONCEPTUAL APROBADA**

Representa la promoción comercial: Productos alcanzados, porcentaje de descuento, vigencia, estado y reglas de aplicación. El Administrador es el actor principal de UC-25; la promoción porcentual documentada aplica al canal ONLINE y se evalúa al crear el Pedido.

### **DestinatarioPromocion — CLASE CONCEPTUAL APROBADA**

Conserva qué Cliente fue seleccionado/destinatario de una Promocion y la información necesaria para distinguir la selección del resultado de envío. La selección de destinatarios no se confunde con el mensaje concreto enviado.

### **IntentoComunicacion — CLASE CONCEPTUAL APROBADA**

Registra cada intento de comunicación de una Promocion a un DestinatarioPromocion, con fecha/hora, canal y resultado. Los reintentos deben evitar duplicar envíos ya confirmados. No se modela como entidad de dominio cada mensaje interno del proveedor externo de mensajería.

* `DetallePedido` conserva la Promocion efectivamente aplicada para que UC-05 no reevalúe el descuento al entregar.  
* Pedido ONLINE utiliza el mismo Pedido/DetallePedido y se distingue mediante `canalOrigen = ONLINE`.  
* Pago electrónico e idempotencia son independientes de la mera creación del Pedido ONLINE.

Pendientes: reglas exactas ante múltiples Promociones simultáneamente elegibles, catálogo definitivo de estados y política de redondeo cuando no consten aprobadas.

## **11\. Margen bruto y atribución histórica**

* `UC-28 — Consultar Margen Bruto` evalúa venta efectiva de las Entregas menos costos históricos atribuibles de Productos ELABORADOS y REVENTA, para un período.  
* En ELABORADO, el consumo confirmado congela costos históricos de Insumos; el costo de porciones vendidas se deriva sin imputar nuevamente cantidades reasignadas.  
* En REVENTA, el `MovimientoStockReventa EGRESO_VENTA` conserva costo promedio móvil histórico de la fecha de Entrega.  
* El costo histórico de Excedentes descartados no se carga automáticamente como «costo de ventas», pues no es una venta efectiva; debe permanecer trazable para otras consultas pertinentes.  
* Quedan excluidos alquiler, sueldos, servicios, gastos generales, impuestos y margen/ganancia neta.  
* **PENDIENTE:** comprobar tratamiento de unidades/precision/redondeos, devoluciones o ajustes extraordinarios en el cálculo; no completar con parámetros supuestos.

## **12\. Asociaciones conceptuales principales y multiplicidades**

> Las multiplicidades no aprobadas expresamente permanecen marcadas como pendientes. Las decisiones conceptuales aprobadas no obligan todavía a una implementación física determinada.

| Extremos | Multiplicidad / regla conceptual | Estado |
| ----- | ----- | ----- |
| Cliente — Pedido | Cliente 1 ↔ Pedidos 0..\* | BASE |
| Pedido — DetallePedido | Pedido 1 ↔ Detalles 1..\* | BASE |
| DetallePedido — Producto | Detalle 1 ↔ Producto 1; Producto 0..\* Detalles | BASE |
| Usuario — Rol | Usuario `1..*` Roles; Rol `0..*` Usuarios | **APROBADO 17/10** |
| Proveedor — Usuario PROVEEDOR | Proveedor `0..*` Usuarios históricos; máximo 1 habilitado a la vez; cada Usuario PROVEEDOR ↔ exactamente 1 Proveedor | **APROBADO** |
| Pedido — AsignacionReparto | Pedido `0..*` registros históricos; 0..1 Repartidor vigente | **CLASE APROBADA** |
| AsignacionReparto — Repartidor/Vendedor | cada asignación identifica Repartidor y responsable del cambio | **APROBADO** |
| Pedido/DetallePedido — Preparacion | `0..*` Preparaciones para cantidades ELABORADO | **CLASE APROBADA; enlace exacto a contrastar** |
| Preparacion — MovimientoInsumo | Preparacion 1 ↔ `1..*` movimientos de consumo cuando corresponda | **DEC-DOM-B-004; cardinalidad final a auditar** |
| Producto ELABORADO — Receta | Producto `0..*` versiones | BASE |
| Receta — DetalleReceta — Insumo | Receta 1..\* Detalles; Insumo 0..\* Detalles | BASE |
| Producto REVENTA — MovimientoStockReventa | Producto `0..*` movimientos; stock/costo actual en Producto | **DEC-DOM-B-005** |
| Insumo — CostoInsumoHistorico | Insumo `0..*` valoraciones históricas | **CLASE APROBADA** |
| OrdenCompra — RecepcionCompra | Orden `0..*` Recepciones | **CLASE APROBADA; parcialidad admitida** |
| Proveedor — ProveedorInsumo — Insumo | `0..*` asociaciones históricas con vigencia | **CLASE APROBADA** |
| SolicitudCotizacion — Proveedor invitado | una Solicitud emitida invita a `1..*` Proveedores; un Proveedor puede ser invitado a `0..*` Solicitudes | **REGLA APROBADA** |
| SolicitudCotizacion — RespuestaCotizacion | `0..*` respuestas; máximo una definitiva por Proveedor invitado | **APROBADO** |
| SolicitudCotizacion — SolicitudCotizacion antecedente | primera 0 antecedente; una ronda manual posterior enlaza con la última de la cadena | **FUNCIONALMENTE APROBADO; detalle UML a auditar** |
| SolicitudCotizacion — DecisionCompra | resolución administrativa o cierre; cardinalidad física final a auditar | **CONCEPTO APROBADO** |
| DecisionCompra — DetalleDecision | detalles de evaluación por alternativas | **CLASE APROBADA** |
| DecisionCompra — OrdenCompra | una Orden solo surge de compra confirmada por Administrador | **APROBADO** |
| Cliente — Cobro | Cliente 1 ↔ Cobros 0..\* | BASE |
| Cliente — MovimientoCuenta | Cliente 1 ↔ Movimientos 0..\* | BASE |
| Cobro — Reembolso | Cobro electrónico 0..1 Reembolso lógico; cada Reembolso corresponde a 1 Cobro; los reintentos reutilizan instancia | **APROBADO 21/10, FIN-03** |
| Excedente — OfertaExcedente | Excedente 1 ↔ Ofertas 0..\* | **CLASE APROBADA** |
| Excedente — MovimientoExcedente | Excedente 1 ↔ Movimientos 0..\* | **CLASE APROBADA** |
| Promocion — DestinatarioPromocion | Promocion 1 ↔ Destinatarios 0..\* | **CLASE APROBADA** |
| DestinatarioPromocion — IntentoComunicacion | Destinatario 1 ↔ Intentos 0..\* | **CLASE APROBADA** |

## **13\. Enumeraciones del dominio (sin presuponer esquema físico)**

| Concepto | Valores respaldados / nota |
| ----- | ----- |
| `Pedido.estado` | `PENDIENTE`, `ENTREGADO`, `CANCELADO` |
| `Pedido.canalOrigen` | `INTERNO`, `ONLINE` |
| `Producto.tipoProducto` | `ELABORADO`, `REVENTA` |
| `MovimientoInsumo.tipo` | `INGRESO_COMPRA`, `CONSUMO_PRODUCCION`, `AJUSTE_POSITIVO`, `AJUSTE_NEGATIVO` |
| `MovimientoStockReventa.tipo` | `INGRESO_COMPRA`, `EGRESO_VENTA`, `AJUSTE_POSITIVO`, `AJUSTE_NEGATIVO` |
| `MovimientoCuenta.tipo` | `CARGO_POR_VENTA`, `PAGO`, `AJUSTE_DEBITO`, `AJUSTE_CREDITO` |
| `MovimientoCaja.tipo` | `INGRESO`, `EGRESO` |
| `Reembolso.estado` | `PENDIENTE`, `PROCESADO`, `RECHAZADO` |
| `MovimientoExcedente.tipo` | `REASIGNACION`, `DESCARTE` |
| `CategoriaComercial` | `CUMPLIDOR`, `EN_MORA` |
| `AjusteComercial.tipo` | `DESCUENTO`, `RECARGO`, `SIN_AJUSTE` según política, no valores porcentuales fijos |
| `OrdenCompra.estado` | `PENDIENTE`, `PARCIALMENTE_RECIBIDA`, `RECIBIDA`, `CANCELADA` **APROBADO INV-04 21/10/2026** |
| `Precio.estado` | Se conoce el concepto; enumeración exacta **NO CONSTA DEFINITIVA** |
| `Excedente.estado` | `DISPONIBLE`, `AGOTADO` en flujo UC-42; confirmar alcance completo |

## **14\. Reglas de integridad transversales**

1. **Identidad histórica:** no borrar hechos pasados para “corregir” estados; conservar trazabilidad y operaciones compensatorias cuando corresponda.  
2. **Entrega:** un solo evento definitivo por Pedido; cantidades efectivas dentro de lo solicitado.  
3. **Inventario:** sin stock negativo; ajustes con motivo y trazabilidad.  
4. **Separación de stock:** Insumo se consume en Preparacion; REVENTA en Entrega; ELABORADO no tiene stock comercial general terminado.  
5. **Costeo histórico:** congelar costos en consumos, venta REVENTA y movimientos de Excedente; cambios actuales no recalculan hechos pasados.  
6. **Consistencia financiera:** Cobro y Reembolso afectan Cuenta Corriente/Caja según sus reglas, con integridad e idempotencia cuando corresponda.  
7. **Reparto:** máximo un Repartidor vigente por Pedido; la reasignación conserva historial e invalida la ruta previa pertinente.  
8. **Precio:** único precio base aplicable por Producto e instante; sin retroactividad y con importes positivos.  
9. **Usuarios:** todo Usuario conserva al menos un Rol; una operación de Roles no puede dejarlo sin ninguno.  
10. **Cuenta PROVEEDOR:** un Usuario PROVEEDOR representa exactamente un Proveedor, no combina Roles internos y un Proveedor tiene como máximo una cuenta habilitada simultáneamente.  
11. **Invitación:** se fija al emitir según Proveedor ACTIVO \+ ProveedorInsumo vigente \+ Usuario habilitado. Cambios posteriores no borran la invitación.  
12. **Respuesta:** portal exclusivo, Proveedor invitado, una respuesta definitiva e inmutable por Proveedor/Solicitud; cuenta habilitada y, si corresponde, contraseña temporal ya cambiada.  
13. **Decisión de compra:** la evaluación automática no autoriza comprar; ninguna OrdenCompra se emite sin confirmación del Administrador.  
14. **Episodio de faltante:** como máximo una primera ronda automática efectivamente emitida; rondas posteriores son manuales. Cambios de configuración no disparan rondas retroactivas.  
15. **Cierre de Solicitud:** sin respuestas → `SIN_RESPUESTAS`; sin ofertas elegibles → `SIN_OFERTAS_ELEGIBLES`; con ofertas elegibles decide el Administrador.

## **15\. Pendientes para el futuro diagrama UML y modelo definitivo**

| ID | Definición pendiente | Tratamiento |
| ----- | ----- | ----- |
| PD-01 | Auditoría gráfica integral del UML y de multiplicidades | `AsignacionReparto`, `Entrega`, `Preparacion`, compras, excedentes y promociones ya poseen decisiones conceptuales, pero el diagrama generado durante la conversación mostró elementos aislados en algunas vistas y **no se considera definitivo**. |
| PD-02 | Cardinalidades físicas de RecepcionCompra, movimientos y abastecimiento REVENTA | La semántica conceptual está aprobada; el modelo lógico/DER decidirá tablas y claves. |
| PD-03 | **RESUELTO 20/10 — RutaSugerida CLASE conceptual** | Conservar fecha/hora, Repartidor, secuencia y asignaciones históricas; persistencia es diseño posterior. |
| PD-04 | **RESUELTO 21/10 — Cobro–Reembolso** | Una devolución completa lógica por Cobro, con reintentos sobre la misma instancia y efectos idempotentes. |
| PD-05 | Algoritmo exacto de categoría/mora y parámetros comerciales | No fijar cifras no aprobadas. |
| PD-06 | Ponderaciones de `PoliticaCompra`, proveedor sin historial, criterio “en término” y período | Los valores ilustrativos no son regla empresarial. |
| PD-07 | Precisión/redondeos monetarios, conversiones de UnidadMedida y costeo extraordinario | Requiere criterio técnico/negocio. |
| PD-08 | Cliente ONLINE: autenticación y relación con Usuario; bloqueo/sesión general | No inferir del esquema de cuentas internas/Proveedor. |
| PD-09 | Cobertura de CU para recuperación/revocación de credenciales de Proveedor | La política está aprobada; verificar si requiere CU específico o extensión documentada. |
| PD-10 | **RESUELTO 20/10 — EXC-05/P-001** | `totalVigente = totalOriginal + suma(incrementosConfirmados)`; ajustes/promociones sobre incrementos y prepago ONLINE aún requieren refinamiento. |
| PD-11 | Múltiples Promociones elegibles, estados exactos y redondeo | Pendiente de política. |
| PD-12 | **RESUELTO PARCIALMENTE 20/10**: estados, modalidad y encadenamiento | Aprobado `modalidadInicio {AUTOMATICA, MANUAL}`, antecedente/sucesora [0..1], cuatro estados conceptuales y tres motivos de cierre; queda pendiente solo el literal definitivo del tercer motivo y refinamiento exacto de transiciones. |
| PD-13 | RNF-08/09/11/12/14/15 y métricas de factibilidad | Continúan provisionales. |
| PD-14 | Catálogo exacto de permisos de cada Rol y autorizaciones adicionales de Repartidor | La cardinalidad mínima de Rol sí está cerrada; los permisos finos no. |

## **16\. Estado conceptual consolidado al 19/10/2026**

### **Clases/conceptos cuya incorporación fue aprobada durante la conversación**

Además de las clases ya presentes en la línea base, quedaron expresamente consolidadas `AsignacionReparto`, `Entrega`, `Preparacion`, `RecepcionCompra`, `CostoInsumoHistorico`, `ProveedorInsumo`, `SolicitudCotizacion`, `RespuestaCotizacion`, `PoliticaCompra`, `DecisionCompra`, `DetalleDecision`, `OrdenCompra`, `Excedente`, `OfertaExcedente`, `MovimientoExcedente`, `Promocion`, `DestinatarioPromocion` e `IntentoComunicacion`.

### **Conceptos que no deben introducirse como clases por defecto**

* `ConsumoPreparacion`: sustituido por `MovimientoInsumo` de tipo `CONSUMO_PRODUCCION` ligado a Preparacion.  
* `ExistenciaReventa`: stock y costo promedio se mantienen conceptualmente en Producto REVENTA.  
* `EpisodioFaltante`: regla transversal, no clase aprobada.  
* Una clase independiente exclusivamente para “cierre de Solicitud”: no necesaria; el resultado/motivo puede conservarse en la Solicitud/decisión según el UML final.  
* `CuentaCorriente`, `Caja` y `LibroDiario`: continúan tratándose como vistas/agregados derivados mientras no exista una decisión posterior que exija entidad conceptual autónoma.

## **17. Consolidación del Modelo de Dominio — decisiones APROBADAS 20/10/2026**

> Adenda prevaleciente frente a formulaciones anteriores incompatibles, sin borrar historia. Referencia: matriz Entrega 1 y DocGralAle versión 07.00; MDALE.drawio (ocho vistas) es fotografía previa del UML, no fuente superior de negocio.

### **17.1 Cotizaciones: Solicitud, invitaciones, respuestas, decisiones y Órdenes**

* `SolicitudCotizacion–Insumo`: cada Solicitud solicita 1 Insumo, cada Insumo 0..* Solicitudes. `cantidadSolicitada`, fecha/hora de emisión, vencimiento fijo al emitir y `modalidadInicio {AUTOMATICA|MANUAL}` pertenecen a la Solicitud; el nombre físico final del vencimiento queda refinable.
* `SolicitudCotizacion–Proveedor`: `invita a`; una Solicitud emitida 1..* Proveedores, un Proveedor 0..* Solicitudes; roles `proveedoresInvitados` y `solicitudesRecibidas`; destinatarios congelados. No crear `InvitacionCotizacion` sin entidad histórica propia adicional aprobada.
* Autoasociación de Solicitudes: `antecedente [0..1]` y `sucesora [0..1]`, una cadena lineal sin ciclos por Insumo/episodio. Primera sin antecedente; todas las posteriores MANUAL.
* `SolicitudCotizacion–RespuestaCotizacion`: una Solicitud admite 0..* Respuestas y cada Respuesta pertenece a 1 Solicitud; roles `respuestas`/`solicitud`.
* Cada RespuestaCotizacion pertenece a 1 Proveedor invitado y 1 Usuario registrador vinculado y habilitado al momento de responder; por Proveedor y Solicitud, como máximo 1 Respuesta definitiva. Precio, disponibilidad, cantidadOfrecida, plazo de entrega y fecha/hora se conservan; la respuesta es definitiva/inmutable desde su confirmación. **COT-17:** después del vencimiento el sistema rechaza el registro: no conserva tardías como nuevas Respuestas.
* Una oferta con `cantidadOfrecida < cantidadSolicitada` se conserva como respuesta no elegible. La compra exige cobertura completa y no combina múltiples Respuestas; se compra la cantidad congelada de la Solicitud.
* SolicitudCotizacion distingue estado `RECEPCION_ABIERTA | PENDIENTE_DECISION | RESUELTA_CON_COMPRA | RESUELTA_SIN_COMPRA`; `motivoCierre` corresponde exclusivamente a cierres sin compra y distingue tres causales (sin respuestas, sin ofertas elegibles y decisión administrativa sin compra), cuyo tercer identificador literal está pendiente de normalización. Se conserva fecha/hora de cierre automático. No crear una clase CierreSolicitud. Cancelar Solicitudes anticipadamente está **fuera del alcance actual**.
* `DecisionCompra–SolicitudCotizacion`: cada decisión pertenece a 1 Solicitud y cada Solicitud admite 0..1 decisión administrativa. Es obligatoria cuando el Administrador resuelve con ofertas elegibles, sea `resultado = COMPRA` o `SIN_COMPRA`, con fecha/hora, Usuario Administrador responsable y justificación obligatoria. Cierres automáticos no crean DecisionCompra.
* `DecisionCompra–PoliticaCompra`: exactamente 1 versión inmutable de política aplicada por Decisión; una versión puede aplicarse a 0..* decisiones. Revalidar/evaluar de forma coherente antes de confirmar si han cambiado la política o condiciones relevantes, sin mezclar versiones entre Detalles de una Decisión. Los pesos definitivos siguen pendientes.
* Composición `DecisionCompra–DetalleDecision`: 1..* Detalles por Decisión; cada Detalle pertenece a 1 Decisión y refiere 1 Respuesta considerada, sin duplicidad (Decisión,Respuesta). Incluye elegibles e inelegibles. Conservar fotografía de criterios **volátiles** (confiabilidad, habitualidad, estado, elegibilidad, motivo de exclusión y puntuación si corresponde), referenciando desde Respuesta sus valores ya inmutables.
* Asociaciones condicionales: `DecisionCompra–Respuesta seleccionada [0..1]` y `DecisionCompra–OrdenCompra [0..1]`, con invariantes: `resultado=COMPRA => exactamente 1 Respuesta seleccionada que tenga DetalleDecision elegible/no excluido + exactamente 1 OrdenCompra`; `resultado=SIN_COMPRA => ninguna Respuesta seleccionada ni OrdenCompra`. Toda OrdenCompra de este circuito pertenece a una sola Decisión de compra confirmada. Nunca emitir automáticamente OrdenCompra. La justificación también es obligatoria si el Administrador se aparta del ranking.
* Irreversibilidad de resolución: cierre sin compra, Orden recibida u Orden cancelada no habilita una segunda DecisionCompra sobre la Solicitud; si persiste faltante, iniciar nueva ronda por UC-45 bajo sus precondiciones.

### **17.2 Inventarios, preparación y costeo**

* ProveedorInsumo vincula exactamente un Proveedor con un Insumo y conserva vigencia/historial; Proveedor e Insumo pueden mantener 0..* asociaciones históricas.
* OrdenCompra puede tener 0..* RecepcionCompra; una RecepcionCompra referencia 0..1 Orden y exactamente un Insumo o un Producto REVENTA (exclusión mutua), con sus movimientos según inventario. **PENDIENTE INV-04:** catálogo/transiciones exactos de OrdenCompra; no fingir cierre.
* Cada Receta de Producto ELABORADO tiene 1..* DetalleReceta; cada Detalle referencia 1 Insumo. Recetas versionadas y Preparacion vinculada a 1 DetallePedido y 1 versión de Receta; un DetallePedido puede tener 0..* Preparaciones. Consumos mediante MovimientoInsumo, no mediante clase ConsumoPreparacion. Cantidades preparadas y recibidas por reasignación no superan lo solicitado.
* Insumo conserva 0..* CostoInsumoHistorico; emitir una Orden no actualiza existencias ni valoración. Solo hechos efectivos de recepción/preparación/ajuste originan los movimientos correspondientes.

### **17.3 Pedido, reparto, entrega y Excedentes**

* Pedido–Cliente (cada Pedido 1 Cliente), Pedido–DetallePedido (1..* Detalles), DetallePedido–Producto (cada Detalle 1 Producto), Pedido–Entrega (0..1 Entrega definitiva), Pedido–AsignacionReparto (0..* historia, máximo 1 asignación vigente). Estado de Pedido: `PENDIENTE|ENTREGADO|CANCELADO`.
* `RutaSugerida` **CLASE CONCEPTUAL APROBADA**: Repartidor, generación, secuencia y asignaciones consideradas, identificables históricamente; la reasignación la vuelve obsoleta. OSRM es infraestructura.
* Excedente–OfertaExcedente y Excedente–MovimientoExcedente: 0..* cada una, movimientos efectivos REASIGNACION o DESCARTE. Solo reasignar/descartar descuenta cantidadDisponible, con costo histórico proporcional; una oferta no disminuye existencias.
* **EXC-05:** cada Pedido conserva `totalOriginal` confirmado, incrementos comerciales trazables y `totalVigente = totalOriginal + suma(incrementos comerciales confirmados)`. No reescribir totalOriginal, precios históricos o ajuste global previo. La aplicación fina de promociones/ajustes y el prepago ONLINE sobre incrementos siguen pendientes.

### **17.4 Finanzas y canal ONLINE**

* Cobro–Cliente (cada Cobro 1 Cliente, Cliente 0..* Cobros); vínculo con Pedido opcional. CuentaCorriente/Caja/LibroDiario derivados de MovimientoCuenta y MovimientoCaja; evitar entidades de resumen artificiales.
* Reembolso–Cobro: historial 0..* intentos/operaciones por Cobro, pero **no se autorizan reembolsos parciales** y como máximo un reembolso completo PROCESADO sobre un mismo importe. Solo PROCESADO ocasiona los efectos definitivos de Caja y CuentaCorriente; PENDIENTE/RECHAZADO no los ocasionan.
* **CONFLICTO HISTÓRICO RESUELTO 21/10:** B4 excluyó solo mecanismos técnicos de idempotencia del Modelo de Dominio, no la garantía funcional de RF-18/RNF-04. Un Reembolso PROCESADO aplica los efectos una sola vez.
* Promocion–Producto (1..* Productos por Promoción; Producto 0..* Promociones), DestinatarioPromocion–Cliente y Promocion, IntentoComunicacion–Destinatario (0..* intentos). Un DetallePedido aplica como máximo 1 Promocion; no acumular descuentos de promociones. Cliente ONLINE separado de Usuario; autenticación ONLINE permanece pendiente.

### **17.5 Criterios transversales y pendientes**

* Aprobados: versionar cuando afecte significado histórico; identificadores de negocio frente a claves técnicas; permisos mediante Rol, no subclases por actor; Modelo de Dominio conceptual antes del DER.
* Pendientes vigentes al 21/10: fórmula exacta de promociones en Entrega parcial; reconciliación de límite de UC-29 con unidades reasignadas; prepago/sobrepago ONLINE; autenticación ONLINE, precisión/redondeo TR-01, RNF TR-05, pesos y casos límite de PoliticaCompra, permisos finos. INV-04, motivoCierre e idempotencia financiera están resueltos.
* **No** agregar por defecto EpisodioFaltante, CierreSolicitud, ConsumoPreparacion, CuentaProveedor, Inventario, Caja, LibroDiario ni entidades de infraestructura.

## **18\. Fuentes de procedencia y autoridad**

* **BASE original:** `B_Dominio_y_Diseño.md` anterior; `A_Requisitos.md`, `C_CasosDeUso_y_Estado.md`, e historial literal de 25.530 líneas.  
* **Origen del costeo REVENTA e Insumos:** historial original L23608–L23842; de Excedentes L13441–L13513; reglas Entrega L24863–L24944.  
* **APROBACIONES DIRECTAS:** `PASO_2_PROPAGACION_Y_CIERRE_44_CU/ACTA_APROBACION_P01_P11.md` (P01–P11) y decisiones DEC-UCxx del archivo de seguimiento `Pendientes.md`.  
* **Requisitos más recientes:** `Ale_Milanesas_Requisitos_Consolidados_Formato_Catedra.docx` y matriz de auditoría `Matriz_Trazabilidad_Requisitos_44_CU.xlsx`; los vínculos derivados del análisis mantienen estatus de ratificación pendiente.  
* **Casos de Uso finales de trabajo:** `Ale_Milanesas_Documento_Maestro_44_Casos_de_Uso.docx` (Alto Nivel, Extendido, Real; códigos UC-01…UC-44). La codificación vieja no debe aparecer como código activo.  
* **NO CONFUNDIR:** decisión de modelado razonable ≠ política aprobada del negocio; trazabilidad propuesta ≠ asociación ratificada; modelo conceptual ≠ arquitectura o DER.

