# Acta de consolidación documental B0 — BC-01, BC-02, BC-03 y BC-04

**Proyecto:** Sistema de Gestión para Ale Milanesas (UNaM-FCEQyN)  
**Fecha:** 29/10/2026  
**Estado:** BC-01/02/03 APROBADOS FUNCIONALMENTE por el responsable; BC-04 CORRECCIÓN EDITORIAL de RF-15 contrastada con Fase 4. Contratos derivados B0 publicados en PR; **NO** implica fusión en `main` o pruebas de software.

| Hallazgo | Operación | ADMIN | VENDEDOR | Referencia |
|---|---|---|---|---|
| BC-01 | UC-14 consultarCuentaCorriente | X | D | [RD-B0-BC01](RD_B0_BC01_2026-10-29.md) |
| BC-02 | UC-03 reprogramarFechaRepartoPedido | X | D | [RD-B0-BC02](RD_B0_BC02_2026-10-29.md) |
| BC-03 | UC-29 anularCobroManual | D | X | [RD-B0-BC03](RD_B0_BC03_2026-10-29.md) |
| BC-04 | UC-22 registrarMovimientoCaja / UC-23 consultarLibroDiario | D | NR | `RF-15` vigente; `RF-09` solo antecedente de corrección |

**Integridad:** el paso de cuatro celdas P a ninguna se realiza modificando sólo BC-01:ADMIN, BC-02:ADMIN y BC-03:ADMIN/VENDEDOR; los demás permisos, roles y modos directos/contextuales quedan conservados. La distribución final está en [matriz RBAC](B0_MATRIZ_RBAC_67_OPERACIONES_CIERRE_2026-10-29.csv) y debe verificarse antes de fusionar. 

**Preservación:** DOCX Fase4, archivos REV en ramas #10–#19, DSS/DS, SQL MR-5/MR-6 y diagramas originales **sin cambios**; copias corregidas en `docs/08-diagramas/consolidacion-b0/`. BC-05, BC-07 y BC-10 se documentan en dictamen de cierre residual B0, sin introducir decisiones comerciales nuevas.
