# Acta de evaluación Gate G0 — Preparada para aprobación del responsable

**Proyecto:** Sistema de Gestión para Ale Milanesas (UNaM–FCEQyN)  
**Fecha:** 29/10/2026  
**ID:** G0-2026-10-29  
**Estado del acta:** **BORRADOR PARA DECISIÓN — G0 NO APROBADO**. No es constancia de aprobación ni de merge.

## Antecedentes ratificados que no requieren nueva autorización

64 CU/67 operaciones, RD-B0-BC01/02/03/05/07, BC09 y permisos 0 P. ADR-B1-01/02/03/04/06 aprobadas por RD de arquitectura, ADR-B1-05 separada en CR-B0-F04-001. Plan rector B0–B10 adoptado; 60 tablas MR5 y MR6 evidencias SQL de PostgreSQL 17.11 **sin aplicación**. Repositorio `ale-milanesas-app` creado por el responsable.

## Decisiones sometidas a aprobación para cerrar G0

| ID | Propuesta concreta | Estado |
|---|---|---|
| **G0-D01** | Aceptar como **paquete candidato canónico** las 67 filas de [manifiesto de referencias inmutables](G0_MANIFIESTO_67_OPERACIONES_FUENTES_INMUTABLES_2026-10-29.csv): Fase4 DOCX `ccf4030438f48a9ac39e305a9e73a1bfbdc61545`, DSS/DS `64af3c3baa571c2d512242e396267a31f0da3efd`, 40 contratos consolidados B0 `56a9fb2cff90bad58fca5d91b4a3abbbc339b8e7` y 27 contratos REV `64af3c3baa571c2d512242e396267a31f0da3efd`, sujetos a revisión e integración de PR #9–#25. Una vez fusionados, fijar nuevo SHA/tag canónico. | **PENDIENTE FIRMA** |
| **G0-D03** | Aprobar priorización `I0 → I1 → I2 → I3 → I4–I7` del [backlog B0](B0_BACKLOG_I0_I1_PRIMER_VERTICAL_2026-10-29.md), con primer vertical `Pedido → Asignación → Preparación → Entrega → Cobro`. No recorta los 64 CU. | **PENDIENTE FIRMA** |
| **G0-D04** | Aprobar QA progresivo: 18 escenarios BC-06 se ejecutan contra servicios reales en B3/B4/B6 y regresión B8, hoy `0/18`; pruebas documentales B0 no sustituyen API/E2E/BD. | **PENDIENTE FIRMA** |
| **G0-D05** | Aprobar control de fuente DSS/DS/contrato, permisos y datos, MR, casos alternativos y diseño transaccional **antes de cada PR de implementación**, bloqueando solo la operación afectada si falta fuente/CR. | **PENDIENTE FIRMA** |
| **G0-D02** | Cinco ADR ratificadas (B1-01/02/03/04/06), B1-05 no ratificada, CR F04 pendiente. | **YA RATIFICADA** |

## Condiciones de salida y reservas

- Aun con la decisión humana sobre D01/03/04/05, **G0 no se declara integrado** mientras las PR de fuente y gobierno permanezcan sin revisar/fusionar y no exista un **commit/tag canónico** de documentación.
- Si se desea usar un **G0 condicionado** a revisión de PR, se necesita una **decisión expresa separada** que enumere excepciones aceptadas y prohíba implementar cada CU sin validar su DS/contrato. Este borrador **no concede** ese permiso.
- [Plan de integración](G0_PLAN_INTEGRACION_CONTROLADA_PR_2026-10-29.md), [dictamen de fuentes y seguridad](G0_DICTAMEN_APTITUD_CIERRE_2026-10-29.md) y [alta del repo app](G0_ALTA_REPO_IMPLEMENTACION_2026-10-29.md).
- `ale-milanesas-app` está creado pero el acceso de escritura del GitHub App sigue pendiente, además de G0. No se inició B1.

## Resolución final

**Pendiente de consignar por el responsable del proyecto** la aceptación de D01/D03/D04/D05 y la decisión de integración. No inventar firma, estado ni fecha de aprobación.

---

## Adenda de cierre (prevalece sobre el estado BORRADOR anterior)

**29/10/2026:** el responsable **ratificó G0-D01/D03/D04/D05**, mantenida D02 aprobada, y declaró inspeccionados y aprobados los lotes #10–#19. Integradas las PR #9, #10–#19 y #20–#26 en orden, con corte `1263ffc17bd0eb7f3c69faaa9ff5ae556cf9de7e`. Esta acta era **borrador histórico**; la **acta vigente de aprobación documental** es [RD-B0-G0-001](RD_B0_G0_001_CIERRE_LINEA_BASE_2026-10-29.md), y la [matriz de fuentes vigente](G0_MANIFIESTO_CANONICO_67_OPERACIONES_2026-10-29.csv) reemplaza a la candidata. BC06 pruebas reales y CR F04 siguen pendientes.
