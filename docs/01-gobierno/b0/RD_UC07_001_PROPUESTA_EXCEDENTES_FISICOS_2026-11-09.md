# RD-UC07-001 (PROPUESTA) — Decisiones de arquitectura y diseño para reasignación de excedentes físicos (UC-07)

**Fecha de redacción:** 09/11/2026  
**Estado:** **PROPUESTA — NO RATIFICADA.** Este documento no constituye una decisión ratificada del responsable, no autoriza cambios físicos en la base de datos ni habilita la implementación de código en `ale-milanesas-app`.  
**Autoridad que debe decidir:** Victor Leandro Machado (responsable del proyecto).  
**Numeración:** `RD-UC07-001` (provisional). Verificado en `docs/01-gobierno/` y `docs/01-gobierno/b0/` al 09/11/2026: no existe ninguna RD previa para `UC-07`.  
**Alcance:** Definiciones funcionales, reglas de tarificación comercial, compatibilidad relacional y protocolo de concurrencia para el caso de uso `UC-07 — Ofrecer y Reasignar Excedente` (operaciones `registrarOfertaExcedente` y `registrarRespuestaOfertaExcedente`), articulado con `UC-61` (Buscar Excedente), `UC-41` (Descarte de Excedente) y `UC-05` (Registrar Entrega).  
**Separación respecto a PR #44:** Este documento aborda exclusivamente **excedentes físicos de productos elaborados** (milanesas sobrantes). El PR #44 (`RD-I302-001`) aborda de forma independiente la entrega, la idempotencia de `UC-05` y la persistencia del efectivo en tránsito / pagos en exceso.

---

## Leyenda de estados empleada en este documento

| Etiqueta | Significado |
|---|---|
| **APROBADO** | Decisión ratificada previamente por el responsable en actas o RDs existentes (se cita la fuente formal). |
| **PROPUESTO** | Alternativa o diseño técnico propuesto en este instrumento; sujeto a revisión y firma del responsable. |
| **PENDIENTE** | Definición de negocio o técnica que permanece sin resolver; no se asume por inferencia. |
| **IMPLEMENTADO** | Estructura existente en código Java o DDL SQL en `ale-milanesas-app` (se cita archivo y línea). |
| **PROBADO** | Prueba automatizada ejecutada con resultado positivo comprobado. **Nada en esta propuesta está PROBADO.** |

---

## 1. Contexto y problema técnico

El caso de uso `UC-07 — Ofrecer y Reasignar Excedente` forma parte del bloque **I3-02 (Entrega y Excedentes)** según el Plan Rector. Fue formalizado en la consolidación B0 bajo dos contratos canónicos individuales en `CONTRATOS_REV04B_CORREGIDOS_B0_ACTUALIZADO.md`:
1. `registrarOfertaExcedente` (§5, L199–231).
2. `registrarRespuestaOfertaExcedente` (§6, L233–277).

La auditoría técnica constató que el modelo relacional MR-5 (`V1__baseline_mr5.sql`) ya cuenta con las tablas `EXCEDENTE`, `OFERTA_EXCEDENTE`, `MOVIMIENTO_EXCEDENTE` e `IMPUTACION_ENTREGA_ADICIONAL`. Sin embargo, existen **vacíos de diseño, restricciones relacionales y tensiones contractuales** que deben resolverse antes de codificar:

1. **Compatibilidad relacional del Pedido receptor:** La tabla `IMPUTACION_ENTREGA_ADICIONAL` (donde se asientan las unidades de excedente entregadas) exige FK hacia `DETALLE_ENTREGA(idPedido, numeroDetalle)`, que a su vez exige FK hacia `DETALLE_PEDIDO(idPedido, numeroDetalle)`. Si un pedido receptor no solicitó originalmente el producto excedente, la entrega física requiere definir un mecanismo formal para registrar el producto sin vulnerar `RD-012` ni corromper las consultas del sistema.
2. **Ambigüedad en la tarificación comercial de `importeInformado` e `importeAceptado`:** El contrato canónico exige un `PrecioProducto` vigente pero no fija la fórmula exacta con respecto a la categoría comercial y recargo/descuento del pedido receptor.
3. **Discrepancia en la firma canónica ante aceptación parcial:** El contrato canónico de G0 exige la aceptación del nuevo importe cuando `cantidadAceptada < cantidadOfrecida`, pero la firma aprobada en G0 no incluye un parámetro para dicho importe ni existe un procedimiento de confirmación normado.
4. **Separación contable estricta:** Es imperativo distinguir el cálculo en memoria de `totalVigente` de los débitos reales en cuenta corriente, garantizando consistencia ante entregas parciales o cancelaciones en `UC-05`.
5. **Protocolo de concurrencia y prevención de bloqueos mutuos:** La competencia simultánea entre ofertas, reasignaciones, descartes (`UC-41`) y entregas (`UC-05`) exige una jerarquía rigurosa de adquisición de locks.
6. **Ausencia de código en la aplicación:** En `ale-milanesas-app`, no existe ningún servicio, repositorio ni controlador para `UC-07` ni `EXCEDENTE` (0% implementado).

---

## 2. Fuentes canónicas y SHAs verificados

