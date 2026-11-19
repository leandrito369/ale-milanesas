# ART-GCON-C2 — Expediente técnico comparativo T1 vs T2: rendición UC-29

**Fecha:** 18/11/2026 (Argentina)  
**Estado:** CANDIDATO DE ANÁLISIS G-ARQ NIVEL 2 / R08.6 PUERTA 1. **ART-GCON-C2 NO VOTADO / DIFERIDO.**  
**Alcance de autorización:** análisis, documentación y PR DRAFT independiente; no contiene DDL ejecutable, no modifica contratos canónicos ni aplicación. La **preferencia técnica por T1** no es decisión del responsable ni aprobación G-ARQ/G-FIS/G-DEV.  
**Gobierno leído:** leandrito369/ale-milanesas main @ 9076570ff3329864fe85c990bcc6f4ff7a63d6e5, PR #66 HEAD e923332096c40620fa4f88f34e76a5d0c2e9213f, PR #54 HEAD cc948fcde1ac2dbfe0a78febff6fd2326b8de258, PR #65 HEAD c8efde5738c202e97cb1135b80656daf0c09570d, PR #68 HEAD c7e1b14d0925022158920de7dc26124aa5f1707f.  
**Aplicación leída en modo SOLO LECTURA:** leandrito369/ale-milanesas-app main @ f5c9af3f76723d5364d44647cfd43ea13a9fd7b5, R09-PRE PR #92 HEAD 5c762bc1c6b3593f975566a05b5c846e275cf7dd.  
**G0/source-lock conservados:** source_commit 1263ffc17bd0eb7f3c69faaa9ff5ae556cf9de7e; governance_commit 27738b089afdd2698cdae915f75c0e8089a6248a. Sin modificaciones a 64 CU / 67 operaciones, RBAC 67×8 ni BC-07 original.

## 1. Pregunta de decisión y precisión terminológica

**Pregunta C2:** ¿La rendición administrativa de un único recorrido se confirma mediante **T1-C2: una transacción ACID agregada** o **T2-C2: una secuencia de aplicaciones con COMMIT individual**, y cómo se acredita cada porción Cobro–Cliente–Entrega sin doble contabilización ni cierres duplicados?

**Evitar homonimias:** R08.5/C3 también usa T1 para el escritor UC-05 (Entrega), T2 para el escritor UC-29 (rendición) y T3 para anularCobroManual. Son identificadores de OPERACIONES CONCURRENTES y **NO** las alternativas T1/T2 de este ART-GCON-C2. Aquí se usan exclusivamente T1-C2 y T2-C2 al comparar protocolos.

ART-GCON-C1-a **ya aprobó** un único cierre por recorrido con clave UUID + huella versionada; ART-GCON-C2 **expresamente diferido** en la declaración original reproducida por PR #66. Tampoco está ratificado un diseño global de generadores/locks/cardinalidades; PR documental no es implementación. El expediente **no** reabre la regla comercial.

## 2. Autoridades existentes — invariantes que T1 y T2 deben satisfacer

1. **C1-a / RCG-05:** cierre único por recorrido, idempotencia por ámbito y huella de payload completo; mismo UUID/mismo payload devuelve **recibo histórico**; mismo UUID/diferente payload -> 409 sin efectos; UUID nuevo en recorrido cerrado -> RECORRIDO_YA_CERRADO sin revelar recibo previo. Revalidar sesión ADMIN, ámbito, pertenencia y permisos incluso en replay.
2. **D6-1 / RCG-04:** solo ADMINISTRADOR confirma rendición; REPARTIDOR únicamente declara UC-05 propio. UC-14 es exclusivo de VENDEDOR: la vista ADMIN de rendición es proyección contextual BC-07, no acceso UC-14.
3. **RCG-03:** en Entrega UC-05, K_e=P_e^{exp}+F_e^{FIFO} disjuntos, E_e=max(0,C_e-K_e), V_e^0=min(D_e,E_e). D_e íntegro, no Cobro/Caja automático. En rendición, A_e suma atribuciones definitivas; 0<=A_e<=V_e^0 y (sin D7-B) V_e^{vig}=V_e^0-A_e; aplicar A_e y reducir V_e^{vig} **en la misma transacción** con un solo Cobro/PAGO/Caja por importe. No convertir Q_e^{decl} en ingreso ni usar faltante no constatado como pérdida.
4. **RCG-04:** Cabecera por recorrido, aplicaciones por Cliente/Entrega, un Cobro definitivo pertenece a un solo Cliente; COBRO.origen='REPARTO', idUsuarioRegistrador=ADMIN, FK verificable a rendición/aplicaciones; custodias separadas de Cobro/Caja de ventas; arqueo en tres vistas y no suma ingenua UC-23 + custodia = efectivo contado.
5. **D7-A:** no permitir anular Cobros vinculados a rendición; anulación de Cobros manuales generales sigue posible bajo sus propias condiciones, con protección de anticipos (DC05-07-A). D7-B está diferida.
6. **A1 / B1 G-CON:** diagnóstico de declaración fallida posterior/fuera de rollback comercial (A1), y rechazo 422 COBERTURA_NO_ACREDITADA cuando falta evidencia, separado del 409 idempotente y del 40P01 técnico con rollback. No confundir registro de fallo con Cobro/Entrega confirmado.
7. **RCG-01 / IMP-B:** libro canónico append-only de reserva, consolidación, FIFO vinculante y liberación; no derivar aplicaciones del campo COBRO.idPedido ni fabricar imputaciones retrospectivas.
8. **C1-a frente a C2:** que exista un cierre único no decide si antes hubo commits por aplicación. C2 debe resolver visibilidad, recovery, vínculos y consistencia de esos posibles intermedios, sin contradecir el cierre único.

