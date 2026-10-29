# RD-B0-REPOS-01 — Separación del repositorio de análisis y del futuro repositorio de implementación

**Fecha:** 29/10/2026  
**Autoridad:** indicación expresa del responsable del proyecto al ratificar ADR.  
**Estado:** **APROBADA COMO POLÍTICA DE TRABAJO**.  
**Repositorio actual:** `leandrito369/ale-milanesas` — **análisis, dominio, requisitos, casos de uso, DSS/DS, contratos, RD/RP/CR, MR, trazabilidad, planes y evidencia documental**.  
**Repositorio de implementación:** **AÚN NO CREADO/NO INFORMADO**; su nombre y URL **no se suponen**. Su alta corresponde **exclusivamente al responsable del proyecto**.

## Regla de espera

**Hasta que el responsable confirme el alta y suministre el enlace/identificador del nuevo repositorio: NO crear repositorio, NO generar scaffold, NO subir código de aplicación o migraciones de backend al repositorio documental, NO ejecutar CI de implementación como si existiera, NO desplegar.** Se puede continuar **trabajo documental y de revisión de G0** en este repositorio, incluida la preparación de plantillas y especificaciones, sin cruzar esa frontera.

## Qué mantiene cada repositorio

| Fuente de verdad: análisis/diseño (actual) | Repositorio futuro: implementación y evidencia operativa |
|---|---|
| Fase 4: 64 CU tres niveles; DSS/DS, contratos y decisiones funcionales | Código fuente backend/web/Android; dependencias; estructura de 7 módulos |
| RD/RP/CR y ADR de arquitectura; matrices RBAC y proyecciones; reglas BC-09 | Servicios, repositorios, controladores, DTO/endpoints reales, adaptadores y seguridad ejecutable |
| MR-3/MR-5/MR-6 documentales e históricos; diseño físico de referencia | Migraciones de aplicación **derivadas/versionadas** con trazabilidad al MR y cambios aprobados por CR |
| Plan rector B0–B10, backlog y criterios de aceptación por CU | Tests unitarios/integración/E2E/concurrencia/BC-06, CI de build y ejecución, resultados/logs reproducibles |
| Manifiesto de fuentes/commit canónico y decisiones de cambio | `README` de instalación, `AGENTS.md` de implementación, `docs/` técnicos y enlaces a versiones inmutables de fuentes |

**No copiar/editar silenciosamente fuentes normativas** al repositorio de código: usar enlaces a commits inmutables, identificadores RD/ADR y manifest de procedencia. Si se necesita snapshot vendorizado, abrir decisión de duplicación con fuente/versión/hash, y actualizarlo solo por cambio de línea base.

## Reglas de enlace cruzado

1. Todo trabajo de implementación referencia el **repositorio actual y su commit/tags de G0**, CU + operación, contrato, DS/DSS, RBAC y proyección ratificada y (si corresponde) CR.
2. Ningún agente puede «actualizar requisitos» por modificar código. La modificación funcional nace como **CR/RD en análisis**, se propaga a contratos y solo entonces al repositorio de implementación mediante PR.
3. Una corrección técnica sin impacto de negocio se documenta con ADR/Issue en el repositorio de código y enlace de vuelta si afecta el contrato de arquitectura.
4. Un informe de QA vincula `commit código + versión contrato + escenario + resultado + entorno`; los fallos se registran, no se reemplazan por una estimación.
5. **No hay repositorio nuevo que usar hasta que el responsable lo cree.** Las herramientas Antigravity/OpenCode recibirán su acceso/configuración y `AGENTS.md` solo tras ese evento.

## Activación de implementación

**Evento habilitante 1:** aceptación expresa del responsable de que el repositorio nuevo existe, con URL y permisos/branch adecuados.  
**Evento habilitante 2:** Gate G0 formalmente aprobado sobre una versión canónica de diseño.  
**Solo después de ambos:** elaborar o incorporar allí el scaffold y documentación operativa de B1, en rama y PR, sin escribir código en `leandrito369/ale-milanesas`.

**Estado:** arquitectura aprobada parcialmente por ADR; **G0 pendiente** y repositorio de implementación **pendiente de alta por el usuario**.
