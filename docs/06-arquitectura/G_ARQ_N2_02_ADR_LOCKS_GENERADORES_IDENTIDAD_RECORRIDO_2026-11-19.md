# G-ARQ-N2-02 — ADR de cierre técnico para R08.6: locks, generadores e identidad de recorrido

**Corte:** G-ARQ-N2-02, desglose de R08.6 del Plan Rector / Roadmap Operativo I3–I7. **Fecha:** 19/11/2026 (UTC−03).  
**ESTADO:** RECOMENDACIÓN TÉCNICA CERRADA PARA REVISIÓN, **NO DISEÑO FÍSICO APROBADO NI TEST C3 FINAL**. PR documental OPEN/DRAFT/NO MERGE.  
**Mandato del responsable:** 2026-11-19T03:34:56Z: cerrar el ADR documental, inventariar escritores/funciones/triggers faltantes y elegir técnicamente A/B/C; **D1 confirmado** (rendición inicial exclusivamente de efectivo RD-F04-002) y **E confirmado** (no abrir circuito nuevo de recupero después de cierre RD-F04-005). Resolver/acotar S10 y señalar mínimo de PR #65–#71 antes de solicitar G-FIS, **sin subcortes documentales intermedios**.  
**Autoridad comercial previa:** ART-GCON-C2 ratificada por declaración en PR gobierno #70 (T1-C2 + K2, diez salvedades S01–S10); ACT-G-COM-001 (RCG-01..08); RD-F04-002/005; G0 64 CU/67 operaciones, RBAC y BC-07.  
**Base verificada, solo lectura:** gobierno `leandrito369/ale-milanesas/main@9076570ff3329864fe85c990bcc6f4ff7a63d6e5`; aplicación `leandrito369/ale-milanesas-app/main@f5c9af3f76723d5364d44647cfd43ea13a9fd7b5`.  
**Fuente de arquitectura previa:** gobierno PR #71 HEAD `f1b4077182337c904bc3a64c15bd142f6e7077d7`. **No repite** modelo lógico, fórmulas de V_e, escenarios económicos ni la matriz R/P/D detallada de #71.  
**Evidencia experimental anterior, no ampliada aquí:** app PR #89 HEAD `642abd6541f0e358d1f9124d7d80bb49234faa14`, C3-A.3 R/P/D sobre PostgreSQL 17.11 efímero; informes de CI referenciados en la PR. La inversión UC43↔UC05 y UC29↔UC05 produjo 40P01 en prototipos. No demuestra ausencia de ciclos en código final.  
**Source-lock G0 preservado:** source_commit `1263ffc17bd0eb7f3c69faaa9ff5ae556cf9de7e`, governance_commit `27738b089afdd2698cdae915f75c0e8089a6248a`. Sin modificación de la Demo; todo el trabajo posterior orientado al sistema final según roadmap.

## 1. Resultado ejecutivo y puerta

**Elección técnica del ADR — cerrada como RECOMENDACIÓN, no implantada:**
- **A2-GLOBAL:** protocolo compartido y versionado de adquisición con **advisory locks de dos claves con namespace por dominio/recurso**, orden de precedencia determinista y **puente de compatibilidad** con guards existentes durante una migración autorizada; **no** adoptar A1 como solución global perpetua ni confiar solo en `2929001`.
- **B2-HÍBRIDO:** para **identificadores globales técnicos**, preferir **secuencias PostgreSQL/identidades persistentes** tras preflight, sin cambiar V1–V3; mantener **ordinales de negocio por Cliente/Pedido** bajo bloqueo del agregado correspondiente y unicidad relacional, sin introducir huecos como regla comercial. No confundir número de cuenta por Cliente con PK global.
- **C1-EXPLÍCITO:** identidad **persistente, inmutable y distinguible de la Fecha/Repartidor** para cada **Recorrido** y su **Cierre**, con pertenencia a asignaciones/Entregas verificable, cierre confirmado único e idempotencia C1-a. No derivar la identidad de `idUsuarioRepartidor+fechaReparto` ni de `COBRO.idPedido` sin contrato que lo autorice.

**Conservación del negocio:** T1 en una transacción ACID, K2 a lo sumo un Cobro `REPARTO` por Cliente/cierre con 1..N aplicaciones, S01–S10, D1 efectivo exclusivamente y E sin nuevo recupero post-cierre. `COBRO.estadoCobro` no incorpora `PENDIENTE`; la pendencia corresponde a la rendición. Medios mixtos en un Cobro de rendición quedan fuera del primer alcance aprobado: no cambiarlos ni falsificar `medioPago`.

