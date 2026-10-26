# Ale Milanesas — RD-01: Registro de Decisiones

**Corte documental:** 24/10/2026  
**Versión:** 1.1 / actualización de Fase 2.3 (25/10/2026)  
**Estado:** consolidación de decisiones aprobadas; no sustituye las fichas maestras.  
**Convención de CU:** UC-01…UC-49 consecutivos, con 15 CU adicionales UC-50…UC-64 aprobados para redacción.  

## 1. Propósito, autoridad y control

El Registro de Decisiones (RD) conserva reglas funcionales y de integridad **expresamente aprobadas** y separa su origen histórico de la redacción limpia de las fichas. Una decisión puede estar **APROBADA / POR PROPAGAR**, aunque todavía no figure en el Word maestro o en el DDL. No confundir aprobación con implementación física. Los asuntos sin definición se derivan al RP-01.

**Orden de autoridad utilizado:** decisiones explícitas de los Grupos A (24/10), B (24/10) y C (24/10); A/B/C/D y Matriz UML del 23/10 como línea base histórica; Esquema Maestro Relacional 59 tablas para verificar atributos, restricciones y límites. En conflicto entre ficha heredada y decisión posterior aprobada, prevalece la decisión posterior, sin borrar la evidencia histórica.

**Regla de mapeo:** UC-01…UC-13 sin cambio; antiguo UC-15…UC-50 → nuevo UC-14…UC-49. El antiguo UC-14 quedó excluido del catálogo; en la nueva convención el identificador UC-14 corresponde a **Consultar Cuenta Corriente**.

## 2. Decisiones rectoras
| ID | Tema | Decisión / restricción | Procedencia | Estado |
| --- | --- | --- | --- | --- |
| RD-001 | Numeración y catálogo | 64 CU consecutivos: 49 existentes renumerados más UC-50 a UC-64 nuevos aprobados; no mantener hueco UC-14. | A/B aprobados 24/10 | APROBADA / PROPAGAR |
| RD-002 | Modelado UML | Mantener 27 «include» y 2 «extend» en la matriz heredada; no crear asociaciones nuevas sin demostrar obligatoriedad/condicionalidad en los flujos. Sistema no es actor externo de sí mismo. | D-23/10 / Grupo A | APROBADA / PROPAGAR |
| RD-003 | Estados e historia | No eliminar ni alterar operaciones históricas como forma de cambio de estado; preservar decisiones, costos, movimientos, invitaciones y recepciones. | B-23/10 / A24 | APROBADA / PROPAGAR |
| RD-004 | Cobros y Reembolsos | Efectos coordinados Caja/Cuenta Corriente, idempotentes. REEMBOLSO único por Cobro, completo; solo PROCESADO materializa efecto monetario una vez, incluidos resultados tardíos. No equivale a contabilidad general por partida doble. | B-23/10 / A7/A8 | APROBADA / PROPAGAR |
| RD-005 | Reintento administrativo de Reembolso | UC-26 incluye modo secundario exclusivo Administrador para RECHAZADO y mismo idReembolso; nuevo INTENTO_REEMBOLSO, numeroIntento y claveIdempotencia; preservar intentos anteriores y verificar concurrencia. Responsable en esquema: lo incorporará el usuario. | A8, 24/10 | APROBADA / PROPAGAR |
| RD-006 | Roles | RBAC, mínimo privilegio, PROVEEDOR exclusivo; Cliente ONLINE no es Usuario con Rol CLIENTE. Consulta directa no hereda modificación ni acceso a datos ajenos. | A25, RF-08 / B-23/10 | APROBADA / PROPAGAR |
| RD-007 | Precio, venta y margen | Precios, promociones y ajustes se congelan; venta devengada original + adicionales aceptados; no sustituir por dinero cobrado ni por movimientos de Caja. | A2/A14 / B-23/10 | APROBADA / PROPAGAR |
| RD-008 | Abastecimiento | No generar OrdenCompra sin decisión expresa del Administrador; 1 sola primera ronda AUTOMATICA por episodio; rondas posteriores MANUALES; respuestas fuera del plazo rechazadas. | B-23/10 / Grupo B | APROBADA / PRA-01 |
| RD-009 | Insumos y apertura | UC-50 registra maestro, umbral, nivel objetivo y automatización; UC-42 registra apertura física y costo con tipo de MovimientoInsumo SALDO_INICIAL, sin compra o Caja ficticias. Se requiere ajustar restricción física para aceptar ese tipo. | Grupo B 24/10 | APROBADA / MODELO PENDIENTE |
| RD-010 | Nuevos CU | UC-50–64: 3 Insumos; 4 cuentas; 2 políticas; 2 Promociones; 3 búsquedas; 1 movimientos de inventario. No crear CU adicional de reembolso, 2 automáticos ni reintento de Comunicación en este lote. | Grupo B 24/10 | APROBADA / REDACTAR |
| RD-011 | Contraseñas | Recuperación asistida inicialmente solo PROVEEDOR; diseño ampliable. Cambio temporal obligatorio. Revocación de sesiones al deshabilitar; políticas internas fuera de alcance actual. | Grupo B 24/10 / RF-08 | APROBADA / REDACTAR |
| RD-012 | Modificación de Pedido | No permitir modificación general del Pedido confirmado. Mantener UC-07 incremento comercial, cancelación y nueva carga; reprogramación aislada de fecha sigue pendiente. | Grupo B 24/10 | APROBADA / PROPAGAR |
| RD-013 | Promociones | Crear Consultar Promociones y Desactivar Promoción; no modificar registros utilizados: desactivar y crear nueva. Reintento envío sigue fuera del lote inicial. | Grupo B 24/10 | APROBADA / REDACTAR |
| RD-014 | Offline | Matriz de operaciones, información congelada y conflictos; no crear CU Sincronizar. UC-43 asignación offline sigue no confirmada. | Grupo B 24/10 | APROBADA / ANALIZAR |
| RD-015 | Proceso PRA-01 | Un proceso rector único guiado por eventos centraliza detección, episodios, emisión, cierre y trazabilidad RF-05/RF-11. No añadir un CU automático. | Grupo B 24/10 | APROBADA / DOCUMENTADO |
| RD-016 | Formato y calidad | Los 3 niveles se especifican con tablas propias: Alto 2, Extendido 3, Real 4 columnas. Excepciones de Real mapeadas a pasos reales; postcondiciones verificables; metatexto fuera de fichas. | Grupo C 24/10 | APROBADA / PROPAGAR |
| RD-017 | Esquema físico | El esquema heredado tiene 59 tablas, 444 atributos y 120 FK. Decisiones de nuevos CU no autorizan mutaciones silenciosas; cada cambio físico se valida por separado. | D-23/10 / Grupo B | APROBADA / PENDIENTES |
| RD-018 | Permisos de Cobro y búsqueda | El usuario propuso Admin/Vendedor para UC-29 manual y consultas directas mixtas para UC-33/34/35/36/37/40; matriz derivada disponible. Mantener el carácter de propuesta evaluada hasta ratificación formal expresa. | Propuesta usuario 24/10 | PROPUESTA EVALUADA / NO RATIFICADA |

