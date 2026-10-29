# Acta de cierre del Lote 1 — REV-01 Insumos e Inventario

**Fecha:** 28/10/2026 · **Repositorio:** `leandrito369/ale-milanesas` · **PR:** #10, DRAFT, basado en rama documental del PR #9.

## 1. Decisión de estado y alcance

**CIERRE DEL LOTE DE TRABAJO DOCUMENTAL: COMPLETADO.** Se concluye el ciclo de corrección *propuesta y auditoría estática* de **UC-50, UC-42 y UC-51**, incluyendo preservación del trabajo de Gemini, propuestas editables, tres contratos separados, corrección de H01/H02, homologación de eventos públicos, revisión estructural de mensajes, matriz de visibilidad y esta acta de calidad.

**VALIDACIÓN ACADÉMICA FINAL: NO APROBADA NI CERTIFICADA.** La conclusión anterior no autoriza presentar los diagramas como versión definitiva del TFI ni fusionar PR #10 a `main`. El PR queda en borrador **abierto**, porque la validación visual, la evidencia de visibilidad de algunos objetos y las fichas originales siguen faltando.

**Implementación:** no se ejecutó API, SQL de servicios, simulación de concurrencia ni pruebas funcionales. El DDL y los diagramas de casos de uso no fueron modificados.

## 2. Material verificado

- **Originales Gemini:** DS UC-50/UC-42/UC-51, DSS del Administrador/Producción y contratos 6A.3/4.4 conservados en `REV01_UC*/originales/`. Se preserva el chat fuente completo fuera del repositorio.
- **Propuestas:** 5 XML (`DS_UC50_REV01`, `DS_UC42_REV01`, `DS_UC51_REV01`, `DSS_ADMIN_6A_REV01`, `DSS_PRODUCCION_UC42_REV01`) y 3 contratos de 9 secciones.
- **Gobierno:** RD-RP016-001, RD-RP017-001, RD-RP022-001, RP-015; contexto maestro 64 CU y diccionario MR-5/MR-6.
- **Análisis:** `REV01_AUDITORIA_TRANSVERSAL_CIERRE_2026-10-28.md` (corte original y hallazgos), `REV01_ADENDA_H01_H02_UC42_2026-10-28.md` y `REV01_MATRIZ_HOMOLOGACION_VISIBILIDAD_2026-10-28.md`.

## 3. Procedimiento de auditoría ejecutado (método con evidencia y límites)

| Puerta | Procedimiento | Evidencia producida | Dictamen |
|---|---|---|---|
| A — autoridad | Contrastar propuesta con decisiones aprobadas y con diccionario físico vigente | Reglas RP-015/016/017/022 y nombres de campos referenciados | **Superada para reglas expresas**, no para fichas Word |
| B — preservación | Conservar originales y versiones revisadas en directorios distintos | Archivos `originales/` y `propuestos/` en PR #10 | **Superada** |
| C — firmas públicas | Comparar nombre y parámetros de evento en DSS, primer mensaje del DS y Nombre del contrato | Matriz A: 3 operaciones `registrarInsumo`, `registrarAjusteInventario`, `buscarYModificarInsumo` | **Superada internamente** |
| D — semántica funcional | Recorrer escenarios encadenados UC-50→UC-42→UC-51, casos de rechazo y no retroactividad | Matriz C de trazabilidad; condiciones de stock, historial y costo | **Superada textualmente** para núcleo ratificado |
| E — secuencia UC-42 | Comprobar orden geométrico costo→movimiento→saldo→retorno y tres regiones `alt` | H01/H02 corregidas; geometrías y mensajes `rev01_u42_insaldo`/`rev01_u42_revsaldo` | **Superada estáticamente**, no certificación visual |
| F — estructura XML | Volver a leer cinco archivos desde GitHub y analizar tags anidados, entidades XML, número de `diagram` e IDs `mxCell` | 5/5 con analizador propio sin errores, una página por archivo, IDs únicos; celdas DS 24/49/26, DSS 41/50 | **Superada por analizador propio**; no parser externo |
| G — contratos | Revisar secciones 1–9 y glosario; concordancia de nombre/operación | Tres contratos separados UC-50/42/51; 9/9 secciones cada uno | **Superada en estructura y firma** |
| H — visibilidad Larman | Recorrer mensajes del DS y exigir prueba de cada referencia por creación, parámetro, atributo/asociación o referencia local | Matriz B identifica visibilidad por creación y referencias **sin justificar** | **NO superada globalmente** |
| I — autoridad académica | Cotejo literal con tres niveles del Word `ALE_MILANESAS_FASE_4_CU_01_A_64_TRES_NIVELES.docx` | Word original no incorporado a GitHub; corte de 49 CU no equivalente | **NO verificable** |
| J — render / GUI | Abrir, mover, guardar y reabrir propuestas en Draw.io y revisar geometría real | No se accedió a Draw.io en esta auditoría | **NO verificado** |
| K — servicios | Probar atomicidad, unidades, costos, stock, concurrencia y bloqueos RBAC en app real | Servicios no ejecutados | **Fuera del cierre documental** |

