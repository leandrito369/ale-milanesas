# C — Catálogo y estado de Casos de Uso
**Corte:** 23/10/2026. **Vigentes:** UC-01…UC-50 excepto UC-14 (49 CU); alto/extendido/real: 147 especificaciones. **No existen códigos provisionales en la línea base vigente.**
**Fuente preferente de flujos:** C_ANEXO_49_CU_TRES_NIVELES_ACTUALIZADO_23-10-2026.md (extraído del Word integrado, no del anexo editorial obsoleto).

| Código | Caso de uso | Actor principal declarado | Requisitos asociados |
|---|---|---|---|
| UC-01 | Iniciar sesión | Usuario de la aplicación: personal interno autorizado y cuentas de Proveedor. Los Clientes ONLINE no utilizan este caso de uso. | RF-08: Gestionar Usuarios y Roles |
| UC-02 | Registrar Cliente | Vendedor o Administrador. | RF-10 — Gestionar Clientes. |
| UC-03 | Cargar Pedido | Vendedor. | RF-01 — Gestionar Pedidos.  RF-09 — Gestionar Precios.  RF-12 — Gestionar Categoría Comercial y Precio Diferenciado. |
| UC-04 | Consultar Pedidos Asignados | Repartidor | RF-01 — Gestionar Pedidos. |
| UC-05 | Registrar Entrega | Repartidor. | RF-02 — Registrar Entregas. RF-04 — Gestionar Inventario. RF-06 — Gestionar Cuenta Corriente. RF-13 — Gestionar Excedentes de Producción. RF-19 — Calcular Margen Bruto. |
| UC-06 | Cancelar Pedido | Vendedor o Repartidor. | RF-03 — Cancelar Pedidos. RF-13 — Gestionar Excedentes de Producción. RF-18 — Gestionar Reembolsos Electrónicos. |
| UC-07 | Ofrecer y Reasignar Excedente | Vendedor. | RF-13 — Gestionar Excedentes de Producción. |
| UC-08 | Registrar Ingreso de Stock por Compra | Responsable de Producción. | RF-04 — Gestionar Inventario. RF-11 — Gestionar Proveedores, Cotizaciones y Compras. |
| UC-09 | Consultar Stock | Responsable de Producción | RF-04 |
| UC-10 | Configurar Receta de Producto | Administrador. | RF-05 — Gestionar Recetas, Umbrales y Reposición (alcance Recetas). |
| UC-11 | Registrar Proveedor | Administrador. | RF-11 |
| UC-12 | Evaluar Cotizaciones y Resolver Compra | Administrador. | RF-05 — Gestionar Recetas, Umbrales y Reposición. RF-11 — Gestionar Proveedores, Cotizaciones y Compras. |
| UC-13 | Responder Solicitud de Cotización | Proveedor. | RF-11 — Gestionar Proveedores, Cotizaciones y Compras. |
| UC-15 | Consultar Cuenta Corriente | Vendedor | RF-06 |
| UC-16 | Evaluar y Actualizar Categoría Comercial | Administrador. | RF-06 — Gestionar Cuenta Corriente. RF-12 — Gestionar Categoría Comercial y Precio Diferenciado. |
| UC-17 | Aplicar Ajuste Comercial según Categoría | Sistema. | RF-01 — Gestionar Pedidos. RF-12 — Gestionar Categoría Comercial y Precio Diferenciado. RF-14 — Gestionar Pedidos Online. |
| UC-18 | Crear Usuario | Administrador | RF-08 |
| UC-19 | Gestionar Asignaciones de Roles | Administrador | RF-08 |
| UC-20 | Actualizar Precio Vigente | Administrador | RF-09 |
| UC-21 | Consultar Historial de Precios | Administrador | RF-09 |
| UC-22 | Realizar Pedido Online | Cliente. | RF-12 — Gestionar Categoría Comercial y Precio Diferenciado. RF-14 — Gestionar Pedidos Online. RF-16 — Gestionar Promociones. RF-20 — Registrar Cobros. |
| UC-23 | Registrar Movimiento de Caja | Administrador | RF-15 |
| UC-24 | Consultar Libro Diario | Administrador | RF-15 |
| UC-25 | Crear y Comunicar Promoción | Administrador. | RF-16 — Gestionar Promociones. |
| UC-26 | Generar Ruta Sugerida de Reparto | Repartidor. | RF-17 — Optimizar Ruta de Reparto. |
| UC-27 | Procesar Reembolso Electrónico | Se cancela un Pedido que posee un Cobro electrónico alcanzado por la política de Reembolso. | RF-06 — Gestionar Cuenta Corriente. RF-15 — Gestionar Caja y Libro Diario. RF-18 — Gestionar Reembolsos Electrónicos. |
| UC-28 | Consultar Margen Bruto | Administrador. | RF-19 — Calcular Margen Bruto. |
| UC-29 | Registrar Preparación de Pedido | Responsable de Producción. | RF-04 — Gestionar Inventario. RF-05 — Gestionar Recetas, Umbrales y Reposición. RF-21 — Registrar Preparación de Pedidos. |
| UC-30 | Registrar Cobro |  | RF-06 — Gestionar Cuenta Corriente. RF-15 — Gestionar Caja y Libro Diario. RF-20 — Registrar Cobros. |
| UC-31 | Registrar Producto | Administrador. | RF-07 |
| UC-32 | Configurar Parámetros de Reposición de Insumo | Responsable de Producción. | RF-05 — Gestionar Recetas, Umbrales y Reposición. / RF-11 — Gestionar Proveedores, Cotizaciones y Compras. |
| UC-33 | Modificar Cliente | Vendedor. | RF-10 — Gestionar Clientes. |
| UC-34 | Buscar Cliente | Usuario Interno autorizado. | RF-10 — Gestionar Clientes. |
| UC-35 | Buscar Pedido | Usuario Interno autorizado. | RF-01 — Gestionar Pedidos. |
| UC-36 | Buscar Producto | Usuario Interno autorizado. | RF-07 — Gestionar Catálogo de Productos. |
| UC-37 | Buscar Insumo | Usuario Interno autorizado. | RF-04 — Gestionar Inventario. RF-05 — Gestionar Recetas, Umbrales y Reposición. RF-11 — Gestionar Proveedores, Cotizaciones y Compras. |
| UC-38 | Buscar Proveedor | Usuario Interno autorizado. | RF-11 — Gestionar Proveedores, Cotizaciones y Compras. |
| UC-39 | Cambiar Estado de Cliente | Administrador. \| | RF-10 — Gestionar Clientes. \| |
| UC-40 | Cancelar Orden de Compra | Administrador. | RF-11 — Gestionar Proveedores, Cotizaciones y Compras. |
| UC-41 | Buscar Orden de Compra | Usuario Interno autorizado. | RF-11 — Gestionar Proveedores, Cotizaciones y Compras. |
| UC-42 | Registrar Descarte de Excedente | Responsable de Producción. | RF-13 — Gestionar Excedentes de Producción. |
| UC-43 | Registrar Ajuste de Inventario | Responsable de Producción. | RF-04 — Gestionar Inventario. RF-05 — Gestionar Recetas, Umbrales y Reposición. |
| UC-44 | Asignar y Reasignar Pedidos a Repartidores | Vendedor. | RF-01 — Gestionar Pedidos (requiere ampliar su cobertura explícita a asignaciones). RF-17 — Optimizar Ruta de Reparto (relación de consistencia, no un requisito ejecutado por este CU). |
| UC-45 | Iniciar Ronda Manual de Cotización | Administrador. | RF-05, RF-11. Información asociada: IRQ-07, IRQ-08. |
| UC-46 | Modificar Proveedor | Administrador. | RF-11 |
| UC-47 | Cambiar Estado de Proveedor | Administrador. | RF-11 |
| UC-48 | Modificar Producto | Administrador. | RF-07 |
| UC-49 | Cambiar Estado de Producto | Administrador. | RF-07 |
| UC-50 | Registrar Resultado de Reembolso Electrónico | MercadoPago (sistema externo). | RF-18 |

