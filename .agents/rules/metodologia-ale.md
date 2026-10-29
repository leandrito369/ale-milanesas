---
trigger: always_on
description: "Reglas metodológicas persistentes para Antigravity en Ale Milanesas"
---
# Regla de proyecto Ale Milanesas

- Leé `AGENTS.md` antes de cualquier tarea y seguí `docs/01-gobierno/PLAN_RECTOR_IMPLEMENTACION_2026-10-29.md`, `docs/01-gobierno/B0_LINEA_BASE_IMPLEMENTACION_2026-10-29.md` y `docs/06-arquitectura/GUIA_DELEGACION_AGENTES_2026-10-29.md`.
- Respetá Proceso Unificado adaptado: requisitos/CU → DSS → DS → contrato → servicio → persistencia/API/interfaz → prueba reproducible.
- No inferir que los DSS, DS y contratos de los 64 CU están **en el repositorio** hasta inventariarlos. No inventar decisiones ausentes.
- No renumerar CU, no usar un diagrama UML de CU rechazado, no alterar SQL histórico MR-6 y no confundir validación de BD con aplicación completa.
- Proponer cambios mediante rama+PR; registrar fuentes, controles, evidencia ejecutada/NO EJECUTADA y decisiones pendientes. No exponer secretos ni tocar producción.
