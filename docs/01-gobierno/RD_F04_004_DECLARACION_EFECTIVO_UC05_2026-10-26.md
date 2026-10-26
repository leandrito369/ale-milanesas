# RD-F04-004 — Declaración de efectivo recibido como parte de UC-05

**Proyecto:** Sistema de Gestión para Ale Milanesas  
**Fecha:** 26/10/2026  
**Autoridad:** aprobación explícita del responsable del proyecto en la conversación F04.  
**Estado funcional:** **APROBADA**. **Implementación:** **PENDIENTE** (sin código de aplicación ni pruebas de servicio).

## Decisión aprobada

Como parte de **UC-05 Registrar Entrega**, el Repartidor queda autorizado para **declarar efectivo efectivamente recibido del Cliente**, bajo las condiciones siguientes:

1. Indicar el **importe recibido** y relacionar la declaración con el **Pedido y la Entrega** correspondientes.
2. La declaración puede capturarse **sin conexión** y quedar en una cola local de sincronización, sin efectos financieros inmediatos en el servidor.
3. Tras recuperar la conectividad, el servidor debe **validar identidad, asignación, importe e idempotencia** antes de aceptar la declaración.
4. Únicamente una declaración **sincronizada y validada por el servidor** puede producir el efecto provisional ya aprobado en RD-F04-003: reducción de la **deuda exigible provisional** del Cliente, sin modificar Caja ni el saldo contable confirmado.
5. **Declarar efectivo recibido no es ejecutar UC-29 Registrar Cobro**. El Repartidor no adquiere permiso para registrar/confirmar Cobros, autorizar rendiciones ni crear movimientos de Caja o Cuenta Corriente definitivos.

La declaración representa evidencia operativa de recepción física por parte del Repartidor. Un evento que solo existe en el teléfono o que fue rechazado por el servidor **no** puede contabilizarse ni afectar la exigibilidad provisional central.

## Reglas de coherencia

- **RD-F04-001:** UC-05 y UC-03 admiten captura offline; UC-43 Asignación de reparto es exclusivamente online.
- **RD-F04-002:** el Administrador recibe la rendición al finalizar cada recorrido, autoriza el registro definitivo, documenta diferencias y es el único que las resuelve y cierra con motivo.
- **RD-F04-003:** el pago en tránsito se representa **fuera de `COBRO`**; la exigibilidad provisional es una proyección diferente del saldo contable.
- **RD-F01:** `COBRO.estadoCobro` se mantiene exclusivamente en `CONFIRMADO` / `ANULADO`.
- **S-01 / RP-007:** la declaración dentro de UC-05 **no modifica la autorización para UC-29** de ningún rol.

## Casos de aceptación para el diseño y las pruebas futuras

| Situación | Resultado exigido |
|---|---|
| Repartidor autorizado declara efectivo recibido al entregar, sin conexión | Se captura localmente sin generar Cobro/Caja/PAGO contable |
| Reenvío del mismo identificador de origen | Se reconoce una sola declaración y un solo efecto provisional |
| Evento sincronizado con asignación no válida o identidad no autorizada | Se rechaza o envía a conciliación conforme a reglas de conflicto pendientes, sin aplicación automática |
| Declaración sincronizada y validada | Se reconoce una única vez el importe en tránsito en la proyección provisional |
| Rendición y Cobro definitivo autorizados por Administrador | El reconocimiento provisional cesa en la misma transacción que se aplican los efectos definitivos; no hay doble descuento |
| Declaración pendiente o fallida en teléfono | La Cuenta Corriente central no refleja el pago provisional |

Son **criterios de aceptación a implementar**, no resultados de pruebas ejecutadas.

## Pendientes no resueltos por esta decisión

- Prueba objetiva de recepción (comprobante, firma, confirmación del Cliente, etc.) y política ante declaraciones falsas o disputadas.
- Tratamiento de importes parciales o superiores a la deuda y conciliación del faltante.
- Qué hacer con la exigibilidad del Cliente cuando el Repartidor declara un pago validado, pero no rinde el efectivo.
- Si la proyección provisional influye en habilitación de nuevos Pedidos o en evaluación de categoría comercial.
- Diseño técnico concreto de inbox/cola, tabla(s), índices, estados de operación, contrato API y migración.

**No se aprueba por inferencia** ningún nuevo estado de `COBRO`, permiso UC-29, tabla, columna o cambio de SQL.

## Trazabilidad

F04 / S-01; **UC-05**, UC-29 (solo frontera de autorización), UC-43 (online); RP-006/RP-007; RD-F01, RD-F04-001/002/003.

- [PR #5 — Análisis y decisiones de F04](https://github.com/leandrito369/ale-milanesas/pull/5)
- [Issue #6 — Seguimiento](https://github.com/leandrito369/ale-milanesas/issues/6)
