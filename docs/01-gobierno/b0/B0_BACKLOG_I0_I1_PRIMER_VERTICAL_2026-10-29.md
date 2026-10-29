# B0.6 — Backlog de arranque I0, I1 y primer recorrido vertical

**Fecha:** 29/10/2026 · **Estado:** PROPUESTO PARA RATIFICACIÓN G0. Prioridades de ejecución en orden del plan B0–B10. **Este backlog no autoriza implementación de código antes del G0.**

## Criterio de iteración

Cada tarea terminada requiere: CU y contrato fuente ratificados; DS/DSS inspeccionados; test positivo/negativo especificado y ejecutado cuando haya servicio; cambio de persistencia bajo ADR/CR; control de Rol y ámbito del objeto; evidencia en PR con logs; no agregar estados/reglas nuevas. Las pruebas documentales B0 **no** sustituyen tests de implementación.

| ID | Orden | CU/alcance | Resultado funcional y dependencias | Criterio de aceptación verificable (cuando exista aplicación) |
|---|---|---|---|---|
| I0-01 | P0 | B0/ADR | Aprobación de línea base y versiones canónicas de CU/DSS/DS/contrato | Acta G0, ADR de arquitectura y lista de pendientes G0-D01..05 firmados |
| I0-02 | P0 | B1/7 módulos | Proyecto Spring Boot arrancable y configuración externa no sensible | Build y arranque reproducibles desde README en máquina limpia |
| I0-03 | P0 | B2/MR-5/MR-6/F01 | Migraciones versionadas sobre PostgreSQL efímero, sin reescribir originales | Instalación de cero, repetición idempotente del arranque, rollback/backup ensayado y huella comparada a MR6 |
| I0-04 | P0 | B8/CI | Tests JUnit/Testcontainers + RBAC/lint + catálogo de fixtures | CI verde ejecuta pruebas genuinas y adjunta logs, no «mock» de DB como prueba física |
| I1-01 | P0 | UC-01/17/18/53/54/55/56 | Identidad, Usuario, Rol, sesiones y cambio de contraseña | Un Usuario con 1+ roles, Proveedor exclusivo, último Admin protegido; sesión revocada; denegación por Rol |
| I1-02 | P0 | UC-02/32/33/38 | Cliente, consulta con proyección BC07 e historial estado | Alta/edición e inhabilitación, búsquedas por Rol y prohibición de nuevo Pedido de Cliente inactivo |
| I1-03 | P0 | UC-30/35/47/48 | Producto y distinción ELABORADO/REVENTA; búsqueda controlada | Crear/editar/cambiar estado sin alterar detalles históricos, sin exponer costo a Vendedor |
| I1-04 | P0 | UC-19/20 | Precio vigente y auditoría temporal | Consultar precio en fecha exacta y conservar versiones; modificaciones no actualizan Pedidos confirmados |
| I1-05 | P1 | UC-15/16/57 | Categoría y ajuste comercial interno sin endpoint de uso general | Aplicación controlada desde Pedido; política vigente y congelamiento histórico sin cambiar categoría por pago en tránsito |
| I1-06 | P1 | UC-50/51/52/36 | Insumo y catálogo unidad como dependencia de Recetas | Alta Insumo en stock 0, búsquedas por rol, unidad histórica protegida; no ejecutar SALDO_INICIAL sin UC42 |
| I2-01 | P0 | UC-03 `cargarPedido` | **Primer vertical Pedido**: Vendedor y datos maestros; compra/canal fuera de alcance del primer demo | Crear Pedido y detalles de forma atómica; persistir categoría/precio/ajustes originales; rechazar Cliente/Producto inactivos; pruebas negativas |
| I2-02 | P0 | UC-34 | Buscar Pedido con permisos directos/contextuales | Vendedor/Administrador autorizados; Producción y Repartidor solo contexto; sin pedidos ajenos ni campos BC07 excluidos |
| I2-03 | P0 | UC-43 | Asignar/reasignar reparto **ONLINE** | Vendedor, Pedido PENDIENTE, Repartidor habilitado; una asignación vigente; conflicto concurrente rechazado |
| I3-01 | P0 | UC-10/28/09 | Receta versionada y Preparación de cantidades originales | Reserva y consumo de Insumos único, costo congelado y prohibición de preparar más que original |
| I3-02 | P0 | UC-05/07/41 | Entrega y Excedentes | Entrega definitiva, extras aceptados físicamente, no duplicar consumo; captura offline queda en B7 |
| I3-03 | P0 | UC-14/29/22/23 | Cuenta Corriente, Cobro y Caja | Vendedor consulta Cuenta; Admin/Vendedor cobran; solo Admin anula, contraasiento único. UC05 declarado no es Cobro |
| I4–I7 | Según plan rector | Restantes CU | Excedentes completos, reembolsos, PRA/Compras, ONLINE, integración, offline y cierre | Matriz E01-C y E09 por operación, no declarar 64 CU implementados hasta pruebas reales |

## Primera demostración vertical real (hito A parcial)

`UC-01 → UC-33/35 → UC-03 cargarPedido → UC-34 → UC-43 online → UC-28 preparar → UC-05 entregar → UC-14 consultarCuenta → UC-29 registrarCobro → UC-22/23`.

**Observaciones:** el flujo cruza B3–B5 y demanda servicio/BD/UI reales; **no** se intenta ejecutar en B0. En la transición UC-05/29 conservar separación de rendición/pago en tránsito según F04. Para evitar alcance falso, la primera versión del recorrido utiliza operaciones ONLINE del personal y Cobro manual permitido; *offline* y Mercado Pago requieren las fases B6/B7.

## Instrucción de delegación en GitHub

Cada Issue para OpenCode/Antigravity debe citar (a) CU + operación, (b) fuente de contrato preferente y commit de E01-C, (c) DS/DSS con pestaña, (d) RBAC 0 P + BC07 ratificada, (e) tablas del mapa como **candidatas**, (f) test positivo/negativo, (g) lo expresamente vedado. **Primero modo planificación; implementación después del G0.**