**Veredicto:** `G-ARQ-N2-02: RECOMENDACIÓN TÉCNICA COMPLETA / APTO PARA REVISIÓN EDITORIAL Y PREPARACIÓN DE SOLICITUD G-FIS CON SALVEDAD S10`. **NO** significa `G-ARQ N1 acreditado`, `CI C3 global PASS`, `CR-F04 levantada` ni `G-FIS autorizado`. La solicitud G-FIS se elevará al terminar el preflight/editorial de §7 **sin un nuevo subcorte documental**, pero sus responsables deberán decidir expresamente si S10 es admisible o bloqueante antes de permitir V4.

## 2. Inventario ampliado de escritores y dependencias verificadas

**Método:** lectura estática del código principal de **23 clases de servicios/colaboradores de negocio**, muestra dirigida de controladores de web y de los SQL de `V1__baseline_mr5.sql`, `V2__f01_cobro_estados.sql`, `V3__trazabilidad_partidas_insumo.sql`. No es captura `pg_locks` ni inventario de un host en ejecución. El árbol app main contiene 115 archivos `src/main/` (Java/SQL/config/plantillas); no se afirma revisión manual de cada archivo no escritor. Los 23 servicios abarcan las operaciones de escritura de negocio identificadas en los submódulos examinados; otros escritores externos (scripts, integración no implementada, SQL directo de otra versión) son **frontera de preflight**.

| Frente escritor REAL en app main | Protección/adquisición observada (en orden de aparición) | Identificadores / riesgo para R09 |
|---|---|---|
| UC-03 CargarPedido | `A2(3003,0) → A1(idCliente) → CLIENTE U → PRODUCTO S → PRECIO S`; invoca evaluación UC15/16 | `MAX(idPedido)+1`; colisión A1(ClientID) con A1(InsumoID); interfaz sin cambio en este corte |
| UC-43 AsignarReparto | `A1(9172001) → A2(60505,7) → USUARIO S → PEDIDO U → ASIGNACION U` | `MAX(numeroAsignacion)+1` por Pedido; C3-03 demostró inversión P/A como 40P01 con prototipo UC05 |
| UC-28 RegistrarPreparacion | `PEDIDO U → DETALLE_PEDIDO U → A2(808,0) → PRODUCTO/RECETA S → A1(idInsumo) → INSUMO U → PARTIDA U` | `MAX(idPreparacion/idMovimientoInsumo)+1`, secuencia por Insumo; trigger V3 modifica PARTIDA |
| UC-19 ActualizarPrecioVigente | `PRODUCTO U → clock_timestamp → A2(1919,1) → PRECIO U` | `MAX(idPrecio/idAuditoriaPrecio)+1`; requiere reloj posterior a esperas para Parte A UC07; C3-04 solo R/P |
| UC-29 CobroManualService.registrarCobro | `A1(2929001) → CLIENTE U → [PEDIDO S] → inserts COBRO/CUENTA/CAJA → UC15` | `MAX(idCobro/idMovimientoCuenta/idMovimientoCaja)+1`, ordinal por Cliente; C3-08 inversión CLIENTE/PEDIDO |
| UC-29 CobroManualService.anularCobroManual | `A1(2929001) → COBRO U → CLIENTE U → fn_mr3_anular_cobro_manual` | **Inversión COBRO/CLIENTE**; firma sin clave de anulación, no protege D7-A ante rendiciones futuras; adenda D1 pendiente de implementación |
| UC-15/16 y política comercial | Evaluador `CLIENTE U → POLITICA S`; configuración `A1(5715001) → POLITICA U`; aplicar ajuste `CLIENTE U → POLITICA S` | FIFO global actual no conoce IMP-B vinculante; bloqueo de políticas y cálculo histórico exige pruebas |
| Clientes UC-31/32/38 | Gestión `A1(3202001)`, `CLIENTE U`, DML/Historial y revocación de sesión online en cambios | `MAX(idCliente)+1`, `MAX(numeroCambio)+1`; auditar orden con UC-03/05/29 |
| Productos UC-30/47/48 | Gestión `A1(3030047)`, `PRODUCTO U`, DML | `MAX(idProducto)+1`; comparte PRODUCTO con Precio/Receta/Stock |
| Insumos UC-20/24/39 | Gestión `A1(5051052)`, `INSUMO U`, DML | `MAX(idInsumo)+1`; conflicto con UC28/stock y controles de Unidad |
| ConfigurarReceta UC-09 | `A2(808,0) → PRODUCTO U → INSUMO S → VERSION_RECETA U` | `MAX(idReceta)+1`, versión por Receta; contrastar UC28 PEDIDO→(808,0) |
| UC-08/42 ingreso/ajuste de Insumo | `A2(808,0) → A1(idInsumo) → INSUMO U` (+ Partida/Orden) | `MAX(idRecepcion/idMovimientoInsumo/idPartida)+1`, ordinal Insumo; lectura V3 secuencia propia |
| UC-08 ingreso Reventa | `A2(808,0) → A1(idProducto) → PRODUCTO U → PROVEEDOR U` | `MAX(idRecepcion/idMovimientoStock)+1`, ordinal Producto; ámbito A1 ambiguo |
| Ajustes Inventario | `A2(808,0) → A1(idElemento) → INSUMO U` o Partida; stock histórico | `MAX(idMovimientoInsumo/idPartida)+1`, trigger V3; mapear tipo de elemento y alcance |
| Faltantes/reposición | `EpisodioFaltanteService` participa en TX MANDATORY, UPDATE/INSERT `EPISODIO_FALTANTE` | `MAX(idEpisodio)+1`; triggers de primera ronda y cierre pueden bloquear EPISODIO e INSUMO |
| Acceso/usuarios | Crear/rol/estado/restablecimiento: `A1(9172001)` y, en varios, `A2(60505,7)` + USUARIO U; sesiones usan USUARIO/SESION U | `MAX(idUsuario/idEventoRol)+1`; funciones/triggers diferidos de roles adquieren `A2(60505,7)`; revocación modifica SESION_USUARIO |
| Consultas (Libro Diario, búsqueda, etc.) | Read-only en servicios examinados; web delega en servicios | No tratarlas como escritores salvo DML real identificado por preflight |

