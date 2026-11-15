# RD-I302-002 (DECISIONES FUNCIONALES D5/D6 ASENTADAS; DISEÑO TÉCNICO PENDIENTE) — UC-05

**Fecha:** 15/11/2026.  
**Estado:** **D5-B y D6-1 APROBADAS FUNCIONALMENTE por decisión expresa del responsable el 15/11/2026**. El documento mantiene estado **DRAFT / NO RATIFICACIÓN INTEGRAL DE RD-I302-001 O DISEÑO FÍSICO / NO AUTORIZA IMPLEMENTACIÓN**. Detalles operativos, D7 y permisos/proyecciones específicos aún requieren diseño y aprobación donde corresponda.  
**Objetivo temporal del Roadmap:** 12/12/2026 (hipótesis de planificación, no excepción a las puertas de gobierno).  
**Autoridad decisora:** responsable del proyecto.  
**Línea base de gobierno al redactar:** `cdd57ed194268f1f5ab29aa0f55781ddddebdfb5`.  
**Línea base de aplicación al redactar:** `4dbe38668fc5cbc08d04e10920e3bf165c71be11`.  
**Dependencias:** PR gobierno #44 (`RD-I302-001`), PR app #89 (C3-A.3 R/P), CR-C #47, CR-F #48, CR-B0-F04-001; G0 y contratos REV04B/REV05. Todas las PR citadas permanecen independientes de esta propuesta.  
**Alcance:** asentar la elección **D5-B** (efectivo de UC-05 imputable exclusivamente a la entrega del mismo Pedido; deudas anteriores por otro procedimiento) y **D6-1** (rendición administrativa como subflujo de UC-29, exclusiva del ADMINISTRADOR), delimitando detalles todavía no decididos y dependencia de **D7**. No define DDL, endpoints nuevos, roles nuevos, algoritmo definitivo de reconocimiento ni otra operación canónica.

## 1. Fuente de autoridad: reglas aprobadas que esta propuesta NO modifica

| Fuente | Restricción aprobada |
|---|---|
| RD-F04-002 | El Administrador recibe, verifica y autoriza la rendición **al terminar cada recorrido**; registra importe esperado, efectivamente recibido, diferencia y responsable; discrepancias quedan pendientes de conciliación. |
| RD-F04-003 | Solo el pago **sincronizado y validado** por servidor reduce deuda **exigible provisional**; no cambia `saldoConfirmado`, `COBRO`, `MOVIMIENTO_CUENTA` ni `MOVIMIENTO_CAJA`. |
| RD-F04-004 | El Repartidor puede declarar efectivo dentro de UC-05; no ejecuta UC-29 ni autoriza rendiciones. |
| RD-F04-005 | Si falta efectivo al rendir un tránsito ya validado, **no se reexige automáticamente** esa parte al Cliente; diferencia pendiente de conciliación, sin confirmar dinero no recibido. |
| RD-F04-006/007 | Nuevos Pedidos evalúan deuda exigible provisional; esto no recategoriza automáticamente al Cliente ni suspende recargo EN_MORA. |
| RD-F01 | `COBRO.estadoCobro` solo `CONFIRMADO` o `ANULADO`. |
| CONTRATOS_REV05 + RBAC G0 | UC-14 solo Vendedor; UC-29 manual general Administrador/Vendedor; rendición del Repartidor solo Administrador. No inventar autorización UC-14 para Administrador. |
| RD-I302-001 PR #44 | D2=B expresada, **pendiente de ratificación documental**: persistir `importeDeclarado` íntegro aun si excede importe de entrega; no imputar automáticamente exceso. PE-1/PE-2 son propuestas, no estructuras ratificadas. |

**Nota de autoridad:** `saldoExigibleProvisional = saldoConfirmado − importeEnTransitoValidadoVigente` es una **proyección aprobada**. Queda pendiente cómo se determina y mantiene el segundo término. No convertir esta expresión en una nueva columna ni promover términos físicos provisionales a contrato ratificado.

