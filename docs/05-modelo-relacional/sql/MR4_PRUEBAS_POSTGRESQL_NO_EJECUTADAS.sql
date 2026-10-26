-- Ale Milanesas MR-4. Ejecutar SOLO en DB descartable que comienza por ale_mr4_.
-- Requiere ejecutar antes el DDL del archivo MR3 consolidado en el esquema mr4_validacion.
-- Estas pruebas revierten INSERT/UPDATE hechos por la batería. No tocan las tablas originales.
\set ON_ERROR_STOP on
BEGIN;
SET LOCAL search_path TO mr4_validacion, public;
DO $mr4$
DECLARE v_tab INT; v_fk INT; v_col INT;
BEGIN
 IF current_database() NOT LIKE 'ale_mr4_%' THEN
   RAISE EXCEPTION 'PRUEBA BLOQUEADA: utilizar base descartable ale_mr4_*';
 END IF;
 SELECT count(*) INTO v_tab FROM information_schema.tables
   WHERE table_schema='mr4_validacion' AND table_type='BASE TABLE';
 SELECT count(*) INTO v_fk FROM pg_constraint c
   JOIN pg_namespace n ON n.oid=c.connamespace
   WHERE n.nspname='mr4_validacion' AND c.contype='f';
 SELECT count(*) INTO v_col FROM information_schema.columns
   WHERE table_schema='mr4_validacion';
 IF v_tab<>60 OR v_fk<>125 OR v_col<>453 THEN
   RAISE EXCEPTION 'MR4 catalogo incoherente: tablas %, FK %, columnas %',v_tab,v_fk,v_col;
 END IF;
 RAISE NOTICE '[PASS] Catalogo 60 tablas / 453 columnas / 125 FK';
END;
$mr4$;

