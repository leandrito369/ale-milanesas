# Plan de trabajo delegado a Gemini Web — Ale Milanesas

**Fecha:** 26/10/2026 · **Versión:** 0.1 / revisión  
**Rol de Gemini:** colaborador de análisis/diseño y producción de borradores; **no** autoridad para modificar decisiones de negocio ni repositorios.  
**Rol de integración:** responsable del proyecto aprueba; ChatGPT contrasta fuentes, revisa trazabilidad y propone PR en GitHub.

## 1. Estado de colaboración

**En curso ahora:** el responsable está trabajando con Gemini en **DSS (Diagramas de Secuencia del Sistema)** y **DSD (Diagramas de Secuencia de Diseño)**. No sustituir ni reconstruir lo producido por Gemini antes de recibir las fuentes originales y el intercambio de trabajo.

**Siguiente encargo:** **Contratos de Operación**, elaborados a partir de operaciones efectivamente identificadas en DSS y reconciliadas con CU vigentes (no copiar mecánicamente un contrato por cada UC).

**Restricción de capacidad actual:** en este flujo Gemini Web no publica en GitHub; el usuario transferirá exportaciones/diagramas y el chat, y ChatGPT actuará como integrador.

## 2. Paquete de referencia por sesión

Proporcionar a Gemini solo la documentación necesaria para cada lote, indicando versión y autoridad:

1. **Fase 4:** documento DOCX maestro de **64 UC a tres niveles** (fuente primaria funcional; todavía no importado como nativo al GitHub actual). Si falta, no reconstruir silenciosamente operaciones desde versiones de 49 UC.
2. Modelo de dominio y diccionario conceptual aprobados; los antecedentes A/B/C/D del 23/10 solo como históricos cuando correspondan.
3. DSS/DSD **editables vigentes** del lote de trabajo; no emplear imágenes o transcripciones como única fuente cuando exista archivo de edición.
4. RD vigentes del frente: para ventas/cobro **RD-F01** y **RD-F04-001…007**; PRA-01 en compras; otras RD pertinentes.
5. `AGENTS.md`, protocolo de cambios, repositorio `main` o SHA del paquete, guía académica y requisitos de entrega de la cátedra.
6. Lista concreta de CU y operaciones incluidas en el lote. **No resolver otros frentes por inferencia.**

### Control de versiones

Cada archivo entregado debe declarar `fuente_nombre`, `fecha_o_commit`, `CU`, `operaciones`, `estado` (`PROPUESTA`/`VALIDADA`), `autor_de_revision` y pendientes. Una versión posterior no reemplaza silenciosamente la anterior; entregar diferencias.

## 3. Cadena de tareas delegables

| Orden | Paquete / rol Gemini | Entradas | Salidas que debe entregar | Control del integrador |
|---|---|---|---|---|
| **G1 — ahora** | **DSS:** interacciones actor–Sistema y operaciones por CU seleccionado | CU extendido/real, dominio, RD | Diagramas fuente editables + vista + tabla CU/paso/operación/parámetros/respuesta/excepción | En DSS el Sistema es caja negra; no introducir tablas, controladores u objetos de implementación |
| **G2 — ahora** | **DSD:** colaboración entre objetos/diseño | DSS revisado, dominio y arquitectura disponible | Diagramas editables + matriz de mensajes/objetos/responsabilidades + notas de decisiones propuestas | Coherencia con DSS y CU; técnicas no se vuelven reglas de negocio; marcar objetos candidatos no aprobados |
| **G3 — siguiente** | **Contratos de Operación** para operaciones seleccionadas de DSS | DSS/DSD aceptados, CU, dominio y RD | Índice de operaciones candidatas, justificación de inclusión/exclusión, contrato por operación, matriz CU↔DSS↔contrato | Solo operaciones que **modifican estado** y/o **devuelven instancias registradas**; poscondiciones declarativas, sin pseudocódigo |
| **G4** | Auditoría cruzada de coherencia | DSS, DSD, contratos, dominio, matriz CU | Tabla de discrepancias, faltantes, ambigüedades y sugerencias **[A CONFIRMAR]** | Contrastar contra fuentes, no aceptar «correcciones» autónomas |
| **G5** | Diseño conceptual de pruebas por CU/operación | CU y contratos validados | Escenarios Given/When/Then o entrada/resultado para normales/excepciones y trazabilidad | No afirmar ejecución; traducir luego a pruebas automatizadas |
| **G6** | Prototipos de pantallas y mensajes (si se solicita) | Contratos, CU, alcance de UX | Wireframes/propuesta de navegación y textos | Sin inventar campos o operaciones de negocio |
| **G7** | Redacción preliminar académica/manuales (fase final) | Entregables reales aprobados y evidencia | Borradores explicativos, guías, glosario y ayudas | No redactar manual de funcionalidades aún no implementadas |