| RD-019 | Plazo de respuesta de cotizaciones | La fechaHoraVencimiento de cada SOLICITUD_COTIZACION se determina por una regla operativa gestionada en PRA-01 y se congela al emitir; no procede de POLITICA_COMPRA.periodoCalculoDias. La fuente operativa concreta (al iniciar episodio o parámetro general independiente) sigue sin ratificación y se documenta en RP-012. No se adopta 48 h como valor predeterminado. | Usuario 25/10/2026 / Fase 2.2, RP-012 | PRINCIPIO APROBADO / ORIGEN POR DEFINIR |
| RD-020 | Evaluación ponderada de Proveedores | Rechazados los pesos fijos ilustrativos 40/25/25/10. Los pesos pesoRelativo y la prioridad ordenDesempate se configuran mediante UC-58 y se aplican en la evaluación comparativa ponderada; no hardcodear valores iniciales. La normalización/escala de cada criterio y el desempate operativo definitivo siguen para especificación técnica; RP-013. | Usuario 25/10/2026 / Fase 2.2, RP-013 | PRINCIPIO APROBADO / DETALLE ABIERTO |
| RD-021 | Fase 2.3: Consultas y desactivación | UC-59 y UC-60: consultas y desactivación lógica de Promociones; preservar descuentos congelados, Productos, destinatarios y comunicaciones históricas. UC-61 y UC-62: búsquedas de solo lectura; revalidación de concurrencia en CU que efectúan cambios. UC-63: portal visible solo para invitaciones históricas del Proveedor autenticado; UC-13 valida nueva respuesta. UC-64: historia separada de movimientos Insumos/REVENTA. | Grupo B aprobado / Fase 2.3 | APROBADA / FICHAS REDACTADAS |

## 3. Decisiones aprobadas del Grupo A — A1 a A26

Se conserva el texto funcional de la aprobación, indicando en los ítems los códigos antiguos y sus equivalencias cuando aparecen. Las fichas futuras usarán solo los códigos nuevos.

