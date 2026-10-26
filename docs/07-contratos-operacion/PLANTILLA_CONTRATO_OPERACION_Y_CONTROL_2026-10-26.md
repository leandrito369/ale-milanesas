# Contratos de Operación — Plantilla y criterios de selección

**Fecha:** 26/10/2026 · **Estado:** PLANTILLA METODOLÓGICA PROPUESTA; no contiene contratos aprobados de CU particulares.  
**Fuente metodológica inmediata:** descripción, secciones y criterio de selección suministrados por el responsable del proyecto en la conversación. Comparar con la guía y convenciones específicas de la cátedra cuando se reciban.

## 1. Definición y alcance

Un **contrato de operación** describe **qué se propone lograr una operación** desde el punto de vista del estado del sistema o de los resultados observables, **no cómo se conseguirá**. Es declarativo, compatible con el lenguaje del dominio y coherente con las operaciones halladas en los **DSS**.

**Criterio de inclusión expresamente indicado por el usuario:** producir contratos **únicamente** para operaciones que:
- **modifican el estado** del sistema, expresado en postcondiciones; y/o
- **producen una salida devolviendo instancias registradas** en el sistema.

Una operación de búsqueda que devuelve instancias de Cliente/Pedido existentes puede justificar contrato aunque no modifique datos. Una simple navegación de pantalla o validación privada sin cambio ni retorno de instancias **no lo exige** por este criterio.

**No se exige automáticamente un contrato por CU:** la correspondencia correcta es `UC ↔ operación(s) del DSS ↔ contrato(s) seleccionado(s)`. Una operación puede aparecer en varios flujos; los contratos deben evitar copias inconsistentes.

## 2. Plantilla rellenable, un documento por operación seleccionada

### Identificación
- **ID del contrato:** `CO-<secuencia>` (código documental candidato, no un nuevo CU).
- **Estado:** `BORRADOR / EN_REVISIÓN / APROBADO_DOCUMENTAL`.
- **Versión / fecha:** `...`.
- **CU y paso(s):** `UC-XX, paso(s) exacto(s) del CU vigente`.
- **Operación de DSS de origen:** `operacion(parametros)`, nombre exacto y versión del DSS.
- **DSD de referencia (si existe):** `...`.
- **Fuente RD/RF pertinente:** `...`.

### Contrato de Operación

| Sección | Contenido |
|---|---|
| **Nombre** | `<operación>(<parámetros>)` según firma DSS, sin inventar parámetros |
| **Responsabilidades** | Finalidad funcional de negocio expresada informalmente |
| **Tipo** | Tipo/concepto/clase/interfaz correspondiente al nivel del modelado; p. ej., `Sistema` si aplica al contrato de una operación del sistema |
| **Referencias cruzadas** | CU exacto, pasos, DSS/DSD, RF, RD |
| **Notas** | Aclaraciones semánticas y restricciones de negocio, no algoritmo |
| **Excepciones** | Condición excepcional y resultado permitido/rechazo previsto por el CU |
| **Salida** | Instancias registradas que se devuelven, datos observables y/o mensajes de resultado/excepción |
| **Precondiciones** | Hechos o supuestos del estado **antes** de ejecutar |
| **Postcondiciones** | Hechos observables del estado **después** de ejecutar satisfactoriamente; para consultas, resultados retornados cuando corresponda |

#### Postcondiciones (formato recomendado)

- **Instancias creadas/eliminadas lógicamente:** «Se crea una instancia de ...», «... queda en estado ...» (no interpretar eliminación física sin autorización).
- **Atributos modificados:** «El atributo ... de ... queda con el valor ...», citando fuente de la regla si corresponde.
- **Asociaciones establecidas/retiradas:** «La instancia ... queda asociada a ...».
- **Hechos financieros/históricos:** «Se registra un movimiento ...» solo cuando está aprobado; no confundir evidencia provisional con asiento contable.
- **Resultados de consulta:** «Se devuelve la colección de instancias registradas ... que cumplen ...»; sin afirmar persistencia modificada.
- **Ramas excepcionales:** «No se modifica ...», «No se crea ...» **solo si** esa invariante se desprende de la especificación; identificar resultados de error.

Evitar procedimientos como «el controlador llama al repositorio», «SQL INSERT/UPDATE», «se calcula mediante este bucle», «se abre una transacción» en el **contrato**. Pertenecen al DSD, diseño técnico o pruebas, no al comportamiento declarativo que debe expresar el contrato.

## 3. Filtro para elegir qué operaciones tienen contrato

| Operación candidata | ¿Contrato? | Motivo |
|---|---|---|
| Registrar un Pedido válido | **Sí** | Cambia estado: crea Pedido, asociaciones e instantáneas |
| Registrar una Entrega válida | **Sí** | Cambia estado: Entrega y estado del Pedido conforme a sus CU |
| Declarar efectivo recibido en UC-05 | **Sí** | Registra declaración cuando el servidor la valida; el efecto provisional está separado de COBRO |
| Buscar Clientes registrados y devolver resultados | **Sí** | Retorna instancias existentes, aunque no cambia persistencia |
| Consultar lista estática de ayuda sin instancias registradas | **No, por criterio vigente** | No cambia estado ni retorna instancias persistidas |
| Navegar entre pantallas / cerrar modal | **No, por criterio vigente** | Es acción de interfaz, no operación de negocio con postcondición o retorno relevante |
| Método privado que valida parámetro de una clase del DSD | **No por sí mismo** | No necesariamente es operación de sistema en DSS |

