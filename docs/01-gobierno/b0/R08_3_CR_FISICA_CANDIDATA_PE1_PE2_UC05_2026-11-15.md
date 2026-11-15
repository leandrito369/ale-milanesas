# R08.3 — Expediente de diseño físico candidato PE-1/PE-2 para UC-05 y rendición UC-29

**Fecha:** 15/11/2026.  
**Estado:** **PROPUESTA FÍSICA / NO RATIFICADA / NO AUTORIZA DDL NI IMPLEMENTACIÓN**.  
**Propósito:** preparar las decisiones físicas necesarias para I3-02 sin confundir la aprobación de D5-B/D6-1/D7-A con autorización de migración.  
**Plan:** Roadmap I3–I7, objetivo 12/12/2026, subordinado al Plan Rector/G0.  
**Gobierno main base:** `cdd57ed194268f1f5ab29aa0f55781ddddebdfb5`. **App main base:** `4dbe38668fc5cbc08d04e10920e3bf165c71be11`.  
**Autoridad de las decisiones funcionales:** PR gobierno #50, RD-I302-002; PR #51, R08.2; PR #44, RD-I302-001 todavía DRAFT.  
**Otras reservas:** CR-B0-F04-001, UC-07 CR-C #47 y CR-F #48; H/RT-UC07-04 ABIERTA; Issue app #28, despliegue PAUSADO.

## 1. Decisiones ratificadas funcionalmente que debe cumplir el diseño

- **D5-B (15/11):** el dinero declarado en una entrega se imputa **solo a esa entrega**, nunca a deudas anteriores ni a otro Pedido. Saldar deuda de otro Pedido exige circuito separado.
- **D5-B / ANT-01 (15/11, decisión complementaria aprobada funcionalmente):** todo anticipo o Cobro previo **confirmado y efectivamente imputado al mismo Pedido/obligación de entrega** reduce el importe pendiente elegible para reconocimiento al entregar. No se descuenta por pertenencia al mismo Cliente ni solo por aparecer `COBRO.idPedido`, sin evidencia de imputación a esa obligación. No autoriza fórmula definitiva ni nueva estructura.
- **D6-1 (15/11):** la rendición al finalizar cada recorrido es **subflujo administrativo de UC-29, exclusivo ADMINISTRADOR**; el Cobro manual general conserva sus permisos actuales.
- **D7-A (15/11):** bloqueo **temporal de anulación de Cobros vinculados a rendición** hasta aprobar contraaplicación. **Sujeto a conciliación expresa del contrato UC-29/REV05.** La anulación manual general ajena a rendición no se restringe.
- RD-F04-002/003/004/005/006/007 y RD-F01: declaración íntegra; validación central antes de efecto provisional; nada a Caja o `COBRO` por declarar; faltante no restablece deuda automáticamente; nuevo Pedido evalúa exigible provisional sin recategorizar; `COBRO` solo `CONFIRMADO` o `ANULADO`.
- D2=B se encuentra **expresada y pendiente de asiento integral en RD-I302-001**: no recortar el importe declarado cuando supera la entrega. Ningún exceso genera crédito ni Cobro automáticos.

**Importante:** las decisiones anteriores **no** aprueban un valor numérico o fórmula de reconocimiento, un esquema ni nuevos permisos.

## 2. Diagnóstico físico desde Flyway V1–V3 y los servicios actuales

| Elemento real | Observación verificable | Brecha |
|---|---|---|
| `ENTREGA` | PK `idPedido`, hora de entrega, usuario repartidor | Sin `idOperacionOrigen` ni efectivo; replay requiere identidad independiente del Pedido |
| `DETALLE_ENTREGA` | Cantidades efectivamente entregadas por detalle | No es por sí sola una cifra de venta con ajuste histórico/adicional |
| `IMPUTACION_ENTREGA_ADICIONAL` | Cantidad e importe adicional imputado con movimiento de excedente | CR-C/CR-F e integración UC-07 no están autorizadas |
| `MOVIMIENTO_CUENTA` + `ORIGEN_MOVIMIENTO_CUENTA` | Cargo por venta vinculado a entrega; asiento por Cliente | Saldo global del Cliente **no sustituye** una imputación de pago a la obligación de una entrega concreta |
| `COBRO` | `idPedido` opcional, UUID idempotencia, `origen` con literal REPARTO/ONLINE/ADMINISTRACION | Informar un Pedido no prueba qué parte del Cobro corresponde a la rendición ni qué tránsito consumió |
| `MOVIMIENTO_CAJA` | Ingreso por Cobro confirmado | Sin asiento hasta rendición recibida/autorizada |
| `CobroManualService` | Cobro general, advisory `2929001`, `CLIENTE FOR UPDATE`, `PEDIDO FOR SHARE`; no usa tránsito | PE-2 exige orquestación administrativa propia y guardia D7-A; anulación toma `COBRO U` antes de `CLIENTE U` |

