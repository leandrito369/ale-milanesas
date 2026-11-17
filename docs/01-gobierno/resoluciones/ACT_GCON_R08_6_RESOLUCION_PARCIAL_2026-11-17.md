# ACT-GCON-R08.6-001 — Archivo propuesto de resolución contractual parcial

**Proyecto:** Sistema de Gestión para Ale Milanesas  
**Ámbito:** repositorio de gobierno `leandrito369/ale-milanesas`; G-CON R08.6 complementaria  
**Fecha del mensaje fuente:** 2026-11-17T03:55:05Z (17/11/2026, 00:55:05 UTC−03:00)  
**Responsable declarado en la conversación:** Machado Victor Leandro  
**Declaración de origen:** «Firmo esta acta como el responsable Machado Victor Leandro»  
**Fuente primaria incorporada:** [ANEXO_CHAT_FIRMA_GCON_R08_6_2026-11-17.md](ANEXO_CHAT_FIRMA_GCON_R08_6_2026-11-17.md), reproducción textual del mensaje con sus tablas de decisión y salvedades  
**Carácter de la firma:** firma declarativa en conversación; **no** firma digital certificada ni comprobación externa de identidad  
**Estado de este asiento:** **PROPUESTA DOCUMENTAL EN PR DRAFT; NO INTEGRADA A MAIN**. La declaración contractual existe en la conversación, pero la publicación canónica y las revisiones editoriales tienen sus propias puertas.  
**Alcance:** se archiva sin agregar, ratificar ni reinterpretar decisiones más allá de la declaración primaria.

## 1. Resolución contractual declarada

| Artículo | Resultado explícito del responsable | Efecto contractual declarado | Salvedad no resuelta |
|---|---|---|---|
| **ART-GCON-A** | **APROBADO — A1** | Evidencia diagnóstica de intento de declaración `D_e` fuera y después del `ROLLBACK` comercial; no Entrega/Cargo/stock/tránsito ficticios ni consumo de idempotencia como éxito; distinguir `NO_DECLARADO` de `0.00` preservando opcionalidad G0 `BigDecimal[0..1]` | G-ARQ Nivel 2: resiliencia del registro diagnóstico posterior al rollback, fallos de infraestructura y retención/purga |
| **ART-GCON-B** | **APROBADO — B1** | No confirmación ante cobertura insuficiente, respuesta contractual `HTTP 422 / COBERTURA_NO_ACREDITADA`; distinguir `409` por payload idempotente diferente y `40P01` como error transaccional con rollback | Cotejar mapeo con E-02/E-07 y protección contextual BC-07 sin filtrar datos de otros Clientes |
| **ART-GCON-C1** | **APROBADO — C1-a** | Cierre único por recorrido; `claveIdempotenciaCierre: UUID` con huella canónica versionada; replay idéntico con recibo histórico, conflicto `409` por payload distinto; nueva clave sobre recorrido cerrado: `RECORRIDO_YA_CERRADO` sin exposición del recibo anterior; ADMIN y ámbito revalidados | Identidades por etapa y cardinalidad Cobro–Aplicación dependen de C2/G-ARQ Nivel 2 |
| **ART-GCON-C2** | **NO VOTADO — DIFERIDO** | No se elige T1/T2 ni protocolo de aplicaciones/COMMIT por etapa | G-ARQ Nivel 2: T1/T2, locks, generadores globales, cardinalidad y pruebas |
| **ART-GCON-D** | **APROBADO — D1** | Evolución contractual a `anularCobroManual(idCobro, motivoAnulacion, claveIdempotenciaAnulacion)`; retorno de IDs de contraasientos `idMovimientoCuenta`, `idMovimientoCaja`, `saldoConfirmado` y `categoriaComercial`; se conservan D7-A y rol ADMINISTRADOR | Definir normalización determinista del motivo; revisión editorial coordinada con E-05 sin aprobación automática de PR #65 |

**Interpretación limitada:** A, B, C1 y D fueron aprobados expresamente por el responsable en el mensaje fuente; C2 fue diferido. Esta constancia conserva su voluntad declarada sin convertirla en código, DDL, aprobación editorial de otra PR, autorización física o certificación de una firma.

## 2. Fuentes normativas y trazabilidad

