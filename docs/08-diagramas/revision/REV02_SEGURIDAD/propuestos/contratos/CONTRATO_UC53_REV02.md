> **Estado:** propuesta revisada documentalmente, sin certificación académica final. Fuente: Gemini 28/10/2026; cotejo funcional con Word maestro (SHA d3fa32360e0b0b8184b1bb1a3eb9ce52bc0fea11) y RD posteriores. Métodos y tipos propuestos, no API implementada.

# Contrato REV-02 — Operación `cambiarContrasena` (`UC-53`)

1. **Nombre:** `cambiarContrasena(credencialActual: String, credencialNueva: String, confirmacion: String)`

2. **Responsabilidades:** Sustituir la credencial protegida del `Usuario` autenticado (interno o `PROVEEDOR`) por una nueva credencial válida y establecer `Usuario.cambioCredencialPendiente = false`, liberando la restricción inicial o de restablecimiento sobre su sesión.

3. **Tipo:** `Sistema`

4. **Referencias cruzadas:** Caso de Uso `UC-53 — Cambiar Contraseña`; Caso de Uso `UC-01 — Iniciar sesión`; Caso de Uso `UC-54 — Restablecer Acceso de Usuario`; Decisión `RD-RP010-001`; Objetivo `OBJE-03`; Requisitos `RF-08`, `RNF-02`.

5. **Notas:** Aplica a cualquier `Usuario` autenticado (`RD-RP010-001`). Reemplaza el hash en `Usuario.credencialProtegida` sin exponer secretos en texto plano ni requerir una tabla separada de historial de contraseñas.

6. **Excepciones:**

   * **A1 — Sesión inválida, revocada o cuenta en estado `DESHABILITADO`:** Rechazar la operación.

   * **A2 — `credencialActual` incorrecta, `credencialNueva` distinta de `confirmacion` o formato inválido:** Solicitar corrección y conservar intactos `credencialProtegida` y `cambioCredencialPendiente`.

7. **Salida:**

   * Confirmación de actualización de contraseña y habilitación de los permisos propios de sus Roles vigentes, o mensajes de las excepciones A1–A2.

8. **Precondiciones:**

   * El `Usuario` posee una `SesionUsuario` activa y su cuenta se encuentra en estado `HABILITADO`.

9. **Postcondiciones:**

   * Se modificó el atributo `Usuario.credencialProtegida` con el valor protegido de `credencialNueva`.

   * Se modificó el atributo `Usuario.cambioCredencialPendiente` a `false`.

   * La `SesionUsuario` activa quedó habilitada para ejecutar las operaciones autorizadas por los `UsuarioRol` vigentes del `Usuario`.

---

**Reserva sobre la firma:** `credencialActual` figura en la propuesta Gemini, pero la ficha Real actual muestra nueva credencial y confirmación sin exigirla explícitamente en todos los escenarios. La necesidad de contraseña previa (en especial sesión restringida por clave temporal) se debe cotejar con la política aprobada antes de certificar el contrato; no asumir que la firma es canónica.
