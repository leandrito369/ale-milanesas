# RD-RP010-001 — Cambio obligatorio de contraseña inicial

**Fecha:** 27/10/2026. **Estado funcional:** APROBADA por el responsable del proyecto. **Implementación y pruebas:** pendientes.

## Reglas aprobadas

1. Cuando un Usuario tiene `cambioCredencialPendiente = true`, **puede autenticarse**, pero **no acceder a funciones operativas** del sistema.
2. El sistema lo dirige obligatoriamente a **UC-53 Cambiar Contraseña**.
3. Después de establecer correctamente la nueva contraseña se **elimina la condición de cambio pendiente** y el Usuario puede acceder a las funciones permitidas por sus Roles.
4. No se crea automáticamente una nueva relación UML `«include»` ni `«extend»` entre **UC-01** y **UC-53**. Primero se representa el comportamiento en precondiciones/flujos de los CU vigentes y se verifica la necesidad metodológica de una relación.

## Coherencia y límites

- El indicador pendiente **no concede permisos adicionales**: la autorización habitual por Rol sigue vigente.
- El bloqueo operativo debe aplicarse en el **servidor/API**, no solo mediante redirección de interfaz.
- Las reglas de sesión, revocación y seguridad de contraseñas de S-04/F07 continúan vigentes; ningún dato de credencial se registra en texto claro.
- La ratificación no modifica las 64 fichas directamente, el diagrama rechazado, el esquema SQL ni las relaciones UML aprobadas.

## Aceptación futura

Credencial pendiente: autenticación identificada, funciones operativas denegadas y acceso habilitado únicamente al flujo de cambio necesario. Cambio exitoso: indicador limpiado y acceso conforme a roles. Intento de saltar UC-53 mediante API: rechazado.

**Trazabilidad:** RP-010; UC-01, UC-53; F07/S-04; RD-006 mínimo privilegio.

**Estado RP-010:** decisión funcional cerrada; propagación documental y verificación de servicio pendientes.
