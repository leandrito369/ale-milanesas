# REV-03A — Auditoría Transversal y Corrección: Compras y Cotizaciones (UC-58, UC-44, UC-62, UC-63, UC-13, UC-12)

**Fecha:** 28/10/2026  

**Rama de trabajo propuesta:** `revision/rev03a-cotizaciones-politica-2026-10-28`  

**Alcance (`REV-03A`):** `UC-58`, `UC-44`, `UC-62`, `UC-63`, `UC-13`, `UC-12` («include» `UC-62` aprobado el 25/10/2026).  

**Estado de los artefactos entregados:** `PROPUESTO / CORREGIDO EN REVISIÓN ESTÁTICA` (pendiente de inspección visual humana en Draw.io y aprobación para fusión a `main`).

---

## 1. Ejecución de las 8 Etapas Metodológicas (M-0 a M-7)

### M-0 — Autoridad y alcance congelados

* **Catálogo funcional vigente:** 64 CU consecutivos (`UC-01`..`UC-64`) en 3 niveles (`ALE_MILANESAS_FASE_4_CU_01_A_64_TRES_NIVELES.docx`).

* **Relaciones UML aprobadas en este sublote:** `UC-12 → UC-62` (`include` aprobada el 25/10/2026). El archivo `DIAGRAMA DE CASOS DE USO.drawio (1).xml` no se modifica.

* **Decisiones posteriores incorporadas (Corte 27/10/2026):**

  * **`RD-RP013-001` (resuelve Hallazgo Bloqueante `H-02` y Hallazgo de Prioridad Alta `H-08`):**

    1. En `UC-58 — Configurar Política de Compra`, los pesos relativos (`pesoRelativo`) de los criterios activos deben sumar **inequívocamente el 100 %** (`sumaPesosActivos == 100`).

    2. En `UC-12 — Evaluar Cotizaciones y Resolver Compra` y `UC-58`, se elimina la regla que asignaba puntaje mínimo cero a datos faltantes y fijaba el precio total como desempate final automático: el sistema debe **identificar expresamente toda cotización u oferta con datos/antecedentes incompletos**, aplicar el **`ordenDesempate` configurado** en la `PoliticaCompra` vigente y, **si persiste el empate tras aplicar el orden configurado, decide el Administrador**.

  * **`RD-RP012-001` (resuelve Hallazgo `H-16`):**

    1. En `UC-58`, la operación `configurarPoliticaCompra` se circunscribe a versionar `PoliticaCompra` y sus `CriterioPoliticaCompra` sin acoplar en su firma la edición del parámetro operativo global del plazo de respuesta a cotizaciones.

    2. En `UC-44 — Iniciar Ronda Manual de Cotización`, el vencimiento de recepción se determina desde la fuente configurada por parámetro global (`PLAZO_RESPUESTA_COTIZACION_HORAS`) y queda **congelado** en `SolicitudCotizacion.fechaHoraVencimiento` al emitir la solicitud (nunca «48 horas» como valor aprobado por defecto).

### M-1 — Proveniencia, integridad y matriz de diferencias (Antes → Después)

\| ID Hallazgo \| Artefacto / Celda Original \| Antes (Borrador 26–27/10) \| Después (Versión Corregida `REV03A`) \| Fundamento \|

\| :--- \| :--- \| :--- \| :--- \| :--- \|

\| **`H-02` (Bloqueante)** \| `DS UC-58` (`u58_g1`), `DS UC-12` y `Contrato 6B.2` \| Disponía puntaje cero ante dato faltante y desempate final fijo por Precio Total ascendente. \| Exige **identificar expresamente las cotizaciones/antecedentes incompletos**, aplicar el **`ordenDesempate` configurado** en `CriterioPoliticaCompra` y, **si persiste el empate, dejar la decisión al Administrador**. \| `RD-RP013-001` \|

\| **`H-08` (Alta)** \| `DS UC-58` (`u58_g1`) y `Contrato 6B.2` \| En el DS decía solo `suma de pesoRelativo consistente`. \| Explicita en la guarda del DS, en el DSS y en el Contrato que la suma de `pesoRelativo` de los criterios activos debe ser **exactamente igual a 100 %** (`sumaPesosActivos == 100`). \| `RD-RP013-001` \|

