# Preparación de traspaso al nuevo repositorio de implementación

**Fecha:** 29/10/2026  
**Estado:** **PLAN PREPARATORIO; NO EJECUTAR HASTA ALTA DEL REPOSITORIO POR EL RESPONSABLE Y G0 APROBADO**.  
**Fuente canónica:** `leandrito369/ale-milanesas`, especialmente [RD de arquitectura](../01-gobierno/b0/RD_B0_ADR_ARQUITECTURA_APROBADA_2026-10-29.md), [política de separación](../01-gobierno/b0/RD_B0_SEPARACION_REPOSITORIOS_2026-10-29.md), [Gate G0](../01-gobierno/b0/B0_INFORME_GATE_G0_PARA_APROBACION_2026-10-29.md) y [mapa 67 operaciones](../01-gobierno/b0/B0_MAPA_TECNICO_67_OPERACIONES_2026-10-29.csv).

## Antes del handoff

- [ ] Responsable crea el repositorio, indica URL exacta, visibilidad y acceso de colaboradores/agentes; **no inferir nombre**.
- [ ] Integrador revisa/fusiona las PR de documentos y ratifica el paquete de fuentes DSS/DS/contratos; registra commit/tag canónico de G0.
- [ ] Responsable aprueba Gate G0 y la priorización inicial; conservar CR-B0-F04-001 pendiente.
- [ ] Se establece relación de trazabilidad entre repositorios sin duplicar autoridad de requisitos.

## Archivos candidatos a crear **solo en el repositorio futuro**, después del desbloqueo

- `README.md`: propósito técnico, versiones y requisitos de instalación, vínculo a commit/tag del repositorio documental, comandos de build/test/arranque.
- `AGENTS.md`: orden de lectura de fuentes, prioridad de RD, prohibiciones y formato de PR para OpenCode/Antigravity y equivalentes.
- `docs/architecture/ADR-*.md`: detalles concretos de dependencias/CI/API/migraciones que no cambien las ADR de arquitectura ratificadas; código Java/Kotlin sin heredar decisiones no aprobadas.
- `docs/traceability/source-lock.json` o `.md`: `source_repo`, `source_commit`, `G0_tag`, `CU`, `operation`, `contract_path`, `DSS/DS_paths`, `RD_ids`, `MR_version` y `CR_id` pertinente. No inventar SHAs.
- `backend/`, `web/`, `android/` y `db/migration/`: estructura concreta **tras** revisión de ADR de build/capacidades de CI, sin asumirla creada aquí.
- `tests/` y CI: Testcontainers/BD efímera, pruebas de autenticación, CU y contratos con identificadores. BC-06: 18 casos aún `NO_EJECUTADO` hasta servicios reales.

## Protocolo para agentes cuando el repositorio esté disponible

1. Leer el nuevo `AGENTS.md` y el archivo `source-lock`, después las fuentes ratificadas en el repositorio documental.
2. Para cada Issue, pedir `WBS/iteración + CU/operación + contrato/DS/DSS + RBAC/BC07 + MR tabla/columna + aceptación`; primero plan de cambios y conflictos.
3. Implementar solo el segmento autorizado; rama propia, commit, PR, pruebas reales con logs y revisión independiente. **No** escribir archivos en el repositorio de análisis, excepto RP/CR/RD por flujo de gobierno.
4. Si contradice DS/contrato o requiere esquema nuevo, abrir RP/CR **aquí** y detener solo la parte afectada. La CR S-01/F04 sigue bloqueando diseño físico offline.
5. Cada release del código etiqueta su dependencia exacta respecto de un commit/tag de la línea base y refleja el resultado en matriz de trazabilidad, sin atribuir implementación a documentos académicos.

## No confundir con un hito ejecutado

No existe aún URL, repo, scaffold, código ni pipelines del nuevo repositorio. Este documento **no** crea el repositorio, no ejecuta migraciones ni concede permiso de despliegue. Es el material para activar el **B1** cuando las condiciones estén dadas.

---

## Actualización posterior de la condición de alta — 29/10/2026

**Repo creado y comprobado:** [leandrito369/ale-milanesas-app](https://github.com/leandrito369/ale-milanesas-app), `main` inicializado con README. El título histórico «pendiente» refiere al **handoff**, ya no al alta. **Escritura desde GitHub App bloqueada (403)** por selección de repositorios: [registro y configuración](../01-gobierno/b0/G0_ALTA_REPO_IMPLEMENTACION_2026-10-29.md).

Preparación de documentación de acceso de agentes para una PR en la app **tras G0 y permisos**:
[plantilla AGENTS](G0_PLANTILLA_AGENTS_REPO_APP_2026-10-29.md) y [plantilla source-lock](G0_PLANTILLA_SOURCE_LOCK_REPO_APP_2026-10-29.md). **No publicadas en app**; ningún código de aplicación se ha iniciado.

## Handoff habilitado por cierre posterior de G0 — 29/10/2026

La condición histórica de este documento ("G0 pendiente") quedó superada: [RD-B0-G0-001](../01-gobierno/b0/RD_B0_G0_001_CIERRE_LINEA_BASE_2026-10-29.md) aprueba G0 y fija las fuentes en `1263ffc17bd0eb7f3c69faaa9ff5ae556cf9de7e`. El repositorio `leandrito369/ale-milanesas-app` existe y el GitHub App tiene permiso de crear ramas. Corresponde publicar `AGENTS.md` y el source-lock en la app y, posteriormente, tareas B1 mediante PR separadas. **No** usar los SHAs históricos Draft como fuente más reciente; la matriz canónica reemplaza el borrador.
