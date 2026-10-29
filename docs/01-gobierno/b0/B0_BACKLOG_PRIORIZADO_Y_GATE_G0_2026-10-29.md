# B0.3/B0.6/B0.7 — Priorización, entregables pendientes y Gate G0

**Fecha:** 29/10/2026. **Estado:** BACKLOG CANDIDATO acorde al plan rector; B0 no habilita escribir código de dominio hasta aprobación de fuentes y reglas críticas.  
**Matriz operativa:** [64 CU / 67 operaciones](B0_MATRIZ_64_CU_67_OPERACIONES.csv). **Manifiesto:** [rutas SHA](B0_MANIFIESTO_RUTAS_SHA.csv).

## Orden de ejecución de B0 (WBS)

| ID | Prioridad | Trabajo específico | Producto | Bloqueo actual | Gate |
|---|---|---|---|---|---|
| B0.1 | P0 | Consolidar referencia canónica DOCX, commits de REV y original/corregido | Inventario y SHA, **realizado** | Aprobar qué revisión será fuente integrable | G0 |
| B0.2 | P0 | Mapear 64 CU→67 operaciones→contrato/DSS/DS | Matriz con rutas, **realizada a nivel archivos** | Cotejo semántico de firmas/pre-post/RF/RNF/IRQ por cada CU | G0 |
| B0.3 | P0 | Mapear permisos y responsabilidades por operación y acceso directo/contextual | Matriz Rol×CU y dependencias por servicio | Fuente RD-RP007 + fichas, sin asumir equivalencias históricas | G0 |
| B0.4 | P0 | Cotejar MR-5/MR-6/F01/F04, operaciones vs estructura | Informe de brechas inicial **realizado** | Atribuir cada columna/trigger/transacción al contrato exacto | G0 |
| B0.5 | P1 | Ratificar modularidad, entornos, framework, API, migración y pruebas | ADR B1 y arquitectura candidata, **borrador generado** | Decisiones técnicas | G0/G1 |
| B0.6 | P0 | Derivar primer vertical desde dependencias, pactar evidencias | Backlog de I0–I2 y acceptance tests | Requiere completar RBAC/trazabilidad | G0 |
| B0.7 | P0 | Revisión humana/academia de propuestas, RP/CR + cierre | Acta de G0 con estado y responsable | PR #9–#19 y #20 no integradas | G0 |

## Dependencias e incremento inicial (sin código nuevo en B0)

1. **I0 / B1:** ADR + esqueleto de backend con CI, base PostgreSQL de prueba que conserve MR-6 y aplique F01 de forma versionada, sin producción. Tests: arranque/migración/rebuild reproducibles.
2. **I1 / B3-B5:** autenticación interna y RBAC; Cliente/Producto/Precio/categoría; operaciones prioritarias propuestas en `UC-01/02/17/18/19/30/32/33/35/47/48/57`. No fijar orden exacto hasta mapa de dependencias completo.
3. **I2 / B3-B5:** `UC-03` pedido, `UC-34` búsqueda y `UC-43` asignación online con precio snapshot y evaluación comercial. Test: persistencia atómica y permiso por rol; capturas offline UC-03 en B7 tras aprobar S-01.
4. **I3 / B3:** `UC-10/28/05/29` recetario→preparación→entrega→cobro/caja/CC. No fusionar declaración de efectivo UC-05 con Cobro UC-29, ni anticipar efectos de reembolso.
5. Continúan I4–I7 según plan rector: Excedentes/finanzas, compras, canales/integraciones/offline y aceptación final.

## Evidencia de pruebas de B0

- **Validado aquí:** lectura de árboles Git de `main` y revisión superior, existencia de 64 CU y 67 operaciones en matriz global; para cada fila, existencia de ruta de contrato, DSS y DS en árbol de revisión; firma UC-50 corregida por lectura de contrato.
- **No ejecutado:** Draw.io visual, suite SQL MR-6 de nuevo, API, backend, pruebas de aceptación, servicios monetarios, permisos de API, migraciones, producción.
- **Evidencia histórica verificada por informe/CI existente:** MR-6 pasó pruebas PostgreSQL 17.11; es ajena a los trabajos nuevos de B0.

## Puerta G0 (estado actual)

**NO APROBADA / CIERRE PARCIAL DOCUMENTAL.** Requiere: integración controlada de la cadena de revisiones, cotejo semántico de pre/postcondiciones por CU, matriz exhaustiva de permisos, mapeo de responsabilidades y persistencia a nivel de operación, decisiones ADR ratificadas, revisión PR y firma del integrador. No declarar G0 verde por disponer de archivos enlazados.

## Entrega de responsabilidad a agentes

- **Agente documental (lectura):** cotejo por bloques de 8–12 CU, completar columnas `rf_rnf_irq`, `permisos`, `persistencia` con citas a Fase 4, RD y contratos. Si encuentra contradicción, abrir RP/Issue, no editar fuentes maestras.
- **Agente revisor independiente:** cruzar RD-RP007 y CU reales, revisar límites de snapshot, costos, stock, F04, compras y finanzas; reporte de conflictos.
- **Agente técnico en modo plan:** especificar ADR y contratos de integración sin ejecutar migraciones ni implementar lógica hasta G0.
- **Integrador humano:** escoger versión aprobada y aceptar o devolver PR de B0. Solo después delegar programación sobre línea base ratificada.

## Evidencia B0 — 29/10/2026 (decisiones y residuales)

La matriz vigente de trabajo es [B0 RBAC 0 P](B0_MATRIZ_RBAC_67_OPERACIONES_CIERRE_2026-10-29.csv), no la copia histórica. BC01/02/03 cerrados funcionalmente por RD individuales; BC04 y BC10 corregidos en contratos/índice derivados. BC05 tiene [21 observaciones](BC05_RECONCILIACION_21_REFERENCIAS_RF.csv), con propagación pendiente. BC07 tiene [15 proyecciones propuestas](BC07_PROYECCIONES_MINIMAS_15_ROL_CU.csv) que requieren ratificación antes de configurar DTO o visibilidad sensible. [Dictamen](B0_DICTAMEN_CIERRE_CONTRACTUAL_Y_SEGURIDAD_2026-10-29.md). **G0 no aprobado.**
