-- ALE MILANESAS | MR-5 | Complemento incremental posterior a MR-3
-- NO EJECUTADO. Aplicar SOLO después de MR-3, en PostgreSQL aislado.
-- No crea tablas, columnas ni FK. Exige preflight de datos y roles de BD adecuados.
-- CU/decisiones: Cobros y reembolsos A; PRA-01; Usuario UC-53..56;
--                   desactivaciones sin cancelar operaciones históricas.
BEGIN;
SET LOCAL lock_timeout = '10s';

-- F01: No existe catálogo completo aprobado de COBRO.estadoCobro.
-- NO inventar CONFIRMADO, PROCESADO, etc. Se limita a impedir literal vacío;
-- la enumeración cerrada sigue pendiente y está etiquetada MR5-F01.
ALTER TABLE "COBRO" ADD CONSTRAINT "ck_mr5_cobro_estado_no_vacio"
  CHECK (length(btrim("estadoCobro")) > 0);

-- F02: Los asientos ya aplicados son inmutables. Cualquier corrección posterior
-- requiere NUEVO movimiento compensatorio; el borrado físico no es admisible.
CREATE OR REPLACE FUNCTION "fn_mr5_bloquear_mutacion_asiento"() RETURNS trigger
LANGUAGE plpgsql AS $mr5$
BEGIN
  IF TG_OP = 'DELETE' THEN
    RAISE EXCEPTION 'No se permite eliminar asientos históricos de %', TG_TABLE_NAME;
  END IF;
  IF NEW IS DISTINCT FROM OLD THEN
    RAISE EXCEPTION 'No se permite modificar asientos históricos de %', TG_TABLE_NAME;
  END IF;
  RETURN NEW;
END;
$mr5$;
CREATE TRIGGER "tg_mr5_movimiento_cuenta_inmutable"
  BEFORE UPDATE OR DELETE ON "MOVIMIENTO_CUENTA" FOR EACH ROW
  EXECUTE FUNCTION "fn_mr5_bloquear_mutacion_asiento"();
CREATE TRIGGER "tg_mr5_origen_movimiento_cuenta_inmutable"
  BEFORE UPDATE OR DELETE ON "ORIGEN_MOVIMIENTO_CUENTA" FOR EACH ROW
  EXECUTE FUNCTION "fn_mr5_bloquear_mutacion_asiento"();
CREATE TRIGGER "tg_mr5_movimiento_caja_inmutable"
  BEFORE UPDATE OR DELETE ON "MOVIMIENTO_CAJA" FOR EACH ROW
  EXECUTE FUNCTION "fn_mr5_bloquear_mutacion_asiento"();

CREATE OR REPLACE FUNCTION "fn_mr5_guardar_cobro"() RETURNS trigger
LANGUAGE plpgsql AS $mr5$
BEGIN
  IF TG_OP = 'DELETE' THEN
    RAISE EXCEPTION 'El Cobro es evidencia financiera y no se elimina';
  END IF;
  IF ROW(NEW."idCobro", NEW."idCliente", NEW."idPedido", NEW."idUsuarioRegistrador",
         NEW."fechaHoraCobro", NEW."importe", NEW."medioPago", NEW."origen",
         NEW."referenciaExterna", NEW."claveIdempotenciaOrigen")
    IS DISTINCT FROM
     ROW(OLD."idCobro", OLD."idCliente", OLD."idPedido", OLD."idUsuarioRegistrador",
         OLD."fechaHoraCobro", OLD."importe", OLD."medioPago", OLD."origen",
         OLD."referenciaExterna", OLD."claveIdempotenciaOrigen") THEN
     RAISE EXCEPTION 'Los datos de un Cobro registrado son inmutables';
  END IF;
  IF OLD."estadoCobro" = 'ANULADO' AND NEW."estadoCobro" <> 'ANULADO' THEN
     RAISE EXCEPTION 'Cobro ANULADO es estado terminal';
  END IF;
  RETURN NEW;
END;
$mr5$;
CREATE TRIGGER "tg_mr5_guardar_cobro"
  BEFORE UPDATE OR DELETE ON "COBRO" FOR EACH ROW
  EXECUTE FUNCTION "fn_mr5_guardar_cobro"();

