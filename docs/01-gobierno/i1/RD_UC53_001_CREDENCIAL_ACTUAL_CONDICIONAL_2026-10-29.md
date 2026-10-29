# RD-UC53-001 — Condicionalidad de credencial actual

**Fecha:** 29/10/2026. **Estado:** APROBADA POR EL RESPONSABLE.  
**CU:** UC-53 `cambiarContrasena`; contrato REV-02/1.2, DSS/DS REV02, RD-RP010-001.

## Firma canónica
`cambiarContrasena(nuevaCredencial: String, confirmacionNuevaCredencial: String, credencialActual: String[0..1])`.

## Condiciones
- `cambioCredencialPendiente=true`: una sesión autenticada, vigente y restringida a UC-53 permite la sustitución **sin exigir `credencialActual`** (ficha Real paso 3). Rechazar reutilización de la clave temporal anterior.
- `cambioCredencialPendiente=false`: el cambio voluntario exige `credencialActual` presente y verificada contra `credencialProtegida` (ficha Extendida pasos 2-3 y A2).
- En ambos casos: Usuario `HABILITADO`, sesión válida, nueva credencial permitida y confirmación coherente. Ante A1 sesión inválida/cuenta no habilitada, A2 credencial o confirmación inválidas, A3 cancelación/falla: **no modificar** hash ni indicador.
- Tras éxito: guardar solo hash seguro de la nueva contraseña, actualizar `cambioCredencialPendiente=false`, conservando los Roles existentes; no se añade ninguna columna o tabla.
- `RD-RP010-001` sigue rigiendo acceso restringido para cualquier Usuario con el indicador verdadero; Cliente ONLINE no se convierte en Usuario interno.
