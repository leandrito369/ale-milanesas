### **Paquete Completo de Revisión Transversal — Lote 5 (`REV-05`: Finanzas, Cuenta Corriente, Cobros, Reembolsos, Caja y Margen Bruto)**

Aplicando la metodología reproducible de ocho etapas (`M-0` a `M-7`) establecida en **`REV01_AUDITORIA_TRANSVERSAL_CIERRE_2026-10-28.md`** y corrigiendo todos los hallazgos señalados en **`AUDITORIA_PREINTEGRACION_GEMINI_DSS_DS_CONTRATOS_2026-10-27.md`**, entrego el paquete completo del **Lote 5 (`REV-05 — Finanzas y Consultas`: `UC-14`, `UC-22`, `UC-23`, `UC-26`, `UC-27`, `UC-29`, `UC-49` — 7 Casos de Uso)**.

### **Archivo 1: `docs/08-diagramas/revision/REV05_AUDITORIA_TRANSVERSAL_FINANZAS_2026-10-28.md`**

\# REV-05 — Auditoría Transversal y Corrección: Finanzas, Cuenta Corriente, Cobros, Reembolsos, Caja y Margen Bruto (UC-14, UC-22, UC-23, UC-26, UC-27, UC-29, UC-49)

\*\*Fecha:\*\* 28/10/2026  