## 2. Definiciones conceptuales, NO nombres físicos aprobados

- **Declarado (D):** efectivo informado por Repartidor, persistido íntegro como evidencia de UC-05; no equivale por sí solo a deuda reconocida.
- **Validado/reconocido vigente (V):** parte de una declaración **aceptada por servidor** con efecto permitido sobre deuda exigible provisional, **atribuida exclusivamente al cargo efectivamente correspondiente a esa entrega**. La base funcional está aprobada en D5-B; el importe exacto y su implementación aún requieren definición y pruebas.
- **Rendido recibido (R):** dinero que el Administrador afirma y acredita haber recibido físicamente al finalizar recorrido; debe conservar evidencia de conteo, responsable y discrepancia.
- **Aplicado definitivamente (A):** fracción de V asociada a uno o varios COBRO confirmados de rendición, con cese proporcional del efecto provisional **en la misma transacción**.
- **Diferencia:** componente declarado/validado y no recibido o no aplicado; su destino definitivo no se deduce y queda pendiente de conciliación.

No equiparar `D`, `V`, `R` y `A`. No asumir que `totalOriginal`, `cargoEntrega` y `saldoConfirmado` del Cliente sean iguales.

## 3. D5 — Qué importe obtiene reconocimiento provisional

### 3.1 Decisión expresa del responsable (15/11/2026): D5-B

**D5-B — APROBADA FUNCIONALMENTE:** el efectivo recibido por el Repartidor al entregar un Pedido **se imputa exclusivamente a esa entrega**. **No** cancela deudas anteriores ni de otros Pedidos del mismo Cliente. La cancelación de deudas se tramita **aparte**, por su circuito autorizado, y no se mezcla con la declaración del Repartidor en UC-05.

| Alternativa | Estado | Alcance |
|---|---|---|
| **D5-A — deuda global del Cliente** | **DESCARTADA para UC-05** | Mezclaría el pago de la entrega con deudas anteriores, expresamente excluidas por el responsable. |
| **D5-B — solo entrega actual** | **APROBADA FUNCIONALMENTE** | Reconocimiento provisional únicamente sobre el importe atribuible a la entrega correspondiente, tras aceptación/validación del servidor. |
| **D5-C — validación en otro paso** | **NO ADOPTADA como política alternativa** | La necesidad de controles específicos de validación sigue sujeta a RD-F04-003/004 y al diseño; no modifica la exclusividad de D5-B. |

**D2 se preserva:** registrar íntegramente el efectivo declarado, aun si excede lo atribuible a esa entrega; el exceso no se acredita, cobra ni convierte en saldo a favor de forma automática. El importe reconocido exacto **no se deriva automáticamente** de `totalOriginal`, `totalPedido` ni del saldo global del Cliente.

### 3.2 Detalles de D5-B todavía pendientes de especificación (SIN AUTORIZACIÓN TÉCNICA)

1. **Resuelto:** UC-05 no permite imputar el dinero a deudas anteriores o de otros Pedidos; esas deudas se saldan por un procedimiento distinto.
2. ¿Cuál es el **importe comercial realmente atribuible a la entrega actual** si hay entrega parcial, líneas adicionales UC-07, ajustes históricos y cobros previos vinculados a esa misma entrega?
3. Si `D` supera ese importe atribuible, ¿qué porción `V` se valida y cómo se conserva el resto declarado para conciliación sin crédito ni Cobro automático?
4. ¿Cómo se evita reconocer dos veces el importe de **la misma entrega** frente a Cobros y otras declaraciones concurrentes, sin tocar deudas de otros Pedidos?
5. ¿Se congela `V` al aceptar el evento en servidor o se permite ajuste posterior mediante otro evento explícitamente autorizado, manteniendo inmutable `D`?
6. ¿Cómo tratar entrega con cargo cero, saldo a favor, diferencias entre `D` y efectivo realmente rendido, o saldo exigible provisional negativo sin introducir compensaciones de deuda ajena?

