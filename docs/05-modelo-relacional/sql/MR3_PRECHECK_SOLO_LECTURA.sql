-- MR-3 PRECHECK de datos, SOLO SELECT; consultar resultados antes de ejecutar la migración.
-- Ejecutar cada SELECT en PostgreSQL con acceso al esquema histórico. No muta tablas.
-- Duplicados de nombre INSUMO tras normalizar:
SELECT lower(regexp_replace(btrim("nombre"), '[[:space:]]+', ' ', 'g')) AS normal,
 count(*) FROM "INSUMO" GROUP BY 1 HAVING count(*)>1;
-- Duplicados de nombre+telefono CLIENTE (no teléfono únicamente):
SELECT lower(regexp_replace(btrim("nombres"||' '||coalesce("apellidos",'')), '[[:space:]]+', ' ', 'g')) AS nombre,
 regexp_replace("telefonoPrincipal",'[^0-9]','','g') AS telefono,
 count(*) FROM "CLIENTE" GROUP BY 1,2 HAVING count(*)>1;
-- Valores PROMOCION que quedarían fuera del nuevo catálogo:
SELECT "estado", count(*) FROM "PROMOCION" WHERE "estado" NOT IN
 ('BORRADOR','ACTIVA','PAUSADA','FINALIZADA','CANCELADA') GROUP BY "estado";
-- Vigencias que impiden las EXCLUDE (rango solapado por Insumo/Producto o global):
SELECT a."idReceta", a."numeroVersion", b."numeroVersion" FROM "VERSION_RECETA" a JOIN "VERSION_RECETA" b
 ON a."idReceta"=b."idReceta" AND a."numeroVersion"<b."numeroVersion"
 AND tstzrange(a."vigenteDesde",coalesce(a."vigenteHasta",'infinity'::timestamptz),'[)') &&
 tstzrange(b."vigenteDesde",coalesce(b."vigenteHasta",'infinity'::timestamptz),'[)');
SELECT a."idProducto",a."idPrecio",b."idPrecio" FROM "PRECIO_PRODUCTO" a JOIN "PRECIO_PRODUCTO" b
 ON a."idProducto"=b."idProducto" AND a."idPrecio"<b."idPrecio"
 AND a."fechaHoraCancelacion" IS NULL AND b."fechaHoraCancelacion" IS NULL
 AND tstzrange(a."vigenteDesde",coalesce(a."vigenteHasta",'infinity'::timestamptz),'[)') &&
 tstzrange(b."vigenteDesde",coalesce(b."vigenteHasta",'infinity'::timestamptz),'[)');
SELECT a."idPoliticaCompra",b."idPoliticaCompra" FROM "POLITICA_COMPRA" a JOIN "POLITICA_COMPRA" b
 ON a."idPoliticaCompra"<b."idPoliticaCompra"
 AND tstzrange(a."vigenteDesde",coalesce(a."vigenteHasta",'infinity'::timestamptz),'[)') &&
 tstzrange(b."vigenteDesde",coalesce(b."vigenteHasta",'infinity'::timestamptz),'[)');
SELECT a."idPoliticaComercial",b."idPoliticaComercial" FROM "POLITICA_CATEGORIA_COMERCIAL" a JOIN "POLITICA_CATEGORIA_COMERCIAL" b
 ON a."idPoliticaComercial"<b."idPoliticaComercial"
 AND tstzrange(a."vigenteDesde",coalesce(a."vigenteHasta",'infinity'::timestamptz),'[)') &&
 tstzrange(b."vigenteDesde",coalesce(b."vigenteHasta",'infinity'::timestamptz),'[)');
-- Interpretación: CERO filas = sin conflictos detectados en la condición evaluada.
-- Reintentos ya existentes que necesitan idUsuarioReintento para satisfacer el CHECK nuevo.
-- Cualquier fila obliga backfill verificable: nunca adjudicar un Administrador al azar.
SELECT "idReembolso", "numeroIntento", "fechaHoraSolicitud" FROM "INTENTO_REEMBOLSO"
 WHERE "numeroIntento" > 1;
-- Puntuaciones históricas negativas: el esquema MR-3 normaliza el mínimo a cero.
SELECT "idDecisionCompra", "idRespuesta", "codigoCriterio", "puntajeEvaluado"
 FROM "DETALLE_DECISION_CRITERIO" WHERE "puntajeEvaluado" < 0;
-- Inconsistencias de cobranza original: cobros que ya tengan un tipo especial de estado.
SELECT "estadoCobro", count(*) FROM "COBRO" GROUP BY "estadoCobro";
