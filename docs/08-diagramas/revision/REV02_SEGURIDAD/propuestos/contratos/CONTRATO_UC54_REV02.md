> **Estado:** PATCH funcional aprobado por RD-UC17/18/53/54 (según CU) el 29/10/2026; sin certificación académica final. Fuente: Gemini 28/10/2026; cotejo funcional con Word maestro (SHA d3fa32360e0b0b8184b1bb1a3eb9ce52bc0fea11) y RD posteriores. Métodos y tipos propuestos, no API implementada.

# Contrato REV-02 — Operación `restablecerAccesoUsuario` (`UC-54` «include» `UC-56`)

1. **Nombre:** `restablecerAccesoUsuario(idUsuario: Long, identidadComercialVerificada: Boolean, credencialTemporal: String)`; `UC-54` incluye búsqueda previa `UC-56`.

2. **Responsabilidades:** Administrador identifica cuenta Proveedor mediante UC-56, verifica personalmente su identidad comercial y confirma expresamente la comprobación; Sistema revalida exclusivamente Rol PROVEEDOR, vínculo `USUARIO_PROVEEDOR` íntegro y condición comercial. Solo entonces sustituye hash por credencial temporal y fuerza cambio pendiente, sin habilitar cuenta deshabilitada.

3. **Tipo:** `Sistema`

4. **Referencias cruzadas:** UC-54, UC-56 include, UC-53, RD-UC54-001, RF-08, OBJE-03 y pasos 2-6 de ficha Real/Extendida Fase4.

5. **Notas:** `identidadComercialVerificada=true` representa confirmación del actor, no prueba automática externa; el Sistema debe validar vínculo de Proveedor, no inventar procedimientos documentales externos. Mantener cuenta, Rol, estado y vínculo; revocar sesiones previas cuando corresponda.

6. **Excepciones:** A1 — Cuenta Proveedor no identificable o identidad comercial no acreditada/confirmada (`identidadComercialVerificada != true`): rechazar sin cambios. A2 — Cuenta sin Rol exclusivo PROVEEDOR, mezcla con roles internos o vínculo `USUARIO_PROVEEDOR` ausente/inconsistente (o creación de segunda cuenta habilitada para el Proveedor): rechazar. A3 — Cancelación del Administrador o fallo de registro: conservar hash e indicador anteriores.

7. **Salida:** confirmación de restablecimiento y obligación de UC-53 para la credencial temporal, sin habilitar cuenta deshabilitada; o rechazo A1-A3. Sin exponer secretos.

8. **Precondiciones:** Administrador autenticado y autorizado; cuenta de USUARIO localizada con UC-56 y vinculada exclusivamente al Rol PROVEEDOR y un Proveedor comercial identificable. El actor verifica/ratifica identidad antes de ejecutar el cambio.

9. **Postcondiciones:** Se sustituyó `USUARIO.credencialProtegida` por hash de `credencialTemporal` y se fijó `cambioCredencialPendiente=true`; se conservaron `idUsuario`, `estado`, `USUARIO_ROL` y `USUARIO_PROVEEDOR`. Sesiones previas revocadas cuando corresponde al restablecimiento y de manera transaccional. No activar automáticamente cuentas DESHABILITADO, ni producir una segunda cuenta.

---

**PATCH controlado vigente (RD-UC54-001) — 29/10/2026:** prevalecen las reglas de los apartados 1–9 corregidos sobre la propuesta histórica (incluidas sus reservas ya resueltas). Los valores SQL físicos de MR5 permanecen intactos. Historial anterior preservado en Git; antes de implementar validar DSS/DS y pruebas de concurrencia.
