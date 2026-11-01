# RD-UC19-002 — Acotamiento prospectivo de vigencias futuras de PrecioProducto

**Fecha:** 2026-11-01 · **Estado:** APROBADA · **Ámbito:** UC-19, I1-04 B3; contratos G0 REV06A, `PRECIO_PRODUCTO` / `AUDITORIA_PRECIO`, MR5/F01.

## Registro formal de decisión (§10.4)

| Campo | Contenido aprobado |
| --- | --- |
| `decision_id` | `RD-UC19-002` |
| `fecha` | `2026-11-01` |
| `estado` | `APROBADA` |
| `autoridad` | Responsable del proyecto: aprobación expresa del 01/11/2026 de **fusionar la PR #26 a main incluyendo el comportamiento actual de UC-19 sobre acortamiento de vigencias futuras**, ante la consulta que describió ambas condiciones. |
| `regla_aprobada` | Para un `PRODUCTO` ACTIVO, cuando UC19 registra un nuevo `PRECIO_PRODUCTO` cuyo `vigenteDesde` está estrictamente después del `vigenteDesde` de un precio existente no cancelado que lo cubre, puede cerrar el período anterior en ese instante aunque **el período anterior todavía no haya comenzado a regir**. El cierre conserva `idPrecio`, `precioBase`, `vigenteDesde`, `fechaHoraRegistro` y los snapshots de pedidos; solo modifica `vigenteHasta` anterior, registrando `CIERRE_VIGENCIA` con su before/after. Registra una nueva fila y su evento `MODIFICACION_PROGRAMADA`, todo atómico. Los intervalos `[desde,hasta)` permanecen sin solaparse y sin duración nula. |
| `casos_prohibidos` | No recortar un período cuyo inicio sea igual o posterior al `vigenteDesde` nuevo cuando implique solapamiento. No acortar a la misma marca temporal inicial, no escribir precios retroactivos, no reabrir una versión cancelada, no modificar un `DETALLE_PEDIDO.precioUnitarioOriginal` congelado y no registrar `CANCELACION_PROGRAMADA` sin cancelación real. |
| `alternativas_descartadas` | Prohibir en todos los casos recortar una vigencia futura ya programada; reinterpretar un recorte como cancelación; borrar/reemplazar físicamente registros programados o reconstruir precios históricos. No se requieren nuevas columnas, tablas o excepciones al CHECK de MR5. |
| `justificacion` | La regla física `ex_precio_producto_no_solape` y el CHECK de vigencia requieren historia temporal coherente. El recorte prospectivo con `CIERRE_VIGENCIA` explícito permite programar reemplazos sin destruir el intervalo original ni los precios congelados. La aprobación ratifica el comportamiento **actual**, no crea un caso de uso de cancelación de programaciones. |
| `artefactos_afectados` | [PR #26](https://github.com/leandrito369/ale-milanesas-app/pull/26), [PR #20](https://github.com/leandrito369/ale-milanesas-app/pull/20), `ActualizarPrecioVigenteService`, `PreciosProductoServiceIntegrationTest`, actas de I1-04 / I1 integrado, `PRECIO_PRODUCTO` y `AUDITORIA_PRECIO`. |
| `fuente_chat` | Pregunta al responsable: «¿aprobás fusionar la PR #26 a main, **incluyendo el comportamiento actual de UC-19 respecto del acortamiento de vigencias futuras**?»; respuesta expresa del 01/11/2026: «**Lo apruebo, sigamos**». |
| `fecha_propagacion` | `2026-11-01` |
| `pruebas` | **Gate final del HEAD fusionado:** [B1 #41318815724](https://github.com/leandrito369/ale-milanesas-app/actions/runs/41318815724) y [B2 #41318815713](https://github.com/leandrito369/ale-milanesas-app/actions/runs/41318815713) **SUCCESS 137/137 ambos**, HEAD `aca438b112573d6a69c459cd470e4a05fac42eac`; MR5/F01 fiel, triple MR6 equivalente, restore 1.225 objetos. [Merge PR #26](https://github.com/leandrito369/ale-milanesas-app/pull/26) confirmado por GitHub en `main`, SHA `fd4bd6d9dd89e43b2fdec29c49a553a3f1b15d93`. |

## Alcance exacto de la aprobación

El algoritmo actual de `ActualizarPrecioVigenteService` bloquea `PRODUCTO FOR UPDATE`, revalida al ADMINISTRADOR, consulta `PRECIO_PRODUCTO` no cancelados en orden temporal `FOR UPDATE`, normaliza precisión a microsegundos y rechaza cualquier período existente que empiece en el nuevo inicio o después y se solape con el nuevo período. Si uno anterior cubre el nuevo inicio, acorta `vigenteHasta` a ese instante y genera auditoría `CIERRE_VIGENCIA` sobre la fila original. La nueva fila se crea con `MODIFICACION_PROGRAMADA` y sus valores anterior/nuevo, en la misma transacción y bajo lock asesor de IDs.

**La decisión cubre expresamente el caso en que ese período anterior aún es futuro**, siempre que su inicio sea anterior al nuevo inicio y resulte un intervalo de duración positiva. No autoriza reinterpretar el recorte como cancelación, ni editar indiscriminadamente programaciones preexistentes.

Se coordina con [RD-UC19-001 aprobada](RD_UC19_001_AUDITORIA_PRIMER_PRECIO_2026-11-01.md), que fija el mapeo de la **primera** programación a `MODIFICACION_PROGRAMADA` con `precioAnterior=NULL`. Ninguna de las dos decisiones modifica MR5/F01 ni certifica HTTP B4 o pruebas E2E.

## Integración a main

La aprobación del responsable **incluye la integración de PR26**. La acción queda condicionada únicamente al cumplimiento efectivo de los mecanismos técnicos de GitHub: HEAD esperado sin divergencias, B1/B2 SUCCESS sobre ese SHA y ausencia de bloqueos de protección de ramas. No debe representarse como review GitHub de una persona distinta al autor ni como acreditación del tribunal.

La integración técnica I1/B3 comprende únicamente los módulos ya incluidos en PR26. **No** declara completadas las operaciones UC03/UC21 de Pedido ni UC10/42 de Receta/inventario, ni acredita los 18 BC06 o cuatro E2E UC54.

## Constatación de ejecución (01/11/2026)

GitHub confirmó el merge de PR #26 mediante método `merge` y bloqueo del SHA esperado `aca438b112573d6a69c459cd470e4a05fac42eac`. `main` avanzó a [`fd4bd6d9dd89e43b2fdec29c49a553a3f1b15d93`](https://github.com/leandrito369/ale-milanesas-app/commit/fd4bd6d9dd89e43b2fdec29c49a553a3f1b15d93), con `PR26.state=closed` y `merged=true`. Los archivos críticos en `main` fueron comparados por blob SHA con la rama validada y coinciden exactamente. Las pruebas citadas corrieron en el HEAD **antes del merge**, no se atribuye una corrida nueva al commit de integración sin evidencia adicional.

Artefactos: B1 id `13088531974`, digest `sha256:c35608dda17af431c20a120c26f7e6267d355836dffc8b747ebc88b58418e877`; B2 id `13087964504`, digest `sha256:80198c441740364b5b61153a7b95cdd4d874257c2525e609db7586b8875f9177`. No se modificaron MR5/F01. La ejecución habilita pasar a planificación de B4; no acredita E2E ni implementa UC03/21/10/42.
