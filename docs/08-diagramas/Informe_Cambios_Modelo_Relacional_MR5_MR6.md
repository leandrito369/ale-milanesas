# Informe de actualización del Modelo Relacional — Ale Milanesas

**Fuente gráfica obligatoria:** `MODELORELACIONAL23_10.drawio.xml` (23/10/2026).

**Fuente de atributos y referencias:** `MR3_DICCIONARIO_COLUMNAS.csv` y `MR5_DDL_NO_EJECUTADO.sql` de `main`, comprobados en MR-6 PostgreSQL 17.11 el 26/10/2026.

## Resultado

- **60 tablas / 453 atributos / 125 relaciones FK**; la huella del multiconjunto de pares FK (FNV-1a) es `cc7392dd`, idéntica a la obtenida del DDL MR-5.
- **59 de 59 tablas existentes** conservan exactamente sus coordenadas `x`, `y` y su ancho; no se redistribuyó la maqueta.
- Se agregó `CONFIGURACION_OPERATIVA` en un espacio libre, a `x=3820, y=575`; contiene 4 columnas y su relación con `USUARIO`.
- Se agregaron 5 columnas a 4 tablas: `EPISODIO_FALTANTE` (+2), `ORIGEN_MOVIMIENTO_CUENTA` (+1), `MOVIMIENTO_CAJA` (+1), `INTENTO_REEMBOLSO` (+1).
- Se aumentó **únicamente la altura de esas cuatro tablas**, para que las filas nuevas no queden ocultas; manteniendo posiciones originales. Todas las demás dimensiones se conservan.
- Las flechas heredadas conservaron su geometría salvo **`rel_104`**, que recibió una rectificación posterior de anclajes y dos waypoints para conectar correctamente `COBRO → CLIENTE` por el corredor libre. Las siete correcciones de cardinalidad posteriores solo modificaron símbolos, sin mover recorridos.

## Relaciones nuevas y reparaciones necesarias

### Cinco FK de MR-3

1. `CONFIGURACION_OPERATIVA.idUsuarioAdministrador → USUARIO.idUsuario`.
2. `EPISODIO_FALTANTE.idUsuarioAjustePlazo → USUARIO.idUsuario`.
3. `ORIGEN_MOVIMIENTO_CUENTA.idCobroAnulado → COBRO.idCobro`.
4. `MOVIMIENTO_CAJA.idCobroAnulado → COBRO.idCobro`.
5. `INTENTO_REEMBOLSO.idUsuarioReintento → USUARIO.idUsuario`.

### Defectos de conexión que ya existían en 23/10

- `rel_093`: faltaba un `source` vinculado a la tabla; se recuperó `RECEPCION_COMPRA → PRODUCTO` sin alterar geometría ni waypoints.
- `rel_104`: duplicaba `PEDIDO → CLIENTE`; el DDL requiere `COBRO → CLIENTE`. Se corrigió su `source` y, tras la revisión geométrica del 26/10, también sus puntos de anclaje y dos waypoints para evitar un recorrido innecesario.
- `6wNsofvO9NhsZGQJbtSw-2`: conectaba de nuevo `COBRO → PEDIDO`, relación que ya está en `rel_106`; se eliminó **solo el duplicado**, para mantener un enlace por FK.
- Se incorporaron las tres relaciones antiguas ausentes: `SOLICITUD_COTIZACION → SOLICITUD_COTIZACION`, `POLITICA_COMPRA → USUARIO`, `DECISION_COMPRA → USUARIO`.

Estas correcciones mínimas de asociación son necesarias para alcanzar los **125 vínculos FK físicos del DDL**, sin inventar ni duplicar relaciones semánticas. No se modificaron las coordenadas de ninguna tabla antigua ni los waypoints de las flechas antiguas conservadas.

## Alcance de la cardinalidad

La notación de pata de cuervo representa las multiplicidades que se deducen físicamente del SQL: `0..N` para referencias no únicas; `0..1` cuando la FK es opcional o cuando `UNIQUE` limita el vínculo hijo; y `1` para cada referencia no nula obligatoria. Las reglas de participación total entre tablas que dependen de triggers o de lógica transaccional, no de un FK simple, **no se han atribuido artificialmente al diagrama**.

## QA aplicada

- XML parseable por lxml, sin IDs de celdas repetidos ni flechas con origen/destino huérfanos.
- Todos los 59 pares `(x,y)` originales y todos sus anchos se mantienen.
- 125 flechas conectadas, y multiconjunto completo de tabla origen → tabla referenciada comparado por huella con DDL MR-5.
- 453 filas de atributos, tipos, etiquetas PK/FK y nulabilidad; los cinco grupos actualizados pasaron comparación mediante huella por tabla contra el diccionario MR-3 del repositorio.
- La ejecución PostgreSQL de MR-6 respalda el esquema SQL, **no representa una prueba de render visual en Draw.io**. La auditoría geométrica offline posterior identificó y corrigió `rel_104` y siete cardinalidades 0..N que correspondían a 0..1 por `UNIQUE`. Véase [QA visual 26/10](QA_VISUAL_MODELO_RELACIONAL_2026-10-26.md). La revisión nativa en diagrams.net continúa pendiente.

**El archivo adjunto original del corte 23/10 sigue intacto. La versión actual y las correcciones de QA se encuentran publicadas en la rama del PR #3, sin fusión a `main`.**