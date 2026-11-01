# RD-UC19-001 — Codificación de la auditoría del primer PrecioProducto

**Fecha de propuesta:** 2026-11-01 · **Estado:** PROPUESTA — PENDIENTE DE APROBACIÓN EXPRESA DEL RESPONSABLE. **No es una RD aprobada ni cierra por sí sola la Issue #21.** Ámbito UC-19/UC-20 B3, MR5/F01, Fase 4 / G0.

## Registro de decisión propuesto (§10.4)

| Campo | Contenido |
| --- | --- |
| `decision_id` | `RD-UC19-001` |
| `fecha` | `2026-11-01` |
| `estado` | `PROPUESTA_PENDIENTE_APROBACION` |
| `autoridad` | Responsable del proyecto: se solicita ratificación expresa; análisis técnico de implementación presentado para su decisión |
| `regla_propuesta` | Para la **primera** fila de `PRECIO_PRODUCTO` de un Producto, UC-19 registra de forma transaccional un evento en `AUDITORIA_PRECIO` con `tipoEvento='MODIFICACION_PROGRAMADA'`, `precioAnterior=NULL`, `precioNuevo` igual al importe nuevo positivo, `vigenteDesdeAnterior=NULL`, `vigenteDesdeNuevo` igual al inicio elegido, `vigenteHastaAnterior=NULL` y `vigenteHastaNuevo` igual al fin informado o `NULL`. Conserva `idPrecio`, `idUsuario` Administrador autenticado, `fechaHoraEvento` del reloj PostgreSQL y `PRECIO_PRODUCTO.fechaHoraRegistro` real. El tipo representa **alta de una programación de precio**, sin afirmar que existió un precio anterior. |
| `alternativas_descartables_si_se_aprueba` | Incorporar `ALTA_PRECIO` por CR/MR5 y ajuste del CHECK `ck_auditoria_precio_0` (no necesario para esta propuesta y **prohibido sin CR**); inventar precioAnterior ficticio; registrar `CANCELACION_PROGRAMADA` o `CIERRE_VIGENCIA` sin una fila anterior efectivamente afectada; omitir la auditoría del primer precio. |
| `justificacion` | El contrato G0 de `actualizarPrecioVigente` exige constancia de auditoría en cada nueva vigencia e incluye primer precio. MR5 permite únicamente los tres tipos `MODIFICACION_PROGRAMADA`, `CANCELACION_PROGRAMADA`, `CIERRE_VIGENCIA`, y permite `precioAnterior=NULL`. La semántica propuesta satisface la obligación de traza sin nuevas tablas ni tipo inventado; requiere decisión funcional porque el literal «modificación» puede inducir a interpretar un precio anterior. |
| `artefactos_afectados` | `docs/08-diagramas/consolidacion-b0/CONTRATOS_REV06A_NUEVE_OPERACIONES_B0_ACTUALIZADO.md`; `PRECIO_PRODUCTO` y `AUDITORIA_PRECIO` MR5; [Issue #21](https://github.com/leandrito369/ale-milanesas-app/issues/21), [PR #26](https://github.com/leandrito369/ale-milanesas-app/pull/26), `ActualizarPrecioVigenteService`, `PreciosProductoServiceIntegrationTest` y documentación I1-04. |
| `fuente_chat` | Solicitud del 01/11/2026 de revisar y resolver Issue #21; **no constituye aprobación expresa de esta opción concreta**. |
| `fecha_propagacion` | Pendiente tras ratificación. |
| `pruebas` | Suite integrada B1/B2 en SHA `9121b4d7ee425daf880105337c2fea30f026708f` **137/137 SUCCESS** antes del refuerzo de aserciones; se verificará nuevamente SHA actualizado. La prueba UC19 `uc19PrimerPrecioFuturoEsProgramadoYAuditado` valida el evento, usuario, marcas temporales y anteriores nulos. |

## Fuentes y evidencia verificable

1. Contrato G0 REV06A, **§5 `actualizarPrecioVigente` UC-19**, SHA normativo `1263ffc17bd0eb7f3c69faaa9ff5ae556cf9de7e`: «Registrar el primer precio o una nueva vigencia del precio base ... conservando historia y auditoría»; postcondición exige `PrecioProducto` y evento `AuditoriaPrecio`, sin precisar subtipo de evento de primer precio.
2. V1 MR5 `PRECIO_PRODUCTO`: `precioBase NUMERIC(18,4)`, `vigenteDesde TIMESTAMPTZ`, `vigenteHasta TIMESTAMPTZ` opcional y CHECK `vigenteHasta > vigenteDesde`. `AUDITORIA_PRECIO` contiene `precioAnterior NUMERIC(18,4)` **nullable**; `ck_auditoria_precio_0` limita tipos a `MODIFICACION_PROGRAMADA`, `CANCELACION_PROGRAMADA` y `CIERRE_VIGENCIA`. No existe `ALTA_PRECIO`.
3. PR26: `ActualizarPrecioVigenteService` registra primera fila de precio y auditoría atómicamente, `@Transactional`, bloqueo `PRODUCTO FOR UPDATE`, solo ADMINISTRADOR, tiempo PostgreSQL, prevención de solapes y normalización a microsegundos. La prueba `uc19PrimerPrecioFuturoEsProgramadoYAuditado` verifica ausencia de datos previos y referencia/actor/fecha reales.
4. UC-20 debe **mostrar el tipo físico existente y los campos nulos**, sin etiquetar artificialmente un evento `ALTA_PRECIO` no persistido. La interfaz futura puede explicar «primera programación» por `precioAnterior IS NULL` si la RD se ratifica.

## Alcance exacto y reservas

- Si hay un precio anterior que **efectivamente se acorta**, corresponde registrar `CIERRE_VIGENCIA` con el antes/después, y `MODIFICACION_PROGRAMADA` para el nuevo `idPrecio`; no reescribir el precio ni el snapshot congelado de `DETALLE_PEDIDO`.
- La comparación de vigencias usa `[vigenteDesde, vigenteHasta)` a precisión `TIMESTAMPTZ` PostgreSQL. Fecha de registro, evento de auditoría e inicio de vigencia no son intercambiables.
- Los eventos `CANCELACION_PROGRAMADA` quedan reservados para una **operación real de cancelación futura** con su contrato y validaciones; no se crean para simular el primer precio. La implementación UC19 existente no expone esa operación.
- La interpretación de cuándo puede cerrarse una programación futura todavía no iniciada debe cotejarse en el gate funcional de UC19; esta decisión propuesta solo ratifica el **primer evento**.
- La aprobación de esta RD **no equivale a revisión humana de código, autorización de merge a main, cierre total de I1 ni habilitación HTTP B4/E2E**.

## Pasos para ratificar

**Responsable:** decidir expresamente «Apruebo RD-UC19-001, opción de mapeo MODIFICACION_PROGRAMADA con precioAnterior=NULL» o solicitar corrección/CR. Tras aprobación: actualizar estado a APROBADA, registrar autoridad/fecha de propagación, cerrar [Issue #21](https://github.com/leandrito369/ale-milanesas-app/issues/21), enlazarla con PR26 y volver a validar su SHA final. Sin esa aprobación, la Issue permanece ABIERTA.
