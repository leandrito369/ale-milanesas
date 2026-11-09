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

La auditoría técnica previa constató que el modelo relacional MR-5 (`V1__baseline_mr5.sql`) ya cuenta con las tablas `EXCEDENTE`, `OFERTA_EXCEDENTE`, `MOVIMIENTO_EXCEDENTE` e `IMPUTACION_ENTREGA_ADICIONAL`. Sin embargo, existen **vacíos de diseño y contradicciones latentes** que bloquean la implementación:

1. **Compatibilidad relacional del Pedido receptor:** La tabla `IMPUTACION_ENTREGA_ADICIONAL` (donde se asientan las unidades de excedente entregadas) exige una FK hacia `DETALLE_ENTREGA(idPedido, numeroDetalle)`, que a su vez exige FK obligatoria hacia `DETALLE_PEDIDO(idPedido, numeroDetalle)`. Si un pedido receptor no solicitó originalmente el producto excedente, la entrega física colisiona con las FKs salvo que se defina un mecanismo explícito.
2. **Vacío en la tarificación de `importeInformado` e `importeAceptado`:** El contrato canónico exige la existencia de un `PrecioProducto` vigente para calcular el importe, pero la fórmula matemática (precio base puro vs precio con recargo/descuento de cliente vs precio de liquidación) no está normada.
3. **Mecanismo de aceptación parcial:** Cuando el cliente acepta una cantidad menor a la ofrecida, el contrato exige recalcular el importe y registrar una nueva aceptación antes de transferir unidades.
4. **Ausencia de código en la aplicación:** En `ale-milanesas-app`, no existe ningún servicio, repositorio ni controlador para `UC-07` ni `EXCEDENTE` (0% implementado).

---

## 2. Fuentes canónicas y SHAs verificados

