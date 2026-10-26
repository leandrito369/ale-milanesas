-- F01 (APROBADA 26/10/2026): catálogo COBRO.CONFIRMADO / ANULADO.
-- Ejecutar DESPUES de MR5. Revisar datos históricos antes de aplicar.
-- En laboratorio se aplica solo en una base descartable.
\set ON_ERROR_STOP on
BEGIN;
SET LOCAL lock_timeout = '10s';
DO $guard$
BEGIN
  IF EXISTS (SELECT 1 FROM "COBRO" WHERE "estadoCobro" NOT IN ('CONFIRMADO','ANULADO')) THEN
    RAISE EXCEPTION 'F01: hay COBRO.estadoCobro desconocidos; conciliar antes de migrar';
  END IF;
END
$guard$;
ALTER TABLE "COBRO" ADD CONSTRAINT "ck_f01_cobro_estado"
  CHECK ("estadoCobro" IN ('CONFIRMADO','ANULADO'));
CREATE OR REPLACE FUNCTION "fn_f01_transicion_cobro"()
RETURNS trigger LANGUAGE plpgsql AS $f01$
BEGIN
  IF TG_OP='INSERT' THEN
    IF NEW."estadoCobro"<>'CONFIRMADO' THEN
      RAISE EXCEPTION 'F01: un COBRO nuevo debe nacer CONFIRMADO';
    END IF;
  ELSIF NEW."estadoCobro" IS DISTINCT FROM OLD."estadoCobro"
       AND (OLD."estadoCobro"<>'CONFIRMADO' OR NEW."estadoCobro"<>'ANULADO') THEN
    RAISE EXCEPTION 'F01: transición de COBRO no permitida';
  END IF;
  RETURN NEW;
END
$f01$;
CREATE TRIGGER "tg_f01_transicion_cobro"
  BEFORE INSERT OR UPDATE OF "estadoCobro" ON "COBRO"
  FOR EACH ROW EXECUTE FUNCTION "fn_f01_transicion_cobro"();
COMMIT;
