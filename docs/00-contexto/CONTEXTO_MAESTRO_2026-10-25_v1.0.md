# Sistema de Gestión para Ale Milanesas
## Documento maestro de continuidad y transferencia de contexto

**Corte funcional y documental:** 25/10/2026 · **Edición de traspaso:** CTX-2026-10-25 v1.0  
**Finalidad:** transferir las decisiones, artefactos, límites y estado de trabajo a otra IA, otro chat, docente o integrante técnico; habilitar actividades paralelas **sin modificar la línea base inadvertidamente**.  
**Estado del proyecto en el corte:** análisis funcional consolidado; diseño relacional MR-3 preparado; MR-4 auditado estáticamente pero **no validado con PostgreSQL**; siguiente trabajo propuesto MR-5.  
**Carácter de este documento:** síntesis derivada, **no reemplaza** los CU, el DDL, el registro de decisiones ni las fuentes firmadas. Cuando difieran, se aplica la jerarquía de precedencia definida en §2.

---

# 1. Resumen ejecutivo para retomar el proyecto

Se estudia un negocio real de elaboración y comercialización de milanesas de pollo, con reparto domiciliario, productos elaborados y de reventa. El Trabajo Final corresponde a la carrera de Analista en Sistemas de Computación de UNaM-FCEQyN (Res. CD 220/15), y se encuadra en un Proceso Unificado adaptado. El sistema busca coordinar ventas, producción, inventario, compras, reparto, cuentas corrientes, Caja y canal ONLINE; incluye Promociones, Excedentes y cotizaciones a Proveedores.

**Situación al cierre:**

| Eje | Entregable / alcance | Estado demostrado al 25/10 |
|---|---|---|
| Requisitos y dominio | Documentos A–D, guías TP05/TP07 y decisiones consolidadas | **Base conceptual disponible**; archivos del 23/10 contienen numeración histórica y deben leerse con precedencia |
| Casos de uso | **64 CU consecutivos**, UC-01…UC-64; 3 niveles c/u (Alto, Extendido, Real): **192 fichas** | Fase 4 entregada; auditoría estructural superada; **153 referencias de subflujos requieren posible lectura semántica** |
| Decisiones y pendientes | RD-01, RP-01 y PRA-01 | Versiones 1.1 del 25/10; **no incorporan íntegramente** los acuerdos posteriores MR-3/MR-4; este documento incorpora la cronología siguiente |
| UML de Casos de Uso | 27 «include» y 2 «extend» históricas; **7 «include» nuevas aprobadas después** | **36 relaciones aprobadas en total** para registrar; el **diagrama alternativo generado fue rechazado visualmente por el usuario** y no debe tratarse como maestro |
| Modelo Relacional de origen | 59 tablas, 444 columnas y 120 FK; SQL no ejecutado | Línea base del 23/10 conservada |
| Modelo Relacional MR-3 | **60 tablas, 453 columnas, 125 FK**; una nueva `CONFIGURACION_OPERATIVA` | Diseño y archivos SQL propuestos; **NO ejecutados** ni certificados |
| MR-4 | Auditoría de 60 tablas, 453 columnas, 125 FK, 11 funciones y 12 triggers | Verificación **estática** de estructura; **10 hallazgos F01–F10**; sin PostgreSQL ni prueba real de concurrencia |
| Próxima etapa | MR-5: resolver hallazgos MR-4; MR-6: validar en PostgreSQL; MR-7: actualizar diagrama relacional si se solicita | **No iniciadas** |

**Instrucción principal a otra IA:** no afirmar que el sistema fue implementado o probado; no reabrir por defecto decisiones ratificadas; no generar nuevos estados, roles, atributos, tablas, relaciones UML ni reglas comerciales a partir de meras inferencias. **El DDL MR-3 no es apto para producción.**

# 2. Fuentes, autoridad y criterios de trabajo

## 2.1 Jerarquía de precedencia (para evitar contradicciones)

1. **Decisiones explícitas del usuario posteriores y fechadas en el chat** prevalecen sobre propuestas de cualquier documento, incluso si las propuestas fueron formuladas por la IA. Ejemplo: aceptación de siete «include» el 25/10, sin aceptar el diagrama que las sugería.
2. **RD/actas aprobadas** para reglas del negocio y **especificación Fase 4** para las 64 fichas; las decisiones posteriores a esas versiones se aplican como *addenda* hasta propagarlas formalmente.
3. **Modelo MR-3 y su DDL** para las estructuras propuestas de 60 tablas, **solo como diseño NO EJECUTADO**. MR-4 tiene autoridad para señalar defectos/riesgos de ese diseño, no para declararlo certificado.
4. PRA-01 para reposición automática; las aclaraciones posteriores sobre plazo y puntuación prevalecen donde difieran.
5. Documentos A/B/C/D, esquema de 59 tablas y UML antiguos como **antecedentes históricos**. Sus códigos viejos y permisos preliminares no sustituyen los acuerdos finales.
6. Cualquier texto de ayuda generado por IA que no conste como decisión aceptada se considera **propuesta**, nunca modificación tácita del negocio.

Si existe contradicción: registrar una **incidencia de coherencia** con dos citas documentales, aplicar solo lo aprobado y no «armonizar» inventando nuevas reglas. La tabla de conflictos al final de §9 ayuda a hacerlo.

## 2.2 Criterios metodológicos y de modelado utilizados

- **Trazabilidad de ida y vuelta:** OBJ/OBJE → RF/RNF/IRQ → CU → reglas del dominio → tablas/columnas/constraints → pruebas. No mezclar las familias de códigos (`OBJ`, `OBJE`, `RF`, `RNF`, `IRQ`).
- **UML:** actores humanos/servicios externos; un procedimiento automático no se dibuja automáticamente como actor «Sistema». `«include»` significa reutilización obligatoria y `«extend»` intervención condicional. Asincronía o proximidad cronológica **no** implican relación UML.
- **Tres niveles de CU:** Alto Nivel en tabla nativa de 2 columnas; Extendido, 3; Real, 4. Secuencias con pasos verificables; excepciones Real referidas a sus propios pasos; intención del actor separada de propósito del sistema; poscondiciones son estados observables.
- **Dominio vs. persistencia:** conceptos y asociaciones no equivalen uno a uno a tablas; `totalVigente` del Pedido es una magnitud derivada, no columna obligatoria nueva.
- **Histórico inmutable cuando corresponda:** precios, promociones, costos, cantidades y ajustes aplicados en operaciones confirmadas se mantienen congelados; una desactivación lógica no borra registros ni cancela operaciones previas.
- **Mínimo privilegio y seguridad:** los accesos dependen de Rol y alcance del objeto; ejecutar una búsqueda dentro de un CU no otorga automáticamente menú de búsqueda global. Cliente ONLINE ≠ `USUARIO` con rol `CLIENTE`.
- **Transacciones e idempotencia:** evitar doble confirmación de Entrega, múltiples efectos de Reembolso, sobresuscripciones de Excedente, episodios de reposición duplicados o Cobros offline repetidos.
- **No introducir datos falsos:** no registrar compras, Caja ni cantidades ficticias para simular stock inicial; no inventar CUIT/DNI del Cliente, porcentajes de política ni 48 horas/15 días por defecto.
- **Separación de estados:** `aprobado funcionalmente`, `propuesto en DDL`, `implementado en software`, `ejecutado en DB` y `verificado` son cinco condiciones distintas. Nunca usar «completado» sin señalar cuál.
- **Preservación de originales:** trabajar mediante nuevas versiones y diferencias, no sobrescribir el documento maestro, diagramas ni SQL histórico sin instrucción explícita.

