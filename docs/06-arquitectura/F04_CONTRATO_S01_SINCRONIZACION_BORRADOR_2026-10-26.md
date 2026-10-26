# F04 — Contrato técnico preliminar de sincronización S-01

**Fecha:** 26/10/2026. **Estado:** PROPUESTA TÉCNICA NO APROBADA para API, colas y persistencia. No implementado ni probado.  
**Alcance funcional vinculante:** RD-F04-001/002/003/004/005/006 y RD-F01.  
**Fuentes:** `AGENTS.md`, `docs/05-modelo-relacional/MR5_CONTRATOS_SERVICIOS.md` (S-01), esquema MR-5, requisitos RF-12/UC-03/05/16/17/29/43.

## 1. Operaciones en alcance

| Operación | Captura offline | Efecto central tras sincronizar | Autorización |
|---|---|---|---|
| UC-03: carga de Pedido | Sí | Crear Pedido solo tras validaciones y aceptación transaccional | Actor con permiso UC-03 vigente |
| UC-05: entrega | Sí | Aplicar Entrega válida una sola vez | Repartidor autorizado y asignado |
| Declaración de efectivo recibido en UC-05 | Sí | Reconocer pago en tránsito y afectar solo exigibilidad provisional tras validación | Repartidor autorizado para UC-05; **no** UC-29 |
| UC-43: asignar/reasignar | **No** | Requiere llamada online validada | Permisos vigentes para UC-43 |
| UC-29: Cobro definitivo | No autorizado por estas RD para Repartidor | Cobro / Cuenta / Caja solo por flujo administrativo autorizado | Repartidor **sin** acceso directo; responsable de rendición: Administrador |

No es un CU adicional de negocio ni altera los 64 CU.

## 2. Propuesta de contrato de entrada/salida (sin endpoint ratificado)

**Candidato:** `POST /api/sincronizaciones/operaciones`. Debe autenticar la sesión y revisar en el servidor roles vigentes. El `idUsuario` declarado en el dispositivo es evidencia, **no prueba autónoma de identidad**.

Envoltorio lógico sugerido:
- `idOperacionOrigen`: UUID inmutable. Reintentos deben repetir exactamente mismo UUID y payload lógico.
- `tipoOperacion`: `CAPTURA_PEDIDO`, `CAPTURA_ENTREGA` o `DECLARACION_EFECTIVO` como **nombres candidatos técnicos**.
- `versionContrato`, `fechaHoraCapturaLocal`, referencias `idPedido`/asignación/Cliente según evento y `snapshot` inmutable de condiciones relevantes.
- Para declaración de efectivo: `importeRecibido`, referencia de Pedido/Entrega y responsable identificado por la sesión.
- El servidor puede añadir `fechaHoraRecepcionServidor`, identificador de confirmación, huella del payload e historial de resultado. Nunca confundir tiempo local con tiempo de validación.

**Respuesta propuesta:** identificador de origen, resultado distinguible de aplicación definitiva / reconocimiento provisional / conflicto no aplicado, detalle estable de validación y referencia al registro central. Se definirán códigos y literales definitivos en diseño API, no como nuevos estados de negocio.

## 3. Modelo lógico de cola e idempotencia

- **Dispositivo:** guardar evento completo, snapshots y UUID en almacenamiento local transaccional protegido; marcar intentos, conservar hasta confirmación duradera del servidor y reintentar con mismo identificador ante red intermitente. No cambiar payload de un UUID existente.
- **Servidor (candidato):** inbox transaccional con clave de origen, tipo, huella/payload, actor, recepción y resolución. Exigir exclusión de eventos concurrentes con misma clave; mismo UUID+payload devuelve el resultado estable; mismo UUID+payload distinto produce conflicto.
- `PEDIDO.idOperacionOrigen` y `COBRO.claveIdempotenciaOrigen` existen en el esquema, pero **`ENTREGA` no tiene UUID de origen universal** y no existe inbox para todos los eventos: deberá resolverse en un CR de diseño físico antes de construir el servicio.
- Si una entrega ya fue aplicada al Pedido, una operación distinta que intenta aplicarla de nuevo no debe producir nueva Entrega; diferenciar reintento idéntico de operación en conflicto.

## 4. Secuencia transaccional candidata