### Lo que NO conviene delegar sin revisión humana

- Ratificar reglas de negocio, cambiar roles o conceder UC-29 al Repartidor.
- Crear entidades o migraciones físicas como si estuvieran aprobadas.
- Alterar el diagrama de CU rechazado o renumerar UC-01…UC-64.
- Declarar pruebas PostgreSQL, APIs o funcionalidades «ejecutadas» basándose únicamente en documentos.
- Fusionar PR, modificar `main` o sustituir el DOCX fuente de 192 fichas.

## 4. Proceso específico G1/G2: cuando recibamos tus DSS/DSD

**Entregar al integrador:**
1. **Archivos editables** de cada DSS/DSD (preferentemente UML textual PlantUML/Mermaid o Draw.io, según formato usado), más exportación PNG/PDF para revisión visual.
2. **Chat completo o extracto confiable** con las decisiones, alternativas, supuestos, correcciones y dudas surgidas con Gemini.
3. **Inventario:** CU trabajado, nombre de cada diagrama, versión, operaciones/mensajes, escenario básico o alternativo, referencias a pasos.
4. **Matriz de trazabilidad:** `CU | paso | actor | operación | parámetros | respuesta | DSS | DSD | estado`.
5. Listado de **puntos de decisión abiertos**; no presentarlos como reglas aprobadas.

**Procedimiento de integración ChatGPT:**
- Clasificar archivos y confirmar que corresponden a la numeración de 64 CU.
- Comparar contra fichas Fase 4, dominio y RD posteriores; detectar pasos omisos, operaciones no justificadas, permisos indebidos y mensajes sin salida.
- Revisar visualmente los diagramas; no regenerarlos si las fuentes aprobadas ya cumplen.
- Publicar originales editables, vistas de referencia, matriz y un informe de QA en **rama/PR dedicado**, sin tocar el diagrama de CU rechazado.
- Obtener conformidad del usuario antes de fusionar, en especial si se propone alguna alteración semántica.
- Etiquetar lote `DSS-DSD-vN` o commit para que los contratos citen una versión reproducible.

**Criterios G1/G2:** cobertura de cada operación relevante del CU, actor correcto, flujo normal y excepciones principales, denominaciones coherentes, sin cambio implícito del negocio, archivos editables, revisión visual y trazabilidad.

## 5. Proceso específico G3: contratos de operación

El **contrato de operación** describe **de forma declarativa lo que una operación se propone lograr, no cómo se consigue**.

**Seleccionar operaciones únicamente cuando**:
- **A.** Modifican el estado observable/persistente del sistema: crear, asociar, cambiar atributos, registrar movimientos, cambiar estados, anular, etc.; **y/o**
- **B.** Producen una salida de negocio con **retorno de instancias registradas** en el sistema (por ejemplo, una búsqueda/consulta que devuelve Clientes o Pedidos registrados).

