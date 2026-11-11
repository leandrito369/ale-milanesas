# CR-B0-UC07-001 — Extensión contractual auxiliar de UC-07

## 1. Identificación, estado y autoridad

**Clase:** Solicitud de Cambio Contractual (CR-C)

**Estado:** BORRADOR — NO AUTORIZADA — NO HABILITA IMPLEMENTACIÓN

**Fecha de redacción:** 11/11/2026 (Argentina); no es fecha de autorización.

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
| CR-F / RT-UC07-04 / UC-03 | CR-F pendiente de preparación; locks y concurrencia pendientes; fix replay UC-03 independiente pendiente |

Distinguir decisión arquitectónica ratificada, diseño contractual propuesto, CR presentada, CR autorizada, implementación realizada y despliegue autorizado. Ninguna etapa implica automáticamente la siguiente.

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

### Primera cotización: decisión requerida antes de autorizar

| Alternativa | Consecuencia y compatibilidad | Pruebas necesarias |
|---|---|---|
| A — creación interna atómica junto a Parte A | Recomendada: oferta y V1 completas o ninguna; V1 conserva cantidadOfrecida/importeInformado. Mantiene firma y salida canónicas; añade efecto interno subordinado que debe autorizarse expresamente con CR-F | Fallo al persistir V1 revierte oferta; V1 única; reintento Parte A no duplica oferta/versiones según contrato que se apruebe |
| B — emisión auxiliar obligatoria después de Parte A y antes de comunicar | Conserva firma principal, pero existe oferta sin V1 entre transacciones. No comunicar condiciones ni admitir evidencia hasta emisión exitosa; requiere flujo/reintentos que eviten aceptación sin referencia | Fallo/reintento auxiliar, oferta sin cotización y prohibición de registrar evidencia prematura; V1 coherente con importeInformado |

Recomendación técnica A, **elección aún pendiente de autorización**; no se impone un nuevo contrato principal ni se modifica G0 en este documento. Si se elige A, evitar que la primera llamada auxiliar duplique V1; distinguir creación interna de V1 de solicitud de versión adicional bajo idempotencia aprobada. Si se elige B, parte A no prueba por sí sola que exista versión comunicable. Resolver esa semántica y su exposición sin romper la salida canónica antes de autorizar.

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

**Archivos:** PNG/JPEG para evaluación inicial MVP; WebP/PDF diferidos, TXT no admitido como evidencia única sin garantías adicionales; ZIP/DOCX/ejecutables fuera de alcance. 2 MiB es candidato de evaluación, no límite final: calibrar con 20–30 archivos antes de aprobar CR-F. Exigir lista blanca, firma binaria y decodificación real, dimensiones/memoria/solicitud limitadas, MIME consistente y contenido seguro. Guardar bytes originales sin transformaciones silenciosas; SHA-256 calculado sobre ellos y comprobable al recuperar. Huella no acredita remitente ni verdad. No persistir archivos inseguros como evidencia para justificar su rechazo.

**Salida y postcondiciones:** evidencia registrada y técnicamente/comercialmente validada, CAPTURADA → VERIFICADA con eventos; si sustituye, aplicar §6. Respuesta mínima sin binario ni datos personales innecesarios. No confirma aceptación física, reserva stock ni devenga deuda.

## 6. Flujo O2, transacciones y sustitución

1. Generar/persistir cotización antes de registrar aceptación; vendedor comunica condiciones y obtiene conformidad verificable por mensaje.
2. O2 registra nueva evidencia en transacción independiente de Parte B. Bloquea recursos en orden global pendiente, revalida sesión/ámbito/estados, integridad, datos comerciales, declaración y vínculo con cotización.
3. Si no resulta válida, rechazar sin invalidar anterior. Política de conservar intentos comerciales fallidos y metadatos seguros requiere CR-F/CR-C; nunca guardar contenido peligroso ni efectuar commits parciales para sortear un rechazo.
4. Solo tras validación exitosa, invalidar anterior VERIFICADA por SUPERADA_POR_RECOTIZACION, registrar nueva CAPTURADA → VERIFICADA y todos sus eventos dentro de **una transacción**. Si falla inserción, evento o transición, rollback completo conserva anterior.
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

Propuesta de replay exitoso: 200 con recibo original sin nuevo efecto; status final y señal de replay pendientes de autorización. Si conserva estadoEvidencia original del recibo, explicitar que es estado al registrar, no garantía de aptitud actual: Parte B siempre revalida el estado persistido. No devolver VERIFICADA histórica como permiso automático. Persistencia, retención, limpieza, conducta tras expirar el registro de clave y errores/reintentos de fallos transitorios deben resolverse antes de autorizar contrato. No prometer exactamente una vez fuera de ese alcance.

### Duplicados documentales y versiones

| Caso | Tratamiento propuesto para revisión |
|---|---|
| Reenvío técnico mismo comando | Mismo recibo, no nuevo intento ni nueva versión |
| Nuevo intento documental | Identidad de negocio distinta, solo si política lo permite; no se deduce por cada reenvío |
| Evidencia de otra cotización | Verificar vínculo y nueva conformidad; no reutilizar automáticamente archivo como aceptación de condiciones nuevas |
| Mismo archivo ya VERIFICADA/UTILIZADA | No duplicar aceptación ni consumo; replay solo si mismo comando, de otro modo evaluar 409 |
| Mismo archivo en INVALIDADA | No reactivar; recomendación de rechazo salvo nuevo intento expresamente permitido con motivo y vínculo verificable. Política final pendiente |
| Archivos diferentes, mismo mensaje | Hash distinto no demuestra aceptación diferente; controles de versión/correspondencia/estado evitan doble consumo |

