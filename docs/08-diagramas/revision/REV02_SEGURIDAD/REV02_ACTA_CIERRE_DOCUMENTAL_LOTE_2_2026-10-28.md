# REV-02 — Acta de cierre documental del Lote 2: Usuarios y Seguridad

**Corte:** 28/10/2026. **Repositorio:** `leandrito369/ale-milanesas`. **Rama:** `revision/rev02-usuarios-seguridad-2026-10-28` (parte de PR #10, que parte de PR #9).  
**Alcance:** UC-01, UC-17, UC-18, UC-53, UC-54, UC-55 y UC-56.  
**Dictamen:** **LOTE 2 CERRADO COMO CICLO DE CORRECCIÓN Y PREINTEGRACIÓN DOCUMENTAL; NO CERTIFICADO ACADÉMICAMENTE NI EN SERVICIOS.** La propuesta debe permanecer en PR de borrador, sin merge.

## 1. Evidencia de procedencia y publicación

Originales **preservados sin sustitución**:
- `originales/PAQUETE_GEMINI_REV02_2026-10-28.md` — paquete íntegro aportado por el responsable, con informe, dos XML y contratos.
- `originales/DSS_GEMINI_REV02.drawio.xml` — dos páginas.
- `originales/DS_GEMINI_REV02.drawio.xml` — siete páginas.

Propuestas corregidas:
- `propuestos/DSS_REV02_SEGURIDAD_CORREGIDO.drawio.xml` — dos páginas DSS.
- `propuestos/DS_REV02_SEGURIDAD_CORREGIDO.drawio.xml` — siete páginas DS.
- `propuestos/contratos/CONTRATO_UC{01,17,18,53,54,55,56}_REV02.md` — siete contratos separados, nueve secciones cada uno.
- `REV02_MATRIZ_TRAZABILIDAD_VISIBILIDAD_2026-10-28.md` — método M-0..M-7, hallazgos, mensajes, riesgos y trazabilidad.
- `REV02_ADENDA_PROPAGACION_WORD_64_CU_2026-10-28.md` — modificaciones funcionales posteriores a Fase 4.

Fuentes de mayor autoridad:
- Word Fase 4, `main:docs/04-casos-uso/CASOS_DE_USO_64_TRES_NIVELES.docx`, blob SHA `d3fa32360e0b0b8184b1bb1a3eb9ce52bc0fea11`, cotejado en pasajes relevantes de los siete CU.
- Decisiones RD-RP010-001 y RP-009/RD-RP009-001 del 27/10, seguimiento transversal, relaciones UML aprobadas.
- Diccionario MR-5/MR-6 de 60 tablas. **No se utilizó MR-3 histórico como si fuera la única última versión.**

## 2. Resultado de QA ejecutado sobre contenidos publicados en la rama

| Control ejecutado | Evidencia | Dictamen |
|---|---|---|
| Página DSS | **2 páginas** | PASÓ |
| Página DS | **7 páginas** | PASÓ |
| Integridad IDs de `mxCell` | DSS **30+39**; DS **33+42+35+25+26+36+29** elementos, todos IDs únicos **dentro de su página** | PASÓ |
| Etiquetas, anidamiento y forma XML | Analizador léxico propio de apertura/cierre de etiquetas y atributos: sin discrepancias conocidas | PASÓ control textual, **no parser de biblioteca externa** |
| Entidades XML | Ningún `&` inválido; `&#xa;` correctamente aceptado como entidad hexadecimal válida | PASÓ |
| Tablas fantasma | No hay referencias a `CAMBIO_CREDENCIAL_USUARIO` ni `HISTORIAL_ESTADO_USUARIO` en los XML corregidos | PASÓ |
| Firma pública principal DSS/DS/contrato | **7/7** nombres y parámetros idénticos tras normalizar espacios y `&lt;/&gt;` | PASÓ **internamente** |
| Contratos separados | **7/7** con nueve secciones numeradas | PASÓ |
| RP-009 | UC-55 bloquea deshabilitar Repartidor con Pedido `PENDIENTE` vigente; UC-43 primero | PASÓ trazabilidad textual |
| RP-010 | Restricción operativa para todo Usuario con indicador pendiente, UC-53 obligatorio, sin relación UML nueva | PASÓ trazabilidad textual |
| Alta UC-17 | Proveedor con credencial temporal obligatoria; no extender automáticamente a internos sin política explícita | CORREGIDO con reserva |
| UC-54 | Identidad comercial verificada además de Rol y vínculo | CORREGIDO textual |
| UC-55 sesiones | Iteración por `SesionUsuario` en alternativa de deshabilitación | CORREGIDO textual |

**Se ejecutó revisión estática sobre los XML descargados desde GitHub, no una inspección gráfica en app.diagrams.net ni una prueba de ejecución PostgreSQL/servicio.** La palabra «PASÓ» de arriba se circunscribe al procedimiento descrito y no implica certificación académica general.

## 3. Correcciones y decisiones tratadas

1. UC-17: se eliminó la obligación universal introducida por Gemini de `cambioCredencialPendiente=true` en todas las altas. Solo la credencial inicial temporal de PROVEEDOR está confirmada en la ficha Real; para internos, política pendiente.
2. UC-17: se separaron las líneas de vida `UsuarioRol`, `EventoAsignacionRol` y `UsuarioProveedor`; se muestran `loop` inicial y `opt` de vínculo PROVEEDOR.
3. UC-18: separación `EventoAsignacionRol` / `SesionUsuario`; revocación de sesiones bajo condición y `loop` explícito.
4. UC-55: la sesión iterada se representa como una instancia individual `sesionVigente`, no como una única instancia con identidad de una colección completa.
5. UC-56: el evento auxiliar de selección se refleja en DSS, DS y nota contractual sin abrir UC nuevo.
6. UC-54: verificación de identidad comercial incorporada a DSS, DS y contrato; método específico no inventado.
7. Visibilidad de Larman: los supuestos de asociación controlador→catálogo/Usuario→sesiones quedan clasificados como **no demostrados**, en lugar de certificarse por la etiqueta «por atributo».
8. RP-009 y RP-010 integradas como decisiones posteriores al Word y adenda específica, sin alterar la fuente original.
9. UC-01: sesiones restringidas por política de autorización en servidor conforme al indicador de Usuario; sin inventar columna de restricción en `SESION_USUARIO`.
10. Los siete contratos quedaron separados con reservas de alcance y pruebas; el paquete Gemini íntegro se preserva.

## 4. Reservas y puertas de certificación no superadas

| Código | Reserva | Criterio de levantamiento |
|---|---|---|
| **R-01** | Política de credencial inicial interna en UC-17 no especificada en las fuentes consultadas | RD expresa o referencia canónica; no fijar automáticamente `true` ni `false` sin fundamento |
| **R-02** | Firma UC-53 exige `credencialActual` en Gemini; el CU Real del Word no muestra necesidad universal con igual claridad | Resolver política de cambio normal vs. primer cambio de clave temporal; homologar solo tras evidencia |
| **R-03** | Visibilidad Larman de `:ControladorSeguridad→:CatalogoUsuarios` y `Usuario→SesionUsuario` no acreditada estructuralmente | Adjuntar diseño de clases/asociaciones o mecanismo de referencia legítimo y comprobar mensajes |
| **R-04** | F07: último administrador, mínimo un Rol, permisos y revocación completa sin pruebas concurrentes | SQL y tests de servicios con rollback, carreras y revocación; fuera del alcance de esta revisión |
| **R-05** | Draw.io no inspeccionado visualmente; sintaxis y geometría no certifican ausencia de solapes | Apertura, edición, guardado, reapertura, verificación de fragmentos y activaciones por página |
| **R-06** | Word Fase 4 conserva redacciones anteriores RP-009/RP-010 y no integra estas adendas | Propagación controlada a los 3 niveles, verificación académica/documental posterior |
| **R-07** | Contrato UC-56: selección auxiliar bajo CU-56 y alcance exacto según Real | Cotejo literal de su secuencia y permisos, especialmente contexto UC-54/UC-55 |

## 5. Estado final y criterio de integración

- **Sí cerrado:** entrega y auditoría estática del **lote documental REV-02**, con correcciones pertinentes respaldadas, versiones en GitHub y trazabilidad.
- **No cerrado:** conformidad académica final de DS/DSS, diseño de clases con visibilidad Larman demostrada, implementación y pruebas F07, propagación al Word.
- **No autorizado:** cambiar relaciones del diagrama de casos de uso rechazado, añadir columnas/tables nuevas, fusionar PR #9/#10 o fusionar el nuevo PR automáticamente.
- **Seguimiento:** las reservas R-01..R-07 permanecen **abiertas y explícitas**, aunque el lote de corrección se haya cerrado administrativamente.

El cierre documental **no convierte inferencias de Gemini en reglas aprobadas** y no declara el paquete «100 % sin errores» ni apto como versión académica definitiva sin los controles pendientes.