-- F03: referencia de costo de apertura coherente con fuente, Insumo y valor.
-- Exige registrar COSTO_INSUMO_HISTORICO antes del movimiento SALDO_INICIAL
-- en la MISMA transacción; no simula compras, cobros ni stock previo.
CREATE OR REPLACE FUNCTION "fn_mr5_validar_apertura_insumo"() RETURNS trigger
LANGUAGE plpgsql AS $mr5$
BEGIN
  IF NEW."tipoMovimiento" <> 'SALDO_INICIAL' THEN RETURN NEW; END IF;
  IF NEW."numeroSecuenciaInsumo" <> 1 OR NEW."stockResultante" <> NEW."cantidad" THEN
    RAISE EXCEPTION 'SALDO_INICIAL requiere secuencia 1 y stockResultante = cantidad';
  END IF;
  IF EXISTS (SELECT 1 FROM "MOVIMIENTO_INSUMO" m
    WHERE m."idInsumo"=NEW."idInsumo" AND m."idMovimientoInsumo"<>NEW."idMovimientoInsumo") THEN
    RAISE EXCEPTION 'No se puede abrir stock inicial después de movimientos registrados';
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM "COSTO_INSUMO_HISTORICO" c
    WHERE c."idInsumo" = NEW."idInsumo"
      AND c."vigenteDesde" = NEW."vigenteDesdeCosto"
      AND c."fuenteCosto" = 'SALDO_INICIAL'
      AND c."idRecepcionCompra" IS NULL
  ) THEN
    RAISE EXCEPTION 'Falta COSTO_INSUMO_HISTORICO con fuente SALDO_INICIAL para el Insumo';
  END IF;
  RETURN NEW;
END;
$mr5$;
CREATE TRIGGER "tg_mr5_validar_apertura_insumo"
  BEFORE INSERT OR UPDATE ON "MOVIMIENTO_INSUMO" FOR EACH ROW
  EXECUTE FUNCTION "fn_mr5_validar_apertura_insumo"();
-- Ningún movimiento físico publicado se reescribe; UC-42 crea ajustes nuevos.
CREATE TRIGGER "tg_mr5_movimiento_insumo_inmutable"
  BEFORE UPDATE OR DELETE ON "MOVIMIENTO_INSUMO" FOR EACH ROW
  EXECUTE FUNCTION "fn_mr5_bloquear_mutacion_asiento"();

CREATE OR REPLACE FUNCTION "fn_mr5_proteger_costo_usado"() RETURNS trigger
LANGUAGE plpgsql AS $mr5$
DECLARE v_id BIGINT; v_fecha TIMESTAMPTZ;
BEGIN
  v_id:=OLD."idInsumo"; v_fecha:=OLD."vigenteDesde";
  IF EXISTS (SELECT 1 FROM "MOVIMIENTO_INSUMO" m
    WHERE m."idInsumo"=v_id AND m."vigenteDesdeCosto"=v_fecha) THEN
      IF TG_OP = 'DELETE' THEN
         RAISE EXCEPTION 'Costo histórico usado: no se permite su borrado';
      END IF;
      IF ROW(NEW."idInsumo", NEW."vigenteDesde", NEW."costoUnitario", NEW."fuenteCosto",
             NEW."referenciaOrigen", NEW."idRecepcionCompra")
         IS DISTINCT FROM
         ROW(OLD."idInsumo", OLD."vigenteDesde", OLD."costoUnitario", OLD."fuenteCosto",
             OLD."referenciaOrigen", OLD."idRecepcionCompra") THEN
         RAISE EXCEPTION 'Costo histórico con movimientos registrados: no puede reescribirse';
      END IF;
  END IF;
  IF TG_OP='DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF;
END;
$mr5$;
CREATE TRIGGER "tg_mr5_proteger_costo_usado"
  BEFORE UPDATE OR DELETE ON "COSTO_INSUMO_HISTORICO" FOR EACH ROW
  EXECUTE FUNCTION "fn_mr5_proteger_costo_usado"();

