# Diagramas — versión de trabajo MR-5/MR-6 (26/10/2026)

## Modelo relacional

- [Diagrama Draw.io editable](Modelo_Relacional_Ale_MR5_MR6_ACTUALIZADO_SOBRE_23-10.drawio.xml): actualiza sobre el archivo de corte del 23/10/2026 sin redistribuir las 59 tablas preexistentes; incorpora CONFIGURACION_OPERATIVA y referencias físicas MR-3/MR-5.
- [Informe de cambios y validación](Informe_Cambios_Modelo_Relacional_MR5_MR6.md): detalla relaciones añadidas y reparaciones mínimas.
- [QA geométrica y de cardinalidades 26/10](QA_VISUAL_MODELO_RELACIONAL_2026-10-26.md): revisiones, rectificación del enlace COBRO→CLIENTE y siete cardinalidades 0..1 según restricciones SQL.
- [Diccionario explicativo de 60 tablas](../05-modelo-relacional/Diccionario_Explicativo_60_Tablas_MR5_MR6_26-10-2026.md): 453 atributos, claves primarias, foráneas, nulabilidad y significado funcional de cada columna.
- [Evidencia ejecutada MR-6](../05-modelo-relacional/MR6_INFORME_EJECUCION_2026-10-26.md): validación de esquema y pruebas seleccionadas en PostgreSQL 17.11, no certificación de aplicación ni de producción.

**QA previa realizada:** comparación geométrica y previsualización offline; se corrigió una ruta y siete cardinalidades sin redistribuir tablas. **Control visual nativo todavía pendiente:** abrir el XML en diagrams.net y verificar conectores, flechas y legibilidad antes de declararlo entrega gráfica definitiva.

**Preservación:** el diagrama de casos de uso rechazado no se reconstruyó ni modificó. Los esquemas del corte 23/10 se conservan como antecedentes y no se borraron.
