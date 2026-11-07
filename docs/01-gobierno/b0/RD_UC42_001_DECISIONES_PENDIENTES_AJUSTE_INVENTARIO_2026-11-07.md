# RD-UC42-001 — Decisiones pendientes de UC-42 (Ajuste de Inventario)

**Fecha:** 07/11/2026.
**Estado:** RATIFICADA PARCIALMENTE: 4/5 gaps cerrados (G1, G2, G3 y G5). G4, idempotencia, permanece PENDIENTE explícito.
**Autoridad:** Victor Leandro Machado (`leandrito369`), Responsable del proyecto.
**CU y operación:** UC-42 `registrarAjusteInventario`, corte INSUMO.
**Alcance:** decisión documental; no implementa servicio, API, UI, SQL ni migraciones.

## Predecesoras y fuentes inspeccionadas

- RD-MR-PARTIDAS-001, merge `cd603d25addb4312d9bee62ec03514760f7e2894`: D1-D3 ya aplican a UC-42; esta RD no las reautoriza.
- RD-UC08-001, merge `ee555ba9d020aaf66f1f95e1e4e73d99a9235448`: UC-08 INSUMO. No convierte sus campos de recepción en campos de UC-42.
- RD-UC08-002, PR [#40](https://github.com/leandrito369/ale-milanesas/pull/40), merge `ad8d39e6351ae71e274747fbf5d8e3c979db2564`: ya integrada al comenzar este trabajo; no se modifica ni se extiende a UC-42 REVENTA.
- [RD-RP022-001](../RD_RP022_001_COSTEO_CONVERSIONES_REDONDEOS_2026-10-27.md): costeo, conversiones y redondeos.
- [RD-RP016-001](../RD_RP016_001_ALTA_INSUMO_SIN_STOCK_COSTO_2026-10-27.md): alta del maestro sin stock físico ni costo ficticio.
- [Contrato UC42 consolidado](../../08-diagramas/consolidacion-b0/CONTRATO_UC42_REV01_B0_ACTUALIZADO.md), estado «PROPUESTA», y [adenda H01/H02](../../08-diagramas/revision/REV01_ADENDA_H01_H02_UC42_2026-10-28.md).
- Ficha Real/Extendida UC-42 de `docs/04-casos-uso/CASOS_DE_USO_64_TRES_NIVELES.docx`, inspeccionada en este trabajo. Confirma selección del elemento, tipo, cantidad, motivo, unidad mostrada, validación de disponibilidad, costo válido y evaluación de reposición; no contiene una firma técnica literal de método ni una clave de idempotencia.
- [Adenda MR-6, UC-42](../../04-casos-uso/ADENDA_MR6_IMPACTO_8_UC_2026-11-07.md#uc-42): partidas nuevas para ingresos y partidas seleccionadas para descuentos.
- [PRA-01](../../02-procesos/PRA_01_REPOSICION_AUTOMATICA_v1.1_2026-10-25.md): PRA-R02, PRA-R03, PRA-R10 y PRA-R12.
- Implementación leída, sin modificar, en `ale-milanesas-app@d8a88f2f77f2cb5f7355aefba23186493b5afeba`: V1/V3 y `RegistrarIngresoStockInsumoService.cerrarEpisodios()` (PR #68).

## Registro formal §10.4

| Campo | Valor |
|---|---|
| `decision_id` | `RD-UC42-001` |
| `fecha` | `2026-11-07` |
| `estado` | `RATIFICADA PARCIALMENTE: G1/G2/G3/G5 CERRADOS; G4 PENDIENTE` |
| `autoridad` | Victor Leandro Machado (`leandrito369`) |
| `regla_aprobada` | Firma y costo de G1, desglose por partidas de G2, rutas de costo de G3 y unidad base de G5 para UC-42 INSUMO. En G4 se ratifican mitigaciones y coordinación PRA-01; no se declara resuelta la idempotencia. |
| `alternativas_descartadas` | Ver cada gap; en particular, deduplicar por motivo/tipo/timestamp o atribuir idempotencia a un lock. |
| `justificacion` | Cerrar los pendientes respaldados por la ratificación del Responsable, alinear firma/postcondiciones MR-6/pruebas y explicitar el riesgo residual de reintentos, sin inventar una clave ni un nuevo esquema de deduplicación. |
| `artefactos_afectados` | Solo este documento. Propagación futura a implementación UC-42 en la app. G0/MR-5/F01/MR-6 y contratos existentes intactos. |
| `fuente_chat` | Auditoría Codex y encargo del 07/11/2026. Respuesta expresa del Responsable: Opción 2, mantener firma restringida, cerrar 4/5 gaps y reservar RD-UC42-002 para idempotencia. Resumen, no transcripción íntegra. |
| `fecha_propagacion` | 07/11/2026, registro documental; implementación y sincronizaciones futuras pendientes. |
| `pruebas` | Comprobaciones documentales B0; sus resultados se registran en el PR. Pruebas B3/HTTP/UI de UC-42 pendientes de implementación, no ejecutadas por esta RD. |

## Resultado de los cinco gaps

| Gap | Resultado |
|---|---|
| G1 — Firma y `costoValuacion` | CERRADO para el corte INSUMO definido aquí. |
| G2 — Partidas, cantidades y apertura | CERRADO mediante extensión MR-6; no se añade identidad de operación. |
| G3 — Rutas de costo | CERRADO para INSUMO; REVENTA fuera de alcance. |
| G4 — Idempotencia | PENDIENTE. Lock, restricciones, confirmación UI y auditoría son mitigaciones, no deduplicación. |
| G5 — Unidad base | CERRADO; sin conversiones ni campos de recepción trasladados a UC-42. |

## G1 — Firma y semántica de costoValuacion: CERRADO

El contrato anterior declara literalmente:

```text
registrarAjusteInventario(tipoElemento: String, idElemento: Long,
    tipoMovimiento: String, cantidad: Decimal, motivo: String,
    costoValuacion: Decimal[0..1])
```

Se conserva esa firma base. Para este corte, `tipoElemento=INSUMO` y los tipos admitidos son `SALDO_INICIAL`, `AJUSTE_POSITIVO` y `AJUSTE_NEGATIVO`. La única extensión de datos de este corte es el desglose por partidas de G2, autorizado por MR-6. No se agrega `idOperacion`, clave de reintento ni parámetros de recepción de compra. El contrato G0 no se reescribe.

El cotejo con la ficha Real confirma el comportamiento funcional; no se atribuye al Word una firma Java que no contiene. La presente decisión complementa la firma de diseño y sus postcondiciones en el alcance expresamente ratificado.

- `cantidad`: estrictamente positiva, expresada en unidad base; no representa un stock final al que sobrescribir el saldo existente.
- `motivo`: obligatorio; conserva la justificación humana del ajuste y no actúa como identificador de operación.
- `SALDO_INICIAL`: `costoValuacion` obligatorio y mayor que cero; establece el costo unitario inicial con `fuenteCosto='SALDO_INICIAL'` antes de crear el movimiento que lo referencia.
- `AJUSTE_POSITIVO`: costo opcional. Informado y positivo, origina una nueva vigencia de costo; omitido, exige un costo histórico vigente válido del mismo insumo.
- `AJUSTE_NEGATIVO`: si se informa costo, se ignora a efectos de valoración; usa el costo histórico aplicable y no modifica costos históricos. No interpretar el costo recibido como una revaluación.

`SALDO_INICIAL` exige además las restricciones ya existentes de V1/F03: ausencia de movimientos previos, `numeroSecuenciaInsumo=1`, `stockResultante=cantidad`, `origen='APERTURA_INVENTARIO'`, preparación y recepción NULL. El índice `uq_movimiento_insumo_saldo_inicial` limita a un saldo inicial por insumo. No es un efecto automático de UC-50.

Para los ajustes ordinarios, el origen documenta que se trata de un ajuste, nunca de una compra ficticia. La codificación técnica del literal de origen debe conservar esa semántica y documentarse en el PR de implementación; no se introduce una nueva enumeración física por esta RD.

**Alternativas descartadas:** trasladar el alta física a UC-50; admitir REVENTA en este corte; asignar costo cero ficticio; modificar retroactivamente movimientos o costos de consumos previos.

## G2 — Partidas, cantidades y apertura: CERRADO

Extensión de la firma base, exclusivamente por MR-6:

```text
List<PartidaAjuste> partidas
```

La lista es obligatoria y no vacía para los tres tipos; no es opcional en este corte. Su ausencia se rechaza como solicitud inválida (400 en la futura API).

Representación de diseño de sus datos, no código de aplicación incorporado:

```text
PartidaAjuste(
    idPartidaInsumo: Long[0..1],
    cantidad: Decimal,
    codigoLote: String[0..1],
    fechaVencimiento: Date[0..1],
    marcarApertura: Boolean[0..1]
)
```

`idPartidaInsumo` identifica la existencia física ya definida por MR-6; es necesario porque el lote no identifica unívocamente un envase. Dos partidas pueden compartir código de lote.

- En `SALDO_INICIAL` y `AJUSTE_POSITIVO`, se crean N partidas nuevas; el servidor asigna su identidad. Los datos opcionales de lote/vencimiento corresponden a las partidas nuevas y `idRecepcionCompra=NULL`; no se simula una recepción de compra.
- En `AJUSTE_NEGATIVO`, se requiere la identidad de cada partida existente seleccionada, perteneciente al insumo ajustado. El identificador no se sustituye por una búsqueda ambigua por lote. Los datos opcionales no habilitan reescribir lote/vencimiento de una partida existente mediante un descuento.
- Cada cantidad es positiva y `SUM(partida.cantidad)=cantidad` de la operación. La discrepancia se rechaza sin efectos (400 en la futura API).
- Un descuento no puede superar la disponibilidad de las partidas seleccionadas ni producir stock físico negativo. Puede seleccionar partidas vencidas para descarte, como ya autoriza D3.
- `marcarApertura` permite la apertura explícita en un descuento/merma parcial de un envase cerrado; omitirlo no inventa una apertura. No habilita el consumo productivo de partidas vencidas.
- Cada movimiento se vincula a sus detalles con el mismo insumo y cantidades aplicadas, conforme a D2 y a las FKs compuestas.

El saldo final de una partida nueva debe ser su cantidad inicial. El trigger de V3 acredita los ingresos al insertar los detalles: el diseño futuro debe evitar el doble crédito (inicializar disponible en cero antes del detalle, sin UPDATE manual adicional). Para descuentos, el mismo trigger reduce disponible. Se preserva la conciliación entre stock físico y saldos de partidas.

**Alternativas descartadas:** omitir detalles; seleccionar envases solo por `codigoLote`; admitir una suma distinta; sumar dos veces el ingreso; imponer FEFO de UC-28 como regla nueva de selección de ajustes negativos.

## G3 — Rutas de costo: CERRADO para INSUMO

| Movimiento / entrada | Decisión |
|---|---|
| `SALDO_INICIAL`, costo informado y positivo | Crear costo histórico con fuente SALDO_INICIAL, mismo insumo y sin recepción, antes del movimiento. |
| `SALDO_INICIAL`, costo omitido | Rechazar 400 `COSTO_VALUACION_REQUERIDO`, aunque exista un registro de costo previo. Esta es la restricción del corte ratificada por el Responsable. |
| `SALDO_INICIAL`, costo no positivo | Rechazar sin efectos; no sustituirlo por cero ni por un valor supuesto. |
| `AJUSTE_POSITIVO`, costo informado y positivo | Cerrar la vigencia anterior cuando exista y crear una nueva, trazable al ajuste, antes del movimiento. No alterar valores de movimientos anteriores. |
| `AJUSTE_POSITIVO`, costo omitido | Referenciar la vigencia actual válida del mismo insumo. Si no existe, rechazar hasta disponer de respaldo de costo; no crear una FK ficticia. |
| `AJUSTE_NEGATIVO` | Usar el costo histórico aplicable del mismo insumo; no crear ni actualizar costos a partir del costo recibido. Sin respaldo válido, rechazar. |

La clave `vigenteDesdeCosto` debe coincidir exactamente con la vigencia referenciada. Las modificaciones del costo, movimiento, detalles y stock deben ser atómicas; un rechazo revierte todos sus efectos.

La regla 11 de RD-RP022-001, que trata la valoración extraordinaria de REVENTA sin costo válido, no se usa como justificación de una regla de INSUMO ni se presenta como prohibición de un mecanismo ya autorizado. UC-42 REVENTA y sus detalles de valoración quedan fuera de esta RD y deberán especificarse en su corte posterior. No se reautoriza aquí la valoración extraordinaria ni se materializa costo por partida.

**Alternativas descartadas:** costo inventado/cero, costo nuevo después del movimiento, reutilizar un costo de otro insumo o revaluar retroactivamente la historia.

## G4 — Idempotencia PENDIENTE y coordinación PRA-01

### Decisión expresa del Responsable

Se adopta la Opción 2: mantener la firma restringida y dejar la idempotencia como pendiente explícito para **RD-UC42-002**, en un ciclo independiente. Esta RD no declara cerrados los cinco gaps.

`pg_advisory_xact_lock(idInsumo)` serializa operaciones simultáneas y protege consistencia; **no identifica una operación ni deduplica reintentos**. Motivo, tipo y timestamp tampoco son una clave estable: pueden repetirse en operaciones legítimas o cambiar al reenviar la misma solicitud. No colapsar ajustes por esa combinación ni declarar ejecución «exactamente una vez».

### Riesgo residual y mitigaciones del MVP

Un double-submit/reintento de `AJUSTE_POSITIVO` puede acreditar stock dos veces; uno de `AJUSTE_NEGATIVO` puede descontarlo dos veces si aún existe disponibilidad. Un lock no elimina ese riesgo. El CHECK de stock no negativo limita el saldo, pero tampoco demuestra idempotencia.

Mitigaciones ratificadas, sin promesa de deduplicación general:

1. Restricción única parcial y validaciones F03 para `SALDO_INICIAL`. Un duplicado se rechaza: en la futura API debe devolver **409**, no 200 silencioso ni confirmar un segundo ingreso.
2. Confirmación explícita en UI y prevención de envíos simultáneos desde esa UI. No constituyen garantía frente a reintentos de red, otros clientes o accesos directos; no reintentar automáticamente una escritura de resultado incierto.
3. Audit trail con motivo, fecha, usuario, movimiento, partidas/detalles y stock resultante, para detectar y conciliar efectos. Corregir mediante nuevos movimientos justificados, sin borrar historia.
4. Lock por insumo y transacción atómica para consistencia concurrente, tal como ya establece MR-6.

PRA-R12 continúa siendo el objetivo normativo; el MVP tiene esta limitación expresa. No se declara cumplida toda PRA-01 ni se certifica operación productiva. La incertidumbre de resultado tras una desconexión no se resuelve generando otra solicitud indistinguible.

### Coordinación PRA-01 ratificada; no equivale a cierre de G4

- Reutilizar la lógica de cierre existente de UC-08, extrayéndola en el futuro a un servicio compartido `abastecimiento/EpisodioFaltanteService`, sin duplicar reglas. Esta RD no crea ni refactoriza código.
- Tras `SALDO_INICIAL`/`AJUSTE_POSITIVO`, reevaluar cierre: requiere stock físico mayor o igual al umbral **y** ausencia de solicitudes en curso y órdenes pendientes. Alcanzar el umbral, por sí solo, no permite cerrar.
- Tras `AJUSTE_NEGATIVO`, reevaluar el faltante. Aplicar PRA-R02: abrir o reutilizar episodio, máximo uno abierto por insumo. PRA-R03 limita la primera ronda automática al flanco descendente válido; no implica crear otro episodio en cada ajuste ni comprar automáticamente.
- La emisión de ronda requiere además las condiciones de PRA-01 (automatización habilitada, invitables, plazo válido y demás restricciones). Orden de Compra siempre requiere decisión administrativa.
- Evaluar `stockActual` físico; trasladar el disparador a `stockUtilizable` requeriría la RD separada ya prevista por D3.

### Próximo ciclo

RD-UC42-002 deberá decidir la identidad estable de operación, alcance y persistencia de deduplicación, comparación de payloads, tratamiento de reintentos concurrentes y respuestas ante resultados inciertos, con su impacto explícito en firma/esquema si corresponde. **No existe esa decisión en este documento y no se añade una clave por inferencia.**

**Alternativas descartadas:** afirmar idempotencia por lock; deduplicar por motivo/tipo/timestamp; responder 200 ante un saldo inicial duplicado; declarar cerrado PRA-R12.

## G5 — Solo unidad base: CERRADO

La cantidad de UC-42 se interpreta en la unidad base del insumo seleccionado, mostrada por el sistema según la ficha Real. No se admiten conversiones en este MVP.

La firma UC-42 no contiene `codigoUnidadMedidaRecibida`, y `factorConversionAplicado` pertenece a `RECEPCION_COMPRA`, no al ajuste ni al movimiento de insumo. **No se agregan ni se persisten esos campos en UC-42.** La identidad de unidades equivale matemáticamente a no convertir, pero no se simula una recepción con factor guardado igual a 1.

No se promete validar un parámetro que la firma no recibe. Una futura interfaz que admita otra unidad y su conversión requerirá especificación y aprobación propias. `UNIDAD_NO_COINCIDE` de UC-08 no se copia como validación de un campo inexistente en UC-42.

**Alternativas descartadas:** inferir unidad recibida/factor desde UC-08, convertir sin una regla ratificada o añadir parámetros de conversión a la firma restringida.

## Diferencias entre INSUMO y REVENTA

| Aspecto | INSUMO, este corte | REVENTA, fuera de este corte |
|---|---|---|
| `SALDO_INICIAL` | Admitido con costo válido y F03 | No admitido por `ck_movimiento_stock_reventa_3` |
| `AJUSTE_POSITIVO` / `AJUSTE_NEGATIVO` | Tipos admitidos y tratados por esta RD | Tipos admitidos en el modelo; requieren su especificación posterior de implementación |
| Partidas y detalles MR-6 | Crear/descontar según G2 | No utiliza PARTIDA_INSUMO |
| Costeo | Histórico del mismo insumo | Promedio móvil/valoración según sus reglas; no se redefine aquí |

## Pruebas exigidas al PR de implementación; NO ejecutadas aquí

- Saldo inicial válido: costo previo al movimiento, secuencia 1, un ingreso físico, partidas/detalles conciliados y ausencia de Compra/Caja ficticias.
- `SALDO_INICIAL` duplicado secuencial y concurrente: segundo intento **409**, no 200 silencioso; stock y costo sin segundo efecto.
- Ajustes positivos/negativos, selección de partidas del mismo insumo, suma de cantidades, disponibilidad, descarte de vencidas y apertura explícita.
- Costos presentes/omitidos/inválidos y rollback sin efectos parciales.
- Reintentos ordinarios sin clave: documentar mediante pruebas el riesgo actual de doble efecto si ambas operaciones son válidas. No presentar una prueba de serialización como prueba de deduplicación.
- UI: confirmación, bloqueo de envíos en curso y manejo de resultado incierto, sin afirmar una garantía de servidor.
- PRA-R02/R03/R10: unicidad de episodio abierto, flanco válido para ronda y cierre solo con todas sus condiciones; no regresión del cierre de UC-08.
- Trazabilidad de usuario, motivo, fecha, costo y detalles; no divulgación de campos sin permiso.

Las pruebas B0 solo verifican documentación y fuentes. UC-42 B3/HTTP/UI y su comportamiento 409 son criterios futuros, no implementación ni pruebas de aplicación ya ejecutadas.

## Invariantes y propagación

- G0 inmutable: `source_commit=1263ffc17bd0eb7f3c69faaa9ff5ae556cf9de7e`, `governance_commit=27738b089afdd2698cdae915f75c0e8089a6248a`.
- MR-5/F01/MR-6, V1/V2/V3 y source-lock sin cambios.
- Sin cambios a contrato UC42, RD-MR-PARTIDAS-001, RD-UC08-001, RD-UC08-002 o RD-RP022-001.
- Esta decisión complementa el contrato propuesto sin reescribir G0 ni reautorizar D1-D3.
- Único archivo propuesto: esta RD. Propagación al servicio, API, UI, pruebas y extracción de lógica compartida pendientes de un PR futuro en la app.
- Issue #28 permanece abierta según el encargo. Sin despliegue, certificación productiva ni merge automático.

## Firmas

**Decisión ratificada por:** Victor Leandro Machado (`leandrito369`).
**Fecha:** 07/11/2026.
**Alcance de la ratificación:** G1, G2, G3 y G5 cerrados; mitigaciones y coordinación de G4 aprobadas, idempotencia pendiente para RD-UC42-002.