**Fronteras NO implementadas en app main:** UC-05, UC-07 y cierre de rendición T1/K2; también falta el registro IMP-B/PE-1/PE-2 completo. **PR app #91 DRAFT** agrega escritor `RegistrarMovimientoCajaService` para UC22 y `ProtocoloIdentificadoresFinancieros`, llevando `MAX(idMovimientoCaja)+1` a un colaborador protegido por `A1(2929001)`; **NO está integrado**, por lo que es obligación del preflight G-FIS comparar `main` real vs esa PR, nunca asumir la refactorización ejecutada. PR app #92 R09-PRE es documentación, no implementación.

**Clasificación de riesgos concretos:** (a) colisión involuntaria de A1 para Cliente/Insumo/Producto con IDs iguales, (b) inversión COBRO→CLIENTE en anulación, (c) inversión PEDIDO/CLIENTE y ASIGNACIÓN/PEDIDO demostradas en R/P, (d) ID global `MAX+1` entre escritores distintos no coordinados, (e) posible bloqueo de FK/key-share tardío, (f) escrituras SQL diferidas al COMMIT, (g) UC28↔UC07/41 y R09↔UC22 sin prueba final. Estos riesgos **no** equivalen a afirmar que hubo fallos de producción.

## 3. Inventario físico de funciones/triggers de V1–V3

**Conteo de declaraciones SQL en archivos versionados:** `V1`: **36** CREATE TRIGGER (incluidos CONSTRAINT TRIGGER), **28 definiciones** de FUNCTION que representan **23 nombres únicos** (ciertas funciones MR3 son redefinidas por MR5). `V2`: **1 trigger y 1 función** (`fn_f01_transicion_cobro`). `V3`: **1 trigger y 1 función** (`fn_actualizar_cantidad_disponible`) y **1 SEQUENCE `seq_partida_insumo`**. **Total textual: 38 triggers, 25 funciones distintas y 1 secuencia; no es inventario runtime.**

### 3.1. Funciones/triggers que impactan directamente el grafo financiero/identidades

