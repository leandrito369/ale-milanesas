# RP-033 — Matriz de trazabilidad auditada (corte 27/10/2026)

**Estado:** MATRIZ PARCIAL VERIFICADA, no exhaustiva. **Fuente:** archivos consultados directamente en la rama del PR #9. **Criterio:** citas de cortes históricos se marcan HISTÓRICO, sin convertir sus códigos UC de forma automática.

| ID | Objetivo de origen | Requisito identificado | CU canónico / proceso | RD o control vigente | Persistencia / evidencia | Estado |
|---|---|---|---|---|---|---|
| T-01 | OBJ-01 / OBJE-01 | RF-01/RF-02 (corte A 23/10) | UC-03, UC-05, UC-43 | RD-RP001/RP019; RD-RP002; RD-RP020 | PEDIDO y asignación / MR-3; servicio sin probar | Correspondencia temática verificada; asociación requisito-CU a reconfirmar en fichas nativas |
| T-02 | OBJ-01 / OBJE-02 | RNF-03/04 (referencias RP-003) | UC-03, UC-05, UC-43 | RD-F04-001..007 | Captura offline vs validación en servidor | Verificado en seguimiento; implementación pendiente |
| T-03 | OBJ-01 / OBJE-03 | RF-08, IRQ-02 (A histórico) | UC-01, UC-53, UC-54/UC-55 | RD-RP010-001, RD-RP009-001 | USUARIO/Rol, control API | Trazado temático; referencia histórica UC-18/UC-19 no trasladable literalmente |
| T-04 | OBJ-02 | RF-09 (A histórico) | UC-19, UC-30 | RD-RP018-001 | Precio vigente temporal; historia preservada | Trazado conceptual; prueba pendiente |
| T-05 | OBJ-02 | RP-016, RP-017 | UC-50, UC-51, UC-42 | RD-RP016-001; RD-RP017-001 | INSUMO, MOVIMIENTO_INSUMO, COSTO_INSUMO_HISTORICO | Trazado por decisiones; mapping a RF/IRQ pendiente |
| T-06 | OBJ-02 | RP-022 | UC-08, UC-42 | RD-RP022-001 | RECEPCION_COMPRA, MOVIMIENTO_STOCK_REVENTA, VALORACION_EXTRAORDINARIA_REVENTA | Trazado por decisión/modelo; pruebas pendientes |
| T-07 | OBJ-02 | RP-012, RP-013 | UC-12, UC-58, PRA-01 | RD-RP012-001; RD-RP013-001 | POLITICA_COMPRA; solicitudes de cotización | Trazado funcional; normalización numérica pendiente |
| T-08 | OBJ-03 | RP-004/RP-028 | UC-14, UC-23, UC-27 | RD-RP004/RP028-001 | Libro Diario, Cuenta Corriente y costos históricos | Trazado de alcance; no afirmar tablas específicas sin mapping completo |
| T-09 | OBJ-03 | RP-006 | UC-05, UC-29 | RD-F04-002..006; RD-RP007-001 | Cobro confirmado vs pagos en tránsito | Trazado funcional; integración pendiente |
| T-10 | OBJ-04 | RF-14 (A histórico) | UC-21 y autenticación ONLINE según catálogo canónico | Decisiones de OTP/RP-029; RP-025 no resuelto | Cliente ONLINE distinto de USUARIO | Correspondencia a CU exacto de autenticación: POR RECONFIRMAR en Word |
| T-11 | OBJ-04 | RF-18 (A histórico) | UC-26 y devolución electrónica según catálogo | RD-F01; RP-027 y RP-029 | Reembolso/contraasiento | Referencia RF histórica identificada; equivalencia UC histórico no asumida |
| T-12 | OBJ-04 | RP-023 | UC-03, UC-21, UC-24, UC-59, UC-60 | RD-RP023-001 | Congelamiento de descuentos por Pedido | Trazado funcional; concurrencia pendiente |

## Significado de estados

- **Verificado:** nombres o relaciones respaldados por contexto canónico, RD aprobada, corte histórico citado o esquema leído.
- **Trazado temático / por reconfirmar:** falta correspondencia exacta requisito → CU → ficha de nivel Real → columna/constraint → caso de prueba, por no disponer del DOCX maestro nativo importado al repositorio.
- **No probado:** toda referencia al modelo relacional no acredita ejecución de aplicación.

## Fuentes verificadas

1. `docs/00-contexto/CONTEXTO_MAESTRO_2026-10-25_v1.0.md`: catálogo canónico UC-01…UC-64 (líneas 85–155), trazabilidad OBJ/OBJE → RF/RNF/IRQ → CU → dominio → datos → pruebas (línea 45), relaciones aprobadas (226–227).
2. `docs/03-requisitos/historico-2026-10-23/A_REQUISITOS.md`: OBJ-01…04, OBJE y referencias RF/IRQ de corte de **49 CU** (líneas 5–51 y secciones posteriores). **No es catálogo actual.**
3. `docs/01-gobierno/RP_01_REGISTRO_PENDIENTES_v1.1_2026-10-25.md`: definición RP-033, razones de control documental (línea 50).
4. `docs/01-gobierno/RP_01_SEGUIMIENTO_TRANSVERSAL_2026-10-26.md`: RPs/RDs y estados, actualizados durante PR #9.
5. `docs/04-casos-uso/README.md`: declara las 192 fichas en documento Word, no incorporadas en ese directorio.
6. `docs/05-modelo-relacional/Diccionario_Explicativo_60_Tablas_MR5_MR6_26-10-2026.md`: soporte parcial de campos de stock/costo (PRODUCTO, INSUMO, RECEPCION_COMPRA, COSTO_INSUMO_HISTORICO).

**Pendiente para cierre exhaustivo:** importar DOCX nativo y concordar íntegramente códigos RF/RNF/IRQ de fuente actual, las 64 fichas de tres niveles, DSS/DSD y contratos de operación; no inventar columnas ni enlaces ausentes.
