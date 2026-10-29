# RD-B0-G0-001 — Ratificación y cierre de precedencia canónica

**Proyecto:** Sistema de Gestión para Ale Milanesas — UNaM-FCEQyN  
**Fecha de corte:** 29/10/2026  
**Estado:** **APROBADA — CIERRE DOCUMENTAL DE B0 / GATE G0**  
**Autoridad:** decisión del responsable del proyecto del 29/10/2026, 18:42:19 UTC (ratificación G0-D01/D03/D04/D05 y autorización de integración) y 18:55:18 UTC (inspección de diagramas y contratos #10–#19, cierre de actas, autorización para fusionar lotes). **No se simula un dictamen docente independiente.**

## 1. Alcance aprobado

- **G0-D01**: fuente de CU Fase 4 (64 CU, Alto/Extendido/Real) y RD funcionales posteriores como autoridad; DSS/DS y contratos revisados REV01–REV06B2 integrados; contratos consolidados B0 prevalecen en las operaciones corregidas BC01..BC05. **Total 64 CU y 67 operaciones contractuales** (3 CU con operación secundaria, sin inventar UC-65).
- **G0-D02**: ADR-B1-01/02/03/04/06 ratificadas; **ADR-B1-05 NO aprobada en diseño físico**, abierta **CR-B0-F04-001**.
- **G0-D03**: backlog I0→I1→I2→I3, resto I4–I7, con primer vertical Pedido→Asignación online→Preparación→Entrega→Cobro y alcance completo de 64 CU intacto.
- **G0-D04**: 18 escenarios BC-06 se ejecutarán cuando existan backend, APIs e integraciones reales. **Estado en G0: 0/18 pruebas de implementación ejecutadas**. CI documental y SQL de MR6 no son test de servicios.
- **G0-D05**: revisión obligatoria por cada operación antes de programar: CU triple ficha, DSS/DS con mensajes y visibilidad, contrato, RD/CR, RBAC y proyección BC07, MR5/MR6 físicos y pruebas; una discrepancia limita la operación, no habilita cambio unilateral del contrato.

## 2. Inspección de lotes y reservas históricas

El responsable manifestó expresamente haber inspeccionado los diagramas y contratos de **#10–#19** y aprobó resolver sus actas e integrar los lotes. Se registra la **ratificación del responsable** de cierre de las reservas de inspección visual y de revisión del material de diseño **para ingreso a la línea base de construcción**, con la siguiente distinción: el asistente cotejó metadatos, contenido documental y árboles Git, **no reprodujo una inspección visual interactiva de cada página Draw.io ni una validación docente**. Se preservan las reservas históricas como **antecedentes de auditoría**, no se borran ni se reescriben las actas viejas.

El alcance de esta ratificación no convierte los archivos `originales/` en autoridad de implementación, ni certifica Larman/GRASP mensaje a mensaje más allá de los controles registrados. Por **G0-D05**, toda operación deberá volver a contrastarse en el PR de código antes de implementarla, y se abrirá RP/CR ante contradicciones.

## 3. Resultado de integración

Se integraron **18 PR individuales**: #9, #10–#19 y #20–#26, **sin fusión masiva de #19**, respetando el orden y conservando los archivos originales/derivados. `main` integrado al corte:

**Commit canónico de las fuentes de G0:** `1263ffc17bd0eb7f3c69faaa9ff5ae556cf9de7e`.

[Bitácora con SHA y resultado por PR](G0_BITACORA_FUSION_18_PR_2026-10-29.md) y [manifiesto canónico de 67 operaciones](G0_MANIFIESTO_CANONICO_67_OPERACIONES_2026-10-29.csv).

## 4. Precedencia aprobada y control de cambio

1. Fase 4 de 64 CU + **RD ratificadas posteriores** prevalecen sobre formulaciones históricas.
2. Para cada operación, usar el **contrato preferente identificado en el manifiesto canónico**: **40 operaciones** con contratos B0 consolidados y **27** con contratos REV ahora integrados, sin alterar el CU original.
3. DSS/DS bajo `docs/08-diagramas/revision/**/propuestos/` integrados; `originales/` permanece como evidencia. Contratos corregidos B0 en `docs/08-diagramas/consolidacion-b0/` se aplican **a sus operaciones precisas**, no reemplazan a los demás contratos por inferencia.
4. Matriz RBAC 67 (8 canales/roles, **0 P**) y **15 proyecciones BC07 ratificadas** son autoridad de permisos; BC09 define origen interno/externo; UC29 anulación solo Administrador.
5. MR5/MR6 = esquema relacional de **60 tablas**, 453 columnas, 125 FK; MR6 tiene evidencia SQL de laboratorio, no código de aplicación.
6. Toda modificación funcional o física posterior requiere RP/RD/CR controlada; no crear tablas de sincronización F04/S01 sin CR aprobada.

## 5. Verificaciones y puerta a B1

La comprobación directa de árboles/objetos Git en el commit `1263ffc17bd0eb7f3c69faaa9ff5ae556cf9de7e` confirmó **402 de 402 asociaciones de blobs** (CU fuente, DSS, DS, contrato, RBAC y BC07 por cada una de las 67 operaciones), **0 rutas ausentes y 0 divergencias de SHA**. El test CI del manifiesto canónico se ejecutará en la PR de cierre y el resultado se agregará como evidencia separada. No se presume superado un test futuro.

El repo de aplicación `https://github.com/leandrito369/ale-milanesas-app` fue dado de alta por el responsable, y su conexión GitHub App ya permitió crear una rama. **El código de B1, sus migraciones y pruebas se harán exclusivamente allí**, con un `source-lock` fijado a este commit de fuentes y a esta RD de cierre (versión aprobada una vez fusionada).

**Conclusión:** requisitos de gobierno B0 y decisiones G0-D01..05 ratificados, diseño y gobierno de B0 fusionados; G0 queda **APROBADO DOCUMENTALMENTE** al publicarse esta acta y completar el control CI canónico. Esto habilita preparar B1 en el repositorio de aplicación, **no** declara implementado el sistema ni superadas las 18 pruebas BC06.