| Grupo SQL real | Activación / efecto | Riesgo para T1/K2 y acción de arquitectura |
|---|---|---|
| `fn_mr3_anular_cobro_manual` | COBRO `FOR UPDATE`, CLIENTE `FOR UPDATE`; inserta `MOVIMIENTO_CUENTA` + `ORIGEN` + `MOVIMIENTO_CAJA`, actualiza COBRO | El orden `COBRO→CLIENTE` contradice el objetivo financiero; requerirá propuesta de evolución funcional D1 + cambio SQL autorizado, y test de replay/concurrencia |
| `fn_mr3_verificar_contraasiento` con `ct_mr3_cobro_anulado/caja_anulacion/origen_anulacion` | **3 constraint triggers diferidos al COMMIT**, reconsultan COBRO y contrapartidas | Incluir efectos y locks de COMMIT en grafo; una transacción no se considera segura hasta completar restricciones diferidas |
| `fn_mr5_bloquear_mutacion_asiento` con triggers en CUENTA/ORIGEN/CAJA | Prohíbe UPDATE/DELETE de asientos | IMP-B debe ser append-only; K2 no se implementa actualizando asientos históricos |
| `fn_mr5_guardar_cobro`, `fn_f01_transicion_cobro` | Cobro inmutable salvo transición autorizada; en V2 estados CONFIRMADO/ANULADO | D7-A se debe validar en Java **y** función/trigger SQL, sin tercer estado de Cobro |
| `fn_mr5_validar_reembolso_financiero` con 3 `ct_mr5_reembolso_*` | Restricciones diferidas; consulta REEMBOLSO/COBRO/CUENTA/CAJA | Evaluar intercalación cierre T1 ↔ reembolso; no suponer que trigger deferrable no toma locks |
| `fn_mr5_validar_invariantes_usuarios` con 3 `ct_mr5_*roles/proveedor` | Diferido; ejecuta `pg_advisory_xact_lock(60505,7)`, inspecciona USUARIO/ROLES/PROVEEDOR | Efecto de cierre de transacción sobre namespaces y control de sesiones; conservar RBAC |
| `fn_mr5_revocar_sesiones_usuario/roles` con 3 triggers | Modifica SESION_USUARIO por deshabilitación/cambio de roles | Revocación concurrente con autenticación/rendición: revalidar ADMIN después de esperas |
| `fn_actualizar_cantidad_disponible` (`tg_detalle_movimiento_partida_actualiza_disponible`) | V3 AFTER INSERT/UPDATE/DELETE DETALLE_MOVIMIENTO_PARTIDA; UPDATE PARTIDA_INSUMO | Integra escritor indirecto de stock en UC28, UC08/42 y futuras interacciones |
| `fn_mr5_validar_primera_ronda/cierre_episodio` | Faltantes: cierra/valida EPISODIO; lee/lockea INSUMO | Cruce indirecto inventario/compra, no omitir del inventario final |
| `fn_mr3_validar_pedido_nuevo` y `fn_mr3_validar_producto_detalle_nuevo` | Verifica elegibilidad de CLIENTE/PRODUCTO en inserción, redefine semántica ante UPDATE en MR5 | Locks FK/trigger y cambios de estado de producto/cliente pueden interferir en Pedido |
| `fn_mr5_validar_apertura_insumo` + protección de costo `fn_mr5_proteger_costo_usado` | Garantizan evidencia y protección histórica de inventario | No romper invariantes por reordenar locks de preparación/stock |

**Otros triggers existentes revisados por categoría:** promoción, plazo/unidad, cotización, invitación/orden/solicitud de compra, primera ronda, reembolso terminal, evento de resultado aplicable. El inventario completo de 38 nombres se obtiene de V1–V3; no se elimina ni sustituye ninguno en este ADR. Deben inventariarse también **FKs e índices de bloqueo efectivo** de cada nueva migración y los ejecutores SQL externos antes de certificar C3.

## 4. Recomendación A2-GLOBAL: namespaces, orden y transición

**Alternativas evaluadas:** A1 conservar exclusivamente `A1(2929001)` + orden local (menor diff pero contención global e insuficiente ante escritores fuera del guard); A2 namespaces por recurso y precedencia común con compatibilidad temporal. **DECISIÓN TÉCNICA RECOMENDADA: A2.** No aprobar lock IDs físicos.

