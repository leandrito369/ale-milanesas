# Auditoría transversal de contratos — REV-01 a REV-06A (54 operaciones / 51 CU)

**Sistema:** Gestión para Ale Milanesas.  
**Fecha:** 28 de octubre de 2026.  
**Rama de auditoría:** `revision/auditoria-transversal-contratos-2026-10-28` (base `revision/rev06a-comercial-promociones-2026-10-28`, PR #15).  
**Dictamen de esta etapa:** correcciones puntuales documentadas y QA de estructura y firmas **conforme**; evaluación funcional transversal **avanzada, no certificación definitiva de todos los flujos**. El documento principal y las ramas precedentes no se modifican ni fusionan.

## 1. Alcance y autoridades

Se verificaron las **16 unidades documentales** que contienen **54 contratos públicos** asociados a **51 CU distintos**. Tres CU admiten dos operaciones diferenciadas: UC-03 (alta/reprogramación), UC-07 (oferta/respuesta), UC-29 (alta/anulación).

| Lote | CU/operaciones | Documentos de contratos |
|---|---|---|
| REV-01 — Inventario | UC-42, UC-50, UC-51: 3 | 3 archivos individuales |
| REV-02 — Seguridad | UC-01, UC-17, UC-18, UC-53, UC-54, UC-55, UC-56: 7 | 7 archivos individuales |
| REV-03 — Compras | UC-58, 44, 62, 63, 13, 12; UC-37, 11, 45, 46, 40, 39, 08: 13 | 2 documentos (3A/3B) |
| REV-04 — Pedidos/Entregas | UC-34, 03×2, 21, 43, 04, 25; UC-28, 05, 06, 61, 07×2, 41: 14 | 2 documentos (4A/4B) |
| REV-05 — Finanzas | UC-14, 29×2, 22, 23, 26, 49, 27: 8 | 1 documento |
| REV-06A — Comercial | UC-35, 30, 47, 48, 19, 20, 24, 59, 60: 9 | 1 documento |
| **Total** | **54 operaciones / 51 CU** | **16 documentos** |

**Fuente maestra:** [CASOS_DE_USO_64_TRES_NIVELES](https://docs.google.com/document/d/1BMF2Yfsh2ki353fU2dS5eZtIsYrOntpkjjAzulNy1uY/edit), revisada el 28/10/2026, revisión `AHj4eMRApkXnQrOvOp9RqLYElYqrVLQrT1rMc2Tkwtez9U1HA1AGGaQ2L0dhNTjxMMFcptBs4cJjqM_hONxD1Uxu97IstR5g22N4F8642Oo`; contiene **64 CU en los tres niveles** (Alto Nivel, Extendido, Real). Para contrastes con decisiones posteriores se utilizaron [RD-RP007-002](../../01-gobierno/RD_RP007_002_PERMISOS_BUSQUEDAS_2026-10-27.md), [RD-RP016-001](../../01-gobierno/RD_RP016_001_ALTA_INSUMO_SIN_STOCK_COSTO_2026-10-27.md), [RD-RP017-001](../../01-gobierno/RD_RP017_001_UNIDAD_MEDIDA_INSUMO_HISTORIAL_2026-10-27.md), [RD-RP023-001](../../01-gobierno/RD_RP023_001_PROMOCIONES_SIMULTANEAS_2026-10-27.md) y [MR-5 S-05](../../05-modelo-relacional/MR5_CONTRATOS_SERVICIOS.md). Se verificó el nombre físico `CRITERIO_POLITICA_COMPRA` en el diccionario de 60 tablas MR-5/MR-6.

**Diagrama de secuencia:** por decisión del responsable, **la inspección visual de diagramas está cerrada**. El DSS de REV-03A permanece deliberadamente como original de Gemini, sin exigir revisión ni una copia corregida. Esta auditoría usa DSS y DS solo para **cotejar firmas de frontera**, sin volver a examinar gráfica, geometría ni UML visual. El [índice de inspección de los seis lotes](./INDICE_INSPECCION_DIAGRAMAS_CONTRATOS_REV01_A_REV06A_2026-10-28.md) conserva los enlaces para trazabilidad.

## 2. QA estructural y de firma

| Control | Resultado | Alcance real |
|---|---|---|
| Operaciones identificadas en contratos | **54** | Recuento exhaustivo de los 16 documentos |
| Nueve apartados declarativos por contrato: Nombre, Responsabilidades, Tipo, Referencias cruzadas, Notas, Excepciones, Salida, Precondiciones, Postcondiciones | **54/54** | Para REV-01 se verificaron títulos `## 1..9`; para REV-02 a REV-06A apartados numerados `1..9` |
| Nombre, orden, tipo/opcionalidad de parámetros del contrato ↔ DSS ↔ DS | **54/54** | Cotejo textual normalizando espacios y escapes HTML/XML; REV-03A contra DSS Gemini conservado |
| CU del maestro con tres especificaciones disponibles | **64/64** | Existencia/identidad de secciones Alto Nivel, Extendido y Real, no validación académica |
| CU distintos cubiertos por los seis lotes | **51/64** | Los 13 restantes no están en el alcance contractual de los seis lotes |
| Persistencia real, control transaccional, permisos ejecutables y comportamiento externo | **No evaluados** | El contrato expresa obligaciones, no prueba de software |

**No se infiere de 9 secciones que todas las alternativas del flujo extendido estén explicitadas:** la auditoría compara responsabilidades y restricciones esenciales, y ha abierto ampliaciones concretas ante omisiones verificadas.

## 3. Hallazgos corregidos en esta rama (no en PR anteriores)

| ID | Nivel | Contrato / fundamento | Corrección aplicada |
|---|---|---|---|
| **CT-01** | Media — RBAC | UC-42 declaraba solo “actor autenticado y autorizado”; su ficha maestra identifica **Responsable de Producción** | Precondición explicita ese actor y su alcance de inventario |
| **CT-02** | Media — RBAC | UC-51 declaraba “Usuario autenticado”; el maestro exige **Administrador** | Precondición restringida a Administrador; no se cambia la operación |
| **CT-03** | Alta — RBAC | UC-34 no delimitaba acceso contextual del **Repartidor** ni de **Producción**, pese a RD-RP007-002 | El contrato incorpora matriz de acceso, validación de asignación vigente, rechazo por falta de ámbito y no exposición de datos |
| **CT-04** | Media — RBAC | UC-37 declaraba un “actor interno” genérico; RD-RP007-002 solo autoriza **Administrador** | Acceso directo/contextual de Administrador explícito |
| **CT-05** | Alta — RBAC | UC-40 nombraba Administrador o Producción sin diferenciar alcance; RD-RP007-002 permite Producción **solo contextual y de lectura** | Se delimita el acceso de ambos, sin facultades de modificación/aprobación de Orden |
| **CT-06** | Alta — integridad y permisos | UC-06 admitía “actor interno autorizado” genérico y solo dos excepciones; el Extendido exige **Vendedor o Repartidor** e incluye escenarios de costo incompleto, falta de elaborados, desistimiento y fallo de persistencia | Se explicitan actores y condición de asignación vigente del Repartidor, ocho alternativas de contrato y efectos conservativos de inventario, costo y transacción |
| **CT-07** | Baja — presentación e identidad del modelo | REV-03A UC-12 tenía marcadores Markdown rotos y glosario `CRITERIO_***POLITICA*_COMPRA`, no coincidente con diccionario | Se normalizaron encabezados/viñetas y el nombre físico correcto `CRITERIO_POLITICA_COMPRA`; sin alterar la lógica de selección |

**Archivos modificados únicamente en esta rama:** [UC-42](./REV01_UC42/propuestos/CONTRATO_UC42_REV01.md), [UC-51](./REV01_UC51/propuestos/CONTRATO_UC51_REV01.md), [REV-03A](./REV03_COMPRAS/propuestos/CONTRATOS_REV03A_CORREGIDOS.md), [REV-03B](./REV03_COMPRAS/propuestos/CONTRATOS_REV03B_CORREGIDOS.md), [REV-04A](./REV04_PEDIDOS_ENTREGAS/propuestos/CONTRATOS_REV04A_CORREGIDOS.md) y [REV-04B](./REV04_PEDIDOS_ENTREGAS/propuestos/CONTRATOS_REV04B_CORREGIDOS.md).

## 4. Verificación transversal de reglas prioritarias

Se hizo un **cribado de 54 operaciones** mediante invariantes de negocio, roles, integridad y vocabulario, seguido de lectura de las piezas indicadas para interpretar diferencias. El cribado sirve para localizar riesgos; **no sustituye lectura manual exhaustiva de cada alternativa**.

- **Stock y costos (REV-01/03/04):** UC-50 no crea stock ni costo inicial; UC-42 usa SALDO_INICIAL real; UC-51 bloquea cambio de unidad con movimientos o costos históricos; UC-08 distingue Insumo de REVENTA, conversiones y órdenes; UC-05/06/07/28 preservan costos de elaborados y no inventan costo cero.
- **Seguridad (REV-02):** login interno/PROVEEDOR sin Cliente ONLINE; al menos un Rol por Usuario; PROVEEDOR exclusivo; UC-54 verificación de identidad comercial; UC-55 no deshabilita al último Administrador y requiere reasignación previa de Pedidos pendientes del Repartidor según RD-RP009-001. Estas obligaciones no acreditan que F07 esté implementado.
- **Compras (REV-03):** políticas de pesos 100 %, ofertas incompletas visibles, `ordenDesempate`; plazos de cotización según parámetro, no “48 horas” inventadas; ronda inicial automática única y decisiones de Compra bajo Administrador.
- **Pedidos (REV-04):** idempotencia en origen offline; Cliente activo; fecha de reparto habilitada; promociones elegibles sin acumulación y congeladas; asignaciones y reprogramación con control de historial/concurrencia; entrega y efectivo en tránsito sin registrar rendición definitiva desde el Repartidor.
- **Finanzas (REV-05):** Cobro confirmado versus anulado con contraasientos; rendición de Repartidor **solo autorizada por Administrador**; Cuenta Corriente separa confirmado/tránsito validado/exigible provisional; MercadoPago y Reembolso idempotentes; margen bruto por venta individual identificada mediante `ENTREGA.idPedido`.
- **Comercial (REV-06A):** Producto nuevo puede no tener Precio pero no es comercializable; Precio sin fechas retroactivas ni vigencias superpuestas; consultas de Promociones solo lectura; promoción sin descuentos acumulados; UC-60 propone baja definitiva `CANCELADA` sin reactivación.

## 5. Reservas expresas para decisión / no corregidas por inferencia

| ID | Tema | Situación |
|---|---|---|
| **RC-01 — resuelta documentalmente** | **UC-08 — permiso de recepción** | El maestro Fase 4 (Alto Nivel, Extendido y Real) identifica únicamente **Responsable de Producción**. Se restringió el contrato de UC-08 a dicho actor y se explicitó el rechazo de accesos no autorizados. Habilitar también Administrador requerirá nueva decisión funcional; no se infiere de la facultad de administrar Órdenes. |
| **RC-02 — CERRADA por ratificación** | **UC-60 — destino de baja** | **RD-F08-001 aprobada el 29/10/2026:** destino único `CANCELADA` desde `BORRADOR`, `ACTIVA` o `PAUSADA`. No se cambia `FINALIZADA`/`CANCELADA`; `PAUSADA→ACTIVA` sigue prohibida. Se conservan asociaciones, comunicaciones y descuentos de Pedidos confirmados. La decisión funcional está cerrada; faltan únicamente pruebas e integración. |
| **RC-03** | **UC-03 — reprogramación** | RD-RP020-001 demanda historial de fechas e invalidación de asignación/ruta, pero el mecanismo persistente concreto sigue sin tabla nueva ratificada. El contrato no habilita inferir esquema. |
| **RC-04** | **UC-43 y operación offline** | Asignación/eligibilidad y sincronización en condiciones adversas requieren control de implementación; la documentación contractual no certifica RNF-04 ni carreras transaccionales. |
| **RC-05** | **F07/F08/F09 y pagos externos** | Permisos efectivos, identidad de webhooks, reembolsos idempotentes, cambios de estado, exclusividad de sesiones y bloqueo ante concurrencia deben validarse en servicios/BD de forma independiente. |
| **RC-06** | **Cobertura 64 CU** | Faltan contratos en estos lotes para: `UC-02, UC-09, UC-10, UC-15, UC-16, UC-31, UC-32, UC-33, UC-36, UC-38, UC-52, UC-57, UC-64`. No se atribuyen a fallas de los lotes existentes; corresponde completar el tramo restante y la matriz global 64 CU. |

## 6. Decisión de cierre de auditoría documental

**Se completó una primera auditoría transversal útil para preintegración:** 54/54 firmas, 54/54 contratos de nueve apartados y correcciones de **siete hallazgos** sobre seis documentos, con evidencia de la fuente, más seis reservas explícitas.

**RC-01 y RC-02 están CERRADAS funcionalmente**, mediante Fase 4 y RD-F08-001 respectivamente. **No declarar integrados todos los 64 CU ni modificar automáticamente el Word principal**: los contratos pendientes de REV-06B, la revisión final y la integración siguen como actividades separadas. Los contratos corregidos son propuestas en rama apilada. No se modifica ningún diagrama, `main`, Word maestro ni DDL. La inspección de diagramas reportada por el responsable permanece cerrada.

## 7. Adenda de autoridad — 29/10/2026 (evaluación de propuesta de cierre)

- **UC-08 / RC-01:** verificadas sus tres fichas Fase 4; actor **Responsable de Producción** (sin autorización documental del Administrador para realizar esta operación). El contrato 7 de REV-03B quedó restringido; se añadió excepción de permiso y se conservó la firma pública del DSS/DS. **RC-01 cerrado como contradicción documental**; no se alteran diagramas.
- **UC-40 — corrección de una desviación en esta misma auditoría:** `RD-RP007-002` aprobada literalmente habilita **Administrador: directo/contextual** y **Responsable de Producción: directo/contextual, solo lectura**. El contrato de REV-03B había reducido erróneamente Producción a “solo contextual”; esto **se corrigió**. UC-40 no concede facultad de emitir/cancelar órdenes ni habilita UC-08 a Administrador.
- **UC-60 / RC-02:** la propuesta adjunta recomienda `CANCELADA` como destino único de baja definitiva. Es compatible con las aristas de `fn_mr3_promocion_estado` parcheada F08, siempre que incluya **el origen PAUSADA** (también permitido). Queda redactada la recomendación formal siguiente: *“UC-60 desactivarPromocion, ejecutado exclusivamente por Administrador y con confirmación/revalidación transaccional, llevará a PROMOCION.estado = CANCELADA cuando el origen sea BORRADOR, ACTIVA o PAUSADA; no procederá desde FINALIZADA ni CANCELADA; no creará ni reactivará Promociones y no modificará descuentos ya congelados ni historial. PAUSADA→ACTIVA no se autoriza.”* Esta formulación fue **ratificada expresamente por el responsable del proyecto el 29/10/2026** y registrada en **RD-F08-001**; el párrafo precedente conserva la redacción de la propuesta histórica.
- **Distinción de alcance:** la propuesta adjunta incluye además un plan para ampliar las excepciones de 54 contratos y redactar **13 contratos REV-06B**. Esos anexos requieren una auditoría independiente antes de proclamar cobertura final de **67 contratos / 64 CU**: no se ha constatado concordancia DSS/DS de las 13 firmas ni validación integral de sus 9 apartados contra las fichas maestras. No se incorporan por inferencia como “ya validados”.
- **Gobierno:** PR transversal Draft. Esta adenda no ratifica reglas nuevas en nombre del usuario ni modifica Word Fase 4, DDL, diagramas o `main`.


## 8. Cierre funcional de las dos reservas (29/10/2026)

**RC-01 — UC-08:** cerrada por cotejo con las tres fichas Fase 4; actor autorizado Responsable de Producción (contrato REV-03B ajustado). **RC-02 — UC-60:** cerrada por ratificación explícita del responsable; ver [RD-F08-001](../../01-gobierno/RD_F08_001_UC60_BAJA_DEFINITIVA_PROMOCION_2026-10-29.md). `desactivarPromocion` lleva `BORRADOR`, `ACTIVA` o `PAUSADA` a `CANCELADA`; se deniega `PAUSADA→ACTIVA`. La firma pública, los diagramas y el SQL permanecen intactos. La cobertura contractual de los 13 CU restantes y las pruebas técnicas son pendientes independientes; PR #16 continúa Draft.


## 9. Adenda de cobertura contractual — REV-06B (29/10/2026)

La reserva **RC-06 (ausencia de los 13 contratos restantes)** quedó superada **como cobertura documental** mediante [REV06B_ACTA_VALIDACION_Y_CIERRE_CONTRATOS_2026-10-29.md](./REV06B_CLIENTES_RECETAS_INVENTARIO/REV06B_ACTA_VALIDACION_Y_CIERRE_CONTRATOS_2026-10-29.md) y la [Matriz global de 64 CU / 67 contratos](./MATRIZ_GLOBAL_COBERTURA_64_CU_67_CONTRATOS_2026-10-29.md). El documento anterior refleja su corte histórico de **54 contratos** y no debe confundirse con el inventario vigente después de REV-06B. Resultado posterior: **67 contratos / 64 CU**, 67/67 con nueve apartados y tres CU con dos operaciones (UC-03/UC-07/UC-29).

**Reserva técnica separada:** las **13 nuevas firmas REV-06B** no están cotejadas contra DSS/DS propios, porque estos artefactos no existen en la rama. Los 54 cotejos de operaciones anteriores no se reabren. Esta adenda **no** aprueba funcionamiento, API, implementación, nuevas relaciones UML ni integración automática en el Word maestro o `main`. El control visual de diagramas declarado concluido por el responsable permanece cerrado.