Fuentes: ACT-G-COM-001 §§2–3, G-CON PR #66 (acta y anexo literal), R08.5 PR #54, G-CON E-01..E-10 PR #65, R08.6 Puerta 1 PR #68. Las propuestas de PR #65 no se presumen fusionadas.

## 3. Modelo conceptual común (sin nombres SQL ni cardinalidad aprobada)

- **Recorrido** es identidad funcional de agrupación de Entregas del Repartidor; el cierre tiene identidad propia, actor ADMIN, huella, estado de resultado y recibo histórico inmutable. No se afirma que exista tabla RECORRIDO en V1–V3: **no existe** CREATE TABLE RECORRIDO en V1 examinado.
- Cada Entrega e pertenece a un Pedido/Cliente y conserva C_e, K_e, D_e, V_e^0, eventos IMP-B, A_e(t), V_e^{vig}(t) y diferencias tipadas. Nada de ello permite inferir P_e desde COBRO.idPedido.
- Una **atribución/aplicación** financiera positiva une explícitamente cierre, Entrega, Cliente, Cobro definitivo, importe y evidencia de recepción; sus porciones no se superponen. Registros de cero/faltante/custodia son eventos distintos de una aplicación monetaria positiva.
- Un Cobro de rendición pertenece exactamente a **un Cliente**; puede representar una o varias Entregas de **ese mismo Cliente** si la cardinalidad elegida lo habilita. Los movimientos PAGO/Caja resultantes deben corresponder una sola vez a su importe confirmado. Nunca agregar en un Cobro Clientes distintos.
- La identidad del intento de cierre de recorrido es distinta de la identidad de la eventual aplicación por etapa. Si existieran commits parciales, ambas necesitan unicidad, huella y correlación durables; el recibo de C1-a se emite solo al cierre confirmado.
- **No se fijan aquí** tablas, tipos, índices, foreign keys, namespace ni orden definitivo de locks. La eventual FK de rendición a Cobro y de aplicación a Entrega debe resultar verificable; V1 COBRO.idPedido no acredita aplicación.

## 4. Alternativas transaccionales

### T1-C2 — Cierre ACID agregado del recorrido

**Semántica propuesta:** una solicitud ADMIN aporta el recorrido, la clave UUID de cierre y el conjunto de atribuciones y evidencia. Validaciones no decisorias pueden prepararse antes; **toda validación que proteja invariantes y todas las escrituras financieras se repiten bajo el mismo punto de serialización**.

