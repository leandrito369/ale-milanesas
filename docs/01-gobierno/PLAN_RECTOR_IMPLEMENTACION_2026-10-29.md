# Plan rector de implementación y entrega — Sistema Ale Milanesas

**ID:** PLAN-IMP-2026-10-29 · **Estado:** ADOPTADO por el responsable del proyecto el 29/10/2026 como plan de trabajo; NO constituye aprobación automática de diseños técnicos o reglas comerciales pendientes.  
**Método:** Proceso Unificado adaptado, iterativo e incremental, con UML, contratos de operaciones, trazabilidad y evidencia verificable.  
**Ámbito:** los 64 CU consecutivos; no renumerar. No alterar unilateralmente el alcance aprobado.

## 1. Punto de partida y nivel de evidencia

- El responsable informó el 29/10/2026 que **los DSS, DS y contratos de operaciones de los 64 CU están completados**. Este avance es una **declaración de situación del usuario**; la copia canónica individualizada de esos artefactos y su cotejo no están todavía verificados en el árbol del repositorio. Importarlos/indexarlos es tarea B0.
- Sí está presente `docs/04-casos-uso/CASOS_DE_USO_64_TRES_NIVELES.docx`. Los 64 CU no deben volver a una numeración histórica de 49.
- El modelo más reciente en el repositorio describe **60 tablas, 453 columnas y 125 FK** (MR-3/MR-5). MR-6 ejecutó y superó pruebas seleccionadas en **PostgreSQL 17.11** de laboratorio, incluidas migración 59→60 y concurrencia; **no** implica que todo el SQL esté listo para producción ni que existan servicios de aplicación. Consultar `docs/05-modelo-relacional/MR6_INFORME_EJECUCION_2026-10-26.md`.
- F01 definió `COBRO.estadoCobro = CONFIRMADO | ANULADO` y conserva un parche post MR-5; no inferir estados desde pruebas históricas. F04 cerró reglas funcionales offline/rendición pero dejó **propuesta técnica no aprobada** de sincronización, persistencia y API. Consultar las RD-F04-001..007 y `docs/06-arquitectura/F04_CIERRE_FUNCIONAL_MAESTRO_2026-10-26.md`.
- No hay evidencia de backend, clientes Android/web ni integraciones completos en el árbol inspeccionado el 29/10. Las pruebas de BD MR-6 son reales y deben preservarse, no repetirse como si nunca se hubieran realizado.
- No reabrir de forma indiscriminada el análisis ni sustituir diagramas rechazados: toda contradicción se tramita como RP/CR con decisión expresa cuando sea de negocio.

## 2. Objetivo general y principio rector

Obtener una **aplicación ejecutable, reproducible, segura y demostrable**, que aplique los contratos y reglas aprobados de Ale Milanesas, con base de datos, servicios, API, interfaces, sincronización e integraciones, y cierre mediante verificación, validación y entrega académica.

**Regla de ejecución:** trabajar por **recorridos verticales** (persistencia + dominio + aplicación + API/UI + pruebas) en vez de programar 64 CU aislados o construir 60 tablas como 60 clases UML. Cada incremento debe dejar una función verificable y evidencia registrada.

## 3. Bloques B0–B10: trabajo, dependencias y entregables

