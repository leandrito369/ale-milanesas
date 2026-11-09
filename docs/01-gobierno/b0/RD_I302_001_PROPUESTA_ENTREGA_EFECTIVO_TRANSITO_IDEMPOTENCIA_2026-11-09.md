# RD-I302-001 (PROPUESTA) — Decisiones de arquitectura para I3-02: Entrega, efectivo en tránsito e idempotencia

**Fecha de redacción:** 09/11/2026
**Estado:** **PROPUESTA — NO RATIFICADA.** Este documento no es una decisión del responsable, no aprueba estructura física alguna, no autoriza migraciones ni implementación de `UC-05`.
**Autoridad que debe decidir:** Victor Leandro Machado (responsable del proyecto).
**Numeración:** `RD-I302-001` es provisional. Verificado en `docs/01-gobierno/` y `docs/01-gobierno/b0/` el 09/11/2026: no existe ninguna RD `I302`; la última del bloque es `RD-I301-001`.
**Alcance:** persistencia del efectivo en tránsito declarado en `UC-05`, idempotencia de `UC-05` y dependencias con F04. Los gaps de tarificación de excedentes y de líneas adicionales de `UC-07` se **conservan sin resolver** en la sección 14.

## Leyenda de estados usada en este documento

| Etiqueta | Significado |
|---|---|
| **APROBADO** | Decisión ya ratificada por el responsable en una RD/acta existente (se cita la fuente). |
| **PROPUESTO** | Diseño sugerido aquí; requiere decisión expresa del responsable. |
| **PENDIENTE** | Decisión o dato que falta; no se resuelve en este documento. |
| **IMPLEMENTADO** | Existe en código/SQL de `ale-milanesas-app` (se cita archivo y línea). |
| **PROBADO** | Hay prueba ejecutada con resultado. **Nada en este documento está PROBADO.** |

---

## 1. Contexto y problema

`UC-05 — Registrar Entrega` tiene la firma canónica `registrarEntrega(idPedido, detallesEntrega, efectivoDeclaradoRecibido[0..1], claveIdempotencia)` ([CONTRATOS_REV04B §2, L59](../../08-diagramas/consolidacion-b0/CONTRATOS_REV04B_CORREGIDOS_B0_ACTUALIZADO.md)).

Dos elementos de esa firma **no tienen hoy soporte físico**:

1. **`efectivoDeclaradoRecibido`.** La tabla `ENTREGA` tiene solo `idPedido`, `fechaHoraEntrega`, `idUsuarioRepartidor` (`V1__baseline_mr5.sql` L205–210). No existe tabla de pago en tránsito. El propio contrato lo declara: «Persistencia pendiente (MR-5/MR-6)» (CONTRATOS_REV04B L71).
2. **`claveIdempotencia`.** `ENTREGA` no tiene columna para la clave. El contrato dice que exige «mecanismo de sincronización técnica pendiente» (L71).

El responsable pidió una propuesta para persistir el efectivo en tránsito de forma real, transaccional y auditable. Quedan **excluidas como solución suficiente**: guardar el importe solo en logs, devolverlo solo en la respuesta HTTP, conservarlo en memoria, suponer que la PK de `ENTREGA` resuelve la idempotencia, o crear un `COBRO` antes de su autorización.

> **Corrección respecto de la auditoría previa de I3-02.** El informe de auditoría anterior planteó como «Opción 1A» registrar el importe en el DTO de respuesta y en logs sin persistirlo. Esa opción **no es admisible** según las restricciones de este encargo y queda descartada. También afirmó que la idempotencia podía apoyarse en `pk_entrega` y `uq_origen_movimiento_cuenta_0`; la sección 8 demuestra que eso no alcanza.

## 2. Fuentes canónicas consultadas

SHAs verificados el 09/11/2026 antes de redactar: gobierno `main` = `d848f73`; implementación `main` = `d5f7607`. Ambos árboles limpios.

### 2.1 Gobierno (`leandrito369/ale-milanesas`)

