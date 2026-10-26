# RD-F04-002 — Responsabilidad por la rendición de efectivo del Repartidor

**Fecha:** 26/10/2026  
**Autoridad:** confirmación explícita del responsable del proyecto.  
**Estado:** **APROBADA** para responsable, autorización y momento de rendición; procedimiento detallado **PENDIENTE**.

## Decisión aprobada

**El Administrador recibe la rendición de efectivo del Repartidor y autoriza su registro en el sistema. La rendición se realiza al finalizar cada recorrido de reparto.**

Por lo tanto:
- La recepción y autorización de esta rendición corresponden al rol **ADMINISTRADOR**.
- El **momento aprobado** es el cierre de **cada recorrido de reparto**, no necesariamente el fin del turno ni después de cada entrega individual.
- El Repartidor no obtiene por esta decisión autorización para ejecutar UC-29 Registrar Cobro.
- Tampoco se interpreta que la captura offline de UC-05 Registrar Entrega equivalga a un Cobro confirmado.
- Los cobros persistidos deben respetar RD-F01: solo estados `CONFIRMADO` y `ANULADO`, con control de duplicados e integridad de Caja/Cuenta Corriente.

## Aspectos todavía [A CONFIRMAR]

- Evidencia requerida: detalle por entrega, comprobante, conteo, firmas, diferencias y registro de responsable.
- Procedimiento ante diferencia entre efectivo declarado y entregado.
- Momento en que se aplica el asiento de Cobro/Caja/Cuenta Corriente, evitando contabilización antes de la autorización administrativa.
- Alcance de RP-007 para cobros distintos de la rendición del Repartidor: esta decisión no ratifica ni revoca permisos generales del Vendedor en UC-29.

## Trazabilidad

- RP-006: **resuelto parcialmente** (responsable, autorización y momento de rendición definidos); quedan pendientes evidencia, conciliación de diferencias y procedimiento.
- F04 / S-01; UC-05 Registrar Entrega, UC-29 Registrar Cobro, RD-F04-001 y RD-F01.
- No se modifica SQL, modelo relacional, diagramas, casos de uso ni RBAC físico con esta decisión.
- [PR #5](https://github.com/leandrito369/ale-milanesas/pull/5) documenta la continuidad.
