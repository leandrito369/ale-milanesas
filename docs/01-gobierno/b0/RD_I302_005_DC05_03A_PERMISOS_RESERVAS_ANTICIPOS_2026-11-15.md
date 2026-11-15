# RD-I302-005 — DC05-03-A: permisos de creación y corrección/liberación de reservas de anticipo

**Fecha:** 15/11/2026.  
**Decisión funcional expresa:** **DC05-03-A APROBADA** por el responsable.  
**Estado de documento:** **ASIENTO PROPUESTO / PR DRAFT / NO RATIFICA G0 / SIN AUTORIZACIÓN DE IMPLEMENTACIÓN**.  
**Gobierno main base:** `cdd57ed194268f1f5ab29aa0f55781ddddebdfb5`. **Aplicación main base:** `4dbe38668fc5cbc08d04e10920e3bf165c71be11`.  
**Fuentes:** PR #53 (R08.4 §17, HEAD `7448e123c3c43c51d48def6a22d10b58679efb2d`); PR #54 (R08.5-C §10.5, HEAD `cc948fcde1ac2dbfe0a78febff6fd2326b8de258`); PR #55 (DC05-04-B, HEAD `9aa8a48ca936dcc9244fcb4da2de6d6262d276ed`); PR #56 (DC05-01/02-A, HEAD `3047e1a327c5447cae3a6538a2712d29a303f4ff`); contratos REV05 UC-29, RD-F01, RD-F04, RD-RP007-001, matriz RBAC G0; PR #44/#50/#51/#52.  

## 1. Decisión funcional aprobada

**DC05-03-A — APROBADA (15/11/2026):**

> **ADMINISTRADOR y VENDEDOR** pueden **crear una reserva de anticipo al registrar un Cobro manual autorizado**. **Solo ADMINISTRADOR** puede **corregirla o liberarla excepcionalmente**. Estas facultades requieren un **contrato explícito y autorización objeto/operación en RBAC/G0**, no se heredan implícitamente del permiso general de UC-29.

**No aprobada:** DC05-03-B (todas las acciones exclusivamente ADMINISTRADOR).

**Límite:** esta elección trata las **reservas voluntarias de anticipos registrados manualmente**, no asigna al VENDEDOR rendición de Repartidor (**D6-1**, exclusivamente ADMINISTRADOR), no le otorga anulación general de Cobros (permanece ADMINISTRADOR según REV05/RD-B0-BC03), ni da a REPARTIDOR, CLIENTE o canal ONLINE facultades adicionales de reserva o corrección.

## 2. Matriz de autorización funcional (contrato candidato; NO RBAC físico vigente)

| Actor | Crear reserva junto a Cobro manual autorizado | Corregir o liberar excepcionalmente una reserva | Rendir efectivo de Repartidor | Anular Cobro manual general |
|---|---|---|---|---|
| ADMINISTRADOR | **APROBADO FUNCIONALMENTE** | **APROBADO FUNCIONALMENTE** | Solo ADMINISTRADOR (D6-1 vigente) | Solo ADMINISTRADOR conforme REV05 |
| VENDEDOR | **APROBADO FUNCIONALMENTE** | **NO AUTORIZADO** | **NO AUTORIZADO** | **NO AUTORIZADO** |
| REPARTIDOR | **NO AUTORIZADO** | **NO AUTORIZADO** | Declara en UC-05; no rinde mediante UC-29 | **NO AUTORIZADO** |
| Otros roles/canales | **SIN CONCESIÓN** | **SIN CONCESIÓN** | Sin modificación de RBAC | Sin modificación de RBAC |

**Consulta de reservas:** la aprobación de creación **no** autoriza automáticamente una nueva consulta transversal ni proyectar Cobros ajenos. La visibilidad estrictamente necesaria para el acto de alta, corrección y liberación debe definirse **por campo y objeto** mediante contrato/BC-07/D9 y autorización pertinente; la elección DC05-03-A no habilita UC-14 al ADMINISTRADOR.

**Alcance de la reserva:** vinculada a **una porción monetaria de Cobro CONFIRMADO**, **Pedido del mismo Cliente** y reserva explícita (DC05-01/02-A). El simple `COBRO.idPedido` no acredita reserva o aplicación válida.

## 3. Eventos y resultados esperados (semántica, no endpoints)

