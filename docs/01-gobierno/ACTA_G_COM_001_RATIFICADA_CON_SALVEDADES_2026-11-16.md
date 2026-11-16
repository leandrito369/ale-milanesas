# Acta G-COM (`ACT-G-COM-001`) — Ratificación Comercial Consolidada

**Expediente:** AUD-E3-COM-001 · **Documento:** `ACT-G-COM-001`  

**Proyecto:** Sistema de Gestión para Ale Milanesas (`leandrito369/ale-milanesas` y `leandrito369/ale-milanesas-app`)  

**Corte de verificación:** 16 de noviembre de 2026 (Argentina)  

**Estado:** **RATIFICADA FUNCIONALMENTE CON SALVEDADES EXPRESAS (16/11/2026) — PR #64 OPEN/DRAFT, AÚN NO INTEGRADA EN MAIN — SIN AUTORIZACIÓN FÍSICA NI DE DESPLIEGUE.**  

**Base normativa y técnica:** G0 ratificado (`RD-B0-G0-001`, manifiesto 67 operaciones / 64 CU, `source-lock` G0 + adendas MR-6), `AUD-E3-COM-001`, Roadmap I3–I7 §9.2, `RD-F04-002/003/005/006/007`, PRs de gobierno `#44`, `#47`, `#48`, `#50`, `#52`–`#63` (en estado `OPEN/DRAFT`) y esquema `V1`–`V3` (62 tablas) de `ale-milanesas-app/main`.

---

## Veredicto Ejecutivo

1. **Qué ratificó expresamente el responsable el 16/11/2026:** ratifica el texto consolidado de las cláusulas comerciales **`RCG-01` a `RCG-08`**, reconociendo la decisión preexistente **`DC-COM-FIFO-001`** (aprobada el 16/11/2026) y las decisiones previas de §1 sin revotarlas. La ratificación **cierra y reconcilia explícitamente** la equivalencia entre el Roadmap §9.2 y `AUD-E3`: fija el alcance exacto de **`DC05-08-A` en `RCG-01`** y de **`DC-03-B` en `RCG-02`**, sin equiparación automática retroactiva para entrega parcial de adicionales.

2. **Qué queda delegado a Diseño/Arquitectura (`G-ARQ` / `G-FIS`):** DDL, tablas, claves, índices, secuencia exacta de locks SQL, protocolos internos de transacción, formatos de recibo y estrategia de pruebas. Ninguna decisión técnica puede alterar los resultados comerciales observables, los permisos, la trazabilidad ni las restricciones fijadas en `RCG-01..08`.

3. **Qué permanece diferido o cerrado:** continúan diferidos **`D7-B`** (contraaplicación de cobros de rendición, con bloqueo `D7-A` vigente) y **`PE-3`** (modo offline). Permanecen **cerradas** `G-FIS` (sin `V4` ni edición de `V1–V3`), `G-DEV` y el despliegue (`Issue app #28` PAUSADA). La ratificación de `G-COM` habilita únicamente **preparar para revisión** el lote editorial `E-01..E-10` en `G-CON` (sin auto-merge) y **no** certifica pruebas ni implementación ejecutada.

---

## 0. Autoridad, Evidencia y Límites

- **Línea base inmutable:** G0 (`source_commit = 1263ffc17bd0eb7f3c69faaa9ff5ae556cf9de7e`, `governance_commit = 27738b089afdd2698cdae915f75c0e8089a6248a`), 64 CU / 67 operaciones, RBAC 67×8 sin pendientes y BC-07 (15 proyecciones base). Sin renumerar ni alterar firmas unilateralmente.

- **Dirección arquitectónica de imputación:** fuente canónica append-only `IMP-B`, proyección derivada `IMP-A` y contención selectiva `IMP-C` ante evidencia insuficiente o ambigua (`DC05-09-A`, sin diseño físico aprobado).

- **Esquema físico en `ale-milanesas-app/main`:** migraciones Flyway `V1` (MR-5, 60 tablas) + `V2` (F01) + `V3` (partidas/envases) = **62 tablas** en cadena de migración (no evidencia de despliegue). **`V4` no existe ni está autorizado** en este corte.

- **Puertas:** `G-COM` queda cerrada **funcionalmente** por ratificación expresa documentada en §3 (declaración textual, sin firma electrónica verificada). `G-CON` queda habilitada solo para preparar un paquete editorial revisable; sin autorización automática de merge. `G-FIS`, `G-DEV` y despliegue continúan bloqueados.

---

## 1. Decisiones Previas Reconocidas (No se vuelven a votar)

| Bloque / ID | Alcance ya definido | Estado / Evidencia |

|---|---|---|

| **D5-B, ANT-01, D6-1, D7-A** | Declaración solo para Entrega actual; anticipo confirmado aplicado; rendición `UC-29` por `ADMINISTRADOR`; bloqueo de anulación de Cobros de rendición | PR `#50`, `#52` (`OPEN/DRAFT`), `RD-F04-002` |

| **DC05-01..07-A** | Reservas explícitas por Pedido; roles; explícitas antes de FIFO libre; liberación al cancelar; bloqueo de anulación con vínculos activos | PR `#55`–`#59` (`OPEN/DRAFT`) |

