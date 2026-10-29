# RD-UC18-001 — Gestión de Roles, invariantes y evento canónico

**Fecha:** 29/10/2026. **Estado:** APROBADA POR EL RESPONSABLE.  
**CU:** UC-18 `gestionarAsignacionesRoles` incluido por UC-17. **IC:** `IC-UC18-MR5-001`.

## Firma y alcance
`gestionarAsignacionesRoles(idUsuario: Long, rolesAgregar: Set<String>[0..1], rolesQuitar: Set<String>[0..1])`, o representación por conjunto objetivo de Roles que resulte **funcionalmente equivalente**. El conjunto resultante debe conservar al menos un Rol del Usuario, al menos un `ADMINISTRADOR` habilitado en todo el sistema y exclusividad de `PROVEEDOR`. No se crean ni eliminan filas del catálogo `ROL`.

## Alternativas aprobadas
- **A1, retiro válido:** quitar asociaciones seleccionadas preservando invariantes; emitir `REVOCACION` por cada Rol retirado.
- **A2:** rechazar retiro del último Rol del Usuario o del último Administrador habilitado (F07).
- **A3:** Rol ya asociado al agregar o ausente al retirar: no crear duplicado ni evento ficticio.
- **A4:** cancelación/falla: transacción completa revertida.
- **A5:** operación no autorizada: rechazar.

## Postcondiciones
Cada Rol agregado crea un `USUARIO_ROL` y un `EVENTO_ASIGNACION_ROL` `tipoEvento='ASIGNACION'`; cada Rol retirado elimina su asociación y crea un evento `tipoEvento='REVOCACION'`. Si se revocan permisos activos, revocar `SESION_USUARIO` vigentes del Usuario afectado. `idUsuarioAdministrador` registra el actor autorizado, jamás se infiere autorización por jerarquía de Roles. Revalidación atómica de F07 y concurrencia obligatoria en pruebas; **no** modificar MR5.