**Secuencia conceptual NO SQL:**
1. Autenticar/revalidar ADMIN + ámbito del recorrido y sus Entregas/Clientes; normalizar huella semántica (sin incluir hora de recepción/sesión efímera), incluido orden y multiplicidad cuando sean contractuales.
2. Inicio de transacción DB; adquirir bloqueos en orden **global que G-ARQ deberá demostrar** frente a UC-03/05/07/15/19/28/29/43, la anulación y las funciones/triggers. Serializar identidad de cierre y claves globales.
3. Comprobar si existe resultado de cierre anterior. Replay idéntico: recibo histórico sin nuevos movimientos; misma clave/huella distinta: 409; clave nueva con recorrido ya cerrado: RECORRIDO_YA_CERRADO. Revalidar permisos tras espera.
4. Comprobar por Entrega V_e^{vig}, saldo de aplicaciones y evidencia; rechazar cobertura insuficiente (422) sin consumir intento confirmado. Descartar montos sin atribución comprobable; mantener custodia y faltantes tipados.
5. Registrar cabecera, atribuciones positivas por Cliente/Entrega, Cobros REPARTO por Cliente bajo cardinalidad aprobada, PAGO, ingreso Caja efectivo realmente recibido y cese exactamente equivalente de V_e^{vig}; asentar custodia por exceso físicamente recibido separado. Verificar conservación/arqueo.
6. Confirmar **una sola vez** todo el conjunto y recibo histórico; el cierre pasa a confirmado. El ACK HTTP es posterior al COMMIT; no debe existir estado de cierre visible como final si faltó alguna aplicación requerida del conjunto.

**Fallo antes del COMMIT:** rollback de todo el cierre, ninguna aplicación/Cobro/PAGO/Caja de este intento confirmada, clave sin recibo de éxito; auditoría de fallo no puede confirmar el negocio. **COMMIT exitoso/ACK perdido:** replay con misma clave/huella devuelve exactamente el recibo histórico. **Límite:** transacción potencialmente larga, espera en hot rows y baja concurrencia; se exige medir tiempo/carga y no introducir tamaño máximo comercial sin RD.

### T2-C2 — Aplicaciones con COMMIT individual

**Semántica candidata:** cada etapa confirma uno o varios importes por Cliente/Entrega de manera durable mientras el recorrido todavía no tiene cierre final C1-a. El último paso publica el cierre único.

**Secuencia conceptual:** identidad cabecera/intent y estado no-final -> etapa A bloquea y confirma porciones A y sus Cobros/PAGO/Caja -> etapa B confirma otras porciones -> cierre final verifica la totalidad, la contabilidad y emite recibo histórico C1-a.

**Riesgo primario:** al fallar entre COMMIT(A) y COMMIT(B), existen Cobros definitivos sin cierre completo. D7-A impide deshacerlos mediante anulación ordinaria, y el reintento no puede repetirlos ni compensarlos informalmente. Es obligatorio diseñar antes:
- estados e identidades permanentes de etapa y huella; control de cambios del conjunto tras iniciar;
- visibilidad de saldos provisionales/confirmados durante la preparación, permisos y arqueo intermedio;
- protocolo de recuperación de etapas inconclusas sin duplicación y sin que dos ADMIN ejecuten etapas incompatibles;
- determinación explícita de qué significa «cierre único» si hay efectos financieros anteriores;
- bloqueo/contención cuando no sea posible recuperar y tratamiento de abandono administrativo;
- integridad de Cobro↔Aplicación, Caja y cuenta bajo reconexión, dos etapas simultáneas y cambio de ámbito.

**Variante T2-P (staging sin efecto contable):** COMMIT por etapa solo de propuestas/evidencias sin disminuir V_e^{vig} ni crear Cobro/PAGO/Caja; un único COMMIT final crea todas las aplicaciones financieras. **No es T2 financiera pura**: equivale a T1 para el punto irreversible de negocio, con mayor persistencia de preparación y requisitos de expiración/versionado. Puede ser útil para formularios extensos, pero no demuestra la viabilidad del T2 de commits financieros individuales.

**Fallo tras A:** efectos A durables; B inexistentes. Recuperación y custodia deben ser demostradas, no se asume rollback global. **COMMIT(B) exitoso/ACK perdido:** reintento de etapa devuelve su recibo sin ejecutar otro Cobro; cierre final debe conservar huella y correlación. **Fallo de recuperación:** recorrido intermedio protegido, sin simular cierre ni prometer contraaplicación D7-B.

## 5. Comparación estructurada de riesgos