-- F06: PROCESADO exige EXACTAMENTE UN efecto de Caja y UNO de Cuenta.
-- El evento se registra y procesa por el servicio de UC-49; estos controles
-- NO autentican por sí solos firmas MercadoPago ni llaman servicios externos.
CREATE UNIQUE INDEX "uq_mr5_resultado_procesado_aplicable"
 ON "EVENTO_RESULTADO_REEMBOLSO" ("idReembolso")
 WHERE "aplicable" IS TRUE AND "resultadoInformado" = 'PROCESADO';

CREATE OR REPLACE FUNCTION "fn_mr5_validar_reembolso_financiero"() RETURNS trigger
LANGUAGE plpgsql AS $mr5$
DECLARE v_id BIGINT; r record; v_caja INTEGER; v_cuenta INTEGER;
BEGIN
  IF TG_TABLE_NAME='REEMBOLSO' THEN
    v_id := NEW."idReembolso";
  ELSIF TG_TABLE_NAME='MOVIMIENTO_CAJA' THEN
    v_id := NEW."idReembolso";
  ELSE
    v_id := NEW."idReembolso";
  END IF;
  IF v_id IS NULL THEN RETURN NULL; END IF;
  SELECT rr."idReembolso",rr."estado",rr."importeReembolso",c."idCliente"
    INTO r FROM "REEMBOLSO" rr JOIN "COBRO" c ON c."idCobro"=rr."idCobro"
    WHERE rr."idReembolso"=v_id;
  IF NOT FOUND THEN RAISE EXCEPTION 'Reembolso sin Cobro relacionado: %',v_id; END IF;
  SELECT count(*) INTO v_caja FROM "MOVIMIENTO_CAJA" mc
    WHERE mc."idReembolso"=v_id AND mc."origen"='REEMBOLSO'
       AND mc."tipoMovimiento"='EGRESO' AND mc."importe"=r."importeReembolso";
  SELECT count(*) INTO v_cuenta FROM "ORIGEN_MOVIMIENTO_CUENTA" o
    JOIN "MOVIMIENTO_CUENTA" m ON m."idMovimientoCuenta"=o."idMovimientoCuenta"
    WHERE o."idReembolso"=v_id AND m."idCliente"=r."idCliente"
       AND m."tipoMovimiento"='AJUSTE_DEBITO' AND m."importe"=r."importeReembolso";
  IF r."estado"='PROCESADO' THEN
    IF v_caja<>1 OR v_cuenta<>1 THEN
      RAISE EXCEPTION 'Reembolso PROCESADO % exige 1 EGRESO y 1 AJUSTE_DEBITO: caja %, cuenta %',v_id,v_caja,v_cuenta;
    END IF;
  ELSIF EXISTS (SELECT 1 FROM "MOVIMIENTO_CAJA" WHERE "idReembolso"=v_id)
     OR EXISTS (SELECT 1 FROM "ORIGEN_MOVIMIENTO_CUENTA" WHERE "idReembolso"=v_id) THEN
    RAISE EXCEPTION 'Reembolso no procesado no admite efectos financieros: %',v_id;
  END IF;
  RETURN NULL;
END;
$mr5$;
CREATE CONSTRAINT TRIGGER "ct_mr5_reembolso_completo"
  AFTER INSERT OR UPDATE ON "REEMBOLSO" DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW EXECUTE FUNCTION "fn_mr5_validar_reembolso_financiero"();
CREATE CONSTRAINT TRIGGER "ct_mr5_reembolso_caja"
  AFTER INSERT ON "MOVIMIENTO_CAJA" DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW EXECUTE FUNCTION "fn_mr5_validar_reembolso_financiero"();
CREATE CONSTRAINT TRIGGER "ct_mr5_reembolso_cuenta"
  AFTER INSERT ON "ORIGEN_MOVIMIENTO_CUENTA" DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW EXECUTE FUNCTION "fn_mr5_validar_reembolso_financiero"();

