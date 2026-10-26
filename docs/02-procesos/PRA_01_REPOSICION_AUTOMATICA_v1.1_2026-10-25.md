# Ale Milanesas — PRA-01: Proceso de Reposición Automática

**Corte documental:** 24/10/2026  
**Versión:** 1.1 / 25-10-2026 / Fase 1  
**Tipo:** proceso transversal de negocio orientado a eventos, **no Caso de Uso UML**.  
**Alcance:** Insumos y compras por cotización; no incluye REVENTA como destinatario de OrdenCompra.  
**Requisitos:** RF-05 — Gestionar Recetas, Umbrales y Reposición; RF-11 — Gestionar Proveedores, Cotizaciones y Compras. RNF de integridad, concurrencia e idempotencia según requisitos aprobados.  

## 1. Objetivo y límites

Administrar el ciclo del faltante de un **Insumo** desde la detección de disminución de existencias hasta el cierre del episodio, incluyendo primera ronda automática cuando procede, publicación de invitaciones, plazo de respuesta y clasificación de ofertas para decisión humana. El proceso unifica reglas dispersas entre CU-08, UC-12, UC-13, UC-28, UC-31, UC-39, UC-42 y UC-44, sin cambiar por sí solo su actor principal ni crear relaciones «include»/«extend».

**Regla fundamental:** la automatización puede emitir solicitudes, recibir resultados y clasificarlos, pero **nunca decide comprar ni genera OrdenCompra sin confirmación del Administrador en UC-12**. La ronda automática no equivale a compra automática.

## 2. Entidades existentes y datos consultados

| Elemento | Atributos físicos o conceptos vigentes | Uso en PRA-01 |
| --- | --- | --- |
| INSUMO | stockActual; umbralMinimo; nivelObjetivoReposicion; automatizacionCompraActiva; activo | Detectar faltante; calcular cantidad; habilitar automatización. |
| MOVIMIENTO_INSUMO | idMovimientoInsumo; tipo y movimientos efectivos | Disparador por cambio real de stock; conservar fuente de apertura. SALDO_INICIAL está aprobado funcionalmente, pendiente de propagación física. |
| EPISODIO_FALTANTE | idEpisodio; idInsumo; fechaHoraInicio; fechaHoraCierre; idMovimientoApertura | Anclar en forma persistente una cadena por episodio; no duplicar episodio vigente. |
| SOLICITUD_COTIZACION | idSolicitud; idEpisodio; idSolicitudAnterior; cantidadSolicitada; fechaHoraEmision; fechaHoraVencimiento; fechaHoraFinRecepcion; modalidadInicio; estado; motivoCierre | Registro inmutable de la ronda y control temporal. |
| PROVEEDOR / PROVEEDOR_INSUMO / USUARIO_PROVEEDOR | ACTIVO; asociación vigente; Usuario habilitado | Determinar Proveedores invitables a la fecha de emisión. |
| INVITACION_COTIZACION / RESPUESTA_COTIZACION | Invitaciones históricas; respuestas únicas y definitivas | Acceso por portal y cierre de recepción. |
| POLITICA_COMPRA / CRITERIO_POLITICA_COMPRA | Versión vigente y criterios | Evaluar / ordenar ofertas; no inventar pesos numéricos. |
| DECISION_COMPRA / ORDEN_COMPRA / RECEPCION_COMPRA | Decisión administrativa y estados de Orden; recepciones acumuladas | No se emite Orden sin Administrador; evaluar resolución del faltante. |

## 3. Condiciones e invariantes

