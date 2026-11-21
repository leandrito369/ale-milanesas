# Ficha Documental de Preflight de Integración — Modelo Aditivo `P1-A` (`UC-07`)

- **Proyecto:** Sistema de Gestión para Ale Milanesas
- **Fecha:** 21/11/2026 (UTC−03, Argentina)
- **Estado normativo/técnico:** `PROPUESTO` (observaciones técnicas de preflight documental para futura evaluación de `P1-A`; **NO autoriza `P1-A`, `F8`, `G`, `H`, `V5+` ni `R09.4`**)
- **Referencia consultada (solo lectura, NO modificada):** [PR #75 DRAFT](https://github.com/leandrito369/ale-milanesas/pull/75) (`docs/01-gobierno/b0/PROPUESTA_R04_R07_MODELO_ADITIVO_UC07_F8_H_2026-11-21.md`, HEAD `82e59f8e030c7d80dbf2689d95506f8f6fbc58d9`)
- **Alcance negativo:** Esta ficha **no** edita PR `#75`, CR-C `#47`, CR-F `#48`, PR `#68` ni `ale-milanesas-app#101`; tampoco concede por inferencia aprobación de `P1-A`, `F8`, `G` o `H`.

---

## Propósito

Registrar explícitamente **tres verificaciones de integración críticas** que deberán demostrarse antes de promover el diseño aditivo `P1-A` (propuesto en PR `#75`) a una CR física definitiva, a un laboratorio PostgreSQL de `UC-07` o a la fase `R09.4`. Ninguna de estas tres verificaciones invalida el rechazo de `DETALLE_PEDIDO(cantidadOriginal=0)` (`RCG-02`), pero todas condicionan la viabilidad transaccional, de seguridad y de coexistencia `V1`/`P1` de `P1-A`.

---

## Verificación P1A-INT-01 — Una única conexión y transacción ACID para `UC-05` / `UC-06` + `P1` + `IMP-B`

### Riesgo a evitar
En el diseño `F8` Opción A de PR `#75`, se propone segregar un pool `DataSource` privilegiado (`uc07_gateway`) del pool general de la aplicación (`uc07_runtime`). Sin embargo, conforme a `RCG-01`, `RCG-02`, `RCG-03`, `ADENDA_REV04B_E01_E02_E03` e `IC-UC07-GFIS-02`, las operaciones **`UC-05` (`registrarEntrega`)** y **`UC-06` (`cancelarPedido`)** deben escribir de forma **estrictamente atómica** tanto los registros físicos de adicionales `P1-A` (`ATRIBUCION_ENTREGA_ADICIONAL_P1`, `RESOLUCION_CANCELACION_ADICIONAL_P1`, `LOTE_EXCEDENTE_P1`) como las tablas núcleo V1 (`PEDIDO`, `ENTREGA`, `DETALLE_ENTREGA`, `EXCEDENTE`, `MOVIMIENTO_CUENTA`, `MOVIMIENTO_STOCK_REVENTA`) y las tablas financieras G-FIS (`RECONOCIMIENTO_ENTREGA_PE1`, `EVENTO_IMPUTACION_FINANCIERA` `IMP-B`, `RECORRIDO_ENTREGA`, `RECORRIDO_ASIGNACION`).

Si `UC-05` o `UC-06` abrieran **dos conexiones JDBC distintas** (una sobre `uc07_runtime` para `ENTREGA`/`PE-1`/`IMP-B` y otra sobre `uc07_gateway` para `P1-A`), se rompería la atomicidad ACID (riesgo de commit parcial o de deadlock autoinducido entre dos sesiones sobre el mismo `PEDIDO`), sin existir XA/2PC aprobado en la arquitectura monolítica.

### Requisito verificable de preflight
1. **Un solo `Connection` / `TransactionManager` JDBC por ejecución de `UC-05` y `UC-06`:** el servicio transaccional de `UC-05` (en `R09.4`) y `UC-06` debe ejecutar la totalidad de sus escrituras (`V1` + `G-FIS PE-1/IMP-B` + `P1-A`) sobre una **única conexión PostgreSQL y un único `COMMIT`/`ROLLBACK`**, con un rol SQL dedicado de mínima superficie para el módulo transaccional integrado (o delegación encapsulada vía funciones `SECURITY DEFINER` invocadas **dentro de la misma sesión/transacción**).
2. **Prueba negativa obligatoria en futuro laboratorio `R09.4`:** inyectar falla controlada en el último paso (p. ej. al insertar `IMP-B` o `RECONOCIMIENTO_ENTREGA_PE1` tras escribir `ATRIBUCION_ENTREGA_ADICIONAL_P1` y `LOTE_EXCEDENTE_P1`, y viceversa) y comprobar rollback total bit a bit (`0` filas residuales en `ENTREGA`, `PE-1`, `IMP-B`, `ATRIBUCION_ENTREGA_ADICIONAL_P1` y `LOTE_EXCEDENTE_P1`).

---

## Verificación P1A-INT-02 — ACL mínimas sin revocación global no comprobada

### Riesgo a evitar
El endurecimiento `F8` de PR `#75` incluye revocaciones amplias sobre `PUBLIC` (por ejemplo, `REVOKE ALL ON ALL TABLES/FUNCTIONS/SEQUENCES IN SCHEMA ale_gestion FROM PUBLIC`). Si dichas sentencias se aplicaran de forma indiscriminada sobre el esquema existente `ale_gestion` sin haber inventariado primero los roles efectivos con los que operan **todos** los servicios ya integrados en `ale-milanesas-app` (`UC-03`, `UC-08`, `UC-09`, `UC-15/16`, `UC-19`, `UC-20/24/39`, `UC-22`, `UC-28`, `UC-29`, `UC-30/47/48`, `UC-31/32/38`, `UC-42`, `UC-43`, consultas y migrador Flyway), podrían producirse regresiones masivas de `SQLSTATE 42501` en funcionalidades productivas ya aprobadas, o bien dejar huecos inadvertidos si un servicio hereda permisos por pertenencia a roles no auditados.

### Requisito verificable de preflight
1. **Catálogo exhaustivo de objetos y roles antes de cualquier `REVOKE`:** el preflight administrativo `G` debe listar desde `pg_roles`, `pg_auth_members`, `information_schema.role_table_grants` y `pg_proc` qué rol ejecuta hoy cada servicio integrado en `ale_gestion`.
2. **Revocación acotada primero a objetos nuevos `P1-A` y `fn_uc07_*`:** aplicar `REVOKE ALL FROM PUBLIC` de manera incondicional sobre todas las tablas, secuencias y funciones nuevas `P1-A` / `fn_uc07_*`, y condicionar cualquier revocación retroactiva sobre objetos V1–V4 a una matriz de permisos explícita probada contra la **regresión completa de `ale-milanesas-app`** ejecutada bajo roles reales no-owner.
3. **Prueba doble obligatoria:** (a) negativa `42501` demostrando que `uc07_gateway` no puede ejecutar `UPDATE ale_gestion."PRODUCTO" SET "idProducto" = ...` ni `uc07_runtime` escribir en `*_P1`, y (b) positiva demostrando `PASS` del 100 % de la suite de integración existente con los roles operativos reales.

---

## Verificación P1A-INT-03 — Identificadores únicos y resolución inequívoca `V1` / `P1`

### Riesgo a evitar
Bajo `P1-A`, las tablas V1 (`EXCEDENTE`, `OFERTA_EXCEDENTE`, `MOVIMIENTO_EXCEDENTE`, `IMPUTACION_ENTREGA_ADICIONAL`) permanecen físicamente intactas y coexisten con las tablas aditivas `P1-A` (`LOTE_EXCEDENTE_P1`, `OFERTA_EXCEDENTE_P1`, `MOVIMIENTO_EXCEDENTE_P1`, `ATRIBUCION_ENTREGA_ADICIONAL_P1`), mientras las firmas canónicas G0 (`UC-61`, `UC-07` Parte A/B, `UC-41`) siguen recibiendo un único parámetro `Long` (`idExcedente` / `idOfertaExcedente`).

Si en un destino con datos históricos (**Ruta G2**) existieran simultáneamente filas en `EXCEDENTE` V1 y espejos/nuevos lotes en `LOTE_EXCEDENTE_P1`:
- Un semillado incorrecto o un identificador duplicado entre `EXCEDENTE.idExcedente` y `LOTE_EXCEDENTE_P1.idLoteExcedente` podría generar ambigüedad al resolver `idExcedente` en `UC-61`/`UC-07`/`UC-41`.
- Una sincronización imperfecta entre `EXCEDENTE` V1 y su espejo 1:1 en `LOTE_EXCEDENTE_P1` (`idExcedenteV1`) podría habilitar doble consumo de la misma existencia si una consulta/escritura legacy leyera `EXCEDENTE` sin pasar por `LOTE_EXCEDENTE_P1`.

### Requisito verificable de preflight
1. **Regla de no colisión de identificadores:** en Ruta G2, el espejo 1:1 en `LOTE_EXCEDENTE_P1` para todo `EXCEDENTE` histórico disponible debe definir explícitamente una convención inequívoca y única (p. ej. conservar `idLoteExcedente = idExcedenteV1` para los espejos gen-1 migrados y sembrar `seq_uc07_lote_excedente` estrictamente en `MAX(EXCEDENTE.idExcedente) + 1`, y análogamente para `seq_uc07_oferta_excedente > MAX(OFERTA_EXCEDENTE.idOfertaExcedente)` y `seq_uc07_movimiento_excedente > MAX(MOVIMIENTO_EXCEDENTE.idMovimientoExcedente)`), asegurando que **cada `Long` expuesto por la API identifica exactamente un único registro sin ambigüedad entre V1 y P1**.
2. **Única fuente de verdad operativa tras cutover:** una vez activado `P1-A`, **toda** operación `UC-61`, `UC-07` y `UC-41` lee y consume exclusivamente contra `LOTE_EXCEDENTE_P1` / `OFERTA_EXCEDENTE_P1` / `MOVIMIENTO_EXCEDENTE_P1`; las tablas V1 `OFERTA_EXCEDENTE`, `MOVIMIENTO_EXCEDENTE` e `IMPUTACION_ENTREGA_ADICIONAL` quedan protegidas contra inserciones operativas paralelas mediante guardia SQL explícita, y la sincronización de `EXCEDENTE.cantidadDisponible`/`costoHistoricoDisponible` (solo para lotes gen-1 con `idExcedenteV1 IS NOT NULL`) ocurre atómicamente por trigger/función controlada en la misma TX.
3. **Pruebas obligatorias de preflight en laboratorio `G2`:** (a) escenario con `N > 0` filas históricas en V1 demostrando `0` colisiones de PK y resolución 1:1 determinista en `UC-61`/`UC-07`/`UC-41`; (b) intento adversario de consumir el mismo excedente gen-1 una vez por ruta V1 y otra por ruta P1 rechazado con `0` doble consumo ni saldo negativo.

---

## Resumen de estado y puerta

| Verificación | Estado actual | Puerta bloqueada hasta su demostración |
|---|---|---|
| `P1A-INT-01` (1 conexión/TX ACID `UC-05/06 + P1 + IMP-B`) | `PENDIENTE DE DISEÑO DETALLADO Y PRUEBA` | Autorización de CR física `V5+` / laboratorio `UC-07` / `R09.4` |
| `P1A-INT-02` (ACL mínimas sin revocación global no comprobada) | `PENDIENTE DE INVENTARIO Y PRUEBA CON ROLES REALES` | Levantamiento de `F8` y laboratorio `UC-07` |
| `P1A-INT-03` (IDs únicos y resolución inequívoca `V1`/`P1`) | `PENDIENTE DE ESPECIFICACIÓN G2 Y PRUEBA` | Autorización de Ruta `G2` y `R09.4` |