- [ACT-G-COM-001 ratificada con salvedades](../ACTA_G_COM_001_RATIFICADA_CON_SALVEDADES_2026-11-16.md): RCG-01..08 son autoridad comercial previa; este asiento no las reabre.
- G0 permanece congelado: `source_commit=1263ffc17bd0eb7f3c69faaa9ff5ae556cf9de7e`, `governance_commit=27738b089afdd2698cdae915f75c0e8089a6248a`. No se cambia `source-lock`, manifiesto 67 operaciones, matriz RBAC 67×8 ni las 15 proyecciones BC-07.
- [PR #65 — G-CON E-01..E-10](https://github.com/leandrito369/ale-milanesas/pull/65) continúa **DRAFT y sin fusionar**. `DGCON-01..06` y `PRE-01..07` son controles independientes; la presente resolución no equivale a `GC-10`.
- [PR #47 — CR-C](https://github.com/leandrito369/ale-milanesas/pull/47), [PR #48 — CR-F](https://github.com/leandrito369/ale-milanesas/pull/48), [PR app #91](https://github.com/leandrito369/ale-milanesas-app/pull/91) y [PR app #92](https://github.com/leandrito369/ale-milanesas-app/pull/92): **sin autorización de merge ni de implementación por esta constancia**.
- Resolución G-ARQ Nivel 1: permanece **REPORTADA / PENDIENTE DE RESPALDO DOCUMENTAL ORIGINAL** con SHA verificable en gobierno. Su archivo independiente es requisito antes de invocarla como autoridad completa para G-ARQ Nivel 2.
- El ANEXO preserva el mensaje del usuario. **No se dispone de ID/URL canónico del mensaje, validación de identidad, firma digital ni hash de exportación forense de ChatGPT**; cualquier validación posterior debe señalar la limitación.

## 3. Puertas y prohibiciones expresas

1. **PR documental independiente:** esta rama/PR solo puede proponer los dos nuevos archivos de la presente resolución y del anexo de chat. No alterar G0, fuente contractual original, app, migraciones ni PR #65.
2. **PRE-05 — aislamiento de Demo: NO CERTIFICADO.** Antes de cualquier integración de gobierno/main, inventariar y verificar GitHub Actions, webhooks, GitHub Apps, integraciones CI/CD y automatismos externos capaces de observar push/merge, incluyendo disparadores indirectos hacia la Demo. Una inspección documental parcial **no constituye evidencia de aislamiento**.
3. **FAIL-CLOSED:** en ausencia de evidencia completa de que la fusión documental no afecta la Demo, **NO MERGE** de esta PR ni de #65. Toda autorización posterior debe ser expresa y específica para el acto correspondiente.
4. No ejecutar ni autorizar Flyway `V4`, DDL, cambios en `V1–V3`, G-FIS, G-DEV, CR-C/CR-F, G-VAL, tests en datos reales, despliegue, cambios de configuración, reinicio, rollback operativo, webhooks ni trabajo sobre la Demo.
5. `ART-GCON-C2`, T1/T2, cardinalidad Cobro–Aplicación, orden global de locks, namespaces y generadores continúan **sin ratificación**. Ningún prototipo se considera evidencia de aciclicidad global.
6. La aprobación contractual de la firma candidata de anulación **no modifica por sí sola la firma implementada ni las firmas históricas G0**. Publicación de adenda, adaptación de API y autorización física se tramitan separadamente.

## 4. Condiciones para una eventual incorporación a gobierno/main

- Revisión humana del texto normalizado frente al anexo de declaración primaria.
- Comprobar diff limitado a **estos dos Markdown nuevos**, HEAD/base y estado de la PR, revisiones y checks reales; sin rebase, amend ni force-push.
- **Certificar PRE-05** sobre todos los mecanismos pertinentes y documentar evidencia verificable de que ningún push/merge documental produce efectos en la Demo. Si queda incertidumbre: conservar DRAFT/NO MERGE.
- Obtener aprobación expresa del responsable para la **integración documental de esta PR específica**; la firma de los artículos no implica permiso automático para su merge.
- Después de una integración autorizada, anotar SHA exacto del merge y referencias de revisión sin modificar retroactivamente G0.

## 5. Registro de control

| Control | Estado al preparar la propuesta |
|---|---|
| Declaración explícita del responsable en conversación | **RECIBIDA**; ver anexo |
| Firma digital certificada / validación externa | **NO APORTADA** |
| Incorporación en gobierno/main | **NO** |
| Revisión editorial de esta propuesta | **PENDIENTE** |
| Verificación integral de automatismos de Demo (PRE-05) | **NO CERTIFICADA / BLOQUEA MERGE** |
| Autorización específica de merge de esta propuesta | **NO CONCEDIDA** |
| CR-C/CR-F, G-FIS/G-DEV, V4, Demo | **NO AUTORIZADOS** |
