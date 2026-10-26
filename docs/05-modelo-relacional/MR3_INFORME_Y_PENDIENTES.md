# Ale Milanesas — MR-3: implementación documental y DDL propuesto

**Fecha de corte:** 25/10/2026. **Estado:** preparado, NO EJECUTADO en PostgreSQL. No se sobrescribió ningún documento, XML, esquema o DDL anterior.

## 1. Resultado físico

| Indicador | Base 23/10 | Diseño MR-3 | Delta |
|---|---:|---:|---:|
| Tablas | 59 | 60 | +1 |
| Columnas físicas | 444 | 453 | +9 |
| FK | 120 | 125 | +5 |

La nueva tabla `CONFIGURACION_OPERATIVA` es una excepción justificada a la conservación de 59 tablas: la duración de respuesta es un **parámetro de ejecución**, independiente de `POLITICA_COMPRA` y sus métricas. Contiene una clave parametrizable `PLAZO_RESPUESTA_COTIZACION_HORAS`, valor entero positivo, autor y fecha; **no se precarga un número**. Las configuraciones anteriores deben preservarse en logs de despliegue; este registro conserva solo el valor vigente.

Las nueve columnas nuevas son: 4 de `CONFIGURACION_OPERATIVA`, 2 de `EPISODIO_FALTANTE`, una `idCobroAnulado` en `ORIGEN_MOVIMIENTO_CUENTA`, otra homónima en `MOVIMIENTO_CAJA`, y `INTENTO_REEMBOLSO.idUsuarioReintento`.

## 2. Decisiones aplicadas en el SQL

1. `MOVIMIENTO_INSUMO`: `SALDO_INICIAL`, una apertura física por Insumo, origen específico, sin `RECEPCION_COMPRA` ficticia. El registro de costo previo puede usar `COSTO_INSUMO_HISTORICO.fuenteCosto = 'SALDO_INICIAL'`.
2. `INSUMO` y `CLIENTE`: índices únicos por representación normalizada, preservando que dos Clientes diferentes compartan teléfono.
3. `VERSION_RECETA`, `PRECIO_PRODUCTO`, `POLITICA_CATEGORIA_COMERCIAL` y `POLITICA_COMPRA`: exclusión de períodos solapados con GiST y extremos `[desde,hasta)`; `PRECIO_PRODUCTO` excluye los cancelados antes de vigencia.
4. `PROMOCION`: `BORRADOR`, `ACTIVA`, `PAUSADA`, `FINALIZADA`, `CANCELADA`; trigger de transiciones; no modifica descuentos históricos.
5. PRA-01: plazo global de Cotización explícito, copia por Episodio, posible override del Administrador antes de emitir primera Solicitud; fechaHoraVencimiento se congela por Solicitud. Ningún valor `48` se impone por defecto.
6. `RESPUESTA_COTIZACION`: admitir tiempo de entrega omitido en una oferta positiva con precio informado; `DETALLE_DECISION_CRITERIO`: ausencia de valor representada por puntaje 0. No se codifican pesos ni escalas de puntuación no acordadas.
7. `MOVIMIENTO_CUENTA` y `MOVIMIENTO_CAJA`: `ANULACION_COBRO` como reversión registrada, con **dos FK separadas** `idCobroAnulado`; Caja usa `tipoMovimiento='EGRESO'` con importe positivo para reflejar signo contable negativo. Se añade función administrativa atómica y validadores diferidos de contraparte.
8. `INTENTO_REEMBOLSO`: elijo `idUsuarioReintento` como FK a `USUARIO`, nula en el primer intento automático y obligatoria en reintentos administrativos.
9. Insertar nuevos Pedidos, Detalles, Invitaciones y Órdenes rechaza elementos inactivos; **ningún trigger cancela automáticamente operaciones preexistentes**.
10. `USUARIO.credencialProtegida`: la recuperación asistida UC-54 puede cambiar el hash con revocación de sesiones y logs de seguridad externos; no se crea historial de contraseñas.

## 3. Cuestiones técnicas aún necesarias

**Seguridad:** el procedimiento de anulación exige un Administrador habilitado. El resto de la capa de aplicación debe restringir escrituras SQL directas, registrar evidencias de auditoría y revalidar permisos en cada operación. `PAUSADA→ACTIVA` queda permitido a nivel de máquina de estados, pero **no** se conceden nuevos permisos UML ni se crea automáticamente un caso de uso de reactivación.

