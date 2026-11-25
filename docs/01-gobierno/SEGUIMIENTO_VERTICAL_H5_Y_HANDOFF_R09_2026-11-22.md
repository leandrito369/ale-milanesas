# Seguimiento vertical H5 y handoff R09 — corte 25/11/2026

**PROPUESTO / PR #77 DRAFT.** Actualización incremental del seguimiento del 22/11; no modifica Plan Rector, G0, RD, contratos, RBAC ni aplicación. No autoriza merge, decisiones comerciales ni despliegue.

## 1. Preflight e inventario de fuentes

- Gobierno: `main@2c74174af7850df5c7cd76f7158c0d729a889122`; [PR #77](https://github.com/leandrito369/ale-milanesas/pull/77), rama `docs/seguimiento-h5-handoff-r09-2026-11-22`, HEAD inicial `951f76d6bac959cb0962126b4c3534c0ce0c85a6`, OPEN/DRAFT. Un único archivo modificado; no se duplica PR.
- Aplicación, exclusivamente lectura: `main@7fb48a32e95b381dcaaac15b1005602bbda19292` (**M** en las matrices). Ambas referencias y estados/SHAs de §2 contrastados directamente en GitHub el 25/11. Código consultado en snapshot de M y diff del HEAD #107, fuera del árbol de trabajo de aplicación; sin datos reales.
- Método: `AGENTS.md`, estado/contexto, [protocolo](PROTOCOLO_CAMBIOS_Y_CHATS.md), preflight → contraste acotado → plan de diff/matriz → edición → checks → commit incremental. Plan previo: sustituir fotografía obsoleta y enlazar implementación, pruebas, aceptación y bloqueos sin crear reglas.
- Planificación: [Plan Rector 29/10](PLAN_RECTOR_IMPLEMENTACION_2026-10-29.md) §§4,6–8 y [Roadmap 15/11](ROADMAP_OPERATIVO_I3_I7_2026-11-15.md) §§3,5–9. Este seguimiento actualiza hechos; no reescribe los originales.
- Autoridad: [manifiesto G0](b0/G0_MANIFIESTO_CANONICO_67_OPERACIONES_2026-10-29.csv), source `1263ffc17bd0eb7f3c69faaa9ff5ae556cf9de7e` (CU/DSS/DS/contrato por operación), [RBAC](b0/B0_MATRIZ_RBAC_67_OPERACIONES_CIERRE_2026-10-29.csv) y [BC-07](b0/BC07_PROYECCIONES_MINIMAS_RATIFICADAS_2026-10-29.csv).
- Contratos: [REV04A](../08-diagramas/consolidacion-b0/CONTRATOS_REV04A_CORREGIDOS_B0_ACTUALIZADO.md), [REV04B](../08-diagramas/consolidacion-b0/CONTRATOS_REV04B_CORREGIDOS_B0_ACTUALIZADO.md), [REV05](../08-diagramas/consolidacion-b0/CONTRATOS_REV05_CORREGIDOS_B0_ACTUALIZADO.md), [RCG-01..08](ACTA_G_COM_001_RATIFICADA_CON_SALVEDADES_2026-11-16.md), [E-01..03](g-con/ADENDA_REV04B_E01_E02_E03_2026-11-16.md), [E-04..06](g-con/ADENDA_REV05_E04_E05_E06_2026-11-16.md), [RD-GFIS-AB-001](resoluciones/RD_GFIS_AB_001_RATIFICACION_FRONTERAS_AB_Y_B1R1_2026-11-21.md). RD/adendas ratificadas precisan redacciones históricas; su estado editorial histórico no sustituye la fotografía GitHub actual.
- Evidencia técnica: PR/checks §2, [código en M](https://github.com/leandrito369/ale-milanesas-app/tree/7fb48a32e95b381dcaaac15b1005602bbda19292/src), [tests en M](https://github.com/leandrito369/ale-milanesas-app/tree/7fb48a32e95b381dcaaac15b1005602bbda19292/src/test/java/ar/edu/unam/alemilanesas), README y V1–V4 de ese snapshot. Los nombres de clases de §3 identifican archivos dentro de esos árboles.

**Estados separados:** PROPUESTO = sujeto a decisión; RATIFICADO = regla aprobada expresamente; IMPLEMENTADO = código existente; PROBADO = ejecución acreditada por SHA; INTEGRADO = presente en main; ACEPTADO = acta humana expresa. DESPLEGADO requiere infraestructura autorizada. CI verde no acredita aceptación, despliegue ni todo el CU.

## 2. Integraciones verificadas

B1/B2 enlazan ejecuciones del HEAD de cada fila, no del merge ni de otro SHA. `S` = check **SonarCloud Code Analysis SUCCESS** observado en ese HEAD. No se atribuye evidencia postmerge por inferencia.

| PR app / alcance | Estado efectivo | HEAD verificado | Merge commit real | CI del HEAD |
|---|---|---|---|---|
| [#102](https://github.com/leandrito369/ale-milanesas-app/pull/102) V4 G-FIS | MERGED 22/11 | `716eff313c9fa39dc98ad9fe175341e90fbab09f` | `87496f6dd224b40070f4b285f60438aea232e3a0` | [B1 PASS](https://github.com/leandrito369/ale-milanesas-app/actions/runs/45027655801), [B2 PASS](https://github.com/leandrito369/ale-milanesas-app/actions/runs/45027655744), S |
| [#104](https://github.com/leandrito369/ale-milanesas-app/pull/104) R09.1a | MERGED 22/11 | `d892228369c857add9f71c404e9104d58f0e871c` | `d0e53fb462700b1a659248752a1e4d7dc99ba31d` | [B1 PASS](https://github.com/leandrito369/ale-milanesas-app/actions/runs/45035678337), [B2 PASS](https://github.com/leandrito369/ale-milanesas-app/actions/runs/45035678343), S |
| [#103](https://github.com/leandrito369/ale-milanesas-app/pull/103) UI UC-28 | MERGED 22/11 | `22adf9af4daeacc8ac90df1c107b024eeb2ed09e` | `f1a7916129602c724b326c372ee08973b0a01558` | [B1 PASS](https://github.com/leandrito369/ale-milanesas-app/actions/runs/45043899633), [B2 PASS](https://github.com/leandrito369/ale-milanesas-app/actions/runs/45043899621), S; 6/6 checks SUCCESS |
| [#105](https://github.com/leandrito369/ale-milanesas-app/pull/105) R09.3a UC-14 | MERGED 22/11 | `d0cdf3bcaaa725469c0386a4582c3f2865cc5519` | `4a1a5e32f727d3322ab9f6e0a81e337e3a3536c4` | [B1 PASS](https://github.com/leandrito369/ale-milanesas-app/actions/runs/45046210283), [B2 PASS](https://github.com/leandrito369/ale-milanesas-app/actions/runs/45046210250), S |
| [#106](https://github.com/leandrito369/ale-milanesas-app/pull/106) originales/PE-1/IMP-B | MERGED 23/11 | `874a5ef1da5f744c1260232c78fa2705af2f407b` | `7fb48a32e95b381dcaaac15b1005602bbda19292` | [B1 PASS](https://github.com/leandrito369/ale-milanesas-app/actions/runs/45066475898), [B2 PASS](https://github.com/leandrito369/ale-milanesas-app/actions/runs/45066475728), S; 23/23 checks SUCCESS, incluidos 20 HTTP |
| [#107](https://github.com/leandrito369/ale-milanesas-app/pull/107) R09.3b-A | OPEN/DRAFT; NO INTEGRADO | `46653da9ed3fb629599c65163d44da27b016b99b` | **No existe merge** | [B1](https://github.com/leandrito369/ale-milanesas-app/actions/runs/45648324334) y [B2](https://github.com/leandrito369/ale-milanesas-app/actions/runs/45648324326) EN CURSO al verificar; S del nuevo HEAD SUCCESS |

| Incremento | Alcance y reservas |
|---|---|
| #102 | V4 integrado y probado en laboratorio; no acredita cutover de destino, servicios finales ni aceptación. V1–V4 intactas en este encargo. |
| #104 | `ProtocoloIdentificadoresFinancieros`, secuencias y locks; adaptación Cobro manual/Caja. No equivale a todo R09.1; reseed de destino y retiro del puente A1 requieren tratamiento autorizado separado. |
| #103 | `PrepararPedidoDemoController` y plantilla conectados a `RegistrarPreparacionService`; interfaz de laboratorio, no aceptación H5. |
| #105 | Servicio UC-14: confirmado, tránsito PE-1 vigente y exigible provisional; fechas filtran historial sin cambiar saldos actuales. **Sin API/UI UC-14**; fixtures de estados rendidos no implementan PE-2. |
| #106 | **H1** Recorrido HTTP; **H2** reservas/aplicaciones separadas del FIFO libre en UC-15; **H3** cierre terminal sin PE-2 bloqueado. [Evidencia correctiva final](https://github.com/leandrito369/ale-milanesas-app/pull/106#issuecomment-7085425697). H3 correctivo ≠ hito académico H3. Entrega original-only crea cargo, nunca Cobro/Caja; UI Entrega pendiente. |
| #107 | ADMIN registra revisión inicial y custodia/diferencia en `PENDIENTE_CONCILIACION`, cero efectos financieros definitivos. Sin HTTP/UI, T1-C2 ni rectificaciones. Rechaza inicial 0/0, FA-2 y cobertura no acreditada. |

**Huella #107:** el [comentario 7166874102](https://github.com/leandrito369/ale-milanesas-app/pull/107#issuecomment-7166874102) detectó serialización ambigua en `189dff3decce425213112dd3ac2fb4a1909f97b9`. El [commit 46653da](https://github.com/leandrito369/ale-milanesas-app/commit/46653da9ed3fb629599c65163d44da27b016b99b) usa longitud UTF-8 prefijada de 4 bytes, conserva normalización/orden y versión `v1` premerge, y agrega `huellaCanonicaInequivocaRechazaAmbiguedadPorDelimitadoresYPreservaReplay`. Diff verificado: payloads ambiguos anteriores, conflicto, cero escrituras extra y replay original. **Corrección IMPLEMENTADA; ejecución del nuevo HEAD pendiente de CI**, sin heredar 828/828 ni Sonar del anterior. No se declara levantada la reserva de merge ni aceptada #107.

**Roadmap:** I1/I2/I3-01 mantienen cierre técnico según Roadmap; UC-22/23 integrados previamente. R08.6 integrado; R09.1a y R09.1b/PE-1/IMP-B integrados; R09.2 limitado a originales; R09.3a integrado como servicio; R09.3b-A propuesto en código; B/C pendientes. **H5 PENDIENTE** por T1-C2, interfaces y aceptación. B9 pausado. Sin porcentaje global.

## 3. Matriz H5 original-only: trazabilidad técnica

`H5-01..08` son filas locales, no nuevos requisitos ni CU. Requisito = cláusula canónica citada. PR/SHA abreviados remiten a §2; **M** acredita presencia/regresión actual, no autoría histórica. Todas las filas carecen aquí de aceptación humana acreditada.

| ID / etapa, CU y requisito | Actor | Servicio / API / interfaz | Persistencia y efectos | PR/SHA y pruebas automatizadas | Resultado y dependencia |
|---|---|---|---|---|---|
| H5-01 Pedido; UC-03, REV04A cargarPedido, snapshot | VENDEDOR | `CargarPedidoService`; POST `/api/v1/pedidos`; web `/web/demo/pedidos/nuevo` | `PEDIDO`, `DETALLE_PEDIDO`, precio histórico; evaluación Cliente | M / regresión #106; `CargarPedidoServiceIntegrationTest`, `CargarPedidoHttpExternoTest`, `DemoPedidoHttpIntegrationTest` | INTEGRADO/PROBADO; aceptación vertical pendiente |
| H5-02 Recorrido/asignación; UC-43, RD A1/FA-1/FA-2 | VENDEDOR | `AsignarRepartoService`, `GestionarRecorridoRepartoService`; POST `/api/v1/recorridos`, `/{id}/asignaciones`, `/{id}/vinculaciones`; UC-43 clásico conservado. UI asignación clásica existente, conexión al Recorrido explícito pendiente | `ASIGNACION_REPARTO`, `RECORRIDO_REPARTO`, `RECORRIDO_ASIGNACION`; pertenencia activa auditable | #106/874a5ef; `RecorridoEntregaCircuitoHttpExternoTest`, `AsignarRepartoServiceIntegrationTest` | INTEGRADO/PROBADO API; UI Recorrido pendiente; cierre sin PE-2 bloqueado |
| H5-03 Preparación; UC-28, REV04B, límite original/costo | RESPONSABLE_PRODUCCION | `RegistrarPreparacionService`; POST `/api/v1/pedidos/{id}/preparaciones`; GET/POST `/web/demo/pedidos/{id}/preparar` | `PREPARACION`, `MOVIMIENTO_INSUMO`, `DETALLE_MOVIMIENTO_PARTIDA`, partidas/stock y costo histórico | #103/22adf9a + M; `RegistrarPreparacionServiceIntegrationTest`, `RegistrarPreparacionConcurrenciaIntegrationTest`, `PrepararPedidoDemoIntegrationTest`, `PrepararPedidoDemoMvcTest` | INTEGRADO/PROBADO; aceptación humana pendiente |
| H5-04 Entrega; UC-05, REV04B/E-01/E-02, RCG-02 | REPARTIDOR asignado | `RegistrarEntregaService`, `ImputacionFinancieraService`; POST `/api/v1/pedidos/{id}/entrega`; “Mis entregas” ilustrativa | `ENTREGA`, `DETALLE_ENTREGA`, stock/excedente, cargo `MOVIMIENTO_CUENTA`, `EVENTO_IMPUTACION_FINANCIERA`, `RECONOCIMIENTO_ENTREGA_PE1`, `RECORRIDO_ENTREGA`; cero Cobro/Caja | #106/874a5ef; `RegistrarEntregaServiceIntegrationTest`, `RegistrarEntregaHttpExternoTest`, `Uc05ConcurrenciaIntegrationTest`, `EvaluadorCategoriaImpBIntegrationTest` | INTEGRADO/PROBADO original-only; UI pendiente; rechazo atómico de adicionales aceptados no soportados |
| H5-05 Cuenta; UC-14, REV05 §1/E-06 | Solo VENDEDOR | `ConsultarCuentaCorrienteService`; API/UI ausentes | Lectura `CLIENTE`, `MOVIMIENTO_CUENTA`, PE-1 vigente; sin escrituras; tres magnitudes separadas | #105/d0cdf3b; `ConsultarCuentaCorrienteServiceIntegrationTest` | INTEGRADO/PROBADO servicio; conectar API/UI y probar transición con PE-2 final |
| H5-06 Rendición preliminar; subflujo UC-29, E-04/RD B1 | Solo ADMINISTRADOR | `RendicionPreliminarPe2Service`; consulta contextual propia, no UC-14; sin API/UI | `CIERRE_RECORRIDO_PE2`, `REVISION_CONCILIACION_PE2`, `PROPUESTA_APLICACION_PENDIENTE`, `CUSTODIA_DIFERENCIA_RENDICION`; Recorrido pendiente, importe confirmado 0, Vvig intacto | #107/46653da; `RendicionPreliminarPe2ServiceIntegrationTest`, nuevo caso huella; CI pendiente | IMPLEMENTADO no integrado; revisión/CI/autorización #107 y conexión pendientes |
| H5-07 Confirmación → Cobro/Caja; UC-29 PE-2, T1-C2/K2, RD B1-R1 | Solo ADMINISTRADOR | Servicio confirmatorio/API/UI finales pendientes; no sustituir por cierre UC-43 o Cobro manual | Efectos contractuales futuros: `COBRO`, `COBRO_RENDICION_K2`, `APLICACION_RENDICION_K2`, PAGO/Caja, IMP-B, extinción exacta Vvig, recibo y Recorrido CERRADO en un COMMIT | V4 #102 prueba soporte físico; **no acredita servicio R09.3b-B** ni E2E final | PENDIENTE; bloqueo crítico H5: implementar/probar/integrar T1-C2 |
| H5-08 Cobro manual/Caja; UC-29 general, UC-22/23, REV05/E-04/E-05 | Manual ADMIN/VENDEDOR; anulación y UC-22/23 ADMIN | `CobroManualService` interno sin API/UI propia; `RegistrarMovimientoCajaService`, `ConsultarLibroDiarioService` con HTTP; no sustituyen rendición | `COBRO`, `MOVIMIENTO_CUENTA`, `MOVIMIENTO_CAJA`, contraasientos; no duplicar anticipo/rendición | M + #104/d892228; `CobroManualServiceIntegrationTest`, `R091aGeneradoresYLocksIntegrationTest`, `RegistrarMovimientoCajaHttpExternoTest`, `ConsultarLibroDiarioHttpExternoTest` | PARCIAL/INTEGRADO según capa; canal manual pendiente; observar finanzas H5 exige T1-C2 |

Recorrido/Entrega experimentales conservan triple gate (`!prod`, flags false, veto en arranque prod). API existente no equivale a habilitación operativa; no se activan flags aquí.

## 4. Matriz de aceptación humana y negativos

**Todos los escenarios: PENDIENTE de aceptación humana.** Suites §3 = evidencia automática, no actas. Ejecutar con datos sintéticos y registrar SHA, entorno, actor, entradas, antes/después, evidencia visible y firma/fecha. Sin canal funcional: bloqueado, nunca PASS por fixture SQL.

| Escenario / filas | Positivo y negativo exigidos por fuentes | Evidencia disponible / bloqueo |
|---|---|---|
| A01 / 01–03 | Vendedor carga originales, asigna/reasigna; Producción prepara. Snapshot, una asignación vigente y costo/consumo verificables. Repartidor anterior no entrega; stock insuficiente rechaza sin consumo parcial | Suites Pedido/Asignación/Preparación y circuito HTTP #106; conectar UI Recorrido y ejecutar por roles |
| A02 / 02–04 | Sesión y pertenencia vigente; rechazar sesión revocada, rol incorrecto y sesión válida de otro Repartidor. Reasignación concurrente no permite entrega fuera de ámbito | `RecorridoEntregaCircuitoHttpExternoTest`, `Uc05ConcurrenciaIntegrationTest`; aceptación UI pendiente |
| A03 / 04 | Entrega total/parcial original con valoración histórica; mismo comando/clave devuelve resultado sin doble cargo/stock/PE-1. Clave/payload conflictivos y fallo precommit no dejan efectos parciales | Suites Entrega/concurrencia #106; UI pendiente; observar reintento y persistencia |
| A04 / 04 | Adicional aceptado no soportado o línea técnica rechaza toda Entrega. Oferta solo pendiente no autoriza adicionales ni recotización | Guardia `SOLO_ORIGINALES` y suite Entrega; no habilita UC-07 ni falso original de cantidad cero |
| A05 / 04–05 | Cargo 100, declaración 100, PE-1 válido 75: confirmado 100, tránsito 75, exigible 25. Sin reconocimiento: tránsito 0. Tras rendir 50: confirmado 50, tránsito 25, exigible 25; no doble descuento | UC-14 cubre estados por fixtures; transición real rendida bloqueada por B. Probar varias entregas, saldo a favor y fechas que solo filtran historial |
| A06 / 04–05,08 | Anticipo reservado a B no cancela deuda vencida A por FIFO; consolidación/liberación sin nuevo PAGO/Caja. ADMIN/REPARTIDOR no acceden UC-14; ADMIN solo ve contexto UC-29 | `EvaluadorCategoriaImpBIntegrationTest` y UC-14; conexión financiera/UI pendiente |
| A07 / 06 | ADMIN registra diferencia positiva: pendiente/custodia, cero Cobro/PAGO/Caja/extinción Vvig. Rechazar FA-2, sobrecobertura, inicial 0/0 y roles ajenos; replay sin segunda revisión | #107 no integrado; huella, rollback y concurrencia requieren CI/revisión del nuevo SHA |
| A08 / 06 | Misma clave con motivo `a\|b`/ubicación `c` frente a `a`/`b\|c`: `CLAVE_IDEMPOTENCIA_CONFLICTO_PAYLOAD`; replay original conserva recibo/contadores | Nuevo test #107; Sonar histórico no acredita esta corrección |
| A09 / 07 | T1-C2: máximo un Cobro REPARTO/EFECTIVO por Cliente/cierre; `A_e + V_e^vig = V_e^0`, recibo inmutable y cierre atómico. Doble confirmación, clave conflictiva y rollback sin duplicados | **PENDIENTE/BLOQUEADO R09.3b-B**; laboratorio V4 no acepta servicio; cotejar Cuenta/Caja antes/después |
| A10 / 02,06–07 | Vendedor intenta cerrar tras PE-1: 409 `RENDICION_PE2_PENDIENTE`, Recorrido ABIERTO y tránsito intacto. Vacío/desvinculado: `CIERRE_SIN_PE2_NO_AUTORIZADO` | H3 correctivo #106 probado; decisión vacío/cero aplicaciones pendiente; FA-1 puede impedir otro Recorrido |
| A11 / 06–07 | Rectificación append-only a cero exige sucesora y T1-C2; invalidación mantiene pendiente, sin reapertura ni confirmación hasta sucesora válida | **PENDIENTE R09.3b-C**; B1-R1/B1-R2 ratificados, no volver a votar; falta servicio final |

## 5. Decisiones y reservas

| Pendiente / dueño | Impacto y condición de salida |
|---|---|
| Vacíos/desvinculados y cero aplicaciones — responsable comercial/contractual | Falta autorización inequívoca del cierre excepcional; mantener fail-closed #106. Puede bloquear repetición por FA-1. Decidir contrato y probar antes de ofrecerlo; demo con entregas/aplicaciones no resuelve esta excepción. |
| R09.3b-B — encargo técnico autorizado y revisión/merge humano | T1-C2/K2 imprescindible para H5 financiero: transacción final, recibo, locks, replay y rollback sobre V4; no usar Cobro manual de atajo. |
| R09.3b-C — implementación/revisión | B1-R1/B1-R2 ratificados; faltan rectificación/invalidación y carreras con confirmación. Si se difieren en demo reducida, exclusión expresa; no declarar UC-29/conciliación completos. |
| UC-07 / DH-01..07 — responsable antes de R09.4 | [#75](https://github.com/leandrito369/ale-milanesas/pull/75) OPEN/DRAFT `82e59f8e030c7d80dbf2689d95506f8f6fbc58d9`. Pendientes: 01 variante física; 02 F8; 03 redondeo cero; 04 Producto desactivado; 05 ámbito Vendedor; 06 evidencia/retención; 07 redlines/secuencia. Fuera H5 original-only; no reabrir P1-A ni cerrar H por laboratorio. |
| Calidad — seguimiento técnico [Issue app #35](https://github.com/leandrito369/ale-milanesas-app/issues/35) | GitHub **CLOSED**, no OPEN. [Cierre](https://github.com/leandrito369/ale-milanesas-app/issues/35#issuecomment-6693815614) refiere duplicación tras #63, no concordancia de cobertura. SonarCloud/JaCoCo **no conciliados por esta evidencia**: comparar mismo SHA/alcance e ingestión XML; sin porcentajes inventados ni reapertura de issue. |
| Procedencia G-ARQ — responsable documental | **S10 = NO ACREDITADO**, según RD-GFIS; V4/CI no lo corrigen. |
| Despliegue — responsable y operador por designar | [Issue app #28](https://github.com/leandrito369/ale-milanesas-app/issues/28) **OPEN**, B9 en pausa expresa. Reanudación humana, host/FQDN/TLS, proxy/firewall/singleton, respaldo/restauración y aceptación UC-54 requieren acreditación en destino. |

## 6. Camino crítico hasta el 12/12/2026

Plan **PROPUESTO**: fechas objetivo, no garantía ni autorización. Responsable aprueba; ejecución técnica mediante encargos acotados de aplicación. Este encargo no interviene otras PR.

| Ventana | Trabajo / dependencia | Terminado verificable / decisión |
|---|---|---|
| 25–28/11 | Verificar fix/CI #107; revisar A; preparar B sobre #102/#104/#106. Conectar Recorrido/Entrega y UC-14 en paralelo | #107 integrado solo si autorizado; matriz de efectos/pruebas T1-C2. Decisión humana de cierre vacío/cero aplicaciones, sin excepción improvisada |
| 29/11–05/12 | Implementar/probar/integrar T1-C2; canales UC-14/29 y observación Caja; C sobre cabecera/revisiones de A y confirmación B | CI por HEAD, RBAC, idempotencia, carreras/rollback, sin pago doble; interfaz con tres magnitudes. Merge autorizado por incremento |
| 06–09/12 | Congelar candidato; ensayo H5-01..08 y A01..A11 según alcance aprobado | SHA fijo, datos sintéticos, evidencia por rol; acta humana de aceptación o fallos. Corregir y repetir pruebas afectadas |
| 10–12/12 | Regresión, manual/guion, paquete reproducible y defensa | Demo 12/12 con evidencia y exclusiones. Si faltan T1-C2 o interfaces: avance parcial, **no H5 aceptado** |

**Imprescindible:** Pedido/Recorrido/Preparación/Entrega originales, Cuenta con tres magnitudes, rendición definitiva/Cobro/Caja sin duplicados, interfaces, pruebas y aceptación humana. Camino crítico: #107 revisada → B → integración financiera/API/UI → ensayo → aceptación. C condiciona aceptar variantes de discrepancia/rectificación; omisión expresa, nunca silenciosa.

**Diferible en este corte:** UC-07/DH, adicionales/P1/F8/H, offline e integraciones externas no necesarias para el circuito. No implica cerrar 64 CU, I3-02 ni H3/H7 globales. Una reducción académica requiere acuerdo humano; no se presupone aceptada.

**B9 separado:** demo reproducible de laboratorio no certifica despliegue. Entorno externo requiere levantar pausa #28 y validar destino; no se alteran flags ni infraestructura aquí.

## 7. Validación y dictamen

- Checks ejecutados: `git diff --check` sin errores; `python -m unittest discover -s tests/b0 -p 'test_*.py'`: **21/21 OK**; enlaces relativos y clases citadas existentes; **28 enlaces GitHub verificados** mediante API (PR/commit/run/comentario/árbol/issue), incluidos HEAD de los 12 runs B1/B2. Tras push: `gh pr view 77 --json state,isDraft,headRefOid`. Solo este Markdown debe aparecer en `git diff --name-only 951f76d`.
- Evidencia externa: estados/SHAs/checks consultados directamente; nuevo HEAD #107 separado de 189dff3. Contadores 819/819 y JaCoCo #106 constan en el comentario correctivo enlazado; descarga de logs completos falló con 403, por lo que no se recalcularon contadores/cobertura. No se ejecuta Java/PostgreSQL ni aceptación humana en este encargo.
- **GO documental** para revisar seguimiento y usar matriz como handoff R09.3/H5. Conexiones sobre servicios integrados y cortes financieros autorizados pueden avanzar sin esperar DH de UC-07.
- **NO-GO** para H5 ACEPTADO, UC-29 completo, cierre H/UC-07, S10 acreditado o despliegue. #107 necesita CI/revisión del nuevo SHA antes de solicitar merge; T1-C2/interfaces siguen en camino crítico.
- PR #77 permanece **DRAFT**, sin merge. Decisiones humanas, estados de issues y aplicación fuera del diff.