**Conclusión:** PE-1 (declaración + idempotencia) sola no alcanza. Antes de habilitar efecto provisional de D5-B es indispensable representar un **reconocimiento validado exclusivo de esa entrega** y un enlace que garantice el cese atómico en PE-2.

## 3. Candidatos de persistencia, todos NO autorizados

Los identificadores siguientes son **nombres candidatos, no objetos existentes, nombres canónicos, ni esquema SQL aprobado**.

### PE-1 — Identidad de entrega, declaración y validación

| Candidato | Campos o vínculos mínimos a evaluar | Integridad requerida |
|---|---|---|
| `ENTREGA.idOperacionOrigen` (columna candidata) | UUID estable aportado por comando UC-05 | Unicidad de comandos; nullable heredado solo tras analizar datos históricos; servicio exige UUID en altas nuevas |
| `PAGO_EN_TRANSITO` (entidad candidata) | PK por `idPedido` si solo hay una declaración por Entrega; `importeDeclarado` `NUMERIC(18,2)`, usuario, instante de recepción servidor, referencia a ENTREGA | Una declaración por entrega salvo cambio funcional aprobado; declaración íntegra, no negativa, historial no editable |
| Reconocimiento validado `V_e` | **Alternativa P1-A:** snapshot de validación inmutable por entrega, cuantía e instante. **Alternativa P1-B:** libro append-only de eventos de validación/ajustes con origen | `V_e` solo respecto del cargo comercial `C_e` de la misma entrega; ningún saldo global determina el valor automáticamente; no doble reconocimiento |
| Resultado idempotente reconstructivo | Referencias a `ENTREGA`, `DETALLE_ENTREGA`, cargos, adicionales, excedentes, declaración y reconocimiento | Reenvío con igual UUID + contenido: mismo resultado comercial; diferente contenido: rechazo sin efecto |

**Elección P1-A/P1-B pendiente:** preferir P1-A para el primer corte solo si se ratifica que el reconocimiento no necesita corrección posterior; si se necesitan correcciones administrativas, P1-B con historial es más fiel. Ninguna opción autoriza la fórmula `min(D_e,C_e)` ni otra.

**Decisión D5-B / ANT-01 ya aprobada funcionalmente:** `C_e` representa el cargo de las **cantidades efectivamente entregadas**, a precios/ajustes históricos y con adicionales autorizados; `P_e` comprende anticipos/Cobros **confirmados y demostrablemente imputados a la obligación de ese Pedido/entrega**. Estos importes deben **descontarse del pendiente elegible para reconocimiento en UC-05**, sin afectar deudas ajenas. La **identificación de imputaciones, distribución de anticipos entre líneas o entrega parcial y la cuantificación exacta de `V_e` siguen pendientes de diseño, autorización y pruebas**. Un `COBRO.idPedido` informado por sí solo no establece una imputación válida.

### PE-2 — Rendición, aplicaciones definitivas y protección D7-A

| Candidato | Datos/binding necesarios | Invariante |
|---|---|---|
| Registro de rendición por recorrido | Identidad idempotente del cierre, repartidor, Administrador, fecha/hora, esperado, realmente recibido, diferencia, observación, evidencia de recepción | Recorrido como concepto funcional: **no presumir tabla/PK física existente**. Precisar identidad y granularidad antes de elegir objeto |
| Detalle de rendición | Relación con una o más entregas/declaraciones; importe esperado y físicamente recibido por declaración | No trasladar dinero entre Clientes o entregas sin autorización; permitir diferencias |
| `APLICACION_PAGO_EN_TRANSITO` (entidad candidata) | FK a declaración/Entrega y a `COBRO` confirmado, `importeAplicado` y origen de rendición, identidad idempotente por aplicación | `0 < importeAplicado <= V_e` disponible; suma por declaración no supera reconocimiento; aplicación y Cobro pertenecen al mismo Cliente |
| Vínculo Cobro–rendición | FK/aplicación inequívoca y detectable por servidor bajo transacción | **D7-A:** si existe vínculo activo/autorizado de Cobro con rendición, rechazar anulación **antes** de contraasientos; no deducir solo por `COBRO.origen` |
| Historia de aplicaciones | Registros no borrables; corrección futura solo mediante procedimiento de compensación D7-B eventualmente autorizado | D7-A es transitoria y **no** aprueba D7-B ni restitución automática de `V_e` |