\| **`H-16` (Media)** \| `DSS Admin 6B` (`a2_m4`), `DS UC-58` (`u58_m1`), `DS UC-44` (`u44_m3`) y `Contrato 6B.2` \| Acoplaba `plazoRespuestaHoras` en la firma de `UC-58` e incluía `plazoOverrideHoras` en la firma pública de `UC-44`. \| Desacopla la firma de `UC-58` (`configurarPoliticaCompra(vigenteDesde, vigenteHasta, periodoCalculoDias, criterios)`) y ajusta `UC-44` a la fuente por parámetro global con `fechaHoraVencimiento` congelada al emitir. \| `RD-RP012-001` \|

\| **`H-11` (Media)** \| `Contrato 1.3`, `Contrato 6B.3` y `Contrato 6B.4` \| Agrupaba `consultar`+`seleccionar` en `UC-63`, `preparar`+`confirmar` en `UC-44` y `UC-62`+`UC-12` en un mismo encabezado. \| Se separan en **6 Contratos individuales** (`UC-58`, `UC-44`, `UC-62`, `UC-63`, `UC-13`, `UC-12`), cada uno con sus 9 secciones estándar. \| Puerta `G4` / `H-11` \|

\| **`H-12`, `H-19` y `H05`** \| `DSS Proveedor`, `DSS Admin 6B`, `DS` y `Contratos` \| Encadenaba CU en una sola línea temporal, citaba tablas SQL en el DSS y tenía firmas distintas entre DSS, DS y Contrato. \| Marcos `sd` independientes por CU en el DSS, lenguaje de caja negra y homologación 1:1 de las 6 firmas públicas entre DSS, DS (`1:`) y Contratos. \| `M-3`, `H-12`, `H-19`, `H05` \|

---

## 2. Matriz de Trazabilidad Vertical y Visibilidad de Larman Mensaje por Mensaje (M-3 y M-6)

\| CU \| Paso / Mensaje en DS \| Emisor $\rightarrow$ Receptor \| Tipo de Visibilidad (Larman) \| Origen verificable de la referencia \|

\| :--- \| :--- \| :--- \| :--- \| :--- \|

\| **`UC-58`** \| `1: configurarPoliticaCompra(vigenteDesde, vigenteHasta, periodoCalculoDias, criterios)` \| `Administrador` $\rightarrow$ `:ControladorCotizacionesCompras` \| Frontera de sistema \| Operación pública homologada del DSS (`UC-58`). \|

\| **`UC-58`** \| `2: cerrarVigenciaAnteriorSinSolapamiento(vigenteDesde)` \| `:ControladorCotizacionesCompras` $\rightarrow$ `:RepositorioCotizaciones` \| **Por Atributo** \| Repositorio inyectado en el controlador. \|

\| **`UC-58`** \| `3: «create» new(numeroVersion, vigenteDesde, vigenteHasta, periodoCalculoDias)` \| `:ControladorCotizacionesCompras` $\rightarrow$ `nuevaPol : PoliticaCompra` \| **Por Creación Local (`new`)** \| Instanciación de la nueva versión tras validar `sumaPesosActivos == 100` (`RD-RP013-001`). \|

\| **`UC-58`** \| `4: «create» new(nuevaPol, codigoCriterio, pesoRelativo, ordenDesempate)` \| `nuevaPol : PoliticaCompra` $\rightarrow$ `crit : CriterioPoliticaCompra` \| **Por Creación Local (`new`) \+ Atributo** \| `PoliticaCompra` crea y contiene su colección de `CriterioPoliticaCompra`. \|

\| **`UC-44`** \| `1: iniciarRondaManualCotizacion(idInsumo, idSolicitudAnterior, idsProveedoresInvitados)` \| `Administrador` $\rightarrow$ `:ControladorCotizacionesCompras` \| Frontera de sistema \| Operación pública homologada del DSS (`UC-44`). \|

\| **`UC-44`** \| `2: ctx = revalidarEpisodioCadenaLinealEInvitables(idInsumo, idSolicitudAnterior, idsProveedoresInvitados)` \| `:ControladorCotizacionesCompras` $\rightarrow$ `:RepositorioCotizaciones` \| **Por Atributo** \| Revalida atómicamente `stockActual < umbralMinimo`, ausencia de Solicitud/Orden pendiente, cadena lineal y Proveedores `ACTIVO` con Usuario habilitado. \|

