# RD-UC17-001 — Política de emisión inicial de credenciales

**Fecha:** 29/10/2026. **Estado:** APROBADA POR EL RESPONSABLE.  
**CU:** UC-17 `crearUsuario` con inclusión UC-18.  
**Fuentes afectadas:** ficha Real/Extendida Fase4, contrato REV-02 UC17, DSS/DS REV-02, referencia histórica del contrato agrupado 6A.1.  
**Autoridad:** ratificación expresa del responsable 29/10/2026 22:04Z. Ancla G0 `1263ffc17bd0eb7f3c69faaa9ff5ae556cf9de7e`.

## Decisión vinculante
- Un nuevo Usuario con **Roles internos** inicia `HABILITADO`, con contraseña inicial asignada por el Administrador, protegida mediante hash y **`cambioCredencialPendiente = false`**; no se fuerza el flujo de cambio inicial.
- Un nuevo Usuario con **Rol exclusivo `PROVEEDOR`** inicia `HABILITADO`, con credencial temporal protegida y **`cambioCredencialPendiente = true`**, más asociación consistente en `USUARIO_PROVEEDOR` a un `PROVEEDOR` `ACTIVO`.
- La operación es atómica con UC-18: al menos un Rol inicial válido; un registro `USUARIO_ROL` y un evento `EVENTO_ASIGNACION_ROL` con `tipoEvento='ASIGNACION'` por cada Rol inicial; no mezclar `PROVEEDOR` con roles internos.
- La decisión **no agrega un flujo alternativo**, Rol, atributo ni columna de MR5. `credencialInicial` jamás se persiste en texto claro ni aparece en respuestas/logs.

## Criterios de prueba
Caso interno `false`; caso Proveedor `true`; verificación de hash; proveedor activo y único; rechazo de Roles vacíos, nombre duplicado, proveedor mezclado o vínculo inválido; rollback total en error y eventos auditados.
