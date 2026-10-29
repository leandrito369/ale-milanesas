# REV-01 — Acta de corrección de UC-42: Ajuste de Inventario

**Fecha:** 28/10/2026. **Estado:** PROPUESTA / NO VALIDADA ACADÉMICAMENTE. **Integración:** rama `revision/rev01-uc50-insumos-2026-10-27`, PR #10 en borrador, base en la rama documental PR #9. **No hubo migración DDL, ejecución de servicio ni modificación del diagrama de casos de uso rechazado.**

## Objeto y alcance de esta entrega

Se examinan únicamente el **DS de UC-42** (diseño), la sección de **UC-42 en el DSS del Responsable de Producción** (caja negra) y el **contrato 4.4 de UC-42** de la conversación completa de Gemini. Se preservan las tres extracciones originales en `originales/` y se añaden tres copias corregidas en `propuestos/`. La revisión de UC-51, de otros fragmentos de los DSS y la verificación académica de los 64 CU **no quedan completas** por este acto.

## Fuentes documentales verificadas

1. `CHAT GEMINI Continuación TFI Ale Milanesas - 2610-2710.md` (archivo adjunto). DS UC-42 **líneas 16815–17020**; DSS Producción **líneas 1783–2299**, sección de UC-42 **2123–2217**; Contrato 4.4 **19718–19766**.
2. `docs/01-gobierno/RD_RP016_001_ALTA_INSUMO_SIN_STOCK_COSTO_2026-10-27.md` — UC-50 solo crea maestro con stock 0; ingreso real se registra por UC-42.
3. `docs/01-gobierno/RD_RP017_001_UNIDAD_MEDIDA_INSUMO_HISTORIAL_2026-10-27.md` — unidad histórica bloqueada.
4. `docs/01-gobierno/RD_RP022_001_COSTEO_CONVERSIONES_REDONDEOS_2026-10-27.md` — unidad base, costo histórico, promedio móvil REVENTA, valoración extraordinaria, conversión, decimal y no retroactividad.
5. `docs/01-gobierno/RP_01_SEGUIMIENTO_TRANSVERSAL_2026-10-26.md` — RP-015, integridad física `SALDO_INICIAL` validada en laboratorio SQL; integración de aplicación pendiente.
6. `docs/05-modelo-relacional/Diccionario_Explicativo_60_Tablas_MR5_MR6_26-10-2026.md` — atributos reales de `INSUMO`, `COSTO_INSUMO_HISTORICO`, `MOVIMIENTO_INSUMO`, `PRODUCTO`, `MOVIMIENTO_STOCK_REVENTA`, `VALORACION_EXTRAORDINARIA_REVENTA`, `RECEPCION_COMPRA`.

## Matriz de diferencias (Gemini → propuesta)

| ID | Artefacto | Evidencia de origen | Corrección propuesta | Fundamento | Verificación |
|---|---|---|---|---|---|
| UC42-C01 | DS: título | `u42_title` aún presenta F03 como totalmente pendiente | Distinguir control SQL realizado de **servicio, conversión y QA pendientes** | RP-015/MR-6 | Texto propuesto |
| UC42-C02 | DS: línea de vida | `u42_inv_box` mezcla `Insumo / ProductoReventa` como una misma instancia | Participantes `Insumo` y `Producto` de tipo `REVENTA` separados | Dominio B y diccionario `PRODUCTO.tipoProducto` | Celdas diferentes |
| UC42-C03 | DS: movimientos | `u42_mov_box` mezcla `MovimientoInsumo / MovimientoStockReventa` | Separar las dos clases de movimiento | Modelo MR-5/MR-6 | Celdas diferentes |
| UC42-C04 | DS: `SALDO_INICIAL` | Rama positiva sin objeto `CostoInsumoHistorico` ni FK explícita | Mostrar efecto de crear/referenciar valoración del mismo Insumo con `fuenteCosto=SALDO_INICIAL` y `vigenteDesdeCosto` | RP-015, RD-RP016-001, diccionario | Rama y nota |
| UC42-C05 | DS: REVENTA | Un único mensaje genérico `aplicarDiferenciaStockYValuacion` | Rama REVENTA con costo promedio móvil y eventual `ValoracionExtraordinariaReventa` documentada | RD-RP022-001 | Rama, marco `opt` |
| UC42-C06 | DS: errores | Guarda genérica de saldo negativo | Rechazos explícitos por tipo ELABORADO, cantidad, motivo, autorización y falta de costo requerido, sin cambio de stock | RD-RP022-001, origen Gemini | Rama `alt` |
| UC42-C07 | DSS Producción | Solo 3 alternativas; salida basada en tablas internas | Aclarar `SALDO_INICIAL` frente a ajuste y resultado observable; conservar tres alternativas y el estilo del archivo base | Larman caja negra, RD-RP016-001 | Ocho celdas editadas |
| UC42-C08 | Contrato 4.4 | No explicita todos los efectos de valoración y correspondencia con RP-022 | Nueve secciones con postcondiciones por Insumo `SALDO_INICIAL`, ajuste ordinario y Producto REVENTA | Material de cátedra y RD-RP022-001 | Nueve secciones |
| UC42-C09 | Conversiones | Potencial confusión entre ajuste y recepción | No inferir un campo `factorConversionAplicado` para UC-42: aparece en `RECEPCION_COMPRA` (UC-08); unidades de stock expresadas en unidad base | Diccionario + RD-RP022-001 | Nota y contrato |
| UC42-C10 | Inventario histórico | Falta prohibición explícita de recalcular costo pasado | Mantener historia inmóvil y costo real, no inferir valores cero | RD-RP022-001 | Contrato y DS |

