# RD-F01 — Catálogo cerrado de estados de COBRO

**Fecha:** 26/10/2026. **Autoridad:** aprobación explícita del usuario durante esta conversación. **Estado funcional:** APROBADA. **Estado físico:** PROPUESTO en PR; no instalado en producción.

## Decisión aprobada
- `COBRO.estadoCobro` acepta únicamente `CONFIRMADO` y `ANULADO`.
- `CONFIRMADO`: cobro validado que ya generó sus efectos correspondientes en Cuenta Corriente y Caja.
- `ANULADO`: cobro anteriormente confirmado cuya anulación administrativa quedó respaldada por contraasientos. Es terminal.
- Los pagos todavía pendientes de acreditación online y las operaciones offline no sincronizadas se gestionan **fuera de COBRO**, sin generar efectos monetarios hasta validación.
- `REEMBOLSO.estado` es un proceso independiente (`PENDIENTE`, `PROCESADO`, `RECHAZADO`) y no introduce estados adicionales en COBRO.
- La anulación de cobros ONLINE/MERCADOPAGO no se confunde con el reembolso electrónico.

## Impacto / transición
- Alta de `COBRO`: solo `CONFIRMADO`.
- Actualización: `CONFIRMADO → ANULADO` por la operación administrativa existente que exige autorización, asiento original y contraasientos. `ANULADO` no revierte a `CONFIRMADO`.
- No borrar `COBRO` ni modificar sus datos históricos. Los duplicados se previenen mediante `claveIdempotenciaOrigen` y referencias existentes.
- No se añade tabla ni columna. El modelo relacional gráfico mantiene las 60 tablas/453 columnas/125 FK.
- Los literales `ESTADO_PRUEBA` y `ESTADO_PARA_PRUEBA` usados históricamente en MR-6/MR-5 **nunca fueron estados de negocio**. No alterar esos artefactos históricos: aplicar F01 **después** de sus pruebas en el CI.

## Aplicación y migración
Fuente incremental: `docs/05-modelo-relacional/sql/f01/F01_PATCH_POST_MR5.sql`.
Antes de activar un catálogo cerrado en un entorno con datos, revisar distribución de estados existentes y bloquear la migración si hay otros literales; **no convertir estados desconocidos a CONFIRMADO automáticamente**.
Esta modificación del DDL no implementa validación de cobros online ni sincronización offline, ni prueba transacciones de servicios de aplicación.

## Trazabilidad
- F01 (hallazgo MR-4/MR-5), RD-003 y RD-004; UC-29 Registrar Cobro, UC-26 Procesar Reembolso Electrónico, UC-49 y UC-06 Cancelar Pedido.
- Pendientes de aplicación: F04 sincronización offline, F06 servicio de reembolso y F07 RBAC de API.
- Pruebas F01 en PostgreSQL aislado; informe de CI del PR adjunto como evidencia cuando termine.
