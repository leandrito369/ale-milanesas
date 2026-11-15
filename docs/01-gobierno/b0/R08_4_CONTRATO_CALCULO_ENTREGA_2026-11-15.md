# R08.4 — Contrato de cálculo por entrega UC-05 y anticipos ANT-01

**Fecha:** 15/11/2026

**Estado:** PROPUESTO — BORRADOR PARA REVISIÓN FUNCIONAL Y DE ARQUITECTURA

**Alcance:** especificación y trazabilidad; sin implementación, DDL, migraciones ni autorización de despliegue

**Dependencias paralelas:** R08.5-A / conciliación UC-05–UC-29

## 1. Propósito y límites

Este documento define las magnitudes, invariantes, alternativas de cálculo y pruebas de aceptación necesarias para reconocer el efectivo declarado durante una Entrega de UC-05. No ratifica una fórmula por inferencia y no declara implementados UC-05, PE-1 ni PE-2.

Se preservan estas separaciones:

- el cargo real de una Entrega no es el total original completo del Pedido cuando existen cantidades parciales, ajustes o adicionales;
- una declaración del Repartidor no es un Cobro confirmado ni un movimiento de Caja;
- el saldo confirmado global del Cliente no demuestra la cancelación de una obligación concreta;
- la aceptación central es distinta de una captura offline;
- el reconocimiento original debe distinguirse de la porción que continúa vigente después de aplicaciones administrativas.

Este corte no modifica contratos REV04B/REV05, PR #44/#50/#51/#52, código, Flyway, G0, permisos ni datos.

## 2. Fuentes verificadas y SHAs

### 2.1 Repositorios

| Fuente | SHA verificado al 15/11/2026 | Estado usado |
|---|---|---|
| `leandrito369/ale-milanesas` `main` | `cdd57ed194268f1f5ab29aa0f55781ddddebdfb5` | base de esta rama |
| PR #44 — RD-I302-001 | `e5e82f843f8a579e3201a332c645f62680d56832` | OPEN / DRAFT; propuesta original |
| PR #50 — RD-I302-002 | `c36920e09f6ea57a96e246592ffa01be72c65e56` | OPEN / DRAFT; asiento de D5-B/D6-1/D7-A |
| PR #51 — R08.2 | `a1c5492def2e8f72f5def376cc0346d02292eccb` | OPEN / DRAFT; diseño previo |
| PR #52 — R08.3 | `adf77bc2c4f3d7e88a1c301926bdd607dd6a4a78` | OPEN / DRAFT; diseño físico candidato y ANT-01 |
| PR #47 — CR-C UC-07 | `9c0a54e4a2147f5f048f7827f26a21b1bfeecf1b` | OPEN / DRAFT; no autorizado para implementar |
| PR #48 — CR-F UC-07 | `fda51c929258dc42e71c40c95bbcd89d0324c306` | OPEN / DRAFT; no autorizado para implementar |
| `leandrito369/ale-milanesas-app` `main` | `4dbe38668fc5cbc08d04e10920e3bf165c71be11` | inspección de esquema y servicios, solo lectura |

### 2.2 Documentos y artefactos leídos

- REV04B UC-05 y REV05 UC-29 consolidados.
- RD-F04-002 a RD-F04-007 y RD-F01.
- RD-I302-001, RD-I302-002, R08.2 y R08.3 completos en los HEAD indicados.
- CR-C #47 y CR-F #48 para los adicionales históricos de UC-07; continúan como candidatos.
- Flyway V1 `V1__baseline_mr5.sql`, V2 `V2__f01_cobro_estados.sql` y V3 `V3__trazabilidad_partidas_insumo.sql`.
- `CobroManualService`, `CargarPedidoService`, `AplicarAjusteComercialService` y `EvaluadorCategoriaComercialInterno`.

Los documentos de PR abiertas se usan como fuentes de propuesta y de decisiones comunicadas; su mera lectura no los fusiona ni convierte estructuras físicas candidatas en autorización.

## 3. Estado normativo de las reglas

| ID | Regla | Estado en este contrato |
|---|---|---|
| D5-B | El efectivo de UC-05 se imputa exclusivamente a la Entrega actual; nunca cancela otro Pedido ni deuda anterior. | APROBADA FUNCIONALMENTE; obligatoria |
| ANT-01 | Solo un pago previo CONFIRMADO y efectivamente imputado a la obligación de ese Pedido reduce el pendiente reconocible. | APROBADA FUNCIONALMENTE; obligatoria |
| D6-1 | La rendición es subflujo administrativo exclusivo del ADMINISTRADOR dentro de UC-29. | APROBADA FUNCIONALMENTE; conciliación REV05 pendiente |
| D7-A | Bloqueo temporal de anulación de Cobros vinculados a rendición. | APROBADA FUNCIONALMENTE; diseño y conciliación REV05 pendientes |
| D2=B | Se conserva íntegramente el efectivo declarado, aun si excede el pendiente. | DECISIÓN EXPRESADA; asiento integral en RD-I302-001 pendiente |
| EX-01 | El exceso no crea crédito, Cobro ni Caja automáticamente. | REGLA OBLIGATORIA comunicada |
| F04 | El tránsito puede afectar el saldo exigible provisional sin alterar el saldo confirmado. | APROBADA en RD-F04; cuantificación de `V_e` pendiente |
| CAL-01 | Fórmula exacta de `C_e`, elegibilidad y `V_e`. | NO RESUELTA; alternativas de este documento |
| CAL-02 | Redondeo y reparto de ajustes/promociones en entregas parciales. | NO RESUELTA |
| IMP-01 | Evidencia canónica de aplicación de un Cobro previo a una obligación concreta. | BRECHA BLOQUEANTE |

## 4. Magnitudes financieras y unidades

Todas las magnitudes monetarias se expresan en ARS. La persistencia vigente usa `NUMERIC(18,2)` para Cobros, movimientos de Cuenta e importes adicionales; las cantidades usan escala 3 y los precios unitarios históricos escala 4. La política de redondeo del nuevo cálculo todavía debe ratificarse.

### 4.1 `C_e` — cargo real de la Entrega

`C_e` es el cargo comercial de la Entrega `e`, derivado de las cantidades efectivamente entregadas y de valores históricos autorizados. Debe abarcar, sin doble conteo:

1. cantidades originales efectivamente entregadas por cada detalle;
2. precios históricos congelados y promociones históricas aplicables;
3. el ajuste comercial histórico del Pedido según una regla explícita para parciales;
4. adicionales UC-07 efectivamente aceptados, entregados y valorizados por su snapshot autorizado, si UC-07 llega a autorizarse e integrarse.

No se permite definir `C_e = PEDIDO.totalOriginal` salvo que una prueba demuestre que la Entrega comprende exactamente todo el Pedido, sin parcialidad ni adicionales y con el mismo alcance comercial. La autoridad contable esperada es el único `MOVIMIENTO_CUENTA` de tipo `CARGO_POR_VENTA` cuyo `ORIGEN_MOVIMIENTO_CUENTA.idPedidoEntrega` identifica `e`; el algoritmo que produce ese importe aún requiere decisión.

### 4.2 `P_e` — pagos previos aplicados

`P_e` es la suma de las porciones de pagos previos que, antes del punto de serialización de UC-05:

- pertenecen al mismo Cliente y a la obligación de `e`;
- están CONFIRMADAS y no ANULADAS;
- tienen una aplicación financiera explícita, íntegra y auditable hacia esa obligación;
- no fueron consumidas por otra obligación ni computadas antes en `P_e`.

`COBRO.idPedido`, por sí solo, no satisface esta definición. Tampoco la satisface el saldo global del Cliente ni una heurística FIFO no asociada a la obligación.

### 4.3 `D_e` — efectivo declarado

`D_e` es el importe íntegro no negativo declarado por el Repartidor para `e`. Se conserva exactamente como declaración aceptada por el servidor, incluso si supera el pendiente elegible. No es un pago confirmado ni genera por sí mismo Cobro, Caja, crédito o aplicación.

### 4.4 `V_e^0` y `V_e^vig(t)` — reconocimiento provisional

- `V_e^0` es el importe originalmente reconocido por el servidor al aceptar centralmente UC-05.
- `V_e^vig(t)` es la porción de ese reconocimiento que continúa produciendo efecto provisional en el instante `t`, después de aplicaciones administrativas definitivas y de cualquier corrección futura expresamente autorizada.

Invariantes mínimas:

- `0 <= V_e^0 <= D_e`;
- `V_e^0` solo puede referirse a pendiente elegible de `e`;
- `0 <= V_e^vig(t) <= V_e^0` mientras no exista una decisión que autorice incrementos posteriores;
- un mismo tramo monetario no puede integrar simultáneamente `V_e^vig(t)` y una aplicación definitiva activa.

La persistencia candidata debe conservar `V_e^0`; no alcanza con sobrescribir un saldo corriente.

### 4.5 `A_e(t)` — tránsito convertido en Cobro definitivo

`A_e(t)` es la suma acumulada de porciones de `V_e^0` convertidas válidamente, hasta `t`, en Cobros definitivos mediante la rendición D6-1. Cada porción exige una aplicación inequívoca y atómica entre tránsito, Cobro, Cuenta y Caja. Debe cumplirse `0 <= A_e(t) <= V_e^0`.

En el primer modelo candidato, sin correcciones ni contraaplicaciones autorizadas, se espera `V_e^vig(t) = V_e^0 - A_e(t)`. Esta igualdad es una **precondición candidata de implementación**, no una autorización de D7-B. Si se admiten correcciones posteriores, deberán representarse como eventos separados y no como edición destructiva.

### 4.6 `Q_e` — diferencias pendientes de conciliación

`Q_e` no debe ser un neto opaco. Es un conjunto auditable de diferencias tipadas y no negativas asociado a `e`. Como mínimo debe distinguir:

- `Q_e^decl`: porción declarada no reconocida provisionalmente;
- `Q_e^rend`: porción reconocida y aún no recibida/aplicada por el Administrador;
- `Q_e^falt`: faltante constatado durante una rendición respecto de la porción presentada.

No se autoriza compensar automáticamente una clase contra otra. Una vista escalar eventual deberá declarar signo, instante y componentes; hasta entonces `Q_e` se trata como composición, no como una única resta ambigua.

## 5. Auditoría de anticipos y evidencia de imputación

### 5.1 Evidencia física disponible

| Objeto | Evidencia que aporta | Límite observado |
|---|---|---|
| `COBRO.idPedido` opcional | El Cobro puede mencionar un Pedido del mismo Cliente. | No expresa importe aplicado, obligación, Entrega ni consumo previo. |
| FK `COBRO(idPedido,idCliente)` | Impide asociar el Cobro a un Pedido de otro Cliente. | No prueba imputación financiera. |
| `COBRO.estadoCobro` | V2 restringe CONFIRMADO/ANULADO. | Estado válido no identifica el destino del importe. |
| `MOVIMIENTO_CUENTA` tipo `PAGO` | Registra el crédito confirmado a nivel Cliente. | No asigna el crédito a un cargo determinado. |
| `ORIGEN_MOVIMIENTO_CUENTA.idCobro` | Traza un movimiento de pago a su Cobro. | Es excluyente de `idPedidoEntrega`; no vincula pago y cargo entre sí. |
| `ORIGEN_MOVIMIENTO_CUENTA.idPedidoEntrega` | Traza un cargo a una Entrega. | No registra aplicaciones recibidas por ese cargo. |
| `ENTREGA` / `DETALLE_ENTREGA` | Identifican entrega y cantidades efectivas. | No contienen pago previo, declaración ni reconocimiento. |
| `IMPUTACION_ENTREGA_ADICIONAL` | Registra cantidad e importe adicional por movimiento UC-07. | No está integrada/autorizada como solución de anticipos. |
| `CobroManualService` | Valida que el Pedido opcional pertenezca al Cliente y no esté cancelado. | Crea pago/caja por el importe total, sin aplicación a la obligación. |
| `EvaluadorCategoriaComercialInterno` | Consume créditos definitivos contra deudas del Cliente por FIFO. | La imputación es global y temporal; no demuestra destino contractual por Pedido. |

### 5.2 Conclusión de la auditoría ANT-01

El modelo vigente **no ofrece evidencia física suficiente para calcular `P_e` de forma inequívoca**. Un Cobro confirmado con `idPedido=e.idPedido` es información relevante, pero no prueba cuánto de ese Cobro fue aplicado al cargo de `e`, si se aplicó primero a otra deuda por la lógica FIFO o si una parte ya fue consumida.

Consecuencia: interpretar `COBRO.idPedido` como `P_e` podría descontar dos veces un pago o atribuirlo a una obligación distinta. Interpretar la ausencia de vínculo como `P_e=0` podría reconocer nuevamente efectivo sobre una obligación ya pagada. Ambas rutas son inseguras.

**Gate IMP-01:** antes de implementar una fórmula que use `P_e`, debe existir un contrato y evidencia canónica de aplicación por obligación, con importes parciales, unicidad, historia, estado y serialización. La definición física corresponde a una CR posterior; este documento no la crea.

## 6. Alternativas de cálculo de `C_e`

### C1 — Cálculo por componentes históricos y redondeo final

1. Calcular cada base original con cantidad efectivamente entregada, precio histórico y promoción congelada.
2. Sumar bases originales con precisión suficiente.
3. Aplicar el ajuste histórico del Pedido según una regla aprobada para parciales.
4. Sumar importes UC-07 aceptados que correspondan a cantidades efectivamente entregadas.
5. Redondear una vez el resultado monetario final a dos decimales.

**Ventajas:** evita reutilizar el total completo; conserva la relación con cantidades reales.

**Riesgos:** no está decidido si el ajuste global se prorratea, se reaplica porcentualmente o se asigna con residuo; tampoco si el adicional UC-07 participa del ajuste histórico.

**Decisión requerida:** método de ajuste parcial, orden promoción/ajuste/adicional y `HALF_UP` u otro modo.

### C2 — Prorrateo del total histórico original más adicionales

Prorratear `PEDIDO.totalOriginal` según la proporción de bases históricas originales efectivamente entregadas y sumar adicionales UC-07.

**Ventajas:** reconcilia el conjunto de entregas con el total congelado si se define una regla de residuo.

**Riesgos:** puede distribuir centavos y ajustes de forma no intuitiva; el Pedido vigente admite una única Entrega, por lo que los parciales son cantidades no entregadas, no varias entregas; requiere resolver denominador cero y líneas técnicas.