## Reglas del catálogo
- UC-14 sigue como material histórico; NO dibujar, no reutilizar su código.
- UC-46: Modificar Proveedor; UC-47: Cambiar Estado de Proveedor; UC-48: Modificar Producto; UC-49: Cambiar Estado de Producto; UC-50: Registrar Resultado de Reembolso Electrónico.
- UC-11 es solo alta de Proveedor y UC-31 solo alta de Producto.
- UC-16: actor principal **Administrador** (también puede ser incluido). UC-17: campo «Actor principal: Sistema» en las especificaciones; **no dibujar Sistema como actor externo de sí mismo**.
- UC-22: Cliente ONLINE autenticado mediante código temporal enviado al teléfono registrado, sin crear USUARIO ni Rol CLIENTE, para Clientes ya registrados y activos. Teléfono compartido ambiguo bloquea el acceso ONLINE.
- Buscar Cliente UC-34; Buscar Pedido UC-35; Buscar Producto UC-36; Buscar Insumo UC-37; Buscar Proveedor UC-38; Buscar Orden UC-41. Las relaciones <<include>> / <<extend>> verificadas se mantienen en archivo de matriz adjunto.

## Resumen por CU (fuente: Word integrado)
### UC-01 — Iniciar sesión
- **Actor declarado:** Usuario de la aplicación: personal interno autorizado y cuentas de Proveedor. Los Clientes ONLINE no utilizan este caso de uso.
- **Descripción:** El Usuario presenta sus credenciales. El sistema valida su identidad, el estado de su cuenta y sus Roles, establece la sesión y aplica los permisos correspondientes. La verificación de identidad del Cliente ONLINE se realiza dentro de UC-22, sin crear un Usuario ni un Rol CLIENTE.
- **Precondición:** Usuario de la aplicación con mecanismo de autenticación disponible; para éxito, cuenta habilitada.
- **Postcondición:** Se establece sesión autenticada para una cuenta habilitada con al menos un Rol; el acceso queda limitado a los permisos de sus Roles vigentes. Para Usuario PROVEEDOR con contraseña inicial o de recuperación temporal, se exige cambiarla antes de habilitar el acceso a cotizaciones.

### UC-02 — Registrar Cliente
- **Actor declarado:** Vendedor o Administrador.
- **Descripción:** El actor ingresa los datos del nuevo Cliente. El sistema valida la información, verifica posibles duplicados y, si corresponde, registra al Cliente activo con categoría comercial inicial CUMPLIDOR.
- **Precondición:** El actor está autorizado para registrar Clientes.
- **Postcondición:** El nuevo Cliente queda registrado y activo, disponible para futuras operaciones comerciales.

### UC-03 — Cargar Pedido
- **Actor declarado:** Vendedor.
- **Descripción:** El Vendedor selecciona al Cliente y uno o más Productos, informa cantidades y fecha de reparto. El sistema obtiene y congela el precio vigente de cada Producto, evalúa la categoría comercial del Cliente, aplica el ajuste global correspondiente y registra un Pedido con canalOrigen INTERNO en estado PENDIENTE.
- **Precondición:** El Vendedor está autorizado. El Cliente y los Productos a incorporar se encuentran registrados y activos.
- **Postcondición:** El Pedido queda registrado con sus Detalles, precios históricos, categoría y ajuste comercial aplicados, canalOrigen INTERNO y estado PENDIENTE, disponible para continuar el ciclo operativo.

