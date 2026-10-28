# REV-04B — Auditoría Transversal y Corrección: Preparación, Entrega, Cancelación y Excedentes (UC-28, UC-05, UC-06, UC-61, UC-07, UC-41)

**Fecha:** 28/10/2026  

**Rama de trabajo propuesta:** `revision/rev04b-entregas-excedentes-2026-10-28`  

**Alcance (`REV-04B`):** `UC-28` («include» `UC-34`), `UC-05` («include» `UC-34`, `UC-15`), `UC-06` («include» `UC-34`, «extend» condicional `UC-26`), `UC-61`, `UC-07` («include» `UC-61` aprobado el 25/10/2026), `UC-41` («include» `UC-61` aprobado el 25/10/2026).  

**Estado de los artefactos entregados:** `PROPUESTO / CORREGIDO EN REVISIÓN ESTÁTICA` (pendiente de inspección visual humana en Draw.io y aprobación para fusión a `main`).

---

## 1. Ejecución de las 8 Etapas Metodológicas (M-0 a M-7)

### M-0 — Autoridad y alcance congelados

* **Catálogo funcional vigente:** 64 CU consecutivos (`UC-01`..`UC-64`) en 3 niveles (`ALE_MILANESAS_FASE_4_CU_01_A_64_TRES_NIVELES.docx`).

* **Relaciones UML aprobadas en este sublote:** `UC-28 → UC-34` (`include`), `UC-05 → UC-34` (`include`), `UC-05 → UC-15` (`include`), `UC-06 → UC-34` (`include`), `UC-26 → UC-06` (`extend` condicional), `UC-07 → UC-61` (`include` aprobada el 25/10/2026) y `UC-41 → UC-61` (`include` aprobada el 25/10/2026). El archivo `DIAGRAMA DE CASOS DE USO.drawio (1).xml` permanece intacto.

* **Decisiones posteriores incorporadas (Corte 27/10/2026):**

  * **`RD-F04-001..007` y `RD-RP004/RP028` (resuelven Hallazgos de Prioridad Alta `H-03` y `H-09` en `UC-05`):**

    1. **Declaración de efectivo recibido por el Repartidor (Efectivo en Tránsito):** En `UC-05 — Registrar Entrega`, el Repartidor puede declarar el monto de efectivo entregado en mano por el Cliente (`efectivoDeclaradoRecibido: BigDecimal[0..1]`). Dicho importe se registra como **pago/efectivo en tránsito validado** asociado a la `Entrega`: **no ejecuta `UC-29 — Registrar Cobro`**, **no crea un `Cobro` definitivo**, **no genera `MovimientoCaja` (`INGRESO`)** ni reduce el **saldo confirmado** de Cuenta Corriente hasta su rendición y registración en `UC-29` por Vendedor o Administrador, pero sí se expone en `UC-14` para determinar el **saldo exigible provisional**.

    2. **Operación offline y regla «El Reparto Manda» (`RD-F04`):** Cuando el Repartidor registra la Entrega en modo offline sobre un Pedido válidamente asignado, la operación se almacena localmente con `claveIdempotencia` y el snapshot comercial congelado; al sincronizar con el servidor, se valida identidad, sesión, no duplicación e integridad de límites comerciales/físicos («El Reparto Manda» para las cantidades efectivamente entregadas y el efectivo declarado en tránsito) sin otorgar permiso de `UC-29` al Repartidor.

  * **Desagrupamiento de `UC-07` en Contratos individuales (`H-11` / Puerta `G4`):** Se separan `registrarOfertaExcedente` (que no reserva stock ni transfiere unidades) y `registrarRespuestaOfertaExcedente` (que revalida concurrencia, transfiere costo histórico en `MovimientoExcedente` `REASIGNACION` e incorpora adicionales al Pedido receptor) en dos contratos independientes con sus 9 secciones.

### M-1 — Proveniencia, integridad y matriz de diferencias (Antes → Después)

\| ID Hallazgo \| Artefacto / Celda Original \| Antes (Borrador 26–27/10) \| Después (Versión Corregida `REV04B`) \| Fundamento \|

\| :--- \| :--- \| :--- \| :--- \| :--- \|

