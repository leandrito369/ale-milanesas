# Ale Milanesas — Registro de decisiones del Grupo A

**Fecha de aprobación funcional:** 24/10/2026  
**Ámbito:** Observaciones A1–A26, numeración, cambios funcionales y correcciones vinculadas.  
**Fuentes de contraste:** `A_Requisitos_ACTUALIZADO_23-10-2026.md`, `B_Dominio_y_Diseño_ACTUALIZADO_23-10-2026.md`, `C_CasosDeUso_y_Estado_ACTUALIZADO_23-10-2026.md`, `C_ANEXO_49_CU_TRES_NIVELES_ACTUALIZADO_23-10-2026.md`, `D_Decisiones_y_Pendientes_ACTUALIZADO_23-10-2026.md`, `Matriz_Relaciones_UML_23-10-2026.md` y esquema relacional maestro del 23/10.  
**Estado:** decisiones funcionales aprobadas por el usuario; cambios aún **no volcados** a las fichas maestras ni al esquema relacional.

## 1. Numeración definitiva (DEC-A-01)

Se adopta **UC-01…UC-49 consecutivos**. Los antiguos UC-01…UC-13 conservan número. Los antiguos UC-15…UC-50 pasan a UC-14…UC-49; la eliminación del antiguo UC-14 no equivale a borrar otro caso. Esta regla obliga a renumerar **todas** las referencias entre CU, matrices, títulos, diagramas y documentos vinculados; las tablas relacionales no cambian por renumerar CUs.

| Código anterior | Nuevo código | Caso |
|---|---|---|
| UC-15 | UC-14 | Consultar Cuenta Corriente |
| UC-16 | UC-15 | Evaluar y Actualizar Categoría Comercial |
| UC-17 | UC-16 | Aplicar Ajuste Comercial según Categoría |
| UC-18 | UC-17 | Crear Usuario |
| UC-19 | UC-18 | Gestionar Asignaciones de Roles |
| UC-22 | UC-21 | Realizar Pedido Online |
| UC-27 | UC-26 | Procesar Reembolso Electrónico |
| UC-28 | UC-27 | Consultar Margen Bruto |
| UC-30 | UC-29 | Registrar Cobro |
| UC-33 | UC-32 | Modificar Cliente |
| UC-34 | UC-33 | Buscar Cliente |
| UC-35 | UC-34 | Buscar Pedido |
| UC-36 | UC-35 | Buscar Producto |
| UC-37 | UC-36 | Buscar Insumo |
| UC-38 | UC-37 | Buscar Proveedor |
| UC-39 | UC-38 | Cambiar Estado de Cliente |
| UC-40 | UC-39 | Cancelar Orden de Compra |
| UC-41 | UC-40 | Buscar Orden de Compra |
| UC-42 | UC-41 | Registrar Descarte de Excedente |
| UC-44 | UC-43 | Asignar y Reasignar Pedidos a Repartidores |
| UC-45 | UC-44 | Iniciar Ronda Manual de Cotización |
| UC-46 | UC-45 | Modificar Proveedor |
| UC-47 | UC-46 | Cambiar Estado de Proveedor |
| UC-48 | UC-47 | Modificar Producto |
| UC-49 | UC-48 | Cambiar Estado de Producto |
| UC-50 | UC-49 | Registrar Resultado de Reembolso Electrónico |

**Aviso:** En todo el resto de este registro A1...A26 conserva la **numeración de la observación** y los códigos de CU entre paréntesis se indican en el sistema **anterior → nuevo**.

## 2. Aprobaciones funcionales (Grupo A)

