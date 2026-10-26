# Ale Milanesas — RP-01: Registro de Pendientes

**Corte documental:** 24/10/2026  
**Versión:** 1.1 / Fase 2.3 / Fase 1  
**Estado:** registro vivo de asuntos abiertos, diferenciado de decisiones ya aprobadas.  
**Numeración:** UC-01…UC-64 consecutivos; cualquier cita heredada se traduce al código nuevo.  

## 1. Política del registro

Un pendiente es una **decisión funcional no aprobada**, una **definición técnica todavía no materializada** o una **tarea documental sin ejecutar**. No convierte automáticamente una funcionalidad en requisito aprobado. Las reglas aprobadas quedan en RD-01; en este registro solo se conserva el trabajo residual. Los criterios `[A CONFIRMAR]` permanecen explícitos aquí y en las fichas donde su ausencia impediría interpretar el comportamiento.

**Estados operativos propuestos para seguimiento:** ABIERTO / EN REVISIÓN / RESUELTO CON ID RD / IMPLEMENTADO / VERIFICADO. Todos los ítems que siguen se inicializan **ABIERTO**. La prioridad describe riesgo de indefinición, no autorización para implementar.

## 2. Pendientes individuales

| ID | Área | Prioridad | CU / componente | Asunto | Decisión o acción requerida | Fuente | Tipo |
| --- | --- | --- | --- | --- | --- | --- | --- |
| RP-001 | Comercial/ONLINE | ALTA | UC-21 (antes UC-22) | Fecha exacta de reparto ONLINE | Definir regla de fecha aceptada para Pedido ONLINE, relación con entregas/rutas. | [A CONFIRMAR] del anexo; D §V.1 | DECISIÓN NEGOCIO |
| RP-002 | Reparto | ALTA | UC-43 (antes UC-44) | Elegibilidad detallada del Repartidor y del Pedido | Determinar inhabilitaciones adicionales, condiciones de asignación y visibilidad de recurso. | [A CONFIRMAR] del anexo; D §V.2 | DECISIÓN NEGOCIO |
| RP-003 | Offline | ALTA | UC-43 / UC-03 | Asignación offline y concurrencia | Resolver si UC-43 será necesariamente online y el alcance de operaciones offline; matriz RNF-03/04; casos de conflicto. | D §V.2; Grupo B | DECISIÓN NEGOCIO / TÉCNICA |
| RP-004 | Consultas | MEDIA | UC-27 (antes UC-28) | Margen por período o por venta individual | Acordar modalidad; si se habilita por venta individual, definir selección y su relación UML. | Profesor 21/10; D §IV | DECISIÓN NEGOCIO |
| RP-005 | Finanzas | ALTA | UC-26 (antes UC-27) | Responsable técnico del reintento | Usuario incorpora FK/registro de responsable en INTENTO_REEMBOLSO; auditar trazabilidad física. | Grupo A §3; usuario asume cambio | MATERIALIZACIÓN USUARIO |
| RP-006 | Caja/Reparto | ALTA | UC-05 / UC-29 | Rendición de efectivo del Repartidor | Aprobar procedimiento: quién recibe, cuándo confirma, conciliación, idempotencia; entrega no equivale a cobro. | Propuesta permisos 24/10; A9 | DECISIÓN NEGOCIO |
| RP-007 | Permisos | MEDIA | UC-29 / UC-33–37 / UC-40 | Ratificación de matriz Rol × CU | Propuesta de acceso directo Admin/Vendedor para Cobro y búsquedas; falta ratificar como matriz operativa y permisos sobre campos sensibles. | Matriz derivada 24/10, sin ratificación explícita | RATIFICAR / ACLARAR |
| RP-008 | Usuarios | ALTA | UC-55 / UC-43 | Último Administrador | Definir regla cuando se deshabilita la última cuenta Administrador habilitada y procedimiento de contingencia. | Grupo B / UC-19 histórico | DECISIÓN NEGOCIO |
| RP-009 | Usuarios/Reparto | ALTA | UC-55 / UC-43 | Cuenta de Repartidor con Pedidos asignados | Acordar bloqueos temporales/alertas/reasignación operativa al deshabilitar la cuenta. | Grupo B | DECISIÓN NEGOCIO |
| RP-010 | Usuarios | MEDIA | UC-53 / UC-01 | Cambio temporal vs relación UML | Definir punto de extensión o ejecución obligatoria de cambio de clave inicial sin otorgar acceso operativo; no dibujar extend automáticamente. | Grupo B | ANÁLISIS UML |
| RP-011 | Autenticación | MEDIA | UC-54 | Política interna de recuperación | Solo PROVEEDOR aprobado; definir expansión posterior para internos y política de seguridad. | Grupo B / RF-08 | EVOLUCIÓN FUTURA |
| RP-012 | Reposición | ALTA | PRA-01 / UC-44 / UC-58 | Fuente operativa del plazo de respuesta | Se aprobó separar plazo de respuesta de POLITICA_COMPRA.periodoCalculoDias y congelar fechaHoraVencimiento por Solicitud. Falta elegir origen concreto: regla dinámica al abrir episodio o parámetro independiente del sistema; definir alcance de cambios y aplicación en rondas posteriores. 48 h NO aprobado. | Usuario 25/10 / RD-019 | DECISIÓN NEGOCIO AÚN ABIERTA |
| RP-013 | Compras | MEDIA | UC-58 / UC-12 / PRA-01 | Algoritmo comparativo y desempates | Aprobada comparación ponderada con pesoRelativo y ordenDesempate configurados en UC-58; rechazados pesos 40/25/25/10. Falta definir escala y normalización de precio, plazo, cumplimiento y criterios, tratamiento de datos faltantes, desempate final y precisión; negocio define carga inicial. | Usuario 25/10 / RD-020 | ESPECIFICACIÓN TÉCNICA ABIERTA |
| RP-014 | Recepción | MEDIA | UC-08 / PRA-01 | Reconciliación stock y cierre de episodio | Definir manejo transaccional de recepción y cierre; umbral recuperado + ausencia de solicitudes/órdenes pendientes, no solo recibir OC. | B; MR-35–47 | IMPLEMENTACIÓN / PRUEBAS |
| RP-015 | Insumos | ALTA | UC-42 / UC-50 | SALDO_INICIAL en modelo físico | Modificar validación tipo MOVIMIENTO_INSUMO y precisar costo/valuación inicial, transacción y procedencia; decisión funcional ya aprobada. | Grupo B / Esquema 59 | MATERIALIZACIÓN ESQUEMA |
| RP-016 | Insumos | MEDIA | UC-50 | Stock y parámetros iniciales | Alta maestro: stockActual=0 con parámetros válidos; definir qué significa sin valoración al momento del alta y políticas numéricas permitidas. | B diseño / Grupo B | ESPECIFICACIÓN |
| RP-017 | Insumos | MEDIA | UC-51 | Unidad de Medida con historial | Determinar datos permitidos y bloqueo de unidad con historia; criterio consistente con Producto. | Grupo B | ESPECIFICACIÓN |
| RP-018 | Precios | ALTA | UC-19 (antes UC-20) | Primer Precio y estado físico | Resolver configuración inicial, solapamiento y enumeración final de estado sin retroactividad. | D §V.6; Grupo B | ESPECIFICACIÓN / ESQUEMA |
| RP-019 | Pedidos | MEDIA | UC-03 / UC-21 | Fecha de reparto de Pedidos internos | Definir validaciones sin inventar días/horizontes no aprobados. | A20; D | DECISIÓN NEGOCIO |
| RP-020 | Pedidos | MEDIA | UC-43 / UC-25 | Reprogramación de fecha de reparto | Política sobre modificación exclusiva de fecha en Pedido PENDIENTE y efectos en rutas/asignaciones. | Grupo B | DECISIÓN NEGOCIO |
| RP-021 | Pedidos | MEDIA | UC-03 / UC-21 / UC-05 | totalVigente conceptual vs persistencia | Verificar referencia en flujos; derivarlo de totalOriginal e incrementos si no se ratifica columna. | Grupo B / Esquema 59 | ANÁLISIS FÍSICO |
| RP-022 | Inventario | MEDIA | UC-08 / UC-42 | Costeo y conversiones | Precisar fuentes de costo de Insumos, REVENTA promedio móvil, redondeos/Unidades de Medida y condiciones de apertura. | D §V.6 | DECISIÓN NEGOCIO / TÉCNICA |
| RP-023 | Comercial | MEDIA | UC-24 / UC-59 / UC-60 | Promociones simultáneas y elegibilidad | Cerrar combinaciones, vigencias, destinatarios, uso y notificación sin alterar pedidos históricos. | D §V.6; Grupo B | DECISIÓN NEGOCIO |
| RP-024 | Comercial | BAJA | UC-24 / UC-59 | Reintento de comunicaciones fallidas | Baja prioridad; trazabilidad de intentos existente, funcionalidad explícita fuera del catálogo UC-50–64. | Grupo B | EVOLUCIÓN FUTURA |
| RP-025 | Clientes/ONLINE | MEDIA | UC-21 / UC-32 | Teléfono compartido / identificación alternativa | Regla vigente: bloquear login ambiguo. Alternativa adicional o unicidad obligatoria requeriría decisión nueva; no inventarla. | B; Grupo A | EVOLUCIÓN FUTURA |
| RP-026 | Clientes/Estados | MEDIA | UC-38 / UC-46 / UC-48 | Bajas lógicas y operaciones en curso | Definir órdenes abiertas y cuentas de Proveedor INACTIVO; revisión manual de Pedidos con Producto INACTIVO sin estado nuevo. | Grupo A24 | DECISIÓN NEGOCIO |
| RP-027 | Finanzas | MEDIA | UC-22 / UC-29 | Contra-asientos auditables | Definir operación de corrección/anulación para Cobro manual y MovimientoCaja, sin borrar movimiento previo. | Grupo B | DECISIÓN NEGOCIO |
| RP-028 | Finanzas | MEDIA | UC-23 / UC-27 | Diferenciar Libro Diario vs utilidad y saldos | Afinar alcance consulta de movimientos monetarios y no confundirlo con margen de venta. | Profesor 21/10; D §IV | ESPECIFICACIÓN |
| RP-029 | Integraciones | ALTA | UC-21 / UC-49 | Notificación e idempotencia | Confirmar implementación de OTP, webhook MercadoPago y respuestas externas con autenticación, correlación, retries y efectos exactly-once. | D §V.5 / A7 | IMPLEMENTACIÓN / PRUEBAS |
| RP-030 | Modelo relacional | ALTA | MR-01…MR-64 | DDL referencial sin ejecutar | Ejecutar validaciones de PostgreSQL y triggers de roles, inmutabilidad, transferencias, ACID, FKs temporales y concurrencia. | D §V.5 / Esquema 59 | IMPLEMENTACIÓN / PRUEBAS |
| RP-031 | UML | MEDIA | 49 existentes + 15 nuevos | Revisión de relaciones «include»/«extend» | La matriz base tiene 29 relaciones; relaciones nuevas requieren justificación y aprobación caso por caso. | D §III / Grupo B | ANÁLISIS UML |
| RP-032 | Documentación | ALTA | 147 fichas 23/10 | Contaminación editorial y errores formales | Retirar metatexto según inventario; corregir excepciones, títulos, campos y niveles en fases 3/4, sin retirar reglas vigentes. | Grupo C | PROPAGACIÓN DOCUMENTAL |
| RP-033 | Trazabilidad | MEDIA | A/B/C/D / objetivos | Prefijos y redacción de objetivos | Unificar citas al catálogo; diferenciar OBJ de OBJE y RF/RNF/IRQ. No reinterpretar sin comparar la definición. | Grupo C13 | PROPAGACIÓN DOCUMENTAL |
| RP-034 | PRA-01 | MEDIA | UC-08/12/13/28/31/39/42/44 | Trazabilidad e implementación por eventos | Instrumentar el mecanismo de eventos y su transaccionalidad; PRA-01 es especificación funcional, no CU nuevo. | Grupo B | IMPLEMENTACIÓN / PRUEBAS |