SHAs efectivos consultados el 09/11/2026:
* **Gobierno (`leandrito369/ale-milanesas`):** `origin/main` en [`d848f73`](https://github.com/leandrito369/ale-milanesas/commit/d848f73).
* **Implementación (`leandrito369/ale-milanesas-app`):** `origin/main` en [`d5f7607`](https://github.com/leandrito369/ale-milanesas-app/commit/d5f7607).

### Fuentes consultadas:
* [Plan Rector de Implementación](../PLAN_RECTOR_IMPLEMENTACION_2026-10-29.md) y [Backlog priorizado G0](B0_BACKLOG_PRIORIZADO_Y_GATE_G0_2026-10-29.md).
* [Contratos canónicos REV-04B](../../08-diagramas/consolidacion-b0/CONTRATOS_REV04B_CORREGIDOS_B0_ACTUALIZADO.md): §1 `UC-28`, §2 `UC-05`, §4 `UC-61`, §5 `UC-07 Parte A`, §6 `UC-07 Parte B`, §7 `UC-41`, §8 Glosario.
* [Matriz RBAC de cierre](B0_MATRIZ_RBAC_67_OPERACIONES_CIERRE_2026-10-29.csv) L9–10 (`UC-07` exclusivo `VENDEDOR=D`).
* [RD-012](../RD_01_REGISTRO_DECISIONES_v1.1_2026-10-25.md#L30) (inmutabilidad de pedidos confirmados).
* Decisiones [A2](../RD_01_REGISTRO_DECISIONES_v1.1_2026-10-25.md#L48), [A23](../RD_01_REGISTRO_DECISIONES_v1.1_2026-10-25.md#L90) y requerimiento [RF-13](../../03-requisitos/historico-2026-10-23/A_REQUISITOS.md#L2030).
* [RD-RP022-001](../RD_RP022_001_COSTEO_CONVERSIONES_REDONDEOS_2026-10-27.md) (costeo histórico, precisión decimal y redondeos).
* Esquema DDL en `ale-milanesas-app`: `V1__baseline_mr5.sql` (tablas `PEDIDO` L138, `DETALLE_PEDIDO` L174, `ENTREGA` L205, `DETALLE_ENTREGA` L212, `EXCEDENTE` L222, `OFERTA_EXCEDENTE` L243, `MOVIMIENTO_EXCEDENTE` L263, `IMPUTACION_ENTREGA_ADICIONAL` L280, `PRECIO_PRODUCTO` L292; FKs L911–923; Triggers L1282, L1687; Constraints L189).
* Código fuente en `ale-milanesas-app`: `AplicarAjusteComercialService.java` (L68–85), `RegistrarPreparacionService.java` (L98–110), `BuscarPedidoService.java` (L69–75).

---

## 3. Alcance y decisiones funcionales ya aprobadas (APROBADO)

Las siguientes reglas se encuentran formalmente ratificadas en la línea base y constituyen invariantes obligatorias:

1. **Desagrupamiento de UC-07 en dos contratos estándar (APROBADO):**
   * Operación 1: `registrarOfertaExcedente(idExcedente, idPedidoReceptor, cantidadOfrecida)`.
   * Operación 2: `registrarRespuestaOfertaExcedente(idOfertaExcedente, aceptada, cantidadAceptada)`.
2. **RBAC estricto (APROBADO):** Exclusivo para el rol `VENDEDOR = D`. El rol `ADMINISTRADOR` tiene `NR` (no hereda permisos automáticos por rango superior).
3. **No reserva de existencias en la oferta (APROBADO):** El registro de una `OfertaExcedente` (`respuesta = PENDIENTE`) no bloquea existencias ni reduce `EXCEDENTE.cantidadDisponible`.
4. **No re-elaboración ni nuevo consumo de insumos (APROBADO):** La incorporación de excedentes a un pedido receptor **no ejecuta UC-28, no genera registros en `PREPARACION`, no descuenta insumos ni altera `cantidadPreparadaPropiaAcumulada`** (`REV-04B §1.5 L25`).
5. **Inmutabilidad de condiciones originales del pedido receptor (APROBADO):** La reasignación no modifica `DETALLE_PEDIDO.cantidadOriginal`, no altera `PEDIDO.totalOriginal`, no altera la promoción aplicada originalmente ni el ajuste comercial global (`REV-04B §6.9 L267`).
6. **Total vigente derivado (APROBADO):** `PEDIDO.totalVigente` es un valor derivado de la suma de `totalOriginal` y las ofertas aceptadas; no es una columna física en la base de datos (`AGENTS.md`).
7. **Trazabilidad estricta de costo histórico (APROBADO):** La reasignación transfiere una porción proporcional exacta de `EXCEDENTE.costoHistoricoDisponible` a `MOVIMIENTO_EXCEDENTE.costoHistoricoSalida` (`RD-RP022-001`). No se inventa costo cero.
8. **Separación conceptual obligatoria (APROBADO):** Un excedente físico de producto (`UC-07`) no tiene relación con el pago en exceso o saldo deudor provisional de `UC-05` / `RD-F04-003`.

---

## 4. Análisis técnico detallado de decisiones y alternativas

### D1 — Compatibilidad del Pedido Receptor (Alcance de Productos Reasignables)

El contrato canónico señala que el pedido receptor debe ser un *"candidato en estado PENDIENTE"*, mientras que requisitos previos mencionan *"Pedidos compatibles"*. Se evalúan tres alternativas técnicas y comerciales:

#### Alternativa D1-A: Permitir únicamente productos preexistentes en el pedido receptor (Conservadora)
* **Mecanismo:** El sistema valida que el `idProducto` del `EXCEDENTE` coincida con el `idProducto` de al menos una línea ya presente en `DETALLE_PEDIDO` del pedido receptor.
* **Reglas de negocio afectadas:** Restringe el ofrecimiento de excedentes: un cliente solo puede recibir ofertas de productos que ya haya ordenado. Si sobran milanesas de pollo y el cliente solo ordenó milanesas de carne, no puede ofrecérsele el excedente.
* **Compatibilidad con G0 y RD-012:** Máxima (100%). No se insertan ni modifican líneas en `DETALLE_PEDIDO`. Respeta taxativamente la prohibición de modificar pedidos confirmados (`RD-012`).
* **Cambios de esquema:** Cero.
* **Riesgos de integridad:** Nulos. En `UC-05`, `IMPUTACION_ENTREGA_ADICIONAL` se asocia al `(idPedido, numeroDetalle)` ya existente en `DETALLE_ENTREGA` y `DETALLE_PEDIDO`.
* **Impacto en UC-05:** Directo y sin fricción. La línea ya existe.

#### Alternativa D1-B: Permitir productos adicionales mediante líneas técnicas con `cantidadOriginal = 0` (RECOMENDADA — PROPUESTA, NO RATIFICADA)
* **Mecanismo:** Si el producto ofrecido no estaba en el pedido, al confirmarse la aceptación (`UC-07 Parte B`) el sistema inserta una fila técnica en `DETALLE_PEDIDO` con:
  - `numeroDetalle = COALESCE(MAX(numeroDetalle), 0) + 1`
  - `idPedido = :idPedidoReceptor`
  - `idProducto = :idProductoExcedente`
  - `cantidadOriginal = 0.000`
  - `precioUnitarioOriginal = NULL`
  - `porcentajePromocionOriginal = 0.00`
  - `idPromocionAplicada = NULL`
* **Verificación técnica exhaustiva:**
  1. **Triggers sobre `DETALLE_PEDIDO`:**
     - `tg_mr3_validar_producto_detalle_nuevo` (BEFORE INSERT, `V1 L1282`): valida que `PRODUCTO.activo` sea verdadero para el producto a insertar. Al ofrecerse un excedente de un producto activo, la inserción pasa sin restricción.
     - `tg_mr5_validar_detalle_cambio_producto` (BEFORE UPDATE OF `idProducto`, `V1 L1687`): solo se dispara ante modificaciones de la columna `idProducto`, por lo que no interviene durante la inserción.
     - Ningún otro trigger bloquea la inserción de una nueva fila en `DETALLE_PEDIDO`.
  2. **Restricciones CHECK y UNIQUE:**
     - `ck_detalle_pedido_3` (`V1 L189`):
       ```sql
       CHECK (("cantidadOriginal"=0 AND "precioUnitarioOriginal" IS NULL AND "porcentajePromocionOriginal"=0 AND "idPromocionAplicada" IS NULL) OR ("cantidadOriginal">0 AND "precioUnitarioOriginal" IS NOT NULL AND "precioUnitarioOriginal">0))
       ```
       El esquema relacional MR-5 **admite explícita y nativamente** filas con `cantidadOriginal = 0` y precio unitario nulo. Esta cláusula fue diseñada precisamente para registrar líneas complementarias sin precio base original.
     - `uq_detalle_pedido_0 UNIQUE ("idPedido", "idProducto")`:
       Exige que un mismo producto no se repita en más de una fila del pedido.
  3. **Inmutabilidad de `cantidadOriginal` y `totalOriginal`:**
     - La línea técnica se crea con `cantidadOriginal = 0.000`. No se altera la cantidad original de ningún producto ya ordenado.
     - `PEDIDO.totalOriginal` permanece inmutable. El valor contractual inicial del pedido no se modifica.
  4. **Impacto en consultas y servicios existentes:**
     - En `RegistrarPreparacionService.java` (`validarAcumulada` L98–110), el sistema verifica que la cantidad acumulada no supere `detalle.original()`. Al tener `cantidadOriginal == 0`, cualquier intento anómalo de enviar a cocina este producto fallaría de inmediato con `CANTIDAD_EXCEDE_ORIGINAL`. Esto garantiza por diseño que el producto reasignado **jamás sea preparado en cocina vía UC-28**.
     - En `BuscarPedidoService.java` (L69–75), el CTE de `preparables` filtra con la condición `d.cantidadOriginal > COALESCE(p.cantidadPreparada, 0)`. Las líneas técnicas con `cantidadOriginal = 0` son automáticamente ignoradas de la lista de preparables.
     - En consultas o reportes que proyecten `precioUnitarioOriginal`, debe asegurarse manejo de nulos (`COALESCE(precioUnitarioOriginal, 0)`), dado que la línea técnica posee valor nulo conforme al CHECK `ck_detalle_pedido_3`.
  5. **Reutilización de la línea técnica ante múltiples ofertas:**
     - Si para un mismo pedido se aceptan dos ofertas sucesivas del mismo producto excedente (por ejemplo, 2 kg de milanesas de cerdo en una oferta y luego 1 kg adicional en otra oferta), una segunda inserción en `DETALLE_PEDIDO` provocaría un error fatal por violación de la clave única `uq_detalle_pedido_0 UNIQUE ("idPedido", "idProducto")`.
     - **Regla técnica mandatoria:** Antes de insertar, el servicio debe ejecutar:
       ```sql
       SELECT "numeroDetalle" FROM "DETALLE_PEDIDO"
       WHERE "idPedido" = :idPedido AND "idProducto" = :idProducto;
       ```
       Si ya existe una línea (sea original o línea técnica previamente creada por otra oferta), **se reutiliza dicho `numeroDetalle`**.
     - La tabla `IMPUTACION_ENTREGA_ADICIONAL` posee como clave primaria `("idPedido", "numeroDetalle", "idMovimientoExcedente")` y restricción `UNIQUE ("idMovimientoExcedente")`. Por tanto, admite perfectamente múltiples imputaciones de excedentes asociadas al mismo `(idPedido, numeroDetalle)`.
  6. **Momento transaccional de creación de la línea:**
     - La fila técnica en `DETALLE_PEDIDO` se crea **exclusiva y estrictamente en `registrarRespuestaOfertaExcedente` (Parte B) cuando `aceptada == true`**, dentro del bloqueo transaccional (`PEDIDO FOR UPDATE`).
     - **Jamás se crea en `registrarOfertaExcedente` (Parte A)**. Mientras la oferta está en estado `PENDIENTE`, no existe ninguna fila técnica en `DETALLE_PEDIDO`. Si el cliente rechaza la oferta o la oferta expira, no queda residuo alguno en el pedido.
  7. **Compatibilidad con `UC-05` (Registrar Entrega):**
     - La tabla `DETALLE_ENTREGA` exige FK `(idPedido, numeroDetalle)` referenciando a `DETALLE_PEDIDO`. Al existir la línea técnica, el repartidor puede registrar la entrega física del producto excedente.
     - La restricción `ck_detalle_entrega_0 CHECK ("cantidadEntregada" >= 0)` no limita `cantidadEntregada` a `<= cantidadOriginal`, por lo que permite entregar la cantidad reasignada con total validez física y relacional.
* **Riesgo residual y elevación como decisión pendiente:**
  Aunque el esquema DDL admite la línea técnica mediante `ck_detalle_pedido_3`, la regla general `RD-012` declara que el pedido confirmado es inmutable *"salvo el incremento comercial de UC-07"*. Si el responsable considera que crear una línea técnica con `cantidadOriginal = 0` excede la excepción prevista en `RD-012`, debe optar por la **Alternativa D1-A**. Se eleva expresamente esta definición para ratificación.

#### Alternativa D1-C: Extender formalmente el modelo relacional (Descartada)
* **Mecanismo:** Desacoplar `IMPUTACION_ENTREGA_ADICIONAL` de `DETALLE_ENTREGA(idPedido, numeroDetalle)` mediante un cambio de FKs para que apunte solo a `ENTREGA(idPedido)` y a `PRODUCTO(idProducto)`.
* **Evaluación:** Requiere alterar DDL, generar una migración Flyway nueva y romper el congelamiento de MR-5 / MR-6.
* **Descarte:** **Descartada de plano** por violar las directivas de congelamiento de arquitectura B0/G0 y el alcance de este encargo.

---

### D2 — Tarificación Comercial de `importeInformado` e `importeAceptado`

El contrato canónico REV-04B (§5.2 y §6.2) exige la existencia de un `PrecioProducto` vigente pero no fija la fórmula. Se elimina toda ambigüedad matemática ("1 ± porcentajeAjuste/100") definiendo la implementación exacta en `BigDecimal` alineada con `AplicarAjusteComercialService.java` (L68–85).

#### 1. Obtención del precio base de catálogo:
Se obtiene el registro de `PRECIO_PRODUCTO` vigente a la fecha/hora de la transacción:
```sql
SELECT "precioBase" FROM "PRECIO_PRODUCTO"
WHERE "idProducto" = :idProducto
  AND "vigenteDesde" <= :ahora
  AND ("vigenteHasta" IS NULL OR "vigenteHasta" > :ahora);
```
Si no existe registro vigente, se dispara la excepción contractual **A2** (`PRECIO_PRODUCTO_NO_VIGENTE`).

#### 2. Cálculo del subtotal base:
```java
BigDecimal subtotalBase = cantidadOfrecida.multiply(precioBase).setScale(2, RoundingMode.HALF_UP);
```

#### 3. Fórmulas exactas según la categoría comercial congelada del pedido receptor:
El cálculo no reevalúa la categoría del cliente (prohibido por `RD-F04-007`); utiliza estrictamente las columnas `tipoAjuste` y `porcentajeAjuste` registradas en la cabecera de `PEDIDO`:

* **CASO SIN_AJUSTE:**
  ```java
  BigDecimal ajuste = BigDecimal.ZERO.setScale(2, RoundingMode.HALF_UP);
  BigDecimal importeInformado = subtotalBase;
  ```
* **CASO DESCUENTO:**
  ```java
  BigDecimal porcentaje = pedido.porcentajeAjuste(); // ej. 5.00
  BigDecimal ajuste = subtotalBase.multiply(porcentaje)
      .divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
  BigDecimal importeInformado = subtotalBase.subtract(ajuste);
  ```
* **CASO RECARGO:**
  ```java
  BigDecimal porcentaje = pedido.porcentajeAjuste(); // ej. 10.00
  BigDecimal ajuste = subtotalBase.multiply(porcentaje)
      .divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
  BigDecimal importeInformado = subtotalBase.add(ajuste);
  ```

#### 4. Diferenciación conceptual y contable de importes y costos:

| Concepto | Tabla / Destino | Naturaleza | Descripción |
|---|---|---|---|
| `importeInformado` | `OFERTA_EXCEDENTE.importeInformado` | Comercial (Oferta) | Monto total cotizado al momento de emitir la oferta sobre `cantidadOfrecida`. No genera compromiso financiero. |
| `importeAceptado` | `OFERTA_EXCEDENTE.importeAceptado` | Comercial (Acordado) | Monto total acordado con el cliente al momento de aceptar la oferta sobre `cantidadAceptada`. Base del futuro cobro. |
| `costoHistoricoSalida` | `MOVIMIENTO_EXCEDENTE.costoHistoricoSalida` | Valuación de Inventario | Costo real transferido del inventario de excedentes al pedido receptor. Es **completamente independiente** del precio comercial y se calcula mediante: `costoHistoricoDisponible.multiply(cantidadAceptada).divide(cantidadDisponible, 4, RoundingMode.HALF_UP).setScale(2, RoundingMode.HALF_UP)`. |
| `totalVigente` | Derivado en memoria / consultas | Comercial (Compromiso) | Monto proyectado total del pedido receptor (`totalOriginal + sum(importeAceptado)`). No existe columna física. |

---

### D3 — Aceptación Parcial (`cantidadAceptada < cantidadOfrecida`) y Preservación de Firma G0

#### 1. Preservación estricta de la firma canónica G0 (APROBADO):
La firma del contrato canónico en `CONTRATOS_REV04B_CORREGIDOS_B0_ACTUALIZADO.md §6.1` es taxativa e inmutable:
```
registrarRespuestaOfertaExcedente(idOfertaExcedente: Long, aceptada: Boolean, cantidadAceptada: BigDecimal[0..1])
```
**No se altera ni extiende la firma canónica agregando parámetros en este documento.**

#### 2. Protocolo en dos pasos (Cotización previa + Confirmación formal):
Para satisfacer la regla de negocio que exige que el cliente conozca y acepte el importe antes de confirmar, el sistema operará mediante un protocolo de dos pasos a nivel de interacción:
* **Paso 1 (Cotización / Consulta de importe proporcional):**
  Cuando el cliente indica que desea aceptar una cantidad parcial (`cantidadAceptada < cantidadOfrecida`), el frontend o canal comercial consulta/calcula el nuevo importe esperado:
  $$\text{importeRecalculado} = \text{round}_{\text{HALF\_UP}}\left(\frac{\text{importeInformado}}{\text{cantidadOfrecida}} \times \text{cantidadAceptada}, 2\right)$$
  Este importe es presentado explícitamente al cliente para su expresa conformidad.
* **Paso 2 (Confirmación):**
  Una vez obtenida la conformidad del cliente, se invoca la operación canónica `registrarRespuestaOfertaExcedente(idOfertaExcedente, true, cantidadAceptada)`.
  El servidor recalcula internamente el `importeAceptado` aplicando la misma fórmula matemática exacta y lo almacena en `OFERTA_EXCEDENTE.importeAceptado`.

#### 3. Documentación del GAP Contractual G0:
Existe un desfasaje formal en el contrato canónico de G0:
* **En el texto de Notas (§6.5):** Se declara textualmente: *"Si cantidadAceptada < cantidadOfrecida, se recalcula el importe proporcionalmente y se exige aceptación del nuevo importe antes de confirmar."*
* **En la tabla de Excepciones (§6.6):** Se define la excepción **A2**: *"IMPORTE_RECALCULADO_NO_ACEPTADO: Cuando cantidadAceptada < cantidadOfrecida y el cliente no confirma el nuevo importe."*
* **En la firma de la Operación (§6.1):** Solo se reciben los 3 parámetros indicados (`idOfertaExcedente`, `aceptada`, `cantidadAceptada`). No existe un campo para transmitir la confirmación del importe ni el importe esperado por el cliente.

#### 4. Registro de Solicitud de Cambio Contractual (CR contractual) PENDIENTE:
Para resolver este desfasaje de forma ordenada y trazable según el gobierno UP, se registra formalmente la siguiente propuesta de cambio:

> **Solicitud de Cambio Contractual:** `CR-B0-UC07-001`<br>
> **Objeto:** Mecanismo de acreditación de conformidad de importe en `registrarRespuestaOfertaExcedente`.<br>
> **Alternativa CR-A (Extensión de firma):** Modificar el contrato canónico para incorporar el parámetro `importeAceptadoCliente: BigDecimal`. El servidor rechaza con `IMPORTE_RECALCULADO_NO_ACEPTADO` si el valor difiere del recálculo.<br>
> **Alternativa CR-B (Protocolo de aplicación sin cambio de firma):** Mantener la firma de 3 parámetros inalterada. El recálculo se realiza en backend y la conformidad del cliente se audita a través del registro de sesión del vendedor. La excepción A2 se reserva para el flujo interactivo UI/frontend previo al envío de la confirmación.<br>
> **Estado:** **PENDIENTE DE AUTORIZACIÓN POR EL RESPONSABLE.** Hasta que el responsable decida, se mantiene la firma canónica de 3 parámetros conforme a G0.

#### 5. Justificación: Por qué el recálculo matemático no sustituye la conformidad del cliente
El recálculo aritmético en servidor garantiza precisión contable y evita errores de cómputo, pero **no acredita consentimiento legal ni comercial**. En caso de redondeos de centavos o desacuerdos comerciales, una imputación unilateral sin confirmación expresa del cliente expone al vendedor a disputas y rechazos al momento de la entrega en puerta. Por ello, la confirmación humana debe preceder a la invocación del servicio.

---

### D4 — Total Vigente y Consistencia con la Entrega (UC-05)

Se establece una delimitación rigurosa en cinco niveles conceptuales y contables:

```
[1. totalOriginal] (Inmutable en PEDIDO.totalOriginal)
         +
[2. incrementosComercialesAceptados] (Suma de OFERTA_EXCEDENTE.importeAceptado con respuesta = 'ACEPTADA')
         =
[3. totalVigente] (Derivado dinámicamente en memoria / consultas. NO es columna física)
         |
         v (Momento de la Entrega en UC-05)
[4. importeEfectivamenteEntregado] (Suma física en DETALLE_ENTREGA + IMPUTACION_ENTREGA_ADICIONAL)
         |
         v (Generación contable exclusiva de UC-05)
[5. cargoContableCorrespondiente] (Débito CARGO_POR_VENTA en MOVIMIENTO_CUENTA sobre importeEfectivamenteEntregado)
```

#### Reglas de comportamiento ante contingencias en la entrega (`UC-05`):

1. **La cantidad entregada difiere de la cantidad aceptada (Entrega parcial del excedente):**
   * *Ejemplo:* Se aceptaron 3.0 kg de excedente, pero en el reparto solo se pudieron entregar 2.0 kg al cliente.
   * *Acción en `UC-05`:*
     - `IMPUTACION_ENTREGA_ADICIONAL.cantidadImputada` se registra con el valor real entregado (`2.000`).
     - `DETALLE_ENTREGA.cantidadEntregada` se asienta en `2.000`.
     - El `CARGO_POR_VENTA` en `MOVIMIENTO_CUENTA` se calcula y devenga **únicamente sobre los 2.0 kg efectivamente entregados**.
     - El remanente no entregado (1.0 kg) se reintegra al inventario físico mediante la creación en `UC-05` de un nuevo registro en `EXCEDENTE` con `origenGeneracion = 'ENTREGA'`, reasignándole el costo histórico proporcional correspondiente.
2. **Se cancela la entrega del pedido receptor:**
   * Si el reparto se frustra o el pedido receptor es cancelado antes o durante el reparto (`UC-06` o fallo en `UC-05`):
     - No se genera débito (`CARGO_POR_VENTA`) en `MOVIMIENTO_CUENTA`.
     - Las unidades de excedente que habían sido comprometidas se reingresan al stock mediante un nuevo registro o movimiento de reversión en `EXCEDENTE`.
     - El registro de `OFERTA_EXCEDENTE` se mantiene con valor histórico de auditoría, pero no tiene impacto financiero alguno.
3. **Entrega parcial de productos base vs excedente:**
   * Cada línea de entrega opera de forma desacoplada: si se entregan los productos base pero no el excedente, o viceversa, `UC-05` liquida exactamente las cantidades presentes en `DETALLE_ENTREGA` e `IMPUTACION_ENTREGA_ADICIONAL`.

---

### D5 — Estrategia de Concurrencia y Orden de Locks

> [!IMPORTANT]
> **PROPUESTA TÉCNICA (NO VALIDADA HASTA PRUEBAS REALES):** La siguiente secuencia de bloqueos y primitivas transaccionales constituye una propuesta de diseño basada en el análisis relacional estático. **No se considerará probada ni certificada hasta su validación empírica mediante pruebas automatizadas de concurrencia con Testcontainers y PostgreSQL real en el repositorio de aplicación.**

```
+---------------------------------------------------------------------------------------------------+
|                        SECUENCIA DE LOCKS PROPUESTA PARA UC-07 (Parte B)                          |
+---------------------------------------------------------------------------------------------------+
|                                                                                                   |
|  [ registrarRespuestaOfertaExcedente (Parte B - Aceptación) ]                                     |
|                                                                                                   |
|    1. pg_advisory_xact_lock(7007002)                                                              |
|       (Serializa operaciones concurrentes sobre el subsistema de excedentes)                      |
|                                                                                                   |
|    2. SELECT "cantidadDisponible", "costoHistoricoDisponible"                                     |
|       FROM "EXCEDENTE" WHERE "idExcedente" = :id FOR UPDATE;                                      |
|       (Bloqueo pesimista del lote físico. Garantiza inventario)                                   |
|                                                                                                   |
|    3. SELECT * FROM "OFERTA_EXCEDENTE"                                                            |
|       WHERE "idOfertaExcedente" = :id FOR UPDATE;                                                 |
|       (Bloqueo pesimista de la oferta. Evita dobles respuestas)                                   |
|                                                                                                   |
|    4. SELECT "estado" FROM "PEDIDO"                                                               |
|       WHERE "idPedido" = :id FOR UPDATE;                                                          |
|       (Bloqueo pesimista del receptor. Serializa con cancelación y reparto)                       |
|                                                                                                   |
|    5. Ejecución de escrituras atómicas en la misma transacción:                                   |
|       - UPDATE OFERTA_EXCEDENTE SET respuesta = 'ACEPTADA', ...                                   |
|       - INSERT INTO MOVIMIENTO_EXCEDENTE (tipo = 'REASIGNACION', ...)                             |
|       - UPDATE EXCEDENTE SET cantidadDisponible = ..., costoHistoricoDisponible = ...             |
|       - (Si aplica D1-B): INSERT o reutilización en DETALLE_PEDIDO                                |
|                                                                                                   |
+---------------------------------------------------------------------------------------------------+
```

#### Análisis de riesgos de bloqueo mutuo (*Deadlock*):

1. **`registrarOfertaExcedente` (Parte A) vs `registrarRespuestaOfertaExcedente` (Parte B):**
   * En Parte A (`registrarOfertaExcedente`), solo se crea la oferta (`PENDIENTE`). Para verificar disponibilidad y estado, las lecturas sobre `EXCEDENTE` y `PEDIDO` se realizan mediante lecturas transaccionales estándar (o `FOR SHARE`).
   * En Parte B, se toman locks exclusivos `FOR UPDATE`.
   * **Prevención de deadlock:** Ambas operaciones deben consultar las entidades en el **mismo orden estricto: primero `EXCEDENTE`, luego `PEDIDO`**. Al respetar el mismo ordenamiento de adquisición de recursos, el motor relacional encola las transacciones competidoras sin generar ciclos de espera.
2. **`registrarRespuestaOfertaExcedente` vs `UC-41` (Registrar Descarte de Excedente):**
   * Tanto la reasignación como el descarte compiten por el saldo disponible del lote físico en `EXCEDENTE`.
   * Ambos servicios adquieren `SELECT ... FROM "EXCEDENTE" WHERE "idExcedente" = :id FOR UPDATE` como primer recurso.
   * La primera transacción que obtiene el lock pesimista evalúa y decrementa el stock; la segunda espera la liberación del lock y, al despertar, evalúa el remanente actualizado. Si el stock no alcanza, rechaza de forma limpia con excepción de disponibilidad. **Riesgo de deadlock nulo.**
3. **`registrarRespuestaOfertaExcedente` vs `UC-05` (Registrar Entrega):**
   * `UC-05` adquiere `PEDIDO ... FOR UPDATE`. Si durante la entrega `UC-05` necesitara bloquear `EXCEDENTE` (por ejemplo, para reintegrar excedentes no entregados) en un orden inverso al de `UC-07` (`EXCEDENTE` $\rightarrow$ `PEDIDO`), se produciría un **deadlock clásico**.
   * **Regla arquitectónica obligatoria:** Se establece una **jerarquía global e invariable de adquisición de bloqueos** en todo el sistema:
     $$\text{Advisory Lock} \longrightarrow \text{EXCEDENTE} \longrightarrow \text{OFERTA\_EXCEDENTE} \longrightarrow \text{PEDIDO} \longrightarrow \text{ENTREGA} \longrightarrow \text{MOVIMIENTO\_CUENTA}$$
     Cualquier servicio que requiera bloquear conjuntamente `EXCEDENTE` y `PEDIDO` debe adquirir indefectiblemente el lock sobre `EXCEDENTE` en primer término. En `UC-05`, la creación del nuevo excedente devuelto se realiza mediante inserción nueva (`INSERT INTO EXCEDENTE`), la cual no bloquea registros preexistentes ni invierte la jerarquía.

#### Supuestos que requieren validación empírica con Testcontainers:
* Efectividad y granularidad del espacio de números de `pg_advisory_xact_lock` (aislamiento frente a transacciones de testing paralelas).
* Comportamiento del nivel de aislamiento `READ COMMITTED` estándar de PostgreSQL frente a inserciones concurrentes de la línea técnica en `DETALLE_PEDIDO` (confirmar que la verificación de existencia previa con bloqueo de cabecera previene efectivamente colisiones en `uq_detalle_pedido_0`).
* Prueba de estrés de saturación concurrente simulando múltiples hilos compitiendo simultáneamente entre `UC-07`, `UC-41` y `UC-05`.

---

## 5. Recomendación argumentada para el responsable

Se elevan las siguientes recomendaciones de ingeniería para su resolución por Victor Leandro Machado:

1. **En D1 (Compatibilidad del pedido receptor):**
   * **Recomendación prioritaria (Comercial):** Ratificar la **Alternativa D1-B** (línea técnica con `cantidadOriginal = 0`), ratificando formalmente que `ck_detalle_pedido_3` provee el respaldo relacional nativo y que dicha inserción se encuentra amparada por la cláusula de incremento comercial de `RD-012`.
   * **Alternativa de repliegue (Conservadora):** Si se desea restringir estrictamente el ofrecimiento a productos ya presentes en el pedido para no tocar `DETALLE_PEDIDO`, ratificar **Alternativa D1-A**.
2. **En D2 (Tarificación comercial):**
   * Ratificar la fórmula matemática exacta en `BigDecimal` con `RoundingMode.HALF_UP` a 2 decimales, basada en el `precioBase` de catálogo ajustado por el `tipoAjuste` y `porcentajeAjuste` del pedido receptor, garantizando plena consistencia con `AplicarAjusteComercialService`.
3. **En D3 (Aceptación parcial y firma G0):**
   * Preservar estrictamente la firma canónica de 3 parámetros de G0.
   * Adoptar el **Protocolo en dos pasos** a nivel de interfaz / proceso comercial para asegurar el consentimiento previo del cliente.
   * Evaluar la Solicitud de Cambio Contractual `CR-B0-UC07-001` (Alternativa CR-A vs CR-B).
4. **En D4 (Total vigente y consistencia con la entrega):**
   * Ratificar la separación de los 5 niveles conceptuales, reservando la generación del débito en cuenta corriente exclusivamente al momento de la entrega física en `UC-05`.
5. **En D5 (Concurrencia y orden de locks):**
   * Aprobar la jerarquía de bloqueos propuesta (`EXCEDENTE` $\rightarrow$ `OFERTA_EXCEDENTE` $\rightarrow$ `PEDIDO`) sujeta a validación empírica con Testcontainers en B3/B4.

---

## 6. Riesgos arquitectónicos y mitigaciones

| ID | Riesgo | Severidad | Mitigación Propuesta |
|---|---|---|---|
| **R-UC07-01** | Incompatibilidad de FK en entrega (`IMPUTACION_ENTREGA_ADICIONAL`) si se acepta un producto ausente en el pedido receptor. | **ALTA** | Ratificar formalmente D1-B (línea técnica con `cantidadOriginal = 0`) o D1-A antes de iniciar la codificación. |
| **R-UC07-02** | Colisión en clave única `uq_detalle_pedido_0` ante múltiples ofertas aceptadas del mismo producto. | **ALTA** | Implementar la verificación y reutilización obligatoria del `numeroDetalle` existente antes de intentar una nueva inserción. |
| **R-UC07-03** | Discrepancias de redondeo entre frontend y backend en la aceptación parcial. | **MEDIA** | Estandarizar el cálculo exacto en `BigDecimal` con escala 2 y redondeo `HALF_UP`. |
| **R-UC07-04** | Carrera concurrente entre reasignación (`UC-07`) y descarte (`UC-41`). | **ALTA** | Bloqueo pesimista unificado `EXCEDENTE ... FOR UPDATE` como primer paso transaccional en ambos servicios. |
| **R-UC07-05** | Potencial deadlock entre `UC-07` y `UC-05` al competir por pedidos y excedentes. | **ALTA** | Respetar rigurosamente la jerarquía global de locks (`EXCEDENTE` antes de `PEDIDO`). |
| **R-UC07-06** | Consulta de pedidos asume que `precioUnitarioOriginal` nunca es nulo, arrojando NPE. | **MEDIA** | Auditoría y sanitización de consultas en `BuscarPedidoService` incorporando manejo defensivo de nulos. |

---

## 7. Impacto transversal en UC-05 (Entrega) y UC-41 (Descarte)

1. **Impacto en `UC-05` (Registrar Entrega):**
   * `UC-05` no puede cerrar la liquidación sin procesar las ofertas aceptadas que hayan imputado excedentes.
   * `UC-05` lee `MOVIMIENTO_EXCEDENTE` e inserta en `IMPUTACION_ENTREGA_ADICIONAL`.
   * El cálculo del débito definitivo (`CARGO_POR_VENTA`) en Cuenta Corriente consolida exclusivamente lo efectivamente entregado. Las diferencias por entrega parcial dan origen a un nuevo excedente en inventario.
2. **Impacto en `UC-41` (Registrar Descarte):**
   * `UC-41` compite por el mismo lote en `EXCEDENTE`. La disminución de disponibilidad por reasignación en `UC-07` reduce inmediatamente la cantidad descartable en `UC-41` y viceversa.
   * Ambos casos de uso comparten la misma tabla histórica: `MOVIMIENTO_EXCEDENTE`.

---

## 8. Dependencias de contratos y modelo relacional

* **Contratos G0:**
  * No se altera la firma ni las 9 secciones de los contratos canónicos de `REV-04B`.
  * Se registra la solicitud de cambio contractual `CR-B0-UC07-001` como PENDIENTE para resolver el mecanismo de confirmación de importe.
* **Modelo Relacional MR-5 / MR-6:**
  * **Cero cambios de DDL.** Se preservan íntegras las 62 tablas y sus restricciones vigentes.
  * El diseño propuesto se apoya estrictamente en las estructuras existentes: `EXCEDENTE`, `OFERTA_EXCEDENTE`, `MOVIMIENTO_EXCEDENTE`, `IMPUTACION_ENTREGA_ADICIONAL`, `PEDIDO`, `DETALLE_PEDIDO`, `PRECIO_PRODUCTO`.

---

## 9. Pruebas de aceptación propuestas (NO EJECUTADAS)

Las siguientes pruebas automatizadas deberán implementarse en `ale-milanesas-app` durante la construcción de B3/B4:

| Código | Escenario | Resultado Esperado |
|---|---|---|
| **T-U07-01** | Registro de oferta sobre excedente con disponibilidad suficiente. | `201 Created`. `OFERTA_EXCEDENTE` en `PENDIENTE`. `EXCEDENTE.cantidadDisponible` intacta. |
| **T-U07-02** | Registro de oferta con `cantidadOfrecida > cantidadDisponible`. | `400 / 409 Conflict` (Excepción A1). Cero escrituras. |
| **T-U07-03** | Registro de oferta sobre pedido no `PENDIENTE`. | `409 Conflict` (Excepción A2). |
| **T-U07-04** | Aceptación total de oferta (`cantidadAceptada == cantidadOfrecida`). | `200 OK`. `OFERTA_EXCEDENTE` en `ACEPTADA`, se crea `MOVIMIENTO_EXCEDENTE` `REASIGNACION`, `cantidadDisponible` decrementada. |
| **T-U07-05** | Rechazo de oferta por el cliente. | `200 OK`. `OFERTA_EXCEDENTE` en `RECHAZADA`. Excedente y pedido intactos. |
| **T-U07-06** | Aceptación parcial calculando importe proporcional en `BigDecimal`. | `200 OK`. Se descuenta solo la cantidad aceptada y se transfiere costo proporcional exacto. |
| **T-U07-07** | Aceptación de producto no presente en el pedido (bajo D1-B). | `200 OK`. Se crea línea técnica en `DETALLE_PEDIDO` con `cantidadOriginal = 0` y precio nulo. |
| **T-U07-08** | Segunda aceptación de oferta para el mismo producto en el mismo pedido (bajo D1-B). | `200 OK`. Se reutiliza el `numeroDetalle` existente sin violar `uq_detalle_pedido_0`. |
| **T-U07-09** | Dos aceptaciones concurrentes sobre el mismo excedente cuyo saldo conjunto supera el disponible. | Una transacción tiene éxito; la segunda falla con `409 Conflict` por disponibilidad insuficiente. Sin sobreasignación. |
| **T-U07-10** | Aceptación concurrente frente a descarte en `UC-41`. | Se serializan por lock pesimista; saldo consistente y sin saldos negativos. |
| **T-U07-11** | Intento de ejecución de `UC-07` por usuarios con rol `ADMINISTRADOR`, `REPARTIDOR` o `PRODUCCION`. | `403 Forbidden` (RBAC estricto, exclusivo `VENDEDOR`). |

---

## 10. Decisiones pendientes para el responsable

Se elevan formalmente al responsable del proyecto (Victor Leandro Machado) las siguientes definiciones:

1. **Decisión D1 (Compatibilidad de Pedido):** ¿Se aprueba formalmente la **Alternativa D1-B** (línea técnica con `cantidadOriginal = 0` bajo `ck_detalle_pedido_3` y reutilización de `numeroDetalle`), o se adopta la **Alternativa D1-A** (restringir ofertas exclusivamente a productos ya presentes en el pedido)?
2. **Decisión D2 (Tarificación Comercial):** ¿Se ratifica la fórmula estandarizada en `BigDecimal` basada en el precio de catálogo vigente ajustado por el recargo/descuento comercial del pedido receptor?
3. **Decisión D3 (GAP Contractual y Solicitud CR-B0-UC07-001):** ¿Se aprueba el **Protocolo en dos pasos** para la aceptación parcial manteniendo la firma canónica de 3 parámetros (Alternativa CR-B), o se solicita una enmienda formal al contrato G0 para incorporar el importe en la firma (Alternativa CR-A)?
4. **Decisión D4 (División de RDs de I3-02):** ¿Se ratifica mantener esta propuesta (`RD-UC07-001`) independiente de `RD-I302-001` (centrada en `UC-05` / F04)?
5. **Decisión D5 (Concurrencia):** ¿Se avala la jerarquía de locks propuesta (`EXCEDENTE` $\rightarrow$ `OFERTA_EXCEDENTE` $\rightarrow$ `PEDIDO`) como base para las pruebas de integración con Testcontainers en B3?

---

## 11. Condiciones previas para implementar UC-07 en B3

1. Ratificación expresa de esta RD por parte de Victor Leandro Machado.
2. Resolución explícita de las Decisiones Pendientes (especialmente D1 y D3).
3. Aprobación y merge del PR documental en `leandrito369/ale-milanesas`.
4. Creación del diseño operacional detallado en `leandrito369/ale-milanesas-app` respetando los locks y algoritmos validados.

---

## 12. Restricciones de despliegue

* **El entorno de despliegue permanece en estado PAUSADO.**
* La **Issue #28** de `leandrito369/ale-milanesas-app` continúa **ABIERTA**.
* La aprobación o tramitación de esta propuesta documental no autoriza el levantamiento de la pausa ni la activación de servicios en producción.
