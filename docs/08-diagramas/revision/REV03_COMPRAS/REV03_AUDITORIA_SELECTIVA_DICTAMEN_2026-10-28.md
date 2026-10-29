# REV-03 — Auditoría selectiva y criterio de adopción de Gemini (Lote 3A + 3B)

**Fecha:** 28/10/2026. **Estado:** CORRECCIÓN DOCUMENTAL ESTÁTICA COMPLETA; APROBACIÓN ACADÉMICA/IMPLEMENTACIÓN **NO CERTIFICADAS**.  
**Fuente original:** `originales/LOTE3_GEMINI_ORIGINAL_2026-10-28.md` (4.844 líneas) preservada íntegra. Cuatro XML originales y los dos documentos de contratos originales también conservados por separado; no se editó ninguna de las fuentes originales.  
**Rama:** `revision/rev03-compras-cotizaciones-2026-10-28`, desde PR #11; base del nuevo PR borrador.  
**Alcance:** 13 casos: REV03A UC-58, UC-44, UC-62, UC-63, UC-13, UC-12; REV03B UC-37, UC-11, UC-45, UC-46, UC-40, UC-39, UC-08.

## 1. Principio rector: no rehacer lo que ya es correcto

Se revisó el paquete completo y se adoptaron **sin modificación de reglas de negocio** las correcciones funcionales principales de Gemini:

- **RD-RP013-001:** pesos de criterios activos suman **100 %**, falta de datos se identifica como cotización incompleta (sin puntaje inventado), desempate por `ordenDesempate` y decisión humana ante empate persistente; **no** se emite Orden automáticamente.
- **RD-RP012-001:** plazo de respuesta tomado de **parámetro global configurable**, vencimiento de cada Solicitud congelado al crearla, sin presumir 48 horas y sin acoplar el parámetro a la firma de UC-58.
- **UC-44/13/63:** cadena lineal de rondas, recepción por invitación de Proveedor, única respuesta definitiva en plazo, sin exposición de ofertas ajenas.
- **UC-37/11/45/40/39:** búsqueda, alta y modificación comercial de Proveedor, consulta/cancelación de Orden con conservación de histórico; **sin intervenciones funcionales** en sus DS o contratos.
- **UC-08:** separación de inventarios INSUMO vs REVENTA, costo aplicable previo al movimiento y promedio móvil de REVENTA, conforme a RP-022.

El DSS REV03A se adoptó **idéntico al XML original de Gemini**, sin copia modificada. No se inventaron pesos por criterio, fórmula de normalización, duración del plazo ni estados persistentes nuevos.

## 2. Intervenciones estrictamente necesarias, con sustento

| Hallazgo | Origen y discrepancia comprobada | Intervención mínima | Evidencia de autoridad |
|---|---|---|---|
| **R3-01 (ALTA)** | Gemini afirma que `HISTORIAL_ESTADO_PROVEEDOR` no existe en el modelo y elimina su registro en UC-46 | Recuperar postcondición histórica de UC-46 y mensaje DS de registro; DSS informa persistencia de transición, sin alterar Órdenes abiertas | Diccionario **MR-5/MR-6, tabla 38**, PK `idProveedor, numeroCambio`, campos `estadoAnterior`, `estadoNuevo`, `fechaHoraCambio`, `idUsuarioAdministrador`, `motivo` |
| **R3-02 (ALTA)** | UC-08 no registraba unidad recibida ni factor congelado y usaba cantidad/costo recibido directamente sobre stock base | Agregar `codigoUnidadMedidaRecibida` a firma en DSS/DS/contrato; convertir a base y registrar `factorConversionAplicado`, costo unitario original y recepción | RD-RP022-001 reglas 1–4, 8–10 y MR-5/MR-6 **tabla 51 RECEPCION_COMPRA** (campos NOT NULL `codigoUnidadMedida`, `factorConversionAplicado`, `costoUnitarioReal`) |
| **R3-03 (ALTA)** | DS UC-08 crea `unaRecepcion` únicamente en operando INSUMO, pero el operando REVENTA le refiere sin crearla | Incorporar creación explícita de `unaRecepcionRev:RecepcionCompra` en operando REVENTA, separada de la creación de movimiento de REVENTA | MR-5/MR-6 tablas 51–52; RP-022 |
| **R3-04 (MEDIA)** | Contracto UC-08 menciona `CostoReventaHistorico` como si fuera estructura de costo reconocida | Sustituir referencia por `Producto.costoPromedioActualReventa` y `MovimientoStockReventa.costoPromedioResultante`, sin añadir tabla | Listado vigente de **60 tablas**, sin tabla `COSTO_REVENTA_HISTORICO`; RP-022 |
| **R3-05 (MEDIA)** | DS UC-58 mezclaba `PoliticaCompra` y `CriterioPoliticaCompra` en una línea de vida | Conservar la clase Política y mostrar creación separada de Criterio dentro de `loop`; sin cambiar el cálculo | Disciplina UML de instancia única; MR-5/MR-6 tablas 45–46 |
| **R3-06 (MEDIA)** | DS UC-12 agrupaba `PoliticaCompra` y `SolicitudCotizacion` en la misma línea de vida; `cerrarSinCompra` era ambiguo | Separar ambos objetos y redirigir `cerrarSinCompra` a `unaSolicitud`; `DecisionCompra` queda con tipo único | Responsabilidades expresadas en contratos UC-12 y entidades de las tablas 42, 45, 47 |
| **R3-07 (MEDIA)** | `ref UC-62` atribuía evaluación de ofertas a la búsqueda, y textos B rotulaban ambiguamente la dirección `extend` | Limitar UC-62 a localizar Solicitudes. Explicitar `UC-40 → UC-08` (extiende de forma condicional) | Matriz de relaciones UML aprobadas, 25/10, en Contexto Maestro |
| **R3-08 (MENOR)** | Contratos REV03A UC-13/UC-12 tenían estrellas `***` que envolvían irregularmente títulos, apartados y listas | Reparación de Markdown sin cambio semántico, recuperando nueve apartados por contrato | Integridad documental y legibilidad académica |