CREATE OR REPLACE FUNCTION "fn_mr5_reembolso_estado_terminal"() RETURNS trigger
LANGUAGE plpgsql AS $mr5$
BEGIN
 IF OLD."estado"='PROCESADO' AND NEW."estado" <> OLD."estado" THEN
   RAISE EXCEPTION 'Reembolso PROCESADO es terminal';
 END IF;
 IF ROW(NEW."idCobro",NEW."importeReembolso") IS DISTINCT FROM
    ROW(OLD."idCobro",OLD."importeReembolso") THEN
   RAISE EXCEPTION 'Cobro e importe de Reembolso son históricos e inmutables';
 END IF;
 RETURN NEW;
END;
$mr5$;
CREATE TRIGGER "tg_mr5_reembolso_terminal" BEFORE UPDATE ON "REEMBOLSO"
FOR EACH ROW EXECUTE FUNCTION "fn_mr5_reembolso_estado_terminal"();

-- F07: invariantes diferidas a fin de transacción, permitiendo UC-17 alta
-- atomica de Usuario + Roles + vinculo Proveedor.
CREATE OR REPLACE FUNCTION "fn_mr5_validar_invariantes_usuarios"() RETURNS trigger
LANGUAGE plpgsql AS $mr5$
BEGIN
 PERFORM pg_advisory_xact_lock(60505,7);
 IF EXISTS (SELECT 1 FROM "USUARIO" u WHERE NOT EXISTS
    (SELECT 1 FROM "USUARIO_ROL" ur WHERE ur."idUsuario"=u."idUsuario")) THEN
   RAISE EXCEPTION 'Todo Usuario debe conservar al menos un Rol al confirmar';
 END IF;
 IF NOT EXISTS (SELECT 1 FROM "USUARIO" u
    JOIN "USUARIO_ROL" ur ON ur."idUsuario"=u."idUsuario"
    WHERE u."estado"='HABILITADO' AND ur."codigoRol"='ADMINISTRADOR') THEN
   RAISE EXCEPTION 'Debe conservarse un Administrador habilitado';
 END IF;
 IF EXISTS (SELECT 1 FROM "USUARIO_ROL" r WHERE r."codigoRol"='PROVEEDOR'
    AND EXISTS (SELECT 1 FROM "USUARIO_ROL" r2
       WHERE r2."idUsuario"=r."idUsuario" AND r2."codigoRol"<>'PROVEEDOR')) THEN
    RAISE EXCEPTION 'PROVEEDOR es Rol exclusivo';
 END IF;
 IF EXISTS (SELECT 1 FROM "USUARIO_ROL" r WHERE r."codigoRol"='PROVEEDOR'
    AND NOT EXISTS (SELECT 1 FROM "USUARIO_PROVEEDOR" up
       WHERE up."idUsuario"=r."idUsuario")) THEN
    RAISE EXCEPTION 'Cuenta PROVEEDOR exige vínculo a Proveedor';
 END IF;
 IF EXISTS (
    SELECT 1 FROM "USUARIO_PROVEEDOR" up JOIN "USUARIO" u
      ON u."idUsuario"=up."idUsuario" AND u."estado"='HABILITADO'
    GROUP BY up."idProveedor" HAVING count(*)>1
 ) THEN
    RAISE EXCEPTION 'Solo una cuenta habilitada por Proveedor';
 END IF;
 IF EXISTS (SELECT 1 FROM "USUARIO_PROVEEDOR" up WHERE NOT EXISTS
    (SELECT 1 FROM "USUARIO_ROL" ur WHERE ur."idUsuario"=up."idUsuario"
      AND ur."codigoRol"='PROVEEDOR')) THEN
    RAISE EXCEPTION 'Vínculo USUARIO_PROVEEDOR exige Rol PROVEEDOR';
 END IF;
 RETURN NULL;
END;
$mr5$;
CREATE CONSTRAINT TRIGGER "ct_mr5_usuario_roles" AFTER INSERT OR UPDATE OR DELETE ON "USUARIO"
 DEFERRABLE INITIALLY DEFERRED FOR EACH ROW
 EXECUTE FUNCTION "fn_mr5_validar_invariantes_usuarios"();
