# RD-RP007-002 — Ratificación de permisos de búsqueda

**Fecha:** 27/10/2026. **Estado:** APROBADA expresamente por el responsable del proyecto.
**Alcance:** UC-33, UC-34, UC-35, UC-36, UC-37 y UC-40; componente de RP-007.

## Matriz formalmente ratificada

| Caso de uso | Administrador | Vendedor | Producción | Repartidor | Proveedor |
|---|---|---|---|---|---|
| UC-33 Buscar Cliente | Directo/contextual | Directo/contextual | No | No | No |
| UC-34 Buscar Pedido | Directo | Directo/contextual | Contextual | Contextual, solo asignados | No |
| UC-35 Buscar Producto | Directo/contextual | Directo/contextual | No | No | No |
| UC-36 Buscar Insumo | Directo/contextual | No | Directo/contextual | No | No |
| UC-37 Buscar Proveedor | Directo/contextual | No | No | No | No |
| UC-40 Buscar Orden de Compra | Directo/contextual | No | Directo/contextual, solo lectura | No | No |

**Directo:** el actor puede ejecutar la búsqueda como función independiente.
**Contextual:** puede consultar solo los registros que requiera otro CU autorizado; no obtiene permiso de búsqueda general ni menú independiente.
**No:** no tiene permiso para ejecutar ese CU. Una consulta de datos puntuales en otro CU requiere autorización y alcance propios, nunca una habilitación implícita.

## Limitaciones obligatorias

- El **Repartidor**, en UC-34, solo puede consultar contextualmente sus propios Pedidos asignados y conforme a la asignación vigente.
- **Producción** no recibe por UC-34 permiso de consulta general; en UC-40 solo lectura, sin capacidad de aprobar, modificar o cancelar órdenes.
- El acceso de búsqueda no concede capacidad de modificación ni visibilidad automática de todos los campos sensibles. Debe aplicarse mínimo privilegio.
- **RD-RP007-001** permanece vigente: UC-29 Registrar Cobro directo solo Administrador y Vendedor. La declaración de efectivo en UC-05 del Repartidor no constituye UC-29 (RD-F04-004).
- Cliente ONLINE no constituye un rol USUARIO adicional. No se modifican los 64 CU ni las relaciones UML.

## Estado residual de RP-007

**Matriz de los CU incluidos en RP-007: RATIFICADA funcionalmente**, en dos actas:
- RD-RP007-001: UC-29.
- RD-RP007-002: UC-33/34/35/36/37/40.

**Pendiente para la implementación:** especificar por rol/operación los campos sensibles visibles y aplicar RBAC en API, vistas y consultas SQL seguras. Esta ratificación no aprueba un catálogo de campos que no haya sido explicitado.

## Fuentes

Contexto maestro del 25/10, RD-006 mínimo privilegio, RD-018 (propuesta anterior a esta ratificación), RP-007, contraste de búsquedas y aprobación expresa del usuario el 27/10/2026.

**No se realizó implementación ni prueba de aplicación; no se modificó el DDL.**
