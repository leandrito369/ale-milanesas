# CR-B0-UC07-002 — Modelo físico para evidencia y cotizaciones de UC-07

## 1. Identificación, estado, autoridad y fuentes

**Clase:** Solicitud de Cambio Física (CR-F).

**Estado:** OPEN / DRAFT — NO AUTORIZADA INTEGRALMENTE — NO CREA MIGRACIONES.

**Fecha de redacción:** 11/11/2026, Argentina; no es fecha de autorización. **Historial Etapa B:** 12/11/2026, convergencia propuesta. **Actualización C1:** 12/11/2026, A–C ratificadas; D–E candidatas especificadas; F–H pendientes. **Actualización C2:** 12/11/2026, F/G especificadas para revisión, no ratificadas; F8 bloqueante y H abierta.

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

### Actualización C2 — fuentes y alcance

Se revalidaron gobierno main `cdd57ed194268f1f5ab29aa0f55781ddddebdfb5`, app main `4dbe38668fc5cbc08d04e10920e3bf165c71be11`, PR #85/#86 MERGED e Issue app #28 OPEN. Bases documentales C1: PR #47 `0b75eb4ca32db9481e22a34c80eb637b80351a31` y PR #48 `4105e60bd7ac35b089c683e206a95aec9ae77fd6`; se releen ambas CR completas. CR-C coordinada C2: [commit 9c0a54e4a2147f5f048f7827f26a21b1bfeecf1b](https://github.com/leandrito369/ale-milanesas/commit/9c0a54e4a2147f5f048f7827f26a21b1bfeecf1b), en especial §13.1. No se inventa el SHA futuro de esta CR-F ni se crea dependencia circular.

Fuentes físicas al SHA app 4dbe386: V1–V3, servicios UC03/19/28, controles HTTP, AutorizacionSesionInterna y TokenSesionInterna; se releen contratos UC05/06/07/41, RDs UC07/UC19/RP022 y protecciones V1. V1 mantiene blob `9c6099e475577499252d12c196685d12dcbbab67`; no contiene columnas snapshot ni tablas nuevas. No se consultó una base destino, ejecutó SQL, creó migración ni modificó app. C2 preserva A–C ratificadas y el texto íntegro D/E candidato de C1. La corrección F6-A/F6-B fue indicada expresamente por el responsable durante este corte; sus mecanismos siguen siendo propuestas.

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
| ENTREGA/DETALLE_ENTREGA, L206/L213 | PK entrega por pedido y detalle compuesto; fk_detalle_entrega_0/1 hacia ENTREGA/DETALLE_PEDIDO (L911–914); se crean en UC05, no al aceptar UC07 |
| IMPUTACION_ENTREGA_ADICIONAL, L280 | PK (idPedido,numeroDetalle,idMovimientoExcedente), cantidadImputada escala 3, importeImputado escala 2; uq_imputacion_entrega_adicional_0 por movimiento; fk_imputacion_entrega_adicional_0 a DETALLE_ENTREGA y _1 a MOVIMIENTO_EXCEDENTE (L922–923) |
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

### Matriz A–H — estado vigente C2 (ratificaciones C1 preservadas)

**Autoridad:** Victor Leandro Machado, decisión expresa del 12/11/2026 comunicada en el encargo Corte C1. Esta constancia asienta A–C en las CR existentes; no crea una RD ni atribuye autorización integral. **Historial:** A–C eran propuestas preferentes en Etapa B y pasan ahora a RATIFICADAS. D–E siguen sin ratificar; F–H no se cierran por pruebas parciales.

| Decisión | Autoridad / estado vigente | Alcance y pendiente |
|---|---|---|
| A | **RATIFICADA — responsable, 12/11/2026** | Parte A crea oferta+V1 atómicamente; V1=(1,cantidadOfrecida,importeInformado); rollback íntegro. O1 emite >=2 solo parciales estrictas; consulta y replay separados. No autoriza ruta de consulta, endpoint ni implementación |
| B | **RATIFICADA — responsable, 12/11/2026** | UUID servidor para idCotizacion/idEvidencia/idComandoAuxiliar; idEvento BIGINT mediante identidad PostgreSQL. Pertenencia por FK compuesta (oferta,cotización) hacia UNIQUE correspondiente, nunca dos FKs independientes. Generación UUID concreta confiable pendiente, sin imponer UUID.randomUUID() |
| C | **RATIFICADA — responsable, 12/11/2026** | Intento INTEGER NOT NULL positivo, secuencial por oferta, UNIQUE(oferta,intento), bajo lock padre. Rechazo previo/replay no consumen; INVALIDADA persistida conserva número; rollback no confirma intento ni permite reutilizar uno ya persistido. numeroVersion no cuenta evidencias |
| D | **ESPECIFICADA PARA RATIFICACIÓN — NO RATIFICADA** | §10: clave 1–128 ASCII, huella UTF-8 versionada, protocolo, replay/errores y retención candidata. Requiere decisión expresa; C1 no implementa ni prueba esa política |
| E | **ESPECIFICADA PARA RATIFICACIÓN — NO RATIFICADA** | Pipeline P2b y calibración; 1 MiB app/2 MiB físico/4096² solo umbrales experimentales. Parámetros definitivos condicionados a muestra y aprobación |
| F | **ESPECIFICADA PARA REVISIÓN/RATIFICACIÓN — NO RATIFICADA** | Cuerpos SQL candidatos y F6-A/F6-B separados; F8/identidad y pruebas C3 bloqueantes, F no completamente cerrada. Tipos/FK B no ratifican mecanismos |
| G | **ESPECIFICADA PARA REVISIÓN/RATIFICACIÓN — NO RATIFICADA** | Preflight sin columnas inexistentes, ruta vacía bloqueada/atómica y alternativa legado uniforme; ninguna ruta elegida ni consulta destino en C2 |
| H | **PENDIENTE / NO RATIFICADA — Corte C3; RT-UC07-04 ABIERTA** | Orden global todavía candidato. Corte 3 reprodujo el defecto puntual UC-03/19 y PR #86 integró corrección; faltan escritores y pruebas globales |

**EXCLUIDA:** autorización integral de CR-C/CR-F, implementación UC-07, nuevos CU/firmas G0, modificación de RDs/migraciones/source-lock/RBAC, merge documental y despliegue. Issue #28 permanece OPEN/PAUSADO.


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

El CHECK de evento puede restringir pares; el estado anterior debe coincidir con último evento/estado real mediante servicio/trigger y locking. Evaluar operación controlada o trigger de transición que registre evento obligatorio y rechace actualización directa sin historial. Resolver actor/motivo confiables y quién puede ejecutar esa operación; un valor de sesión SQL controlable por app no autentica al vendedor. Deshabilitar UPDATE/DELETE de eventos para rol operativo y evaluar triggers defensivos; nombres/cuerpos candidatos desarrollados en §15.8, no ejecutados ni autorizados por esta CR.

Sustitución O2: bloquear oferta y respaldos, validar nueva evidencia completamente; solo entonces anterior VERIFICADA→INVALIDADA por SUPERADA_POR_RECOTIZACION y nueva CAPTURADA→VERIFICADA con eventos. Commit único; cualquier fallo revierte todo y conserva anterior. Emitir una nueva versión sola no invalida respaldo anterior. Parte B posterior consume la VERIFICADA inequívoca y, al transferir con éxito, la pasa a UTILIZADA con evento en la misma transacción que movimiento/stock/oferta. Falta de stock hace rollback, dejando VERIFICADA y sin incremento aceptado/deuda ni movimiento. Rechazo sin evidencia conserva historial e invalida pendientes según contrato que se autorice, sin transferir ni reactivar terminales.

## 8. Integridad referencial y correspondencia entre entidades

| Alternativa evidencia | Garantía y costo |
|---|---|
| Antecedente EXCLUIDO tras ratificación B: solo idCotizacion | Menos redundancia y pertenencia natural. Un índice parcial simple por oferta no puede consultar otra tabla; unicidad global por oferta requeriría otro mecanismo/trigger bloqueado. Lecturas y control de ámbito siempre recorren cotización |
| B RATIFICADA: ambos IDs y FK compuesta | Clave UNIQUE(oferta,idCotizacion) en cotización y FK compuesta desde evidencia. Facilita índices por oferta y control de O2; impide referencias cruzadas. Costo: dato redundante y protección de clave comercial padre |

**RATIFICADA B en C1** en ambas CR y §15, sin autorización integral de migración: UNIQUE(idOfertaExcedente,idCotizacion) en cotización y FK compuesta desde evidencia. Dos FKs simples independientes no impiden evidencia de oferta A apuntando a cotización de B. Todas las referencias propuestas usan RESTRICT y no CASCADE sobre historia, sin cambiar políticas G0 existentes. Considerar bloqueos a borrado de padres por nuevas FKs como impacto a autorizar, no detalle inocuo.

Invariantes cruzadas restantes: producto correcto del precio (§4), cantidad<=ofrecida, cantidad/importe confirmados iguales a versión, versión calculada D2-A, temporalidad entre tablas, oferta/pedido PENDIENTE y rol activo. FK prueba existencia/pertenencia si es compuesta; UNIQUE máximo una fila de clave; CHECK comprueba fila. Validación comercial, autorización, transición y aislamiento requieren servicio/triggers/locking. El cumplimiento debe mantenerse ante escritores SQL no cooperantes bajo permisos del rol operativo, no solo frente al controlador HTTP.

## 9. Restricciones y generadores — B/C ratificadas; F especificada C2, no ratificada

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

**H PENDIENTE C3, ORDEN GLOBAL NO RATIFICADO.** Matriz originada en auditoría histórica Etapa B al SHA app d5f7607; C1/C2 revalidan las correcciones #85/#86 sobre main `4dbe38668fc5cbc08d04e10920e3bf165c71be11`, con contratos de gobierno `cdd57ed194268f1f5ab29aa0f55781ddddebdfb5`. El Corte 3 previo ejecutó parcialmente R/P; no prueba ausencia global de deadlocks. No ejecutar DDL ni experimentos en C1/C2.

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

**Precisión del candidato C2 respecto de §12.3:** fn_uc07_abrir_contexto (§15.6) materializa el subgrafo de raíces. Para A/B toma CLIENTE U de origen y receptor, PEDIDO U y, conservadoramente, todos sus DETALLE_PEDIDO U por PK (más fuerte que S del detalle de origen en la alternativa de la tabla). UC05 toma las raíces/detalles de su receptor; UC41 solo EXCEDENTE U. O1/O2/rechazo no toman EXCEDENTE ni precio actual. En O1/O2, A2(70702,hash del ámbito completo) es un namespace nuevo candidato que C3 debe inventariar/reservar; los generadores BIGINT necesarios deben coordinarse antes de entrar a las raíces, sin reutilizar 1919/808 por analogía.

El gateway completa después de OFERTA U la lectura/lock de COTIZACION S y EVIDENCIA U en orden de identificador cuando corresponda, antes de sus escrituras; abrir_contexto no contiene esos SELECT ni constituye por sí sola un servicio UC07. Las guardias se apoyan en oferta bloqueada, versiones inmutables y escrituras de estado controladas; no toman después nuevas raíces PRODUCTO/PRECIO/PEDIDO. FKs inmediatas, índice conjunto, AFTER de eventos, constraint triggers al commit y la prueba privada agregan aristas que C3 debe observar. Las guardias selectivas de maestros no son una prueba de aislamiento global frente a escritores cuyos grants/protocolos no se hayan incorporado al inventario F8/H.

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

**Historial:** el plan Etapa B siguiente tuvo ejecución parcial reportada en Corte 3: L1 real, L2/L3 mixtos y L4/L5 prototipos. No se acredita ejecución total de esta lista ni de recibos/HTTP. **Pendiente C3:** pruebas con cuerpos físicos candidatos C2 y escritores restantes.

1. Para la futura ampliación, autorización específica del experimento; checkout/artefacto descartable separado de app/main y de PR #85, sin despliegue. PostgreSQL 17.11 (precedente `postgres:17.11-alpine` de `RegistrarPreparacionConcurrenciaIntegrationTest.java` L20–44), Flyway V1–V3 sin editar y esquema candidato solo en sandbox de prueba autorizado. Ninguna migración/DDL se ejecuta en Etapa B.
2. Dos o tres conexiones/transacciones reales READ COMMITTED con IDs sintéticos controlados, incluidos cliente=1919001, insumo=1919001 y dos productos/pedidos. Barreras CountDownLatch en puntos de lock para forzar cada intercalado; no depender de sleeps. Confirmar que el primer lock se adquirió consultando observabilidad antes de liberar la otra sesión. Repetir ambos órdenes de llegada y múltiples raíces con IDs invertidos.
3. Registrar por paso: PID, transacción, recurso, modo pedido/concedido, `pg_locks`, `pg_blocking_pids`, waits/transactionid y `pg_stat_activity`, sin tokens ni datos personales. En laboratorio fijar y reportar lock_timeout/statement_timeout/deadlock_timeout permitidos (no requieren privilegios extra en esta tarea); deadlines de Future/test y rollback/cleanup garantizado. Un timeout no prueba deadlock y un éxito aislado no demuestra ausencia universal.
4. Intercalados mínimos: ciclo UC-03/19 descrito; UC-19/A con cambio P→P2 y frontera temporal/cancelación; UC-28/A/B sobre pedido/detalle origen; dos O1 misma/distinta clave; O2/O2; O2/B y O2/rechazo; B/UC-41; UC-05/06 contra B según DS futuros, incluidos generadores; FK K de detalle/producto y guardias de precio. Si no hay implementación de operación pendiente, el harness SQL solo valida el protocolo candidato y no certifica un servicio futuro.
5. Aserciones tras commit/rollback: una V1 por oferta; snapshots/coherencia temporal; una evidencia en VERIFICADA/UTILIZADA; estado y cadena de eventos concordantes; intento único por oferta; una transferencia por oferta; stock/costo correctos; recibo original inmutable y estadoActual real; cero efectos parciales al inyectar error entre actualización/evento/recibo. SQLSTATE 40P01/55P03/40001 y timeouts clasificados, con política aprobada de reintento acotado de transacción completa, nunca doble aceptación.
6. Evidencia de entrega: SHA exacto de código/harness/esquema, versión PG/Flyway, fixtures, barreras/intercalados, trazas de espera, resultados y CI. Un deadlock esperado al reproducir el orden antiguo acredita el hallazgo; luego probar candidato/corrección autorizada, sin ocultar fallos con reintentos. No cerrar RT-UC07-04 por pasar B0 documental; diseño suficiente antes de autorizar transacciones y pruebas reales aprobadas antes del merge funcional, conforme la secuencia de RD-UC07-001.

**RT-UC07-04: ABIERTA / PENDIENTE DE AMPLIACIÓN DE PRUEBAS REALES Y COORDINACIÓN DE OPERACIONES PENDIENTES.** No se certifica ausencia de deadlocks ni se autoriza implementar el protocolo por este documento.

## 13. F — mecanismos físicos candidatos, invariantes y límites

**F ESPECIFICADA PARA REVISIÓN/RATIFICACIÓN — NO RATIFICADA.** Se desarrollan cuerpos SQL en §15.6–15.13; **F no queda completamente cerrada**: persisten el límite de identidad F8, revisión de permisos efectivos, alcance UC05 de la imputación parcial y pruebas C3. Ninguna definición autoriza implementar UC-07, ejecutar migraciones ni desplegar.

### 13.1. Corrección de F6 acordada durante C2

Por aclaración expresa del responsable del 12/11/2026, se sustituye la exigencia de imputación inmediata al aceptar por dos controles preferentes, **técnicos y no ratificados**:

- **F6-A, UC-07 Parte B:** al commit, oferta ACEPTADA, una evidencia UTILIZADA de la oferta/cotización, cantidades/importes coincidentes, un movimiento REASIGNACION correcto, costo proporcional con remanente exacto al agotar y descuento de saldo en la misma transacción; línea receptora original o técnica. **No exige ENTREGA, DETALLE_ENTREGA ni IMPUTACION_ENTREGA_ADICIONAL.**
- **F6-B, UC-05 posterior:** detalle de entrega e imputaciones corresponden al receptor/producto/movimiento, sin doble imputación ni cantidades sobre lo aceptado/entregado; originales primero y adicionales por orden cronológico. Entrega parcial puede imputar menos que la aceptación. El cargo contable sigue exclusivamente en UC05; no modifica totalOriginal.

Fundamento verificado: V1 L280–290, L922–923, FK de IMPUTACION_ENTREGA_ADICIONAL a DETALLE_ENTREGA; DETALLE_ENTREGA requiere ENTREGA (L911–914). G0 REV04B §2 L97/L105 crea entrega/imputaciones en UC05, mientras §6 A3 L251 exige pedido PENDIENTE al aceptar. RD-UC07-001 §4.1 y §4.4 describe la **futura** entrega adicional. No se adelanta una entrega ni se cambia ninguna FK para forzar un trigger imposible.

### 13.2. Matriz de invariantes y garantía física propuesta

| Invariante | Mecanismo / momento | Garantía y límite |
|---|---|---|
| Oferta nueva con precio exacto de origen y vigente a su instante | FKs V1 intactas; fn_uc07_oferta_guard BEFORE INSERT y contexto con reloj tras locks | P contra PRECIO_PRODUCTO.precioBase NUMERIC(18,4), pertenencia EXCEDENTE→DETALLE_PEDIDO→PRODUCTO, no cancelado y [desde,hasta), importe D2-A/ajuste congelado; no “precioBaseUnitario” inexistente |
| Contexto comercial inmutable y respuesta legítima | BEFORE UPDATE/DELETE oferta + ck_oferta_excedente_3 | No-op devuelve fila; PENDIENTE→ACEPTADA/RECHAZADA con campos coherentes; cerradas no reabren; sin revalidar vigencia actual al responder; legado según G |
| Oferta y única V1 atómicas | UNIQUE(oferta,numeroVersion); ct_uc07_oferta_final/cotizacion_final/contexto_final diferidos | Relectura final exige exactamente V1 igual al padre; no bloquea el INSERT inicial antes de insertar V1 |
| Versiones parciales, importe y código | CHECKs/UNIQUE existentes candidatos + cotizacion_guard | V1 total original; >=2 parciales con snapshot, no P2; sin UPDATE/DELETE ni estados comerciales nuevos |
| Evidencia pertenece a versión/oferta y confirma sus valores | FK compuesta ratificada B; checks y evidencia_guard | Igualdad cantidad/importe/tiempo, intento serializado, bytes/MIME declarados/detectados/huella inmutables |
| Intentos y evidencia utilizable | UNIQUE(oferta,intento), CHECK positivo, lock padre; uq_evidencia_utilizable_por_oferta | Rechazo previo/replay no consumen; INVALIDADA conserva número; como máximo una fila en la unión VERIFICADA/UTILIZADA |
| Máquina de estados y ambos eventos O2 | BEFORE evidencia, AFTER emisor, BEFORE evento invoker y diferidos estado_evento | NULL→CAPTURADA y CAPTURADA→VERIFICADA; terminales; cadena consecutiva y último evento=estado final; fallo de auditoría revierte transición |
| Antifalsificación de eventos | Sin INSERT de runtime/gateway, AFTER SECURITY DEFINER owner y BEFORE evento SECURITY INVOKER | Actor/motivo del canal controlado; no GUC/pg_trigger_depth como autenticación; no prueba identidad de cliente/WhatsApp ni posesión de Bearer |
| Recibo ligado al efecto nuevo y misma transacción | Contexto privado, comando_guard y contexto_final diferido | Operación/ámbito/actor/huella/clave/recurso coinciden; JSON mínimo generado desde efecto; sin huérfanos ni reserva PENDIENTE; inmutable tras commit |
| F6-A: aceptación/stock/costo | movimiento_guard/registro privado de transferencia, saldo guard y diferidos oferta/evidencia/movimiento/contexto | Cantidad/costo proporcionales, saldo atómico y prueba histórica inmutable; no compara saldo de una aceptación vieja con el saldo de descartes futuros |
| F6-B: entrega/imputación | FKs y uq_imputacion_entrega_adicional_0 de V1; imputacion_guard + entrega_diferida | Receptor/producto/movimiento, cantidad parcial y orden cronológico; no doble imputación; costo/finanzas completos de UC05 no se certifican por este subgrafo |
| Historia después de aceptar | Guardias de evidencia, movimiento, imputación, detalle, pedido, precio y producto | No se depende solo de UPDATE OF respuesta; protege relaciones y datos ya usados sin congelar toda modificación del maestro |
| UC19 y UC48 compatibles | Guardias selectivas precio/producto | Permite cierre prospectivo que preserve fechaHoraOferta y cambio activo/nombre; no borra historia ni salta veto V1 a línea técnica inactiva |
| Escritores no cooperantes bajo rol runtime | REVOKE DML y EXECUTE sensible; owner/gateway separados | Runtime no puede insertar eventos/recibos ni modificar historia; escritores con credencial gateway forman parte del límite confiable pendiente F8 |
| Históricos | Preflight y registro privado certificado, o ruta NOT NULL uniforme | Ningún precio inventado ni fallback por datos; nuevos INSERT completos; rutas no elegidas en C2 |

