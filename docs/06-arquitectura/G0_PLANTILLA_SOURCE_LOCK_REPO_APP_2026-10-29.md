# Plantilla source-lock.md — REQUIERE G0 Y SHA DE FUENTE

**Estado:** SOLO PLANTILLA en repositorio documental, no es source-lock activo de la app. No colocar `APROBADO` hasta acta G0.

| Campo | Valor a completar tras integración controlada |
|---|---|
| `source_repo` | `https://github.com/leandrito369/ale-milanesas` |
| `source_commit` | **PENDIENTE COMMIT CANÓNICO DE G0** |
| `g0_acta` | **PENDIENTE ACTA APROBADA** |
| `g0_state` | **BLOQUEADO** |
| `source_manifest` | `docs/01-gobierno/b0/G0_MANIFIESTO_67_OPERACIONES_FUENTES_INMUTABLES_2026-10-29.csv` como antecedente; regenerar con SHA canónico |
| `adr_aprobadas` | ADR-B1-01/02/03/04/06 (29/10/2026) |
| `adr_pendiente` | ADR-B1-05 y CR-B0-F04-001 |
| `rbac` | 67 operaciones, 0 P / 536 celdas, 15 proyecciones BC07 |
| `repo_implementacion` | `https://github.com/leandrito369/ale-milanesas-app` |

Para cada PR de app, agregar `CU`, `operacion`, `source_commit`, `contrato_path`, `dss_path`, `ds_path`, `RD/CR`, `MR5/migracion`, `pruebas` y `evidencia`. Nunca vincular a la rama `main` fluctuante ni al encabezado de una PR Draft como si fuera aprobada.

**Habilitantes:** decisión de responsable sobre G0-D01/D03/D04/D05, integración revisada, acto formal G0 y permisos GitHub App habilitados en el nuevo repositorio.
