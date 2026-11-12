# CR-B0-UC07-001 — Extensión contractual auxiliar de UC-07

## 1. Identificación, estado y autoridad

**Clase:** Solicitud de Cambio Contractual (CR-C)

**Estado:** BORRADOR — NO AUTORIZADA — NO HABILITA IMPLEMENTACIÓN

**Fecha de redacción:** 11/11/2026 (Argentina); no es fecha de autorización. **Actualización coordinada Etapa B:** 12/11/2026, propuestas de diseño para revisión, sin ratificación final.

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
| Contratos/HTTP de esta CR | Propuestos; firmas definitivas, primera versión, errores, idempotencia y políticas pendientes de autorización |
| RD-UC07-002 integral | Pendiente de ratificación documental según fuente; cuatro decisiones parcialmente ratificadas no equivalen a documento integral autorizado |
| CR-F / RT-UC07-04 / UC-03 | CR-F presentada en [PR #48](https://github.com/leandrito369/ale-milanesas/pull/48), OPEN/DRAFT, referencia inicial `115f4948f47f9754118ba46f7c3ff8973ebe9930`; matriz RT-UC07-04 en su §12; fix UC-03/PR app #85 independiente |

Distinguir decisión arquitectónica ratificada, diseño contractual propuesto, CR presentada, CR autorizada, implementación realizada y despliegue autorizado. Ninguna etapa implica automáticamente la siguiente.

### Matriz A–H — convergencia del 12/11/2026

Las decisiones A–H siguientes **no son RATIFICACIÓN EXPRESA FINAL**. Su fundamento ratificado no autoriza automáticamente sus mecanismos.

| Decisión | RATIFICADA EN RD (fundamento) | PROPUESTA PREFERENTE (CONVERGENCIA ETAPA B) | PENDIENTE / BLOQUEANTE DE AUTORIZACIÓN |
|---|---|---|---|
| A | Versiones y extensión subordinada | V1 atómica interna; O1 separa consulta, emisión parcial >=2 y replay | Aprobación de semántica/ruta de consulta y reintento Parte A |
| B ajustada | Procedencia e identidad vinculadas | UUID servidor para cotización/evidencia/comando; evento BIGINT identidad; FK compuesta | Generadores, canonización de códigos y tipos contractuales definitivos |
| C | Evidencia durable e historial | Intento positivo no nulo por oferta, lock y UNIQUE; prevalidación sin consumo | Duplicados documentales/INVALIDADA y política de intentos persistidos fallidos |
| D | Evidencia y efecto auditables | Registro específico atómico; recibo inmutable + estado actual separado; reautorización | Formato/retención/tombstones, clave y huella canónica |
| E condicionada | P2b, PNG/JPEG para evaluación | 2 MiB provisional, validación segura previa a escritura y recuperación íntegra | Muestra 20–30, límites finales, privacidad y retención |
| F | O2 atómico, terminales e historial | Índice parcial conjunto, FK compuesta, triggers y permisos de protección cruzada | Detalle verificable de funciones/privilegios/actor e integridad de recibos |
| G | Snapshot obligatorio para nuevas ofertas | Dos ramas según certificación de datos; inserción estricta y actualización histórica diferenciada | Inventario destino, política de cierre/aceptación de legado y autorización |
| H | RT-UC07-04 continúa abierta | Matriz/protocolo y experimento Corte 3 en CR-F §12 | Orden y generadores de operaciones pendientes; colisiones advisory y pruebas reales no ejecutadas |

**EXCLUIDA:** implementación/DDL/migración/despliegue, autorización por esta actualización, cambios G0 y fix UC-03/PR #85. Las pruebas reales preceden al merge funcional; la suficiencia del diseño se revisa antes de autorizar, sin circularidad entre CR.

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

UUID es candidato compartido con CR-F, no tipo físico ratificado. int para versión debe contrastarse con generadores/límites. Autenticación se obtiene del contexto servidor conforme §8; firma de dominio definitiva se adaptará a las convenciones del proyecto. No aceptar precio, importeCalculado o idUsuarioVendedor del cliente como autoridad comercial.

**Responsabilidad y precondiciones:** VENDEDOR autorizado y ámbito revalidado; oferta existente PENDIENTE; pedido receptor PENDIENTE y demás condiciones canónicas de cliente/producto. cantidadCotizada positiva, representable como NUMERIC(18,3), no superior a cantidadOfrecida; no redondear silenciosamente cantidades ni usar punto flotante binario. En HTTP se propone rechazar exceso de escala siguiendo el patrón de la app; normalización exacta sin pérdida, si se adoptara, debe definirse antes de autorizar.

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

### Primera cotización y semántica de O1 — propuesta preferente A

**PROPUESTA PREFERENTE (CONVERGENCIA ETAPA B), NO AUTORIZADA:** Parte A crea internamente OFERTA_EXCEDENTE y V1 en una sola transacción: numeroVersion=1, cantidadCotizada=cantidadOfrecida e importeCalculado=importeInformado. Un fallo de V1 revierte la oferta completa. La firma y salida principales G0 permanecen intactas; no se infiere idempotencia de Parte A por cantidad ni se le agrega una clave contractual sin autorización.

Separar tres comportamientos, también en el adaptador HTTP:

| Intención | Semántica propuesta |
|---|---|
| Consultar/recuperar V1 o una versión identificada | Lectura autorizada sin escritura, nueva versión ni comando de emisión; su ruta/proyección de consulta sigue pendiente de definición y autorización. La versión de la evidencia VERIFICADA puede ser anterior a la más reciente; no hay un estado físico de cotización «vigente» inferido por MAX(numeroVersion) |
| Nueva emisión O1 | POST crea numeroVersion>=2 para cantidad parcial estrictamente menor que cantidadOfrecida y mayor que cero, usando D2-A. Con otra clave es una nueva intención comercial, aunque repita cantidad parcial; no es replay. Petición nueva por cantidad total: 409 candidato, orientar al flujo de consulta, sin devolver V1 silenciosamente. Cantidad superior/escala inválida: 400 |
| Replay O1 | Mismo Idempotency-Key, ámbito y payload: recuperar efecto original, sin nueva versión ni nueva fecha; verificar clave existente antes de aplicar reglas de una emisión nueva. Recibo histórico y situación actual separados (§10), con reautorización |

La alternativa de emisión V1 posterior a Parte A queda **EXCLUIDA del candidato preferente de Etapa B**, conservada como antecedente comparativo: permitiría un intervalo con oferta sin V1 y exigiría otro flujo de bloqueo/comunicación. No se introduce una tercera operación principal. Probar fallo entre oferta/V1, unicidad V1, consulta sin emisión, total no convertido en replay, parcial repetida con clave distinta y replay con misma clave.

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

UUID es candidato coordinado con CR-F, no decisión física ratificada; byte[] describe contenido conceptual, no exige cargar solicitudes sin límite en memoria. El principal del servidor determina usuario/sesión responsables; no incluir idUsuarioVendedor controlado por HTTP. Nombre original opcional, si se admite después, es metadato no confiable, no ruta de disco ni detector de formato.

**Datos estructurados que deben conservarse:** cotización, oferta padre derivada/verificada, cantidad, importe, canal, contacto cotejado, fecha/hora declarada del mensaje, fecha/hora servidor de registro, bytes originales, MIME declarado y detectado/validado, SHA-256 servidor, declaración, usuario autenticado, estado y eventos. CR-F debe garantizar pertenencia cotización/oferta, no asumir que dos FKs independientes bastan.

**Precondiciones y validaciones:** cotización existente, oferta padre y pedido PENDIENTE, acceso por objeto y VENDEDOR. Cantidad idéntica a la versión comercial y dentro de rango/escala 3; importe idéntico numéricamente en escala 2 al de esa versión calculado por servidor y coherente con D2-A. Recalcular con P/ajuste originales para detectar inconsistencias, nunca con precio vigente actual. Los campos confirmados son declaraciones a contrastar, no autoridad comercial. Rechazar incoherencia, no editar cotización histórica para acomodarla al mensaje.

El respaldo debe permitir relacionar cliente/contacto, cotización, cantidad, importe y conformidad afirmativa. Declaración con al menos 20 caracteres no blancos y componentes de canal, contacto, relación con cliente y verificación declarada. La longitud no prueba identidad. El servidor valida estructura/datos; el vendedor declara auditablemente significado e identidad del respondedor. VERIFICADA no significa autenticación criptográfica ni comprensión automática de una captura; no se crea un segundo aprobador. Evidencia UTILIZADA/INVALIDADA no vuelve a habilitar transferencia (§6/10).

**Tiempo esperado:** fechaHoraGeneracionCotizacion <= fechaHoraMensaje <= fechaHoraRegistroServidor. Mensaje es declarado, registro es servidor; generación no prueba envío real. Propuesta: offsets explícitos, comparar instantes normalizados a precisión PostgreSQL de microsegundos, conservar representación necesaria para auditoría, rechazar fechas incoherentes. Tolerancia por reloj/canal y tratamiento de discrepancias deben autorizarse; no inventar tolerancia ni corregir silenciosamente. Su diseño es requisito antes de autorizar.

**Archivos:** PNG/JPEG para evaluación inicial MVP; WebP/PDF diferidos, TXT no admitido como evidencia única sin garantías adicionales; ZIP/DOCX/ejecutables fuera de alcance. 2 MiB (2097152 bytes) y los umbrales aplicativos son candidatos provisionales, no límites finales: calibrar con 20–30 archivos antes de aprobar CR-F. Exigir lista blanca, firma binaria y decodificación real, dimensiones/memoria/solicitud limitadas, MIME consistente y contenido seguro. Guardar bytes originales sin transformaciones silenciosas; SHA-256 calculado sobre ellos y comprobable al recuperar. Huella no acredita remitente ni verdad. No persistir archivos inseguros como evidencia para justificar su rechazo. Recepción acotada, magic bytes y decodificación real con límites de dimensiones/memoria deben completarse **antes de abrir la transacción de escritura en BD**; luego se revalidan permisos/estados tras las esperas. El límite multipart/aplicativo configurable no puede exceder sin revisión el eventual techo físico defensivo de CR-F, aún no congelado.

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
| Solicitud, cantidad, escala o partes inválidas | 400 | SOLICITUD_INVALIDA; sintaxis/rango, no truncar |
| Contenido inválido o inseguro | 400 | CONTENIDO_INVALIDO propuesto; sin eco de bytes |
| Mayor al límite efectivo aprobado | 413 | EVIDENCIA_DEMASIADO_GRANDE propuesto |
| Sesión ausente/inválida | 401 | SESION_INVALIDA; patrón Bearer/WWW-Authenticate existente |
| Sin rol o sin gate de autorización aplicable | 403 | OPERACION_PROHIBIDA; permisos/gate según cadena real |
| Oferta/cotización inexistente o no visible | 404 | RECURSO_NO_DISPONIBLE propuesto, tras autorización y sin distinguir existencia protegida; política por objeto pendiente de revisión |
| Oferta/pedido fuera de estado | 409 | ESTADO_INCOMPATIBLE propuesto |
| Cantidad/importe no coinciden con versión | 409 | COTIZACION_DISCREPANTE propuesto; conflicto de condiciones, distinto de rango 400 |
| Evidencia duplicada | 409 o replay | EVIDENCIA_DUPLICADA propuesto; mismo comando se trata según §10 |
| UTILIZADA o INVALIDADA para nuevo consumo | 409 | EVIDENCIA_NO_UTILIZABLE propuesto; no reactivar |
| Misma clave con payload diferente | 409 | CLAVE_IDEMPOTENCIA_CONFLICTIVA propuesto |
| Concurrencia incompatible | 409 | CONFLICTO_CONCURRENCIA propuesto; sin 500 por conflicto esperable |
| Dependencia temporalmente indisponible | 503 | AUTENTICACION_NO_DISPONIBLE existente para autenticación; código específico de dependencia solo si se justifica, sin disfrazar defecto permanente como 503 |

Si el recurso es visible pero no pertenece a la oferta/cotización declarada, aplicar 409 de correspondencia; si el solicitante no puede conocerlo, aplicar política uniforme 404/403 que se autorice sin filtración. Orden de autorización, códigos definitivos y mapeo de fallos de infraestructura requieren autorización; no exponer hashes secretos, tokens ni claves de idempotencia en errores.

## 10. Idempotencia y concurrencia contractual

### Propuesta de comandos idempotentes, no política ya aprobada

Evaluar Idempotency-Key obligatoria en ambos POST, formato/acotación por definir sin inventar TTL. Vincularla a operación, oferta derivada, vendedor autenticado y huella canónica de solicitud. En evidencia incluir idCotizacion; la oferta se deriva y se comprueba. Misma clave/alcance/payload recupera el mismo resultado sin crear versión o intento adicional; misma clave y payload distinto, 409 controlado. Dos solicitudes concurrentes con la misma clave se serializan o esperan resultado confirmado, sin dos efectos. Registro durable de clave, efecto y respuesta deben ser atómicos en CR-F.

La huella canónica de emisión incluye cantidad e identificadores con escalas/representación definidas; la de evidencia incluye hash servidor de bytes y todos los metadatos semánticos admitidos. No usar bytes crudos del sobre multipart, orden de partes, boundary o token de sesión como identidad del comando. Definir normalización para distinguir cambios reales sin falsear igualdad. Clave no permite eludir autenticación: revalidar actor y ámbito antes de devolver datos.

**Propuesta preferente D:** COMANDO_AUXILIAR_UC07 persiste atómicamente efecto y recibo original inmutable. Replay 200 candidato con sobre explícito `replay: true`, `resultadoHistorico` (recibo/status/estado al ejecutar, sin reescribirlos) y `estadoActual` (estado real de oferta y, cuando corresponda, evidencia; lectura autorizada consistente al instante de respuesta). Una evidencia hoy INVALIDADA o UTILIZADA se informa así en estadoActual aunque el recibo histórico diga VERIFICADA. No se simula una nueva transición ni disponibilidad comercial; Parte B revalida bajo lock. Forma definitiva del sobre y status requieren autorización.

**En cada replay**, antes de devolver recibo o existencia, autenticar sesión vigente y reautorizar VENDEDOR/acceso al ámbito; el UUID o la clave no son credenciales. Si perdió acceso, 401/403/404 conforme política de privacidad, sin recibo ni nuevo efecto. Distinguir cierre comercial (puede haber replay de lectura autorizado) de permiso vigente. Si la lectura de estado concurrente no es coherente, no devolver estado obsoleto como actual.

Retención: decidir con responsable horizonte de reintentos HTTP/offline, vida comercial, auditoría/privacidad, tamaño y restauración; no fijar TTL arbitrario. Preferencia: no purgar identidad/huella/vínculo mientras exista riesgo de reenvío o deber de auditoría. Eventual reducción del recibo requiere política de tombstone que impida reejecutar claves vencidas y respuesta contractual expresa; nunca tratar purga como comando nuevo. Plazo, formato, limpieza excepcional, errores transitorios y canonización siguen bloqueantes de autorización; no se promete exactamente una vez ilimitado.

### Duplicados documentales y versiones

| Caso | Tratamiento propuesto para revisión |
|---|---|
| Reenvío técnico mismo comando | Mismo recibo, no nuevo intento ni nueva versión |
| Nuevo intento documental | Identidad de negocio distinta, solo si política lo permite; no se deduce por cada reenvío |
| Evidencia de otra cotización | Verificar vínculo y nueva conformidad; no reutilizar automáticamente archivo como aceptación de condiciones nuevas |
| Mismo archivo ya VERIFICADA/UTILIZADA | No duplicar aceptación ni consumo; replay solo si mismo comando, de otro modo evaluar 409 |
| Mismo archivo en INVALIDADA | No reactivar; recomendación de rechazo salvo nuevo intento expresamente permitido con motivo y vínculo verificable. Política final pendiente |
| Archivos diferentes, mismo mensaje | Hash distinto no demuestra aceptación diferente; controles de versión/correspondencia/estado evitan doble consumo |

**Propuesta preferente C:** separar numeroVersion comercial, numeroIntentoEvidencia y reintento HTTP. Intento secuencial positivo **por oferta**, NOT NULL, UNIQUE(idOfertaExcedente,numeroIntentoEvidencia); asignación bajo bloqueo de oferta padre. Replays no incrementan; rechazo antes de persistir no consume; INVALIDADA persistida conserva número y no se recicla. Un rollback no deja intento confirmado; no exigir secuencia global sin huecos ajenos a transacciones. No TTL comercial propio ni EXPIRADA adicional en OFERTA_EXCEDENTE.

RT-UC07-04 debe resolver orden global y compatibilidad UC-19/05/06/07/41, emisión/sustitución/Parte B, generadores y fallos. Snapshot inicial exige instante PostgreSQL posterior a locks relevantes, precio único no cancelado [desde,hasta), visibilidad MVCC coherente y captura atómica de valor/procedencia. Las auxiliares posteriores usan snapshot, no vuelven al precio actual. Índices parciales de evidencia no sustituyen autorización, locks o condición de oferta PENDIENTE.

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

La conformidad documental se incorpora como control subordinado de Parte B conforme D3-B; no se añaden idCotizacion, importe ni binario a su firma. Se resuelve por evidencia inequívoca de la oferta; ambigüedad rechaza. No alterar totalOriginal, cantidades originales ni costos históricos, no recalcular categoría, no devengar deuda al ofertar o cotizar. Regresión UC-03 y casos históricos de productos desactivados conservan reservas del antecedente, sin corregirlos ni autorizar excepciones aquí.

## 12. Matriz de pruebas contractuales

Para todos los escenarios: **ESPECIFICADA — NO IMPLEMENTADA — NO EJECUTADA — NO APROBADA**. Los controles documentales del PR no son ejecución HTTP, PostgreSQL o negocio. IDs C de esta CR tienen alcance local; no renumeran el catálogo de RD-UC07-002.

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

Además, generadores y carreras entre distintas ofertas/excedentes requieren PostgreSQL/Testcontainers y evidencia CI del SHA funcional. No se ejecutan servicios ni DDL mediante este documento.

## 13. Coordinación con CR-F presentada

La CR física es **CR-B0-UC07-002, [PR #48](https://github.com/leandrito369/ale-milanesas/pull/48), OPEN/DRAFT/NO AUTORIZADA**, archivo `docs/01-gobierno/b0/CR_B0_UC07_002_EVIDENCIA_ACEPTACION_OFERTA_2026-11-11.md`. Referencia inicial examinada `115f4948f47f9754118ba46f7c3ff8973ebe9930`; su actualización coordinada debe cotejar el nuevo SHA de esta CR-C, evitando referencias circulares a commits futuros. No está pendiente de preparación. Revisión conjunta previa a autorización, sin exigir merges previos recíprocos.

| Contrato preferente | Garantía física exigida a CR-F |
|---|---|
| A: V1 interna, O1 parcial >=2, consulta separada/replay | Oferta+V1 mismo commit; versión única por oferta y filas inmutables; comando atómico para emisión auxiliar |
| B: tipos y pertenencia | UUID servidor idCotizacion/idEvidencia/idComandoAuxiliar; idEvento BIGINT con secuencia/identidad. UNIQUE(oferta,cotización) y FK compuesta desde evidencia |
| C: intento por oferta | INTEGER NOT NULL >0, UNIQUE(oferta,intento), asignación bajo lock padre; prevalidación rechazada sin fila/número, INVALIDADA conserva historia |
| D: recibo y estado actual | COMANDO_AUXILIAR_UC07 inmutable, claves/efecto atómicos; lectura actual separada sin mutar recibo y sin eludir permisos |
| E: archivos seguros | Bytes originales P2b, MIME declarado/validado y SHA-256; 2 MiB solo candidato tras calibración, límites coherentes antes de escritura |
| F: evidencia utilizable única | `uq_evidencia_utilizable_por_oferta` único parcial WHERE estadoEvidencia IN ('VERIFICADA','UTILIZADA'); no dos índices separados como garantía equivalente |
| F: integridad cruzada / auditoría | Triggers BEFORE INSERT/UPDATE/DELETE según entidad y permisos SQL: producto–precio–vigencia–snapshot; cantidad y cálculo cotizado; igualdad confirmada; bytes/hashes inmutables, terminales y evento obligatorio. Servicio solo no basta |
| G: históricos | CR-F §14: tabla vacía certificada → NOT NULL; con legado → guardia BEFORE INSERT obligatoria y BEFORE UPDATE diferenciada, sin CHECK NOT VALID no nulo global que bloquee cierre legítimo |
| H: concurrencia | CR-F §12: matriz real UC-03/19/28, contratos UC-05/06/41, protocolo propuesto A/O1/O2/B y experimento Corte 3; RT-UC07-04 ABIERTA |

Para G, revisión de V1–V3 y fixtures/tests versionados de app no halló INSERT de OFERTA_EXCEDENTE, lo cual **no certifica tabla vacía en destinos**. No inventar P desde importe ni usar precio actual. Ofertas históricas sin fuente exacta no admiten nueva cotización/evidencia ni aceptación automática; un rechazo legítimo autorizado conserva nulos históricos sin bloqueo retroactivo, sin rechazar masivamente por conveniencia migratoria.

Para H, el protocolo es un candidato revisado estáticamente, no garantía global: UC-03/19/28 tienen advisory locks y modos de fila distintos; UC-05/06/41 no tienen implementación examinable en main. Son pendientes el orden definitivo compatible, coordinación de generadores y resultados de PostgreSQL/Testcontainers. Hallazgo a probar: colisión del advisory bigint 1919001 con IDs crudos de cliente/insumo; una lista nominal de tablas no lo resuelve. No se modifica app ni PR #85.

No anticipar número Flyway ni editar migraciones. Cuerpos finales de triggers, privilegios/propietario, actor confiable, límites calibrados y recuperación deben especificarse/testearse en el corte autorizado; el DDL candidato no se declara ejecutado.

## 14. Criterios de autorización

1. Revisión formal del responsable, consistencia con RD-UC07-002 y resolución expresa de cualquier contradicción; no se altera esa RD aquí.
2. Autorizar expresamente propuesta preferente A: V1 interna atómica y distinción consulta/emisión parcial/replay O1; acordar reintentos de Parte A conservando firma/salida G0.
3. Aprobar firmas definitivas y tipos coordinados con CR-F, entradas/salidas estrictas, temporalidad, cantidades, errores y códigos HTTP.
4. Resolver idempotencia de ambas operaciones: clave, ámbito, huella, almacenamiento/atomicidad, replay tras cierre, retención y duplicados/INVALIDADA.
5. Confirmar permisos por objeto, Bearer, gates, nombres de flags/veto y pruebas negativas; revisar seguridad, archivos y privacidad.
6. Acordar algoritmos de identificación/serialización y correspondencia histórica oferta/cotización/evidencia, transiciones y sustitución.
7. Demostrar consistencia por revisión conjunta con CR-F, incluyendo generadores, unicidad, RT-UC07-04 y plan de pruebas. No se exige CR-F mergeada para preparar esta CR.
8. Cumplir las puertas de ratificación documental y autorizaciones del antecedente antes de iniciar implementación; pruebas reales son obligación del corte funcional, no evidencia ya adquirida por aprobar un diseño.
9. **Autorización expresa de Victor Leandro Machado**, registrando fecha y alcance reales cuando ocurra, nunca inferida de publicación o merge documental.

La publicación o merge de esta CR no representa automáticamente autorización. La ratificación parcial de arquitectura no aprueba endpoints definitivos; la autorización de desarrollar tampoco autoriza desplegar. Issue #28 y gates permanecen intactos.

## 15. Exclusiones, riesgos y firmas

Único artefacto modificado en la rama de PR #47: esta CR contractual. La rama existente de PR #48 actualiza solo su CR-F coordinadamente. Sin cambios a RDs, otras CRs, G0/manifiesto/catálogo/RBAC/source-lock, Java/tests de aplicación/SQL/migraciones, despliegue o habilitación HTTP. No se ejecuta DDL ni se envían mensajes reales.

Riesgos residuales: declaración manual no autentica remitente ni contenido; hash no prueba envío ni aceptación; archivos requieren inspección y límites; numeración/hash no sustituyen locks; retención idempotente y datos históricos requieren diseño; códigos/rutas/tipos son candidatos. Cualquier contradicción normativa posterior detiene la definición afectada hasta decisión expresa, sin modificar fuentes anteriores para hacerla desaparecer.

**Redactada por:** Codex, agente técnico, para revisión del responsable.

**Fecha de redacción:** 11/11/2026.

**Estado:** BORRADOR — NO AUTORIZADA — NO HABILITA IMPLEMENTACIÓN.

**Responsable que puede autorizar:** Victor Leandro Machado (`leandrito369`).

**Firma y fecha de autorización:** pendientes; no atribuidas. **Implementación, migraciones y despliegue:** no autorizados por esta solicitud.