| Bloque | Objetivo | Salida verificable | Dependencia |
|---|---|---|---|
| **B0 — Línea base de construcción** | Inventariar/reconciliar 64 CU, DSS, DS, contratos, RD/RP, modelo MR-5/MR-6 y permisos; fijar prioridades y arquitectura candidata | E01 matriz CU→operación→responsable→persistencia→prueba; registro de brechas y backlog | Inmediato |
| **B1 — Arquitectura y entorno** | Estructura del código, decisiones arquitectónicas aprobables, CI, contenedores y configuración sin secretos | E02 arquitectura, esqueletos arrancables y comandos reproducibles | B0 mínimo |
| **B2 — PostgreSQL de aplicación** | Convertir SQL validado en laboratorio a migraciones versionadas, seeds ficticios, permisos y pruebas; no degradar MR-6 | E04 migraciones reproducibles y tests de integridad | B0/B1 |
| **B3 — Dominio y servicios** | Implementar clases de diseño, reglas, aplicación, repositorios, transacciones e idempotencia según DS/contratos | E06 servicios integrados y tests de contrato | B1/B2 por módulo |
| **B4 — API y seguridad** | Exponer operaciones con DTO, validación, autenticación y autorización real por CU/rol; documentar contratos HTTP | E05 OpenAPI y pruebas API/RBAC | B3 por recorrido |
| **B5 — Interfaces** | Web (personal/administración/cliente/proveedor según alcance) y Android (movilidad); accesibilidad y errores | E07 pantallas navegables con E2E | B3/B4 por recorrido |
| **B6 — Integraciones** | Mercado Pago, mensajería WhatsApp y rutas OSRM mediante adaptadores, mocks/sandbox y reintentos | E08 integraciones aislables y pruebas de fallos | B3/B4 |
| **B7 — Offline y sincronización** | Room/cola local, identidad estable de operaciones, inbox o equivalente aprobado, conflictos y conciliación | Operaciones admitidas offline y suite de desconexión/idempotencia | Cierre técnico F04 + B3/B4 |
| **B8 — Verificación y validación** | Tests unitarios/integración/API/E2E, concurrencia, seguridad, no funcionales y aceptación | E09 resultados ejecutados y E11 actas con evidencia | Continuo; cierre integral |
| **B9 — Despliegue y operación** | Instalación reproducible, configuración, respaldos, restauración y validación del negocio | Versión candidata desplegable, sin secretos reales en Git | B1–B8 esenciales |
| **B10 — Documentación y defensa** | Manual técnico/usuario/instalación, trazabilidad, demostración, paquete de entrega | E10 manuales y E12 entrega académica | Continuo; final |

**E03** será el repositorio de código fuente y configuración versionada. Orden **orientativo**, no calendario contractual. B8 y B10 se realizan desde el inicio; B3–B7 se solapan por incrementos.

## 4. Incrementos verticales prioritarios

| Incremento | Recorrido y valor | Hito de aceptación |
|---|---|---|
| I0 | B0 + B1 mínimo + laboratorio DB sin afectar SQL histórico | Repositorio y base de aplicación arrancan desde cero |
| I1 | Usuarios/Roles, Clientes, Productos, Insumos, Proveedores, Precios y búsquedas según dependencias | Identidades/datos maestros seguros, visibles y persistidos |
| I2 | Cargar Pedido, Detalles, políticas y precio histórico, asignación y consulta | Pedido confirmado con importe/snapshot verificable |
| I3 | Recetas versionadas, Preparación, consumos, REVENTA y Entrega | Pedido → Preparación → Entrega con integridad y coste histórico |
| I4 | Cancelaciones, Excedentes, Cuenta Corriente, Cobro, Caja y margen bruto | Circuito comercial-financiero íntegro sin doble efecto |
| I5 | Faltantes, cotizaciones, decisión humana, Orden y Recepción | Reposición trazada, nunca compra automática sin confirmación |
| I6 | ONLINE, OTP Cliente, promociones, pagos, reembolsos, WhatsApp/OSRM, offline | Canales e integraciones probados ante falla/reintento |
| I7 | Regresión, seguridad, rendimiento, despliegue y aceptación | Paquete instalable y demostración reproducible |

**Hito A (versión operativa evaluable):** circuito real Pedido → Preparación → Entrega → Cuenta Corriente → Cobro/Caja, con interfaz y pruebas. **Hito B:** alcance comprometido de 64 CU, más excepciones e integraciones, validado. Si el cronograma exigiera recortar alcance, tramitar cambio y acuerdo de cátedra; no declarar completitud ficticia.

## 5. Arquitectura de referencia, NO imposición de diseño nuevo

Como punto de partida previsto en el proyecto: **backend Java/Spring Boot, PostgreSQL, web Thymeleaf y Android Kotlin/Room**, más adaptadores de Mercado Pago, WhatsApp y OSRM. Recomendar **monolito modular**, servicios de aplicación transaccionales, dominio aislado de HTTP/ORM, APIs expresas, migraciones versionadas (candidato: Flyway), pruebas de PostgreSQL real (candidato: Testcontainers) y CI. Aceptar o ajustar decisiones técnicas en B0/B1 mediante ADR/CR antes de crear dependencias duraderas.

**No** crear 60 clases de dominio calcadas de 60 tablas; el modelo conceptual y el relacional son niveles distintos. Los controladores no definen reglas comerciales: deben ejecutar el comportamiento de los contratos aprobados.

