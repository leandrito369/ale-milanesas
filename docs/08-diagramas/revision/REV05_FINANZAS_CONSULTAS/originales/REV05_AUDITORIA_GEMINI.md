# REV-05 — Auditoría Transversal y Corrección: Finanzas, Cuenta Corriente, Cobros, Reembolsos, Caja y Margen Bruto (UC-14, UC-22, UC-23, UC-26, UC-27, UC-29, UC-49)

**Fecha:** 28/10/2026  

**Rama de trabajo propuesta:** `revision/rev05-finanzas-consultas-2026-10-28`  

**Alcance (`REV-05`):** `UC-14` («include» `UC-33`), `UC-29` («include» `UC-15`), `UC-22`, `UC-23`, `UC-26` («extend» condicional a `UC-06`), `UC-49`, `UC-27`.  

**Estado de los artefactos entregados:** `PROPUESTO / CORREGIDO EN REVISIÓN ESTÁTICA` (pendiente de inspección visual humana en Draw.io y aprobación para fusión a `main`).

---

## 1. Ejecución de las 8 Etapas Metodológicas (M-0 a M-7)

### M-0 — Autoridad y alcance congelados

* **Catálogo funcional vigente:** 64 CU consecutivos (`UC-01`..`UC-64`) en 3 niveles (`ALE_MILANESAS_FASE_4_CU_01_A_64_TRES_NIVELES.docx`), respetando que **`UC-49` es «Registrar Resultado de Reembolso Electrónico»** (Actor principal: `MercadoPago`) y que **`UC-26` no incluye ni extiende `UC-49`**.

* **Relaciones UML aprobadas en este lote:** `UC-14 → UC-33` (`include`), `UC-29 → UC-15` (`include`) y `UC-26 → UC-06` (`extend` condicional). El archivo `DIAGRAMA DE CASOS DE USO.drawio (1).xml` permanece intacto.

* **Decisiones posteriores incorporadas (Corte 27/10/2026):**

  * **`RD-RP004/RP028-001` y `RD-F04` (resuelve Hallazgo de Prioridad Alta `H-03` en `UC-14`):** En `UC-14 — Consultar Cuenta Corriente`, el sistema diferencia y expone explícitamente tres magnitudes financieras:

    1. **`saldoConfirmado`:** Saldo resultante de los movimientos definitivos en `MOVIMIENTO_CUENTA` (`CARGO_POR_VENTA`, `PAGO`, `AJUSTE_DEBITO`, `ANULACION_COBRO`).

    2. **`pagosEnTransitoValidados`:** Suma de efectivo declarado como recibido por los Repartidores en `UC-05` que aún se encuentra pendiente de rendición y registración en `UC-29`.

    3. **`saldoExigibleProvisional`:** Saldo neto exigible al Cliente considerando los pagos en tránsito validados (`saldoConfirmado - pagosEnTransitoValidados`).

  * **`RD-RP004/RP028-001` (resuelve Hallazgo de Prioridad Alta `H-04` en `UC-27`):** En `UC-27 — Consultar Margen Bruto`, además de la consulta **por período** (delimitado por `Entrega.fechaHoraEntrega`), se incorpora la consulta **por venta individual** (`idPedido` / `idEntrega` de un Pedido `ENTREGADO`), aplicando exactamente la misma regla de ingresos efectivos (`CARGO_POR_VENTA`: tramo original a condiciones históricas \+ tramo adicional a importe aceptado en `UC-07`) menos costos históricos atribuibles (`ELABORADO` y `REVENTA`) e indicador de completitud.

  * **`RD-F01` y `MR-6` (resuelve Hallazgo `H-10` en `UC-29`):** Se restringe el dominio de `COBRO.estadoCobro` exclusivamente a los valores aprobados **`CONFIRMADO`** y **`ANULADO`**. Cuando se registra un cobro válido en `UC-29`, nace con `estadoCobro = CONFIRMADO`. Para revertir un cobro manual erróneo (dentro de `UC-29`, sin confundirlo con `UC-49`), el Cobro pasa a `estadoCobro = ANULADO` y se generan los contraasientos trazables mediante `idCobroAnulado` en `ORIGEN_MOVIMIENTO_CUENTA` (`ANULACION_COBRO`) y en `MOVIMIENTO_CAJA` (`EGRESO`), reevaluando `UC-15`.

