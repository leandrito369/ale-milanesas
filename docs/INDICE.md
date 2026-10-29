# Índice de documentación

| Ruta | Finalidad | Autoridad |
|---|---|---|
| [Estado](ESTADO_ACTUAL.md) | Situación vigente y prioridades | Punto de entrada; actualizar por PR |
| [Contexto maestro](00-contexto/CONTEXTO_MAESTRO_2026-10-25_v1.0.md) | Handoff corte 25/10 | Documento de referencia, **corte histórico** |
| [Protocolo](01-gobierno/PROTOCOLO_CAMBIOS_Y_CHATS.md) | Control de cambios y sesiones | Política de trabajo |
| [RD v1.1](01-gobierno/RD_01_REGISTRO_DECISIONES_v1.1_2026-10-25.md) | Decisiones a esa fecha | Parcialmente superado por MR-3/MR-5 |
| [RP v1.1](01-gobierno/RP_01_REGISTRO_PENDIENTES_v1.1_2026-10-25.md) | Pendientes a esa fecha | Verificar cierres posteriores |
| [PRA-01](02-procesos/PRA_01_REPOSICION_AUTOMATICA_v1.1_2026-10-25.md) | Reposición automática | Diseño de negocio; servicio no implementado |
| [Casos de uso](04-casos-uso/README.md) | Situación de 64 fichas y relaciones | Requiere DOCX maestro original |
| [Modelo Relacional](05-modelo-relacional/README.md) | Fuentes MR-3 a MR-5, SQL | Propuesto / no ejecutado |
| [Plantillas](99-plantillas/README.md) | Bitácoras, decisiones, cambios | Usar en PR |

Los documentos de requisitos 23/10 se incluyen como **línea base histórica**, no como reemplazo de decisiones posteriores.

- [Guía Gemini web](GUIA_GEMINI_WEB.md): importación, limitaciones de escritura y flujo con PR.

- [Informe MR-6](05-modelo-relacional/MR6_INFORME_EJECUCION_2026-10-26.md): ejecución PostgreSQL 17 y riesgos restantes.

## Implementación (plan adoptado 29/10/2026)
- [Plan rector B0–B10](01-gobierno/PLAN_RECTOR_IMPLEMENTACION_2026-10-29.md): prioridades, hitos y entregables E01–E12.
- [B0, primera ejecución](01-gobierno/B0_LINEA_BASE_IMPLEMENTACION_2026-10-29.md): inventario 64 CU/DSS/DS/contratos, trazabilidad y gate G0.
- [Guía de delegación IA](06-arquitectura/GUIA_DELEGACION_AGENTES_2026-10-29.md): tareas delegables, límites, PR y pruebas para Antigravity/OpenCode.

## Cierre de línea base B0 en preparación (29/10/2026)

- [Mapa técnico 67 operaciones](01-gobierno/b0/B0_MAPA_TECNICO_67_OPERACIONES_2026-10-29.csv) y [60 tablas](01-gobierno/b0/B0_COBERTURA_60_TABLAS_Y_OPERACIONES_2026-10-29.csv).
- [Arquitectura: ADR candidatas](06-arquitectura/B0_ADR_CANDIDATAS_PARA_G0_2026-10-29.md) — requieren ratificación humana.
- [Backlog de primera entrega](01-gobierno/b0/B0_BACKLOG_I0_I1_PRIMER_VERTICAL_2026-10-29.md) y [Gate G0](01-gobierno/b0/B0_INFORME_GATE_G0_PARA_APROBACION_2026-10-29.md).

## Línea base B0 — arquitectura y repositorios (ratificaciones 29/10/2026)

- [ADR-B1-01/02/03/04/06 ratificadas](01-gobierno/b0/RD_B0_ADR_ARQUITECTURA_APROBADA_2026-10-29.md)
- [CR-B0-F04-001 pendiente, ADR-B1-05](01-gobierno/b0/CR_B0_F04_001_DISENO_FISICO_SINCRONIZACION_PENDIENTE_2026-10-29.md)
- [Separación análisis vs implementación](01-gobierno/b0/RD_B0_SEPARACION_REPOSITORIOS_2026-10-29.md)
- [Traspaso preparado, repo implementación aún no creado](06-arquitectura/HANDOFF_REPOSITORIO_IMPLEMENTACION_PENDIENTE_2026-10-29.md)
- [Gate G0, decisión D02 resuelta y restantes pendientes](01-gobierno/b0/B0_INFORME_GATE_G0_PARA_APROBACION_2026-10-29.md)

## Expediente Gate G0 29/10/2026

- [Dictamen de aptitud](01-gobierno/b0/G0_DICTAMEN_APTITUD_CIERRE_2026-10-29.md)
- [Manifiesto inmutable de 67 operaciones](01-gobierno/b0/G0_MANIFIESTO_67_OPERACIONES_FUENTES_INMUTABLES_2026-10-29.csv)
- [Plan integración de PR #9–#25](01-gobierno/b0/G0_PLAN_INTEGRACION_CONTROLADA_PR_2026-10-29.md)
- [Acta preparada para decisión](01-gobierno/b0/G0_ACTA_PARA_RATIFICACION_2026-10-29.md)
- [Alta confirmada del repositorio app y permiso GitHub pendiente](01-gobierno/b0/G0_ALTA_REPO_IMPLEMENTACION_2026-10-29.md)
- [Plantillas AGENTS/source-lock para app, aún no publicadas allí](06-arquitectura/G0_PLANTILLA_AGENTS_REPO_APP_2026-10-29.md)

## Fuentes canónicas aprobadas tras fusión B0/G0 (29/10/2026)

- [Acta formal RD-B0-G0-001](01-gobierno/b0/RD_B0_G0_001_CIERRE_LINEA_BASE_2026-10-29.md)
- [Manifiesto canónico de 67 operaciones](01-gobierno/b0/G0_MANIFIESTO_CANONICO_67_OPERACIONES_2026-10-29.csv)
- [Bitácora de fusiones #9/#10–#26](01-gobierno/b0/G0_BITACORA_FUSION_18_PR_2026-10-29.md)
- Commit canónico: `1263ffc17bd0eb7f3c69faaa9ff5ae556cf9de7e`
- [Requisitos técnicos de B1 y bloqueo F04](01-gobierno/b0/CR_B0_F04_001_DISENO_FISICO_SINCRONIZACION_PENDIENTE_2026-10-29.md). Los manifiestos de PR anteriores son **históricos**.
