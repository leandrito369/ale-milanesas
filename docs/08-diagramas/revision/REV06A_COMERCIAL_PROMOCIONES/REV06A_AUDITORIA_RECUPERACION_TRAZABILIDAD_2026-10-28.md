# REV-06A — Acta de recuperación, auditoría selectiva y matriz de trazabilidad

**Fecha:** 28/10/2026. **Proyecto:** Sistema de Gestión para Ale Milanesas.  
**Estado:** propuesta documental reconstruida con QA estático, **no** aceptación académica, ni implementación, ni prueba visual de Draw.io.  
**Rama:** `revision/rev06a-comercial-promociones-2026-10-28`, fundada sobre commit `bdcf26d1f91d` de REV-05 (PR #14). **No alterar `main` ni fusionar sin autorización.**

## M-0 — Fuentes y precedencia

- **Base funcional declarada:** 64 casos de uso consecutivos, tres niveles, Word Fase 4 externo al árbol de esta rama. La propuesta original de Gemini remite a ese Word, **pero este acta no certifica un cotejo literal completo** de sus nueve fichas.
- **Decisiones verificadas directamente en la rama de GitHub:** [RD-RP023-001](../../../01-gobierno/RD_RP023_001_PROMOCIONES_SIMULTANEAS_2026-10-27.md), [RD-RP007-002](../../../01-gobierno/RD_RP007_002_PERMISOS_BUSQUEDAS_2026-10-27.md), [RD-RP018-001](../../../01-gobierno/RD_RP018_001_PRIMER_PRECIO_PRODUCTO_2026-10-27.md), [RD-01](../../../01-gobierno/RD_01_REGISTRO_DECISIONES_v1.1_2026-10-25.md).
- **Modelo físico de contraste:** [Diccionario explicativo MR-5/MR-6 de 60 tablas](../../../05-modelo-relacional/Diccionario_Explicativo_60_Tablas_MR5_MR6_26-10-2026.md), especialmente PRODUCTO, PRECIO_PRODUCTO, AUDITORIA_PRECIO, PROMOCION, PROMOCION_PRODUCTO, DESTINATARIO_PROMOCION e INTENTO_COMUNICACION.
- **Relaciones de búsqueda citadas en el Lote 6A:** UC-47, UC-48, UC-19, UC-20 y UC-24 «include» UC-35. No agregar nuevos vínculos ni modificar el diagrama general de CU rechazado. UC-35 es directo/contextual para Administrador/Vendedor, no Producción.

## M-1 / M-2 — Inventario y reconstrucción verificable

El usuario aportó `LOTE 6.md`, cuyo contenido se preservó íntegro en [`originales/LOTE6A_GEMINI_RECIBIDO_2026-10-28.md`](./originales/LOTE6A_GEMINI_RECIBIDO_2026-10-28.md).

**Disponibilidad real del paquete recibido:** informe inicial de Gemini, DSS completo de **dos páginas**, DS de **cinco páginas completas y comienzo truncado de UC-20 (sexta página)**, **cero contratos de operación completos**. Por tanto, la declaración original de “9 DS + 9 contratos” no constituía evidencia del material efectivamente entregado.

**Artefactos reconstruidos:**
1. [DSS corregido](./propuestos/DSS_REV06A_CORREGIDO.drawio.xml), dos páginas recuperadas del original sin reescritura funcional masiva.
2. [DS completo corregido](./propuestos/DS_REV06A_COMPLETO_CORREGIDO.drawio.xml), nueve páginas: las cinco primeras recuperadas con correcciones puntuales y páginas UC-20, UC-24, UC-59 y UC-60 reconstruidas documentalmente.
3. [Nueve contratos independientes](./propuestos/CONTRATOS_REV06A_NUEVE_OPERACIONES.md), cada uno con Nombre, Responsabilidades, Tipo, Referencias cruzadas, Notas, Excepciones, Salida, Precondiciones y Postcondiciones.

**Nota de procedencia:** las nuevas páginas UC-20/24/59/60 y los contratos se redactaron como **reconstrucción del asistente**, no se atribuyen falsamente a Gemini ni a validación humana.

## M-3 — Matriz de trazabilidad vertical

| CU | Operación pública | DSS | DS | Contrato | Regla clave |
|---|---|---|---|---|---|
| UC-35 | `buscarProducto` | Pág. 1 | Pág. 1 | N.º 1 | RBAC Administrador/Vendedor; RD-RP007-002 |
| UC-30 | `gestionarProducto` | Pág. 1 | Pág. 2 | N.º 2 | Alta sin precio inicial, RD-RP018-001 |
| UC-47 | `modificarProducto` | Pág. 1 | Pág. 3 | N.º 3 | Bloqueo de cambio tipo/unidad con historia |
| UC-48 | `cambiarEstadoProducto` | Pág. 1 | Pág. 4 | N.º 4 | No cancelar Pedidos PENDIENTE |
| UC-19 | `actualizarPrecioVigente` | Pág. 1 | Pág. 5 | N.º 5 | Vigencias excluyentes y auditoría |
| UC-20 | `consultarHistorialPrecios` | Pág. 1 | Pág. 6 **reconstruida** | N.º 6 | Solo lectura PrecioProducto/AuditoriaPrecio |
| UC-24 | `crearYComunicarPromocion` | Pág. 2 | Pág. 7 **reconstruida** | N.º 7 | Superposición sin acumulación, mensajería auditada |
| UC-59 | `consultarPromociones` | Pág. 2 | Pág. 8 **reconstruida** | N.º 8 | Estados F08 e historial de intentos |
| UC-60 | `desactivarPromocion` | Pág. 2 | Pág. 9 **reconstruida** | N.º 9 | Conservación histórica y bloqueo de usos futuros |

**QA posterior a publicación en GitHub:** 9 firmas públicas coincidentes entre DSS, DS y contratos (normalizando espacios y entidades XML); 9 contratos con nueve apartados; 2 páginas DSS y 9 páginas DS sin `mxCell.id` duplicados por página.

## M-4 / M-5 — Discrepancias y correcciones de contenido

| Hallazgo | Autoridad / evidencia | Corrección aplicada | Estado |
|---|---|---|---|
| **R6A-01 — Alto** | Gemini equiparaba *mayor beneficio económico* y *mayor porcentajeDescuento*. RD-RP023-001 exige beneficio económico de promociones elegibles y no aprueba fórmula nueva | Contrato UC-24 y notas de DS distinguen el criterio y ubican selección en UC-21. DSS conserva referencia a “mayor beneficio elegible”. | Corregido documentalmente; algoritmo concreto pendiente |
| **R6A-02 — Alto** | Gemini reunía `PrecioProducto` y `AuditoriaPrecio` en una sola línea de vida UC-19 | Separadas instancias y mensajes de creación/auditoría en la página DS UC-19 | Corregido estáticamente |
| **R6A-03 — Alto** | El DS UC-19 cerraba el precio previo **antes** de la guarda de validación; la rama de rechazo afirmaba no alterarlo | Se sustituyó esa operación inicial por verificación sin mutación; el cierre efectivo se ubica en la rama válida, junto al alta y auditoría transaccionales | Corregido documentalmente; prueba de transacción pendiente |
| **R6A-04 — Medio** | UC-30 usaba `nombreNormalizado` en búsqueda antes de indicar su obtención | Mensaje de búsqueda usa `normalizar(nombre)`; unicidad de activos/inactivos preservada | Corregido |
| **R6A-05 — Alto** | Fuente adjunta termina en mitad del DS UC-20 y carece de las páginas UC-24/59/60 y nueve contratos | Reconstrucción conservadora de cuatro páginas y nueve contratos | Completado como propuesta nueva |
| **R6A-06 — Medio (actualizado)** | El contrato MR-5 S-05 y su parche F08 especifican aristas admitidas, incluida BORRADOR/ACTIVA/PAUSADA→CANCELADA; PAUSADA→ACTIVA prohibida | UC-60 propone CANCELADA como único resultado de baja lógica administrativa definitiva, sin nuevos estados ni tablas, con revalidación transaccional | **Diseño especificado; ratificación funcional obtenida posteriormente en RD-F08-001 (29/10/2026)** |
| **R6A-07 — Medio** | Riesgo de atribuir permisos UC-35 a Responsable de Producción | Se mantiene RBAC expreso Admin/Vendedor y ámbito contextual (RD-RP007-002) | Documentado |
| **R6A-08 — Medio** | Riesgo de tratar Producto nuevo como comercializable sin precio | UC-30 y contrato distinguen alta y primera vigencia mediante UC-19 (RD-RP018-001) | Documentado |

**MR-5/MR-6:** no se agregan `HISTORIAL_ESTADO_PRODUCTO`, `CAMBIO_ESTADO_PROMOCION`, `PRODUCTO_PROMOCION` ni `INTENTO_COMUNICACION_PROMOCION`. Se usan las tablas reales y se conservan PK/FK vigentes. El código y el DDL permanecen intactos.

## M-6 — Visibilidad UML, responsabilidades y zonas por verificar

- UC-35, UC-20, UC-59: las consultas de repositorio/catálogo se modelan desde controladores por **visibilidad por atributo**; sin cambios de estado.
- UC-30, UC-24, UC-19: objetos creados reciben visibilidad por **creación local**; se diferencia la instancia de negocio de sus asociaciones, eventos y colaboradores.
- UC-47, UC-48, UC-60: el controlador obtiene el objeto existente de la búsqueda o consulta; modificación por **variable local**. Revalidación al confirmar evita utilizar una selección obsoleta.
- UC-24: comunicación externa representada por `:AdaptadorMensajeria`, mientras `Promocion`, `PromocionProducto`, `DestinatarioPromocion` e `IntentoComunicacion` son líneas de vida distintas. La cantidad de intentos, resultados y claves de idempotencia requiere prueba de servicio.
- La visibilidad de Larman **no está certificada mensaje por mensaje** sin cotejo con diagrama de clases y especificación Fase 4, y los nuevos diagramas requieren inspección gráfica de conectores, legibilidad y guardas.

## M-7 — Puertas de aceptación

| Verificación | Resultado | Alcance |
|---|---|---|
| DSS ↔ DS ↔ contratos, nombre + orden + tipo/opcionalidad de parámetros | **9/9** | Estático |
| Contratos individuales con nueve apartados | **9/9** | Estático |
| Páginas XML: 2 DSS + 9 DS | **11/11** | Recuento estructural |
| Duplicación de IDs `mxCell` dentro de página | **0/11** | Estático |
| Escáner de elementos/entidades XML (pila de etiquetas y ampersands ilegales) | Sin anomalías detectadas | **No** parser XML completo ni round-trip Draw.io |
| Cotejo literal de 27 fichas (9 CU × 3 niveles) en Word Fase 4 | **Completado posteriormente** | Ver acta REV06A_COTEJO_WORD_64_CU_Y_CONDICION_INTEGRACION; no implica certificación gráfica |
| Verificación gráfica Draw.io de 11 páginas | **Pendiente** | Abrir–guardar–reabrir |
| Estados F08 en detalle y transición terminal UC-60 | **F08 revisado posteriormente** | CANCELADA es baja definitiva; decisión ratificada posteriormente en RD-F08-001 el 29/10/2026 |
| Pruebas SQL, concurrencia, promoción elegible y mensajería | **Pendiente** | No software implementado |

## Dictamen

**REV-06A queda reconstruida como propuesta documental revisable.** Se preservó el original incompleto, se completaron los cuatro DS faltantes y nueve contratos, y se verificó coherencia de firmas y estructura estática. El conjunto **no está autorizado para fusión ni declarado aceptado académicamente**.

**No modificar el Word maestro, el DDL, el diagrama general de casos de uso ni el repositorio `main` sin decisión expresa.**

## Adenda de cierre de cotejo 28/10/2026

La fuente [CASOS_DE_USO_64_TRES_NIVELES](https://docs.google.com/document/d/1BMF2Yfsh2ki353fU2dS5eZtIsYrOntpkjjAzulNy1uY/edit) fue inspeccionada después de esta primera auditoría; el detalle de las correcciones y reservas está en [REV06A_COTEJO_WORD_64_CU_Y_CONDICION_INTEGRACION_2026-10-28.md](./REV06A_COTEJO_WORD_64_CU_Y_CONDICION_INTEGRACION_2026-10-28.md). Asimismo, F08 del [MR5_PATCH_NO_EJECUTADO.sql](../../../05-modelo-relacional/sql/MR5_PATCH_NO_EJECUTADO.sql) confirma las aristas BORRADOR/ACTIVA/PAUSADA→CANCELADA y prohíbe PAUSADA→ACTIVA. La baja definitiva de UC-60 a **CANCELADA** fue **ratificada funcionalmente en RD-F08-001 el 29/10/2026**. No se cambia el SQL ni se habilita reactivación. Los originales conservan su estado histórico.

Para inspección se publicó [Índice de diagramas y contratos REV-01 a REV-06A](../INDICE_INSPECCION_DIAGRAMAS_CONTRATOS_REV01_A_REV06A_2026-10-28.md).


## Adenda de ratificación de UC-60 — 29/10/2026

La reserva de destino único de UC-60 fue **resuelta mediante ratificación expresa del responsable del proyecto**. La decisión [RD-F08-001](../../../01-gobierno/RD_F08_001_UC60_BAJA_DEFINITIVA_PROMOCION_2026-10-29.md) fija `PROMOCION.estado = CANCELADA` desde `BORRADOR`, `ACTIVA` o `PAUSADA`; estados `FINALIZADA` y `CANCELADA` no admiten nueva baja; `PAUSADA→ACTIVA` permanece prohibida. Este registro actualiza **únicamente la situación funcional de la reserva**; no anula otros requisitos de inspección, QA de implementación ni los hallazgos originales del 28/10. No se tocaron los diagramas.
