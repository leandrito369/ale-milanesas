# Ale Milanesas — MR-1: Auditoría transversal de impacto relacional

**Corte:** 25/10/2026. **Base física:** esquema maestro, diccionario de 444 columnas y esqueleto DDL no ejecutado del 23/10/2026. **Base funcional:** catálogo Fase 4 (UC-01 a UC-64), RD-01, RP-01 y PRA-01 v1.1.

**Naturaleza:** análisis de diferencias y propuestas para MR-2. No es una migración, DDL final, certificación 3FN ni evidencia de ejecución de PostgreSQL. Las decisiones pendientes no quedan aprobadas por estar registradas en esta matriz.

## 1. Alcance y método

- Contraste automatizado: 59 sentencias `CREATE TABLE`, 120 definiciones `FOREIGN KEY` y 444 entradas del diccionario; 59 tablas únicas y 64 CU enumerados en el Word consolidado.
- Lectura dirigida de atributos, nulabilidad, PK, FK, `CHECK`, UNIQUE/índices documentados y notas de integridad del esquema maestro.
- Cruce semántico de las 64 fichas con RD (A/B/C) y PRA-01. El mapeo tabla–CU es de impacto funcional estimado y **no prueba** que se haya auditado cada SELECT, UPDATE o transición implementada.
- Clasificación de cada hallazgo: cambio físico necesario; control transaccional/trigger; consulta/índice; decisión abierta; verificación posterior.

## 2. Balance

| Indicador | Resultado |
|---|---:|
| Tablas verificadas | 59 |
| Columnas verificadas | 444 |
| FK verificadas en DDL | 120 |
| CU con mapeo de tablas | 64 |
| Hallazgos MR-1 | 53 |
| Críticos | 1 |
| Altos | 27 |
| Medios | 25 |

**Interpretación:** los 53 hallazgos no equivalen a 53 cambios de esquema. Muchos consisten en implementar invariantes sobre las mismas tablas, validar índices o cerrar una política funcional.

## 3. Resultados arquitectónicos

**Bloqueo físico aprobado:** `MOVIMIENTO_INSUMO.tipoMovimiento` tiene un `CHECK` que no admite `SALDO_INICIAL`. La apertura UC-42/UC-50 no se podrá ejecutar como se especificó hasta actualizar esa restricción y validar el vínculo con `COSTO_INSUMO_HISTORICO`. El alta UC-50 registra el maestro con `stockActual=0` y los parámetros obligatorios; no inventa ingreso por compra.

**Brecha de unicidad:** el maestro de `INSUMO` no declara unicidad de nombre, pese a la exigencia funcional en UC-50. Se necesita política normalizadora y protección concurrente, sin incorporar automáticamente una columna nueva.

**Finanzas:** hay claves para limitar duplicaciones, pero `UNIQUE` por sí solo no exige que exista cada efecto financiero. Los cargos por Entrega, los PAGOs por Cobro y la devolución PROCESADO deben aplicarse de forma atómica y trazable; esto no equivale a una contabilidad completa por partida doble.

**Usuarios:** las cuentas, Roles y sesiones existen, pero el último Administrador, la exclusividad de cuenta PROVEEDOR habilitada y la revocación deben validarse mediante transacciones y reglas cruzadas. La identificación del responsable del reintento en `INTENTO_REEMBOLSO` queda expresamente **a cargo del usuario**.

**PRA-01:** `EPISODIO_FALTANTE` y `SOLICITUD_COTIZACION` soportan el proceso, pero los cierres, la primera ronda automática y la recepción de respuestas deben hacerse consistentes con bloqueos y comprobación de vencimientos; `ORDEN_COMPRA` ya contiene los cuatro estados aprobados.

**Sin agregar tablas por reflejo:** UC-53 a UC-64 disponen de estructuras físicas reutilizables; no se propone aumentar a priori las 59 tablas. Historial de estado de Producto, auditoría de restablecimiento y corrección financiera podrían alterar esa conclusión solo tras aprobación específica.

## 4. Matriz completa de hallazgos MR-1

Cada fila incluye la **situación verificada**, la diferencia funcional y la acción propuesta; la columna final distingue aprobación y pendientes.