\| **`UC-44`** \| `3: «create» new(unEpisodio, solAnterior, idAdmin, cantidadSolicitada, fechaHoraVencimiento, modalidadInicio=MANUAL)` \| `:ControladorCotizacionesCompras` $\rightarrow$ `nuevaSol : SolicitudCotizacion` \| **Por Creación Local (`new`) \+ Parámetro** \| Congela `cantidadSolicitada` y `fechaHoraVencimiento` (calculada desde el parámetro global `RD-RP012-001`). \|

\| **`UC-44`** \| `4: «create» new(nuevaSol, provInvitado, fechaHoraInvitacion)` \| `nuevaSol : SolicitudCotizacion` $\rightarrow$ `inv : InvitacionCotizacion` \| **Por Creación Local (`new`) \+ Atributo** \| `SolicitudCotizacion` crea y conserva sus invitaciones históricas irrevocables. \|

\| **`UC-62`** \| `1: buscarSolicitudCotizacion(idSolicitud, idInsumo, idEpisodio, modalidadInicio, estado)` \| `Administrador` $\rightarrow$ `:ControladorCotizacionesCompras` \| Frontera de sistema \| Operación pública homologada del DSS (`UC-62`). \|

\| **`UC-62`** \| `2: lista = consultarSolicitudesConEpisodio(filtro)` \| `:ControladorCotizacionesCompras` $\rightarrow$ `:RepositorioCotizaciones` \| **Por Atributo** \| Consulta de solo lectura sobre Solicitudes y Episodios. \|

\| **`UC-63`** \| `1: consultarSolicitudesCotizacionRecibidas(idSolicitudSeleccionada)` \| `Proveedor` $\rightarrow$ `:ControladorCotizacionesCompras` \| Frontera de sistema \| Operación pública homologada del DSS (`UC-63`). \|

\| **`UC-63`** \| `2: misInvitaciones = obtenerSolicitudesInvitadasYRespuestaPropia(idProveedorAutenticado, idSolicitudSeleccionada)` \| `:ControladorCotizacionesCompras` $\rightarrow$ `:RepositorioCotizaciones` \| **Por Atributo \+ Parámetro** \| Filtra estrictamente por `InvitacionCotizacion` del Proveedor vinculado al Usuario autenticado, sin exponer terceros. \|

\| **`UC-13`** \| `1: responderSolicitudCotizacion(idSolicitud, precioUnitario, cantidadOfrecida, tiempoEntregaEstimado)` \| `Proveedor` $\rightarrow$ `:ControladorCotizacionesCompras` \| Frontera de sistema \| Operación pública homologada del DSS (`UC-13`). \|

\| **`UC-13`** \| `2: elegible = revalidarRecepcionAbiertaPlazoYUnicaRespuesta(idSolicitud, idProveedorAutenticado)` \| `:ControladorCotizacionesCompras` $\rightarrow$ `unaSolicitud : SolicitudCotizacion` \| **Por Variable Local / Parámetro** \| Revalida en la confirmación que la Solicitud siga en `RECEPCION_ABIERTA`, en plazo, con Proveedor `ACTIVO` y sin respuesta definitiva previa. \|

\| **`UC-13`** \| `3: «create» new(unaSolicitud, unProveedor, idUsuarioRegistrador, cantidadOfrecida, precioUnitario, tiempoEntregaEstimado, fechaHoraRespuesta)` \| `:ControladorCotizacionesCompras` $\rightarrow$ `unaResp : RespuestaCotizacion` \| **Por Creación Local (`new`)** \| Crea la única `RespuestaCotizacion` definitiva e inmutable del Proveedor para esa Solicitud. \|

\| **`UC-12`** \| `1: evaluarCotizacionesYResolverCompra(idSolicitud, decision, idRespuestaElegida, justificacionOMotivo)` \| `Administrador` $\rightarrow$ `:ControladorCotizacionesCompras` \| Frontera de sistema \| Operación pública homologada del DSS (`UC-12`, precedida por `«include» UC-62`). \|

