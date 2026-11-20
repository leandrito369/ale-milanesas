# RD-I302-007 — DC05-07-A: bloqueo de anulación manual con reservas o imputaciones activas

**Fecha:** 15/11/2026.  
**Estado funcional:** **DC05-07-A APROBADA EXPRESAMENTE POR EL RESPONSABLE**.  
**Estado de este asiento:** **PR DRAFT / DOCUMENTAL / SIN AUTORIZAR CAMBIOS FÍSICOS NI IMPLEMENTACIÓN**.  
**Gobierno main de referencia:** `cdd57ed194268f1f5ab29aa0f55781ddddebdfb5`. **App main de referencia:** `4dbe38668fc5cbc08d04e10920e3bf165c71be11`.  
**Fuentes:** R08.4 PR #53 @ `7448e123c3c43c51d48def6a22d10b58679efb2d` §17 IMP-01; R08.5-C PR #54 @ `cc948fcde1ac2dbfe0a78febff6fd2326b8de258` §10.5 P0; decisiones funcionales PR #55 (`DC05-04-B`), PR #56 (`DC05-01/02-A`), PR #57 (`DC05-03-A`), PR #58 (`DC05-05/06-A`); RD-F01, REV05 UC-29 §3, RD-RP007-001, RD-F04-002..007, D7-A PR #50/#51, `CobroManualService` y `fn_mr3_anular_cobro_manual` Flyway V1.  
**Contrato y RBAC canónicos:** NO modificados por esta decisión.

## 1. Decisión funcional expresa

**DC05-07-A — APROBADA (15/11/2026):**

> **Bloquear en servidor la anulación de un Cobro manual general cuando tenga reservas o imputaciones monetarias activas** hasta que dichas relaciones hayan sido **liberadas válidamente o contraaplicadas por un mecanismo expresamente autorizado**. Los Cobros manuales generales **sin vínculos activos** conservan el comportamiento de anulación de `UC-29`, sujeto a F01 y a sus precondiciones vigentes. Los Cobros vinculados a **rendición de efectivo** siguen sujetos a su bloqueo temporal **D7-A**, distinto e independiente de DC05-07-A.

**No ratificado:** DC05-07-B (invalidación y contraaplicación automática de todas las reservas/aplicaciones dentro de la anulación). La aprobación de DC05-07-A **no** constituye aprobación de D7-B (contraaplicación de Cobros de rendición).

**Distinción imprescindible:** la mera existencia **histórica** de una reserva liberada o aplicación previamente contraaplicada NO debe equivaler a vínculo **activo** y bloquear indefinidamente un Cobro general; la elegibilidad depende del **estado vigente reconstruido con evidencia canónica**, no de la presencia pasada de filas o de `COBRO.idPedido`.

## 2. Matriz de comportamiento obligatorio

| Estado al intentar `anularCobroManual` | Comportamiento funcional | Efecto financiero autorizado |
|---|---|---|
| Cobro manual general `CONFIRMADO` sin reservas/aplicaciones activas ni vínculo con rendición | Preservar la anulación manual ordinaria y sus controles existentes | F01: `ANULADO` + contraasientos de Cuenta/Caja y reevaluación UC-15, cuando proceda |
| Reserva **activa** sobre Pedido PENDIENTE | **Rechazar anulación** hasta liberación válida; la liberación excepcional requiere ADMINISTRADOR por DC05-03-A | Ningún contraasiento ni mutación de Cobro/Reserva durante el rechazo |
| Imputación **consolidada activa** a una entrega | **Rechazar anulación** hasta mecanismo de contraaplicación autorizado, ejecutado y verificado | No revertir un Cobro cuya porción todavía respalda obligación satisfecha; no inventar reversión de `P_e` |
| Reservas ya liberadas y sin imputaciones activas | No bloquear solo por registros históricos; evaluar resto de precondiciones | Mantener historia íntegra y comportamiento de anulación general |
| Cobro vinculado a rendición `D6-1` | Aplicar **D7-A** aunque no tenga reserva de anticipo; independiente de DC05-07-A | Rechazar sin alterar `COBRO`, Cuenta, Caja ni tránsito |
| Cobro `ONLINE`, ya `ANULADO` o actor no autorizado | Preservar excepciones/roles del contrato existente | No conceder nuevas anulaciones |

