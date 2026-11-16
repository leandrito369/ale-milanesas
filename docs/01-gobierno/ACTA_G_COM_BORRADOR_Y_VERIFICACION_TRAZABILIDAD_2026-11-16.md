# Acta G-COM — propuesta corregida para ratificación y verificación de trazabilidad

**Expediente:** AUD-E3-COM-001 · **Acta candidata:** ACT-G-COM-001 (identificador documental provisional).  
**Corte de verificación:** 16/11/2026 (Argentina).  
**Estado:** **BORRADOR REVISADO — NO RATIFICADO / NO MERGEADO / NO EJECUTIVO**.  
**Autoridad futura de ratificación:** responsable del proyecto, únicamente mediante aprobación expresa **posterior a esta revisión**, con alcance y eventuales salvedades.  
**Documento antecedente recibido:** «Etapa 4 — Cierre contractual de los pendientes críticos», sección final «Acta de Aprobación G-COM», aportado el 16/11/2026. **Ese texto era una propuesta redactada en primera persona: no prueba firma ni aprobación.**  
**Proyecto:** Sistema de Gestión para Ale Milanesas. **Repositorios:** [gobierno](https://github.com/leandrito369/ale-milanesas) y [aplicación](https://github.com/leandrito369/ale-milanesas-app).

> **Lectura obligatoria:** esta acta presenta texto para una futura resolución del responsable. Las secciones 1–3 contienen **reglas propuestas para ratificación**, excepto lo identificado expresamente como **antecedente ya aprobado**. Publicar este borrador, crear la PR, ejecutar tests o aprobar una decisión parcial **no equivale a ratificar G-COM completo**.

## 0. Autoridad, evidencia y límites

- **Línea base normativa:** G0, [RD-B0-G0-001](b0/RD_B0_G0_001_CIERRE_LINEA_BASE_2026-10-29.md), [manifiesto de 67 operaciones](b0/G0_MANIFIESTO_CANONICO_67_OPERACIONES_2026-10-29.csv), contratos preferentes REV04B y REV05, [vigencia documental](VIGENCIA_DOCUMENTAL_Y_PRECEDENCIA_2026-11-15.md). **64 casos de uso / 67 operaciones**, sin alterar numeración ni firmas unilateralmente.
- **Contratos y auditoría de trabajo:** [AUD-E3-COM-001](AUDITORIA_E3_CONTRATO_COMERCIAL_CONSOLIDADO_2026-11-15.md) §1–11, [roadmap I3–I7 §9.2](ROADMAP_OPERATIVO_I3_I7_2026-11-15.md), [R08.4 PR #53](https://github.com/leandrito369/ale-milanesas/pull/53), [R08.5 PR #54](https://github.com/leandrito369/ale-milanesas/pull/54).
- **Decisión previa expresamente aprobada:** **DC-COM-FIFO-001 / RC-03-FIFO**, confirmada por el responsable el **16/11/2026** y asentada en AUD-E3 §11; solo ella queda aprobada por dicha confirmación.
- **Historial de aprobación funcional documentada:** PR de gobierno #50, #52, #55–#63 (**OPEN/DRAFT**, con decisiones expresadas, no integradas), y roadmap §9.2. Su inclusión en esta acta **no los convierte por sí sola en contratos consolidados**.
- **Esquema físico de aplicación:** Flyway [V1](https://github.com/leandrito369/ale-milanesas-app/blob/main/src/main/resources/db/migration/V1__baseline_mr5.sql) MR-5 (60 tablas) + [V2](https://github.com/leandrito369/ale-milanesas-app/blob/main/src/main/resources/db/migration/V2__f01_cobro_estados.sql) F01 + [V3](https://github.com/leandrito369/ale-milanesas-app/blob/main/src/main/resources/db/migration/V3__trazabilidad_partidas_insumo.sql) partidas = **62 tablas en la cadena de migraciones de main**, **no evidencia de despliegue**. [Source-lock](https://github.com/leandrito369/ale-milanesas-app/blob/main/docs/traceability/source-lock.md) mantiene G0 inmutable y adenda MR-6. **V4 no existe ni está autorizado para F04** en este corte.
- **Puertas no autorizadas:** G-CON para editar canónicos, G-FIS para SQL/DDL/Flyway, G-DEV para código, y despliegue. Issue [app #28](https://github.com/leandrito369/ale-milanesas-app/issues/28) sigue abierta; entorno pausado. Este documento no certifica pruebas ni E2E.

## 1. Decisiones previas que el acta reconoce — **NO se vuelven a votar**

| ID / bloque | Alcance de decisión previa | Evidencia y estado de asiento |
|---|---|---|
| **D5-B, ANT-01, D6-1, D7-A** | Declaración solo para Entrega actual; anticipo confirmado **efectivamente aplicado**; rendición UC-29 por ADMIN; bloqueo de anulación de Cobros de rendición mientras no exista contraaplicación aprobada | [PR #50](https://github.com/leandrito369/ale-milanesas/pull/50), [#52](https://github.com/leandrito369/ale-milanesas/pull/52), [RD-F04-002](RD_F04_002_RENDICION_EFECTIVO_2026-10-26.md); PR drafts |
| **DC05-01/02/03/04/05/06/07-A** | Reservas explícitas por Pedido; roles; aplicaciones explícitas antes de FIFO libre; liberación al cancelar; bloqueo de anulación de Cobro con vínculos activos | [PR #56](https://github.com/leandrito369/ale-milanesas/pull/56), [#57](https://github.com/leandrito369/ale-milanesas/pull/57), [#55](https://github.com/leandrito369/ale-milanesas/pull/55), [#58](https://github.com/leandrito369/ale-milanesas/pull/58), [#59](https://github.com/leandrito369/ale-milanesas/pull/59); drafts |
| **DC05-09-A** | IMP-B append-only canónico, IMP-A derivada, IMP-C contención; **no** diseño físico aprobado | [PR #60](https://github.com/leandrito369/ale-milanesas/pull/60); draft |
| **D12-C** | PE-1 + PE-2 + IMP-01 online integradas; PE-3 offline diferida | [PR #61](https://github.com/leandrito369/ale-milanesas/pull/61); draft |
| **DC-01-C1, DC-02-A, DC-04-A** | Cargos de cantidad realmente entregada, porcentaje histórico, base agregada HALF_UP(2), ajuste HALF_UP(2), conciliación | [PR #62](https://github.com/leandrito369/ale-milanesas/pull/62), [#63](https://github.com/leandrito369/ale-milanesas/pull/63); drafts |
| **D2=B/EX-01 — principio funcional** | Conservar íntegramente la declaración incluso superior al pendiente; no crear crédito, Cobro o Caja automáticamente por excedente | [Roadmap §9.2](ROADMAP_OPERATIVO_I3_I7_2026-11-15.md), [PR #53](https://github.com/leandrito369/ale-milanesas/pull/53); falta asiento contractual integral |
| **RC-03-FIFO / DC-COM-FIFO-001** | El crédito confirmado **libre y efectivamente aplicado por FIFO** a una Entrega reduce también el pendiente elegible de esa Entrega; no sumar dos veces porción explícita y FIFO | Aprobación expresa del responsable, 16/11/2026; [AUD-E3 §11](AUDITORIA_E3_CONTRATO_COMERCIAL_CONSOLIDADO_2026-11-15.md#11-resolución-expresa-del-responsable--rc-03-fifo-16112026). **APROBADA FUNCIONALMENTE**, propagación pendiente |
| **RD-F04-002/003/005/006/007** | Rendición al fin de recorrido por ADMIN; evidencia mínima; saldo provisional separado; faltante no restaura automáticamente exigibilidad; UC-03 evalúa saldo exigible provisional; tránsito no recategoriza | [002](RD_F04_002_RENDICION_EFECTIVO_2026-10-26.md), [003](RD_F04_003_PAGO_EN_TRANSITO_SALDO_PROVISIONAL_2026-10-26.md), [005](RD_F04_005_DIFERENCIA_PAGO_EN_TRANSITO_2026-10-26.md), [006](RD_F04_006_EVALUACION_DEUDA_NUEVOS_PEDIDOS_2026-10-26.md), [007](RD_F04_007_AJUSTE_EN_MORA_PAGO_TRANSITO_2026-10-26.md); **integradas funcionalmente en main** |

**Nota de discrepancia entre fuentes de seguimiento:** el [roadmap §9.2](ROADMAP_OPERATIVO_I3_I7_2026-11-15.md) declara **«DC-03-B» y «DC05-08-A» aprobadas funcionalmente por comunicación del responsable, con asiento pendiente**. En [AUD-E3](AUDITORIA_E3_CONTRATO_COMERCIAL_CONSOLIDADO_2026-11-15.md) las cláusulas equivalentes o conexas **RC-02 y RC-01** siguen como propuestas. **No se afirma identidad literal automática entre etiquetas DC-03-B y RC-02-A**: las afirmaciones coincidentes deben reconciliarse al ratificar, y la nueva política de entrega **parcial** del adicional no se considera aprobada solo por el roadmap. Esta acta está redactada para **consolidar explícitamente y cerrar esa ambigüedad**, sin negar los antecedentes.

## 2. Texto propuesto para resolución comercial conjunta — **PENDIENTE DE RATIFICACIÓN**

Las siguientes cláusulas serán normativas **solo después de aprobación expresa y posterior del responsable**. El código de propuesta RCG-xx identifica cláusulas de esta acta, **no** nuevas operaciones o tablas.

### RCG-01 — RC-01 / DC05-08: remanente de anticipo en Entrega definitiva parcial

**Propuesta de aprobación — alternativa A, concordante con DC05-08-A comunicada en roadmap:**

1. Al confirmar una Entrega única y definitiva, se determina cargo real \`C_e\` de cantidades efectivas. Se consolida como \`P_e^{exp}\` solo la parte de la reserva confirmada, vigente, elegible y **no cubierta por otras imputaciones** para esa obligación, **nunca por encima del cargo**; se conserva identidad de origen.
2. El remanente no aplicable de esa reserva se **libera automáticamente dentro de la misma transacción de UC-05** mediante evento IMP-B; no crea Cobro, \`MOVIMIENTO_CUENTA(PAGO)\`, \`MOVIMIENTO_CAJA\` ni crédito contable nuevo.
3. La porción liberada puede pasar a **crédito confirmado libre del mismo Cliente**, siempre que no esté anulada, reembolsada, inmovilizada por reembolso u otra reserva. Al estar libre, **puede ser consumida por FIFO** según DC05-04-B y DC-COM-FIFO-001 en otras deudas existentes: es un efecto material a aceptar, no una reasignación explícita oculta.
4. No dejar reservas huérfanas sobre el Pedido \`ENTREGADO\`; no permitir Entrega adicional futura ficticia para consumirlas. Operación transaccional: si falla cualquier paso, se revierte consolidación/liberación/Entrega.
5. Alternativa no elegida: retención del remanente hasta liberación administrativa ordinaria, porque bloquearía crédito sobre obligación cerrada. Correcciones excepcionales siguen sujetas a DC05-03-A.

**Aceptación:** pedido B reserva ARS 8.000, \`C_e=5.000\`: máximo ARS 5.000 de reserva consolidada y ARS 3.000 liberados, si elegibles, con prueba de FIFO sobre otra deuda A, anulación, reembolso y concurrencia.

### RCG-02 — RC-02 / DC-03: adicionales aceptados UC-07 y Entrega parcial

**Propuesta de aprobación — alternativa A, conciliando DC-03-B comunicada en roadmap con RC-02-A:**

1. La cotización aceptada de UC-07, identificada por oferta **y versión**, fija precio base capturado y condiciones históricas aplicables del Pedido receptor; calcula el ajuste una sola vez según secuencia decimal ratificada, sin reevaluar UC-15/UC-16 al emitir ni al entregar. Para cantidad totalmente entregada, \`importeAceptado\` debe conciliar exactamente al centavo.
2. En UC-05 **NO** aplicar Promoción ni un segundo descuento/recargo global sobre el importe final del adicional. El cargo agregado distingue componente original y adicional con trazabilidad independiente; no altera \`PEDIDO.totalOriginal\`.
3. Si la cantidad del adicional **entregada** resulta menor que la **aceptada**, facturar exclusivamente la cantidad entregada aplicando el **mismo precio base y tipo/porcentaje históricos congelados** y los dos redondeos comerciales \`HALF_UP(2)\`. Conservar evidencia de unidades no entregadas, origen de Excedente y costo histórico; no facturar fracción faltante ni recalcular precios actuales. **Esta regla específica para parcial posterior a aceptación necesita ratificación expresa en G-COM; no inferirla de DC-03-B del roadmap.**
4. Cotización parcial nueva antes de aceptación requiere la versión/evidencia que corresponda. No exigir automáticamente nueva conformidad en la puerta por una merma de unidades efectivamente entregadas **si esta alternativa se aprueba**; nunca aumentar cargo respecto del importe aceptado.
5. **Gate de corte inicial:** mientras CR-C [#47](https://github.com/leandrito369/ale-milanesas/pull/47), CR-F [#48](https://github.com/leandrito369/ale-milanesas/pull/48) y RT-UC07-04 no estén autorizadas/probadas, un corte técnico UC-05 **sin adicionales** debe rechazar explícita y transaccionalmente Pedidos con ofertas/adicionales aceptados **no soportados**; código 409 es candidato HTTP sujeto a contrato. No simular líneas comerciales/transferencias ni declarar UC-05/H3 completo.
6. **Alerta de diseño (no decisión de negocio):** \`IMPUTACION_ENTREGA_ADICIONAL\` referencia \`DETALLE_ENTREGA\` que, a su vez, requiere \`DETALLE_PEDIDO\`; un Producto nuevo no presente en el Pedido original exige **CR física/funcional específica**. No crear \`DETALLE_PEDIDO\` original ficticio por esta aprobación.

**Aceptación:** cotización V1 íntegra, cotización posterior parcial, importes aceptados, Entrega total/parcial de adicional, snapshot histórico y bloqueo cuando no existe evidencia/CR autorizada.

### RCG-03 — RC-03 / DC-06/07/08 y D2=B: reconocimiento provisional y diferencias

**Propuesta de aprobación — alternativa A con DC-COM-FIFO-001 ya ratificada:**

1. Definir **\`C_e\`** como cargo por Entrega real e histórica; **\`P_e^{exp}\`** como pagos previos confirmados y explícitamente aplicados a e; **\`F_e^{FIFO}\`** como porción confirmada libre **efectivamente aplicada y auditada** a e, sin solapamiento. \`K_e=P_e^{exp}+F_e^{FIFO}\` cumple \`0<=K_e<=C_e\`. **No** obtener \`F_e^{FIFO}\` de mera simulación de UC-15, saldo global o \`COBRO.idPedido\`.
2. **Fórmula comercial propuesta:**
   \`\`\`text
   E_e   = max(0, C_e - K_e)
   V_e^0 = min(D_e, E_e)
   \`\`\`
   con \`D_e\` íntegramente conservado. **Solo** cuando \`K_e\`, declaración, instante y obligación están acreditados por fuente canónica IMP-B y el protocolo concurrente está validado; si no, **IMP-C contención**: conservar declaración y motivo sin reconocer importe provisional inventado. Mantener versión/evidencia **inmutable** de entradas y cálculo, con correcciones como eventos, sin reescribir snapshot histórico.
3. Si \`C_e=0\` **o** \`E_e=0\` y \`D_e>0\`, aceptar la **Entrega únicamente si cumple todas las demás precondiciones comerciales y operativas de UC-05**, conservar \`D_e\`, y reconocer \`V_e^0=0\`; registrar declaración no reconocida para posterior conciliación. **No** validar como Entrega real un pedido sin cantidades/identidad/asignación válidas.
4. **D2=B/EX-01:** registrar **todo** efectivo declarado, aun excedente, pero nunca convertir exceso automáticamente en \`COBRO\`, Caja de ventas, crédito definitivo ni compensación de otra Entrega.
5. **DC-08 — diferencias tipadas, vinculadas por origen y evento:** distinguir \`Q_e^{decl}\` (declaración no reconocible), \`Q_e^{rend}\` (importe reconocido **aún pendiente** de rendir, no pérdida), \`Q_e^{falt}\` (faltante físico constatado respecto al esperado) y \`Q_e^{exc}\` (exceso físico recibido respecto a lo atribuible). **No son cuatro sumandos de pérdida.** Un mismo tramo puede aparecer temporalmente en \`Q^{decl}\` y \`Q^{exc}\`, o un faltante puede ser subconjunto de \`Q^{rend}\`; se exige identificación/estados que permitan conciliación **sin doble conteo ni compensación automática** entre Clientes/Entregas.
6. Conversión confirmada: \`A_e\` de efectivo realmente recibido, autorizado y atribuido a e extingue **en la misma transacción** igual porción de \`V_e^{vig}\` y genera **una sola vez** Cobro/Pago/Caja definitivo. La diferencia RD-F04-005 no restaura automáticamente deuda exigible del Cliente. No establecer pérdidas definitivas, sanciones o recuperos no aprobados.
7. Nombres «fórmula candidata de R08.4» y «snapshot inmutable» sustituyen a «V1/V3» en este contrato para no confundirlos con migraciones **Flyway V1/V3**.

**Aceptación:** SEM-01 ya aprobado para FIFO efectivo (\`C_e=100,P_e^{exp}=0,F_e^{FIFO}=100,D_e=100\` ⇒ \`E_e=0\`, reconocimiento \`0\` si se ratifica fórmula); SEM-02 crédito libre parcial; sin evidencia IMP-C; prepagado \`E_e=0,D_e>0\`; Q declarada y exceso físicamente recibido **del mismo dinero** sin duplicar pérdida; rendición parcial/anulación concurrente.

### RCG-04 — RC-04 / D4/D9/D10/DEC-GRAN-D6: rendición, evidencia, visibilidad y custodia

**Preexistente y obligatorio, NO nueva decisión:** [RD-F04-002](RD_F04_002_RENDICION_EFECTIVO_2026-10-26.md) ya ratificó rendición al final de **cada recorrido**; solo ADMIN recibe/autoriza; mínimo: Repartidor, recorrido, fecha/hora, esperado, recibido, diferencia, responsable ADMIN, observación obligatoria ante discrepancia y motivo ADMIN al resolver/cerrar. RD-F04-005 no restaura deuda del Cliente por faltante.

**Propuesta de aprobación — alternativa A, únicamente en los aspectos todavía no aprobados:**

1. **Granularidad:** cabecera de rendición **por cierre de recorrido**, con atribución verificable y aplicaciones monetarias **por Entrega y Cliente** (parciales si corresponde); un Cobro definitivo se vincula a **un Cliente** y al acto de rendición, nunca se distribuye arbitrariamente entre Clientes.
2. **D4:** utilizar como evidencia mínima de PE-2 un **registro digital estructurado** con los datos ya ratificados, acuse y auditoría del acto. **Propuesta adicional pendiente:** no exigir de manera general fotografías, captura P2b de UC-07 ni firma manuscrita digitalizada en este primer corte; la ausencia de una imposición de RD-F04-002 **no equivale por sí sola a una prohibición ratificada de adjuntos**.
3. **D9/BC-07:** para \`ADMINISTRADOR\`, nueva proyección **contextual de rendición UC-29** restringida a recorrido, Entregas relacionadas, Clientes imprescindibles para atribución, \`C_e/K_e/D_e/V_e^0/V_e^{vig}/A_e\`, diferencia, estado de custodia, responsable y evidencia mínima. Para \`REPARTIDOR\`, solo su declaración y acuse del propio recorrido, sin información financiera ajena. Para \`VENDEDOR\`, conservar \`UC-14\` exclusiva para saldo confirmado, importe en tránsito validado y saldo exigible provisional, sin habilitar rendición o custodia ADMIN. **No dar UC-14 al ADMIN por inferencia**. El detalle definitivo de campos y protección por objeto se ratificará en adenda BC-07 y su contrato, no mediante permisos SQL globales.
4. **D10 — faltantes:** si recibido es inferior a esperado, confirmar solo dinero físicamente recibido y **atribuido** a la Entrega/Cliente; no prorratear ni aplicar FIFO entre Clientes ante un faltante **sin atribución verificable**. Conservar pendiente y motivo, sin restaurar automáticamente deuda al Cliente.
5. **D10 — excesos/custodia:** importe físico recibido **no imputable** debe conservarse en un registro administrativo conciliable de **custodia de fondos pendientes de clasificación**, con importe, instante, responsable, ubicación/control, fuente/recorrido, motivo, estado, devoluciones y evidencias. Separarlo de \`COBRO\` y \`MOVIMIENTO_CAJA\` **de ventas** hasta que exista atribución/autorización válida. **No** tratarlo como «fuera de toda contabilidad» ni dejar dinero sin arqueo/control. Prohibir declarar «Caja cuadrada» o diferencias resueltas mientras exista saldo en custodia/diferencia abierta sin acto de cierre motivado.
6. La atribución posterior a Cliente se realiza solo por decisión ADMIN autorizada con referencia al efectivo ya recibido **sin registrar segunda recepción física ni segundo ingreso de Caja por el mismo tramo**. La devolución requiere recibo/constancia y registro de salida de custodia; si se requiere cuenta contable auxiliar, Arquitectura podrá proponerla, pero **no queda aprobada por esta acta**.
7. La política no habilita contraaplicación de Cobros de rendición (D7-B), investigación patrimonial ni medidas disciplinarias.

**Aceptación:** recorrido X con dos Clientes y faltante conjunto no distribuible; recibido y aplicado parcialmente; sobrante físico atribuible/no atribuible; devolución de custodia; control de unicidad Cliente–Entrega; autorización/visibilidad por rol y propiedad; conciliación físico-administrativa al final del recorrido.

### RCG-05 — BT-05: contrato observable de idempotencia y anulación

**Propuesta de aprobación contractual (el algoritmo/índice es delegable a Arquitectura):**

1. Los rechazos previos a confirmación transaccional no consumen la identidad idempotente **como comando exitosamente aplicado**. La auditoría de rechazo/seguridad puede conservar su propio evento, sin convertirlo en pago o Entrega aceptados. Errores después de COMMIT se resuelven por recuperación del recibo confirmado.
2. Misma clave, mismo ámbito autorizado y **payload completo semánticamente equivalente** ⇒ replay seguro del recibo histórico, **sin nueva ejecución**. Misma clave y payload distinto ⇒ conflicto sin efectos, sujeto a revalidar permisos. Clave nueva representa una nueva intención y no transforma en operación válida una anulación repetida de un Cobro ya ANULADO.
3. Evolucionar \`anularCobroManual\` para admitir identidad idempotente y retornar referencia auditable a \`idMovimientoCuenta\` y \`idMovimientoCaja\` de contraasientos, preservando ADMIN exclusivo y D7-A. Cambiar firma pública/HTTP requiere **adenda contractual trazable**, no cambio informal de servicio.
4. **Hallazgo verificado pendiente:** [CargarPedidoService.anterior](https://github.com/leandrito369/ale-milanesas-app/blob/main/src/main/java/ar/edu/unam/alemilanesas/ventas/CargarPedidoService.java) actualmente solo compara \`idCliente\` y \`canalOrigen\` para replays, **no** compara integralmente fecha, items/cantidades y dirección; no se declara idempotencia completa ya implementada. [CobroManualService](https://github.com/leandrito369/ale-milanesas-app/blob/main/src/main/java/ar/edu/unam/alemilanesas/finanzas/CobroManualService.java) sí compara varios parámetros, pero su anulación carece de clave específica. Registrar issue o evidencia de prueba en G-ARQ/G-DEV **posteriormente**, no corregir código por este acta.

### RCG-06 — BT-06: referencia COBRO.idPedido y datos heredados

**Propuesta de aprobación de regla de integridad y preflight:**

1. \`COBRO.idPedido\` puede indicar un vínculo contextual, pero **nunca acredita por sí solo** importe reservado/aplicado. No reconstruir \`P_e^{exp}\` o \`F_e^{FIFO}\` mediante backfill heurístico basado en \`idPedido\`, saldo Cliente o un FIFO retrospectivo.
2. Preflight **en cada base destino** antes de activar IMP-B/PE-1: inventario de Cobros previos, obligaciones vivas, reembolsos/restricciones, saldos y evidencias de aplicación. **Un Cobro confirmado antiguo no prueba automáticamente un anticipo vivo** ni exige bloquear toda la base.
3. Ante **compromisos vivos ambiguos con efecto financiero posible**: contener únicamente el circuito afectado \`IMP-C\` hasta conciliación humana/documental. Si no hay datos vivos que migrar, **no fabricar asientos IMP-B**.
4. Para nuevos Cobros, crear reserva por orden/importe **solo si existe evento autorizado explícito**; el atributo contextual \`idPedido\` no produce reserva implícita.
5. La prueba se hará sobre base de destino/ensayo; **no se afirma que la BD real esté vacía** por estar pausado el despliegue.

### RCG-07 — BT-07: diferimiento y precondición de UC-03

**Propuesta de delimitación:**

1. Mantener **diferida** la contraaplicación de Cobros de rendición \`D7-B/DC-09\`, con **bloqueo D7-A vigente**, hasta regla y CR específica; mantener modo **offline PE-3 diferido**, conservando identidad compatible con futuras capturas.
2. **No diferir la obligación normativa de RD-F04-006:** antes de **activar** pago en tránsito provisional en el circuito real, UC-03/aceptación central debe evaluar deuda mediante \`saldoExigibleProvisional\` de eventos ya sincronizados/validados. Se mantiene el ajuste de categoría según [RD-F04-007](RD_F04_007_AJUSTE_EN_MORA_PAGO_TRANSITO_2026-10-26.md).
3. **RD-F04-006 NO creó un umbral nuevo de bloqueo**: UC-03 debe aplicar las políticas de admisión existentes. Cualquier umbral, condición o prohibición comercial adicional requiere nueva decisión formal; Arquitectura no lo inventa como \`C-08\`.
4. Para corte preliminar en que el tránsito siga deshabilitado, se puede planificar esta adaptación, pero **no certificar la vertical completa** ni encender \`V_e\` antes de cerrar su comprobación.

### RCG-08 — G-CON: permiso limitado para preparar la integración editorial

**Propuesta (condicionada a ratificación de esta acta):** se permitirá **preparar para revisión**, como **un solo lote E-01..E-07**, los cambios a REV04B UC-05/06/07, REV05 UC-14/29, RD-I302-001, matriz RBAC/BC07 **mediante adendas/versiones trazables**, preservando G0 congelado, manifiesto y SHAs originales. Las matrices canónicas de G0 pueden referenciar adendas ratificadas, pero **no sobrescribirse silenciosamente** ni expandir permisos por supuestos.

**Esta habilitación editorial no es aprobación automática del contenido de la futura PR G-CON ni habilita merge, SQL, DDL, Flyway, endpoints, implementación, tests con datos reales o despliegue**. G-FIS y G-DEV siguen cerradas. G-ARQ puede revisar y diseñar candidaturas sin alterar fuente.

## 3. Tabla formal para futura ratificación del responsable (aún sin firma)

| Cláusula | Decisión propuesta | Estado **ahora** |
|---|---|---|
| Preexistente: DC-COM-FIFO-001 | Aprobada en conversación 16/11 y referenciada; **sin revotación** | **APROBADA FUNCIONALMENTE** |
| **RCG-01 / RC-01** | Liberación automática de sobrante de reserva; potencial uso FIFO libre | **A RATIFICAR** (roadmap declara DC05-08-A comunicada; conciliar asiento) |
| **RCG-02 / RC-02** | Ajuste UC-07 una vez; parcial posterior a aceptación; guardia de corte inicial | **A RATIFICAR** (roadmap declara DC-03-B comunicada; alcances no idénticos por defecto) |
| **RCG-03 / RC-03** | Fórmula \`V_e^0\` con FIFO aplicado, caso E=0, diferencias tipadas | **A RATIFICAR** (solo subregla FIFO ya aprobada) |
| **RCG-04 / RC-04** | Granularidad, evidencia sin P2b, BC07, custodia | **A RATIFICAR** (RD-F04-002/005 ya rigen sus aspectos existentes) |
| **RCG-05 / BT-05** | Idempotencia de replay y anulación, contrato observable | **A RATIFICAR** |
| **RCG-06 / BT-06** | Referencia no imputativa, preflight, contención selectiva | **A RATIFICAR** |
| **RCG-07 / BT-07** | Diferimiento D7-B/PE-3; cumplimiento RD-F04-006 antes de encender tránsito | **A RATIFICAR** en cuanto a alcance; RD-F04-006 ya vigente |
| **RCG-08 / G-CON** | Solo preparación editorial de E-01..07; revisión posterior | **A RATIFICAR** |

**Espacio reservado para resolución posterior (NO COMPLETAR POR EL ASISTENTE):**  
- Autoridad ratificante: ____________________  
- Fecha de ratificación: ____________________  
- Resolución: [ ] Aprobar íntegramente  [ ] Aprobar con salvedades explícitas  [ ] Devolver para ajustes  [ ] Rechazar  
- Salvedades por cláusula: ____________________  
- PR/commit de incorporación de acta ratificada: ____________________

## 4. Anexo de verificación de trazabilidad (estática y documental)

**Método:** se revisaron el documento de propuestas recibido y su sección de acta, las fuentes principales de gobierno en \`main\`, expedientes en PR draft y archivos Java/SQL de \`ale-milanesas-app/main\`. Una referencia documental se marca **V** cuando el archivo/PR y su contenido fueron identificados y son compatibles, **C** si hay conflicto/requiere conciliación de alcance, **P** si el requisito es propuesto/pendiente, y **T** si es comprobable técnicamente pero **no certificado en ejecución**. Ninguna V prueba existencia de funcionalidad corriendo en producción.

| Traza | Cláusula | Fuente primaria y estado | Resultado | Acción requerida |
|---|---|---|---|---|
| TR-01 | G0 64/67, no renumerar | [Acta G0](b0/RD_B0_G0_001_CIERRE_LINEA_BASE_2026-10-29.md), [source-lock](https://github.com/leandrito369/ale-milanesas-app/blob/main/docs/traceability/source-lock.md) | **V** | No modificar origen; adendas por SHA |
| TR-02 | F04 rendición al fin recorrido, ADMIN, datos mínimos | [RD-F04-002](RD_F04_002_RENDICION_EFECTIVO_2026-10-26.md) **integrada** | **V** | No revotar; D4 «sin fotos» sigue propuesta |
| TR-03 | F04 faltantes no restauran exigible | [RD-F04-005](RD_F04_005_DIFERENCIA_PAGO_EN_TRANSITO_2026-10-26.md) **integrada** | **V** | No crear Cobro/Caja por efectivo no recibido |
| TR-04 | F04 provisional en UC-03 y categoría separada | [RD-F04-006](RD_F04_006_EVALUACION_DEUDA_NUEVOS_PEDIDOS_2026-10-26.md), [007](RD_F04_007_AJUSTE_EN_MORA_PAGO_TRANSITO_2026-10-26.md) **integradas** | **V** | Implementar evaluación; no inventar umbral |
| TR-05 | D5-B/ANT-01/D6-1/D7-A | Gobierno [#50](https://github.com/leandrito369/ale-milanesas/pull/50), [#52](https://github.com/leandrito369/ale-milanesas/pull/52) **drafts** | **V** funcional, **P** propagación | Integrar con referencia posterior, no convertir drafts en SQL |
| TR-06 | Reservas/roles/FIFO/liberación/anulación | Gobierno [#55–#59](https://github.com/leandrito369/ale-milanesas/pull/55) **drafts** (enlaces #56/#57/#58/#59 en §1) | **V** funcional, **P** propagación | Mantener trazabilidad por decisión |
| TR-07 | IMP-B/IMP-A/IMP-C | Gobierno [#60](https://github.com/leandrito369/ale-milanesas/pull/60) **draft** | **V** dirección, **P** físico | No generar DDL por inferencia |
| TR-08 | D12-C y cálculo histórico/decimal | Gobierno [#61](https://github.com/leandrito369/ale-milanesas/pull/61), [#62](https://github.com/leandrito369/ale-milanesas/pull/62), [#63](https://github.com/leandrito369/ale-milanesas/pull/63) **drafts** | **V** funcional, **P** propagación | No reabrir |
| TR-09 | RC-03-FIFO | [AUD-E3 §11](AUDITORIA_E3_CONTRATO_COMERCIAL_CONSOLIDADO_2026-11-15.md), confirmación expresa del responsable 16/11 | **V — APROBADA FUNCIONALMENTE** | Formalizar cláusula y pruebas SEM-01..07 |
| TR-10 | **RC-01 ↔ DC05-08-A** | [Roadmap §9.2](ROADMAP_OPERATIVO_I3_I7_2026-11-15.md) dice comunicada/pendiente asiento; [AUD-E3](AUDITORIA_E3_CONTRATO_COMERCIAL_CONSOLIDADO_2026-11-15.md) la trató como propuesta | **C** entre asientos | Ratificar correspondencia y alcance total en esta acta |
| TR-11 | **RC-02 ↔ DC-03-B** | [Roadmap §9.2](ROADMAP_OPERATIVO_I3_I7_2026-11-15.md), [REV05 UC-27](../08-diagramas/consolidacion-b0/CONTRATOS_REV05_CORREGIDOS_B0_ACTUALIZADO.md), [CR-C #47](https://github.com/leandrito369/ale-milanesas/pull/47) | **C**: ajuste único soportado, parcial posterior a aceptación **no íntegramente ratificado** | Aprobar explícitamente regla de parciales y guardia, no equiparar IDs por intuición |
| TR-12 | UC-07 representación/FKs | [V1](https://github.com/leandrito369/ale-milanesas-app/blob/main/src/main/resources/db/migration/V1__baseline_mr5.sql) y [CR-F #48](https://github.com/leandrito369/ale-milanesas/pull/48) **draft** | **T/P** | Resolver 2 FKs, precio base y evidencia antes de integrar UC-07 |
| TR-13 | Fórmula C/K/D/V y Q | [R08.4 #53](https://github.com/leandrito369/ale-milanesas/pull/53), [R08.5 #54](https://github.com/leandrito369/ale-milanesas/pull/54), [AUD-E3](AUDITORIA_E3_CONTRATO_COMERCIAL_CONSOLIDADO_2026-11-15.md) **drafts** | **P** salvo subregla FIFO | Ratificación integral RC-03, asegurar Q no aditivas |
| TR-14 | BC-07 y permisos proyección | [BC07 G0](b0/BC07_PROYECCIONES_MINIMAS_RATIFICADAS_2026-10-29.csv), [REV05 UC-14/29](../08-diagramas/consolidacion-b0/CONTRATOS_REV05_CORREGIDOS_B0_ACTUALIZADO.md) | **V** límites de G0 / **P** nueva proyección | Adenda aprobada, sin conceder UC-14 al ADMIN |
| TR-15 | Evidencia RD-F04-002 vs propuesta sin binarios | [RD-F04-002](RD_F04_002_RENDICION_EFECTIVO_2026-10-26.md) datos mínimos ratificados; formato aún pendiente | **V/P** | Ratificar explícitamente el alcance «sin foto/firma» |
| TR-16 | Contrato de anulación manual idempotente | [REV05](../08-diagramas/consolidacion-b0/CONTRATOS_REV05_CORREGIDOS_B0_ACTUALIZADO.md) Nota exige idempotencia y Salida IDs; firma sin clave; [CobroManualService](https://github.com/leandrito369/ale-milanesas-app/blob/main/src/main/java/ar/edu/unam/alemilanesas/finanzas/CobroManualService.java) sin clave en anulación | **C/T** | Resolver firma+replay en G-CON/ARQ, no reportar código conforme |
| TR-17 | Reintentos de UC-03 | [CargarPedidoService](https://github.com/leandrito369/ale-milanesas-app/blob/main/src/main/java/ar/edu/unam/alemilanesas/ventas/CargarPedidoService.java): compara Cliente/canal solamente en \`anterior()\` | **T — BRECHA ESTÁTICA** | Prueba misma clave distinta fecha/items/dirección y corrección posterior autorizada |
| TR-18 | Legado \`COBRO.idPedido\` | [CobroManualService](https://github.com/leandrito369/ale-milanesas-app/blob/main/src/main/java/ar/edu/unam/alemilanesas/finanzas/CobroManualService.java), [R08.4 #53](https://github.com/leandrito369/ale-milanesas/pull/53) | **V** insuficiencia, **P** preflight físico | No inferir aplicación; preflight selectivo, sin afirmar BD vacía |
| TR-19 | 62 tablas V1–V3 | [V3 main](https://github.com/leandrito369/ale-milanesas-app/blob/main/src/main/resources/db/migration/V3__trazabilidad_partidas_insumo.sql), [RD-MR-PARTIDAS-001](b0/RD_MR_PARTIDAS_001_AMPLIACION_MR_PARTIDA_INSUMO_2026-11-06.md) | **V** archivo/contrato; **T** ejecución pendiente | No usar documento histórico del 05/11 para decir que V3 no existe |
| TR-20 | Concurrencia y guarda SQL de anulación | [V1](https://github.com/leandrito369/ale-milanesas-app/blob/main/src/main/resources/db/migration/V1__baseline_mr5.sql), [CobroManualService](https://github.com/leandrito369/ale-milanesas-app/blob/main/src/main/java/ar/edu/unam/alemilanesas/finanzas/CobroManualService.java) | **T — riesgo no probado** | Grafo de locks completo + Testcontainers PG; SQL guarda origen REP/IMP; no afirmar deadlock inevitable |
| TR-21 | No despliegue ni aprobación física | [source-lock](https://github.com/leandrito369/ale-milanesas-app/blob/main/docs/traceability/source-lock.md), [Issue #28](https://github.com/leandrito369/ale-milanesas-app/issues/28), [CR-B0-F04-001](b0/CR_B0_F04_001_DISENO_FISICO_SINCRONIZACION_PENDIENTE_2026-10-29.md) | **V** | Mantener gates G-FIS/G-DEV cerrados |

### 4.1 Contradicciones e incertidumbres detectadas y tratamiento

| ID | Severidad | Asunto | Resolución en borrador |
|---|---|---|---|
| H-GCOM-01 | **ALTA — documental** | Roadmap DC-03-B/DC05-08-A «aprobadas comunicadas» vs AUD-E3 «pendientes» y etiqueta RC-02-A no idéntica literalmente | §1 nota de concordancia; RCG-01/02 requerirán ratificación expresa de **alcance exacto**; no falsificar acta anterior |
| H-GCOM-02 | **ALTA — integridad** | Diferencias \`Q_e\` pueden representar mismo efectivo en dos perspectivas | RCG-03 prohíbe sumarlas como pérdidas y exige trazabilidad de tramos |
| H-GCOM-03 | **ALTA — física/contable** | Custodia de exceso no imputable podría desaparecer de arqueo o registrarse como venta | RCG-04 exige custodia conciliable y prohíbe doble recepción; pendiente mecanismo contable autorizado |
| H-GCOM-04 | **ALTA — implementación** | Replay UC-03 no valida payload completo; anulación UC-29 sin clave | RCG-05 separa decisión y deuda técnica; bloquear certificación de idempotencia total |
| H-GCOM-05 | **MEDIA — precisión** | RD-F04-006 ya aprobó saldo provisional; no aprobó nuevos límites de admisión | RCG-07 exige implementación de la RD antes de activación; cambio de umbral por nueva RD |
| H-GCOM-06 | **MEDIA — documental** | RD-F04-002 aprobó evidencia mínima, pero no prohibición general de fotografía | RCG-04 declara «sin P2b obligatorio» como propuesta adicional |
| H-GCOM-07 | **ALTA — dependencias** | UC-07 parciales no cubiertos por tabla original; CR-C/CR-F/RT-UC07-04 draft | RCG-02 gate 409 candidato; no declarar H3/UC-05 completos |
| H-GCOM-08 | **ALTA — concurrencia** | Orden inverso de filas entre Cobro/anulación y futuros escritores, aunque los Cobros actuales comparten advisory lock | T-05: grafo de recursos y pruebas PostgreSQL; no afirmar deadlock demostrado |

### 4.2 Veredicto de verificación y próximos gates

- **Trazabilidad documental:** **APTITUD CONDICIONADA** para ratificación del contenido **RCG-01..RCG-08**; los antecedentes que constan en main y PR drafts se separaron de las nuevas decisiones. La equivalencia entre los nombres del roadmap y las cláusulas nuevas **no está demostrada palabra por palabra**; la ratificación deberá mencionar ambos IDs y el alcance exacto.
- **Trazabilidad de implementación:** **PARCIAL**; varios servicios/gates ya existen, pero el circuito completo UC-05 ↔ UC-29 ↔ IMP-B/PE-1/PE-2 no está integrado ni certificado. La identificación de rutas, clases y restricciones **no es ejecución de tests**.
- **G-COM:** **NO CERRADA** hasta resolución expresa posterior del responsable sobre RCG-01..08. Una ratificación parcial debe listar las cláusulas excluidas y sus protecciones.
- **G-CON:** **NO AUTORIZADA PARA MODIFICAR CANÓNICOS** hasta esa ratificación; el acta solo propone preparar E-01..07 como paquete revisable.
- **G-ARQ:** se permite seguir evaluando alternativas/documentando pruebas no intrusivas; cualquier contrato observable nuevo se retorna a gobierno.
- **G-FIS / G-DEV / despliegue:** **CERRADAS**. Sin SQL, DDL/Flyway, edición de V1–V3 o habilitar flags. Issue app #28 continúa abierta.

**Evidencias a ejecutar posteriormente (NO ejecutadas en esta revisión):** SEM-01..07; CON-01..15; FIN-01..14; RCM de parciales/custodia; fingerprint y replay UC-03/UC-29; matriz RBAC negativa por campos y roles; grafo C3 y Testcontainers PostgreSQL; preflight de datos reales. La aprobación humana de G-COM **no** equivaldrá a validación de esas pruebas.

---

**FIN DEL BORRADOR.** La firma, la aprobación de RC-01..04, BT-05/06/07 y el permiso editorial G-CON se dejan **explícitamente en blanco** para decisión posterior del responsable. 