| Fuente | Qué aporta a esta propuesta |
|---|---|
| [Plan Rector](../PLAN_RECTOR_IMPLEMENTACION_2026-10-29.md) L12, L84 | F04 offline/rendición «funcionalmente acordado, persistencia S-01/API todavía propuesta; se exige CR antes de modificar esquema». |
| [Backlog priorizado](B0_BACKLOG_PRIORIZADO_Y_GATE_G0_2026-10-29.md) L23 | «No fusionar declaración de efectivo UC-05 con Cobro UC-29». |
| [Manifiesto canónico 67 operaciones](G0_MANIFIESTO_CANONICO_67_OPERACIONES_2026-10-29.csv) L7 | `UC-05`/`registrarEntrega` con contrato B0 derivado. No hay operación de «rendición» entre las 67. |
| [CONTRATOS_REV04B](../../08-diagramas/consolidacion-b0/CONTRATOS_REV04B_CORREGIDOS_B0_ACTUALIZADO.md) §2 L57–107 | Firma, notas, excepciones A1–A5, postcondiciones de `UC-05`. |
| [CONTRATOS_REV05](../../08-diagramas/consolidacion-b0/CONTRATOS_REV05_CORREGIDOS_B0_ACTUALIZADO.md) UC-14 (L19, L37), UC-29 (L51, L61, L83) | `saldoExigibleProvisional = saldoConfirmado − pagosEnTransitoValidados`; rendición recibida **exclusivamente por el Administrador**; retiro atómico del efecto provisional al contabilizar. |
| [RD-F04-001](../RD_F04_001_ALCANCE_OFFLINE_2026-10-26.md) | `UC-05` admite captura offline; no se aplica en servidor hasta validar; `UC-43` solo online. |
| [RD-F04-002](../RD_F04_002_RENDICION_EFECTIVO_2026-10-26.md) | El Administrador recibe y autoriza la rendición al cierre de cada recorrido; la diferencia queda pendiente de conciliación. |
| [RD-F04-003](../RD_F04_003_PAGO_EN_TRANSITO_SALDO_PROVISIONAL_2026-10-26.md) | Pago en tránsito independiente de `COBRO`; reduce solo la deuda exigible provisional tras validación; diseño físico **pendiente**. |
| [RD-F04-004](../RD_F04_004_DECLARACION_EFECTIVO_UC05_2026-10-26.md) | El Repartidor declara efectivo en `UC-05`; no es `UC-29`; lista pendientes (importes superiores a la deuda, prueba de recepción). |
| [RD-F04-005](../RD_F04_005_DIFERENCIA_PAGO_EN_TRANSITO_2026-10-26.md) | Faltante: rendición pendiente de conciliación; la deuda no reaparece automáticamente; tratamiento definitivo **no decidido**. |
| [RD-F04-006](../RD_F04_006_EVALUACION_DEUDA_NUEVOS_PEDIDOS_2026-10-26.md) / [007](../RD_F04_007_AJUSTE_EN_MORA_PAGO_TRANSITO_2026-10-26.md) | Nuevos Pedidos evalúan deuda con saldo exigible provisional; sin recategorización automática. |
| [RD-F01](../RD_F01_ESTADOS_COBRO_2026-10-26.md) | `COBRO.estadoCobro` solo `CONFIRMADO`/`ANULADO`; lo offline/pendiente va fuera de `COBRO`. |
| [RD-RP004/RP028-001](../RD_RP004_RP028_001_CONSULTAS_ECONOMICAS_2026-10-27.md) regla 5 | `UC-14` distingue saldo confirmado, pagos en tránsito validados y saldo exigible provisional. |
| [RD-RP007-001](../RD_RP007_001_PERMISOS_UC29_2026-10-26.md) | `UC-29` solo Administrador y Vendedor; que el Vendedor tenga `UC-29` **no** lo autoriza a recibir rendiciones. |
| [RD-RP020-001](../RD_RP020_001_REPROGRAMACION_PEDIDOS_2026-10-27.md) | La reprogramación invalida la asignación; una captura offline con asignación invalidada no se acepta automáticamente. |
| [CR-B0-F04-001](CR_B0_F04_001_DISENO_FISICO_SINCRONIZACION_PENDIENTE_2026-10-29.md) | Abierta. Pide decidir si realmente se requieren tablas/columnas nuevas y cubre inbox, locks, conflictos, pago en tránsito y rendición. |
| [RD-B0 arquitectura](RD_B0_ADR_ARQUITECTURA_APROBADA_2026-10-29.md) | ADR-B1-05 **no ratificada** como diseño físico; sujeta a la CR. |
| [Matriz RBAC](B0_MATRIZ_RBAC_67_OPERACIONES_CIERRE_2026-10-29.csv) L7, L17, L18, L32, L47 | `UC-05` solo Repartidor; `UC-14` solo Vendedor (Administrador `X`); `UC-15` solo Automatismo (`I`); `UC-29` Administrador y Vendedor (Repartidor `X`). |
| [BC07](BC07_PROYECCIONES_MINIMAS_RATIFICADAS_2026-10-29.csv) | No hay proyección ratificada para un registro de pago en tránsito. |
| [BC09](BC09_REGLA_INVOCACION_INTERNA_EXTERNA_2026-10-29.md) | Automatismo/Cliente ONLINE/MercadoPago ≠ rol humano interno. |
| [MR5 contratos de servicios](../../05-modelo-relacional/MR5_CONTRATOS_SERVICIOS.md) S-01 | Entrada mínima con UUID inmutable; verificación de duplicado por `claveIdempotenciaOrigen`/`idOperacionOrigen`; «hoy no existe un inbox/snapshot dedicado». |

### 2.2 Implementación (`leandrito369/ale-milanesas-app`)

| Fuente | Hallazgo verificado |
|---|---|
| `V1__baseline_mr5.sql` L205–210 | `ENTREGA`: `pk_entrega (idPedido)`; sin columna de clave ni de efectivo. |
| L787–814 | `MOVIMIENTO_CUENTA` y `ORIGEN_MOVIMIENTO_CUENTA` con `uq_origen_movimiento_cuenta_0 UNIQUE (idPedidoEntrega)`. |
| L766–785 | `COBRO.claveIdempotenciaOrigen UUID` con `uq_cobro_0 UNIQUE`; `ck_cobro_2 origen IN ('REPARTO','ONLINE','ADMINISTRACION')`. |
| L816–830 | `MOVIMIENTO_CAJA` con `uq_movimiento_caja_0 UNIQUE (idCobro)`. |
| L138–164 | `PEDIDO.idOperacionOrigen UUID` con `uq_pedido_0 UNIQUE`: precedente de clave de operación como columna única de la entidad. |
| L1391–1411 | `fn_mr5_bloquear_mutacion_asiento` y triggers de inmutabilidad de `MOVIMIENTO_CUENTA`, `ORIGEN_MOVIMIENTO_CUENTA`, `MOVIMIENTO_CAJA`. |
| `V2__f01_cobro_estados.sql`, `V3__trazabilidad_partidas_insumo.sql` | Sin tabla de tránsito ni inbox (V3 agrega solo las 2 tablas de partidas: 62 tablas en total). |
| `finanzas/CobroManualService.java` L40–81, L184 | Idempotencia de `UC-29` por `claveIdempotenciaOrigen` **comparando el contenido** (cliente, pedido, importe, medio, origen, estado) y fallando con «Clave de operacion ya utilizada con otros datos». Lock de identificadores `pg_advisory_xact_lock(2929001)`. Declara «NO incorpora efectivo en tránsito de UC05/F04». |
| `ventas/CargarPedidoService.java` L44–77 | Idempotencia de `UC-03` por `PEDIDO.idOperacionOrigen`; la comparación de contenido es **parcial** (solo cliente y canal; no compara ítems). Locks `(3003,0)` y `advisory(idCliente)`. No consulta saldo ni deuda. |
| `ventas/AsignarRepartoService.java` L28–36 | Locks `9172001`, `(60505,7)`, luego `ASIGNACION_REPARTO … FOR UPDATE`. |
| `finanzas/EvaluadorCategoriaComercialInterno.java` L14, L43–49, L64 | `UC-15` usa **deuda confirmada** (`MOVIMIENTO_CUENTA`), `CLIENTE FOR UPDATE`; usa `ENTREGA.fechaHoraEntrega` para antigüedad. |
| `abastecimiento/RegistrarIngresoStockReventaService.java` L38–39 | Locks `(808,0)` y `advisory(idProducto)` para stock de reventa. |

Búsqueda de locks (`pg_advisory_xact_lock`) en `src/main/java`: los prefijos vigentes son `9172001`+`(60505,7)` (acceso y reparto), `2929001` (cobro), `(3003,0)`+`idCliente` (pedido), `(808,0)`+id de elemento (inventario), `5715001`, `5051052`, `3030047`, `1919001`, `3202001` (maestros y política). Ningún servicio toma dos de estos grupos en orden inverso a otro.