| Regla | Condición obligatoria |
| --- | --- |
| PRA-R01 | `nivelObjetivoReposicion > umbralMinimo`; cantidad a reponer = `nivelObjetivoReposicion - stockActual`, positiva, en la Unidad de Medida del Insumo; valor congelado al emitir Solicitud. |
| PRA-R02 | Existe faltante si `stockActual < umbralMinimo`. El episodio no se duplica: máximo un `EPISODIO_FALTANTE` abierto por Insumo. |
| PRA-R03 | Solo un flanco de bajada producido por movimiento de stock puede activar primera ronda automática; habilitar luego automatización, modificar umbral, habilitar Proveedor o cambiar nivel objetivo no la dispara retroactivamente. |
| PRA-R04 | Por episodio puede emitirse como máximo **una primera ronda AUTOMATICA efectiva**. Si se bloquea por falta de invitables/validaciones, se conserva alerta sin Solicitud ficticia ni consumo de esa posibilidad. |
| PRA-R05 | Invitable ⇔ Proveedor ACTIVO ∧ ProveedorInsumo vigente ∧ Usuario PROVEEDOR habilitado. Evaluar invitabilidad al emitir. Las invitaciones históricas no se modifican por cambio posterior. |
| PRA-R06 | Ronda AUTOMATICA invita a todos los invitables; MANUAL de UC-44 selecciona conjunto no vacío autorizado. Ronda posterior siempre MANUAL, enlazada con la última Solicitud de la cadena, sin bifurcar ni crear ciclos. |
| PRA-R07 | Un Proveedor invitado presenta como máximo una RespuestaCotizacion definitiva e inmutable por Solicitud, por portal y dentro del plazo; vencida o cerrada se rechaza sin crear respuesta. |
| PRA-R08 | Cierre sin respuestas = `RESUELTA_SIN_COMPRA` + `SIN_RESPUESTAS`; con respuestas pero cero ofertas elegibles = `RESUELTA_SIN_COMPRA` + `SIN_OFERTAS_ELEGIBLES`. No se crea DecisionCompra para cierres automáticos. |
| PRA-R09 | Con al menos una oferta elegible: `PENDIENTE_DECISION`, evaluación mostrada al Administrador en UC-12. La compra o cierre administrativo requiere su decisión expresa y, cuando corresponda, justificación. |
| PRA-R10 | El episodio se cierra únicamente si `stockActual >= umbralMinimo` **y** no existen Solicitudes en curso ni Órdenes pendientes de recepción asociadas. Una recepción parcial o una Orden finalizada sin recuperar stock no basta. |
| PRA-R11 | OrdenCompra: `PENDIENTE`, `PARCIALMENTE_RECIBIDA`, `RECIBIDA`, `CANCELADA`; recepciones acumuladas ≤ cantidad ordenada. Cancelar no deshace recepciones ni crea automáticamente otra ronda. |
| PRA-R12 | Concurrencia e idempotencia en detección, cierre, ronda y evaluación; no doble solicitud, episodio, invitación, decisión, Orden o efecto de stock por reintento/evento duplicado. |

### Ampliación normativa aprobada — plazo y política de evaluación

**PRA-R13 — Plazo de cotización independiente.** La duración habilitada para respuestas constituye una regla operativa del episodio gestionada por PRA-01, y **no** se obtiene de `POLITICA_COMPRA.periodoCalculoDias` (ventana para calcular métricas de evaluación). Antes de cada emisión válida, PRA-01 deberá disponer de una regla de plazo explícita y válida, calcular `fechaHoraVencimiento` y congelarla en `SOLICITUD_COTIZACION`. La elección entre regla dinámica al abrir episodio y parámetro general independiente continúa abierta en RP-012: no se fija duración por defecto ni se agrega atributo no aprobado.

**PRA-R14 — Evaluación ponderada configurable.** PRA-01 utiliza la Política de Compra registrada por UC-58 y sus `CRITERIO_POLITICA_COMPRA.pesoRelativo` y `ordenDesempate`, sin pesos fijos 40/25/25/10. La evaluación debe conservar la versión aplicable, los datos usados y un resultado reproducible. El algoritmo preciso de transformación de datos a valores comparables, escalas y desempate continúa en RP-013; no se fingirá aprobado un cálculo matemático completo.

## 4. Eventos y responsables funcionales