**Decisión requerida:** base del prorrateo, destinatario del residuo y tratamiento de promociones/adicionales.

### C3 — Importe canónico persistido por detalle entregado

Un cálculo autorizado produce y congela el importe comercial de cada detalle entregado; `C_e` es la suma de esos importes y de adicionales inequívocos.

**Ventajas:** máxima auditabilidad y replay exacto.

**Riesgos:** exige diseño físico, regla de generación y compatibilidad con V1; no está autorizado en este corte.

**Decisión requerida:** autoridad del snapshot, granularidad, correcciones y vínculo con el cargo contable.

**Recomendación técnica sobre `C_e`:** seleccionar C1 como especificación algorítmica inicial solo después de ratificar el tratamiento de ajuste y redondeo; usar C3 como dirección de evidencia si la auditoría y el replay requieren reconstrucción exacta. C2 queda como alternativa si Negocio exige reconciliación exacta con `totalOriginal` para parciales. Ninguna está aprobada por este documento.

## 7. Alternativas para elegibilidad y `V_e^0`

### V1 — Tope matemático con aplicación previa demostrable

Como fórmula **candidata**, y únicamente si IMP-01 está resuelto:

```text
E_e = max(0, C_e - P_e)
V_e^0 = min(D_e, E_e)
```

Precondiciones: `C_e` definitivo en la misma transacción; `P_e` canónico, confirmado y no duplicado; snapshot serializado frente a anulaciones/rendiciones; escala y redondeo aprobados.

Contraejemplos que invalidan su uso inmediato:

- `P_e` inferido solo desde `COBRO.idPedido`;
- Cobro anulado o anulado concurrentemente;
- parcialidad cuyo ajuste comercial aún no tiene regla;
- adicional UC-07 no autorizado o contabilizado dos veces;
- crédito global del Cliente proveniente de otro Pedido.

**Ventaja:** simple y consistente con D5-B/ANT-01 bajo precondiciones fuertes.

**Riesgo:** oculta errores de atribución si `P_e` no es una aplicación real.

**Estado:** PROPUESTA; no ratificada.

### V2 — Reconocimiento diferido por ambigüedad

Persistir `D_e`, pero fijar ausencia de efecto provisional mientras no pueda acreditarse `C_e - P_e`; la validación administrativa posterior crea el primer reconocimiento autorizado.

**Ventaja:** evita doble imputación con el esquema actual.

**Riesgo:** no satisface de inmediato el efecto provisional esperado por F04 y agrega una etapa operativa.

**Estado:** alternativa segura de contingencia; requiere decisión funcional.

### V3 — Libro de decisiones de reconocimiento

El servidor registra una decisión inmutable que contiene `C_e`, aplicaciones previas acreditadas, regla/versionado, `D_e`, `V_e^0` y motivos de exclusión. El cálculo puede usar V1 u otra fórmula ratificada, pero su evidencia queda explícita y las correcciones son eventos.

**Ventaja:** permite auditoría, reintento y evolución sin sobrescribir historia.

**Riesgo:** mayor superficie física y necesidad de CR; no resuelve por sí solo la semántica de `P_e`.

**Estado:** dirección técnica recomendada, no autorizada.

### V4 — Reconocimiento manual por Administrador

El Repartidor solo declara; un Administrador determina luego `V_e^0` con evidencia de aplicaciones.

**Ventaja:** contiene la ambigüedad inicial.

**Riesgo:** mezcla aceptación de Entrega con UC-29, introduce demora y puede contradecir la experiencia operativa esperada.

**Estado:** alternativa de respaldo, requiere decisión expresa.

**Recomendación:** resolver IMP-01 y CAL-02; luego ratificar V1 como fórmula o descartarla. Si el vínculo de aplicación no está disponible para R08.6, usar V2 solo como prototipo de persistencia sin afirmar que UC-05 está funcionalmente completa. V3 es la forma preferida de hacer auditable cualquier fórmula aprobada.

## 8. Reglas transversales de cálculo

### 8.1 Pagos previos y anulaciones

- Solo porciones confirmadas, vigentes y aplicadas a `e` pueden integrar `P_e`.
- Un Cobro ANULADO no integra `P_e`.
- La anulación concurrente debe serializarse con el snapshot de UC-05; no se admite leer CONFIRMADO y confirmar UC-05 después de que el Cobro haya sido anulado sin recomputar.
- D7-A solo bloquea Cobros vinculados a rendición; no convierte todos los Cobros manuales en inmutables.

### 8.2 Entregas parciales, promociones y adicionales

- Las cantidades no entregadas no generan `C_e`.
- Los precios y promociones deben ser los históricos autorizados, no valores maestros vigentes al entregar.
- El ajuste comercial congelado no puede reaplicarse sin una regla explícita de parcialidad.
- Un adicional UC-07 cuenta una sola vez, solo si su aceptación, cantidad entregada e importe histórico son válidos.
- CR-C/CR-F abiertas no autorizan usar estructuras UC-07 en producción.

### 8.3 Exceso, cargo cero y saldo a favor

- `D_e` se conserva íntegro aunque exceda el pendiente.
- La porción no reconocida permanece diferenciada; no se transforma automáticamente en crédito, Cobro, Caja ni pago de otra deuda.
- Con `C_e=0`, ninguna declaración puede generar reconocimiento contra otra obligación; el tratamiento operativo de la declaración requiere decisión, pero debe conservarse o rechazarse de forma explícita e idempotente.
- Un saldo global a favor no prueba qué obligación originó el crédito y no reemplaza `P_e`.

### 8.4 Concurrencia e idempotencia

- La misma clave y el mismo contenido deben devolver el mismo resultado original, incluidos `C_e`, `P_e` acreditado, `D_e` y `V_e^0`.
- La misma clave con contenido distinto debe rechazarse sin efectos.
- Dos UC-05 sobre el mismo Pedido no pueden crear dos Entregas ni dos reconocimientos.
- UC-05 y UC-29 deben serializar aplicaciones para que una porción no permanezca a la vez provisional y definitiva.
- El punto de serialización y el orden de locks se coordinan con C3; este documento no los aprueba.

## 9. Matriz de trazabilidad

| Fuente / decisión | Regla trazada | Magnitud | Pruebas |
|---|---|---|---|
| REV04B UC-05 | cantidades efectivamente entregadas; declaración en Entrega | `C_e`, `D_e` | T01, T05, T14, T15 |
| RD-F04-002 / D6-1 | rendición exclusiva Administrador en UC-29 | `A_e`, `Q_e` | T16, T18, T19 |
| RD-F04-003 | separar saldo confirmado y exigible provisional | `V_e^vig` | T18, T20, T26 |
| RD-F04-004 / D2=B | conservar declaración íntegra | `D_e`, `Q_e^decl` | T06, T21 |
| RD-F04-005 | faltante queda pendiente de conciliación | `Q_e^falt` | T19 |
| RD-F04-006/007 | tránsito no equivale a crédito confirmado | `V_e^vig` | T20, T26 |
| D5-B | no aplicar a otro Pedido/deuda | `P_e`, `V_e^0` | T07, T08 |
| ANT-01 | descontar solo anticipo confirmado y aplicado | `P_e` | T02–T05, T09–T11, T23 |
| D7-A | bloquear anulación de Cobro de rendición | `A_e`, `V_e^vig` | T16, T22 |
| V1–V2 / `CobroManualService` | estados y Cobro manual sin aplicación por obligación | `P_e` | T09–T11, T22 |
| `EvaluadorCategoriaComercialInterno` | FIFO global no es imputación contractual | `P_e` | T07, T08, T20 |
| CR-C/CR-F UC-07 | adicional histórico candidato | `C_e` | T12, T24 |

