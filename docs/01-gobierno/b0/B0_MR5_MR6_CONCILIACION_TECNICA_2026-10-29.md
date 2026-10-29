# B0.4 — Reconciliación MR-5/MR-6, F01/F04 y riesgos de integridad

**Fecha:** 29/10/2026 · **Estado:** RECONCILIACIÓN DOCUMENTAL EJECUTADA; no se ejecutaron nuevas migraciones ni se habilitó producción.

## Fuentes y evidencia

- `docs/05-modelo-relacional/MR3_ESQUEMA_MAESTRO.md` y diccionario MR5/MR6: **60 tablas / 453 columnas / 125 FK**.
- `docs/05-modelo-relacional/MR5_CONTRATOS_SERVICIOS.md`: S-01 offline, S-02 PRA, S-03 reembolso, S-04 roles y S-05 promociones. Es **diseño de servicio**, no implementación.
- `docs/05-modelo-relacional/MR6_INFORME_EJECUCION_2026-10-26.md` y [GitHub Actions MR6](https://github.com/leandrito369/ale-milanesas/actions/runs/40337106012): en PostgreSQL **17.11** pasaron las **15 pruebas enumeradas**: DDL MR3/MR5, ruta migratoria 59→60, recuentos, inmutabilidad y unicidad/restricciones seleccionadas, 2 sesiones concurrentes para Insumo/Cobro, último Administrador y revocación de sesión, comparación de huella. **No certificar todo el comportamiento de la aplicación.**
- `docs/05-modelo-relacional/F01_ESTADOS_COBRO_IMPLEMENTACION.md` y SQL F01: catálogo aprobado `CONFIRMADO`/`ANULADO`, transición `CONFIRMADO→ANULADO` y contraasientos; requiere migra/test en ambiente B1.
- `docs/06-arquitectura/F04_CIERRE_FUNCIONAL_MAESTRO_2026-10-26.md`: reglas F04-001..007 **aprobadas funcionalmente**; S-01, pago en tránsito y rendición tienen **diseño técnico por ratificar**.
- `docs/01-gobierno/b0/B0_MAPA_TECNICO_67_OPERACIONES_2026-10-29.csv`: relaciones candidatas y brechas por CU.

## Tabla de estado (DB física frente a servicios)

| Área | Evidencia SQL MR6 / física | Servicio + control de seguridad/negocio | Estado |
|---|---|---|---|
| Stock / insumo / apertura | Índices, triggers e inmutabilidad de movimientos seleccionados probados | Costo y stock secuencial, preparación versionada, descarte/excedente | PARCIAL, NO IMPLEMENTADO |
| Cobro y contraasientos F01 | MR5 estructura y F01 definido como parche, requisitos de atomicidad diferida | Servicio Cobro, anulación solo Admin, un PAGO/INGRESO o contraasientos | NO IMPLEMENTADO |
| Reembolso F06 | Constraints de aplicación PROCESADO y unicidad en MR5, casos parciales MR6 | Firma webhook, correlación, reintento Admin, idempotencia y efectos una sola vez | NO IMPLEMENTADO |
| Cuentas/roles F07 | MR6 probó último Admin y revocación sesión | Seguridad HTTP, pertenencia de objeto, privilegios SQL y proyección por campo BC07 | NO IMPLEMENTADO |
| PRA-01 F05 | Episodio/ronda y restricciones parciales | Detector de cruce, selección Proveedor, invitaciones, plazo, decisión humana OC | NO IMPLEMENTADO |
| Pedidos/Promoción F08/F09 | Catálogos, referencias e invariantes físico seleccionados | Congelamiento, promociones, UC-60 CANCELADA y políticas, sin retroactividad | NO IMPLEMENTADO |
| Offline/reparto F04 | Claves idempotentes parciales `PEDIDO/COBRO`, sin inbox general | Cola Room, validación, snapshot, pago en tránsito/rendición, conciliación | REQUIERE CR/ADR/SQL NUEVO |
| Integraciones | No hay garantías automáticas de proveedor externo solo por FK | MercadoPago, WhatsApp, OSRM, mocks/sandbox y controles de autenticidad | NO IMPLEMENTADO |

## Dictamen y condiciones para B1

1. **No** editar scripts `MR3_*`, `MR5_*` ni resultados `MR6_*` in situ.
2. Nueva migración física solo por CR/ADR y ensayos en base **efímera**; preservar ruta MR5 consolidada o migrada, aplicar F01 ordenado y documentar comandos/snapshots.
3. No inferir nuevas columnas de los nombres de tablas del mapa E01-C. El mapeo de tablas y transacciones es **hipótesis trazable**, no sustituto de inspeccionar el DDL/DS y procedimientos concretos.
4. **F04** queda un riesgo arquitectónico aislado: se podrá empezar I0/I1 sin alterar su semántica, pero no se codifica sincronización/rendición antes de CR.
5. BC06: 18 pruebas de comportamiento **no ejecutadas por falta de backend**. Las cinco pruebas CI documentales B0 no son las 18 de implementación.

**Dictamen B0.4:** reconciliación documental suficiente para preparar ADR de migración e I0. **No** certifica esquema de producción ni implementaciones.
