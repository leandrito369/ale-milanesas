# REV-06B — Dictamen de validación funcional de los 13 contratos restantes

**Proyecto:** Sistema de Gestión para Ale Milanesas · **Corte:** 29/10/2026.  
**Rama:** `revision/rev06b-contratos-restantes-2026-10-29` (apilada sobre PR #16).  
**Autoridad:** [CASOS_DE_USO_64_TRES_NIVELES (Google Doc)](https://docs.google.com/document/d/1BMF2Yfsh2ki353fU2dS5eZtIsYrOntpkjjAzulNy1uY/edit), cotejado en niveles Alto Nivel, Extendido y Real, y [Diccionario MR-5/MR-6 de 60 tablas](../../../05-modelo-relacional/Diccionario_Explicativo_60_Tablas_MR5_MR6_26-10-2026.md). Rigen también RD-RP007-002, RD-F04-003/006/007, RD-RP022-001 y RD-F08-001.  
**Entradas:** [13 contratos originalmente propuestos](./originales/CONTRATOS_REV06B_PROPUESTA_RECIBIDA_2026-10-29.md) y [13 contratos corregidos](./propuestos/CONTRATOS_REV06B_TRECE_CORREGIDOS.md). Se conservó la propuesta original sin sustituirla.

## 1. Dictamen y alcance

**Resultado:** **13/13 contratos revisados y corregidos según Fase 4 y MR-5/MR-6**; **13/13** con nueve apartados. Sumados a los **54 contratos de REV-01 a REV-06A** revisados en PR #16, existen **67 contratos para los 64 CU vigentes**, porque UC-03, UC-07 y UC-29 cuentan con dos operaciones públicas independientes cada uno.

**Límite expreso:** REV-06B **no contiene DSS/DS específicos publicados**. Por tanto, la **homologación de firmas DSS ↔ DS ↔ Contrato se conserva como 54/54 para las operaciones de los lotes anteriores**, pero **no está verificada para las 13 nuevas operaciones REV-06B**. Las firmas de REV-06B y los DTO son **propuestas de interfaz**, no API implementada ni hecho UML certificado. La inspección gráfica de los diagramas existentes está cerrada por el responsable y no se reabre.

## 2. Matriz de contratos REV-06B

| CU | Operación pública propuesta | Resultado Fase 4 / MR-5/MR-6 |
|---|---|---|
| UC-02 | `registrarCliente` | Corregida validación de duplicado exacto, Cliente inactivo, coincidencias parciales y mapeo de identidad/domicilio a columnas reales |
| UC-33 | `buscarCliente` | Conformidad de lectura; nombre presentado como dato lógico de `nombres`/`apellidos`, acceso Admin/Vendedor RD-RP007-002 |
| UC-32 | `modificarCliente` | Actor Vendedor de Fase 4; OTP pendiente invalidado cuando cambia teléfono sin revocar sesiones ONLINE activas |
| UC-38 | `cambiarEstadoCliente` | Administrador; actualización con registro de `HISTORIAL_ESTADO_CLIENTE` real, conservación de deudas/Pedidos |
| UC-57 | `configurarPoliticaCategoriaComercial` | Reconstruida firma con dos ajustes; `POLITICA_CATEGORIA_COMERCIAL` + exactamente 2 `AJUSTE_POLITICA_CATEGORIA`; A1–A6, transacción atómica |
| UC-15 | `evaluarYActualizarCategoriaComercial` | FIFO de deuda confirmada; mora solo si antigüedad supera tolerancia; sin inventar `«include»` desde UC-26/49 |
| UC-16 | `aplicarAjusteComercialSegunCategoria` | Ajuste de tabla hija, base de INTERNO distinta de ONLINE posterior a mejor Promoción, preservación histórica |
| UC-36 | `buscarInsumo` | Administrador y Producción en acceso directo/contextual conforme RD-RP007-002 |
| UC-10 | `configurarRecetaProducto` | `RECETA`, `VERSION_RECETA` y `DETALLE_VERSION_RECETA` con claves compuestas y `codigoUnidadCantidad` real |
| UC-31 | `configurarParametrosReposicionInsumo` | Solo Responsable de Producción; sin rondas retroactivas ni cierre/cancelación de episodios existentes por configuración |
| UC-52 | `cambiarEstadoInsumo` | Conservado sin corrección semántica necesaria; actor Administrador, estado lógico sin pérdida de historial |
| UC-09 | `consultarStock` | Solo Responsable de Producción; REVENTA separado de INSUMO, cantidades cero visibles y filtros aplicables |
| UC-64 | `consultarMovimientosInventario` | Consulta histórica separada y de solo lectura, con filtrado de costos y alcance por rol |

## 3. Hallazgos principales y decisiones de corrección

| ID | Riesgo inicial | Resolución |
|---|---|---|
| **R6B-01 — Alta** | UC-57 trataba `porcentajeDescuentoCumplidor` y `porcentajeRecargoMora` como columnas de `POLITICA_CATEGORIA_COMERCIAL` que **no existen** | Firma conceptual revisada; política con tolerancia/vigencia/registro y **dos filas reales de `AJUSTE_POLITICA_CATEGORIA`** con tipo/porcentaje; no se añaden columnas ni `numeroVersion` físico |
| **R6B-02 — Alta** | UC-31 añadía Administrador como actor y cerraba `EpisodioFaltante` por mero cambio de parámetros | Actor exclusivo Producción; las actualizaciones son prospectivas, sin cierre de Episodio ni reactivación de reposición automática retroactiva |
| **R6B-03 — Media** | UC-09 añadía Administrador al permiso de consulta y omitía visibilidad del stock cero | Actor exclusivo Producción; stock cero mostrado; filtros de umbral solo INSUMO |
| **R6B-04 — Alta** | UC-38 omitía la creación del evento histórico pese a existir `HISTORIAL_ESTADO_CLIENTE` | Agregada fila individual con clave `idCliente+numeroCambio`, fecha, estado anterior/nuevo, motivo e id del Administrador |
| **R6B-05 — Media** | UC-02 trataba `nombreNormalizado` como columna física y exigía `zona` pese a ser opcional | Se distingue normalización calculada de almacenamiento real, domicilio atómico y coincidencia exacta/partial; alta de Cliente INACTIVO no se duplica |
| **R6B-06 — Alta** | UC-32 permitía Administrador por inferencia y no distinguía sesiones activas de desafíos OTP pendientes | Fase 4 exige Vendedor autorizado; actualización de teléfono invalida OTP pendientes **sin revocar sesiones ya activas** |
| **R6B-07 — Media** | UC-16 no distinguía explícitamente la fuente del ajuste ni el subtotal por canal | Se remite a `AJUSTE_POLITICA_CATEGORIA`, INTERNO usa subtotal base, ONLINE usa subtotal posterior a Promoción elegible (RD-RP023-001) |
| **R6B-08 — Alta** | UC-15 declaraba relaciones `«include»` desde UC-26 y UC-49 no aprobadas | Se diferencia la ejecución comercial de reevaluaciones de una **relación UML**; se conserva `UC-16 «include» UC-15` |
| **R6B-09 — Media** | Contratos originales asignaban OBJEs/RFs de otros CU (p.ej. UC-02/33/32/38 y UC-16) | Los 13 apartados de referencias cruzadas se contrastaron contra el nivel Extendido y se corrigieron los discrepantes |
| **R6B-10 — Media** | UC-10 omitía explicitación de clave compuesta y unidad real de cantidad del Detalle | Se explicitan `VERSION_RECETA(idReceta,numeroVersion)`, `DETALLE_VERSION_RECETA(idReceta,numeroVersion,idInsumo)` y `codigoUnidadCantidad` |

**No se alteraron las firmas de las 54 operaciones anteriormente homologadas**, ni se modificaron documentos maestros, SQL, diagramas ni `main`. La propuesta original permanece conservada.

## 4. QA verificable al 29/10/2026

| Prueba | Resultado | Observación |
|---|---:|---|
| CU del maestro con Alto/Extendido/Real | **64/64** | 192 fichas |
| Contratos documentales existentes tras incorporar REV-06B | **67/67** | 54 anteriores + 13 nuevos |
| CU distintos con al menos un contrato | **64/64** | Sin huecos UC-01…UC-64 |
| Contratos con nueve secciones en orden y firma explícita | **67/67** | Cotejo del Markdown publicado |
| Repeticiones esperadas (dos operaciones por CU) | **3 CU** | UC-03, UC-07 y UC-29 |
| Homologación DSS/DS/Contrato del material REV-01 a REV-06A | **54/54, constatada en PR #16** | Heredada sin reabrir diagramas |
| Homologación DSS/DS/Contrato de las 13 nuevas firmas | **No verificable todavía** | No existen DSS/DS REV-06B publicados |
| Pruebas funcionales de persistencia, autorización, concurrencia y cálculo | **No realizadas** | Fuera de este cierre documental |

## 5. Dictamen de cierre del apartado contractual

**Conforme para cierre de la cobertura documental de contratos de los 64 CU**, con 67 operaciones contractuales descritas y trazables a sus fichas de tres niveles. Se corrigen discrepancias demostrables y no se añaden tablas ni columnas.

**No confundir cierre de cobertura contractual con certificación de los 67 tríos DSS/DS/Contrato**: únicamente 54 firmas tienen cotejo triple anterior. Las 13 nuevas quedan listas para su futura homologación cuando exista el diseño correspondiente; no se abrirán ni modificarán diagramas previamente inspeccionados sin decisión expresa. No fusionar PR ni editar el documento maestro automáticamente.


## 6. Adenda de homologación triple — REV-06B.1 (29/10/2026)

El dictamen de este archivo es el **corte inicial de cobertura de 13 contratos**, previo a la entrega/revisión de diagramas específicos. Con posterioridad se recibieron DSS y DS del sublote **REV-06B.1** y se corrigieron sus desviaciones respecto de Fase 4, el diccionario y los contratos aquí referidos.

La [auditoría M-0 a M-7 de REV-06B.1](../REV06B1_CLIENTES_CATEGORIA/REV06B1_AUDITORIA_TRANSVERSAL_Y_HOMOLOGACION_2026-10-29.md) confirmó la coincidencia nominal de las **7 firmas** de UC-02, UC-33, UC-32, UC-38, UC-57, UC-15 y UC-16 en DSS, DS y Contrato corregidos. No altera los 13 contratos de este archivo. La trazabilidad global pasó de **54/67 a 61/67**, quedando pendientes los seis CU de REV-06B.2 y el control H01/H02 de UC-42. No se integra ni ejecuta automáticamente el DDL o el Word.
