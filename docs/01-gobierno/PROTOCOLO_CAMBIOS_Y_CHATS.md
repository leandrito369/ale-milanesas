# Protocolo recomendado de documentación de cambios y conversaciones

**Corte de referencia:** 25/10/2026. **Carácter:** propuesta metodológica, no regla de negocio.

**Método propuesto:** repositorio de documentación versionado con **Git** (o equivalente con historial), una línea base por versión, un registro inmutable de decisiones (RD / ADR), registro de pendientes (RP / issues), solicitudes de cambio (CR), bitácoras de sesiones de chat, matriz de trazabilidad y manifiesto de archivos con SHA-256. Se añade el chat completo como evidencia archivada, pero **nunca como única fuente normativa**.

## 10.1 Estructura sugerida del repositorio

```text
ale-milanesas/
  README.md                          # estado actual, enlace a índice, responsable
  CONTEXTO_ACTUAL.md                 # versión breve de este documento
  docs/
    00_gobierno/                    # convenciones, precedencia y metodología
    01_requisitos/                  # RF, RNF, IRQ, objetivos
    02_dominio/                     # entidades conceptuales y reglas
    03_casos_uso/                   # UC-01 a UC-64, 3 niveles
    04_procesos/                    # PRA-01
    05_modelo_relacional/           # diccionario, SQL, migraciones, pruebas
    06_arquitectura/                # diseño técnico y contratos
    07_pruebas/                     # evidencia ejecutada, criterios de aceptación
    08_diagramas/                   # originales y gráficos versionados
  gobierno/
    RD_decisiones.csv                # registro único de decisiones
    RP_pendientes.csv                # pendientes / bloqueos
    CR_cambios.csv                   # solicitud, impacto, autor, revisión
    MATRIZ_trazabilidad.csv          # requisito→CU→objeto→prueba
    CHANGELOG.md                     # cambio visible por versión
    MANIFIESTO_archivos.csv          # ruta, versión, hash, autoridad, estado
  sesiones/
    2026-10-25_chat_X.md             # acta sintética y enlace a transcripción
    transcripciones/                # exportaciones íntegras si se conservan
  entregas/
    baseline_2026-10-25/            # snapshot inmutable
    propuestas/                     # versiones no aprobadas
```

## 10.2 Qué se registra luego de CADA conversación

1. **Datos de sesión:** ID, fecha/hora, chat origen, objetivo, versiones consultadas, responsable, nueva información proporcionada.
2. **Hechos aceptados:** transcribir regla acordada y su justificación; separar `APROBADA_USUARIO`, `PROPUESTA_IA`, `DECISION_TECNICA_DELEGADA`, `PENDIENTE` y `DESCARTADA`.
3. **Diferencias concretas:** archivo de origen, ruta/ID, antes→después, archivos generados, tablas/columnas/CU afectados; no basta «actualizado».
4. **Pruebas y limitaciones:** qué se validó, herramienta/entorno, salida reproducible, qué **NO** se ejecutó.
5. **Pendientes y dueño:** cuestión, prioridad, dependencia, actor que decide, fecha de revisión o evento que la desbloquea.
6. **Propagación:** marcar todos los artefactos tocados o pendientes de sincronizar: RD, RP, PRA, CU, RBAC, UML, esquema, diccionario, DDL y tests.
7. **Cierre y continuidad:** resumen de máximo una página, manifest de archivos nuevos y recomendación para el próximo chat.

Si la plataforma permite exportar la conversación íntegra, conservarla en `sesiones/transcripciones/` con su fecha y origen; **este documento es un resumen reconstruido, no una exportación literal del chat**.

La IA puede generar el borrador del acta, pero **solo la aceptación explícita del usuario convierte propuestas de negocio en reglas aprobadas**. Las decisiones técnicas delegadas se pueden aplicar dentro de los límites de la delegación, manteniendo prueba y trazabilidad.

