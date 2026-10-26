# Ale Milanesas | MR-5 — Contratos de servicios transaccionales

**Fecha de referencia:** 25/10/2026. **Estado:** diseño de implementación y pruebas; **NO probado ni ejecutado**. Los triggers del parche no sustituyen servicios de aplicación ni permisos de BD.

## S-01 | Sincronización offline (F04; UC-03/05/29/43)

- **Entrada mínima:** identificador UUID inmutable de la operación de origen, usuario autenticado, autorización vigente, Pedido y asignación (si corresponde), instantánea de importes/condiciones congelados y marca temporal capturada localmente.
- **Regla de permisos innegociable:** Repartidor **no** tiene permiso directo UC-29. Si traslada un Cobro de efectivo, la operación administrativa de conciliación/registración requiere Vendedor o Administrador autorizado. La expresión «El Reparto Manda» no revoca esta matriz RBAC.
- **Transacción:** verificar evento duplicado por `claveIdempotenciaOrigen`/`idOperacionOrigen`, bloquear Pedido y Cliente, verificar asignación/habilitación antes de aceptar, comparar condiciones congeladas, emitir registros una sola vez. Si hay conflicto de autorización o asignación, no confirmar automáticamente: registrar para conciliación y responder estado de rechazo/no aplicado sin fingir éxito.
- **Aceptación:** mismo UUID reintentado N veces ⇒ un efecto; precio o categoría cambiados luego de operación válida ⇒ no se altera el importe congelado; cliente inactivo o asignación revocada antes de la confirmación válida ⇒ conflicto explícito, no acceso implícito; retorno después de pérdida de conexión ⇒ sin doble Cobro.
- **Límite físico:** hoy no existe un inbox/snapshot dedicado a eventos offline; el modelo permite IDs en Pedido/Cobro, pero no garantiza por sí solo un registro universal de sincronización. La granularidad de evento y la reconciliación quedan para diseño de API.

## S-02 | PRA-01 (F05; UC-08/12/13/44/50/58)

- **Disparador:** cruce efectivo bajo `umbralMinimo` en `INSUMO`, no cada consulta de stock. `fn_mr5_validar_primera_ronda` verifica el plazo aplicado al primer envío automático, pero **no detecta** por sí mismo el cruce.
- **Secuencia:** (1) iniciar transacción; (2) bloquear el Insumo y su episodio activo, con un orden de locks único; (3) confirmar cruce, automatización y ausencia de episodio abierto; (4) crear/reutilizar `EPISODIO_FALTANTE`; (5) leer `CONFIGURACION_OPERATIVA`, aceptar override admin solo si autorizado y congelarlo; (6) calcular elegibilidad de proveedores; (7) crear como máximo una Solicitud AUTOMATICA por episodio e invitaciones de forma atómica; (8) confirmar y publicar notificaciones desde un mecanismo de entrega confiable (sin duplicarlas); (9) al vencimiento cerrar recepción, evaluar estado `SIN_RESPUESTAS`/`SIN_OFERTAS_ELEGIBLES` como razones de negocio; (10) exigir UC-12 para decidir cualquier Orden; (11) cerrar episodio solo con stock recuperado y sin pendientes asociados.
- **Aceptar concurrencia:** dos procesos simultáneos de cruce ⇒ un episodio y a lo sumo una primera Solicitud; reintento del envío ⇒ no duplicar solicitudes/invitaciones. Ningún cierre de episodio con OC `PENDIENTE`/`PARCIALMENTE_RECIBIDA`.
- **Límite SQL:** indices `uq_episodio_faltante_abierto` y `uq_solicitud_automatica` ya existían. El parche agrega un comprobador de primera ronda y cierre, pero **no genera proveedores, comunicaciones ni decisiones**. No agregar actor «Sistema» al UML.

## S-03 | Procesar resultado de Reembolso (F06; UC-26 y UC-49)

