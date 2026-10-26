-- MR-6 pruebas focalizadas que no están cubiertas integralmente por MR-5.
-- SOLO base descartable; transacción revertida.
\set ON_ERROR_STOP on
BEGIN;
SET LOCAL search_path TO mr5_validacion,public;
DO $mr6$
DECLARE v_error TEXT;
BEGIN
 IF current_database() <> 'ale_mr5_ci' THEN
   RAISE EXCEPTION 'BLOQUEO MR-6: esta prueba solo admite ale_mr5_ci';
 END IF;
 INSERT INTO "ROL" ("codigoRol","nombreMostrado") VALUES
 ('ADMINISTRADOR','Administrador'),('VENDEDOR','Vendedor');
 INSERT INTO "USUARIO" ("idUsuario","nombreUsuario","credencialProtegida","estado","cambioCredencialPendiente","fechaHoraAlta")
 VALUES (991001,'mr6.admin','hash-ficticio','HABILITADO',false,now());
 INSERT INTO "USUARIO_ROL" ("idUsuario","codigoRol","fechaHoraAsignacion") VALUES
 (991001,'ADMINISTRADOR',now()),(991001,'VENDEDOR',now());

 -- Queda Rol VENDEDOR: solo puede fallar por perder el último ADMINISTRADOR habilitado.
 BEGIN
   DELETE FROM "USUARIO_ROL" WHERE "idUsuario"=991001 AND "codigoRol"='ADMINISTRADOR';
   SET CONSTRAINTS ALL IMMEDIATE;
   RAISE EXCEPTION 'FAIL_MR6: se revocó el último ADMINISTRADOR';
 EXCEPTION WHEN raise_exception THEN
   GET STACKED DIAGNOSTICS v_error=MESSAGE_TEXT;
   IF v_error LIKE 'FAIL_MR6:%' THEN RAISE; END IF;
   IF v_error NOT LIKE '%Administrador habilitado%' THEN
     RAISE EXCEPTION 'MR6: error distinto al esperado: %',v_error;
   END IF;
   RAISE NOTICE '[PASS] F07 último ADMINISTRADOR protegido aun con otro Rol';
 END;

 INSERT INTO "SESION_USUARIO" ("idSesionUsuario","idUsuario","tokenProtegido",
   "fechaHoraInicio","fechaHoraExpiracion")
 VALUES ('00000000-0000-0000-0000-000000991001',991001,decode('991001','hex'),
   now(),now()+interval '2 hours');
 UPDATE "USUARIO" SET "credencialProtegida"='hash-ficticio-renovado'
 WHERE "idUsuario"=991001;
 IF NOT EXISTS (
   SELECT 1 FROM "SESION_USUARIO"
   WHERE "idUsuario"=991001 AND "fechaHoraRevocacion" IS NOT NULL
 ) THEN
   RAISE EXCEPTION 'FAIL_MR6: cambio de credencial no revocó sesión';
 END IF;
 RAISE NOTICE '[PASS] F07 cambio de credencial revoca sesión activa';
END;
$mr6$;
ROLLBACK;
\echo '[MR6] Prueba focalizada de seguridad revertida (ROLLBACK)'
