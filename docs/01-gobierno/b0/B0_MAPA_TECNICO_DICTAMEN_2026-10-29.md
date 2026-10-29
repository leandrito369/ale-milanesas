# B0.3 — Mapa técnico de las 67 operaciones (E01-C)

**Fecha:** 29/10/2026 · **Corte:** PR #23 `530924441122ce47a942720e400e67d3f77fc2d0`, origen DSS/DS/contratos REV `64af3c3baa571c2d512242e396267a31f0da3efd`.  
**Estado:** MAPA TÉCNICO **CANDIDATO**, preparado para revisión de DS/contratos; no equivale a ratificación de clases/servicios ni implementación. **G0 NO APROBADO**.

## Matrices

- [B0_MAPA_TECNICO_67_OPERACIONES_2026-10-29.csv](B0_MAPA_TECNICO_67_OPERACIONES_2026-10-29.csv) — **67 filas/64 CU**, responsabilidad de servicio propuesta, módulo arquitectónico y subdominio, tablas MR-3/MR-5 **existentes**, tipo de transacción candidato, invocación, matriz RBAC ratificada, regla funcional, fuente de contrato/DSS/DS, brechas y pruebas propuestas.
- [B0_COBERTURA_60_TABLAS_Y_OPERACIONES_2026-10-29.csv](B0_COBERTURA_60_TABLAS_Y_OPERACIONES_2026-10-29.csv) — **60 tablas**, relación inversa con operaciones. Una referencia no es prueba de lectura/escritura efectiva, integridad, permiso SQL ni correspondencia 1:1 con clase conceptual.

## Alcance y método del mapeo

1. Se partió del inventario **64 CU / 67 operaciones**, con contratos B0 consolidados cuando existen y fuentes de PR #19 para los demás. Las rutas de DS/DSS corresponden a archivos Draw.io en la rama propuesta, **no** a clases verificadas mediante inspección completa de cada objeto gráfico.
2. Se cruzó la lista de tablas nombradas con el índice exacto de 60 nombres de `docs/05-modelo-relacional/MR3_ESQUEMA_MAESTRO.md`. **Todas las tablas propuestas existen** y los 60 nombres tienen alguna referencia candidata. Esto valida consistencia de nombres, **no** que deban consultarse todas ni que las 67 operaciones efectivamente usen esos conjuntos; los campos SQL, transacciones y responsabilidades deberán cotejarse en B1/B3 contra contratos y SQL.
3. Se conservan los **siete módulos** del [diseño de arquitectura candidato](../../06-arquitectura/B0_ARQUITECTURA_CANDIDATA_2026-10-29.md): `acceso`, `maestros`, `ventas`, `produccion_inventario`, `abastecimiento`, `finanzas`, `canales_integraciones`. Las **12 áreas funcionales** de la matriz solo organizan trabajo: **no son 12 servicios desplegables**.
4. La responsabilidad de servicio propuesta (`ServicioAplicacion_<operacion>_CANDIDATO`) es un **identificador de trazabilidad**, **no nombre ni firma de clase aprobado por DS**. La asignación exacta se revisará contra diagrama DS, contrato y principios GRASP/Larman. Un solo servicio real puede reutilizar operaciones comunes; ninguna obligación a crear un servicio por CU.
5. Las columnas `unidad_transaccional_propuesta` y `origen_invocacion_propuesto` son etiquetas de análisis, **no enums, tablas, endpoints o estados aprobados**. Los permisos `D/D-C/C/X/NR/R/I/E/F` sí provienen de la matriz RBAC ratificada; la implementación de servidor está pendiente.

## Reglas críticas que delimitan responsabilidades entre módulos

- **Pedido/Comercial**: categoría, precio, promoción y condición se congelan en Pedido/Detalle; el servicio de composición registra hechos atómicamente; una política nueva no actualiza históricos.
- **Preparación/Entrega/Excedente**: Preparación limita la cantidad original; Excedentes aceptados no vuelven a consumir insumos; Entrega es definitiva y debe reconciliar entregado, extra y cobro sin doble movimiento.
- **Finanzas**: registrarCobro manual admite Admin/Vendedor; anularCobroManual solo Admin; contraasientos son atómicos e idempotentes; UC-49 procesa resultado autenticado como máximo una vez en estado PROCESADO; Cobro de Repartidor declarado/pendiente no es Cobro definitivo.
- **Acceso**: Usuario/Roles/sesiones revocables, último Admin protegido y PROVEEDOR exclusivo; autorización por contexto servidor.
- **Abastecimiento**: una ronda automática por episodio PRA, vencimiento definido, y Orden de Compra solo por decisión Admin; no defaults inventados.
- **F04**: captura offline UC-03/05; asignar/reasignar UC-43 solo ONLINE. El modelo 60 tablas **carece aún de inbox universal y persistencia de pago en tránsito/rendición ratificados**. La matriz consigna `REVISAR_F04_PERSISTENCIA_S01` en las operaciones impactadas; no inventa columnas ni tablas.

## Brechas abiertas concretas (no cerrar por una matriz automática)

| ID | Brecha | Consecuencia / responsable |
|---|---|---|
| B0-T01 | Verificación **objeto/columna/mensaje** por operación contra cada pestaña del DS + contrato completo, incluyendo excepciones | Revisión técnica DS y contratos antes de construir cada servicio; integrador y agente revisor |
| B0-T02 | Transacción: entradas, locking, atomicidad, rollback e idempotencia exactos por operación monetaria/stock/compra | ADR-B1-02/03 y revisión del servicio en B3 |
| B0-T03 | S-01 F04: inbox, snapshot, eventos y pago en tránsito/rendición no tienen esquema aprobado | CR/ADR de diseño físico; no bloquear módulos ajenos a F04 |
| B0-T04 | API, DTO y consulta física por columna aún no aprobados; no confundir proyección BC-07 con SQL ya implementado | ADR-B1-02 y pruebas B4 |
| B0-T05 | MR-5/MR-6 probado solo para suite de BD; F01 aplicado como parche posterior; proteger originales | B1 estrategia de migraciones/ensayos, no producción |
| B0-T06 | Las fuentes DSS/DS/contratos de PR #10–#19 siguen sin fusionarse; versiones B0 corregidas viven en PR encadenadas | Integrador ratifica paquete canónico; G0 formal pendiente |

**Dictamen:** E01-C tiene cobertura de las **67 operaciones a nivel candidato** y dependencias documentadas. No se puede marcar «técnicamente ratificado» hasta ADR e inspección puntual de diseños, ni «implementado/probado» antes de código ejecutable.
