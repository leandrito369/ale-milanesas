# RD-RP013-001 — Reglas funcionales de comparación de cotizaciones y desempates

**Fecha:** 27/10/2026. **Estado:** APROBADA funcionalmente por el responsable del proyecto. **Fórmulas de normalización, implementación y pruebas:** pendientes.

## Siete reglas aprobadas

1. **Precio:** cuanto menor sea el precio comparable, mejor la puntuación.
2. **Plazo de entrega:** cuanto menor sea el plazo, mejor la puntuación.
3. **Cumplimiento de Proveedor:** cuanto mejor su historial de cumplimiento, mejor la puntuación.
4. **Ponderaciones:** los pesos `pesoRelativo` configurados deben sumar **100 % de los criterios activos**.
5. **Información faltante:** no inventar valores ni asignar puntuaciones favorables a información desconocida; identificar la Cotización como **incompleta para su evaluación**.
6. **Empates:** aplicar criterios de acuerdo con `ordenDesempate` configurado; de persistir la igualdad, el **Administrador decide**.
7. **Resultado:** el sistema presenta una clasificación comparativa, pero **no genera automáticamente una Orden de Compra**. La decisión corresponde al Administrador mediante **UC-12**.

## Alcance y límites

- Se conserva la comparación ponderada aprobada en UC-58, sin imponer pesos 40/25/25/10 u otros pesos prefijados.
- Esta decisión **no establece fórmulas numéricas concretas** para normalización de precio, plazo, cumplimiento u otros criterios configurados.
- No fija escala de puntuación, precisión, redondeos, moneda/base de comparación, regla exacta para historial sin datos ni operación física para almacenar rankings; deberán revisarse cuando se diseñe la implementación y, si agregan conducta de negocio, pedir aprobación.
- La **clasificación** es apoyo a una decisión humana; no aprueba compras, no emite una Orden de Compra y no sustituye UC-12.
- La clasificación de una cotización como «incompleta para su evaluación» es una **calificación de evaluación**, no un nuevo estado persistente aprobado del modelo relacional ni un nuevo caso de uso.
- No se altera PRA-01 ni la decisión RD-RP012-001 sobre plazo configurable de respuesta.

## Aceptación funcional

Las cotizaciones con información suficiente se ordenan considerando los criterios y pesos configurados; los datos faltantes se señalan; los empates se resuelven con el orden definido y eventualmente por Administrador. Ninguna evaluación crea una Orden de Compra sin la autorización de UC-12.

**Trazabilidad:** RP-013, UC-12, UC-58, PRA-01, RD-020 histórica, RD-RP012-001. Este documento no aprueba DDL ni afirma servicios probados.
