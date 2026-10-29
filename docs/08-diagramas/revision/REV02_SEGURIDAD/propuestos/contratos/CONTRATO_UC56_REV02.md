> **Estado:** propuesta revisada documentalmente, sin certificación académica final. Fuente: Gemini 28/10/2026; cotejo funcional con Word maestro (SHA d3fa32360e0b0b8184b1bb1a3eb9ce52bc0fea11) y RD posteriores. Métodos y tipos propuestos, no API implementada.

# Contrato REV-02 — Operación `buscarUsuario` (`UC-56`)

1. **Nombre:** `buscarUsuario(nombreUsuario: String[0..1], estado: String[0..1], codigoRol: String[0..1])`

   **Evento auxiliar del mismo UC:** `seleccionarUsuario(idUsuario: Long)`. Aparece después de mostrar resultados en el DSS y en el DS revisado; no crea un CU nuevo ni modifica la cuenta. Requiere verificar su descripción literal con la ficha Real.

2. **Responsabilidades:** Consultar y localizar cuentas de `Usuario` según criterios de nombre de usuario, estado de habilitación o Rol, presentando sus datos administrativos y su eventual vínculo con un `Proveedor` sin exponer credenciales ni tokens secretos.

3. **Tipo:** `Sistema`

4. **Referencias cruzadas:** Caso de Uso `UC-56 — Buscar Usuario`; incluido por `UC-54 — Restablecer Acceso de Usuario` y `UC-55 — Cambiar Estado de Usuario` **(relaciones aprobadas el 25/10/2026)**; Objetivo `OBJE-03`; Requisito `RF-08`.

5. **Notas:** Operación estrictamente de solo lectura. Omite siempre `Usuario.credencialProtegida` y `SesionUsuario.tokenProtegido`.

6. **Excepciones:**

   * **A1 — Criterios de búsqueda con formato inválido:** Solicitar corrección sin ejecutar la consulta.

   * **A2 — Sin cuentas coincidentes:** Informar ausencia de resultados sin fabricar registros.

7. **Salida:**

   * Listado de cuentas coincidentes (`idUsuario`, `nombreUsuario`, `estado`, `cambioCredencialPendiente`, `Roles` vigentes, `Proveedor` vinculado si posee Rol `PROVEEDOR`, y cantidad de Pedidos `PENDIENTE` asignados si posee Rol `REPARTIDOR`) y referencia del `Usuario` seleccionado para el caso de uso invocante; o mensajes de las excepciones A1–A2.

8. **Precondiciones:**

   * El `Administrador` se encuentra autenticado y autorizado.

9. **Postcondiciones:**

   * **(Sin cambios de estado en el sistema: no se crean, modifican ni eliminan instancias de `Usuario`, `UsuarioRol` ni `SesionUsuario`)**.

---

**Alcance:** en UC-54/UC-55 la selección devuelve una referencia de la cuenta identificada a la operación invocante; no concede al actor permiso global adicional fuera de su contexto y no expone credenciales ni tokens.
