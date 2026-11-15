# RD-I302-008 — DC05-09-A: evidencia canónica IMP-B, proyección IMP-A y contención IMP-C

**Fecha:** 15/11/2026.  
**Estado funcional/arquitectónico:** **DC05-09-A APROBADA EXPRESAMENTE POR EL RESPONSABLE**.  
**Estado documental:** **ASIENTO PROPUESTO / PR OPEN-DRAFT / NO MERGE / SIN AUTORIZACIÓN DE DDL NI IMPLEMENTACIÓN**.  
**Gobierno main de referencia:** `cdd57ed194268f1f5ab29aa0f55781ddddebdfb5`; **aplicación main de referencia:** `4dbe38668fc5cbc08d04e10920e3bf165c71be11`.  
**Referencias:** PR #53 R08.4 §17 IMP-01 @ `7448e123c3c43c51d48def6a22d10b58679efb2d`; PR #54 R08.5-C §10.1/10.5 @ `cc948fcde1ac2dbfe0a78febff6fd2326b8de258`; PR #55 DC05-04-B; PR #56 DC05-01/02-A; PR #57 DC05-03-A; PR #58 DC05-05/06-A; PR #59 DC05-07-A @ `84ea674df6f151792b628b7cd7ca6317814c3f10`; R08.3 PR #52, RD-F01/F04, REV04B/REV05, CR-B0-F04-001 y catálogo/seguridad G0.

## 1. Decisión expresa DC05-09-A

> Se adopta **IMP-B append-only como evidencia canónica e inmutable** de la historia de **reservas, consolidaciones, liberaciones, correcciones y contraaplicaciones expresamente autorizadas** por porción monetaria de Cobro y obligación. Se requiere una **proyección activa equivalente a IMP-A** para consultar y controlar las aplicaciones y reservas vigentes. **IMP-C** queda disponible **solo como mecanismo de contención ante falta de evidencia verificable**, nunca como imputación presunta ni como sustituto definitivo de IMP-01.

Esta es una **elección de patrón funcional/arquitectónico**, **no** una autorización de tablas, nombres de columnas, eventos SQL, contrato de API, nuevos permisos o migración. **IMP-A no constituye una segunda fuente canónica**: debe derivarse o mantenerse sincronizada transaccionalmente con IMP-B bajo un protocolo verificable. No se aprueba una tabla mutable de aplicaciones como única autoridad.

**Alternativas no elegidas como destino:** IMP-A con historia separada sin autoridad append-only inequívoca; IMP-C como solución definitiva.

## 2. Semántica exigida y relación con decisiones anteriores

| Concepto | Comportamiento aprobado | Restricción |
|---|---|---|
| Reserva sobre Pedido | Evidencia explícita por porción de **Cobro confirmado**, Pedido, Cliente, actor/causa y clave de idempotencia | **DC05-01/02-A**: mientras esté reservada, la porción queda fuera de FIFO libre; reserva no es `P_e` efectivo |
| Consolidación `UC-05` | Al confirmar servidor la Entrega, convertir solo la reserva elegible en imputación a la obligación efectiva | **ANT-01**: no superar el cargo real; parciales y distribución siguen **DC05-08/DC-01..04** |
| Precedencia de imputación `UC-15` | Primero las imputaciones explícitas confirmadas y vigentes; después FIFO sobre crédito confirmado **libre** | **DC05-04-B**: misma porción no puede consumirse por FIFO y por aplicación |
| Alta con reserva | ADMINISTRADOR y VENDEDOR pueden crearla junto a Cobro manual autorizado | **DC05-03-A**: requiere contrato/RBAC explícitos antes de código; no agregar operación por inferencia |
| Corrección o liberación excepcional | Solo ADMINISTRADOR, con identidad, motivo, autorización y evidencia causal | **DC05-03-A**; no editar ni borrar eventos originales |
| Cancelación `UC-06` | Liberar automáticamente reservas activas elegibles del Pedido cancelado a crédito libre del mismo Cliente | **DC05-05/06-A**: no duplica Cobro/PAGO/Caja ni implica reasignación explícita a otro Pedido; prevenir doble disponibilidad con reembolso `UC-26` |
| Anulación general `UC-29` | Rechazar si Cobro tiene reserva o imputación activa; permitir anulación ordinaria sin vínculos activos | **DC05-07-A**: liberación o contraaplicación expresa previa; no confundir historial pasado con vínculo vigente |
| Cobro de rendición `D6-1` | Guardia independiente de anulación **D7-A**, aun sin reservas de anticipo | No aprobar D7-B ni anulaciones automáticas de rendición |
| Falta de evidencia `IMP-C` | Conservar Entrega y declaración íntegra `D_e` sin adjudicar `P_e` ni generar `V_e^0` provisional por conjetura | Evitar `P_e=0` arbitrario y doble reconocimiento. Aplicabilidad operativa, recuperación y plazo para resolver quedan para contrato |
| Importe declarado por Repartidor | `D_e` se conserva íntegro, aun si es superior a lo elegible | Excedente no crea automáticamente Cobro, crédito ni Caja; D5-B/D2-B y decisiones cuantitativas pendientes |

