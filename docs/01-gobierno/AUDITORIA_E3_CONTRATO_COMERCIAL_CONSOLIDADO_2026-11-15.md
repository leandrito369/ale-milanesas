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
| **B-02 Adicionales UC-07** | `DC-03`, parte UC-07 de `DC05-08` | ¿Adicional aceptado lleva precio/cotización propia sin ajuste/promoción histórica del Pedido o entra a esa base? ¿Qué ocurre si aún no está habilitada UC-07? | Valorar adicional por snapshot/aceptación propia; evaluar política de ajuste separada sin presumirla. Si no autorizado, excluir **solo escenarios con adicional** del corte técnico inicial, sin declarar UC-07 completo. | **P0** para Entrega con adicionales; diferible en flujo sin UC-07 |
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
