> **Estado:** propuesta revisada documentalmente, sin certificación académica final. Fuente: Gemini 28/10/2026; cotejo funcional con Word maestro (SHA d3fa32360e0b0b8184b1bb1a3eb9ce52bc0fea11) y RD posteriores. Métodos y tipos propuestos, no API implementada.

# Contrato REV-02 — Operación `crearUsuario` (`UC-17` «include» `UC-18`)

1. **Nombre:** `crearUsuario(nombreUsuario: String, credencialInicial: String, codigosRol: Set<String>, idProveedor: Long[0..1])`

2. **Responsabilidades:** Registrar una nueva cuenta de `Usuario` en estado `HABILITADO` con credencial inicial protegida y asignarle en la misma operación atómica al menos un `Rol` inicial mediante el caso incluido `UC-18`.

3. **Tipo:** `Sistema`

4. **Referencias cruzadas:** Caso de Uso `UC-17 — Crear Usuario`; incluye `UC-18 — Gestionar Asignaciones de Roles`; Decisión `RD-RP010-001`; Objetivo `OBJE-03`; Requisito `RF-08`.

5. **Notas:** Ningún `Usuario` puede crearse sin al menos un `Rol`. El Rol `PROVEEDOR` es exclusivo (no puede combinarse con roles internos), exige vincularse a un único `Proveedor` comercial en estado `ACTIVO` y admite a lo sumo una cuenta en estado `HABILITADO` para ese mismo `Proveedor`.

6. **Excepciones:**

   * **A1 — `nombreUsuario` duplicado o datos obligatorios inválidos:** Rechazar el alta sin crear el `Usuario`.

   * **A2 — Conjunto `codigosRol` vacío (`codigosRol.size < 1`):** Rechazar el alta sin persistir una cuenta sin Roles.

   * **A3 — Violación de exclusividad o elegibilidad del Rol `PROVEEDOR`:** Si `codigosRol` incluye `PROVEEDOR` junto con otro Rol, o no se informa un `Proveedor` `ACTIVO`, o dicho `Proveedor` ya posee otra cuenta en estado `HABILITADO`, rechazar íntegramente la operación.

7. **Salida:**

   * Confirmación del alta del `Usuario` (`idUsuario`), estado `HABILITADO`, condición `cambioCredencialPendiente = true` únicamente para `PROVEEDOR` según la ficha Real; en usuarios internos se determinará por la política de emisión y no se presupone, más la lista de `Rol` asignados; o mensajes provocados por las excepciones A1–A3.

8. **Precondiciones:**

   * El `Administrador` se encuentra autenticado y autorizado.

   * Existen los `Rol` referenciados en `codigosRol` (y el `Proveedor` referenciado por `idProveedor` cuando se asigna el Rol `PROVEEDOR`).

9. **Postcondiciones:**

   * Se creó una instancia `nuevoUsuario` de `Usuario` con `nombreUsuario`, `credencialProtegida`, `estado = HABILITADO`, `cambioCredencialPendiente` definido por el origen de credencial (`true` obligatorio si Rol `PROVEEDOR`; para interno queda pendiente política), `fechaHoraAlta` y `fechaHoraDeshabilitacion = NULL`.

   * Se ejecutaron en la misma transacción las postcondiciones de `UC-18`: para cada código en `codigosRol`, se creó una instancia de `UsuarioRol` y una instancia de `EventoAsignacionRol` (`tipoEvento = ALTA`) asociadas a `nuevoUsuario`, al `Rol` y al `Usuario` Administrador.

   * Si `codigosRol` correspondió al Rol exclusivo `PROVEEDOR`, se creó una instancia de `UsuarioProveedor` asociando `nuevoUsuario` con el `Proveedor` comercial.

---

**Reserva de autoridad UC-17:** RP-010 regula el acceso cuando el indicador ya es verdadero, pero no impone automáticamente credenciales temporales a todas las cuentas internas. El Word Real de UC-17 solo explicita la temporalidad inicial obligatoria para `PROVEEDOR`. No implementar el alta interna con un valor inferido sin decisión formal.