| Criterio | T1-C2 (único COMMIT) | T2-C2 (COMMIT por etapa) | Preferencia provisional |
|---|---|---|---|
| Atomicidad del cierre | Alta: todo o nada por recorrido | Parcial entre etapas; exige recuperación | **T1** |
| Conformidad C1-a | Directa: resultado único y recibo | Condicionada a semántica de estados parciales | **T1** |
| No doble Cobro/PAGO/Caja | Un punto de efecto irreversible; aún requiere FK/UNIQUE | Muchos puntos de replay y transacción | **T1** |
| Rendición parcial respecto V_e | Se confirman las porciones efectivamente recibidas; el faltante queda pendiente | Posible por etapas, pero no supone ventaja comercial automática | **Igual negocio** |
| Dos Clientes en mismo recorrido | Cobros separados por Cliente en transacción común | Etapas por Cliente independientes; riesgo de cierre incompleto | **T1** |
| Concurrentes UC05/UC29/anulación | Locks del conjunto más prolongados | Locks más breves por etapa, mayor superficie de intercalados | **A medir** |
| Fallo entre Clientes | Rollback de todo; sin recibo final | A confirmado/B pendiente; recovery obligatorio | **T1** |
| Escalabilidad | Puede bloquear recorridos grandes | Mejor tolerancia de lotes si recuperación demostrada | **T2 potencial** |
| Complejidad y pruebas C3 | Menor cantidad de estados; igual prueba global requerida | Máquina de estados y pruebas crash/replay adicionales | **T1** |
| Interacción D7-A | Cobros nacen asociados a rendición final | Cobros parciales no anulables antes de finalizar: riesgo alto | **T1** |
| Auditoría y custodia | Recibo y libro en un corte; custodia separada | Custodia y estados intermedios más complejos | **T1** |
| Compatibilidad actual V1–V3 | Requiere PE-2/IMP-B/CR física | Requiere PE-2/IMP-B y más estructuras; ninguna autorizada | **Ambas bloqueadas** |

**Hipótesis recomendada para decisión futura:** T1-C2 como primera estrategia online, **condicionada** a un diseño de cardinalidades, un grafo global de locks acíclico, cargas representativas y una campaña de recuperación. NO resulta de esta PR una aprobación de T1.

## 6. Cardinalidad Cobro–Aplicación: alternativas separadas de T1/T2

| Modelo | Relación por cierre | Ventajas | Costes/condiciones | Dictamen candidato |
|---|---|---|---|---|
| K1 — Cobro por Entrega aplicada | Cada aplicación positiva corresponde a un Cobro específico (1:1 usual); varios Cobros posibles del mismo Cliente en un recorrido | Trazabilidad directa Entrega–Cobro, referencia idPedido no ambigua | Multiplica Cobros, Caja/PAGO y secuencias; no elimina carrera ni evidencia | Válido a estudiar, no impuesto |
| K2 — Cobro agregado por Cliente y cierre | Un Cobro REPARTO por cada Cliente con importe positivo en ese cierre; 1 Cobro → N aplicaciones de sus Entregas | Menos Cobros/Caja; límites de Cliente claros; permite varias Entregas mismo Cliente | Exige FK/vínculo explícito por aplicación y suma exacta; COBRO.idPedido contextual NULL al abarcar varias Entregas | **Preferido, sujeto a revisión C2** |
| K3 — Cobro global multicliente | Un Cobro reúne aplicaciones de Clientes distintos | Menos filas en apariencia | **Incompatible con RCG-04/D6-1**: Cobro tiene un único idCliente y no puede mezclar Clientes | **Descartado por autoridad comercial** |

**Propuesta conceptual K2:** una identidad de cierre para 1 recorrido; un cierre genera 0..N aplicaciones positivas y, para cada Cliente con aplicaciones positivas, 1 Cobro REPARTO de ese Cliente; cada aplicación positiva referencia exactamente 1 Entrega/Cliente y 1 Cobro del mismo Cliente y cierre. La suma de importes de aplicaciones de un Cobro = su importe; 0<=sum(A_e)<=V_e^0 por Entrega; no duplicar una porción en cierres/reintentos. Si no hay importes elegibles, no fabricar Cobro de 0; debe resolverse explícitamente si puede cerrarse con solo diferencias/custodia y qué recibo corresponde. El cierre de recorrido se realiza una vez; remanentes V_e^{vig} no se extinguen por marcar recorrido cerrado.

**Objeto/relaciones futuras conceptuales:** Recorrido(1)→Cierre(0..1); Cierre(1)→Aplicaciones(0..N); Cierre(1)→CobrosREPARTO(0..N); Cobro(1)→Aplicaciones(1..N), todas para el mismo Cliente; Entrega(1)→Aplicaciones(0..N a través del tiempo, sujetas a no exceder V_e^0). La multiplicidad definitiva y representación de rendiciones posteriores no se fija aquí.

**Sobre esquema vigente:** V1 COBRO incluye idCliente NOT NULL, idPedido nullable, origen REPARTO/ONLINE/ADMINISTRACION y unique(claveIdempotenciaOrigen); ORIGEN_MOVIMIENTO_CUENTA tiene un origen por movimiento, no un importe de aplicación por Entrega. V1 no acredita tabla RECORRIDO ni cabecera/custodia PE-2, y la implementación actual de CobroManualService crea solo Cobro general ADMINISTRACION, un MOVIMIENTO_CUENTA(PAGO) y un MOVIMIENTO_CAJA(INGRESO) por Cobro. Nunca tomar COBRO.idPedido como IMP-B.

