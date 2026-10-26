-- ALE MILANESAS MR-3: MIGRACION PROPUESTA SOBRE ESQUEMA 59 TABLAS 23/10/2026
-- NO EJECUTADA. ANTES: ejecutar PRECHECK_MR3.sql, respaldar datos y validar triggers/aplicación.
-- No se asigna por defecto 48 horas ni 15 dias. Cada cláusula asume PostgreSQL con btree_gist.
BEGIN;
CREATE EXTENSION IF NOT EXISTS btree_gist;

-- MR3-01 SALDO_INICIAL (apertura física; UC-42), sin recepción inventada.
ALTER TABLE "MOVIMIENTO_INSUMO" DROP CONSTRAINT "ck_movimiento_insumo_3";
ALTER TABLE "MOVIMIENTO_INSUMO" ADD CONSTRAINT "ck_movimiento_insumo_3" CHECK ("tipoMovimiento" IN ('INGRESO_COMPRA','CONSUMO_PRODUCCION','AJUSTE_POSITIVO','AJUSTE_NEGATIVO','SALDO_INICIAL'));
ALTER TABLE "MOVIMIENTO_INSUMO" ADD CONSTRAINT "ck_mov_insumo_saldo_inicial_origen" CHECK (
    "tipoMovimiento" <> 'SALDO_INICIAL' OR ("idPreparacion" IS NULL AND "idRecepcionCompra" IS NULL AND "origen" = 'APERTURA_INVENTARIO')
);
CREATE UNIQUE INDEX "uq_movimiento_insumo_saldo_inicial" ON "MOVIMIENTO_INSUMO" ("idInsumo") WHERE "tipoMovimiento" = 'SALDO_INICIAL';
ALTER TABLE "COSTO_INSUMO_HISTORICO" ADD CONSTRAINT "ck_costo_saldo_inicial" CHECK (
    "fuenteCosto" <> 'SALDO_INICIAL' OR "idRecepcionCompra" IS NULL
);

-- MR3-02 Índices UNIQUE por nombres normalizados; Cliente conserva teléfonos compartidos.
CREATE UNIQUE INDEX "uq_insumo_nombre_normalizado" ON "INSUMO" (lower(regexp_replace(btrim("nombre"), '[[:space:]]+', ' ', 'g')));
CREATE UNIQUE INDEX "uq_cliente_nombre_telefono_normalizado" ON "CLIENTE" (
    lower(regexp_replace(btrim("nombres" || ' ' || coalesce("apellidos", '')), '[[:space:]]+', ' ', 'g')),
    regexp_replace("telefonoPrincipal", '[^0-9]', '', 'g')
);

-- MR3-03 EXCLUDE GiST con vigencias [desde,hasta), sin solapamientos.
ALTER TABLE "VERSION_RECETA" ADD CONSTRAINT "ex_version_receta_no_solape" EXCLUDE USING gist (
    "idReceta" WITH =, tstzrange("vigenteDesde", COALESCE("vigenteHasta", 'infinity'::timestamptz), '[)') WITH &&
);
ALTER TABLE "PRECIO_PRODUCTO" ADD CONSTRAINT "ex_precio_producto_no_solape" EXCLUDE USING gist (
    "idProducto" WITH =, tstzrange("vigenteDesde", COALESCE("vigenteHasta", 'infinity'::timestamptz), '[)') WITH &&
) WHERE ("fechaHoraCancelacion" IS NULL);
ALTER TABLE "POLITICA_CATEGORIA_COMERCIAL" ADD CONSTRAINT "ex_politica_categoria_no_solape" EXCLUDE USING gist (
    tstzrange("vigenteDesde", COALESCE("vigenteHasta", 'infinity'::timestamptz), '[)') WITH &&
);
ALTER TABLE "POLITICA_COMPRA" ADD CONSTRAINT "ex_politica_compra_no_solape" EXCLUDE USING gist (
    tstzrange("vigenteDesde", COALESCE("vigenteHasta", 'infinity'::timestamptz), '[)') WITH &&
);

