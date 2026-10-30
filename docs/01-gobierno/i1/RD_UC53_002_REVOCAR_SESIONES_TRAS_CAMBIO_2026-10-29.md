# RD-UC53-002 — Revocación total de sesiones después de cambiar contraseña

**Fecha de ratificación:** 29/10/2026 (mensaje del responsable 30/10/2026 01:10 UTC).  
**Estado funcional:** RATIFICADA. **Estado de propagación:** PATCH en revisión de PR.  
**Fuente previa:** RD-UC53-001 aprobada, contrato y DSS/DS REV-02. **Incidencia:** IC-UC53-MR5-002, [#30](https://github.com/leandrito369/ale-milanesas/issues/30).

## Decisión ratificada

Después de cada **cambio exitoso de contraseña** de UC-53, tanto desde una sesión restringida `cambioCredencialPendiente=true` como desde una sesión operativa `false`, el Sistema:

1. Sustituye `USUARIO.credencialProtegida` exclusivamente por el hash protegido de la nueva contraseña.
2. Establece `USUARIO.cambioCredencialPendiente=false` y **conserva sin cambios los Roles** existentes.
3. **Revoca todas las `SESION_USUARIO` activas/no revocadas del Usuario, incluida la sesión invocante**, mediante el trigger MR-5 `tg_mr5_revocar_sesiones_usuario` asociado al cambio de hash.
4. **Exige un nuevo inicio de sesión** para obtener una nueva sesión vigente y acceder a los permisos de los Roles conservados. El cambio de contraseña **no autoriza continuar utilizando la sesión anterior**, ni la reactiva, ni crea automáticamente una nueva sesión.

## Precedencia y compatibilidad

Esta RD **complementa RD-UC53-001**: no modifica su firma ni la condicionalidad de `credencialActual`. Reemplaza únicamente cualquier texto de postcondición o retorno que sugiera habilitar inmediatamente permisos **en la misma sesión** tras el cambio. Los A1/A2/A3 siguen preservando credencial e indicador si la operación fracasa; no se revocan sesiones por un intento rechazado, salvo que sean revocadas por otra operación independiente.

El contrato REV-02 UC53 y la etiqueta de retorno DS REV-02 se corrigen mediante PATCH controlado. DSS y DS se cotejan sin cambiar la semántica de credencial actual. **MR-5/MR-6/F01 y Flyway V1/V2 no cambian.** El corte G0 y RD-UC53-001 permanecen como historial.

## Criterios de prueba y aceptación

- Cambio restringido y voluntario exitosos → hash nuevo, indicador falso, Roles intactos, todas las sesiones anteriores revocadas.
- Misma sesión no autorizada para un nuevo cambio ni para buscar Usuarios/Clientes, según Rol; el nuevo ingreso será exigible cuando UC-01/B4 esté implementado.
- Error A1/A2/A3 → sin cambio de credencial ni revocación de sesiones por UC-53.
- No declarar probado el nuevo ingreso ni la aceptación E2E sin UC-01/B4; sí puede comprobarse el efecto PostgreSQL y el rechazo de sesión vieja en B3.