- **Entrada:** evento externo verificado, identificador externo único, `idReembolso`/`numeroIntento` existente, resultado `PENDIENTE`/`RECHAZADO`/`PROCESADO` y fecha de recepción. No inventar un segundo Reembolso por un reintento.
- **Transacción:** bloquear `REEMBOLSO` y su Cobro; verificar autenticidad/firma de MercadoPago **antes** de marcar `autenticado`; deduplicar por identificador externo y referencia de operación; registrar evento con `aplicable=false` si está duplicado o no corresponde; si `PROCESADO` aplicable, registrar 1 EGRESO de `MOVIMIENTO_CAJA` y 1 `AJUSTE_DEBITO` + `ORIGEN_MOVIMIENTO_CUENTA` del mismo importe, actualizar `REEMBOLSO.estado='PROCESADO'`, cerrar transacción; solo después notificar Cliente / reevaluar categoría. Si falla cualquier escritura, rollback de todo el resultado monetario.
- **Restricciones SQL:** MR-3 ya usa `UNIQUE` por Reembolso; MR-5 añade integridad diferida `PROCESADO ⇔ efectos` (solo para registros procesados y sus pares) y un único evento PROCESADO declarado aplicable. Esto no autentica la firma del proveedor ni decide por sí solo cuál de dos eventos concurrentes es aplicable.
- **Aceptar:** evento duplicado con igual o distinto ID ⇒ cero duplicados monetarios; respuesta tardía PROCESADO del intento válido ⇒ aplicar una vez; `RECHAZADO` ⇒ sin EGRESO; segundo intento con `idUsuarioReintento` válido ⇒ mismo Reembolso, nuevo intento; fallo simulado entre Caja y Cuenta ⇒ rollback íntegro.
- **Nota de validación:** la elección del estado original de `COBRO.estadoCobro` sigue sin catálogo aprobado; ningún test debe construir uno como regla de negocio.

## S-04 | Cuentas, Roles y sesiones (F07; UC-17/18/53/54/55)

- **Alta:** crear Usuario + 1..N Roles + vínculo PROVEEDOR si corresponde **dentro de una misma transacción**. No dejar usuarios huérfanos.
- **Deshabilitación:** bloquear y verificar que continúe al menos un Administrador habilitado; revocar sesiones al cambiar contraseña, estado, Roles o vínculo PROVEEDOR; la autorización en cada petición debe validar estado activo y sesión no revocada.
- **Roles:** PROVEEDOR exclusivo y máximo una cuenta habilitada por Proveedor. El parche usa constraint triggers diferidos para admitir altas atómicas y `pg_advisory_xact_lock` para serializar la comprobación del último Administrador; validar en PostgreSQL con dos sesiones concurrentes.
- **Restablecimiento UC-54:** solo cuenta PROVEEDOR mediante Administrador autorizado, nueva credencial protegida, `cambioCredencialPendiente=true`, revocar sesiones. No guardar contraseñas en texto claro ni editar hashes manualmente.
- **Seguridad física pendiente:** revocar permisos `INSERT/UPDATE/DELETE` directos a los roles SQL de la aplicación donde corresponda; diseñar funciones `SECURITY DEFINER` con `search_path` fijo, ownership y GRANT explícitos antes de desplegar. Un trigger no demuestra por sí solo la identidad del actor HTTP.

## S-05 | Promociones, bajas lógicas y operaciones iniciadas (F08/F09)

- `PAUSADA→ACTIVA`: temporalmente **denegada** por el parche; la pausa existe, pero no hay UC/permiso específico aprobado para reanudar. `PAUSADA→FINALIZADA/CANCELADA` permanece permitida. Si negocio necesita reactivación, registrar nueva RD/CU autorizado.
- Insertar nuevo Pedido/Detalle/Invitación/Orden con Cliente, Producto o Proveedor inactivo: **rechazar**. Edición que cambia referencia a otra entidad inactiva: **rechazar**. Conservar Pedido/OC previamente iniciados y permitir su finalización válida sin cancelar automáticamente.
- El parche aplica `FOR SHARE` en el catálogo activo para bloquear carreras con UPDATE de estado, pero no prueba todavía todos los órdenes de locking ni migraciones con operaciones existentes. No actualizar importes ni condiciones históricas tras inactivar un catálogo.

## Criterios de cierre de MR-5/MR-6

1. Aplicar MR-3 y MR-5 en una **base descartable**; reportar resultados reales `PASS/FAIL` y PostgreSQL versión/extensión.
2. Ejecutar invariantes con inserciones negativas y positivas, fechas, concurrencia a dos sesiones, pruebas de rollback e idempotencia.
3. Comparar snapshots MR-3↔MR-5, documentar cambios de performance y permisos. Solo después etiquetar DDL como ejecutado.
4. Mantener F01 abierta hasta aprobar literal(es) adicionales a `ANULADO`; F04/F05/F06 permanecerán **parciales** hasta contar con servicios probados.