**Cardinalidades a decidir:** una declaración puede aplicarse en varias rendiciones parciales; un Cobro podría agrupar varias declaraciones **del mismo Cliente** solo si se justifica y autoriza. No crear por inferencia una rendición transaccional monolítica que cruce Clientes sin pruebas.

**Compatibilidad con `COBRO.origen`:** los literales físicos `REPARTO`, `ONLINE`, `ADMINISTRACION` existen en V1, pero la elección de literal para el nuevo subflujo y la semántica de `idUsuarioRegistrador` deben revisarse con F01 y el contrato UC-29. No introducir otro literal por iniciativa técnica.

## 4. Secuencia transaccional conceptual (todavía NO contrato definitivo)

### T1 — Aceptación online de UC-05 (PE-1)

1. Validar actor REPARTIDOR, Pedido PENDIENTE, asignación vigente y pertenencia; revalidar después de esperas.
2. Observar orden compatible con C3-03: **PEDIDO antes que ASIGNACION_REPARTO** en escenarios que los bloqueen; coordinar CLIENTE/advisories con UC-29 (C3-08).
3. Congelar/derivar `C_e` de cantidades realmente entregadas y precios históricos; incluir adicionales UC-07 **solo si autorizados y existentes**.
4. Registrar ENTREGA, cantidades, cargos, movimientos físicos y `D_e` íntegro de manera atómica e idempotente.
5. Validar `V_e` **solo conforme a fórmula y pertenencia aún pendientes de ratificación**, exclusivamente de la entrega; si la validación no está definida, **no habilitar efecto provisional**.
6. No insertar `COBRO`, `MOVIMIENTO_CAJA` ni asiento PAGO por la mera declaración. Rollback de todo el comando ante fallas.

### T2 — Rendición administrativa de UC-29 (PE-2)

1. Autenticar ADMINISTRADOR y validar cierre de recorrido, receptor de efectivo, evidencia y conjunto de declaraciones.
2. Asignar explícitamente dinero recibido a aplicaciones de esa entrega; no aplicar Cobros a otros Pedidos ni deuda antigua a través de UC-05.
3. Bloquear Cliente/declaración/Cobro en orden global aún sujeto a decisión C3; revisar advisory `2929001` y generadores.
4. En una unidad de commit autorizada: insertar `COBRO(CONFIRMADO)`, `MOVIMIENTO_CUENTA(PAGO)`, `MOVIMIENTO_CAJA(INGRESO)`, la aplicación idempotente y **cesar exactamente** la porción `V_e` aplicada; ningún paso `REQUIRES_NEW` aislado.
5. Mantener diferencias y faltantes como pendiente de conciliación sin registrar importes no recibidos ni restaurar deuda automáticamente.
6. Respetar permisos: VENDEDOR mantiene Cobro manual general, pero no puede confirmar rendición. No conceder UC-14 al ADMINISTRADOR por esta elección.

### T3 — Solicitud de anulación (D7-A)

1. Conservar autorización ADMINISTRADOR, motivo obligatorio, F01 y controles actuales para Cobro manual general.
2. Identificar inequívocamente si el Cobro tiene un vínculo con rendición; **bajo protección transaccional que excluya carreras con T2**.
3. Si está vinculado: **rechazar sin ningún cambio de COBRO/Cuenta/Caja/aplicación**, con error estable y sin exponer datos de otros actores. No deshabilitar solo interfaz.
4. Si **no** está vinculado: conservar la anulación manual general y sus contraasientos existentes (sujeta a sus reglas previas).
5. El mecanismo de protección en servicio, SQL o ambos requiere diseño y pruebas; revisar especialmente orden actual `COBRO U → CLIENTE U` de `anularCobroManual`, que puede interactuar con el nuevo T2.