## 2.3 Arquitectura prevista — no confundir con producto construido

Aplicación Android (Kotlin/Room) con cola offline para flujos habilitados; backend Java/Spring Boot; web Thymeleaf; PostgreSQL; integración MercadoPago; ruteo sugerido (OSRM) y mensajería WhatsApp por proveedor a definir. Se trata de **tecnologías previstas en la documentación del dominio**, no de componentes desplegados ni comprobados. No se han presentado pruebas de integración reales.

**Fuera de alcance académico previsto:** facturación electrónica fiscal AFIP/ARCA, contabilidad general/impuestos, cuentas a pagar a Proveedores, margen neto, SaaS multiempresa, ERP genérico y optimización exacta de rutas.

# 3. Cronología de entregas y estado verificable

| Etapa | Trabajo realizado y principal archivo | Dictamen de continuidad |
|---|---|---|
| Base 19–23/10 | Requisitos A, Dominio B, CU C/anexo, decisiones D, esquema/diccionario/SQL de 59 tablas | Origen histórico; numeración previa no vigente |
| Acuerdos A / B / C, 24/10 | 26 correcciones funcionales A; 15 CU nuevos B; 13 grupos de higiene C; renumeración | **Aprobado funcionalmente** |
| Fase 1, 24/10 | RD-01, RP-01, PRA-01 y extracción de metatexto | Documentación de soporte preparada; su versión 1.1 es anterior a MR-3 |
| Fase 2.1, 24/10 | UC-50…56 × tres niveles | Redactados |
| Fase 2.2, 24/10 | UC-57…58 × tres niveles | Redactados |
| Fase 2.3, 25/10 | UC-59…64 × tres niveles; RD/RP/PRA v1.1 | Redactados y versionados |
| Fase 3, 25/10 | Refactor funcional UC-01…49 | Versión derivada, posteriormente revisada en Fase 4 |
| Fase 4, 25/10 | **Catálogo final 64×3** en `ALE_MILANESAS_FASE_4_CU_01_A_64_TRES_NIVELES.docx` | Fuente principal de fichas; revisión semántica final de subflujos no está certificada exhaustivamente |
| Diagrama CU, 25/10 | Se generó versión modular con 64 nodos, 29 relaciones anteriores y 7 candidatas | **Usuario rechazó su diseño; no actualizarlo.** Las siete relaciones se aceptaron posteriormente |
| MR-1, 25/10 | 53 hallazgos sobre 59 tablas y 64 CU | Auditoría de impacto completada |
| MR-2, 25/10 | Dictámenes técnicos para los 53 hallazgos | 26 controles, 8 hallazgos DDL, 3 índices condicionales, 5 sin cambio, 7 funcionales pendientes, 2 verificaciones, 1 reservada y 1 MR-4 |
| MR-3, 25/10 | Nuevo catálogo físico y SQL **60 / 453 / 125** | Preparado en archivos, **NO EJECUTADO** |
| MR-4, 25/10 | Auditoría estática del SQL; batería de pruebas entregada | **PARCIAL: 10 hallazgos, ejecución PostgreSQL ausente, no aptitud productiva** |
| MR-5 / MR-6 / MR-7 | Corrección crítica / ejecución PostgreSQL / eventual DER | **Pendiente de comenzar** |

**Estado exacto de este chat al corte:** el usuario preguntó «¿Qué es lo que sigue?» tras MR-4. Se propuso comenzar MR-5, luego MR-6 y eventualmente MR-7. **MR-5 no se ejecutó.** La solicitud posterior es preparar este documento de traspaso.

# 4. Catálogo funcional completo y numeración

La numeración **es consecutiva UC-01…UC-64**. No existe hueco UC-14. Antecedentes del 23/10: UC-01…UC-13 se mantuvieron, los viejos UC-15…UC-50 se renumeraron restando 1, y los nuevos se asignaron UC-50…UC-64. Por eso está prohibido copiar códigos de un archivo histórico sin traducirlos.

Los títulos siguientes se extraen directamente de las 64 fichas del Word consolidado Fase 4; prevalecen, para identificar esas fichas, sobre títulos simplificados de antiguos catálogos. En particular, Fase 4 usa **UC-11 «Gestionar Proveedor»** y **UC-30 «Gestionar Producto»**, donde documentación anterior utilizaba «Registrar». No cambiar títulos físicos a ciegas sin registrar ese contraste.

| Código | Nombre vigente en el catálogo Fase 4 |
|---|---|
| UC-01 | Iniciar sesión |
| UC-02 | Registrar Cliente |
| UC-03 | Cargar Pedido |
| UC-04 | Consultar Pedidos Asignados |
| UC-05 | Registrar Entrega |
| UC-06 | Cancelar Pedido |
| UC-07 | Ofrecer y Reasignar Excedente |
| UC-08 | Registrar Ingreso de Stock por Compra |
| UC-09 | Consultar Stock |
| UC-10 | Configurar Receta de Producto |
| UC-11 | Gestionar Proveedor |
| UC-12 | Evaluar Cotizaciones y Resolver Compra |
| UC-13 | Responder Solicitud de Cotización |
| UC-14 | Consultar Cuenta Corriente |
| UC-15 | Evaluar y Actualizar Categoría Comercial |
| UC-16 | Aplicar Ajuste Comercial según Categoría |
| UC-17 | Crear Usuario |
| UC-18 | Gestionar Asignaciones de Roles |
| UC-19 | Actualizar Precio Vigente |
| UC-20 | Consultar Historial de Precios |
| UC-21 | Realizar Pedido Online |
| UC-22 | Registrar Movimiento de Caja |
| UC-23 | Consultar Libro Diario |
| UC-24 | Crear y Comunicar Promoción |
| UC-25 | Generar Ruta Sugerida de Reparto |
| UC-26 | Procesar Reembolso Electrónico |
| UC-27 | Consultar Margen Bruto |
| UC-28 | Registrar Preparación de Pedido |
| UC-29 | Registrar Cobro |
| UC-30 | Gestionar Producto |
| UC-31 | Configurar Parámetros de Reposición de Insumo |
| UC-32 | Modificar Cliente |
| UC-33 | Buscar Cliente |
| UC-34 | Buscar Pedido |
| UC-35 | Buscar Producto |
| UC-36 | Buscar Insumo |
| UC-37 | Buscar Proveedor |
| UC-38 | Cambiar Estado de Cliente |
| UC-39 | Cancelar Orden de Compra |
| UC-40 | Buscar Orden de Compra |
| UC-41 | Registrar Descarte de Excedente |
| UC-42 | Registrar Ajuste de Inventario |
| UC-43 | Asignar y Reasignar Pedidos a Repartidores |
| UC-44 | Iniciar Ronda Manual de Cotización |
| UC-45 | Modificar Proveedor |
| UC-46 | Cambiar Estado de Proveedor |
| UC-47 | Modificar Producto |
| UC-48 | Cambiar Estado de Producto |
| UC-49 | Registrar Resultado de Reembolso Electrónico |
| UC-50 | Registrar Insumo |
| UC-51 | Modificar Insumo |
| UC-52 | Cambiar Estado de Insumo |
| UC-53 | Cambiar Contraseña |
| UC-54 | Restablecer Acceso de Usuario |
| UC-55 | Cambiar Estado de Usuario |
| UC-56 | Buscar Usuario |
| UC-57 | Configurar Política de Categoría Comercial |
| UC-58 | Configurar Política de Compra |
| UC-59 | Consultar Promociones |
| UC-60 | Desactivar Promoción |
| UC-61 | Buscar Excedente |
| UC-62 | Buscar Solicitud de Cotización |
| UC-63 | Consultar Solicitudes de Cotización Recibidas |
| UC-64 | Consultar Movimientos de Inventario |