**Los nombres anteriores son ilustrativos**. Los contratos reales conservarán firmas y nombres que figuren en los DSS aprobados; no deben crearse operaciones nuevas a partir de la tabla.

## 4. Dos mini-ejemplos didácticos (NO aprobados como contratos de CU)

### Ejemplo A — Consulta que retorna instancias

**Nombre:** `buscarClientes(criterios)` *(firma ilustrativa; comprobar DSS UC-33 antes de usar)*  
**Responsabilidades:** recuperar Clientes registrados que satisfacen criterios permitidos.  
**Tipo:** Sistema.  
**Referencias cruzadas:** UC-33 (ilustrativo; verificar paso exacto).  
**Notas:** respetar permisos y filtros del CU.  
**Excepciones:** criterios inválidos o ausencia de resultados según reglas aprobadas.  
**Salida:** colección de instancias de Clientes registradas que cumplen criterios, o mensaje de situación cuando corresponda.  
**Precondiciones:** usuario autorizado para la búsqueda según matriz vigente.  
**Postcondiciones:** se retorna el conjunto de instancias correspondientes; no se modifica el estado persistente del Cliente ni su Cuenta Corriente.

### Ejemplo B — Declaración de efectivo en UC-05

**Nombre:** `declararEfectivoRecibido(datos)` *(nombre/parámetros **ilustrativos**, no sustituyen DSS real)*  
**Responsabilidades:** registrar la declaración de efectivo que el Repartidor recibió al entregar.  
**Tipo:** Sistema.  
**Referencias cruzadas:** UC-05; RD-F04-003 y RD-F04-004; verificar pasos DSS exactos.  
**Notas:** captura puede ser offline; la mera captura no valida ni confirma un Cobro.  
**Excepciones:** identidad no autorizada, asignación inválida, importe inválido, operación duplicada/conflictiva (resultado concreto según política de sincronización que sea aprobada).  
**Salida:** confirmación de captura local o resultado de aceptación/conflicto del servidor, distinguiéndolos; firma real pendiente.  
**Precondiciones:** Pedido/Entrega identificables y Repartidor que actúa dentro de UC-05, según reglas vigentes.  
**Postcondiciones de aceptación en servidor:** una declaración válida queda registrada una sola vez como pago en tránsito independiente de COBRO; su importe afecta **solo la deuda exigible provisional** del Cliente. No se crea Cobro confirmado, ni movimiento de Caja o Cuenta Corriente definitivo.  
**Postcondiciones de mera captura offline:** la información queda localmente pendiente de sincronización; no modifica los saldos del servidor.  
**Estado del ejemplo:** **DIDÁCTICO**, confirmar nombre, firma y paso exacto con DSS/DSD antes de convertirlo en contrato definitivo.

## 5. Hoja de control para cada operación de un DSS

| Campo | Qué registrar |
|---|---|
| CU/paso | Código y paso exactos de la ficha Fase 4 |
| DSS | Archivo, versión, mensaje de operación y parámetros |
| Cambia estado | Sí/No + entidad/resultado esperado |
| Retorna instancias existentes | Sí/No + tipo de instancia |
| ¿Se redacta contrato? | Sí/No según los dos criterios anteriores |
| Razón de exclusión | Si es No, breve y verificable |
| Contrato asociado | ID/archivo si es Sí |
| DSD asociado | Mensaje/colaboración (solo para referencia) |
| Fuentes | RF/RD/RP y modelo de dominio |
| Duda | `[A CONFIRMAR]` si falta regla o autorización |

## 6. Revisión de calidad obligatoria

1. Los nombres, parámetros y retornos están anclados en operaciones DSS reales.
2. El contrato no impone una secuencia técnica ni un algoritmo.
3. Cada postcondición tiene un hecho verificable del dominio y una fuente.
4. Se distinguieron precondiciones, condiciones de excepción, salidas y postcondiciones de éxito.
5. No se concedió permiso directo UC-29 al Repartidor. Su declaración en UC-05 no es un Cobro definitivo.
6. En F04, los pagos en tránsito reducen exigibilidad provisional solo tras validación central; faltantes permanecen pendientes de conciliación, sin diseñar responsabilidades.
7. En F01, `COBRO.estadoCobro` mantiene exclusivamente `CONFIRMADO`/`ANULADO`.
8. Se respeta categoría `EN_MORA` y ajuste vigente hasta reevaluación formal, sin recalcular precios históricos.
9. Se documentan excepciones por operaciones no aplicadas sin inventar estados no aprobados.
10. Existen archivos editables, matriz de operaciones, referencias de fuente y revisión del usuario.

## 7. Entrega de Gemini para integración

Por lote: `00_indice_operaciones.md`, `CO-xxx_...md`, `matriz_cu_dss_dsd_contratos.md`, `incidencias_y_preguntas.md`, fuentes DSS/DSD originales y conversación de trabajo cuando sea necesaria.

Las herramientas o nombres de archivo son **sugerencias técnicas**. Primero validar la convención documental y la consigna con la cátedra; la entrega final debe preservar el formato académico que esta exija.

**Ningún contrato de este documento es un contrato funcional definitivo por sí solo.**
