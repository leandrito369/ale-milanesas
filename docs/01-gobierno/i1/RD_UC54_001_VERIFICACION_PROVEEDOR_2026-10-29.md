# RD-UC54-001 — Verificación comercial y restablecimiento asistido

**Fecha:** 29/10/2026. **Estado:** APROBADA POR EL RESPONSABLE.  
**CU:** UC-54 `restablecerAccesoUsuario` con UC-56 incluido; contrato REV-02/6A.2 y DSS/DS REV02.

## Firma canónica
`restablecerAccesoUsuario(idUsuario: Long, identidadComercialVerificada: Boolean, credencialTemporal: String)`.

## Separación de responsabilidades
El **Administrador actor** localiza la cuenta con UC-56, coteja los datos comerciales disponibles del Proveedor y **confirma expresamente** en el paso 3 que verificó su identidad; no se impone un procedimiento externo nuevo. El **Sistema** exige esa confirmación y valida en las tablas `USUARIO_ROL`, `USUARIO_PROVEEDOR` y `PROVEEDOR` la exclusividad PROVEEDOR y su vínculo íntegro.

- **A1:** falta cuenta Proveedor identificable o `identidadComercialVerificada != true`: rechazar sin cambiar contraseña.
- **A2:** Rol no exclusivo PROVEEDOR, mezcla con Roles internos o vínculo inexistente/inconsistente (o riesgo de segunda cuenta habilitada para mismo Proveedor): rechazar.
- **A3:** cancelación o falla de persistencia: no confirmar cambios parciales.
- **Éxito:** sustituir hash por credencial temporal protegida; `cambioCredencialPendiente=true`; conservar id, estado, vínculos y Roles. La cuenta deshabilitada **no** se habilita automáticamente. Revocar sesiones vigentes cuando corresponda al restablecimiento, de manera consistente y transaccional, sin inventar un método externo de verificación.

**Seguridad:** el booleano de confirmación es una declaración de la acción administrativa, **no** prueba autónoma de identidad ni token; el acceso al comando continúa reservado al Administrador autenticado.
