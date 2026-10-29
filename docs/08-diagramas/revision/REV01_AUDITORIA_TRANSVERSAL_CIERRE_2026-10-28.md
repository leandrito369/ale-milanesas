# REV-01 — Auditoría transversal de cierre: UC-50 / UC-42 / UC-51

**Fecha:** 28/10/2026  
**Rama auditada:** `revision/rev01-uc50-insumos-2026-10-27`  
**PR:** #10 (DRAFT; base documental: PR #9)  
**Resultado:** **CIERRE NO APROBADO / OBSERVACIONES BLOQUEANTES**. Los tres casos tienen propuestas versionadas, pero no se certifica que formen un conjunto UML validado. No se modifica `main`, no se altera el diagrama de casos de uso rechazado y no se ejecutan pruebas de aplicación.

## 1. Metodología reproducible

**M-0 — Congelar el alcance y la autoridad:** fijar SHA/ruta del documento de comparación, PR/branch, fecha, catálogo UC-01..64, decisiones aprobadas RD-RP016-001, RD-RP017-001, RD-RP022-001 y RP-015. Separar fuente histórica Gemini, propuesta revisada y decisiones posteriores; no convertir inferencias en reglas aprobadas.

**M-1 — Proveniencia e integridad:** comprobar que por cada UC hay original de Gemini y propuesta diferenciados, y que el DSS por actor está identificado por operación; cotejar diferencias por celda `mxCell.id` y contrato. Dejar originales inmutables.

**M-2 — Sintaxis y estructura XML (puerta técnica):** contar páginas, elementos, IDs duplicados, atributos y escapes; idealmente procesar con parser XML estricto, abrir en diagrams.net y guardar/reabrir. Un conteo equilibrado de etiquetas **no equivale** a parseo completo ni a prueba visual.

**M-3 — Trazabilidad vertical:** para cada operación humana `Actor → :Sistema` en DSS identificar mensaje equivalente del DS, contrato con las nueve secciones y un estado/postcondición coherente. Para los mensajes internos del DS: documentar receptor, responsabilidad, objeto/entidad, origen de visibilidad por atributo/parámetro/creación y persistencia asociada. Una asociación a una tabla SQL por sí sola no prueba visibilidad UML.

**M-4 — Invariantes horizontales y pruebas de excepción:** someter los tres CU a escenarios encadenados y negativos: alta maestro sin stock; ingreso físico valorizado por UC-42; edición de unidad sin historial; bloqueo tras **cualquier** movimiento o **cualquier** costo; reventa sin valoración válida; salidas sin stock negativo; concurrencia y revalidación. Comprobar que los mismos efectos aparecen en DSS, DS y contrato y no se duplican en otro CU.

**M-5 — Exactitud frente a fuentes:** separar (a) regla explícitamente ratificada, (b) representación de diseño inferida/propuesta, (c) atribución pendiente de cotejo con ficha Real/Extendida, modelo del dominio, MR-5/MR-6 y RBAC. No añadir campos, estados, actores, política de conversiones, autorizaciones o métodos sin soporte.

**M-6 — Semántica UML y revisión gráfica:** comprobar `alt` mutuamente excluyentes, `opt` dentro de la rama correcta, orden vertical de creación y uso, duración de líneas de vida, barras de activación, extremos de mensajes, referencias de visibilidad y legibilidad de las seis o más páginas. **No declarar esta puerta superada sin abrir/reeditar los XML en Draw.io.**

**M-7 — Dictamen con puerta de aceptación:** registrar cada hallazgo con ID, criticidad, evidencia, regla fuente, corrección propuesta y estado. Resultado por criterio: `PASÓ`, `OBSERVADO`, `NO VERIFICADO`. Bloqueos impiden cierre académico. Abrir correcciones sólo en la rama/PR y pedir aprobación expresa antes de convertir la propuesta en definitiva/merge.

## 2. Universo y cobertura observada

| Caso | DSS por actor | DS individual | Contrato | Original preservado | Situación |
|---|---|---|---|---|---|
| UC-50 Registrar Insumo | Admin 6A, celdas `a1_m6`/`a1_r6` | `DS_UC50_REV01.drawio.xml` | `CONTRATO_UC50_REV01.md` | Sí | Propuesta consistente en regla base, sin cotejo académico |
| UC-42 Registrar Ajuste de Inventario | Producción, `rp_m8`, `rp_r8_*` | `DS_UC42_REV01.drawio.xml` | `CONTRATO_UC42_REV01.md` | Sí | **Bloqueo de semántica/secuencia DS** |
| UC-51 Modificar Insumo | Admin 6A, `a1_r7` | `DS_UC51_REV01.drawio.xml` | `CONTRATO_UC51_REV01.md` | Sí | Regla correcta, contratos/semántica aún parciales |