### M-1 — Proveniencia, integridad y matriz de diferencias (Antes → Después)

| ID Hallazgo | Artefacto / Celda Original | Antes (Borrador 26–27/10) | Después (Versión Corregida `REV05`) | Fundamento |

| :--- | :--- | :--- | :--- | :--- |

| **`H-03` (Alta)** | `DSS Vendedor` (`v_r14`), `DS UC-14` (`u14_r2`) y `Contrato 5.6` | Mostraba únicamente un `saldoActual` plano sin distinguir pagos en tránsito ni saldo exigible provisional. | Expone explícitamente **`saldoConfirmado`**, **`pagosEnTransitoValidados`** (declarados en `UC-05`) y **`saldoExigibleProvisional`** tanto en el DSS como en `DS UC-14` y `CONTRATO_UC14`. | `RD-RP004/RP028-001` y `RD-F04` |

| **`H-04` (Alta)** | `DSS Admin 6C` (`a3_m9`), `DS UC-27` (`u27_m1`) y `Contrato 6C.3` | Modelaba `UC-27` únicamente por período de fechas. | Incorpora en la firma y en el fragmento `alt` de `DS UC-27` y `CONTRATO_UC27` ambas modalidades aprobadas: consulta **por período** (`fechaHoraDesde`, `fechaHoraHasta`) y consulta **por venta individual** (`idEntrega` / `idPedido` `ENTREGADO`). | `RD-RP004/RP028-001` |

| **`H-10` (Media/Alta)** | `DS UC-29` (`u29_m3_new`) y `Contrato 5.6` | Usaba un `estado` indeterminado en `DS UC-29` y en el DSS mezclaba la anulación manual con `UC-49`. | Fija `estadoCobro = CONFIRMADO` en el alta de `UC-29` y modela la anulación de cobro manual (`estadoCobro = ANULADO` \+ contraasiento con `idCobroAnulado` \+ `UC-15`) dentro del alcance de `UC-29`, manteniendo `UC-49` exclusivamente para el resultado asíncrono de `MercadoPago`. | `RD-F01`, `MR-3`/`MR-6` y Ficha Fase 4 `UC-49` |

| **`H-11` (Media)** | `Contrato 5.6` (`UC-29`+`UC-14`) y `Contrato 6C.3` (`UC-22`+`23`+`26`+`49`+`27`) | Agrupaba 7 casos de uso distintos en solo 2 fichas de contrato compuestas. | Se desagrupan en **8 Contratos individuales** (`UC-14`, `UC-29` alta, `UC-29` anulación manual, `UC-22`, `UC-23`, `UC-26`, `UC-49`, `UC-27`), cada uno con sus 9 secciones estándar. | Puerta `G4` / `H-11` |

| **`H-12`, `H-19`, `H05`** | `DSS`, `DS` y `Contratos` | Secuencia continua en el DSS y firmas divergentes. | Marcos `sd` independientes por CU en el DSS, lenguaje de caja negra y homologación 1:1 de las 8 firmas públicas entre DSS, DS y Contratos. | `M-3`, `H-12`, `H-19`, `H05` |

---

## 2. Matriz de Trazabilidad Vertical y Visibilidad de Larman Mensaje por Mensaje (M-3 y M-6)

| CU | Paso / Mensaje en DS | Emisor \$\\rightarrow\$ Receptor | Tipo de Visibilidad (Larman) | Origen verificable de la referencia |

| :--- | :--- | :--- | :--- | :--- |

| **`UC-14`** | `1: consultarCuentaCorriente(idCliente, fechaDesde, fechaHasta)` | `Vendedor / Admin` \$\\rightarrow\$ `:ControladorCuentaCorrienteCobros` | Frontera de sistema | Operación pública homologada del DSS (`UC-14`, precedida por `«include» UC-33`). |

| **`UC-14`** | `2: res = recuperarSaldosConfirmadoEnTransitoYProvisionalEHistorial(idCliente, fechaDesde, fechaHasta)` | `:ControladorCuentaCorrienteCobros` \$\\rightarrow\$ `:LibroCuentaCorriente` | **Por Atributo** | Calcula `saldoConfirmado`, `pagosEnTransitoValidados` y `saldoExigibleProvisional` (`RD-RP028`) y filtra solo la vista de movimientos sin alterar los saldos. |