### UC-04 — Consultar Pedidos Asignados
- **Actor declarado:** Repartidor
- **Descripción:** El actor inicia la operación. El sistema valida las condiciones, ejecuta las acciones definidas en el nivel Extendido y comunica el resultado sin efectos adicionales.
- **Precondición:** Repartidor autenticado y autorizado; hay datos de asignación para consultar (puede no haber pedidos).
- **Postcondición:** Información consultada sin alteración de Pedidos ni asignaciones.

### UC-05 — Registrar Entrega
- **Actor declarado:** Repartidor.
- **Descripción:** El Repartidor localiza un Pedido pendiente e informa las cantidades efectivamente entregadas. El sistema verifica el límite comercial constituido por las cantidades originalmente solicitadas más los incrementos aceptados mediante UC-07. Para Productos ELABORADO, también comprueba que exista cantidad preparada propia o reasignada disponible y determina su costo histórico. Imputa la entrega primero a las unidades originales, aplicando sus condiciones comerciales históricas, y luego a las adicionales por sus importes aceptados. Si queda cantidad elaborada disponible sin entregar, registra un Excedente conservando su costo histórico. Para Productos REVENTA, descuenta stock y congela el costo promedio vigente. La Entrega es definitiva y el Pedido pasa a ENTREGADO.
- **Precondición:** Existe un Pedido PENDIENTE correspondiente a la entrega y el actor está autorizado.
- **Postcondición:** La venta efectiva queda registrada, la Cuenta Corriente y el inventario REVENTA quedan actualizados, los costos históricos de la venta quedan determinados y todo ELABORADO preparado no vendido queda registrado como Excedente.

### UC-06 — Cancelar Pedido
- **Actor declarado:** Vendedor o Repartidor.
- **Descripción:** El actor localiza un Pedido pendiente e informa el motivo de cancelación. El sistema identifica las cantidades ELABORADAS ya disponibles y las registra como Excedentes conservando sus costos históricos. Los consumos de Insumos ya efectuados no se revierten. El Pedido queda CANCELADO. Si posee un Cobro electrónico alcanzado por la política de Reembolso, queda determinada la necesidad de procesarlo mediante UC-27.
- **Precondición:** Existe un Pedido en estado PENDIENTE y el actor está autorizado para cancelarlo.
- **Postcondición:** El Pedido queda CANCELADO, su motivo y trazabilidad quedan conservados, todo ELABORADO disponible queda preservado como Excedente y los consumos históricos de Insumos permanecen inalterados.

### UC-07 — Ofrecer y Reasignar Excedente
- **Actor declarado:** Vendedor.
- **Descripción:** El sistema identifica candidatos para un Excedente disponible. El Vendedor ofrece cantidades a Clientes con Pedidos compatibles y registra sus respuestas. Ante una aceptación, registra unidades adicionales e importe aceptado en el Pedido receptor, sin sustituir su cantidad originalmente solicitada ni requerir otra Preparación, reduce la cantidad disponible del Excedente y conserva el costo histórico transferido.
- **Precondición:** Existe un Excedente de Producto ELABORADO con cantidadDisponible > 0.
- **Postcondición:** Las ofertas quedan trazadas y las unidades adicionales aceptadas quedan incorporadas a los Pedidos receptores sin modificar sus cantidades originales. El Excedente permanece DISPONIBLE mientras conserve cantidad o pasa a AGOTADO cuando cantidadDisponible = 0.

### UC-08 — Registrar Ingreso de Stock por Compra
- **Actor declarado:** Responsable de Producción.
- **Descripción:** El Responsable de Producción registra la recepción de un Insumo o Producto REVENTA, vinculándola a una Orden de Compra cuando exista o registrándola como compra sin Orden de Compra cuando corresponda. El sistema actualiza las existencias y el costo aplicable según el tipo de elemento recibido.
- **Precondición:** El actor está autorizado. El Insumo o Producto REVENTA está registrado.
- **Postcondición:** La recepción queda registrada como INGRESO_COMPRA, las existencias quedan actualizadas y se conserva el costo histórico correspondiente.

### UC-09 — Consultar Stock
- **Actor declarado:** Responsable de Producción
- **Descripción:** El actor inicia la operación. El sistema valida las condiciones, ejecuta las acciones definidas en el nivel Extendido y comunica el resultado sin efectos adicionales.
- **Precondición:** Responsable de Producción autenticado y autorizado.
- **Postcondición:** Existencias consultadas sin generar movimientos.

### UC-10 — Configurar Receta de Producto
- **Actor declarado:** Administrador.
- **Descripción:** El Administrador selecciona un Producto ELABORADO, define una nueva versión de su Receta indicando el rendimiento base y los Insumos necesarios para obtenerlo, sin cambiar los parámetros de reposición, que pertenecen a UC-32. Las versiones anteriores se conservan para trazabilidad.
- **Precondición:** El Administrador está autorizado. Existen Productos ELABORADO e Insumos activos registrados.
- **Postcondición:** La nueva versión de Receta queda registrada con su rendimiento base, Detalles de Insumos y vigencia, sin alterar versiones históricas.