### 2.3 Qué no se pudo verificar

- No existe aún el documento DS/DSS operacional de `UC-05` en `ale-milanesas-app`. El diseño de secuencia lo aportan los diagramas `DS_REV04B_CORREGIDO.drawio.xml` (L419–L527), que muestran el orden funcional pero no locks ni SQL.
- No se ejecutó ninguna prueba de concurrencia ni DDL para esta propuesta.

## 3. Decisiones funcionales ya ratificadas (APROBADO)

| Regla innegociable del encargo | Respaldo APROBADO |
|---|---|
| R1. El Repartidor declara efectivo en `UC-05`; no es `UC-29`. | RD-F04-004; RD-RP007-001; matriz RBAC L32 (Repartidor `X` en `UC-29`). |
| R2. Sin `COBRO`, sin `MOVIMIENTO_CAJA`, sin cambio de saldo confirmado; reduce solo la deuda exigible provisional. | RD-F04-003 §1; RD-F04-004; RD-F01; contrato `UC-05` nota «Efectivo en tránsito» (L69). |
| R3. Asociar a Pedido, Entrega, Cliente, Repartidor, importe e identidad de la operación; validar autorización y asignación. | Contrato `UC-05` precondiciones (L93), excepción A1 (L77); RD-F04-004 punto 3. |
| R4. Reenvío idempotente sin duplicar efectos. | Contrato `UC-05` A5 (L85); RD-F04-004 casos de aceptación; MR5 S-01. |
| R5. Rendición sin doble imputación; el efecto provisional cesa; se conserva la declaración. | Contrato `UC-29` L61 y L83; RD-F04-004 caso «Rendición y Cobro definitivo». |
| R6. Captura offline ≠ confirmación del servidor. | RD-F04-001; RD-F04-003 punto 5. |
| El faltante no reexige la deuda al Cliente. | RD-F04-005. |
| Rendición solo por Administrador. | RD-F04-002; contrato `UC-29` L61. |

**Lo que NO está aprobado:** ninguna tabla, columna, índice, trigger, estado técnico ni migración. RD-F04-003 punto 7 deja explícito que ni siquiera el literal `PENDIENTE_RENDICION` está aprobado.

## 4. Alternativas arquitectónicas

### Alternativa A — Tabla independiente de pago en tránsito (PROPUESTO)

Una entidad específica `PAGO_EN_TRANSITO` (nombre provisional) con una fila por declaración.

- **Relación con `ENTREGA`:** 1:1 opcional. `UC-05` es una única entrega definitiva por Pedido (`pk_entrega`), y el contrato crea la declaración solo si `efectivoDeclaradoRecibido > 0` (CONTRATOS_REV04B L99). La fila puede usar `idPedido` como PK y FK a `ENTREGA`.
- **Identidad de la operación:** **no** resuelve por sí sola la clave cuando no hay efectivo (no se crea fila), por lo que A no basta para la idempotencia de `UC-05`.
- **Repartidor y Cliente:** derivables por join (`ENTREGA.idUsuarioRepartidor`, `PEDIDO.idCliente`). Almacenarlos duplicaría datos y exigiría `UNIQUE` adicionales en tablas base para FK compuestas (existe precedente: `uq_oferta_excedente_0`, `uq_cobro_2`).
- **Estados:** una declaración inmutable, más una tabla de aplicación separada para la rendición (ver 7.3), evita una columna de estado mutable sobre dinero.
- **Auditoría:** inmutabilidad con la función existente `fn_mr5_bloquear_mutacion_asiento`.

### Alternativa B — Extensión de `ENTREGA` (columnas físicas)

Agregar `efectivoDeclaradoRecibido` y la clave a `ENTREGA`.

- **Ventajas:** una sola fila; atomicidad trivial; cero tablas nuevas.
- **Limitaciones:**
  - Convierte a `ENTREGA` en una tabla con **estado financiero mutable** si se agregan estados de rendición.
  - No representa rendiciones parciales ni múltiples cobros que cubren una declaración (relación N:M con `COBRO`).
  - Mezcla la evidencia de entrega con el ciclo de vida del efectivo; la conciliación y la trazabilidad histórica quedan atadas a una tabla que `UC-15` y `ORIGEN_MOVIMIENTO_CUENTA` ya referencian.
  - `NULL` vs `0` para «no declaró» queda ambiguo en una columna.
  - La futura sincronización offline necesita campos adicionales (captura local, estado de validación), que engrosarían `ENTREGA`.
- **Lo que sí es rescatable de B:** una **única columna de clave** en `ENTREGA`, por coherencia con `PEDIDO.idOperacionOrigen` y `COBRO.claveIdempotenciaOrigen` (ver 6).

### Alternativa C — Registro transaccional de operaciones (inbox)

Una tabla de operaciones con UUID, tipo, usuario, huella del contenido, estado y resultado.

- **Aporta:** deduplicación para cualquier operación offline (`UC-03` y `UC-05`); registro persistente de eventos **rechazados o en conflicto**, que S-01 exige («registrar para conciliación y responder estado de rechazo/no aplicado»); recuperación de resultados.
- **No reemplaza a A ni a B:** no representa el dinero ni su ciclo de vida.
- **Costo:** introduce un concepto transversal cuyo diseño completo (retención, autenticación de dispositivo, estados de conflicto) está cubierto por la CR abierta y **no puede cerrarse en I3-02**.
- **Conclusión:** C **complementa** a A. Su versión completa se necesita recién con B7; para `UC-05` online alcanza con un mecanismo de clave más simple (ver 6).

## 5. Comparación de alternativas

| Criterio | A (tabla) | B (columnas en `ENTREGA`) | C (inbox) |
|---|---|---|---|
| Persiste el importe de forma auditable | Sí | Sí | No |
| Idempotencia cuando no hay efectivo | No (sin fila) | Sí, con columna de clave | Sí |
| Detecta «misma clave, otro contenido» | Solo del importe | Con comparación contra filas persistidas | Con huella o comparación |
| Rendiciones parciales / N:M con `COBRO` | Sí (con tabla de aplicación) | No sin tablas extra | No aplica |
| Inmutabilidad del evento financiero | Sí (trigger) | Parcial (la tabla tiene otras columnas) | Sí |
| Registra rechazos/conflictos offline | No | No | **Sí** |
| Cambios sobre tablas base | Ninguno | `ALTER TABLE ENTREGA` | Ninguno |
| Tablas nuevas | 1 | 0 | 1 |
| Alcance dentro de I3-02 | Cabe | Cabe | **Excede** (pertenece a B7/CR) |
| Compatibilidad con B7 | Extensible con columnas nulas | Engrosa `ENTREGA` | Diseñada para B7 |
| Precedente en el repositorio | Tablas de movimiento inmutables (L1403–1411) | `PEDIDO.idOperacionOrigen` (L154, L164); `COBRO.claveIdempotenciaOrigen` (L776–779) | Ninguno (S-01 lo declara inexistente) |