-- MR3-04 Catálogo de cinco estados acordado, sin modificación de pedidos previos.
ALTER TABLE "PROMOCION" ADD CONSTRAINT "ck_promocion_estado_mr3" CHECK (
    "estado" IN ('BORRADOR','ACTIVA','PAUSADA','FINALIZADA','CANCELADA')
);

-- MR3-05 Configuración global sin duración inventada; plazo aplicado congelado en episodio/solicitud.
CREATE TABLE "CONFIGURACION_OPERATIVA" (
    "clave" VARCHAR(80) NOT NULL,
    "valorEntero" INTEGER NOT NULL,
    "fechaHoraModificacion" TIMESTAMPTZ NOT NULL,
    "idUsuarioAdministrador" BIGINT NOT NULL,
    CONSTRAINT "pk_configuracion_operativa" PRIMARY KEY ("clave"),
    CONSTRAINT "ck_configuracion_operativa_plazo" CHECK (
        "clave" = 'PLAZO_RESPUESTA_COTIZACION_HORAS' AND "valorEntero" > 0
    ),
    CONSTRAINT "fk_configuracion_operativa_usuario" FOREIGN KEY ("idUsuarioAdministrador")
        REFERENCES "USUARIO" ("idUsuario") ON UPDATE RESTRICT ON DELETE RESTRICT
);
ALTER TABLE "EPISODIO_FALTANTE" ADD COLUMN "plazoRespuestaHorasAplicado" INTEGER;
ALTER TABLE "EPISODIO_FALTANTE" ADD COLUMN "idUsuarioAjustePlazo" BIGINT;
ALTER TABLE "EPISODIO_FALTANTE" ADD CONSTRAINT "ck_episodio_plazo_aplicado" CHECK (
    "plazoRespuestaHorasAplicado" IS NULL OR "plazoRespuestaHorasAplicado" > 0
);
ALTER TABLE "EPISODIO_FALTANTE" ADD CONSTRAINT "ck_episodio_override_plazo" CHECK (
    "idUsuarioAjustePlazo" IS NULL OR "plazoRespuestaHorasAplicado" IS NOT NULL
);
ALTER TABLE "EPISODIO_FALTANTE" ADD CONSTRAINT "fk_episodio_usuario_ajuste_plazo" FOREIGN KEY ("idUsuarioAjustePlazo")
    REFERENCES "USUARIO" ("idUsuario") ON UPDATE RESTRICT ON DELETE RESTRICT;

-- MR3-06 Respuesta sin plazo informado válida; puntaje mínimo cero para criterio sin dato, sin pesos fijos.
ALTER TABLE "RESPUESTA_COTIZACION" DROP CONSTRAINT "ck_respuesta_cotizacion_1";
ALTER TABLE "RESPUESTA_COTIZACION" ADD CONSTRAINT "ck_respuesta_cotizacion_1" CHECK (
    ("cantidadOfrecida" = 0 AND "precioUnitario" IS NULL AND "tiempoEntregaEstimado" IS NULL)
    OR ("cantidadOfrecida" > 0 AND "precioUnitario" IS NOT NULL AND "precioUnitario" > 0
        AND ("tiempoEntregaEstimado" IS NULL OR "tiempoEntregaEstimado" > INTERVAL '0 seconds'))
);
ALTER TABLE "DETALLE_DECISION_CRITERIO" DROP CONSTRAINT "ck_detalle_decision_criterio_0";
ALTER TABLE "DETALLE_DECISION_CRITERIO" ADD CONSTRAINT "ck_detalle_decision_criterio_0" CHECK (
    NOT ("valorNumerico" IS NOT NULL AND "valorTexto" IS NOT NULL)
);
ALTER TABLE "DETALLE_DECISION_CRITERIO" ADD CONSTRAINT "ck_criterio_dato_faltante_puntaje" CHECK (
    (("valorNumerico" IS NULL AND "valorTexto" IS NULL) AND "puntajeEvaluado" = 0)
    OR (("valorNumerico" IS NOT NULL OR "valorTexto" IS NOT NULL) AND ("puntajeEvaluado" IS NULL OR "puntajeEvaluado" >= 0))
);