**No confundir autorización de Reparto con Cobro:** la regla propuesta «El Reparto Manda» es compatible con **conservar el contenido congelado de una operación offline autorizada**, pero la matriz aprobada niega al Repartidor acceso directo a UC-29. Incorporar Cobro por Repartidor exigiría revisar RBAC, autenticación offline, conciliación de efectivo e idempotencia. Ningún disparo de sincronización puede evitar la revocación de identidad, el control de duplicados, la asignación vigente ni los límites de operación. No se codifica aceptación incondicional de eventos atrasados.

**Deuda:** la fecha de origen de vencimiento es `ENTREGA.fechaHoraEntrega`, sin gracia estándar de 15 días. La distribución de pagos entre múltiples Pedidos para obtener deuda individual vencida **no está representada** por una imputación a facturas; requiere acordar método de imputación o reconocer una métrica agregada, sin inventar deuda por antigüedad.

**Puntuación:** puntaje cero representa el mínimo cuando falta un dato. `Precio Total` ascendente es último desempate cuando los criterios configurados en `ordenDesempate` no resuelven igualdad. Para convertir todos los datos a puntuaciones y ejecutar una sumatoria de unidades homogéneas falta todavía **normalización por criterio**, precisión y manejo de monedas/cantidad comparable; la base conserva datos y resultado, pero ningún algoritmo incompleto se presenta como terminado.

**Plazo:** el flujo automático se inicia de manera transaccional con la apertura del Episodio; un Administrador solo puede modificar un plazo **antes** de la primera emisión efectiva. Si el proceso emitió una Solicitud automáticamente en el mismo evento, no es posible ajustarla después sin contradecir el congelamiento. La edición manual se limita al escenario aún no emitido; las siguientes rondas usan sus propias fechas congeladas. Sin configuración válida el episodio permanece visible, pero no se crea Solicitud ficticia.

**Responsable histórico:** si ya hay filas `INTENTO_REEMBOLSO.numeroIntento>1`, el CHECK requerirá recuperar el Administrador real antes de migrar. No se rellenará el campo con un Usuario arbitrario. La opción `idUsuarioReintento` es la preferida y queda implementada **solo en los archivos SQL propuestos**, sin alterar tus archivos originales.

**Integridad restante:** procedimientos completos de roles, sesiones y último Administrador; preparación, Excedentes, stock y compras; confirmación y clasificación de Reembolsos externos con efectos exactamente una vez; publicación de rondas; asociación de Cuenta Corriente con Venta efectiva; conciliación de importes y `saldoResultante`; requieren ejecutar MR-4 y completar servicios transaccionales. El paquete contiene varias protecciones SQL nuevas, pero **no acredita todas estas invariantes**.

## 4. Archivos y modo de uso

- `...MR3_ESQUEMA_MAESTRO_ACTUALIZADO.md`: catálogo de 60 entidades con las 453 columnas y vínculos principales.
- `...MR3_DICCIONARIO_COLUMNAS_ACTUALIZADO.csv`: columnas, PK/FK y nulabilidad.
- `...MR3_DDL_CONSOLIDADO_NO_EJECUTADO.sql`: base de 59 tablas + delta completo.
- `...MR3_MIGRACION_PROPUESTA_NO_EJECUTADA.sql`: delta para una instalación existente del esquema 23/10; incluye BEGIN/COMMIT, sin borrado de datos.
- `...MR3_PRECHECK_SOLO_LECTURA.sql`: diagnóstico de duplicados, vigencias y códigos históricos que impedirían migrar.
- `...MR3_TRAZABILIDAD_DECISIONES.csv`: decisiones aprobadas, parciales y CU relacionados.
- `...MR3_CONTROL_VALIDACION.md`: estado de pruebas y lista de controles posteriores.

**Secuencia exigida:** respaldo y PRECHECK → resolver datos conflictivos con trazabilidad → ejecutar migración en entorno desechable → MR-4 con pruebas de PostgreSQL → actualización del diagrama relacional solo mediante pedido específico. No ejecutar directamente en producción.