| **DC05-09-A** | `IMP-B` append-only canónico, `IMP-A` derivada, `IMP-C` contención (no diseño físico) | PR `#60` (`OPEN/DRAFT`) |

| **D12-C** | `PE-1` + `PE-2` + `IMP-01` online integradas; `PE-3` offline diferida | PR `#61` (`OPEN/DRAFT`) |

| **DC-01-C1, DC-02-A, DC-04-A** | Cargos sobre cantidad realmente entregada; porcentaje histórico; base agregada `HALF_UP(2)` y ajuste `HALF_UP(2)` para tramo original | PR `#62`, `#63` (`OPEN/DRAFT`) |

| **D2=B / EX-01** | Conservar declaración completa incluso excedente; no crear Cobro, Caja ni crédito contable automático por exceso | Roadmap §9.2, PR `#53` (`OPEN/DRAFT`) |

| **RC-03-FIFO / DC-COM-FIFO-001** | Crédito confirmado **libre y efectivamente aplicado por FIFO** reduce también el pendiente elegible; no sumar doble explícito + FIFO | Confirmación expresa 16/11/2026 (`AUD-E3 §11`); **APROBADA FUNCIONALMENTE** |

| **RD-F04-002/003/005/006/007** | Rendición fin de recorrido por `ADMINISTRADOR`; datos mínimos; saldo provisional separado; faltante no restaura exigibilidad; `UC-03` evalúa saldo provisional; tránsito no recategoriza | **Integradas como decisiones normativas en `ale-milanesas/main`; la implementación del circuito completo F04 en `ale-milanesas-app/main` continúa pendiente de verificación e integración** |

> **Cierre de discrepancia Roadmap vs AUD-E3:** por ratificación expresa de esta Acta quedan formalmente conciliadas **`DC05-08-A` con `RCG-01`** y **`DC-03-B` con `RCG-02`**, fijando en §2 el alcance exacto vinculante para ambas (incluida la política de entrega parcial de adicionales posterior a `UC-07`).

---

## 2. Resoluciones Comerciales Conjuntas Consolidadas (`RCG-01` a `RCG-08`)

### `RCG-01` — Remanente de anticipo en Entrega definitiva parcial (`RC-01` / `DC05-08-A`)

1. Al confirmar una Entrega única y definitiva (`UC-05`), se consolida como `P_e^{exp}` únicamente la porción de reserva confirmada, vigente, elegible y no cubierta por otras imputaciones para ese Pedido, **nunca por encima del cargo real `C_e`**. El sobrante no aplicado se **libera automáticamente dentro de la misma transacción** mediante evento `IMP-B`, sin emitir Cobro, Pago, Caja ni crédito contable nuevo.

2. **Precedencia ante múltiples reservas (regla comercial):** si un Pedido cuenta con varias reservas válidas procedentes de Cobros distintos, el consumo al entregar sigue la regla **«reserva creada válidamente más antigua primero»**. Arquitectura implementará una secuencia canónica total, estable y reproducible de antigüedad y desempate (no fijar `idEvento ASC` como regla de negocio salvo garantía de correspondencia con la confirmación real).

3. **Frontera atómica en `UC-05`:** en una única transacción con rollback integral se calculará `C_e` histórico, se consolidarán las reservas explícitas elegibles, se liberará el sobrante a disponibilidad libre, se determinará y persistirá cualquier aplicación FIFO libre efectiva (sin reutilizar importes comprometidos ni causar un segundo movimiento financiero), se registrará el Cargo y se reevaluará `UC-15` sobre el estado final. El orden interno de escrituras y locks corresponde al diseño transaccional sujeto a pruebas.

4. **Elegibilidad del crédito liberado y control de `REEMBOLSO`:** la disponibilidad libre exige evaluar **estado e importe del `REEMBOLSO`**: se excluyen porciones anuladas, reembolsadas o inmovilizadas por reembolso/restricción vigente; la mera existencia de una fila `REEMBOLSO` en estado `RECHAZADO` **no** veta la disponibilidad del saldo legítimo restante. Casos ambiguos pasan a contención `IMP-C`. El saldo libre resultante queda sujeto a consumo FIFO (`DC05-04-B` / `DC-COM-FIFO-001`) en otras deudas del mismo Cliente.

5. **Invariante de cierre:** no dejar reservas huérfanas sobre Pedido `ENTREGADO` ni habilitar entregas adicionales ficticias. *Aceptación:* Pedido B reserva ARS 8.000 con `C_e = 5.000` (y variante multi-reserva) ⇒ consolida ARS 5.000 según antigüedad, libera ARS 3.000, valida consumo FIFO sobre deuda A, excluye solo reembolsos activos/efectivos y verifica rollback ante falla.

### `RCG-02` — Adicionales aceptados `UC-07` y Entrega parcial (`RC-02` / `DC-03-B`)