-- MR3-07 Contraasiento de Cobro con FK diferenciada, movimiento negativo de Caja como EGRESO.
ALTER TABLE "MOVIMIENTO_CUENTA" DROP CONSTRAINT "ck_movimiento_cuenta_2";
ALTER TABLE "MOVIMIENTO_CUENTA" ADD CONSTRAINT "ck_movimiento_cuenta_2" CHECK (
    "tipoMovimiento" IN ('CARGO_POR_VENTA','PAGO','AJUSTE_DEBITO','AJUSTE_CREDITO','ANULACION_COBRO')
);
ALTER TABLE "ORIGEN_MOVIMIENTO_CUENTA" ADD COLUMN "idCobroAnulado" BIGINT;
ALTER TABLE "ORIGEN_MOVIMIENTO_CUENTA" DROP CONSTRAINT "ck_origen_movimiento_cuenta_0";
ALTER TABLE "ORIGEN_MOVIMIENTO_CUENTA" ADD CONSTRAINT "ck_origen_movimiento_cuenta_0" CHECK (
    num_nonnulls("idPedidoEntrega","idCobro","idReembolso","idCobroAnulado") = 1
);
ALTER TABLE "ORIGEN_MOVIMIENTO_CUENTA" ADD CONSTRAINT "uq_origen_cuenta_cobro_anulado" UNIQUE ("idCobroAnulado");
ALTER TABLE "ORIGEN_MOVIMIENTO_CUENTA" ADD CONSTRAINT "fk_origen_cuenta_cobro_anulado" FOREIGN KEY ("idCobroAnulado")
    REFERENCES "COBRO" ("idCobro") ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE "MOVIMIENTO_CAJA" ADD COLUMN "idCobroAnulado" BIGINT;
ALTER TABLE "MOVIMIENTO_CAJA" DROP CONSTRAINT "ck_movimiento_caja_2";
ALTER TABLE "MOVIMIENTO_CAJA" ADD CONSTRAINT "ck_movimiento_caja_2" CHECK (
    "origen" IN ('MANUAL','COBRO','REEMBOLSO','ANULACION_COBRO')
);
ALTER TABLE "MOVIMIENTO_CAJA" ADD CONSTRAINT "uq_caja_cobro_anulado" UNIQUE ("idCobroAnulado");
ALTER TABLE "MOVIMIENTO_CAJA" ADD CONSTRAINT "fk_caja_cobro_anulado" FOREIGN KEY ("idCobroAnulado")
    REFERENCES "COBRO" ("idCobro") ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE "MOVIMIENTO_CAJA" ADD CONSTRAINT "ck_caja_anulacion_cobro" CHECK (
    ("origen" = 'ANULACION_COBRO' AND "tipoMovimiento" = 'EGRESO' AND "idCobroAnulado" IS NOT NULL
        AND "idCobro" IS NULL AND "idReembolso" IS NULL AND "idUsuarioRegistro" IS NOT NULL)
    OR ("origen" <> 'ANULACION_COBRO' AND "idCobroAnulado" IS NULL)
);

-- MR3-08 Responsable opcional para primer intento automático; obligatorio en reintentos administrativos.
ALTER TABLE "INTENTO_REEMBOLSO" ADD COLUMN "idUsuarioReintento" BIGINT;
ALTER TABLE "INTENTO_REEMBOLSO" ADD CONSTRAINT "fk_intento_reembolso_usuario_reintento" FOREIGN KEY ("idUsuarioReintento")
    REFERENCES "USUARIO" ("idUsuario") ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE "INTENTO_REEMBOLSO" ADD CONSTRAINT "ck_intento_reembolso_responsable" CHECK (
    ("numeroIntento" = 1 AND "idUsuarioReintento" IS NULL)
    OR ("numeroIntento" > 1 AND "idUsuarioReintento" IS NOT NULL)
);


