# REV-01 — Acta y matriz UC-51 Modificar Insumo

**Corte:** 28/10/2026. **Estado:** PROPUESTO, pendiente validación académica y visual. **PR:** #10 (borrador).

## Fuentes utilizadas
- Conversación Gemini `CHAT GEMINI Continuación TFI Ale Milanesas - 2610-2710.md`, DS UC-51 en líneas **11470–11694**; contrato conjunto Gemini 6A.3 en **20276–20320**.
- RD-RP017-001 aprobada 27/10; RD-RP016-001; RD-RP022-001; catálogo de 64 CU; DSS del Administrador corregido previamente en `REV01_UC50/propuestos/DSS_ADMIN_6A_REV01.drawio.xml`.
- La relación «include» UC-51 → UC-36 ya fue aprobada el 25/10. No se alteraron diagramas de casos de uso ni SQL.

## Matriz de cambios

| ID | Elemento | Gemini | Corrección | Justificación |
|---|---|---|---|---|
| C-01 | DS `u51_m2` | `tieneHistorial` genérico | Comprobar **movimientos y costos históricos** independientemente, con revalidación al confirmar | RP-017 |
| C-02 | DS `u51_g1` y `u51_g2` | Bloqueo por Recetas/Compras/Movimientos | Unidad bloqueada si existe un movimiento **O** un costo histórico; otras restricciones solo si hay fuente canónica | RP-017 |
| C-03 | DS `u51_m3`, `u51_m4`, `u51_r4` | Nombre y unidad como únicos campos | Distinguir datos no históricos autorizados de unidad; no alterar stock, costos, historial ni parámetros de UC-31 | RP-017 y separación de UC-31 |
| C-04 | DS `u51_r3_ok` / `u51_r3_err` | Confirmación/rechazo genéricos | Aclarar revalidación transaccional y creación independiente de nuevo Insumo cuando hay historial | RP-017 |
| C-05 | Contrato original 6A.3 | Combina UC-50, UC-51 y UC-52 | Contrato de UC-51 independiente, nueve apartados, glosario y casos de excepción | Convención del apunte de cátedra |
| C-06 | DSS Admin 6A `a1_r7` | Restricción histórica genérica | Ya corregido al trabajar UC-50: bloqueo de unidad tras movimiento o costo | RD-RP017-001; no se duplica archivo |

## Verificación realizada
- Lectura de los archivos creados en GitHub, una página DS, identificadores de celdas únicos, balance de etiquetas, ausencia de caracteres `&` sin escape por control textual.
- Contrato contiene nueve secciones y glosario.
- Se comprobó que las guardas distinguen movimientos **y** costos históricos, y contemplan concurrencia.
- **No** se ha probado apertura visual en Draw.io ni semántica temporal/activaciones completas; no se ha parseado con biblioteca XML el archivo publicado en GitHub, solo comprobaciones estructurales.
- **No** se ha cotejado aún con las 192 fichas originales del Word maestro ni con el RBAC efectivo campo por campo. No se implementó o probó API/SQL.

## Pendencias para cerrar el lote conjunto UC-50 / UC-42 / UC-51
1. Cotejar UC-50/42/51 con fichas de los tres niveles y permisos aplicables, verificando campos exactos y dependencias históricas.
2. Revisar **DSS del Administrador**, DSS de Producción y DS individuales en conjunto: eventos, guardas, visibilidad por mensajes y activaciones.
3. Abrir, editar y volver a abrir XML en Draw.io; corregir cualquier superposición.
4. Verificar atomicidad/concurrencia, historia y valoraciones en servicios reales cuando existan.
5. Solo tras lo anterior aprobar los diagramas y contratos como versión de TFI; PR #10 seguirá en borrador.
