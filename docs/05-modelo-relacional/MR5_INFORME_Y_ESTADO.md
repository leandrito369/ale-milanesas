# MR-5 — Endurecimiento de integridad del Modelo Relacional

**Proyecto:** Sistema de Gestión para Ale Milanesas. **Corte histórico de decisiones:** 25/10/2026. **Versión:** propuesta MR-5 v1.0. **Estado real:** parche redactado y auditado estáticamente, **NO EJECUTADO** en PostgreSQL.

## 1. Alcance y precedencia

Se conservan las fuentes MR-3 como originales. `ALE_MILANESAS_MR5_PATCH_POST_MR3_NO_EJECUTADO.sql` es un complemento **posterior** al DDL/Migración MR-3. `ALE_MILANESAS_MR5_DDL_CONSOLIDADO_PROPUESTO_NO_EJECUTADO.sql` encadena el DDL de creación MR-3 y el patch MR-5 para una base nueva. No aplicar ambos secuencialmente al mismo esquema (duplicaría objetos).

No se agregan tablas, columnas ni FK. **Estructura esperada:** 60 tablas, 453 columnas, 125 claves foráneas. Las nuevas funciones, índices y triggers refuerzan reglas entre tablas sin alterar las columnas del diccionario. Las cantidades son estimaciones estáticas: se verifican en PostgreSQL cuando sea posible.

## 2. Matriz de tratamiento de los 10 hallazgos MR-4

| Hallazgo | Qué se implementó o entregó | Estado real | Qué falta |
|---|---|---|---|
| **F01** | CHECK conservador para no admitir estadoCobro vacío | **PARCIAL** | Aprobar catálogo literal íntegro; no suponer `CONFIRMADO` u otros estados |
| **F02** | Asientos Caja/Cuenta/Origen inmutables; Cobro histórico inmutable excepto estado y `ANULADO` terminal; mantener verificación diferida MR-3 | **PARCHE PREPARADO** | Ejecutar casos UPDATE/DELETE, anulación atómica, dos transacciones |
| **F03** | Apertura `SALDO_INICIAL` requiere costo histórico con `fuenteCosto='SALDO_INICIAL'`, misma clave y secuencia 1; movimientos inmutables | **PARCHE PREPARADO** | Probar con stock real y controles de stockActual secuencial del servicio |
| **F04** | Contrato offline, deduplicación con UUID existentes, regla RBAC Repartidor sin UC-29 | **DISEÑO, NO IMPLEMENTADO** | Servicio de sync, snapshot, autorización y conflictos, pruebas en red |
| **F05** | Primera ronda AUTOMATICA validada con plazo congelado; cierre de episodio exige stock recuperado y ausencia de Solicitud/OC pendientes | **PARCIAL SQL** | Servicio detector de cruce, elegibilidad, invitaciones, mensajería, vencimientos y concurrencia |
| **F06** | Reembolso PROCESADO requiere dos efectos únicos al COMMIT; evento aplicable PROCESADO único; estado PROCESADO terminal | **PARCIAL SQL** | Servicio de webhooks autenticados, idempotencia semántica y notificaciones, pruebas reales |
| **F07** | Validadores diferidos de Roles/último Administrador/vínculo Proveedor; revocación automática de sesiones ante cambios | **PARCIAL SQL** | Privilegios físicos y funciones seguras por actor; pruebas de concurrencia |
| **F08** | Se prohíbe transición `PAUSADA→ACTIVA` hasta CU/permiso de reactivación | **PARCHE PREPARADO** | Confirmar si se creará UC para reactivar promoción |
| **F09** | Validación `FOR SHARE` de entidades habilitadas en nuevas operaciones y cambios de referencia | **PARCHE PREPARADO** | Tests de concurrencia e integración; no revocar operaciones abiertas |
| **F10** | Batería de pruebas, precheck y orden de ejecución para base `ale_mr5_*` | **NO EJECUTADO** | PostgreSQL real, inspección de catálogo, EXPLAIN y dos sesiones concurrentes |

**Lectura importante:** `PARCHE PREPARADO` no significa funcionalidad probada ni certificación. Los servicios que deben completar F04, F05, F06 y F07 se describen en el contrato adjunto.