**No se autoriza modificar `CobroManualService` en esta etapa.**

## 5. Riesgos, decisiones y pruebas de aprobación pendientes

| ID | Riesgo / decisión pendiente | Gate |
|---|---|---|
| F01 | Cálculo exacto de `C_e` con parciales, precio congelado, adicional UC-07 y cargos históricos | RD de cálculo antes de implementar |
| F02 | **Regla aprobada D5-B/ANT-01:** anticipos y Cobros previos confirmados imputados a esa entrega **reducen** el pendiente reconocible; falta diseño de evidencia/vínculo y anti-sobrepago | Vinculación canónica por obligación, cálculo con parciales y prueba de elegibilidad |
| F03 | Congelamiento o historial de `V_e` y cambios posteriores | Elegir P1-A o P1-B, revisión de D9 y D10 |
| F04 | Materialización de recorrido y unidad atómica de rendición | Decidir si cabecera + aplicaciones, y qué pasa si una de N aplicaciones falla |
| F05 | Distinción entre efectivo realmente recibido vs declarado vs aplicado; diferencia sin cobro | F04-002/005, casos parciales, cero y exceso |
| F06 | D7-A frente a contrato de anulación UC-29/REV05; prohibición solo para vínculos de rendición | Revisar contrato y mecanismo de validación SQL/servicio |
| F07 | Opciones físicas PE-1/PE-2 y CR-B0-F04-001 / D12; offline PE-3 separado | Elegir alcance y autorizar CR física, sin inferir aprobación por D5/6/7 |
| F08 | Orden de locks, generadores, FK, triggers, idempotencia, rollback, carreras de anulación | Campaña C3 adicional y tests físicos EFÍMEROS una vez autorizados |
| F09 | Representación y proyección por rol D9; admin no hereda UC-14 | Revisar BC07 y RBAC; no incluir datos de terceros |
| F10 | Compatibilidad con tablas y datos existentes (ENTREGA histórica, nombres, claves únicas, V1–V3) | Preflight/rollback/backfill de una migración futura, **no crear V4 ahora** |

### Pruebas obligatorias para un futuro laboratorio autorizado (ninguna ejecutada por esta PR)

- Primera entrega con declaración y reconocimiento aislado.
- Entrega parcial y UC-07 adicionales en contrato autorizado.
- UUID repetido con igual contenido, UUID distinto para mismo Pedido, UUID con otro contenido y replay tras respuesta perdida.
- Declaración `D_e > C_e` y `V_e` no determinado por saldo global.
- Cliente con deudas anteriores y entrega nueva: la declaración no cancela deudas históricas.
- Anticipo/Cobro previo **confirmado y efectivamente imputado** al mismo Pedido: debe disminuir el reconocimiento elegible de esa entrega. Cobro solo referido por `idPedido`, Cobro de otro Pedido y Cobro general no vinculado: no imputar por conjetura.
- Rendición total/parcial, varios Clientes, faltantes y exceso físico.
- Dos Administradores rindiendo la misma declaración simultáneamente y dos Cobros sobre el mismo reconocimiento.
- `anularCobroManual` sobre Cobro de rendición: **rechazo D7-A sin efectos**; sobre Cobro general no vinculado: anulación vigente conserva contraasientos.
- Anulación concurrente con inserción de aplicación: no carrera TOCTOU ni deadlock `40P01`.
- Rollback tras Cobro y antes de Caja/aplicación; saldo confirmado/provisional coherente.
- `PG` logs: `pg_locks`, `pg_blocking_pids`, SQLSTATE, snapshots; no confundir timeout con deadlock.
- Privilegios de base, llamadas HTTP 401/403, ámbito de Repartidor y proyección administrativa, sin conceder UC-14.
- Diferencia pendiente F04-005 sin reclasificar automáticamente EN_MORA ni restablecer deuda.

### 5.1 Nuevo asiento funcional: D5-B / ANT-01 (15/11/2026)

**Decisión expresa del responsable:** “un anticipo o Cobro previo, asociado explícitamente a ese mismo Pedido, debe descontarse del importe que el Repartidor puede reconocer al entregar”. Interpretación estricta de ingeniería: solo importes **confirmados y cuya aplicación a la obligación de esa entrega se pueda demostrar**. Deben ser deducidos al calcular el **pendiente elegible por entrega**, no al reescribir el cargo histórico `C_e`, que permanece como valor de venta efectivamente entregada.

