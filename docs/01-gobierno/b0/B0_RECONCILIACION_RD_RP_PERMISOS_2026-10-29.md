# B0.2/B0.4 — Reconciliación de decisiones, pendientes, permisos y MR-5/MR-6

**29/10/2026 · Estado:** cotejo documental transversal inicial, **no se cierran RP por inferencia**. Las RD recientes resuelven la semántica donde expresamente lo dicen; su implementación se evalúa por separado.  
**Ramas bajo contraste:** `main@ccf4030`, PR #9 (seguimiento RD/RP), PR #10–#19 (diseño). No se fusionan ni se altera Fase 4 en B0.

| Núcleo | Autoridad y cobertura | Estado comprobado | Acción antes de desarrollar |
|---|---|---|---|
| 64 CU y numeración | Word Fase 4 (Git main); 64 consecutivos, incluido UC-14. Contexto del 25/10 es índice, no reemplazo | FUENTE PRESENTE | Cotejar de forma literal RF/RNF/IRQ, actores y flujos con DSS/DS/contratos propuestos por operación; registrar diferencias |
| DSS/DS/contratos | PR #19 matriz 64/67; 54+13 contratos, 67/67 firmas estáticas reportadas | DISEÑO PROPUESTO REVISADO, SIN FUSIÓN | Revisión humana de incorporación, visual pendiente donde lo indique la acta; no afirmar API ni persistencia probadas |
| Aprobaciones funcionales nuevas | RD-RP001/019, 002, 004/028, 007, 009, 010, 012, 013, 016, 017, 018, 020, 022, 023; RD-F08-001 en rama de revisión | APROBADAS en actas expresas, pendientes de propagación donde así conste | Seguir RD específica; **no** copiar estados anteriores de la auditoría Gemini como decisión vigente |
| Roles y permisos | RD-RP007-001 y RD-RP007-002; RP-007, F07 | MATRIZ RATIFICADA PARCIAL EN FUENTES, API NO PROBADA | Crear tabla `CU × actor × acceso directo/contextual × alcance de datos` usando RD; revisar UC-29, UC-33..37/40 y nuevas UC-09/31/32/52/64. No inferir permisos desde `include` |
| Deshabilitación con reparto | RD-RP009-001 / UC-55 + UC-43 | RESUELTO FUNCIONALMENTE, servicio pendiente | Comprobar asignaciones pendientes y exigir reasignación previa online con concurrencia |
| Pedidos/fechas/offline | RD-F04-001..007; RD-RP001/019 y RD-RP020; UC-03/05/21/43 | FUNCIONAL APROBADO, S-01 API/INBOX PROPUESTA | UC-03 y UC-05 captura offline; UC-43 solo online; pagos en tránsito ≠ COBRO/Caja; validación servidor y fecha histórica |
| Cobro/anulación/reembolso | RD-F01, MR-5 S-03, UC-26/29/49 | COBRO estados CONFIRMADO/ANULADO aprobados; MR-6 parcial | No confundir con REEMBOLSO; diseñar transacción y exactly-once en B3/B6; pruebas negativas |
| Inventario y producción | RD-RP016/017/022, UC-42/50/51/52, UC-28/05/07 | Reglas de stock/costo históricas aprobadas, servicios pendientes | UC-50 maestro con stock cero; UC-42 ingreso real SALDO_INICIAL; control versiones, unidades y costos; tests de conservación |
| Cotizaciones/PRA | RD-RP012/013, PRA-01, MR-5 S-02 | Funcional definido con detalles técnicos pendientes | Plazo configurable **sin default 48h**; fórmula numérica/ponderación según fuente; compra siempre humana |
| Promociones | RD-RP023-001 y RD-F08-001 (rama PR #19), UC-21/24/60 | Regla mayor beneficio sin acumulación y UC-60 hacia CANCELADA aprobadas | Confirmar propagación en contrato corregido; no reactivar PAUSADA; conservar descuentos históricos |
| PostgreSQL | MR-5 DDL/parche, F01 y MR-6 GitHub Actions | ESTRUCTURA 60/453/125 Y PRUEBAS SELECCIONADAS **PASARON** en PostgreSQL 17.11, no aplicación | Preservar SQL histórico; migraciones futuras requieren ADR/CR y datos efímeros; no declarar validación de producción |
| RP anteriores no cerrados | `RP_01_SEGUIMIENTO_TRANSVERSAL_2026-10-26.md` documenta 34 RP; RP-011, RP-024 y RP-025 allí abiertos | PENDIENTE/NO REEVALUADO | Contrastar contra nuevas decisiones; si no hay RD posterior permanecer abierto, asignar dueño y no inventar solución |

### Riesgos de trazabilidad de código vigente (ejemplos)

- `UC-14` **sí existe** en catálogo de 64 CU. Los códigos de 49 CU del 23/10 son históricos; la renumeración **no** se traslada por intuición.
- `UC-29` es **Registrar Cobro**; la declaración de efectivo en `UC-05` **no** concede a Repartidor permiso para Cobro definitivo.
- El repositorio público carece de control de acceso a Drive privado: la **fuente entregable a agentes es GitHub**, y los enlaces a Drive indican origen o contraste sujeto a permisos.
- `DSS_REV03A_GEMINI` se conserva deliberadamente; su presencia como `originales/` es excepción documentada, no autorización para usar todos los originales.
- La operación `UC-50` de la matriz global aparece con nombre genérico `Contrato`, mientras su documento fuente dice `registrarInsumo`. Corregir **solo la matriz de revisión mediante PR propio**, no el contrato ni el modelo de negocio por inferencia.

### Estado de G0 por criterio

- [x] Se identificaron rutas exactas de 64 CU, 67 contratos y sus paquetes DSS/DS en GitHub (algunos **solo en ramas propuestas**).
- [x] Se distinguió MR-6 probado en BD frente a backend no implementado.
- [x] Se identificaron RD/RP posteriores relevantes, con vínculo a ramas no fusionadas.
- [ ] No se certificó cotejo **semántico exhaustivo** de todas las pre/postcondiciones de los 67 contratos frente al DOCX canónico.
- [ ] Falta matriz **RBAC exhaustiva por CU** ratificada para interfaces, API y alcance contextual.
- [ ] Falta aprobación del integrador a la cadena PR #9–#19 y la selección de fuentes para trabajar sin usar propuestas como normativas.
- [ ] Falta ratificar ADR de arquitectura y estrategia de migración de B1.

**Dictamen:** B0 está iniciado y sus fuentes recuperadas; **G0 no se declara aprobado**, por lo que no se habilita programación de lógica de negocio basada en supuestos.
