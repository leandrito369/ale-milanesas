> **Estado:** propuesta revisada documentalmente, sin certificación académica final. Fuente: Gemini 28/10/2026; cotejo funcional con Word maestro (SHA d3fa32360e0b0b8184b1bb1a3eb9ce52bc0fea11) y RD posteriores. Métodos y tipos propuestos, no API implementada.

# Contrato REV-02 — Operación `restablecerAccesoUsuario` (`UC-54` «include» `UC-56`)

1. **Nombre:** `restablecerAccesoUsuario(idUsuario: Long, credencialTemporal: String)`

2. **Responsabilidades:** Restablecer de manera asistida el acceso de una cuenta de `Usuario` con Rol exclusivo `PROVEEDOR` (previamente localizada mediante `UC-56`), sustituyendo su credencial protegida por una credencial temporal y activando `cambioCredencialPendiente = true` sin modificar su estado de habilitación ni crear una segunda cuenta.

3. **Tipo:** `Sistema`

4. **Referencias cruzadas:** Caso de Uso `UC-54 — Restablecer Acceso de Usuario`; incluye `UC-56 — Buscar Usuario` **(relación aprobada el 25/10/2026)**; Caso de Uso `UC-53 — Cambiar Contraseña`; Objetivo `OBJE-03`; Requisito `RF-08`.

5. **Notas:** La comprobación del Rol y de `UsuarioProveedor` **no sustituye la verificación de identidad comercial** que exige UC-54 Real. Esa verificación debe quedar documentada antes de confirmar el restablecimiento; su procedimiento preciso no se inventa aquí.  Alcance inicial exclusivo para cuentas con Rol `PROVEEDOR`. No habilita automáticamente una cuenta `DESHABILITADO` (lo cual corresponde a `UC-55`) ni crea un `Usuario` nuevo.

6. **Excepciones:**

   * **A1 — No existe la cuenta o no se acredita la identidad del Proveedor comercial:** No restablecer el acceso.

   * **A2 — La cuenta no pertenece al Rol exclusivo `PROVEEDOR` o su vínculo en `UsuarioProveedor` es inconsistente:** Rechazar la operación.

   * **A3 — Credencial temporal inválida o falla de actualización:** Conservar la credencial y condición anteriores.

7. **Salida:**

   * Confirmación del restablecimiento asistido e indicación de que el Proveedor deberá ejecutar `UC-53` antes de responder Solicitudes de Cotización; o mensajes de las excepciones A1–A3.

8. **Precondiciones:**

   * El `Administrador` se encuentra autenticado y autorizado.

   * El Administrador verificó la identidad comercial del Proveedor de acuerdo con UC-54 Real.

   * La cuenta objetivo fue localizada mediante `UC-56` y corresponde a un `Usuario` con Rol exclusivo `PROVEEDOR` vinculado a un `Proveedor` identificable en `UsuarioProveedor`.

9. **Postcondiciones:**

   * Se modificó el atributo `Usuario.credencialProtegida` sustituyéndolo por el valor protegido de `credencialTemporal`.

   * Se modificó el atributo `Usuario.cambioCredencialPendiente` a `true`.

   * Se conservaron inalterados `Usuario.idUsuario`, `Usuario.estado` (`HABILITADO` o `DESHABILITADO`), sus asociaciones en `UsuarioRol` y su vínculo en `UsuarioProveedor`.

---

**Seguridad:** antes de sustituir credenciales se debe cotejar la verificación de identidad comercial indicada en UC-54 Real. Ningún valor protegido se incluye en resultados visibles ni en registros de auditoría.