## 10. Matriz de pruebas de aceptación

Los importes exactos de `V_e^0` marcados como “según fórmula ratificada” no pueden fijarse antes de resolver CAL-01/CAL-02/IMP-01. Las invariantes sí son obligatorias.

| ID | Escenario y entradas mínimas | Resultado esperado | Invariante principal | Autorización |
|---|---|---|---|---|
| T01 | Entrega completa; `C_e=10.000`, sin pago aplicado, `D_e=10.000` | Conservar `D_e`; calcular `V_e^0` según fórmula ratificada | solo obligación actual | Fórmula PENDIENTE |
| T02 | Completa; `C_e=10.000`, `P_e=3.000` demostrado, `D_e=7.000` | El tramo aplicado reduce el pendiente elegible | no reconocer los 3.000 otra vez | ANT-01 aprobada; fórmula pendiente |
| T03 | `P_e=C_e` con aplicación demostrada; `D_e>0` | `V_e^0=0`; declaración/exceso no crea crédito | obligación ya cubierta | Derivable de ANT-01 |
| T04 | `P_e>C_e` por inconsistencia o crédito sobreasignado | Bloquear cálculo y conciliar; nunca pendiente negativo ni traslado | no netear con otros Pedidos | Manejo PENDIENTE |
| T05 | Entrega parcial; solo parte de cantidades originales; anticipo aplicado | `C_e` excluye no entregado; `P_e` solo hasta la obligación atribuible | no usar `totalOriginal` completo | Ajuste parcial PENDIENTE |
| T06 | `D_e` superior al pendiente elegible | Persistir `D_e` íntegro; exceso tipado en `Q_e^decl` | sin crédito/Cobro/Caja automático | Regla aprobada; fórmula pendiente |
| T07 | Dos Pedidos del mismo Cliente; Cobro aplicado al Pedido A; entrega B | `P_B` no incluye el Cobro de A | aislamiento D5-B | Aprobado |
| T08 | Deuda anterior independiente y entrega actual | El efectivo de la Entrega no cancela deuda anterior | aislamiento por obligación | Aprobado |
| T09 | Cobro CONFIRMADO con `idPedido`, sin aplicación demostrable | No tratarlo automáticamente como `P_e`; bloquear o diferir reconocimiento | `idPedido` no prueba imputación | Gate IMP-01 |
| T10 | Cobro previo ANULADO | Excluirlo de `P_e` | solo pagos vigentes | Aprobado por estado; cálculo pendiente |
| T11 | Dos Cobros previos con aplicaciones parciales a la misma obligación | Sumar solo porciones activas, sin duplicar ni superar lo aplicado | unicidad de aplicación | Diseño físico PENDIENTE |
| T12 | Adicional UC-07 entregado con snapshot histórico autorizado | Incorporar exactamente una vez al `C_e` conforme contrato UC-07 | sin precio maestro actual | Depende de autorización UC-07 |
| T13 | Promoción/descuento congelado y entrega parcial | Usar valores históricos; asignar ajuste según regla ratificada | no recalcular política vigente | CAL-02 PENDIENTE |
| T14 | Captura offline sin aceptación central | No crear `V_e^0`, Cobro, Caja ni cargo central | captura no equivale a aceptación | Aprobado |
| T15 | Dos UC-05 concurrentes sobre el mismo Pedido | Una sola Entrega/decisión; la otra reusa o rechaza conforme idempotencia | no doble cargo/reconocimiento | Protocolo C3 PENDIENTE |
| T16 | UC-29 rinde mientras UC-05 intenta aceptar | Serializar; cada porción queda provisional o definitiva, nunca ambas | cese atómico | D6-1 aprobada; protocolo pendiente |
| T17 | Replay con misma clave y mismo contenido | Mismos importes y resultado, sin filas ni efectos nuevos | replay comercial completo | Semántica física PENDIENTE |
| T18 | Rendición parcial de `V_e^0` | Aumenta `A_e`; reduce por igual `V_e^vig`; resto sigue trazado | `A_e + V_e^vig = V_e^0` bajo modelo inicial | Candidata, requiere PE-2 |
| T19 | Faltante constatado en rendición | Registrar diferencia tipada; no restablecer deuda ni crear Caja ficticia | conciliación separada | RD-F04-005; diseño pendiente |
| T20 | Saldo global del Cliente distinto del pendiente de `e` | Calcular por obligación; ignorar saldo global como prueba | no usar agregado como imputación | Aprobado |
| T21 | `C_e=0`, `D_e>0` | `V_e^0=0`; conservar o rechazar declaración según decisión explícita | no aplicar a otra deuda | Operativa PENDIENTE |
| T22 | Anulación concurrente de Cobro previo o Cobro de rendición | Snapshot serializado; D7-A rechaza solo el vinculado a rendición | no estado mixto ni doble cómputo | D7-A aprobada; locks pendientes |
| T23 | Cobro confirmado sin `idPedido`, pero con supuesto verbal de destino | No integrar `P_e` sin aplicación canónica | evidencia, no intención | Gate IMP-01 |
| T24 | Adicional UC-07 no aceptado, revertido o no entregado | Excluirlo de `C_e` | solo adicional válido y entregado | Depende de UC-07 |
| T25 | Borde de redondeo: cantidad escala 3 × precio escala 4 termina en medio centavo | Resultado conforme única regla ratificada y reproducible | mismo importe en replay/cargo | CAL-02 PENDIENTE |
| T26 | `D_e=0` con cargo pendiente | `V_e^0=0`; cargo confirmado permanece; sin Caja/Cobro | declarar cero no paga | Derivable; validación de entrada pendiente |
| T27 | Misma clave idempotente con `D_e` o cantidades diferentes | Rechazo sin efectos | identidad de comando ≠ PK Entrega | Diseño de idempotencia pendiente |
| T28 | Respuesta HTTP perdida después del commit | Replay reconstruye exactamente el resultado original | sin nueva lectura recalculada con estado posterior | Diseño de snapshot pendiente |
| T29 | Cobro previo se aplica parcialmente a dos obligaciones | Solo la porción canónica de `e` integra `P_e`; suma de aplicaciones no supera Cobro | conservación monetaria | Diseño físico PENDIENTE |
| T30 | `P_e` cambia entre validación y commit | Recalcular bajo lock o abortar; nunca confirmar snapshot obsoleto | consistencia transaccional | Protocolo C3 PENDIENTE |

## 11. Riesgos de doble imputación

