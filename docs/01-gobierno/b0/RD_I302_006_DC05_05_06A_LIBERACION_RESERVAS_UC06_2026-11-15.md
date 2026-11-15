# RD-I302-006 — DC05-05/06-A: liberación automática de reservas al cancelar Pedido (UC-06)

**Fecha:** 15/11/2026.  
**Decisión funcional:** **DC05-05/06-A APROBADA EXPRESAMENTE POR EL RESPONSABLE**.  
**Estado de este documento:** ASIENTO PROPUESTO — **PR DRAFT / NO MERGE / SIN AUTORIZACIÓN FÍSICA NI DE IMPLEMENTACIÓN**.  
**Gobierno main de referencia:** `cdd57ed194268f1f5ab29aa0f55781ddddebdfb5`; **app main de referencia:** `4dbe38668fc5cbc08d04e10920e3bf165c71be11`.  
**Fuentes contrastadas:** REV04B contrato UC-06 §3 (Pedido PENDIENTE, Cancelación, saldo a favor de Cobro manual y extensión UC-26 para Cobro electrónico); RD-I302-004 PR #56 DC05-01/02-A @ `3047e1a327c5447cae3a6538a2712d29a303f4ff`; RD-I302-005 PR #57 DC05-03-A @ `bffb510658bb7d0916426165a714446a9fb59812`; RD-I302-003 PR #55 DC05-04-B @ `9aa8a48ca936dcc9244fcb4da2de6d6262d276ed`; R08.4 PR #53 §17; R08.5-C PR #54 §10.5; RD-F01/F04; REV05; RBAC G0; CR-B0-F04-001.

## 1. Asiento de la decisión aprobada

**DC05-05/06-A — APROBADA FUNCIONALMENTE (15/11/2026):**

> Cuando `UC-06` confirma válidamente la **cancelación de un Pedido**, el sistema **libera automáticamente todas las porciones todavía reservadas para ese Pedido que sean elegibles para liberación**, preservando evidencia histórica. Los importes liberados de Cobros manuales **confirmados y no reembolsados** pasan a ser crédito **libre, no imputado** del mismo Cliente, sometido a las reglas FIFO que correspondan. La liberación **no duplica `COBRO`, `MOVIMIENTO_CUENTA(PAGO)` ni `MOVIMIENTO_CAJA`**, no altera retroactivamente el Cobro y **no realiza una reasignación explícita automática** a ningún otro Pedido.

**No se elige** DC05-05/06-B (liberación de reservas retenida hasta intervención administrativa) para la cancelación ordinaria válida.

**Diferencia crítica:** al regresar a crédito libre, ese dinero **sí puede consumirse mediante el mecanismo general FIFO** al evaluar obligaciones y mora según DC05-04-B. Esto **no** constituye una nueva imputación **explícita** a otro Pedido. Ningún actor autoriza implícitamente una reserva nueva para otro Pedido.

## 2. Integración estricta con contratos existentes

