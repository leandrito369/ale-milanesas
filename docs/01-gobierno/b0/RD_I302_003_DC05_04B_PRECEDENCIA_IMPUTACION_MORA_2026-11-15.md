# RD-I302-003 — DC05-04-B: precedencia de imputación explícita al evaluar deuda y mora

**Fecha:** 15/11/2026.  
**Estado de decisión:** **DC05-04-B APROBADA FUNCIONALMENTE por decisión expresa del responsable**.  
**Estado documental:** **PROPUESTA DE ASIENTO / PR DRAFT / SIN RATIFICACIÓN FÍSICA NI AUTORIZACIÓN DE IMPLEMENTACIÓN**.  
**Alcance:** UC-15/EvaluadorCategoriaComercialInterno, Cuenta Corriente y futura evidencia IMP-01 de anticipos; NO se reabre D5-B, ANT-01, D6-1 ni D7-A.  
**Referencias de gobierno:** PR #53 R08.4 @ `7448e123c3c43c51d48def6a22d10b58679efb2d`, anexo IMP-01 §17; PR #54 R08.5-C @ `cc948fcde1ac2dbfe0a78febff6fd2326b8de258` §10.2/10.5; PR #44/#50/#51/#52; RD-F04-007; F01; REV04B/REV05; G0.  
**Referencias de aplicación:** `ale-milanesas-app` main @ `4dbe38668fc5cbc08d04e10920e3bf165c71be11`, `EvaluadorCategoriaComercialInterno.reevaluar`, `CobroManualService`, Flyway V1–V3.  
**Gobierno main base:** `cdd57ed194268f1f5ab29aa0f55781ddddebdfb5`.

## 1. Texto de decisión funcional expresa

**DC05-04-B — APROBADA (15/11/2026):**

> Las imputaciones monetarias **explícitas, vigentes y verificables** de **Cobros confirmados** deben respetarse primero al evaluar la deuda por obligación y la mora comercial. El criterio **FIFO** se aplica **solo al remanente libre y no imputado** de los créditos confirmados. Una porción monetaria no puede descontarse de dos obligaciones diferentes. Esta elección exige adecuar y comprobar la evaluación de mora en la implementación futura; no aprueba por sí misma el modelo físico IMP-01.

**No aprobado:** DC05-04-A (coexistencia divergente de FIFO global para mora frente a imputación explícita solo en UC-05).

**Preservado:** RD-F04-007: el efectivo declarado por el Repartidor y cualquier pago en tránsito validado que **no** sea Cobro definitivamente confirmado **no recategoriza** al Cliente por sí solo. D5-B y ANT-01 aplican exclusivamente a la obligación vinculada a esa entrega.

## 2. Invariantes que deberá implementar Arquitectura, sin seleccionar todavía DDL

1. El conjunto de importes de Cobros confirmados de un Cliente se conserva: la nueva evidencia de aplicación **no crea otro COBRO, MOVIMIENTO_CUENTA(PAGO) ni MOVIMIENTO_CAJA**.
2. Una porción de Cobro confirmada e imputada explícitamente a una obligación se descuenta **solo** de esa obligación. En particular, no entra simultáneamente al pozo de créditos libres FIFO.
3. El remanente confirmado sin imputación explícita puede aplicarse por FIFO solo una vez y sin absorber importes reservados para otra obligación bajo una política de reserva futura todavía no decidida.
4. La suma entre importes explícitamente imputados, remanentes libres e importes ajustados/contraaplicados tiene que reconciliar con los Cobros confirmados y otros créditos contables aplicables, sin sobreaplicación.
5. Una anulación de Cobro general elimina o invalida de modo coherente sus aplicaciones según la futura **DC05-07**; mientras esa decisión no esté resuelta, no dar por autorizado un mecanismo de anulación nuevo. Se conserva **D7-A** en Cobros asociados a rendición.
6. El cálculo de deuda por obligación y la evaluación de mora deben contemplar deudas anteriores, nuevas, canceladas y saldos favorables sin asignar un mismo importe dos veces.
7. La atribución explícita se sustenta en un vínculo monetario verificable, **no** en el simple dato `COBRO.idPedido`, ni en las inferencias de la FIFO global actual.
8. Los ajustes históricos `AJUSTE_CREDITO`/`AJUSTE_DEBITO`, contraasientos `ANULACION_COBRO` y fechas/orden de deuda requieren tratamiento contractual y pruebas; no suponer que son equivalentes a un anticipo identificado.
9. Revalidar bajo concurrencia y aislamiento del mismo PostgreSQL la versión de aplicaciones, saldos y estados de Cobro antes de recalcular categoría; evitar snapshot de un Cobro anulado o reasignado.
10. Mantener la política vigente de tolerancia a mora y el reloj PostgreSQL, salvo decisión posterior expresa. No cambiarla al aprobar DC05-04-B.

