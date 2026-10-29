# Estado operativo — actualizado al 26/10/2026

**Hito anterior:** corte documental del 25/10/2026. Este archivo agrega el estado de MR-5 y la habilitación de GitHub.

| Frente | Estado | Nota |
|---|---|---|
| Requisitos y dominio | Línea base histórica 23/10/2026 | Revisar contra cambios aprobados posteriores |
| Fases 1–4 / 64 CU | Consolidación documental terminada | Entregable maestro en **DOCX** fuera de este commit; no fingir que el extracto equivale al Word |
| Relaciones UML | 7 nuevas `include` aprobadas | El diagrama nuevo fue rechazado; no publicar como vigente |
| PRA-01 | Especificación acordada | Servicio aún no implementado |
| MR-1/MR-2 | Auditoría y dictamen | 53 hallazgos clasificados; evidencia en fuentes |
| MR-3 | Esquema propuesto | 60 tablas / 453 columnas / 125 FK; DDL sin ejecutar |
| MR-4 | Auditoría estática | 10 hallazgos F01–F10; no hay prueba PostgreSQL |
| MR-5 | Corrección propuesta | Patch y DDL, funciones/triggers no ejecutados |
| MR-6 | **Ejecutado — pruebas de BD satisfactorias** | PostgreSQL 17.11; DDL directo e incremental 59→60, catálogo, rollback, concurrencia e igualdad de huellas; ver informe MR-6 |

## Restricciones de avance
- Las correcciones MR-5 **compilaron y superaron pruebas seleccionadas en PostgreSQL 17.11** (MR-6). No equivalen a validación funcional de toda la aplicación.
- F01 (`COBRO.estadoCobro`) conserva definición incompleta de catálogo literal.
- Servicios para offline, PRA-01 y Reembolsos exigen lógica transaccional fuera del DDL.
- El alta del repositorio no implica desplegar sistema o cargar datos reales.

## Actualización
Editar solo mediante PR con evidencia. Para cambios posteriores registrar fecha, CR, artefactos y prueba. Seguir [protocolo](01-gobierno/PROTOCOLO_CAMBIOS_Y_CHATS.md).

## Evidencia MR-6 — 26/10/2026

- [Informe técnico](05-modelo-relacional/MR6_INFORME_EJECUCION_2026-10-26.md).
- [Resultado real GitHub Actions #40337106012](https://github.com/leandrito369/ale-milanesas/actions/runs/40337106012): éxito.
- Las pruebas de concurrencia y migración trabajan únicamente sobre contenedores y bases descartables.
- **Próximo frente:** cerrar F01 y los servicios F04/F05/F06/F07/F09 y, después, revisar el Diagrama Relacional; mantener sin cambios el Diagrama de CU rechazado.

## Adenda 29/10/2026 — Plan de implementación

El responsable adoptó el [plan rector B0–B10](01-gobierno/PLAN_RECTOR_IMPLEMENTACION_2026-10-29.md) y priorizó [B0](01-gobierno/B0_LINEA_BASE_IMPLEMENTACION_2026-10-29.md). Declaró terminados los DSS, DS y contratos de 64 CU; **queda por localizar/importar y verificar esos artefactos en Git**. El documento DOCX de 64 CU sí está en el repositorio. Las pruebas de BD MR-6 siguen siendo evidencia válida del 26/10; no hay afirmación de sistema completo ni de servicios implementados. La [delegación de programación](06-arquitectura/GUIA_DELEGACION_AGENTES_2026-10-29.md) requiere rama+PR, contratos, trazabilidad y pruebas reproducibles. Esta adenda no reemplaza las RD vigentes ni autoriza cambios de reglas o migraciones productivas.
