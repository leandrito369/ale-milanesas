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

## B0 — Consolidación RBAC y contratos (29/10/2026)
- Documentos ratificados: `docs/01-gobierno/b0/RD_B0_BC01_2026-10-29.md`, `RD_B0_BC02_2026-10-29.md`, `RD_B0_BC03_2026-10-29.md`.
- Matriz nueva `docs/01-gobierno/b0/B0_MATRIZ_RBAC_67_OPERACIONES_CIERRE_2026-10-29.csv`: **0 P en 536 celdas**. `UC-14` solo Vendedor; `UC-03/reprogramar` solo Vendedor; `UC-29/anularCobroManual` solo Administrador. Las matrices previas son históricas y no deben usarse para permisos vigentes.
- Contratos derivados aprobados funcionalmente en `docs/08-diagramas/consolidacion-b0/`. Originales de PR #10–#19 intactos; no generar una segunda API sin cotejarlos.
- Dictamen `docs/01-gobierno/b0/B0_DICTAMEN_CIERRE_CONTRACTUAL_Y_SEGURIDAD_2026-10-29.md`: BC-05 reconciliado con propagación editorial pendiente; **BC-07 proyección de campos sensible PROPUESTA, NO APROBADA**. No exponer costos/campos por inferencia ni afirmar G0 ratificado.

## Últimas RD BC-05/BC-07 y regla BC-09 (29/10/2026)
- **BC-05 ratificada:** `docs/01-gobierno/b0/RD_B0_BC05_2026-10-29.md`, 21 RF propagados en 8 versiones B0; originales de revisión permanecen intactos.
- **BC-07 ratificada:** `docs/01-gobierno/b0/RD_B0_BC07_2026-10-29.md` y matriz `BC07_PROYECCIONES_MINIMAS_RATIFICADAS_2026-10-29.csv`. Los campos excluidos **NO** están autorizados por el permiso general de lectura.
- **BC-09:** leer `docs/01-gobierno/b0/BC09_REGLA_INVOCACION_INTERNA_EXTERNA_2026-10-29.md` antes de diseñar HTTP, servicios internos, webhook o pagos. Automatismo/Cliente ONLINE/MercadoPago ≠ Rol humano interno.
- **BC-06:** 18 casos de implementación `BC06_CASOS_PRUEBA_IMPLEMENTACION_18.csv` se encuentran **NO EJECUTADOS** por ausencia de backend. Solo `tests/b0/test_documentacion_b0.py` comprueba consistencia documental. No declarar B3/B4/B6/B8 completados.

## B0 — Mapa técnico E01-C y puerta G0 (29/10/2026)
- Fuente de trabajo **propuesta**: `docs/01-gobierno/b0/B0_MAPA_TECNICO_67_OPERACIONES_2026-10-29.csv` con 67 operaciones, 7 módulos lógicos candidatos, 12 subdominios funcionales y tablas relacionales **existentes**, pero **no** mapeo de clases DS aprobado ni SQL probado.
- Leer `docs/01-gobierno/b0/B0_MAPA_TECNICO_DICTAMEN_2026-10-29.md`, `docs/01-gobierno/b0/B0_MR5_MR6_CONCILIACION_TECNICA_2026-10-29.md` y `docs/06-arquitectura/B0_ADR_CANDIDATAS_PARA_G0_2026-10-29.md`.
- La tabla de operación/servicio/tx se identifica como **CANDIDATA**: ninguna IA debe crear una clase/método o una migración solo por su nombre propuesto. Antes de programar: abrir DS y contrato vigente, validar pre/post, datos, concurrencia, autorización y test.
- **G0 NO APROBADO**: [informe de aprobación](docs/01-gobierno/b0/B0_INFORME_GATE_G0_PARA_APROBACION_2026-10-29.md), sujeto a fuentes canónicas, ADR ratificadas y PR apiladas revisadas. BC06 de implementación permanece 0/18.

## Decisión final de arquitectura y separación de repositorios (29/10/2026)

**Autoridad ratificada:** [RD-B0 arquitectura](docs/01-gobierno/b0/RD_B0_ADR_ARQUITECTURA_APROBADA_2026-10-29.md): **ADR-B1-01/02/03/04/06 APROBADAS** en su alcance original; **ADR-B1-05 PENDIENTE CR** [CR-B0-F04-001](docs/01-gobierno/b0/CR_B0_F04_001_DISENO_FISICO_SINCRONIZACION_PENDIENTE_2026-10-29.md). Todas las menciones más antiguas de «ADR pendientes» quedan superadas respecto de estas cinco.

**Límite de repositorios:** [RD-B0-REPOS-01](docs/01-gobierno/b0/RD_B0_SEPARACION_REPOSITORIOS_2026-10-29.md). **ESTE repositorio es de análisis/diseño/gobierno**. **NO** crear ni introducir aquí el backend, frontend, Android, nuevas migraciones de implementación ni código de servicios. El responsable dará de alta **otro repositorio** y confirmará URL/acceso; hasta entonces **no crear repositorio por cuenta propia ni comenzar B1**. Preparar exclusivamente documentos B0, ADR, CR e instrucciones de handoff. Es posible cerrar documentalmente G0 antes de alta, pero no iniciar implementación.

**Gate:** G0-D02 arquitectura resuelto; G0 general **NO APROBADO** por fuentes PR, backlog y control formal. BC06 pruebas de aplicación **0/18**. Ver [informe Gate](docs/01-gobierno/b0/B0_INFORME_GATE_G0_PARA_APROBACION_2026-10-29.md) y [handoff](docs/06-arquitectura/HANDOFF_REPOSITORIO_IMPLEMENTACION_PENDIENTE_2026-10-29.md). Ningún agente debe inferir una URL o nombre para el futuro repositorio.
