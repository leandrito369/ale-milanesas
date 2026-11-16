# Auditoría transversal E2 — Invariantes del dominio y conservación de hechos

**Corte de evidencia:** 15/11/2026 (Argentina). **Estado:** PRUEBA DOCUMENTAL Y ESTÁTICA PARCIAL, sin ejecución de código ni BD.  
**Marco funcional:** E1 adoptado como referencia de trabajo por el responsable en conversación posterior; no es observación externa del negocio.  
**Autoridad:** G0 64 CU/67 operaciones + RD ratificadas, con propuestas/PR draft claramente segregadas.  
**Restricciones:** solo documentación; sin DDL, fuente Java, migraciones, cambios de RBAC, merges o despliegue.

## 1. Método y lectura de estados

**Invariante:** propiedad que debe mantenerse después de cada transición válida. Para una transacción que falla se exige que el estado persistente permanezca equivalente al anterior. Se distingue:
- **CONTRATO**: exigencia identificada en Fase4/G0/RD.
- **ESTRUCTURA**: columnas/constraints/triggers visibles en migraciones Flyway V1–V3.
- **SERVICIO**: garantía de código (necesita inspección específica y pruebas ejecutadas; aquí NO certificada en toda la vertical).
- **GAP**: una exigencia sin mecanismo físico suficiente acreditado o pendiente de diseño, no necesariamente un bug observado.

