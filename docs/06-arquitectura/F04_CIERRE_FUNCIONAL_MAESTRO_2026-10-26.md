# F04 — Acta maestra de cierre funcional

**Fecha:** 26/10/2026. **Estado del bloque:** ANÁLISIS FUNCIONAL CERRADO; diseño técnico PRELIMINAR; implementación y pruebas PENDIENTES.

## Fuentes de autoridad y precedencia

Se consolidan las decisiones del responsable del proyecto RD-F04-001 a RD-F04-007. **Las RD posteriores complementan y resuelven preguntas originalmente señaladas como pendientes en las RD anteriores**; no sustituyen sus reglas aprobadas. El texto técnico marcado como **propuesta** no adquiere aprobación por la fusión de este PR. RD-F01 permanece vigente: `COBRO.estadoCobro` únicamente `CONFIRMADO`/`ANULADO`.

## Decisiones funcionales aprobadas

| RD | Decisión |
|---|---|
| RD-F04-001 | UC-03 Cargar Pedido y UC-05 Registrar Entrega admiten captura offline, validable posteriormente en servidor. UC-43 Asignación y reasignación de reparto exclusivamente online. |
| RD-F04-002 | Al finalizar cada recorrido, el Administrador recibe el efectivo del Repartidor y autoriza el registro definitivo. La rendición conserva Repartidor, recorrido, fecha/hora, importe esperado, recibido, diferencia y Administrador; si hay diferencia, observación obligatoria. Solo Administrador puede resolver y cerrar diferencias con motivo. |
| RD-F04-003 | Pago en tránsito separado de `COBRO`; exclusivamente tras sincronización y validación central reduce deuda exigible **provisional**, sin alterar Caja ni saldo contable confirmado. El Cliente consulta ambos saldos diferenciados. |
| RD-F04-004 | En UC-05 el Repartidor puede declarar efectivo efectivamente recibido, asociado a Pedido/Entrega, incluso offline. Validar identidad, asignación, importe e idempotencia en servidor. No concede UC-29 ni habilita Cobros definitivos. |
| RD-F04-005 | Si falta efectivo de una declaración sincronizada y validada, la rendición **queda pendiente de conciliación**; no reaparece automáticamente la deuda exigible del Cliente ni se registra Caja ficticia. La investigación, atribución de responsabilidad y procedimientos pormenorizados **no forman parte del alcance de F04**. |
| RD-F04-006 | Para evaluar deuda al cargar nuevos Pedidos se utiliza el saldo exigible provisional validado. La categoría comercial `CUMPLIDOR`/`EN_MORA` permanece independiente y no cambia automáticamente. Las demás restricciones siguen vigentes. |
| RD-F04-007 | El ajuste comercial propio de `EN_MORA` permanece hasta una reevaluación formal, aunque los pagos en tránsito validados cubran provisionalmente la deuda. No suspender recargo ni modificar condiciones comerciales históricas. |

## Flujo funcional delimitado

1. Captura local de Pedido o Entrega, y eventual declaración de efectivo recibida por el Repartidor en UC-05.
2. Sincronización hacia servidor con controles de identidad, autorización vigente, asignación, instantáneas e idempotencia. Hasta confirmación remota, el evento solo existe localmente.
3. Una declaración de efectivo validada queda en el circuito de pagos en tránsito **separado de COBRO**. Su importe se visualiza en la deuda exigible provisional; ni Caja ni el libro definitivo se alteran.
4. Cuando se consulta deuda de un Cliente para un nuevo Pedido, se considera la exigibilidad provisional validada, pero el ajuste de precio sigue respetando la categoría comercial vigente y el Pedido conserva su instantánea histórica.
5. Al finalizar el recorrido, el Repartidor rinde al Administrador. El Administrador verifica importes, autoriza registros definitivos y deja diferencias **pendientes de conciliación**, sin declarar cobrado lo no recibido. No se rediseñan investigaciones ni atribuciones de responsabilidades.
6. El futuro servicio debe convertir reconocimiento provisional a definitivo en una operación consistente y sin doble descuento; el mecanismo SQL/API específico sigue por diseñar.

## Compatibilidad transversal

- **UC-29 / RBAC:** Repartidor no tiene autorización directa para registrar Cobro; su declaración UC-05 es evidencia de recepción, no Cobro definitivo. Permisos generales Vendedor/Administrador para otros flujos UC-29 permanecen en RP-007, sin ratificación implícita.
- **RD-F01:** el estado `PENDIENTE_RENDICION`, si se adopta técnicamente, pertenecería al evento independiente, jamás a `COBRO.estadoCobro`. No se ha ratificado su catálogo físico.
- **MR-5 / MR-6:** el diseño físico existente de 60 tablas y sus pruebas PostgreSQL 17.11 siguen sin implementar el servicio offline ni un inbox universal; los cambios de estructura precisan CR separado.
- **Modelado:** no se renumeran los 64 CU, ni se reemplaza el diagrama de CU rechazado, ni se altera el diagrama relacional aprobado en PR #3.

## Entregables técnicos, explícitamente no cerrados

- Contrato S-01 y esquema de cola Android/Room e inbox transaccional API/PostgreSQL.
- Identificadores origen y deduplicación para UC-03/05 y declaraciones, snapshots verificables, control de concurrencia y bloqueos.
- Evidencias y comprobantes, importes parciales/excedentes y reglas de conflictos de sincronización.
- Políticas de reintentos/retención y seguridad del dispositivo; detalle de RBAC para otros usos de UC-29.
- Diseño físico de persistencia del pago en tránsito y procesamiento de rendición, migraciones versionadas.
- Pruebas de servicio: red intermitente, doble envío, respuesta perdida tras COMMIT, asignación revocada, saldos provisionales, ausencia de dobles asientos, conciliación e integridad.
- **No cerrar estos pendientes por mera aceptación de documentación.** No ejecutar migraciones ni afirmar despliegue.

## Criterio y dictamen de cierre

**CERRADO:** definición funcional acotada F04 y aprobaciones RD-F04-001..007.  
**DOCUMENTADO COMO PROPUESTA:** contrato técnico de sincronización S-01.  
**NO IMPLEMENTADO / NO PROBADO:** servicio offline, persistencia de pago en tránsito y su conexión transaccional con Cuenta Corriente y Caja.

### Referencias

- [RD-F04-001](../01-gobierno/RD_F04_001_ALCANCE_OFFLINE_2026-10-26.md)
- [RD-F04-002](../01-gobierno/RD_F04_002_RENDICION_EFECTIVO_2026-10-26.md)
- [RD-F04-003](../01-gobierno/RD_F04_003_PAGO_EN_TRANSITO_SALDO_PROVISIONAL_2026-10-26.md)
- [RD-F04-004](../01-gobierno/RD_F04_004_DECLARACION_EFECTIVO_UC05_2026-10-26.md)
- [RD-F04-005](../01-gobierno/RD_F04_005_DIFERENCIA_PAGO_EN_TRANSITO_2026-10-26.md)
- [RD-F04-006](../01-gobierno/RD_F04_006_EVALUACION_DEUDA_NUEVOS_PEDIDOS_2026-10-26.md)
- [RD-F04-007](../01-gobierno/RD_F04_007_AJUSTE_EN_MORA_PAGO_TRANSITO_2026-10-26.md)
- [Contrato S-01, borrador no aprobado](F04_CONTRATO_S01_SINCRONIZACION_BORRADOR_2026-10-26.md)
- [PR #5](https://github.com/leandrito369/ale-milanesas/pull/5) · [Issue #6](https://github.com/leandrito369/ale-milanesas/issues/6)