**Inventario GitHub leído para esta auditoría:** ocho piezas propuestas: cinco XML (DS UC-50/42/51 y DSS Admin/Producción) y tres contratos; originales de Gemini separados. Los ocho contenidos fueron recuperados directamente de la rama de PR #10. Cada contrato indica 9 apartados y glosario. No equivale a la cobertura completa de todos los escenarios de los tres CU.

## 3. Matriz transversal y dictamen por invariante

| ID | Invariante ratificada | DSS | DS | Contrato | Resultado |
|---|---|---|---|---|---|
| T-01 | UC-50 crea maestro con `stockActual=0`, sin entradas físicas ni costos inventados (RP-016) | Expresa saldo 0 | Crea Insumo con stock 0; elimina ramas costo inicial | Postcondición sin movimientos ni costos | **PASÓ en trazabilidad textual** |
| T-02 | Primer ingreso real por UC-42, `SALDO_INICIAL` documentado y costo válido (RP-015/016) | Explicita separación | Agrega costo y movimiento, pero **secuencia/fragmentos defectuosos** | Postcondiciones de costo y movimiento | **OBSERVADO/BLOQUEANTE** |
| T-03 | Unidad Insumo bloqueada si hay movimiento **o** costo histórico (RP-017) | Expresado `a1_r7` | Guardas separan ambos antecedentes | Pre y postcondiciones obligan revalidación | **PASÓ en trazabilidad textual**; concurrencia no probada |
| T-04 | Con historial, usar nuevo Insumo sin transferir stock ni reescribir históricos (RP-017) | Sin nueva transferencia explícita | Rechazo y salida a un nuevo registro | Bloquea migración silenciosa | **PASÓ textual**, no auditadas todas las asociaciones |
| T-05 | Insumo y REVENTA son stocks distintos (RP-022) | Ramas diferenciadas | Líneas de vida separadas, pero alternativa UML no cerrada correctamente | Tres postcondiciones separadas | **OBSERVADO** |
| T-06 | Promedio móvil de REVENTA y valoración extraordinaria justificada; nunca costo 0 inventado (RP-022) | Lo menciona | Menciona `MovimientoStockReventa` y `ValoracionExtraordinariaReventa`; no muestra cálculo ponderado ni procedencia de costo a detalle | Regla descrita, falta formalizar variantes de operación | **OBSERVADO** |
| T-07 | Cantidades válidas, unidad base, no stock negativo, costos históricos inmutables (RP-022) | Guardas resumidas | Guardas parciales; no representación total de control concurrente | Excepciones y rechazo atómico | **OBSERVADO / servicio no probado** |
| T-08 | Cada DSS tiene evento correspondiente en DS y contrato 9 secciones | Mismo nombre general por UC | Firmas no coinciden exactamente y se incluyen métodos de diseño no trazados a operaciones canónicas | Cada UC tiene contrato | **OBSERVADO** |
| T-09 | Visibilidad Larman demostrada para cada mensaje del DS | No aplica (caja negra) | No hay prueba de procedencia de referencias entre todos los participantes/controladores | No es prueba de visibilidad | **NO VERIFICADO** |
| T-10 | XML operable, diagramas y contratos académicamente conformes | Control textual | Control textual, sin inspección gráfica | Estructura 9 secciones comprobada | **NO VERIFICADO** |
| T-11 | RBAC/actor correctos en cada operación | Admin/Producción | UC-42 muestra `Responsable de Producción / Admin`; permisos por rol no cotejados exhaustivamente | Autorización genérica | **NO VERIFICADO** |
| T-12 | Fichas UC Real/Extendida son autoridad de eventos y excepciones | Sin cotejo literal | Firmas declaradas a verificar | Reconoce limitación | **NO VERIFICADO** |

## 4. Hallazgos concretos ordenados por gravedad