| **`UC-29` (Alta)** | `1a: registrarCobro(idCliente, idPedido, importe, medioPago, origen, referenciaExterna)` | `Vendedor / Admin` \$\\rightarrow\$ `:ControladorCuentaCorrienteCobros` | Frontera de sistema | Operación pública homologada del DSS (`UC-29`). |

| **`UC-29` (Alta)** | `2a: «create» new(unCliente, unPedido[0..1], importe, medioPago, origen, referenciaExterna, estadoCobro=CONFIRMADO)` | `:ControladorCuentaCorrienteCobros` \$\\rightarrow\$ `unCobro : Cobro` | **Por Creación Local (`new`) \+ Parámetro** | Instancia el `Cobro` con `estadoCobro = CONFIRMADO` (`RD-F01`), registra `PAGO` en `:LibroCuentaCorriente` (conciliando efectivo en tránsito si corresponde a rendición), `INGRESO` en `:LibroCaja` y ejecuta `«include» UC-15`. |

| **`UC-29` (Anul.)** | `1b: anularCobroManual(idCobro, motivoAnulacion)` | `Vendedor / Admin` \$\\rightarrow\$ `:ControladorCuentaCorrienteCobros` | Frontera de sistema | Operación de reversión de cobro manual por contraasiento (`RD-F01` / `MR1-33`). |

| **`UC-29` (Anul.)** | `2b: marcarAnuladoYGenerarContraasientos(idCobroAnulado, motivoAnulacion)` | `:ControladorCuentaCorrienteCobros` \$\\rightarrow\$ `unCobro : Cobro` / `:LibroCuentaCorriente` / `:LibroCaja` | **Por Variable Local \+ Atributo** | Pasa `unCobro.estadoCobro` a `ANULADO`, crea contraasiento `ANULACION_COBRO` enlazado por `idCobroAnulado` en Cuenta Corriente y Caja, y reevalúa `UC-15`. |

| **`UC-22`** | `1: registrarMovimientoCaja(tipoMovimiento, importe, concepto, observacion)` | `Administrador` \$\\rightarrow\$ `:ControladorCaja` | Frontera de sistema | Operación pública homologada del DSS (`UC-22`). |

| **`UC-22`** | `2: «create» new(tipoMovimiento, importe, concepto, observacion, origen=MANUAL, idAdmin)` | `:ControladorCaja` \$\\rightarrow\$ `movCaja : MovimientoCaja` | **Por Creación Local (`new`)** | Crea y persiste en `:LibroCaja` el movimiento manual excluyendo pagos de Clientes y reembolsos automáticos. |

| **`UC-23`** | `1: consultarLibroDiario(fechaInicial, fechaFinal)` | `Administrador` \$\\rightarrow\$ `:ControladorCaja` | Frontera de sistema | Operación pública homologada del DSS (`UC-23`). |

| **`UC-23`** | `2: libro = recuperarMovimientosYCalcularResultadoMonetario(fechaInicial, fechaFinal)` | `:ControladorCaja` \$\\rightarrow\$ `:LibroCaja` | **Por Atributo** | Recupera movimientos manuales y automáticos y calcula `ingresos - egresos` en solo lectura. |

| **`UC-26`** | `1: procesarReembolsoElectronico(idCobroOriginal, idReembolsoReintento, idUsuarioReintento)` | `Disparador UC-06 / Admin` \$\\rightarrow\$ `:ControladorReembolsos` | Frontera de sistema | Operación pública homologada del DSS (`UC-26`). |

| **`UC-26`** | `2: «create» new(unReembolso, numeroIntento, claveIdempotencia, idUsuarioReintento[0..1])` | `unReembolso : Reembolso` \$\\rightarrow\$ `intento : IntentoReembolso` | **Por Creación Local (`new`) \+ Atributo** | Crea el intento sobre el único `Reembolso` del `Cobro`; solo si `MercadoPago` responde `PROCESADO` genera `EGRESO` en Caja, `AJUSTE_DEBITO` en Cuenta Corriente y ejecuta `UC-15`. |

| **`UC-49`** | `1: registrarResultadoReembolsoElectronico(referenciaExternaIntento, estadoInformado, firmaVerificacion)` | `MercadoPago` \$\\rightarrow\$ `:ControladorReembolsos` | Frontera de sistema | Operación pública homologada del DSS (`UC-49`). |