## 7. Ejemplo numérico 1 — recorrido con dos Clientes, tres Entregas

**Datos sintéticos de ejemplo** (ARS; descuentos/prepagos calculados y acreditados de antemano en UC-05, no recreados en rendición):

| Entrega | Cliente | C_e cargo | P_e^{exp} | F_e^{FIFO} | K_e | E_e | D_e declarado | V_e^0 |
|---|---|---:|---:|---:|---:|---:|---:|---:|
| e-A1 | Cliente A | 120,00 | 20,00 | 10,00 | 30,00 | 90,00 | 70,00 | 70,00 |
| e-A2 | Cliente A | 80,00 | 0,00 | 15,00 | 15,00 | 65,00 | 50,00 | 50,00 |
| e-B1 | Cliente B | 90,00 | 30,00 | 0,00 | 30,00 | 60,00 | 70,00 | 60,00 |
| **TOTAL** | — | **290,00** | **50,00** | **25,00** | **75,00** | **215,00** | **190,00** | **180,00** |

En la rendición física el ADMIN verifica: **Cliente A, e-A1 = 70,00, e-A2 = 40,00**; **Cliente B, e-B1 = 70,00 físicamente**, pero solo 60,00 son imputables según V_e^0. El total contado y recibido es 180,00. La atribución autorizada A_e suma **170,00** (A=110,00; B=60,00); los **10,00 restantes del Cliente B** quedan bajo **custodia no imputada**, sin Cobro/PAGO/Caja de venta. El Cliente A mantiene exposición provisional **10,00** en e-A2, susceptible de faltante físico constatado y conciliación; no se presume pérdida adicional por la suma de indicadores.

**Asientos candidatos para K2, bajo T1:**

| Cobro conceptual | Cliente | Aplicaciones | Importe Cobro/PAGO/Ingreso Caja de venta |
|---|---|---|---:|
| r-A | A | e-A1 70,00 + e-A2 40,00 | **110,00** |
| r-B | B | e-B1 60,00 | **60,00** |
| **Total** | — | — | **170,00** |

**Estado financiero por Entrega tras cierre:** A_e(e-A1)=70, V_e^{vig}(e-A1)=0; A_e(e-A2)=40, V_e^{vig}(e-A2)=10; A_e(e-B1)=60, V_e^{vig}(e-B1)=0. La igualdad de conservación es **sum(A_e)+sum(V_e^{vig})=170+10=180=sum(V_e^0)**. El saldo confirmado del conjunto de Clientes baja 170 por PAGO y el tránsito vigente baja 170; por Cliente, **saldoExigibleProvisional = saldoConfirmado - tránsito vigente** permanece sin doble descuento, si no hubo otra mutación concurrente.

**Diferencias no sumables:** Q_e^{decl}(e-B1)=D_e-V_e^0=10; el exceso de fondos físicamente recibidos B=10 se custodia, pero ambos conceptos describen el mismo tramo de distinta forma, NO dos ingresos/pérdidas. En e-A2, pendiente de tránsito=10 y un faltante físico constatado podría ser 10 con evidencia atribuible; tampoco se suma dos veces.

Este ejemplo **no constituye** regla nueva de distribución física sin evidencia entre Entregas. La atribución A1/A2/B1 se supone aportada y confirmada por ADMIN; si solo se cuenta un sobre global sin atribución verificable por Cliente/Entrega, **B1/RCG-04 impiden inventar el reparto** y se aplica contención según cobertura real.

## 8. Ejemplo numérico 2 — fallos y reintentos

**Entrada fija:** cierre recorrido R-51 con Cliente A (110,00) y Cliente B (60,00) del ejemplo 1. Clave de cierre K-51 UUID (identificador ilustrativo, no string de producción); huella H(v1, clientes, aplicaciones, importes, fuente, custodia, evidencia y ámbito).