**Liberación automática de `UC-06` (DC05-05/06-A):** cuando la cancelación está confirmada y efectivamente liberó las reservas, esos vínculos dejan de estar activos. Un reintento de anulación de un Cobro manual general sin otras relaciones activas podrá continuar según F01/REV05. **No** usar la cancelación como autorización para contraaplicar una imputación ya consolidada: UC-06 no cancela un Pedido `ENTREGADO`.

**Separación de permisos:** solo ADMINISTRADOR ejecuta anulación manual general conforme REV05/RD-B0-BC03; VENDEDOR mantiene alta general y facultad de crear reserva conforme DC05-03-A, pero no adquiere por ello permisos de anulación ni liberación excepcional. Liberación automática como efecto interno de UC-06 conserva el actor de UC-06 sin concederle una operación excepcional independiente.

## 3. Protocolo transaccional exigible al diseño futuro

1. Validar actor ADMINISTRADOR, Cobro manual general `CONFIRMADO`, motivo y demás requisitos de REV05/F01. No modificar otros canales de Cobro.
2. Tomar locks y coordinar con el protocolo **global C3 pendiente DC05-10/DC-10**, evitando carreras con alta/liberación de reserva, `UC-05` (consolidación), `UC-06` (liberación), reevaluación de mora y rendición `D6-1`.
3. Consultar el **vínculo monetario activo** desde el futuro mecanismo canónico IMP-01, con revalidación de versión/estado dentro de la misma unidad de transacción, y verificar por separado vínculo con rendición sujeto a D7-A.
4. Si hay reserva o imputación activa, o vínculo de rendición, **rechazar antes de emitir contraasientos, cambiar estado o alterar proyecciones**. Rechazo atómico, sin liberación implícita y sin modificar categoría.
5. Solo si no hay vínculo activo de ambos tipos, ejecutar el circuito manual ya autorizado: contraasientos y categoría comercial conforme a RD-F01/REV05, sin duplicar Caja ni Cuenta en retries.
6. Al liberar reserva o ejecutar una futura contraaplicación autorizada, persistir evidencia causal/histórica inmutable; el siguiente intento de anulación revalida las relaciones y no interpreta eventos pasados como activos.
7. La implementación de protección debe revisarse tanto en **`CobroManualService.anularCobroManual`** como en el punto de escritura SQL **`fn_mr3_anular_cobro_manual`**; no depender únicamente de una validación de interfaz o consulta previa sin lock.

**Riesgo ya identificado (NO resultado de prueba de este corte):** el servicio y función SQL actuales siguen una secuencia que incluye `COBRO FOR UPDATE → CLIENTE FOR UPDATE` bajo advisory `2929001`. La futura reserva/UC-05 podría usar distinto orden y producir `40P01`. No elegir orden definitivo sin campaña C3 ampliada; PR app #91 también modifica `CobroManualService` en draft, por lo que deberá integrarse esa dependencia antes de implementación.

## 4. Ejemplos ilustrativos, sin pruebas de runtime

- **A1:** ADMINISTRADOR intenta anular Cobro confirmado de $10.000 que tiene $4.000 reservados a Pedido B. Resultado: bloqueo DC05-07-A, sin `ANULACION_COBRO` ni `EGRESO` de Caja.
- **A2:** ADMINISTRADOR libera excepcionalmente con motivo la única reserva activa; el libro mantiene el evento histórico de reserva y el de liberación. Un intento posterior de anulación puede proceder si no existe otra aplicación, vínculo de rendición u otro impedimento.
- **A3:** Cobro de $10.000 con $5.000 consolidados en `P_e` tras confirmar UC-05. No alcanza liberar un remanente: la porción consolidada bloquea la anulación hasta contraaplicación **aprobada en otro corte**.
- **A4:** `UC-06` cancela Pedido PENDIENTE y libera automáticamente reservas válidas. Cobro sigue `CONFIRMADO`; no se alteró Caja ni se anuló el Cobro. Si luego se solicita anulación, evaluar el estado activo actual, no el evento histórico.
- **A5:** `UC-05` consolida reserva concurrentemente con anulación. El diseño deberá serializar los comandos: no permitir consolidación sobre Cobro ya anulado ni anulación que omita una consolidación recién confirmada.
- **A6:** Cobro ligado a rendición pero sin reservas: bloqueo por **D7-A**; no usar reglas DC05-07-A para habilitar indebidamente su anulación.