## 6. Diseño recomendado (PROPUESTO)

Se recomienda **dividir el diseño en tres fases** (opción C del punto 14 del encargo):

| Fase | Contenido | Estado |
|---|---|---|
| **PE-1 — Persistencia online mínima** | `PAGO_EN_TRANSITO` (A) + una columna de clave `idOperacionOrigen` en `ENTREGA` (rescate de B) | **PROPUESTO** para ratificación; habilita `UC-05` en I3-02c |
| **PE-2 — Rendición y aplicación** | Tabla de aplicación que enlaza la declaración con `COBRO` (N:M) y la operación de rendición del Administrador | **PROPUESTO conceptualmente**; requiere decisiones propias (sección 14) y su propia RD |
| **PE-3 — Sincronización offline** | Inbox (C): rechazos, conflictos, retención, dispositivo | **PENDIENTE**; pertenece a B7 y a la CR |

### Justificación de PE-1

1. **Una sola tabla nueva y una sola columna nueva.** CR-B0-F04-001 pide justificar si realmente se necesitan; esto es el mínimo que cumple las restricciones del encargo (no logs, no solo HTTP, no memoria).
2. **La clave vive en `ENTREGA`, no en un inbox.** Sigue el patrón ya implementado para `PEDIDO` y `COBRO`: la entidad resultante lleva su clave `UNIQUE`. Así el resultado de la operación se recupera por la clave (escenario «respuesta perdida»), también cuando no hubo efectivo.
3. **La comparación de contenido se hace contra filas persistidas** (`DETALLE_ENTREGA`, `PAGO_EN_TRANSITO`), como hace `CobroManualService` (L70–78), sin almacenar una huella. A diferencia de `CargarPedidoService` (L68–70, que compara solo cliente y canal), la propuesta compara **todo el contenido de la solicitud**; ver escenario 3 en la sección 8.
4. **El dinero queda separado de la entrega** y es inmutable; el ciclo de vida de rendición se modela aparte (PE-2) sin alterar la evidencia original.
5. **No anticipa B7.** Los rechazos offline no se persisten en PE-1 (ver 8.3); el modelo no impide agregar PE-3 después.

### Variante de respaldo (PROPUESTO, menos recomendada)

Si el responsable prefiere **no alterar `ENTREGA`**: guardar la clave en una tabla mínima de operaciones (versión reducida de C: UUID PK, tipo, usuario, `idPedido`, fecha). Se pierde el precedente `idOperacionOrigen` y se adelanta un concepto de B7. No se recomienda.

## 7. Persistencia propuesta

> **TODO lo de esta sección es PROPUESTO.** No se creó ningún archivo SQL ni migración V4; no se modificó V1/V2/V3. Los nombres son provisionales.

### 7.1 Tabla `PAGO_EN_TRANSITO` (PE-1)

| Columna | Tipo | Nulabilidad | Notas |
|---|---|---|---|
| `idPedido` | `BIGINT` | NOT NULL | **PK** y **FK → `ENTREGA(idPedido)`** `ON UPDATE/DELETE RESTRICT`. Una declaración por Entrega. |
| `importeDeclarado` | `NUMERIC(18,2)` | NOT NULL | `CHECK (importeDeclarado > 0)`. Misma precisión que `COBRO.importe`. Con `efectivoDeclaradoRecibido` nulo o 0 **no se crea fila**. |
| `fechaHoraRegistroServidor` | `TIMESTAMPTZ` | NOT NULL | Reloj del servidor (`clock_timestamp()`), igual que las demás entidades. |

- **Inmutable:** trigger `BEFORE UPDATE OR DELETE` con `fn_mr5_bloquear_mutacion_asiento` (L1391).
- **Repartidor y Cliente no se duplican:** se obtienen de `ENTREGA.idUsuarioRepartidor` y `PEDIDO.idCliente`. `PEDIDO.idCliente` está protegido por `tg_mr5_validar_pedido_cambio_cliente` (V1 L1675). Esto garantiza por construcción la consistencia pedido–entrega–cliente–repartidor (R3) sin `UNIQUE` extra en tablas base.
- **Índices:** la PK cubre la búsqueda por Pedido. La suma por Cliente se resuelve por join con `PEDIDO`; el índice por `idCliente` debe **verificarse en el DS** (no se confirmó en V1).
- **No se agregan estados.** No hay columna de estado de rendición (ver 7.3).
- Campos de captura offline (`fechaHoraCapturaLocal`, dispositivo) **no se incluyen**: son PE-3 y se agregarían como columnas nulas.

### 7.2 Columna `ENTREGA.idOperacionOrigen` (PE-1)

| Atributo | Propuesta |
|---|---|
| Tipo | `UUID` |
| Restricción | `UNIQUE` (precedente: `uq_pedido_0`, V1 L164) |
| Nulabilidad | **Nullable**, igual que `PEDIDO.idOperacionOrigen` (L154). Las filas históricas, si las hubiera, no tienen clave. El **servicio** debe exigirla siempre; no se puede imponer `NOT NULL` sin tocar filas existentes. |
| Contenido | La `claveIdempotencia` del contrato, generada por el cliente (en offline, el UUID inmutable de captura, según MR5 S-01). |

Cambio **aditivo**: no altera columnas, PK ni FK existentes. `EvaluadorCategoriaComercialInterno` consulta `ENTREGA` por columnas concretas (L64), por lo que no se ve afectado; confirmar en el DS.

### 7.3 Tabla de aplicación `APLICACION_PAGO_EN_TRANSITO` (PE-2, conceptual)

Para cumplir R5 se **propone conceptualmente**; su diseño físico final requiere su propia RD (sección 14).

