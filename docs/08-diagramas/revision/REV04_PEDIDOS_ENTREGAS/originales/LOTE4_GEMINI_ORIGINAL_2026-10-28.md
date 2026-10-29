### **Paquete Completo de Revisión Transversal — Lote 4A (`REV-04A`: Pedidos, Canal Online, Asignación y Ruteo)**

Aplicando la metodología reproducible de ocho etapas (`M-0` a `M-7`) definida en **`REV01_AUDITORIA_TRANSVERSAL_CIERRE_2026-10-28.md`** y levantando los hallazgos de **`AUDITORIA_PREINTEGRACION_GEMINI_DSS_DS_CONTRATOS_2026-10-27.md`**, entrego la primera mitad del Lote 4 (**`REV-04A`: `UC-34`, `UC-03`, `UC-21`, `UC-43`, `UC-04`, `UC-25`**).

### **Archivo 1: `docs/08-diagramas/revision/REV04A_AUDITORIA_TRANSVERSAL_PEDIDOS_REPARTO_2026-10-28.md`**

\# REV-04A — Auditoría Transversal y Corrección: Pedidos, Canal Online, Asignación y Ruteo (UC-34, UC-03, UC-21, UC-43, UC-04, UC-25)

\*\*Fecha:\*\* 28/10/2026  