**Protocolo candidato obligatorio para futuro diseño SQL/Java:**
1. **Registro único de dominios** para `A2(int,int)` (Finanzas/Cliente, Recorrido, Pedido, Insumo, Producto, Secuencias, Oferta) con key derivation documentada, unicidad y ausencia de colisión entre dominios. Prohibir nuevos `A1(idEntidad)` sin tipo de recurso. Claves asesoras `A1(bigint)` y `A2(int,int)` pertenecen a espacios distintos; documentar la distinción y no mezclar namespaces involuntariamente.
2. **Puente explícito hacia escritores legacy:** mientras `CobroManualService`, la función SQL y UC22 mantengan `A1(2929001)`, **todo escritor financiero nuevo compatible debe adquirir ese guard primero**, antes de bloqueos de Cliente/Cobro/Pedido implicados, hasta que todos se adapten bajo puerta de código autorizada. No crear un ciclo al adquirir el guard legacy después de locks nuevos. La migración del guard solo podrá retirar `2929001` cuando toda ruta financiera y su CI acrediten reemplazo.
3. Dentro del cierre T1, adquirir **IDs de Cliente en orden ascendente**, después **Pedidos/Entregas** en orden estable, y conservar para UC43 el orden `PEDIDO → ASIGNACION_REPARTO`. En el escritor de anulación, corregir por CR el caso `COBRO→CLIENTE` y armonizarlo con el orden global (incluida consulta inicial de idCliente sin lock de escritura y revalidación bajo lock). No introducir `COBRO` antes de `CLIENTE` en una ruta que compita con K2. Restringir escrituras a recursos del ámbito autorizado.
4. Los **locks de Recorrido/cierre**, IMP-B por tramo y globales de generador deben ubicarse en una precedencia común antes de ejecutar DML. **El orden exacto Recorrido vs guard financiero y FKs tardías permanece como problema de verificación física**; proponer rango documentado que todos los writers adopten. No afirmar ciclo resuelto solo con Clientes ascendentes.
5. Las rutas de `UC28`, `UC19`, `UC03`, `UC43` y stock tienen precedencias actuales diferentes (`PEDIDO→A2(808,0)`, `PRODUCTO→A2(1919,1)`, etc.). **No se las declara compatibles automáticamente.** Todo cambio de namespace/orden debe preservarlas mediante adaptación coordinada de servicios/funciones y suite de intercalados, en lugar de un segundo advisory que se tome demasiado tarde.
6. **Reintentos:** una transacción abortada por `40P01` no continúa; los retries son transacciones nuevas con rollback, autorización y huella revalidadas, no doble COMMIT. La idempotencia de C1-a protege ACK perdido, conflictos y recibo histórico.

**Condición necesaria pero no suficiente para G-FIS:** grafo dirigido de todos los escritores relevantes con edges, locks de FK y triggers; buscar ciclos (incluida adquisición multi-Cliente) y testear C3 con barrearas reproducibles. `40P01` reproducido en prototipo no es falla del código final aún inexistente. El salto A2 implica **cambios futuros sujetos a G-DEV**; esta recomendación no los ejecuta.

## 5. Recomendación B2-HÍBRIDA: generadores globales/ordinales

**Alternativas:** B1 `MAX+1` global con advisory cooperativo (hoy varios servicios lo aplican, pero toda ruta nueva debe adherir; propenso a `23505` si un escritor no coopera); B2 identificadores técnicos por generador PostgreSQL versionado, ordinales de negocio bajo agregado.

**DECISIÓN TÉCNICA RECOMENDADA: B2-HÍBRIDA.**

- PKs globales nuevas o afectadas por T1/PE-1/PE-2/IMP-B/Cobro/Cuenta/Caja: **proponer secuencias/IDENTITY compatibles con BIGINT actual** en nueva migración aprobada; **no reescribir ni ejecutar V1–V3**. En esquema actual el ejemplo precedente es V3 `seq_partida_insumo`, no una solución global certificada.
- Si las tablas contienen IDs anteriores, el preflight debe comprobar `MAX(id)`, nulos, duplicados, valores negativos y seed de generador **más alto que el máximo válido** bajo exclusión mutua. `nextval` no se revierte con rollback: **permitir huecos técnicos en PK**; esto **NO** autoriza huecos en ordinales de negocio si sus invariantes exigen consecutividad.
- `numeroSecuenciaCliente`, `numeroAsignacion`, `numeroVersion`, `numeroSecuenciaInsumo` y equivalentes deben conservar su orden/UNIQUE y ser calculados bajo bloqueo del agregado pertinente o solución equivalente autorizada y probada. No usar secuencia global como reemplazo silencioso de su semántica.
- El puente con `MAX+1` legacy debe quedar formalmente protegido durante transición (por ejemplo guard coherente y actualización coordinada de escritores) para no asignar IDs superpuestos; no basta con agregar una secuencia a una tabla si servicios existentes siguen leyendo MAX+1 sin coordinación.
- **No derivar IDs Cobro K2** de la misma UUID de cierre; derivar identidad duradera por cierre/Cliente bajo un contrato de huella versionada y UNIQUE; un Cobro no absorbe dos Clientes, no cambiar estados F01.
- **Puerta física:** elección exacta entre DEFAULT nextval/IDENTITY/UUID en cada tabla, números de secuencia, permisos BD, backfill de historiales, locking de seed y compatibilidad con funciones de anulación son trabajo de CR/G-FIS, no resultado de este ADR.