| ID | Prioridad | Tabla(s) | Brecha / riesgo | Acción sugerida | Tipo | CU | Estado |
|---|---|---|---|---|---|---|---|
| MR1-01 | Crítica | MOVIMIENTO_INSUMO | Rechaza SALDO_INICIAL aprobado para UC-42. | Ampliar CHECK con SALDO_INICIAL y definir compatibilidad origen / claves nulas / cantidad / costo. | DDL obligatorio | UC-42,UC-50,UC-64 | Regla aprobada; DDL pendiente |
| MR1-02 | Alta | COSTO_INSUMO_HISTORICO;MOVIMIENTO_INSUMO | La apertura física exige crear/fijar costo válido sin inventar recepción. No hay enum de fuenteCosto en DDL. | Diseñar registro inicial de costo, origen trazable y secuencia transaccional valoración→movimiento→stock. | Control + DDL por evaluar | UC-42,UC-50 | Regla aprobada; detalle físico por validar |
| MR1-03 | Alta | INSUMO | UC-50 exige nombre único; alta concurrente puede duplicarlo. | Ratificar normalización y agregar UNIQUE/índice de expresión correspondiente; no agregar columna sin aprobación. | Índice/normalización por aprobar | UC-50,UC-51 | Regla de CU aprobada; mecanismo por ratificar |
| MR1-04 | Alta | INSUMO | Una edición de Unidad de Medida con historia afectaría cantidades antiguas. | Bloquear cambio mediante trigger/servicio si existen movimientos, recetas u otras dependencias históricas. | Trigger/regla aplicación | UC-51 | Aprobado como conducta |
| MR1-05 | Media | INSUMO | Inactivar Insumo no debe borrar stock ni desencadenar reposición o permitir nueva operación comercial. | Validar estado en consumo nuevo, recepción y apertura del episodio; conservar movimientos históricos. | Trigger/regla aplicación | UC-31,UC-50,UC-52;PRA-01 | Aprobado |
| MR1-06 | Alta | MOVIMIENTO_INSUMO;INSUMO | Movimientos automáticos también deben tener responsable válido; CHECK de una fila no asegura stockResultante igual al acumulado. | Definir identidad de ejecución atribuible y escritura serializada; trigger de conciliación, lock por Insumo y prueba de concurrencia. | Trigger/transacción | UC-08,UC-28,UC-42,UC-64;PRA-01 | Diseño técnico por concretar |
| MR1-07 | Alta | PREPARACION;MOVIMIENTO_INSUMO;DETALLE_PEDIDO | Cantidad preparada acumulada y receta del mismo Producto no quedan garantizadas por FK simples. | Constraint trigger para sumatoria por Detalle, receta aplicable y consumos exactamente una vez. | Trigger/transacción | UC-10,UC-28 | Regla aprobada; implementar |
| MR1-08 | Media | VERSION_RECETA;DETALLE_VERSION_RECETA | DDL deja EXCLUDE de solapamiento de vigencias sin implementar. | Implementar exclusion temporal y bloqueo de cambios retrospectivos de versiones usadas. | DDL/trigger | UC-10,UC-28 | Ya diseñado; pendiente ejecución |
| MR1-09 | Media | PRODUCTO | La normalización automática aprobada podría depender de la aplicación y perder coherencia. | Declarar columna generada o trigger determinista, con una sola regla de normalización. | DDL/trigger | UC-30,UC-47 | Decisión previa; concretar técnica |
| MR1-10 | Media | PRODUCTO | La conservación de operaciones históricas no documenta cada transición ACTIVO/INACTIVO. | Evaluar si se requiere auditoría propia; no agregar tabla sin ratificación. | Decisión eventual | UC-48 | Pendiente AT-16 |
| MR1-11 | Media | MOVIMIENTO_STOCK_REVENTA;VALORACION_EXTRAORDINARIA_REVENTA | No corresponde extrapolar SALDO_INICIAL de Insumos a REVENTA sin aprobación. | Conservar costeo promedio móvil; pruebas de compras, ajustes y apertura extraordinaria. | Pruebas/trigger | UC-08,UC-42,UC-64 | Sin ampliación aprobada |
| MR1-12 | Alta | PEDIDO;DETALLE_PEDIDO;IMPUTACION_ENTREGA_ADICIONAL | Margen de UC-27 y total de Entrega deben incluir adicionales aceptados sin reaplicar promoción ni ajuste global. | Derivar totalVigente de original + incrementos efectivamente aplicables; conciliar CARGO_POR_VENTA y costo histórico. No materializar nueva columna por defecto. | Consulta/conciliación | UC-05,UC-07,UC-16,UC-27 | Principio A2 aprobado |
| MR1-13 | Alta | PEDIDO;SESION_CLIENTE_ONLINE;DESAFIO_AUTENTICACION_CLIENTE | FK encadenadas no garantizan que sesión se verificó para el mismo CLIENTE del pedido ni vigencia OTP. | Validar titularidad, autenticación OTP, estado activo y sesiones válidas en transacción de creación. | Trigger/regla aplicación | UC-21,UC-32 | A12 aprobado |
| MR1-14 | Alta | PEDIDO | Offline puede sincronizar con Cliente inactivo, política/precio antiguo y repetición de solicitud. | Definir matriz y revalidación al sincronizar; clave de operación obligatoria para transacciones offline; política final abierta. | Decisión + trigger | UC-03,UC-21 | Offline parcialmente pendiente |
| MR1-15 | Alta | ASIGNACION_REPARTO;ENTREGA | Un Repartidor puede intentar entregar luego de reasignación concurrente. | SELECT ... FOR UPDATE y validar asignación activa al confirmar entrega; actualización única de estado Pedido. | Transacción concurrente | UC-04,UC-05,UC-25,UC-43 | A10/A21 aprobado |
| MR1-16 | Alta | EXCEDENTE;OFERTA_EXCEDENTE;MOVIMIENTO_EXCEDENTE;IMPUTACION_ENTREGA_ADICIONAL | No hay garantía declarativa de conservación de unidades a través de ofertas, descarte y reasignaciones encadenadas. | Triggers diferidos + bloqueo por Excedente para suma de unidades e imputación a Producto/Pedido receptor. | Trigger/transacción | UC-05,UC-07,UC-41,UC-61 | AT-07 ratificada; trigger pendiente |
| MR1-17 | Media | EXCEDENTE | Búsqueda debe filtrar remanentes sin inventar atributo de estado. | Índice/filtros por cantidadDisponible, Producto y compatibilidad; revalidar en operación. | Índice/consulta | UC-07,UC-41,UC-61 | A23 aprobada |
| MR1-18 | Media | PEDIDO;PRODUCTO | Baja lógica de Producto no puede generar estado CONGELADO ni cancelación silenciosa de Pedido. | Regla de bloqueo operativo/revisión manual sin nuevo estado; documentar qué ocurre si preparación se había iniciado. | Decisión de proceso | UC-03,UC-05,UC-48 | A24 parcial; detalle operativo abierto |
| MR1-19 | Media | PRECIO_PRODUCTO;AUDITORIA_PRECIO | El solapamiento de precios se declara como EXCLUDE pendiente en DDL. | Implementar GiST EXCLUDE e inmutabilidad de precios ya efectivos/usados; prueba primer precio. | DDL/trigger | UC-03,UC-19,UC-20 | B8 aprobado |
| MR1-20 | Media | CLIENTE | La unicidad comercial nombre+teléfono normalizados no figura en DDL como índice o función. | Definir normalización determinista y control de unicidad; coincidencia parcial solo advertencia. | Índice/servicio | UC-02,UC-21,UC-32,UC-33 | A3/A4/A26 aprobado |
| MR1-21 | Alta | DESAFIO_AUTENTICACION_CLIENTE;SESION_CLIENTE_ONLINE | Cambiar teléfono no invalida automáticamente desafíos pendientes del número antiguo. | En actualización de teléfono invalidar desafíos no usados; sesiones vivas no se revocan salvo decisión adicional. | Trigger/regla aplicación | UC-21,UC-32 | A4 aprobado |
| MR1-22 | Alta | USUARIO;SESION_USUARIO | UC-53/54/55 exigen actualizaciones atómicas y protección de sesiones, no expresadas por CHECK. | Diseñar cambio/restablecimiento de credencial con sesión restringida, hash nuevo, revocaciones y auditoría pertinente. | Transacción/seguridad | UC-01,UC-53,UC-54,UC-55 | B1 aprobado |
| MR1-23 | Alta | USUARIO;USUARIO_ROL;ROL | Puede quedar Usuario HABILITADO sin rol o mezclarse PROVEEDOR con roles internos. | Trigger diferido de cardinalidad 1..*, exclusividad y alta Usuario/Rol atómica. | Trigger/transacción | UC-17,UC-18,UC-55 | A18 y B1 aprobados |
| MR1-24 | Alta | USUARIO_ROL;USUARIO | Deshabilitar o revocar último administrador puede bloquear totalmente la gestión. | Constraint trigger diferido + bloqueo transaccional que preserve al menos uno habilitado con rol ADMINISTRADOR. | Trigger/transacción | UC-18,UC-55 | B1 aprobado |
| MR1-25 | Alta | USUARIO_PROVEEDOR;USUARIO | Permitir varias cuentas históricas pero máximo 1 habilitada por Proveedor necesita control intertabla. | Transición atómica con lock de Proveedor y validación de habilitadas. No UNIQUE simple idProveedor. | Trigger/transacción | UC-17,UC-54,UC-55 | A18 aprobado |
| MR1-26 | Media | USUARIO;SESION_USUARIO | Rastrear qué Administrador realizó UC-54 puede exigir auditoría adicional no modelada. | Definir si auditoría de restablecimiento necesita persistencia; evaluar evento separado solo con autorización. | Posible diseño adicional | UC-53,UC-54 | No aprobado físicamente |
| MR1-27 | Media | USUARIO;ROL;USUARIO_ROL | Las reglas de acceso directo/contextual por CU no son verificables como configuración en base de datos. | Mantener matriz de acceso en capa de autorización o ratificar configuración física si negocio requiere cambios dinámicos. | Arquitectura/opción | UC-01,UC-17,UC-56,UC-64 | Matriz de rol aprobada parcialmente; diseño configurable no aprobado |
| MR1-28 | Alta | COBRO;MOVIMIENTO_CUENTA;MOVIMIENTO_CAJA;ORIGEN_MOVIMIENTO_CUENTA | No garantizan existencia de ambos efectos por cada Cobro confirmado. | Transacción atómica + trigger diferido para exactamente un PAGO y un INGRESO por cobro confirmado. | Trigger/transacción | UC-29,UC-14 | A22 y rol D Admin/Vendedor aprobados |
| MR1-29 | Alta | COBRO;MOVIMIENTO_CAJA | Registrar movimiento manual de Caja como pago de Cliente omitiría Cuenta Corriente. | Restringir UC-22 a movimiento manual no cobro de Cliente; validación de negocio en servidor. | Regla aplicación | UC-22,UC-29 | A22 aprobado / restricción derivada |
| MR1-30 | Alta | REEMBOLSO;INTENTO_REEMBOLSO;EVENTO_RESULTADO_REEMBOLSO | Notificación PROCESADO tardía o doble puede duplicar efectos si se confía solo en clave evento. | Bloquear por Reembolso; máquina de estados terminal PROCESADO y exactamente una aplicación financiera por idReembolso. | Trigger/transacción | UC-26,UC-49 | A7/A8 aprobado |
| MR1-31 | Alta | INTENTO_REEMBOLSO | No se registra físicamente quién pidió reintento manual exclusivo del Administrador. | Reservar modificación al usuario: su implementación debe preservar histórico y null para intento automático; validar al recibir nueva versión. | CAMBIO RESERVADO AL USUARIO | UC-26,UC-49 | A8 aprobado; usuario implementa |
| MR1-32 | Alta | REEMBOLSO;COBRO;MOVIMIENTO_CAJA;MOVIMIENTO_CUENTA | No hay asientos de reversión del cobro físico para cancelación con efectivo; se pactó conservar saldo a favor. | Aplicar sólo reembolso electrónico confirmado; manual mantiene PAGO anterior y crédito. Validar sin Libro Mayor. | Regla/transacción | UC-06,UC-26,UC-49 | A9 aprobado |
| MR1-33 | Media | COBRO;MOVIMIENTO_CAJA;MOVIMIENTO_CUENTA | Anular cobro manual o un movimiento manual ya confirmado sigue sin mecanismo aprobado. | Mantener en RP: aprobar tipos/referencias de reversión antes de diseñar nuevas columnas o tablas. | DECISIÓN ABIERTA | UC-22,UC-29 | B6 pendiente |
| MR1-34 | Media | MOVIMIENTO_CUENTA;PEDIDO;DETALLE_ENTREGA | La mora/categoría depende de antigüedad de deuda y orden de imputación; consulta agregada no basta para reconstruir vencimiento. | Comprobar semántica de antigüedad y asignación de pagos según RF-12; si falta dato de vencimiento histórico, solicitar decisión antes de agregar campo. | Verificación funcional | UC-14,UC-15,UC-16,UC-27,UC-57 | Revisar algoritmo antes de DDL |
| MR1-35 | Media | MOVIMIENTO_CAJA;MOVIMIENTO_CUENTA | No se debe calificar como contabilidad general; son movimientos Caja/Cta Cte coordinados. | Pruebas de conciliación e invariantes según alcance, sin nuevo módulo contable. | Pruebas/control | UC-22,UC-23,UC-29 | Alcance aprobado |
| MR1-36 | Media | PRECIO_PRODUCTO | EXCLUDE temporal no está implementado; puede haber dos precios vigentes. | GiST para intervalos y control de precio vigente único por Producto, preservando históricos. | DDL/índice | UC-03,UC-19,UC-20 | B8 aprobado |
| MR1-37 | Media | PROMOCION | UC-60 requiere transición lógica de desactivación; literales concretos no aprobados. | Decidir catálogo literal + transiciones antes de ampliar CHECK; no tocar descuentos congelados. | DECISIÓN NEGOCIO | UC-24,UC-59,UC-60 | B5 aprobado, catálogo abierto |
| MR1-38 | Media | DETALLE_PEDIDO;PROMOCION_PRODUCTO;DESTINATARIO_PROMOCION | Estado posterior de Promoción no debe alterar precios/promoción ya aplicados; autorización por canal requiere control. | Congelar detalles y validar Producto/destinatario/canal al crear Pedido; consulta UC-59 solo lectura. | Trigger/regla aplicación | UC-03,UC-21,UC-24,UC-59,UC-60 | A19/B5 aprobado |
| MR1-39 | Media | POLITICA_CATEGORIA_COMERCIAL;AJUSTE_POLITICA_CATEGORIA | Política comercial superpuesta cambiaría regla aplicable en UC-15/UC-16. | EXCLUDE temporal por vigencia y validación de ambos ajustes al publicar. | DDL/trigger | UC-15,UC-16,UC-57 | UC-57 aprobado |
| MR1-40 | Alta | POLITICA_COMPRA;CRITERIO_POLITICA_COMPRA;DETALLE_DECISION_CRITERIO | No está especificada normalización ni algoritmo que vuelva comparable y reproducible una decisión de compra. | Cerrar RP-013: catálogo de criterios/escala/datos ausentes/sumatoria y desempate; no hardcodear porcentajes. | DECISIÓN ABIERTA | UC-12,UC-58;PRA-01 | RP-013 abierto |
| MR1-41 | Alta | SOLICITUD_COTIZACION;EPISODIO_FALTANTE | Fuente operativa de plazo aún no elegida (episodio o parámetro independiente). | Cerrar RP-012, definir origen del plazo en PRA-01 y su congelamiento por Solicitud. Evitar atributo ficticio. | DECISIÓN ABIERTA | UC-44,UC-58,UC-62;PRA-01 | RP-012 abierto |
| MR1-42 | Alta | EPISODIO_FALTANTE;SOLICITUD_COTIZACION | DDL no implementa trigger de cruce umbral ni cierre condicionado a stock/solicitudes/órdenes. | PRA-01 transacción para episodio + primera ronda y cierre consistente; no crear Orden automáticamente. | Trigger/transacción | UC-08,UC-12,UC-31,UC-42,UC-44;PRA-01 | PRA-01 aprobado |
| MR1-43 | Alta | RESPUESTA_COTIZACION;SOLICITUD_COTIZACION;INVITACION_COTIZACION | Una respuesta tardía puede violar negocio aunque respete FK/CHECK. | Validar estado RECEPCION_ABIERTA, hora de vencimiento, Proveedor activo/cuenta y unicidad bajo concurrencia. | Trigger/transacción | UC-13,UC-63;PRA-01 | A15 aprobado |
| MR1-44 | Alta | ORDEN_COMPRA;RECEPCION_COMPRA | Acumulados no se controlan con CHECK de fila; riesgo sobrerrecepción/recepción tras cierre. | Trigger diferido suma recepciones y control transición PENDIENTE→PARCIALMENTE_RECIBIDA→RECIBIDA; bloquear CANCELADA/RECIBIDA. | Trigger/transacción | UC-08,UC-12,UC-39,UC-40 | A16/A17 aprobado |
| MR1-45 | Alta | RECEPCION_COMPRA;ORDEN_COMPRA;DECISION_COMPRA | FK a Orden no garantiza Insumo igual al cotizado/ordenado y proveedor correcto. | Validar consistencia OC–Decisión–Respuesta–Insumo y cantidades, sin emitir OC para REVENTA. | Trigger/transacción | UC-08,UC-12 | A16 aprobado |
| MR1-46 | Alta | DECISION_COMPRA;DETALLE_DECISION;RESPUESTA_COTIZACION | Una respuesta evaluada en DETALLE_DECISION puede pertenecer a otra Solicitud. | Trigger diferido para coincidencia de Solicitud, elegibilidad de respuesta y emisión OC tras COMPRA. | Trigger/transacción | UC-12 | AT-12 aprobado como control |
| MR1-47 | Media | PROVEEDOR;USUARIO_PROVEEDOR;INVITACION_COTIZACION | Cuenta deshabilitada/Proveedor INACTIVO no debe responder, pero antecedentes deben conservarse. | Consulta UC-63 y UC-13 con filtrado por Proveedor autenticado, Invitación y vigencia; no borrar invitaciones. | Regla aplicación | UC-11,UC-13,UC-46,UC-63 | A24 aprobado |
| MR1-48 | Media | PROVEEDOR;ORDEN_COMPRA;SOLICITUD_COTIZACION | El tratamiento de órdenes abiertas de Proveedor inactivo continúa parcialmente abierto. | Cerrar decisión operativa, evitar cancelación/recepción automática no autorizada; sin nuevo estado por defecto. | DECISIÓN NEGOCIO | UC-39,UC-45,UC-46 | A24 pendiente parcial |
| MR1-49 | Media | POLITICA_COMPRA;POLITICA_CATEGORIA_COMERCIAL;PRECIO_PRODUCTO | Contenciones temporales simultáneas podrían crear múltiples políticas/precios vigentes. | Consolidar exclusiones de rango y permisos de inmutabilidad de versiones usadas. | DDL/trigger | UC-19,UC-57,UC-58 | No cambio de tabla |
| MR1-50 | Media | MOVIMIENTO_INSUMO;MOVIMIENTO_STOCK_REVENTA | UC-64 requiere filtros por Insumo/Producto, período y origen, potencialmente de alto volumen. | Evaluar índices compuestos de lectura sin redundar índices PK/UNIQUE existentes; permisos lectura diferenciados. | Índices por medir | UC-64 | Consulta aprobada |
| MR1-51 | Media | SOLICITUD_COTIZACION;INVITACION_COTIZACION;RESPUESTA_COTIZACION | UC-62/63 necesitan filtro rápido sin exposición de solicitudes de otros Proveedores. | Índices por estado/vencimiento y Proveedor si plan de ejecución lo exige; seguridad por titularidad. | Índices por medir | UC-62,UC-63 | Consultas aprobadas |
| MR1-52 | Media | USUARIO;INSUMO;EXCEDENTE;PROMOCION | No hay justificación automática para crear 1 tabla por UC de búsqueda. | Mantener consultas parametrizadas; restricciones de rol y propiedad, índices solo al verificar consultas reales. | Sin cambio físico inicial | UC-33..UC-40,UC-56,UC-59,UC-61..UC-64 | Catálogo aprobado |
| MR1-53 | Media | DDL completo | Contar PK/FK no prueba funcionamiento interrelacional ni consistencia temporal. | MR-4: ejecutar en PostgreSQL, constraints diferidos/triggers, pruebas negativas y concurrencia. | Verificación posterior | UC-01..UC-64 | MR-1 auditoría, sin ejecución |