| Riesgo | Evidencia | Consecuencia | Mitigación requerida |
|---|---|---|---|
| Usar `COBRO.idPedido` como aplicación | Campo opcional sin importe aplicado; servicio solo valida pertenencia | descontar un Cobro que FIFO consumió en otra deuda | aplicación canónica por obligación |
| Usar saldo global como `P_e` | movimientos y saldo están a nivel Cliente | deuda ajena reduce `V_e^0` | cálculo aislado por Entrega |
| No considerar anticipo real | no existe vínculo físico suficiente | `D_e` reconoce nuevamente una obligación ya pagada | Gate IMP-01 o V2 diferido |
| Mantener `V_e^vig` tras rendición | PE-2 aún no implementado | el mismo dinero reduce provisionalmente y además como Cobro | cese atómico con aplicación |
| Recalcular replay con estado nuevo | no hay snapshot UC-05 vigente | misma operación devuelve o aplica otro valor | resultado comercial persistido |
| Contar adicional en base y en imputación UC-07 | CRs abiertas y cálculo aún no integrado | cargo duplicado | autoridad única por componente |
| Anulación concurrente | estados F01 y D7-A sin protocolo UC-05/29 aprobado | `P_e` o `A_e` queda obsoleto | locks, revalidación y prueba C3 |

## 12. Decisiones que debe tomar el responsable

| ID | Decisión requerida | Opciones principales | Recomendación técnica |
|---|---|---|---|
| DC-01 | Regla de `C_e` para parcialidad | C1, C2 o C3 | C1 con evidencia C3 si se aprueba su persistencia |
| DC-02 | Distribución del ajuste comercial congelado | reaplicar porcentaje; prorratear total; asignar residuo | ratificar regla y ejemplos de centavos antes de código |
| DC-03 | Inclusión de adicionales UC-07 en ajustes/promociones | fuera o dentro del ajuste del Pedido | resolver con contrato UC-07; no inferir |
| DC-04 | Modo y momento de redondeo | por línea; por componente; al final | una regla única, versionada y probada |
| DC-05 | Evidencia canónica de `P_e` | relación de aplicación; libro de aplicaciones; otra autoridad | vínculo explícito con importe, estado e historia |
| DC-06 | Fórmula de `V_e^0` | V1, V2, V3/V1 u otra | V1 solo tras IMP-01; persistir evidencia estilo V3 |
| DC-07 | Tratamiento de `C_e=0` con declaración positiva | aceptar y conservar; rechazar comando | decisión funcional explícita e idempotente |
| DC-08 | Modelo de diferencias `Q_e` | componentes tipados; neto escalar | componentes tipados, sin compensación automática |
| DC-09 | Correcciones posteriores de reconocimiento | no permitir; eventos compensatorios | no sobrescribir; coordinar con D7-B futura |
| DC-10 | Punto de serialización UC-05/UC-29/anulaciones | protocolo C3 específico | decidir después de R08.5-A y ensayar en R08.6 |

## 13. Recomendación técnica y gates

1. Ratificar primero DC-05: sin evidencia de imputación no existe un `P_e` confiable y ninguna fórmula numérica es segura.
2. Ratificar en conjunto DC-01 a DC-04 con ejemplos de entregas parciales, promociones y centavos.
3. Evaluar V1 como fórmula candidata únicamente después de esos gates. Su forma simple no sustituye la prueba de pertenencia financiera.
4. Persistir la decisión original y sus componentes de entrada para distinguir `V_e^0` de `V_e^vig`; preferir historia append-only para aplicaciones y diferencias.
5. Coordinar D6-1/D7-A, locks y cese atómico con R08.5-A antes de una CR física.
6. Si se necesita ensayar antes del cierre financiero, limitar R08.6 a un prototipo aislado de captura y trazabilidad sin efecto provisional, Cobro ni Caja; no declarar UC-05 terminada.

## 14. Condiciones de cierre de R08.4

R08.4 puede considerarse cerrado para revisión cuando el responsable y Arquitectura hayan dejado explícitos:

- la autoridad y algoritmo de `C_e`, incluidos parciales, promociones, ajustes y adicionales;
- la política exacta de escala y redondeo;
- la evidencia física canónica y reglas de conservación para `P_e`;
- la fórmula o procedimiento autorizado de `V_e^0`;
- la representación de `V_e^0`, `V_e^vig`, `A_e` y diferencias `Q_e`;
- la conducta de cargo cero, exceso y replays;
- la coordinación UC-05/UC-29 para rendición, anulación y concurrencia;
- la aceptación de la matriz T01–T30 o sus ajustes trazados.

## 15. Condiciones para iniciar R08.6

R08.6 no debe autorizar implementación productiva. Puede comenzar como CR/ensayo físico efímero cuando:

1. DC-01 a DC-06 estén ratificadas o el experimento se limite expresamente a alternativas sin efecto financiero;
2. IMP-01 tenga una solución candidata trazable;
3. R08.5-A haya conciliado D6-1/D7-A con REV05 y fijado los límites de UC-29;
4. estén definidos identidad idempotente, snapshot de resultado y protocolo de concurrencia a someter a C3;
5. UC-07 adicional tenga una fuente autorizada o quede excluido del ensayo con esa limitación documentada;
6. exista un plan de pruebas que cubra T01–T30, rollback, reintentos y conservación monetaria.

Hasta entonces, el estado es **CONTRATO PROPUESTO CON BRECHA BLOQUEANTE IMP-01**. No se autoriza código productivo, SQL, migración, fusión ni despliegue.

## 16. Validaciones de este corte

- Revisión documental y de trazabilidad sobre los SHAs de §2.
- Inspección estática de V1–V3 y servicios citados, sin modificar el repositorio de aplicación.
- Sin ejecución de SQL, PostgreSQL, migraciones ni pruebas de integración, por restricción del encargo.
- Las pruebas T01–T30 son criterios preparados; **no fueron ejecutadas** en R08.4.

## 17. Anexo IMP-01 — Evidencia de imputación y alternativas

**Corte de auditoría:** complemento incremental sobre PR #53, HEAD inicial `0765de8add7c904d70af9dea20b69b15a9abe64a`.

**Objeto de decisión:** completar el expediente DC-05 sin elegir tablas, DDL ni una fórmula de `V_e^0`.

**Estados de lectura:** D5-B, ANT-01, D6-1 y D7-A se conservan como reglas aprobadas en su alcance; IMP-A, IMP-B e IMP-C son alternativas propuestas; los puntos marcados `[A CONFIRMAR]` requieren decisión del responsable.

### 17.1 Reconstrucción del flujo vigente de un Cobro previo

El flujo implementado en `CobroManualService.registrarCobro` es el siguiente:

1. Exige sesión y rol `ADMINISTRADOR` o `VENDEDOR`, valida importe, medio y clave técnica.
2. Adquiere el advisory lock financiero global `2929001`, vuelve a comprobar autorización y bloquea `CLIENTE FOR UPDATE`.
3. Busca `COBRO.claveIdempotenciaOrigen`. Un replay idéntico devuelve el Cobro existente; la misma clave con datos diferentes se rechaza.
4. Si se informó `idPedido`, lee el Pedido `FOR SHARE` y solo comprueba que exista, pertenezca al Cliente y no esté `CANCELADO`.
5. Crea un `COBRO` CONFIRMADO por el importe completo. `idPedido` continúa siendo opcional.
6. Crea un `MOVIMIENTO_CUENTA` de tipo `PAGO` por el importe completo y actualiza el saldo confirmado global del Cliente.
7. Crea un `ORIGEN_MOVIMIENTO_CUENTA` cuyo único origen es `idCobro`; no enlaza esa fila con el origen `idPedidoEntrega` de un cargo.
8. Crea un `MOVIMIENTO_CAJA` de INGRESO por el importe completo.
9. Ejecuta la reevaluación de categoría comercial del Cliente.