| Columna | Notas |
|---|---|
| `idPedido` (FK → `PAGO_EN_TRANSITO`), `idCobro` (FK → `COBRO`) | PK compuesta. N:M: un cobro del Cliente puede cubrir varias declaraciones y una declaración puede cubrirse en varias rendiciones parciales. |
| `importeAplicado` `NUMERIC(18,2)` | `CHECK (> 0)`. |
| `fechaHoraAplicacion`, `idUsuarioAdministrador` | Trazabilidad de quién rindió/concilió. |
| Invariantes | Σ `importeAplicado` por declaración ≤ `importeDeclarado` (restricción diferida o trigger con `FOR UPDATE` de la declaración); Σ por cobro ≤ `COBRO.importe`; el Cliente del `COBRO` debe ser el del Pedido. |
| Inmutable | Igual que el resto de asientos. |

### 7.4 Inbox offline (PE-3)

No se propone esquema. Debe cubrir, como mínimo: estado `CONFLICTO` auditable, deduplicación, retención, dispositivo e identidad. Queda dentro de CR-B0-F04-001.

### 7.5 Efecto en cifras del Modelo Relacional

MR-5 = 60 tablas / 453 columnas / 125 FK (cifras históricas citadas por la CR). MR-6 vigente en implementación = 62 tablas (V3). **PROPUESTO:** PE-1 llevaría el modelo a 63 tablas (+1) y +1 columna en `ENTREGA`; PE-2 sumaría otra tabla. Las cifras definitivas deben recalcularse tras ratificar y verificarse con PostgreSQL.

## 8. Idempotencia y concurrencia

### 8.1 Por qué la PK de `ENTREGA` no alcanza

`pk_entrega (idPedido)` impide una **segunda** entrega por Pedido, pero:

1. No distingue una **repetición legítima** (mismo UUID, cliente reintentando) de un **conflicto** (otro intento sobre un pedido ya entregado): ambos chocan con la misma PK.
2. No permite **recuperar el resultado** previo por la identidad de la operación.
3. No detecta «misma clave, contenido distinto».
4. `uq_origen_movimiento_cuenta_0 UNIQUE (idPedidoEntrega)` y `uq_movimiento_stock_reventa_2` son unicidades **por Pedido/ítem**, no por operación.

La unicidad del Pedido y la idempotencia por identidad de operación son dos cosas distintas. La clave de `7.2` aporta la segunda.

### 8.2 Escenarios (PROPUESTO)

Resumen de comportamiento. «Replay» = devolver el resultado previo reconstruido desde filas persistidas, sin escribir.

| # | Escenario | Comportamiento propuesto | Resultado HTTP sugerido |
|---|---|---|---|
| 1 | Primera solicitud válida | Ejecuta toda la transacción (8.4); persiste `ENTREGA.idOperacionOrigen`. | 201 |
| 2 | Misma clave, mismo contenido | Se halla `ENTREGA` por la clave; el contenido coincide; **replay** sin escrituras. Respuesta marcada como repetida. | 200 |
| 3 | Misma clave, contenido distinto | Se halla la `ENTREGA`; el contenido difiere (`idPedido`, cantidades, importe declarado, repartidor). **Sin modificar nada.** Mensaje genérico, sin revelar datos. | 409 `CLAVE_YA_UTILIZADA` |
| 4 | Clave nueva, Pedido ya entregado | No existe la clave; el Pedido no está `PENDIENTE` (contrato A1). No es replay. | 409 |
| 5 | Respuesta perdida después de commit | Reintento con la misma clave → escenario 2. Todo el resultado (cargo, excedentes, efectivo) se reconstruye desde `MOVIMIENTO_CUENTA`/`ORIGEN`, `EXCEDENTE` y `PAGO_EN_TRANSITO`. | 200 |
| 6 | Dos solicitudes concurrentes | Se serializan por locks (8.3); la segunda ve el commit y cae en 2 o 3. Mismo Pedido, otra clave → 4. | 200/409 |
| 7 | Reintento de sincronización offline | Igual que 2: el UUID de captura es `idOperacionOrigen`. Reintentar tras un rechazo vuelve a evaluarse con el estado actual; no hay estado «rechazado» persistido en PE-1. | 200/409 |
| 8 | Rechazo por asignación invalidada | La validación falla antes de cualquier escritura; **rollback total**, la clave **no queda consumida**. Sin éxito simulado. En offline, el registro del conflicto para conciliación requiere PE-3. | 409 |

- **Misma clave por otro usuario o para otro Pedido:** `409 CLAVE_YA_UTILIZADA` **sin** devolver el resultado ajeno (no filtrar información entre repartidores).
- **Retención:** la clave vive en `ENTREGA`, entidad permanente. No hay purga ni caducidad en PE-1. La retención del inbox (PE-3) queda **PENDIENTE**.
- **Validación previa a consumir la clave:** una solicitud rechazada por validación (400/403) no escribe nada, por lo que no consume la clave. Es una decisión de comportamiento que el responsable debe confirmar (D3).

### 8.3 Orden de locks (PROPUESTO; a validar en el DS con prueba de concurrencia)

**No se modifica el orden de ningún servicio existente.** Los prefijos actuales son parciales y consistentes entre sí (sección 2.2). La propuesta para `UC-05` sigue las mismas convenciones:

| Paso | Lock | Motivo y precedente |
|---|---|---|
| 0 | Autorización de sesión (rol `REPARTIDOR`) antes y **después** de tomar locks | Patrón `AsignarRepartoService` L26–30. |
| 1 | `advisory(9172001)` y `advisory(60505,7)` | Serializa con `UC-43` y con cambios de usuario/rol: la asignación vigente y la habilitación del Repartidor no cambian durante la entrega. Mismo orden que `AsignarRepartoService` L28–29. |
| 2 | `advisory(2929001)` | **Dependencia nueva:** `UC-05` genera ids con `MAX+1` en `MOVIMIENTO_CUENTA`/`ORIGEN`, generador ya protegido por este lock en `CobroManualService` L184. Si `UC-05` no lo toma, ambos pueden obtener el mismo `idMovimientoCuenta` o `numeroSecuenciaCliente`. |
| 3 | Lock de la clave: `advisory` en espacio de dos enteros dedicado (a definir en DS) | Evita que dos Pedidos distintos con la misma clave lleguen al `INSERT` y fallen por violación de `UNIQUE` dentro de la transacción. |
| 4 | `advisory(idCliente)` (un entero) | Serializa con `CargarPedidoService` L48 por Cliente (futura evaluación de deuda exigible provisional, RD-F04-006). El `idCliente` se lee sin lock y se **reverifica** bajo lock. |
| 5 | `PEDIDO … FOR UPDATE` | Serializa estados del Pedido. |
| 6 | `ASIGNACION_REPARTO` vigente `… FOR UPDATE` | Mismo tramo final que `UC-43`. |
| 7 | `CLIENTE … FOR UPDATE` | Orden «cliente → histórico de cuenta» de `CobroManualService` (L58) y requisito de `UC-15`. |
| 8 | Stock `REVENTA`: `(808,0)` y `advisory(idProducto)` en **orden ascendente de id** | Patrón de `RegistrarIngresoStockReventaService` L38–39 y orden de `CargarPedidoService` (ids ordenados). Su posición exacta en la cadena queda **PENDIENTE** del DS. |

