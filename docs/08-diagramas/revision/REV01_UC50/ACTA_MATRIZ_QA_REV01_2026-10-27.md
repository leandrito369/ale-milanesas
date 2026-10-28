# REV-01 — Acta, matriz de cambios y control de calidad UC-50

**Fecha local:** 27/10/2026. **Etapa:** piloto de preintegración. **Estado:** PROPUESTO / NO VALIDADO ACADÉMICAMENTE. **No existe código de aplicación implementado por estos cambios.**

## Objetivo y decisión de origen

Corregir la contradicción entre el trabajo de Gemini y la decisión **RD-RP016-001**: el alta de Insumo **UC-50** crea un maestro con `stockActual = 0`, sin costo histórico ni movimiento ficticio. La primera entrada física pertenece a **UC-42**, con trazabilidad y valoración válida según RP-015 y RP-022. Incluir la restricción de unidad de medida aprobada en **RD-RP017-001** donde aparezca UC-51 en el DSS por actor, sin considerar UC-51 revisado por completo.

## Material de origen preservado

Fuente: `CHAT GEMINI Continuación TFI Ale Milanesas - 2610-2710.md` (conversación adjunta por el responsable). Extracción sin reinterpretación de:
- DS Gemini, página 9 UC-50: líneas **11214–11462**.
- DSS Gemini de Administrador 6A: bloque XML entre líneas **3176–3630**.
- Contrato Gemini 6A.3 conjunto UC-50/51/52: líneas **20276–20320**.

Las tres piezas se conservan bajo `originales/`. Se trabajó sobre copias en `propuestos/`, **sin sustituir otros DS/DSS originales, el diagrama de CU ni el DDL**.

## Matriz concreta de diferencias

| ID | Fuente | Cambio | Evidencia / fundamento |
|---|---|---|---|
| C-01 | DSS Admin 6A, `a1_m6` | Eliminar parámetros `stockInicial`, `costoInicial`; incorporar `automatizacionCompraActiva` y nombre físico `nivelObjetivoReposicion` | RD-RP016-001 y diccionario MR-5/MR-6 de INSUMO |
| C-02 | DSS Admin 6A, `a1_r6` | Alta con `stockActual=0`; no `CostoInsumoHistorico` ni `MovimientoInsumo`; ingreso real vía UC-42 | RD-RP016-001 / RP-015 |
| C-03 | DSS Admin 6A, `a1_r7` | Unidad bloqueada cuando hay movimientos o costos históricos; ajuste descriptivo sujeto a permisos | RD-RP017-001; UC-51 completo queda para el lote siguiente |
| C-04 | DS UC-50, `u50_m1`, `u50_m3_new` | Firma sin stock/costo inicial, creación de Insumo con saldo cero, parámetros obligatorios | RD-RP016-001 y diccionario INSUMO |
| C-05 | DS UC-50, `u50_cst_*`, `u50_opt_ini`, `u50_m4_new` | Retirar línea de vida y mensajes para costo/movimiento ficticio generado por alta | RD-RP016-001 |
| C-06 | DS UC-50, validación/retornos | Excepciones de maestro y confirmación sin efectos físicos | RD-RP016-001 |
| C-07 | Contrato 6A.3 | Conservar original agrupado y crear contrato específico UC-50 de nueve secciones y glosario | Convención declarativa aportada por usuario; separar responsabilidades UC-50/51/52 |

## Comprobaciones realmente realizadas

1. Extraídos los **nueve bloques XML** de la conversación y comprobada su formación como XML por analizador `xml.etree.ElementTree` después de desescapar el Markdown del chat, previo a estas modificaciones.
2. Consultados en la rama de revisión los archivos XML originales y propuestos; verificados un elemento `<diagram>` en cada uno, IDs `mxCell` únicos, cantidad de `mxCell` abiertos igual a cerrados más autocerrados, y cierre de `mxGraphModel`, `diagram` y `mxfile`.
3. En el DS corregido se constata ausencia de `stockInicial`, `costoUnitarioInicial` y cinco elementos retirados del costeo inicial; el original los conservaba.
4. En el DSS se identifican y actualizan exactamente las celdas `a1_m6`, `a1_r6`, `a1_r7`; no se presume revisión integral de otros flujos de Administrador.
5. El contrato nuevo tiene las nueve secciones y glosario. Se cotejó la lista de atributos de INSUMO con el diccionario explicativo MR-5/MR-6.

## Limitaciones y aceptación

- **PENDIENTE:** validación visual en Draw.io (maquetación, activaciones y flechas); prueba de abrir/editar/guardar.
- **PENDIENTE:** pase de análisis XML integral sobre los archivos *ya escritos en GitHub* (el control sobre esos archivos fue estructural por texto).
- **PENDIENTE:** comparación literal contra ficha de CU-50 Real/Extendida de las 192 fichas canónicas; el índice del repositorio indica que el DOCX maestro está pendiente de importar.
- **PENDIENTE:** refinar firmas en el DSS y el DS si los CU fuente exigieran eventos más desagregados. No fijar más políticas numéricas sin autorización.
- **PENDIENTE:** revisar el DS/contrato de UC-51 y UC-42 completos, además de sus DSS, antes de cerrar el lote de Insumos/Inventario.
- **PENDIENTE:** recepción de aprobación del responsable para declarar el piloto como validado y utilizarlo en el Trabajo Final.

**Aprobación funcional original:** RD-RP016-001. **Validación de artefactos propuesta:** todavía NO aprobada. **Integración en main:** NO.
