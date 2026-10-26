# QA visual y cardinalidades del modelo relacional — 26/10/2026

**Estado:** **REVISIÓN GEOMÉTRICA Y ESTRUCTURAL REALIZADA**. **Verificación final de renderizado nativo en diagrams.net pendiente**.

## Fuentes controladas

- Diagrama de corte: `MODELORELACIONAL23_10.drawio.xml`, adjuntado por el usuario.
- Diagrama del PR #3: [Draw.io MR-5/MR-6](Modelo_Relacional_Ale_MR5_MR6_ACTUALIZADO_SOBRE_23-10.drawio.xml).
- SQL físico: [MR5_DDL_NO_EJECUTADO.sql](../05-modelo-relacional/sql/MR5_DDL_NO_EJECUTADO.sql) y [diccionario MR-3](../05-modelo-relacional/MR3_DICCIONARIO_COLUMNAS.csv).
- PostgreSQL MR-6: [evidencia ejecutada](../05-modelo-relacional/MR6_INFORME_EJECUCION_2026-10-26.md), sin pretensión de certificar el aspecto gráfico.

## Método y alcance de la inspección

1. Se comparó el XML contra el corte 23/10: 59/59 tablas anteriores conservan exactamente `x`, `y` y `width`; las cuatro ampliaciones de altura corresponden a nuevas filas. La tabla 60 se incorpora en sector libre.
2. Se analizaron los rectángulos de las 60 tablas: **no existen superposiciones entre tablas**.
3. Se examinó una **previsualización geométrica offline** en Chromium, recreada a partir de las coordenadas, estilos y valores HTML del XML. **No se ejecutó el motor nativo de Draw.io**: sus decisiones de autoruteo y símbolos pueden variar; esta inspección no sustituye abrir el .drawio.xml en diagrams.net.
4. Se verificaron las rutas explícitas nuevas y la ruta corregida de `rel_104` contra los rectángulos de las demás tablas: ninguno de esos trayectos atraviesa una tabla ajena. Para segmentos autocalculados en el render nativo subsiste la limitación del punto 3.
5. Se comparó cada flecha (125) con las 125 FK del DDL, incluyendo multiplicidades por `UNIQUE`, `PRIMARY KEY` y `NOT NULL`. **Resultado final: cero correspondencias o cardinalidades discordantes**.
6. Las restricciones `UNIQUE` sobre **subconjuntos** de columnas FK compuestas también limitan la multiplicidad a 0..1. Las unicidades parciales condicionadas a `WHERE` no se interpretaron como unicidad universal.

## Hallazgos y correcciones en el PR #3

| ID | Relación | Hallazgo | Corrección aplicada |
|---|---|---|---|
| `rel_104` | `COBRO → CLIENTE` | Conector reasignado desde un antiguo origen en `PEDIDO` retenía salida izquierda y llegada derecha; trayecto menos legible | Salida por borde derecho de `COBRO`, llegada por borde izquierdo de `CLIENTE`; dos waypoints en el corredor vacío `x=1855`. No se mueve ninguna tabla |
| `rel_015` | `MOVIMIENTO_INSUMO → RECEPCION_COMPRA` | `UNIQUE(idRecepcionCompra)` | Multiplicidad hija de 0..N a **0..1** |
| `rel_038` | `MOVIMIENTO_EXCEDENTE → OFERTA_EXCEDENTE` | `UNIQUE(idOfertaExcedente)` | 0..N → **0..1** |
| `mr_add_BASE_119` | `SOLICITUD_COTIZACION → SOLICITUD_COTIZACION` | `UNIQUE(idSolicitudAnterior)` | 0..N → **0..1** |
| `rel_084` | `DECISION_COMPRA → RESPUESTA_COTIZACION` | `UNIQUE(idSolicitud)`, subconjunto de la FK compuesta | 0..N → **0..1** |
| `rel_097` | `MOVIMIENTO_STOCK_REVENTA → RECEPCION_COMPRA` | `UNIQUE(idRecepcionCompra)` | 0..N → **0..1** |
| `rel_099` | `MOVIMIENTO_STOCK_REVENTA → DETALLE_PEDIDO` | `UNIQUE(idPedidoEntrega, numeroDetalleEntrega)`, subconjunto FK | 0..N → **0..1** |
| `rel_100` | `MOVIMIENTO_STOCK_REVENTA → VALORACION_EXTRAORDINARIA_REVENTA` | `UNIQUE(idValoracionReventa)` | 0..N → **0..1** |

Las siete rectificaciones de cardinalidad **no modifican la ubicación, waypoints ni dirección** de sus flechas: solo reemplazan `startArrow=ERzeroToMany` por `startArrow=ERzeroToOne`. La corrección `rel_104` sí cambia sus anclajes y agrega dos waypoints, **justificada porque cambió de origen respecto del corte del 23/10**.

## Resultado y puerta de aprobación

- **60 tablas / 453 atributos / 125 FK.**
- 59 posiciones y anchos iniciales preservados; 4 aumentos de altura; nueva `CONFIGURACION_OPERATIVA` sin solapamientos.
- Cero diferencias de dirección o cardinalidad entre los 125 enlaces y el DDL MR-5 bajo PK, FK, `UNIQUE` y `NOT NULL`.
- Ninguna modificación de SQL, reglas de negocio, permisos o casos de uso.

**Pendiente explícito:** abrir el archivo editable del PR #3 en **diagrams.net**, comprobar el render nativo y recorrer especialmente las zonas `COBRO/CLIENTE`, `USUARIO/CONFIGURACION_OPERATIVA`, `EPISODIO_FALTANTE/SOLICITUD_COTIZACION` y `MOVIMIENTO_STOCK_REVENTA`. La fusión del PR debe esperar esa última comprobación si el objetivo es preservar la legibilidad exacta del corte.
