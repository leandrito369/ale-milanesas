# F04 — Evaluación de pagos en tránsito durante rendición de reparto

**Fecha:** 26/10/2026. **Carácter:** **DECISIÓN PARCIAL APROBADA** (RD-F04-003: separación del pago en tránsito, descuento en exigibilidad provisional después de validación remota, sin impacto en Caja ni contabilidad). El resto del modelo técnico y las reglas A/C/D/E continúan **PROPUESTOS / PENDIENTES**; **sin SQL implementado**.

**Acta vinculante:** [RD-F04-003](../01-gobierno/RD_F04_003_PAGO_EN_TRANSITO_SALDO_PROVISIONAL_2026-10-26.md).

## 1. Problema operativo identificado por el usuario

Cliente entrega efectivo al Repartidor a las 11:00. La rendición administrativa se valida a las 16:00. Entre ambos momentos, un saldo de Cuenta Corriente que solo considere pagos definitivamente aplicados seguirá mostrando deuda. Si el Cliente consulta o intenta comprar durante esa ventana, puede enfrentar restricciones o reclamaciones pese a haber entregado el dinero.

**Precisión de consistencia eventual:** si el teléfono permanece offline, el servidor no conoce la operación. El reconocimiento provisional en consultas centrales solo puede comenzar **después de sincronizar y validar** la declaración; la hora local de captura por sí sola no implica registro central.

## 2. Fuentes contrastadas

- `RD_F01_ESTADOS_COBRO_2026-10-26.md`: `COBRO.estadoCobro` tiene exclusivamente `CONFIRMADO` y `ANULADO`, y los pagos no confirmados se representan fuera de COBRO.
- `RD_F04_001_ALCANCE_OFFLINE_2026-10-26.md`: captura offline de UC-03 y UC-05; UC-43 exclusivamente online.
- `RD_F04_002_RENDICION_EFECTIVO_2026-10-26.md`: recepción y autorización por Administrador al finalizar cada recorrido; diferencias permanecen pendientes; cierre exclusivo del Administrador con motivo.
- `MR5_CONTRATOS_SERVICIOS.md` S-01: idempotencia, snapshots y permisos; Repartidor no recibe permiso directo UC-29.
- `sql/MR5_DDL_NO_EJECUTADO.sql`: `COBRO` usa `estadoCobro`, `MOVIMIENTO_CUENTA` conserva `saldoResultante`, `ORIGEN_MOVIMIENTO_CUENTA.idCobro` referencia COBRO, `MOVIMIENTO_CAJA.idCobro` refiere al Cobro; los movimientos históricos no se reescriben.
- `CLIENTE.categoriaComercial`: `CUMPLIDOR` o `EN_MORA`; el comportamiento de reevaluación requiere decisión explícita cuando hay pago provisional.

## 3. Compatibilidad con el modelo vigente

| Propuesta | Compatibilidad / límite |
|---|---|
| Añadir `PENDIENTE_RENDICION` a `COBRO.estadoCobro` | **Conflicto directo con RD-F01**; requiere reabrir esa decisión y modificar el CHECK F01. No recomendado. |
| Crear un `COBRO` o `MOVIMIENTO_CUENTA` de tipo `PAGO` al sincronizar declaración no rendida | Confunde asiento definitivo con información todavía no conciliada, altera saldos históricos e introduce reversión/sustitución futura; **no recomendado** sin rediseño completo. |
| Agregar al Cliente una proyección de pago en tránsito separada del saldo contable | **Viable como propuesta**, sin recalcular ni alterar `saldoResultante` y sin impactar Caja, pero requiere persistencia/contrato y autorización formal. |
| Asignar custodia al Repartidor | Viable como responsabilidad operativa **condicionada** a evidencia y validación del evento. No existe todavía mecanismo para declarar o conciliar esa responsabilidad en las 60 tablas actuales. |
| Capturar efectivo desde UC-05 | Si se limita a una **declaración de recepción de efectivo asociada a la entrega**, no es todavía un `COBRO` ni ejerce UC-29; se requiere aprobar explícitamente ese alcance y sus permisos. |

## 4. Alternativa recomendada — registro independiente y dos saldos diferenciados

**Separación funcional aprobada por RD-F04-003, sin aprobar aún su materialización física:** registro de pago en tránsito independiente de `COBRO`. Los nombres técnicos `PAGO_EN_TRANSITO` y `DECLARACION_EFECTIVO_ENTREGA` son candidatos, no denominaciones físicas ratificadas.

