# MR-2 — Resolución técnica de los 53 hallazgos de MR-1

**Proyecto:** Sistema de Gestión para Ale Milanesas  
**Corte:** 25/10/2026  
**Naturaleza:** acuerdos de diseño para MR-3; **NO** se ejecutó ni cambió el modelo físico.

## Línea base y regla de autoridad

- Se preservan las **59 tablas, 444 columnas y 120 FK** del 23/10 como esquema base. Son conteos históricos, no estado de implementación de MR-2.
- Se aprobaron 15 CU adicionales (UC-50..64), PRA-01 y las decisiones A/B/C; no se extrapolan automáticamente tablas nuevas.
- Reglas decididas explícitamente por el usuario tienen precedencia sobre propuestas y el DDL preliminar. No se asignan pesos, plazos, estados literales ni cuentas por suposición.
- El responsable del reintento de Reembolso permanece reservado al usuario, sin alteraciones por este trabajo.

## Resultado de cierre

| Dictamen | Hallazgos | Significado |
|---|---:|---|
| `APROBADO_CONTROL` | 26 | Control transaccional, trigger o autorización aprobado |
| `APROBADO_DDL` | 8 | Alteración declarativa aprobada para diseñar/implementar |
| `PENDIENTE_FUNCIONAL` | 7 | No se adoptan datos/estados/reglas ausentes de la fuente |
| `SIN_CAMBIO_FISICO` | 5 | No se justifica nueva estructura |
| `APROBADO_INDICE_CONDICIONAL` | 3 | Índice supeditado a evidencia del plan de ejecución |
| `VERIFICACION_PREVIA` | 2 | Requiere contraste adicional antes de decidir estructura |
| `RESERVADO_USUARIO` | 1 | Modificación a cargo del usuario |
| `VERIFICACION_MR4` | 1 | Pruebas pendientes para MR-4 |

**Total evaluado:** 53 hallazgos. **Pendientes no automáticos:** 10 (incluye una tarea reservada al usuario).

## Resoluciones físicas autorizadas para diseño de MR-3

1. **`MOVIMIENTO_INSUMO.tipoMovimiento`:** agregar `SALDO_INICIAL` al CHECK. El costo histórico debe registrarse y enlazarse usando la FK compuesta existente `(idInsumo, vigenteDesdeCosto)`; no se crea una `RECEPCION_COMPRA` ficticia. El stock inicial es cargado en UC-42, no en UC-50.
2. **`INSUMO`**: implementar unicidad del nombre normalizado sin nuevo atributo físico. Normalización mínima determinista: eliminación de espacios externos, consolidación de espacios interiores y minúsculas; no se asume unicidad sin tildes hasta una definición adicional. Verificar duplicados preexistentes antes de aplicar UNIQUE.
3. **`CLIENTE`**: unicidad de nombre completo normalizado + teléfono normalizado; dos personas pueden compartir número. No convertir la regla en UNIQUE(telefonoPrincipal).
4. **Vigencias exclusivas:** restricciones GiST `EXCLUDE` sobre `VERSION_RECETA`, `PRECIO_PRODUCTO`, `POLITICA_CATEGORIA_COMERCIAL` y `POLITICA_COMPRA` con intervalos semiabiertos. `PRECIO_PRODUCTO` excluye las versiones canceladas antes de su inicio. No crear constraints duplicadas por MR1-19/36/49.
5. **Restricciones ya existentes que se reutilizan:** UNIQUE parcial de Asignación de Reparto vigente, Episodio abierto, Solicitud AUTOMATICA por Episodio, Solicitud inicial por Episodio, claves idempotentes de Cobros/Intentos, respuesta única por Solicitud/Proveedor y FK de costo histórico.
6. **Controles entre tablas:** adopción de transacciones con bloqueos y validadores (constraint triggers diferidos cuando sea necesario) para Roles, último Administrador, único Proveedor habilitado, Entregas concurrentes, conservación de Excedentes, Cobro→Cuenta→Caja, Reembolso PROCESADO exactamente una vez, recepciones parciales, decisiones de Compra y episodios PRA-01.
7. **Índices de rendimiento:** se prioriza reutilizar PK/UNIQUE. Crear índices adicionales solo tras justificar con planes `EXPLAIN ANALYZE` y cardinalidades reales. No duplicar uno ya existente.

## Aspectos expresamente no inventados

- **RP-012:** fechaHoraVencimiento queda congelada por Solicitud, sin derivarse de `periodoCalculoDias`. El origen concreto del plazo (episodio o parámetro operativo general) continúa pendiente.
- **RP-013:** se ratifica la sumatoria ponderada configurable y `ordenDesempate`. No están definidos aún escala/normalización, manejo de datos faltantes ni precisión del cálculo.
- **PROMOCION.estado:** UC-60 permite desactivar; sin catálogo literal aprobado no se fija aún CHECK de valores.
- **Offline:** manejo de actualización de precio, categoría o Cliente entre carga y sincronización sigue pendiente; no se presume offline para UC-43.
- **Anulaciones/contra-asientos:** B6 no define operación completa; no introducir columnas, tipos ni tablas de reversión.
- **Producto/Proveedor inactivo:** conservar historial, impedir nuevas operaciones no elegibles, no cancelar Orden/Pedido automáticamente; tratamiento de operaciones abiertas sigue pendiente.
- **Responsable del reintento:** queda explícitamente a cargo del usuario.

