# Instrucciones para asistentes IA — Ale Milanesas

## Orden de lectura
1. `docs/ESTADO_ACTUAL.md`
2. `docs/00-contexto/CONTEXTO_MAESTRO_2026-10-25_v1.0.md`
3. `docs/01-gobierno/PROTOCOLO_CAMBIOS_Y_CHATS.md`
4. Los documentos fuente específicos del área sobre la que vas a trabajar.

## Reglas estrictas
- **No renumerar** los 64 CU. El catálogo 49 original excluía UC-14 y luego fue renumerado; los nuevos son UC-50 a UC-64.
- Los **7 nuevos «include» fueron aprobados**; **NO reconstruir ni reemplazar el diagrama de casos de uso rechazado**.
- Diferenciar: `APROBADO` (decisión), `PROPUESTO` (diseño), `IMPLEMENTADO` (código), `PROBADO` (resultado ejecutado) y `PENDIENTE`.
- **MR-6** ejecutó DDL MR-3/MR-5, migración incremental y pruebas seleccionadas en PostgreSQL 17.11; ver `docs/05-modelo-relacional/MR6_INFORME_EJECUCION_2026-10-26.md`. **NO** inferir que los servicios offline/PRA/webhooks ni producción estén certificados.
- No inventar defaults de plazo de cotizaciones (48 h fue solo ejemplo); `periodoCalculoDias` NO es el plazo de respuesta.
- La categoría, precio y condiciones confirmadas se conservan históricamente; `Pedido.totalVigente` es derivado, no una columna física aprobada.
- Primera ronda de reposición automática como máximo una por episodio; Orden de Compra requiere confirmación humana de Administrador.
- Cambios físicos o de acceso deben tener prueba y trazabilidad CU/RD/RP/CR.
- Proponer cambios mediante rama + PR, **no sobrescribir `main`** ni editar archivos fuente in situ.
- La nueva regla «El Reparto Manda» NO habilita por sí sola al Repartidor a usar UC-29; el permiso requiere decisión explícita.
- No exponer secretos/datos personales en un repositorio público.

## Registro de trabajo por IA
Incluí en cada PR: objetivo, fuentes consultadas, artefactos alterados, decisiones ya aprobadas, pendientes, pruebas corridas/no corridas, riesgo y próximo paso.

## Coordinación
La IA no es árbitro de las decisiones comerciales no definidas. Marcá `[A CONFIRMAR]` y abrí un Issue con trazabilidad.