### 13.3. Catálogo de objetos nuevos y existentes

**Preexistentes, conservados:** fk_oferta_excedente_0/1/2, ck_oferta_excedente_3, EXCLUDE de precios, fk_excedente_0/1, uq_movimiento_excedente_0, ck_movimiento_excedente_0/3, uq_imputacion_entrega_adicional_0 y fk_imputacion_entrega_adicional_0/1, FKs ENTREGA/DETALLE_ENTREGA, uq_detalle_pedido_0 y ck_detalle_pedido_3. No se renumeran ni sustituyen. El nombre nuevo fk_oferta_excedente_precio no colisiona con _2 del vendedor.

**Nuevos propuestos:** columnas snapshot, tablas/PK/FK/UNIQUE/CHECK de §15.1–15.5, índice parcial conjunto, schema uc07_privado con contexto_tx/transferencia/legado_oferta y los catálogos de funciones/triggers de abajo. Estos registros privados adicionales requieren revisión del alcance físico: contexto evita GUC manipulable; transferencia conserva saldo/costo anterior; legado identifica excepciones aprobadas sin dar permiso general. No estaban en V1 ni quedan autorizados.

**Funciones nuevas propuestas (25; 22 PL/pgSQL y 3 SQL):**

| Función pública candidata | Lenguaje / privilegio | Cuerpo |
|---|---|---|
| fn_uc07_contexto | plpgsql / SECURITY DEFINER | §15.6 |
| fn_uc07_actor | plpgsql / SECURITY DEFINER | §15.6 |
| fn_uc07_abrir_contexto | plpgsql / SECURITY DEFINER | §15.6 |
| fn_uc07_importe | plpgsql / SECURITY INVOKER | §15.6 |
| fn_uc07_campo | sql / SECURITY INVOKER | §15.6 |
| fn_uc07_huella_cotizacion | sql / SECURITY INVOKER | §15.6 |
| fn_uc07_huella_evidencia | sql / SECURITY INVOKER | §15.6 |
| fn_uc07_oferta_guard | plpgsql / SECURITY DEFINER | §15.7 |
| fn_uc07_cotizacion_guard | plpgsql / SECURITY DEFINER | §15.7 |
| fn_uc07_evidencia_guard | plpgsql / SECURITY DEFINER | §15.7 |
| fn_uc07_evento_guard | plpgsql / SECURITY INVOKER | §15.8 |
| fn_uc07_emitir_evento | plpgsql / SECURITY DEFINER | §15.8 |
| fn_uc07_estado_evento_final | plpgsql / SECURITY DEFINER | §15.8 |
| fn_uc07_movimiento_guard | plpgsql / SECURITY DEFINER | §15.9 |
| fn_uc07_registrar_transferencia | plpgsql / SECURITY DEFINER | §15.9 |
| fn_uc07_inmutable | plpgsql / SECURITY INVOKER | §15.9 |
| fn_uc07_excedente_guard | plpgsql / SECURITY DEFINER | §15.9 |
| fn_uc07_validar_oferta | plpgsql / SECURITY DEFINER | §15.9 |
| fn_uc07_oferta_diferida | plpgsql / SECURITY DEFINER | §15.9 |
| fn_uc07_imputacion_guard | plpgsql / SECURITY DEFINER | §15.10 |
| fn_uc07_validar_entrega | plpgsql / SECURITY DEFINER | §15.10 |
| fn_uc07_entrega_diferida | plpgsql / SECURITY DEFINER | §15.10 |
| fn_uc07_comando_guard | plpgsql / SECURITY DEFINER | §15.11 |
| fn_uc07_contexto_final | plpgsql / SECURITY DEFINER | §15.11 |
| fn_uc07_padre_guard | plpgsql / SECURITY DEFINER | §15.12 |

**Triggers nuevos propuestos (27; 10 constraint triggers diferidos):** Todos FOR EACH ROW.

| Trigger | Tabla | Momento / evento | Función |
|---|---|---|---|
| tg_uc07_oferta_guard | public."OFERTA_EXCEDENTE" | BEFORE INSERT OR UPDATE OR DELETE | fn_uc07_oferta_guard |
| tg_uc07_cotizacion_guard | public."COTIZACION_OFERTA_EXCEDENTE" | BEFORE INSERT OR UPDATE OR DELETE | fn_uc07_cotizacion_guard |
| tg_uc07_evidencia_guard | public."EVIDENCIA_ACEPTACION_OFERTA" | BEFORE INSERT OR UPDATE OR DELETE | fn_uc07_evidencia_guard |
| tg_uc07_evento_guard | public."EVENTO_ESTADO_EVIDENCIA_OFERTA" | BEFORE INSERT OR UPDATE OR DELETE | fn_uc07_evento_guard |
| tg_uc07_emitir_evento | public."EVIDENCIA_ACEPTACION_OFERTA" | AFTER INSERT OR UPDATE | fn_uc07_emitir_evento |
| ct_uc07_estado_evento | public."EVIDENCIA_ACEPTACION_OFERTA" | AFTER INSERT OR UPDATE; DEFERRABLE INITIALLY DEFERRED | fn_uc07_estado_evento_final |
| ct_uc07_evento_estado | public."EVENTO_ESTADO_EVIDENCIA_OFERTA" | AFTER INSERT; DEFERRABLE INITIALLY DEFERRED | fn_uc07_estado_evento_final |
| tg_uc07_movimiento_guard | public."MOVIMIENTO_EXCEDENTE" | BEFORE INSERT OR UPDATE OR DELETE | fn_uc07_movimiento_guard |
| tg_uc07_registrar_transferencia | public."MOVIMIENTO_EXCEDENTE" | AFTER INSERT | fn_uc07_registrar_transferencia |
| tg_uc07_transferencia_inmutable | uc07_privado.transferencia | BEFORE UPDATE OR DELETE | fn_uc07_inmutable |
| tg_uc07_excedente_guard | public."EXCEDENTE" | BEFORE UPDATE OR DELETE | fn_uc07_excedente_guard |
| ct_uc07_oferta_final | public."OFERTA_EXCEDENTE" | AFTER INSERT OR UPDATE; DEFERRABLE INITIALLY DEFERRED | fn_uc07_oferta_diferida |
| ct_uc07_cotizacion_final | public."COTIZACION_OFERTA_EXCEDENTE" | AFTER INSERT; DEFERRABLE INITIALLY DEFERRED | fn_uc07_oferta_diferida |
| ct_uc07_evidencia_aceptacion | public."EVIDENCIA_ACEPTACION_OFERTA" | AFTER INSERT OR UPDATE; DEFERRABLE INITIALLY DEFERRED | fn_uc07_oferta_diferida |
| ct_uc07_movimiento_aceptacion | public."MOVIMIENTO_EXCEDENTE" | AFTER INSERT; DEFERRABLE INITIALLY DEFERRED | fn_uc07_oferta_diferida |
| tg_uc07_imputacion_guard | public."IMPUTACION_ENTREGA_ADICIONAL" | BEFORE INSERT OR UPDATE OR DELETE | fn_uc07_imputacion_guard |
| ct_uc07_imputacion_final | public."IMPUTACION_ENTREGA_ADICIONAL" | AFTER INSERT; DEFERRABLE INITIALLY DEFERRED | fn_uc07_entrega_diferida |
| ct_uc07_detalle_entrega_final | public."DETALLE_ENTREGA" | AFTER INSERT OR UPDATE OR DELETE; DEFERRABLE INITIALLY DEFERRED | fn_uc07_entrega_diferida |
| ct_uc07_entrega_final | public."ENTREGA" | AFTER INSERT OR UPDATE OR DELETE; DEFERRABLE INITIALLY DEFERRED | fn_uc07_entrega_diferida |
| tg_uc07_comando_guard | public."COMANDO_AUXILIAR_UC07" | BEFORE INSERT OR UPDATE OR DELETE | fn_uc07_comando_guard |
| ct_uc07_contexto_final | uc07_privado.contexto_tx | AFTER INSERT; DEFERRABLE INITIALLY DEFERRED | fn_uc07_contexto_final |
| tg_uc07_precio_padre | public."PRECIO_PRODUCTO" | BEFORE UPDATE OR DELETE | fn_uc07_padre_guard |
| tg_uc07_pedido_padre | public."PEDIDO" | BEFORE UPDATE OR DELETE | fn_uc07_padre_guard |
| tg_uc07_detalle_padre | public."DETALLE_PEDIDO" | BEFORE INSERT OR UPDATE OR DELETE | fn_uc07_padre_guard |
| tg_uc07_producto_padre | public."PRODUCTO" | BEFORE UPDATE OR DELETE | fn_uc07_padre_guard |
| tg_uc07_entrega_guard | public."ENTREGA" | BEFORE INSERT OR UPDATE OR DELETE | fn_uc07_padre_guard |
| tg_uc07_detalle_entrega_guard | public."DETALLE_ENTREGA" | BEFORE INSERT OR UPDATE OR DELETE | fn_uc07_padre_guard |

### 13.4. Secuencias, dependencias y estados intermedios

Orden de definición: roles → ruta snapshot aprobada → cotización/UNIQUE → evidencia/FK → eventos/identidad → comandos → esquema privado/tablas → helpers/contexto/aritmética → guardias/emisor → validadores F6-A/F6-B → constraint triggers diferidos → ownership/ACL → pruebas C3. Las escrituras permanecen pausadas hasta completar todas las dependencias. El bloque de ACL contiene una parte de provisión previa y otra posterior; no se ejecuta linealmente antes de sus tablas.

Parte A inserta oferta y V1, y el constraint diferido exige ambas al commit. O2 valida previamente contenido en Java, abre contexto, invalida la VERIFICADA anterior cuando corresponde, inserta CAPTURADA (evento inicial), transiciona a VERIFICADA (segundo evento) y confirma efecto/recibo juntos. El índice conjunto obliga a invalidar anterior antes de verificar la nueva; fallo restaura todo. No se pospone sustitución hasta Parte B.

Parte B puede crear/reutilizar DETALLE_PEDIDO técnico, escribir movimiento/descontar saldo, pasar evidencia a UTILIZADA y actualizar respuesta en el orden que satisfaga FKs y locks; los diferidos verifican estado final releyendo relaciones. No se inventa DETALLE_ENTREGA en ese flujo. UC05 crea ENTREGA antes de DETALLE_ENTREGA y luego IMPUTACION_ENTREGA_ADICIONAL, conforme FKs inmediatas V1; el control final permite varias sentencias válidas sin exigir estados finales prematuros.

El candidato limita un contexto comercial por transacción (una oferta/comando o un descarte; UC05 admite sus múltiples imputaciones). Batch comercial distinto necesita protocolo explícito posterior, sin reutilizar contexto/actor para otros ámbitos. Los generadores BIGINT de otros escritores y el namespace candidato 70702 de comando no están ratificados: inventario/reserva y pruebas corresponden a H/C3. El candidato no genera IDs MAX+1 sin coordinación.

### 13.5. Comportamiento histórico y mantenimiento

UPDATE oferta sin cambio real no altera historia ni respuesta. Si ya está ACEPTADA/RECHAZADA, cualquier cambio real se rechaza; no se reabre. Condiciones comerciales originales quedan inmutables, pero la respuesta puede evolucionar legítimamente desde PENDIENTE, conservando ck_oferta_excedente_3. La legitimidad del precio se valida al crear y se preserva con guardias de procedencia; no se exige que siga vigente hoy.

No hay excepción cotidiana de DELETE para un rol amplio. Owner/migrador separado puede hacer mantenimiento excepcional con autorización, motivo, respaldo y auditoría; no se promete resistencia contra propietario/superusuario. Retención/anonimización de D/E y de los nuevos registros privados requiere plan aprobado sin reciclar claves o destruir prueba de aceptación.

### 13.6. F8 — confianza Java/SQL y bloqueo explícito

| Canal / rol candidato | Acceso propuesto | Identidad realmente garantizada |
|---|---|---|
| uc07_runtime | Sin DML/EXECUTE UC07 sensible; solo proyecciones BC07 aprobadas aparte | No puede forjar contexto, eventos o recibos mediante SQL directo |
| uc07_gateway | Pool privilegiado solo del módulo autorizado; EXECUTE abrir_contexto y DML acotado con triggers | DB valida sesión declarada vigente/rol y ámbito estructural; **no valida posesión del Bearer** |
| uc07_owner | NOLOGIN; owner de funciones/nuevas tablas; sin membresía operativa | Emisor técnico de eventos y guardias; no identidad humana |
| Migrador/administrador | Provisionamiento/mantenimiento separado y auditado | Fuera del adversario operativo; nunca credencial diaria del servicio |

**Bloqueo de autorización F8:** la aplicación actual no tiene esta separación de pools/roles configurada por estas CR. El actor obtenido por idSesion sigue siendo una **afirmación del gateway tras autenticar Bearer en Spring**, no prueba criptográfica de PostgreSQL. Un escritor que posea esa misma credencial gateway y otra sesión válida podría atribuirse el actor; no se oculta este límite. Comprobar vigencia/rol SQL no equivale a autenticar token, y ningún idUsuario/GUC resuelve el puente.

Alternativas para decisión: (a) gateway Java confiable aislado, runtime sin credencial ni DML, auditoría de acceso y aceptación expresa de ese límite —preferencia compatible con el monolito actual—; (b) SQL verifica Bearer o capacidad firmada con protocolo seguro y pruebas de revocación/ámbito —mayor alcance, no implementado—; (c) roles SQL por principal —implica otra estrategia de pool/identidad—. Deben decidirse custodia de credenciales, ACL efectivas y autorización por objeto antes de autorizar F. No se concede automáticamente un permiso por ser ADMIN ni se declara probado el aislamiento de JVM/pools.

Java conserva: autenticación Bearer, ámbito comercial, prevalidación E (decodificación/recursos), exactitud de entrada antes de typmod, DTO/no-store y reautorización en replay. PostgreSQL propone: relaciones, snapshot consistente, inmutabilidad, cadena causal, hash físico, cantidades/importes persistidos, unicidad y atomicidad final. C3 debe demostrar la frontera con conexiones de roles reales, sin asumir que el usuario propietario de laboratorio representa al runtime.


## 14. G — preflight real y migración determinista candidata

**G ESPECIFICADA PARA REVISIÓN/RATIFICACIÓN — NO RATIFICADA.** C2 no ejecuta preflight de destinos ni elige ruta. V1–V3 al SHA app 4dbe386 no contienen idPrecio/precioBaseUnitarioAplicado en OFERTA_EXCEDENTE. Su ausencia se distingue de una fila con snapshot NULL: no puede consultarse una columna inexistente.

### 14.1. Fase administrativa, solo con autorización del destino

Registrar entorno/base, servidor, fecha, esquema efectivo, versión/checksums Flyway, extensiones, propietarios/ACL, escritores, respaldo y restauración. El ejemplo usa public según las fuentes examinadas; otro esquema exige adaptar y revisar explícitamente todas las referencias.

**CONSULTAS CANDIDATAS DE SOLO LECTURA — NO EJECUTADAS EN C2.** Antes de ejecutarlas en un destino persistente se requiere autorización administrativa específica.

~~~sql
BEGIN TRANSACTION READ ONLY;
SELECT current_database(),current_schema(),version(),clock_timestamp();
SELECT to_regclass('public."OFERTA_EXCEDENTE"') AS oferta,
       to_regclass('public.flyway_schema_history') AS historial_flyway,
       to_regprocedure('pg_catalog.sha256(bytea)') AS sha256_integrada;
SELECT column_name,data_type,is_nullable,numeric_precision,numeric_scale
FROM information_schema.columns
WHERE table_schema='public' AND table_name='OFERTA_EXCEDENTE'
ORDER BY ordinal_position;
-- Continuar solo si existe la tabla esperada; no crearla desde el preflight.
SELECT count(*) AS total FROM public."OFERTA_EXCEDENTE";
SELECT "respuesta",count(*) AS total FROM public."OFERTA_EXCEDENTE"
GROUP BY "respuesta" ORDER BY "respuesta";
SELECT count(*) AS referencias_incompletas
FROM public."OFERTA_EXCEDENTE" o
LEFT JOIN public."EXCEDENTE" x ON x."idExcedente"=o."idExcedente"
LEFT JOIN public."PEDIDO" p ON p."idPedido"=o."idPedidoReceptor"
LEFT JOIN public."USUARIO" u ON u."idUsuario"=o."idUsuarioVendedor"
WHERE x."idExcedente" IS NULL OR p."idPedido" IS NULL OR u."idUsuario" IS NULL;
SELECT conname,convalidated,pg_get_constraintdef(oid)
FROM pg_constraint WHERE conrelid='public."OFERTA_EXCEDENTE"'::regclass
ORDER BY conname;
DO $inventario$
DECLARE n integer; vacios bigint; filas record;
BEGIN
  IF to_regclass('public.flyway_schema_history') IS NULL THEN
    RAISE EXCEPTION 'Falta historial Flyway esperado';
  END IF;
  FOR filas IN EXECUTE
    'SELECT version,description,checksum,success FROM public.flyway_schema_history ORDER BY installed_rank'
  LOOP RAISE NOTICE 'Flyway: %',row_to_json(filas); END LOOP;
  SELECT count(*) INTO n FROM information_schema.columns
    WHERE table_schema='public' AND table_name='OFERTA_EXCEDENTE'
      AND column_name IN ('idPrecio','precioBaseUnitarioAplicado');
  IF n=0 THEN
    RAISE NOTICE 'Esquema V1-V3: columnas snapshot AUSENTES; no consultar sus nulos';
  ELSIF n=2 THEN
    EXECUTE 'SELECT count(*) FROM public."OFERTA_EXCEDENTE"
      WHERE "idPrecio" IS NULL OR "precioBaseUnitarioAplicado" IS NULL' INTO vacios;
    RAISE NOTICE 'Extension encontrada; verificar su autorizacion y tipos. Filas sin snapshot: %',vacios;
  ELSE
    RAISE EXCEPTION 'Extension parcial inesperada: detener y revisar';
  END IF;