**No se aprueba una fórmula física o algorítmica** como `min(importeDeclarado,totalPedido)` o `min(importeDeclarado,saldoGlobalCliente)`. Los límites exactos, la prevención de reconocimientos duplicados y las pruebas deben diseñarse conforme a D5-B.

## 4. D6 — Cómo opera la rendición autorizada y el cese atómico

### 4.1 Opción D6-1 — APROBADA FUNCIONALMENTE el 15/11/2026

**Opción D6-1 (elegida por el responsable):** la rendición es un **subflujo específico de UC-29** atendido exclusivamente por ADMINISTRADOR. A diferencia del Cobro manual general, exige vinculación explícita con una o más declaraciones validadas y con la rendición del recorrido; utiliza orquestación interna adicional y conserva el catálogo G0 sin inventar automáticamente un CU #65 ni conceder UC-14 al Administrador.

**Opción D6-2:** operación administrativa independiente. **No adoptada**; si en el futuro se considera, requerirá revisión expresa de G0 y gobierno.

**Gate de seguridad aprobado:** VENDEDOR sigue autorizado a Cobro manual general donde corresponda, pero **nunca** a registrar o confirmar una **rendición de un Repartidor**, aun si el cobro general comparte parte del servicio. El Repartidor tampoco recibe permisos UC-29. La elección D6-1 **no autoriza** un endpoint, proyección o permiso adicional; esos contratos y controles continúan pendientes de diseño y revisión.

### 4.2 Requisitos transaccionales de D6

Para una rendición con aplicaciones monetarias vinculadas a declaraciones:

1. Validar ADMINISTRADOR, recorrido, repartidor, declaraciones aceptadas y evidencia física del dinero recibido.
2. Obtener locks del protocolo **global compatible** con UC-03/05/19/28/29/43 y registrar la identidad idempotente de rendición; su orden definitivo requiere DS y pruebas. C3-08 demostró `40P01` para un **prototipo** que toma `PEDIDO U → CLIENTE U` frente a UC-29.
3. Impedir aplicar una misma parte del tránsito dos veces y vincular únicamente COBRO del mismo Cliente. La suma de aplicaciones no debe exceder **V autorizado**, no solo D declarado.
4. Registrar `COBRO(CONFIRMADO)`, `MOVIMIENTO_CUENTA(PAGO)`, `MOVIMIENTO_CAJA(INGRESO)`, orígenes, evidencia de rendición y aplicaciones definitivas **atómicamente**, sin `REQUIRES_NEW` intermedio.
5. Dejar de computar, en esa misma transacción, exactamente la porción de V aplicada al Cobro. El resto del pago validado conserva provisionalidad cuando la rendición está pendiente, conforme F04-005.
6. Garantizar rollback total de Cobro, Cuenta, Caja, aplicación y cese provisional si falla una validación, FK, integridad o autorización.
7. Mantener declaración original y las aplicaciones como historia auditable. Diferencias no crean Cobro ni Caja por efectivo no recibido.
8. Proteger ante reenvío, respuesta perdida, dos Administradores concurrentes y cierre parcial del recorrido sin doble asiento.

**Mecanismo conceptual del saldo:** antes de aplicar un cobro, `saldoExigibleProvisional = S − V_pendiente`; si el Administrador confirma un Cobro de importe `a` aplicado íntegramente a tránsito, el confirmado baja en `a` y el tránsito vigente baja en `a`. Por eso la deuda provisional se mantiene sin **segundo descuento**, suponiendo ausencia de otras operaciones concurrentes y `0 ≤ a ≤ V_pendiente`. Este es un ejemplo algebraico de integridad, **no define D5 ni el reparto de R**.

### 4.3 Ejemplos conceptuales para aceptación (D5-B aprobada; cuantificación de V pendiente)

