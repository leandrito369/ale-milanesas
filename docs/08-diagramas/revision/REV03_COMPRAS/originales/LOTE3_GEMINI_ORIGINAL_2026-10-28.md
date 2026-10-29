

* REV-03A **(en este mensaje):** Los **6 Casos de Uso principales del Lote 3 del Plan de Auditoría (**UC-58**,** UC-44**,** UC-62**,** UC-63**,** UC-13**,** UC-12**)**, que concentran los hallazgos bloqueantes y de prioridad alta H-02, H-08 (RD-RP013-001) y H-16 (RD-RP012-001).  
*   
* REV-03B **(en el próximo mensaje):** Los **7 Casos de Uso complementarios de Proveedores, Órdenes y Recepción (**UC-11**,** UC-37**,** UC-45**,** UC-46**,** UC-40**,** UC-39**,** UC-08**)**.  
* 

### **Archivo 1:** docs/08-diagramas/revision/REV03A\_AUDITORIA\_TRANSVERSAL\_COTIZACIONES\_2026-10-28.md

Este informe ejecuta las **8 etapas metodológicas (**M-0 **a** M-7**)** definidas en REV-01 sobre UC-58, UC-44, UC-62, UC-63, UC-13 y UC-12:

Markdown  
\# REV-03A — Auditoría Transversal y Corrección: Compras y Cotizaciones (UC-58, UC-44, UC-62, UC-63, UC-13, UC-12)

**\*\*Fecha:\*\*** 28/10/2026  