\| **`H-03` (Alta)** \| `DSS Repartidor` (`p3_m7`), `DS UC-05` y `Contrato 3.3` \| Restringía `UC-05` a entrega y cargo sin modelar la declaración de efectivo recibido por el Repartidor ni el efectivo en tránsito. \| Incorpora `efectivoDeclaradoRecibido:BigDecimal[0..1]` en la firma y flujo de `UC-05`, registrando el **efectivo en tránsito validado** (que impacta en el saldo exigible provisional de `UC-14` sin ejecutar `UC-29` ni ingresar en `Caja`). \| `RD-F04-001..007` y `RD-RP004/RP028` \|

\| **`H-09` (Media/Alta)** \| `DS UC-05` y `Contrato 3.3` \| Trataba `F04` como pendiente abierto sin detallar la validación en servidor ni la regla «El Reparto Manda». \| Formaliza la validación de servidor con `claveIdempotencia`, respeto del snapshot de reparto válido («El Reparto Manda») y conciliación idempotente sin duplicar cargos ni entregas. \| `RD-F04-001..007` \|

\| **`H-11` (Media)** \| `Contrato 5.5` (`UC-07`) \| Agrupaba `registrarOfertaExcedente` y `registrarRespuestaOfertaExcedente` en un único contrato. \| Se desagrupan en **2 Contratos independientes** (Contratos `5` y `6` de `REV-04B`), sumando **7 Contratos individuales** en este sublote. \| Puerta `G4` / `H-11` \|

\| **`H-12`, `H-19`, `H05`** \| `DSS`, `DS` y `Contratos` \| Secuencia continua en el DSS, referencias a tablas SQL en caja negra y firmas divergentes. \| Marcos `sd` independientes por CU en el DSS, lenguaje de caja negra y homologación 1:1 de las 7 firmas públicas entre DSS, DS y Contratos. \| `M-3`, `H-12`, `H-19`, `H05` \|

---

## 2. Matriz de Trazabilidad Vertical y Visibilidad de Larman Mensaje por Mensaje (M-3 y M-6)

\| CU \| Paso / Mensaje en DS \| Emisor \$\\rightarrow\$ Receptor \| Tipo de Visibilidad (Larman) \| Origen verificable de la referencia \|

\| :--- \| :--- \| :--- \| :--- \| :--- \|

\| **`UC-28`** \| `1: registrarPreparacionPedido(idPedido, idProducto, cantidadPreparada)` \| `Responsable de Producción` \$\\rightarrow\$ `:ControladorProduccion` \| Frontera de sistema \| Operación pública homologada del DSS (`UC-28`, precedida por `«include» UC-34`). \|

\| **`UC-28`** \| `2: consumos = calcularInsumosProporcionales(cantidadPreparada)` \| `:ControladorProduccion` \$\\rightarrow\$ `verReceta : VersionReceta` \| **Por Variable Local / Parámetro** \| Recupera la `VersionReceta` vigente del Producto `ELABORADO` y escala por `cantidadPreparada / cantidadRendimientoBase`. \|

\| **`UC-28`** \| `3: verificarStockYCongelarCostosHistoricos(consumos)` \| `:ControladorProduccion` \$\\rightarrow\$ `:CatalogoInsumos` \| **Por Atributo** \| Verifica `stockActual >= cantidadNecesaria` y obtiene el `vigenteDesdeCosto` de `CostoInsumoHistorico` (nunca costo cero). \|

\| **`UC-28`** \| `4: «create» new(unPedido, unProducto, verReceta, cantidadPreparada, consumosConCostoCongelado)` \| `:ControladorProduccion` \$\\rightarrow\$ `unaPrep : Preparacion` \| **Por Creación Local (`new`)** \| Registra `Preparacion`, descuenta stock creando `MovimientoInsumo` (`CONSUMO_PRODUCCION`) y evalúa `PRA-01`. \|

\| **`UC-05`** \| `1: registrarEntrega(idPedido, detallesEntrega, efectivoDeclaradoRecibido, claveIdempotencia)` \| `Repartidor` \$\\rightarrow\$ `:ControladorReparto` \| Frontera de sistema \| Operación pública homologada del DSS (`UC-05`, precedida por `«include» UC-34`). \|