-- MR3-09: Estados de promocion. El paso temporal a FINALIZADA se ejecuta por tarea autorizada;
-- un CHECK no puede forzar un cambio temporal por reloj.
CREATE OR REPLACE FUNCTION "fn_mr3_promocion_estado"() RETURNS trigger
LANGUAGE plpgsql AS $mr3$
BEGIN
    IF TG_OP = 'UPDATE' AND NEW."estado" IS DISTINCT FROM OLD."estado" THEN
        IF (OLD."estado" = 'BORRADOR' AND NEW."estado" NOT IN ('ACTIVA','CANCELADA'))
           OR (OLD."estado" = 'ACTIVA' AND NEW."estado" NOT IN ('PAUSADA','FINALIZADA','CANCELADA'))
           OR (OLD."estado" = 'PAUSADA' AND NEW."estado" NOT IN ('ACTIVA','FINALIZADA','CANCELADA'))
           OR (OLD."estado" IN ('FINALIZADA','CANCELADA')) THEN
            RAISE EXCEPTION 'Transicion de promocion no permitida: % -> %', OLD."estado", NEW."estado";
        END IF;
    END IF;
    RETURN NEW;
END;
$mr3$;
CREATE TRIGGER "tg_mr3_promocion_estado" BEFORE UPDATE OF "estado" ON "PROMOCION"
FOR EACH ROW EXECUTE FUNCTION "fn_mr3_promocion_estado"();

-- MR3-10: Congelar plazo de EPISODIO luego de la primera SOLICITUD. No atribuye 48 h.
CREATE OR REPLACE FUNCTION "fn_mr3_proteger_plazo_episodio"() RETURNS trigger
LANGUAGE plpgsql AS $mr3$
BEGIN
  IF (NEW."plazoRespuestaHorasAplicado", NEW."idUsuarioAjustePlazo")
     IS DISTINCT FROM (OLD."plazoRespuestaHorasAplicado", OLD."idUsuarioAjustePlazo")
     AND EXISTS (SELECT 1 FROM "SOLICITUD_COTIZACION" s WHERE s."idEpisodio" = OLD."idEpisodio") THEN
     RAISE EXCEPTION 'Plazo de episodio ya utilizado; las solicitudes emitidas son inmutables';
  END IF;
  RETURN NEW;
END;
$mr3$;
CREATE TRIGGER "tg_mr3_proteger_plazo_episodio" BEFORE UPDATE OF "plazoRespuestaHorasAplicado", "idUsuarioAjustePlazo" ON "EPISODIO_FALTANTE"
FOR EACH ROW EXECUTE FUNCTION "fn_mr3_proteger_plazo_episodio"();

-- MR3-11: Imposibilitar cambio de Unidad de Medida con historial de Insumo.
CREATE OR REPLACE FUNCTION "fn_mr3_proteger_unidad_insumo"() RETURNS trigger
LANGUAGE plpgsql AS $mr3$
BEGIN
   IF NEW."codigoUnidadMedida" IS DISTINCT FROM OLD."codigoUnidadMedida"
      AND (EXISTS (SELECT 1 FROM "MOVIMIENTO_INSUMO" m WHERE m."idInsumo" = OLD."idInsumo")
      OR EXISTS (SELECT 1 FROM "DETALLE_VERSION_RECETA" d WHERE d."idInsumo" = OLD."idInsumo")
      OR EXISTS (SELECT 1 FROM "RECEPCION_COMPRA" r WHERE r."idInsumoRecibido" = OLD."idInsumo")) THEN
       RAISE EXCEPTION 'No se puede cambiar unidad de insumo con historial dependiente';
   END IF;
   RETURN NEW;