## Evidencia de revisión real

- **Extracción original:** analizador `xml.etree.ElementTree` pudo leer el diagrama DS UC-42 extraído (23 `mxCell`) y la página DSS Producción de Gemini (50 `mxCell`), reconstruidos a partir de Markdown escapado.
- **Archivos GitHub propuestos:** comprobación posterior por lectura desde la rama: DS de **una página y 46 `mxCell`**, DSS de **una página y 50 `mxCell`**, ID de `mxCell` únicos, balance de etiquetas de celda, raíces `mxfile`, `diagram` y `mxGraphModel` presentes, sin caracteres `&` sin escape según comprobación textual.
- **Contrato UC-42:** nueve secciones enumeradas más glosario y límites explícitos de alcance.
- Se verificó correspondencia de campos `vigenteDesdeCosto`, `fuenteCosto` y `factorConversionAplicado` con el diccionario explicativo; **no** se crearon nombres de columnas.
- **No se comprobó mediante parser XML el archivo corregido ya descargado desde GitHub**; el control ejecutado sobre él fue estructural/textual. **No se abrió ni exportó visualmente en Draw.io**. Por ello, no se certifican legibilidad, geometría, semántica UML ni editabilidad.

## Controles funcionales pendientes antes de aprobar

1. **Fichas académicas**: comparar mensaje por mensaje con UC-42 Extendido/Real nativo y su matriz de permisos. Comprobar si la firma propuesta debe desagregarse.
2. **Visibilidad de Larman**: confirmar cómo `:ControladorInventario` obtiene referencias de Insumo/Producto y cómo crea y asocia movimientos/costos; las referencias propuestas no son evidencia de código ejecutado.
3. **Transacciones**: probar atomicidad de ajuste + costo + historia, stock no negativo y carreras de movimientos simultáneos.
4. **Límites de costo**: verificar el contrato físico de cada tipo de ajuste; no asumir que todas las altas de REVENTA son `SALDO_INICIAL` de Insumo.
5. **Valoración REVENTA**: validar promedio ponderado ante entradas valorizadas, stock sin costo válido, cero stock, y salidas sin retroactividad.
6. **Conversiones y precisión**: confirmar política de ingreso por UC-42 en una unidad distinta a la base; si se habilita, diseñar evidencia de conversión sin inventar columna en `MOVIMIENTO_INSUMO`. Aplicar precisión 2/4 aprobada según etapa.
7. **PRA-01**: revisar disparadores, episodio faltante y regla de **no emisión automática de OrdenCompra**.
8. **Draw.io**: abrir, mover, guardar y reabrir los XML; controlar legibilidad, fragmentos, tiempos, creación de líneas de vida y sin superposición. El DS presenta **nuevas líneas de vida alternativas** cuya visualización necesita cotejo.
9. **UC-51**: pendiente en esta REV-01, incluido el bloqueo de unidad de medida conforme a RP-017.

## Criterio de aprobación

Este PR es un **artefacto de trabajo** y debe permanecer en borrador; no acredita UC-42 terminado ni autoriza merge a `main`. Se solicita validación posterior del lote de UC-42 y UC-51 antes de dar por cerrada REV-01.