### UC-11 — Registrar Proveedor
- **Actor declarado:** Administrador.
- **Descripción:** El Administrador solicita registrar un Proveedor. El sistema presenta los datos comerciales obligatorios. El Administrador informa identificación, contacto y demás datos comerciales. El sistema valida integridad y duplicados comerciales; la verificación no ejecuta UC-38 como selección obligatoria. El Administrador confirma el alta. El sistema registra el Proveedor y su estado inicial; preserva relación separada respecto de Usuario. El sistema devuelve el identificador y confirma el registro.
- **Precondición:** Administrador autenticado y autorizado. Se dispone de los datos comerciales mínimos del nuevo Proveedor.
- **Postcondición:** Proveedor registrado con identidad única y estado inicial válido; no se crean cuentas de acceso ni invitaciones retroactivas.

### UC-12 — Evaluar Cotizaciones y Resolver Compra
- **Actor declarado:** Administrador.
- **Descripción:** El Administrador consulta una SolicitudCotizacion cuya recepción ha finalizado, con una o más ofertas elegibles evaluadas automáticamente por PoliticaCompra. Revisa criterios, puntajes y condiciones; selecciona el Proveedor y confirma expresamente la emisión de una OrdenCompra, con justificación y trazabilidad; o decide no comprar y cierra la Solicitud con motivo. No se genera una Orden sin aprobación humana. Cuando no se recibió ninguna respuesta o no existe oferta elegible, el subsistema cierra automáticamente la Solicitud con SIN_RESPUESTAS o SIN_OFERTAS_ELEGIBLES; esa situación no inicia UC-12. Los niveles Extendido y Real se desarrollan en sus secciones correspondientes.
- **Precondición:** Administrador autenticado y autorizado. Existe una SolicitudCotizacion con recepción de respuestas finalizada, evaluación disponible y al menos una oferta elegible; la Solicitud aún no tiene resolución comercial ni OrdenCompra emitida. La ronda pudo originarse automática o manualmente.
- **Postcondición:** Compra confirmada: se registran DecisionCompra, DetalleDecision y OrdenCompra PENDIENTE asociados a la Solicitud, al Proveedor seleccionado y al Usuario Administrador, con condiciones de la oferta congeladas. No compra: la Solicitud finaliza sin compra por decisión administrativa justificada, sin Orden. Si cancela o falla, no se registra una resolución comercial parcial.

### UC-13 — Responder Solicitud de Cotización
- **Actor declarado:** Proveedor.
- **Descripción:** El Proveedor accede mediante un formulario web sencillo a una Solicitud dirigida a él, consulta el Insumo, cantidad solicitada, Unidad de Medida y vencimiento, y completa campos estructurados de precio, disponibilidad, cantidad disponible cuando corresponda y tiempo estimado de entrega. Puede corregir los datos antes de confirmar. El sistema valida los campos y, tras la confirmación, registra una única RespuestaCotizacion definitiva con fecha/hora y condición de presentación dentro o fuera del plazo. No se interpretan automáticamente mensajes externos ni texto libre.
- **Precondición:** Existe una SolicitudCotizacion que conserva la invitación histórica al Proveedor y no tiene otra respuesta definitiva de ese Proveedor. Para responder, el Proveedor continúa ACTIVO y el actor utiliza el Usuario habilitado vinculado al Proveedor invitado, con la contraseña temporal ya cambiada. La exclusividad del Rol PROVEEDOR permanece como invariante de RF-08.
- **Postcondición:** Queda registrada una RespuestaCotizacion definitiva asociada al Proveedor y a la Solicitud, o no se registra respuesta si el Proveedor no confirma la operación.

### UC-15 — Consultar Cuenta Corriente
- **Actor declarado:** Vendedor
- **Descripción:** El actor inicia la operación. El sistema valida las condiciones, ejecuta las acciones definidas en el nivel Extendido y comunica el resultado sin efectos adicionales.
- **Precondición:** Vendedor autenticado y autorizado; Cliente identificable.
- **Postcondición:** No se generan Cobros, MovimientosCuenta ni MovimientosCaja.

### UC-16 — Evaluar y Actualizar Categoría Comercial
- **Actor declarado:** Administrador.
- **Descripción:** El Administrador puede solicitar directamente la evaluación de la categoría comercial de un Cliente; el sistema también la ejecuta cuando otro caso de uso requiere conocer la categoría vigente. Consulta la Cuenta Corriente y la política aplicable, determina CUMPLIDOR o EN_MORA a partir del saldo deudor y la antigüedad de la deuda impaga, y actualiza la categoría cuando corresponde.
- **Precondición:** Existe un Cliente y se dispone de su información de Cuenta Corriente. Para una reevaluación completa existe una Política de Categoría Comercial vigente.
- **Postcondición:** La categoría comercial vigente del Cliente refleja su situación de Cuenta Corriente conforme a la política aplicable en el momento de la evaluación.

### UC-17 — Aplicar Ajuste Comercial según Categoría
- **Actor declarado:** Sistema.
- **Descripción:** Durante la creación de un Pedido, el sistema obtiene la categoría comercial vigente mediante UC-16, recupera la Política de Categoría Comercial aplicable y determina si corresponde DESCUENTO, RECARGO o SIN_AJUSTE. El tipo y porcentaje aplicados quedan congelados en el Pedido y se utilizan para calcular su total.
- **Precondición:** Existe un Cliente y un nuevo Pedido en proceso de creación con sus Productos, cantidades y precios unitarios históricos determinados.
- **Postcondición:** El nuevo Pedido conserva la categoría y política comercial utilizadas, el tipo y porcentaje de ajuste aplicados y el total resultante.