CREATE CONSTRAINT TRIGGER "ct_mr5_asignacion_roles" AFTER INSERT OR UPDATE OR DELETE ON "USUARIO_ROL"
 DEFERRABLE INITIALLY DEFERRED FOR EACH ROW
 EXECUTE FUNCTION "fn_mr5_validar_invariantes_usuarios"();
CREATE CONSTRAINT TRIGGER "ct_mr5_usuario_proveedor" AFTER INSERT OR UPDATE OR DELETE ON "USUARIO_PROVEEDOR"
 DEFERRABLE INITIALLY DEFERRED FOR EACH ROW
 EXECUTE FUNCTION "fn_mr5_validar_invariantes_usuarios"();

CREATE OR REPLACE FUNCTION "fn_mr5_revocar_sesiones_usuario"() RETURNS trigger
LANGUAGE plpgsql AS $mr5$
BEGIN
 IF NEW."estado"='DESHABILITADO' AND OLD."estado"<>'DESHABILITADO'
   OR NEW."credencialProtegida" IS DISTINCT FROM OLD."credencialProtegida" THEN
   UPDATE "SESION_USUARIO" su SET "fechaHoraRevocacion"=clock_timestamp()
    WHERE su."idUsuario"=NEW."idUsuario" AND su."fechaHoraRevocacion" IS NULL;
 END IF;
 RETURN NEW;
END;
$mr5$;
CREATE TRIGGER "tg_mr5_revocar_sesiones_usuario" AFTER UPDATE OF "estado","credencialProtegida" ON "USUARIO"
 FOR EACH ROW EXECUTE FUNCTION "fn_mr5_revocar_sesiones_usuario"();
CREATE OR REPLACE FUNCTION "fn_mr5_revocar_sesiones_roles"() RETURNS trigger
LANGUAGE plpgsql AS $mr5$
DECLARE v_id BIGINT;
BEGIN
 v_id:=CASE WHEN TG_OP='DELETE' THEN OLD."idUsuario" ELSE NEW."idUsuario" END;
 UPDATE "SESION_USUARIO" SET "fechaHoraRevocacion"=clock_timestamp()
   WHERE "idUsuario"=v_id AND "fechaHoraRevocacion" IS NULL;
 IF TG_OP='UPDATE' AND OLD."idUsuario" IS DISTINCT FROM NEW."idUsuario" THEN
   UPDATE "SESION_USUARIO" SET "fechaHoraRevocacion"=clock_timestamp()
     WHERE "idUsuario"=OLD."idUsuario" AND "fechaHoraRevocacion" IS NULL;
 END IF;
 RETURN NULL;
END;
$mr5$;
CREATE TRIGGER "tg_mr5_revocar_sesiones_roles" AFTER INSERT OR UPDATE OR DELETE ON "USUARIO_ROL"
 FOR EACH ROW EXECUTE FUNCTION "fn_mr5_revocar_sesiones_roles"();
CREATE TRIGGER "tg_mr5_revocar_sesiones_proveedor" AFTER INSERT OR UPDATE OR DELETE ON "USUARIO_PROVEEDOR"
 FOR EACH ROW EXECUTE FUNCTION "fn_mr5_revocar_sesiones_roles"();

-- F08: PAUSADA -> ACTIVA está físicamente prohibida hasta autorizar un CU
-- de reactivación; PAUSADA -> FINALIZADA/CANCELADA sigue permitido.
CREATE OR REPLACE FUNCTION "fn_mr3_promocion_estado"() RETURNS trigger
LANGUAGE plpgsql AS $mr5$
BEGIN
 IF NEW."estado" IS DISTINCT FROM OLD."estado" THEN
   IF (OLD."estado"='BORRADOR' AND NEW."estado" NOT IN ('ACTIVA','CANCELADA'))
     OR (OLD."estado"='ACTIVA' AND NEW."estado" NOT IN ('PAUSADA','FINALIZADA','CANCELADA'))
     OR (OLD."estado"='PAUSADA' AND NEW."estado" NOT IN ('FINALIZADA','CANCELADA'))
     OR OLD."estado" IN ('FINALIZADA','CANCELADA') THEN
     RAISE EXCEPTION 'Transición de Promoción no autorizada: % -> %',OLD."estado",NEW."estado";
   END IF;
 END IF;
 RETURN NEW;