- REV04B §3: `UC-06 cancelarPedido` solo cancela Pedidos **PENDIENTES** y ya establece que un Cobro manual previo permanece como saldo a favor en Cuenta Corriente sin salida automática de Caja. Esta decisión precisa la liberación de la porción reservada; **no** modifica reglas de producción, inventario, Excedente, motivo o asignación vigente.
- DC05-01/02-A (PR #56): reserva previa vinculada al **Pedido**, excluida del FIFO libre. El evento de liberación retira su compromiso; una reserva liberada **no** se consolida después como `P_e` en una Entrega.
- DC05-04-B (PR #55): asignaciones monetarias explícitas vigentes se respetan primero; FIFO solo sobre créditos libres. No volver a consumir por FIFO una porción todavía reservada/consolidada.
- DC05-03-A (PR #57): solo ADMINISTRADOR corrige/libera **excepcionalmente** reservas. La liberación **automática y obligatoria como efecto del UC-06** es una regla interna del sistema, **no** concede al VENDEDOR ni al REPARTIDOR permiso nuevo de liberación excepcional. Actores de cancelación mantienen exactamente el RBAC/alcance contextual ratificados de UC-06.
- D5-B, ANT-01, D6-1 y D7-A siguen vigentes; la anulación de Cobros generales con reserva/aplicación continúa **pendiente DC05-07**.
- **Cobros electrónicos y UC-26:** REV04B activa reembolso electrónico por extensión condicional. **La decisión DC05-05/06-A no autoriza** volver crédito libre un importe ya reembolsado ni generar doble disponibilidad durante un reembolso pendiente. La coordinación entre liberación, reserva y `UC-26` debe quedar cerrada contractualmente antes de incorporar anticipos electrónicos al mecanismo de reserva; en este corte se especifican las reservas procedentes de Cobros **manuales confirmados** definidas por DC05-03-A.

## 3. Máquina de estados conceptual, sin selección de esquema

| Fase | Hecho del dominio | Efecto en disponibilidades | Historial |
|---|---|---|---|
| Cobro manual CONFIRMADO, sin reserva | Único Cobro + Cuenta + Caja | Crédito libre conforme a su origen y reglas | Cobro intacto |
| Reserva explícita sobre Pedido PENDIENTE | Porción de Cobro comprometida a ese Pedido | Sale del crédito libre FIFO, **sin segundo asiento de PAGO/Caja** | Evento/versionado verificable, no `COBRO.idPedido` implícito |
| UC-06 confirma cancelación | Pedido pasa de PENDIENTE a CANCELADO; se identifican porciones aún reservadas | **Liberación automática** a crédito libre del mismo Cliente, sin reasignar explícitamente otro Pedido | Evento de liberación causal con referencia a cancelación |
| Reintento de UC-06 sobre CANCELADO | Precondición de cancelación ya no satisfecha | **Ninguna nueva liberación ni asiento** | Persistencia sin efectos adicionales, según contrato de rechazo |
| Entrega UC-05 ya confirmada | Pedido no es PENDIENTE según REV04B | No aplicar cancelación tardía ni deshacer `P_e` consolidado usando UC-06 | Se mantiene obligación/entrega registrada |

**Regla de atomicidad propuesta para autorización:** la confirmación de cancelación UC-06 y la liberación de reservas vigentes que le corresponde se persisten **en una sola transacción**; si falla una parte, revertir ambas sin liberar crédito ni cancelar parcialmente. El diseño físico y el orden global de locks siguen bajo C3/DC05-10.

**Regla de conservación:** por cada Cobro confirmado, el total neto elegible se particiona de forma excluyente entre porciones comprometidas/activas, consolidadas y libres, considerando compensaciones. La liberación cambia su **destino analítico**, no multiplica fondos ni modifica el saldo contable confirmado al efectuarla. Recalcular mora por las reglas de créditos libres cuando corresponda, sin considerar tránsito de efectivo UC-05 no confirmado como Cobro.

## 4. Casos ilustrativos (no son pruebas ejecutadas)

**L01 — Cancelación sin entrega:** Cobro manual confirmado por $10.000; reserva explícita de $10.000 al Pedido B, aún PENDIENTE. Al confirmarse UC-06, se libera la reserva al crédito libre del mismo Cliente; el Cobro y Caja originales se conservan; `P_B` de entrega no existe. No se crea asignación explícita al Pedido A.

**L02 — FIFO posterior:** si el Cliente también tiene deuda antigua del Pedido A y la reserva de B se libera, el dinero podrá participar en **FIFO** conforme DC05-04-B cuando se evalúe deuda/mora, sin declararlo anticipo reservado para A.

**L03 — Cancelación concurrente con alta de reserva:** el protocolo futuro debe serializar ambos comandos y rechazar la reserva cuando el Pedido ya esté CANCELADO; no permitir reserva posterior a la liberación.

**L04 — Reserva parcial y varios Cobros:** solo las porciones activas realmente reservadas al Pedido cancelado quedan liberadas; otros Pedidos del Cliente conservan sus reservas. No duplicar la liberación en replay.

**L05 — Intento de cancelar ENTREGADO:** UC-06 rechaza según REV04B. No liberar por esta ruta porciones consolidadas en `P_e` por una entrega real. El remanente de reserva tras entrega parcial corresponde a DC05-08 y no se resuelve en este asiento.

**L06 — Cobro electrónico reembolsable:** activar/revisar UC-26 según REV04B; no liberar como crédito libre un importe que ya salió o saldrá por reembolso. Definir guarda contra disponibilidad doble en conciliación contractual futura.

## 5. Matriz de pruebas futuras (NO EJECUTADAS)

| ID | Escenario | Resultado exigible al implementar |
|---|---|---|
| LIB-01 | UC-06 cancela Pedido PENDIENTE con reserva activa de Cobro manual | Liberación automática íntegra, evidencia inmutable; ningún nuevo Cobro/Caja/PAGO |
| LIB-02 | Cancelación con reservas de varios Cobros al mismo Pedido | Liberar solo porciones de ese Pedido, sin superar saldos netos |
| LIB-03 | Cliente con dos Pedidos, uno cancelado | Reserva del otro Pedido intacta, remanente libre FIFO solo desde la liberación |
| LIB-04 | Reintento, duplicación o cancelación ya confirmada | No duplicar liberación; preservar semántica de excepción UC-06 |
| LIB-05 | Error entre actualización Pedido y evento de liberación | Rollback íntegro |
| LIB-06 | VENDEDOR autorizado o REPARTIDOR con asignación vigente cancela Pedido propio | Efecto automático UC-06 sin conceder operación independiente de liberación |
| LIB-07 | VENDEDOR intenta liberar excepcionalmente una reserva | Rechazo por DC05-03-A |
| LIB-08 | Cancelación concurrente con creación de reserva | Orden coherente, sin reserva colgada en CANCELADO |
| LIB-09 | Cancelación concurrente con anulación de Cobro manual | Sin crédito fantasma, pendiente DC05-07 / C3 |
| LIB-10 | Pedido ya ENTREGADO o con `P_e` consolidado | UC-06 no lo cancela ni revierte aplicaciones |
| LIB-11 | Cobro electrónico en proceso de reembolso UC-26 | No doble disponibilidad; contrato adicional obligatorio antes de permitir reserva electrónica |
| LIB-12 | Crédito liberado y evaluación de categoría | Se incorpora al FIFO libre sin doble consumir Cobros confirmados; tránsito UC-05 no cambia categoría |

## 6. Decisiones pendientes y ruta al siguiente P0

| ID | Estado |
|---|---|
| **DC05-05/06-A** | **APROBADA FUNCIONALMENTE; asiento documental propuesto** |
| **DC05-01/02-A** | APROBADA (PR #56) |
| **DC05-03-A** | APROBADA (PR #57) |
| **DC05-04-B** | APROBADA (PR #55) |
| **DC05-07** | **PENDIENTE** — anulación de Cobro general con reserva o aplicación |
| **DC05-09** | **PENDIENTE** — elección IMP-A/IMP-B/IMP-C |
| **D12** | **PENDIENTE** — CR online PE-1/PE-2/IMP-01 frente a PE-3 offline |
| **DC05-08, DC05-10/11/12, DC-01..08, D9/D10, E-01..07** | Pendientes según dependencia |

**Dictamen:** esta decisión es funcional, no física. **No** ratifica `IMP-B`, no altera `UC-06`, `UC-15`, `UC-26`, `CobroManualService`, `EvaluadorCategoriaComercialInterno`, Flyway, G0, RBAC ni contratos canónicos. No autoriza DDL, test con esquema candidato, implementación, merge ni despliegue.