1. **Valoración separada por oferta y versión:** cada adicional aceptado (`UC-07`) se identifica por Oferta de Excedente y versión de cotización, capturando su precio base y las condiciones históricas del Pedido receptor sin reevaluar `UC-15/UC-16` al emitir ni al entregar, ni alterar `PEDIDO.totalOriginal`. Cada oferta aceptada (y su eventual entrega parcial) se calcula **separadamente** (`subtotal = HALF_UP_2(cantidad * precioBase)`, `ajuste = HALF_UP_2(subtotal * porcentaje / 100)`, `importe = subtotal ± ajuste`), sin mezclar bases imponibles entre ofertas ni con el tramo original (`DC-04-A` permanece únicamente para el tramo original).

   - *Regresión obligatoria:* dos ofertas distintas del mismo Pedido por ARS 15,05 c/u con 10% de descuento deben totalizar **ARS 27,08** (ARS 13,54 + ARS 13,54), y **no** ARS 27,09 agrupadas.

2. **Frontera temporal antes vs después de aceptar:**

   - **Antes de aceptar (`UC-07`):** reducir cantidades respecto de `cantidadOfrecida` requiere nueva versión/cotización `O1` y conformidad expresa.

   - **Después de aceptar y al entregar (`UC-05`):** si `cantidadEntregada < cantidadAceptada`, se factura exclusivamente `cantidadEntregada` con el mismo precio base, tipo/porcentaje históricos congelados y ambos redondeos `HALF_UP(2)`, **sin exigir nueva conformidad en puerta** (aprobado expresamente por esta cláusula; nunca cobrar faltante ni superar `importeAceptado`), conservando evidencia de merma, origen de Excedente y costo histórico.

3. **Restricción física y prohibiciones (`CR-C` / `CR-F`):** Arquitectura deberá demostrar representación de Oferta, Excedente, Producto, cantidad, valoración y costo **sin depender de insertar `DETALLE_PEDIDO(cantidadOriginal = 0)`**, debido al conflicto con `fk_detalle_entrega_1`, `uq_detalle_pedido_0(idPedido, idProducto)` y el trigger `tg_mr3_validar_producto_detalle_nuevo` (productos inactivos históricos o múltiples ofertas del mismo Producto). **Queda prohibido desactivar dicho trigger, editar `V1`, relajar la unicidad o crear líneas originales ficticias.**

4. **Gate de corte inicial:** mientras `CR-C` (`#47`), `CR-F` (`#48`) y `RT-UC07-04` no estén aprobadas y probadas, `UC-05` rechazará explícita y transaccionalmente Pedidos con adicionales aceptados no soportados (`409` / código HTTP a fijar en `G-CON`). No simular entregas ni declarar `UC-05`/`H3` completos.

### `RCG-03` — FIFO vinculante, cargo cero, reconocimiento provisional y diferencias (`RC-03`)

1. **Atribución `F_e^{FIFO}` vinculante en `IMP-B`:** toda aplicación `F_e^{FIFO} > 0` constituye una atribución monetaria efectiva, persistida y vinculante en `IMP-B` (porciones de Cobros `CONFIRMADOS` elegibles, Cliente, obligación `e`, importe y causa), decidida bajo la **misma frontera de consistencia y rollback integral** que `UC-05`, `C_e`, `P_e^{exp}`, `V_e^0` y agotamiento de crédito libre. Nunca se reutiliza una porción ya atribuida para otra Entrega o anulación incompatible; las proyecciones se derivan del libro sin crear un segundo Cobro/Pago/Caja. Ante falta de evidencia o imposibilidad de serializar, `IMP-C` impide inventar `V_e^0`.

2. **Fórmula y definiciones (nombres «fórmula R08.4» y «snapshot inmutable», evitando «V1/V3»):**

   `K_e = P_e^{exp} + F_e^{FIFO}` (porciones disjuntas, `0 <= K_e <= C_e`); `E_e = max(0, C_e - K_e)`; **`V_e^0 = min(D_e, E_e)`**, conservando `D_e` íntegramente (`D2=B/EX-01`). Prohibido derivar `F_e^{FIFO}` de simulación de `UC-15`, saldo global o `COBRO.idPedido`.

3. **Cargo cero (`C_e = 0, D_e > 0`) o prepago total (`E_e = 0, D_e > 0`):** solo es válido en una **Entrega válida con cantidades efectivamente entregadas mayores a cero** y precio final cero (por ejemplo, promoción o descuento del 100% debidamente autorizado, sin limitar el universo contractual de causas de precio cero). No habilita Entregas con todas las cantidades en cero ni omite precondiciones (`REV04B A2`). Conservar `D_e` íntegro, reconocer `V_e^0 = 0` y derivar la diferencia a conciliación sin crédito, Cobro ni Caja automáticos.

