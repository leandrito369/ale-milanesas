# RD-F04-003 — Pago en tránsito y saldo exigible provisional

**Fecha:** 26/10/2026  
**Autoridad:** aprobación expresa del responsable del proyecto durante la conversación de análisis F04.  
**Estado funcional:** **APROBADA** para la separación del pago en tránsito y su tratamiento provisional tras sincronización validada.  
**Estado de diseño físico e implementación:** **PENDIENTE**; no se ha autorizado todavía una estructura SQL concreta, ni se han implementado servicios.

## 1. Decisión aprobada

1. La recepción de efectivo del Cliente por el Repartidor puede representarse mediante un **registro de pago en tránsito independiente de `COBRO`**. Es un concepto funcional; su nombre, ubicación física y estructura definitiva están pendientes de diseño y revisión.
2. **Solo después de sincronizar el registro y superar las validaciones del servidor**, el importe validado reduce la **deuda exigible provisional** del Cliente.
3. El reconocimiento provisional **no produce ingreso en Caja**, **no crea un `COBRO` confirmado** y **no modifica** los asientos ni el saldo contable definitivo de `MOVIMIENTO_CUENTA`.
4. La consulta debe distinguir con claridad entre **saldo confirmado**, **importe validado en tránsito** y **saldo exigible provisional**. Una deuda mostrada como provisionalmente cubierta **no equivale a pago definitivo contabilizado**.
5. El servidor **no puede atribuir efectos centrales a capturas que continúan sin sincronizar**. La hora local de captura se conserva como evidencia, no como sustituto de la validación remota.
6. El registro definitivo del cobro rendido continúa sujeto a la **recepción, verificación y autorización del Administrador** según RD-F04-002, con deduplicación e integridad de Caja/Cuenta Corriente.
7. Se conservan exactamente los dos estados aprobados para `COBRO.estadoCobro`: **`CONFIRMADO` y `ANULADO`** (RD-F01). Una eventual etiqueta `PENDIENTE_RENDICION` correspondería exclusivamente a la operación independiente; ese literal y su catálogo detallado **no quedan aprobados aquí**.

## 2. Proyección conceptual, sin columna nueva aprobada

Para consultas operativas se propone distinguir:

- `saldoConfirmado`: el saldo contable de Cuenta Corriente, preservado.
- `importeEnTransitoValidado`: el total de importes sincronizados, aceptados por el servidor y todavía no aplicados definitivamente.
- `saldoExigibleProvisional`: `saldoConfirmado - importeEnTransitoValidado`, **solo como proyección de consulta**.

La regla concreta para excedentes, saldos negativos, pagos parciales y la base de cálculo del importe reconocido requiere diseño y aprobación específicos. No se crea crédito definitivo por mera declaración.

## 3. Coherencia con decisiones previas

| Fuente | Compatibilidad |
|---|---|
| RD-F01 | No agregar estados a `COBRO`, ni anticipar sus asientos. |
| RD-F04-001 | UC-03 y UC-05 admiten captura offline; UC-43 sigue exclusivamente online. |
| RD-F04-002 | La rendición se entrega al Administrador al finalizar recorrido; solo el Administrador autoriza y resuelve diferencias con motivo. |
| S-01 / RP-007 | No se habilita automáticamente UC-29 al Repartidor. Declarar efectivo en UC-05 requiere aclaración funcional separada. |
| MR-5 | `MOVIMIENTO_CUENTA` y `MOVIMIENTO_CAJA` mantienen su inmutabilidad y efectos definitivos; cualquier persistencia nueva requiere trazabilidad y pruebas. |

## 4. Pendientes que esta aprobación NO resuelve

- **Permiso/alcance de UC-05:** autorizar de modo expreso que el Repartidor pueda declarar recepción de efectivo como información asociada a la Entrega, **sin permiso de UC-29**.
- **Faltante en rendición:** determinar si una declaración validada mantiene al Cliente provisionalmente cubierto durante la investigación, sin retornar automáticamente el faltante a deuda exigible.
- **Evaluación comercial:** definir si la deuda exigible provisional incide en elegibilidad de nuevos Pedidos, sin modificar automáticamente la categoría `CUMPLIDOR`/`EN_MORA`.
- **Controles y evidencia:** eventos duplicados, importes parciales/excedentes, prueba de recepción física, responsabilidad de custodia, plazos y resolución de disputas.
- **Diseño físico y API:** tabla(s), claves, índices, vínculos con Pedido/Entrega/Repartidor, estados operativos, contrato de sincronización, atomicidad y pruebas. **No autorizado implícitamente**.

## 5. Trazabilidad y pruebas futuras

- Frente F04, contrato S-01; UC-05, UC-29; RP-006/RP-007; RD-F01, RD-F04-001 y RD-F04-002.
- [Análisis técnico y alternativas](../06-arquitectura/F04_EVALUACION_PAGO_EN_TRANSITO_PROPUESTA_2026-10-26.md).
- [PR #5](https://github.com/leandrito369/ale-milanesas/pull/5); [Issue #6](https://github.com/leandrito369/ale-milanesas/issues/6).
- QA futura: duplicación de UUID, asincronía, pérdida de respuesta tras COMMIT, cambio de asignación, actualización simultánea de rendición, neutralidad en Caja y ausencia de doble descuento cuando se aplique el cobro definitivo.

**Este registro documenta una decisión funcional, no certifica una implementación en PostgreSQL ni autoriza un cambio físico.**