**No duplicar contabilidad:** el libro IMP-B registra destino y cambios de porciones **analíticas** del Cobro ya confirmado. No crea un segundo `COBRO`, `MOVIMIENTO_CUENTA(PAGO)` ni `MOVIMIENTO_CAJA`. El campo `COBRO.idPedido` por sí solo **no** es evento de reserva ni aplicación.

## 3. Garantías obligatorias a concretar en R08.6 (NO DDL aprobado)

1. **Append-only real:** eventos originales no se editan ni borran; correcciones generan nuevo evento causal autenticado con instante de base de datos y referencias al hecho corregido.
2. **Proyección íntegra:** estado activo reconstruible y congruente con el libro a una versión/snapshot verificable; ninguna proyección puede producir doble disponibilidad si falla su actualización.
3. **Porciones conservadas:** sumatoria de reservas activas, aplicaciones efectivas y porciones libres (más compensaciones autorizadas) coincide con el neto realmente elegible; no sobreaplicar ni consumir una porción dos veces.
4. **Idempotencia:** reenvío con misma identidad/payload produce el mismo resultado; igual UUID con payload diferente rechaza sin efecto; definir consumo de UUID ante rechazo (`D3`) antes de código.
5. **Objeto y rol:** Cobro, Cliente, Pedido y Entrega pertenecen al mismo ámbito autorizado; no confiar en `COBRO.idPedido`, saldo global o FIFO para inventar asignación.
6. **Concurrencia:** confirmar UC-05, cancelar UC-06, registrar/anular UC-29, liberar/corregir y reevaluar UC-15 con un protocolo global C3/locks `DC05-10/DC-10`, compatible con `fn_mr3_anular_cobro_manual`; los ensayos R/P no prueban el comportamiento final.
7. **Sin lectura financiera ambigua:** los importes reservados no integran FIFO libre antes de Entrega, aun cuando todavía no constituyen `P_e`. Imputaciones consolidadas se reflejan en mora; el efectivo en tránsito de Repartidor sin Cobro definitivo no recategoriza automáticamente (`RD-F04-007`).
8. **Auditoría y privilegios:** crear/reservar, consolidar, corregir, liberar y consultar deben contar con contrato y seguridad de objeto/actor; sin concesiones silenciosas en G0/RBAC.
9. **Históricos:** Cobros anteriores sin eventos explícitos no se convierten a aplicaciones por heurística desde `COBRO.idPedido`/FIFO; `DC05-12` sigue pendiente.
10. **Consolidación y disponibilidad:** las porciones activas/comprometidas deben quedar no disponibles en caso de error intermedio; rollback completo; rechazos no crean movimientos monetarios.
11. **Rendición independiente:** el libro de IMP-01 no sustituye el diseño de `PE-1` (declaración/reconocimiento `V_e`) ni `PE-2` (Cobro/rendición/cese); D7-A protege su vínculo específico.
12. **Sin fórmula implícita:** `C_e`, `P_e`, `V_e^0`, `V_e^vig`, `Q_e`, redondeo y adicionales UC-07 siguen pendientes de ratificación; DC05-09-A no aprueba `V1 = min(D_e,max(0,C_e-P_e))`.

