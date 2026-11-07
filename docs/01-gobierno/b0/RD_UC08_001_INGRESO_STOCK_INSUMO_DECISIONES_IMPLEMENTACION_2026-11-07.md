# RD-UC08-001 — Decisiones de implementación de UC-08 INSUMO

**Fecha:** 07/11/2026
**Estado:** RATIFICADA. Cierra brecha de gobernanza del PR #68 en `ale-milanesas-app`.
**Autoridad:** Victor Leandro Machado (`leandrito369`), Responsable del proyecto.
**CU y operación:** UC-08 `registrarIngresoStockPorCompra` — rama INSUMO.
**Implementación ratificada:** PR #68 `ale-milanesas-app`, merge `d8a88f2f77f2cb5f7355aefba23186493b5afeba`.

## Registro formal §10.4

| Campo | Valor |
|---|---|
| `decision_id` | `RD-UC08-001` |
| `fecha` | `2026-11-07` |
| `estado` | `RATIFICADA` |
| `autoridad` | Victor Leandro Machado |
| `regla_aprobada` | Las 4 decisiones de implementación del PR #68 que no estaban explícitas en `CONTRATOS_REV03B_CORREGIDOS.md §7` ni en `RD-MR-PARTIDAS-001`. |
| `alternativas_descartadas` | (1) `codigoLote = NULL`; (2) agregar `fechaVencimiento` al body de UC-08; (3) agregar `factorConversionAplicado` al body; (4) permitir `idOrdenCompra = NULL` con `idProveedorDirecto`. |
| `justificacion` | El contrato `REV03B §7` define la operación con firma `registrarIngresoStockPorCompra(tipoElemento, idElemento, idOrdenCompra[0..1], cantidadRecibida, codigoUnidadMedidaRecibida, costoUnitarioCompra, comprobante)`. Las 4 decisiones son decisiones de alcance/implementación dentro del margen permitido por el contrato, necesarias para no extender la firma canónica ni el schema. |
| `artefactos_afectados` | `ale-milanesas-app` (PR #68). Cero cambios en G0/MR-5/F01/MR-6. |
| `fuente_chat` | Trabajo del 07/11/2026. Ratificación del Responsable. |
| `fecha_propagacion` | 07/11/2026 |
| `pruebas` | PR #68 con 12/12 checks verdes, 15 tests B3, 8 tests B4, 360 tests de regresión. |

## Decisiones ratificadas

### D1 — `codigoLote` autogenerado

**Decisión:** el servicio genera `codigoLote = 'LOTE_' || idRecepcionCompra` al insertar en `PARTIDA_INSUMO`.

**Justificación:** la firma canónica del contrato REV03B §7 no incluye `codigoLote`. La tabla `PARTIDA_INSUMO` creada por V3 define `codigoLote VARCHAR(80) NULL`. Sin código de lote, la partida existe pero pierde agrupación por lote. Autogenerarlo permite trazabilidad mínima sin extender la firma.

**Alternativa descartada:** dejar `codigoLote = NULL` (perdería la identificación del envío).

**Reversibilidad:** cuando se ratifique un `codigoLote` provisto por el usuario (futuro), esta decisión se supersede con nueva RD.

### D2 — `fechaVencimiento = NULL`

**Decisión:** el servicio inserta `fechaVencimiento = NULL` al crear `PARTIDA_INSUMO`.

**Justificación:** la firma canónica no incluye `fechaVencimiento`. La columna admite NULL por diseño de V3 ("insumos no perecederos"). El operador puede completarla después en UC-51 o por UI.

**Alternativa descartada:** agregar `fechaVencimiento` al body (extendería la firma).

**Estado:** la columna existe y es nullable, coherente con D1 de `RD-MR-PARTIDAS-001` ("`fechaVencimiento` nullable").

### D3 — `factorConversionAplicado = 1` con validación de unidad base

**Decisión:** el servicio exige que `codigoUnidadMedidaRecibida == INSUMO.codigoUnidadMedida` y registra `factorConversionAplicado = 1`.

**Justificación:** la firma incluye `codigoUnidadMedidaRecibida` (parámetro explícito de R3-02), pero el contrato no especifica el `factorConversionAplicado`. Como no existe tabla de conversiones en V1, la implementación valida que la unidad recibida sea la unidad base del insumo y no aplica conversión.

**Alternativa descartada:** agregar `factorConversionAplicado` al body (extendería la firma). Requeriría una tabla de conversiones (no existe).

**Limitación documentada:** si el proveedor entrega en unidad distinta de la base, la recepción se rechaza con 400 `UNIDAD_NO_COINCIDE`. La extensión queda para corte futuro con RD específica.

### D4 — `idOrdenCompra` obligatoria (dentro del margen del contrato)

**Decisión:** el servicio rechaza la operación con 400 `ORDEN_COMPRA_REQUERIDA` si `idOrdenCompra = NULL`.

**Justificación:** la firma canónica declara `idOrdenCompra: Long[0..1]` (opcional en sintaxis). Sin embargo, la rama de recepción extraordinaria (sin orden) requiere `idProveedorDirecto`, que **no está en la firma**. Implementar recepción extraordinaria sin extender la firma es imposible. La decisión restringe el corte a recepciones asociadas a orden.

**Alternativa descartada:** agregar `idProveedorDirecto` al body (extendería la firma). Coherente con reventa, pero requiere decisión de producto.

**Limitación documentada:** la recepción extraordinaria (sin orden) queda fuera de este corte.

## Impacto en gobernanza

- **NO modifica G0**: `source_commit=1263ffc17bd0eb7f3c69faaa9ff5ae556cf9de7e` sigue inmutable.
- **NO modifica MR-5/F01 ni MR-6.**
- **NO modifica `source-lock.md`** (esta RD no autoriza nuevos objetos de schema; solo ratifica decisiones de implementación).
- **NO requiere actualización de manifiesto** (`G0_MANIFIESTO_CANONICO_*`), porque no hay cambios de schema.
- **La `RD-MR-PARTIDAS-001`** (que autoriza `PARTIDA_INSUMO`) sigue vigente. Esta RD **depende** de ella y no la sustituye.

## Pruebas

- PR #68 con **12/12 checks verdes** (Sonar, B1, B2, 8 workflows UC, UC08, B2).
- 15 tests B3 en `RegistrarIngresoStockInsumoServiceIntegrationTest`.
- 8 tests B4 en `RegistrarIngresoStockInsumoHttpExternoTest`.
- 360 tests de regresión en `main`.

## Firmas

**Decisión ratificada por:** Victor Leandro Machado — Responsable del proyecto.
**Fecha:** 07/11/2026.