**Riesgos de deadlock identificados:**

- Un servicio que tome `2929001` después de un lock de cliente por fila invertiría el orden del paso 2–7. Hoy ninguno lo hace.
- El generador `MAX+1` de `EXCEDENTE` necesita un lock común con los futuros `UC-06`/`UC-07`/`UC-41`; **PENDIENTE** (riesgo residual).
- La cadena larga con locks globales (`9172001`, `2929001`) serializa todas las entregas. Es aceptable a la escala del proyecto, pero debe medirse.
- El DS debe incluir una prueba de concurrencia `UC-05` vs `UC-43`, `UC-05` vs `UC-29` y `UC-05` vs `UC-05`.

### 8.4 Secuencia de escritura y atomicidad (PROPUESTO)

Todo en **una única transacción** (`@Transactional` sin `REQUIRES_NEW`). Cualquier fallo → rollback total (R4: ni dos entregas, ni dos declaraciones, ni dos cargos, ni dos movimientos de inventario).

1. Validar sesión, rol, `claveIdempotencia`, importes (≥0, escala ≤2, precisión ≤18).
2. Tomar locks (8.3). Buscar `ENTREGA` por clave → replay (2) o conflicto (3).
3. Verificar Pedido `PENDIENTE` y asignación vigente del Repartidor autenticado (A1).
4. Validar cantidades, límites y costos (A2–A4).
5. `INSERT ENTREGA` (con `idOperacionOrigen`).
6. `INSERT DETALLE_ENTREGA`.
7. `IMPUTACION_ENTREGA_ADICIONAL` (dependiente de `UC-07`; ver sección 14).
8. Egreso de `REVENTA`: `MOVIMIENTO_STOCK_REVENTA` y stock.
9. `EXCEDENTE` por sobrantes `ELABORADO`.
10. `MOVIMIENTO_CUENTA` `CARGO_POR_VENTA` y `ORIGEN_MOVIMIENTO_CUENTA` (`idPedidoEntrega`).
11. **`INSERT PAGO_EN_TRANSITO`** si `efectivoDeclaradoRecibido > 0` (sin `COBRO`, sin `MOVIMIENTO_CAJA`).
12. `UC-15` (`EvaluadorCategoriaComercialInterno`).
13. `PEDIDO.estado = ENTREGADO` y cierre de `ASIGNACION_REPARTO`.

Restricciones SQL que respaldan el resultado: `pk_entrega`, `UNIQUE` propuesto de `ENTREGA.idOperacionOrigen`, `uq_origen_movimiento_cuenta_0`, `uq_movimiento_stock_reventa_2`, PK/FK de `PAGO_EN_TRANSITO`, triggers de inmutabilidad. La FK de `ORIGEN_MOVIMIENTO_CUENTA → ENTREGA` (L993) impone crear `ENTREGA` antes del cargo.

## 9. Efectos financieros provisionales

### 9.1 Magnitudes (PROPUESTO como cálculo; la fórmula está APROBADA conceptualmente)

- `saldoConfirmado`: saldo contable de `MOVIMIENTO_CUENTA` (sin cambios por la declaración). **APROBADO** (RD-F04-003 §2).
- `pagosEnTransitoValidados(cliente)` = Σ `importeDeclarado` de sus Pedidos − Σ `importeAplicado` (PE-2). **PROPUESTO.**
- `saldoExigibleProvisional` = `saldoConfirmado − pagosEnTransitoValidados`, **solo proyección de consulta** (RD-F04-003 §2; CONTRATOS_REV05 L37).

La convención de signo de `MOVIMIENTO_CUENTA` es: `CARGO_POR_VENTA` suma y `PAGO` resta (`CobroManualService` L96; verificado). En `UC-05` el `CARGO_POR_VENTA` sube el saldo y la declaración baja solo el exigible.

### 9.2 Cómo se evita descontar dos veces (R5)

1. **Consulta de una sola sentencia:** `saldoConfirmado` y `pagosEnTransitoValidados` se leen en el mismo `SELECT` (un único snapshot), como hace `BuscarPedidoService` (L58–102). Con dos lecturas separadas en `READ COMMITTED` podría verse el saldo ya rebajado y el tránsito aún completo.
2. **Cese atómico:** la operación de rendición inserta `COBRO`, `MOVIMIENTO_CUENTA` (`PAGO`), `MOVIMIENTO_CAJA` y `APLICACION_PAGO_EN_TRANSITO` en **la misma transacción**. Al confirmarse, el saldo confirmado baja y el tránsito pendiente baja a la vez.
3. **Control de sobreaplicación:** `FOR UPDATE` sobre `PAGO_EN_TRANSITO` más la restricción Σ aplicado ≤ declarado, para rendiciones concurrentes.
4. **La declaración nunca se borra ni modifica:** su trazabilidad se conserva.

### 9.3 Interacciones

| Operación | Interacción | Estado |
|---|---|---|
| `UC-14` | Muestra las tres magnitudes (CONTRATOS_REV05 L37). RBAC: **solo Vendedor**; Administrador `X`. | **PENDIENTE (D6):** el Administrador recibe la rendición pero `UC-14` no se lo muestra. Debe resolverse qué vista usa el Administrador sin inferir permisos. |
| `UC-15` | Usa deuda **confirmada** (`EvaluadorCategoriaComercialInterno` L14). | **PROPUESTO:** sin cambios en `UC-15` por el tránsito, coherente con RD-F04-006/007 (sin recategorización automática). Que el tránsito influya en `UC-15` es una pregunta abierta de RD-F04-004 (**PENDIENTE D8**). |
| `UC-29` | Rendición definitiva por el Administrador (L61). La firma canónica `registrarCobro(idCliente, idPedido, importe, medioPago, origen, referenciaExterna)` no tiene parámetro para enlazar la declaración, y el RBAC permite también al Vendedor. | **PENDIENTE (D6):** qué operación ejecuta la rendición, cómo restringirla al Administrador y cómo enlazarla; no se modifica el contrato aquí. |
| `UC-43` | La asignación vigente es precondición de `UC-05` y se cierra al final; reprogramar invalida la asignación (RD-RP020-001). | Cubierto por locks 1 y 6. |
| `UC-03` | RD-F04-006 exige evaluar deuda de nuevos Pedidos con saldo exigible provisional. `CargarPedidoService` **no consulta saldo ni deuda** (verificado, sin referencias a saldo). | **Dependencia fuera de I3-02;** no se amplía el alcance. |
| `anularCobroManual` | Un cobro aplicado a una declaración puede anularse (contraasiento). Efecto en el tránsito: no definido. | **PENDIENTE (D7).** |

