# F01 — Implementación SQL y criterios de validación (26/10/2026)

**Decisión:** [RD-F01](../01-gobierno/RD_F01_ESTADOS_COBRO_2026-10-26.md). **Estado:** parche propuesto en PR; ninguna migración de producción ejecutada.

El parche F01 se ejecuta **después del esquema MR-5**. Agrega restricción `CHECK` para los únicos literales `CONFIRMADO` / `ANULADO` y un trigger que impide insertar cobros inicialmente anulados y cualquier transición distinta de `CONFIRMADO → ANULADO`. El trigger histórico `tg_mr5_guardar_cobro` impide reescribir datos originales; el trigger diferido MR-3 exige contraasientos completos para `ANULADO` al confirmar la transacción.

**Migración segura:** si una base contiene `estadoCobro` fuera del catálogo, se aborta sin modificar filas. Se requiere conciliación humana, no limpieza automática.

**Pruebas CI:** crear 60 tablas con DDL MR-5; completar baterías MR-5 heredadas (que insertan literales sintéticos históricos y terminan en rollback), luego aplicar F01; ejecutar batería F01 también con rollback. Repetir F01 sobre esquema migrado MR-3→MR-5. Las pruebas F01 comprueban INSERT confirmado, rechazos de estados no permitidos, alta ANULADO inválida y clave idempotente duplicada; la anulación completa con contraasientos requiere además integración funcional del servicio. No se certifican F04/F06/F07.

**Impacto gráfico:** ninguno: no se alteran tablas, columnas, claves ni flechas.