END;
$inventario$;
COMMIT;
~~~

Encontrar dos columnas no prueba que la extensión esté autorizada: cotejar migración/CR/versión y sus tipos/FKs antes de aceptarla. El conteo de nulos se usa solo tras comprobar existencia; no se incluye en el SELECT inicial de V1–V3. Los conteos de Git/fixtures no certifican un destino vacío. Registrar los resultados y recomendar una ruta; no seleccionarla por IF que altere el esquema final.

### 14.2. Fase posterior: ruta vacía determinista con exclusión de escritores

**EJEMPLO DE MIGRACIÓN CANDIDATA — NO AUTORIZADA — NO EJECUTAR EN BASES PERSISTENTES.** Este bloque sustituiría §15.1, no se concatena con su alternativa nullable. Solo tras certificar vacío y autorizar esa ruta; no reservar V4. Flyway/PostgreSQL debe mantener estas sentencias en una única transacción (executeInTransaction=true), sin COMMIT intermedio.

~~~sql
LOCK TABLE public."OFERTA_EXCEDENTE" IN ACCESS EXCLUSIVE MODE;
DO $vacia$
BEGIN
  IF EXISTS(SELECT 1 FROM public."OFERTA_EXCEDENTE") THEN
    RAISE EXCEPTION 'Precondicion vacia incumplida: abortar, no cambiar de ruta';
  END IF;
END;
$vacia$;
ALTER TABLE public."OFERTA_EXCEDENTE"
  ADD COLUMN "idPrecio" bigint NOT NULL,
  ADD COLUMN "precioBaseUnitarioAplicado" numeric(18,4) NOT NULL,
  ADD CONSTRAINT fk_oferta_excedente_precio
    FOREIGN KEY ("idPrecio") REFERENCES public."PRECIO_PRODUCTO" ("idPrecio")
    ON UPDATE RESTRICT ON DELETE RESTRICT,
  ADD CONSTRAINT ck_oferta_snapshot_positivo CHECK ("precioBaseUnitarioAplicado">0);
~~~

ACCESS EXCLUSIVE se adquiere **antes** de la aserción y se conserva durante ALTER/instalación hasta commit; impide INSERT entre conteo y cambio. Puede bloquear lecturas y escritores: no se promete cero downtime. Si aparecen filas, conflicto de nombres o esquema extendido inesperado, rollback completo y decisión administrativa; no fallback automático a nullable. Se preservan ck_oferta_excedente_3 y fk_oferta_excedente_0/1/2; la nueva FK no reutiliza _2.

### 14.3. Históricos: detener la ruta vacía y decidir tratamiento específico

No fabricar precio/idPrecio por división ni por precio actual; no alterar ofertas ACEPTADA/RECHAZADA ni rechazar masivamente pendientes. Preservar relaciones, movimientos e importes legítimos. La política y fuentes para regularización/aceptación histórica requieren aprobación del responsable.

**Alternativa uniforme, NO elegida:** columnas nullable en todos los destinos de esa versión, par completo/ausente y FK/positivo de §15.1; registro protegido uc07_privado.legado_oferta cargado solo por el migrador desde inventario aprobado. La lista certifica IDs y contexto original tras agregar columnas; no se llena automáticamente con “cualquier NULL” que aparezca. Runtime/gateway no pueden añadir o modificar marcas. El mismo esquema objetivo y los mismos guards se aplican a todos los destinos: solo difieren las filas del inventario autorizado, no el DDL de una versión Flyway.

Las guardias F rechazan nuevos INSERT sin snapshot; solo legado certificado puede conservar ambos NULL. UPDATE no-op no cambia historia; pendientes certificados pueden cerrarse por rechazo legítimo según política, sin exigir retroactivamente idPrecio; aceptación sin procedencia demostrada sigue bloqueada. Ofertas ya cerradas no se reabren/reinterpretan para generar evidencia retroactiva. Los chequeos diferidos nuevos no obligan a reconstruir V1/evidencia inexistentes del legado certificado; tampoco convierten esa excepción en habilitación de nuevas ofertas incompletas. UC05 legado, en especial entrega parcial sin P, necesita política comercial explícita antes de habilitar ese caso.

CHECK NOT VALID omite el escaneo inicial pero valida cada INSERT/UPDATE posterior: no se usa un CHECK no nulo global que bloquee el cierre legítimo de filas antiguas. Una regularización debe conservar fuentes, aprobación y auditoría, sin actualizar silenciosamente snapshot inmutable. Las rutas vacía y legado requieren planes/versiones aprobados y coherentes; una misma migración no produce esquemas distintos según la presencia de datos.

### 14.4. Dependencias, rollout, disponibilidad y recuperación

1. Inventario real y política aprobada, verificación de nombres/funciones/ACL/extensiones.
2. Pausa coordinada de escritores incompatibles; bloqueo de tabla en la migración elegida.
3. Snapshot de oferta y protecciones iniciales, preservando V1/V2/V3.
4. Cotizaciones y UNIQUE(oferta,idCotizacion)/versión.
5. Evidencias, FK compuesta e índice único parcial conjunto.
6. Eventos/identidad y control causal.
7. Comandos/recibos; esquema privado, contexto y prueba histórica de transferencia.
8. Guardias y constraint triggers diferidos sobre oferta, evidencia, movimientos, entrega e imputación.
9. Owner/roles/grants mínimos; sin ventana operativa con funciones PUBLIC ni triggers desactivados.
10. Compilación y pruebas descartables PostgreSQL 17.11/Testcontainers, incluyendo cuerpos F e intercalados H.
11. Backup/restore y forward-fix ensayados, conteos/huellas/referencias y medición de locks/espacio/duración.
12. Autorización posterior de integración y, separadamente, despliegue.

Los roles se provisionan antes de funciones SECURITY DEFINER; no reabrir escritores hasta instalar dependencias, validaciones diferidas y ACL. Las funciones que consultan tablas nuevas se crean después de ellas; §15.6–15.13 se instalan con escritura pausada. Rollback de código no borra evidencia; no editar checksums ni reaplicar migraciones a ciegas. El plan debe evaluar pérdida de escrituras posteriores ante restauración. C2 no elige ruta, no consulta bases destino, no crea migración ni levanta Issue #28.


## 15. DDL candidato consolidado y decisiones abiertas

**PROPUESTA SQL — NO ES MIGRACIÓN AUTORIZADA — NO EJECUTAR EN BASES PERSISTENTES.** Solo bloques Markdown: §15.1–15.5 estructuras candidatas y §15.6–15.13 cuerpos de funciones, triggers, controles diferidos y ACL. **REVISADO ESTÁTICAMENTE / COMPILACIÓN Y COMPORTAMIENTO NO PROBADOS.** Tipos/FK B e intento C ratificados no autorizan D/E/F/G/H ni esta migración. El orden administrativo de roles y dependencias se explica en §13.4/§14.4; alternativas §14/§15.1 no se ejecutan juntas. F8 y revisión C3 siguen bloqueando la autorización integral.

### 15.1. Extensión de oferta, compatible con auditoría de históricos

