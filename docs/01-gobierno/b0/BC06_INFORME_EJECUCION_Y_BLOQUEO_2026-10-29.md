# BC-06 — Pruebas de implementación solicitadas: informe de ejecución y bloqueo

**Fecha:** 29/10/2026 · **Estado:** 0/18 pruebas de implementación ejecutadas, por **ausencia de aplicación ejecutable**.

## Comprobación real del repositorio
Se inspeccionaron árboles de `main` y PR #22: no contienen módulos Spring Boot, fuentes Java/Kotlin de aplicación, endpoints, adaptadores Mercado Pago ni UI de negocio. Solo `.github/workflows/mr6-postgresql.yml` contiene pruebas históricas específicas de BD. **MR-6 no prueba Cobro, webhook, rendición ni controles de identidad de la aplicación.**

## Casos definidos (NO EJECUTADOS)
La suite [BC06_CASOS_PRUEBA_IMPLEMENTACION_18.csv](BC06_CASOS_PRUEBA_IMPLEMENTACION_18.csv) especifica **18** comprobaciones de UC-05, UC-15, UC-16, UC-21, UC-26, UC-29 y UC-49. Cubre denegación, segregación de Cobro/Anulación, efectivo en tránsito, rendición parcial, origen de webhook, idempotencia, transiciones de Reembolso, concurrencia y suplantación. Los casos tienen `NO_EJECUTADO_SIN_BACKEND` y carecen deliberadamente de ejecución y logs ficticios.

## Qué sí puede ejecutarse ahora
Un **control documental automatizado** de la matriz RBAC (67 × 8, 0 P), las 15 proyecciones BC-07, las 21 anotaciones propagadas BC-05 y el contrato de invocación BC-09. Eso constituye prueba de **consistencia documental**, no de seguridad real del servidor. Se incorporan `tests/b0/test_documentacion_b0.py` y un workflow de CI para tal fin. Ver resultados de CI cuando se publiquen.

## Precondiciones para las pruebas reales (sin alterar secuencia B0→B1→B3/B4/B6)
- B1: estructura de aplicación que compile, PostgreSQL efímero, migrations y CI.
- B3: servicios de dominio/aplicación y transacciones de Cobro, Cuenta, Caja, rendición y reembolso.
- B4: interfaces HTTP con autenticación y RBAC real.
- B6: adaptador Mercado Pago mock/sandbox con autenticidad de eventos.
- Datos ficticios, ejecución aislada y resultados observables (before/after, movimientos, trazas sanitizadas, locks y rollback).

**BC-06 = PENDIENTE DE PRUEBAS DE IMPLEMENTACIÓN.** Se entregan planes y controles documentales verificables; no se adelanta implementación fuera del plan rector.

## Evidencia ejecutada de CI documental — 29/10/2026

GitHub Actions [run 40903529545](https://github.com/leandrito369/ale-milanesas/actions/runs/40903529545) sobre PR #23 concluyó **SUCCESS** (job `verificar-documentos`), con comando `python -m unittest discover -s tests/b0 -p 'test_*.py' -v`: **5 tests, 5 OK, 0 fallos**. Son pruebas **estáticas de consistencia documental**: 67 operaciones con 0 P, tres decisiones RBAC, 15 proyecciones ratificadas, 21 adendas en ocho documentos y regla BC09. Ningún test invocó un backend, webhook real, sandbox de Mercado Pago ni recibió un Cobro. Estado **BC06 0/18 de implementación** sin modificar.
