# Vigencia documental y precedencia canónica — Ale Milanesas

**Corte de control:** 15/11/2026 (Argentina).  
**Estado de la clasificación:** DECLARACIÓN DE VIGENCIA Y PRECEDENCIA solicitada por el responsable. **Estado de integración al corte de redacción:** pendiente de revisión; consultar [PR #64](https://github.com/leandrito369/ale-milanesas/pull/64) para comprobar integración posterior.  
**Naturaleza:** exclusivamente documental. **No** modifica el alcance, aprueba nuevos contratos, cambia decisiones de negocio, valida la empresa ni autoriza implementación, migraciones o despliegue.

## 1. Regla principal de lectura

No se usa «el archivo con fecha más reciente gana». La autoridad vigente es **G0 congelado y sus modificaciones posteriores ratificadas, específicas y trazables**. Un borrador más nuevo no reemplaza un contrato aprobado más antiguo.

- **G0 canónico:** 64 casos de uso `UC-01..UC-64`, **67 operaciones principales**; no renumerar. Fuente [RD-B0-G0-001](b0/RD_B0_G0_001_CIERRE_LINEA_BASE_2026-10-29.md), [manifiesto canónico](b0/G0_MANIFIESTO_CANONICO_67_OPERACIONES_2026-10-29.csv). `source_commit=1263ffc17bd0eb7f3c69faaa9ff5ae556cf9de7e`; `governance_commit=27738b089afdd2698cdae915f75c0e8089a6248a`. Son anclas **inmutables**; jamás sustituirlas por `main`.
- **Fase 4:** `docs/04-casos-uso/CASOS_DE_USO_64_TRES_NIVELES.docx`, DSS/DS y los contratos preferentes señalados **por operación** en el manifiesto; 40 B0 y 27 REV en G0. Se aplican RD/CR posteriores solo cuando tengan autorización pertinente y trazabilidad.
- **Esquema relacional de aplicación vigente:** **62 tablas**, compuesto por la base MR-5 de 60 tablas, F01 y la ampliación MR-6 de dos tablas para partidas, ratificada mediante [RD-MR-PARTIDAS-001](b0/RD_MR_PARTIDAS_001_AMPLIACION_MR_PARTIDA_INSUMO_2026-11-06.md), reflejada en Flyway `V1__baseline_mr5.sql`, `V2__f01_cobro_estados.sql` y `V3__trazabilidad_partidas_insumo.sql` del [repositorio de aplicación](https://github.com/leandrito369/ale-milanesas-app). **MR-5 sigue siendo la base obligatoria**, no una migración revocada. MR-6 (laboratorio 26/10) también designa una campaña de pruebas del modelo de 60 tablas: distinguir ese **informe histórico de ejecución** de la **ampliación a 62 tablas de noviembre**.
- **Gobierno de planificación:** [Plan Rector del 29/10](PLAN_RECTOR_IMPLEMENTACION_2026-10-29.md), complementado por el [roadmap I3–I7 del 15/11](ROADMAP_OPERATIVO_I3_I7_2026-11-15.md) (PR #49 **MERGED**), sin sustituir G0 ni las RD.
- **Estado técnico:** el [roadmap](ROADMAP_OPERATIVO_I3_I7_2026-11-15.md) prevalece para el seguimiento sobre el **snapshot histórico** `docs/ESTADO_ACTUAL.md` fechado 09/11; la evidencia definitiva de cada operación es su PR mergeada, SHA y CI, no la antigüedad de un resumen.
- **Política de fuente de aplicación:** [source-lock](https://github.com/leandrito369/ale-milanesas-app/blob/main/docs/traceability/source-lock.md); conservar G0 y anotar adendas posteriores por su SHA/PR, no reemplazar la fuente original.

## 2. Versiones históricas: conservadas pero NO vigentes para nuevos cambios

| Fuente o familia | Estado | Cómo se puede utilizar | Cómo NO utilizarla |
|---|---|---|---|
| Catálogo **49 CU**, modelos de octubre **59 tablas** y documentación 22–23/10 | **HISTÓRICA — SUPERADA** en numeración y esquema de alcance | Evolución, contraste académico y justificación de decisiones | No asignar identificadores UC actuales ni generar DDL nuevo desde 49/59 |
| `docs/00-contexto/CONTEXTO_MAESTRO_2026-10-25_v1.0.md` | **HISTÓRICO — CORTE 25/10** | Contexto y decisiones vigentes en aquella fecha | No sustituir G0 ni los acuerdos posteriores |
| MR-3/MR-4 y SQL originales `NO_EJECUTADO` | **HISTÓRICOS — NO AUTORIDAD ACTUAL** | Ver cómo se diseñó y probó/migró el esquema | No desplegar archivos históricos ni reemplazar V1–V3 |
| MR-5 **60 tablas** | **BASE HISTÓRICA VIGENTE EN LA CADENA DE MIGRACIONES** | Mantener V1, constraints y antecedentes de F01/MR-6 | No presentar 60 como recuento total actual ni editar V1 in situ |
| Revisiones previas de contratos, `originales/`, actas y matrices anteriores a G0 | **HISTÓRICAS** salvo referencia exacta aprobada en manifiesto | Evidencia de auditoría y procedencia | No sustituir contratos preferentes ni permisos RBAC/BC07 de G0 |
| Cortes de estado `docs/ESTADO_ACTUAL.md` 26/10–09/11 | **SNAPSHOTS HISTÓRICOS** | Reconstrucción de hitos pasados | No tratarlos como situación actual del 15/11 |
| PR de gobierno **#44, #47/#48, #50–#63** abiertas en estado draft | **BORRADOR — NO INTEGRADO** | Investigación, propuestas y decisiones expresamente comunicadas, con estado individual | No usarlas como RD consolidada en main, permiso de DDL o código por su sola existencia |
| PR app **#90/#91/#92** drafts | **TRABAJO NO INTEGRADO** | Revisar posibles conflictos y evidencias en rama | No afirmar que están en producción o en main |

**Regla de preservación:** «histórico/no vigente» significa **no usar como fuente normativa actual**; **no** significa que el documento fuera incorrecto en su fecha, que deba borrarse, ni que debamos deshacer migraciones ya integradas. Conservar SHAs, referencias, trazabilidad e historial.

**Ejemplo de colisión de identificadores:** el catálogo antiguo excluía UC-14 de su vigencia; el **G0 actual sí tiene UC-14 = Consultar Cuenta Corriente**. El nombre del CU se obtiene siempre del manifiesto G0, nunca de equivalencias por número en el catálogo antiguo.

## 3. Referencia de operación E1 para auditoría

Por acuerdo expreso del responsable del **15/11/2026**, la **reconstrucción E1** del circuito Pedido → Preparación → Entrega → Cuenta Corriente → Cobro/Caja, incluyendo Cancelación, Excedentes, anticipos, rendición, REVENTA y ONLINE/offline, se adopta como **referencia operativa de trabajo** para las auditorías E2 y sucesivas.

- **No** se la presenta como observación en campo ni validación independiente de Ale Milanesas.
- E1 **no cambia** el contrato G0 ni ratifica fórmulas propuestas; las discrepancias pasan a hallazgos y, si corresponde, a RD/CR.
- La comprobación de aceptación con usuarios reales sigue siendo distinta de la adopción metodológica de esta referencia.

## 4. Regla de precedencia ante discrepancias

1. Una RD/CR **ratificada y aplicable a la operación** prevalece en su alcance; verificar texto, fecha, aprobación, propagación y SHA.
2. En lo que no haya sido cambiado expresamente, rigen Fase 4/G0, contrato preferente por operación, DSS/DS, matriz RBAC y BC07.
3. La representación relacional vigente se reconstruye por migraciones **V1→V2→V3**, sin editar una migración histórica ni inferir V4.
4. Un plan/roadmap describe **prioridades**, no modifica requisitos ni autoriza API/DDL.
5. Una decisión **aprobada funcionalmente** en PR draft no es automáticamente una **modificación física aprobada** ni documentación integrada. Marcar esas tres dimensiones por separado.
6. Si hay contradicción material no resuelta, registrar hallazgo y bloquear solo el alcance afectado; no elegir el texto más reciente por intuición.

## 5. Alcance y revisión de esta clasificación

**Modifica solamente la señalización de fuentes y su índice.** No se actualiza `source-lock` ni se renumera un CU. No se crean tablas/migraciones ni se cambian flags, RBAC, contratos o pruebas.

**Control de integración posterior:** constatar en [PR #64](https://github.com/leandrito369/ale-milanesas/pull/64) el resultado de revisión y eventual merge; el presente apartado describe la condición al corte 15/11. Si se ratifican nuevos contratos después de este corte, agregar referencia y evidencia en un nuevo cambio; conservar esta fecha como corte histórico.

**Despliegue:** PAUSADO; Issue [app #28](https://github.com/leandrito369/ale-milanesas-app/issues/28) abierta.
