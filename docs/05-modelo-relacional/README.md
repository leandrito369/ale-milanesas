# Modelo Relacional — Estado MR-5

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