4. **Diferencias tipadas con marca temporal, ámbito y trazabilidad de tramos (no son cuatro pérdidas aditivas):**

   - En `UC-05`: `Q_e^{decl} = max(0, D_e - V_e^0)` (declaración no reconocida) y `Q_e^{rend}(t_0) = V_e^0` (exposición provisional pendiente de conversión, **no efectivo físicamente faltante**).

   - En `UC-29`: `A_e(t)` suma aplicaciones definitivas efectivamente recibidas y autorizadas; en el modelo inicial sin correcciones posteriores, `V_e^{vig}(t) = V_e^0 - A_e(t)` y `Q_e^{rend}(t) = V_e^{vig}(t)` (correcciones posteriores por eventos inmutables sin sobrescribir historia).

   - **Faltante constatado `Q_e^{falt}(t)`:** existe **solo** cuando hay conciliación física y atribución comprobables, cumpliendo `0 <= Q_e^{falt}(t) <= Q_e^{rend}(t)`; nunca se deduce automáticamente de que una porción siga pendiente.

   - **Exceso físico `Q^{exc}`:** pertenece al evento/recorrido de rendición y representa fondos efectivamente recibidos sin imputación elegible, descontando lo ya atribuido y evitando contar dos veces otras fuentes del mismo efectivo. `Q_e^{decl}` y `Q^{exc}` pueden reflejar el mismo tramo desde perspectivas distintas y **no se suman como pérdida ni ingreso**.

5. **Conversión y `RD-F04-005`:** `A_e` extingue igual porción de `V_e^{vig}` en la misma transacción generando una sola vez Cobro/Pago/Caja definitivo. El faltante pendiente de conciliación mantiene la exigibilidad provisional reconocida: no restaura deuda automática al Cliente ni contabiliza efectivo no recibido. *Aceptación:* `SEM-01` (FIFO total ⇒ `V_e^0 = 0`), `SEM-07` (dos entregas concurrentes), anulación del Cobro financiador, rendición parcial, `Q` pendiente vs faltante constatado, caso físico de ARS 25 declarados de más y recibidos sin doble pérdida, `C_e = 0` con unidades positivas y rechazo con cero unidades.

### `RCG-04` — Origen de Cobro rendido, evidencia, arqueo, custodia y BC-07 (`RC-04`)

1. **Origen y trazabilidad del Cobro rendido:** todo Cobro confirmado por rendición autorizada por `ADMINISTRADOR` en `UC-29` (`D6-1`) tendrá **`COBRO.origen = 'REPARTO'`** (`V1 ck_cobro_2`), `idUsuarioRegistrador = Administrador`, identidad de Repartidor/recorrido y referencia FK verificable a la rendición y sus aplicaciones (`origen = 'REPARTO'` solo no acredita entrega). Cobros manuales generales usan `'ADMINISTRACION'`; Mercado Pago usa `'ONLINE'`. Sujeto a `D7-A`.

2. **Granularidad y faltantes (`D10`):** cabecera de rendición por cierre de recorrido con aplicaciones por Entrega y Cliente; un Cobro definitivo pertenece a un único Cliente. Ante faltante sin atribución verificable, confirmar solo lo recibido y atribuido; **prohibido prorratear o aplicar FIFO entre Clientes**.

3. **Evidencia mínima (`D4`):** registro digital estructurado conforme `RD-F04-002`; en este corte **no se exigen de manera general fotografías, captura P2b ni firma manuscrita digitalizada** (sin prohibir adjuntos en cortes futuros).

4. **Arqueo en tres vistas y rechazo de fórmula simplificada:** el arqueo separará **(i)** saldo contable de Caja/Libro Diario por medio de pago y período, **(ii)** efectivo físico bajo custodia por fuente y responsable, y **(iii)** efectivo contado al cierre. **No se aprobará la igualdad simplificada «total de UC-23 + custodia = billetes contados»**, ya que `MOVIMIENTO_CAJA`/`UC-23` incluye medios **no efectivos**, saldo físico inicial y traspasos/depósitos. `G-ARQ/G-FIS` definirá la ecuación filtrada por efectivo, perímetro e instante con validación contable.

5. **Custodia y no duplicación:** los fondos recibidos no imputables se conservan en registro conciliable de **custodia de fondos pendientes de clasificación**, separado de `COBRO` y `MOVIMIENTO_CAJA` de ventas. La custodia solo se reduce por **(a)** devolución física documentada (egreso de custodia sin asiento de venta) o **(b)** regularización/autorización de `ADMINISTRADOR` a Cobro/Caja vinculada a la recepción original **sin segunda recepción física ni segundo ingreso de efectivo**. Prohibido declarar «Caja cuadrada» con custodia o diferencia abierta sin cierre motivado.

6. **Visibilidad `BC-07` (`D9`):** `ADMINISTRADOR` recibe nueva proyección **contextual exclusiva de `UC-29`** (recorrido, Entregas, Clientes imprescindibles para atribución, `C_e/K_e/D_e/V_e^0/V_e^{vig}/A_e`, diferencia, custodia, responsable y evidencia); **no inferir permiso a `UC-14`**. `REPARTIDOR` ve solo su propia declaración y acuse en `UC-05` (sin `UC-29` ni datos ajenos). `VENDEDOR` conserva `UC-14` en exclusividad (sin rendición ni custodia).

### `RCG-05` — Contrato observable de idempotencia y anulación (`BT-05`)

