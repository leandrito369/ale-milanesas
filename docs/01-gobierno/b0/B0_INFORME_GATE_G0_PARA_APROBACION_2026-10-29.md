# B0.7 — Informe de Gate G0: evaluación y decisiones pendientes

**Fecha:** 29/10/2026 · **Estado formal:** **G0 NO APROBADO.** Éste es el informe listo para revisión, no un acta de aprobación.

## Control contra el plan B0.1–B0.7

| Criterio | Evidencia disponible | Resultado |
|---|---|---|
| **B0.1** Inventario canónico | 64 CU, 67 contratos y rutas DSS/DS; manifiesto con SHA y diferencia `main`/ramas propuestas | **CUMPLIDO DOCUMENTALMENTE**; fuentes REV por integrar |
| **B0.2** Correspondencia y reglas | Matriz 67, revisión estructural 192 fichas, 21 RF adendados; 3 RD de RBAC y BC07 ratificados | **CUMPLIDO EN TRAZABILIDAD/CONTROL**; cotejo semántico gráfico detallado continúa por CU antes de codificar |
| **B0.3** Responsabilidades | Mapa E01-C de 67 operaciones, 7 módulos, RBAC 0 P, 60 tablas existentes referenciadas | **PROPUESTO, PENDIENTE REVISION DE DS Y RATIFICACION** |
| **B0.4** MR5/MR6 y brechas | 60/453/125, MR6 SQL CI real y F01; informe F04/S01 sin esquema de pago tránsito | **RECONCILIADO DOCUMENTALMENTE**, CR físico F04 diferida |
| **B0.5** Arquitectura | 6 ADR candidatas y estructura vertical; sin build ni API existentes | **PENDIENTE APROBACIÓN DE ADR** |
| **B0.6** Plan de incrementos | Orden I0–I7 e I1/I2 con acceptance tests y dependencias; paquete I0/I1 en backlog | **PREPARADO, REQUIERE VALIDACION** |
| **B0.7** Integración y acta | PR #20 (plan), #21 (inventario), #22 (RD/RBAC), #23 (BC05/BC07) y la PR de este trabajo; fuentes de diseño #10–#19 en propuestas no fusionadas | **PENDIENTE REVISION Y FIRMA** |

## Puntos que requieren aprobación del responsable

**G0-D01 — Autoridad de diseños:** ratificar qué versión de DSS/DS/contratos de la cadena PR #10–#19, más revisiones B0 de contratos y RD, será canónica para implementación; revisar/fusionar en orden sin mezclar históricos.

**G0-D02 — ADR de arranque:** aceptar o ajustar **ADR-B1-01/02/03/04/06**; la ADR-B1-05 (sincronización offline) **no** aprueba SQL y requiere CR posterior de B7. Si cambia una elección técnica, registrar la alternativa y motivo.

**G0-D03 — Alcance y dependencias:** aprobar backlog vertical I0/I1 con recorrido Pedido y criterios de aceptación verificables. Las 67 operaciones y todos los CU siguen en alcance académico; priorizar no equivale a recortar.

**G0-D04 — QA:** aceptar que los **18 casos de BC-06** se ejecutarán **cuando existan servicios reales** en B3/B4/B6, de acuerdo al plan rector. Sus fallos no se ocultan. Las 5 pruebas CI documentales pasan, pero no son tests funcionales.

**G0-D05 — Cotejo DS/contratos por operación:** aprobar la estrategia de inspección técnica antes de cada PR de implementación; una ruta y la verificación estática de firma no reemplazan inspección de mensajes, firmas, transacción y postcondiciones.

## Bloqueos y trabajos diferidos controlados

