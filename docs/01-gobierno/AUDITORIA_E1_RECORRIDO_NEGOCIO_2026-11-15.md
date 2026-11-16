# Auditoría transversal E1 — Recorrido funcional de negocio

**Fecha del corte de fuentes:** 15/11/2026 (Argentina).  
**Estado:** **REFERENCIA FUNCIONAL DE TRABAJO ADOPTADA POR EL RESPONSABLE** para auditorías posteriores (ratificación comunicada en conversación del 15/11–16/11).  
**Alcance de la adopción:** se acepta este recorrido como supuesto operativo del proyecto. **No** constituye observación de campo, aceptación humana E2E, modificación del G0 o autorización técnica/DDL. Ante contradicción prevalecen los contratos/RD ratificados y se registra hallazgo.

## 1. Fuentes y regla de precedencia

[Plan Rector](PLAN_RECTOR_IMPLEMENTACION_2026-10-29.md), [roadmap 15/11](ROADMAP_OPERATIVO_I3_I7_2026-11-15.md), [G0](b0/RD_B0_G0_001_CIERRE_LINEA_BASE_2026-10-29.md), [REV04B](../08-diagramas/consolidacion-b0/CONTRATOS_REV04B_CORREGIDOS_B0_ACTUALIZADO.md), [REV05](../08-diagramas/consolidacion-b0/CONTRATOS_REV05_CORREGIDOS_B0_ACTUALIZADO.md). Nuevas propuestas financieras [R08.4 PR #53](https://github.com/leandrito369/ale-milanesas/pull/53), [R08.5 PR #54](https://github.com/leandrito369/ale-milanesas/pull/54) y [CR-C/CR-F UC-07 #47/#48](https://github.com/leandrito369/ale-milanesas/pull/47) son **borradores** y se citan como investigación, no norma integrada. Leer [vigencia documental](VIGENCIA_DOCUMENTAL_Y_PRECEDENCIA_2026-11-15.md).

## 2. Cadena de eventos

| Paso | Hecho | Actor predominante | Resultado esperado |
|---|---|---|---|
| P0 | Datos maestros de Cliente, Producto, precios, Receta y stock | ADMIN/Producción | Condiciones válidas para operar |
| P1 | Cargar Pedido | Vendedor o Cliente ONLINE autenticado | Pedido PENDIENTE, cantidades y valores comerciales congelados |
| P2 | Asignar/Reasignar reparto | Vendedor | Repartidor vigente e historial de cambios |
| P3 | Preparar ELABORADO | RESPONSABLE_PRODUCCION | Insumos consumidos por versión de Receta, costo y cantidad de preparación registrados |
| P4 | Verificar stock de REVENTA | Producción | Disponibilidad separada de Insumos |
| P5 | Ofrecer/aceptar Excedente como adicional, cuando aplique | Vendedor + aceptación de Cliente | Compromiso comercial de origen y costo conservados, sin nueva preparación |
| P6 | Registrar Entrega efectiva y única | REPARTIDOR | Cantidades realmente entregadas, no cantidades meramente pedidas |
| P7 | Efectos de stock y comerciales | Sistema | Egreso REVENTA si corresponde, cargo real y remanente ELABORADO como Excedente |
| P8 | Declarar efectivo y consolidar anticipos aplicables | Repartidor/Sistema | Declaración íntegra separada de Cobro, reservas y aplicaciones |
| P9 | Rendir efectivo | ADMIN dentro de UC-29 | Conciliación, Cobros definitivos, Caja y diferencias, sin doble efecto |
| P10 | Consultar Cuenta Corriente y Libro Diario | Actores permitidos por RBAC | Saldo confirmado separado de exigible provisional |

**Importante:** P8 representa una dependencia lógica, no orden cronológico. Un Cobro o anticipo puede preceder a la Entrega.

## 3. Variaciones y hechos no equivalentes

- **Preparación ≠ Entrega.** Consumir Insumo ocurre al fabricar, y la venta de REVENTA descuenta stock en la Entrega.
- **Pedido original ≠ cargo entregado.** Una entrega parcial requiere cantidades efectivas, precios/promociones congelados, ajuste histórico y redondeo consistente.
- **Excedente ≠ nueva preparación.** Cancelación o preparación sobrante conserva costo y cantidades; una reasignación no vuelve a consumir Insumos.
- **Cobro confirmado ≠ anticipo aplicado.** Solo una porción identificada y vigente cuenta como `P_e`; `COBRO.idPedido` por sí solo no demuestra importe aplicado.
- **Declaración `D_e` ≠ Caja/Cobro.** El efectivo declarado íntegramente por el Repartidor no produce automáticamente ingreso ni crédito del Cliente. `V_e`, si se reconoce válidamente, es provisional.
- **Rendición ≠ segundo ingreso por el mismo dinero.** La conversión a Cobro definitivo debe extinguir la reducción provisional correspondiente.
- **Reembolso solicitado ≠ PROCESADO.** Los efectos financieros se producen solo ante resultado definitivo válido y una vez.
- **Captura offline ≠ aceptación central.** Reintentos no duplican Entrega, Cobro ni movimientos de stock.

## 4. Escenarios de contraste E1

| ID | Situación | Propiedad exigida |
|---|---|---|
| S01 | Pedido total entregado | Un cargo real, una Entrega y movimientos consistentes |
| S02 | Solicitado 10, preparado 8, entregado 6 | Se venden 6, quedan 2 preparados como Excedentes; consumo de Insumos de 8 |
| S03 | Cancelar tras preparación | Sin cargo de venta; preservación de Insumos consumidos y Excedentes |
| S04 | Adicional de UC-07 aceptado | Valor/costo de lo efectivamente entregado una vez, sin doble preparación |
| S05 | Anticipo parcial confirmado y aplicado | Solo porción acreditada a esa obligación reduce importe elegible |
| S06 | Declaración excede pendiente | Guardar declaración sin ingreso automático en Caja/Cobro |
| S07 | Rendición parcial | Provisional y definitivo nunca se superponen sobre el mismo tramo |
| S08 | Reembolso y webhook duplicado | Un efecto final solo ante PROCESADO |
| S09 | Entrega reenviada | Idempotencia de comando y ausencia de efectos duplicados |
| S10 | UC-05 y anulación UC-29 concurrentes | Snapshot financiero consistente bajo locks/serialización |
| S11 | Captura offline y sincronización | No se transforma captura no aceptada en venta o cobro |

**Estado de los escenarios:** propuestos para prueba, **no ejecutados** por esta auditoría.

## 5. Hallazgos E1

| ID | Criticidad | Hallazgo |
|---|---|---|
| E1-01 | ALTA | Falta evidencia física canónica del importe de un Cobro aplicado a una obligación específica (IMP-01). |
| E1-02 | ALTA | Tránsito → rendición sin diseño/implementación completa acreditada de conversión atómica. |
| E1-03 | ALTA | UC-05 depende de reglas/CR aún no autorizadas de UC-07 (Excedentes). |
| E1-04 | ALTA | Locks/idempotencia globales no se acreditan con pruebas puntuales. |
| E1-05 | MEDIA-ALTA | Riesgo de confundir la numeración histórica de 49 CU / 59 tablas con G0 64/67 y aplicación 62. **Tratamiento:** [índice de vigencia](VIGENCIA_DOCUMENTAL_Y_PRECEDENCIA_2026-11-15.md). |
| E1-06 | METODOLÓGICA | Operativa de campo no observada. **Tratamiento decidido:** adoptar E1 como referencia de negocio para auditoría, sin afirmar verificación independiente. |
| E1-07 | ALTA | Cierres técnicos CI no equivalen a UI/E2E, aceptación humana o despliegue. |
| E1-08 | MEDIA-ALTA | Fragmentación de decisiones y PR draft dificulta lectura de contrato integral; consolidar por paquete. |

## 6. Estado de transición a E2

**E1 adoptada como línea de trabajo**, no como aceptación final de operación real. E2 debe identificar para cada invariante la regla contractual, representación conceptual/física, servicio, actor, evidencia de prueba y brecha restante. Ver [auditoría E2](AUDITORIA_E2_INVARIANTES_DOMINIO_2026-11-15.md).

**Sin cambios físicos ni funcionales:** G0/source-lock congelado, Issue [app #28](https://github.com/leandrito369/ale-milanesas-app/issues/28) de despliegue pausado, sin alteración de código/SQL, ni permiso de fusionar borradores existentes.