### 9.4 Reglas que NO se inventan

Quedan **PENDIENTES** y no se resuelven: tope del importe declarado, saldo exigible negativo, importes superiores a la deuda, pagos parciales, tratamiento definitivo del saldo al cerrar una conciliación con diferencia (RD-F04-005 lo deja sin decidir), prueba de recepción física. Para `UC-05` en I3-02 se propone implementar **solo** las validaciones ya contratadas: `efectivoDeclaradoRecibido < 0` se rechaza (A2), y escala/precisión compatibles con `NUMERIC(18,2)`.

## 10. Seguridad y auditoría

| Aspecto | Propuesta |
|---|---|
| Rol que declara | Solo `REPARTIDOR` en `UC-05` (matriz L7). La identidad del Repartidor se toma **de la sesión**, nunca del cuerpo de la solicitud. |
| Roles que validan/concilian | Administrador (RD-F04-002). Vendedor no recibe rendiciones (RD-RP007-001). |
| Roles que consultan | `UC-14` solo Vendedor (matriz L17). **No hay proyección BC-07 ratificada** para el registro de pago en tránsito: no se expone a ningún rol por inferencia (**PENDIENTE D9**). |
| Asignación | Validación en servidor de asignación vigente y usuario habilitado, bajo locks 1 y 6. |
| Inmutabilidad | `PAGO_EN_TRANSITO` y la aplicación son inmutables por trigger; las correcciones serían contraasientos futuros. |
| Auditoría | Quién (`ENTREGA.idUsuarioRepartidor`), cuándo (`fechaHoraRegistroServidor`), qué (importe), sobre qué (Pedido/Entrega) y bajo qué identidad de operación (`idOperacionOrigen`). No se guarda el id de sesión (puede revocarse). |
| Fuente primaria | Siempre filas relacionales. Los logs **no** son almacenamiento primario ni deben incluir importes ni claves. |
| Errores | Mensajes genéricos; sin datos de otro Pedido, Cliente o clave ajena. |
| Canal | `UC-05` es acción humana con canal offline F04 (mapa técnico L7). No se invoca desde automatismos (BC09). |

## 11. Impacto sobre MR-6 y F04

- **Esquema (PROPUESTO):** una tabla nueva (`PAGO_EN_TRANSITO`) y una columna nueva (`ENTREGA.idOperacionOrigen`) en PE-1; requeriría una migración **V4 futura** que no se crea aquí. V1/V2/V3 permanecen intactos.
- **MR-5 «no hay tabla de tránsito»:** el contrato `UC-05` (L71) y `UC-14` (L25) lo declaran como pendiente. Tras ratificar y probar, deberían actualizarse por la vía formal (RD/CR); **no se editan aquí**.
- **ADR-B1-05:** permanece **PENDIENTE** para el diseño físico de sincronización. PE-1 no la resuelve; solo cubre persistencia online.
- **Tratamiento de CR-B0-F04-001 (propuesta):** opción **C** del encargo. Dividir:
  1. **PE-1** se tramita con esta RD como *resolución parcial* de la CR (persistencia online mínima + idempotencia de `UC-05`). Si el responsable la ratifica, la CR se anota por un documento aparte (no se edita aquí).
  2. **PE-2** requiere una decisión complementaria específica (rendición).
  3. **PE-3** permanece íntegramente en la CR.
  Así no se duplican decisiones de gobierno: la CR conserva el inbox, la RD-I302 cubre solo lo necesario para I3-02.
- **Ninguna prueba MR-6 se amplía** ni se afirma validación de PostgreSQL para este diseño.

## 12. Riesgos residuales

| # | Riesgo | Mitigación propuesta |
|---|---|---|
| RR1 | `ENTREGA.idOperacionOrigen` nullable no impide filas sin clave | Exigencia en servicio y prueba; evaluar `NOT NULL` en una migración posterior si no hay filas heredadas. |
| RR2 | Generadores `MAX+1` sin lock común (`EXCEDENTE`, `MOVIMIENTO_STOCK_REVENTA`) | Fijar locks compartidos en el DS; prueba de concurrencia. |
| RR3 | Cadena de locks globales serializa entregas | Medir; aceptable a escala actual. |
| RR4 | Declaración falsa o disputada | Sin prueba objetiva de recepción (pendiente RD-F04-004). La declaración es evidencia operativa, no cobro. |
| RR5 | Importe declarado superior a la deuda | **Sin regla aprobada.** No se fija tope por defecto. |
| RR6 | Rechazos offline no persistidos hasta PE-3 | UC-05 offline no debe habilitarse antes de PE-3 (B7). |
| RR7 | La comparación de contenido depende de qué filas persiste `DETALLE_ENTREGA` (¿líneas con cantidad 0?) | El DS debe fijar la forma canónica de comparación. |
| RR8 | Operación de rendición sin definir (no está entre las 67) | Decisión D6; no inventar CU. |
| RR9 | `UC-14` excluye al Administrador | Decisión D6. |
| RR10 | Anular cobro aplicado a un tránsito | Decisión D7. |
| RR11 | Dependencia de `UC-07` (imputación adicional) con gaps sin resolver | Sección 14. |

## 13. Pruebas de aceptación propuestas (NO EJECUTADAS)

Deben implementarse con PostgreSQL real. **Ninguna está ejecutada.**

