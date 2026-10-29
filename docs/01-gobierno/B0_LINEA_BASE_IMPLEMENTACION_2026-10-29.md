# B0 — Consolidación de línea base y preparación de construcción

**ID:** B0-2026-10-29 · **Estado:** PRIORIZADO / PENDIENTE DE EJECUCIÓN.  
**Fuente de mandato:** `PLAN_RECTOR_IMPLEMENTACION_2026-10-29.md`.  
**Criterio:** inventariar, contrastar y resolver bloqueos antes de abrir implementación general; NO rehacer el análisis completo.

## Entradas de autoridad a revisar, en orden

1. `AGENTS.md`, `docs/ESTADO_ACTUAL.md`, `docs/01-gobierno/PROTOCOLO_CAMBIOS_Y_CHATS.md`.
2. Documento original `docs/04-casos-uso/CASOS_DE_USO_64_TRES_NIVELES.docx` y adenda de relaciones UML; no renumerar CU ni reconstruir diagrama rechazado.
3. DSS, DS y contratos de **64 CU declarados completos por el responsable el 29/10**, con fuente/versiones por localizar o incorporar en repo. No declararlos auditados por su sola mención.
4. RD/RP vigentes y resoluciones posteriores: RD-F01, RD-F04-001..007, PRA-01, contratos S-01 propuestos; resolver precedencia documental explícitamente.
5. Modelo relacional MR-3/MR-5 de **60 tablas / 453 columnas / 125 FK**; MR-6 evidencia PostgreSQL 17.11 en CI; F01 parche y cobertura de F04–F09. Los documentos del 23/10 con 59 tablas son históricos.

## Paquetes de trabajo de B0

| WBS | Acción | Evidencia/entregable | Definición de salida |
|---|---|---|---|
| B0.1 | Inventario canónico: rutas, hashes/versiones y estado de DOCX, DSS, DS, contratos, UML y reglas | E01-A inventario de fuentes | Ningún CU sin ubicación o «falta fuente» explícito |
| B0.2 | Validar correspondencia de 64 CU: actor, flujo, DSS, DS, operación contractual, dependencia, estado | E01-B matriz 64×componentes | IDs estables; inconsistencias enumeradas, no silenciadas |
| B0.3 | Mapear operaciones a módulos/servicios, persistencia, transacción, autorización y API/UI | E01-C mapa de diseño técnico | Responsables sin solapamientos; operaciones compartidas reutilizadas |
| B0.4 | Reconciliar MR-5/MR-6/F01/F04 y gaps de integridad: sin editar DDL histórico | E01-D evaluación de brechas | Distingue probado en BD vs pendiente de servicio |
| B0.5 | Definir límites de módulos, herramientas propuestas, entornos, estrategia de migración y pruebas | E02 borrador arquitectura + ADR pendientes | Elecciones ratificadas antes de introducir código dependiente |
| B0.6 | Priorizar backlog por recorridos I0–I7 y dependencias; especificar pruebas de aceptación | E01-E backlog y criterios de CU | Primer vertical de Pedidos, responsables y tests claros |
| B0.7 | Preparar gate G0 con revisión académica/usuario y lista de pendientes de decisión | Informe B0 + PR + RP/CR | Aprobación de línea base o bloqueos registrados |

## Matriz maestra (formato mínimo)

`CU_ID | versión_fuente | RF/RNF | DSS_ruta | DS_ruta | contrato_operación_ruta | módulo | servicio/operación | tablas/vistas | transacción | rol/permisos | endpoint/interfaz | tests_positivos | tests_negativos | estado_evidencia | RD/RP/CR | observaciones`.

Usar una fila por **operación significativa**, no necesariamente una por CU. Debe ser posible filtrar por CU y localizar todas sus operaciones; ningún valor «completo» sin ruta verificable. Plantilla existente: `docs/99-plantillas/MATRIZ_TRAZABILIDAD.csv` (ampliar mediante CR o crear matriz de implementación, sin destruir la histórica).

## Primeros contratos de integración interna a identificar

- Autenticación/roles y control de autorización con UC/roles vigentes.
- Clientes, Productos/Precios y Carga de Pedido con snapshot comercial.
- Receta/Preparación/Entrega con costos e inventario.
- Cuenta/Caja/Cobro; diferencias entre Cobro, declaración de efectivo y pago en tránsito.
- Reposición PRA-01, Marketplace/Mercado Pago y resultados idempotentes.
- Sincronización F04 (solo capturas admitidas offline; **asignación exclusivamente ONLINE** según RD-F04).
  
**No elegir nombres finales de endpoints o tablas nuevas en B0 sin ADR/CR.**

## Gate G0 — aceptación para comenzar construcción

