# BC-07 — Propuesta de contrato mínimo de datos por rol y operación

**Fecha:** 29/10/2026 · **Estado:** PROPUESTA DE SEGURIDAD PARA RATIFICACIÓN; los permisos D/D-C/C están aprobados en RD-RP007-002 pero **los campos concretos NO están aprobados todavía**. No inventar nombres de columnas de PostgreSQL, DTO ni APIs físicas.

La matriz [BC07_PROYECCIONES_MINIMAS_15_ROL_CU.csv](BC07_PROYECCIONES_MINIMAS_15_ROL_CU.csv) tiene **15 combinaciones CU–rol** para UC-33/34/35/36/37/40/64, sin ampliar actores, canales, CU ni permisos de escritura. Datos mínimos propuestos se basan en información necesaria para el flujo de cada CU y en el principio de menor privilegio.

## Condiciones de seguridad que se proponen ratificar

1. La autorización se comprueba **en servidor** por Rol actual, estado de cuenta, CU autorizado y ámbito del objeto. No basta con ocultar menús.
2. El modo **contextual** no admite búsquedas globales: debe estar justificado por un CU invocante autorizado; no se expone un endpoint de búsqueda general para Producción en UC-34 ni para Repartidor.
3. El Repartidor solo consulta Pedidos con asignación **vigente** propia; la pertenencia histórica no alcanza. El contenido se limita al reparto, no al saldo de Cuenta Corriente.
4. Las consultas de UC-40 por Producción son de **solo lectura** y no habilitan cambio/aprobación/cancelación de Órdenes.
5. La proyección de búsqueda jamás devuelve credenciales, tokens, claves API ni datos de autenticación.
6. Costo histórico, valorizaciones, saldos y datos comerciales sensibles se devuelven **solamente si la operación y el Rol autorizan expresamente esa información**. En ausencia de decisión: **no exponer**. La regla de no exposición es una *propuesta de política defensiva* y requiere aceptación como contrato final de datos.
7. Diferenciar identificador técnico, datos operativos necesarios y campos de costo/pago; no deducir acceso por asociación entre tablas físicas.
8. Especificar en B1/B4 las proyecciones concretas de DTO y filtros en SQL a partir de esta matriz **cuando esté ratificada**; aplicar pruebas negativas por Rol y por objeto.

## Decisiones pendientes de ratificación (sin suponer respuesta)

- **BC07-R1:** Confirmar el contenido mínimo por Rol/CU de la matriz de 15 filas.
- **BC07-R2:** Especificar si Administrador/Producción pueden ver importes de costo en UC-64 y en qué condiciones. Las fichas subordinan esos campos al permiso; no consta una matriz de columnas ya ratificada.
- **BC07-R3:** Aprobar si teléfono/domicilio se exponen completos a cada Rol y en qué pantalla; la necesidad operativa debe controlar campos, sin publicar más de lo necesario.
- **BC07-R4:** Delimitar lectura comercial de UC-40 Producción; no conceder visibilidad de precios o evaluación de Proveedores por defecto.

**Estado del hallazgo BC-07:** propuesta concreta entregada; **NO CERRADO funcionalmente** hasta aprobación de BC07-R1..R4. No bloquear análisis técnico de B0, pero sí implementación de proyecciones físicas sensibles.
