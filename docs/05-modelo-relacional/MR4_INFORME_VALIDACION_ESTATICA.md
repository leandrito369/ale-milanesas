# Ale Milanesas — MR-4 | Informe de validación del Modelo Relacional

**Corte documental:** 25/10/2026. **Material auditado:** `ALE_MILANESAS_MR3_DDL_CONSOLIDADO_NO_EJECUTADO.sql`, `ALE_MILANESAS_MR3_MIGRACION_PROPUESTA_NO_EJECUTADA.sql`, diccionario MR-3, DDL original de 59 tablas y decisiones ratificadas. **Resultado:** revisión estática completada; pruebas reales de PostgreSQL **NO EJECUTADAS** por ausencia de servidor y `psql` en el entorno. **Aptitud de producción: NO CERTIFICADA.**

## 1. Estado y resultados realmente constatados

| Prueba | Resultado | Método |
|---|---|---|
| Definiciones de tablas, sin duplicados | **60 identificadas** | Análisis léxico y catálogo extraído de SQL |
| Columnas vs. diccionario MR-3 | **453 / 453 coincidentes** | Inventario de 60 tablas y 453 filas de diccionario |
| FK declaradas, tabla/columna de cada extremo existente | **125 / 125 consistentes a nivel de nombres** | Análisis de referencias; no valida que PostgreSQL acepte todos los tipos/índices |
| Funciones `CREATE OR REPLACE FUNCTION` | **11 identificadas** | Extracción estática |
| Triggers `CREATE TRIGGER` + `CREATE CONSTRAINT TRIGGER` | **12 identificados** | Extracción estática; para las funciones unitabla se verificó `NEW`/`OLD` contra columnas |
| `DROP CONSTRAINT` y `ADD CONSTRAINT` | **Sin referencia textual huérfana identificada** | Seguimiento de constraints declaradas y removidas |
| Migración vs. sección delta de DDL consolidado | **Idénticas por sentencias SQL normalizadas** | Comparación de 62 instrucciones del delta, excluyendo BEGIN/COMMIT y extensión |
| Cierre léxico de cadenas, comentarios y cuerpos de funciones | **Sin bloque abierto detectado** | Analizador propio; no sustituye parser PostgreSQL |
| Errores estructurales identificados mediante esas pruebas | **0** | Verificador incluido, reproducible |
| `CREATE TABLE` efectivamente ejecutado en PostgreSQL | **NO EJECUTADO** | No hay servicio ni binarios PostgreSQL disponibles |
| Rechazo de operaciones inválidas e integridad temporal | **PREPARADA, NO EJECUTADA** | `MR4_PRUEBAS_POSTGRESQL.sql` |
| Concurrencia, rollback con eventos, idempotencia | **NO EJECUTADA** | Requiere PostgreSQL y servicios transaccionales |

**Advertencia:** «0 errores estructurales identificados» no es equivalente a sintaxis válida certificada, integridad de negocio completa o autorización para producción.

## 2. Hallazgos de calidad y brechas de integridad

Ocho hallazgos de prioridad **ALTA** y dos de prioridad **MEDIA**. Cada uno tiene evidencia y acción en `ALE_MILANESAS_MR4_HALLAZGOS.csv`.

| ID | Prioridad | Hallazgo | Tratamiento necesario antes de dar por validado MR-4 |
|---|---|---|---|
| F01 | ALTA | `COBRO.estadoCobro` no tiene dominio CHECK; `ANULADO` se usa desde una función, pero persiste cualquier otro literal. | Ratificar la enumeración completa y aplicar CHECK sin cambiar los estados aprobados. |
| F02 | ALTA | La integridad diferida del contraasiento contempla INSERT/UPDATE, pero omite DELETE, y una actualización que quita `idCobroAnulado` puede esquivar una revalidación. | Restringir mutabilidad / borrados de la pareja de asientos y probar sus invariantes al COMMIT; evitar borrados físicos. |
| F03 | ALTA | `SALDO_INICIAL` tiene CHECK y UNIQUE, pero no fuerza que el costo histórico referenciado tenga `fuenteCosto='SALDO_INICIAL'` para el mismo Insumo. | Validación transaccional/constraint trigger + prueba de consistencia del primer registro y stock resultante. |
| F04 | ALTA | La sincronización offline solo figura como obligación documental; no hay servicio de sincronización probado. | Tests de condiciones históricas, identidad, permisos, idempotencia y conflictos de asignación. |
| F05 | ALTA | PRA-01 no dispone todavía del servicio transaccional completo de episodio/ronda/cierre. | Tests de concurrencia para cruce de umbral, única ronda automática, publicación y cierre. |
| F06 | ALTA | Falta el flujo integral de resultados externos e idempotencia contable de Reembolsos. | Simular duplicados, RECHAZADO→reintento y PROCESADO exactamente una vez en Caja/Cuenta. |
| F07 | ALTA | Faltan controles persistentes del último Administrador, mínimo de Roles y revocación de sesiones. | Controles transaccionales/privilegios y tests del ciclo de vida de Usuario. |
| F08 | MEDIA | El trigger de Promociones permite `PAUSADA→ACTIVA` aunque no existe CU específico aprobado de reactivación. | Delimitar quién puede iniciar esa transición; no atribuir el permiso por el solo hecho de existir la transición física. |
| F09 | ALTA | Las desactivaciones se verifican solo para determinadas altas; no cubren por completo cambios concurrentes y operaciones creadas por actualizaciones. | Extender reglas y tests a inserciones/ediciones, preservando operaciones anteriores. |
| F10 | MEDIA | Sin ejecución real, no hay comprobación de EXCLUDE GiST, permisos de extensión, bloqueos, ni transacciones diferidas. | Ejecutar batería en PostgreSQL aislado y documentar resultados. |