**Ejemplo A, rendición completa:** saldo confirmado deudor S=1000; el servidor ya validó V=600 bajo una política D5 futura; exigible inicial=400. Administrador recibe R=600, contabiliza Cobro aplicado A=600 y retira 600 de V. Luego S=400, V=0 y exigible=400; no duplicó efecto.

**Ejemplo B, rendición parcial con faltante:** S=1000, V=600, exigible=400. Administrador recibe R=400; confirma solo A=400 y retira esa porción del tránsito. Luego S=600, V=200, exigible=400. Los 200 restantes continúan pendientes de conciliación; no vuelven automáticamente a deuda exigible.

**Ejemplo C, declaración superior al importe de la entrega:** D=1500, importe comercial atribuible a la entrega actual=1000 (ejemplo hipotético). El documento conserva D=1500, **sin inferir V=1000** hasta definir las validaciones de esa misma entrega. El exceso no puede imputarse a otras deudas, convertirse en crédito ni originar Cobro o Caja automáticamente.

### 4.4 Bloqueos/limitaciones que no pueden tratarse como resueltos

- **D7 — Anular Cobro aplicado a tránsito:** debe definirse la contraaplicación antes de habilitar anulación de un COBRO vinculado. **Propuesta de seguridad:** bloquear ese caso hasta ratificar D7; no inventar restitución automática de V.
- **D9 — Proyección administrativa:** debe diseñarse vista de rendición autorizada; no conceder `UC-14` al ADMINISTRADOR por inferencia.
- **D10 — Cierre definitivo con diferencia:** no resolver responsabilidad, crédito, recupero ni asiento de dinero no recibido por inferencia.
- **D12 — CR-B0-F04-001:** decidir separación PE-1 / PE-2 / PE-3, y el gate correspondiente.
- **Evidencia de recepción:** formato concreto pendiente; cumplir mínimos funcionales aprobados RD-F04-002.
- **Offline PE-3:** no habilitar captura sincronizable ni un inbox sin CR aprobada.

## 5. Contratos y decisiones pendientes antes de codificar

| Bloque | Estado | Salida requerida |
|---|---|---|
| **D5-B** | **POLÍTICA FUNCIONAL APROBADA 15/11** | Definir importe atribuible exclusivamente a la entrega, tratamiento del exceso, cobros previos de esa entrega y mecanismo verificable de reconocimiento; no aplicar deudas anteriores |
| **D6-1** | **ENCUADRE FUNCIONAL APROBADO 15/11** | Completar contrato del subflujo de UC-29, seguridad exclusiva ADMINISTRADOR, idempotencia, evidencia de rendición, aplicación/cese atómico y pruebas |
| **D7** | PENDIENTE | Compensación de anulación de COBRO aplicado, o prohibición explícita hasta definirla |
| D1/D2/D3/D9/D12 | PR #44, NO RATIFICADA | Decisión documental coherente con D5/D6 |
| CR física PE-1/PE-2 | NO AUTORIZADA | Diseño de tablas, constraints y migración futura, posterior a ratificación |
| C3-A.3 | Evidencia Nivel R/P disponible en PR #89 | Incorporar al DS el orden sin inversión; jamás declarar UC-05 ya probada |
| UC-07 CR-C/CR-F | DRAFT/NO IMPLEMENTADAS | Delimitar nuevas líneas físicas y efectos adicionales antes de cerrar UC-05 |
| Issue app #28 | ABIERTA | Despliegue continúa pausado |

## 6. Matriz mínima de escenarios para tests futuros

