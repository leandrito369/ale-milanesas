# B0 — Dictamen de cierre contractual y seguridad residual (29/10/2026)

**Estado:** CONSOLIDACIÓN PROPUESTA EN PR, SIN MERGE EN MAIN, SIN PRUEBAS DE APLICACIÓN.

## Estado por hallazgo

| Hallazgo | Estado documental B0 | Evidencia / decisión pendiente |
|---|---|---|
| BC-01 | **RATIFICADO Y PARCHE B0** | RD-B0-BC01, UC-14 solo Vendedor; original REV05 preservado |
| BC-02 | **RATIFICADO Y PARCHE B0** | RD-B0-BC02, UC-03/reprogramar solo Vendedor; original REV04A preservado |
| BC-03 | **RATIFICADO Y PARCHE B0** | RD-B0-BC03, UC-29/anularCobroManual solo Administrador; original REV05 preservado |
| BC-04 | **CORREGIDO EDITORIALMENTE B0** | UC-22/23 `RF-15` en REV05 derivado, `RF-09` solo antecedente histórico |
| BC-05 | **RECONCILIADO EN ADENDA; PROPAGACIÓN PENDIENTE** | [21 referencias](BC05_RECONCILIACION_21_REFERENCIAS_RF.csv) con RF vigentes Fase4; evitar alterar reglas de negocio |
| BC-06 | **CONTROL DEFINIDO; IMPLEMENTACIÓN PENDIENTE** | No equiparar Cobro UC29, efectivo en tránsito UC05, Reembolso UC26 y webhook UC49 |
| BC-07 | **PROPUESTA DE CAMPOS; REQUIERE RATIFICACIÓN** | [15 proyecciones](BC07_PROYECCIONES_MINIMAS_15_ROL_CU.csv), decisiones BC07-R1..R4 |
| BC-08 | **CERRADO DOCUMENTALMENTE** | RD-F08-001 ya propagada en contrato UC-60 y actas REV06A, verificación directa commit `64af3c3baa571c2d512242e396267a31f0da3efd` |
| BC-09 | **CONTROL DOCUMENTADO; SERVICIOS PENDIENTES** | Interfaz automática/externa no crea Rol adicional; pruebas técnicas futuras |
| BC-10 | **CORREGIDO EN ÍNDICE B0** | Copia corregida del índice global UC50 `registrarInsumo` en `docs/08-diagramas/consolidacion-b0/`; índice histórico PR19 preservado, requiere sincronización al integrar |

## Estado RBAC

La matriz [RBAC 67 operaciones](B0_MATRIZ_RBAC_67_OPERACIONES_CIERRE_2026-10-29.csv) contiene **67 × 8 = 536 celdas** y **0 códigos P**, validado por recuento. Accesos activos por columna: Administrador 43, Vendedor 16, Producción 13, Repartidor 7, Proveedor 4, Cliente ONLINE 1, automatismo 3, MercadoPago 2. La matriz describe autorizaciones documentales, **no** implementación API.

## Condiciones para declarar cerrado BC-05 y BC-07

1. BC-05: aprobar esta adenda como matriz de referencias de Fase4 o propagar las correcciones editoriales a todos los contratos con trazabilidad; corregir especialmente RF de UC21/28/06/13 sin inferir un comportamiento que no corresponde a la operación.
2. BC-07: **ratificación expresa** de las 15 proyecciones por CU–Rol y decisiones sobre costo, contacto, domicilio y órdenes de Producción. No se puede concluir 'cerrado' simplemente por aplicar mínimo privilegio genérico.
3. BC-10: al integrar PR #19 o consolidar versiones, preservar el índice derivado B0 y corregir la mención de UC-50 en el índice finalmente ratificado.

**Conclusión:** BC01-04/08/10 resueltos en las fuentes derivadas y documentados; BC05 tratado pero requiere criterio de cierre documental; BC07 necesita decisión de negocio/seguridad. G0 **continúa NO APROBADO** porque también faltan mapeo de servicios/tabla/transacción, ADR, aprobación de fuentes y PR.

## Actualización posterior — RD del responsable de 29/10/2026 (prevalece sobre estados previos)

- **BC-05 = CERRADO DOCUMENTALMENTE EN B0:** adenda aceptada y [21 anotaciones propagadas](BC05_PROPAGACION_21_OPERACIONES_2026-10-29.csv) a ocho contratos derivados, pendiente de revisión/fusión del PR.
- **BC-07 = CERRADO FUNCIONALMENTE:** el responsable ratificó [15 proyecciones](BC07_PROYECCIONES_MINIMAS_RATIFICADAS_2026-10-29.csv), con exclusiones en [RD-B0-BC07](RD_B0_BC07_2026-10-29.md). Campos excluidos no se autorizan por defecto; ejecución API pendiente.
- **BC-09 = DOCUMENTADO** en [regla explícita](BC09_REGLA_INVOCACION_INTERNA_EXTERNA_2026-10-29.md), sin actor/rol adicional.
- **BC-06 = PENDIENTE PRUEBAS REALES:** [18 casos](BC06_CASOS_PRUEBA_IMPLEMENTACION_18.csv), **0 ejecutados** por ausencia de backend. Controles de documentos B0 separados.

**G0 permanece NO APROBADO:** faltan mapeo servicio/DB/transacción, ADR e integración aprobada de PR.