## 10.3 Ciclo de control de cambios (CR → RD → artefactos → QA)

| Paso | Acción | Evidencia mínima |
|---|---|---|
| 1. Registrar | Abrir `CR-YYYY-NNN` con necesidad, motivación, artefactos y riesgo | CR + versiones afectadas |
| 2. Evaluar | Analizar impacto RF/CU/UML/DB/RBAC/QA; distinguir alternativa no aprobada | Matriz de impacto |
| 3. Decidir | Crear `RD-YYYY-NNN` si hay regla nueva; o citar RD existente si es mera corrección técnica | Acta de decisión y quién autorizó |
| 4. Implementar | Trabajar en rama/copia; producir diff legible; no sobreescribir baseline | Commit / parche / nuevo archivo |
| 5. Verificar | Pruebas formales, revisión semántica y render de artefactos; adjuntar resultados reales | QA ejecutado / pendientes explícitos |
| 6. Propagar | Actualizar RD, RP, catálogo CU, modelo, migraciones y trazabilidad afectados | Lista de sincronización con estados |
| 7. Publicar | Versionar (`vX.Y.Z`), generar manifiesto y hash, crear snapshot nuevo | Changelog y release |

**Versionado práctico:** `vMAJOR.MINOR.PATCH`; `MAJOR` cambio incompatible de reglas/estructura, `MINOR` nuevo UC o funcionalidad aprobada, `PATCH` corrección editorial/técnica sin cambiar comportamiento. Ej.: `MR-3 v1.0.0` propuesto, `MR-5 v1.1.0` corregido; nunca etiquetar `CERTIFICADO` sin evidencias de PostgreSQL.

## 10.4 Campos obligatorios de cada registro

**RD (decisión):** `decision_id`, `fecha`, `estado`, `autoridad`, `regla_aprobada`, `alternativas_descartadas`, `justificacion`, `artefactos_afectados`, `fuente_chat`, `fecha_propagacion`, `pruebas`. Mantener históricos; para revertir agregar una nueva RD con `sustituye_id`, no borrar la anterior.

**RP (pendiente):** `pendiente_id`, `tipo`, `estado`, `pregunta_exacta`, `contexto`, `riesgo`, `responsable`, `desbloqueo`, `fuentes`, `resuelto_por_RD`, `estado_implantacion`. Resolver RP requiere enlace a RD y, si es físico, evidencia de implementación.

**CR (cambio):** `cambio_id`, `fecha`, `area`, `propuesta`, `origen`, `aprobacion`, `antes`, `despues`, `artefacto`, `version_origen`, `version_destino`, `prueba`, `estado`, `owner`.

**Bitácora de chat:** `sesion_id`, `fecha_hora`, `objetivo`, `archivos_entrada`, `decisiones_usuario`, `decisiones_ia_delegadas`, `propuestas_rechazadas`, `archivos_salida`, `qa_realizado`, `pendientes`, `prompt_de_reanudacion`.

## 10.5 Regla para trabajo simultáneo con dos o más IA

- Cada chat recibe el mismo **paquete de corte**, más un **encargo aislado**; no confiar en memoria compartida entre chats.
- Un chat es *propietario* de cada archivo base: por ejemplo MR-5 de DDL, otro de prototipos, otro de trazabilidad. Los demás proponen parches.
- Cada intervención concluye con **entregables + diff + acta de sesión + inventario de decisiones + lista de artefactos impactados**.
- Un único integrador (el usuario u otro chat rector) revisa los parches por conflicto y publica la versión canónica.
- Si dos equipos necesitan modificar el mismo archivo, serializar la integración: primero aceptar un parche, después rebasar y revisar el siguiente.
- Nunca fusionar con la regla «el archivo más nuevo gana»; comparar IDs RD/CR, alcance, versiones y pruebas.
- Cada chat debe declarar explícitamente: «Fuentes inspeccionadas», «Qué cambié», «Qué no cambié», «Qué no pude validar».

