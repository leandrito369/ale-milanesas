# RD-I302-002 (BORRADOR DE DECISIÓN) — D5/D6: reconocimiento del efectivo y rendición de UC-05

**Fecha:** 15/11/2026.  
**Estado:** **PROPUESTA / NO RATIFICADA / NO AUTORIZA IMPLEMENTACIÓN**.  
**Objetivo temporal del Roadmap:** 12/12/2026 (hipótesis de planificación, no excepción a las puertas de gobierno).  
**Autoridad decisora:** responsable del proyecto.  
**Línea base de gobierno al redactar:** `cdd57ed194268f1f5ab29aa0f55781ddddebdfb5`.  
**Línea base de aplicación al redactar:** `4dbe38668fc5cbc08d04e10920e3bf165c71be11`.  
**Dependencias:** PR gobierno #44 (`RD-I302-001`), PR app #89 (C3-A.3 R/P), CR-C #47, CR-F #48, CR-B0-F04-001; G0 y contratos REV04B/REV05. Todas las PR citadas permanecen independientes de esta propuesta.  
**Alcance:** decidir la política **D5**, el mecanismo **D6** y explicitar la dependencia de **D7**; NO define aún DDL, endpoints, nuevos roles ni operación canónica.

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
- **Validado/reconocido vigente (V):** parte de una declaración **aceptada por servidor** con efecto permitido sobre deuda exigible provisional; su base debe decidirse en D5.
- **Rendido recibido (R):** dinero que el Administrador afirma y acredita haber recibido físicamente al finalizar recorrido; debe conservar evidencia de conteo, responsable y discrepancia.
- **Aplicado definitivamente (A):** fracción de V asociada a uno o varios COBRO confirmados de rendición, con cese proporcional del efecto provisional **en la misma transacción**.
- **Diferencia:** componente declarado/validado y no recibido o no aplicado; su destino definitivo no se deduce y queda pendiente de conciliación.

No equiparar `D`, `V`, `R` y `A`. No asumir que `totalOriginal`, `cargoEntrega` y `saldoConfirmado` del Cliente sean iguales.

## 3. D5 — Qué importe obtiene reconocimiento provisional

### 3.1 Opciones de política comercial a decisión del responsable

| Opción | Base de reconocimiento | Ventaja | Riesgo / decisión adicional | Estado |
|---|---|---|---|---|
| **D5-A (sugerida para evaluación)** | **Deuda positiva global del Cliente en el servidor**, considerando el cargo confirmado de la entrega y otros tránsitos vigentes; exceso monetario queda documentado para conciliación sin crédito automático | Puede cubrir deuda anterior, además de la venta entregada; evita deuda provisional negativa por exceso si se valida atómicamente | Decidir prioridad entre obligaciones, cómo preservar V ante pagos independientes posteriores y qué hacer cuando no hay deuda disponible | **PROPUESTO** |
| **D5-B** | Solo parte atribuible al **cargo de esa entrega**, descontando lo ya definitivamente cubierto según una regla específica | Facilita conciliación entrega ↔ dinero | Una persona que paga además deuda anterior necesita mecanismo distinto; no es equivalente a aplicar todo al Cliente | **PROPUESTO** |
| **D5-C** | Declaración queda registrada; reconocimiento monetario ocurre únicamente tras validación específica de un segundo paso | Minimiza reconocimiento prematuro de montos controvertidos | Definir qué significa aceptación de UC-05 y en qué momento se produce la validación exigida por F04; podría demorar efecto provisional | **PROPUESTO** |

**Recomendación provisional:** evaluar **D5-A** si el negocio entiende que el efectivo recibido puede abonar tanto esta entrega como otras obligaciones del mismo Cliente. No es una elección por defecto ni una fórmula ratificada.

### 3.2 Preguntas que D5 debe resolver explícitamente

