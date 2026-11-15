# RD-I302-004 — DC05-01/02-A: reserva anticipada por Pedido y consolidación al entregar

**Fecha:** 15/11/2026.  
**Estado funcional:** **DC05-01/02-A APROBADA por decisión expresa del responsable (15/11/2026)**.  
**Estado documental:** **ASIENTO PROPUESTO / PR DRAFT / SIN AUTORIZACIÓN DE IMPLEMENTACIÓN**.  
**Gobierno main de referencia:** `cdd57ed194268f1f5ab29aa0f55781ddddebdfb5`.  
**Aplicación main de referencia:** `4dbe38668fc5cbc08d04e10920e3bf165c71be11`.  
**Fuentes de trabajo:** PR #53 R08.4 @ `7448e123c3c43c51d48def6a22d10b58679efb2d` (anexo IMP-01 §17, DC05-01..12); PR #54 R08.5-C @ `cc948fcde1ac2dbfe0a78febff6fd2326b8de258` (§10.2 y P0); PR #55 RD-I302-003, DC05-04-B @ `9aa8a48ca936dcc9244fcb4da2de6d6262d276ed`; PR #44/#50/#51/#52; RD-F04-002..007, RD-F01, REV04B/REV05, RBAC G0 y CR-B0-F04-001.

## 1. Decisión funcional expresa

**DC05-01/02-A — APROBADA FUNCIONALMENTE:**

> Un anticipo procedente de un **Cobro confirmado**, asociado expresamente a un **Pedido determinado**, se puede **reservar para ese Pedido antes de la entrega**. Durante la reserva, su porción monetaria está comprometida y **se excluye de los créditos libres susceptibles de asignación FIFO a otras deudas**. Cuando el servidor confirma `UC-05 Registrar Entrega`, **solo la porción de reserva válidamente atribuible a la obligación realmente entregada se consolida como imputación efectiva `P_e`**. La reserva por sí sola no equivale a `P_e` consolidado ni a un cargo de entrega ya existente.

**Objeto de referencia anterior a la entrega:** el **Pedido**.  
**Objeto de consolidación posterior:** la **obligación económica de la entrega validada** de ese Pedido. Su identificador físico y cardinalidad quedan para Arquitectura/CR.

**Convergencia con decisiones vigentes:**
- **D5-B:** la declaración de efectivo del Repartidor se imputa **solo a esa Entrega**, no a otras deudas.
- **ANT-01:** los anticipos confirmados y efectivamente imputados a esa obligación reducen el pendiente elegible al entregar.
- **DC05-04-B:** la evaluación de mora respeta primero aplicaciones explícitas confirmadas y asigna créditos **libres** por FIFO; las reservas previas comprometidas **no** integran el pozo libre.
- **D6-1:** rendición únicamente ADMINISTRADOR; no es una operación de reserva.
- **D7-A:** bloqueo temporal de anulación de Cobros vinculados a rendición; no autoriza por sí sola el tratamiento de anulación de Cobros generales con reserva (`DC05-07`).

## 2. Separación del ciclo de vida y de la contabilidad

| Fase conceptual | Evidencia requerida | Efecto autorizado por esta decisión | Sin inferir |
|---|---|---|---|
| **Cobro confirmado** | Cobro real y asiento único Cuenta/Caja | Efecto contable global vigente del Cobro confirmado según F01 | La referencia `COBRO.idPedido` **no** constituye una aplicación monetaria |
| **Reserva previa** | Evento verificable por porción de Cobro, Pedido destino, importe, instante, causa e identidad idempotente | Compromete exclusivamente esa porción para el Pedido; queda **fuera de FIFO libre** | No crear otro COBRO/PAGO/CAJA, no inventar `ENTREGA` ni `C_e`, no computar reserva como `P_e` consolidado |
| **Confirmación UC-05** | Entrega aceptada por servidor, cargo real `C_e` y estado de reserva actual validados bajo protocolo concurrente | Consolida como `P_e` **la porción elegible** de reserva vinculada a esa entrega; restante sin consolidar exige tratamiento explícito posterior | No aplicar a deuda vieja, otro Pedido ni cargo no entregado |
| **Remanente / cancelación / anulación** | Evento y autorización adecuados | El crédito conserva contabilidad y trazabilidad hasta regla de liberación o compensación ratificada | No definir aquí destino automático ni permisos de corrección, cancelación y anulación |

**Regla monetaria:** la suma de porciones reservadas activas, porciones consolidadas e importes disponibles **no puede superar el Cobro confirmado neto elegible** en la política correspondiente; una misma porción nunca puede estar simultáneamente reservada, consolidada y libre. La forma de reconciliar otros movimientos de cuenta (`AJUSTE_CREDITO`, `ANULACION_COBRO`, etc.) sigue pendiente de contrato técnico y comercial.

**Temporalidad:** la reserva anterior a UC-05 se toma en cuenta para no asignar el crédito a otra deuda bajo FIFO, aun cuando no haya cargo de entrega confirmado. Eso no crea un cargo de venta anticipado ni implica recategorizar al Cliente por efectivo en tránsito. Mantener RD-F04-007 y política de mora existentes; la semántica completa de reserva frente a obligaciones vencidas y saldos generales deberá probarse.