| Instante / fallo | T1-C2 | T2-C2 por COMMIT financiero |
|---|---|---|
| Antes de empezar | Ningún efecto | Ningún efecto |
| Después de preparar A pero antes de COMMIT | A provisional no visible como Cobro confirmado | Si se confirma etapa A: Cobro/PAGO/Caja A=110,00 ya durables |
| Falla al tratar B | Rollback, **0 Cobro / 0 PAGO / 0 Caja** de K-51 | A=110,00 durable, B=0; cierre sin recibo final; requiere recuperación |
| Reintento misma clave después del fallo | Nuevo procesamiento íntegro si no hubo COMMIT | Identificar etapa A y reutilizarla; jamás sumar otros 110 |
| Falla de red tras COMMIT final exitoso | Replay devuelve mismo recibo y Cobros A=110/B=60, total 170 | Replay exige estado por etapas + cierre; mismas cifras, pero mayor complejidad |
| Nueva clave sobre recorrido ya cerrado | RECORRIDO_YA_CERRADO sin revelar recibo histórico | Igual obligación, incluso si etapas históricas existen |
| Mismo UUID, payload distinto | 409, sin efectos | 409 también en cualquier etapa; el cierre no puede recomponer otra cartera |

**T2 y D7-A:** está prohibido usar anularCobroManual para eliminar A=110 tras fallo de B; es un Cobro de rendición y su anulación está bloqueada. Si T2 se adopta, hay que aprobar explícitamente la semántica de estados incompletos, recuperación y tratamiento de eventual abandono. No se habilita D7-B por inferencia.

## 9. Concurrencia y protocolo de locks: riesgos REALES versus candidatos

**Observado por lectura de código en main de aplicación:** CobroManualService.registrarCobro toma pg_advisory_xact_lock(2929001) -> CLIENTE FOR UPDATE -> PEDIDO FOR SHARE cuando corresponde; genera IDs por MAX+1 y la secuencia por Cliente. anularCobroManual toma el mismo advisory, después COBRO FOR UPDATE y **recién luego CLIENTE FOR UPDATE** mediante función SQL. El código de rendición F04 aún **no existe**. No ejecutar T1/T2 sobre este orden sin conciliarlo.

**Evidencia anterior R08.5/C3:** el prototipo de UC-05 que tomaba PEDIDO antes que CLIENTE produjo 40P01 en C3-08; el intercalado reordenado A1(2929001) -> CLIENTE -> PEDIDO serializó ese caso. **No prueba ausencia de ciclos globales**, ni T2-C2, ni T1-C2, ni T2 escritor de rendición vs T3 anulación.

| Cruce | Riesgo concreto | Guardia/propuesta para G-ARQ (sin fijar SQL) |
|---|---|---|
| Cierre rendición ↔ Cobro manual del mismo Cliente | Saldos/secuencias divergentes, MAX+1, orden diferente de locks | Bloqueo ordenado de Cliente(s), serialización de generadores, revalidar saldo y ámbito |
| Cierre rendición ↔ anularCobroManual sobre anticipo | Lectura de P_e o IMP-B obsoleta; COBRO→CLIENTE inverso | Incluir función SQL/trigger y escrituras indirectas en grafo; unificar orden verificable |
| Cierre rendición ↔ otra rendición del mismo recorrido | Dos cierres y doble Caja si la clave difiere | Unicidad cierre por recorrido; dos ADMIN concurrentes, replay/conflicto seguros |
| Cierre rendición ↔ UC-05 que valida entrega | Valor V_e^vig leído fuera de corte; fondos duplicados/no disponibles | Revalidación bajo serialización, aislamiento/guardas de versión; lock order total |
| Cierre rendición ↔ UC-07/UC-19/UC-28/UC-43 | Intercalados en Pedido, Producto, Precio, Stock, Excedente | Matriz C3 completa y locks de funciones/triggers; RT-UC07-04 abierta |
| Dos Clientes en cierre | Deadlock si se adquieren en órdenes inversos | Orden total determinista por ID de Cliente, y luego dependencias verificadas |
| T2-C2 etapa A ↔ etapa B ↔ consulta UC-14 | Estado financiero parcial visible entre COMMIT | Definir proyecciones provisionales, versiones y aislamiento o descartar T2 |
| T1-C2 muy largo ↔ operación online | Bloqueo/timeout, contención o denegación de servicio | Medir tiempos/bloqueos por volumen; sin declarar T1 apto sin tests |

**No adoptar aún** el consejo simple «advisory 2929001 resuelve todos los deadlocks». Es un recurso usado por ciertos servicios, pero deben auditarse todos los escritores, triggers, otras claves/locks y accesos SQL directos. Cualquier orden propuesto es candidato; certificar aciclicidad requiere matriz C3, intercalados y una estrategia de rollback de errores 40P01.

## 10. Estados, idempotencia y recuperación — requisitos verificables