## 4. Evidencia de aceptación futura (NO ejecutada)

| Referencia | Escenario | Resultado exigido |
|---|---|---|
| `IMP-T01/T02` | Cobro confirmado con/sin `idPedido` pero sin evento IMP-B | No inferir reserva ni aplicación; no `P_e` artificial |
| `IMP-T03/T04/T05` | Aplicación parcial, dos Pedidos y dos Cobros | Conservación por porciones; sin doble consumo ni crédito fantasma |
| `IMP-T07` / `LIB-01..12` | Cancelación UC-06 con reservas activas | Liberación causal y atómica, sin duplicación de Cobro/Caja/PAGO |
| `IMP-T08/19/20` / `ANU-01..15` | Anulación tras reserva/liberación/consolidación concurrente | Bloqueo según DC05-07-A y D7-A; estado vigente coherente |
| `IMP-T15` | Deuda vieja de Pedido A y anticipo reservado/imputado a B | A no recibe el crédito de B mediante FIFO; mora coherente con DC05-04-B |
| `IMP-T17` | Ausencia de evidencia válida de `P_e` | Contención IMP-C: `D_e` íntegra, sin `V_e^0` |
| `IMP-T18` | Reenvío UC-05 y posterior cambio de aplicaciones | Snapshot original/resultado idempotente sin recálculo silencioso |
| `PER-01..10` | Alta VENDEDOR/ADMIN, corrección ADMIN, acceso no autorizado | Permisos expresos, rechazos sin efectos y auditoría |
| `C3-03/C3-08` | Operaciones concurrentes sobre Pedido/Cliente/Cobro/IMP-01 | Protocolo aprobado, cero inconsistencias y campaña PG real previa a cierre |

Ninguna prueba de aplicación, SQL, Testcontainers ni migración fue ejecutada por este asiento.

## 5. Límites y próximas decisiones

| ID | Estado tras DC05-09-A |
|---|---|
| **DC05-09-A** | **APROBADA FUNCIONAL/ARQUITECTÓNICAMENTE** — IMP-B canónico, IMP-A proyección, IMP-C solo contención |
| **D12** | **PENDIENTE** — separación del CR-B0-F04-001: `PE-1 + PE-2 + IMP-01` online y `PE-3` offline |
| **DC05-08** | **PENDIENTE** — reparto y remanente ante entrega parcial |
| **DC05-10/11/12** | **PENDIENTE** — concurrencia, semántica `COBRO.idPedido`, históricos |
| **DC-01..08 / D9 / D10 / DEC-GRAN-D6** | **PENDIENTES** — cálculo, diferencias, rendición y proyecciones por rol |
| **E-01..E-07** | **PENDIENTES** — paquete de enmiendas contractuales REV04B/REV05/RD-I302-001 |
| **CR-B0-F04-001** | ABIERTA — autorización física y separación PE-3 todavía bloqueadas |

**Dictamen:** DC05-09-A selecciona la **fuente de verdad conceptual**, pero **no ratifica el diseño SQL/DDL, una migración Flyway (ni su versión), esquema, eventos o tipos concretos, transiciones monetarias automáticas, G0/RBAC, endpoints, código, experimentación física o despliegue**. Preparación documental de R08.6 condicionada es admisible; **R08.6 físico y R09 implementación permanecen bloqueados**. El siguiente paso es decidir **D12** y posteriormente cerrar P1/contratos, sin reabrir DC05-09-A.