1. ¿Puede el efectivo declarado al entregar un Pedido cubrir deudas de **otros Pedidos** del mismo Cliente?
2. ¿Qué hacer si D es mayor que la deuda elegible: reconocer solo parte y mantener el resto declarado para conciliación, sin crédito automático?
3. ¿Qué se considera deuda elegible cuando existen saldo a favor, pagos previos, cargo de entrega aún en la misma transacción, otros tránsitos y Cobros concurrentes?
4. ¿V se congela por aceptación del servidor o se recalcula al consultar? Si cambia, ¿qué evento autorizado ajusta V sin borrar la declaración original?
5. ¿Cómo se diferencia importe declarado en exceso de efectivo realmente rendido en exceso?
6. ¿Se permite saldo exigible provisional negativo? Si no, definir la restricción y los casos con deuda nula.

**No se ratifica** `min(importeDeclarado,totalPedido)`, `min(importeDeclarado,saldoCliente)` ni una regla de prioridad entre deudas. Cualquier ecuación de tope requiere decisión expresa y escenarios de negocio.

## 4. D6 — Cómo opera la rendición autorizada y el cese atómico

### 4.1 Forma funcional candidata

**Opción D6-1 (recomendada para diseño):** la rendición es un **subflujo específico de UC-29** atendido exclusivamente por ADMINISTRADOR. A diferencia del Cobro manual general, exige vinculación explícita con una o más declaraciones validadas y con la rendición del recorrido; utiliza orquestación interna adicional y conserva el catálogo G0 sin inventar automáticamente un CU #65 ni conceder UC-14 al Administrador.

**Opción D6-2:** operación administrativa interna propia, sujeta a análisis y autorización de G0 si modifica el catálogo de operaciones y accesos. No autorizada por este documento.

**Gate de seguridad:** VENDEDOR sigue autorizado a Cobro manual general donde corresponda, pero **nunca** a registrar o confirmar una **rendición de un Repartidor**, aun si el cobro general comparte parte del servicio.

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

### 4.3 Ejemplos conceptuales para aceptación (sin política D5 ratificada)

**Ejemplo A, rendición completa:** saldo confirmado deudor S=1000; el servidor ya validó V=600 bajo una política D5 futura; exigible inicial=400. Administrador recibe R=600, contabiliza Cobro aplicado A=600 y retira 600 de V. Luego S=400, V=0 y exigible=400; no duplicó efecto.

**Ejemplo B, rendición parcial con faltante:** S=1000, V=600, exigible=400. Administrador recibe R=400; confirma solo A=400 y retira esa porción del tránsito. Luego S=600, V=200, exigible=400. Los 200 restantes continúan pendientes de conciliación; no vuelven automáticamente a deuda exigible.

**Ejemplo C, declaración superior a la deuda:** D=1500 y saldo confirmado=1000. El documento debe conservar D=1500, pero **no determina V=1000** sin decisión D5. El exceso monetario no se convierte automáticamente en crédito, Cobro ni Caja.

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
| **D5** | PENDIENTE | Política de reconocimiento y comportamiento ante importe superior a deuda/entrega, saldo a favor, pagos previos y múltiples obligaciones |
| **D6** | PENDIENTE | Elegir forma D6-1/D6-2, restricciones y operación administrativa exacta, seguridad, idempotencia y cese atómico |
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
| D56-03 | Cliente con deuda anterior + cargo nuevo | Determinar V conforme opción D5 ratificada |
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

## 7. Solicitud expresa de decisión al responsable

**D5.** Elegir A (deuda global de Cliente), B (solo cargo imputable a la entrega) o C (aceptación con validación separada), indicando cómo tratar exceso, pagos previos y orden de prioridad.  
**D6.** Elegir D6-1 (subflujo administrativo de UC-29, recomendado) o D6-2 (otra operación a someter a G0).  
**D7.** Determinar si se bloquea anulación de cobros vinculados hasta decidir contraaplicación, o si se requiere resolver todo D7 antes de autorizar PE-2.

Hasta recibir esas decisiones **NO RATIFICAR** esta RD ni la PR #44, no crear DDL, no cambiar código productivo ni declarar UC-05 implementada.

**Dictamen:** expediente de decisión listo para revisión funcional. Esta propuesta permite avanzar con trabajo documental y diseño, no habilita ejecución de UC-05 ni modificaciones de F04/G0.