### UC-18 — Crear Usuario
- **Actor declarado:** Administrador
- **Descripción:** El actor inicia la operación. El sistema valida las condiciones, ejecuta las acciones definidas en el nivel Extendido y comunica el resultado sin efectos adicionales.
- **Precondición:** Administrador autenticado y autorizado.
- **Postcondición:** Usuario registrado con contraseña inicial protegida y al menos un Rol asignado desde su creación. Si el Rol es PROVEEDOR, la cuenta queda vinculada a un único Proveedor comercial, utiliza credencial inicial temporal y es exclusiva de ese Rol; solo se habilita si ese Proveedor no tiene otra cuenta habilitada.

### UC-19 — Gestionar Asignaciones de Roles
- **Actor declarado:** Administrador
- **Descripción:** El actor inicia la operación. El sistema valida las condiciones, ejecuta las acciones definidas en el nivel Extendido y comunica el resultado sin efectos adicionales.
- **Precondición:** El Administrador está autenticado y autorizado; existe un Usuario registrado o una cuenta en proceso de alta mediante UC-18.
- **Postcondición:** Asociaciones actualizadas conservando al menos un Rol por Usuario; las operaciones que dejen sin Roles se rechazan.

### UC-20 — Actualizar Precio Vigente
- **Actor declarado:** Administrador
- **Descripción:** El actor inicia la operación. El sistema valida las condiciones, ejecuta las acciones definidas en el nivel Extendido y comunica el resultado sin efectos adicionales.
- **Precondición:** Administrador autenticado y autorizado; Producto registrado.
- **Postcondición:** Nuevo Precio con vigencia inmediata o futura; sin cambio retroactivo a Precio/DetallePedido.

### UC-21 — Consultar Historial de Precios
- **Actor declarado:** Administrador
- **Descripción:** El actor inicia la operación. El sistema valida las condiciones, ejecuta las acciones definidas en el nivel Extendido y comunica el resultado sin efectos adicionales.
- **Precondición:** Administrador autenticado y autorizado; Producto registrado.
- **Postcondición:** Datos de Precio consultados sin reescritura, sin alterar Pedido.

### UC-22 — Realizar Pedido Online
- **Actor declarado:** Cliente.
- **Descripción:** El Cliente accede al canal ONLINE, verifica su identidad mediante un código temporal enviado al teléfono registrado, selecciona Productos y cantidades y, si corresponde, una Promoción destinada a ese Cliente. El sistema aplica las condiciones comerciales vigentes mediante UC-17, procesa el pago electrónico y registra el Pedido ONLINE de manera idempotente.
- **Precondición:** Existe un Cliente registrado y ACTIVO cuyo teléfono permite verificar su identidad. El catálogo ONLINE está disponible.
- **Postcondición:** El Pedido queda registrado con canalOrigen ONLINE, estado PENDIENTE, precios, Promociones y ajuste comercial históricamente preservados, y con un Cobro electrónico confirmado y trazable.

### UC-23 — Registrar Movimiento de Caja
- **Actor declarado:** Administrador
- **Descripción:** El actor inicia la operación. El sistema valida las condiciones, ejecuta las acciones definidas en el nivel Extendido y comunica el resultado sin efectos adicionales.
- **Precondición:** Administrador autenticado y autorizado.
- **Postcondición:** MovimientoCaja manual registrado; no crea Cobro/Reembolso ni MovimientoCuenta.

### UC-24 — Consultar Libro Diario
- **Actor declarado:** Administrador
- **Descripción:** El actor inicia la operación. El sistema valida las condiciones, ejecuta las acciones definidas en el nivel Extendido y comunica el resultado sin efectos adicionales.
- **Precondición:** Administrador autenticado y autorizado.
- **Postcondición:** Solo consulta; resultado monetario no representa saldo de Caja ni utilidad.

### UC-25 — Crear y Comunicar Promoción
- **Actor declarado:** Administrador.
- **Descripción:** El Administrador define una Promoción consistente en un descuento porcentual sobre uno o más Productos, establece su vigencia y selecciona los destinatarios. El sistema registra y activa la Promoción, genera un acceso al canal de Pedido Online que permite identificarla y comunica la Promoción mediante el canal configurado.
- **Precondición:** El Administrador está autorizado; existen Productos activos y al menos un Cliente activo elegible como destinatario.
- **Postcondición:** La Promoción queda registrada con sus Productos, descuento, vigencia y destinatarios, y se conserva el resultado de comunicación para cada Cliente.

### UC-26 — Generar Ruta Sugerida de Reparto
- **Actor declarado:** Repartidor.
- **Descripción:** El Repartidor solicita organizar las entregas de una fecha. El sistema obtiene exclusivamente los Pedidos PENDIENTE asignados al Repartidor para la fecha, sus Clientes y ubicaciones, consulta un Servicio de Ruteo y presenta la secuencia sugerida resultante. Si el servicio externo no puede utilizarse, el sistema conserva accesible el listado de Pedidos sin afirmar que se encuentra optimizado.
- **Precondición:** El Repartidor está autorizado y existen Pedidos PENDIENTE correspondientes a la fecha de reparto a planificar.
- **Postcondición:** El Repartidor dispone de una secuencia sugerida de reparto o, ante imposibilidad de generarla, del listado de entregas pendientes con la contingencia informada.