**Excluir por defecto** simple navegación, validaciones auxiliares sin poscondición ni retorno de instancias, mensajes puramente decorativos, llamadas privadas de implementación que solo aparecen en el DSD. Si la cátedra exige otra cobertura, documentarla como variación metodológica explícita.

**No construir automáticamente 64 contratos:** un CU puede originar varias operaciones, una operación puede aparecer en múltiples CU, y algunos CU solo necesitan contratos para operaciones seleccionadas.

### Estructura estricta del contrato

1. **Nombre:** operación y parámetros de su firma observada (no inventar tipos).
2. **Responsabilidades:** propósito declarado en lenguaje del negocio.
3. **Tipo:** nombre del tipo/concepto/clase/interfaz según el nivel y notación utilizados; `Sistema` en un contrato de operación de sistema cuando corresponda, sin convertirlo en actor UML.
4. **Referencias cruzadas:** CU exacto, pasos y DSS/DSD correspondientes; RD/RF cuando procedan.
5. **Notas:** aclaraciones de diseño o restricciones, sin convertirlas en algoritmo ni introducir acuerdos ficticios.
6. **Excepciones:** condiciones excepcionales previstas por el CU, con efecto sobre el estado cuando corresponda.
7. **Salida:** retornos de instancias registradas y/o mensajes al usuario según la operación.
8. **Precondiciones:** hechos que deben cumplirse **antes** de ejecutar; no las instrucciones para verificarlos.
9. **Postcondiciones:** hechos observables **después** de completarse con éxito (instancias creadas, atributos cambiados, asociaciones establecidas, estados resultantes, objetos retornados). Para excepciones, indicar explícitamente si no hay cambio o qué estado se conserva.

**Redacción:** «Se crea una instancia de Pedido...», «El Pedido queda asociado al Cliente...», «Se registra la operación una única vez...», «Se devuelve la colección de Clientes que cumplen...». No «el controlador ejecuta SQL INSERT...», «se llama a tal servicio...» ni pseudocódigo.

**Auditoría previa a integración:**
- Firma del contrato = operación de DSS, con parámetros compatibles y sin inventar nombres.
- Pre/post justificadas por CU y dominio, independientes de implementación.
- No convertir la entrega física en Cobro. UC-05 puede declarar efectivo sin permiso UC-29, como RD-F04-004.
- Pago en tránsito válido afecta **solo exigibilidad provisional**; no crea `COBRO=CONFIRMADO` ni ingreso en Caja sin rendición Admin.
- Deuda provisional al evaluar nuevos Pedidos; categoría `EN_MORA` y recargo permanecen hasta reevaluación formal.
- `COBRO.estadoCobro` únicamente `CONFIRMADO`/`ANULADO`, conforme a RD-F01.
- No introducir `PENDIENTE_RENDICION` como estado de COBRO.
- Definir referencias a incidentes/faltantes solo hasta «pendiente de conciliación» (RD-F04-005).
- No exigir atributos o políticas que la fuente no define. Marcar `[A CONFIRMAR]`.
- Revisión por lotes pequeños (por ejemplo, 4–8 operaciones) para no perder calidad ni control de versión; lote inicial priorizar Cliente/Pedido/Entrega/Cobro con sus permisos bien establecidos.

[Plantilla y matriz de selección](../07-contratos-operacion/PLANTILLA_CONTRATO_OPERACION_Y_CONTROL_2026-10-26.md).

## 6. Otros encargos útiles después de G3

- **Revisión de consistencia conceptual:** detectar conceptos de dominio que aparecen en postcondiciones pero no están modelados, sin crear clases/columnas automáticamente.
- **Matriz de cobertura UC↔operación↔contrato↔prueba:** señalar operaciones sin cobertura y contratos sin fuente.
- **Análisis de alternativas de UI:** flujos de Administrador, Vendedor y Repartidor, separando captura offline de aplicación financiera.
- **Auditoría documental:** ambigüedades por documentos históricos del 23/10 vs RD posteriores, referencias cruzadas obsoletas y notación UML.
- **Preparación de pruebas de aceptación:** redactar escenarios verificables para que el equipo programador los implemente después.