\| **`UC-05`** \| `2: liq = validarAsignacionLimitesEImputacionComercial(idRepartidor, detallesEntrega, efectivoDeclaradoRecibido, claveIdempotencia)` \| `:ControladorReparto` \$\\rightarrow\$ `unPedido : Pedido` \| **Por Variable Local** \| Valida idempotencia (`RD-F04`), imputa primero a unidades originales y luego a adicionales por orden de confirmación (`UC-07`). \|

\| **`UC-05`** \| `3: «create» new(unPedido, detallesEntrega, importeEfectivoVenta, efectivoDeclaradoEnTransito, claveIdempotencia)` \| `:ControladorReparto` \$\\rightarrow\$ `unaEntrega : Entrega` \| **Por Creación Local (`new`)** \| Crea la `Entrega` definitiva, descuenta stock `REVENTA` (`EGRESO_VENTA`) y conserva el **efectivo en tránsito validado** (`RD-F04` / `RD-RP028`) sin crear `Cobro` ni `MovimientoCaja`. \|

\| **`UC-05`** \| `4: «create» new(unProducto, unPedido, cantSobrante, costoHistoricoPreservado, estado=DISPONIBLE)` \| `:ControladorReparto` \$\\rightarrow\$ `sobrante : Excedente` \| **Por Creación Local (`new`)** \| Si sobró Producto `ELABORADO` disponible, crea el `Excedente` con su costo histórico. \|

\| **`UC-05`** \| `5: registrarCargoPorVentaEfectivaYActualizarEfectivoEnTransito(unCliente, unaEntrega, importeEfectivoVenta, efectivoDeclaradoRecibido)` \| `:ControladorReparto` \$\\rightarrow\$ `:LibroCuentaCorriente` \| **Por Atributo \+ Parámetro** \| Registra `CARGO_POR_VENTA` en el saldo confirmado y actualiza los pagos en tránsito validados para el saldo exigible provisional (`UC-14`), ejecutando luego `«include» UC-15`. \|

\| **`UC-06`** \| `1: cancelarPedido(idPedido, motivoCancelacion)` \| `Actor Autorizado` \$\\rightarrow\$ `:ControladorPedidos` \| Frontera de sistema \| Operación pública homologada del DSS (`UC-06`, precedida por `«include» UC-34`). \|

\| **`UC-06`** \| `2: «create» new(unProducto, unPedido, cantDisponible, costoHistoricoPonderado, origen=CANCELACION)` \| `:ControladorPedidos` \$\\rightarrow\$ `excCancel : Excedente` \| **Por Creación Local (`new`)** \| Preserva como `Excedente` todo Producto `ELABORADO` ya preparado/reasignado sin revertir consumos de Insumos, y extiende condicionalmente a `UC-26` si tiene `Cobro` electrónico reembolsable. \|

\| **`UC-61`** \| `1: buscarExcedente(idProducto, idPedidoOrigen, fechaGeneracion, soloDisponibles)` \| `Vendedor / Resp. Producción` \$\\rightarrow\$ `:ControladorProduccion` \| Frontera de sistema \| Operación pública homologada del DSS (`UC-61`). \|

\| **`UC-61`** \| `2: lista = consultarExcedentesElaboradosSegunPermisos(filtro, rolActor)` \| `:ControladorProduccion` \$\\rightarrow\$ `:RepositorioExcedentes` \| **Por Atributo** \| Consulta sin reservar saldo y ocultando costos internos al Vendedor. \|

\| **`UC-07` (Oferta)** \| `1a: registrarOfertaExcedente(idExcedente, idPedidoReceptor, cantidadOfrecida)` \| `Vendedor` \$\\rightarrow\$ `:ControladorPedidos` \| Frontera de sistema \| Primera operación pública de `UC-07` (precedida por `«include» UC-61`). \|

\| **`UC-07` (Oferta)** \| `2a: «create» new(unExcedente, pedidoReceptor, cantidadOfrecida, importeInformado)` \| `:ControladorPedidos` \$\\rightarrow\$ `oferta : OfertaExcedente` \| **Por Creación Local (`new`)** \| Registra la oferta sin reservar `cantidadDisponible`. \|