Los **15 CU incorporados** en Fase 2 son exactamente UC-50…UC-64. No se crea automáticamente un CU por cada operación interna, subproceso o respuesta asíncrona.

# 5. Decisiones funcionales y arquitectónicas que no deben perderse

## 5.1 Identidad, acceso y Roles

- UC-01 inicia sesión para **Usuarios** internos y Proveedores; **no** autentica Cliente ONLINE.
- UC-21: acceso ONLINE por código temporal remitido al teléfono registrado mediante WhatsApp; Cliente **preexistente, ACTIVO**, con identidad inequívoca. Si un teléfono corresponde a varios Clientes y no puede desambiguarse, se bloquea el acceso; no se introduce registro autónomo del Cliente ni rol `CLIENTE` en `USUARIO`.
- UC-17 crea `USUARIO` con **al menos un Rol inicial en la misma transacción** mediante UC-18; cuentas de Rol PROVEEDOR son exclusivas y se vinculan con un Proveedor habilitado; no acumulan roles internos.
- UC-53 permite cambiar contraseña al Usuario autenticado; UC-54 es restablecimiento asistido por Administrador **solo de PROVEEDORES** en el alcance inicial. Hash protegido en `USUARIO`, no historial nuevo de contraseñas; auditoría mediante logs generales; sesiones revocadas cuando corresponda.
- UC-55 deshabilita lógicamente Usuarios; debe conservar roles/historia, impedir pérdida del último Administrador habilitado y revocar sesiones activas. Estos invariantes están **pendientes de completar y probar**, según MR-4 F07.
- UC-56 busca Usuarios con mínimo privilegio, sin exponer secretos.

## 5.2 Clientes, ventas ONLINE y Pedidos

- Cliente se identifica sin CUIT/DNI inventados; duplicado exacto por **nombre normalizado + teléfono**; dos Clientes distintos pueden compartir teléfono. Cambiar teléfono de Cliente invalida un desafío OTP pendiente.
- Cliente `INACTIVO`: no nuevos Pedidos, Promociones u ofertas de Excedente; deuda y pagos históricos subsisten. Solo Administrador reactiva vía UC-38; Vendedor puede modificar campos permitidos en UC-32, no estado.
- `PEDIDO` usa `canalOrigen` INTERNO/ONLINE; estados `PENDIENTE`, `ENTREGADO`, `CANCELADO`. Fecha de reparto ONLINE y algunas reglas de reprogramación permanecen **pendientes**.
- `totalOriginal` es histórico; `totalVigente` se **deriva** de total original más incrementos por aceptaciones de Excedentes; no almacenar automáticamente columna nueva ni recalcular promociones anteriores.
- En ONLINE, el OTP precede a selección; se aplican Promoción primero y luego ajuste por categoría sobre el subtotal resultante. En INTERNO, el ajuste por categoría se aplica sobre subtotal base.
- UC-06 cancelación aplica según autorizaciones internas; no existe autocancelación ONLINE del Cliente aprobada. Cuando corresponda reembolso electrónico, UC-26 **extiende** UC-06; no es inclusión universal.

## 5.3 Producción, reparto, Excedentes e inventario

- UC-28 registra preparación: producción propia limitada a **cantidad original**. Reasignar Excedente no prepara nuevamente ni consume Insumos otra vez.
- UC-07 ofrece/reasigna Excedentes; requiere saldo disponible, mismo Producto/compatibilidad, cronología de aceptaciones y transacciones que eviten doble asignación. UC-41 registra descartes.
- UC-05 comprueba **asignación vigente de Repartidor en el instante de confirmar**; una Entrega es única y definitiva. Cantidad efectiva no supera original más adicionales aceptados ni disponibilidad física.
- La imputación comercial de Entrega sigue orden **unidades originales → adicionales aceptadas cronológicamente**. Los precios, costos y Promociones del Pedido original quedan congelados; los adicionales no heredan descuento/ajuste comercial original.
- UC-29 Cobro manual: permisos directos aprobados **Administrador y Vendedor**; Repartidor/Producción/Proveedor no tienen acceso directo. **Entrega no demuestra Cobro**. Una posible recaudación física por Repartidor necesita rendición y autorización propias, no habilitación implícita de UC-29.
- UC-50 crea solo Maestro de Insumo con `stockActual = 0` y parámetros obligatorios; stock inicial físico se registra vía UC-42, nuevo tipo `SALDO_INICIAL`, con costo histórico coherente, sin Compra ni Caja ficticias.
- Producto/Proveedor desactivado impide nuevas operaciones con ese elemento, pero **no cancela de oficio** los Pedidos u Órdenes abiertas: se permite completar las ya iniciadas bajo las condiciones aprobadas. MR-4 F09 detecta cobertura parcial de la regla en triggers.

## 5.4 Cuenta Corriente, Cobros, Margen y Reembolsos