END;
$mr5$;

-- F09: Bloqueos compatibles con UPDATE para cerrar carrera con desactivación.
-- Se valida una operación NUEVA o el CAMBIO de entidad vinculada; operaciones
-- históricas intactas siguen sus flujos y NO son canceladas.
CREATE OR REPLACE FUNCTION "fn_mr3_validar_pedido_nuevo"() RETURNS trigger
LANGUAGE plpgsql AS $mr5$
BEGIN
 IF TG_OP='UPDATE' AND NEW."idCliente" IS NOT DISTINCT FROM OLD."idCliente" THEN RETURN NEW; END IF;
 PERFORM 1 FROM "CLIENTE" c WHERE c."idCliente"=NEW."idCliente" AND c."estado"='ACTIVO' FOR SHARE;
 IF NOT FOUND THEN RAISE EXCEPTION 'Cliente inactivo o inexistente para operación nueva'; END IF;
 RETURN NEW;
END;
$mr5$;
CREATE TRIGGER "tg_mr5_validar_pedido_cambio_cliente" BEFORE UPDATE OF "idCliente" ON "PEDIDO"
FOR EACH ROW EXECUTE FUNCTION "fn_mr3_validar_pedido_nuevo"();

CREATE OR REPLACE FUNCTION "fn_mr3_validar_producto_detalle_nuevo"() RETURNS trigger
LANGUAGE plpgsql AS $mr5$
BEGIN
 IF TG_OP='UPDATE' AND NEW."idProducto" IS NOT DISTINCT FROM OLD."idProducto" THEN RETURN NEW; END IF;
 PERFORM 1 FROM "PRODUCTO" p WHERE p."idProducto"=NEW."idProducto" AND p."activo" FOR SHARE;
 IF NOT FOUND THEN RAISE EXCEPTION 'Producto inactivo o inexistente para selección nueva'; END IF;
 RETURN NEW;
END;
$mr5$;
CREATE TRIGGER "tg_mr5_validar_detalle_cambio_producto" BEFORE UPDATE OF "idProducto" ON "DETALLE_PEDIDO"
FOR EACH ROW EXECUTE FUNCTION "fn_mr3_validar_producto_detalle_nuevo"();

CREATE OR REPLACE FUNCTION "fn_mr3_validar_invitacion_nueva"() RETURNS trigger
LANGUAGE plpgsql AS $mr5$
DECLARE v_usr BIGINT; v_ins BIGINT; v_fecha TIMESTAMPTZ;
BEGIN
 IF TG_OP='UPDATE' AND ROW(NEW."idSolicitud",NEW."idProveedor")
   IS NOT DISTINCT FROM ROW(OLD."idSolicitud",OLD."idProveedor") THEN RETURN NEW; END IF;
 SELECT up."idUsuario" INTO v_usr FROM "USUARIO_PROVEEDOR" up
   JOIN "USUARIO" uv ON uv."idUsuario"=up."idUsuario" AND uv."estado"='HABILITADO'
   JOIN "USUARIO_ROL" rv ON rv."idUsuario"=up."idUsuario" AND rv."codigoRol"='PROVEEDOR'
   WHERE up."idProveedor"=NEW."idProveedor" LIMIT 1;
 PERFORM 1 FROM "PROVEEDOR" p WHERE p."idProveedor"=NEW."idProveedor" AND p."estado"='ACTIVO' FOR SHARE;
 IF NOT FOUND THEN RAISE EXCEPTION 'Proveedor inactivo para invitación nueva'; END IF;
 PERFORM 1 FROM "USUARIO" u WHERE u."idUsuario"=v_usr AND u."estado"='HABILITADO' FOR SHARE;
 IF NOT FOUND THEN RAISE EXCEPTION 'Proveedor sin cuenta de portal habilitada'; END IF;
 IF NOT EXISTS (SELECT 1 FROM "USUARIO_ROL" ur WHERE ur."idUsuario"=v_usr AND ur."codigoRol"='PROVEEDOR') THEN
   RAISE EXCEPTION 'Cuenta sin Rol PROVEEDOR';
 END IF;
 SELECT e."idInsumo",s."fechaHoraEmision" INTO v_ins,v_fecha FROM "SOLICITUD_COTIZACION" s
    JOIN "EPISODIO_FALTANTE" e ON e."idEpisodio"=s."idEpisodio"
    WHERE s."idSolicitud"=NEW."idSolicitud" AND e."fechaHoraCierre" IS NULL;
 IF NOT FOUND OR NOT EXISTS (SELECT 1 FROM "PROVEEDOR_INSUMO" pi
    WHERE pi."idProveedor"=NEW."idProveedor" AND pi."idInsumo"=v_ins
    AND pi."vigenteDesde"<=v_fecha
    AND (pi."vigenteHasta" IS NULL OR pi."vigenteHasta">v_fecha)) THEN
    RAISE EXCEPTION 'Proveedor no elegible para episodio abierto';
 END IF;
 RETURN NEW;