**A1.** UC-16→15, UC-05 y UC-27→26: reevaluación de Categoría al existir un movimiento confirmado de Cuenta Corriente, no antes. Reconocer invocadores UC-17→16 y UC-30→29. Respetar UC-05 «include» UC-16 antiguo. No inventar «include» universal desde UC-27 porque la confirmación de Reembolso es condicional.

**A2.** UC-28→27: ingresos por venta efectiva = tramo original efectivamente entregado valorado con condiciones congeladas + tramo adicional efectivamente entregado valorado según importe aceptado UC-07. Conciliar con cargo real de UC-05; excluir dinero cobrado y movimientos de Caja como sustitutos del ingreso devengado.

**A3.** UC-02, UC-33→32 y UC-39→38: no duplicar Cliente inactivo; derivar reactivación al Administrador mediante UC-39; Vendedor no cambia estado.

**A4.** UC-33→32, UC-34→33 y UC-22→21: buscar Cliente explícitamente, unificar actor Vendedor, verificar duplicidad normalizada de nombre + teléfono, no duplicar propio registro; cambio de teléfono invalida desafíos OTP pendientes del número anterior. Sesiones ONLINE activas NO se revocan automáticamente sin otra aprobación.

**A5.** UC-01: usuarios internos y usuarios de Proveedor; excluir Clientes ONLINE de ese caso. Unificar objetivos/requisitos e indicar OBJE-03 / RF-08; retirar OBJ-01 como objetivo específico del CU.

**A6.** UC-27→26: Sistema como iniciador automático textual, Administrador como iniciador secundario solo de reintentos. No dibujar Sistema como actor externo de sí mismo. UC-30→29: Usuario interno para Cobro manual; MercadoPago como proveedor externo de confirmaciones electrónicas.

**A7.** UC-50→49: al confirmar tardíamente PROCESADO, aplicar efectos monetarios una sola vez, reevaluar categoría con UC-16→15 y comunicar resultado al Cliente por el canal validado. Compartir reglas con UC-27→26, sin crear «include» UC-27↔UC-50.

**A8.** UC-27→26: incorporar **modo de inicio secundario** de reintento manual exclusivo Administrador. Solo para REEMBOLSO RECHAZADO, siempre que no exista operación externa en curso ni estado PROCESADO. Mantener idReembolso, registrar nuevo INTENTO_REEMBOLSO con numeroIntento distinto y clave idempotente propia, validar concurrencia, y volver a la solicitud externa. No crear Reembolso lógico nuevo. Registrar responsable y fecha del reintento sujeto a la brecha física señalada en §3.

**A9.** UC-06 y UC-27→26: relación aprobada «extend» bajo condición Cobro electrónico reembolsable. Cobros manuales/anticipos no generan devolución de Caja automática al cancelar; permanecerán como crédito/saldo a favor conforme a movimientos ya registrados, sin crear asientos ficticios.

**A10.** UC-04: mostrar solo Pedidos PENDIENTE asignados actualmente al Repartidor; identificar Cliente, fecha, dirección, Productos, cantidades originales y adiciones aceptadas; quitar nota obsoleta de Postcondición.

**A11.** UC-44→43: fusionar pasos de búsqueda duplicados; unificar Pedido PENDIENTE asignable/reasignable, separar RF ejecutado de RF solo relacionado, mantener elegibilidad adicional del Repartidor y offline `[A CONFIRMAR]`; concurrencia e idempotencia obligatorias.

**A12.** UC-22→21 Real: OTP completo y validado antes de selección comercial y pago; restaurar elección de Productos/cantidades, condiciones comerciales, confirmación y pago. Mantener fecha de reparto `[A CONFIRMAR]`.

**A13.** UC-22→21 / UC-02 / UC-06: canal ONLINE solo para Cliente registrado y ACTIVO. No introducir autorregistro ni autocancelación por Cliente. UC-06 sí contempla cancelación de Pedido ONLINE por roles internos autorizados.

**A14.** UC-17→16: subtotal INTERNO base; ONLINE subtotal después de Promoción válida; aplicar luego ajuste comercial global, conservando el historial.

**A15.** UC-13 / UC-29→28: no aceptar respuestas definitivas nuevas sobre una Solicitud ya cerrada; rechazo informado. «Compra automática» se reemplaza por detección de faltante / inicio de ronda de cotización cuando corresponda; la Orden exige UC-12.

**A16.** UC-08: completar transiciones de Orden PENDIENTE→PARCIALMENTE_RECIBIDA→RECIBIDA por acumulados; rechazar recepción excedente o contra Orden CANCELADA/RECIBIDA. Estos **estados ya existen** en el modelo de 59 tablas. Compras de REVENTA sin Orden de Compra mientras no se apruebe ampliar ese modelo. No convertir la búsqueda opcional de OC en include universal.

