# F04 — Análisis de sincronización offline (S-01)

**Fecha:** 26/10/2026. **Estado:** RD-F04-001 **APROBADA** para el alcance UC-03/05/43; diseño e implementación F04 todavía **PENDIENTES**.  
**Seguimiento:** [Issue #6](https://github.com/leandrito369/ale-milanesas/issues/6); [RD-F04-001](../01-gobierno/RD_F04_001_ALCANCE_OFFLINE_2026-10-26.md). El primer intento de crear un Issue devolvió HTTP 410; tras habilitar el servicio, se creó el Issue #6 correctamente.

## Fuentes vigentes

- `AGENTS.md`, `docs/ESTADO_ACTUAL.md`.
- `docs/05-modelo-relacional/MR5_CONTRATOS_SERVICIOS.md`, sección S-01.
- `docs/01-gobierno/RP_01_REGISTRO_PENDIENTES_v1.1_2026-10-25.md` (RP-003, RP-006, RP-007, RP-009).
- `docs/01-gobierno/RD_F01_ESTADOS_COBRO_2026-10-26.md`.
- **Decisión aprobada 26/10:** [RD-F04-001](../01-gobierno/RD_F04_001_ALCANCE_OFFLINE_2026-10-26.md): UC-03/UC-05 capturables offline; UC-43 exclusivamente online.
- MR4-F04: integración offline y verificación de permisos/snapshots todavía no implementadas.

## Reglas ya establecidas

1. La operación capturada debe poseer un identificador UUID inmutable, usuario autenticado, marca temporal, referencia al Pedido/asignación si corresponde, y condiciones e importes congelados.
2. Idempotencia de extremo a extremo: el mismo evento reintentado no genera dos Pedidos, Entregas, Cobros ni efectos Caja/Cuenta Corriente.
3. Validar habilitación, asignación, vigencias y autorización al aplicar la operación; conflicto explícito si cambian de forma incompatible. No conceder permisos retroactivos.
4. El Repartidor no obtiene permiso directo para UC-29 por registrar una Entrega. RD-F04-004 sí autoriza declarar efectivo recibido como información ligada a UC-05, incluso offline, con validación remota previa al efecto provisional. Los cobros definitivos requieren autorización del Administrador.
5. `COBRO.estadoCobro` tiene solamente `CONFIRMADO` y `ANULADO`, conforme a RD-F01. Una captura offline pendiente de sincronizar permanece fuera de COBRO y no materializa efectos financieros.
6. La persistencia de eventos de entrada, snapshots y conciliación es una **brecha de implementación**. MR-6 validó restricciones físicas seleccionadas, no un servicio offline.

## Matriz de alcance — decisión funcional aprobada (RD-F04-001)

| CU | Evento | Estado de captura | Aplicación central y límites |
|---|---|---|---|
| UC-03 | Cargar Pedido | **OFFLINE PERMITIDA** | Se registra como captura local pendiente; el servidor debe revalidar permiso, datos y condiciones antes de confirmar. Conflictos de stock, precios o vigencia se tratan explícitamente; la política detallada sigue pendiente. |
| UC-05 | Registrar Entrega | **OFFLINE PERMITIDA** | Se registra captura local pendiente; solo el servidor confirma la aplicación tras validar Pedido y asignación. Puede incluir declaración de efectivo recibido según RD-F04-004; no implica registrar Cobro ni Caja. |
| UC-29 | Registrar Cobro | **NO DEFINIDA por RD-F04-001** | Se conserva el RBAC existente: Repartidor sin permiso directo. El Administrador recibe y autoriza la rendición de efectivo (RD-F04-002). Si hay diferencias, el Administrador las registra y deja la rendición pendiente de conciliación, sin confirmar importes no recibidos. Evidencias y permisos generales UC-29 pendientes (RP-006/RP-007). |
| UC-43 | Gestionar asignación de reparto | **EXCLUSIVAMENTE ONLINE** | La creación, cambio y reasignación necesitan conectividad con servidor; no se autorizan colas de asignación offline. |

## Escenarios obligatorios de diseño y prueba

- **Doble envío:** mismo UUID en dos sesiones simultáneas ⇒ una aplicación monetaria.
- **Pérdida de conexión:** respuesta perdida tras COMMIT ⇒ reintento devuelve resultado original sin efectos duplicados.
- **Conflicto de permisos:** usuario deshabilitado o Rol revocado durante desconexión ⇒ no se confirma silenciosamente.
- **Cambio de asignación:** Repartidor anterior sincroniza una Entrega después de la reasignación ⇒ conflicto y conciliación, sin permitir entrega duplicada.
- **Cambios históricos:** precio/categoría/promoción actualizados luego de captura válida ⇒ no sustituir instantáneas aprobadas.
- **Falla parcial:** error entre Pedido, Cobro, Caja o Cuenta Corriente ⇒ rollback de efectos inseparables.
- **Mensajes tardíos/fuera de orden:** estados divergentes ⇒ respuesta explícita y auditoría; no procesar por fecha local como única fuente de verdad.

## Cuestiones [A CONFIRMAR] con usuario

1. **RP-006 (parcialmente resuelto):** el **Administrador recibe la rendición, que ocurre al finalizar cada recorrido de reparto, y autoriza su registro** (RD-F04-002). Las diferencias se registran y la rendición permanece pendiente de conciliación, sin confirmar un Cobro por efectivo no recibido. La evidencia mínima obligatoria y el cierre exclusivo por Administrador con motivo están aprobados. Faltan formato de comprobante y contrato técnico.
2. **RP-007:** ¿ratificar acceso directo a UC-29 solo para Administrador y Vendedor?
3. ¿Una operación capturada antes de revocar un permiso puede aceptarse después, o debe ir siempre a revisión?
4. ¿Qué plazo/retención aplica a eventos pendientes? Sin valor predeterminado aprobado.

**RP-006 — responsabilidad aprobada por [RD-F04-002](../01-gobierno/RD_F04_002_RENDICION_EFECTIVO_2026-10-26.md):** solo el Administrador recibe y autoriza el registro de rendiciones de efectivo del Repartidor. El momento es el final de cada recorrido; si hay diferencias se registran y la rendición queda pendiente de conciliación, sin confirmar automáticamente Cobros por importes no recibidos. Datos mínimos obligatorios aprobados; el cierre de diferencias es exclusivo del Administrador, con motivo documentado. Falta definir formato de comprobantes y aplicación financiera.

**RP-003 — decisión de alcance cerrada por RD-F04-001:** UC-03 y UC-05 admiten captura offline; UC-43 requiere conexión. La política operativa de conflictos continúa pendiente.

## Análisis emergente: pago en tránsito y latencia financiera

**RD-F04-003 aprobada funcionalmente:** un **registro de pago en tránsito independiente de `COBRO`**, una vez **sincronizado y validado por el servidor**, reduce la **deuda exigible provisional** del Cliente, **sin modificar Caja, `COBRO.estadoCobro` ni `MOVIMIENTO_CUENTA.saldoResultante`**. Los efectos definitivos solo proceden tras rendición y autorización administrativa. La declaración vinculada a UC-05 está aprobada por RD-F04-004. Siguen pendientes el tratamiento de faltantes, las restricciones comerciales, la evidencia y el modelo físico. Ver [RD-F04-003](../01-gobierno/RD_F04_003_PAGO_EN_TRANSITO_SALDO_PROVISIONAL_2026-10-26.md) y [evaluación técnica](F04_EVALUACION_PAGO_EN_TRANSITO_PROPUESTA_2026-10-26.md). No realizar cambios físicos sin nueva decisión expresa.

**RD-F04-004:** [declaración de efectivo recibida en UC-05](../01-gobierno/RD_F04_004_DECLARACION_EFECTIVO_UC05_2026-10-26.md) aprobada sin permiso UC-29; validación remota de identidad, asignación, importe e idempotencia obligatoria.

**RD-F04-005 — regla limitada y aprobada:** ante efectivo faltante en un pago en tránsito ya sincronizado y validado, la rendición queda **pendiente de conciliación** y el importe reconocido **no vuelve automáticamente a ser deuda exigible del Cliente**. No se contabiliza en Caja el faltante. La investigación, atribución de responsabilidades y resolución detallada de este supuesto están **fuera del alcance F04**. Ver [RD-F04-005](../01-gobierno/RD_F04_005_DIFERENCIA_PAGO_EN_TRANSITO_2026-10-26.md).


**RD-F04-006 — regla funcional aprobada:** al evaluar deuda para nuevos Pedidos, utilizar el **saldo exigible provisional**, compuesto únicamente por eventos sincronizados y validados. La categoría comercial `CUMPLIDOR`/`EN_MORA` **permanece separada y no se modifica automáticamente**; los ajustes de precio, bloqueos ajenos a deuda y demás políticas siguen vigentes. Para pedidos capturados offline, el servidor revalida al sincronizar. Ver [RD-F04-006](../01-gobierno/RD_F04_006_EVALUACION_DEUDA_NUEVOS_PEDIDOS_2026-10-26.md). No se interpreta que un saldo provisional cero habilite todos los pedidos sin más controles.

**Borrador técnico S-01 (no aprobado):** [contrato de sincronización, cola, idempotencia y pruebas](F04_CONTRATO_S01_SINCRONIZACION_BORRADOR_2026-10-26.md). Expone el cruce entre deuda exigible provisional y categoría comercial aplicada al nuevo Pedido; no incorpora DDL ni endpoints ratificados.

## Diseño técnico siguiente, condicionado a decisiones

- Proponer contrato `POST /sincronizaciones` con UUID de operación, payload versionado, actor, referencia, instantánea y respuesta estable de éxito/conflicto/reintento.
- Evaluar inbox persistente, esquema de deduplicación, bitácora de errores y estados de sincronización **sin confundirlos con estados de COBRO**.
- Definir orden de bloqueos y atomicidad con transacciones; verificar RBAC a nivel API.
- Preparar pruebas de integración con conectividad intermitente, concurrencia y rollback.

**RD-F04-001 fue aprobada exclusivamente sobre modalidades de captura. No se aprueba en este documento ninguna migración, nueva tabla ni permiso adicional.**
