> **Estado:** PATCH funcional aprobado por RD-UC17/18/53/54 (según CU) el 29/10/2026; sin certificación académica final. Fuente: Gemini 28/10/2026; cotejo funcional con Word maestro (SHA d3fa32360e0b0b8184b1bb1a3eb9ce52bc0fea11) y RD posteriores. Métodos y tipos propuestos, no API implementada.

# Contrato REV-02 — Operación `crearUsuario` (`UC-17` «include» `UC-18`)

1. **Nombre:** `crearUsuario(nombreUsuario: String, credencialInicial: String, rolesIniciales: Set<String>, idProveedor: Long[0..1])`. Inclusión obligatoria `UC-18`.

2. **Responsabilidades:** Crear Usuario HABILITADO, hash de credencial inicial y al menos un Rol vigente en una transacción. Roles internos: `cambioCredencialPendiente=false`; Rol exclusivo PROVEEDOR: temporal, `cambioCredencialPendiente=true`, vinculación a un Proveedor ACTIVO sin segunda cuenta habilitada (`RD-UC17-001`).

3. **Tipo:** `Sistema`

4. **Referencias cruzadas:** UC-17, UC-18, RD-UC17-001, RD-UC18-001, RD-RP010-001, RF-08 y OBJE-03; ficha Real/Extendida Fase4.

5. **Notas:** `rolesIniciales` es el conjunto de Roles a asignar, no una nueva tabla. PROVEEDOR es exclusivo de los Roles internos. La credencial de interno, asignada por Administrador, es operativa desde el alta. No se persiste texto claro ni se crea flujo alternativo.

6. **Excepciones:** A1 nombre duplicado o datos obligatorios inválidos: rechazar. A2 sin Rol inicial: rechazar. A3 PROVEEDOR mezclado con internos, Proveedor no ACTIVO, vínculo inconsistente o segunda cuenta habilitada del mismo Proveedor: rechazar. A4 cancelación/falla: rollback completo, sin Usuario ni Roles huérfanos.

7. **Salida:** identificador del nuevo Usuario, Roles asignados y estado HABILITADO; `cambioCredencialPendiente=false` para interno, `true` para PROVEEDOR, o rechazo A1-A4. Nunca devolver el hash.

8. **Precondiciones:** Administrador autenticado/autorizado; Roles solicitados existen en catálogo. Cuando corresponde PROVEEDOR, cuenta comercial identificable en estado ACTIVO sin otra cuenta habilitada.

9. **Postcondiciones:** Se insertó `USUARIO` con `nombreUsuario`, `credencialProtegida` (hash), `estado='HABILITADO'`, `fechaHoraAlta`, `fechaHoraDeshabilitacion=NULL` y `cambioCredencialPendiente` conforme a RD-UC17-001. Por la inclusión UC-18 se insertó por cada Rol un `USUARIO_ROL` y un `EVENTO_ASIGNACION_ROL` con **`tipoEvento='ASIGNACION'`** (RD-UC18-001/MR5) e `idUsuarioAdministrador`; si Rol exclusivo PROVEEDOR se creó también `USUARIO_PROVEEDOR`. Todo es atómico.

---

**PATCH controlado vigente (RD-UC17-001) — 29/10/2026:** prevalecen las reglas de los apartados 1–9 corregidos sobre la propuesta histórica (incluidas sus reservas ya resueltas). Los valores SQL físicos de MR5 permanecen intactos. Historial anterior preservado en Git; antes de implementar validar DSS/DS y pruebas de concurrencia.