- Cargo por Venta se confirma con Entrega efectiva; se reevaluará categoría comercial cuando corresponda y solo después de efectos financieros confirmados. Categoría `CUMPLIDOR` / `EN_MORA` configurable y versionada con UC-57.
- Cancelar Pedidos con Cobros manuales no dispara salida de Caja automática: conserva saldo a favor. Devoluciones electrónicas siguen lógica diferenciada.
- `REEMBOLSO` único por Cobro; resultado de MercadoPago en UC-49 **asíncrono, verificable e idempotente**. Caja/Cuenta Corriente se afectan solo con resultado `PROCESADO`. UC-26 no incluye ni extiende UC-49.
- Para reembolso RECHAZADO, reintento manual **exclusivamente Administrador** sobre el mismo Reembolso; un nuevo registro `INTENTO_REEMBOLSO`, sin crear otro `REEMBOLSO`. MR-3 eligió `idUsuarioReintento`, nulo en intento automático, obligatorio en reintentos; se trata de **DDL propuesto**.
- MR-3 introduce `ANULACION_COBRO` enlazada al Cobro original: inversión en Cuenta Corriente y EGRESO de Caja con signo contable negativo, manteniendo auditoría; **F01–F02 de MR-4 siguen abiertos**.
- Antigüedad de deuda: fecha/hora de Entrega confirmada, **sin plazo de gracia estándar**; imputación de pagos entre múltiples Pedidos todavía sin especificación aprobada.
- Margen bruto utiliza ingresos **efectivos** y costos históricos: original entregado + unidades adicionales aceptadas/entregadas con precio congelado, sin promover descuentos originales a dichas unidades. La consulta por venta individual todavía no fue incorporada; se conserva por período.

## 5.5 Compras, cotizaciones, políticas y PRA-01

- PRA-01 es un **proceso dirigido por eventos** separado del catálogo UML. Detecta cruce de `stockActual < umbralMinimo`, abre/reusa `EPISODIO_FALTANTE`, emite **a lo sumo una primera ronda AUTOMATICA por episodio** con Proveedores invitables y plazo válido, publica las Invitaciones, cierra recepción y clasifica ofertas. No es actor `Sistema` en UML.
- **Nunca se genera una Orden de Compra automáticamente**: UC-12 exige decisión humana del Administrador. UC-44 permite rondas posteriores **MANUALES**.
- Respuestas tardías, duplicadas, no invitadas o contra Solicitud cerrada se rechazan sin registro definitivo. Si no hay respuestas: `SIN_RESPUESTAS`; sin ofertas elegibles: `SIN_OFERTAS_ELEGIBLES`; no se crea Orden en esos casos.
- Una Orden de Compra puede quedar `PENDIENTE`, `PARCIALMENTE_RECIBIDA`, `RECIBIDA` o `CANCELADA`. La recepción UC-08 prohíbe cantidades excedentes o compras contra Orden cancelada/completada. REVENTA puede recibirse sin Orden según alcance aprobado.
- Episodio de faltante solo cierra cuando **stock recupera umbral y no quedan Solicitudes ni Órdenes pendientes**. Una actualización de umbral no genera ronda automática retroactiva.
- UC-58 versiona la Política de Compra; `pesoRelativo` y `ordenDesempate` son administrados, sin pesos `40/25/25/10` hardcodeados. Se decidió **puntaje mínimo cero** ante dato faltante; `Precio Total` ascendente es último desempate. **Escalas y normalización de puntuaciones heterogéneas siguen pendientes**.
- Plazo de Cotización no depende de `POLITICA_COMPRA.periodoCalculoDias`: MR-3 propone parámetro global `PLAZO_RESPUESTA_COTIZACION_HORAS`, sin valor inicial inventado. Se copia al Episodio y se congela el vencimiento por Solicitud. Override administrativo solo **antes de emisión efectiva**; no puede modificar Solicitudes ya emitidas. Los ejemplos «48 horas» no fueron aprobados como defecto.

## 5.6 Promociones y vigencias

- Se aprobó el catálogo de `PROMOCION.estado`: `BORRADOR`, `ACTIVA`, `PAUSADA`, `FINALIZADA`, `CANCELADA`. UC-59 consulta; UC-60 desactiva sin reescribir descuentos históricos.
- MR-4 F08 advierte que el trigger propuesto acepta `PAUSADA → ACTIVA`, pero **no existe CU ni permiso de reactivación aprobados**. No conceder ese permiso solo porque el DDL tolere la transición.
- Versiones y vigencias de Recetas, Precios, Políticas comerciales y de compra no deben solaparse. MR-3 utiliza intervalos `[desde, hasta)` y `EXCLUDE GiST` propuestos; su funcionamiento todavía no fue probado en PostgreSQL.

# 6. Roles, permisos y relaciones UML

## 6.1 Roles operativos relevantes

Usuarios internos: **Administrador, Vendedor, Responsable de Producción y Repartidor**; Proveedor accede con Rol **PROVEEDOR** exclusivo. Cliente ONLINE es actor de otro mecanismo de autenticación; MercadoPago y Servicio de Mensajería son sistemas externos. No introducir Rol `SISTEMA` ni `CLIENTE` por conveniencia.

**Alcances confirmados:** UC-29 Cobro manual directo Admin y Vendedor; UC-33 Buscar Cliente directo/contextual Admin y Vendedor; UC-34 Buscar Pedido: Admin directo, Vendedor directo/contextual, Producción contextual, Repartidor contextual **solo asignados**; UC-35 Buscar Producto Admin/Vendedor directo/contextual; UC-36 Buscar Insumo Admin/Producción directo/contextual; UC-37 Buscar Proveedor Admin directo/contextual; UC-40 Buscar Orden de Compra Admin/Producción directo/contextual (**Producción solo lectura**). Consultas nunca otorgan capacidad de modificar. Fuentes antiguas de RBAC marcadas «PROPUESTA» pueden contradecir estos acuerdos posteriores.

**Cuestión abierta:** política del «Reparto Manda» para datos comerciales congelados en una operación offline válida. Su propuesta NO cambia la prohibición de Cobro directo del Repartidor ni anula controles de sesión, duplicados, asignación vigente y reconciliación con el servidor. Requiere procedimiento de conciliación y matriz offline explícita.

## 6.2 Relaciones formalmente aprobadas

- **Legado formal:** **27 «include» + 2 «extend»** según matriz de relaciones del 25/10. Los `«extend»` son **UC-26 → UC-06** (solo reembolso electrónico pertinente) y **UC-40 → UC-08** (búsqueda condicional de Orden de Compra).
- **Nuevas relaciones aceptadas por el usuario el 25/10:** **7 «include»**: UC-51 → UC-36; UC-52 → UC-36; UC-54 → UC-56; UC-55 → UC-56; UC-07 → UC-61; UC-41 → UC-61; UC-12 → UC-62.
- **Total de relaciones ratificadas por alcance:** **34 «include» y 2 «extend» = 36**. Este total representa acuerdos, **no una versión XML actualizada**.
- El archivo CSV `ALE_MILANESAS_MATRIZ_RELACIONES_UML_64_CU_25-10-2026.csv` fue generado **antes de la aprobación de esas siete** y todavía las marca como candidatas; debe ser actualizado como dato estructurado en un trabajo específico, **pero el usuario pidió expresamente NO actualizar el Diagrama de Casos de Uso** tras rechazar la propuesta visual.
- La figura modular generada por IA y rechazada **no es el diagrama maestro**. Conservar el XML original como referencia visual si se solicita retomarlo en el futuro.

