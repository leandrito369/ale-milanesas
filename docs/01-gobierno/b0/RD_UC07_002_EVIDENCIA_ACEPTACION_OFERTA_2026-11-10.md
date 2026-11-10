# RD-UC07-002 — Evidencia de aceptación de oferta y congelamiento del precio comercial

**Estado: BORRADOR DE TRABAJO — NO RATIFICADO — NO AUTORIZA IMPLEMENTACIÓN NI MIGRACIONES.**

**Fecha de redacción:** 10/11/2026 (Argentina).

**Responsable del proyecto y autoridad de ratificación:** Victor Leandro Machado (`leandrito369`).

**Ámbito:** UC-07, RT-UC07-02/03; coordinación con RT-UC07-04, UC-19 y regresión UC-03.

**Resultado de este documento:** consolidación para revisión; no cierra reservas, no activa CR y no sustituye fuentes ratificadas.

## 1. Identificación, estados y trazabilidad

### 1.1. Corte de fuentes efectivo

| Fuente | Versión examinada y resultado |
|---|---|
| Gobierno `leandrito369/ale-milanesas`, `origin/main` | `914827585c2e9b050f1beffbf7b725d413dd6e7d` |
| Aplicación `leandrito369/ale-milanesas-app`, `origin/main` | `d5f7607afb430a251cbf5cc9190a879a7d41416b` |
| Línea base G0, `source_commit` | `1263ffc17bd0eb7f3c69faaa9ff5ae556cf9de7e` |
| Acta G0, `governance_commit` | `27738b089afdd2698cdae915f75c0e8089a6248a` |
| Antecedente RD-UC07-001 | [PR #45](https://github.com/leandrito369/ale-milanesas/pull/45) fusionada mediante `914827585c2e9b050f1beffbf7b725d413dd6e7d`; D1–D5 y RT-UC07-01 ratificados parcialmente |
| RD-UC07-002 y CR relacionadas | Sin documento previo en `main`, sin borrador local y sin PR draft específica encontrados en la auditoría previa. Los identificadores de CR de §15 son propuestas, no reservas ni archivos creados |
| Flyway en la aplicación | V1 `V1__baseline_mr5.sql`, V2 `V2__f01_cobro_estados.sql`, V3 `V3__trazabilidad_partidas_insumo.sql`. V3 es la última encontrada; no se anticipa el número de una futura migración |
| Worktrees al comenzar | Limpios; checkout de gobierno en `d6807a0`, app en `20ce82d`. Inspección de fuentes remotas sin actualizar el checkout de la app |
| Entorno | [Issue app #28](https://github.com/leandrito369/ale-milanesas-app/issues/28) abierta; despliegue pausado. No se alteran gates ni producción |

La numeración RD-UC07-002 se emplea tras la búsqueda anterior, sin atribuirle ratificación. Las orientaciones O2/P2b y de captura que se transcriben provienen del encargo explícito del responsable para esta consolidación. No se inventa un acta previa, fecha de ratificación ni evidencia GitHub de una aprobación distinta. El encargo autoriza redactar y publicar este borrador, no implementar sus propuestas.

### 1.2. Fuentes documentales y técnicas

- [RD-UC07-001](RD_UC07_001_PROPUESTA_EXCEDENTES_FISICOS_2026-11-09.md): §4.1 D1-B y RT-UC07-01; §4.2 D2-A/RT-UC07-02; §4.3 D3-B/RT-UC07-03; §4.4 D4-A; §4.5 D5-B/RT-UC07-04; §8 dependencias; §11 y criterios de implementación.
- [Contratos canónicos G0 REV04B](../../08-diagramas/consolidacion-b0/CONTRATOS_REV04B_CORREGIDOS_B0_ACTUALIZADO.md), §5 Parte A `registrarOfertaExcedente` y §6 Parte B `registrarRespuestaOfertaExcedente` (líneas 199–277 en el corte). La Parte A no reserva existencias; §6.5 exige nueva aceptación del importe si cambia la cantidad.
- [RD-RP022-001](../RD_RP022_001_COSTEO_CONVERSIONES_REDONDEOS_2026-10-27.md): precisión decimal y escala comercial 2; no autoriza DDL.
- [RD-RP018-001](../RD_RP018_001_PRIMER_PRECIO_PRODUCTO_2026-10-27.md): producto sin precio no comercializable, máximo un precio vigente por instante, historia y condiciones confirmadas preservadas.
- [RD-UC19-002](RD_UC19_002_ACOTAMIENTO_VIGENCIAS_FUTURAS_2026-11-01.md): recortes prospectivos de vigencias, inclusive futuras; conserva `precioBase`, genera nueva fila y auditoría, prohíbe retroactividad. No crea una operación general de cancelación de precios.
- [Matriz RBAC G0](B0_MATRIZ_RBAC_67_OPERACIONES_CIERRE_2026-10-29.csv), filas UC-07: exclusivamente `VENDEDOR = D`; `ADMIN = NR`, sin herencia por jerarquía. [BC07](RD_B0_BC07_2026-10-29.md) limita las proyecciones; no inferir acceso a costos o documentos personales.
- [Manifiesto canónico de 67 operaciones](G0_MANIFIESTO_CANONICO_67_OPERACIONES_2026-10-29.csv) y [protocolo de cambios](../PROTOCOLO_CAMBIOS_Y_CHATS.md): conservar catálogo y distinguir decisión, propuesta, implementación y prueba.
- Aplicación, [V1](https://github.com/leandrito369/ale-milanesas-app/blob/d5f7607afb430a251cbf5cc9190a879a7d41416b/src/main/resources/db/migration/V1__baseline_mr5.sql): `PEDIDO` L138–172, `EXCEDENTE` L222–241, `OFERTA_EXCEDENTE` L243–261, `PRECIO_PRODUCTO`/`AUDITORIA_PRECIO` L292–322, exclusión temporal L1041–1043. V2/F01 y V3/partidas no agregan el snapshot ni la evidencia de este borrador.
- [ActualizarPrecioVigenteService](https://github.com/leandrito369/ale-milanesas-app/blob/d5f7607afb430a251cbf5cc9190a879a7d41416b/src/main/java/ar/edu/unam/alemilanesas/maestros/ActualizarPrecioVigenteService.java) L52–155: microsegundos, `PRODUCTO FOR UPDATE`, instante PostgreSQL, lock asesor `1919001`, períodos `FOR UPDATE`, cierre e inserción atómicos.
- [ConsultarHistorialPreciosService](https://github.com/leandrito369/ale-milanesas-app/blob/d5f7607afb430a251cbf5cc9190a879a7d41416b/src/main/java/ar/edu/unam/alemilanesas/maestros/ConsultarHistorialPreciosService.java) L61–115: historial por vigencia y auditoría; no sustituye una captura atómica de oferta.
- [AplicarAjusteComercialService](https://github.com/leandrito369/ale-milanesas-app/blob/d5f7607afb430a251cbf5cc9190a879a7d41416b/src/main/java/ar/edu/unam/alemilanesas/finanzas/AplicarAjusteComercialService.java) L77–85: orden de redondeos que D2-A adopta; [CargarPedidoService](https://github.com/leandrito369/ale-milanesas-app/blob/d5f7607afb430a251cbf5cc9190a879a7d41416b/src/main/java/ar/edu/unam/alemilanesas/ventas/CargarPedidoService.java) L69: replay sin filtro de líneas técnicas.

Las fuentes enlazadas relativas se interpretan al SHA de gobierno de §1.1. El análisis previo de Codex sobre ese corte fue estático, con ejemplos aritméticos BigDecimal; no ejecutó concurrencia de UC-07 en PostgreSQL. Se incorpora su razonamiento en §9–11, sin usar un chat como sustituto de las fuentes normativas.

### 1.3. Matriz de autoridad

| Decisión | Estado |
|---|---|
| D1–D5 y RT-UC07-01 opción A de RD-UC07-001 | Ratificadas en el antecedente; no modificadas aquí |
| WhatsApp o mensaje verificable | Orientación aprobada según encargo |
| Captura manual asistida | Orientación aprobada según encargo |
| O2 — Registro previo independiente | Orientación aprobada; contrato definitivo pendiente de CR-C |
| P2 — Entidad independiente | Orientación aprobada |
| P2b — Contenido en PostgreSQL | Orientación aprobada; restricciones de archivos pendientes |
| Invalidación atómica después de validar nueva evidencia | Orientación aprobada |
| Alternativa B — Snapshot del precio | Recomendada; pendiente de ratificación formal |
| `idPrecio` y obligatoriedad | Pendiente de definición |
| Formatos, PDF y tamaños | Pendiente de evaluación |
| Índices definitivos | Pendiente de aprobación física |
| Orden global de locks | Pendiente, RT-UC07-04 abierta |
| CR-C y CR-F | No creadas ni autorizadas |
| Implementación UC-07 | No autorizada |

No se promueven orientaciones aprobadas a una ratificación integral de esta RD. Las propuestas físicas, el contrato auxiliar y los protocolos siguientes son diseños para revisión.

## 2. Contexto y brechas que deben resolverse

D3-B exige conformidad expresa sobre cantidad e importe antes de confirmar una aceptación parcial. Recalcular correctamente no prueba que el cliente haya aceptado ese resultado. RT-UC07-03 requiere evidencia durable vinculada a oferta, cotización, cantidad e importe.

D2-A exige conservar el precio comercial de la oferta frente a cambios posteriores de UC-19. `OFERTA_EXCEDENTE` conserva cantidad e importe ofrecidos, fecha, respuesta y cantidad/importe aceptados, pero no el precio base unitario ni su referencia directa. RT-UC07-02 exige probar reconstrucción inequívoca o aprobar otra persistencia.

P2b resuelve la orientación de almacenamiento documental; B propone conservar la base comercial. Son responsabilidades distintas: la oferta existe antes de la conformidad, puede ser recotizada o rechazada y debe preservar sus condiciones aun sin evidencia de aceptación. Un snapshot guardado exclusivamente al capturar la evidencia sería tardío para definir las condiciones originales.

Se mantienen D1-B (líneas técnicas solo al aceptar), RT-UC07-01 opción A (no nuevas ofertas de productos inactivos, trigger intacto), D4-A (sin mezclar excedentes físicos con efectivo en tránsito) y D5-B (no sobreasignación, atomicidad, unicidad y coordinación). La captura de evidencia no reserva stock, no crea líneas técnicas ni movimientos, no devenga deuda y no altera `totalOriginal`. No se invocan UC-15/UC-16 ni se vuelve a preparar el excedente. Los casos históricos de producto desactivado permanecen sujetos a la aclaración del antecedente, sin habilitación ni cancelación inferidas.

## 3. Canal y captura manual asistida: orientación aprobada

La conformidad se recibe por WhatsApp o mensaje verificable equivalente. Para el MVP no se exige un portal autenticado de `CLIENTE_ONLINE`, integración automática con WhatsApp ni envío de mensajes reales desde esta tarea. Una afirmación unilateral del vendedor sin respaldo documental no es evidencia suficiente.

El vendedor captura constancia documental, canal, referencia de contacto cotejada, vínculo con el cliente del pedido, oferta/cotización, cantidad e importe confirmados, fecha/hora del mensaje y declaración de la verificación realizada. El servidor obtiene la identidad del registrante de su contexto autenticado; nunca confía en un `idUsuario` arbitrario del cuerpo HTTP.

La declaración y el hash aportan trazabilidad e integridad documental. **No constituyen autenticación criptográfica del remitente.** La igualdad entre campos capturados y cálculo servidor no demuestra que la imagen/mensaje contenga realmente esos datos. El vendedor responde mediante declaración auditable por la correspondencia del contenido y la identidad del respondedor. No se presume interpretación automática del texto o de una captura.

`VERIFICADA` significa validación técnica y comercial automática de los datos registrados, no validación criptográfica, prueba concluyente de identidad ni comprobación automática del significado del mensaje. No se crea un segundo rol aprobador.

## 4. Persistencia: alternativas y orientación P2b

| Alternativa de evidencia | Evaluación |
|---|---|
| Solo texto/declaración o huella sin contenido | No conserva el respaldo recuperable que exige el encargo; insuficiente para esa orientación |
| Contenido fuera de la BD con referencia | Requeriría coordinar almacenamiento, acceso, retención y consistencia externos; no es la orientación elegida |
| P2 — entidad independiente; P2b — contenido en PostgreSQL | Orientación aprobada: separa evidencia de respuesta de oferta, permite historial e integridad transaccional de contenido, datos y eventos |

P2b no autoriza aún tablas ni BYTEA en producción. Requiere CR-F, límites y seguridad aprobados; debe evaluarse su impacto en almacenamiento, respaldo, restauración, lectura y retención de datos personales. No se fija 512 KB, no se aprueba PDF ni un conjunto definitivo de MIME. Tampoco se aprueba compresión automática ni admisión indiscriminada de archivos.

## 5. O2: operación auxiliar y fronteras transaccionales

**Orientación aprobada:** `registrarEvidenciaAceptacionOferta`, registro independiente previo, subordinado a UC-07, exclusivo de `VENDEDOR = D`. La matriz G0 respalda el ámbito del rol para UC-07; el alta del contrato auxiliar debe formalizarse en CR-C. No constituye otro CU principal ni altera las 67 operaciones principales del manifiesto.

La firma canónica se conserva:

```java
registrarRespuestaOfertaExcedente(
    Long idOfertaExcedente,
    Boolean aceptada,
    BigDecimal cantidadAceptada
)
```

### 5.1. Contrato auxiliar propuesto, no ratificado

| Elemento | Propuesta para CR-C |
|---|---|
| Nombre | `registrarEvidenciaAceptacionOferta` |
| Responsabilidad | Registrar y validar respaldo de conformidad, sin confirmar la reasignación |
| Entrada conceptual | `idOfertaExcedente`, referencia de cotización/intento, `cantidadConfirmada`, `importeConfirmado`, canal, referencia de contacto, fecha/hora del mensaje, contenido, MIME declarado, nombre descriptivo opcional y declaración de identidad del vendedor |
| Identidad | Sesión autenticada del servidor; rol VENDEDOR y ámbito del objeto revalidados |
| Precondiciones | Oferta existente y PENDIENTE, pedido receptor PENDIENTE y demás condiciones canónicas aplicables; base comercial identificable y correspondencia verificable de cotización |
| Salida conceptual | Identificador de evidencia, intento/correlación, estado, cantidad/importe comprobados, huella y fecha de registro; sin contenido personal innecesario ni costos internos |
| Postcondiciones | Evidencia y eventos conservados; si resulta válida, VERIFICADA. Si sustituye una verificada, sustitución atómica según §8; sin movimiento físico/comercial |
| Fallo | Sin confirmación física ni degradación de evidencia previa válida. Errores contractuales de §5.3 |
| Firma definitiva, transporte e HTTP | Pendientes de CR-C; esta tabla no aprueba una firma Java/HTTP ni una ruta |

### 5.2. Validaciones obligatorias propuestas

El servidor comprueba autorización y ámbito, existencia/estado de oferta y pedido, vínculo con cliente/producto, referencia de cotización válida, `0 < cantidadConfirmada <= cantidadOfrecida` representable con escala 3 y cantidad consistente con la oferta. O2 no reserva ni garantiza disponibilidad futura; se revalida en Parte B. Rechazar exceso de precisión sin truncar silenciosamente.

El servidor recalcula con las condiciones originales de §10 y compara `importeConfirmado` numéricamente con escala comercial 2. El valor remitido no es autoridad de cálculo. Debe ser positivo y representable como exige el modelo vigente; no inferir tolerancia de un centavo. Se exige correspondencia entre oferta, cantidad, importe y cotización/intento; contenido presente, seguro, recuperable e íntegro, declaración estructurada y fecha/hora de mensaje coherente. Se conserva instante del mensaje separado del instante servidor de registro; normalización temporal y eventual tolerancia de relojes/canales deben decidirse, sin inventar plazos.

`declaracionIdentidadVendedor` requiere texto no vacío con al menos 20 caracteres no blancos; debe identificar canal, contacto cotejado, relación con el cliente, referencia de cotización y comprobación declarada por el vendedor. La longitud no acredita identidad ni veracidad. La validación estructurada de esos componentes debe definirse en CR-C; no se presume validación semántica automática del texto libre.

### 5.3. Catálogo conceptual de errores

| Identificador de trabajo | Situación y efecto |
|---|---|
| ERR-EVIDENCIA-INEXISTENTE | Parte B no encuentra respaldo asociado; no transferir |
| ERR-OFERTA-INEXISTENTE | No exponer datos ni registrar respaldo huérfano |
| ERR-OFERTA-NO-PENDIENTE | No registrar nueva conformidad ni reasignar una oferta cerrada |
| ERR-PEDIDO-NO-PERMITIDO | Pedido fuera del estado/ámbito canónico; rechazar |
| ERR-CANTIDAD-INVALIDA | Rango, precisión o correspondencia inválidos |
| ERR-IMPORTE-DISCREPANTE | Importe no coincide con cálculo servidor de las condiciones originales |
| ERR-COTIZACION-DISCREPANTE | Referencia/intento no corresponde a cantidad e importe que se pretenden confirmar |
| ERR-EVIDENCIA-DUPLICADA | Repetición a resolver según idempotencia y estado, sin duplicar intentos por reenvío |
| ERR-EVIDENCIA-UTILIZADA | No consumir una misma conformidad en otra transferencia |
| ERR-EVIDENCIA-INVALIDADA | Evidencia terminal no apta; no reactivarla |
| ERR-CONTENIDO-INVALIDO | Vacío, inseguro, tipo discordante u otra política aprobada incumplida |
| ERR-USUARIO-NO-AUTORIZADO | Sin permiso VENDEDOR/ámbito, sin herencia ADMIN |
| ERR-CONCURRENCIA | Cambio incompatible de oferta, pedido, evidencia o disponibilidad; rechazo controlado y atómico |

Son identificadores propuestos, no códigos públicos aprobados. Mensajes, HTTP definitivos y diferencia entre repetición idempotente y error deben resolverse en CR-C. No convertir conflictos esperables en errores 500 no tratados.

### 5.4. Rechazo de oferta y evidencia inválida

`registrarRespuestaOfertaExcedente(idOfertaExcedente, false, null)` no exige evidencia de aceptación. La oferta pasa a RECHAZADA con fecha de respuesta conforme G0, sin transferencia ni incremento aceptado. Se propone invalidar atómicamente las evidencias CAPTURADA/VERIFICADA aún vigentes con motivo de rechazo y eventos; UTILIZADA/INVALIDADA permanecen terminales. La formalización de esa propagación pertenece a CR-C/CR-F.

Un fallo de validación de nueva evidencia no invalida la anterior ni confirma la reasignación. Como propuesta, los contenidos seguros que fallen validaciones comerciales podrían conservarse como CAPTURADA → INVALIDADA únicamente bajo una política explícita de intentos fallidos y retención; sigue pendiente autorizar ese comportamiento. Un archivo inseguro no se persiste como evidencia para poder justificar el rechazo. El registro seguro de metadatos de rechazo, su transacción y retención deben definirse, sin debilitar controles para almacenar contenido malicioso ni confirmar parcialmente una sustitución fallida.

## 6. Modelo relacional propuesto: sujeto íntegramente a CR-F

### 6.1. EVIDENCIA_ACEPTACION_OFERTA

| Campo propuesto | Naturaleza / justificación |
|---|---|
| `idEvidenciaAceptacionOferta` | Identificador; tipo y generador coordinado por definir |
| `idOfertaExcedente` | FK a oferta; asociación obligatoria |
| `numeroIntento` | Secuencia por oferta; correlación y unicidad concurrente por definir |
| `codigoCotizacion` | Referencia comercial según §8, sin confundir oferta con versión parcial |
| `cantidadConfirmada NUMERIC(18,3)` | Cantidad expresamente confirmada |
| `importeConfirmado NUMERIC(18,2)` | Importe contrastado contra cálculo del servidor |
| `canalComunicacion` | Canal verificable; catálogo definitivo pendiente |
| `referenciaContacto` | Identifica contacto cotejado; campo adicional justificado para no perder el dato obligatorio en texto libre |
| `fechaHoraMensaje` | Instante declarado del mensaje, conservando referencia temporal |
| `fechaHoraRegistro` | Instante servidor de captura, independiente del mensaje |
| `idUsuarioRegistro` | FK a usuario autenticado, nunca identidad impuesta por HTTP |
| `declaracionIdentidadVendedor TEXT NOT NULL` | Al menos 20 caracteres no blancos y componentes de §5.2; no autenticación criptográfica |
| `contenidoOriginal BYTEA` | Bytes documentales originales en PostgreSQL, orientación P2b |
| `tipoMimeContenido` | Tipo validado; conservar declaración/detección si se justifica en diseño definitivo |
| `nombreArchivoOriginal` | Descriptivo opcional, no confiable como ruta ni como detector de formato |
| `huellaContenido` | SHA-256 calculado por servidor sobre los bytes efectivamente conservados; representación por definir |
| `estadoEvidencia` | CAPTURADA, VERIFICADA, UTILIZADA o INVALIDADA |

Longitudes, nulabilidad restante, identificadores, FKs, políticas de borrado, checks y claves se concretarán en CR-F. No se autoriza SQL mediante esta tabla ni se presume idempotencia a partir de `numeroIntento`.

### 6.2. Contenido, huella y recuperación

Evaluar con muestras representativas de capturas WhatsApp e imágenes comprimidas el tamaño típico, legibilidad de cifras/textos, límites por solicitud y almacenamiento, consumo de memoria y respaldo. Definir inspección de contenido potencialmente malicioso, detección real del tipo y rechazo de desacuerdo con MIME declarado, lectura/descarga autorizadas, protección de datos personales, retención/eliminación y recuperación para auditoría. PDF sigue pendiente. No se fija un límite de 512 KB, lista cerrada de MIME ni compresión automática.

La huella se calcula en servidor sobre los bytes almacenados y se verifica al recuperar. No efectuar transformaciones silenciosas posteriores; una eventual representación derivada no sustituye el original sin decisión expresa. SHA-256 aporta integridad frente a una comparación confiable; no prueba autenticidad del remitente, veracidad de la captura ni resistencia frente a quien pudiera reemplazar simultáneamente contenido y huella. Las protecciones de acceso/auditoría complementarias son necesarias.

### 6.3. EVENTO_ESTADO_EVIDENCIA_OFERTA

Se propone bitácora append-only con identificador de evento, evidencia, estado anterior, estado nuevo, motivo, fecha/hora servidor y usuario responsable. El registro inicial podrá representar origen sin estado previo → CAPTURADA, como evento de creación, no como una nueva transición de negocio. Las transiciones automáticas conservan al vendedor autenticado responsable y dejan constancia de que la validación fue del servidor; no inventan un aprobador humano.

El conjunto de eventos debe permitir reconstruir el estado actual y el orden de cambios aun con instantes iguales. Tipo/generador y orden inequívoco de eventos están pendientes. CR-F evaluará restricciones y permisos que impidan UPDATE/DELETE no autorizados sobre historial y alteración del contenido utilizado. Una convención Java no basta para afirmar inmutabilidad física.

### 6.4. Unicidad a evaluar

Evaluar índices únicos parciales: máximo una evidencia VERIFICADA por oferta y máximo una UTILIZADA por oferta. Son candidatos, no índices aprobados. La cardinalidad de una aceptación por oferta resulta coherente con G0 y `uq_movimiento_excedente_0`, pero debe validarse el ciclo completo de creación, sustitución, uso y cierre antes de aprobarlos.

Ambos índices por separado permitirían una VERIFICADA y una UTILIZADA simultáneas; por eso no sustituyen el bloqueo y la comprobación de oferta PENDIENTE ni la prohibición de nuevas conformidades después de aceptar. La unicidad por `(idOfertaExcedente, numeroIntento)` y la detección por huella también requieren diseño y aprobación, sin serialización basada en MAX+1 sin coordinación.

## 7. Estados, transiciones y conservación histórica

| Estado | Significado |
|---|---|
| CAPTURADA | Respaldo recibido; aún no habilita transferencia |
| VERIFICADA | Datos técnicos/comerciales validados automáticamente; no prueba criptográfica de remitente |
| UTILIZADA | Evidencia consumida por una confirmación física atómica |
| INVALIDADA | Respaldo descartado para futuros usos, conservando historial y motivo |

Transiciones admitidas: CAPTURADA → VERIFICADA; CAPTURADA → INVALIDADA; VERIFICADA → UTILIZADA; VERIFICADA → INVALIDADA. UTILIZADA e INVALIDADA son terminales; no se reactivan ni se borran como sustituto de eventos.

Toda transición conserva usuario, fecha/hora, estado anterior/nuevo y motivo. CAPTURADA y su validación pueden ocurrir en una única transacción de O2, conservando ambos eventos aunque el estado intermedio no sea visible externamente. Una evidencia solo CAPTURADA no satisface Parte B. No se introduce otro rol aprobador ni un estado EXPIRADA en oferta o evidencia.

## 8. Cotización, recotización, sustitución e idempotencia

### 8.1. Código previo y ambigüedad por intento

Se conserva como orientación previa, sin cambiar unilateralmente su algoritmo:

```text
SHA-256(idOfertaExcedente + cantidadOfrecida + importeInformado + timestampOferta)
```

No implica persistirlo en OFERTA_EXCEDENTE. La serialización canónica de identificadores, decimales, separadores, instante, zona y precisión está pendiente; concatenar texto sin un formato definido no garantiza una codificación inequívoca.

**Hallazgo:** dos recotizaciones parciales de la misma oferta, por cantidades distintas, comparten los cuatro componentes originales. El código identifica la oferta, pero por sí solo no identifica cada par cantidad/importe confirmado. No es una colisión criptográfica: la entrada es la misma. La fecha del mensaje tampoco sustituye una correlación comercial explícita.

**Decisión pendiente:** definir en CR-C/CR-F una referencia por intento o versión, por ejemplo correlación conjunta `(codigoCotizacion, numeroIntento)` vinculada a cantidad e importe calculados por servidor. Es una propuesta para aprobación, no un reemplazo ya adoptado del hash. Debe decidirse cómo se emite, comunica y conserva la cotización antes del mensaje y qué intento es el vigente. O2 registra evidencia posterior y no puede inventar retrospectivamente que el cliente respondió a una versión no identificada. Se bloquea la confirmación dependiente hasta resolver este vínculo. Una nueva cantidad nunca reutiliza silenciosamente la conformidad de una cotización anterior.

### 8.2. Sustitución atómica

Protocolo propuesto de O2: bloquear oferta y evidencias relevantes según orden global pendiente; validar completamente el nuevo respaldo y sus condiciones; solo entonces invalidar la evidencia VERIFICADA anterior con motivo `SUPERADA_POR_RECOTIZACION`; registrar la nueva CAPTURADA → VERIFICADA y los eventos; confirmar como unidad transaccional.

Si falla contenido, correspondencia, cálculo, inserción, evento o transición, rollback completo y la anterior permanece VERIFICADA. No hay una ventana confirmada donde la anterior esté INVALIDADA sin sustituta válida. La comprobación y cambio deben serializarse con Parte B para que una evidencia no sea utilizada mientras otra transacción la sustituye. Índices, orden interno y manejo de fallos deben probarse con PostgreSQL, no presumirse.

### 8.3. Duplicado de archivo, duplicado semántico y reintento

Evaluar detección `(idOfertaExcedente, huellaContenido)`. Una repetición ya VERIFICADA/UTILIZADA no crea una segunda aceptación. La política exacta de rechazo o devolución de la evidencia anterior queda en CR-C. La misma huella en una INVALIDADA no la reactiva: debe decidirse si se admite otro intento documentado o se rechaza, conservando la historia y el motivo.

Un reintento HTTP de la misma operación debe distinguirse de un nuevo intento de cotización. Se propone evaluar una clave de operación estable, alcance por oferta y validación del mismo payload; almacenamiento y respuesta idempotente siguen pendientes. Un número de intento asignado nuevamente a cada reenvío no resuelve idempotencia. Dos archivos distintos pueden documentar el mismo mensaje/aceptación; dos hashes distintos no autorizan dos transferencias. Revalidar correlación y estado de oferta además de la huella. No se promete exactamente una vez sin ese diseño.

### 8.4. Vigencia

No se crea TTL propio ni se agrega EXPIRADA a OFERTA_EXCEDENTE. La aptitud para usar evidencia depende del estado de oferta y pedido y de las condiciones identificadas. La antigüedad no habilita ni anula por sí sola. Entrega, cancelación, rechazo o sustitución requieren verificar/instrumentar la invalidación trazable aplicable; reglas físicas de esa propagación se aprobarán en CR-C/CR-F. Nunca se altera una evidencia terminal para ocultar una operación.

## 9. RT-UC07-02: auditoría de precio y alternativas

### 9.1. Hechos, inferencias y pruebas pendientes

| Categoría | Resultado y límite |
|---|---|
| Hecho: persistencia actual | OFERTA_EXCEDENTE guarda fecha e importes escala 2, no `idPrecio`/`precioBaseUnitarioAplicado`. PRECIO_PRODUCTO guarda precio escala 4. PEDIDO guarda tipo y porcentaje congelados |
| Hecho: máximo un precio | V1 incluye `ex_precio_producto_no_solape` GiST sobre `[desde,hasta)` por producto, solo no cancelados. `ck_precio_producto_1` solo comprueba un intervalo; no es la garantía de exclusividad entre filas |
| Hecho: existencia | La exclusión no asegura que exista un precio: pueden existir huecos. Debe exigirse exactamente uno, excluyendo cancelados |
| Hecho: historia por UC-19 | Cierre prospectivo, nueva fila y auditoría atómicos; normalización a microsegundos, rechazo de retroactividad. No hay trigger de inmutabilidad de PRECIO_PRODUCTO en el DDL examinado |
| Inferencia condicionada | Si selección e instante coinciden y todos los escritores preservan el historial, puede recuperarse P por fecha. Un cambio prospectivo a P2 no obliga a abandonar P para la oferta anterior |
| Hipótesis a probar | Lectura de precio frente a programación concurrente, espera de locks y captura del instante; ausencia de protección suficiente frente a escrituras no cooperantes |
| Dictamen previo | **NO DEMOSTRADO** para suficiencia integral temporal; no son cinco errores de UC-07 comprobados, porque UC-07 aún no tiene implementación funcional |

La pérdida matemática de información al invertir importes redondeados no demuestra imposibilidad de reconstrucción por historial temporal. Tampoco el éxito de pruebas UC-19 certifica UC-07.

### 9.2. Alternativas de conservación comercial

| Alternativa | Integridad y auditoría | Compatibilidad y cambios físicos | Complejidad / efecto en evidencia |
|---|---|---|---|
| A — reconstrucción temporal | Depende de historia preservada y captura coherente; consulta por producto y fecha original, nunca precio actual | Compatible con estructura actual; no requiere necesariamente columnas. Suficiencia integral no demostrada | Coordinación temporal y de escritores esencial; evidencia requiere una resolución histórica demostrable |
| B — snapshot en oferta | Conserva directamente P y facilita recotización/auditoría posterior; inmutabilidad por diseñar | Mantiene D2-A, pero exige CR-F y aprobación física. Precio aplicado y eventual procedencia | Reduce dependencia posterior del historial; no elimina coordinación inicial. Evidencia se vincula a oferta y condiciones originales |
| C — snapshot comercial independiente | Permite versiones y conjuntos comerciales independientes | Tabla/relaciones nuevas sujetas a CR-F, mayor revisión de modelo | Más ciclo de vida y concurrencia; necesidad no demostrada para MVP; no confundirlo con P2b de respaldo documental |

### 9.3. Recomendación B para ratificación, no decisión física aprobada

**ALTERNATIVA B RECOMENDADA — PENDIENTE DE RATIFICACIÓN FORMAL.** Proponer en OFERTA_EXCEDENTE `precioBaseUnitarioAplicado NUMERIC(18,4)` y `idPrecio BIGINT` de procedencia, cuya obligatoriedad y FK deben definirse. La CR-F debe proteger el precio congelado y la procedencia contra modificaciones no autorizadas, garantizar precio positivo y correspondencia con el producto del excedente y decidir qué escritor puede crear la oferta. Una FK por sí sola no congela el valor de PRECIO_PRODUCTO ni evita cambiar el `idPrecio` de la oferta.

La información pertenece a la oferta, no exclusivamente a la evidencia: P se selecciona al emitir, mientras que la aceptación es posterior y puede no ocurrir. El snapshot evita volver al catálogo para recotizar, pero puede congelar un precio mal elegido si falla la captura inicial. No se declara RT-UC07-02 resuelta por recomendar B.

## 10. Cálculo comercial reproducible

La regla funcional D2-A ya ratificada conserva el precio P vigente al crear la oferta y el ajuste del pedido receptor. **Si B se ratifica e implementa**, P se obtiene de `precioBaseUnitarioAplicado`; el almacenamiento propuesto sigue pendiente. Nunca obtenerlo por inversión de importeInformado, por precio vigente al responder, por nueva categoría del cliente ni mediante otra ejecución de UC-15/UC-16.

```java
BigDecimal subtotal = q.multiply(P)
    .setScale(2, RoundingMode.HALF_UP);

BigDecimal ajuste = subtotal.multiply(r)
    .divide(new BigDecimal("100"), 2, RoundingMode.HALF_UP);

// SIN_AJUSTE: subtotal
// DESCUENTO: subtotal.subtract(ajuste)
// RECARGO: subtotal.add(ajuste)
```

`q` se valida con escala máxima 3 y P conserva 4 decimales; `r` y tipo son los congelados del pedido. Para SIN_AJUSTE el ajuste es cero. Conservar el orden: redondear subtotal a 2 y ajuste a 2; un único redondeo del producto compuesto puede dar otro centavo. Verificar rango NUMERIC e importe positivo; una combinación que produzca cero (por ejemplo descuento total o redondeo de cantidades pequeñas) no permite relajar `ck_oferta_excedente_1/3`. El tratamiento contractual de esos casos debe concretarse antes de implementar, sin inventar un mínimo comercial.

Si `cantidadAceptada == cantidadOfrecida`, `importeAceptado = importeInformado` exactamente, conforme D2-A. Si es menor, recalcular con P y ajuste originales, presentar el nuevo par cantidad/importe, obtener conformidad expresa y vincular respaldo verificable antes de transferir. No prorratear el importe inicial redondeado como sustituto de la fórmula.

Ejemplos de la auditoría aritmética con BigDecimal (no pruebas de aplicación): P=123.4567, cantidad ofrecida 2.345, parcial 0.777, r=12.50%. Con descuento: importe inicial 253.32, subtotal parcial 95.93, ajuste 11.99, parcial 83.94. Con recargo: inicial 325.70, mismo subtotal/ajuste, parcial 107.92. Si se usara indebidamente P2=150.0000, resultarían 101.98 y 131.12 respectivamente.

P=1.0037 y P=1.0103, cantidad ofrecida 1.111 y descuento 12.50%, producen ambos importe inicial 0.98, pero parcial 0.777 produce 0.68 y 0.69. Con recargo 12.50%, ambos iniciales son 1.26 y los parciales 0.88/0.89. Por tanto, incluso con cantidad y ajuste conocidos no se puede recuperar inequívocamente P desde el importe inicial. Ejemplo de orden de redondeo: q=0.050, P=1.0000, descuento 10%; subtotal 0.05, ajuste 0.01, final 0.04; un único redondeo final daría 0.05.

## 11. Concurrencia, captura inicial y Parte B

### 11.1. Captura comercial de Parte A: protocolo de referencia no probado

1. Iniciar transacción; validar sesión, permisos y condiciones canónicas de excedente/pedido/producto.
2. Obtener el bloqueo sobre PRODUCTO coordinado con UC-19, en el orden global que resuelva RT-UC07-04.
3. Después de obtener los bloqueos capaces de causar una espera relevante para la selección, obtener el instante efectivo de PostgreSQL y revalidar condiciones.
4. Buscar precio con `vigenteDesde <= instante AND (vigenteHasta IS NULL OR vigenteHasta > instante) AND fechaHoraCancelacion IS NULL`; exigir exactamente uno. No resolver ambigüedad con LIMIT 1.
5. Capturar conjuntamente idPrecio, precioBase e instante utilizado; leer de forma consistente tipo/porcentaje congelados del pedido.
6. Calcular importeInformado e insertar la oferta con el snapshot propuesto y `fechaHoraOferta` igual al instante efectivo de selección, si esta semántica se aprueba. Confirmar atómicamente, sin reservar stock ni crear detalle.

UC-19 bloquea PRODUCTO FOR UPDATE, después toma su instante y espera el lock asesor 1919001 antes de bloquear períodos. El protocolo candidato debe revisar compatibilidad de modo de lock y orden con UC-19, UC-47/48 y con EXCEDENTE/PEDIDO/evidencia en UC-05/06/07/41. No basta declarar PRODUCTO FOR UPDATE suficiente ni agregar locks sin examinar ciclos y generadores compartidos. Modo exacto, aislamiento, relecturas, reintentos y traducción de conflictos quedan pendientes de RT-UC07-04. Un snapshot correcto no garantiza ausencia de deadlocks.

### 11.2. Instante PostgreSQL

`transaction_timestamp()`/`now()` fijan el inicio de transacción; `statement_timestamp()` fija el inicio de sentencia. Ambos pueden preceder a una espera por lock, incluso si se evalúan después dentro de esa misma sentencia. Como referencia se propone una consulta de `clock_timestamp()` **posterior a la adquisición efectiva de los bloqueos**, reutilizando su valor en selección, cálculo e inserción, con precisión de microsegundos consistente con TIMESTAMPTZ. No tomar un reloj previo a la espera ni volver a llamar al reloj independientemente para fechaHoraOferta.

El nivel de aislamiento y snapshot MVCC deben permitir que la búsqueda posterior al bloqueo vea la programación comprometida pertinente; el reloj por sí solo no garantiza visibilidad. Debe probarse el límite exacto y la carrera con una programación UC-19 no confirmada, incluida su espera por identificadores. Si se necesita otro instante de auditoría de inserción, justificarlo en CR-F; no sobrecargar fechaHoraOferta con dos significados ni añadir columnas sin aprobación.

### 11.3. Confirmación de Parte B

Para aceptada=true, exigir evidencia existente, VERIFICADA, no utilizada, asociada a oferta y correspondiente a cantidad, importe y cotización/intento vigente. Con la firma G0 intacta, se propone resolver el respaldo por la oferta y la unicidad aprobada; si no hay selección inequívoca, rechazar. La firma no recibe un importe arbitrario ni un nuevo idEvidencia.

Una única transacción obtiene locks en orden aprobado, revalida sesión, oferta PENDIENTE, pedido PENDIENTE, disponibilidad física, costo histórico y cantidad; bloquea/resuelve evidencia y calcula el importe original; ejecuta reasignación, crea/reutiliza detalle técnico D1-B cuando corresponda, actualiza oferta a ACEPTADA, marca evidencia UTILIZADA y registra evento. Confirma todo o nada. La oferta no devenga CARGO_POR_VENTA ni efectivo en tránsito; esas responsabilidades siguen en UC-05/29 según sus fuentes.

La confirmación, rechazo, sustitución y reintentos deben serializarse sin doble consumo. La política para repetir una confirmación ya exitosa queda pendiente de CR-C: no confundir devolver el mismo resultado con reutilizar evidencia para otra transferencia.

### 11.4. E07: pérdida de disponibilidad

Si UC-41 u otra aceptación consume el excedente antes de confirmar, rechazar sin transferir stock, sin aumentar importeAceptado ni marcar evidencia UTILIZADA. Rollback de la transacción de Parte B; la evidencia de O2, previamente confirmada en otra transacción, permanece VERIFICADA. Una futura decisión de rechazo/sustitución debe invalidarla con motivo y trazabilidad. No invalidarla dentro de una confirmación fallida ni suponer que disponibilidad perdida autoriza una nueva cantidad sin conformidad.

## 12. Pruebas obligatorias y estado de validación

Para **cada fila y escenario** siguiente: **ESPECIFICADA — NO IMPLEMENTADA — NO EJECUTADA — NO APROBADA** en este corte. La especificación no acredita funcionamiento. Las pruebas documentales del PR se reportan aparte; no alteran estos estados. UC-19 tiene tests existentes, pero no sustituyen pruebas específicas de ofertas/evidencias.

### 12.1. Evidencia y aceptación

| ID | Escenario | Resultado exigido al implementarlo |
|---|---|---|
| E01 | Evidencia válida | CAPTURADA → VERIFICADA, datos/contenido/eventos consistentes |
| E02 | Rechazo sin evidencia previa | Oferta RECHAZADA; sin transferencia ni evidencia de aceptación obligatoria |
| E03 | Aceptación sin evidencia | Rechazo controlado, sin movimiento ni cambio parcial |
| E04 | Cantidad diferente | No consumir respaldo de otra cantidad |
| E05 | Importe distinto del cálculo | Rechazo; no tomar importe HTTP como autoridad |
| E06 | Reutilizar evidencia UTILIZADA | No segunda transferencia; respuesta según política idempotente aprobada |
| E07 | Pérdida concurrente de stock | Rollback Parte B; respaldo previo permanece VERIFICADA |
| E08 | Recotización parcial | Usa P y ajuste originales; nueva conformidad sobre par exacto |
| E09 | Sustituta válida | Invalidación anterior y nueva VERIFICADA atómicas con eventos |
| E10 | Sustituta inválida o fallo de inserción/transición | Anterior VERIFICADA permanece intacta |
| E11 | Recuperación y huella | Bytes almacenados/recuperados y SHA-256 coinciden |
| E12 | Actor sin VENDEDOR=D | Denegado, incluido ADMIN sin VENDEDOR; no filtrar datos personales |
| E13 | Historial y terminales | Secuencia reconstruible; sin salidas de UTILIZADA/INVALIDADA |
| E14 | Duplicación de evidencia | Diferenciar reenvío, contenido repetido y aceptación semántica, sin doble consumo |
| E15 | Dos recotizaciones de una oferta | Una respuesta vieja no habilita condiciones nuevas; demostrar correlación por intento |
| E16 | Sustitución concurrente con confirmación/rechazo | Serialización coherente sin doble uso, ventana confirmada ni deadlock |
| E17 | Doble O2 y doble confirmación concurrentes | Cumplir unicidad y generadores; no crear dos VERIFICADA/UTILIZADA indebidas |
| E18 | Oferta/pedido no permitidos, mensaje temporal incoherente o declaración insuficiente | Rechazo sin degradar respaldo válido; tolerancias solo si aprobadas |
| E19 | Rechazo con evidencia pendiente | Invalidación de CAPTURADA/VERIFICADA y eventos atómicos, historia terminal intacta |

### 12.2. Archivos y acceso

| ID | Escenario | Resultado exigido |
|---|---|---|
| F01 | Tamaño superior al límite aprobado | Rechazo sin cargas descontroladas; el límite sigue pendiente |
| F02 | MIME declarado discordante del detectado | Rechazo, no confiar en extensión/nombre |
| F03 | Contenido vacío o ilegible | No VERIFICADA; legibilidad humana/técnica delimitada sin prometer OCR |
| F04 | Contenido potencialmente peligroso | No conservar archivo inseguro como evidencia; registro seguro de rechazo según política |
| F05 | Lectura/descarga no autorizada y datos personales | Denegación y trazabilidad según política aprobada, sin exposición por rol superior |
| F06 | PDF | Ejecutar solo si se aprueba admisión y seguridad; actualmente no aprobado |
| F07 | Bytes, huella y transformaciones | Sin cambios silenciosos; recuperación íntegra y controles de acceso |
| F08 | Retención, respaldo y recuperación | Demostrar política aprobada sin borrar historia usada ni perder trazabilidad |

### 12.3. Precio y RT-UC07-02

| ID | Escenario | Resultado exigido |
|---|---|---|
| P01 | Crear oferta con precio vigente | Snapshot coincide con único precio del instante efectivo |
| P02 | Cambiar precio después | Oferta conserva P, procedencia e importe inicial |
| P03 | Parcial posterior al cambio | Recalcula con P y exige conformidad; no usa P2 |
| P04 | UC-07 concurrente con UC-19 | Selección/captura coherentes y conflictos controlados |
| P05 | Inicio inclusivo y fin exclusivo exactos | Selecciona período correcto; sin error por precisión de microsegundos |
| P06 | Hueco sin precio vigente | Rechazo contractual, cero oferta inventada |
| P07 | Precio cancelado | No seleccionarlo; distinguir período cancelado de precio histórico válido |
| P08 | Modificación directa no autorizada del snapshot | Protección física efectiva por mecanismo aprobado, sin modificar precios de otras ofertas |
| P09 | Integridad de idPrecio | Procedencia/producto coherentes y política de obligatoriedad/FK verificada |
| P10 | BigDecimal, recargo, descuento y sin ajuste | Escalas 3/4/2, doble redondeo, aceptación total, límites, cero y overflow controlados |
| P11 | Espera de locks e instante | Reproducir reloj anterior/posterior y visibilidad concurrente; no congelar un precio erróneo |
| P12 | Registros preexistentes en futura migración | Plan autorizado, sin inversión de importes ni relleno ficticio; rollback/compatibilidad demostrados |

Añadir regresión UC-03: creación original, línea técnica nueva y reutilizada, replay con UUID original y `cantidadItems`/`totalOriginal` preservados. Añadir las carreras UC-07/41/05/06 y generadores de RT-UC07-04 con PostgreSQL/Testcontainers y evidencia GitHub Actions del commit funcional. Ninguna está declarada ejecutada por este borrador.

## 13. Riesgos residuales y decisiones pendientes

| Punto | Riesgo / resolución necesaria |
|---|---|
| Identidad y contenido manual | Hash/declaración no autentican remitente ni garantizan significado; asumir y revisar el riesgo residual sin ocultarlo |
| Archivos y datos personales | Tamaños, MIME, PDF, inspección, legibilidad, lectura, retención y restauración pendientes antes de CR-F definitiva |
| Snapshot B | Ratificación formal, inmutabilidad y selección atómica inicial pendientes; no cerrar RT-UC07-02 |
| Procedencia idPrecio | Obligatoriedad, FK, integridad producto/oferta y protección de modificaciones pendientes |
| Recotizaciones | Hash de oferta insuficiente por intento; falta decidir emisión/correlación y caducidad lógica de cotizaciones previas sin TTL inventado |
| Duplicados e idempotencia | Huella no prueba unicidad semántica; falta clave/protocolo HTTP y política para INVALIDADA/repetición de confirmación |
| Unicidad y auditoría | Índices parciales, generadores, terminales, append-only y permisos pendientes de diseño físico |
| Concurrencia | Orden global, aislamiento MVCC y manejo de conflictos UC-19/05/06/07/41 pendientes; hipótesis no equivale a prueba |
| Histórico | No rellenar precio desde importes invertidos; estrategia para ofertas previas sin snapshot requiere aprobación y evidencia |
| Productos desactivados | Subsisten casos históricos RT-UC07-01 del antecedente; no otorgar permisos ni cancelar de oficio |
| Importes cero y límites | Concretar error/validación cuando fórmula no satisface constraints, sin cambiar ck_oferta_excedente_3 |
| Reconciliación contractual | RD-UC07-001 §8 condiciona activar CR-C a demostrar imposibilidad de preservar G0; este encargo pide proponer O2 y una CR-C auxiliar. Se detiene aquí la decisión de activar/modificar esa condición. El responsable debe resolver expresamente su alcance antes de autorizar CR-C. No se concluye que O2 obligue a cambiar la firma principal ni se altera la RD antecedente |

Esta consolidación no encontró decisiones posteriores en `main` que ratifiquen B, aprueben archivos o autoricen CR-F. Las diferencias históricas de redacción del antecedente sobre el merge de PR #45 no alteran el hecho verificado de §1.1 ni se corrigen en ese archivo.

## 14. Reservas y puertas de implementación

| Reserva | Estado conservado / propuesto para revisión |
|---|---|
| RT-UC07-01 | Opción A ratificada; casos históricos específicos aún sujetos al antecedente |
| RT-UC07-02 | **ALTERNATIVA B RECOMENDADA — PENDIENTE DE RATIFICACIÓN FORMAL Y CR-F**; reconstrucción temporal NO DEMOSTRADA |
| RT-UC07-03 | **ORIENTACIÓN FUNCIONAL Y ARQUITECTÓNICA APROBADA — CONSOLIDADA EN ESTE BORRADOR; PENDIENTE DE REVISIÓN/RATIFICACIÓN DE LA RD Y AUTORIZACIÓN DE CR**; decisiones físicas específicas de archivos abiertas |
| RT-UC07-04 | **ABIERTA:** diseño/orden global y coordinación UC-19 antes de implementar transacciones; pruebas reales de concurrencia/rollback antes del merge funcional |
| Regresión UC-03 | Corrección independiente pendiente; antes del merge funcional de UC-07 |

El futuro fix de replay debe contar líneas originales conservando la correlación por pedido, por ejemplo agregando `AND d."cantidadOriginal" > 0`. No se implementa aquí ni se generaliza ese filtro a consumidores que necesitan adicionales.

**Para iniciar las transacciones afectadas:** esta RD revisada y ratificada; RT-UC07-02 definida y cambios físicos autorizados; RT-UC07-03 formalizada con contrato/persistencia aprobados; CR-C y CR-F presentadas y autorizadas con la reconciliación de §13; política de contenido, correlación e idempotencia definida; diseño RT-UC07-04 aprobado y compatibilidad UC-19 demostrable por diseño. Ninguna aprobación se presume por publicar o fusionar este borrador.

**Para fusionar código funcional:** ejecutar y aprobar pruebas específicas de evidencia, precio, redondeo, inmutabilidad, archivos y concurrencia real/rollback en PostgreSQL; resolver generadores e índices aprobados; fix UC-03 y regresión verdes; evidencia CI del commit. Las pruebas de implementación pertenecen a ese corte y no se exigen como prueba ya ejecutada para comenzar a diseñarlo o programarlo tras las autorizaciones previas.

**Para desplegar/activar:** cumplir gates de seguridad y aceptación aplicables. Issue #28 abierta bloquea producción salvo autorización explícita conforme al procedimiento del proyecto. Desarrollo/CI documental no equivale a despliegue; no se cambian flags, perfiles, infraestructura ni el estado de la issue.

## 15. Anexo: alcance propuesto de CR-C y CR-F

**ALCANCE PROPUESTO — CR NO CREADAS NI AUTORIZADAS.** Los nombres/identificadores siguientes son provisionales, sujetos a nueva verificación al redactar; no se crean archivos ni se reserva numeración mediante esta RD.

### 15.1. CR-C — contractual

Identificador sugerido `CR-B0-UC07-001`; archivo futuro sugerido `CR_B0_UC07_001_CONTRATO_AUXILIAR_EVIDENCIA_<fecha>.md`.

Alcance candidato: contrato de `registrarEvidenciaAceptacionOferta` subordinada a UC-07, entrada/salida, autorización VENDEDOR=D, errores y HTTP definitivos, validación de respaldo, reintentos/idempotencia, cotizaciones e intentos, rechazo e invalidación de pendientes, selección/consumo de evidencia y transición auditada. Preservar firma canónica de tres parámetros de Parte B; no cambiar contratos G0 ni catálogo principal de 64 CU/67 operaciones en este PR. Registrar en el futuro cualquier operación auxiliar separadamente y con trazabilidad.

**Decisión de activación detenida:** resolver primero con el responsable la condición de RD-UC07-001 §8 señalada en §13. El encargo autoriza proponer el alcance, no declarar imposible preservar G0 ni activar esa CR automáticamente. No se elige una modificación de firma principal como atajo.

### 15.2. CR-F — física

Identificador sugerido `CR-B0-UC07-002`; archivo futuro sugerido `CR_B0_UC07_002_EVIDENCIA_ACEPTACION_OFERTA_<fecha>.md`.

**Alcance A, evidencia:** EVIDENCIA_ACEPTACION_OFERTA y EVENTO_ESTADO_EVIDENCIA_OFERTA, relaciones/FKs, campos y estados de §6–7, identificadores/generadores, constraints e índices que se aprueben, almacenamiento original P2b en PostgreSQL, inspección/límites de archivos aún pendientes, protección de contenido/eventos, lectura/retención, unicidad y correlación/idempotencia.

**Alcance B, snapshot:** proponer `precioBaseUnitarioAplicado NUMERIC(18,4)` en OFERTA_EXCEDENTE, `idPrecio BIGINT` como procedencia con obligatoriedad/FK pendientes, precio válido, correspondencia con producto, protección del valor y procedencia, captura compatible con UC-19, tratamiento de ofertas existentes y pruebas concurrentes. La restricción temporal existente no se sustituye ni se debilita. La política de histórico no puede inferir un valor exacto invirtiendo importeInformado ni usar el precio actual como relleno.

Pueden agruparse A/B en una CR-F solo si se demuestra coherencia y el responsable aprueba expresamente cada cambio y su trazabilidad. Una CR única no autoriza todo lo mencionado por mera inclusión. Antes de implementar, obtener la secuencia efectiva de Flyway; no nombrar V4 anticipadamente ni editar V1/V2/V3 o migraciones aplicadas. Incluir plan de compatibilidad, datos preexistentes, verificación/rollback y protección del snapshot según el diseño autorizado.

**Exclusiones:** ningún DDL ejecutado; ningún cambio aquí a ck_oferta_excedente_3, firmas principales G0, catálogo, source-lock, RDs ratificadas, implementación o columnas/tablas fuera del alcance que se autorice. CR-F no es la CR-B0-F04-001 de sincronización/efectivo en tránsito ni incorpora ese dominio.

### 15.3. Decisiones necesarias antes de autorizar las CR

1. Revisión y ratificación formal de esta RD, con B aceptada o alternativa expresamente elegida y alcance O2/P2b confirmado.
2. Reconciliar la condición de activación CR-C del antecedente y aprobar contrato auxiliar, reintentos y selección de evidencia preservando G0.
3. Aprobar correlación por intento/versión, serialización del código, y tratamiento de cotización superada y duplicados.
4. Resolver límites/MIME/PDF/seguridad, acceso y datos personales; no autorizar un esquema incompleto que eluda estas políticas.
5. Definir idPrecio, obligatoriedad/FK, inmutabilidad, política de datos previos e integridad del precio aplicado.
6. Aprobar cardinalidades, índices, bitácora, generadores y protocolos transaccionales, incluyendo separación O2/Parte B.
7. Diseñar coordinación UC-19/RT-UC07-04, aislamiento/relojes y plan de pruebas; distinguir diseño previo de ejecución posterior en CI.
8. Mantener trazabilidad de cada cambio físico/contractual y del fix UC-03 independiente, sin conceder despliegue.

## 16. Revisión, firmas y límites de esta entrega

**Documento presentado para revisión:** RD-UC07-002, borrador de trabajo del 10/11/2026.

**Responsable de decidir:** Victor Leandro Machado (`leandrito369`).

**Ratificación integral de esta RD:** PENDIENTE; sin firma ni fecha de ratificación atribuida.

**Ratificación de alternativa B:** PENDIENTE.

**Autorización de CR-C / CR-F:** PENDIENTE; archivos no creados.

**Implementación / migraciones / despliegue:** NO AUTORIZADOS por este documento.

Este archivo consolida orientaciones aprobadas por el encargo y propuestas pendientes explícitas. No modifica RD-UC07-001, otras RDs, contratos G0, manifiestos, código, migraciones ni estado de despliegue. La validación documental ejecutada para la PR se informará con sus resultados efectivos en el cuerpo de esa PR; no certifica E01–E19, F01–F08 o P01–P12 ni cierra reservas por sí misma.
