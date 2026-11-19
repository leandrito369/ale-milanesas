# G-ARQ-N2-01 — Arquitectura lógica T1-C2 + K2 y matriz de locks (R08.6)

**Proyecto:** Sistema de Gestión para Ale Milanesas.  
**Fecha local del corte:** 18/11/2026 (Argentina; mensaje fuente posterior al cambio UTC de 19/11).  
**Estado:** PROPUESTA DE DISEÑO CONCEPTUAL, en PR DRAFT independiente. **NO certifica aciclicidad global, diseño físico ni G-ARQ Nivel 2 aprobado.**  
**Autoridad:** el responsable ratificó por declaración **ART-GCON-C2 = T1-C2 + K2, con S01–S10**, mensaje `2026-11-19T02:49:39Z`, registrado en gobierno PR #70 HEAD `9f3a2fbed6d34d2efa5f07f4bae2bcdf1629704f`. PR #70 permanece **DRAFT / NO MERGE**, la ratificación conceptual no autoriza implementación.  
**Directiva operativa posterior:** el responsable solicitó `G-ARQ-N2-01` y dispuso **no incorporar más bloques a la Demo**: concentrar siguientes cortes en **finalizar el sistema** respetando **obligatoriamente** el Plan Rector. Mensaje `2026-11-19T02:56:40Z`. No equivale a eliminar interfaces o E2E requeridos para el sistema final ni a un recorte unilateral de 64 CU / 67 operaciones.

**Refs de lectura (no cambiar):** gobierno `leandrito369/ale-milanesas/main@9076570ff3329864fe85c990bcc6f4ff7a63d6e5`; app `leandrito369/ale-milanesas-app/main@f5c9af3f76723d5364d44647cfd43ea13a9fd7b5`; gobierno PR #70 HEAD `9f3a2fbe`; PR #69 HEAD `012b9613`; PR #68 HEAD `c7e1b14d`; app C3-A.3 PR #89 HEAD `642abd65`; app R09-PRE PR #92 HEAD `5c762bc1`.  
**Source-lock G0 invariable:** `source_commit=1263ffc17bd0eb7f3c69faaa9ff5ae556cf9de7e`; `governance_commit=27738b089afdd2698cdae915f75c0e8089a6248a`.  
**Alcance ejecutado:** cotejo estático de contratos, documentación experimental y fuente Java/SQL existente. **NO se ejecutaron** pruebas nuevas, PostgreSQL, Testcontainers, Maven, migraciones, E2E ni acciones de negocio.

## 1. Inserción obligatoria en el Plan Rector y límite de Demo