# 7. Modelo Relacional: línea base, MR-3 y observaciones MR-4

## 7.1 Evolución numérica y cambio físico

| Versión / corte | Tablas | Columnas | FK | Estado |
|---|---:|---:|---:|---|
| Línea base 23/10 | 59 | 444 | 120 | DDL no ejecutado |
| MR-3, 25/10 | **60** | **453** | **125** | DDL consolidado + migración propuestos, **NO EJECUTADOS** |
| MR-4, 25/10 | 60 | 453 | 125 | Conteo/consistencia de nombres verificada estáticamente; **sin validación ejecutable** |

Nueva tabla: `CONFIGURACION_OPERATIVA` (parámetro global de plazo de respuesta). Nueve columnas agregadas: **4** en esa tabla; **2** en `EPISODIO_FALTANTE`; `idCobroAnulado` en `ORIGEN_MOVIMIENTO_CUENTA`; otro `idCobroAnulado` en `MOVIMIENTO_CAJA`; `idUsuarioReintento` en `INTENTO_REEMBOLSO`. Total nuevas FK: **5**. El detalle físico exacto lo determinan el diccionario y SQL de MR-3, no esta síntesis.

## 7.2 Garantías propuestas vs. garantías realmente validadas

MR-3 incorpora en archivos SQL restricciones para `SALDO_INICIAL`, nombres normalizados, vigencias, cinco estados de Promoción, vencimientos congelados, `ANULACION_COBRO` y autor del reintento. **No equivale a servicios de negocio completos ni a validación de PostgreSQL.**

MR-4 identificó **11 funciones** y **12 triggers** mediante análisis estático; comparó **62 instrucciones normalizadas** de migración y delta del DDL consolidado, y no encontró extremos FK inexistentes a nivel nominal. Estos son controles de inventario y sintaxis léxica, **no pruebas de ejecución ni conformidad funcional completa**.

## 7.3 Hallazgos abiertos MR-4 (requieren solución MR-5)

| ID | Prioridad MR-4 | Problema comprobado / riesgo | Condición de cierre |
|---|---|---|---|
| **F01** | ALTA | Falta `CHECK` para el dominio real `COBRO.estadoCobro`; función usa `ANULADO` pero se aceptaría cualquier literal | Enumeración aprobada + CHECK correcto |
| **F02** | ALTA | Contraasientos: trigger diferido no cubre DELETE ni quitar referencias en ciertas UPDATE | Integridad/inalterabilidad de ambos asientos hasta COMMIT |
| **F03** | ALTA | `SALDO_INICIAL` no fuerza coherencia con `COSTO_INSUMO_HISTORICO.fuenteCosto` del mismo Insumo | Trigger/constraint + pruebas de apertura y costo |
| **F04** | ALTA | Servicio offline ausente; no probado «Reparto Manda» ni RBAC | Pruebas de identidad, alcance, snapshot e idempotencia |
| **F05** | ALTA | PRA-01 no tiene servicio transaccional completo | Prueba concurrente de episodio/única primera ronda/cierre |
| **F06** | ALTA | Procesamiento completo de Reembolsos externos e idempotencia contable incompleto | Notificaciones duplicadas, reintentos y PROCESADO exactamente una vez |
| **F07** | ALTA | Faltan garantías persistentes de último Administrador, Roles y sesiones | Transacciones/privilegios y pruebas de seguridad |
| **F08** | MEDIA | `PAUSADA→ACTIVA` en trigger sin caso de uso/permiso de reactivación | Decisión de autorización o restricción de transición |
| **F09** | ALTA | Bloqueos para entidades inactivas incompletos en cambios concurrentes y UPDATE | Cobertura alta/edición; preservar histórico previo |
| **F10** | MEDIA | No hubo PostgreSQL real para GiST, extensiones, bloqueos o diferidas | Ejecutar pruebas en entorno aislado y registrar evidencia |

**Dictamen preciso:** MR-4 **ESTÁTICA COMPLETADA / EJECUTABLE NO EJECUTADA / TRANSACCIONAL NO CERTIFICADA**. Ocho hallazgos ALTA y dos MEDIA. Nunca etiquetar «base final implementada» hasta ejecutar y pasar MR-6.

# 8. Pendientes funcionales, técnicos y editoriales todavía activos

No todo asunto registrado en RP-01 v1.1 sigue abierto del mismo modo después de MR-3: ese RP fue redactado **antes** de las últimas elecciones. Clasificación para el traspaso:

| Tema | Dictamen al 25/10 | Próxima acción sin asumir nueva aprobación |
|---|---|---|
| Fuente del plazo de cotización (RP-012) | **Resuelto como diseño operativo MR-3:** tabla/configuración global independiente, override previo a emisión y congelamiento por Solicitud; **sin valor numérico por defecto** | Probar transacción y desplegar política de valor inicial con una decisión operativa explícita |
| Ponderación (RP-013) | **Parcial:** pesos configurables; faltante = puntaje cero; Precio Total = desempate final | Especificar normalización, escala, precisión, comparabilidad y pruebas |
| `SALDO_INICIAL` (RP-015) | **Incorporado solo a SQL MR-3**, no ejecutado; F03 detecta integridad insuficiente | Completar vínculo de costeo y validar |
| Responsable del reintento (RP-005 / MR1-31) | `INTENTO_REEMBOLSO.idUsuarioReintento` **en SQL propuesto**; histórico de intentos previos puede requerir recuperación documental | Validar origen real en migración, no rellenar con usuario inventado |
| Promociones (MR1-37) | Cinco estados aprobados y modelados | Resolver F08: reactivación desde PAUSADA y autorización explícita |
| Producto/Proveedor inactivo (MR1-18/48) | No bloquear operaciones ya abiertas, sí impedir nuevas; implementado parcialmente | Resolver F09 con concurrencia |
| Cobros / contraasientos (MR1-33) | Reversión diseñada con FK al Cobro original | Resolver F01/F02; definir derechos y conciliación cuando falte |
| Vencimiento de deuda (MR1-34) | Entrega confirmada como origen; **sin 15 días automáticos** | Definir imputación a Pedidos si requiere deuda individual por antigüedad |
| Reparto offline (MR1-14) | Propuesta de respetar snapshot de transacción válida, **no se habilitó UC-29 al Repartidor** | Definir catálogo de acciones offline y resolución de conflictos; F04 |
| Fecha de reparto ONLINE / reprogramación | Sigue `[A CONFIRMAR]` | Decisión funcional futura si se implementa ese flujo |
| Elegibilidad/offline asignación de Repartidores | Sigue `[A CONFIRMAR]` | Definir alcance y RNF |
| Margen individual | No incorporado | Evaluar solo si se solicita |
| Excepciones de subflujos Fase 4 | **153 rótulos** conservados para lectura semántica | Revisión humana focalizada sin renumeración por aproximación |
| Ajuste de permisos antiguos | Algunas matrices `PROPUESTA` están desactualizadas | Consolidar RBAC definitivo sin ampliar roles por inferencia |
| XML UML de CU | Nuevo diagrama descartado por diseño; 7 relaciones nuevas sí aprobadas | No editar imagen/XML sin pedido nuevo; registrar addendum de relaciones |