| Evento | Origen documentado | Responsabilidad del proceso |
| --- | --- | --- |
| E1 — Stock disminuye y cruza umbral | UC-28: consumo en Preparación; UC-42: ajuste negativo; UC-08: ingresos cambian stock y permiten reevaluar episodio | Evaluar flanco, abrir episodio y primera ronda si reúne condiciones. No disparar por mero cambio de parámetros. |
| E2 — Se emite la primera Solicitud automática | PRA-01 tras E1 | Congelar cantidad, vigencia e invitados; publicar acceso por portal. |
| E3 — Proveedor responde | UC-13 | Validar invitación y estado temporal; guardar respuesta única. |
| E4 — Vence plazo / se cierra recepción | PRA-01 por tiempo de negocio | Determinar SIN_RESPUESTAS, SIN_OFERTAS_ELEGIBLES o PENDIENTE_DECISION. |
| E5 — Administrador resuelve compra | UC-12 | Conservar decisión y eventualmente crear Orden; no decisión automática. |
| E6 — Se recibe mercadería | UC-08 | Actualizar stock, recepciones y estados de Orden, reevaluar umbral y cierre episodio. |
| E7 — Se cancela Orden | UC-39 | Conservar recepciones anteriores; si persiste faltante, alertar para eventual ronda MANUAL UC-44. |
| E8 — Administrador inicia ronda manual | UC-44 | Seleccionar invitables; confirmar ronda primera o posterior sin Orden pendiente/solicitud en curso. |
| E9 — Se modifica configuración | UC-31, UC-50/51 | Actualizar parámetros para próximos movimientos; nunca disparar primera ronda retroactiva ni recalcular Solicitudes emitidas. |

## 5. Flujo principal basado en eventos

### PRA-F1. Apertura y primera ronda automática

1. Se confirma un movimiento de Insumo que deja `stockActual` por debajo de `umbralMinimo`. El proceso identifica si se produjo el **cruce descendente** del umbral; distingue ese disparador de una simple configuración posterior.
2. Si el Insumo tiene un episodio abierto, reutiliza `EPISODIO_FALTANTE`; de lo contrario, registra uno nuevo con `fechaHoraInicio` y referencia al movimiento de apertura cuando proceda, aplicando exclusión concurrente por Insumo.
3. Registra o mantiene la alerta de faltante sin suponer que ya existe una SolicitudCotizacion.
4. Comprueba si puede emitir la primera ronda automática: Insumo ACTIVO, `automatizacionCompraActiva` habilitada al evento válido, sin ronda automática previa efectiva del episodio, sin Solicitud en curso ni Orden pendiente que la vuelva incompatible, y parámetros consistentes.
5. Calcula `nivelObjetivoReposicion - stockActual` con stock y parámetros actuales, en Unidad de Medida válida. El resultado debe ser positivo.
6. Obtiene todos los Proveedores asociados vigentes con el Insumo y verifica `ACTIVO` y Usuario habilitado. **No utiliza historial de incumplimientos para excluir invitables.**
7. Si hay al menos un invitable y existe plazo de respuesta válido, registra atómicamente `SOLICITUD_COTIZACION` con `modalidadInicio = AUTOMATICA`, `cantidadSolicitada`, fechas, estado `RECEPCION_ABIERTA` e invitaciones congeladas. `idSolicitudAnterior` queda vacío para la primera ronda.
8. Publica la Solicitud en el portal para esos destinatarios y conserva las invitaciones como hechos históricos; publicar en portal no supone aviso externo automático.

### PRA-F2. Recepción y evaluación

