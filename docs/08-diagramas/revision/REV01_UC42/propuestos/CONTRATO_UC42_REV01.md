# REV-01 — Contrato UC-42: Registrar Ajuste de Inventario

**Estado:** PROPUESTA, no validada académicamente. **Fuente:** Contrato 4.4 de Gemini (chat, líneas 19718–19766), revisado a la luz de RD-RP016-001, RD-RP022-001 y RP-015. **No modifica UC-08 ni UC-50.**

## 1. Nombre

`registrarAjusteInventario(tipoElemento: String, idElemento: Long, tipoMovimiento: String, cantidad: Decimal, motivo: String, costoValuacion: Decimal[0..1])`

**Nota de firma:** es una *firma de diseño propuesta* para mantener trazabilidad con el DS de Gemini, no un contrato API implementado ni un atributo añadido al modelo. El nombre de parámetro `costoValuacion` armoniza el costo opcional del DS y del DSS; **pendiente cotejo textual con la ficha Real de UC-42**.

## 2. Responsabilidades

Registrar una variación real y justificada del stock de un Insumo o un Producto de tipo `REVENTA`, o un ingreso físico inicial de Insumo de tipo `SALDO_INICIAL`, sin atribuir a UC-50 el registro de inventario. Conservar el costo aplicable, el responsable y la procedencia, impedir stock negativo y evitar alteraciones retroactivas.

## 3. Tipo

Sistema.

## 4. Referencias cruzadas

UC-42 — Registrar Ajuste de Inventario; UC-50 — Registrar Insumo (alta de maestro sin stock físico); UC-08 — Registrar Ingreso de Stock por Compra (recepciones y factor de conversión de compra); RP-015, RD-RP016-001, RD-RP017-001, RD-RP022-001; diccionario MR-5/MR-6: `INSUMO`, `COSTO_INSUMO_HISTORICO`, `MOVIMIENTO_INSUMO`, `PRODUCTO`, `MOVIMIENTO_STOCK_REVENTA` y `VALORACION_EXTRAORDINARIA_REVENTA`. PRA-01 donde corresponda.

## 5. Notas

- Se distingue **inventario Insumo** de **inventario Producto REVENTA**. Los Productos `ELABORADO` no se ajustan mediante un stock comercial general de REVENTA.
- **`SALDO_INICIAL` del Insumo** es un ingreso físico real y trazable por UC-42, **no** un movimiento generado por UC-50. Requiere costo histórico válido con `fuenteCosto=SALDO_INICIAL`; `MOVIMIENTO_INSUMO.vigenteDesdeCosto` referencia ese costo del **mismo Insumo**.
- Los movimientos ordinarios de Insumo conservan su vínculo a costo histórico aplicable. No se inventa costo cero ni se sobreescriben movimientos anteriores.
- En REVENTA se conserva `costoPromedioActualReventa`. Los ingresos válidamente valorizados actualizan el promedio móvil ponderado por cantidades; las salidas conservan el costo aplicado. Si falta un costo válido cuando es necesario valorizar el stock, se exige **valoración extraordinaria justificada**, no cero ficticio.
- El `motivo` de ajuste debe documentarse, y el `idUsuarioResponsable` mantiene trazabilidad.
- Las cantidades usadas para stock se expresan en la **unidad base**. RP-022 dispone conversiones y control de precisión decimal; **no se supone que UC-42 tenga `factorConversionAplicado`**, campo que el diccionario conserva expresamente en `RECEPCION_COMPRA` (UC-08). Si se habilitan entradas de ajuste en otras unidades, su interfaz y evidencia deben diseñarse y aprobarse.
- La evaluación de PRA-01 sigue sus reglas aprobadas: no equivale a emitir automáticamente una Orden de Compra. Los controles relacionales MR-5/MR-6 no sustituyen a los servicios transaccionales.

## 6. Excepciones