## Pendientes focalizados para MR-3 / política de negocio

| Hallazgo | Clasificación | Condición que impide cerrarlo automáticamente |
|---|---|---|
| MR1-14 | `PENDIENTE_FUNCIONAL` | Mantener idOperacionOrigen UNIQUE y diseño de sincronización idempotente; no aprobar reglas de precio/categoría offline ni revalidación final hasta decidir política de conflictos. UC-43 sigue sin operación offline presumida. |
| MR1-18 | `PENDIENTE_FUNCIONAL` | No crear estado CONGELADO; mantener Pedidos PENDIENTE sin cancelación automática, pero el procedimiento cuando Producto fue inactivado con preparación en curso requiere decisión del negocio. |
| MR1-26 | `VERIFICACION_PREVIA` | UC-54: documentar quién y cuándo solicita el restablecimiento en registro de seguridad ya disponible, si existe y está autorizado; si se exige historial estructurado persistente que el modelo no soporta, elevar una modificación separada. |
| MR1-31 | `RESERVADO_USUARIO` | No modificar INTENTO_REEMBOLSO: el usuario incorporará la trazabilidad del Administrador responsable del reintento. MR-3 debe integrar posteriormente su cambio manteniendo histórico. |
| MR1-33 | `PENDIENTE_FUNCIONAL` | Contra-asientos y anulaciones de Cobros/MovimientosCaja no están aprobados. No introducir nuevos tipos de movimiento, FK o tabla hasta cerrar B6. |
| MR1-34 | `VERIFICACION_PREVIA` | Verificar que RF-12 y movimientos históricos permitan calcular antigüedad de deuda después de imputaciones de pagos. No agregar fecha de vencimiento o FK sin determinar origen semántico. |
| MR1-37 | `PENDIENTE_FUNCIONAL` | Mantener PROMOCION.estado como texto controlado por lógica de UC-59/60 hasta aprobar literales permitidos y transiciones; no inventar ACTIVA/CANCELADA como CHECK definitivo. |
| MR1-40 | `PENDIENTE_FUNCIONAL` | RP-013: suma ponderada aprobada; quedan por definir escalas/normalización, datos faltantes, precisión y orden de desempate. No hardcodear pesos ni SQL de puntuación final. |
| MR1-41 | `PENDIENTE_FUNCIONAL` | RP-012: vencimiento pertenece a PRA-01 y se congela en fechaHoraVencimiento, independiente de periodoCalculoDias. Queda sin decidir si se deriva del episodio o de un parámetro operacional general. No fijar 48h. |
| MR1-48 | `PENDIENTE_FUNCIONAL` | Mantener historial de OC y Cotizaciones de Proveedor inactivo; prohibir nuevas invitaciones/respuestas. El destino de Órdenes abiertas debe ser decidido antes de cambios automáticos; no cancelar de oficio. |

## Inventario de decisiones por hallazgo

La matriz CSV adjunta es el registro exhaustivo de las **53** decisiones; cada fila conserva prioridad, tabla, columna, dictamen, acción precisa, CU relacionados y prueba de aceptación.

## Plan de implementación MR-3

1. Preflight: cargar esquema en entorno desechable, detectar nombres repetidos, vigencias solapadas, movimientos/roles inconsistentes y claves idempotentes duplicadas; no crear cambios destructivos automáticamente.
2. Diseño DDL: incluir nuevas CHECK, UNIQUE y EXCLUDE aprobadas en un script **NO EJECUTADO**, y documentar su impacto en diccionario y esquema maestro.
3. Integridad transaccional: añadir rutinas SQL/servicio con bloqueos correctos, criterios de cierre y pruebas de fallo atómico; no declarar garantizada una regla mientras solo esté escrita como comentario.
4. Actualizar matriz CU→Tablas, RD/RP, documentación de reglas transversales y DDL; no intervenir el diagrama UML de casos de uso.
5. MR-4: validación real PostgreSQL con pruebas de concurrencia, rollback, ausencia de duplicados, invariantes de saldos y vigencias.

## Control de cambios

- **No se modificaron** los 59 `CREATE TABLE` de origen, el esquema maestro, el diccionario, el archivo SQL, el diagrama relacional ni el diagrama UML.
- La línea base 59/444/120 solo cambiará si un delta físico se aprueba y se incorpora. No se atribuyen nuevas FK a MR-2.
- No se ha ejecutado SQL ni certificado integridad física en PostgreSQL.
