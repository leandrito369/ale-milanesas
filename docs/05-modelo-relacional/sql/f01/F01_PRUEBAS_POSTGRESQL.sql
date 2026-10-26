-- Ejecutar tras MR5 + F01 dentro del schema mr5_validacion en base aislada.
\set ON_ERROR_STOP on
BEGIN;
SET LOCAL search_path TO mr5_validacion,public;
DO $f01$
DECLARE v_error TEXT;
BEGIN
  IF current_database() NOT LIKE 'ale_mr5_%' THEN
    RAISE EXCEPTION 'F01: requiere BD descartable ale_mr5_%%';
  END IF;
  INSERT INTO "CLIENTE" ("idCliente","nombres","telefonoPrincipal","estado","categoriaComercial","fechaHoraAlta")
    VALUES(901001,'Cliente F01','3755009001','ACTIVO','CUMPLIDOR',clock_timestamp());
  INSERT INTO "COBRO" ("idCobro","idCliente","fechaHoraCobro","importe","medioPago","origen","estadoCobro","claveIdempotenciaOrigen")
    VALUES (901001,901001,clock_timestamp(),100,'EFECTIVO','ADMINISTRACION','CONFIRMADO','e326439c-c1df-434d-b298-4ac00c71d92a');
  IF (SELECT "estadoCobro" FROM "COBRO" WHERE "idCobro"=901001)<>'CONFIRMADO' THEN
    RAISE EXCEPTION 'F01: alta CONFIRMADO falló';
  END IF;
  BEGIN
    INSERT INTO "COBRO"("idCobro","idCliente","fechaHoraCobro","importe","medioPago","origen","estadoCobro")
      VALUES(901002,901001,clock_timestamp(),10,'EFECTIVO','ADMINISTRACION','PENDIENTE');
    RAISE EXCEPTION 'FAIL_F01: INSERT PENDIENTE aceptado';
  EXCEPTION WHEN others THEN
    GET STACKED DIAGNOSTICS v_error=MESSAGE_TEXT;
    IF v_error LIKE 'FAIL_F01:%' THEN RAISE; END IF;
  END;
  BEGIN
    INSERT INTO "COBRO"("idCobro","idCliente","fechaHoraCobro","importe","medioPago","origen","estadoCobro")
      VALUES(901003,901001,clock_timestamp(),10,'EFECTIVO','ADMINISTRACION','ANULADO');
    RAISE EXCEPTION 'FAIL_F01: INSERT ANULADO aceptado';
  EXCEPTION WHEN others THEN
    GET STACKED DIAGNOSTICS v_error=MESSAGE_TEXT;
    IF v_error LIKE 'FAIL_F01:%' THEN RAISE; END IF;
  END;
  BEGIN
    UPDATE "COBRO" SET "estadoCobro"='PENDIENTE' WHERE "idCobro"=901001;
    RAISE EXCEPTION 'FAIL_F01: UPDATE PENDIENTE aceptado';
  EXCEPTION WHEN others THEN
    GET STACKED DIAGNOSTICS v_error=MESSAGE_TEXT;
    IF v_error LIKE 'FAIL_F01:%' THEN RAISE; END IF;
  END;
  BEGIN
    INSERT INTO "COBRO"("idCobro","idCliente","fechaHoraCobro","importe","medioPago","origen","estadoCobro")
      VALUES(901004,901001,clock_timestamp(),10,'EFECTIVO','ADMINISTRACION','ESTADO_PRUEBA');
    RAISE EXCEPTION 'FAIL_F01: ESTADO_PRUEBA aceptado';
  EXCEPTION WHEN others THEN
    GET STACKED DIAGNOSTICS v_error=MESSAGE_TEXT;
    IF v_error LIKE 'FAIL_F01:%' THEN RAISE; END IF;
  END;
  BEGIN
    INSERT INTO "COBRO"("idCobro","idCliente","fechaHoraCobro","importe","medioPago","origen","estadoCobro","claveIdempotenciaOrigen")
      VALUES(901005,901001,clock_timestamp(),10,'EFECTIVO','ADMINISTRACION','CONFIRMADO','e326439c-c1df-434d-b298-4ac00c71d92a');
    RAISE EXCEPTION 'FAIL_F01: duplicado idempotente aceptado';
  EXCEPTION WHEN others THEN
    GET STACKED DIAGNOSTICS v_error=MESSAGE_TEXT;
    IF v_error LIKE 'FAIL_F01:%' THEN RAISE; END IF;
  END;
  RAISE NOTICE '[F01 PASS] Alta CONFIRMADO, rechazos, integridad e idempotencia';
END
$f01$;
ROLLBACK;
