# REV-05 — Auditoría selectiva del Lote 5 de Gemini (Finanzas y Consultas)

**Fecha:** 28/10/2026 · **Estado:** corrección documental estática en revisión, no aceptación académica definitiva ni implementación.  
**Rama:** `revision/rev05-finanzas-consultas-2026-10-28` sobre `revision/rev04-pedidos-entregas-2026-10-28` (PR #13).  
**Metodología:** conservar lo aprobado de Gemini y alterar únicamente incompatibilidades demostrables con decisiones del proyecto, esquema relacional o notación/secuenciación UML; nunca modificar originales ni fusionar sin permiso.

## 1. Inventario y fuentes de autoridad

**Ámbito:** UC-14 (incluye UC-33), UC-29 (incluye UC-15), UC-22, UC-23, UC-26 (extiende condicionalmente UC-06), UC-49 y UC-27: **7 CU**, **8 operaciones públicas**, **8 contratos individuales**.

**Proveniencia:**
- `originales/LOTE5_GEMINI_ORIGINAL_2026-10-28.md`: paquete recibido completo (texto, 4 secciones, 2 bloques mxfile).
- `originales/DSS_REV05_GEMINI.drawio.xml` (2 páginas), `originales/DS_REV05_GEMINI.drawio.xml` (7 páginas).
- `originales/REV05_AUDITORIA_GEMINI.md`, `originales/CONTRATOS_REV05_GEMINI.md`.
- `propuestos/DSS_REV05_CORREGIDO.drawio.xml`, `propuestos/DS_REV05_CORREGIDO.drawio.xml`, `propuestos/CONTRATOS_REV05_CORREGIDOS.md`.

**Fuentes cotejadas en GitHub:** `docs/01-gobierno/RD_F01_ESTADOS_COBRO_2026-10-26.md`, **RD-F04-001 a RD-F04-007** (siete archivos), `RD_RP004_RP028_001_CONSULTAS_ECONOMICAS_2026-10-27.md`, diccionario de **60 tablas** `docs/05-modelo-relacional/Diccionario_Explicativo_60_Tablas_MR5_MR6_26-10-2026.md`. Decisiones funcionales posteriores se distinguen del estado de pruebas/implementación.

## 2. Hallazgos efectivos y corrección mínima

| Código | Verificación / antes de la corrección | Ajuste en `propuestos/` | Autoridad |
|---|---|---|---|
| **R5-01 Alta — rendición** | Gemini en UC-29 atribuía genéricamente el cobro manual a Vendedor o Administrador, sin separar **rendición de efectivo del Repartidor** | DSS/contrato precisan: cobro manual general conforme permisos; **rendición al final de cada recorrido, recibida/verificada/autorizada por Administrador**. Diferencias sin conciliar no crean Cobro confirmado ni Caja por efectivo faltante | RD-F04-002/005 |
| **R5-02 Alta — transitoriedad** | UC-14 y UC-29 no hacían suficientemente explícito que efectivo declarado offline no afecta saldos centrales, ni el retiro atómico de la porción provisional tras rendición | Solo declaraciones sincronizadas y validadas cuentan como tránsito; Cobro definitivo retira reconocimiento provisional evitando doble descuento; pendiente de conciliación conserva efecto provisional sin cobrar efectivo faltante | RD-F04-003/004/005/006 y RD-F01 |
| **R5-03 Media — operación separada** | UC-29 `anularCobroManual` representada como `opt` después de alta de un Cobro, como si dependiera de esa misma ejecución | DSS y DS cambian a escenario **`sd` público independiente** dentro del mismo UC-29; conserva motivo obligatorio, autorización, `CONFIRMADO→ANULADO`, contraasientos, reevaluación UC-15 e historial | RD-F01, MR-6 |
| **R5-04 Alta — columnas de webhook** | Evento UC-49 descrito con `estadoInformado` y `referenciaExternaIntento` como atributos directos, mientras MR-5/MR-6 usan `resultadoInformado`, `referenciaOperacionExterna`, `identificadorEventoExterno`, `autenticado`, `aplicable`, `motivoNoAplicacion` | DS/contrato separan **argumentos de entrada** de **columnas reales**; guardan incidencias no aplicables sin asociar automáticamente a Reembolsos ajenos | Tablas `INTENTO_REEMBOLSO` y `EVENTO_RESULTADO_REEMBOLSO` |
| **R5-05 Alta — visibilidad UML** | DS UC-26 muestra `:AdaptadorMercadoPago + :LibroCaja / :LibroCC` en una misma lifeline; UC-49 combina dos libros financieros | UC-26 separa adaptador, LibroCaja y LibroCuentaCorriente; UC-49 separa ambos libros, con **mensajes distintos para EGRESO y AJUSTE_DEBITO**. No se crean tablas ni relaciones de clase automáticamente | Identidad UML por instancia; MR-5/MR-6 tablas 55 y 57 |
| **R5-06 Media — relación UML** | Contratos UC-26 y UC-49 decían que **«incluyen» UC-15**, aunque catálogo del lote solo establece `UC-29 «include» UC-15` | Se conserva la **reevaluación funcional** cuando Reembolso llega a PROCESADO, sin inventar nuevas relaciones UML `include` en el diagrama general | Catálogo 64 CU y matriz de relaciones adoptada para REV-05 |
| **R5-07 Alta — venta individual** | UC-27 denominaba `idEntrega` como si fuera identificador físico distinto | `idVentaIndividual` público se interpreta como `ENTREGA.idPedido`, que también es `PEDIDO.idPedido`; no se añade `idEntrega` | Diccionario 60 tablas: `ENTREGA` PK `idPedido`; RD-RP004/RP028 |
| **R5-08 Media — proyección/almacenamiento** | DS UC-14 concentra saldo confirmado y tránsito validado en `:LibroCuentaCorriente`, sugiriendo implícitamente que tránsito ya es persistente en Cuenta Corriente | Se expresa `:ServicioConsultaCuentaCorriente` como **lectura compuesta**, sin `COBRO` ni asientos por tránsito; diseño físico F04 sigue pendiente | RD-F04-003; no existe `PAGO_EN_TRANSITO` como tabla en el diccionario |
| **R5-09 Media — origen de datos UC-27** | `:RepositorioPedidos (ENTREGA / CARGO_POR_VENTA)` confundía dominio de Pedido con asiento de Cuenta Corriente | `:ServicioConsultaVentasEfectivas` integra `ENTREGA` con `CARGO_POR_VENTA` en una consulta de solo lectura, sin fingir una misma tabla | `PEDIDO`, `ENTREGA`, `MOVIMIENTO_CUENTA` |
| **R5-10 Media — intentos/seguridad** | UC-26 creaba/recuperaba `Reembolso` en un mismo evento ambiguo, describía `numeroIntento=sig` y trataba `idUsuarioReintento` como argumento suficiente | Se aclara recuperación/alta **única por Cobro**, número correlativo e UUID de idempotencia nuevo, rol Admin comprobado en identidad autenticada; no se afirma servicio implementado | MR-5 tablas 58/59, RD-F01, reglas F06 reseñadas por Gemini |
| **R5-11 Alta — asincronía** | Efectos financieros podían figurar en UC-26 y UC-49 sin evidenciar una **única primera transición a PROCESADO** | DSS/DS/contrato precisan idempotencia entre respuesta inmediata y webhook tardío; un solo EGRESO y AJUSTE_DEBITO. **No sustituye pruebas de concurrencia** | MR-5 tablas 58–60 y política de estados de Reembolso |

**Preservado sin cambio de negocio:** UC-22 Caja manual excluye pagos de Clientes y reembolsos automáticos; UC-23 Libro Diario es registro de ingresos/egresos y **no utilidad**; UC-14 muestra saldos confirmado/provisional/transitorio sin filtrar dichos saldos por fecha; UC-27 cubre período y venta individual, costos históricos `ELABORADO`/`REVENTA` e indicador de incompletitud; UC-26/49 no reembolsan parcialmente ni alteran COBRO con estados inexistentes.

## 3. Metodología M-0 a M-7

| Etapa | Control | Dictamen |
|---|---|---|
| **M-0** | Prelación de RD-F01, F04-001..007, RP004/RP028 y MR5/MR6 frente a borrador Gemini; 64 CU vigentes | Contrastada funcionalmente; no se infirieron nuevos UC |
| **M-1** | Conservación de paquete completo + originales extraídos; separar originales de propuestos | Completado |
| **M-2** | Extracción de 2 XML; validación de originales con parser XML de biblioteca Python; estructura textual propuesta y unicidad de ID por página | Originales parseados; propuestas pasan verificación textual; round-trip pendiente |
| **M-3** | DSS ↔ DS ↔ contrato por operación pública/argumentos/orden | **8/8 homologados** |
| **M-4** | Estados Cobro, tránsito, rendición, contraasientos, reembolsos, consulta de margen | Núcleo corregido; concurrencia real no probada |
| **M-5** | PK, FKs y columnas de las tablas 13 y 54–60 contra secuencias/contratos | Clave de `ENTREGA` y campos de evento corregidos |
| **M-6** | Lifeline = una instancia; separar operaciones y colaboradores; registrar origen de visibilidad | Correcciones puntuales; visibilidad Larman completa todavía no demostrada |
| **M-7** | Comparar versiones publicadas, detectar IDs repetidos, contratos completos y firmas; reservas y dictamen | Cierre documental estático con pendientes |

## 4. QA sobre `propuestos/` leído desde GitHub

| Artefacto | Páginas | Cantidad de `mxCell` por página |
|---|---:|---|
| `DSS_REV05_CORREGIDO.drawio.xml` | 2 | 21, 35 |
| `DS_REV05_CORREGIDO.drawio.xml` | 7 | 21, 35, 23, 20, 33, 30, 28 |
| `CONTRATOS_REV05_CORREGIDOS.md` | — | 8 contratos, **nueve apartados por contrato** |

- **8/8 operaciones** con nombre y argumentos idénticos en DSS, DS y contrato (tras normalizar espacios y escapes XML).
- **9/9 páginas** detectadas; `mxCell` IDs únicos por página.
- Analizador textual de marcas/atributos/entidades XML en versiones propuestas no encontró desbalance ni entidades inválidas.
- **Distinción obligatoria:** los dos XML originales fueron interpretados correctamente por parser XML Python. Las versiones corregidas fueron cotejadas con un **analizador textual**, sin parser externo/Draw.io ni prueba de guardado/edición. No es validación visual de diagramas.

## 5. Reservas abiertas (no convertir en hechos implementados)

1. **Visibilidad y semántica académica:** cotejo exhaustivo de fichas de UC de tres niveles y matriz Rol×CU, más las asociaciones y parámetros que fundamentan cada mensaje; no declarar 100 % certificación Larman sin diagrama de clases.
2. **Rendición y pagos en tránsito:** F04 define reglas funcionales, pero **no** tabla, conciliación de excedentes/parciales ni servicio real. Aplicar autorizaciones, evidencia, cierre de recorrido y tratamiento de diferencias sin imaginar esquemas.
3. **F06 / MercadoPago:** webhooks, firmas, deduplicación, carreras entre UC-26 y UC-49, respuesta perdida después de commit, reintentos y transacciones **no probados**. No se atribuye atomicidad distribuida con MercadoPago.
4. **UC-14:** saldo provisional es proyección (RD-F04-003); saldos negativos, pagos parciales/excedentes y disputas requieren decisión. No introducir `max(0,…)` ni crédito definitivo sin aprobación.
5. **UC-27:** completitud de costos y asignación de tramos se validarán con datos históricos reales; no reemplazar costo faltante por cero ni por costos actuales.
6. **Draw.io y entorno:** falta abrir, inspeccionar visualmente, mover y guardar/reabrir los **9 diagramas**. No se ejecutó DDL, PostgreSQL, pruebas de servicios, Word ni merge.
7. **Cotejo exacto de fase 4:** los textos de los 7 CU en el Word maestro de 64 CU y 3 niveles no se relevaron aquí de manera íntegra; el resultado es revisión transversal documental, no sustituto del cotejo de fichas.

## 6. Dictamen de adopción

**REV-05 queda preintegrado como paquete de propuesta en GitHub.** Se acepta sustancialmente el trabajo de Gemini, con correcciones limitadas y trazables de las once filas R5-01..R5-11. Su carácter es **provisional / documental**, no corrección física de MR-5/MR-6, no certificación UML definitiva y no aprobación para fusionar.

**No modificar `main`, Fase 4 Word, DDL, diagrama de CU ni PR anteriores sin autorización.**