1. Verificar autenticación, habilitación y permiso **actuales**, sin conferir UC-29 por estar asignado como Repartidor.
2. Consultar/registrar clave idempotente bajo bloqueo o restricción única; evitar condición de carrera en el inbox.
3. Verificar Cliente activo para nuevos pedidos, Pedido, vigencia y asignación aplicables al evento; leer snapshots congelados.
4. Comparar datos, precios históricos, promociones, categoría comercial aplicada al Pedido y cantidad; no sustituir sin justificación el snapshot de un pedido ya aceptado.
5. Aplicar atomícamente el efecto admitido, registrar origen y respuesta estable; si hay conflicto retornar resultado no aplicado y razón auditable.
6. Solo después de COMMIT responder confirmación. Si la respuesta se pierde, el reintento obtiene el mismo resultado sin duplicar.
7. Para **declaración de efectivo**, el efecto es **reconocimiento provisional independiente** de COBRO/Caja/`MOVIMIENTO_CUENTA`; no generar asiento definitivo.
8. Para **rendición administrativa**, exigir Administrador; solo lo efectivamente rendido/validado se contabiliza por el flujo definitivo correspondiente, retirando simultáneamente la contribución provisional que corresponda. Si hay diferencia, queda pendiente de conciliación dentro del límite RD-F04-005; no reexigir automáticamente al Cliente.

Este borrador no define todavía política de resolución de todos los conflictos de catálogo, asignación o permisos.

## 5. Dos saldos y categoría comercial

**En servidor:**
- `saldoConfirmado`: saldo contable de Cuenta Corriente (no mutable por proyecciones).
- `pagoEnTransitoValidado`: suma no duplicada de eventos válidos aún no aplicados definitivamente.
- `saldoExigibleProvisional`: proyección operativa de saldo confirmado y pagos en tránsito válidos (RD-F04-003); la fórmula y control de excedentes requieren especificación adicional.

**RD-F04-006:** para evaluar deuda al crear un Pedido se usa el **saldo exigible provisional**. El cálculo no transforma `CLIENTE.categoriaComercial` (`CUMPLIDOR`/`EN_MORA`), no cambia automáticamente la política de descuento/recargo y no omite otras restricciones.

**Ejemplo de decisión de negocio aún pendiente:** Cliente clasificado `EN_MORA` cuyo saldo exigible provisional es cero tras un pago validado. La deuda se evalúa con cero provisional, **pero el descuento/recargo del nuevo Pedido continúa obedeciendo a la categoría vigente** mientras no se apruebe otra regla. No se presume reclasificación ni se modifican instantáneas históricas.

**Pedidos capturados offline:** un evento local no ingresado al servidor no reduce todavía deuda central. Al sincronizar UC-03, el servidor vuelve a evaluar deuda y otras restricciones, pudiendo comunicar conflicto; no asignar una política comercial inexistente por inferencia.

## 6. Pruebas de aceptación por implementar

- Mismo UUID reenviado N veces y desde dos clientes ⇒ un resultado y un efecto.
- UUID reutilizado con payload diferente ⇒ conflicto sin modificar registro.
- Respuesta perdida después del COMMIT ⇒ consulta/reintento idempotente.
- Entrega sincronizada después de reasignación o baja de actor ⇒ no aplicación automática; evento conflictivo auditable.
- Declaración de efectivo solo local ⇒ ni Caja ni saldo contable ni exigibilidad provisional central cambian.
- Declaración validada ⇒ cambia solo exigibilidad provisional; Cliente y Pedido relacionados correctamente.
- Registro definitivo por Administrador ⇒ desaparición del descuento provisional y un único Cobro/Caja/Cuenta correspondiente.
- Faltante en rendición ⇒ pendiente de conciliación sin Caja ficticia ni deuda reexigida automáticamente.
- Cliente `EN_MORA` con deuda provisoriamente cubierta ⇒ se utiliza deuda provisional al evaluar Pedido, sin reclasificación automática.
- Concurrencia de Pedido y eventos en tránsito ⇒ lecturas consistentes; no saldos provisionales duplicados.
- Importe negativo, cero, excedente, pago parcial o eventos para otro Cliente ⇒ validaciones y política a aprobar; **no fijar umbrales por defecto**.

## 7. Decisiones pendientes que bloquean cierre técnico

1. **Ajuste comercial:** si hay pago validado y `EN_MORA` vigente, ¿sigue el recargo hasta reevaluación comercial ordinaria o hay tratamiento especial para el nuevo Pedido? **No alterar valores sin aprobación**.
2. **Evidencia de recepción de efectivo:** mecanismo verificable para evitar declaraciones falsas/repetidas, respetando protección de datos.
3. **Excedentes y pagos parciales:** cómo se visualizan y aplican provisionalmente; no inventar crédito definitivo.
4. **Persistencia/inbox y estados técnicos:** propuesta de entidad lógica, FK, índices, endpoints y migración física específica; requiere CR y pruebas PostgreSQL.
5. **Retención, reintentos, autentificación de dispositivo y control de accesos** a eventos pendientes; plazos no aprobados.
6. **Reglas de conflictos** por categoría o precios no coincidentes antes de la aceptación central de un Pedido offline.

**No modificar el DDL, ni dar por implementadas rutinas o pruebas de servicio sobre la base de este documento.**