- **Bloqueante para declarar G0 aprobado:** decisiones G0-D01/D02/D03 y aceptación humana de la línea base, CI del nuevo mapa documental, coordinación de PR apiladas y origen de diseño con estado explícito.
- **No bloqueante para iniciar I0/I1 tras G0:** la ejecución de BC-06 de servicios no existentes, implementación de integraciones externas y la CR física F04/B7 (si los primeros incrementos no dependen de ella). **No** declararlos resueltos: registrarlos como riesgos y dependencias.
- **Obligatorio por CU antes de codificarlo:** cotejar sus DS con contratos, permisos, columnas/operaciones SQL, pre/post, invariantes y pruebas. Escalar discrepancias como RP/CR.

## Estado para defender metodológicamente

Las 64 fichas y los 67 contratos están documentados; su **arquitectura de aplicación** todavía es **propuesta**. El esquema PostgreSQL 17.11 tiene evidencia MR6 en laboratorio; la aplicación **no** ha sido programada. B0 prepara la **línea base de construcción**, no la aplicación construida.

**Dictamen:** material de G0 listo para decidir; **G0 NO APROBADO** hasta ratificación y revisión efectiva. No se realizará merge ni migración de producción por este informe.

## Ejecución real de CI documental E01-C (29/10/2026)

El [workflow B0 documental de GitHub Actions #40908456777](https://github.com/leandrito369/ale-milanesas/actions/runs/40908456777) terminó **SUCCESS**. El job `verificar-documentos` ejecutó `python -m unittest discover -s tests/b0 -p 'test_*.py' -v`: **9 tests ejecutados / 9 aprobados / 0 fallos**, según logs. Cuatro son específicos de mapeo (67 operaciones, 64 CU, 7 módulos, 60 tablas existentes, consistencia de RBAC y carácter candidato); cinco verifican RD/BC previos. **Es comprobación documental automatizada, no test de aplicación, transacción ni PostgreSQL nuevo**. BC-06 de implementación sigue **0/18**.

---

## Actualización posterior — Ratificación de ADR y separación de repositorios, 29/10/2026

**Éste es el estado vigente; las menciones históricas anteriores a ADR «pendientes» describen el estado previo.**

| Decisión G0 | Estado actualizado | Evidencia |
|---|---|---|
| **G0-D01** — fuentes canónicas | **PENDIENTE** | Revisión e integración de PR de DSS/DS/contratos y copias B0 con criterios de autoridad |
| **G0-D02** — ADR de arquitectura | **RESUELTA** | [RD arquitectura](RD_B0_ADR_ARQUITECTURA_APROBADA_2026-10-29.md): ADR-B1-01/02/03/04/06 ratificadas; B1-05 requiere CR |
| **G0-D03** — aceptación backlog/prioridad | **PENDIENTE** | Backlog I0/I1/primer vertical propuesto; no equivale a ratificación expresa |
| **G0-D04** — estrategia de QA futuro | **PENDIENTE DE ACEPTACIÓN EN G0** | 18 escenarios BC06 no ejecutados; 9 tests documentales sí pasaron en CI |
| **G0-D05** — revisión detallada DS/contrato previa a cada PR | **PENDIENTE DE ACEPTACIÓN EN G0** | Método propuesto y mapa E01-C; no confundir con cotejo íntegro ya ejecutado |

**Nuevo bloqueo independiente de G0:** el responsable indicó que dará de alta el **nuevo repositorio de implementación**. Ver [RD-B0-REPOS-01](RD_B0_SEPARACION_REPOSITORIOS_2026-10-29.md) y [handoff](../../06-arquitectura/HANDOFF_REPOSITORIO_IMPLEMENTACION_PENDIENTE_2026-10-29.md). **No crear repo ni escribir código en el repositorio documental; B1 solo después de G0 aprobado y de URL/alta confirmada por el responsable.**

**CR-B0-F04-001** está **abierta y no aprobada** para diseño físico de F04/S-01, sin bloquear G0 en las partes iniciales ajenas a F04 ni autorizar nuevas tablas.

**Estado formal final de este informe: G0 NO APROBADO** hasta resolver G0-D01/D03/D04/D05, revisar PR, y obtener acta formal de aceptación. La ratificación de cinco ADR no aprueba por sí sola las demás condiciones.
