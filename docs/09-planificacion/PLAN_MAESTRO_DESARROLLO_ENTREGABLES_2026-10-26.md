# Plan Maestro de Desarrollo y Entregables — Ale Milanesas

**Versión:** 0.1 para revisión · **Fecha:** 26/10/2026  
**Estado:** PLAN PROPUESTO; requiere revisión y aprobación del responsable del proyecto antes de fijarlo como hoja de ruta vigente.  
**Ámbito:** Trabajo Final de Analista en Sistemas, gestión real de elaboración/venta de milanesas; documentación académica, sistema implementable y evidencia verificable.

## 1. Propósito y criterio de verdad

Coordinar requisitos, análisis, diseño, implementación, pruebas y entrega académica en **incrementos verificables**, evitando confundir:
- **APROBADO:** decisión funcional ratificada por el responsable.
- **PROPUESTO:** diseño o plan pendiente de ratificación.
- **IMPLEMENTADO:** código integrado al repositorio correspondiente.
- **PROBADO:** ejecución con evidencia reproducible y alcance explícito.
- **PENDIENTE:** trabajo todavía no completado.

La planificación no amplía el negocio automáticamente. Toda modificación de CU, roles, estados, campos, esquema, reglas de precio, UML o alcance exige RD/CR y PR.

## 2. Línea base verificable al 26/10/2026