# 9. Reglas de colaboración para otros chats / IA

## 9.1 Áreas que pueden desarrollarse en paralelo

| Frente independiente | Entradas que se deben entregar a otra IA | Salida aceptable | Zona de conflicto |
|---|---|---|---|
| MR-5: corrección de SQL | DDL y migración MR-3; MR-4 informe/hallazgos; este handoff | SQL v2 en copia, reporte F01–F10, tests de aceptación | Es dueño de esquema físico: otras tareas no alteran tablas hasta integrar sus cambios |
| MR-6: entorno y tests | MR-4 paquete/plan; esquema MR-3; luego MR-5 | Scripts de laboratorio, resultados reproducibles, logs de ejecución | No declarar éxito antes de correr PostgreSQL; trabajo de preparación en paralelo sí |
| Revisión funcional de subflujos | Fase 4 Word, informe de control, RD/RP | Fe de erratas y propuesta de correcciones con diffs | No modificar modelo ni crear CU nuevos |
| Requisitos y trazabilidad | A–D, 64 CU, RD/RP, MR-3 | Matriz RF/RNF/IRQ → CU → tabla/regla/prueba | No recodificar requisitos por intuición |
| Diseño de interfaz y prototipos | Fase 4, RBAC confirmado y alcance offline | Wireframes y flujos UI sin nuevas decisiones de negocio | No confundir pantallas con nuevos CU ni conceder permisos |
| Arquitectura backend | 64 CU, MR-3, hallazgos MR-4 | Contratos y servicios transaccionales propuestos; ADR | Las invariantes SQL siguen pendientes de MR-5/6 |
| Manual de pruebas de aceptación | CU Fase 4, PRA, MR-4 | Tests funcionales positivos/negativos y matrices | Estados/algoritmos abiertos se marcan pendientes |
| Modelo relacional gráfico futuro | Esquema MR-3 **después de MR-5/6** | Diagrama relacional basado en DDL validado | No reemplazar el diagrama de Casos de Uso rechazado |

**Control de concurrencia documental:** nombrar un **responsable editorial por artefacto**. Otras IA proponen *patches* (diferencias) o solicitudes de cambio, nunca editan simultáneamente la fuente canónica. Al fusionar, contrastar primero fecha, versión, autoridad, pruebas y dependencias.

## 9.2 Contradicciones que otra IA debe detectar y no ocultar

1. **RBAC antiguo:** algunas tablas previas tienen `?` en UC-29 o solo acceso contextual en búsquedas; la decisión posterior habilita Cobro directo a Admin/Vendedor y consulta directa según rol. Aplicar lo posterior; registrar propagación al documento definitivo.
2. **PRA/RP v1.1:** indican que aún se elige fuente del plazo. MR-3 la eligió como configuración global independiente **sin seed**; queda la prueba y valor real de explotación.
3. **UML CSV:** las siete candidatas aparecen «PENDIENTE» porque la matriz fue emitida antes del sí expreso del usuario; el usuario después las **aprobó**, pero **rechazó la gráfica**.
4. **Títulos de CU:** el texto final Fase 4 muestra UC-11 «Gestionar Proveedor» y UC-30 «Gestionar Producto»; las fuentes antiguas dicen «Registrar». No asumir equivalencia funcional para corregir sin comparar.
5. **MR-3 vs MR-4:** MR-3 dice que existen triggers y controles; MR-4 demostró que no cubren todos los casos y que no se ejecutó PostgreSQL.
6. **Desactivaciones:** finalizar operaciones abiertas está aprobado, pero varios escenarios concurrentes carecen de cobertura SQL real.
7. **Offline:** propuesta «El Reparto Manda» no amplía por sí sola los permisos del Repartidor para cobrar manualmente.

# 10. Método recomendado: documentación como código y bitácora de decisiones

**Método propuesto:** repositorio de documentación versionado con **Git** (o equivalente con historial), una línea base por versión, un registro inmutable de decisiones (RD / ADR), registro de pendientes (RP / issues), solicitudes de cambio (CR), bitácoras de sesiones de chat, matriz de trazabilidad y manifiesto de archivos con SHA-256. Se añade el chat completo como evidencia archivada, pero **nunca como única fuente normativa**.

## 10.1 Estructura sugerida del repositorio

```text
ale-milanesas/
  README.md                          # estado actual, enlace a índice, responsable
  CONTEXTO_ACTUAL.md                 # versión breve de este documento
  docs/
    00_gobierno/                    # convenciones, precedencia y metodología
    01_requisitos/                  # RF, RNF, IRQ, objetivos
    02_dominio/                     # entidades conceptuales y reglas
    03_casos_uso/                   # UC-01 a UC-64, 3 niveles
    04_procesos/                    # PRA-01
    05_modelo_relacional/           # diccionario, SQL, migraciones, pruebas
    06_arquitectura/                # diseño técnico y contratos
    07_pruebas/                     # evidencia ejecutada, criterios de aceptación
    08_diagramas/                   # originales y gráficos versionados
  gobierno/
    RD_decisiones.csv                # registro único de decisiones
    RP_pendientes.csv                # pendientes / bloqueos
    CR_cambios.csv                   # solicitud, impacto, autor, revisión
    MATRIZ_trazabilidad.csv          # requisito→CU→objeto→prueba
    CHANGELOG.md                     # cambio visible por versión
    MANIFIESTO_archivos.csv          # ruta, versión, hash, autoridad, estado
  sesiones/
    2026-10-25_chat_X.md             # acta sintética y enlace a transcripción
    transcripciones/                # exportaciones íntegras si se conservan
  entregas/
    baseline_2026-10-25/            # snapshot inmutable
    propuestas/                     # versiones no aprobadas
```

## 10.2 Qué se registra luego de CADA conversación

1. **Datos de sesión:** ID, fecha/hora, chat origen, objetivo, versiones consultadas, responsable, nueva información proporcionada.
2. **Hechos aceptados:** transcribir regla acordada y su justificación; separar `APROBADA_USUARIO`, `PROPUESTA_IA`, `DECISION_TECNICA_DELEGADA`, `PENDIENTE` y `DESCARTADA`.
3. **Diferencias concretas:** archivo de origen, ruta/ID, antes→después, archivos generados, tablas/columnas/CU afectados; no basta «actualizado».
4. **Pruebas y limitaciones:** qué se validó, herramienta/entorno, salida reproducible, qué **NO** se ejecutó.
5. **Pendientes y dueño:** cuestión, prioridad, dependencia, actor que decide, fecha de revisión o evento que la desbloquea.
6. **Propagación:** marcar todos los artefactos tocados o pendientes de sincronizar: RD, RP, PRA, CU, RBAC, UML, esquema, diccionario, DDL y tests.
7. **Cierre y continuidad:** resumen de máximo una página, manifest de archivos nuevos y recomendación para el próximo chat.