\| **`UC-12`** \| `2: eval = evaluarOfertasSegunPoliticaVigente(unaSolicitud, polVigente)` \| `:ControladorCotizacionesCompras` $\rightarrow$ `polVigente : PoliticaCompra` \| **Por Variable Local \+ Parámetro** \| Identifica ofertas elegibles e incompletas, calcula puntajes ponderados (suma 100 %) y aplica `ordenDesempate` (`RD-RP013-001`). \|

\| **`UC-12`** \| `3: «create» new(unaSolicitud, polVigente, idAdmin, respElegida, justificacion)` \| `:ControladorCotizacionesCompras` $\rightarrow$ `unaDecision : DecisionCompra` \| **Por Creación Local (`new`)** \| Si el Administrador confirma `COMPRAR` (resolviendo cualquier empate persistente, `RD-RP013-001`), registra `DecisionCompra` y `DetalleDecision`. \|

\| **`UC-12`** \| `4: «create» new(unaDecision, cantidadOrdenada, precioUnitarioAcordado, fechaHoraComprometidaEntrega, estado=PENDIENTE)` \| `:ControladorCotizacionesCompras` $\rightarrow$ `unaOrden : OrdenCompra` \| **Por Creación Local (`new`)** \| Emite la única `OrdenCompra` `PENDIENTE` tras confirmación humana expresa. \|

---

## 3. Matriz Transversal de Invariantes y Puertas de Aceptación (M-4 y M-7)

\| ID \| Invariante ratificada \| DSS \| DS \| Contrato \| Dictamen \|

\| :--- \| :--- \| :--- \| :--- \| :--- \| :--- \|

\| **`I-01`** \| `RD-RP013-001` (`H-02`, `H-08`): En `UC-58`, la suma de `pesoRelativo` de los criterios activos es exactamente **100 %**; en `UC-12`/`UC-58` se señalan cotizaciones incompletas, se aplica `ordenDesempate` configurado y si persiste el empate decide el Administrador \| Guardas y respuestas corregidas en `UC-58` y `UC-12` \| Guardas explícitas `sumaPesosActivos == 100` y desempate por Administrador en `DS UC-58` y `DS UC-12` \| Pre/Postcondiciones y Notas en `CONTRATO_UC58` y `CONTRATO_UC12` \| **PASÓ (Trazabilidad estática)** \|

\| **`I-02`** \| `RD-RP012-001` (`H-16`): Fuente del plazo de cotización por parámetro global y `fechaHoraVencimiento` congelada al emitir; firma de `UC-58` desacoplada de dicho parámetro \| Firma limpia en `UC-58` y plazo congelado en `UC-44` \| `DS UC-58` y `DS UC-44` alineados con `RD-RP012-001` \| `CONTRATO_UC58` y `CONTRATO_UC44` \| **PASÓ (Trazabilidad estática)** \|

\| **`I-03`** \| Ninguna `OrdenCompra` se emite de forma autónoma: `UC-12` exige confirmación humana expresa del Administrador con Proveedor `ACTIVO` y faltante vigente \| Marco `UC-12` con `ref UC-62` y ramas `COMPRAR` / `NO_COMPRAR` \| `DS UC-12` con 3 operandos mutuamente excluyentes (`COMPRAR`, `NO_COMPRAR`, `RECHAZO`) \| `CONTRATO_UC12` individual con 9 secciones \| **PASÓ (Trazabilidad estática)** \|

\| **`I-04`** \| En `UC-63` y `UC-13`, el Proveedor solo ve sus propias invitaciones y registra a lo sumo una `RespuestaCotizacion` definitiva e inmutable en plazo con Solicitud en `RECEPCION_ABIERTA` \| Marcos independientes `UC-63` y `UC-13` \| `DS UC-63` y `DS UC-13` con revalidación en confirmación \| `CONTRATO_UC63` y `CONTRATO_UC13` individuales \| **PASÓ (Trazabilidad estática)** \|

\| **`I-05`** \| Homologación 1:1 de firmas públicas DSS ↔ DS ↔ Contrato y desagrupamiento total de contratos (`H-11`, `H05`) \| 6 firmas canónicas \| Mensaje `1:` idéntico en las 6 páginas DS \| 6 Contratos individuales con las mismas 6 firmas \| **PASÓ** \|