1. **Alta de Cobro manual general:** ADMINISTRADOR/VENDEDOR puede registrar el Cobro con sus controles actuales. La reserva es **opcional y expresamente identificada**; registrar el Cobro general **sin** reserva debe seguir admitido, sin inferir aplicación a partir de `COBRO.idPedido`.
2. **Alta con reserva:** comprobar actor, Cliente/Pedido y Cobro confirmado, importe positivo y porción disponible, identidad idempotente y ausencia de doble consumo. Emitir evidencia explícita de reserva ligada al Cobro y Pedido; el Cobro/Cuenta/Caja se contabiliza **una sola vez**.
3. **Corrección excepcional:** solo ADMINISTRADOR, motivo y evidencia antes/después. No editar ni borrar historial. Cualquier reducción, reasignación o cambio de destino necesita control de disponibilidad, versión, integridad y permisos.
4. **Liberación excepcional:** solo ADMINISTRADOR y con motivo verificable, preservando relación causal con Cobro/Reserva. **No** se decide aquí el destino comercial del saldo liberado ni cuándo corresponde liberación automática por UC-06: quedan para **DC05-05/06**.
5. **Confirmación UC-05:** solo la reserva elegible se consolida al cargo efectivamente entregado y contribuye al futuro `P_e`; no exige al VENDEDOR ejecutar UC-05 ni concede nuevos permisos de REPARTIDOR.
6. **Anulación de Cobro con reserva:** prohibido inferir de DC05-03-A una invalidación automática. Requiere decisión **DC05-07**, diferenciada de **D7-A** para Cobros ligados a rendición.

## 4. Controles de gobierno y dependencias de arquitectura

- **G0/RBAC:** construir la matriz operación–actor–objeto–campo y verificar si crear/corregir/liberar reservas caben como suboperaciones autorizables de UC-29 o requieren CR de catálogo/G0. **No** crear nuevas operaciones, endpoints ni permisos por interpretación.
- **REV05/E-04/E-05:** reconciliar la firma y pre/postcondiciones de `registrarCobro` y la anulación de `anularCobroManual`, incluyendo identidad idempotente y vínculo explícito Cobro→Reserva.
- **IMP-01/DC05-09:** la recomendación técnica IMP-B append-only + proyección IMP-A continúa **no ratificada**; esta decisión solo requiere historia verificable y segregación de facultades.
- **C3/DC05-10:** bloqueo transaccional coherente entre Cobro, Pedido, reserva, anulación y UC-05; los intercalados C3 R/P no demuestran todos los casos finales.
- **RD-F04-007/DC05-04-B:** reserva de Cobro confirmado comprometida por Pedido se excluye de FIFO libre; no equiparar con efectivo en tránsito del REPARTIDOR para recategorización comercial.
- **D2/B, D5-B, ANT-01, D6-1, D7-A, DC05-01/02-A, DC05-04-B** se preservan íntegros.

### Pruebas a diseñar, NO ejecutadas

| ID | Escenario | Resultado esperado |
|---|---|---|
| PER-01 | ADMINISTRADOR crea reserva al registrar Cobro manual | Permitido con evidencia, sin doble Cobro/Cuenta/Caja |
| PER-02 | VENDEDOR crea reserva al registrar Cobro manual | Permitido sin facultad de corrección |
| PER-03 | VENDEDOR intenta corregir o liberar reserva | Rechazo en servidor sin efectos |
| PER-04 | ADMINISTRADOR corrige o libera excepcionalmente | Solo con motivo, identidad idempotente, historia íntegra |
| PER-05 | REPARTIDOR, CLIENTE u otro rol intenta crear/corregir reserva | Rechazo y sin divulgación de datos |
| PER-06 | Se registra Cobro con `idPedido` sin reserva explícita | No se crea reserva ni P_e implícito |
| PER-07 | Dos altas concurrentes consumen misma porción | No sobreaplicar, serializar o rechazar |
| PER-08 | Alta de Cobro general sin reserva | Continúa funcionando conforme REV05/F01 |
| PER-09 | VENDEDOR intenta rendición o anular Cobro manual | Rechazo conforme a D6-1 y REV05 |
| PER-10 | ADMINISTRADOR libera excepcionalmente y UC-05 confirma en paralelo | Resultado serializable sin duplicación ni P_e obsoleto |

## 5. Estado P0 después de DC05-03-A

| Decisión | Estado |
|---|---|
| **DC05-03-A** | **APROBADA FUNCIONALMENTE**, pendiente conciliación contractual/RBAC y diseño |
| **DC05-01/02-A** | APROBADA FUNCIONALMENTE (PR #56) |
| **DC05-04-B** | APROBADA FUNCIONALMENTE (PR #55) |
| **DC05-05/06** | **PENDIENTE** — remanentes y cancelación UC-06 |
| **DC05-07** | **PENDIENTE** — anulación Cobro general con reserva/aplicación |
| **DC05-09** | **PENDIENTE** — modelo IMP-01 |
| **D12** | **PENDIENTE** — alcance CR online PE-1/PE-2/IMP-01 y offline PE-3 |
| **DC05-08/10/11/12, DC-01..08, D9/D10 y E-01..07** | PENDIENTES / DEPENDIENTES |

**Dictamen:** la aprobación funcional de permisos no ratifica nuevas filas RBAC ni cambia `registrarCobro`, `anularCobroManual`, modelos, SQL, G0, Flyway, seguridad HTTP, tests, despliegue o los documentos canónicos. Antes de implementar se exige conciliación y aprobación expresa de contratos y RBAC, más CR física.
