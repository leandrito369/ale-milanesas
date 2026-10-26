#!/usr/bin/env bash
# MR-6: pruebas sobre DB descartable creada exclusivamente en GitHub Actions.
set -euo pipefail
test "${PGDATABASE:-}" = "ale_mr5_ci" || { echo "ERROR: DB no descartable"; exit 90; }
mkdir -p mr6-logs
psql -X -v ON_ERROR_STOP=1 <<'SQL'
SET search_path TO mr5_validacion,public;
INSERT INTO "UNIDAD_MEDIDA" ("codigoUnidad","nombre") VALUES ('MR6_KG','Unidad test MR-6');
INSERT INTO "CLIENTE" ("idCliente","nombres","telefonoPrincipal","estado","categoriaComercial","fechaHoraAlta")
VALUES (990001,'Cliente prueba MR6','3755000000','ACTIVO','CUMPLIDOR',now());
SQL
# La operación B intenta escribir la misma clave normalizada que A aún no confirmó.
# PostgreSQL debe bloquear temporalmente y después rechazarla con SQLSTATE 23505.
psql -X -v ON_ERROR_STOP=1 -c "
BEGIN;
SET LOCAL search_path TO mr5_validacion,public;
INSERT INTO \"INSUMO\" (\"idInsumo\",\"nombre\",\"codigoUnidadMedida\",\"stockActual\",\"umbralMinimo\",\"nivelObjetivoReposicion\",\"automatizacionCompraActiva\",\"activo\")
VALUES (990001,'Insumo   MR6','MR6_KG',0,1,2,false,true);
SELECT pg_sleep(3);
COMMIT;
" >mr6-logs/concurrencia-insumo-a.log 2>&1 &
pid=$!
sleep 1
set +e
psql -X -v ON_ERROR_STOP=1 -c "SET search_path TO mr5_validacion,public;" \
    -c "SET statement_timeout='10s';" \
    -c "INSERT INTO \"INSUMO\" (\"idInsumo\",\"nombre\",\"codigoUnidadMedida\",\"stockActual\",\"umbralMinimo\",\"nivelObjetivoReposicion\",\"automatizacionCompraActiva\",\"activo\") VALUES (990002,' insumo mr6 ','MR6_KG',0,1,2,false,true);" \
    >mr6-logs/concurrencia-insumo-b.log 2>&1
second_rc=$?
set -e
wait "$pid"
test "$second_rc" -ne 0 || { echo "FAIL: Insumo duplicado concurrente aceptado"; exit 1; }
grep -q 'duplicate key value violates unique constraint' mr6-logs/concurrencia-insumo-b.log || { cat mr6-logs/concurrencia-insumo-b.log; exit 1; }
test "$(psql -X -At -v ON_ERROR_STOP=1 -c "SELECT count(*) FROM mr5_validacion.\"INSUMO\" WHERE \"idInsumo\" IN (990001,990002)")" = "1"
echo "[PASS] Concurrencia de INSUMO: un solo registro confirmado"
# Se ejecutan dos Cobros con la misma clave de origen y distinto idCobro.
# Demuestra UNIQUE en BD; no sustituye la autorización ni el servicio offline.
idem="00000000-0000-0000-0000-000000990001"
psql -X -v ON_ERROR_STOP=1 -c "
BEGIN;
SET LOCAL search_path TO mr5_validacion,public;
INSERT INTO \"COBRO\" (\"idCobro\",\"idCliente\",\"fechaHoraCobro\",\"importe\",\"medioPago\",\"origen\",\"claveIdempotenciaOrigen\",\"estadoCobro\")
VALUES (990001,990001,now(),100,'EFECTIVO','ADMINISTRACION','$idem','ESTADO_PRUEBA');
SELECT pg_sleep(3);
COMMIT;
" >mr6-logs/concurrencia-cobro-a.log 2>&1 &
pid=$!
sleep 1
set +e
psql -X -v ON_ERROR_STOP=1 -c "SET search_path TO mr5_validacion,public;" \
    -c "SET statement_timeout='10s';" \
    -c "INSERT INTO \"COBRO\" (\"idCobro\",\"idCliente\",\"fechaHoraCobro\",\"importe\",\"medioPago\",\"origen\",\"claveIdempotenciaOrigen\",\"estadoCobro\") VALUES (990002,990001,now(),100,'EFECTIVO','ADMINISTRACION','$idem','ESTADO_PRUEBA');" \
    >mr6-logs/concurrencia-cobro-b.log 2>&1
second_rc=$?
set -e
wait "$pid"
test "$second_rc" -ne 0 || { echo "FAIL: Cobro de mismo UUID duplicado"; exit 1; }
grep -q 'duplicate key value violates unique constraint' mr6-logs/concurrencia-cobro-b.log || { cat mr6-logs/concurrencia-cobro-b.log; exit 1; }
test "$(psql -X -At -v ON_ERROR_STOP=1 -c "SELECT count(*) FROM mr5_validacion.\"COBRO\" WHERE \"claveIdempotenciaOrigen\"='$idem'")" = "1"
echo "[PASS] Idempotencia física COBRO: una operación por clave de origen"
echo "NOTA: estadoCobro ESTADO_PRUEBA es un dato de laboratorio, NO un literal de negocio aprobado."
