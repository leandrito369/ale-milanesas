> **Estado:** propuesta revisada documentalmente, sin certificación académica final. Fuente: Gemini 28/10/2026; cotejo funcional con Word maestro (SHA d3fa32360e0b0b8184b1bb1a3eb9ce52bc0fea11) y RD posteriores. Métodos y tipos propuestos, no API implementada.

# Contrato REV-02 — Operación `iniciarSesion` (`UC-01`)

1. **Nombre:** `iniciarSesion(nombreUsuario: String, credencial: String)`

2. **Responsabilidades:** Autenticar la identidad de un Usuario registrado (personal interno o `PROVEEDOR`, excluyendo al `Cliente ONLINE`), verificar que su cuenta se encuentre en estado `HABILITADO` y posea al menos un `Rol` vigente, y establecer una sesión autenticada (restringida exclusivamente a ejecutar `UC-53` cuando `Usuario.cambioCredencialPendiente = true`).

3. **Tipo:** `Sistema`

4. **Referencias cruzadas:** Caso de Uso `UC-01 — Iniciar sesión`; Caso de Uso `UC-53 — Cambiar Contraseña`; Decisión `RD-RP010-001`; Objetivo `OBJE-03`; Requisito `RF-08`.

5. **Notas:** Conforme a `RD-RP010-001`, el bloqueo operativo cuando `Usuario.cambioCredencialPendiente = true` rige para **todo `Usuario`** (tanto interno como de Rol `PROVEEDOR`). El `Cliente ONLINE` no autentica mediante esta operación sino mediante desafíos temporales en `UC-21`.

6. **Excepciones:**

   * **A1 — Credenciales ausentes o inválidas:** Si `nombreUsuario` no existe o `credencial` no coincide con `Usuario.credencialProtegida`, rechazar la autenticación.

   * **A2 — Cuenta no habilitada:** Si `Usuario.estado` es `DESHABILITADO`, rechazar el acceso.

   * **A3 — Cuenta sin Roles vigentes por inconsistencia de datos:** Si la cuenta está `HABILITADO` pero no posee ninguna asociación en `UsuarioRol`, impedir el establecimiento de la sesión e informar que requiere regularización administrativa mediante `UC-18`.

   * **A4 — Fallo del servicio de autenticación:** No establecer sesión.

7. **Salida:**

   * En caso normal con `cambioCredencialPendiente = false`: acceso habilitado a las funciones autorizadas por sus `Rol` vigentes.

   * En caso normal con `cambioCredencialPendiente = true`: aviso de sesión restringida exclusivamente a ejecutar `UC-53 — Cambiar Contraseña`.

   * En caso excepcional: mensajes de rechazo provocados por las excepciones A1, A2, A3 o A4.

8. **Precondiciones:**

   * Existen definiciones de `Rol` y cuentas de `Usuario` registradas en el sistema.

9. **Postcondiciones:**

   * Se creó una instancia `unaSesion` de `SesionUsuario` con `fechaHoraInicio`, `fechaHoraExpiracion`, `tokenProtegido` y `fechaHoraRevocacion = NULL`.

   * Se asoció `unaSesion` con la instancia autenticada de `Usuario`.

   * Si `Usuario.cambioCredencialPendiente = true` (para cualquier `Usuario`, interno o `PROVEEDOR`), el permiso efectivo de `unaSesion` quedó restringido por validación del servidor de `Usuario.cambioCredencialPendiente`, exclusivamente a ejecutar la operación `cambiarContrasena` (`UC-53`); en caso contrario, quedó asociado a los permisos de sus `UsuarioRol` vigentes.

---

**Control de seguridad:** `SESION_USUARIO` no tiene una columna persistente `accesoRestringidoACambioClave`; el bloqueo se deriva del indicador en `USUARIO` y se impone también sobre la API. No inventar una columna.