**Evidencia fuente por fila** disponible sin pérdida de detalle en el archivo Excel y el CSV: incluye situación física comprobada, atributo, fuente y localizador.

## 5. Cobertura de las 59 tablas

| Bloque | Tabla | Columnas | CU vinculados | Hallazgos |
|---:|---|---:|---|---|
| 1 | UNIDAD_MEDIDA | 2 | UC-08,UC-10,UC-30,UC-47,UC-50,UC-51 |  |
| 1 | PRODUCTO | 9 | UC-03,UC-07,UC-10,UC-19,UC-21,UC-24,UC-28,UC-30,UC-35,UC-47,UC-48 | MR1-09, MR1-10, MR1-18 |
| 1 | INSUMO | 8 | UC-08,UC-09,UC-10,UC-28,UC-31,UC-36,UC-42,UC-50,UC-51,UC-52,UC-64;PRA-01 | MR1-03, MR1-04, MR1-05, MR1-06, MR1-52 |
| 1 | RECETA | 2 | UC-10,UC-28,UC-47 |  |
| 1 | VERSION_RECETA | 6 | UC-10,UC-28 | MR1-08 |
| 1 | DETALLE_VERSION_RECETA | 5 | UC-10,UC-28 | MR1-08 |
| 1 | PREPARACION | 7 | UC-28,UC-05,UC-06 | MR1-07 |
| 1 | COSTO_INSUMO_HISTORICO | 7 | UC-08,UC-28,UC-42,UC-50,UC-64 | MR1-02 |
| 1 | MOVIMIENTO_INSUMO | 15 | UC-08,UC-09,UC-28,UC-42,UC-50,UC-64;PRA-01 | MR1-01, MR1-02, MR1-06, MR1-07, MR1-50 |
| 2 | PEDIDO | 24 | UC-03,UC-04,UC-05,UC-06,UC-07,UC-16,UC-21,UC-25,UC-27,UC-28,UC-29,UC-34,UC-43 | MR1-12, MR1-13, MR1-14, MR1-18, MR1-34 |
| 2 | DETALLE_PEDIDO | 8 | UC-03,UC-05,UC-07,UC-16,UC-21,UC-27,UC-28,UC-35 | MR1-07, MR1-12, MR1-38 |
| 2 | ASIGNACION_REPARTO | 7 | UC-04,UC-05,UC-06,UC-25,UC-43,UC-55 | MR1-15 |
| 2 | ENTREGA | 3 | UC-05,UC-06,UC-27,UC-29 | MR1-15 |
| 2 | DETALLE_ENTREGA | 4 | UC-05,UC-07,UC-27,UC-64 | MR1-34 |
| 2 | EXCEDENTE | 10 | UC-05,UC-06,UC-07,UC-27,UC-41,UC-61 | MR1-16, MR1-17, MR1-52 |
| 2 | OFERTA_EXCEDENTE | 11 | UC-07,UC-41,UC-61 | MR1-16 |
| 2 | MOVIMIENTO_EXCEDENTE | 8 | UC-07,UC-41,UC-61 | MR1-16 |
| 2 | IMPUTACION_ENTREGA_ADICIONAL | 5 | UC-05,UC-07,UC-27 | MR1-12, MR1-16 |
| 3 | PRECIO_PRODUCTO | 9 | UC-03,UC-19,UC-20,UC-21,UC-27,UC-35 | MR1-19, MR1-36, MR1-49 |
| 3 | AUDITORIA_PRECIO | 11 | UC-19,UC-20 | MR1-19 |
| 3 | PROMOCION | 9 | UC-03,UC-21,UC-24,UC-27,UC-59,UC-60 | MR1-37, MR1-52 |
| 3 | PROMOCION_PRODUCTO | 2 | UC-21,UC-24,UC-59,UC-60 | MR1-38 |
| 3 | DESTINATARIO_PROMOCION | 3 | UC-21,UC-24,UC-59,UC-60 | MR1-38 |
| 3 | INTENTO_COMUNICACION | 9 | UC-24,UC-59 |  |
| 3 | POLITICA_CATEGORIA_COMERCIAL | 6 | UC-03,UC-15,UC-16,UC-21,UC-57 | MR1-39, MR1-49 |
| 3 | AJUSTE_POLITICA_CATEGORIA | 4 | UC-15,UC-16,UC-57 | MR1-39 |
| 4 | CLIENTE | 16 | UC-02,UC-03,UC-05,UC-06,UC-14,UC-15,UC-21,UC-29,UC-32,UC-33,UC-38 | MR1-20 |
| 4 | HISTORIAL_ESTADO_CLIENTE | 7 | UC-38 |  |
| 4 | USUARIO | 7 | UC-01,UC-17,UC-18,UC-53,UC-54,UC-55,UC-56 | MR1-22, MR1-23, MR1-24, MR1-25, MR1-26, MR1-27, MR1-52 |
| 4 | ROL | 2 | UC-01,UC-17,UC-18,UC-55 | MR1-23, MR1-27 |
| 4 | USUARIO_ROL | 3 | UC-01,UC-17,UC-18,UC-55 | MR1-23, MR1-24, MR1-27 |
| 4 | EVENTO_ASIGNACION_ROL | 6 | UC-18 |  |
| 4 | USUARIO_PROVEEDOR | 3 | UC-11,UC-13,UC-17,UC-54,UC-55,UC-63 | MR1-25, MR1-47 |
| 4 | SESION_USUARIO | 6 | UC-01,UC-53,UC-54,UC-55 | MR1-22, MR1-26 |
| 4 | DESAFIO_AUTENTICACION_CLIENTE | 10 | UC-21,UC-32 | MR1-13, MR1-21 |
| 4 | SESION_CLIENTE_ONLINE | 6 | UC-21,UC-32 | MR1-13, MR1-21 |
| 5 | PROVEEDOR | 11 | UC-08,UC-11,UC-12,UC-13,UC-37,UC-44,UC-45,UC-46,UC-63 | MR1-47, MR1-48 |
| 5 | HISTORIAL_ESTADO_PROVEEDOR | 7 | UC-45,UC-46 |  |
| 5 | PROVEEDOR_INSUMO | 4 | UC-08,UC-11,UC-37,UC-44,UC-45,UC-46 |  |
| 5 | EPISODIO_FALTANTE | 5 | UC-08,UC-12,UC-31,UC-42,UC-44,UC-62;PRA-01 | MR1-41, MR1-42 |
| 5 | SOLICITUD_COTIZACION | 12 | UC-12,UC-13,UC-31,UC-44,UC-62,UC-63;PRA-01 | MR1-41, MR1-42, MR1-43, MR1-48, MR1-51 |
| 5 | INVITACION_COTIZACION | 2 | UC-12,UC-13,UC-44,UC-62,UC-63;PRA-01 | MR1-43, MR1-47, MR1-51 |
| 5 | RESPUESTA_COTIZACION | 8 | UC-12,UC-13,UC-62,UC-63;PRA-01 | MR1-43, MR1-46, MR1-51 |
| 5 | POLITICA_COMPRA | 7 | UC-12,UC-44,UC-58;PRA-01 | MR1-40, MR1-49 |
| 5 | CRITERIO_POLITICA_COMPRA | 4 | UC-12,UC-58;PRA-01 | MR1-40 |
| 5 | DECISION_COMPRA | 8 | UC-12,UC-39 | MR1-45, MR1-46 |
| 5 | DETALLE_DECISION | 6 | UC-12 | MR1-46 |
| 5 | DETALLE_DECISION_CRITERIO | 6 | UC-12,UC-58 | MR1-40 |
| 5 | ORDEN_COMPRA | 11 | UC-08,UC-12,UC-39,UC-40,UC-44;PRA-01 | MR1-44, MR1-45, MR1-48 |
| 5 | RECEPCION_COMPRA | 12 | UC-08,UC-09,UC-12,UC-39,UC-64;PRA-01 | MR1-44, MR1-45 |
| 6 | MOVIMIENTO_STOCK_REVENTA | 16 | UC-08,UC-09,UC-05,UC-42,UC-64 | MR1-11, MR1-50 |
| 6 | VALORACION_EXTRAORDINARIA_REVENTA | 7 | UC-08,UC-42,UC-64 | MR1-11 |
| 7 | COBRO | 11 | UC-05,UC-06,UC-21,UC-26,UC-27,UC-29,UC-49 | MR1-28, MR1-29, MR1-32, MR1-33 |
| 7 | MOVIMIENTO_CUENTA | 9 | UC-05,UC-06,UC-14,UC-15,UC-26,UC-27,UC-29,UC-49 | MR1-28, MR1-32, MR1-33, MR1-34, MR1-35 |
| 7 | ORIGEN_MOVIMIENTO_CUENTA | 4 | UC-05,UC-26,UC-29,UC-49 | MR1-28 |
| 7 | MOVIMIENTO_CAJA | 11 | UC-22,UC-23,UC-26,UC-29,UC-49 | MR1-28, MR1-29, MR1-32, MR1-33, MR1-35 |
| 7 | REEMBOLSO | 7 | UC-06,UC-26,UC-49 | MR1-30, MR1-32 |
| 7 | INTENTO_REEMBOLSO | 5 | UC-26,UC-49 | MR1-30, MR1-31 |
| 7 | EVENTO_RESULTADO_REEMBOLSO | 11 | UC-26,UC-49 | MR1-30 |

