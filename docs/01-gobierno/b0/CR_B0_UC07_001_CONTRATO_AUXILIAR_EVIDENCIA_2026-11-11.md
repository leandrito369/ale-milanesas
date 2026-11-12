# CR-B0-UC07-001 — Extensión contractual auxiliar de UC-07

## 1. Identificación, estado y autoridad

**Clase:** Solicitud de Cambio Contractual (CR-C)

**Estado:** OPEN / DRAFT — NO AUTORIZADA INTEGRALMENTE — NO HABILITA IMPLEMENTACIÓN

**Fecha de redacción:** 11/11/2026 (Argentina); no es fecha de autorización. **Historial Etapa B:** 12/11/2026, propuestas para revisión. **Actualización C1:** 12/11/2026, A–C ratificadas por el responsable; D–E candidatas; F–H pendientes. **Actualización C2:** F/G especificadas para revisión/ratificación (sin aprobación); H pendiente C3.

**Autoridad de autorización:** Victor Leandro Machado (`leandrito369`).

**Fundamento:** RD-UC07-001 y RD-UC07-002.

**Implementación:** NO AUTORIZADA. **Migraciones:** NO AUTORIZADAS.

**Despliegue:** PAUSADO — [Issue app #28](https://github.com/leandrito369/ale-milanesas-app/issues/28), abierta al verificar este corte.

### Fuentes efectivas y auditoría previa

| Fuente | SHA / comprobación |
|---|---|
| Gobierno origin/main | `cdd57ed194268f1f5ab29aa0f55781ddddebdfb5`, coincide con base del encargo |
| Aplicación origin/main | `d5f7607afb430a251cbf5cc9190a879a7d41416b`; checkout local conservado en `20ce82d` |
| G0 fuente y acta | `1263ffc17bd0eb7f3c69faaa9ff5ae556cf9de7e` / `27738b089afdd2698cdae915f75c0e8089a6248a` |
| RD-UC07-001 | [PR #45](https://github.com/leandrito369/ale-milanesas/pull/45), merge `914827585c2e9b050f1beffbf7b725d413dd6e7d` |
| RD-UC07-002 | [PR #46](https://github.com/leandrito369/ale-milanesas/pull/46), merge `cdd57ed`; ratificación parcial de cuatro decisiones, no autorización de CR |
| Numeración y duplicados | Sin CR_B0_UC07_001/002 en main, rama equivalente ni PR abierta equivalente encontradas antes de redactar |
| Worktrees iniciales | Limpios; esta CR se crea desde origin/main en rama documental nueva. App sin cambios de rama ni archivos |
| Última migración examinada | V3__trazabilidad_partidas_insumo.sql; V1/V2/V3 no incluyen las nuevas capacidades propuestas |

Referencias normativas relativas, al SHA de gobierno de la tabla:

- [RD-UC07-001](RD_UC07_001_PROPUESTA_EXCEDENTES_FISICOS_2026-11-09.md), D1–D5, reservas y §8; [RD-UC07-002](RD_UC07_002_EVIDENCIA_ACEPTACION_OFERTA_2026-11-10.md), §§5, 6, 7, 8, 10, 11, 14 y 15.
- [Contratos G0 REV04B](../../08-diagramas/consolidacion-b0/CONTRATOS_REV04B_CORREGIDOS_B0_ACTUALIZADO.md), §5 Parte A y §6 Parte B; [matriz RBAC](B0_MATRIZ_RBAC_67_OPERACIONES_CIERRE_2026-10-29.csv), filas UC-07; [manifiesto canónico](G0_MANIFIESTO_CANONICO_67_OPERACIONES_2026-10-29.csv), ambas operaciones principales.
- [RD-UC19-002](RD_UC19_002_ACOTAMIENTO_VIGENCIAS_FUTURAS_2026-11-01.md) y [RD-RP022-001](../RD_RP022_001_COSTEO_CONVERSIONES_REDONDEOS_2026-10-27.md).

Referencias técnicas en app al SHA `d5f7607afb430a251cbf5cc9190a879a7d41416b`, no modificaciones propuestas por este archivo:

- [V1](https://github.com/leandrito369/ale-milanesas-app/blob/d5f7607afb430a251cbf5cc9190a879a7d41416b/src/main/resources/db/migration/V1__baseline_mr5.sql), PEDIDO L138, OFERTA_EXCEDENTE L243, PRECIO_PRODUCTO L292 y exclusión GiST L1041: máximo un precio no cancelado por producto/instante, no garantía de existencia. Oferta conserva importes escala 2; no contiene todavía snapshot ni evidencia/cotizaciones versionadas.
- [ActualizarPrecioVigenteService](https://github.com/leandrito369/ale-milanesas-app/blob/d5f7607afb430a251cbf5cc9190a879a7d41416b/src/main/java/ar/edu/unam/alemilanesas/maestros/ActualizarPrecioVigenteService.java), L62–155: PRODUCTO FOR UPDATE, reloj PostgreSQL, lock asesor 1919001, precio y auditoría atómicos; coordinación futura RT-UC07-04.
- [SeguridadHttpInterna](https://github.com/leandrito369/ale-milanesas-app/blob/d5f7607afb430a251cbf5cc9190a879a7d41416b/src/main/java/ar/edu/unam/alemilanesas/web/SeguridadHttpInterna.java): API stateless Bearer, PrincipalInterno(idSesion,idUsuario), roles/sesión vigentes, no-store y códigos de autenticación.
- [RegistrarPrecioProductoHttpController](https://github.com/leandrito369/ale-milanesas-app/blob/d5f7607afb430a251cbf5cc9190a879a7d41416b/src/main/java/ar/edu/unam/alemilanesas/web/RegistrarPrecioProductoHttpController.java): campos permitidos, BigDecimal, no-prod, flag y respuesta 201/no-store; [PrecondicionesDespliegue](https://github.com/leandrito369/ale-milanesas-app/blob/d5f7607afb430a251cbf5cc9190a879a7d41416b/src/main/java/ar/edu/unam/alemilanesas/web/PrecondicionesDespliegue.java): veto de escrituras experimentales en prod.

No se encontraron contradicciones normativas bloqueantes en este corte. Las elecciones aún abiertas quedan señaladas como propuestas antes de autorización, no como reglas ya implementadas.

### Actualización C1 — hechos verificados y autoridad (12/11/2026)

**HECHO VERIFICADO:** gobierno origin/main sigue `cdd57ed194268f1f5ab29aa0f55781ddddebdfb5`; aplicación main vigente `4dbe38668fc5cbc08d04e10920e3bf165c71be11`. El checkout app local se preserva en `20ce82d0ce564b77034aba97e0eef8b3fd75e684`, solo lectura; no se confunde con la base vigente. Las referencias d5f7607 de auditoría anterior se conservan como históricas.

- [PR app #85](https://github.com/leandrito369/ale-milanesas-app/pull/85) **MERGED**, merge `a07fd95bc0e8910c5b81efbe4253e959fc45e23f`: [CargarPedidoService L69](https://github.com/leandrito369/ale-milanesas-app/blob/4dbe38668fc5cbc08d04e10920e3bf165c71be11/src/main/java/ar/edu/unam/alemilanesas/ventas/CargarPedidoService.java#L69) ya filtra cantidadOriginal>0 al reconstruir items. No se mantiene el fix como pendiente; no implica validar UC-07.
- [PR app #86](https://github.com/leandrito369/ale-milanesas-app/pull/86) **MERGED**, merge `4dbe38668fc5cbc08d04e10920e3bf165c71be11`: [ActualizarPrecioVigenteService L84](https://github.com/leandrito369/ale-milanesas-app/blob/4dbe38668fc5cbc08d04e10920e3bf165c71be11/src/main/java/ar/edu/unam/alemilanesas/maestros/ActualizarPrecioVigenteService.java#L84) usa pg_advisory_xact_lock(1919,1), conservando PRODUCTO U y coordinación de IDs precio/auditoría. Corrección **IMPLEMENTADA/INTEGRADA** para ese defecto puntual; no orden global aprobado.
- **PROBADO según informe del Corte 3 reportado el 12/11/2026:** 3/3 deadlocks 40P01 con servicios reales anteriores y seis intercalados correctos con namespace separado; ensayos P parciales de UC-07/UC-41, separados de Nivel R. El informe registró 24 tests experimentales y 24 existentes finales aprobados; no certifica servicios UC-07 terminados. No se reejecuta esa campaña en C1. Informe completo/ZIP fueron artefactos temporales de Codex, **no se afirma que estén versionados**.
- [INC-UC19](https://github.com/leandrito369/ale-milanesas-app/blob/4dbe38668fc5cbc08d04e10920e3bf165c71be11/docs/traceability/INC_UC19_DEADLOCK_UC03_UC19_2026-11-12.md) y prueba permanente `PrecioProductoUc03DeadlockIntegrationTest` son antecedentes de #86. El INC conserva rótulos históricos «DRAFT / no integrado»; el estado real posterior comprobado en GitHub es MERGED. No se corrige ese archivo desde estas CR ni se infiere cierre formal global.
- **RATIFICADO:** A–C por decisión expresa del responsable comunicada en este encargo C1. **PROPUESTO PARA RATIFICACIÓN:** D/E. **PENDIENTE DE PRUEBA/DECISIÓN:** F/G/H y orden global UC-05/06/07/28/41; RT-UC07-04 **ABIERTA**. Issue #28 **OPEN**, despliegue PAUSADO.

Publicación/merge documental, ratificación parcial, autorización integral, implementación, prueba y despliegue son estados distintos. No hay autorización integral de estas CR ni implementación UC-07 por este corte.

## 2. Problema y justificación contractual

G0 registra la oferta y posteriormente confirma o rechaza la respuesta. El diseño ratificado de evidencia durable y versiones comerciales requiere capacidades adicionales: generar y conservar cotizaciones antes de la aceptación, registrar respaldo binario, declaración del vendedor, conformidad y su historial.

Se propone una extensión contractual no disruptiva de dos operaciones subordinadas a UC-07. La aclaración complementaria ratificada en RD-UC07-002 §5 permite presentar esta CR sin afirmar imposible preservar G0 y sin modificar retrospectivamente RD-UC07-001 §8. Ausencia de columnas no implica necesidad de cambiar firmas principales. Presentar esta solicitud no significa autorizarla.

## 3. Decisiones ratificadas y pendientes

| Elemento | Estado y límite |
|---|---|
| D1–D5 y RT-UC07-01 | Ratificadas en RD-UC07-001; producto inactivo no genera nueva oferta, trigger intacto; casos históricos específicos siguen sujetos a su aclaración |
| D-UC07-02-B | Snapshot precioBaseUnitarioAplicado e idPrecio con FK obligatorios para nuevas ofertas, diseño ratificado; mecanismo físico y datos previos pendientes |
| D-UC07-COT | Versionado explícito ratificado; entidad, identificadores, estados adicionales y algoritmos definitivos sujetos a CR-F/CR-C |
| D-UC07-CRC | Extensión no disruptiva ratificada como orientación; esta CR sigue NO AUTORIZADA |
| D-UC07-P2B | Contenido original PostgreSQL, PNG/JPEG para evaluación MVP; límites definitivos y admisión sujetos a evaluación/CR-F |
| O2 y sustitución | Registro previo independiente; nueva evidencia válida sustituye atómicamente, emisión sola no invalida |
| Contratos/HTTP de esta CR | A–C ratificadas en C1; endpoints/firmas auxiliares definitivas y D/E requieren autorización/ratificación posterior |
| RD-UC07-002 integral | Pendiente de ratificación documental según fuente; cuatro decisiones parcialmente ratificadas no equivalen a documento integral autorizado |
| CR-F / RT-UC07-04 / UC-03 | CR-F #48 OPEN/DRAFT; referencia examinada C2 `4105e60bd7ac35b089c683e206a95aec9ae77fd6`; #85 y #86 MERGED; RT-UC07-04 ABIERTA, sin implementación UC-07 |

Distinguir decisión arquitectónica ratificada, diseño contractual propuesto, CR presentada, CR autorizada, implementación realizada y despliegue autorizado. Ninguna etapa implica automáticamente la siguiente.

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

## 4. Operación emitirCotizacionOfertaExcedente

### Contrato conceptual candidato

```java
CotizacionEmitida emitirCotizacionOfertaExcedente(
    Long idOfertaExcedente,
    BigDecimal cantidadCotizada
);

record CotizacionEmitida(
    UUID idCotizacion,
    int numeroVersion,
    String codigoCotizacion,
    BigDecimal cantidadCotizada,
    BigDecimal importeCalculado,
    OffsetDateTime fechaHoraGeneracion
) {}
```

UUID servidor está RATIFICADO por B en C1; implementación concreta de generación aún pendiente, sin imponer UUID.randomUUID(). int para versión debe contrastarse con generadores/límites. Autenticación se obtiene del contexto servidor conforme §8; firma de dominio definitiva se adaptará a las convenciones del proyecto. No aceptar precio, importeCalculado o idUsuarioVendedor del cliente como autoridad comercial.

**Responsabilidad y precondiciones:** VENDEDOR autorizado y ámbito revalidado; oferta existente PENDIENTE; pedido receptor PENDIENTE y demás condiciones canónicas de cliente/producto. cantidadCotizada positiva, representable como NUMERIC(18,3), no superior a cantidadOfrecida; no redondear silenciosamente cantidades ni usar punto flotante binario. D §10.2 especifica como candidato normalización exacta sin pérdida de ceros superfluos y rechazo de fracciones no representables; no redondeo de entrada.

**Cálculo exclusivo del servidor:** P de OFERTA_EXCEDENTE.precioBaseUnitarioAplicado y tipo/porcentaje congelados en PEDIDO del receptor. Snapshot e idPrecio deberán existir válidamente tras CR-F; no suplirlos con precio actual ni invertir importeInformado. No ejecutar UC-15/UC-16 ni consultar de nuevo categoría. Preservar exactamente importeInformado en cotización por toda la cantidad original, incluida V1, conforme D2-A.

Para parcial q y porcentaje r, fórmula ratificada:

```java
BigDecimal subtotal = q.multiply(P).setScale(2, RoundingMode.HALF_UP);
BigDecimal ajuste = subtotal.multiply(r)
    .divide(new BigDecimal("100"), 2, RoundingMode.HALF_UP);
// SIN_AJUSTE: subtotal (ajuste cero)
// DESCUENTO: subtotal.subtract(ajuste)
// RECARGO: subtotal.add(ajuste)
```

Mantener orden escalonado, escala comercial 2, precisión/rango NUMERIC(18,2) e importe positivo. No prorratear el total inicial redondeado ni usar P2 de UC-19. Si falta snapshot, hay inconsistencia histórica, overflow o importe cero incompatible con V1, rechazar sin cotización inventada; CR-F debe resolver históricos, no esta operación por fallback.

**Postcondiciones:** asignar versión sin colisiones, persistir cantidad, importe, código, instante servidor y usuario solicitante; devolver condiciones comunicables antes de registrar conformidad. No crear evidencia, reservar/transferir stock, crear líneas técnicas, modificar cantidadOriginal, totalOriginal o deuda ni invalidar evidencia VERIFICADA anterior. Oferta sigue PENDIENTE. El instante de generación no prueba envío o recepción WhatsApp.

**Identificadores:** codigoOferta es identidad estable de oferta padre; codigoCotizacion identifica una versión. SHA-256 es orientación de identificación, no evidencia de comunicación. Serialización, componentes ordenados, separadores, escalas, precisión/zona temporal, codificación, unicidad y reintentos deben quedar acordados con CR-F. No se ratifica aquí un algoritmo definitivo.

### Primera cotización y semántica de O1 — A RATIFICADA el 12/11/2026

**RATIFICADA por Victor Leandro Machado en C1; sin autorización de implementación:** Parte A crea internamente OFERTA_EXCEDENTE y V1 en una sola transacción: numeroVersion=1, cantidadCotizada=cantidadOfrecida e importeCalculado=importeInformado. Un fallo de V1 revierte la oferta completa. La firma y salida principales G0 permanecen intactas; no se infiere idempotencia de Parte A por cantidad ni se le agrega una clave contractual sin autorización.

Separar tres comportamientos, también en el adaptador HTTP:

| Intención | Semántica propuesta |
|---|---|
| Consultar/recuperar V1 o una versión identificada | Lectura autorizada sin escritura, nueva versión ni comando de emisión; su ruta/proyección de consulta sigue pendiente de definición y autorización. La versión de la evidencia VERIFICADA puede ser anterior a la más reciente; no hay un estado físico de cotización «vigente» inferido por MAX(numeroVersion) |
| Nueva emisión O1 | POST crea numeroVersion>=2 para cantidad parcial estrictamente menor que cantidadOfrecida y mayor que cero, usando D2-A. Con otra clave es una nueva intención comercial, aunque repita cantidad parcial; no es replay. Petición nueva por cantidad total: 409 candidato, orientar al flujo de consulta, sin devolver V1 silenciosamente. Cantidad superior/escala inválida: 400 |
| Replay O1 | Mismo Idempotency-Key, ámbito y payload: recuperar efecto original, sin nueva versión ni nueva fecha; verificar clave existente antes de aplicar reglas de una emisión nueva. Recibo histórico y situación actual separados (§10), con reautorización |

La alternativa de emisión V1 posterior a Parte A queda **EXCLUIDA de la política A ratificada en C1**, conservada como antecedente comparativo: permitiría un intervalo con oferta sin V1 y exigiría otro flujo de bloqueo/comunicación. No se introduce una tercera operación principal. Probar fallo entre oferta/V1, unicidad V1, consulta sin emisión, total no convertido en replay, parcial repetida con clave distinta y replay con misma clave.

## 5. Operación registrarEvidenciaAceptacionOferta

### Firma y salida conceptuales candidatas

```java
EvidenciaRegistrada registrarEvidenciaAceptacionOferta(
    UUID idCotizacion,
    BigDecimal cantidadConfirmada,
    BigDecimal importeConfirmado,
    String canalComunicacion,
    String referenciaContacto,
    byte[] contenidoOriginal,
    String tipoMimeContenido,
    String declaracionIdentidadVendedor,
    OffsetDateTime fechaHoraMensaje
);

record EvidenciaRegistrada(
    UUID idEvidencia,
    UUID idCotizacion,
    String estadoEvidencia,
    String huellaContenido,
    OffsetDateTime fechaHoraRegistro
) {}
```

UUID servidor está RATIFICADO por B en C1; byte[] describe contenido conceptual, no exige cargar solicitudes sin límite en memoria. El principal del servidor determina usuario/sesión responsables; no incluir idUsuarioVendedor controlado por HTTP. nombreArchivoOriginal es metadato opcional no semántico conservado en CR-F, no ruta ni detector; no se agrega a esta firma ni se exige desde HTTP. tipoMimeDeclarado procede de la parte multipart y tipoMimeContenido de la detección servidor (§10/E).

**Datos estructurados que deben conservarse:** cotización, oferta padre derivada/verificada, cantidad, importe, canal, contacto cotejado, fecha/hora declarada del mensaje, fecha/hora servidor de registro, bytes originales, MIME declarado y detectado/validado, SHA-256 servidor, declaración, usuario autenticado, estado y eventos. CR-F debe garantizar pertenencia cotización/oferta, no asumir que dos FKs independientes bastan.

**Precondiciones y validaciones:** cotización existente, oferta padre y pedido PENDIENTE, acceso por objeto y VENDEDOR. Cantidad idéntica a la versión comercial y dentro de rango/escala 3; importe idéntico numéricamente en escala 2 al de esa versión calculado por servidor y coherente con D2-A. Recalcular con P/ajuste originales para detectar inconsistencias, nunca con precio vigente actual. Los campos confirmados son declaraciones a contrastar, no autoridad comercial. Rechazar incoherencia, no editar cotización histórica para acomodarla al mensaje.

El respaldo debe permitir relacionar cliente/contacto, cotización, cantidad, importe y conformidad afirmativa. Declaración con al menos 20 caracteres no blancos y componentes de canal, contacto, relación con cliente y verificación declarada. La longitud no prueba identidad. El servidor valida estructura/datos; el vendedor declara auditablemente significado e identidad del respondedor. VERIFICADA no significa autenticación criptográfica ni comprensión automática de una captura; no se crea un segundo aprobador. Evidencia UTILIZADA/INVALIDADA no vuelve a habilitar transferencia (§6/10).

**Tiempo esperado:** fechaHoraGeneracionCotizacion <= fechaHoraMensaje <= fechaHoraRegistroServidor. Mensaje es declarado, registro es servidor; generación no prueba envío real. Propuesta: offsets explícitos, comparar instantes UTC a microsegundos exactos según §10.2, sin truncar; TIMESTAMPTZ conserva el instante y no el offset textual de entrada; rechazar fechas incoherentes. Tolerancia por reloj/canal y tratamiento de discrepancias deben autorizarse; no inventar tolerancia ni corregir silenciosamente. Su diseño es requisito antes de autorizar.

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

**Salida y postcondiciones:** evidencia registrada y técnicamente/comercialmente validada, CAPTURADA → VERIFICADA con eventos; si sustituye, aplicar §6. Respuesta mínima sin binario ni datos personales innecesarios. No confirma aceptación física, reserva stock ni devenga deuda.

## 6. Flujo O2, transacciones y sustitución

1. Generar/persistir cotización antes de registrar aceptación; vendedor comunica condiciones y obtiene conformidad verificable por mensaje.
2. O2 registra nueva evidencia en transacción independiente de Parte B. Bloquea recursos en orden global pendiente, revalida sesión/ámbito/estados, integridad, datos comerciales, declaración y vínculo con cotización.
3. Si no resulta válida, rechazar sin invalidar anterior. Rechazo previo a persistencia por MIME, corrupción, tamaño o formato **no consume numeroIntentoEvidencia**. Todo intento efectivamente persistido, incluso INVALIDADA o posteriormente sustituido, conserva su número histórico. No guardar contenido peligroso ni efectuar commits parciales para sortear un rechazo.
4. Solo tras validación exitosa, invalidar anterior VERIFICADA por SUPERADA_POR_RECOTIZACION, registrar nueva CAPTURADA → VERIFICADA y todos sus eventos dentro de **una transacción**. Si falla inserción, evento o transición, rollback completo conserva anterior. La anterior pasa a INVALIDADA antes de pasar la nueva a VERIFICADA; un único índice parcial conjunto por oferta sobre los estados VERIFICADA/UTILIZADA impide también su coexistencia entre distintas filas (§13).
5. Parte B posterior resuelve una única evidencia VERIFICADA vinculada a oferta/cotización y cantidad/importe. Ejecuta transferencia, actualiza oferta y pasa evidencia a UTILIZADA con evento como unidad atómica.
6. Si falla por disponibilidad física concurrente, rollback Parte B: sin transferencia, incremento aceptado ni consumo de evidencia; la previamente registrada sigue VERIFICADA.

La sustitución **no se posterga hasta Parte B**. Emitir V3 sin nueva conformidad no invalida E2 VERIFICADA de V2; E2 puede utilizarse si no fue sustituida y todos los estados, cantidades, importes y disponibilidad siguen válidos. No seleccionar automáticamente versión comercial más alta. O2 y Parte B deben serializarse para evitar sustituir mientras se consume.

Estados de evidencia preservados: CAPTURADA → VERIFICADA/INVALIDADA, VERIFICADA → UTILIZADA/INVALIDADA; UTILIZADA e INVALIDADA terminales. Cada transición conserva usuario, instante, origen/destino y motivo. No adoptar estados de cotización EMITIDA/ACEPTADA/RECHAZADA/SUPERADA ni índices basados en ellos sin definir responsabilidades separadas de conformidad y transferencia.

**Rechazo:** registrarRespuestaOfertaExcedente(idOfertaExcedente,false,null) no exige evidencia de aceptación y no transfiere stock ni incrementa compromiso comercial. Propuesta a autorizar: invalidar CAPTURADA/VERIFICADA aún vigentes con motivo OFERTA_RECHAZADA y eventos dentro de la misma transacción que cierra oferta; terminales quedan intactos. Fallo revierte cierre/invalidaciones. Cierre confirmado impide usar pendientes para otra transferencia; no borrar historial.

## 7. Contratos HTTP propuestos

Son candidatos no implementados; requieren autorización y validación de convenciones del proyecto. Para ambos, propuesta de Idempotency-Key conforme §10, autenticación Bearer y Cache-Control: no-store en éxitos y errores.

### Cotización

```http
POST /api/v1/ofertas-excedente/{idOfertaExcedente}/cotizaciones
Authorization: Bearer <token>
Idempotency-Key: <clave-de-operacion>
Content-Type: application/json

{"cantidadCotizada": 3.000}
```

201 Created candidato:

```json
{
  "idCotizacion": "550e8400-e29b-41d4-a716-446655440000",
  "numeroVersion": 2,
  "codigoCotizacion": "<sha256-de-la-version>",
  "cantidadCotizada": 3.000,
  "importeCalculado": 30000.00,
  "fechaHoraGeneracion": "2026-11-11T14:30:00-03:00"
}
```

Valores ilustrativos; no precio/importe unitario impuestos por cliente. Proponer esquema estricto de campos permitidos, rechazo de duplicados/extraños/trailing tokens y BigDecimal como patrón del controlador UC-19. IDs/rango y errores candidatos §9. No se aprueba aún ruta de consulta/descarga adicional.

### Evidencia

```http
POST /api/v1/cotizaciones/{idCotizacion}/evidencias
Authorization: Bearer <token>
Idempotency-Key: <clave-de-operacion>
Content-Type: multipart/form-data; boundary=<limite>
```

Partes candidatas: contenidoOriginal (binario y Content-Type declarado), cantidadConfirmada, importeConfirmado, canalComunicacion, referenciaContacto, fechaHoraMensaje y declaracionIdentidadVendedor. Definir metadatos textuales con codificación inequívoca; rechazar partes/campos duplicados o desconocidos y límites excedidos. MIME detectado y hash los genera el servidor, no se aceptan como prueba desde el cliente.

201 Created candidato con idEvidencia, idCotizacion, estadoEvidencia, huellaContenido y fechaHoraRegistro, conforme record de §5. No devolver documento, contacto, declaración, costos internos ni secretos. Un reintento idempotente no requiere otra transferencia ni nueva versión; status de replay a autorizar según §10.

## 8. RBAC, autenticación y protección HTTP

Ambas auxiliares exclusivamente VENDEDOR=D; otros roles NR, sin herencia ADMIN. Una cuenta multirrol debe poseer VENDEDOR y superar los controles; el mero rol ADMIN no basta. No modificar la matriz principal para añadir estas operaciones: su registro de extensión será posterior a autorización.

Usar Bearer interno y PrincipalInterno del servidor conforme SeguridadHttpInterna; verificar sesión, cuenta, roles y ámbito del objeto también en servicio, revalidando después de esperas relevantes. No aceptar usuario por parámetros; cookie sola no autentica la API. Las rutas propuestas son stateless Bearer y deben conservar esa frontera: no desactivar globalmente CSRF ni alterar la cadena web con cookies/CSRF. Multipart no constituye excepción de autenticación. Pruebas negativas de cookie sola, sesión inválida/revocada y cambio de contraseña pendiente.

Futura implementación HTTP condicionada a @Profile("!prod"), flags de escritura false por defecto, matchers explícitos y veto equivalente en PrecondicionesDespliegue. Nombres de flags aún por definir verificando convenciones ale.http.writes; no se agregan aquí. Probar gate apagado, producción, permisos y acceso por objeto, incluyendo no filtrar existencia antes de autorizar. Issue #28 sigue bloqueando despliegue; estas propuestas no habilitan endpoints, perfiles ni flags.

Lectura/descarga de evidencias exige política propia de autorización y protección de datos con CR-F; no se concede por inferencia un GET público. Límites efectivos antes de recepción descontrolada, acceso restringido y ausencia de contenido personal/binario/tokens en logs. Hashes de sesión, claves y detalles SQL no se exponen.

## 9. Errores y respuestas candidatas

Proponer cuerpo JSON mínimo {"codigo":"..."}, no-store y mensajes sin contenido documental, SQL o datos de autenticación. Se reutilizan códigos existentes cuando aplican; los específicos siguientes son candidatos, no nuevos literales ya aprobados.

| Situación | HTTP candidato | Código / justificación |
|---|---|---|
| Solicitud, rango o partes inválidas | 400 | SOLICITUD_INVALIDA; no truncar |
| Clave idempotente ausente/duplicada/inválida | 400 | IDEMPOTENCY_KEY_INVALIDA, candidato D |
| Escala decimal no representable exactamente | 400 | ESCALA_DECIMAL_INVALIDA, candidato D |
| Contenido inválido o inseguro | 400 | CONTENIDO_INVALIDO propuesto; sin eco de bytes |
| Mayor al límite efectivo aprobado | 413 | EVIDENCIA_DEMASIADO_GRANDE propuesto |
| Sesión ausente/inválida | 401 | SESION_INVALIDA; patrón Bearer/WWW-Authenticate existente |
| Sin rol o sin gate de autorización aplicable | 403 | OPERACION_PROHIBIDA; permisos/gate según cadena real |
| Oferta/cotización inexistente o no visible | 404 | RECURSO_NO_DISPONIBLE propuesto, tras autorización y sin distinguir existencia protegida; política por objeto pendiente de revisión |
| Oferta/pedido fuera de estado | 409 | ESTADO_INCOMPATIBLE propuesto |
| Cantidad/importe no coinciden con versión | 409 | COTIZACION_DISCREPANTE propuesto; conflicto de condiciones, distinto de rango 400 |
| Evidencia duplicada | 409 o replay | EVIDENCIA_DUPLICADA propuesto; mismo comando se trata según §10 |
| UTILIZADA o INVALIDADA para nuevo consumo | 409 | EVIDENCIA_NO_UTILIZABLE propuesto; no reactivar |
| Misma clave con payload diferente | 409 | IDEMPOTENCY_KEY_PAYLOAD_MISMATCH, reemplaza CLAVE_IDEMPOTENCIA_CONFLICTIVA |
| Conflicto comercial de estado/versión | 409 | CONFLICTO_CONCURRENCIA, no lock_timeout de infraestructura |
| Espera transaccional excedida / indisponibilidad transitoria operativa | 503 preferente | OPERACION_TEMPORALMENTE_NO_DISPONIBLE, condiciones Retry-After/reintento de §10.5 |
| Espera concluida con clave/payload idénticos | 200 | Replay con resultadoHistorico y estadoActual, §10 |
| Dependencia temporalmente indisponible | 503 | AUTENTICACION_NO_DISPONIBLE existente para autenticación; código específico de dependencia solo si se justifica, sin disfrazar defecto permanente como 503 |

Si el recurso es visible pero no pertenece a la oferta/cotización declarada, aplicar 409 de correspondencia; si el solicitante no puede conocerlo, aplicar política uniforme 404/403 que se autorice sin filtración. Orden de autorización, códigos definitivos y mapeo de fallos de infraestructura requieren autorización; no exponer hashes secretos, tokens ni claves de idempotencia en errores.

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

## 11. Compatibilidad G0

Se preservan expresamente, sin modificación de los contratos canónicos:

```java
registrarOfertaExcedente(
    Long idExcedente,
    Long idPedidoReceptor,
    BigDecimal cantidadOfrecida
)

registrarRespuestaOfertaExcedente(
    Long idOfertaExcedente,
    Boolean aceptada,
    BigDecimal cantidadAceptada
)
```

64 CU y 67 operaciones/firmas principales intactos, catálogo y matriz RBAC principal intactos, sin ampliación a otros roles. Dos auxiliares propuestas subordinadas, no nuevos CU principales ni reemplazo de operaciones G0. El manifiesto de extensiones corresponde a autorización/documentación posterior; no modificar el canónico actual ni CONTRATOS_REV04B.

La conformidad documental se incorpora como control subordinado de Parte B conforme D3-B; no se añaden idCotizacion, importe ni binario a su firma. Se resuelve por evidencia inequívoca de la oferta; ambigüedad rechaza. No alterar totalOriginal, cantidades originales ni costos históricos, no recalcular categoría, no devengar deuda al ofertar o cotizar. Regresión UC-03: corrección #85 ya integrada y presente en main; no queda como fix pendiente. Casos históricos de productos desactivados conservan sus reservas; no se autorizan excepciones aquí.

## 12. Matriz de pruebas contractuales

Para todos los escenarios de esta matriz C: **PROPUESTOS, NO EJECUTADOS COMO SUITE CONTRACTUAL UC-07**. Los ensayos parciales R/P del Corte 3 son antecedentes separados (adenda C1), no acreditan ejecución completa de estas filas ni implementación UC-07. Los controles documentales del PR no son ejecución HTTP, PostgreSQL o negocio. IDs C de esta CR tienen alcance local; no renumeran el catálogo de RD-UC07-002.

| ID | Escenario y resultado esperado |
|---|---|
| C01 | VENDEDOR autorizado emite cotización, con respuesta mínima y versión persistida |
| C02 | Otros roles, incluido ADMIN sin VENDEDOR, reciben 403 |
| C03 | Oferta/pedido no PENDIENTE rechazados, sin efectos |
| C04 | Cantidad inválida, exceso de escala o superior a ofrecida rechazados |
| C05 | Servidor calcula importe; campos de importe/precio/usuario no permitidos rechazados |
| C06 | Cambio UC-19 posterior no modifica cotización/snapshot previos |
| C07 | Parte A crea oferta/V1 atómicamente; fallo al insertar V1 revierte ambas; cantidad/importe iguales al padre |
| C08 | Nueva versión sin aceptación conserva evidencia anterior VERIFICADA |
| C09 | Nueva evidencia inválida conserva previa, incluso ante fallo de evento/inserción |
| C10 | Nueva evidencia válida sustituye atómicamente, con eventos y sin ventana confirmada |
| C11 | Parte B exitosa utiliza evidencia inequívoca, incluso de versión anterior no sustituida |
| C12 | Fallo concurrente de stock revierte Parte B y conserva evidencia VERIFICADA |
| C13 | Rechazo sin evidencia, sin transferencia; invalidación trazable de pendientes atómica |
| C14 | Reintento HTTP y concurrencia misma clave no generan versión extra; payload distinto produce 409 |
| C15 | Reenvío, duplicado documental y duplicado semántico no crean doble consumo; política INVALIDADA probada |
| C16 | Cotización/oferta/cliente ajenos rechazados sin filtración ni vínculos cruzados |
| C17 | Archivos inválidos/MIME discordante y exceso de límite aprobado rechazados; bytes/huella recuperables |
| C18 | no-store en éxito/error y ausencia de datos sensibles en cuerpo/logs |
| C19 | Gate false, no-prod, matchers y veto producción; cookie sola y sesión inválida no autentican |
| C20 | Sustitución concurrente con Parte B/emisión/rechazo serializada sin doble uso ni deadlock |
| C21 | Fecha declarada fuera de relación temporal o discrepancia de precisión rechazada según política aprobada |
| C22 | Descuento/recargo/sin ajuste, fronteras escala/rango/cero y doble redondeo reproducibles |
| C23 | Replay tras INVALIDADA/UTILIZADA devuelve recibo histórico separado del estado actual, sin consumo; sesión/rol/ámbito revocados impiden recibo |
| C24 | Consulta V1 sin emisión; POST total con nueva clave no devuelve V1; parcial con nueva clave emite >=2; misma clave/payload es replay |
| C25 | Rechazo previo de archivo/formato no consume intento; persistida INVALIDADA conserva número; unicidad por oferta, no por cotización |
| C26 | Escritor SQL operativo intenta cotización excesiva, confirmación discrepante, cambio de snapshot/bytes o evento sin transición: protección física rechaza |
| C27 | Índice conjunto rechaza VERIFICADA+UTILIZADA por oferta; sustitución y paso VERIFICADA→UTILIZADA mantienen unicidad |
| C28 | Histórico sin snapshot puede cerrarse legítimamente según política aprobada sin CHECK retroactivo; oferta nueva incompleta se rechaza |
| C29 | Imagen peligrosa rechazada antes de transacción de escritura; límites provisionales coherentes y recuperación SHA-256 íntegra |
| C30 | Claves ASCII 1/128 válidas; vacía, duplicada, espacios, Unicode o 129 rechazadas; HTTP y SQL alineados |
| C31 | Vectores de canonización de campos/NULL/UTF-8, ceros exactos y offsets equivalentes; fracciones no representables rechazadas sin redondeo |
| C32 | Timeout de infraestructura produce 503 candidato y reintento con misma clave; distinto payload conserva 409 específico |
| C33 | Límites request/app/DB y presupuestos de lector, corrupción/firmas PNG-JPEG y recuperación no-store sin fuga de metadatos |
| C34 | Sin purga automática/TTL en MVP; eliminación excepcional impide reejecutar clave; permisos de recibo revalidados |
| C35 | Commit de oferta sin V1 falla por diferido; insertar ambas en orden permitido confirma |
| C36 | F6-A acepta sin ENTREGA/imputación; F6-B comprueba después entrega parcial/originales/adicionales y no doble imputación |
| C37 | Estado final y último evento coinciden sin exigir que eventos históricos igualen el presente; fallo auditoría revierte todo |
| C38 | Gateway/sesión no equivalen a Bearer: roles/ACL y frontera Java se prueban expresamente en C3 |
| C39 | Preflight V1-V3 no consulta snapshots ausentes; aserción vacía bajo lock aborta ante INSERT concurrente |

Además, generadores y carreras entre distintas ofertas/excedentes requieren PostgreSQL/Testcontainers y evidencia CI del SHA funcional. No se ejecutan servicios ni DDL mediante este documento.

## 13. Coordinación con CR-F presentada

La CR física es **CR-B0-UC07-002, [PR #48](https://github.com/leandrito369/ale-milanesas/pull/48), OPEN/DRAFT/NO AUTORIZADA**, archivo `docs/01-gobierno/b0/CR_B0_UC07_002_EVIDENCIA_ACEPTACION_OFERTA_2026-11-11.md`. Referencia examinada al comenzar C2 `4105e60bd7ac35b089c683e206a95aec9ae77fd6` (C1; antecedentes Etapa B e78f154/115f494); CR-F actualizará su referencia al nuevo SHA publicado de esta CR-C, sin inventar un SHA futuro de CR-F. No se inventa el SHA futuro de CR-F. No está pendiente de preparación. Revisión conjunta previa a autorización, sin exigir merges previos recíprocos.

| Estado contractual vigente | Correspondencia en CR-F |
|---|---|
| A RATIFICADA: V1 interna, O1 parcial >=2, consulta separada/replay | Oferta+V1 mismo commit; versión única por oferta y filas inmutables; comando atómico para emisión auxiliar |
| B RATIFICADA: tipos y pertenencia | UUID servidor idCotizacion/idEvidencia/idComandoAuxiliar; idEvento BIGINT mediante identidad PostgreSQL. UNIQUE(oferta,cotización) y FK compuesta desde evidencia |
| C RATIFICADA: intento por oferta | INTEGER NOT NULL >0, UNIQUE(oferta,intento), asignación bajo lock padre; prevalidación rechazada sin fila/número, INVALIDADA conserva historia |
| D ESPECIFICADA PARA RATIFICACIÓN: recibo y estado actual | COMANDO_AUXILIAR_UC07 inmutable, claves/efecto atómicos; lectura actual separada sin mutar recibo y sin eludir permisos |
| E ESPECIFICADA PARA RATIFICACIÓN: archivos | P2b, MIME declarado/detectado, SHA-256; 1 MiB app/2 MiB físico/4096² experimentales; calibración y presupuestos, sin CHECK definitivo |
| F ESPECIFICADA C2 (NO RATIFICADA): evidencia utilizable única | `uq_evidencia_utilizable_por_oferta` único parcial WHERE estadoEvidencia IN ('VERIFICADA','UTILIZADA'); no dos índices separados como garantía equivalente |
| F ESPECIFICADA C2 (NO RATIFICADA): integridad cruzada / auditoría | Triggers BEFORE INSERT/UPDATE/DELETE según entidad y permisos SQL: producto–precio–vigencia–snapshot; cantidad y cálculo cotizado; igualdad confirmada; bytes/hashes inmutables, terminales y evento obligatorio. Servicio solo no basta |
| G ESPECIFICADA C2 (NO RATIFICADA): históricos | CR-F §14: preflight y ruta determinista; ante históricos detener ruta vacía y decidir tratamiento específico. No una misma migración con esquemas divergentes por datos; no CHECK NOT VALID no nulo que bloquee cierre legítimo |
| H PENDIENTE C3: concurrencia | CR-F §12: matriz real UC-03/19/28, contratos UC-05/06/41, protocolo propuesto A/O1/O2/B y experimento Corte 3; RT-UC07-04 ABIERTA |

Para G, revisión de V1–V3 y fixtures/tests versionados de app no halló INSERT de OFERTA_EXCEDENTE, lo cual **no certifica tabla vacía en destinos**. No inventar P desde importe ni usar precio actual. Ofertas históricas sin fuente exacta no admiten nueva cotización/evidencia ni aceptación automática; un rechazo legítimo autorizado conserva nulos históricos sin bloqueo retroactivo, sin rechazar masivamente por conveniencia migratoria.

F C2 desarrolla esos cuerpos candidatos, con F6-A de aceptación y F6-B de entrega posterior. No se exige IMPUTACION_ENTREGA_ADICIONAL en Parte B. G C2 corrige inventario de columnas ausentes y propone aserción bajo ACCESS EXCLUSIVE, sin ejecutar ni elegir ruta. Los detalles y bloqueos se explicitan en §13.1.

Para H, Corte 3 confirmó el ciclo anterior UC-03/19 y #86 lo corrigió en main 4dbe386. La matriz de CR-F §12 mantiene candidato CLIENTE→PEDIDO→DETALLE_PEDIDO→EXCEDENTE→PRODUCTO→PRECIO→OFERTA→COTIZACION→EVIDENCIA, con coordinación de claves/generadores antes cuando corresponda y eventos/recibos al final. Recursos/modos por operación y FKs/triggers siguen pendientes de pruebas globales UC-05/06/07/28/41. No se impone bloquear todas las tablas; RT-UC07-04 ABIERTA. No se modifica app ni PR #85/#86.

No anticipar número Flyway ni editar migraciones. Cuerpos candidatos/privilegios de F y estrategia G se especifican en C2; deben ratificarse y probarse en C3, junto con el límite de identidad y parámetros E. No se declara SQL compilado, ejecutado ni comportamiento probado.

### 13.1. Corte C2 — F/G especificadas como candidatas; no autorizadas

Fuentes verificadas al iniciar C2: gobierno main cdd57ed194268f1f5ab29aa0f55781ddddebdfb5; aplicación main 4dbe38668fc5cbc08d04e10920e3bf165c71be11; CR-C 0b75eb4ca32db9481e22a34c80eb637b80351a31 y CR-F 4105e60bd7ac35b089c683e206a95aec9ae77fd6. #85/#86 MERGED, #28 OPEN, worktrees limpios. A–C ratificadas se preservan; bloques D/E de C1 se conservan íntegros como candidatos pendientes de ratificación.

**Corrección expresa de F6 durante C2 (responsable, 12/11/2026):** adoptar como alternativa técnica preferente dos momentos de verificación; el mecanismo definitivo requiere ratificación y PostgreSQL/Testcontainers. No es autorización funcional ni cambio de G0:

| Momento | Garantía candidata al commit | Relación con V1 |
|---|---|---|
| F6-A — UC07 Parte B | Oferta ACEPTADA, única evidencia UTILIZADA de su cotización, cantidades/importes iguales, un REASIGNACION de la oferta/excedente, costo y saldo atómicos, detalle receptor original o técnico | No exige ENTREGA, DETALLE_ENTREGA ni IMPUTACION_ENTREGA_ADICIONAL al aceptar |
| F6-B — UC05 posterior | Detalle de entrega e imputaciones del receptor/movimiento correctos; cantidad efectivamente entregada, sin doble imputación ni exceso, originales primero y adicionales cronológicos | fk_imputacion_entrega_adicional_0 apunta a DETALLE_ENTREGA y _1 a MOVIMIENTO_EXCEDENTE; uq_imputacion_entrega_adicional_0 se conserva |

La exigencia anterior de imputación inmediata era incompatible con esas FKs y REV04B §2 L97/L105 y §6 L251. RD-UC07-001 §§4.1/4.4 prevé **futura** entrega adicional; no se fabrica una entrega en Parte B ni se alteran contratos/FKs para acomodar un trigger. Cantidad/importe imputados pueden ser inferiores a lo aceptado; el criterio candidato de valoración parcial D2-A y sus redondeos requiere revisión conjunta UC05. El caso completo conserva importeAceptado.

**F propuesta:** CR-F §§13/15.6–15.13 contienen funciones fn_uc07_..., triggers BEFORE/AFTER y constraint triggers diferidos, sin límite artificial de cuatro disparadores. Se protegen padres comerciales, bytes/MIME/nombre opcional/huellas y estados terminales; O2 registra NULL→CAPTURADA y CAPTURADA→VERIFICADA. Se relee estado final/último evento, no se exige que cada evento histórico iguale el estado actual. Parte A no puede confirmar oferta sin única V1. Los recibos se vinculan al efecto nuevo de la misma transacción y conservan los nombres D.

SQL usa PRECIO_PRODUCTO.precioBase NUMERIC(18,4) y snapshot precioBaseUnitarioAplicado; conserva ck_oferta_excedente_3 y fk_oferta_excedente_0/1/2 (la _2 es vendedor). Guardias selectivas permiten respuesta PENDIENTE→ACEPTADA/RECHAZADA, no-op sin alterar historia, cierre prospectivo de precio UC19 y cambio activo UC48. No verifican que el precio siga vigente hoy al responder. El veto V1 para insertar una línea técnica de producto inactivo y su reserva funcional permanecen.

Se proponen tres registros privados adicionales, sujetos a aprobación física: contexto de transacción, prueba inmutable de saldo/costo de transferencia y registro de legado certificado. El saldo de una aceptación vieja no se compara con el saldo actual después de futuros descartes. El hash físico usa sha256(bytea) de PostgreSQL 17, sin suponer pgcrypto; decodificación/recursos de imágenes siguen en Java conforme E.

**Bloqueo F8:** rol runtime sin DML sensible, gateway SQL privilegiado del módulo Java y owner/migrador separados. El contexto protegido evita GUC manipulable por runtime; **no convierte idSesion/idUsuario en prueba de posesión de Bearer**. Spring sigue autenticando y autorizando ámbito. Quien posea credencial gateway podría atribuir otra sesión válida: la aceptación del límite, aislamiento/credenciales y ACL efectivas o una capacidad SQL verificable siguen pendientes. F no se declara completamente cerrada.

**G propuesta:** primero inventariar estructura y estados existentes, sin SELECT de idPrecio/precioBaseUnitarioAplicado ausentes en V1–V3. Contar snapshots nulos solo si existen las dos columnas y su extensión fue autorizada. Preflight administrativo separado de migración; C2 no consulta destinos. Ruta vacía candidata: ACCESS EXCLUSIVE antes de aserción y ALTER, misma transacción Flyway, NOT NULL y aborto ante filas inesperadas; no fallback ni promesa de cero downtime. Ruta legado alternativa: esquema uniforme nullable/guardias y lista protegida aprobada, nunca precio inventado/rechazo masivo ni CHECK NOT VALID global no nulo. Ninguna ruta se elige en C2.

**Estado de prueba:** SQL candidato revisado estáticamente; compilación y comportamiento en PostgreSQL NO PROBADOS. B0 documental no los ejecuta. C3 debe validar cuerpos, privilegios reales, límite de identidad, cierres/no-op/legado, orden/FKs implícitas, recibos/replay, transferencias y entrega posterior con UC03/19 corregida/28/05/06/07/41. RT-UC07-04 ABIERTA; sin implementación, migración, merge ni despliegue.


## 14. Criterios de autorización

1. Revisión formal del responsable, consistencia con RD-UC07-002 y resolución expresa de cualquier contradicción; no se altera esa RD aquí.
2. Respetar A–C ya RATIFICADAS el 12/11/2026; resolver reintentos Parte A, ruta/proyección de consulta y firmas auxiliares finales sin reabrir sus políticas ni modificar G0.
3. Aprobar firmas definitivas y tipos coordinados con CR-F, entradas/salidas estrictas, temporalidad, cantidades, errores y códigos HTTP.
4. Ratificar o corregir expresamente D ya especificada en §10: clave/huella/protocolo, replay, errores, retención/duplicados; completar horizonte calendario y parámetros operativos pendientes.
5. Ratificar o corregir E, medir 20–30 archivos y aprobar límites/presupuestos/aislamiento; confirmar permisos, Bearer, gates/flags/veto y privacidad.
6. Acordar algoritmos de identificación/serialización y correspondencia histórica oferta/cotización/evidencia, transiciones y sustitución.
7. Revisar/ratificar F/G especificadas en C2, resolver F8 y políticas pendientes, y probar H en C3 con CR-F, generadores y locks implícitos; no declarar cerrado F por publicar cuerpos no probados. No se exige CR-F mergeada para preparar esta CR.
8. Cumplir las puertas de ratificación documental y autorizaciones del antecedente antes de iniciar implementación; pruebas reales son obligación del corte funcional, no evidencia ya adquirida por aprobar un diseño.
9. **Autorización expresa de Victor Leandro Machado**, registrando fecha y alcance reales cuando ocurra, nunca inferida de publicación o merge documental.

La publicación o merge de esta CR no representa automáticamente autorización. La ratificación parcial de arquitectura no aprueba endpoints definitivos; la autorización de desarrollar tampoco autoriza desplegar. Issue #28 y gates permanecen intactos.

## 15. Exclusiones, riesgos y firmas

Único artefacto modificado en la rama de PR #47: esta CR contractual. La rama existente de PR #48 actualiza solo su CR-F coordinadamente. Sin cambios a RDs, otras CRs, G0/manifiesto/catálogo/RBAC/source-lock, Java/tests de aplicación/SQL/migraciones, despliegue o habilitación HTTP. No se ejecuta DDL ni se envían mensajes reales.

Riesgos residuales: declaración manual no autentica remitente ni contenido; hash no prueba envío ni aceptación; archivos requieren inspección y límites; numeración/hash no sustituyen locks; retención idempotente y datos históricos requieren diseño; códigos/rutas y mecanismos físicos pendientes siguen candidatos; los tipos de B están ratificados en C1. Cualquier contradicción normativa posterior detiene la definición afectada hasta decisión expresa, sin modificar fuentes anteriores para hacerla desaparecer.

**Redactada por:** Codex, agente técnico, para revisión del responsable.

**Fecha de redacción:** 11/11/2026.

**Estado:** OPEN / DRAFT — NO AUTORIZADA INTEGRALMENTE — NO HABILITA IMPLEMENTACIÓN.

**Responsable que puede autorizar:** Victor Leandro Machado (`leandrito369`).

**Constancia de ratificación parcial:** A–C por Victor Leandro Machado, 12/11/2026, según decisión expresa del encargo C1. **Firma y fecha de autorización integral:** pendientes; no atribuidas. **Implementación, migraciones y despliegue:** no autorizados por esta solicitud.