9. Durante `RECEPCION_ABIERTA`, UC-13 permite una sola respuesta definitiva por invitación y antes del vencimiento; la respuesta queda vinculada con su Proveedor e Invitación.
10. Al vencer el plazo o finalizar legítimamente la recepción, cierra la ventana de respuestas y fija `fechaHoraFinRecepcion`; todo envío posterior se rechaza sin registrar respuesta definitiva.
11. Si no existe ninguna respuesta válida, cierra la Solicitud como `RESUELTA_SIN_COMPRA` con `motivoCierre = SIN_RESPUESTAS`, sin DecisionCompra ni OrdenCompra.
12. Si existen respuestas pero ninguna es elegible según Proveedor ACTIVO y política/condiciones aprobadas, cierra como `RESUELTA_SIN_COMPRA` con `SIN_OFERTAS_ELEGIBLES`, sin DecisionCompra ni OrdenCompra. Una reevaluación desde PENDIENTE_DECISION puede conducir al mismo cierre si deja cero elegibles.
13. Si existen respuestas elegibles, registra/presenta una evaluación conforme a la `POLITICA_COMPRA` vigente y deja la Solicitud `PENDIENTE_DECISION`; el Administrador conserva la decisión en UC-12.
14. El Administrador puede seleccionar oferta elegible y confirmar compra (OrderCompra ligada a la decisión), o resolver sin compra justificadamente. El sistema preserva la evaluación, la versión de política y la decisión humana, sin emitir ninguna Orden anticipada.

### PRA-F3. Reposición física, nuevas rondas y cierre del episodio

15. UC-08 registra las recepciones físicas reales, sus costos y cantidades y las acumula contra la Orden cuando exista, respetando restricciones de estado y cantidad. REVENTA sin Orden queda fuera de la cadena de episodios de Insumos.
16. Al confirmar un movimiento de stock o recepción, el proceso reevalúa el Insumo. Si `stockActual >= umbralMinimo` y no queda Solicitud abierta ni Orden pendiente de recepción, registra `fechaHoraCierre` del episodio.
17. Si persiste faltante tras una Solicitud resuelta sin compra o una Orden CANCELADA/RECIBIDA y no hay Solicitud ni Orden pendiente, mantiene el episodio y la alerta; **no crea nueva ronda automática**.
18. El Administrador puede utilizar UC-44 para emitir la primera ronda manual si nunca se emitió una automática, o una ronda posterior MANUAL enlazada con la última Solicitud de una cadena lineal. Revalida parámetros, cantidad, invitabilidad y concurrencia en la confirmación.
19. La recepción y el cierre no alteran Solicitudes, invitaciones, respuestas, decisiones ni recepciones históricas ya confirmadas.

## 6. Escenarios excepcionales y resultado

| Escenario | Tratamiento verificable |
| --- | --- |
| X01 — Stock bajo causado solo por actualización de umbral/automatización | Conservar faltante y alerta; no iniciar ronda automática retroactiva. |
| X02 — Sin Proveedores invitables, o parámetros/plazo inconsistentes | No emitir Solicitud ficticia. Mantener alerta y posibilidad de primera ronda manual bajo UC-44. |
| X03 — Otro episodio abierto o disparador repetido | Reusar episodio vigente; no crear otro ni doble ronda automática. |
| X04 — Respuesta fuera del plazo, sobre Solicitud cerrada o de Proveedor no invitado | Rechazarla; no registrar RespuestaCotizacion definitiva. |
| X05 — Respuesta duplicada o modificada | No modificar una Respuesta definitiva previa; informar el rechazo. |
| X06 — Respuestas válidas pero ninguna oferta elegible | Cerrar automáticamente SIN_OFERTAS_ELEGIBLES; no DecisionCompra. |
| X07 — Sin respuestas | Cerrar automáticamente SIN_RESPUESTAS; no DecisionCompra. |
| X08 — Sin POLITICA_COMPRA vigente/consistente | No inventar ponderaciones ni decidir compra; registrar incidencia y bloquear resolución que dependa de la política. |
| X09 — Recepción contra Orden CANCELADA/RECIBIDA, exceso o Insumo distinto | UC-08 rechaza la recepción asociada inválida sin alterar stock ni estado de Orden. |
| X10 — Stock recuperado pero hay Solicitud u Orden pendiente | No cerrar aún episodio; reevaluar tras resolver el bloqueo. |
| X11 — Faltante persiste después de Orden cancelada/recibida | Mantener alerta y habilitar evaluación para ronda MANUAL; nunca segunda automática. |
| X12 — Fallo transaccional o carrera | No confirmar operación parcial ni efectos duplicados. Reintentos recuperan el mismo hecho o son rechazados según clave/estado. |

