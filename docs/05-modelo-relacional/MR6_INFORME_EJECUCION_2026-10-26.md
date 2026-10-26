# MR-6 — Validación ejecutable en PostgreSQL 17

**Proyecto:** Sistema de Gestión para Ale Milanesas  
**Fecha efectiva de prueba:** 26/10/2026  
**Estado:** **VALIDACIÓN DE ESQUEMA Y PRUEBAS INCLUIDAS SUPERADAS EN LABORATORIO**. No equivale a certificación de aplicación ni producción.  
**Motor:** PostgreSQL 17.11 (contenedor descartable en GitHub Actions).  
**Ejecución exitosa y verificada:** [GitHub Actions #40337106012](https://github.com/leandrito369/ale-milanesas/actions/runs/40337106012).  
**Trabajo:** [PR #2](https://github.com/leandrito369/ale-milanesas/pull/2), rama `ci/mr6-postgresql-2026-10-26`.

## 1. Entornos aislados

| Base efímera | Esquema | Procedimiento |
|---|---|---|
| `ale_mr4_ci` | `mr4_validacion` | MR-3 DDL consolidado + pruebas MR-4 (ROLLBACK) |
| `ale_mr5_ci` | `mr5_validacion` | MR-5 DDL consolidado + pruebas MR-5 (ROLLBACK) + seguridad (ROLLBACK) + concurrencia |
| `ale_mr5_migracion_ci` | `mr5_validacion` | DDL histórico 59 tablas → migración MR-3 → parche MR-5 → catálogo y pruebas MR-5 (ROLLBACK) |

Bases, contraseñas ficticias y filas de prueba se usan **exclusivamente dentro del runner efímero**. No se accedió a una base real ni se aplicó una migración con datos productivos.

## 2. Resultados observados

| ID | Comprobación | Resultado |
|---|---|---|
| MR6-01 | PostgreSQL 17.11 responde a `psql` y `pg_isready` | PASÓ |
| MR6-02 | Compilación del DDL consolidado MR-3 | PASÓ |
| MR6-03 | Batería MR-4 de unicidad, estados, apertura y vigencias | PASÓ |
| MR6-04 | Compilación del DDL consolidado MR-5 | PASÓ |
| MR6-05 | Catálogo MR-5: 60 tablas / 453 columnas / 125 FK | PASÓ |
| MR6-06 | MR-5: apertura con costo incorrecto, inmutabilidad, PROMOCIÓN, Roles, Reembolso | PASÓ (rechazos esperados) |
| MR6-07 | Último ADMINISTRADOR preservado aun cuando queda otro Rol al Usuario | PASÓ |
| MR6-08 | Cambio de credencial revoca SESION_USUARIO activa | PASÓ |
| MR6-09 | Dos sesiones compiten por nombre normalizado de INSUMO | PASÓ: 1 registro confirmado, otra sesión rechazado por UNIQUE |
| MR6-10 | Dos sesiones compiten por `COBRO.claveIdempotenciaOrigen` | PASÓ: 1 Cobro confirmado, segundo rechazado por UNIQUE |
| MR6-11 | DDL original de 59 tablas + migración MR-3 + parche MR-5 | PASÓ |
| MR6-12 | Catálogo de modelo migrado = 60 / 453 / 125 | PASÓ |
| MR6-13 | Prueba MR-5 sobre modelo migrado | PASÓ |
| MR6-14 | Igualdad de huella (columnas, constraints, índices, triggers, funciones) entre instalación directa y migrada | PASÓ |
| MR6-15 | Captura de logs de GitHub Actions | PASÓ |

**Validación basada en el resultado real de la ejecución #40337106012**, que terminó con `conclusion=success`. Las verificaciones incluyen valores efectivamente comprobados por `grep`, errores esperados capturados y la salida de `diff -u` sin diferencias. No se atribuyen a MR-6 pruebas inexistentes.

## 3. Incidencias y correcciones durante MR-6

1. **Primer intento** [#40334777476](https://github.com/leandrito369/ale-milanesas/actions/runs/40334777476): MR-3 compiló; la batería MR-4 falló porque esperaba la excepción `check_violation` de un estado inválido de PROMOCION, pero la regla la rechazó mediante `raise_exception`. Se corrigió **la prueba**, preservando su versión histórica, y se mantuvo la comprobación de fallo por un estado realmente aceptado.
2. **Segunda ejecución** [#40335103928](https://github.com/leandrito369/ale-milanesas/actions/runs/40335103928): MR-3, MR-5, recuentos y baterías pasaron.
3. **Tercera ejecución** [#40335595854](https://github.com/leandrito369/ale-milanesas/actions/runs/40335595854): incorporadas pruebas concurrentes para INSUMO y COBRO; pasaron.
4. **Prueba reforzada** [#40336076611](https://github.com/leandrito369/ale-milanesas/actions/runs/40336076611): agregó control específico del último Administrador y revocación de sesión; pasó.
5. **Migración real en base descartable** [#40336526452](https://github.com/leandrito369/ale-milanesas/actions/runs/40336526452): ruta incremental 59→60 y parche MR-5 pasaron.
6. **Huella estructural** [#40336933736](https://github.com/leandrito369/ale-milanesas/actions/runs/40336933736): falla del script verificador (tipo interno `char` concatenado sin conversión), no de la migración. Se corrigió `contype::text`.
7. **Ejecución final** [#40337106012](https://github.com/leandrito369/ale-milanesas/actions/runs/40337106012): todas las etapas, incluida la comparación de huellas, pasaron.

No se alteraron los archivos SQL históricos MR-3 y MR-5 para corregir fallos de las pruebas; los ajustes están dentro de `sql/mr6/`.

## 4. Riesgos que NO cierra MR-6

**MR-6 certifica solo las operaciones incluidas en la batería, no los servicios completos.**

- **F01 COBRO.estadoCobro:** todavía falta la definición del catálogo literal. Se usó el literal **`ESTADO_PRUEBA` exclusivamente como dato sintético de laboratorio** para comprobar la clave única; **no es un estado aprobado**. Que el esquema lo acepte demuestra precisamente el límite del CHECK pendiente.
- **F04 Offline:** no existe la implementación completa del servicio de sincronización ni pruebas de red, permisos y conflictos de mensajes tardíos.
- **F05 PRA-01:** se probaron piezas del esquema, **no** la detección de episodios, mensajería, vencimientos ni generación idempotente de rondas bajo procesos reales.
- **F06 Reembolsos:** se comprobó el rechazo de `PROCESADO` sin efectos, **no** la ejecución completa del webhook MercadoPago ni callbacks duplicados en un servicio real.
- **F07 Seguridad:** se probaron las invariantes SQL y la revocación local, **no** el RBAC de API ni la autorización de cada UC.
- **F09 Inactivaciones:** falta una matriz adicional de carreras concurrentes con Pedidos y Órdenes de Compra abiertas.
- **Rendimiento:** no se realizaron ensayos con datos representativos, `EXPLAIN ANALYZE` ni medición de bloqueos a escala.
- **Migración de datos históricos:** el camino SQL sí compiló y se probó desde 59 tablas **vacías**; falta evaluar transformaciones/duplicados sobre una copia anonimizada de datos reales, si existieran.

## 5. Próximos pasos

1. Registrar los pendientes no cubiertos como Issues con referencia F01/F04/F05/F06/F07/F09, sin presentar como resueltos los servicios.
2. Mantener la validación PostgreSQL 17 como workflow de CI para modificaciones futuras.
3. Para una eventual instalación con datos, ejecutar prechecks y verificar migraciones en respaldo anonimizado.
4. Continuar documentación/modelo relacional y diagrama relacional únicamente sobre el esquema confirmado, **sin reconstruir el diagrama de CU rechazado**.

## 6. Reproducibilidad

- Workflow: [`.github/workflows/mr6-postgresql.yml`](https://github.com/leandrito369/ale-milanesas/blob/main/.github/workflows/mr6-postgresql.yml)
- Casos y scripts: [`docs/05-modelo-relacional/sql/mr6/`](https://github.com/leandrito369/ale-milanesas/tree/main/docs/05-modelo-relacional/sql/mr6)
- Artefactos y logs: [ejecución #40337106012](https://github.com/leandrito369/ale-milanesas/actions/runs/40337106012).
- Base histórica 59 tablas: `docs/05-modelo-relacional/historico/DDL_59_TABLAS_2026-10-23_NO_EJECUTADO.sql`

**Dictamen:** MR-6 superó la validación ejecutable *de estructura, restricciones y pruebas seleccionadas* en PostgreSQL 17.11. El sistema de gestión completo **no está implementado ni certificado para producción**.
