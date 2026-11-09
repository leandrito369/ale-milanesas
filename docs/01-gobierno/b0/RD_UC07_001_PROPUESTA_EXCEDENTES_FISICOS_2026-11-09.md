# RD-UC07-001 (PROPUESTA) — Decisiones de arquitectura y diseño para reasignación de excedentes físicos (UC-07)

**Fecha de redacción:** 09/11/2026
**Estado:** **PROPUESTA — NO RATIFICADA.** Este documento consolida las decisiones funcionales y de arquitectura **D1-B, D2-A, D3-B (orientación CR-B), D4-A y D5-B aprobadas expresamente por el responsable del proyecto el 09/11/2026**, cuya **ratificación documental definitiva permanece pendiente**. No declara implementado `UC-07`, no cierra el bloque `I3-02`, no autoriza cambios físicos en la base de datos ni habilita el despliegue.
**Autoridad que decide:** Victor Leandro Machado (responsable del proyecto).
**Numeración:** `RD-UC07-001` (provisional). Verificado en `docs/01-gobierno/` y `docs/01-gobierno/b0/` al 09/11/2026: no existe ninguna RD previa para `UC-07`.
**Alcance:** Definiciones funcionales, reglas de tarificación comercial, compatibilidad relacional, aceptación expresa en dos pasos e invariantes de concurrencia para el caso de uso `UC-07 — Ofrecer y Reasignar Excedente` (operaciones `registrarOfertaExcedente` y `registrarRespuestaOfertaExcedente`), articulado con `UC-61` (Buscar Excedente), `UC-41` (Registrar Descarte de Excedente), `UC-06` (Cancelar Pedido) y `UC-05` (Registrar Entrega).
**Trazabilidad cruzada con `RD-I302-001` (PR #44):** Conforme a la decisión **D4-A**, este documento aborda exclusivamente **excedentes físicos de productos elaborados** (`UC-07`). El documento independiente `RD-I302-001` (en tramitación en el PR #44) aborda `UC-05`, la entrega, la persistencia del efectivo en tránsito y la idempotencia. No se duplican reglas financieras ni se incorpora el efectivo en tránsito al dominio de excedentes físicos.

---

## Leyenda de estados empleada en este documento

| Etiqueta | Significado |
|---|---|
| **APROBADO (Línea base)** | Decisión ya ratificada en el cierre G0 o en actas/RDs previas del repositorio (se cita la fuente formal). |
| **APROBADO POR RESPONSABLE (09/11/2026)** | Decisión funcional/arquitectónica aprobada expresamente por Victor Leandro Machado para `RD-UC07-001`, sujeta a ratificación documental definitiva mediante el procedimiento del repositorio. |
| **PROPUESTO** | Diseño arquitectónico o hipótesis técnica (como la secuencia candidata de locks); no ratificado ni validado empíricamente. |
| **PENDIENTE** | Reserva técnica, brecha de persistencia o definición que permanece abierta; no se asume resuelta por inferencia. |
| **IMPLEMENTADO** | Estructura existente en código Java o DDL SQL en `ale-milanesas-app` (se cita archivo y línea). **`UC-07` está 0% implementado en código.** |
| **PROBADO** | Prueba automatizada ejecutada con evidencia verificable. **Ningún servicio ni prueba de concurrencia de `UC-07` está PROBADO.** |

---

## 1. Contexto y problema técnico

El caso de uso `UC-07 — Ofrecer y Reasignar Excedente` forma parte del bloque **I3-02 (Entrega y Excedentes)** según el Plan Rector. Fue formalizado en la consolidación B0 bajo dos contratos canónicos individuales en `CONTRATOS_REV04B_CORREGIDOS_B0_ACTUALIZADO.md`:
1. `registrarOfertaExcedente` (§5, L199–231).
2. `registrarRespuestaOfertaExcedente` (§6, L233–277).

El modelo relacional MR-5 (`V1__baseline_mr5.sql`) ya cuenta con las tablas `EXCEDENTE`, `OFERTA_EXCEDENTE`, `MOVIMIENTO_EXCEDENTE` e `IMPUTACION_ENTREGA_ADICIONAL`. Tras la auditoría previa y la revisión de alternativas por el responsable del proyecto el 09/11/2026, se consolidan en este documento las decisiones **D1-B, D2-A, D3-B, D4-A y D5-B** para resolver cinco aspectos críticos antes de iniciar la construcción en B3:

1. **Compatibilidad relacional del Pedido receptor (`D1-B`):** La tabla `IMPUTACION_ENTREGA_ADICIONAL` exige FK hacia `DETALLE_ENTREGA(idPedido, numeroDetalle)`, que a su vez referencia a `DETALLE_PEDIDO(idPedido, numeroDetalle)`. Se consolida el uso de una línea técnica con `cantidadOriginal = 0` cuando el producto no integraba originalmente el pedido receptor, dejando registrada la reserva técnica sobre productos desactivados frente al trigger `tg_mr3_validar_producto_detalle_nuevo`.
2. **Tarificación comercial e integridad histórica (`D2-A`):** Cálculo del `importeInformado` a partir del `precioBase` vigente en `PRECIO_PRODUCTO` al momento de la oferta y del ajuste comercial congelado en el pedido receptor, identificando con transparencia el alcance y los límites de reconstrucción histórica en el esquema actual.
3. **Aceptación expresa en dos pasos (`D3-B`):** Adopción de un protocolo funcional en dos pasos (Cotización y conformidad + Confirmación con la firma canónica intacta de 3 parámetros) bajo la orientación funcional `CR-B`, manteniendo explícitamente pendiente el diseño técnico del mecanismo de obtención, vinculación y persistencia de la evidencia de conformidad.
4. **Separación documental y consistencia con la entrega (`D4-A`):** Independencia entre `RD-UC07-001` y `RD-I302-001`, distinción de los cinco niveles de importes/cargos, y articulación estricta con `UC-05` y `UC-06` sin introducir operaciones inexistentes de cancelación o reversión de entregas.
5. **Invariantes de concurrencia y reserva sobre el orden de locks (`D5-B`):** Ratificación de las invariantes obligatorias de atomicidad y aislamiento entre `UC-07`, `UC-41` y `UC-05`, conservando el orden concreto de adquisición de locks como hipótesis técnica pendiente de diseño detallado y validación con PostgreSQL/Testcontainers en CI.

---

## 2. Fuentes canónicas y SHAs verificados

SHAs efectivos verificados el 09/11/2026 antes de consolidar esta revisión:
* **Gobierno (`leandrito369/ale-milanesas`):** `origin/main` en [`d848f73`](https://github.com/leandrito369/ale-milanesas/commit/d848f73); HEAD previo de la rama `docs/rd-uc07-001-propuesta-2026-11-09` (PR #45) en [`acf236e`](https://github.com/leandrito369/ale-milanesas/commit/acf236e).
* **Implementación (`leandrito369/ale-milanesas-app`):** `origin/main` en [`d5f7607`](https://github.com/leandrito369/ale-milanesas-app/commit/d5f7607).
* **Propuesta hermana de I3-02 (PR #44, solo lectura):** rama `origin/docs/rd-i302-001-propuesta-2026-11-09` en [`e5e82f8`](https://github.com/leandrito369/ale-milanesas/commit/e5e82f8) (`RD-I302-001`, sección 14.2 sobre pendientes de `UC-07`).

### Fuentes consultadas:
* [Plan Rector de Implementación](../PLAN_RECTOR_IMPLEMENTACION_2026-10-29.md), [Backlog priorizado G0](B0_BACKLOG_PRIORIZADO_Y_GATE_G0_2026-10-29.md) y [Estado Actual](../../ESTADO_ACTUAL.md).
* [Contratos canónicos REV-04B](../../08-diagramas/consolidacion-b0/CONTRATOS_REV04B_CORREGIDOS_B0_ACTUALIZADO.md): §1 `UC-28`, §2 `UC-05`, §3 `UC-06`, §4 `UC-61`, §5 `UC-07 Parte A`, §6 `UC-07 Parte B`, §7 `UC-41`, §8 Glosario.
* [Manifiesto canónico de 67 operaciones](G0_MANIFIESTO_CANONICO_67_OPERACIONES_2026-10-29.csv) y [Matriz RBAC de cierre](B0_MATRIZ_RBAC_67_OPERACIONES_CIERRE_2026-10-29.csv) L9–10 (`UC-07` exclusivo `VENDEDOR=D`).
* [RD-007](../RD_01_REGISTRO_DECISIONES_v1.1_2026-10-25.md#L25) y [RD-012](../RD_01_REGISTRO_DECISIONES_v1.1_2026-10-25.md#L30) (congelamiento de condiciones e inmutabilidad de pedidos confirmados salvo el incremento comercial de `UC-07`).
* Decisiones [A2](../RD_01_REGISTRO_DECISIONES_v1.1_2026-10-25.md#L48), [A23](../RD_01_REGISTRO_DECISIONES_v1.1_2026-10-25.md#L90), [A24](../RD_01_REGISTRO_DECISIONES_v1.1_2026-10-25.md#L92) y requerimiento [RF-13](../../03-requisitos/historico-2026-10-23/A_REQUISITOS.md#L2030).
* [RD-RP022-001](../RD_RP022_001_COSTEO_CONVERSIONES_REDONDEOS_2026-10-27.md) (costeo histórico, precisión decimal: 2 decimales para importes monetarios finales y 4 decimales para costos internos).
* Migraciones Flyway en `ale-milanesas-app`: `V1__baseline_mr5.sql` (tablas `PEDIDO` L138, `DETALLE_PEDIDO` L174, `ENTREGA` L205, `DETALLE_ENTREGA` L212, `EXCEDENTE` L222, `OFERTA_EXCEDENTE` L243, `MOVIMIENTO_EXCEDENTE` L263, `IMPUTACION_ENTREGA_ADICIONAL` L280, `PRECIO_PRODUCTO` L292; FKs L904–923; Triggers `tg_mr3_validar_producto_detalle_nuevo` L1274–1283 y `tg_mr5_validar_detalle_cambio_producto` L1687; Constraints `ck_detalle_pedido_3` L189, `ck_oferta_excedente_3` L260, `ck_movimiento_excedente_0` L274), `V2__f01_cobro_estados.sql` y `V3__trazabilidad_partidas_insumo.sql`.
* Código implementado en `ale-milanesas-app`: `AplicarAjusteComercialService.java` (L68–85), `CargarPedidoService.java` (L55–141), `BuscarPedidoService.java` (L69–75), `RegistrarPreparacionService.java` (L98–110), `ActualizarPrecioVigenteService.java` (L64–155) y `GestionProductoService.java` (L18, L148).

---

## 3. Alcance y decisiones funcionales de línea base (APROBADO)

Las siguientes reglas pertenecen a la línea base G0 y a las RDs previamente ratificadas, constituyendo invariantes obligatorias:

1. **Desagrupamiento de UC-07 en dos contratos canónicos (APROBADO — Línea base G0):**
   * Operación 1: `registrarOfertaExcedente(idExcedente: Long, idPedidoReceptor: Long, cantidadOfrecida: BigDecimal)`.
   * Operación 2: `registrarRespuestaOfertaExcedente(idOfertaExcedente: Long, aceptada: Boolean, cantidadAceptada: BigDecimal[0..1])`.
2. **RBAC estricto (APROBADO — Línea base G0):** Ambas operaciones de `UC-07` son exclusivas para el rol `VENDEDOR = D`. El rol `ADMINISTRADOR` tiene `NR` (no hereda permisos automáticos). `UC-61` (`buscarExcedente`) está habilitado para `VENDEDOR` y `RESPONSABLE_PRODUCCION`; `UC-41` (`registrarDescarteExcedente`) es exclusivo de `RESPONSABLE_PRODUCCION`.
3. **No reserva de existencias en la oferta (APROBADO — REV-04B §5.5 L209):** El registro de una `OfertaExcedente` (`respuesta = PENDIENTE`) no bloquea existencias ni reduce `EXCEDENTE.cantidadDisponible`.
4. **No re-elaboración ni nuevo consumo de insumos (APROBADO — REV-04B §1.5 L25, §6.2 L237):** La incorporación de excedentes a un pedido receptor **no ejecuta `UC-28`, no genera registros en `PREPARACION`, no descuenta insumos ni altera `cantidadPreparadaPropiaAcumulada`**.
5. **Inmutabilidad de condiciones originales del pedido receptor (APROBADO — RD-007, RD-012, REV-04B §6.9 L267):** La reasignación no modifica `DETALLE_PEDIDO.cantidadOriginal` de las líneas originales, no altera `PEDIDO.totalOriginal`, no altera la promoción aplicada originalmente ni reevalúa la categoría o el ajuste comercial global (`UC-15`/`UC-16`).
6. **Total vigente derivado (APROBADO — AGENTS.md, REV-04B §6.9 L267):** `PEDIDO.totalVigente` es un valor derivado en memoria/consultas a partir de `totalOriginal` más las ofertas aceptadas; no es una columna física aprobada.
7. **Trazabilidad estricta de costo histórico (APROBADO — RD-RP022-001, REV-04B §6.9 L269):** La reasignación transfiere la porción proporcional de `EXCEDENTE.costoHistoricoDisponible` a `MOVIMIENTO_EXCEDENTE.costoHistoricoSalida` (`NUMERIC(18,4)`). Prohibido asignar costo cero.
8. **Separación conceptual respecto de pagos en tránsito (APROBADO — RD-F04-003/004):** Un excedente físico de producto elaborado (`UC-07`) es completamente independiente del efectivo en tránsito o de las diferencias monetarias declaradas durante `UC-05`.

---

## 4. Consolidación de las decisiones D1–D5 aprobadas por el responsable

### 4.1. D1-B — Compatibilidad del Pedido Receptor

* **Estado de la decisión:** **APROBADA POR EL RESPONSABLE (09/11/2026)**, pendiente de ratificación documental definitiva y sujeta a la **Reserva Técnica `RT-UC07-01`**.
* **Alternativas descartadas como antecedente:**
  * *D1-A (restringir ofertas solo a productos ya incluidos en el pedido receptor):* descartada por el responsable en favor de la flexibilidad comercial de `D1-B`.
  * *D1-C (alterar FKs de `IMPUTACION_ENTREGA_ADICIONAL` mediante nueva migración DDL):* descartada por violar el congelamiento del modelo relacional MR-5/MR-6.

#### Definición funcional y técnica consolidada (D1-B):
Se permite ofrecer y reasignar excedentes físicos de productos elaborados que no integraban originalmente el pedido receptor. Cuando el producto ofrecido no posea aún una fila en `DETALLE_PEDIDO` para el `idPedidoReceptor`, al aceptarse la oferta se utilizará una **línea técnica en `DETALLE_PEDIDO`** con los siguientes valores exactos:
* `idPedido = :idPedidoReceptor`
* `numeroDetalle = COALESCE(MAX(numeroDetalle), 0) + 1` (calculado bajo bloqueo del pedido receptor)
* `idProducto = :idProductoExcedente`
* `codigoUnidadVenta = :codigoUnidadVentaProducto` (tomado del producto/detalle de origen)
* `cantidadOriginal = 0.000`
* `precioUnitarioOriginal = NULL`
* `porcentajePromocionOriginal = 0.00`
* `idPromocionAplicada = NULL`

#### Condiciones obligatorias de cumplimiento:
1. **Inmutabilidad de `PEDIDO.totalOriginal`:** La creación o uso de la línea técnica no modifica bajo ningún concepto `PEDIDO.totalOriginal`.
2. **Inmutabilidad de líneas preexistentes:** Si el producto ya existía en el pedido receptor (con `cantidadOriginal > 0`), no se modifica su `cantidadOriginal`, su `precioUnitarioOriginal`, su `porcentajePromocionOriginal` ni su `idPromocionAplicada`; simplemente se reutiliza su `numeroDetalle` para vincular la futura entrega adicional.
3. **Reutilización obligatoria de línea técnica existente:** Si el pedido receptor ya cuenta con una línea técnica (`cantidadOriginal = 0`) para ese mismo `idProducto` (originada por una oferta aceptada previamente), **se debe reutilizar dicho `numeroDetalle`** sin insertar una segunda fila. La tabla `IMPUTACION_ENTREGA_ADICIONAL` tiene PK `("idPedido", "numeroDetalle", "idMovimientoExcedente")` y `UNIQUE ("idMovimientoExcedente")`, admitiendo múltiples movimientos de excedente asociados al mismo `(idPedido, numeroDetalle)`.
4. **Respeto a `uq_detalle_pedido_0` y restricciones referenciales:** La reutilización del detalle por `(idPedido, idProducto)` preserva la restricción `uq_detalle_pedido_0 UNIQUE ("idPedido", "idProducto")` y satisface `ck_detalle_pedido_3` (`V1 L189`), que admite expresamente `("cantidadOriginal"=0 AND "precioUnitarioOriginal" IS NULL AND "porcentajePromocionOriginal"=0 AND "idPromocionAplicada" IS NULL)`.
5. **Momento transaccional de creación:** La línea técnica se crea **única y exclusivamente cuando se acepta la oferta** (`registrarRespuestaOfertaExcedente` con `aceptada == true`), dentro de la misma transacción atómica. **Nunca** se crea al registrar la oferta (`registrarOfertaExcedente`) ni cuando la oferta es rechazada.
6. **Exclusión de preparación propia (`UC-28`):** Las unidades procedentes de excedentes reasignados no se envían a preparación propia. En el código implementado, `RegistrarPreparacionService.java` (L98–110) rechaza cualquier intento de preparar sobre una línea con `cantidadOriginal = 0` (`CANTIDAD_EXCEDE_ORIGINAL`), y `BuscarPedidoService.java` (L69–75) filtra `d."cantidadOriginal" > COALESCE(...)`, excluyendo automáticamente las líneas técnicas de los pedidos preparables.
7. **Preservación de consultas existentes sobre `DETALLE_PEDIDO`:** Se detectó en `CargarPedidoService.java` (L69) que la consulta de replay idempotente de `UC-03` calcula `SELECT count(*) FROM "DETALLE_PEDIDO" d WHERE d."idPedido"=p."idPedido" AS items`. Durante la implementación de B3, toda consulta que cuente ítems originales o lea `precioUnitarioOriginal` deberá contemplar la existencia de líneas técnicas (`WHERE d."cantidadOriginal" > 0` para conteo de ítems originales y manejo nulo-seguro de `precioUnitarioOriginal`).
8. **Preservación del costo histórico y compatibilidad con `RD-012`:** El costo histórico del excedente se transfiere mediante `MOVIMIENTO_EXCEDENTE.costoHistoricoSalida` sin usar la columna `precioUnitarioOriginal` de la línea técnica. La inserción de la línea técnica con `cantidadOriginal = 0` instrumenta exclusivamente el *"incremento comercial de UC-07"* expresamente exceptuado en `RD-012` (`RD_01 L30`), sin habilitar modificaciones generales del pedido confirmado. Asimismo, conforme a la decisión `A24`, el `Cliente` del pedido receptor debe mantenerse en estado `ACTIVO`.

#### Reserva técnica obligatoria (`RT-UC07-01`) — Producto físicamente en excedente pero desactivado en catálogo:

> [!WARNING]
> **Conflicto detectado con `tg_mr3_validar_producto_detalle_nuevo` (PENDIENTE DE DECISIÓN):**
> En `V1__baseline_mr5.sql` (L1274–1283), el trigger `tg_mr3_validar_producto_detalle_nuevo` (`BEFORE INSERT ON "DETALLE_PEDIDO"`) ejecuta:
> ```sql
> IF NOT EXISTS (SELECT 1 FROM "PRODUCTO" p WHERE p."idProducto"=NEW."idProducto" AND p."activo") THEN
>   RAISE EXCEPTION 'Producto no habilitado para pedido nuevo';
> END IF;
> ```
> **Análisis del caso:** Un `EXCEDENTE` físico puede haberse generado legítimamente cuando el producto estaba activo (`activo = TRUE`), y con posterioridad el Administrador puede haber desactivado el producto en el catálogo mediante `UC-48` (`PRODUCTO.activo = FALSE`, baja lógica según `A24`).
> * Si el pedido receptor **ya incluía** ese producto desde antes de su desactivación, `UC-07` reutiliza el `numeroDetalle` existente sin ejecutar `INSERT INTO "DETALLE_PEDIDO"`, por lo que el trigger no se dispara.
> * En cambio, si el pedido receptor **no incluía** ese producto y se intenta insertar la línea técnica con `cantidadOriginal = 0` al aceptar la oferta, **el trigger `tg_mr3_validar_producto_detalle_nuevo` bloqueará la inserción** con la excepción `'Producto no habilitado para pedido nuevo'`.
>
> **Regla de gobierno:** No se modifica automáticamente el comportamiento del trigger de productos activos. Este conflicto queda registrado y **pendiente de decisión expresa del responsable** entre dos opciones:
> 1. **Restricción funcional (sin cambio DDL):** Prohibir en `UC-07` ofrecer/reasignar excedentes de productos actualmente inactivos (`PRODUCTO.activo = FALSE`) hacia pedidos que no contengan ya dicho producto (o restringir cualquier oferta de producto inactivo, canalizando el sobrante a `UC-41 — Registrar Descarte de Excedente`).
> 2. **Cambio físico controlado (requiere CR y migración futura):** Autorizar una Solicitud de Cambio para que `fn_mr3_validar_producto_detalle_nuevo` solo exija `PRODUCTO.activo = TRUE` cuando `NEW."cantidadOriginal" > 0`, manteniendo el bloqueo para altas de pedidos nuevos.

---

### 4.2. D2-A — Tarificación Comercial e Integridad Histórica

* **Estado de la decisión:** **APROBADA POR EL RESPONSABLE (09/11/2026)**, pendiente de ratificación documental definitiva y con identificación explícita del **Gap de Reconstrucción Histórica `RT-UC07-02`**.

#### Definición funcional y matemática consolidada (D2-A):
El `importeInformado` al registrar la oferta (`registrarOfertaExcedente`) se calcula utilizando exclusivamente:
1. El **`precioBase` vigente de `PRECIO_PRODUCTO`** al momento de registrar la oferta (`vigenteDesde <= fechaHoraOferta AND (vigenteHasta IS NULL OR vigenteHasta > fechaHoraOferta) AND fechaHoraCancelacion IS NULL`, coherente con `CargarPedidoService.java` L98–100). Si no existe un precio base vigente e inequívoco, se rechaza la oferta por excepción contractual **A2**.
2. El **`tipoAjuste` comercial ya establecido y congelado** en la cabecera del pedido receptor (`PEDIDO.tipoAjuste`: `'SIN_AJUSTE'`, `'DESCUENTO'` o `'RECARGO'`).
3. El **`porcentajeAjuste` congelado** en la cabecera del pedido receptor (`PEDIDO.porcentajeAjuste`).
4. Los **criterios de precisión decimal y redondeo de las RD vigentes (`RD-RP022-001`):** aritmética `BigDecimal` exacta y redondeo comercial a **2 decimales con `RoundingMode.HALF_UP`** para los importes monetarios finales, alineado con `AplicarAjusteComercialService.java` (L68–85):

```java
BigDecimal subtotalBase = cantidad.multiply(precioBase).setScale(2, RoundingMode.HALF_UP);

BigDecimal importeCalculado = switch (pedidoReceptor.tipoAjuste()) {
    case "SIN_AJUSTE" -> subtotalBase;
    case "DESCUENTO" -> {
        BigDecimal ajuste = subtotalBase.multiply(pedidoReceptor.porcentajeAjuste())
            .divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
        yield subtotalBase.subtract(ajuste);
    }
    case "RECARGO" -> {
        BigDecimal ajuste = subtotalBase.multiply(pedidoReceptor.porcentajeAjuste())
            .divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
        yield subtotalBase.add(ajuste);
    }
};
```

#### Reglas de invariancia comercial:
* **No recalcular la categoría comercial del cliente:** Queda estrictamente prohibido invocar `UC-15` o `UC-16` durante `UC-07`. Se respetan las condiciones congeladas del pedido receptor (`RD-007`, `RD-F04-007`, `REV-04B §6.2 L237`).
* **No modificar silenciosamente el precio comunicado al cliente:** Una vez emitida la oferta con su `importeInformado`, un cambio posterior de precios en `PRECIO_PRODUCTO` (`UC-19`) no puede alterar silenciosamente el precio de la oferta ya comunicada al cliente. Si `cantidadAceptada == cantidadOfrecida`, `importeAceptado` es exactamente igual a `importeInformado`. Si `cantidadAceptada < cantidadOfrecida`, el recálculo se rige por la base de la oferta emitida y por el protocolo de aceptación expresa en dos pasos (`D3-B`).

#### Distinción conceptual y contable obligatoria de los cinco valores:

| Concepto | Ubicación / Tipo SQL | Escala (`RD-RP022-001` / MR-5) | Naturaleza y significado |
|---|---|---|---|
| `importeInformado` | `OFERTA_EXCEDENTE.importeInformado` | `NUMERIC(18,2)` (2 dec.) | Importe comercial cotizado e informado al cliente al registrar la oferta por `cantidadOfrecida`. No transfiere unidades ni devenga deuda. |
| `importeAceptado` | `OFERTA_EXCEDENTE.importeAceptado` | `NUMERIC(18,2)` (2 dec.) | Importe comercial expresamente aceptado por el cliente al responder afirmativamente la oferta por `cantidadAceptada`. |
| `costoHistoricoSalida` | `MOVIMIENTO_EXCEDENTE.costoHistoricoSalida` | `NUMERIC(18,4)` (4 dec.) | Costo de inventario transferido desde `EXCEDENTE.costoHistoricoDisponible` en proporción a `cantidadAceptada / cantidadDisponible` (si agota el saldo disponible, transfiere exactamente el `costoHistoricoDisponible` remanente sin dejar residuo). Es independiente del precio de venta. |
| `totalOriginal` | `PEDIDO.totalOriginal` | `NUMERIC(18,2)` (2 dec.) | Importe comercial congelado al confirmar el pedido en `UC-03` / `UC-21`. Es **inmutable** durante todo el ciclo de vida del pedido. |
| `totalVigente` | Derivado en memoria / consultas | Escala 2 (`BigDecimal`) | Compromiso comercial vigente del pedido: `PEDIDO.totalOriginal + SUM(OFERTA_EXCEDENTE.importeAceptado WHERE respuesta = 'ACEPTADA')`. No es columna física ni equivale al cargo contable de entrega. |

#### Verificación de trazabilidad histórica e identificación de gap (`RT-UC07-02`):
Se verificó la estructura física de `OFERTA_EXCEDENTE` (`V1__baseline_mr5.sql` L243–261) para comprobar si permite reconstruir íntegramente la cotización y su aceptación:
* **Datos persistidos actualmente:** `OFERTA_EXCEDENTE` conserva `idExcedente`, `idPedidoReceptor`, `idUsuarioVendedor`, `fechaHoraOferta`, `cantidadOfrecida`, `importeInformado`, `respuesta`, `fechaHoraRespuesta`, `cantidadAceptada` e `importeAceptado`. A su vez, `PEDIDO` conserva `tipoAjuste`, `porcentajeAjuste`, `categoriaComercialAplicada` e `idPoliticaComercialAplicada`.
* **Reconstrucción indirecta por vigencia temporal:** Dado que `ActualizarPrecioVigenteService.java` (L74) prohíbe precios retroactivos (`vigenteDesde < ahora`) y `ck_precio_producto_2` (`V1 L305`) prohíbe cancelar precios cuya vigencia ya comenzó (`fechaHoraCancelacion < vigenteDesde`), el `precioBase` vigente en `fechaHoraOferta` puede consultarse históricamente en `PRECIO_PRODUCTO` para el `idProducto` del excedente.
* **Gap de persistencia identificado (`RT-UC07-02` — sin proponer cambios físicos como aprobados):**
  1. `OFERTA_EXCEDENTE` **no posee una columna física `idPrecio` ni `precioBaseUnitarioAplicado`** que congele por referencia directa o valor atómico el precio base utilizado al crear la oferta (y en `DETALLE_PEDIDO`, cuando se usa una línea técnica bajo `D1-B`, `ck_detalle_pedido_3` exige `precioUnitarioOriginal IS NULL`). La reconstrucción depende por completo de la consulta por intervalo temporal `fechaHoraOferta` sobre `PRECIO_PRODUCTO`.
  2. Cuando `cantidadAceptada < cantidadOfrecida`, `OFERTA_EXCEDENTE` guarda el `importeInformado` original y el `importeAceptado` final al cerrarse la respuesta, pero no posee columnas adicionales para persistir un estado intermedio de "recotización comunicada pendiente de confirmación" (pues `ck_oferta_excedente_3` exige que mientras `respuesta = 'PENDIENTE'`, `fechaHoraRespuesta`, `cantidadAceptada` e `importeAceptado` sean `NULL`).
  3. **No se proponen ni asumen como aprobadas nuevas columnas ni tablas.** Queda identificado este límite para que el responsable determine si la reconstrucción temporal vía `PRECIO_PRODUCTO` + `PEDIDO` junto con los campos actuales de `OFERTA_EXCEDENTE` es suficiente para B3, o si requiere un ajuste futuro sujeto a CR.

---

### 4.3. D3-B — Aceptación Expresa en Dos Pasos

* **Estado de la decisión:** **APROBADA POR EL RESPONSABLE (09/11/2026)** con la **Alternativa `CR-B` aprobada como orientación funcional**, sujeta al **Pendiente Técnico `RT-UC07-03`** sobre el diseño del mecanismo de evidencia.

#### Definición funcional consolidada (D3-B):
Se preserva sin modificaciones la firma canónica aprobada en G0 (`CONTRATOS_REV04B §6.1 L235`):
```text
registrarRespuestaOfertaExcedente(idOfertaExcedente: Long, aceptada: Boolean, cantidadAceptada: BigDecimal[0..1])
```
Para cumplir la exigencia contractual de que, ante una aceptación parcial (`cantidadAceptada < cantidadOfrecida`), se recalcule el importe y se cuente con la aceptación expresa del cliente antes de confirmar (`REV-04B §6.5 L243` y excepción `A2 L249`), se establece un **protocolo funcional de dos pasos**:

* **Paso 1 — Cotización y conformidad:**
  El sistema determina la cantidad (`cantidadAceptada`) y el importe resultante (`importeAceptado` calculado determinísticamente con los parámetros congelados de la oferta según `D2-A`) y los presenta al vendedor/cliente para obtener la **aceptación expresa del cliente** sobre ese monto exacto antes de ejecutar la confirmación.
* **Paso 2 — Confirmación:**
  Una vez obtenida la conformidad expresa del cliente, el vendedor registra la aceptación invocando la firma canónica existente:
  `registrarRespuestaOfertaExcedente(idOfertaExcedente, aceptada, cantidadAceptada)`.

#### Condiciones obligatorias de cumplimiento:
1. **No modificar la firma G0:** No se añade `importeAceptado` ni ningún otro parámetro extra a la firma canónica de `registrarRespuestaOfertaExcedente`.
2. **Revalidar disponibilidad y estado del pedido:** Al ejecutar el Paso 2, el servidor revalida transaccionalmente que `OFERTA_EXCEDENTE.respuesta == 'PENDIENTE'`, que `PEDIDO.estado == 'PENDIENTE'` y que `EXCEDENTE.cantidadDisponible >= cantidadAceptada`.
3. **Verificar correspondencia del importe final:** El servidor calcula el `importeAceptado` verificando que corresponda exactamente a la `cantidadAceptada` y a las condiciones económicas de la oferta comunicada.
4. **Prohibición de aceptación silenciosa de importes discrepantes:** El sistema no puede aceptar ni imputar silenciosamente un importe diferente del que fue determinado y comunicado para la conformidad del cliente.
5. **Conservación de evidencia verificable:** Deben conservarse de forma auditable la cantidad aceptada, el importe aceptado, el instante de respuesta y el vendedor actuante.
6. **Protección frente a invalidación concurrente:** Un cambio concurrente (sobre el excedente, el pedido o la oferta) no puede invalidar silenciosamente las condiciones bajo las cuales se obtuvo la conformidad; ante cualquier alteración concurrente de disponibilidad o estado, la confirmación debe rechazarse de forma atómica (excepciones `A2` / `A3`).

#### Pendiente técnico obligatorio (`RT-UC07-03`) — Mecanismo de obtención, vinculación y persistencia de la evidencia de aceptación:

> [!IMPORTANT]
> **Mecanismo de evidencia NO resuelto — Pendiente de diseño técnico antes de implementar B3:**
> El recálculo matemático en el servidor garantiza exactitud aritmética, pero por sí solo no demuestra que el cliente haya prestado conformidad al nuevo importe recalculado cuando `cantidadAceptada < cantidadOfrecida`.
>
> * **Orientación funcional aprobada (`CR-B`):** El responsable aprobó la alternativa `CR-B` como orientación funcional para evitar modificar innecesariamente la firma canónica de G0.
> * **Restricción técnica abierta:** Actualmente, en el manifiesto canónico de 67 operaciones (`G0_MANIFIESTO_CANONICO_67_OPERACIONES_2026-10-29.csv`) solo existen las dos operaciones de `UC-07` (`registrarOfertaExcedente` y `registrarRespuestaOfertaExcedente`), la firma del Paso 2 solo admite `(idOfertaExcedente, aceptada, cantidadAceptada)`, y la restricción SQL `ck_oferta_excedente_3` (`V1 L260`) impide guardar `cantidadAceptada` o `importeAceptado` en `OFERTA_EXCEDENTE` mientras `respuesta = 'PENDIENTE'`.
> * **Deber de diseño y regla de bloqueo:** Queda **PENDIENTE** determinar técnicamente cómo se obtiene, vincula y persiste la evidencia de aceptación del Paso 1 con la confirmación del Paso 2 sin introducir una ampliación contractual o de esquema no autorizada (por ejemplo, evaluando si una segunda oferta por la cantidad exacta deseada cuando el cliente pide menos unidades o un mecanismo de sesión/auditoría interna satisface las invariantes, o si ambos presentan limitaciones). **No se presenta este mecanismo como resuelto.** Si durante el diseño detallado previo a B3 se comprueba que no puede implementarse preservando simultáneamente G0 y todas las invariantes vigentes, se deberá **detener la implementación de ese punto, registrar formalmente el impedimento y solicitar autorización expresa al responsable para una modificación contractual (`CR-B0-UC07-001` / Alternativa `CR-A`)**.

---

### 4.4. D4-A — Separación Documental, `totalVigente` y Consistencia con `UC-05` / `UC-06`

* **Estado de la decisión:** **APROBADA POR EL RESPONSABLE (09/11/2026)**, pendiente de ratificación documental definitiva.

#### 1. Separación documental aprobada (D4-A):
Se mantienen como dos instrumentos independientes y coordinados:
* **`RD-I302-001` (PR #44):** `UC-05 — Registrar Entrega`, persistencia del efectivo en tránsito e idempotencia de entrega.
* **`RD-UC07-001` (PR #45 — este documento):** `UC-07 — Ofrecer y Reasignar Excedente`, ofertas, aceptación, líneas técnicas, tarificación e invariantes de reasignación de excedentes físicos.

Ambos documentos mantienen trazabilidad cruzada (la sección 14.2 de `RD-I302-001` remite la resolución de la tarificación de `importeInformado` y de las líneas adicionales de `UC-07` a esta RD). No se duplican reglas financieras ni se mezcla el efectivo en tránsito con el inventario de excedentes físicos.

#### 2. Separación estricta de cinco niveles comerciales y contables:

```text
[1. totalOriginal]
    Inmutable en PEDIDO.totalOriginal (fijado en UC-03 / UC-21).
         +
[2. incrementosComercialesAceptados]
    SUM(OFERTA_EXCEDENTE.importeAceptado) con respuesta = 'ACEPTADA' para el pedido receptor.
         =
[3. totalVigente]
    Derivado en memoria / consultas (totalOriginal + incrementosComercialesAceptados).
    NO es columna física y NO devenga deuda en Cuenta Corriente por sí mismo.
         |
         v  (Ejecución física del reparto en UC-05 — Registrar Entrega)
[4. importeEfectivamenteEntregado]
    Determinado en UC-05 a partir de las cantidades realmente entregadas en DETALLE_ENTREGA,
    imputando comercialmente primero las unidades originales y luego las adicionales aceptadas
    en UC-07 por orden cronológico en IMPUTACION_ENTREGA_ADICIONAL (REV-04B §2.2 L61, §2.9 L105).
         |
         v  (Devengamiento contable exclusivo de UC-05)
[5. cargoContableCorrespondiente]
    Único MovimientoCuenta de tipo CARGO_POR_VENTA generado exclusivamente por UC-05
    por el importeEfectivamenteEntregado (RD-007, A2, REV-04B §2.9 L105).
```

#### 3. Comportamiento ante diferencias en la entrega (`UC-05`) o cancelación previa del pedido (`UC-06`):

1. **Entrega parcial o cantidad entregada inferior a la aceptada en `UC-05` (`CONTRATOS_REV04B §2.6 A2, §2.9 L97–105`):**
   * En `UC-05`, las cantidades entregadas no pueden ser negativas ni todas iguales a cero, ni superar `cantidadOriginal + adicionalesAceptados` (excepción `A2` de `UC-05`).
   * Para cada línea de producto elaborado, `UC-05` imputa comercialmente **primero las unidades originales** del pedido (valoradas según sus condiciones originales congeladas) y **luego las unidades adicionales aceptadas en `UC-07` por orden cronológico**, registrando en `IMPUTACION_ENTREGA_ADICIONAL` (`cantidadImputada`, `importeImputado`) únicamente la porción adicional efectivamente entregada.
   * El `CARGO_POR_VENTA` en `MOVIMIENTO_CUENTA` se genera **exclusivamente por las unidades efectivamente entregadas**.
   * Cualquier sobrante físico de producto elaborado disponible que no haya sido entregado al cliente en `UC-05` genera una **nueva instancia en `EXCEDENTE`** en estado disponible con `origenGeneracion = 'ENTREGA'`, conservando su costo histórico proporcional (`REV-04B §2.9 L103`). No se modifica hacia atrás el `MOVIMIENTO_EXCEDENTE` (`REASIGNACION`) ya ejecutado en `UC-07`.
2. **Cancelación de un pedido `PENDIENTE` antes de la entrega mediante `UC-06` (`CONTRATOS_REV04B §3.6 A1, §3.9 L153–160`):**
   * `UC-06 — Cancelar Pedido` opera **exclusivamente sobre pedidos en estado `PENDIENTE`** (si el pedido ya está `ENTREGADO` o `CANCELADO`, `UC-06` lo rechaza por excepción `A1`).
   * Si un pedido `PENDIENTE` que ya había recibido unidades adicionales por ofertas aceptadas en `UC-07` es cancelado mediante `UC-06`, el pedido pasa a `CANCELADO` sin generar `CARGO_POR_VENTA`, y para cada producto elaborado con unidades disponibles (preparadas en `UC-28` o recibidas en `UC-07`) `UC-06` crea una **nueva instancia de `EXCEDENTE`** con `origenGeneracion = 'CANCELACION'` (pudiendo referenciar `idMovimientoExcedenteOrigen` en `EXCEDENTE` según `V1 L232, L916`), conservando su costo histórico ponderado (`REV-04B §3.9 L155`).
3. **Exclusión expresa de «cancelación de entrega» o «reversión de entrega registrada»:**
   * **No existe en el catálogo canónico de 64 CU / 67 operaciones ninguna operación de «cancelación de entrega» ni de reversión de una `ENTREGA` ya confirmada.**
   * `UC-06 — Cancelar Pedido` no revierte entregas registradas (`REV-04B §3.6 A1`), y la tabla `MOVIMIENTO_EXCEDENTE` solo admite `tipoMovimiento IN ('REASIGNACION', 'DESCARTE')` (`ck_movimiento_excedente_0`, `V1 L274`).
   * Cualquier comportamiento de reversión posterior a una entrega confirmada no contemplado por los contratos canónicos permanece **estrictamente fuera del alcance** hasta que exista una decisión formal del responsable.

---

### 4.5. D5-B — Invariantes de Concurrencia y Reserva Técnica sobre Locks

* **Estado de la decisión:** **Invariantes de concurrencia APROBADAS POR EL RESPONSABLE (09/11/2026)**, pendientes de ratificación documental definitiva. El **orden concreto de adquisición de locks queda bajo la Reserva Técnica `RT-UC07-04`**.

#### 1. Invariantes obligatorias de concurrencia aprobadas (D5-B):
Toda implementación de `UC-07` y de los casos de uso que interactúan con `EXCEDENTE` y `PEDIDO` debe satisfacer obligatoriamente las siguientes ocho invariantes:

1. **No sobreasignación ni sobredescarte:** La suma de cantidades reasignadas (`UC-07`) y descartadas (`UC-41`) sobre un mismo `EXCEDENTE` nunca puede superar su disponibilidad física (`cantidadDisponible >= 0` y `cantidadDisponible <= cantidadInicial`, `costoHistoricoDisponible >= 0`).
2. **Atomicidad de la aceptación:** La aceptación de una oferta en `registrarRespuestaOfertaExcedente` (actualización de `OFERTA_EXCEDENTE`, inserción de `MOVIMIENTO_EXCEDENTE`, descuento de `EXCEDENTE` y, cuando corresponda bajo `D1-B`, creación de la línea técnica en `DETALLE_PEDIDO`) es **estrictamente atómica** (todo o nada en una única transacción).
3. **Coordinación mutua entre `UC-07` y `UC-41`:** `UC-07` (reasignación) y `UC-41` (descarte) deben coordinar de manera serializada sus modificaciones sobre el mismo registro de `EXCEDENTE`.
4. **Prohibición de aceptar ofertas sobre pedidos no `PENDIENTE`:** `UC-07` no puede aceptar ofertas para pedidos que hayan dejado de estar en estado `PENDIENTE` (por entrega en `UC-05` o cancelación en `UC-06`).
5. **Resultados controlados ante conflictos concurrentes:** Las carreras entre transacciones concurrentes deben resolverse mediante rechazos de negocio determinísticos y controlados (`409 Conflict` / excepciones contractuales `A1`–`A3`), nunca mediante errores `500`, estados corruptos o violaciones no tratadas.
6. **Ausencia de duplicaciones:** No deben producirse duplicaciones de registros en `MOVIMIENTO_EXCEDENTE` (`uq_movimiento_excedente_0 UNIQUE ("idOfertaExcedente")`), de líneas por producto en `DETALLE_PEDIDO` (`uq_detalle_pedido_0 UNIQUE ("idPedido", "idProducto")`) ni de imputaciones en `IMPUTACION_ENTREGA_ADICIONAL` (`uq_imputacion_entrega_adicional_0 UNIQUE ("idMovimientoExcedente")`).
7. **Compatibilidad transaccional con `UC-05`:** El protocolo de bloqueo de `UC-07` debe ser plenamente compatible con `UC-05` (y con `UC-06`), impidiendo que una entrega o cancelación cierre un pedido mientras una aceptación de excedente está modificándolo, o viceversa.
8. **Verificación empírica de ausencia de deadlocks:** Las condiciones de ausencia de interbloqueos (*deadlocks*) deben comprobarse obligatoriamente mediante pruebas automatizadas de concurrencia sobre PostgreSQL real.

#### 2. Reserva técnica obligatoria (`RT-UC07-04`) e hipótesis técnica de secuencia de locks:

> [!IMPORTANT]
> **Reserva técnica `RT-UC07-04` (PROPUESTO — NO RATIFICADO NI PROBADO):**
> El orden concreto de adquisición de locks queda **pendiente de diseño detallado y de validación empírica mediante PostgreSQL / Testcontainers en CI**. La secuencia que se describe a continuación se conserva únicamente como **hipótesis técnica de trabajo**, y no debe interpretarse como un orden ratificado ni como comportamiento probado.

```text
+---------------------------------------------------------------------------------------------------+
|               HIPÓTESIS TÉCNICA DE LOCKS PARA UC-07 (PENDIENTE DE VALIDACIÓN EN CI)               |
+---------------------------------------------------------------------------------------------------+
|                                                                                                   |
|  [ Hipótesis para registrarRespuestaOfertaExcedente (Parte B - Aceptación) ]                      |
|    1. Revalidar sesión activa con rol VENDEDOR.                                                   |
|    2. Adquirir lock de fila sobre EXCEDENTE:                                                      |
|       SELECT "idExcedente", "idPedidoOrigen", "numeroDetalleOrigen",                              |
|              "cantidadDisponible", "costoHistoricoDisponible"                                     |
|       FROM "EXCEDENTE" WHERE "idExcedente" = :idExcedente FOR UPDATE;                             |
|    3. Adquirir lock de fila sobre OFERTA_EXCEDENTE:                                               |
|       SELECT * FROM "OFERTA_EXCEDENTE" WHERE "idOfertaExcedente" = :idOferta FOR UPDATE;          |
|    4. Adquirir lock de fila sobre PEDIDO receptor (y verificar CLIENTE activo):                   |
|       SELECT "idPedido", "idCliente", "estado", "tipoAjuste", "porcentajeAjuste"                  |
|       FROM "PEDIDO" WHERE "idPedido" = :idPedidoReceptor FOR UPDATE;                              |
|    5. Si se inserta en MOVIMIENTO_EXCEDENTE / DETALLE_PEDIDO sin secuencia SQL,                   |
|       coordinar el generador de IDs con advisory lock transaccional dedicado.                     |
|                                                                                                   |
+---------------------------------------------------------------------------------------------------+
```

#### Análisis preliminar de interacciones concurrentes a validar en Testcontainers:
* **`registrarOfertaExcedente` vs `registrarRespuestaOfertaExcedente`:** Verificar que la lectura de `EXCEDENTE`, `PRECIO_PRODUCTO` y `PEDIDO` al emitir una oferta y el bloqueo `FOR UPDATE` al responderla adquieran los recursos en un orden consistente, además de coordinar la generación de `idOfertaExcedente` (`COALESCE(MAX("idOfertaExcedente"), 0) + 1` requiere serialización de inserción).
* **`registrarRespuestaOfertaExcedente` vs `UC-41` (Descarte):** Ambos operan sobre el mismo `idExcedente`. Si ambos bloquean `EXCEDENTE ... FOR UPDATE` en primer lugar, el segundo esperará la liberación del lock y reevaluará `cantidadDisponible`.
* **`registrarRespuestaOfertaExcedente` vs `UC-05` (Entrega) y `UC-06` (Cancelación):** Si `UC-05` o `UC-06` bloquean primero `PEDIDO ... FOR UPDATE` y luego leen/insertan en `EXCEDENTE` (por sobrantes de entrega o cancelación), mientras `UC-07` bloquea `EXCEDENTE` y luego `PEDIDO`, debe verificarse en el diseño de B3 que `UC-05`/`UC-06` solo hacen `INSERT` de nuevos registros de `EXCEDENTE` (sin hacer `FOR UPDATE` sobre el `idExcedente` anterior) o bien unificar el orden `PEDIDO` vs `EXCEDENTE` para evitar ciclos de espera.

---

## 5. Síntesis consolidada del estado de D1–D5

| Código | Tema | Estado funcional (09/11/2026) | Estado documental / técnico | Reserva o pendiente asociado |
|---|---|---|---|---|
| **D1-B** | Compatibilidad del pedido receptor mediante línea técnica (`cantidadOriginal = 0`) | **APROBADA POR RESPONSABLE** | Pendiente de ratificación documental; 0% implementado en código | **`RT-UC07-01`:** Conflicto con trigger `tg_mr3_validar_producto_detalle_nuevo` cuando `PRODUCTO.activo = FALSE` y el producto no existía en el pedido; ajuste de `count(*)` en `CargarPedidoService`. |
| **D2-A** | Tarificación comercial con `precioBase` vigente + ajuste congelado del pedido receptor | **APROBADA POR RESPONSABLE** | Pendiente de ratificación documental; 0% implementado en código | **`RT-UC07-02`:** `OFERTA_EXCEDENTE` no persiste columna física `idPrecio` / `precioBase`; la reconstrucción histórica depende del intervalo temporal en `PRECIO_PRODUCTO`. |
| **D3-B** | Aceptación expresa en dos pasos conservando firma canónica G0 (orientación `CR-B`) | **APROBADA POR RESPONSABLE** | Pendiente de ratificación documental; 0% implementado en código | **`RT-UC07-03`:** Falta diseñar cómo se obtiene, vincula y persiste la evidencia de aceptación sin ampliar contratos G0; si fuera inviable, activar `CR-B0-UC07-001`. |
| **D4-A** | Separación documental (`RD-I302-001` vs `RD-UC07-001`) y 5 niveles de importe/cargo | **APROBADA POR RESPONSABLE** | Pendiente de ratificación documental; 0% implementado en código | Sin reversión de entregas registradas (fuera de alcance). Articulación estricta con `UC-05` y `UC-06`. |
| **D5-B** | Ocho invariantes obligatorias de concurrencia y atomicidad | **APROBADA POR RESPONSABLE** | Invariantes aprobadas; orden de locks **PROPUESTO** (no ratificado); 0 pruebas ejecutadas | **`RT-UC07-04`:** El orden concreto de locks requiere diseño detallado y validación empírica con PostgreSQL/Testcontainers en CI. |

---

## 6. Riesgos arquitectónicos y residuos técnicos identificados

| ID | Riesgo / Residuo técnico | Severidad | Estado / Mitigación |
|---|---|---|---|
| **R-UC07-01** | Rechazo por trigger `tg_mr3_validar_producto_detalle_nuevo` al crear línea técnica para un excedente cuyo producto fue desactivado (`PRODUCTO.activo = FALSE`). | **ALTA** | Documentado en **`RT-UC07-01`**. No se altera el trigger automáticamente; requiere decisión del responsable antes de implementar. |
| **R-UC07-02** | Violación de `uq_detalle_pedido_0` ante múltiples ofertas aceptadas del mismo producto para el mismo pedido receptor. | **ALTA** | Mitigado por regla obligatoria de `D1-B`: consultar y reutilizar siempre el `numeroDetalle` existente para `(idPedido, idProducto)`. |
| **R-UC07-03** | Alteración del conteo `items` en replay idempotente de `UC-03` (`CargarPedidoService.java` L69) tras insertar líneas técnicas con `cantidadOriginal = 0`. | **MEDIA** | Mitigado especificando que el conteo de ítems originales en `CargarPedidoService` debe filtrar `WHERE d."cantidadOriginal" > 0`. |
| **R-UC07-04** | Ausencia de columna `idPrecio` / `precioBase` en `OFERTA_EXCEDENTE` para reconstrucción directa sin cruce temporal con `PRECIO_PRODUCTO`. | **MEDIA** | Documentado en **`RT-UC07-02`**. No se proponen cambios físicos como aprobados; sujeto a validación de suficiencia. |
| **R-UC07-05** | Falta de diseño del mecanismo técnico para vincular y persistir la evidencia de conformidad del cliente en el protocolo de dos pasos (`D3-B`). | **ALTA** | Documentado en **`RT-UC07-03`**. Debe diseñarse antes de B3; si no pudiera resolverse respetando G0, solicitar autorización para `CR-B0-UC07-001`. |
| **R-UC07-06** | Carrera concurrente o deadlock entre `UC-07`, `UC-41`, `UC-05`, `UC-06` y `UC-19`. | **ALTA** | Documentado en **`RT-UC07-04`**. Requiere diseño detallado del orden global de locks y suite de concurrencia con Testcontainers. |
| **R-UC07-07** | Residuo de redondeo en `EXCEDENTE.costoHistoricoDisponible` (`NUMERIC(18,4)`) al agotar el saldo disponible en múltiples reasignaciones/descartes. | **MEDIA** | Cuando `cantidadAceptada == cantidadDisponible`, `costoHistoricoSalida` toma exactamente el `costoHistoricoDisponible` remanente (4 decimales). |

---

## 7. Impacto transversal y trazabilidad cruzada (`UC-05`, `UC-06`, `UC-41`, `RD-I302-001`)

1. **Trazabilidad con `RD-I302-001` (PR #44) y `UC-05 — Registrar Entrega`:**
   * Las decisiones `D1-B` (línea técnica `cantidadOriginal = 0`) y `D2-A` (tarificación de `importeInformado` / `importeAceptado`) resuelven en este documento los dos pendientes de `UC-07` referenciados en la sección 14.2 de `RD-I302-001`.
   * Durante `UC-05`, el servicio de entrega lee las líneas de `DETALLE_PEDIDO` (incluidas las líneas técnicas creadas por `UC-07` bajo `D1-B`) y los movimientos `MOVIMIENTO_EXCEDENTE` (`REASIGNACION`) asociados a ofertas aceptadas del pedido, registrando `DETALLE_ENTREGA` e `IMPUTACION_ENTREGA_ADICIONAL` y calculando el único `CARGO_POR_VENTA` sobre lo efectivamente entregado.
2. **Trazabilidad con `UC-06 — Cancelar Pedido`:**
   * `UC-06` solo cancela pedidos en estado `PENDIENTE`. Si el pedido cancelado tenía unidades adicionales aceptadas vía `UC-07`, `UC-06` genera un nuevo `EXCEDENTE` con `origenGeneracion = 'CANCELACION'` y su costo histórico preservado (`REV-04B §3.9 L155`). No existe operación de cancelación de una entrega ya registrada.
3. **Trazabilidad con `UC-41 — Registrar Descarte de Excedente` y `UC-61 — Buscar Excedente`:**
   * `UC-61` consulta excedentes sin reservar stock ni exponer costos internos al `VENDEDOR` (`BC07`).
   * `UC-41` y `UC-07` consumen de manera excluyente y coordinada `EXCEDENTE.cantidadDisponible` y `EXCEDENTE.costoHistoricoDisponible`, registrando su trazabilidad en `MOVIMIENTO_EXCEDENTE`.

---

## 8. Dependencias de contratos y modelo relacional

* **Contratos canónicos G0 (`CONTRATOS_REV04B_CORREGIDOS_B0_ACTUALIZADO.md`):**
  * **Se preservan intactas las firmas y las 9 secciones** de `registrarOfertaExcedente` (§5) y `registrarRespuestaOfertaExcedente` (§6), así como el manifiesto canónico de 67 operaciones.
  * Bajo `D3-B`, la alternativa `CR-B` queda aprobada como orientación funcional. La Solicitud de Cambio Contractual `CR-B0-UC07-001` (ampliación de firma o contrato) permanece **no activada / condicionada**, y solo se elevará para autorización expresa del responsable si durante el diseño detallado de `RT-UC07-03` se demuestra imposible persistir la evidencia de aceptación preservando G0.
* **Modelo Relacional MR-5 / MR-6 (`V1`–`V3`):**
  * **Cero cambios de DDL autorizados.** Las migraciones `V1__baseline_mr5.sql`, `V2__f01_cobro_estados.sql` y `V3__trazabilidad_partidas_insumo.sql` permanecen inalteradas.
  * Cualquier eventual cambio físico futuro derivado de `RT-UC07-01`, `RT-UC07-02` o `RT-UC07-03` exigirá una Solicitud de Cambio (CR) y aprobación expresa antes de tocar SQL.

---

## 9. Pruebas de aceptación y concurrencia propuestas (NO EJECUTADAS)

> [!NOTE]
> **Evidencia actual de ejecución:** En este PR se ejecutaron únicamente las **21 pruebas documentales de `tests/b0`** en el repositorio de gobierno. **Ninguna de las pruebas de aplicación o concurrencia listadas a continuación (`T-U07-01` a `T-U07-13`) ha sido implementada ni ejecutada.** Deberán construirse con PostgreSQL real / Testcontainers en `ale-milanesas-app` durante B3/B4.

| Código | Escenario | Resultado esperado |
|---|---|---|
| **T-U07-01** | Registro de oferta sobre excedente disponible para pedido `PENDIENTE` y cliente `ACTIVO`. | `201 Created`. `OFERTA_EXCEDENTE` en `PENDIENTE`, `importeInformado` calculado según `D2-A`. `EXCEDENTE.cantidadDisponible` y `DETALLE_PEDIDO` intactos. |
| **T-U07-02** | Registro de oferta con `cantidadOfrecida <= 0` o `cantidadOfrecida > cantidadDisponible`. | Rechazo `400 / 409 Conflict` (Excepción A1). Cero escrituras. |
| **T-U07-03** | Registro de oferta sobre pedido no `PENDIENTE` o producto sin `PRECIO_PRODUCTO` vigente. | Rechazo `409 Conflict` (Excepción A2). Cero escrituras. |
| **T-U07-04** | Tarificación `D2-A` en los tres casos (`SIN_AJUSTE`, `DESCUENTO`, `RECARGO`). | `importeInformado` coincide al centavo (`HALF_UP` escala 2) con el ajuste congelado en `PEDIDO`, sin invocar `UC-15`/`UC-16`. |
| **T-U07-05** | Aceptación total (`cantidadAceptada == cantidadOfrecida`) para producto ya existente en el pedido receptor. | `OFERTA_EXCEDENTE` pasa a `ACEPTADA`, se reutiliza el `numeroDetalle` existente, se inserta `MOVIMIENTO_EXCEDENTE` (`REASIGNACION`) con `costoHistoricoSalida` en escala 4 y se descuenta `EXCEDENTE`. |
| **T-U07-06** | Aceptación de oferta para producto ausente en el pedido receptor (`D1-B`, producto activo). | Se crea línea técnica en `DETALLE_PEDIDO` con `cantidadOriginal = 0` y `precioUnitarioOriginal = NULL` (cumpliendo `ck_detalle_pedido_3`); `PEDIDO.totalOriginal` y el conteo de ítems originales de `UC-03` permanecen inalterados. |
| **T-U07-07** | Segunda oferta aceptada para el mismo producto ausente originalmente en el mismo pedido (`D1-B`). | Reutiliza la línea técnica existente sin violar `uq_detalle_pedido_0`. |
| **T-U07-08** | Intento de registrar preparación (`UC-28`) sobre la línea técnica `cantidadOriginal = 0` o consulta de preparables (`UC-34`). | `UC-28` rechaza con `CANTIDAD_EXCEDE_ORIGINAL`; `UC-34` no incluye la línea técnica entre los preparables. |
| **T-U07-09** | Rechazo de oferta (`aceptada == false`). | `OFERTA_EXCEDENTE` pasa a `RECHAZADA` con `fechaHoraRespuesta`. No se crea línea técnica ni `MOVIMIENTO_EXCEDENTE`, y `EXCEDENTE.cantidadDisponible` queda intacto. |
| **T-U07-10** | Aceptación parcial (`cantidadAceptada < cantidadOfrecida`) bajo protocolo en dos pasos (`D3-B`). | Se verifica evidencia de conformidad previa (según diseño de `RT-UC07-03`), se transfiere solo `cantidadAceptada` y queda remanente disponible en `EXCEDENTE`. |
| **T-U07-11** | Concurrencia: dos aceptaciones simultáneas (`UC-07`) o aceptación (`UC-07`) vs descarte (`UC-41`) sobre el mismo `EXCEDENTE` que superan el saldo disponible. | Ejecución serializada sin deadlock; una transacción confirma y la otra falla limpiamente con `409 Conflict` (A2). `cantidadDisponible >= 0` siempre. |
| **T-U07-12** | Concurrencia: aceptación de oferta (`UC-07`) simultánea con entrega (`UC-05`) o cancelación (`UC-06`) del mismo pedido receptor. | Ejecución serializada sin deadlock; si el pedido dejó de estar `PENDIENTE`, `UC-07` rechaza con `409 Conflict` (A3). |
| **T-U07-13** | Control RBAC: invocación de `UC-07` por `ADMINISTRADOR`, `REPARTIDOR` o `RESPONSABLE_PRODUCCION`. | `403 Forbidden`. Solo `VENDEDOR` autorizado. |

---

## 10. Reservas técnicas y decisiones pendientes de resolución

Aunque las decisiones **D1-B, D2-A, D3-B, D4-A y D5-B** cuentan con aprobación expresa del responsable del 09/11/2026, quedan pendientes de resolución formal los siguientes puntos antes de declarar cerrada esta especificación e iniciar la codificación:

1. **Ratificación documental definitiva de `RD-UC07-001`:**
   Formalización del cierre y firma de este documento por parte de Victor Leandro Machado conforme al flujo de gobierno del repositorio.
2. **Resolución de la Reserva Técnica `RT-UC07-01` (Excedente de producto desactivado en catálogo):**
   Definir si se prohíbe funcionalmente reasignar excedentes de productos con `PRODUCTO.activo = FALSE` hacia pedidos que no contengan ya ese producto (conservando intacto el trigger `tg_mr3_validar_producto_detalle_nuevo`), o si se tramita una CR futura sobre dicho trigger para líneas técnicas con `cantidadOriginal = 0`.
3. **Verificación sobre el Gap `RT-UC07-02` (Reconstrucción histórica de la cotización):**
   Confirmar si la reconstrucción del `precioBase` mediante cruce temporal de `OFERTA_EXCEDENTE.fechaHoraOferta` con `PRECIO_PRODUCTO` y los atributos congelados de `PEDIDO` se considera suficiente sin agregar columnas físicas a `OFERTA_EXCEDENTE`.
4. **Resolución del Pendiente Técnico `RT-UC07-03` (Evidencia verificable en el protocolo de dos pasos `D3-B`):**
   Especificar el diseño técnico exacto mediante el cual se obtiene, vincula y persiste la evidencia de aceptación expresa del importe recalculado bajo la orientación `CR-B` sin vulnerar G0 ni `ck_oferta_excedente_3`; o, en caso de comprobarse inviable, elevar para autorización la modificación contractual `CR-B0-UC07-001`.
5. **Resolución de la Reserva Técnica `RT-UC07-04` (Diseño detallado y prueba empírica del orden de locks `D5-B`):**
   Definir el orden definitivo de adquisición de locks entre `UC-07`, `UC-41`, `UC-05`, `UC-06` y `UC-19`, y validarlo mediante pruebas reales de concurrencia con PostgreSQL / Testcontainers en CI.

---

## 11. Condiciones previas para implementar UC-07 en B3

No se deberá iniciar la implementación de código de `UC-07` en `leandrito369/ale-milanesas-app` hasta que se cumplan las siguientes condiciones:

1. Ratificación documental definitiva de `RD-UC07-001` y merge del PR #45 en `leandrito369/ale-milanesas`.
2. Resolución explícita de las reservas técnicas **`RT-UC07-01`** (producto inactivo frente a trigger de `DETALLE_PEDIDO`) y **`RT-UC07-03`** (mecanismo de evidencia de aceptación en dos pasos).
3. Diseño operacional detallado del orden de locks (`RT-UC07-04`) y ajuste del conteo de ítems originales en `CargarPedidoService.java` (L69) para ignorar líneas técnicas con `cantidadOriginal = 0`.
4. Coordinación con las definiciones de `UC-05` (`RD-I302-001`, PR #44) para la lectura e imputación de líneas adicionales en `IMPUTACION_ENTREGA_ADICIONAL`.

---

## 12. Restricciones de despliegue

* **El entorno de despliegue permanece en estado PAUSADO.**
* La **Issue #28** de `leandrito369/ale-milanesas-app` continúa **ABIERTA**.
* La consolidación de las decisiones D1–D5 en esta propuesta documental no autoriza la activación de endpoints de escritura en producción, no levanta la pausa operativa ni habilita despliegues.
