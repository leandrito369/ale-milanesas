# Auditoría — Etapa 3. Contrato comercial consolidado y separación de decisiones

**ID provisional:** AUD-E3-COM-001 · **Corte:** 15/11/2026 (Argentina; actualización 16/11 UTC).  
**Estado:** **PROPUESTA DE CONSOLIDACIÓN NORMATIVA — DRAFT / NO RATIFICADA COMO CONTRATO INTEGRAL / NO MERGE**.  
**Ámbito:** circuito Pedido → Preparación → Entrega (UC-05) → Cuenta Corriente (UC-14) → Cobro y rendición (UC-29), cancelación (UC-06), categoría/mora (UC-15/16), Excedentes (UC-07), seguridad, idempotencia y concurrencia.  
**Propósito:** unificar decisiones comerciales ya expresadas; reducir el número de asuntos pendientes; distinguir políticas a ratificar por el responsable de mecanismos delegables a Arquitectura. **No cambiar** G0, 64 CU/67 operaciones, API, RBAC, DDL/Flyway, fuente de aplicación ni despliegue.

> **Normativa de autoridad:** el presente documento **NO convierte las PR draft #44/#47/#48/#50–#63 en normas integradas**. Un estado «aprobado funcionalmente» significa que existe constancia de decisión expresa del responsable en esa PR, no que el contrato canónico REV04B/REV05 se haya actualizado, ni que se autorice SQL, código o merge. Los pendientes siguen siéndolo hasta una decisión expresa y formalización controlada.

## 0. Fuentes verificadas y precedencia temporal

**Línea base vigente:** [G0/acta](b0/RD_B0_G0_001_CIERRE_LINEA_BASE_2026-10-29.md) · [Manifiesto 67](b0/G0_MANIFIESTO_CANONICO_67_OPERACIONES_2026-10-29.csv) · [REV04B](../08-diagramas/consolidacion-b0/CONTRATOS_REV04B_CORREGIDOS_B0_ACTUALIZADO.md) · [REV05](../08-diagramas/consolidacion-b0/CONTRATOS_REV05_CORREGIDOS_B0_ACTUALIZADO.md) · [RD-F04 cierre](../06-arquitectura/F04_CIERRE_FUNCIONAL_MAESTRO_2026-10-26.md) · [precedencia de versiones](VIGENCIA_DOCUMENTAL_Y_PRECEDENCIA_2026-11-15.md).

