# G0 — Bitácora final de las 18 fusiones de PR aprobadas

**Fecha:** 29/10/2026. **Corte canónico `main`:** `1263ffc17bd0eb7f3c69faaa9ff5ae556cf9de7e`  
**Estado:** **FUSIÓN COMPLETADA** para #9, #10–#19 y #20–#26. No incluye #7/#8, no solicitadas como parte de este cierre.

| PR | Alcance | SHA de merge |
|---|---|---|
| [#9](https://github.com/leandrito369/ale-milanesas/pull/9) | RD/RP histórico | `7ef91f4594688dc25fe436735fe23bf0d189c4b5` |
| [#10](https://github.com/leandrito369/ale-milanesas/pull/10) | REV01 UC42/50/51 | `22d22fd2a20a81b751788c06b8d861576e79da3d` |
| [#11](https://github.com/leandrito369/ale-milanesas/pull/11) | REV02 Usuarios/Seguridad | `4468dfa10d40b5dd3f40064f0d1d29e7d286d111` |
| [#12](https://github.com/leandrito369/ale-milanesas/pull/12) | REV03 Compras/Cotizaciones | `abb885bcb1578c6c57b45fdf880619958c9bbb6f` |
| [#13](https://github.com/leandrito369/ale-milanesas/pull/13) | REV04 Pedidos/Entregas | `941a1dfbb2ca79a93ccd5585689c3db6a3d66035` |
| [#14](https://github.com/leandrito369/ale-milanesas/pull/14) | REV05 Finanzas | `b42a6ed7359100a6e2930ca5f36cc8479bb63c11` |
| [#15](https://github.com/leandrito369/ale-milanesas/pull/15) | REV06A Comercial/Promociones | `d1784614f9fc53203b71d522e39ec4a83d53066b` |
| [#16](https://github.com/leandrito369/ale-milanesas/pull/16) | Auditoría transversal 54 contratos | `1d8ba1404fa7523a43ce9e7075fd502215b5b328` |
| [#17](https://github.com/leandrito369/ale-milanesas/pull/17) | REV06B 13 contratos restantes | `9b9be98b6d73316ba09515a9dbe748b2e8e2d9d6` |
| [#18](https://github.com/leandrito369/ale-milanesas/pull/18) | REV06B1 Clientes/Categoría | `62dd5e07919a30e3be7ec63f49362318a7a4f50f` |
| [#19](https://github.com/leandrito369/ale-milanesas/pull/19) | REV06B2 Recetas/Inventario | `14fe6a96f74579d57fb90a42ee61fe347a3dfda5` |
| [#20](https://github.com/leandrito369/ale-milanesas/pull/20) | Plan rector y agentes | `44c70dc71f9ba101237427faf38feb5c1f0ea53e` |
| [#21](https://github.com/leandrito369/ale-milanesas/pull/21) | B0 Inventario 64 CU/67 operaciones | `42148986651ea0be0d76f6066c69b83c9c5f9e9f` |
| [#22](https://github.com/leandrito369/ale-milanesas/pull/22) | B0 RBAC BC01–03 | `c5cd093f49360b8af6ec6d41b841b29bc691c40e` |
| [#23](https://github.com/leandrito369/ale-milanesas/pull/23) | B0 BC05/07/09 | `4f88410191c1995e9530693ee80ed0a42eb068d2` |
| [#24](https://github.com/leandrito369/ale-milanesas/pull/24) | B0 Mapeo técnico 67 y ADR | `c146fcb34af0762dc8f18f792d478ebbe15bfcef` |
| [#25](https://github.com/leandrito369/ale-milanesas/pull/25) | B0 ADR ratificadas y CR F04 | `9802f382eff99371eda547a0d8f742aa8f435e53` |
| [#26](https://github.com/leandrito369/ale-milanesas/pull/26) | G0 expediente y fuentes preliminares | `1263ffc17bd0eb7f3c69faaa9ff5ae556cf9de7e` |

## Protocolo ejecutado

1. Comparación de cada PR con su base, revisión de rutas/alcance y reservas declaradas.
2. Ratificación por el responsable de inspección de diagramas y contratos de #10–#19. Se dejaron visibles sus actas históricas; su cierre para G0 no es certificación externa de la materia.
3. Cambio a base `main` y conversión de Draft a Ready **solo después** de la autorización, en el orden #10→#19; verificación `mergeable=clean` y SHA de cabeza esperado antes de cada merge.
4. Gobierno #20→#26 fusionado en orden, con comparación del alcance y conservación de contratos B0 como **versiones derivadas**.
5. Verificación del corte `main` `1263ffc17bd0eb7f3c69faaa9ff5ae556cf9de7e` y del manifiesto previo: **402/402 blobs idénticos en el árbol integrado**, 67 operaciones, 64 CU, 40 contratos B0 preferentes, 27 REV.

**Nota:** el primer intento de merge #24 de una interacción anterior había sido bloqueado; una llamada de merge posterior, tras la nueva autorización de cierre y revisión de la PR limpia, se completó normalmente con SHA `c146fcb34af0762dc8f18f792d478ebbe15bfcef`. No se modificó `main` mediante comandos alternativos para eludir aquella denegación.

## Evidencias no confundibles

- Inspección visual: **declarada por el responsable**, no duplicada técnicamente por el asistente.
- GitHub CI de las PR precedentes: pruebas de **documentos**; la nueva CI final se registrará de forma independiente.
- MR6: evidencia SQL sobre Postgres en laboratorio, **no** pruebas de servicios.
- BC06: **0/18** de implementación; se mantienen en backlog B3/B4/B6/B8.
- CR-B0-F04-001: abierta hasta decisión física.
- #7/#8: siguen abiertas; no se cambia su estado ni se supone que integren G0.

**Fuentes oficiales:** [acta RD-B0-G0-001](RD_B0_G0_001_CIERRE_LINEA_BASE_2026-10-29.md) y [manifiesto SHA canónico](G0_MANIFIESTO_CANONICO_67_OPERACIONES_2026-10-29.csv).