## 3. Extracción del metatexto desde las 147 fichas

Se recorrió C_ANEXO de 23/10 buscando marcadores explícitos de duda, comentarios incrustados, referencias de decisiones antiguas, frases de plantilla y artefactos de Markdown. Se preservan la **línea original**, el **CU original**, el **CU consecutivo**, el **nivel** y un fragmento de evidencia en `Fase1_Inventario_MetaTexto_49CU_24-10-2026.csv`.

| Indicador | Casos |
| --- | --- |
| CALIDAD_LENGUAJE | 44 |
| ETIQUETA_REGLAS | 1 |
| NOTA_EDITORIAL_EN_CAMPO | 20 |
| PENDIENTE_EXPLICITO | 8 |
| PLANTILLA_GENERICA | 19 |
| POSTCONDICION_CONTAMINADA | 19 |
| REFERENCIA_DECISION | 10 |
| TEXTO_DE_MARCADOR | 11 |

**Total de evidencias:** 132 en **87 de 147** secciones analizadas. Estos son marcadores detectados para revisión, no una validación semántica automática de todos los defectos.

## 4. Método de depuración que se aplicará en Fases 3 y 4

1. **Postcondición con nota:** conservar solo el estado verificable. Mover el resto a RD-01 si está aprobado o a RP-01 si aún depende de negocio.
2. **Comentario con fórmula:** trasladar a Reglas de cálculo o Reglas de negocio, manteniendo el cálculo literalmente hasta aprobar una versión nueva.
3. **Comentario con pregunta/sugerencia:** copiar al RP con procedencia y retirar de ficha final; no dejar una regla ficticia en Comentarios.
4. **Fragmento histórico contradictorio:** guardar referencia, aplicar la decisión posterior aprobada y registrar qué se sustituyó.
5. **Excepción que cita un paso de otro nivel:** mapear a los pasos reales del propio nivel; no eliminar condición ni forzar índices inválidos.
6. **Texto genérico:** redactar objetivo, intención y propósito específicos; no crear nuevos atributos o disparadores.
7. **Nombres físicos:** respetar `stockActual`, `nivelObjetivoReposicion`, `PENDIENTE`, `SIN_RESPUESTAS`, etc.