\*\*Rama de trabajo propuesta:\*\* \`revision/rev05-finanzas-consultas-2026-10-28\`  

\*\*Alcance (\`REV-05\`):\*\* \`UC-14\` («include» \`UC-33\`), \`UC-29\` («include» \`UC-15\`), \`UC-22\`, \`UC-23\`, \`UC-26\` («extend» condicional a \`UC-06\`), \`UC-49\`, \`UC-27\`.  

\*\*Estado de los artefactos entregados:\*\* \`PROPUESTO / CORREGIDO EN REVISIÓN ESTÁTICA\` (pendiente de inspección visual humana en Draw.io y aprobación para fusión a \`main\`).

\---

\#\# 1\. Ejecución de las 8 Etapas Metodológicas (M-0 a M-7)

\#\#\# M-0 — Autoridad y alcance congelados

\* \*\*Catálogo funcional vigente:\*\* 64 CU consecutivos (\`UC-01\`..\`UC-64\`) en 3 niveles (\`ALE\_MILANESAS\_FASE\_4\_CU\_01\_A\_64\_TRES\_NIVELES.docx\`), respetando que \*\*\`UC-49\` es «Registrar Resultado de Reembolso Electrónico»\*\* (Actor principal: \`MercadoPago\`) y que \*\*\`UC-26\` no incluye ni extiende \`UC-49\`\*\*.

\* \*\*Relaciones UML aprobadas en este lote:\*\* \`UC-14 → UC-33\` (\`include\`), \`UC-29 → UC-15\` (\`include\`) y \`UC-26 → UC-06\` (\`extend\` condicional). El archivo \`DIAGRAMA DE CASOS DE USO.drawio (1).xml\` permanece intacto.

\* \*\*Decisiones posteriores incorporadas (Corte 27/10/2026):\*\*

  \* \*\*\`RD-RP004/RP028-001\` y \`RD-F04\` (resuelve Hallazgo de Prioridad Alta \`H-03\` en \`UC-14\`):\*\* En \`UC-14 — Consultar Cuenta Corriente\`, el sistema diferencia y expone explícitamente tres magnitudes financieras:

    1\. \*\*\`saldoConfirmado\`:\*\* Saldo resultante de los movimientos definitivos en \`MOVIMIENTO\_CUENTA\` (\`CARGO\_POR\_VENTA\`, \`PAGO\`, \`AJUSTE\_DEBITO\`, \`ANULACION\_COBRO\`).

    2\. \*\*\`pagosEnTransitoValidados\`:\*\* Suma de efectivo declarado como recibido por los Repartidores en \`UC-05\` que aún se encuentra pendiente de rendición y registración en \`UC-29\`.

    3\. \*\*\`saldoExigibleProvisional\`:\*\* Saldo neto exigible al Cliente considerando los pagos en tránsito validados (\`saldoConfirmado \- pagosEnTransitoValidados\`).

  \* \*\*\`RD-RP004/RP028-001\` (resuelve Hallazgo de Prioridad Alta \`H-04\` en \`UC-27\`):\*\* En \`UC-27 — Consultar Margen Bruto\`, además de la consulta \*\*por período\*\* (delimitado por \`Entrega.fechaHoraEntrega\`), se incorpora la consulta \*\*por venta individual\*\* (\`idPedido\` / \`idEntrega\` de un Pedido \`ENTREGADO\`), aplicando exactamente la misma regla de ingresos efectivos (\`CARGO\_POR\_VENTA\`: tramo original a condiciones históricas \+ tramo adicional a importe aceptado en \`UC-07\`) menos costos históricos atribuibles (\`ELABORADO\` y \`REVENTA\`) e indicador de completitud.

  \* \*\*\`RD-F01\` y \`MR-6\` (resuelve Hallazgo \`H-10\` en \`UC-29\`):\*\* Se restringe el dominio de \`COBRO.estadoCobro\` exclusivamente a los valores aprobados \*\*\`CONFIRMADO\`\*\* y \*\*\`ANULADO\`\*\*. Cuando se registra un cobro válido en \`UC-29\`, nace con \`estadoCobro \= CONFIRMADO\`. Para revertir un cobro manual erróneo (dentro de \`UC-29\`, sin confundirlo con \`UC-49\`), el Cobro pasa a \`estadoCobro \= ANULADO\` y se generan los contraasientos trazables mediante \`idCobroAnulado\` en \`ORIGEN\_MOVIMIENTO\_CUENTA\` (\`ANULACION\_COBRO\`) y en \`MOVIMIENTO\_CAJA\` (\`EGRESO\`), reevaluando \`UC-15\`.

\#\#\# M-1 — Proveniencia, integridad y matriz de diferencias (Antes → Después)

\| ID Hallazgo \| Artefacto / Celda Original \| Antes (Borrador 26–27/10) \| Después (Versión Corregida \`REV05\`) \| Fundamento \|

\| :--- \| :--- \| :--- \| :--- \| :--- \|

\| \*\*\`H-03\` (Alta)\*\* \| \`DSS Vendedor\` (\`v\_r14\`), \`DS UC-14\` (\`u14\_r2\`) y \`Contrato 5.6\` \| Mostraba únicamente un \`saldoActual\` plano sin distinguir pagos en tránsito ni saldo exigible provisional. \| Expone explícitamente \*\*\`saldoConfirmado\`\*\*, \*\*\`pagosEnTransitoValidados\`\*\* (declarados en \`UC-05\`) y \*\*\`saldoExigibleProvisional\`\*\* tanto en el DSS como en \`DS UC-14\` y \`CONTRATO\_UC14\`. \| \`RD-RP004/RP028-001\` y \`RD-F04\` \|

\| \*\*\`H-04\` (Alta)\*\* \| \`DSS Admin 6C\` (\`a3\_m9\`), \`DS UC-27\` (\`u27\_m1\`) y \`Contrato 6C.3\` \| Modelaba \`UC-27\` únicamente por período de fechas. \| Incorpora en la firma y en el fragmento \`alt\` de \`DS UC-27\` y \`CONTRATO\_UC27\` ambas modalidades aprobadas: consulta \*\*por período\*\* (\`fechaHoraDesde\`, \`fechaHoraHasta\`) y consulta \*\*por venta individual\*\* (\`idEntrega\` / \`idPedido\` \`ENTREGADO\`). \| \`RD-RP004/RP028-001\` \|

\| \*\*\`H-10\` (Media/Alta)\*\* \| \`DS UC-29\` (\`u29\_m3\_new\`) y \`Contrato 5.6\` \| Usaba un \`estado\` indeterminado en \`DS UC-29\` y en el DSS mezclaba la anulación manual con \`UC-49\`. \| Fija \`estadoCobro \= CONFIRMADO\` en el alta de \`UC-29\` y modela la anulación de cobro manual (\`estadoCobro \= ANULADO\` \+ contraasiento con \`idCobroAnulado\` \+ \`UC-15\`) dentro del alcance de \`UC-29\`, manteniendo \`UC-49\` exclusivamente para el resultado asíncrono de \`MercadoPago\`. \| \`RD-F01\`, \`MR-3\`/\`MR-6\` y Ficha Fase 4 \`UC-49\` \|

\| \*\*\`H-11\` (Media)\*\* \| \`Contrato 5.6\` (\`UC-29\`+\`UC-14\`) y \`Contrato 6C.3\` (\`UC-22\`+\`23\`+\`26\`+\`49\`+\`27\`) \| Agrupaba 7 casos de uso distintos en solo 2 fichas de contrato compuestas. \| Se desagrupan en \*\*8 Contratos individuales\*\* (\`UC-14\`, \`UC-29\` alta, \`UC-29\` anulación manual, \`UC-22\`, \`UC-23\`, \`UC-26\`, \`UC-49\`, \`UC-27\`), cada uno con sus 9 secciones estándar. \| Puerta \`G4\` / \`H-11\` \|

\| \*\*\`H-12\`, \`H-19\`, \`H05\`\*\* \| \`DSS\`, \`DS\` y \`Contratos\` \| Secuencia continua en el DSS y firmas divergentes. \| Marcos \`sd\` independientes por CU en el DSS, lenguaje de caja negra y homologación 1:1 de las 8 firmas públicas entre DSS, DS y Contratos. \| \`M-3\`, \`H-12\`, \`H-19\`, \`H05\` \|

\---

\#\# 2\. Matriz de Trazabilidad Vertical y Visibilidad de Larman Mensaje por Mensaje (M-3 y M-6)

\| CU \| Paso / Mensaje en DS \| Emisor \$\\rightarrow\$ Receptor \| Tipo de Visibilidad (Larman) \| Origen verificable de la referencia \|

\| :--- \| :--- \| :--- \| :--- \| :--- \|

\| \*\*\`UC-14\`\*\* \| \`1: consultarCuentaCorriente(idCliente, fechaDesde, fechaHasta)\` \| \`Vendedor / Admin\` \$\\rightarrow\$ \`:ControladorCuentaCorrienteCobros\` \| Frontera de sistema \| Operación pública homologada del DSS (\`UC-14\`, precedida por \`«include» UC-33\`). \|

\| \*\*\`UC-14\`\*\* \| \`2: res \= recuperarSaldosConfirmadoEnTransitoYProvisionalEHistorial(idCliente, fechaDesde, fechaHasta)\` \| \`:ControladorCuentaCorrienteCobros\` \$\\rightarrow\$ \`:LibroCuentaCorriente\` \| \*\*Por Atributo\*\* \| Calcula \`saldoConfirmado\`, \`pagosEnTransitoValidados\` y \`saldoExigibleProvisional\` (\`RD-RP028\`) y filtra solo la vista de movimientos sin alterar los saldos. \|

\| \*\*\`UC-29\` (Alta)\*\* \| \`1a: registrarCobro(idCliente, idPedido, importe, medioPago, origen, referenciaExterna)\` \| \`Vendedor / Admin\` \$\\rightarrow\$ \`:ControladorCuentaCorrienteCobros\` \| Frontera de sistema \| Operación pública homologada del DSS (\`UC-29\`). \|

\| \*\*\`UC-29\` (Alta)\*\* \| \`2a: «create» new(unCliente, unPedido\[0..1\], importe, medioPago, origen, referenciaExterna, estadoCobro=CONFIRMADO)\` \| \`:ControladorCuentaCorrienteCobros\` \$\\rightarrow\$ \`unCobro : Cobro\` \| \*\*Por Creación Local (\`new\`) \+ Parámetro\*\* \| Instancia el \`Cobro\` con \`estadoCobro \= CONFIRMADO\` (\`RD-F01\`), registra \`PAGO\` en \`:LibroCuentaCorriente\` (conciliando efectivo en tránsito si corresponde a rendición), \`INGRESO\` en \`:LibroCaja\` y ejecuta \`«include» UC-15\`. \|

\| \*\*\`UC-29\` (Anul.)\*\* \| \`1b: anularCobroManual(idCobro, motivoAnulacion)\` \| \`Vendedor / Admin\` \$\\rightarrow\$ \`:ControladorCuentaCorrienteCobros\` \| Frontera de sistema \| Operación de reversión de cobro manual por contraasiento (\`RD-F01\` / \`MR1-33\`). \|

\| \*\*\`UC-29\` (Anul.)\*\* \| \`2b: marcarAnuladoYGenerarContraasientos(idCobroAnulado, motivoAnulacion)\` \| \`:ControladorCuentaCorrienteCobros\` \$\\rightarrow\$ \`unCobro : Cobro\` / \`:LibroCuentaCorriente\` / \`:LibroCaja\` \| \*\*Por Variable Local \+ Atributo\*\* \| Pasa \`unCobro.estadoCobro\` a \`ANULADO\`, crea contraasiento \`ANULACION\_COBRO\` enlazado por \`idCobroAnulado\` en Cuenta Corriente y Caja, y reevalúa \`UC-15\`. \|

\| \*\*\`UC-22\`\*\* \| \`1: registrarMovimientoCaja(tipoMovimiento, importe, concepto, observacion)\` \| \`Administrador\` \$\\rightarrow\$ \`:ControladorCaja\` \| Frontera de sistema \| Operación pública homologada del DSS (\`UC-22\`). \|

\| \*\*\`UC-22\`\*\* \| \`2: «create» new(tipoMovimiento, importe, concepto, observacion, origen=MANUAL, idAdmin)\` \| \`:ControladorCaja\` \$\\rightarrow\$ \`movCaja : MovimientoCaja\` \| \*\*Por Creación Local (\`new\`)\*\* \| Crea y persiste en \`:LibroCaja\` el movimiento manual excluyendo pagos de Clientes y reembolsos automáticos. \|

\| \*\*\`UC-23\`\*\* \| \`1: consultarLibroDiario(fechaInicial, fechaFinal)\` \| \`Administrador\` \$\\rightarrow\$ \`:ControladorCaja\` \| Frontera de sistema \| Operación pública homologada del DSS (\`UC-23\`). \|

\| \*\*\`UC-23\`\*\* \| \`2: libro \= recuperarMovimientosYCalcularResultadoMonetario(fechaInicial, fechaFinal)\` \| \`:ControladorCaja\` \$\\rightarrow\$ \`:LibroCaja\` \| \*\*Por Atributo\*\* \| Recupera movimientos manuales y automáticos y calcula \`ingresos \- egresos\` en solo lectura. \|

\| \*\*\`UC-26\`\*\* \| \`1: procesarReembolsoElectronico(idCobroOriginal, idReembolsoReintento, idUsuarioReintento)\` \| \`Disparador UC-06 / Admin\` \$\\rightarrow\$ \`:ControladorReembolsos\` \| Frontera de sistema \| Operación pública homologada del DSS (\`UC-26\`). \|

\| \*\*\`UC-26\`\*\* \| \`2: «create» new(unReembolso, numeroIntento, claveIdempotencia, idUsuarioReintento\[0..1\])\` \| \`unReembolso : Reembolso\` \$\\rightarrow\$ \`intento : IntentoReembolso\` \| \*\*Por Creación Local (\`new\`) \+ Atributo\*\* \| Crea el intento sobre el único \`Reembolso\` del \`Cobro\`; solo si \`MercadoPago\` responde \`PROCESADO\` genera \`EGRESO\` en Caja, \`AJUSTE\_DEBITO\` en Cuenta Corriente y ejecuta \`UC-15\`. \|

\| \*\*\`UC-49\`\*\* \| \`1: registrarResultadoReembolsoElectronico(referenciaExternaIntento, estadoInformado, firmaVerificacion)\` \| \`MercadoPago\` \$\\rightarrow\$ \`:ControladorReembolsos\` \| Frontera de sistema \| Operación pública homologada del DSS (\`UC-49\`). \|

\| \*\*\`UC-49\`\*\* \| \`2: «create» new(intentoActivo, estadoInformado, fechaHoraRecepcion, referenciaExternaIntento)\` \| \`:ControladorReembolsos\` \$\\rightarrow\$ \`evResultado : EventoResultadoReembolso\` \| \*\*Por Creación Local (\`new\`)\*\* \| Registra idempotentemente el evento; solo en la primera transición a \`PROCESADO\` aplica \`EGRESO\` en Caja, \`AJUSTE\_DEBITO\` en Cuenta Corriente y ejecuta \`UC-15\`. \|

\| \*\*\`UC-27\`\*\* \| \`1: consultarMargenBruto(modoConsulta, fechaHoraDesde, fechaHoraHasta, idVentaIndividual)\` \| \`Administrador\` \$\\rightarrow\$ \`:ControladorMargenBruto\` \| Frontera de sistema \| Operación pública homologada del DSS (\`UC-27\`, soporta \`PERIODO\` y \`VENTA\_INDIVIDUAL\` según \`RD-RP004/RP028-001\`). \|

\| \*\*\`UC-27\`\*\* \| \`2: entregas \= obtenerVentasEfectivasPorPeriodoOVentaIndividual(modoConsulta, fechaHoraDesde, fechaHoraHasta, idVentaIndividual)\` \| \`:ControladorMargenBruto\` \$\\rightarrow\$ \`:RepositorioPedidos\` \| \*\*Por Atributo\*\* \| Recupera la(s) \`Entrega\` definitiva(s) conciliada(s) con \`CARGO\_POR\_VENTA\` y sus costos históricos en \`:ControladorInventario\`. \|

\---

\#\# 3\. Matriz Transversal de Invariantes y Puertas de Aceptación (M-4 y M-7)

\| ID \| Invariante ratificada \| DSS \| DS \| Contrato \| Dictamen \|

\| :--- \| :--- \| :--- \| :--- \| :--- \| :--- \|

\| \*\*\`I-01\`\*\* \| \`RD-RP004/RP028-001\` (\`H-03\`): \`UC-14\` diferencia explícitamente \`saldoConfirmado\`, \`pagosEnTransitoValidados\` y \`saldoExigibleProvisional\`, manteniendo los saldos intactos al filtrar movimientos por período \| Retorno explícito en \`DSS UC-14\` \| Paso \`2:\` y \`2.1:\` en \`DS UC-14\` \| Salida y Notas en \`CONTRATO\_UC14\` \| \*\*PASÓ (Trazabilidad estática)\*\* \|

\| \*\*\`I-02\`\*\* \| \`RD-RP004/RP028-001\` (\`H-04\`): \`UC-27\` soporta tanto la consulta \*\*por período\*\* como la consulta \*\*por venta individual\*\* (\`idPedido\` / \`idEntrega\`), marcando incompleto si falta algún costo histórico (nunca costo cero) \| Parámetros y ramas en \`DSS UC-27\` \| Fragmento \`alt\` con operandos \`PERIODO\`, \`VENTA\_INDIVIDUAL\` y \`RECHAZO\` en \`DS UC-27\` \| \`CONTRATO\_UC27\` individual con 9 secciones \| \*\*PASÓ (Trazabilidad estática)\*\* \|

\| \*\*\`I-03\`\*\* \| \`RD-F01\` / \`MR-6\` (\`H-10\`): \`COBRO.estadoCobro\` restringido a \`CONFIRMADO\` y \`ANULADO\`; reversión manual mediante contraasiento con \`idCobroAnulado\` en Cuenta Corriente y Caja \| Marcos en \`DSS Vendedor\` \| \`DS UC-29\` con alta (\`CONFIRMADO\`) y anulación (\`ANULADO\` \+ \`idCobroAnulado\`) \| Contratos \`2\` y \`3\` individuales \| \*\*PASÓ (Trazabilidad estática)\*\* \|

\| \*\*\`I-04\`\*\* \| \`UC-26\` vs. \`UC-49\`: Un único \`Reembolso\` por \`Cobro\` electrónico; reintento manual exclusivo de Administrador sobre \`RECHAZADO\`; efectos en Caja y Cuenta Corriente solo cuando pasa a \`PROCESADO\`; \`UC-26\` no incluye ni extiende \`UC-49\` \| Marcos separados \`UC-26\` y \`UC-49\` \| \`DS UC-26\` y \`DS UC-49\` con idempotencia estricta \| Contratos \`6\` y \`7\` individuales \| \*\*PASÓ (Trazabilidad estática)\*\* \|

\| \*\*\`I-05\`\*\* \| Homologación 1:1 de firmas públicas DSS ↔ DS ↔ Contrato y desagrupamiento en 8 contratos individuales (\`H-11\`, \`H05\`) \| 8 firmas canónicas \| Mensaje \`1:\` idéntico en las 7 páginas DS \| 8 Contratos individuales con 9 secciones \| \*\*PASÓ\*\* \|

\| \*\*\`I-06\`\*\* \| Inspección visual y prueba de desplazamiento (\`round-trip\`) en editor gráfico Draw.io (\`M-6\` / \`G5\`) \| XML bien formado \| XML bien formado \| N/A \| \*\*PENDIENTE DE VALIDACIÓN HUMANA EN DRAW.IO\*\* \|

### **Archivo 2: `docs/08-diagramas/revision/DSS_REV05_FINANZAS_FRAGMENTOS.drawio.xml`**

Este archivo XML compatible con **Draw.io** modela en **2 páginas** los escenarios de caja negra (DSS) de `UC-14` y `UC-29` (Página 1: Actor `Vendedor / Administrador`) y `UC-22`, `UC-23`, `UC-26`, `UC-49` y `UC-27` (Página 2: Actores `Administrador` y `MercadoPago`), separados en marcos `sd` independientes (`H-12`) y sin lenguaje SQL interno (`H-19`):

\<mxfile host="app.diagrams.net" modified="2026-10-28T13:00:00.000Z" agent="Gemini-REV05" version="24.7.17" type="device"\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 1: DSS CAJA NEGRA — CUENTA CORRIENTE Y COBROS (UC-14, UC-29)       \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id="dss-rev05-cc-cobros" name="DSS REV05 \- Cuenta Corriente y Cobros (UC-14, UC-29)"\>

    \<mxGraphModel dx="1500" dy="950" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1450" pageHeight="1300" math="0" shadow="0"\>

      \<root\>

        \<mxCell id="0" /\>

        \<mxCell id="1" parent="0" /\>

        \<mxCell id="f1\_title" value="DSS (Caja Negra — REV05) — Actor: Vendedor / Administrador — Escenarios Independientes UC-14 \[RD-RP028\] y UC-29 \[RD-F01\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=13;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="15" width="1300" height="30" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="f1\_actor" value="Vendedor /&\#xa;Administrador" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="110" y="60" width="30" height="60" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="f1\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="119" y="155" width="12" height="1080" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="f1\_sys\_box" value=":Sistema" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;fontSize=13;" vertex="1" parent="1"\>

          \<mxGeometry x="960" y="60" width="140" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="f1\_sys\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1030" y="1260" as="sourcePoint" /\>

            \<mxPoint x="1030" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="f1\_sys\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1024" y="155" width="12" height="1080" as="geometry" /\>

        \</mxCell\>

        \<\!-- MARCO UC-14 CORREGIDO CON RD-RP028 (H-03) \--\>

        \<mxCell id="f1\_sd14" value="sd Escenario Independiente — UC-14: Consultar Cuenta Corriente («include» UC-33) \[RD-RP004/RP028-001\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=680;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="170" width="1120" height="310" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="f1\_14\_ref33" value="ref «include» UC-33 Buscar Cliente (identifica y selecciona el Cliente a consultar)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=250;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="90" y="205" width="760" height="50" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="f1\_14\_m1" value="1: estadoCuenta \= consultarCuentaCorriente(idCliente:Long, fechaDesde:LocalDate\[0..1\], fechaHasta:LocalDate\[0..1\])" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="131" y="295" as="sourcePoint" /\>

            \<mxPoint x="1024" y="295" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="f1\_14\_r1" value="1.1: presenta en modo solo lectura: (1) saldoConfirmado (deudor o a favor), (2) pagosEnTransitoValidados (efectivo declarado por Repartidor en UC-05 pendiente de rendir) y (3) saldoExigibleProvisional, más el historial de movimientos (el filtro por fechas no altera los tres saldos)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1024" y="395" as="sourcePoint" /\>

            \<mxPoint x="131" y="395" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<\!-- MARCO UC-29 CORREGIDO CON RD-F01 (H-10) \--\>

        \<mxCell id="f1\_sd29" value="sd Escenario Independiente — UC-29: Registrar Cobro y Reversión Manual por Contraasiento («include» UC-15) \[RD-F01\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=750;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="510" width="1120" height="670" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="f1\_29\_m1" value="1: idCobro \= registrarCobro(idCliente:Long, idPedido:Long\[0..1\], importe:BigDecimal, medioPago:String, origen:String, referenciaExterna:String\[0..1\])" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="131" y="565" as="sourcePoint" /\>

            \<mxPoint x="1024" y="565" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="f1\_29\_ref15" value="ref «include» UC-15 Evaluar y Actualizar Categoría Comercial (ejecutado tras acreditar el pago en Cuenta Corriente)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=280;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="250" y="595" width="760" height="50" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="f1\_29\_r1" value="1.1: \[importe \&gt; 0 y vínculo con Pedido válido\] registra Cobro con estadoCobro \= CONFIRMADO, acredita PAGO en Cuenta Corriente (conciliando efectivo en tránsito si corresponde a rendición), registra INGRESO en Caja y reevalúa categoría comercial" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1024" y="695" as="sourcePoint" /\>

            \<mxPoint x="131" y="695" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="f1\_29\_r2" value="1.2: \[importe \&lt;= 0, Pedido CANCELADO o de otro Cliente, o confirmación electrónica repetida\] rechaza o reconoce por idempotencia sin duplicar asientos" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1024" y="775" as="sourcePoint" /\>

            \<mxPoint x="131" y="775" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="f1\_opt\_anul" value="opt \[Anulación de Cobro Manual erróneo por contraasiento — RD-F01 / MR1-33 (H-10)\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=560;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="75" y="825" width="1070" height="320" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="f1\_29\_m2" value="2: idContraasiento \= anularCobroManual(idCobro:Long, motivoAnulacion:String)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="131" y="885" as="sourcePoint" /\>

            \<mxPoint x="1024" y="885" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="f1\_29\_r3" value="2.1: \[Cobro MANUAL en estadoCobro \== CONFIRMADO y motivo informado\] actualiza Cobro a estadoCobro \= ANULADO, genera contraasiento en Cuenta Corriente y egreso compensatorio en Caja referenciando el Cobro anulado, y ejecuta UC-15" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1024" y="985" as="sourcePoint" /\>

            \<mxPoint x="131" y="985" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="f1\_29\_r4" value="2.2: \[Cobro ya ANULADO, de origen ONLINE o sin motivo obligatorio\] rechaza la anulación manual (los cobros ONLINE se reembolsan vía UC-26)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1024" y="1095" as="sourcePoint" /\>

            \<mxPoint x="131" y="1095" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 2: DSS CAJA NEGRA — CAJA, REEMBOLSOS Y MARGEN (UC-22,23,26,49,27)  \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id="dss-rev05-caja-margen" name="DSS REV05 \- Caja, Reembolsos y Margen (UC-22,23,26,49,27)"\>

    \<mxGraphModel dx="1550" dy="950" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1500" pageHeight="1650" math="0" shadow="0"\>

      \<root\>

        \<mxCell id="0" /\>

        \<mxCell id="1" parent="0" /\>

        \<mxCell id="f2\_title" value="DSS (Caja Negra — REV05) — Escenarios Independientes UC-22, UC-23, UC-26, UC-49 y UC-27 (Período y Venta Individual RD-RP004)" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=13;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="15" width="1360" height="30" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="f2\_actor" value="Administrador" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="100" y="60" width="30" height="60" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="f2\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="109" y="155" width="12" height="1430" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="f2\_sys\_box" value=":Sistema" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;fontSize=13;" vertex="1" parent="1"\>

          \<mxGeometry x="820" y="60" width="140" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="f2\_sys\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="890" y="1600" as="sourcePoint" /\>

            \<mxPoint x="890" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="f2\_sys\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="884" y="155" width="12" height="1430" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="f2\_mp\_box" value=":MercadoPago&\#xa;(Actor/Sistema Externo)" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;fontSize=12;" vertex="1" parent="1"\>

          \<mxGeometry x="1220" y="60" width="170" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="f2\_mp\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1305" y="1600" as="sourcePoint" /\>

            \<mxPoint x="1305" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="f2\_mp\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1299" y="650" width="12" height="440" as="geometry" /\>

        \</mxCell\>

        \<\!-- MARCO UC-22 \--\>

        \<mxCell id="f2\_sd22" value="sd Escenario Independiente — UC-22: Registrar Movimiento de Caja" style="shape=umlFrame;whiteSpace=wrap;html=1;width=430;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="45" y="170" width="980" height="190" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="f2\_22\_m1" value="1: idMovimientoCaja \= registrarMovimientoCaja(tipoMovimiento:String, importe:BigDecimal, concepto:String, observacion:String\[0..1\])" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="121" y="220" as="sourcePoint" /\>

            \<mxPoint x="884" y="220" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="f2\_22\_r1" value="1.1: \[tipo INGRESO\|EGRESO, importe \&gt; 0, concepto informado y no es cobro de Cliente ni reembolso automático\] registra movimiento manual en Caja" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="884" y="305" as="sourcePoint" /\>

            \<mxPoint x="121" y="305" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<\!-- MARCO UC-23 \--\>

        \<mxCell id="f2\_sd23" value="sd Escenario Independiente — UC-23: Consultar Libro Diario" style="shape=umlFrame;whiteSpace=wrap;html=1;width=390;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="45" y="385" width="980" height="190" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="f2\_23\_m1" value="1: libroDiario \= consultarLibroDiario(fechaInicial:LocalDate, fechaFinal:LocalDate)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="121" y="435" as="sourcePoint" /\>

            \<mxPoint x="884" y="435" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="f2\_23\_r1" value="1.1: presenta en modo solo lectura los movimientos manuales y automáticos del período, total de ingresos, total de egresos y resultado monetario \= ingresos \- egresos" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="884" y="520" as="sourcePoint" /\>

            \<mxPoint x="121" y="520" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<\!-- MARCO UC-26 \--\>

        \<mxCell id="f2\_sd26" value="sd Escenario Independiente — UC-26: Procesar Reembolso Electrónico (Inicio por «extend» UC-06 o Reintento Administrativo)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=750;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="45" y="600" width="1395" height="260" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="f2\_26\_m1" value="1: estadoReembolso \= procesarReembolsoElectronico(idCobroOriginal:Long, idReembolsoReintento:Long\[0..1\], idUsuarioReintento:Long\[0..1\])" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="121" y="650" as="sourcePoint" /\>

            \<mxPoint x="884" y="650" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="f2\_26\_mp" value="1.1: solicitarDevolucionElectronica(referenciaExternaCobro, importe, claveIdempotenciaIntento)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="896" y="695" as="sourcePoint" /\>

            \<mxPoint x="1299" y="695" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="f2\_26\_r1" value="1.2: registra intento sobre el único Reembolso del Cobro; solo si se confirma PROCESADO registra egreso en Caja, ajuste débito en Cuenta Corriente y ejecuta UC-15 (si queda PENDIENTE o RECHAZADO no afecta Caja ni Cuenta Corriente)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="884" y="795" as="sourcePoint" /\>

            \<mxPoint x="121" y="795" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<\!-- MARCO UC-49 \--\>

        \<mxCell id="f2\_sd49" value="sd Escenario Independiente — UC-49: Registrar Resultado de Reembolso Electrónico (Actor: MercadoPago — UC-26 no incluye ni extiende UC-49)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=840;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="45" y="885" width="1395" height="230" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="f2\_49\_m1" value="1: acuse \= registrarResultadoReembolsoElectronico(referenciaExternaIntento:String, estadoInformado:String, firmaVerificacion:String)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1299" y="945" as="sourcePoint" /\>

            \<mxPoint x="896" y="945" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="f2\_49\_r1" value="1.1: verifica autenticidad e idempotencia sobre el Reembolso existente; únicamente en la primera confirmación PROCESADO genera por única vez EGRESO en Caja, AJUSTE\_DEBITO en Cuenta Corriente y ejecuta UC-15" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="896" y="1055" as="sourcePoint" /\>

            \<mxPoint x="1299" y="1055" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<\!-- MARCO UC-27 CORREGIDO CON RD-RP004 (H-04) \--\>

        \<mxCell id="f2\_sd27" value="sd Escenario Independiente — UC-27: Consultar Margen Bruto (Por Período y Por Venta Individual) \[RD-RP004/RP028-001\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=730;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="45" y="1140" width="980" height="410" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="f2\_27\_m1" value="1: reporteMargen \= consultarMargenBruto(modoConsulta:String, fechaHoraDesde:Timestamp\[0..1\], fechaHoraHasta:Timestamp\[0..1\], idVentaIndividual:Long\[0..1\])" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="121" y="1195" as="sourcePoint" /\>

            \<mxPoint x="884" y="1195" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="f2\_27\_alt" value="alt Modalidad de consulta de Margen Bruto \[UC-27 — RD-RP004/RP028-001\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=480;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="70" y="1220" width="930" height="305" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="f2\_27\_g1" value="\[modoConsulta \== PERIODO con rango válido de fechaHoraEntrega\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="140" y="1245" width="520" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="f2\_27\_r1" value="1.1: calcula en solo lectura ingresos efectivos (conciliados con CARGO\_POR\_VENTA), costos históricos (ELABORADO y REVENTA), margen bruto del período e indicador de completitud" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="884" y="1305" as="sourcePoint" /\>

            \<mxPoint x="121" y="1305" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="f2\_27\_div1" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="70" y="1350" as="sourcePoint" /\>

            \<mxPoint x="1000" y="1350" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="f2\_27\_g2" value="\[RD-RP004/RP028-001: modoConsulta \== VENTA\_INDIVIDUAL para un Pedido ENTREGADO\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="140" y="1360" width="620" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="f2\_27\_r2" value="1.2: calcula en solo lectura el ingreso efectivo de esa Entrega individual (tramo original \+ adicionales UC-07), sus costos históricos atribuibles, el margen bruto individual y su estado de completitud" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="884" y="1430" as="sourcePoint" /\>

            \<mxPoint x="121" y="1430" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="f2\_27\_div2" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="70" y="1465" as="sourcePoint" /\>

            \<mxPoint x="1000" y="1465" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="f2\_27\_g3" value="\[Período inválido, Pedido no ENTREGADO o sin operaciones\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="140" y="1472" width="480" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="f2\_27\_r3" value="1.3: informa ausencia de venta efectiva o solicita corrección sin asumir margen ficticio" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="884" y="1510" as="sourcePoint" /\>

            \<mxPoint x="121" y="1510" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

\</mxfile\>

### **Archivo 3: `docs/08-diagramas/revision/DS_REV05_FINANZAS_UC14_22_23_26_27_29_49.drawio.xml`**

Este archivo XML de **7 páginas** para **Draw.io** contiene los Diagramas de Secuencia de Diseño (DS de caja blanca) corregidos para `UC-14`, `UC-29`, `UC-22`, `UC-23`, `UC-26`, `UC-49` y `UC-27`, incorporando `RD-RP004/RP028-001` (`H-03` y `H-04`) y `RD-F01` (`H-10`):

\<mxfile host="app.diagrams.net" modified="2026-10-28T13:05:00.000Z" agent="Gemini-REV05" version="24.7.17" type="device"\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 1: DS UC-14 CONSULTAR CUENTA CORRIENTE (RD-RP028 H-03)             \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id="ds-rev05-uc14" name="DS UC-14 Consultar Cuenta Corriente (REV05)"\>

    \<mxGraphModel dx="1500" dy="850" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1450" pageHeight="920" math="0" shadow="0"\>

      \<root\>

        \<mxCell id="0" /\>

        \<mxCell id="1" parent="0" /\>

        \<mxCell id="u14\_title" value="Diagrama de Secuencia de Diseño (DS — REV05) — UC-14: Consultar Cuenta Corriente («include» UC-33) \[RD-RP004/RP028-001\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="15" width="1220" height="30" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u14\_actor" value="Vendedor /&\#xa;Administrador" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="90" y="60" width="30" height="60" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u14\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="99" y="155" width="12" height="700" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u14\_ctrl\_box" value=":ControladorCuentaCorrienteCobros" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="360" y="60" width="220" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u14\_ctrl\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="470" y="880" as="sourcePoint" /\>

            \<mxPoint x="470" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u14\_ctrl\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="464" y="155" width="12" height="700" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u14\_cc\_box" value=":LibroCuentaCorriente" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="820" y="60" width="185" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u14\_cc\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="912" y="880" as="sourcePoint" /\>

            \<mxPoint x="912" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u14\_cc\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="906" y="250" width="12" height="360" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u14\_ref33" value="ref «include» UC-33 Buscar Cliente (identifica y selecciona unCliente : Cliente)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=250;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="65" y="165" width="760" height="55" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u14\_m1" value="1: estadoCuenta \= consultarCuentaCorriente(idCliente:Long, fechaDesde:LocalDate\[0..1\], fechaHasta:LocalDate\[0..1\])" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="111" y="255" as="sourcePoint" /\>

            \<mxPoint x="464" y="255" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u14\_m2" value="2: res \= recuperarSaldosConfirmadoEnTransitoYProvisionalEHistorial(idCliente, fechaDesde, fechaHasta) \[Atributo — RD-RP028\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="476" y="305" as="sourcePoint" /\>

            \<mxPoint x="906" y="305" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u14\_r2" value="2.1: (saldoConfirmado, pagosEnTransitoValidados de UC-05, saldoExigibleProvisional \= saldoConfirmado \- pagosEnTransitoValidados, List\&lt;MovimientoCuenta\&gt;)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="906" y="385" as="sourcePoint" /\>

            \<mxPoint x="476" y="385" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u14\_alt" value="alt Presentación diferenciada de saldos e historial de Cuenta Corriente \[UC-14 — RD-RP004/RP028-001\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=640;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="435" width="1310" height="380" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u14\_g1" value="\[Cliente válido (con o sin movimientos; el filtro de fechas restringe solo los movimientos exhibidos)\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="125" y="460" width="660" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u14\_r1\_ok" value="3.1: muestra saldoConfirmado (indicando si es deudor o a favor), pagosEnTransitoValidados, saldoExigibleProvisional y movimientos (sin crear Cobro, MovimientoCuenta ni MovimientoCaja)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="464" y="545" as="sourcePoint" /\>

            \<mxPoint x="111" y="545" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u14\_div" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="50" y="645" as="sourcePoint" /\>

            \<mxPoint x="1360" y="645" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u14\_g2" value="\[Cliente no encontrado o rango de fechas inválido\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="125" y="655" width="450" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u14\_r1\_err" value="3.2: solicita repetir búsqueda o corregir fechas sin exponer datos erróneos" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="464" y="745" as="sourcePoint" /\>

            \<mxPoint x="111" y="745" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 2: DS UC-29 REGISTRAR COBRO Y ANULACIÓN MANUAL (RD-F01 H-10)       \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id="ds-rev05-uc29" name="DS UC-29 Registrar Cobro (REV05)"\>

    \<mxGraphModel dx="1650" dy="950" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1600" pageHeight="1300" math="0" shadow="0"\>

      \<root\>

        \<mxCell id="0" /\>

        \<mxCell id="1" parent="0" /\>

        \<mxCell id="u29\_title" value="Diagrama de Secuencia de Diseño (DS — REV05) — UC-29: Registrar Cobro y Anulación Manual («include» UC-15) \[RD-F01: CONFIRMADO / ANULADO\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="15" width="1380" height="30" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u29\_actor" value="Vendedor / Admin&\#xa;(o Confirmación MP UC-21)" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="85" y="60" width="30" height="60" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u29\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="94" y="155" width="12" height="1080" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u29\_ctrl\_box" value=":ControladorCuentaCorrienteCobros" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="330" y="60" width="220" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u29\_ctrl\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="440" y="1260" as="sourcePoint" /\>

            \<mxPoint x="440" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u29\_ctrl\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="434" y="155" width="12" height="1080" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u29\_cob\_box" value="unCobro : Cobro&\#xa;(estadoCobro=CONFIRMADO\|ANULADO)" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="660" y="360" width="220" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u29\_cob\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="770" y="1260" as="sourcePoint" /\>

            \<mxPoint x="770" y="405" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u29\_cob\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="764" y="405" width="12" height="650" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u29\_cc\_box" value=":LibroCuentaCorriente" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="980" y="60" width="175" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u29\_cc\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1067" y="1260" as="sourcePoint" /\>

            \<mxPoint x="1067" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u29\_cc\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1061" y="210" width="12" height="860" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u29\_caj\_box" value=":LibroCaja" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1280" y="60" width="160" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u29\_caj\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1360" y="1260" as="sourcePoint" /\>

            \<mxPoint x="1360" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u29\_caj\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1354" y="550" width="12" height="530" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u29\_m1" value="1: idCobro \= registrarCobro(idCliente:Long, idPedido:Long\[0..1\], importe:BigDecimal, medioPago:String, origen:String, referenciaExterna:String\[0..1\])" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="106" y="185" as="sourcePoint" /\>

            \<mxPoint x="434" y="185" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u29\_m2" value="2: val \= verificarIdempotenciaYVinculoPedido(idCliente, idPedido, referenciaExterna) \[Atributo\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="446" y="230" as="sourcePoint" /\>

            \<mxPoint x="1061" y="230" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u29\_alt" value="alt Registro atómico de Cobro CONFIRMADO \[UC-29 — RD-F01\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=520;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="295" width="1460" height="585" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u29\_g1" value="\[importe \&gt; 0, referenciaExterna no procesada y (idPedido \== null \|\| (Pedido pertenece al Cliente \&amp;\&amp; estado in (PENDIENTE, ENTREGADO)))\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="320" width="900" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u29\_m3\_new" value="3: «create» new(unCliente, unPedido\[0..1\], fechaHora, importe, medioPago, origen, referenciaExterna, estadoCobro=CONFIRMADO)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="446" y="382" as="sourcePoint" /\>

            \<mxPoint x="660" y="382" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u29\_m4" value="4: saldoConfirmado \= registrarMovimientoCuentaPagoYConciliarEfectivoEnTransito(unCliente, unCobro, importe)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="446" y="495" as="sourcePoint" /\>

            \<mxPoint x="1061" y="495" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u29\_m5" value="5: registrarMovimientoCajaIngreso(unCobro, importe, medioPago, origen)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="446" y="575" as="sourcePoint" /\>

            \<mxPoint x="1354" y="575" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u29\_ref15" value="ref «include» UC-15 Evaluar y Actualizar Categoría Comercial (ejecutado tras confirmar PAGO en Cuenta Corriente)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=280;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="380" y="625" width="740" height="55" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u29\_r1\_ok" value="5.1: informa Cobro CONFIRMADO y nuevo saldoConfirmado" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="434" y="720" as="sourcePoint" /\>

            \<mxPoint x="106" y="720" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u29\_div" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="50" y="765" as="sourcePoint" /\>

            \<mxPoint x="1510" y="765" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u29\_g2" value="\[importe \&lt;= 0, Pedido CANCELADO/ajeno o confirmación electrónica repetida\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="775" width="580" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u29\_r1\_err" value="5.2: rechaza vínculo inválido o reconoce Cobro existente por idempotencia sin duplicar asientos" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="434" y="850" as="sourcePoint" /\>

            \<mxPoint x="106" y="850" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<\!-- BLOQUE ANULACION COBRO MANUAL (RD-F01 / H-10) \--\>

        \<mxCell id="u29\_opt\_anul" value="opt \[Anulación de Cobro Manual erróneo por contraasiento — RD-F01 / MR1-33 (H-10)\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=560;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="910" width="1460" height="300" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u29\_m6" value="6: idContraasiento \= anularCobroManual(idCobro:Long, motivoAnulacion:String)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="106" y="965" as="sourcePoint" /\>

            \<mxPoint x="434" y="965" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u29\_m7" value="7: establecerEstadoAnulado(motivoAnulacion) \[estadoCobro \= ANULADO\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="446" y="1015" as="sourcePoint" /\>

            \<mxPoint x="764" y="1015" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u29\_m8" value="8: registrarContraasientoAnulacionCobro(idCobroAnulado=idCobro) en CuentaCorriente y Caja \+ ejecutar UC-15" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="446" y="1075" as="sourcePoint" /\>

            \<mxPoint x="1354" y="1075" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u29\_r6" value="8.1: confirma Cobro ANULADO, contraasientos con idCobroAnulado y categoría reevaluada" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="434" y="1165" as="sourcePoint" /\>

            \<mxPoint x="106" y="1165" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 3: DS UC-22 REGISTRAR MOVIMIENTO DE CAJA                           \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id="ds-rev05-uc22" name="DS UC-22 Registrar Movimiento Caja (REV05)"\>

    \<mxGraphModel dx="1450" dy="800" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1400" pageHeight="880" math="0" shadow="0"\>

      \<root\>

        \<mxCell id="0" /\>

        \<mxCell id="1" parent="0" /\>

        \<mxCell id="u22\_title" value="Diagrama de Secuencia de Diseño (DS — REV05) — UC-22: Registrar Movimiento de Caja" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="15" width="900" height="30" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u22\_actor" value="Administrador" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="90" y="60" width="30" height="60" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u22\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="99" y="155" width="12" height="650" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u22\_ctrl\_box" value=":ControladorCaja" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="380" y="60" width="160" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u22\_ctrl\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="460" y="830" as="sourcePoint" /\>

            \<mxPoint x="460" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u22\_ctrl\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="454" y="155" width="12" height="650" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u22\_caj\_box" value=":LibroCaja" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="740" y="60" width="160" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u22\_caj\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="820" y="830" as="sourcePoint" /\>

            \<mxPoint x="820" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u22\_caj\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="814" y="450" width="12" height="90" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u22\_mov\_box" value="movCaja : MovimientoCaja" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1060" y="320" width="180" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u22\_mov\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1150" y="830" as="sourcePoint" /\>

            \<mxPoint x="1150" y="365" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u22\_mov\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1144" y="365" width="12" height="75" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u22\_m1" value="1: idMovimientoCaja \= registrarMovimientoCaja(tipoMovimiento:String, importe:BigDecimal, concepto:String, observacion:String\[0..1\])" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="111" y="195" as="sourcePoint" /\>

            \<mxPoint x="454" y="195" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u22\_alt" value="alt Validación de tipoMovimiento (INGRESO\|EGRESO), importe \&gt; 0, concepto y exclusión de pagos de Cliente \[UC-22\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=690;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="245" width="1280" height="510" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u22\_g1" value="\[tipoMovimiento in (INGRESO, EGRESO), importe \&gt; 0, concepto \!= vacio y no corresponde a Cobro de Cliente ni Reembolso automático\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="125" y="270" width="780" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u22\_m2\_new" value="2: «create» new(tipoMovimiento, fechaHora, importe, concepto, origen=MANUAL, observacion\[0..1\], idAdmin)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="466" y="342" as="sourcePoint" /\>

            \<mxPoint x="1060" y="342" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u22\_m3" value="3: guardarMovimiento(movCaja:MovimientoCaja) \[Atributo\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="466" y="475" as="sourcePoint" /\>

            \<mxPoint x="814" y="475" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u22\_r1\_ok" value="3.1: confirma MovimientoCaja manual registrado (no crea Cobro, Reembolso ni MovimientoCuenta)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="454" y="555" as="sourcePoint" /\>

            \<mxPoint x="111" y="555" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u22\_div" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="50" y="615" as="sourcePoint" /\>

            \<mxPoint x="1330" y="615" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u22\_g2" value="\[Concepto vacío, importe inválido o intento de registrar pago de Cliente como movimiento aislado\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="125" y="625" width="660" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u22\_r1\_err" value="3.2: impide confirmar e indica procesar pagos de Clientes mediante UC-29" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="454" y="710" as="sourcePoint" /\>

            \<mxPoint x="111" y="710" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 4: DS UC-23 CONSULTAR LIBRO DIARIO                                 \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id="ds-rev05-uc23" name="DS UC-23 Consultar Libro Diario (REV05)"\>

    \<mxGraphModel dx="1400" dy="800" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1350" pageHeight="850" math="0" shadow="0"\>

      \<root\>

        \<mxCell id="0" /\>

        \<mxCell id="1" parent="0" /\>

        \<mxCell id="u23\_title" value="Diagrama de Secuencia de Diseño (DS — REV05) — UC-23: Consultar Libro Diario" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="15" width="850" height="30" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u23\_actor" value="Administrador" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="90" y="60" width="30" height="60" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u23\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="99" y="155" width="12" height="600" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u23\_ctrl\_box" value=":ControladorCaja" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="400" y="60" width="160" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u23\_ctrl\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="480" y="780" as="sourcePoint" /\>

            \<mxPoint x="480" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u23\_ctrl\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="474" y="155" width="12" height="600" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u23\_caj\_box" value=":LibroCaja" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="780" y="60" width="160" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u23\_caj\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="860" y="780" as="sourcePoint" /\>

            \<mxPoint x="860" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u23\_caj\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="854" y="200" width="12" height="140" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u23\_m1" value="1: libroDiario \= consultarLibroDiario(fechaInicial:LocalDate, fechaFinal:LocalDate)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="111" y="190" as="sourcePoint" /\>

            \<mxPoint x="474" y="190" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u23\_m2" value="2: recuperarMovimientosYCalcularResultadoMonetario(fechaInicial, fechaFinal) \[Atributo\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="486" y="235" as="sourcePoint" /\>

            \<mxPoint x="854" y="235" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u23\_r2" value="2.1: List\&lt;MovimientoCaja\&gt; \+ totalIngresos \+ totalEgresos \+ resultadoMonetario \= ingresos \- egresos" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="854" y="305" as="sourcePoint" /\>

            \<mxPoint x="486" y="305" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u23\_alt" value="alt Resultado de la consulta del Libro Diario \[UC-23\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=360;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="365" width="1150" height="340" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u23\_g1" value="\[Período válido con movimientos\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="125" y="390" width="350" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u23\_r1\_ok" value="3.1: presenta movimientos (tipo, fechaHora, importe, concepto, origen, referencia) y resultadoMonetario en solo lectura" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="474" y="455" as="sourcePoint" /\>

            \<mxPoint x="111" y="455" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u23\_div" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="50" y="535" as="sourcePoint" /\>

            \<mxPoint x="1200" y="535" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u23\_g2" value="\[Sin movimientos en el intervalo (A2) o período inválido (A1)\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="125" y="545" width="480" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u23\_r1\_empty" value="3.2: indica vacío y totales del intervalo nulos (sin afirmar saldo de Caja cero) o solicita corregir período" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="474" y="645" as="sourcePoint" /\>

            \<mxPoint x="111" y="645" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 5: DS UC-26 PROCESAR REEMBOLSO ELECTRÓNICO                         \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id="ds-rev05-uc26" name="DS UC-26 Procesar Reembolso Electrónico (REV05)"\>

    \<mxGraphModel dx="1650" dy="950" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1600" pageHeight="1150" math="0" shadow="0"\>

      \<root\>

        \<mxCell id="0" /\>

        \<mxCell id="1" parent="0" /\>

        \<mxCell id="u26\_title" value="Diagrama de Secuencia de Diseño (DS — REV05) — UC-26: Procesar Reembolso Electrónico (extiende UC-06; reintento exclusivo Administrador)" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="15" width="1320" height="30" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u26\_actor" value="Disparador UC-06 /&\#xa;Administrador (Reintento)" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="85" y="60" width="30" height="60" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u26\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="94" y="155" width="12" height="920" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u26\_ctrl\_box" value=":ControladorReembolsos" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="340" y="60" width="180" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u26\_ctrl\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="430" y="1100" as="sourcePoint" /\>

            \<mxPoint x="430" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u26\_ctrl\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="424" y="155" width="12" height="920" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u26\_rem\_box" value="unReembolso : Reembolso" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="680" y="250" width="180" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u26\_rem\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="770" y="1100" as="sourcePoint" /\>

            \<mxPoint x="770" y="295" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u26\_rem\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="764" y="295" width="12" height="320" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u26\_int\_box" value="intento : IntentoReembolso" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="980" y="380" width="185" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u26\_int\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1072" y="1100" as="sourcePoint" /\>

            \<mxPoint x="1072" y="425" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u26\_int\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1066" y="425" width="12" height="80" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u26\_mp\_box" value=":AdaptadorMercadoPago&\#xa;+ :LibroCaja / :LibroCC" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1280" y="60" width="190" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u26\_mp\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1375" y="1100" as="sourcePoint" /\>

            \<mxPoint x="1375" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u26\_mp\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1369" y="530" width="12" height="260" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u26\_m1" value="1: estadoReembolso \= procesarReembolsoElectronico(idCobroOriginal:Long, idReembolsoReintento:Long\[0..1\], idUsuarioReintento:Long\[0..1\])" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="106" y="190" as="sourcePoint" /\>

            \<mxPoint x="424" y="190" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u26\_m2\_new" value="2: «create» / recuperar Reembolso único por Cobro (en reintento valida estado==RECHAZADO y Rol Admin)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="436" y="272" as="sourcePoint" /\>

            \<mxPoint x="680" y="272" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u26\_m3\_new" value="3: «create» new(unReembolso, numeroIntento=sig, claveIdempotencia=UUID, idUsuarioReintento\[0..1\])" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="776" y="402" as="sourcePoint" /\>

            \<mxPoint x="980" y="402" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u26\_m4" value="4: respMP \= solicitarDevolucionIdempotente(referenciaExternaCobro, importe, intento.claveIdempotencia)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="436" y="555" as="sourcePoint" /\>

            \<mxPoint x="1369" y="555" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u26\_alt" value="alt Resultado de MercadoPago: PROCESADO vs. PENDIENTE / RECHAZADO \[UC-26\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=540;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="610" width="1460" height="430" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u26\_g1" value="\[MercadoPago confirma devolución aprobada → estado \= PROCESADO\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="635" width="520" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u26\_m5" value="5: registrarEfectosFinancierosUnicos(EGRESO en Caja \+ AJUSTE\_DEBITO en Cuenta Corriente \+ ejecutar UC-15)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="436" y="705" as="sourcePoint" /\>

            \<mxPoint x="1369" y="705" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u26\_r1\_ok" value="5.1: establece Reembolso PROCESADO, registra EGRESO y AJUSTE\_DEBITO y reevalúa UC-15" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="424" y="780" as="sourcePoint" /\>

            \<mxPoint x="106" y="780" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u26\_div" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="50" y="835" as="sourcePoint" /\>

            \<mxPoint x="1510" y="835" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u26\_g2" value="\[MercadoPago informa PENDIENTE, no disponible o RECHAZADO\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="845" width="520" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u26\_r1\_pend" value="5.2: conserva PENDIENTE o establece RECHAZADO sin generar anticipadamente EGRESO en Caja ni revertir Cuenta Corriente" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="424" y="945" as="sourcePoint" /\>

            \<mxPoint x="106" y="945" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 6: DS UC-49 REGISTRAR RESULTADO DE REEMBOLSO ELECTRÓNICO           \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id="ds-rev05-uc49" name="DS UC-49 Registrar Resultado Reembolso (REV05)"\>

    \<mxGraphModel dx="1600" dy="900" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1550" pageHeight="1050" math="0" shadow="0"\>

      \<root\>

        \<mxCell id="0" /\>

        \<mxCell id="1" parent="0" /\>

        \<mxCell id="u49\_title" value="Diagrama de Secuencia de Diseño (DS — REV05) — UC-49: Registrar Resultado de Reembolso Electrónico (Asíncrono e idempotente)" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="15" width="1280" height="30" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u49\_actor" value="MercadoPago&\#xa;(Notificación Asíncrona)" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="85" y="60" width="30" height="60" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u49\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="94" y="155" width="12" height="820" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u49\_ctrl\_box" value=":ControladorReembolsos" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="350" y="60" width="180" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u49\_ctrl\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="440" y="1000" as="sourcePoint" /\>

            \<mxPoint x="440" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u49\_ctrl\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="434" y="155" width="12" height="820" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u49\_ev\_box" value="evResultado :&\#xa;EventoResultadoReembolso" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="680" y="340" width="195" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u49\_ev\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="777" y="1000" as="sourcePoint" /\>

            \<mxPoint x="777" y="385" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u49\_ev\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="771" y="385" width="12" height="80" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u49\_rem\_box" value="unReembolso : Reembolso" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="990" y="60" width="180" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u49\_rem\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1080" y="1000" as="sourcePoint" /\>

            \<mxPoint x="1080" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u49\_rem\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1074" y="210" width="12" height="420" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u49\_fin\_box" value=":LibroCaja /&\#xa;:LibroCuentaCorriente" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1280" y="60" width="180" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u49\_fin\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1370" y="1000" as="sourcePoint" /\>

            \<mxPoint x="1370" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u49\_fin\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1364" y="560" width="12" height="120" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u49\_m1" value="1: acuse \= registrarResultadoReembolsoElectronico(referenciaExternaIntento:String, estadoInformado:String, firmaVerificacion:String)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="106" y="185" as="sourcePoint" /\>

            \<mxPoint x="434" y="185" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u49\_m2" value="2: (unReembolso, intentoActivo) \= verificarAutenticidadCorrespondenciaEIdempotencia(referenciaExternaIntento)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="446" y="235" as="sourcePoint" /\>

            \<mxPoint x="1074" y="235" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u49\_m3\_new" value="3: «create» new(intentoActivo, estadoInformado, fechaHoraRecepcion, referenciaExternaIntento)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="446" y="362" as="sourcePoint" /\>

            \<mxPoint x="680" y="362" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u49\_alt" value="alt Evaluación idempotente del resultado asíncrono \[UC-49 — UC-26 no incluye ni extiende UC-49\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=660;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="485" width="1440" height="445" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u49\_g1" value="\[estadoInformado \== PROCESADO y unReembolso no estaba PROCESADO previamente\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="510" width="580" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u49\_m4" value="4: marcarProcesadoYRegistrarEgresoCajaYAjusteDebitoCuentaCorriente() \+ ejecutar UC-15" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="446" y="595" as="sourcePoint" /\>

            \<mxPoint x="1364" y="595" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u49\_r1\_ok" value="4.1: aplica por única vez EGRESO en Caja, AJUSTE\_DEBITO en Cuenta Corriente y reevaluación UC-15" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="434" y="700" as="sourcePoint" /\>

            \<mxPoint x="106" y="700" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u49\_div" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="50" y="755" as="sourcePoint" /\>

            \<mxPoint x="1490" y="755" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u49\_g2" value="\[estadoInformado \== RECHAZADO / PENDIENTE, o notificación repetida de un Reembolso ya PROCESADO\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="765" width="700" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u49\_r1\_rech" value="4.2: si es RECHAZADO actualiza estado sin tocar Caja/Cuenta Corriente; si es repetida reconoce estado previo sin duplicar asientos" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="434" y="865" as="sourcePoint" /\>

            \<mxPoint x="106" y="865" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 7: DS UC-27 CONSULTAR MARGEN BRUTO (PERÍODO Y VENTA INDIVIDUAL)    \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id="ds-rev05-uc27" name="DS UC-27 Consultar Margen Bruto (REV05)"\>

    \<mxGraphModel dx="1600" dy="950" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1550" pageHeight="1150" math="0" shadow="0"\>

      \<root\>

        \<mxCell id="0" /\>

        \<mxCell id="1" parent="0" /\>

        \<mxCell id="u27\_title" value="Diagrama de Secuencia de Diseño (DS — REV05) — UC-27: Consultar Margen Bruto (Por Período y Por Venta Individual) \[RD-RP004/RP028-001\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="15" width="1360" height="30" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u27\_actor" value="Administrador" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="85" y="60" width="30" height="60" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u27\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="94" y="155" width="12" height="920" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u27\_ctrl\_box" value=":ControladorMargenBruto" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="350" y="60" width="180" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u27\_ctrl\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="440" y="1100" as="sourcePoint" /\>

            \<mxPoint x="440" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u27\_ctrl\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="434" y="155" width="12" height="920" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u27\_ped\_box" value=":RepositorioPedidos&\#xa;(ENTREGA / CARGO\_POR\_VENTA)" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="700" y="60" width="210" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u27\_ped\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="805" y="1100" as="sourcePoint" /\>

            \<mxPoint x="805" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u27\_ped\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="799" y="210" width="12" height="190" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u27\_inv\_box" value=":ControladorInventario&\#xa;(Costos ELABORADO y REVENTA)" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1080" y="60" width="215" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u27\_inv\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1187" y="1100" as="sourcePoint" /\>

            \<mxPoint x="1187" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u27\_inv\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1181" y="430" width="12" height="150" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u27\_m1" value="1: reporteMargen \= consultarMargenBruto(modoConsulta:String, fechaHoraDesde:Timestamp\[0..1\], fechaHoraHasta:Timestamp\[0..1\], idVentaIndividual:Long\[0..1\])" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="106" y="185" as="sourcePoint" /\>

            \<mxPoint x="434" y="185" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u27\_m2" value="2: entregas \= obtenerVentasEfectivasPorPeriodoOVentaIndividual(modoConsulta, fechaHoraDesde, fechaHoraHasta, idVentaIndividual) \[RD-RP004\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="446" y="235" as="sourcePoint" /\>

            \<mxPoint x="799" y="235" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u27\_r2" value="2.1: ingreso(s) efectivo(s) conciliado(s) con CARGO\_POR\_VENTA (tramo original a condiciones históricas \+ adicionales a importe aceptado UC-07)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="799" y="335" as="sourcePoint" /\>

            \<mxPoint x="446" y="335" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u27\_m3" value="3: costos \= recuperarCostosHistoricosAtribuiblesAVentasEfectivas(entregas) \[Atributo\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="446" y="455" as="sourcePoint" /\>

            \<mxPoint x="1181" y="455" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u27\_r3" value="3.1: costos históricos de ELABORADO entregado (UC-05) \+ costos congelados en MovimientoStockReventa EGRESO\_VENTA \+ flagCompletitud" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1181" y="545" as="sourcePoint" /\>

            \<mxPoint x="446" y="545" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u27\_alt" value="alt Cálculo de Margen Bruto por Período o por Venta Individual \[UC-27 — RD-RP004/RP028-001\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=640;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="50" y="610" width="1420" height="430" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u27\_g1" value="\[modoConsulta \== PERIODO y existen Entregas definitivas en el rango \[fechaHoraDesde, fechaHoraHasta\]\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="635" width="660" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u27\_r1\_per" value="4.1: presenta período, ingresos efectivos agregados, costos históricos (ELABORADO y REVENTA), margen bruto total y estado de completitud" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="434" y="700" as="sourcePoint" /\>

            \<mxPoint x="106" y="700" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u27\_div1" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="50" y="745" as="sourcePoint" /\>

            \<mxPoint x="1470" y="745" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u27\_g2" value="\[RD-RP004/RP028-001: modoConsulta \== VENTA\_INDIVIDUAL y el Pedido/Entrega seleccionado está ENTREGADO\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="755" width="720" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u27\_r1\_ind" value="4.2: presenta el desglose de esa venta individual (ingreso efectivo original \+ adicional, costos históricos de ELABORADO y REVENTA, margen bruto individual y completitud)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="434" y="835" as="sourcePoint" /\>

            \<mxPoint x="106" y="835" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u27\_div2" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="50" y="885" as="sourcePoint" /\>

            \<mxPoint x="1470" y="885" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u27\_g3" value="\[Período inválido, Pedido no ENTREGADO o sin ventas efectivas\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="895" width="520" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u27\_r1\_empty" value="4.3: informa ausencia de operaciones o solicita corrección sin asumir margen ficticio ni usar costos cero" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="434" y="980" as="sourcePoint" /\>

            \<mxPoint x="106" y="980" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

\</mxfile\>

### **Archivo 4: `docs/08-diagramas/revision/CONTRATOS_REV05_FINANZAS_8_OPERACIONES.md`**

Este archivo contiene los **8 Contratos individuales desagrupados** (`UC-14`, `registrarCobro` de `UC-29`, `anularCobroManual` de `UC-29`, `UC-22`, `UC-23`, `UC-26`, `UC-49`, y `UC-27`) con las **9 secciones estándar**, firmas 100% homologadas y aplicación estricta de `RD-RP004/RP028-001` (`H-03`, `H-04`) y `RD-F01` (`H-10`):

\# Contratos de Operación del Sistema (DSS — REV-05) — Finanzas y Consultas (8 Contratos Individuales)

\*\*Proyecto:\*\* Sistema de Gestión para Ale Milanesas (UNaM-FCEQyN)  

\*\*Lote de revisión:\*\* \`REV-05\` (\`UC-14\`, \`UC-29\` alta y anulación manual, \`UC-22\`, \`UC-23\`, \`UC-26\`, \`UC-49\`, \`UC-27\`)  

\*\*Decisiones incorporadas:\*\* \`RD-RP004/RP028-001\` (\`H-03\` en \`UC-14\`: diferenciación de \`saldoConfirmado\`, \`pagosEnTransitoValidados\` y \`saldoExigibleProvisional\`; \`H-04\` en \`UC-27\`: consulta de margen bruto por período y por venta individual), \`RD-F01\` (\`H-10\` en \`UC-29\`: \`COBRO.estadoCobro\` restringido a \`CONFIRMADO\` y \`ANULADO\` y reversión por contraasiento) y desagrupamiento total de contratos (\`H-11\`).

\---

\#\# 1\. Contrato de la Operación \`consultarCuentaCorriente\` (\`UC-14\` «include» \`UC-33\`)

1\. \*\*Nombre:\*\* \`consultarCuentaCorriente(idCliente: Long, fechaDesde: LocalDate\[0..1\], fechaHasta: LocalDate\[0..1\])\`

2\. \*\*Responsabilidades:\*\* Recuperar y presentar en modo solo lectura para un \`Cliente\` (localizado mediante \`UC-33\`) su \*\*saldo confirmado\*\*, los \*\*pagos en tránsito validados\*\* (declarados en \`UC-05\` pendientes de rendir) y el \*\*saldo exigible provisional\*\* (\`RD-RP004/RP028-001\`), junto con el historial completo o filtrado por período de sus \`MovimientoCuenta\`.

3\. \*\*Tipo:\*\* \`Sistema\`

4\. \*\*Referencias cruzadas:\*\* Caso de Uso \`UC-14 — Consultar Cuenta Corriente\`; incluye \`UC-33 — Buscar Cliente\`; Caso de Uso \`UC-05 — Registrar Entrega\`; Decisiones \`RD-RP004/RP028-001\` y \`RD-F04\` (\`H-03\`); Objetivo \`OBJE-10\`; Requisito \`RF-06\`.

5\. \*\*Notas:\*\* Operación estrictamente de solo lectura. Filtrar el historial de movimientos por un rango \`\[fechaDesde, fechaHasta\]\` restringe únicamente las filas exhibidas en pantalla y \*\*mantiene inalterados \`saldoConfirmado\`, \`pagosEnTransitoValidados\` y \`saldoExigibleProvisional\`\*\*.

6\. \*\*Excepciones:\*\*

   \* \*\*A1 — \`Cliente\` no encontrado:\*\* Solicitar repetir la búsqueda mediante \`UC-33\`.

   \* \*\*A2 — Cuenta sin movimientos o con saldo a favor:\*\* Mostrar explícitamente la condición verificable (\`saldoConfirmado \= 0\` o saldo a favor) sin inventar deuda.

   \* \*\*A3 — Rango de fechas inválido (\`fechaDesde \> fechaHasta\`) o permiso insuficiente:\*\* Solicitar corrección o rechazar el acceso sin exponer datos erróneos.

7\. \*\*Salida:\*\*

   \* \`saldoConfirmado\` (deudor o a favor), \`pagosEnTransitoValidados\` (efectivo recibido por Repartidores en \`UC-05\` pendiente de rendición en \`UC-29\`), \`saldoExigibleProvisional \= saldoConfirmado \- pagosEnTransitoValidados\` e historial de \`MovimientoCuenta\` con sus orígenes; o mensajes de las excepciones A1–A3.

8\. \*\*Precondiciones:\*\*

   \* El actor autorizado (\`Vendedor\` o \`Administrador\`) se encuentra autenticado y el \`Cliente\` fue identificado mediante \`UC-33\`.

9\. \*\*Postcondiciones:\*\*

   \* \*(Sin cambios de estado en el sistema: no se generan instancias de \`Cobro\`, \`MovimientoCuenta\` ni \`MovimientoCaja\`)\*.

\---

\#\# 2\. Contrato de la Operación \`registrarCobro\` (\`UC-29\` — Alta de Cobro, «include» \`UC-15\`)

1\. \*\*Nombre:\*\* \`registrarCobro(idCliente: Long, idPedido: Long\[0..1\], importe: BigDecimal, medioPago: String, origen: String, referenciaExterna: String\[0..1\])\`

2\. \*\*Responsabilidades:\*\* Registrar de manera atómica e idempotente un \`Cobro\` con \`estadoCobro \= CONFIRMADO\` (\`RD-F01\`) recibido de un \`Cliente\` (manualmente por Vendedor/Administrador o electrónicamente por \`MercadoPago\` en \`UC-21\`), acreditar el \`PAGO\` en \`MovimientoCuenta\` (conciliando el efectivo en tránsito validado cuando corresponde a la rendición de un reparto de \`UC-05\`), registrar el \`INGRESO\` en \`MovimientoCaja\` y ejecutar \`UC-15\`.

3\. \*\*Tipo:\*\* \`Sistema\`

4\. \*\*Referencias cruzadas:\*\* Caso de Uso \`UC-29 — Registrar Cobro\`; incluye \`UC-15 — Evaluar y Actualizar Categoría Comercial\`; Decisiones \`RD-F01\`, \`RD-F04\` y \`RD-RP028\` (\`H-10\`); Objetivos \`OBJE-10\`, \`OBJE-12\`; Requisitos \`RF-06\`, \`RF-09\`, \`RF-12\`.

5\. \*\*Notas:\*\* Permisos directos para cobro manual: \*\*Administrador y Vendedor\*\* (el Repartidor no ejecuta \`UC-29\`). Los únicos valores válidos de \`Cobro.estadoCobro\` son \`CONFIRMADO\` y \`ANULADO\` (\`RD-F01\`).

6\. \*\*Excepciones:\*\*

   \* \*\*A1 — \`importe \<= 0\` o \`medioPago\` inválido:\*\* Rechazar el registro del Cobro.

   \* \*\*A2 — Se informó \`idPedido\` pero el Pedido no pertenece al \`Cliente\` o se encuentra \`CANCELADO\`:\*\* Rechazar la operación sin registrar el Cobro.

   \* \*\*A3 — \`referenciaExterna\` de pago electrónico ya procesada previamente:\*\* Reconocer el \`Cobro\` existente por idempotencia sin duplicar movimientos en Caja ni en Cuenta Corriente.

7\. \*\*Salida:\*\*

   \* Confirmación del \`Cobro\` (\`idCobro\`, \`estadoCobro \= CONFIRMADO\`), nuevo \`saldoConfirmado\` de Cuenta Corriente y \`categoriaComercial\` resultante tras ejecutar \`UC-15\`; o mensajes de las excepciones A1–A3.

8\. \*\*Precondiciones:\*\*

   \* El actor autorizado (\`Vendedor\` o \`Administrador\`, o el flujo verificado de \`UC-21\`) se encuentra autenticado y existe el \`Cliente\` identificado por \`idCliente\`.

9\. \*\*Postcondiciones:\*\*

   \* Se creó una instancia \`unCobro\` de \`Cobro\` con \`fechaHoraCobro\`, \`importe\`, \`medioPago\`, \`origen\` (\`MANUAL\` \| \`ONLINE\`), \`referenciaExterna\` y \`estadoCobro \= CONFIRMADO\` (\`RD-F01\`), asociada al \`Cliente\`, al \`Usuario\` registrador y opcionalmente al \`Pedido\` (\`0..1\`).

   \* Se creó una instancia de \`MovimientoCuenta\` de tipo \`PAGO\` por \`importe\` (y su \`OrigenMovimientoCuenta\` vinculado a \`unCobro\`), actualizando el \`saldoConfirmado\` del \`Cliente\` (y dando por rendido el efectivo en tránsito correspondiente cuando el cobro manual concilia una recaudación de \`UC-05\`).

   \* Se creó una instancia de \`MovimientoCaja\` de \`tipoMovimiento \= INGRESO\` y \`origen \= COBRO\` asociada a \`unCobro\`.

   \* Se ejecutaron las postcondiciones de \`UC-15\` (reevaluación y eventual actualización de \`Cliente.categoriaComercial\`).

\---

\#\# 3\. Contrato de la Operación \`anularCobroManual\` (\`UC-29\` — Reversión por Contraasiento, «include» \`UC-15\`)

1\. \*\*Nombre:\*\* \`anularCobroManual(idCobro: Long, motivoAnulacion: String)\`

2\. \*\*Responsabilidades:\*\* Revertir de manera trazable un \`Cobro\` de \`origen \= MANUAL\` que se encontraba en \`estadoCobro \= CONFIRMADO\`, cambiando su estado a \`ANULADO\` y generando los contraasientos compensatorios en \`MovimientoCuenta\` y \`MovimientoCaja\` enlazados mediante \`idCobroAnulado\` (\`RD-F01\` / \`MR1-33\`), seguidos de la reevaluación de \`UC-15\`.

3\. \*\*Tipo:\*\* \`Sistema\`

4\. \*\*Referencias cruzadas:\*\* Caso de Uso \`UC-29 — Registrar Cobro\`; incluye \`UC-15 — Evaluar y Actualizar Categoría Comercial\`; Decisión \`RD-F01\` (\`H-10\`); Objetivos \`OBJE-10\`, \`OBJE-12\`; Requisitos \`RF-06\`, \`RF-09\`.

5\. \*\*Notas:\*\* Nunca se elimina físicamente un \`Cobro\` ni sus movimientos originales. Los cobros electrónicos (\`origen \= ONLINE\`) no se anulan por esta vía sino mediante el circuito de reembolso electrónico (\`UC-26\` / \`UC-49\`).

6\. \*\*Excepciones:\*\*

   \* \*\*A1 — \`Cobro\` inexistente, de \`origen \= ONLINE\` o ya en \`estadoCobro \= ANULADO\`:\*\* Rechazar la anulación manual.

   \* \*\*A2 — \`motivoAnulacion\` ausente o vacío:\*\* Exigir el motivo obligatorio antes de confirmar.

7\. \*\*Salida:\*\*

   \* Confirmación del \`Cobro\` en \`estadoCobro \= ANULADO\`, identificadores de los contraasientos generados y nuevo \`saldoConfirmado\` del Cliente; o mensajes de las excepciones A1–A2.

8\. \*\*Precondiciones:\*\*

   \* El actor autorizado (\`Administrador\` o \`Vendedor\` según permisos) está autenticado y existe el \`Cobro\` manual con \`estadoCobro \= CONFIRMADO\`.

9\. \*\*Postcondiciones:\*\*

   \* Se modificó el atributo \`unCobro.estadoCobro\` a \`ANULADO\` (\`RD-F01\`).

   \* Se creó una instancia de \`MovimientoCuenta\` de contraasiento (\`ANULACION\_COBRO\`) por \`unCobro.importe\` vinculada en \`OrigenMovimientoCuenta\` mediante \`idCobroAnulado \= unCobro.idCobro\`, recomponiendo el \`saldoConfirmado\` del \`Cliente\`.

   \* Se creó una instancia de \`MovimientoCaja\` (\`tipoMovimiento \= EGRESO\`) vinculada mediante \`idCobroAnulado \= unCobro.idCobro\` con \`motivoAnulacion\`.

   \* Se ejecutaron las postcondiciones de \`UC-15\`.

\---

\#\# 4\. Contrato de la Operación \`registrarMovimientoCaja\` (\`UC-22\`)

1\. \*\*Nombre:\*\* \`registrarMovimientoCaja(tipoMovimiento: String, importe: BigDecimal, concepto: String, observacion: String\[0..1\])\`

2\. \*\*Responsabilidades:\*\* Registrar un ingreso o egreso manual de Caja con su fecha/hora, importe positivo y concepto obligatorio, sin crear Cobros, Reembolsos ni movimientos en Cuenta Corriente.

3\. \*\*Tipo:\*\* \`Sistema\`

4\. \*\*Referencias cruzadas:\*\* Caso de Uso \`UC-22 — Registrar Movimiento de Caja\`; Objetivo \`OBJE-12\`; Requisito \`RF-09\`.

5\. \*\*Notas:\*\* Los pagos de Clientes y las devoluciones automáticas no pueden registrarse como movimientos manuales aislados en \`UC-22\` (corresponden a \`UC-29\` y \`UC-26\`).

6\. \*\*Excepciones:\*\*

   \* \*\*A1 — \`tipoMovimiento\` distinto de \`INGRESO\`/\`EGRESO\`, \`importe \<= 0\` o \`concepto\` vacío:\*\* Solicitar corrección sin registrar el movimiento.

   \* \*\*A2 — Intento de registrar un pago de Cliente como movimiento manual aislado:\*\* Rechazar la operación e indicar el uso de \`UC-29\`.

7\. \*\*Salida:\*\*

   \* Confirmación del \`MovimientoCaja\` manual registrado (\`idMovimientoCaja\`); o mensajes de las excepciones A1–A2.

8\. \*\*Precondiciones:\*\*

   \* El \`Administrador\` se encuentra autenticado y autorizado.

9\. \*\*Postcondiciones:\*\*

   \* Se creó una instancia de \`MovimientoCaja\` con \`tipoMovimiento\` (\`INGRESO\` \| \`EGRESO\`), \`fechaHoraMovimiento\`, \`importe\`, \`concepto\`, \`observacion\` (\`0..1\`) y \`origen \= MANUAL\`, asociada al \`Usuario\` Administrador.

\---

\#\# 5\. Contrato de la Operación \`consultarLibroDiario\` (\`UC-23\`)

1\. \*\*Nombre:\*\* \`consultarLibroDiario(fechaInicial: LocalDate, fechaFinal: LocalDate)\`

2\. \*\*Responsabilidades:\*\* Recuperar todos los \`MovimientoCaja\` manuales y automáticos registrados dentro del intervalo \`\[fechaInicial, fechaFinal\]\`, sumar los ingresos y egresos del período y presentar el resultado monetario (\`ingresos \- egresos\`) en modo solo lectura.

3\. \*\*Tipo:\*\* \`Sistema\`

4\. \*\*Referencias cruzadas:\*\* Caso de Uso \`UC-23 — Consultar Libro Diario\`; Objetivo \`OBJE-12\`; Requisito \`RF-09\`.

5\. \*\*Notas:\*\* El resultado monetario del período (\`ingresos \- egresos\`) no representa un saldo físico de arqueo de Caja ni una medida de utilidad contable.

6\. \*\*Excepciones:\*\*

   \* \*\*A1 — Período inválido (\`fechaInicial \> fechaFinal\`):\*\* Solicitar corrección de las fechas.

   \* \*\*A2 — Sin movimientos en el intervalo:\*\* Mostrar lista vacía y totales del período nulos sin afirmar que el saldo físico de Caja sea cero.

7\. \*\*Salida:\*\*

   \* Listado cronológico de \`MovimientoCaja\` del período (\`tipoMovimiento\`, \`fechaHoraMovimiento\`, \`importe\`, \`concepto\`, \`origen\`, referencia), \`totalIngresos\`, \`totalEgresos\` y \`resultadoMonetario\`; o mensajes de las excepciones A1–A2.

8\. \*\*Precondiciones:\*\*

   \* El \`Administrador\` se encuentra autenticado y autorizado.

9\. \*\*Postcondiciones:\*\*

   \* \*(Sin cambios de estado en el sistema: operación de solo lectura)\*.

\---

\#\# 6\. Contrato de la Operación \`procesarReembolsoElectronico\` (\`UC-26\` «extend» \`UC-06\`)

1\. \*\*Nombre:\*\* \`procesarReembolsoElectronico(idCobroOriginal: Long, idReembolsoReintento: Long\[0..1\], idUsuarioReintento: Long\[0..1\])\`

2\. \*\*Responsabilidades:\*\* Gestionar de manera idempotente ante \`MercadoPago\` la devolución monetaria de un \`Cobro\` electrónico reembolsable correspondiente a un \`Pedido\` \`CANCELADO\` (ya sea en su inicio automático desde \`UC-06\` o en un reintento manual exclusivo del \`Administrador\` sobre un \`Reembolso\` en estado \`RECHAZADO\`), registrando los efectos financieros internos en Caja y Cuenta Corriente \*\*únicamente cuando la devolución resulta \`PROCESADO\`\*\*.

3\. \*\*Tipo:\*\* \`Sistema\`

4\. \*\*Referencias cruzadas:\*\* Caso de Uso \`UC-26 — Procesar Reembolso Electrónico\`; extiende condicionalmente a \`UC-06 — Cancelar Pedido\`; incluye \`UC-15 — Evaluar y Actualizar Categoría Comercial\` (cuando pasa a \`PROCESADO\`); Pendiente \`F06\`; Objetivos \`OBJE-10\`, \`OBJE-13\`, \`OBJE-17\`; Requisitos \`RF-06\`, \`RF-15\`, \`RF-18\`.

5\. \*\*Notas:\*\* Existe a lo sumo un único \`Reembolso\` por \`Cobro\` electrónico. El reintento manual sobre un \`Reembolso\` \`RECHAZADO\` es exclusivo del \`Administrador\`, opera sobre la misma instancia de \`Reembolso\` y exige \`idUsuarioReintento\`. \`UC-26\` no incluye ni extiende \`UC-49\`.

6\. \*\*Excepciones:\*\*

   \* \*\*A1 — \`Cobro\` no reembolsable, ya reembolsado (\`PROCESADO\`) o con intento externo en curso:\*\* Impedir iniciar una nueva devolución.

   \* \*\*A2 — Reintento solicitado sin Rol \`Administrador\` o sobre un \`Reembolso\` cuyo estado no es \`RECHAZADO\`:\*\* Rechazar el reintento.

   \* \*\*A3 — \`MercadoPago\` no disponible o resultado \`PENDIENTE\` / \`RECHAZADO\`:\*\* Conservar el \`Reembolso\` en \`PENDIENTE\` o establecerlo en \`RECHAZADO\` sin generar egreso en Caja ni ajuste en Cuenta Corriente.

7\. \*\*Salida:\*\*

   \* Estado actualizado del \`Reembolso\` (\`PROCESADO\`, \`PENDIENTE\` o \`RECHAZADO\`) y comprobante de los asientos internos cuando resultó \`PROCESADO\`; o mensajes de las excepciones A1–A3.

8\. \*\*Precondiciones:\*\*

   \* En inicio automático: el \`Pedido\` fue \`CANCELADO\` (\`UC-06\`) y posee un \`Cobro\` electrónico \`CONFIRMADO\` reembolsable. En reintento manual: el actor es \`Administrador\` y existe el \`Reembolso\` en estado \`RECHAZADO\`.

9\. \*\*Postcondiciones:\*\*

   \* Se creó (en el primer intento) o recuperó (en reintento) la única instancia \`unReembolso\` de \`Reembolso\` asociada al \`Cobro\` original.

   \* Se creó una instancia de \`IntentoReembolso\` asociada a \`unReembolso\` con \`numeroIntento\` correlativo, nueva \`claveIdempotencia\` e \`idUsuarioReintento\` (nulo en inicio automático; obligatorio con el \`idUsuario\` del Administrador en reintento manual).

   \* \*\*Únicamente si \`MercadoPago\` confirmó la devolución (\`estado \= PROCESADO\`):\*\* se modificó \`unReembolso.estado\` a \`PROCESADO\`, se creó por única vez una instancia de \`MovimientoCaja\` (\`EGRESO\`), se creó por única vez una instancia de \`MovimientoCuenta\` (\`AJUSTE\_DEBITO\`) actualizando el \`saldoConfirmado\` del \`Cliente\`, y se ejecutaron las postcondiciones de \`UC-15\`.

\---

\#\# 7\. Contrato de la Operación \`registrarResultadoReembolsoElectronico\` (\`UC-49\`)

1\. \*\*Nombre:\*\* \`registrarResultadoReembolsoElectronico(referenciaExternaIntento: String, estadoInformado: String, firmaVerificacion: String)\`

2\. \*\*Responsabilidades:\*\* Verificar la autenticidad, correspondencia e idempotencia de una notificación asíncrona remitida por \`MercadoPago\` respecto de un \`IntentoReembolso\` registrado, actualizar el estado del \`Reembolso\` (\`PROCESADO\` o \`RECHAZADO\`) y aplicar por única vez los efectos financieros en Caja y Cuenta Corriente (más \`UC-15\`) exclusivamente cuando el resultado sea \`PROCESADO\`.

3\. \*\*Tipo:\*\* \`Sistema\`

4\. \*\*Referencias cruzadas:\*\* Caso de Uso \`UC-49 — Registrar Resultado de Reembolso Electrónico\`; Caso de Uso \`UC-26 — Procesar Reembolso Electrónico\`; incluye \`UC-15\` (al confirmar \`PROCESADO\`); Pendiente \`F06\`; Objetivo \`OBJE-17\`; Requisitos \`RF-18\`, \`RNF-04\`.

5\. \*\*Notas:\*\* Actor principal: \`MercadoPago\` (sistema externo). Un resultado \`RECHAZADO\` habilita un eventual reintento administrativo posterior mediante \`UC-26\` sobre la misma instancia de \`Reembolso\`, pero nunca dispara un reintento automático dentro de \`UC-49\`.

6\. \*\*Excepciones:\*\*

   \* \*\*A1 — Comunicación externa con firma inválida, sin correspondencia con un \`IntentoReembolso\` existente o inconsistente:\*\* Registrar la incidencia de auditoría sin asociarla a un Reembolso ajeno ni producir efecto financiero.

   \* \*\*A2 — Notificación repetida de un resultado ya \`PROCESADO\` (idempotencia):\*\* Reconocer el procesamiento previo sin duplicar \`MovimientoCaja\` ni \`MovimientoCuenta\`.

   \* \*\*A3 — Resultado informado \`RECHAZADO\` o no definitivo (\`PENDIENTE\`):\*\* Actualizar el estado sin generar movimientos monetarios en Caja ni en Cuenta Corriente.

7\. \*\*Salida:\*\*

   \* Acuse de procesamiento idempotente hacia \`MercadoPago\` y notificación al Cliente cuando el reembolso quedó \`PROCESADO\`.

8\. \*\*Precondiciones:\*\*

   \* Existe una instancia de \`Reembolso\` e \`IntentoReembolso\` pendiente de resultado definitivo asociada a un \`Cobro\` electrónico.

9\. \*\*Postcondiciones:\*\*

   \* Se creó una instancia de \`EventoResultadoReembolso\` asociada al \`IntentoReembolso\` con \`fechaHoraRecepcion\`, \`estadoInformado\` y \`referenciaExternaIntento\`.

   \* \*\*Si \`estadoInformado \== PROCESADO\` (por primera y única vez para ese \`Reembolso\`):\*\* se modificó \`unReembolso.estado\` a \`PROCESADO\`, se creó una única instancia de \`MovimientoCaja\` (\`EGRESO\`), se creó una única instancia de \`MovimientoCuenta\` (\`AJUSTE\_DEBITO\`) actualizando el \`saldoConfirmado\` del \`Cliente\`, y se ejecutaron las postcondiciones de \`UC-15\`.

   \* \*\*Si \`estadoInformado \== RECHAZADO\`:\*\* se modificó \`unReembolso.estado\` a \`RECHAZADO\` sin crear movimientos en Caja ni en Cuenta Corriente.

\---

\#\# 8\. Contrato de la Operación \`consultarMargenBruto\` (\`UC-27\`)

1\. \*\*Nombre:\*\* \`consultarMargenBruto(modoConsulta: String, fechaHoraDesde: Timestamp\[0..1\], fechaHoraHasta: Timestamp\[0..1\], idVentaIndividual: Long\[0..1\])\`

2\. \*\*Responsabilidades:\*\* Calcular y presentar en modo solo lectura el margen bruto de las ventas efectivas (derivadas exclusivamente de Pedidos en estado \`ENTREGADO\`), tanto \*\*por período\*\* (delimitado por \`Entrega.fechaHoraEntrega\`) como \*\*por venta individual\*\* (\`idPedido\` / \`idEntrega\` según \`RD-RP004/RP028-001\`), restando de los ingresos efectivos conciliados con \`CARGO\_POR\_VENTA\` los costos históricos atribuibles de Productos \`ELABORADO\` y \`REVENTA\` e informando el estado de completitud.

3\. \*\*Tipo:\*\* \`Sistema\`

4\. \*\*Referencias cruzadas:\*\* Caso de Uso \`UC-27 — Consultar Margen Bruto\`; Decisión \`RD-RP004/RP028-001\` (\`H-04\`); Objetivo \`OBJE-14\`; Requisito \`RF-19\`.

5\. \*\*Notas:\*\*

   \* \*\*Doble modalidad aprobada (\`RD-RP004/RP028-001\`):\*\* Soporta \`modoConsulta \= PERIODO\` (agregando todas las \`Entrega\` definitivas cuya \`fechaHoraEntrega\` pertenezca al intervalo) y \`modoConsulta \= VENTA\_INDIVIDUAL\` (desglosando una \`Entrega\` / \`Pedido\` \`ENTREGADO\` específico).

   \* En ambas modalidades, el ingreso efectivo suma el tramo original entregado (con su precio histórico, Promoción congelada y ajuste global congelado) más el tramo adicional entregado (a su importe aceptado en \`UC-07\`, sin aplicarle Promoción ni segundo ajuste global).

   \* Si falta algún costo histórico de \`ELABORADO\` o \`REVENTA\`, \*\*jamás se sustituye por costo cero ni por costo actual\*\*: el resultado se marca expresamente como \*\*incompleto\*\*.

6\. \*\*Excepciones:\*\*

   \* \*\*A1 — Período inválido (\`fechaHoraDesde \> fechaHoraHasta\`), \`idVentaIndividual\` inexistente/no \`ENTREGADO\` o sin ventas efectivas:\*\* Informar la situación sin asumir margen ficticio.

   \* \*\*A2 — Falta algún costo histórico en una o más entregas incluidas:\*\* Marcar expresamente el cálculo como \*\*incompleto\*\* identificando la causa, sin utilizar costo cero.

7\. \*\*Salida:\*\*

   \* En \`PERIODO\`: intervalo consultado, ingresos efectivos totales, costos históricos atribuibles (\`ELABORADO\` y \`REVENTA\`), margen bruto del período y estado de completitud.

   \* En \`VENTA\_INDIVIDUAL\`: identificación del Pedido/Entrega, ingreso efectivo del tramo original y del tramo adicional, costos históricos atribuibles por ítem (\`ELABORADO\` y \`REVENTA\`), margen bruto individual y estado de completitud; o mensajes de las excepciones A1–A2.

8\. \*\*Precondiciones:\*\*

   \* El \`Administrador\` se encuentra autenticado y autorizado.

9\. \*\*Postcondiciones:\*\*

   \* \*(Sin cambios de estado en el sistema: operación estrictamente de solo lectura)\*.

\---

\#\# 9\. Glosario de Términos Asociados (\`REV-05\`)

\* \*\*\`Saldo Confirmado\` (Concepto Financiero — \`UC-14\` / \`RD-RP028\`):\*\* Saldo contable firme de la Cuenta Corriente de un \`Cliente\` resultante de los \`MovimientoCuenta\` definitivos (\`CARGO\_POR\_VENTA\`, \`PAGO\`, \`AJUSTE\_DEBITO\`, \`ANULACION\_COBRO\`).

\* \*\*\`Pagos en Tránsito Validados\` (Concepto Financiero — \`UC-05\` / \`UC-14\` / \`RD-RP028\`):\*\* Efectivo declarado como recibido por el \`Repartidor\` al confirmar una \`Entrega\` (\`UC-05\`), pendiente de rendición y registración en \`UC-29\`.

\* \*\*\`Saldo Exigible Provisional\` (Magnitud Derivada — \`UC-14\` / \`RD-RP028\`):\*\* Importe neto exigible al \`Cliente\` calculado como \`saldoConfirmado \- pagosEnTransitoValidados\`.

\* \*\*\`Cobro\` (Tipo / Concepto — Tabla \`COBRO\`):\*\* Percepción monetaria asociada a un \`Cliente\` cuyo atributo \`estadoCobro\` admite exclusivamente los valores \`CONFIRMADO\` o \`ANULADO\` (\`RD-F01\`).

\* \*\*\`Margen Bruto\` (Magnitud de Gestión — \`UC-27\` / \`RD-RP004\`):\*\* Diferencia entre el ingreso efectivo de ventas entregadas (conciliado con \`CARGO\_POR\_VENTA\`) y los costos históricos atribuibles de los productos \`ELABORADO\` y \`REVENTA\` efectivamente entregados, consultable por período o por venta individual.

### **Estado Acumulado y Próximo Paso: Lote 6 (`REV-06 — Comercial, Clientes y Promociones`)**

Con `REV-05` completado, ya tenemos auditados y corregidos los lotes `REV-02` (Seguridad), `REV-03A/B` (Compras, Cotizaciones, Proveedores y Órdenes), `REV-04A/B` (Pedidos, Reparto, Entregas y Excedentes) y `REV-05` (Finanzas, Cuenta Corriente, Cobros, Reembolsos, Caja y Margen Bruto).

El siguiente paso del plan es el **Lote 6 (`REV-06 — Comercial, Catálogo, Clientes y Promociones`)**, que abarca:

* **Sublote `REV-06A` (Promociones y Precios/Catálogo comercial: `UC-19`, `UC-20`, `UC-24`, `UC-30`, `UC-35`, `UC-47`, `UC-48`, `UC-59`, `UC-60` — 9 CU):** Aplicando transversalmente **`RD-RP023-001` (`H-06`):** regla de promociones simultáneas sin acumulación de descuentos sobre las mismas unidades, selección del mayor beneficio aplicable y congelamiento.  
* **Sublote `REV-06B` (Clientes, Categoría Comercial y Recetas/Consultas restantes: `UC-02`, `UC-10`, `UC-15`, `UC-16`, `UC-31`, `UC-32`, `UC-33`, `UC-36`, `UC-38`, `UC-52`, `UC-57`, `UC-09`, `UC-64`):** Cerrando además las 2 observaciones de `REV-01` en `UC-42` (`H01` y `H02`) para llegar al **Lote 7 (`REV-07`: Matriz Maestra de los 64 CU)** con el 100% de los casos auditados.

¿Avanzamos con **`REV-06A` (`UC-19`, `UC-20`, `UC-24`, `UC-30`, `UC-35`, `UC-47`, `UC-48`, `UC-59`, `UC-60`)**?