**No se corrigieron por simple gusto** formatos de fechas, nombres de controladores, DTO abstractos, agrupación de páginas DSS por actor ni detalles de notación que no tengan evidencia de error material. Los dos informes Gemini originales se mantienen sin alteraciones como fuente histórica.

## 3. Matriz de conformidad interna de artefactos

| Subconjunto | DSS elegido | DS elegido | Contratos elegidos | Estado |
|---|---|---|---|---|
| REV03A (6 UC) | `originales/DSS_REV03A_GEMINI.drawio.xml` (**intacto**) | `propuestos/DS_REV03A_CORREGIDO.drawio.xml` (solo delimitación de objetos UC-58/12) | `propuestos/CONTRATOS_REV03A_CORREGIDOS.md` (solo reparaciones de Markdown) | **6/6 firmas coincidentes**, seis contratos de 9 apartados |
| REV03B (7 UC) | `propuestos/DSS_REV03B_CORREGIDO.drawio.xml` | `propuestos/DS_REV03B_CORREGIDO.drawio.xml` | `propuestos/CONTRATOS_REV03B_CORREGIDOS.md` | **7/7 firmas coincidentes**, siete contratos de 9 apartados |

**QA ejecutado** sobre contenidos recuperados de GitHub:
- DSS REV03A: **2 páginas** (27 y 31 celdas).
- DS REV03A: **6 páginas** (28, 28, 20, 20, 24, 36 celdas).
- DSS REV03B: **2 páginas** (25 y 28 celdas).
- DS REV03B: **7 páginas** (20, 29, 25, 26, 20, 21, 44 celdas).
- **17/17 páginas** con identificadores `mxCell` únicos **por página** (los IDs raíz `0`/`1` pueden repetirse legalmente entre páginas).
- **13/13 firmas** (nombre y argumentos) DSS → DS → Nombre contractual idénticas tras normalizar espacios/escapes XML.
- **13/13 contratos** con 9 apartados numerados.
- Sin entidades XML inválidas y sin desajustes de anidamiento según comprobador textual; los **cuatro originales** pasaron además el analizador XML estricto `ElementTree` en el entorno local tras desescapar el Markdown. Los propuestos **no** se abrieron visualmente ni se sometieron a prueba de guardado/reapertura en Draw.io.

## 4. Reservas expresamente NO resueltas

**S1 — UC-12 NO_COMPRAR y `DECISION_COMPRA`.** El diccionario MR-5/MR-6 define `DECISION_COMPRA` como resolución de comprar **o no comprar**. El contrato original de Gemini crea `DecisionCompra` explícitamente en COMPRAR, pero en NO_COMPRAR sólo actualiza Solicitud. Requiere cotejo de las fichas Real/Extendido y de la regla de auditoría; **no se impone una nueva postcondición por inferencia**.

**S2 — UC-08 firma académica y conversión.** El parámetro explícito `codigoUnidadMedidaRecibida` es una adecuación de diseño **necesaria para sostener RP-022**, pero su formulación exacta y DTO deben armonizarse con la ficha Real del Word. El factor se calcula/valida y conserva; **no se introduce como campo inventado por el actor**. No se hizo una prueba de conversiones con servicios.

**S3 — Visibilidad de Larman.** Los mensajes controlador→catálogo/repositorio rotulados «por atributo» en Gemini no se certifican sin atributos/asociaciones del diseño de clases. La propuesta no agrega relaciones artificiales para simular demostración.

**S4 — Precisión económica y concurrencia.** Normalización y redondeo de cotizaciones RD-RP013; precisión/costos unitarios RP-022; bloqueos concurrentes F09, cadena de solicitudes, doble respuesta y recepción parcial requieren pruebas reales, no ejecutadas.

**S5 — Draw.io y representación UML.** No se ejecutó inspección gráfica humana, redimensionamiento ni round-trip de los 17 diagramas. Las nuevas líneas de vida/secuencias pueden requerir ajuste visual en la herramienta antes de certificar. 

**S6 — Cotejo total con Fase 4.** Se verificaron el catálogo vigente de 64 CU, las RD ratificadas y MR-5/MR-6; **no se certifica comparación literal exhaustiva de las 39 fichas (13 CU x 3 niveles)** en el DOCX maestro durante esta revisión. No presentar «100 % fidelidad académica» sin esa evidencia.

**S7 — Dirección UML de extensión.** La relación vigente documentada es `UC-40 → UC-08` como `«extend»` condicional; no cambiar el diagrama de CU sin la revisión específica del legado aprobado. El texto de las propuestas REV03B evita invertir ese sentido.

## 5. Dictamen del lote

**REV-03 corregido y cerrado como trabajo documental estático, con adopción mayoritaria de Gemini.** No se declara validado académicamente, ni se altera `main`, ni se ejecutan servicios/DDL, ni se fusionan los PR encadenados. Las reservas S1–S7 quedan abiertas y trazables.

**Método de selección:** solo modificar si (a) hay contradicción comprobable con RD/modelo vigente, (b) hay error UML material de identidad/responsabilidad o (c) la firma/contrato no puede conservar integralidad; lo demás se preserva.
