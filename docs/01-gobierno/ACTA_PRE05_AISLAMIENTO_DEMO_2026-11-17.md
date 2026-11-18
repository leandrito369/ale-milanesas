# ACTA PRE05 — Aislamiento de la Demo

**Identificador:** ACTA_PRE05_AISLAMIENTO_DEMO_2026-11-17  
**Fecha del corte:** 17/11/2026  
**Repositorios:** leandrito369/ale-milanesas, leandrito369/ale-milanesas-app  
**Estado:** **PRE-05 CONFORME para el alcance evaluado**. Documento propuesto en PR DRAFT; no autoriza merge, despliegue ni cambios de infraestructura.

## 1. Objeto y alcance

Registrar la conclusión de que **no se identificó una ruta concreta** por la que una integración exclusivamente documental de `ale-milanesas/main` afecte la Demo del proyecto. El dictamen cubre el aislamiento frente a integraciones documentales de gobierno, **no** constituye autorización general de despliegue, acceso a la Demo, fusión de PR ni habilitación de G-FIS, G-DEV o V4. No certifica una imposibilidad absoluta ante integraciones futuras no inventariadas.

## 2. Fuentes y SHAs consultados

| Fuente | SHA / referencia |
|---|---|
| app `main` al cierre de auditoría | `cc11611d1118f8a755aa3cb1df6bfd442ee13777` |
| app `main` en corte anterior | `26996e82fbbe264a797565cb4c53933b4e9c39b9` |
| gov `main` | `9076570ff3329864fe85c990bcc6f4ff7a63d6e5` |
| PR #65 G-CON | `c8efde5738c202e97cb1135b80656daf0c09570d`, OPEN/DRAFT |
| PR #66 archivo G-CON | `6c7e71649200e2707015172e6b4b7bac71d1364b`, OPEN/DRAFT |
| Informe | `DICTAMEN_PRE05_AISLAMIENTO_DEMO_2026-11-17` |
| Antecedentes | `OC-PRE05-01` y `OC-PRE05-02` |

La evidencia documental técnica y las declaraciones administrativas no reciben el mismo grado de verificación.

## 3. Inventario de automatismos

Se examinaron **34 workflows**: 31 en la aplicación y tres en gobierno (`b0-documental.yml`, `i1-rd-revision.yml` y `mr6-postgresql.yml`). La auditoría no identificó un workflow que despliegue el servicio de Demo desde cambios documentales de gobierno. La inexistencia de webhooks de repositorio se consigna **como declaración del responsable**, no como comprobación independiente vía API.

El workflow de gobierno `b0-documental.yml` limita su disparador `pull_request` a `docs/ESTADO_ACTUAL.md`, `docs/01-gobierno/b0/**`, `docs/08-diagramas/consolidacion-b0/**`, `tests/b0/**` y el propio workflow. Este archivo PRE-05 no coincide con esos filtros; que el check no se ejecute no equivale a fallo ni obliga a editar `ESTADO_ACTUAL.md`.

## 4. Comparación de SHAs de aplicación

El HEAD de la aplicación avanzó desde `26996e82…` hasta `cc11611d…`, incluyendo PR app #98 y #99 relacionados con navegación y sesión de la Demo. La comparación de los archivos `.github/workflows/*` entre ambos SHAs no arrojó modificaciones. No se detectó un automatismo nuevo en esos archivos.

## 5. Declaraciones del responsable — 17/11/2026

**DECLARACIÓN DEL RESPONSABLE** (no verificación independiente):

1. No existen webhooks configurados en ninguno de los dos repositorios.
2. Netlify figura como GitHub App instalada, pero no existe proyecto Ale Milanesas configurado en el dashboard; el responsable decidió no conectar repositorios ni utilizar Netlify.
3. La Demo G4 se ejecutó localmente con Spring Boot, PostgreSQL Docker y HTTPS en `127.0.0.1:8443`.
4. Según la evidencia final de G4, la ejecución temporal, los datos y los secretos fueron eliminados.
5. No existe instancia pública permanente ni despliegue productivo acreditado.
6. El despliegue sigue pausado bajo la Issue app #28.

## 6. Evidencia documental de contraste

- `ale-milanesas-app/docs/implementation/B5_B9_DEMO_EVIDENCIA_HTTPS_2026-11-16.md`: servidor Spring Boot HTTPS en loopback, JVM detenida, proyecto Docker desmontado y claves temporales retiradas; no se ejecutó una inspección del host a posteriori.
- `ale-milanesas-app/deploy/demo/compose.yaml`: PostgreSQL publicado solo en `127.0.0.1:55439` y datos temporales.
- `ale-milanesas-app/deploy/nginx/ale-milanesas.nginx.conf.template`: plantilla con `server_name @ALE_HOST@` y proxy interno a `127.0.0.1:8080`; una plantilla no acredita host externo efectivamente desplegado.
- `ale-milanesas-app/docs/implementation/B8_DEMO_G4_R01_ESTADO_SESION_WEB.md`: evidencia de pruebas de sesión web, sin certificación de servicio productivo.
- No se identificó, dentro del alcance documental inspeccionado, un pipeline conectado a Netlify u otro hosting de producción.

## 7. Riesgos residuales y controles de cambio

1. Webhooks no inspeccionados directamente mediante API por permisos insuficientes; su ausencia está declarada por el responsable.
2. Dashboard de Netlify no inspeccionado independientemente; falta de proyecto e intención de no utilizarlo declaradas por el responsable.
3. Teardown documentado, sin comprobación independiente del host de ejecución.
4. PR #66 conserva el **estado histórico anterior** «PRE-05 NO CERTIFICADO» y **ya incorporó**, mediante el commit documental `e923332096c40620fa4f88f34e76a5d0c2e9213f`, una actualización posterior al dictamen favorable, sin borrar ni falsificar la cronología. La revisión y autorización de integración de PR #66 permanecen independientes.
5. PR #98/#99 app: documentar referencia de autorización de B5/G4, sin presumir incumplimiento.
6. Ante cualquier cambio futuro en workflows, webhooks, GitHub Apps, hosting o entorno protegido, **revalidar PRE-05** antes de integrar documentos.

## 8. Dictamen

**PRE-05 CONFORME PARA EL ALCANCE EVALUADO**: no se ha identificado ruta concreta que permita afectar la Demo desde los automatismos revisados al integrar documentación en gobierno `main`. Esta conclusión considera explícitamente las declaraciones del responsable como evidencia administrativa y conserva las limitaciones indicadas.

**No autoriza:** fusión de PR, integración editorial, cambio de configuración, acceso a la Demo, despliegue, G-FIS, G-DEV, V4, CR-C/CR-F o modificación de G0, `source-lock`, RBAC o BC07.

## 9. Condiciones para integración documental posterior

- Revalidar PRE-01..07 y GC-10 propios de PR #65.
- Obtener autorización editorial **expresa y específica para cada PR**, incluida la presente y la #66.
- Verificar la actualización cronológica de PRE-05 **ya incorporada** en PR #66 y que continúe preservando el hecho histórico de que inicialmente no estaba certificado.
- Conservar la declaración de firma del responsable como declarativa, no firma digital certificada.
- Revalidar HEAD/base, diff, revisiones y checks **realmente aplicables**; no ejecutar workflows no exigidos ni sumar modificaciones a G0 para provocarlos.
- Mantener cerrados G-FIS, G-DEV, V4 y despliegue.