**A17.** UC-40→39: exigir Administrador autenticado y autorizado, y hacer explícito UC-41→40 Buscar Orden de Compra en Extendido y Real. Mantener su include aprobado.

**A18.** UC-18→17 / UC-19→18: la asignación del primer Rol durante alta continúa mediante include, en contexto de Usuario aún no confirmado; alta y Roles atómicos. Verificar Proveedor ACTIVO, identidad comercial, cuenta habilitada única y exclusividad Rol PROVEEDOR. No incluir búsqueda Proveedor obligatoria para todas las altas.

**A19.** UC-25→24: al menos un Cliente destinatario activo y elegible; Producto activo y Promoción válida. Distinguir elegibilidad de envío por canal existente y derecho de uso de Promoción; cualquier reintento debe respetar intentos históricos e idempotencia. No asumir email: canal definido actualmente WHATSAPP en INTENTO_COMUNICACION.

**A20.** UC-03: Cliente elegido INACTIVO no confirma nuevo Pedido. No inventar política numérica de fecha. Operación offline únicamente en alcance RNF-03/04 validado, con idempotencia.

**A21.** UC-05: verificar asignación vigente del Repartidor en instante de confirmación, cubrir reasignación concurrente y renumerar paso «24a». Real debe preservar verificaciones, saldos a favor y operaciones atómicas de Extendido.

**A22.** UC-30→29: Cobro opcionalmente sin Pedido; al vincular a Pedido, debe pertenecer al mismo Cliente y ser PENDIENTE o ENTREGADO. No asociar Cobro nuevo como cobro vigente de un Pedido CANCELADO. Mantener cobranza de deuda previa o anticipos generales.

**A23.** UC-07 / UC-42→41: seleccionar Excedente disponible del Producto compatible, con saldo suficiente no reasignado/no descartado y comprobación concurrente. No está aprobado por esta decisión crear nuevo «Buscar Excedente».

**A24.** UC-39→38, UC-47→46, UC-49→48: bajas lógicas y preservación histórica, no borrados. Cliente inactivo: sin nuevos Pedidos/Promociones/ofertas; deuda y Cobros subsisten. Proveedor inactivo: no nuevas invitaciones/respuestas, historial permanece; definir tratamiento de Órdenes abiertas/cuenta antes de implementación. Producto inactivo: no nuevos Pedidos; Pedidos pendientes existentes **no se cancelan automáticamente** y deben quedar sujetos a revisión/resolución manual, sin crear por defecto un estado PEDIDO inexistente.

**A25.** Se aprueba mínimo privilegio RBAC. Elaborar matriz Rol×CU antes de conceder nuevas operaciones al Administrador; no agregar actores por inferencia ni extender permisos de consultas a roles no especificados.

**A26.** UC-02 y UC-26→25: coincidencias parciales de identidad generan advertencia, no bloqueo automático; duplicados exactos por criterios aprobados sí se impiden. UC-26 filtra Pedidos PENDIENTE asignados al Repartidor y gestiona secuencia anterior obsoleta según el flujo Extendido.

## 4. Grupo B — catálogo UC-50 a UC-64 aprobado

| Código | Nombre | Actor previsto | Criterio de alcance aprobado / a especificar |
| --- | --- | --- | --- |
| UC-50 | Registrar Insumo | Administrador | Maestro con stockActual inicial 0 y parámetros de reposición obligatorios; apertura física/valorada mediante UC-42. |
| UC-51 | Modificar Insumo | Administrador | No alterar Unidad de Medida con historial dependiente. |
| UC-52 | Cambiar Estado de Insumo | Administrador | Baja lógica y preservación histórica. |
| UC-53 | Cambiar Contraseña | Usuario autenticado | Cambio voluntario o temporal obligatorio, sin revelar clave previa. |
| UC-54 | Restablecer Acceso de Usuario | Administrador | Solo cuentas PROVEEDOR en alcance inicial. |
| UC-55 | Cambiar Estado de Usuario | Administrador | Revocación de sesiones, al menos un administrador y restricciones PROVEEDOR a especificar. |
| UC-56 | Buscar Usuario | Administrador | No exponer credenciales ni secretos. |
| UC-57 | Configurar Política de Categoría Comercial | Administrador | Versionar días de tolerancia y ajuste por categoría. |
| UC-58 | Configurar Política de Compra | Administrador | Versionar criterios de evaluación; plazo de respuesta pendiente de especificar. |
| UC-59 | Consultar Promociones | Administrador | Consulta estado, vigencia y resultado de comunicaciones. |
| UC-60 | Desactivar Promoción | Administrador | Sin efectos retroactivos sobre pedidos ya confirmados. |
| UC-61 | Buscar Excedente | Vendedor / Producción contextual | No mostrar saldo ocupado/reasignado como disponible. |
| UC-62 | Buscar Solicitud de Cotización | Administrador | Selección según episodio, estado y autorización. |
| UC-63 | Consultar Solicitudes de Cotización Recibidas | Proveedor | Solo solicitudes dirigidas al Proveedor autenticado. |
| UC-64 | Consultar Movimientos de Inventario | Producción / Administrador | Inventarios Insumo y REVENTA diferenciados, con procedencia y costo histórico autorizado. |