Referencias de código físico: [V1 MR5](https://github.com/leandrito369/ale-milanesas-app/blob/main/src/main/resources/db/migration/V1__baseline_mr5.sql), [V2 F01](https://github.com/leandrito369/ale-milanesas-app/blob/main/src/main/resources/db/migration/V2__f01_cobro_estados.sql), [V3 Partidas](https://github.com/leandrito369/ale-milanesas-app/blob/main/src/main/resources/db/migration/V3__trazabilidad_partidas_insumo.sql).
Referencias de requisitos: [manifiesto G0](b0/G0_MANIFIESTO_CANONICO_67_OPERACIONES_2026-10-29.csv), [REV04B](../08-diagramas/consolidacion-b0/CONTRATOS_REV04B_CORREGIDOS_B0_ACTUALIZADO.md), [REV05](../08-diagramas/consolidacion-b0/CONTRATOS_REV05_CORREGIDOS_B0_ACTUALIZADO.md), [RD-I301](b0/RD_I301_001_DECISIONES_I3_01_RECETAS_PREPARACION_2026-11-11.md), [RD-MR-PARTIDAS](b0/RD_MR_PARTIDAS_001_AMPLIACION_MR_PARTIDA_INSUMO_2026-11-06.md), [R08.4 PR #53](https://github.com/leandrito369/ale-milanesas/pull/53) y [R08.5 PR #54](https://github.com/leandrito369/ale-milanesas/pull/54) (**borradores**).

## 2. Matriz de invariantes de extremo a extremo

| ID | Invariante del dominio | Referencias y datos físicos observados | Nivel de garantía documentado | Dictamen E2 |
|---|---|---|---|---|
| INV-01 | Un Pedido tiene identidad única; su estado es PENDIENTE, ENTREGADO o CANCELADO y su contenido comercial histórico no se reescribe por precios actuales | `PEDIDO` PK, `idOperacionOrigen` UNIQUE, `estado` CHECK, `totalOriginal`; `DETALLE_PEDIDO` guarda precio/promoción original | Estructura en V1; semántica y transiciones requieren servicios/lock | **COBERTURA PARCIAL; test end-to-end pendiente** |
| INV-02 | Preparación propia acumulada por detalle no supera `cantidadOriginal`; adicionales reasignados no consumen cuota de preparación propia | `PREPARACION(idPedido, numeroDetalle, cantidadPreparada, idReceta, numeroVersion)`; `DETALLE_PEDIDO.cantidadOriginal`; contrato UC-28 | Regla transversal agregada por servicio y serialización, no por CHECK de una sola fila | **PARCIAL; idempotencia UC-28 diferida RD-UC28-002** |
| INV-03 | Todo consumo de Insumo por preparación descuenta existencias utilizables, conserva costo y no admite cantidad menor o igual a cero | V1 `MOVIMIENTO_INSUMO`, `COSTO_INSUMO_HISTORICO`; V3 `PARTIDA_INSUMO`, `DETALLE_MOVIMIENTO_PARTIDA` con FKs compuestas y checks; RD-I301 | V3 asegura pertenencia partida/insumo por FK; suma partidas=movimiento y saldos requieren trigger/servicio/prueba, no meras FKs | **PARCIAL; cotejo de trigger e intercalados pendiente** |
| INV-04 | `stockActual` de Insumo debe conciliar con cantidades físicas por partida y excluir partidas vencidas del stock utilizable | V3 `PARTIDA_INSUMO.cantidadDisponible`, `fechaVencimiento`, `fechaHoraApertura`; RD-MR-PARTIDAS D1–D4 | Modelo ampliado a 62 tablas, RD ratificada; FEFO e integridad acumulada requieren servicios y pruebas | **PARCIAL, verificar a nivel integración PostgreSQL** |
| INV-05 | La Entrega es única por Pedido, con cantidades efectivamente entregadas y nunca superiores a disponibilidad válida | V1 `ENTREGA(idPedido)` PK, `DETALLE_ENTREGA(idPedido, numeroDetalle)` PK y `cantidadEntregada>=0` | PK evita más de una cabecera por Pedido, **no equivale** a idempotencia de comando ni valida suma de preparaciones+adicionales | **BRECHA de servicio/operación; UC-05 pendiente** |
| INV-06 | Excedentes y REVENTA conservan cantidades y costos; ofrecer/aceptar/descartar no fabrica nuevo producto ni duplica salida | V1 `EXCEDENTE` checks cantidad/costo, `OFERTA_EXCEDENTE`, `MOVIMIENTO_EXCEDENTE`, `IMPUTACION_ENTREGA_ADICIONAL`; UC-07/41 | Checks solo locales; aceptación, evidencia, cotización y stock transaccional cruzado esperan CR-C/CR-F | **BLOQUEANTE para vertical con UC-07** |
| INV-07 | Cargo de venta se deriva de cantidades realmente entregadas y valores congelados; parciales nunca cargan todo `PEDIDO.totalOriginal` por defecto | `DETALLE_ENTREGA`, `PEDIDO`, `DETALLE_PEDIDO`, `MOVIMIENTO_CUENTA`/origen; decisiones DC-01-C1, DC-02-A, DC-04-A comunicadas en PR #62/#63 | Fórmula de componentes, reconciliación por detalle y caso UC-07 aún no cerrados en contrato integrado | **ALTO; sujeto a integración normativa y pruebas de centavos** |
| INV-08 | Un Cobro CONFIRMADO o ANULADO genera los movimientos correctos una sola vez; anulación manual requiere contraasientos e identidad | V1 `COBRO`, `MOVIMIENTO_CUENTA`, `ORIGEN_MOVIMIENTO_CUENTA`, `MOVIMIENTO_CAJA`; V2 CHECK y trigger transición F01 | Estado y ciertas unicidades están en BD; integridad transaccional y privilegios se prueban por servicio; PR app #91 draft | **PARCIAL; anulación/concurrencia por comprobar** |
| INV-09 | Un anticipo se atribuye por importe a una obligación específica sin superar Cobro disponible; reserva no equivale a aplicación | V1 `COBRO.idPedido` opcional, pago y cargo por orígenes distintos; sin importe aplicado por obligación acreditado | R08.4 §5 / R08.5; IMP-B acordado funcionalmente en PR #60 draft, no migrado | **BRECHA CONFIRMADA DE REPRESENTACIÓN** |
| INV-10 | Efectivo declarado por Repartidor `D_e` no es automáticamente ingreso confirmado/Caja; el reconocimiento `V_e` nunca duplica aplicación definitiva | REV04B UC-05, REV05 UC-14/29 y RD-F04; V1–V3 sin diseño físico ratificado completo de tránsito/rendición | F04 funcional, alternativas R08.4 y RD-I302 propuestas; CR-B0-F04-001 pendiente | **BLOQUEANTE antes de UC-05/29 vertical** |
| INV-11 | Un mismo tramo de dinero no puede reducir dos veces la deuda: al rendir se retira su efecto provisional simultáneamente con el definitivo | Eventos de tránsito/COBRO/CUENTA/CAJA requeridos; F04/D6-1/D7-A; alternativa IMP-B append-only | No hay protocolo físico integral en V1–V3; requiere CR y orden de locks | **BLOQUEANTE** |
| INV-12 | Toda transición concurrente sobre un mismo Pedido/Cliente conserva consistencia y carece de secuencias con doble efecto o deadlock no tratado | Contratos UC-05/07/29; RD-I301 locks para UC-28; R08.5 ordenamiento y caso C3, RT-UC07-04 | Locks de un CU no prueban orden global para todas las operaciones | **ALTO; concurrencia PostgreSQL real pendiente** |
| INV-13 | Eventos y reintentos tienen identidad de negocio: mismos parámetros no duplican Pedido, preparación, Entrega o Cobro | V1 `PEDIDO.idOperacionOrigen`, `COBRO.claveIdempotenciaOrigen`; `ENTREGA` PK sin identidad de comando; RD-UC28-002 diferida | Idempotencia parcial en algunas operaciones; no hay mecanismo general completo para todas | **PARCIAL / BLOQUEANTE en Entrega** |
| INV-14 | Reembolso no genera egreso definitivo antes de estado PROCESADO y no se duplica ante callback repetido | V1 Reembolso/MovimientoCaja y contratos F06 | SQL de laboratorio cubrió solo reglas seleccionadas; falta E2E con simulador | **PRUEBA FUNCIONAL PENDIENTE** |
| INV-15 | Compra a Proveedor requiere decisión ADMIN; movimiento Insumo recibido debe tener origen/costo físico coherente | `EPISODIO_FALTANTE`, `SOLICITUD_COTIZACION`, `DECISION_COMPRA`, `RECEPCION_COMPRA` y `MOVIMIENTO_INSUMO` | Modelo estructural disponible, circuito I5 sin aceptación completa | **NO CERTIFICADO END-TO-END** |
| INV-16 | Permisos de operación y proyecciones por campo se aplican al actor/canal autorizado; no se infieren de SQL | Matriz RBAC 67×8 y BC07 del G0; V1 `ROL`, `USUARIO_ROL`, sesiones | Matriz documental aprobada, APIs por etapas; E2E humanos pendientes | **PARCIAL POR OPERACIÓN** |

**Advertencia:** esta es una **matriz de hipótesis de conservación y evidencia inspeccionada**, no certificación de que cada trigger/servicio cumple la propiedad. El CHECK/PK físico se puede verificar estáticamente; los vínculos entre registros deben probarse dinámicamente.

## 3. Cinco puntos de ruptura prioritarios

### R1 — Dinero confirmado, anticipo y aplicación (INV-08/09)
La semántica contractual distingue `COBRO.idPedido` de la **aplicación efectiva de una porción monetaria a una obligación**. El modelo vigente no acredita directamente una entidad de imputaciones por `idCobro`/obligación/importe/estado. El FIFO global registrado en servicios previos puede contradecir reserva explícita. **No calcular `P_e` del `idPedido` o del saldo del Cliente**.

**Prueba requerida:** cliente con dos deudas, cobro previo parcial, reserva por Pedido 2, posterior Entrega de Pedido 2, anulación y concurrencia. Verificar identidad y suma de aplicaciones <= importe confirmado, sin doble destino.

### R2 — Declaración → tránsito → rendición (INV-10/11)
Separar `D_e` (declaración), `V_e` (provisional), `COBRO` y Caja. La conversión requiere un protocolo atómico con correcciones/contraaplicaciones tipadas; la aceptación central es distinta de captura offline.

**Prueba requerida:** declaración superior/inferior al saldo elegible, rendición parcial, faltante constatado, repetición de comando, fallo entre eventos y UC-05/29 simultáneos.

### R3 — Conservación de cantidades y costos (INV-02/03/04/05/06)
Para cada detalle ELABORADO: cantidad preparada propia, cantidad disponible, entregada, convertida a Excedente o descartada/reasignada debe poder explicarse **sin doble conteo**. Para Insumos: egreso por preparación vinculado con partidas FEFO y costo histórico; para REVENTA: egreso por Entrega, no por Preparación.

**Prueba requerida:** preparar 8, entregar 6, originar excedente 2; reasignar 1 y descartar 1; recuento de unidades y costo a través de cada movimiento. Verificar que `cantidadOriginal=10` no obliga a fabricar las 2 pendientes.

### R4 — Entrega parcial con ajuste comercial (INV-01/07)
El total original no define por sí solo el cargo de una entrega parcial. Deben aplicarse las condiciones históricas, reglas de redondeo y reconciliación con UC-16; la incorporación de adicional UC-07 depende de una CR autorizada.

**Prueba requerida:** 3 líneas con promociones, cantidad parcial en 2, ajuste comercial congelado, precios con 4 decimales; verificar importes de 2 decimales sin centavos inventados y entrega completa reconciliada con `totalOriginal`.

### R5 — Bloqueos e idempotencia (INV-05/12/13)
Una PK de `ENTREGA` controla cardinalidad de cabecera, **no** la respuesta a un reintento ni la consistencia de una lectura concurrente de Cobro/Excedente. Los locks deben estudiarse como grafo global que contiene UC-28/05/07/29, no individualmente.

**Prueba requerida:** intercalados reproducibles en PostgreSQL 17 con dos o más sesiones; mismo `idOperacionOrigen` y payload igual/distinto; comprobar una sola Entrega, un único cargo y ninguna recontabilización.

## 4. Prioridad y competencia

| Prioridad | Decisión o comprobación | Autoridad |
|---|---|---|
| P0 | Ratificar y consolidar expediente financiero interdependiente (IMP-B, anticipo, cargo, tránsito y rendición) | Responsable del proyecto; contratos/CR |
| P0 | Contratos cruzados UC-05 / UC-07 y evidencia/stock de adicional | Responsable del proyecto; CR-C/CR-F; no autorizar por inferencia |
| P0 | Grafo de locks, idempotencia y escenarios de intercalado | Arquitectura B0/B3 + pruebas; si cambia contrato, RD |
| P1 | Reconciliación de unidades y costo V1/V3 en escenarios compuestos | Backend/BD + Testcontainers |
| P1 | Regresión precios/promociones/ajustes, centavos y categoría | Servicios I1/I2 + pruebas |
| P1 | Mapa de RBAC y protección de datos UC-05/07/29 | G0 + revisión HTTP/UI |
| P2 | Validación humana, UI E2E y offline (PE-3 diferida) | B5/B7/B8; no declaración de aceptación prematura |

## 5. Dictamen E2 y condiciones de cierre

**Hallazgo dominante:** el problema principal no es «demasiadas tablas» ni «todos los CU mal diseñados». Es la **integración de invariantes interdominio**, especialmente entre `PEDIDO`/`ENTREGA`, `COBRO`, `MOVIMIENTO_CUENTA` y `MOVIMIENTO_CAJA`, junto con Excedentes, existencias y concurrencia.

- **E2 realizada como evaluación estática inicial:** 16 invariantes trazadas a contratos/datos y 5 focos de prueba.
- **NO cerrada como verificación de implementación:** sin inspección exhaustiva de cada servicio, ni ejecución de la suite PostgreSQL/HTTP/E2E en este corte.
- **Secuencia acordada de continuación:** antes del cotejo exhaustivo de servicios, la [Etapa 3](AUDITORIA_E3_CONTRATO_COMERCIAL_CONSOLIDADO_2026-11-15.md) consolida decisiones comerciales existentes y separa pendientes normativos de soluciones técnicas (borrador en esta PR). Luego se hará el **cotejo técnico de servicios y esquema real por invariantes** (INV-09/10/11/12 prioritarias), registrando una matriz única de discrepancias **sin abrir micro-PR por cada regla**.
- **Despliegue pausado:** Issue app #28 permanece abierta. Ninguna prueba/CI futura autoriza levantarla sin decisión del responsable.

**Nota de versiones:** el [informe MR-6 del 26/10](../05-modelo-relacional/MR6_INFORME_EJECUCION_2026-10-26.md) documenta pruebas PostgreSQL del esquema de **60 tablas**; la **ampliación a 62 tablas** adoptada el 06/11 también recibe la denominación MR-6 y está implementada como Flyway **V3**. No confundir versión de ampliación con nombre de campaña histórica de pruebas.