## 6. Cobertura del catálogo UC-01 a UC-64

Cada UC figura en la hoja «Cobertura 64 CU» del Excel y en el CSV adicional con las tablas de soporte identificadas. La ausencia de un hallazgo específico no certifica implementación correcta.

| CU | Caso de uso | Tablas vinculadas | Hallazgos |
|---|---|---:|---:|
| UC-01 | Iniciar sesión | 4 | 3 |
| UC-02 | Registrar Cliente | 1 | 1 |
| UC-03 | Cargar Pedido | 7 | 5 |
| UC-04 | Consultar Pedidos Asignados | 2 | 1 |
| UC-05 | Registrar Entrega | 13 | 4 |
| UC-06 | Cancelar Pedido | 9 | 1 |
| UC-07 | Ofrecer y Reasignar Excedente | 8 | 3 |
| UC-08 | Registrar Ingreso de Stock por Compra | 11 | 5 |
| UC-09 | Consultar Stock | 4 | 0 |
| UC-10 | Configurar Receta de Producto | 6 | 2 |
| UC-11 | Gestionar Proveedor | 3 | 1 |
| UC-12 | Evaluar Cotizaciones y Resolver Compra | 12 | 5 |
| UC-13 | Responder Solicitud de Cotización | 5 | 2 |
| UC-14 | Consultar Cuenta Corriente | 2 | 2 |
| UC-15 | Evaluar y Actualizar Categoría Comercial | 4 | 2 |
| UC-16 | Aplicar Ajuste Comercial según Categoría | 4 | 3 |
| UC-17 | Crear Usuario | 4 | 3 |
| UC-18 | Gestionar Asignaciones de Roles | 4 | 2 |
| UC-19 | Actualizar Precio Vigente | 3 | 3 |
| UC-20 | Consultar Historial de Precios | 2 | 2 |
| UC-21 | Realizar Pedido Online | 12 | 5 |
| UC-22 | Registrar Movimiento de Caja | 1 | 3 |
| UC-23 | Consultar Libro Diario | 1 | 1 |
| UC-24 | Crear y Comunicar Promoción | 5 | 2 |
| UC-25 | Generar Ruta Sugerida de Reparto | 2 | 1 |
| UC-26 | Procesar Reembolso Electrónico | 7 | 3 |
| UC-27 | Consultar Margen Bruto | 10 | 2 |
| UC-28 | Registrar Preparación de Pedido | 10 | 3 |
| UC-29 | Registrar Cobro | 7 | 4 |
| UC-30 | Gestionar Producto | 2 | 1 |
| UC-31 | Configurar Parámetros de Reposición de Insumo | 3 | 2 |
| UC-32 | Modificar Cliente | 3 | 3 |
| UC-33 | Buscar Cliente | 1 | 2 |
| UC-34 | Buscar Pedido | 1 | 0 |
| UC-35 | Buscar Producto | 3 | 0 |
| UC-36 | Buscar Insumo | 1 | 0 |
| UC-37 | Buscar Proveedor | 2 | 0 |
| UC-38 | Cambiar Estado de Cliente | 2 | 0 |
| UC-39 | Cancelar Orden de Compra | 3 | 2 |
| UC-40 | Buscar Orden de Compra | 1 | 2 |
| UC-41 | Registrar Descarte de Excedente | 3 | 2 |
| UC-42 | Registrar Ajuste de Inventario | 6 | 5 |
| UC-43 | Asignar y Reasignar Pedidos a Repartidores | 2 | 1 |
| UC-44 | Iniciar Ronda Manual de Cotización | 7 | 2 |
| UC-45 | Modificar Proveedor | 3 | 1 |
| UC-46 | Cambiar Estado de Proveedor | 3 | 2 |
| UC-47 | Modificar Producto | 3 | 1 |
| UC-48 | Cambiar Estado de Producto | 1 | 2 |
| UC-49 | Registrar Resultado de Reembolso Electrónico | 7 | 3 |
| UC-50 | Registrar Insumo | 4 | 4 |
| UC-51 | Modificar Insumo | 2 | 2 |
| UC-52 | Cambiar Estado de Insumo | 1 | 1 |
| UC-53 | Cambiar Contraseña | 2 | 2 |
| UC-54 | Restablecer Acceso de Usuario | 3 | 3 |
| UC-55 | Cambiar Estado de Usuario | 6 | 4 |
| UC-56 | Buscar Usuario | 1 | 2 |
| UC-57 | Configurar Política de Categoría Comercial | 2 | 3 |
| UC-58 | Configurar Política de Compra | 3 | 3 |
| UC-59 | Consultar Promociones | 4 | 3 |
| UC-60 | Desactivar Promoción | 3 | 2 |
| UC-61 | Buscar Excedente | 3 | 3 |
| UC-62 | Buscar Solicitud de Cotización | 4 | 2 |
| UC-63 | Consultar Solicitudes de Cotización Recibidas | 5 | 3 |
| UC-64 | Consultar Movimientos de Inventario | 7 | 7 |