## 5. Grupo C — reglas de higiene aprobadas

| Referencia | Regla |
| --- | --- |
| C1–C3, C11 | Corregir títulos copiados, marcadores Markdown incrustados, caracteres extraños y columnas fantasmas; revisar tablas nativas antes de borrar supuestas columnas. |
| C4, C6 | Separar metatexto de postcondiciones; mover decisiones a RD y pendientes a RP; eliminar restos conversacionales sin borrar reglas aprobadas. |
| C5, C7 | Referencias a decisiones pasan al RD. Fórmulas y reglas formales se expresan en sección de Reglas de cálculo/negocio. |
| C8–C9 | Cada excepción Real debe señalar paso que exista en Real. Completar excepciones de búsquedas, separar grupos y eliminar etiquetas «propuesta» editoriales. |
| C10 | Descripciones autocontenidas; Intención del actor ≠ Propósito del sistema. |
| C12 | Corregir ortografía sin modificar nombres físicos, constantes, estados y enumerados. |
| C13 | Contrastar nombres y prefijos con catálogo canónico. OBJ, OBJE, RF, RNF e IRQ no son intercambiables; diferencias se registran antes de cambiar. |

## 6. Trazabilidad y extracción de metatexto

La inspección automatizada recorre los **147 apartados** (49 CU × 3 niveles) del `C_ANEXO_49_CU_TRES_NIVELES_ACTUALIZADO_23-10-2026.md`, sin reescribirlos. Su inventario de referencias y fragmentos de contexto está en `Fase1_Inventario_MetaTexto_49CU_24-10-2026.csv`.

| Hallazgo de extracción | Cantidad |
| --- | --- |
| CALIDAD_LENGUAJE | 44 |
| ETIQUETA_REGLAS | 1 |
| NOTA_EDITORIAL_EN_CAMPO | 20 |
| PENDIENTE_EXPLICITO | 8 |
| PLANTILLA_GENERICA | 19 |
| POSTCONDICION_CONTAMINADA | 19 |
| REFERENCIA_DECISION | 10 |
| TEXTO_DE_MARCADOR | 11 |

**Secciones con hallazgos:** 87 / 147. **Coincidencias detectadas:** 132. Un fragmento puede tener más de una categoría. Son indicios de revisión, no declaraciones de error automáticamente confirmado.

## 7. Control de cambios y estado de implantación

- **Fase 1:** RD-01, RP-01 y PRA-01 producidos como artefactos derivados. No se editó C_ANEXO ni el Google Doc original.
- **Fase 2:** redactar UC-50 a UC-64 a tres niveles y verificar nuevos campos/índices necesarios antes de modificar el esquema.
- **Fase 3:** aplicar Grupo A a los 49 existentes y validar cambios de numeración, excepciones y relaciones.
- **Fase 4:** retirar metatexto por identificación de fuente; validar coherencia transversal.
- **Trazabilidad de aceptación:** cada revisión futura deberá registrar ID de decisión, CU afectado, fecha, responsable de ratificación y estado de propagación. La redacción no transforma una propuesta en regla por sí sola.

## 8. Referencias documentales

`A_Requisitos_ACTUALIZADO_23-10-2026.md`; `B_Dominio_y_Diseño_ACTUALIZADO_23-10-2026.md`; `C_CasosDeUso_y_Estado_ACTUALIZADO_23-10-2026.md`; `C_ANEXO_49_CU_TRES_NIVELES_ACTUALIZADO_23-10-2026.md`; `D_Decisiones_y_Pendientes_ACTUALIZADO_23-10-2026.md`; `Esquema_Maestro_Relacional_59_Tablas_ACTUALIZADO_23-10-2026.md`; `Registro_Decisiones_Grupo_A_Aprobadas_24-10-2026.md`; aprobaciones B/C y numeración en esta conversación del 24/10.