| ID | Situación | Propiedad a exigir |
|---|---|---|
| D56-01 | D válido, V reconocido | Solo consulta provisional cambia; 0 COBRO, 0 CAJA |
| D56-02 | D excede monto de entrega | Se conserva íntegro; no crédito ni Cobro automático |
| D56-03 | Cliente con deuda anterior + cargo nuevo | D5-B: solo reconocer importe atribuible a la **entrega actual**; la deuda anterior no recibe parte de la declaración |
| D56-04 | Deuda inicial cero / saldo a favor | No convertir declaración en crédito implícito |
| D56-05 | Cobro general concurrente con validación de tránsito | No sobre-reconocer ni leer snapshots incongruentes |
| D56-06 | Admin rinde exactamente V | Cese provisional y Cobro confirmados en una sola transacción |
| D56-07 | Admin rinde una parte de V | Resto conserva provisionalidad; diferencia pendiente |
| D56-08 | Rendido real menor que declarado | No contabilizar efectivo no recibido; no reexigir faltante automáticamente |
| D56-09 | Rendido mayor que V | No imputar exceso por inferencia; vía de conciliación pendiente |
| D56-10 | Reenvío tras pérdida de respuesta | Mismo resultado comercial, sin duplicar aplicaciones |
| D56-11 | Dos Administradores aplican simultáneamente misma declaración | Una única aplicación por porción; sin cobro/caja duplicados |
| D56-12 | Anulación de Cobro vinculado | Exigir decisión D7; si no existe, bloquear |
| D56-13 | Vendedor intenta rendición | Denegado; Cobro general queda sometido a permisos preexistentes |
| D56-14 | Repartidor intenta UC-29 o rendición | Denegado; UC-05 conserva permiso de declaración |
| D56-15 | Faltante pendiente + nuevo Pedido | F04-005/006: deuda provisional no se restablece automáticamente |
| D56-16 | Fallo SQL al insertar Cuenta/Caja/aplicación | Rollback total e historia intacta |

**Estado de ejecución:** TODOS estos escenarios son **CASOS PROPUESTOS, NO EJECUTADOS**.

## 7. Asiento de decisiones expresas y reserva de implementación

**Decisiones comunicadas por el responsable el 15/11/2026:**

- **D5 = D5-B — APROBADA FUNCIONALMENTE:** la declaración del Repartidor al entregar un Pedido se imputa **exclusivamente a esa entrega**. El saldado de deudas anteriores/ajenas a dicha entrega se tramita aparte.
- **D6 = D6-1 — APROBADA FUNCIONALMENTE:** la rendición de dinero de Repartidor se trata como **subflujo administrativo de UC-29**, exclusivamente autorizado al ADMINISTRADOR, conservando los permisos de Cobro manual general sin ampliarlos.
- **Atomicidad D6 — regla a instrumentar:** el Cobro confirmado asociado a tránsito retira el mismo importe de reconocimiento provisional en **una transacción**; no hay doble imputación. Esta regla desarrolla RD-F04-003/004; el diseño específico requiere pruebas.

**Asuntos que NO se infieren ni ratifican:**

1. Monto exacto `V` de cada entrega, eventos que ajustan reconocimiento, pagos parciales/exceso y snapshots comerciales: requieren diseño compatible con D5-B y aprobación de sus criterios.
2. Forma física PE-1/PE-2/PE-3, nombres de columnas, DDL/migraciones, consultas, endpoints, DTO y contratos de autorización: siguen propuestos/no autorizados.
3. **D7:** qué hacer si se anula un Cobro aplicado al tránsito (contraaplicación/restitución) y cómo preservar simultáneamente el saldo confirmado y la exigibilidad.
4. **D9/D10/D12:** vista administrativa, diferencias y CR física; requieren resolución aparte.
5. RD-I302-001 PR #44 sigue DRAFT y no queda ratificada integralmente por elegir D5/D6.

**Siguiente corte:** auditar este asiento junto con PR #44 y REV05; diseñar opciones de cálculo de `V` **solo para la entrega actual**, mecanismo transaccional de aplicación/cese, contraaplicación D7 y controles de seguridad; después preparar CR física propuesta para revisión separada. Mantener toda implementación deshabilitada.

**Dictamen:** D5-B/D6-1 **funcionalmente definidas**. Pendientes de diseño técnico y ratificación de las partes correspondientes; **no habilita código, Flyway, migraciones, merges ni despliegue**.