**Sin selección física:** no se aprobó `IMP-A`, `IMP-B`, `IMP-C` como esquema, tabla, evento SQL o contrato de API. La opción IMP-B append-only + proyección IMP-A es recomendación de R08.5-C **todavía por decidir en DC05-09**.

## 3. Ejemplos ilustrativos (NO pruebas ejecutadas)

**Caso 1 — Entrega completa:** Cobro confirmado de $8.000, reserva explícita de $8.000 para Pedido B. Antes de entregar: $8.000 comprometidos, $0 de ese Cobro libre para FIFO, `P_e` aún no consolidado. Si al confirmar UC-05 el cargo válido atribuible a la Entrega B admite esos $8.000 según el contrato futuro, pasan a `P_e`; no se crea un segundo Cobro ni un segundo ingreso de Caja.

**Caso 2 — Entrega parcial:** reserva $8.000 para Pedido B; cargo real de lo efectivamente entregado $5.000. La reserva **no autoriza** consolidar $8.000. El destino de la porción no elegible $3.000 (liberación a saldo libre, retención o reasignación expresamente autorizada) permanece pendiente de `DC05-05/06/08`. No asignarla por inferencia.

**Caso 3 — Deuda anterior:** Cliente debe $10.000 del Pedido A. Confirma Cobro de $8.000 y lo reserva explícitamente para B. La reserva de B se excluye de los $8.000 de créditos libres FIFO, de acuerdo con `DC05-04-B`; no cancela A. El criterio de mora de A debe calcularse sobre importes confirmados e imputaciones vigentes, sin reconocer ninguna declaración de reparto sin rendición.

## 4. Controles a diseñar y escenarios futuros

- **Resguardo de unicidad por porción:** una reserva activa identifica Cobro confirmado, Pedido, importe y versión de eventos; prohibir consumo doble o remanente negativo.
- **Precondiciones:** Cobro `CONFIRMADO`, Pedido destino perteneciente al mismo Cliente, existencia y estado elegibles; no inferir reserva de `COBRO.idPedido` ni de FIFO.
- **Serialización:** coordinar `UC-29`, `UC-05`, anulación, liberación y `UC-15` con locks ordenados; evitar `40P01` y lecturas `P_e` obsoletas. R/P C3 no acredita la secuencia definitiva.
- **Idempotencia:** reenvío idéntico sin duplicar reserva/consolidación; mismo UUID con distinto contenido rechaza sin efecto; sin modificación retrospectiva de `D_e`.
- **Autorización:** no derivar derechos para crear, corregir, liberar o consultar reservas del hecho de que el actor pueda registrar Cobro manual; `DC05-03` y G0/RBAC siguen pendientes.
- **Reversión / cancelación:** destino del remanente tras `UC-06`, anulación de Cobros generales con reserva y resolución de exceso siguen sujetos a `DC05-05/06/07/08`.
- **Pruebas por implementar:** `IMP-T04`/`IMP-T05` (pre-entrega), `IMP-T10` (concurrencia), `IMP-T15` (deuda anterior vs reserva explícita), `IMP-T07` (cancelación), `IMP-T08`/`IMP-T19`/`IMP-T20` (anulación concurrente), y entrega parcial con reserva mayor al cargo.

## 5. Estado de decisiones y siguiente paso P0

| ID | Estado | Alcance |
|---|---|---|
| **DC05-01/02-A** | **APROBADA FUNCIONALMENTE 15/11** | Reserva por Pedido antes de entrega; excluir de FIFO libre; consolidar porción válida al aceptar UC-05 |
| **DC05-04-B** | **APROBADA FUNCIONALMENTE 15/11**, PR #55 | Imputaciones explícitas al evaluar mora; FIFO para créditos libres |
| D5-B, ANT-01, D6-1, D7-A | APROBADAS FUNCIONALMENTE 15/11 | Se preservan, sin reabrir |
| **DC05-03** | **PENDIENTE** | Roles habilitados para crear, corregir y liberar reservas |
| **DC05-05/06** | **PENDIENTE** | Remanentes y liberación por cancelación `UC-06` |
| **DC05-07** | **PENDIENTE** | Anulación de Cobro general con reserva/aplicación, distinta de D7-A |
| **DC05-09** | **PENDIENTE** | Elección de evidencia canónica IMP-A/IMP-B/IMP-C |
| **D12** | **PENDIENTE** | Autorización CR online `PE-1 + PE-2 + IMP-01` y reserva `PE-3` |
| DC05-08/10/11/12, DC-01..08, D9, D10, E-01..07 | PENDIENTES / DEPENDIENTES | Parciales, concurrencia, modelo, cálculo, conciliación de contratos |

**Dictamen:** DC05-01/02-A queda registrada como decisión funcional. **No se autoriza** crear o modificar esquema `IMP-01`, eventos append-only, tablas, Flyway, `EvaluadorCategoriaComercialInterno`, `CobroManualService`, controlador, permisos, G0, desplegar ni mergear PR. La aplicación de `E-01..E-07` requiere conciliación contractual posterior.
