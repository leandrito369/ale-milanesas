Paquete Completo de Revisión Transversal — Lote 6A (REV-06A: Comercial, Catálogo de Productos, Precios y Promociones)  
Aplicando la metodología reproducible de ocho etapas (M-0 a M-7) establecida en REV01\_AUDITORIA\_TRANSVERSAL\_CIERRE\_2026-10-28.md y corrigiendo transversalmente los hallazgos de AUDITORIA\_PREINTEGRACION\_GEMINI\_DSS\_DS\_CONTRATOS\_2026-10-27.md, entrego la primera mitad del Lote 6 (REV-06A: UC-35, UC-30, UC-47, UC-48, UC-19, UC-20, UC-24, UC-59, UC-60 — 9 Casos de Uso).     
MD  
\+ 4

Archivo 1: docs/08-diagramas/revision/REV06A\_AUDITORIA\_TRANSVERSAL\_COMERCIAL\_PROMOCIONES\_2026-10-28.md  
Markdown  
\# REV-06A — Auditoría Transversal y Corrección: Catálogo de Productos, Precios y Promociones (UC-35, UC-30, UC-47, UC-48, UC-19, UC-20, UC-24, UC-59, UC-60)

\*\*Fecha:\*\* 28/10/2026    
\*\*Rama de trabajo propuesta:\*\* \`revision/rev06a-comercial-promociones-2026-10-28\`    
\*\*Alcance (\`REV-06A\`):\*\* \`UC-35\`, \`UC-30\`, \`UC-47\` («include» \`UC-35\`), \`UC-48\` («include» \`UC-35\`), \`UC-19\` («include» \`UC-35\`), \`UC-20\` («include» \`UC-35\`), \`UC-24\` («include» \`UC-35\`), \`UC-59\`, \`UC-60\`.    
\*\*Estado de los artefactos entregados:\*\* \`PROPUESTO / CORREGIDO EN REVISIÓN ESTÁTICA\` (pendiente de inspección visual humana en Draw.io y aprobación para fusión a \`main\`).

\---

\#\# 1\. Ejecución de las 8 Etapas Metodológicas (M-0 a M-7)

\#\#\# M-0 — Autoridad y alcance congelados  
\* \*\*Catálogo funcional vigente:\*\* 64 CU consecutivos (\`UC-01\`..\`UC-64\`) en 3 niveles (\`ALE\_MILANESAS\_FASE\_4\_CU\_01\_A\_64\_TRES\_NIVELES.docx\`), respetando la denominación canónica de Fase 4 \*\*\`UC-30 — Gestionar Producto\`\*\*.  
\* \*\*Relaciones UML aprobadas en este sublote:\*\* \`UC-47 → UC-35\` (\`include\`), \`UC-48 → UC-35\` (\`include\`), \`UC-19 → UC-35\` (\`include\`), \`UC-20 → UC-35\` (\`include\`) y \`UC-24 → UC-35\` (\`include\`). El archivo \`DIAGRAMA DE CASOS DE USO.drawio (1).xml\` permanece intacto.  
\* \*\*Decisiones posteriores incorporadas (Corte 27/10/2026):\*\*  
  \* \*\*\`RD-RP023-001\` (resuelve Hallazgo de Prioridad Alta \`H-06\`):\*\*  
    1\. En \`UC-24 — Crear y Comunicar Promoción\`, pueden coexistir múltiples promociones activas cuyos períodos de vigencia, Productos (\`PROMOCION\_PRODUCTO\`) y Clientes destinatarios (\`DESTINATARIO\_PROMOCION\`) se superpongan parcial o totalmente, pero \*\*queda prohibida la acumulación de descuentos promocionales sobre las mismas unidades\*\*.  
    2\. Cuando un Cliente destinatario opera en \`UC-21\`, el sistema evalúa las promociones vigentes y elegibles para cada Producto, selecciona automáticamente la de \*\*mayor beneficio aplicable (mayor \`porcentajeDescuento\` elegible)\*\* y congela ese único descuento en el detalle del Pedido (antes de aplicar el ajuste por categoría comercial \`UC-16\`).  
    3\. En \`UC-60 — Desactivar Promoción\`, las correcciones de una campaña se realizan desactivándola y registrando otra nueva mediante \`UC-24\`, sin sobrescribir condiciones ya utilizadas ni recalcular descuentos congelados en Pedidos ya confirmados.  
  \* \*\*Restricción \`F08\` (Estados de \`PROMOCION\`):\*\* Se respetan los cinco estados aprobados (\`BORRADOR\`, \`ACTIVA\`, \`PAUSADA\`, \`FINALIZADA\`, \`CANCELADA\`) y \*\*no se concede ningún permiso ni operación de reactivación desde \`PAUSADA\`\*\*, ya que no existe Caso de Uso aprobado para ello.  
  \* \*\*\`RD-RP007-002\` (resuelve Hallazgo \`H-17\` en \`UC-35\`):\*\* Se restringe el alcance de \`UC-35 — Buscar Producto\` a los roles autorizados (\`Administrador\` y \`Vendedor\`), eliminando cualquier atribución de \`UC-35\` al actor \`Responsable de Producción\`.

\#\#\# M-1 — Proveniencia, integridad y matriz de diferencias (Antes → Después)

\| ID Hallazgo \| Artefacto / Celda Original \| Antes (Borrador 26–27/10) \| Después (Versión Corregida \`REV06A\`) \| Fundamento \|  
\| :--- \| :--- \| :--- \| :--- \| :--- \|  
\| \*\*\`H-06\` (Alta)\*\* \| \`DSS Admin 6C\` (\`a3\_m1\`), \`DS UC-24\` y \`Contrato 6C.1\` \| No explicitaba la regla de coexistencia sin acumulación ni el congelamiento del mejor beneficio aplicable. \| Incorpora en \`DSS\`, \`DS UC-24\`, \`DS UC-60\` y Contratos la regla \`RD-RP023-001\`: coexistencia de campañas sin acumulación sobre las mismas unidades, selección del mayor beneficio aplicable en \`UC-21\` e inmutabilidad de descuentos congelados. \| \`RD-RP023-001\` \|  
\| \*\*\`H-17\` (Media)\*\* \| \`DS UC-35\` y \`DSS Producción\` \| Usaba actor genérico o incluía \`UC-35\` en el título del DSS de Producción. \| Restringe \`UC-35\` a \`Administrador\` y \`Vendedor\` conforme a la matriz RBAC aprobada (\`RD-RP007-002\`). \| \`RD-RP007-002\` / \`H-17\` \|  
\| \*\*\`M-5\` (Tablas inexistentes en MR-3)\*\* \| \`DSS Admin 6A\` (\`a1\_r11\`) y \`DSS Admin 6C\` (\`a3\_r3\`) \| Mencionaba \`HISTORIAL\_ESTADO\_PRODUCTO\`, \`PRODUCTO\_PROMOCION\`, \`INTENTO\_COMUNICACION\_PROMOCION\` y \`CAMBIO\_ESTADO\_PROMOCION\`. \| Se eliminan las tablas inexistentes y se usan exactamente las tablas reales de MR-3 y de las Fichas Fase 4 (\`PRODUCTO.activo\`, \`PROMOCION\`, \`PROMOCION\_PRODUCTO\`, \`DESTINATARIO\_PROMOCION\`, \`INTENTO\_COMUNICACION\`). \| Fichas Fase 4 y Diccionario MR-3 \|  
\| \*\*\`H-11\` (Media)\*\* \| \`Contrato 6A.4\` (6 CU agrupados) y \`Contrato 6C.1\` (3 CU agrupados) \| Agrupaba 8 casos de uso de este lote en solo 2 contratos compuestos. \| Se desagrupan en \*\*9 Contratos individuales\*\* (\`UC-35\`, \`UC-30\`, \`UC-47\`, \`UC-48\`, \`UC-19\`, \`UC-20\`, \`UC-24\`, \`UC-59\`, \`UC-60\`), cada uno con sus 9 secciones estándar. \| Puerta \`G4\` / \`H-11\` \|  
\| \*\*\`H-12\`, \`H-19\`, \`H05\`\*\* \| \`DSS\`, \`DS\` y \`Contratos\` \| Secuencia continua en el DSS y firmas divergentes entre DSS, DS y Contrato. \| Marcos \`sd\` independientes por CU en el DSS, lenguaje de caja negra y homologación 1:1 de las 9 firmas públicas entre DSS, DS (\`1:\`) y Contratos. \| \`M-3\`, \`H-12\`, \`H-19\`, \`H05\` \|

\---

\#\# 2\. Matriz de Trazabilidad Vertical y Visibilidad de Larman Mensaje por Mensaje (M-3 y M-6)

\| CU \| Paso / Mensaje en DS \| Emisor \$\\rightarrow\$ Receptor \| Tipo de Visibilidad (Larman) \| Origen verificable de la referencia \|  
\| :--- \| :--- \| :--- \| :--- \| :--- \|  
\| \*\*\`UC-35\`\*\* \| \`1: buscarProducto(idProducto, nombre, tipoProducto, activo)\` \| \`Vendedor / Administrador\` \$\\rightarrow\$ \`:ControladorCatalogo\` \| Frontera de sistema \| Operación pública homologada del DSS (\`UC-35\`, excluyendo a Producción según \`RD-RP007-002\`). \|  
\| \*\*\`UC-35\`\*\* \| \`2: lista \= consultarProductosPorCriterios(idProducto, nombre, tipoProducto, activo)\` \| \`:ControladorCatalogo\` \$\\rightarrow\$ \`:CatalogoProductos\` \| \*\*Por Atributo\*\* \| Repositorio de Productos inyectado en el controlador. \|  
\| \*\*\`UC-30\`\*\* \| \`1: gestionarProducto(nombre, descripcion, tipoProducto, codigoUnidadVenta)\` \| \`Administrador\` \$\\rightarrow\$ \`:ControladorCatalogo\` \| Frontera de sistema \| Operación pública homologada del DSS (\`UC-30\`). \|  
\| \*\*\`UC-30\`\*\* \| \`2: prodExistente \= buscarPorNombreNormalizado(nombreNormalizado)\` \| \`:ControladorCatalogo\` \$\\rightarrow\$ \`:CatalogoProductos\` \| \*\*Por Atributo\*\* \| Verifica unicidad de \`nombreNormalizado\` entre Productos activos e inactivos. \|  
\| \*\*\`UC-30\`\*\* \| \`3: «create» new(nombre, nombreNormalizado, descripcion, tipoProducto, codigoUnidadVenta, activo=true)\` \| \`:ControladorCatalogo\` \$\\rightarrow\$ \`nuevoProd : Producto\` \| \*\*Por Creación Local (\`new\`)\*\* \| Instancia el \`Producto\` con \`activo \= true\` (el precio vigente se administra en \`UC-19\` y la Receta en \`UC-10\`). \|  
\| \*\*\`UC-47\`\*\* \| \`1: modificarProducto(idProducto, nuevoNombre, descripcion, tipoProductoPropuesto, codigoUnidadVentaPropuesto)\` \| \`Administrador\` \$\\rightarrow\$ \`:ControladorCatalogo\` \| Frontera de sistema \| Operación pública homologada del DSS (\`UC-47\`, precedida por \`«include» UC-35\`). \|  
\| \*\*\`UC-47\`\*\* \| \`2: (unProducto, tieneHistorial, nombreDup) \= revalidarUnicidadYRestriccionesHistorial(idProducto, nuevoNombreNormalizado)\` \| \`:ControladorCatalogo\` \$\\rightarrow\$ \`:CatalogoProductos\` \| \*\*Por Atributo\*\* \| Verifica que no duplique otro \`nombreNormalizado\` y si existen precios, pedidos, recetas o movimientos dependientes. \|  
\| \*\*\`UC-47\`\*\* \| \`3: actualizarDatosPermitidos(nuevoNombre, nuevoNombreNormalizado, descripcion, tipoProductoPropuesto, codigoUnidadVentaPropuesto)\` \| \`:ControladorCatalogo\` \$\\rightarrow\$ \`unProducto : Producto\` \| \*\*Por Variable Local\*\* \| Actualiza solo los datos permitidos bloqueando el cambio de tipo o unidad cuando \`tieneHistorial \== true\` (Ficha Fase 4 \`UC-47\`). \|  
\| \*\*\`UC-48\`\*\* \| \`1: cambiarEstadoProducto(idProducto, nuevoActivo)\` \| \`Administrador\` \$\\rightarrow\$ \`:ControladorCatalogo\` \| Frontera de sistema \| Operación pública homologada del DSS (\`UC-48\`, precedida por \`«include» UC-35\`). \|  
\| \*\*\`UC-48\`\*\* \| \`2: establecerEstadoActivo(nuevoActivo)\` \| \`:ControladorCatalogo\` \$\\rightarrow\$ \`unProducto : Producto\` \| \*\*Por Variable Local\*\* \| Actualiza \`Producto.activo\` preservando los Pedidos \`PENDIENTE\` abiertos (\`F09\`). \|  
\| \*\*\`UC-19\`\*\* \| \`1: actualizarPrecioVigente(idProducto, nuevoPrecioBase, vigenteDesde, vigenteHasta)\` \| \`Administrador\` \$\\rightarrow\$ \`:ControladorCatalogo\` \| Frontera de sistema \| Operación pública homologada del DSS (\`UC-19\`, precedida por \`«include» UC-35\`). \|  
\| \*\*\`UC-19\`\*\* \| \`2: «create» new(unProducto, nuevoPrecioBase, vigenteDesde, vigenteHasta, idAdmin) \+ new AuditoriaPrecio(...)\` \| \`:ControladorCatalogo\` \$\\rightarrow\$ \`nuevoPrecio : PrecioProducto\` / \`evAud : AuditoriaPrecio\` \| \*\*Por Creación Local (\`new\`) \+ Parámetro\*\* \| Cierra la vigencia previa sin solapamiento, crea el nuevo \`PrecioProducto\` y registra \`AuditoriaPrecio\`. \|  
\| \*\*\`UC-20\`\*\* \| \`1: consultarHistorialPrecios(idProducto, fechaDesde, fechaHasta)\` \| \`Administrador\` \$\\rightarrow\$ \`:ControladorCatalogo\` \| Frontera de sistema \| Operación pública homologada del DSS (\`UC-20\`, precedida por \`«include» UC-35\`). \|  
\| \*\*\`UC-20\`\*\* \| \`2: historial \= recuperarPreciosYAuditoriaOrdenados(idProducto, fechaDesde, fechaHasta)\` \| \`:ControladorCatalogo\` \$\\rightarrow\$ \`:CatalogoProductos\` \| \*\*Por Atributo\*\* \| Consulta cronológica en modo solo lectura de \`PrecioProducto\` y \`AuditoriaPrecio\`. \|  
\| \*\*\`UC-24\`\*\* \| \`1: crearYComunicarPromocion(descripcion, porcentajeDescuento, vigenteDesde, vigenteHasta, idsProductos, idsClientesDestinatarios)\` \| \`Administrador\` \$\\rightarrow\$ \`:ControladorPromociones\` \| Frontera de sistema \| Operación pública homologada del DSS (\`UC-24\`, precedida por \`«include» UC-35\`). \|  
\| \*\*\`UC-24\`\*\* \| \`2: «create» new(descripcion, porcentajeDescuento, vigenteDesde, vigenteHasta, prodsActivos, destsActivos)\` \| \`:ControladorPromociones\` \$\\rightarrow\$ \`nuevaPromo : Promocion\` \| \*\*Por Creación Local (\`new\`) \+ Parámetro\*\* \| Crea \`Promocion\` (\`PROMOCION\_PRODUCTO\` y \`DESTINATARIO\_PROMOCION\`), genera referencia de acceso online y registra cada \`IntentoComunicacion\` vía \`:AdaptadorMensajeria\`. \|  
\| \*\*\`UC-59\`\*\* \| \`1: consultarPromociones(idPromocion, vigenteDesde, vigenteHasta, estado, idProducto)\` \| \`Administrador\` \$\\rightarrow\$ \`:ControladorPromociones\` \| Frontera de sistema \| Operación pública homologada del DSS (\`UC-59\`). \|  
\| \*\*\`UC-59\`\*\* \| \`2: lista \= buscarPromocionesYComunicaciones(filtro)\` \| \`:ControladorPromociones\` \$\\rightarrow\$ \`:CatalogoPromociones\` \| \*\*Por Atributo\*\* \| Recupera en modo solo lectura \`Promocion\`, \`PromocionProducto\`, \`DestinatarioPromocion\` e \`IntentoComunicacion\` sin reenviar mensajes. \|  
\| \*\*\`UC-60\`\*\* \| \`1: desactivarPromocion(idPromocion)\` \| \`Administrador\` \$\\rightarrow\$ \`:ControladorPromociones\` \| Frontera de sistema \| Operación pública homologada del DSS (\`UC-60\`). \|  
\| \*\*\`UC-60\`\*\* \| \`2: desactivarParaUsosFuturos()\` \| \`:ControladorPromociones\` \$\\rightarrow\$ \`unaPromocion : Promocion\` \| \*\*Por Variable Local\*\* \| Retira la promoción de usos futuros en \`UC-21\` sin alterar los descuentos congelados en Pedidos ya confirmados (\`RD-RP023-001\` / \`F08\`). \|

\---

\#\# 3\. Matriz Transversal de Invariantes y Puertas de Aceptación (M-4 y M-7)

\| ID \| Invariante ratificada \| DSS \| DS \| Contrato \| Dictamen \|  
\| :--- \| :--- \| :--- \| :--- \| :--- \| :--- \|  
\| \*\*\`I-01\`\*\* \| \`RD-RP023-001\` (\`H-06\`): Coexistencia de promociones sin acumulación sobre las mismas unidades, selección del mayor beneficio aplicable en \`UC-21\`, congelamiento en el Pedido e inmutabilidad al desactivar en \`UC-60\` \| Notas y respuestas en \`DSS UC-24\` y \`UC-60\` \| \`DS UC-24\` y \`DS UC-60\` \| Contratos \`7\` (\`UC-24\`) y \`9\` (\`UC-60\`) \| \*\*PASÓ (Trazabilidad estática)\*\* \|  
\| \*\*\`I-02\`\*\* \| \`F08\` y Ficha Fase 4 \`UC-59\` / \`UC-60\`: Cinco estados de \`PROMOCION\` (\`BORRADOR\`, \`ACTIVA\`, \`PAUSADA\`, \`FINALIZADA\`, \`CANCELADA\`), consulta de \`INTENTO\_COMUNICACION\` sin reenvíos y prohibición de reactivar campañas desactivadas \| Marcos \`UC-59\` y \`UC-60\` \| \`DS UC-59\` y \`DS UC-60\` \| Contratos \`8\` y \`9\` \| \*\*PASÓ (Trazabilidad estática)\*\* \|  
\| \*\*\`I-03\`\*\* \| Ficha Fase 4 \`UC-47\`: Bloqueo de cambio de \`tipoProducto\` o \`codigoUnidadVenta\` cuando exista historia dependiente, indicando crear un Producto nuevo mediante \`UC-30\` \| Guarda de rechazo en \`DSS UC-47\` \| Operando de rechazo en \`DS UC-47\` \| Excepción A3 en \`CONTRATO\_UC47\` \| \*\*PASÓ (Trazabilidad estática)\*\* \|  
\| \*\*\`I-04\`\*\* \| \`RD-RP007-002\` (\`H-17\`): Exclusión del actor \`Responsable de Producción\` en \`UC-35 — Buscar Producto\` \| Actor \`Vendedor / Administrador\` en \`DSS UC-35\` \| Actor \`Vendedor / Administrador\` en \`DS UC-35\` \| Precondiciones de \`CONTRATO\_UC35\` \| \*\*PASÓ\*\* \|  
\| \*\*\`I-05\`\*\* \| Homologación 1:1 de firmas públicas DSS ↔ DS ↔ Contrato y desagrupamiento en 9 contratos individuales (\`H-11\`, \`H05\`) \| 9 firmas canónicas \| Mensaje \`1:\` idéntico en las 9 páginas DS \| 9 Contratos individuales con 9 secciones \| \*\*PASÓ\*\* \|  
\| \*\*\`I-06\`\*\* \| Inspección visual y prueba de desplazamiento (\`round-trip\`) en editor gráfico Draw.io (\`M-6\` / \`G5\`) \| XML bien formado \| XML bien formado \| N/A \| \*\*PENDIENTE DE VALIDACIÓN HUMANA EN DRAW.IO\*\* \|  
Archivo 2: docs/08-diagramas/revision/DSS\_REV06A\_COMERCIAL\_PROMOCIONES\_FRAGMENTOS.drawio.xml  
Este archivo XML compatible con Draw.io modela en 2 páginas los escenarios de caja negra (DSS) de UC-35, UC-30, UC-47, UC-48, UC-19 y UC-20 (Página 1: Catálogo de Productos y Precios) y UC-24, UC-59 y UC-60 (Página 2: Promociones con :ServicioDeMensajeria), encapsulados en marcos sd independientes (H-12), sin lenguaje SQL interno (H-19) y aplicando RD-RP023-001 (H-06) y RD-RP007-002 (H-17):     
MD  
\+ 2

XML  
\<mxfile host="app.diagrams.net" modified="2026-10-28T13:15:00.000Z" agent="Gemini-REV06A" version="24.7.17" type="device"\>  
  \<\!-- \========================================================================= \--\>  
  \<\!-- PÁGINA 1: DSS CAJA NEGRA — PRODUCTOS Y PRECIOS (UC-35,30,47,48,19,20)     \--\>  
  \<\!-- \========================================================================= \--\>  
  \<diagram id="dss-rev06a-catalogo" name="DSS REV06A \- Productos y Precios (UC-35,30,47,48,19,20)"\>  
    \<mxGraphModel dx="1500" dy="950" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1450" pageHeight="1850" math="0" shadow="0"\>  
      \<root\>  
        \<mxCell id="0" /\>  
        \<mxCell id="1" parent="0" /\>

        \<mxCell id="c1\_title" value="DSS (Caja Negra — REV06A) — Escenarios Independientes UC-35 \[RD-RP007-002\], UC-30, UC-47, UC-48, UC-19 y UC-20" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=13;fontStyle=1" vertex="1" parent="1"\>  
          \<mxGeometry x="50" y="15" width="1300" height="30" as="geometry" /\>  
        \</mxCell\>

        \<mxCell id="c1\_actor" value="Administrador&\#xa;(y Vendedor en UC-35)" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="110" y="60" width="30" height="60" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="c1\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="119" y="155" width="12" height="1630" as="geometry" /\>  
        \</mxCell\>

        \<mxCell id="c1\_sys\_box" value=":Sistema" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;fontSize=13;" vertex="1" parent="1"\>  
          \<mxGeometry x="960" y="60" width="140" height="45" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="c1\_sys\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="1030" y="1810" as="sourcePoint" /\>  
            \<mxPoint x="1030" y="105" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="c1\_sys\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="1024" y="155" width="12" height="1630" as="geometry" /\>  
        \</mxCell\>

        \<\!-- MARCO UC-35 \--\>  
        \<mxCell id="c1\_sd35" value="sd Escenario Independiente — UC-35: Buscar Producto (Roles autorizados: Administrador y Vendedor — RD-RP007-002)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=710;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>  
          \<mxGeometry x="50" y="170" width="1120" height="190" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="c1\_35\_m1" value="1: productos \= buscarProducto(idProducto:Long\[0..1\], nombre:String\[0..1\], tipoProducto:String\[0..1\], activo:Boolean\[0..1\])" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="131" y="220" as="sourcePoint" /\>  
            \<mxPoint x="1024" y="220" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="c1\_35\_r1" value="1.1: presenta Productos coincidentes (idProducto, nombre, descripción, tipoProducto ELABORADO\|REVENTA, codigoUnidadVenta, activo) y devuelve el seleccionado al CU invocante" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="1024" y="305" as="sourcePoint" /\>  
            \<mxPoint x="131" y="305" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>

        \<\!-- MARCO UC-30 \--\>  
        \<mxCell id="c1\_sd30" value="sd Escenario Independiente — UC-30: Gestionar Producto (Denominación canónica Fase 4)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=560;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>  
          \<mxGeometry x="50" y="385" width="1120" height="240" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="c1\_30\_m1" value="1: idProducto \= gestionarProducto(nombre:String, descripcion:String\[0..1\], tipoProducto:String, codigoUnidadVenta:String)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="131" y="435" as="sourcePoint" /\>  
            \<mxPoint x="1024" y="435" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="c1\_30\_r1" value="1.1: \[Nombre normalizado único respecto de activos e inactivos y campos válidos\] registra Producto con activo \= true" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="1024" y="505" as="sourcePoint" /\>  
            \<mxPoint x="131" y="505" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="c1\_30\_r2" value="1.2: \[Nombre normalizado duplicado en activo o inactivo\] no crea duplicado y presenta el Producto existente" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="1024" y="580" as="sourcePoint" /\>  
            \<mxPoint x="131" y="580" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>

        \<\!-- MARCO UC-47 (+ INCLUDE UC-35) \--\>  
        \<mxCell id="c1\_sd47" value="sd Escenario Independiente — UC-47: Modificar Producto (con «include» UC-35)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=520;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>  
          \<mxGeometry x="50" y="650" width="1120" height="310" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="c1\_47\_ref35" value="ref «include» UC-35 Buscar Producto (selecciona el Producto y presenta sus datos y restricciones por historial)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=260;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex="1" parent="1"\>  
          \<mxGeometry x="90" y="685" width="760" height="50" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="c1\_47\_m1" value="1: ok \= modificarProducto(idProducto:Long, nuevoNombre:String, descripcion:String\[0..1\], tipoProductoPropuesto:String, codigoUnidadVentaPropuesto:String)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="131" y="770" as="sourcePoint" /\>  
            \<mxPoint x="1024" y="770" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="c1\_47\_r1" value="1.1: \[Nombre único y sin cambio de tipo/unidad con historial dependiente\] actualiza datos permitidos preservando identidad, precios, Pedidos y Recetas" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="1024" y="840" as="sourcePoint" /\>  
            \<mxPoint x="131" y="840" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="c1\_47\_r2" value="1.2: \[Nombre duplicado o intento de modificar tipo/unidad con historial dependiente\] rechaza el cambio e informa la alternativa de crear un Producto nuevo mediante UC-30" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="1024" y="915" as="sourcePoint" /\>  
            \<mxPoint x="131" y="915" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>

        \<\!-- MARCO UC-48 (+ INCLUDE UC-35) \--\>  
        \<mxCell id="c1\_sd48" value="sd Escenario Independiente — UC-48: Cambiar Estado de Producto (con «include» UC-35)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=560;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>  
          \<mxGeometry x="50" y="985" width="1120" height="260" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="c1\_48\_ref35" value="ref «include» UC-35 Buscar Producto (selecciona el Producto e informa si existen Pedidos PENDIENTE sin bloquear la desactivación)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=280;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex="1" parent="1"\>  
          \<mxGeometry x="90" y="1020" width="780" height="50" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="c1\_48\_m1" value="1: ok \= cambiarEstadoProducto(idProducto:Long, nuevoActivo:Boolean)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="131" y="1105" as="sourcePoint" /\>  
            \<mxPoint x="1024" y="1105" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="c1\_48\_r1" value="1.1: actualiza condición activo/inactivo del Producto (si queda inactivo impide nuevas ventas y promociones, sin cancelar de oficio Pedidos PENDIENTE abiertos)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="1024" y="1195" as="sourcePoint" /\>  
            \<mxPoint x="131" y="1195" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>

        \<\!-- MARCO UC-19 (+ INCLUDE UC-35) \--\>  
        \<mxCell id="c1\_sd19" value="sd Escenario Independiente — UC-19: Actualizar Precio Vigente (con «include» UC-35)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=540;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>  
          \<mxGeometry x="50" y="1270" width="1120" height="250" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="c1\_19\_ref35" value="ref «include» UC-35 Buscar Producto (selecciona el Producto y muestra su precio vigente actual)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=260;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex="1" parent="1"\>  
          \<mxGeometry x="90" y="1305" width="760" height="50" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="c1\_19\_m1" value="1: idPrecio \= actualizarPrecioVigente(idProducto:Long, nuevoPrecioBase:BigDecimal, vigenteDesde:Timestamp, vigenteHasta:Timestamp\[0..1\])" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="131" y="1390" as="sourcePoint" /\>  
            \<mxPoint x="1024" y="1390" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="c1\_19\_r1" value="1.1: \[nuevoPrecioBase \&gt; 0 e intervalo sin solapamiento\] cierra vigencia previa, registra nuevo precio vigente y auditoría de cambio sin alterar precios congelados en Pedidos anteriores" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="1024" y="1475" as="sourcePoint" /\>  
            \<mxPoint x="131" y="1475" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>

        \<\!-- MARCO UC-20 (+ INCLUDE UC-35) \--\>  
        \<mxCell id="c1\_sd20" value="sd Escenario Independiente — UC-20: Consultar Historial de Precios (con «include» UC-35)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=560;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>  
          \<mxGeometry x="50" y="1545" width="1120" height="215" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="c1\_20\_ref35" value="ref «include» UC-35 Buscar Producto (selecciona el Producto a consultar)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=250;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex="1" parent="1"\>  
          \<mxGeometry x="90" y="1580" width="760" height="45" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="c1\_20\_m1" value="1: historialPrecios \= consultarHistorialPrecios(idProducto:Long, fechaDesde:LocalDate\[0..1\], fechaHasta:LocalDate\[0..1\])" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="131" y="1655" as="sourcePoint" /\>  
            \<mxPoint x="1024" y="1655" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="c1\_20\_r1" value="1.1: presenta en modo solo lectura la evolución cronológica de precios y auditoría (vigencias, valores y Administrador responsable)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="1024" y="1725" as="sourcePoint" /\>  
            \<mxPoint x="131" y="1725" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
      \</root\>  
    \</mxGraphModel\>  
  \</diagram\>

  \<\!-- \========================================================================= \--\>  
  \<\!-- PÁGINA 2: DSS CAJA NEGRA — PROMOCIONES (UC-24, UC-59, UC-60)              \--\>  
  \<\!-- \========================================================================= \--\>  
  \<diagram id="dss-rev06a-promos" name="DSS REV06A \- Promociones (UC-24, UC-59, UC-60)"\>  
    \<mxGraphModel dx="1550" dy="950" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1500" pageHeight="1350" math="0" shadow="0"\>  
      \<root\>  
        \<mxCell id="0" /\>  
        \<mxCell id="1" parent="0" /\>

        \<mxCell id="p2\_title" value="DSS (Caja Negra — REV06A) — Actor: Administrador — Escenarios Independientes UC-24, UC-59 y UC-60 \[RD-RP023-001 y F08\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=13;fontStyle=1" vertex="1" parent="1"\>  
          \<mxGeometry x="50" y="15" width="1320" height="30" as="geometry" /\>  
        \</mxCell\>

        \<mxCell id="p2\_actor" value="Administrador" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="100" y="60" width="30" height="60" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="p2\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="109" y="155" width="12" height="1120" as="geometry" /\>  
        \</mxCell\>

        \<mxCell id="p2\_sys\_box" value=":Sistema" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;fontSize=13;" vertex="1" parent="1"\>  
          \<mxGeometry x="820" y="60" width="140" height="45" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="p2\_sys\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="890" y="1300" as="sourcePoint" /\>  
            \<mxPoint x="890" y="105" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="p2\_sys\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="884" y="155" width="12" height="1120" as="geometry" /\>  
        \</mxCell\>

        \<mxCell id="p2\_msg\_box" value=":ServicioDeMensajeria&\#xa;(WhatsApp)" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;fontSize=12;" vertex="1" parent="1"\>  
          \<mxGeometry x="1220" y="60" width="170" height="45" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="p2\_msg\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="1305" y="1300" as="sourcePoint" /\>  
            \<mxPoint x="1305" y="105" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="p2\_msg\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="1299" y="340" width="12" height="90" as="geometry" /\>  
        \</mxCell\>

        \<\!-- MARCO UC-24 (+ INCLUDE UC-35) \--\>  
        \<mxCell id="p2\_sd24" value="sd Escenario Independiente — UC-24: Crear y Comunicar Promoción («include» UC-35) \[RD-RP023-001\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=650;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>  
          \<mxGeometry x="45" y="170" width="1395" height="410" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="p2\_24\_ref35" value="ref «include» UC-35 Buscar Producto (selecciona uno o más Productos activos alcanzados por la Promoción)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=260;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex="1" parent="1"\>  
          \<mxGeometry x="85" y="205" width="760" height="50" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="p2\_24\_m1" value="1: idPromocion \= crearYComunicarPromocion(descripcion:String, porcentajeDescuento:BigDecimal, vigenteDesde:Timestamp, vigenteHasta:Timestamp, idsProductos:List\&lt;Long\&gt;, idsClientesDestinatarios:List\&lt;Long\&gt;)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="121" y="290" as="sourcePoint" /\>  
            \<mxPoint x="884" y="290" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="p2\_24\_ext" value="1.1: enviarComunicacionPromocion(telefonoDestinatario, referenciaAccesoOnline) \[para cada destinatario\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="896" y="360" as="sourcePoint" /\>  
            \<mxPoint x="1299" y="360" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="p2\_24\_rext" value="1.2: resultadoIndividualEnvio" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="1299" y="410" as="sourcePoint" /\>  
            \<mxPoint x="896" y="410" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="p2\_24\_r1" value="1.3: \[Datos, Productos activos y destinatarios activos válidos\] registra Promoción (coexiste sin acumular descuentos sobre las mismas unidades en UC-21, aplicándose el mayor beneficio elegible — RD-RP023-001) y conserva el resultado de cada intento de comunicación" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="884" y="505" as="sourcePoint" /\>  
            \<mxPoint x="121" y="505" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>

        \<\!-- MARCO UC-59 \--\>  
        \<mxCell id="p2\_sd59" value="sd Escenario Independiente — UC-59: Consultar Promociones" style="shape=umlFrame;whiteSpace=wrap;html=1;width=410;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>  
          \<mxGeometry x="45" y="610" width="980" height="230" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="p2\_59\_m1" value="1: promociones \= consultarPromociones(idPromocion:Long\[0..1\], vigenteDesde:Timestamp\[0..1\], vigenteHasta:Timestamp\[0..1\], estado:String\[0..1\], idProducto:Long\[0..1\])" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="121" y="660" as="sourcePoint" /\>  
            \<mxPoint x="884" y="660" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="p2\_59\_r1" value="1.1: presenta en modo solo lectura las Promociones coincidentes (descripción, porcentajeDescuento, vigencia, estado BORRADOR\|ACTIVA\|PAUSADA\|FINALIZADA\|CANCELADA, Productos, destinatarios e intentos de comunicación, sin iniciar reenvíos)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="884" y="765" as="sourcePoint" /\>  
            \<mxPoint x="121" y="765" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>

        \<\!-- MARCO UC-60 \--\>  
        \<mxCell id="p2\_sd60" value="sd Escenario Independiente — UC-60: Desactivar Promoción \[RD-RP023-001 / F08\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=530;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>  
          \<mxGeometry x="45" y="870" width="980" height="310" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="p2\_60\_m1" value="1: ok \= desactivarPromocion(idPromocion:Long)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="121" y="925" as="sourcePoint" /\>  
            \<mxPoint x="884" y="925" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="p2\_60\_r1" value="1.1: \[Promoción existente y aún no retirada\] registra la desactivación impidiendo nuevas aplicaciones en UC-21, conservando íntegros Productos, destinatarios, comunicaciones y descuentos ya congelados en Pedidos confirmados (sin reactivación — F08)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="884" y="1025" as="sourcePoint" /\>  
            \<mxPoint x="121" y="1025" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="p2\_60\_r2" value="1.2: \[Promoción inexistente o ya desactivada\] informa la situación y no duplica el cambio" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="884" y="1125" as="sourcePoint" /\>  
            \<mxPoint x="121" y="1125" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
      \</root\>  
    \</mxGraphModel\>  
  \</diagram\>  
\</mxfile\>  
Archivo 3: docs/08-diagramas/revision/DS\_REV06A\_COMERCIAL\_PROMOCIONES\_UC19\_20\_24\_30\_35\_47\_48\_59\_60.drawio.xml  
Este archivo XML de 9 páginas para Draw.io contiene los Diagramas de Secuencia de Diseño (DS de caja blanca) corregidos para UC-35, UC-30, UC-47, UC-48, UC-19, UC-20, UC-24, UC-59 y UC-60, aplicando RD-RP023-001 (H-06), RD-RP007-002 (H-17) y el diccionario MR-3:     
MD  
\+ 3

XML  
\<mxfile host="app.diagrams.net" modified="2026-10-28T13:20:00.000Z" agent="Gemini-REV06A" version="24.7.17" type="device"\>  
  \<\!-- \========================================================================= \--\>  
  \<\!-- PÁGINA 1: DS UC-35 BUSCAR PRODUCTO (RD-RP007-002 H-17)                    \--\>  
  \<\!-- \========================================================================= \--\>  
  \<diagram id="ds-rev06a-uc35" name="DS UC-35 Buscar Producto (REV06A)"\>  
    \<mxGraphModel dx="1400" dy="800" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1350" pageHeight="850" math="0" shadow="0"\>  
      \<root\>  
        \<mxCell id="0" /\>  
        \<mxCell id="1" parent="0" /\>  
        \<mxCell id="u35\_title" value="Diagrama de Secuencia de Diseño (DS — REV06A) — UC-35: Buscar Producto \[RD-RP007-002: Admin y Vendedor\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex="1" parent="1"\>  
          \<mxGeometry x="50" y="15" width="1050" height="30" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u35\_actor" value="Administrador /&\#xa;Vendedor" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="90" y="60" width="30" height="60" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u35\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="99" y="155" width="12" height="620" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u35\_ctrl\_box" value=":ControladorCatalogo" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="400" y="60" width="165" height="45" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u35\_ctrl\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="482" y="800" as="sourcePoint" /\>  
            \<mxPoint x="482" y="105" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="u35\_ctrl\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="476" y="155" width="12" height="620" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u35\_cat\_box" value=":CatalogoProductos" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="780" y="60" width="165" height="45" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u35\_cat\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="862" y="800" as="sourcePoint" /\>  
            \<mxPoint x="862" y="105" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="u35\_cat\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="856" y="200" width="12" height="120" as="geometry" /\>  
        \</mxCell\>

        \<mxCell id="u35\_m1" value="1: productos \= buscarProducto(idProducto:Long\[0..1\], nombre:String\[0..1\], tipoProducto:String\[0..1\], activo:Boolean\[0..1\])" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="111" y="190" as="sourcePoint" /\>  
            \<mxPoint x="476" y="190" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="u35\_m2" value="2: lista \= consultarProductosPorCriterios(idProducto, nombre, tipoProducto, activo) \[Atributo\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="488" y="235" as="sourcePoint" /\>  
            \<mxPoint x="856" y="235" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="u35\_r2" value="2.1: lista : List\&lt;Producto\&gt;" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="856" y="295" as="sourcePoint" /\>  
            \<mxPoint x="488" y="295" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="u35\_alt" value="alt Resultado de la búsqueda de Productos \[UC-35\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=340;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>  
          \<mxGeometry x="50" y="340" width="1150" height="380" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u35\_g1" value="\[lista.notEmpty()\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>  
          \<mxGeometry x="125" y="365" width="300" height="20" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u35\_r1\_ok" value="3.1: muestra idProducto, nombre, descripcion, tipoProducto (ELABORADO\|REVENTA), codigoUnidadVenta y activo; devuelve el seleccionado al CU invocante" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="476" y="455" as="sourcePoint" /\>  
            \<mxPoint x="111" y="455" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="u35\_div" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="50" y="555" as="sourcePoint" /\>  
            \<mxPoint x="1200" y="555" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="u35\_g2" value="\[Sin coincidencias\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>  
          \<mxGeometry x="125" y="565" width="300" height="20" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u35\_r1\_empty" value="3.2: informa ausencia de coincidencias sin modificar el catálogo" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="476" y="655" as="sourcePoint" /\>  
            \<mxPoint x="111" y="655" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
      \</root\>  
    \</mxGraphModel\>  
  \</diagram\>

  \<\!-- \========================================================================= \--\>  
  \<\!-- PÁGINA 2: DS UC-30 GESTIONAR PRODUCTO                                     \--\>  
  \<\!-- \========================================================================= \--\>  
  \<diagram id="ds-rev06a-uc30" name="DS UC-30 Gestionar Producto (REV06A)"\>  
    \<mxGraphModel dx="1500" dy="850" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1450" pageHeight="950" math="0" shadow="0"\>  
      \<root\>  
        \<mxCell id="0" /\>  
        \<mxCell id="1" parent="0" /\>  
        \<mxCell id="u30\_title" value="Diagrama de Secuencia de Diseño (DS — REV06A) — UC-30: Gestionar Producto (Denominación canónica Fase 4)" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex="1" parent="1"\>  
          \<mxGeometry x="50" y="15" width="1020" height="30" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u30\_actor" value="Administrador" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="90" y="60" width="30" height="60" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u30\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="99" y="155" width="12" height="720" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u30\_ctrl\_box" value=":ControladorCatalogo" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="380" y="60" width="165" height="45" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u30\_ctrl\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="462" y="900" as="sourcePoint" /\>  
            \<mxPoint x="462" y="105" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="u30\_ctrl\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="456" y="155" width="12" height="720" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u30\_cat\_box" value=":CatalogoProductos" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="720" y="60" width="165" height="45" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u30\_cat\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="802" y="900" as="sourcePoint" /\>  
            \<mxPoint x="802" y="105" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="u30\_cat\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="796" y="200" width="12" height="420" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u30\_prd\_box" value="nuevoProd : Producto" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="1080" y="380" width="165" height="45" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u30\_prd\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="1162" y="900" as="sourcePoint" /\>  
            \<mxPoint x="1162" y="425" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="u30\_prd\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="1156" y="425" width="12" height="90" as="geometry" /\>  
        \</mxCell\>

        \<mxCell id="u30\_m1" value="1: idProducto \= gestionarProducto(nombre:String, descripcion:String\[0..1\], tipoProducto:String, codigoUnidadVenta:String)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="111" y="185" as="sourcePoint" /\>  
            \<mxPoint x="456" y="185" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="u30\_m2" value="2: prodExistente \= buscarPorNombreNormalizado(nombreNormalizado:String) \[Atributo\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="468" y="225" as="sourcePoint" /\>  
            \<mxPoint x="796" y="225" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="u30\_r2" value="2.1: prodExistente : Producto \[0..1\] (verifica activos e inactivos)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="796" y="270" as="sourcePoint" /\>  
            \<mxPoint x="468" y="270" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>

        \<mxCell id="u30\_alt" value="alt Validación de datos obligatorios y unicidad de nombreNormalizado \[UC-30\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=500;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>  
          \<mxGeometry x="50" y="310" width="1310" height="510" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u30\_g1" value="\[Datos obligatorios válidos y prodExistente \== null\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>  
          \<mxGeometry x="125" y="335" width="450" height="20" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u30\_m3\_new" value="3: «create» new(nombre, nombreNormalizado, descripcion, tipoProducto=ELABORADO\|REVENTA, codigoUnidadVenta, activo=true)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="468" y="402" as="sourcePoint" /\>  
            \<mxPoint x="1080" y="402" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="u30\_m4" value="4: guardarProducto(nuevoProd:Producto)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="468" y="545" as="sourcePoint" /\>  
            \<mxPoint x="796" y="545" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="u30\_r1\_ok" value="4.1: confirma registro del Producto con activo \= true (precio vigente en UC-19; Receta en UC-10)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="456" y="635" as="sourcePoint" /\>  
            \<mxPoint x="111" y="635" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="u30\_div" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="50" y="685" as="sourcePoint" /\>  
            \<mxPoint x="1360" y="685" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="u30\_g2" value="\[Existe otro Producto con igual nombreNormalizado (activo o inactivo) o datos inválidos\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>  
          \<mxGeometry x="125" y="695" width="600" height="20" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u30\_r1\_err" value="4.2: no crea duplicado y presenta el registro existente" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="456" y="775" as="sourcePoint" /\>  
            \<mxPoint x="111" y="775" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
      \</root\>  
    \</mxGraphModel\>  
  \</diagram\>

  \<\!-- \========================================================================= \--\>  
  \<\!-- PÁGINA 3: DS UC-47 MODIFICAR PRODUCTO («include» UC-35)                   \--\>  
  \<\!-- \========================================================================= \--\>  
  \<diagram id="ds-rev06a-uc47" name="DS UC-47 Modificar Producto (REV06A)"\>  
    \<mxGraphModel dx="1500" dy="850" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1450" pageHeight="920" math="0" shadow="0"\>  
      \<root\>  
        \<mxCell id="0" /\>  
        \<mxCell id="1" parent="0" /\>  
        \<mxCell id="u47\_title" value="Diagrama de Secuencia de Diseño (DS — REV06A) — UC-47: Modificar Producto (con «include» UC-35)" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex="1" parent="1"\>  
          \<mxGeometry x="50" y="15" width="1050" height="30" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u47\_actor" value="Administrador" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="90" y="60" width="30" height="60" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u47\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="99" y="155" width="12" height="700" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u47\_ctrl\_box" value=":ControladorCatalogo" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="380" y="60" width="165" height="45" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u47\_ctrl\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="462" y="880" as="sourcePoint" /\>  
            \<mxPoint x="462" y="105" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="u47\_ctrl\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="456" y="155" width="12" height="700" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u47\_cat\_box" value=":CatalogoProductos" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="720" y="60" width="165" height="45" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u47\_cat\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="802" y="880" as="sourcePoint" /\>  
            \<mxPoint x="802" y="105" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="u47\_cat\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="796" y="290" width="12" height="90" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u47\_prd\_box" value="unProducto : Producto" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="1060" y="60" width="165" height="45" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u47\_prd\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="1142" y="880" as="sourcePoint" /\>  
            \<mxPoint x="1142" y="105" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="u47\_prd\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="1136" y="485" width="12" height="165" as="geometry" /\>  
        \</mxCell\>

        \<mxCell id="u47\_ref35" value="ref «include» UC-35 Buscar Producto (recibe unProducto y presenta sus datos y restricciones por historial)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=260;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex="1" parent="1"\>  
          \<mxGeometry x="65" y="165" width="760" height="60" as="geometry" /\>  
        \</mxCell\>

        \<mxCell id="u47\_m1" value="1: ok \= modificarProducto(idProducto:Long, nuevoNombre:String, descripcion:String\[0..1\], tipoProductoPropuesto:String, codigoUnidadVentaPropuesto:String)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="111" y="265" as="sourcePoint" /\>  
            \<mxPoint x="456" y="265" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="u47\_m2" value="2: (unProducto, tieneHistorial, nombreDup) \= revalidarUnicidadYRestriccionesHistorial(idProducto, nuevoNombreNormalizado) \[Atributo\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="468" y="315" as="sourcePoint" /\>  
            \<mxPoint x="796" y="315" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>

        \<mxCell id="u47\_alt" value="alt Validación de unicidad y bloqueo de cambio de tipo/unidad con historial dependiente \[UC-47\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=590;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>  
          \<mxGeometry x="50" y="405" width="1310" height="415" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u47\_g1" value="\[nombreDup \== false y (\!cambiaTipoOUnidad \|\| \!tieneHistorial)\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>  
          \<mxGeometry x="125" y="430" width="540" height="20" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u47\_m3" value="3: actualizarDatosPermitidos(nuevoNombre, nuevoNombreNormalizado, descripcion, tipoProductoPropuesto, codigoUnidadVentaPropuesto)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="468" y="510" as="sourcePoint" /\>  
            \<mxPoint x="1136" y="510" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="u47\_r3" value="3.1: actualiza campos permitidos preservando identidad, precios, Pedidos y Recetas" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="1136" y="585" as="sourcePoint" /\>  
            \<mxPoint x="468" y="585" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="u47\_r1\_ok" value="3.2: informa resultado exitoso" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="456" y="645" as="sourcePoint" /\>  
            \<mxPoint x="111" y="645" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="u47\_div" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="50" y="695" as="sourcePoint" /\>  
            \<mxPoint x="1360" y="695" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="u47\_g2" value="\[Nombre normalizado duplicado o intento de modificar tipo/unidad con historial dependiente\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>  
          \<mxGeometry x="125" y="705" width="640" height="20" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u47\_r1\_err" value="3.3: rechaza el cambio e informa la alternativa de crear un Producto nuevo mediante UC-30" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="456" y="785" as="sourcePoint" /\>  
            \<mxPoint x="111" y="785" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
      \</root\>  
    \</mxGraphModel\>  
  \</diagram\>

  \<\!-- \========================================================================= \--\>  
  \<\!-- PÁGINA 4: DS UC-48 CAMBIAR ESTADO DE PRODUCTO («include» UC-35)           \--\>  
  \<\!-- \========================================================================= \--\>  
  \<diagram id="ds-rev06a-uc48" name="DS UC-48 Cambiar Estado Producto (REV06A)"\>  
    \<mxGraphModel dx="1500" dy="850" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1450" pageHeight="920" math="0" shadow="0"\>  
      \<root\>  
        \<mxCell id="0" /\>  
        \<mxCell id="1" parent="0" /\>  
        \<mxCell id="u48\_title" value="Diagrama de Secuencia de Diseño (DS — REV06A) — UC-48: Cambiar Estado de Producto (con «include» UC-35)" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex="1" parent="1"\>  
          \<mxGeometry x="50" y="15" width="1050" height="30" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u48\_actor" value="Administrador" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="90" y="60" width="30" height="60" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u48\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="99" y="155" width="12" height="700" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u48\_ctrl\_box" value=":ControladorCatalogo" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="380" y="60" width="165" height="45" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u48\_ctrl\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="462" y="880" as="sourcePoint" /\>  
            \<mxPoint x="462" y="105" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="u48\_ctrl\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="456" y="155" width="12" height="700" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u48\_prd\_box" value="unProducto : Producto" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="920" y="60" width="165" height="45" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u48\_prd\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="1002" y="880" as="sourcePoint" /\>  
            \<mxPoint x="1002" y="105" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="u48\_prd\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="996" y="420" width="12" height="190" as="geometry" /\>  
        \</mxCell\>

        \<mxCell id="u48\_ref35" value="ref «include» UC-35 Buscar Producto (selecciona unProducto e informa si existen Pedidos PENDIENTE sin bloquear la desactivación)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=280;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex="1" parent="1"\>  
          \<mxGeometry x="65" y="165" width="760" height="60" as="geometry" /\>  
        \</mxCell\>

        \<mxCell id="u48\_m1" value="1: ok \= cambiarEstadoProducto(idProducto:Long, nuevoActivo:Boolean) \[Pendiente F09\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="111" y="295" as="sourcePoint" /\>  
            \<mxPoint x="456" y="295" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>

        \<mxCell id="u48\_alt" value="alt Desactivación o Reactivación preservando identidad y Pedidos abiertos \[UC-48\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=530;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>  
          \<mxGeometry x="50" y="365" width="1310" height="455" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u48\_g1" value="\[unProducto.activo \!= nuevoActivo y (nuevoActivo \== false \|\| datosActualesValidosParaUso)\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>  
          \<mxGeometry x="125" y="390" width="600" height="20" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u48\_m2" value="2: establecerEstadoActivo(nuevoActivo:Boolean) \[Visibilidad por Variable Local\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="468" y="465" as="sourcePoint" /\>  
            \<mxPoint x="996" y="465" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="u48\_r2" value="2.1: actualiza Producto.activo (si queda inactivo bloquea nuevas ventas conservando Pedidos PENDIENTE abiertos)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="996" y="545" as="sourcePoint" /\>  
            \<mxPoint x="468" y="545" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="u48\_r1\_ok" value="2.2: confirma nuevo estado del Producto" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="456" y="620" as="sourcePoint" /\>  
            \<mxPoint x="111" y="620" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="u48\_div" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="50" y="680" as="sourcePoint" /\>  
            \<mxPoint x="1360" y="680" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="u48\_g2" value="\[Estado ya coincidente o reactivación solicitada con datos actuales inválidos\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>  
          \<mxGeometry x="125" y="690" width="560" height="20" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u48\_r1\_err" value="2.3: informa ausencia de cambio o exige corregir datos mediante UC-47 antes de reactivar" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="456" y="775" as="sourcePoint" /\>  
            \<mxPoint x="111" y="775" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
      \</root\>  
    \</mxGraphModel\>  
  \</diagram\>

  \<\!-- \========================================================================= \--\>  
  \<\!-- PÁGINA 5: DS UC-19 ACTUALIZAR PRECIO VIGENTE («include» UC-35)            \--\>  
  \<\!-- \========================================================================= \--\>  
  \<diagram id="ds-rev06a-uc19" name="DS UC-19 Actualizar Precio Vigente (REV06A)"\>  
    \<mxGraphModel dx="1600" dy="900" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1550" pageHeight="1050" math="0" shadow="0"\>  
      \<root\>  
        \<mxCell id="0" /\>  
        \<mxCell id="1" parent="0" /\>  
        \<mxCell id="u19\_title" value="Diagrama de Secuencia de Diseño (DS — REV06A) — UC-19: Actualizar Precio Vigente (con «include» UC-35)" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex="1" parent="1"\>  
          \<mxGeometry x="50" y="15" width="1050" height="30" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u19\_actor" value="Administrador" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="85" y="60" width="30" height="60" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u19\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="94" y="155" width="12" height="820" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u19\_ctrl\_box" value=":ControladorCatalogo" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="350" y="60" width="165" height="45" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u19\_ctrl\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="432" y="1000" as="sourcePoint" /\>  
            \<mxPoint x="432" y="105" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="u19\_ctrl\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="426" y="155" width="12" height="820" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u19\_cat\_box" value=":CatalogoProductos" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="660" y="60" width="165" height="45" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u19\_cat\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="742" y="1000" as="sourcePoint" /\>  
            \<mxPoint x="742" y="105" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="u19\_cat\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="736" y="340" width="12" height="90" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u19\_np\_box" value="nuevoPrecio : PrecioProducto&\#xa;+ evAud : AuditoriaPrecio" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="1020" y="510" width="210" height="45" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u19\_np\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="1125" y="1000" as="sourcePoint" /\>  
            \<mxPoint x="1125" y="555" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="u19\_np\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="1119" y="555" width="12" height="80" as="geometry" /\>  
        \</mxCell\>

        \<mxCell id="u19\_ref35" value="ref «include» UC-35 Buscar Producto (selecciona unProducto y recupera su precioVigente actual)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=260;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex="1" parent="1"\>  
          \<mxGeometry x="65" y="165" width="740" height="55" as="geometry" /\>  
        \</mxCell\>

        \<mxCell id="u19\_m1" value="1: idPrecio \= actualizarPrecioVigente(idProducto:Long, nuevoPrecioBase:BigDecimal, vigenteDesde:Timestamp, vigenteHasta:Timestamp\[0..1\])" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="106" y="280" as="sourcePoint" /\>  
            \<mxPoint x="426" y="280" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="u19\_m2" value="2: cerrarVigenciaAnteriorSinSolapamiento(idProducto, vigenteDesde) \[Atributo\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="438" y="365" as="sourcePoint" /\>  
            \<mxPoint x="736" y="365" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>

        \<mxCell id="u19\_alt" value="alt Validación de nuevoPrecioBase \&gt; 0 e intervalo \[vigenteDesde, vigenteHasta) consistente \[UC-19\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=610;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>  
          \<mxGeometry x="50" y="425" width="1440" height="500" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u19\_g1" value="\[nuevoPrecioBase \&gt; 0 y vigencia sin solapamiento\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>  
          \<mxGeometry x="120" y="450" width="450" height="20" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u19\_m3\_new" value="3: «create» new PrecioProducto(idProducto, nuevoPrecioBase, vigenteDesde, vigenteHasta, idAdmin) \+ new AuditoriaPrecio(...)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="438" y="532" as="sourcePoint" /\>  
            \<mxPoint x="1020" y="532" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="u19\_r1\_ok" value="3.1: registra PrecioProducto y AuditoriaPrecio (sin alterar precioUnitario congelado en DetallePedido previos)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="426" y="685" as="sourcePoint" /\>  
            \<mxPoint x="106" y="685" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="u19\_div" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="50" y="755" as="sourcePoint" /\>  
            \<mxPoint x="1490" y="755" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="u19\_g2" value="\[nuevoPrecioBase \&lt;= 0 o solapamiento de intervalos de vigencia\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>  
          \<mxGeometry x="120" y="765" width="520" height="20" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u19\_r1\_err" value="3.2: rechaza la actualización y conserva intacta la vigencia anterior" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="426" y="865" as="sourcePoint" /\>  
            \<mxPoint x="106" y="865" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
      \</root\>  
    \</mxGraphModel\>  
  \</diagram\>

  \<\!-- \========================================================================= \--\>  
  \<\!-- PÁGINA 6: DS UC-20 CONSULTAR HISTORIAL DE PRECIOS («include» UC-35)       \--\>  
  \<\!-- \========================================================================= \--\>  
  \<diagram id="ds-rev06a-uc20" name="DS UC-20 Consultar Historial Precios (REV06A)"\>  
    \<mxGraphModel dx="1450" dy="800" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1400" pageHeight="850" math="0" shadow="0"\>  
      \<root\>  
        \<mxCell id="0" /\>  
        \<mxCell id="1" parent="0" /\>  
        \<mxCell id="u20\_title" value="Diagrama de Secuencia de Diseño (DS — REV06A) — UC-20: Consultar Historial de Precios (con «include» UC-35)" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex="1" parent="1"\>  
          \<mxGeometry x="50" y="15" width="1050" height="30" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u20\_actor" value="Administrador" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="90" y="60" width="30" height="60" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u20\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="99" y="155" width="12" height="600" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u20\_ctrl\_box" value=":ControladorCatalogo" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="380" y="60" width="165" height="45" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u20\_ctrl\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="462" y="790" as="sourcePoint" /\>  
            \<mxPoint x="462" y="105" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="u20\_ctrl\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="456" y="155" width="12" height="600" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u20\_cat\_box" value=":CatalogoProductos" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="760" y="60" width="165" height="45" as="geometry" /\>  
        \</mxCell\>  
        \<mxCell id="u20\_cat\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>  
          \<mxGeometry relative="1" as="geometry"\>  
            \<mxPoint x="842" y="790" as="sourcePoint" /\>  
            \<mxPoint x="842" y="105" as="targetPoint" /\>  
          \</mxGeometry\>  
        \</mxCell\>  
        \<mxCell id="u20\_cat\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>  
          \<mxGeometry x="836" y="280" width="12" height="160" as="geometry" /\>  
        \</mxCell\>

        \<mxCell id="u20\_ref35" value="ref «include» UC-35 Buscar Producto (selecciona el Producto a consultar)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=250;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex="1" parent="1"\>  
          \<mxGeometry x="65" y="165" width="760" height="55" as="geometry" /\>  
        \</mxCell\>

        \<mxCell id="u20\_m1" value="1: historialPrecios \= consultarHistorialPrecios(idProducto:Long, fechaDesde:LocalDate\[0..1\], fechaHasta:LocalDate\[0..1\])" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1