1. **Identidad y huella canónica:** la idempotencia se define por ámbito autorizado y **huella canónica versionada del payload semánticamente completo** (`UC-03`: Cliente, canal, fecha, dirección, detalles/cantidades con su multiplicidad y orden contractual; `CobroManual`: Cliente, Pedido contextual, importe, medio, origen), normalizando equivalencias decimales sin pérdida (`1.0` = `1.000`), excluyendo timestamp de recepción/sesión técnica y **revalidando autorización y ámbito en cada replay**.

2. **Semántica de replay, conflicto y mutación posterior:**

   - **Replay tras éxito:** devuelve el recibo histórico sin reejecutar efectos. Si el recurso mutó después por otro comando válido (p. ej., un Cobro confirmado luego pasó a `ANULADO`), el replay de la clave original de alta devuelve el **recibo histórico** (eventualmente acompañado del estado actual separado) y **no** se convierte en nuevo Cobro ni en conflicto `409`.

   - **Misma clave + payload distinto:** rechazo `409 Conflict` sin efectos.

   - **Rechazos pre-COMMIT:** no consumen la identidad idempotente como comando aplicado; su auditoría va en canal separado sin confirmar transacciones de negocio.

3. **Evolución de `anularCobroManual` (`UC-29`):** requiere adenda contractual `G-CON` con clave idempotente propia, motivo obligatorio, retorno de IDs de contraasientos (`idMovimientoCuenta`, `idMovimientoCaja`), replay seguro de la anulación ya confirmada y rechazo ante nueva clave sobre Cobro ya `ANULADO`, manteniendo `ADMINISTRADOR` exclusivo y `D7-A`.

4. **Deuda técnica registrada:** `CargarPedidoService.anterior()` (solo compara `idCliente`/`canalOrigen`) y `CobroManualService` (anulación sin clave) quedan registrados para corrección en `G-ARQ/G-DEV`; no se declara idempotencia cumplida en este corte.

### `RCG-06` — `COBRO.idPedido`, preflight, contención y reserva `UC-21` ONLINE (`BT-06`)

1. **Carácter informativo y prohibición de backfill:** `COBRO.idPedido` es meramente contextual y nunca acredita por sí solo reserva o aplicación (`P_e^{exp}`/`F_e^{FIFO}`). Prohibido el backfill heurístico por `idPedido`, saldo o FIFO retrospectivo.

2. **Preflight por Cliente y Obligación antes de encender `IMP-B`/`PE-1`:** verificar en cada base destino al menos cinco señales: **(A)** Cobro confirmado con `idPedido` hacia Pedido `PENDIENTE` sin reserva; **(B)** saldo neto a favor con Pedidos `PENDIENTE`; **(C)** reembolso `PENDIENTE`/sin conciliar; **(D)** crédito confirmado sin `idPedido` potencialmente consumido; **(E)** pagos `ONLINE`/entregas pendientes de cierre. Estas señales son **indicadores de revisión y no condición suficiente** (`A∪B∪C vacío ≠ apto`). Ante compromisos vivos ambiguos con impacto financiero, aplicar contención `IMP-C` selectiva; si no hay datos vivos, no fabricar asientos.

3. **Regla explícita para `UC-21` ONLINE:** tras acreditación de Mercado Pago y confirmación idempotente del Cobro ONLINE y del Pedido ONLINE, el sistema registrará de forma recuperable ante reintentos/fallos una **reserva explícita en `IMP-B`** para ese Pedido (`COBRO.idPedido` informativo), sin suponer transacción distribuida ACID con Mercado Pago ni generar segundo Cobro/Pago/Caja.

### `RCG-07` — Diferimientos y admisión `UC-03` con saldo provisional (`BT-07`)

1. **Alcance diferido:** se mantienen diferidos `D7-B` (contraaplicación en rendición) y `PE-3` (modo offline), preservando compatibilidad de identidad de comandos.

2. **Obligación previa a habilitar `V_e` (`RD-F04-006`):** antes de activar el reconocimiento provisional en producción, la aceptación central de `UC-03` calculará y conservará auditablemente `saldoExigibleProvisional` desde eventos de tránsito sincronizados, validados e idempotentes y su saldo confirmado (`RD-F04-003/006`). Los eventos exclusivamente offline no alteran la deuda central y toda captura offline se revalida en servidor al sincronizar.

3. **Ausencia de umbral nuevo:** los contratos de admisión vigentes **no** establecen un umbral de deuda que por sí solo impida a un Cliente `ACTIVO` crear un Pedido. Un Cliente `EN_MORA` continúa sujeto a su categoría y recargos vigentes (`RD-F04-007`), sin recategorizarse ni suprimir recargos por tránsito pendiente. **No se activará `409 CLIENTE_CON_DEUDA`** ni se incorporará veto por monto o antigüedad mientras no exista una RD comercial expresa (Alternativa B requerirá nueva RD con importe, mora, excepciones, rol y validaciones).

### `RCG-08` — Permiso editorial limitado `G-CON` (Lote único `E-01..E-10`)

