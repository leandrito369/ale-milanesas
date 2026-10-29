# REV-04 — Auditoría selectiva de Gemini (Lote 4A/4B)

**Fecha:** 28/10/2026 · **Proyecto:** Sistema de Gestión para Ale Milanesas · **Corte:** revisión y corrección documental estática, **NO validación académica ni implementación**.  
**Rama:** `revision/rev04-pedidos-entregas-2026-10-28` (desde revisión REV-03/PR #12).  
**Regla metodológica de adopción:** conservar íntegro lo correcto de Gemini; intervenir **solo** cuando exista contradicción comprobada con RD aprobada, campo/clave del MR-5/MR-6, o defecto material UML/contractual. Preservar originales y registrar cada modificación.

## 1. Fuente y alcance comprobados

- Fuente inalterada: `originales/LOTE4_GEMINI_ORIGINAL_2026-10-28.md`, que incluye los informes REV04A/04B, dos DSS, dos DS y catorce contratos individuales. Se conservaron, además, cuatro XML y cuatro documentos de informe/contratos extraídos por separado como `originales/`.
- **REV-04A, 6 CU:** UC-34, UC-03, UC-21, UC-43, UC-04 y UC-25, con **7 operaciones** (la reprogramación RP-020 es una operación adicional **sin crear UC-65**).
- **REV-04B, 6 CU:** UC-28, UC-05, UC-06, UC-61, UC-07 y UC-41, con **7 operaciones** (oferta y respuesta de excedentes tienen contratos independientes).
- Gobierno cotejado literalmente con RD-RP001/RP019, RD-RP002-001, RD-RP020-001 y RD-RP023-001, más RD-RP004/RP028-001 para los alcances de saldos. Se consultó el diccionario MR-5/MR-6 de 60 tablas.
- RD-F04-001..007: el paquete de Gemini y el seguimiento de gobierno registran sus reglas funcionales, pero esta auditoría **no recuperó el documento primario íntegro** de F04. No declarar cotejo palabra por palabra de F04 ni prueba de su ejecución.

## 2. Aplicación del método M-0 a M-7

| Puerta | Revisión | Resultado |
|---|---|---|
| M-0 Autoridad | Comparar decisiones expresas y esquema actual de **60 tablas**; no reutilizar 59 tablas/49 CU como únicos canónicos | RD-RP002/RP023/RP020 y PK de Asignación/Entrega verificadas |
| M-1 Proveniencia | Preservar paquete, informes, XML y contratos Gemini en `originales/` antes de editar | Completa |
| M-2 Integridad | Analizar estructura XML, entidades, número de páginas e IDs únicos **por página** | Superada en control textual |
| M-3 Trazabilidad | DSS evento público → DS mensaje actor → contrato Nombre, incluidos reprogramación y respuesta excedente | **14/14 firmas homologadas** |
| M-4 Escenarios | Revisar fecha ONLINE, promociones, asignaciones, offline, entregas, cobros provisionales y excedentes | Núcleo funcional coherente con reservas |
| M-5 Modelo | Cotejar existencia de claves y campos; distinguir concepto UML de tabla persistente | Corregidas tres claves/entidades físicas; persistencia parcial pendiente |
| M-6 UML/GRASP | Identidad de instancias y separación de escenarios; referencias por parámetro/local/creación frente a asociación no demostrada | Correcciones puntuales; **visibilidad Larman no certificada** |
| M-7 Dictamen | Verificación del resultado versionado; documentar reservas de herramienta, concurrencia, Word, RBAC | Cierre de trabajo documental **con reservas** |

## 3. Intervenciones materiales (antes → después → evidencia)

| ID | Artefacto y motivo | Corrección mínima realizada | Fundamento |
|---|---|---|---|
| **R4-01 (Alta)** | Gemini en UC-43 presentó como las «seis reglas de RP-002» otra lista donde el motivo/concurrencia reemplazaban historial y no asignar a deshabilitados | DSS/DS/contrato contienen las **seis reglas realmente aprobadas**: Pedido PENDIENTE, cuenta habilitada+Rol, unicidad vigente, conservar historial, prohibir Repartidor deshabilitado y **solo online**. Motivo/concurrencia permanecen como **controles adicionales**, no como sustitutos | `RD_RP002_001_ELEGIBILIDAD_ASIGNACION_UC43_2026-10-27.md` |
| **R4-02 (Alta)** | REV04A equiparaba «mayor beneficio económico» con «mayor porcentaje» en promociones simultáneas | Selección expresada como **mayor beneficio económico elegible**; no se supone que el porcentaje aislado determine todo el resultado | `RD_RP023_001_PROMOCIONES_SIMULTANEAS_2026-10-27.md` |
| **R4-03 (Alta)** | UC-43 devolvía `idAsignacion` inexistente en la tabla; UC-05 devolvía `idEntrega` inexistente; UC-41 usaba `idMovimiento` ambiguo | UC-43 devuelve referencia compuesta `(idPedido,numeroAsignacion)`; UC-05 confirmación de entrega por `idPedido`; UC-41 usa `idMovimientoExcedente`. DSS, DS y contratos homologados | Diccionario MR-5/MR-6, tablas 12, 13 y 17 |
| **R4-04 (Alta)** | En UC-03 la reprogramación de un Pedido existente estaba dentro de un fragmento `opt` tras crear el mismo Pedido; mensaje usaba objeto `nuevoPedido` de la operación anterior | Se la representa como **escenario público independiente** en la misma página, orientado a recuperación/revalidación en repositorio; **no se creó CU adicional** | `RD_RP020_001_REPROGRAMACION_PEDIDOS_2026-10-27.md` |
| **R4-05 (Media)** | DS UC-03/21 representaban `Pedido + DetallePedido` en la misma lifeline; DS UC-21/43 juntaban repositorio con catálogo, DS UC-25 adaptador con servicio externo | Se separaron conceptos/lifelines; en UC-03 y UC-21 los detalles tienen una creación ilustrativa; en UC-21 las promociones se consultan a colaborador distinto; UC-43 separa catálogo de usuarios | UML: cada lifeline representa una instancia, no una colección de clases distintas |
| **R4-06 (Alta)** | UC-05 trataba el snapshot de asignación offline como potencial sustituto suficiente de asignación vigente tras reprogramación | DSS/DS/contrato exigen **conciliación servidor y resolución explícita del conflicto** antes de confirmar; repetición de idempotencia reconoce entrega previa en lugar de duplicar/rechazarla indiscriminadamente | RD-RP020: una captura offline con asignación invalidada **no obtiene aceptación automática** |
| **R4-07 (Alta)** | DS/contrato UC-05 sugerían `importeEfectivoVenta` y efectivo en tránsito como campos almacenados directamente en `ENTREGA` | Instancia `Entrega` ajustada a `idPedido`, `fechaHoraEntrega`, `idUsuarioRepartidor`; cargo comercial y efectivo provisional se consideran **efectos lógicos diferenciados**, con persistencia técnica de tránsito pendiente | Diccionario MR-5/MR-6, tabla 13 `ENTREGA`; RD-RP004/RP028 y F04 |
| **R4-08 (Media)** | DS UC-28 mezclaba `Preparacion + MovimientoInsumo`, DS UC-07 mezclaba `Pedido + MovimientoExcedente` | Etiquetas de participantes corregidas; en UC-07 se añadió creación independiente del movimiento. No se cambiaron reglas de cantidades/costos | UML y tablas 07, 09, 10 y 17 |
| **R4-09 (Media)** | Contrato UC-25 afirmaba persistencia de `RutaReparto` como si fuera esquema vigente | Se preserva como **objeto conceptual** de la secuencia sugerida, sin afirmar tabla/DDL preexistentes ni inventar persistencia | MR-5/MR-6 60 tablas **no incluye** `RUTA_REPARTO` ni `DETALLE_RUTA_REPARTO` |
| **R4-10 (Alta documental)** | Historial de fechas de Pedido y efectivo en tránsito son obligaciones funcionales posteriores pero no estructuras físicas del catálogo actual | Se conservan como **reglas aprobadas / comportamiento requerido**, con reserva explícita de diseño físico; no se crea `HISTORIAL_FECHA_PEDIDO` o `EFECTIVO_EN_TRANSITO` por inferencia | RD-RP020 y MR-5/MR-6, sin esas tablas |
| **R4-11 (Media)** | Contrato UC-21 llamaba «atómicas» a las postcondiciones de pago externo sin distinguir proveedor y BD | Se aclaró que la consistencia transaccional de registros **internos** sucede tras acreditación externa; no se presupone transacción distribuida MercadoPago↔BD | Semántica de integración y ausencia de pruebas de proveedor |
| **R4-12 (Menor)** | DSS mezclaba en una lifeline el servicio de mensajería y MercadoPago | Quedó una sola instancia `:ServicioDeMensajeria`; el cobro externo se representa por el `ref UC-29` | Identidad UML de líneas de vida |

**No modificados funcionalmente:** búsqueda de Pedido UC-34; consulta asignada UC-04; preparación proporcional y costos UC-28; cancelación UC-06; búsqueda de Excedentes UC-61; oferta/aceptación de Excedentes UC-07, descarte UC-41. Mantener sus reglas salvo contradicción verificable futura.

## 4. Entregables y QA real (sobre GitHub)

| Artefacto propuesto | Páginas | Celdas por página |
|---|---:|---|
| `DSS_REV04A_CORREGIDO.drawio.xml` | 3 | 27, 28, 21 |
| `DS_REV04A_CORREGIDO.drawio.xml` | 6 | 20, 33, 38, 30, 20, 28 |
| `DSS_REV04B_CORREGIDO.drawio.xml` | 3 | 21, 18, 24 |
| `DS_REV04B_CORREGIDO.drawio.xml` | 6 | 29, 36, 27, 20, 34, 24 |

**Total:** 18/18 páginas, cada una con IDs `mxCell` únicos; sin entidades XML inválidas ni desajustes de etiquetas según analizador estático propio. `CONTRATOS_REV04A_CORREGIDOS.md` contiene 7 contratos de 9 apartados; `CONTRATOS_REV04B_CORREGIDOS.md` contiene otros 7 de 9 apartados. **14/14 nombres y argumentos de operaciones homologados** entre DSS/DS/contrato, normalizando espacios/escapes XML.  
**Límite QA:** el control propio no sustituye parser XML de biblioteca externa ni apertura/guardado/round-trip y validación gráfica humana en Draw.io. No se probó software ni SQL.

## 5. Puertas de certificación todavía pendientes

| Reserva | Riesgo no inventado | Qué evidenciar |
|---|---|---|
| **P-01 — F04 primaria** | Documentación de F04 citada por Gemini, no cotejada literal aquí en totalidad | Documento RD-F04-001..007, snapshots, validez, resolución de conflicto y rendición |
| **P-02 — persistencia histórica / dinero** | `RUTA_REPARTO`, historial de fecha y efectivo en tránsito no tienen tablas en el diccionario 60 | Decisión de modelo físico y mecanismo auditado, sin migración arbitraria |
| **P-03 — visibilidad Larman** | Controladores→repositorios y entidades existentes sin atributo/asociación demostrada | Diagrama de clases de diseño y origen de las referencias en mensajes |
| **P-04 — concurrencia y pagos** | Idempotencia, doble entrega, simultaneidad UC-43/55/05, rendición de efectivo, transacciones MercadoPago | Pruebas de servicio y casos concurrentes con rollback/compensación |
| **P-05 — Word 64 CU** | No se ejecutó cotejo literal exhaustivo de las **36 fichas** (12 CU × Alto/Extendido/Real) ni reconciliación formal de las RD posteriores | Cotejo sistemático contra `main/docs/04-casos-uso/CASOS_DE_USO_64_TRES_NIVELES.docx` y adendas explícitas |
| **P-06 — geometría Draw.io** | Fragmentos nuevos, largos y ubicación de participantes no validados en la interfaz gráfica | Abrir, mover, guardar y reabrir las 18 páginas; inspeccionar solapes y marcas de activación |
| **P-07 — roles / contrato físico** | Usuario interno autorizado para reprogramación no definido por nombre de rol en RD-RP020 | Matriz RBAC aprobada, sin asignar permisos por inferencia |

## 6. Dictamen

**Lote 4A/4B: CICLO DE CORRECCIÓN DOCUMENTAL ESTÁTICA CERRADO**, adoptando mayoritariamente Gemini con cambios limitados a los hallazgos R4-01..R4-12.  
**NO cerrado:** certificación académica final, pruebas del sistema, propagación del Word, autoridad total de F04, diseño de persistencia y Draw.io visual. Mantener PR como **DRAFT abierto**, sin fusionar PR #9..#12 ni `main`, sin cambiar DDL, diagrama general de casos de uso ni ficha original.

Este dictamen no afirma «sin errores» ni «100 % validado» donde no existe evidencia.