Si la plataforma permite exportar la conversación íntegra, conservarla en `sesiones/transcripciones/` con su fecha y origen; **este documento es un resumen reconstruido, no una exportación literal del chat**.\n\nLa IA puede generar el borrador del acta, pero **solo la aceptación explícita del usuario convierte propuestas de negocio en reglas aprobadas**. Las decisiones técnicas delegadas se pueden aplicar dentro de los límites de la delegación, manteniendo prueba y trazabilidad.

## 10.3 Ciclo de control de cambios (CR → RD → artefactos → QA)

| Paso | Acción | Evidencia mínima |
|---|---|---|
| 1. Registrar | Abrir `CR-YYYY-NNN` con necesidad, motivación, artefactos y riesgo | CR + versiones afectadas |
| 2. Evaluar | Analizar impacto RF/CU/UML/DB/RBAC/QA; distinguir alternativa no aprobada | Matriz de impacto |
| 3. Decidir | Crear `RD-YYYY-NNN` si hay regla nueva; o citar RD existente si es mera corrección técnica | Acta de decisión y quién autorizó |
| 4. Implementar | Trabajar en rama/copia; producir diff legible; no sobreescribir baseline | Commit / parche / nuevo archivo |
| 5. Verificar | Pruebas formales, revisión semántica y render de artefactos; adjuntar resultados reales | QA ejecutado / pendientes explícitos |
| 6. Propagar | Actualizar RD, RP, catálogo CU, modelo, migraciones y trazabilidad afectados | Lista de sincronización con estados |
| 7. Publicar | Versionar (`vX.Y.Z`), generar manifiesto y hash, crear snapshot nuevo | Changelog y release |

**Versionado práctico:** `vMAJOR.MINOR.PATCH`; `MAJOR` cambio incompatible de reglas/estructura, `MINOR` nuevo UC o funcionalidad aprobada, `PATCH` corrección editorial/técnica sin cambiar comportamiento. Ej.: `MR-3 v1.0.0` propuesto, `MR-5 v1.1.0` corregido; nunca etiquetar `CERTIFICADO` sin evidencias de PostgreSQL.

## 10.4 Campos obligatorios de cada registro

**RD (decisión):** `decision_id`, `fecha`, `estado`, `autoridad`, `regla_aprobada`, `alternativas_descartadas`, `justificacion`, `artefactos_afectados`, `fuente_chat`, `fecha_propagacion`, `pruebas`. Mantener históricos; para revertir agregar una nueva RD con `sustituye_id`, no borrar la anterior.

**RP (pendiente):** `pendiente_id`, `tipo`, `estado`, `pregunta_exacta`, `contexto`, `riesgo`, `responsable`, `desbloqueo`, `fuentes`, `resuelto_por_RD`, `estado_implantacion`. Resolver RP requiere enlace a RD y, si es físico, evidencia de implementación.

**CR (cambio):** `cambio_id`, `fecha`, `area`, `propuesta`, `origen`, `aprobacion`, `antes`, `despues`, `artefacto`, `version_origen`, `version_destino`, `prueba`, `estado`, `owner`.

**Bitácora de chat:** `sesion_id`, `fecha_hora`, `objetivo`, `archivos_entrada`, `decisiones_usuario`, `decisiones_ia_delegadas`, `propuestas_rechazadas`, `archivos_salida`, `qa_realizado`, `pendientes`, `prompt_de_reanudacion`.

## 10.5 Regla para trabajo simultáneo con dos o más IA

- Cada chat recibe el mismo **paquete de corte**, más un **encargo aislado**; no confiar en memoria compartida entre chats.
- Un chat es *propietario* de cada archivo base: por ejemplo MR-5 de DDL, otro de prototipos, otro de trazabilidad. Los demás proponen parches.
- Cada intervención concluye con **entregables + diff + acta de sesión + inventario de decisiones + lista de artefactos impactados**.
- Un único integrador (el usuario u otro chat rector) revisa los parches por conflicto y publica la versión canónica.
- Si dos equipos necesitan modificar el mismo archivo, serializar la integración: primero aceptar un parche, después rebasar y revisar el siguiente.
- Nunca fusionar con la regla «el archivo más nuevo gana»; comparar IDs RD/CR, alcance, versiones y pruebas.
- Cada chat debe declarar explícitamente: «Fuentes inspeccionadas», «Qué cambié», «Qué no cambié», «Qué no pude validar».

# 11. Instrucción lista para pegar en otro chat

> Estoy trabajando en el Trabajo Final «Sistema de Gestión para Ale Milanesas» (UNaM-FCEQyN). Te adjunto el **kit de continuidad, corte 25/10/2026**, con documento maestro de contexto y fuentes. Considerá vigente el catálogo de **64 CU consecutivos en tres niveles** y el **modelo MR-3 propuesto de 60 tablas/453 columnas/125 FK**, pero recordá que **NO se ejecutó ni certificó en PostgreSQL**. La auditoría MR-4 dejó **10 hallazgos F01–F10**; el siguiente bloque de DB previsto es MR-5. Las siete nuevas relaciones UML `«include»` fueron aprobadas, **pero el diagrama de CU propuesto por IA fue rechazado y NO debe modificarse**. Seguí la jerarquía de autoridad del documento; antes de producir cambios identificá reglas aprobadas, inconsistencias y pendencias, y evitá inventar estados/roles/columnas/porcentajes. Tu tarea específica será: **[PEGAR AQUÍ LA TAREA]**. Trabajá en archivos nuevos, entregá un diff o matriz de cambios, informá qué probaste realmente y redactá una breve acta de sesión para integrar al repositorio.

# 12. Inventario de fuentes necesarias en el kit y lectura recomendada

**Orden de lectura para un nuevo chat:** (1) este documento y el `PROMPT_REANUDACION`; (2) catálogo Word 64 CU + informe Fase 4; (3) RD/RP/PRA v1.1 **con las rectificaciones de §§5 y 8**; (4) MR-3 esquema/diccionario/SQL; (5) MR-4 informe y diez hallazgos; (6) A/B/C/D y DDL de 59 tablas solo si se necesita historia o derivaciones; (7) matriz UML/RBAC y archivo original, prestando atención a sus inconsistencias conocidas.

**Fuentes incluidas en el kit:**

