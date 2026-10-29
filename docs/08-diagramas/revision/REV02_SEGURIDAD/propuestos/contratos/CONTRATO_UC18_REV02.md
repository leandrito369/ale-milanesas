> **Estado:** PATCH funcional aprobado por RD-UC17/18/53/54 (según CU) el 29/10/2026; sin certificación académica final. Fuente: Gemini 28/10/2026; cotejo funcional con Word maestro (SHA d3fa32360e0b0b8184b1bb1a3eb9ce52bc0fea11) y RD posteriores. Métodos y tipos propuestos, no API implementada.

# Contrato REV-02 — Operación `gestionarAsignacionesRoles` (`UC-18`)

1. **Nombre:** `gestionarAsignacionesRoles(idUsuario: Long, rolesAgregar: Set<String>[0..1], rolesQuitar: Set<String>[0..1])` (equivalente a conjunto objetivo `nuevosRoles: Set<Rol>` cuando conserva la misma semántica).

2. **Responsabilidades:** Gestionar asociaciones vigentes Usuario–Rol sin crear/eliminar entradas del catálogo ROL. Conservar al menos un Rol del Usuario, al menos un ADMINISTRADOR HABILITADO y exclusividad de PROVEEDOR; auditar altas/bajas con **ASIGNACION/REVOCACION** (RD-UC18-001).

3. **Tipo:** `Sistema`

4. **Referencias cruzadas:** UC-18, UC-17 include, F07, IC-UC18-MR5-001, RD-UC18-001, RF-08, OBJE-03, MR-5 tabla `EVENTO_ASIGNACION_ROL`.

5. **Notas:** No se crea evento por intento de agregar Rol ya asignado ni retirar Rol inexistente. La revocación de permisos activos revoca sesiones vigentes. Revalidación atómica y protección del último Administrador HABILITADO; no cambiar definición física del evento.

6. **Excepciones y alternativas:** A1 — Retirar Roles existentes es válido si permanece al menos un Rol y un ADMINISTRADOR habilitado y se respeta exclusividad PROVEEDOR: eliminar asociaciones y registrar **REVOCACION**. A2 — Retirar último Rol del Usuario o último ADMINISTRADOR habilitado (F07): rechazar sin cambios. A3 — Rol ya agregado/no asignado al quitar: omitir duplicados y eventos ficticios. A4 — Cancelación/falla transaccional: revertir todo. A5 — No autorizado: rechazar.

7. **Salida:** conjunto actualizado de Roles vigentes o ausencia de cambio para A3, o rechazo A2/A4/A5; nunca inventar Rol de catálogo.

8. **Precondiciones:** Administrador autenticado/autorizado; Usuario existente; Roles de destino pertenecen al catálogo ROL; no se concede jerarquía implícita.

9. **Postcondiciones:** Para cada Rol agregado se creó `USUARIO_ROL` y `EVENTO_ASIGNACION_ROL` **`tipoEvento='ASIGNACION'`**; por cada Rol retirado se eliminó `USUARIO_ROL` y se creó `EVENTO_ASIGNACION_ROL` **`tipoEvento='REVOCACION'`**. Se conservan al menos un Rol por Usuario, un ADMINISTRADOR habilitado y la exclusividad PROVEEDOR. Ante baja de permisos activos se revocaron `SESION_USUARIO` vigentes. Sin eventos ni cambios ante A3; toda mutación es transaccional.

---

**PATCH controlado vigente (RD-UC18-001 / IC-UC18-MR5-001) — 29/10/2026:** prevalecen las reglas de los apartados 1–9 corregidos sobre la propuesta histórica (incluidas sus reservas ya resueltas). Los valores SQL físicos de MR5 permanecen intactos. Historial anterior preservado en Git; antes de implementar validar DSS/DS y pruebas de concurrencia.