## 3. Ejemplo ilustrativo, no prueba ejecutada

Cliente con Pedido A anterior ya vencido (deuda de $10.000) y Pedido B posterior (deuda de $8.000). Existe un Cobro **confirmado** de $8.000, con aplicación explícita verificable a B:

- **Resultado comercial elegido:** B queda cubierto por ese Cobro; A conserva deuda de $10.000. La evaluación de mora identifica A como impaga si supera la tolerancia.
- **Conducta FIFO global actual no admisible para este supuesto:** asignar los $8.000 a A e indicar B como impago, ignorando la imputación explícita.
- **Control:** el mismo Cobro no puede rebajar A además de B.
- **Reserva pre-entrega:** cuando B aún no tiene cargo confirmado, definir en **DC05-01/02** si los $8.000 se mantienen reservados y cómo se apartan del FIFO sin considerarlos una aplicación definitiva `P_e`.

## 4. Cambios futuros requeridos, NO autorizados

| Frente | Tarea futura necesaria | Gate |
|---|---|---|
| Contratos | Incorporar DC05-04-B en las propuestas de conciliación E-02/E-06/E-07, distinguiendo mora basada en Cobros confirmados de deuda provisional por tránsito | Aprobación de enmiendas de REV04B/REV05/RD-I302-001 |
| IMP-01 | Escoger identidad de obligación, reservas, aplicaciones, liberaciones y reglas de anulación; considerar IMP-B append-only + proyección IMP-A como opción, no aprobación automática | DC05-01/02/03/05/06/07/09 y D12 |
| Evaluación de mora | Reemplazar la aplicación global indiscriminada de créditos por algoritmo `imputaciones explícitas vigentes → créditos libres FIFO`, sin doble consumo ni modificación de RD-F04-007 | Contrato y modelo físico ratificados; PR de aplicación independiente |
| SQL | Evaluar claves foráneas, historial, consistencia y serialización entre `COBRO`, aplicaciones, Cuenta y anulación | R08.6 físico y laboratorio expresamente autorizados |
| Pruebas | IMP-T15, categorías antes/después, dos Pedidos, crédito libre parcial, Cobro anulado, remanente y reservas preentrega, concurrencia con UC-05/29 | Testcontainers PG17.11 y CI sobre commit ejecutado real |

## 5. Puertas pendientes tras esta aprobación

| ID | Estado | Decisión requerida |
|---|---|---|
| **DC05-04-B** | **APROBADA FUNCIONALMENTE** | Aplicar en contratos, implementación futura y pruebas; no reabrir alternativa A sin una nueva decisión expresa |
| **DC05-01/02** | PENDIENTE | Reserva anticipada sobre Pedido y punto de conversión a imputación efectiva por entrega; evitar disponibilidad doble en FIFO |
| **DC05-03** | PENDIENTE | Quién puede crear/corregir/liberar reservas, sin otorgar permisos implícitos |
| **DC05-05/06** | PENDIENTE | Remanentes libres, saldo a favor y liberación tras cancelar Pedido |
| **DC05-07** | PENDIENTE | Anulación de Cobros manuales generales con reserva/aplicación; distinta de D7-A de rendición |
| **DC05-09** | PENDIENTE | Autorizar IMP-B + proyección IMP-A o variante, con fallback seguro cuando falta evidencia |
| **D12** | PENDIENTE | Resolver CR-B0-F04-001 y el corte PE-1/PE-2/IMP-01 online frente a PE-3 offline |
| **DC-01..08** | PENDIENTE | Cálculo, ajuste, redondeo, diferencias y política de reconocimiento provisional |

### Dictamen

DC05-04-B está decidida funcionalmente. **No se autoriza** actualizar `EvaluadorCategoriaComercialInterno`, `CobroManualService`, Flyway, tablas, RBAC, G0, despliegue ni el repositorio de aplicación en este corte. No cerrar R08.6 ni R09 por esta aprobación. La PR de este asiento debe permanecer **OPEN/DRAFT/NO MERGE** hasta la revisión de consistencia y reconciliación contractual.
