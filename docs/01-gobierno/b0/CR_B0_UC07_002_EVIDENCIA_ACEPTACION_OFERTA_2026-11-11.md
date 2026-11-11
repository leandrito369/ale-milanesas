# CR-B0-UC07-002 — Modelo físico para evidencia y cotizaciones de UC-07

## 1. Identificación, estado, autoridad y fuentes

**Clase:** Solicitud de Cambio Física (CR-F).

**Estado:** BORRADOR — NO AUTORIZADA — NO CREA MIGRACIONES.

**Fecha de redacción:** 11/11/2026, Argentina; no es fecha de autorización.

**Responsable de autorización:** Victor Leandro Machado (`leandrito369`).

**Fundamento:** RD-UC07-001 y RD-UC07-002. **Contrato relacionado:** CR-B0-UC07-001, PR #47 en revisión.

**Migración:** NO CREADA. **Implementación:** NO AUTORIZADA. **Despliegue:** PAUSADO, [Issue app #28](https://github.com/leandrito369/ale-milanesas-app/issues/28).

### 1.1. Auditoría de fuentes efectivas

| Fuente | Referencia examinada / resultado |
|---|---|
| Gobierno origin/main | `cdd57ed194268f1f5ab29aa0f55781ddddebdfb5`, coincide con el encargo |
| Aplicación origin/main | `d5f7607afb430a251cbf5cc9190a879a7d41416b`; checkout local conservado en `20ce82d` |
| RD-UC07-001 | [PR #45](https://github.com/leandrito369/ale-milanesas/pull/45), merge `914827585c2e9b050f1beffbf7b725d413dd6e7d` |
| RD-UC07-002 | [Documento parcialmente ratificado](RD_UC07_002_EVIDENCIA_ACEPTACION_OFERTA_2026-11-10.md), merge `cdd57ed`; cuatro decisiones, sin autorización física |
| CR-C | [PR #47](https://github.com/leandrito369/ale-milanesas/pull/47), OPEN/DRAFT, HEAD `06bf800cdbfab9eedebe5a7a79e32269df01e63f`; [archivo contractual leído desde esa referencia](https://github.com/leandrito369/ale-milanesas/blob/06bf800cdbfab9eedebe5a7a79e32269df01e63f/docs/01-gobierno/b0/CR_B0_UC07_001_CONTRATO_AUXILIAR_EVIDENCIA_2026-11-11.md), no mergeado ni autorizado |
| G0 fuente / acta | `1263ffc17bd0eb7f3c69faaa9ff5ae556cf9de7e` / `27738b089afdd2698cdae915f75c0e8089a6248a` |
| Flyway | V1__baseline_mr5.sql, V2__f01_cobro_estados.sql, V3__trazabilidad_partidas_insumo.sql; V3 última disponible al corte |
| Colisiones documentales | No se encontró CR_B0_UC07_002 ni variante física equivalente en main, ramas equivalentes o PR abiertas. Precedente CR_B0_F04_001 y nombre sugerido en RD-UC07-002 §15.2 justifican esta nomenclatura |
| Worktrees | Limpios al iniciar; gobierno desde main en rama específica nueva, app solo lectura y sin cambio de checkout |

No se detectó cambio normativo incompatible posterior a las referencias del encargo. Las elecciones pendientes son propuestas evaluables, no discrepancias que autoricen modificar fuentes.

Fuentes de gobierno: [RD-UC07-001](RD_UC07_001_PROPUESTA_EXCEDENTES_FISICOS_2026-11-09.md), D1–D5 y reservas; RD-UC07-002 §§5–11,14–15; [contratos G0 REV04B](../../08-diagramas/consolidacion-b0/CONTRATOS_REV04B_CORREGIDOS_B0_ACTUALIZADO.md) §§5/6; [RBAC](B0_MATRIZ_RBAC_67_OPERACIONES_CIERRE_2026-10-29.csv); [manifiesto G0](G0_MANIFIESTO_CANONICO_67_OPERACIONES_2026-10-29.csv); [RD-UC19-002](RD_UC19_002_ACOTAMIENTO_VIGENCIAS_FUTURAS_2026-11-01.md); [RD-RP022-001](../RD_RP022_001_COSTEO_CONVERSIONES_REDONDEOS_2026-10-27.md).

Fuentes de aplicación, todas al SHA `d5f7607afb430a251cbf5cc9190a879a7d41416b`: [V1](https://github.com/leandrito369/ale-milanesas-app/blob/d5f7607afb430a251cbf5cc9190a879a7d41416b/src/main/resources/db/migration/V1__baseline_mr5.sql), V2/F01, V3/partidas; [ActualizarPrecioVigenteService](https://github.com/leandrito369/ale-milanesas-app/blob/d5f7607afb430a251cbf5cc9190a879a7d41416b/src/main/java/ar/edu/unam/alemilanesas/maestros/ActualizarPrecioVigenteService.java), ConsultarHistorialPreciosService, AplicarAjusteComercialService; precedentes CobroManualService/CargarPedidoService; consumidores adicionales RegistrarPreparacionService y AsignarRepartoService para riesgos de locking. No se ejecutó SQL ni se consultaron datos de entornos destino.

### 1.2. Inventario físico comprobado

| Tabla V1 | PK / relaciones y reglas relevantes |
|---|---|
| PRODUCTO, L25 | idProducto BIGINT, sin generador V1; ELABORADO/REVENTA, activo, unidad y nombre único |
| USUARIO | idUsuario BIGINT; estado HABILITADO/DESHABILITADO. Una FK a usuario no acredita rol ni sesión |
| PEDIDO, L138 | idPedido BIGINT; FK cliente/usuario; ajuste tipo y porcentaje NUMERIC(5,2), totalOriginal NUMERIC(18,2); PENDIENTE/ENTREGADO/CANCELADO; uq_pedido_0 por idOperacionOrigen |
| DETALLE_PEDIDO, L174 | PK (idPedido,numeroDetalle INTEGER); FK producto/unidad/pedido; uq_detalle_pedido_0 por pedido/producto; cantidad NUMERIC(18,3), precio NUMERIC(18,4); ck_detalle_pedido_3 admite línea técnica cero sin precio/promoción |
| EXCEDENTE, L222 | idExcedente BIGINT; fk_excedente_0 a detalle origen compuesto y fk_excedente_1 a movimiento origen; cantidades NUMERIC(18,3), costos NUMERIC(18,4), disponibilidad no negativa y no superior a inicial |
| OFERTA_EXCEDENTE, L243 | idOfertaExcedente BIGINT, uq_oferta_excedente_0 por oferta/excedente; FK excedente (_0), pedido receptor (_1), vendedor (_2); cantidades escala 3, importes escala 2; ck_oferta_excedente_3 gobierna respuesta/fecha/cantidad/importe y queda intacto |
| PRECIO_PRODUCTO, L292 | idPrecio BIGINT; FK producto/usuarios; precioBase NUMERIC(18,4), rango TIMESTAMPTZ; ck_precio_producto_2 limita cancelación previa al comienzo; exclusión GiST ex_precio_producto_no_solape L1041–1043, [desde,hasta), no cancelados |
| MOVIMIENTO_EXCEDENTE, L263 | idMovimientoExcedente BIGINT; FK excedente y (oferta,excedente); uq_movimiento_excedente_0 por oferta; REASIGNACION/DESCARTE, cantidad positiva y costo no negativo |

Convenciones: V1 usa nombres pk_/fk_/uq_/ck_ e índices/EXCLUDE; identificadores BIGINT mayormente sin secuencias. V3 sí incorpora seq_partida_insumo: no extrapolar universalmente ninguno de los patrones. Se observaron triggers MR3/MR5 de inmutabilidad en movimientos financieros/inventario y protección de entidades activas; no hay protección existente del nuevo snapshot, cotizaciones, evidencia o eventos propuestos, ni trigger de inmutabilidad en PRECIO_PRODUCTO. No reutilizar un prefijo histórico como nombre aprobado de mecanismos nuevos.

**Colisión evitada:** fk_oferta_excedente_2 ya apunta de idUsuarioVendedor a USUARIO (V1:919). La FK de precio propone otro nombre: fk_oferta_excedente_precio. Los nombres candidatos deben revisarse nuevamente al implementar.

Búsqueda de semillas/fixtures: no se encontraron INSERT INTO OFERTA_EXCEDENTE en los archivos versionados de app examinados, incluidos recursos/tests. Esto no prueba ausencia de datos en BD destino ni de cargas externas. La migración requiere inventario real autorizado en cada destino.

Idempotencia existente: PEDIDO.idOperacionOrigen/CargarPedidoService y COBRO.claveIdempotenciaOrigen/CobroManualService son patrones específicos de dominio; INTENTO_COMUNICACION e INTENTO_REEMBOLSO tienen claves UUID y relaciones propias. No se encontró registro genérico suficiente de operación/actor/ámbito/huella/recibo de auxiliares. Reutilizar esas tablas alteraría dominios ajenos sin justificación; §10 compara reutilización con persistencia específica.

## 2. Necesidad del cambio físico y alcance

Oferta actual guarda importes redondeados y fecha, pero no precio base ni procedencia. Las nuevas capacidades necesitan conservar cotización previa a aceptación, respaldo original, historial y replay de comandos. La reconstrucción temporal previa tiene dictamen NO DEMOSTRADO; la pérdida al invertir importes no prueba imposibilidad del historial, pero no permite backfill ficticio.

Alcances propuestos: A snapshot; B cotizaciones; C evidencia PostgreSQL P2b; D bitácora; E comandos idempotentes. Todas las nuevas estructuras son subordinadas a UC-07 y requieren autorización expresa. El detalle físico siguiente no está aprobado por el hecho de que su propósito esté ratificado.

## 3. Matriz de decisiones y clasificación

| Definición | Clasificación | Límite |
|---|---|---|
| D-UC07-02-B | RATIFICADA EN RD | Precio congelado e idPrecio con FK obligatorios para nuevas ofertas; implementación no autorizada |
| D-UC07-COT | RATIFICADA EN RD | Principio de versiones antes de aceptación; entidad/PK/DDL final pendientes |
| D-UC07-CRC | RATIFICADA EN RD | Extensión contractual no disruptiva; PR #47 no autorizada |
| D-UC07-P2B, O2 y sustitución | RATIFICADA EN RD como orientación | PostgreSQL y evidencia independiente; PNG/JPEG para evaluación; sin autenticación criptográfica |
| Tablas, columnas adicionales, FK compuesta, índices y generadores de esta CR | PROPUESTA PARA CR-F | Alternativas seleccionadas solo para examinar un candidato coherente |
| PK UUID, V1 interna, intentos, idempotencia/retención, triggers, archivos y locks | PENDIENTE DE DECISIÓN | Revisión conjunta con CR-C y autorización del responsable |
| Nuevos CU, modificación G0, cambio ck_oferta_excedente_3, SQL ejecutado, migración/Java/despliegue | EXCLUIDA | No se realizan ni autorizan aquí |

Las etiquetas de cada sección se extienden a sus tablas y fragmentos SQL. DDL de §15 es PROPUESTA DOCUMENTAL — NO EJECUTAR, no script completo de migración ni evidencia de validación PostgreSQL.

## 4. Alcance A: snapshot comercial y procedencia

**RATIFICADA EN RD:** nuevas ofertas conservan precioBaseUnitarioAplicado NUMERIC(18,4) e idPrecio BIGINT, ambos obligatorios; referencia a PRECIO_PRODUCTO e instante comercial coherente. Captura atómica compatible con UC-19.

**PROPUESTA PARA CR-F:** agregar columnas inicialmente nullable según auditoría de históricos, CHECK de precio positivo y de par completo/ausente, FK fk_oferta_excedente_precio con ON UPDATE/DELETE RESTRICT. El CHECK de par no sustituye obligatoriedad en nuevas ofertas: si hay históricos nulos, evaluar guardia de inserción posterior al corte, validación por servicio y política física que solo permita excepción identificada de legado, sin exención general por rol app. Si no hay históricos, elevar a NOT NULL tras comprobación. Mecanismo definitivo PENDIENTE DE DECISIÓN; no basta permitir NULL indefinidamente a toda fila.

La FK simple solo prueba existencia. Para verificar producto recorrer OFERTA_EXCEDENTE → EXCEDENTE → DETALLE_PEDIDO de origen → PRODUCTO y contrastar PRECIO_PRODUCTO.idProducto. Propuesta preferida para revisión: validación cruzada de inserción mediante función/trigger con lecturas y bloqueos compatibles, más servicio autorizado y permisos restrictivos. Debe comprobar P leído = snapshot, precio no cancelado e intervalo aplicable al instante guardado. No recalcular esa condición sobre UPDATE de respuesta usando el reloj actual: legitimidad inicial y snapshot histórico son hechos distintos.

Alternativa: desnormalizar idProducto y relaciones compuestas hasta precio; implica nuevas columnas/UNIQUE/FKs en varias entidades, mayor alcance que el candidato mínimo. No se adopta ni autoriza. CHECK de fila no puede consultar coherentemente otras tablas; una subconsulta en CHECK no es solución. Los vínculos de origen y pedido receptor que sustentan la comprobación también necesitan protección histórica, no solo los dos campos nuevos.

Evaluar BEFORE UPDATE que rechace cambio de precioBaseUnitarioAplicado/idPrecio y de referencias/fecha/cantidad/importe comercial de oferta ya emitida, más privilegios SQL. Permitir cambios de respuesta que exige ck_oferta_excedente_3, sin congelar toda la fila. Nombre y cuerpo definitivos del trigger pendientes; no usar fk_oferta_excedente_2 ni prefijos MR3 por inercia. Mantenimiento excepcional requeriría rol separado, aprobación y auditoría, no parámetro HTTP o flag de sesión que app pueda falsificar.

**Históricos:** verificar filas y semillas de destinos antes de NOT NULL; no dividir importeInformado para inventar P. Si faltan fuentes inequívocas, detener habilitación de esas ofertas y someter tratamiento a decisión; no afirmar que todas pueden migrarse automáticamente. No se ha comprobado contenido de BD alguna en esta tarea.

## 5. Alcance B: COTIZACION_OFERTA_EXCEDENTE

**RATIFICADA EN RD:** versionado explícito y registro previo a conformidad. **PROPUESTA PARA CR-F:**

| Columna | Tipo candidato / integridad |
|---|---|
| idCotizacion | UUID PK, coherente con CR-C; generación por aplicación candidata, sin DEFAULT elegido |
| idOfertaExcedente | BIGINT NOT NULL FK oferta |
| numeroVersion | INTEGER NOT NULL, >0; única por oferta |
| cantidadCotizada | NUMERIC(18,3) NOT NULL, >0 y no mayor a cantidadOfrecida por validación cruzada |
| importeCalculado | NUMERIC(18,2) NOT NULL, >0; cálculo servidor |
| codigoCotizacion | CHAR(64) NOT NULL, hex SHA-256 candidato, único |
| fechaHoraGeneracion | TIMESTAMPTZ NOT NULL, servidor |
| idUsuarioVendedor | BIGINT NOT NULL FK USUARIO; identidad autenticada |

Conservar codigoOferta como identidad estable de oferta y codigoCotizacion por versión. No se propone columna de codigoOferta obligatoria en padre; puede derivarse de datos originales protegidos. Los componentes/canonización de hash, zona/precisión, codificación y unicidad definitiva son PENDIENTES DE DECISIÓN con CR-C; hash no prueba comunicación. UUID es candidato compartido, no regla aprobada; confirmar generador/PostgreSQL y política ante colisión, sin elegir extensión o random_uuid por supuesto.

Importe parcial: P del snapshot y ajuste congelado en PEDIDO. Subtotal=round(q*P,2,HALF_UP), ajuste=round(subtotal*r/100,2,HALF_UP); descuento resta, recargo suma y SIN_AJUSTE conserva subtotal. Aceptación total usa exactamente importeInformado. No P2, prorrateo del importe redondeado ni UC-15/16. La igualdad entre importe persistido y cálculo es validación cruzada, no garantía de un CHECK positivo.

Proponer UNIQUE(oferta,numeroVersion), UNIQUE(codigoCotizacion), clave candidata UNIQUE(oferta,idCotizacion) para FK compuesta; capturar bajo oferta bloqueada y proteger todas las condiciones emitidas contra UPDATE/DELETE no autorizados. No agregar máquina EMITIDA/ACEPTADA/RECHAZADA/SUPERADA ni índices parciales basados en ella. Usar estado de evidencia para conformidad, sin equipararlo a transferencia.

### Primera versión: elección coordinada con CR-C

| Alternativa | Efecto físico y contractual |
|---|---|
| A — interna atómica con Parte A, recomendada | Oferta y versión 1 completas o rollback de ambas; cantidad inicial=cantidadOfrecida e importe inicial=importeInformado. Misma firma/salida G0; efecto interno subordinado requiere autorización conjunta |
| B — auxiliar posterior antes de comunicar | Oferta puede existir sin versión entre transacciones; prohibir comunicación/registro de evidencia hasta emisión y controlar reintentos. Misma firma, pero requiere flujo explícito |

A es recomendación, NO AUTORIZADA. Si se adopta A, el primer POST auxiliar no debe duplicar V1 por confundir reintento con nueva versión; acordar con CR-C esa semántica. Pruebas F10/F16 y fallo de inserción. No se impone nueva operación principal.

## 6. Alcance C: EVIDENCIA_ACEPTACION_OFERTA

**RATIFICADA EN RD como orientación:** P2b, O2, estados y sustitución previa. **PROPUESTA PARA CR-F:**

| Columna | Tipo candidato / función |
|---|---|
| idEvidencia | UUID PK, mismo candidato de salida CR-C |
| idCotizacion | UUID NOT NULL, versión respaldada |
| idOfertaExcedente | BIGINT NOT NULL si se adopta alternativa B de §8 |
| numeroIntentoEvidencia | INTEGER nullable en candidato, >0 si existe; semántica pendiente, no identidad de versión |
| idUsuarioVendedor | BIGINT NOT NULL FK USUARIO, actor obtenido del principal |
| canalComunicacion | VARCHAR NOT NULL, catálogo/longitud pendientes |
| referenciaContacto | TEXT NOT NULL, contacto cotejado |
| cantidadConfirmada | NUMERIC(18,3) NOT NULL, >0 y coincide con versión |
| importeConfirmado | NUMERIC(18,2) NOT NULL, >0 y coincide con versión/cálculo |
| fechaHoraMensaje | TIMESTAMPTZ NOT NULL, declarada |
| fechaHoraRegistro | TIMESTAMPTZ NOT NULL, servidor |
| contenidoOriginal | BYTEA NOT NULL, bytes documentales seguros originales |
| tipoMimeDeclarado | VARCHAR NOT NULL, captura declaración de la parte multipart |
| tipoMimeContenido | VARCHAR NOT NULL, tipo detectado/validado; no confundir con declarado |
| nombreArchivoOriginal | VARCHAR nullable, metadato opcional no confiable |
| huellaContenido | CHAR(64) NOT NULL, hex SHA-256 servidor sobre bytes |
| declaracionIdentidadVendedor | TEXT NOT NULL, al menos 20 caracteres no blancos |
| estadoEvidencia | VARCHAR(12) NOT NULL, estados de §7 |

La columna MIME declarado adicional está justificada por CR-C §5, que exige conservar declaración y detección separadamente. idUsuarioVendedor es equivalente semántico al registrante servidor, no un nuevo actor aprobado desde HTTP. Longitudes/catálogos no definidos no se inventan como límites definitivos; VARCHAR sin longitud en el candidato no significa admitir cargas ilimitadas en operación.

Cantidad/importe/fecha generación requieren consultar cotización y oferta bajo protocolo transaccional. CHECK(cantidad>0), CHECK(importe>0), CHECK(fechaHoraMensaje<=fechaHoraRegistro) y declaración >=20 no garantizan correspondencia. También comprobar fechaHoraGeneracionCotizacion<=fechaHoraMensaje, ajustando precisión PostgreSQL; tolerancias pendientes con CR-C, sin corregir relojes silenciosamente ni inventar margen monetario.

Evidencia comercial inválida no sustituye a la previa. El candidato guarda únicamente bytes seguros que cumplan integridad mínima: no debilitar NOT NULL/checks para conservar archivos peligrosos o declaraciones inválidas. Si se desea historial de intentos rechazados que no pueden constituir evidencia, definir metadatos seguros/transacción/retención separadamente antes de aprobar; no agregar otra tabla por inferencia aquí.

**Intento documental, PENDIENTE DE DECISIÓN:** definir qué lo inicia, si se numera por cotización u oferta, cómo se conserva INVALIDADA y cómo se diferencia de reenvío HTTP. Recomendar evaluar alcance por cotización y bloqueo de oferta para asignación, pero no imponer UNIQUE(idCotizacion,numeroIntentoEvidencia) hasta decidirlo. No usar numeroVersion para contar cargas de archivos.

## 7. Alcance D: EVENTO_ESTADO_EVIDENCIA_OFERTA

**PROPUESTA PARA CR-F:** bitácora append-only de idEvento (BIGINT candidato, generador pendiente), idEvidencia UUID FK, estadoAnterior nullable, estadoNuevo, idUsuario BIGINT FK, fechaHoraTransicion servidor, motivo obligatorio y ordenEvento BIGINT positivo por evidencia. UNIQUE(idEvidencia,ordenEvento) permite orden inequívoco aun con timestamps iguales; idEvento o reloj por sí solos no prueban secuencia causal. Numerar bajo lock de evidencia/oferta y conservar eventos junto con estado en una sola transacción. No imponer generador MAX+1 global sin coordinación; puede evaluarse secuencia para idEvento, no creada aquí.

Estados preservados: CAPTURADA, VERIFICADA, UTILIZADA, INVALIDADA. Transiciones: CAPTURADA→VERIFICADA, CAPTURADA→INVALIDADA, VERIFICADA→UTILIZADA, VERIFICADA→INVALIDADA. UTILIZADA/INVALIDADA terminales. Evento inicial NULL→CAPTURADA permitido como creación, no una nueva transición comercial. VERIFICADA es validación automática técnica/comercial, no autenticación criptográfica ni aprobación humana ADMIN.

El CHECK de evento puede restringir pares; el estado anterior debe coincidir con último evento/estado real mediante servicio/trigger y locking. Evaluar operación controlada o trigger de transición que registre evento obligatorio y rechace actualización directa sin historial. Resolver actor/motivo confiables y quién puede ejecutar esa operación; un valor de sesión SQL controlable por app no autentica al vendedor. Deshabilitar UPDATE/DELETE de eventos para rol operativo y evaluar triggers defensivos; nombres y funciones no fijados ni código de función ejecutable en esta CR.

Sustitución O2: bloquear oferta y respaldos, validar nueva evidencia completamente; solo entonces anterior VERIFICADA→INVALIDADA por SUPERADA_POR_RECOTIZACION y nueva CAPTURADA→VERIFICADA con eventos. Commit único; cualquier fallo revierte todo y conserva anterior. Emitir una nueva versión sola no invalida respaldo anterior. Parte B posterior consume la VERIFICADA inequívoca y, al transferir con éxito, la pasa a UTILIZADA con evento en la misma transacción que movimiento/stock/oferta. Falta de stock hace rollback, dejando VERIFICADA y sin incremento aceptado/deuda ni movimiento. Rechazo sin evidencia conserva historial e invalida pendientes según contrato que se autorice, sin transferir ni reactivar terminales.

## 8. Integridad referencial y correspondencia entre entidades

| Alternativa evidencia | Garantía y costo |
|---|---|
| A — solo idCotizacion, oferta derivada por JOIN | Menos redundancia y pertenencia natural. Un índice parcial simple por oferta no puede consultar otra tabla; unicidad global por oferta requeriría otro mecanismo/trigger bloqueado. Lecturas y control de ámbito siempre recorren cotización |
| B — ambos IDs y FK compuesta, recomendación candidata | Clave UNIQUE(oferta,idCotizacion) en cotización y FK compuesta desde evidencia. Facilita índices por oferta y control de O2; impide referencias cruzadas. Costo: dato redundante y protección de clave comercial padre |

Se usa B **solo para evaluar coherentemente el DDL candidato de §15**, no se autoriza su adopción. Dos FKs simples independientes no impiden evidencia de oferta A apuntando a cotización de B. Todas las referencias propuestas usan RESTRICT y no CASCADE sobre historia, sin cambiar políticas G0 existentes. Considerar bloqueos a borrado de padres por nuevas FKs como impacto a autorizar, no detalle inocuo.

Invariantes cruzadas restantes: producto correcto del precio (§4), cantidad<=ofrecida, cantidad/importe confirmados iguales a versión, versión calculada D2-A, temporalidad entre tablas, oferta/pedido PENDIENTE y rol activo. FK prueba existencia/pertenencia si es compuesta; UNIQUE máximo una fila de clave; CHECK comprueba fila. Validación comercial, autorización, transición y aislamiento requieren servicio/triggers/locking. El cumplimiento debe mantenerse ante escritores SQL no cooperantes bajo permisos del rol operativo, no solo frente al controlador HTTP.

## 9. Restricciones, unicidad y generadores

**PROPUESTAS:** PK/FKs nuevas, checks positivos, rangos de estados, declaración/tiempo y claves comerciales. Candidatos de evidencia: uq_evidencia_verificada_por_oferta y uq_evidencia_utilizada_por_oferta, parciales por estado.

Ambos índices separados permiten simultáneamente una VERIFICADA y una UTILIZADA. No prueban exclusión entre estados ni que oferta siga PENDIENTE. Bloquear oferta durante O2/Parte B/rechazo, comprobar estado y ausencia de consumo previo y prohibir otra evidencia utilizable tras aceptación; evaluar guardia física cruzada. Durante confirmación exitosa, evidencia y oferta cambian juntas; no abrir nueva aceptación por haber quedado libre el índice VERIFICADA.

No aprobar todavía índice de intentos ni unicidad de huella de archivo: un archivo INVALIDADA puede necesitar política específica y dos archivos distintos pueden ser misma aceptación. UNIQUE(codigoCotizacion) detecta duplicado de código, no prueba representación canónica o comunicación. Si un código colisiona/repite, rechazo y diagnóstico, no resolver cambiando aleatoriamente historia.

Generadores: UUID de cotización/evidencia/comando candidatos coherentes con CR-C, suministro explícito por app, sin elegir extensión/default ratificado. idEvento BIGINT y ordenEvento requieren mecanismo aprobado. Para numeroVersion, candidato lock de oferta + cálculo siguiente bajo ese lock y UNIQUE de defensa; no MAX sin serialización. Para BIGINT de oferta, excedente y movimiento existentes, coordinar todos los futuros escritores UC-05/06/07/41 y espacios de advisory IDs o secuencias aprobadas; no introducir un MAX+1 local que colisione con otro servicio.

## 10. Alcance E: idempotencia y reintentos

CR-C §10 propone Idempotency-Key para emitirCotizacionOfertaExcedente y registrarEvidenciaAceptacionOferta, pendiente de autorización.

| Alternativa | Evaluación |
|---|---|
| A — reutilizar infraestructura existente | Patrones específicos de PEDIDO/COBRO/INTENTO_* sirven de antecedente, pero no contienen alcance/actor/huella/recibo genérico; no demostrado suficiente reutilizarlos sin alterar esos dominios |
| B — registro específico de comandos | Recomendación para revisión: COMANDO_AUXILIAR_UC07, candidato nuevo y no autorizado, dentro de alcance E |

Propuesta B conserva idComando UUID, operacion, idOfertaExcedente BIGINT, idUsuarioVendedor BIGINT, claveIdempotencia TEXT, huellaSolicitud CHAR(64), idCotizacion UUID o idEvidencia UUID según operación, respuesta HTTP/recibo JSONB mínimo y fechaHoraRegistro TIMESTAMPTZ. Candidato UNIQUE(operacion,oferta,vendedor,clave); misma clave/alcance con huella distinta produce conflicto. La huella no forma parte de esa UNIQUE, pues permitiría insertar otra fila al cambiar payload. Cantidad/cotización/metadatos y hash servidor de bytes integran la huella canónica, no boundary multipart ni token.

**Protocolo candidato de recibos completos:** serializar primero la clave de comando mediante lock transaccional dedicado derivado de alcance o mecanismo de reserva equivalente que se apruebe; reautorizar actor/objeto; releer recibo. Si existe y huella coincide, devolver resultado previo sin nuevo efecto; si difiere, 409. Si no existe, ejecutar negocio y guardar recibo completo como última escritura **dentro de la misma transacción**. Commit conjunto. No persistir PENDIENTE parcial en otra transacción ni dejar reserva eterna. Si falla, rollback de efecto y recibo. Peticiones simultáneas de la misma clave esperan y releen; UNIQUE es defensa, no sustituto de protocolo. Definir canonización/espacios de locks; una colisión del hash de lock solo debe serializar solicitudes extra, no confundir identidades reales.

Solo uno de los recursos de resultado será no nulo, según operación. FK compuesta de recurso/oferta evita recibo que apunta a efecto ajeno. JSONB no contiene archivo, contacto, declaración ni secretos; conserva versión de formato, status/recibo mínimo y estado **al registrar**. Replay 200 candidato de CR-C no convierte un antiguo VERIFICADA en aptitud actual: Parte B revalida estado real. Rechazo por permisos actuales precede a devolver recibo; no exponer resultados de otro vendedor.

**PENDIENTE DE DECISIÓN:** formato/límite de clave, canonización, retención/limpieza, fallo transitorio, status definitivo de replay y conducta tras purga. No inventar TTL. Si se elimina deduplicación antes de que cese riesgo de repetición, puede reaparecer efecto: evaluar conservar tombstone/clave y vínculo mínimo, o rechazar reuso conforme contrato autorizado. No prometer exactly-once ilimitado. Huella de contenido por sí sola no identifica comando ni aceptación; distinguir nuevo intento documental, reenvío técnico y evidencia de otra versión. Política de mismo archivo INVALIDADA sigue abierta, sin reactivarla.

## 11. Seguridad documental, tamaños, privacidad y recuperación

**RATIFICADA EN RD como orientación:** original en PostgreSQL/P2b; PNG/JPEG para evaluación inicial. WebP y PDF diferidos; TXT no evidencia única sin garantías adicionales, ZIP/DOCX/ejecutables EXCLUIDOS. No S3/MinIO, integración automática WhatsApp ni mensajes reales en esta tarea.

**PENDIENTE:** calibración de 20–30 archivos representativos, midiendo tamaño, resolución, legibilidad, compresión/fidelidad, memoria, recepción, recuperación, almacenamiento y backups. 2 MiB=2097152 bytes solo candidato; no se incorpora CHECK de ese techo como definitivo. No se realizó calibración.

Evaluar separadamente límite aplicativo configurable, request/multipart, streaming acotado antes de leer todo, dimensiones/image bombs y techo físico defensivo. Si límite app es menor al techo BD, app rechaza antes; si app supera techo BD, revisar configuración antes de activar y traducir rechazo sin error SQL expuesto. No aprobar sin coherencia entre límites ni usar propiedad backend como única integridad. BYTEA/TOAST no valida seguridad, dimensiones o legibilidad ni ofrece límite de negocio por sí mismo.

Lista blanca aprobada al implementar, magic bytes, MIME declarado/detectado, decodificación real segura, rechazo de archivos corruptos/peligrosos y tamaño vacío/excesivo. Conservar bytes recibidos sin recodificación silenciosa, hash servidor y comparación al recuperar. Hash no demuestra remitente, envío ni veracidad y necesita referencia confiable y protección contra cambiar simultáneamente hash/bytes.

Lectura/descarga bajo autorización por objeto y proyección BC07, no-store, sin publicar URL documental ni logs con datos personales/bytes. Proteger backups, restauración y accesos de mantenimiento; minimización de metadatos, retención y eventual eliminación/anonimización conforme política aplicable. No declarar retención eterna ni borrar historia terminal sin reconciliar deberes de auditoría/privacidad. Política autorizada, roles y procedimiento excepcional pendientes; no conceder permiso por FK a USUARIO ni por jerarquía ADMIN.

## 12. Concurrencia y protocolo candidato — RT-UC07-04 ABIERTA

### 12.1. Protocolo observado y captura de oferta

Hecho UC-19: PRODUCTO FOR UPDATE, revalidación de sesión, clock_timestamp, validación de inicio no retroactivo; lock asesor 1919001 para IDs, períodos no cancelados ordenados FOR UPDATE; cierre vigenteHasta y nueva fila/auditorías en una transacción. El instante se toma antes de esperar ese advisory, riesgo a considerar en coordinación. ConsultarHistorialPrecios clasifica actual/futuro/histórico/cancelado y expone auditoría, no garantiza captura de oferta. AplicarAjusteComercialService aplica HALF_UP escalonado; UC-07 conserva ajuste original sin reinvocarlo.

Parte A candidata: identificar producto por cadena de excedente; bloquear raíces/filas según orden global pendiente; tomar clock_timestamp de PostgreSQL después de las esperas relevantes; exigir exactamente un precio no cancelado donde vigenteDesde<=instante y (vigenteHasta IS NULL o vigenteHasta>instante). Capturar precio, referencia, fechaHoraOferta y ajuste original; validar producto/estado, calcular importeInformado e insertar oferta (y V1 si A autorizada) atómicamente. Rechazar cero/múltiples candidatos; no LIMIT 1. No usar now()/transaction_timestamp capturado al inicio ni statement_timestamp de sentencia que esperaba lock como sustituto automático del instante posterior. Reutilizar el mismo valor temporal y definir precisión/aislamiento MVCC para ver la programación pertinente.

### 12.2. Orden de referencia para revisión, no orden global aprobado

Propuesta a auditar: reserva lógica de clave idempotente cuando aplica → PEDIDO(s) por ID ascendente → EXCEDENTE(s) por ID ascendente → PRODUCTO(s) por ID ascendente → PRECIO(s) → OFERTA → COTIZACION → EVIDENCIA → EVENTOS/generadores específicos. Las operaciones solo toman recursos necesarios; no se afirma que UC-19 deba tomar pedidos/excedentes. No fijar números de advisory nuevos sin inventariar espacios existentes.

| Operación candidata | Fragmento / validaciones |
|---|---|
| Parte A | Pedido receptor y excedente, producto/precio coordinados con UC-19; reloj posterior; oferta nueva; no reserva comercial de stock por el mero registro |
| Emitir versión | Clave comando, pedido/ámbito y oferta bloqueada; siguiente versión protegida, cotización inmutable y recibo en mismo commit |
| O2 | Clave comando, pedido/oferta, cotización referida y evidencias; nueva válida antes de invalidar anterior, eventos y recibo juntos |
| Parte B/rechazo | Pedido/excedente/oferta/evidencia según necesidad, revalidar después de esperar, transferencia/estado/evento juntos; rechazo no requiere evidencia |

**Limitación concreta:** RegistrarPreparacionService existente bloquea PEDIDO y luego producto FOR SHARE; imponer PRODUCTO→PEDIDO en nueva Parte A podría formar ciclo con UC-28. El candidato PEDIDO antes de PRODUCTO busca evitar ese ciclo, pero no certifica ausencia de otros. AsignarRepartoService usa advisory 9172001 y (60505,7) antes de bloquear pedidos/asignaciones; CargarPedidoService usa (3003,0), lock por cliente y producto/precio FOR SHARE. Inventariar también UC-47/48 y todos los consumidores antes de aprobar. No se encontró implementación funcional de entrega/cancelación/descarte en el árbol de servicios inspeccionado: sus contratos y futuras transacciones deben coordinarse, no inventar un orden actual probado.

D5-B del antecedente conserva como hipótesis EXCEDENTE→OFERTA→PEDIDO; no es orden ratificado. La discrepancia entre hipótesis y candidato es punto de revisión RT-UC07-04, no permiso de modificar RD ni declarar bloqueo insoluble. No autorizar transacciones hasta resolver orden y generadores.

### 12.3. Carreras obligatorias de revisión y prueba

UC-19 vs creación oferta y límite temporal; dos emisiones misma oferta; dos evidencias válidas; O2 vs Parte B; Parte B vs UC-41; Parte B vs rechazo; doble consumo evidencia/stock; reintentos simultáneos. Añadir UC-05/06 sobre mismo pedido, distintos pedidos con excedente compartido y relación con UC-28. Esperas/serialización deben terminar con rechazo controlado o éxito íntegro, no estados parciales; diseñar timeouts/reintentos acotados de transacción completa sin reintentar semánticamente otra aceptación. Política definitiva pendiente, no número arbitrario de retries.

Un CHECK no evita deadlock; UNIQUE no impone orden ni evita la carrera de leer antes de actualizar; FK no garantiza rol/estado comercial. PostgreSQL/Testcontainers debe comprobar aislamiento, visibilidad después de espera, orden de locks, manejo de conflictos y rollback. Ninguna prueba se ejecutó aquí; RT-UC07-04 permanece ABIERTA.

## 13. Inmutabilidad histórica

| Dato | Protección candidata a aprobar |
|---|---|
| precioBaseUnitarioAplicado, idPrecio y contexto de oferta | Guardias BEFORE UPDATE/DELETE y permisos; inserción cruzada válida; no impedir UPDATE legítimo de respuesta |
| Cantidad/importe/código y referencia de cotización | Tabla comercial insert-only para rol app, trigger contra edición retroactiva, FK RESTRICT; toda recotización es nueva fila |
| Bytes, huella y datos confirmados de evidencia | Inmutables tras registro, solo transición controlada; no transformar original ni reasociar a otra cotización |
| Estado terminal | Rechazar cambios/reuso fuera de mecanismo excepcional formal, preservar eventos |
| Bitácora | Insert-only controlado, restricción de transición y orden, negar UPDATE/DELETE al rol operativo; auditar mantenimiento |
| Recibo idempotente | No cambiar huella/resultado para aceptar otra solicitud; purga solo según política de retención aprobada |

No elegir nombres definitivos de triggers ni entregar cuerpos ejecutables aquí. CHECK limita valores presentes, no compara OLD/NEW; FK prueba referencias, no inmutabilidad de su contenido; permisos/triggers requieren roles, propietario y superusuario fuera del alcance operativo. Evaluar mantenimiento autorizado con respaldo, registro de motivo y verificación, sin afirmar resistencia contra propietario privilegiado. Retención/eliminación legítima de datos personales debe coordinarse antes de implementar esta política, no habilitar borrado ordinario.

## 14. Estrategia Flyway y compatibilidad histórica

**PROPUESTA, NO MIGRACIÓN CREADA.** Nombre ilustrativo `V4__evidencia_aceptacion_oferta_uc07.sql`; V4 no se reserva ni se fija como definitiva. Releer secuencia real de origin/main antes de implementar; V1/V2/V3 aplicadas permanecen intactas.

1. Inventariar versión, catálogo, propietarios/roles, tablas, índices, constraints y triggers en cada destino; detectar colisiones y dependencias, incluidas semillas/fixtures externas.
2. Medir ofertas históricas y cobertura de evidencia del precio. Sin filas comprobadas puede adoptarse NOT NULL global desde creación; con filas, columnas inicialmente nullable y par coherente, y plan explícito de validación/tratamiento aprobado antes de elevar NOT NULL.
3. No inventar precios mediante división de importes ni usar precio actual. Recuperación temporal solo si demostrada inequívoca y aprobada para ese conjunto; si no, mantener bloqueo del flujo histórico pendiente de decisión. No marcar oferta como RECHAZADA ni alterar su estado por conveniencia de migración.
4. Crear dependencias en orden oferta extendida → cotización → evidencia → eventos → recibos, y claves compuestas antes de FKs dependientes; validar referencias y checks, después protecciones/privilegios aprobados. Separar candidatos opcionales de versión definitiva.
5. Coordinar rollout: código antiguo podría insertar ofertas sin snapshot; no permitir convivencia escribiente incompatible con guardia nueva. Plan de pausa de esas escrituras/compatibilidad y activación de gates solo tras autorización, sin levantar #28 aquí.
6. Backup/restauración probados en entorno descartable, conteos antes/después, huellas/contenidos, referencias, nulos y restricciones verificables. Medir duración/locks y necesidades de espacio, sin fijar estrategia online no probada.
7. Fallo de migración debe preservar recuperabilidad y coherencia con Flyway; no editar checksums ni reaplicar a ciegas. Rollback de código no elimina tablas con evidencia; considerar forward-fix o restauración autorizada desde respaldo. Cualquier pérdida de escrituras posteriores debe evaluarse explícitamente.
8. Obtener autorización final del responsable, plan/revisión conjunta y evidencias de prueba. No ejecutar pasos en esta tarea.

## 15. DDL candidato consolidado y decisiones abiertas

**PROPUESTA DOCUMENTAL — NO EJECUTAR.** Fragmentos en este Markdown exclusivamente: no archivo SQL ejecutable, no migración lista para aplicar, sin cuerpos de triggers. Describen un candidato con alternativa B de pertenencia y recibos completos; NO autorizan tipos/índices/retención/PK. Se omiten DEFAULT de identificadores porque generadores no aprobados. El conjunto no cierra guards cruzados y privilegios descritos en §§4–13; tampoco es afirmación de compilación en PostgreSQL.

### 15.1. Extensión de oferta, compatible con auditoría de históricos

```sql
-- PROPUESTA DOCUMENTAL. NO EJECUTAR.
-- Nulabilidad inicial depende de históricos. NOT NULL final según §14.
ALTER TABLE "OFERTA_EXCEDENTE"
  ADD COLUMN "precioBaseUnitarioAplicado" NUMERIC(18,4),
  ADD COLUMN "idPrecio" BIGINT;
ALTER TABLE "OFERTA_EXCEDENTE"
  ADD CONSTRAINT "fk_oferta_excedente_precio"
    FOREIGN KEY ("idPrecio") REFERENCES "PRECIO_PRODUCTO" ("idPrecio")
    ON UPDATE RESTRICT ON DELETE RESTRICT,
  ADD CONSTRAINT "ck_oferta_snapshot_par"
    CHECK (("idPrecio" IS NULL AND "precioBaseUnitarioAplicado" IS NULL)
      OR ("idPrecio" IS NOT NULL AND "precioBaseUnitarioAplicado" IS NOT NULL)),
  ADD CONSTRAINT "ck_oferta_snapshot_positivo"
    CHECK ("precioBaseUnitarioAplicado" > 0);
```

No cambiar fk_oferta_excedente_2 ni ck_oferta_excedente_3. NULL histórico no habilita nuevas ofertas sin snapshot; la guardia/NOT NULL requiere definición y autorización según §4/14.

### 15.2. Cotizaciones candidatas, sin columna de estado

```sql
-- PROPUESTA DOCUMENTAL. NO EJECUTAR.
CREATE TABLE "COTIZACION_OFERTA_EXCEDENTE" (
  "idCotizacion" UUID NOT NULL,
  "idOfertaExcedente" BIGINT NOT NULL,
  "numeroVersion" INTEGER NOT NULL,
  "cantidadCotizada" NUMERIC(18,3) NOT NULL,
  "importeCalculado" NUMERIC(18,2) NOT NULL,
  "codigoCotizacion" CHAR(64) NOT NULL,
  "fechaHoraGeneracion" TIMESTAMPTZ NOT NULL,
  "idUsuarioVendedor" BIGINT NOT NULL,
  CONSTRAINT "pk_cotizacion_oferta" PRIMARY KEY ("idCotizacion"),
  CONSTRAINT "fk_cotizacion_oferta" FOREIGN KEY ("idOfertaExcedente")
    REFERENCES "OFERTA_EXCEDENTE" ("idOfertaExcedente") ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT "fk_cotizacion_usuario" FOREIGN KEY ("idUsuarioVendedor")
    REFERENCES "USUARIO" ("idUsuario") ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT "uq_cotizacion_version" UNIQUE ("idOfertaExcedente", "numeroVersion"),
  CONSTRAINT "uq_cotizacion_codigo" UNIQUE ("codigoCotizacion"),
  CONSTRAINT "uq_cotizacion_oferta_id" UNIQUE ("idOfertaExcedente", "idCotizacion"),
  CONSTRAINT "ck_cotizacion_version" CHECK ("numeroVersion" > 0),
  CONSTRAINT "ck_cotizacion_cantidad" CHECK ("cantidadCotizada" > 0),
  CONSTRAINT "ck_cotizacion_importe" CHECK ("importeCalculado" > 0),
  CONSTRAINT "ck_cotizacion_codigo" CHECK ("codigoCotizacion" ~ '^[0-9a-f]{64}$')
);
```

Formato hex minúsculo candidato coordinado con CR-C; no aprueba algoritmo/canonización. Checks positivos no garantizan importe D2-A ni cantidad<=ofrecida.

### 15.3. Evidencia candidata con pertenencia compuesta

```sql
-- PROPUESTA DOCUMENTAL. NO EJECUTAR.
CREATE TABLE "EVIDENCIA_ACEPTACION_OFERTA" (
  "idEvidencia" UUID NOT NULL,
  "idCotizacion" UUID NOT NULL,
  "idOfertaExcedente" BIGINT NOT NULL,
  "numeroIntentoEvidencia" INTEGER,
  "idUsuarioVendedor" BIGINT NOT NULL,
  "canalComunicacion" VARCHAR NOT NULL,
  "referenciaContacto" TEXT NOT NULL,
  "cantidadConfirmada" NUMERIC(18,3) NOT NULL,
  "importeConfirmado" NUMERIC(18,2) NOT NULL,
  "fechaHoraMensaje" TIMESTAMPTZ NOT NULL,
  "fechaHoraRegistro" TIMESTAMPTZ NOT NULL,
  "contenidoOriginal" BYTEA NOT NULL,
  "tipoMimeDeclarado" VARCHAR NOT NULL,
  "tipoMimeContenido" VARCHAR NOT NULL,
  "nombreArchivoOriginal" VARCHAR,
  "huellaContenido" CHAR(64) NOT NULL,
  "declaracionIdentidadVendedor" TEXT NOT NULL,
  "estadoEvidencia" VARCHAR(12) NOT NULL,
  CONSTRAINT "pk_evidencia_oferta" PRIMARY KEY ("idEvidencia"),
  CONSTRAINT "uq_evidencia_oferta_id" UNIQUE ("idOfertaExcedente", "idEvidencia"),
  CONSTRAINT "fk_evidencia_cotizacion_oferta"
    FOREIGN KEY ("idOfertaExcedente", "idCotizacion")
    REFERENCES "COTIZACION_OFERTA_EXCEDENTE" ("idOfertaExcedente", "idCotizacion")
    ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT "fk_evidencia_usuario" FOREIGN KEY ("idUsuarioVendedor")
    REFERENCES "USUARIO" ("idUsuario") ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT "ck_evidencia_intento" CHECK ("numeroIntentoEvidencia" > 0),
  CONSTRAINT "ck_evidencia_cantidad" CHECK ("cantidadConfirmada" > 0),
  CONSTRAINT "ck_evidencia_importe" CHECK ("importeConfirmado" > 0),
  CONSTRAINT "ck_evidencia_declaracion"
    CHECK (length(regexp_replace("declaracionIdentidadVendedor", '[[:space:]]', '', 'g')) >= 20),
  CONSTRAINT "ck_evidencia_estado"
    CHECK ("estadoEvidencia" IN ('CAPTURADA','VERIFICADA','UTILIZADA','INVALIDADA')),
  CONSTRAINT "ck_evidencia_tiempo" CHECK ("fechaHoraMensaje" <= "fechaHoraRegistro"),
  CONSTRAINT "ck_evidencia_no_vacia" CHECK (octet_length("contenidoOriginal") > 0),
  CONSTRAINT "ck_evidencia_huella" CHECK ("huellaContenido" ~ '^[0-9a-f]{64}$')
);
-- Índices CANDIDATOS, no aprobación definitiva de unicidad/ciclo:
CREATE UNIQUE INDEX "uq_evidencia_verificada_por_oferta"
  ON "EVIDENCIA_ACEPTACION_OFERTA" ("idOfertaExcedente")
  WHERE "estadoEvidencia" = 'VERIFICADA';
CREATE UNIQUE INDEX "uq_evidencia_utilizada_por_oferta"
  ON "EVIDENCIA_ACEPTACION_OFERTA" ("idOfertaExcedente")
  WHERE "estadoEvidencia" = 'UTILIZADA';
```

No CHECK de techo 2097152 ni MIME cerrado como regla definitiva. numeroIntentoEvidencia permite NULL; CHECK no impone existencia ni unicidad del intento, pendientes de semántica. Alternativa A por JOIN exige otro mecanismo para unicidad por oferta: no mezclar sus columnas ausentes con estos índices.

### 15.4. Eventos candidatos y transiciones

```sql
-- PROPUESTA DOCUMENTAL. NO EJECUTAR.
CREATE TABLE "EVENTO_ESTADO_EVIDENCIA_OFERTA" (
  "idEvento" BIGINT NOT NULL,
  "idEvidencia" UUID NOT NULL,
  "estadoAnterior" VARCHAR(12),
  "estadoNuevo" VARCHAR(12) NOT NULL,
  "idUsuario" BIGINT NOT NULL,
  "fechaHoraTransicion" TIMESTAMPTZ NOT NULL,
  "motivo" TEXT NOT NULL,
  "ordenEvento" BIGINT NOT NULL,
  CONSTRAINT "pk_evento_evidencia" PRIMARY KEY ("idEvento"),
  CONSTRAINT "fk_evento_evidencia" FOREIGN KEY ("idEvidencia")
    REFERENCES "EVIDENCIA_ACEPTACION_OFERTA" ("idEvidencia") ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT "fk_evento_usuario" FOREIGN KEY ("idUsuario")
    REFERENCES "USUARIO" ("idUsuario") ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT "uq_evento_evidencia_orden" UNIQUE ("idEvidencia", "ordenEvento"),
  CONSTRAINT "ck_evento_orden" CHECK ("ordenEvento" > 0),
  CONSTRAINT "ck_evento_motivo" CHECK (length(btrim("motivo")) > 0),
  CONSTRAINT "ck_evento_transicion" CHECK (
    ("estadoAnterior" IS NULL AND "estadoNuevo" = 'CAPTURADA')
    OR ("estadoAnterior" IS NOT NULL AND (
      ("estadoAnterior" = 'CAPTURADA' AND "estadoNuevo" IN ('VERIFICADA','INVALIDADA'))
      OR ("estadoAnterior" = 'VERIFICADA' AND "estadoNuevo" IN ('UTILIZADA','INVALIDADA'))
    ))
  )
);
```

El predicado explícito IS NOT NULL evita que un par ilegal con anterior NULL pase por resultado UNKNOWN de CHECK. Aun así, necesita cotejo del estado real, evento inicial único, secuencia sin saltos injustificados y protección física append-only; no están implementados por este fragmento.

### 15.5. Recibos completos candidatos de comandos

```sql
-- PROPUESTA DOCUMENTAL. NO EJECUTAR.
CREATE TABLE "COMANDO_AUXILIAR_UC07" (
  "idComando" UUID NOT NULL,
  "operacion" VARCHAR NOT NULL,
  "idOfertaExcedente" BIGINT NOT NULL,
  "idUsuarioVendedor" BIGINT NOT NULL,
  "claveIdempotencia" TEXT NOT NULL,
  "huellaSolicitud" CHAR(64) NOT NULL,
  "idCotizacion" UUID,
  "idEvidencia" UUID,
  "estadoHttpOriginal" INTEGER NOT NULL,
  "respuestaOriginal" JSONB NOT NULL,
  "fechaHoraRegistro" TIMESTAMPTZ NOT NULL,
  CONSTRAINT "pk_comando_aux_uc07" PRIMARY KEY ("idComando"),
  CONSTRAINT "uq_comando_aux_uc07_clave"
    UNIQUE ("operacion", "idOfertaExcedente", "idUsuarioVendedor", "claveIdempotencia"),
  CONSTRAINT "fk_comando_aux_oferta" FOREIGN KEY ("idOfertaExcedente")
    REFERENCES "OFERTA_EXCEDENTE" ("idOfertaExcedente") ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT "fk_comando_aux_usuario" FOREIGN KEY ("idUsuarioVendedor")
    REFERENCES "USUARIO" ("idUsuario") ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT "fk_comando_aux_cotizacion" FOREIGN KEY ("idOfertaExcedente", "idCotizacion")
    REFERENCES "COTIZACION_OFERTA_EXCEDENTE" ("idOfertaExcedente", "idCotizacion")
    ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT "fk_comando_aux_evidencia" FOREIGN KEY ("idOfertaExcedente", "idEvidencia")
    REFERENCES "EVIDENCIA_ACEPTACION_OFERTA" ("idOfertaExcedente", "idEvidencia")
    ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT "ck_comando_aux_resultado" CHECK (
    ("operacion" = 'EMITIR_COTIZACION' AND "idCotizacion" IS NOT NULL AND "idEvidencia" IS NULL)
    OR ("operacion" = 'REGISTRAR_EVIDENCIA' AND "idEvidencia" IS NOT NULL AND "idCotizacion" IS NULL)
  ),
  CONSTRAINT "ck_comando_aux_clave" CHECK (length(btrim("claveIdempotencia")) > 0),
  CONSTRAINT "ck_comando_aux_huella" CHECK ("huellaSolicitud" ~ '^[0-9a-f]{64}$'),
  CONSTRAINT "ck_comando_aux_http" CHECK ("estadoHttpOriginal" BETWEEN 200 AND 299),
  CONSTRAINT "ck_comando_aux_json" CHECK (jsonb_typeof("respuestaOriginal") = 'object')
);
```

Los tipos, literales de operación, JSONB, claves e índices son candidatos de revisión, no políticas aprobadas. Validar respuesta mínima por operación contra esquema contractual y tamaño seguro; JSONB objeto por sí solo no impide datos sensibles. Limitar tamaño de clave antes de persistir y evaluar impacto sobre índice B-tree; no dejar TEXT ilimitado como solución operativa. No se define TTL/default ni registro PENDIENTE confirmado. Todo guard/trigger/privilegio aún no definido debe resolverse antes del DDL definitivo, no suplirse con suposiciones sobre este bloque.

## 16. Compatibilidad con línea base G0

64 CU y 67 firmas principales intactos. Parte A registrarOfertaExcedente(Long,Long,BigDecimal) y Parte B registrarRespuestaOfertaExcedente(Long,Boolean,BigDecimal) conservadas; no se agregan IDs de cotización/evidencia a esas firmas. Ambas auxiliares de CR-C subordinadas y solo VENDEDOR=D; FK a actor no amplía RBAC ni concede rol ADMIN aprobador.

ck_oferta_excedente_3, migraciones V1/V2/V3, contratos REV04B, manifiestos, RBAC, source-lock y RDs anteriores intactos. No se ejecuta SQL ni crea migración real. TotalOriginal y cantidadOriginal originales no cambian; línea técnica D1-B solo al aceptar dentro de Parte B, sin nueva preparación de excedentes. Se preservan cargo UC-05 y separación de efectivo en tránsito; no modificación de CR-B0-F04-001.

## 17. Coordinación cruzada CR-C ↔ CR-F

### 17.1. Datos y tipos

CR-C comparada: PR #47, HEAD `06bf800cdbfab9eedebe5a7a79e32269df01e63f`, no modificarla.

| Elemento | CR-C | CR-F candidata | Coincide |
|---|---|---|---|
| idCotizacion | UUID conceptual candidato | UUID PK/FK | Sí como candidato; elección final conjunta |
| idEvidencia | UUID candidato | UUID PK | Sí, no ratificado físicamente |
| codigoOferta | Identidad estable padre | Derivación sobre datos originales protegidos | Sí; no columna obligatoria nueva |
| codigoCotizacion | String de versión | CHAR(64) hex candidato | Sí conceptual; canonización definitiva pendiente |
| numeroVersion | int salida | INTEGER positivo y UNIQUE por oferta | Sí; generador pendiente |
| numeroIntentoEvidencia | Semántica pendiente | INTEGER nullable, sin UNIQUE aún | Sí; no confundir con versión/HTTP |
| cantidadConfirmada | Entrada validada BigDecimal | NUMERIC(18,3), cotejo con cotización | Sí |
| importeConfirmado | Entrada no autoritativa | NUMERIC(18,2), igualdad/cálculo servidor | Sí |
| fechaHoraMensaje | OffsetDateTime declarada | TIMESTAMPTZ | Sí; precisión/tolerancia pendientes |
| fechaHoraRegistro | Salida servidor | TIMESTAMPTZ servidor | Sí |
| Estados evidencia | Cuatro estados/transiciones, terminales | CHECK + eventos + transición controlada propuesta | Sí, requiere mecanismo físico |
| Idempotency-Key | Ámbito operación/oferta/actor/payload | COMANDO_AUXILIAR_UC07 y protocolo completos propuestos | Sí conceptual; retención/status/canonización por resolver |
| Límites de archivo | 2 MiB candidato; calibración | Sin techo físico definitivo | Sí; admisión definitiva pendiente |
| Actor vendedor | Principal autenticado | FK USUARIO y eventos con actor servidor | Sí; FK no sustituye autorización |
| MIME declarado y validado | Ambos conservados | tipoMimeDeclarado y tipoMimeContenido | Sí |

### 17.2. Reglas contractuales y garantías físicas

| Regla CR-C | Persistencia necesaria | Constraint, lock o transacción candidata | Prueba |
|---|---|---|---|
| Emisión | Oferta/snapshot y cotización | Validación cruzada D2-A, lock oferta, recibo mismo commit | F01,F11,F13,F14 |
| V1 inicial | Oferta + versión 1 | A atómica recomendada o B con flujo bloqueado hasta emisión | F10,F45 |
| Numeración concurrente | numeroVersion | Lock oferta + UNIQUE; no MAX sin coordinación | F12,F16 |
| Registro evidencia | Cotización, bytes, metadatos | FK compuesta, checks y validación servidor | F17–F21,F29–F35 |
| Sustitución atómica | Dos evidencias y eventos | Oferta bloqueada; nueva válida antes de invalidar, commit único | F22,F23,F40,F41 |
| Transiciones/bitácora | Estado y eventos | Pares, orden por evidencia, operación controlada, append-only | F24,F27,F36,F37,F45 |
| Idempotencia/replay | Clave/huella/efecto/recibo | UNIQUE por alcance, serialización previa y atomicidad | F16,F46–F48 |
| Correlación comercial | Cotización + pertenencia | FK compuesta y cotejo de cantidad/importe/tiempo | F18–F20,F28 |
| Datos/recuperación | Bytes, huella, accesos/backup | Permisos, hash, controles streaming, no-store y retención | F29–F39 |
| Inmutabilidad | Snapshot, versiones, evidencia/eventos | Permisos y guardias físicas pendientes, RESTRICT | F08,F15,F27,F35,F36 |
| Rechazo/confirmación final | Oferta/movimiento/stock/evidencia | Rechazo sin evidencia, serialización y rollback Parte B | F24–F28,F42,F43 |

Compatibilidad conceptual encontrada, no compatibilidad física ya demostrada. **Pendientes bloqueantes para autorización conjunta:** V1 A/B, UUID/generadores, semántica intentos, llave/hash/replay/retención, tipo/longitudes MIME y clave, límites calibrados, estado por versión si se justifica, guardias y orden global. No hay contradicción ratificada insalvable encontrada; las diferencias entre alternativa física A/B son elecciones de revisión, no modificación unilateral de CR-C. Si se descubre incompatibilidad no representable o se cambia un principio, documentar discrepancia, proponer corrección y solicitar decisión del responsable; no editar PR #47 ni declarar autorizada esta CR.

## 18. Plan de pruebas PostgreSQL/Testcontainers

Todas las filas: **PROPUESTAS DOCUMENTADAS — NO IMPLEMENTADAS — NO EJECUTADAS — NO APROBADAS**. B0 documental no ejecuta estos escenarios. Precondiciones aluden a un futuro entorno descartable autorizado con esquema candidato definitivo, datos sintéticos y actores correctos; no a producción. IDs F locales a esta CR.

| ID | Precondición | Acción | Resultado esperado | Componente |
|---|---|---|---|---|
| F01 | Precio aplicable único | Crear oferta | P, idPrecio e instante coherentes | Snapshot |
| F02 | Ningún precio registrado | Ofertar | Rechazo sin oferta inventada | Precio/Parte A |
| F03 | Hueco entre vigencias | Ofertar en hueco | Rechazo cero candidatos | Precio |
| F04 | Precio programado cancelado | Buscar/ofertar | No se selecciona cancelado | Precio |
| F05 | Oferta creada | UC-19 cambia precio | Snapshot/oferta intactos | UC-19/Oferta |
| F06 | Límite exacto y escritor UC-19 concurrente | Crear dos ofertas | Precio correcto por instante, sin lectura incoherente | MVCC/Precio |
| F07 | Precio de otro producto | Insertar oferta vinculándolo | Rechazo de correspondencia | Guardia snapshot |
| F08 | Snapshot creado | Cambiar P/idPrecio no autorizado | Rechazo e historia intacta | Inmutabilidad |
| F09 | Oferta histórica sin snapshot | Migrar/habilitar flujo | Plan aprobado, sin P inventado ni excepción silenciosa | Históricos |
| F10 | Parte A autorizada con alternativa elegida | Crear V1 | Cantidad/importe iguales al padre, atomicidad/flujo según decisión | Cotización |
| F11 | Oferta con P congelado | Cotizar parcial V2 | P/ajuste originales | Cotización |
| F12 | Oferta compartida | Dos emisiones simultáneas | Versiones únicas, resultado controlado | Numeración |
| F13 | Cantidad escala 3 y P escala 4 | Calcular parcial | HALF_UP subtotal/ajuste, escala 2 y rangos válidos | Cálculo |
| F14 | Cotizaciones existentes y cambio UC-19 | Recotizar y consultar anteriores | Todas conservan condiciones de oferta | Snapshot/Cotización |
| F15 | Versión emitida | UPDATE cantidad/importe/código | Rechazo no autorizado | Inmutabilidad |
| F16 | Comando emisión previo | Repetir misma clave/payload | Mismo efecto, sin versión extra | Idempotencia |
| F17 | Cotización válida y archivo seguro | O2 | CAPTURADA→VERIFICADA y eventos consistentes | Evidencia |
| F18 | Cotización de oferta distinta | Vincular evidencia a otro padre | FK/validación rechaza | Pertenencia |
| F19 | Cantidad no coincide | O2 | Rechazo sin sustituir previa | Validación |
| F20 | Importe no coincide | O2 | Rechazo sin cambiar precio ni versión | Validación |
| F21 | Contenido/aceptación ya registrados | Repetir fuera de replay | Manejo según política aprobada sin doble consumo | Duplicados |
| F22 | Evidencia anterior VERIFICADA | Capturar nueva inválida o fallo | Anterior intacta | O2/Rollback |
| F23 | Anterior y sustituta válida | O2 completa | Invalidación/verificación/eventos juntos | O2 |
| F24 | VERIFICADA y stock suficiente | Parte B | Transferencia/oferta/UTILIZADA/eventos juntos | Confirmación |
| F25 | VERIFICADA, stock consumido concurrentemente | Parte B falla | Rollback sin transferencia ni incremento/deuda; sigue VERIFICADA | Confirmación |
| F26 | Oferta sin evidencia | Rechazar | Permitido, historia preservada y pendientes tratados | Rechazo |
| F27 | UTILIZADA o INVALIDADA | Editar/reutilizar | Rechazo terminal | Evidencia |
| F28 | Sin cotización o sin respaldo inequívoco | Confirmar | Rechazo sin transferencia | Parte B |
| F29 | PNG/JPEG legítimos bajo política aprobada | Capturar | Bytes preservados y validación correcta | Archivos |
| F30 | MIME declarado distinto de magic bytes | Capturar | Rechazo | Archivos |
| F31 | Imagen corrupta/no decodificable | Capturar | Rechazo seguro | Archivos |
| F32 | Archivo vacío o excede límite aprobado | Capturar | Rechazo antes de consumo descontrolado | Límites |
| F33 | Dimensiones peligrosas | Decodificar bajo control | Rechazo sin agotar memoria | Seguridad |
| F34 | Evidencia almacenada | Recuperar y comparar SHA-256 | Bytes y huella coinciden | Recuperación |
| F35 | Contenido/huella existentes | UPDATE no autorizado | Rechazo | Inmutabilidad |
| F36 | Bitácora registrada | UPDATE/DELETE rol operativo | Rechazo, historia íntegra | Auditoría |
| F37 | Dos eventos con timestamp igual | Ordenar/reconstruir estado | ordenEvento inequívoco y causal | Auditoría |
| F38 | Actor no autorizado y actor habilitado | Lectura/descarga | Denegación adecuada y no-store | Acceso |
| F39 | Operaciones con datos personales | Examinar logs | Sin contenido, datos personales ni binarios | Privacidad |
| F40 | Dos nuevas evidencias válidas | O2 simultáneos | Sustitución serializada y máximo apto por oferta | Unicidad/Locks |
| F41 | O2 y Parte B simultáneos | Ejecutar ambas | No sustituir evidencia consumida ni doble uso | Locks |
| F42 | Parte B vs UC-41 o rechazo | Ejecutar simultáneo | Stock/estado coherentes y conflicto controlado | Locks |
| F43 | Misma evidencia/stock | Doble confirmación | Una transferencia, ninguna duplicación | Parte B |
| F44 | UC-07/UC-19 con esperas e IDs | Intercalar transacciones | Reloj/visibilidad/orden compatibles, sin deadlock | RT-UC07-04 |
| F45 | Fallo inducido en inserción/evento/recibo | Abortar transacción | Rollback completo, sin eventos/efectos huérfanos | Atomicidad |
| F46 | Commit exitoso y respuesta perdida | Reenviar clave/payload | Recibo determinista y sin nuevo efecto | Idempotencia |
| F47 | Clave usada con payload distinto | Reenviar modificado | 409 controlado, ninguna mutación | Idempotencia |
| F48 | Dos comandos simultáneos misma clave | Ejecutar en paralelo | Un efecto/recibo, segundo replay | Idempotencia |
| F49 | Pedido UC-03 con líneas originales | Agregar/reutilizar técnica y replay UUID | Conteo original y totalOriginal preservados, fix independiente verde | Regresión UC-03 |

Ampliaciones del plan: fallos y versión antigua V2 con evidencia aún válida tras emitir V3 sin aceptación; cruce con UC-05/06 y UC-28, distintos pedidos/excedentes, replay tras cierre/revocación, purga idempotente, restore y comparación de huellas. Definir timeouts/instrumentación y reproducibilidad de intercalados, confirmar cantidad de pruebas ejecutadas y resultados en CI del SHA funcional. No marcar RT-UC07-04 cerrada por el mero diseño ni confundir pruebas ya existentes de UC-19 con estas.

## 19. Riesgos, exclusiones y criterios de autorización

Riesgos bloqueantes: correlación temporal/producto insuficiente con FK simple; pares snapshot nulos históricos; incoherencia entre límite aplicativo/físico; heredados sin fuente exacta de P; duplicados semánticos no detectables solo por hash; dos índices parciales no excluyentes entre sí; relojes coincidentes sin orden; eventos/estado no atómicos; ciclos por invertir PEDIDO/PRODUCTO; purga prematura de claves; escrituras privilegiadas fuera del servicio; identidad manual no autenticada; borrado de datos personales frente a historial terminal. Cada uno requiere solución verificable antes de autorizar, no aprobación por omisión.

**Para autorizar:** revisión del responsable y cruzada con PR #47; resolver tipos/PK/generadores, V1 A/B, pertenencia compuesta o JOIN y correspondencia producto/precio, intentos/índices, mecanismo físico de inmutabilidad/auditoría, retención y recibos de idempotencia, calibración y política documental, tratamiento de históricos, diseño suficiente RT-UC07-04, privilegios/seguridad y plan de pruebas. Compatibilidad conjunta demostrada y autorización expresa con fecha/alcance reales. No exigir CR-C mergeada para redactar esta CR-F ni crear dependencia circular entre merges.

Aprobar diseño no equivale a ejecutar pruebas; pruebas reales y fix UC-03 pertenecen al corte funcional antes de su merge conforme las RDs. Merge documental de CR-F no autoriza automáticamente crear/ejecutar migración. Issue #28 sigue bloqueando producción; no levantar pausa, perfiles o flags.

**EXCLUIDAS:** implementación UC-07, corrección UC-03, SQL ejecutado, creación de V4 u otra migración, cambio V1/V2/V3, Java/tests/configuración de aplicación, source-lock, contratos/manifiesto/catálogo/RBAC G0, otras RDs/CRs, modificación o merge de PR #47, autorización de CR-C/CR-F, envío de mensajes y despliegue. Único archivo nuevo: esta CR-F; los bloques SQL son documentación candidata no ejecutada.

## 20. Firmas

**Redactada por:** Codex, agente técnico, para revisión cruzada del responsable.

**Fecha de redacción:** 11/11/2026.

**Estado:** BORRADOR — NO AUTORIZADA — NO CREA MIGRACIONES.

**Responsable de autorización:** Victor Leandro Machado (`leandrito369`).

**Firma y fecha de autorización:** PENDIENTES, no atribuidas. **Implementación y despliegue:** NO AUTORIZADOS por este documento.
