# REV-06A — Cotejo con Fase 4 (64 CU × 3 niveles), correcciones y condición de integración

**Corte:** 28/10/2026. **Estado:** cotejo funcional documentado; validación XML estructural y geométrica parcial; **inspección visual Draw.io pendiente**.  
**Fuente utilizada:** [CASOS_DE_USO_64_TRES_NIVELES](https://docs.google.com/document/d/1BMF2Yfsh2ki353fU2dS5eZtIsYrOntpkjjAzulNy1uY/edit), Google Doc nativo accesible en Drive, revisión `AHj4eMRApkXnQrOvOp9RqLYElYqrVLQrT1rMc2Tkwtez9U1HA1AGGaQ2L0dhNTjxMMFcptBs4cJjqM_hONxD1Uxu97IstR5g22N4F8642Oo` (consultada el 28/10/2026). Los nueve CU aparecen en los tres niveles: Alto Nivel, Extendido y Real.  
**Propuesta cotejada:** rama `revision/rev06a-comercial-promociones-2026-10-28`, PR #15, DSS 2 páginas, DS 9 páginas, contratos 9; [acta previa](./REV06A_AUDITORIA_RECUPERACION_TRAZABILIDAD_2026-10-28.md).  
**Precedencia:** RD-RP007-002, RD-RP018-001 y RD-RP023-001 aprobadas frente a formulaciones más genéricas de fichas. El cotejo no convierte propuestas de diseño en implementación física.

## 1. Matriz de resultados por CU

| CU | Ficha Alto Nivel / Extendido / Real: exigencias comprobadas | DSS / DS / contrato: resultado del cotejo | Dictamen |
|---|---|---|---|
| **UC-35 Buscar Producto** | Identificar con filtros por id/nombre/tipo/estado, presentar coincidencias y selección; sin registros, informar ausencia; actor “Usuario interno autorizado” | Se mantiene operación independiente, selección contextual y filtro. Actor precisado por **RD-RP007-002**: Administrador y Vendedor, no Producción | **Conforme funcional** |
| **UC-30 Gestionar Producto** | La ficha abarca **alta, modificación, desactivación y reactivación**; unicidad de nombre también frente a inactivos; conservar historia y registrar trazabilidad | Operación `gestionarProducto` cubre **alta**; modificaciones y estado se trazan específicamente en UC-47/UC-48, sin duplicar efectos. Se agregó traza de alta y aclaración de ausencia de precio inicial (RD-RP018-001), sin crear tabla artificial | **Conforme condicionado a reconocer la desagregación UC-30/47/48** |
| **UC-47 Modificar Producto** | UC-35 para seleccionar, actualizar solo datos admitidos; nombre no duplicado; tipo/unidad inmutables cuando exista historial; cambios de estado/precio/Receta corresponden a otros CU | Revalidación y rechazo antes de mutar; se corrigió uso del nombre normalizado sin definir, empleando `normalizar(nuevoNombre)` | **Conforme funcional** |
| **UC-48 Cambiar Estado Producto** | Desactivar o reactivar conservando Pedido PENDIENTE, inventario, Órdenes y Recetas; reactivar solo con datos vigentes válidos; comprobar concurrencia | DSS, DS y contrato preservan antecedentes; DS ahora explicita revalidación de estado y dependencias al confirmar | **Conforme funcional; F09 requiere implementación** |
| **UC-19 Actualizar Precio Vigente** | Precio nuevo positivo, primer Precio sin versión anterior permitido; sin vigencias superpuestas; **fecha retroactiva prohibida**; futuro no aplica antes de inicio; fallo no muta anterior | Se corrigió DSS, DS y contrato para prohibir retroactividad; validación no muta antes de rama exitosa; PrecioProducto y AuditoriaPrecio tienen lifelines distintas | **Conforme documental tras corrección; sin prueba de concurrencia** |
| **UC-20 Consultar Historial Precios** | Distingue históricos / vigente / futuros; ausencia de versiones, precio único o falta de precio actual; no exponer datos no autorizados | Se corrigieron DSS, DS y contrato para distinguir categorías y excepciones sin alteraciones | **Conforme funcional** |
| **UC-24 Crear y Comunicar Promoción** | Producto(s) activo(s) y al menos un Cliente elegible; registra Promoción disponible según vigencia, acceso al canal online, comunicaciones y resultados individuales; fallo de uno no anula otros ni la campaña | Se aclaró estado conforme a vigencia y traza individual; excepción por enlace online inutilizable añadida. Beneficio económico elegible según RD-RP023-001 sin asumir equivalente a máximo porcentaje. Promoción/Producto/Destinatario/Intento en lifelines distintas | **Conforme funcional como propuesta; integración de mensajería pendiente** |
| **UC-59 Consultar Promociones** | Filtros por id/vigencia/estado/Producto; **selección de una Promoción y consulta de detalle**; destinatarios e intentos documentados, sin reenvío | DS y contrato ampliados con detalle, falta de intentos y selección inválida; solo lectura | **Conforme funcional** |
| **UC-60 Desactivar Promoción** | Presentar estado y vigencia; advertir sobre históricos; confirmar; revalidar transaccionalmente; no cancelar pedidos históricos ni enviar comunicaciones; no repetir bajas | DSS/DS/contrato reflejan las condiciones. **La ficha y RD-RP023-001 no dan aquí un literal único inequívoco de estado destino**, por lo que no se inventa una transición concreta. F08 prohíbe atribuir reactivación PAUSADA→ACTIVA sin CU/decisión | **Conforme en comportamiento; transición exacta pendiente de ratificación** |

## 2. Correcciones posteriores al primer cierre documental

**Cotejo literal del Word/Google Doc Fase 4, tres niveles** sobre las operaciones del Lote 6A.

- **W6A-01 — UC-19 (Alta):** contrato y diagramas omitían prohibición de vigencia retroactiva (alternativa A2 del Extendido, paso 3 Real). Se incorporó y se mantiene que vigencia futura no aplica antes del inicio; primer precio no requiere precio previo.
- **W6A-02 — UC-20 (Media):** antes no se distinguía explícitamente histórico/actual/futuro ni ausencia de precio actualmente aplicable. Se incorporaron alternativas de ausencia, precio único y acceso no autorizado.
- **W6A-03 — UC-24 (Media):** se explicitó alta de Promoción ACTIVA conforme a vigencia, acceso identificable y persistencia de resultados por destinatario; se añadió excepción de referencia online no válida; no se agregan envíos ficticios.
- **W6A-04 — UC-30 (Media):** se preserva que UC-30 es “Gestionar Producto”, con alta por `gestionarProducto` y mantenimiento/estado separados en operaciones UC-47/UC-48; trazabilidad sin suponer una tabla de cambios de Producto inexistente.
- **W6A-05 — UC-47 (Media):** se aclaró origen de `nombreNormalizado` en DS con `normalizar(nuevoNombre)`.
- **W6A-06 — UC-48 (Media):** guarda de cambio de estado incorpora revalidación concurrente en la instancia antes de aceptar.
- **W6A-07 — UC-59 (Media):** agregó selección y despliegue de detalle de Promoción y alternativas de selección sin permiso o sin intentos.
- **W6A-08 — UC-60 (Reserva):** comportamiento consistente con fichas; la conversión exacta estado origen→destino no se atribuye al esquema solo por existir un estado.

## 3. Controles de los XML y contratos después del cotejo

- **9/9 operaciones** mantienen mismos nombres, orden, parámetros y opcionalidad en DSS/DS/contratos, considerando el escape XML `&lt;`/ `&gt;` para `List<Long>`.
- **9/9 contratos** conservan los nueve apartados declarativos.
- **2 + 9 = 11 páginas** en XML propuestos; identificadores `mxCell` únicos en cada página.
- Se revisaron 11 anchos/altos declarados de página y coordenadas de geometrías y extremos de flechas; **no se detectaron puntos ni rectángulos fuera de los límites declarados**.
- No se observaron ampersands inválidos ni desequilibrio elemental de etiquetas en comprobación textual.
- En DS UC-19 se separan objetos `nuevoPrecio : PrecioProducto` y `evAud : AuditoriaPrecio`; en UC-24 las instancias de `Promocion`, `PromocionProducto`, `DestinatarioPromocion`, `IntentoComunicacion` y servicio externo no se agrupan en una lifeline compuesta.

**Importante:** estos son **controles de contenido/estructura/geometría**, NO renderizado auténtico en Draw.io ni comprobación visual de solapamientos de texto, legibilidad, edición y round-trip. No se ejecutó parser XML externo desde un archivo descargado ni prueba de aplicación.

## 4. Reglas de gobierno para la integración en documento principal

1. **No fusionar PR #15 ni modificar el documento principal** únicamente por resultado estático.
2. Antes de integrar, abrir el DSS de dos páginas y DS de nueve páginas en **app.diagrams.net**; verificar que los 11 diagramas se visualicen completos, se lean, no oculten etiquetas ni confundan alternativas de flujo. Guardar, cerrar, reabrir y comparar.
3. Revisar las zonas especialmente sensibles: UC-19 validación antes de cierre de vigencia y lifelines separadas, UC-24 creación de asociaciones y bucle de intentos de comunicación, UC-30/47/48 distribución de responsabilidades, UC-59 consulta del detalle, UC-60 transición no reactivable.
4. Mantener los archivos de XML editables como **anexos técnicos versionados**, y los nueve contratos como anexo declarativo; incorporar al documento maestro de 64 CU por **referencia o anexo expresamente aprobado**, no sobreescribir las fichas canónicas ni insertar XML como si fueran gráficos renderizados.
5. Fuentes y decisiones posteriores aprobadas conservan precedencia; cualquier diferencia en el Word maestro debe quedar como adenda con aprobación, no como edición silenciosa.

## 5. Dictamen

**Cotejo funcional de los nueve CU contra Alto Nivel, Extendido y Real: completado con correcciones; QA estático posterior: conforme.** 

**Aprobación de los diagramas para integración académica: condicionada**, porque no se ha ejecutado inspección visual y guardado/reapertura en Draw.io, ni cotejo con diagrama de clases y visibilidad Larman mensaje por mensaje. **El documento principal no ha sido modificado.** La PR continúa **Draft** como preintegración documentada.
