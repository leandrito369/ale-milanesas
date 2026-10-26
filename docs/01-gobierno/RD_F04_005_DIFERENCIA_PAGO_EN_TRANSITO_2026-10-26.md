# RD-F04-005 — Diferencia en un pago en tránsito validado: límite funcional de F04

**Fecha:** 26/10/2026  
**Origen:** aprobación explícita del responsable del proyecto, con instrucción de limitar el alcance.  
**Estado:** **APROBADA** como regla funcional acotada. **Sin implementación ni DDL aprobados**.

## Decisión

Cuando exista un **pago en tránsito ya sincronizado y validado por el servidor**, pero el Repartidor no entregue todo el efectivo correspondiente al rendir su recorrido:

1. **La rendición permanece pendiente de conciliación** por la diferencia, con evidencia e importe esperado/recibido conforme a RD-F04-002.
2. **No se restablece automáticamente como exigible al Cliente** el importe provisionalmente reconocido por el servidor. Se mantiene ese reconocimiento provisional mientras la rendición está pendiente.
3. **No se suma a Caja el efectivo faltante** ni se crea un `COBRO` confirmado o un `MOVIMIENTO_CUENTA` definitivo por un importe no rendido.
4. Solo el **Administrador** está facultado para resolver y cerrar una rendición con diferencias, dejando registrado el motivo, conforme a la decisión previa.

## Límite expreso del alcance

**F04 termina aquí para este supuesto:** identificar y conservar la diferencia como **pendiente de conciliación**. No se incorpora el análisis de causas, investigaciones, atribución de responsabilidad patrimonial, sanciones, disputas o procedimientos detallados para recuperos. Tampoco se decide aquí el tratamiento definitivo del saldo si en el futuro se cierra la conciliación; requiere definición específica si el sistema llegara a necesitarla.

Esto **no cambia** el principio ya aprobado: el reconocimiento provisional existe únicamente cuando el evento fue sincronizado y validado; una captura que continúa offline no modifica la Cuenta Corriente central.

## Compatibilidad y trazabilidad

- **RD-F01:** `COBRO.estadoCobro` sigue restringido a `CONFIRMADO` y `ANULADO`.
- **RD-F04-001:** UC-03 y UC-05 admiten captura offline; UC-43 solo online.
- **RD-F04-002:** rendición al finalizar cada recorrido; Administrador recibe, autoriza y cierra diferencias, dejando el motivo.
- **RD-F04-003:** pago en tránsito independiente y deuda exigible provisional, sin alterar Caja ni saldo contable.
- **RD-F04-004:** declaración del Repartidor en UC-05, sin permiso directo UC-29.
- **F04 / RP-006:** este caso se registra con la conciliación como frontera funcional. No se crean nuevos CU ni se aprueban tablas, campos o estados físicos.

**Pendientes generales ajenos a este caso:** diseño de API/inbox y pruebas de sincronización; evidencia técnica verificable; impacto de la deuda exigible provisional sobre la evaluación comercial de nuevos Pedidos.

Referencia: [PR #5](https://github.com/leandrito369/ale-milanesas/pull/5) · [Issue #6](https://github.com/leandrito369/ale-milanesas/issues/6).
