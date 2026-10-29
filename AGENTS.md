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

## Plan de implementación adoptado (29/10/2026)
- Plan rector: `docs/01-gobierno/PLAN_RECTOR_IMPLEMENTACION_2026-10-29.md`; primer bloque: `docs/01-gobierno/B0_LINEA_BASE_IMPLEMENTACION_2026-10-29.md`.
- Delegación a Antigravity, OpenCode y similares: `docs/06-arquitectura/GUIA_DELEGACION_AGENTES_2026-10-29.md`. La raíz `AGENTS.md` es común a OpenCode y Antigravity; reglas adicionales `.agents/rules/` y revisión `.opencode/agents/`.
- El usuario declaró completos DSS, DS y contratos de los 64 CU el 29/10; **no** se ha verificado que dichos archivos estén incorporados. B0 debe inventariarlos antes de implementar sobre supuestos.
- El marco de construcción es CU → DSS → DS → contrato → servicio/dominio → BD/API/UI → prueba reproducible, por incrementos verticales.
- MR-6 en PostgreSQL de laboratorio sí fue ejecutado; no atribuir a MR-6 validación de API, servicios, offline o producción. F04 funcional cerrado ≠ S-01 técnica aprobada.
- Para nuevos encargos, cada agente debe leer una tarea acotada y entregar rama+PR con fuentes, diff, pruebas y límites. Decisiones de negocio y cambios físicos de riesgo requieren autorización.

## Fuentes comprobadas en B0 (29/10/2026)
- Índice y manifiesto inmutable: `docs/01-gobierno/b0/B0_INVENTARIO_FUENTES_2026-10-29.md` y `B0_MANIFIESTO_RUTAS_SHA.csv`.
- Matriz 64 CU/67 operaciones: `docs/01-gobierno/b0/B0_MATRIZ_64_CU_67_OPERACIONES.csv`, con rutas concretas a propuestas de PR #10–#19, **no fusionadas**. No aprobar diseño por existencia de archivo.
- Reconciliación RD/RP/RBAC: `docs/01-gobierno/b0/B0_RECONCILIACION_RD_RP_PERMISOS_2026-10-29.md`. Respetar UC-14 vigente en catálogo de 64; evitar equivalencias con 49 CU históricos.
- **Gate G0 NO aprobado**: la matriz operativa requiere cotejo semántico, roles y contrato/persistencia, aceptación humana y ADR. Los agentes pueden auditar y proponer sin programación de lógica de negocio basada en supuestos.