END;
$mr3$;
CREATE TRIGGER "tg_mr3_proteger_unidad_insumo" BEFORE UPDATE OF "codigoUnidadMedida" ON "INSUMO"
FOR EACH ROW EXECUTE FUNCTION "fn_mr3_proteger_unidad_insumo"();

-- MR3-12: La respuesta solo se recibe mientras Solicitud está abierta, antes del vencimiento;
-- el valor de tiempoEntregaEstimado puede faltar, sin forzar una respuesta ficticia.
CREATE OR REPLACE FUNCTION "fn_mr3_validar_respuesta_cotizacion"() RETURNS trigger
LANGUAGE plpgsql AS $mr3$
DECLARE s record;
BEGIN
    SELECT "estado", "fechaHoraVencimiento" INTO s FROM "SOLICITUD_COTIZACION"
      WHERE "idSolicitud" = NEW."idSolicitud" FOR UPDATE;
    IF NOT FOUND OR s."estado" <> 'RECEPCION_ABIERTA' OR clock_timestamp() >= s."fechaHoraVencimiento" THEN
       RAISE EXCEPTION 'Solicitud inexistente, cerrada o vencida';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM "INVITACION_COTIZACION" i
        JOIN "PROVEEDOR" p ON p."idProveedor"=i."idProveedor" AND p."estado"='ACTIVO'
        WHERE i."idSolicitud" = NEW."idSolicitud" AND i."idProveedor" = NEW."idProveedor") THEN
       RAISE EXCEPTION 'Proveedor no invitado o inactivo al responder';
    END IF;
    RETURN NEW;
END;
$mr3$;
CREATE TRIGGER "tg_mr3_validar_respuesta_cotizacion" BEFORE INSERT ON "RESPUESTA_COTIZACION"
FOR EACH ROW EXECUTE FUNCTION "fn_mr3_validar_respuesta_cotizacion"();