## 3. Batería SQL entregada (pendiente de ejecución real)

- **Instalación:** `ALE_MILANESAS_MR4_INSTALAR_AISLADO.sql` aplica el DDL MR-3 en el esquema `mr4_validacion` de una base cuyo nombre empieza con `ale_mr4_`. No borra esquemas existentes. Exige `btree_gist`.
- **Pruebas funcionales de DDL:** `ALE_MILANESAS_MR4_PRUEBAS_POSTGRESQL.sql` comprueba catálogo, usuario y rol de prueba, nombres normalizados de Insumo, teléfono compartido de Clientes sin colisión de identidad, estados y transiciones de Promoción, plazo operativo positivo sin valor precargado, una sola apertura `SALDO_INICIAL`, rechazo de vigencias solapadas de Política de Compra y Precio de Producto y aceptación de intervalos contiguos. **Todos los inserts/updates de estas pruebas están dentro de una transacción con `ROLLBACK`.**
- **Lanzador:** `ALE_MILANESAS_MR4_EJECUTAR.sh` exige nombre de base descartable `ale_mr4_*` y presencia de `psql`.
- **Prueba del lanzador en este entorno:** devuelve código 3 por falta de `psql`; esto es una **imposibilidad de ejecución**, no un fallo de PostgreSQL.
- **Verificador estático:** `ALE_MILANESAS_MR4_VERIFICADOR_ESTATICO.py` vuelve a generar el resultado JSON y el CSV de observaciones. Analiza, pero **no ejecuta SQL ni simula reglas de concurrencia**.

**Uso local recomendado:**

```bash
# En un PostgreSQL de laboratorio, NUNCA en producción:
createdb ale_mr4_pruebas
bash ALE_MILANESAS_MR4_EJECUTAR.sh ale_mr4_pruebas
```

La ejecución necesita que todos los archivos del paquete estén en el mismo directorio. Una base `ale_mr4_pruebas` debe ser nueva y descartable. Se recomienda inspeccionar manualmente el SQL antes de ejecutar. **Las pruebas no reemplazan tests de migración sobre un respaldo real**.

## 4. Validación integral adicional para cerrar MR-4

1. Crear la estructura completa en una base vacía PostgreSQL; comprobar `pg_constraint`, `pg_class`, tablas, tipos y `btree_gist`.
2. Migrar una copia desidentificada de datos reales. Ejecutar PRECHECK MR-3; resolver duplicados y vigencias conflictivas sin borrar automáticamente históricos.
3. Reembolso: notificaciones duplicadas, reintentos del mismo Reembolso, cambio de estado a PROCESADO, efectos únicos y rollback ante error.
4. Anulación de Cobro: original conciliado, dos contraasientos, bloqueo de repetición, rechazo de borrado o modificación posterior, error a mitad de transacción y rollback íntegro.
5. PRA-01: dos transacciones en paralelo cruzando umbral, primera ronda automática una sola vez; cotizaciones tardías rechazadas; anulación/cierre con tareas activas protegidos.
6. Roles/Usuario/Proveedor: impedir quitar último ADMINISTRADOR, cuentas de PROVEEDOR duplicadas, acceso deshabilitado y tokens revocados.
7. Reparto offline: condiciones comerciales congeladas; permisos explícitos, asignación vigente y deduplicación de eventos; no conceder UC-29 al Repartidor sin actualizar el RBAC aprobado.
8. `EXPLAIN (ANALYZE, BUFFERS)` con volumen razonable de consultas antes de añadir índices propuestos por rendimiento.

## 5. Dictamen MR-4

**Validación estática:** COMPLETADA sobre las comprobaciones mencionadas.

**Validación ejecutable del esquema en PostgreSQL:** NO EJECUTADA — infraestructura ausente.

**Validación transaccional y de concurrencia:** NO APROBADA — falta implementación y prueba de invariantes críticas.

**Estado general:** **MR-4 PARCIAL / ESQUEMA NO CERTIFICADO PARA PRODUCCIÓN.** Requiere resolver F01–F09 según prioridad, instalar PostgreSQL de laboratorio y adjuntar evidencias ejecutadas para cerrar definitivamente MR-4.

No se modificaron los archivos maestros originales, la migración MR-3, la base de datos ni el Diagrama de Casos de Uso.