\*\*Rama de trabajo propuesta:\*\* \`revision/rev04a-pedidos-reparto-2026-10-28\`  

\*\*Alcance (\`REV-04A\`):\*\* \`UC-34\`, \`UC-03\` («include» \`UC-33\`, \`UC-35\`, \`UC-16\`→\`UC-15\`), \`UC-21\` («include» \`UC-16\`→\`UC-15\`, \`UC-29\`), \`UC-43\` («include» \`UC-34\`), \`UC-04\`, \`UC-25\`.  

\*\*Estado de los artefactos entregados:\*\* \`PROPUESTO / CORREGIDO EN REVISIÓN ESTÁTICA\` (pendiente de inspección visual humana en Draw.io y aprobación para fusión a \`main\`).

\---

\#\# 1\. Ejecución de las 8 Etapas Metodológicas (M-0 a M-7)

\#\#\# M-0 — Autoridad y alcance congelados

\* \*\*Catálogo funcional vigente:\*\* 64 CU consecutivos (\`UC-01\`..\`UC-64\`) en 3 niveles (\`ALE\_MILANESAS\_FASE\_4\_CU\_01\_A\_64\_TRES\_NIVELES.docx\`).

\* \*\*Relaciones UML aprobadas en este sublote:\*\* \`UC-03 → UC-33\` (\`include\`), \`UC-03 → UC-35\` (\`include\`), \`UC-03 → UC-16\` (\`include\`), \`UC-16 → UC-15\` (\`include\`), \`UC-21 → UC-16\` (\`include\`), \`UC-21 → UC-29\` (\`include\`) y \`UC-43 → UC-34\` (\`include\`). El archivo \`DIAGRAMA DE CASOS DE USO.drawio (1).xml\` permanece intacto.

\* \*\*Decisiones posteriores incorporadas (Corte 27/10/2026):\*\*

  \* \*\*\`RD-RP001/RP019\` (resuelve Hallazgo de Prioridad Alta \`H-05\`):\*\* En \`UC-21 — Realizar Pedido Online\`, el Cliente Online selecciona la \`fechaReparto\` entre las \*\*fechas habilitadas\*\* presentadas por el sistema y el servidor \*\*valida que la fecha seleccionada continúe habilitada antes de confirmar e iniciar el pago\*\* (dejando de tratar la fecha de reparto online como pendiente abierto).

  \* \*\*\`RD-RP023-001\` (resuelve Hallazgo de Prioridad Alta \`H-06\` en \`UC-21\`):\*\* Cuando concurren múltiples promociones vigentes para un mismo Producto y Cliente destinatario en \`UC-21\`, \*\*no se acumulan descuentos sobre las mismas unidades\*\*; el sistema evalúa las promociones elegibles, selecciona automáticamente la de \*\*mayor beneficio aplicable (mayor porcentaje de descuento elegible)\*\* y la congela en el detalle del Pedido.

  \* \*\*\`RD-RP002-001\` (resuelve Hallazgo de Prioridad Alta \`H-21\`):\*\* En \`UC-43 — Asignar y Reasignar Pedidos a Repartidores\`, se explicitan las \*\*6 reglas obligatorias\*\*:

    1\. El \`Pedido\` debe estar en estado \`PENDIENTE\` (tanto de canal \`INTERNO\` como \`ONLINE\`).

    2\. El Repartidor elegido debe poseer cuenta de \`Usuario\` en estado \`HABILITADO\`.

    3\. El Repartidor elegido debe poseer el Rol vigente \`REPARTIDOR\`.

    4\. Unicidad transaccional: existe a lo sumo una única \`AsignacionReparto\` vigente por \`Pedido\` (al reasignar se cierra la anterior y se activa la nueva atómicamente).

    5\. Operación \*\*exclusivamente online\*\* (no se admite asignar ni reasignar Repartidores en modo offline).

    6\. En toda reasignación es obligatorio informar \`motivoReasignacion\` y revalidar ausencia de conflicto concurrente (que el Pedido no haya sido entregado/cancelado ni reasignado por otro usuario).

  \* \*\*\`RD-F04-001..007\` (resuelve Hallazgo \`H-09\` en \`UC-03\`):\*\* En \`UC-03 — Cargar Pedido\`, cuando el Vendedor opera sin conectividad, el Pedido puede registrarse localmente con clave de idempotencia y snapshot comercial, quedando sujeto a \*\*validación y conciliación idempotente por el servidor\*\* al recuperar conectividad sin duplicar Pedidos.

  \* \*\*\`RD-RP020-001\` (resuelve Hallazgo \`H-23\`):\*\* Se incorpora la secuencia y contrato de \*\*reprogramación de \`fechaReparto\` sobre un Pedido \`PENDIENTE\`\*\* (dentro del alcance de gestión del Pedido sin crear un CU 65), la cual registra el historial de cambio de fecha con motivo obligatorio, \*\*invalida automáticamente la \`AsignacionReparto\` vigente (\`UC-43\`)\*\* para exigir nueva asignación y deja sin efecto cualquier \`RutaReparto\` sugerida previa (\`UC-25\`).

\#\#\# M-1 — Proveniencia, integridad y matriz de diferencias (Antes → Después)

\| ID Hallazgo \| Artefacto / Celda Original \| Antes (Borrador 26–27/10) \| Después (Versión Corregida \`REV04A\`) \| Fundamento \|

\| :--- \| :--- \| :--- \| :--- \| :--- \|

\| \*\*\`H-05\` (Alta)\*\* \| \`DS UC-21\` y \`Contrato 2.2\` \| El DSS tenía \`fechaReparto\`, pero el DS no validaba fechas habilitadas y el contrato lo declaraba pendiente. \| \`DS UC-21\` incorpora la consulta/validación en servidor de \`fechaReparto\` dentro de las \*\*fechas habilitadas\*\* antes de confirmar, y \`CONTRATO\_UC21\` lo formaliza en Pre/Postcondiciones y Excepciones. \| \`RD-RP001/RP019\` \|

\| \*\*\`H-06\` (Alta)\*\* \| \`DS UC-21\` (\`u21\_m6\`) y \`Contrato 2.2\` \| Aplica una promoción única sin especificar la regla de no acumulación ante promociones simultáneas. \| Explicita que ante promociones simultáneas \*\*no se acumulan descuentos sobre las mismas unidades\*\*, sino que se elige y congela el \*\*mejor beneficio aplicable\*\*. \| \`RD-RP023-001\` \|

\| \*\*\`H-21\` (Alta)\*\* \| \`DS UC-43\` (\`u43\_m2\`, \`u43\_g1\`) y \`Contrato 5.3\` \| Validaba solo \`Pedido PENDIENTE\` y asignación previa, dejando la elegibilidad y el modo offline como \`\[A CONFIRMAR\]\`. \| Incorpora en el DS y en \`CONTRATO\_UC43\` las \*\*6 reglas obligatorias\*\* de \`RD-RP002-001\` (cuenta \`HABILITADO\`, Rol \`REPARTIDOR\`, asignación vigente única, operación \*\*exclusivamente online\*\*, motivo en reasignación y control de concurrencia). \| \`RD-RP002-001\` \|

\| \*\*\`H-09\` (Media/Alta)\*\* \| \`DS UC-03\` y \`Contrato 5.2\` \| Citaba \`F04\` como pendiente abierto sin detallar la validación del servidor. \| Incorpora la regla aprobada \`RD-F04\`: captura local con \`claveIdempotencia\` y validación/conciliación idempotente en servidor al sincronizar. \| \`RD-F04-001..007\` \|

\| \*\*\`H-23\` (Media)\*\* \| \`DS UC-03\`/\`UC-43\` y Contratos \| No representaba la reprogramación de fecha de reparto de un Pedido \`PENDIENTE\` ni la invalidación de la asignación \`UC-43\`. \| Se incorpora la secuencia \`reprogramarFechaRepartoPedido\` (con historial de fecha e invalidación automática de \`AsignacionReparto\` vigente y ruta sugerida) y su Contrato explícito. \| \`RD-RP020-001\` \|

\| \*\*\`H-11\`, \`H-12\`, \`H-19\`, \`H05\`\*\* \| \`DSS\`, \`DS\` y \`Contratos\` \| Contratos agrupados en \`UC-21\` y firmas distintas entre DSS, DS y Contrato. \| Marcos \`sd\` independientes en DSS, lenguaje de caja negra, firmas 1:1 homologadas y \*\*7 Contratos individuales\*\* con 9 secciones estándar. \| \`M-3\`, \`H-11\`, \`H-12\`, \`H-19\`, \`H05\` \|

\---

\#\# 2\. Matriz de Trazabilidad Vertical y Visibilidad de Larman Mensaje por Mensaje (M-3 y M-6)

\| CU \| Paso / Mensaje en DS \| Emisor \$\\rightarrow\$ Receptor \| Tipo de Visibilidad (Larman) \| Origen verificable de la referencia \|

\| :--- \| :--- \| :--- \| :--- \| :--- \|

\| \*\*\`UC-34\`\*\* \| \`1: buscarPedido(idPedido, idCliente, fechaReparto, estado, canalOrigen)\` \| \`Actor Interno Autorizado\` \$\\rightarrow\$ \`:ControladorPedidos\` \| Frontera de sistema \| Operación pública homologada del DSS (\`UC-34\`). \|

\| \*\*\`UC-34\`\*\* \| \`2: lista \= consultarPedidosPorCriterios(filtro)\` \| \`:ControladorPedidos\` \$\\rightarrow\$ \`:RepositorioPedidos\` \| \*\*Por Atributo\*\* \| Repositorio de Pedidos inyectado en el controlador. \|

\| \*\*\`UC-03\`\*\* \| \`1: cargarPedido(idCliente, fechaReparto, items, direccionEntrega, claveIdempotencia)\` \| \`Vendedor\` \$\\rightarrow\$ \`:ControladorPedidos\` \| Frontera de sistema \| Operación pública homologada del DSS (\`UC-03\`, precedida por \`«include» UC-33\` y \`UC-35\`). \|

\| \*\*\`UC-03\`\*\* \| \`2: ctx \= validarClienteActivoFechaProductosYIdempotencia(idCliente, fechaReparto, items, claveIdempotencia)\` \| \`:ControladorPedidos\` \$\\rightarrow\$ \`:RepositorioPedidos\` \| \*\*Por Atributo\*\* \| Valida en servidor Cliente \`ACTIVO\`, Productos \`ACTIVO\` con precio vigente, \`fechaReparto\` válida y no duplicación por \`claveIdempotencia\` (\`RD-F04\`). \|

\| \*\*\`UC-03\`\*\* \| \`3: «create» new(unCliente, fechaReparto, direccionEntrega, canalOrigen=INTERNO, estado=PENDIENTE)\` \| \`:ControladorPedidos\` \$\\rightarrow\$ \`nuevoPedido : Pedido\` \| \*\*Por Creación Local (\`new\`) \+ Parámetro\*\* \| Instancia el \`Pedido\` interno y crea sus \`det : DetallePedido\` congelando \`precioUnitarioOriginal\`. \|

\| \*\*\`UC-03\`→\`UC-16\`\*\* \| \`4: aplicarAjusteComercialSegunCategoria(unCliente, nuevoPedido)\` \| \`:ControladorPedidos\` \$\\rightarrow\$ \`:ControladorClientes\` (\`UC-16\`→\`UC-15\`) \| \*\*Por Atributo \+ Parámetro\*\* \| Ejecuta el caso incluido \`UC-16\` (que incluye \`UC-15\`) congelando categoría, tipo y porcentaje de ajuste y \`totalOriginal\`. \|

\| \*\*\`UC-03\` (\`RP-020\`)\*\* \| \`1b: reprogramarFechaRepartoPedido(idPedido, nuevaFechaReparto, motivo)\` \| \`Vendedor\` \$\\rightarrow\$ \`:ControladorPedidos\` \| Frontera de sistema \| Operación de reprogramación sobre Pedido \`PENDIENTE\` (\`RD-RP020-001\`). \|

\| \*\*\`UC-03\` (\`RP-020\`)\*\* \| \`2b: actualizarFechaRegistrarHistorialEInvalidarAsignacion(nuevaFechaReparto, motivo)\` \| \`:ControladorPedidos\` \$\\rightarrow\$ \`unPedido : Pedido\` \| \*\*Por Variable Local\*\* \| Registra el cambio en el historial de fecha del Pedido e \*\*invalida la \`AsignacionReparto\` vigente (\`UC-43\`)\*\* (\`RD-RP020-001\`). \|

\| \*\*\`UC-21\`\*\* \| \`1: realizarPedidoOnline(idDesafioVerificado, items, direccionEntrega, fechaReparto)\` \| \`Cliente Online\` \$\\rightarrow\$ \`:ControladorPedidos\` \| Frontera de sistema \| Operación pública homologada del DSS (\`UC-21\`). \|

\| \*\*\`UC-21\`\*\* \| \`2: okFecha \= validarClienteActivoYFechaRepartoHabilitada(idDesafioVerificado, fechaReparto)\` \| \`:ControladorPedidos\` \$\\rightarrow\$ \`:RepositorioPedidos\` \| \*\*Por Atributo\*\* \| Valida desafío OTP verificado de Cliente \`ACTIVO\` y que \`fechaReparto\` pertenezca a las \*\*fechas habilitadas en servidor\*\* (\`RD-RP001/RP019\`). \|

\| \*\*\`UC-21\`\*\* \| \`3: «create» new(unCliente, fechaReparto, direccionEntrega, canalOrigen=ONLINE, estado=PENDIENTE)\` \| \`:ControladorPedidos\` \$\\rightarrow\$ \`pedidoOnline : Pedido\` \| \*\*Por Creación Local (\`new\`)\*\* \| Crea el Pedido y evalúa promociones elegibles seleccionando el \*\*mejor beneficio aplicable sin acumular descuentos sobre las mismas unidades\*\* (\`RD-RP023-001\`), seguido de \`UC-16\`→\`UC-15\` y \`UC-29\`. \|

\| \*\*\`UC-43\`\*\* \| \`1: asignarOReasignarPedidoARepartidor(idPedido, idUsuarioRepartidor, motivoReasignacion)\` \| \`Vendedor\` \$\\rightarrow\$ \`:ControladorReparto\` \| Frontera de sistema \| Operación pública homologada del DSS (\`UC-43\`, precedida por \`«include» UC-34\`). \|

\| \*\*\`UC-43\`\*\* \| \`2: val \= revalidarReglasAsignacionOnline(idPedido, idUsuarioRepartidor, motivoReasignacion)\` \| \`:ControladorReparto\` \$\\rightarrow\$ \`:RepositorioPedidos\` \| \*\*Por Atributo\*\* \| Verifica las \*\*6 reglas de \`RD-RP002-001\`\*\*: operación online, Pedido \`PENDIENTE\`, Repartidor \`HABILITADO\` con Rol \`REPARTIDOR\`, cambio real, motivo obligatorio si reasigna y sin conflicto concurrente. \|

\| \*\*\`UC-43\`\*\* \| \`3: «create» new(unPedido, repElegido, fechaHoraInicio, vigente=true, motivoReasignacion)\` \| \`unPedido : Pedido\` \$\\rightarrow\$ \`nuevaAsig : AsignacionReparto\` \| \*\*Por Creación Local (\`new\`) \+ Atributo\*\* \| Cierra la asignación vigente previa (si existía), crea la única \`AsignacionReparto\` vigente e invalida cualquier \`RutaReparto\` previa de esa fecha. \|

\| \*\*\`UC-04\`\*\* \| \`1: consultarPedidosAsignados()\` \| \`Repartidor\` \$\\rightarrow\$ \`:ControladorReparto\` \| Frontera de sistema \| Operación pública homologada del DSS (\`UC-04\`). \|

\| \*\*\`UC-04\`\*\* \| \`2: misPedidos \= obtenerPedidosPendientesConAsignacionVigente(idRepartidorAutenticado)\` \| \`:ControladorReparto\` \$\\rightarrow\$ \`:RepositorioPedidos\` \| \*\*Por Atributo \+ Parámetro\*\* \| Recupera solo Pedidos \`PENDIENTE\` con asignación vigente al Repartidor autenticado, incluyendo adicionales de \`UC-07\`. \|

\| \*\*\`UC-25\`\*\* \| \`1: generarRutaSugeridaReparto(fechaReparto)\` \| \`Repartidor\` \$\\rightarrow\$ \`:ControladorReparto\` \| Frontera de sistema \| Operación pública homologada del DSS (\`UC-25\`). \|

\| \*\*\`UC-25\`\*\* \| \`2: respRuteo \= solicitarSecuenciaVisita(ubicacionesValidas)\` \| \`:ControladorReparto\` \$\\rightarrow\$ \`:AdaptadorRuteo\` \| \*\*Por Atributo \+ Parámetro\*\* \| Indirección hacia \`:ServicioDeRuteo\`; si responde válidamente, instancia \`unaRuta : RutaReparto\` (\*\*Creación Local\*\*). \|

\---

\#\# 3\. Matriz Transversal de Invariantes y Puertas de Aceptación (M-4 y M-7)

\| ID \| Invariante ratificada \| DSS \| DS \| Contrato \| Dictamen \|

\| :--- \| :--- \| :--- \| :--- \| :--- \| :--- \|

\| \*\*\`I-01\`\*\* \| \`RD-RP001/RP019\` (\`H-05\`): Selección de \`fechaReparto\` entre fechas habilitadas y validación del servidor antes de confirmar en \`UC-21\` \| Mensaje y guarda explícitos en \`DSS UC-21\` \| Paso \`2:\` y guarda en \`DS UC-21\` \| Pre/Postcondiciones y Excepción A2 en \`CONTRATO\_UC21\` \| \*\*PASÓ (Trazabilidad estática)\*\* \|

\| \*\*\`I-02\`\*\* \| \`RD-RP023-001\` (\`H-06\`): Promociones simultáneas no acumulan descuentos sobre las mismas unidades; se elige y congela el mejor beneficio aplicable antes del ajuste \`UC-16\` \| Respuesta explícita en \`DSS UC-21\` \| Selección del mejor descuento elegible en \`DS UC-21\` \| Notas y Postcondiciones en \`CONTRATO\_UC21\` \| \*\*PASÓ (Trazabilidad estática)\*\* \|

\| \*\*\`I-03\`\*\* \| \`RD-RP002-001\` (\`H-21\`): Las 6 reglas obligatorias en \`UC-43\` (Pedido \`PENDIENTE\`, Repartidor \`HABILITADO\` con Rol \`REPARTIDOR\`, asignación vigente única, operación exclusivamente online, motivo en reasignación y concurrencia) \| Guardas completas en \`DSS UC-43\` \| Revalidación explícita en \`DS UC-43\` \| Pre/Postcondiciones y Excepciones en \`CONTRATO\_UC43\` \| \*\*PASÓ (Trazabilidad estática)\*\* \|

\| \*\*\`I-04\`\*\* \| \`RD-RP020-001\` (\`H-23\`): Reprogramar \`fechaReparto\` de un Pedido \`PENDIENTE\` registra historial de fecha e invalida la \`AsignacionReparto\` vigente (\`UC-43\`) y la ruta sugerida (\`UC-25\`) \| Bloque \`opt\` de reprogramación en \`DSS Vendedor\` \| Bloque de reprogramación en \`DS UC-03\` \| \`CONTRATO\_REPROGRAMAR\_FECHA\` individual con 9 secciones \| \*\*PASÓ (Trazabilidad estática)\*\* \|

\| \*\*\`I-05\`\*\* \| \`RD-F04-001..007\` (\`H-09\`): Registro offline de \`UC-03\` con clave de idempotencia y validación/reconciliación del servidor al sincronizar \| Nota y guarda idempotente en \`DSS UC-03\` \| Verificación de \`claveIdempotencia\` en \`DS UC-03\` \| Notas, Excepciones y Postcondiciones en \`CONTRATO\_UC03\` \| \*\*PASÓ (Trazabilidad estática)\*\* \|

\| \*\*\`I-06\`\*\* \| Homologación 1:1 de firmas públicas DSS ↔ DS ↔ Contrato y desagrupamiento en contratos individuales (\`H-11\`, \`H05\`) \| Firmas canónicas \| Mensaje \`1:\` idéntico en las 6 páginas DS \| 7 Contratos individuales con 9 secciones \| \*\*PASÓ\*\* \|

\| \*\*\`I-07\`\*\* \| Inspección visual y prueba de desplazamiento (\`round-trip\`) en editor gráfico Draw.io (\`M-6\` / \`G5\`) \| XML bien formado \| XML bien formado \| N/A \| \*\*PENDIENTE DE VALIDACIÓN HUMANA EN DRAW.IO\*\* \|

### **Archivo 2: `docs/08-diagramas/revision/DSS_REV04A_PEDIDOS_REPARTO_FRAGMENTOS.drawio.xml`**

Este archivo XML compatible con **Draw.io** modela en **3 páginas** los escenarios de caja negra (DSS) de `UC-21` (Actor `Cliente Online`), `UC-34`, `UC-03` (con reprogramación `RD-RP020-001`) y `UC-43` (Actor `Vendedor`), y `UC-04` y `UC-25` (Actor `Repartidor`), separados en marcos `sd` independientes (`H-12`) y sin lenguaje SQL interno (`H-19`):

\<mxfile host="app.diagrams.net" modified="2026-10-28T12:00:00.000Z" agent="Gemini-REV04A" version="24.7.17" type="device"\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 1: DSS CAJA NEGRA — CLIENTE ONLINE (UC-21)                         \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id="dss-rev04a-online" name="DSS REV04A \- Cliente Online (UC-21)"\>

    \<mxGraphModel dx="1550" dy="900" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1500" pageHeight="1050" math="0" shadow="0"\>

      \<root\>

        \<mxCell id="0" /\>

        \<mxCell id="1" parent="0" /\>

        \<mxCell id="o1\_title" value="DSS (Caja Negra — REV04A) — Actor: Cliente Online — UC-21: Realizar Pedido Online \[RD-RP001/RP019 y RD-RP023-001\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=13;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="15" width="1300" height="30" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="o1\_actor" value="Cliente Online" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="100" y="60" width="30" height="60" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="o1\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="109" y="155" width="12" height="820" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="o1\_sys\_box" value=":Sistema" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;fontSize=13;" vertex="1" parent="1"\>

          \<mxGeometry x="820" y="60" width="140" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="o1\_sys\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="890" y="1000" as="sourcePoint" /\>

            \<mxPoint x="890" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="o1\_sys\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="884" y="155" width="12" height="820" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="o1\_ext\_box" value=":ServicioDeMensajeria /&\#xa;:MercadoPago" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;fontSize=12;" vertex="1" parent="1"\>

          \<mxGeometry x="1220" y="60" width="170" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="o1\_ext\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1305" y="1000" as="sourcePoint" /\>

            \<mxPoint x="1305" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="o1\_ext\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1299" y="210" width="12" height="480" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="o1\_sd21" value="sd Escenario Independiente — UC-21: Realizar Pedido Online («include» UC-16→UC-15 y UC-29)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=620;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="45" y="170" width="1395" height="770" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="o1\_m0" value="0.1: idDesafio \= solicitarYValidarAccesoOnline(telefonoPrincipal:String, codigoTemporal:String, codigoPromocion:UUID\[0..1\])" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="121" y="220" as="sourcePoint" /\>

            \<mxPoint x="884" y="220" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="o1\_m0\_ext" value="0.2: enviarCodigoTemporalWhatsApp(telefonoPrincipal, codigoTemporal)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="896" y="245" as="sourcePoint" /\>

            \<mxPoint x="1299" y="245" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="o1\_r0" value="0.3: \[Cliente único preexistente ACTIVO y código válido\] presenta catálogo activo, fechas de reparto habilitadas (RD-RP001) y mejor Promoción elegible sin acumulación (RD-RP023-001)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="884" y="305" as="sourcePoint" /\>

            \<mxPoint x="121" y="305" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="o1\_m1" value="1: comprobante \= realizarPedidoOnline(idDesafioVerificado:UUID, items:List\&lt;ItemPedidoDTO\&gt;, direccionEntrega:DireccionDTO, fechaReparto:LocalDate)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="121" y="375" as="sourcePoint" /\>

            \<mxPoint x="884" y="375" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="o1\_ref16" value="ref «include» UC-16 Aplicar Ajuste Comercial según Categoría («include» UC-15) — Aplicado luego de congelar el mejor beneficio promocional sin acumulación (RD-RP023-001)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=290;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="250" y="400" width="700" height="55" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="o1\_ref29" value="ref «include» UC-29 Registrar Cobro (procesa cobro electrónico vía MercadoPago y reevalúa UC-15)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=260;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="680" y="475" width="660" height="55" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="o1\_alt" value="alt Validación de fechaReparto habilitada en servidor y resultado del Cobro Electrónico \[UC-21 — RD-RP001 / RD-RP023-001\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=740;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="70" y="555" width="1340" height="355" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="o1\_g1" value="\[fechaReparto pertenece a las fechas habilitadas validadas por el servidor y el pago electrónico es confirmado\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="140" y="580" width="760" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="o1\_r1\_ok" value="1.1: registra Pedido ONLINE en estado PENDIENTE con mejor promoción sin acumulación y ajuste comercial congelados, más su Cobro electrónico confirmado" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="884" y="640" as="sourcePoint" /\>

            \<mxPoint x="121" y="640" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="o1\_div1" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="70" y="685" as="sourcePoint" /\>

            \<mxPoint x="1410" y="685" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="o1\_g2" value="\[RD-RP001/RP019: fechaReparto no habilitada o cerrada en el servidor antes de confirmar\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="140" y="695" width="660" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="o1\_r1\_fch" value="1.2: rechaza la fecha seleccionada y presenta nuevamente las fechas de reparto habilitadas sin iniciar pago" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="884" y="755" as="sourcePoint" /\>

            \<mxPoint x="121" y="755" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="o1\_div2" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="70" y="795" as="sourcePoint" /\>

            \<mxPoint x="1410" y="795" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="o1\_g3" value="\[Pago electrónico rechazado, cancelado o fallo de comunicación con MercadoPago\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="140" y="805" width="580" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="o1\_r1\_err" value="1.3: no confirma el Pedido ni registra Cobro, Caja ni Cuenta Corriente; informa el rechazo" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="884" y="875" as="sourcePoint" /\>

            \<mxPoint x="121" y="875" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 2: DSS CAJA NEGRA — VENDEDOR (UC-34, UC-03 \+ RP-020, UC-43)        \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id="dss-rev04a-vendedor" name="DSS REV04A \- Vendedor (UC-34, UC-03, UC-43)"\>

    \<mxGraphModel dx="1500" dy="950" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1450" pageHeight="1550" math="0" shadow="0"\>

      \<root\>

        \<mxCell id="0" /\>

        \<mxCell id="1" parent="0" /\>

        \<mxCell id="v1\_title" value="DSS (Caja Negra — REV04A) — Actor: Vendedor — Escenarios Independientes UC-34, UC-03 (+ Reprogramación RD-RP020-001) y UC-43 \[RD-RP002-001\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=13;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="15" width="1340" height="30" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="v1\_actor" value="Vendedor" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="110" y="60" width="30" height="60" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="v1\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="119" y="155" width="12" height="1320" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="v1\_sys\_box" value=":Sistema" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;fontSize=13;" vertex="1" parent="1"\>

          \<mxGeometry x="940" y="60" width="140" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="v1\_sys\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1010" y="1500" as="sourcePoint" /\>

            \<mxPoint x="1010" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="v1\_sys\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1004" y="155" width="12" height="1320" as="geometry" /\>

        \</mxCell\>

        \<\!-- MARCO UC-34 \--\>

        \<mxCell id="v1\_sd34" value="sd Escenario Independiente — UC-34: Buscar Pedido" style="shape=umlFrame;whiteSpace=wrap;html=1;width=360;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="170" width="1100" height="180" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="v1\_34\_m1" value="1: pedidos \= buscarPedido(idPedido:Long\[0..1\], idCliente:Long\[0..1\], fechaReparto:LocalDate\[0..1\], estado:String\[0..1\], canalOrigen:String\[0..1\])" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="131" y="220" as="sourcePoint" /\>

            \<mxPoint x="1004" y="220" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="v1\_34\_r1" value="1.1: presenta Pedidos coincidentes (idPedido, Cliente, fechaHoraCarga, fechaReparto, canalOrigen, estado) y devuelve el seleccionado al CU invocante" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1004" y="295" as="sourcePoint" /\>

            \<mxPoint x="131" y="295" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<\!-- MARCO UC-03 (+ REPROGRAMACION RD-RP020-001) \--\>

        \<mxCell id="v1\_sd03" value="sd Escenario Independiente — UC-03: Cargar Pedido («include» UC-33, UC-35, UC-16→UC-15) y Reprogramación \[RD-F04 / RD-RP020-001\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=840;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="380" width="1100" height="530" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="v1\_03\_ref" value="ref «include» UC-33 Buscar Cliente \+ «include» UC-35 Buscar Producto \+ «include» UC-16 Aplicar Ajuste Comercial («include» UC-15)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=280;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="90" y="415" width="840" height="50" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="v1\_03\_m1" value="1: idPedido \= cargarPedido(idCliente:Long, fechaReparto:LocalDate, items:List\&lt;ItemPedidoDTO\&gt;, direccionEntrega:DireccionDTO, claveIdempotencia:UUID)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="131" y="505" as="sourcePoint" /\>

            \<mxPoint x="1004" y="505" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="v1\_03\_r1" value="1.1: \[Cliente ACTIVO, Productos activos con precio vigente, fechaReparto válida y claveIdempotencia no duplicada\] registra Pedido INTERNO en estado PENDIENTE con precios y ajuste congelados" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1004" y="575" as="sourcePoint" /\>

            \<mxPoint x="131" y="575" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="v1\_03\_r2" value="1.2: \[Cliente INACTIVO, Producto sin precio vigente o fecha inválida\] rechaza la confirmación (en sincronización offline reconcilia idempotentemente en servidor — RD-F04)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1004" y="645" as="sourcePoint" /\>

            \<mxPoint x="131" y="645" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="v1\_opt\_rp20" value="opt \[Reprogramación de fechaReparto sobre un Pedido PENDIENTE — RD-RP020-001 (H-23)\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=580;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="75" y="685" width="1050" height="195" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="v1\_rp20\_m1" value="2: ok \= reprogramarFechaRepartoPedido(idPedido:Long, nuevaFechaReparto:LocalDate, motivoReprogramacion:String)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="131" y="745" as="sourcePoint" /\>

            \<mxPoint x="1004" y="745" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="v1\_rp20\_r1" value="2.1: \[Pedido PENDIENTE, nuevaFechaReparto válida \!= actual y motivo informado\] actualiza fechaReparto, registra historial de cambio de fecha e INVALIDA la asignación vigente de Repartidor (UC-43) y ruta sugerida (UC-25)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1004" y="830" as="sourcePoint" /\>

            \<mxPoint x="131" y="830" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<\!-- MARCO UC-43 (+ INCLUDE UC-34) CORREGIDO CON LAS 6 REGLAS RD-RP002-001 \--\>

        \<mxCell id="v1\_sd43" value="sd Escenario Independiente — UC-43: Asignar y Reasignar Pedidos a Repartidores («include» UC-34) \[RD-RP002-001\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=740;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="940" width="1100" height="480" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="v1\_43\_ref34" value="ref «include» UC-34 Buscar Pedido (selecciona el Pedido PENDIENTE de canal INTERNO u ONLINE y muestra su asignación vigente si existe)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=280;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="90" y="975" width="780" height="50" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="v1\_43\_m1" value="1: idAsignacion \= asignarOReasignarPedidoARepartidor(idPedido:Long, idUsuarioRepartidor:Long, motivoReasignacion:String\[0..1\])" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="131" y="1060" as="sourcePoint" /\>

            \<mxPoint x="1004" y="1060" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="v1\_43\_alt" value="alt Verificación de las 6 reglas obligatorias de Asignación/Reasignación \[UC-43 — RD-RP002-001\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=610;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="75" y="1085" width="1050" height="310" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="v1\_43\_g1" value="\[(1) Operación online, (2) Pedido PENDIENTE, (3) Repartidor con cuenta HABILITADO y (4) Rol REPARTIDOR activo, (5) distinto del actual y (6) motivoReasignacion informado si ya tenía asignación\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="145" y="1110" width="960" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="v1\_43\_r1" value="1.1: cierra asignación previa (si existía), registra nueva asignación vigente única transaccional e invalida ruta sugerida previa de esa fecha (sin alterar estado ni importes del Pedido)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1004" y="1180" as="sourcePoint" /\>

            \<mxPoint x="131" y="1180" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="v1\_43\_div" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="75" y="1235" as="sourcePoint" /\>

            \<mxPoint x="1125" y="1235" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="v1\_43\_g2" value="\[Modo offline, Pedido ENTREGADO/CANCELADO, Repartidor DESHABILITADO o sin Rol REPARTIDOR, mismo Repartidor, falta motivo en reasignación o conflicto concurrente\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="145" y="1245" width="960" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="v1\_43\_r2" value="1.2: rechaza la operación y conserva intacta la asignación anterior" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1004" y="1340" as="sourcePoint" /\>

            \<mxPoint x="131" y="1340" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 3: DSS CAJA NEGRA — REPARTIDOR (UC-04, UC-25)                      \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id="dss-rev04a-repartidor" name="DSS REV04A \- Repartidor (UC-04, UC-25)"\>

    \<mxGraphModel dx="1550" dy="900" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1500" pageHeight="1050" math="0" shadow="0"\>

      \<root\>

        \<mxCell id="0" /\>

        \<mxCell id="1" parent="0" /\>

        \<mxCell id="r1\_title" value="DSS (Caja Negra — REV04A) — Actor: Repartidor — Escenarios Independientes UC-04 y UC-25" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=13;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="15" width="1100" height="30" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="r1\_actor" value="Repartidor" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="100" y="60" width="30" height="60" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="r1\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="109" y="155" width="12" height="820" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="r1\_sys\_box" value=":Sistema" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;fontSize=13;" vertex="1" parent="1"\>

          \<mxGeometry x="820" y="60" width="140" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="r1\_sys\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="890" y="1000" as="sourcePoint" /\>

            \<mxPoint x="890" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="r1\_sys\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="884" y="155" width="12" height="820" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="r1\_rut\_box" value=":ServicioDeRuteo" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;fontSize=12;" vertex="1" parent="1"\>

          \<mxGeometry x="1220" y="60" width="160" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="r1\_rut\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1300" y="1000" as="sourcePoint" /\>

            \<mxPoint x="1300" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="r1\_rut\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1294" y="550" width="12" height="90" as="geometry" /\>

        \</mxCell\>

        \<\!-- MARCO UC-04 \--\>

        \<mxCell id="r1\_sd04" value="sd Escenario Independiente — UC-04: Consultar Pedidos Asignados" style="shape=umlFrame;whiteSpace=wrap;html=1;width=430;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="45" y="170" width="980" height="230" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="r1\_04\_m1" value="1: pedidosAsignados \= consultarPedidosAsignados()" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="121" y="220" as="sourcePoint" /\>

            \<mxPoint x="884" y="220" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="r1\_04\_r1" value="1.1: \[Con asignaciones vigentes\] muestra en solo lectura sus Pedidos PENDIENTE asignados (Cliente, fecha, dirección, Productos, cantidades originales y adicionales aceptadas en UC-07) \| \[Sin asignaciones\] lista vacía" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="884" y="320" as="sourcePoint" /\>

            \<mxPoint x="121" y="320" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<\!-- MARCO UC-25 \--\>

        \<mxCell id="r1\_sd25" value="sd Escenario Independiente — UC-25: Generar Ruta Sugerida de Reparto" style="shape=umlFrame;whiteSpace=wrap;html=1;width=450;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="45" y="435" width="1395" height="500" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="r1\_25\_m1" value="1: rutaSugerida \= generarRutaSugeridaReparto(fechaReparto:LocalDate)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="121" y="485" as="sourcePoint" /\>

            \<mxPoint x="884" y="485" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="r1\_25\_ext" value="1.1: calcularSecuenciaVisita(ubicacionesEntregas:List\&lt;UbicacionDTO\&gt;)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="896" y="565" as="sourcePoint" /\>

            \<mxPoint x="1294" y="565" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="r1\_25\_rext" value="1.2: secuenciaSugerida" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1294" y="620" as="sourcePoint" /\>

            \<mxPoint x="896" y="620" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="r1\_25\_r1" value="1.3: \[Ubicaciones completas y respuesta válida\] registra y presenta entregas en la secuencia sugerida sin modificar el estado de los Pedidos" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="884" y="705" as="sourcePoint" /\>

            \<mxPoint x="121" y="705" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="r1\_25\_r2" value="1.4: \[Ubicación insuficiente o Servicio de Ruteo no disponible/inconsistente\] informa la contingencia y presenta el listado pendiente sin afirmar ruta optimizada" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="884" y="810" as="sourcePoint" /\>

            \<mxPoint x="121" y="810" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="r1\_25\_r3" value="1.5: \[Sin Pedidos PENDIENTE asignados para fechaReparto\] informa ausencia de entregas pendientes sin invocar al servicio externo" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="884" y="895" as="sourcePoint" /\>

            \<mxPoint x="121" y="895" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

\</mxfile\>

### **Archivo 3: `docs/08-diagramas/revision/DS_REV04A_PEDIDOS_REPARTO_UC03_04_21_25_34_43.drawio.xml`**

Este archivo XML de **6 páginas** para **Draw.io** contiene los Diagramas de Secuencia de Diseño (DS de caja blanca) corregidos para `UC-34`, `UC-03`, `UC-21`, `UC-43`, `UC-04` y `UC-25`, incorporando todas las reglas de `RD-RP001/RP019` (`H-05`), `RD-RP023-001` (`H-06`), `RD-F04` (`H-09`), `RD-RP002-001` (`H-21`) y `RD-RP020-001` (`H-23`):

\<mxfile host="app.diagrams.net" modified="2026-10-28T12:05:00.000Z" agent="Gemini-REV04A" version="24.7.17" type="device"\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 1: DS UC-34 BUSCAR PEDIDO                                          \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id="ds-rev04a-uc34" name="DS UC-34 Buscar Pedido (REV04A)"\>

    \<mxGraphModel dx="1400" dy="800" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1350" pageHeight="850" math="0" shadow="0"\>

      \<root\>

        \<mxCell id="0" /\>

        \<mxCell id="1" parent="0" /\>

        \<mxCell id="u34\_title" value="Diagrama de Secuencia de Diseño (DS — REV04A) — UC-34: Buscar Pedido" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="15" width="850" height="30" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u34\_actor" value="Usuario Interno&\#xa;Autorizado" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="90" y="60" width="30" height="60" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u34\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="99" y="155" width="12" height="620" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u34\_ctrl\_box" value=":ControladorPedidos" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="400" y="60" width="165" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u34\_ctrl\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="482" y="800" as="sourcePoint" /\>

            \<mxPoint x="482" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u34\_ctrl\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="476" y="155" width="12" height="620" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u34\_repo\_box" value=":RepositorioPedidos" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="780" y="60" width="165" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u34\_repo\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="862" y="800" as="sourcePoint" /\>

            \<mxPoint x="862" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u34\_repo\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="856" y="200" width="12" height="120" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u34\_m1" value="1: pedidos \= buscarPedido(idPedido:Long\[0..1\], idCliente:Long\[0..1\], fechaReparto:LocalDate\[0..1\], estado:String\[0..1\], canalOrigen:String\[0..1\])" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="111" y="190" as="sourcePoint" /\>

            \<mxPoint x="476" y="190" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u34\_m2" value="2: lista \= consultarPedidosPorCriterios(filtro) \[Visibilidad por Atributo\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="488" y="235" as="sourcePoint" /\>

            \<mxPoint x="856" y="235" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u34\_r2" value="2.1: lista : List\&lt;Pedido\&gt;" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="856" y="295" as="sourcePoint" /\>

            \<mxPoint x="488" y="295" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u34\_alt" value="alt Resultado de la búsqueda de Pedidos \[UC-34\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=340;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="340" width="1150" height="380" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u34\_g1" value="\[lista.notEmpty()\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="125" y="365" width="300" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u34\_r1\_ok" value="3.1: muestra idPedido, Cliente, fechaHoraCarga, fechaReparto, canalOrigen (INTERNO\|ONLINE) y estado (PENDIENTE\|ENTREGADO\|CANCELADO); devuelve referencia al CU invocante" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="476" y="455" as="sourcePoint" /\>

            \<mxPoint x="111" y="455" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u34\_div" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="50" y="555" as="sourcePoint" /\>

            \<mxPoint x="1200" y="555" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u34\_g2" value="\[Sin coincidencias\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="125" y="565" width="300" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u34\_r1\_empty" value="3.2: informa ausencia de coincidencias sin modificar Pedidos" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="476" y="655" as="sourcePoint" /\>

            \<mxPoint x="111" y="655" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 2: DS UC-03 CARGAR PEDIDO (+ REPROGRAMACIÓN RD-RP020-001 / RD-F04) \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id="ds-rev04a-uc03" name="DS UC-03 Cargar Pedido (REV04A)"\>

    \<mxGraphModel dx="1650" dy="950" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1600" pageHeight="1300" math="0" shadow="0"\>

      \<root\>

        \<mxCell id="0" /\>

        \<mxCell id="1" parent="0" /\>

        \<mxCell id="u03\_title" value="Diagrama de Secuencia de Diseño (DS — REV04A) — UC-03: Cargar Pedido («include» UC-33, UC-35, UC-16→UC-15) \+ Reprogramación \[RD-F04 / RD-RP020-001\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="15" width="1420" height="30" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u03\_actor" value="Vendedor" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="85" y="60" width="30" height="60" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u03\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="94" y="155" width="12" height="1080" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u03\_ctrl\_box" value=":ControladorPedidos" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="340" y="60" width="165" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u03\_ctrl\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="422" y="1260" as="sourcePoint" /\>

            \<mxPoint x="422" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u03\_ctrl\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="416" y="155" width="12" height="1080" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u03\_repo\_box" value=":RepositorioPedidos" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="680" y="60" width="165" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u03\_repo\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="762" y="1260" as="sourcePoint" /\>

            \<mxPoint x="762" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u03\_repo\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="756" y="250" width="12" height="110" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u03\_ped\_box" value="nuevoPedido : Pedido&\#xa;+ DetallePedido \[1..\*\]" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1020" y="450" width="180" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u03\_ped\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1110" y="1260" as="sourcePoint" /\>

            \<mxPoint x="1110" y="495" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u03\_ped\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1104" y="495" width="12" height="630" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u03\_ref" value="ref «include» UC-33 Buscar Cliente (selecciona Cliente ACTIVO) \+ «include» UC-35 Buscar Producto (selecciona Productos activos con precio vigente)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=290;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="65" y="165" width="840" height="55" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u03\_m1" value="1: idPedido \= cargarPedido(idCliente:Long, fechaReparto:LocalDate, items:List\&lt;ItemPedidoDTO\&gt;, direccionEntrega:DireccionDTO, claveIdempotencia:UUID)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="106" y="255" as="sourcePoint" /\>

            \<mxPoint x="416" y="255" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u03\_m2" value="2: ctx \= validarClienteActivoFechaProductosYIdempotencia(idCliente, fechaReparto, items, claveIdempotencia) \[Atributo — RD-F04\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="428" y="295" as="sourcePoint" /\>

            \<mxPoint x="756" y="295" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u03\_alt" value="alt Validación en servidor de Cliente ACTIVO, precios vigentes e idempotencia \[UC-03 — RD-F04\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=610;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="380" width="1460" height="560" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u03\_g1" value="\[Cliente ACTIVO, fechaReparto válida, items con Producto activo y precioVigente \&gt; 0, y claveIdempotencia no registrada previamente\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="405" width="840" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u03\_m3\_new" value="3: «create» new(unCliente, fechaReparto, direccionEntrega, canalOrigen=INTERNO, estado=PENDIENTE, itemsConPrecioCongelado)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="428" y="472" as="sourcePoint" /\>

            \<mxPoint x="1020" y="472" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u03\_ref16" value="ref «include» UC-16 Aplicar Ajuste Comercial según Categoría («include» UC-15 Evaluar y Actualizar Categoría Comercial)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=280;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="380" y="555" width="760" height="60" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u03\_r1\_ok" value="3.1: persiste Pedido (INTERNO, PENDIENTE) y DetallePedido con precios y ajuste comercial congelados" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="416" y="685" as="sourcePoint" /\>

            \<mxPoint x="106" y="685" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u03\_div" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="50" y="750" as="sourcePoint" /\>

            \<mxPoint x="1510" y="750" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u03\_g2" value="\[Cliente INACTIVO, Producto inactivo/sin precio vigente, fecha inválida o claveIdempotencia ya sincronizada\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="760" width="720" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u03\_r1\_err" value="3.2: rechaza carga inválida o devuelve el Pedido ya sincronizado por idempotencia sin duplicarlo (RD-F04)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="416" y="865" as="sourcePoint" /\>

            \<mxPoint x="106" y="865" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<\!-- BLOQUE REPROGRAMACIÓN RD-RP020-001 (H-23) \--\>

        \<mxCell id="u03\_opt\_rp20" value="opt \[Reprogramación de fechaReparto de un Pedido PENDIENTE — RD-RP020-001 (H-23)\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=560;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="965" width="1460" height="235" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u03\_m4" value="4: ok \= reprogramarFechaRepartoPedido(idPedido:Long, nuevaFechaReparto:LocalDate, motivoReprogramacion:String)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="106" y="1025" as="sourcePoint" /\>

            \<mxPoint x="416" y="1025" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u03\_m5" value="5: actualizarFechaRegistrarHistorialEInvalidarAsignacionVigente(nuevaFechaReparto, motivoReprogramacion) \[Variable Local\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="428" y="1080" as="sourcePoint" /\>

            \<mxPoint x="1104" y="1080" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u03\_r4" value="5.1: actualiza fechaReparto, registra historial de cambio de fecha e INVALIDA la AsignacionReparto vigente (UC-43) y RutaReparto sugerida (UC-25)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="416" y="1160" as="sourcePoint" /\>

            \<mxPoint x="106" y="1160" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 3: DS UC-21 REALIZAR PEDIDO ONLINE (RD-RP001/RP019 Y RD-RP023-001) \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id="ds-rev04a-uc21" name="DS UC-21 Realizar Pedido Online (REV04A)"\>

    \<mxGraphModel dx="1650" dy="950" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1600" pageHeight="1200" math="0" shadow="0"\>

      \<root\>

        \<mxCell id="0" /\>

        \<mxCell id="1" parent="0" /\>

        \<mxCell id="u21\_title" value="Diagrama de Secuencia de Diseño (DS — REV04A) — UC-21: Realizar Pedido Online \[RD-RP001/RP019 y RD-RP023-001\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="15" width="1280" height="30" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u21\_actor" value="Cliente Online" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="85" y="60" width="30" height="60" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u21\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="94" y="155" width="12" height="960" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u21\_ctrl\_box" value=":ControladorPedidos" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="340" y="60" width="165" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u21\_ctrl\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="422" y="1140" as="sourcePoint" /\>

            \<mxPoint x="422" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u21\_ctrl\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="416" y="155" width="12" height="960" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u21\_repo\_box" value=":RepositorioPedidos /&\#xa;:CatalogoPromociones" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="680" y="60" width="180" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u21\_repo\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="770" y="1140" as="sourcePoint" /\>

            \<mxPoint x="770" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u21\_repo\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="764" y="210" width="12" height="140" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u21\_ped\_box" value="pedidoOnline : Pedido&\#xa;+ DetallePedido \[1..\*\]" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1040" y="450" width="180" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u21\_ped\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1130" y="1140" as="sourcePoint" /\>

            \<mxPoint x="1130" y="495" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u21\_ped\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1124" y="495" width="12" height="240" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u21\_m1" value="1: comprobante \= realizarPedidoOnline(idDesafioVerificado:UUID, items:List\&lt;ItemPedidoDTO\&gt;, direccionEntrega:DireccionDTO, fechaReparto:LocalDate)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="106" y="190" as="sourcePoint" /\>

            \<mxPoint x="416" y="190" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u21\_m2" value="2: val \= validarClienteActivoFechaRepartoHabilitadaYMejorPromocion(idDesafioVerificado, fechaReparto, items) \[Atributo — RD-RP001 / RD-RP023-001\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="428" y="240" as="sourcePoint" /\>

            \<mxPoint x="764" y="240" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u21\_r2" value="2.1: (unCliente:Cliente, fechaRepartoHabilitadaOk:Boolean, mejorPromocionSinAcumulacionPorItem:Map\&lt;Long,BigDecimal\&gt;)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="764" y="310" as="sourcePoint" /\>

            \<mxPoint x="428" y="310" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u21\_alt" value="alt Validación de fechaReparto habilitada en servidor y acreditación de pago electrónico \[UC-21 — RD-RP001 / RD-RP023-001\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=750;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="370" width="1460" height="700" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u21\_g1" value="\[Cliente ACTIVO con desafío OTP verificado y fechaRepartoHabilitadaOk \== true\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="395" width="660" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u21\_m3\_new" value="3: «create» new(unCliente, fechaReparto, direccionEntrega, canalOrigen=ONLINE, estado=PENDIENTE, itemsConMejorDescuentoPromocionalCongeladoSinAcumular)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="428" y="472" as="sourcePoint" /\>

            \<mxPoint x="1040" y="472" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u21\_ref16" value="ref «include» UC-16 Aplicar Ajuste Comercial según Categoría («include» UC-15) — Aplicado sobre el subtotal resultante luego del mejor descuento promocional" style="shape=umlFrame;whiteSpace=wrap;html=1;width=290;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="380" y="555" width="820" height="60" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u21\_ref29" value="ref «include» UC-29 Registrar Cobro (procesa cobro electrónico vía MercadoPago con estadoCobro \= CONFIRMADO y reevalúa UC-15)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=280;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="380" y="635" width="820" height="60" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u21\_r1\_ok" value="3.1: \[Pago electrónico CONFIRMADO\] persiste Pedido ONLINE (PENDIENTE) y DetallePedido con mejor Promoción y ajuste congelados" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="416" y="755" as="sourcePoint" /\>

            \<mxPoint x="106" y="755" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u21\_div1" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="50" y="810" as="sourcePoint" /\>

            \<mxPoint x="1510" y="810" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u21\_g2" value="\[RD-RP001/RP019: fechaRepartoHabilitadaOk \== false (fecha no habilitada o cerrada en el servidor)\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="820" width="680" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u21\_r1\_fch" value="3.2: rechaza la fecha seleccionada y devuelve la lista actualizada de fechas de reparto habilitadas sin iniciar pago" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="416" y="895" as="sourcePoint" /\>

            \<mxPoint x="106" y="895" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u21\_div2" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="50" y="940" as="sourcePoint" /\>

            \<mxPoint x="1510" y="940" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u21\_g3" value="\[Pago electrónico rechazado o fallo en MercadoPago\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="950" width="480" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u21\_r1\_err" value="3.3: no confirma el Pedido ni registra Cobro, Caja ni Cuenta Corriente" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="416" y="1030" as="sourcePoint" /\>

            \<mxPoint x="106" y="1030" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 4: DS UC-43 ASIGNAR Y REASIGNAR PEDIDOS (6 REGLAS RD-RP002-001)    \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id="ds-rev04a-uc43" name="DS UC-43 Asignar Reasignar Pedidos (REV04A)"\>

    \<mxGraphModel dx="1600" dy="900" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1550" pageHeight="1050" math="0" shadow="0"\>

      \<root\>

        \<mxCell id="0" /\>

        \<mxCell id="1" parent="0" /\>

        \<mxCell id="u43\_title" value="Diagrama de Secuencia de Diseño (DS — REV04A) — UC-43: Asignar y Reasignar Pedidos a Repartidores («include» UC-34) \[RD-RP002-001\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="15" width="1280" height="30" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u43\_actor" value="Vendedor" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="85" y="60" width="30" height="60" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u43\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="94" y="155" width="12" height="820" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u43\_ctrl\_box" value=":ControladorReparto" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="350" y="60" width="165" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u43\_ctrl\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="432" y="1000" as="sourcePoint" /\>

            \<mxPoint x="432" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u43\_ctrl\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="426" y="155" width="12" height="820" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u43\_repo\_box" value=":RepositorioPedidos /&\#xa;:CatalogoUsuarios" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="680" y="60" width="175" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u43\_repo\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="767" y="1000" as="sourcePoint" /\>

            \<mxPoint x="767" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u43\_repo\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="761" y="290" width="12" height="100" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u43\_asig\_box" value="nuevaAsig :&\#xa;AsignacionReparto" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1080" y="520" width="175" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u43\_asig\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1167" y="1000" as="sourcePoint" /\>

            \<mxPoint x="1167" y="565" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u43\_asig\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1161" y="565" width="12" height="80" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u43\_ref34" value="ref «include» UC-34 Buscar Pedido (selecciona unPedido PENDIENTE de canal INTERNO u ONLINE y recupera su asignación vigente)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=280;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="65" y="165" width="760" height="55" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u43\_m1" value="1: idAsignacion \= asignarOReasignarPedidoARepartidor(idPedido:Long, idUsuarioRepartidor:Long, motivoReasignacion:String\[0..1\])" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="106" y="265" as="sourcePoint" /\>

            \<mxPoint x="426" y="265" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u43\_m2" value="2: val \= revalidarReglasAsignacionOnline(idPedido, idUsuarioRepartidor, motivoReasignacion) \[Atributo — 6 reglas RD-RP002-001\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="438" y="315" as="sourcePoint" /\>

            \<mxPoint x="761" y="315" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u43\_r2" value="2.1: (esOnline:Boolean, pedidoPendiente:Boolean, repCuentaHabilitadaConRolRepartidor:Boolean, cambioRealConMotivoSiReasigna:Boolean)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="761" y="375" as="sourcePoint" /\>

            \<mxPoint x="438" y="375" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u43\_alt" value="alt Cumplimiento de las 6 reglas obligatorias de Asignación/Reasignación \[UC-43 — RD-RP002-001\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=640;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="425" width="1410" height="495" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u43\_g1" value="\[esOnline \== true, pedidoPendiente \== true, repCuentaHabilitadaConRolRepartidor \== true y cambioRealConMotivoSiReasigna \== true\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="450" width="840" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u43\_m3\_new" value="3: «create» new(unPedido, repElegido, fechaHoraInicio, fechaHoraFin=null, motivoReasignacion\[0..1\]) \[Cierra previa e invalida RutaReparto\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="438" y="542" as="sourcePoint" /\>

            \<mxPoint x="1080" y="542" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u43\_r1\_ok" value="3.1: confirma única AsignacionReparto vigente para el Pedido sin alterar estado comercial, precios ni inventario" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="426" y="685" as="sourcePoint" /\>

            \<mxPoint x="106" y="685" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u43\_div" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="50" y="745" as="sourcePoint" /\>

            \<mxPoint x="1460" y="745" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u43\_g2" value="\[Modo offline, Pedido ENTREGADO/CANCELADO, Repartidor DESHABILITADO o sin Rol REPARTIDOR, mismo Repartidor, falta motivo o conflicto concurrente\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="755" width="900" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u43\_r1\_err" value="3.2: rechaza la operación y conserva intacta la asignación anterior" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="426" y="855" as="sourcePoint" /\>

            \<mxPoint x="106" y="855" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 5: DS UC-04 CONSULTAR PEDIDOS ASIGNADOS                            \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id="ds-rev04a-uc04" name="DS UC-04 Consultar Pedidos Asignados (REV04A)"\>

    \<mxGraphModel dx="1450" dy="800" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1400" pageHeight="850" math="0" shadow="0"\>

      \<root\>

        \<mxCell id="0" /\>

        \<mxCell id="1" parent="0" /\>

        \<mxCell id="u04\_title" value="Diagrama de Secuencia de Diseño (DS — REV04A) — UC-04: Consultar Pedidos Asignados" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="15" width="900" height="30" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u04\_actor" value="Repartidor" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="90" y="60" width="30" height="60" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u04\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="99" y="155" width="12" height="620" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u04\_ctrl\_box" value=":ControladorReparto" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="380" y="60" width="165" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u04\_ctrl\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="462" y="800" as="sourcePoint" /\>

            \<mxPoint x="462" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u04\_ctrl\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="456" y="155" width="12" height="620" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u04\_repo\_box" value=":RepositorioPedidos" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="760" y="60" width="165" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u04\_repo\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="842" y="800" as="sourcePoint" /\>

            \<mxPoint x="842" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u04\_repo\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="836" y="200" width="12" height="140" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u04\_m1" value="1: pedidosAsignados \= consultarPedidosAsignados()" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="111" y="190" as="sourcePoint" /\>

            \<mxPoint x="456" y="190" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u04\_m2" value="2: obtenerPedidosPendientesConAsignacionVigente(idRepartidorAutenticado:Long) \[Atributo \+ Parámetro\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="468" y="235" as="sourcePoint" /\>

            \<mxPoint x="836" y="235" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u04\_r2" value="2.1: List\&lt;Pedido\&gt; (exclusivamente PENDIENTE con AsignacionReparto vigente al Repartidor)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="836" y="305" as="sourcePoint" /\>

            \<mxPoint x="468" y="305" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u04\_alt" value="alt Resultado de consulta de Pedidos asignados \[UC-04\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=380;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="360" width="1150" height="360" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u04\_g1" value="\[Existen Pedidos PENDIENTE con asignación vigente al Repartidor autenticado\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="125" y="385" width="560" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u04\_r1\_ok" value="3.1: muestra Cliente, fecha, dirección y Detalles con cantidades originales y adicionales aceptadas en UC-07 (sin exponer Pedidos ajenos ni alterar asignaciones)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="456" y="465" as="sourcePoint" /\>

            \<mxPoint x="111" y="465" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u04\_div" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="50" y="555" as="sourcePoint" /\>

            \<mxPoint x="1200" y="555" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u04\_g2" value="\[Sin asignaciones vigentes\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="125" y="565" width="300" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u04\_r1\_empty" value="3.2: informa lista vacía en modo solo lectura" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="456" y="655" as="sourcePoint" /\>

            \<mxPoint x="111" y="655" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 6: DS UC-25 GENERAR RUTA SUGERIDA DE REPARTO                       \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id="ds-rev04a-uc25" name="DS UC-25 Generar Ruta Sugerida (REV04A)"\>

    \<mxGraphModel dx="1600" dy="900" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1550" pageHeight="1050" math="0" shadow="0"\>

      \<root\>

        \<mxCell id="0" /\>

        \<mxCell id="1" parent="0" /\>

        \<mxCell id="u25\_title" value="Diagrama de Secuencia de Diseño (DS — REV04A) — UC-25: Generar Ruta Sugerida de Reparto" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="15" width="950" height="30" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u25\_actor" value="Repartidor" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="85" y="60" width="30" height="60" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u25\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="94" y="155" width="12" height="820" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u25\_ctrl\_box" value=":ControladorReparto" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="350" y="60" width="165" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u25\_ctrl\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="432" y="1000" as="sourcePoint" /\>

            \<mxPoint x="432" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u25\_ctrl\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="426" y="155" width="12" height="820" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u25\_repo\_box" value=":RepositorioPedidos" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="660" y="60" width="165" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u25\_repo\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="742" y="1000" as="sourcePoint" /\>

            \<mxPoint x="742" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u25\_repo\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="736" y="200" width="12" height="90" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u25\_adp\_box" value=":AdaptadorRuteo&\#xa;(:ServicioDeRuteo)" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="960" y="60" width="175" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u25\_adp\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1047" y="1000" as="sourcePoint" /\>

            \<mxPoint x="1047" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u25\_adp\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1041" y="340" width="12" height="100" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u25\_rut\_box" value="unaRuta : RutaReparto" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1260" y="540" width="170" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u25\_rut\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1345" y="1000" as="sourcePoint" /\>

            \<mxPoint x="1345" y="585" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u25\_rut\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1339" y="585" width="12" height="80" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u25\_m1" value="1: rutaSugerida \= generarRutaSugeridaReparto(fechaReparto:LocalDate)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="106" y="185" as="sourcePoint" /\>

            \<mxPoint x="426" y="185" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u25\_m2" value="2: entregasPendientes \= obtenerPendientesAsignadosPorFecha(idRepartidor, fechaReparto) \[Atributo\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="438" y="225" as="sourcePoint" /\>

            \<mxPoint x="736" y="225" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u25\_m3" value="3: respRuteo \= solicitarSecuenciaVisita(ubicacionesValidas:List\&lt;UbicacionDTO\&gt;) \[Atributo \+ Parámetro\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="438" y="365" as="sourcePoint" /\>

            \<mxPoint x="1041" y="365" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u25\_r3" value="3.1: respRuteo (ordenSugerido \| errorServicio)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1041" y="420" as="sourcePoint" /\>

            \<mxPoint x="438" y="420" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u25\_alt" value="alt Validación de ubicaciones y respuesta del Servicio de Ruteo \[UC-25\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=480;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="465" width="1440" height="450" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u25\_g1" value="\[Ubicaciones completas y respRuteo consistente con el conjunto enviado\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="490" width="560" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u25\_m4\_new" value="4: «create» new(idRepartidor, fechaReparto, fechaHoraGeneracion, secuenciaSugerida)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="438" y="562" as="sourcePoint" /\>

            \<mxPoint x="1260" y="562" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u25\_r1\_ok" value="4.1: presenta entregas ordenadas según secuencia sugerida sin modificar el estado de ningún Pedido" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="426" y="685" as="sourcePoint" /\>

            \<mxPoint x="106" y="685" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u25\_div" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="50" y="745" as="sourcePoint" /\>

            \<mxPoint x="1490" y="745" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u25\_g2" value="\[Sin Pedidos PENDIENTE asignados, ubicación insuficiente o Servicio de Ruteo no disponible/inconsistente\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="755" width="700" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u25\_r1\_err" value="4.2: informa la contingencia o ausencia de entregas y presenta el listado pendiente sin secuencia optimizada" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="426" y="850" as="sourcePoint" /\>

            \<mxPoint x="106" y="850" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

\</mxfile\>

### **Archivo 4: `docs/08-diagramas/revision/CONTRATOS_REV04A_PEDIDOS_REPARTO_7_OPERACIONES.md`**

Este archivo contiene los **7 Contratos individuales desagrupados** (`UC-34`, `UC-03`, `reprogramarFechaRepartoPedido` por `RD-RP020-001`, `UC-21`, `UC-43`, `UC-04`, `UC-25`) con las **9 secciones estándar**, firmas 100% homologadas y aplicación estricta de `RD-RP001/RP019` (`H-05`), `RD-RP023-001` (`H-06`), `RD-F04` (`H-09`), `RD-RP002-001` (`H-21`) y `RD-RP020-001` (`H-23`):

\# Contratos de Operación del Sistema (DSS — REV-04A) — Pedidos, Canal Online, Asignación y Ruteo (7 Contratos Individuales)

\*\*Proyecto:\*\* Sistema de Gestión para Ale Milanesas (UNaM-FCEQyN)  

\*\*Lote de revisión:\*\* \`REV-04A\` (\`UC-34\`, \`UC-03\`, \`UC-21\`, \`UC-43\`, \`UC-04\`, \`UC-25\` \+ operación de reprogramación \`RD-RP020-001\`)  

\*\*Decisiones incorporadas:\*\* \`RD-RP001/RP019\` (\`H-05\`: selección y validación en servidor de \`fechaReparto\` habilitada en \`UC-21\`), \`RD-RP023-001\` (\`H-06\`: mejor beneficio aplicable sin acumulación de promociones simultáneas), \`RD-RP002-001\` (\`H-21\`: 6 reglas obligatorias en \`UC-43\`), \`RD-F04-001..007\` (\`H-09\`: validación idempotente en servidor para carga offline en \`UC-03\`) y \`RD-RP020-001\` (\`H-23\`: reprogramación de Pedido pendiente con invalidación de asignación \`UC-43\`).

\---

\#\# 1\. Contrato de la Operación \`buscarPedido\` (\`UC-34\`)

1\. \*\*Nombre:\*\* \`buscarPedido(idPedido: Long\[0..1\], idCliente: Long\[0..1\], fechaReparto: LocalDate\[0..1\], estado: String\[0..1\], canalOrigen: String\[0..1\])\`

2\. \*\*Responsabilidades:\*\* Localizar y presentar en modo solo lectura los \`Pedido\` registrados que cumplan los criterios indicados y devolver el \`Pedido\` seleccionado al caso de uso invocante.

3\. \*\*Tipo:\*\* \`Sistema\`

4\. \*\*Referencias cruzadas:\*\* Caso de Uso \`UC-34 — Buscar Pedido\`; incluido por \`UC-05 — Registrar Entrega\`, \`UC-06 — Cancelar Pedido\`, \`UC-28 — Registrar Preparación de Pedido\` y \`UC-43 — Asignar y Reasignar Pedidos a Repartidores\`; Objetivo \`OBJE-01\`; Requisito \`RF-01\`.

5\. \*\*Notas:\*\* Operación estrictamente de solo lectura. No modifica el estado ni el contenido de ningún Pedido.

6\. \*\*Excepciones:\*\*

   \* \*\*A1 — Sin coincidencias:\*\* Informar que no existen Pedidos que cumplan los criterios ingresados.

   \* \*\*A2 — Criterios con formato inválido:\*\* Solicitar corrección sin ejecutar la consulta.

7\. \*\*Salida:\*\*

   \* Listado de \`Pedido\` coincidentes (\`idPedido\`, \`Cliente\`, \`fechaHoraCarga\`, \`fechaReparto\`, \`canalOrigen\` \`INTERNO\` \| \`ONLINE\`, \`estado\` \`PENDIENTE\` \| \`ENTREGADO\` \| \`CANCELADO\`) y referencia del \`Pedido\` seleccionado; o mensajes de las excepciones A1–A2.

8\. \*\*Precondiciones:\*\*

   \* El actor interno se encuentra autenticado y autorizado.

9\. \*\*Postcondiciones:\*\*

   \* \*(Sin cambios de estado en el sistema: no se crean ni modifican instancias de \`Pedido\` ni \`AsignacionReparto\`)\*.

\---

\#\# 2\. Contrato de la Operación \`cargarPedido\` (\`UC-03\` «include» \`UC-33\`, \`UC-35\`, \`UC-16\`→\`UC-15\`)

1\. \*\*Nombre:\*\* \`cargarPedido(idCliente: Long, fechaReparto: LocalDate, items: List\<ItemPedidoDTO\>, direccionEntrega: DireccionDTO, claveIdempotencia: UUID)\`

2\. \*\*Responsabilidades:\*\* Registrar de manera unificada e idempotente un nuevo \`Pedido\` multiproducto de \`canalOrigen \= INTERNO\` en estado \`PENDIENTE\` para un \`Cliente\` \`ACTIVO\` (localizado mediante \`UC-33\`), incorporando \`Producto\` activos (\`UC-35\`), congelando los precios unitarios vigentes y el ajuste comercial según la categoría evaluada del Cliente (\`UC-16\` incluyendo \`UC-15\`), y admitiendo su sincronización validada por el servidor cuando se originó en modo offline (\`RD-F04\`).

3\. \*\*Tipo:\*\* \`Sistema\`

4\. \*\*Referencias cruzadas:\*\* Caso de Uso \`UC-03 — Cargar Pedido\`; incluye \`UC-33 — Buscar Cliente\`, \`UC-35 — Buscar Producto\`, \`UC-16 — Aplicar Ajuste Comercial según Categoría\` y \`UC-15 — Evaluar y Actualizar Categoría Comercial\`; Decisión \`RD-F04-001..007\`; Objetivos \`OBJE-01\`, \`OBJE-02\`, \`OBJE-04\`, \`OBJE-11\`; Requisitos \`RF-01\`, \`RF-09\`, \`RF-12\`.

5\. \*\*Notas:\*\* Conforme a \`RD-F04\`, si el Vendedor opera sin conectividad, la operación se captura localmente con su snapshot comercial y \`claveIdempotencia\`; al recuperar conectividad, el servidor valida y reconcilia idempotentemente el registro sin duplicar el Pedido.

6\. \*\*Excepciones:\*\*

   \* \*\*A1 — \`Cliente\` no localizado o en estado \`INACTIVO\`:\*\* No permitir confirmar un Pedido nuevo para ese Cliente.

   \* \*\*A2 — \`fechaReparto\` inválida:\*\* Solicitar corrección.

   \* \*\*A3 — Ningún ítem informado, \`Producto\` inexistente/inactivo (\`activo \= false\`), sin \`PrecioProducto\` vigente o \`cantidadSolicitada \<= 0\`:\*\* No incorporar el detalle ni confirmar el Pedido.

   \* \*\*A4 — Categoría comercial o \`PoliticaCategoriaComercial\` no determinable:\*\* Aplicar las excepciones de \`UC-15\`/\`UC-16\` sin inventar porcentajes.

   \* \*\*A5 — \`claveIdempotencia\` ya procesada en sincronización previa (\`RD-F04\`):\*\* Reconocer el \`Pedido\` existente sin crear un duplicado.

7\. \*\*Salida:\*\*

   \* Confirmación del \`Pedido\` registrado (\`idPedido\`, \`canalOrigen \= INTERNO\`, \`estado \= PENDIENTE\`, \`categoriaComercialAplicada\`, \`tipoAjuste\`, \`porcentajeAjuste\`, \`totalOriginal\`), o mensajes provocados por las excepciones A1–A5.

8\. \*\*Precondiciones:\*\*

   \* El \`Vendedor\` se encuentra autenticado y autorizado.

   \* El \`Cliente\` seleccionado mediante \`UC-33\` se encuentra \`ACTIVO\`, los \`Producto\` seleccionados mediante \`UC-35\` están activos con precio vigente y existe \`PoliticaCategoriaComercial\` vigente.

9\. \*\*Postcondiciones:\*\*

   \* Se ejecutaron las postcondiciones de \`UC-15\` (evaluación/actualización de \`Cliente.categoriaComercial\`) y \`UC-16\` (determinación del ajuste según \`PoliticaCategoriaComercial\` vigente).

   \* Se creó una única instancia \`nuevoPedido\` de \`Pedido\` con \`canalOrigen \= INTERNO\`, \`estado \= PENDIENTE\`, \`fechaHoraCarga\`, \`fechaReparto\`, \`direccionEntrega\` congelada, \`categoriaComercialAplicada\`, \`tipoAjuste\`, \`porcentajeAjuste\` y \`totalOriginal\`.

   \* Se asoció \`nuevoPedido\` con el \`Cliente\`, con el \`Usuario\` Vendedor y con la \`PoliticaCategoriaComercial\` aplicada.

   \* Para cada elemento en \`items\`, se creó una instancia de \`DetallePedido\` asociada a \`nuevoPedido\` y al \`Producto\`, con \`cantidadSolicitada\` original, \`codigoUnidadVenta\` y \`precioUnitario\` congelado.

\---

\#\# 3\. Contrato de la Operación \`reprogramarFechaRepartoPedido\` (\`UC-03\` / \`RD-RP020-001\`)

1\. \*\*Nombre:\*\* \`reprogramarFechaRepartoPedido(idPedido: Long, nuevaFechaReparto: LocalDate, motivoReprogramacion: String)\`

2\. \*\*Responsabilidades:\*\* Modificar la \`fechaReparto\` de un \`Pedido\` que se encuentra en estado \`PENDIENTE\`, registrando el historial de cambio de fecha con su motivo obligatorio e \*\*invalidando automáticamente cualquier \`AsignacionReparto\` vigente (\`UC-43\`) y cualquier \`RutaReparto\` sugerida previa (\`UC-25\`)\*\* (\`RD-RP020-001\`).

3\. \*\*Tipo:\*\* \`Sistema\`

4\. \*\*Referencias cruzadas:\*\* Caso de Uso \`UC-03 — Cargar Pedido\`; Caso de Uso \`UC-34 — Buscar Pedido\`; Caso de Uso \`UC-43 — Asignar y Reasignar Pedidos a Repartidores\`; Caso de Uso \`UC-25 — Generar Ruta Sugerida de Reparto\`; Decisión \`RD-RP020-001\` (\`H-23\`); Objetivo \`OBJE-01\`; Requisito \`RF-01\`.

5\. \*\*Notas:\*\* Esta operación resuelve la reprogramación de un Pedido pendiente dentro del ciclo de gestión del Pedido sin crear un caso de uso adicional fuera de los 64 canónicos (\`RD-RP020-001\`). No altera los precios, promociones ni el ajuste comercial congelados originalmente.

6\. \*\*Excepciones:\*\*

   \* \*\*A1 — \`Pedido\` inexistente o en estado \`ENTREGADO\` o \`CANCELADO\`:\*\* Impedir la reprogramación.

   \* \*\*A2 — \`nuevaFechaReparto\` inválida o igual a la \`Pedido.fechaReparto\` actual:\*\* Solicitar una fecha válida distinta o informar ausencia de cambio.

   \* \*\*A3 — \`motivoReprogramacion\` ausente o vacío:\*\* Exigir el motivo obligatorio antes de confirmar.

7\. \*\*Salida:\*\*

   \* Confirmación de la \`nuevaFechaReparto\` vigente del \`Pedido\` y aviso de que la asignación de Repartidor previa (si existía) quedó invalidada y requiere nueva asignación en \`UC-43\`; o mensajes de las excepciones A1–A3.

8\. \*\*Precondiciones:\*\*

   \* El actor autorizado (\`Vendedor\` o \`Administrador\`) se encuentra autenticado y el \`Pedido\` identificado por \`idPedido\` se encuentra en estado \`PENDIENTE\`.

9\. \*\*Postcondiciones:\*\*

   \* Se registró en el historial de fechas del \`Pedido\` la \`fechaRepartoAnterior\`, la \`nuevaFechaReparto\`, la fecha/hora del cambio, el \`motivoReprogramacion\` y el \`Usuario\` responsable (\`RD-RP020-001\`).

   \* Se modificó el atributo \`unPedido.fechaReparto\` al valor \`nuevaFechaReparto\` (conservando inalterados \`unPedido.estado \= PENDIENTE\`, sus \`DetallePedido\` y \`unPedido.totalOriginal\`).

   \* Si existía una instancia vigente de \`AsignacionReparto\` asociada a \`unPedido\`, se cerró su vigencia (\`fechaHoraFin \= fechaHoraActual\`), quedando \`unPedido\` sin Repartidor asignado hasta una nueva ejecución de \`UC-43\` e invalidando las \`RutaReparto\` sugeridas que lo incluían.

\---

\#\# 4\. Contrato de la Operación \`realizarPedidoOnline\` (\`UC-21\` «include» \`UC-16\`→\`UC-15\`, \`UC-29\`)

1\. \*\*Nombre:\*\* \`realizarPedidoOnline(idDesafioVerificado: UUID, items: List\<ItemPedidoDTO\>, direccionEntrega: DireccionDTO, fechaReparto: LocalDate)\`

2\. \*\*Responsabilidades:\*\* Validar en el servidor que el \`Cliente\` \`ACTIVO\` posea un desafío temporal verificado y que la \`fechaReparto\` elegida pertenezca a las \*\*fechas de reparto habilitadas (\`RD-RP001/RP019\`)\*\*, aplicar y congelar por cada Producto el \*\*mejor beneficio promocional elegible sin acumular descuentos sobre las mismas unidades (\`RD-RP023-001\`)\*\*, aplicar luego el ajuste comercial por categoría (\`UC-16\` incluyendo \`UC-15\`), procesar el cobro electrónico en \`MercadoPago\` (\`UC-29\`) y, únicamente ante su confirmación, registrar el \`Pedido\` con \`canalOrigen \= ONLINE\` y \`estado \= PENDIENTE\`.

3\. \*\*Tipo:\*\* \`Sistema\`

4\. \*\*Referencias cruzadas:\*\* Caso de Uso \`UC-21 — Realizar Pedido Online\`; incluye \`UC-16 — Aplicar Ajuste Comercial según Categoría\`, \`UC-15 — Evaluar y Actualizar Categoría Comercial\` y \`UC-29 — Registrar Cobro\`; Decisiones \`RD-RP001/RP019\` (\`H-05\`) y \`RD-RP023-001\` (\`H-06\`); Objetivos \`OBJE-01\`, \`OBJE-10\`, \`OBJE-11\`, \`OBJE-13\`, \`OBJE-16\`; Requisitos \`RF-01\`, \`RF-06\`, \`RF-10\`, \`RF-12\`, \`RF-15\`, \`RF-16\`, \`RF-20\`.

5\. \*\*Notas:\*\*

   \* Conforme a \`RD-RP001/RP019\`, la \`fechaReparto\` debe seleccionarse entre las opciones habilitadas y es revalidada por el servidor antes de iniciar el cobro.

   \* Conforme a \`RD-RP023-001\`, si un mismo Producto y Cliente destinatario están alcanzados por más de una \`Promocion\` \`ACTIVA\` simultánea, \*\*nunca se suman ni acumulan porcentajes de descuento sobre las mismas unidades\*\*: el sistema selecciona automáticamente la promoción elegible que otorgue el mayor beneficio y la congela en el detalle, aplicando después sobre el subtotal resultante el ajuste por categoría comercial (\`UC-16\` → \`UC-15\`).

6\. \*\*Excepciones:\*\*

   \* \*\*A1 — Desafío temporal no verificado, expirado o \`Cliente\` no \`ACTIVO\` o con teléfono ambiguo:\*\* Bloquear la confirmación del Pedido online.

   \* \*\*A2 (\`RD-RP001/RP019\`) — La \`fechaReparto\` seleccionada no pertenece a las fechas habilitadas o perdió disponibilidad en el servidor:\*\* Rechazar la fecha e informar las fechas de reparto habilitadas actualizadas sin iniciar el cobro.

   \* \*\*A3 — Ningún ítem seleccionado, \`Producto\` inactivo, sin precio vigente o cantidad \`\<= 0\`:\*\* Solicitar corrección antes de iniciar el pago.

   \* \*\*A4 — Pago electrónico rechazado, cancelado o fallo de comunicación con \`MercadoPago\`:\*\* No confirmar el \`Pedido\` ni registrar \`Cobro\`, \`MovimientoCuenta\` ni \`MovimientoCaja\`.

7\. \*\*Salida:\*\*

   \* Comprobante del \`Pedido\` online confirmado (\`idPedido\`, \`idCobro\`, \`fechaReparto\` validada, mejor promoción aplicada por ítem sin acumulación, ajuste por categoría comercial y \`totalOriginal\` congelado); o mensajes de las excepciones A1–A4.

8\. \*\*Precondiciones:\*\*

   \* El \`Cliente\` preexistente se encuentra en estado \`ACTIVO\` y superó la verificación del código temporal (\`idDesafioVerificado\`).

   \* Existen fechas de reparto habilitadas, Productos activos con precio vigente y una \`PoliticaCategoriaComercial\` vigente.

9\. \*\*Postcondiciones:\*\*

   \* El servidor validó que \`fechaReparto\` pertenece al conjunto vigente de fechas de reparto habilitadas (\`RD-RP001/RP019\`).

   \* Para cada ítem alcanzado por una o más \`Promocion\` vigentes para ese \`Cliente\`, se seleccionó sin acumulación la \`Promocion\` de mayor descuento elegible (\`RD-RP023-001\`).

   \* Se ejecutaron las postcondiciones de \`UC-15\` y \`UC-16\` sobre el subtotal resultante tras aplicar el descuento promocional.

   \* Se ejecutaron atómicamente las postcondiciones de \`UC-29\` tras la acreditación de \`MercadoPago\`: creación de \`Cobro\` (\`origen \= ONLINE\`, \`estadoCobro \= CONFIRMADO\`), creación de \`MovimientoCuenta\` (\`PAGO\`), creación de \`MovimientoCaja\` (\`INGRESO\`) y reevaluación de \`UC-15\`.

   \* Se creó una instancia \`pedidoOnline\` de \`Pedido\` con \`canalOrigen \= ONLINE\`, \`estado \= PENDIENTE\`, \`fechaReparto\`, \`direccionEntrega\`, ajuste comercial y \`totalOriginal\` congelados, junto con sus instancias de \`DetallePedido\` (con \`precioUnitario\` y descuento promocional congelados).

\---

\#\# 5\. Contrato de la Operación \`asignarOReasignarPedidoARepartidor\` (\`UC-43\` «include» \`UC-34\`)

1\. \*\*Nombre:\*\* \`asignarOReasignarPedidoARepartidor(idPedido: Long, idUsuarioRepartidor: Long, motivoReasignacion: String\[0..1\])\`

2\. \*\*Responsabilidades:\*\* Registrar en modo \*\*exclusivamente online\*\* la asignación inicial de un \`Pedido\` \`PENDIENTE\` (localizado mediante \`UC-34\`) a un Repartidor elegible, o sustituir su asignación vigente antes de la Entrega registrando el motivo obligatorio y preservando la unicidad transaccional y la trazabilidad histórica (\`RD-RP002-001\`).

3\. \*\*Tipo:\*\* \`Sistema\`

4\. \*\*Referencias cruzadas:\*\* Caso de Uso \`UC-43 — Asignar y Reasignar Pedidos a Repartidores\`; incluye \`UC-34 — Buscar Pedido\`; Decisión \`RD-RP002-001\` (\`H-21\`); Objetivos \`OBJE-01\`, \`OBJE-06\`; Requisitos \`RF-01\`, \`RF-17\`.

5\. \*\*Notas:\*\* Conforme a \`RD-RP002-001\`, rigen \*\*6 reglas obligatorias\*\*: (1) \`Pedido.estado \== PENDIENTE\` (canal \`INTERNO\` u \`ONLINE\`), (2) el Repartidor tiene cuenta \`Usuario.estado \== HABILITADO\`, (3) el Repartidor posee Rol vigente \`REPARTIDOR\`, (4) existe a lo sumo una única \`AsignacionReparto\` vigente por \`Pedido\` en todo instante, (5) la operación se ejecuta \*\*exclusivamente online\*\* (prohibida en modo offline), y (6) toda reasignación exige \`motivoReasignacion\` obligatorio y control de concurrencia. Una reasignación invalida cualquier \`RutaReparto\` sugerida previamente generada para esa fecha (\`UC-25\`).

6\. \*\*Excepciones:\*\*

   \* \*\*A1 — Intento de ejecutar la asignación/reasignación en modo offline (\`RD-RP002-001\`):\*\* Rechazar la operación e exigir conectividad con el servidor.

   \* \*\*A2 — \`Pedido\` en estado \`ENTREGADO\` o \`CANCELADO\`:\*\* Impedir asignarlo o reasignarlo.

   \* \*\*A3 — El \`Usuario\` seleccionado no está en estado \`HABILITADO\` o no posee el Rol vigente \`REPARTIDOR\` (\`RD-RP002-001\`):\*\* Rechazar la selección.

   \* \*\*A4 — Se selecciona el mismo Repartidor que ya posee la asignación vigente:\*\* Informar que no hay cambio real y no registrar reasignación redundante.

   \* \*\*A5 — El Pedido ya poseía asignación vigente y no se informó \`motivoReasignacion\`:\*\* Rechazar la confirmación hasta completar el motivo obligatorio.

   \* \*\*A6 — Conflicto de concurrencia (el Pedido o su asignación cambiaron durante la operación):\*\* Detener la confirmación y solicitar revisar la información actualizada.

7\. \*\*Salida:\*\*

   \* Confirmación de la \`AsignacionReparto\` vigente registrada (\`idAsignacion\`) para el \`Pedido\` y el \`Repartidor\` elegido; o mensajes provocados por las excepciones A1–A6.

8\. \*\*Precondiciones:\*\*

   \* El \`Vendedor\` se encuentra autenticado y operando \*\*online\*\* contra el servidor (\`RD-RP002-001\`).

   \* El \`Pedido\` seleccionado mediante \`UC-34\` está en estado \`PENDIENTE\` y el \`Usuario\` elegido está \`HABILITADO\` con Rol \`REPARTIDOR\`.

9\. \*\*Postcondiciones:\*\*

   \* Si existía una instancia previa de \`AsignacionReparto\` vigente para el \`Pedido\`, se modificó su atributo \`fechaHoraFin\` con la marca temporal actual, cerrando su vigencia sin eliminarla del historial.

   \* Se creó una única instancia vigente \`nuevaAsignacion\` de \`AsignacionReparto\` con \`fechaHoraInicio\`, \`fechaHoraFin \= NULL\` y \`motivoReasignacion\` (cuando fue reasignación), asociada al \`Pedido\`, al \`Usuario\` Repartidor y al \`Usuario\` Vendedor.

   \* Se conservaron inalterados \`Pedido.estado \= PENDIENTE\`, sus \`DetallePedido\`, precios, inventario, Caja y Cuenta Corriente; y quedó invalidada cualquier \`RutaReparto\` sugerida previa que dependiera de la asignación reemplazada.

\---

\#\# 6\. Contrato de la Operación \`consultarPedidosAsignados\` (\`UC-04\`)

1\. \*\*Nombre:\*\* \`consultarPedidosAsignados()\`

2\. \*\*Responsabilidades:\*\* Mostrar en modo solo lectura exclusivamente el conjunto de \`Pedido\` en estado \`PENDIENTE\` que poseen una \`AsignacionReparto\` vigente vinculada al \`Repartidor\` autenticado, incluyendo las cantidades originales y las unidades adicionales aceptadas en \`UC-07\`.

3\. \*\*Tipo:\*\* \`Sistema\`

4\. \*\*Referencias cruzadas:\*\* Caso de Uso \`UC-04 — Consultar Pedidos Asignados\`; Caso de Uso \`UC-43 — Asignar y Reasignar Pedidos a Repartidores\`; Objetivo \`OBJE-01\`; Requisito \`RF-01\`.

5\. \*\*Notas:\*\* Operación estrictamente de solo lectura. No expone Pedidos asignados a otros Repartidores ni confunde el estado comercial del Pedido con su asignación.

6\. \*\*Excepciones:\*\*

   \* \*\*A1 — El Repartidor no posee asignaciones vigentes:\*\* Informar lista vacía.

   \* \*\*A2 — Intento de acceder a Pedidos de otro Repartidor o sin autorización:\*\* Rechazar el acceso.

7\. \*\*Salida:\*\*

   \* Listado y detalle de los \`Pedido\` \`PENDIENTE\` asignados al Repartidor autenticado (\`idPedido\`, \`Cliente\`, \`fechaReparto\`, dirección de entrega, \`Producto\`, \`cantidadOriginal\` y adicionales aceptadas en \`UC-07\`); o mensajes de las excepciones A1–A2.

8\. \*\*Precondiciones:\*\*

   \* El \`Repartidor\` se encuentra autenticado y autorizado.

9\. \*\*Postcondiciones:\*\*

   \* \*(Sin cambios de estado en el sistema: no se modifican \`Pedido\` ni \`AsignacionReparto\`)\*.

\---

\#\# 7\. Contrato de la Operación \`generarRutaSugeridaReparto\` (\`UC-25\`)

1\. \*\*Nombre:\*\* \`generarRutaSugeridaReparto(fechaReparto: LocalDate)\`

2\. \*\*Responsabilidades:\*\* Recuperar los \`Pedido\` en estado \`PENDIENTE\` para la \`fechaReparto\` indicada con \`AsignacionReparto\` vigente al \`Repartidor\` autenticado, validar sus datos de ubicación, solicitar al \`Servicio de Ruteo\` externo una secuencia sugerida de visita y registrar/presentar dicha secuencia sin alterar el estado de los Pedidos.

3\. \*\*Tipo:\*\* \`Sistema\`

4\. \*\*Referencias cruzadas:\*\* Caso de Uso \`UC-25 — Generar Ruta Sugerida de Reparto\`; Caso de Uso \`UC-43 — Asignar y Reasignar Pedidos a Repartidores\`; Objetivo \`OBJE-06\`; Requisito \`RF-17\`.

5\. \*\*Notas:\*\* La secuencia constituye una ruta sugerida de apoyo operativo y no un óptimo matemático garantizado. Una reasignación posterior en \`UC-43\` o una reprogramación de fecha (\`RD-RP020-001\`) invalida la ruta sugerida y exige su regeneración.

6\. \*\*Excepciones:\*\*

   \* \*\*A1 — No existen \`Pedido\` \`PENDIENTE\` asignados al Repartidor para \`fechaReparto\`:\*\* Informar que no hay entregas pendientes y no invocar al \`Servicio de Ruteo\`.

   \* \*\*A2 — Uno o más Pedidos carecen de ubicación suficiente:\*\* Identificarlos expresamente (sin omitirlos silenciosamente) y presentar el listado pendiente sin afirmar ruta optimizada.

   \* \*\*A3 — \`Servicio de Ruteo\` no disponible, con error o con respuesta inconsistente respecto de las ubicaciones enviadas:\*\* Informar la contingencia y conservar disponible el listado de entregas pendientes sin secuencia optimizada.

7\. \*\*Salida:\*\*

   \* Entregas ordenadas según la secuencia sugerida (\`ordenVisita\`, \`idPedido\`, \`Cliente\`, dirección y marca temporal de generación), o listado de contingencia sin optimizar según las excepciones A1–A3.

8\. \*\*Precondiciones:\*\*

   \* El \`Repartidor\` se encuentra autenticado y autorizado, y existen \`Pedido\` \`PENDIENTE\` asignados a él para la \`fechaReparto\`.

9\. \*\*Postcondiciones:\*\*

   \* Cuando las ubicaciones fueron válidas y el \`Servicio de Ruteo\` devolvió una respuesta consistente, se creó una instancia \`unaRuta\` de \`RutaReparto\` (con sus \`DetalleRutaReparto\` indicando el orden sugerido y las asignaciones consideradas) asociada al \`Repartidor\` y a la \`fechaHoraGeneracion\`.

   \* El atributo \`Pedido.estado\` de todos los Pedidos considerados permaneció inalterado en \`PENDIENTE\`.

\---

\#\# 8\. Glosario de Términos Asociados (\`REV-04A\`)

\* \*\*\`Pedido\` (Tipo / Concepto — Tabla \`PEDIDO\`):\*\* Orden comercial de un \`Cliente\` para una \`fechaReparto\`, con \`canalOrigen\` (\`INTERNO\` \| \`ONLINE\`), \`estado\` (\`PENDIENTE\` \| \`ENTREGADO\` \| \`CANCELADO\`) y \`totalOriginal\` congelado.

\* \*\*\`DetallePedido\` (Tipo / Concepto — Tabla \`DETALLE\_PEDIDO\`):\*\* Ítem de un \`Pedido\` que conserva inmutables \`cantidadOriginal\`, \`precioUnitarioOriginal\` y el mejor descuento promocional aplicable sin acumulación (\`RD-RP023-001\`).

\* \*\*\`AsignacionReparto\` (Tipo / Concepto — Tabla \`ASIGNACION\_REPARTO\`):\*\* Asociación trazable regida por las 6 reglas de \`RD-RP002-001\` que vincula un \`Pedido\` \`PENDIENTE\` con un único \`Repartidor\` vigente (\`fechaHoraFin \= NULL\`).

\* \*\*\`RutaReparto\` (Tipo / Concepto — Tabla \`RUTA\_REPARTO\`):\*\* Secuencia sugerida de visita generada en \`UC-25\` para los Pedidos \`PENDIENTE\` asignados a un \`Repartidor\` en una \`fechaReparto\`.

### **Próximo paso inmediato: `REV-04B` (`UC-28`, `UC-05`, `UC-06`, `UC-61`, `UC-07`, `UC-41`)**

Con `REV-04A` completado y validado estáticamente, el siguiente paso es emitir la segunda mitad del Lote 4: **`REV-04B` (`UC-28`, `UC-05`, `UC-06`, `UC-61`, `UC-07`, `UC-41` — 6 Casos de Uso)**, donde incorporaremos de forma central el hallazgo **`H-03` y `H-09` (`RD-F04-001..007` y `RD-RP004/RP028`):** **la declaración de efectivo recibido por el Repartidor bajo `UC-05` y su tratamiento como dinero/efectivo en tránsito** (sin otorgar `UC-29` al Repartidor). ¿Avanzamos con **`REV-04B`**?

### **Paquete Completo de Revisión Transversal — Lote 4B (`REV-04B`: Preparación, Entrega con Efectivo en Tránsito y Offline, Cancelación y Excedentes)**

Aplicando la metodología reproducible de ocho etapas (`M-0` a `M-7`) definida en **`REV01_AUDITORIA_TRANSVERSAL_CIERRE_2026-10-28.md`** y corrigiendo los hallazgos de **`AUDITORIA_PREINTEGRACION_GEMINI_DSS_DS_CONTRATOS_2026-10-27.md`**, entrego la segunda mitad del Lote 4 (**`REV-04B`: `UC-28`, `UC-05`, `UC-06`, `UC-61`, `UC-07`, `UC-41`**).

### **Archivo 1: `docs/08-diagramas/revision/REV04B_AUDITORIA_TRANSVERSAL_ENTREGAS_EXCEDENTES_2026-10-28.md`**

\# REV-04B — Auditoría Transversal y Corrección: Preparación, Entrega, Cancelación y Excedentes (UC-28, UC-05, UC-06, UC-61, UC-07, UC-41)

\*\*Fecha:\*\* 28/10/2026  

\*\*Rama de trabajo propuesta:\*\* \`revision/rev04b-entregas-excedentes-2026-10-28\`  

\*\*Alcance (\`REV-04B\`):\*\* \`UC-28\` («include» \`UC-34\`), \`UC-05\` («include» \`UC-34\`, \`UC-15\`), \`UC-06\` («include» \`UC-34\`, «extend» condicional \`UC-26\`), \`UC-61\`, \`UC-07\` («include» \`UC-61\` aprobado el 25/10/2026), \`UC-41\` («include» \`UC-61\` aprobado el 25/10/2026).  

\*\*Estado de los artefactos entregados:\*\* \`PROPUESTO / CORREGIDO EN REVISIÓN ESTÁTICA\` (pendiente de inspección visual humana en Draw.io y aprobación para fusión a \`main\`).

\---

\#\# 1\. Ejecución de las 8 Etapas Metodológicas (M-0 a M-7)

\#\#\# M-0 — Autoridad y alcance congelados

\* \*\*Catálogo funcional vigente:\*\* 64 CU consecutivos (\`UC-01\`..\`UC-64\`) en 3 niveles (\`ALE\_MILANESAS\_FASE\_4\_CU\_01\_A\_64\_TRES\_NIVELES.docx\`).

\* \*\*Relaciones UML aprobadas en este sublote:\*\* \`UC-28 → UC-34\` (\`include\`), \`UC-05 → UC-34\` (\`include\`), \`UC-05 → UC-15\` (\`include\`), \`UC-06 → UC-34\` (\`include\`), \`UC-26 → UC-06\` (\`extend\` condicional), \`UC-07 → UC-61\` (\`include\` aprobada el 25/10/2026) y \`UC-41 → UC-61\` (\`include\` aprobada el 25/10/2026). El archivo \`DIAGRAMA DE CASOS DE USO.drawio (1).xml\` permanece intacto.

\* \*\*Decisiones posteriores incorporadas (Corte 27/10/2026):\*\*

  \* \*\*\`RD-F04-001..007\` y \`RD-RP004/RP028\` (resuelven Hallazgos de Prioridad Alta \`H-03\` y \`H-09\` en \`UC-05\`):\*\*

    1\. \*\*Declaración de efectivo recibido por el Repartidor (Efectivo en Tránsito):\*\* En \`UC-05 — Registrar Entrega\`, el Repartidor puede declarar el monto de efectivo entregado en mano por el Cliente (\`efectivoDeclaradoRecibido: BigDecimal\[0..1\]\`). Dicho importe se registra como \*\*pago/efectivo en tránsito validado\*\* asociado a la \`Entrega\`: \*\*no ejecuta \`UC-29 — Registrar Cobro\`\*\*, \*\*no crea un \`Cobro\` definitivo\*\*, \*\*no genera \`MovimientoCaja\` (\`INGRESO\`)\*\* ni reduce el \*\*saldo confirmado\*\* de Cuenta Corriente hasta su rendición y registración en \`UC-29\` por Vendedor o Administrador, pero sí se expone en \`UC-14\` para determinar el \*\*saldo exigible provisional\*\*.

    2\. \*\*Operación offline y regla «El Reparto Manda» (\`RD-F04\`):\*\* Cuando el Repartidor registra la Entrega en modo offline sobre un Pedido válidamente asignado, la operación se almacena localmente con \`claveIdempotencia\` y el snapshot comercial congelado; al sincronizar con el servidor, se valida identidad, sesión, no duplicación e integridad de límites comerciales/físicos («El Reparto Manda» para las cantidades efectivamente entregadas y el efectivo declarado en tránsito) sin otorgar permiso de \`UC-29\` al Repartidor.

  \* \*\*Desagrupamiento de \`UC-07\` en Contratos individuales (\`H-11\` / Puerta \`G4\`):\*\* Se separan \`registrarOfertaExcedente\` (que no reserva stock ni transfiere unidades) y \`registrarRespuestaOfertaExcedente\` (que revalida concurrencia, transfiere costo histórico en \`MovimientoExcedente\` \`REASIGNACION\` e incorpora adicionales al Pedido receptor) en dos contratos independientes con sus 9 secciones.

\#\#\# M-1 — Proveniencia, integridad y matriz de diferencias (Antes → Después)

\| ID Hallazgo \| Artefacto / Celda Original \| Antes (Borrador 26–27/10) \| Después (Versión Corregida \`REV04B\`) \| Fundamento \|

\| :--- \| :--- \| :--- \| :--- \| :--- \|

\| \*\*\`H-03\` (Alta)\*\* \| \`DSS Repartidor\` (\`p3\_m7\`), \`DS UC-05\` y \`Contrato 3.3\` \| Restringía \`UC-05\` a entrega y cargo sin modelar la declaración de efectivo recibido por el Repartidor ni el efectivo en tránsito. \| Incorpora \`efectivoDeclaradoRecibido:BigDecimal\[0..1\]\` en la firma y flujo de \`UC-05\`, registrando el \*\*efectivo en tránsito validado\*\* (que impacta en el saldo exigible provisional de \`UC-14\` sin ejecutar \`UC-29\` ni ingresar en \`Caja\`). \| \`RD-F04-001..007\` y \`RD-RP004/RP028\` \|

\| \*\*\`H-09\` (Media/Alta)\*\* \| \`DS UC-05\` y \`Contrato 3.3\` \| Trataba \`F04\` como pendiente abierto sin detallar la validación en servidor ni la regla «El Reparto Manda». \| Formaliza la validación de servidor con \`claveIdempotencia\`, respeto del snapshot de reparto válido («El Reparto Manda») y conciliación idempotente sin duplicar cargos ni entregas. \| \`RD-F04-001..007\` \|

\| \*\*\`H-11\` (Media)\*\* \| \`Contrato 5.5\` (\`UC-07\`) \| Agrupaba \`registrarOfertaExcedente\` y \`registrarRespuestaOfertaExcedente\` en un único contrato. \| Se desagrupan en \*\*2 Contratos independientes\*\* (Contratos \`5\` y \`6\` de \`REV-04B\`), sumando \*\*7 Contratos individuales\*\* en este sublote. \| Puerta \`G4\` / \`H-11\` \|

\| \*\*\`H-12\`, \`H-19\`, \`H05\`\*\* \| \`DSS\`, \`DS\` y \`Contratos\` \| Secuencia continua en el DSS, referencias a tablas SQL en caja negra y firmas divergentes. \| Marcos \`sd\` independientes por CU en el DSS, lenguaje de caja negra y homologación 1:1 de las 7 firmas públicas entre DSS, DS y Contratos. \| \`M-3\`, \`H-12\`, \`H-19\`, \`H05\` \|

\---

\#\# 2\. Matriz de Trazabilidad Vertical y Visibilidad de Larman Mensaje por Mensaje (M-3 y M-6)

\| CU \| Paso / Mensaje en DS \| Emisor \$\\rightarrow\$ Receptor \| Tipo de Visibilidad (Larman) \| Origen verificable de la referencia \|

\| :--- \| :--- \| :--- \| :--- \| :--- \|

\| \*\*\`UC-28\`\*\* \| \`1: registrarPreparacionPedido(idPedido, idProducto, cantidadPreparada)\` \| \`Responsable de Producción\` \$\\rightarrow\$ \`:ControladorProduccion\` \| Frontera de sistema \| Operación pública homologada del DSS (\`UC-28\`, precedida por \`«include» UC-34\`). \|

\| \*\*\`UC-28\`\*\* \| \`2: consumos \= calcularInsumosProporcionales(cantidadPreparada)\` \| \`:ControladorProduccion\` \$\\rightarrow\$ \`verReceta : VersionReceta\` \| \*\*Por Variable Local / Parámetro\*\* \| Recupera la \`VersionReceta\` vigente del Producto \`ELABORADO\` y escala por \`cantidadPreparada / cantidadRendimientoBase\`. \|

\| \*\*\`UC-28\`\*\* \| \`3: verificarStockYCongelarCostosHistoricos(consumos)\` \| \`:ControladorProduccion\` \$\\rightarrow\$ \`:CatalogoInsumos\` \| \*\*Por Atributo\*\* \| Verifica \`stockActual \>= cantidadNecesaria\` y obtiene el \`vigenteDesdeCosto\` de \`CostoInsumoHistorico\` (nunca costo cero). \|

\| \*\*\`UC-28\`\*\* \| \`4: «create» new(unPedido, unProducto, verReceta, cantidadPreparada, consumosConCostoCongelado)\` \| \`:ControladorProduccion\` \$\\rightarrow\$ \`unaPrep : Preparacion\` \| \*\*Por Creación Local (\`new\`)\*\* \| Registra \`Preparacion\`, descuenta stock creando \`MovimientoInsumo\` (\`CONSUMO\_PRODUCCION\`) y evalúa \`PRA-01\`. \|

\| \*\*\`UC-05\`\*\* \| \`1: registrarEntrega(idPedido, detallesEntrega, efectivoDeclaradoRecibido, claveIdempotencia)\` \| \`Repartidor\` \$\\rightarrow\$ \`:ControladorReparto\` \| Frontera de sistema \| Operación pública homologada del DSS (\`UC-05\`, precedida por \`«include» UC-34\`). \|

\| \*\*\`UC-05\`\*\* \| \`2: liq \= validarAsignacionLimitesEImputacionComercial(idRepartidor, detallesEntrega, efectivoDeclaradoRecibido, claveIdempotencia)\` \| \`:ControladorReparto\` \$\\rightarrow\$ \`unPedido : Pedido\` \| \*\*Por Variable Local\*\* \| Valida idempotencia (\`RD-F04\`), imputa primero a unidades originales y luego a adicionales por orden de confirmación (\`UC-07\`). \|

\| \*\*\`UC-05\`\*\* \| \`3: «create» new(unPedido, detallesEntrega, importeEfectivoVenta, efectivoDeclaradoEnTransito, claveIdempotencia)\` \| \`:ControladorReparto\` \$\\rightarrow\$ \`unaEntrega : Entrega\` \| \*\*Por Creación Local (\`new\`)\*\* \| Crea la \`Entrega\` definitiva, descuenta stock \`REVENTA\` (\`EGRESO\_VENTA\`) y conserva el \*\*efectivo en tránsito validado\*\* (\`RD-F04\` / \`RD-RP028\`) sin crear \`Cobro\` ni \`MovimientoCaja\`. \|

\| \*\*\`UC-05\`\*\* \| \`4: «create» new(unProducto, unPedido, cantSobrante, costoHistoricoPreservado, estado=DISPONIBLE)\` \| \`:ControladorReparto\` \$\\rightarrow\$ \`sobrante : Excedente\` \| \*\*Por Creación Local (\`new\`)\*\* \| Si sobró Producto \`ELABORADO\` disponible, crea el \`Excedente\` con su costo histórico. \|

\| \*\*\`UC-05\`\*\* \| \`5: registrarCargoPorVentaEfectivaYActualizarEfectivoEnTransito(unCliente, unaEntrega, importeEfectivoVenta, efectivoDeclaradoRecibido)\` \| \`:ControladorReparto\` \$\\rightarrow\$ \`:LibroCuentaCorriente\` \| \*\*Por Atributo \+ Parámetro\*\* \| Registra \`CARGO\_POR\_VENTA\` en el saldo confirmado y actualiza los pagos en tránsito validados para el saldo exigible provisional (\`UC-14\`), ejecutando luego \`«include» UC-15\`. \|

\| \*\*\`UC-06\`\*\* \| \`1: cancelarPedido(idPedido, motivoCancelacion)\` \| \`Actor Autorizado\` \$\\rightarrow\$ \`:ControladorPedidos\` \| Frontera de sistema \| Operación pública homologada del DSS (\`UC-06\`, precedida por \`«include» UC-34\`). \|

\| \*\*\`UC-06\`\*\* \| \`2: «create» new(unProducto, unPedido, cantDisponible, costoHistoricoPonderado, origen=CANCELACION)\` \| \`:ControladorPedidos\` \$\\rightarrow\$ \`excCancel : Excedente\` \| \*\*Por Creación Local (\`new\`)\*\* \| Preserva como \`Excedente\` todo Producto \`ELABORADO\` ya preparado/reasignado sin revertir consumos de Insumos, y extiende condicionalmente a \`UC-26\` si tiene \`Cobro\` electrónico reembolsable. \|

\| \*\*\`UC-61\`\*\* \| \`1: buscarExcedente(idProducto, idPedidoOrigen, fechaGeneracion, soloDisponibles)\` \| \`Vendedor / Resp. Producción\` \$\\rightarrow\$ \`:ControladorProduccion\` \| Frontera de sistema \| Operación pública homologada del DSS (\`UC-61\`). \|

\| \*\*\`UC-61\`\*\* \| \`2: lista \= consultarExcedentesElaboradosSegunPermisos(filtro, rolActor)\` \| \`:ControladorProduccion\` \$\\rightarrow\$ \`:RepositorioExcedentes\` \| \*\*Por Atributo\*\* \| Consulta sin reservar saldo y ocultando costos internos al Vendedor. \|

\| \*\*\`UC-07\` (Oferta)\*\* \| \`1a: registrarOfertaExcedente(idExcedente, idPedidoReceptor, cantidadOfrecida)\` \| \`Vendedor\` \$\\rightarrow\$ \`:ControladorPedidos\` \| Frontera de sistema \| Primera operación pública de \`UC-07\` (precedida por \`«include» UC-61\`). \|

\| \*\*\`UC-07\` (Oferta)\*\* \| \`2a: «create» new(unExcedente, pedidoReceptor, cantidadOfrecida, importeInformado)\` \| \`:ControladorPedidos\` \$\\rightarrow\$ \`oferta : OfertaExcedente\` \| \*\*Por Creación Local (\`new\`)\*\* \| Registra la oferta sin reservar \`cantidadDisponible\`. \|

\| \*\*\`UC-07\` (Resp.)\*\* \| \`1b: registrarRespuestaOfertaExcedente(idOfertaExcedente, aceptada, cantidadAceptada)\` \| \`Vendedor\` \$\\rightarrow\$ \`:ControladorPedidos\` \| Frontera de sistema \| Segunda operación pública de \`UC-07\`. \|

\| \*\*\`UC-07\` (Resp.)\*\* \| \`2b: incorporarAdicionalesYCrearMovimientoReasignacion(cantidadAceptada, importeAceptado, costoTransferido)\` \| \`:ControladorPedidos\` \$\\rightarrow\$ \`pedidoReceptor : Pedido\` / \`movExc : MovimientoExcedente\` \| \*\*Por Variable Local \+ Creación Local (\`new\`)\*\* \| Incorpora unidades adicionales e \`importeAceptado\` sin alterar \`cantidadOriginal\` ni \`totalOriginal\`, crea \`MovimientoExcedente\` (\`REASIGNACION\`) y reduce \`cantidadDisponible\`. \|

\| \*\*\`UC-41\`\*\* \| \`1: registrarDescarteExcedente(idExcedente, cantidadDescartada, motivoDescarte)\` \| \`Responsable de Producción\` \$\\rightarrow\$ \`:ControladorProduccion\` \| Frontera de sistema \| Operación pública homologada del DSS (\`UC-41\`, precedida por \`«include» UC-61\`). \|

\| \*\*\`UC-41\`\*\* \| \`2: «create» new(unExcedente, tipo=DESCARTE, cantidadDescartada, motivoDescarte, costoDescartado)\` \| \`:ControladorProduccion\` \$\\rightarrow\$ \`movDesc : MovimientoExcedente\` \| \*\*Por Creación Local (\`new\`)\*\* \| Registra el descarte y reduce atómicamente \`unExcedente.cantidadDisponible\` (\`DISPONIBLE\` o \`AGOTADO\`). \|

\---

\#\# 3\. Matriz Transversal de Invariantes y Puertas de Aceptación (M-4 y M-7)

\| ID \| Invariante ratificada \| DSS \| DS \| Contrato \| Dictamen \|

\| :--- \| :--- \| :--- \| :--- \| :--- \| :--- \|

\| \*\*\`I-01\`\*\* \| \`RD-F04\` y \`RD-RP004/RP028\` (\`H-03\`, \`H-09\`): \`UC-05\` registra \`efectivoDeclaradoRecibido\` como efectivo en tránsito validado (sin ejecutar \`UC-29\` ni ingresar en \`Caja\`) y valida idempotencia/snapshot de reparto offline \| Parámetro y retorno explícitos en \`DSS UC-05\` \| Paso \`2:\`, \`3:\` y \`5:\` en \`DS UC-05\` \| Notas, Pre/Postcondiciones en \`CONTRATO\_UC05\` \| \*\*PASÓ (Trazabilidad estática)\*\* \|

\| \*\*\`I-02\`\*\* \| \`UC-28\`: Límite de preparación propia \`\<= cantidadSolicitada\` original (sin descontar adicionales de \`UC-07\`) y congelamiento de costos históricos válidos \| Guarda en \`DSS UC-28\` \| Validación en \`DS UC-28\` \| \`CONTRATO\_UC28\` individual \| \*\*PASÓ (Trazabilidad estática)\*\* \|

\| \*\*\`I-03\`\*\* \| \`UC-07\` y \`UC-41\` («include» \`UC-61\` aprobados el 25/10): Oferta no reserva saldo; aceptación transfiere costo histórico sin re-ejecutar \`UC-15\`/\`UC-16\` ni volver a preparar; descarte exige motivo y preserva consumos históricos \| Marcos \`UC-61\`, \`UC-07\` y \`UC-41\` \| \`DS UC-61\`, \`UC-07\` y \`UC-41\` con revalidación concurrente \| Contratos individuales \`4\`, \`5\`, \`6\` y \`7\` \| \*\*PASÓ (Trazabilidad estática)\*\* \|

\| \*\*\`I-04\`\*\* \| Homologación 1:1 de firmas públicas DSS ↔ DS ↔ Contrato y desagrupamiento en 7 contratos individuales (\`H-11\`, \`H05\`) \| 7 firmas canónicas \| Mensaje \`1:\` idéntico en las 6 páginas DS \| 7 Contratos individuales con 9 secciones \| \*\*PASÓ\*\* \|

\| \*\*\`I-05\`\*\* \| Inspección visual y prueba de desplazamiento (\`round-trip\`) en editor gráfico Draw.io (\`M-6\` / \`G5\`) \| XML bien formado \| XML bien formado \| N/A \| \*\*PENDIENTE DE VALIDACIÓN HUMANA EN DRAW.IO\*\* \|

### **Archivo 2: `docs/08-diagramas/revision/DSS_REV04B_ENTREGAS_EXCEDENTES_FRAGMENTOS.drawio.xml`**

Este archivo XML compatible con **Draw.io** modela en **3 páginas** los escenarios de caja negra (DSS) de `UC-28`, `UC-61` y `UC-41` (Actor `Responsable de Producción`), `UC-05` (Actor `Repartidor` con declaración de efectivo en tránsito y sincronización offline `RD-F04`/`RD-RP028`), y `UC-06` y `UC-07` (Actor `Vendedor`), separados en marcos `sd` independientes (`H-12`) y sin lenguaje SQL interno (`H-19`):

\<mxfile host="app.diagrams.net" modified="2026-10-28T12:15:00.000Z" agent="Gemini-REV04B" version="24.7.17" type="device"\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 1: DSS CAJA NEGRA — PRODUCCIÓN (UC-28, UC-61, UC-41)               \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id="dss-rev04b-prod" name="DSS REV04B \- Producción (UC-28, UC-61, UC-41)"\>

    \<mxGraphModel dx="1500" dy="950" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1450" pageHeight="1350" math="0" shadow="0"\>

      \<root\>

        \<mxCell id="0" /\>

        \<mxCell id="1" parent="0" /\>

        \<mxCell id="p1\_title" value="DSS (Caja Negra — REV04B) — Actor: Responsable de Producción — Escenarios Independientes UC-28, UC-61 y UC-41 \[Sin UC-35 en rótulo — H-17\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=13;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="15" width="1320" height="30" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="p1\_actor" value="Responsable de&\#xa;Producción" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="110" y="60" width="30" height="60" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="p1\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="119" y="155" width="12" height="1120" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="p1\_sys\_box" value=":Sistema" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;fontSize=13;" vertex="1" parent="1"\>

          \<mxGeometry x="940" y="60" width="140" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="p1\_sys\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1010" y="1300" as="sourcePoint" /\>

            \<mxPoint x="1010" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="p1\_sys\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1004" y="155" width="12" height="1120" as="geometry" /\>

        \</mxCell\>

        \<\!-- MARCO UC-28 \--\>

        \<mxCell id="p1\_sd28" value="sd Escenario Independiente — UC-28: Registrar Preparación de Pedido (con «include» UC-34)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=580;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="170" width="1100" height="340" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="p1\_28\_ref34" value="ref «include» UC-34 Buscar Pedido (selecciona el Pedido PENDIENTE y el Producto ELABORADO con preparación propia pendiente)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=280;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="90" y="205" width="780" height="50" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="p1\_28\_m1" value="1: idPreparacion \= registrarPreparacionPedido(idPedido:Long, idProducto:Long, cantidadPreparada:BigDecimal)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="131" y="295" as="sourcePoint" /\>

            \<mxPoint x="1004" y="295" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="p1\_28\_r1" value="1.1: \[0 \&lt; cantidadPreparada \&lt;= (cantidadOriginal \- preparadaPropiaAcumulada), Receta vigente activa, stock suficiente y costos históricos válidos\] registra Preparación, consume Insumos y evalúa reposición automática (PRA-01)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1004" y="375" as="sourcePoint" /\>

            \<mxPoint x="131" y="375" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="p1\_28\_r2" value="1.2: \[Pedido no PENDIENTE, supera cantidadOriginal propia, sin Receta vigente, stock insuficiente o sin fuente de costo histórico\] bloquea el registro sin descontar stock parcial" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1004" y="465" as="sourcePoint" /\>

            \<mxPoint x="131" y="465" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<\!-- MARCO UC-61 \--\>

        \<mxCell id="p1\_sd61" value="sd Escenario Independiente — UC-61: Buscar Excedente" style="shape=umlFrame;whiteSpace=wrap;html=1;width=380;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="540" width="1100" height="200" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="p1\_61\_m1" value="1: excedentes \= buscarExcedente(idProducto:Long\[0..1\], idPedidoOrigen:Long\[0..1\], fechaGeneracion:LocalDate\[0..1\], soloDisponibles:Boolean)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="131" y="590" as="sourcePoint" /\>

            \<mxPoint x="1004" y="590" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="p1\_61\_r1" value="1.1: muestra Excedentes de Productos ELABORADO (Producto, Pedido origen, fechaHoraGeneracion, cantidadInicial, cantidadDisponible) y devuelve la referencia seleccionada sin reservar saldo" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1004" y="685" as="sourcePoint" /\>

            \<mxPoint x="131" y="685" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<\!-- MARCO UC-41 (+ INCLUDE UC-61) \--\>

        \<mxCell id="p1\_sd41" value="sd Escenario Independiente — UC-41: Registrar Descarte de Excedente (con «include» aprobado 25/10 UC-61)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=660;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="770" width="1100" height="330" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="p1\_41\_ref61" value="ref «include» UC-61 Buscar Excedente (aprobada 25/10 — selecciona un Excedente DISPONIBLE con cantidadDisponible \&gt; 0)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=280;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="90" y="805" width="780" height="50" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="p1\_41\_m1" value="1: idMovimiento \= registrarDescarteExcedente(idExcedente:Long, cantidadDescartada:BigDecimal, motivoDescarte:String)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="131" y="895" as="sourcePoint" /\>

            \<mxPoint x="1004" y="895" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="p1\_41\_r1" value="1.1: \[0 \&lt; cantidadDescartada \&lt;= cantidadDisponible actual, motivoDescarte informado y costo histórico determinable\] registra descarte, reduce cantidadDisponible (DISPONIBLE o AGOTADO) y preserva Preparación histórica" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1004" y="975" as="sourcePoint" /\>

            \<mxPoint x="131" y="975" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="p1\_41\_r2" value="1.2: \[Cantidad inválida/supera disponible por concurrencia, falta motivo o costo histórico indeterminable\] rechaza el descarte sin modificar el Excedente" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1004" y="1060" as="sourcePoint" /\>

            \<mxPoint x="131" y="1060" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 2: DSS CAJA NEGRA — REPARTIDOR (UC-05 CON EFECTIVO EN TRÁNSITO)    \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id="dss-rev04b-rep" name="DSS REV04B \- Repartidor (UC-05 Efectivo en Tránsito)"\>

    \<mxGraphModel dx="1500" dy="850" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1450" pageHeight="950" math="0" shadow="0"\>

      \<root\>

        \<mxCell id="0" /\>

        \<mxCell id="1" parent="0" /\>

        \<mxCell id="r2\_title" value="DSS (Caja Negra — REV04B) — Actor: Repartidor — UC-05: Registrar Entrega \[RD-F04 Efectivo en Tránsito y Validación Offline\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=13;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="15" width="1300" height="30" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="r2\_actor" value="Repartidor" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="110" y="60" width="30" height="60" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="r2\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="119" y="155" width="12" height="720" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="r2\_sys\_box" value=":Sistema" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;fontSize=13;" vertex="1" parent="1"\>

          \<mxGeometry x="960" y="60" width="140" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="r2\_sys\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1030" y="900" as="sourcePoint" /\>

            \<mxPoint x="1030" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="r2\_sys\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1024" y="155" width="12" height="720" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="r2\_sd05" value="sd Escenario Independiente — UC-05: Registrar Entrega («include» UC-34 y UC-15) \[RD-F04 / RD-RP028\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=680;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="170" width="1120" height="670" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="r2\_ref34" value="ref «include» UC-34 Buscar Pedido (selecciona el Pedido PENDIENTE asignado al Repartidor autenticado)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=260;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="90" y="205" width="780" height="50" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="r2\_05\_m1" value="1: idEntrega \= registrarEntrega(idPedido:Long, detallesEntrega:List\&lt;ItemEntregaDTO\&gt;, efectivoDeclaradoRecibido:BigDecimal\[0..1\], claveIdempotencia:UUID)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="131" y="295" as="sourcePoint" /\>

            \<mxPoint x="1024" y="295" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="r2\_ref15" value="ref «include» UC-15 Evaluar y Actualizar Categoría Comercial (ejecutado tras confirmar el cargo por venta efectiva en Cuenta Corriente)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=280;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="250" y="325" width="760" height="50" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="r2\_alt05" value="alt Confirmación de Entrega, Cargo Efectivo y Declaración de Efectivo en Tránsito \[UC-05 — RD-F04 / RD-RP028\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=690;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="75" y="395" width="1070" height="415" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="r2\_g1" value="\[Pedido PENDIENTE con asignación vigente al Repartidor (o snapshot offline válido «El Reparto Manda»), cantidades dentro del límite comercial y físico, y efectivoDeclaradoRecibido \&gt;= 0\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="145" y="420" width="960" height="25" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="r2\_r1" value="1.1: registra Entrega definitiva, marca Pedido ENTREGADO, genera Excedente por elaborado no entregado, registra cargo por venta efectiva en Cuenta Corriente, ejecuta UC-15 y registra efectivoDeclaradoRecibido como EFECTIVO EN TRÁNSITO VALIDADO (sin ejecutar UC-29 ni ingresar aún en Caja)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1024" y="510" as="sourcePoint" /\>

            \<mxPoint x="131" y="510" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="r2\_div" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="75" y="610" as="sourcePoint" /\>

            \<mxPoint x="1145" y="610" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="r2\_g2" value="\[Pedido no asignado al Repartidor, cantidades fuera de límite comercial/físico, falta costo histórico o claveIdempotencia duplicada\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="145" y="620" width="840" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="r2\_r2" value="1.2: rechaza entrega inválida o reconoce idempotentemente la entrega ya sincronizada sin duplicar cargos, Excedentes ni efectivo en tránsito" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1024" y="730" as="sourcePoint" /\>

            \<mxPoint x="131" y="730" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 3: DSS CAJA NEGRA — VENDEDOR (UC-06 Y UC-07 DESAGRUPADO)           \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id="dss-rev04b-vend" name="DSS REV04B \- Vendedor (UC-06 y UC-07)"\>

    \<mxGraphModel dx="1550" dy="950" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1500" pageHeight="1350" math="0" shadow="0"\>

      \<root\>

        \<mxCell id="0" /\>

        \<mxCell id="1" parent="0" /\>

        \<mxCell id="v2\_title" value="DSS (Caja Negra — REV04B) — Actor: Vendedor — Escenarios Independientes UC-06 y UC-07 (Oferta y Respuesta separadas)" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=13;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="15" width="1280" height="30" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="v2\_actor" value="Vendedor" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="100" y="60" width="30" height="60" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="v2\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="109" y="155" width="12" height="1120" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="v2\_sys\_box" value=":Sistema" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;fontSize=13;" vertex="1" parent="1"\>

          \<mxGeometry x="860" y="60" width="140" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="v2\_sys\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="930" y="1300" as="sourcePoint" /\>

            \<mxPoint x="930" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="v2\_sys\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="924" y="155" width="12" height="1120" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="v2\_mp\_box" value=":MercadoPago" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;fontSize=12;" vertex="1" parent="1"\>

          \<mxGeometry x="1240" y="60" width="150" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="v2\_mp\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1315" y="1300" as="sourcePoint" /\>

            \<mxPoint x="1315" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="v2\_mp\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1309" y="340" width="12" height="90" as="geometry" /\>

        \</mxCell\>

        \<\!-- MARCO UC-06 \--\>

        \<mxCell id="v2\_sd06" value="sd Escenario Independiente — UC-06: Cancelar Pedido («include» UC-34 y «extend» condicional UC-26)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=630;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="45" y="170" width="1395" height="420" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="v2\_06\_ref34" value="ref «include» UC-34 Buscar Pedido (selecciona el Pedido PENDIENTE)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=250;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="85" y="205" width="760" height="50" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="v2\_06\_m1" value="1: resultadoCancelacion \= cancelarPedido(idPedido:Long, motivoCancelacion:String)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="121" y="290" as="sourcePoint" /\>

            \<mxPoint x="924" y="290" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="v2\_06\_opt26" value="opt «extend» UC-26 Procesar Reembolso Electrónico \[solo si el Pedido posee Cobro electrónico reembolsable\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=680;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="680" y="330" width="680" height="80" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="v2\_06\_r1" value="1.1: \[Pedido PENDIENTE y motivo informado\] marca Pedido CANCELADO, preserva elaborados preparados/reasignados como Excedente (con costo histórico ponderado) e inicia UC-26 si tenía Cobro electrónico (el Cobro manual queda como saldo a favor)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="924" y="465" as="sourcePoint" /\>

            \<mxPoint x="121" y="465" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="v2\_06\_r2" value="1.2: \[Pedido ya ENTREGADO/CANCELADO o falta motivo obligatorio\] rechaza la cancelación" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="924" y="545" as="sourcePoint" /\>

            \<mxPoint x="121" y="545" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<\!-- MARCO UC-07 (+ INCLUDE UC-61) \--\>

        \<mxCell id="v2\_sd07" value="sd Escenario Independiente — UC-07: Ofrecer y Reasignar Excedente (con «include» aprobado 25/10 UC-61)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=670;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="45" y="620" width="1100" height="580" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="v2\_07\_ref61" value="ref «include» UC-61 Buscar Excedente (aprobada 25/10 — selecciona un Excedente DISPONIBLE y presenta Pedidos candidatos PENDIENTE)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=280;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="85" y="655" width="780" height="50" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="v2\_07\_m1" value="1: idOfertaExcedente \= registrarOfertaExcedente(idExcedente:Long, idPedidoReceptor:Long, cantidadOfrecida:BigDecimal)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="121" y="745" as="sourcePoint" /\>

            \<mxPoint x="924" y="745" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="v2\_07\_r1" value="1.1: calcula importeInformado y registra Oferta de Excedente sin reservar existencias" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="924" y="805" as="sourcePoint" /\>

            \<mxPoint x="121" y="805" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="v2\_07\_m2" value="2: resultadoReasignacion \= registrarRespuestaOfertaExcedente(idOfertaExcedente:Long, aceptada:Boolean, cantidadAceptada:BigDecimal\[0..1\])" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="121" y="885" as="sourcePoint" /\>

            \<mxPoint x="924" y="885" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="v2\_07\_r2" value="2.1: \[aceptada \== true, Pedido receptor PENDIENTE y cantidadAceptada \&lt;= cantidadDisponible\] incorpora unidades adicionales e importeAceptado al Pedido receptor (sin alterar cantidadOriginal ni totalOriginal y sin volver a preparar ni ejecutar UC-15/UC-16), transfiere costo histórico y reduce cantidadDisponible" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="924" y="990" as="sourcePoint" /\>

            \<mxPoint x="121" y="990" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="v2\_07\_r3" value="2.2: \[aceptada \== false o sin disponibilidad física suficiente al confirmar\] registra rechazo o impide la transferencia sin modificar cantidadDisponible ni el Pedido receptor" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="924" y="1120" as="sourcePoint" /\>

            \<mxPoint x="121" y="1120" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

\</mxfile\>

### **Archivo 3: `docs/08-diagramas/revision/DS_REV04B_ENTREGAS_EXCEDENTES_UC05_06_07_28_41_61.drawio.xml`**

Este archivo XML de **6 páginas** para **Draw.io** contiene los Diagramas de Secuencia de Diseño (DS de caja blanca) corregidos para `UC-28`, `UC-05` (con **declaración de efectivo en tránsito validado y sincronización offline** `RD-F04`/`RD-RP028`), `UC-06`, `UC-61`, `UC-07` y `UC-41`:

\<mxfile host="app.diagrams.net" modified="2026-10-28T12:20:00.000Z" agent="Gemini-REV04B" version="24.7.17" type="device"\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 1: DS UC-28 REGISTRAR PREPARACIÓN DE PEDIDO                        \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id="ds-rev04b-uc28" name="DS UC-28 Registrar Preparación (REV04B)"\>

    \<mxGraphModel dx="1650" dy="950" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1600" pageHeight="1150" math="0" shadow="0"\>

      \<root\>

        \<mxCell id="0" /\>

        \<mxCell id="1" parent="0" /\>

        \<mxCell id="u28\_title" value="Diagrama de Secuencia de Diseño (DS — REV04B) — UC-28: Registrar Preparación de Pedido (con «include» UC-34)" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="15" width="1150" height="30" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u28\_actor" value="Responsable de&\#xa;Producción" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="85" y="60" width="30" height="60" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u28\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="94" y="155" width="12" height="920" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u28\_ctrl\_box" value=":ControladorProduccion" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="340" y="60" width="170" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u28\_ctrl\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="425" y="1100" as="sourcePoint" /\>

            \<mxPoint x="425" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u28\_ctrl\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="419" y="155" width="12" height="920" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u28\_ver\_box" value="verReceta : VersionReceta" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="660" y="60" width="175" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u28\_ver\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="747" y="1100" as="sourcePoint" /\>

            \<mxPoint x="747" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u28\_ver\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="741" y="290" width="12" height="80" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u28\_cat\_box" value=":CatalogoInsumos" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="960" y="60" width="165" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u28\_cat\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1042" y="1100" as="sourcePoint" /\>

            \<mxPoint x="1042" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u28\_cat\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1036" y="390" width="12" height="390" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u28\_prp\_box" value="unaPrep : Preparacion&\#xa;+ MovimientoInsumo \[1..\*\]" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1280" y="550" width="185" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u28\_prp\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1372" y="1100" as="sourcePoint" /\>

            \<mxPoint x="1372" y="595" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u28\_prp\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1366" y="595" width="12" height="80" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u28\_ref34" value="ref «include» UC-34 Buscar Pedido (selecciona unPedido PENDIENTE y un Producto ELABORADO con preparación propia pendiente)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=280;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="65" y="165" width="760" height="55" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u28\_m1" value="1: idPreparacion \= registrarPreparacionPedido(idPedido:Long, idProducto:Long, cantidadPreparada:BigDecimal)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="106" y="255" as="sourcePoint" /\>

            \<mxPoint x="419" y="255" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u28\_m2" value="2: consumos \= calcularInsumosProporcionales(factor \= cantidadPreparada / cantidadRendimientoBase) \[Variable Local\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="431" y="315" as="sourcePoint" /\>

            \<mxPoint x="741" y="315" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u28\_m3" value="3: verificarStockYCongelarCostosHistoricos(consumos) \[Atributo\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="431" y="415" as="sourcePoint" /\>

            \<mxPoint x="1036" y="415" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u28\_alt" value="alt Validación de límite propio \&lt;= cantidadOriginal (sin descontar adicionales UC-07), stock y costo histórico \[UC-28\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=710;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="475" width="1460" height="560" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u28\_g1" value="\[0 \&lt; cantidadPreparada \&lt;= (cantidadOriginal \- cantidadPreparadaPropiaAcumulada), stock suficiente y costos históricos válidos\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="500" width="820" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u28\_m4\_new" value="4: «create» new(unPedido, unProducto, verReceta, cantidadPreparada, consumosConCostoCongelado)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="431" y="572" as="sourcePoint" /\>

            \<mxPoint x="1280" y="572" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u28\_m5" value="5: descontarStockRegistrarConsumoYEvaluarReposicionAutomatica(consumos) \[PRA-01\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="431" y="710" as="sourcePoint" /\>

            \<mxPoint x="1036" y="710" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u28\_r1\_ok" value="5.1: registra Preparacion, MovimientoInsumo (CONSUMO\_PRODUCCION), actualiza stockActual y evalúa umbralMinimo" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="419" y="805" as="sourcePoint" /\>

            \<mxPoint x="106" y="805" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u28\_div" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="50" y="865" as="sourcePoint" /\>

            \<mxPoint x="1510" y="865" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u28\_g2" value="\[Supera cantidadOriginal propia, sin Receta vigente, stock insuficiente o Insumo sin fuente de costo válida\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="875" width="740" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u28\_r1\_err" value="5.2: bloquea el registro sin descontar stock parcial ni utilizar costo cero" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="419" y="975" as="sourcePoint" /\>

            \<mxPoint x="106" y="975" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 2: DS UC-05 REGISTRAR ENTREGA (RD-F04 EFECTIVO EN TRÁNSITO/OFFLINE)--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id="ds-rev04b-uc05" name="DS UC-05 Registrar Entrega (REV04B)"\>

    \<mxGraphModel dx="1700" dy="1000" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1650" pageHeight="1350" math="0" shadow="0"\>

      \<root\>

        \<mxCell id="0" /\>

        \<mxCell id="1" parent="0" /\>

        \<mxCell id="u05\_title" value="Diagrama de Secuencia de Diseño (DS — REV04B) — UC-05: Registrar Entrega («include» UC-34, UC-15) \[RD-F04 Efectivo en Tránsito y Validación Offline\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="15" width="1460" height="30" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u05\_actor" value="Repartidor" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="80" y="60" width="30" height="60" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u05\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="89" y="155" width="12" height="1120" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u05\_ctrl\_box" value=":ControladorReparto" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="320" y="60" width="165" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u05\_ctrl\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="402" y="1300" as="sourcePoint" /\>

            \<mxPoint x="402" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u05\_ctrl\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="396" y="155" width="12" height="1120" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u05\_ped\_box" value="unPedido : Pedido" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="620" y="60" width="155" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u05\_ped\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="697" y="1300" as="sourcePoint" /\>

            \<mxPoint x="697" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u05\_ped\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="691" y="250" width="12" height="750" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u05\_ent\_box" value="unaEntrega : Entrega&\#xa;(incluye efectivoEnTransito)" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="910" y="510" width="185" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u05\_ent\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1002" y="1300" as="sourcePoint" /\>

            \<mxPoint x="1002" y="555" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u05\_ent\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="996" y="555" width="12" height="100" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u05\_exc\_box" value="sobrante : Excedente&\#xa;\[0..\*\]" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1160" y="650" width="160" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u05\_exc\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1240" y="1300" as="sourcePoint" /\>

            \<mxPoint x="1240" y="695" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u05\_exc\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1234" y="695" width="12" height="75" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u05\_cc\_box" value=":LibroCuentaCorriente" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1400" y="60" width="170" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u05\_cc\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1485" y="1300" as="sourcePoint" /\>

            \<mxPoint x="1485" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u05\_cc\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1479" y="800" width="12" height="90" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u05\_ref34" value="ref «include» UC-34 Buscar Pedido (selecciona unPedido PENDIENTE con asignación vigente al Repartidor)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=250;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="65" y="165" width="680" height="55" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u05\_m1" value="1: idEntrega \= registrarEntrega(idPedido:Long, detallesEntrega:List\&lt;ItemEntregaDTO\&gt;, efectivoDeclaradoRecibido:BigDecimal\[0..1\], claveIdempotencia:UUID)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="101" y="255" as="sourcePoint" /\>

            \<mxPoint x="396" y="255" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u05\_m2" value="2: liq \= validarAsignacionLimitesEImputacionComercial(idRepartidor, detallesEntrega, efectivoDeclaradoRecibido, claveIdempotencia) \[RD-F04\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="408" y="310" as="sourcePoint" /\>

            \<mxPoint x="691" y="310" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u05\_r2" value="2.1: (importeEfectivoVenta imputando originales → adicionales cronológicos, costosHistoricosAtribuidos, sobrantesElaborados, efectivoEnTransitoValidado)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="691" y="375" as="sourcePoint" /\>

            \<mxPoint x="408" y="375" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u05\_alt" value="alt Revalidación de asignación, límites físicos/comerciales y registro de Efectivo en Tránsito \[UC-05 — RD-F04 / RD-RP028\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=750;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="45" y="430" width="1555" height="790" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u05\_g1" value="\[Pedido PENDIENTE asignado al Repartidor (o snapshot offline válido «El Reparto Manda»), \&gt;= 1 cantidad \&gt; 0, costos válidos y efectivoDeclaradoRecibido \&gt;= 0\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="115" y="455" width="960" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u05\_m3\_new" value="3: «create» new(unPedido, detallesEntrega, importeEfectivoVenta, efectivoDeclaradoEnTransito, salidasReventaEgresoVenta)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="408" y="532" as="sourcePoint" /\>

            \<mxPoint x="910" y="532" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u05\_opt\_exc" value="opt \[cantidadElaboradaDisponible \&gt; cantidadEntregada — Registra Excedente con su costo histórico\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=620;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="380" y="615" width="980" height="165" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u05\_m4\_new" value="4: «create» new(unProducto, unPedido, cantSobrante, costoUnitarioHistorico, costoTotalHistorico, estado=DISPONIBLE)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="408" y="672" as="sourcePoint" /\>

            \<mxPoint x="1160" y="672" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u05\_m5" value="5: registrarCargoPorVentaEfectivaYActualizarEfectivoEnTransito(unCliente, unaEntrega, importeEfectivoVenta, efectivoDeclaradoRecibido) \[RD-RP028\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="408" y="825" as="sourcePoint" /\>

            \<mxPoint x="1479" y="825" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u05\_ref15" value="ref «include» UC-15 Evaluar y Actualizar Categoría Comercial (ejecutado tras confirmar CARGO\_POR\_VENTA)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=280;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="380" y="905" width="760" height="55" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u05\_m6" value="6: marcarComoEntregado() \[estado \= ENTREGADO\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="408" y="985" as="sourcePoint" /\>

            \<mxPoint x="691" y="985" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u05\_r1\_ok" value="6.1: informa Entrega definitiva, Excedentes y efectivo en tránsito validado (sin crear Cobro UC-29 ni ingresar aún en Caja)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="396" y="1040" as="sourcePoint" /\>

            \<mxPoint x="101" y="1040" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u05\_div" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="45" y="1090" as="sourcePoint" /\>

            \<mxPoint x="1600" y="1090" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u05\_g2" value="\[Sin asignación válida, supera límite comercial/físico, falta valoración válida o claveIdempotencia ya sincronizada\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="115" y="1100" width="760" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u05\_r1\_err" value="6.2: detiene entrega inválida o reconoce idempotentemente la entrega ya sincronizada sin duplicar efectos" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="396" y="1185" as="sourcePoint" /\>

            \<mxPoint x="101" y="1185" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 3: DS UC-06 CANCELAR PEDIDO                                        \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id="ds-rev04b-uc06" name="DS UC-06 Cancelar Pedido (REV04B)"\>

    \<mxGraphModel dx="1600" dy="900" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1550" pageHeight="1050" math="0" shadow="0"\>

      \<root\>

        \<mxCell id="0" /\>

        \<mxCell id="1" parent="0" /\>

        \<mxCell id="u06\_title" value="Diagrama de Secuencia de Diseño (DS — REV04B) — UC-06: Cancelar Pedido («include» UC-34 y «extend» condicional UC-26)" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="15" width="1200" height="30" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u06\_actor" value="Vendedor /&\#xa;Repartidor" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="85" y="60" width="30" height="60" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u06\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="94" y="155" width="12" height="820" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u06\_ctrl\_box" value=":ControladorPedidos" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="350" y="60" width="165" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u06\_ctrl\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="432" y="1000" as="sourcePoint" /\>

            \<mxPoint x="432" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u06\_ctrl\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="426" y="155" width="12" height="820" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u06\_ped\_box" value="unPedido : Pedido" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="680" y="60" width="160" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u06\_ped\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="760" y="1000" as="sourcePoint" /\>

            \<mxPoint x="760" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u06\_ped\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="754" y="250" width="12" height="290" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u06\_exc\_box" value="excCancel : Excedente&\#xa;\[0..\*\]" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1040" y="490" width="170" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u06\_exc\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1125" y="1000" as="sourcePoint" /\>

            \<mxPoint x="1125" y="535" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u06\_exc\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1119" y="535" width="12" height="80" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u06\_ref34" value="ref «include» UC-34 Buscar Pedido (selecciona unPedido y recupera Preparaciones, Reasignaciones y Cobros)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=250;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="65" y="165" width="740" height="55" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u06\_m1" value="1: resultadoCancelacion \= cancelarPedido(idPedido:Long, motivoCancelacion:String)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="106" y="255" as="sourcePoint" /\>

            \<mxPoint x="426" y="255" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u06\_m2" value="2: elaboradosDisponibles \= calcularElaboradosYCostoHistoricoPonderado() \[Variable Local\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="438" y="305" as="sourcePoint" /\>

            \<mxPoint x="754" y="305" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u06\_alt" value="alt Validación de estado PENDIENTE y motivo obligatorio al cancelar \[UC-06\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=490;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="360" width="1420" height="565" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u06\_g1" value="\[unPedido.estado \== PENDIENTE y motivoCancelacion \!= null\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="385" width="480" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u06\_m3" value="3: establecerEstadoCancelado(motivoCancelacion, fechaHoraCancelacion) \[No revierte CONSUMO\_PRODUCCION ni stock REVENTA\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="438" y="435" as="sourcePoint" /\>

            \<mxPoint x="754" y="435" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u06\_opt\_exc" value="opt \[Existe cantidad ELABORADA disponible en el Pedido cancelado\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=460;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="380" y="465" width="880" height="165" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u06\_m4\_new" value="4: «create» new(unProducto, unPedido, cantInicial, cantDisponible, costoUnitarioPonderado, costoTotalHistorico)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="438" y="512" as="sourcePoint" /\>

            \<mxPoint x="1040" y="512" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u06\_opt\_26" value="opt «extend» UC-26 Procesar Reembolso Electrónico \[solo si existe Cobro electrónico reembolsable\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=680;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="380" y="650" width="980" height="65" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u06\_r1\_ok" value="4.1: informa Pedido CANCELADO, Excedentes preservados y eventual inicio de Reembolso electrónico" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="426" y="760" as="sourcePoint" /\>

            \<mxPoint x="106" y="760" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u06\_div" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="50" y="810" as="sourcePoint" /\>

            \<mxPoint x="1470" y="810" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u06\_g2" value="\[Pedido ya ENTREGADO o CANCELADO, o falta motivo obligatorio\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="820" width="520" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u06\_r1\_err" value="4.2: impide cancelar nuevamente y conserva intacto el estado" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="426" y="895" as="sourcePoint" /\>

            \<mxPoint x="106" y="895" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 4: DS UC-61 BUSCAR EXCEDENTE                                       \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id="ds-rev04b-uc61" name="DS UC-61 Buscar Excedente (REV04B)"\>

    \<mxGraphModel dx="1450" dy="800" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1400" pageHeight="850" math="0" shadow="0"\>

      \<root\>

        \<mxCell id="0" /\>

        \<mxCell id="1" parent="0" /\>

        \<mxCell id="u61\_title" value="Diagrama de Secuencia de Diseño (DS — REV04B) — UC-61: Buscar Excedente" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="15" width="900" height="30" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u61\_actor" value="Vendedor /&\#xa;Resp. Producción" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="90" y="60" width="30" height="60" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u61\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="99" y="155" width="12" height="620" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u61\_ctrl\_box" value=":ControladorProduccion" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="380" y="60" width="170" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u61\_ctrl\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="465" y="800" as="sourcePoint" /\>

            \<mxPoint x="465" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u61\_ctrl\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="459" y="155" width="12" height="620" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u61\_repo\_box" value=":RepositorioExcedentes" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="760" y="60" width="175" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u61\_repo\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="847" y="800" as="sourcePoint" /\>

            \<mxPoint x="847" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u61\_repo\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="841" y="200" width="12" height="120" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u61\_m1" value="1: excedentes \= buscarExcedente(idProducto:Long\[0..1\], idPedidoOrigen:Long\[0..1\], fechaGeneracion:LocalDate\[0..1\], soloDisponibles:Boolean)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="111" y="190" as="sourcePoint" /\>

            \<mxPoint x="459" y="190" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u61\_m2" value="2: lista \= consultarExcedentesElaboradosSegunPermisos(filtro, rolActor) \[Atributo\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="471" y="235" as="sourcePoint" /\>

            \<mxPoint x="841" y="235" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u61\_r2" value="2.1: List\&lt;Excedente\&gt; (omite costos internos restringidos si el actor es Vendedor)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="841" y="295" as="sourcePoint" /\>

            \<mxPoint x="471" y="295" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u61\_alt" value="alt Selección de Excedente sin reserva de saldo \[UC-61\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=380;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="340" width="1180" height="380" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u61\_g1" value="\[lista.notEmpty()\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="125" y="365" width="300" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u61\_r1\_ok" value="3.1: muestra Producto ELABORADO, Pedido origen, fechaHoraGeneracion, cantidadInicial y cantidadDisponible; devuelve referencia al CU invocante sin reservar saldo" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="459" y="455" as="sourcePoint" /\>

            \<mxPoint x="111" y="455" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u61\_div" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="50" y="555" as="sourcePoint" /\>

            \<mxPoint x="1230" y="555" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u61\_g2" value="\[Sin coincidencias o Excedente seleccionado con cantidadDisponible \== 0 para consumo\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="125" y="565" width="560" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u61\_r1\_empty" value="3.2: informa lista vacía o indisponibilidad para reasignar/descartar" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="459" y="655" as="sourcePoint" /\>

            \<mxPoint x="111" y="655" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 5: DS UC-07 OFRECER Y REASIGNAR EXCEDENTE («include» 25/10 UC-61)  \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id="ds-rev04b-uc07" name="DS UC-07 Ofrecer Reasignar Excedente (REV04B)"\>

    \<mxGraphModel dx="1650" dy="950" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1600" pageHeight="1200" math="0" shadow="0"\>

      \<root\>

        \<mxCell id="0" /\>

        \<mxCell id="1" parent="0" /\>

        \<mxCell id="u07\_title" value="Diagrama de Secuencia de Diseño (DS — REV04B) — UC-07: Ofrecer y Reasignar Excedente (con «include» aprobado 25/10 UC-61)" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="15" width="1280" height="30" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u07\_actor" value="Vendedor" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="85" y="60" width="30" height="60" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u07\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="94" y="155" width="12" height="960" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u07\_ctrl\_box" value=":ControladorPedidos" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="340" y="60" width="165" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u07\_ctrl\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="422" y="1140" as="sourcePoint" /\>

            \<mxPoint x="422" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u07\_ctrl\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="416" y="155" width="12" height="960" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u07\_exc\_box" value="unExcedente : Excedente" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="660" y="60" width="170" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u07\_exc\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="745" y="1140" as="sourcePoint" /\>

            \<mxPoint x="745" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u07\_exc\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="739" y="550" width="12" height="300" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u07\_of\_box" value="oferta : OfertaExcedente" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="960" y="310" width="175" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u07\_of\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1047" y="1140" as="sourcePoint" /\>

            \<mxPoint x="1047" y="355" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u07\_of\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1041" y="355" width="12" height="80" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u07\_ped\_box" value="pedidoReceptor : Pedido&\#xa;+ movExc : MovimientoExcedente" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1260" y="60" width="210" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u07\_ped\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1365" y="1140" as="sourcePoint" /\>

            \<mxPoint x="1365" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u07\_ped\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1359" y="610" width="12" height="190" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u07\_ref61" value="ref «include» UC-61 Buscar Excedente (aprobada 25/10 — identifica unExcedente DISPONIBLE y candidatos PENDIENTE)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=280;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="65" y="165" width="760" height="60" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u07\_m1" value="1: idOfertaExcedente \= registrarOfertaExcedente(idExcedente:Long, idPedidoReceptor:Long, cantidadOfrecida:BigDecimal)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="106" y="270" as="sourcePoint" /\>

            \<mxPoint x="416" y="270" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u07\_m2\_new" value="2: «create» new(unExcedente, pedidoReceptor, cantidadOfrecida, importeInformado, fechaHora) \[Sin reservar stock\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="428" y="332" as="sourcePoint" /\>

            \<mxPoint x="960" y="332" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u07\_m3" value="3: resultadoReasignacion \= registrarRespuestaOfertaExcedente(idOfertaExcedente:Long, aceptada:Boolean, cantidadAceptada:BigDecimal\[0..1\])" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="106" y="465" as="sourcePoint" /\>

            \<mxPoint x="416" y="465" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u07\_alt" value="alt Revalidación bajo bloqueo concurrente al aceptar reasignación de Excedente \[UC-07\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=560;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="505" width="1460" height="560" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u07\_g1" value="\[aceptada \== true, 0 \&lt; cantidadAceptada \&lt;= unExcedente.cantidadDisponible y pedidoReceptor.estado \== PENDIENTE\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="530" width="760" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u07\_m4" value="4: costoTransferido \= descontarCantidadYCalcularCostoTransferido(cantidadAceptada)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="428" y="585" as="sourcePoint" /\>

            \<mxPoint x="739" y="585" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u07\_m5" value="5: incorporarAdicionalesYCrearMovimientoReasignacion(cantidadAceptada, importeAceptado, costoTransferido)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="428" y="655" as="sourcePoint" /\>

            \<mxPoint x="1359" y="655" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u07\_r5" value="5.1: conserva cantidadOriginal, Promoción y ajuste global; registra MovimientoExcedente REASIGNACION (sin ejecutar UC-15/UC-16 ni nueva Preparación)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1359" y="745" as="sourcePoint" /\>

            \<mxPoint x="428" y="745" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u07\_r3\_ok" value="5.2: informa reasignación confirmada y estado resultante del Excedente (DISPONIBLE o AGOTADO)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="416" y="835" as="sourcePoint" /\>

            \<mxPoint x="106" y="835" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u07\_div" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="50" y="895" as="sourcePoint" /\>

            \<mxPoint x="1510" y="895" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u07\_g2" value="\[Cliente rechaza oferta, cantidad supera disponible o Pedido receptor ya no está PENDIENTE\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="905" width="660" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u07\_r3\_err" value="5.3: registra rechazo o impide transferencia sin alterar cantidadDisponible ni el Pedido receptor" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="416" y="1000" as="sourcePoint" /\>

            \<mxPoint x="106" y="1000" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 6: DS UC-41 REGISTRAR DESCARTE DE EXCEDENTE («include» 25/10 UC-61)--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id="ds-rev04b-uc41" name="DS UC-41 Registrar Descarte Excedente (REV04B)"\>

    \<mxGraphModel dx="1550" dy="850" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1500" pageHeight="950" math="0" shadow="0"\>

      \<root\>

        \<mxCell id="0" /\>

        \<mxCell id="1" parent="0" /\>

        \<mxCell id="u41\_title" value="Diagrama de Secuencia de Diseño (DS — REV04B) — UC-41: Registrar Descarte de Excedente (con «include» aprobado 25/10 UC-61)" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="15" width="1280" height="30" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u41\_actor" value="Responsable de&\#xa;Producción" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="90" y="60" width="30" height="60" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u41\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="99" y="155" width="12" height="720" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u41\_ctrl\_box" value=":ControladorProduccion" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="360" y="60" width="170" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u41\_ctrl\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="445" y="900" as="sourcePoint" /\>

            \<mxPoint x="445" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u41\_ctrl\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="439" y="155" width="12" height="720" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u41\_exc\_box" value="unExcedente : Excedente" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="700" y="60" width="170" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u41\_exc\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="785" y="900" as="sourcePoint" /\>

            \<mxPoint x="785" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u41\_exc\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="779" y="380" width="12" height="220" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u41\_mov\_box" value="movDesc :&\#xa;MovimientoExcedente" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1080" y="470" width="180" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u41\_mov\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1170" y="900" as="sourcePoint" /\>

            \<mxPoint x="1170" y="515" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u41\_mov\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1164" y="515" width="12" height="80" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u41\_ref61" value="ref «include» UC-61 Buscar Excedente (aprobada 25/10 — localiza unExcedente DISPONIBLE con remanente libre)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=280;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="65" y="165" width="760" height="60" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u41\_m1" value="1: idMovimiento \= registrarDescarteExcedente(idExcedente:Long, cantidadDescartada:BigDecimal, motivoDescarte:String)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="111" y="275" as="sourcePoint" /\>

            \<mxPoint x="439" y="275" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u41\_alt" value="alt Validación de cantidadDescartada \&lt;= cantidadDisponible, motivo y costo histórico determinable \[UC-41\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=630;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="325" width="1360" height="510" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u41\_g1" value="\[0 \&lt; cantidadDescartada \&lt;= cantidadDisponible, motivoDescarte \!= null y costoHistoricoDisponible determinable\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="125" y="350" width="680" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u41\_m2" value="2: costoDescartado \= descontarParaDescarte(cantidadDescartada:BigDecimal)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="451" y="415" as="sourcePoint" /\>

            \<mxPoint x="779" y="415" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u41\_m3\_new" value="3: «create» new(unExcedente, tipo=DESCARTE, cantidadDescartada, motivoDescarte, costoDescartado, fechaHora)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="451" y="492" as="sourcePoint" /\>

            \<mxPoint x="1080" y="492" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u41\_r1\_ok" value="3.1: registra MovimientoExcedente DESCARTE y actualiza estado (DISPONIBLE o AGOTADO) sin revertir Preparaciones ni Insumos" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="439" y="635" as="sourcePoint" /\>

            \<mxPoint x="111" y="635" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u41\_div" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="50" y="695" as="sourcePoint" /\>

            \<mxPoint x="1410" y="695" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u41\_g2" value="\[Cantidad inválida, sin motivo o sin costo histórico determinable\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="125" y="705" width="520" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u41\_r1\_err" value="3.2: rechaza el descarte sin utilizar costo cero ni modificar cantidadDisponible" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="439" y="790" as="sourcePoint" /\>

            \<mxPoint x="111" y="790" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

\</mxfile\>

### **Archivo 4: `docs/08-diagramas/revision/CONTRATOS_REV04B_ENTREGAS_EXCEDENTES_7_OPERACIONES.md`**

Este archivo contiene los **7 Contratos individuales desagrupados** (`UC-28`, `UC-05`, `UC-06`, `UC-61`, `registrarOfertaExcedente` de `UC-07`, `registrarRespuestaOfertaExcedente` de `UC-07`, y `UC-41`) con las **9 secciones estándar**, firmas 100% homologadas y aplicación estricta de `RD-F04-001..007` y `RD-RP004/RP028` (`H-03`, `H-09`):

\# Contratos de Operación del Sistema (DSS — REV-04B) — Preparación, Entrega, Cancelación y Excedentes (7 Contratos Individuales)

\*\*Proyecto:\*\* Sistema de Gestión para Ale Milanesas (UNaM-FCEQyN)  

\*\*Lote de revisión:\*\* \`REV-04B\` (\`UC-28\`, \`UC-05\`, \`UC-06\`, \`UC-61\`, \`UC-07\` desagrupado en Oferta y Respuesta, \`UC-41\`)  

\*\*Decisiones incorporadas:\*\* \`RD-F04-001..007\` y \`RD-RP004/RP028\` (\`H-03\`, \`H-09\`: declaración de efectivo recibido por el Repartidor bajo \`UC-05\` como \*\*efectivo en tránsito validado\*\* y validación en servidor para operación offline bajo «El Reparto Manda»), más relaciones \`include\` aprobadas el 25/10/2026 (\`UC-07→UC-61\` y \`UC-41→UC-61\`).

\---

\#\# 1\. Contrato de la Operación \`registrarPreparacionPedido\` (\`UC-28\` «include» \`UC-34\`)

1\. \*\*Nombre:\*\* \`registrarPreparacionPedido(idPedido: Long, idProducto: Long, cantidadPreparada: BigDecimal)\`

2\. \*\*Responsabilidades:\*\* Registrar la producción propia de un \`Producto\` de \`tipoProducto \= ELABORADO\` para un \`Pedido\` \`PENDIENTE\` (localizado mediante \`UC-34\`), verificando que la preparación propia acumulada no supere la \`cantidadOriginal\` solicitada, escalando proporcionalmente la \`VersionReceta\` vigente, descontando las existencias de cada \`Insumo\`, congelando sus costos históricos y evaluando el proceso \`PRA-01\`.

3\. \*\*Tipo:\*\* \`Sistema\`

4\. \*\*Referencias cruzadas:\*\* Caso de Uso \`UC-28 — Registrar Preparación de Pedido\`; incluye \`UC-34 — Buscar Pedido\`; Proceso \`PRA-01\`; Objetivo \`OBJE-07\`; Requisitos \`RF-04\`, \`RF-05\`, \`RF-21\`.

5\. \*\*Notas:\*\* Las cantidades adicionales recibidas por reasignación de Excedentes (\`UC-07\`) \*\*no reducen\*\* el límite de preparación propia (\`cantidadOriginal \- cantidadPreparadaPropiaAcumulada\`) ni vuelven a prepararse. Prohibido utilizar costo cero si falta fuente de costo histórico válida.

6\. \*\*Excepciones:\*\*

   \* \*\*A1 — \`Pedido\` no \`PENDIENTE\`:\*\* Impedir el registro de preparación.

   \* \*\*A2 — \`cantidadPreparada \<= 0\` o \`cantidadPreparadaPropiaAcumulada \+ cantidadPreparada \> cantidadOriginal\`:\*\* Solicitar corrección sin registrar preparación.

   \* \*\*A3 — No existe \`VersionReceta\` aplicable válida o el Producto es de tipo \`REVENTA\`:\*\* Bloquear la operación.

   \* \*\*A4 — Stock disponible insuficiente en algún \`Insumo\` o falta de fuente válida de \`CostoInsumoHistorico\`:\*\* Rechazar atómicamente la preparación sin descontar stock parcial.

7\. \*\*Salida:\*\*

   \* Confirmación de la \`Preparacion\` registrada (\`idPreparacion\`), consumos de \`Insumo\`, costos históricos congelados y stock resultante; o mensajes de las excepciones A1–A4.

8\. \*\*Precondiciones:\*\*

   \* El \`Responsable de Producción\` se encuentra autenticado y autorizado.

   \* El \`Pedido\` seleccionado mediante \`UC-34\` está en estado \`PENDIENTE\`, el \`Producto\` es \`ELABORADO\` con preparación propia pendiente y posee \`VersionReceta\` vigente.

9\. \*\*Postcondiciones:\*\*

   \* Se creó una instancia \`unaPreparacion\` de \`Preparacion\` con \`cantidadPreparada\` y \`fechaHoraPreparacion\`, asociada al \`DetallePedido\` y a la \`VersionReceta\` aplicada.

   \* Para cada \`DetalleVersionReceta\` de la versión aplicada, se decrementó \`Insumo.stockActual\` y se creó una instancia de \`MovimientoInsumo\` (\`CONSUMO\_PRODUCCION\`) asociada a \`unaPreparacion\`, al \`Insumo\` y al \`CostoInsumoHistorico\` vigente (\`vigenteDesdeCosto\`).

   \* Si algún \`Insumo\` quedó con \`stockActual \< umbralMinimo\` y \`automatizacionCompraActiva \= true\`, se activó la evaluación de \`PRA-01\`.

\---

\#\# 2\. Contrato de la Operación \`registrarEntrega\` (\`UC-05\` «include» \`UC-34\`, \`UC-15\`)

1\. \*\*Nombre:\*\* \`registrarEntrega(idPedido: Long, detallesEntrega: List\<ItemEntregaDTO\>, efectivoDeclaradoRecibido: BigDecimal\[0..1\], claveIdempotencia: UUID)\`

2\. \*\*Responsabilidades:\*\* Registrar de forma definitiva e idempotente las cantidades efectivamente entregadas de un \`Pedido\` \`PENDIENTE\` asignado al \`Repartidor\` autenticado (localizado mediante \`UC-34\`), imputando comercialmente primero las unidades originales y luego las adicionales aceptadas (\`UC-07\`), descontando stock \`REVENTA\`, generando \`Excedente\` por los productos elaborados disponibles no entregados, registrando el \`CARGO\_POR\_VENTA\` efectivo en Cuenta Corriente, ejecutando \`UC-15\` y \*\*registrando la declaración de efectivo recibido por el Repartidor como efectivo en tránsito validado (\`RD-F04\` / \`RD-RP028\`)\*\*.

3\. \*\*Tipo:\*\* \`Sistema\`

4\. \*\*Referencias cruzadas:\*\* Caso de Uso \`UC-05 — Registrar Entrega\`; incluye \`UC-34 — Buscar Pedido\` y \`UC-15 — Evaluar y Actualizar Categoría Comercial\`; Decisiones \`RD-F04-001..007\` y \`RD-RP004/RP028\` (\`H-03\`, \`H-09\`); Objetivos \`OBJE-01\`, \`OBJE-05\`, \`OBJE-10\`, \`OBJE-14\`; Requisitos \`RF-02\`, \`RF-04\`, \`RF-06\`, \`RF-13\`, \`RF-19\`.

5\. \*\*Notas:\*\*

   \* \*\*Efectivo en tránsito (\`RD-F04\` / \`RD-RP028\`):\*\* El Repartidor \*\*no ejecuta \`UC-29 — Registrar Cobro\`\*\*. Cuando el Cliente entrega dinero en efectivo al Repartidor durante el reparto, el monto informado en \`efectivoDeclaradoRecibido\` queda registrado como \*\*efectivo/pago en tránsito validado\*\*: reduce el \*\*saldo exigible provisional\*\* consultable en \`UC-14\`, pero no modifica el \*\*saldo confirmado\*\* de Cuenta Corriente ni genera \`Cobro\` ni \`MovimientoCaja\` (\`INGRESO\`) hasta su rendición y registración mediante \`UC-29\` por Vendedor o Administrador.

   \* \*\*Operación offline y «El Reparto Manda» (\`RD-F04\`):\*\* Si la entrega se ejecutó en modo offline dentro de una sesión y asignación válidas, al sincronizar con el servidor se reconcilia idempotentemente mediante \`claveIdempotencia\` respetando el snapshot comercial congelado («El Reparto Manda»).

6\. \*\*Excepciones:\*\*

   \* \*\*A1 — \`Pedido\` no \`PENDIENTE\` o sin asignación válida al Repartidor autenticado:\*\* Rechazar el registro de la entrega.

   \* \*\*A2 — Cantidades negativas, todas iguales a cero, superiores al límite comercial (\`cantidadOriginal \+ adicionalesAceptados\`) o \`efectivoDeclaradoRecibido \< 0\`:\*\* Solicitar corrección sin confirmar.

   \* \*\*A3 — Cantidad entregada superior a la disponibilidad física (\`ELABORADO\` preparado/reasignado o stock \`REVENTA\`):\*\* Impedir la confirmación.

   \* \*\*A4 — Falta de valoración válida de costo histórico en \`ELABORADO\` o \`REVENTA\`:\*\* No utilizar costo cero; bloquear o marcar para regularización.

   \* \*\*A5 — \`claveIdempotencia\` ya procesada en sincronización previa (\`RD-F04\`):\*\* Reconocer la \`Entrega\` existente sin duplicar cargos, salidas de stock, Excedentes ni efectivo en tránsito.

7\. \*\*Salida:\*\*

   \* Confirmación de la \`Entrega\` definitiva (\`idEntrega\`), importe efectivo cargado en Cuenta Corriente, monto de \`efectivoDeclaradoRecibido\` registrado en tránsito y detalle de \`Excedente\` generados; o mensajes de las excepciones A1–A5.

8\. \*\*Precondiciones:\*\*

   \* El \`Repartidor\` se encuentra autenticado y autorizado, y el \`Pedido\` identificado por \`idPedido\` está en estado \`PENDIENTE\` con asignación vigente a ese Repartidor (o respaldado por un snapshot offline válido según \`RD-F04\`).

9\. \*\*Postcondiciones:\*\*

   \* Se creó una única instancia \`unaEntrega\` de \`Entrega\` (y sus \`DetalleEntrega\` e \`ImputacionEntregaAdicional\`) asociada al \`Pedido\` y al \`Repartidor\`, con \`fechaHoraEntrega\` e \`importeEfectivoVenta\`.

   \* Si \`efectivoDeclaradoRecibido \> 0\`, se registró en \`unaEntrega\` / registro de tránsito el importe de \*\*efectivo en tránsito validado\*\* atribuido al \`Repartidor\` y al \`Cliente\` (\`RD-F04\` / \`RD-RP028\`), sin crear instancias de \`Cobro\` ni de \`MovimientoCaja\`.

   \* Para cada ítem de \`Producto\` \`REVENTA\` entregado, se decrementó \`Producto.stockActualReventa\` y se creó una instancia de \`MovimientoStockReventa\` (\`EGRESO\_VENTA\`) con su costo histórico congelado.

   \* Para cada ítem de \`Producto\` \`ELABORADO\` con sobrante físico disponible no entregado, se creó una instancia de \`Excedente\` en estado \`DISPONIBLE\` (\`origenGeneracion \= ENTREGA\`) conservando su costo histórico.

   \* Se creó una instancia de \`MovimientoCuenta\` de tipo \`CARGO\_POR\_VENTA\` por el importe efectivo entregado (imputando primero unidades originales y luego adicionales aceptadas en \`UC-07\` por orden cronológico), actualizando el \*\*saldo confirmado\*\* de Cuenta Corriente y el \*\*saldo exigible provisional\*\* (descontando los pagos en tránsito validados).

   \* Se ejecutaron las postcondiciones de \`UC-15\` y se modificó \`unPedido.estado\` a \`ENTREGADO\`.

\---

\#\# 3\. Contrato de la Operación \`cancelarPedido\` (\`UC-06\` «include» \`UC-34\`, «extend» \`UC-26\`)

1\. \*\*Nombre:\*\* \`cancelarPedido(idPedido: Long, motivoCancelacion: String)\`

2\. \*\*Responsabilidades:\*\* Cancelar un \`Pedido\` en estado \`PENDIENTE\` (localizado mediante \`UC-34\`) registrando su motivo obligatorio, preservar como \`Excedente\` toda cantidad de Producto \`ELABORADO\` ya preparada o reasignada para dicho Pedido y activar por extensión condicional \`UC-26\` únicamente cuando exista un \`Cobro\` electrónico reembolsable.

3\. \*\*Tipo:\*\* \`Sistema\`

4\. \*\*Referencias cruzadas:\*\* Caso de Uso \`UC-06 — Cancelar Pedido\`; incluye \`UC-34 — Buscar Pedido\`; extendido condicionalmente por \`UC-26 — Procesar Reembolso Electrónico\`; Objetivos \`OBJE-01\`, \`OBJE-05\`, \`OBJE-13\`; Requisitos \`RF-01\`, \`RF-13\`, \`RF-20\`.

5\. \*\*Notas:\*\* No revierte consumos de Insumos (\`CONSUMO\_PRODUCCION\`). Si el Pedido tenía un Cobro manual previo, dicho monto permanece como saldo a favor en Cuenta Corriente sin salida automática de Caja.

6\. \*\*Excepciones:\*\*

   \* \*\*A1 — \`Pedido\` ya \`ENTREGADO\` o \`CANCELADO\`:\*\* Impedir cancelar nuevamente.

   \* \*\*A2 — \`motivoCancelacion\` ausente o vacío:\*\* Solicitar el motivo obligatorio antes de confirmar.

7\. \*\*Salida:\*\*

   \* Confirmación del \`Pedido\` en estado \`CANCELADO\`, detalle de \`Excedente\` preservados y estado del eventual inicio de reembolso electrónico (\`UC-26\`); o mensajes de las excepciones A1–A2.

8\. \*\*Precondiciones:\*\*

   \* El actor interno autorizado se encuentra autenticado y el \`Pedido\` seleccionado mediante \`UC-34\` está en estado \`PENDIENTE\`.

9\. \*\*Postcondiciones:\*\*

   \* Se modificaron \`unPedido.estado\` a \`CANCELADO\`, \`unPedido.motivoCancelacion\` y \`unPedido.fechaHoraCancelacion\`.

   \* Para cada \`Producto\` \`ELABORADO\` del Pedido que poseía unidades disponibles (preparadas en \`UC-28\` o recibidas en \`UC-07\`), se creó una instancia de \`Excedente\` en estado \`DISPONIBLE\` (\`origenGeneracion \= CANCELACION\`) conservando su costo histórico ponderado.

   \* Si existía un \`Cobro\` electrónico reembolsable asociado a \`unPedido\`, se invocó por extensión \`UC-26\`.

\---

\#\# 4\. Contrato de la Operación \`buscarExcedente\` (\`UC-61\`)

1\. \*\*Nombre:\*\* \`buscarExcedente(idProducto: Long\[0..1\], idPedidoOrigen: Long\[0..1\], fechaGeneracion: LocalDate\[0..1\], soloDisponibles: Boolean)\`

2\. \*\*Responsabilidades:\*\* Consultar y presentar los \`Excedente\` de Productos \`ELABORADO\` distinguiendo los remanentes disponibles (\`cantidadDisponible \> 0\`) de los agotados (\`cantidadDisponible \= 0\`), y devolver la referencia seleccionada al caso de uso invocante (\`UC-07\` o \`UC-41\`) sin reservar ni modificar existencias.

3\. \*\*Tipo:\*\* \`Sistema\`

4\. \*\*Referencias cruzadas:\*\* Caso de Uso \`UC-61 — Buscar Excedente\`; incluido por \`UC-07 — Ofrecer y Reasignar Excedente\` y \`UC-41 — Registrar Descarte de Excedente\` \*(relaciones aprobadas el 25/10/2026)\*; Objetivo \`OBJE-05\`; Requisito \`RF-13\`.

5\. \*\*Notas:\*\* Operación estrictamente de solo lectura. No reserva saldo ni expone costos internos restringidos al Vendedor.

6\. \*\*Excepciones:\*\*

   \* \*\*A1 — Criterios inválidos o Producto no \`ELABORADO\`:\*\* Solicitar corrección sin ejecutar cambios.

   \* \*\*A2 — Sin coincidencias:\*\* Informar lista vacía.

   \* \*\*A3 — Selección de un Excedente con \`cantidadDisponible \= 0\` para consumo comercial o descarte:\*\* Informar indisponibilidad operativa.

7\. \*\*Salida:\*\*

   \* Listado de \`Excedente\` coincidentes (\`idExcedente\`, \`Producto\` \`ELABORADO\`, \`idPedidoOrigen\`, \`fechaHoraGeneracion\`, \`cantidadInicial\`, \`cantidadDisponible\`) y referencia seleccionada; o mensajes de las excepciones A1–A3.

8\. \*\*Precondiciones:\*\*

   \* El actor (\`Vendedor\` o \`Responsable de Producción\`) se encuentra autenticado y autorizado.

9\. \*\*Postcondiciones:\*\*

   \* \*(Sin cambios de estado en el sistema: \`Excedente.cantidadDisponible\` y los movimientos históricos permanecen inalterados)\*.

\---

\#\# 5\. Contrato de la Operación \`registrarOfertaExcedente\` (\`UC-07\` — Parte A, «include» \`UC-61\`)

1\. \*\*Nombre:\*\* \`registrarOfertaExcedente(idExcedente: Long, idPedidoReceptor: Long, cantidadOfrecida: BigDecimal)\`

2\. \*\*Responsabilidades:\*\* Registrar una propuesta comercial (\`OfertaExcedente\`) para destinar una \`cantidadOfrecida\` de un \`Excedente\` disponible (previamente localizado mediante \`UC-61\`) a un \`Pedido\` receptor candidato en estado \`PENDIENTE\`, calculando el \`importeInformado\` sin reservar existencias ni modificar el Pedido receptor.

3\. \*\*Tipo:\*\* \`Sistema\`

4\. \*\*Referencias cruzadas:\*\* Caso de Uso \`UC-07 — Ofrecer y Reasignar Excedente\`; incluye \`UC-61 — Buscar Excedente\` \*(relación aprobada el 25/10/2026)\*; Objetivo \`OBJE-05\`; Requisito \`RF-13\`.

5\. \*\*Notas:\*\* Se separa como contrato individual (\`H-11\`) porque el registro de la oferta aún no transfiere unidades ni descuenta \`Excedente.cantidadDisponible\`.

6\. \*\*Excepciones:\*\*

   \* \*\*A1 — \`Excedente\` sin disponibilidad (\`cantidadDisponible \<= 0\`) o \`cantidadOfrecida \<= 0\` o superior a \`cantidadDisponible\`:\*\* Rechazar la oferta.

   \* \*\*A2 — \`Pedido\` receptor no \`PENDIENTE\` o sin \`PrecioProducto\` vigente válido para calcular el importe:\*\* Impedir el registro de la oferta.

7\. \*\*Salida:\*\*

   \* Confirmación de la \`OfertaExcedente\` registrada (\`idOfertaExcedente\`) y del \`importeInformado\` al Cliente; o mensajes de las excepciones A1–A2.

8\. \*\*Precondiciones:\*\*

   \* El \`Vendedor\` se encuentra autenticado y autorizado, el \`Excedente\` seleccionado mediante \`UC-61\` está \`DISPONIBLE\` con \`cantidadDisponible \> 0\` y el \`Pedido\` receptor está \`PENDIENTE\`.

9\. \*\*Postcondiciones:\*\*

   \* Se creó una instancia \`unaOferta\` de \`OfertaExcedente\` con \`cantidadOfrecida\`, \`importeInformado\`, \`fechaHoraOferta\` y respuesta pendiente, asociada al \`Excedente\`, al \`Pedido\` receptor y al \`Usuario\` Vendedor.

   \* Se conservaron inalterados \`Excedente.cantidadDisponible\` y el \`Pedido\` receptor.

\---

\#\# 6\. Contrato de la Operación \`registrarRespuestaOfertaExcedente\` (\`UC-07\` — Parte B, «include» \`UC-61\`)

1\. \*\*Nombre:\*\* \`registrarRespuestaOfertaExcedente(idOfertaExcedente: Long, aceptada: Boolean, cantidadAceptada: BigDecimal\[0..1\])\`

2\. \*\*Responsabilidades:\*\* Registrar la respuesta del Cliente a una \`OfertaExcedente\` y, cuando es aceptada, revalidar disponibilidad bajo control de concurrencia, incorporar las unidades aceptadas como adicionales al \`Pedido\` receptor con su \`importeAceptado\` (sin alterar \`cantidadOriginal\` ni \`totalOriginal\` y sin volver a preparar ni ejecutar \`UC-15\`/\`UC-16\`), transferir el costo histórico mediante \`MovimientoExcedente\` (\`REASIGNACION\`) y descontar \`Excedente.cantidadDisponible\`.

3\. \*\*Tipo:\*\* \`Sistema\`

4\. \*\*Referencias cruzadas:\*\* Caso de Uso \`UC-07 — Ofrecer y Reasignar Excedente\`; incluye \`UC-61 — Buscar Excedente\` \*(relación aprobada el 25/10/2026)\*; Objetivo \`OBJE-05\`; Requisito \`RF-13\`.

5\. \*\*Notas:\*\* Si \`cantidadAceptada\` cambia respecto de \`cantidadOfrecida\`, se recalcula el importe y se exige aceptación del nuevo importe antes de confirmar.

6\. \*\*Excepciones:\*\*

   \* \*\*A1 — \`aceptada \== false\` (Rechazo del Cliente):\*\* Registrar la respuesta rechazada en \`OfertaExcedente\` sin transferir unidades ni modificar \`Excedente.cantidadDisponible\`.

   \* \*\*A2 — \`cantidadAceptada \<= 0\`, superior a \`Excedente.cantidadDisponible\` actual (por concurrencia) o importe recalculado sin nueva aceptación:\*\* Rechazar la confirmación de transferencia.

   \* \*\*A3 — El \`Pedido\` receptor dejó de estar \`PENDIENTE\` o el costo histórico no es determinable:\*\* Impedir la transferencia parcial.

7\. \*\*Salida:\*\*

   \* Confirmación de la reasignación trazable, nuevo \`totalVigente\` derivado del \`Pedido\` receptor y estado resultante del \`Excedente\` (\`DISPONIBLE\` o \`AGOTADO\`); o constancia de rechazo / mensajes de las excepciones A1–A3.

8\. \*\*Precondiciones:\*\*

   \* El \`Vendedor\` se encuentra autenticado y autorizado, y existe la \`OfertaExcedente\` pendiente de resolución.

9\. \*\*Postcondiciones:\*\*

   \* \*\*Si \`aceptada \== true\`:\*\*

     \* Se modificaron en \`unaOferta\` los atributos de respuesta aceptada, \`cantidadAceptada\`, \`importeAceptado\` y \`fechaHoraRespuesta\`.

     \* Se incorporaron las unidades adicionales y su \`importeAceptado\` al \`Pedido\` receptor sin modificar \`DetallePedido.cantidadOriginal\`, \`Pedido.totalOriginal\`, Promoción original ni ajuste comercial global, permitiendo derivar \`Pedido.totalVigente\`.

     \* Se creó una instancia de \`MovimientoExcedente\` con \`tipoMovimiento \= REASIGNACION\`, \`cantidad \= cantidadAceptada\`, \`costoHistoricoSalida\` proporcional y \`fechaHoraMovimiento\`, asociada a \`unExcedente\` y a \`unaOferta\`.

     \* Se decrementó \`unExcedente.cantidadDisponible\` en \`cantidadAceptada\` y se actualizó su estado a \`DISPONIBLE\` (si \`\> 0\`) o \`AGOTADO\` (si \`= 0\`).

   \* \*\*Si \`aceptada \== false\`:\*\*

     \* Se modificó \`unaOferta\` registrando el rechazo y su \`fechaHoraRespuesta\`, conservando intactos \`unExcedente.cantidadDisponible\` y el \`Pedido\` receptor.

\---

\#\# 7\. Contrato de la Operación \`registrarDescarteExcedente\` (\`UC-41\` «include» \`UC-61\`)

1\. \*\*Nombre:\*\* \`registrarDescarteExcedente(idExcedente: Long, cantidadDescartada: BigDecimal, motivoDescarte: String)\`

2\. \*\*Responsabilidades:\*\* Registrar un \`MovimientoExcedente\` de tipo \`DESCARTE\` sobre un \`Excedente\` disponible (previamente localizado mediante \`UC-61\`) con su motivo obligatorio y su costo histórico proporcional, reduciendo atómicamente \`Excedente.cantidadDisponible\`.

3\. \*\*Tipo:\*\* \`Sistema\`

4\. \*\*Referencias cruzadas:\*\* Caso de Uso \`UC-41 — Registrar Descarte de Excedente\`; incluye \`UC-61 — Buscar Excedente\` \*(relación aprobada el 25/10/2026)\*; Objetivos \`OBJE-05\`, \`OBJE-07\`; Requisito \`RF-13\`.

5\. \*\*Notas:\*\* No revierte la \`Preparacion\` histórica ni reintegra \`Insumo\` al inventario.

6\. \*\*Excepciones:\*\*

   \* \*\*A1 — \`cantidadDescartada \<= 0\` o superior a \`Excedente.cantidadDisponible\` actual (por concurrencia):\*\* Solicitar corrección sin registrar descarte parcial.

   \* \*\*A2 — \`motivoDescarte\` ausente o vacío:\*\* Impedir confirmar el descarte.

   \* \*\*A3 — Costo histórico no determinable:\*\* Rechazar la operación sin inventar costo cero.

7\. \*\*Salida:\*\*

   \* Confirmación del descarte registrado (\`idMovimiento\`), cantidad remanente, estado del \`Excedente\` (\`DISPONIBLE\` \| \`AGOTADO\`), motivo y costo histórico trazado; o mensajes de las excepciones A1–A3.

8\. \*\*Precondiciones:\*\*

   \* El \`Responsable de Producción\` se encuentra autenticado y autorizado, y existe el \`Excedente\` \`DISPONIBLE\` seleccionado mediante \`UC-61\` con \`cantidadDisponible \> 0\`.

9\. \*\*Postcondiciones:\*\*

   \* Se creó una instancia de \`MovimientoExcedente\` con \`tipoMovimiento \= DESCARTE\`, \`cantidad \= cantidadDescartada\`, \`motivoDescarte\`, \`costoHistoricoSalida\` proporcional y \`fechaHoraMovimiento\`, asociada a \`unExcedente\`.

   \* Se decrementó \`unExcedente.cantidadDisponible\` en \`cantidadDescartada\` y se redujo proporcionalmente \`unExcedente.costoHistoricoDisponible\`.

   \* Si \`unExcedente.cantidadDisponible \== 0\`, su estado quedó en \`AGOTADO\`; si permaneció \`\> 0\`, quedó en \`DISPONIBLE\`.

\---

\#\# 8\. Glosario de Términos Asociados (\`REV-04B\`)

\* \*\*\`Entrega\` (Tipo / Concepto — Tabla \`ENTREGA\`):\*\* Registro definitivo de las cantidades entregadas al Cliente en \`UC-05\` que origina el \`CARGO\_POR\_VENTA\` efectivo en Cuenta Corriente.

\* \*\*\`Efectivo en Tránsito Validado\` (Concepto de Dominio — \`RD-F04\` / \`RD-RP028\`):\*\* Importe en efectivo declarado por el \`Repartidor\` al registrar la \`Entrega\` (\`UC-05\`) que reduce el saldo exigible provisional del Cliente (\`UC-14\`), pero que no constituye un \`Cobro\` confirmado (\`UC-29\`) ni ingresa en \`Caja\` hasta su rendición formal ante Vendedor o Administrador.

\* \*\*\`Excedente\` (Tipo / Concepto — Tabla \`EXCEDENTE\`):\*\* Remanente trazable de un Producto \`ELABORADO\` ya preparado originado por entrega parcial (\`UC-05\`) o cancelación (\`UC-06\`), con estado \`DISPONIBLE\` o \`AGOTADO\`.

\* \*\*\`OfertaExcedente\` (Tipo / Concepto — Tabla \`OFERTA\_EXCEDENTE\`):\*\* Propuesta comercial registrada en \`UC-07\` para ofrecer unidades de un \`Excedente\` a un \`Pedido\` receptor en estado \`PENDIENTE\`.

\* \*\*\`MovimientoExcedente\` (Tipo / Concepto — Tabla \`MOVIMIENTO\_EXCEDENTE\`):\*\* Salida trazable de un \`Excedente\` por \`REASIGNACION\` (\`UC-07\`) o por \`DESCARTE\` (\`UC-41\`) que conserva el costo histórico proporcional afectado.

### **Estado Acumulado y Próximo Paso: Lote 5 (`REV-05 — Finanzas y Consultas`)**

Con `REV-04A` y `REV-04B` completados, quedaron íntegramente corregidos y auditados los **12 Casos de Uso de Pedidos, Reparto, Entregas y Excedentes** (`UC-03`, `UC-04`, `UC-05`, `UC-06`, `UC-07`, `UC-21`, `UC-25`, `UC-28`, `UC-34`, `UC-41`, `UC-43`, `UC-61`).

El siguiente paso del plan de trabajo es el **Lote 5 (`REV-05 — Finanzas y Consultas`: `UC-14`, `UC-22`, `UC-23`, `UC-26`, `UC-27`, `UC-29`, `UC-49` — 7 Casos de Uso)**, donde resolveremos:

* **`H-03` (`RD-RP004/RP028-001` en `UC-14`):** Diferenciar explícitamente en `UC-14 — Consultar Cuenta Corriente` el **saldo confirmado**, los **pagos/efectivo en tránsito validados** y el **saldo exigible provisional**.  
* **`H-04` (`RD-RP004/RP028-001` en `UC-27`):** Incorporar en `UC-27 — Consultar Margen Bruto` tanto la consulta **por período** como la consulta **por venta individual**.  
* **`H-10` (`RD-F01` y `MR-6` en `UC-29`):** Restringir `COBRO.estadoCobro` a los literales aprobados `CONFIRMADO` y `ANULADO` y formalizar el contraasiento de anulación (`ANULACION_COBRO`).

¿Avanzamos con el paquete completo del **Lote 5 (`REV-05 — Finanzas y Consultas` — 7 CU)**?