| ID | Prioridad | Evidencia de artefacto propuesto | Defecto / riesgo | Acción exigida |
|---|---|---|---|---|
| **H01** | **BLOQUEANTE** | UC-42 `DS_UC42_REV01.drawio.xml`: `u42_m3_new` crea `MovimientoInsumo` antes de `u42_mcost` (costo de `SALDO_INICIAL`) y la asociación al costo se limita a una nota | Orden del historial y origen del costo quedan ambiguos; el movimiento exige `vigenteDesdeCosto` válido | Reorganizar secuencia para obtener/crear costo histórico primero, luego movimiento que lo referencia; distinguir costo preexistente y creación |
| **H02** | **BLOQUEANTE** | UC-42: fragmento `u42_alt`, `u42_div` y `u42_g2`; la nueva guarda `u42_grev` no está acompañada de divisoria propia y la rama de rechazo se desplaza a y=1390 | El gráfico no delimita correctamente los operandos `INSUMO`, `REVENTA` y `RECHAZO`; `alt` no expresa opciones excluyentes | Reconstruir el marco `alt` con tres operandos explícitos y mensajes de cada rama contenidos dentro |
| **H03** | ALTA | UC-42: `u42_opt_saldo` inicia en x=1020 y=413; `u42_mcost` a y=455 y el movimiento `u42_m3_new` a otra altura; `u42_opt_val` y mensajes REVENTA | La geometría y el alcance condicional pueden no contener íntegramente los mensajes que dicen condicionar | Comprobar geometría, orden, activaciones y pertenencia a fragmentos en Draw.io; no certificar a partir de atributos |
| **H04** | ALTA | UC-50/51: firmas `registrarInsumo`, `modificarInsumo`, `consultarHistorialInsumo` con DTO y métodos postulados | El DS incorpora operaciones de diseño propuestas, que no se deben presentar como identidad literal de las fichas de la cátedra | Contrastar evento de DSS/ficha, mensaje a controlador y métodos internos; catalogar cuál es propuesta y cuál textual |
| **H05** | ALTA | UC-42: DSS `rp_m8` y DS `u42_m1` usan distinta tipificación/orden de argumentos; contrato propone `tipoMovimiento`, `costoValuacion` opcional | El contrato del sistema no tiene firma unívoca | Unificar **por fuente** la firma pública y diferenciarla de las llamadas internas; no inventar API |
| **H06** | ALTA | UC-42: cálculo de promedio REVENTA mencionado sin desglose de valorización y conversiones detalladas | Contrato funcional no demuestra aplicación del promedio móvil para tipos de ajuste ni tratamiento de cambio de costo | Separar casos de ingreso valorizado, egreso y valoración extraordinaria; vincular con RP-022 y RP-015 |
| **H07** | MEDIA | UC-51 `u51_m2` consulta historial antes de `u51_m3`, pero la revalidación transaccional queda solo en una etiqueta | Posible cambio concurrente de historial entre consulta y modificación | Explicitar condición atómica en mensaje pertinente de dominio/servicio y postcondición; probar posteriormente |
| **H08** | MEDIA | UC-50/42/51: falta matriz verificable emisor → receptor → visibilidad | El rótulo `Controlador` y la tabla SQL no demuestran reglas de visibilidad Larman | Preparar matriz por cada mensaje interno y comprobación de asociaciones/creación |
| **H09** | MEDIA | UC-42: DSS agrupado por Producción; DS incluye actor compuesto `Responsable de Producción / Admin` | Autoridades y flujo del caso podrían mezclarse si RBAC no distingue permisos | Consultar matriz aprobada de permisos y documentar escenas por actor |
| **H10** | MEDIA | UC-50/51: contrato menciona validez de nombre/unidad y restricciones históricas | Falta contraste con el detalle literal de pre/postcondiciones y permisos de las 192 fichas | Cotejar DOCX maestro, no sustituir por corte histórico de 49 CU |

## 5. Puertas de cierre — criterio objetivo