## 7. Matriz de trazabilidad RF-05 / RF-11 y CU afectados

**Nota de numeración:** los códigos son los nuevos consecutivos. Las fichas actuales del 23/10 citan el número anterior y serán refactorizadas en Fase 3.

| Responsabilidad | RF-05 | RF-11 | PRA-01 | CU / titular de interacción |
| --- | --- | --- | --- | --- |
| Parámetros, umbral, automatización | Sí | Relacionado | R01–R04 / E9 | UC-31 Configurar Parámetros de Reposición; UC-50 Alta Insumo |
| Consumo físico que modifica stock Insumo | Sí | Relacionado | E1 / F1 | UC-28 Registrar Preparación; UC-42 Registrar Ajuste/Apertura |
| Crear episodio y alerta | Sí | Sí | F1.1–F1.3 | PRA-01, disparado por movimiento real |
| Emitir primera ronda automática | Sí | Sí | F1.4–F1.8 | PRA-01 sin CU automático |
| Invitabilidad Proveedor | Relacionado | Sí | R05 / F1.6 | PRA-01; UC-44 ronda manual |
| Consultar invitaciones y responder | Relacionado | Sí | F2.9 | UC-13; futuro UC-63 para consulta del Proveedor |
| Cerrar respuestas y clasificar ofertas | Relacionado | Sí | F2.10–F2.13 | PRA-01; UC-12 usa evaluación |
| Resolver compra humana | Relacionado | Sí | F2.14 | UC-12 exclusivamente Administrador |
| Recepcionar Compra / actualizar Orden | Relacionado | Sí | F3.15 | UC-08; sin Orden REVENTA según alcance vigente |
| Cancelar Orden | Relacionado | Sí | E7 / X11 | UC-39 Cancelar Orden de Compra |
| Emitir ronda MANUAL | Sí | Sí | F3.17–F3.18 | UC-44 Iniciar Ronda Manual de Cotización |
| Cerrar episodio | Sí | Sí | F3.16 | PRA-01 tras reconciliar stock + solicitudes + órdenes |
| Configurar política de compra | Relacionado | Sí | X08 | UC-58, nueva ficha por redactar |

## 8. Garantías técnicas mínimas (no nuevos atributos)

- **Atomicidad:** apertura/reutilización de episodio, emisión de Solicitud e invitaciones; recepción y movimientos stock; estado de Orden y acumulados, como unidades transaccionales cuando comparten una operación.
- **Exclusión concurrente:** bloquear Insumo/episodio/solicitud u Orden según cada operación; índice único parcial de episodio abierto e invariantes de una primera AUTOMATICA efectiva. Son reglas para implementar en PostgreSQL, no presunción de DDL ya validado.
- **Idempotencia:** eventos repetidos no crean episodios, rondas, respuestas, recepciones ni órdenes duplicadas; los identificadores y estados persistidos permiten reconocer resultados ya aplicados.
- **Temporalidad:** `fechaHoraEmision`, `fechaHoraVencimiento` y `fechaHoraFinRecepcion` distinguen emisión, vencimiento y cierre efectivo. No alterar solicitudes históricas después de su emisión.
- **Trazabilidad:** versión de política y datos comerciales vigentes se preservan en la decisión correspondiente; no introducir pesos o fórmulas no aprobadas.
- **Inventario:** `SALDO_INICIAL` fue aprobado funcionalmente para UC-42 y obliga a ajustar la enumeración/validación física de MOVIMIENTO_INSUMO antes de ejecutarlo. No genera compra o efecto monetario ficticio.

## 9. Dependencias aún abiertas (referencias RP-01)

