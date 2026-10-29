> **Estado:** PATCH funcional aprobado por RD-UC17/18/53/54 (según CU) el 29/10/2026; sin certificación académica final. Fuente: Gemini 28/10/2026; cotejo funcional con Word maestro (SHA d3fa32360e0b0b8184b1bb1a3eb9ce52bc0fea11) y RD posteriores. Métodos y tipos propuestos, no API implementada.

# Contrato REV-02 — Operación `cambiarContrasena` (`UC-53`)

1. **Nombre:** `cambiarContrasena(nuevaCredencial: String, confirmacionNuevaCredencial: String, credencialActual: String[0..1])` (RD-UC53-001).

2. **Responsabilidades:** Reemplazar hash de credencial de Usuario autenticado (interno o PROVEEDOR). Si `cambioCredencialPendiente=true`, sesión restringida habilitada únicamente para UC-53 **no exige** `credencialActual`; si `false`, cambio voluntario **exige** credencial actual que coincida con el hash vigente.

3. **Tipo:** `Sistema`

4. **Referencias cruzadas:** UC-53, UC-01, UC-54, RD-RP010-001, RD-UC53-001, RF-08, RNF-02, OBJE-03, Fase4 ficha Real Paso 3 y ficha Extendida Pasos 2-3/A2.

5. **Notas:** Revalidar cuenta HABILITADO, sesión vigente y tipo de cambio. La nueva contraseña debe cumplir política de seguridad y no reutilizar la misma clave temporal. Hash seguro, jamás secretos en claro/logs; sin tabla de historial de contraseñas inventada.

6. **Excepciones:** A1 — Sesión inválida/revocada/expirada o cuenta no HABILITADO: rechazar. A2 — Nueva credencial inválida, confirmación distinta, reutilización de clave temporal o (cuando `cambioCredencialPendiente=false`) `credencialActual` ausente/no coincidente: rechazar sin cambios. A3 — Cancelación/falla de persistencia: conservar hash e indicador anteriores.

7. **Salida:** confirmación de cambio de contraseña y levantamiento del bloqueo UC-53 sin cambiar Roles; o rechazo A1-A3. No incluir hash ni contraseñas.

8. **Precondiciones:** Existe `SESION_USUARIO` vigente vinculada a un Usuario HABILITADO, incluso si la sesión está restringida a UC-53 por `cambioCredencialPendiente=true`.

9. **Postcondiciones:** Se reemplazó `USUARIO.credencialProtegida` exclusivamente por hash de `nuevaCredencial` y `USUARIO.cambioCredencialPendiente=false`. El Usuario recupera el alcance derivado de sus Roles existentes y sesión válida (sin ampliación de permisos ni columnas). En fallo todo permanece intacto.

---

**PATCH controlado vigente (RD-UC53-001) — 29/10/2026:** prevalecen las reglas de los apartados 1–9 corregidos sobre la propuesta histórica (incluidas sus reservas ya resueltas). Los valores SQL físicos de MR5 permanecen intactos. Historial anterior preservado en Git; antes de implementar validar DSS/DS y pruebas de concurrencia.
