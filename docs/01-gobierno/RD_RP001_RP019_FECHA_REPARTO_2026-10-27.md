# RD-RP001/RP019 — Fecha de reparto para Pedidos internos y ONLINE

**Fecha:** 27/10/2026 · **Estado funcional:** APROBADA por el responsable del proyecto. **Implementación y pruebas:** pendientes.

## Reglas aprobadas

1. Todo Pedido debe tener una **fecha de reparto definida antes de su confirmación**.
2. Para Pedidos internos (**UC-03**), la fecha la selecciona el **Usuario autorizado**.
3. Para Pedidos ONLINE (**UC-21**), el **Cliente** selecciona una fecha entre las opciones habilitadas por el sistema.
4. El **servidor valida** que la fecha sea admisible según las condiciones operativas vigentes.
5. No se fija por esta RD una **cantidad máxima de días de anticipación ni horarios obligatorios**.

## Consistencia con otras decisiones

- UC-03 permite captura offline conforme RD-F04-001, pero **la confirmación central del Pedido requiere revalidación del servidor**; tener una fecha seleccionada localmente no asegura disponibilidad o validez al sincronizar.
- UC-21 conserva las condiciones propias de acceso ONLINE y Cliente habilitado; la fecha elegida debe ser una de las habilitadas al momento de la validación aplicable.
- Esta decisión **no modifica estados** de `PEDIDO`, no introduce un nuevo CU ni altera el histórico comercial confirmado.
- Las reglas de **reprogramación de fecha** para Pedidos ya existentes pertenecen al pendiente separado **RP-020**.
- La definición de calendario operativo (feriados, días de entrega, cupos, excepciones) no se infiere de esta RD.

## Criterios de aceptación futuros

- Pedido interno no puede confirmarse sin fecha elegida y validada.
- Pedido ONLINE solo puede confirmar fecha habilitada y validada por servidor.
- Captura offline con fecha luego no admisible genera conflicto explícito al sincronizar; no confirmar silenciosamente ni cambiar fecha sin autorización.
- Sin fijar por defecto ventanas de anticipación u horarios.

## Trazabilidad

RP-001 / RP-019; UC-03 y UC-21; RD-F04-001 y contrato S-01. [PR #9](https://github.com/leandrito369/ale-milanesas/pull/9).

**Esta RD no autoriza una migración, endpoint o configuración de calendario concreta.**
