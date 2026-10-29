# BC-05 — Cotejo de referencias RF entre Fase 4 y contratos revisados

**Fecha:** 29/10/2026 · **Estado:** COTEJO DE METADATOS DOCUMENTADO, PROPAGACIÓN PARCIAL. **No se modifica el significado de RF.**

El archivo [BC05_RECONCILIACION_21_REFERENCIAS_RF.csv](BC05_RECONCILIACION_21_REFERENCIAS_RF.csv) identifica las **21 operaciones** con RF de ficha no presentes literalmente en el apartado de referencias del contrato correspondiente, según comparación de los tres niveles de Fase4 con contratos PR #19 (`64af3c3baa571c2d512242e396267a31f0da3efd`). Los RF se incluyen tal como figuran en Fase4; no se deducen requisitos nuevos.

**Correcciones ya publicadas en contratos derivados B0:** UC-22/23 referencia `RF-15` en lugar de `RF-09`; UC-29 anulación asocia `RF-06, RF-15, RF-20` de su ficha y `RF-12` exclusivamente como referencia complementaria a la evaluación UC-15. La ficha UC-29 no cambia; el alta de Cobro conserva su contrato anterior, señalada en la matriz para propagación posterior.

**Clasificación:** las operaciones principales con RF ausentes o adicionales requieren corrección de metadatos en sus lotes originales; algunas operaciones secundarias como `UC-03/reprogramar` no afectan la política de precios original y no deben incorporar RF como comportamiento nuevo. En los grupos REV-06A y REV-01, varios contratos omiten el prefijo RF en referencias aun cuando detallan el CU/objetivo: se ofrece una *adenda de trazabilidad*, no se editan originales sin aprobación. 

**Dictamen:** BC-05 queda **RECONCILIADO_EN_ADENDA** con 21 filas auditables, pero **NO cerrado por propagación completa a todos los contratos**; para cerrar, un integrador debe validar que la adenda sea autoridad documental suficiente o aprobar correcciones editoriales de los otros lotes. No prometer que 21 discrepancias de RF sean defectos funcionales.