## 7. Protocolo de recepción, QA e integración

1. Gemini devuelve **archivos originales y matriz**, no solo una respuesta narrativa.
2. Se incluye el chat para reconstruir decisiones, **pero una afirmación de Gemini no equivale a autorización del negocio**.
3. ChatGPT compara los artefactos con el repositorio y fuentes; prepara informe `QA_GEMINI_LOTE_...`.
4. Divergencias o políticas no definidas → **Issue/RP** con pregunta exacta; no corregir autónomamente.
5. Cambios semánticos → consentimiento explícito del usuario y nueva RD.
6. Commit en rama `docs/gemini-<lote>-<fecha>`; PR con archivos originales, diffs, referencias CU/RD y pruebas documentales; merge tras revisión.
7. Cerrar el lote con `APROBADO_DOCUMENTAL`, `CORRECCIONES_PENDIENTES` o `RECHAZADO`; nunca `IMPLEMENTADO` si solo son diagramas/contratos.

### Lista de control para cada entrega

- [ ] Fuente Fase 4 vigente, CU y versión identificadas.
- [ ] DSS/DSD y contratos identifican la misma operación.
- [ ] Descripción funcional y poscondiciones sin lógica de implementación.
- [ ] Actores/permisos y decisiones RD no contradichos.
- [ ] Excepciones y retornos relevantes cubiertos.
- [ ] Archivos editables exportados; tablas/imágenes legibles.
- [ ] Sin nuevas reglas/estructuras no autorizadas.
- [ ] Matriz y QA revisados por responsable/integrador.
- [ ] PR independiente con trazabilidad y estado.

## 8. Encargo listo para Gemini — próxima etapa G3

> Estamos documentando el Trabajo Final «Sistema de Gestión para Ale Milanesas». La fuente funcional principal son los 64 CU de Fase 4, a tres niveles, y las RD posteriores que te suministraré. Ya estamos preparando DSS y DSD. Tu siguiente tarea es identificar **solo las operaciones de sistema** presentes en los DSS revisados que (a) cambian estado del sistema y/o (b) retornan instancias registradas. Para cada operación seleccionada produce un **Contrato de Operación declarativo**, con las nueve secciones: Nombre y parámetros, Responsabilidades, Tipo, Referencias cruzadas, Notas, Excepciones, Salida, Precondiciones y Postcondiciones. No expliques implementación, SQL, algoritmos ni arquitectura dentro de las postcondiciones. Usa hechos del dominio: creación/modificación de instancias, asociaciones y estados resultantes. Identifica explícitamente el CU/paso/DSS que justifica cada postcondición. Si faltan datos escribe `[A CONFIRMAR]` y no inventes políticas, atributos, actores o nuevos casos de uso. Mantén UC-01…UC-64, preserva RD-F01 y RD-F04-001…007 y no concedas UC-29 al Repartidor. Antes de redactar: presenta índice y justificación de inclusión/exclusión de las operaciones. Trabaja por lotes de 4–8 operaciones. Devuélveme documentos editables, matriz de trazabilidad y lista de discrepancias. No atribuyas a estos borradores aprobación ni implementación.

Este texto es la **plantilla base de encargo**; completar con archivos DSS/DSD, CU concretos y versiones antes de enviarlo para producir contratos definitivos.

## 9. Próxima transferencia de trabajo

Al finalizar DSS/DSD con Gemini, traer al chat:
- Fuentes editables de los diagramas y exportaciones legibles.
- Chat completo o extracto suficiente para auditar decisiones.
- Lista de CU y operaciones modeladas, y archivos de entrada usados en Gemini.
- Dudas abiertas y diagramas que el usuario considera aprobados/corregibles.

**Sin esos elementos no se declarará que la integración está completa**; puede comenzarse una revisión parcial, identificando lo no verificable.
