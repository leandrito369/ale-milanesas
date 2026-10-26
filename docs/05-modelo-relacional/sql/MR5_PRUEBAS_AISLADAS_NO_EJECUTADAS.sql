-- MR5: batería funcional exploratoria; requiere DDL MR-3 + parche MR-5
-- instalados en esquema 'mr5_validacion' de base NUEVA y DESCARTABLE ale_mr5_*.
-- Todas las operaciones de prueba terminan con ROLLBACK.
\set ON_ERROR_STOP on
BEGIN;
SET LOCAL search_path TO mr5_validacion, public;
DO $test$
DECLARE v_tab INTEGER; v_names TEXT; v_err TEXT;
BEGIN
 IF current_database() NOT LIKE 'ale_mr5_%' THEN
   RAISE EXCEPTION 'BLOQUEADO: base debe comenzar con ale_mr5_';
 END IF;
 SELECT count(*) INTO v_tab FROM information_schema.tables
  WHERE table_schema='mr5_validacion' AND table_type='BASE TABLE';
 IF v_tab<>60 THEN RAISE EXCEPTION 'Se esperaban 60 tablas: %',v_tab; END IF;
 RAISE NOTICE '[CATALOGO] 60 tablas visibles';
 INSERT INTO "UNIDAD_MEDIDA"("codigoUnidad","nombre") VALUES('KGT','Kilogramo prueba MR5');
 INSERT INTO "USUARIO"("idUsuario","nombreUsuario","credencialProtegida","estado","cambioCredencialPendiente","fechaHoraAlta")
 VALUES(891001,'mr5.admin','hash-no-real','HABILITADO',FALSE,now());
 INSERT INTO "ROL"("codigoRol","nombreMostrado") VALUES('ADMINISTRADOR','Administrador');
 INSERT INTO "USUARIO_ROL"("idUsuario","codigoRol","fechaHoraAsignacion") VALUES(891001,'ADMINISTRADOR',now());
 INSERT INTO "INSUMO"("idInsumo","nombre","codigoUnidadMedida","stockActual","umbralMinimo","nivelObjetivoReposicion","automatizacionCompraActiva","activo")
 VALUES(891001,'Insumo prueba MR5','KGT',0,8,15,TRUE,TRUE);
 INSERT INTO "COSTO_INSUMO_HISTORICO"("idInsumo","vigenteDesde","costoUnitario","fuenteCosto")
 VALUES(891001,now(),10,'OTRO');
 BEGIN
   INSERT INTO "MOVIMIENTO_INSUMO"("idMovimientoInsumo","idInsumo","numeroSecuenciaInsumo","vigenteDesdeCosto","idUsuarioResponsable","tipoMovimiento","cantidad","fechaHora","stockResultante","origen")
   VALUES(891001,891001,1,now(),891001,'SALDO_INICIAL',5,now(),5,'APERTURA_INVENTARIO');
   RAISE EXCEPTION 'FAIL_F03: aceptó apertura con costo ajeno';
 EXCEPTION WHEN raise_exception THEN
   GET STACKED DIAGNOSTICS v_err=MESSAGE_TEXT;
   IF v_err LIKE 'FAIL_%' THEN RAISE; END IF;
   RAISE NOTICE '[F03] rechazo de costo incompatible: %',v_err;
 END;
 INSERT INTO "COSTO_INSUMO_HISTORICO"("idInsumo","vigenteDesde","costoUnitario","fuenteCosto")
 VALUES(891001,now()+interval '1 second',10,'SALDO_INICIAL');
 INSERT INTO "MOVIMIENTO_INSUMO"("idMovimientoInsumo","idInsumo","numeroSecuenciaInsumo","vigenteDesdeCosto","idUsuarioResponsable","tipoMovimiento","cantidad","fechaHora","stockResultante","origen")
 VALUES(891001,891001,1,now()+interval '1 second',891001,'SALDO_INICIAL',5,now(),5,'APERTURA_INVENTARIO');
 UPDATE "INSUMO" SET "stockActual"=5 WHERE "idInsumo"=891001;
 BEGIN
   DELETE FROM "MOVIMIENTO_INSUMO" WHERE "idMovimientoInsumo"=891001;
   RAISE EXCEPTION 'FAIL_F03: permitió borrar movimiento inicial';
 EXCEPTION WHEN raise_exception THEN
   GET STACKED DIAGNOSTICS v_err=MESSAGE_TEXT;
   IF v_err LIKE 'FAIL_%' THEN RAISE; END IF;
   RAISE NOTICE '[F03] historial inmutable: %',v_err;
 END;
 INSERT INTO "MOVIMIENTO_CAJA"("idMovimientoCaja","tipoMovimiento","importe","fechaHoraMovimiento","origen")
 VALUES(891001,'INGRESO',10,now(),'MANUAL');
 BEGIN
   UPDATE "MOVIMIENTO_CAJA" SET "importe"=11 WHERE "idMovimientoCaja"=891001;
   RAISE EXCEPTION 'FAIL_F02: permitió reescribir asiento';
 EXCEPTION WHEN raise_exception THEN
   GET STACKED DIAGNOSTICS v_err=MESSAGE_TEXT;
   IF v_err LIKE 'FAIL_%' THEN RAISE; END IF;
   RAISE NOTICE '[F02] asiento inmutable: %',v_err;
 END;
 INSERT INTO "PROMOCION"("idPromocion","descripcion","porcentajeDescuento","vigenteDesde","vigenteHasta","estado","fechaHoraCreacion","idUsuarioCreador","codigoAccesoOnline")
 VALUES(891001,'Prueba MR5',5,now(),now()+interval '1 day','BORRADOR',now(),891001,'00000000-0000-0000-0000-000000891001');
 UPDATE "PROMOCION" SET "estado"='ACTIVA' WHERE "idPromocion"=891001;
 UPDATE "PROMOCION" SET "estado"='PAUSADA' WHERE "idPromocion"=891001;
 BEGIN
   UPDATE "PROMOCION" SET "estado"='ACTIVA' WHERE "idPromocion"=891001;
   RAISE EXCEPTION 'FAIL_F08: permitió reactivación sin CU';
 EXCEPTION WHEN raise_exception THEN
   GET STACKED DIAGNOSTICS v_err=MESSAGE_TEXT;
   IF v_err LIKE 'FAIL_%' THEN RAISE; END IF;
   RAISE NOTICE '[F08] reactivación no autorizada: %',v_err;
 END;
 BEGIN
   DELETE FROM "USUARIO_ROL" WHERE "idUsuario"=891001 AND "codigoRol"='ADMINISTRADOR';
   SET CONSTRAINTS ALL IMMEDIATE;
   RAISE EXCEPTION 'FAIL_F07: último Administrador no fue protegido';
 EXCEPTION WHEN raise_exception THEN
   GET STACKED DIAGNOSTICS v_err=MESSAGE_TEXT;
   IF v_err LIKE 'FAIL_%' THEN RAISE; END IF;
   RAISE NOTICE '[F07] último Administrador protegido: %',v_err;
 END;
 INSERT INTO "CLIENTE"("idCliente","nombres","telefonoPrincipal","estado","categoriaComercial","fechaHoraAlta")
 VALUES(891001,'Cliente MR5','3755111222','ACTIVO','CUMPLIDOR',now());
 INSERT INTO "COBRO"("idCobro","idCliente","fechaHoraCobro","importe","medioPago","origen","estadoCobro")
 VALUES(891001,891001,now(),100,'EFECTIVO','ADMINISTRACION','ESTADO_PARA_PRUEBA');
 INSERT INTO "REEMBOLSO"("idReembolso","idCobro","importeReembolso","fechaHoraCreacion","motivo","estado")
 VALUES(891001,891001,100,now(),'Prueba MR5','PENDIENTE');
 BEGIN
   UPDATE "REEMBOLSO" SET "estado"='PROCESADO',"fechaHoraProcesamiento"=now() WHERE "idReembolso"=891001;
   SET CONSTRAINTS ALL IMMEDIATE;
   RAISE EXCEPTION 'FAIL_F06: PROCESADO sin Caja/Cuenta';
 EXCEPTION WHEN raise_exception THEN
   GET STACKED DIAGNOSTICS v_err=MESSAGE_TEXT;
   IF v_err LIKE 'FAIL_%' THEN RAISE; END IF;
   RAISE NOTICE '[F06] PROCESADO incompleto rechazado: %',v_err;
 END;
 RAISE NOTICE '[MR5] Tests de rechazo concluidos; todo se revierte';
END;
$test$;
ROLLBACK;
