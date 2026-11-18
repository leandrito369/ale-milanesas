# R08.6 — Puerta 1: conciliación contractual y técnica UC-05 / UC-07 / UC-29

**Fecha:** 18/11/2026 (Argentina)  
**Estado:** PROPUESTA DOCUMENTAL EN REVISIÓN — NO RATIFICA DECISIONES NUEVAS — NO HABILITA G-FIS/G-DEV.  
**Autorización del responsable:** mensaje del 18/11/2026 que autoriza exclusivamente análisis, documentación y propuestas mediante PR DRAFT independientes; expresamente excluye merge, código, DDL, Flyway V4, Demo, infraestructura, despliegue y cambios G0. No se interpreta esta autorización como aprobación editorial del presente documento.  
**Repositorio de gobierno examinado:** leandrito369/ale-milanesas/main @ 9076570ff3329864fe85c990bcc6f4ff7a63d6e5.  
**Repositorio de implementación examinado (solo lectura):** leandrito369/ale-milanesas-app/main @ f5c9af3f76723d5364d44647cfd43ea13a9fd7b5.  
**Source-lock inmutable:** source_commit 1263ffc17bd0eb7f3c69faaa9ff5ae556cf9de7e; governance_commit 27738b089afdd2698cdae915f75c0e8089a6248a.

## 1. Alcance, método y autoridad

El trabajo es un cotejo estático entre documentos vigentes, PR DRAFT y servicios/DDL publicados en main. NO se ejecutaron PostgreSQL, Testcontainers, CI, E2E ni operaciones de negocio para este expediente. No implica aprobación de contratos nuevos, CR-C/CR-F UC-07, firmas, modelo físico, autorización de migración o aceptación de UC-05.

