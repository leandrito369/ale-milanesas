# RD-UC56-001 — Criterios, proyección administrativa y selección de Usuario

**Fecha:** 05/11/2026. **Estado:** RATIFICADA EXPRESAMENTE POR EL RESPONSABLE EN LA CONVERSACIÓN DE TRABAJO; **incorporación documental pendiente de revisión y merge**.
**Responsable:** Víctor Leandro Machado (`leandrito369`).
**CU y operación:** UC-56 `buscarUsuario`, evento auxiliar `seleccionarUsuario(idUsuario)`.
**Anclas inmutables:** `source_commit=1263ffc17bd0eb7f3c69faaa9ff5ae556cf9de7e`; `governance_commit=27738b089afdd2698cdae915f75c0e8089a6248a`.
**Fuentes:** ficha Fase4 Real/Extendida UC-56; `docs/08-diagramas/revision/REV02_SEGURIDAD/propuestos/contratos/CONTRATO_UC56_REV02.md`, DSS/DS REV02, RBAC 67 operaciones y BC07.

## Registro formal §10.4

| Campo | Valor |
|---|---|
| `decision_id` | `RD-UC56-001` |
| `fecha` | `2026-11-05` |
| `estado` | `RATIFICADA EN CONVERSACIÓN; PENDIENTE INTEGRACIÓN DOCUMENTAL` |
| `autoridad` | Víctor Leandro Machado, responsable del proyecto |
| `regla_aprobada` | Tres decisiones del apartado siguiente: al menos un criterio; siete campos administrativos; selección auxiliar sin nuevo endpoint en este corte. |
| `alternativas_descartadas` | Enumerar todas las cuentas sin filtros; agregar campos fuera del contrato; crear por inferencia un endpoint de selección independiente. |
| `justificacion` | Coherencia con Fase4 Real, principio de mínima exposición y alcance del evento auxiliar UC-56. |
| `artefactos_afectados` | RD nueva; trazabilidad de UC-56, contrato B4 y pruebas en `ale-milanesas-app`. G0/MR5/F01 sin cambios. |
| `fuente_chat` | Conversación de trabajo del 05/11/2026: ratificación expresa del responsable («Las ratifico»). No es una exportación íntegra. |
| `fecha_propagacion` | Pendiente de incorporación de la RD por PR documental y PR posterior de aplicación. |
| `pruebas` | No ejecutadas para esta RD; se requieren los casos de la sección final y evidencia de CI/aceptación en el PR de aplicación. |

## Decisiones ratificadas

1. **Al menos un criterio:** la búsqueda de Usuarios requiere al menos uno de `nombreUsuario`, `estado` o `codigoRol`. Se rechaza una consulta sin filtros, aun cuando los tres parámetros son individualmente opcionales en la firma lógica del contrato. Prevalece la ficha Fase4 Real, que exige ingresar uno o más criterios y contempla criterios insuficientes. En el canal HTTP, la omisión total produce **400**, sin consultar ni enumerar el catálogo completo.
2. **Proyección administrativa estricta:** el Administrador puede recibir únicamente los **siete campos del contrato REV02**: `idUsuario`, `nombreUsuario`, `estado`, `cambioCredencialPendiente`, roles vigentes, `idProveedor` si corresponde y `pedidosPendientesAsignados` para el Repartidor. Se ratifica expresamente esta proyección UC-56, que no integraba las 15 proyecciones CU–Rol específicas de la matriz BC07 original. Nunca se incluyen `credencialProtegida`, `tokenProtegido`, hashes, tokens de sesión u otros datos no enumerados.
3. **Selección contextual:** `seleccionarUsuario(idUsuario)` es evento auxiliar de UC-56 para los flujos invocantes, sin nuevo endpoint HTTP en el corte B4 de consulta. La referencia seleccionada no concede permisos adicionales: UC-54 y UC-55 deben revalidar sesión, rol, cuenta y precondiciones de su propio contrato. La selección visual/flujo integral se acredita en su capa de interfaz, no por la mera existencia del GET.

## Alcance y salvaguardas

- RBAC inalterado: `ADMINISTRADOR=D`; demás roles/canales `NR`.
- Consulta estrictamente de solo lectura; sin modificación de cuentas, Roles, sesiones o asociaciones, ni cambio de la línea base MR5/F01.
- Los filtros inválidos siguen la alternativa A1; los resultados vacíos siguen A2 sin fabricar registros. La representación técnica `200 []` permite a la interfaz informar la ausencia.
- La ruta propuesta `GET /api/v1/usuarios` no sustituye la consulta contextual `/api/v1/usuarios/proveedores` existente para UC-54/UC-37.
- El tiempo de respuesta de RNF-08 y la aceptación humana se verifican por separado, sin dar resultados por aprobados anticipadamente.

## Pruebas requeridas para su implementación B4

Administrador autorizado y roles denegados; credencial pendiente y sesiones inválidas; filtros individuales y combinados; rechazo de consulta sin filtros; proyección exacta de siete campos y ausencia de secretos; selección sin cambio de datos; ausencia de coincidencias; regresión del contexto UC-54/UC-37. Evidencia en PR de implementación con versiones, tests reales y estado de aceptación.

**Gobernanza:** esta RD registra únicamente las decisiones ratificadas el 05/11/2026. No sustituye ni reescribe G0 ni actualiza el `source_commit` de la aplicación; su efecto documental queda sometido a la revisión e integración de la PR correspondiente.