**Precisión:** el analizador de XML usado inspeccionó apilamiento de etiquetas, escapes y forma; no es un validador XSD, ni prueba semántica UML ni equivalente a abrir Draw.io. No se utilizaron coordenadas como sustituto de verificación académica.

## 4. Cambios efectivamente cerrados en el alcance documental

1. **UC-50:** alta de Insumo con `stockActual=0`; sin stock/costo inicial inventado; contrato propio. Firma pública igual en DSS/DS/contrato.
2. **UC-42:** distinción Insumo/REVENTA; `SALDO_INICIAL` separado de alta de maestro; mensaje de costo anterior al de movimiento; cambios de saldo explicitados y fragmentos `alt/opt` reordenados; objetos creados con líneas de vida dentro de sus ramas. Firma pública igual en DSS/DS/contrato.
3. **UC-51:** unidad editable sólo sin movimientos **y** sin costos históricos; rechazo de cambio con historial; conserva UC-36; un único evento público de modificación, búsqueda e historial como interacciones internas; contrato propio. Firma pública igual en DSS/DS/contrato.
4. **Trazabilidad y QA:** informe inicial, adenda correctiva, matriz de mensajes con visibilidad y acta de este cierre.

## 5. Reservas explícitas y defectos que NO deben declararse solucionados

- **R1 — Visibilidad Larman no demostrada:** `:ControladorInsumos` → `:CatalogoInsumos`; `:ControladorInventario` → instancias existentes de `Insumo`/`Producto`. Debe localizarse y representarse el origen de esas referencias o demostrar atributo/asociación válida.
- **R2 — Firma vs CU Real:** las tres firmas coinciden *entre los artefactos propuestos*, pero no se sabe si todos sus parámetros/tipos son los aprobados en el Word de 192 fichas; especialmente `costoValuacion` en UC-42 y `DatosInsumo` en UC-51.
- **R3 — UML gráfico y editabilidad:** no se ejecutó apertura/reapertura de XML en Draw.io; puede haber solapamientos, mensajes fuera de marco, anotaciones largas o problemas de activación.
- **R4 — Responsabilidades y atomicidad:** `:CatalogoInsumos` consulta historial en la propuesta, pero el reparto de responsabilidades debe verificarse con el diseño de clases; la verificación atómica del bloqueo por historial no está probada por software.
- **R5 — Detalles de inventario:** conversiones en ajustes UC-42, costo según cada dirección/tipo, manejo de valores extraordinarios y precisión decimal por operación no deben completarse sin fuente.
- **R6 — Roles y alcance Real:** actor habilitado para UC-42, atributos editables de UC-51 y efectos de UC-36 exigen cotejo con fichas originales.

Ninguna reserva se transforma en una regla nueva del negocio; si al resolverla emerge una decisión funcional no cubierta, debe proponerse por separado para aprobación del responsable.

## 6. Dictamen final

- **Cerrado:** trabajo de **corrección documental y homologación estática** definido para el Lote 1 REV-01.
- **No cerrado:** certificación de **conformidad académica** y aptitud para presentar las versiones propuestas como diagramas finales.
- **Estado del PR #10:** **DRAFT ABIERTO**, no fusionado a `main`.
- **Regla para levantar reservas:** obtener ficha maestra actual UC-50/42/51, justificar referencias de controladores, efectuar QA visual Draw.io y nueva revisión docente/funcional. Solo tras evidencia positiva reconsiderar certificación y fusión.

**No declarar “sin errores” ni “100 % validado”: la evidencia disponible no lo permite.** Este documento hace trazable exactamente lo que está terminado y lo que falta.
