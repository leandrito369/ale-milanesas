> **Estado:** propuesta revisada documentalmente, sin certificación académica final. Fuente: Gemini 28/10/2026; cotejo funcional con Word maestro (SHA d3fa32360e0b0b8184b1bb1a3eb9ce52bc0fea11) y RD posteriores. Métodos y tipos propuestos, no API implementada.

# Contrato REV-02 — Operación `gestionarAsignacionesRoles` (`UC-18`)

1. **Nombre:** `gestionarAsignacionesRoles(idUsuario: Long, codigosRolAgregar: Set<String>, codigosRolQuitar: Set<String>)`

2. **Responsabilidades:** Actualizar el conjunto de `Rol` asignados a un `Usuario` preservando que la cuenta mantenga al menos un `Rol` vigente, que el sistema conserve al menos un `ADMINISTRADOR` en estado `HABILITADO` y que no se vulnere la exclusividad del Rol `PROVEEDOR`.

3. **Tipo:** `Sistema`

4. **Referencias cruzadas:** Caso de Uso `UC-18 — Gestionar Asignaciones de Roles`; incluido por `UC-17 — Crear Usuario`; Pendiente `F07`; Objetivo `OBJE-03`; Requisito `RF-08`.

5. **Notas:** Cuando se retiran permisos activos a un `Usuario`, se revocan sus sesiones vigentes para evitar que continúe operando con autorizaciones revocadas.

6. **Excepciones:**

   * **A1 — `Usuario` inexistente o conjuntos de cambios vacíos/inválidos:** Rechazar la operación.

   * **A2 — El resultado dejaría al `Usuario` sin ningún `Rol` (`rolesResultantes.isEmpty()`):** Rechazar la modificación y conservar los Roles previos.

   * **A3 — El cambio quitaría el Rol `ADMINISTRADOR` al último Administrador en estado `HABILITADO`:** Rechazar la modificación.

   * **A4 — Intento de mezclar el Rol exclusivo `PROVEEDOR` con roles internos:** Rechazar la modificación.

7. **Salida:**

   * Nueva lista de `Rol` vigentes del `Usuario`, o mensajes de rechazo provocados por las excepciones A1–A4.

8. **Precondiciones:**

   * El `Administrador` se encuentra autenticado y autorizado, y existe el `Usuario` identificado por `idUsuario`.

9. **Postcondiciones:**

   * Para cada Rol en `codigosRolAgregar`, se creó una instancia de `UsuarioRol` y una instancia de `EventoAsignacionRol` (`tipoEvento = ALTA`) asociadas al `Usuario`, al `Rol` y al `Administrador`.

   * Para cada Rol en `codigosRolQuitar`, se eliminó la instancia correspondiente de `UsuarioRol` y se creó una instancia de `EventoAsignacionRol` (`tipoEvento = BAJA`) asociada al `Usuario`, al `Rol` y al `Administrador`.

   * Si `codigosRolQuitar` no fue vacío, se modificó `SesionUsuario.fechaHoraRevocacion` en las sesiones activas del `Usuario` afectado.

---

**Reserva F07:** la atomicidad de último administrador, al menos un rol y revocación de sesiones se establece como comportamiento requerido, no como transacción o prueba de concurrencia ya ejecutada. Cada evento `EventoAsignacionRol` es un objeto distinto; las sesiones no comparten su línea de vida.