| Elemento | Estado verificable y límite |
|---|---|
| Catálogo funcional | **64 CU, UC-01…UC-64** y 3 niveles por CU (192 fichas). Fase 4 consolidada; **DOCX maestro nativo aún no importado a GitHub**, y la auditoría semántica integral no está acreditada. |
| UML de CU | Siete nuevas relaciones «include» aprobadas. **El diagrama alternativo rechazado no se reemplaza ni publica como vigente.** |
| Modelo relacional | **60 tablas / 453 columnas / 125 FK** en MR-3/MR-5; MR-6 probó esquema, restricciones, migración sin datos y escenarios seleccionados en PostgreSQL 17.11 descartable. No equivale a producción. |
| Diagrama relacional | XML corregido aprobado por usuario y fusionado mediante PR #3. |
| F01 | Estados `COBRO.estadoCobro` = `CONFIRMADO`/`ANULADO`; parche y pruebas de BD en PR #4 fusionado, con [CI satisfactoria #40371508731](https://github.com/leandrito369/ale-milanesas/actions/runs/40371508731). Sin servicio financiero integral probado. |
| F04 | **Análisis funcional cerrado**; RD-F04-001..007 y acta maestra fusionadas por PR #5. Contrato S-01 **borrador**; sin implementación offline ni nuevas estructuras aprobadas. |
| F02/F03/F08/F09 | Restricciones y pruebas de BD seleccionadas; hay trabajo de integración, controles y concurrencia aún pendiente. |
| F05/F06/F07 | Contratos parciales y soporte SQL; **servicios reales todavía no implementados ni probados**. |
| Gobierno | [PR #7](https://github.com/leandrito369/ale-milanesas/pull/7) abierto para actualizar `docs/ESTADO_ACTUAL.md`; no declararlo fusionado sin verificar. |
| Aplicación | **Sin backend, Android, web, integraciones o despliegue acreditados en el repositorio.** |

Documentos de referencia: `AGENTS.md`, `docs/ESTADO_ACTUAL.md`, `docs/00-contexto/CONTEXTO_MAESTRO_2026-10-25_v1.0.md`, `docs/01-gobierno/PROTOCOLO_CAMBIOS_Y_CHATS.md`, `docs/05-modelo-relacional/MR4_HALLAZGOS.csv`, MR-6 y RD-F04.

## 3. Arquitectura organizativa de repositorios: decisión futura propuesta

### Recomendación

**Mantener por ahora el repositorio actual `leandrito369/ale-milanesas` como fuente documental y de decisiones. Cuando se inicie la programación real, crear un segundo repositorio de aplicación, por ejemplo `ale-milanesas-app` (nombre por aprobar).**

No crear el segundo repositorio prematuramente: el hito es la aprobación de arquitectura y el inicio del esqueleto ejecutable.

| Repositorio | Propiedad y contenido |
|---|---|
| **Actual — documentación/academia** | RD/RP/CR, CU y DOCX originales, DSS, DSD, contratos de operación, diagramas, arquitectura aprobada, diccionario, actas, plan maestro, trazabilidad, informes, validación académica. Conservar DDL MR-3/MR-5/MR-6 **histórico y evidencia**. |
| **Futuro — aplicación** | Java/Spring Boot, Android/Kotlin/Room, vistas web/Thymeleaf cuando corresponda, **migraciones ejecutables vigentes** (Flyway/Liquibase o mecanismo elegido), pruebas, scripts/infraestructura, CI y documentación mínima para ejecutar el software. |

**Regla antideriva:** un solo origen editable por artefacto. Para nuevas migraciones de código, el repositorio de aplicación será la fuente ejecutable y se documentará el modelo aprobado y la referencia exacta a su commit en el repositorio académico. No mantener dos versiones independientes de DDL «vigente». Las RD y los CU seguirán siendo autoridad funcional en el repositorio documental.

**Sincronización entre repositorios:** PR vinculados entre sí, identificadores CU/RD/CR, enlaces a commits y releases, matriz de versiones cruzadas en el plan de publicación. Un cambio funcional aprobado antes del código; pruebas junto al PR de implementación.

### Alternativa aceptable
Si el costo de coordinación supera las ventajas, mantener monorepo con `docs/`, `backend/`, `android/` y `infra/`. La separación **es recomendación de organización, no requisito académico confirmado**.

## 4. Etapas, prioridades, dependencias y entregables

**P0 = iniciar antes del núcleo de desarrollo; P1 = siguiente incremento; P2 = integración avanzada; P3 = cierre.** No son fechas calendario comprometidas.

| ID | Bloque | Prioridad / depende de | Entregables principales | Criterio de salida |
|---|---|---|---|---|
| **B0** | Gobierno, respaldo documental y alcance | **P0**, ya iniciado | PR #7 revisado; DOCX Fase 4 nativo importado; RP/RD actualizados; inventario maestro; alcance de MVP; plan académico | Fuentes trazables y versiones inequívocas; pendientes reales identificados |
| **B1** | Diseño académico: DSS/DSD y contratos de operación | **P0**, B0 en paralelo | DSS, DSD, índice de operaciones, contratos seleccionados, matriz CU↔operación↔modelo de dominio; QA | Operaciones y nombres coinciden con CU; contratos declaran resultados, no algoritmos; no omiten excepciones |
| **B2** | Arquitectura e inicio del repositorio de código | **P0**, B0+B1 suficientes | ADR de repositorios; estructura Spring/Android/web; diagrama de componentes/despliegue; estándares; CI; migración base reproducible | Proyecto compila desde checkout limpio y levanta ambiente de prueba |
| **B3** | Seguridad e identidad **F07/F09** | **P0**, B2 | Servicios UC-01/17/18/53/54/55; roles, revocación de sesiones y protección frente a inactivaciones; matriz RBAC revisada | Pruebas funcionales/seguridad de permisos, último Admin, concurrencia y rechazo de accesos indebidos |
| **B4** | Maestros y primer circuito comercial | **P1**, B3 | Clientes, Productos, Insumos mínimos, precios/políticas; UC-03 Pedido, UC-43 asignación, UC-05 Entrega, UC-29 Cobro, Cuenta/Caja; pruebas F02 | Demostración integral *Cliente→Pedido→Asignación→Entrega→Cobro→Caja/Cuenta* sin inconsistencias |
| **B5** | Implementar **F04** offline y pago en tránsito | **P1**, B4+B3 | Cola Room, sincronizador API, inbox/idempotencia, diseño/migración aprobado de pago en tránsito, saldos separados, rendición Admin, pruebas de red | Con reintentos, cortes y carreras no hay doble Pedido/Entrega/Cobro ni saldo/caja ficticios |
| **B6** | Preparación, stock, Excedentes y costos **F03** | **P1/P2**, B4+B3 | Recetas, preparación, movimientos, costo histórico, stock inicial, excedentes, costeo y pruebas | Stock y costos trazables; no consumo/transferencia doble; históricos inmutables |
| **B7** | Compras y **F05 PRA-01** | **P2**, B6+B3 | Proveedores, cotizaciones, OC, recepción, políticas de compra, motor de reposición y vencimientos | Máximo una ronda inicial por episodio, invitaciones sin duplicados y OC solo tras decisión humana autorizada |
| **B8** | ONLINE, promociones y **F06** | **P2**, B4+B3 | Canal UC-21, OTP, promociones, integraciones y reembolsos, eventos autenticados e idempotentes | Webhooks repetidos/rechazados no duplican efectos; canal online y permisos validados |
| **B9** | Integración, validación y entrega final | **P3**, B3–B8 según alcance ratificado | Suite E2E, seguridad, concurrencia, rendimiento básico, instalación de demo, manuales, informe final, presentación y evidencias académicas | Release reproducible, escenarios aceptados, entregables académicos y pendientes explicitados |

**Prioridad de primera versión demostrable (propuesta):** B0→B2→B3→B4, luego B5. B1 transcurre en paralelo siempre que no bloquee operaciones a implementar. B6/B7/B8 se integran por incrementos, no en paralelo indiscriminadamente si comparten recursos.

## 5. Correspondencia de hallazgos F01–F10 con el recorrido

| Frente | Estado para planificar | Tratamiento programado |
|---|---|---|
| F01 | Catálogo aprobado/SQL probado | B4/B9: servicio financiero + tests de anulación reales |
| F02 | SQL de integridad parcial/probado selectivamente | B4/B9: transacción Cobro, Caja y Cuenta; contraasientos |
| F03 | Restricciones SQL probadas selectivamente | B6: alta stock, costos, movimientos con concurrencia |
| F04 | **ANÁLISIS FUNCIONAL CERRADO** | B5: diseño físico, implementación, pruebas |
| F05 | PRA-01 diseñado, servicio pendiente | B7: episodio, disparos, comunicación, ventanas y recepción |
| F06 | Reembolsos SQL parciales | B8: integración, firmas, webhooks y aplicación única |
| F07 | SQL parcial de identidad/Roles | B3: RBAC API, sesiones y GRANT |
| F08 | Restricción de PROMOCION documentada | B8: respetar estado vigente; reactivación solo con nueva RD |
| F09 | Controles SQL parciales | B3/B4/B9: concurrencia y bajas lógicas |
| F10 | MR-6 PostgreSQL ejecutado | B2–B9: CI continuo y ampliación a pruebas de servicios |

## 6. Matriz de entregables académicos y técnicos

| Categoría | Fuente y artefactos esperados | Autoridad de revisión |
|---|---|---|
| Requisitos/análisis | RF/RNF/IRQ, actores, dominio, catálogo 64 CU a tres niveles, reglas comerciales, trazabilidad | Usuario + consignas/cátedra |
| Interacciones y diseño OO | **DSS, DSD, contratos de operación seleccionados**, modelo de clases de diseño, diagramas de paquetes/componentes/despliegue según necesidad académica | Usuario; revisión de consistencia con CU/dominio |
| Datos | DER relacional aprobado, diccionario, DDL histórico, migraciones versionadas, matrices de impacto y rollback | Usuario para cambio físico; PR+pruebas para ejecución |
| Arquitectura | Contratos API, decisiones ADR, seguridad, sincronización S-01, integraciones | Usuario aprueba reglas; ingeniería prueba diseño |
| Desarrollo | Backend, web, Android, persistencia, servicios, tests, infraestructura mínima reproducible | PR por incremento |
| Verificación y validación | Plan de pruebas, casos positivos/negativos, seguridad, concurrencia, evidencias CI, validación usuario | Evidencia ejecutada, no inferida |
| Trabajo Final | Informe de avance, registro de práctica si corresponde, memoria final, manual técnico y de usuario, instalación y defensa/demo | Cátedra según reglamento vigente confirmado |

**Advertencia académica:** el documento de Resolución CD 220/15 aportado menciona presentación de avances mensuales (días 1–5), seguimiento semanal, práctica mínima de 80 horas y documentación/manual final. Es una fuente de 2015: **verificar su vigencia y modalidad con la cátedra antes de fijarlo como calendario obligatorio 2026**.

## 7. Gobierno, responsables y coordinación IA

- **Responsable del proyecto (usuario):** acepta reglas del negocio y alcance, resuelve discrepancias académicas, revisa diagramas y autoriza cambios de alto impacto.
- **ChatGPT integrador:** contrasta fuentes oficiales, actualiza RD/RP/CR, audita trazabilidad, crea ramas/PR, valida cambios mediante pruebas disponibles y publica solo lo autorizado.
- **Gemini Web (colaborador):** elabora **borradores inspeccionables** (DSS/DSD, contratos, matrices, auditorías, propuestas de UX y pruebas) con paquete documental explícito; **no se presume capacidad de escribir en el repositorio**.
- **Cátedra:** revisa requisitos metodológicos, formalismos y alcance académico. Sus observaciones relevantes se documentan con fuente/fecha.

Flujo de delegación: `paquete de fuentes versionadas → encargo aislado a Gemini → revisión del responsable → auditoría cruzada ChatGPT → RD/CR si hay cambio → rama/PR → merge autorizado → actualización del tablero`. Evitar que dos agentes editen simultáneamente el mismo archivo maestro.

[Plan operativo Gemini](PLAN_DELEGACION_GEMINI_2026-10-26.md) y [plantilla para contratos](../07-contratos-operacion/PLANTILLA_CONTRATO_OPERACION_Y_CONTROL_2026-10-26.md).

## 8. Criterios generales de aceptación y definición de terminado

Para cada bloque mantener evidencia de **cinco controles**:
1. **Alcance:** CU/RF/RD identificados y aprobados; exclusiones explícitas.
2. **Artefacto:** archivo versionado, editable cuando se requiera, nombres/diagramas legibles y fuentes declaradas.
3. **Consistencia:** sin inventar datos o permisos, historial preservado, revisión contra CU y modelo de dominio.
4. **Pruebas reales:** si hay software, ejecutar CI y casos funcionales/negativos/seguridad/concurrencia apropiados; si solo hay diseño, no declarar software probado.
5. **Integración:** PR revisado, trazabilidad bidireccional y registro de qué cambió, qué no cambió y qué falta.

**Un bloque documental puede cerrarse sin software implementado** solo cuando el estado explicite esa limitación (precedente: F04).

## 9. Seguimiento vivo por bloque

### Tabla de control inicial (26/10/2026)

| Bloque | Estado | Evidencia principal | Próxima acción | Dependencia |
|---|---|---|---|---|
| B0 | En curso | PR #7, RD, contexto y repo | Revisar PR #7, importar DOCX, depurar RP | Acceso al Word fuente |
| B1 | En curso con Gemini | DSS/DSD en elaboración externa | Recibir diagramas y chat, revisar; luego contratos de operación | CU Fase 4 y dominio |
| B2 | Pendiente | Esquema SQL y contratos como insumo | Aprobar estrategia de repos y estructura técnica | B0 |
| B3 | Pendiente | S-04, F07/F09 | Descomponer servicios RBAC y casos de prueba | B2 |
| B4 | Pendiente | CU comerciales, RD-F01 | Crear primer recorrido end-to-end | B3 |
| B5 | Funcional cerrado; código pendiente | RD-F04-001…007, PR #5 | Implementar en etapa B5 | B3+B4 |
| B6 | Diseño parcial | MR-3/5 y CU de inventario | Servicios de costos/preparación/stock | B3+B4 |
| B7 | Diseño PRA-01 | `docs/02-procesos/PRA_01_...` | Resolver pendientes RP-012/013, implementar F05 | B6 |
| B8 | Diseño parcial | S-03, CU online/reembolsos | Construir, autenticar e integrar F06 | B3+B4 |
| B9 | Pendiente | CI MR-6 como referencia | Suite E2E y entrega académica | Incrementos entregados |

Estados permitidos: **PENDIENTE, EN_ANÁLISIS, EN-DISEÑO, EN-IMPLEMENTACIÓN, EN-PRUEBAS, CERRADO-FUNCIONAL, CERRADO-TÉCNICO, BLOQUEADO**, con evidencia y fecha del cambio. La presente tabla es un corte inicial, no una automatización del seguimiento.

### Ritmo propuesto
- Al terminar cada sesión significativa: acta corta, RD/RP/CR afectados, links a fuente/PR, riesgos y próximo paso.
- Por incremento de aplicación: PR + pruebas + actualización del bloque y matriz CU.
- Una revisión de plan por semana o al incorporar un hito; informes académicos según exigencias vigentes verificadas.
- No imponer fechas de entrega o duración sin disponibilidad real, aprobación del alcance y calendario de cátedra.

## 10. Próximas acciones en orden

1. Revisar [PR #7](https://github.com/leandrito369/ale-milanesas/pull/7) y evitar textos de estado contradictorios.
2. Importar el **DOCX Fase 4 original** con las 192 fichas; no sustituirlo por extractos históricos.
3. Terminar con Gemini los **DSS/DSD**; entregar fuentes editables + chat + matriz de operaciones y excepciones.
4. Auditar e integrar esos diagramas en un PR exclusivo y congelar su versión de referencia.
5. Encargar a Gemini **contratos de operación seleccionados** a partir del DSS/DSD revisado, según plantilla; QA y PR separados.
6. Ratificar o modificar este plan; decidir formalmente la separación de repositorios al abrir B2.
7. Preparar arquitectura de código y F07, sin mezclar esa aprobación con cambios físicos no autorizados.

**Esta planificación es propuesta; fusionarla no constituye autorización automática de crear otro repo, agregar nuevos estados/tablas, alterar casos de uso o desplegar software.**
