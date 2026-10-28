# REV-01 — Contrato de operación: UC-50 Registrar Insumo

**Estado:** PROPUESTA CORREGIDA; **no validado todavía** contra las 192 fichas canónicas ni en Draw.io. **Origen:** contrato 6A.3 de Gemini, que unía UC-50, UC-51 y UC-52.

## 1. Nombre

**Firma de homologación DSS/DS:** la tipificación `BigDecimal` refleja el contrato de diseño documentado, no un lenguaje de programación ni implementación aprobados.
`registrarInsumo(nombre: String, codigoUnidadMedida: String, umbralMinimo: BigDecimal, nivelObjetivoReposicion: BigDecimal, automatizacionCompraActiva: Boolean)`

## 2. Responsabilidades
Registrar el maestro de Insumo sin existencia física inicial y sin costo inventado, comprobando autorización y datos operativos obligatorios. El alta no equivale a una operación de inventario.

## 3. Tipo
Sistema.

## 4. Referencias cruzadas
UC-50 — Registrar Insumo; UC-42 — Registrar Ajuste de Inventario; RD-RP016-001 (RP-016); RP-015 / SALDO_INICIAL; diccionario MR-5/MR-6, tabla `INSUMO`. Para modificación de unidad de medida: UC-51 y RD-RP017-001.

## 5. Notas
- `stockActual` comienza en **0**. UC-50 no recibe `stockInicial` ni `costoInicial`.
- La primera entrada física real, en su caso, se registra por UC-42 con `SALDO_INICIAL` y costo histórico válido y trazable. No se crea automáticamente una Compra, un Cobro ni un movimiento de Caja.
- `automatizacionCompraActiva` existe en el diccionario vigente y es un atributo no nulo; se recoge explícitamente sin fijar un valor predeterminado no aprobado.
- No se traslada a UC-50 ningún proceso de valoración, recepción o recuperación de faltante sin fuente específica.

## 6. Excepciones
- **E1:** Insumo con nombre/identidad duplicada según regla aplicable: rechazar alta sin persistencia.
- **E2:** Unidad de medida inexistente o inválida: rechazar alta.
- **E3:** Parámetros obligatorios ausentes o inconsistentes: rechazar alta. Se mantiene la validación `nivelObjetivoReposicion > umbralMinimo >= 0` del diseño original, pendiente de cotejo literal con la ficha canónica.
- **E4:** Usuario sin permiso UC-50: rechazar alta.
- **E5:** Petición de stock o costo inicial como efecto de UC-50: rechazar ese efecto y remitir al flujo UC-42 aplicable.

## 7. Salida
Identificador `idInsumo` y confirmación de creación del maestro, o rechazo identificando la causa. Sin costo inicial fabricado.

## 8. Precondiciones
Administrador autenticado y autorizado; nombre admisible y no duplicado; UnidadMedida existente y válida; parámetros requeridos informados.

## 9. Postcondiciones
**Si la operación tiene éxito:**
- Se crea una instancia `unInsumo:Insumo` con `nombre`, `codigoUnidadMedida`, `stockActual = 0`, `umbralMinimo`, `nivelObjetivoReposicion`, `automatizacionCompraActiva` y `activo = true`.
- No se crea instancia de `MovimientoInsumo` ni de `CostoInsumoHistorico` como efecto de UC-50.
- No se registra Compra o Caja ficticia ni se alteran existencias preexistentes.

**Si la operación se rechaza:** no se crea instancia de Insumo ni se altera el inventario.

## Glosario asociado
**Insumo:** materia prima catalogada. **Unidad de medida base:** unidad asociada a su existencia. **SALDO_INICIAL:** ingreso físico justificable mediante UC-42, separado del maestro. **CostoInsumoHistorico:** costo con fuente y vigencia real.

## Puntos pendientes de validación
Cotejar la firma con la ficha Real/Extendida original de UC-50 y el catálogo RF/IRQ vigente; verificar en Draw.io la legibilidad, activaciones y ausencia de interferencias; asegurar que el contrato de UC-42 cubra el ingreso inicial real. Estos puntos **no se declaran validados**.