\| **`UC-07` (Resp.)** \| `1b: registrarRespuestaOfertaExcedente(idOfertaExcedente, aceptada, cantidadAceptada)` \| `Vendedor` \$\\rightarrow\$ `:ControladorPedidos` \| Frontera de sistema \| Segunda operación pública de `UC-07`. \|

\| **`UC-07` (Resp.)** \| `2b: incorporarAdicionalesYCrearMovimientoReasignacion(cantidadAceptada, importeAceptado, costoTransferido)` \| `:ControladorPedidos` \$\\rightarrow\$ `pedidoReceptor : Pedido` / `movExc : MovimientoExcedente` \| **Por Variable Local \+ Creación Local (`new`)** \| Incorpora unidades adicionales e `importeAceptado` sin alterar `cantidadOriginal` ni `totalOriginal`, crea `MovimientoExcedente` (`REASIGNACION`) y reduce `cantidadDisponible`. \|

\| **`UC-41`** \| `1: registrarDescarteExcedente(idExcedente, cantidadDescartada, motivoDescarte)` \| `Responsable de Producción` \$\\rightarrow\$ `:ControladorProduccion` \| Frontera de sistema \| Operación pública homologada del DSS (`UC-41`, precedida por `«include» UC-61`). \|

\| **`UC-41`** \| `2: «create» new(unExcedente, tipo=DESCARTE, cantidadDescartada, motivoDescarte, costoDescartado)` \| `:ControladorProduccion` \$\\rightarrow\$ `movDesc : MovimientoExcedente` \| **Por Creación Local (`new`)** \| Registra el descarte y reduce atómicamente `unExcedente.cantidadDisponible` (`DISPONIBLE` o `AGOTADO`). \|

---

## 3. Matriz Transversal de Invariantes y Puertas de Aceptación (M-4 y M-7)

\| ID \| Invariante ratificada \| DSS \| DS \| Contrato \| Dictamen \|

\| :--- \| :--- \| :--- \| :--- \| :--- \| :--- \|

\| **`I-01`** \| `RD-F04` y `RD-RP004/RP028` (`H-03`, `H-09`): `UC-05` registra `efectivoDeclaradoRecibido` como efectivo en tránsito validado (sin ejecutar `UC-29` ni ingresar en `Caja`) y valida idempotencia/snapshot de reparto offline \| Parámetro y retorno explícitos en `DSS UC-05` \| Paso `2:`, `3:` y `5:` en `DS UC-05` \| Notas, Pre/Postcondiciones en `CONTRATO_UC05` \| **PASÓ (Trazabilidad estática)** \|

\| **`I-02`** \| `UC-28`: Límite de preparación propia `<= cantidadSolicitada` original (sin descontar adicionales de `UC-07`) y congelamiento de costos históricos válidos \| Guarda en `DSS UC-28` \| Validación en `DS UC-28` \| `CONTRATO_UC28` individual \| **PASÓ (Trazabilidad estática)** \|

\| **`I-03`** \| `UC-07` y `UC-41` («include» `UC-61` aprobados el 25/10): Oferta no reserva saldo; aceptación transfiere costo histórico sin re-ejecutar `UC-15`/`UC-16` ni volver a preparar; descarte exige motivo y preserva consumos históricos \| Marcos `UC-61`, `UC-07` y `UC-41` \| `DS UC-61`, `UC-07` y `UC-41` con revalidación concurrente \| Contratos individuales `4`, `5`, `6` y `7` \| **PASÓ (Trazabilidad estática)** \|

\| **`I-04`** \| Homologación 1:1 de firmas públicas DSS ↔ DS ↔ Contrato y desagrupamiento en 7 contratos individuales (`H-11`, `H05`) \| 7 firmas canónicas \| Mensaje `1:` idéntico en las 6 páginas DS \| 7 Contratos individuales con 9 secciones \| **PASÓ** \|

\| **`I-05`** \| Inspección visual y prueba de desplazamiento (`round-trip`) en editor gráfico Draw.io (`M-6` / `G5`) \| XML bien formado \| XML bien formado \| N/A \| **PENDIENTE DE VALIDACIÓN HUMANA EN DRAW.IO** \|