| Puerta | Evidencia mínima | Resultado al 28/10 |
|---|---|---|
| G1 Origen preservado | Originales + propuesta por CU, historia de commits | **PASÓ** |
| G2 Cobertura nominal | DSS Admin/Producción, tres DS y tres contratos | **PASÓ** |
| G3 Reglas RP-016/RP-017 textuales | Alta sin stock; unidad bloqueada por movimiento o costo | **PASÓ textual** |
| G4 RP-015/RP-022 y orden UML UC-42 | Historia y costo enlazados, alternativas completas y valores justificados | **NO PASÓ**, H01/H02 |
| G5 Trazabilidad exhaustiva DSS–DS–Contrato | Operaciones, firma, permisos, escenarios y postcondiciones uno a uno | **PENDIENTE**, H04/H05/H09/H10 |
| G6 Visibilidad/semántica UML | Matriz emisor/receptor, creación, activaciones y visibilidad | **PENDIENTE**, H03/H08 |
| G7 XML y QA gráfico | Parser XML estricto sobre artefactos corregidos + abrir/editar/reabrir Draw.io | **PENDIENTE**, no afirmar superado |
| G8 Pruebas de servicio/inventario | Atomicidad, stock y costos con casos positivos/negativos/concurrentes | **PENDIENTE**, aplicación no implementada |
| G9 Aprobación de artefactos | Conformidad del responsable y revisión académica | **PENDIENTE** |

**Dictamen:** **No cerrar REV-01 todavía**. Es posible corregir H01/H02 dentro de esta misma rama, luego repetir M-2/M-3/M-6 y volver a evaluar. **No fusionar PR #10 ni marcar UC-50/42/51 como validados.**

## 6. Matriz de escenarios mínimos de prueba futura

| Escenario | Entrada/evento | Resultado esperado | Evidencia por producir |
|---|---|---|---|
| E01 | Alta UC-50 sin existencia inicial | Insumo stockActual=0, sin costo/movimiento | Contrato + fixture + test servicio |
| E02 | Intento de stock inicial mediante UC-50 | Efecto físico rechazado/no persistido | DSS/DS + test API |
| E03 | UC-42 SALDO_INICIAL real con costo válido | Movimiento y costo del mismo Insumo, saldo positivo | Test transaccional y FK |
| E04 | UC-42 SALDO_INICIAL sin costo válido | Rechazado sin movimiento ni saldo | Test API + DB |
| E05 | UC-51 cambio unidad sin movimiento/costo | Se permite si cumple restantes reglas | Test servicio |
| E06 | UC-51 cambio unidad tras movimiento aunque stock=0 | Rechazado | Test servicio |
| E07 | UC-51 cambio unidad sin movimientos pero con costo histórico | Rechazado | Test servicio |
| E08 | UC-51 nombre/descripción con historial | Se permite sólo lo editable | Test RBAC + servicio |
| E09 | UC-42 REVENTA ingreso valorizado | Promedio móvil ponderado; saldo correcto | Test decimal |
| E10 | UC-42 REVENTA sin costo, requiere valoración extraordinaria | Se requiere justificación, sin costo cero ficticio | Test servicio |
| E11 | Ajuste que deja stock negativo | Rechazado sin efectos parciales | Test concurrencia |
| E12 | Cambio de unidad concurrente con ingreso UC-42 | Sólo uno puede confirmarse si genera conflicto de historial | Test concurrente |

## 7. Secuencia de trabajo para levantar el bloqueo

1. En UC-42, separar los tres operandos `alt` y ubicar creación/selección de costo anterior al movimiento que lo referencia, sin cambiar modelo de datos.
2. Resolver la geometría de los fragmentos `opt`, líneas de vida, barras de activación y las direcciones de los mensajes; después ejecutar parser XML estricto y Draw.io.
3. Homologar firmas de UC-42 según la ficha Real/Extendida, no por elección libre de DTO o métodos.
4. Rellenar matriz granular por mensaje con visibilidad Larman y origen de la asociación entre objetos.
5. Comparar los tres CU frente al DOCX de 192 fichas y las restricciones MR-5/MR-6 y RBAC, separando conflictos de decisiones funcionales de decisiones de diseño.
6. Adjuntar evidencias de QA, nueva revisión de este dictamen y obtener aprobación expresa antes de integrar al Trabajo Final.

## 8. Notas de integridad de la auditoría

- Se leyeron las ocho propuestas desde GitHub, las decisiones vigentes y la trazabilidad previa del PR #10.
- Los hallazgos H01/H02 fueron detectados en esta auditoría transversal y no deben diluirse por controles previos de etiquetas balanceadas.
- **No** se abrió la interfaz Draw.io ni se ejecutaron pruebas de software.
- No se afirma que se verificaron las 192 fichas del DOCX ni que estos diez hallazgos sean una lista exhaustiva de defectos.