### UC-27 — Procesar Reembolso Electrónico
- **Actor declarado:** Se cancela un Pedido que posee un Cobro electrónico alcanzado por la política de Reembolso.
- **Descripción:** Ante la cancelación de un Pedido con Cobro electrónico reembolsable, el sistema identifica el Cobro y crea o reutiliza su único Reembolso. Solicita el procesamiento a MercadoPago y registra el resultado inmediato, si existe. Puede terminar con estado PENDIENTE sin esperar una notificación posterior; UC-50 registrará un resultado definitivo recibido más tarde.
- **Precondición:** Existe un Cobro electrónico válido asociado al Pedido cancelado y no existe un Reembolso PROCESADO previo que revierta ese mismo importe.
- **Postcondición:** El intento de Reembolso queda trazado. Si fue procesado, el dinero y la Cuenta Corriente reflejan la devolución; si no fue procesado, la Cancelación del Pedido permanece válida y el Reembolso conserva su estado para tratamiento posterior.

### UC-28 — Consultar Margen Bruto
- **Actor declarado:** Administrador.
- **Descripción:** El Administrador selecciona un período. El sistema considera únicamente ventas efectivas derivadas de Pedidos ENTREGADO, reconstruye el ingreso utilizando cantidades entregadas, precios históricos, Promociones y ajustes comerciales congelados, recupera los costos históricos atribuibles de Productos ELABORADO y REVENTA y calcula el margen bruto.
- **Precondición:** Existen Entregas definitivas registradas en el período consultado y se dispone de la información histórica necesaria de ingresos y costos.
- **Postcondición:** El Administrador dispone del margen bruto del período y de la información histórica utilizada para calcularlo.

### UC-29 — Registrar Preparación de Pedido
- **Actor declarado:** Responsable de Producción.
- **Descripción:** El Responsable de Producción selecciona un Pedido pendiente y un Producto elaborado e informa la nueva cantidad preparada propia. El sistema impide superar la cantidad originalmente solicitada con Preparaciones propias, sin restar los incrementos recibidos mediante Reasignaciones de Excedente. Luego escala proporcionalmente la versión de Receta aplicable y, si existen stock y fuentes de costo suficientes, registra atómicamente la Preparación, los consumos de Insumos, los costos históricos y las existencias.
- **Precondición:** Existe un Pedido PENDIENTE con al menos un Detalle de Producto ELABORADO cuya cantidad preparada propia acumulada es menor que la cantidad originalmente solicitada. Existe una versión de Receta aplicable.
- **Postcondición:** La nueva Preparación queda registrada y la cantidad propia acumulada, consumos, costos históricos y existencias de Insumos quedan actualizados consistentemente.

### UC-30 — Registrar Cobro
- **Actor declarado:** 
- **Descripción:** El Cobro puede originarse por una operación manual o por una confirmación electrónica. Se registra Cliente, importe, medio, origen y referencias disponibles. El sistema genera un MovimientoCuenta PAGO, un MovimientoCaja INGRESO, recalcula el saldo del Cliente y origina la reevaluación de su categoría comercial. El Cobro puede estar o no asociado a un Pedido.
- **Precondición:** El Cliente está identificado. Si el registro es manual, el Usuario está autorizado. Si el origen es electrónico, la confirmación externa fue validada.
- **Postcondición:** El Cobro, el PAGO en Cuenta Corriente y el INGRESO en Caja quedan registrados de manera consistente e idempotente.

### UC-31 — Registrar Producto
- **Actor declarado:** Administrador.
- **Descripción:** El Administrador solicita registrar un Producto. El sistema solicita nombre, tipo ELABORADO/REVENTA, unidad y datos exigidos. El Administrador informa los datos. El sistema valida el formato y unicidad del nombre normalizado, incluyendo Productos INACTIVOS. El Administrador confirma el alta. El sistema registra el Producto ACTIVO y su identidad estable. El sistema confirma el alta.
- **Precondición:** Administrador autorizado. Se dispone de datos para el nuevo Producto; la unicidad del nombre se verifica durante la ejecución.
- **Postcondición:** Producto ACTIVO registrado; ningún Producto preexistente fue reinterpretado ni eliminado.

### UC-32 — Configurar Parámetros de Reposición de Insumo
- **Actor declarado:** Responsable de Producción.
- **Descripción:** El Responsable de Producción localiza un Insumo, consulta sus parámetros actuales, informa el umbral mínimo y nivel objetivo de reposición y define si la automatización de compra queda habilitada. El sistema valida la coherencia de la configuración y la registra.
- **Precondición:** El Responsable de Producción se encuentra autenticado y autorizado. El Insumo está registrado.
- **Postcondición:** Los parámetros de reposición del Insumo quedan actualizados para futuras evaluaciones de stock.

### UC-33 — Modificar Cliente
- **Actor declarado:** Vendedor.
- **Descripción:** El Vendedor localiza un Cliente, consulta sus datos actuales, modifica la información permitida y confirma los cambios. El sistema valida la nueva información y actualiza el registro del Cliente.
- **Precondición:** El Usuario se encuentra autenticado y autorizado. El Cliente se encuentra registrado.
- **Postcondición:** Los datos vigentes del Cliente quedan actualizados para futuras operaciones.

### UC-34 — Buscar Cliente
- **Actor declarado:** Usuario Interno autorizado.
- **Descripción:** El actor proporciona uno o más criterios de búsqueda. El sistema recupera los Clientes coincidentes, muestra información suficiente para distinguirlos y permite seleccionar uno.
- **Precondición:** El actor está autenticado y autorizado para acceder a información de Clientes.
- **Postcondición:** Queda identificado y seleccionado un Cliente, o se informa que no existen coincidencias.

### UC-35 — Buscar Pedido
- **Actor declarado:** Usuario Interno autorizado.
- **Descripción:** El actor ingresa criterios de búsqueda y el sistema presenta Pedidos coincidentes con información suficiente para distinguirlos y seleccionar uno.
- **Precondición:** El actor está autenticado y autorizado para acceder a Pedidos.
- **Postcondición:** Queda seleccionado un Pedido o se informa que no existen coincidencias.

