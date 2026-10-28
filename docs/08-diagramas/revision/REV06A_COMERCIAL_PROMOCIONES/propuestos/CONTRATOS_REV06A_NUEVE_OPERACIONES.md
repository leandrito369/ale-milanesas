# REV-06A — Contratos de operación, Comercial, Productos, Precios y Promociones

**Corte:** 28/10/2026 · **Estado:** propuesta documental completada y sujeta a cotejo literal del Word Fase 4 de 64 CU. No sustituye fichas maestras ni decisiones nuevas. **Nueve CU, nueve contratos**. Se preservan operaciones públicas exactas del DSS y DS; los detalles de diseño no alteran la firma.

## 1. Contrato de la Operación `buscarProducto` (UC-35 — Buscar Producto)

1. **Nombre:** `buscarProducto(idProducto:Long[0..1], nombre:String[0..1], tipoProducto:String[0..1], activo:Boolean[0..1])`

2. **Responsabilidades:** Localizar Productos por criterios opcionales y devolver coincidencias o una selección contextual, sin modificar el catálogo.

3. **Tipo:** Sistema

4. **Referencias cruzadas:** UC-35; RD-RP007-002; UC-47, UC-48, UC-19, UC-20 y UC-24 (incluyen búsqueda contextual).

5. **Notas:** Solo Administrador y Vendedor disponen de acceso directo o contextual conforme permisos concretos. Producción no obtiene acceso UC-35. La búsqueda contextual no concede permisos generales ni modificación.

6. **Excepciones:** A1: filtros incompatibles o no autorizados: rechazar o solicitar corrección. A2: ninguna coincidencia: resultado vacío, no crear registros.

7. **Salida:** Lista de Productos autorizados con id, nombre, descripción, tipo ELABORADO/REVENTA, unidad de venta y estado; o aviso de búsqueda sin resultado.

8. **Precondiciones:** Actor autenticado y autorizado como Administrador o Vendedor, con alcance directo/contextual permitido.

9. **Postcondiciones:** No se crean ni alteran Producto, precios ni relaciones.

---

## 2. Contrato de la Operación `gestionarProducto` (UC-30 — Gestionar Producto (alta))

1. **Nombre:** `gestionarProducto(nombre:String, descripcion:String[0..1], tipoProducto:String, codigoUnidadVenta:String)`

2. **Responsabilidades:** Registrar un Producto maestro ELABORADO o REVENTA con identidad única y estado inicial activo, sin inventar precio vigente ni Receta.

3. **Tipo:** Sistema

4. **Referencias cruzadas:** UC-30; RD-RP018-001; UC-19 (primer precio); UC-10 (Receta); MR-5 tabla PRODUCTO.

5. **Notas:** El nombre normalizado es único también frente a Productos inactivos; la normalización interna debe ser determinista. Producto sin precio vigente existe, pero no puede comercializarse hasta UC-19. No se crea stock/costo de origen ficticio.

6. **Excepciones:** A1: datos obligatorios o tipo/unidad inválidos: rechazar alta. A2: nombre normalizado ya utilizado por Producto activo o inactivo: mostrar coincidencia sin duplicar.

7. **Salida:** idProducto y confirmación del nuevo Producto activo, o explicación del rechazo.

8. **Precondiciones:** Administrador autenticado y autorizado; código de unidad válido y nombre informado.

9. **Postcondiciones:** Se crea una instancia Producto con nombre, descripción, tipoProducto, codigoUnidadVenta y activo=true. No se crean PrecioProducto, AuditoriaPrecio, Receta ni movimientos de stock a partir de esta operación.

---

## 3. Contrato de la Operación `modificarProducto` (UC-47 — Modificar Producto)

1. **Nombre:** `modificarProducto(idProducto:Long, nuevoNombre:String, descripcion:String[0..1], tipoProductoPropuesto:String, codigoUnidadVentaPropuesto:String)`

