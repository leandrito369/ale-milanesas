# REV-02 — Adenda de propagación a Fase 4 (Word maestro de 64 CU)

**Fecha:** 28/10/2026. **Objeto:** documentar los cambios a propagar al DOCX maestro sin modificarlo silenciosamente ni sobrescribir su estructura académica.  
**Word cotejado:** `main:docs/04-casos-uso/CASOS_DE_USO_64_TRES_NIVELES.docx`, SHA de blob `d3fa32360e0b0b8184b1bb1a3eb9ce52bc0fea11`.  
**Precedencia:** las RD del 27/10 aprobadas por el responsable prevalecen en su punto específico sobre las fichas redactadas previamente.

## UC-01 — Iniciar sesión

**Word Alto Nivel/Real vigente en `main`:** destaca como obligatoria la sustitución de credencial temporal de `PROVEEDOR`.  
**RD-RP010-001 posterior:** `Usuario.cambioCredencialPendiente=true` bloquea la operación normal de **cualquier** Usuario, interno o PROVEEDOR, aunque permite autenticarse y ejecutar UC-53. El servidor/API debe imponer el bloqueo, no solo la interfaz.  
**Propagación requerida:** actualizar la descripción, restricciones y alternativas de Alto, Extendido y Real sin introducir `«include» UC-01→UC-53` por defecto ni campo nuevo de sesión.

## UC-17 — Crear Usuario

**Word Extendido/Real:** credencial inicial temporal y cambio obligatorio están **expresamente** indicados para Rol `PROVEEDOR`. No se encontró en los pasajes cotejados una obligación equivalente para todas las altas internas.  
**Corrección REV-02:** retirar la extrapolación Gemini `cambioCredencialPendiente=true` para todo Usuario creado. Mantener `true` al crear PROVEEDOR; en cuentas internas no fijar una política de temporalidad sin RD expresa.  
**No se modifica aquí** el formulario ni el valor de base de datos del Usuario interno; requiere decisión si esa política debe formalizarse.

## UC-18 — Gestionar Asignaciones de Roles

**Word:** alta inicial desde UC-17 en una única operación, mínimo un Rol y exclusividad PROVEEDOR; los eventos de alta/baja se auditan.  
**Corrección:** separar `UsuarioRol`, `EventoAsignacionRol` y `SesionUsuario` como objetos distintos, con creación de eventos y revocación de sesiones en operaciones diferenciadas. Garantías transaccionales F07 continúan sin prueba.

## UC-53 — Cambiar Contraseña

**Word Real:** sesión autenticada incluida la restringida; nueva clave con confirmación y borrado de la condición pendiente después de cambio válido.  
**Reserva:** la firma Gemini incluye `credencialActual` obligatoria. La ficha Real consultada no acredita que deba exigirse también durante el primer cambio de clave temporal. **No modificar esta política por inferencia**; contrastar con el criterio de seguridad antes de adoptar firma definitiva.

## UC-54 — Restablecer Acceso de Usuario

**Word Real:** recuperación asistida solo de PROVEEDOR, **verificación de identidad comercial**, vínculo válido y nueva credencial temporal. Conserva estado, Roles e identidad sin habilitación automática.  
**Corrección:** declarar verificación comercial en guarda DSS, guarda DS y precondición contractual. El procedimiento concreto no se inventa.

## UC-55 — Cambiar Estado de Usuario

**Word Extendido/Real anterior a RP-009:** menciona deshabilitar al Repartidor y luego comunicar Pedidos que deberán gestionarse por UC-43.  
**RD-RP009-001 posterior (seguimiento RP-009):** **bloquear previamente la deshabilitación** si existe algún Pedido `PENDIENTE` con asignación vigente; exigir reasignación en UC-43 antes de UC-55.  
**Propagación requerida:** corregir Descripción, Secuencia Normal, Alternativas y Postcondiciones de los tres niveles; rechazo deja cuenta y sesiones intactas. **No introducir una reasignación automática.**

## UC-56 — Buscar Usuario

La búsqueda debe preservar mínimo privilegio, no exponer `credencialProtegida` ni `tokenProtegido`, ni alterar estados. La selección de un Usuario aparece como evento auxiliar en DSS y DS, reflejado en contrato. Cotejar su secuencia literal en las tres fichas antes de confirmar su carácter de operación pública independiente.

## Estado de esta adenda

**EMITIDA, PENDIENTE DE PROPAGACIÓN AL WORD.** El DOCX de `main` no se editó y PR #9/#10 no se fusionaron. Esta adenda documenta diferencias y decisiones, no modifica retroactivamente las fichas ya commiteadas. Se requiere posterior actualización controlada del Word y revisión visual antes de certificar la documentación académica.
