# ANEXO — Declaración original del responsable en la conversación

**Origen:** mensaje del usuario en esta conversación de ChatGPT, recibido el **2026-11-17T03:55:05Z** (17/11/2026 00:55:05, UTC−03:00).  
**Naturaleza:** transcripción textual del mensaje aportado como declaración de firma, no exportación forense ni firma digital certificada. El identificador interno del mensaje, su URL y una huella criptográfica de la conversación **no están disponibles**.  
**Responsable declarado por el emisor:** Machado Victor Leandro.  
**Propósito:** preservar junto a la constancia normalizada la declaración primaria; ninguna acción o ratificación adicional se deduce de esta transcripción.  
**Control:** documento propuesto en una PR DRAFT; todavía no publicado en gobierno/main.

---

Firmo esta acta como el responsable Machado Victor Leandro:

## 1. Evaluación del marco de gobierno y trazabilidad (OC-I3-09R)

- **Disciplina de puertas y repositorios:** Mantiene la separación estricta entre el repositorio de gobierno (`ale-milanesas`) y el de implementación (`ale-milanesas-app`), respetando `source-lock`, RBAC, proyecciones `BC-07` y el bloqueo documental `PRE-05` sobre la Demo.
- **Desacoplamiento contractual vs. físico:** Separa con rigor lo que debe fijarse como comportamiento observable (`G-CON`) de las decisiones de concurrencia, locks y cardinalidad (`G-ARQ Nivel 2` y `G-FIS`), evitando que los agentes de código improvisen contratos HTTP o contables al implementar `PR #47/#48`, `PR #91` o `PR #92`.
- **Pendientes documentales a controlar antes del cierre editorial:**
  - La **Resolución G-ARQ Nivel 1** figura como reportada sin respaldo documental; debe exigirse su incorporación con SHA verificable en `ale-milanesas` antes de aprobar decisiones de Nivel 2 basadas en ella.
  - El paquete editorial **`PR #65`** (`GC-10` y `PRE-05`) sigue abierto; aprobar esta preacta habilita la redacción de la resolución editorial `G-CON`, pero no autoriza fusionar `PR #65` hasta levantar `PRE-05`.

## 2. Evaluación técnica por artículo y propuesta de decisión

| **Artículo** | **Decisión propuesta** | **Fundamento técnico-contractual** | **Condición o salvedad para G-ARQ Nivel 2** |
| --- | --- | --- | --- |
| **ART-GCON-A** (Evidencia diagnóstica `D_e`) | **APROBAR** | La alternativa **A1** (persistencia *fuera y después* del `ROLLBACK` comercial) resuelve la corrección R1: evita perder el efectivo declarado por el repartidor sin crear estados comerciales intermedios ni consumir la `claveIdempotencia` del comando. Mantiene intacta la firma G0 `BigDecimal[0..1]` (`NO_DECLARADO` vs. `0.00`). | Definir en Nivel 2 la política de resiliencia ante fallo de infraestructura en la escritura post-rollback y el plazo de retención/purga. |
| **ART-GCON-B** (Respuesta ante contención `IMP-C`) | **APROBAR** | Separa correctamente insuficiencia de evidencia (`422` / `COBERTURA_NO_ACREDITADA`), conflicto de payload idempotente (`409`, `RCG-05`) y error técnico transaccional (`40P01` con rollback íntegro). Bloquea el atajo de confirmar entregas cuando $V_e^0=0$ sin acreditar reservas y aplicación FIFO. | Confirmar compatibilidad del mapeo HTTP `422` con la tabla de errores de `E-02/E-07` y validar que el diagnóstico ADMIN no filtre datos de terceros (`BC-07`). |
| **ART-GCON-C1** (Identidad mínima cierre `UC-29`) | **APROBAR** | Fija unicidad por cierre mediante `claveIdempotenciaCierre: UUID` + huella canónica versionada. Resuelve la concurrencia entre administradores: solo el primero confirma; un replay idéntico devuelve el recibo histórico, un payload distinto devuelve `409` y una clave nueva sobre recorrido cerrado devuelve `RECORRIDO_YA_CERRADO` sin exponer el recibo previo. | Articular la huella versionada con las identidades por etapa (`ART-GCON-C2`) y la cardinalidad `Cobro–Aplicación` en Nivel 2. |
| **ART-GCON-C2** (Protocolo `T1/T2`) | **NO VOTAR (DIFERIDO)** | La elección entre cierre atómico agregado (`T1`) y aplicaciones con `COMMIT` individual (`T2`) depende de locks, generadores globales y cardinalidad `Cobro–Aplicación`. Forzarlo en `G-CON` violaría la separación de puertas. | Pasa como entrada obligatoria a `G-ARQ Nivel 2`. |
| **ART-GCON-D** (Anulación `UC-29`) | **APROBAR** | Evita re-votar la necesidad de adenda ya resuelta en `RCG-05` y fija la firma `anularCobroManual(idCobro, motivoAnulacion, claveIdempotenciaAnulacion)` con retorno obligatorio de IDs de ambos contraasientos (`idMovimientoCuenta`, `idMovimientoCaja`), `saldoConfirmado` y `categoriaComercial`. Preserva `D7-A` y exclusividad `ADMINISTRADOR`. | Explicitar en la integración editorial de `E-05` una regla determinista de normalización de `motivoAnulacion` para evitar falsos `409` en reintentos. |

## 3. Hoja de decisión lista para volcar al acta

Para dejar asentada la resolución parcial del responsable en la **Sección 8** de `PREACTA-GCON-R08.6`:

| **Artículo** | **Decide ahora** | **APROBAR** | **DEVOLVER** | **RECHAZAR** | **Observaciones sugeridas para el acta** |
| --- | --- | --- | --- | --- | --- |
| **ART-GCON-A** | Sí | **[X]** | [ ] | [ ] | Aprobado bajo alternativa A1. Registrar en G-ARQ Nivel 2 la política ante fallo de escritura post-rollback y retención de constancias. |
| **ART-GCON-B** | Sí | **[X]** | [ ] | [ ] | Aprobado bajo alternativa B1. Alinear código HTTP `422` y diagnóstico ADMIN con la tabla editorial de `E-02/E-07`. |
| **ART-GCON-C1** | Sí | **[X]** | [ ] | [ ] | Aprobado bajo alternativa C1-a. Queda sujeto a articulación con `ART-GCON-C2` en Nivel 2. |
| **ART-GCON-C2** | **No — diferido** | — | — | — | Diferido formalmente a `G-ARQ Nivel 2` junto con cardinalidad `Cobro–Aplicación`, orden de locks y generadores. |
| **ART-GCON-D** | Sí | **[X]** | [ ] | [ ] | Aprobado bajo alternativa D1. Explicitar regla de normalización de `motivoAnulacion` al integrar `E-05` en `PR #65` (sujeto a `GC-10` y `PRE-05`). |