**Jerarquía aplicada:** G0 y RD posteriores ratificadas; ACT-G-COM-001 (PR #64 integrada al SHA 9076570) para reglas comerciales RCG-01..08; la declaración contractual parcial G-CON R08.6 reproducida en PR #66, distinguiendo su existencia en el chat de su incorporación editorial; REV04B/REV05/REV06B para contratos heredados; R08.4 (PR #53), R08.5 (PR #54) y las PR #47/#48 como propuestas técnicas pendientes. En conflicto, NO corregir fuente canónica silenciosamente: tramitar adenda/CR independiente.

**Fuentes exactas examinadas:**
- Gobierno: AGENTS.md, docs/ESTADO_ACTUAL.md, docs/00-contexto/CONTEXTO_MAESTRO_2026-10-25_v1.0.md, docs/01-gobierno/PROTOCOLO_CAMBIOS_Y_CHATS.md.
- docs/01-gobierno/ACTA_G_COM_001_RATIFICADA_CON_SALVEDADES_2026-11-16.md (§§1–3); docs/01-gobierno/b0/CR_B0_F04_001_DISENO_FISICO_SINCRONIZACION_PENDIENTE_2026-10-29.md.
- docs/08-diagramas/consolidacion-b0/CONTRATOS_REV04B_CORREGIDOS_B0_ACTUALIZADO.md (§§2,5,6); docs/08-diagramas/consolidacion-b0/CONTRATOS_REV05_CORREGIDOS_B0_ACTUALIZADO.md (§§2–3).
- docs/08-diagramas/revision/REV06B_CLIENTES_RECETAS_INVENTARIO/propuestos/CONTRATOS_REV06B_TRECE_CORREGIDOS.md (§§6–7, sujeto a precedencia G0).
- PRs gobierno #47 (CR-C), #48 (CR-F), #53 (R08.4), #54 (R08.5), #55–#63 (RD funcionales), #65 (G-CON E-01..10), #66 (resolución parcial), #67 (PRE-05), todas OPEN/DRAFT al cotejo. Las PR NO son automáticamente autoridad canónica por existir.
- App: docs/traceability/source-lock.md; CobroManualService.java, EvaluadorCategoriaComercialInterno.java y CargarPedidoService.java; src/main/resources/db/migration/V1__baseline_mr5.sql; esquema V1–V3 (V3 amplía a 62 tablas, no incorpora PE-1/PE-2/IMP-01).

No se utilizaron datos, contraseñas o instancias de la Demo. La PR #65 no forma parte del diff presente; mantener sus siete adendas intactas.

## 2. Matriz única de autoridad: evitar revotos y falsos cierres

| Identificador | Estado de autoridad | Regla/invariante comercial vigente o frontera | Propagación pendiente |
|---|---|---|---|
| D5-B; ANT-01; D6-1; D7-A | Aprobadas funcionalmente; reconocidas en ACT-G-COM-001 §1 | Declaración efectiva solo de esa Entrega; anticipo confirmado/aplicado; rendición ADMIN; anulación de Cobro de rendición bloqueada temporalmente | E-01/E-02/E-04/E-05 |
| DC05-01/02/03/04/05/06/07-A; DC05-09-A; D12-C | Ratificadas en decisiones referidas por ACT-G-COM-001 §1 | Reservas por Pedido; autorización segregada; imputación explícita primero; FIFO sobre crédito libre; liberaciones y guardas; IMP-B canónico, IMP-A derivada, IMP-C contingencia; online PE-1+PE-2+IMP-01 prioritario | Diseño físico y RBAC contextual aún no publicados como nuevos permisos |
| DC-01-C1 / DC-02-A / DC-04-A | Aprobadas, reconocidas por ACT-G-COM-001 §1 | Cargo real sobre cantidades efectivamente entregadas; tipo/% históricos; redondear base agregada y ajuste, cada uno HALF_UP(2) en tramo original | Pruebas de cálculo y snapshots |
| DC-COM-FIFO-001 + RCG-01 | ACT-G-COM-001 RATIFICADA con salvedades | Porción de reserva consolidada <= C_e, más antigua primero; remanente liberado en misma transacción, filtro por estado/importe de reembolso; créditos libres FIFO pueden cubrir otras deudas | Garantías IMP-B, no doble uso, condiciones de reembolso |
| RCG-02 | RATIFICADA con salvedades | Adicional UC-07 por oferta y versión; dos ofertas de 15,05 con 10% descuento => 27,08; parcial después de aceptar no pide nueva conformidad; prohibidas líneas técnicas DETALLE_PEDIDO(cantidadOriginal=0) y cambios V1/trigger | CR-F #48 §15.12 contradice esta prohibición |
| RCG-03 | RATIFICADA con salvedades | K_e = P_e^exp + F_e^FIFO disjuntos; E_e=max(0,C_e-K_e); V_e^0=min(D_e,E_e). FIFO es imputación vinculante persistida en IMP-B; D_e íntegro; diferencias Q tipadas no sumables | PE-1/IMP-B y pruebas de atomicidad, casos cero y concurrencia |
| RCG-04 | RATIFICADA con salvedades | Cobro de rendición origen REPARTO, Admin, FK/alcance verificable; arqueo en tres vistas; custodia separada; D9 ADMIN contextual sin habilitar UC-14 | PE-2, BC07 adenda E-10, ecuación de arqueo |
| RCG-05 | RATIFICADA con salvedades | Huella semántica completa e idempotencia por ámbito; replay histórico sin doble efecto; nueva clave/payload distinto 409; anulación con clave propia y contraasientos | E-05, corrección futura de servicios, C-04 |
| RCG-06 | RATIFICADA con salvedades | COBRO.idPedido informativo, sin inferir P_e/backfill; preflight cinco señales por base destino; reserva ONLINE UC-21 recuperable | Preflight futuro G-FIS, PE-1/IMP-B, E-09 |
| RCG-07 | RATIFICADA con salvedades | Antes de activar V_e, UC-03 debe evaluar saldoExigibleProvisional auditado, sin umbral de deuda ni nuevo veto 409; tránsito no recategoriza | E-09 y futura integración; NO introducir corte por mora |
| RCG-08 | RATIFICADA con salvedades | Autoriza preparar lote editorial E-01..10 en PR revisable, sin auto-merge ni G-FIS/G-DEV | PR #65 DRAFT, aprobación editorial GC-10 separada |
| ART-GCON-A/A1, B/B1, C1/C1-a, D/D1 | Declaración contractual aprobatoria recogida en PR #66 (NO integrada) | Evidencia diagnóstica post-rollback, 422 COBERTURA_NO_ACREDITADA, idempotencia de cierre, evolución de firma de anulación | Archivo fuente/respaldo y revisión editorial #66 independiente |
| ART-GCON-C2 | NO VOTADA / DIFERIDA | T1/T2, cardinalidad Cobro–Aplicación, protocolos COMMIT por etapa | Decisión futura expresa o análisis G-ARQ Nivel 2, sin inferir |
| UC-07 CR-C A/B/C | Ratificadas parcialmente en PR #47/#48 | Oferta + cotización V1 atómicas; UUID de entidades y FK compuesta; intento entero por oferta bajo lock | Contratos/DDL globales NO ratificados; no merge |
| UC-07 CR-C/CR-F D/E/F/G/H | D/E especificadas pero no ratificadas; F/G propuestas; H RT-UC07-04 abierta | Idempotencia, formatos/retención, mecanismos físicos, estrategia histórica y locks | Decisiones y validación C3; sin implantación |

**Corrección de cronología:** R08.5 §10.5 presentaba decisiones P0/P1 como abiertas; la RATIFICACIÓN posterior ACT-G-COM-001 resuelve funcionalmente RCG-01..08. Las propuestas previas se conservan como historia y no revocan la decisión comercial posterior. PR #66 documenta otra declaración posterior, pero no concede permiso de integración.

## 3. Matriz de contradicciones, persistencia existente y brechas

| ID | Contraste contractual/técnico verificable | Riesgo si se ignora | Tratamiento permitido en Puerta 1 |
|---|---|---|---|
| CX-01 | REV04B UC-05 menciona declaración en tránsito y Cargo/Entrega, pero V1–V3 NO contiene la persistencia integrada PE-1/PE-2/IMP-01 | Captura D_e interpretada falsamente como Cobro/Caja; doble exigible | PE-1 y PE-2 como conceptos, sin columnas ni DDL |
| CX-02 | V1 COBRO.idPedido es 0..1 y no expresa cantidad aplicada; Cuenta/OrigenMovimientoCuenta no vinculan porción de Cobro a una Entrega | Doble uso de anticipo o FIFO; backfill inventado | IMP-B append-only canónico; IMP-A derivada; preflight real futuro |
| CX-03 | EvaluadorCategoriaComercialInterno.reevaluar consume créditos globales FIFO por saldos/movimientos; no distingue atribuciones explícitas y F_e^FIFO vinculante | Mora errónea y crédito reutilizado | Adaptación futura de UC-15 con precedencia explícita y FIFO libre (RCG-03); sin editar Java |
| CX-04 | CobroManualService.anularCobroManual(sesion,idCobro,motivo) carece de clave idempotente; su Resultado no devuelve IDs de contraasientos; usa fn_mr3_anular_cobro_manual | Reintento tras COMMIT o carrera de anulación rompe RCG-05 / D1 | Adenda de firma/DTO y test de replay; protocolo SQL futuro |
| CX-05 | CobroManualService.registrarCobro revalida el replay exigiendo estadoCobro CONFIRMADO; si luego ANULADO, una clave de alta idéntica no devuelve recibo histórico | Contradice RCG-05 replay histórico tras mutación | Diseño de recibo histórico y huella completa, sin tocar app |
| CX-06 | CargarPedidoService.anterior compara en replay solo idCliente + canalOrigen, no detalles/dirección/fecha completos | Clave reutilizada con payload distinto podría aceptarse | E-09 huella semántica completa; prueba futura de 409 |
| CX-07 | REV05 UC-29 usa origen lógico MANUAL/ONLINE; V1 ck_cobro_2 admite REPARTO/ONLINE/ADMINISTRACION, y código manual usa ADMINISTRACION | Falla SQL, incompatibilidad de rendición | E-04 mapea manual->ADMINISTRACION, rendición->REPARTO, ONLINE->ONLINE |
| CX-08 | CR-F UC-07 #48 §15.12 propone insertar DETALLE_PEDIDO(cantidadOriginal=0); RCG-02 prohíbe esta ruta y mantener V1/trigger intactos | Unicidad idPedido/idProducto, producto inactivo histórico, múltiples ofertas mismo Producto, auditoría ficticia | Marcar opción DESCARTADA; diseñar representación de adicionales independiente sin elegir DDL |
| CX-09 | V1 OFERTA_EXCEDENTE registra importe informado/aceptado, pero carece de FK snapshot de precio/versiones de cotización/evidencia documental propuestas en CR-C/F | Desacople de consentimiento, redondeo y origen | Contratos auxiliares candidatos hasta ratificar D/E/F/H |
| CX-10 | V1 ENTREGA PK idPedido; DETALLE_ENTREGA se enlaza a DETALLE_PEDIDO; IMPUTACION_ENTREGA_ADICIONAL referida a detalle original. No hay soporte completo probado para adicionales aceptados según RCG-02 | Se aceptan importes/cantidades sin atribución ni costo correcto | Guard explícito primer UC-05: rechazar pedido con adicionales aceptados no soportados, transacción íntegra |
| CX-11 | REV06B UC-15 prevé FIFO global y UC-16 congelación; RCG-03 exige FIFO vinculado de cobros elegibles y redondeos históricos particulares | Desfase de categorías, centavos y saldos provisionales | E-08 adenda fuente REV06B, sin editar G0 |
| CX-12 | REV05 permite registrar Cobro por Admin/Vendedor, mientras RCG-04 restringe rendición a Admin y BC07 contextual; no se habilita UC-14 al Admin | Escalada de privilegios y exposición de cuentas | E-04/E-10 y matriz campo/rol contextual futura |
| CX-13 | CR-B0-F04-001 mantiene bloqueo físico; R09-PRE app #92 sigue DRAFT; G-FIS, G-DEV, V4 y PR #65 no aprobadas editorialmente | Código/DDL basados en propuestas | Mantener cuatro gates independientes; solo documentación |
| CX-14 | ART-GCON-C2 T1/T2/caridinalidad aún diferidos, pese a C1-a cierre único ratificado por declaración | Indefinición de transacción/confirmación por etapa | Analizar alternativas sin cerrar la decisión ni inventar cardinalidad |

**Nota:** CX-14 usa "cardinalidad" (sin corrección de contratos por este documento). Cada riesgo se documenta, no demuestra una falla ejecutada en producción. El análisis sobre V1 es estático; la eventual aplicabilidad en una base destino requiere preflight de esquema y datos.

## 4. Propuestas de persistencia — no DDL y sin autoridad física

| Concepto | Responsabilidad propuesta de datos | Existente / brecha observada | Invariantes y pruebas futuras |
|---|---|---|---|
| PE-1 — aceptación/Entrega online | Identidad de comando y resultado; enlace a Pedido/Entrega, Repartidor, recibo idempotente, declaración D_e opcional; no capturar como Cobro | ENTREGA/DETALLE_ENTREGA existen; falta persistencia completa de tránsito y evidencia con semántica RCG | Un solo cierre de Pedido; rollback integral; replay; A1 registro diagnóstico fuera de rollback separado |
| IMP-B — libro de aplicaciones | Evento inmutable de reserva, consolidación, FIFO vinculante, liberación y corrección/contraaplicación autorizada; porción Cobro+Cliente+obligación+importe+causa | COBRO/ORIGEN_MOVIMIENTO_CUENTA no acreditan importe aplicado por Pedido | No doble uso; orden de reserva más antigua; elegibilidad de REEMBOLSO; trazabilidad del consumo FIFO |
| IMP-A — proyección activa | Derivación consistente de disponibilidad y compromisos desde IMP-B, sin segunda autoridad mutable | No hay proyección aprobada | Reconciliación contra libro, sin deriva, consultas autorizadas |
| IMP-C — contención | D_e íntegro preservado, no inventar V_e^0 cuando falta evidencia confiable de compromisos o locks | Comportamiento comercial ratificado, protocolo físico pendiente | No Cobro/Caja/credito automático, modo de revisión/regularización |
| PE-2 — rendición UC-29 | Cabecera de cierre de recorrido, aplicaciones por Cliente/Entrega, fondos recibidos/custodia, arqueo en tres vistas y recibos; Cobro REPARTO por Cliente | COBRO, MOVIMIENTO_CUENTA, MOVIMIENTO_CAJA existen; no persistencia integral de recorrido/aplicación/arqueo | Un Cobro por Cliente; no mezclar Clientes, no contabilizar efectivo inexistente; D7-A |
| UC-07 CR-C/CR-F | Oferta/cotización versionada, snapshot de precio/procedencia, evidencia independiente P2b, eventos de estado, idempotencia y locking | OFERTA_EXCEDENTE existe sin versión de cotización ni evidencia P2b aprobada; #48 conserva camino físico incompatible | Ofertas múltiples mismo Producto; historial sin líneas originales ficticias; rollback; FK/oferta; RT-UC07-04 |
| UC-06 / UC-15 / UC-03 | Liberaciones sobre cancelación, FIFO solo libre, saldoExigibleProvisional auditable sin veto nuevo | Servicios existentes aún no conocen IMP-B ni tránsito; UC-03 y UC-15 requieren adaptación futura | No duplicar Cobro/PAGO/Caja; no veto 409 de deuda inventado |

No fijar nombres de tablas, columnas, CHECK/FK, UUID generator, índices, locking ni número de migración con esta matriz. La futura propuesta física deberá justificar integridad y backfill por base destino, sin editar V1–V3.

## 5. Segregación propuesta del primer incremento UC-05 y dependencia UC-07

**Recomendación para una futura autorización de alcance, NO decisión ejecutiva de este PR:** UC-05 online inicial puede tratar únicamente Pedidos sin adicionales UC-07 aceptados. Si existen adicionales aceptados, debe rechazar **en el servidor** y de modo atómico toda confirmación, con estado 409 y un código contractual específico por ratificar en G-CON (nunca entregar parcialmente por el camino heredado, contabilizar D_e ni consumir un intento como éxito). No implica desactivar la consulta UC-07 ni aceptar nuevos adicionales. RCG-02 ya exige expresamente este gate mientras CR-C/F y RT-UC07-04 no estén aprobadas y probadas.

La fase UC-07 completa queda bloqueada para F/G/H; cuando se habilite, cada oferta/version se valora separadamente y una entrega parcial posterior a aceptación no exige nueva conformidad en puerta. El modelo de adicionales debe ser independiente de DETALLE_PEDIDO original. La separación es **un corte operacional condicionado**, no exclusión permanente del dominio ni autorización de endpoint.

## 6. Matriz de decisiones realmente pendientes — para resolución/arquitectura

| Prioridad / ID | Pregunta abierta precisa | Alternativas | Recomendación/estado | Riesgo y evidencia exigida |
|---|---|---|---|---|
| P0 UC07-D | ¿Se ratifica política de clave ASCII 1–128, huella versionada, replay, errores y retención de CR-C §10? | Ratificar íntegra tras auditoría / ajustar alcance y re-presentar | NO RATIFICADA; revisar correlación con RCG-05 | Replay no trazable; pruebas negativas y privacidad |
| P0 UC07-E | ¿Qué evidencia P2b y límites definitivos se admiten? | Calibración y ratificación / soporte inicial acotado con aceptación explícita | NO RATIFICADA; no elevar umbrales experimentales a negocio | Riesgo contenido dañino/privacidad; muestra y controles medidos |
| P0 UC07-F/G/H | ¿Con qué integridad y ruta histórica se sustituye #48 §15.12; cómo se prueba orden global? | Representación de adicionales separada; estrategias preflight/históricos; protocolos C3 candidatos | No decidir PK/trigger; retirar ruta incompatible de propuesta futura | FK/UNIQUE, bloqueo y migración de históricos; PG real tras autorización |
| P0 GCON-C2 | ¿T1/T2, cardinalidad Cobro–Aplicación y COMMIT por etapa? | T1/T2 bajo análisis comparado, cardinalidades por Cliente/Entrega | NO VOTADO; requiere decisión o delegación expresa delimitada a G-ARQ | Atomicidad/duplicación en rendición; pruebas C3 y fallo intermedio |
| P0 GCON editorial | ¿Autorizar luego integración específica de #65/#66/#67? | Revisar cada diff/HEAD, PRE-05, checks, comentarios | No autorización en esta Puerta 1 | Documentos de gobierno ≠ DDL/implementación |
| P1 IMP/PE | ¿Qué diseño transaccional satisface RCG-01/03/04 sin ciclos? | Arquitectura propone orden global y mecanismos auditables, sin elegir físicamente aún | Delegable solo después de autorización de G-ARQ; sin SQL | 40P01/duplicación; IMP-T19/T20, C3, T05 |
| P1 MIG/CR | ¿Cuándo levantar parcialmente CR-B0-F04-001 para PE-1+PE-2+IMP-01? | CR por fases D12-C vs habilitación posterior única | D12-C funcional ratificada; levantamiento físico AÚN NO | V4 prohibida; preflight cinco señales por base destino |
| P2 HIST/BC07 | ¿Cómo comprobar ausencia de anticipos vivos y proyectar D9 por campo? | Preflight de datos tras autorización; matriz de campos en adenda E-10 | RCG-04/06 fija negocio; faltan detalles físicos y revisión editorial | Datos sin protección, crédito histórico falso |
| P2 D1/C04 | ¿Cómo implementar la firma idempotente de anulación aprobada por declaración D1? | Recibo histórico persistido y DTO con contraasientos / alternativas de almacenamiento | Firma conceptual aprobada en #66, publicación editorial y pruebas pendientes | Replay tras COMMIT, carrera y coherencia con V1 |
| P3 OFFLINE | ¿Cuándo incorporar PE-3? | Fase separada compatible / esperar certificación posterior | D12-C y RCG-07 ya difieren PE-3; NO reabrir | Que online dependa accidentalmente de inbox offline |

**No volver a someter a votación:** DC05-08-A, DC-03-B, D5-B, ANT-01, D6-1, D7-A, DC05-01..07-A, DC05-09-A, D12-C, DC-01-C1, DC-02-A, DC-04-A y RCG-01..08. Ajustar solo las opciones técnicas o decisiones no ratificadas, sin alterar las restricciones comerciales.

## 7. Protocolo conceptual de concurrencia, seguridad y pruebas (NO ejecutado)

Secuencia/orden de eventos a modelar, **no secuencia definitiva de locks**:
1. Autenticar en servidor y verificar ámbito por rol/objeto/Cliente, incluida pertenencia de Repartidor y Pedido; revalidar tras esperas. UC-14 continúa exclusivamente VENDEDOR; rendición D6-1 exclusivamente ADMINISTRADOR.
2. Resolver idempotencia de comando, comparar huella semántica y definir resultado de replay/409; rechazo previo a COMMIT no acredita éxito.
3. Verificar la elegibilidad de Pedido, cantidades entregadas positivas para C_e=0, estados, preparación, entregas y adicionales; si hay adicionales sin soporte UC-07, rechazo integral.
4. Determinar C_e histórico (tramo original y, solo cuando UC-07 esté implementado, por oferta/version); bloquear disponibilidad comercial y confirmar reservas explícitas más antiguas, liberaciones y FIFO vinculante sin reutilización.
5. Registrar en una sola transacción el libro IMP-B, Cargo, Entrega, cambios de stock/costos y V_e^0; registrar la D_e íntegra con las fronteras de rollback/diagnóstico ya fijadas por ART-GCON-A1.
6. Cierre ADMIN: registro por recorrido, evidencia digital estructurada, aplicaciones por Cliente/Entrega, Caja/PAGO una sola vez, custodia/exceso/faltante tipado; no superar V_e^vig; no mezclar Clientes ni anular Cobros de rendición con D7-B no autorizada.
7. El grafo final debe estudiar **TODOS** los escritores reales (UC-03/19/28/43/05/07/15/29 y triggers), no solo un par libre de 40P01; resolver GCON-C2 y RT-UC07-04 antes de G-FIS.

**Catálogo de pruebas futuras propuesto, NO EJECUTADO:** SEM-01 FIFO total y V_e=0; SEM-07 dos entregas concurrentes; IMP-T04/T05 reserva/consolidación; IMP-T06/T07 cancelación; IMP-T15 FIFO sin doble uso; IMP-T19/T20 anulación/carrera; T21 cargo cero con unidades; T24 extras parciales; T28 redondeo/total histórico; RT-UC07-04 bloqueo global; GCON-A1 rollback con evidencia diagnóstica separada; GCON-B1 422 cobertura insuficiente; C1-a cierre y replay históricos; C2 fases sin cardinalidad aprobada; 409 para adicionales aceptados no soportados. Tests HTTP RBAC 403, no filtración BC-07, recuperación ante COMMIT/loss, y PRE-05 Demo protegida.

## 8. Puertas y próximo corte

- **Puerta 1: esta PR, análisis y documentos solamente.** Autorizada por el responsable para preparación; documento en DRAFT sujeto a revisión. No editar canónicos ni fusionar.
- **Puerta editorial:** PR #65 E-01..10, #66 resolución parcial, #67 PRE-05 requieren revisiones y autorizaciones **separadas**. Esta PR no sustituye GC-10 ni declara esas PR aptas automáticamente.
- **G-ARQ:** podrá elaborar ADR/DS/contratos candidatos tras decisión expresa sobre los ítems no delegados (particularmente C2 y UC07-D/E). No inventar modelo físico por inferencia.
- **G-FIS / R08.6 físico:** bloqueado; sin V4, DDL ejecutable, modificaciones V1–V3 ni experimentos físicos habilitantes.
- **G-DEV / R09:** bloqueado; sin ediciones de app/main, src/**, scripts, infraestructura, secretos, datos ni Demo. Despliegue sigue pausado (app Issue #28).
- **Gobernanza:** no merge, no rebase/amend/force-push, no cerrar PRs históricas, no auto-deploy.

**Criterio de conclusión de esta Puerta 1:** matriz de autoridad y conflictos revisada, decisiones pendientes diferenciadas, objeciones del responsable identificadas y ruta de adendas + pruebas de siguiente fase aceptada documentalmente, SIN afirmar que persisten evidencias físicas ni que se resolvió C2/RT-UC07-04.

## 9. Registro de QA de esta propuesta

- Fuentes revisadas: contratos y RD descritos en §1; lectura estática de servicios reales y esquema V1.
- Validación manual: correspondencia comercial RCG-01..08 con contradicciones CX-01..14, preservando G0 y PR abiertas.
- **NO EJECUTADO:** suites documentales B0/CI del nuevo HEAD, pruebas Spring/JUnit/Testcontainers, PostgreSQL, seguridad/evidencia UC05/07/29, migraciones, QA humana y despliegue.
- El estado de CI de esta PR deberá verificarse sobre su HEAD definitivo; ausencia de workflow por filtro de ruta no es PASS.
- Riesgos pendientes: semántica C2, representación de extras, locks RT-UC07-04, diseño físico, migración y adendas editoriales.
- Siguiente paso propuesto: revisión humana de esta matriz y preparación independiente de decisiones UC07-D/E y GCON-C2, sin autorizaciones implícitas.

**Referencias de PR:** https://github.com/leandrito369/ale-milanesas/pull/47 ; /pull/48 ; /pull/53 ; /pull/54 ; /pull/55..63 ; /pull/65 ; /pull/66 ; /pull/67 ; https://github.com/leandrito369/ale-milanesas-app/pull/92.