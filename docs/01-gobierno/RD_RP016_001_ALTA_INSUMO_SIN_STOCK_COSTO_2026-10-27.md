# RD-RP016-001 — Alta de Insumo sin stock físico ni costo histórico

**Fecha:** 27/10/2026. **Estado funcional:** APROBADA expresamente por el responsable. **Implementación/pruebas:** pendientes.

## Reglas aprobadas

1. En UC-50 Registrar Insumo, `stockActual` se inicializa en **0**.
2. El Insumo puede registrarse con sus **parámetros operativos obligatorios**, sin ingreso físico inmediato.
3. Puede existir **sin costo histórico** mientras no haya tenido movimientos valorizados.
4. El primer **ingreso físico real** debe establecer un costo válido y trazable mediante el mecanismo correspondiente.
5. No se permiten consumos ni egresos que provoquen stock negativo.
6. El alta del maestro **no crea movimientos ficticios de inventario ni costos inventados**.

## Alcance e integridad

- Distinguir **alta de maestro** (UC-50), **ingreso de existencia real** y el procedimiento de **SALDO_INICIAL** cuando proceda (UC-42 / RP-015). No registrar SALDO_INICIAL como efecto automático de UC-50.
- El servicio debe comprobar parámetros obligatorios y límites de stock; las validaciones físicas de costo histórico existentes en MR-5/MR-6 no sustituyen el servicio.
- Estas seis reglas **no autorizan** valores numéricos por defecto para parámetros, cambio de esquema, políticas de unidad de medida, ni un método nuevo de valoración.
- Preservar la inmutabilidad y trazabilidad de movimientos y fuentes de costo existentes.

## Estado del pendiente

**RP-016 resuelto funcionalmente** para el alta inicial sin valoración. Quedan especificaciones detalladas de parámetros válidos y pruebas de stock/costos durante la implementación.

**Trazabilidad:** RP-016, UC-50, UC-42, RP-015, F03, MR-5/MR-6.

No se realizaron migraciones ni pruebas de aplicación.