## 5. Elementos que NO son pendientes funcionales

- El reintento manual del Reembolso rechazado fue aprobado en A8; solo quedan su propagación y la columna de responsable a implementar por el usuario (RP-005).
- UC-50…UC-64 están aprobados para redacción, no son propuestas no resueltas.
- PRA-01 fue aprobado como proceso transversal, no como CU nuevo.
- El antiguo hueco UC-14 quedó eliminado; no debe mantenerse en índices futuros.
- La respuesta tardía a cotizaciones se rechaza: no reabrir la norma antigua de registrarla.
- Una OrdenCompra no se emite automáticamente.

## 6. Referencias de control

Ver RD-01, PRA-01, C_ANEXO del 23/10, D del 23/10, Grupo A consolidado 24/10, aprobaciones B/C del 24/10 y Esquema Maestro 59 tablas. Los pendientes referidos al modelo físico deben contrastarse con el DDL y las restricciones antes de darlos por cerrados.

## Actualización de seguimiento — Fase 2.3 (25/10/2026)

Las fichas UC-59 a UC-64 se redactaron sin crear entidades físicas nuevas. Para su incorporación al maestro se deberán verificar y, cuando corresponda, resolver: (a) catálogo literal de PROMOCION.estado y representación de desactivación, sin afectar DetallePedido; (b) campos de costo autorizados por rol en UC-64 y UC-61; (c) disponibilidad y visibilidad histórica de las invitaciones del PROVEEDOR INACTIVO sin habilitar respuestas; (d) ningún estado almacenado EXCEDENTE.estado fue supuesto: disponibilidad se deriva de cantidadDisponible. Los asuntos (a)-(c) se incluyen en los pendientes de permisos, modelos y políticas ya existentes; no se presentan como aprobaciones nuevas.
