# Seguimiento vertical H5 y handoff R09 — 22/11/2026

**Estado del documento:** `PROPUESTO / PR DRAFT`; coordinación de gobierno, no autorización de código, merge, aceptación ni despliegue.

**Base de Gobierno verificada:** `main@2c74174af7850df5c7cd76f7158c0d729a889122`.

**Aplicación consultada solo en lectura:** `main@21db1f536d0d7153e5d4abb721115778dadf14b3`.

**Objeto:** permitir iniciar `R09.1` y el primer `UC-05` de originales sin reabrir el dominio ni anticipar `R09.4`.

## 1. Criterio de estados

- **INTEGRADO:** presente en `main`; no implica aceptación humana ni despliegue.
- **PROBADO:** existe evidencia reproducible sobre un SHA; no implica integración, aceptación ni prueba E2E.
- **ACEPTADO:** validación humana/operativa expresa; no se presume a partir de CI.
- **DESPLEGADO:** ejecutado en infraestructura autorizada; no se presume a partir de merge.
- **CERRADO TÉCNICAMENTE:** alcance técnico del incremento concluido; puede conservar aceptación o despliegue pendientes.

## 2. Fotografía verificable del roadmap

| Frente | Estado al 22/11/2026 | Evidencia y límite |
|---|---|---|
| `I1` | **CERRADO TÉCNICAMENTE** | 6/6 paquetes según Roadmap §3; aceptación E2E no acreditada aquí. |
| `I2` | **CERRADO TÉCNICAMENTE** | 3/3 paquetes según Roadmap §3; no equivale a despliegue. |
| `I3-01` | **CERRADO TÉCNICAMENTE** | `UC-09/10/28`; reservas `UC-03` y rutas `UC-25` siguen fuera de ese cierre. |
| `UC-22` | **INTEGRADO** | app `main`, merge `28bc24e` (PR #91). |
| `UC-23` | **INTEGRADO** | app `main`, merge `aa68b78` (PR #90). |
| `R08.6 / V4` | **CONSTRUIDO Y PROBADO; NO INTEGRADO** | app PR #102 `OPEN/DRAFT`, HEAD `716eff313c9fa39dc98ad9fe175341e90fbab09f`, `MERGEABLE/CLEAN`; B1, B2 y SonarCloud `SUCCESS` sobre ese HEAD. |
| `R09.1` | **NO IMPLEMENTADO** | PR #102 agrega esquema/invariantes y pruebas, con cero cambios en `src/main/java/**`; faltan servicios de aplicación y conexión funcional. |
| `UC-05` | **PENDIENTE DE INTEGRACIÓN FUNCIONAL** | No existe servicio/controlador integrado; la vista “Mis entregas” es ilustrativa y no consulta el caso de uso. |
| `UC-29` | **PARCIAL / PENDIENTE DE INTEGRACIÓN FUNCIONAL** | Existe servicio B3 de Cobro manual general; faltan HTTP/UI y el subflujo de rendición `PE-2`. |
| `UC-14` | **PENDIENTE** | No existe servicio/controlador integrado de Cuenta Corriente. |
| `H5` | **PENDIENTE** | Aún no hay vertical Pedido → Preparación → Entrega → Cuenta → Cobro/Caja con interfaz y pruebas. |
| `B9` | **PAUSA EXPRESA** | app Issue #28 `OPEN`: faltan reanudación autorizada, host/TLS/respaldo y aceptación humana `UC-54`; no bloquea construir en laboratorio, sí desplegar/aceptar. |

PR #102 no prueba bases reales, operación humana ni infraestructura. Su expediente conserva además una referencia CI histórica anterior; para esta fotografía se tomaron el HEAD vivo `716eff3` y sus tres checks exitosos, sin heredar resultados de otro SHA.

## 3. Fuentes canónicas mínimas y regla de precedencia

| Materia | Fuente aplicada |
|---|---|
| Secuencia y hitos | Plan Rector 29/10; Roadmap 15/11 §§3, 5, 6 y 9.3. |
| Firmas y responsabilidades | G0; contratos, DSS y DS `REV04B` (`UC-05`) y `REV05` (`UC-14/29`). |
| Correcciones financieras | `ACTA_G_COM_001` ratificada; adendas `REV04B E-01..03`, `REV05 E-04..06` y `RD-I302 E-07`. |
| Fronteras A/B y concurrencia | `RD-GFIS-AB-001`, integrada en Gobierno por PR #76. |
| Esquema candidato probado | app PR #102; no rige físicamente mientras no se integre y autorice su aplicación. |
| Adicionales | PR #75 permanece `OPEN/DRAFT` en `82e59f8e030c7d80dbf2689d95506f8f6fbc58d9`; `P1-A` y `DH-01..07` siguen `PROPUESTOS/PENDIENTES`. |

Ante una redacción histórica ambigua, la RD o adenda ratificada posterior precisa el contrato sin editar G0. Un diseño o una prueba de laboratorio nunca se convierte por esa sola razón en autorización.

## 4. Auditoría contractual mínima de `R09.1/R09.2`

**Resultado:** no queda una decisión comercial abierta que impida construir `R09.1` y un `UC-05` limitado a originales. Sí existen tres gates efectivos: autorización de integrar V4, implementación de los servicios de aplicación y rechazo fail-closed de pedidos con adicionales aceptados no soportados.

| Cruce | Alineación obligatoria para construir | Bloqueo real |
|---|---|---|
| 1. `PE-1/PE-2/IMP-B` | V4 aporta persistencia, constraints, triggers y funciones; `R09.1` debe aportar servicios de aplicación que orquesten actor, objeto, idempotencia, transacción y errores. `PE-1` pertenece a confirmar Entrega; `PE-2` a la rendición administrativa; `IMP-B` registra aplicaciones/liberaciones sin crear un segundo pago. | V4 no integrada y servicios ausentes. No requiere un modelo alternativo. |
| 2. `UC-05` online, originales | `REPARTIDOR` asignado confirma un Pedido `PENDIENTE`, cantidades originales válidas y clave idempotente; usa snapshots históricos, registra entrega/stock/excedente/cargo y revierte todo ante error. | Implementación ausente; adicionales se contienen según fila 6. |
| 3. Cargo sin Cobro prematuro | “Cargo confirmado” de DS `REV04B` significa débito por venta realmente entregada, no recepción de dinero. En la transacción de `UC-05` se registra `C_e`, `PE-1`, `D_e`/tránsito e `IMP-B`; se crean **cero** `COBRO` y **cero** `MOVIMIENTO_CAJA`. | Contradicción semántica cerrada por E-01/E-02; falta llevarla a código. |
| 4. Anticipos y Caja | Una reserva/aplicación proviene de un Cobro confirmado ya existente. `IMP-B` consolida primero imputación explícita elegible y luego crédito libre FIFO, libera sobrante con trazabilidad y nunca duplica `COBRO`, `PAGO` o Caja. La recepción administrativa posterior extingue una sola vez el tránsito y recién allí `PE-2/UC-29` registra los efectos definitivos correspondientes. | Servicio transaccional y pruebas anti-doble-imputación ausentes. |
| 5. Autorización | `UC-05`: solo `REPARTIDOR` asignado. `UC-14`: solo `VENDEDOR`. `UC-29` Cobro manual general: `ADMINISTRADOR` o `VENDEDOR`; anulación manual: solo `ADMINISTRADOR`; rendición: solo `ADMINISTRADOR`. No se añade permiso a ADMIN para `UC-14`, ni a Repartidor para `UC-29`. | Implementar revalidación de sesión/rol/ámbito en servidor y pruebas `403`; no hay decisión RBAC pendiente. |
| 6. Adicional no implementado | Bajo lock del Pedido, si existe oferta/adicional **aceptado** no soportado, rechazar toda la confirmación: cero `ENTREGA`, cargo, `PE-1`, `IMP-B`, stock o éxito idempotente. Una oferta solo pendiente no bloquea originales; su aceptación posterior debe revalidar que el Pedido siga `PENDIENTE`. | Guardia obligatoria de `R09.2`; sin ella el corte original-only es `NO-GO`. El literal HTTP definitivo sigue sujeto a la adenda API futura. |

### 4.1. Límite transaccional del primer `UC-05`

1. Revalidar sesión `REPARTIDOR`, asignación vigente y Pedido `PENDIENTE` en servidor.
2. Detectar adicionales aceptados no soportados y fallar antes de cualquier efecto.
3. Validar cantidades originales contra preparación/stock y snapshot histórico, sin recotizar.
4. En una sola transacción: Entrega y detalles originales, stock/excedente, cargo `C_e`, eventos `IMP-B`, `PE-1`, tránsito `V_e` y estado del Pedido.
5. Si falla cualquier componente, rollback completo; el reintento con la misma clave y payload devuelve el resultado previo sin duplicar efectos.
6. No invocar `PE-2`, no crear Cobro/Caja y no afirmar `UC-05` completo mientras falten adicionales.

## 5. Decisiones `DH-01..07` de UC-07

No existe ratificación expresa nueva: las siete decisiones conservan estado `PENDIENTE`. Ninguna bloquea el primer `UC-05` de originales si se implementa la guardia fail-closed anterior; todas deben resolverse antes de `R09.4`.

| DH | Materia preservada, sin reabrir `P1-A` | Primer UC-05 original | Antes de `R09.4` |
|---|---|---|---|
| `DH-01` | Variante física `P1-A/P1-B/P2` | No bloquea | **Decisión humana requerida**. |
| `DH-02` | Frontera de confianza `F8` | No bloquea | **Requerida** para UC-07 físico. |
| `DH-03` | Parcial adicional con redondeo `0,00` | No bloquea | **Regla comercial requerida**. |
| `DH-04` | Oferta previa a desactivación de Producto | No bloquea | **Regla comercial requerida**. |
| `DH-05` | Ámbito de Vendedores sobre una oferta | No bloquea | **Regla de autorización requerida**. |
| `DH-06` | Parámetros/retención/acceso de evidencia `P2b` | No bloquea | **Decisión operativa requerida**. |
| `DH-07` | Redlines #47/#48 y secuencia de preflight/laboratorio | No bloquea | **Autorización de secuencia requerida**; avances A/B no equivalen a su cierre. |

PR #75 y sus archivos permanecen intactos. Esta separación no ratifica `P1-A`, no autoriza `V5+` y no declara cerrada la campaña H de UC-07.

## 6. Plan inmediato 22–28/11

| Orden | Trabajo acotado | Dependencias | Criterio de terminado | Riesgo / decisión humana |
|---:|---|---|---|---|
| 0 | Revisar y, solo tras autorización, integrar V4 de PR #102 | HEAD/checks vigentes; revisión de diff, ACL y cutover | V4 en app `main`, SHA de merge registrado; aún no desplegada | **Aprobación humana de merge**; privilegios mínimos y respaldo/cutover. |
| 1 | `R09.1`: servicios de aplicación `PE-1/PE-2/IMP-B` y adaptación de generadores | V4 integrada; RD-GFIS-AB-001 | Fronteras transaccionales, idempotencia, rollback, ACL y regresión legacy probados en PostgreSQL real efímero | Autorizar rama/PR de código; evitar doble autoridad Java/SQL. |
| 2 | `R09.2`: `UC-05` online para originales | Paso 1; contratos `REV04B` + E-01/E-02 | Servicio/API con actor/asignación, cantidades, snapshot, stock/excedente, cargo, `PE-1/IMP-B`, replay y rechazo de adicionales; cero Cobro/Caja | No declarar `UC-05`/H3 completos. Carreras con UC-28/43/29 requieren pruebas finales. |
| 3 | `R09.3`: `UC-14` y `UC-29` | Pasos 1–2; `REV05` + E-04..06 | `UC-14` Vendedor con tres magnitudes separadas; Cobro manual conectado sin regresión; rendición Admin con `PE-2`, cese único del tránsito y anti-doble-Caja | Mantener segregación RBAC y `B1`: conciliación pendiente produce cero efectos definitivos. |
| 4 | Conectar interfaces ya construidas | Servicios integrados de pasos 2–3 | Reemplazar la pantalla ilustrativa “Mis entregas” y reutilizar shell/login/navegación B5; pruebas HTTP/UI por rol, sin mocks presentados como E2E | La UI no debe saltar autorización ni ampliar datos visibles. |
| 5 | Avanzar a H5 original-only evaluable | Pasos 2–4 integrados | Pedido → Preparación → Entrega original → Cuenta → Cobro/Rendición/Caja ejecutable con interfaz y evidencia por SHA | **Aceptación humana separada**. No equivale a H3/UC-05 completo, despliegue ni cierre de `DH/H`. |

### 6.1. Campaña mínima para no trasladar contradicciones

- Servicio: éxito, validaciones, replay idéntico, conflicto de clave, rollback y RBAC de cada operación.
- Finanzas: `C_e`, aplicación explícita, FIFO libre, liberación y conservación; un mismo importe no puede reservarse, aplicarse o rendirse dos veces.
- Concurrencia: completar sobre servicios finales las carreras `UC-05↔UC-28`, `UC-05↔UC-43`, `UC-05↔UC-29`, anulación/reservas y dos reintentos concurrentes.
- Integración: probar que `UC-05` genera cero Cobro/Caja y que `UC-29` extingue exactamente una vez el tránsito correspondiente.
- Interfaz: flujos positivos y denegaciones `UC-05/14/29` con sesión válida ajena, rol incorrecto y objeto fuera de ámbito.
- Evidencia: CI por HEAD exacto y PostgreSQL efímero; E2E humano, aceptación y despliegue se registran aparte.

## 7. Respuestas de handoff y gates

**¿Qué puede implementarse inmediatamente?** Tras autorizar e integrar V4: `R09.1`, luego `UC-05` original-only con rechazo de adicionales, `UC-14`, Cobro manual/rendición `UC-29` y conexión B5. En paralelo puede prepararse la matriz de pruebas; no requiere decidir `DH-01..07`.

**¿Qué está bloqueado y por cuál decisión?** El código que depende de V4 está bloqueado por autorización de merge e integración de PR #102. `R09.4/UC-07` está bloqueado por `DH-01..07`, CR #47/#48 y laboratorio H autorizados. Despliegue/aceptación está bloqueado por la pausa de Issue #28.

**¿Qué puede esperar sin impedir H5?** El soporte de adicionales `UC-07`, `UC-41/61`, P1 físico, F8 y su campaña H pueden esperar para un H5 explícitamente acotado a originales. No pueden omitirse para declarar `UC-05`, H3 o I3-02 completos.

**¿Qué requiere aprobación humana?** Merge de V4; apertura/promoción de PR de implementación; decisiones `DH-01..07` antes de `R09.4`; aceptación del vertical H5; y cualquier reanudación de B9/despliegue. Este documento no concede ninguna de esas aprobaciones.

## 8. Dictamen

- **GO condicionado** para solicitar autorización de merge de PR #102 e iniciar `R09.1`.
- **GO condicionado** para construir `UC-05` de originales después de `R09.1`, únicamente con la guardia fail-closed de adicionales y cero Cobro/Caja en Entrega.
- **NO-GO** para declarar `UC-05`, H3, H5 aceptado, H o `R09.4` cerrados; también para implementar UC-07/P1, desplegar o fusionar sin autorización.
- **Handoff suficiente:** las reglas pendientes de UC-07 quedan aisladas; Antigravity/OpenCode pueden trabajar `R09.1–R09.3` sin reinterpretar G0 ni crear un contrato físico alternativo.
