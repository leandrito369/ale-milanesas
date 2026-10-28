> **Estado:** propuesta revisada documentalmente, sin certificación académica final. Fuente: Gemini 28/10/2026; cotejo funcional con Word maestro (SHA d3fa32360e0b0b8184b1bb1a3eb9ce52bc0fea11) y RD posteriores. Métodos y tipos propuestos, no API implementada.

# Contrato REV-02 — Operación `cambiarEstadoUsuario` (`UC-55` «include» `UC-56`)

1. **Nombre:** `cambiarEstadoUsuario(idUsuario: Long, nuevoEstado: String)`

2. **Responsabilidades:** Habilitar o deshabilitar lógicamente una cuenta de `Usuario` (previamente localizada mediante `UC-56`) conservando su identidad y sus Roles, **bloqueando la deshabilitación de cualquier Repartidor que aún posea Pedidos `PENDIENTE` asignados (`RD-RP009-001`)**, impidiendo la pérdida del último `ADMINISTRADOR` habilitado y revocando las sesiones activas al deshabilitar.

3. **Tipo:** `Sistema`

4. **Referencias cruzadas:** Caso de Uso `UC-55 — Cambiar Estado de Usuario`; incluye `UC-56 — Buscar Usuario` **(relación aprobada el 25/10/2026)**; Caso de Uso `UC-43 — Asignar y Reasignar Pedidos a Repartidores`; Decisión `RD-RP009-001`; Pendiente `F07`; Objetivo `OBJE-03`; Requisito `RF-08`.

5. **Notas:** Conforme a `RD-RP009-001`, está prohibido deshabilitar primero a un `Repartidor` y dejar sus Pedidos `PENDIENTE` asignados para reasignar después: la reasignación completa en `UC-43` es condición previa obligatoria para poder deshabilitarlo en `UC-55`.

6. **Excepciones:**

   * **A1 — `Usuario` inexistente o `nuevoEstado` igual al `Usuario.estado` actual:** Informar ausencia de cambio sin modificar registros.

   * **A2 — Intento de deshabilitar al último `Usuario` con Rol `ADMINISTRADOR` en estado `HABILITADO`:** Rechazar la deshabilitación.

   * **A3 — Intento de habilitar una cuenta de Rol `PROVEEDOR` cuando el mismo `Proveedor` comercial ya posee otra cuenta en estado `HABILITADO`:** Rechazar la habilitación.

   * **A4 (`RD-RP009-001`) — Intento de deshabilitar (`nuevoEstado = DESHABILITADO`) a un `Usuario` con Rol `REPARTIDOR` que posee uno o más `Pedido` en estado `PENDIENTE` con `AsignacionReparto` vigente:** **Bloquear la deshabilitación**, conservar `Usuario.estado = HABILITADO` e informar los Pedidos pendientes que deben reasignarse previamente mediante `UC-43`.

7. **Salida:**

   * Confirmación del nuevo `Usuario.estado` (`HABILITADO` \| `DESHABILITADO`), o mensaje de bloqueo con el detalle de los Pedidos `PENDIENTE` a reasignar en `UC-43` (A4) u otros rechazos (A1–A3).

8. **Precondiciones:**

   * El `Administrador` se encuentra autenticado y autorizado, y el `Usuario` objetivo fue localizado mediante `UC-56`.

   * Si se solicita `nuevoEstado = DESHABILITADO` para un `Repartidor`, dicho `Usuario` no posee ningún `Pedido` en estado `PENDIENTE` con `AsignacionReparto` vigente (`RD-RP009-001`).

9. **Postcondiciones:**

   * Se modificó el atributo `Usuario.estado` al valor `nuevoEstado`, conservando intactas su identidad y sus asociaciones en `UsuarioRol` y `UsuarioProveedor`.

   * Si `nuevoEstado = DESHABILITADO`, se modificó `Usuario.fechaHoraDeshabilitacion` con la fecha/hora actual y se modificó `SesionUsuario.fechaHoraRevocacion` en todas las sesiones activas asociadas a ese `Usuario`.

   * Si `nuevoEstado = HABILITADO`, se limpió `Usuario.fechaHoraDeshabilitacion = NULL`.

---

**Reserva F07:** la operación de deshabilitación y la revocación de todas las sesiones activas deberán confirmarse atómicamente; no consta ejecución de prueba concurrente. Si existen Pedidos `PENDIENTE` con asignación vigente, RP-009 impide deshabilitar antes de reasignar mediante UC-43, aunque el Word maestro anterior permita la deshabilitación y comunicación posterior.