- [ ] Se conoce la **fuente canónica de cada uno de los 64 DSS, DS y contratos** o se registró faltante con dueño/resolución.
- [ ] Existe mapa de dependencias con fuentes y versión por operación.
- [ ] Toda contradicción que altera regla de negocio tiene RP o decisión ratificada, sin «solución» inventada por IA.
- [ ] Se distingue claramente MR-6 probado en laboratorio de servicios aún no implementados; F01 y F04 correctamente incorporados.
- [ ] Se acordó una arquitectura preliminar y estrategia de migraciones sin tocar datos reales.
- [ ] I0/I1 tienen entregables y pruebas definidos; el primer vertical de Pedido está descompuesto por capas.
- [ ] PR de B0 incluye diff, matriz, límites de verificación y responsable de aprobación.

## Tareas delegables inmediatas

**Antigravity / otros agentes UI:** inspección de flujos y mapa pantalla→operación→estado, prototipos no normativos; NO introducir valores comerciales nuevos.  
**OpenCode / agentes de código:** auditoría del árbol y dependencias, mapa clase/servicio desde DS, propuesta de módulos/CI, verificación de reproducibilidad MR-6 sin modificar SQL histórico; **primero modo plan, luego PR pequeña**.  
**Revisor IA independiente:** cotejar referencias CU/RD/RP, estados y pruebas citadas; no marcar implementado sin código y ejecución.  
**Responsable humano:** ratifica límites, priorización y cualquier decisión comercial, física o de autorización no aprobada.

**Regla de cierre:** B0 no produce por sí mismo un sistema funcional; habilita B1/I0 con decisiones rastreables.

## Ejecución documental del 29/10/2026 (adenda sin alterar el plan)

Se generaron el [inventario B0](b0/B0_INVENTARIO_FUENTES_2026-10-29.md), [matriz 64 CU/67 operaciones](b0/B0_MATRIZ_64_CU_67_OPERACIONES.csv), [manifiesto de Git SHA](b0/B0_MANIFIESTO_RUTAS_SHA.csv), [reconciliación RD/RP/MR](b0/B0_RECONCILIACION_RD_RP_PERMISOS_2026-10-29.md), [arquitectura candidata](../06-arquitectura/B0_ARQUITECTURA_CANDIDATA_2026-10-29.md) y [backlog/G0](b0/B0_BACKLOG_PRIORIZADO_Y_GATE_G0_2026-10-29.md).

**Resultado:** identificación de fuentes y cotejo automatizado de rutas alcanzado; G0 **no aprobado** por revisión semántica y RBAC exhaustivos pendientes, más integración y aprobación de PR encadenadas y ADR. Las fuentes DSS/DS/contrato están presentes en PR #10–#19, NO en `main`. No se modificaron originales ni SQL.

## Consolidación de decisiones y revisión de seguridad — 29/10/2026

- [Acta RD y RBAC 0 P](b0/RD_B0_CIERRE_RBAC_BC01_BC02_BC03_2026-10-29.md).
- [Matriz actualizada de 67 operaciones](b0/B0_MATRIZ_RBAC_67_OPERACIONES_CIERRE_2026-10-29.csv) (la versión anterior con `P` queda histórica).
- [Contratos REV04A y REV05 derivados](../08-diagramas/consolidacion-b0/) (no alteran propuestas REV originales).
- [Dictamen contractual y de seguridad residual](b0/B0_DICTAMEN_CIERRE_CONTRACTUAL_Y_SEGURIDAD_2026-10-29.md): BC-05 conciliado con propagación pendiente, BC-07 propuesto y sujeto a ratificación, BC-08 comprobado, BC-10 corregido en índice B0.

**G0 NO APROBADO** hasta aprobación de matriz de campos sensibles, mapeo de servicios/DB y ADR.

## Cierre documental adicional 29/10/2026 (sin adelantar B1)

- BC05: adenda ratificada, 21 observaciones RF integradas como anotación en 8 documentos derivados B0, sin tocar originales.
- BC07: las 15 proyecciones de datos y sus exclusiones quedan ratificadas en [RD_B0_BC07](b0/RD_B0_BC07_2026-10-29.md). No otorga roles/acciones nuevos.
- BC09: [regla de invocación interna/externa](b0/BC09_REGLA_INVOCACION_INTERNA_EXTERNA_2026-10-29.md) incorporada para agentes.
- BC06: [18 pruebas previstas, 0 ejecutadas](b0/BC06_INFORME_EJECUCION_Y_BLOQUEO_2026-10-29.md) por falta de aplicación; pruebas estáticas B0 separadas.

**G0 sigue NO APROBADO**, pendientes mapa servicio/transacción/persistencia, ADR, y aceptación/fusión de cadena de PR.