DO $mr4$
DECLARE err TEXT;
BEGIN
 INSERT INTO "UNIDAD_MEDIDA" ("codigoUnidad","nombre") VALUES ('KG','Kilogramo');
 INSERT INTO "USUARIO" ("idUsuario","nombreUsuario","credencialProtegida","estado","cambioCredencialPendiente","fechaHoraAlta")
 VALUES(900001,'mr4.admin','hash-de-prueba-no-real','HABILITADO',false,now());
 INSERT INTO "ROL" ("codigoRol","nombreMostrado") VALUES ('ADMINISTRADOR','Administrador');
 INSERT INTO "USUARIO_ROL" ("idUsuario","codigoRol","fechaHoraAsignacion") VALUES(900001,'ADMINISTRADOR',now());
 INSERT INTO "INSUMO" ("idInsumo","nombre","codigoUnidadMedida","stockActual","umbralMinimo","nivelObjetivoReposicion","automatizacionCompraActiva","activo")
 VALUES(900001,'Harina MR4','KG',0,2,10,true,true);
 BEGIN
   INSERT INTO "INSUMO" ("idInsumo","nombre","codigoUnidadMedida","stockActual","umbralMinimo","nivelObjetivoReposicion","automatizacionCompraActiva","activo")
   VALUES(900002,'  hArIna  MR4 ','KG',0,2,10,true,true);
   RAISE EXCEPTION 'FAIL: Insumo duplicado fue aceptado';
 EXCEPTION WHEN unique_violation THEN
   RAISE NOTICE '[PASS] nombre INSUMO normalizado: duplicado rechazado';
 END;
 INSERT INTO "CLIENTE" ("idCliente","nombres","apellidos","telefonoPrincipal","estado","categoriaComercial","fechaHoraAlta")
 VALUES(900001,'Ana','Ríos','3755123400','ACTIVO','CUMPLIDOR',now());
 INSERT INTO "CLIENTE" ("idCliente","nombres","apellidos","telefonoPrincipal","estado","categoriaComercial","fechaHoraAlta")
 VALUES(900002,'Julio','Pérez','3755123400','ACTIVO','CUMPLIDOR',now());
 BEGIN
   INSERT INTO "CLIENTE" ("idCliente","nombres","apellidos","telefonoPrincipal","estado","categoriaComercial","fechaHoraAlta")
   VALUES(900003,' ANA ',' RÍOS ','3755-123400','ACTIVO','CUMPLIDOR',now());
   RAISE EXCEPTION 'FAIL: Cliente duplicado aceptado';
 EXCEPTION WHEN unique_violation THEN
   RAISE NOTICE '[PASS] Telefono compartido permitido y nombre+telefono duplicado rechazado';
 END;
 INSERT INTO "PROMOCION" ("idPromocion","descripcion","porcentajeDescuento","vigenteDesde","vigenteHasta","estado","fechaHoraCreacion","idUsuarioCreador","codigoAccesoOnline")
 VALUES(900001,'MR4 Promocion prueba',5,now(),now()+interval '1 day','BORRADOR',now(),900001,'00000000-0000-0000-0000-000000900001');
 UPDATE "PROMOCION" SET "estado"='ACTIVA' WHERE "idPromocion"=900001;
 BEGIN
   UPDATE "PROMOCION" SET "estado"='BORRADOR' WHERE "idPromocion"=900001;
   RAISE EXCEPTION 'FAIL: Transicion ACTIVA->BORRADOR permitida';
 EXCEPTION WHEN raise_exception THEN
   GET STACKED DIAGNOSTICS err=MESSAGE_TEXT;
   IF err LIKE 'FAIL:%' THEN RAISE; END IF;
   RAISE NOTICE '[PASS] PROMOCION no permite transicion inversa ACTIVA->BORRADOR';
 END;
 BEGIN
   UPDATE "PROMOCION" SET "estado"='INVENTADA' WHERE "idPromocion"=900001;
   RAISE EXCEPTION 'FAIL: estado inventado permitido';
 EXCEPTION WHEN check_violation THEN
   RAISE NOTICE '[PASS] Estado literal inválido PROMOCION rechazado';
 END;
 IF EXISTS (SELECT 1 FROM "CONFIGURACION_OPERATIVA" WHERE "clave"='PLAZO_RESPUESTA_COTIZACION_HORAS') THEN
   RAISE EXCEPTION 'FAIL: se precargó plazo operativo (se esperaba sin seed)';
 END IF;
 INSERT INTO "CONFIGURACION_OPERATIVA" ("clave","valorEntero","fechaHoraModificacion","idUsuarioAdministrador")
 VALUES ('PLAZO_RESPUESTA_COTIZACION_HORAS',24,now(),900001);
 BEGIN
    UPDATE "CONFIGURACION_OPERATIVA" SET "valorEntero"=0 WHERE "clave"='PLAZO_RESPUESTA_COTIZACION_HORAS';
    RAISE EXCEPTION 'FAIL: plazo no positivo aceptado';
 EXCEPTION WHEN check_violation THEN
    RAISE NOTICE '[PASS] plazo operativo debe ser positivo (24h es solo dato de prueba)';
 END;
 RAISE NOTICE '[PASS] Datos mínimos, UNIQUE, seguridad base, promoción, parámetro';
END;
$mr4$;

