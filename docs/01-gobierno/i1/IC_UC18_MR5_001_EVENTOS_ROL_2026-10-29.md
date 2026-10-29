# IC-UC18-MR5-001 — Incidencia de coherencia léxica

**Fecha:** 29/10/2026. **Estado:** RESUELTA POR `RD-UC18-001`, pendiente de incorporación de PATCH a fuente revisada.  
**Fuente:** contrato UC-18 REV-02 y DS REV-02 consignaban eventos `ALTA/BAJA`; la tabla existente `EVENTO_ASIGNACION_ROL` de MR5 admite exclusivamente `ASIGNACION/REVOCACION`.
**Severidad:** incompatibilidad de contrato/aplicación física para eventos de auditoría.

## Cierre de incidencia
Adoptar exclusivamente los literales físicos canónicos `ASIGNACION` y `REVOCACION` para `EVENTO_ASIGNACION_ROL.tipoEvento`. El contrato se corrige mediante PATCH, conservando evidencia histórica en Git. **No** alterar constraint, tabla, columna, catálogo de Roles ni el SQL aprobado MR5/F01.
