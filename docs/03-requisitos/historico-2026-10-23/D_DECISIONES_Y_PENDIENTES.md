# D — Decisiones, estado y pendientes — Ale Milanesas
**Corte:** 23/10/2026. **Vigente.** Esta fuente sustituye las frases antiguas de estado *provisional* de la edición del 21/10. Fuentes históricas disponibles en `99_Historico`.

## I. Estado firme
- 49 CU vigentes = UC-01 a UC-50 salvo UC-14 (solo histórico). Tres niveles por CU, extraídos de la copia del Documento General integrada.
- UC-46 Modificar Proveedor; UC-47 Cambiar Estado de Proveedor; UC-48 Modificar Producto; UC-49 Cambiar Estado de Producto; UC-50 Registrar Resultado de Reembolso Electrónico.
- UC-16 actor textual Administrador; UC-17 actor textual Sistema, **no figura como actor externo en UML**.
- UC-05/UC-07/UC-29 con reglas de cantidades congeladas, adiciones y trazabilidad aceptadas; UC-22 OTP por teléfono de Cliente registrado y ACTIVO; accesos ambiguos bloqueados.
- 64 decisiones relacionales MR-01…MR-64 aprobadas en siete bloques; 59 tablas distintas; 443 columnas + FK de Excedentes = 444 y 119+1=120 FK.
- FK opcional `EXCEDENTE.idMovimientoExcedenteOrigen → MOVIMIENTO_EXCEDENTE.idMovimientoExcedente` aprobada por el usuario el 22/10; requiere verificación cruzada de Producto, destino, cantidades y costo.
- Activo como diagrama CU: archivo `Diagrama_Casos_de_Uso_Ale_49CU_CORREGIDO_23-10-2026.drawio`, XML nativo de Draw.io, que sustituyó el defectuoso con `atob`.
- Activo como modelo relacional: `Modelo_Relacional_Ale_59_Tablas_Editable_Compacto.drawio`; ambas son una página y editables.

## II. Decisiones relacionales validadas
| Código | Bloque | Alcance de decisiones aprobadas |
|---|---|---|
| MR-01–MR-08 | Recetas, Producto, Insumo y Producción | Receta / Versión / Detalle de versión; consumo por movimiento; unidad normalizada; PK y FK históricas. |
| MR-09–MR-16 | Pedidos y Excedentes | DETALLE_PEDIDO PK (idPedido,numeroDetalle) y AK (idPedido,idProducto); oferta y movimiento separados; imputación de original antes de adiciones; entrega única; saldos históricos, restricciones ACID. |
| MR-17–MR-24 | Catálogo, Precios, Promociones | PRECIO_PRODUCTO temporal con EXCLUDE; AUDITORIA_PRECIO inmutable; asociaciones M:M; intentos de comunicación; política comercial versionada y ajuste por categoría. |
| MR-25–MR-34 | Clientes, Usuarios y Autenticación | Cliente ≠ Usuario; historial y Roles, proveedor vinculado a usuario; sesiones distintas; verificación telefónica en línea; bloqueo por teléfono compartido ambiguo; snapshots históricos en PEDIDO. |
| MR-35–MR-47 | Proveedores, Cotizaciones y Compras | CUIT único, PROVEEDOR_INSUMO temporal, EPISODIO_FALTANTE técnico, solicitudes encadenadas, invitación y respuesta única dentro del plazo, decisión humana, orden/recepción diferenciadas. |
| MR-48–MR-55 | Inventario y Costeo | MOVIMIENTO_STOCK_REVENTA, secuencia por inventario, valoraciones extraordinarias, FK compuestas de recepción, factor histórico de conversión, costos congelados. |
| MR-56–MR-64 | Cuenta Corriente, Caja y Reembolsos | COBRO idempotente; movimientos Cuenta/Caja; origen automático; reembolso completo único; intentos y eventos; efecto financiero exactamente una vez al PROCESADO; consultas derivadas. |

