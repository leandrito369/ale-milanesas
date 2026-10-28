### Contrato 4.4: `registrarAjusteInventario` (`UC-42`)

* **Nombre:** `registrarAjusteInventario(tipoElemento: String, idElemento: Long, tipoAjuste: String, cantidad: BigDecimal, motivo: String, costoExtraordinario: BigDecimal\[0..1\])`

* **Responsabilidades:** Registrar un ajuste positivo o negativo justificado de existencias (o la carga de `SALDO_INICIAL` físico con su valuación) sobre un `Insumo` o sobre un `Producto` de `tipoProducto \= REVENTA`, actualizando su stock actual y dejando trazabilidad del movimiento y de su valoración.

* **Tipo:** `Sistema`

* **Referencias cruzadas:** Caso de Uso `UC-42 — Registrar Ajuste de Inventario`; incluye `UC-36 — Buscar Insumo` / `UC-35 — Buscar Producto`; Objetivos `OBJE-05`, `OBJE-07`; Requisito `RF-04`.

* **Notas:** No se admiten ajustes directos de stock sobre Productos de tipo `ELABORADO` (cuyas existencias provienen de `Preparacion` y `Excedente`). Pendiente asociado: **`F03`** (integridad del vínculo de costeo en `SALDO_INICIAL`).

* **Excepciones:**

  * **A1 — Stock resultante negativo (`stockResultante < 0`):** Rechazar el ajuste sin modificar existencias.

  * **A2 — Elemento de tipo `ELABORADO` o falta de `motivo` obligatorio:** Rechazar la operación.

  * **A3 — Operación de `SALDO_INICIAL` o alta positiva sin fuente de costo previa cuando no se informa `costoExtraordinario > 0`:** Impedir el registro sin valoración válida.

* **Salida:**

  * Confirmación del ajuste registrado y nuevo `stockResultante`, o mensajes provocados por las excepciones A1–A3.

* **Precondiciones:**

  * El `Responsable de Producción` (o `Administrador`) se encuentra autenticado y autorizado.

  * Existe el `Insumo` o el `Producto` de tipo `REVENTA` seleccionado.

* **Postcondiciones:**

  * Si `tipoElemento \= INSUMO`:

    * Se modificó `Insumo.stockActual` al valor `stockResultante`.

    * Si correspondió a `SALDO_INICIAL`, se creó una instancia de `CostoInsumoHistorico` con `fuenteCosto \= SALDO_INICIAL`.

    * Se creó una instancia de `MovimientoInsumo` asociada al `Insumo`, a la vigencia de costo (`vigenteDesdeCosto`) y al `Usuario` responsable, con `motivo` y `stockResultante`; y se evaluó la apertura/cierre de `EpisodioFaltante` (`PRA-01`).

  * Si `tipoElemento \= REVENTA`:

    * Se modificó `Producto.stockActualReventa` al valor `stockResultante`.

    * Si requirió valoración extraordinaria, se creó una instancia de `ValoracionExtraordinariaReventa` asociada al `Producto` y al `Usuario` responsable.

    * Se creó una instancia de `MovimientoStockReventa` asociada al `Producto` y al `Usuario` responsable con `motivo` y `stockResultante`.

\---