## 6. Definición de terminado por CU y por incremento

Un CU implementado requiere: (1) trazabilidad a especificación vigente, DS/DSS y contrato; (2) reglas/precondiciones/postcondiciones en servicio de dominio/aplicación; (3) persistencia y transacciones coherentes; (4) permisos y validación; (5) interfaz o canal de entrada con errores comprensibles; (6) caminos alternativos/negativos relevantes; (7) pruebas ejecutadas con datos iniciales/resultados observables; (8) evidencia y documentación actualizadas. «Compila» ≠ «probado» ≠ «validado por negocio».

**Suite mínima por capa:** unitarias, integración PostgreSQL, API/RBAC, UI E2E, concurrencia/idempotencia, adaptadores externos simulados/sandbox, offline red intermitente, seguridad, rendimiento y aceptación. Cada test reproducible registra preparación, operación, estado esperado y estado posterior; sin dependencia de datos productivos.

**Escenarios de alto riesgo obligatorios:** congelamiento de precio y receta; límite de Preparación original; reasignación de Excedentes sin nuevo consumo; Entrega parcial y correcta imputación; COBRO idempotente; webhook duplicado sin asientos extra; teléfono ONLINE ambiguo bloqueado; decisión humana antes de compra; operación offline reenviada sin duplicar; rendición y pago en tránsito sin alterar Caja indebidamente. Los identificadores de CU exactos se verifican en el catálogo actual, no se importan de numeraciones anteriores.

## 7. Entregables con identificador

- **E01** línea base y matriz de trazabilidad; **E02** arquitectura/ADRs; **E03** código ejecutable; **E04** esquema y migraciones; **E05** OpenAPI/API; **E06** servicios; **E07** interfaces; **E08** integraciones; **E09** suite de pruebas e informes; **E10** manuales; **E11** aceptación del negocio; **E12** paquete académico/defensa.
- Cada entrega registra **ruta, versión/cambio (CR), requisitos/CU, autor, estado APROBADO/PROPUESTO/IMPLEMENTADO/PROBADO, comandos y evidencias, límites conocidos**.
- No confundir una PR documental con aplicación implementada; las etiquetas y evidencias deben corresponder a ejecuciones reales.

## 8. Gobierno, delegación y puertas de aprobación

La guía `docs/06-arquitectura/GUIA_DELEGACION_AGENTES_2026-10-29.md` regula asignaciones a Antigravity, OpenCode u otros agentes. Todos deben leer `AGENTS.md` y el protocolo, operar en **rama+PR**, no sobrescribir `main`, no cambiar RD comerciales/num CU ni migrar bases reales sin aprobación. Un único integrador valida el diff.

**Gates:** G0 B0 aprobado (inventario y mapa de dependencias); G1 proyecto arrancable + migración aislada probada; G2 primer pedido visible y persistido; G3 Hito A; G4 integraciones/offline con evidencia; G5 aceptación de negocio y paquete final. En cada gate: PRs, matriz, resultados reproducibles y pendientes explícitos.

## 9. Riesgos y decisiones activas

- **R1** desajuste entre DOCX de 64 CU, DSS/DS/contratos disponibles fuera del repositorio y esquema de 60 tablas; **B0 inventaría y bloquea código dependiente de brechas**.
- **R2** F04 offline/rendición: funcionalmente acordado, persistencia S-01/API todavía propuesta; se exige CR antes de modificar esquema.
- **R3** MR-6 prueba un subconjunto del DDL, no seguridad HTTP ni coherencia completa de servicios; conservar workflow y ampliar pruebas.
- **R4** integración real de pagos/mensajería: secretos, datos personales e idempotencia; usar sandbox/mocks, nunca credenciales/producción en Git.
- **R5** volumen de 64 CU para un desarrollador: priorizar verticales completos, controlar dependencias y negociar alcance si el plazo académico no permite el total.

## 10. Primera acción autorizada

**Ejecutar B0** según `docs/01-gobierno/B0_LINEA_BASE_IMPLEMENTACION_2026-10-29.md`. B0 entrega documentación técnica y un backlog ejecutable; **no autoriza** por sí mismo SQL productivo, cambios de reglas o agentes ejecutando cobros reales. Estado inicial: PLAN ADOPTADO; B0 EN PREPARACIÓN; B1–B10 NO INICIADOS salvo evidencia histórica específica (MR-6).
