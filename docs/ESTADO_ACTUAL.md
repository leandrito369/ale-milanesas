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

## Cierre funcional F04 — 26/10/2026

**Estado:** ANÁLISIS FUNCIONAL CERRADO. RD-F04-001 a RD-F04-007 aprobadas y versionadas en `main` por [PR #5](https://github.com/leandrito369/ale-milanesas/pull/5) (merge `d681ff88ea4f4689e7390ac4ec68b81dea8edd2f`). [Acta maestra](06-arquitectura/F04_CIERRE_FUNCIONAL_MAESTRO_2026-10-26.md).

- **Captura offline:** UC-03 y UC-05 admitidas, con aceptación condicionada al servidor; UC-43 asignación solo online.
- **Dinero en reparto:** Repartidor puede declarar efectivo recibido en UC-05, sin permiso UC-29. Administrador recibe la rendición al terminar el recorrido, autoriza contabilización y gestiona diferencias. Las diferencias quedan pendientes de conciliación, sin ampliar F04 a investigaciones.
- **Cuenta Corriente:** pagos en tránsito validados quedan fuera de COBRO, Caja y asientos definitivos; reducen solo deuda exigible provisional. Esta se usa al evaluar deuda para nuevos Pedidos, sin recategorizar ni suspender el ajuste `EN_MORA` hasta reevaluación formal.
- **F01:** estados de `COBRO` exclusivamente `CONFIRMADO`/`ANULADO` (PR #4 integrado en `main`).
- **Técnica:** contrato S-01 borrador **PROPUESTO**; inbox, persistencia, API, seguridad, migraciones, concurrencia y pruebas de servicio **PENDIENTES / NO IMPLEMENTADOS / NO PROBADOS**. El cierre funcional no implica sistema desplegado.

**Nota de lectura:** el cuadro histórico anterior refleja un corte previo al cierre de F01/F04; para estos frentes prevalecen las RD y el presente apartado con fecha 26/10/2026.