2. **Responsabilidades:** Actualizar datos permitidos de Producto existente, revalidando su identidad y dependencias históricas antes de confirmar.

3. **Tipo:** Sistema

4. **Referencias cruzadas:** UC-47 «include» UC-35; F09; MR-5 PRODUCTO y dependencias; RD-RP007-002.

5. **Notas:** Tipo y unidad no se modifican si el Producto tiene historial dependiente. Precios, Pedidos, Recetas y movimientos previos conservan su identidad; la alternativa es crear otro Producto por UC-30.

6. **Excepciones:** A1: Producto no localizado o sin permiso: rechazar. A2: nombre normalizado duplicado, aun si el otro Producto está inactivo: rechazar. A3: cambio de tipo o unidad con historia dependiente: rechazar e indicar UC-30. A4: cambio concurrente de historia entre lectura y confirmación: revalidar y abortar si afecta restricciones.

7. **Salida:** Confirmación de datos modificados permitidos o detalle de restricción.

8. **Precondiciones:** Administrador autenticado; Producto identificado mediante UC-35.

9. **Postcondiciones:** Se modifican únicamente los atributos permitidos de Producto. No se reescriben Pedidos, Recetas, precios ni movimientos históricos.

---

## 4. Contrato de la Operación `cambiarEstadoProducto` (UC-48 — Cambiar Estado de Producto)

1. **Nombre:** `cambiarEstadoProducto(idProducto:Long, nuevoActivo:Boolean)`

2. **Responsabilidades:** Activar o desactivar Producto existente preservando relaciones y Pedidos pendientes sin cancelaciones automáticas.

3. **Tipo:** Sistema

4. **Referencias cruzadas:** UC-48 «include» UC-35; F09; MR-5 PRODUCTO.activo.

5. **Notas:** Desactivar impide nuevas ventas/promociones sin eliminar el Producto, sus dependencias ni los Pedidos PENDIENTE existentes. Reactivar exige verificar condiciones actuales de uso; no confundir estado con habilitación comercial si falta precio.

6. **Excepciones:** A1: Producto inexistente o no autorizado: rechazar. A2: estado igual al solicitado: informar que no hubo cambio. A3: reactivación con datos actuales inválidos: rechazar y señalar corrección mediante UC-47.

7. **Salida:** Nuevo estado activo/inactivo o explicación de rechazo.

8. **Precondiciones:** Administrador autenticado; Producto localizado por UC-35.

9. **Postcondiciones:** Se modifica Producto.activo solo cuando la transición es admisible; no se borran relaciones ni se cancelan de oficio los Pedidos PENDIENTE.

---

## 5. Contrato de la Operación `actualizarPrecioVigente` (UC-19 — Actualizar Precio Vigente)

1. **Nombre:** `actualizarPrecioVigente(idProducto:Long, nuevoPrecioBase:BigDecimal, vigenteDesde:Timestamp, vigenteHasta:Timestamp[0..1])`

2. **Responsabilidades:** Registrar el primer precio o una nueva vigencia del precio base de un Producto sin solapamiento, conservando historia y auditoría.

3. **Tipo:** Sistema

4. **Referencias cruzadas:** UC-19 «include» UC-35; RD-RP018-001; MR-5 PRECIO_PRODUCTO y AUDITORIA_PRECIO.

5. **Notas:** Precio mayor que cero; vigenteHasta, si se informa, posterior a vigenteDesde. A lo sumo un precio válido por Producto e instante. La comprobación es previa; cierre de período y nueva fila/auditoría ocurren atómicamente solo en la rama válida. Se preservan montos de Pedidos confirmados.

6. **Excepciones:** A1: precio no positivo, intervalo vacío o fechas incoherentes: rechazar. A2: intervalos superpuestos o actualización concurrente incompatible: abortar sin cerrar el precio anterior. A3: Producto inexistente/sin permiso: rechazar.