## 6. Recomendación C1-EXPLÍCITA: recorrido, cierre y aplicaciones

**Alternativas:** C2 derivar identificación de usuario+fecha o conjuntos de asignaciones en cada ejecución (identidad inestable frente a reasignación, múltiples salidas y replay); C1 entidad lógica persistente de recorrido y cierre.

**DECISIÓN TÉCNICA RECOMENDADA: C1.**

- Identidad estable de **Recorrido** distinta de Pedido, Usuario Repartidor, día de entrega y de un Cobro; pertenencia acreditada por asignación/historia y conjunto de Entregas, no por heurística temporal. **No inventar** la regla de cuándo empieza/termina un recorrido: el contrato de pertenencia debe cotejarse con RD-F04-002 y UC43 durante el preflight G-FIS.
- Entidad lógica **CierreRecorrido** con máximo **un cierre confirmado por Recorrido** (`UNIQUE` conceptual), UUID de C1-a, huella semántica y recibo histórico. La situación operativa de diferencias sin conciliar **no equivale** a un cierre confirmado y no agrega un nuevo estado COBRO. La unicidad debe resistir dos ADMIN simultáneos con claves distintas.
- **Aplicaciones**: porción positiva con referencia inequívoca a Cierre, Entrega, Cliente, Cobro y monto. **K2**: a lo sumo un Cobro REPARTO positivo por Cliente y Cierre; cada Cobro respalda 1..N aplicaciones a Entregas de **ese mismo Cliente**, suma exacta = importe, bajo mismo COMMIT ACID T1. `COBRO.idPedido` no permite reconstrucción de aplicaciones.
- **Separar recepción física/custodia** de Cobro/Caja venta; diferencias requieren resolución motivada ADMIN y, hasta entonces, estado operativo `PENDIENTE_CONCILIACION`. Sin recupero nuevo después de cierre (E confirmado), sin extinguir `V_e^{vig}` remanente automáticamente y sin segundo cierre.
- **Solo efectivo (D1):** el primer circuito PE-2 de rendición usa `EFECTIVO`; no transformar Cobro K2 en `TRANSFERENCIA/MERCADOPAGO` ni inventar un Cobro de medio mixto. Otros canales e integraciones del sistema final permanecen en roadmap I6/B6, fuera del alcance inicial de PE-2.
- **Esquema físico todavía bloqueado:** V1 tiene `ASIGNACION_REPARTO` y `ENTREGA`, **no** entidad Recorrido/Cierre persistente ni aplicación por importe. G-FIS definirá PK/FK/UNIQUE/CHECK y preflight; CR-B0-F04-001 no levantada.

## 7. S10, dependencia normativa y conjunto mínimo de PR para pedir G-FIS

### 7.1. Disposición explícita S10 — NO FALSIFICAR G-ARQ Nivel 1

**Resultado de búsqueda:** la resolución **«G-ARQ Nivel 1 aprobada»** está **reportada**, pero no se localizó **texto primario de aprobación, fecha exacta, ruta en `main` o PR fuente con SHA verificable**. Se revisaron árbol de gobierno `main`, búsqueda de PR/Issues, contenidos de PR #65–#71, PR #66 (acta/anexo y comentario del responsable) y referencias cruzadas. La PR #66 conserva el estado **REPORTADO / PENDIENTE DE RESPALDO ORIGINAL**. No existe evidencia suficiente para afirmar aprobación histórica verificable.

**Acotación, sin otro subcorte:** este ADR declara `S10 = LIMITACIÓN DE PROCEDENCIA / N1 NO ACREDITADO`. Presenta **autónomamente** la justificación A/B/C de Nivel 2 y conserva la incertidumbre histórica. La revisión del responsable sobre **este mismo ADR** podrá aprobar su alcance actual **sin certificar retrospectivamente Nivel 1**. En la solicitud G-FIS deberá constar la salvedad y la autoridad de gate decidir expresamente si acepta la documentación N2 autosuficiente como base suficiente o exige primero prueba original de N1. **No se declara S10 levantada** por silencio, ni se tramita una «ratificación retroactiva» ficticia. Si G-FIS exige N1 formal, queda **NO-GO** hasta evidencia/decisión específica, que puede registrarse en el mismo hilo del gate sin abrir un nuevo subcorte documental.

### 7.2. Mínimo documental para solicitar G-FIS (no equivalente a permiso de V4)

**Mínimo prudente de incorporación a gobierno/main, por función y dependencia:**