1. Sujeto a la firma de esta Acta, se autoriza únicamente **preparar para revisión** (en rama/PR independiente, sin auto-merge) un lote editorial único **`E-01..E-10`**:

   - **`E-01..E-07`:** consolidación `R08.5` (`REV04B UC-05/06/07`, `REV05 UC-14/29` incl. idempotencia de anulación, `RD-I302-001`).

   - **`E-08`:** adenda a la fuente aplicable en G0 de `REV06B` `UC-15/16` (`docs/08-diagramas/revision/REV06B_CLIENTES_RECETAS_INVENTARIO/propuestos/CONTRATOS_REV06B_TRECE_CORREGIDOS.md`, blob `af5dae3e09562f925092a44784152ec552d855b2`), identificando la fuente preferente G0 antes de editar sin reemplazarla silenciosamente.

   - **`E-09`:** adenda a `REV04A` `UC-03/21` (`saldoExigibleProvisional` sin umbral nuevo, huella completa de idempotencia, reserva ONLINE `IMP-B`).

   - **`E-10`:** adenda `BC-07` (`D9` ADMIN en `UC-29`, acuse Repartidor en `UC-05`, `UC-14` exclusivo `VENDEDOR`), preservando las 15 filas originales, el manifiesto de 67 operaciones y `source-lock` G0.

2. `G-FIS`, `G-DEV` y el despliegue continúan **cerrados**; esta autorización no aprueba DDL, Flyway `V4`, edición de `V1–V3` ni implementación.

---

## 3. Matriz Decisión Comercial vs Delegación Técnica y Bloque de Firma

### 3.1 Qué ratifica negocio vs qué diseña Arquitectura (`G-ARQ` / `G-FIS`)

| Cláusula | Ratificación comercial vinculante | Delegado a `G-ARQ` / `G-FIS` (con prueba exigida) |

|---|---|---|

| **RCG-01** | «Reserva más antigua primero»; liberación atómica; filtro de reembolso por estado/importe | Mecanismo total de desempate; locks/tablas `IMP-B`; prueba multi-reserva y `REEMBOLSO` `RECHAZADO` vs activo |

| **RCG-02** | Valoración por oferta/versión (ARS 27,08); parcial en puerta sin nueva conformidad; rechazo inicial | Representación física sin `DETALLE_PEDIDO(cantidad=0)` ni tocar `V1`/trigger; código HTTP `409` en `G-CON` |

| **RCG-03** | `F_e^{FIFO}` vinculante; `V_e^0`; `C_e=0` solo con unidades > 0; `Q_e` no aditivas | Persistencia atómica en `IMP-B`, estados de tramos y contención `IMP-C`; pruebas `SEM-01..07`, `Q` y `C_e=0` |

| **RCG-04** | `origen='REPARTO'`; arqueo en 3 vistas; custodia separada sin doble ingreso; `BC-07` `D9` | FK a rendición/aplicaciones; ecuación filtrada de arqueo efectivo; matriz negativa de roles/campos |

| **RCG-05** | Huella semántica completa (decimales normalizados, sin timestamp); `409` distinto payload; adenda `anularCobroManual` | Esquema de almacenamiento de claves, auditoría de rechazos pre-COMMIT, firma de anulación y tests de replay |

| **RCG-06** | `idPedido` informativo; preflight 5 señales (no suficiente); reserva ONLINE `IMP-B` | Script/reporte de preflight por BD destino; mecanismo de recuperación de reserva `UC-21` y prueba ante fallos |

| **RCG-07** | `UC-03` evalúa `saldoExigibleProvisional` antes de `V_e`; **sin umbral nuevo** (`409` inactivo) | Cálculo/auditoría de evaluación en servidor y revalidación offline; prueba `EN_MORA` y sincronización repetida |

| **RCG-08** | Lote editorial `E-01..E-10` en PR revisable manteniendo G0 intacto | Revisión cruzada `G-CON/G-ARQ`, grafo `T-05` en PG efímero; puertas `G-FIS/G-DEV` permanecen cerradas |

### 3.2 Resolución formal por cláusula (ratificada con salvedades el 16/11/2026)

| Cláusula | Síntesis de resolución | Estado actual |

|---|---|---|

| `DC-COM-FIFO-001` | FIFO libre aplicado reduce pendiente elegible (confirmada 16/11/2026) | **APROBADA FUNCIONALMENTE** |

| **`RCG-01` (`DC05-08-A`)** | Remanente de reserva, orden «más antigua primero», filtro `REEMBOLSO` | **RATIFICADA CON SALVEDADES (§3.3)** |

| **`RCG-02` (`DC-03-B`)** | Valoración por oferta/versión, parcial en puerta, prohibición DDL ficticia, gate corte | **RATIFICADA CON SALVEDADES (§3.3)** |

| **`RCG-03`** | `F_e^{FIFO}` vinculante en `IMP-B`, `V_e^0`, `C_e=0` con unidades > 0, `Q_e` tipadas | **RATIFICADA CON SALVEDADES (§3.3)** |

| **`RCG-04`** | `origen='REPARTO'`, arqueo 3 vistas, custodia conciliable, `BC-07` `D9` | **RATIFICADA CON SALVEDADES (§3.3)** |

| **`RCG-05`** | Huella semántica completa, invariante pos-mutación, adenda `anularCobroManual` | **RATIFICADA CON SALVEDADES (§3.3)** |