**Invariantes obligatorias de negocio:**
- Nunca aplicar un anticipo de otro Pedido, una deuda antigua o un Cobro general no imputado para reducir la obligación de esta entrega.
- No reconocer provisionalmente una porción de la misma entrega que ya esté cubierta por pago definitivo previo.
- Conservar íntegra la declaración de efectivo del Repartidor; cualquier exceso es asunto de conciliación, no crédito/cobro automático.
- Mantener la distinción entre **cargo de la entrega**, **pagos confirmados atribuibles**, **declaración íntegra**, **reconocimiento provisional** y **aplicaciones definitivas**.
- Si solo existe `COBRO.idPedido` sin una imputación acreditable, el diseño debe resolver el vínculo o bloquear la atribución; no inferir un descuento comercial por ese campo aisladamente.

**Ejemplo únicamente ilustrativo:** cargo de la entrega 10.000 ARS; anticipo confirmado y atribuible a esa obligación de 3.000 ARS; pendiente comercial antes de la declaración 7.000 ARS. Si el Repartidor declara 8.000 ARS, la declaración debe persistirse por 8.000 ARS, pero **no se puede reconocer automáticamente todo ese importe**. Este ejemplo no fija `V_e` ni su tope algorítmico, redondeos ni tratamiento final del exceso.

**Criterio de prueba a incorporar:** cobro previo válido de igual Pedido, pagos parciales con entrega parcial, pago de deuda histórica, mismo Cliente con dos Pedidos, pago general sin atribución, pago anulado, respuesta perdida, concurrencia UC-29/UC-05 y reintento idempotente. Ninguna prueba de esta decisión fue ejecutada en R08.3.

**Próximos subcortes propuestos (desglose de R08–R09; no modifica G0):** R08.4 contrato de cálculo `C_e/P_e/V_e` → R08.5 conciliación de UC-05/UC-29 y decisiones D1/D2/D3/D9/D10/D12 → R08.6 CR física y autorización/ensayo PostgreSQL efímero → R09 implementación online UC-05 y rendición D6-1 por incrementos revisables. El plazo objetivo del 12/12 exige paralelismo prudente, no anticipar gates.

## 6. Ruta de autorización y relación con el Roadmap

1. Conservar las decisiones funcionales **D5-B/D6-1/D7-A** en PR #50 y R08.2 PR #51; **conciliar REV05/UC-29 antes de codificar D7-A**.
2. Aplicar la **decisión funcional D5-B/ANT-01** (anticipos/Cobros previos del mismo Pedido reducen el pendiente reconocible), y luego especificar/ratificar el diseño de `C_e`/`V_e`, el **vínculo verificable de imputación** y la granularidad de rendición. No convertir la aceptación de la regla en aprobación de una fórmula o de nuevas columnas.
3. Conciliar RD-I302-001 PR #44, D1/D2/D3/D9/D10/D12 y la división CR-B0-F04-001 en PE-1 online, PE-2 rendición, PE-3 offline.
4. Presentar el diseño físico/contrato SQL candidato con su prueba de compatibilidad, SQL de prueba y plan de migración **por una aprobación separada**. Este documento NO contiene SQL ejecutable.
5. **Solo después de autorización expresa:** testear en PostgreSQL efímero, incorporar diseño definitivo a implementación, crear migraciones, realizar CI y revisar. No rebase, amend o force-push.
6. Preparar UC-05 online y PE-2 por cortes independientes, sin habilitar escrituras productivas ni declarar I3-02 cerrada sin UC-07/41.
7. D7-B (contraaplicación) queda **futura/no ratificada**; el bloqueo D7-A no debe presentarse como compensación financiera completa.

### Estado de salida de R08.3

- **Listo para revisión:** alternativas físicas y garantías de negocio de PE-1/PE-2, con D7-A incorporada.
- **Pendiente de decisión:** algoritmo por entrega, cardinalidades, recorrido, D1/D2/D3/D9/D10/D12, contratos y esquema.
- **No ejecutado ni autorizado:** DDL, migración, servicios, bases de laboratorio, despliegue, ratificación integral de PR #44.

**Dictamen:** expediente R08.3 de diseño físico candidato, independiente del código. La aprobación funcional D5-B/D6-1/D7-A no habilita desarrollo hasta resolver las puertas de contrato, esquema y pruebas.