| Grupo de autoridad | Archivo del kit |
|---|---|
| BASE_CONCEPTUAL | `A_Requisitos_ACTUALIZADO_23-10-2026.md` |
| BASE_CONCEPTUAL | `B_Dominio_y_Diseño_ACTUALIZADO_23-10-2026.md` |
| BASE_CONCEPTUAL | `C_CasosDeUso_y_Estado_ACTUALIZADO_23-10-2026.md` |
| BASE_CONCEPTUAL | `D_Decisiones_y_Pendientes_ACTUALIZADO_23-10-2026.md` |
| BASE_CONCEPTUAL | `Esquema_Maestro_Relacional_59_Tablas_ACTUALIZADO_23-10-2026.md` |
| BASE_CONCEPTUAL | `Diccionario_Columnas_59_Tablas_ACTUALIZADO_23-10-2026.csv` |
| BASE_CONCEPTUAL | `Esqueleto_DDL_59_Tablas_NO_EJECUTADO_ACTUALIZADO.sql` |
| CASOS_DE_USO | `ALE_MILANESAS_FASE_4_CU_01_A_64_TRES_NIVELES.docx` |
| CASOS_DE_USO | `C_ANEXO_49_CU_TRES_NIVELES_ACTUALIZADO_23-10-2026.md` |
| CASOS_DE_USO | `FASE_4_INFORME_FINAL_DE_CONTROL_25-10-2026.md` |
| DECISIONES_Y_PROCESO | `RD_01_Registro_Decisiones_V1_1_Fase_2_3_25-10-2026.md` |
| DECISIONES_Y_PROCESO | `RP_01_Registro_Pendientes_V1_1_Fase_2_3_25-10-2026.md` |
| DECISIONES_Y_PROCESO | `PRA_01_Proceso_Reposicion_Automatica_V1_1_Fase_2_3_25-10-2026.md` |
| RELACIONES_Y_PERMISOS | `ALE_MILANESAS_MATRIZ_RELACIONES_UML_64_CU_25-10-2026.csv` |
| RELACIONES_Y_PERMISOS | `Matriz_Rol_x_CU_49_Consecutivos_24-10-2026.md` |
| RELACIONES_Y_PERMISOS | `DIAGRAMA DE CASOS DE USO.drawio (1).xml` |
| MODELO_MR3 | `ALE_MILANESAS_MR3_ESQUEMA_MAESTRO_ACTUALIZADO.md` |
| MODELO_MR3 | `ALE_MILANESAS_MR3_DICCIONARIO_COLUMNAS_ACTUALIZADO.csv` |
| MODELO_MR3 | `ALE_MILANESAS_MR3_DDL_CONSOLIDADO_NO_EJECUTADO.sql` |
| MODELO_MR3 | `ALE_MILANESAS_MR3_MIGRACION_PROPUESTA_NO_EJECUTADA.sql` |
| MODELO_MR3 | `ALE_MILANESAS_MR3_PRECHECK_SOLO_LECTURA.sql` |
| MODELO_MR3 | `ALE_MILANESAS_MR3_INFORME_TECNICO_Y_PENDIENTES.md` |
| REFERENCIAS_ACADEMICAS | `Res_220-15_Trabajo_Final.docx (1).md` |
| REFERENCIAS_ACADEMICAS | `2025 INANSI - 05A - Guía de Consulta Práctica TP 05 - Parte A (1).md` |
| REFERENCIAS_ACADEMICAS | `2025 INANSI - 05A - Guía de Consulta Práctica TP 05 - Parte B (1).md` |
| REFERENCIAS_ACADEMICAS | `2025 INANSI - 05A - Guía de Consulta Práctica TP 05 - Parte C (1).md` |
| REFERENCIAS_ACADEMICAS | `2025 INANSI - 07A - Guía de Consulta Práctica TP 07 - Parte A (1).md` |
| REFERENCIAS_ACADEMICAS | `2025 INANSI - 07B - Guía de Consulta Práctica TP 07 - Parte B (1).md` |
| REFERENCIAS_ACADEMICAS | `EJEMPLOS DE LOS CU EN SUS TRES NIVELES.docx` |
| AUDITORIAS_MR1_MR2 | `ALE_MILANESAS_MR1_AUDITORIA_IMPACTO_RELACIONAL_25-10-2026.xlsx` |
| AUDITORIAS_MR1_MR2 | `ALE_MILANESAS_MR2_MATRIZ_DECISIONES_Y_PLAN_MR3_25-10-2026.xlsx` |
| AUDITORIAS_MR1_MR2 | `ALE_MILANESAS_MR2_DICTAMEN_TECNICO_Y_PLAN_MR3_25-10-2026.md` |
| AUDITORIA_MR4 | `ALE_MILANESAS_MR4_INFORME_VALIDACION_25-10-2026.md` |
| AUDITORIA_MR4 | `ALE_MILANESAS_MR4_HALLAZGOS.csv` |
| AUDITORIA_MR4 | `ALE_MILANESAS_MR4_PLAN_VALIDACION.csv` |
| AUDITORIA_MR4 | `ALE_MILANESAS_MR4_PRUEBAS_POSTGRESQL.sql` |
| AUDITORIA_MR4 | `ALE_MILANESAS_MR4_PAQUETE_VALIDACION_25-10-2026.zip` |

El `MANIFIESTO_FUENTES.csv` adjunto contiene ruta, tamaño y **SHA-256** de cada archivo empaquetado. Los hashes facilitan detectar modificaciones accidentales entre chats. No se incluye el diagrama modular descartado para no confundirlo con un artefacto vigente.

# 13. Lista de verificación de entrega y próxima acción

- [x] Catálogo Word Fase 4 con 64×3 fichas localizado y verificado estructuralmente.
- [x] RD/RP/PRA, SQL MR-3 y auditoría MR-4 identificados; estados diferenciados.
- [x] Acuerdo de **siete «include» nuevas** registrado en esta síntesis como posterior a la matriz CSV.
- [x] Rechazo del **diagrama UML alternativo** y orden de no editarlo registrados.
- [x] Diez hallazgos MR-4 documentados como activos.
- [ ] MR-5: corregir F01–F09 con pruebas y versionar SQL sin sobrescribir MR-3.
- [ ] MR-6: ejecutar DDL, migración, pruebas de negocio, concurrencia, rollback e idempotencia en PostgreSQL aislado.
- [ ] MR-7: actualización futura del **diagrama relacional** si se solicita.
- [ ] Sincronizar formalmente RD/RP 1.1, RBAC y matriz UML con acuerdos posteriores; verificar subflujos Fase 4 según necesidad.
- [ ] Confirmar normativa de deuda imputada, scoring normalizado y reparto offline antes de implementar esas funciones.

**Síntesis final:** el proyecto está en posición de continuar arquitectura, QA, prototipos y trazabilidad en paralelo. **El cierre físico de base de datos depende de MR-5 y de pruebas reales MR-6**; mientras tanto, MR-3 es una propuesta versionada, no una base lista para explotación.
