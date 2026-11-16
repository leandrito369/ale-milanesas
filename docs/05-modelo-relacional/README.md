# Modelo Relacional — Estado MR-5

> **Actualización de vigencia 15/11/2026:** este README describe la base física MR-5 de **60 tablas**, que se mantiene como **migración V1 histórica y obligatoria**; **no** es el recuento total actual. La aplicación vigente incorpora **62 tablas** mediante `V1__baseline_mr5.sql` + `V2__f01_cobro_estados.sql` + `V3__trazabilidad_partidas_insumo.sql` (dos tablas nuevas, [RD-MR-PARTIDAS-001](../01-gobierno/b0/RD_MR_PARTIDAS_001_AMPLIACION_MR_PARTIDA_INSUMO_2026-11-06.md)). El [informe MR-6 del 26/10](MR6_INFORME_EJECUCION_2026-10-26.md) es una **campaña histórica de pruebas de 60 tablas**, distinta de la ampliación MR-6 a 62 del 06/11. El antiguo modelo de 59 tablas y SQL pre-V1 no están vigentes para implementar cambios nuevos. [Precedencia completa](../01-gobierno/VIGENCIA_DOCUMENTAL_Y_PRECEDENCIA_2026-11-15.md). **No reescribir ninguna migración histórica.**

El modelo de diseño vigente tiene **60 tablas, 453 columnas y 125 FK**.

- `MR3_ESQUEMA_MAESTRO.md`: descripción de entidades propuesta.
- `MR3_DICCIONARIO_COLUMNAS.csv`: columnas físicas.
- `sql/MR3_DDL_NO_EJECUTADO.sql`: DDL consolidado MR-3.
- `sql/MR3_MIGRACION_NO_EJECUTADA.sql`: incremento 59→60 MR-3, **no aplicar sin precheck**.
- `sql/MR5_DDL_NO_EJECUTADO.sql`: MR-3 más mejoras MR-5, **no certificado**.
- `sql/MR5_PATCH_NO_EJECUTADO.sql`: parche post MR-3, no ejecutar en producción.
- `MR4_HALLAZGOS.csv`, `MR5_RESOLUCION.csv`: riesgos y tratamiento.
- `MR5_CONTRATOS_SERVICIOS.md`: obligaciones de servicios de aplicación.

**MR-6 ya realizó pruebas ejecutables en PostgreSQL 17.11 descartable.** Consulta [el informe MR-6](MR6_INFORME_EJECUCION_2026-10-26.md). Los SQL históricos conservan nombres `NO_EJECUTADO` para documentar su procedencia, pero MR-6 sí los ejecutó en laboratorio; ello no acredita producción ni servicios de aplicación.
No tomar éxito de parseo estático como aceptación funcional, ni aplicar scripts sobre bases reales.