La anulación manual, exclusiva del Administrador, bloquea el Cobro y el Cliente, verifica el pago y la Caja originales, agrega `ANULACION_COBRO` y EGRESO por el importe completo y cambia el Cobro a ANULADO. V1/V2 no registran qué aplicaciones por obligación deberían quedar corregidas porque ese concepto no existe en el modelo vigente.

UC-05 no está implementado en el `main` de aplicación inspeccionado. Por tanto, el modelo actual tampoco genera todavía el cargo de Entrega ni un vínculo físico de anticipo hacia esa obligación.

### 17.2 FIFO global versus imputación comercial explícita

`EvaluadorCategoriaComercialInterno` consulta todos los movimientos del Cliente y:

- acumula como créditos los `PAGO` y `AJUSTE_CREDITO`;
- resta del fondo de créditos los `ANULACION_COBRO`;
- ordena los cargos y ajustes débito por fecha;
- consume el fondo de créditos contra las deudas más antiguas para encontrar la primera deuda impaga y evaluar mora.

La consulta usa `ORIGEN_MOVIMIENTO_CUENTA.idPedidoEntrega` únicamente para obtener la fecha de una deuda desde `ENTREGA`. No consulta `COBRO.idPedido`, no produce registros de aplicación, no conserva porciones por obligación y no devuelve un resultado de imputación reutilizable por UC-05.

| Propiedad | FIFO de evaluación vigente | Imputación comercial requerida por ANT-01 |
|---|---|---|
| Finalidad | Evaluar deuda/mora del Cliente | Probar cuánto pago previo corresponde a la obligación de `e` |
| Alcance | Cuenta Corriente global | Pedido/obligación individual |
| Autoridad de pertenencia | Orden temporal de débitos y fondo global de créditos | Decisión explícita y trazable de aplicación |
| Persistencia de porciones | No | Sí |
| Usa `COBRO.idPedido` | No | No basta por sí solo |
| Corrección histórica | Se recalcula desde movimientos | Debe conservar aplicación y corrección |
| Resultado apto para `P_e` | No | Sí, si cumple las invariantes de §17.7 |

La FIFO puede ser coherente como algoritmo de evaluación global y, al mismo tiempo, insuficiente como prueba contractual. Convertirla retroactivamente en imputación explícita cambiaría la semántica vigente y requiere decisión; este anexo no lo propone como hecho aprobado.

### 17.3 Información existente, inferencias válidas y límites

| Evidencia vigente | Puede afirmarse | No puede afirmarse |
|---|---|---|
| `COBRO.idCobro`, Cliente, importe, fecha, origen, estado | Existió un Cobro por ese importe y se conoce su estado actual. | Qué porción canceló cada obligación. |
| `COBRO.idPedido` opcional + FK compuesta | El Pedido indicado pertenece al mismo Cliente. | Que todo o parte del Cobro fue aplicado a su cargo. |
| Validación de servicio sobre Pedido | Al registrar, el Pedido existía y no estaba cancelado. | Que ya existía una Entrega o cargo; que el Pedido continuó elegible después. |
| `MOVIMIENTO_CUENTA` tipo `PAGO` | El saldo confirmado global recibió el efecto del importe. | Destino comercial por Pedido o Entrega. |
| Origen `idCobro` del movimiento | El PAGO deriva de ese Cobro. | Relación con el cargo cuyo origen es `idPedidoEntrega`. |
| `COBRO.estadoCobro=CONFIRMADO` | El Cobro está vigente según F01 al instante leído. | Que no se esté anulando concurrentemente ni que siga sin consumir en otra obligación. |
| `ANULACION_COBRO` y `idCobroAnulado` | Existe contraasiento global trazable del Cobro. | Cómo revertir porciones de aplicación inexistentes. |
| `PEDIDO` / `ENTREGA` | Identidad, Cliente, estado y existencia de la Entrega. | Importe de anticipo aplicado. |
| FIFO de `EvaluadorCategoriaComercialInterno` | Qué deuda resulta primera impaga bajo ese cálculo y ese conjunto de movimientos. | Una intención contractual, una reserva previa ni un snapshot estable de `P_e`. |
| Saldo a favor global | Los créditos superan los débitos según la Cuenta. | A qué Pedido se reserva el excedente. |

Conclusión probatoria: el esquema vigente demuestra el efecto contable global de un Cobro, pero no el hecho adicional exigido por ANT-01 —la aplicación monetaria efectiva a la obligación concreta—. IMP-01 permanece bloqueante hasta seleccionar una autoridad de imputación.

### 17.4 IMP-A — relación explícita de aplicaciones parciales

**Concepto propuesto:** mantener el Cobro y su PAGO global sin cambios semánticos, y representar por separado aplicaciones monetarias explícitas entre porciones de un Cobro y una obligación identificada. Este anexo no determina tabla, columnas ni nombre físico.

La evidencia mínima de cada aplicación debería permitir identificar:

- Cobro fuente y Cliente;
- obligación destino, inicialmente referenciable por Pedido y consolidable contra su Entrega/cargo;
- importe aplicado;
- estado vigente de la aplicación y motivo de cualquier liberación/corrección;
- identidad idempotente, instante, actor/operación autorizada y versión de concurrencia;
- relación con la evidencia que confirma la existencia y cuantía de la obligación.

| Caso | Tratamiento candidato IMP-A |
|---|---|
| Anticipo antes de `ENTREGA` | Registrar una reserva/designación al Pedido; no computarla como aplicación efectiva de `P_e` hasta validar la obligación según una decisión de lifecycle. |
| Cobro con `idPedido` sin aplicación | Mantenerlo como Cobro global; `idPedido` es indicio, no crea la aplicación. |
| Aplicación parcial | Permitir porciones; el remanente conserva condición de crédito global/no aplicado. |
| Dos Pedidos del mismo Cliente | Exigir aplicaciones separadas; ninguna porción puede estar activa en ambos. |
| Saldo a favor general | No asignarlo automáticamente. Requiere una aplicación posterior autorizada. |
| Pedido cancelado | Impedir nueva aplicación; liberar o reclasificar la reserva solo mediante regla explícita `[A CONFIRMAR]`. |
| Cobro anulado | No puede conservar aplicaciones activas; la desactivación/compensación debe ser atómica con la anulación. |
| Pagos concurrentes | Serializar el total aplicable por Cobro y el total recibido por obligación. |
| Reintentos | Misma identidad y contenido devuelve la misma aplicación; contenido diferente se rechaza. |
| Entrega parcial | Aplicar solo conforme a la porción de obligación autorizada; la distribución y el excedente quedan `[A CONFIRMAR]`. |
| Cuenta Corriente global | Crear o cambiar una aplicación no genera otro PAGO ni modifica nuevamente el saldo. |

**Suficiencia:** IMP-A es la evidencia mínima suficiente para calcular `P_e` si conserva historia, impide sobreaplicación y permite reconstruir el conjunto activo en un snapshot serializado. Una fila mutable sin historia de correcciones no satisface por sí sola el requisito de auditoría.

