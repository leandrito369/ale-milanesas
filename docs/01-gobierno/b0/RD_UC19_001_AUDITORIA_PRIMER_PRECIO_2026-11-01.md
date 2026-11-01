# RD-UC19-001 — Codificación de la auditoría del primer PrecioProducto

**Fecha de aprobación:** 2026-11-01 · **Estado:** APROBADA — Opción `MODIFICACION_PROGRAMADA` con `precioAnterior=NULL`, ratificada por el responsable el 01/11/2026. Ámbito UC-19/UC-20 B3, MR5/F01, Fase 4 / G0.

## Registro de decisión aprobada (§10.4)

| Campo | Contenido |
| --- | --- |
| `decision_id` | `RD-UC19-001` |
| `fecha` | `2026-11-01` |
| `estado` | `APROBADA` |
| `autoridad` | Responsable del proyecto; aprobación literal en la conversación de 01/11/2026: «Apruebo RD-UC19-001, opción de mapeo MODIFICACION_PROGRAMADA con precioAnterior=NULL» |
| `regla_aprobada` | Para la **primera** fila de `PRECIO_PRODUCTO` de un Producto, UC-19 registra de forma transaccional un evento en `AUDITORIA_PRECIO` con `tipoEvento='MODIFICACION_PROGRAMADA'`, `precioAnterior=NULL`, `precioNuevo` igual al importe nuevo positivo, `vigenteDesdeAnterior=NULL`, `vigenteDesdeNuevo` igual al inicio elegido, `vigenteHastaAnterior=NULL` y `vigenteHastaNuevo` igual al fin informado o `NULL`. Conserva `idPrecio`, `idUsuario` Administrador autenticado, `fechaHoraEvento` del reloj PostgreSQL y `PRECIO_PRODUCTO.fechaHoraRegistro` real. El tipo representa **alta de una programación de precio**, sin afirmar que existió un precio anterior. |
| `alternativas_descartadas` | Incorporar `ALTA_PRECIO` por CR/MR5 y ajuste del CHECK `ck_auditoria_precio_0` (descartado en esta decisión y **prohibido sin CR**); inventar precioAnterior ficticio; registrar `CANCELACION_PROGRAMADA` o `CIERRE_VIGENCIA` sin una fila anterior efectivamente afectada; omitir la auditoría del primer precio. |
| `justificacion` | El contrato G0 de `actualizarPrecioVigente` exige constancia de auditoría en cada nueva vigencia e incluye primer precio. MR5 permite únicamente los tres tipos `MODIFICACION_PROGRAMADA`, `CANCELACION_PROGRAMADA`, `CIERRE_VIGENCIA`, y permite `precioAnterior=NULL`. La semántica aprobada satisface la obligación de traza sin nuevas tablas ni tipo inventado y aclara que «modificación» no implica un precio anterior cuando `precioAnterior IS NULL`. |
| `artefactos_afectados` | `docs/08-diagramas/consolidacion-b0/CONTRATOS_REV06A_NUEVE_OPERACIONES_B0_ACTUALIZADO.md`; `PRECIO_PRODUCTO` y `AUDITORIA_PRECIO` MR5; [Issue #21](https://github.com/leandrito369/ale-milanesas-app/issues/21), [PR #26](https://github.com/leandrito369/ale-milanesas-app/pull/26), `ActualizarPrecioVigenteService`, `PreciosProductoServiceIntegrationTest` y documentación I1-04. |
| `fuente_chat` | Aprobación literal recibida del responsable el 01/11/2026: «Apruebo RD-UC19-001, opción de mapeo MODIFICACION_PROGRAMADA con precioAnterior=NULL. Sigamos». |
| `fecha_propagacion` | `2026-11-01` — documento normativo, Issue #21 y actas de PR #26. |
| `pruebas` | Suite B1/B2 sobre `cc2f6dc5ed37229f0e4cb31baf667fe002a2ee6a` **137/137 SUCCESS** en cada pipeline ([B1 #41316787755](https://github.com/leandrito369/ale-milanesas-app/actions/runs/41316787755) y [B2 #41316787756](https://github.com/leandrito369/ale-milanesas-app/actions/runs/41316787756)); repetir si cambia HEAD. La prueba UC19 `uc19PrimerPrecioFuturoEsProgramadoYAuditado` valida el evento, usuario, marcas temporales y anteriores nulos. |

## Fuentes y evidencia verificable

1. Contrato G0 REV06A, **§5 `actualizarPrecioVigente` UC-19**, SHA normativo `1263ffc17bd0eb7f3c69faaa9ff5ae556cf9de7e`: «Registrar el primer precio o una nueva vigencia del precio base ... conservando historia y auditoría»; postcondición exige `PrecioProducto` y evento `AuditoriaPrecio`, sin precisar subtipo de evento de primer precio.
2. V1 MR5 `PRECIO_PRODUCTO`: `precioBase NUMERIC(18,4)`, `vigenteDesde TIMESTAMPTZ`, `vigenteHasta TIMESTAMPTZ` opcional y CHECK `vigenteHasta > vigenteDesde`. `AUDITORIA_PRECIO` contiene `precioAnterior NUMERIC(18,4)` **nullable**; `ck_auditoria_precio_0` limita tipos a `MODIFICACION_PROGRAMADA`, `CANCELACION_PROGRAMADA` y `CIERRE_VIGENCIA`. No existe `ALTA_PRECIO`.
3. PR26: `ActualizarPrecioVigenteService` registra primera fila de precio y auditoría atómicamente, `@Transactional`, bloqueo `PRODUCTO FOR UPDATE`, solo ADMINISTRADOR, tiempo PostgreSQL, prevención de solapes y normalización a microsegundos. La prueba `uc19PrimerPrecioFuturoEsProgramadoYAuditado` verifica ausencia de datos previos y referencia/actor/fecha reales.
4. UC-20 debe **mostrar el tipo físico existente y los campos nulos**, sin etiquetar artificialmente un evento `ALTA_PRECIO` no persistido. La interfaz futura puede explicar «primera programación» por `precioAnterior IS NULL` conforme a la RD aprobada.

## Alcance exacto y reservas

- Si hay un precio anterior que **efectivamente se acorta**, corresponde registrar `CIERRE_VIGENCIA` con el antes/después, y `MODIFICACION_PROGRAMADA` para el nuevo `idPrecio`; no reescribir el precio ni el snapshot congelado de `DETALLE_PEDIDO`.
- La comparación de vigencias usa `[vigenteDesde, vigenteHasta)` a precisión `TIMESTAMPTZ` PostgreSQL. Fecha de registro, evento de auditoría e inicio de vigencia no son intercambiables.
- Los eventos `CANCELACION_PROGRAMADA` quedan reservados para una **operación real de cancelación futura** con su contrato y validaciones; no se crean para simular el primer precio. La implementación UC19 existente no expone esa operación.
- La interpretación de cuándo puede cerrarse una programación futura todavía no iniciada debe cotejarse en el gate funcional de UC19; esta decisión aprobada solo ratifica el **primer evento**.
- Esta RD **no equivale a revisión humana de código, autorización de merge a main, cierre total de I1 ni habilitación HTTP B4/E2E**.

## Aprobación y cierre de reserva

El responsable aprobó expresamente `RD-UC19-001` en la conversación del **01/11/2026**. La decisión ya no está pendiente. Se ratifica que el primer registro en `PRECIO_PRODUCTO` tendrá auditoría `MODIFICACION_PROGRAMADA` con `precioAnterior=NULL`, `precioNuevo` informado y marcas anteriores nulas, sin inventar un evento `ALTA_PRECIO`. Se mantiene `CIERRE_VIGENCIA` solo cuando se acorta un período efectivamente existente y `CANCELACION_PROGRAMADA` solo para una operación real posterior.

**Propagación:** [Issue #21](https://github.com/leandrito369/ale-milanesas-app/issues/21) (cierre `completed`), [PR #26](https://github.com/leandrito369/ale-milanesas-app/pull/26) (actas y evidencia final B1/B2). El contenido de esta RD no modifica MR5/F01 ni autoriza el merge de PR #26. La política exacta de acortar programaciones futuras sigue como revisión funcional separada.