- **RP-012:** queda fijado que PRA-01 determina y congela el plazo de respuesta por Solicitud sin usar `POLITICA_COMPRA.periodoCalculoDias`; falta ratificar si la regla se determina al abrir el episodio o proviene de un parámetro general independiente. No se aprueba plazo de 48 h por defecto.
- **RP-013:** aprobación de ponderación configurable mediante `pesoRelativo` y prioridad `ordenDesempate` de UC-58; no adoptar pesos fijos 40/25/25/10. Faltan escalas, normalización, algoritmo exacto y desempate final, que requieren definición reproducible.
- **RP-014, RP-030, RP-034:** implementar concurrencia, cierres y pruebas; el Esqueleto DDL no fue ejecutado.
- **RP-015:** implementar SALDO_INICIAL en las restricciones de tipo de MOVIMIENTO_INSUMO.

## 10. Estados y cierres (control de coherencia)

| Entidad | Estados vigentes / campo | Condición o transición |
| --- | --- | --- |
| SOLICITUD_COTIZACION | RECEPCION_ABIERTA | Admite respuesta definitiva válida antes de vencimiento. |
| SOLICITUD_COTIZACION | PENDIENTE_DECISION | Con oferta elegible, espera al Administrador; reevaluación sin elegibles → resolución automática SIN_OFERTAS_ELEGIBLES. |
| SOLICITUD_COTIZACION | RESUELTA_CON_COMPRA | Exige DecisionCompra resultado COMPRA y OrdenCompra confirmada. |
| SOLICITUD_COTIZACION | RESUELTA_SIN_COMPRA | Exige motivoCierre SIN_RESPUESTAS / SIN_OFERTAS_ELEGIBLES / DECISION_ADMINISTRATIVA_SIN_COMPRA; sólo el último implica DecisionCompra. |
| ORDEN_COMPRA | PENDIENTE, PARCIALMENTE_RECIBIDA, RECIBIDA, CANCELADA | Cancelación desde PENDIENTE o PARCIALMENTE_RECIBIDA. RECIBIDA/CANCELADA terminales. Nunca VENCIDA como estado. |
| EPISODIO_FALTANTE | fechaHoraCierre NULL / no NULL | Se cierra cuando stock ≥ umbral y no haya Solicitud ni Orden pendiente de recepción. |

## 11. Verificaciones de aceptación de PRA-01

1. Un movimiento que cruza umbral con automatización habilitada y Proveedores invitables genera un episodio y una sola Solicitud AUTOMATICA con todos los invitables.
2. Una actualización de umbral o habilitación de Proveedor no genera una ronda automática retroactiva.
3. El flanco sin invitables conserva alerta sin Solicitud ficticia y sin consumir la capacidad de una primera ronda automática efectiva.
4. No se acepta una respuesta tardía, no invitada, duplicada o sobre Solicitud cerrada.
5. SIN_RESPUESTAS y SIN_OFERTAS_ELEGIBLES se cierran sin DecisionCompra; con oferta elegible se espera UC-12.
6. Sin confirmación del Administrador jamás existe nueva OrdenCompra, aunque la evaluación tenga un primer puesto.
7. Recepción parcial actualiza Orden correctamente y no cierra el episodio si queda Solicitud/Orden pendiente.
8. Cancelar una Orden no revierte recepción previa ni inicia una segunda ronda automática.
9. Recibir una Orden completa con stock aún por debajo de umbral no cierra episodio y permite ronda MANUAL según UC-44.
10. Dos disparadores/reintentos simultáneos no duplican episodio, Solicitud, invitación o movimiento.

## 12. Fuentes y alcance de la presente aprobación

`B_Dominio_y_Diseño_ACTUALIZADO_23-10-2026.md` (Insumo y abastecimiento); `C_CasosDeUso_y_Estado_ACTUALIZADO_23-10-2026.md`; `C_ANEXO_49_CU_TRES_NIVELES_ACTUALIZADO_23-10-2026.md`; `D_Decisiones_y_Pendientes_ACTUALIZADO_23-10-2026.md`; `Esquema_Maestro_Relacional_59_Tablas_ACTUALIZADO_23-10-2026.md`; decisión explícita del usuario del Grupo B 24/10: documentar PRA-01 sin crear un CU automático.

**No equivale a implementación ni a ejecución de DDL.** La asignación exacta de handlers/eventos y tecnología se resolverá en diseño técnico sin añadir entidades o atributos no autorizados.
