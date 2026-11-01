# RD-UC50-001 — Contrato del alta y modificación de Insumo (UC-50 y UC-51)

**Fecha:** 2026-11-01 · **Estado:** APROBADA · **Ámbito:** catálogo de 64 CU, Fase 4, I1-06 B3 y esquema MR-5/F01.

## Registro formal (§10.4)

| Campo | Decisión |
| --- | --- |
| `decision_id` | `RD-UC50-001` |
| `fecha` | `2026-11-01` |
| `estado` | `APROBADA` |
| `autoridad` | Decisión expresa del responsable del proyecto aportada en la sesión de conciliación y cierre de Issue #25 del 01/11/2026 |
| `regla_aprobada` | **Opción A.** UC-50 exige Administrador autenticado, `nombre`, `codigoUnidadMedida` existente, `umbralMinimo >= 0` y `nivelObjetivoReposicion > umbralMinimo`. Se verifica unicidad del nombre normalizado y se registra `INSUMO.activo=true`, `stockActual=0` y `automatizacionCompraActiva=false`. **No** se registra `SALDO_INICIAL`, `MOVIMIENTO_INSUMO`, `COSTO_INSUMO_HISTORICO` ni existencias reales en el alta: pertenecen a UC-42. UC-31 administra la activación y parámetros de reposición con posterioridad. UC-51 solo admite editar `nombre` y `codigoUnidadMedida`, impidiendo cambio de unidad cuando existen dependencias históricas, sin alterar stock, costes, movimientos, parámetros, automatización ni estado. No se modifica MR-5/F01. |
| `alternativas_descartadas` | Opción B de aceptar `automatizacionCompraActiva` en la firma del alta mediante sobrecarga, manteniendo compatibilidad. Se descarta por esta RD para I1-06; **no habría exigido por sí sola modificar MR-5**. También se descarta cualquier inventario transitorio ficticio o cambio de DDL no autorizado. |
| `justificacion` | La ficha real UC-50 solicita `automatizacionCompraActiva` al Administrador, pero se ratifica como especialización explícita para B3 que nazca desactivada: no dispara ronda de compras al registrar el maestro, y su habilitación operativa se reserva a UC-31. La modificación UC-51 protege identidad y dependencias. Evita inventar saldo físico, costos y rondas sin `PRA-01` ni UC-42. |
| `artefactos_afectados` | [Catálogo 64 CU](../../04-casos-uso/CASOS_DE_USO_64_TRES_NIVELES.docx), [Issue #25](https://github.com/leandrito369/ale-milanesas-app/issues/25), [PR #24](https://github.com/leandrito369/ale-milanesas-app/pull/24), [PR #26](https://github.com/leandrito369/ale-milanesas-app/pull/26), `GestionInsumosService`, `ConsultarInsumosUnidadesService`, actas I1-06 e I1 de integración. |
| `fuente_chat` | Dictamen y aprobación explícita de Opción A `RD-UC50-001` aportados en la conversación de 01/11/2026; incluye extractos textuales de las fichas actualizadas UC-50/UC-51. |
| `fecha_propagacion` | `2026-11-01` |
| `pruebas` | [B1 #41313357501](https://github.com/leandrito369/ale-milanesas-app/actions/runs/41313357501) y [B2 #41313357515](https://github.com/leandrito369/ale-milanesas-app/actions/runs/41313357515): **SUCCESS, 136/136** en el SHA aplicativo `c372aed91b719032efd678191c3614932b1bb62f`, Testcontainers PostgreSQL 17.11, triple equivalencia MR6, restauración 1.225 objetos. Evidencia histórica previa a la propagación documental de esta RD; el nuevo HEAD debe revalidarse. |

## Fuentes y partición de contratos

- Fuente normativa vigente: `ALE_MILANESAS_FASE_4_CU_01_A_64_TRES_NIVELES.docx`, equivalente a `docs/04-casos-uso/CASOS_DE_USO_64_TRES_NIVELES.docx`, fichas UC-50 *Registrar Insumo* y UC-51 *Modificar Insumo*. La descripción y el cotejo de la ficha fueron transcritos en la decisión aprobatoria. **No confundir con el corte anterior del 23/10/2026 de 49 CU**, en que la numeración es distinta.
- En la partición B0/B0.2/B0.3 de los 67 contratos, `UC-50` y `UC-51` pertenecen al lote **REV-01**, junto con UC-42; **REV-06B.2** abarca UC-36/10/31/52/09/64, y no permite deducir la ausencia de las fichas de alta y modificación.
- UC-51 `include` UC-36 (relación aprobada 25/10 según el dictamen). El Servicio B3 realiza la identificación/bloqueo del Insumo dentro de su transacción; **no se presenta esto como realización de un flujo HTTP/GUI de búsqueda**, pendiente de B4.

## Postcondiciones y límites ratificados

1. El valor `stockActual=0` es **exclusivamente el valor inicial**, no una columna inmutable: posteriores movimientos auténticos pueden modificarlo conforme a UC-42.
2. `automatizacionCompraActiva=false` es la **excepción aprobada** frente a la captura literal del booleano en el nivel Real de UC-50. La automatización no se habilita por defecto en el alta y UC-31 queda responsable de su cambio operativo; el alta no inicia rondas PRA-01.
3. La unicidad normalizada se asegura cooperativamente en `GestionInsumosService` (bloqueo asesor transaccional para escritores cooperantes), **no** mediante nueva restricción física UNIQUE no ratificada.
4. Para cambio de unidad UC-51, son dependencias relevantes `DETALLE_VERSION_RECETA`, `MOVIMIENTO_INSUMO`, `RECEPCION_COMPRA`, `COSTO_INSUMO_HISTORICO`, `PROVEEDOR_INSUMO` y `EPISODIO_FALTANTE`. La existencia de historia impide cambiar la unidad pero no renombrar conservando `idInsumo`.
5. Las pruebas de código B3 demuestran integridad y alcance técnico, **no** implementan UC-42 (saldo inicial real), UC-10 (crear Receta), UC-31 (modificar parámetros), B4 ni aceptación E2E.
6. Esta RD cierra la **brecha documental Issue #25**, no ordena fusionar automáticamente PR #24/#26 con `main` ni acredita la Issue #21 (auditoría primer precio).

## Evidencia y trazabilidad

- SHA combinado previamente probado: `c372aed91b719032efd678191c3614932b1bb62f`.
- B1 136/136, cobertura APP 95,5 % líneas (1126/1179) y 73,1 % ramas (624/854); artefacto `13085749543`, digest `sha256:749d01b638f62fc3ba9f24d1994ca708dea086638e93fc364d1d28731194c772`.
- B2 136/136, restauración 1225 objetos y 3 rutas MR6 equivalentes; artefacto `13085922531`, digest `sha256:c56740e4a3eb577acc0a630e0d4da135e2e29c35441d400e9078421584efe22e`.
- La aprobación normativa de esta RD se realiza **después** de esa evidencia técnica; no altera los resultados previos ni el contenido histórico de G0/MR-5/F01.
