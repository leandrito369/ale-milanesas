# RP-033 — Informe de inconsistencias y acciones de trazabilidad (27/10/2026)

**Naturaleza:** auditoría documental focalizada, ejecutada sobre fuentes verificables del repositorio, sin modificar originales históricos. **No es una certificación exhaustiva de los 64 CU/192 fichas.**

| Hallazgo | Severidad | Evidencia verificable | Riesgo | Acción propuesta |
|---|---|---|---|---|
| H-01 — Corte A del 23/10 declara 49 CU como vigentes | ALTA, de interpretación | `docs/03-requisitos/historico-2026-10-23/A_REQUISITOS.md`, líneas 5, 30 y 51; contexto canónico línea 85 declara 64 | Se reutilizan CU antiguos con otro significado | Conservar A como histórico; toda derivación nueva toma nombres/códigos del catálogo UC-01…UC-64 |
| H-02 — UC-14 ilustra colisión semántica | ALTA | A histórico líneas 30 y 51 dice UC-14 retirado; contexto canónico línea 104: UC-14 Consultar Cuenta Corriente | Eliminar por error un CU vigente | No transferir regla histórica «UC-14 inexistente» al catálogo actual |
| H-03 — UC-50 histórico tiene otro significado | ALTA | A histórico líneas 5, 8, 35: UC-50 notificación de reembolso; contexto canónico línea 140: UC-50 Registrar Insumo | Contratos o DSS sobre operación equivocada | Traducir por nombre y versión; no sustituir códigos con simple desplazamiento sin cotejo |
| H-04 — UC-19 histórico/actual no coincide | ALTA | A histórico líneas 12, 34: asignación de roles por UC-19; contexto canónico línea 109: UC-19 Actualizar Precio Vigente | Asignación errónea de responsabilidad | Verificar UC por nombre y origen; marcar toda cita del corte histórico |
| H-05 — Prefijos OBJ/OBJE/RF/RNF/IRQ | MEDIA | Contexto canónico línea 45; A histórico secciones Objetivos generales y específicos; RP-033 línea 50 | Objetivo general tomado como específico o requisito como decisión | Usar cinco espacios de nombres sin recodificar; validar correspondencia contra definición original |
| H-06 — DOCX canónico no disponible como fichas nativas en GitHub | ALTA, de cobertura | `docs/04-casos-uso/README.md`, líneas 3–15; seguimiento RP-032 | No puede verificarse exhaustivamente trazabilidad 64×3 ni 153 referencias de subflujo | Importar DOCX original sin reescribir y auditar referencias por ficha |
| H-07 — DSS/DSD de Gemini aún no integrados como fuentes verificables | MEDIA, cobertura | Seguimiento RP-033 y tarea posterior; plan de delegación PR #8 | Falta cotejar secuencias contra CU y RD | Esperar recepción de fuentes editables y auditar individualmente; no generar diagramas sustitutivos |
| H-08 — RDs recientes no propagadas a fichas/contratos | ALTA, propagación | RD-RP010-001 y decisiones RP-012/013/016/017/018/022/023/004+028 en PR #9 | Documento de reglas difiere de casos de uso operativos | Crear checklist RD → CU → DSS/DSD → contrato → servicio → prueba; cambios propuestos mediante PR, no editar fichas históricas |
| H-09 — El seguimiento mezcla estado funcional y estado técnico deliberadamente | MEDIA | Seguimiento RP-01 actualizado; MR-6 solamente laboratorio | Afirmar implementación o cierre integral sin pruebas | Mantener `FUNCIONAL_RESUELTO_TECNICO_PENDIENTE` y estados parciales; registrar evidencia de test al completar |

## Auditoría realizada y cobertura

- Contrastados catálogo canónico (64 CU), requisitos A históricos (49), RP-01 de origen, seguimiento transversal, README de CU, diccionario MR-5/MR-6 y decisiones ratificadas del PR #9.
- La matriz asociada registra **12 trazas temáticas** auditables; **no** corresponde a 64/64 CU certificados ni a una matriz de todas las columnas y pruebas.
- **No** se modificaron objetivos ni se tradujeron automáticamente prefijos o identificadores.
- No se recibió en este acto el documento Word maestro como archivo nativo incorporado al repositorio ni DSS/DSD editables integrados para revisión total.

## Plan de corrección priorizado

1. **P0:** evitar en documentación activa cualquier declaración de «49 CU vigentes» o «UC-14 retirado»; preservar estas afirmaciones en archivos bajo `historico-2026-10-23` como antecedente fechado.
2. **P0:** incorporar el documento maestro UC-01…UC-64, tres niveles (192 fichas), con nombre y edición original; auditar referencias cruzadas sin recrear contenido.
3. **P1:** convertir la matriz parcial en trazabilidad por registro `OBJ → OBJE (si aplica) → RF/RNF/IRQ → UC → RD → entidad/tabla/constraint → prueba`, sólo con soporte documental explícito.
4. **P1:** revisar cada DSS/DSD contra identidad canónica, permisos aprobados, cambios offline, fecha, precios, stock y contabilidad.
5. **P1:** derivar contratos de operación declarativos, con pre/postcondiciones, a partir de operaciones efectivamente identificadas; revisar las nueve secciones exigidas antes de aprobación.
6. **P2:** normalizar redacción genérica en documento vigente, preservando texto histórico y usando propuestas de cambio con referencia a fuente.

## Decisión administrativa sobre RP-033

El **producto de auditoría está entregado y versionado**, pero RP-033 se clasifica **AUDITORIA_PARCIAL_ENTREGADA_PROPAGACION_PENDIENTE**, no `CERRADO`: falta cobertura con DOCX, DSS/DSD y contratos, y revisión sistemática de equivalencias.