**\*\*Rama de trabajo propuesta:\*\*** \`revision/rev03a-cotizaciones-politica-2026-10-28\`  

**\*\*Alcance (\`REV-03A\`):\*\*** \`UC-58\`, \`UC-44\`, \`UC-62\`, \`UC-63\`, \`UC-13\`, \`UC-12\` («include» \`UC-62\` aprobado el 25/10/2026).  

**\*\*Estado de los artefactos entregados:\*\*** \`PROPUESTO / CORREGIDO EN REVISIÓN ESTÁTICA\` (pendiente de inspección visual humana en Draw.io y aprobación para fusión a \`main\`).

\---

\#\# 1\. Ejecución de las 8 Etapas Metodológicas (M-0 a M-7)

\#\#\# M-0 — Autoridad y alcance congelados

\* **\*\*Catálogo funcional vigente:\*\*** 64 CU consecutivos (\`UC-01\`..\`UC-64\`) en 3 niveles (\`ALE\_MILANESAS\_FASE\_4\_CU\_01\_A\_64\_TRES\_NIVELES.docx\`).

\* **\*\*Relaciones UML aprobadas en este sublote:\*\*** \`UC-12 → UC-62\` (\`include\` aprobada el 25/10/2026). El archivo \`DIAGRAMA DE CASOS DE USO.drawio (1).xml\` no se modifica.

\* **\*\*Decisiones posteriores incorporadas (Corte 27/10/2026):\*\***

  \* **\*\*\`RD-RP013-001\` (resuelve Hallazgo Bloqueante \`H-02\` y Hallazgo de Prioridad Alta \`H-08\`):\*\***

    1\. En \`UC-58 — Configurar Política de Compra\`, los pesos relativos (\`pesoRelativo\`) de los criterios activos deben sumar **\*\*inequívocamente el 100 %\*\*** (\`sumaPesosActivos \== 100\`).

    2\. En \`UC-12 — Evaluar Cotizaciones y Resolver Compra\` y \`UC-58\`, se elimina la regla que asignaba puntaje mínimo cero a datos faltantes y fijaba el precio total como desempate final automático: el sistema debe **\*\*identificar expresamente toda cotización u oferta con datos/antecedentes incompletos\*\***, aplicar el **\*\*\`ordenDesempate\` configurado\*\*** en la \`PoliticaCompra\` vigente y, **\*\*si persiste el empate tras aplicar el orden configurado, decide el Administrador\*\***.

  \* **\*\*\`RD-RP012-001\` (resuelve Hallazgo \`H-16\`):\*\***

    1\. En \`UC-58\`, la operación \`configurarPoliticaCompra\` se circunscribe a versionar \`PoliticaCompra\` y sus \`CriterioPoliticaCompra\` sin acoplar en su firma la edición del parámetro operativo global del plazo de respuesta a cotizaciones.

    2\. En \`UC-44 — Iniciar Ronda Manual de Cotización\`, el vencimiento de recepción se determina desde la fuente configurada por parámetro global (\`PLAZO\_RESPUESTA\_COTIZACION\_HORAS\`) y queda **\*\*congelado\*\*** en \`SolicitudCotizacion.fechaHoraVencimiento\` al emitir la solicitud (nunca «48 horas» como valor aprobado por defecto).

\#\#\# M-1 — Proveniencia, integridad y matriz de diferencias (Antes → Después)

\| ID Hallazgo \| Artefacto / Celda Original \| Antes (Borrador 26–27/10) \| Después (Versión Corregida \`REV03A\`) \| Fundamento \|

\| :--- \| :--- \| :--- \| :--- \| :--- \|

\| **\*\*\`H-02\` (Bloqueante)\*\*** \| \`DS UC-58\` (\`u58\_g1\`), \`DS UC-12\` y \`Contrato 6B.2\` \| Disponía puntaje cero ante dato faltante y desempate final fijo por Precio Total ascendente. \| Exige **\*\*identificar expresamente las cotizaciones/antecedentes incompletos\*\***, aplicar el **\*\*\`ordenDesempate\` configurado\*\*** en \`CriterioPoliticaCompra\` y, **\*\*si persiste el empate, dejar la decisión al Administrador\*\***. \| \`RD-RP013-001\` \|

\| **\*\*\`H-08\` (Alta)\*\*** \| \`DS UC-58\` (\`u58\_g1\`) y \`Contrato 6B.2\` \| En el DS decía solo \`suma de pesoRelativo consistente\`. \| Explicita en la guarda del DS, en el DSS y en el Contrato que la suma de \`pesoRelativo\` de los criterios activos debe ser **\*\*exactamente igual a 100 %\*\*** (\`sumaPesosActivos \== 100\`). \| \`RD-RP013-001\` \|

\| **\*\*\`H-16\` (Media)\*\*** \| \`DSS Admin 6B\` (\`a2\_m4\`), \`DS UC-58\` (\`u58\_m1\`), \`DS UC-44\` (\`u44\_m3\`) y \`Contrato 6B.2\` \| Acoplaba \`plazoRespuestaHoras\` en la firma de \`UC-58\` e incluía \`plazoOverrideHoras\` en la firma pública de \`UC-44\`. \| Desacopla la firma de \`UC-58\` (\`configurarPoliticaCompra(vigenteDesde, vigenteHasta, periodoCalculoDias, criterios)\`) y ajusta \`UC-44\` a la fuente por parámetro global con \`fechaHoraVencimiento\` congelada al emitir. \| \`RD-RP012-001\` \|

\| **\*\*\`H-11\` (Media)\*\*** \| \`Contrato 1.3\`, \`Contrato 6B.3\` y \`Contrato 6B.4\` \| Agrupaba \`consultar\`+\`seleccionar\` en \`UC-63\`, \`preparar\`+\`confirmar\` en \`UC-44\` y \`UC-62\`+\`UC-12\` en un mismo encabezado. \| Se separan en **\*\*6 Contratos individuales\*\*** (\`UC-58\`, \`UC-44\`, \`UC-62\`, \`UC-63\`, \`UC-13\`, \`UC-12\`), cada uno con sus 9 secciones estándar. \| Puerta \`G4\` / \`H-11\` \|

\| **\*\*\`H-12\`, \`H-19\` y \`H05\`\*\*** \| \`DSS Proveedor\`, \`DSS Admin 6B\`, \`DS\` y \`Contratos\` \| Encadenaba CU en una sola línea temporal, citaba tablas SQL en el DSS y tenía firmas distintas entre DSS, DS y Contrato. \| Marcos \`sd\` independientes por CU en el DSS, lenguaje de caja negra y homologación 1:1 de las 6 firmas públicas entre DSS, DS (\`1:\`) y Contratos. \| \`M-3\`, \`H-12\`, \`H-19\`, \`H05\` \|

\---

\#\# 2\. Matriz de Trazabilidad Vertical y Visibilidad de Larman Mensaje por Mensaje (M-3 y M-6)

\| CU \| Paso / Mensaje en DS \| Emisor $\rightarrow$ Receptor \| Tipo de Visibilidad (Larman) \| Origen verificable de la referencia \|

\| :--- \| :--- \| :--- \| :--- \| :--- \|

\| **\*\*\`UC-58\`\*\*** \| \`1: configurarPoliticaCompra(vigenteDesde, vigenteHasta, periodoCalculoDias, criterios)\` \| \`Administrador\` $\rightarrow$ \`:ControladorCotizacionesCompras\` \| Frontera de sistema \| Operación pública homologada del DSS (\`UC-58\`). \|

\| **\*\*\`UC-58\`\*\*** \| \`2: cerrarVigenciaAnteriorSinSolapamiento(vigenteDesde)\` \| \`:ControladorCotizacionesCompras\` $\rightarrow$ \`:RepositorioCotizaciones\` \| **\*\*Por Atributo\*\*** \| Repositorio inyectado en el controlador. \|

\| **\*\*\`UC-58\`\*\*** \| \`3: «create» new(numeroVersion, vigenteDesde, vigenteHasta, periodoCalculoDias)\` \| \`:ControladorCotizacionesCompras\` $\rightarrow$ \`nuevaPol : PoliticaCompra\` \| **\*\*Por Creación Local (\`new\`)\*\*** \| Instanciación de la nueva versión tras validar \`sumaPesosActivos \== 100\` (\`RD-RP013-001\`). \|

\| **\*\*\`UC-58\`\*\*** \| \`4: «create» new(nuevaPol, codigoCriterio, pesoRelativo, ordenDesempate)\` \| \`nuevaPol : PoliticaCompra\` $\rightarrow$ \`crit : CriterioPoliticaCompra\` \| **\*\*Por Creación Local (\`new\`) \+ Atributo\*\*** \| \`PoliticaCompra\` crea y contiene su colección de \`CriterioPoliticaCompra\`. \|

\| **\*\*\`UC-44\`\*\*** \| \`1: iniciarRondaManualCotizacion(idInsumo, idSolicitudAnterior, idsProveedoresInvitados)\` \| \`Administrador\` $\rightarrow$ \`:ControladorCotizacionesCompras\` \| Frontera de sistema \| Operación pública homologada del DSS (\`UC-44\`). \|

\| **\*\*\`UC-44\`\*\*** \| \`2: ctx \= revalidarEpisodioCadenaLinealEInvitables(idInsumo, idSolicitudAnterior, idsProveedoresInvitados)\` \| \`:ControladorCotizacionesCompras\` $\rightarrow$ \`:RepositorioCotizaciones\` \| **\*\*Por Atributo\*\*** \| Revalida atómicamente \`stockActual \< umbralMinimo\`, ausencia de Solicitud/Orden pendiente, cadena lineal y Proveedores \`ACTIVO\` con Usuario habilitado. \|

\| **\*\*\`UC-44\`\*\*** \| \`3: «create» new(unEpisodio, solAnterior, idAdmin, cantidadSolicitada, fechaHoraVencimiento, modalidadInicio=MANUAL)\` \| \`:ControladorCotizacionesCompras\` $\rightarrow$ \`nuevaSol : SolicitudCotizacion\` \| **\*\*Por Creación Local (\`new\`) \+ Parámetro\*\*** \| Congela \`cantidadSolicitada\` y \`fechaHoraVencimiento\` (calculada desde el parámetro global \`RD-RP012-001\`). \|

\| **\*\*\`UC-44\`\*\*** \| \`4: «create» new(nuevaSol, provInvitado, fechaHoraInvitacion)\` \| \`nuevaSol : SolicitudCotizacion\` $\rightarrow$ \`inv : InvitacionCotizacion\` \| **\*\*Por Creación Local (\`new\`) \+ Atributo\*\*** \| \`SolicitudCotizacion\` crea y conserva sus invitaciones históricas irrevocables. \|

\| **\*\*\`UC-62\`\*\*** \| \`1: buscarSolicitudCotizacion(idSolicitud, idInsumo, idEpisodio, modalidadInicio, estado)\` \| \`Administrador\` $\rightarrow$ \`:ControladorCotizacionesCompras\` \| Frontera de sistema \| Operación pública homologada del DSS (\`UC-62\`). \|

\| **\*\*\`UC-62\`\*\*** \| \`2: lista \= consultarSolicitudesConEpisodio(filtro)\` \| \`:ControladorCotizacionesCompras\` $\rightarrow$ \`:RepositorioCotizaciones\` \| **\*\*Por Atributo\*\*** \| Consulta de solo lectura sobre Solicitudes y Episodios. \|

\| **\*\*\`UC-63\`\*\*** \| \`1: consultarSolicitudesCotizacionRecibidas(idSolicitudSeleccionada)\` \| \`Proveedor\` $\rightarrow$ \`:ControladorCotizacionesCompras\` \| Frontera de sistema \| Operación pública homologada del DSS (\`UC-63\`). \|

\| **\*\*\`UC-63\`\*\*** \| \`2: misInvitaciones \= obtenerSolicitudesInvitadasYRespuestaPropia(idProveedorAutenticado, idSolicitudSeleccionada)\` \| \`:ControladorCotizacionesCompras\` $\rightarrow$ \`:RepositorioCotizaciones\` \| **\*\*Por Atributo \+ Parámetro\*\*** \| Filtra estrictamente por \`InvitacionCotizacion\` del Proveedor vinculado al Usuario autenticado, sin exponer terceros. \|

\| **\*\*\`UC-13\`\*\*** \| \`1: responderSolicitudCotizacion(idSolicitud, precioUnitario, cantidadOfrecida, tiempoEntregaEstimado)\` \| \`Proveedor\` $\rightarrow$ \`:ControladorCotizacionesCompras\` \| Frontera de sistema \| Operación pública homologada del DSS (\`UC-13\`). \|

\| **\*\*\`UC-13\`\*\*** \| \`2: elegible \= revalidarRecepcionAbiertaPlazoYUnicaRespuesta(idSolicitud, idProveedorAutenticado)\` \| \`:ControladorCotizacionesCompras\` $\rightarrow$ \`unaSolicitud : SolicitudCotizacion\` \| **\*\*Por Variable Local / Parámetro\*\*** \| Revalida en la confirmación que la Solicitud siga en \`RECEPCION\_ABIERTA\`, en plazo, con Proveedor \`ACTIVO\` y sin respuesta definitiva previa. \|

\| **\*\*\`UC-13\`\*\*** \| \`3: «create» new(unaSolicitud, unProveedor, idUsuarioRegistrador, cantidadOfrecida, precioUnitario, tiempoEntregaEstimado, fechaHoraRespuesta)\` \| \`:ControladorCotizacionesCompras\` $\rightarrow$ \`unaResp : RespuestaCotizacion\` \| **\*\*Por Creación Local (\`new\`)\*\*** \| Crea la única \`RespuestaCotizacion\` definitiva e inmutable del Proveedor para esa Solicitud. \|

\| **\*\*\`UC-12\`\*\*** \| \`1: evaluarCotizacionesYResolverCompra(idSolicitud, decision, idRespuestaElegida, justificacionOMotivo)\` \| \`Administrador\` $\rightarrow$ \`:ControladorCotizacionesCompras\` \| Frontera de sistema \| Operación pública homologada del DSS (\`UC-12\`, precedida por \`«include» UC-62\`). \|

\| **\*\*\`UC-12\`\*\*** \| \`2: eval \= evaluarOfertasSegunPoliticaVigente(unaSolicitud, polVigente)\` \| \`:ControladorCotizacionesCompras\` $\rightarrow$ \`polVigente : PoliticaCompra\` \| **\*\*Por Variable Local \+ Parámetro\*\*** \| Identifica ofertas elegibles e incompletas, calcula puntajes ponderados (suma 100 %) y aplica \`ordenDesempate\` (\`RD-RP013-001\`). \|

\| **\*\*\`UC-12\`\*\*** \| \`3: «create» new(unaSolicitud, polVigente, idAdmin, respElegida, justificacion)\` \| \`:ControladorCotizacionesCompras\` $\rightarrow$ \`unaDecision : DecisionCompra\` \| **\*\*Por Creación Local (\`new\`)\*\*** \| Si el Administrador confirma \`COMPRAR\` (resolviendo cualquier empate persistente, \`RD-RP013-001\`), registra \`DecisionCompra\` y \`DetalleDecision\`. \|

\| **\*\*\`UC-12\`\*\*** \| \`4: «create» new(unaDecision, cantidadOrdenada, precioUnitarioAcordado, fechaHoraComprometidaEntrega, estado=PENDIENTE)\` \| \`:ControladorCotizacionesCompras\` $\rightarrow$ \`unaOrden : OrdenCompra\` \| **\*\*Por Creación Local (\`new\`)\*\*** \| Emite la única \`OrdenCompra\` \`PENDIENTE\` tras confirmación humana expresa. \|

\---

\#\# 3\. Matriz Transversal de Invariantes y Puertas de Aceptación (M-4 y M-7)

\| ID \| Invariante ratificada \| DSS \| DS \| Contrato \| Dictamen \|

\| :--- \| :--- \| :--- \| :--- \| :--- \| :--- \|

\| **\*\*\`I-01\`\*\*** \| \`RD-RP013-001\` (\`H-02\`, \`H-08\`): En \`UC-58\`, la suma de \`pesoRelativo\` de los criterios activos es exactamente **\*\*100 %\*\***; en \`UC-12\`/\`UC-58\` se señalan cotizaciones incompletas, se aplica \`ordenDesempate\` configurado y si persiste el empate decide el Administrador \| Guardas y respuestas corregidas en \`UC-58\` y \`UC-12\` \| Guardas explícitas \`sumaPesosActivos \== 100\` y desempate por Administrador en \`DS UC-58\` y \`DS UC-12\` \| Pre/Postcondiciones y Notas en \`CONTRATO\_UC58\` y \`CONTRATO\_UC12\` \| **\*\*PASÓ (Trazabilidad estática)\*\*** \|

\| **\*\*\`I-02\`\*\*** \| \`RD-RP012-001\` (\`H-16\`): Fuente del plazo de cotización por parámetro global y \`fechaHoraVencimiento\` congelada al emitir; firma de \`UC-58\` desacoplada de dicho parámetro \| Firma limpia en \`UC-58\` y plazo congelado en \`UC-44\` \| \`DS UC-58\` y \`DS UC-44\` alineados con \`RD-RP012-001\` \| \`CONTRATO\_UC58\` y \`CONTRATO\_UC44\` \| **\*\*PASÓ (Trazabilidad estática)\*\*** \|

\| **\*\*\`I-03\`\*\*** \| Ninguna \`OrdenCompra\` se emite de forma autónoma: \`UC-12\` exige confirmación humana expresa del Administrador con Proveedor \`ACTIVO\` y faltante vigente \| Marco \`UC-12\` con \`ref UC-62\` y ramas \`COMPRAR\` / \`NO\_COMPRAR\` \| \`DS UC-12\` con 3 operandos mutuamente excluyentes (\`COMPRAR\`, \`NO\_COMPRAR\`, \`RECHAZO\`) \| \`CONTRATO\_UC12\` individual con 9 secciones \| **\*\*PASÓ (Trazabilidad estática)\*\*** \|

\| **\*\*\`I-04\`\*\*** \| En \`UC-63\` y \`UC-13\`, el Proveedor solo ve sus propias invitaciones y registra a lo sumo una \`RespuestaCotizacion\` definitiva e inmutable en plazo con Solicitud en \`RECEPCION\_ABIERTA\` \| Marcos independientes \`UC-63\` y \`UC-13\` \| \`DS UC-63\` y \`DS UC-13\` con revalidación en confirmación \| \`CONTRATO\_UC63\` y \`CONTRATO\_UC13\` individuales \| **\*\*PASÓ (Trazabilidad estática)\*\*** \|

\| **\*\*\`I-05\`\*\*** \| Homologación 1:1 de firmas públicas DSS ↔ DS ↔ Contrato y desagrupamiento total de contratos (\`H-11\`, \`H05\`) \| 6 firmas canónicas \| Mensaje \`1:\` idéntico en las 6 páginas DS \| 6 Contratos individuales con las mismas 6 firmas \| **\*\*PASÓ\*\*** \|

\| **\*\*\`I-06\`\*\*** \| Inspección visual y prueba de desplazamiento (\`round-trip\`) en editor gráfico Draw.io (\`M-6\` / \`G5\`) \| XML bien formado \| XML bien formado con operandos \`alt\` separados \| N/A \| **\*\*PENDIENTE DE VALIDACIÓN HUMANA EN DRAW.IO\*\*** \|

\---

\#\# 4\. Matriz de 12 Escenarios Mínimos de Prueba Futura para \`REV-03A\`

\| Escenario \| Caso \| Entrada / Evento \| Resultado Esperado \|

\| :--- \| :--- \| :--- \| :--- \|

\| **\*\*\`E01\`\*\*** \| \`UC-58\` \| Configuración de Política de Compra cuyos criterios activos suman 95 % o 105 % (\`RD-RP013-001\`) \| **\*\*Rechazado\*\***: exige que la suma de \`pesoRelativo\` de los criterios activos sea exactamente 100 %. \|

\| **\*\*\`E02\`\*\*** \| \`UC-58\` \| Configuración de Política de Compra con suma de pesos activos \= 100 %, \`ordenDesempate\` único por criterio y vigencia sin solapamiento \| Se cierra la vigencia previa y se registra la nueva versión de \`PoliticaCompra\` y \`CriterioPoliticaCompra\`. \|

\| **\*\*\`E03\`\*\*** \| \`UC-44\` \| Inicio de ronda manual para Insumo \`ACTIVO\` bajo umbral, sin Solicitud/Orden pendiente, con Proveedores \`ACTIVO\` y Usuario habilitado (\`RD-RP012-001\`) \| Se emite \`SolicitudCotizacion\` (\`MANUAL\`, \`RECEPCION\_ABIERTA\`) con \`cantidadSolicitada\` y \`fechaHoraVencimiento\` congeladas e \`InvitacionCotizacion\` para cada invitado. \|

\| **\*\*\`E04\`\*\*** \| \`UC-44\` \| Intento de iniciar ronda manual bifurcando la cadena desde una Solicitud que no es la última del episodio \| **\*\*Rechazado\*\***: preserva la cadena lineal sin bifurcaciones. \|

\| **\*\*\`E05\`\*\*** \| \`UC-63\` \| Proveedor autenticado intenta consultar detalle de una \`SolicitudCotizacion\` a la que no fue invitado \| **\*\*Rechazado\*\***: niega el acceso aunque conozca el \`idSolicitud\`. \|

\| **\*\*\`E06\`\*\*** \| \`UC-13\` \| Proveedor invitado confirma respuesta dentro de \`fechaHoraVencimiento\` con Solicitud en \`RECEPCION\_ABIERTA\` y Proveedor \`ACTIVO\` \| Se registra su única \`RespuestaCotizacion\` definitiva e inmutable. \|

\| **\*\*\`E07\`\*\*** \| \`UC-13\` \| Proveedor intenta enviar una segunda respuesta o confirmar después de \`fechaHoraVencimiento\` \| **\*\*Rechazado\*\***: no modifica la respuesta previa ni registra respuesta tardía. \|

\| **\*\*\`E08\`\*\*** \| \`UC-12\`+\`UC-62\` \| Evaluación de ofertas cuando una cotización u antecedente está incompleto (\`RD-RP013-001\`) \| El sistema **\*\*identifica expresamente la cotización/dato incompleto\*\*** (sin adjudicar silenciosamente ni inventar valores). \|

\| **\*\*\`E09\`\*\*** \| \`UC-12\`+\`UC-62\` \| Dos ofertas elegibles empatan en puntaje total; se aplica el \`ordenDesempate\` configurado y el empate persiste (\`RD-RP013-001\`) \| El sistema expone el empate persistente y **\*\*decide el Administrador\*\*** con justificación obligatoria. \|

\| **\*\*\`E10\`\*\*** \| \`UC-12\`+\`UC-62\` \| Administrador confirma \`COMPRAR\` seleccionando oferta elegible de Proveedor que sigue \`ACTIVO\` y con faltante vigente \| Registra atómicamente \`DecisionCompra\`, \`DetalleDecision\`, \`OrdenCompra\` (\`PENDIENTE\`) y marca la Solicitud \`CON\_COMPRA\`. \|

\| **\*\*\`E11\`\*\*** \| \`UC-12\`+\`UC-62\` \| El Proveedor de la oferta elegida pasó a \`INACTIVO\` o el faltante ya se cubrió antes de confirmar la compra \| **\*\*Rechaza emitir la \`OrdenCompra\`\*\*** e informa al Administrador para revisar otra oferta o cerrar justificadamente \`SIN\_COMPRA\`. \|

\| **\*\*\`E12\`\*\*** \| \`UC-12\`+\`UC-62\` \| Administrador selecciona \`NO\_COMPRAR\` informando motivo obligatorio \| Cierra la Solicitud como \`SIN\_COMPRA\` sin emitir \`OrdenCompra\` y conserva la alerta del episodio si persiste el faltante. \|

### **Archivo 2:** docs/08-diagramas/revision/DSS\_REV03A\_COTIZACIONES\_FRAGMENTOS.drawio.xml

Este archivo XML compatible con **Draw.io** modela en **2 páginas** los escenarios de caja negra (DSS) de UC-63 y UC-13 (Actor Proveedor) y UC-58, UC-44, UC-62 y UC-12 (Actor Administrador), encapsulados en marcos sd independientes (H-12), sin lenguaje SQL interno (H-19) y aplicando RD-RP013-001 y RD-RP012-001:

XML  
\<mxfile host="app.diagrams.net" modified="2026-10-28T11:30:00.000Z" agent="Gemini-REV03A" version="24.7.17" type="device"\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 1: DSS CAJA NEGRA — PROVEEDOR (UC-63 y UC-13)                      \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id="dss-rev03a-prov" name="DSS REV03A \- Proveedor (UC-63, UC-13)"\>

    \<mxGraphModel dx="1450" dy="900" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1400" pageHeight="1100" math="0" shadow="0"\>

      \<root\>

        \<mxCell id="0" /\>

        \<mxCell id="1" parent="0" /\>

        \<mxCell id="p1\_title" value="DSS (Caja Negra — REV03A) — Actor: Proveedor — Escenarios Independientes UC-63 y UC-13" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=13;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="15" width="1100" height="30" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="p1\_actor" value="Proveedor&\#xa;(Usuario PROVEEDOR)" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="110" y="60" width="30" height="60" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="p1\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="119" y="155" width="12" height="880" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="p1\_sys\_box" value=":Sistema" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;fontSize=13;" vertex="1" parent="1"\>

          \<mxGeometry x="880" y="60" width="140" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="p1\_sys\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="950" y="1060" as="sourcePoint" /\>

            \<mxPoint x="950" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="p1\_sys\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="944" y="155" width="12" height="880" as="geometry" /\>

        \</mxCell\>

        \<\!-- MARCO INDEPENDIENTE UC-63 \--\>

        \<mxCell id="p1\_sd63" value="sd Escenario Independiente — UC-63: Consultar Solicitudes de Cotización Recibidas" style="shape=umlFrame;whiteSpace=wrap;html=1;width=520;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="170" width="1040" height="310" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="p1\_63\_m1" value="1: misSolicitudes \= consultarSolicitudesCotizacionRecibidas(idSolicitudSeleccionada:Long\[0..1\])" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="131" y="215" as="sourcePoint" /\>

            \<mxPoint x="944" y="215" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="p1\_63\_alt" value="alt Consulta de invitaciones dirigidas al Proveedor autenticado \[UC-63\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=450;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="75" y="235" width="990" height="225" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="p1\_63\_g1" value="\[Existen Solicitudes con invitación histórica para el Proveedor autenticado\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="145" y="258" width="560" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="p1\_63\_r1" value="1.1: presenta Insumo, cantidad solicitada, Unidad de Medida, vencimiento, estado y únicamente la respuesta propia si existe (sin exponer otros Proveedores)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="944" y="310" as="sourcePoint" /\>

            \<mxPoint x="131" y="310" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="p1\_63\_div" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="75" y="350" as="sourcePoint" /\>

            \<mxPoint x="1065" y="350" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="p1\_63\_g2" value="\[Sin invitaciones registradas o Solicitud consultada no dirigida a este Proveedor\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="145" y="360" width="580" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="p1\_63\_r2" value="1.2: informa resultado vacío o niega el acceso a una Solicitud ajena" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="944" y="425" as="sourcePoint" /\>

            \<mxPoint x="131" y="425" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<\!-- MARCO INDEPENDIENTE UC-13 \--\>

        \<mxCell id="p1\_sd13" value="sd Escenario Independiente — UC-13: Responder Solicitud de Cotización" style="shape=umlFrame;whiteSpace=wrap;html=1;width=460;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="515" width="1040" height="480" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="p1\_13\_m1" value="1: idRespuesta \= responderSolicitudCotizacion(idSolicitud:Long, precioUnitario:BigDecimal, cantidadOfrecida:BigDecimal, tiempoEntregaEstimado:Interval)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="131" y="565" as="sourcePoint" /\>

            \<mxPoint x="944" y="565" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="p1\_13\_alt" value="alt Revalidación al confirmar respuesta definitiva de cotización \[UC-13\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=460;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="75" y="590" width="990" height="380" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="p1\_13\_g1" value="\[Solicitud abierta en plazo, Proveedor ACTIVO, invitado históricamente, sin respuesta definitiva previa y datos estructurados válidos\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="145" y="615" width="800" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="p1\_13\_r1" value="1.1: registra por única vez la respuesta definitiva e inmutable con fecha y hora efectivas de confirmación" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="944" y="670" as="sourcePoint" /\>

            \<mxPoint x="131" y="670" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="p1\_13\_div1" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="75" y="715" as="sourcePoint" /\>

            \<mxPoint x="1065" y="715" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="p1\_13\_g2" value="\[Solicitud cerrada, plazo vencido, Proveedor INACTIVO o ya existe una respuesta definitiva previa del mismo Proveedor\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="145" y="725" width="760" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="p1\_13\_r2" value="1.2: rechaza el registro (no admite respuestas tardías ni reemplazo de una respuesta ya confirmada)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="944" y="790" as="sourcePoint" /\>

            \<mxPoint x="131" y="790" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="p1\_13\_div2" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="75" y="835" as="sourcePoint" /\>

            \<mxPoint x="1065" y="835" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="p1\_13\_g3" value="\[Datos estructurados de precio, disponibilidad o plazo inválidos\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="145" y="845" width="520" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="p1\_13\_r3" value="1.3: solicita corrección de los campos estructurados antes de confirmar" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="944" y="920" as="sourcePoint" /\>

            \<mxPoint x="131" y="920" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 2: DSS CAJA NEGRA — ADMINISTRADOR (UC-58, UC-44, UC-62, UC-12)     \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id="dss-rev03a-admin" name="DSS REV03A \- Admin Cotizaciones (UC-58,44,62,12)"\>

    \<mxGraphModel dx="1500" dy="950" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1450" pageHeight="1650" math="0" shadow="0"\>

      \<root\>

        \<mxCell id="0" /\>

        \<mxCell id="1" parent="0" /\>

        \<mxCell id="p2\_title" value="DSS (Caja Negra — REV03A) — Actor: Administrador — Escenarios Independientes UC-58, UC-44, UC-62 y UC-12 \[RD-RP013-001 / RD-RP012-001\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=13;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="15" width="1340" height="30" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="p2\_actor" value="Administrador" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="110" y="60" width="30" height="60" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="p2\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="119" y="155" width="12" height="1430" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="p2\_sys\_box" value=":Sistema" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;fontSize=13;" vertex="1" parent="1"\>

          \<mxGeometry x="940" y="60" width="140" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="p2\_sys\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1010" y="1600" as="sourcePoint" /\>

            \<mxPoint x="1010" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="p2\_sys\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1004" y="155" width="12" height="1430" as="geometry" /\>

        \</mxCell\>

        \<\!-- MARCO UC-58 \--\>

        \<mxCell id="p2\_sd58" value="sd Escenario Independiente — UC-58: Configurar Política de Compra \[RD-RP013-001 / RD-RP012-001\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=620;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="170" width="1100" height="250" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="p2\_58\_m1" value="1: numeroVersion \= configurarPoliticaCompra(vigenteDesde:Timestamp, vigenteHasta:Timestamp\[0..1\], periodoCalculoDias:Integer, criterios:List\&lt;CriterioPoliticaDTO\&gt;)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="131" y="220" as="sourcePoint" /\>

            \<mxPoint x="1004" y="220" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="p2\_58\_r1" value="1.1: \[Suma de pesoRelativo de criterios activos \== 100 %, ordenDesempate válido y vigencia sin solapamiento\] registra nueva versión de Política de Compra sin alterar decisiones pasadas" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1004" y="295" as="sourcePoint" /\>

            \<mxPoint x="131" y="295" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="p2\_58\_r2" value="1.2: \[Suma de pesos \!= 100 %, ordenDesempate duplicado o vigencias superpuestas\] rechaza la configuración y mantiene la versión vigente previa" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1004" y="375" as="sourcePoint" /\>

            \<mxPoint x="131" y="375" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<\!-- MARCO UC-44 \--\>

        \<mxCell id="p2\_sd44" value="sd Escenario Independiente — UC-44: Iniciar Ronda Manual de Cotización \[RD-RP012-001\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=560;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="450" width="1100" height="260" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="p2\_44\_m1" value="1: idSolicitud \= iniciarRondaManualCotizacion(idInsumo:Long, idSolicitudAnterior:Long\[0..1\], idsProveedoresInvitados:List\&lt;Long\&gt;)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="131" y="500" as="sourcePoint" /\>

            \<mxPoint x="1004" y="500" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="p2\_44\_r1" value="1.1: \[Insumo ACTIVO bajo umbral, sin Solicitud/Orden pendiente, cadena lineal válida y \&gt;= 1 Proveedor invitable\] emite Solicitud MANUAL con cantidad y vencimiento congelados (según parámetro global)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1004" y="575" as="sourcePoint" /\>

            \<mxPoint x="131" y="575" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="p2\_44\_r2" value="1.2: \[Existe Solicitud/Orden pendiente, intento de bifurcar la cadena o destinatarios sin invitabilidad\] bloquea la emisión" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1004" y="660" as="sourcePoint" /\>

            \<mxPoint x="131" y="660" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<\!-- MARCO UC-62 \--\>

        \<mxCell id="p2\_sd62" value="sd Escenario Independiente — UC-62: Buscar Solicitud de Cotización" style="shape=umlFrame;whiteSpace=wrap;html=1;width=440;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="740" width="1100" height="200" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="p2\_62\_m1" value="1: solicitudes \= buscarSolicitudCotizacion(idSolicitud:Long\[0..1\], idInsumo:Long\[0..1\], idEpisodio:Long\[0..1\], modalidadInicio:String\[0..1\], estado:String\[0..1\])" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="131" y="790" as="sourcePoint" /\>

            \<mxPoint x="1004" y="790" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="p2\_62\_r1" value="1.1: presenta Solicitudes coincidentes y detalle de la seleccionada en modo solo lectura (sin emitir ni cerrar Órdenes)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1004" y="875" as="sourcePoint" /\>

            \<mxPoint x="131" y="875" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<\!-- MARCO UC-12 (+ INCLUDE UC-62) \--\>

        \<mxCell id="p2\_sd12" value="sd Escenario Independiente — UC-12: Evaluar Cotizaciones y Resolver Compra (con «include» UC-62) \[RD-RP013-001\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=690;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="970" width="1100" height="580" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="p2\_12\_ref62" value="ref «include» UC-62 Buscar Solicitud de Cotización (aprobada 25/10 — selecciona Solicitud con recepción finalizada, identifica cotizaciones incompletas, aplica ordenDesempate configurado y expone empates persistentes)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=290;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="90" y="1005" width="840" height="60" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="p2\_12\_m1" value="1: resolucion \= evaluarCotizacionesYResolverCompra(idSolicitud:Long, decision:String, idRespuestaElegida:Long\[0..1\], justificacionOMotivo:String)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="131" y="1100" as="sourcePoint" /\>

            \<mxPoint x="1004" y="1100" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="p2\_12\_alt" value="alt Resolución Comercial Humana por el Administrador \[UC-12 — RD-RP013-001\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=520;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="75" y="1125" width="1050" height="395" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="p2\_12\_g1" value="\[decision \== COMPRAR, Proveedor elegido sigue ACTIVO, oferta elegible, faltante persiste y justificación informada (incluyendo decisión humana ante empate persistente)\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="145" y="1150" width="940" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="p2\_12\_r1" value="1.1: registra Decisión de Compra con sus antecedentes/puntajes, emite Orden de Compra PENDIENTE con condiciones congeladas y marca Solicitud CON\_COMPRA" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1004" y="1210" as="sourcePoint" /\>

            \<mxPoint x="131" y="1210" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="p2\_12\_div1" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="75" y="1255" as="sourcePoint" /\>

            \<mxPoint x="1125" y="1255" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="p2\_12\_g2" value="\[decision \== NO\_COMPRAR y motivo obligatorio informado\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="145" y="1265" width="520" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="p2\_12\_r2" value="1.2: cierra Solicitud como SIN\_COMPRA con motivo y Administrador responsable (sin emitir Orden de Compra; mantiene alerta del episodio si persiste el faltante)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1004" y="1335" as="sourcePoint" /\>

            \<mxPoint x="131" y="1335" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="p2\_12\_div2" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="75" y="1380" as="sourcePoint" /\>

            \<mxPoint x="1125" y="1380" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="p2\_12\_g3" value="\[Recepción aún abierta, Proveedor elegido pasó a INACTIVO, necesidad ya cubierta o falta justificación/motivo\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="145" y="1390" width="760" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="p2\_12\_r3" value="1.3: impide emitir Orden de Compra y solicita revisar alternativas o cerrar justificadamente sin compra" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1004" y="1465" as="sourcePoint" /\>

            \<mxPoint x="131" y="1465" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

\</mxfile\>

### **Archivo 3:** docs/08-diagramas/revision/DS\_REV03A\_COTIZACIONES\_UC12\_13\_44\_58\_62\_63.drawio.xml

Este archivo XML de **6 páginas** para **Draw.io** contiene los Diagramas de Secuencia de Diseño (DS de caja blanca) corregidos para UC-58, UC-44, UC-62, UC-63, UC-13 y UC-12, aplicando RD-RP013-001 (H-02, H-08) y RD-RP012-001 (H-16):

XML  
\<mxfile host="app.diagrams.net" modified="2026-10-28T11:40:00.000Z" agent="Gemini-REV03A" version="24.7.17" type="device"\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 1: DS UC-58 CONFIGURAR POLÍTICA DE COMPRA (RD-RP013-001/RP012-001) \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id="ds-rev03a-uc58" name="DS UC-58 Configurar Política Compra (REV03A)"\>

    \<mxGraphModel dx="1550" dy="850" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1500" pageHeight="950" math="0" shadow="0"\>

      \<root\>

        \<mxCell id="0" /\>

        \<mxCell id="1" parent="0" /\>

        \<mxCell id="u58\_title" value="Diagrama de Secuencia de Diseño (DS — REV03A) — UC-58: Configurar Política de Compra \[RD-RP013-001 / RD-RP012-001\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="15" width="1200" height="30" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u58\_actor" value="Administrador" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="90" y="60" width="30" height="60" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u58\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="99" y="155" width="12" height="720" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u58\_ctrl\_box" value=":ControladorCotizacionesCompras" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="350" y="60" width="210" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u58\_ctrl\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="455" y="900" as="sourcePoint" /\>

            \<mxPoint x="455" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u58\_ctrl\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="449" y="155" width="12" height="720" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u58\_repo\_box" value=":RepositorioCotizaciones" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="700" y="60" width="175" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u58\_repo\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="787" y="900" as="sourcePoint" /\>

            \<mxPoint x="787" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u58\_repo\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="781" y="290" width="12" height="310" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u58\_pol\_box" value="nuevaPol : PoliticaCompra&\#xa;+ CriterioPoliticaCompra \[1..\*\]" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1040" y="380" width="210" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u58\_pol\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1145" y="900" as="sourcePoint" /\>

            \<mxPoint x="1145" y="425" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u58\_pol\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1139" y="425" width="12" height="80" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u58\_m1" value="1: numeroVersion \= configurarPoliticaCompra(vigenteDesde:Timestamp, vigenteHasta:Timestamp\[0..1\], periodoCalculoDias:Integer, criterios:List\&lt;CriterioPoliticaDTO\&gt;)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="111" y="190" as="sourcePoint" /\>

            \<mxPoint x="449" y="190" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u58\_alt" value="alt Validación de suma de pesos activos \== 100 %, ordenDesempate y vigencia sin solapamiento \[UC-58 — RD-RP013-001\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=690;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="235" width="1360" height="585" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u58\_g1" value="\[criterios.notEmpty(), sumaPesosActivos \== 100 %, ordenDesempate único \&gt; 0, periodoCalculoDias \&gt; 0 y vigencia sin solapamiento\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="125" y="260" width="840" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u58\_m2" value="2: cerrarVigenciaAnteriorSinSolapamiento(vigenteDesde:Timestamp) \[Visibilidad por Atributo\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="461" y="315" as="sourcePoint" /\>

            \<mxPoint x="781" y="315" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u58\_m3\_new" value="3: «create» new(numeroVersion=sig, vigenteDesde, vigenteHasta, periodoCalculoDias, criterios) \[Creación Local\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="461" y="402" as="sourcePoint" /\>

            \<mxPoint x="1040" y="402" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u58\_m4" value="4: guardarVersionPoliticaCompra(nuevaPol:PoliticaCompra)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="461" y="545" as="sourcePoint" /\>

            \<mxPoint x="781" y="545" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u58\_r1\_ok" value="4.1: confirma nueva versión de PoliticaCompra y CriterioPoliticaCompra (sin alterar DecisionCompra pasadas)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="449" y="620" as="sourcePoint" /\>

            \<mxPoint x="111" y="620" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u58\_div" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="50" y="675" as="sourcePoint" /\>

            \<mxPoint x="1410" y="675" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u58\_g2" value="\[A1/A2: sumaPesosActivos \!= 100 %, ordenDesempate duplicado/inválido, periodoCalculoDias \&lt;= 0 o vigencia superpuesta\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="125" y="685" width="760" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u58\_r1\_err" value="4.2: rechaza la configuración y mantiene intacta la versión vigente previa" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="449" y="775" as="sourcePoint" /\>

            \<mxPoint x="111" y="775" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 2: DS UC-44 INICIAR RONDA MANUAL DE COTIZACIÓN (RD-RP012-001)      \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id="ds-rev03a-uc44" name="DS UC-44 Iniciar Ronda Manual (REV03A)"\>

    \<mxGraphModel dx="1650" dy="900" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1600" pageHeight="1100" math="0" shadow="0"\>

      \<root\>

        \<mxCell id="0" /\>

        \<mxCell id="1" parent="0" /\>

        \<mxCell id="u44\_title" value="Diagrama de Secuencia de Diseño (DS — REV03A) — UC-44: Iniciar Ronda Manual de Cotización \[RD-RP012-001\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="15" width="1100" height="30" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u44\_actor" value="Administrador" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="85" y="60" width="30" height="60" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u44\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="94" y="155" width="12" height="870" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u44\_ctrl\_box" value=":ControladorCotizacionesCompras" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="340" y="60" width="210" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u44\_ctrl\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="445" y="1050" as="sourcePoint" /\>

            \<mxPoint x="445" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u44\_ctrl\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="439" y="155" width="12" height="870" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u44\_repo\_box" value=":RepositorioCotizaciones" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="680" y="60" width="175" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u44\_repo\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="767" y="1050" as="sourcePoint" /\>

            \<mxPoint x="767" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u44\_repo\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="761" y="200" width="12" height="120" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u44\_sol\_box" value="nuevaSol :&\#xa;SolicitudCotizacion" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="990" y="470" width="175" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u44\_sol\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1077" y="1050" as="sourcePoint" /\>

            \<mxPoint x="1077" y="515" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u44\_sol\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1071" y="515" width="12" height="150" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u44\_inv\_box" value="inv : InvitacionCotizacion&\#xa;\[1..\*\]" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1280" y="580" width="180" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u44\_inv\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1370" y="1050" as="sourcePoint" /\>

            \<mxPoint x="1370" y="625" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u44\_inv\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1364" y="625" width="12" height="80" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u44\_m1" value="1: idSolicitud \= iniciarRondaManualCotizacion(idInsumo:Long, idSolicitudAnterior:Long\[0..1\], idsProveedoresInvitados:List\&lt;Long\&gt;)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="106" y="185" as="sourcePoint" /\>

            \<mxPoint x="439" y="185" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u44\_m2" value="2: ctx \= revalidarEpisodioCadenaLinealEInvitables(idInsumo, idSolicitudAnterior, idsProveedoresInvitados) \[Atributo\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="451" y="230" as="sourcePoint" /\>

            \<mxPoint x="761" y="230" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u44\_r2" value="2.1: (unEpisodio, cantAReponer \= nivelObjetivo \- stockActual, plazoHorasGlobal, cadenaLinealOk:Boolean, invitablesOk:Boolean)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="761" y="290" as="sourcePoint" /\>

            \<mxPoint x="451" y="290" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u44\_alt" value="alt Revalidación de faltante vigente, cadena lineal y Proveedores invitables \[UC-44 — RD-RP012-001\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=610;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="360" width="1460" height="620" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u44\_g1" value="\[Insumo ACTIVO, stockActual \&lt; umbralMinimo, sin Solicitud/Orden pendiente, cadenaLinealOk \== true e invitablesOk \== true\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="385" width="780" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u44\_m3\_new" value="3: «create» new(unEpisodio, idSolicitudAnterior\[0..1\], idAdmin, cantAReponer, fechaHoraVencimiento congelada según parámetro global, modalidadInicio=MANUAL)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="451" y="492" as="sourcePoint" /\>

            \<mxPoint x="990" y="492" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u44\_m4\_new" value="4: «create» new(nuevaSol, provInvitado, fechaHoraInvitacion) \[Asociación histórica irrevocable\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1083" y="602" as="sourcePoint" /\>

            \<mxPoint x="1280" y="602" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u44\_r1\_ok" value="4.1: publica SolicitudCotizacion (RECEPCION\_ABIERTA) en el portal para destinatarios invitados sin generar OrdenCompra" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="439" y="755" as="sourcePoint" /\>

            \<mxPoint x="106" y="755" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u44\_div" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="50" y="820" as="sourcePoint" /\>

            \<mxPoint x="1510" y="820" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u44\_g2" value="\[A1/A2/A3: Solicitud u Orden pendiente, intento de bifurcar la cadena, stock \&gt;= umbral o destinatario sin invitabilidad\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="830" width="760" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u44\_r1\_err" value="4.2: bloquea la emisión sin crear Solicitud parcial ni alterar antecedentes" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="439" y="925" as="sourcePoint" /\>

            \<mxPoint x="106" y="925" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 3: DS UC-62 BUSCAR SOLICITUD DE COTIZACIÓN                         \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id="ds-rev03a-uc62" name="DS UC-62 Buscar Solicitud Cotización (REV03A)"\>

    \<mxGraphModel dx="1450" dy="800" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1400" pageHeight="850" math="0" shadow="0"\>

      \<root\>

        \<mxCell id="0" /\>

        \<mxCell id="1" parent="0" /\>

        \<mxCell id="u62\_title" value="Diagrama de Secuencia de Diseño (DS — REV03A) — UC-62: Buscar Solicitud de Cotización" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="15" width="900" height="30" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u62\_actor" value="Administrador" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="90" y="60" width="30" height="60" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u62\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="99" y="155" width="12" height="620" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u62\_ctrl\_box" value=":ControladorCotizacionesCompras" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="380" y="60" width="210" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u62\_ctrl\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="485" y="800" as="sourcePoint" /\>

            \<mxPoint x="485" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u62\_ctrl\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="479" y="155" width="12" height="620" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u62\_repo\_box" value=":RepositorioCotizaciones" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="780" y="60" width="175" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u62\_repo\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="867" y="800" as="sourcePoint" /\>

            \<mxPoint x="867" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u62\_repo\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="861" y="200" width="12" height="120" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u62\_m1" value="1: solicitudes \= buscarSolicitudCotizacion(idSolicitud:Long\[0..1\], idInsumo:Long\[0..1\], idEpisodio:Long\[0..1\], modalidadInicio:String\[0..1\], estado:String\[0..1\])" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="111" y="190" as="sourcePoint" /\>

            \<mxPoint x="479" y="190" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u62\_m2" value="2: consultarSolicitudesConEpisodio(filtro) \[Visibilidad por Atributo\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="491" y="235" as="sourcePoint" /\>

            \<mxPoint x="861" y="235" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u62\_r2" value="2.1: List\&lt;SolicitudCotizacion\&gt;" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="861" y="295" as="sourcePoint" /\>

            \<mxPoint x="491" y="295" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u62\_alt" value="alt Resultado de la búsqueda de Solicitudes de Cotización \[UC-62\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=410;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="340" width="1180" height="380" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u62\_g1" value="\[Existen Solicitudes coincidentes\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="125" y="365" width="350" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u62\_r1\_ok" value="3.1: muestra fechaHoraEmision, fechaHoraVencimiento, estado, modalidadInicio, cantidadSolicitada, invitaciones e idSolicitudAnterior; devuelve referencia al CU invocante" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="479" y="455" as="sourcePoint" /\>

            \<mxPoint x="111" y="455" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u62\_div" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="50" y="555" as="sourcePoint" /\>

            \<mxPoint x="1230" y="555" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u62\_g2" value="\[Sin coincidencias o criterios inválidos\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="125" y="565" width="350" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u62\_r1\_empty" value="3.2: informa resultado vacío o solicita corrección sin alterar Solicitudes ni Órdenes" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="479" y="655" as="sourcePoint" /\>

            \<mxPoint x="111" y="655" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 4: DS UC-63 CONSULTAR SOLICITUDES DE COTIZACIÓN RECIBIDAS          \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id="ds-rev03a-uc63" name="DS UC-63 Consultar Solicitudes Recibidas (REV03A)"\>

    \<mxGraphModel dx="1450" dy="800" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1400" pageHeight="850" math="0" shadow="0"\>

      \<root\>

        \<mxCell id="0" /\>

        \<mxCell id="1" parent="0" /\>

        \<mxCell id="u63\_title" value="Diagrama de Secuencia de Diseño (DS — REV03A) — UC-63: Consultar Solicitudes de Cotización Recibidas" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="15" width="980" height="30" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u63\_actor" value="Proveedor&\#xa;(Usuario PROVEEDOR)" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="90" y="60" width="30" height="60" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u63\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="99" y="155" width="12" height="620" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u63\_ctrl\_box" value=":ControladorCotizacionesCompras" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="380" y="60" width="210" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u63\_ctrl\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="485" y="800" as="sourcePoint" /\>

            \<mxPoint x="485" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u63\_ctrl\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="479" y="155" width="12" height="620" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u63\_repo\_box" value=":RepositorioCotizaciones" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="780" y="60" width="175" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u63\_repo\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="867" y="800" as="sourcePoint" /\>

            \<mxPoint x="867" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u63\_repo\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="861" y="200" width="12" height="140" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u63\_m1" value="1: misSolicitudes \= consultarSolicitudesCotizacionRecibidas(idSolicitudSeleccionada:Long\[0..1\])" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="111" y="190" as="sourcePoint" /\>

            \<mxPoint x="479" y="190" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u63\_m2" value="2: obtenerSolicitudesInvitadasYRespuestaPropia(idProveedorAutenticado, idSolicitudSeleccionada) \[Atributo \+ Parámetro\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="491" y="235" as="sourcePoint" /\>

            \<mxPoint x="861" y="235" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u63\_r2" value="2.1: Solicitudes con InvitacionCotizacion propia \+ RespuestaCotizacion propia \[0..1\] (sin exponer terceros)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="861" y="305" as="sourcePoint" /\>

            \<mxPoint x="491" y="305" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u63\_alt" value="alt Resultado de la consulta en el portal de Proveedores \[UC-63\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=410;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="360" width="1180" height="360" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u63\_g1" value="\[Cuenta PROVEEDOR habilitada con credencial ya actualizada e invitación perteneciente al Proveedor\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="125" y="385" width="660" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u63\_r1\_ok" value="3.1: muestra Insumo, cantidadSolicitada, Unidad de Medida, fechaHoraVencimiento, estado y respuesta propia (distinguiendo abiertas sin respuesta de cerradas/respondidas)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="479" y="465" as="sourcePoint" /\>

            \<mxPoint x="111" y="465" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u63\_div" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="50" y="555" as="sourcePoint" /\>

            \<mxPoint x="1230" y="555" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u63\_g2" value="\[A1/A2/A3: Sin invitaciones registradas o Solicitud seleccionada no dirigida al Proveedor autenticado\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="125" y="565" width="640" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u63\_r1\_err" value="3.2: muestra listado vacío o niega el acceso al detalle de una Solicitud ajena" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="479" y="655" as="sourcePoint" /\>

            \<mxPoint x="111" y="655" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 5: DS UC-13 RESPONDER SOLICITUD DE COTIZACIÓN                      \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id="ds-rev03a-uc13" name="DS UC-13 Responder Solicitud Cotización (REV03A)"\>

    \<mxGraphModel dx="1600" dy="900" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1550" pageHeight="1050" math="0" shadow="0"\>

      \<root\>

        \<mxCell id="0" /\>

        \<mxCell id="1" parent="0" /\>

        \<mxCell id="u13\_title" value="Diagrama de Secuencia de Diseño (DS — REV03A) — UC-13: Responder Solicitud de Cotización" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="15" width="950" height="30" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u13\_actor" value="Proveedor&\#xa;(Usuario PROVEEDOR)" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="85" y="60" width="30" height="60" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u13\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="94" y="155" width="12" height="820" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u13\_ctrl\_box" value=":ControladorCotizacionesCompras" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="350" y="60" width="210" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u13\_ctrl\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="455" y="1000" as="sourcePoint" /\>

            \<mxPoint x="455" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u13\_ctrl\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="449" y="155" width="12" height="820" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u13\_sol\_box" value="unaSolicitud :&\#xa;SolicitudCotizacion" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="700" y="60" width="175" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u13\_sol\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="787" y="1000" as="sourcePoint" /\>

            \<mxPoint x="787" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u13\_sol\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="781" y="210" width="12" height="120" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u13\_rsp\_box" value="unaResp :&\#xa;RespuestaCotizacion" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1080" y="480" width="180" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u13\_rsp\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1170" y="1000" as="sourcePoint" /\>

            \<mxPoint x="1170" y="525" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u13\_rsp\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1164" y="525" width="12" height="80" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u13\_m1" value="1: idRespuesta \= responderSolicitudCotizacion(idSolicitud:Long, precioUnitario:BigDecimal, cantidadOfrecida:BigDecimal, tiempoEntregaEstimado:Interval)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="106" y="185" as="sourcePoint" /\>

            \<mxPoint x="449" y="185" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u13\_m2" value="2: elegible \= revalidarRecepcionAbiertaPlazoYUnicaRespuesta(idProveedor, precioUnitario, cantidadOfrecida, tiempoEntregaEstimado)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="461" y="235" as="sourcePoint" /\>

            \<mxPoint x="781" y="235" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u13\_r2" value="2.1: (invitadoHistorico:Boolean, recepcionAbiertaEnPlazo:Boolean, proveedorActivo:Boolean, sinRespuestaPrevia:Boolean)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="781" y="295" as="sourcePoint" /\>

            \<mxPoint x="461" y="295" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u13\_alt" value="alt Revalidación de RECEPCION\_ABIERTA, plazo \&lt;= fechaHoraVencimiento, Proveedor ACTIVO y sin respuesta previa \[UC-13\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=750;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="365" width="1390" height="550" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u13\_g1" value="\[invitadoHistorico \== true, recepcionAbiertaEnPlazo \== true, proveedorActivo \== true, sinRespuestaPrevia \== true y campos válidos\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="390" width="800" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u13\_m3\_new" value="3: «create» new(unaSolicitud, unProveedor, idUsuarioRegistrador, cantidadOfrecida, precioUnitario, tiempoEntregaEstimado, fechaHoraRespuesta)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="461" y="502" as="sourcePoint" /\>

            \<mxPoint x="1080" y="502" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u13\_r1\_ok" value="3.1: registra RespuestaCotizacion definitiva e inmutable (su elegibilidad comercial se evalúa en UC-12)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="449" y="655" as="sourcePoint" /\>

            \<mxPoint x="106" y="655" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u13\_div" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="50" y="725" as="sourcePoint" /\>

            \<mxPoint x="1440" y="725" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u13\_g2" value="\[Solicitud cerrada/vencida, Proveedor INACTIVO, ya existe respuesta definitiva previa o campos inválidos\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="735" width="680" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u13\_r1\_err" value="3.2: rechaza el registro sin generar RespuestaCotizacion tardía ni duplicada" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="449" y="845" as="sourcePoint" /\>

            \<mxPoint x="106" y="845" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 6: DS UC-12 EVALUAR COTIZACIONES Y RESOLVER COMPRA (RD-RP013-001)  \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id="ds-rev03a-uc12" name="DS UC-12 Evaluar y Resolver Compra (REV03A)"\>

    \<mxGraphModel dx="1650" dy="950" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1600" pageHeight="1250" math="0" shadow="0"\>

      \<root\>

        \<mxCell id="0" /\>

        \<mxCell id="1" parent="0" /\>

        \<mxCell id="u12\_title" value="Diagrama de Secuencia de Diseño (DS — REV03A) — UC-12: Evaluar Cotizaciones y Resolver Compra (con «include» UC-62) \[RD-RP013-001\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="15" width="1320" height="30" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u12\_actor" value="Administrador" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="85" y="60" width="30" height="60" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u12\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="94" y="155" width="12" height="1020" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u12\_ctrl\_box" value=":ControladorCotizacionesCompras" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="340" y="60" width="210" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u12\_ctrl\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="445" y="1200" as="sourcePoint" /\>

            \<mxPoint x="445" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u12\_ctrl\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="439" y="155" width="12" height="1020" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u12\_pol\_box" value="polVigente : PoliticaCompra&\#xa;/ unaSolicitud : SolicitudCotizacion" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="680" y="60" width="210" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u12\_pol\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="785" y="1200" as="sourcePoint" /\>

            \<mxPoint x="785" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u12\_pol\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="779" y="250" width="12" height="690" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u12\_dec\_box" value="unaDecision : DecisionCompra&\#xa;+ DetalleDecision / Criterio" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="990" y="540" width="200" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u12\_dec\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1090" y="1200" as="sourcePoint" /\>

            \<mxPoint x="1090" y="585" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u12\_dec\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1084" y="585" width="12" height="80" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u12\_oc\_box" value="unaOrden : OrdenCompra" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1280" y="660" width="180" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u12\_oc\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1370" y="1200" as="sourcePoint" /\>

            \<mxPoint x="1370" y="705" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u12\_oc\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1364" y="705" width="12" height="80" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u12\_ref62" value="ref «include» UC-62 Buscar Solicitud de Cotización (aprobada 25/10 — selecciona Solicitud con recepción finalizada y ofertas elegibles)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=280;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="65" y="165" width="760" height="55" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u12\_m0" value="0.1: eval \= evaluarOfertasSegunPoliticaVigente(unaSolicitud) \[RD-RP013-001: señala cotizaciones incompletas, aplica ordenDesempate y expone empates\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="451" y="265" as="sourcePoint" /\>

            \<mxPoint x="779" y="265" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u12\_r0" value="0.2: presenta ranking sugerido, cotizaciones incompletas identificadas y eventual empate persistente (sin selección automática)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="779" y="320" as="sourcePoint" /\>

            \<mxPoint x="106" y="320" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u12\_m1" value="1: resolucion \= evaluarCotizacionesYResolverCompra(idSolicitud:Long, decision:String, idRespuestaElegida:Long\[0..1\], justificacionOMotivo:String)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="106" y="385" as="sourcePoint" /\>

            \<mxPoint x="439" y="385" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<\!-- FRAGMENTO ALT CON 3 OPERANDOS EXCLUYENTES \--\>

        \<mxCell id="u12\_alt" value="alt Resolución Comercial Humana por el Administrador \[UC-12 — RD-RP013-001\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=550;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="45" y="435" width="1495" height="700" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u12\_g1" value="\[decision \== COMPRAR, Proveedor elegido sigue ACTIVO, oferta elegible, faltante persiste y justificacionOMotivo informado\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="460" width="780" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u12\_m2\_new" value="2: «create» new(idSolicitud, idPoliticaCompra, idAdmin, idRespuestaElegida, resultado=CON\_COMPRA, justificacion)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="451" y="562" as="sourcePoint" /\>

            \<mxPoint x="990" y="562" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u12\_m3\_new" value="3: «create» new(unaDecision, cantidadOrdenada, precioUnitarioAcordado, fechaHoraComprometidaEntrega, estado=PENDIENTE)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="451" y="682" as="sourcePoint" /\>

            \<mxPoint x="1280" y="682" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u12\_r1\_comp" value="3.1: marca Solicitud CON\_COMPRA y comunica idOrdenCompra (PENDIENTE)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="439" y="800" as="sourcePoint" /\>

            \<mxPoint x="106" y="800" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u12\_div1" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="45" y="840" as="sourcePoint" /\>

            \<mxPoint x="1540" y="840" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u12\_g2" value="\[decision \== NO\_COMPRAR y justificacionOMotivo obligatorio informado\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="850" width="520" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u12\_m4" value="4: cerrarSinCompra(justificacionOMotivo, idAdmin, fechaHoraResolucion)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="451" y="905" as="sourcePoint" /\>

            \<mxPoint x="779" y="905" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u12\_r1\_nocomp" value="4.1: cierra Solicitud SIN\_COMPRA sin emitir OrdenCompra (mantiene alerta del episodio si persiste el faltante)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="439" y="965" as="sourcePoint" /\>

            \<mxPoint x="106" y="965" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u12\_div2" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="45" y="1005" as="sourcePoint" /\>

            \<mxPoint x="1540" y="1005" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u12\_g3" value="\[A2/A4/A6/A10: Recepción abierta, Proveedor elegido pasó a INACTIVO, necesidad ya cubierta o falta justificación/motivo\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="1015" width="780" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u12\_r1\_err" value="4.2: rechaza la confirmación sin emitir OrdenCompra parcial ni alterar antecedentes" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="439" y="1095" as="sourcePoint" /\>

            \<mxPoint x="106" y="1095" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

\</mxfile\>

### **Archivo 4:** docs/08-diagramas/revision/CONTRATOS\_REV03A\_COTIZACIONES\_6\_OPERACIONES.md

Este archivo contiene los **6 Contratos individuales desagrupados** (UC-58, UC-44, UC-62, UC-63, UC-13, UC-12) con las **9 secciones estándar** y aplicación estricta de RD-RP013-001 (H-02, H-08) y RD-RP012-001 (H-16):

Markdown  
\# Contratos de Operación del Sistema (DSS — REV-03A) — Compras y Cotizaciones (6 Contratos Individuales)

**\*\*Proyecto:\*\*** Sistema de Gestión para Ale Milanesas (UNaM-FCEQyN)  

**\*\*Lote de revisión:\*\*** \`REV-03A\` (\`UC-58\`, \`UC-44\`, \`UC-62\`, \`UC-63\`, \`UC-13\`, \`UC-12\`)  

**\*\*Decisiones incorporadas:\*\*** \`RD-RP013-001\` (\`H-02\`, \`H-08\`: suma de pesos activos \= 100 %, identificación expresa de cotizaciones incompletas, aplicación de \`ordenDesempate\` y desempate final por Administrador), \`RD-RP012-001\` (\`H-16\`: fuente del plazo por parámetro global con vencimiento congelado y firma de \`UC-58\` desacoplada) y relación \`include\` aprobada el 25/10/2026 (\`UC-12→UC-62\`).

\---

\#\# 1\. Contrato de la Operación \`configurarPoliticaCompra\` (\`UC-58\`)

1\. **\*\*Nombre:\*\*** \`configurarPoliticaCompra(vigenteDesde: Timestamp, vigenteHasta: Timestamp\[0..1\], periodoCalculoDias: Integer, criterios: List\<CriterioPoliticaDTO\>)\`

2\. **\*\*Responsabilidades:\*\*** Registrar una nueva versión verificable de \`PoliticaCompra\` y sus \`CriterioPoliticaCompra\` asociados, validando que la suma de \`pesoRelativo\` de los criterios activos sea exactamente igual al **\*\*100 %\*\*** y que cada criterio posea un \`ordenDesempate\` válido, sin modificar decisiones de compra ni evaluaciones pasadas.

3\. **\*\*Tipo:\*\*** \`Sistema\`

4\. **\*\*Referencias cruzadas:\*\*** Caso de Uso \`UC-58 — Configurar Política de Compra\`; Caso de Uso \`UC-12 — Evaluar Cotizaciones y Resolver Compra\`; Decisiones \`RD-RP013-001\` y \`RD-RP012-001\`; Objetivo \`OBJE-09\`; Requisitos \`RF-05\`, \`RF-11\`; Información \`IRQ-08\`.

5\. **\*\*Notas:\*\*** Conforme a \`RD-RP013-001\`, los pesos relativos de los criterios activos deben sumar **\*\*100 %\*\***; en la evaluación (\`UC-12\`), toda cotización u oferta con datos faltantes se identifica como **\*\*incompleta\*\*** (sin asignarle puntaje cero silencioso ni imponer un desempate fijo por precio total al margen de \`ordenDesempate\`). Conforme a \`RD-RP012-001\`, \`periodoCalculoDias\` delimita la ventana histórica de indicadores (confiabilidad/habitualidad) y no fija el plazo de respuesta de \`SolicitudCotizacion\`.

6\. **\*\*Excepciones:\*\***

   \* **\*\*A1 — Suma de pesos distinta de 100 % (\`sumaPesosActivos \!= 100\`):\*\*** Rechazar la configuración y solicitar ajustar las ponderaciones (\`RD-RP013-001\`).

   \* **\*\*A2 — \`codigoCriterio\` repetido, \`pesoRelativo \< 0\` u \`ordenDesempate \<= 0\` o duplicado:\*\*** Impedir la confirmación.

   \* **\*\*A3 — Fechas inválidas, \`periodoCalculoDias \<= 0\` o intervalo \`\[vigenteDesde, vigenteHasta)\` superpuesto con otra versión:\*\*** Rechazar la configuración conservando la versión vigente previa.

7\. **\*\*Salida:\*\***

   \* Confirmación del \`numeroVersion\` y vigencia de la nueva \`PoliticaCompra\` registrada, o mensajes de rechazo provocados por las excepciones A1–A3.

8\. **\*\*Precondiciones:\*\***

   \* El \`Administrador\` se encuentra autenticado y autorizado.

9\. **\*\*Postcondiciones:\*\***

   \* Si existía una versión vigente anterior de \`PoliticaCompra\`, se acotó su \`vigenteHasta\` sin generar solapamiento temporal ni alterar \`DecisionCompra\` históricas.

   \* Se creó una instancia \`nuevaPolitica\` de \`PoliticaCompra\` con \`numeroVersion\` correlativo, \`vigenteDesde\`, \`vigenteHasta\` y \`periodoCalculoDias\`.

   \* Para cada criterio configurado en \`criterios\` (cuya suma de \`pesoRelativo\` es igual a 100 %), se creó una instancia de \`CriterioPoliticaCompra\` asociada a \`nuevaPolitica\` con \`codigoCriterio\`, \`pesoRelativo\` y \`ordenDesempate\`.

\---

\#\# 2\. Contrato de la Operación \`iniciarRondaManualCotizacion\` (\`UC-44\`)

1\. **\*\*Nombre:\*\*** \`iniciarRondaManualCotizacion(idInsumo: Long, idSolicitudAnterior: Long\[0..1\], idsProveedoresInvitados: List\<Long\>)\`

2\. **\*\*Responsabilidades:\*\*** Emitir por decisión administrativa una \`SolicitudCotizacion\` con \`modalidadInicio \= MANUAL\` dentro de un \`EpisodioFaltante\` abierto y sin operaciones en curso, congelando la \`cantidadSolicitada\` y la \`fechaHoraVencimiento\` (determinada a partir del parámetro global vigente) y publicando las \`InvitacionCotizacion\` para los Proveedores invitables seleccionados.

3\. **\*\*Tipo:\*\*** \`Sistema\`

4\. **\*\*Referencias cruzadas:\*\*** Caso de Uso \`UC-44 — Iniciar Ronda Manual de Cotización\`; Decisión \`RD-RP012-001\`; Objetivos \`OBJE-07\`, \`OBJE-09\`; Requisitos \`RF-05\`, \`RF-11\`; Información \`IRQ-07\`, \`IRQ-08\`.

5\. **\*\*Notas:\*\*** Existe a lo sumo una primera ronda \`AUTOMATICA\` por episodio (\`PRA-01\`); toda ronda ulterior se emite mediante \`UC-44\` manteniendo una cadena lineal (\`idSolicitudAnterior\` \`0..1\`) sin bifurcaciones. Un \`Proveedor\` es invitable solo si está \`ACTIVO\`, tiene vínculo vigente en \`ProveedorInsumo\` para el \`Insumo\` y posee cuenta de \`Usuario\` habilitada en \`UsuarioProveedor\`. El plazo de respuesta se toma de la configuración global (\`RD-RP012-001\`), sin asumir «48 horas» como defecto fijo.

6\. **\*\*Excepciones:\*\***

   \* **\*\*A1 — \`Insumo\` inactivo, sin faltante vigente (\`stockActual \>= umbralMinimo\`) o \`cantidadSolicitada \<= 0\`:\*\*** Rechazar el inicio de la ronda.

   \* **\*\*A2 — Existe otra \`SolicitudCotizacion\` abierta u \`OrdenCompra\` pendiente para el mismo episodio, o \`idSolicitudAnterior\` intenta bifurcar la cadena:\*\*** Bloquear la emisión.

   \* **\*\*A3 — Lista \`idsProveedoresInvitados\` vacía o algún destinatario seleccionado carece de condición \`ACTIVO\` o de cuenta \`Usuario\` habilitada al confirmar:\*\*** Rechazar la emisión sin crear Solicitud parcial.

7\. **\*\*Salida:\*\***

   \* Confirmación del \`idSolicitud\`, \`cantidadSolicitada\`, \`fechaHoraVencimiento\` congelada y Proveedores invitados habilitados en el portal; o mensajes provocados por las excepciones A1–A3.

8\. **\*\*Precondiciones:\*\***

   \* El \`Administrador\` se encuentra autenticado y autorizado.

   \* El \`Insumo\` está \`ACTIVO\` con \`stockActual \< umbralMinimo\`, existe un \`EpisodioFaltante\` abierto sin Solicitud abierta ni Orden pendiente, y está configurado el parámetro global del plazo de respuesta a cotizaciones (\`RD-RP012-001\`).

9\. **\*\*Postcondiciones:\*\***

   \* Se creó una instancia \`nuevaSolicitud\` de \`SolicitudCotizacion\` con \`modalidadInicio \= MANUAL\`, \`estado \= RECEPCION\_ABIERTA\`, \`cantidadSolicitada \= nivelObjetivoReposicion \- stockActual\`, \`fechaHoraEmision\` y \`fechaHoraVencimiento\` congeladas.

   \* Se asoció \`nuevaSolicitud\` con el \`EpisodioFaltante\`, con el \`Insumo\`, con el \`Usuario\` Administrador y con la \`SolicitudCotizacion\` antecedente (\`idSolicitudAnterior\` \`0..1\`).

   \* Para cada Proveedor en \`idsProveedoresInvitados\`, se creó una instancia histórica e irrevocable de \`InvitacionCotizacion\` asociada a \`nuevaSolicitud\` y al \`Proveedor\`.

\---

\#\# 3\. Contrato de la Operación \`buscarSolicitudCotizacion\` (\`UC-62\`)

1\. **\*\*Nombre:\*\*** \`buscarSolicitudCotizacion(idSolicitud: Long\[0..1\], idInsumo: Long\[0..1\], idEpisodio: Long\[0..1\], modalidadInicio: String\[0..1\], estado: String\[0..1\])\`

2\. **\*\*Responsabilidades:\*\*** Localizar y presentar en modo solo lectura las \`SolicitudCotizacion\` que cumplan los criterios indicados junto con su estado de recepción, invitaciones y eslabón antecedente, devolviendo la referencia seleccionada al flujo invocante (\`UC-12\` o seguimiento administrativo).

3\. **\*\*Tipo:\*\*** \`Sistema\`

4\. **\*\*Referencias cruzadas:\*\*** Caso de Uso \`UC-62 — Buscar Solicitud de Cotización\`; incluido por \`UC-12 — Evaluar Cotizaciones y Resolver Compra\` *\*(relación aprobada el 25/10/2026)\**; Objetivo \`OBJE-09\`; Requisitos \`RF-05\`, \`RF-11\`.

5\. **\*\*Notas:\*\*** Operación estrictamente de solo lectura. No emite ni cierra Solicitudes ni Órdenes de Compra.

6\. **\*\*Excepciones:\*\***

   \* **\*\*A1 — Criterios de búsqueda inválidos:\*\*** Solicitar corrección sin ejecutar la consulta.

   \* **\*\*A2 — Sin Solicitudes coincidentes:\*\*** Informar resultado vacío.

7\. **\*\*Salida:\*\***

   \* Listado de \`SolicitudCotizacion\` coincidentes y detalle de la seleccionada (\`Insumo\`, \`cantidadSolicitada\`, \`fechaHoraEmision\`, \`fechaHoraVencimiento\`, \`fechaHoraFinRecepcion\`, \`estado\`, \`modalidadInicio\`, \`motivoCierre\`, \`idSolicitudAnterior\` e invitaciones); o mensajes de las excepciones A1–A2.

8\. **\*\*Precondiciones:\*\***

   \* El \`Administrador\` se encuentra autenticado y autorizado.

9\. **\*\*Postcondiciones:\*\***

   \* *\*(Sin cambios de estado en el sistema: no se crean ni modifican instancias de \`SolicitudCotizacion\`, \`RespuestaCotizacion\` ni \`OrdenCompra\`)\**.

\---

\#\# 4\. Contrato de la Operación \`consultarSolicitudesCotizacionRecibidas\` (\`UC-63\`)

1\. **\*\*Nombre:\*\*** \`consultarSolicitudesCotizacionRecibidas(idSolicitudSeleccionada: Long\[0..1\])\`

2\. **\*\*Responsabilidades:\*\*** Mostrar exclusivamente las \`SolicitudCotizacion\` para las que consta una \`InvitacionCotizacion\` histórica dirigida al \`Proveedor\` vinculado al \`Usuario\` \`PROVEEDOR\` autenticado, distinguiendo las abiertas sin respuesta de las cerradas, vencidas o ya respondidas por ese mismo Proveedor.

3\. **\*\*Tipo:\*\*** \`Sistema\`

4\. **\*\*Referencias cruzadas:\*\*** Caso de Uso \`UC-63 — Consultar Solicitudes de Cotización Recibidas\`; Caso de Uso \`UC-13 — Responder Solicitud de Cotización\`; Objetivo \`OBJE-09\`; Requisito \`RF-11\`.

5\. **\*\*Notas:\*\*** Operación estrictamente de solo lectura. Jamás expone invitaciones ni respuestas de otros Proveedores.

6\. **\*\*Excepciones:\*\***

   \* **\*\*A1 — Cuenta no habilitada, sin Rol exclusivo \`PROVEEDOR\` o con \`cambioCredencialPendiente \= true\`:\*\*** Negar la consulta operativa.

   \* **\*\*A2 — Sin invitaciones registradas para el Proveedor autenticado:\*\*** Informar resultado vacío.

   \* **\*\*A3 — \`idSolicitudSeleccionada\` no fue dirigida al Proveedor autenticado:\*\*** Negar el acceso al detalle aunque se conozca el identificador.

7\. **\*\*Salida:\*\***

   \* Listado de \`SolicitudCotizacion\` invitadas (\`Insumo\`, \`cantidadSolicitada\`, \`UnidadMedida\`, \`fechaHoraVencimiento\`, \`estado\`, existencia de \`RespuestaCotizacion\` propia) y detalle de la seleccionada con la respuesta propia si existe; o mensajes de las excepciones A1–A3.

8\. **\*\*Precondiciones:\*\***

   \* El actor se encuentra autenticado con cuenta \`HABILITADO\` de Rol exclusivo \`PROVEEDOR\`, vinculada a un único \`Proveedor\`, y con \`cambioCredencialPendiente \= false\`.

9\. **\*\*Postcondiciones:\*\***

   \* *\*(Sin cambios de estado en el sistema: ninguna \`RespuestaCotizacion\` ni \`SolicitudCotizacion\` fue creada o modificada)\**.

\---

\#\# 5\. Contrato de la Operación \`responderSolicitudCotizacion\` (\`UC-13\`)

1\. **\*\*Nombre:\*\*** \`responderSolicitudCotizacion(idSolicitud: Long, precioUnitario: BigDecimal, cantidadOfrecida: BigDecimal, tiempoEntregaEstimado: Interval)\`

2\. **\*\*Responsabilidades:\*\*** Registrar por única vez y con carácter definitivo e inmutable las condiciones estructuradas de suministro informadas en el portal web por un \`Proveedor\` invitado frente a una \`SolicitudCotizacion\` en \`RECEPCION\_ABIERTA\` y dentro de su \`fechaHoraVencimiento\`.

3\. **\*\*Tipo:\*\*** \`Sistema\`

4\. **\*\*Referencias cruzadas:\*\*** Caso de Uso \`UC-13 — Responder Solicitud de Cotización\`; Caso de Uso \`UC-12 — Evaluar Cotizaciones y Resolver Compra\`; Objetivo \`OBJE-09\`; Requisito \`RF-11\`.

5\. **\*\*Notas:\*\*** No se admiten cargas por teléfono/mensajería ni interpretación de texto libre. Cada invitación admite a lo sumo una única \`RespuestaCotizacion\` definitiva e inmutable; su elegibilidad comercial e integridad de datos para cubrir la solicitud se evalúan en \`UC-12\`.

6\. **\*\*Excepciones:\*\***

   \* **\*\*A1 — La Solicitud no existe o no posee \`InvitacionCotizacion\` para el Proveedor autenticado:\*\*** Rechazar la operación.

   \* **\*\*A2 — Campos estructurados inválidos (\`precioUnitario\`, \`cantidadOfrecida\` o \`tiempoEntregaEstimado\`):\*\*** Solicitar corrección antes de confirmar.

   \* **\*\*A3 — Ya consta una \`RespuestaCotizacion\` definitiva previa del mismo Proveedor para esa Solicitud:\*\*** Rechazar el registro de una segunda respuesta.

   \* **\*\*A4 — La Solicitud ya no está en \`RECEPCION*\_ABIERTA\`, superó \`fechaHoraVencimiento\` o el Proveedor dejó de estar \`ACTIVO\` al confirmar:\*\* Rechazar el registro sin crear respuesta tardía.***

***7\. \*\*Salida:\*\****

   ***\* Confirmación del registro definitivo de la \`RespuestaCotizacion\` con su \`idRespuesta\` y \`fechaHoraRespuesta\`, o mensajes provocados por las excepciones A1–A4.***

***8\. \*\*Precondiciones:\*\****

   ***\* El actor está autenticado con su Usuario \`PROVEEDOR\` habilitado (\`cambioCredencialPendiente \= false\`), su \`Proveedor\` comercial está \`ACTIVO\`, consta \`InvitacionCotizacion\` para \`idSolicitud\` y no existe respuesta definitiva previa de ese Proveedor para dicha Solicitud.***

***9\. \*\*Postcondiciones:\*\****

   ***\* Se creó una única instancia \`unaRespuesta\` de \`RespuestaCotizacion\` con carácter definitivo e inmutable.***

   ***\* Se inicializaron \`unaRespuesta.precioUnitario\`, \`unaRespuesta.cantidadOfrecida\`, \`unaRespuesta.tiempoEntregaEstimado\` y \`unaRespuesta.fechaHoraRespuesta\` (validada \`\<= SolicitudCotizacion.fechaHoraVencimiento\`).***

   ***\* Se asoció \`unaRespuesta\` con la \`SolicitudCotizacion\`, con el \`Proveedor\` comercial y con el \`Usuario\` \`PROVEEDOR\` registrador.***

***\---***

***\#\# 6\. Contrato de la Operación \`evaluarCotizacionesYResolverCompra\` (\`UC-12\` «include» \`UC-62\`)***

***1\. \*\*Nombre:\*\* \`evaluarCotizacionesYResolverCompra(idSolicitud: Long, decision: String, idRespuestaElegida: Long\[0..1\], justificacionOMotivo: String)\`***

***2\. \*\*Responsabilidades:\*\* Evaluar las \`RespuestaCotizacion\` recibidas para una \`SolicitudCotizacion\` con recepción cerrada (localizada mediante \`UC-62\`) aplicando la \`PoliticaCompra\` vigente (\*\*identificando expresamente las cotizaciones incompletas, aplicando el \`ordenDesempate\` configurado y dejando al Administrador la decisión final si persiste el empate — \`RD-RP013-001\`\*\*), y registrar la resolución comercial humana emitiendo una \`OrdenCompra\` \`PENDIENTE\` (\`decision \= COMPRAR\`) o cerrando justificadamente la Solicitud \`SIN\_COMPRA\` (\`decision \= NO\_COMPRAR\`).***

***3\. \*\*Tipo:\*\* \`Sistema\`***

***4\. \*\*Referencias cruzadas:\*\* Caso de Uso \`UC-12 — Evaluar Cotizaciones y Resolver Compra\`; incluye \`UC-62 — Buscar Solicitud de Cotización\` \*(relación aprobada el 25/10/2026)\*; Decisión \`RD-RP013-001\`; Objetivos \`OBJE-07\`, \`OBJE-09\`; Requisitos \`RF-05\`, \`RF-11\`; Información \`IRQ-08\`.***

***5\. \*\*Notas:\*\* \*\*Ninguna \`OrdenCompra\` se emite sin confirmación humana expresa del Administrador.\*\* Conforme a \`RD-RP013-001\`, el sistema no adjudica por sí mismo ni oculta datos faltantes: señala expresamente toda cotización incompleta, ordena las ofertas elegibles según los pesos (100 %) y el \`ordenDesempate\` configurado en \`PoliticaCompra\`, y ante empate persistente o elección de otra alternativa elegible exige la decisión y justificación del Administrador.***

***6\. \*\*Excepciones:\*\****

   ***\* \*\*A1 — Recepción aún \`ABIERTA\`, Solicitud ya resuelta o sin ofertas elegibles:\*\* Impedir la resolución mediante \`UC-12\` (si cerró con 0 respuestas o 0 ofertas elegibles, rige el cierre automático \`SIN\_RESPUESTAS\` / \`SIN\_OFERTAS\_ELEGIBLES\`).***

   ***\* \*\*A2 — En \`COMPRAR\`, la oferta seleccionada es tardía, parcial, incompleta para cubrir la solicitud o su \`Proveedor\` dejó de estar \`ACTIVO\`:\*\* Impedir confirmar la compra y solicitar revisar alternativas.***

   ***\* \*\*A3 — Falta \`justificacionOMotivo\` obligatorio (justificación de la elección al comprar o motivo de cierre al no comprar):\*\* Rechazar la confirmación.***

   ***\* \*\*A4 — La necesidad de reposición desapareció antes de confirmar (\`stockActual \>= umbralMinimo\`):\*\* Informar el cambio y bloquear la emisión de una \`OrdenCompra\` innecesaria, permitiendo cerrar justificadamente \`SIN\_COMPRA\`.***

***7\. \*\*Salida:\*\****

   ***\* En \`COMPRAR\`: confirmación de la \`SolicitudCotizacion\` resuelta \`CON\_COMPRA\` e identificación de la \`OrdenCompra\` emitida en estado \`PENDIENTE\`.***

   ***\* En \`NO\_COMPRAR\`: confirmación del cierre \`SIN\_COMPRA\` (conservando la alerta del episodio si persiste el faltante para eventual ronda manual en \`UC-44\`); o mensajes de las excepciones A1–A4.***

***8\. \*\*Precondiciones:\*\****

   ***\* El \`Administrador\` se encuentra autenticado y autorizado.***

   ***\* Existe una \`SolicitudCotizacion\` (localizada mediante \`UC-62\`) con recepción finalizada, evaluación disponible conforme a \`PoliticaCompra\` vigente, al menos una \`RespuestaCotizacion\` elegible y sin resolución comercial previa.***

***9\. \*\*Postcondiciones:\*\****

   ***\* \*\*Si \`decision \= COMPRAR\`:\*\****

     ***\* Se creó una instancia \`unaDecision\` de \`DecisionCompra\` con \`resultado \= CON\_COMPRA\`, \`fechaHoraDecision\` y \`justificacion \= justificacionOMotivo\`, asociada a la \`SolicitudCotizacion\`, a la \`PoliticaCompra\` aplicada, a la \`RespuestaCotizacion\` elegida y al \`Usuario\` Administrador.***

     ***\* Se crearon las instancias de \`DetalleDecision\` y \`DetalleDecisionCriterio\` preservando los valores, ponderaciones, identificación de cotizaciones incompletas y puntajes evaluados (\`RD-RP013-001\`).***

     ***\* Se creó una única instancia \`unaOrden\` de \`OrdenCompra\` en estado \`PENDIENTE\` asociada a \`unaDecision\`, congelando \`cantidadOrdenada\`, \`precioUnitarioAcordado\`, \`fechaHoraEmision\` y \`fechaHoraComprometidaEntrega\`.***

     ***\* Se modificó el estado de la \`SolicitudCotizacion\` a resuelta \`CON\_COMPRA\`.***

   ***\* \*\*Si \`decision \= NO\_COMPRAR\`:\*\****

     ***\* Se modificó el estado de la \`SolicitudCotizacion\` a finalizada \`SIN\_COMPRA\` registrando \`motivoCierre \= justificacionOMotivo\`, fecha/hora y \`Usuario\` Administrador responsable, sin crear \`OrdenCompra\`.***

***\---***

***\#\# 7\. Glosario de Términos Asociados (\`REV-03A\`)***

***\* \*\*\`PoliticaCompra\` (Tipo / Concepto — Tabla \`POLITICA\_COMPRA\`):\*\* Versión histórica de reglas de evaluación de cotizaciones con intervalo \`\[vigenteDesde, vigenteHasta)\` y ventana \`periodoCalculoDias\`.***

***\* \*\*\`CriterioPoliticaCompra\` (Tipo / Concepto — Tabla \`CRITERIO\_*****POLITICA*\_COMPRA\`):\*\* Criterio integrante de una \`PoliticaCompra\` con \`codigoCriterio\`, \`pesoRelativo\` (cuya suma entre criterios activos es 100 % según \`RD-RP013-001\`) y \`ordenDesempate\`.***

***\* \*\*\`SolicitudCotizacion\` (Tipo / Concepto — Tabla \`SOLICITUD\_COTIZACION\`):\*\* Requerimiento formal de cotización de un \`Insumo\` dentro de un \`EpisodioFaltante\`, con \`cantidadSolicitada\` y \`fechaHoraVencimiento\` congeladas al emitirse (\`RD-RP012-001\`).***

***\* \*\*\`InvitacionCotizacion\` (Tipo / Concepto — Tabla \`INVITACION\_COTIZACION\`):\*\* Vínculo histórico e irrevocable entre una \`SolicitudCotizacion\` y un \`Proveedor\` invitable al momento de la emisión.***

***\* \*\*\`RespuestaCotizacion\` (Tipo / Concepto — Tabla \`RESPUESTA\_COTIZACION\`):\*\* Oferta estructurada única, definitiva e inmutable registrada por un \`Proveedor\` invitado dentro del plazo de recepción.***

***\* \*\*\`DecisionCompra\` (Tipo / Concepto — Tabla \`DECISION\_COMPRA\`):\*\* Resolución comercial humana tomada por el \`Administrador\` en \`UC-12\` que fundamenta la elección y origina una \`OrdenCompra\`.***

### **Próximo paso inmediato:** REV-03B

Con REV-03A (UC-58, UC-44, UC-62, UC-63, UC-13, UC-12) entregado íntegro y sin recortes, confirmame con un **«Avancemos con REV-03B»** para emitir inmediatamente la segunda mitad de este módulo: REV-03B **(**UC-11**,** UC-37**,** UC-45**,** UC-46**,** UC-40**,** UC-39**,** UC-08 **— 7 Casos de Uso con su auditoría, DSS, DS de 7 páginas y 7 Contratos individuales)**.

### **Paquete Completo de Revisión Transversal — Lote 3B (**REV-03B**: Proveedores, Órdenes de Compra y Recepción de Stock)**

Aplicando la metodología reproducible de ocho etapas (M-0 a M-7) establecida en REV01\_AUDITORIA\_TRANSVERSAL\_CIERRE\_2026-10-28.md y corrigiendo transversalmente las observaciones de AUDITORIA\_PREINTEGRACION\_GEMINI\_DSS\_DS\_CONTRATOS\_2026-10-27.md, entrego la segunda mitad del Lote 3 (REV-03B**:** UC-11**,** UC-37**,** UC-45**,** UC-46**,** UC-40**,** UC-39**,** UC-08).

### **Archivo 1:** docs/08-diagramas/revision/REV03B\_AUDITORIA\_TRANSVERSAL\_PROVEEDORES\_ORDENES\_2026-10-28.md

Markdown  
\# REV-03B — Auditoría Transversal y Corrección: Proveedores, Órdenes de Compra y Recepción (UC-11, UC-37, UC-45, UC-46, UC-40, UC-39, UC-08)

**\*\*Fecha:\*\*** 28/10/2026  

**\*\*Rama de trabajo propuesta:\*\*** \`revision/rev03b-proveedores-ordenes-2026-10-28\`  

**\*\*Alcance (\`REV-03B\`):\*\*** \`UC-37\`, \`UC-11\`, \`UC-45\` («include» \`UC-37\`), \`UC-46\` («include» \`UC-37\`), \`UC-40\`, \`UC-39\` («include» \`UC-40\`), \`UC-08\` («extend» condicional \`UC-40\`).  

**\*\*Estado de los artefactos entregados:\*\*** \`PROPUESTO / CORREGIDO EN REVISIÓN ESTÁTICA\` (pendiente de inspección visual humana en Draw.io y aprobación para fusión a \`main\`).

\---

\#\# 1\. Ejecución de las 8 Etapas Metodológicas (M-0 a M-7)

\#\#\# M-0 — Autoridad y alcance congelados

\* **\*\*Catálogo funcional vigente:\*\*** 64 CU consecutivos (\`UC-01\`..\`UC-64\`) en 3 niveles (\`ALE\_MILANESAS\_FASE\_4\_CU\_01\_A\_64\_TRES\_NIVELES.docx\`), respetando el título canónico de Fase 4 **\*\*\`UC-11 Gestionar Proveedor\`\*\***.

\* **\*\*Relaciones UML aprobadas en este sublote:\*\*** \`UC-45 → UC-37\` (\`include\`), \`UC-46 → UC-37\` (\`include\`), \`UC-39 → UC-40\` (\`include\`) y \`UC-40 → UC-08\` (\`extend\` condicional cuando el ingreso responde a una Orden de Compra). El archivo \`DIAGRAMA DE CASOS DE USO.drawio (1).xml\` permanece intacto.

\* **\*\*Decisiones y criterios transversales incorporados (\`REV-01\` y Corte 27/10/2026):\*\***

  \* **\*\*Corrección preventiva de \`H01\` y \`H02\` (\`REV-01\`) en \`UC-08 — Registrar Ingreso de Stock por Compra\`:\*\***

    1\. **\*\*Orden estricto Costo $\rightarrow$ Movimiento (\`H01\`):\*\*** Al ingresar un \`Insumo\` por compra, se registra **\*\*primero\*\*** la nueva vigencia en \`CostoInsumoHistorico\` (\`fuenteCosto \= COMPRA\`) y **\*\*después\*\*** se crea la instancia de \`MovimientoInsumo\` (\`INGRESO\_COMPRA\`) que referencia ese \`vigenteDesdeCosto\` válido.

    2\. **\*\*Separación de ramas en fragmento \`alt\` (\`H02\` y \`RD-RP022-001\`):\*\*** El fragmento \`alt\` de \`UC-08\` separa en tres operandos mutuamente excluyentes con sus divisorias explícitas: (Op. 1\) Ingreso de \`INSUMO\` (con actualización opcional de \`OrdenCompra\` vía \`«extend» UC-40\` y evaluación de cierre de \`EpisodioFaltante\`), (Op. 2\) Ingreso de \`PRODUCTO\` de \`REVENTA\` (calculando el **\*\*promedio ponderado móvil\*\*** de costo antes de registrar \`MovimientoStockReventa\`, \`RD-RP022-001\`), y (Op. 3\) Rechazo atómico.

  \* **\*\*Separación estricta de responsabilidades entre \`UC-11\`, \`UC-45\` y \`UC-46\` (Fichas Reales/Extendidas Fase 4):\*\***

    \* \`UC-45 — Modificar Proveedor\` actualiza datos comerciales/contacto y períodos de \`ProveedorInsumo\` conservando vigencias históricas, pero **\*\*no modifica el estado \`ACTIVO\`/\`INACTIVO\`\*\*** (que pertenece a \`UC-46\`) ni administra cuentas de \`Usuario\` (que pertenecen a \`UC-17\`/\`UC-18\`).

    \* \`UC-46 — Cambiar Estado de Proveedor\` transiciona lógicamente \`Proveedor.estado\` (\`ACTIVO\` \| \`INACTIVO\`) sin eliminar invitaciones, respuestas ni órdenes históricas y **\*\*sin cancelar automáticamente las \`OrdenCompra\` abiertas\*\***. Se elimina del DSS y del DS la tabla inexistente \`HISTORIAL\_ESTADO\_PROVEEDOR\`.

\#\#\# M-1 — Proveniencia, integridad y matriz de diferencias (Antes → Después)

\| ID Hallazgo \| Artefacto / Celda Original \| Antes (Borrador 26–27/10) \| Después (Versión Corregida \`REV03B\`) \| Fundamento \|

\| :--- \| :--- \| :--- \| :--- \| :--- \|

\| **\*\*\`H01\` y \`H02\` (\`REV-01\` aplicado a \`UC-08\`)\*\*** \| \`DS UC-08\` (\`u08\_m3\`, \`u08\_alt\`) \| Agrupaba en un solo mensaje \`incrementarStockYActualizarCosto\` tanto \`INSUMO\` como \`REVENTA\` sin separar operandos ni mostrar que el costo precede al movimiento. \| Reconstruye el \`alt\` en **\*\*3 operandos excluyentes\*\*** (\`INSUMO\`, \`REVENTA\`, \`RECHAZO\`) y, en \`INSUMO\`, crea **\*\*primero\*\*** \`CostoInsumoHistorico\` y **\*\*luego\*\*** \`MovimientoInsumo\` con \`vigenteDesdeCosto\`. \| \`REV-01\` (\`H01\`, \`H02\`), \`RD-RP022-001\` \|

\| **\*\*\`H06\` (\`REV-01\` aplicado a \`UC-08\`)\*\*** \| \`DS UC-08\` y \`Contrato 6B.5\` \| Mencionaba promedio ponderado móvil de \`REVENTA\` en texto general sin desglosar la operación. \| Explicita el cálculo de promedio ponderado móvil (\`nuevoCostoPromedio \= (stockActual \* costoActual \+ cantRecibida \* costoCompra) / (stockActual \+ cantRecibida)\`) antes del \`MovimientoStockReventa\`. \| \`RD-RP022-001\` / \`H06\` \|

\| **\*\*\`M-5\` (Tabla inexistente en \`UC-46\`)\*\*** \| \`DSS Admin 6B\` (\`a2\_r3\`) y \`DS UC-46\` (\`u46\_r4\`) \| Mencionaba \`HISTORIAL\_ESTADO\_PROVEEDOR\`, que no forma parte de las 60 tablas de MR-3. \| Se elimina la referencia a la tabla inexistente y se alinea con la Ficha Real/Extendida de \`UC-46\` (\`Proveedor.estado \= ACTIVO \| INACTIVO\` conservando historial de invitaciones, respuestas y compras). \| Ficha Fase 4 \`UC-46\` y Diccionario MR-3 \|

\| **\*\*\`H-11\` (Contratos compuestos)\*\*** \| \`Contrato 6B.1\` (\`UC-11\`\+\`45\`\+\`46\`), \`Contrato 6B.5\` (\`UC-08\`\+\`39\`) y \`Contrato 4.5\` (\`UC-40\`) \| Agrupaba múltiples CU con pre/postcondiciones distintas bajo un mismo contrato. \| Se desagrupan en **\*\*7 Contratos individuales\*\*** (\`UC-37\`, \`UC-11\`, \`UC-45\`, \`UC-46\`, \`UC-40\`, \`UC-39\`, \`UC-08\`), cada uno con sus 9 secciones estándar. \| Puerta \`G4\` / \`H-11\` \|

\| **\*\*\`H-12\`, \`H-19\` y \`H05\`\*\*** \| \`DSS Admin 6B\`, \`DS\` y \`Contratos\` \| Secuencia continua en el DSS y firmas divergentes entre DSS, DS y Contrato. \| Marcos \`sd\` independientes por CU en el DSS, lenguaje de caja negra y homologación 1:1 de las 7 firmas públicas entre DSS, DS (\`1:\`) y Contratos. \| \`M-3\`, \`H-12\`, \`H-19\`, \`H05\` \|

\---

\#\# 2\. Matriz de Trazabilidad Vertical y Visibilidad de Larman Mensaje por Mensaje (M-3 y M-6)

\| CU \| Paso / Mensaje en DS \| Emisor $\rightarrow$ Receptor \| Tipo de Visibilidad (Larman) \| Origen verificable de la referencia \|

\| :--- \| :--- \| :--- \| :--- \| :--- \|

\| **\*\*\`UC-37\`\*\*** \| \`1: buscarProveedor(idProveedor, cuit, razonSocial, nombreComercial, estado)\` \| \`Actor Interno Autorizado\` $\rightarrow$ \`:ControladorProveedores\` \| Frontera de sistema \| Operación pública homologada del DSS (\`UC-37\`). \|

\| **\*\*\`UC-37\`\*\*** \| \`2: lista \= consultarProveedoresPorCriterios(filtro)\` \| \`:ControladorProveedores\` $\rightarrow$ \`:CatalogoProveedores\` \| **\*\*Por Atributo\*\*** \| Repositorio de Proveedores inyectado en el controlador. \|

\| **\*\*\`UC-11\`\*\*** \| \`1: gestionarProveedor(cuit, razonSocial, nombreComercial, contacto, insumosVigencias)\` \| \`Administrador\` $\rightarrow$ \`:ControladorProveedores\` \| Frontera de sistema \| Operación pública homologada del DSS (\`UC-11\`). \|

\| **\*\*\`UC-11\`\*\*** \| \`2: validacion \= validarUnicidadCuitYVigenciasInsumo(cuitNormalizado, insumosVigencias)\` \| \`:ControladorProveedores\` $\rightarrow$ \`:CatalogoProveedores\` \| **\*\*Por Atributo\*\*** \| Verifica que el CUIT no esté duplicado y que no existan vigencias superpuestas en \`ProveedorInsumo\`. \|

\| **\*\*\`UC-11\`\*\*** \| \`3: «create» new(cuitNormalizado, razonSocial, nombreComercial, contacto, estado=ACTIVO)\` \| \`:ControladorProveedores\` $\rightarrow$ \`unProveedor : Proveedor\` \| **\*\*Por Creación Local (\`new\`)\*\*** \| Instancia el \`Proveedor\` comercial. \|

\| **\*\*\`UC-11\`\*\*** \| \`4: «create» new(unProveedor, unInsumo, vigenteDesde, vigenteHasta)\` \| \`unProveedor : Proveedor\` $\rightarrow$ \`rel : ProveedorInsumo\` \| **\*\*Por Creación Local (\`new\`) \+ Atributo\*\*** \| \`Proveedor\` crea y mantiene sus relaciones históricas \`ProveedorInsumo\`. \|

\| **\*\*\`UC-45\`\*\*** \| \`1: modificarProveedor(idProveedor, datosComerciales, cambiosVigenciasInsumo)\` \| \`Administrador\` $\rightarrow$ \`:ControladorProveedores\` \| Frontera de sistema \| Operación pública homologada del DSS (\`UC-45\`, precedida por \`«include» UC-37\`). \|

\| **\*\*\`UC-45\`\*\*** \| \`2: ok \= validarCompatibilidadInsumosYVigencias(idProveedor, datosComerciales, cambiosVigenciasInsumo)\` \| \`:ControladorProveedores\` $\rightarrow$ \`:CatalogoProveedores\` \| **\*\*Por Atributo\*\*** \| Valida formato, Insumos registrados y no solapamiento de períodos \`\[vigenteDesde, vigenteHasta)\`. \|

\| **\*\*\`UC-45\`\*\*** \| \`3: actualizarDatosComercialesYVigencias(datosComerciales, cambiosVigenciasInsumo)\` \| \`:ControladorProveedores\` $\rightarrow$ \`unProveedor : Proveedor\` \| **\*\*Por Variable Local\*\*** \| Actualiza datos vigentes y preserva la historia de \`ProveedorInsumo\` sin cambiar \`estado\`. \|

\| **\*\*\`UC-46\`\*\*** \| \`1: cambiarEstadoProveedor(idProveedor, nuevoEstado, motivo)\` \| \`Administrador\` $\rightarrow$ \`:ControladorProveedores\` \| Frontera de sistema \| Operación pública homologada del DSS (\`UC-46\`, precedida por \`«include» UC-37\`). \|

\| **\*\*\`UC-46\`\*\*** \| \`2: admisible \= revalidarTransicionEstadoProveedor(idProveedor, nuevoEstado, motivo)\` \| \`:ControladorProveedores\` $\rightarrow$ \`:CatalogoProveedores\` \| **\*\*Por Atributo\*\*** \| Revalida en concurrencia (\`F09\`) que el estado difiera del actual y tenga motivo cuando corresponde. \|

\| **\*\*\`UC-46\`\*\*** \| \`3: establecerEstadoComercial(nuevoEstado)\` \| \`:ControladorProveedores\` $\rightarrow$ \`unProveedor : Proveedor\` \| **\*\*Por Variable Local\*\*** \| Actualiza \`Proveedor.estado\` (\`ACTIVO\` \| \`INACTIVO\`) sin cancelar Órdenes abiertas ni borrar invitaciones/respuestas previas. \|

\| **\*\*\`UC-40\`\*\*** \| \`1: buscarOrdenCompra(idOrdenCompra, idProveedor, idInsumo, estado, fechaEmision)\` \| \`Actor Interno Autorizado\` $\rightarrow$ \`:ControladorCotizacionesCompras\` \| Frontera de sistema \| Operación pública homologada del DSS (\`UC-40\`). \|

\| **\*\*\`UC-40\`\*\*** \| \`2: ordenes \= consultarOrdenesPorCriterios(filtro)\` \| \`:ControladorCotizacionesCompras\` $\rightarrow$ \`:RepositorioCotizaciones\` \| **\*\*Por Atributo\*\*** \| Recupera \`OrdenCompra\` con cantidad ordenada, acumulada recibida y referencia a la cotización. \|

\| **\*\*\`UC-39\`\*\*** \| \`1: cancelarOrdenCompra(idOrdenCompra, motivoCancelacion, cancelacionAtribuibleProveedor)\` \| \`Administrador\` $\rightarrow$ \`:ControladorCotizacionesCompras\` \| Frontera de sistema \| Operación pública homologada del DSS (\`UC-39\`, precedida por \`«include» UC-40\`). \|

\| **\*\*\`UC-39\`\*\*** \| \`2: cancelarSaldoPendiente(motivoCancelacion, cancelacionAtribuibleProveedor, idAdmin, fechaHoraCancelacion)\` \| \`:ControladorCotizacionesCompras\` $\rightarrow$ \`unaOrden : OrdenCompra\` \| **\*\*Por Variable Local\*\*** \| Pasa \`unaOrden.estado\` a \`CANCELADA\` conservando recepciones previas y manteniendo abierto el episodio si persiste el faltante. \|

\| **\*\*\`UC-08\`\*\*** \| \`1: registrarIngresoStockPorCompra(tipoElemento, idElemento, idOrdenCompra, cantidadRecibida, costoUnitarioCompra, comprobante)\` \| \`Actor Autorizado\` $\rightarrow$ \`:ControladorInventario\` \| Frontera de sistema \| Operación pública homologada del DSS (\`UC-08\`, con \`«extend»\` condicional \`UC-40\`). \|

\| **\*\*\`UC-08\`\*\*** \| \`2: «create» new(idOrdenCompra\[0..1\], idElemento, cantidadRecibida, costoUnitarioCompra, fechaHoraRecepcion)\` \| \`:ControladorInventario\` $\rightarrow$ \`unaRecepcion : RecepcionCompra\` \| **\*\*Por Creación Local (\`new\`)\*\*** \| Registra el documento de recepción física. \|

\| **\*\*\`UC-08\`\*\*** \| \`3 (Rama INSUMO): «create» new(unInsumo, vigenteDesde, costoUnitarioCompra, fuenteCosto=COMPRA, unaRecepcion)\` \| \`:ControladorInventario\` $\rightarrow$ \`nuevoCosto : CostoInsumoHistorico\` \| **\*\*Por Creación Local (\`new\`) \+ Parámetro\*\*** \| **\*\*Orden obligatorio \`H01\`:\*\*** Crea **\*\*primero\*\*** la vigencia de costo histórico originada en la compra. \|

\| **\*\*\`UC-08\`\*\*** \| \`4 (Rama INSUMO): «create» new(unInsumo, tipo=INGRESO\_COMPRA, cantidadRecibida, stockResultante, nuevoCosto.vigenteDesde, unaRecepcion)\` \| \`:ControladorInventario\` $\rightarrow$ \`movIns : MovimientoInsumo\` \| **\*\*Por Creación Local (\`new\`) \+ Parámetro\*\*** \| Crea **\*\*después\*\*** el \`MovimientoInsumo\` referenciando \`nuevoCosto.vigenteDesde\`, actualiza \`unInsumo.stockActual\` y \`unaOrden\`. \|

\| **\*\*\`UC-08\`\*\*** \| \`3b (Rama REVENTA): recalcularCostoPromedioPonderadoMovilEIncrementarStock(cantidadRecibida, costoUnitarioCompra)\` \| \`:ControladorInventario\` $\rightarrow$ \`prodRev : Producto\` \| **\*\*Por Variable Local\*\*** \| Actualiza el costo promedio ponderado móvil (\`RD-RP022-001\`) y el stock de reventa. \|

\| **\*\*\`UC-08\`\*\*** \| \`4b (Rama REVENTA): «create» new(prodRev, tipo=INGRESO\_COMPRA, cantidadRecibida, stockResultante, costoUnitarioCompra, unaRecepcion)\` \| \`:ControladorInventario\` $\rightarrow$ \`movRev : MovimientoStockReventa\` \| **\*\*Por Creación Local (\`new\`) \+ Parámetro\*\*** \| Registra el movimiento de entrada en el inventario separado de \`REVENTA\` (\`RD-RP022-001\`). \|

\---

\#\# 3\. Matriz Transversal de Invariantes y Puertas de Aceptación (M-4 y M-7)

\| ID \| Invariante ratificada \| DSS \| DS \| Contrato \| Dictamen \|

\| :--- \| :--- \| :--- \| :--- \| :--- \| :--- \|

\| **\*\*\`I-01\`\*\*** \| \`H01\` (\`REV-01\`) en \`UC-08\`: En recepción de \`INSUMO\`, se crea primero \`CostoInsumoHistorico\` (\`COMPRA\`) y recién después \`MovimientoInsumo\` referenciando \`vigenteDesdeCosto\` \| Respuesta de caja negra consistente \| \`u08\_m3\_cost\` precede estrictamente a \`u08\_m4\_mov\` dentro del operando \`INSUMO\` \| Postcondiciones ordenadas en \`CONTRATO\_UC08\` \| **\*\*PASÓ (Trazabilidad estática)\*\*** \|

\| **\*\*\`I-02\`\*\*** \| \`H02\` y \`H06\` (\`REV-01\` / \`RD-RP022-001\`) en \`UC-08\`: Operandos \`alt\` mutuamente excluyentes (\`INSUMO\`, \`REVENTA\` con promedio ponderado móvil, \`RECHAZO\`) manteniendo inventarios separados \| Guardas diferenciadas \| 3 operandos con divisorias explícitas en \`DS UC-08\` \| Postcondiciones separadas por tipo de inventario en \`CONTRATO\_UC08\` \| **\*\*PASÓ (Trazabilidad estática)\*\*** \|

\| **\*\*\`I-03\`\*\*** \| Fichas Fase 4 \`UC-11\`, \`UC-37\`, \`UC-45\`, \`UC-46\`: Conservación histórica de \`ProveedorInsumo\`; inactivación de Proveedor no cancela de oficio \`OrdenCompra\` abiertas ni usa tablas inexistentes \| Marcos independientes \`UC-37\`, \`UC-11\`, \`UC-45\`, \`UC-46\` \| \`DS UC-37\`, \`UC-11\`, \`UC-45\`, \`UC-46\` alineados a MR-3 \| Contratos individuales 1 a 4 \| **\*\*PASÓ (Trazabilidad estática)\*\*** \|

\| **\*\*\`I-04\`\*\*** \| \`UC-39\` («include» \`UC-40\`): Cancela saldo pendiente con motivo y flag \`cancelacionAtribuibleProveedor\`, conservando recepciones previas y manteniendo episodio abierto sin disparo automático \| Marco \`UC-39\` con \`ref UC-40\` \| \`DS UC-39\` con operandos \`alt\` \| \`CONTRATO\_UC39\` individual \| **\*\*PASÓ (Trazabilidad estática)\*\*** \|

\| **\*\*\`I-05\`\*\*** \| Homologación 1:1 de firmas públicas DSS ↔ DS ↔ Contrato y desagrupamiento en 7 contratos individuales (\`H-11\`, \`H05\`) \| 7 firmas canónicas \| Mensaje \`1:\` idéntico en las 7 páginas DS \| 7 Contratos individuales con las mismas 7 firmas \| **\*\*PASÓ\*\*** \|

\| **\*\*\`I-06\`\*\*** \| Inspección visual y prueba de desplazamiento (\`round-trip\`) en editor gráfico Draw.io (\`M-6\` / \`G5\`) \| XML bien formado \| XML bien formado con 3 operandos en \`UC-08\` \| N/A \| **\*\*PENDIENTE DE VALIDACIÓN HUMANA EN DRAW.IO\*\*** \|

### **Archivo 2:** docs/08-diagramas/revision/DSS\_REV03B\_PROVEEDORES\_ORDENES\_FRAGMENTOS.drawio.xml

Este archivo XML compatible con **Draw.io** modela en **2 páginas** los escenarios de caja negra (DSS) de UC-37, UC-11, UC-45 y UC-46 (Página 1\) y UC-40, UC-39 y UC-08 (Página 2), encapsulados en marcos sd independientes (H-12) y sin lenguaje SQL interno (H-19):

XML  
\<mxfile host\="app.diagrams.net" modified\="2026-10-28T11:45:00.000Z" agent\="Gemini-REV03B" version\="24.7.17" type\="device"\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 1: DSS CAJA NEGRA — PROVEEDORES (UC-37, UC-11, UC-45, UC-46)       \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id\="dss-rev03b-prov" name\="DSS REV03B \- Proveedores (UC-37,11,45,46)"\>

    \<mxGraphModel dx\="1500" dy\="950" grid\="1" gridSize\="10" guides\="1" tooltips\="1" connect\="1" arrows\="1" fold\="1" page\="1" pageScale\="1" pageWidth\="1450" pageHeight\="1450" math\="0" shadow\="0"\>

      \<root\>

        \<mxCell id\="0" /\>

        \<mxCell id\="1" parent\="0" /\>

        \<mxCell id\="p1\_title" value\="DSS (Caja Negra — REV03B) — Actor: Administrador — Escenarios Independientes UC-37, UC-11, UC-45 y UC-46" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=13;fontStyle=1" vertex\="1" parent\="1"\>

          \<mxGeometry x\="50" y\="15" width\="1200" height\="30" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="p1\_actor" value\="Administrador" style\="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="110" y\="60" width\="30" height\="60" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="p1\_actor\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="119" y\="155" width\="12" height\="1220" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="p1\_sys\_box" value\=":Sistema" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;fontSize=13;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="940" y\="60" width\="140" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="p1\_sys\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="1010" y\="1400" as\="sourcePoint" /\>

            \<mxPoint x\="1010" y\="105" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="p1\_sys\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="1004" y\="155" width\="12" height\="1220" as\="geometry" /\>

        \</mxCell\>

        \<\!-- MARCO UC-37 \--\>

        \<mxCell id\="p1\_sd37" value\="sd Escenario Independiente — UC-37: Buscar Proveedor" style\="shape=umlFrame;whiteSpace=wrap;html=1;width=380;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="50" y\="170" width\="1100" height\="190" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="p1\_37\_m1" value\="1: proveedores \= buscarProveedor(idProveedor:Long\[0..1\], cuit:String\[0..1\], razonSocial:String\[0..1\], nombreComercial:String\[0..1\], estado:String\[0..1\])" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="131" y\="220" as\="sourcePoint" /\>

            \<mxPoint x\="1004" y\="220" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="p1\_37\_r1" value\="1.1: presenta Proveedores coincidentes (idProveedor, CUIT, razón social, nombre comercial, contacto, estado ACTIVO\|INACTIVO) y devuelve el seleccionado al CU invocante" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="1004" y\="305" as\="sourcePoint" /\>

            \<mxPoint x\="131" y\="305" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<\!-- MARCO UC-11 \--\>

        \<mxCell id\="p1\_sd11" value\="sd Escenario Independiente — UC-11: Gestionar Proveedor (Título canónico Fase 4)" style\="shape=umlFrame;whiteSpace=wrap;html=1;width=540;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="50" y\="390" width\="1100" height\="250" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="p1\_11\_m1" value\="1: idProveedor \= gestionarProveedor(cuit:String, razonSocial:String, nombreComercial:String\[0..1\], contacto:ContactoDTO, insumosVigencias:List\&lt;VigenciaInsumoDTO\&gt;)" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="131" y\="440" as\="sourcePoint" /\>

            \<mxPoint x\="1004" y\="440" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="p1\_11\_r1" value\="1.1: \[CUIT único, contacto válido y asociaciones Proveedor–Insumo sin solapamiento\] registra Proveedor ACTIVO y relaciones históricas de suministro" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="1004" y\="515" as\="sourcePoint" /\>

            \<mxPoint x\="131" y\="515" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="p1\_11\_r2" value\="1.2: \[CUIT duplicado, datos de contacto inválidos o período de suministro superpuesto\] rechaza la confirmación y solicita corrección" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="1004" y\="595" as\="sourcePoint" /\>

            \<mxPoint x\="131" y\="595" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<\!-- MARCO UC-45 (+ INCLUDE UC-37) \--\>

        \<mxCell id\="p1\_sd45" value\="sd Escenario Independiente — UC-45: Modificar Proveedor (con «include» UC-37)" style\="shape=umlFrame;whiteSpace=wrap;html=1;width=530;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="50" y\="670" width\="1100" height\="310" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="p1\_45\_ref37" value\="ref «include» UC-37 Buscar Proveedor (selecciona el Proveedor y muestra sus datos y asociaciones vigentes con Insumos)" style\="shape=umlFrame;whiteSpace=wrap;html=1;width=260;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="90" y\="705" width\="760" height\="50" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="p1\_45\_m1" value\="1: ok \= modificarProveedor(idProveedor:Long, datosComerciales:DatosProveedorDTO, cambiosVigenciasInsumo:List\&lt;VigenciaInsumoDTO\&gt;)" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="131" y\="790" as\="sourcePoint" /\>

            \<mxPoint x\="1004" y\="790" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="p1\_45\_r1" value\="1.1: \[Datos válidos, Insumos registrados y vigencias compatibles\] actualiza datos comerciales y asociaciones vigentes preservando la historia (sin cambiar ACTIVO/INACTIVO)" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="1004" y\="860" as\="sourcePoint" /\>

            \<mxPoint x\="131" y\="860" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="p1\_45\_r2" value\="1.2: \[Insumo inexistente, vigencia incompatible o datos inválidos\] solicita corrección sin modificar el historial" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="1004" y\="935" as\="sourcePoint" /\>

            \<mxPoint x\="131" y\="935" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<\!-- MARCO UC-46 (+ INCLUDE UC-37) \--\>

        \<mxCell id\="p1\_sd46" value\="sd Escenario Independiente — UC-46: Cambiar Estado de Proveedor (con «include» UC-37)" style\="shape=umlFrame;whiteSpace=wrap;html=1;width=570;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="50" y\="1010" width\="1100" height\="320" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="p1\_46\_ref37" value\="ref «include» UC-37 Buscar Proveedor (selecciona el Proveedor y muestra estado comercial actual y referencias históricas)" style\="shape=umlFrame;whiteSpace=wrap;html=1;width=260;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="90" y\="1045" width\="760" height\="50" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="p1\_46\_m1" value\="1: ok \= cambiarEstadoProveedor(idProveedor:Long, nuevoEstado:String, motivo:String\[0..1\])" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="131" y\="1130" as\="sourcePoint" /\>

            \<mxPoint x\="1004" y\="1130" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="p1\_46\_r1" value\="1.1: \[Transición admisible\] actualiza estado (ACTIVO\|INACTIVO) conservando identidad, invitaciones, respuestas y Órdenes históricas (si queda INACTIVO no es invitable ni cancela de oficio Órdenes abiertas)" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="1004" y\="1205" as\="sourcePoint" /\>

            \<mxPoint x\="131" y\="1205" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="p1\_46\_r2" value\="1.2: \[Estado ya coincidente o cambio concurrente inválido\] informa ausencia de cambio o detiene la transición sin alterar el historial" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="1004" y\="1285" as\="sourcePoint" /\>

            \<mxPoint x\="131" y\="1285" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 2: DSS CAJA NEGRA — ÓRDENES Y RECEPCIÓN (UC-40, UC-39, UC-08)      \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id\="dss-rev03b-ordenes" name\="DSS REV03B \- Órdenes y Recepción (UC-40,39,08)"\>

    \<mxGraphModel dx\="1500" dy\="950" grid\="1" gridSize\="10" guides\="1" tooltips\="1" connect\="1" arrows\="1" fold\="1" page\="1" pageScale\="1" pageWidth\="1450" pageHeight\="1350" math\="0" shadow\="0"\>

      \<root\>

        \<mxCell id\="0" /\>

        \<mxCell id\="1" parent\="0" /\>

        \<mxCell id\="p2\_title" value\="DSS (Caja Negra — REV03B) — Escenarios Independientes UC-40, UC-39 y UC-08 \[RD-RP022-001\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=13;fontStyle=1" vertex\="1" parent\="1"\>

          \<mxGeometry x\="50" y\="15" width\="1200" height\="30" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="p2\_actor" value\="Administrador /&\#xa;Resp. Producción (según CU)" style\="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="110" y\="60" width\="30" height\="60" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="p2\_actor\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="119" y\="155" width\="12" height\="1120" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="p2\_sys\_box" value\=":Sistema" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;fontSize=13;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="940" y\="60" width\="140" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="p2\_sys\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="1010" y\="1300" as\="sourcePoint" /\>

            \<mxPoint x\="1010" y\="105" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="p2\_sys\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="1004" y\="155" width\="12" height\="1120" as\="geometry" /\>

        \</mxCell\>

        \<\!-- MARCO UC-40 \--\>

        \<mxCell id\="p2\_sd40" value\="sd Escenario Independiente — UC-40: Buscar Orden de Compra" style\="shape=umlFrame;whiteSpace=wrap;html=1;width=410;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="50" y\="170" width\="1100" height\="190" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="p2\_40\_m1" value\="1: ordenes \= buscarOrdenCompra(idOrdenCompra:Long\[0..1\], idProveedor:Long\[0..1\], idInsumo:Long\[0..1\], estado:String\[0..1\], fechaEmision:LocalDate\[0..1\])" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="131" y\="220" as\="sourcePoint" /\>

            \<mxPoint x\="1004" y\="220" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="p2\_40\_r1" value\="1.1: presenta Órdenes coincidentes (idOrdenCompra, fechaEmision, Proveedor, Insumo, cantidadOrdenada, Unidad de Medida, estado) y devuelve la seleccionada al CU invocante" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="1004" y\="305" as\="sourcePoint" /\>

            \<mxPoint x\="131" y\="305" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<\!-- MARCO UC-39 (+ INCLUDE UC-40) \--\>

        \<mxCell id\="p2\_sd39" value\="sd Escenario Independiente — UC-39: Cancelar Orden de Compra (con «include» UC-40 — Exclusivo Administrador)" style\="shape=umlFrame;whiteSpace=wrap;html=1;width=710;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="50" y\="390" width\="1100" height\="320" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="p2\_39\_ref40" value\="ref «include» UC-40 Buscar Orden de Compra (localiza la Orden de Compra en estado PENDIENTE o PARCIALMENTE\_RECIBIDA)" style\="shape=umlFrame;whiteSpace=wrap;html=1;width=260;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="90" y\="425" width\="760" height\="50" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="p2\_39\_m1" value\="1: ok \= cancelarOrdenCompra(idOrdenCompra:Long, motivoCancelacion:String, cancelacionAtribuibleProveedor:Boolean)" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="131" y\="510" as\="sourcePoint" /\>

            \<mxPoint x\="1004" y\="510" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="p2\_39\_r1" value\="1.1: \[Orden en PENDIENTE o PARCIALMENTE\_RECIBIDA y motivo informado\] cancela el saldo pendiente, conserva recepciones previas y mantiene alerta del episodio si persiste el faltante (sin disparo automático)" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="1004" y\="585" as\="sourcePoint" /\>

            \<mxPoint x\="131" y\="585" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="p2\_39\_r2" value\="1.2: \[Orden ya RECIBIDA o CANCELADA, o falta motivo obligatorio\] rechaza la cancelación y mantiene el estado actual" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="1004" y\="665" as\="sourcePoint" /\>

            \<mxPoint x\="131" y\="665" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<\!-- MARCO UC-08 (+ EXTEND UC-40) \--\>

        \<mxCell id\="p2\_sd08" value\="sd Escenario Independiente — UC-08: Registrar Ingreso de Stock por Compra (con «extend» condicional UC-40) \[RD-RP022-001\]" style\="shape=umlFrame;whiteSpace=wrap;html=1;width=790;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="50" y\="740" width\="1100" height\="490" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="p2\_08\_opt40" value\="opt «extend» UC-40 Buscar Orden de Compra \[cuando el ingreso de Insumo responde a una Orden de Compra emitida\]" style\="shape=umlFrame;whiteSpace=wrap;html=1;width=690;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="90" y\="775" width\="760" height\="50" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="p2\_08\_m1" value\="1: idRecepcion \= registrarIngresoStockPorCompra(tipoElemento:String, idElemento:Long, idOrdenCompra:Long\[0..1\], cantidadRecibida:BigDecimal, costoUnitarioCompra:BigDecimal, comprobante:String)" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="131" y\="860" as\="sourcePoint" /\>

            \<mxPoint x\="1004" y\="860" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="p2\_08\_alt" value\="alt Registro de Recepción por tipo de inventario separado \[UC-08 — RD-RP022-001\]" style\="shape=umlFrame;whiteSpace=wrap;html=1;width=530;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="75" y\="885" width\="1050" height\="320" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="p2\_08\_g1" value\="\[tipoElemento \== INSUMO, cantidadRecibida \&gt; 0, costoUnitarioCompra \&gt; 0 y dentro del saldo pendiente de la Orden\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="145" y\="910" width\="760" height\="20" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="p2\_08\_r1" value\="1.1: registra Recepción, actualiza primero el costo histórico de compra del Insumo y luego el movimiento de entrada y su stock, actualiza la Orden y evalúa cierre de faltante" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="1004" y\="965" as\="sourcePoint" /\>

            \<mxPoint x\="131" y\="965" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="p2\_08\_div1" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="75" y\="1000" as\="sourcePoint" /\>

            \<mxPoint x\="1125" y\="1000" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="p2\_08\_g2" value\="\[tipoElemento \== REVENTA, cantidadRecibida \&gt; 0 y costoUnitarioCompra \&gt; 0\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="145" y\="1010" width\="540" height\="20" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="p2\_08\_r2" value\="1.2: registra Recepción, recalcula el costo promedio ponderado móvil de REVENTA, registra el movimiento de entrada e incrementa el stock de reventa" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="1004" y\="1070" as\="sourcePoint" /\>

            \<mxPoint x\="131" y\="1070" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="p2\_08\_div2" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="75" y\="1105" as\="sourcePoint" /\>

            \<mxPoint x\="1125" y\="1105" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="p2\_08\_g3" value\="\[Cantidad o costo \&lt;\= 0, Orden CANCELADA/RECIBIDA o cantidad supera saldo pendiente\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="145" y\="1115" width\="600" height\="20" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="p2\_08\_r3" value\="1.3: rechaza la recepción sin modificar existencias, costos ni estado de la Orden" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="1004" y\="1175" as\="sourcePoint" /\>

            \<mxPoint x\="131" y\="1175" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

\</mxfile\>

### **Archivo 3:** docs/08-diagramas/revision/DS\_REV03B\_PROVEEDORES\_ORDENES\_UC08\_11\_37\_39\_40\_45\_46.drawio.xml

Este archivo XML de **7 páginas** para **Draw.io** contiene los Diagramas de Secuencia de Diseño (DS de caja blanca) corregidos para UC-37, UC-11, UC-45, UC-46, UC-40, UC-39 y UC-08, incorporando en UC-08 el orden estricto **Costo Histórico $\rightarrow$ Movimiento** (H01) y las **3 ramas mutuamente excluyentes (**INSUMO**,** REVENTA**,** RECHAZO**)** (H02 y RD-RP022-001):

XML  
\<mxfile host\="app.diagrams.net" modified\="2026-10-28T11:50:00.000Z" agent\="Gemini-REV03B" version\="24.7.17" type\="device"\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 1: DS UC-37 BUSCAR PROVEEDOR                                       \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id\="ds-rev03b-uc37" name\="DS UC-37 Buscar Proveedor (REV03B)"\>

    \<mxGraphModel dx\="1400" dy\="800" grid\="1" gridSize\="10" guides\="1" tooltips\="1" connect\="1" arrows\="1" fold\="1" page\="1" pageScale\="1" pageWidth\="1350" pageHeight\="850" math\="0" shadow\="0"\>

      \<root\>

        \<mxCell id\="0" /\>

        \<mxCell id\="1" parent\="0" /\>

        \<mxCell id\="u37\_title" value\="Diagrama de Secuencia de Diseño (DS — REV03B) — UC-37: Buscar Proveedor" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex\="1" parent\="1"\>

          \<mxGeometry x\="50" y\="15" width\="850" height\="30" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u37\_actor" value\="Usuario Interno&\#xa;Autorizado" style\="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="90" y\="60" width\="30" height\="60" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u37\_actor\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="99" y\="155" width\="12" height\="620" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u37\_ctrl\_box" value\=":ControladorProveedores" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="400" y\="60" width\="175" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u37\_ctrl\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="487" y\="800" as\="sourcePoint" /\>

            \<mxPoint x\="487" y\="105" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u37\_ctrl\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="481" y\="155" width\="12" height\="620" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u37\_cat\_box" value\=":CatalogoProveedores" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="780" y\="60" width\="170" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u37\_cat\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="865" y\="800" as\="sourcePoint" /\>

            \<mxPoint x\="865" y\="105" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u37\_cat\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="859" y\="200" width\="12" height\="120" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u37\_m1" value\="1: proveedores \= buscarProveedor(idProveedor:Long\[0..1\], cuit:String\[0..1\], razonSocial:String\[0..1\], nombreComercial:String\[0..1\], estado:String\[0..1\])" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="111" y\="190" as\="sourcePoint" /\>

            \<mxPoint x\="481" y\="190" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u37\_m2" value\="2: lista \= consultarProveedoresPorCriterios(filtro) \[Visibilidad por Atributo\]" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="493" y\="235" as\="sourcePoint" /\>

            \<mxPoint x\="859" y\="235" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u37\_r2" value\="2.1: lista : List\&lt;Proveedor\&gt;" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="859" y\="295" as\="sourcePoint" /\>

            \<mxPoint x\="493" y\="295" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u37\_alt" value\="alt Resultado de la búsqueda de Proveedores \[UC-37\]" style\="shape=umlFrame;whiteSpace=wrap;html=1;width=360;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="50" y\="340" width\="1150" height\="380" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u37\_g1" value\="\[lista.notEmpty()\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="125" y\="365" width\="300" height\="20" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u37\_r1\_ok" value\="3.1: presenta idProveedor, CUIT, razón social, nombre comercial, contacto y estado (ACTIVO\|INACTIVO); devuelve el seleccionado al CU invocante" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="481" y\="455" as\="sourcePoint" /\>

            \<mxPoint x\="111" y\="455" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u37\_div" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="50" y\="555" as\="sourcePoint" /\>

            \<mxPoint x\="1200" y\="555" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u37\_g2" value\="\[Sin coincidencias\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="125" y\="565" width\="300" height\="20" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u37\_r1\_empty" value\="3.2: informa que no se encontraron Proveedores sin modificar información" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="481" y\="655" as\="sourcePoint" /\>

            \<mxPoint x\="111" y\="655" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 2: DS UC-11 GESTIONAR PROVEEDOR                                    \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id\="ds-rev03b-uc11" name\="DS UC-11 Gestionar Proveedor (REV03B)"\>

    \<mxGraphModel dx\="1600" dy\="900" grid\="1" gridSize\="10" guides\="1" tooltips\="1" connect\="1" arrows\="1" fold\="1" page\="1" pageScale\="1" pageWidth\="1550" pageHeight\="1050" math\="0" shadow\="0"\>

      \<root\>

        \<mxCell id\="0" /\>

        \<mxCell id\="1" parent\="0" /\>

        \<mxCell id\="u11\_title" value\="Diagrama de Secuencia de Diseño (DS — REV03B) — UC-11: Gestionar Proveedor (Título canónico Fase 4)" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex\="1" parent\="1"\>

          \<mxGeometry x\="50" y\="15" width\="1050" height\="30" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u11\_actor" value\="Administrador" style\="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="85" y\="60" width\="30" height\="60" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u11\_actor\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="94" y\="155" width\="12" height\="820" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u11\_ctrl\_box" value\=":ControladorProveedores" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="350" y\="60" width\="175" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u11\_ctrl\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="437" y\="1000" as\="sourcePoint" /\>

            \<mxPoint x\="437" y\="105" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u11\_ctrl\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="431" y\="155" width\="12" height\="820" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u11\_cat\_box" value\=":CatalogoProveedores" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="660" y\="60" width\="170" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u11\_cat\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="745" y\="1000" as\="sourcePoint" /\>

            \<mxPoint x\="745" y\="105" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u11\_cat\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="739" y\="200" width\="12" height\="520" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u11\_prv\_box" value\="unProveedor : Proveedor" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="960" y\="380" width\="165" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u11\_prv\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="1042" y\="1000" as\="sourcePoint" /\>

            \<mxPoint x\="1042" y\="425" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u11\_prv\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="1036" y\="425" width\="12" height\="190" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u11\_rel\_box" value\="rel : ProveedorInsumo&\#xa;\[1..\*\]" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="1240" y\="510" width\="185" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u11\_rel\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="1332" y\="1000" as\="sourcePoint" /\>

            \<mxPoint x\="1332" y\="555" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u11\_rel\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="1326" y\="555" width\="12" height\="75" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u11\_m1" value\="1: idProveedor \= gestionarProveedor(cuit:String, razonSocial:String, nombreComercial:String\[0..1\], contacto:ContactoDTO, insumosVigencias:List\&lt;VigenciaInsumoDTO\&gt;)" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="106" y\="185" as\="sourcePoint" /\>

            \<mxPoint x\="431" y\="185" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u11\_m2" value\="2: validacion \= validarUnicidadCuitYVigenciasInsumo(cuitNormalizado, insumosVigencias) \[Atributo\]" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="443" y\="230" as\="sourcePoint" /\>

            \<mxPoint x\="739" y\="230" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u11\_r2" value\="2.1: (cuitUnico:Boolean, contactoValido:Boolean, vigenciasSinSolapamiento:Boolean)" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="739" y\="280" as\="sourcePoint" /\>

            \<mxPoint x\="443" y\="280" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u11\_alt" value\="alt Validación de CUIT único, contacto válido y vigencias ProveedorInsumo sin solapamiento \[UC-11\]" style\="shape=umlFrame;whiteSpace=wrap;html=1;width=630;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="50" y\="315" width\="1440" height\="610" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u11\_g1" value\="\[cuitUnico \== true, contactoValido \== true, insumosVigencias.notEmpty() y vigenciasSinSolapamiento \== true\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="120" y\="340" width\="700" height\="20" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u11\_m3\_new" value\="3: «create» new(cuitNormalizado, razonSocial, nombreComercial, contacto, estado=ACTIVO)" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="443" y\="402" as\="sourcePoint" /\>

            \<mxPoint x\="960" y\="402" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u11\_m4\_new" value\="4: «create» new(unProveedor, unInsumo, vigenteDesde, vigenteHasta\[0..1\])" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="1048" y\="532" as\="sourcePoint" /\>

            \<mxPoint x\="1240" y\="532" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u11\_m5" value\="5: guardarProveedorYAsociaciones(unProveedor:Proveedor)" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="443" y\="685" as\="sourcePoint" /\>

            \<mxPoint x\="739" y\="685" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u11\_r1\_ok" value\="5.1: confirma Proveedor ACTIVO y vigencias históricas en ProveedorInsumo" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="431" y\="750" as\="sourcePoint" /\>

            \<mxPoint x\="106" y\="750" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u11\_div" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="50" y\="800" as\="sourcePoint" /\>

            \<mxPoint x\="1490" y\="800" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u11\_g2" value\="\[CUIT duplicado, datos comerciales/contacto inválidos o asociación ProveedorInsumo superpuesta\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="120" y\="810" width\="660" height\="20" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u11\_r1\_err" value\="5.2: no registra identidad duplicada ni período incompatible y solicita corrección" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="431" y\="890" as\="sourcePoint" /\>

            \<mxPoint x\="106" y\="890" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 3: DS UC-45 MODIFICAR PROVEEDOR («include» UC-37)                  \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id\="ds-rev03b-uc45" name\="DS UC-45 Modificar Proveedor (REV03B)"\>

    \<mxGraphModel dx\="1500" dy\="850" grid\="1" gridSize\="10" guides\="1" tooltips\="1" connect\="1" arrows\="1" fold\="1" page\="1" pageScale\="1" pageWidth\="1450" pageHeight\="920" math\="0" shadow\="0"\>

      \<root\>

        \<mxCell id\="0" /\>

        \<mxCell id\="1" parent\="0" /\>

        \<mxCell id\="u45\_title" value\="Diagrama de Secuencia de Diseño (DS — REV03B) — UC-45: Modificar Proveedor (con «include» UC-37)" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex\="1" parent\="1"\>

          \<mxGeometry x\="50" y\="15" width\="1050" height\="30" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u45\_actor" value\="Administrador" style\="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="90" y\="60" width\="30" height\="60" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u45\_actor\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="99" y\="155" width\="12" height\="700" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u45\_ctrl\_box" value\=":ControladorProveedores" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="380" y\="60" width\="175" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u45\_ctrl\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="467" y\="880" as\="sourcePoint" /\>

            \<mxPoint x\="467" y\="105" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u45\_ctrl\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="461" y\="155" width\="12" height\="700" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u45\_cat\_box" value\=":CatalogoProveedores" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="720" y\="60" width\="170" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u45\_cat\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="805" y\="880" as\="sourcePoint" /\>

            \<mxPoint x\="805" y\="105" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u45\_cat\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="799" y\="290" width\="12" height\="90" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u45\_prv\_box" value\="unProveedor : Proveedor" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="1060" y\="60" width\="170" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u45\_prv\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="1145" y\="880" as\="sourcePoint" /\>

            \<mxPoint x\="1145" y\="105" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u45\_prv\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="1139" y\="485" width\="12" height\="165" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u45\_ref37" value\="ref «include» UC-37 Buscar Proveedor (recibe unProveedor y muestra sus datos y asociaciones vigentes con Insumos)" style\="shape=umlFrame;whiteSpace=wrap;html=1;width=260;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="65" y\="165" width\="760" height\="60" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u45\_m1" value\="1: ok \= modificarProveedor(idProveedor:Long, datosComerciales:DatosProveedorDTO, cambiosVigenciasInsumo:List\&lt;VigenciaInsumoDTO\&gt;)" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="111" y\="265" as\="sourcePoint" /\>

            \<mxPoint x\="461" y\="265" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u45\_m2" value\="2: val \= validarCompatibilidadInsumosYVigencias(idProveedor, datosComerciales, cambiosVigenciasInsumo) \[Atributo\]" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="473" y\="315" as\="sourcePoint" /\>

            \<mxPoint x\="799" y\="315" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u45\_alt" value\="alt Validación de formato, Insumos registrados y conservación de vigencias anteriores \[UC-45\]" style\="shape=umlFrame;whiteSpace=wrap;html=1;width=610;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="50" y\="405" width\="1310" height\="415" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u45\_g1" value\="\[Datos comerciales válidos, Insumos existentes y períodos \[vigenteDesde, vigenteHasta) sin solapamiento\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="125" y\="430" width\="680" height\="20" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u45\_m3" value\="3: actualizarDatosComercialesYVigencias(datosComerciales, cambiosVigenciasInsumo) \[Variable Local\]" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="473" y\="510" as\="sourcePoint" /\>

            \<mxPoint x\="1139" y\="510" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u45\_r3" value\="3.1: actualiza datos vigentes y preserva historia de ProveedorInsumo (estado ACTIVO/INACTIVO corresponde a UC-46; cuentas a UC-17/18)" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="1139" y\="585" as\="sourcePoint" /\>

            \<mxPoint x\="473" y\="585" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u45\_r1\_ok" value\="3.2: informa modificación realizada" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="461" y\="645" as\="sourcePoint" /\>

            \<mxPoint x\="111" y\="645" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u45\_div" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="50" y\="695" as\="sourcePoint" /\>

            \<mxPoint x\="1360" y\="695" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u45\_g2" value\="\[Vínculo con Insumo inexistente, vigencia incompatible o datos inválidos\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="125" y\="705" width\="520" height\="20" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u45\_r1\_err" value\="3.3: solicita corrección y conserva sin cambios el historial" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="461" y\="785" as\="sourcePoint" /\>

            \<mxPoint x\="111" y\="785" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 4: DS UC-46 CAMBIAR ESTADO DE PROVEEDOR («include» UC-37)          \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id\="ds-rev03b-uc46" name\="DS UC-46 Cambiar Estado Proveedor (REV03B)"\>

    \<mxGraphModel dx\="1500" dy\="850" grid\="1" gridSize\="10" guides\="1" tooltips\="1" connect\="1" arrows\="1" fold\="1" page\="1" pageScale\="1" pageWidth\="1450" pageHeight\="920" math\="0" shadow\="0"\>

      \<root\>

        \<mxCell id\="0" /\>

        \<mxCell id\="1" parent\="0" /\>

        \<mxCell id\="u46\_title" value\="Diagrama de Secuencia de Diseño (DS — REV03B) — UC-46: Cambiar Estado de Proveedor (con «include» UC-37)" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex\="1" parent\="1"\>

          \<mxGeometry x\="50" y\="15" width\="1080" height\="30" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u46\_actor" value\="Administrador" style\="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="90" y\="60" width\="30" height\="60" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u46\_actor\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="99" y\="155" width\="12" height\="700" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u46\_ctrl\_box" value\=":ControladorProveedores" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="380" y\="60" width\="175" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u46\_ctrl\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="467" y\="880" as\="sourcePoint" /\>

            \<mxPoint x\="467" y\="105" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u46\_ctrl\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="461" y\="155" width\="12" height\="700" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u46\_cat\_box" value\=":CatalogoProveedores" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="720" y\="60" width\="170" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u46\_cat\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="805" y\="880" as\="sourcePoint" /\>

            \<mxPoint x\="805" y\="105" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u46\_cat\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="799" y\="290" width\="12" height\="90" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u46\_prv\_box" value\="unProveedor : Proveedor" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="1060" y\="60" width\="170" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u46\_prv\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="1145" y\="880" as\="sourcePoint" /\>

            \<mxPoint x\="1145" y\="105" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u46\_prv\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="1139" y\="485" width\="12" height\="165" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u46\_ref37" value\="ref «include» UC-37 Buscar Proveedor (recibe unProveedor y muestra estado comercial actual y referencias históricas)" style\="shape=umlFrame;whiteSpace=wrap;html=1;width=260;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="65" y\="165" width\="760" height\="60" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u46\_m1" value\="1: ok \= cambiarEstadoProveedor(idProveedor:Long, nuevoEstado:String, motivo:String\[0..1\])" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="111" y\="265" as\="sourcePoint" /\>

            \<mxPoint x\="461" y\="265" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u46\_m2" value\="2: admisible \= revalidarTransicionEstadoProveedor(idProveedor, nuevoEstado, motivo) \[Atributo — Pendiente F09\]" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="473" y\="315" as\="sourcePoint" /\>

            \<mxPoint x\="799" y\="315" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u46\_alt" value\="alt Transición ACTIVO / INACTIVO conservando identidad, invitaciones, respuestas y Órdenes históricas \[UC-46\]" style\="shape=umlFrame;whiteSpace=wrap;html=1;width=690;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="50" y\="405" width\="1310" height\="415" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u46\_g1" value\="\[unProveedor.estado \!= nuevoEstado y transición admisible\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="125" y\="430" width\="520" height\="20" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u46\_m3" value\="3: establecerEstadoComercial(nuevoEstado:String) \[Visibilidad por Variable Local\]" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="473" y\="510" as\="sourcePoint" /\>

            \<mxPoint x\="1139" y\="510" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u46\_r3" value\="3.1: actualiza Proveedor.estado (si pasa a INACTIVO no es invitable ni admite respuestas nuevas; conserva Órdenes abiertas sin cancelarlas de oficio)" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="1139" y\="585" as\="sourcePoint" /\>

            \<mxPoint x\="473" y\="585" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u46\_r1\_ok" value\="3.2: informa nuevo estado comercial registrado" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="461" y\="645" as\="sourcePoint" /\>

            \<mxPoint x\="111" y\="645" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u46\_div" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="50" y\="695" as\="sourcePoint" /\>

            \<mxPoint x\="1360" y\="695" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u46\_g2" value\="\[Ya tiene el estado solicitado o cambio concurrente inválido\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="125" y\="705" width\="520" height\="20" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u46\_r1\_err" value\="3.3: informa ausencia de cambio o detiene la transición sin alterar el historial" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="461" y\="785" as\="sourcePoint" /\>

            \<mxPoint x\="111" y\="785" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 5: DS UC-40 BUSCAR ORDEN DE COMPRA                                 \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id\="ds-rev03b-uc40" name\="DS UC-40 Buscar Orden Compra (REV03B)"\>

    \<mxGraphModel dx\="1400" dy\="800" grid\="1" gridSize\="10" guides\="1" tooltips\="1" connect\="1" arrows\="1" fold\="1" page\="1" pageScale\="1" pageWidth\="1350" pageHeight\="850" math\="0" shadow\="0"\>

      \<root\>

        \<mxCell id\="0" /\>

        \<mxCell id\="1" parent\="0" /\>

        \<mxCell id\="u40\_title" value\="Diagrama de Secuencia de Diseño (DS — REV03B) — UC-40: Buscar Orden de Compra" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex\="1" parent\="1"\>

          \<mxGeometry x\="50" y\="15" width\="850" height\="30" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u40\_actor" value\="Usuario Interno&\#xa;Autorizado" style\="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="90" y\="60" width\="30" height\="60" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u40\_actor\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="99" y\="155" width\="12" height\="620" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u40\_ctrl\_box" value\=":ControladorCotizacionesCompras" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="380" y\="60" width\="210" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u40\_ctrl\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="485" y\="800" as\="sourcePoint" /\>

            \<mxPoint x\="485" y\="105" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u40\_ctrl\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="479" y\="155" width\="12" height\="620" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u40\_repo\_box" value\=":RepositorioCotizaciones" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="780" y\="60" width\="175" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u40\_repo\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="867" y\="800" as\="sourcePoint" /\>

            \<mxPoint x\="867" y\="105" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u40\_repo\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="861" y\="200" width\="12" height\="120" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u40\_m1" value\="1: ordenes \= buscarOrdenCompra(idOrdenCompra:Long\[0..1\], idProveedor:Long\[0..1\], idInsumo:Long\[0..1\], estado:String\[0..1\], fechaEmision:LocalDate\[0..1\])" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="111" y\="190" as\="sourcePoint" /\>

            \<mxPoint x\="479" y\="190" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u40\_m2" value\="2: consultarOrdenesPorCriterios(filtro) \[Visibilidad por Atributo\]" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="491" y\="235" as\="sourcePoint" /\>

            \<mxPoint x\="861" y\="235" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u40\_r2" value\="2.1: List\&lt;OrdenCompra\&gt;" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="861" y\="295" as\="sourcePoint" /\>

            \<mxPoint x\="491" y\="295" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u40\_alt" value\="alt Resultado de la búsqueda de Órdenes de Compra \[UC-40\]" style\="shape=umlFrame;whiteSpace=wrap;html=1;width=380;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="50" y\="340" width\="1150" height\="380" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u40\_g1" value\="\[Existen Órdenes coincidentes\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="125" y\="365" width\="300" height\="20" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u40\_r1\_ok" value\="3.1: muestra idOrdenCompra, fechaEmision, Proveedor, Insumo, cantidadOrdenada, Unidad de Medida y estado; devuelve la seleccionada al CU invocante" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="479" y\="455" as\="sourcePoint" /\>

            \<mxPoint x\="111" y\="455" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u40\_div" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="50" y\="555" as\="sourcePoint" /\>

            \<mxPoint x\="1200" y\="555" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u40\_g2" value\="\[Sin coincidencias\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="125" y\="565" width\="300" height\="20" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u40\_r1\_empty" value\="3.2: informa ausencia de coincidencias sin modificar estados" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="479" y\="655" as\="sourcePoint" /\>

            \<mxPoint x\="111" y\="655" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 6: DS UC-39 CANCELAR ORDEN DE COMPRA («include» UC-40)             \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id\="ds-rev03b-uc39" name\="DS UC-39 Cancelar Orden Compra (REV03B)"\>

    \<mxGraphModel dx\="1500" dy\="850" grid\="1" gridSize\="10" guides\="1" tooltips\="1" connect\="1" arrows\="1" fold\="1" page\="1" pageScale\="1" pageWidth\="1450" pageHeight\="920" math\="0" shadow\="0"\>

      \<root\>

        \<mxCell id\="0" /\>

        \<mxCell id\="1" parent\="0" /\>

        \<mxCell id\="u39\_title" value\="Diagrama de Secuencia de Diseño (DS — REV03B) — UC-39: Cancelar Orden de Compra (con «include» UC-40)" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex\="1" parent\="1"\>

          \<mxGeometry x\="50" y\="15" width\="1100" height\="30" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u39\_actor" value\="Administrador" style\="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="90" y\="60" width\="30" height\="60" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u39\_actor\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="99" y\="155" width\="12" height\="700" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u39\_ctrl\_box" value\=":ControladorCotizacionesCompras" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="360" y\="60" width\="210" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u39\_ctrl\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="465" y\="880" as\="sourcePoint" /\>

            \<mxPoint x\="465" y\="105" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u39\_ctrl\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="459" y\="155" width\="12" height\="700" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u39\_oc\_box" value\="unaOrden : OrdenCompra" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="860" y\="60" width\="180" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u39\_oc\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="950" y\="880" as\="sourcePoint" /\>

            \<mxPoint x\="950" y\="105" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u39\_oc\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="944" y\="380" width\="12" height\="220" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u39\_ref40" value\="ref «include» UC-40 Buscar Orden de Compra (localiza unaOrden en estado PENDIENTE o PARCIALMENTE\_RECIBIDA)" style\="shape=umlFrame;whiteSpace=wrap;html=1;width=260;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="65" y\="165" width\="760" height\="60" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u39\_m1" value\="1: ok \= cancelarOrdenCompra(idOrdenCompra:Long, motivoCancelacion:String, cancelacionAtribuibleProveedor:Boolean)" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="111" y\="275" as\="sourcePoint" /\>

            \<mxPoint x\="459" y\="275" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u39\_alt" value\="alt Cancelación de saldo pendiente de Orden de Compra con motivo obligatorio \[UC-39\]" style\="shape=umlFrame;whiteSpace=wrap;html=1;width=560;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="50" y\="325" width\="1310" height\="495" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u39\_g1" value\="\[unaOrden.estado in (PENDIENTE, PARCIALMENTE\_RECIBIDA) y motivoCancelacion \!= null\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="125" y\="350" width\="620" height\="20" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u39\_m2" value\="2: cancelarSaldoPendiente(motivoCancelacion, cancelacionAtribuibleProveedor, idAdmin, fechaHoraCancelacion) \[Variable Local\]" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="471" y\="425" as\="sourcePoint" /\>

            \<mxPoint x\="944" y\="425" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u39\_r2" value\="2.1: establece estado \= CANCELADA (conserva RecepcionCompra previas; si persiste stock \&lt; umbral mantiene episodio abierto para UC-44)" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="944" y\="515" as\="sourcePoint" /\>

            \<mxPoint x\="471" y\="515" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u39\_r1\_ok" value\="2.2: confirma Orden de Compra CANCELADA" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="459" y\="595" as\="sourcePoint" /\>

            \<mxPoint x\="111" y\="595" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u39\_div" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="50" y\="655" as\="sourcePoint" /\>

            \<mxPoint x\="1360" y\="655" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u39\_g2" value\="\[Orden ya RECIBIDA o CANCELADA, o falta motivoCancelacion\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="125" y\="665" width\="520" height\="20" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u39\_r1\_err" value\="2.3: rechaza la cancelación y conserva el estado actual de la Orden" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="459" y\="755" as\="sourcePoint" /\>

            \<mxPoint x\="111" y\="755" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 7: DS UC-08 REGISTRAR INGRESO DE STOCK POR COMPRA (H01/H02/RP022)  \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id\="ds-rev03b-uc08" name\="DS UC-08 Registrar Ingreso Compra (REV03B)"\>

    \<mxGraphModel dx\="1700" dy\="1000" grid\="1" gridSize\="10" guides\="1" tooltips\="1" connect\="1" arrows\="1" fold\="1" page\="1" pageScale\="1" pageWidth\="1650" pageHeight\="1350" math\="0" shadow\="0"\>

      \<root\>

        \<mxCell id\="0" /\>

        \<mxCell id\="1" parent\="0" /\>

        \<mxCell id\="u08\_title" value\="Diagrama de Secuencia de Diseño (DS — REV03B) — UC-08: Registrar Ingreso de Stock por Compra («extend» UC-40) \[H01 / H02 / RD-RP022-001\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex\="1" parent\="1"\>

          \<mxGeometry x\="50" y\="15" width\="1380" height\="30" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u08\_actor" value\="Responsable de&\#xa;Producción / Admin" style\="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="80" y\="60" width\="30" height\="60" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u08\_actor\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="89" y\="155" width\="12" height\="1120" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u08\_ctrl\_box" value\=":ControladorInventario" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="320" y\="60" width\="170" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u08\_ctrl\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="405" y\="1300" as\="sourcePoint" /\>

            \<mxPoint x\="405" y\="105" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u08\_ctrl\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="399" y\="155" width\="12" height\="1120" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u08\_rcp\_box" value\="unaRecepcion :&\#xa;RecepcionCompra" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="620" y\="380" width\="165" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u08\_rcp\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="702" y\="1300" as\="sourcePoint" /\>

            \<mxPoint x\="702" y\="425" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u08\_rcp\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="696" y\="425" width\="12" height\="75" as\="geometry" /\>

        \</mxCell\>

        \<\!-- PARTICIPANTES INSUMO (ORDEN H01: COSTO PRIMERO, MOVIMIENTO DESPUÉS) \--\>

        \<mxCell id\="u08\_cst\_box" value\="nuevoCosto :&\#xa;CostoInsumoHistorico" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="860" y\="485" width\="175" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u08\_cst\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="947" y\="1300" as\="sourcePoint" /\>

            \<mxPoint x\="947" y\="530" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u08\_cst\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="941" y\="530" width\="12" height\="65" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u08\_movi\_box" value\="movIns : MovimientoInsumo&\#xa;\+ unInsumo / unaOrden" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="1110" y\="590" width\="190" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u08\_movi\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="1205" y\="1300" as\="sourcePoint" /\>

            \<mxPoint x\="1205" y\="635" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u08\_movi\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="1199" y\="635" width\="12" height\="80" as\="geometry" /\>

        \</mxCell\>

        \<\!-- PARTICIPANTES REVENTA SEPARADOS (RD-RP022-001) \--\>

        \<mxCell id\="u08\_rev\_box" value\="prodRev : Producto (REVENTA)&\#xa;\+ movRev : MovimientoStockReventa" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="1360" y\="60" width\="220" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u08\_rev\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="1470" y\="1300" as\="sourcePoint" /\>

            \<mxPoint x\="1470" y\="105" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u08\_rev\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="1464" y\="870" width\="12" height\="140" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u08\_opt40" value\="opt «extend» UC-40 Buscar Orden de Compra \[cuando el ingreso de Insumo responde a una Orden de Compra emitida\]" style\="shape=umlFrame;whiteSpace=wrap;html=1;width=690;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="65" y\="165" width\="760" height\="55" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u08\_m1" value\="1: idRecepcion \= registrarIngresoStockPorCompra(tipoElemento:String, idElemento:Long, idOrdenCompra:Long\[0..1\], cantidadRecibida:BigDecimal, costoUnitarioCompra:BigDecimal, comprobante:String)" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="101" y\="265" as\="sourcePoint" /\>

            \<mxPoint x\="399" y\="265" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<\!-- FRAGMENTO ALT CON 3 OPERANDOS MUTUAMENTE EXCLUYENTES (H02) \--\>

        \<mxCell id\="u08\_alt" value\="alt Registro de Recepción por Tipo de Inventario Separado \[UC-08 — H01 / H02 / RD-RP022-001\]" style\="shape=umlFrame;whiteSpace=wrap;html=1;width=640;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="45" y\="310" width\="1555" height\="920" as\="geometry" /\>

        \</mxCell\>

        \<\!-- OPERANDO 1: INSUMO \--\>

        \<mxCell id\="u08\_g1" value\="\[Operando 1 — tipoElemento \== INSUMO, cantidadRecibida \&gt; 0, costoUnitarioCompra \&gt; 0 y (idOrdenCompra \== null \|\| cantRecibida \&lt;\= saldoPendienteOrden)\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontStyle=1" vertex\="1" parent\="1"\>

          \<mxGeometry x\="115" y\="335" width\="960" height\="20" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u08\_m2\_rcp" value\="2: «create» new(idOrdenCompra\[0..1\], unInsumo, cantidadRecibida, costoUnitarioCompra, fechaHoraRecepcion)" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="411" y\="402" as\="sourcePoint" /\>

            \<mxPoint x\="620" y\="402" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u08\_m3\_cost" value\="3 \[H01 Primero Costo\]: «create» new(unInsumo, vigenteDesde=fechaHoraRecepcion, costoUnitarioCompra, fuenteCosto=COMPRA, unaRecepcion)" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="411" y\="507" as\="sourcePoint" /\>

            \<mxPoint x\="860" y\="507" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u08\_m4\_mov" value\="4 \[H01 Luego Movimiento\]: «create» new(unInsumo, tipo=INGRESO\_COMPRA, cantidadRecibida, stockResultante, vigenteDesdeCosto=nuevoCosto.vigenteDesde) \+ actualizar OrdenCompra y evaluar EpisodioFaltante" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="411" y\="612" as\="sourcePoint" /\>

            \<mxPoint x\="1110" y\="612" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u08\_r1\_ins" value\="4.1: confirma ingreso de Insumo, nueva vigencia en CostoInsumoHistorico, MovimientoInsumo y actualización de OrdenCompra" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="399" y\="745" as\="sourcePoint" /\>

            \<mxPoint x\="101" y\="745" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<\!-- OPERANDO 2: PRODUCTO REVENTA \--\>

        \<mxCell id\="u08\_div1" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="45" y\="790" as\="sourcePoint" /\>

            \<mxPoint x\="1600" y\="790" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u08\_g2" value\="\[Operando 2 — tipoElemento \== REVENTA, cantidadRecibida \&gt; 0 y costoUnitarioCompra \&gt; 0 (RD-RP022-001)\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontStyle=1" vertex\="1" parent\="1"\>

          \<mxGeometry x\="115" y\="800" width\="760" height\="20" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u08\_m5\_rev" value\="5: recalcularCostoPromedioPonderadoMovilYCrearMovimientoReventa(cantidadRecibida, costoUnitarioCompra, unaRecepcion)" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="411" y\="895" as\="sourcePoint" /\>

            \<mxPoint x\="1464" y\="895" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u08\_r5\_rev" value\="5.1: actualiza costoPromedioActualReventa \= (stockAnt\*costoAnt \+ cant\*costoCompra)/(stockAnt \+ cant), stockActualReventa y MovimientoStockReventa" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="1464" y\="975" as\="sourcePoint" /\>

            \<mxPoint x\="411" y\="975" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u08\_r1\_rev" value\="5.2: confirma ingreso de Producto REVENTA con promedio ponderado móvil actualizado" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="399" y\="1035" as\="sourcePoint" /\>

            \<mxPoint x\="101" y\="1035" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<\!-- OPERANDO 3: RECHAZO \--\>

        \<mxCell id\="u08\_div2" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="45" y\="1080" as\="sourcePoint" /\>

            \<mxPoint x\="1600" y\="1080" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u08\_g3" value\="\[Operando 3 — Cantidad o costo \&lt;\= 0, Orden CANCELADA/RECIBIDA, cantidad supera saldo pendiente o Producto ELABORADO\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="115" y\="1090" width\="800" height\="20" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u08\_r1\_err" value\="5.3: rechaza la recepción de forma atómica sin alterar existencias, costos ni estado de la Orden" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="399" y\="1180" as\="sourcePoint" /\>

            \<mxPoint x\="101" y\="1180" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

\</mxfile\>

### **Archivo 4:** docs/08-diagramas/revision/CONTRATOS\_REV03B\_PROVEEDORES\_ORDENES\_7\_OPERACIONES.md

Este archivo contiene los **7 Contratos individuales desagrupados** (UC-37, UC-11, UC-45, UC-46, UC-40, UC-39, UC-08) con las **9 secciones estándar**, firmas 100% homologadas y aplicación estricta de H01, H02 y RD-RP022-001:

Markdown  
\# Contratos de Operación del Sistema (DSS — REV-03B) — Proveedores, Órdenes de Compra y Recepción (7 Contratos Individuales)

**\*\*Proyecto:\*\*** Sistema de Gestión para Ale Milanesas (UNaM-FCEQyN)  

**\*\*Lote de revisión:\*\*** \`REV-03B\` (\`UC-37\`, \`UC-11\`, \`UC-45\`, \`UC-46\`, \`UC-40\`, \`UC-39\`, \`UC-08\`)  

**\*\*Decisiones y criterios incorporados:\*\*** \`RD-RP022-001\` (separación de inventarios \`INSUMO\` y \`REVENTA\` y promedio ponderado móvil), corrección de secuencia \`Costo → Movimiento\` (\`H01\`/\`H02\` de \`REV-01\`) y desagrupamiento total de contratos (\`H-11\`).

\---

\#\# 1\. Contrato de la Operación \`buscarProveedor\` (\`UC-37\`)

1\. **\*\*Nombre:\*\*** \`buscarProveedor(idProveedor: Long\[0..1\], cuit: String\[0..1\], razonSocial: String\[0..1\], nombreComercial: String\[0..1\], estado: String\[0..1\])\`

2\. **\*\*Responsabilidades:\*\*** Localizar Proveedores activos o inactivos que cumplan los criterios indicados y devolver el Proveedor seleccionado al caso de uso invocante sin modificar su información.

3\. **\*\*Tipo:\*\*** \`Sistema\`

4\. **\*\*Referencias cruzadas:\*\*** Caso de Uso \`UC-37 — Buscar Proveedor\`; incluido por \`UC-45 — Modificar Proveedor\` y \`UC-46 — Cambiar Estado de Proveedor\`; Objetivo \`OBJE-09\`; Requisito \`RF-11\`.

5\. **\*\*Notas:\*\*** Operación estrictamente de solo lectura. Si el caso de uso invocante exige que el Proveedor se encuentre \`ACTIVO\`, dicha condición es validada por ese caso de uso.

6\. **\*\*Excepciones:\*\***

   \* **\*\*A1 — Sin coincidencias:\*\*** Informar que no se encontraron Proveedores que cumplan los criterios.

   \* **\*\*A2 — Criterios con formato inválido:\*\*** Solicitar corrección sin ejecutar la búsqueda.

7\. **\*\*Salida:\*\***

   \* Listado de Proveedores coincidentes (\`idProveedor\`, \`cuit\`, \`razonSocial\`, \`nombreComercial\`, contacto principal, \`estado\` \`ACTIVO\` \| \`INACTIVO\`) y referencia del \`Proveedor\` seleccionado; o mensajes de las excepciones A1–A2.

8\. **\*\*Precondiciones:\*\***

   \* El actor interno se encuentra autenticado y autorizado.

9\. **\*\*Postcondiciones:\*\***

   \* *\*(Sin cambios de estado en el sistema: no se crean ni modifican instancias de \`Proveedor\` ni \`ProveedorInsumo\`)\**.

\---

\#\# 2\. Contrato de la Operación \`gestionarProveedor\` (\`UC-11\`)

1\. **\*\*Nombre:\*\*** \`gestionarProveedor(cuit: String, razonSocial: String, nombreComercial: String\[0..1\], contacto: ContactoDTO, insumosVigencias: List\<VigenciaInsumoDTO\>)\`

2\. **\*\*Responsabilidades:\*\*** Registrar un Proveedor comercial verificando la unicidad de su CUIT normalizado y estableciendo las vigencias históricas de los Insumos que suministra (\`ProveedorInsumo\`).

3\. **\*\*Tipo:\*\*** \`Sistema\`

4\. **\*\*Referencias cruzadas:\*\*** Caso de Uso \`UC-11 — Gestionar Proveedor\` *\*(denominación canónica Fase 4)\**; Objetivo \`OBJE-09\`; Requisito \`RF-11\`.

5\. **\*\*Notas:\*\*** El registro comercial del \`Proveedor\` es independiente de la creación de su cuenta de \`Usuario\` (\`UC-17\`/\`UC-18\`). No se admiten períodos de vigencia superpuestos para el mismo par \`Proveedor\`–\`Insumo\`.

6\. **\*\*Excepciones:\*\***

   \* **\*\*A1 — CUIT duplicado (en Proveedor activo o inactivo):\*\*** Rechazar el registro de una nueva identidad duplicada.

   \* **\*\*A2 — Datos comerciales o de contacto inválidos o ausentes:\*\*** Solicitar corrección antes de confirmar.

   \* **\*\*A3 — Asociación \`ProveedorInsumo\` superpuesta o vigencia inválida:\*\*** Rechazar el período incompatible.

7\. **\*\*Salida:\*\***

   \* Confirmación del \`Proveedor\` registrado (\`idProveedor\`, \`estado \= ACTIVO\`) y de sus asociaciones \`ProveedorInsumo\` vigentes; o mensajes de las excepciones A1–A3.

8\. **\*\*Precondiciones:\*\***

   \* El \`Administrador\` se encuentra autenticado y autorizado, y existen los \`Insumo\` referenciados en \`insumosVigencias\`.

9\. **\*\*Postcondiciones:\*\***

   \* Se creó una instancia \`unProveedor\` de \`Proveedor\` con \`cuit\` normalizado único, \`razonSocial\`, \`nombreComercial\`, datos de contacto, \`estado \= ACTIVO\` y \`fechaHoraAlta\`.

   \* Para cada elemento en \`insumosVigencias\`, se creó una instancia de \`ProveedorInsumo\` asociada a \`unProveedor\` y al \`Insumo\`, con \`vigenteDesde\` y \`vigenteHasta\` (\`0..1\`).

\---

\#\# 3\. Contrato de la Operación \`modificarProveedor\` (\`UC-45\` «include» \`UC-37\`)

1\. **\*\*Nombre:\*\*** \`modificarProveedor(idProveedor: Long, datosComerciales: DatosProveedorDTO, cambiosVigenciasInsumo: List\<VigenciaInsumoDTO\>)\`

2\. **\*\*Responsabilidades:\*\*** Actualizar los datos comerciales/contacto y las asociaciones vigentes de \`ProveedorInsumo\` de un \`Proveedor\` previamente localizado mediante \`UC-37\`, preservando su historial de vigencias anteriores.

3\. **\*\*Tipo:\*\*** \`Sistema\`

4\. **\*\*Referencias cruzadas:\*\*** Caso de Uso \`UC-45 — Modificar Proveedor\`; incluye \`UC-37 — Buscar Proveedor\`; Objetivo \`OBJE-09\`; Requisitos \`RF-11\`, \`IRQ-08\`.

5\. **\*\*Notas:\*\*** Los cambios de estado \`ACTIVO\`/\`INACTIVO\` corresponden exclusivamente a \`UC-46\`, y la administración de cuentas de acceso con Rol \`PROVEEDOR\` corresponde a \`UC-17\`/\`UC-18\`.

6\. **\*\*Excepciones:\*\***

   \* **\*\*A1 — \`UC-37\` finalizó sin selección válida:\*\*** No modificar información.

   \* **\*\*A2 — Vínculo con \`Insumo\` inexistente, vigencia \`\[vigenteDesde, vigenteHasta)\` superpuesta o datos comerciales inválidos:\*\*** Solicitar corrección y conservar los datos anteriores.

7\. **\*\*Salida:\*\***

   \* Confirmación de la modificación de los datos comerciales y de las asociaciones \`ProveedorInsumo\` del \`Proveedor\`; o mensajes de las excepciones A1–A2.

8\. **\*\*Precondiciones:\*\***

   \* El \`Administrador\` se encuentra autenticado y autorizado, existe el \`Proveedor\` seleccionado mediante \`UC-37\` y existen los \`Insumo\` involucrados.

9\. **\*\*Postcondiciones:\*\***

   \* Se modificaron los atributos comerciales y de contacto vigentes de \`unProveedor\` (conservando inalterado \`unProveedor.estado\`).

   \* Se crearon nuevas instancias y/o se cerraron períodos vigentes en \`ProveedorInsumo\` conforme a \`cambiosVigenciasInsumo\`, sin eliminar los períodos históricos anteriores.

\---

\#\# 4\. Contrato de la Operación \`cambiarEstadoProveedor\` (\`UC-46\` «include» \`UC-37\`)

1\. **\*\*Nombre:\*\*** \`cambiarEstadoProveedor(idProveedor: Long, nuevoEstado: String, motivo: String\[0..1\])\`

2\. **\*\*Responsabilidades:\*\*** Activar o desactivar lógicamente un \`Proveedor\` (previamente localizado mediante \`UC-37\`), conservando su identidad comercial y la totalidad de sus invitaciones, respuestas, órdenes de compra y vigencias históricas.

3\. **\*\*Tipo:\*\*** \`Sistema\`

4\. **\*\*Referencias cruzadas:\*\*** Caso de Uso \`UC-46 — Cambiar Estado de Proveedor\`; incluye \`UC-37 — Buscar Proveedor\`; Pendiente \`F09\`; Objetivo \`OBJE-09\`; Requisitos \`RF-11\`, \`IRQ-08\`.

5\. **\*\*Notas:\*\*** Si el \`Proveedor\` pasa a \`INACTIVO\`, deja de ser elegible para nuevas \`InvitacionCotizacion\` (\`UC-44\` / \`PRA-01\`), no admite nuevas respuestas (\`UC-13\`) ni nuevas confirmaciones de compra (\`UC-12\`), pero **\*\*no se eliminan sus respuestas previas ni se cancelan automáticamente sus \`OrdenCompra\` abiertas\*\*** (las cuales quedan sujetas a resolución manual autorizada en \`UC-08\` o \`UC-39\`).

6\. **\*\*Excepciones:\*\***

   \* **\*\*A1 — Sin \`Proveedor\` seleccionado en \`UC-37\`:\*\*** No ejecutar operación.

   \* **\*\*A2 — El \`Proveedor\` ya posee el \`nuevoEstado\` solicitado:\*\*** Informar ausencia de cambio.

   \* **\*\*A3 — Estado o dependencias modificados concurrentemente de modo inválido:\*\*** Detener la transición sin alterar el historial.

7\. **\*\*Salida:\*\***

   \* Confirmación del nuevo \`Proveedor.estado\` (\`ACTIVO\` \| \`INACTIVO\`), o mensajes provocados por las excepciones A1–A3.

8\. **\*\*Precondiciones:\*\***

   \* El \`Administrador\` se encuentra autenticado y autorizado, y existe el \`Proveedor\` seleccionado mediante \`UC-37\`.

9\. **\*\*Postcondiciones:\*\***

   \* Se modificó el atributo \`unProveedor.estado\` al valor \`nuevoEstado\` (\`ACTIVO\` o \`INACTIVO\`).

   \* Se conservaron íntegramente todas las instancias históricas de \`InvitacionCotizacion\`, \`RespuestaCotizacion\`, \`DecisionCompra\`, \`OrdenCompra\` y \`ProveedorInsumo\` asociadas a \`unProveedor\`.

\---

\#\# 5\. Contrato de la Operación \`buscarOrdenCompra\` (\`UC-40\`)

1\. **\*\*Nombre:\*\*** \`buscarOrdenCompra(idOrdenCompra: Long\[0..1\], idProveedor: Long\[0..1\], idInsumo: Long\[0..1\], estado: String\[0..1\], fechaEmision: LocalDate\[0..1\])\`

2\. **\*\*Responsabilidades:\*\*** Localizar y presentar las \`OrdenCompra\` que cumplan los criterios informados y devolver la Orden seleccionada al caso de uso invocante (\`UC-08\`, \`UC-39\` o consulta de seguimiento).

3\. **\*\*Tipo:\*\*** \`Sistema\`

4\. **\*\*Referencias cruzadas:\*\*** Caso de Uso \`UC-40 — Buscar Orden de Compra\`; incluido por \`UC-39 — Cancelar Orden de Compra\`; extiende condicionalmente a \`UC-08 — Registrar Ingreso de Stock por Compra\`; Objetivo \`OBJE-09\`; Requisito \`RF-11\`.

5\. **\*\*Notas:\*\*** Operación estrictamente de solo lectura. Si el caso invocante exige un estado específico (\`PENDIENTE\` o \`PARCIALMENTE\_RECIBIDA\`), dicha validación se ejecuta en el caso invocante.

6\. **\*\*Excepciones:\*\***

   \* **\*\*A1 — Sin coincidencias:\*\*** Informar que no existen Órdenes de Compra que cumplan los criterios.

   \* **\*\*A2 — Criterios inválidos:\*\*** Solicitar corrección sin modificar registros.

7\. **\*\*Salida:\*\***

   \* Listado de \`OrdenCompra\` coincidentes (\`idOrdenCompra\`, \`fechaHoraEmision\`, \`Proveedor\`, \`Insumo\`, \`cantidadOrdenada\`, \`codigoUnidadMedida\`, \`estado\`, referencia a la decisión/cotización) y referencia de la Orden seleccionada; o mensajes de las excepciones A1–A2.

8\. **\*\*Precondiciones:\*\***

   \* El actor interno (\`Administrador\` o \`Responsable de Producción\`) se encuentra autenticado y autorizado.

9\. **\*\*Postcondiciones:\*\***

   \* *\*(Sin cambios de estado en el sistema: operación de solo lectura)\**.

\---

\#\# 6\. Contrato de la Operación \`cancelarOrdenCompra\` (\`UC-39\` «include» \`UC-40\`)

1\. **\*\*Nombre:\*\*** \`cancelarOrdenCompra(idOrdenCompra: Long, motivoCancelacion: String, cancelacionAtribuibleProveedor: Boolean)\`

2\. **\*\*Responsabilidades:\*\*** Cancelar de forma trazable el saldo pendiente de recepción de una \`OrdenCompra\` en estado \`PENDIENTE\` o \`PARCIALMENTE\_RECIBIDA\` (previamente localizada mediante \`UC-40\`), registrando su motivo obligatorio y si el incumplimiento es atribuible al Proveedor.

3\. **\*\*Tipo:\*\*** \`Sistema\`

4\. **\*\*Referencias cruzadas:\*\*** Caso de Uso \`UC-39 — Cancelar Orden de Compra\`; incluye \`UC-40 — Buscar Orden de Compra\`; Caso de Uso \`UC-44 — Iniciar Ronda Manual de Cotización\`; Objetivos \`OBJE-07\`, \`OBJE-09\`; Requisitos \`RF-05\`, \`RF-11\`.

5\. **\*\*Notas:\*\*** Exclusivo del \`Administrador\`. Las \`RecepcionCompra\` y el stock ya ingresados antes de la cancelación no se revierten. Si tras cancelar la Orden el \`Insumo\` permanece con \`stockActual \< umbralMinimo\`, el \`EpisodioFaltante\` conserva su alerta abierta para que el Administrador pueda iniciar una ronda manual mediante \`UC-44\` (**\*\*sin producir un nuevo disparo automático\*\***).

6\. **\*\*Excepciones:\*\***

   \* **\*\*A1 — \`OrdenCompra\` inexistente, ya \`RECIBIDA\` o ya \`CANCELADA\`:\*\*** Rechazar la cancelación.

   \* **\*\*A2 — Falta \`motivoCancelacion\` obligatorio o no se indicó \`cancelacionAtribuibleProveedor\`:\*\*** Solicitar completar los datos antes de confirmar.

7\. **\*\*Salida:\*\***

   \* Confirmación de la \`OrdenCompra\` en estado \`CANCELADA\` y aviso de alerta de stock bajo persistente cuando corresponda; o mensajes de las excepciones A1–A2.

8\. **\*\*Precondiciones:\*\***

   \* El \`Administrador\` se encuentra autenticado y autorizado, y la \`OrdenCompra\` seleccionada mediante \`UC-40\` se encuentra en estado \`PENDIENTE\` o \`PARCIALMENTE\_RECIBIDA\`.

9\. **\*\*Postcondiciones:\*\***

   \* Se modificaron en la instancia \`unaOrden\` de \`OrdenCompra\` los atributos \`estado \= CANCELADA\`, \`fechaHoraCancelacion\`, \`motivoCancelacion\` y \`cancelacionAtribuibleProveedor\`, asociando al \`Usuario\` Administrador responsable.

   \* Se conservaron inalteradas las instancias previas de \`RecepcionCompra\`, \`MovimientoInsumo\` y \`CostoInsumoHistorico\`.

   \* Si \`Insumo.stockActual \< Insumo.umbralMinimo\`, el \`EpisodioFaltante\` permaneció abierto sin emitir automáticamente una nueva \`SolicitudCotizacion\`.

\---

\#\# 7\. Contrato de la Operación \`registrarIngresoStockPorCompra\` (\`UC-08\` «extend» \`UC-40\`)

1\. **\*\*Nombre:\*\*** \`registrarIngresoStockPorCompra(tipoElemento: String, idElemento: Long, idOrdenCompra: Long\[0..1\], cantidadRecibida: BigDecimal, costoUnitarioCompra: BigDecimal, comprobante: String)\`

2\. **\*\*Responsabilidades:\*\*** Registrar la recepción física por compra de un \`Insumo\` o de un \`Producto\` de \`tipoProducto \= REVENTA\` manteniendo separados ambos inventarios (\`RD-RP022-001\`), actualizando **\*\*primero la valoración histórica y luego el movimiento de entrada\*\*** (\`H01\`/\`H02\`), y actualizando el grado de cumplimiento de la \`OrdenCompra\` cuando se vinculó mediante la extensión \`UC-40\`.

3\. **\*\*Tipo:\*\*** \`Sistema\`

4\. **\*\*Referencias cruzadas:\*\*** Caso de Uso \`UC-08 — Registrar Ingreso de Stock por Compra\`; extendido condicionalmente por \`UC-40 — Buscar Orden de Compra\`; Decisión \`RD-RP022-001\`; Objetivos \`OBJE-05\`, \`OBJE-07\`, \`OBJE-09\`; Requisitos \`RF-04\`, \`RF-05\`, \`RF-11\`.

5\. **\*\*Notas:\*\***

   \* Conforme a \`RD-RP022-001\`, el inventario de \`Insumo\` y el inventario de \`Producto\` \`REVENTA\` son independientes y nunca se mezclan.

   \* En el ingreso de \`Insumo\`, la creación de la nueva vigencia en \`CostoInsumoHistorico\` (\`fuenteCosto \= COMPRA\`) precede obligatoriamente a la creación del \`MovimientoInsumo\` que referencia \`vigenteDesdeCosto\` (\`H01\`).

   \* En el ingreso de \`Producto\` \`REVENTA\`, se recalcula el costo promedio ponderado móvil antes de registrar el \`MovimientoStockReventa\` (\`H06\`).

6\. **\*\*Excepciones:\*\***

   \* **\*\*A1 — \`cantidadRecibida \<= 0\` o \`costoUnitarioCompra \<= 0\`:\*\*** Rechazar la recepción sin alterar existencias ni costos.

   \* **\*\*A2 — \`idOrdenCompra\` informada pero la Orden está \`CANCELADA\` o \`RECIBIDA\`, corresponde a otro \`Insumo\`, o \`cantidadRecibida\` supera el saldo pendiente de recepción:\*\*** Rechazar la operación.

   \* **\*\*A3 — Se intenta registrar ingreso por compra sobre un \`Producto\` de \`tipoProducto \= ELABORADO\`:\*\*** Rechazar la operación.

7\. **\*\*Salida:\*\***

   \* Confirmación de la \`RecepcionCompra\` (\`idRecepcion\`), nuevo stock resultante, nuevo costo histórico o promedio ponderado móvil vigente y estado actualizado de la \`OrdenCompra\` (\`PARCIALMENTE\_RECIBIDA\` o \`RECIBIDA\`) cuando aplica; o mensajes de las excepciones A1–A3.

8\. **\*\*Precondiciones:\*\***

   \* El actor autorizado (\`Responsable de Producción\` o \`Administrador\`) se encuentra autenticado.

   \* Existe el \`Insumo\` o el \`Producto\` con \`tipoProducto \= REVENTA\` identificado por \`idElemento\` (y, si se vinculó mediante \`UC-40\`, existe la \`OrdenCompra\` en estado \`PENDIENTE\` o \`PARCIALMENTE\_RECIBIDA\`).

9\. **\*\*Postcondiciones:\*\***

   \* Se creó una instancia \`unaRecepcion\` de \`RecepcionCompra\` con \`fechaHoraRecepcion\`, \`cantidadRecibida\`, \`costoUnitarioCompra\` y \`comprobante\`, asociada al \`Usuario\` registrador y opcionalmente a la \`OrdenCompra\` (\`0..1\`).

   \* **\*\*Si \`tipoElemento \= INSUMO\` (Operando 1):\*\***

     \* Se cerró la vigencia previa y se creó **\*\*primero\*\*** una nueva instancia \`nuevoCosto\` de \`CostoInsumoHistorico\` con \`vigenteDesde \= fechaHoraRecepcion\`, \`costoUnitario \= costoUnitarioCompra\` y \`fuenteCosto \= COMPRA\`, asociada a \`unInsumo\` y a \`unaRecepcion\`.

     \* Se incrementó \`unInsumo.stockActual\` en \`cantidadRecibida\`.

     \* Se creó **\*\*después\*\*** una instancia de \`MovimientoInsumo\` con \`tipoMovimiento \= INGRESO\_COMPRA\`, \`cantidad \= cantidadRecibida\` y \`stockResultante\`, asociada a \`unInsumo\`, a \`unaRecepcion\` y a \`nuevoCosto\` (\`vigenteDesdeCosto\`).

     \* Si estuvo asociada a \`unaOrden\`, se incrementó su acumulado recibido y se actualizó \`unaOrden.estado\` a \`PARCIALMENTE\_RECIBIDA\` (si resta saldo) o \`RECIBIDA\` (si completó \`cantidadOrdenada\`); y si \`unInsumo.stockActual \>= unInsumo.umbralMinimo\` sin Solicitudes ni Órdenes pendientes, se cerró el \`EpisodioFaltante\`.

   \* **\*\*Si \`tipoElemento \= REVENTA\` (Operando 2 — \`RD-RP022-001\`):\*\***

     \* Se recalculó y actualizó el costo promedio ponderado móvil del \`Producto\` de reventa (\`CostoReventaHistorico\` / \`costoPromedioActualReventa\`) combinando el stock previo valorizado y la nueva entrada \`cantidadRecibida \* costoUnitarioCompra\`.

     \* Se incrementó \`Producto.stockActualReventa\` en \`cantidadRecibida\`.

     \* Se creó una instancia de \`MovimientoStockReventa\` con \`tipoMovimiento \= INGRESO\_COMPRA\`, \`cantidad \= cantidadRecibida\`, \`stockResultante\` y costo asociado a \`unaRecepcion\`.

\---

\#\# 8\. Glosario de Términos Asociados (\`REV-03B\`)

\* **\*\*\`Proveedor\` (Tipo / Concepto — Tabla \`PROVEEDOR\`):\*\*** Entidad comercial externa identificada por su \`cuit\` normalizado único, con \`razonSocial\`, datos de contacto y \`estado\` (\`ACTIVO\` \| \`INACTIVO\`).

\* **\*\*\`ProveedorInsumo\` (Tipo / Concepto — Tabla \`PROVEEDOR*\_INSUMO\`):\*\* Relación histórica con intervalo \`\[vigenteDesde, vigenteHasta)\` que acredita qué \`Insumo\` suministra un \`Proveedor\`.***

***\* \*\*\`OrdenCompra\` (Tipo / Concepto — Tabla \`ORDEN\_COMPRA\`):\*\* Compromiso formal de compra emitido en \`UC-12\` con \`cantidadOrdenada\`, \`precioUnitarioAcordado\` y estados \`PENDIENTE\`, \`PARCIALMENTE\_RECIBIDA\`, \`RECIBIDA\` o \`CANCELADA\`.***

***\* \*\*\`RecepcionCompra\` (Tipo / Concepto — Tabla \`RECEPCION\_COMPRA\`):\*\* Registro de ingreso físico de mercadería comprada, vinculable opcionalmente a una \`OrdenCompra\`.***

***\* \*\*\`CostoInsumoHistorico\` (Tipo / Concepto — Tabla \`COSTO\_INSUMO\_HISTORICO\`):\*\* Vigencia histórica del costo unitario de un \`Insumo\` (\`SALDO\_INICIAL\` o \`COMPRA\`), que precede y respalda todo \`MovimientoInsumo\`.***

### **Estado Acumulado y Próximo Paso: Lote 4 (**REV-04 — Pedidos y Reparto**)**

Con REV-03A y REV-03B completados, quedaron íntegramente corregidos y auditados los **13 Casos de Uso de Abastecimiento, Proveedores, Cotizaciones y Compras** (UC-08, UC-11, UC-12, UC-13, UC-37, UC-39, UC-40, UC-44, UC-45, UC-46, UC-58, UC-62, UC-63).

El siguiente paso del plan de trabajo es el **Lote 4 (**REV-04 — Pedidos y Reparto**)**, donde debemos aplicar:

* RD-F04-001..007 **y** RD-RP004/RP028 **(**H-03**,** H-09**):** Declaración de efectivo recibido por el Repartidor en UC-05 y su tratamiento como **efectivo en tránsito**, más la validación en servidor para operación offline en UC-03/UC-05.  
*   
* RD-RP001/RP019 **(**H-05**):** Selección de fechaReparto entre opciones habilitadas y validación del servidor en UC-21.  
*   
* RD-RP002-001 **(**H-21**):** Las 6 reglas obligatorias en UC-43 (cuenta activa, Rol REPARTIDOR, asignación vigente única transaccional, operación exclusivamente online, control de concurrencia y motivo obligatorio en reasignación).  
*   
* RD-RP020-001 **(**H-23**):** Secuencia de reprogramación de Pedido pendiente, invalidación de asignación UC-43 e historial de fecha.


