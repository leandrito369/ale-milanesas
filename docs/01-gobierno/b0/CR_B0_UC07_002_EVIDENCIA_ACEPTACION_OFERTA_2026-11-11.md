# CR-B0-UC07-002 — Modelo físico para evidencia y cotizaciones de UC-07

## 1. Identificación, estado, autoridad y fuentes

**Clase:** Solicitud de Cambio Física (CR-F).

**Estado:** OPEN / DRAFT — NO AUTORIZADA INTEGRALMENTE — NO CREA MIGRACIONES.

**Fecha de redacción:** 11/11/2026, Argentina; no es fecha de autorización. **Historial Etapa B:** 12/11/2026, convergencia propuesta. **Actualización C1:** 12/11/2026, A–C ratificadas; D–E candidatas especificadas; F–H pendientes.

**Responsable de autorización:** Victor Leandro Machado (`leandrito369`).

**Fundamento:** RD-UC07-001 y RD-UC07-002. **Contrato relacionado:** CR-B0-UC07-001, PR #47 en revisión.

**Migración:** NO CREADA. **Implementación:** NO AUTORIZADA. **Despliegue:** PAUSADO, [Issue app #28](https://github.com/leandrito369/ale-milanesas-app/issues/28).

### 1.1. Fuentes de redacción/Etapa B y actualización C1

| Fuente | Referencia examinada / resultado |
|---|---|
| Gobierno origin/main | `cdd57ed194268f1f5ab29aa0f55781ddddebdfb5`, coincide con el encargo |
| Aplicación origin/main en auditoría histórica Etapa B | `d5f7607afb430a251cbf5cc9190a879a7d41416b`; checkout local conservado en `20ce82d` |
| RD-UC07-001 | [PR #45](https://github.com/leandrito369/ale-milanesas/pull/45), merge `914827585c2e9b050f1beffbf7b725d413dd6e7d` |
| RD-UC07-002 | [Documento parcialmente ratificado](RD_UC07_002_EVIDENCIA_ACEPTACION_OFERTA_2026-11-10.md), merge `cdd57ed`; cuatro decisiones, sin autorización física |
| CR-C | [PR #47](https://github.com/leandrito369/ale-milanesas/pull/47), OPEN/DRAFT, HEAD C1 `0b75eb4ca32db9481e22a34c80eb637b80351a31` (examinado inicialmente `7a4887d0c447c7ee82ce0c729d9360b8cbc1c661`); [archivo contractual leído desde esa referencia](https://github.com/leandrito369/ale-milanesas/blob/0b75eb4ca32db9481e22a34c80eb637b80351a31/docs/01-gobierno/b0/CR_B0_UC07_001_CONTRATO_AUXILIAR_EVIDENCIA_2026-11-11.md), no mergeado ni autorizado |
| G0 fuente / acta | `1263ffc17bd0eb7f3c69faaa9ff5ae556cf9de7e` / `27738b089afdd2698cdae915f75c0e8089a6248a` |
| Flyway | V1__baseline_mr5.sql, V2__f01_cobro_estados.sql, V3__trazabilidad_partidas_insumo.sql; V3 última disponible al corte |
| Identidad histórica de Etapa B | Se actualizó la CR-F existente de PR #48 desde `115f4948f47f9754118ba46f7c3ff8973ebe9930`; CR-C desde `06bf800cdbfab9eedebe5a7a79e32269df01e63f` al SHA nuevo indicado arriba; sin nueva CR/PR |
| Worktrees | Limpios al iniciar Etapa B; ramas existentes #47/#48; app solo lectura, HEAD local `20ce82d0ce564b77034aba97e0eef8b3fd75e684` sin cambio de checkout |

No se detectó cambio normativo incompatible posterior a las referencias del encargo. Las elecciones pendientes son propuestas evaluables, no discrepancias que autoricen modificar fuentes.

Fuentes de gobierno: [RD-UC07-001](RD_UC07_001_PROPUESTA_EXCEDENTES_FISICOS_2026-11-09.md), D1–D5 y reservas; RD-UC07-002 §§5–11,14–15; [contratos G0 REV04B](../../08-diagramas/consolidacion-b0/CONTRATOS_REV04B_CORREGIDOS_B0_ACTUALIZADO.md) §§5/6; [RBAC](B0_MATRIZ_RBAC_67_OPERACIONES_CIERRE_2026-10-29.csv); [manifiesto G0](G0_MANIFIESTO_CANONICO_67_OPERACIONES_2026-10-29.csv); [RD-UC19-002](RD_UC19_002_ACOTAMIENTO_VIGENCIAS_FUTURAS_2026-11-01.md); [RD-RP022-001](../RD_RP022_001_COSTEO_CONVERSIONES_REDONDEOS_2026-10-27.md).

Fuentes de aplicación, todas al SHA `d5f7607afb430a251cbf5cc9190a879a7d41416b`: [V1](https://github.com/leandrito369/ale-milanesas-app/blob/d5f7607afb430a251cbf5cc9190a879a7d41416b/src/main/resources/db/migration/V1__baseline_mr5.sql), V2/F01, V3/partidas; [ActualizarPrecioVigenteService](https://github.com/leandrito369/ale-milanesas-app/blob/d5f7607afb430a251cbf5cc9190a879a7d41416b/src/main/java/ar/edu/unam/alemilanesas/maestros/ActualizarPrecioVigenteService.java), ConsultarHistorialPreciosService, AplicarAjusteComercialService; precedentes CobroManualService/CargarPedidoService; consumidores adicionales RegistrarPreparacionService y AsignarRepartoService para riesgos de locking. No se ejecutó SQL ni se consultaron datos de entornos destino.

### Actualización C1 — hechos verificados y autoridad (12/11/2026)

**HECHO VERIFICADO:** gobierno origin/main sigue `cdd57ed194268f1f5ab29aa0f55781ddddebdfb5`; aplicación main vigente `4dbe38668fc5cbc08d04e10920e3bf165c71be11`. El checkout app local se preserva en `20ce82d0ce564b77034aba97e0eef8b3fd75e684`, solo lectura; no se confunde con la base vigente. Las referencias d5f7607 de auditoría anterior se conservan como históricas.

- [PR app #85](https://github.com/leandrito369/ale-milanesas-app/pull/85) **MERGED**, merge `a07fd95bc0e8910c5b81efbe4253e959fc45e23f`: [CargarPedidoService L69](https://github.com/leandrito369/ale-milanesas-app/blob/4dbe38668fc5cbc08d04e10920e3bf165c71be11/src/main/java/ar/edu/unam/alemilanesas/ventas/CargarPedidoService.java#L69) ya filtra cantidadOriginal>0 al reconstruir items. No se mantiene el fix como pendiente; no implica validar UC-07.
- [PR app #86](https://github.com/leandrito369/ale-milanesas-app/pull/86) **MERGED**, merge `4dbe38668fc5cbc08d04e10920e3bf165c71be11`: [ActualizarPrecioVigenteService L84](https://github.com/leandrito369/ale-milanesas-app/blob/4dbe38668fc5cbc08d04e10920e3bf165c71be11/src/main/java/ar/edu/unam/alemilanesas/maestros/ActualizarPrecioVigenteService.java#L84) usa pg_advisory_xact_lock(1919,1), conservando PRODUCTO U y coordinación de IDs precio/auditoría. Corrección **IMPLEMENTADA/INTEGRADA** para ese defecto puntual; no orden global aprobado.
- **PROBADO según informe del Corte 3 reportado el 12/11/2026:** 3/3 deadlocks 40P01 con servicios reales anteriores y seis intercalados correctos con namespace separado; ensayos P parciales de UC-07/UC-41, separados de Nivel R. El informe registró 24 tests experimentales y 24 existentes finales aprobados; no certifica servicios UC-07 terminados. No se reejecuta esa campaña en C1. Informe completo/ZIP fueron artefactos temporales de Codex, **no se afirma que estén versionados**.
- [INC-UC19](https://github.com/leandrito369/ale-milanesas-app/blob/4dbe38668fc5cbc08d04e10920e3bf165c71be11/docs/traceability/INC_UC19_DEADLOCK_UC03_UC19_2026-11-12.md) y prueba permanente `PrecioProductoUc03DeadlockIntegrationTest` son antecedentes de #86. El INC conserva rótulos históricos «DRAFT / no integrado»; el estado real posterior comprobado en GitHub es MERGED. No se corrige ese archivo desde estas CR ni se infiere cierre formal global.
- **RATIFICADO:** A–C por decisión expresa del responsable comunicada en este encargo C1. **PROPUESTO PARA RATIFICACIÓN:** D/E. **PENDIENTE DE PRUEBA/DECISIÓN:** F/G/H y orden global UC-05/06/07/28/41; RT-UC07-04 **ABIERTA**. Issue #28 **OPEN**, despliegue PAUSADO.

Publicación/merge documental, ratificación parcial, autorización integral, implementación, prueba y despliegue son estados distintos. No hay autorización integral de estas CR ni implementación UC-07 por este corte.

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

Alcance físico: snapshot, cotizaciones, evidencia PostgreSQL P2b, bitácora y comandos idempotentes. Las letras A–H de decisiones C1 no se confunden con las antiguas letras de alcances físicos de Etapa B. Todas las nuevas estructuras son subordinadas a UC-07 y requieren autorización expresa. El detalle físico siguiente no está aprobado por el hecho de que su propósito esté ratificado.

## 3. Matriz de decisiones y clasificación

**RATIFICADA EN RD:** D1–D5/RT-UC07-01 en su alcance y D-UC07-02-B, D-UC07-COT, D-UC07-CRC, D-UC07-P2B parcialmente en RD-UC07-002. La RD integral y estas CR no quedan autorizadas por la convergencia. El detalle A–H conserva la clasificación común de CR-C:

### Matriz A–H — estado vigente del Corte C1 (12/11/2026)

**Autoridad:** Victor Leandro Machado, decisión expresa del 12/11/2026 comunicada en el encargo Corte C1. Esta constancia asienta A–C en las CR existentes; no crea una RD ni atribuye autorización integral. **Historial:** A–C eran propuestas preferentes en Etapa B y pasan ahora a RATIFICADAS. D–E siguen sin ratificar; F–H no se cierran por pruebas parciales.

| Decisión | Autoridad / estado vigente | Alcance y pendiente |
|---|---|---|
| A | **RATIFICADA — responsable, 12/11/2026** | Parte A crea oferta+V1 atómicamente; V1=(1,cantidadOfrecida,importeInformado); rollback íntegro. O1 emite >=2 solo parciales estrictas; consulta y replay separados. No autoriza ruta de consulta, endpoint ni implementación |
| B | **RATIFICADA — responsable, 12/11/2026** | UUID servidor para idCotizacion/idEvidencia/idComandoAuxiliar; idEvento BIGINT mediante identidad PostgreSQL. Pertenencia por FK compuesta (oferta,cotización) hacia UNIQUE correspondiente, nunca dos FKs independientes. Generación UUID concreta confiable pendiente, sin imponer UUID.randomUUID() |
| C | **RATIFICADA — responsable, 12/11/2026** | Intento INTEGER NOT NULL positivo, secuencial por oferta, UNIQUE(oferta,intento), bajo lock padre. Rechazo previo/replay no consumen; INVALIDADA persistida conserva número; rollback no confirma intento ni permite reutilizar uno ya persistido. numeroVersion no cuenta evidencias |
| D | **ESPECIFICADA PARA RATIFICACIÓN — NO RATIFICADA** | §10: clave 1–128 ASCII, huella UTF-8 versionada, protocolo, replay/errores y retención candidata. Requiere decisión expresa; C1 no implementa ni prueba esa política |
| E | **ESPECIFICADA PARA RATIFICACIÓN — NO RATIFICADA** | Pipeline P2b y calibración; 1 MiB app/2 MiB físico/4096² solo umbrales experimentales. Parámetros definitivos condicionados a muestra y aprobación |
| F | **PENDIENTE / NO RATIFICADA — Corte C2** | Índice conjunto, integridad cruzada, inmutabilidad, funciones/triggers/privilegios y estado final transaccional. Tipos/FK ratificados por B no ratifican todos los mecanismos |
| G | **PENDIENTE / NO RATIFICADA — Corte C2** | Preflight por destino y política uniforme/determinista de históricos; no elegir rama ni ejecutar consultas de destino en C1 |
| H | **PENDIENTE / NO RATIFICADA — Corte C3; RT-UC07-04 ABIERTA** | Orden global todavía candidato. Corte 3 reprodujo el defecto puntual UC-03/19 y PR #86 integró corrección; faltan escritores y pruebas globales |

**EXCLUIDA:** autorización integral de CR-C/CR-F, implementación UC-07, nuevos CU/firmas G0, modificación de RDs/migraciones/source-lock/RBAC, merge documental y despliegue. Issue #28 permanece OPEN/PAUSADO.

Los fragmentos SQL de §15 son DOCUMENTACIÓN CANDIDATA — NO EJECUTAR: tipos/identidad/FK de B e intento C están ratificados en su alcance; otras restricciones y funciones siguen sujetas a F/G/H y autorización integral. No se crea migración ni se ejecuta DDL en C1.

## 4. Snapshot comercial y procedencia

**RATIFICADA EN RD:** nuevas ofertas conservan precioBaseUnitarioAplicado NUMERIC(18,4) e idPrecio BIGINT, ambos obligatorios; referencia a PRECIO_PRODUCTO e instante comercial coherente. Captura atómica compatible con UC-19.

**F/G PENDIENTES C2:** preflight por destino y política física determinista por aprobar (§14). NOT NULL con guardia que aborte ante datos inesperados es una ruta candidata para tabla vacía certificada; legado exige detener esa ruta y decidir tratamiento específico. La alternativa nullable/guardias de Etapa B queda como antecedente, no una rama automática dependiente de datos dentro de una misma migración. FK fk_oferta_excedente_precio/guardias cruzadas pendientes; no exención general por rol app.

La FK simple solo prueba existencia. Para verificar producto recorrer OFERTA_EXCEDENTE → EXCEDENTE → DETALLE_PEDIDO de origen → PRODUCTO y contrastar PRECIO_PRODUCTO.idProducto. Propuesta preferida para revisión: validación cruzada de inserción mediante función/trigger con lecturas y bloqueos compatibles, más servicio autorizado y permisos restrictivos. Debe comprobar P leído = snapshot, precio no cancelado e intervalo aplicable al instante guardado. No recalcular esa condición sobre UPDATE de respuesta usando el reloj actual: legitimidad inicial y snapshot histórico son hechos distintos.

Alternativa: desnormalizar idProducto y relaciones compuestas hasta precio; implica nuevas columnas/UNIQUE/FKs en varias entidades, mayor alcance que el candidato mínimo. No se adopta ni autoriza. CHECK de fila no puede consultar coherentemente otras tablas; una subconsulta en CHECK no es solución. Los vínculos de origen y pedido receptor que sustentan la comprobación también necesitan protección histórica, no solo los dos campos nuevos.

Evaluar BEFORE UPDATE que rechace cambio de precioBaseUnitarioAplicado/idPrecio y de referencias/fecha/cantidad/importe comercial de oferta ya emitida, más privilegios SQL. Permitir cambios de respuesta que exige ck_oferta_excedente_3, sin congelar toda la fila. Nombre y cuerpo definitivos del trigger pendientes; no usar fk_oferta_excedente_2 ni prefijos MR3 por inercia. Mantenimiento excepcional requeriría rol separado, aprobación y auditoría, no parámetro HTTP o flag de sesión que app pueda falsificar.

**Históricos:** verificar filas y semillas de destinos antes de NOT NULL; no dividir importeInformado para inventar P. Si faltan fuentes inequívocas, detener habilitación de esas ofertas y someter tratamiento a decisión; no afirmar que todas pueden migrarse automáticamente. No se ha comprobado contenido de BD alguna en esta tarea.

## 5. COTIZACION_OFERTA_EXCEDENTE

**RATIFICADA EN RD:** versionado explícito y registro previo a conformidad. **PROPUESTA PARA CR-F:**

| Columna | Tipo candidato / integridad |
|---|---|
| idCotizacion | UUID servidor RATIFICADO B; PK del candidato, mecanismo confiable exacto pendiente, sin imponer UUID.randomUUID() |
| idOfertaExcedente | BIGINT NOT NULL FK oferta |
| numeroVersion | INTEGER NOT NULL, >0; única por oferta |
| cantidadCotizada | NUMERIC(18,3) NOT NULL, >0 y no mayor a cantidadOfrecida por validación cruzada |
| importeCalculado | NUMERIC(18,2) NOT NULL, >0; cálculo servidor |
| codigoCotizacion | CHAR(64) NOT NULL, hex SHA-256 candidato, único |
| fechaHoraGeneracion | TIMESTAMPTZ NOT NULL, servidor |
| idUsuarioVendedor | BIGINT NOT NULL FK USUARIO; identidad autenticada |

Conservar codigoOferta como identidad estable de oferta y codigoCotizacion por versión. No se propone columna de codigoOferta obligatoria en padre; puede derivarse de datos originales protegidos. Los componentes/canonización de hash, zona/precisión, codificación y unicidad definitiva son PENDIENTES DE DECISIÓN con CR-C; hash no prueba comunicación. UUID servidor está RATIFICADO por B en C1; confirmar mecanismo confiable y política ante colisión, sin imponer implementación única ni extensión por supuesto.

Importe parcial: P del snapshot y ajuste congelado en PEDIDO. Subtotal=round(q*P,2,HALF_UP), ajuste=round(subtotal*r/100,2,HALF_UP); descuento resta, recargo suma y SIN_AJUSTE conserva subtotal. Aceptación total usa exactamente importeInformado. No P2, prorrateo del importe redondeado ni UC-15/16. La igualdad entre importe persistido y cálculo es validación cruzada, no garantía de un CHECK positivo.

Proponer UNIQUE(oferta,numeroVersion), UNIQUE(codigoCotizacion), UNIQUE(oferta,idCotizacion) para FK compuesta RATIFICADA B; capturar bajo oferta bloqueada y proteger todas las condiciones emitidas contra UPDATE/DELETE no autorizados. No agregar máquina EMITIDA/ACEPTADA/RECHAZADA/SUPERADA ni índices parciales basados en ella. Usar estado de evidencia para conformidad, sin equipararlo a transferencia.

### Primera versión y O1 — A RATIFICADA el 12/11/2026

**RATIFICADA por el responsable en C1, no autorización de implementación:** Parte A crea oferta y V1 internamente en una sola transacción: numeroVersion=1, cantidadCotizada=cantidadOfrecida, importeCalculado=importeInformado. Fallo en cualquiera → rollback de ambas. Se conserva firma/salida principal G0; no se presume deduplicación de Parte A por cantidad.

O1 POST crea **versiones >=2 para cantidades parciales** (0<q<cantidadOfrecida). Con otra clave, igual cantidad parcial representa nueva emisión; con misma clave/ámbito/payload es replay del efecto anterior (§10), no nueva versión. Solicitud nueva por cantidad total: 409 candidato conforme CR-C, nunca retorno silencioso de V1. Consulta/recuperación de V1 o versión identificada es lectura separada sin nueva fila/comando; ruta/proyección aún pendiente de autorización. La evidencia VERIFICADA puede corresponder a versión anterior no sustituida; MAX(numeroVersion) no indica aceptación vigente. La alternativa de V1 posterior queda EXCLUIDA de la política A ratificada, sin crear tercera operación principal. Pruebas F10/F16/F50.

## 6. EVIDENCIA_ACEPTACION_OFERTA

**RATIFICADA EN RD como orientación:** P2b, O2, estados y sustitución previa. **PROPUESTA PARA CR-F:**

| Columna | Tipo candidato / función |
|---|---|
| idEvidencia | UUID servidor RATIFICADO B; PK coherente con salida CR-C |
| idCotizacion | UUID NOT NULL, versión respaldada |
| idOfertaExcedente | BIGINT NOT NULL, pertenencia compuesta RATIFICADA B de §8 |
| numeroIntentoEvidencia | INTEGER NOT NULL >0, secuencial por oferta; UNIQUE(oferta,intento), no identidad de versión |
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

Cantidad/importe/fecha generación requieren consultar cotización y oferta bajo protocolo transaccional. CHECK(cantidad>0), CHECK(importe>0), CHECK(fechaHoraMensaje<=fechaHoraRegistro) y declaración >=20 no garantizan correspondencia. También comprobar fechaHoraGeneracionCotizacion<=fechaHoraMensaje, exigiendo microsegundos exactos/UTC según §10.2 sin truncar; tolerancias comerciales pendientes con CR-C, sin corregir relojes silenciosamente ni inventar margen monetario.

Evidencia comercial inválida no sustituye a la previa. El candidato guarda únicamente bytes seguros que cumplan integridad mínima: no debilitar NOT NULL/checks para conservar archivos peligrosos o declaraciones inválidas. Si se desea historial de intentos rechazados que no pueden constituir evidencia, definir metadatos seguros/transacción/retención separadamente antes de aprobar; no agregar otra tabla por inferencia aquí.

**C RATIFICADA por el responsable, 12/11/2026:** numeroIntentoEvidencia secuencial positivo **por oferta**, NOT NULL y UNIQUE(idOfertaExcedente,numeroIntentoEvidencia). Asignar siguiente número bajo lock de oferta padre; no MAX+1 fuera del lock. Archivo/solicitud rechazados antes de persistir (MIME, corrupción, tamaño, formato) no crean fila ni consumen número. Evidencia persistida INVALIDADA o posteriormente sustituida conserva su número histórico; nunca reciclarlo ni renumerar. Replays HTTP no incrementan. Rollback no deja intento confirmado ni autoriza reutilizar uno ya persistido. Persistir un intento comercial fallido seguro como CAPTURADA→INVALIDADA exige política explícita aún pendiente; no rebajar las validaciones mínimas ni guardar archivo inseguro. No usar numeroVersion para contar archivos.

## 7. EVENTO_ESTADO_EVIDENCIA_OFERTA

**PROPUESTA PARA CR-F:** bitácora append-only de idEvento (BIGINT mediante identidad PostgreSQL RATIFICADA B, no UUID), idEvidencia UUID FK, estadoAnterior nullable, estadoNuevo, idUsuario BIGINT FK, fechaHoraTransicion servidor, motivo obligatorio y ordenEvento BIGINT positivo por evidencia. UNIQUE(idEvidencia,ordenEvento) permite orden inequívoco aun con timestamps iguales; idEvento o reloj por sí solos no prueban secuencia causal. Numerar bajo lock de evidencia/oferta y conservar eventos junto con estado en una sola transacción. No imponer generador MAX+1 global sin coordinación; identidad PostgreSQL de idEvento está RATIFICADA, sin crearla aquí. V1 respalda el tipo BIGINT de movimientos/auditoría, no un generador universal; la identidad está ratificada por B; su implementación/migración sigue sin autorización integral. El orden causal depende de ordenEvento, no del orden de asignación de secuencia ni de commit.

Estados preservados: CAPTURADA, VERIFICADA, UTILIZADA, INVALIDADA. Transiciones: CAPTURADA→VERIFICADA, CAPTURADA→INVALIDADA, VERIFICADA→UTILIZADA, VERIFICADA→INVALIDADA. UTILIZADA/INVALIDADA terminales. Persistir inicialmente CAPTURADA y luego transición controlada a VERIFICADA. Si ambas ocurren en O2, registrar ambos hechos: NULL→CAPTURADA y CAPTURADA→VERIFICADA, en orden y una transacción; INSERT directo VERIFICADA con un único evento no satisface el candidato. VERIFICADA es validación automática técnica/comercial, no autenticación criptográfica ni aprobación humana ADMIN.

El CHECK de evento puede restringir pares; el estado anterior debe coincidir con último evento/estado real mediante servicio/trigger y locking. Evaluar operación controlada o trigger de transición que registre evento obligatorio y rechace actualización directa sin historial. Resolver actor/motivo confiables y quién puede ejecutar esa operación; un valor de sesión SQL controlable por app no autentica al vendedor. Deshabilitar UPDATE/DELETE de eventos para rol operativo y evaluar triggers defensivos; nombres y funciones no fijados ni código de función ejecutable en esta CR.

Sustitución O2: bloquear oferta y respaldos, validar nueva evidencia completamente; solo entonces anterior VERIFICADA→INVALIDADA por SUPERADA_POR_RECOTIZACION y nueva CAPTURADA→VERIFICADA con eventos. Commit único; cualquier fallo revierte todo y conserva anterior. Emitir una nueva versión sola no invalida respaldo anterior. Parte B posterior consume la VERIFICADA inequívoca y, al transferir con éxito, la pasa a UTILIZADA con evento en la misma transacción que movimiento/stock/oferta. Falta de stock hace rollback, dejando VERIFICADA y sin incremento aceptado/deuda ni movimiento. Rechazo sin evidencia conserva historial e invalida pendientes según contrato que se autorice, sin transferir ni reactivar terminales.

## 8. Integridad referencial y correspondencia entre entidades

| Alternativa evidencia | Garantía y costo |
|---|---|
| Antecedente EXCLUIDO tras ratificación B: solo idCotizacion | Menos redundancia y pertenencia natural. Un índice parcial simple por oferta no puede consultar otra tabla; unicidad global por oferta requeriría otro mecanismo/trigger bloqueado. Lecturas y control de ámbito siempre recorren cotización |
| B RATIFICADA: ambos IDs y FK compuesta | Clave UNIQUE(oferta,idCotizacion) en cotización y FK compuesta desde evidencia. Facilita índices por oferta y control de O2; impide referencias cruzadas. Costo: dato redundante y protección de clave comercial padre |

**RATIFICADA B en C1** en ambas CR y §15, sin autorización integral de migración: UNIQUE(idOfertaExcedente,idCotizacion) en cotización y FK compuesta desde evidencia. Dos FKs simples independientes no impiden evidencia de oferta A apuntando a cotización de B. Todas las referencias propuestas usan RESTRICT y no CASCADE sobre historia, sin cambiar políticas G0 existentes. Considerar bloqueos a borrado de padres por nuevas FKs como impacto a autorizar, no detalle inocuo.

Invariantes cruzadas restantes: producto correcto del precio (§4), cantidad<=ofrecida, cantidad/importe confirmados iguales a versión, versión calculada D2-A, temporalidad entre tablas, oferta/pedido PENDIENTE y rol activo. FK prueba existencia/pertenencia si es compuesta; UNIQUE máximo una fila de clave; CHECK comprueba fila. Validación comercial, autorización, transición y aislamiento requieren servicio/triggers/locking. El cumplimiento debe mantenerse ante escritores SQL no cooperantes bajo permisos del rol operativo, no solo frente al controlador HTTP.

## 9. Restricciones y generadores — B/C ratificadas; F pendiente C2

Un **único índice único parcial conjunto** `uq_evidencia_utilizable_por_oferta` por idOfertaExcedente, WHERE estadoEvidencia IN ('VERIFICADA','UTILIZADA'), reemplaza los dos índices separados del candidato anterior. Impide físicamente dos VERIFICADA, dos UTILIZADA **y una de cada estado para la misma oferta**. No impide múltiples INVALIDADA/CAPTURADA ni sustituye validación de oferta PENDIENTE.

O2 valida la sustituta segura; dentro de la misma transacción cambia primero la anterior VERIFICADA→INVALIDADA y luego inserta/promueve la nueva a VERIFICADA, con eventos. Cualquier error revierte ambas. Parte B cambia la misma fila VERIFICADA→UTILIZADA manteniendo su entrada en el índice. Con una UTILIZADA terminal existente, intentar verificar otra fila falla aunque un escritor omita la validación de servicio. Además se protege estado comercial cruzado (§13).

Intentos: UNIQUE(oferta,numeroIntentoEvidencia), NOT NULL y >0; numeración bajo lock padre. No UNIQUE global del hash documental: mismo archivo no prueba misma aceptación, y la política de INVALIDADA/duplicados requiere autorización.

**B RATIFICADA el 12/11/2026:** UUID generado por servidor para idCotizacion, idEvidencia e idComandoAuxiliar, mismo tipo en contrato/PK/FK. BIGINT mediante identidad PostgreSQL para idEvento; INTEGER positivo para numeroVersion/numeroIntentoEvidencia y BIGINT positivo para ordenEvento. Generación UUID exacta, manejo de colisión y límites requieren aprobación, sin presuponer extensión instalada. Versiones/intentos/ordenEvento se numeran bajo bloqueo padre y UNIQUE defensivo. No confundir la posible falta de continuidad de una secuencia con pérdida de eventos: ordenEvento prueba causalidad.

Para BIGINT existentes de oferta/excedente/movimiento, coordinar **todos** los escritores UC-05/06/07/41 y generadores/advisory namespaces (§12); UUID en tablas nuevas no soluciona esos generadores MAX+1. La canonización de codigoCotizacion permanece pendiente; UNIQUE detecta duplicación, no prueba comunicación.

## 10. Idempotencia — D ESPECIFICADA PARA RATIFICACIÓN, NO RATIFICADA

### 10.1. Entidad, alcance y clave

Candidato único compartido CR-C/CR-F: COMANDO_AUXILIAR_UC07. Nombres físicos: idComandoAuxiliar, operacion, idOfertaExcedente, idUsuarioVendedor, claveIdempotencia, huellaSolicitud, idCotizacion, idEvidencia, estadoHttpOriginal, **respuestaOriginal JSONB NOT NULL**, fechaHoraRegistro. No se introduce reciboOriginalJson. Los UUID son de generación servidor conforme B; actor viene del principal autenticado, no de HTTP.

UNIQUE(operacion,idOfertaExcedente,idUsuarioVendedor,claveIdempotencia). Huella fuera de la UNIQUE: cambiar payload debe entrar en conflicto, no crear otra identidad. FK restrictiva a oferta y FKs compuestas de resultado/oferta; solo un efecto (cotización o evidencia) según operación. Efecto y recibo se confirman juntos. respuestaOriginal guarda exclusivamente la salida mínima autorizada y su formato; nunca bytes documentales, contacto, declaración libre, credenciales ni tokens. Estado HTTP original separado en estadoHttpOriginal.

**Candidato de clave obligatoria en ambos POST:** 1–128 caracteres ASCII visibles U+0021–U+007E, sin espacios/control ni Unicode fuera de ese alfabeto. Conservar exactamente la clave recibida: sin trim, normalización, cambio de caja, truncamiento ni colapso de duplicados de cabecera. HTTP valida antes del negocio. CR-F §15.5 cambia el anterior TEXT por VARCHAR(128) con CHECK de longitud/alfabeto; la operación SQL controlada también valida antes de cualquier cast que pudiera truncar. Entrada ausente, duplicada o inválida: 400 IDEMPOTENCY_KEY_INVALIDA, sin efectos. No registrar clave completa en logs.

### 10.2. Canonización inequívoca UC07-IDEM/1

huellaSolicitud = SHA-256 hexadecimal minúsculo de bytes canónicos UTF-8. Misma función/especificación para adaptador, servicio y pruebas; no hashear el JSON HTTP ni concatenar con "|" sin escape.

Representación candidata exacta:

1. Cabecera ASCII `UC07-IDEM/1\n` (LF único).
2. Campos en el orden fijo de las listas O1/O2 de abajo. Por campo: longitud en bytes UTF-8 del nombre, decimal ASCII sin ceros iniciales, ":" y nombre; después `N;` para NULL o `V<longitudValor>:<valor>;` para valor no nulo. Longitud del valor cuenta bytes, no caracteres; NULL y cadena vacía son distintos. Prefijos de longitud permiten ":"/"|" y saltos en el valor sin ambigüedad.
3. Valores de campos obligatorios nunca NULL; el marcador NULL queda definido para un opcional admitido en una futura versión del contrato. No añadir opcionales unilateralmente al hash. Cambio de esquema requiere nuevo identificador de canonización y convivencia/lectura de recibos antiguos definida antes de habilitarlo.

Identificadores Long positivos dentro de BIGINT se representan en decimal sin signo "+" ni ceros iniciales; UUID en formato estándar de 36 caracteres con hex minúsculo. No se impone algoritmo UUID específico. Literales de operación: O1=`EMITIR_COTIZACION`, O2=`REGISTRAR_EVIDENCIA`, alineados con §15.5 de CR-F.

**Decimales exactos:** validar positividad, finitud del dato decimal y representabilidad NUMERIC(18,3) para cantidades / NUMERIC(18,2) para importes. Usar BigDecimal, nunca double. Admitir ceros decimales superfluos sin pérdida; después de validar, setScale(3,UNNECESSARY) para cantidad y setScale(2,UNNECESSARY) para importe, toPlainString y punto decimal. Ejemplos: 1, 1.0 y 1.0000 → 1.000; 10 y 10.00 → 10.00. 1.0001 o importe 10.001 se rechazan con 400 ESCALA_DECIMAL_INVALIDA; no se redondean para que compartan hash. Cero, negativo y overflow: 400 SOLICITUD_INVALIDA. El HALF_UP de D2-A calcula importes comerciales; **no** normaliza con pérdida entradas antes del hash.

**Instantes declarados:** parsear OffsetDateTime válido, convertir al mismo instante UTC y representar fecha/hora con seis dígitos de fracción y Z. Exigir nanos divisibles por 1000; precisión submicrosegundo que cambie el instante se rechaza (400 SOLICITUD_INVALIDA), sin truncar ni redondear. Offsets distintos del mismo instante y ceros fraccionales extra exactos producen el mismo valor canónico. Persistencia TIMESTAMPTZ conserva el instante, no promete conservar el offset textual original. Validación temporal generación<=mensaje<=registro sigue siendo comercial, adicional al hash.

**Texto:** UTF-8 estricto; rechazar Unicode inválido/surrogates sin pareja. No aplicar NFC/NFKC, case-fold, trim, colapso de espacios ni conversión CRLF/LF a canal/contacto/declaración: conservar secuencia Unicode y espacios admitidos por contrato. Dos textos visualmente iguales pero con codificación Unicode distinta siguen siendo solicitudes distintas; se prioriza no fusionar declaraciones diferentes. Los catálogos se validan con sus literales autorizados, sin “corregir” entradas. La regla de 20 caracteres no blancos valida declaración sin modificarla.

| Orden O1 | Valor semántico |
|---|---|
| operacion | EMITIR_COTIZACION |
| idOfertaExcedente | ID validado de ruta/ámbito |
| cantidadCotizada | Escala fija 3 exacta |

| Orden O2 | Valor semántico |
|---|---|
| operacion | REGISTRAR_EVIDENCIA |
| idOfertaExcedente | Derivado de cotización y verificado, no autoridad HTTP |
| idCotizacion | UUID validado |
| cantidadConfirmada | Escala fija 3 exacta |
| importeConfirmado | Escala fija 2 exacta |
| canalComunicacion | Literal contractual validado |
| referenciaContacto | Texto admitido, sin minimización silenciosa |
| fechaHoraMensaje | UTC/microsegundos exactos |
| tipoMimeContenido | Tipo detectado por servidor, literal image/png o image/jpeg |
| huellaContenido | SHA-256 servidor de bytes originales, hex minúsculo |
| declaracionIdentidadVendedor | Texto exacto admitido |

**Transporte no semántico:** boundary/orden de partes, cabeceras HTTP, Content-Length, token/sesión y nombreArchivoOriginal opcional no integran la huella. tipoMimeDeclarado es la declaración de Content-Type de la parte, se conserva separadamente y debe superar E, pero no es tipoMimeContenido ni se usa como autoridad/hash comercial. Un cambio de nombre opcional o variación admitida de la cabecera declarada no emite otro intento bajo la misma clave; replay mantiene los metadatos originales del primer efecto. No se agrega nombreArchivoOriginal a la firma O2 ni se exige por inferencia. Identidad del vendedor y clave completa están en el alcance UNIQUE; no se confunden con campos de payload controlados por cliente.

### 10.3. Protocolo transaccional candidato

1. Autenticar sesión y autorizar VENDEDOR/objeto vigentes, sin herencia automática ADMIN. Para O2, aplicar E antes de abrir escritura; derivar y verificar ámbito y canonizar solicitud válida.
2. Identificar clave completa operación/oferta/vendedor/clave, sin filtrar existencia protegida.
3. Serializar por clave/comando y adquirir el subgrafo necesario según el candidato de CR-F §12.3, revalidando permisos tras esperar. No sustituir todo esto por un lock de oferta: debe resolverse su orden con advisory/raíces en H.
4. Releer el registro confirmado después de esperar. Si misma clave y huella: replay, sin efectos; si huella distinta: 409 IDEMPOTENCY_KEY_PAYLOAD_MISMATCH.
5. Sin registro: ejecutar negocio, generar el resultado y persistir efecto y respuestaOriginal/estadoHttpOriginal dentro de **la misma transacción**. No confirmar reserva PENDIENTE ni comando huérfano.
6. Fallo: rollback íntegro. UNIQUE es defensa adicional, no reemplazo del protocolo ni de la relectura. Tras respuesta perdida/commit incierto, reintentar con misma clave; nunca inventar otra para “solucionar” el timeout.

### 10.4. Replay y respuesta

Sobre público candidato único: `replay`, `resultadoHistorico`, `estadoActual`; no se introduce replayIdempotente. HTTP actual 200 OK candidato; resultadoHistorico conserva respuestaOriginal y estadoHttpOriginal como hechos originales inmutables. estadoActual se obtiene por lectura autorizada y consistente: respuesta vigente de oferta y estado de evidencia si corresponde, con instante de observación definido en esquema final. No reescribir el recibo al cambiar el recurso.

UTILIZADA o INVALIDADA se informa como tal, nunca consumible. Replay no crea versiones/intentos/evidencias, transferencias ni efectos financieros. Parte B vuelve a validar bajo sus locks; estadoActual no reserva disponibilidad. Cada replay reautentica y reautoriza antes de devolver recibo/existencia; sesión/rol/ámbito perdidos impiden devolución conforme §9, aunque el efecto histórico haya sido legítimo. El contrato final del sobre debe aprobarse junto con CR-F.

### 10.5. Errores candidatos únicos para CR-C y CR-F

| Situación | HTTP candidato | Código / comportamiento |
|---|---|---|
| Clave ausente, duplicada o inválida | 400 | IDEMPOTENCY_KEY_INVALIDA |
| Escala decimal no exacta | 400 | ESCALA_DECIMAL_INVALIDA |
| Rango/instante/estructura inválidos | 400 | SOLICITUD_INVALIDA |
| Sesión ausente o inválida | 401 | SESION_INVALIDA, convención vigente Bearer |
| Rol o ámbito no autorizado | 403/404 | OPERACION_PROHIBIDA para rol; política uniforme de objeto no visible sin filtrar existencia |
| Misma clave, distinto payload | 409 | IDEMPOTENCY_KEY_PAYLOAD_MISMATCH |
| Espera finaliza y payload idéntico | 200 | Replay, no nuevo efecto |
| Espera transaccional excedida / aborto transitorio de infraestructura | **503 preferente** | OPERACION_TEMPORALMENTE_NO_DISPONIBLE, candidato; rollback y reintento con misma clave. Retry-After solo si puede justificarse una estimación operativa aprobada; no derivarlo automáticamente del lock_timeout ni fijar plazo arbitrario |

El 409 CLAVE_IDEMPOTENCIA_CONFLICTIVA anterior se **reemplaza** por IDEMPOTENCY_KEY_PAYLOAD_MISMATCH; no quedan dos literales activos para el mismo caso. CONFLICTO_CONCURRENCIA queda reservado como candidato 409 para conflicto **comercial** de estado/versión; no representa lock_timeout/deadlock/indisponibilidad. No se adopta IDEMPOTENCY_KEY_TIMEOUT como sinónimo 409 de infraestructura. No exponer SQL, SQLSTATE interno, claves, bytes, contacto ni declaración. Reintento de aborto transitorio debe ser acotado y de transacción completa; presupuesto, estimación Retry-After y esquema final de error requieren aprobación operativa. Nuevos códigos son propuestos, no implementados.

### 10.6. Retención, privacidad y duplicados

**MVP candidato:** sin TTL corto ni purga automática en línea. Conservar clave, huella, vínculo, resultado y recibo mientras la oferta esté bajo conservación operativa/auditable, con FK restrictiva. No se declara conservación eterna legalmente obligatoria. Riesgo residual explícito: horizonte calendario aún no definitivo, crecimiento de datos y conflicto con minimización/privacidad.

Eliminación/anonimización excepcional solo mediante procedimiento autorizado y auditado, compatible con obligaciones de conservación; antes de cualquier purga definir una protección (por ejemplo tombstone) que impida reutilizar claves y reejecutar efectos. No tratar registro eliminado como nueva intención por defecto. Acceso a recibos/trazas por rol y objeto; logs sin bytes, contacto, declaración libre, Bearer ni clave completa.

| Caso documental | Política candidata para ratificación |
|---|---|
| Misma clave/huella | Replay, sin número de intento nuevo |
| Clave distinta y mismo archivo de la misma oferta/cotización | Preferencia MVP: 409 EVIDENCIA_DUPLICADA, también si el intento previo está INVALIDADA; no reactivarlo ni consumirlo |
| Nuevo archivo / nuevo intento | Nueva identidad documental solo tras validar conformidad y reglas comerciales; hash distinto no prueba otra aceptación |
| Otra cotización/oferta | No reciclar automáticamente la conformidad ni usar hash como unicidad global; verificar relación/contacto/cantidad/importe y obtener conformidad de esa versión |
| INVALIDADA persistida | Conserva definitivamente numeroIntentoEvidencia conforme C; solo un intento nuevo permitido por política puede generar otra fila |

Numeración C está ratificada; esta política de duplicados/retención pertenece a D y **no** está ratificada. Pendientes precisos: ratificación de D, algoritmo/namespace/orden físico con H, horizonte calendario y procedimiento excepcional, presupuesto de reintentos/Retry-After, esquema público final y pruebas reproducibles de canonización/serialización. No se reabren los tipos ni la semántica A–C ya ratificados.

## 11. Evidencia documental P2b — especificación candidata E

### E — P2b ESPECIFICADA PARA RATIFICACIÓN; límites definitivos condicionados

**Estado C1:** propuesta completa de seguridad/calibración, NO RATIFICADA. El contenido original en PostgreSQL/P2b tiene fundamento previo; este pipeline y sus parámetros requieren ratificación. No se implementan endpoints ni se afirma ejecutar pruebas de imágenes en C1.

#### E1. Formatos y campos

Lista blanca candidata MVP: image/png, image/jpeg. WebP/PDF diferidos; TXT, ZIP, DOCX y ejecutables fuera del alcance de evidencia documental MVP. tipoMimeDeclarado conserva el Content-Type de transporte; tipoMimeContenido es el formato detectado/validado por servidor. Extensión y nombreArchivoOriginal opcional no deciden admisión ni agregan parámetros obligatorios a O2.

En la firma conceptual O2, tipoMimeContenido representa el valor que el adaptador obtuvo de la validación servidor, no un campo comercial autorizado desde HTTP. La cabecera declarada se conserva como metadato separado. No aceptar un MIME detectado/hash impuestos por el cliente.

#### E2. Pipeline seguro antes de escritura

1. Limitar request, multipart, número de partes y bytes desde recepción, incluyendo transferencia sin Content-Length; no cargar entrada ilimitada ni confiar solo en cabeceras.
2. Autenticar y autorizar antes de revelar recursos protegidos y antes de gastar trabajo de decodificación sobre objetos no accesibles.
3. Medir bytes, detectar formato por firma: PNG `89 50 4E 47 0D 0A 1A 0A`; JPEG prefijo `FF D8 FF`, que requiere decodificación real complementaria.
4. Exigir tipo detectado en lista blanca y coherencia con MIME declarado admitido; no confiar en extensión. Discordancia, corrupción o formato no permitido → 400 CONTENIDO_INVALIDO.
5. Seleccionar lector controlado PNG/JPEG; sondear dimensiones antes de asignar raster, limitar píxeles y metadatos/buffers, decodificar realmente bajo presupuesto de memoria/tiempo y concurrencia.
6. Rechazar imágenes truncadas, corruptas, no decodificables/ilegibles o fuera de presupuesto. Gestionar errores de ImageIO sin eco del contenido ni persistencia parcial; decodificación no prueba por sí sola legibilidad comercial de una captura.
7. Calcular SHA-256 servidor sobre bytes originales admitidos; ni huella ni imagen acreditan criptográficamente remitente/WhatsApp.
8. Solo tras completar prevalidación, abrir transacción de escritura y persistir bytes originales sin recodificación silenciosa.
9. Después de esperar locks, revalidar sesión/permiso, oferta, pedido, cotización, datos comerciales y estados; efectuar O2/recibo atómicos. Rechazo previo no consume intento conforme C.
10. Recuperación posterior con autorización por objeto y BC07, comparación SHA-256, respuesta mínima y Cache-Control: no-store. Ningún GET/descarga se habilita por inferencia.

**Presupuesto experimental, no garantía implícita de ImageIO:** 4096×4096 RGBA son 67,108,864 bytes (~64 MiB) solo de raster; no incluye originales, buffers, metadatos, objetos, memoria nativa ni decodificador. Candidato de evaluación: un trabajador a la vez, cola acotada y rechazo controlado por saturación; heap por trabajador 128 MiB, presupuesto de proceso 256 MiB y deadline por archivo 2 s, todos sujetos a medir y ratificar. ImageIO dentro de un hilo HTTP no impone esos límites automáticamente; Future.cancel/interrupción no garantizan detener un lector. Preferencia a evaluar: subproceso local controlado con límites del SO/watchdog y descarte al excederlos, sin abrir transacción DB hasta resultado seguro. No se autoriza nueva infraestructura ni se promete límite total de CPU/RSS por fijar -Xmx. El mecanismo de aislamiento/lector y los presupuestos efectivos son pendientes de revisión de seguridad/calibración.

**Privacidad del original:** ignorar EXIF/tEXt durante lectura no los elimina de los bytes conservados. Persistir original también conserva metadatos embebidos y potenciales datos personales; restringir lectura, descargas, backups y retención. No afirmar que se sanitizó/redujo el archivo si se conserva íntegro. No guardar capturas personales en repositorio/CI/logs.

#### E3. Umbrales de laboratorio y coherencia de capas

| Parámetro | Candidato experimental, NO límite definitivo |
|---|---|
| Propiedad aplicativa | ale.uc07.evidencia.max-bytes |
| Máximo aplicativo inicial | 1048576 bytes (1 MiB) |
| Techo físico de evaluación | 2097152 bytes (2 MiB) |
| Dimensiones máximas candidatas | Ancho<=4096 y alto<=4096; píxeles<=16,777,216 |
| Presupuestos de evaluación | Los de E2, sujetos a medición y aprobación |

Configurar coherentemente request/multipart (incluyendo overhead acotado), app y eventual techo DB. La app rechaza antes si excede su máximo; cambiar configuración por encima del techo físico exige revisión previa, no esperar un error SQL expuesto. Valores no crean flags/endpoints ni alteran configuración real.

V1 no contiene evidencia. El DDL candidato CR-F §15.3 sí contiene contenidoOriginal BYTEA NOT NULL y ck_evidencia_no_vacia: octet_length(contenidoOriginal)>0. Conservar esa restricción; **no existe allí un CHECK de 2 MiB ya aprobado**. Un eventual ejemplo de evaluación sería CHECK(octet_length(contenidoOriginal) BETWEEN 1 AND 2097152), **NO EJECUTAR / VALOR EXPERIMENTAL**; no sustituye automáticamente ck_evidencia_no_vacia ni se incorpora como límite definitivo en §15.3. No usar :techo_calibrado como marcador literal de una futura migración Flyway.

#### E4. Calibración obligatoria, NO EJECUTADA en C1

Preparar 20–30 archivos sintéticos o anonimizados representativos de capturas Android, iOS y WhatsApp Web, con procedencia de plataforma/formato y sin datos personales. Dataset de evaluación con acceso restringido; no incorporar capturas reales identificables a Git/CI/logs. Añadir deliberadamente muestras grandes y malformadas; distinguir estas muestras adversariales del conjunto representativo.

Registrar tamaño mínimo/máximo, P50/mediana, P95 (método de orden elegido explícito; candidato rango más cercano ceil(0.95*n)), outliers grandes, dimensiones/píxeles, formato real, tiempo de decodificación, heap/RSS/picos bajo prueba controlada y fallos/incompatibilidades de lector. Para n par, especificar cómo se calcula mediana. Registrar versión de lector/JDK, equipo, concurrencia, límites efectivos y repetición para reproducir mediciones.

No usar P99 de 20–30 archivos como conclusión estadística. Proponer margen razonado usando legibilidad, peores casos, memoria/tiempo, overhead multipart y capacidad PostgreSQL/backup; ensayar fronteras y malformados antes de congelar parámetros. Si la muestra no respalda 1 MiB/2 MiB/4096² o los presupuestos, ajustar propuesta y someterla nuevamente a ratificación, sin cambiar silenciosamente límites físicos.

#### E5. HTTP, acceso y pendientes

Preferencia única compartida: 400 CONTENIDO_INVALIDO para contenido/MIME/decodificación inválidos y 413 EVIDENCIA_DEMASIADO_GRANDE para bytes sobre límite efectivo. Escalas siguen 400 ESCALA_DECIMAL_INVALIDA de D. No adoptar 422 por defecto ni crear una segunda matriz contradictoria; cualquier alternativa requerirá justificación y aprobación del catálogo final. Saturación/fallo transitorio del validador puede mapearse al 503 candidato de D; no disfrazar archivo inválido como indisponibilidad.

Errores/logs sin eco de bytes, contacto, declaración, tokens ni clave de idempotencia completa. Lectura/descarga requiere autorización expresa por rol/ámbito y BC07, no-store e integridad; el permiso general de VENDEDOR no abre un GET público. Pendientes: ratificación de E/pipeline, calibración, lectores/aislamiento y presupuestos, límites finales, retención/privacidad y contrato de recuperación; no están implementados ni probados por completar esta especificación.

## 12. Matriz Global de Adquisición de Locks — RT-UC07-04 ABIERTA

**H PENDIENTE C3, ORDEN GLOBAL NO RATIFICADO.** Matriz originada en auditoría histórica Etapa B al SHA app d5f7607; C1 revalida las correcciones #85/#86 sobre main `4dbe38668fc5cbc08d04e10920e3bf165c71be11`, con contratos de gobierno `cdd57ed194268f1f5ab29aa0f55781ddddebdfb5`. El Corte 3 previo ejecutó parcialmente R/P; no prueba ausencia global de deadlocks. No ejecutar DDL ni experimentos en C1.

### 12.1. Convenciones y fuentes reproducibles

U=`FOR UPDATE`, N=`FOR NO KEY UPDATE`, S=`FOR SHARE`, K=`FOR KEY SHARE`; A1(k)=`pg_advisory_xact_lock(bigint)`, A2(a,b)=variante de dos enteros. A1 y A2 son espacios distintos; claves A1 idénticas de dominios distintos sí colisionan. Los locks transaccionales se conservan hasta commit/rollback. SELECT ordinario no aporta lock de fila excluyente; la espera también puede ser por transactionid/índice/exclusión GiST y locks de relación. Un UPDATE no clave suele tomar N, o U si modifica columnas de clave reconocidas por PostgreSQL; no atribuir N a todo UPDATE sin inspeccionar índices/plan. Las lecturas explícitas U de los servicios ya son más fuertes.

Fuentes exactas en app (rutas relativas a `src/main/java/ar/edu/unam/alemilanesas/`, auditadas originalmente en d5f7607; líneas de corrección C1 enlazadas en adenda): `ventas/CargarPedidoService.java` L42–64,80–103; `finanzas/AplicarAjusteComercialService.java` L40–63 y `EvaluadorCategoriaComercialInterno.java` L43–56; `maestros/ActualizarPrecioVigenteService.java` L62–89,108–155; `produccioninventario/RegistrarPreparacionService.java` L48–72,92–137,150–180,210–242. Para las FKs/triggers: V1 L917–921,1041–1043,1664–1686 y V3 (partidas/funciones). Enlaces estables: [UC-03](https://github.com/leandrito369/ale-milanesas-app/blob/d5f7607afb430a251cbf5cc9190a879a7d41416b/src/main/java/ar/edu/unam/alemilanesas/ventas/CargarPedidoService.java#L42), [UC-19](https://github.com/leandrito369/ale-milanesas-app/blob/d5f7607afb430a251cbf5cc9190a879a7d41416b/src/main/java/ar/edu/unam/alemilanesas/maestros/ActualizarPrecioVigenteService.java#L62), [UC-28](https://github.com/leandrito369/ale-milanesas-app/blob/d5f7607afb430a251cbf5cc9190a879a7d41416b/src/main/java/ar/edu/unam/alemilanesas/produccioninventario/RegistrarPreparacionService.java#L48).

Gobierno: contratos REV04B §2 UC-05 L57–109, §3 UC-06 L111–159, §5 UC-07 A L199–229, §6 B L233–275, §7 UC-41 L279–313. [PR #44](https://github.com/leandrito369/ale-milanesas/pull/44) OPEN/DRAFT, HEAD `e5e82f843f8a579e3201a332c645f62680d56832`, archivo `RD_I302_001_PROPUESTA_ENTREGA_EFECTIVO_TRANSITO_IDEMPOTENCIA_2026-11-09.md`, §§8.3–8.4 L266–304: secuencia funcional y recursos, **no orden SQL aprobado**. No hay implementación funcional de UC-05/06/07/41 en el main inspeccionado; no asignarles locks actuales inventados.

### 12.2. Matriz real y contractual (orden cronológico)

| Operación / evidencia | Orden observado dentro de transacción | FK, triggers, escrituras y límites |
|---|---|---|
| UC-03 implementada | Autorizar/validar → A2(3003,0) → A1(idCliente) → reautorizar → buscar replay (si existe, retorna) → CLIENTE U → PRODUCTO S para todos los IDs ascendentes → clock_timestamp → PRECIO_PRODUCTO S por ítem en orden de entrada → CLIENTE U de nuevo en UC-16/15 → política S y regla de ajuste S → MAX+1 PEDIDO → INSERT PEDIDO/detalles | UC-15 actualiza categoría CLIENTE ya bloqueada. FKs toman K en padres referidos (cliente, usuario, política, pedido, producto/unidad según escritura); triggers V1 toman CLIENTE S al insertar pedido y PRODUCTO S al seleccionar producto de detalle. No U sobre un pedido antiguo en camino de alta. Replay UC-03 ya corregido por #85 (cantidadOriginal>0), integrado; sin cambio de servicio en C1 |
| UC-19 implementada | Autorizar/validar → PRODUCTO U → reautorizar → reloj PostgreSQL/control no retroactivo → A2(1919,1) integrado por #86 → períodos PRECIO_PRODUCTO no cancelados U ordenados (vigenteDesde,idPrecio) → MAX+1 precio/auditoría → UPDATE vigenteHasta/INSERT nuevo precio/auditoría → commit | Reloj se toma **antes** de esperar A2(1919,1); antes de #86 era A1(1919001). FKs de precio/auditoría toman K de producto/usuario/precio. GiST exclusión [desde,hasta) puede esperar por transacciones concurrentes. No PEDIDO/EXCEDENTE explícitos |
| UC-28 implementada | Autorizar/validar → PEDIDO U → DETALLE_PEDIDO U (pedido/producto) → A2(808,0) → reautorizar → sumas ordinarias → reloj → PRODUCTO S → VERSION_RECETA/RECETA S OF v,r → DETALLE_VERSION_RECETA S por idInsumo asc → por cada ingrediente: A1(idInsumo), INSUMO U, PARTIDA_INSUMO U orden apertura/vencimiento/registro/id → reautorizar → MAX+1 preparación/movimientos y escrituras | El bucle conserva locks de ingredientes anteriores. COSTO_INSUMO_HISTORICO se consulta sin lock explícito. FKs de preparación/consumo toman K (detalle, versión, insumo, preparación/usuario); V3 actualiza partidas ya bloqueadas. No bloquear todo PRODUCTO antes de PEDIDO en un nuevo consumidor que luego espera el mismo pedido |
| UC-05 pendiente, contrato + PR #44 | **Orden SQL/advisory no definido.** Recursos: asignación vigente, PEDIDO/detalles, CLIENTE/UC-15, stock REVENTA, EXCEDENTE nuevo y movimientos; ENTREGA antes de origen del cargo por FK. PR44 solo propone coordinación de IDs contables con A1(2929001) de UC-29 | No atribuir 2929001 a ENTREGA/EXCEDENTE. Requiere integrar UC-43 A1(9172001)/A2(60505,7), inventario A2(808,0)/A1(elemento), generadores y posibles locks tardíos de CLIENTE. La secuencia funcional de PR44 no prueba modo/orden de filas |
| UC-06 pendiente, contrato §3 | **Orden SQL/advisory no definido.** Revalidar PEDIDO PENDIENTE/asignación contextual; preservar preparado/reasignado como EXCEDENTE, cancelar; eventual extensión UC-26 según contrato | Recursos compartidos PEDIDO/detalles, EXCEDENTE/movimientos y generadores. Modo/orden exactos y coordinación con asignación/reembolso pendientes de DS; sin falsa implementación |
| UC-41 pendiente, contrato §7 | **Orden SQL/advisory no definido.** Disminución atómica de EXCEDENTE y movimiento DESCARTE; costo histórico preservado | Candidato futuro U sobre excedente, generador común y K por FK de movimiento; son propuestas, no hechos de servicio existente |

FK no implica siempre lock nuevo observable si la transacción ya protege padre o PostgreSQL evita comprobación innecesaria; K describe la protección referencial requerida al insertar/cambiar FK. K **conflicta con U**, aunque puede convivir con N: no omitirla del grafo. Corte 3 observó interacciones K/U/N en prototipos; falta registrar el conjunto efectivo de triggers/FKs definitivos en C3, sin deducirlo solo de nombres de tablas.

### 12.3. Matriz UC-07 propuesta y protocolo compatible a experimentar

**H CANDIDATO PENDIENTE C3, NO RATIFICADO:** catálogo sometido parcialmente a pruebas, aún no orden global autorizado. Lectura preliminar sin locks para descubrir raíces no autoriza efectos: después bloquear y **revalidar las referencias**; si cambiaron/añadieron recursos, rollback completo y replanificar sin adquirir raíces tardías fuera del orden. Serialización auxiliar por clave en espacio A2 dedicado, separado de A1 de IDs crudos; componentes/namespace exactos por aprobar. Colisiones de hash del lock solo serializan de más; igualdad real siempre por clave completa/UNIQUE.

Para nuevas operaciones compartir un catálogo de recursos y un orden total: coordinación de comando/generadores necesaria **antes de filas** → CLIENTE necesarios por ID → PEDIDO origen/receptor por ID → DETALLE_PEDIDO necesarios por PK → EXCEDENTE por ID → PRODUCTO por ID → PRECIO_PRODUCTO por (producto,desde,id) si se captura → OFERTA por ID → COTIZACION por ID → EVIDENCIA por ID → eventos/recibo. UUID no ordena tiempo comercial; ordenar lexicográficamente solo para adquisición determinista. No tomar recursos irrelevantes, ni consultar precio actual en auxiliares/B. Mantenimiento y triggers deben respetar el mismo catálogo. D5-B EXCEDENTE→OFERTA→PEDIDO era hipótesis no ratificada; no se altera la RD.

| Operación UC-07 propuesta | Secuencia exacta del candidato, omitiendo recursos no usados | Modos / efecto y FK |
|---|---|---|
| Parte A | Coordinación aprobada del generador BIGINT oferta → CLIENTE receptor → PEDIDO origen/receptor ordenados → detalle origen → EXCEDENTE → PRODUCTO → todos los períodos no cancelados de ese producto S ordenados → reloj posterior a esperas → revalidar y elegir exactamente un precio visible a ese instante → insertar oferta y V1 → commit | CLIENTE U conservador, PEDIDO U, detalle origen S (o U si se modifica), EXCEDENTE U para estabilizar comprobación sin descontar stock, PRODUCTO S, precio S. Usar lectura READ COMMITTED posterior al lock de producto para períodos visibles, lock S por (vigenteDesde,idPrecio) y después reloj único t; si selección/lock de precio espera, revalidar t/intervalo antes de insertar. K FKs excedente/pedido/usuario/precio y oferta padre V1; raíz detalle ya protegida para evitar K tardío conflictivo |
| O1 nueva versión | Lock de clave comando → CLIENTE/PEDIDO receptor necesarios → OFERTA U → cotizaciones previas S/lectura bajo padre → siguiente versión → insertar cotización >=2 y recibo → commit | CLIENTE U/PEDIDO U conservadores para coherencia de ámbito/estado; no PRODUCTO/PRECIO ni stock. Oferta inmoviliza cantidad/snapshot. K oferta/usuario y efecto del recibo; UNIQUE versión y clave defensivos |
| O1 consulta / replay | Autenticar/autorizar ámbito → consulta consistente de versión o lock de clave si replay → leer recibo y situación actual por snapshot coherente → respuesta | Consulta no crea versión/recibo; replay no consume. Para autorización que cambie durante espera, revalidar antes de devolver. No inferir «vigente» por versión mayor ni bloquear producto actual |
| O2 | Prevalidar imagen segura fuera de escritura → lock clave → CLIENTE/PEDIDO necesarios → OFERTA U → COTIZACION S → EVIDENCIAS U ordenadas → asignar intento por oferta → validar → anterior INVALIDADA → nueva CAPTURADA/VERIFICADA + eventos → recibo → commit | Cliente/pedido U conservadores, cotización S, evidencia U; comprobación comercial y pertenencia física. K cotización compuesta/usuario/evidencia para eventos/recibo; índice conjunto exige invalidar anterior antes de verificar nueva. No EXCEDENTE/PRODUCTO/PRECIO ni reserva stock |
| Parte B acepta | Coordinación generadores movimiento/detalle aprobada → CLIENTE necesarios → PEDIDO origen/receptor ordenados → detalles necesarios por PK → EXCEDENTE U → PRODUCTO S si nueva línea técnica → OFERTA U → COTIZACION S → EVIDENCIA U → revalidar todo → transferir, actualizar oferta/detalle y misma evidencia UTILIZADA con evento → commit | CLIENTE/PEDIDO U conservadores, detalles U, EXCEDENTE U; producto S solo si nueva línea técnica dispara selección V1, adquirido **antes** de OFERTA según catálogo, nunca después de evidencia. K detalle origen/producto/unidad, oferta/excedente en movimiento, usuario y efecto. No precio actual ni UC-15/16; stock insuficiente revierte Parte B y conserva VERIFICADA |
| Parte B rechaza | CLIENTE/PEDIDO receptor necesarios → OFERTA U → EVIDENCIAS U → rechazo y invalidación trazable de CAPTURADA/VERIFICADA con eventos → commit | No transferencia ni precio actual; no nueva evidencia requerida. Si política histórica aplica, §14 no exige retroactivamente snapshot. No reactivar terminales |

Los modos conservadores U sacrifican concurrencia para revisar un protocolo coherente; optimizar a N/S exige demostrar que preserva FKs, invariantes y ausencia de ciclos. No introducir adquisición de A1(1919001) ni reutilizar A2(1919,1) desde UC-07 por analogía: no genera precios. El namespace actual de UC-19 queda reservado a coordinación de escritores precio/auditoría. Tampoco reutilizar A2(808,0) para IDs de excedentes por analogía; precisar generador compartido entre UC-05/06/07/41 (secuencia común o advisory dedicado acordado por todos). Una nueva coordinación solo entre UC-07 no resuelve inversiones de servicios existentes. UC-05 puede necesitar locks financieros/inventario/asignación adicionales: debe publicar su DS compatible antes de declarar completo el orden global.

### 12.4. Pares que comparten recursos y ciclos posibles

| Par | Espera/grafo a examinar | Tratamiento / incertidumbre |
|---|---|---|
| UC-03 ↔ UC-19 | **Defecto histórico CONFIRMADO:** con idCliente=1919001, UC-03 retiene A1(1919001) y espera PRODUCTO S; UC-19 antiguo retiene PRODUCTO U y espera A1(1919001). Corte 3 reportó 3/3 SQLSTATE 40P01 | **IMPLEMENTADO/INTEGRADO:** #86 sustituye UC-19 por A2(1919,1), main 4dbe386. Seis intercalados experimentales sin ese ciclo y prueba permanente específica incorporada; no certifica orden global ni se reejecuta aquí |
| UC-28 ↔ UC-19 | El riesgo histórico de coincidencia idInsumo=1919001 con A1 de UC-19 ya no corresponde a su llamada actual A2(1919,1). Persisten PRODUCTO S/U, precio y dependencias con terceros | Separación A1/A2 evita esa colisión numérica puntual; no elimina por sí sola otras inversiones con receta/insumo/producto. Examinar escritores restantes y no llamar deadlock a toda espera |
| UC-03 ↔ UC-28 | Producto S/S compatible, A1(idCliente)=A1(idInsumo) puede esperar por coincidencia numérica. UC-03 vuelve a CLIENTE U después de producto pero ya lo tomó antes | No afirmar ciclo directo sin otra arista; añadir UC-19 y política comercial para cadenas. Ordenar raíces antes de producto en UC-07 |
| UC-28 ↔ UC-07 A/B | UC-28 tiene PEDIDO/detalle U y pide PRODUCTO S; UC-07 con PRODUCTO U/S y K/U tardío de ese detalle/pedido puede cerrar ciclo si los modos conflictúan | Bloquear pedidos/detalles origen y receptor antes de producto. Un S/S de producto por sí solo no forma ciclo; incluir UC-19 que toma U y FKs nuevas |
| UC-19 ↔ Parte A | PRODUCTO U/S serializa captura; precio U/S y GiST pueden esperar; reloj de UC-19 previo a advisory | t oferta después de esperas y lectura posterior coherente, probar [desde,hasta) y cancelaciones. Auxiliares/B usan snapshot y no esperan P2 |
| O2 ↔ Parte B/rechazo | OFERTA U común serializa sustitución/consumo/cierre; sin lock común ambas podrían validar VERIFICADA y luego actuar | Misma adquisición de raíces/oferta/evidencias; índice conjunto y eventos obligatorios defensivos. Revalidar tras esperar |
| Parte B ↔ UC-41 | EXCEDENTE compartido, movimiento/ID compartidos y cantidadDisponible | U por excedente, generador común previo a filas o secuencia; uno gana y otro revalida stock, sin saldo negativo |
| UC-05/06 ↔ A/O1/O2/B | PEDIDO/DETALLE origen y receptor, CLIENTE, EXCEDENTE, stock, posibles asignaciones y generadores | Inversión CLIENTE↔PEDIDO o EXCEDENTE↔PEDIDO no resuelta por lista nominal. DS exactos pendientes; ordenar múltiples pedidos/detalles y definir raíces antes de integrar |
| Escritores SQL ↔ triggers/FKs | K tardío a padres puede esperar U; trigger con SELECT de otra tabla puede invertir orden; índice/GiST y command-UNIQUE esperan transacción | Rol operativo sin DML libre en historia; funciones controladas respetan catálogo. Inspeccionar grafo real y locks implícitos, no solo SELECT visibles |

El primer ciclo dejó de ser hipótesis: el Corte 3 lo reprodujo y #86 integró su corrección puntual en app, ver adenda. **HECHO VERIFICADO** de integración distinto de **PROBADO según informe R/P**; no se ejecutan pruebas reales nuevas en C1. No declarar resuelto el orden global por esa corrección. Inventario adicional necesario: UC-43/asignación, maestros de producto/receta/insumo, UC-08/42/29 y funciones invocadas; esta matriz detalla los consumidores solicitados y explicita el límite de cobertura global.

### 12.5. Plan histórico Corte 3 y ampliación pendiente C3

**Historial:** el plan Etapa B siguiente tuvo ejecución parcial reportada en Corte 3: L1 real, L2/L3 mixtos y L4/L5 prototipos. No se acredita ejecución total de esta lista ni de recibos/HTTP. **Pendiente C3:** pruebas con cuerpos físicos definitivos C2 y escritores restantes.

1. Para la futura ampliación, autorización específica del experimento; checkout/artefacto descartable separado de app/main y de PR #85, sin despliegue. PostgreSQL 17.11 (precedente `postgres:17.11-alpine` de `RegistrarPreparacionConcurrenciaIntegrationTest.java` L20–44), Flyway V1–V3 sin editar y esquema candidato solo en sandbox de prueba autorizado. Ninguna migración/DDL se ejecuta en Etapa B.
2. Dos o tres conexiones/transacciones reales READ COMMITTED con IDs sintéticos controlados, incluidos cliente=1919001, insumo=1919001 y dos productos/pedidos. Barreras CountDownLatch en puntos de lock para forzar cada intercalado; no depender de sleeps. Confirmar que el primer lock se adquirió consultando observabilidad antes de liberar la otra sesión. Repetir ambos órdenes de llegada y múltiples raíces con IDs invertidos.
3. Registrar por paso: PID, transacción, recurso, modo pedido/concedido, `pg_locks`, `pg_blocking_pids`, waits/transactionid y `pg_stat_activity`, sin tokens ni datos personales. En laboratorio fijar y reportar lock_timeout/statement_timeout/deadlock_timeout permitidos (no requieren privilegios extra en esta tarea); deadlines de Future/test y rollback/cleanup garantizado. Un timeout no prueba deadlock y un éxito aislado no demuestra ausencia universal.
4. Intercalados mínimos: ciclo UC-03/19 descrito; UC-19/A con cambio P→P2 y frontera temporal/cancelación; UC-28/A/B sobre pedido/detalle origen; dos O1 misma/distinta clave; O2/O2; O2/B y O2/rechazo; B/UC-41; UC-05/06 contra B según DS futuros, incluidos generadores; FK K de detalle/producto y guardias de precio. Si no hay implementación de operación pendiente, el harness SQL solo valida el protocolo candidato y no certifica un servicio futuro.
5. Aserciones tras commit/rollback: una V1 por oferta; snapshots/coherencia temporal; una evidencia en VERIFICADA/UTILIZADA; estado y cadena de eventos concordantes; intento único por oferta; una transferencia por oferta; stock/costo correctos; recibo original inmutable y estadoActual real; cero efectos parciales al inyectar error entre actualización/evento/recibo. SQLSTATE 40P01/55P03/40001 y timeouts clasificados, con política aprobada de reintento acotado de transacción completa, nunca doble aceptación.
6. Evidencia de entrega: SHA exacto de código/harness/esquema, versión PG/Flyway, fixtures, barreras/intercalados, trazas de espera, resultados y CI. Un deadlock esperado al reproducir el orden antiguo acredita el hallazgo; luego probar candidato/corrección autorizada, sin ocultar fallos con reintentos. No cerrar RT-UC07-04 por pasar B0 documental; diseño suficiente antes de autorizar transacciones y pruebas reales aprobadas antes del merge funcional, conforme la secuencia de RD-UC07-001.

**RT-UC07-04: ABIERTA / PENDIENTE DE AMPLIACIÓN DE PRUEBAS REALES Y COORDINACIÓN DE OPERACIONES PENDIENTES.** No se certifica ausencia de deadlocks ni se autoriza implementar el protocolo por este documento.

## 13. Integridad física cruzada, inmutabilidad y bitácora protegida — F

**Compatibilidad F1–F5 verificada para preparar C2:** tabla real PRECIO_PRODUCTO, columna precioBase NUMERIC(18,4); no existe precioBaseUnitario en esa tabla. El snapshot futuro se llama precioBaseUnitarioAplicado NUMERIC(18,4) y se coteja con precioBase/producto origen. Conservar ck_oferta_excedente_3 y respuestas PENDIENTE/ACEPTADA/RECHAZADA: una guardia permite PENDIENTE→ACEPTADA/RECHAZADA con campos coherentes y condiciones originales inmutables, sin exigir vigencia actual del precio al responder. No se impone cantidad fija de triggers: deben cubrir padres comerciales, evidencia/eventos y comandos además de las relaciones directas.

**Estado final transaccional a diseñar C2:** oferta ACEPTADA, evidencia UTILIZADA, movimiento de reasignación único, imputación al pedido receptor, cantidades/importes aceptados y saldo/costo histórico deben coincidir al commit. Evaluar constraint triggers diferidos para invariantes entre varias sentencias; no exigir cada estado final intermedio ni permitir commit incongruente. O2 debe reflejar NULL→CAPTURADA y CAPTURADA→VERIFICADA como dos hechos causales ordenados. Sin cuerpos PL/pgSQL ni GRANT/REVOKE definitivos en C1.

**F PENDIENTE / NO RATIFICADA — Corte C2:** los siguientes controles son requisitos del futuro diseño ejecutable; no se suplen con validación Java. Los cuerpos de funciones/triggers y GRANT/REVOKE se especificarán/probarán en corte autorizado, nunca se ejecutan aquí.

| Entidad / operación | Garantía física candidata obligatoria |
|---|---|
| OFERTA_EXCEDENTE BEFORE INSERT | Exigir snapshot completo nuevo; bajo raíces bloqueadas recorrer excedente→detalle origen→producto; contrastar precio.idProducto, no cancelado y vigencia [desde,hasta) en fechaHoraOferta única servidor. Snapshot debe ser exactamente precioBase NUMERIC(18,4); la operación controlada calcula importeInformado con D2-A y ajuste congelado, sin importe de autoridad aportado por cliente. No aceptar fecha/P arbitrarios como hechos por venir desde SQL operativo. Inserción solo mediante operación controlada que toma reloj DB posterior a esperas y revalida estados |
| OFERTA BEFORE UPDATE/DELETE | UPDATE compara OLD/NEW: identidad, excedente, receptor, fechaHoraOferta, cantidadOfrecida, importeInformado, idPrecio/P inmutables; solo transición PENDIENTE→ACEPTADA/RECHAZADA legítima según ck_oferta_excedente_3 y protocolo Parte B/rechazo; preservar ofertas ya cerradas. DELETE prohibido operativo. Excepción histórica delimitada en §14, sin obligación retroactiva de snapshot |
| Padres comerciales/procedencia | Proteger relación producto del detalle origen, vínculo del excedente y ajuste tipo/porcentaje del pedido receptor contra cambios retroactivos por escritor operativo. Para PRECIO_PRODUCTO referido, guardia ante UPDATE/DELETE impide cambiar producto/precioBase o eliminar procedencia; cierres futuros UC-19 permitidos si no excluyen el instante ya registrado de ofertas. Cancelación/rangos no pueden invalidar retrospectivamente la captura. Coordinación por PRODUCTO antes de precio; no agregar lock tardío de oferta desde UC-19. Cuerpos/privilegios exactos y compatibilidad con UC-19 requieren prueba |
| COTIZACION BEFORE INSERT/UPDATE/DELETE | INSERT bloquea oferta padre, exige estado admisible y 0<q<=cantidadOfrecida, V1 igual a padre y versiones >=2 parciales; coteja cálculo D2-A con snapshot y ajuste protegido, no precio actual. UNIQUE padre/version y padre/id. UPDATE/DELETE rechazan alteraciones de cualquier campo comercial/identidad/autor/instante: toda recotización es nueva fila. Excepción solo por mantenimiento autorizado fuera del rol app |
| EVIDENCIA BEFORE INSERT/UPDATE/DELETE | INSERT exige padre/cotización coherentes (FK compuesta), q/importe iguales a versión, tiempo válido, intento positivo único asignado bajo padre; hash SHA-256 servidor sobre bytes. Verificación física hash/bytes necesita función hash instalada/autorizada (no asumir pgcrypto existente). UPDATE permite solo transición controlada, no cambiar intento, padre/cotización, bytes, hashes, MIME, cantidad/importe, contacto/declaración/autor/fechas. UTILIZADA/INVALIDADA terminales. DELETE prohibido operativo |
| Estado y eventos obligatorios | BEFORE INSERT/UPDATE de evidencia valida creación CAPTURADA y cada par OLD→NEW; mecanismo trigger transaccional inserta automáticamente evento inicial/transición con ordenEvento siguiente bajo lock, actor/motivo confiables. Fallo de evento revierte cambio de estado. BEFORE INSERT de evento solo admite origen controlado, coteja evidencia real/último evento/orden; no se permite insertar historia falsa por DML libre. Si se usa trigger posterior para leer estado ya escrito, complementar con constraint trigger diferido que verifique estado final=último evento al commit. El estado debe existir antes de la FK del evento; **no insertar evento inicial en BEFORE INSERT antes de crear evidencia**. Detalle de combinación BEFORE/AFTER/diferido y prueba es pendiente, no garantía aportada solo por CHECK |
| EVENTO BEFORE UPDATE/DELETE | Rechazo incondicional para rol operativo; bitácora append-only, sin editar fechas/motivos/estados. UNIQUE(evidencia,ordenEvento), evento inicial único y cadena causal comprobada. BIGINT identidad no sustituye ordenEvento |
| COMANDO BEFORE INSERT/UPDATE/DELETE | INSERT solo desde operación controlada, recurso/operación/oferta/actor coincidentes, huella y recibo conforme esquema contractual/efecto creado en misma transacción. FKs compuestas no prueban igualdad del JSON: guardia coteja IDs, importe/cantidad/estado original/instante según efecto. UPDATE/DELETE rechazan cambios operativos de clave/huella/vínculo/recibo; retención excepcional aprobada sin reactivar claves |

**Modelo de privilegios explícito:** rol runtime app distinto del propietario/migrador; sin SUPERUSER/BYPASSRLS, propiedad de tablas, CREATE sobre esquema, ALTER/DROP/TRUNCATE ni capacidad de deshabilitar triggers/cambiar session_replication_role. Revocar UPDATE/DELETE de cotización/eventos/comandos y DML directo de estado/evidencia/snapshot; conceder solo SELECT mínimo y EXECUTE de operaciones controladas del dominio. Sin INSERT directo de eventos/recibos. Las operaciones elevadas, si SECURITY DEFINER, usan propietario separado sin login, search_path fijo seguro, objetos cualificados, EXECUTE revocado a PUBLIC y chequeo de argumentos/sesión/ámbito; no autorizar por GUC/variable de sesión falsificable. La identidad comercial requiere puente confiable con principal autenticado/validación de sesión, **no** un idUsuario enviado por SQL o HTTP. Diseño exacto de ese puente y privilegios del rol real es bloqueante.

Los triggers de integridad bloquean además a escritores no cooperantes con DML permitido; la privación de DML evita que esos escritores eludan la operación. No se afirma resistencia contra propietario/superusuario: mantenimiento excepcional con autorización, motivo, respaldo y auditoría fuera del runtime. Ninguna cuenta de mantenimiento se usa para el servicio normal. Integridad física comercial y autenticidad humana son garantías diferentes; no se atribuye a una FK ni al hash verificación criptográfica de WhatsApp.

## 14. Históricos y estrategia determinista — G PENDIENTE / NO RATIFICADA (C2)

### 14.1. Antecedentes comprobados y límite

La auditoría de código Etapa B al SHA d5f7607 no encontró INSERT de OFERTA_EXCEDENTE en migraciones/fixtures; no era inspección de bases destino. El Corte 3 ensayó únicamente datos sintéticos/guardias en PostgreSQL descartable. Ninguno certifica destinos vacíos. C1 no ejecuta preflight en ninguna BD, no elige rama y no crea/ejecuta migración. V1/V2/V3 y sus checksums permanecen intactos.

### 14.2. Restricciones del futuro preflight

Antes de elegir política física: identificar destino/versión, inventariar filas, respuestas ya ACEPTADA/RECHAZADA y snapshots nulos; coordinar pausa de escritores incompatibles para impedir cambios entre comprobación y migración. No inventar precio por importe/cantidad ni usar P actual como histórico. Conservar estados/comercial original e historia; rechazo masivo por conveniencia migratoria queda excluido.

**Una misma versión Flyway no debe producir esquemas distintos según datos de cada destino.** La comparación Etapa B de tabla vacía versus legado era análisis de alternativas, no autorización para IF por datos que cree NOT NULL en un destino y columnas nullable/otros triggers en otro.

### 14.3. Ruta candidata de tabla vacía

Solo tras certificación y decisión C2: proponer migración **determinista** con NOT NULL para nuevas columnas, FK/guardias y precondición que aborte íntegramente si aparecen filas inesperadas. La misma migración debe dar el mismo esquema autorizado en todos los destinos donde se aplique. Fallar una precondición no autoriza continuar con otra estructura ni rellenar P ficticio; decidir tratamiento específico antes de reintentar.

### 14.4. Si existen históricos: detener ruta y decidir tratamiento

Cualquier legado o incertidumbre detiene la ruta vacía. Someter a decisión C2 un tratamiento específico con fuentes inequívocas, preservación de ofertas ACEPTADA/RECHAZADA, regularización/auditoría y política de respuesta de pendientes sin bloquear UPDATE histórico legítimo. No ejecutar tal decisión en C1.

CHECK(... NOT VALID) omite escaneo inicial pero se evalúa en todo INSERT/UPDATE posterior: un CHECK global que exija snapshot no nulo puede bloquear el cierre de una fila antigua. Este defecto se reprodujo en Corte 3; no usar NOT VALID como solución retroactiva. El CHECK del par completo/ausente de §15 no exige presencia en filas nuevas.

La solución estudiada en Etapa B (BEFORE INSERT estricto, BEFORE UPDATE diferenciado para OLD legado y prohibición de fabricar procedencia) queda como **alternativa técnica pendiente**, no ruta adoptada. Requiere identificar legado de forma protegida, impedir oferta nueva incompleta y conservar cierres legítimos sin reasignar un precio inventado. Aceptación de legado sin prueba histórica sigue bloqueada hasta política aprobada; no declarar autorizado aceptar, rechazar o alterar registros por este texto. Si se elige un esquema con legado, deberá definirse explícitamente su esquema objetivo uniforme, versiones y rollout, sin ramas divergentes dentro de una misma migración Flyway.

### 14.5. Preparación de recuperación y dependencias C2

Inventario/decisión de tratamiento → esquema objetivo uniforme y precondiciones → dependencias ordenadas snapshot/raíces, cotizaciones/UNIQUE compuesta, evidencias, eventos y recibos → funciones/privilegios definitivos de C2 → pruebas descartables/backup/restore → autorización de implementación y activación correspondiente. Funciones que consultan tablas nuevas se instalan después de sus dependencias; no reabrir escritor incompatible en una ventana sin protección.

Medir conteos, huellas, nulos/referencias, locks, duración y espacio. No editar checksums, reaplicar a ciegas ni borrar evidencia al retroceder código. Diseño de restauración/forward-fix y tratamiento de escrituras posteriores requieren aprobación. Sin preflight ni elección de rama en C1; Issue #28 sigue OPEN/PAUSADO.

## 15. DDL candidato consolidado y decisiones abiertas

**PROPUESTA DOCUMENTAL — NO EJECUTAR.** Fragmentos en este Markdown exclusivamente: no archivo SQL ejecutable, no migración lista para aplicar, sin cuerpos de triggers. Contienen tipos/identidad y FK compuesta RATIFICADOS por B, intento RATIFICADO C y resto de mecanismos/documentación candidata; no autorizan migración ni reglas D/E/F/G/H. UUID de servidor sin algoritmo único impuesto; idEvento BIGINT mediante identidad PostgreSQL ratificada. El conjunto no cierra guards cruzados y privilegios descritos en §§4–13; tampoco es afirmación de compilación en PostgreSQL.

### 15.1. Extensión de oferta, compatible con auditoría de históricos

```sql
-- PROPUESTA DOCUMENTAL. NO EJECUTAR.
-- Antecedente Etapa B nullable para analizar legado: NO es ruta elegida en C1.
-- C2 debe definir esquema uniforme/precondiciones; sin IF por datos que cambie el esquema.
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

No cambiar fk_oferta_excedente_2 ni ck_oferta_excedente_3. NULL histórico no habilita nuevas ofertas sin snapshot: §14 define BEFORE INSERT obligatorio y BEFORE UPDATE diferenciado o NOT NULL bajo tabla vacía certificada; cuerpos y autorización pendientes. Este fragmento nullable es antecedente de análisis de legado; no habilitarlo ni elegir rama en C1. C2 deberá definir esquema uniforme/precondiciones y guardias, sin divergencia de una misma migración por destino.

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

Formato hex minúsculo candidato coordinado con CR-C; no aprueba algoritmo/canonización. Checks positivos no garantizan importe D2-A ni cantidad<=ofrecida: los mecanismos físicos complementarios obligatorios del candidato se especifican en §13; este bloque sin sus funciones no es una migración completa.

### 15.3. Evidencia candidata con pertenencia compuesta

```sql
-- PROPUESTA DOCUMENTAL. NO EJECUTAR.
CREATE TABLE "EVIDENCIA_ACEPTACION_OFERTA" (
  "idEvidencia" UUID NOT NULL,
  "idCotizacion" UUID NOT NULL,
  "idOfertaExcedente" BIGINT NOT NULL,
  "numeroIntentoEvidencia" INTEGER NOT NULL,
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
  CONSTRAINT "uq_evidencia_intento_oferta" UNIQUE ("idOfertaExcedente", "numeroIntentoEvidencia"),
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
CREATE UNIQUE INDEX "uq_evidencia_utilizable_por_oferta"
  ON "EVIDENCIA_ACEPTACION_OFERTA" ("idOfertaExcedente")
  WHERE "estadoEvidencia" IN ('VERIFICADA', 'UTILIZADA');
```

No CHECK de techo 2097152 ni MIME cerrado como regla definitiva. numeroIntentoEvidencia ahora exige NOT NULL, CHECK positivo y UNIQUE por oferta; la asignación bajo lock y la ausencia de consumo por prevalidación se especifican en §6. Alternativa A por JOIN exige otro mecanismo para unicidad por oferta: no mezclar sus columnas ausentes con estos índices.

### 15.4. Eventos candidatos y transiciones

```sql
-- PROPUESTA DOCUMENTAL. NO EJECUTAR.
CREATE TABLE "EVENTO_ESTADO_EVIDENCIA_OFERTA" (
  "idEvento" BIGINT GENERATED ALWAYS AS IDENTITY,
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
  "idComandoAuxiliar" UUID NOT NULL,
  "operacion" VARCHAR NOT NULL,
  "idOfertaExcedente" BIGINT NOT NULL,
  "idUsuarioVendedor" BIGINT NOT NULL,
  "claveIdempotencia" VARCHAR(128) COLLATE "C" NOT NULL,
  "huellaSolicitud" CHAR(64) NOT NULL,
  "idCotizacion" UUID,
  "idEvidencia" UUID,
  "estadoHttpOriginal" INTEGER NOT NULL,
  "respuestaOriginal" JSONB NOT NULL,
  "fechaHoraRegistro" TIMESTAMPTZ NOT NULL,
  CONSTRAINT "pk_comando_aux_uc07" PRIMARY KEY ("idComandoAuxiliar"),
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
  CONSTRAINT "ck_comando_aux_clave" CHECK (
    char_length("claveIdempotencia") BETWEEN 1 AND 128
    AND "claveIdempotencia" COLLATE "C" ~ '^[!-~]{1,128}$'
  ),
  CONSTRAINT "ck_comando_aux_huella" CHECK ("huellaSolicitud" ~ '^[0-9a-f]{64}$'),
  CONSTRAINT "ck_comando_aux_http" CHECK ("estadoHttpOriginal" BETWEEN 200 AND 299),
  CONSTRAINT "ck_comando_aux_json" CHECK (jsonb_typeof("respuestaOriginal") = 'object')
);
```

Tipo UUID de idComandoAuxiliar está RATIFICADO B; resto de D es ESPECIFICADO PARA RATIFICACIÓN. Clave antes TEXT pasa a VARCHAR(128) COLLATE "C" y CHECK ASCII de §10, preservando igualdad exacta de clave en UNIQUE; HTTP y función SQL validan original antes de cast/truncamiento. respuestaOriginal JSONB NOT NULL es nombre único, sin reciboOriginalJson. Validar esquema mínimo y vínculo/recibo con efecto: JSONB objeto no basta ni admite datos sensibles. Sin TTL/purga online ni PENDIENTE confirmado en MVP candidato. Canonización UTF-8, retención y errores exactos en §10; funciones/privilegios definitivos quedan en C2, sin ejecutar este fragmento.

## 16. Compatibilidad con línea base G0

64 CU y 67 firmas principales intactos. Parte A registrarOfertaExcedente(Long,Long,BigDecimal) y Parte B registrarRespuestaOfertaExcedente(Long,Boolean,BigDecimal) conservadas; no se agregan IDs de cotización/evidencia a esas firmas. Ambas auxiliares de CR-C subordinadas y solo VENDEDOR=D; FK a actor no amplía RBAC ni concede rol ADMIN aprobador.

ck_oferta_excedente_3, migraciones V1/V2/V3, contratos REV04B, manifiestos, RBAC, source-lock y RDs anteriores intactos. No se ejecuta SQL ni crea migración real. TotalOriginal y cantidadOriginal originales no cambian; línea técnica D1-B solo al aceptar dentro de Parte B, sin nueva preparación de excedentes. Se preservan cargo UC-05 y separación de efectivo en tránsito; no modificación de CR-B0-F04-001.

## 17. Coordinación cruzada CR-C ↔ CR-F

### 17.1. Datos y tipos

CR-C coordinada: [PR #47](https://github.com/leandrito369/ale-milanesas/pull/47), nuevo HEAD C1 `0b75eb4ca32db9481e22a34c80eb637b80351a31` (base C1 `7a4887d0c447c7ee82ce0c729d9360b8cbc1c661`; antecedente Etapa B `06bf800cdbfab9eedebe5a7a79e32269df01e63f`), leído desde ese commit. Esta rama solo modifica su CR-F; no incluye cambios del archivo de CR-C.

| Elemento | CR-C | CR-F candidata | Coincide |
|---|---|---|---|
| idCotizacion | UUID servidor RATIFICADO B | UUID PK/FK | Sí; mecanismo concreto pendiente |
| idEvidencia | UUID servidor RATIFICADO B | UUID PK | Sí, no autorización de implementación |
| idComandoAuxiliar | UUID servidor RATIFICADO B, registro interno | UUID PK COMANDO_AUXILIAR_UC07 | Sí, sin exigir exposición HTTP |
| idEvento | BIGINT identidad PostgreSQL RATIFICADO B | BIGINT GENERATED ALWAYS AS IDENTITY | Sí, no UUID |
| Replay | resultadoHistorico + estadoActual; reautorización | Recibo inmutable, lectura actual consistente y permisos vigentes | Sí, D ESPECIFICADA PARA RATIFICACIÓN |
| Evidencia utilizable única | Índice conjunto por oferta | uq_evidencia_utilizable_por_oferta, VERIFICADA/UTILIZADA | Sí, candidato F PENDIENTE C2 |
| codigoOferta | Identidad estable padre | Derivación sobre datos originales protegidos | Sí; no columna obligatoria nueva |
| codigoCotizacion | String de versión | CHAR(64) hex candidato | Sí conceptual; canonización definitiva pendiente |
| numeroVersion | int salida | INTEGER positivo y UNIQUE por oferta | Sí; generador pendiente |
| numeroIntentoEvidencia | Por oferta, prevalidación no consume, replay no incrementa | INTEGER NOT NULL >0 + UNIQUE(oferta,intento), lock padre | Sí, RATIFICADA C |
| cantidadConfirmada | Entrada validada BigDecimal | NUMERIC(18,3), cotejo con cotización | Sí |
| importeConfirmado | Entrada no autoritativa | NUMERIC(18,2), igualdad/cálculo servidor | Sí |
| fechaHoraMensaje | OffsetDateTime declarada | TIMESTAMPTZ | Sí; D especifica UTC/microsegundos exactos; tolerancia comercial pendiente |
| fechaHoraRegistro | Salida servidor | TIMESTAMPTZ servidor | Sí |
| Estados evidencia | Cuatro estados/transiciones, terminales | CHECK + eventos + transición controlada propuesta | Sí, requiere mecanismo físico |
| Idempotency-Key | §10 C1: 1–128 ASCII, huella versionada y replay | COMANDO_AUXILIAR_UC07, VARCHAR(128)/CHECK, respuestaOriginal | Sí, D especificada NO ratificada |
| Límites de archivo | 1 MiB app/2 MiB físico/4096² experimentales | ck_evidencia_no_vacia conservado, sin techo definitivo | Sí; E especificada NO ratificada |
| Actor vendedor | Principal autenticado | FK USUARIO y eventos con actor servidor | Sí; FK no sustituye autorización |
| MIME declarado y validado | Ambos conservados | tipoMimeDeclarado y tipoMimeContenido | Sí |

### 17.2. Reglas contractuales y garantías físicas

| Regla CR-C | Persistencia necesaria | Constraint, lock o transacción candidata | Prueba |
|---|---|---|---|
| Emisión | Oferta/snapshot y cotización | Validación cruzada D2-A, lock oferta, recibo mismo commit | F01,F11,F13,F14 |
| V1 inicial / O1 | Oferta + V1; consulta/emisión parcial/replay distintos | A RATIFICADA: V1 atómica, >=2 parcial; D candidata para replay | F10,F45,F50 |
| Numeración concurrente | numeroVersion | Lock oferta + UNIQUE; no MAX sin coordinación | F12,F16 |
| Registro evidencia | Cotización, bytes, metadatos | FK compuesta, checks y validación servidor | F17–F21,F29–F35 |
| Sustitución atómica | Dos evidencias y eventos | Oferta bloqueada; nueva válida antes de invalidar, commit único | F22,F23,F40,F41 |
| Transiciones/bitácora | Estado y eventos | Pares, orden por evidencia, operación controlada, append-only | F24,F27,F36,F37,F45 |
| Idempotencia/replay | Clave/huella/efecto/recibo | UNIQUE por alcance, serialización previa y atomicidad | F16,F46–F48 |
| Correlación comercial | Cotización + pertenencia | FK compuesta y cotejo de cantidad/importe/tiempo | F18–F20,F28 |
| Datos/recuperación | Bytes, huella, accesos/backup | Permisos, hash, controles streaming, no-store y retención | F29–F39 |
| Inmutabilidad | Snapshot, versiones, evidencia/eventos | Triggers/operaciones controladas/permisos especificados en §13; cuerpos futuros | F08,F15,F27,F35,F36,F54 |
| Rechazo/confirmación final | Oferta/movimiento/stock/evidencia | Rechazo sin evidencia, serialización y rollback Parte B | F24–F28,F42,F43 |

Compatibilidad C1 cotejada contra nuevo SHA CR-C: A/B/C RATIFICADAS por decisión expresa del responsable; D/E ESPECIFICADAS PARA RATIFICACIÓN; F/G/H PENDIENTES. No reabrir tipos/identidad/FK compuesta/intentos como elecciones técnicas aún no tomadas. Pendientes: contratos auxiliares/rutas y ratificación D/E, límites calibrados, funciones/privilegios/estado final C2, preflight y tratamiento uniforme de legado, matriz global/generadores y campaña C3. #85/#86 MERGED no equivalen a UC-07 implementado ni RT-UC07-04 cerrada.

## 18. Plan de pruebas PostgreSQL/Testcontainers

Todas las filas F siguen **PLAN DE PRUEBAS DE LA IMPLEMENTACIÓN DEFINITIVA, NO ACREDITADO COMO SUITE COMPLETA**. Corte 3 tuvo ensayos R/P parciales descritos en adenda/§12, sin equivalencia automática con todos estos IDs; C1 no ejecuta PostgreSQL ni implementa esos servicios. B0 documental no ejecuta estos escenarios. Precondiciones aluden a un futuro entorno descartable autorizado con esquema candidato definitivo, datos sintéticos y actores correctos; no a producción. IDs F locales a esta CR.

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
| F10 | Candidato A preferente | Crear oferta/V1 y fallar entre inserciones | Cantidad/importe iguales, ambas o ninguna | Cotización |
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
| F50 | Oferta con V1 | Consultar, POST total nuevo, parcial misma/distinta clave | Consulta no escribe; total no devuelve V1; nueva parcial >=2; replay sin versión extra | O1 |
| F51 | Dos cotizaciones de una oferta | Persistir intentos y rechazar archivo antes de transacción | Secuencia única por oferta; sin consumo por rechazo previo/replay; INVALIDADA conserva número | Intentos |
| F52 | Evidencia con recibo original VERIFICADA, hoy terminal | Replay con y sin autorización vigente | Histórico separado de estado actual; sin acceso no hay recibo | Idempotencia |
| F53 | VERIFICADA o UTILIZADA existente | Insertar otra fila en cualquiera de ambos estados | Índice conjunto rechaza; sustitución y transición misma fila sí válidas | Unicidad |
| F54 | Rol SQL operativo, sin servicio cooperante | Violar snapshot, cantidad, igualdad, bytes, evento/estado o DELETE | Guardias/permisos rechazan; no historia alterada | Integridad física |
| F55 | Legado sin snapshot y oferta nueva incompleta | Rechazo legítimo del legado; insertar nueva; aceptar sin fuente | UPDATE legítimo no bloqueado por NOT VALID; nueva y aceptación no demostrada se rechazan | Históricos |
| F56 | Sin filas, certificado con escrituras detenidas | Aplicar rama NOT NULL y reanudar escritor compatible | Ninguna oferta nueva sin snapshot; certificado inválido ante carrera | Históricos |
| F57 | Intercalados §12.5 y futura C3 | Barreras y conexiones reales | Ampliar evidencia R/P sin dar por cerrado RT04 por documentos o #86 | Locks |
| F58 | Clave 1–128 ASCII/huella versionada | Fronteras HTTP/SQL y vectores UTF-8/NULL | Canonización exacta, rechazo de pérdida decimal/temporal, sin colisión de solicitudes | D |
| F59 | Replay/timeout/retención | Mismo/distinto payload, pérdida de permisos, 503 transitorio, purga excepcional | Recibo original, estado actual y deduplicación preservados | D |
| F60 | 20–30 muestras seguras y adversariales | Medir E y presupuestos | Límites finales motivados, sin P99 concluyente ni datos personales en Git/CI | E |
| F61 | Destinos con/sin filas | Preflight externo y abortar precondición inesperada | Misma versión Flyway no produce esquemas divergentes por datos; no regularización inventada | G/C2 |

Ampliaciones del plan: fallos y versión antigua V2 con evidencia aún válida tras emitir V3 sin aceptación; cruce con UC-05/06 y UC-28, distintos pedidos/excedentes, replay tras cierre/revocación, purga idempotente, restore y comparación de huellas. Definir timeouts/instrumentación y reproducibilidad de intercalados, confirmar cantidad de pruebas ejecutadas y resultados en CI del SHA funcional. No marcar RT-UC07-04 cerrada por el mero diseño ni confundir pruebas ya existentes de UC-19 con estas.

## 19. Riesgos, exclusiones y criterios de autorización

Riesgos bloqueantes: correlación temporal/producto insuficiente con FK simple; pares snapshot nulos históricos; incoherencia entre límite aplicativo/físico; heredados sin fuente exacta de P; duplicados semánticos no detectables solo por hash; mecanismos físicos definitivos pendientes de C2/C3 pese a ensayos parciales del índice/guardias; relojes coincidentes sin orden; eventos/estado no atómicos; ciclos por invertir PEDIDO/PRODUCTO; purga prematura de claves; escrituras privilegiadas fuera del servicio; identidad manual no autenticada; borrado de datos personales frente a historial terminal. Cada uno requiere solución verificable antes de autorizar, no aprobación por omisión.

**Para autorizar:** revisión del responsable y cruzada con PR #47; respetar A–C ratificadas (UUID/BIGINT identidad, V1/O1, FK compuesta, intentos) sin reabrirlas; ratificar D/E y completar F/G/H (generadores existentes, correspondencia producto/precio e índice conjunto), mecanismo físico de inmutabilidad/auditoría, retención y recibos de idempotencia, calibración y política documental, tratamiento de históricos, diseño suficiente RT-UC07-04, privilegios/seguridad y plan de pruebas. Compatibilidad conjunta demostrada y autorización expresa con fecha/alcance reales. No exigir CR-C mergeada para redactar esta CR-F ni crear dependencia circular entre merges.

Aprobar diseño no equivale a ejecutar pruebas. #85 de UC-03 y #86 de UC-19 ya están integradas; no conservarlas como fixes pendientes. Pruebas globales definitivas pertenecen a C3/corte funcional antes de su merge conforme las RDs. Merge documental de CR-F no autoriza automáticamente crear/ejecutar migración. Issue #28 sigue bloqueando producción; no levantar pausa, perfiles o flags.

**EXCLUIDAS:** implementación UC-07, corrección UC-03, SQL ejecutado, creación de V4 u otra migración, cambio V1/V2/V3, Java/tests/configuración de aplicación, source-lock, contratos/manifiesto/catálogo/RBAC G0, otras RDs/CRs, modificación del archivo de PR #47 en esta rama o merge de ambas PR, autorización de CR-C/CR-F, envío de mensajes y despliegue. Único archivo modificado en esta rama existente: esta CR-F; los bloques SQL son documentación candidata no ejecutada.

## 20. Firmas

**Redactada por:** Codex, agente técnico, para revisión cruzada del responsable.

**Fecha de redacción:** 11/11/2026.

**Estado:** OPEN / DRAFT — NO AUTORIZADA INTEGRALMENTE — NO CREA MIGRACIONES.

**Responsable de autorización:** Victor Leandro Machado (`leandrito369`).

**Constancia de ratificación parcial:** A–C por Victor Leandro Machado, 12/11/2026, según decisión expresa del encargo C1. **Firma y fecha de autorización integral:** PENDIENTES, no atribuidas. **Implementación y despliegue:** NO AUTORIZADOS por este documento.