\| **`I-06`** \| Inspección visual y prueba de desplazamiento (`round-trip`) en editor gráfico Draw.io (`M-6` / `G5`) \| XML bien formado \| XML bien formado con operandos `alt` separados \| N/A \| **PENDIENTE DE VALIDACIÓN HUMANA EN DRAW.IO** \|

---

## 4. Matriz de 12 Escenarios Mínimos de Prueba Futura para `REV-03A`

\| Escenario \| Caso \| Entrada / Evento \| Resultado Esperado \|

\| :--- \| :--- \| :--- \| :--- \|

\| **`E01`** \| `UC-58` \| Configuración de Política de Compra cuyos criterios activos suman 95 % o 105 % (`RD-RP013-001`) \| **Rechazado**: exige que la suma de `pesoRelativo` de los criterios activos sea exactamente 100 %. \|

\| **`E02`** \| `UC-58` \| Configuración de Política de Compra con suma de pesos activos = 100 %, `ordenDesempate` único por criterio y vigencia sin solapamiento \| Se cierra la vigencia previa y se registra la nueva versión de `PoliticaCompra` y `CriterioPoliticaCompra`. \|

\| **`E03`** \| `UC-44` \| Inicio de ronda manual para Insumo `ACTIVO` bajo umbral, sin Solicitud/Orden pendiente, con Proveedores `ACTIVO` y Usuario habilitado (`RD-RP012-001`) \| Se emite `SolicitudCotizacion` (`MANUAL`, `RECEPCION_ABIERTA`) con `cantidadSolicitada` y `fechaHoraVencimiento` congeladas e `InvitacionCotizacion` para cada invitado. \|

\| **`E04`** \| `UC-44` \| Intento de iniciar ronda manual bifurcando la cadena desde una Solicitud que no es la última del episodio \| **Rechazado**: preserva la cadena lineal sin bifurcaciones. \|

\| **`E05`** \| `UC-63` \| Proveedor autenticado intenta consultar detalle de una `SolicitudCotizacion` a la que no fue invitado \| **Rechazado**: niega el acceso aunque conozca el `idSolicitud`. \|

\| **`E06`** \| `UC-13` \| Proveedor invitado confirma respuesta dentro de `fechaHoraVencimiento` con Solicitud en `RECEPCION_ABIERTA` y Proveedor `ACTIVO` \| Se registra su única `RespuestaCotizacion` definitiva e inmutable. \|

\| **`E07`** \| `UC-13` \| Proveedor intenta enviar una segunda respuesta o confirmar después de `fechaHoraVencimiento` \| **Rechazado**: no modifica la respuesta previa ni registra respuesta tardía. \|

\| **`E08`** \| `UC-12`+`UC-62` \| Evaluación de ofertas cuando una cotización u antecedente está incompleto (`RD-RP013-001`) \| El sistema **identifica expresamente la cotización/dato incompleto** (sin adjudicar silenciosamente ni inventar valores). \|

\| **`E09`** \| `UC-12`+`UC-62` \| Dos ofertas elegibles empatan en puntaje total; se aplica el `ordenDesempate` configurado y el empate persiste (`RD-RP013-001`) \| El sistema expone el empate persistente y **decide el Administrador** con justificación obligatoria. \|

\| **`E10`** \| `UC-12`+`UC-62` \| Administrador confirma `COMPRAR` seleccionando oferta elegible de Proveedor que sigue `ACTIVO` y con faltante vigente \| Registra atómicamente `DecisionCompra`, `DetalleDecision`, `OrdenCompra` (`PENDIENTE`) y marca la Solicitud `CON_COMPRA`. \|

\| **`E11`** \| `UC-12`+`UC-62` \| El Proveedor de la oferta elegida pasó a `INACTIVO` o el faltante ya se cubrió antes de confirmar la compra \| **Rechaza emitir la `OrdenCompra`** e informa al Administrador para revisar otra oferta o cerrar justificadamente `SIN_COMPRA`. \|

\| **`E12`** \| `UC-12`+`UC-62` \| Administrador selecciona `NO_COMPRAR` informando motivo obligatorio \| Cierra la Solicitud como `SIN_COMPRA` sin emitir `OrdenCompra` y conserva la alerta del episodio si persiste el faltante. \|