| ID | Escenario | Resultado esperado |
|---|---|---|
| T-01 | Entrega válida con efectivo | Una `ENTREGA`, un `PAGO_EN_TRANSITO`, un `CARGO_POR_VENTA`; cero `COBRO` y cero `MOVIMIENTO_CAJA`; saldo confirmado = anterior + cargo. |
| T-02 | Entrega sin efectivo o con 0 | Sin fila en `PAGO_EN_TRANSITO`; la clave queda registrada. |
| T-03 | Replay (misma clave y contenido) N veces y desde dos sesiones | Un efecto; respuesta repetida idéntica. |
| T-04 | Misma clave, importe o cantidades distintos | 409; ninguna fila nueva ni modificada. |
| T-05 | Clave nueva para Pedido entregado | 409 sin replay. |
| T-06 | Fallo simulado entre pasos 5 y 11 | Rollback total (cero filas, stock y saldo intactos). |
| T-07 | Respuesta perdida tras commit | Reintento devuelve el resultado reconstruido. |
| T-08 | Dos solicitudes concurrentes: misma clave; mismo Pedido distinta clave; mismo clave distinto Pedido | Un solo efecto; sin deadlock ni error 500. |
| T-09 | `UC-05` vs `UC-43` concurrentes | Solo un resultado coherente; no se entrega con asignación cerrada. |
| T-10 | `UC-05` vs `UC-29` concurrentes sobre el mismo Cliente | Sin ids duplicados (`2929001`); saldos consistentes. |
| T-11 | Asignación invalidada o Repartidor deshabilitado | 409/403; cero filas; clave no consumida. |
| T-12 | Rol no autorizado (Administrador, Vendedor, Producción) | 403; cero filas. |
| T-13 | Intento de `UPDATE`/`DELETE` de `PAGO_EN_TRANSITO` | Rechazado por trigger. |
| T-14 | `UC-14` (cuando exista la vista) con tránsito pendiente | `saldoConfirmado` sin cambios; exigible = confirmado − tránsito, en una sola sentencia. |
| T-15 | Rendición total, parcial y concurrente (PE-2) | Efecto provisional cesa en la misma transacción; Σ aplicado ≤ declarado; sin doble descuento. |
| T-16 | Importe negativo, escala > 2, precisión > 18 | 400; cero filas. |
| T-17 | Logs y errores | Sin importes ni claves de terceros. |

## 14. Decisiones pendientes del responsable

### 14.1 Sobre esta propuesta

| ID | Decisión | Recomendación (PROPUESTO) |
|---|---|---|
| D1 | ¿Aprobar PE-1 (`PAGO_EN_TRANSITO` + `ENTREGA.idOperacionOrigen`) como diseño físico objetivo de `UC-05`? | Aprobar; alternativa de respaldo en sección 6. |
| D2 | Tope y política del importe declarado (superior al cargo, superior a la deuda, parciales). | Sin tope hasta decidirlo; no inventar defaults. |
| D3 | ¿Una solicitud rechazada antes de escribir consume la clave? | No consume; confirma sección 8.2. |
| D4 | Evidencia de recepción del efectivo (comprobante, firma, confirmación). | Pendiente de RD-F04-004; fuera de PE-1. |
| D5 | Saldo exigible negativo / importes superiores a la deuda: truncar o mostrar crédito provisional. | RD-F04-003 exige decisión explícita; no truncar en silencio. |
| D6 | Operación de rendición: ¿qué operación (no hay entre las 67), cómo restringirla al Administrador (`UC-29` también permite Vendedor), cómo enlazar la declaración (la firma de `UC-29` no lo prevé) y cómo ve el Administrador los tránsitos pendientes (`UC-14` lo excluye)? | Requiere RD propia; no inventar CU ni permisos. |
| D7 | Efecto sobre el tránsito al anular un cobro aplicado (`anularCobroManual`). | Pendiente. |
| D8 | ¿El pago en tránsito influye en `UC-15`? | Pendiente; mientras tanto `UC-15` sigue con deuda confirmada. |
| D9 | Proyección BC-07 de los campos de `PAGO_EN_TRANSITO` por rol. | Pendiente; no exponer por inferencia. |
| D10 | Cierre de una conciliación con diferencia: tratamiento definitivo del saldo (RD-F04-005). | Pendiente. |
| D11 | Retención y política de rechazos/conflictos offline (PE-3). | Dentro de la CR. |
| D12 | Tratamiento de la CR-B0-F04-001: A (resolverla completa), B (decisión complementaria) o C (dividir). | **C**, sección 11. |

### 14.2 Pendientes de I3-02 que NO se resuelven aquí

Se conservan para decidir antes de la RD definitiva:

- **Tarificación del excedente reasignado (`UC-07`, `importeInformado`):** el contrato dice «calculando el `importeInformado`» sin definir la fuente de precio (CONTRATOS_REV04B L203, L215). No se fija una política.
- **Representación de líneas adicionales de `UC-07`:** `IMPUTACION_ENTREGA_ADICIONAL` tiene FK a `DETALLE_ENTREGA(idPedido, numeroDetalle)` (V1 L922), que a su vez referencia `DETALLE_PEDIDO` (L914). No se decide aquí cómo representar unidades adicionales de un producto ausente del Pedido receptor ni si se restringe a líneas existentes.
- **Orden de implementación:** el paso 7 de `UC-05` depende de `UC-07`; el orden de sub-cortes de I3-02 no se modifica aquí.

## 15. Condiciones previas para implementar `UC-05`

Todas **PENDIENTES**; ninguna está cumplida.

1. Ratificación expresa por el responsable de esta RD (o de una versión modificada), con D1, D2, D3 y D12 resueltas.
2. Decisión sobre D6, o confirmación de que la rendición queda fuera de I3-02 y no se habilita el tránsito hacia la rendición hasta su RD.
3. Anotación formal de la CR-B0-F04-001 (resolución parcial) en el repositorio de gobierno.
4. Migración V4 con tests en PostgreSQL real (no creada, no probada).
5. Documento DS/contrato operacional de `UC-05` en `ale-milanesas-app` con orden de locks verificado y pruebas T-01 a T-17.
6. Resolución o delimitación de los pendientes de `UC-07` (sección 14.2), dado que el paso 7 depende de ellos.
7. Reafirmar que el despliegue permanece **PAUSADO** (Issue #28 abierta) y que `UC-05` offline no se habilita antes de PE-3 (B7).

---

**Estado de verificación de este documento:** análisis estático contra las fuentes de la sección 2. **No hay código ejecutado, ni DDL, ni pruebas.** Estado de `UC-05` en implementación: **NO IMPLEMENTADO.** BC06 de implementación para `UC-05`: **NO EJECUTADO.**