| Ítem | Decisión aprobada y límites de implementación |
|---|---|
| A1 | UC-16→15, UC-05 y UC-27→26: reevaluación de Categoría al existir un movimiento confirmado de Cuenta Corriente, no antes. Reconocer invocadores UC-17→16 y UC-30→29. Respetar UC-05 «include» UC-16 antiguo. No inventar «include» universal desde UC-27 porque la confirmación de Reembolso es condicional. |
| A2 | UC-28→27: ingresos por venta efectiva = tramo original efectivamente entregado valorado con condiciones congeladas + tramo adicional efectivamente entregado valorado según importe aceptado UC-07. Conciliar con cargo real de UC-05; excluir dinero cobrado y movimientos de Caja como sustitutos del ingreso devengado. |
| A3 | UC-02, UC-33→32 y UC-39→38: no duplicar Cliente inactivo; derivar reactivación al Administrador mediante UC-39; Vendedor no cambia estado. |
| A4 | UC-33→32, UC-34→33 y UC-22→21: buscar Cliente explícitamente, unificar actor Vendedor, verificar duplicidad normalizada de nombre + teléfono, no duplicar propio registro; cambio de teléfono invalida desafíos OTP pendientes del número anterior. Sesiones ONLINE activas NO se revocan automáticamente sin otra aprobación. |
| A5 | UC-01: usuarios internos y usuarios de Proveedor; excluir Clientes ONLINE de ese caso. Unificar objetivos/requisitos e indicar OBJE-03 / RF-08; retirar OBJ-01 como objetivo específico del CU. |
| A6 | UC-27→26: Sistema como iniciador automático textual, Administrador como iniciador secundario solo de reintentos. No dibujar Sistema como actor externo de sí mismo. UC-30→29: Usuario interno para Cobro manual; MercadoPago como proveedor externo de confirmaciones electrónicas. |
| A7 | UC-50→49: al confirmar tardíamente PROCESADO, aplicar efectos monetarios una sola vez, reevaluar categoría con UC-16→15 y comunicar resultado al Cliente por el canal validado. Compartir reglas con UC-27→26, sin crear «include» UC-27↔UC-50. |
| A8 | UC-27→26: incorporar **modo de inicio secundario** de reintento manual exclusivo Administrador. Solo para REEMBOLSO RECHAZADO, siempre que no exista operación externa en curso ni estado PROCESADO. Mantener idReembolso, registrar nuevo INTENTO_REEMBOLSO con numeroIntento distinto y clave idempotente propia, validar concurrencia, y volver a la solicitud externa. No crear Reembolso lógico nuevo. Registrar responsable y fecha del reintento sujeto a la brecha física señalada en §3. |
| A9 | UC-06 y UC-27→26: relación aprobada «extend» bajo condición Cobro electrónico reembolsable. Cobros manuales/anticipos no generan devolución de Caja automática al cancelar; permanecerán como crédito/saldo a favor conforme a movimientos ya registrados, sin crear asientos ficticios. |
| A10 | UC-04: mostrar solo Pedidos PENDIENTE asignados actualmente al Repartidor; identificar Cliente, fecha, dirección, Productos, cantidades originales y adiciones aceptadas; quitar nota obsoleta de Postcondición. |
| A11 | UC-44→43: fusionar pasos de búsqueda duplicados; unificar Pedido PENDIENTE asignable/reasignable, separar RF ejecutado de RF solo relacionado, mantener elegibilidad adicional del Repartidor y offline `[A CONFIRMAR]`; concurrencia e idempotencia obligatorias. |
| A12 | UC-22→21 Real: OTP completo y validado antes de selección comercial y pago; restaurar elección de Productos/cantidades, condiciones comerciales, confirmación y pago. Mantener fecha de reparto `[A CONFIRMAR]`. |
| A13 | UC-22→21 / UC-02 / UC-06: canal ONLINE solo para Cliente registrado y ACTIVO. No introducir autorregistro ni autocancelación por Cliente. UC-06 sí contempla cancelación de Pedido ONLINE por roles internos autorizados. |
| A14 | UC-17→16: subtotal INTERNO base; ONLINE subtotal después de Promoción válida; aplicar luego ajuste comercial global, conservando el historial. |
| A15 | UC-13 / UC-29→28: no aceptar respuestas definitivas nuevas sobre una Solicitud ya cerrada; rechazo informado. «Compra automática» se reemplaza por detección de faltante / inicio de ronda de cotización cuando corresponda; la Orden exige UC-12. |
| A16 | UC-08: completar transiciones de Orden PENDIENTE→PARCIALMENTE_RECIBIDA→RECIBIDA por acumulados; rechazar recepción excedente o contra Orden CANCELADA/RECIBIDA. Estos **estados ya existen** en el modelo de 59 tablas. Compras de REVENTA sin Orden de Compra mientras no se apruebe ampliar ese modelo. No convertir la búsqueda opcional de OC en include universal. |
| A17 | UC-40→39: exigir Administrador autenticado y autorizado, y hacer explícito UC-41→40 Buscar Orden de Compra en Extendido y Real. Mantener su include aprobado. |
| A18 | UC-18→17 / UC-19→18: la asignación del primer Rol durante alta continúa mediante include, en contexto de Usuario aún no confirmado; alta y Roles atómicos. Verificar Proveedor ACTIVO, identidad comercial, cuenta habilitada única y exclusividad Rol PROVEEDOR. No incluir búsqueda Proveedor obligatoria para todas las altas. |
| A19 | UC-25→24: al menos un Cliente destinatario activo y elegible; Producto activo y Promoción válida. Distinguir elegibilidad de envío por canal existente y derecho de uso de Promoción; cualquier reintento debe respetar intentos históricos e idempotencia. No asumir email: canal definido actualmente WHATSAPP en INTENTO_COMUNICACION. |
| A20 | UC-03: Cliente elegido INACTIVO no confirma nuevo Pedido. No inventar política numérica de fecha. Operación offline únicamente en alcance RNF-03/04 validado, con idempotencia. |
| A21 | UC-05: verificar asignación vigente del Repartidor en instante de confirmación, cubrir reasignación concurrente y renumerar paso «24a». Real debe preservar verificaciones, saldos a favor y operaciones atómicas de Extendido. |
| A22 | UC-30→29: Cobro opcionalmente sin Pedido; al vincular a Pedido, debe pertenecer al mismo Cliente y ser PENDIENTE o ENTREGADO. No asociar Cobro nuevo como cobro vigente de un Pedido CANCELADO. Mantener cobranza de deuda previa o anticipos generales. |
| A23 | UC-07 / UC-42→41: seleccionar Excedente disponible del Producto compatible, con saldo suficiente no reasignado/no descartado y comprobación concurrente. No está aprobado por esta decisión crear nuevo «Buscar Excedente». |
| A24 | UC-39→38, UC-47→46, UC-49→48: bajas lógicas y preservación histórica, no borrados. Cliente inactivo: sin nuevos Pedidos/Promociones/ofertas; deuda y Cobros subsisten. Proveedor inactivo: no nuevas invitaciones/respuestas, historial permanece; definir tratamiento de Órdenes abiertas/cuenta antes de implementación. Producto inactivo: no nuevos Pedidos; Pedidos pendientes existentes **no se cancelan automáticamente** y deben quedar sujetos a revisión/resolución manual, sin crear por defecto un estado PEDIDO inexistente. |
| A25 | Se aprueba mínimo privilegio RBAC. Elaborar matriz Rol×CU antes de conceder nuevas operaciones al Administrador; no agregar actores por inferencia ni extender permisos de consultas a roles no especificados. |
| A26 | UC-02 y UC-26→25: coincidencias parciales de identidad generan advertencia, no bloqueo automático; duplicados exactos por criterios aprobados sí se impiden. UC-26 filtra Pedidos PENDIENTE asignados al Repartidor y gestiona secuencia anterior obsoleta según el flujo Extendido. |