| **`RCG-06`** | `idPedido` no imputativo, preflight 5 señales, reserva `IMP-B` en `UC-21` ONLINE | **RATIFICADA CON SALVEDADES (§3.3)** |

| **`RCG-07`** | Diferimiento `D7-B`/`PE-3`; `RD-F04-006` sin umbral ni `409` nuevo | **RATIFICADA CON SALVEDADES (§3.3)** |

| **`RCG-08`** | Preparación editorial única `E-01..E-10` en `G-CON` (sin merge/DDL/código) | **RATIFICADA CON SALVEDADES (§3.3)** |


**Constancia de ratificación expresa del responsable — declaración textual, sin firma electrónica criptográfica:**

- **Autoridad ratificante:** Machado Victor Leandro.
- **Fecha de ratificación:** 16/11/2026 (Argentina).
- **Resolución:** [ ] Aprobar íntegramente · [x] **Aprobar con salvedades explícitas** · [ ] Devolver para ajustes · [ ] Rechazar.
- **Salvedades expresas por cláusula:** **RCG-01 a RCG-08 ratificadas con las condiciones expresadas en §2, resumidas sin reemplazarlas en §3.3.** Se reconocen decisiones anteriores, especialmente `DC-COM-FIFO-001`, sin volver a votarlas. No se consideran dispensadas las validaciones técnicas, los límites de autorización ni los gates.
- **PR / commit de incorporación del acta ratificada:** [PR #64](https://github.com/leandrito369/ale-milanesas/pull/64) · commit de **incorporación inicial**: [`0a414600a17ceba1d75548ad5e22263a63480a95`](https://github.com/leandrito369/ale-milanesas/commit/0a414600a17ceba1d75548ad5e22263a63480a95) (commit de creación de esta acta; la presente anotación de trazabilidad constituye un commit documental posterior). **PR OPEN/DRAFT, NO MERGEADA.**
- **Fundamento del asiento:** mensaje expreso del responsable: «Cierro aquí, ratifico ya con estas salvedades», acompañado de la identificación de autoridad, fecha y documento consolidado. La presente constancia **no implica verificación criptográfica de firma o identidad**.


### 3.3 Salvedades expresas y vinculantes por cláusula

Estas salvedades son condiciones **integrantes de la ratificación comercial del 16/11/2026**. La descripción de cada cláusula en §2 es la fuente completa: este resumen no autoriza comportamientos adicionales.

| Cláusula | Salvedades que integran la ratificación |
|---|---|
| **RCG-01** | «Reserva válida más antigua primero» con desempate reproducible; liberación y consolidación atómicas, sin crédito ficticio ni doble FIFO. Control de importes efectivamente anulados, reembolsados o restringidos; un reembolso RECHAZADO no bloquea por su mera existencia. Arquitectura define secuencia física y prueba multi-reserva. |
| **RCG-02** | Cotización y redondeos **por oferta/versión**, nunca una base global; `O1` y consentimiento si cambia cantidad **antes** de aceptar; merma en reparto **después** de aceptación no exige conformidad nueva y solo cobra cantidad entregada. CR-C/CR-F deben resolver producto inactivo, `uq_detalle_pedido_0`, trigger y FKs sin líneas originales ficticias. |
| **RCG-03** | `F_e^{FIFO}` como aplicación **vinculante, única y atómica en IMP-B**; `V_e^0=min(D_e,E_e)` solo con `K_e` acreditado. `C_e=0` no permite Entrega sin unidades; diferencias `Q` por tramos/etapa, no aditivas, con `IMP-C` si falta evidencia. |
| **RCG-04** | Cobro de rendición por ADMIN con `COBRO.origen='REPARTO'` y vínculo verificable; cabecera de recorrido y atribuciones por Cliente/Entrega. Custodia sin Cobro ficticio ni segunda recepción; arqueo en tres vistas **sin sumar UC-23 global a billetes**, con ecuación filtrada por efectivo y roles BC07 preservados. |
| **RCG-05** | Fingerprint semántico completo y versionado; mismo comando recupera recibo histórico aunque su Cobro posteriormente esté ANULADO; payload diferente devuelve conflicto; anulación requiere clave propia, motivo e IDs de contraasientos. Corregir defectos actuales de UC-03 y Cobro durante G-DEV, previa adenda G-CON. |
| **RCG-06** | `COBRO.idPedido` es contextual, no imputación; preflight por Cliente/obligación con **cinco señales indicativas no exhaustivas**, contención selectiva y prohibición de backfill heurístico. En `UC-21`, pago online acreditado crea reserva explícita `IMP-B` recuperable y sin suponer ACID distribuido con Mercado Pago. |
| **RCG-07** | Antes de encender tránsito provisional, `UC-03` debe calcular y auditar saldo exigible provisional y revalidar capturas; **sin veto nuevo por deuda ni 409 CLIENTE_CON_DEUDA** sin RD comercial expresa. Categoría y recargos vigentes se mantienen; `D7-B` y `PE-3` diferidas. |
| **RCG-08** | Habilitar **solo preparación para revisión** del lote editorial `E-01..E-10` (REV04A, REV04B, REV05, REV06B y BC07); preservar G0, source-lock y las matrices originales. **Sin auto-merge, SQL, V4, cambios Java, ampliación unilateral de permisos ni despliegue**. |

**Salvedad transversal:** esta ratificación cierra `G-COM` **comercialmente**, no acredita pruebas ejecutadas, aprobación editorial definitiva, CR-C/CR-F, diseño de persistencia, G-FIS, G-DEV, G-VAL ni levantamiento de la pausa de despliegue (Issue app #28). Las PRs de respaldo conservan su estado individual OPEN/DRAFT hasta revisión.

---

## 4. Anexo Compacto de Trazabilidad, Alcance `T-05` y Fuentes Congeladas

### 4.1 Fuentes y PRs de referencia congelados al 16/11/2026

> PRs en estado `OPEN/DRAFT / NO MERGED` y blobs inspeccionados únicamente como referencia de este corte (no implican integración en `main`):

| Origen | Identificador / Blob SHA verificado | Alcance principal |

|---|---|---|

| **`PR #44`** | HEAD `e5e82f843f8a579e3201a332c645f62680d56832` · `docs/01-gobierno/b0/RD_I302_001_PROPUESTA_ENTREGA_EFECTIVO_TRANSITO_IDEMPOTENCIA_2026-11-09.md` (`a181abaeb4225a4c20fc9f63b0aaf7fe8ff86fcf`) | Propuesta entrega, efectivo en tránsito e idempotencia (`OPEN/DRAFT`) |

| **PRs `#47`, `#48`** | `#47`: `9c0a54e4a2147f5f048f7827f26a21b1bfeecf1b` · `#48`: `fda51c929258dc42e71c40c95bbcd89d0324c306` | `CR-C` / `CR-F` `UC-07` (`OPEN/DRAFT`) |

| **PRs `#50`, `#52`–`#54`** | `#50`: `c36920e09f6ea57a96e246592ffa01be72c65e56` · `#52`: `adf77bc2c4f3d7e88a1c301926bdd607dd6a4a78` · `#53`: `7448e123c3c43c51d48def6a22d10b58679efb2d` · `#54`: `cc948fcde1ac2dbfe0a78febff6fd2326b8de258` | `D5-B/D6-1/D7-A`, `ANT-01`, `R08.4`, `R08.5` (`OPEN/DRAFT`) |

| **PRs `#55`–`#63`** | `#55`: `9aa8a48ca936dcc9244fcb4da2de6d6262d276ed` · `#56`: `3047e1a327c5447cae3a6538a2712d29a303f4ff` · `#57`: `bffb510658bb7d0916426165a714446a9fb59812` · `#58`: `4a72197a626e840ba9e81547f9e5571ee73d9c08` · `#59`: `84ea674df6f151792b628b7cd7ca6317814c3f10` · `#60`: `3bbb6187141255c472e246aa5fcfdb836c0a6dcb` · `#61`: `3abfff88ff3744fb02f4336c60ce17c65653a765` · `#62`: `a3bd12d552f2f45baffca147f6cafdaa84284bcb` · `#63`: `78f9dd6b6a3cb2e9caa193f5bc2b483cfd9ed6be` | `DC05-01..09-A`, `D12-C`, `DC-01-C1`, `DC-02/04-A` (`OPEN/DRAFT`) |

| **Blobs `main` / G0** | Roadmap: `b2a8db21659b6bb343a5e89bc798370859213c72` · `RD-F04-002`: `1b84bba458c012fe140c9eb6a96a9cd6f88453c8` · `RD-F04-005`: `c9c171b3946c5aa23faa98bfc85fd5854301d55b` · `RD-F04-006`: `ada45f59ae3b8766ac022381a9eb4f138e554f2a` · `REV05`: `fd6af871224f23b4a0a545de9155f07bfdbd991a` · `REV06B` G0 (`CONTRATOS_REV06B_TRECE_CORREGIDOS.md`): `af5dae3e09562f925092a44784152ec552d855b2` | Fuentes contrastadas en repo documental |

### 4.2 Alcance técnico de concurrencia (`T-05`) y próximos gates

- **Grafo `T-05`:** incluirá **`ASIGNACION_REPARTO` / `UC-43`** junto con `CLIENTE`, `PEDIDO`, `COBRO` y `UC-15`. La inversión potencial de locks se registra como **riesgo de intercalado** (no como `40P01` demostrado) y se validará en PostgreSQL efímero (Testcontainers) con timeouts y verificación de efectos y hashes en el libro `IMP-B`, sin fijar orden SQL de locks en esta Acta comercial.

- **Secuencia de puertas:** `G-COM` (ratificación comercial expresa) → `G-CON` (revisión/aprobación PR lote `E-01..E-10`) → `G-ARQ` (protocolos, grafo `T-05`, ecuación de arqueo, preflight) → `G-FIS` (autorización DDL/Flyway `V4` si procede) → `G-DEV` (implementación + pruebas `SEM-01..07`, `CON-01..15`, `FIN-01..14`, `RCM`, idempotencia, RBAC negativa, `BC-06`) → `G-VAL` / despliegue (`Issue app #28`).