## 7. Decisiones propuestas para MR-2

1. **DDL y apertura de Insumos (aprobado):** revisar `SALDO_INICIAL`, costo inicial, posible origen y contabilidad de stock.
2. **Unicidad de `INSUMO.nombre`:** validar equivalencia normalizada antes de fijar un índice.
3. **Responsable de reintento:** reservado al usuario; MR-2 incorpora la versión corregida que el usuario entregue.
4. **RP-012:** decidir fuente del plazo de respuesta operativo; no usar `periodoCalculoDias`.
5. **RP-013:** precisar escala, normalización, faltantes de datos y desempate de evaluación ponderada.
6. **Promociones:** decidir literales del catálogo `PROMOCION.estado` y transiciones permitidas.
7. **Seguridad:** validar auditoría de restablecimientos de contraseña y si precisa persistencia adicional.
8. **Estados de Producto/Proveedor:** decidir historia y resolución de operaciones abiertas sin inferir nuevos estados.
9. **Correcciones de Caja/Cobros:** decidir si hay contra-asiento auditable y cómo se referencia origen.
10. **Control físico:** diseñar triggers y pruebas de simultaneidad para stock, ofertas, entregas, órdenes, reembolsos, vigencias y Usuarios.


## 8. Cambios que MR-1 no realiza