**Compatibilidad:** puede incorporarse como operación analítica opcional alrededor del Cobro manual general sin redefinir `registrarCobro`: un Cobro continúa generando un único PAGO/Caja global y la aplicación no repite esos efectos. Los roles que crean o corrigen aplicaciones quedan `[A CONFIRMAR]`; no se infieren de UC-29 ni de `idPedido`.

### 17.5 IMP-B — libro inmutable de eventos de imputación y corrección

**Concepto propuesto:** registrar eventos append-only que asignan, liberan o corrigen porciones monetarias, identificando Cobro, obligación, causal, importe, instante e identidad idempotente. El estado actual se obtiene plegando la secuencia; no se editan ni eliminan eventos anteriores.

No se fijan nombres de eventos ni un diseño físico. Semánticamente, el libro debe distinguir al menos:

- designación/reserva antes de existir el cargo;
- aplicación efectiva a una obligación validada;
- liberación por cancelación o inelegibilidad;
- corrección/contraaplicación trazable;
- invalidación coordinada por anulación del Cobro.

| Caso | Tratamiento candidato IMP-B |
|---|---|
| Anticipo antes de `ENTREGA` | Evento de reserva no computable como `P_e` efectivo hasta evento/condición de consolidación autorizada. |
| Cobro con `idPedido` sin evento | No existe aplicación; se conserva el Cobro general. |
| Aplicación parcial | Uno o más eventos por porción, con conservación de suma y remanente. |
| Dos Pedidos del mismo Cliente | Flujos causales separados por obligación; controles contra doble consumo. |
| Saldo a favor general | Permanece fuera del libro de una obligación hasta asignación expresa. |
| Pedido cancelado | Evento compensatorio; nunca borrado de la historia. Destino posterior del crédito `[A CONFIRMAR]`. |
| Cobro anulado | Evento de invalidación/contraaplicación en la misma unidad transaccional o anulación bloqueada hasta completarlo. |
| Pagos concurrentes | Orden total por Cobro/obligación, control de versión y revalidación al confirmar. |
| Reintentos | Identidad única por comando/evento y reconstrucción determinista del resultado. |
| Entrega parcial | Eventos por porción autorizada; regla de distribución `[A CONFIRMAR]`. |
| Cuenta Corriente global | Los eventos explican destino analítico; no duplican movimientos contables. |

**Suficiencia:** IMP-B ofrece la evidencia más fuerte para `P_e`, porque conserva tanto la aplicación original como su evolución. Facilita auditoría de cancelaciones, anulaciones y reasignaciones, pero exige una CR física y mayor disciplina de proyección, orden y pruebas.

**Compatibilidad:** también puede coexistir con el Cobro manual general sin cambiar su significado contable. Sin embargo, introduce nuevas operaciones de imputación/corrección y requiere coordinar sus autorizaciones con UC-29, sin atribuirlas automáticamente al Vendedor, Administrador o Repartidor.

### 17.6 IMP-C — declaración sin reconocimiento provisional

**Concepto propuesto:** cuando el servidor no puede demostrar `P_e`, conserva la declaración `D_e` y la Entrega aceptada, pero no crea `V_e^0` ni efecto provisional hasta que exista evidencia suficiente.

| Caso | Tratamiento candidato IMP-C |
|---|---|
| Anticipo previo ambiguo | No inferirlo ni fijar `P_e=0`; dejar reconocimiento pendiente. |
| Cobro vinculado por `idPedido` | No usarlo como aplicación. |
| Cobro parcial, saldo a favor o dos Pedidos | No repartir automáticamente. |
| Pedido cancelado / Cobro anulado | Revalidar la elegibilidad; sin reconocimiento previo que revertir. |
| Concurrencia y reintentos | Persistir el mismo resultado “pendiente de evidencia” de forma idempotente. |
| Entrega parcial | Conservar entradas; diferir el reconocimiento hasta resolver cálculo e imputación. |
| Cuenta Corriente global | Sin nuevo efecto provisional, Cobro, Caja ni segundo movimiento. |

**Suficiencia:** IMP-C no calcula `P_e` y no resuelve DC-05. Es un mecanismo de contención seguro para evitar doble reconocimiento y permitir un prototipo de captura, con el costo de diferir el efecto F04 esperado. Requiere aceptación funcional si se pretende usar fuera de un experimento.

### 17.7 Invariantes propuestas para una evidencia canónica

Estas invariantes son criterios técnicos propuestos; no seleccionan estructura física:

1. **Conservación por Cobro:** la suma de porciones activas no supera el importe CONFIRMADO y no anulado del Cobro.
2. **Conservación por obligación:** ninguna aplicación activa supera la porción de obligación autorizada para ese destino.
3. **No doble destino:** la misma unidad monetaria de un Cobro no está activa en dos obligaciones.
4. **Mismo Cliente:** Cobro y obligación pertenecen al mismo Cliente durante toda la aplicación.
5. **Separación contable:** imputar, reservar o corregir no crea un segundo PAGO ni una segunda Caja por el Cobro original.
6. **Estado F01:** un Cobro ANULADO aporta cero a `P_e`; la anulación y la invalidación de sus aplicaciones no dejan una ventana inconsistente.
7. **Reserva no es aplicación:** una designación anterior a la Entrega no integra `P_e` efectivo hasta que la obligación exista y supere la validación autorizada.
8. **Historia:** toda corrección conserva causal, actor/operación, instante y relación con el hecho corregido.
9. **Idempotencia:** replay idéntico no agrega porciones; misma clave con contenido diferente se rechaza.
10. **Snapshot:** el `P_e` utilizado por UC-05 identifica versión/corte y se revalida antes del commit frente a pagos, aplicaciones y anulaciones concurrentes.
11. **D5-B:** UC-05 solo consulta aplicaciones de la obligación de la Entrega actual; no consume saldo general ni aplicaciones de otros Pedidos.
12. **ANT-01:** solo porciones confirmadas, efectivas, vigentes y demostrables integran `P_e`.
13. **No autoridad implícita:** `COBRO.idPedido`, el FIFO y el saldo a favor son indicios/proyecciones, no comandos de aplicación.
14. **D6-1/D7-A:** la imputación de anticipos no concede rendición al Repartidor ni amplía el bloqueo de anulación a Cobros generales ajenos a rendición.

### 17.8 Escenarios de aceptación de DC-05

