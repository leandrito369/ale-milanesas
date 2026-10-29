# REV-05 — Acta de trazabilidad DSS → DS → Contratos de operación

**Proyecto:** Sistema de Gestión para Ale Milanesas.  
**Fecha de corte:** 28/10/2026.  
**Alcance:** Lote 5, Finanzas y Consultas: siete casos de uso (UC-14, UC-22, UC-23, UC-26, UC-27, UC-29 y UC-49), **ocho operaciones públicas** porque UC-29 registra y anula Cobros mediante operaciones independientes.  
**Carácter del acta:** evidencia documental y control estático de consistencia. **No constituye aceptación académica, validación visual Draw.io, ejecución SQL ni prueba funcional de servicios.**  
**Rama:** `revision/rev05-finanzas-consultas-2026-10-28`; **PR:** [#14](https://github.com/leandrito369/ale-milanesas/pull/14), basado en REV-04 / PR #13 y en la cadena documental PR #12, #11, #10 y #9. Mantener como **Draft** y no fusionar sin autorización.

## 1. Identificación de los artefactos

Los originales de Gemini se conservan sin cambios dentro de [`originales/`](./originales/). Las versiones revisadas se encuentran en:

- [`propuestos/DSS_REV05_CORREGIDO.drawio.xml`](./propuestos/DSS_REV05_CORREGIDO.drawio.xml): **2 páginas** de secuencia de sistema, con escenarios independientes.
- [`propuestos/DS_REV05_CORREGIDO.drawio.xml`](./propuestos/DS_REV05_CORREGIDO.drawio.xml): **7 páginas** de diseño; UC-29 incluye dos operaciones públicas distintas en su página.
- [`propuestos/CONTRATOS_REV05_CORREGIDOS.md`](./propuestos/CONTRATOS_REV05_CORREGIDOS.md): **8 contratos independientes** con nueve secciones cada uno.
- [`REV05_AUDITORIA_SELECTIVA_DICTAMEN_2026-10-28.md`](./REV05_AUDITORIA_SELECTIVA_DICTAMEN_2026-10-28.md): hallazgos R5-01 a R5-11, metodología M-0 a M-7 y reservas de implementación.

**Autoridades de contraste de esta revisión:** `docs/01-gobierno/RD_F01_ESTADOS_COBRO_2026-10-26.md`; RD-F04-001 a RD-F04-007; `RD_RP004_RP028_001_CONSULTAS_ECONOMICAS_2026-10-27.md`; catálogo vigente de **64 CU** y diccionario de **60 tablas** `docs/05-modelo-relacional/Diccionario_Explicativo_60_Tablas_MR5_MR6_26-10-2026.md`. Se cita el Word maestro Fase 4 como referencia a cotejar literalmente, **no** como fichas certificadas por esta acta. La antigua línea base local de 49 CU/59 tablas no reemplaza esas decisiones posteriores.

## 2. Matriz de trazabilidad por operación pública

Las páginas se enumeran en el orden de los elementos `diagram` de cada `mxfile`; la sección de contrato corresponde al encabezado del documento de contratos.

| Caso de uso / operación | DSS | DS | Contrato | Trazabilidad normativa y correcciones |
|---|---|---|---|---|
| **UC-14** — `consultarCuentaCorriente` | Página 1, escenario UC-14 | Página 1, UC-14 | N.º 1 | RD-RP004/RP028-001 y F04-003/004/005/006. Distingue saldo confirmado, tránsito validado y exigible provisional sin asientos nuevos; R5-02 y R5-08. |
| **UC-29** — `registrarCobro` | Página 1, alta UC-29 | Página 2, UC-29, alta | N.º 2 | RD-F01; F04-002/003/004/005/006. Cobro CONFIRMADO, PAGO/INGRESO una vez; rendición de Repartidor recibida, comprobada y autorizada por **Administrador**; R5-01, R5-02. |
| **UC-29** — `anularCobroManual` | Página 1, escenario independiente UC-29 | Página 2, UC-29, anulación independiente | N.º 3 | RD-F01, MR-6. Operación pública separada de alta, motivo obligatorio, CONFIRMADO → ANULADO y contraasientos con `idCobroAnulado`; R5-03. |
| **UC-22** — `registrarMovimientoCaja` | Página 2, UC-22 | Página 3, UC-22 | N.º 4 | Movimiento manual de Caja del Administrador. No se utiliza para Cobros de Clientes ni Reembolsos automáticos. |
| **UC-23** — `consultarLibroDiario` | Página 2, UC-23 | Página 4, UC-23 | N.º 5 | Ingresos y egresos monetarios por período, sin equipararlos con utilidad ni saldo de arqueo; lectura sin mutación. |
| **UC-26** — `procesarReembolsoElectronico` | Página 2, UC-26 | Página 5, UC-26 | N.º 6 | Reembolso completo único por Cobro; Administrador para reintento; MercadoPago separado de Caja y Cuenta Corriente; efectos solo en primera transición a PROCESADO; R5-05, R5-06, R5-10 y R5-11. |
| **UC-49** — `registrarResultadoReembolsoElectronico` | Página 2, UC-49 | Página 6, UC-49 | N.º 7 | Notificación de MercadoPago: entrada `estadoInformado` ≠ columna `resultadoInformado`; auditoría `autenticado`, `aplicable`, `motivoNoAplicacion`; efectos únicos EGRESO/AJUSTE_DEBITO; R5-04, R5-05, R5-06 y R5-11. |
| **UC-27** — `consultarMargenBruto` | Página 2, UC-27 | Página 7, UC-27 | N.º 8 | RD-RP004/RP028-001: período o venta individual, `idVentaIndividual` resuelto por `ENTREGA.idPedido` (PK existente), costos históricos e indicador de incompletitud; R5-07 y R5-09. |

## 3. Firmas públicas cotejadas

Se conservan nombre, orden, tipos y opcionalidad de parámetros. Las diferencias de espacios entre etiquetas XML y Markdown no cambian la firma. Se ha cotejado **una ocurrencia de cada firma pública en cada uno de DSS, DS y contrato**.

1. `consultarCuentaCorriente(idCliente: Long, fechaDesde: LocalDate[0..1], fechaHasta: LocalDate[0..1])`
2. `registrarCobro(idCliente: Long, idPedido: Long[0..1], importe: BigDecimal, medioPago: String, origen: String, referenciaExterna: String[0..1])`
3. `anularCobroManual(idCobro: Long, motivoAnulacion: String)`
4. `registrarMovimientoCaja(tipoMovimiento: String, importe: BigDecimal, concepto: String, observacion: String[0..1])`
5. `consultarLibroDiario(fechaInicial: LocalDate, fechaFinal: LocalDate)`
6. `procesarReembolsoElectronico(idCobroOriginal: Long, idReembolsoReintento: Long[0..1], idUsuarioReintento: Long[0..1])`
7. `registrarResultadoReembolsoElectronico(referenciaExternaIntento: String, estadoInformado: String, firmaVerificacion: String)`
8. `consultarMargenBruto(modoConsulta: String, fechaHoraDesde: Timestamp[0..1], fechaHoraHasta: Timestamp[0..1], idVentaIndividual: Long[0..1])`

## 4. Resultados reproducibles del QA estático

Se releyeron **las tres versiones propuestas desde la rama de GitHub**, no solo las cifras declaradas en el texto de la PR.

| Control | Resultado | Límite de la evidencia |
|---|---|---|
| Concordancia de nombre/firma DSS ↔ DS ↔ contrato | **8/8** | Normalización de espacios; no prueba semántica integral de todos los mensajes. |
| Contratos con los apartados Nombre, Responsabilidades, Tipo, Referencias cruzadas, Notas, Excepciones, Salida, Precondiciones, Postcondiciones | **8/8** | Valida presencia estructural, no exhaustividad académica. |
| Páginas DSS | **2**; `mxCell` por página: **21, 35** | Recuento textual en XML. |
| Páginas DS | **7**; `mxCell`: **21, 35, 23, 20, 33, 30, 28** | Recuento textual en XML. |
| Duplicados de `mxCell.id` dentro de una página | **0**, en las nueve páginas | No equivale a validación de render ni de rutas de conectores. |
| Equilibrio básico de etiquetas/entidades en propuestas | Sin anomalías reportadas por el control textual del dictamen | Los XML propuestos aún no fueron sometidos a prueba de abrir–guardar–reabrir en Draw.io; el parser XML citado en la auditoría se aplicó a los **originales**. |
| Revisión académica/servicio/BD | **No realizada** | No presentar esta acta como aprobación de Larman, RBAC, SQL o integración. |

## 5. Control de fronteras: lo que no se infiere ni se agrega

- **Rendición de efectivo:** el permiso general de Vendedor para Cobros manuales no autoriza a aprobar rendiciones de Repartidor. La rendición de cierre requiere verificación y autorización de **Administrador**; las diferencias no se convierten en dinero confirmado.
- **Operaciones de UC-29:** `anularCobroManual` no es un bloque `opt` del alta `registrarCobro`; son dos eventos de sistema separados dentro del mismo CU.
- **Eventos de MercadoPago:** parámetros del mensaje entrante no son columnas nuevas; conservar la trazabilidad de eventos no aplicables sin correlacionarlos con Reembolsos ajenos. Se mantienen separados el adaptador, Caja y Cuenta Corriente en las líneas de vida.
- **Idempotencia:** la respuesta inmediata UC-26 y el webhook UC-49 no pueden generar dos EGRESOS ni dos AJUSTES_DEBITO; el requisito está expresado documentalmente pero aún requiere control transaccional y prueba concurrente.
- **Consulta de margen:** una entrega individual se identifica mediante **`ENTREGA.idPedido`**, no una inexistente `ENTREGA.idEntrega`; no se agregaron columnas para justificar un nombre de parámetro lógico.
- **Relaciones de CU:** la reevaluación comercial tras reembolso PROCESADO no autoriza inventar un nuevo `«include»` desde UC-26 ni UC-49 a UC-15. No se modifica el diagrama general de casos de uso.
- **Modelo de datos:** este lote documental **no** cambia MR-5/MR-6, el DDL, el Word maestro, los originales Gemini, las PR anteriores ni `main`.

## 6. Reservas y condiciones para una revisión posterior

1. **Fase 4:** cotejar literalmente las fichas de tres niveles de los siete CU contra el Word vigente de 64 CU, incluyendo actores, alternativos y poscondiciones; registrar diferencias si las hay.
2. **Draw.io:** abrir, inspeccionar visualmente, guardar y reabrir las nueve páginas; revisar visibilidad, legibilidad, conectores, guardas `alt/opt/loop` y posibilidad de edición.
3. **Visibilidad de Larman:** demostrar, con el diseño y responsabilidades de clases, por qué cada objeto posee la información necesaria para recibir cada mensaje.
4. **Permisos y rendición:** implementar y verificar autorización del Administrador, identidad de Vendedor/Repartidor, sincronización offline, tránsito validado y conciliación sin doble descuento.
5. **MercadoPago:** validar firma/correlación de webhook, idempotencia del intento, resultado inmediato versus notificación tardía, reintentos y fallas concurrentes de commit.
6. **Integridad financiera:** ejecutar pruebas PostgreSQL/servicios para contraasientos, efectos únicos y saldos; no extrapolar garantías desde diagramas.
7. **Margen bruto:** probar costos históricos de ELABORADO y REVENTA, imputación de adiciones y notificación de costo faltante (resultado incompleto, nunca costo cero).
8. **Gobierno del cambio:** mantener el PR #14 en **Draft** hasta revisión y autorización; resolver dependencias de PR #13/#12/#11/#10/#9 sin fusionar unilateralmente.

## 7. Dictamen del acta

**Trazabilidad documental estática: conforme para preintegración**, con **8/8 firmas**, **8/8 contratos completos en nueve secciones** y **9/9 páginas sin IDs de `mxCell` duplicados por página**. Los once hallazgos R5-01 a R5-11 se documentan en el dictamen transversal y están localizados funcionalmente en la matriz precedente.

**Estado de validación:** revisión documental en curso, no certificación final. **Disposición:** conservar `originales/`, `propuestos/` y esta acta en la rama REV-05; **no fusionar** ni modificar archivos de la línea base sin una decisión expresa.