**Propuestas históricas en PR separadas:** [RD-I302-001 #44](https://github.com/leandrito369/ale-milanesas/pull/44), [D5/D6/D7 #50](https://github.com/leandrito369/ale-milanesas/pull/50), [R08.2 #51](https://github.com/leandrito369/ale-milanesas/pull/51), [R08.3 #52](https://github.com/leandrito369/ale-milanesas/pull/52), [R08.4 #53](https://github.com/leandrito369/ale-milanesas/pull/53), [R08.5 #54](https://github.com/leandrito369/ale-milanesas/pull/54).

**Decisiones funcionales posteriores de 15/11:** [DC05-04 #55](https://github.com/leandrito369/ale-milanesas/pull/55), [DC05-01/02 #56](https://github.com/leandrito369/ale-milanesas/pull/56), [DC05-03 #57](https://github.com/leandrito369/ale-milanesas/pull/57), [DC05-05/06 #58](https://github.com/leandrito369/ale-milanesas/pull/58), [DC05-07 #59](https://github.com/leandrito369/ale-milanesas/pull/59), [DC05-09 #60](https://github.com/leandrito369/ale-milanesas/pull/60), [D12 #61](https://github.com/leandrito369/ale-milanesas/pull/61), [DC-01 #62](https://github.com/leandrito369/ale-milanesas/pull/62), [DC-02/DC-04 #63](https://github.com/leandrito369/ale-milanesas/pull/63). Verificar texto y SHA de HEAD antes de consolidación definitiva: son **asientos OPEN/DRAFT**.

**UC-07:** [CR-C #47](https://github.com/leandrito369/ale-milanesas/pull/47) y [CR-F #48](https://github.com/leandrito369/ale-milanesas/pull/48), ambas **sin autorización integral**. RD-UC07-001 y RD-UC07-002 en main registran decisiones parciales, pero las CR no quedan aprobadas por esa razón.

**Desfase temporal conocido:** R08.5 (#54) muestra todavía `DC05-01..09`, `DC-01/02/04` y `D12` como decisiones futuras. Los asientos posteriores #55–#63 recogen su aprobación funcional. **No reinterpretar retrospectivamente R08.5 ni borrar su historia:** este documento registra la prevalencia de los hechos posteriores en su alcance y las enmiendas que faltan.

## 1. Contrato unificado: hechos de negocio y reglas ya elegidas

### C-01. Identidad y valor de la venta entregada

1. `PEDIDO` conserva Cliente, Detalles, precios, promociones, categoría, política, tipo y porcentaje de ajuste **históricos** al confirmar. No se recalcula la venta con tarifas ni categoría actuales al entregar.
2. `UC-05` cobra por lo efectivamente entregado: `C_e` deriva de cantidades reales de `DETALLE_ENTREGA`; no usar `PEDIDO.totalOriginal` completo en Entrega parcial. **DC-01-C1 APROBADA FUNCIONALMENTE** ([#62](https://github.com/leandrito369/ale-milanesas/pull/62)).
3. Reaplicar al subtotal entregado tras promociones **el tipo y porcentaje histórico congelado del Pedido**; no prorratear como algoritmo principal el importe fijo de ajuste del Pedido ni reevaluar `UC-15/16`. **DC-02-A APROBADA** ([#63](https://github.com/leandrito369/ale-milanesas/pull/63)).
4. **DC-04-A APROBADA:** sumar componentes de la **base agregada** (no redondear de forma autónoma cada línea), redondear base a 2 decimales `HALF_UP`, calcular ajuste porcentual sobre esa base y redondearlo a 2 decimales `HALF_UP`; después sumar/restar según `DESCUENTO/RECARGO/SIN_AJUSTE`. Exigir conciliación posterior por detalle, sin alterar el cargo agregado ni inventar centavos ([#63](https://github.com/leandrito369/ale-milanesas/pull/63)).
5. Entrega completa de las cantidades originales **sin adicionales** debe conciliar al centavo con `PEDIDO.totalOriginal` cuando los snapshots comerciales coinciden. Una divergencia no autoriza compensación monetaria silenciosa.
6. **Pendiente acotado B-02 (`DC-03`):** tratamiento comercial de adicionales UC-07; no inferirles ajuste ni promoción históricos. Mientras CR-C/CR-F estén sin aprobación, no declarar probado el flujo UC-05 con adicionales aceptados.

### C-02. Cobro confirmado, reserva, aplicación y mora

1. El `Cobro` confirmado es un hecho de pago; acredita Cuenta y Caja **una sola vez** según F01/REV05. Registrar reserva o aplicación **no** genera nuevo `COBRO`, `MOVIMIENTO_CUENTA(PAGO)` ni `MOVIMIENTO_CAJA`.
2. **DC05-01/02-A APROBADA** ([#56](https://github.com/leandrito369/ale-milanesas/pull/56)): una porción explícita de Cobro `CONFIRMADO` puede reservarse **antes de Entrega** para un Pedido del mismo Cliente; la reserva aparta fondos del crédito FIFO libre, **sin ser todavía** aplicación definitiva `P_e` ni cargo. Al confirmar UC-05 se consolida solo la parte elegible a la obligación real de esa Entrega.
3. **ANT-01 APROBADA** ([#52](https://github.com/leandrito369/ale-milanesas/pull/52)): solamente importes previamente cobrados, CONFIRMADOS, no ANULADOS y **efectivamente aplicados** a esa obligación disminuyen el importe elegible por reconocer al entregar. `COBRO.idPedido` y saldo global, por sí solos, no prueban aplicación de cantidad alguna.
4. **DC05-04-B APROBADA** ([#55](https://github.com/leandrito369/ale-milanesas/pull/55)): las aplicaciones explícitas y vigentes tienen prioridad al evaluar deuda y mora (`UC-15`); FIFO solo usa remanentes libres de créditos confirmados, nunca importes reservados/aplicados. Pago en tránsito no confirmado no recategoriza al Cliente (RD-F04-007).
5. Una misma porción confirmada no puede aparecer simultáneamente como **reservada**, **aplicada** y **libre**, ni aplicarse a dos obligaciones. Debe reconciliar con los importes confirmados netos, contraasientos y ajustes autorizados.
6. **DC05-03-A APROBADA** ([#57](https://github.com/leandrito369/ale-milanesas/pull/57)): `ADMINISTRADOR` y `VENDEDOR` pueden crear la reserva al registrar Cobro manual autorizado; solo `ADMINISTRADOR` puede corregir o liberar **excepcionalmente** una reserva. No heredar permisos de otras operaciones ni conceder `UC-14` al ADMIN; requiere contrato y RBAC explícitos antes de API.
7. **DC05-09-A APROBADA como dirección arquitectónica** ([#60](https://github.com/leandrito369/ale-milanesas/pull/60)): `IMP-B` append-only es la **única fuente canónica de eventos** de reserva, aplicación, liberación, corrección y contraaplicación autorizada; `IMP-A` es su **proyección activa derivada**, no segunda autoridad. `IMP-C` es solo contención ante falta de evidencia, sin reconocimiento `V_e^0` inventado. La decisión **no aprueba DDL, tablas, migración ni implementación**.
8. **Pendiente acotado B-01 (`DC05-08`)**: remanente de reserva cuando la Entrega parcial genera `C_e` inferior a lo reservado; nunca consolidar `P_e > C_e`. El destino exacto del exceso debe ratificarse.
9. **Pendiente acotado B-06 (`DC05-11/12`)**: semántica contractual final de `COBRO.idPedido` y tratamiento de Cobros legados; prohibido transformar información histórica ambiguamente en aplicaciones.

### C-03. Cancelación y anulación

1. **DC05-05/06-A APROBADA** ([#58](https://github.com/leandrito369/ale-milanesas/pull/58)): cuando `UC-06` confirma cancelación de Pedido `PENDIENTE`, liberar automáticamente las reservas **elegibles y activas** asociadas, conservando historia. El dinero liberado retorna a crédito libre del Cliente sujeto a FIFO, **sin reasignación explícita automática** a otro Pedido. No duplicar Pago/Caja ni dar libre disponibilidad a montos reembolsados o bajo reembolso.
2. **DC05-07-A APROBADA** ([#59](https://github.com/leandrito369/ale-milanesas/pull/59)): `anularCobroManual` de un Cobro **general** queda bloqueada mientras existan reservas o aplicaciones activas hasta liberación válida o contraaplicación **expresamente autorizada**. Una relación histórica liberada no equivale a vínculo activo. Cobros generales sin vínculos activos conservan anulación normal conforme F01.
3. **D7-A APROBADA** ([#50](https://github.com/leandrito369/ale-milanesas/pull/50)): bloqueo transitorio de anulación de Cobros **de rendición** en servidor mientras no exista política aprobada de contraaplicación; no bloquear indiscriminadamente el resto de Cobros generales.
4. Contraasientos y reparaciones son eventos trazados; no borrar ni alterar retrospectivamente el Cobro original o la historia de reservas.
5. **D7-B/`DC-09` diferida**: no habilitar anulación de Cobro de rendición ni restauración automática de tránsito hasta nueva aprobación comercial. Mantener el sistema diseñado para evolución, pero sin programar la regla no aprobada.

### C-04. Entrega, declaración y reconocimiento

1. **D5-B APROBADA** ([#50](https://github.com/leandrito369/ale-milanesas/pull/50)): efectivo declarado `D_e` de la Entrega `e` solo puede atribuirse a **esa Entrega**, nunca saldar otras deudas.
2. **D2=B/EX-01 — regla expresada, asiento contractual pendiente:** conservar íntegramente `D_e`, incluso si supera el pendiente; el exceso no crea automáticamente crédito, Cobro, Caja ni otro pago. La diferencia queda explícita para conciliación ([#44](https://github.com/leandrito369/ale-milanesas/pull/44)); no interpretar su redacción anterior como fórmula aprobada.
3. Separar `C_e` (cargo comercial real), `P_e` (porción previa efectivamente aplicada), `D_e` (total declarado), `V_e^0` (reconocimiento provisional original), `V_e^vig(t)` (efecto provisional vigente), `A_e(t)` (tránsito convertido a definitivo) y `Q_e` (diferencias auditables); nombres de R08.4 como lenguaje común, **no equivalencias monetarias automáticas**.
4. **DC-06 PENDIENTE:** no se ha ratificado la fórmula `V_e^0`. La alternativa de cálculo **V1** `E_e=max(0,C_e-P_e)`, `V_e^0=min(D_e,E_e)` es **candidata**, válida únicamente si la evidencia `IMP-01` y los saldos a punto de serialización están probados, sin carreras, anulaciones ni ambigüedad. El patrón **V3** de conservar decisiones/snapshots no es una fórmula alternativa de negocio. `IMP-C` evita asumir un `P_e` o `V_e^0` no demostrable.
5. **DC-07 PENDIENTE:** cuando `C_e=0` y `D_e>0`, elegir si se acepta y conserva la declaración como diferencia sin reconocimiento o se rechaza el comando; no crear automáticamente crédito/Cobro/Caja.
6. **DC-08 PENDIENTE:** aprobar separación de `Q_e^decl`, `Q_e^rend`, `Q_e^falt` en vez de neteo opaco; el diseño físico de campos/vistas será técnico una vez aprobada la política de no compensación.

### C-05. Rendición administrativa y cierre financiero

1. **D6-1 APROBADA** ([#50](https://github.com/leandrito369/ale-milanesas/pull/50)): rendición como **subflujo UC-29 exclusivo de ADMINISTRADOR**; `VENDEDOR` mantiene Cobro manual general, no rendición; `REPARTIDOR` declara en UC-05, **no** ejecuta UC-29.
2. Declaración/captura local no equivale a efectivo rendido ni a `COBRO`. Solo ingreso confirmado y vinculado de forma verificable modifica el saldo **confirmado** y Caja; la conversión debe extinguir el efecto provisional **del mismo tramo monetario**, sin duplicarlo.
3. El saldo confirmado de `UC-14` no es `saldoExigibleProvisional`. El tránsito validado puede afectar una proyección de exigibilidad provisional sin recategorizar por sí solo al Cliente (F04). **No** alterar el permiso de UC-14, exclusivo VENDEDOR conforme G0.
4. **Pendiente B-04:** unidad de rendición (por recorrido completo vs cabecera de recorrido con aplicaciones por Entrega/Cliente), evidencia de recepción (`D4`), visibilidad exacta del ADMIN en rendición (`D9/BC-07`) y tratamiento del efectivo recibido que exceda lo reconocido (`D10`). El literal exacto de `COBRO.origen` dentro del catálogo permitido de V1 puede definirlo Arquitectura si no altera la semántica elegida y los reportes.
5. **No** crear automáticamente una operación `UC-65` de rendición ni ampliar permisos de UC-14; si se necesitan suboperaciones y proyecciones nuevas, tramite contrato/RBAC/BC07 específico sin renumeración unilateral.

### C-06. Excedentes y canales

1. UC-07 conserva procedencia de producto, cantidades, costos, aceptación y snapshot comercial; aceptar/transferir Excedente no fabrica el producto ni crea segundo consumo de Insumos.
2. En [CR-C #47](https://github.com/leandrito369/ale-milanesas/pull/47) y [CR-F #48](https://github.com/leandrito369/ale-milanesas/pull/48) existen decisiones A–C **ratificadas parcialmente** (cotización inicial atómica, identificadores/pertenencia y numeración de intentos), pero D–H **sin ratificar** y CR completas **NO AUTORIZADAS**. Quedan abiertos idempotencia, pipeline y límites de evidencia, integración físico-financiera, migración y RT-UC07-04.
3. **DC-03 PENDIENTE:** si adicionales de UC-07 participan en la base del ajuste comercial histórico del Pedido o en promoción/valoración separada. Cualquiera de las opciones debe conservar la cotización aceptada y evitar doble cómputo.
4. **D12-C APROBADA como faseo** ([#61](https://github.com/leandrito369/ale-milanesas/pull/61)): bajo `CR-B0-F04-001` se debe diseñar **ONLINE PE-1 (Entrega/transito) + PE-2 (rendición) + IMP-01 (aplicaciones)** de forma integrada, y diferir **OFFLINE PE-3** con gate específico. **No** autoriza instalar, migrar o desarrollar físicamente ninguna fase. Sin entregar un PE-1 aislado sin rendición ni evidencia de anticipos.

## 2. Decisiones ya expresadas: registro único de precedencia

| ID funcional | Política adoptada / estado | Evidencia fuente | Acción pendiente (NO nueva decisión comercial) |
|---|---|---|---|
| D5-B | Declaración solo de la Entrega actual | PR #50/#51 | Propagar a REV04B/REV05 |
| ANT-01 | Solo Cobro confirmado y aplicado efectivamente reduce pendiente | PR #52 | Exigir evidencia IMP-01 |
| D6-1 | Rendición en UC-29 por ADMIN exclusivo | PR #50/#51 | Contrato de subflujo y BC07 |
| D7-A | Bloquear anulación de Cobros de rendición | PR #50/#51 | Guarda transaccional y enmienda REV05 |
| D2=B/EX-01 | Declaración íntegra, exceso no acredita automáticamente | PR #44, #50/#53 | **Asiento formal escrito** (no inferir fórmula) |
| DC05-01/02-A | Reserva Pedido, consolidación en Entrega elegible | PR #56 | Contrato y evidencia física |
| DC05-03-A | ADMIN/VENDEDOR reserva; solo ADMIN corrige/libera excepcionalmente | PR #57 | Formalización RBAC/BC07 |
| DC05-04-B | Aplicación explícita antes de FIFO libre en mora | PR #55 | Alinear UC-15 y pruebas |
| DC05-05/06-A | Cancelación libera reserva activa; crédito libre sin asignación explícita | PR #58 | Propagar UC-06 y evitar reembolsos dobles |
| DC05-07-A | Anulación de Cobro general con aplicación/reserva activa bloqueada | PR #59 | Conciliar con F01, sin afectar anulaciones sin vínculo |
| DC05-09-A | IMP-B canónico append-only; IMP-A proyección; IMP-C contención | PR #60 | Diseñar CR físico, no «aprobar» tablas automáticamente |
| D12-C | CR articulada online PE1/PE2/IMP01; PE3 offline diferida | PR #61 | Gates por fase y CR documental |
| DC-01-C1 | Cargo C_e real por cantidad efectiva/histórico | PR #62 | Incorporar a REV04B y test parcial |
| DC-02-A | Aplicar ajuste histórico porcentual al subtotal entregado | PR #63 | Prueba de parcial y UC-16 |
| DC-04-A | Base agregada HALF_UP 2; ajuste HALF_UP 2; luego suma/resta | PR #63 | Implementación decimal y centavos |

**No revotar estas decisiones.** Una aprobación funcional aún no integrada debe **conservar su referencia de PR, fecha, autoridad y alcance**. Las modificaciones a fuentes G0/REV04B/REV05 necesitan revisión editorial controlada y autorización de integración, no una nueva elección de fondo.

## 3. Únicos paquetes comerciales pendientes a someter al responsable

Cada paquete se aprueba o queda abierto **en conjunto**, no por decenas de microdecisiones. Las opciones recomendadas **NO** son aprobaciones.

| Grupo | IDs originales | Pregunta de negocio residual | Alternativa preferente para revisión | Bloqueo |
|---|---|---|---|---|
| **B-01 Anticipo en Entrega parcial** | `DC05-08` | Si la reserva supera `C_e`, ¿se libera automáticamente el excedente a crédito libre o exige decisión posterior? | `P_e` consolidado `<= C_e` y remanente liberado con evento trazable; nunca aplicación a otra obligación por inferencia. | **P0** para parciales con anticipos |
| **B-02 Adicionales UC-07** | `DC-03`, parte UC-07 de `DC05-08` | ¿Adicional aceptado lleva precio/cotización propia sin ajuste/promoción histórica del Pedido o entra a esa base? ¿Qué ocurre si aún no está habilitada UC-07? | Valorar adicional mediante cotización aceptada que incorpora el ajuste histórico congelado según CR-C (todavía DRAFT); no reaplicar ese ajuste en Entrega. Resolver la fracción efectivamente entregada y autorizar CR-C/CR-F. Si no autorizado, excluir **solo escenarios con adicional** del corte técnico inicial, sin declarar UC-07 completo. | **P0** para Entrega con adicionales; diferible en flujo sin UC-07 |
| **B-03 Reconocimiento de declaración y anomalías** | `DC-06`, `DC-07`, `DC-08`, asiento `D2=B` | ¿Regla de `V_e^0` con `C_e/P_e/D_e` probados? ¿Aceptar declaración positiva si `C_e=0`? ¿Diferencias tipadas sin compensación? | Fórmula V1 **solo tras IMP-01** + evidencia V3; aceptar declaración íntegra con `V_e^0=0` ante cargo cero y registrar diferencia; Q tipado. Sin evidencia, IMP-C. | **P0** antes de reconocer tránsito |
| **B-04 Rendición y diferencias** | `D4`, `D9`, `D10`, `DEC-GRAN-D6`, `D56-09` | ¿Cómo rinde ADMIN: recorrido, entregas/Cliente, parciales? ¿Qué evidencia mínima recibe? ¿Quién ve cada campo? ¿Qué sucede si se recibe más o menos que lo reconocible? | Cabecera por recorrido + aplicaciones atómicas por Entrega/Cliente, evidencia digital mínima RD-F04-002, diferencias sin compensar; excedente no aplicado automáticamente. Requiere autorización explícita de proyección BC07. | **P0** antes de PE-2 |
| **B-05 Políticas visibles de reintentos y anulación** | `D3`, `DEC-UC29-ANUL/C-04` | ¿Se permite corregir y reenviar tras rechazo previo? ¿Debe devolución de anulación exponer los IDs de contraasiento? | Rechazo previo sin confirmar comando/consumir clave; reenvío idéntico tras éxito devuelve mismo resultado; anulación con recibo idempotente trazable. Arquitectura decide UUID/almacenamiento. | **P1**, requisito de contrato observable |
| **B-06 Legado y campos informativos** | `DC05-11/12` | ¿Cómo interpretar `COBRO.idPedido` histórico y Cobros antiguos sin registro de aplicación? | Conservar campo como **referencia informativa sin imputación**; no backfill automático; conciliación manual si existen Cobros previos vivos. Diferir transición solo si no existen anticipos heredados. | **Condicionado a datos heredados** |
| **B-07 Cierre excepcional y fase posterior** | `DC-09/D7-B`, porción final `D10`, `C-08` `UC-03` | ¿Cuándo habilitar contraaplicaciones de Cobros rendidos, tratamiento administrativo definitivo de diferencias y control de admisión con saldo provisional? | Primera fase mantiene bloqueo D7-A e historial; cierre administrativo posterior en subfase autorizada, sin reabrir F04 ni permitir ingreso ficticio. | **Diferible** con contención explícita |

**Observación de alcance:** el paquete B-04 contiene decisiones de privacidad/RBAC; aunque Arquitectura pueda diseñar los DTO, **no puede conceder nuevos campos o permisos sin acto del responsable**. El paquete B-05 tiene una parte técnica (idempotencia) y una parte de contrato observable; si cambia comportamiento visible, deberá quedar aprobada la semántica, pero no es necesario que el responsable elija algoritmo de hash o índice.

## 4. Decisiones técnicas delegables sin microaprobaciones comerciales

Solo **después** de fijados los requisitos/alcance relevantes y mediante revisión de arquitectura, diff de CR e informes reproducibles, el equipo técnico podrá resolver:

| ID técnico | Decisión delegable | Restricción que NO puede violar | Evidencia de aceptación |
|---|---|---|---|
| T-01 | DDL concreto del **IMP-B append-only** y proyección **IMP-A**, identificadores, FK, índices, eventos, proyección activa | No segunda autoridad mutable; suma de porciones no supera Cobros válidos, no doble destino | Reconciliación IMP-T01..20; PostgreSQL y auditoría del historial |
| T-02 | Persistencia de `D_e`, `V_e^0`, `V_e^vig`, aplicaciones `A_e`, diferencias `Q_e`, snapshot por detalle C3 si mejora auditoría | Declaración no crea Cobro, no reconocer sin `P_e` cierto, total C_e siempre rige | T01–T30 + regresión centavos |
| T-03 | Algoritmo `BigDecimal`/escalas SQL y reparto reproducible de residuos por detalle | **DC-04-A exacta**: base agregada HALF_UP(2) + ajuste HALF_UP(2); total no cambia | Paridad exacta con UC-16 y Pedido.totalOriginal |
| T-04 | UUID, fingerprint versionado, scope y recibos idempotentes, replay misma respuesta y conflicto payload distinto | No duplicar hechos, no consumir por error de validación si B-05 lo fija | Reintentos/concurrencia y casos 400/403/409 |
| T-05 | Orden global de locks `DC-10/DC05-10/C3` y estrategia PostgreSQL de aislamiento/conflictos | No romper UC-28/43, UC-05/07/29 ni admitir stale `P_e` | Intercalados reales Testcontainers, ausencia de ciclos/inconsistencia |
| T-06 | Guardas SQL/servicio de anulación general y D7-A rendición | No anular Cobros vinculados activos; no bloquear anulaciones generales sin vínculo | Regresión F01/BC06, reintentos y carreras |
| T-07 | DDL/DTO de rendición por Cliente/Entrega, estado derivado, literal `COBRO.origen` permitido por V1, auditoría de diferencias | No agregar permisos ni transformar declaración en Cobro; respetar B-04 | Tests API/RBAC, comparación V1 y consulta de saldo confirmado/provisional |
| T-08 | Estructura física de CR-C/CR-F UC-07: snapshot, FK compuestas, seguridad documento, índices/privilegios y migración histórica | Respetar decisiones UC-07 A–C ratificadas y no anticipar D–H; no usar SQL antes de CR autorizada | C3/RT-UC07-04, F01–F49, calibración de archivos |
| T-09 | Plan de migración/rollback `R08.6`, preflight de datos heredados, compatibilidad V1→V3 | No editar V1–V3 ni ejecutar DDL candidato sin gate; sin backfill financiero ficticio | CI PostgreSQL efímero y reporte de diff/locks/migración |
| T-10 | Diseño de UI/errores, proyecciones concretas BC07, implementación RBAC y pruebas negativas | Roles/campos conforme negocio; UC-14 solo VENDEDOR, rendición solo ADMIN | Tests HTTP negativos por actor/objeto/campo |

**Nota de autoridad:** delegación **no** significa autorización para escribir en `main`, alterar una BD o desplegar. La CR física específica sigue requiriendo aprobación expresa antes de implementar. Tampoco se habilita la elección técnica de parámetros que el usuario reservó expresamente en UC-07 D/E (retención/umbrales P2b) sin calibración y ratificación.

## 5. Contradicciones documentales y plan de propagación por paquete

R08.5 documentó conflictos `C-01..C-09`; las enmiendas `E-01..E-07` **no fueron aplicadas** a los canónicos. Ejecutarlas como **único lote contractual controlado**, una vez cerrados los marcadores de B-01..B-06 que afecten su texto:

| Enmienda | Fuentes | Consolidar exactamente |
|---|---|---|
| E-01 | REV04B UC-05 / glosario | ADMIN exclusivo en rendición D6-1, sin alterar Vendedor en Cobro general |
| E-02 | REV04B UC-05 | `C_e,P_e,D_e,V_e,Q_e`, D5-B, ANT-01, C1, ajuste/redondeo; pendientes explícitos y guardia UC-07 |
| E-03 | REV04B UC-06 | Liberación automática DC05-05/06-A, crédito libre, exclusión de reembolsos |
| E-04 | REV05 registrarCobro | D6-1 subflujo, origen real permitido por V1, idempotencia y reserva facultativa con RBAC explícito |
| E-05 | REV05 anularCobroManual | Diferenciar DC05-07-A (reserva/aplicación activa), D7-A (rendición), cobro sin vínculo; contraasientos e idempotencia |
| E-06 | REV05 UC-14 | Separar saldo confirmado de exigible provisional y mantener UC-14 solo VENDEDOR; proyección ADMIN de rendición independiente |
| E-07 | RD-I302-001 y registros conexos | Corregir 60→62 tablas actuales, fórmulas no aprobadas, precedencia de #55–#63 y fases D12-C |

Se agregará a cada operación: referencia a la RD de aprobación, actor, datos visibles, pre/post, alternativas/errores, casos de prueba, estado implementado y commit. **No** sustituir G0 ni reescribir SHA/source-lock.

## 6. Puertas de aprobación y condición de reanudación

1. **G-COM:** el responsable revisa **los 7 grupos** B-01..B-07 y ratifica solo los que entran al alcance inmediato. Distinguir decisiones ya tomadas de nuevas; dejar las diferibles expresamente fuera y sus resguardos activos.
2. **G-CON:** contrato unificado y paquete editorial **E-01..E-07** validados/ratificados, propagados con PR única, trazabilidad G0/RBAC/BC07; sin conflicto con UC-07/CR-C/CR-F.
3. **G-ARQ:** Arquitectura selecciona detalles técnicos T-01..T-10, firma plan C3, idempotencia, seguridad, migración, plan pruebas. Decisiones nuevas de negocio retornan al responsable, no se inventan.
4. **G-FIS:** autorización **expresa y separada** de CR física `CR-B0-F04-001` fase online **PE-1+PE-2+IMP-01** y, cuando corresponda, de UC-07 CR-C/CR-F; luego laboratorio PostgreSQL efímero y evidencia. No crear V4 antes de gate.
5. **G-DEV:** una vez cumplidas las anteriores, implementación y CI en PR de aplicación propias, sin rebase/amend/force-push y sin habilitar despliegue pausado (app Issue #28).
6. **G-VAL:** E2E, BC06, roles, concurrente, conciliación de cantidades/dinero y aceptación humana. **Éxito en CI no es validación empresarial**.

La preparación documental de `R08.6` puede ser **condicionada** con marcadores de decisiones abiertas, pero no autoriza SQL ni implementación. La fase offline PE-3 queda diferida por D12-C, manteniendo identidad futura compatible.

## 7. Mini batería unificada de aceptación (escenarios a ejecutar, no ejecutados aquí)

| ID | Entrada ilustrativa | Resultado contractual que debe demostrarse |
|---|---|---|
| CON-01 | Pedido A deuda $10.000, Cobro $8.000 reservado explícitamente a Pedido B | B conserva su reserva, A no recibe $8.000 por FIFO; no segundo Cobro/Caja |
| CON-02 | Reserva $8.000 a B; Entrega parcial `C_e=$5.000` | `P_e <= $5.000`; excedente $3.000 sigue B-01 hasta ratificación, nunca se aplica furtivamente |
| CON-03 | Pedido cancelado con reserva activa | Liberación trazable; no reembolso ficticio ni reasignación expresa automática |
| CON-04 | Cobro general con aplicación activa → anular | Rechazo DC05-07-A; sin aplicaciones → F01 continúa habilitado según permisos |
| CON-05 | Cobro de rendición → anular | Rechazo temporal D7-A, incluso sin reabrir anulación general |
| CON-06 | Entrega parcial cantidad 3/5 con promoción y descuento histórico | `C_e` por cantidad efectiva, base agregada HALF_UP(2), ajuste HALF_UP(2), sin precio actual |
| CON-07 | Entrega completa original sin adicionales | `C_e` coincide a centavo con `totalOriginal` histórico o se identifica fallo; nunca inventar diferencia |
| CON-08 | Declaración `D_e` superior a pendiente elegible | `D_e` íntegro conservado; nunca `COBRO`/Caja/crédito automático |
| CON-09 | Mismo UUID y contenido; después mismo UUID y contenido distinto | Replay original sin efectos; discrepante rechazada sin segunda venta |
| CON-10 | UC-05, anulación Cobro y rendición concurrentes | Serialización sin `P_e` obsoleto, doble `V_e`/Cobro ni deadlocks no tratados |
| CON-11 | UC-07 adicional aceptado sin CR autorizada | No marcar Entrega integrada como completa ni inventar precio/aceptación |
| CON-12 | Repartidor/Vendedor/ADMIN consultan/corrigen reservas | Solo permisos exactos de DC05-03-A y D9; UC-14 no se abre al ADMIN |
| CON-13 | Rendición parcial de una declaración validada | Aplicar como máximo el tramo provisional vigente, retirarlo exactamente al confirmar Cobro |
| CON-14 | Cliente con saldo confirmado, tránsito y categoría | Distinguir exigible provisional vs deuda confirmada; tránsito no modifica categoría |
| CON-15 | Entrega `C_e=0`, `D_e>0` | Resultado pendiente B-03; no imponer camino hasta ratificación |

## 8. Dictamen y restricciones

**Conclusión:** las decisiones dispersas son **consolidables** en un contrato coherente. La mayor parte de `IMP-01`, reserva, liberación, anulación, fases y cálculo histórico **ya fue decidida funcionalmente**. La incertidumbre residual se concentra en **siete paquetes de negocio**, algunos acotables/diferibles, mientras **diez áreas de implementación** son delegables a Arquitectura y prueba dentro de las garantías aprobadas.

**Prohibido declarar**:
- `DC-06` o `DC-07` ratificadas por mera recomendación.
- `DC05-08` resuelta por deducción de `P_e<=C_e`: **el tope es invariante**, el destino del remanente sigue siendo decisión.
- `DC-03` resuelta por existencia de tablas `UC-07` en V1.
- `DEC-GRAN-D6`, `D9`, `D10` aprobadas por decisión `D6-1`.
- Diseño físico `IMP-B` / CR-F04 ratificado por aprobación de dirección arquitectónica `DC05-09-A`.
- PR #44/#47/#48/#50–#63 integradas o supersedidas automáticamente por este registro.
- Pruebas de escenarios `CON-01..15` realizadas. **No se ejecutaron** en este corte.
- Despliegue permitido: **Issue app #28 abierta / PAUSADO**.

**Siguiente tarea:** revisión editorial/funcional de este contrato, ratificación dirigida de **grupos B-01 a B-06** según alcance y habilitación de un **paquete único** E-01..E-07. Mantener B-07 diferido salvo decisión expresa. El cotejo posterior de implementación de invariantes continúa como etapa técnica específica, no debe confundirse con esta etapa 3 de consolidación de gobierno.


---

## 9. Etapa 4 — Dictamen de cierre contractual y paquete para decisión

**Corte analítico:** 15/11/2026 (Argentina) / 16/11 UTC. **Estado:** PROPUESTA TÉCNICO-COMERCIAL PARA REVISIÓN; NO RATIFICADA. Se incorpora al **mismo expediente de contrato** para evitar micro-PR adicionales. Este apartado **precisa** la priorización preliminar §3 y, donde hay discrepancia, prevalece solo como recomendación de auditoría, nunca como sustituto de decisiones ratificadas.

### 9.1 Segregación revisada: cuatro grupos comerciales, dos técnicos y uno diferido

| Grupo de §3 | Naturaleza y dictamen revisado | Autoridad |
|---|---|---|
| B-01 (DC05-08) | **DECISIÓN COMERCIAL NECESARIA:** destino de reserva no consolidada después de Entrega única y parcial | Responsable |
| B-02 (DC-03 / UC-07) | **DECISIÓN COMERCIAL NECESARIA PARA ADICIONALES:** importe final aceptado, ajuste ya incorporado en cotización, prorrateo de entrega parcial de cantidad aceptada | Responsable; CR-C/CR-F sin autorización |
| B-03 (DC-06/07/08, D2=B) | **DECISIÓN COMERCIAL NECESARIA:** fórmula de reconocimiento, cargo cero y diferencias sin compensación; formalizar D2=B | Responsable |
| B-04 (D4, D9, D10, D6-1 granularidad) | **DECISIÓN OPERATIVA NECESARIA**, pero respetando RD-F04-002 (momento y evidencia mínima YA aprobados); selección de campos visibles = gobierno BC07 | Responsable |
| B-05 (D3, C-04) | **DISEÑO TÉCNICO + contrato observable**, no nuevo principio económico: reintentos deterministas, claves, recibos, idempotencia de anulación | Arquitectura bajo revisión de contrato; autoridad de cambio de firma si procede |
| B-06 (DC05-11/12) | **COMPATIBILIDAD TÉCNICA + preflight de legado**: prohibición de deducir imputación ya surge de ANT-01/DC05-01/02-A; si hay datos reales ambiguos, conciliación explícita de responsable | Arquitectura para migración; responsable ante excepciones comerciales reales |
| B-07 (D7-B, DC-09) | **DIFERIDO**: mantener D7-A hasta una nueva autorización; no habilitar contraaplicación futura por conjetura | Responsable posterior |

**Rectificación de la recomendación inicial B-02:** decir «adicional sin ajuste histórico» sería incorrecto o, como mínimo, equívoco. [REV04B §6](../08-diagramas/consolidacion-b0/CONTRATOS_REV04B_CORREGIDOS_B0_ACTUALIZADO.md) impide **volver a ejecutar** UC-15/UC-16 y modificar los atributos originales del Pedido; **no prohíbe** usar el tipo/porcentaje histórico congelado para calcular la cotización del adicional. La [CR-C #47, §4](https://github.com/leandrito369/ale-milanesas/pull/47) ya propone precisamente ese cálculo y describe D2-A como ratificada, pero la CR permanece **DRAFT y NO AUTORIZADA integralmente**. La regla final debe ser **un único precio final aceptado**, sin aplicar nuevamente el ajuste al contabilizar Entrega. Distinguir la fuerza normativa del contrato G0 de la propuesta de CR-C.

### 9.2 Paquete recomendado R-COM-04, cláusulas sometidas a decisión del responsable

**Naturaleza:** propuestas concretas que **NO quedan aprobadas por publicar este documento**, ni por continuar la auditoría. Solo una ratificación expresa con IDs y alcance puede cambiar su estado. No reabrir DC-01-C1, DC-02-A, DC-04-A, D5-B, ANT-01, D6-1, D7-A, DC05-01/02/03/04/05/06/07/09 ni D12-C.

#### RC-01 — Remanente de reserva al confirmar una Entrega única y parcial (B-01 / DC05-08)

**Propuesta preferente A (no aprobada):**

1. La Entrega valida un cargo real único **C_e**; la porción confirmada y reservada para el Pedido se consolida como **P_e = mínimo(reserva elegible y cargo atribuible real)**, sujeto a que no exista otra aplicación efectiva a esa obligación y a preservación de importes.
2. Si la reserva superaba la porción legalmente imputable al cargo, el remanente **se libera automáticamente** mediante evento IMP-B causado por la misma aceptación de UC-05, **no** mediante nuevo Cobro/Pago/Caja. Conserva su origen y queda como **crédito libre** del mismo Cliente, **solo si** no se encuentra reembolsado, inmovilizado por reembolso o sujeto a otra restricción válida. Si falta evidencia, bloquear/contener sin inventar disponibilidad.
3. No reasignar **explícitamente** el remanente a otro Pedido de manera oculta. Distinguir: al quedar libre, la **política FIFO previamente aprobada DC05-04-B sí puede aplicarlo a deudas existentes**, que es un efecto comercial observable. Si el negocio quiere retenerlo sin FIFO, eso es **alternativa B** que necesita aprobación expresa y un estado diferente, no una simple variante de SQL.
4. La transición reserva→consolidación/liberación se confirma atómicamente con UC-05; si UC-05 falla, todas las porciones vuelven al estado anterior. No se debe crear una «segunda Entrega futura» para consumir la reserva remanente: el modelo G0 usa Entrega definitiva **una por Pedido**.
5. Un Cobro manual general sin reserva continúa conservando su tratamiento; no crear P_e a partir de su idPedido.

**Ejemplo R1:** cobro confirmado de ARS 8.000, reserva explícita a Pedido B ARS 8.000 y cargo real de Entrega definitiva de B ARS 5.000. Aceptando la propuesta A: P_e=5.000; el evento de liberación acredita 3.000 a **disponibilidad libre preexistente**, no crea ingreso ni crédito contable nuevo; podrían consumirse bajo FIFO para deuda A si A existe y cumple reglas vigentes. Una asignación explícita de ese remanente a otro Pedido requeriría acción autorizada.

**Alternativa B:** retener los 3.000 comprometidos hasta liberación ADMIN; reduce automatismo y preserva intención original, pero deja reserva huérfana en Pedido ENTREGADO y exige política de cierre. No confundir con DC05-03-A (liberación ADMIN **excepcional**).

**Pruebas obligatorias:** RCM-01 parcial; RCM-02 Entrega completa; RCM-03 remanente con deuda A; RCM-04 importe reembolsado/pendiente de reembolso; RCM-05 UC-05/UC-06/anulación concurrentes. Reconciliar por Cobro origen: **libre + reservado + aplicado + restricciones/compensaciones = remanente efectivo verificable**, sin doble atribución.

#### RC-02 — Adicional UC-07 aceptado, precio final y entrega parcial (B-02 / DC-03)

**Propuesta preferente A (no aprobada):**

1. Cada adicional está respaldado por la **cotización versionada concreta aceptada** y por su evidencia verificable; la cotización utiliza el **precio base capturado de la oferta** y los **tipo/porcentaje de ajuste históricos del Pedido receptor**, sin reevaluar categoría ni invocar otra vez UC-15/UC-16. Este método está descrito en CR-C #47/CR-F #48; las CR requieren revisión y autorización integral antes de implementarse.
2. **importeAceptado** es el importe comercial final para la **cantidad efectivamente aceptada** de esa versión. **No aplicar de nuevo** el porcentaje comercial histórico ni una promoción sobre dicho importe al formar C_e: equivaldría a duplicar el ajuste, salvo otra política promocional expresamente pactada y versionada para ese adicional.
3. En UC-05, el componente adicional facturable es **solo la cantidad adicional físicamente entregada**, con vínculo a oferta, versión cotizada, evidencia, movimiento de Excedente e imputación técnica; nunca usar íntegro el precio aceptado para unidades no entregadas.
4. Si lo entregado del adicional es **menor** que la cantidad aceptada, **no facturar la fracción faltante**. Propuesta preferente: valorar la fracción entregada **por el mismo precio base histórico y ajuste congelado de la cotización aceptada**, replicando su secuencia de subtotal→ajuste HALF_UP a 2 decimales, sin recalcular precios actuales. Registrar explícitamente la diferencia respecto del importe originalmente aceptado como disminución de unidades entregadas, no como descuento inventado. Para un cambio comercial **previo a la aceptación**, emitir cotización parcial nueva O1 y exigir conformidad del nuevo importe; tras aceptación, una disminución exclusivamente de lo realmente entregado nunca puede aumentar el cargo.
5. Se conserva trazabilidad física de unidades adicionales aceptadas pero **no entregadas**: no desaparecer, no volver a prepararlas ni reutilizarlas automáticamente sin Excedente/movimiento autorizado.
6. **Si CR-C/CR-F y RT-UC07-04 no están autorizadas**, el primer experimento técnico de UC-05 podrá limitarse **a escenarios sin adicionales**, de forma explícita y transitoria. Esto no constituye cierre funcional de UC-05 completo ni reducción permanente de G0.

**Ejemplo R2:** la cotización aceptada de un adicional incluye ARS 125 por su cantidad total y el Cliente lo aceptó. Si se entrega íntegro, el componente adicional es exactamente **125**, sin descuento adicional sobre esos 125. Si se entrega solo una parte, el importe debe derivarse de los datos congelados y la cantidad real, no de precios actuales ni prorrateando ciegamente 125 si ello altera el método de dos redondeos.

**Alternativa B:** exigir nueva cotización y reconfirmación ante cualquier menor cantidad efectiva de adicional, incluso en la Entrega final. Aporta consentimiento explícito, pero puede bloquear la operatoria de reparto; elegir por negocio, no por DDL.

**Riesgo residual:** cotización original con redondeos en 2 decimales y cantidades fraccionarias puede dar resultados distintos al prorratear importe total; la fuente de verdad es la **versión cotizada y fórmula ratificada**, no dividir dinero redondeado. Para adicionales exactamente entregados mantener **igualdad al centavo** con importeAceptado. Pruebas RCM-06..10: cantidad completa, fracción, cotización anterior VERIFICADA y nueva emisión, falta de evidencia, concurrencia de stock/UC-05.

#### RC-03 — Reconocimiento provisional, cargo cero y diferencias (B-03 / DC-06/07/08)

**Propuesta preferente A (no aprobada):**

1. Definir **C_e** por DC-01-C1 + DC-02-A + DC-04-A (cargo sobre cantidades reales y historia, redondeo por base y ajuste agregados). Definir **P_e** exclusivamente como aplicaciones efectivas canónicas de Cobros CONFIRMADOS no ANULADOS, con evidencia IMP-B de la misma obligación, congeladas en el punto transaccional de UC-05.
2. **E_e = max(0, C_e - P_e)**; **V_e^0 = min(D_e, E_e)**, siempre en ARS con escala monetaria 2, una vez probado que P_e, C_e y D_e están completos/coherentes y la operación es serializable. Esta es la variante **V1 de R08.4**, ahora propuesta como política; **NO estaba ratificada**.
3. **D_e** se conserva íntegro incluso cuando supera E_e; **Q_e^decl = max(0, D_e - V_e^0)** como diferencia de declaración no reconocida; sin Cobro, Caja, crédito nuevo ni pago a otra deuda por el excedente.
4. Si **C_e=0 y D_e>0**, propuesta preferente: aceptar la **Entrega comercialmente válida** (cantidades válidas), guardar D_e completo, calcular V_e^0=0 y registrar diferencia D_e, sin contabilizar un Cobro ni reclasificarlo a otra deuda. La recepción física real se resolverá en rendición; alternativa B es rechazar la operación y exige política expresa.
5. Mantener el reconocimiento provisional **solo cuando** el servidor aceptó la Entrega y exista evidencia segura para P_e. Sin evidencia, aplicar **IMP-C** conservando D_e y no generar V_e^0 por conjetura; documentar que el flujo queda pendiente de conciliación y no marcar UC-05 plenamente aceptada.
6. **DC-08 propuesta:** diferencias clasificadas por causa (declarado no reconocido, reconocido pendiente de rendir, faltante constatado y exceso físico recibido); no compensar entre entregas ni Clientes; **no sumar Q_e^rend y Q_e^falt** como si fueran necesariamente conjuntos disjuntos: el faltante puede ser **subconjunto** de lo reconocido aún pendiente. Exigir estados/transiciones que eviten doble exhibición como pérdida total. Arquitectura define estructura de eventos y proyecciones.
7. **V_e^vig = V_e^0 - A_e** para primer corte sin correcciones posteriores autorizadas; cada A_e corresponde a una porción real rendida y confirmada. Al confirmar A_e, **en la misma transacción** retirar igual efecto provisional y registrar los asientos definitivos una vez. Bajo F04-005, un faltante observado no elimina V_e^vig ni restaura deuda al Cliente automáticamente.

**Ejemplo R3 verificado con aritmética decimal:**
- Dos unidades de producto a precio histórico ARS 333,3350 → subtotal exacto 666,6700; base agregada HALF_UP(2)=ARS **666,67**.
- Descuento histórico 10% → ajuste HALF_UP(2)=ARS **66,67**; cargo por unidades originales **600,00**.
- Si un adicional **válidamente aceptado y efectivamente entregado** ya cotizado en **125,00** está autorizado (B-02), el cargo total **C_e=725,00**. No descontar otro 10% sobre los 125,00.
- Anticipo confirmado y aplicado a esta obligación **P_e=650,00**; la declaración de Repartidor **D_e=100,00**.
- **E_e=75,00**; reconocimiento provisional **V_e^0=75,00**; diferencia de declaración **Q_e^decl=25,00**. No crear un Cobro nuevo de 100 al confirmar UC-05.
- Si en rendición el Administrador confirma realmente **50,00** vinculados a esta Entrega, entonces **A_e=50,00**, **V_e^vig=25,00**, y existe un faltante parcial de rendición **25,00** pendiente de conciliación. El saldo confirmado tras Cobro final de 50 y el saldo exigible provisional deben reconciliar, sin recuperar automáticamente esa deuda del Cliente por el faltante.

**Alternativa B:** diferir todo V_e^0 hasta conciliación manual, aun con C_e/P_e demostrados. Menos riesgo ante implementación incompleta, pero incumple la expectativa de reconocimiento provisional automático ya establecida por F04 cuando existen datos válidos. Preferir B solo como **contención no certificada**, no como resultado final funcional.

**Pruebas RCM-11..17:** sin anticipo; total y parcial; V_e=0; D_e superior al pendiente; Cobro anulado; dos Pedidos del Cliente; rendición parcial e intercalado de anulación. El supuesto matemático **0<=P_e<=C_e** debe comprobarse a partir de eventos, no forzarse recortando en silencio una reserva incompatible.

#### RC-04 — Rendición al fin del recorrido, asignación de efectivo, custodia y diferencias (B-04)

**Restricciones aprobadas que NO se vuelven a votar:** RD-F04-002 dispone rendir **al finalizar cada recorrido**; solo ADMINISTRADOR recibe y autoriza. La evidencia mínima **ya está aprobada**: Repartidor, recorrido, instante, importe esperado, importe recibido, diferencia, Administrador; ante diferencia, observación obligatoria y solo ADMIN puede resolver/cerrar con motivo. RD-F04-005 prohíbe restaurar automáticamente deuda del Cliente por faltante. D6-1 sitúa rendición como subflujo de UC-29.

**Propuesta preferente A (no aprobada):**

1. Una **cabecera de rendición por recorrido** agrupa el evento administrativo al finalizar el recorrido, con el mínimo RD-F04-002. Las **aplicaciones de dinero son trazables por Entrega/Cliente**, cada una con autorización y resultado transaccional, sin que un mismo Cobro abarque Clientes diferentes. Admitir **aplicaciones parciales por Entrega dentro del cierre de recorrido**, no declarar nuevos actos independientes de rendición después de cada Entrega.
2. Para una entrega e, importe definitivo por nueva aplicación **a_e,k** debe satisfacer **0<a_e,k<=V_e^vig** y estar respaldado por **efectivo realmente recibido y atribuido verificablemente** a esa entrega, bajo autorización ADMIN. Un importe atribuido a otra entrega/cliente no puede cubrir su V_e.
3. Si el dinero entregado al Administrador es **inferior** a lo esperado, solo la parte efectivamente recibida y atribuible se transforma en Cobro/Caja; el faltante queda pendiente, con evidencia. **No restaurar automáticamente deuda exigible del Cliente**, por RD-F04-005.
4. Si se recibe físicamente **más** que el tramo V_e^vig elegible, **no se convierte el exceso automáticamente** en Cobro, crédito ni Caja por venta. El evento debe distinguir (a) conteo físico/custodia del excedente (b) importe efectivamente aplicado a la obligación (c) causa/destino en conciliación administrativa. **La custodia de efectivo no clasificado no puede quedar invisible**: documentar lugar/responsable de custodia y registrar diferencia, sin inventar una nueva cuenta o movimiento contable hasta regla y CR autorizadas. No declarar «Caja cuadrada» cuando el conteo y los asientos difieren.
5. **Faltante conjunto de recorrido sin atribución por Entrega:** prohibir FIFO/prorrateo automático entre Entregas o Clientes; solicitar detalle y evidencia. La porción no atribuible **no** genera Cobros por persona hasta que ADMIN identifique y autorice su origen. Si la empresa requiere una regla diferente de atribución forzosa, necesita aprobación expresa y trazabilidad.
6. **D9 (BC-07)**: aprobar proyección específica de rendición para ADMIN con cabecera, entregas del recorrido, importes declarados/validados, diferencias, montos aplicados y evidencia mínima; REPARTIDOR ve solo su declaración/acuse; VENDEDOR mantiene exclusivamente UC-14 según G0. **NO conceder UC-14 al ADMIN** ni acceso indiscriminado a Cuenta Corriente.
7. La decisión de **cerrar administrativamente diferencias** deberá distinguir «rendición presentada», «importe aplicado», «diferencia pendiente», «diferencia resuelta con motivo» y «recorrido finalizado». El cierre de recorrido **no** autoriza cerrar sin motivo diferencias monetarias o registrar faltantes como efectivo real.
8. El literal técnico **COBRO.origen** debe pertenecer al CHECK V1 ('REPARTO','ONLINE','ADMINISTRACION'). Arquitectura puede elegir el literal que identifica rendición, pero debe documentar que el vínculo **Cobro↔Rendición** es independiente y no se infiere únicamente del literal.

**Ejemplo R4:** recorrido con Entrega A de Cliente X (V_x^vig=100) y Entrega B de Cliente Y (V_y^vig=150); esperado de reconocimiento 250, efectivo contado físicamente 230. Sin desglose/evidencia de atribución, **no crear arbitrariamente** dos Cobros por 100 y 130, o 92 y 138: eso sería una regla nueva sobre qué Cliente se considera pagado. Se registra diferencia y se exige atribución verificable antes de confirmar las porciones definitivas. La suma de aplicaciones confirmadas nunca puede superar efectivo recibido atribuible y elegible.

**Alternativa B:** rendimiento monolítico indivisible por recorrido. Simplifica ingreso global pero dificulta diferencias por Entrega y viola la necesidad de un vínculo financiero preciso al Cliente si no hay distribución demostrada. No recomendada.

**Subdecisión operativa material aún imprescindible:** ¿Qué hacer físicamente con los importes **recibidos pero no imputables** al finalizar el recorrido? Propuesta conservadora: mantener **custodia y registro administrativo de diferencia no aplicada**, hasta devolverlos contra constancia o atribuirlos mediante acto ADMIN independiente autorizado; no se inventa una cuenta contable ni un estado de Cobro hasta aprobar el mecanismo correspondiente. La empresa debe autorizar explícitamente el procedimiento de custodia/devolución, ya que la seguridad operativa de fondos no es un detalle SQL.

**Pruebas RCM-18..25:** recorrido único, clientes distintos, efectivo parcial atribuido, sin atribución, exceso físicamente recibido, un faltante no revierte automáticamente exigibilidad, visibilidad por rol, repetición e intercalado con Cobro/anulación.

### 9.3 Paquetes sin nueva decisión comercial de fondo

**BT-05 — Reintentos y anulación**: diseño por defecto recomendado (sujeto a revisión contractual) — error **antes de COMMIT** revierte efecto y no consume idempotencia de un comando aceptado; tras COMMIT una solicitud idéntica con la misma identidad y payload obtiene **respuesta histórica** sin segunda escritura; misma identidad con payload distinto responde conflicto; para **anularCobroManual**, reenvío con misma identidad posterior a anulación confirma el recibo original, mientras **nueva intención** de anulación sobre Cobro ya ANULADO sigue rechazada como REV05 A1. Rechazos de seguridad pueden quedar auditados por un canal separado sin consumir clave de operación. No confundir política de seguridad ante abuso con prueba de identidad/idempotencia. Si se cambia firma pública/errores observables o cobertura contractual, revisar contrato y RBAC; Arquitectura decide estructura de recibos, huellas y locks.

**BT-06 — Datos anteriores a IMP-B**: mantener COBRO.idPedido como **referencia informativa**, nunca como prueba de importe aplicado; no inventar registros históricos ni reconstruir importes desde FIFO. Exigir preflight de base destino: conteos de Cobros previos CONFIRMADOS no ANULADOS, pagos/prepagos vivos, referencias idPedido y aplicación verificable por otras evidencias; si el preflight identifica montos heredados con ambigüedad, **detener la transición que los aplicaría** y solicitar conciliación humana/documental, sin inventar datos ni activar V_e^0 con ambigüedad. Si la base está vacía o no tiene compromisos vivos, no forzar migración ficticia de imputaciones. Sin acceso a una BD de destino no se afirma ausencia de datos históricos.

**BT-07 — Futuro**: D7-B/contraaplicación de Cobros de rendición y PE-3/offline **diferidos** conforme D7-A/D12-C; compatibilidad del libro append-only, fuente de aplicación y reintentos se conserva, sin adelantar privilegios ni estados.

### 9.4 Matriz de no-regresión y condiciones de cierre formal

| Control | Invariante exigida | Evidencia futura; NO ejecutada en esta auditoría |
|---|---|---|
| FIN-01 | Un solo Cargo C_e por Entrega real; DC-04-A idéntica a UC-16 | Test decimal de agregado (2,4)→2 HALF_UP, promociones, 100% y entrega completa |
| FIN-02 | Cobro CONFIRMADO genera PAGO/Caja una sola vez; reserva/aplicación no | Asientos por idCobro antes y después de reservar/liberar |
| FIN-03 | Cobro previo no se atribuye a dos Pedidos y reserva no entra al FIFO libre | IMP-T01..20, especialmente T15 y dos Clientes |
| FIN-04 | P_e solo aplica obligación de e; reserva excedente no crea nuevo crédito | RCM-01..05, ajuste de estado y suma de porciones |
| FIN-05 | V_e^0 nunca supera declaración ni pendiente de esa entrega | RCM-11..17, saldo confirmado/provisional |
| FIN-06 | UC-05 no genera Cobro/Caja; rendición convertida extingue provisional mismo tramo | D6-1, pagos parciales, fallo después de cada escritura con rollback |
| FIN-07 | Faltante constatado no restaura automáticamente deuda al Cliente | RCM-18..25; control RD-F04-005 |
| FIN-08 | Exceso D_e preservado no equivale a ingreso o crédito automático | E=0, D>0, rendición con exceso, custodia evidenciada |
| FIN-09 | Adicional UC-07 en C_e exactamente una vez y sin doble ajuste histórico | Cotización V1, O1, aceptación, parcial y C_e; CR-C/CR-F solo tras aprobación |
| FIN-10 | Un mismo comando no duplica efectos; concurrente no rompe serialización | Replays 2 requests, nuevo payload, Testcontainers PG 17.11 y locks C3 |
| FIN-11 | Administrador no obtiene UC-14 y Vendedor no puede rendir | Matriz G0/BC07 y tests HTTP 403 por campo/objeto |
| FIN-12 | Rendición en el cierre de recorrido, sin asignación arbitraria entre Clientes | RD-F04-002, auditoría por recorrido/Entrega/Cliente |
| FIN-13 | Modelo inicial no altera D7-A ni permite D7-B por inercia | Anulación de Cobro general con/sin vínculos, Cobro de rendición siempre protegido |
| FIN-14 | Ningún dato heredado se aplica por conjetura | Preflight, base vacía, Cobro legacy, refund en curso, contención IMP-C |

**Requisitos de revisión antes de aprobar el paquete:**

- **Aprobación comercial:** aceptación/rechazo/modificación expresas de RC-01, RC-02, RC-03 y RC-04 y del procedimiento de custodia. Son **un lote de decisión**, no un lote de implementación.
- **Aprobación editorial:** integrar en paquete E-01..E-07 las cláusulas ya ratificadas y las nuevas **solo después** de aprobación, manteniendo fuentes originales, SHAs, historial y RD/CR.
- **Gate de contrato:** si alguna cláusula contradice CR-C/CR-F o RD-F04, **detener únicamente el área afectada** y conciliar antes de autorizar DDL. El cálculo UC-07 parcial tras aceptación no debe asumirse autorizado por el solo texto de la CR-C.
- **Gate físico:** decisiones comerciales no autorizan V4, migraciones, nuevos permisos, implementación de UC-05/07/29 ni despliegue. La CR-B0-F04-001 online requiere aprobación física independiente.
- **Evidencia:** **ninguno de los casos RCM/FIN se ejecutó aquí**. Los ejemplos R1–R4 son razonamiento de contrato; R3 fue calculado con aritmética decimal, no prueba de servicio.

**Dictamen actualizado:** cuatro unidades de decisión comercial, BT-05/06 técnicos y BT-07 diferido. La principal amenaza de implementación prematura sigue siendo activar V_e^0 / P_e sin imputación explícita validada, doble ajuste comercial de UC-07, o convertir una diferencia de rendición en Caja/Cobro sin identificación y autorización. **Estado global: propuesta lista para revisión, NO ratificada**.


---

## 10. Contraste independiente del informe recibido el 16/11 — G-COM

**Origen:** revisión técnica externa proporcionada por el responsable el 16/11/2026, originalmente realizada sobre una **copia local de** `ale-milanesas-app` y el documento AUD-E3. **Naturaleza:** hallazgos del informe recibidos como evidencia a verificar; **no** son una instrucción de ratificar paquetes ni sustituyen la inspección del GitHub remoto. Las rutas locales `file:///` del informe no son referencias canónicas compartibles.

**Método de verificación:** contraste directo, en esta sesión, con `main` de ambos repositorios y PR #64; lectura de migraciones V1–V3, `source-lock.md`, `RD-MR-PARTIDAS-001`, `AplicarAjusteComercialService`, `CobroManualService`, `EvaluadorCategoriaComercialInterno`, REV04B, REV05, F04. **No** se ejecutó PostgreSQL, JUnit, Testcontainers ni CI en esta revisión.

### 10.1 Tabla de hallazgos y dictamen

| Hallazgo del informe | Dictamen contrastado | Acción de gobierno |
|---|---|---|
| I-01 — «V1/V2 son únicas migraciones; V3 reservada, no aplicada» | **DESACTUALIZADO / INCORRECTO PARA `main` REMOTO:** existe [V3__trazabilidad_partidas_insumo.sql](https://github.com/leandrito369/ale-milanesas-app/blob/main/src/main/resources/db/migration/V3__trazabilidad_partidas_insumo.sql), con dos nuevas tablas; [source-lock](https://github.com/leandrito369/ale-milanesas-app/blob/main/docs/traceability/source-lock.md) incluye adenda RD-MR-PARTIDAS-001; gobierno [RD-MR-PARTIDAS-001](b0/RD_MR_PARTIDAS_001_AMPLIACION_MR_PARTIDA_INSUMO_2026-11-06.md) ratifica MR-6. **62 tablas = esquema definido por cadena V1→V2→V3**. No hay evidencia aquí de aplicación en producción; despliegue pausado. El antiguo documento 05/11 era un snapshot «propuesta». | Mantener redacción 62 tablas y V3 existente; la **próxima migración candidata es V4**, previa verificación de secuencia y gate, **no crearla aquí**. Corregir notas históricas si se utilizan como estado actual. |
| I-02 — UC-16 redondea en dos fases y consulta política/categoría actual | **CONFIRMADO** en [AplicarAjusteComercialService.java](https://github.com/leandrito369/ale-milanesas-app/blob/main/src/main/java/ar/edu/unam/alemilanesas/finanzas/AplicarAjusteComercialService.java). | Arquitectura podrá extraer cálculo puro con atributos congelados; no invocar el servicio UC-16 actual para recalcular una Entrega histórica. Tests de paridad centavo a centavo. |
| I-03 — UC-15 mantiene FIFO global de créditos sin atribución por obligación | **CONFIRMADO COMO LIMITACIÓN DEL SERVICIO ACTUAL** en [EvaluadorCategoriaComercialInterno.java](https://github.com/leandrito369/ale-milanesas-app/blob/main/src/main/java/ar/edu/unam/alemilanesas/finanzas/EvaluadorCategoriaComercialInterno.java), antes de implementar IMP-B. | Contrato DC05-04-B requiere «explícitas vigentes primero, FIFO solo libre». Diseñar transición y regresión; no declarar bug ya ejecutado en UC-05 ausente. |
| I-04 — Anulación: Java filtra origen, SQL no veta por `REPARTO` ni aplicación/rendición | **CONFIRMADO:** [CobroManualService.java](https://github.com/leandrito369/ale-milanesas-app/blob/main/src/main/java/ar/edu/unam/alemilanesas/finanzas/CobroManualService.java) exige `ADMINISTRACION`; función `fn_mr3_anular_cobro_manual` en [V1](https://github.com/leandrito369/ale-milanesas-app/blob/main/src/main/resources/db/migration/V1__baseline_mr5.sql) veta `ONLINE/MERCADOPAGO` pero no `REPARTO` ni IMP-B (inexistente). | Extender guardas transaccionales en **migración futura nueva**, con vínculo explícito, sin editar V1; preservar anulación general válida y D7-A. Revisar idempotencia de anulación. |
| I-05 — OFERTA_EXCEDENTE no conserva precio base; adicional apunta a DETALLE_ENTREGA | **CONFIRMADO EN V1.** Pero la sugerencia «crear DETALLE_ENTREGA ficticio con cantidad cero» **NO ES SUFICIENTE** si no existe `DETALLE_PEDIDO` de ese producto: hay FK `DETALLE_ENTREGA(idPedido,numeroDetalle)→DETALLE_PEDIDO`. En V1, `DETALLE_PEDIDO.cantidadOriginal=0` es estructuralmente posible con precio nulo, pero **crear una línea original técnica nueva** puede alterar semántica del Pedido y requiere decisión/CR. | CR-C/CR-F deben cerrar representación de producto adicional ausente en Pedido receptor, vínculo de producto, cantidad entregada, importe y costo, sin líneas «originales» ficticias ni cambio a totalOriginal por inferencia. |
| I-06 — advisory locks y MAX+1 deben armonizarse | **RIESGO TÉCNICO REAL, NO DEFECTO GLOBAL AUTOMÁTICAMENTE DEMOSTRADO.** Cobro tiene advisory global propio; UC-15 y anulaciones tienen orden de filas cruzado; otros escritores futuros no están cubiertos por ese único mutex. | Diseñar **grafo real** de adquisición de locks con todos los escritores y probar intercalados PG; **no ratificar** el orden ejemplo del informe (CLIENTE→PEDIDO→COBRO→POLITICA) sin test y sin comprobar orden en las funciones SQL. No cambiar solo por preferencia `MAX+1` a secuencias sin análisis de compatibilidad. |
| I-07 — Informe recomienda aprobar RC-01..04 y BT-05..07 | **RECOMENDACIÓN, NO ACTO DE APROBACIÓN.** Los acuerdos anteriores se conservan, nuevas decisiones siguen propuestas. | Preparar una resolución G-COM para aprobación expresa del responsable; no marcar `APROBADO` ni modificar G0/REV/BC07/CR o app por esta revisión. |

### 10.2 Bloqueante semántico adicional no resuelto por el informe: saldo libre confirmado y `V_e^0`

**CRÍTICO — CONTRAEJEMPLO DE CONSISTENCIA COMERCIAL A DECIDIR DENTRO DE RC-03.**

**Hechos expresos ya aprobados:** DC05-04-B: las aplicaciones monetarias explícitas se atienden primero; los créditos confirmados **libres** entran a FIFO para evaluar deuda/mora por obligación. DC05-01/02-A: la reserva del anticipo no equivale a `P_e` hasta su consolidación. R08.4 y AUD-E3 definen `P_e` como **aplicación explícita efectiva, probada y atribuida** a la Entrega.

**Escenario de prueba SEM-01 (no ejecutado):**
1. Cliente sin deuda pendiente y con **ARS 100** de crédito general confirmado y **libre**, no reservado a ningún Pedido.
2. Al registrar una nueva Entrega, el cargo real congelado es `C_e=ARS 100` y el Repartidor declara `D_e=ARS 100`.
3. No hay reserva/imputación explícita a esa Entrega, por lo que, bajo la definición estricta de R08.4, `P_e=0`.
4. La fórmula candidata V1 produce `E_e=100` y `V_e^0=100`.
5. Sin embargo, si conforme a DC05-04-B el FIFO libre de ARS 100 **efectivamente cubre la obligación comercial de esta Entrega** al crear su cargo, el pendiente de e ya es `0` y el reconocimiento provisional `100` le atribuye un nuevo pago al Cliente sin deuda elegible, a pesar de que D2=B impide crédito automático por exceso. El `saldoConfirmado` global tras el cargo sería `0` y `saldoExigibleProvisional` proyectado podría aparecer artificialmente a favor.

**No es un fallo de código demostrado:** la condición depende de **qué significa jurídicamente que el FIFO «cubra» una obligación**: aplicación comercial efectiva vs mera herramienta de categoría/mora. **No aprobar todavía RC-03/V1 sin aclararlo.**

**Subdecisión RC-03-FIFO (responsable):** ¿El crédito confirmado libre aplicado por FIFO a una obligación de Entrega reduce también su pendiente elegible para reconocimiento provisional?

- **A — Consistencia por obligación (RECOMENDADA, NO APROBADA):** sí. La fórmula requiere tomar el **total de cobertura confirmada y acreditada a esa Entrega**, incluidas aplicaciones explícitas y porciones libres realmente consumidas por FIFO, sin doble conteo. El algoritmo y evidencia canónica deben distinguir `P_e^expl` y `F_e^FIFO` (nombres de trabajo, no columnas): `E_e = max(0, C_e - P_e^expl - F_e^FIFO)`; `V_e^0=min(D_e,E_e)`. `F_e^FIFO` no es un nuevo Cobro ni crédito: es una atribución auditable del **mismo importe confirmado libre**, y debe ser compatible con el evaluador UC-15, anticipo y anulación. **No persistir un segundo movimiento PAGO por atribuirlo**. Si ya está comprendido en P_e, no restarlo otra vez.
- **B — Separación jurídica explícita:** FIFO sirve **solo** para categoría/mora, y no cancela obligación individual a efectos de elegibilidad de `V_e`. Entonces se debe documentar que el «saldo deudor por obligación» y la categoría comercial difieren por diseño, con casos de saldo general a favor, y justificar por qué D_e puede reconocerse mientras hay crédito libre. No inferir esta opción solo desde el servicio actual.

**Controles:** SEM-01 crédito libre de igual importe, SEM-02 crédito libre menor, SEM-03 crédito libre ya destinado a deuda anterior, SEM-04 crédito reservado a otro Pedido, SEM-05 liberación automática RC-01 con FIFO y actualización simultánea de UC-15, SEM-06 anulación/reembolso, SEM-07 dos Entregas concurrentes de un mismo Cliente. Si se ratifica A, ajustar DC-06 y RC-03 preservando el alcance de `ANT-01` y `DC05-04-B`; si B, justificar explícitamente su coexistencia y la visualización de exigibilidad.

### 10.3 Otras reservas necesarias antes de ratificar

1. **Legado (BT-06):** encontrar en preflight un Cobro `CONFIRMADO` anterior **no prueba automáticamente un anticipo vivo** ni justifica bloquear toda la base. La condición es **existencia de imputación/obligación viva ambigua con efectos posibles**. Verificar saldos y trazas sin reconstruir imputación por `COBRO.idPedido` o FIFO. No afirmar que la base real está vacía: solo se sabe que el despliegue está pausado.
2. **C-08 / RD-F04-006:** su postergación es admisible **solo mientras no se active el tránsito provisional que debe considerarse en UC-03**. Una vez activado ese tránsito, UC-03 deberá contemplarlo según su RD aprobada; no tratar el caso como deuda técnica sin fecha indefinida.
3. **UC-07 y nueva cotización:** el método de cotización histórica de CR-C #47 permite no aplicar el porcentaje dos veces, pero su **autorización integral sigue pendiente**. La modificación de cantidad aceptada/entregada y la eventual creación de líneas técnicas deben superar primero el contrato, la seguridad y la consistencia física con CR-F y RT-UC07-04.
4. **Dinero excedente recibido físicamente:** no basta registrar solo una diferencia virtual. Debe existir trazabilidad de recepción, custodia, responsable y posterior devolución o atribución; el instrumento contable exacto no está ratificado. No afirmar «fuera de toda contabilidad» como norma: distinguir **Caja de ventas** de **custodia de fondos pendiente de clasificación**, sometiendo su tratamiento a decisión comercial/contable.
5. **Anulación de Cobro:** la función SQL V1 **sí contiene** enmiendas MR3-07 anteriores al trigger, que amplían `MOVIMIENTO_CUENTA` a `ANULACION_COBRO`, agregan `idCobroAnulado` y amplían el catálogo de origen de Caja. Leer la migración **completa** antes de afirmar que el trigger generaría un movimiento rechazado por el CHECK inicialmente declarado. La brecha confirmada es la falta de guardas sobre relación de rendición/IMP, no incompatibilidad de tipo en su propia V1.

### 10.4 Acta G-COM: **borrador de resolución, pendiente de ratificación expresa**

| Entrada | Estado tras contraste | Recomendación para voto de negocio |
|---|---|---|
| RC-01 — remanente parcial | **PROPUESTA** | A, liberar remanente no elegible atómicamente y volverlo libre bajo reglas de reembolso/FIFO |
| RC-02 — cotización/adicional UC-07 | **PROPUESTA** | A, una cotización final aceptada con ajuste histórico una sola vez; cantidades realmente entregadas y traza de no entregadas; CR-C/CR-F pendientes |
| RC-03 — fórmula V1 | **RETENIDA POR SEM-01** | Adoptar solo después de resolver **RC-03-FIFO**; D2=B, cargo cero y Q tipada pueden ratificarse por separado |
| RC-04 — rendición/custodia/BC07 | **PROPUESTA** | Cabecera por recorrido, imputación por Entrega y Cliente, no prorratear faltantes, custodiar exceso con registro y proyección acotada ADMIN |
| BT-05 — idempotencia | **CONTRATO OBSERVABLE, PENDIENTE** | Reintento mismo payload/clave devuelve recibo, clave distinta es operación distinta; idempotencia de anulación sin alterar permisos |
| BT-06 — legado | **PRECONDICIÓN DE ARQUITECTURA** | No inferir imputaciones, preflight selectivo por compromisos vivos, contención ante ambigüedad |
| BT-07 — diferimiento | **CONTENCIÓN DOCUMENTADA** | Mantener D7-A y PE-3 diferida; C-08 pasa a requisito antes de activar tránsito provisional |
| E-01..E-07 | **NO AUTORIZADAS PARA EDICIÓN CANÓNICA** | Aprobación editorial específica tras resolver RC-01/02/03/04 y sus dependencias |

**Puertas explícitas:** G-COM no alcanzada; G-CON (enmiendas REV04B/REV05) no autorizada; G-ARQ solo revisión documental/escenarios; G-FIS (DDL, migración, datos) y G-DEV (código) no autorizadas. Ningún consentimiento para reanudar el despliegue: [app Issue #28](https://github.com/leandrito369/ale-milanesas-app/issues/28) **abierta**.

**Cómo aprobar correctamente:** el responsable debe confirmar por escrito las cláusulas comerciales, **incluida RC-03-FIFO**, y aceptar expresamente los límites de RC-02/04. Una recomendación de un informe cargado al chat no sustituye esa aprobación. Tras ello, elaborar acta G-COM con fecha/autoridad/alternativas descartadas, aprobar el único paquete E-01..07 y mantener CR física independiente.

---

## 11. Resolución expresa del responsable — RC-03-FIFO (16/11/2026)

**ID de decisión:** `DC-COM-FIFO-001` (identificador de seguimiento dentro de **AUD-E3-COM-001**; no crea nuevo CU ni renumera G0).  
**Fecha:** 16/11/2026 (Argentina).  
**Autoridad:** confirmación expresa del responsable del proyecto en conversación, ante la pregunta: «¿Confirmás que, cuando el crédito confirmado libre se aplica mediante FIFO a una Entrega, también debe reducir el importe pendiente elegible para reconocer el efectivo declarado por el Repartidor?».  
**Respuesta:** «Lo confirmo».  
**Estado:** **APROBADA FUNCIONALMENTE POR EL RESPONSABLE — PENDIENTE DE INTEGRACIÓN DOCUMENTAL**, sin autoridad física. Se registra **solo esta subdecisión** dentro de la PR #64 OPEN/DRAFT. La versión previa, §10.2/10.4, queda como **historial del problema antes de la resolución**, no como estado vigente de esta subdecisión.

### 11.1 Regla comercial aprobada

**El crédito confirmado y libre que se aplica de forma efectiva y demostrable mediante FIFO a la obligación de una Entrega también reduce el saldo elegible de esa Entrega para reconocer dinero declarado por el Repartidor.** Los créditos explícitamente aplicados o reservados para **otra** obligación no integran el FIFO libre de esta Entrega.

Reglas de alcance:

1. **Sin doble cobertura.** Una misma porción de un Cobro confirmado, no anulado y no reembolsado nunca puede aplicarse por reserva/imputación explícita y por FIFO simultáneamente, ni cubrir dos Entregas. Los importes bloqueados por reserva, aplicación previa o reembolso no se consideran crédito libre.
2. **Identidad por obligación.** Solo cuenta el FIFO **realmente atribuido y registrado con evidencia auditada a la Entrega e**, no el saldo global del Cliente, una simple simulación en `UC-15`, `COBRO.idPedido`, una consulta FIFO sin asiento vinculante o la existencia de un Cobro confirmado. La decisión comercial **no convierte automáticamente el evaluador global existente en evidencia financiera canónica**.
3. **Precedencia.** Mantener `DC05-04-B`: primero las imputaciones explícitas vigentes; FIFO únicamente sobre remanente libre realmente elegible, según la misma política determinista. No alterar la histórica condición comercial del Pedido ni recalcular su precio.
4. **Naturaleza del hecho.** Aplicar por FIFO una porción de crédito **ya cobrado** no crea un Cobro, no genera segundo `MOVIMIENTO_CUENTA(PAGO)` ni nuevo `MOVIMIENTO_CAJA`. Debe conservarse su procedencia y el vínculo a obligación/importe/instante.
5. **Anulación y carreras.** Si un Cobro se anula o restringe antes del punto transaccional válido, su porción deja de ser elegible; anulación, refund, reservas, Entrega y rendición deben serializarse para evitar reconstruir una situación monetaria obsoleta.
6. **Sin evidencia, sin reconocimiento inventado.** Si la atribución concreta del FIFO o el origen de los fondos es ambiguo, aplicar contención `IMP-C` y registrar la discrepancia. Ningún algoritmo puede deducir aplicación a partir de `idPedido` o de saldos agregados.

### 11.2 Notación propuesta para contrato integrado — alcance matemático de la decisión

La notación mantiene **separada** la definición previa `P_e` de R08.4/AUD-E3 como porciones explícitas acreditadas; no se redefine silenciosamente:

- `P_e^{exp}`: importe confirmado **explícitamente aplicado** a la obligación de Entrega `e` (incluida consolidación de una reserva previa, cuando corresponda).
- `F_e^{FIFO}`: importe de crédito confirmado **libre** atribuido **efectivamente y de manera auditable** por FIFO a la misma obligación `e`, sin superponerse con `P_e^{exp}` ni con otras aplicaciones.
- `K_e = P_e^{exp} + F_e^{FIFO}`: cobertura confirmada efectiva total de esa obligación. Invariante: `0 <= K_e <= C_e`, con no superposición de importes.
- `E_e = max(0, C_e - K_e)`: pendiente elegible comercial tras cobertura confirmada.

**Efecto aprobado:** para reconocer efectivo en tránsito **no puede utilizarse una base de pendiente mayor que `E_e` que ignore `F_e^{FIFO}` efectivamente aplicado**.

**Importante:** `V_e^0 = min(D_e,E_e)` sigue siendo **la fórmula completa candidata** de `RC-03/DC-06`, no ratificada integralmente por esta respuesta. También siguen abiertas `DC-07` (cargo cero) y `DC-08` (diferencias tipadas); `D2=B/EX-01` requiere el asiento editorial correspondiente. No inferir aprobación de `RC-01`, `RC-02`, `RC-04` ni de `BT-05/BT-06`/paquete `E-01..E-07`.

### 11.3 Casos normativos de contraste (diseñados; no ejecutados)

| Caso | `C_e` | `P_e^{exp}` | `F_e^{FIFO}` acreditado | `D_e` | `E_e` correcto | Límite de reconocimiento provisional |
|---|---:|---:|---:|---:|---:|---|
| **SEM-01**: crédito general libre cubre todo | 100,00 | 0,00 | 100,00 | 100,00 | 0,00 | 0,00; no reconocer el mismo dinero dos veces |
| SEM-02: crédito libre cubre parte | 100,00 | 0,00 | 40,00 | 80,00 | 60,00 | Como máximo 60,00 |
| SEM-03: explícito y FIFO, sin superposición | 100,00 | 30,00 | 20,00 | 70,00 | 50,00 | Como máximo 50,00 |
| SEM-04: crédito ajeno reservado, no libre | 100,00 | 0,00 | 0,00 | 70,00 | 100,00 | Como máximo 70,00, sujeto a RC-03 |
| SEM-05: consulta FIFO estimativa sin aplicación real probada | 100,00 | 0,00 | **no acreditado** | 70,00 | **no acreditable** | `IMP-C`, sin reconocimiento automático |

**No contabilizar valores candidatos como Cobro.** La cobertura del caso SEM-01 no significa que los ARS 100 físicamente declarados deban ocultarse: `D_e` se conserva íntegro y la diferencia requiere clasificación y rendición aún pendientes.

### 11.4 Dependencias y acciones autorizadas

- **G-COM:** la **subdecisión RC-03-FIFO se considera resuelta funcionalmente**. Quedan abiertos los demás extremos de RC-03 y las restantes cláusulas comerciales. En el acta integral G-COM se incluirá esta decisión por referencia, **sin volver a someterla a aprobación**.
- **G-CON:** preparar enmiendas a las operaciones `UC-05`, `UC-15`, `UC-29`, y las proyecciones derivadas `UC-14/BC07`, para que su contrato distinga aplicaciones explícitas, FIFO efectivamente aplicado y saldo confirmado/provisional. **No editar aún documentos canónicos por esta sola decisión.**
- **G-ARQ:** seleccionar y probar representación de `F_e^{FIFO}` en la fuente canónica `IMP-B` y la proyección `IMP-A`, con secuencia explícita de locks y replay determinista. La aprobación funcional no fija columnas, SQL, ni el formato de la API.
- **G-FIS / G-DEV:** **NO AUTORIZADAS** por esta resolución. No crear/modificar V4, V1–V3, producción, credenciales, RBAC ni desplegar. Issue app #28 sigue abierta; entorno pausado.

**Trazabilidad:** propuesta inicial SEM-01 §10.2 y alternativas A/B; resolución A expresamente confirmada por el responsable el 16/11/2026. **Alternativa B descartada funcionalmente:** usar FIFO solo como criterio de mora **cuando ese mismo crédito ya fue aplicado de manera efectiva** a la Entrega; no habilita un segundo reconocimiento provisional por la misma obligación.
