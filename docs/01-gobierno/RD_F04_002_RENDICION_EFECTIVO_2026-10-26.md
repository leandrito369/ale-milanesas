# RD-F04-002 — Responsabilidad por la rendición de efectivo del Repartidor

**Fecha:** 26/10/2026  
**Autoridad:** confirmación explícita del responsable del proyecto.  
**Estado:** **APROBADA** para la asignación de responsabilidad; procedimiento completo **PENDIENTE**.

## Decisión aprobada

**El Administrador recibe la rendición de efectivo del Repartidor y autoriza su registro en el sistema.**

Por lo tanto:
- La recepción y autorización de esta rendición corresponden al rol **ADMINISTRADOR**.
- El Repartidor no obtiene por esta decisión autorización para ejecutar UC-29 Registrar Cobro.
- Tampoco se interpreta que la captura offline de UC-05 Registrar Entrega equivalga a un Cobro confirmado.
- Los cobros persistidos deben respetar RD-F01: solo estados `CONFIRMADO` y `ANULADO`, con control de duplicados e integridad de Caja/Cuenta Corriente.

## Aspectos todavía [A CONFIRMAR]

- Momento exacto de rendición: al finalizar recorrido, por turno o en otro momento.
- Evidencia requerida: detalle por entrega, comprobante, conteo, firmas, diferencias y registro de responsable.
- Procedimiento ante diferencia entre efectivo declarado y entregado.
- Momento en que se aplica el asiento de Cobro/Caja/Cuenta Corriente, evitando contabilización antes de la autorización administrativa.
- Alcance de RP-007 para cobros distintos de la rendición del Repartidor: esta decisión no ratifica ni revoca permisos generales del Vendedor en UC-29.

## Trazabilidad

- RP-006: **resuelto parcialmente** (responsable y autorización definidos); quedan pendiente procedimiento, oportunidad y evidencias.
- F04 / S-01; UC-05 Registrar Entrega, UC-29 Registrar Cobro, RD-F04-001 y RD-F01.
- No se modifica SQL, modelo relacional, diagramas, casos de uso ni RBAC físico con esta decisión.
- [PR #5](https://github.com/leandrito369/ale-milanesas/pull/5) documenta la continuidad.