- **Autoridad de planificación:** `PLAN_RECTOR_IMPLEMENTACION_2026-10-29.md` (ADOPTADO) y `ROADMAP_OPERATIVO_I3_I7_2026-11-15.md` (seguimiento adoptado). Entregar el sistema final por recorridos verticales, no una sucesión de funcionalidades ad hoc de Demo.
- **Corte actual:** R08.6, preparación de arquitectura/persistencia de I3-02 (Entrega UC-05, Excedentes UC-07) e I3-03 (Cuenta/Cobro/Caja UC-14/29/22/23). Desbloquea diseño de R09.1 (PE-1/PE-2/IMP-01), R09.2 (Entrega online) y R09.3 (Cuenta/Rendición), **solo después de puertas propias**. R09.4 integra UC-07/UC-06 y R09.5 regresión/aceptación; no saltarlos.
- **Directiva de focalización:** **no agregar pantallas, endpoints, fixtures, flags, integraciones ni despliegues a la Demo I1/I2 existente** para demostrar nuevos cortes. No ejecutar pruebas en esa Demo. Probar la implementación del sistema final en CI y laboratorio aislado **cuando el gate correspondiente lo autorice**. B5 (web final y Android), B6, B7, B8, B10 e hitos H3/H4/H5 siguen vigentes; no transformar esta restricción de Demo en eliminación de alcance del sistema.
- **Despliegue productivo:** sigue PAUSADO (app Issue #28); no se modifica ni se levanta esa restricción.
- **Definición de terminado:** una decisión ratificada ≠ un contrato integrado ≠ un servicio codificado ≠ prueba ejecutada ≠ aceptación. El objetivo académico del 12/12/2026 es una **meta del roadmap**, no evidencia de que se cumplirán los hitos ni licencia para omitir gates.

## 2. Fronteras normativas y restricciones no negociables

| ID | Autoridad | Consecuencia obligatoria en G-ARQ |
|---|---|---|
| N-01 | ART-GCON-C1-a, PR #66 | Cierre **único** por recorrido, UUID `claveIdempotenciaCierre`, huella canónica versionada, replay histórico idempotente; misma clave con payload distinto 409; clave distinta sobre recorrido cerrado `RECORRIDO_YA_CERRADO`. Revalidación ADMIN y ámbito incluso en replay. |
| N-02 | **ART-GCON-C2 ratificada en PR #70** | Primer online **T1-C2**: una frontera ACID para todos los efectos **financieros definitivos** del cierre. **K2**: a lo sumo un Cobro `REPARTO` por Cliente y cierre con importe positivo, relacionado con 1..N aplicaciones a Entregas del mismo Cliente. `T2-C2` COMMIT financiero por etapa no autorizado. S01–S10 obligatorias. |
| N-03 | RD-F04-002 / RD-F04-005 | Ante diferencias sin resolver, rendición **PENDIENTE DE CONCILIACIÓN**, sin recibo de cierre definitivo; solo ADMIN puede resolver motivadamente. Faltante no produce Cobro/Caja, ni restitución automática de deuda exigible; no inventar proceso de recupero/contraaplicación. |
| N-04 | ACT-G-COM-001 RCG-01/03 | `IMP-B` inmutable canónico; `K_e=P_e^{exp}+F_e^{FIFO}` disjuntos; `E_e=max(0,C_e-K_e)`; `V_e^0=min(D_e,E_e)`. `D_e` intacto, aplicación financiera única y cese equivalente de `V_e^{vig}`. Faltantes y diferencias `Q` tipados/no aditivos. |
| N-05 | ACT-G-COM-001 RCG-04 | `COBRO.origen='REPARTO'`, registrador ADMIN; 1 Cliente por Cobro; FK/vínculos verificables a cierre y aplicaciones; custodia sin segundo ingreso; arqueo efectivo en tres vistas; proyección contextual BC-07. UC-14 sigue exclusivamente VENDEDOR. |
| N-06 | ACT-G-COM-001 RCG-05/06/07 | Huella completa y recibo histórico, incluso tras mutaciones permitidas; `COBRO.idPedido` contextual NO acredita imputación; preflight financiero por destino; no introducir `409 CLIENTE_CON_DEUDA` sin RD, `PE-3` offline diferida. |
| N-07 | ART-GCON-A1/B1/D1, PR #66 | Evidencia diagnóstica post-rollback separada, cobertura insuficiente `422 COBERTURA_NO_ACREDITADA` sin confirmación y diferencia con `40P01`; anulación con clave propia/IDs de contraasientos por futura adenda. D7-A veta anular Cobro de rendición. |
| N-08 | RCG-02, UC-07 CR-C/#47 y CR-F/#48 | Prohibido simular adicional aceptado mediante `DETALLE_PEDIDO(cantidadOriginal=0)`; mantener V1 y trigger intactos. Mientras extras aceptados no se soporten, UC-05 debe rechazarlos atómicamente con 409 contractual por precisar. |
| N-09 | G0 y CR-B0-F04-001 | No alteración de 64 CU/67 operaciones, RBAC 67×8, BC-07 base y source-lock. Diseño físico, CR-F04, V4, G-FIS/G-DEV, API, CI de nuevas migraciones y despliegue requieren autorización separada. |

**Alerta de fuente:** PR #65 E-01..E-10, PR #66 archivo contractual, PR #68 conciliación y PR #70 RD están propuestas o ratificadas declarativamente, pero no integradas automáticamente en `main`. Esta arquitectura respeta sus decisiones expresas sin falsificar publicación editorial ni G-ARQ Nivel 1 (original/SHA todavía NO acreditados).

## 3. Arquitectura lógica y responsabilidades (NO clases/DDL obligatorios)

### 3.1. Contextos y puertos candidatos

```text
                 UC-05 / Entrega validada y auditada
                              |
              Captura D_e íntegra; cálculo C_e/K_e/V_e^0
                              |
      [PE-1 / reconocimiento provisional] ↔ [IMP-B: eventos canónicos]
                              |                         |
             Lectura V_e^vig por Entrega     [IMP-A: proyección derivada]
                              |                         |
 ADMIN → [UC-29 / Caso de uso CierreRendicion] ← [Autorización + BC-07]
                |  (validación de cobertura y atribución)
                v
        [Coordinador transaccional T1-C2]
          ├─ Cierre/huella/recibo histórico por recorrido
          ├─ Aplicaciones (Cliente, Entrega, porción, Cobro)
          ├─ CobroREPARTO por Cliente (K2; no multicliente)
          ├─ PAGO Cuenta / Ingreso Caja de venta una vez
          ├─ Extinción equivalente del tránsito V_e^vig
          ├─ Diferencias, evidencia y custodia segregada
          └─ Reevaluación/consulta segura: UC-15 y BC-07
                        |
                  COMMIT único
                        |
            Recibo de Cierre o reintento histórico
```

**Puertos lógicos — sin crear API G0:**
1. **AutorizadorContextual**: sesión/rol ADMIN y ámbito de recorrido, repartidor, Entregas y Clientes; no concede UC-14 a ADMIN ni rendición a REPARTIDOR.
2. **ConsultaSnapshotFinanciero**: obtiene `C_e/K_e/D_e/V_e^0/V_e^{vig}` desde evidencia y eventos; ninguna inferencia desde `COBRO.idPedido` o FIFO retrospectivo. Versión/coherencia revalidada bajo serialización.
3. **PlanificadorCierre**: lista de aplicaciones positivas por Entrega/Cliente, efectivo contado/recibido, motivo de diferencias, origen de custodia y huella completa; preparación puede ser persistida sin asientos **solo bajo diseño futuro**, nunca COMMIT financiero por etapa.
4. **CoordinadorT1**: bajo **una** transacción de BD, decide idempotencia y resultado, valida cobertura, confirma por Cliente, conserva remanentes y materializa el recibo.
5. **EscritorAplicaciones/IMP-B**: registra atribución y cese de `V_e^{vig}` conservando historia; proyección IMP-A nunca sustituye el libro IMP-B.
6. **EscritorCobroREPARTO**: un Cobro por Cliente/cierre con importe >0, para ese mismo Cliente; PAGO/Caja de venta exactamente una vez, consistente con movimientos MR5/F01.
7. **RegistroCustodia/Diferencias**: traza dinero físicamente recibido no atribuible, faltantes constatados, diferencias pendientes y resolución del ADMIN **sin segundo ingreso de ventas**. Una recepción física previa al cierre y en estado pendiente requiere clasificación/documentación operativa, no Cobro anticipado.
8. **GeneradorIdentidades**: identidad del cierre separada de claves de Cobro, idempotencias por ámbito y generadores de ID global/por Cliente; no reutilizar UUID idéntico para dos Cobros.
9. **ProyectorLectura**: tres vistas de arqueo, cierre contextual ADMIN y UC-14 exclusiva de VENDEDOR, sin revelar Clientes/Entregas ajenos.

**No se autoriza** crear estos nombres como clases, servicios HTTP, entidades o tablas. Son responsabilidades del diseño para evaluar en ADR/DS.

### 3.2. Relaciones y multiplicidad K2 (conceptuales)

| Entidad conceptual | Relación / límite | Clave de negocio y restricción |
|---|---|---|
| Recorrido → cierre financiero | `0..1` cierre **confirmado** por identidad de recorrido; situación PENDIENTE es operativa, no un cierre confirmado | `claveIdempotenciaCierre: UUID` y huella versionada; dos ADMIN no cierran dos veces |
| Cierre → CobrosREPARTO | `0..N`; **0..1 por Cliente** con importe positivo por cierre | Nunca mezclar clientes; uno de muchos Cobros puede respaldar varias Entregas de **ese Cliente** |
| CobroREPARTO → Aplicación | `1..N` aplicaciones de importe positivo; **cada aplicación → 1 Cobro y 1 Entrega** | `importeCobro = Σ importeAplicación`; `idCliente(Cobro)=idCliente(Entrega)` |
| Entrega → Aplicaciones | `0..N` en el historial financiero, limitado por `V_e^0` y las restricciones de recorrido | `Σ A_e <= V_e^0` sin contraaplicación `D7-B`, que sigue diferida |
| Cliente → Cuenta/Caja | Movimientos definitivos compatibles con Cobro por Cliente, sin segundo PAGO de anticipo | Un Cobro `REPARTO` produce una sola representación contable de su importe, y un único ingreso de Caja de venta del medio efectivamente recibido cuando aplique |
| Recorrido → custodia/diferencia | `0..N` eventos tipados y auditables, incluso sin aplicación positiva | Custodia **no equivale** a Cobro de venta; tres vistas, evidencia y motivo |
| Recorrido → Entregas | Una agrupación lógica y pertenencia demostrable, idempotente y con Repartidor contextual | **No existe una tabla `RECORRIDO` en V1 examinado**: identidad, vínculo y políticas de pertenencia quedan para diseño físico |

**Límites K2 que NO se deben improvisar:** el esquema existente asigna **un solo `medioPago` por Cobro**. Si un mismo Cliente entrega dinero por dos medios en un recorrido, **K2 de un Cobro por Cliente/cierre no representa directamente ambos medios** sin elegir otra política. No dividirlo automáticamente en dos Cobros ni falsear `medioPago`: **[DECISIÓN/CONTRATO A RESOLVER]** para casos multimedio (p. ej., restringir al efectivo del recorrido si eso respeta alcance aprobado, o promover una RD delimitada; sin supuestos). También queda por definir identidad física del recorrido, caso de cierre con cero aplicaciones, y regularización posterior de `V_e^{vig}` remanente después de cierre único sin segunda clausura.

### 3.3. Conservación monetaria y estados de conciliación

Por Entrega `e`, `0 <= A_e(t) <= V_e^0`; mientras `D7-B` esté diferida, `V_e^{vig}(t) = V_e^0 - A_e(t)`. Se mantiene `saldoExigibleProvisional = saldoConfirmado - Σ V_e^{vig}` (por Cliente). Por cada Cobro K2, `Σ aplicaciones = importe confirmado`, sin reimputar anticipos `P_e^{exp}/F_e^{FIFO}`. El comprobante de `D_e` original no se modifica.

**Diferencia no resuelta:** `PENDIENTE DE CONCILIACIÓN` como estado **operativo de rendición**, jamás nuevo `COBRO.estadoCobro`. **No** producir «recibo de cierre» ni reconocer importes que no fueron recibidos. La evidencia del dinero físicamente recibido mientras está pendiente no debe convertirse silenciosamente en Cobro/Caja de venta. Solo ADMIN puede **resolver con motivo**; si corresponde entonces confirmar **una única transacción T1**. El tratamiento posterior de faltantes y tránsito no se inventa en este documento.

**Caso sin diferencia y sin aplicaciones positivas:** no crear `COBRO(importe=0)`; confirmar el cierre automáticamente sería una regla no acreditada. Definir contrato/condición de cierre y recibo antes de G-FIS.

## 4. Máquina conceptual de cierre e idempotencia

```text
SIN_CIERRE
    ├─ evidencia incompleta / IMP-C / 422 --> SIN_CIERRE (sin efectos)
    ├─ diferencias --> PENDIENTE_CONCILIACION (operativa; sin cierre confirmado)
    │                      └─ resolución motivada ADMIN --> CANDIDATO_CONFIRMACION
    └─ caso sin diferencias --> CANDIDATO_CONFIRMACION

CANDIDATO_CONFIRMACION
    ├─ conflicto UUID/huella --> 409 (sin efectos)
    ├─ cierre anterior con otra UUID --> RECORRIDO_YA_CERRADO
    ├─ validación financiera fallida --> ROLLBACK (sin Cobro/PAGO/Caja nuevos)
    └─ COMMIT ACID T1 --> CERRADO_CONFIRMADO + RECIBO_HISTORICO

CERRADO_CONFIRMADO
    ├─ replay UUID/huella idénticos + autorización --> mismo recibo histórico
    ├─ UUID idéntica / huella diferente --> 409 sin efectos
    └─ otra UUID --> RECORRIDO_YA_CERRADO sin revelar recibo ajeno
```

Los estados anteriores son **etiquetas conceptuales**, no DDL ni catálogo aprobado de estados persistidos; el contrato RD-F01 restringe `COBRO.estadoCobro` a `CONFIRMADO`/`ANULADO`. No asumir segunda operación G0 para un recorrido; si la regularización posterior requiere nuevos comandos, tramitar decisión/acceso/CR. Los rechazos pre-COMMIT no consumen clave como éxito; un diagnóstico post-rollback es canal separado conforme A1 y no crea Entrega/Cobro.

## 5. Frontera T1 — secuencia conceptual para diseñar (NO SQL)

1. **Preflight sin efecto**: identificar recorrido/repartidor/Entregas/Clientes/efectivo y medio, resolver formato de intención y huella; autenticar ADMIN y ámbito. Si la información no acredita imputación, no inventar aplicaciones.
2. **Entrada transaccional:** iniciar frontera ACID y **adquirir bloqueos en un orden global aún pendiente de prueba**. La matriz §6 consigna orden parcial observado; no tratarla como receta definitiva. Resolver clave de cierre concurrente contra identidad de recorrido; revalidar ADMIN y pertenencia después de espera.
3. **Reevaluar después de bloquear:** que los Pedidos/Entregas sigan elegibles, que el recorrido no esté cerrado, que `V_e^{vig}` y eventos IMP-B estén actualizados, que nada haya sido aplicado por otro Cierre/Cliente y que no se presupongan anticipos por `COBRO.idPedido`.
4. **Resolver aceptación:** si diferencia requiere conciliación motivada, registrar su pendencia por circuito apropiado **sin confirmar cierre definitivo**. Si falta cobertura contractual, `422 COBERTURA_NO_ACREDITADA` y rollback de efectos del intento. No ocultar un `40P01` técnico como error comercial ni efectuar commit parcial.
5. **Aplicación atómica:** para las atribuciones verificadas: registrar libro/aplicaciones a Entregas; agrupación K2 por Cliente; generar un Cobro `REPARTO` por Cliente con importe positivo; movimientos `PAGO`/Caja de venta correspondientes **una sola vez**; retirar el mismo importe de `V_e^{vig}`; registrar custodia/diferencias autorizadas con fuente original; mantener FIFO y saldo comercial coherentes.
6. **Finalización:** persistir estado de cierre confirmado, clave/huella/recibo histórico junto con todos los efectos. COMMIT único. Responder después del COMMIT; si hay pérdida de ACK, recuperar el recibo histórico, no volver a pagar/contabilizar.
7. **Control de fallo:** error anterior a COMMIT -> rollback íntegro; si falla la escritura del diagnóstico después de rollback no simular éxito; tratarlo como incidencia de observabilidad. Reintento después de `40P01` exige transacción nueva y condiciones revalidadas, no replay sobre transacción abortada.

**Restricción T1:** no hacer llamadas externas a Mercado Pago/WhatsApp/OSRM dentro de la frontera ACID; su aislamiento y eventual outbox/compensación requieren diseño de B6 posterior, no asumir ACID distribuido.

## 6. Matriz de locks: hechos observados, prototipos y brechas

**Notación:** `U = FOR UPDATE`, `S = FOR SHARE`; `A1(bigint)` y `A2(int,int)` son espacios distintos en PostgreSQL, **pero los usos actuales de A1(bigint) entre entidades distintas pueden colisionar si reciben el mismo número**. Se consigna solo la secuencia identificada, sin afirmar que toda FK/trigger está inventariada. `R` = servicio real leído; `P` = prototipo C3; `D` = decisión/diseño pendiente.

| Escritor / CU | Nivel | Locks y generadores observados / candidatos | Aristas de riesgo a revisar | Estado de evidencia |
|---|---|---|---|---|
| UC-03 CargarPedido | **R** | `A2(3003,0) → A1(idCliente) → CLIENTE U → PRODUCTO S (IDs asc) → PRECIO_PRODUCTO S`; `MAX(idPedido)+1`, política/ajuste comercial UC-15/16 | Comparte CLIENTE/PRODUCTO con Cobro/Precio/UC-28; `A1(idCliente)` puede colisionar con `A1(idInsumo)` | Código main leído; no certificar grafo |
| UC-43 AsignarReparto | **R** | `A1(9172001) → A2(60505,7) → USUARIO S → PEDIDO U → ASIGNACION_REPARTO U`; `MAX(numeroAsignacion)+1` por Pedido | `ASIGNACION U → PEDIDO U` en UC-05 genera `40P01` | R/P C3-03a/b en app PR #89 |
| UC-28 RegistrarPreparacion | **R** | `PEDIDO U → DETALLE_PEDIDO U → A2(808,0) → PRODUCTO S → RECETA/VERSION S → A1(idInsumo) → INSUMO U → PARTIDA_INSUMO U`; `MAX(idPreparacion)+1`, secuencias de insumos | Potencial ciclo con UC-05/07, bloqueo de producto y cruce A1 numérico con UC-03; trigger V3 modifica partidas | Código leído; C3-05 solo D |
| UC-19 ActualizarPrecio | **R** | `PRODUCTO U → reloj DB → A2(1919,1) → PRECIO_PRODUCTO U`; `MAX(idPrecio)+1`, `MAX(idAuditoriaPrecio)+1` protegidos cooperativamente | UC-07 Parte A snapshot debe fijar reloj tras espera y orden PRODUCTO→PRECIO; falta prueba global UC-19/07 completo | R/P C3-04a/b app PR #89 |
| UC-29 Cobro manual | **R** | `A1(2929001) → CLIENTE U → [PEDIDO S] → COBRO/PAGO/Caja insert → UC-15 CLIENTE U/POLITICA S`; `MAX(idCobro/idMovCuenta/idMovCaja)+1`, secuencia Cliente | Si UC-05 bloquea PEDIDO antes de CLIENTE, produce 40P01; no asumir que `2929001` cubre otros escritores | R/P C3-08a/b app PR #89 |
| UC-29 AnularCobro | **R** | `A1(2929001) → COBRO U → CLIENTE U → fn_mr3_anular_cobro_manual → contraasientos`, con función/triggers y revalidación | Orden `COBRO→CLIENTE` frente a `CLIENTE→COBRO`; generadores/antecedentes SQL; no implementa D7-A contra vinculación de rendición | Código main + función MR5; **no probado contra T1** |
| UC-15 Evaluar categoría | **R** | `CLIENTE U → POLITICA_CATEGORIA_COMERCIAL S`; consulta Cuenta por Cliente y movimientos históricos; invocado dentro de otros servicios | FIFO global debe respetar porciones IMP-B reservadas/consumidas; lectura de tránsito segregada | Código main; adaptación futura |
| UC-05 RegistrarEntrega | **P/D** | Precedencia demostrada entre ciertos recursos: `A1(2929001) [si asiento] → CLIENTE U → PEDIDO U → ASIGNACION_REPARTO U`; luego detalles, stock, IMP-B y `V_e` | Simultáneo con UC-43, UC-29, UC-28, UC-07, UC-15, anulación y triggers; no fijar locks adicionales sin grafo | C3-03/08 prueban **solo** fragmentos P/R |
| UC-07 Oferta/Adicionales | **P/D** | Candidato heredado `CLIENTE U → PEDIDO U (IDs asc) → DETALLE U → EXCEDENTE U → PRODUCTO S → OFERTA U → COTIZACION S → EVIDENCIA U`, **a revisar** sin línea técnica ficticia | Cambios de Producto, Preparación, inventario, UC-05; H/RT-UC07-04 y CR-F §15.12 incompatibles con RCG-02 | C3-05 Nivel D; #47/#48 DRAFT |
| Cierre UC-29 T1/K2 | **D (este diseño)** | Serialización de **recorrido/cierre + varios CLIENTE, Entrega/V_e/IMP-B + Cobros/Cuenta/Caja + custodia + huella**. Primera opción: entrar por el guard financiero `2929001`, luego Clientes en orden total, luego Pedidos en orden total, etc.; **NO elegir físicamente aún** | Falta resolver cuándo tomar guard de recorrido, lock de Cobro, generadores, FK `FOR KEY SHARE` tardíos, interbloqueos con `UC-28` y `UC-43` | No ejecutado; aprobar C2 ≠ aprobar orden |
| UC-06/41/21 y otros escritores (UC-08/10/22/42, webhooks/triggers) | **D para grafo integral** | Requieren inventario específico sobre servicios/funciones actuales y propuestas; `UC-21` ONLINE implica reserva recuperable IMP-B, UC-22 Caja en app PR #91 independiente | Escrituras de Caja, Cliente, Stock, Producto, Excedente, Pedidos y fuentes de crédito pueden introducir aristas adicionales | No declarar cobertura integral; PR #91 en DRAFT |

### 6.1. Grafo de orden parcial observado y casos de 40P01

```text
C3-03 (UC-43 R vs UC-05 P):
    UC43: PEDIDO(U) -----------------> ASIGNACION_REPARTO(U)
    UC05 peligro: ASIGNACION_REPARTO(U) -------> PEDIDO(U)
    Resultado experimental: 40P01 en inversión.

C3-08 (UC-29 R vs UC-05 P):
    UC29: A1(2929001) -> CLIENTE(U) -> PEDIDO(S)
    UC05 peligro: PEDIDO(U) -----------------> CLIENTE(U)
    Resultado experimental: 40P01 en inversión.

Precedencia candidata local (NO global certificada):
    [guard financiero A1(2929001) cuando corresponda]
                  |
            CLIENTE(U, IDs asc)
                  |
            PEDIDO(U, IDs asc)
                  |
          ASIGNACION_REPARTO(U)
                  |
          Detalles/Entrega/IMP-B *
                  |
          Cobro/PAGO/Caja/recibo *
                  * orden físico NO DISEÑADO TODAVÍA
```

**Advertencia esencial:** una ruta local `CLIENTE→PEDIDO→ASIGNACION` **no es** prueba de aciclicidad del sistema. `UC-28` actualmente toma `PEDIDO` antes de acceder a `A2(808,0)`/Producto/Insumo, y anularCobro usa `COBRO→CLIENTE`. La interacción de **varios Clientes en un único cierre K2**, claves asesoras, `MAX+1`, FK/trigger y servicios no auditados requiere un **DAG global de todos los escritores**, no una elección cosmética de orden. Si existe ciclo no eliminable sin cambiar código, informar **bloqueo G-FIS**, requerir CR/autorización de corrección, jamás «resolver» suprimiendo pruebas o desactivando constraints.

### 6.2. Decisiones técnicas de locking que G-ARQ Nivel 2 aún debe proponer en ADR separado

| ID | Pregunta técnica abierta | Opciones a comparar, sin elegir aún | Prueba/criterio de salida |
|---|---|---|---|
| L01 | Orden total entre guard de cierre por recorrido, A1(2929001) y Clientes | Guard de cierre antes del guard financiero / inverso / identidad única no bloqueante con índice, siempre validando permisos | Dos ADMIN mismos y distintos Clientes, cierre concurrente y Cobro manual; no 40P01 no recuperado |
| L02 | CLIENTE/Cobro/Pedido/FK en alta y anulación | Reordenar escritor de anulación con nueva adenda / jerarquía de serialización compartida | C3 completo que incluye `fn_mr3_anular_cobro_manual`, rollback e inserciones indirectas |
| L03 | Claves globales `MAX+1` y secuencias por Cliente | Generadores SQL versionados, locks cooperativos u otra estrategia aprobable | Dos Clientes en cierre, alta Cobro/UC-22, sin `23505`, duplicación ni saltos que rompan invariantes |
| L04 | Identidad de Recorrido en esquema sin tabla | Relación de asignaciones/recorrido y cierre protegido por unicidad verificable | Prueba dos ADMIN doble cierre/otra UUID, sin exponer recibos ajenos |
| L05 | Locks IMP-B: reservas, consolidaciones, liberaciones, consumo FIFO | Grafo por Cliente/Obligación/Cobro/tramo con desempate total | Sin doble aplicación ni cambio de `V_e` por lectura obsoleta |
| L06 | Interacción UC-28, UC-07 y UC-41 con Pedido/Detalle/Producto/Excedente | Orden global o validación/encapsulamiento de escritores adaptados | `C3-05/06/07`, sin línea `cantidadOriginal=0` |
| L07 | Snapshot temporal UC-19 y UC-07 | Bloquear PRODUCTO/PRECIO y capturar `clock_timestamp()` tras esperas relevantes | Reproducir C3-04 y corregir snapshot obsoleto |
| L08 | Interferencia de A1 bigint Cliente vs Insumo | Nombres/espacios advisory separados, o serialización consciente documentada | Ensayo IDs coincidentes `idCliente=idInsumo`, sin bloqueo cruzado accidental |
| L09 | T1 duración/aislamiento y error 40P01 | READ COMMITTED con revalidación, aislamiento más estricto con retry, límites técnicos medidos | Tests de rendimiento, no cambiar regla comercial por timeout |
| L10 | Contenido de recibo e identidad K2 con varios Cobros | Derivación segura de claves por cierre/Cliente, orden de confirmación, versiones de huella | UUID única por Cobro, huella y replay histórico, recibo consistente tras cambio posterior |
| L11 | Múltiples medios de pago por Cliente en cierre | Política a decidir sin violar K2 ni `medioPago` único de COBRO | RD específica o restricción de alcance demostrable; sin fabricación de medio |
| L12 | Cierre con diferencias o 0 aplicaciones; regularización posterior | PENDIENTE hasta motivo ADMIN, sin segundo cierre, casos límites de custodia | Prueba de diferencias y `V_e^{vig}` remanente; RD si se pretende recupero/segunda aplicación |

## 7. Tabla de riesgos, compatibilidad física y decisiones que bloquean V4

| Riesgo | Evidencia/condición | Consecuencia | Mitigación o gate |
|---|---|---|---|
| R-N2-01 — falta identidad Recorrido | V1 contiene `ASIGNACION_REPARTO` y `ENTREGA`, pero no `CREATE TABLE RECORRIDO` | No hay persistencia completa de cierre único por recorrido | Diseñar identidad y cardinalidad en CR física, sin inventar tabla ahora |
| R-N2-02 — aplicación no acreditada | V1 `ORIGEN_MOVIMIENTO_CUENTA` tiene 1 origen/Movimiento, no importe Cobro–Entrega | Duplicación/mala atribución y `COBRO.idPedido` engañoso | IMP-B + aplicación K2 trazable, FK/UNIQUE, sumas y pruebas |
| R-N2-03 — Cobro con un medio | V1 `COBRO.medioPago` escalar; K2 a lo sumo 1 Cobro/Cliente/cierre | No representa varios medios por Cliente sin política adicional | Bloqueo de alcance o RD comercial específica antes de FIS |
| R-N2-04 — inversión COBRO/CLIENTE | Servicio anular vs alta y futuras transacciones | Deadlock y reintento inconsistente | ADR y C3 global; función y triggers incluidos |
| R-N2-05 — identidad financiera | Cobro manual usa `MAX+1` y secuencia por Cliente | Carreras `23505` y múltiples clientes en T1 | Generación coherente y locks verificables |
| R-N2-06 — caja/custodia | RD-F04-002, RCG-04, diferencias y medios heterogéneos | Balance físico vs contable inválido | Tres vistas y prueba de no doble ingreso |
| R-N2-07 — pendiente F04 | RD-F04-005 no regula la resolución posterior del saldo remanente | Cerrar recorrido no borra `V_e^{vig}` | No segunda clausura ni restauración de deuda; nueva decisión si se requiere |
| R-N2-08 — V4 y CR-F04 | CR-B0-F04-001 sigue bloqueando diseño físico | Cambio de esquema sin autoridad | Gate independiente G-FIS, preflight de bases |
| R-N2-09 — UC07 CR-F | `DETALLE_PEDIDO(cantidadOriginal=0)` incompatible RCG-02 | Inconsistencias de FK/trigger/unicidad | No aprobar ese diseño, rediseñar antes de R09.4 |
| R-N2-10 — completitud artificial | App UC-05/07 y rendición aún no integrados | Entrega académica sin circuito final | Mantener H3/H4/H5 y requisitos B5/B8; no añadir funcionalidades a Demo |

## 8. Ejemplo numérico de conservación e interpretación de estado

**Ejemplo sintético** del expediente PR #69 y resolución PR #70; NO corresponde a una prueba ejecutada:

| Entrega | Cliente | `C_e` | `K_e` | `D_e` | `V_e^0` | `A_e` propuesto | `V_e^{vig}` después |
|---|---|---:|---:|---:|---:|---:|---:|
| A1 | A | 120,00 | 30,00 | 70,00 | 70,00 | 70,00 | 0,00 |
| A2 | A | 80,00 | 15,00 | 50,00 | 50,00 | 40,00 | 10,00 |
| B1 | B | 90,00 | 30,00 | 70,00 | 60,00 | 60,00 | 0,00 |
| **Σ** | — | **290,00** | **75,00** | **190,00** | **180,00** | **170,00** | **10,00** |

Se recibieron físicamente 180,00; bajo evidencia suficiente se atribuyen A 110,00 (A1=70,00 + A2=40,00) y B 60,00 (B1), con 10,00 **recibidos no imputables bajo custodia**. Falta material 10,00 en A2 que puede resultar constatado. Conservación: `170,00 + 10,00 = 180,00 = Σ V_e^0`. La custodia de 10,00 NO es otro Cobro ni suma a `Σ V_e^0`.

**Antes de resolución ADMIN motivada:** la rendición queda **PENDIENTE DE CONCILIACIÓN**, sin recibo de cierre definitivo T1; las cantidades de la columna `A_e propuesto` son *planificación* hasta el COMMIT del cierre autorizado. **Después de resolución lícita:** el cierre T1 registra de manera indivisible Cobro A 110,00 + Cobro B 60,00, Cuenta/Caja de ventas 170,00, extinción de tránsito 170,00 y custodia separada 10,00. El remanente `V_{A2}^{vig}=10,00` **no se extingue** ni se vuelve automáticamente exigible; resolución posterior de ese saldo queda fuera de esta decisión. Si no hay evidencia suficiente para atribuir esos importes, aplica contención/422, no heurística por total de sobre.

## 9. Matriz de pruebas de salida para el próximo gate (no ejecutadas)

| ID | Escenario y fronteras | Criterio / evidencia requerida |
|---|---|---|
| N2-T01 | Un Cliente, dos Entregas K2 | Un Cobro REPARTO del Cliente, dos aplicaciones con sumatoria exacta |
| N2-T02 | Dos Clientes, un recorrido T1 | Cobros separados, no multicliente, IDs globales únicos y sin doble Cuenta/Caja |
| N2-T03 | Fallo tras primer Cobro pero antes de COMMIT | Todo efecto final de ese cierre revierte, 0 asientos residuales |
| N2-T04 | COMMIT exitoso con ACK perdido | Replay mismo UUID/huella = recibo histórico idéntico, sin duplicación |
| N2-T05 | Mismo UUID/payload diferente y nueva UUID en recorrido cerrado | `409` / `RECORRIDO_YA_CERRADO` de C1-a, sin fuga de datos |
| N2-T06 | Dos ADMIN cierran simultáneamente un recorrido | Un único cierre; autorización revalidada, sin carreras ni permisos indebidos |
| N2-T07 | Diferencias abiertas / faltante / custodia / sin importe | PENDIENTE, motivo para resolver, no Cobro/caja ficticio ni restauración de deuda |
| N2-T08 | C3-03 UC-43 vs UC-05 | Reproducir inversión 40P01 y alineación PEDIDO→ASIGNACION |
| N2-T09 | C3-08 UC-29 vs UC-05 | Reproducir inversión 40P01 y alineación CLIENTE→PEDIDO |
| N2-T10 | UC-29 anulación ↔ cierre K2 ↔ Cobro/IMP-B | Probar function/triggers/contraasientos; D7-A y locks/acceso |
| N2-T11 | UC-28/UC-07/UC-41 y stock/excedente | C3-05/06/07 sobre CR autorizadas; no línea original ficticia |
| N2-T12 | UC-19/07 snapshot y espera advisory | Reloj posterior a espera; precio histórico congelado, sin mezcla |
| N2-T13 | Dos Clientes con IDs invertidos y varios Cobros | Grafo de wait-for sin ciclos, secuencias y `MAX+1` seguros |
| N2-T14 | Un Cliente con dos medios en mismo cierre | Rechazo/contención conforme futura RD; nunca fingir un único medio |
| N2-T15 | Revisión UC-14/15 y contención IMP-C | Saldo confirmado/provisional sin doble descuento; ADMIN no accede UC-14 |
| N2-T16 | Recorridos grandes y secuencias intercaladas | Medición de locks, latencia, timeouts; pruebas de rollback/retry (40P01) |
| N2-T17 | Preflight Cobros antiguos y reservas ambiguas | Cinco señales RCG-06, contención selectiva, sin backfill heurístico |
| N2-T18 | Contrato B1 cobertura insuficiente y A1 observabilidad | 422 sin cierre ni efectos, diagnóstico separado post-rollback |
| N2-T19 | Registro de custodia + arqueo en tres vistas | No sumar global UC-23 a efectivo contado, sin ingreso de venta duplicado |
| N2-T20 | Regresión y trazabilidad final R09.1–R09.5 | Testcontainers PostgreSQL, tests HTTP/RBAC/BC-06/E2E del **sistema final** con SHAs exactos, no Demo ampliada |

**Evidencia futura:** contrato/versión de esquema, base desechable sintética, commits exactos de ambos repos, `pg_locks`, `pg_blocking_pids`, intercalados reproducibles, SQLSTATE, filas esperadas vs obtenidas, CI y revisión de roles. **No se ejecuta ningún test nuevo en este PR**, ni se considera CI documental como prueba funcional.

## 10. Entregables y puertas del roadmap después de G-ARQ-N2-01

| Orden rector | Próximo producto | Puerta bloqueante y salida |
|---|---|---|
| 0 (este corte) | **G-ARQ-N2-01**, arquitectura lógica/matriz de locks, una PR documental DRAFT | Satisface preparación de análisis R08.6; **no** cierra G-ARQ N2, RT-UC07-04 ni G-FIS |
| 1 | **G-ARQ-N2-02**: ADR de concurrencia global, generadores, identidad/estado recorrido, K2 multimedio, contrato de conciliación; resolver respaldo G-ARQ Nivel 1 | Objeciones L01–L12 y R-N2-01..09, C3 completa; cambios comerciales requieren RD expresa |
| 2 | **R08.6 físico / CR-F04**: propuesta física por fases PE-1/PE-2/IMP-01, integridad, preflight de datos destino, protocolo de migración no destructiva | **Pedir autorización G-FIS distinta** antes de DDL/V4 o pruebas físicas de cambios nuevos |
| 3 | **R09.1** fundaciones; **R09.2** UC-05 online; **R09.3** UC-14 y rendición UC-29; **R09.4** UC-07/06/15; **R09.5** regresión | Solo después de decisiones, adendas y gate físico; no elevar PR de código por inferencia |
| 4 (paralelo permitido cuando corresponda) | B5 interfaces del sistema final, B6 adaptadores, B8 pruebas, B10 documentación | Mantener trazabilidad y ruta crítica H3/H4/H5, sin ampliar Demo I1/I2 ni marcar interfaces como aceptadas |
| 5 | I4/I5/I6 restantes e I7 certificación/aceptación | No reducir 64 CU/67 ops sin CR y acuerdo académico; B9 pausado hasta autorización expresa |

### Definición de terminado específica G-ARQ-N2-01

- [x] Contratos/decisión ratificada y orden de fuentes registrados.
- [x] Modelo lógico y multiplicidad K2 documentados, sin DDL.
- [x] Matriz de locks R/P/D y conflictos 40P01 con alcance real de la evidencia.
- [x] Riesgos de generadores, idempotencia, conciliación, doble ingreso, medio de pago y políticas de vista segregadas.
- [x] Lista verificable de casos de prueba y dependencias del roadmap.
- [x] No ampliar Demo; foco en cierre del sistema.
- [ ] **Pendiente de revisión:** matriz de grafo global validada con escritores completos, pruebas ejecutadas, G-ARQ Nivel 1 original acreditado, G-ARQ Nivel 2 ratificado y G-FIS autorizado.
- [ ] **Pendiente de integración editorial:** check/PR/merge de este documento; el estado DRAFT permanece.

## 11. Fuentes directas y trazabilidad

**Gobierno main (lectura):**
- `docs/01-gobierno/PLAN_RECTOR_IMPLEMENTACION_2026-10-29.md`.
- `docs/01-gobierno/ROADMAP_OPERATIVO_I3_I7_2026-11-15.md`.
- `docs/01-gobierno/RD_F04_002_RENDICION_EFECTIVO_2026-10-26.md` y `RD_F04_005_DIFERENCIA_PAGO_EN_TRANSITO_2026-10-26.md`.
- `docs/01-gobierno/ACTA_G_COM_001_RATIFICADA_CON_SALVEDADES_2026-11-16.md`.
- `docs/01-gobierno/b0/CR_B0_F04_001_DISENO_FISICO_SINCRONIZACION_PENDIENTE_2026-10-29.md`.
- PR #66: acta y transcripción ART-GCON-C1-a, C2 diferida históricamente. https://github.com/leandrito369/ale-milanesas/pull/66
- PR #68: conciliación R08.6 previa. https://github.com/leandrito369/ale-milanesas/pull/68
- PR #69: comparación T1-C2/T2-C2/K1/K2, ejemplos y matriz futura. https://github.com/leandrito369/ale-milanesas/pull/69
- **PR #70:** ratificación declarativa T1-C2 + K2 y salvedades S01–S10. https://github.com/leandrito369/ale-milanesas/pull/70
- PR #65: adendas E-01..10 pendientes de gate editorial, no canonizadas. https://github.com/leandrito369/ale-milanesas/pull/65

**Aplicación main (solo lectura):** `CobroManualService.java`, `CargarPedidoService.java`, `AsignarRepartoService.java`, `RegistrarPreparacionService.java`, `ActualizarPrecioVigenteService.java`, `EvaluadorCategoriaComercialInterno.java`; `V1__baseline_mr5.sql`, `V2__f01_cobro_estados.sql`, `V3__trazabilidad_partidas_insumo.sql`.

**Evidencia experimental previa (NO ejecutada aquí):** app PR #89, `docs/implementation/C3_A3_NIVEL_RP_2026-11-15.md`, clase R/P/D, PostgreSQL efímero. https://github.com/leandrito369/ale-milanesas-app/pull/89. **Plan futuro:** app PR #92 R09-PRE https://github.com/leandrito369/ale-milanesas-app/pull/92.

**Limitaciones honestas:** revisión estática del código y el informe de C3; no certificación global de locks, ni auditoría exhaustiva de todos los writers SQL/triggers. Esta PR no modifica `main`, contratos G0, código, migraciones, datasets, Demo, workflows, despliegue ni otras PR.
