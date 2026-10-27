# RD-RP004/RP028-001 — Alcance de consultas económicas

**Fecha:** 27/10/2026. **Estado funcional:** APROBADA expresamente por el responsable. **Implementación y pruebas:** PENDIENTES.

## Seis reglas aprobadas

1. **UC-27 Consultar Margen Bruto** permite consulta **por período** y **por venta individual**, sin crear un CU adicional.
2. El margen bruto considera **ventas efectivamente entregadas**: ingresos correspondientes menos **costos históricos atribuibles**.
3. El margen bruto **no es utilidad neta**: no deduce gastos generales, impuestos ni otros costos fuera del alcance definido.
4. **UC-23 Consultar Libro Diario** muestra movimientos monetarios registrados (ingresos, egresos, fechas, conceptos e importes); no calcula margen bruto ni utilidad.
5. **UC-14 Consultar Cuenta Corriente** distingue **saldo confirmado**, **pagos en tránsito validados** y **saldo exigible provisional**, según RD-F04-003/006.
6. Las consultas pueden presentar **totales y desgloses**, pero no alteran movimientos, costos ni registros históricos.

## Compatibilidad y límites

- Conservar costos históricos congelados de elaboración y de salidas de REVENTA; aplicar RD-RP022-001 para costeo/conversiones/redondeos.
- Una consulta por venta individual identifica una Entrega/venta efectiva concreta, sin crear nuevo actor, estado o relación UML automática.
- No equiparar saldo de Caja, ingreso por venta y deuda exigible provisional: conceptos distintos.
- La visualización de datos queda sujeta al rol, a permisos ratificados (RD-RP007-001/002) y al futuro contrato de campos sensibles por rol.
- No se ratifican aquí fórmulas para devoluciones o asignación de gastos generales; si hacen falta, se discutirán separadamente.

## Trazabilidad

RP-004 y RP-028; UC-14, UC-23, UC-27; RD-F04-003/006, RD-RP022-001; MR-5/MR-6.

**Estado:** alcance funcional de RP-004/RP-028 resuelto, servicios, informes y pruebas pendientes. Sin cambio DDL ni código.