| **`UC-49`** | `2: «create» new(intentoActivo, estadoInformado, fechaHoraRecepcion, referenciaExternaIntento)` | `:ControladorReembolsos` \$\\rightarrow\$ `evResultado : EventoResultadoReembolso` | **Por Creación Local (`new`)** | Registra idempotentemente el evento; solo en la primera transición a `PROCESADO` aplica `EGRESO` en Caja, `AJUSTE_DEBITO` en Cuenta Corriente y ejecuta `UC-15`. |

| **`UC-27`** | `1: consultarMargenBruto(modoConsulta, fechaHoraDesde, fechaHoraHasta, idVentaIndividual)` | `Administrador` \$\\rightarrow\$ `:ControladorMargenBruto` | Frontera de sistema | Operación pública homologada del DSS (`UC-27`, soporta `PERIODO` y `VENTA_INDIVIDUAL` según `RD-RP004/RP028-001`). |

| **`UC-27`** | `2: entregas = obtenerVentasEfectivasPorPeriodoOVentaIndividual(modoConsulta, fechaHoraDesde, fechaHoraHasta, idVentaIndividual)` | `:ControladorMargenBruto` \$\\rightarrow\$ `:RepositorioPedidos` | **Por Atributo** | Recupera la(s) `Entrega` definitiva(s) conciliada(s) con `CARGO_POR_VENTA` y sus costos históricos en `:ControladorInventario`. |

---

## 3. Matriz Transversal de Invariantes y Puertas de Aceptación (M-4 y M-7)

| ID | Invariante ratificada | DSS | DS | Contrato | Dictamen |

| :--- | :--- | :--- | :--- | :--- | :--- |

| **`I-01`** | `RD-RP004/RP028-001` (`H-03`): `UC-14` diferencia explícitamente `saldoConfirmado`, `pagosEnTransitoValidados` y `saldoExigibleProvisional`, manteniendo los saldos intactos al filtrar movimientos por período | Retorno explícito en `DSS UC-14` | Paso `2:` y `2.1:` en `DS UC-14` | Salida y Notas en `CONTRATO_UC14` | **PASÓ (Trazabilidad estática)** |

| **`I-02`** | `RD-RP004/RP028-001` (`H-04`): `UC-27` soporta tanto la consulta **por período** como la consulta **por venta individual** (`idPedido` / `idEntrega`), marcando incompleto si falta algún costo histórico (nunca costo cero) | Parámetros y ramas en `DSS UC-27` | Fragmento `alt` con operandos `PERIODO`, `VENTA_INDIVIDUAL` y `RECHAZO` en `DS UC-27` | `CONTRATO_UC27` individual con 9 secciones | **PASÓ (Trazabilidad estática)** |

| **`I-03`** | `RD-F01` / `MR-6` (`H-10`): `COBRO.estadoCobro` restringido a `CONFIRMADO` y `ANULADO`; reversión manual mediante contraasiento con `idCobroAnulado` en Cuenta Corriente y Caja | Marcos en `DSS Vendedor` | `DS UC-29` con alta (`CONFIRMADO`) y anulación (`ANULADO` \+ `idCobroAnulado`) | Contratos `2` y `3` individuales | **PASÓ (Trazabilidad estática)** |

| **`I-04`** | `UC-26` vs. `UC-49`: Un único `Reembolso` por `Cobro` electrónico; reintento manual exclusivo de Administrador sobre `RECHAZADO`; efectos en Caja y Cuenta Corriente solo cuando pasa a `PROCESADO`; `UC-26` no incluye ni extiende `UC-49` | Marcos separados `UC-26` y `UC-49` | `DS UC-26` y `DS UC-49` con idempotencia estricta | Contratos `6` y `7` individuales | **PASÓ (Trazabilidad estática)** |

| **`I-05`** | Homologación 1:1 de firmas públicas DSS ↔ DS ↔ Contrato y desagrupamiento en 8 contratos individuales (`H-11`, `H05`) | 8 firmas canónicas | Mensaje `1:` idéntico en las 7 páginas DS | 8 Contratos individuales con 9 secciones | **PASÓ** |

| **`I-06`** | Inspección visual y prueba de desplazamiento (`round-trip`) en editor gráfico Draw.io (`M-6` / `G5`) | XML bien formado | XML bien formado | N/A | **PENDIENTE DE VALIDACIÓN HUMANA EN DRAW.IO** |