| Propiedad | T1-C2 | T2-C2 |
|---|---|---|
| Recibo de cierre | Único, durable, mismo en replay | Único al final; recibos de etapa adicionales no son «cierre» |
| Clave confirmada | Junto con todos los efectos finales | Cierre final y claves únicas por etapa; correlación obligatoria |
| Rechazo pre-COMMIT | No consumir clave aplicada | Rechazos de etapa no consumen su aplicación; etapas previas ya confirmadas no se borran |
| Cierre con Cobro cero | No fabricar Cobro; definir caso de solo constancias | Igual, más semántica de etapas vacías |
| Recuperación tras ACK perdido | Leer recibo histórico desde la misma DB | Leer cabecera, huella y recibos de etapas + cierre |
| Recuperación tras caída entre pasos | Ningún estado financiero parcial | Estados parciales durables; reconciliador/admin recovery necesario |
| Retries concurrentes | Serializar por recorrido/clave y devolver una respuesta | Serializar cierre y cada etapa, comprobar cartera y versiones |
| B1 cobertura insuficiente | 422 sin cierre confirmado | Etapas previas confirmadas crean problema si la cobertura de otra se descubre tarde |
| Custodia | Registro conciliable distinto de Cobro/Caja | Misma exigencia, estados por etapa y recuperación de evidencia adicional |
| Revocación ADMIN durante espera | Revalidación antes de efectos finales | Revalidación en cada etapa y al cierre, sin permitir continuar sin permiso |

**Regla de seguridad:** no exponer en respuestas a ADMIN un estado de otros Clientes/recorridos ajenos a la atribución; no conceder UC-14 a ADMIN. REPARTIDOR no confirma rendiciones. Este expediente no modifica el RBAC G0.

## 11. Casos de prueba y criterios de decisión para una futura fase autorizada

Propuestos, **NO EJECUTADOS en este expediente**:

| Test | Preparación / intercalado | Esperado mínimo |
|---|---|---|
| C2-T01 | Un Cliente/una Entrega, cobro parcial | Un Cobro REPARTO, PAGO/Caja una vez, V_e baja mismo importe |
| C2-T02 | Dos Entregas mismo Cliente, K1 vs K2 | Suma por Cliente exacta, vínculo FK por Entrega, idPedido no inferido |
| C2-T03 | Dos Clientes, 3 Entregas, caja 180, aplicación 170, custodia 10 | Cobros 110+60, no Cobro multicliente, Vvig 10 |
| C2-T04 | Inyectar error antes del COMMIT final T1 | 0 Cobro/PAGO/Caja nuevos, sin cierre ni clave de éxito consumida |
| C2-T05 | COMMIT final confirmado y respuesta HTTP perdida | Replay idéntico devuelve mismo recibo y mismas identidades sin duplicación |
| C2-T06 | Mismo UUID, payload distinto / nueva clave recorrido cerrado | 409 o RECORRIDO_YA_CERRADO, no revelar recibo ajeno |
| C2-T07 | Dos ADMIN concurrentes sobre el mismo recorrido | Un cierre único; segundo replay/conflicto según clave/huella |
| C2-T08 | UC-05 ↔ rendición ↔ Cobro manual ↔ anulación | Cero 40P01 no recuperados, sin doble IMP-B y sin MAX+1 duplicado |
| C2-T09 | T2 falla después de COMMIT(A), antes de B | A durable y rastreado; recuperación formal sin repetir A, sin cierre falso |
| C2-T10 | UC-14 durante T1/T2 intermedio y cambios de estado | No doble descuento, permisos VENDEDOR/ADMIN correctos, vista segura |
| C2-T11 | Devolución/custodia exceso y faltante constatado | Tres vistas de arqueo, fondos no imputables no generan Caja de venta |
| C2-T12 | Crash/rollback, intento con datos insuficientes (422), y contención IMP-C | Sin confirmaciones ficticias; diagnóstico fuera de transacción cuando aplique |
| C2-T13 | V_e^0=0 con D_e>0 y unidades entregadas; cero cantidad inválido | Sin Cobro ficticio, D_e íntegro, diferencias correctas |
| C2-T14 | Repetición de aplicación tras mutación posterior legítima | Recibo histórico en replay, sin duplicar PAGO/Caja |
| C2-T15 | Pruebas de latencia/hot rows para recorrido corto y masivo | Medir duración de locks, timeout y throughput; no fijar umbral sin medición |
| C2-T16 | Revisión de V1–V3, función de anulación y trigger con escritor SQL directo | D7-A aplicada de forma integral y sin ciclo global |