| PR | Papel para G-FIS | Condición / estado actual | ¿Necesaria en cadena mínima? |
|---|---|---|---|
| **#65** — G-CON E01..E10 | Adendas de contratos REV04B/REV05/REV06B, IMP, CUENTA, BC07, reglas para PE-1/2 | DRAFT y sin autorización editorial GC-10; además conflicto CR-F registrado, no aprobado | **SÍ** para alcance PE-1/PE-2/IMP-01 |
| **#66** — acta G-CON y anexo fuente | Evidencia A1/B1/C1-a/D1 y cronología; C2 allí figura diferida históricamente | DRAFT. Autorización documental declarada del responsable (comentario 18/11) **no es orden automática de merge** | **SÍ** |
| **#67** — PRE-05 aislamiento | Acreditación documental limitada para revisar el merge de #65 sin afectar Demo | DRAFT, autorización documental declarada para revisión, preflight distinto; la fuente describe límites de evidencia | **SÍ como prueba de PRE-05 para gate editorial #65**, no como permiso de Demo/G-FIS; su integración puede exigirse antes o junto con #65 |
| **#70** — RD ART-GCON-C2 | T1 + K2 con S01–S10, ratificación del responsable 19/11 | DRAFT, sin autorización de ejecución de merge; requiere coherencia editorial con #66 (C2 diferida históricamente) | **SÍ** |
| **#71** — G-ARQ-N2-01 | Modelo lógico y matriz R/P/D; este ADR solo agrega inventario, A/B/C y cierre técnico | DRAFT, sin permiso de integración | **SÍ** |
| **Esta PR G-ARQ-N2-02** | Elección A2/B2/C1 + S10/alcances + preflight con inventario real | DRAFT, sin merge | **SÍ, al finalizar revisión** |
| #68 — matriz R08.6 Puerta 1 | Auditoría y trazabilidad históricas, contiene fotografía anterior a C2 ratificada | DRAFT, se cita como soporte | **NO esencial** para solicitud si este ADR y #65/#70/#71 conservan las referencias |
| #69 — expediente T1 vs T2 | Justificación de alternativas previa a la ratificación | DRAFT, citada por #70 | **NO esencial**; es evidencia complementaria, no fuente de la decisión final |

**Orden conservador de preflight e integración (cada paso requiere autorización expresa de merge y checks):** #67 (PRE-05), #66 (acta histórica), #65 (adendas GC-10), #70 (C2 posterior), #71 (modelo lógico), **esta PR** (ADR cierre). No rebase, amend, force-push ni auto-merge; verificar diferencias/base porque #65 parte de SHA antiguo. Si alguna revisión detecta dependencia contradictoria, corregir **dentro de la PR pertinente** con nuevo commit, sin abrir otro subcorte documental.

**Nota:** para simplemente **presentar una solicitud G-FIS** se puede adjuntar una PR como evidencia aún no fusionada, pero **para declararla apta para autorización** se recomienda esta cadena mínima en `main` más los controles normativos; no fingir que ya se integró. La **autorización de G-FIS y del diseño físico es una votación/puerta distinta**. La fase física podría delimitarse a PE-1/PE-2/IMP-01 de **Pedidos originales**; UC-07 CR-C/#47/CR-F/#48 y H/RT-UC07-04 siguen bloqueadas y requieren su propia aprobación física y pruebas. El circuito original parcial no equivale a UC-05/I3-02 completos.

### 7.3. Solicitud G-FIS inmediatamente posterior a este ADR — SIN nuevos subcortes documentales

Una vez emitidos el dictamen de revisión de este ADR, comprobación de SHA/diff/checks y las autorizaciones editoriales que correspondan, usar **esta misma PR y sus referencias** como expediente para solicitar **G-FIS / CR-B0-F04-001**. La solicitud deberá especificar:
- **Ámbito:** fase física PE-1, PE-2, IMP-B canónico/IMP-A derivada/IMP-C contención, identidad de recorrido/cierre, aplicaciones K2 y custodia, compatibilidad F01 y guard D7-A; **sin UC-07 físico hasta CR-F/H**.
- **Preflight obligatorio:** base de destino, datos históricos, cinco señales RCG-06, cardinalidad, restricciones preexistentes, coherencia de precios/stock, FX de `COBRO`, revisión de permisos BD y dependencias con PR app #91; sin backfill heurístico de `COBRO.idPedido`.
- **C3/seguridad:** proponer nuevos tests PostgreSQL/Testcontainers (C3-01..08, dos ADMIN, multi-Cliente, `23505` IDs, `40P01` reintentos, funciones/constraints triggers al COMMIT, D7-A, D1, custodia, rollback/ACK, RBAC/BC07). No declarar test funcional pasado por checks de documentación.
- **Paso autorizado solo después de G-FIS:** proponer nueva migración (no editar V1–V3) y pruebas de SQL en laboratorio efímero aislado; aplicación `src/**` requiere **G-DEV/R09** posterior, y despliegue Issue #28 sigue pausado.

