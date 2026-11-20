# RD-I302-009 — D12-C: CR-B0-F04-001 articulada por fases online y offline

**Fecha:** 15/11/2026.  
**Estado funcional de D12-C:** **APROBADA EXPRESAMENTE por el responsable del proyecto**.  
**Estado de esta propuesta documental:** **PR OPEN / DRAFT / NO MERGE**.  
**Estado de CR-B0-F04-001:** **ABIERTA / ANÁLISIS / NO RATIFICADA FÍSICAMENTE**, sin cambio automático de estado.  
**Gobierno main de referencia:** `cdd57ed194268f1f5ab29aa0f55781ddddebdfb5`. **Aplicación main de referencia:** `4dbe38668fc5cbc08d04e10920e3bf165c71be11`.  
**Fuentes:** `docs/01-gobierno/b0/CR_B0_F04_001_DISENO_FISICO_SINCRONIZACION_PENDIENTE_2026-10-29.md` (main); PR #52 R08.3 @ `adf77bc2c4f3d7e88a1c301926bdd607dd6a4a78`; PR #53 R08.4 @ `7448e123c3c43c51d48def6a22d10b58679efb2d`; PR #54 R08.5-C @ `cc948fcde1ac2dbfe0a78febff6fd2326b8de258`; PR #55 a #60 (decisiones DC05-04-B, DC05-01/02-A, DC05-03-A, DC05-05/06-A, DC05-07-A y DC05-09-A); RD-F04-001..007, contratos REV04B/REV05, G0/RBAC.

## 1. Decisión expresa del responsable

**D12-C — APROBADA (15/11/2026):**

> Mantener **CR-B0-F04-001** como solicitud de cambio **articulada por fases**, con un **alcance online prioritario e integrado de PE-1 + PE-2 + IMP-01**, y una **fase offline PE-3 diferida**, conservando trazabilidad común F04/S-01 y exigiendo **autorización específica e independiente por fase**. **Esta aprobación de división del trabajo no autoriza DDL, migraciones, experimentación física ni implementación**.

**No elegidas:** D12-A (bloquear toda la CR hasta completar PE-3); D12-B (partir la gobernanza en CR formalmente independientes e inconexas). En D12-C se conserva el identificador común **CR-B0-F04-001**, con alcances y gates explícitos; no se presume crear nuevas CR por sí sola.

## 2. Alcances separados y sus gates

| Fase | Alcance mínimo a diseñar conjuntamente | Entrada necesaria | Puerta de aprobación independiente | Estado |
|---|---|---|---|---|
| **ONLINE PRIORITARIA** | **PE-1:** UC-05 entrega online, declaración íntegra `D_e`, validación central, cargo `C_e`, reconocimiento `V_e`, idempotencia. **PE-2:** rendición ADMIN en UC-29, enlace de declaración/Entrega con Cobro confirmado, cese atómico de tránsito, diferencias, guarda D7-A. **IMP-01:** libro canónico IMP-B + proyección activa IMP-A y contención IMP-C, reservas, aplicaciones, liberaciones y guardia DC05-07-A. | Decisiones numéricas CAL-01/CAL-02, parciales DC05-08, semántica contratos REV04B/REV05, D6-1/DEC-GRAN-D6, D9, D10, pruebas y protocolo C3. | **Primero** contrato/diseño R08.6 documental ratificado y **después**, por autorización humana expresa, diseño SQL, laboratorio PG efímero, migración y R09 en cortes separados. | **Solo diseño conceptual autorizado; SQL/R09 BLOQUEADOS** |
| **OFFLINE DIFERIDA** | **PE-3:** cola Android/Room para captura UC-03/UC-05, contrato S-01, inbox/verificación del servidor, recuperación de conectividad, reenvíos, conflictos e identidad UUID original. | Contrato S-01, seguridad, datos personales, revocación de permisos/asignaciones, estrategia de recuperación, integración con online ya aprobada. | **Revisión y autorización propia** de esquema/protocolo offline, pruebas de reenvío/duplicación y liberación posterior sin alterar decisiones F04. | **DIFERIDA; NO AUTORIZADA** |

**No se implementa un PE-1 aislado que deje efectivo en tránsito sin ruta de rendición ni evidencia de anticipos.** La prioridad online significa **diseñar de forma integrada** PE-1, PE-2 e IMP-01 y autorizar/implementar sus incrementos cuando superen sus respectivas puertas; no habilitar escrituras aisladas antes del cierre seguro.

**Compatibilidad futura:** la identidad de origen, semántica de replay, snapshots y contratos online deben ser compatibles con futura captura offline. PE-3 podrá tener gates distintos, pero no debe exigir romper `UC-05` ya ratificado ni reescribir una transacción online con una segunda contabilidad.

## 3. Decisiones ya funcionalmente aprobadas y límites de la fase online