- Captura local junto con UC-05: UUID origen, `idPedido`, `idCliente`, `idUsuarioRepartidor`, referencia a asignación y entrega, importe declarado como recibido, fecha/hora local, instantánea y evidencia. La evidencia/custodia son propuestas sujetas a definición.
- Al sincronizar: el servidor valida identidad, autorización para declarar (no UC-29), Pedido, asignación y unicidad; conserva el evento y, si pasa las reglas, lo considera `PENDIENTE_RENDICION`. Este es un estado del **evento independiente**, no de COBRO.
- **Cuenta Corriente confirmada:** saldos reales de `MOVIMIENTO_CUENTA` se mantienen intactos.
- **Consulta operativa:** mostrar por separado `saldoConfirmado`, `importeEnTransitoValidado` y `saldoExigibleProvisional`. El importe en tránsito se descuenta solo de la exigibilidad provisoria para ese Cliente, no constituye un asiento `PAGO` ni crea crédito definitivo.
- **Caja:** cero ingreso al confirmar la declaración; solo contabilizar efectivo realmente recibido y autorizado mediante el flujo posterior del Administrador.
- Al rendir: el Administrador concilia; aplicar registros definitivos `COBRO=CONFIRMADO`, `MOVIMIENTO_CUENTA=PAGO` y `MOVIMIENTO_CAJA=INGRESO` en una transacción que consuma/reconcilie el importe en tránsito exactamente una vez. El descuento provisional cesa simultáneamente; así se evita contabilizar dos veces.
- Si falta dinero en la rendición: registrar diferencia; continuar pendiente de conciliación y no cargar el faltante como ingreso en Caja. RD-F04-005 establece que la deuda exigible no reaparece automáticamente y que la rendición permanece pendiente de conciliación. La atribución de responsabilidad y la investigación están fuera del alcance de F04.

**Cálculo de presentación conceptual:** `saldoExigibleProvisional = saldoConfirmado - sumaDeImportesEnTransitoValidadosYNoAplicados`. Se muestra como **saldo operativo/provisional**, nunca sustituye `MOVIMIENTO_CUENTA.saldoResultante`. La política ante saldos negativos o importes mayores a la deuda requiere decisión, no truncamiento oculto.

## 5. Riesgos por mitigar

1. **Sin sincronización no existe visibilidad central.** El dispositivo puede mostrar su propio estado pendiente; no trasladar la captura local a todas las consultas antes de recibirla.
2. **Declaración falsa o duplicada.** La responsabilidad provisional se activaría solo después de pasar controles en el servidor, con `UNIQUE` por evento y restricciones contra duplicados por entrega/operación; debe haber evidencia verificable.
3. **Conflictos por reasignación, permisos, cancelaciones u otras entregas.** Validar antes de aplicar; enviar a conciliación cuando corresponda.
4. **No conceder UC-29 al Repartidor.** Es una función de declaración vinculada a UC-05, que requiere decisión funcional propia. La contabilización definitiva sigue siendo administrativa.
5. **Categoría `CUMPLIDOR/EN_MORA` y bloqueos comerciales.** No actualizar categoría ni condiciones históricas automáticamente por mero evento pendiente, salvo regla aprobada. Evaluar una vista de **deuda provisional exigible** para consultas y nuevos pedidos.
6. **Faltante tras declaración validada.** RD-F04-005 determina que no se restablece automáticamente la exigibilidad del Cliente y la rendición queda pendiente de conciliación. No investigar causas ni definir responsabilidad patrimonial dentro de F04.
7. **Migración física.** El esquema actual carece de la entidad de pago en tránsito y del inbox universal. Agregar tabla/índices/relaciones exige CR/RD, trazabilidad y pruebas; no se ejecutó ningún DDL.
8. **Proyección atómica.** Garantizar que un evento no contribuya simultáneamente al pago provisional y al definitivo al aplicar cobro, bajo reintentos y concurrencia.

## 6. Decisiones requeridas [A CONFIRMAR]

- **A — Repartidor (APROBADA por RD-F04-004):** puede declarar efectivo recibido asociado a Pedido/Entrega desde UC-05, incluso offline; exige validación posterior de identidad, asignación, importe e idempotencia en servidor. No obtiene permiso de UC-29.
- **B — Cliente (APROBADO por RD-F04-003):** solo el importe del evento sincronizado y validado reduce la **deuda exigible provisional**; el saldo contable y Caja permanecen sin cambios.
- **C — Faltante (APROBADA con alcance acotado por RD-F04-005):** si el evento fue validado y el efectivo no se rinde completamente, la rendición **permanece pendiente de conciliación** y la deuda exigible del Cliente **no reaparece automáticamente**. F04 no diseña investigación, responsabilidad patrimonial ni resolución detallada; esos temas quedan fuera de alcance.
- **D — Categoría:** ¿el pago en tránsito puede evitar restricciones de compra por deuda, aun sin reclasificar automáticamente `CLIENTE.categoriaComercial`?
- **E — Evidencia y límites:** condiciones verificables de aceptación, pagos parciales, importes que exceden deuda, plazo de conciliación, trazabilidad y tratamiento de fraudes.

## 7. Dictamen

**Dictamen actualizado:** la separación del pago en tránsito y la proyección exigible provisional quedaron **aprobadas** por RD-F04-003. La declaración de efectivo del Repartidor como parte de UC-05 está aprobada por RD-F04-004; el tratamiento acotado del faltante quedó aprobado en RD-F04-005; continúan en evaluación la elegibilidad comercial, la evidencia y el diseño físico. No introducir `PENDIENTE_RENDICION` como estado de `COBRO`. No codificar estructuras físicas ni atribuir aprobación a las decisiones A/C/D/E.

**Estado de QA:** revisión estática de coherencia con fuentes documentales y DDL; no hay pruebas PostgreSQL ni servicios offline ejecutados para esta propuesta.