### UC-36 — Buscar Producto
- **Actor declarado:** Usuario Interno autorizado.
- **Descripción:** El actor informa criterios de búsqueda. El sistema recupera Productos coincidentes, muestra sus datos identificatorios y permite seleccionar uno.
- **Precondición:** El actor está autorizado para acceder al catálogo.
- **Postcondición:** Producto identificado y seleccionado, o ausencia de coincidencias informada.

### UC-37 — Buscar Insumo
- **Actor declarado:** Usuario Interno autorizado.
- **Descripción:** El actor ingresa uno o más criterios. El sistema recupera los Insumos coincidentes, presenta información identificatoria y permite seleccionar uno.
- **Precondición:** El actor está autenticado y autorizado para acceder a información de Insumos.
- **Postcondición:** Queda seleccionado un Insumo o se informa que no existen coincidencias.

### UC-38 — Buscar Proveedor
- **Actor declarado:** Usuario Interno autorizado.
- **Descripción:** El actor ingresa criterios de búsqueda. El sistema recupera Proveedores coincidentes, muestra información suficiente para distinguirlos y permite seleccionar uno.
- **Precondición:** El actor está autenticado y autorizado para acceder a información de Proveedores.
- **Postcondición:** Proveedor seleccionado o ausencia de coincidencias informada.

### UC-39 — Cambiar Estado de Cliente
- **Actor declarado:** Administrador. |
- **Descripción:** El Administrador localiza al Cliente, consulta su estado actual y solicita cambiarlo. El sistema informa las consecuencias operativas del cambio y, luego de la confirmación, actualiza el estado conservando toda la información histórica. |
- **Precondición:** El Administrador se encuentra autenticado y autorizado. El Cliente está registrado. |
- **Postcondición:** El Cliente queda ACTIVO o INACTIVO según lo solicitado, manteniendo sus relaciones e historial. |

### UC-40 — Cancelar Orden de Compra
- **Actor declarado:** Administrador.
- **Descripción:** El Administrador localiza una Orden de Compra pendiente o parcialmente recibida, revisa sus antecedentes e informa el motivo de cancelación y si la causa es atribuible al Proveedor. El sistema registra la fecha/hora de cancelación, establece la Orden en estado CANCELADA, conserva las recepciones e ingresos de stock previos y determina el tratamiento de la Orden para futuros cálculos de confiabilidad.
- **Precondición:** Existe una OrdenCompra en estado PENDIENTE o PARCIALMENTE_RECIBIDA.
- **Postcondición:** La Orden queda CANCELADA, con motivo, fecha/hora y atribución registrados. Las recepciones y movimientos de inventario previos permanecen inalterados.

### UC-41 — Buscar Orden de Compra
- **Actor declarado:** Usuario Interno autorizado.
- **Descripción:** El actor ingresa criterios de búsqueda. El sistema recupera las Órdenes de Compra coincidentes, muestra información suficiente para distinguirlas y permite seleccionar una.
- **Precondición:** El actor está autenticado y autorizado para acceder a Órdenes de Compra.
- **Postcondición:** Queda seleccionada una Orden de Compra o se informa que no existen coincidencias.

### UC-42 — Registrar Descarte de Excedente
- **Actor declarado:** Responsable de Producción.
- **Descripción:** El Responsable de Producción selecciona un Excedente, informa la cantidad que será descartada y el motivo. El sistema valida la cantidad, registra el movimiento de descarte, disminuye la cantidad disponible y conserva el costo histórico correspondiente.
- **Precondición:** Existe un Excedente DISPONIBLE con cantidad mayor que cero.
- **Postcondición:** La cantidad descartada deja de estar disponible para reasignación y queda registrada históricamente. El Excedente permanece DISPONIBLE o pasa a AGOTADO según su remanente.

### UC-43 — Registrar Ajuste de Inventario
- **Actor declarado:** Responsable de Producción.
- **Descripción:** El Responsable de Producción selecciona un Insumo o Producto REVENTA, indica si la corrección aumenta o disminuye las existencias, informa cantidad y motivo y confirma el ajuste. El sistema registra el movimiento correspondiente y actualiza el stock sin alterar indebidamente el costo histórico.
- **Precondición:** El actor está autorizado y existe el Insumo o Producto REVENTA cuya existencia debe corregirse.
- **Postcondición:** La existencia queda corregida mediante un movimiento AJUSTE_POSITIVO o AJUSTE_NEGATIVO, con motivo y trazabilidad.

### UC-44 — Asignar y Reasignar Pedidos a Repartidores
- **Actor declarado:** Vendedor.
- **Descripción:** El Vendedor solicita asignar o reasignar un Pedido. Identifica el Pedido mediante UC-35 — Buscar Pedido, selecciona al Repartidor correspondiente y confirma la asignación o reasignación. El sistema valida la elegibilidad, conserva historial y motivo de reasignación y actualiza la asignación vigente, invalidando la RutaSugerida anterior cuando corresponda.
- **Precondición:** El Vendedor está autenticado y autorizado. Existe al menos un Pedido registrado, con canalOrigen INTERNO u ONLINE, aún no entregado, y existen Repartidores identificables.
- **Postcondición:** Queda registrada la asignación nueva o el cambio de asignación del Pedido. No se modifica Pedido.estado, su contenido, cantidades, precios, Cuenta Corriente ni Caja. Si la operación fracasa o se cancela, la asignación anterior permanece sin modificación.