7. **Salida:** idPrecio y vigencia creada, junto con constancia de auditoría, o motivo de rechazo.

8. **Precondiciones:** Administrador autenticado; Producto seleccionado mediante UC-35.

9. **Postcondiciones:** Se crea PrecioProducto para la nueva vigencia y un evento AuditoriaPrecio asociado; si corresponde se ajusta la vigencia previa sin perder su historia; ninguna venta histórica cambia.

---

## 6. Contrato de la Operación `consultarHistorialPrecios` (UC-20 — Consultar Historial de Precios)

1. **Nombre:** `consultarHistorialPrecios(idProducto:Long, fechaDesde:LocalDate[0..1], fechaHasta:LocalDate[0..1])`

2. **Responsabilidades:** Presentar precios históricos y eventos de auditoría correspondientes a un Producto, opcionalmente filtrados por fechas.

3. **Tipo:** Sistema

4. **Referencias cruzadas:** UC-20 «include» UC-35; RD-RP018-001; MR-5 PRECIO_PRODUCTO y AUDITORIA_PRECIO.

5. **Notas:** Consulta de solo lectura; diferencias entre fecha de registro, evento auditado y período de vigencia deben conservarse en la visualización.

6. **Excepciones:** A1: Producto no encontrado/no autorizado: rechazar. A2: fechaDesde posterior a fechaHasta: solicitar corrección. A3: sin datos en período: lista vacía sin crear precio.

7. **Salida:** Secuencia cronológica de precios, vigencias y auditoría de Administrador, o explicación de consulta vacía.

8. **Precondiciones:** Administrador autenticado y Producto localizado mediante UC-35.

9. **Postcondiciones:** No se modifican Producto, PrecioProducto ni AuditoriaPrecio.

---

## 7. Contrato de la Operación `crearYComunicarPromocion` (UC-24 — Crear y Comunicar Promoción)

1. **Nombre:** `crearYComunicarPromocion(descripcion:String, porcentajeDescuento:BigDecimal, vigenteDesde:Timestamp, vigenteHasta:Timestamp, idsProductos:List<Long>, idsClientesDestinatarios:List<Long>)`

2. **Responsabilidades:** Crear una Promoción con Productos alcanzados y Clientes destinatarios, emitir comunicación por el proveedor de mensajería y registrar resultado por destinatario.

3. **Tipo:** Sistema

4. **Referencias cruzadas:** UC-24 «include» UC-35; RD-RP023-001; MR-5 PROMOCION, PROMOCION_PRODUCTO, DESTINATARIO_PROMOCION e INTENTO_COMUNICACION.

5. **Notas:** Exige al menos un destinatario. Pueden coexistir Promociones sobre mismo Producto y destinatario; no se acumulan descuentos sobre mismas unidades. La evaluación de mayor **beneficio económico** entre las elegibles y el congelamiento ocurre en UC-21, no se presupone equivalencia universal con el porcentaje más alto. El enlace de campaña no autentica al Cliente. Los fallos por destinatario se conservan, sin inventar un CU de reenvío.

6. **Excepciones:** A1: descripción, vigencia, porcentaje o colecciones inválidas, Producto/Cliente inactivo o sin destinatarios: rechazar creación. A2: fallo parcial del servicio de mensajería: conservar la Promoción y resultados individuales registrados conforme operación confirmada; no declarar envío exitoso donde falló. A3: indisponibilidad del servicio: conservar incidencia, sin falsificar entregas.

7. **Salida:** idPromocion, productos y destinatarios vinculados, y detalle de resultados por intento; o rechazo de creación.

8. **Precondiciones:** Administrador autenticado; productos seleccionados mediante UC-35 y destinatarios autorizados, al menos uno.

9. **Postcondiciones:** Se crea Promocion y vínculos PromocionProducto/DestinatarioPromocion; cada comunicación ejecutada crea IntentoComunicacion con resultado/rastro. No cambia descuentos de Pedidos previos ni se selecciona una Promoción para un Pedido hasta UC-21.