- **E1.** Tipo no elegible (`ELABORADO`), identificador inexistente o acceso no autorizado: rechazar.
- **E2.** Cantidad no positiva, unidad incompatible o conversión no admisible: rechazar.
- **E3.** Stock resultante negativo o modificación concurrente que vuelva inválida la operación: rechazar sin efectos parciales.
- **E4.** Motivo exigible omitido: rechazar.
- **E5.** `SALDO_INICIAL` de Insumo sin costo histórico válido o con fuente/relación inconsistentes: rechazar.
- **E6.** Ajuste de REVENTA cuya valoración requiera respaldo y carezca de costo válido o valoración extraordinaria justificada: rechazar.
- **E7.** Datos de costo, origen o identificación que contradigan la historia inmutable: rechazar.
- **E8.** Error en registro atómico de movimiento, saldo o costo: no confirmar parcialmente; queda pendiente definir pruebas concretas de servicio/transacción.

## 7. Salida

Confirmación y referencia del movimiento físico registrado y del saldo resultante para el Insumo o Producto REVENTA, o rechazo explícito. El costo y la justificación se conservan para auditoría; no se divulgan campos sensibles a roles sin permiso.

## 8. Precondiciones

- Actor autenticado y autorizado para UC-42 en el ámbito del elemento seleccionado (según matriz de permisos vigente).
- Insumo o Producto REVENTA existente, unidad base identificada y cantidad/motivo válidos.
- Disponibilidad de fuente de costo consistente con la clase de movimiento y su procedencia; para `SALDO_INICIAL`, la validación de costo histórico y origen de RP-015.
- No se presupone que el alta UC-50 haya generado movimientos ni costos.

## 9. Postcondiciones

**Caso A — Insumo, `SALDO_INICIAL` real:**
- Se crea un `MovimientoInsumo` asociado al `Insumo` y al `Usuario` responsable, con cantidad, tipo, origen/documentación y `stockResultante`.
- Se crea o referencia el `CostoInsumoHistorico` válido con `fuenteCosto=SALDO_INICIAL`, y el movimiento queda asociado al costo de **ese Insumo** mediante `vigenteDesdeCosto`.
- Se modifica `Insumo.stockActual` exclusivamente por la cantidad ingresada real. No se crea Compra ni registro de Caja ficticios.

**Caso B — Insumo, ajuste ordinario:**
- Se crea un `MovimientoInsumo` justificado con costo histórico aplicable y se modifica `Insumo.stockActual`, manteniéndolo no negativo.
- Permanecen inalterados los movimientos y costos históricos anteriores.

**Caso C — Producto REVENTA:**
- Se crea un `MovimientoStockReventa` asociado al `Producto` y al responsable, y se modifica `Producto.stockActualReventa` sin quedar negativo.
- Se conserva o actualiza el costo promedio móvil conforme a la dirección del movimiento y a la valoración real. Cuando corresponda por falta de costo válido, existe una `ValoracionExtraordinariaReventa` justificada y asociada.
- No se recalculan costos de ventas, Entregas ni movimientos históricos anteriores.

**Rechazo:** no se crean movimientos ni valoraciones ni se modifican saldos de stock, costos o históricos.

## Glosario

**`SALDO_INICIAL`:** ingreso físico inicial documentado de Insumo, separado de UC-50. **Costo histórico:** valor con fuente, vigencia y relación con el Insumo aplicable. **Promedio móvil:** costo unitario resultante de ingresos reales de REVENTA ponderados por sus cantidades. **Valoración extraordinaria:** justificación auditable para costo REVENTA cuando falta una valoración válida. **Unidad base:** unidad de stock definida por cada Insumo/Producto.

## Límites de esta revisión

No se ejecutó SQL ni API. Pendientes: validación visual en Draw.io, cotejo exhaustivo con CU-42 Real/Extendido del Word maestro, exactitud de enumeraciones/orígenes y rutas de coste para ajustes extraordinarios, variantes de conversión de UC-42, reglas transaccionales de concurrencia y verificación con QA de MR-5/MR-6.
