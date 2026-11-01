# RD-UC30-001 — Alcance de trazabilidad del maestro PRODUCTO sin migración

**Fecha:** 31/10/2026 · **Estado:** APROBADA por decisión expresa del responsable en el dictamen de cierre de Issue #19 · **Ámbito:** Fase 4 / G0 / I1-03 B3 / MR-5 y F01.

## Registro canónico (§10.4)

| Campo | Valor |
|---|---|
| `decision_id` | `RD-UC30-001` |
| `fecha` | `2026-10-31` |
| `estado` | `APROBADA` |
| `autoridad` | Responsable del proyecto, dictamen de 31/10/2026 aportado para resolver Issue #19 |
| `regla_aprobada` | **Opción A**: se interpreta la trazabilidad del catálogo de Productos como conservación transaccional de su identidad estable, unicidad de denominación normalizada y no reescritura de dependencias históricas. No se incorpora nueva auditoría de eventos del maestro. La sesión y Rol ADMINISTRADOR se verifican al ejecutar la operación B3; las entidades dependientes retienen sus atributos de registro tal como los define MR5. |
| `alternativas_descartadas` | Opción B: `CR-MR5-AUD-PROD`, tabla de eventos o columnas de alta/actor por migración `V3`; no se implementa sin CR separada |
| `justificacion` | REV-06A/M-5 descartó `HISTORIAL_ESTADO_PRODUCTO`; MR5 contiene `PRODUCTO` y dependencias con integridad referencial. La opción aprobada preserva la línea base física G0/MR5/F01. |
| `artefactos_afectados` | Contratos B0 REV06A (UC30/47/48), `GestionProductoService`, documentación I1-03, Issue #19 y PR #18 del repositorio aplicativo |
| `fuente_chat` | Dictamen entregado en la conversación de revisión del 31/10/2026 con `RD-UC30-001` expresamente aprobada |
| `fecha_propagacion` | `2026-10-31` |
| `pruebas` | UC30/47/48: JUnit/Testcontainers PostgreSQL, integridad MR5, unicidad `nombreNormalizado`, conservación de historia, regresión B1/B2 en SHA final del código; no son pruebas de auditoría de eventos que no existe |

## Delimitación indispensable del término «trazabilidad»

1. `PRODUCTO.idProducto` es la **identidad estable** que los registros históricos referencian. `PRODUCTO.nombreNormalizado` es **único globalmente** (incluidos inactivos), pero **no es inmutable**: UC47 autoriza modificar el nombre y actualizar su versión normalizada, manteniendo `idProducto`. La regla es no cambiar tipo/unidad si existen dependencias históricas.
2. La revisión de dependencias abarca siete tablas físicas: `DETALLE_PEDIDO`, `PRECIO_PRODUCTO`, `RECETA`, `PROMOCION_PRODUCTO`, `RECEPCION_COMPRA`, `MOVIMIENTO_STOCK_REVENTA`, `VALORACION_EXTRAORDINARIA_REVENTA`. Los Pedidos anteriores y sus detalles no se reescriben al modificar el catálogo.
3. La ejecución de UC30/47/48 requiere sesión/rol ADMINISTRADOR vigentes y revalidados transaccionalmente. **Este requisito de autorización no es evidencia persistente del actor que ejecutó cada operación**.
4. Las tablas dependientes preservan solo los campos de fecha y actor **que realmente contienen en MR5**; `RECETA` y `PROMOCION_PRODUCTO`, por ejemplo, no registran por sí mismas autor/fecha. No afirmar traza de actor/fecha para el alta, modificación o cambio de estado del maestro `PRODUCTO`: ese evento *no se materializa en MR5*.
5. Por ello, **el criterio de aceptación aprobado es integridad histórica y autorización, no auditoría de eventos**. Si se exige responder «quién, cuándo y qué valor previo/nuevo cambió», requiere Opción B mediante CR y migración autorizada. La presente RD no concede ni simula tal capacidad.
6. `activo=false` impide nuevas ventas/promociones conforme a sus flujos y validaciones; no borra relaciones ni cancela pedidos pendientes. Un Producto activo sin precio vigente continúa sin ser comercializable (UC19).

## Protocolo cooperativo de concurrencia para implementaciones posteriores

- Escritores del maestro UC30/47/48 usan `pg_advisory_xact_lock(3030047)` para serialización interna de IDs y nombres, y `SELECT PRODUCTO FOR UPDATE` para validar/actualizar una ficha existente.
- Los productores de relaciones (UC19 `PRECIO_PRODUCTO`, UC10 `RECETA`, UC24 `PROMOCION_PRODUCTO`, UC03/21 `DETALLE_PEDIDO`) deberán bloquear explícitamente `PRODUCTO FOR SHARE` y **revalidar** `activo`, `tipoProducto` y `codigoUnidadVenta` según su contrato **antes** del INSERT. Para listas, IDs ascendentes y protocolo transaccional consistente. UC08/42 debe coordinar `FOR UPDATE` si escribe stock/costo de REVENTA.
- **Precisión técnica:** PostgreSQL 17 `FOR KEY SHARE` (habitual por FK) **sí** entra en conflicto con `FOR UPDATE`; el modo que no bloquea un `FOR KEY SHARE` es `FOR NO KEY UPDATE`. El `FOR SHARE` explícito se adopta para validar las condiciones comerciales bajo protección, no porque la FK sea compatible con un `FOR UPDATE` real.
- Orden global recomendado para flujos multi-entidad: `CLIENTE → PRODUCTO (id ascendente) → INSUMO (id ascendente) → hijas`, previa conciliación de locks asesores existentes y del orden de `COBRO`/CLIENTE en UC29. El orden no es garantía frente a escritores que no adopten el protocolo.
- Antes de afirmar aislamiento con UC19/10/24/03/21, incluir pruebas de dos transacciones reales con INSERT hijo concurrente, cambio de tipo/unidad y cambio a inactivo, sin desactivar restricciones.

## Evidencia y límites

- Fuente normativa histórica anclada al commit G0 `1263ffc17bd0eb7f3c69faaa9ff5ae556cf9de7e`; esta RD es una **adenda posterior fechada** y no modifica el contenido de aquel commit.
- MR5/F01 y sus 59 tablas del modelo de referencia se mantienen sin cambios. No se aprueba `HISTORIAL_ESTADO_PRODUCTO` ni una `V3`.
- Issues y PR relacionadas: [Issue #19](https://github.com/leandrito369/ale-milanesas-app/issues/19) y [PR #18](https://github.com/leandrito369/ale-milanesas-app/pull/18).
- La aceptación funcional aprobada no equivale a B4 ni a E2E. No fusionar PR sin revisión humana y CI del último SHA.