-- MR3-13: Contraasiento administrativo. Parametros de IDs provistos por la capa de aplicación
-- (base de esquema académico no define secuencias de identificadores). La función es atómica.
CREATE OR REPLACE FUNCTION "fn_mr3_anular_cobro_manual"(
    p_id_cobro BIGINT, p_id_usuario_admin BIGINT, p_id_mov_cuenta BIGINT, p_id_mov_caja BIGINT,
    p_motivo TEXT
) RETURNS void LANGUAGE plpgsql AS $mr3$
DECLARE c record; s NUMERIC(18,2); n BIGINT;
BEGIN
    IF length(btrim(coalesce(p_motivo, ''))) = 0 THEN RAISE EXCEPTION 'Motivo requerido'; END IF;
    IF NOT EXISTS (SELECT 1 FROM "USUARIO" u JOIN "USUARIO_ROL" ur ON ur."idUsuario"=u."idUsuario"
        WHERE u."idUsuario"=p_id_usuario_admin AND u."estado"='HABILITADO'
        AND ur."codigoRol"='ADMINISTRADOR') THEN
        RAISE EXCEPTION 'Solo Administrador habilitado puede anular cobro';
    END IF;
    SELECT * INTO c FROM "COBRO" WHERE "idCobro"=p_id_cobro FOR UPDATE;
    IF NOT FOUND THEN RAISE EXCEPTION 'Cobro no encontrado'; END IF;
    IF c."origen"='ONLINE' OR c."medioPago"='MERCADOPAGO' THEN
       RAISE EXCEPTION 'La anulacion local no reemplaza reembolso electronico';
    END IF;
    IF c."estadoCobro"='ANULADO' OR EXISTS (SELECT 1 FROM "REEMBOLSO" r WHERE r."idCobro"=p_id_cobro)
       OR NOT EXISTS (SELECT 1 FROM "MOVIMIENTO_CAJA" mc
           WHERE mc."idCobro"=p_id_cobro AND mc."origen"='COBRO'
             AND mc."tipoMovimiento"='INGRESO' AND mc."importe"=c."importe") THEN
       RAISE EXCEPTION 'Cobro ya anulado, reembolsado o sin asiento original valido';
    END IF;
    PERFORM 1 FROM "CLIENTE" WHERE "idCliente"=c."idCliente" FOR UPDATE;
    SELECT mc."saldoResultante", mc."numeroSecuenciaCliente" INTO s,n FROM "MOVIMIENTO_CUENTA" mc
       WHERE mc."idCliente"=c."idCliente" ORDER BY mc."numeroSecuenciaCliente" DESC LIMIT 1;
    IF n IS NULL THEN RAISE EXCEPTION 'Sin cuenta corriente de referencia'; END IF;
    IF NOT EXISTS (SELECT 1 FROM "ORIGEN_MOVIMIENTO_CUENTA" o
         JOIN "MOVIMIENTO_CUENTA" m ON m."idMovimientoCuenta"=o."idMovimientoCuenta"
         WHERE o."idCobro"=p_id_cobro AND m."tipoMovimiento"='PAGO'
         AND m."importe"=c."importe" AND m."idCliente"=c."idCliente") THEN
       RAISE EXCEPTION 'Sin pago original conciliable';
    END IF;
    INSERT INTO "MOVIMIENTO_CUENTA" (
        "idMovimientoCuenta","idCliente","numeroSecuenciaCliente","tipoMovimiento","importe",
        "fechaHoraMovimiento","saldoResultante","idUsuarioAjuste","observacion"
    ) VALUES (p_id_mov_cuenta,c."idCliente",n+1,'ANULACION_COBRO',c."importe",
        clock_timestamp(),s+c."importe",p_id_usuario_admin,p_motivo);
    INSERT INTO "ORIGEN_MOVIMIENTO_CUENTA" ("idMovimientoCuenta","idCobroAnulado")
       VALUES(p_id_mov_cuenta,p_id_cobro);
    INSERT INTO "MOVIMIENTO_CAJA" ("idMovimientoCaja","tipoMovimiento","importe","fechaHoraMovimiento",
       "origen","concepto","observacion","idUsuarioRegistro","idCobroAnulado")
       VALUES(p_id_mov_caja,'EGRESO',c."importe",clock_timestamp(),
       'ANULACION_COBRO','Contraasiento de cobro manual',p_motivo,p_id_usuario_admin,p_id_cobro);
    UPDATE "COBRO" SET "estadoCobro"='ANULADO' WHERE "idCobro"=p_id_cobro;
END;
$mr3$;

-- MR3-14: Impedir reescribir las condiciones históricas de Cotización y Reparto por cambios
-- posteriores de catálogo: debe completarse en el servicio de sincronización y sus pruebas.
-- MR3-15: El 'Precio Total' es último desempate ASC del algoritmo evaluador,
-- después de ordenDesempate dinámico; no se codifica una fórmula de normalización inexistente.


-- MR3-16: Solo nuevos registros usan catálogo actualmente elegible.
-- Desactivar PRODUCTO/PROVEEDOR no cancela operaciones iniciadas.
CREATE OR REPLACE FUNCTION "fn_mr3_validar_pedido_nuevo"() RETURNS trigger LANGUAGE plpgsql AS $mr3$
BEGIN
 IF NOT EXISTS (SELECT 1 FROM "CLIENTE" c WHERE c."idCliente"=NEW."idCliente" AND c."estado"='ACTIVO') THEN
  RAISE EXCEPTION 'Cliente no habilitado para pedido nuevo';
 END IF;
 RETURN NEW;
END;
$mr3$;
CREATE TRIGGER "tg_mr3_validar_pedido_nuevo" BEFORE INSERT ON "PEDIDO"
FOR EACH ROW EXECUTE FUNCTION "fn_mr3_validar_pedido_nuevo"();