## 3. Precisiones de integridad y decisiones aún no materializadas

1. **Responsable del reintento de Reembolso:** `INTENTO_REEMBOLSO` tiene `(idReembolso, numeroIntento)`, fechaHoraSolicitud, claveIdempotencia y referencia externa, pero **no** `idUsuarioResponsable`. La exigencia aprobada de trazabilidad de quién solicita el reintento requiere ratificar una columna FK nullable a USUARIO (o alternativa de auditoría formal equivalente); ello afectaría el inventario 444 columnas / 120 FK. Hasta ratificación, no declarar que este dato queda físicamente almacenado.
2. **Concurrencia de reintentos:** transición RECHAZADO→PENDIENTE y creación de intento deben protegerse en transacción; una notificación tardía o una operación que ya fue PROCESADA impiden duplicaciones. Cada nuevo intento usa clave propia; un reenvío de ese intento reutiliza su clave.
3. **No partida doble formal:** MOVIMIENTO_CUENTA y MOVIMIENTO_CAJA describen efectos financieros coordinados, no un Libro Mayor general de contabilidad por partida doble. No agregar cuentas contables ni nuevos asientos por esta decisión.
4. **Identificación de Clientes:** `CLIENTE` no tiene DNI ni CUIT en el esquema vigente; no exigir su unicidad como si existieran. `PROVEEDOR` sí utiliza CUIT. Exactitud de coincidencia de Cliente: política nombre/teléfono tal como quede aprobada.
5. **Estado de Pedido:** `PEDIDO.estado` conserva `PENDIENTE`, `ENTREGADO`, `CANCELADO`. La revisión manual por Producto INACTIVO no añade automáticamente `CONGELADO` o `SUSPENDIDO`; falta ratificar el mecanismo de bloqueo operacional.
6. **Permisos:** la aprobación A25 no establece celdas concretas de la matriz Rol×CU. Las fichas conservarán actores actuales hasta que se valide esa matriz.
7. **Pendientes explícitos:** UC-22 fecha de reparto ONLINE, UC-44 offline/elegibilidad y UC-28 modalidad de consulta por venta individual permanecen `[A CONFIRMAR]` según corresponda.
8. **UML:** conservar 27 «include» y 2 «extend» aprobados, reasignando sus identificadores según §1. No agregar nuevas flechas solo porque haya una invocación condicional o colaboración técnica.

## 4. Política de transcripción al documento maestro

- Crear un **archivo derivado nuevo**; no sobrescribir fuentes del 23/10 ni el Google Doc original.
- Cada CU afectado contendrá sus **tres niveles completos**; Alto: 2 columnas; Extendido: 3 columnas; Real: 4 columnas; conservar colores, jerarquía y estructura de `EJEMPLOS DE LOS CU EN SUS TRES NIVELES.docx`.
- Cambios de pasos: actualizar referencia cruzada y alternativas/ excepciones, no solo postcondiciones.
- Renumerar todos los identificadores simultáneamente de acuerdo a §1 y verificar que no permanezcan UC-50 ni código reservado para caso eliminado.
- No insertar `[A CONFIRMAR]` donde no existía decisión pendiente; sí preservar los aprobados y señalarlos fuera de los pasos definitivos cuando sea posible.