SHAs efectivos consultados el 09/11/2026 antes de iniciar la redacción:
* **Gobierno (`leandrito369/ale-milanesas`):** `origin/main` en [`d848f73`](https://github.com/leandrito369/ale-milanesas/commit/d848f73).
* **Implementación (`leandrito369/ale-milanesas-app`):** `origin/main` en [`d5f7607`](https://github.com/leandrito369/ale-milanesas-app/commit/d5f7607).

### Fuentes consultadas:
* [Plan Rector de Implementación](../PLAN_RECTOR_IMPLEMENTACION_2026-10-29.md) y [Backlog priorizado G0](B0_BACKLOG_PRIORIZADO_Y_GATE_G0_2026-10-29.md).
* [Contratos canónicos REV-04B](../../08-diagramas/consolidacion-b0/CONTRATOS_REV04B_CORREGIDOS_B0_ACTUALIZADO.md): §1 `UC-28`, §2 `UC-05`, §4 `UC-61`, §5 `UC-07 Parte A`, §6 `UC-07 Parte B`, §7 `UC-41`, §8 Glosario.
* [Matriz RBAC de cierre](B0_MATRIZ_RBAC_67_OPERACIONES_CIERRE_2026-10-29.csv) L9–10 (`UC-07` exclusivo `VENDEDOR=D`).
* [RD-012](../RD_01_REGISTRO_DECISIONES_v1.1_2026-10-25.md#L30) (inmutabilidad de pedidos confirmados).
* Decisiones [A2](../RD_01_REGISTRO_DECISIONES_v1.1_2026-10-25.md#L48), [A23](../RD_01_REGISTRO_DECISIONES_v1.1_2026-10-25.md#L90) y requerimiento [RF-13](../../03-requisitos/historico-2026-10-23/A_REQUISITOS.md#L2030).
* [RD-RP022-001](../RD_RP022_001_COSTEO_CONVERSIONES_REDONDEOS_2026-10-27.md) (costeo histórico, precisión decimal y redondeos).
* Esquema DDL en `ale-milanesas-app`: `V1__baseline_mr5.sql` (tablas `PEDIDO` L138, `DETALLE_PEDIDO` L174, `ENTREGA` L205, `DETALLE_ENTREGA` L212, `EXCEDENTE` L222, `OFERTA_EXCEDENTE` L243, `MOVIMIENTO_EXCEDENTE` L263, `IMPUTACION_ENTREGA_ADICIONAL` L280, `PRECIO_PRODUCTO` L292; FKs L911–923).

---

## 3. Alcance y decisiones funcionales ya aprobadas (APROBADO)

Las siguientes reglas se encuentran formalmente ratificadas y constituyen invariantes obligatorias:

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

## 4. Alternativas analizadas

### D1 — Compatibilidad del Pedido Receptor (Alcance de Productos Reasignables)

El contrato canónico señala que el pedido receptor debe ser un *"candidato en estado PENDIENTE"*, mientras que requisitos previos mencionan *"Pedidos compatibles"*. Se evalúan tres alternativas técnicas y comerciales:

#### Alternativa D1-A: Permitir únicamente productos preexistentes en el pedido receptor
* **Mecanismo:** El sistema valida que el `idProducto` del `EXCEDENTE` coincida con el `idProducto` de al menos una línea en `DETALLE_PEDIDO` del pedido receptor.
* **Reglas de negocio afectadas:** Restringe el ofrecimiento de excedentes: un cliente solo puede recibir ofertas de productos que ya haya ordenado. Si sobran milanesas de pollo y un cliente solo ordenó milanesas de carne, no puede ofrecérsele el excedente.
* **Compatibilidad con G0 y RD-012:** Máxima (100%). No se insertan ni modifican líneas en `DETALLE_PEDIDO`. Respeta taxativamente la prohibición de modificar pedidos confirmados (`RD-012`).
* **Cambios de esquema:** Cero.
* **Riesgos de integridad:** Nulos. En `UC-05`, `IMPUTACION_ENTREGA_ADICIONAL` se asocia al `(idPedido, numeroDetalle)` ya existente en `DETALLE_ENTREGA` y `DETALLE_PEDIDO`.
* **Impacto en UC-05:** Directo y sin fricción. La línea ya existe.

#### Alternativa D1-B: Permitir productos adicionales mediante líneas técnicas con `cantidadOriginal = 0`
* **Mecanismo:** Si el producto no estaba en el pedido, al confirmarse la aceptación (`UC-07 Parte B`) se inserta una fila en `DETALLE_PEDIDO` con:
  `numeroDetalle = COALESCE(MAX(numeroDetalle), 0) + 1`, `cantidadOriginal = 0`, `precioUnitarioOriginal = NULL`, `porcentajePromocionOriginal = 0`, `idPromocionAplicada = NULL`.
* **Reglas de negocio afectadas:** Amplía la capacidad comercial: el vendedor puede ofrecer cualquier producto en excedente a cualquier pedido `PENDIENTE`.
* **Compatibilidad con G0 y RD-012:**
  * **Soporte físico:** El CHECK de MR-5 `ck_detalle_pedido_3` (`V1 L189`) **admite explícitamente** `("cantidadOriginal"=0 AND "precioUnitarioOriginal" IS NULL AND "porcentajePromocionOriginal"=0 AND "idPromocionAplicada" IS NULL)`.
  * **Tensión normativa:** `RD-012` prohíbe la modificación general del pedido confirmado, salvo para *"el incremento comercial de UC-07"*. Si se interpreta que insertar una línea técnica con cantidad original cero es parte del incremento comercial previsto, encaja; pero si se considera que altera la instantánea de carga de `UC-03`, requeriría una adenda a `RD-012`.
* **Cambios de esquema:** Cero.
* **Riesgos de integridad:** Medio.
  1. Si dos ofertas de excedente del mismo producto se aceptaran para el mismo pedido, la segunda inserción violaría `uq_detalle_pedido_0 UNIQUE ("idPedido", "idProducto")`. Se debe reusar la línea técnica ya creada.
  2. Si `CargarPedidoService` o `BuscarPedidoService` asumen que `precioUnitarioOriginal` nunca es nulo, podrían arrojar `NullPointerException` (debe verificarse la robustez del código de consulta).
* **Impacto en UC-05:** Permite que `DETALLE_ENTREGA` se enlace con FK válida a `DETALLE_PEDIDO`, reflejando la entrega del producto adicional.

#### Alternativa D1-C: Extender formalmente el modelo relacional
* **Mecanismo:** Desacoplar `IMPUTACION_ENTREGA_ADICIONAL` de `DETALLE_ENTREGA(idPedido, numeroDetalle)` mediante un cambio de FKs para que apunte solo a `ENTREGA(idPedido)` y a `PRODUCTO(idProducto)`.
* **Evaluación:** Requiere alterar DDL, generar una migración Flyway nueva y romper el congelamiento de MR-5 / MR-6.
* **Descarte:** **Descartada de plano** por violar las directivas de congelamiento de arquitectura B0/G0 y el alcance de este encargo.

---

### D2 — Tarificación Comercial de `importeInformado` e `importeAceptado`

El contrato exige contar con un `PrecioProducto` vigente pero no fija la fórmula. Se evalúan cuatro alternativas:

1. **Precio base vigente puro:**
   $$\text{importe} = \text{cantidad} \times \text{PRECIO\_PRODUCTO.precioBase}$$
   *Desventaja:* Ignora si el cliente es `CUMPLIDOR` (descuento) o `EN_MORA` (recargo), cobrándole una tarifa no alineada a su cuenta.
2. **Precio histórico del pedido receptor:**
   $$\text{importe} = \text{cantidad} \times \text{DETALLE\_PEDIDO.precioUnitarioOriginal}$$
   *Desventaja:* Inviable si el producto es nuevo en el pedido (Alternativa D1-B). Además, si hubo una actualización de precios posterior a la carga del pedido, se estaría vendiendo a precio desactualizado.
3. **Precio vigente ajustado por la política comercial del pedido receptor (RECOMENDADA):**
   El servidor toma el `precioBase` de `PRECIO_PRODUCTO` vigente al momento de la oferta (`vigenteDesde <= ahora < vigenteHasta`) y le aplica el ajuste comercial que ya quedó congelado en la cabecera del pedido receptor (`PEDIDO.tipoAjuste` y `PEDIDO.porcentajeAjuste`):
   $$\text{precioUnitarioEfectivo} = \text{precioBase} \times \left(1 \pm \frac{\text{porcentajeAjuste}}{100}\right)$$
   $$\text{importeInformado} = \text{round}_{\text{HALF\_UP}}(\text{cantidadOfrecida} \times \text{precioUnitarioEfectivo}, 2)$$
   *Ventaja:* Totalmente armónico con `RF-13`, no reevalúa categoría comercial (prohibido por `RD-F04-007` y contrato §6.2) y respeta las condiciones acordadas para el cliente en ese pedido.
4. **Precio especial de liquidación (descuento discrecional):**
   *Desventaja:* No tiene respaldo documental en G0. Introduciría discrecionalidad no auditada en el vendedor. **Descartada.**

---

### D3 — Aceptación Parcial (`cantidadAceptada < cantidadOfrecida`)

El contrato canónico (§6.5 y excepción A2) exige que ante un cambio de cantidad, se recalcule el importe y se cuente con la aceptación del nuevo importe.

#### Propuesta técnica de verificación:
* El payload de `registrarRespuestaOfertaExcedente` debe exigir obligatoriamente:
  ```json
  {
    "idOfertaExcedente": 1234,
    "aceptada": true,
    "cantidadAceptada": 2.500,
    "importeAceptado": 12500.00
  }
  ```
* **Validación matemática en servidor:**
  1. Si `cantidadAceptada == cantidadOfrecida`, el servidor verifica que `importeAceptado == importeInformado`.
  2. Si `cantidadAceptada < cantidadOfrecida`, el servidor calcula:
     $$\text{importeEsperado} = \text{round}_{\text{HALF\_UP}}\left(\frac{\text{importeInformado}}{\text{cantidadOfrecida}} \times \text{cantidadAceptada}, 2\right)$$
  3. Si el `importeAceptado` enviado por el cliente difiere de `importeEsperado`, el servidor **rechaza atómicamente la solicitud** con error `409 Conflict` (Excepción A2: `IMPORTE_RECALCULADO_NO_ACEPTADO`).
* Esto impide que el vendedor confirme unilateralmente un valor arbitrario o que se produzcan discrepancias de redondeo entre el frontend y el backend.

---

### D4 — Derivación de `totalVigente` e Integridad con la Entrega

1. **Derivación contable:**
   No existe columna física `totalVigente` en `PEDIDO`. Se calcula en las consultas (`BuscarPedidoService`, reportes) mediante:
   $$\text{totalVigente} = \text{PEDIDO.totalOriginal} + \sum_{\substack{\text{OFERTA\_EXCEDENTE} \\ \text{respuesta='ACEPTADA'}}} \text{importeAceptado}$$
2. **Consistencia con la Entrega (`UC-05`):**
   * Una oferta aceptada en `UC-07` es un compromiso comercial de asignación, pero **no devenga deuda contable inmediatamente**.
   * El débito definitivo en Cuenta Corriente (`CARGO_POR_VENTA`) se genera recién en `UC-05` al registrar la entrega real.
   * Si al momento del reparto el cliente finalmente recibe menos unidades de las reasignadas, la tabla `IMPUTACION_ENTREGA_ADICIONAL` registra la cantidad efectivamente entregada, cobrándose solo esa fracción. El remanente no entregado vuelve a convertirse en un nuevo `EXCEDENTE` en `UC-05` (`origenGeneracion = 'ENTREGA'`).

---

### D5 — Estrategia de Concurrencia y Orden de Locks

Para garantizar que múltiples vendedores o procesos concurrentes no sobreasignen un excedente ni provoquen bloqueos mutuos (*deadlocks*), se define la siguiente estrategia:

```
+---------------------------------------------------------------------------------------------------+
|                            FLUJO TRANSACCIONAL Y LOCKS EN UC-07                                   |
+---------------------------------------------------------------------------------------------------+
|                                                                                                   |
|  [ registrarOfertaExcedente (Parte A) ]                                                           |
|    1. Validar sesión (rol VENDEDOR).                                                              |
|    2. Lock advisory de espacio de ofertas: pg_advisory_xact_lock(7007001).                        |
|    3. SELECT ... FROM "EXCEDENTE" WHERE idExcedente = :id FOR SHARE (Verifica disponibilidad).    |
|    4. SELECT ... FROM "PEDIDO" WHERE idPedido = :id FOR SHARE (Verifica estado PENDIENTE).        |
|    5. INSERT INTO "OFERTA_EXCEDENTE" (respuesta = 'PENDIENTE').                                   |
|    (Sin bloqueo exclusivo sobre EXCEDENTE: otras ofertas pueden registrarse en paralelo)          |
|                                                                                                   |
|                                                 |                                                 |
|                                                 v                                                 |
|                                                                                                   |
|  [ registrarRespuestaOfertaExcedente (Parte B - Aceptación) ]                                     |
|    1. Validar sesión (rol VENDEDOR).                                                              |
|    2. Lock advisory de serialización de movimientos: pg_advisory_xact_lock(7007002).              |
|    3. Lock pesimista en EXCEDENTE:                                                                |
|       SELECT "cantidadDisponible", "costoHistoricoDisponible"                                     |
|       FROM "EXCEDENTE" WHERE "idExcedente" = :id FOR UPDATE;                                      |
|    4. Lock pesimista en OFERTA_EXCEDENTE:                                                         |
|       SELECT * FROM "OFERTA_EXCEDENTE" WHERE "idOfertaExcedente" = :id FOR UPDATE;               |
|    5. Lock pesimista en PEDIDO receptor:                                                          |
|       SELECT "estado" FROM "PEDIDO" WHERE "idPedido" = :id FOR UPDATE;                            |
|    6. Validaciones críticas bajo lock:                                                            |
|       - OFERTA_EXCEDENTE.respuesta == 'PENDIENTE'                                                 |
|       - PEDIDO.estado == 'PENDIENTE'                                                              |
|       - EXCEDENTE.cantidadDisponible >= cantidadAceptada                                          |
|    7. Escrituras atómicas:                                                                        |
|       - UPDATE OFERTA_EXCEDENTE (respuesta = 'ACEPTADA', importeAceptado, ...)                    |
|       - INSERT MOVIMIENTO_EXCEDENTE (tipo = 'REASIGNACION', costoHistoricoSalida proporcional)    |
|       - UPDATE EXCEDENTE (decrementa cantidadDisponible y costoHistoricoDisponible)               |
|       - (Si aplica D1-B): INSERT DETALLE_PEDIDO (cantidadOriginal = 0) si no existía.            |
|                                                                                                   |
+---------------------------------------------------------------------------------------------------+
```

#### Coordinación transversal con otros casos de uso:
* **Frente a `UC-41` (Descarte):** `RegistrarDescarteExcedenteService` debe adquirir exactamente el mismo lock: `SELECT ... FROM "EXCEDENTE" ... FOR UPDATE`. Quien obtenga el lock primero (descarte o reasignación) consume la existencia; la transacción competidora detectará saldo insuficiente y disparará excepción `A2` o `A1`.
* **Frente a `UC-05` (Entrega del receptor):** El lock `FOR UPDATE` sobre `PEDIDO` serializa la reasignación con el cierre de la entrega. Si `UC-05` ya comenzó, el pedido pasa a `ENTREGADO` y `UC-07` es rechazada con excepción `A3`.

---

## 5. Recomendación argumentada

Se somete a consideración del responsable el siguiente esquema de decisión:

1. **En D1 (Compatibilidad del pedido receptor):**
   * **Recomendación base conservadora:** Adoptar **Alternativa D1-A** (restringir reasignación a productos ya presentes en el pedido) para la versión inicial de I3-02, por ser 100% libre de riesgos relacionales e inmune a disputas normativas sobre `RD-012`.
   * **Recomendación comercial avanzada:** Si el responsable considera prioritaria la flexibilidad comercial de poder ofrecer cualquier excedente, autorizar explícitamente la **Alternativa D1-B** (línea técnica con `cantidadOriginal = 0`), ratificando formalmente que dicha inserción constituye una operación legítima de `UC-07` admitida por `ck_detalle_pedido_3`.
2. **En D2 (Tarificación):**
   * Adoptar **Alternativa D2-3** (`precioBase` vigente ajustado por el porcentaje de la categoría comercial del pedido receptor).
3. **En D3 (Aceptación parcial):**
   * Exigir validación del `importeAceptado` en el payload confrontado contra el cálculo proporcional del servidor.
4. **En D4 (Total vigente):**
   * Derivación en memoria y consultas mediante suma de ofertas aceptadas, sin alterar tablas físicas.
5. **En D5 (Concurrencia):**
   * Adopción del orden estricto de locks: Advisory `7007002` $\rightarrow$ `EXCEDENTE FOR UPDATE` $\rightarrow$ `OFERTA_EXCEDENTE FOR UPDATE` $\rightarrow$ `PEDIDO FOR UPDATE`.

---

## 6. Riesgos arquitectónicos identificados

| ID | Riesgo | Severidad | Mitigación Propuesta |
|---|---|---|---|
| **R-UC07-01** | Incompatibilidad de FK en entrega (`IMPUTACION_ENTREGA_ADICIONAL`) si se acepta un producto ausente en el pedido receptor. | **ALTA** | Resolver formalmente D1 (adoptar D1-A o autorizar D1-B antes de codificar). |
| **R-UC07-02** | Discrepancias de redondeo en aceptación parcial entre frontend y backend. | **MEDIA** | Forzar redondeo `HALF_UP` a 2 decimales y rechazo estricto si el importe difiere. |
| **R-UC07-03** | Carrera concurrente entre reasignación (`UC-07`) y descarte (`UC-41`). | **ALTA** | Bloqueo pesimista unificado `EXCEDENTE ... FOR UPDATE` en ambos servicios. |
| **R-UC07-04** | Ofertas huérfanas si el pedido receptor es cancelado (`UC-06`) o entregado (`UC-05`). | **MEDIA** | Validación bajo lock de `PEDIDO.estado == 'PENDIENTE'` al responder la oferta. |
| **R-UC07-05** | Confusión conceptual entre excedente de producto y excedente monetario de `UC-05`. | **BAJA** | Fijar terminología estricta en la documentación del proyecto. |

---

## 7. Impacto en UC-05 (Entrega) y UC-41 (Descarte)

1. **Impacto en `UC-05` (Registrar Entrega):**
   * `UC-05` no puede dar por cerrada la liquidación de un pedido sin procesar las ofertas aceptadas de `UC-07` que le hayan imputado unidades adicionales.
   * `UC-05` lee `MOVIMIENTO_EXCEDENTE` asociados a ofertas aceptadas de ese pedido e inserta en `IMPUTACION_ENTREGA_ADICIONAL`.
   * El cálculo del `CARGO_POR_VENTA` en Cuenta Corriente debe consolidar el valor entregado de los excedentes aceptados.
2. **Impacto en `UC-41` (Registrar Descarte):**
   * `UC-41` compite por el mismo inventario físico de `EXCEDENTE`. La disminución de disponibilidad por reasignación en `UC-07` reduce inmediatamente la cantidad descartable en `UC-41` y viceversa.
   * Ambos casos de uso comparten la misma tabla histórica: `MOVIMIENTO_EXCEDENTE`.

---

## 8. Dependencias de contratos y modelo relacional

* **Contratos G0:**
  * No se altera la firma ni las 9 secciones de los contratos canónicos de `REV-04B`.
  * La excepción A2 de `registrarOfertaExcedente` y A2 de `registrarRespuestaOfertaExcedente` respaldan formalmente las validaciones de precio y de recálculo propuestas.
* **Modelo Relacional MR-5 / MR-6:**
  * **Cero cambios de DDL.** Se preservan íntegras las 62 tablas vigentes.
  * Se utilizan estrictamente las tablas existentes: `EXCEDENTE`, `OFERTA_EXCEDENTE`, `MOVIMIENTO_EXCEDENTE`, `IMPUTACION_ENTREGA_ADICIONAL`, `PEDIDO`, `DETALLE_PEDIDO`, `PRECIO_PRODUCTO`.

---

## 9. Pruebas de aceptación propuestas (NO EJECUTADAS)

Las siguientes pruebas deberán implementarse en `ale-milanesas-app` durante la construcción de B3/B4:

| Código | Escenario | Resultado Esperado |
|---|---|---|
| **T-U07-01** | Registro de oferta sobre excedente con disponibilidad suficiente. | `201 Created`. `OFERTA_EXCEDENTE` en `PENDIENTE`. `EXCEDENTE.cantidadDisponible` intacta. |
| **T-U07-02** | Registro de oferta con `cantidadOfrecida > cantidadDisponible`. | `400 / 409 Conflict` (Excepción A1). Cero escrituras. |
| **T-U07-03** | Registro de oferta sobre pedido no `PENDIENTE`. | `409 Conflict` (Excepción A2). |
| **T-U07-04** | Aceptación total de oferta (`cantidadAceptada == cantidadOfrecida`). | `200 OK`. `OFERTA_EXCEDENTE` en `ACEPTADA`, se crea `MOVIMIENTO_EXCEDENTE` `REASIGNACION`, `cantidadDisponible` decrementada. |
| **T-U07-05** | Rechazo de oferta por el cliente. | `200 OK`. `OFERTA_EXCEDENTE` en `RECHAZADA`. Excedente y pedido intactos. |
| **T-U07-06** | Aceptación parcial con importe recalculado exacto. | `200 OK`. Se descuenta solo la cantidad aceptada y se transfiere costo proporcional. |
| **T-U07-07** | Aceptación parcial con discrepancia en el importe recalculado. | `409 Conflict` (Excepción A2). Transacción revertida. |
| **T-U07-08** | Dos aceptaciones concurrentes sobre el mismo excedente cuyo saldo conjunto supera el disponible. | Una transacción tiene éxito; la segunda falla con `409 Conflict` por disponibilidad insuficiente. Sin sobreasignación. |
| **T-U07-09** | Aceptación concurrente frente a descarte en `UC-41`. | Se serializan por lock pesimista; saldo consistente y sin saldos negativos. |
| **T-U07-10** | Intento de ejecución de `UC-07` por usuarios con rol `ADMINISTRADOR`, `REPARTIDOR` o `PRODUCCION`. | `403 Forbidden` (RBAC estricto, exclusivo `VENDEDOR`). |

---

## 10. Decisiones pendientes para el responsable

Se elevan formalmente al responsable del proyecto las siguientes definiciones:

1. **Decisión D1 (Compatibilidad de Pedido):** ¿Se restringe formalmente la oferta a pedidos que ya tengan el producto (Opción D1-A), o se aprueba la inserción de líneas técnicas con `cantidadOriginal = 0` (Opción D1-B)?
2. **Decisión D2 (Tarificación):** ¿Se ratifica la fórmula de `precioBase` vigente multiplicado por el factor de ajuste de la categoría comercial del pedido receptor (Opción D2-3)?
3. **Decisión D3 (Aceptación parcial):** ¿Se aprueba el esquema de validación matemática estricta de `importeAceptado` en el payload de confirmación?
4. **Decisión D4 (División de RDs de I3-02):** ¿Se confirma que esta RD (`RD-UC07-001`) se mantenga separada de `RD-I302-001` (dedicada a `UC-05` / F04)?

---

## 11. Condiciones previas para implementar UC-07 en B3

1. Ratificación expresa de esta RD por parte de Victor Leandro Machado.
2. Resolución explícita de la Decisión D1.
3. Aprobación y merge del PR documental correspondiente en `leandrito369/ale-milanesas`.
4. Creación del diseño operacional detallado en `leandrito369/ale-milanesas-app` respetando los locks definidos en D5.

---

## 12. Restricciones de despliegue

* **El entorno de despliegue permanece en estado PAUSADO.**
* La **Issue #28** de `leandrito369/ale-milanesas-app` continúa **ABIERTA**.
* La aprobación o tramitación de esta propuesta documental no autoriza el levantamiento de la pausa ni la activación de servicios en producción.