END;
$mr5$;
CREATE TRIGGER "tg_mr5_validar_invitacion_cambio" BEFORE UPDATE OF "idSolicitud","idProveedor" ON "INVITACION_COTIZACION"
FOR EACH ROW EXECUTE FUNCTION "fn_mr3_validar_invitacion_nueva"();

CREATE OR REPLACE FUNCTION "fn_mr3_validar_orden_nueva"() RETURNS trigger
LANGUAGE plpgsql AS $mr5$
DECLARE v_proveedor BIGINT;
BEGIN
 IF TG_OP='UPDATE' AND NEW."idDecisionCompra" IS NOT DISTINCT FROM OLD."idDecisionCompra" THEN RETURN NEW; END IF;
 SELECT r."idProveedor" INTO v_proveedor FROM "DECISION_COMPRA" d
 JOIN "RESPUESTA_COTIZACION" r ON r."idRespuesta"=d."idRespuestaSeleccionada"
 WHERE d."idDecisionCompra"=NEW."idDecisionCompra" AND d."resultado"='COMPRA';
 IF NOT FOUND THEN RAISE EXCEPTION 'Orden nueva sin decisión COMPRA válida'; END IF;
 PERFORM 1 FROM "PROVEEDOR" p WHERE p."idProveedor"=v_proveedor AND p."estado"='ACTIVO' FOR SHARE;
 IF NOT FOUND THEN RAISE EXCEPTION 'Proveedor inactivo para nueva Orden de Compra'; END IF;
 RETURN NEW;
END;
$mr5$;
CREATE TRIGGER "tg_mr5_validar_orden_cambio_decision" BEFORE UPDATE OF "idDecisionCompra" ON "ORDEN_COMPRA"
 FOR EACH ROW EXECUTE FUNCTION "fn_mr3_validar_orden_nueva"();

-- F05: Controles físicos auxiliares de PRA-01, NO equivalen a su servicio.
CREATE OR REPLACE FUNCTION "fn_mr5_validar_primera_ronda"() RETURNS trigger
LANGUAGE plpgsql AS $mr5$
DECLARE v_plazo INTEGER; v_cierre TIMESTAMPTZ; v_ins BIGINT; v_automatico BOOLEAN; v_stock NUMERIC; v_umbral NUMERIC;
BEGIN
 SELECT e."plazoRespuestaHorasAplicado",e."fechaHoraCierre",e."idInsumo",
        i."automatizacionCompraActiva",i."stockActual",i."umbralMinimo"
 INTO v_plazo,v_cierre,v_ins,v_automatico,v_stock,v_umbral
 FROM "EPISODIO_FALTANTE" e JOIN "INSUMO" i ON i."idInsumo"=e."idInsumo"
 WHERE e."idEpisodio"=NEW."idEpisodio" FOR UPDATE OF e;
 IF NOT FOUND OR v_cierre IS NOT NULL THEN
   RAISE EXCEPTION 'No se crean solicitudes en un episodio cerrado o inexistente';
 END IF;
 IF NEW."modalidadInicio"='AUTOMATICA' THEN
   IF NEW."idSolicitudAnterior" IS NOT NULL OR NOT v_automatico OR v_stock>=v_umbral
     OR v_plazo IS NULL OR NEW."fechaHoraVencimiento" <> NEW."fechaHoraEmision" + make_interval(hours=>v_plazo) THEN
     RAISE EXCEPTION 'Primera ronda automática no cumple condiciones del episodio/plazo congelado';
   END IF;
 END IF;
 RETURN NEW;