| ID | Regla que debe preservar el diseño |
|---|---|
| D5-B / ANT-01 | Efectivo de entrega actual solamente; descontar anticipos **confirmados y efectivamente aplicados** a esa obligación, jamás saldo global ni `COBRO.idPedido` aislado |
| D6-1 | Rendición como subflujo UC-29 exclusivo del ADMINISTRADOR, sin conceder UC-14 al ADMIN |
| D7-A | Bloqueo de anulación de Cobros vinculados a rendición, distinto del bloqueo DC05-07-A |
| DC05-01/02-A (PR #56) | Reserva previa por Pedido, excluida de FIFO libre; consolidar solo porción elegible al confirmar Entrega |
| DC05-03-A (PR #57) | ADMIN/VENDEDOR crean reserva junto con Cobro manual autorizado; solo ADMIN corrige/libera excepcionalmente; requiere permisos y contratos explícitos |
| DC05-04-B (PR #55) | Imputaciones explícitas primero al evaluar deuda/mora, FIFO solo para créditos libres |
| DC05-05/06-A (PR #58) | UC-06 libera automáticamente reservas elegibles a crédito libre sin duplicar Cobro/Caja ni reasignación **explícita** automática |
| DC05-07-A (PR #59) | Bloquear anulación de Cobro manual general con reservas/aplicaciones activas hasta regularización; conservar anulación sin vínculos |
| DC05-09-A (PR #60) | IMP-B append-only fuente canónica; IMP-A proyección activa; IMP-C solo contención sin reconocer `V_e^0` por conjetura |

## 4. Puertas aún bloqueantes para R08.6 físico y R09

1. **Cálculo comercial:** DC-01/DC-02/DC-03/DC-04 (precisión, ajuste, promociones históricas, adicionales UC-07), DC05-08 (remanente en parcial), DC-06 (fórmula de `V_e^0`); ninguna fórmula aprobada por D12-C.
2. **Rendición:** DEC-GRAN-D6, D4, D9/BC-07, D10/errores `Q_e`, diferencia `D56-09` y `COBRO.origen` efectivo conforme V1 y REV05.
3. **Integridad/concurrencia:** DC05-10/DC-10 (orden de locks, versiones, snapshot), DC05-11/12 (semántica informativa de `COBRO.idPedido`, tratamiento de Cobros históricos sin evidencia); idempotencia D3 y C-04.
4. **Gobierno contractual:** conciliación E-01..E-07 sobre REV04B, REV05, RD-I302-001, RBAC/G0 con decisiones ratificadas, y autorización específica de propuesta física bajo **CR-B0-F04-001**, sin inferirlo de una PR documental.
5. **Integración:** PR #47/#48 UC-07 aún draft y prueba H/RT-UC07-04 no cerrada; PR app #91 puede incidir en `CobroManualService`/protocolo C3. No crear rutas incompatibles ni deducir cierres.

## 5. Plan por etapas propuesto (no orden de implementación ejecutado)

- **P1:** fijar algoritmo de `C_e` y ajuste/redondeo; parciales y UC-07; decidir `V_e`, diferencias y unidad de rendición.
- **R08.5 conciliación final:** actualizar contratos REV04B/REV05 y RD-I302-001, y matrices BC-07/RBAC bajo autorización documental explícita; mantener G0 source-lock hasta CR separada cuando corresponda.
- **R08.6 documental condicionado:** elaborar esquema candidato integrado PE-1/PE-2/IMP-01, constraints, índices, concurrencia, idempotencia, plan de pruebas/migración, sin SQL ejecutable.
- **Puerta humana física:** propuesta aprobada en CR-B0-F04-001, autorización de laboratorio PG efímero y luego migración/implementación bajo nuevas aprobaciones y CI; sin despliegue mientras Issue app #28 esté abierta.
- **PE-3 offline:** corte posterior bajo S-01/Android/Room/inbox con pruebas propias; no se declara cerrado por completar online.

## 6. Evidencia futura de aceptación (NO EJECUTADA)

| Test | Exigencia |
|---|---|
| T01–T30 R08.4 | Cálculo por Entrega, parciales, cargo cero, declaración íntegra, V_e, rendición e idempotencia |
| IMP-T01..T20 / PER / LIB / ANU | Aplicación explícita, libro/proyección, reservas, anulación, liberación, permisos y conservación de fondos |
| C3/PG17.11 | SQLSTATE, locks, reintentos, rollback completo, sin sobreaplicación ni deadlocks 40P01 |
| S-01/PE-3 posterior | Replays offline/reconexión y revocaciones, nunca doble Entrega/Cobro/Caja |

### Dictamen

**D12-C es decisión funcional de partición y orden de tratamiento.** La **CR-B0-F04-001 continúa ABIERTA**. Ni esta PR ni el hecho de priorizar online ratifican esquema, firmas, RBAC, G0, Java, SQL, tablas, DDL, migración Flyway, ensayos físicos, producción, ni despliegue. No autorizar merge sin revisión y conciliación documental.