- No modifica el modelo de 59 tablas, el diccionario, DDL ni ningún Draw.io.
- No ejecuta SQL ni prueba restricciones en PostgreSQL.
- No añade columnas, tablas, estados, pesos, fórmulas, plazos de horas ni reglas offline no aprobadas.
- No incorpora la FK de responsable del reintento: esta tarea la hará el usuario.
- Las siete relaciones «include» nuevas aprobadas corresponden al UML y no implican automáticamente cambios relacionales.

## 9. Fuentes

- `Esquema_Maestro_Relacional_59_Tablas_ACTUALIZADO_23-10-2026.md`
- `Diccionario_Columnas_59_Tablas_ACTUALIZADO_23-10-2026.csv`
- `Esqueleto_DDL_59_Tablas_NO_EJECUTADO_ACTUALIZADO.sql`
- `ALE_MILANESAS_FASE_4_CU_01_A_64_TRES_NIVELES.docx`
- `RD_01_Registro_Decisiones_V1_1_Fase_2_3_25-10-2026.md`
- `RP_01_Registro_Pendientes_V1_1_Fase_2_3_25-10-2026.md`
- `PRA_01_Proceso_Reposicion_Automatica_V1_1_Fase_2_3_25-10-2026.md`
- `A_Requisitos_ACTUALIZADO_23-10-2026.md`
- `B_Dominio_y_Diseño_ACTUALIZADO_23-10-2026.md`
- `AUDITORIA_TRANSVERSAL_MODELO_RELACIONAL_ALE_22-10-2026.md`
