# G0 — Dictamen técnico de aptitud de la línea base y pendientes de aprobación

**Proyecto:** Sistema de Gestión para Ale Milanesas (UNaM–FCEQyN)  
**Fecha de corte:** 29/10/2026. **Estado:** **LISTO PARA REVISIÓN DE G0, PERO G0 NO APROBADO**. Este informe no constituye la firma del responsable ni crea código.

## Evidencia verificada en GitHub

- `ale-milanesas`: ramas principales de análisis/linea base; PR #20–#25 **abiertas, sin merge y sin revisiones aprobatorias** al cotejo. La cadena de revisión #10–#19 permanece **draft** (PR #19 sobre #18), sin integración en `main`.
- **64 CU/67 operaciones**: [manifiesto de fuente por operación](G0_MANIFIESTO_67_OPERACIONES_FUENTES_INMUTABLES_2026-10-29.csv) verificó 67 rutas de DSS, DS y contrato contra árboles Git existentes; **40 operaciones** con contrato derivado B0 y **27** con contrato REV propuesto. Los 67 tienen fuente de CU Fase 4 en `main`. **SHA de blob Git** identifica contenido, no sustituye SHA-256 ni revisión semántica del diagrama.
- **Base Fase 4:** `ccf4030438f48a9ac39e305a9e73a1bfbdc61545:docs/04-casos-uso/CASOS_DE_USO_64_TRES_NIVELES.docx` y sus RD posteriores; DSS/DS de `64af3c3baa571c2d512242e396267a31f0da3efd`; contratos B0 de `56a9fb2cff90bad58fca5d91b4a3abbbc339b8e7` cuando existen, o contratos REV de `64af3c3baa571c2d512242e396267a31f0da3efd` para el resto. **Candidato a congelar en G0**, aún sin ratificación final del responsable ni merge a `main`.
- **RBAC BC01–03:** 0 P/536 celdas, 67 operaciones; **BC05** 21 RF propagadas; **BC07** 15 proyecciones ratificadas; BC09 regla explícita; BC06 18 casos de aplicación **NO EJECUTADOS**.
- Arquitectura: **ADR B1-01/02/03/04/06 RATIFICADAS** por RD-B0, **B1-05 sujeta a CR-B0-F04-001**. Modelo relacional MR3/MR5: 60 tablas, 453 atributos, 125 FK; MR6 pasó pruebas puntuales PostgreSQL 17.11. No aplicación instalada.
- CI documental anterior: **13/13 tests** en [workflow de B0](https://github.com/leandrito369/ale-milanesas/actions/runs/40912486584). Este informe y sus artefactos deberán pasar CI adicional de validación del manifiesto.
- Repositorio de programación **ya existe:** [`leandrito369/ale-milanesas-app`](https://github.com/leandrito369/ale-milanesas-app), `main` inicial `7c7dfaec31f91bf5d9e312668f0f403f0fb30adf`, `README.md` solamente. **Sin código ni PR B1**.
- **Bloqueo de conector:** la instalación de GitHub #175453350 tiene `repository_selection=selected`; `ale-milanesas-app` NO figura entre sus repositorios instalados y la creación de una rama fue rechazada con HTTP 403 `Resource not accessible by integration`. **No intentar subir a main como alternativa.** Configuración: [instalación GitHub](https://github.com/settings/installations/175453350) → configurar repositorios seleccionados → agregar `ale-milanesas-app`.

## Criterios del Gate G0

| Control | Dictamen a 29/10/2026 | Qué falta para G0 definitivo |
|---|---|---|
| **G0-D01 Fuentes canónicas** | **MANIFIESTO VERIFICADO, NO RATIFICADO COMO PAQUETE DEFINITIVO** | Aceptar el conjunto de commits preferentes y revisar/ordenar integraciones PR #9–#25, preservando el original y las RD posteriores |
| **G0-D02 Arquitectura** | **RESUELTO** | RD-B0 de las cinco ADR ratificadas; B1-05 no es parte del alcance físico aprobado |
| **G0-D03 Backlog y prioridades** | **PREPARADO, SIN FIRMA ESPECÍFICA** | Responsable acepta I0–I3, primer recorrido Pedido→Entrega→Cobro, manteniendo los 64 CU en el alcance global |
| **G0-D04 QA** | **PLAN PROPUESTO, SIN FIRMA ESPECÍFICA** | Aceptar ejecución por fases de BC06 18 pruebas reales (0 ejecutadas hoy), CI documental como evidencia distinta; fallos obligan corrección |
| **G0-D05 Revisiones DS/Contrato** | **PROTOCOLO PROPUESTO, SIN FIRMA ESPECÍFICA** | Aceptar inspección por cada PR de código antes de implementar cada operación; verificar mensajes DS, contrato, RBAC, tablas/columnas, prueba |
| **Integración** | **PR #9–#25 sin fusionar**, diseño #10–#19 `draft` | Revisar jerarquías, precedencia y alcance, no fusionar automáticamente ni convertir `draft` a aprobación |
| **Repo de aplicación** | **ALTA CONFIRMADA** | Conceder al GitHub App acceso a repositorio para PR de `AGENTS.md` y `source-lock`, **tras G0** |

## Dictamen de cierre

**NO DECLARAR G0 = APROBADO por existencia de un enlace, PR o test documental.** Las fuentes están localizadas, las decisiones de arquitectura están firmadas, y la separación de repositorios es verificable. Quedan **ratificación de G0-D01/D03/D04/D05**, revisión efectiva de PR de diseño y B0 y acta formal de aceptación.

Las acciones de B1 seguirán únicamente **después** de Gate G0 aprobado; ya no falta crear el repositorio, pero sí habilitarlo para la integración y congelar el source-lock. **No confundir la CR-B0-F04-001 pendiente con un bloqueo del desarrollo de módulos independientes de sincronización.**
