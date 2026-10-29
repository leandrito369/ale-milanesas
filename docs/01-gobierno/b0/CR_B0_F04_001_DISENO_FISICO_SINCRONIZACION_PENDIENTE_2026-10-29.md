# CR-B0-F04-001 — Diseño físico y contratos de sincronización S-01 / F04

**Fecha de registro:** 29/10/2026  
**Clase:** Solicitud de cambio de diseño técnico **ABIERTA PARA ANÁLISIS**, no aprobación de modificación del esquema.  
**Estado:** **PENDIENTE DE PROPUESTA TÉCNICA, IMPACTO Y RATIFICACIÓN**.  
**Origen:** ratificación de ADR-B1-01/02/03/04/06 con **ADR-B1-05 condicionada explícitamente a una CR específica**.

## 1. Situación y necesidad

La funcionalidad F04 está ratificada por las RD-F04-001 a RD-F04-007: captura offline de UC-03/05, asignación UC-43 exclusivamente online, declaración de efectivo recibida por Repartidor distinta de Cobro, pago en tránsito solo tras validación central y rendición administrada. **No se aprobó todavía** el modelo físico de inbox de eventos, snapshot transaccional, pago en tránsito ni los detalles completos del protocolo S-01. MR-5/MR-6 contiene 60 tablas, 453 columnas, 125 FK; el diseño no cubre un inbox universal ni ese circuito físico completo.

## 2. Impacto propuesto a evaluar, NO AUTORIZADO

- Definir identidad UUID origen y unidad de idempotencia por evento de **UC-03/05**, reenvío sin duplicados y reconocimiento del resultado de sincronización.
- Decidir si realmente se requieren **tablas/columnas nuevas** o si una solución de aplicación sobre estructura vigente satisface el contrato; justificar con ER/DDL/índices/estado y compatibilidad.
- Tratar simultaneidad, orden de locks, permisos y pertenencia de objeto, conflictos por repartidor deshabilitado/asignación revocada y reintentos después de pérdida de respuesta tras COMMIT.
- Diseñar persistencia de **pago en tránsito** y **rendición de efectivo** sin introducir nuevos estados en `COBRO.estadoCobro` (`CONFIRMADO`/`ANULADO` por RD-F01).
- Separar la cola **Android/Room** del inbox/verificación del **servidor**, con controles de datos personales, auditoría y conservación.
- Matriz de pruebas de concurrencia, recuperación, doble envío, importe parcial, saldo provisional y finalización contable sin dobles efectos.

## 3. Fuentes y límites

- [Cierre F04 funcional](../../06-arquitectura/F04_CIERRE_FUNCIONAL_MAESTRO_2026-10-26.md), [contrato S-01 borrador](../../06-arquitectura/F04_CONTRATO_S01_SINCRONIZACION_BORRADOR_2026-10-26.md) y [MR-5 contratos de servicios](../../05-modelo-relacional/MR5_CONTRATOS_SERVICIOS.md).
- [ADR candidatas y ratificación posterior](RD_B0_ADR_ARQUITECTURA_APROBADA_2026-10-29.md); no renumerar CU, no crear endpoints ni estado de Cobro por conjetura.
- Requiere propuesta técnica, evaluación de impacto sobre CU/DSS/DS/contratos/DDL/MR-6 y revisión de seguridad, decisión humana y pruebas aisladas **antes** de codificar/migrar.
- Los documentos de diseño/impacto se controlan desde este repositorio; **código/SQL versionado de aplicación y pruebas de implementación se prepararán en el futuro repositorio**, una vez que el responsable confirme su alta y la CR habilite el cambio.

## 4. Puerta de aprobación

**Rechazado por defecto hasta aprobación:** agregar tabla de evento, modificar columnas/FK/índices de esquema en implementación, cambiar flujos F04 o emitir un Cobro antes de rendición.

**No bloquea** por sí solo la decisión arquitectónica B1-01/02/03/04/06 ni el diseño de los módulos independientes del circuito F04. **Sí bloquea** implementación específica de sincronización/rendición y cualquier migración del modelo correspondiente hasta su resolución.

**Responsable de decisión:** responsable del proyecto; **agente técnico:** puede producir análisis de alternativas y pruebas propuestas, no modificar datos/productivo.