## 3. Decisiones preservadas

- No alterar la numeración **UC-01…UC-64** ni el Diagrama de Casos de Uso rechazado.
- El catálogo `COBRO.estadoCobro` sigue sin completarse en las decisiones históricas. Solo `ANULADO` está textualmente confirmado en MR-3; no se inventa el estado original.
- UC-29 Cobro manual directo: Administrador y Vendedor. El Repartidor no recibe ese permiso por la regla offline.
- No se cancela automáticamente una operación ya iniciada si después se desactiva Producto o Proveedor.
- Un Reembolso por Cobro; reintentos sobre el mismo Reembolso; solo PROCESADO aplica efectos financieros, una sola vez.
- Un Episodio PRA-01 tiene una primera ronda automática como máximo; no emite OC sin decisión de Administrador.
- Se mantiene el origen del plazo operativo fuera de `POLITICA_COMPRA.periodoCalculoDias`; no se precargan 48 horas.
- No crear tabla histórica de credenciales sin exigencia; conservar hashes protegidos y revocar sesiones.

## 4. Riesgos técnicos y limitaciones no ocultados

1. No se pudo compilar ni ejecutar `CREATE FUNCTION` y `CREATE TRIGGER` contra PostgreSQL; cualquier detalle sintáctico/semántico de PL/pgSQL exige ensayo real.
2. Prohibir UPDATE/DELETE de los movimientos asentados es una decisión de integridad consistente con el principio de contra-asientos. Si la aplicación anterior actualizaba movimientos en lugar de agregar nuevos, deberá migrar a operaciones append-only.
3. `SALDO_INICIAL` se confirma después de registrar el costo histórico; para garantizar `INSUMO.stockActual` y secuencia completa de todos los movimientos es necesario canalizar operaciones por un servicio transaccional común.
4. Los `CONSTRAINT TRIGGER` diferidos permiten crear Cobro/Origen/Caja y Reembolso/Origen/Caja en un mismo COMMIT. El servicio debe mantener un orden de locks fijo y la seguridad de los `GRANT`.
5. Las relaciones y claves únicas de MR-3 no convierten en idempotente una notificación externa autenticada; el servicio debe clasificar eventos duplicados en `EVENTO_RESULTADO_REEMBOLSO`.
6. Promoción `PAUSADA` sigue siendo una pausa sin CU de reactivación; permitir su reanudación necesitará un procedimiento autorizado.
7. En el precheck, detalles de pedidos vinculados a productos actualmente inactivos son **esperables** por conservación del histórico, no errores a depurar.
8. El parche NO establece una política de imputación de pagos a Pedidos ni una fórmula de scoring matemático completa; no alterar hechos congelados.

## 5. Archivos para MR-6

- `ALE_MILANESAS_MR5_PATCH_POST_MR3_NO_EJECUTADO.sql`: cambio incremental posterior a MR-3.
- `ALE_MILANESAS_MR5_DDL_CONSOLIDADO_PROPUESTO_NO_EJECUTADO.sql`: creación en base nueva con MR-3+MR-5 (no aplicar también patch).
- `ALE_MILANESAS_MR5_PRECHECK_SOLO_LECTURA.sql`: consulta de duplicados, inconsistencias históricas e invariantes.
- `ALE_MILANESAS_MR5_PRUEBAS_AISLADAS_NO_EJECUTADAS.sql`: ejercicios de rechazo y protección en base `ale_mr5_*`.
- `ALE_MILANESAS_MR5_CONTRATOS_DE_SERVICIO_Y_PRUEBAS.md`: especificaciones para APIs/servicios de UC-49/PRA/offline/seguridad.

## 6. Próximo paso preciso

**MR-6**: instalar o habilitar PostgreSQL de laboratorio; crear `ale_mr5_pruebas`; ejecutar DDL consolidado en esquema aislado; correr precheck y batería; probar concurrencia de dos sesiones; corregir fallos observados; registrar versión/SQLSTATE/rollback y evidencias de `pg_constraint`/`pg_trigger`. Solo entonces actualizar el diagrama relacional físico.