---

## 8. Contrato de la Operación `consultarPromociones` (UC-59 — Consultar Promociones)

1. **Nombre:** `consultarPromociones(idPromocion:Long[0..1], vigenteDesde:Timestamp[0..1], vigenteHasta:Timestamp[0..1], estado:String[0..1], idProducto:Long[0..1])`

2. **Responsabilidades:** Consultar campañas con filtros, Productos, destinatarios e historial de intentos de comunicación, sin producir nuevos envíos.

3. **Tipo:** Sistema

4. **Referencias cruzadas:** UC-59; F08; RD-RP023-001; MR-5 PROMOCION y tablas asociadas.

5. **Notas:** Estados conocidos: BORRADOR, ACTIVA, PAUSADA, FINALIZADA, CANCELADA. La consulta no habilita activación/reactivación ni modifica destinatarios.

6. **Excepciones:** A1: estado no permitido o intervalo inválido: solicitar corrección. A2: sin resultados: respuesta vacía, sin modificar datos.

7. **Salida:** Listado de Promociones coincidentes con período, estado, Producto, destinatarios e intentos; o condición sin resultados.

8. **Precondiciones:** Administrador autenticado y autorizado.

9. **Postcondiciones:** Sin modificaciones a Promocion, PromocionProducto, DestinatarioPromocion ni IntentoComunicacion.

---

## 9. Contrato de la Operación `desactivarPromocion` (UC-60 — Desactivar Promoción)

1. **Nombre:** `desactivarPromocion(idPromocion:Long)`

2. **Responsabilidades:** Retirar una Promoción para aplicaciones futuras de acuerdo con las transiciones admisibles del ciclo F08, conservando integridad histórica.

3. **Tipo:** Sistema

4. **Referencias cruzadas:** UC-60; RD-RP023-001; F08; MR-5 PROMOCION.estado.

5. **Notas:** La desactivación no elimina la Promoción ni modifica Productos, destinatarios, intentos y descuentos aplicados en Pedidos confirmados. No existe CU para reactivar PAUSADA; no se define aquí un nuevo tránsito de estados ni una tabla CAMBIO_ESTADO_PROMOCION. El literal de destino del estado según etapa de ciclo debe contrastarse literalmente con la ficha F08/Word.

6. **Excepciones:** A1: idPromocion no encontrado o falta autorización: rechazar. A2: campaña terminal o transición no permitida: informar sin duplicar cambio. A3: revalidación concurrente revela otro estado: rechazar o revalidar transición antes de guardar.

7. **Salida:** Confirmación de retiro para usos futuros y estado vigente, o explicación de no modificación.

8. **Precondiciones:** Administrador autenticado y Promoción localizada, con transición habilitada según F08.

9. **Postcondiciones:** Se modifica solo el estado permitido de Promocion para impedir nuevos usos; no se alteran descuentos congelados, referencias ni intentos y no se habilita reactivación.

---

## Glosario y límite de revisión

- **Beneficio económico:** criterio aprobado RD-RP023-001 para elegir, en UC-21, entre promociones elegibles. No se infiere una fórmula nueva ni se presupone que `max(porcentajeDescuento)` siempre lo maximice.
- **Estado de promoción:** BORRADOR, ACTIVA, PAUSADA, FINALIZADA y CANCELADA; no se añade reactivación. La transición exacta de UC-60 se verificará contra F08/Word antes de considerarla certificada.
- **Producto sin precio:** registro maestro válido pero no comercializable hasta primer precio UC-19 (RD-RP018-001).
- **Versionado de precios:** preservar intervalos y auditorías sin alterar Pedidos confirmados.
- **Visibilidad UML:** separadas las instancias PrecioProducto/AuditoriaPrecio, Promocion/PromocionProducto/DestinatarioPromocion/IntentoComunicacion; requiere posterior cotejo con diagrama de clases y Draw.io visual.
