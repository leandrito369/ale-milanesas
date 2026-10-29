# RD-F08-001 — UC-60: baja definitiva de Promoción en estado CANCELADA

**Fecha de ratificación:** 29/10/2026 (Argentina).  
**Estado funcional:** **APROBADA expresamente por el responsable del proyecto** en la conversación del 29/10/2026, al responder «La ratifico a la decision» a la resolución completa de UC-60 propuesta inmediatamente antes.  
**Objeto:** cerrar reserva `RC-02` de la auditoría transversal de contratos (PR #16).  
**Operación afectada:** `UC-60 — Desactivar Promoción` / `desactivarPromocion(idPromocion: Long)`.

## 1. Decisión formal ratificada

> Se aprueba que la operación `desactivarPromocion` de UC-60, ejecutada exclusivamente por el **Administrador**, cambie `PROMOCION.estado` a **`CANCELADA`** desde `BORRADOR`, `ACTIVA` o `PAUSADA`, previa confirmación y revalidación transaccional. No se permite la reactivación `PAUSADA → ACTIVA`, ni modificar promociones terminales `FINALIZADA` o `CANCELADA`. Se preservan las asociaciones, comunicaciones y descuentos históricos.

La transición **`PAUSADA → CANCELADA`** está autorizada y **no equivale a reactivar**. La transición `PAUSADA → ACTIVA` permanece prohibida.

## 2. Matriz normativa de UC-60

| Estado origen | Destino al confirmar UC-60 | Resultado |
|---|---|---|
| `BORRADOR` | `CANCELADA` | Permitido por F08 y aprobado para UC-60 |
| `ACTIVA` | `CANCELADA` | Permitido por F08 y aprobado para UC-60 |
| `PAUSADA` | `CANCELADA` | Permitido por F08 y aprobado para UC-60 |
| `FINALIZADA` | Sin cambio | Rechazar: estado terminal |
| `CANCELADA` | Sin cambio | Informar estado existente; no duplicar transición |

**Destino único de la baja administrativa definitiva de UC-60:** `CANCELADA`. No se usa `PAUSADA` como destino alternativo de esta operación ni `FINALIZADA` como sinónimo de baja administrativa. `FINALIZADA` continúa representando finalización de vigencia.

## 3. Condiciones transaccionales y efectos conservativos

1. Validar autenticación y autorización de **Administrador**; identificar Promoción, estado y vigencia; advertir sobre el efecto prospectivo; solicitar confirmación.
2. Antes de confirmar, revalidar autorización y estado dentro de la transacción; si cambió el estado o falló la persistencia, no registrar un estado parcial ni confirmar éxito.
3. Una vez `CANCELADA`, impedir toda **aplicación nueva** de la Promoción; UC-21 debe revalidar estado y vigencia al confirmar el Pedido ONLINE.
4. No eliminar ni reescribir `PROMOCION`, sus relaciones de Productos/destinatarios, los intentos de comunicación, ni descuentos y precios comerciales ya congelados en Pedidos confirmados.
5. No generar reenvíos de comunicaciones como efecto de la desactivación ni habilitar reactivación posterior. Si se requiere una nueva campaña, utilizar UC-24 y una Promoción nueva.

## 4. Sustento y precedencia

- **Fase 4 (64 CU, niveles Alto / Extendido / Real):** UC-60 requiere baja lógica, autorización, confirmación, revalidación, conservación histórica y bloqueo de nuevos usos; no determinaba por sí sola el literal exclusivo del estado destino.
- **F08 / MR-5 S-05:** `fn_mr3_promocion_estado` permite físicamente `BORRADOR/ACTIVA/PAUSADA → CANCELADA` y prohíbe `PAUSADA → ACTIVA`; `FINALIZADA` y `CANCELADA` son terminales.
- **RD-RP023-001:** las Promociones se aplican solamente si son elegibles y vigentes; su desactivación/finalización no altera Pedidos históricos.
- **Esta RD**, posterior a las anteriores, decide expresamente el **destino único de UC-60**, antes solo propuesto. No modifica ni reemplaza las demás restricciones de elegibilidad.

## 5. Artefactos afectados y límites

- **Actualizar:** contrato de `UC-60` en `REV06A_COMERCIAL_PROMOCIONES/propuestos/CONTRATOS_REV06A_NUEVE_OPERACIONES.md`; auditoría transversal y actas de REV-06A para identificar la decisión ya ratificada.
- **No modificar:** diagramas DSS/DS (inspección visual cerrada por el responsable), archivo original de Gemini, Word maestro, DDL/SQL, `main` y PR anteriores.
- **Estado de implementación:** **PENDIENTE**. Esta aprobación funcional no certifica que el trigger haya sido ejecutado, ni permisos RBAC, bloqueos/rollback, concurrencia, ni pruebas de servicio. La PR #16 sigue en Draft y sin merge hasta una decisión independiente de integración.

## 6. Disposición

**RC-02 — CERRADA FUNCIONALMENTE** por ratificación expresa. La regla de UC-60 y la matriz de F08 quedan trazadas en esta acta. Se preservan como pendientes separados la implementación, las pruebas y la integración del artefacto en la línea base.