| ID | Escenario | Resultado exigido a cualquier alternativa elegida | Estado |
|---|---|---|---|
| IMP-T01 | Anticipo CONFIRMADO antes de `ENTREGA`, reservado al Pedido | No integra `P_e` efectivo hasta consolidación autorizada | Lifecycle `[A CONFIRMAR]` |
| IMP-T02 | Cobro con `idPedido`, sin aplicación canónica | `P_e` no aumenta | Obligatorio por ANT-01 |
| IMP-T03 | Cobro de 10.000, aplicación activa 3.000 a la obligación | Solo 3.000 son evidencia candidata de `P_e` | Fórmula `V_e` no aprobada |
| IMP-T04 | Mismo Cobro intenta aplicar los mismos 3.000 a dos Pedidos | Segunda aplicación rechazada o serializada sin doble consumo | Invariante propuesta |
| IMP-T05 | Dos Cobros con porciones válidas hacia una obligación | Sumar solo porciones activas y vigentes | Invariante propuesta |
| IMP-T06 | Dos Pedidos del mismo Cliente y saldo global a favor | No asignar saldo ni Cobro por proximidad/FIFO | D5-B/ANT-01 |
| IMP-T07 | Pedido se cancela después de una reserva | No queda aplicación efectiva al cargo inexistente; conservar historia | Destino del crédito `[A CONFIRMAR]` |
| IMP-T08 | Cobro se anula antes de UC-05 | Sus aplicaciones aportan cero a `P_e` | F01 + invariante |
| IMP-T09 | Cobro se anula concurrentemente con lectura de `P_e` | UC-05 revalida/aborta; no confirma snapshot obsoleto | Locks `[A CONFIRMAR]` |
| IMP-T10 | Dos pagos concurrentes al mismo Pedido | Totales serializados, sin superar Cobros ni obligación | Protocolo C3 pendiente |
| IMP-T11 | Replay idéntico de aplicación | Mismo resultado, sin nueva porción | Invariante propuesta |
| IMP-T12 | Misma clave con otro importe/destino | Rechazo sin efectos | Invariante propuesta |
| IMP-T13 | Entrega parcial menor que la reserva previa | No sobreaplicar; distribución/remanente según decisión explícita | `[A CONFIRMAR]` |
| IMP-T14 | Aplicación se crea/corrige | Saldo confirmado, PAGO y Caja no se duplican | Compatibilidad Cuenta global |
| IMP-T15 | FIFO global asignaría el crédito a una deuda anterior, pero existe aplicación explícita a `e` | Detectar conflicto semántico; no fingir que ambos son la misma evidencia | Precedencia `[A CONFIRMAR]` |
| IMP-T16 | Corrección de una aplicación parcial | Historia original y compensación permanecen auditables | IMP-B o IMP-A versionada |
| IMP-T17 | No hay evidencia suficiente al aceptar la Entrega | IMP-C conserva declaración sin reconocimiento | Alternativa propuesta |
| IMP-T18 | Replay de UC-05 tras cambio posterior de aplicaciones | Devuelve el snapshot original o rechaza según contrato; no recalcula silenciosamente | Semántica `[A CONFIRMAR]` |
| IMP-T19 | Cobro de rendición vinculado a D6-1 intenta anularse | Aplicar D7-A solo al vínculo de rendición | Regla aprobada |
| IMP-T20 | Cobro manual general, no vinculado a rendición | D7-A no lo bloquea por inferencia | Regla aprobada |

Estos escenarios no fueron ejecutados. Deben convertirse en pruebas de servicio, PostgreSQL e intercalados de C3 después de una decisión y CR autorizadas.

### 17.9 Decisiones pendientes para el responsable

| ID | Pregunta de decisión | Impacto si queda abierta |
|---|---|---|
| DC05-01 | ¿La obligación canónica se identifica por Pedido, por Entrega/cargo o por una identidad independiente que atraviesa ambos momentos? | No puede consolidarse un anticipo anterior a la Entrega. |
| DC05-02 | ¿Se admite una reserva previa y qué hecho la convierte en aplicación efectiva? | `P_e` no tiene lifecycle determinista. |
| DC05-03 | ¿Quién puede crear, corregir, liberar o consultar aplicaciones y bajo qué operación contractual? | No hay autorización implementable; no inferir permisos de UC-29. |
| DC05-04 | ¿La imputación explícita prevalece sobre FIFO para `P_e` y cómo se reconcilia con la evaluación global de mora? | Dos lecturas financieras pueden atribuir el mismo crédito de forma distinta. |
| DC05-05 | ¿Qué ocurre con remanentes no aplicados y saldos a favor? | Riesgo de traslado automático a otro Pedido. |
| DC05-06 | ¿Qué ocurre con una reserva/aplicación si el Pedido se cancela? | Puede quedar una obligación inexistente o perderse trazabilidad. |
| DC05-07 | ¿La anulación exige contraaplicación automática, bloqueo previo o flujo administrativo? | Ventana de `P_e` basado en Cobro ANULADO. |
| DC05-08 | ¿Cómo se reparte un anticipo frente a Entrega parcial, promociones, ajustes y adicionales? | No puede determinarse la porción elegible. |
| DC05-09 | ¿Se permiten correcciones/reasignaciones y, en tal caso, se exige un libro append-only? | IMP-A mutable podría perder historia. |
| DC05-10 | ¿Cuál es el punto de serialización y orden de locks con Cobro, aplicación, UC-05, UC-29 y anulación? | Sobreaplicación y snapshots obsoletos. |
| DC05-11 | ¿`COBRO.idPedido` queda como referencia informativa, intención inicial o pasa a tener una semántica contractual nueva? | Riesgo de tratar datos históricos ambiguos como aplicaciones. |
| DC05-12 | ¿Cómo se tratan Cobros históricos sin evidencia canónica? | No es posible reconstruir aplicaciones sin inventarlas. |

### 17.10 Recomendación técnica para DC-05

1. Definir como autoridad mínima una **aplicación monetaria explícita por porción y obligación**, separada del PAGO global. En ese sentido, IMP-A es el mínimo semántico suficiente.
2. Si se autorizan correcciones, liberaciones, cancelaciones o reasignaciones —casos ya previsibles—, preferir IMP-B como fuente canónica append-only y, si resulta útil, una proyección equivalente a IMP-A para consultar el estado activo. Esta recomendación no elige tablas ni DDL.
3. Incorporar la aplicación como operación adicional y opcional permite conservar la semántica de `CobroManualService`: el Cobro general sigue confirmando Cuenta/Caja una sola vez; `idPedido` no aplica dinero automáticamente.
4. Mantener IMP-C como fallback de seguridad cuando falte evidencia. IMP-C no desbloquea el cálculo de `P_e`, pero evita convertir la incertidumbre en doble reconocimiento.
5. No aprobar V1 de §7 hasta resolver DC05-01..12, especialmente la relación entre imputación explícita, FIFO global, parciales y anulaciones.

**Dictamen del anexo:** IMP-01 queda **TÉCNICAMENTE CARACTERIZADA, PENDIENTE DE DECISIÓN DC-05**. IMP-A/IMP-B pueden aportar evidencia suficiente bajo las invariantes anteriores; IMP-C solo contiene el riesgo. No se ha ratificado un esquema físico, una nueva operación, un permiso ni una fórmula de reconocimiento.

### 17.11 Validaciones y límites del complemento

- Fuentes revalidadas: gobierno `main` `cdd57ed194268f1f5ab29aa0f55781ddddebdfb5`; aplicación `main` `4dbe38668fc5cbc08d04e10920e3bf165c71be11`; PR #53 en el HEAD inicial indicado.
- Inspección estática de V1/V2, `CobroManualService`, `EvaluadorCategoriaComercialInterno`, contratos REV04B/REV05 y RD-F01/F04.
- No se modificó ni utilizó como autoridad física la PR #54; su trabajo paralelo debe conciliarse por revisión posterior.
- No se ejecutaron SQL, PostgreSQL, migraciones ni escenarios IMP-T01..IMP-T20.
- Único artefacto documental modificado: este archivo de R08.4.
