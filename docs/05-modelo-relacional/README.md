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

**No hay evidencia de PostgreSQL ejecutado.** La siguiente validación es MR-6 en base descartable.
No tomar éxito de parseo estático como aceptación funcional, ni aplicar scripts sobre bases reales.