### UC-45 — Iniciar Ronda Manual de Cotización
- **Actor declarado:** Administrador.
- **Descripción:** El Administrador parte de una alerta de stock o de la última solicitud de cotización. El sistema presenta el Insumo, su stock y parámetros; calcula la cantidad requerida y muestra todos los Proveedores con asociación vigente, distinguiendo cuáles son invitables porque están ACTIVOS y tienen un Usuario habilitado vinculado. El Administrador selecciona al menos uno de los invitables, revisa el plazo y confirma. El sistema registra y publica la Solicitud en el portal para esos destinatarios; no espera respuestas ni genera OrdenCompra.
- **Precondición:** Administrador autenticado y autorizado; Insumo ACTIVO con stockActual < umbralMinimo, con parámetros de reposición válidos y sin SolicitudCotizacion en curso ni OrdenCompra pendiente de recepción para el mismo episodio. Existen Proveedores invitables. Puede no existir solicitud anterior cuando la primera ronda automática no llegó a emitirse; para rondas posteriores, existe una última solicitud de la cadena que permite la continuación, porque terminó sin compra o porque la Orden originada terminó CANCELADA o RECIBIDA y persiste el faltante.
- **Postcondición:** Existe una nueva SolicitudCotizacion manual emitida, con Insumo, cantidad y vencimiento congelados, Proveedores invitados históricos, Administrador responsable y antecedente 0..1; si falla o se cancela, no se registra una solicitud parcial.

### UC-46 — Modificar Proveedor
- **Actor declarado:** Administrador.
- **Descripción:** El Administrador solicita modificar un Proveedor. El sistema ejecuta UC-38 — Buscar Proveedor; recibe el Proveedor seleccionado. El sistema muestra sus datos y asociaciones vigentes con Insumos. El Administrador modifica datos comerciales y/o asociaciones de suministro. El sistema valida formato, compatibilidad con Insumos registrados y conservación de vigencias anteriores. El Administrador confirma los cambios. El sistema actualiza datos vigentes y preserva la historia de ProveedorInsumo. El sistema informa la modificación realizada.
- **Precondición:** Existe un Proveedor registrado; Administrador autorizado; Insumos involucrados registrados.
- **Postcondición:** Información vigente modificada y asociación comercial actualizada sin borrar datos históricos.

### UC-47 — Cambiar Estado de Proveedor
- **Actor declarado:** Administrador.
- **Descripción:** El Administrador solicita cambiar el estado de un Proveedor. El sistema ejecuta UC-38 y recibe el Proveedor seleccionado. El sistema muestra estado comercial actual y referencias históricas relevantes. El Administrador solicita activar o desactivar. El sistema verifica que la transición sea admisible. El Administrador confirma. El sistema actualiza el estado y conserva el historial; un Proveedor inactivo no resulta invitable para Solicitudes nuevas. El sistema informa el resultado.
- **Precondición:** Existe un Proveedor; Administrador autorizado.
- **Postcondición:** Nuevo estado comercial registrado; invitaciones y decisiones históricas conservadas.

### UC-48 — Modificar Producto
- **Actor declarado:** Administrador.
- **Descripción:** El Administrador solicita modificar un Producto. El sistema ejecuta UC-36 — Buscar Producto y recibe el Producto seleccionado. El sistema presenta sus datos y restricciones por historial. El Administrador edita los datos permitidos. El sistema valida unicidad del nombre y bloquea modificaciones de tipo/unidad cuando exista historia dependiente. El Administrador confirma. El sistema registra solo los cambios válidos preservando identidad e historial. El sistema informa el resultado.
- **Precondición:** Existe un Producto registrado; Administrador autorizado.
- **Postcondición:** Datos permitidos actualizados; tipo/Unidad de Medida se preservan cuando existe historial dependiente.

### UC-49 — Cambiar Estado de Producto
- **Actor declarado:** Administrador.
- **Descripción:** El Administrador solicita cambiar el estado de un Producto. El sistema ejecuta UC-36 y recibe el Producto seleccionado, incluso si está INACTIVO. El sistema muestra estado actual y dependencias históricas. El Administrador indica desactivar o reactivar. El sistema valida transición y datos necesarios para reactivación. El Administrador confirma el cambio. El sistema registra el nuevo estado sin borrar movimientos, Pedidos, Recetas o Precios. El sistema informa el estado resultante.
- **Precondición:** Existe un Producto registrado; Administrador autorizado.
- **Postcondición:** Producto con estado ACTIVO o INACTIVO actualizado; información histórica íntegra.

### UC-50 — Registrar Resultado de Reembolso Electrónico
- **Actor declarado:** MercadoPago (sistema externo).
- **Descripción:** El MercadoPago envía al sistema un resultado posterior identificable respecto de una solicitud de Reembolso. El sistema verifica procedencia y asociación con el Reembolso existente. El sistema comprueba estado actual e historial de resultados; evita registrar efectos monetarios duplicados. El sistema registra el resultado recibido en el mismo Reembolso: PROCESADO o RECHAZADO, con referencia externa e historial del intento. El sistema si PROCESADO, registra una única vez el EGRESO de Caja y el efecto correspondiente en Cuenta Corriente; si RECHAZADO no produce esos efectos. El sistema confirma procesamiento de la comunicación externa sin crear otro Reembolso.
- **Precondición:** Existe un Reembolso lógico con Cobro electrónico asociado que puede recibir un resultado posterior; la notificación es atribuible a MercadoPago.
- **Postcondición:** Resultado externo vinculado al Reembolso original; solo una confirmación PROCESADO genera una única vez los efectos en Caja y Cuenta Corriente.
## Extendido