CREATE OR REPLACE FUNCTION "fn_mr3_validar_producto_detalle_nuevo"() RETURNS trigger LANGUAGE plpgsql AS $mr3$
BEGIN
 IF NOT EXISTS (SELECT 1 FROM "PRODUCTO" p WHERE p."idProducto"=NEW."idProducto" AND p."activo") THEN
  RAISE EXCEPTION 'Producto no habilitado para pedido nuevo';
 END IF;
 RETURN NEW;
END;
$mr3$;
CREATE TRIGGER "tg_mr3_validar_producto_detalle_nuevo" BEFORE INSERT ON "DETALLE_PEDIDO"
FOR EACH ROW EXECUTE FUNCTION "fn_mr3_validar_producto_detalle_nuevo"();

CREATE OR REPLACE FUNCTION "fn_mr3_validar_invitacion_nueva"() RETURNS trigger LANGUAGE plpgsql AS $mr3$
BEGIN
 IF NOT EXISTS (
  SELECT 1 FROM "PROVEEDOR" p
  JOIN "USUARIO_PROVEEDOR" up ON up."idProveedor"=p."idProveedor"
  JOIN "USUARIO" u ON u."idUsuario"=up."idUsuario" AND u."estado"='HABILITADO'
  JOIN "USUARIO_ROL" ur ON ur."idUsuario"=u."idUsuario" AND ur."codigoRol"='PROVEEDOR'
  JOIN "PROVEEDOR_INSUMO" pi ON pi."idProveedor"=p."idProveedor"
  JOIN "EPISODIO_FALTANTE" e ON e."idInsumo"=pi."idInsumo"
  JOIN "SOLICITUD_COTIZACION" s ON s."idEpisodio"=e."idEpisodio"
  WHERE p."idProveedor"=NEW."idProveedor" AND p."estado"='ACTIVO'
    AND s."idSolicitud"=NEW."idSolicitud"
    AND pi."vigenteDesde"<=s."fechaHoraEmision"
    AND (pi."vigenteHasta" IS NULL OR pi."vigenteHasta">s."fechaHoraEmision")
 ) THEN RAISE EXCEPTION 'Proveedor inactivo o sin cuenta de portal habilitada'; END IF;
 RETURN NEW;
END;
$mr3$;
CREATE TRIGGER "tg_mr3_validar_invitacion_nueva" BEFORE INSERT ON "INVITACION_COTIZACION"
FOR EACH ROW EXECUTE FUNCTION "fn_mr3_validar_invitacion_nueva"();

CREATE OR REPLACE FUNCTION "fn_mr3_validar_orden_nueva"() RETURNS trigger LANGUAGE plpgsql AS $mr3$
BEGIN
 IF NOT EXISTS (
   SELECT 1 FROM "DECISION_COMPRA" d
   JOIN "RESPUESTA_COTIZACION" r ON r."idRespuesta"=d."idRespuestaSeleccionada"
   JOIN "PROVEEDOR" p ON p."idProveedor"=r."idProveedor"
   WHERE d."idDecisionCompra"=NEW."idDecisionCompra" AND d."resultado"='COMPRA'
     AND p."estado"='ACTIVO'
 ) THEN RAISE EXCEPTION 'No se puede emitir orden nueva a proveedor inactivo o sin decision de compra'; END IF;
 RETURN NEW;
END;
$mr3$;
CREATE TRIGGER "tg_mr3_validar_orden_nueva" BEFORE INSERT ON "ORDEN_COMPRA"
FOR EACH ROW EXECUTE FUNCTION "fn_mr3_validar_orden_nueva"();

-- MR3-17: Congelar contenido comercial de la solicitud. Estado/cierre sí evolucionan.
CREATE OR REPLACE FUNCTION "fn_mr3_proteger_solicitud_emitida"() RETURNS trigger LANGUAGE plpgsql AS $mr3$
BEGIN
 IF ROW(NEW."idEpisodio",NEW."cantidadSolicitada",NEW."fechaHoraEmision",NEW."fechaHoraVencimiento",NEW."modalidadInicio")
    IS DISTINCT FROM ROW(OLD."idEpisodio",OLD."cantidadSolicitada",OLD."fechaHoraEmision",OLD."fechaHoraVencimiento",OLD."modalidadInicio") THEN
   RAISE EXCEPTION 'Solicitud emitida inmutable: plazo y cantidades congelados';
 END IF;
 RETURN NEW;