Separar numeroVersion comercial, numeroIntentoEvidencia si se adopta y reintento HTTP. Numeración segura y unicidad candidata por oferta/versión coordinadas con CR-F; no MAX+1 sin lock. No TTL comercial propio ni EXPIRADA adicional en OFERTA_EXCEDENTE.

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
| C07 | V1 coherente con importeInformado; probar atomicidad o flujo separado según elección autorizada |
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
| C23 | Replay tras cambio de estado no permite consumir evidencia terminal ni eludir reautorización |

Además, generadores y carreras entre distintas ofertas/excedentes requieren PostgreSQL/Testcontainers y evidencia CI del SHA funcional. No se ejecutan servicios ni DDL mediante este documento.

## 13. Dependencia con CR-F

Futura CR-B0-UC07-002 física (identificador provisional, verificar al redactar), no creada en esta tarea: snapshot de precio/idPrecio, cotizaciones versionadas, evidencia P2b y bitácora append-only; FKs, índices, estados, generadores, integridad cotización/oferta y claves idempotentes persistidas, locks, inmutabilidad, acceso y recuperación.

Coordinar UUID candidato para cotización/evidencia en ambas CR; si se elige otro tipo, adaptar ambas antes de autorizar. No fijar PK ni trigger concreto aquí. La CR-F debe evaluar archivos y calibración 20–30 muestras, límites definitivos, privacidad, tamaño y protección física además del backend. Nuevas ofertas requieren snapshot obligatorio; verificar si hay históricos en destinos sin asumir tabla vacía y sin backfill por inversión de importes. No anticipar número Flyway ni editar migraciones aplicadas.

Esta CR-C puede redactarse y revisarse antes de que exista CR-F; ambas deben someterse a revisión cruzada antes de autorización. No exigir merge previo de CR-F como condición circular. Matriz de correspondencia contratos/datos/errores/idempotencia/locking y plan de pruebas deben mostrar consistencia; su mera mención no autoriza DDL.

## 14. Criterios de autorización

1. Revisión formal del responsable, consistencia con RD-UC07-002 y resolución expresa de cualquier contradicción; no se altera esa RD aquí.
2. Elegir creación de V1 (A recomendada o B) y reglas de reintento Parte A/auxiliar, conservando firma/salida G0 y trazabilidad.
3. Aprobar firmas definitivas y tipos coordinados con CR-F, entradas/salidas estrictas, temporalidad, cantidades, errores y códigos HTTP.
4. Resolver idempotencia de ambas operaciones: clave, ámbito, huella, almacenamiento/atomicidad, replay tras cierre, retención y duplicados/INVALIDADA.
5. Confirmar permisos por objeto, Bearer, gates, nombres de flags/veto y pruebas negativas; revisar seguridad, archivos y privacidad.
6. Acordar algoritmos de identificación/serialización y correspondencia histórica oferta/cotización/evidencia, transiciones y sustitución.
7. Demostrar consistencia por revisión conjunta con CR-F, incluyendo generadores, unicidad, RT-UC07-04 y plan de pruebas. No se exige CR-F mergeada para preparar esta CR.
8. Cumplir las puertas de ratificación documental y autorizaciones del antecedente antes de iniciar implementación; pruebas reales son obligación del corte funcional, no evidencia ya adquirida por aprobar un diseño.
9. **Autorización expresa de Victor Leandro Machado**, registrando fecha y alcance reales cuando ocurra, nunca inferida de publicación o merge documental.

La publicación o merge de esta CR no representa automáticamente autorización. La ratificación parcial de arquitectura no aprueba endpoints definitivos; la autorización de desarrollar tampoco autoriza desplegar. Issue #28 y gates permanecen intactos.

## 15. Exclusiones, riesgos y firmas

Único artefacto: esta CR contractual. Sin otras RDs/CRs, CR-F, cambios a G0/manifiesto/catálogo/RBAC/source-lock, Java/tests de aplicación/SQL/migraciones, despliegue o habilitación HTTP. No se ejecuta DDL ni se envían mensajes reales.

Riesgos residuales: declaración manual no autentica remitente ni contenido; hash no prueba envío ni aceptación; archivos requieren inspección y límites; numeración/hash no sustituyen locks; retención idempotente y datos históricos requieren diseño; códigos/rutas/tipos son candidatos. Cualquier contradicción normativa posterior detiene la definición afectada hasta decisión expresa, sin modificar fuentes anteriores para hacerla desaparecer.

**Redactada por:** Codex, agente técnico, para revisión del responsable.

**Fecha de redacción:** 11/11/2026.

**Estado:** BORRADOR — NO AUTORIZADA — NO HABILITA IMPLEMENTACIÓN.

**Responsable que puede autorizar:** Victor Leandro Machado (`leandrito369`).

**Firma y fecha de autorización:** pendientes; no atribuidas. **Implementación, migraciones y despliegue:** no autorizados por esta solicitud.