**Evidencia mínima por test futuro:** commit/HEAD exacto, esquema y versión PostgreSQL, dataset sintético y condición de aislamiento, transacciones/sesiones, secuencia de barreras, resultados DB antes/después, restricciones verificadas, captura de SQLSTATE y regresión de UC-29 manual/UC-15/UC-03. Tests C3 previos son antecedente, no PASS de C2.

## 12. Decisiones reservadas y propuesta de dictamen al responsable

**Propuesta ARQ (para votar luego, no aprobado):**
- **C2-P1:** preferir **T1-C2** para el primer online; no introducir T2-C2 con Cobros durables por etapa mientras no exista diseño formal de recuperación ni una autorización comercial que tolere estados parciales.
- **C2-P2:** preferir cardinalidad **K2**: 1 Cobro REPARTO por Cliente con importe positivo y cierre; 1..N aplicaciones del mismo Cliente, 1 referencia por aplicación hacia Entrega, sin un Cobro multicliente, con suma exacta Cobro=Σ aplicaciones; idPedido informativo/null si agrupa.
- **C2-P3:** el cierre debe permitir aplicaciones parciales menores a V_e^0 y conservar V_e^{vig} restante; un faltante constatado no es Cobro y la custodia de exceso no es Caja de venta.
- **C2-P4:** la selección técnica NO equivale a elegir un orden concreto de SQL locks, namespaces, generadores, aislamiento, tabla/constraints ni V4. G-ARQ produce ADR/DS y C3 con prueba, luego G-FIS requiere permiso.
- **C2-P5:** resolver explícitamente caso de cierre sin importe elegible, recepción física no atribuible, representación de etapas si se autorizara T2, y cómo regularizar tránsito restante luego del cierre único sin D7-B.

**Qué autoriza este PR:** solamente revisión humana de las alternativas y eventual preparación de una RD/ADR posterior (separada). **Qué NO autoriza:** aprobación C2, cierre de PR #66/#68, merge, G-ARQ Nivel 1 por inferencia, G-FIS, CR-B0-F04-001, DDL, Flyway V4, cambios V1–V3, src/**, PR #91/#92, Demo, despliegue ni datos reales. PR #65 permanece bajo GC-10 independiente. La constancia G-ARQ Nivel 1 debe acreditarse con documento/commit verificable antes de invocar su aprobación como antecedente.

**Checklist para elevar a decisión:** (a) comprobar fuente G-ARQ Nivel 1; (b) revisar K1/K2 y casos numéricos; (c) exponer excepciones de T1 y T2/abandono; (d) solicitar decisión específica T1/K2 y salvedades **solo cuando responsable lo evalúe**; (e) documentar RD/ADR y pasar luego a propuesta física con C3 y preflight por base destino.

## 13. Referencias rastreables

- Plan rector: docs/01-gobierno/PLAN_RECTOR_IMPLEMENTACION_2026-10-29.md (main); roadmap operativo: docs/01-gobierno/ROADMAP_OPERATIVO_I3_I7_2026-11-15.md (main).
- ACT-G-COM-001, §§RCG-01/03/04/05/06/08, en main.
- Resolución y fuente literal C2 diferida: https://github.com/leandrito369/ale-milanesas/pull/66 (dos Markdown, OPEN/DRAFT).
- G-CON E-01..E-10: https://github.com/leandrito369/ale-milanesas/pull/65 (DRAFT).
- R08.5 y pruebas de C3: https://github.com/leandrito369/ale-milanesas/pull/54 ; app https://github.com/leandrito369/ale-milanesas-app/pull/89 .
- Expediente de conciliación de autoridad: https://github.com/leandrito369/ale-milanesas/pull/68 (DRAFT).
- Plan R09-PRE: https://github.com/leandrito369/ale-milanesas-app/pull/92 (DRAFT).
- CobroManualService.java; EvaluadorCategoriaComercialInterno.java; src/main/resources/db/migration/V1__baseline_mr5.sql, lectura app main @ f5c9af3f76723d5364d44647cfd43ea13a9fd7b5.
- Issue de despliegue pausado: https://github.com/leandrito369/ale-milanesas-app/issues/28 .

**Verificación en este corte:** revisión estática de documentos, código y DDL fuente únicamente. Ninguna prueba del protocolo propuesto, migración, evaluación de rendimiento o certificación de arquitectura se ejecutó. No se envían credenciales ni se accede a la Demo.