-- Costo y apertura, validar registro físico único. Se usa fecha fija para FK compuesta.
DO $mr4$
DECLARE t TIMESTAMPTZ := '2026-10-25 12:00:00+00';
BEGIN
 INSERT INTO "COSTO_INSUMO_HISTORICO" ("idInsumo","vigenteDesde","costoUnitario","fuenteCosto")
 VALUES (900001,t,100,'SALDO_INICIAL');
 INSERT INTO "MOVIMIENTO_INSUMO" ("idMovimientoInsumo","idInsumo","numeroSecuenciaInsumo","vigenteDesdeCosto", "idUsuarioResponsable", "tipoMovimiento", "cantidad", "fechaHora", "stockResultante", "origen")
 VALUES (900001,900001,1,t,900001,'SALDO_INICIAL',3,now(),3,'APERTURA_INVENTARIO');
 BEGIN
  INSERT INTO "MOVIMIENTO_INSUMO" ("idMovimientoInsumo","idInsumo","numeroSecuenciaInsumo","vigenteDesdeCosto", "idUsuarioResponsable", "tipoMovimiento", "cantidad", "fechaHora", "stockResultante", "origen")
  VALUES (900002,900001,2,t,900001,'SALDO_INICIAL',3,now(),6,'APERTURA_INVENTARIO');
  RAISE EXCEPTION 'FAIL: segunda apertura SALDO_INICIAL permitida';
 EXCEPTION WHEN unique_violation THEN
  RAISE NOTICE '[PASS] una sola apertura SALDO_INICIAL por insumo';
 END;
END;
$mr4$;

-- Vigencias [desde,hasta): los extremos contiguos son válidos; los solapes se rechazan.
DO $mr4$
DECLARE t TIMESTAMPTZ := '2027-01-01 00:00:00+00';
BEGIN
 INSERT INTO "POLITICA_COMPRA" ("idPoliticaCompra","numeroVersion","vigenteDesde","vigenteHasta","periodoCalculoDias","fechaHoraRegistro","idUsuarioRegistro")
 VALUES(900001,1,t,t+interval '1 day',30,now(),900001);
 BEGIN
   INSERT INTO "POLITICA_COMPRA" ("idPoliticaCompra","numeroVersion","vigenteDesde","vigenteHasta","periodoCalculoDias","fechaHoraRegistro","idUsuarioRegistro")
   VALUES(900002,2,t+interval '12 hours',t+interval '2 days',30,now(),900001);
   RAISE EXCEPTION 'FAIL: dos politicas de compra solapadas aceptadas';
 EXCEPTION WHEN exclusion_violation THEN
   RAISE NOTICE '[PASS] Politicas de compra solapadas rechazadas';
 END;
 INSERT INTO "POLITICA_COMPRA" ("idPoliticaCompra","numeroVersion","vigenteDesde","vigenteHasta","periodoCalculoDias","fechaHoraRegistro","idUsuarioRegistro")
 VALUES(900003,3,t+interval '1 day',t+interval '2 days',30,now(),900001);
 INSERT INTO "PRODUCTO" ("idProducto","nombre","nombreNormalizado","tipoProducto","codigoUnidadVenta","activo")
 VALUES(900001,'Producto MR4','producto mr4','ELABORADO','KG',true);
 INSERT INTO "PRECIO_PRODUCTO" ("idPrecio","idProducto","precioBase","vigenteDesde","vigenteHasta","fechaHoraRegistro","idUsuarioRegistro")
 VALUES(900001,900001,200,t,t+interval '1 day',now(),900001);
 BEGIN
   INSERT INTO "PRECIO_PRODUCTO" ("idPrecio","idProducto","precioBase","vigenteDesde","vigenteHasta","fechaHoraRegistro","idUsuarioRegistro")
   VALUES(900002,900001,225,t+interval '12 hours',t+interval '2 days',now(),900001);
   RAISE EXCEPTION 'FAIL: precios solapados aceptados';
 EXCEPTION WHEN exclusion_violation THEN
   RAISE NOTICE '[PASS] Precios solapados del mismo Producto rechazados';
 END;
 INSERT INTO "PRECIO_PRODUCTO" ("idPrecio","idProducto","precioBase","vigenteDesde","vigenteHasta","fechaHoraRegistro","idUsuarioRegistro")
 VALUES(900003,900001,225,t+interval '1 day',t+interval '2 days',now(),900001);
 RAISE NOTICE '[PASS] Intervalos temporales [desde,hasta) contiguos admitidos';
END;
$mr4$;

ROLLBACK;
\echo 'MR-4: las pruebas de base se revirtieron (ROLLBACK). Esta salida NO valida concurrencia, PRA-01 ni reembolsos.'