## III. UML — matriz aprobada de 29 relaciones
La matriz vigente del 21/10 contiene **27 «include» y 2 «extend»**. Usar `Matriz_Relaciones_UML_23-10-2026.md` y los CU a tres niveles para fundamentarlas.
Para decidir entre include y extend, usá siempre estas preguntas:

Include: ¿el caso base puede completar su objetivo sin ese comportamiento? Si no puede, es include. Se ejecuta siempre y la flecha va del base al incluido.
Extend: ¿el comportamiento es opcional o condicional, y el base está completo sin él? Entonces es extend. La flecha va de la extensión al base, y lleva condición y punto de extensión.
## IV. Observaciones del profesor — clase del 21/10/2026
- Solicita presentar el **Modelo Relacional** y demostrar cómo se materializa el versionado de Receta en tablas, PK y FK; plazo indicado en conversación: lunes 26/10/2026.
- UC-03 Cargar Pedido: explicitar identificación/asociación del Cliente (en matriz actual incluye UC-34 Buscar Cliente).
- UC-28 Consultar Margen Bruto: aclarar si se consulta sobre una venta individual, mediante qué búsqueda y cómo queda reflejado en el diagrama. **Pendiente de comprobar**; no inventar UC Buscar Venta ni agregar relación sin validarla en flujos.
- UC-23 Registrar Movimiento de Caja: no modelar abandono genérico o error de tipeo banal como excepción; sí errores relevantes de validación; mejorar redacción de excepciones.
- UC-24 Consultar Libro Diario: aclarar reportes de movimientos monetarios vs utilidad.
- El profesor examinó Modelo de Dominio pero centró la próxima revisión en tablas del Modelo Relacional.

## V. Pendientes reales, NO aprobados ni solucionados automáticamente
1. **UC-22 Extendido:** `[A CONFIRMAR]` fecha exacta de reparto ONLINE. Mecanismo OTP sí está aprobado; no confundir.
2. **UC-44 Extendido:** `[A CONFIRMAR]` criterios de elegibilidad Pedido/Repartidor y tratamiento offline; no inventar.
3. **UC-27:** alinear denominación del campo «Actor principal» entre los tres niveles sin representar Sistema como actor externo.
4. **UML caso de uso UC-28:** verificar relación con búsqueda de venta o Pedido contra intención real; el diagrama actual mantiene únicamente 27 includes aprobados, podrían faltar asociaciones que el profesor observe.
5. **Modelo Relacional SQL:** sin validación ejecutada en PostgreSQL. Falta implementar triggers de 1..* Roles, traspasos, historial append-only, efectos completos de cobros/reembolsos, no solapamiento temporal, bloqueos y pruebas de concurrencia.
6. **Decisiones numéricas comerciales:** redondeos de importes/costos, compatibilidad y conversiones de Unidad de Medida, fórmula/ponderaciones de criterios de Compra, estados definitivos de algunos flujos, promociones simultáneas.
7. **UC-49 Producto:** comprobar si basta la representación de activo y historial actual o si exige una relación de eventos específica; no agregar tabla sin decisión.
8. **Documentación maestra:** índices automáticos de Word y diagramas incrustados pueden ser anteriores; el `.drawio` corregido prevalece visualmente. La copia del 21/10 es fuente de flujos, no declararla aprobada como versión final de entrega.

## VI. Próxima tarea al abrir un chat nuevo
**Prioridad:** revisión técnica y visual del Diagrama de Casos de Uso en Draw.io: actor a izquierda/derecha, no colisiones, etiqueta y cuestiones de include/extend, cotejo uno por uno con flujos y observaciones del profesor. Después cerrar pendientes funcionales del CU (principalmente UC-28 y UC-23), actualizar el diagrama y preparar la defensa del lunes. Mantener la versión única del Modelo Relacional en Draw.io.


