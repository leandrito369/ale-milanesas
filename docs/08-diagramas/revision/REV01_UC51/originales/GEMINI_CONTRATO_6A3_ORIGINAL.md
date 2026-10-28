### Contrato 6A.3: `registrarInsumo` (`UC-50`), `buscarYModificarInsumo` (`UC-51` «include» `UC-36`) y `buscarYCambiarEstadoInsumo` (`UC-52` «include» `UC-36`)

* **Nombre:** `registrarInsumo(nombre: String, codigoUnidadMedida: String, umbralMinimo: BigDecimal, nivelObjetivo: BigDecimal, stockInicial: BigDecimal, costoInicial: BigDecimal\[0..1\])` / `buscarYModificarInsumo(criterio: FiltroInsumoDTO, nuevoNombre: String, codigoUnidad: String)` / `buscarYCambiarEstadoInsumo(criterio: FiltroInsumoDTO, nuevoActivo: Boolean, motivo: String)`

* **Responsabilidades:** Registrar un nuevo `Insumo` con sus parámetros de reposición y eventual saldo inicial valuado (`UC-50`), modificar sus datos descriptivos permitidos (`UC-51` incluyendo `UC-36`), o activar/desactivar lógicamente el `Insumo` (`UC-52` incluyendo `UC-36`) preservando sus costos, movimientos y compras históricas.

* **Tipo:** `Sistema`

* **Referencias cruzadas:** Casos de Uso `UC-50 — Registrar Insumo`, `UC-51 — Modificar Insumo`, `UC-52 — Cambiar Estado de Insumo` y `UC-36 — Buscar Insumo` *(relaciones «include» `UC-51→UC-36` y `UC-52→UC-36` aprobadas el 25/10/2026)*; Objetivo `OBJE-07`; Requisitos `RF-04`, `RF-05`.

* **Notas:** En `UC-52`, un `Insumo` inactivo (`activo = false`) no es elegible para nuevas Recetas ni para iniciar nuevas rondas automáticas (`PRA-01`), pero no borra Solicitudes, Órdenes, costos ni movimientos históricos. Pendientes asociados: **`F03`** (`SALDO_INICIAL`) y **`F09`** (inactivación lógica bajo concurrencia).

* **Excepciones:**

  * **A1 (`UC-50`) — Nombre duplicado, `nivelObjetivo <= umbralMinimo`, o `stockInicial > 0` sin `costoInicial > 0`:** Rechazar el alta sin persistir el `Insumo`.

  * **A2 (`UC-51`) — Nombre duplicado o intento de cambiar `codigoUnidadMedida` cuando existen Recetas, Compras o Movimientos históricos:** Rechazar la modificación.

  * **A3 (`UC-52`) — El estado solicitado coincide con el actual o existen dependencias activas incompatibles:** Informar la situación y mantener el estado anterior.

* **Salida:**

  * Confirmación del alta (`idInsumo`), de la modificación o del nuevo estado `activo` del `Insumo`; o mensajes provocados por las excepciones A1–A3.

* **Precondiciones:**

  * El `Administrador` se encuentra autenticado y autorizado. Para `UC-51` y `UC-52`, el `Insumo` fue localizado mediante `UC-36`.

* **Postcondiciones:**

  * **En `registrarInsumo` (`UC-50`):**

    * Se creó una instancia `unInsumo` de `Insumo` con `nombre`, `codigoUnidadMedida`, `stockActual = stockInicial`, `umbralMinimo`, `nivelObjetivoReposicion` y `activo = true`.

    * Si `stockInicial > 0`, se creó una instancia de `CostoInsumoHistorico` (`fuenteCosto = SALDO_INICIAL`, `costoUnitario = costoInicial`) y una instancia de `MovimientoInsumo` inicial asociada a `unInsumo`.

  * **En `buscarYModificarInsumo` (`UC-51`):**

    * Se modificaron los atributos descriptivos permitidos de `unInsumo` sin alterar `stockActual` ni su historial de movimientos.

  * **En `buscarYCambiarEstadoInsumo` (`UC-52`):**

    * Se modificó el atributo `unInsumo.activo` al valor `nuevoActivo`, preservando íntegramente sus movimientos, costos, invitaciones y órdenes históricas y evitando nuevas rondas automáticas mientras permanezca inactivo.

\---