# B0.1 — Inventario verificable de fuentes y precedencia

**Corte de verificación: 29/10/2026. Estado: inventario de rutas ejecutado; aprobación de fuentes de diseño pendiente.**  
**Repositorio:** `leandrito369/ale-milanesas`. **Rama de B0:** `docs/b0-linea-base-2026-10-29`, apilada sobre PR #20.  
**Manifest:** [B0_MANIFIESTO_RUTAS_SHA.csv](B0_MANIFIESTO_RUTAS_SHA.csv), con ruta, blob SHA Git, commit, tamaño, estado y enlace de GitHub. **No es SHA-256 de contenido**, sino identificador Git del blob.

## Autoridad y accesibilidad

| Clase | Identidad y ubicación comprobada | Estatus en B0 | Acceso del agente |
|---|---|---|---|
| CU 64 × tres niveles | `main@ccf4030:docs/04-casos-uso/CASOS_DE_USO_64_TRES_NIVELES.docx` (blob `d3fa32360e0b0b8184b1bb1a3eb9ce52bc0fea11`); fuente nativa de cotejo Fase 4 adicional en Drive, ID `1BMF2Yfsh2ki353fU2dS5eZtIsYrOntpkjjAzulNy1uY` | Fuente principal de especificaciones; auditorías de 192 fichas reportadas, **sin asumir aprobación semántica completa** | DOCX **en GitHub** accesible; Google Doc requiere permiso propio, no es recurso automáticamente compartido a agentes |
| DSS/DS/contratos corregidos | [PR #10](https://github.com/leandrito369/ale-milanesas/pull/10) a [PR #19](https://github.com/leandrito369/ale-milanesas/pull/19), encadenados; corte superior `64af3c3baa571c2d512242e396267a31f0da3efd`, contiene `docs/08-diagramas/revision/` | `PROPUESTA_COTEJADA_ESTATICAMENTE`; **no fusionada a main**, sin prueba de software | URL/commit inmutable y checkout de `revision/rev06b2-recetas-inventario-2026-10-29`; usar exclusivamente para análisis/revisión, no como norma aprobada |
| Matriz de cobertura | `64af3c3baa571c2d512242e396267a31f0da3efd:docs/08-diagramas/revision/MATRIZ_GLOBAL_COBERTURA_64_CU_67_CONTRATOS_2026-10-29.md` | 64 CU/67 operaciones; firma textual DSS–DS–contrato 67/67 reportada, con reserva visual | Referenciar commit + ruta, nunca solo nombre del lote |
| Auditoría de lote | Actas REV01…REV06B2 y `INDICE_INSPECCION_DIAGRAMAS_CONTRATOS_REV01_A_REV06A_2026-10-28.md` | QA estático; nuevas piezas REV06B2 requieren aceptación/inspección indicada en acta | GitHub rama de revisión; los originales `originales/` no son sustituto de los corregidos `propuestos/` |
| RD/RP históricos | `docs/01-gobierno/RD_01_REGISTRO_DECISIONES_v1.1_2026-10-25.md` y `RP_01_REGISTRO_PENDIENTES_v1.1_2026-10-25.md` | Contexto subordinado a decisiones posteriores | GitHub main |
| RD/RP posteriores | `64af3c3baa571c2d512242e396267a31f0da3efd:docs/01-gobierno/RD_RP*.md`, `RD_F08_001_UC60_BAJA_DEFINITIVA_PROMOCION_2026-10-29.md`; `RP_01_SEGUIMIENTO_TRANSVERSAL_2026-10-26.md` (PR #9) | **RD aprobadas funcionalmente donde así lo dicen**; archivos de seguimiento aún en rama no fusionada | Referenciar SHA/PR; no presentar el contenido de una rama como `main` |
| Base relacional MR-5/MR-6 | `main:docs/05-modelo-relacional/` — diccionario 60 tablas, 453 columnas, 125 FK; SQL MR-5, workflow MR-6, parche F01 | MR-6 **ejecutado y pasó pruebas seleccionadas** en PostgreSQL 17.11; no servicios ni producción | GitHub main + [CI MR-6](https://github.com/leandrito369/ale-milanesas/actions/runs/40337106012) |
| PRA y offline | `docs/02-procesos/PRA_01_REPOSICION_AUTOMATICA_v1.1_2026-10-25.md`; `docs/06-arquitectura/F04_CIERRE_FUNCIONAL_MAESTRO_2026-10-26.md`; S-01 borrador | Reglas funcionales aprobadas donde constan, API/persistencia de sincronización **no ratificadas** | GitHub main, no convertir borrador técnico en contrato definitivo |
| Código de aplicación | Ningún módulo Java/Spring, Android o web verificado en árbol `main` al corte | **NO IMPLEMENTADO/NO VERIFICADO** | B1 en adelante |

**Fuentes Drive adicionales identificadas (evidencia, no sustitutos canónicos):** [conversación Gemini 26–27/10](https://docs.google.com/document/d/1sDnzFfxkEDbcnxzWgYQr60Ku3nRciQa9y5xQUFVoBr8/edit), [auditoría preliminar DSS/DS/contratos](https://docs.google.com/document/d/1KJuP7miPyAUAis-0LdHFE1OsSQDgk6w6en6zP008IEc/edit). La auditoría identifica problemas de la entrega **original**; los lotes de corrección en GitHub posterior deben contrastarse antes de declarar una discrepancia no resuelta. **No copiar documentos privados de Drive a repositorio público.**

## Resultado del cotejo automatizado de rutas

- Se localizaron **64 CU diferentes y 67 operaciones** en la matriz del PR #19. Casos con dos operaciones: **UC-03, UC-07, UC-29**.
- Se verificó en el árbol Git de `64af3c3baa571c2d512242e396267a31f0da3efd` la existencia de las **67 rutas de contrato y sus DSS/DS de lote** usadas en [B0_MATRIZ_64_CU_67_OPERACIONES.csv](B0_MATRIZ_64_CU_67_OPERACIONES.csv). DSS y DS pueden agrupar varios CU como pestañas; **esto verifica existencia de archivos, no inspección de cada página ni exactitud de cada mensaje**.
- Distribución de operaciones por lotes: REV-02 Seguridad: 7; REV-06B.1 Clientes/Categoria: 7; REV-04A Pedidos/Reparto: 7; REV-04B Produccion/Entrega: 7; REV-03B Compras: 7; REV-06B.2 Recetas/Inventario: 6; REV-03A Compras: 6; REV-05 Finanzas: 8; REV-06A Comercial: 9; REV-01 Inventario: 1; REV-01 Insumos: 2.
- Inventario del manifiesto: 186 entradas (main 71, rama propuesta 115); no contiene tokens ni datos reales de negocio.
- **Anomalía editorial registrada:** la matriz global nombra operación UC-50 como `Contrato`; el archivo del contrato correspondiente contiene la firma `registrarInsumo(...)`. En la matriz B0 se usa `registrarInsumo` identificada en la fuente y se conserva el hallazgo para corrección editorial en PR de revisión, **sin modificar la matriz original**.

## Regla operativa para agentes

1. Leer `AGENTS.md`, plan rector, B0 y este inventario, después Fase 4 y RD posterior aplicable.
2. Para un CU, buscar fila en `B0_MATRIZ_64_CU_67_OPERACIONES.csv`; abrir **rutas exactas** en el commit indicado; contrastar firma y reglas con la ficha Real/Extendido.
3. Si la fuente está en `propuestos/` y no está fusionada, usarla para **preparar arquitectura y detectar conflictos**, no como autorización para modificar negocio, DB, RBAC o codebase.
4. Registrar resultados de cotejo, permisos y operaciones en nueva PR de integración; el integrador humano aprueba/cierra G0. No sobreescribir `main` ni el diagrama de CU rechazado.