## 8. Dictamen de revisión, criterios de aceptación y próximos pasos

| Criterio G-ARQ-N2-02 | Resultado |
|---|---|
| D1 solo efectivo y E sin recupero post-cierre | **CONFIRMADOS por responsable en este corte**, no nuevas reglas |
| A locks namespaces + compatibilidad legacy | **A2 seleccionado como recomendación técnica**, pendiente de prueba de grafo global |
| B global IDs y ordinales de negocio | **B2-HÍBRIDO seleccionado como recomendación técnica**, pendiente de definición física/pruebas |
| C identidad de Recorrido/Cierre | **C1-EXPLÍCITO seleccionado como recomendación técnica**, sin inventar identificación por fecha |
| Inventario faltante | **Ampliado** a escritores principales, funciones y triggers V1–V3; no se declara certificado el runtime |
| S10 G-ARQ N1 | **NO ACREDITADO; acotado explícitamente como salvedad histórica** |
| Conjunto mínimo de integración #65–#71 | **#65/#66/#67/#70/#71 + esta PR**; #68/#69 soporte no esencial |
| Cumplimiento roadmap | R08.6 → solicitud G-FIS → R09.1–R09.5 (con puertas), no más Demo; B5/B8 del sistema final permanecen |
| Pruebas físicas nuevas y CI | **NO ejecutadas**; ningún resultado declarado de este ADR |
| Estado final de la arquitectura | **Recomendación técnica terminada, pendiente de revisión/ratificación editorial; G-FIS NO autorizado** |

**Criterio de salida hacia solicitud G-FIS:** verificar el preflight de PR/editorial y registrar el dictamen técnico. El **gate G-FIS** decidirá si puede autorizar un diseño/migración física bajo las salvedades, no este ADR. Este corte **NO** autoriza por sí mismo merges, DDL, `V4`, `src/**`, CI para migración futura, cambios en apps, Demo, configuración, secretos, infraestructura, despliegue ni cambios G0/source-lock.

## 9. Referencias directas y método de evidencia

1. Plan Rector `docs/01-gobierno/PLAN_RECTOR_IMPLEMENTACION_2026-10-29.md`; Roadmap Operativo `docs/01-gobierno/ROADMAP_OPERATIVO_I3_I7_2026-11-15.md`; G0.
2. RD-F04-002 / RD-F04-005; ACT-G-COM-001 RCG-01..08; resolución C2 [PR #70](https://github.com/leandrito369/ale-milanesas/pull/70).
3. Contratos y acta: [PR #65](https://github.com/leandrito369/ale-milanesas/pull/65), [PR #66](https://github.com/leandrito369/ale-milanesas/pull/66), PRE-05 [PR #67](https://github.com/leandrito369/ale-milanesas/pull/67).
4. Antecedentes de análisis: [PR #68](https://github.com/leandrito369/ale-milanesas/pull/68), [PR #69](https://github.com/leandrito369/ale-milanesas/pull/69), [PR #71](https://github.com/leandrito369/ale-milanesas/pull/71). No se duplican en este ADR.
5. App `main@f5c9af3f76723d5364d44647cfd43ea13a9fd7b5`: `src/main/java/ar/edu/unam/alemilanesas/{abastecimiento,acceso,finanzas,maestros,produccioninventario,ventas}` servicios de negocio auditados; `src/main/resources/db/migration/V1__baseline_mr5.sql`, `V2__f01_cobro_estados.sql`, `V3__trazabilidad_partidas_insumo.sql`.
6. C3 antecedentes [app PR #89](https://github.com/leandrito369/ale-milanesas-app/pull/89), `docs/implementation/C3_A3_NIVEL_RP_2026-11-15.md`; escritor financiero adicional **NO integrado** [app PR #91](https://github.com/leandrito369/ale-milanesas-app/pull/91); plan R09 [app PR #92](https://github.com/leandrito369/ale-milanesas-app/pull/92).
7. No se accedió a bases persistentes, Demo, credenciales, APIs externas, ni se ejecutaron compilaciones o pruebas nuevas; todo resultado SQL descrito como verificado procede de fuente de migración, no del servidor en vivo.
