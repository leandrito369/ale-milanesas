# Ale Milanesas — Sistema de Gestión

Repositorio colaborativo de **análisis, documentación y diseño** del Sistema de Gestión para Ale Milanesas.

> **Estado: documentación en evolución.** Los 64 casos de uso están consolidados en un documento Word de Fase 4; el diseño relacional MR-5 es una **propuesta ejecutada en PostgreSQL 17 de laboratorio con alcance de pruebas parcial, no certificada para producción**. No equiparar estos archivos con software listo para producción.

## Cómo empezar

1. Leé [el índice](docs/INDICE.md) y [el estado actual](docs/ESTADO_ACTUAL.md).
2. Para cargar el contexto en otra IA, empezá por [el documento maestro](docs/00-contexto/CONTEXTO_MAESTRO_2026-10-25_v1.0.md) y [las instrucciones de reanudación](docs/00-contexto/PROMPT_REANUDACION.md).
3. Antes de editar, consultá [AGENTS.md](AGENTS.md) y [el protocolo de cambios](docs/01-gobierno/PROTOCOLO_CAMBIOS_Y_CHATS.md).
4. Trabajá en una rama propia y abrí un Pull Request hacia `main` con los archivos afectados, decisiones y pruebas.

## Situación al 26/10/2026

- **64 CU** numerados consecutivamente, fichas de tres niveles en Word; el DOCX maestro debe incorporarse sin sustituir su estructura por texto extraído.
- **7 nuevas relaciones «include» aprobadas**, pero el diagrama de CU generado fue rechazado: **NO usarlo como diagrama definitivo**.
- **MR-3:** propuesta relacional de 60 tablas, 453 columnas y 125 FK.
- **MR-4:** auditoría estática, no prueba en PostgreSQL; 10 hallazgos.
- **MR-5/MR-6:** DDL y migración ejecutados y probados en **PostgreSQL 17 de laboratorio**; falta implementar los servicios offline, PRA-01 y MercadoPago.
- Hay decisiones posteriores al corte que pueden prevalecer sobre los registros RD/RP antiguos; consultar el estado y la trazabilidad.

Este repositorio es **público**. No subir contraseñas, tokens, datos reales de clientes/proveedores, bases de producción ni archivos de terceros sin autorización.

Consultá [la guía de Gemini web](docs/GUIA_GEMINI_WEB.md) para importar de nuevo el repositorio y proponer cambios sin sobrescribir `main`.

## Trabajar con Gemini web

Importá este repositorio desde Gemini para **consultar el contenido de la versión importada**. La importación no implica escritura ni sincronización automática: para aplicar cambios, usá un cliente Git / entorno autorizado, o generá un parche/PR manual. Reimportá al actualizarse la rama `main`.

## Licencias y fuentes

Documentación para trabajo académico del proyecto; no se concede aquí ninguna licencia de reutilización de guías educativas de terceros. No se incluyeron las guías de consulta originales.

## Plan de construcción adoptado — 29/10/2026

Se adoptó el [plan rector B0–B10](docs/01-gobierno/PLAN_RECTOR_IMPLEMENTACION_2026-10-29.md), con desarrollo incremental por recorridos completos y pruebas reproducibles. Primer paso: [B0 — consolidación de línea base](docs/01-gobierno/B0_LINEA_BASE_IMPLEMENTACION_2026-10-29.md). Para delegación de programación a Antigravity/OpenCode, consultar la [guía de agentes](docs/06-arquitectura/GUIA_DELEGACION_AGENTES_2026-10-29.md) y `AGENTS.md`.

**Precisión de evidencia:** el responsable informó DSS, DS y contratos de 64 CU terminados, pendientes de inventario/importación en Git; MR-6 ya demostró pruebas seleccionadas de PostgreSQL 17, sin demostrar backend o aplicación completa.

## Línea base de construcción: B0 en fase de aprobación

Se dispone del [mapa de las 67 operaciones](docs/01-gobierno/b0/B0_MAPA_TECNICO_67_OPERACIONES_2026-10-29.csv) hacia módulos/servicios/transacciones propuestos y tablas físicas MR3/MR5, así como de [6 ADR candidatas](docs/06-arquitectura/B0_ADR_CANDIDATAS_PARA_G0_2026-10-29.md) y un [informe de Gate G0](docs/01-gobierno/b0/B0_INFORME_GATE_G0_PARA_APROBACION_2026-10-29.md). La evidencia B0 es **documental**, no aplicación terminada. **G0 requiere aprobación de fuentes/ADR/PR por el integrador.**

## Decisión de arquitectura y repositorio de implementación (29/10/2026)

El responsable **ratificó ADR-B1-01/02/03/04/06**; ADR-B1-05 queda condicionada a una CR de diseño físico F04. [Acta de arquitectura](docs/01-gobierno/b0/RD_B0_ADR_ARQUITECTURA_APROBADA_2026-10-29.md).

**Este repositorio sigue siendo el de análisis, diseño y gobierno.** El código Spring Boot, las interfaces, Android, migraciones versionadas y pruebas de implementación irán a **otro repositorio que creará el responsable**. Hasta entonces no se crea un repositorio nuevo ni se empieza programación. [Política de repositorios](docs/01-gobierno/b0/RD_B0_SEPARACION_REPOSITORIOS_2026-10-29.md) · [Handoff pendiente](docs/06-arquitectura/HANDOFF_REPOSITORIO_IMPLEMENTACION_PENDIENTE_2026-10-29.md).

**G0 no aprobado**: queda revisar integración de fuentes y PR, backlog y aceptación formal. Una ADR aprobada no habilita por sí sola B1.