END;
$mr5$;
CREATE TRIGGER "tg_mr5_validar_primera_ronda" BEFORE INSERT ON "SOLICITUD_COTIZACION"
FOR EACH ROW EXECUTE FUNCTION "fn_mr5_validar_primera_ronda"();

CREATE OR REPLACE FUNCTION "fn_mr5_validar_cierre_episodio"() RETURNS trigger
LANGUAGE plpgsql AS $mr5$
DECLARE v_stock NUMERIC(18,3); v_umbral NUMERIC(18,3);
BEGIN
 IF OLD."fechaHoraCierre" IS NOT NULL AND NEW."fechaHoraCierre" IS DISTINCT FROM OLD."fechaHoraCierre" THEN
   RAISE EXCEPTION 'Episodio cerrado no puede reabrirse';
 END IF;
 IF OLD."fechaHoraCierre" IS NULL AND NEW."fechaHoraCierre" IS NOT NULL THEN
   SELECT i."stockActual",i."umbralMinimo" INTO v_stock,v_umbral
     FROM "INSUMO" i WHERE i."idInsumo"=NEW."idInsumo" FOR SHARE;
   IF v_stock < v_umbral OR v_stock IS NULL THEN
     RAISE EXCEPTION 'No cerrar episodio: stock aún bajo umbral';
   END IF;
   IF EXISTS (SELECT 1 FROM "SOLICITUD_COTIZACION" s
       WHERE s."idEpisodio"=NEW."idEpisodio" AND s."estado" NOT IN ('RESUELTA_CON_COMPRA','RESUELTA_SIN_COMPRA')) THEN
     RAISE EXCEPTION 'No cerrar episodio con solicitudes sin resolver';
   END IF;
   IF EXISTS (SELECT 1 FROM "ORDEN_COMPRA" oc
       JOIN "DECISION_COMPRA" d ON d."idDecisionCompra"=oc."idDecisionCompra"
       JOIN "SOLICITUD_COTIZACION" s ON s."idSolicitud"=d."idSolicitud"
       WHERE s."idEpisodio"=NEW."idEpisodio"
         AND oc."estado" IN ('PENDIENTE','PARCIALMENTE_RECIBIDA')) THEN
     RAISE EXCEPTION 'No cerrar episodio con Orden de Compra pendiente';
   END IF;
 END IF;
 RETURN NEW;
END;
$mr5$;
CREATE TRIGGER "tg_mr5_validar_cierre_episodio" BEFORE UPDATE OF "fechaHoraCierre" ON "EPISODIO_FALTANTE"
FOR EACH ROW EXECUTE FUNCTION "fn_mr5_validar_cierre_episodio"();


-- F06: Si un evento externo PROCESADO se declara aplicable, el Reembolso
-- correspondiente debe quedar PROCESADO antes de confirmar la transacción.
CREATE OR REPLACE FUNCTION "fn_mr5_validar_evento_aplicable"() RETURNS trigger
LANGUAGE plpgsql AS $mr5$
BEGIN
  IF NEW."aplicable" AND NEW."resultadoInformado"='PROCESADO'
     AND NOT EXISTS (SELECT 1 FROM "REEMBOLSO" r
       WHERE r."idReembolso"=NEW."idReembolso" AND r."estado"='PROCESADO') THEN
    RAISE EXCEPTION 'Evento PROCESADO aplicable sin Reembolso PROCESADO';
  END IF;
  RETURN NULL;
END;
$mr5$;
CREATE CONSTRAINT TRIGGER "ct_mr5_evento_aplicable"
 AFTER INSERT OR UPDATE ON "EVENTO_RESULTADO_REEMBOLSO"
 DEFERRABLE INITIALLY DEFERRED FOR EACH ROW
 EXECUTE FUNCTION "fn_mr5_validar_evento_aplicable"();

COMMIT;