## 5. Matriz de pruebas obligatorias futuras (NO EJECUTADAS)

| ID | Escenario | Criterio de aceptación |
|---|---|---|
| ANU-01 | Cobro general confirmado sin vínculos activos | Anulación actual según F01, contraasientos una sola vez y reevaluación categoría |
| ANU-02 | Cobro general con reserva activa | Rechazo transaccional; `COBRO`/Cuenta/Caja y reserva sin mutaciones |
| ANU-03 | Cobro con reserva liberada y sin otros vínculos | Anulación permitida si las precondiciones generales se cumplen |
| ANU-04 | Cobro con aplicación consolidada | Rechazo hasta contraaplicación ratificada; no liberar `P_e` implícitamente |
| ANU-05 | Cobro con reserva y aplicación parcial | Bloqueo mientras alguna porción activa subsista |
| ANU-06 | Cobro ligado a rendición `D6-1` | Rechazo D7-A independiente, sin contraasientos |
| ANU-07 | VENDEDOR intenta anular, o intenta liberar reserva excepcionalmente | `403`/rechazo según contrato, ningún efecto |
| ANU-08 | `UC-06` libera automáticamente reservas antes de anulación | Sin vínculo activo, no bloquear solo por historial |
| ANU-09 | UC-05 y anulación simultáneas | Sin `P_e` de Cobro ANULADO, sin deadlock ni TOCTOU |
| ANU-10 | Liberación excepcional y anulación simultáneas | Operaciones serializadas, nunca doble utilización |
| ANU-11 | Reintento de anulación tras fallo de respuesta | Idempotencia conforme futura resolución `C-04/DEC-UC29-ANUL`, sin duplicar asientos |
| ANU-12 | `COBRO.idPedido` informado pero sin evento de reserva/aplicación | No bloquear por inferencia; conservar demás controles |
| ANU-13 | Pago ONLINE / Cobro ya ANULADO | Mantener excepciones actuales |
| ANU-14 | Cliente con dos Pedidos y aplicaciones independientes | No liberar ni invalidar vínculos de otro Cobro o Pedido |
| ANU-15 | PR app #91 integrada/rebasada conceptualmente con nuevo protocolo | Verificar bloqueo transaccional compatible con identificadores financieros compartidos y sin perder regresiones B1 |

## 6. Estado P0 y gates pendientes

| Decisión | Estado y alcance |
|---|---|
| **DC05-07-A** | **APROBADA FUNCIONALMENTE 15/11**; guardia de anulación manual con vínculos activos, sin contraaplicación implícita |
| DC05-01/02-A, DC05-03-A, DC05-04-B, DC05-05/06-A | APROBADAS FUNCIONALMENTE en PR #56/#57/#55/#58 |
| D5-B, ANT-01, D6-1, D7-A | APROBADAS FUNCIONALMENTE y conservadas |
| **DC05-09** | **PENDIENTE** — elegir mecanismo de evidencia IMP-A/IMP-B/IMP-C |
| **D12** | **PENDIENTE** — alcance online PE-1/PE-2/IMP-01 frente offline PE-3 |
| DC05-08/10/11/12, DC-01..08, DEC-GRAN-D6, D9/D10, E-01..07, `C-04`, `D7-B` | PENDIENTES / DIFERIDOS por alcance |

**Dictamen:** DC05-07-A es decisión **funcional y específica** sobre guardia de anulación. No crea operación nueva, no aprueba D7-B ni DC05-07-B, no ratifica IMP-B, no cambia `REV05`, `RD-I302-001`, RBAC, G0, Java, SQL, V1–V3, Testcontainers, despliegue ni permite merge automático. Antes de implementar: conciliar contrato UC-29, decidir IMP-01/DC05-09, diseñar control transaccional y autorizar CR física.