END;
$mr3$;
CREATE TRIGGER "tg_mr3_proteger_solicitud_emitida" BEFORE UPDATE ON "SOLICITUD_COTIZACION"
FOR EACH ROW EXECUTE FUNCTION "fn_mr3_proteger_solicitud_emitida"();

-- MR3-18: Integridad de contraasiento evaluada al COMMIT cuando se completan ambas contrapartidas.
CREATE OR REPLACE FUNCTION "fn_mr3_verificar_contraasiento"() RETURNS trigger LANGUAGE plpgsql AS $mr3$
DECLARE v_cobro BIGINT; c record; v_cnt_caja INTEGER; v_cnt_cuenta INTEGER;
BEGIN
 IF TG_TABLE_NAME = 'COBRO' THEN
   IF NEW."estadoCobro" <> 'ANULADO' THEN RETURN NEW; END IF;
   v_cobro:=NEW."idCobro";
 ELSE
   v_cobro:=NEW."idCobroAnulado";
   IF v_cobro IS NULL THEN RETURN NEW; END IF;
 END IF;
 SELECT * INTO c FROM "COBRO" WHERE "idCobro"=v_cobro;
 IF NOT FOUND OR c."estadoCobro" <> 'ANULADO' THEN
   RAISE EXCEPTION 'Contraasiento sin cobro original ANULADO';
 END IF;
 SELECT count(*) INTO v_cnt_caja FROM "MOVIMIENTO_CAJA" mc
   WHERE mc."idCobroAnulado"=v_cobro AND mc."tipoMovimiento"='EGRESO'
     AND mc."importe"=c."importe" AND mc."origen"='ANULACION_COBRO';
 SELECT count(*) INTO v_cnt_cuenta FROM "ORIGEN_MOVIMIENTO_CUENTA" o
   JOIN "MOVIMIENTO_CUENTA" m ON m."idMovimientoCuenta"=o."idMovimientoCuenta"
   WHERE o."idCobroAnulado"=v_cobro AND m."idCliente"=c."idCliente"
     AND m."tipoMovimiento"='ANULACION_COBRO' AND m."importe"=c."importe";
 IF v_cnt_caja <> 1 OR v_cnt_cuenta <> 1 THEN
   RAISE EXCEPTION 'Contraasiento incompleto de cobro %: caja %, cuenta %',v_cobro,v_cnt_caja,v_cnt_cuenta;
 END IF;
 RETURN NEW;
END;
$mr3$;
CREATE CONSTRAINT TRIGGER "ct_mr3_cobro_anulado" AFTER INSERT OR UPDATE ON "COBRO"
DEFERRABLE INITIALLY DEFERRED FOR EACH ROW
EXECUTE FUNCTION "fn_mr3_verificar_contraasiento"();
CREATE CONSTRAINT TRIGGER "ct_mr3_caja_anulacion" AFTER INSERT OR UPDATE ON "MOVIMIENTO_CAJA"
DEFERRABLE INITIALLY DEFERRED FOR EACH ROW
EXECUTE FUNCTION "fn_mr3_verificar_contraasiento"();
CREATE CONSTRAINT TRIGGER "ct_mr3_origen_anulacion" AFTER INSERT OR UPDATE ON "ORIGEN_MOVIMIENTO_CUENTA"
DEFERRABLE INITIALLY DEFERRED FOR EACH ROW
EXECUTE FUNCTION "fn_mr3_verificar_contraasiento"();

-- MR3-19: Esta capa SQL no otorga a Repartidor permiso de UC-29. Registrar Cobro
-- online/offline exige permisos explícitos, instantáneas y deduplicación por clave de origen.

COMMIT;