```sql
-- PROPUESTA DOCUMENTAL. NO EJECUTAR.
-- Alternativa uniforme nullable para legado: NO elegida en C1 ni C2.
-- La ruta vacía NOT NULL de §14.2 sustituye este bloque; nunca aplicar ambas.
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

No cambiar fk_oferta_excedente_2 ni ck_oferta_excedente_3. NULL histórico no habilita INSERT incompleto: §15.7 exige snapshot nuevo, permite solo rechazo legítimo/no-op de legado certificado y bloquea aceptación sin procedencia. §14 distingue las rutas uniformes nullable/NOT NULL y sus precondiciones; ninguna se elige ni autoriza en C2. No emplear CHECK NOT VALID global no nulo ni IF por datos que cambie el esquema.

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

Tipo UUID de idComandoAuxiliar está RATIFICADO B; resto de D es ESPECIFICADO PARA RATIFICACIÓN. Clave antes TEXT pasa a VARCHAR(128) COLLATE "C" y CHECK ASCII de §10, preservando igualdad exacta de clave en UNIQUE; HTTP y función SQL validan original antes de cast/truncamiento. respuestaOriginal JSONB NOT NULL es nombre único, sin reciboOriginalJson. Validar esquema mínimo y vínculo/recibo con efecto: JSONB objeto no basta ni admite datos sensibles. Sin TTL/purga online ni PENDIENTE confirmado en MVP candidato. Canonización UTF-8, retención y errores exactos en §10; cuerpos y ACL candidatos en §15.6–15.13, sin ejecutar este fragmento ni ratificar D.

### 15.6. Dependencias privadas, contexto y aritmética candidatos

**PROPUESTA SQL — NO ES MIGRACIÓN AUTORIZADA — NO EJECUTAR EN BASES PERSISTENTES. REVISADO ESTÁTICAMENTE / COMPILACIÓN Y COMPORTAMIENTO NO PROBADOS.**

Los roles se provisionan antes según §13.6; los objetos de §15.2–15.5 y las columnas snapshot deben existir. El esquema privado y los tres registros siguientes son **objetos nuevos propuestos**, no columnas de V1. Justificación: contexto no falsificable por el runtime y prueba histórica del saldo/costo al transferir; sin ellos no se confunde un saldo posterior con el de una aceptación anterior. Ninguna ruta G se elige en C2.

~~~sql
CREATE SCHEMA uc07_privado AUTHORIZATION uc07_owner;

CREATE TABLE uc07_privado.contexto_tx (
  xid xid8 PRIMARY KEY, pid integer NOT NULL,
  sesion uuid NOT NULL, actor bigint NOT NULL, operacion text NOT NULL,
  oferta bigint, pedido bigint, excedente bigint, comando uuid,
  clave varchar(128) COLLATE "C", huella char(64),
  instante timestamptz NOT NULL,
  cantidad_antes numeric(18,3), costo_antes numeric(18,4),
  cotizacion_nueva uuid, evidencia_nueva uuid, movimiento_nuevo bigint,
  replay boolean NOT NULL
);
CREATE TABLE uc07_privado.transferencia (
  "idMovimientoExcedente" bigint PRIMARY KEY
    REFERENCES public."MOVIMIENTO_EXCEDENTE" ("idMovimientoExcedente")
    ON UPDATE RESTRICT ON DELETE RESTRICT,
  xid xid8 NOT NULL,
  cantidad_antes numeric(18,3) NOT NULL,
  costo_antes numeric(18,4) NOT NULL,
  cantidad_despues numeric(18,3) NOT NULL,
  costo_despues numeric(18,4) NOT NULL,
  CHECK (cantidad_antes>0 AND cantidad_despues>=0 AND costo_antes>=0 AND costo_despues>=0)
);
CREATE TABLE uc07_privado.legado_oferta (
  "idOfertaExcedente" bigint PRIMARY KEY
    REFERENCES public."OFERTA_EXCEDENTE" ("idOfertaExcedente")
    ON UPDATE RESTRICT ON DELETE RESTRICT,
  fila_certificada jsonb NOT NULL, referencia_preflight text NOT NULL
);
-- legado_oferta queda vacío en la ruta vacía; solo el migrador puede
-- cargarlo en una ruta de legado aprobada. No es una excepción por GUC/rol.
-- contexto_tx no guarda Bearer ni contenido; retención/depuración administrativa
-- separada y pendiente, sin cambiar la retención D de recibos.

CREATE FUNCTION public.fn_uc07_contexto(p_escritura boolean DEFAULT true)
RETURNS uc07_privado.contexto_tx LANGUAGE plpgsql SECURITY DEFINER
SET search_path=pg_catalog AS $fn$
DECLARE c uc07_privado.contexto_tx;
BEGIN
  SELECT * INTO c FROM uc07_privado.contexto_tx
    WHERE xid=pg_current_xact_id() AND pid=pg_backend_pid();
  IF NOT FOUND OR (p_escritura AND c.replay) THEN
    RAISE EXCEPTION 'Contexto UC07 ausente o de solo replay' USING ERRCODE='42501';
  END IF;
  RETURN c;
END;
$fn$;

CREATE FUNCTION public.fn_uc07_actor(p_sesion uuid,p_op text)
RETURNS bigint LANGUAGE plpgsql SECURITY DEFINER SET search_path=pg_catalog AS $fn$
DECLARE a bigint; rol text;
BEGIN
  rol:=CASE p_op WHEN 'UC05' THEN 'REPARTIDOR'
                WHEN 'UC41' THEN 'RESPONSABLE_PRODUCCION'
                ELSE 'VENDEDOR' END;
  SELECT u."idUsuario" INTO a
    FROM public."SESION_USUARIO" s JOIN public."USUARIO" u USING ("idUsuario")
    JOIN public."USUARIO_ROL" r USING ("idUsuario")
    WHERE s."idSesionUsuario"=p_sesion
      AND s."fechaHoraInicio"<=clock_timestamp()
      AND s."fechaHoraExpiracion">clock_timestamp()
      AND s."fechaHoraInicio"+interval '8 hours'>clock_timestamp()
      AND s."fechaHoraRevocacion" IS NULL
      AND u."estado"='HABILITADO' AND NOT u."cambioCredencialPendiente"
      AND r."codigoRol"=rol;
  IF NOT FOUND THEN RAISE EXCEPTION 'Sesion o rol no vigente' USING ERRCODE='42501'; END IF;
  RETURN a;
END;
$fn$;
-- Esta función valida vigencia/rol de una SESION, NO la posesión del Bearer.
-- F8 deja ese control en Spring y bloquea atribuirle autenticación SQL autónoma.

CREATE FUNCTION public.fn_uc07_abrir_contexto(
  p_sesion uuid,p_op text,p_oferta bigint,p_pedido bigint,p_excedente bigint,
  p_comando uuid DEFAULT NULL,p_clave text DEFAULT NULL,p_huella text DEFAULT NULL
) RETURNS boolean LANGUAGE plpgsql SECURITY DEFINER SET search_path=pg_catalog AS $fn$
DECLARE a bigint; receptor bigint; ex bigint; origen bigint; producto bigint;
        q numeric; costo numeric; ids bigint[]; anterior public."COMANDO_AUXILIAR_UC07"%ROWTYPE;
        op_aux text; es_replay boolean:=false; o public."OFERTA_EXCEDENTE"%ROWTYPE;
BEGIN
  IF session_user<>'uc07_gateway' THEN
    RAISE EXCEPTION 'Canal SQL no autorizado' USING ERRCODE='42501';
  END IF;
  IF p_op NOT IN ('PARTE_A','O1','O2','PARTE_B','RECHAZO','UC05','UC41') THEN
    RAISE EXCEPTION 'Operacion no admitida' USING ERRCODE='22023';
  END IF;
  a:=public.fn_uc07_actor(p_sesion,p_op);
  IF p_op IN ('O1','O2') THEN
    IF p_comando IS NULL OR p_clave IS NULL
       OR p_clave COLLATE "C" !~ '^[!-~]{1,128}$'
       OR p_huella IS NULL OR p_huella !~ '^[0-9a-f]{64}$' THEN
      RAISE EXCEPTION 'Identidad de comando invalida' USING ERRCODE='22023';
    END IF;
    op_aux:=CASE p_op WHEN 'O1' THEN 'EMITIR_COTIZACION' ELSE 'REGISTRAR_EVIDENCIA' END;
    -- Namespace 70702 candidato NUEVO, pendiente inventario/ratificación H.
    -- hashtext solo coordina; UNIQUE y comparación completa deciden identidad.
    PERFORM pg_advisory_xact_lock(70702,
      hashtext(jsonb_build_array(op_aux,p_oferta,a,p_clave)::text));
    SELECT * INTO anterior FROM public."COMANDO_AUXILIAR_UC07"
      WHERE "operacion"=op_aux AND "idOfertaExcedente"=p_oferta
        AND "idUsuarioVendedor"=a AND "claveIdempotencia"=p_clave;
    IF FOUND THEN
      IF anterior."huellaSolicitud" IS DISTINCT FROM p_huella THEN
        RAISE EXCEPTION 'Payload distinto para clave existente' USING ERRCODE='23505';
      END IF;
      es_replay:=true;
    END IF;
  END IF;
  IF p_op IN ('O1','O2','PARTE_B','RECHAZO') THEN
    SELECT * INTO STRICT o FROM public."OFERTA_EXCEDENTE" WHERE "idOfertaExcedente"=p_oferta;
    receptor:=o."idPedidoReceptor"; ex:=o."idExcedente";
  ELSE receptor:=p_pedido; ex:=p_excedente;
  END IF;
  IF p_op='PARTE_A' AND (p_oferta IS NULL OR p_oferta<=0) THEN
    RAISE EXCEPTION 'Identificador de oferta no preparado' USING ERRCODE='22023';
  END IF;
  IF ex IS NOT NULL AND p_op IN ('PARTE_A','PARTE_B') THEN
    SELECT e."idPedidoOrigen",d."idProducto" INTO STRICT origen,producto
      FROM public."EXCEDENTE" e JOIN public."DETALLE_PEDIDO" d
      ON (d."idPedido",d."numeroDetalle")=(e."idPedidoOrigen",e."numeroDetalleOrigen")
      WHERE e."idExcedente"=ex;
  END IF;
  ids:=ARRAY(SELECT DISTINCT v FROM unnest(ARRAY[receptor,origen]) t(v)
             WHERE v IS NOT NULL ORDER BY v);
  -- Candidato de subgrafo, NO prueba de ausencia de deadlocks.
  PERFORM 1 FROM public."CLIENTE" c
    WHERE c."idCliente" IN (SELECT p."idCliente" FROM public."PEDIDO" p WHERE p."idPedido"=ANY(ids))
    ORDER BY c."idCliente" FOR UPDATE;
  PERFORM 1 FROM public."PEDIDO" p WHERE p."idPedido"=ANY(ids) ORDER BY p."idPedido" FOR UPDATE;
  IF p_op IN ('PARTE_A','PARTE_B','UC05') THEN
    PERFORM 1 FROM public."DETALLE_PEDIDO" d WHERE d."idPedido"=ANY(ids)
      ORDER BY d."idPedido",d."numeroDetalle" FOR UPDATE;
  END IF;
  IF ex IS NOT NULL AND p_op IN ('PARTE_A','PARTE_B','UC41') THEN
    SELECT "cantidadDisponible","costoHistoricoDisponible" INTO STRICT q,costo
      FROM public."EXCEDENTE" WHERE "idExcedente"=ex FOR UPDATE;
  END IF;
  IF p_op='PARTE_A' OR (p_op='PARTE_B' AND NOT EXISTS(
      SELECT 1 FROM public."DETALLE_PEDIDO" WHERE "idPedido"=receptor AND "idProducto"=producto)) THEN
    PERFORM 1 FROM public."PRODUCTO" WHERE "idProducto"=producto FOR SHARE;
  END IF;
  IF p_op='PARTE_A' THEN
    PERFORM 1 FROM public."PRECIO_PRODUCTO"
      WHERE "idProducto"=producto AND "fechaHoraCancelacion" IS NULL
      ORDER BY "vigenteDesde","idPrecio" FOR SHARE;
  END IF;
  IF p_op IN ('O1','O2','PARTE_B','RECHAZO') THEN
    PERFORM 1 FROM public."OFERTA_EXCEDENTE" WHERE "idOfertaExcedente"=p_oferta FOR UPDATE;
    IF NOT EXISTS (SELECT 1 FROM public."OFERTA_EXCEDENTE"
       WHERE "idOfertaExcedente"=p_oferta AND "idPedidoReceptor"=receptor AND "idExcedente"=ex) THEN
      RAISE EXCEPTION 'Raices cambiaron; replanificar transaccion' USING ERRCODE='40001';
    END IF;
  END IF;
  IF NOT es_replay AND p_op IN ('PARTE_A','O1','O2','PARTE_B','UC05')
     AND NOT EXISTS(SELECT 1 FROM public."PEDIDO" WHERE "idPedido"=receptor AND "estado"='PENDIENTE') THEN
    RAISE EXCEPTION 'Pedido no pendiente al abrir operacion' USING ERRCODE='23514';
  END IF;
  IF a IS DISTINCT FROM public.fn_uc07_actor(p_sesion,p_op) THEN
    RAISE EXCEPTION 'Autorizacion cambio tras espera' USING ERRCODE='42501';
  END IF;
  INSERT INTO uc07_privado.contexto_tx
    (xid,pid,sesion,actor,operacion,oferta,pedido,excedente,comando,clave,huella,
     instante,cantidad_antes,costo_antes,replay)
    VALUES(pg_current_xact_id(),pg_backend_pid(),p_sesion,a,p_op,p_oferta,receptor,ex,
      p_comando,p_clave,p_huella,clock_timestamp(),q,costo,es_replay);
  RETURN es_replay;
END;
$fn$;
-- Generadores BIGINT deben coordinarse ANTES de llamar esta función según H;
-- no genera IDs ni certifica los generadores futuros UC05/06/41.
-- UC05 requiere además asignación/stock/finanzas: fuera de esta función, C3.

CREATE FUNCTION public.fn_uc07_importe(p_q numeric,p_p numeric,p_tipo text,p_r numeric)
RETURNS numeric LANGUAGE plpgsql IMMUTABLE SET search_path=pg_catalog AS $fn$
DECLARE s numeric; a numeric; total numeric;
BEGIN
  IF p_q IS NULL OR p_q<=0 OR p_q<>round(p_q,3)
     OR p_q>999999999999999.999 OR p_p IS NULL OR p_p<=0
     OR p_tipo IS NULL OR p_tipo NOT IN ('SIN_AJUSTE','DESCUENTO','RECARGO')
     OR p_r IS NULL OR p_r<0 OR p_r>100 THEN
    RAISE EXCEPTION 'Parametros comerciales invalidos' USING ERRCODE='22023';
  END IF;
  s:=round(p_q*p_p,2); a:=round(s*p_r/100,2);
  total:=CASE p_tipo WHEN 'DESCUENTO' THEN s-a WHEN 'RECARGO' THEN s+a ELSE s END;
  IF total<=0 OR total>9999999999999999.99 THEN
    RAISE EXCEPTION 'Importe no representable' USING ERRCODE='22003';
  END IF;
  RETURN total;
END;
$fn$;
-- Para cantidades/precios positivos, round(numeric,2) da HALF_UP comercial.
-- Se utiliza numeric exacto, no double; D sigue validando antes de asignar typmod.

CREATE FUNCTION public.fn_uc07_campo(p_nombre text,p_valor text)
RETURNS text LANGUAGE sql IMMUTABLE SET search_path=pg_catalog AS $fn$
  SELECT octet_length(convert_to(p_nombre,'UTF8'))::text||':'||p_nombre||
    CASE WHEN p_valor IS NULL THEN 'N;'
      ELSE 'V'||octet_length(convert_to(p_valor,'UTF8'))::text||':'||p_valor||';' END
$fn$;

CREATE FUNCTION public.fn_uc07_huella_cotizacion(p_id uuid)
RETURNS text LANGUAGE sql STABLE SET search_path=pg_catalog AS $fn$
 SELECT encode(sha256(convert_to(
   E'UC07-IDEM/1\n'||
   public.fn_uc07_campo('operacion','EMITIR_COTIZACION')||
   public.fn_uc07_campo('idOfertaExcedente',c."idOfertaExcedente"::text)||
   public.fn_uc07_campo('cantidadCotizada',c."cantidadCotizada"::text),'UTF8')),'hex')
 FROM public."COTIZACION_OFERTA_EXCEDENTE" c WHERE c."idCotizacion"=p_id
$fn$;

CREATE FUNCTION public.fn_uc07_huella_evidencia(p_id uuid)
RETURNS text LANGUAGE sql STABLE SET search_path=pg_catalog AS $fn$
 SELECT encode(sha256(convert_to(
   E'UC07-IDEM/1\n'||
   public.fn_uc07_campo('operacion','REGISTRAR_EVIDENCIA')||
   public.fn_uc07_campo('idOfertaExcedente',e."idOfertaExcedente"::text)||
   public.fn_uc07_campo('idCotizacion',e."idCotizacion"::text)||
   public.fn_uc07_campo('cantidadConfirmada',e."cantidadConfirmada"::text)||
   public.fn_uc07_campo('importeConfirmado',e."importeConfirmado"::text)||
   public.fn_uc07_campo('canalComunicacion',e."canalComunicacion")||
   public.fn_uc07_campo('referenciaContacto',e."referenciaContacto")||
   public.fn_uc07_campo('fechaHoraMensaje',
     to_char(e."fechaHoraMensaje" AT TIME ZONE 'UTC','YYYY-MM-DD"T"HH24:MI:SS.US"Z"'))||
   public.fn_uc07_campo('tipoMimeContenido',e."tipoMimeContenido")||
   public.fn_uc07_campo('huellaContenido',e."huellaContenido"::text)||
   public.fn_uc07_campo('declaracionIdentidadVendedor',e."declaracionIdentidadVendedor"),
   'UTF8')),'hex')
 FROM public."EVIDENCIA_ACEPTACION_OFERTA" e WHERE e."idEvidencia"=p_id
$fn$;
~~~

sha256(bytea), encode y convert_to son funciones integradas de PostgreSQL 17; el candidato **no instala ni requiere pgcrypto** (V1 solo declara btree_gist). La disponibilidad y equivalencia de vectores con Java deben comprobarse en C3. El hash de archivo no decodifica imágenes. Metadatos/escala/instante exactos se validan en el adaptador antes de la coerción NUMERIC/TIMESTAMPTZ; el rol runtime no puede insertar filas para eludirlo. El rol gateway continúa siendo un límite de confianza (§13.6).


### 15.7. Guardias de oferta, cotización y evidencia

Las guardias leen el contexto protegido; no toman locks tardíos sobre raíces. Se presupone el subgrafo de §15.6 y se somete a C3. Excepción de legado únicamente por registro certificado privado de G, nunca por fecha/rol/GUC falsificable.

~~~sql
CREATE FUNCTION public.fn_uc07_oferta_guard()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path=pg_catalog AS $fn$
DECLARE c uc07_privado.contexto_tx; p public."PRECIO_PRODUCTO"%ROWTYPE;
  ped public."PEDIDO"%ROWTYPE; producto bigint; n integer;
BEGIN
  IF TG_OP='DELETE' THEN
    RAISE EXCEPTION 'Oferta historica no borrable' USING ERRCODE='23514';
  END IF;
  IF TG_OP='UPDATE' AND NEW IS NOT DISTINCT FROM OLD THEN RETURN NEW; END IF;
  c:=public.fn_uc07_contexto();
  IF NEW."idOfertaExcedente" IS DISTINCT FROM c.oferta THEN
    RAISE EXCEPTION 'Oferta fuera de contexto' USING ERRCODE='42501';
  END IF;
  IF TG_OP='UPDATE' THEN
    IF (to_jsonb(NEW)-ARRAY['respuesta','fechaHoraRespuesta','cantidadAceptada','importeAceptado'])
       IS DISTINCT FROM
       (to_jsonb(OLD)-ARRAY['respuesta','fechaHoraRespuesta','cantidadAceptada','importeAceptado']) THEN
      RAISE EXCEPTION 'Condiciones originales inmutables' USING ERRCODE='23514';
    END IF;
    IF OLD."respuesta"<>'PENDIENTE' OR
       NOT ((c.operacion='PARTE_B' AND NEW."respuesta"='ACEPTADA') OR
            (c.operacion='RECHAZO' AND NEW."respuesta"='RECHAZADA')) THEN
      RAISE EXCEPTION 'Respuesta terminal o reapertura' USING ERRCODE='23514';
    END IF;
    IF OLD."idPrecio" IS NULL OR OLD."precioBaseUnitarioAplicado" IS NULL THEN
      IF NEW."respuesta"<>'RECHAZADA' OR NOT EXISTS
         (SELECT 1 FROM uc07_privado.legado_oferta l
           WHERE l."idOfertaExcedente"=OLD."idOfertaExcedente"
             AND (l.fila_certificada-ARRAY['respuesta','fechaHoraRespuesta','cantidadAceptada','importeAceptado'])
               IS NOT DISTINCT FROM
                 (to_jsonb(OLD)-ARRAY['respuesta','fechaHoraRespuesta','cantidadAceptada','importeAceptado'])) THEN
        RAISE EXCEPTION 'Legado sin politica/procedencia' USING ERRCODE='23514';
      END IF;
    END IF;
    IF NEW."respuesta"='ACEPTADA' AND NOT EXISTS
       (SELECT 1 FROM public."PEDIDO" WHERE "idPedido"=c.pedido AND "estado"='PENDIENTE') THEN
      RAISE EXCEPTION 'Receptor no pendiente' USING ERRCODE='23514';
    END IF;
    NEW."fechaHoraRespuesta":=clock_timestamp();
    RETURN NEW; -- ck_oferta_excedente_3 sigue comprobando todos los campos.
  END IF;
  IF c.operacion<>'PARTE_A' OR NEW."idExcedente" IS DISTINCT FROM c.excedente
     OR NEW."idPedidoReceptor" IS DISTINCT FROM c.pedido
     OR NEW."idPrecio" IS NULL OR NEW."precioBaseUnitarioAplicado" IS NULL THEN
    RAISE EXCEPTION 'Nueva oferta sin snapshot/ambito' USING ERRCODE='23514';
  END IF;
  SELECT d."idProducto" INTO STRICT producto FROM public."EXCEDENTE" e
    JOIN public."DETALLE_PEDIDO" d
      ON (d."idPedido",d."numeroDetalle")=(e."idPedidoOrigen",e."numeroDetalleOrigen")
    WHERE e."idExcedente"=c.excedente;
  SELECT * INTO STRICT ped FROM public."PEDIDO" WHERE "idPedido"=c.pedido;
  IF ped."estado"<>'PENDIENTE' THEN
    RAISE EXCEPTION 'Pedido no pendiente' USING ERRCODE='23514';
  END IF;
  IF NOT EXISTS(SELECT 1 FROM public."CLIENTE"
      WHERE "idCliente"=ped."idCliente" AND "estado"='ACTIVO')
     OR NOT EXISTS(SELECT 1 FROM public."PRODUCTO"
      WHERE "idProducto"=producto AND "activo" AND "tipoProducto"='ELABORADO')
     OR NEW."cantidadOfrecida"<=0 OR NEW."cantidadOfrecida">c.cantidad_antes THEN
    RAISE EXCEPTION 'Elegibilidad/cantidad no valida' USING ERRCODE='23514';
  END IF;
  NEW."fechaHoraOferta":=c.instante;
  NEW."idUsuarioVendedor":=c.actor;
  SELECT count(*) INTO n FROM public."PRECIO_PRODUCTO"
    WHERE "idProducto"=producto AND "fechaHoraCancelacion" IS NULL
      AND "vigenteDesde"<=c.instante AND ("vigenteHasta" IS NULL OR c.instante<"vigenteHasta");
  SELECT * INTO STRICT p FROM public."PRECIO_PRODUCTO" WHERE "idPrecio"=NEW."idPrecio";
  IF n<>1 OR p."idProducto"<>producto OR p."fechaHoraCancelacion" IS NOT NULL
     OR p."vigenteDesde">c.instante OR (p."vigenteHasta" IS NOT NULL AND c.instante>=p."vigenteHasta")
     OR NEW."precioBaseUnitarioAplicado" IS DISTINCT FROM p."precioBase"
     OR NEW."importeInformado" IS DISTINCT FROM public.fn_uc07_importe(
       NEW."cantidadOfrecida",p."precioBase",ped."tipoAjuste",ped."porcentajeAjuste")
     OR NEW."respuesta"<>'PENDIENTE' THEN
    RAISE EXCEPTION 'Precio, vigencia o importe incoherentes' USING ERRCODE='23514';
  END IF;
  RETURN NEW;
END;
$fn$;
CREATE TRIGGER tg_uc07_oferta_guard BEFORE INSERT OR UPDATE OR DELETE
ON public."OFERTA_EXCEDENTE" FOR EACH ROW EXECUTE FUNCTION public.fn_uc07_oferta_guard();

CREATE FUNCTION public.fn_uc07_cotizacion_guard()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path=pg_catalog AS $fn$
DECLARE c uc07_privado.contexto_tx; o public."OFERTA_EXCEDENTE"%ROWTYPE;
  p public."PEDIDO"%ROWTYPE; siguiente integer; importe numeric;
BEGIN
  IF TG_OP<>'INSERT' THEN RAISE EXCEPTION 'Version inmutable' USING ERRCODE='23514'; END IF;
  c:=public.fn_uc07_contexto();
  SELECT * INTO STRICT o FROM public."OFERTA_EXCEDENTE" WHERE "idOfertaExcedente"=c.oferta;
  SELECT * INTO STRICT p FROM public."PEDIDO" WHERE "idPedido"=o."idPedidoReceptor";
  IF NEW."idOfertaExcedente" IS DISTINCT FROM c.oferta OR o."respuesta"<>'PENDIENTE'
     OR p."estado"<>'PENDIENTE' OR o."idPrecio" IS NULL
     OR NEW."cantidadCotizada"<=0 OR NEW."cantidadCotizada">o."cantidadOfrecida" THEN
    RAISE EXCEPTION 'Cotizacion fuera de contexto' USING ERRCODE='23514';
  END IF;
  SELECT coalesce(max("numeroVersion"),0)+1 INTO siguiente
    FROM public."COTIZACION_OFERTA_EXCEDENTE" WHERE "idOfertaExcedente"=c.oferta;
  IF NEW."numeroVersion" IS DISTINCT FROM siguiente THEN
    RAISE EXCEPTION 'Version no correlativa bajo padre' USING ERRCODE='23514';
  END IF;
  IF siguiente=1 THEN
    IF c.operacion<>'PARTE_A' OR NEW."cantidadCotizada"<>o."cantidadOfrecida" THEN
      RAISE EXCEPTION 'V1 no atomica con Parte A' USING ERRCODE='23514';
    END IF;
    importe:=o."importeInformado";
  ELSE
    IF c.operacion<>'O1' OR NEW."cantidadCotizada">=o."cantidadOfrecida"
       OR c.cotizacion_nueva IS NOT NULL THEN
      RAISE EXCEPTION 'Nueva emision no parcial/unica' USING ERRCODE='23514';
    END IF;
    importe:=public.fn_uc07_importe(NEW."cantidadCotizada",o."precioBaseUnitarioAplicado",
                                   p."tipoAjuste",p."porcentajeAjuste");
  END IF;
  IF NEW."importeCalculado" IS DISTINCT FROM importe THEN
    RAISE EXCEPTION 'Importe cotizado discrepante' USING ERRCODE='23514';
  END IF;
  NEW."idUsuarioVendedor":=c.actor; NEW."fechaHoraGeneracion":=clock_timestamp();
  IF siguiente>1 THEN UPDATE uc07_privado.contexto_tx SET cotizacion_nueva=NEW."idCotizacion"
    WHERE xid=c.xid; END IF;
  RETURN NEW;
END;
$fn$;
CREATE TRIGGER tg_uc07_cotizacion_guard BEFORE INSERT OR UPDATE OR DELETE
ON public."COTIZACION_OFERTA_EXCEDENTE" FOR EACH ROW EXECUTE FUNCTION public.fn_uc07_cotizacion_guard();

CREATE FUNCTION public.fn_uc07_evidencia_guard()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path=pg_catalog AS $fn$
DECLARE c uc07_privado.contexto_tx; o public."OFERTA_EXCEDENTE"%ROWTYPE;
  q public."COTIZACION_OFERTA_EXCEDENTE"%ROWTYPE; siguiente integer;
BEGIN
  IF TG_OP='DELETE' THEN RAISE EXCEPTION 'Evidencia no borrable' USING ERRCODE='23514'; END IF;
  IF TG_OP='UPDATE' AND NEW IS NOT DISTINCT FROM OLD THEN RETURN NEW; END IF;
  c:=public.fn_uc07_contexto();
  IF NEW."idOfertaExcedente" IS DISTINCT FROM c.oferta THEN
    RAISE EXCEPTION 'Evidencia fuera de ambito' USING ERRCODE='42501';
  END IF;
  IF TG_OP='UPDATE' THEN
    IF (to_jsonb(NEW)-'estadoEvidencia') IS DISTINCT FROM (to_jsonb(OLD)-'estadoEvidencia')
       OR NOT ((OLD."estadoEvidencia"='CAPTURADA' AND NEW."estadoEvidencia" IN ('VERIFICADA','INVALIDADA'))
            OR (OLD."estadoEvidencia"='VERIFICADA' AND NEW."estadoEvidencia" IN ('UTILIZADA','INVALIDADA'))) THEN
      RAISE EXCEPTION 'Historia o transicion invalida' USING ERRCODE='23514';
    END IF;
    IF NOT ((c.operacion='O2' AND NEW."estadoEvidencia" IN ('VERIFICADA','INVALIDADA'))
      OR (c.operacion='PARTE_B' AND OLD."estadoEvidencia"='VERIFICADA' AND NEW."estadoEvidencia"='UTILIZADA')
      OR (c.operacion='RECHAZO' AND NEW."estadoEvidencia"='INVALIDADA')) THEN
      RAISE EXCEPTION 'Transicion ajena a operacion' USING ERRCODE='42501';
    END IF;
    RETURN NEW;
  END IF;
  IF c.operacion<>'O2' OR c.evidencia_nueva IS NOT NULL THEN
    RAISE EXCEPTION 'Alta documental no autorizada/unica' USING ERRCODE='42501';
  END IF;
  SELECT * INTO STRICT q FROM public."COTIZACION_OFERTA_EXCEDENTE" WHERE "idCotizacion"=NEW."idCotizacion";
  SELECT * INTO STRICT o FROM public."OFERTA_EXCEDENTE" WHERE "idOfertaExcedente"=c.oferta;
  IF q."idOfertaExcedente"<>c.oferta OR o."respuesta"<>'PENDIENTE'
     OR NOT EXISTS(SELECT 1 FROM public."PEDIDO" WHERE "idPedido"=o."idPedidoReceptor" AND "estado"='PENDIENTE')
     OR NEW."cantidadConfirmada" IS DISTINCT FROM q."cantidadCotizada"
     OR NEW."importeConfirmado" IS DISTINCT FROM q."importeCalculado"
     OR NEW."estadoEvidencia"<>'CAPTURADA' THEN
    RAISE EXCEPTION 'Correspondencia comercial invalida' USING ERRCODE='23514';
  END IF;
  NEW."fechaHoraRegistro":=clock_timestamp(); NEW."idUsuarioVendedor":=c.actor;
  IF NEW."fechaHoraMensaje"<q."fechaHoraGeneracion" OR NEW."fechaHoraMensaje">NEW."fechaHoraRegistro"
     OR octet_length(NEW."contenidoOriginal")=0
     OR NEW."tipoMimeContenido" NOT IN ('image/png','image/jpeg')
     OR lower(btrim(split_part(NEW."tipoMimeDeclarado",';',1))) IS DISTINCT FROM NEW."tipoMimeContenido"
     OR (NEW."tipoMimeContenido"='image/png' AND substring(NEW."contenidoOriginal" FROM 1 FOR 8)<>decode('89504e470d0a1a0a','hex'))
     OR (NEW."tipoMimeContenido"='image/jpeg' AND substring(NEW."contenidoOriginal" FROM 1 FOR 3)<>decode('ffd8ff','hex'))
     OR NEW."huellaContenido" IS DISTINCT FROM encode(sha256(NEW."contenidoOriginal"),'hex') THEN
    RAISE EXCEPTION 'Tiempo, MIME, firma o huella invalidos' USING ERRCODE='23514';
  END IF;
  SELECT coalesce(max("numeroIntentoEvidencia"),0)+1 INTO siguiente
    FROM public."EVIDENCIA_ACEPTACION_OFERTA" WHERE "idOfertaExcedente"=c.oferta;
  IF NEW."numeroIntentoEvidencia" IS NOT NULL AND NEW."numeroIntentoEvidencia"<>siguiente THEN
    RAISE EXCEPTION 'Intento no correlativo' USING ERRCODE='23514';
  END IF;
  NEW."numeroIntentoEvidencia":=siguiente;
  UPDATE uc07_privado.contexto_tx SET evidencia_nueva=NEW."idEvidencia" WHERE xid=c.xid;
  RETURN NEW;
END;
$fn$;
CREATE TRIGGER tg_uc07_evidencia_guard BEFORE INSERT OR UPDATE OR DELETE
ON public."EVIDENCIA_ACEPTACION_OFERTA" FOR EACH ROW EXECUTE FUNCTION public.fn_uc07_evidencia_guard();
~~~

La comprobación física de firma/MIME/hash no reemplaza decodificación, legibilidad, memoria, tiempo ni límites efectivos de E en Java. No incorpora un techo físico de 2 MiB sin calibración. C2 no valida autenticidad del cliente ni WhatsApp. En UPDATE no-op de oferta/evidencia se conserva la fila sin generar transición; cualquier cambio real de historia o reapertura falla. Cotizaciones y comandos rechazan UPDATE incluso no-op.

### 15.8. Eventos causales y prueba del último estado

~~~sql
CREATE FUNCTION public.fn_uc07_evento_guard()
RETURNS trigger LANGUAGE plpgsql SECURITY INVOKER SET search_path=pg_catalog AS $fn$
DECLARE c uc07_privado.contexto_tx; ultimo public."EVENTO_ESTADO_EVIDENCIA_OFERTA"%ROWTYPE;
        actual text;
BEGIN
  IF TG_OP<>'INSERT' THEN RAISE EXCEPTION 'Bitacora append-only' USING ERRCODE='23514'; END IF;
  -- INVOKER: no convertir current_user en owner mediante SECURITY DEFINER aquí.
  -- La inserción legítima se ejecuta dentro del AFTER de evidencia, como owner.
  IF current_user<>'uc07_owner' THEN
    RAISE EXCEPTION 'Evento requiere emisor controlado' USING ERRCODE='42501';
  END IF;
  c:=public.fn_uc07_contexto();
  SELECT * INTO ultimo FROM public."EVENTO_ESTADO_EVIDENCIA_OFERTA"
    WHERE "idEvidencia"=NEW."idEvidencia" ORDER BY "ordenEvento" DESC LIMIT 1;
  IF NOT FOUND THEN
    IF NEW."ordenEvento"<>1 OR NEW."estadoAnterior" IS NOT NULL OR NEW."estadoNuevo"<>'CAPTURADA' THEN
      RAISE EXCEPTION 'Evento inicial invalido' USING ERRCODE='23514';
    END IF;
  ELSIF NEW."ordenEvento"<>ultimo."ordenEvento"+1
      OR NEW."estadoAnterior" IS DISTINCT FROM ultimo."estadoNuevo" THEN
    RAISE EXCEPTION 'Cadena causal no correlativa' USING ERRCODE='23514';
  END IF;
  SELECT "estadoEvidencia" INTO STRICT actual FROM public."EVIDENCIA_ACEPTACION_OFERTA"
    WHERE "idEvidencia"=NEW."idEvidencia";
  IF NEW."estadoNuevo" IS DISTINCT FROM actual OR NEW."idUsuario" IS DISTINCT FROM c.actor
     OR NEW."motivo" IS NULL OR btrim(NEW."motivo")='' THEN
    RAISE EXCEPTION 'Evento no corresponde al hecho actual' USING ERRCODE='23514';
  END IF;
  RETURN NEW; -- comparación solo al INSERT del evento, no sobre cada evento histórico.
END;
$fn$;
CREATE TRIGGER tg_uc07_evento_guard BEFORE INSERT OR UPDATE OR DELETE
ON public."EVENTO_ESTADO_EVIDENCIA_OFERTA" FOR EACH ROW EXECUTE FUNCTION public.fn_uc07_evento_guard();

CREATE FUNCTION public.fn_uc07_emitir_evento()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path=pg_catalog AS $fn$
DECLARE c uc07_privado.contexto_tx; anterior text; motivo text; numero bigint;
BEGIN
  IF TG_OP='UPDATE' AND NEW."estadoEvidencia"=OLD."estadoEvidencia" THEN RETURN NEW; END IF;
  c:=public.fn_uc07_contexto();
  anterior:=CASE WHEN TG_OP='INSERT' THEN NULL ELSE OLD."estadoEvidencia" END;
  motivo:=CASE
    WHEN TG_OP='INSERT' THEN 'CAPTURA_DOCUMENTAL'
    WHEN NEW."estadoEvidencia"='VERIFICADA' THEN 'VERIFICACION_TECNICA'
    WHEN NEW."estadoEvidencia"='UTILIZADA' THEN 'TRANSFERENCIA_CONFIRMADA'
    WHEN c.operacion='RECHAZO' THEN 'OFERTA_RECHAZADA'
    ELSE 'SUPERADA_POR_RECOTIZACION' END;
  SELECT coalesce(max("ordenEvento"),0)+1 INTO numero
    FROM public."EVENTO_ESTADO_EVIDENCIA_OFERTA" WHERE "idEvidencia"=NEW."idEvidencia";
  INSERT INTO public."EVENTO_ESTADO_EVIDENCIA_OFERTA"
    ("idEvidencia","estadoAnterior","estadoNuevo","ordenEvento","idUsuario","fechaHoraTransicion","motivo")
    VALUES(NEW."idEvidencia",anterior,NEW."estadoEvidencia",numero,c.actor,clock_timestamp(),motivo);
  RETURN NEW;
END;
$fn$;
CREATE TRIGGER tg_uc07_emitir_evento AFTER INSERT OR UPDATE
ON public."EVIDENCIA_ACEPTACION_OFERTA" FOR EACH ROW EXECUTE FUNCTION public.fn_uc07_emitir_evento();

CREATE FUNCTION public.fn_uc07_estado_evento_final()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path=pg_catalog AS $fn$
DECLARE id uuid; actual text; ultimo text;
BEGIN
  id:=NEW."idEvidencia";
  SELECT "estadoEvidencia" INTO STRICT actual FROM public."EVIDENCIA_ACEPTACION_OFERTA" WHERE "idEvidencia"=id;
  SELECT "estadoNuevo" INTO ultimo FROM public."EVENTO_ESTADO_EVIDENCIA_OFERTA"
    WHERE "idEvidencia"=id ORDER BY "ordenEvento" DESC LIMIT 1;
  IF ultimo IS DISTINCT FROM actual THEN
    RAISE EXCEPTION 'Falta evento causal del estado final' USING ERRCODE='23514';
  END IF;
  RETURN NULL;
END;
$fn$;
CREATE CONSTRAINT TRIGGER ct_uc07_estado_evento
AFTER INSERT OR UPDATE ON public."EVIDENCIA_ACEPTACION_OFERTA"
DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION public.fn_uc07_estado_evento_final();
CREATE CONSTRAINT TRIGGER ct_uc07_evento_estado
AFTER INSERT ON public."EVENTO_ESTADO_EVIDENCIA_OFERTA"
DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION public.fn_uc07_estado_evento_final();
~~~

O2 inserta CAPTURADA, el AFTER inserta NULL→CAPTURADA cuando el padre ya existe; luego UPDATE a VERIFICADA emite CAPTURADA→VERIFICADA. Los diferidos releen **estado final y último evento**. No se compara cada evento pasado con el estado final. El rol operativo carece de INSERT de eventos; no se usa pg_trigger_depth como prueba de identidad. El rol propietario/migrador queda fuera del adversario operativo y requiere mantenimiento excepcional auditado.


### 15.9. Movimiento, saldo y prueba histórica de la transferencia (F6-A)

~~~sql
CREATE FUNCTION public.fn_uc07_movimiento_guard()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path=pg_catalog AS $fn$
DECLARE c uc07_privado.contexto_tx; esperado numeric;
BEGIN
  IF TG_OP<>'INSERT' THEN
    RAISE EXCEPTION 'Movimiento historico inmutable' USING ERRCODE='23514';
  END IF;
  c:=public.fn_uc07_contexto();
  IF NEW."idExcedente" IS DISTINCT FROM c.excedente OR c.movimiento_nuevo IS NOT NULL
     OR NOT ((c.operacion='PARTE_B' AND NEW."tipoMovimiento"='REASIGNACION'
                  AND NEW."idOfertaExcedente" IS NOT DISTINCT FROM c.oferta)
          OR (c.operacion='UC41' AND NEW."tipoMovimiento"='DESCARTE'
                  AND NEW."idOfertaExcedente" IS NULL))
     OR NEW."cantidad"<=0 OR NEW."cantidad">c.cantidad_antes THEN
    RAISE EXCEPTION 'Transferencia fuera de contexto/saldo' USING ERRCODE='23514';
  END IF;
  esperado:=CASE WHEN NEW."cantidad"=c.cantidad_antes THEN c.costo_antes
                 ELSE round(c.costo_antes*NEW."cantidad"/c.cantidad_antes,4) END;
  IF NEW."costoHistoricoSalida" IS DISTINCT FROM esperado THEN
    RAISE EXCEPTION 'Costo historico discrepante' USING ERRCODE='23514';
  END IF;
  NEW."fechaHoraMovimiento":=clock_timestamp();
  UPDATE uc07_privado.contexto_tx SET movimiento_nuevo=NEW."idMovimientoExcedente" WHERE xid=c.xid;
  RETURN NEW;
END;
$fn$;
CREATE TRIGGER tg_uc07_movimiento_guard BEFORE INSERT OR UPDATE OR DELETE
ON public."MOVIMIENTO_EXCEDENTE" FOR EACH ROW EXECUTE FUNCTION public.fn_uc07_movimiento_guard();

CREATE FUNCTION public.fn_uc07_registrar_transferencia()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path=pg_catalog AS $fn$
DECLARE c uc07_privado.contexto_tx;
BEGIN
  c:=public.fn_uc07_contexto();
  INSERT INTO uc07_privado.transferencia VALUES
    (NEW."idMovimientoExcedente",c.xid,c.cantidad_antes,c.costo_antes,
     c.cantidad_antes-NEW."cantidad",c.costo_antes-NEW."costoHistoricoSalida");
  RETURN NEW;
END;
$fn$;
CREATE TRIGGER tg_uc07_registrar_transferencia AFTER INSERT
ON public."MOVIMIENTO_EXCEDENTE" FOR EACH ROW EXECUTE FUNCTION public.fn_uc07_registrar_transferencia();

CREATE FUNCTION public.fn_uc07_inmutable()
RETURNS trigger LANGUAGE plpgsql SET search_path=pg_catalog AS $fn$
BEGIN RAISE EXCEPTION 'Registro historico inmutable' USING ERRCODE='23514'; END;
$fn$;
CREATE TRIGGER tg_uc07_transferencia_inmutable BEFORE UPDATE OR DELETE
ON uc07_privado.transferencia FOR EACH ROW EXECUTE FUNCTION public.fn_uc07_inmutable();

CREATE FUNCTION public.fn_uc07_excedente_guard()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path=pg_catalog AS $fn$
DECLARE c uc07_privado.contexto_tx; delta numeric; costo numeric;
BEGIN
  IF TG_OP='DELETE' THEN RAISE EXCEPTION 'Excedente historico no borrable' USING ERRCODE='23514'; END IF;
  IF NEW IS NOT DISTINCT FROM OLD THEN RETURN NEW; END IF;
  IF (to_jsonb(NEW)-ARRAY['cantidadDisponible','costoHistoricoDisponible']) IS DISTINCT FROM
     (to_jsonb(OLD)-ARRAY['cantidadDisponible','costoHistoricoDisponible']) THEN
    RAISE EXCEPTION 'Origen/cantidad inicial/costo inicial inmutables' USING ERRCODE='23514';
  END IF;
  c:=public.fn_uc07_contexto();
  IF c.operacion NOT IN ('PARTE_B','UC41') OR c.excedente IS DISTINCT FROM OLD."idExcedente"
     OR OLD."cantidadDisponible" IS DISTINCT FROM c.cantidad_antes
     OR OLD."costoHistoricoDisponible" IS DISTINCT FROM c.costo_antes THEN
    RAISE EXCEPTION 'Cambio de saldo sin contexto inicial' USING ERRCODE='23514';
  END IF;
  delta:=OLD."cantidadDisponible"-NEW."cantidadDisponible";
  IF delta<=0 OR delta>OLD."cantidadDisponible" THEN
    RAISE EXCEPTION 'Delta de saldo invalido' USING ERRCODE='23514';
  END IF;
  costo:=CASE WHEN delta=OLD."cantidadDisponible" THEN OLD."costoHistoricoDisponible"
              ELSE round(OLD."costoHistoricoDisponible"*delta/OLD."cantidadDisponible",4) END;
  IF NEW."costoHistoricoDisponible" IS DISTINCT FROM OLD."costoHistoricoDisponible"-costo THEN
    RAISE EXCEPTION 'Costo restante invalido' USING ERRCODE='23514';
  END IF;
  RETURN NEW;
END;
$fn$;
CREATE TRIGGER tg_uc07_excedente_guard BEFORE UPDATE OR DELETE
ON public."EXCEDENTE" FOR EACH ROW EXECUTE FUNCTION public.fn_uc07_excedente_guard();

CREATE FUNCTION public.fn_uc07_validar_oferta(p_id bigint)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER SET search_path=pg_catalog AS $fn$
DECLARE o public."OFERTA_EXCEDENTE"%ROWTYPE; e public."EVIDENCIA_ACEPTACION_OFERTA"%ROWTYPE;
  m public."MOVIMIENTO_EXCEDENTE"%ROWTYPE; t uc07_privado.transferencia;
  q public."COTIZACION_OFERTA_EXCEDENTE"%ROWTYPE; n integer; prod bigint;
BEGIN
  SELECT * INTO o FROM public."OFERTA_EXCEDENTE" WHERE "idOfertaExcedente"=p_id;
  IF NOT FOUND THEN RETURN; END IF;
  IF o."idPrecio" IS NULL AND EXISTS(SELECT 1 FROM uc07_privado.legado_oferta
        WHERE "idOfertaExcedente"=p_id) THEN RETURN; END IF;
  -- Grandfather solo certificado; no habilita nueva aceptación sin snapshot.
  SELECT count(*) INTO n FROM public."COTIZACION_OFERTA_EXCEDENTE"
    WHERE "idOfertaExcedente"=p_id AND "numeroVersion"=1
      AND "cantidadCotizada"=o."cantidadOfrecida" AND "importeCalculado"=o."importeInformado";
  IF n<>1 THEN RAISE EXCEPTION 'Oferta sin unica V1 final' USING ERRCODE='23514'; END IF;
  IF o."respuesta"<>'ACEPTADA' THEN
    IF EXISTS(SELECT 1 FROM public."EVIDENCIA_ACEPTACION_OFERTA"
         WHERE "idOfertaExcedente"=p_id AND "estadoEvidencia"='UTILIZADA')
       OR EXISTS(SELECT 1 FROM public."MOVIMIENTO_EXCEDENTE" WHERE "idOfertaExcedente"=p_id)
       OR (o."respuesta"='RECHAZADA' AND EXISTS(
          SELECT 1 FROM public."EVIDENCIA_ACEPTACION_OFERTA"
          WHERE "idOfertaExcedente"=p_id AND "estadoEvidencia" IN ('CAPTURADA','VERIFICADA'))) THEN
      RAISE EXCEPTION 'Efectos de aceptacion/cierre incoherentes' USING ERRCODE='23514';
    END IF;
    RETURN;
  END IF;
  SELECT count(*) INTO n FROM public."EVIDENCIA_ACEPTACION_OFERTA"
    WHERE "idOfertaExcedente"=p_id AND "estadoEvidencia"='UTILIZADA';
  IF n<>1 THEN RAISE EXCEPTION 'Aceptacion sin evidencia utilizada unica' USING ERRCODE='23514'; END IF;
  SELECT * INTO STRICT e FROM public."EVIDENCIA_ACEPTACION_OFERTA"
    WHERE "idOfertaExcedente"=p_id AND "estadoEvidencia"='UTILIZADA';
  SELECT * INTO STRICT q FROM public."COTIZACION_OFERTA_EXCEDENTE" WHERE "idCotizacion"=e."idCotizacion";
  SELECT count(*) INTO n FROM public."MOVIMIENTO_EXCEDENTE" WHERE "idOfertaExcedente"=p_id;
  IF n<>1 THEN RAISE EXCEPTION 'Aceptacion sin movimiento unico' USING ERRCODE='23514'; END IF;
  SELECT * INTO STRICT m FROM public."MOVIMIENTO_EXCEDENTE" WHERE "idOfertaExcedente"=p_id;
  SELECT * INTO t FROM uc07_privado.transferencia WHERE "idMovimientoExcedente"=m."idMovimientoExcedente";
  IF NOT FOUND THEN RAISE EXCEPTION 'Transferencia sin prueba historica' USING ERRCODE='23514'; END IF;
  IF q."idOfertaExcedente"<>p_id OR o."cantidadAceptada" IS DISTINCT FROM e."cantidadConfirmada"
     OR o."importeAceptado" IS DISTINCT FROM e."importeConfirmado"
     OR q."cantidadCotizada" IS DISTINCT FROM e."cantidadConfirmada"
     OR q."importeCalculado" IS DISTINCT FROM e."importeConfirmado"
     OR m."tipoMovimiento"<>'REASIGNACION' OR m."idExcedente"<>o."idExcedente"
     OR m."cantidad" IS DISTINCT FROM o."cantidadAceptada"
     OR t.cantidad_despues IS DISTINCT FROM t.cantidad_antes-m."cantidad"
     OR t.costo_despues IS DISTINCT FROM t.costo_antes-m."costoHistoricoSalida"
     OR m."costoHistoricoSalida" IS DISTINCT FROM
          (CASE WHEN m."cantidad"=t.cantidad_antes THEN t.costo_antes
                ELSE round(t.costo_antes*m."cantidad"/t.cantidad_antes,4) END) THEN
    RAISE EXCEPTION 'Aceptacion, evidencia o costo incoherentes' USING ERRCODE='23514';
  END IF;
  IF t.xid=pg_current_xact_id() AND NOT EXISTS(
     SELECT 1 FROM public."EXCEDENTE" x WHERE x."idExcedente"=m."idExcedente"
       AND x."cantidadDisponible"=t.cantidad_despues AND x."costoHistoricoDisponible"=t.costo_despues) THEN
    RAISE EXCEPTION 'Saldo no descontado atomicamente' USING ERRCODE='23514';
  END IF;
  SELECT d."idProducto" INTO STRICT prod FROM public."EXCEDENTE" x
    JOIN public."DETALLE_PEDIDO" d ON (d."idPedido",d."numeroDetalle")=(x."idPedidoOrigen",x."numeroDetalleOrigen")
    WHERE x."idExcedente"=o."idExcedente";
  IF NOT EXISTS(SELECT 1 FROM public."DETALLE_PEDIDO" d
      WHERE d."idPedido"=o."idPedidoReceptor" AND d."idProducto"=prod) THEN
    RAISE EXCEPTION 'Falta detalle receptor original o tecnico' USING ERRCODE='23514';
  END IF;
  -- F6-A NO consulta ni exige DETALLE_ENTREGA/IMPUTACION_ENTREGA_ADICIONAL.
END;
$fn$;

CREATE FUNCTION public.fn_uc07_oferta_diferida()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path=pg_catalog AS $fn$
DECLARE r jsonb; id bigint;
BEGIN
  r:=CASE WHEN TG_OP='DELETE' THEN to_jsonb(OLD) ELSE to_jsonb(NEW) END;
  id:=(r->>'idOfertaExcedente')::bigint;
  IF id IS NOT NULL THEN PERFORM public.fn_uc07_validar_oferta(id); END IF;
  RETURN NULL;
END;
$fn$;
CREATE CONSTRAINT TRIGGER ct_uc07_oferta_final
AFTER INSERT OR UPDATE ON public."OFERTA_EXCEDENTE"
DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION public.fn_uc07_oferta_diferida();
CREATE CONSTRAINT TRIGGER ct_uc07_cotizacion_final
AFTER INSERT ON public."COTIZACION_OFERTA_EXCEDENTE"
DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION public.fn_uc07_oferta_diferida();
CREATE CONSTRAINT TRIGGER ct_uc07_evidencia_aceptacion
AFTER INSERT OR UPDATE ON public."EVIDENCIA_ACEPTACION_OFERTA"
DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION public.fn_uc07_oferta_diferida();
CREATE CONSTRAINT TRIGGER ct_uc07_movimiento_aceptacion
AFTER INSERT ON public."MOVIMIENTO_EXCEDENTE"
DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION public.fn_uc07_oferta_diferida();
~~~

Las guardias de movimiento/imputación y de evidencia/padres impiden romper la aceptación posteriormente; no se depende únicamente de UPDATE OF respuesta. El diferido relee las filas finales; no usa el NEW encolado como estado definitivo. La prueba inmutable de transferencia evita exigir que el saldo actual, tras futuros descartes, siga siendo el saldo de aquella aceptación.

### 15.10. F6-B: entrega posterior, imputación y orden cronológico

**Corrección expresa del responsable en este C2:** controles en dos momentos. F6-B se ejecuta al entregar en UC-05; no fabrica ENTREGA/DETALLE_ENTREGA en UC-07. Se mantienen fk_imputacion_entrega_adicional_0/1 y uq_imputacion_entrega_adicional_0. Una entrega puede imputar menos que lo aceptado: no se exige siempre cantidad/importe completos.

**Criterio monetario candidato para revisión:** porción completa conserva importeAceptado; porción parcial aplica D2-A a cantidadImputada con P/ajuste congelados. La fórmula específica de entrega parcial, su redondeo y los casos legacy sin P requieren revisión conjunta UC-05; no se presenta como nueva regla ratificada. El SQL siguiente desarrolla esa propuesta, no autoriza su uso.

~~~sql
CREATE FUNCTION public.fn_uc07_imputacion_guard()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path=pg_catalog AS $fn$
DECLARE c uc07_privado.contexto_tx; m public."MOVIMIENTO_EXCEDENTE"%ROWTYPE;
        o public."OFERTA_EXCEDENTE"%ROWTYPE;
BEGIN
  IF TG_OP<>'INSERT' THEN RAISE EXCEPTION 'Imputacion historica inmutable' USING ERRCODE='23514'; END IF;
  c:=public.fn_uc07_contexto();
  SELECT * INTO STRICT m FROM public."MOVIMIENTO_EXCEDENTE" WHERE "idMovimientoExcedente"=NEW."idMovimientoExcedente";
  SELECT * INTO STRICT o FROM public."OFERTA_EXCEDENTE" WHERE "idOfertaExcedente"=m."idOfertaExcedente";
  IF c.operacion<>'UC05' OR c.pedido IS DISTINCT FROM NEW."idPedido"
     OR o."respuesta"<>'ACEPTADA' OR m."tipoMovimiento"<>'REASIGNACION'
     OR o."idPedidoReceptor"<>NEW."idPedido" OR o."idExcedente"<>m."idExcedente"
     OR NEW."cantidadImputada"<=0 OR NEW."cantidadImputada">m."cantidad" THEN
    RAISE EXCEPTION 'Imputacion ajena o excesiva' USING ERRCODE='23514';
  END IF;
  RETURN NEW; -- FKs exigen el DETALLE_ENTREGA real; diferido valida la entrega completa.
END;
$fn$;
CREATE TRIGGER tg_uc07_imputacion_guard BEFORE INSERT OR UPDATE OR DELETE
ON public."IMPUTACION_ENTREGA_ADICIONAL" FOR EACH ROW EXECUTE FUNCTION public.fn_uc07_imputacion_guard();

CREATE FUNCTION public.fn_uc07_validar_entrega(p_pedido bigint,p_detalle integer)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER SET search_path=pg_catalog AS $fn$
DECLARE d public."DETALLE_PEDIDO"%ROWTYPE; q_ent numeric; restante numeric;
        tomar numeric; esperado numeric; encontrado public."IMPUTACION_ENTREGA_ADICIONAL"%ROWTYPE;
        rec record; n_esperado integer:=0; n_real integer; ped public."PEDIDO"%ROWTYPE;
        preparado numeric; total_adicional numeric; producto_tipo text;
BEGIN
  SELECT "cantidadEntregada" INTO q_ent FROM public."DETALLE_ENTREGA"
    WHERE "idPedido"=p_pedido AND "numeroDetalle"=p_detalle;
  IF NOT FOUND THEN
    IF EXISTS(SELECT 1 FROM public."IMPUTACION_ENTREGA_ADICIONAL"
      WHERE "idPedido"=p_pedido AND "numeroDetalle"=p_detalle) THEN
      RAISE EXCEPTION 'Imputacion sin detalle de entrega' USING ERRCODE='23514';
    END IF;
    RETURN;
  END IF;
  SELECT * INTO STRICT d FROM public."DETALLE_PEDIDO"
    WHERE "idPedido"=p_pedido AND "numeroDetalle"=p_detalle;
  SELECT * INTO STRICT ped FROM public."PEDIDO" WHERE "idPedido"=p_pedido;
  IF ped."estado"<>'ENTREGADO' THEN
    RAISE EXCEPTION 'Entrega sin cierre final del pedido' USING ERRCODE='23514';
  END IF;
  SELECT "tipoProducto" INTO STRICT producto_tipo FROM public."PRODUCTO" WHERE "idProducto"=d."idProducto";
  SELECT coalesce(sum(o."cantidadAceptada"),0) INTO total_adicional
    FROM public."OFERTA_EXCEDENTE" o JOIN public."EXCEDENTE" x ON x."idExcedente"=o."idExcedente"
    JOIN public."DETALLE_PEDIDO" origen ON (origen."idPedido",origen."numeroDetalle")=(x."idPedidoOrigen",x."numeroDetalleOrigen")
    WHERE o."idPedidoReceptor"=p_pedido AND o."respuesta"='ACEPTADA' AND origen."idProducto"=d."idProducto";
  IF q_ent>d."cantidadOriginal"+total_adicional THEN
    RAISE EXCEPTION 'Entrega sobre limite comercial' USING ERRCODE='23514';
  END IF;
  IF producto_tipo='ELABORADO' THEN
    SELECT coalesce(sum("cantidadPreparada"),0) INTO preparado FROM public."PREPARACION"
      WHERE "idPedido"=p_pedido AND "numeroDetalle"=p_detalle;
    IF q_ent>preparado+total_adicional THEN
      RAISE EXCEPTION 'Entrega sobre disponibilidad elaborada' USING ERRCODE='23514';
    END IF;
  END IF;
  restante:=greatest(q_ent-d."cantidadOriginal",0);
  FOR rec IN SELECT o.*,m."idMovimientoExcedente",m."cantidad"
      FROM public."OFERTA_EXCEDENTE" o
      JOIN public."MOVIMIENTO_EXCEDENTE" m ON m."idOfertaExcedente"=o."idOfertaExcedente"
      JOIN public."EXCEDENTE" x ON x."idExcedente"=o."idExcedente"
      JOIN public."DETALLE_PEDIDO" origen ON (origen."idPedido",origen."numeroDetalle")=(x."idPedidoOrigen",x."numeroDetalleOrigen")
      WHERE o."idPedidoReceptor"=p_pedido AND o."respuesta"='ACEPTADA'
        AND m."tipoMovimiento"='REASIGNACION' AND origen."idProducto"=d."idProducto"
      ORDER BY o."fechaHoraRespuesta",o."idOfertaExcedente",m."idMovimientoExcedente"
  LOOP
    tomar:=least(restante,rec."cantidad");
    SELECT * INTO encontrado FROM public."IMPUTACION_ENTREGA_ADICIONAL"
      WHERE "idMovimientoExcedente"=rec."idMovimientoExcedente";
    IF tomar>0 THEN
      IF NOT FOUND OR encontrado."idPedido"<>p_pedido OR encontrado."numeroDetalle"<>p_detalle
         OR encontrado."cantidadImputada" IS DISTINCT FROM tomar THEN
        RAISE EXCEPTION 'Falta imputacion cronologica exacta' USING ERRCODE='23514';
      END IF;
      IF tomar=rec."cantidadAceptada" THEN esperado:=rec."importeAceptado";
      ELSE
        IF rec."precioBaseUnitarioAplicado" IS NULL THEN
          RAISE EXCEPTION 'Importe parcial legado requiere politica aprobada' USING ERRCODE='23514';
        END IF;
        esperado:=public.fn_uc07_importe(tomar,rec."precioBaseUnitarioAplicado",ped."tipoAjuste",ped."porcentajeAjuste");
      END IF;
      IF encontrado."importeImputado" IS DISTINCT FROM esperado THEN
        RAISE EXCEPTION 'Importe imputado discrepante' USING ERRCODE='23514';
      END IF;
      n_esperado:=n_esperado+1; restante:=restante-tomar;
    ELSIF FOUND THEN
      RAISE EXCEPTION 'Imputacion no entregada o fuera de orden' USING ERRCODE='23514';
    END IF;
  END LOOP;
  SELECT count(*) INTO n_real FROM public."IMPUTACION_ENTREGA_ADICIONAL"
    WHERE "idPedido"=p_pedido AND "numeroDetalle"=p_detalle;
  IF restante<>0 OR n_real<>n_esperado THEN
    RAISE EXCEPTION 'Imputaciones adicionales incompletas/extranas' USING ERRCODE='23514';
  END IF;
  -- No actualiza PEDIDO.totalOriginal ni cobra; cargo contable sigue siendo UC05.
END;
$fn$;

CREATE FUNCTION public.fn_uc07_entrega_diferida()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path=pg_catalog AS $fn$
DECLARE r jsonb; p bigint; numero integer; it record;
BEGIN
  r:=CASE WHEN TG_OP='DELETE' THEN to_jsonb(OLD) ELSE to_jsonb(NEW) END;
  p:=(r->>'idPedido')::bigint; numero:=(r->>'numeroDetalle')::integer;
  IF numero IS NOT NULL THEN PERFORM public.fn_uc07_validar_entrega(p,numero);
  ELSE
    IF NOT EXISTS(SELECT 1 FROM public."ENTREGA" WHERE "idPedido"=p)
       OR NOT EXISTS(SELECT 1 FROM public."DETALLE_ENTREGA" WHERE "idPedido"=p AND "cantidadEntregada">0) THEN
      RAISE EXCEPTION 'Entrega ausente o sin cantidades positivas' USING ERRCODE='23514';
    END IF;
    FOR it IN SELECT "numeroDetalle" FROM public."DETALLE_ENTREGA" WHERE "idPedido"=p
    LOOP PERFORM public.fn_uc07_validar_entrega(p,it."numeroDetalle"); END LOOP;
  END IF;
  RETURN NULL;
END;
$fn$;
CREATE CONSTRAINT TRIGGER ct_uc07_imputacion_final AFTER INSERT
ON public."IMPUTACION_ENTREGA_ADICIONAL"
DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION public.fn_uc07_entrega_diferida();
CREATE CONSTRAINT TRIGGER ct_uc07_detalle_entrega_final AFTER INSERT OR UPDATE OR DELETE
ON public."DETALLE_ENTREGA"
DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION public.fn_uc07_entrega_diferida();
CREATE CONSTRAINT TRIGGER ct_uc07_entrega_final AFTER INSERT OR UPDATE OR DELETE
ON public."ENTREGA"
DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION public.fn_uc07_entrega_diferida();
~~~

V1 permite una única imputación por movimiento; se aprovecha esa UNIQUE, sin crear otra redundante. La integridad de stock/costos de entrega, sobrantes y CARGO_POR_VENTA completa continúa en el contrato/protocolo UC-05: este candidato solo cubre sus relaciones con adicionales UC-07. No certifica UC-05 entero.


### 15.11. Recibo ligado al efecto nuevo y comprobación diferida del contexto

~~~sql
CREATE FUNCTION public.fn_uc07_comando_guard()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path=pg_catalog AS $fn$
DECLARE c uc07_privado.contexto_tx; q public."COTIZACION_OFERTA_EXCEDENTE"%ROWTYPE;
        e public."EVIDENCIA_ACEPTACION_OFERTA"%ROWTYPE; h text; op text; recibo jsonb;
BEGIN
  IF TG_OP<>'INSERT' THEN RAISE EXCEPTION 'Comando confirmado inmutable' USING ERRCODE='23514'; END IF;
  c:=public.fn_uc07_contexto();
  op:=CASE c.operacion WHEN 'O1' THEN 'EMITIR_COTIZACION' WHEN 'O2' THEN 'REGISTRAR_EVIDENCIA' ELSE NULL END;
  IF op IS NULL OR NEW."idComandoAuxiliar" IS DISTINCT FROM c.comando
     OR NEW."operacion" IS DISTINCT FROM op OR NEW."idOfertaExcedente" IS DISTINCT FROM c.oferta
     OR NEW."idUsuarioVendedor" IS DISTINCT FROM c.actor
     OR NEW."claveIdempotencia" IS DISTINCT FROM c.clave THEN
    RAISE EXCEPTION 'Identidad de comando no corresponde al contexto' USING ERRCODE='23514';
  END IF;
  IF c.operacion='O1' THEN
    IF NEW."idCotizacion" IS DISTINCT FROM c.cotizacion_nueva OR NEW."idEvidencia" IS NOT NULL
       OR c.cotizacion_nueva IS NULL THEN RAISE EXCEPTION 'Efecto O1 no nuevo' USING ERRCODE='23514'; END IF;
    SELECT * INTO STRICT q FROM public."COTIZACION_OFERTA_EXCEDENTE" WHERE "idCotizacion"=c.cotizacion_nueva;
    IF q."idOfertaExcedente"<>c.oferta OR q."idUsuarioVendedor"<>c.actor THEN
      RAISE EXCEPTION 'Ambito/actor del efecto O1' USING ERRCODE='23514'; END IF;
    h:=public.fn_uc07_huella_cotizacion(q."idCotizacion");
    recibo:=jsonb_build_object('idCotizacion',q."idCotizacion",'numeroVersion',q."numeroVersion",
      'codigoCotizacion',q."codigoCotizacion",'cantidadCotizada',q."cantidadCotizada",
      'importeCalculado',q."importeCalculado",'fechaHoraGeneracion',
      to_char(q."fechaHoraGeneracion" AT TIME ZONE 'UTC','YYYY-MM-DD"T"HH24:MI:SS.US"Z"'));
  ELSE
    IF NEW."idEvidencia" IS DISTINCT FROM c.evidencia_nueva OR NEW."idCotizacion" IS NOT NULL
       OR c.evidencia_nueva IS NULL THEN RAISE EXCEPTION 'Efecto O2 no nuevo' USING ERRCODE='23514'; END IF;
    SELECT * INTO STRICT e FROM public."EVIDENCIA_ACEPTACION_OFERTA" WHERE "idEvidencia"=c.evidencia_nueva;
    IF e."idOfertaExcedente"<>c.oferta OR e."idUsuarioVendedor"<>c.actor OR e."estadoEvidencia"<>'VERIFICADA' THEN
      RAISE EXCEPTION 'Ambito/estado del efecto O2' USING ERRCODE='23514'; END IF;
    h:=public.fn_uc07_huella_evidencia(e."idEvidencia");
    recibo:=jsonb_build_object('idEvidencia',e."idEvidencia",'idCotizacion',e."idCotizacion",
      'estadoEvidencia',e."estadoEvidencia",'huellaContenido',e."huellaContenido",
      'fechaHoraRegistro',to_char(e."fechaHoraRegistro" AT TIME ZONE 'UTC','YYYY-MM-DD"T"HH24:MI:SS.US"Z"'));
  END IF;
  IF h IS DISTINCT FROM c.huella OR NEW."huellaSolicitud" IS DISTINCT FROM h THEN
    RAISE EXCEPTION 'Huella de solicitud/efecto discrepante' USING ERRCODE='23514';
  END IF;
  NEW."respuestaOriginal":=recibo;
  NEW."estadoHttpOriginal":=201;
  NEW."fechaHoraRegistro":=clock_timestamp();
  RETURN NEW;
END;
$fn$;
CREATE TRIGGER tg_uc07_comando_guard BEFORE INSERT OR UPDATE OR DELETE
ON public."COMANDO_AUXILIAR_UC07" FOR EACH ROW EXECUTE FUNCTION public.fn_uc07_comando_guard();

CREATE FUNCTION public.fn_uc07_contexto_final()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path=pg_catalog AS $fn$
DECLARE c uc07_privado.contexto_tx; t uc07_privado.transferencia;
        m public."MOVIMIENTO_EXCEDENTE"%ROWTYPE;
BEGIN
  SELECT * INTO STRICT c FROM uc07_privado.contexto_tx WHERE xid=NEW.xid;
  PERFORM public.fn_uc07_actor(c.sesion,c.operacion); -- vigencia/rol, no prueba de Bearer.
  IF c.replay THEN
    IF c.cotizacion_nueva IS NOT NULL OR c.evidencia_nueva IS NOT NULL OR c.movimiento_nuevo IS NOT NULL THEN
      RAISE EXCEPTION 'Replay con efectos nuevos' USING ERRCODE='23514';
    END IF;
    RETURN NULL;
  END IF;
  IF c.operacion IN ('O1','O2') AND NOT EXISTS(
    SELECT 1 FROM public."COMANDO_AUXILIAR_UC07" r
    WHERE r."idComandoAuxiliar"=c.comando AND r."idOfertaExcedente"=c.oferta
      AND r."idUsuarioVendedor"=c.actor AND r."claveIdempotencia"=c.clave
      AND r."huellaSolicitud"=c.huella
      AND ((c.operacion='O1' AND r."idCotizacion"=c.cotizacion_nueva AND r."idEvidencia" IS NULL)
        OR (c.operacion='O2' AND r."idEvidencia"=c.evidencia_nueva AND r."idCotizacion" IS NULL))) THEN
    RAISE EXCEPTION 'Efecto sin recibo atomico' USING ERRCODE='23514';
  END IF;
  IF c.operacion IN ('PARTE_A','PARTE_B','RECHAZO','O1','O2') THEN
    PERFORM public.fn_uc07_validar_oferta(c.oferta);
  END IF;
  IF c.operacion='PARTE_A' AND NOT EXISTS(SELECT 1 FROM public."OFERTA_EXCEDENTE" WHERE "idOfertaExcedente"=c.oferta) THEN
    RAISE EXCEPTION 'Parte A sin oferta' USING ERRCODE='23514';
  END IF;
  IF c.operacion='PARTE_B' AND NOT EXISTS(SELECT 1 FROM public."OFERTA_EXCEDENTE"
       WHERE "idOfertaExcedente"=c.oferta AND "respuesta"='ACEPTADA') THEN
    RAISE EXCEPTION 'Parte B sin aceptacion final' USING ERRCODE='23514';
  END IF;
  IF c.operacion='RECHAZO' AND NOT EXISTS(SELECT 1 FROM public."OFERTA_EXCEDENTE"
       WHERE "idOfertaExcedente"=c.oferta AND "respuesta"='RECHAZADA') THEN
    RAISE EXCEPTION 'Rechazo no confirmado' USING ERRCODE='23514';
  END IF;
  IF c.operacion IN ('PARTE_B','UC41') THEN
    SELECT * INTO STRICT m FROM public."MOVIMIENTO_EXCEDENTE" WHERE "idMovimientoExcedente"=c.movimiento_nuevo;
    SELECT * INTO STRICT t FROM uc07_privado.transferencia WHERE "idMovimientoExcedente"=m."idMovimientoExcedente";
    IF t.xid<>c.xid OR NOT EXISTS(SELECT 1 FROM public."EXCEDENTE"
        WHERE "idExcedente"=c.excedente AND "cantidadDisponible"=t.cantidad_despues
          AND "costoHistoricoDisponible"=t.costo_despues) THEN
      RAISE EXCEPTION 'Saldo y movimiento no atomicos' USING ERRCODE='23514';
    END IF;
  END IF;
  IF c.operacion='UC05' AND NOT EXISTS(SELECT 1 FROM public."ENTREGA" WHERE "idPedido"=c.pedido) THEN
    RAISE EXCEPTION 'Contexto UC05 sin entrega final' USING ERRCODE='23514';
  END IF;
  RETURN NULL;
END;
$fn$;
CREATE CONSTRAINT TRIGGER ct_uc07_contexto_final AFTER INSERT ON uc07_privado.contexto_tx
DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION public.fn_uc07_contexto_final();
~~~

El contexto protege el enlace al efecto **insertado en esa transacción** sin depender de xmin (que complica subtransacciones). No existe reserva PENDIENTE confirmada; los efectos fallan al commit si falta recibo. El gateway debe devolver el recibo construido mediante INSERT ... RETURNING respuestaOriginal/estadoHttpOriginal; el SQL no acepta JSON arbitrario sensible. Los formatos y HTTP 201/200 son candidatos D, no una nueva ratificación. En replay se conserva el JSON histórico, se reautoriza en Java y se consulta estadoActual por separado; no se ejecuta otro INSERT.

### 15.12. Padres comerciales, entrega y líneas técnicas

~~~sql
CREATE FUNCTION public.fn_uc07_padre_guard()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path=pg_catalog AS $fn$
DECLARE c uc07_privado.contexto_tx; j jsonb; id bigint; relacionado boolean;
BEGIN
  IF TG_OP='UPDATE' AND NEW IS NOT DISTINCT FROM OLD THEN RETURN NEW; END IF;
  j:=CASE WHEN TG_OP='DELETE' THEN to_jsonb(OLD) ELSE to_jsonb(NEW) END;
  IF TG_TABLE_NAME='PRECIO_PRODUCTO' THEN
    id:=OLD."idPrecio";
    relacionado:=EXISTS(SELECT 1 FROM public."OFERTA_EXCEDENTE" WHERE "idPrecio"=id);
    IF relacionado AND TG_OP='DELETE' THEN
      RAISE EXCEPTION 'Procedencia de precio no borrable' USING ERRCODE='23514';
    END IF;
    IF relacionado AND TG_OP='UPDATE' THEN
      IF ROW(NEW."idPrecio",NEW."idProducto",NEW."precioBase",NEW."vigenteDesde",
             NEW."fechaHoraRegistro",NEW."idUsuarioRegistro",NEW."fechaHoraCancelacion",NEW."idUsuarioCancelacion")
         IS DISTINCT FROM
         ROW(OLD."idPrecio",OLD."idProducto",OLD."precioBase",OLD."vigenteDesde",
             OLD."fechaHoraRegistro",OLD."idUsuarioRegistro",OLD."fechaHoraCancelacion",OLD."idUsuarioCancelacion")
         OR EXISTS(SELECT 1 FROM public."OFERTA_EXCEDENTE" o WHERE o."idPrecio"=id
           AND (NEW."vigenteDesde">o."fechaHoraOferta"
             OR (NEW."vigenteHasta" IS NOT NULL AND NEW."vigenteHasta"<=o."fechaHoraOferta"))) THEN
        RAISE EXCEPTION 'Precio historico alterado' USING ERRCODE='23514';
      END IF;
    END IF;
  ELSIF TG_TABLE_NAME='PEDIDO' THEN
    IF TG_OP='UPDATE' AND NEW."estado" IS DISTINCT FROM OLD."estado"
       AND session_user='uc07_gateway' THEN
      c:=public.fn_uc07_contexto();
      IF c.operacion<>'UC05' OR c.pedido IS DISTINCT FROM OLD."idPedido"
         OR OLD."estado"<>'PENDIENTE' OR NEW."estado"<>'ENTREGADO' THEN
        RAISE EXCEPTION 'Cierre/reapertura fuera de UC05' USING ERRCODE='23514';
      END IF;
    END IF;
    id:=OLD."idPedido";
    relacionado:=EXISTS(SELECT 1 FROM public."OFERTA_EXCEDENTE" WHERE "idPedidoReceptor"=id);
    IF relacionado AND TG_OP='DELETE' THEN
      RAISE EXCEPTION 'Pedido con historia UC07' USING ERRCODE='23514';
    END IF;
    IF relacionado AND TG_OP='UPDATE' AND
      ROW(NEW."idPedido",NEW."idCliente",NEW."tipoAjuste",NEW."porcentajeAjuste",NEW."totalOriginal",
          NEW."categoriaComercialAplicada",NEW."idPoliticaComercialAplicada")
      IS DISTINCT FROM
      ROW(OLD."idPedido",OLD."idCliente",OLD."tipoAjuste",OLD."porcentajeAjuste",OLD."totalOriginal",
          OLD."categoriaComercialAplicada",OLD."idPoliticaComercialAplicada") THEN
      RAISE EXCEPTION 'Cabecera comercial congelada' USING ERRCODE='23514';
    END IF;
  ELSIF TG_TABLE_NAME='DETALLE_PEDIDO' THEN
    IF TG_OP='INSERT' THEN
      IF NEW."cantidadOriginal"=0 THEN
        c:=public.fn_uc07_contexto();
        IF c.operacion<>'PARTE_B' OR c.pedido IS DISTINCT FROM NEW."idPedido" THEN
          RAISE EXCEPTION 'Linea tecnica fuera de aceptacion' USING ERRCODE='42501';
        END IF;
      END IF;
      RETURN NEW; -- ck_detalle_pedido_3 y trigger activo V1 intactos.
    END IF;
    relacionado:=EXISTS(SELECT 1 FROM public."EXCEDENTE" x
       WHERE (x."idPedidoOrigen",x."numeroDetalleOrigen")=(OLD."idPedido",OLD."numeroDetalle"))
       OR EXISTS(SELECT 1 FROM public."OFERTA_EXCEDENTE" o
          JOIN public."EXCEDENTE" x ON x."idExcedente"=o."idExcedente"
          JOIN public."DETALLE_PEDIDO" origen
            ON (origen."idPedido",origen."numeroDetalle")=(x."idPedidoOrigen",x."numeroDetalleOrigen")
          WHERE o."idPedidoReceptor"=OLD."idPedido" AND origen."idProducto"=OLD."idProducto");
    IF relacionado THEN
      RAISE EXCEPTION 'Detalle con procedencia/historia UC07 inmutable' USING ERRCODE='23514';
    END IF;
  ELSIF TG_TABLE_NAME='PRODUCTO' THEN
    relacionado:=EXISTS(SELECT 1 FROM public."OFERTA_EXCEDENTE" o
       JOIN public."EXCEDENTE" x ON x."idExcedente"=o."idExcedente"
       JOIN public."DETALLE_PEDIDO" d ON (d."idPedido",d."numeroDetalle")=(x."idPedidoOrigen",x."numeroDetalleOrigen")
       WHERE d."idProducto"=OLD."idProducto");
    IF relacionado AND (TG_OP='DELETE' OR
       (TG_OP='UPDATE' AND ROW(NEW."idProducto",NEW."tipoProducto",NEW."codigoUnidadVenta")
       IS DISTINCT FROM ROW(OLD."idProducto",OLD."tipoProducto",OLD."codigoUnidadVenta"))) THEN
      RAISE EXCEPTION 'Identidad/tipo/unidad con historia UC07' USING ERRCODE='23514';
    END IF;
    -- activo, nombre y descripción no se congelan indiscriminadamente.
  ELSIF TG_TABLE_NAME IN ('ENTREGA','DETALLE_ENTREGA') THEN
    IF TG_OP<>'INSERT' THEN
      RAISE EXCEPTION 'Entrega definitiva no reversible' USING ERRCODE='23514';
    END IF;
    c:=public.fn_uc07_contexto();
    IF c.operacion<>'UC05' OR c.pedido IS DISTINCT FROM (j->>'idPedido')::bigint THEN
      RAISE EXCEPTION 'Entrega fuera de contexto UC05' USING ERRCODE='42501';
    END IF;
    IF TG_TABLE_NAME='ENTREGA' THEN
      NEW."idUsuarioRepartidor":=c.actor; NEW."fechaHoraEntrega":=clock_timestamp();
    END IF;
  END IF;
  IF TG_OP='DELETE' THEN RETURN OLD; END IF;
  RETURN NEW;
END;
$fn$;
CREATE TRIGGER tg_uc07_precio_padre BEFORE UPDATE OR DELETE ON public."PRECIO_PRODUCTO"
FOR EACH ROW EXECUTE FUNCTION public.fn_uc07_padre_guard();
CREATE TRIGGER tg_uc07_pedido_padre BEFORE UPDATE OR DELETE ON public."PEDIDO"
FOR EACH ROW EXECUTE FUNCTION public.fn_uc07_padre_guard();
CREATE TRIGGER tg_uc07_detalle_padre BEFORE INSERT OR UPDATE OR DELETE ON public."DETALLE_PEDIDO"
FOR EACH ROW EXECUTE FUNCTION public.fn_uc07_padre_guard();
CREATE TRIGGER tg_uc07_producto_padre BEFORE UPDATE OR DELETE ON public."PRODUCTO"
FOR EACH ROW EXECUTE FUNCTION public.fn_uc07_padre_guard();
CREATE TRIGGER tg_uc07_entrega_guard BEFORE INSERT OR UPDATE OR DELETE ON public."ENTREGA"
FOR EACH ROW EXECUTE FUNCTION public.fn_uc07_padre_guard();
CREATE TRIGGER tg_uc07_detalle_entrega_guard BEFORE INSERT OR UPDATE OR DELETE ON public."DETALLE_ENTREGA"
FOR EACH ROW EXECUTE FUNCTION public.fn_uc07_padre_guard();
~~~

No se añade FOR UPDATE de oferta desde un trigger de precio/producto; se conserva el orden UC-19 PRODUCTO U→A2(1919,1)→PRECIO U. Los predicados de historia impiden romper intervalos ya usados, pero permiten cierres prospectivos que mantengan fechaHoraOferta dentro del rango. UC-48 puede cambiar activo sin borrar historia; una futura línea técnica de producto inactivo sigue encontrando el veto V1 intacto. La reserva de aceptación/entrega tras desactivación no se resuelve por este guard.

Las pruebas C3 deben incluir READ COMMITTED, nuevas FKs K, snapshots y escritores SQL controlados; no se atribuye seguridad concurrente global solo a EXISTS de un trigger. La cooperación exigida se impone al limitar DML al gateway; si otro rol operativo conserva UPDATE directo de precio/raíces fuera de los protocolos, F/H permanecen bloqueadas.


### 15.13. Propietarios y privilegios candidatos

**PROVISIONAMIENTO CANDIDATO, NO EJECUTADO.** Los nombres de roles son nuevos y requieren inventario previo; no representan usuarios ya configurados. Ejecutar su provisión antes de §15.6 en una eventual migración autorizada. Las credenciales se gestionan fuera del documento. No aplicar a ciegas sobre los roles actuales de la app.

~~~sql
-- Precondición administrativa: nombres libres y esquema/ACL inventariados.
CREATE ROLE uc07_owner NOLOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION NOBYPASSRLS;
CREATE ROLE uc07_gateway LOGIN NOINHERIT NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION NOBYPASSRLS;
CREATE ROLE uc07_runtime LOGIN NOINHERIT NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION NOBYPASSRLS;
ALTER DEFAULT PRIVILEGES FOR ROLE uc07_owner REVOKE EXECUTE ON FUNCTIONS FROM PUBLIC;
REVOKE uc07_owner,uc07_gateway FROM uc07_runtime;
REVOKE uc07_owner FROM uc07_gateway;
REVOKE CREATE ON SCHEMA public FROM PUBLIC,uc07_gateway,uc07_runtime;
GRANT USAGE ON SCHEMA public TO uc07_owner,uc07_gateway;
-- uc07_runtime tendrá únicamente las proyecciones autorizadas BC07,
-- definidas fuera de estos fragmentos; no se le concede DML UC07.

-- Después de crear tablas nuevas y funciones:
ALTER TABLE public."COTIZACION_OFERTA_EXCEDENTE" OWNER TO uc07_owner;
ALTER TABLE public."EVIDENCIA_ACEPTACION_OFERTA" OWNER TO uc07_owner;
ALTER TABLE public."EVENTO_ESTADO_EVIDENCIA_OFERTA" OWNER TO uc07_owner;
ALTER TABLE public."COMANDO_AUXILIAR_UC07" OWNER TO uc07_owner;
ALTER TABLE uc07_privado.contexto_tx OWNER TO uc07_owner;
ALTER TABLE uc07_privado.transferencia OWNER TO uc07_owner;
ALTER TABLE uc07_privado.legado_oferta OWNER TO uc07_owner;
REVOKE ALL ON SCHEMA uc07_privado FROM PUBLIC,uc07_runtime,uc07_gateway;
REVOKE ALL ON ALL TABLES IN SCHEMA uc07_privado FROM PUBLIC,uc07_runtime,uc07_gateway;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA uc07_privado FROM PUBLIC,uc07_runtime,uc07_gateway;

REVOKE ALL ON public."OFERTA_EXCEDENTE",public."COTIZACION_OFERTA_EXCEDENTE",
  public."EVIDENCIA_ACEPTACION_OFERTA",public."EVENTO_ESTADO_EVIDENCIA_OFERTA",
  public."COMANDO_AUXILIAR_UC07",public."MOVIMIENTO_EXCEDENTE",
  public."IMPUTACION_ENTREGA_ADICIONAL" FROM PUBLIC,uc07_runtime,uc07_gateway;

GRANT SELECT ON public."SESION_USUARIO",public."USUARIO",public."USUARIO_ROL",
  public."CLIENTE",public."PEDIDO",public."DETALLE_PEDIDO",public."EXCEDENTE",
  public."PRODUCTO",public."PRECIO_PRODUCTO",public."PREPARACION",
  public."ENTREGA",public."DETALLE_ENTREGA",public."MOVIMIENTO_EXCEDENTE",
  public."OFERTA_EXCEDENTE",public."IMPUTACION_ENTREGA_ADICIONAL" TO uc07_owner;
-- Privilegio mínimo de UPDATE para SELECT ... FOR UPDATE/SHARE en las raíces;
-- owner NOLOGIN no se concede a roles operativos.
GRANT UPDATE("idCliente") ON public."CLIENTE" TO uc07_owner;
GRANT UPDATE("idPedido") ON public."PEDIDO" TO uc07_owner;
GRANT UPDATE("numeroDetalle") ON public."DETALLE_PEDIDO" TO uc07_owner;
GRANT UPDATE("idExcedente") ON public."EXCEDENTE" TO uc07_owner;
GRANT UPDATE("idProducto") ON public."PRODUCTO" TO uc07_owner;
GRANT UPDATE("idPrecio") ON public."PRECIO_PRODUCTO" TO uc07_owner;

GRANT SELECT ON public."OFERTA_EXCEDENTE",public."COTIZACION_OFERTA_EXCEDENTE",
  public."EVIDENCIA_ACEPTACION_OFERTA",public."COMANDO_AUXILIAR_UC07",
  public."MOVIMIENTO_EXCEDENTE",public."IMPUTACION_ENTREGA_ADICIONAL",
  public."PEDIDO",public."DETALLE_PEDIDO",public."EXCEDENTE",public."PRODUCTO",
  public."PRECIO_PRODUCTO",public."ENTREGA",public."DETALLE_ENTREGA" TO uc07_gateway;
GRANT INSERT ON public."OFERTA_EXCEDENTE",public."COTIZACION_OFERTA_EXCEDENTE",
  public."EVIDENCIA_ACEPTACION_OFERTA",public."COMANDO_AUXILIAR_UC07",
  public."MOVIMIENTO_EXCEDENTE",public."IMPUTACION_ENTREGA_ADICIONAL",
  public."DETALLE_PEDIDO",public."ENTREGA",public."DETALLE_ENTREGA" TO uc07_gateway;
GRANT UPDATE("respuesta","fechaHoraRespuesta","cantidadAceptada","importeAceptado")
  ON public."OFERTA_EXCEDENTE" TO uc07_gateway;
GRANT UPDATE("estadoEvidencia") ON public."EVIDENCIA_ACEPTACION_OFERTA" TO uc07_gateway;
GRANT UPDATE("cantidadDisponible","costoHistoricoDisponible") ON public."EXCEDENTE" TO uc07_gateway;
GRANT UPDATE("estado") ON public."PEDIDO" TO uc07_gateway; -- cierre UC05 guardado, no reapertura
-- ACL mínima del subgrafo UC07/adicionales; NO configura todo UC05/finanzas/stock.
-- Sus restantes permisos y escritores necesitan revisión propia y campaña C3.
-- Ningún UPDATE/DELETE de cotizaciones, eventos, comandos, movimientos o imputaciones.
-- Ningún INSERT de eventos ni tablas privadas, ni acceso a hashes de sesión.

DO $acl$
DECLARE r record; firma text; secuencia text;
BEGIN
  secuencia:=pg_get_serial_sequence('public."EVENTO_ESTADO_EVIDENCIA_OFERTA"','idEvento');
  IF secuencia IS NULL THEN RAISE EXCEPTION 'Identidad de evento ausente'; END IF;
  EXECUTE format('REVOKE ALL ON SEQUENCE %s FROM PUBLIC,uc07_runtime,uc07_gateway',secuencia);
  FOR r IN SELECT n.nspname,p.proname,oidvectortypes(p.proargtypes) AS argumentos
    FROM pg_proc p JOIN pg_namespace n ON n.oid=p.pronamespace
    WHERE n.nspname='public' AND p.proname ~ '^fn_uc07_'
  LOOP
    firma:=format('%I.%I(%s)',r.nspname,r.proname,r.argumentos);
    EXECUTE format('ALTER FUNCTION %s OWNER TO uc07_owner',firma);
    EXECUTE format('REVOKE ALL ON FUNCTION %s FROM PUBLIC,uc07_runtime,uc07_gateway',firma);
  END LOOP;
END;
$acl$;
GRANT EXECUTE ON FUNCTION public.fn_uc07_abrir_contexto(uuid,text,bigint,bigint,bigint,uuid,text,text)
  TO uc07_gateway;
~~~

Antes de usar el bloque ACL debe verificarse que la familia fn_uc07_ contiene **solo** los objetos nuevos catalogados; si hay objetos homónimos/preexistentes, detener y versionar el plan en vez de cambiarles propietario. Las funciones internas/triggers son del owner y no EXECUTE de gateway; fn_uc07_evento_guard permanece SECURITY INVOKER. Su inserción legítima ocurre bajo el AFTER SECURITY DEFINER, cuyo current_user es owner. No se otorgan SUPERUSER, propiedad, SET ROLE owner ni capacidad de deshabilitar triggers. El migrador conserva sus privilegios administrativos separados, sin excepción cotidiana a la historia.

**Bloqueo F8:** gateway es un canal privilegiado del servidor, no una identidad humana. Spring debe autenticar Bearer real, validar ámbito y prevalidar E/D, y usar ese canal únicamente desde la operación autorizada. La función SQL comprueba existencia/vigencia/rol de la sesión declarada; quien posea credenciales gateway y conozca otra sesión válida podría atribuirle la operación. No prueba posesión del Bearer, no sustituye controles Java y no se considera resuelto el puente confiable. Deben ratificarse distribución/aislamiento de credenciales, límites del actor de amenaza, auditoría de todos los grants efectivos y alternativa de autenticación SQL verificable si se exige resistencia a escritores con esas mismas credenciales. No se concede identidad mediante GUC o idUsuario libre.


## 16. Compatibilidad con línea base G0

64 CU y 67 firmas principales intactos. Parte A registrarOfertaExcedente(Long,Long,BigDecimal) y Parte B registrarRespuestaOfertaExcedente(Long,Boolean,BigDecimal) conservadas; no se agregan IDs de cotización/evidencia a esas firmas. Ambas auxiliares de CR-C subordinadas y solo VENDEDOR=D; FK a actor no amplía RBAC ni concede rol ADMIN aprobador.

ck_oferta_excedente_3, migraciones V1/V2/V3, contratos REV04B, manifiestos, RBAC, source-lock y RDs anteriores intactos. No se ejecuta SQL ni crea migración real. TotalOriginal y cantidadOriginal originales no cambian; línea técnica D1-B solo al aceptar dentro de Parte B, sin nueva preparación de excedentes. Se preservan cargo UC-05 y separación de efectivo en tránsito; no modificación de CR-B0-F04-001.

## 17. Coordinación cruzada CR-C ↔ CR-F

### 17.1. Datos y tipos

CR-C coordinada: [PR #47](https://github.com/leandrito369/ale-milanesas/pull/47), HEAD C2 `9c0a54e4a2147f5f048f7827f26a21b1bfeecf1b` (HEAD C1 `0b75eb4ca32db9481e22a34c80eb637b80351a31`) (base C1 `7a4887d0c447c7ee82ce0c729d9360b8cbc1c661`; antecedente Etapa B `06bf800cdbfab9eedebe5a7a79e32269df01e63f`), leído desde ese commit. Esta rama solo modifica su CR-F; no incluye cambios del archivo de CR-C.

| Elemento | CR-C | CR-F candidata | Coincide |
|---|---|---|---|
| idCotizacion | UUID servidor RATIFICADO B | UUID PK/FK | Sí; mecanismo concreto pendiente |
| idEvidencia | UUID servidor RATIFICADO B | UUID PK | Sí, no autorización de implementación |
| idComandoAuxiliar | UUID servidor RATIFICADO B, registro interno | UUID PK COMANDO_AUXILIAR_UC07 | Sí, sin exigir exposición HTTP |
| idEvento | BIGINT identidad PostgreSQL RATIFICADO B | BIGINT GENERATED ALWAYS AS IDENTITY | Sí, no UUID |
| Replay | resultadoHistorico + estadoActual; reautorización | Recibo inmutable, lectura actual consistente y permisos vigentes | Sí, D ESPECIFICADA PARA RATIFICACIÓN |
| Evidencia utilizable única | Índice conjunto por oferta | uq_evidencia_utilizable_por_oferta, VERIFICADA/UTILIZADA | Sí, candidato F especificado C2, no ratificado |
| codigoOferta | Identidad estable padre | Derivación sobre datos originales protegidos | Sí; no columna obligatoria nueva |
| codigoCotizacion | String de versión | CHAR(64) hex candidato | Sí conceptual; canonización comercial definitiva pendiente, distinta de huella D |
| numeroVersion | int salida | INTEGER positivo y UNIQUE por oferta | Sí; correlativo bajo lock padre candidato §15.7, prueba C3 pendiente |
| numeroIntentoEvidencia | Por oferta, prevalidación no consume, replay no incrementa | INTEGER NOT NULL >0 + UNIQUE(oferta,intento), lock padre | Sí, RATIFICADA C |
| cantidadConfirmada | Entrada validada BigDecimal | NUMERIC(18,3), cotejo con cotización | Sí |
| importeConfirmado | Entrada no autoritativa | NUMERIC(18,2), igualdad/cálculo servidor | Sí |
| fechaHoraMensaje | OffsetDateTime declarada | TIMESTAMPTZ | Sí; D especifica UTC/microsegundos exactos; tolerancia comercial pendiente |
| fechaHoraRegistro | Salida servidor | TIMESTAMPTZ servidor | Sí |
| Estados evidencia | Cuatro estados/transiciones, terminales | CHECK + eventos + transición controlada propuesta | Sí, cuerpos §15.7–15.8 candidatos, no probados |
| Idempotency-Key | §10 C1: 1–128 ASCII, huella versionada y replay | COMANDO_AUXILIAR_UC07, VARCHAR(128)/CHECK, respuestaOriginal | Sí, D especificada NO ratificada |
| Límites de archivo | 1 MiB app/2 MiB físico/4096² experimentales | ck_evidencia_no_vacia conservado, sin techo definitivo | Sí; E especificada NO ratificada |
| Actor vendedor | Principal autenticado | FK USUARIO y eventos del gateway | Sí; F8 bloqueante, FK/sesión declarada no prueban Bearer |
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
| Inmutabilidad | Snapshot, versiones, evidencia/eventos | Triggers/operaciones controladas/permisos especificados en §13; cuerpos candidatos §15.6–15.13, F8 pendiente | F08,F15,F27,F35,F36,F54 |
| F6-A, aceptación separada de entrega | Oferta/evidencia/cotización/movimiento/saldo/prueba histórica | Diferidos §15.9/15.11 releen final; sin DETALLE_ENTREGA ni imputación | F24,F43,F64 |
| F6-B, entrega posterior UC05 | ENTREGA/DETALLE_ENTREGA e IMPUTACION existentes V1 | §15.10 con FK/UNIQUE V1; parcial/cantidad/importe/cronología; sin doble imputación | F65,F66 |
| Frontera de identidad | Gateway aislado y contexto privado candidato | §13.6/§15.13 distinguen identidad Java de sesión declarada; bloqueo F8 | F69 |
| Históricos/preflight | Ruta uniforme elegida después | §14; lock previo a aserción vacía; no columnas ausentes ni precio inventado | F55,F56,F61,F70,F71 |
| Rechazo/confirmación final | Oferta/movimiento/stock/evidencia | Rechazo sin evidencia, serialización y rollback Parte B | F24–F28,F42,F43 |

Compatibilidad C2 cotejada contra SHA CR-C 9c0a54e4a2147f5f048f7827f26a21b1bfeecf1b: A/B/C RATIFICADAS por decisión expresa del responsable; D/E ESPECIFICADAS PARA RATIFICACIÓN sin cambiar su texto; F/G ESPECIFICADAS PARA REVISIÓN/RATIFICACIÓN, F8 bloqueante; H ABIERTA para C3. No reabrir tipos/identidad/FK compuesta/intentos como elecciones técnicas aún no tomadas. Pendientes: contratos auxiliares/rutas y ratificación D/E, límites calibrados, ratificación/revisión de funciones/privilegios y F6-A/F6-B, ejecución autorizada del preflight y elección uniforme de legado, matriz global/generadores y campaña C3. #85/#86 MERGED no equivalen a UC-07 implementado ni RT-UC07-04 cerrada.

## 18. Plan de pruebas PostgreSQL/Testcontainers

Todas las filas F siguen **PLAN DE PRUEBAS DE LA IMPLEMENTACIÓN DEFINITIVA, NO ACREDITADO COMO SUITE COMPLETA**. Corte 3 tuvo ensayos R/P parciales descritos en adenda/§12, sin equivalencia automática con todos estos IDs; C1/C2 no ejecutan PostgreSQL ni implementan esos servicios. B0 documental no ejecuta estos escenarios. Precondiciones aluden a un futuro entorno descartable autorizado con esquema candidato definitivo, datos sintéticos y actores correctos; no a producción. IDs F locales a esta CR.

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
| F10 | A ratificada, implementación futura | Crear oferta/V1 y fallar entre inserciones | Cantidad/importe iguales, ambas o ninguna | Cotización |
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
| F62 | Parte A y triggers C2 | Insertar oferta sin V1 / V1 incoherente / ambas correctas | Fallo al commit en dos primeros; commit completo solo en tercero | F1/F2/diferidos |
| F63 | Cadena CAPTURADA→VERIFICADA→UTILIZADA | Revisar eventos anteriores y último; inducir fallo de AFTER/DELETE | Pasados válidos conservados; último=estado final; rollback si falta evento | F3/F4 |
| F64 | Aceptación sin ninguna entrega | Parte B con evidencia, movimiento, saldo y técnica; omitir/alterar un efecto | Commit íntegro sin ENTREGA/IMPUT; rechazo si efecto falta o discrepa | F6-A |
| F65 | Oferta aceptada y entrega UC05 posterior | Imputar a otro pedido/producto, dos veces o sobre cantidad; caso parcial válido | FKs/UNIQUE y diferidos rechazan inválidos; parcial correcto según política autorizada | F6-B |
| F66 | Varios movimientos aceptados del mismo producto | Entregar originales primero y adicionales en orden; saltar uno o usar importe total en porción parcial | Rechazo fuera de cronología/cantidad/importe; propuesta parcial revisada con UC05 | F6-B |
| F67 | Precio/producto con oferta histórica | UC19 cierra hacia futuro; modifica P/inicio o cierre anterior a oferta; UC48 cambia activo | Cierre prospectivo y activo permitidos; historia alterada rechazada; V1 activo intacto | F7 |
| F68 | Recibo O1/O2 y efecto nuevo/ajeno | Falta recibo, otro recurso/actor, JSON arbitrario, excepción antes de commit | Vínculo privado y huella rechazan; JSON mínimo servidor; rollback completo | F5 |
| F69 | Conexiones gateway/runtime/owner reales | DML/EXECUTE directo, inserción evento, GUC e intento de suplantar idSesion | Runtime denegado; cuantificar límite gateway y decidir puente confiable, sin falso positivo de autenticación | F8 |
| F70 | Esquema V1–V3 sin snapshot | Ejecutar solo preflight descartable | No se referencia columna inexistente; extensión parcial detiene inventario | G1 |
| F71 | Ruta vacía autorizada en sandbox y escritor concurrente | INSERT antes/durante ACCESS EXCLUSIVE; abortar aserción/ALTER | Lock precede aserción, esquema determinista y rollback sin extensión parcial; sin fallback | G2/G3 |
| F72 | Legado certificado y fila NULL no certificada | Rechazo/no-op, intento de aceptar o falsificar marca | Solo cierres aprobados; no P inventado; nuevos incompletos/aceptación no demostrada fallan | G4 |
| F73 | PG17.11 y roles/esquema completos | Compilar todos los cuerpos, revisar columnas, permisos y funciones SQL | Errores materiales corregidos antes de certificar; parser/B0 no son sustituto | F9/C3 |
| F74 | Intercalados §12.5 y escritores reales/prototipos separados | Contexto, triggers, FK K y advisory A2(70702,hash), generadores y UC05/06/41 | Grafo real registrado, ambos órdenes, fallos inyectados, resultados R/P y namespaces inventariados; RT04 sigue abierta hasta evidencia suficiente | H/C3 |

**Revisión estática efectuada C2:** lectura de nombres/FKs contra V1 y análisis gramatical con pglast 7.22 (gramática PostgreSQL 17.7) de los bloques nuevos, incluidos 22 cuerpos PL/pgSQL. No se ejecutó CREATE, DDL, función, trigger, consulta destino ni Testcontainers. El parser no resuelve tablas/tipos/permisos ni verifica ejecución en PostgreSQL 17.11; **compilación y comportamiento no probados**, F62–F74 sin ejecutar. Los tests B0 verifican gobierno documental, no garantías SQL.

Ampliaciones del plan: fallos y versión antigua V2 con evidencia aún válida tras emitir V3 sin aceptación; cruce con UC-05/06 y UC-28, distintos pedidos/excedentes, replay tras cierre/revocación, purga idempotente, restore y comparación de huellas. Definir timeouts/instrumentación y reproducibilidad de intercalados, confirmar cantidad de pruebas ejecutadas y resultados en CI del SHA funcional. No marcar RT-UC07-04 cerrada por el mero diseño ni confundir pruebas ya existentes de UC-19 con estas.

## 19. Riesgos, exclusiones y criterios de autorización

Riesgos bloqueantes: correlación temporal/producto insuficiente con FK simple; pares snapshot nulos históricos; incoherencia entre límite aplicativo/físico; heredados sin fuente exacta de P; duplicados semánticos no detectables solo por hash; mecanismos C2 candidatos no compilados/probados; F8, ACL y campaña C3 pendientes pese a ensayos parciales anteriores del índice/guardias; relojes coincidentes sin orden; eventos/estado no atómicos; ciclos por invertir PEDIDO/PRODUCTO; purga prematura de claves; escrituras privilegiadas fuera del servicio; identidad manual no autenticada; borrado de datos personales frente a historial terminal. Cada uno requiere solución verificable antes de autorizar, no aprobación por omisión.

**Para autorizar:** revisión del responsable y cruzada con PR #47; respetar A–C ratificadas (UUID/BIGINT identidad, V1/O1, FK compuesta, intentos) sin reabrirlas; ratificar D/E; revisar/ratificar F/G candidatos, incluida separación F6-A/F6-B, fórmula parcial UC05, objetos privados y puente de identidad F8; elegir ruta G tras inventario y completar H/C3 (generadores existentes, namespace 70702, correspondencia producto/precio e índice conjunto), mecanismo físico de inmutabilidad/auditoría, retención y recibos de idempotencia, calibración y política documental, tratamiento de históricos, diseño suficiente RT-UC07-04, privilegios/seguridad y plan de pruebas. Compatibilidad conjunta demostrada y autorización expresa con fecha/alcance reales. No exigir CR-C mergeada para redactar esta CR-F ni crear dependencia circular entre merges.

Aprobar diseño no equivale a ejecutar pruebas. #85 de UC-03 y #86 de UC-19 ya están integradas; no conservarlas como fixes pendientes. Pruebas globales definitivas pertenecen a C3/corte funcional antes de su merge conforme las RDs. Merge documental de CR-F no autoriza automáticamente crear/ejecutar migración. Issue #28 sigue bloqueando producción; no levantar pausa, perfiles o flags.

**EXCLUIDAS:** implementación UC-07, corrección UC-03, SQL ejecutado, creación de V4 u otra migración, cambio V1/V2/V3, Java/tests/configuración de aplicación, source-lock, contratos/manifiesto/catálogo/RBAC G0, otras RDs/CRs, modificación del archivo de PR #47 en esta rama o merge de ambas PR, autorización de CR-C/CR-F, envío de mensajes y despliegue. Único archivo modificado en esta rama existente: esta CR-F; los bloques SQL son documentación candidata no ejecutada.

## 20. Firmas

**Redactada por:** Codex, agente técnico, para revisión cruzada del responsable.

**Fecha de redacción:** 11/11/2026.

**Estado:** OPEN / DRAFT — NO AUTORIZADA INTEGRALMENTE — NO CREA MIGRACIONES.

**Responsable de autorización:** Victor Leandro Machado (`leandrito369`).

**Constancia de ratificación parcial:** A–C por Victor Leandro Machado, 12/11/2026, según decisión expresa del encargo C1. **Firma y fecha de autorización integral:** PENDIENTES, no atribuidas. **Implementación y despliegue:** NO AUTORIZADOS por este documento.
