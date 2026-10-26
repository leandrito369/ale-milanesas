# A — Requisitos y trazabilidad — Ale Milanesas
**Corte vigente:** 23/10/2026. **Autoridad:** acuerdos explícitos de la conversación 19–23/10/2026, copia local integrada del Documento General y esquemas validados. El cuerpo heredado a continuación preserva las fichas originales y algunas notas históricas del 21/10; **ante cualquier contradicción prevalece esta actualización y D-23/10**.

## Actualización funcional final, aprobada
- **49 CU** vigentes: UC-01 a UC-50 excepto UC-14 (histórico). UC-46/47 afectan Proveedor; UC-48/49 Producto; UC-50 resultado de reembolso electrónico posterior.
- **RF-07**: UC-31 alta de Producto; UC-48 modificación y UC-49 cambio de estado; ambos incluyen UC-36 Buscar Producto.
- **RF-11**: UC-11 alta Proveedor; UC-46 modificación y UC-47 cambio de estado; ambos incluyen UC-38 Buscar Proveedor.
- **RF-18**: UC-50 notificación de MercadoPago, independientemente de UC-27, sin include/extend UC-27↔UC-50. Reembolso único y completo, efectos exclusivamente al llegar a PROCESADO.
- **RF-02, RF-13, RF-21**: UC-29 prepara hasta cantidad original, sin aumentar por ofertas aceptadas; UC-07 transfiere Excedentes sin nueva preparación; UC-05 no entrega por encima de original + adicionales aceptados ni de disponibilidad física; la imputación comercial se atribuye al original y luego a aceptaciones cronológicas, conservando costos/precios históricos.
- **RF-14 / UC-22**: autenticación ONLINE de Cliente mediante código temporal WhatsApp al teléfono registrado, solo Cliente registrado ACTIVO; sin Rol CLIENTE ni «include» UC-01. Teléfono compartido ambiguo: bloquear acceso hasta resolver identidad. Enlaces de Promoción no autentican.
- **UC-16/UC-17**: UC-16 actor Administrador con ejecución directa e incluida; UC-17 actor declarado Sistema en texto, pero no es actor externo UML.
- **RF-08**: Usuario 1..* Roles; PROVEEDOR exclusivo; UC-18 incluye UC-19 para asignación inicial atómica.
- **RF-16**: UC-25 exige al menos un destinatario, sin include UC-34; sí actor externo de Servicio de Mensajería.
- **UC-41 / UC-08**: búsqueda de Orden condicional: «extend» UC-41 → UC-08; compras de REVENTA pueden recibirse sin Orden.
- **RF-09**: versionado temporal de Precio; vigencias no superpuestas y congelamiento de histórico aplicado.
- **Recepción de RespuestaCotizacion**: fuera de plazo se rechaza el registro; la regla previa de registrar respuesta tardía quedó reemplazada el 20/10/2026.

## Advertencia de trazabilidad
El anexo vigente proviene del Documento General local integrado, no del anexo editorial del 21/10. Las cuatro marcas `[A CONFIRMAR]` relacionadas con fecha reparto online y UC-44 NO están resueltas; tampoco se deben dar por acordadas nuevas relaciones UML sugeridas por la transcripción del profesor.

---
## Fichas y antecedentes heredados (21/10/2026; subordinados a la actualización anterior)

\# A. REQUISITOS — Sistema de Gestión «Ale Milanesas»

\> \*\*Fuente de consulta base — 19/10/2026; cierre incremental 21/10/2026.\*\* Este archivo consolida las 73 fichas documentales y propaga las decisiones adoptadas en la conversación de trabajo del 11/10 al 19/10/2026. Mantiene los identificadores de requisitos existentes y distingue decisiones vigentes, material histórico y cuestiones todavía pendientes.

\#\# Actualización de trazabilidad funcional — auditoría TP05 (21/10/2026)

\*\*Estatus:\*\* 49 CU vigentes (44 identificadores originales + 5 incorporaciones con nombre y código provisional); UC-14 histórico no vigente. El Anexo de 49×3 niveles y el catálogo integrado constituyen la fuente de responsabilidad funcional para este corte. La numeración oficial de los nuevos CU se decidirá posteriormente.

- RF-07 / IRQ-03 / OBJE-08: UC-31 queda restringido al alta de Producto; UC-48 modifica información permitida y UC-49 cambia estado, ambos mediante «include» UC-36.
- RF-11 / IRQ-08 / OBJE-09: UC-11 queda restringido al alta de Proveedor; UC-46 actualiza datos comerciales y ProveedorInsumo; UC-47 cambia estado; ambos incluyen UC-38.
- RF-08 / IRQ-02 / OBJE-03: UC-18 «include» UC-19; asignación de al menos un Rol y registro de Usuario atómicos; UC-19 admite alta en curso y modificaciones posteriores.
- RF-18 / RNF-04: UC-50 recibe de MercadoPago resultados posteriores de Reembolso, sin «include» ni «extend» con UC-27; único Reembolso por Cobro, devolución completa, sin efectos financieros duplicados.
- RF-16 / IRQ-12: UC-25 exige 1..* Clientes destinatarios, seleccionados en su propio flujo; no incluye UC-34; el Servicio de Mensajería es actor externo.
- RF-01 / RF-17: UC-44 «include» UC-35 y conserva historial de Repartidores y obsolescencia de RutaSugerida al cambiar asignación.
- RF-04 / RF-11: UC-41 «extend» UC-08 si la recepción se vincula con una Orden; el Insumo o REVENTA se identifica mediante ramas de inventario según corresponda.
- RF-02 / RF-06 / RF-13 / RF-21: UC-05 genera cargo por Entrega efectiva y ejecuta reevaluación de categoría; UC-07 no se divide; la compatibilidad de cantidades de UC-29 permanece pendiente.

\*\*La sección precedente reemplaza referencias funcionales antiguas incompatibles; no reemplaza las 73 fichas académicas ni sus antecedentes de aprobación.\*\*

\#\# Contexto y límites del sistema

Trabajo Final académico, carrera de Analista en Sistemas de Computación, UNaM-FCEQyN, Res. CD 220/15. Se estudia una empresa real de elaboración y venta de milanesas de pollo con entregas a domicilio. Proceso Unificado adaptado al alcance de un desarrollador.

\*\*Problemas:\*\* doble registración en papel/Excel; comunicación Ventas–Producción–Reparto; inventarios sin trazabilidad suficiente; reposición manual; cuentas corrientes y Caja poco sistematizadas; necesidad de canal ONLINE, promociones y redistribución de Excedentes.

\*\*Fuera de alcance:\*\* facturación electrónica AFIP/ARCA, contabilidad general e impuestos, cuentas a pagar a proveedores, margen neto, multiempresa/SaaS, ERP general y optimización matemática exacta de rutas.

Con este corte de auditoría, existen **49 CU vigentes**: 44 códigos originales (UC-14 histórico excluido) y cinco nuevos con código provisional UC-46, UC-47, UC-48, UC-49 y UC-50. UC-14 queda como especificación histórica no vigente y su código no se reutiliza. Cuando una ficha contiene asociaciones por auditoría, la relación sigue siendo candidata a ratificación salvo que una decisión posterior la haya aprobado expresamente.

\#\#\# Cambios consolidados del corte 19/10/2026

Este corte incorpora, entre otros, los siguientes cambios transversales: \`Pedido.origen\` se renombra conceptualmente a \`Pedido.canalOrigen\`; todo Usuario debe conservar al menos un Rol; se incorpora el Rol \`PROVEEDOR\` y el vínculo controlado entre Usuario y Proveedor; la compra deja de ser una decisión completamente automática; UC-12 pasa a \*\*Evaluar Cotizaciones y Resolver Compra\*\* con confirmación obligatoria del Administrador; UC-14 se retira como CU vigente; y UC-45 \*\*Iniciar Ronda Manual de Cotización\*\* concentra las rondas manuales de reposición. La primera ronda automática por faltante continúa existiendo como comportamiento automático, pero nunca emite una Orden de Compra sin confirmación administrativa.

\#\# Objetivos Generales

\#\#\# OBJ-01 — Centralizar y coordinar la gestión de pedidos entre las áreas operativas

\*\*Origen:\*\* DOCX consolidado, ficha 1 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Descripción\*\*

El sistema deberá centralizar la carga, consulta, seguimiento, entrega y cancelación de los pedidos en un único registro compartido, permitiendo su utilización por las áreas involucradas y contemplando la operación con y sin conectividad cuando corresponda. Cada Pedido podrá incluir uno o más Productos y deberá mantenerse sincronizado hasta su cierre. \\\\

\*\*Estabilidad\*\*

Alta.

\*\*Comentarios\*\*

Constituye el eje operativo del sistema. La entrega de un Pedido genera los efectos comerciales correspondientes, mientras que el consumo de Insumos se produce previamente al registrarse la preparación.

\---

\#\#\# OBJ-02 — Sistematizar la gestión de productos, insumos y abastecimiento

\*\*Origen:\*\* DOCX consolidado, ficha 2 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Descripción\*\*

El sistema deberá gestionar el catálogo de Productos, diferenciando Productos elaborados de Productos de Reventa, mantener el control de Insumos utilizados en la producción, registrar sus movimientos, controlar umbrales de reposición, iniciar automáticamente una primera ronda de cotización solamente bajo las condiciones aprobadas y evaluar ofertas mediante una PoliticaCompra configurable. La selección de Proveedor y la emisión de toda OrdenCompra requieren confirmación expresa del Administrador. \\\\

\*\*Estabilidad\*\*

Alta.

\*\*Comentarios\*\*

Los Insumos representan las materias primas utilizadas en la elaboración y constituyen un concepto independiente de Producto. Su consumo se registra durante la preparación de Productos elaborados, no durante la entrega.

\---

\#\#\# OBJ-03 — Gestionar cobros, cuenta corriente y operación financiera del negocio

\*\*Origen:\*\* DOCX consolidado, ficha 3 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Descripción\*\*

El sistema deberá registrar Cobros, mantener la Cuenta Corriente de cada Cliente, aplicar políticas comerciales diferenciadas según su comportamiento de pago, registrar los movimientos monetarios de Caja y Libro Diario, y proporcionar información para calcular el margen bruto del negocio. \\\\

\*\*Estabilidad\*\*

Alta.

\*\*Comentarios\*\*

Un Cobro podrá registrarse independientemente de una entrega o de un Pedido concreto. La Entrega genera el cargo por venta; el Cobro registra el pago efectuado por el Cliente.

\---

\#\#\# OBJ-04 — Habilitar la venta directa a clientes mediante un canal online

\*\*Origen:\*\* DOCX consolidado, ficha 4 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Descripción\*\*

El sistema deberá permitir que los Clientes consulten el catálogo, realicen Pedidos y efectúen pagos en línea, integrando dichas operaciones al mismo ciclo de gestión que los Pedidos internos. También deberá permitir la comunicación de promociones y gestionar los Reembolsos correspondientes ante cancelaciones de Pedidos pagados electrónicamente. \\\\

\*\*Estabilidad\*\*

Media.

\*\*Comentarios\*\*

Los Pedidos online utilizarán el mismo modelo de Pedido y DetallePedido que los registrados internamente, diferenciándose por su origen.

\---

\#\# Objetivos Específicos

\#\#\# OBJE-01 — Unificar la gestión de Pedidos

\*\*Origen:\*\* DOCX consolidado, ficha 5 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Descripción\*\*

Registrar y mantener cada Pedido en un único módulo compartido por las áreas involucradas, permitiendo incorporar múltiples Productos, consultar su estado y evitar la doble carga en papel, planillas u otros registros paralelos. \\\\ Incluye la asignación y reasignación de Pedidos a Repartidores por el Vendedor, conservando trazabilidad.

\*\*Objetivo Relacionado\*\*

OBJ-01 — Centralizar y coordinar la gestión de pedidos entre las áreas operativas

\*\*Estabilidad\*\*

Alta.

\*\*Comentarios\*\*

La información podrá no encontrarse actualizada en tiempo real cuando exista operación offline; en esos casos será sincronizada posteriormente.

\---

\#\#\# OBJE-02 — Permitir la operación de Ventas ante ausencia de conectividad

\*\*Origen:\*\* DOCX consolidado, ficha 6 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Descripción\*\*

Permitir que las operaciones necesarias para Ventas puedan continuar sin conexión cuando sea técnicamente posible, utilizando información previamente sincronizada, almacenando localmente las nuevas operaciones y sincronizándolas con el servidor una vez recuperada la conectividad. \\\\

\*\*Objetivo Relacionado\*\*

OBJ-01 — Centralizar y coordinar la gestión de pedidos entre las áreas operativas

\*\*Estabilidad\*\*

Media.

\*\*Comentarios\*\*

Operación apoyada en información local y sincronización posterior, conforme a RNF-03 y RNF-04.

\---

\#\#\# OBJE-03 — Definir un esquema de Usuarios, roles y permisos

\*\*Origen:\*\* ficha consolidada; actualización por decisiones de la conversación 11/10–19/10/2026.

\*\*Descripción\*\*

Permitir administrar Usuarios y sus Roles, restringiendo el acceso a la información y funcionalidades del sistema conforme a las responsabilidades asignadas. Todo Usuario deberá mantener \*\*uno o más Roles durante toda su existencia\*\*; la creación de la cuenta y su asignación inicial de Roles constituyen una única operación válida. Para cuentas vinculadas a Proveedores se incorpora el Rol \`PROVEEDOR\`, sujeto a las restricciones específicas documentadas en RF-08 e IRQ-02.

\*\*Objetivo Relacionado\*\*

OBJ-01 — Centralizar y coordinar la gestión de pedidos entre las áreas operativas

\*\*Estabilidad\*\*

Alta.

\*\*Comentarios\*\*

La política anterior que admitía Usuarios sin Roles queda reemplazada. Un Usuario puede cumplir más de una función interna siempre que la combinación de Roles sea válida. El Rol \`PROVEEDOR\` no se combina con Roles internos y la cuenta externa representa a un único Proveedor.

\---

\#\#\# OBJE-04 — Favorecer una operación móvil simple y eficiente

\*\*Origen:\*\* DOCX consolidado, ficha 8 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Descripción\*\*

Proporcionar interfaces móviles orientadas a reducir pasos y carga manual innecesaria en las operaciones frecuentes, utilizando información preexistente y valores sugeridos cuando resulte adecuado. \\\\

\*\*Objetivo Relacionado\*\*

OBJ-01 — Centralizar y coordinar la gestión de pedidos entre las áreas operativas

\*\*Estabilidad\*\*

Media.

\*\*Comentarios\*\*

Operación apoyada en información local y sincronización posterior, conforme a RNF-03 y RNF-04.

\---

\#\#\# OBJE-05 — Facilitar la redistribución de excedentes de producción

\*\*Origen:\*\* DOCX consolidado, ficha 9 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Descripción\*\*

Identificar Productos elaborados que hayan sido preparados y queden sin destino como consecuencia de una cancelación, priorizar Clientes candidatos y asistir a Ventas en la reasignación total o parcial del excedente. \\\\

\*\*Objetivo Relacionado\*\*

OBJ-01 — Centralizar y coordinar la gestión de pedidos entre las áreas operativas

\*\*Estabilidad\*\*

Media.

\*\*Comentarios\*\*

La identificación y priorización puede automatizarse; el contacto comercial y la aceptación del Cliente continúan siendo parte de la operación de Ventas.

\---

\#\#\# OBJE-06 — Generar una secuencia optimizada de reparto

\*\*Origen:\*\* DOCX consolidado, ficha 10 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Descripción\*\*

Utilizar un servicio de ruteo para obtener una secuencia sugerida de visita a partir de las direcciones de los Pedidos a entregar, con el objetivo de mejorar la planificación del reparto. \\\\ La sugerencia se calculará por Repartidor y fecha sobre sus Pedidos pendientes asignados, y se invalidará si cambia la asignación.

\*\*Objetivo Relacionado\*\*

OBJ-01 — Centralizar y coordinar la gestión de pedidos entre las áreas operativas

\*\*Estabilidad\*\*

Media.

\*\*Comentarios\*\*

La solución obtenida se considerará optimizada o sugerida según los criterios del servicio utilizado, sin garantizar un óptimo matemático global.

\---

\#\#\# OBJE-07 — Sistematizar la preparación de Productos elaborados y el control de Insumos

\*\*Origen:\*\* DOCX consolidado, ficha 11 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Descripción\*\*

Registrar la preparación parcial o total de Productos elaborados utilizando recetas configurables, calcular los Insumos requeridos, descontar sus existencias al confirmarse la preparación y detectar situaciones de stock inferior al umbral de reposición. \\\\

\*\*Objetivo Relacionado\*\*

OBJ-02 — Sistematizar la gestión de productos, insumos y abastecimiento

\*\*Estabilidad\*\*

Alta.

\*\*Comentarios\*\*

Las recetas deberán utilizar unidades de medida configurables y podrán conservar versiones históricas. El consumo de Insumos ocurre durante la preparación y no durante la Entrega.

\---

\#\#\# OBJE-08 — Gestionar un catálogo de Productos

\*\*Origen:\*\* DOCX consolidado, ficha 12 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Descripción\*\*

Gestionar los Productos comercializados por el negocio, diferenciando Productos ELABORADOS de Productos de REVENTA, junto con su unidad de venta, estado y demás información necesaria para su utilización en Pedidos y canales de venta. \\\\

\*\*Objetivo Relacionado\*\*

OBJ-02 — Sistematizar la gestión de productos, insumos y abastecimiento

\*\*Estabilidad\*\*

Media.

\*\*Comentarios\*\*

Los Insumos y materias primas no forman parte del catálogo de Productos comercializados; se gestionan separadamente.

\---

\#\#\# OBJE-09 — Gestionar cotizaciones y asistir la decisión de compra a Proveedores

\*\*Origen:\*\* ficha consolidada; actualización por decisiones de la conversación 11/10–19/10/2026.

\*\*Descripción\*\*

Gestionar Solicitudes y Respuestas de Cotización, comparar las alternativas mediante una \`PoliticaCompra\` configurable y presentar al Administrador la información necesaria para decidir. El sistema podrá automatizar la detección de faltantes, la primera ronda de cotización de un episodio y la evaluación comparativa, pero \*\*no seleccionará ni autorizará por sí solo una compra\*\*. La emisión de una \`OrdenCompra\` requiere selección, justificación y confirmación expresa del Administrador.

\*\*Objetivo Relacionado\*\*

OBJ-02 — Sistematizar la gestión de productos, insumos y abastecimiento

\*\*Estabilidad\*\*

Media.

\*\*Comentarios\*\*

Las rondas posteriores dentro del mismo episodio de faltante son manuales mediante UC-45. Los pesos, umbrales y demás parámetros concretos de \`PoliticaCompra\` continúan pendientes si no fueron expresamente validados.

\---

\#\#\# OBJE-10 — Registrar Cobros y mantener la Cuenta Corriente de los Clientes

\*\*Origen:\*\* DOCX consolidado, ficha 14 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Descripción\*\*

Registrar Cobros realizados por los Clientes y mantener automáticamente su Cuenta Corriente mediante cargos por ventas, pagos y ajustes, permitiendo determinar saldo, crédito disponible y antigüedad de deuda. \\\\

\*\*Objetivo Relacionado\*\*

OBJ-03 — Gestionar cobros, cuenta corriente y operación financiera del negocio

\*\*Estabilidad\*\*

Alta.

\*\*Comentarios\*\*

Un Cobro no deberá requerir necesariamente la asociación a una Entrega o Pedido específico y podrá representar pagos parciales, totales, anticipados o importes superiores al saldo adeudado.

\---

\#\#\# OBJE-11 — Aplicar políticas comerciales según el historial de pago del Cliente

\*\*Origen:\*\* DOCX consolidado, ficha 15 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Descripción\*\*

Determinar una categoría comercial para cada Cliente según su saldo, historial de movimientos y antigüedad de deuda, y aplicar automáticamente el ajuste de precio correspondiente sobre nuevos Pedidos. \\\\

\*\*Objetivo Relacionado\*\*

OBJ-03 — Gestionar cobros, cuenta corriente y operación financiera del negocio

\*\*Estabilidad\*\*

Media.

\*\*Comentarios\*\*

Las categorías iniciales consideradas son CUMPLIDOR y EN\_MORA. Los umbrales exactos permanecen pendientes de validación.

\---

\#\#\# OBJE-12 — Gestionar precios vigentes e historial de precios

\*\*Origen:\*\* DOCX consolidado, ficha 16 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Descripción\*\*

Registrar el precio base de cada Producto junto con su período de vigencia, conservar el historial de precios y utilizar el valor aplicable al momento de confirmar una operación comercial. \\\\ Admite nuevos precios inmediatos o futuros, sin retroactividad ni superposición.

\*\*Objetivo Relacionado\*\*

OBJ-02 — Sistematizar la gestión de productos, insumos y abastecimiento

\*\*Estabilidad\*\*

Alta.

\*\*Comentarios\*\*

El precio aplicado a un Pedido deberá conservarse en su DetallePedido para no depender de modificaciones futuras del Precio base.

\---

\#\#\# OBJE-13 — Registrar la operación monetaria diaria del negocio

\*\*Origen:\*\* DOCX consolidado, ficha 17 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Descripción\*\*

Registrar y consolidar los movimientos de ingreso y egreso generados automática o manualmente, permitiendo consultar el Libro Diario y el resultado monetario de un período. \\\\ El registro manual de Caja exige concepto y admite observación; el resultado monetario de un período es ingresos menos egresos.

\*\*Objetivo Relacionado\*\*

OBJ-03 — Gestionar cobros, cuenta corriente y operación financiera del negocio

\*\*Estabilidad\*\*

Alta.

\*\*Comentarios\*\*

Incluye Cobros, Reembolsos y otros movimientos manuales. No implica implementar un subsistema completo de cuentas a pagar a Proveedores.

\---

\#\#\# OBJE-14 — Calcular el margen bruto del negocio

\*\*Origen:\*\* DOCX consolidado, ficha 18 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Descripción\*\*

Calcular el margen bruto de un período contrastando los ingresos efectivos por ventas con los costos directos correspondientes a los Productos vendidos, utilizando información histórica reproducible. \\\\

\*\*Objetivo Relacionado\*\*

OBJ-03 — Gestionar cobros, cuenta corriente y operación financiera del negocio

\*\*Estabilidad\*\*

Media.

\*\*Comentarios\*\*

Para Productos ELABORADOS se considerarán los consumos de Insumos registrados durante la preparación y el criterio de costo definido. Para Productos de REVENTA se utilizará el costo de adquisición correspondiente. No se contemplan gastos operativos generales.

\---

\#\#\# OBJE-15 — Permitir que los Clientes realicen Pedidos y pagos en línea

\*\*Origen:\*\* DOCX consolidado, ficha 19 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Descripción\*\*

Permitir que los Clientes consulten el catálogo, seleccionen Productos y cantidades, efectúen pagos electrónicos y generen Pedidos online sin intervención directa de Ventas. \\\\

\*\*Objetivo Relacionado\*\*

OBJ-04 — Habilitar la venta directa a clientes mediante un canal online

\*\*Estabilidad\*\*

Media.

\*\*Comentarios\*\*

Los Pedidos creados por este canal utilizarán el mismo ciclo de gestión que los Pedidos internos, identificándose mediante su \`canalOrigen\` ONLINE.

\---

\#\#\# OBJE-16 — Gestionar y comunicar Promociones a los Clientes

\*\*Origen:\*\* DOCX consolidado, ficha 20 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Descripción\*\*

Permitir definir Promociones para Productos, seleccionar sus destinatarios y comunicarlas a los Clientes mediante WhatsApp, incorporando un acceso directo al canal de Pedidos online cuando corresponda. \\\\

\*\*Objetivo Relacionado\*\*

OBJ-04 — Habilitar la venta directa a clientes mediante un canal online

\*\*Estabilidad\*\*

Media.

\*\*Comentarios\*\*

El proveedor tecnológico concreto de mensajería podrá variar; el uso de WhatsApp responde al canal comercial definido para el negocio.

\---

\#\#\# OBJE-17 — Gestionar Reembolsos de Cobros electrónicos

\*\*Origen:\*\* DOCX consolidado, ficha 21 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Descripción\*\*

Solicitar y registrar el Reembolso correspondiente cuando se cancele un Pedido que posea un Cobro electrónico asociado, manteniendo su estado y reflejando sus efectos en la Cuenta Corriente del Cliente y en Caja. \\\\

\*\*Objetivo Relacionado\*\*

OBJ-04 — Habilitar la venta directa a clientes mediante un canal online

\*\*Estabilidad\*\*

Media.

\*\*Comentarios\*\*

Un Reembolso podrá encontrarse PENDIENTE, PROCESADO o RECHAZADO. Si el proveedor de pagos no puede procesarlo automáticamente, deberá quedar registrada la situación para su posterior gestión.

\---

\#\# Requisitos de Información

\#\#\# IRQ-01 — Clientes

\*\*Origen:\*\* DOCX consolidado, ficha 22 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Objetivos Asociados\*\*

• OBJ-01 — Centralizar y coordinar la gestión de pedidos entre las áreas operativas

• OBJ-03 — Gestionar cobros, cuenta corriente y operación financiera del negocio

• OBJ-04 — Habilitar la venta directa a clientes mediante un canal online

\*\*Requisitos Asociados\*\*

Requisitos funcionales: RF-01, RF-06, RF-09, RF-10, RF-12, RF-13, RF-14, RF-15, RF-16, RF-17, RF-20

Casos de uso: UC-02, UC-03, UC-04, UC-07, UC-15, UC-16, UC-17, UC-22, UC-25, UC-26, UC-30, UC-33, UC-34, UC-39, UC-44

\*\*Descripción\*\*

El sistema deberá almacenar y permitir consultar la información correspondiente a clientes, preservando las relaciones y referencias necesarias para los procesos asociados.

\*\*Datos Específicos\*\*

• id, nombre, contacto, dirección, zona, día habitual, activo, categoría comercial, datos de antigüedad de deuda, fecha de alta.

• Registrar motivo de inactivación de Cliente; conservar estado, datos y criterios necesarios para evitar duplicación normalizada nombre+teléfono y preservar Pedidos y Cuenta Corriente históricos.

\*\*Estabilidad\*\*

Alta (estimación de análisis).

\*\*Comentarios\*\*

Datos originales conservados de A\_Requisitos.md. Ampliación aprobada: DEC-P2-004. Las relaciones de CU y objetivos incluyen vínculos de auditoría documental por ratificar; no añaden nuevos campos a esta ficha.

\---

\#\#\# IRQ-02 — Usuarios y Roles

\*\*Origen:\*\* ficha consolidada; actualización por decisiones de la conversación 11/10–19/10/2026.

\*\*Objetivos Asociados\*\*

• OBJ-01 — Centralizar y coordinar la gestión de pedidos entre las áreas operativas

\*\*Requisitos Asociados\*\*

Requisitos funcionales: RF-08  

Casos de uso: UC-01, UC-18, UC-19

\*\*Descripción\*\*

El sistema deberá almacenar y permitir consultar Usuarios, Roles, asignaciones y los vínculos necesarios para aplicar autenticación y autorización. Todo Usuario debe poseer al menos un Rol.

\*\*Datos Específicos\*\*

• \`id\`, nombre de usuario, credencial protegida, estado, Roles, fecha de alta.  

• Asociación \`Usuario–Rol\`: cada Usuario tiene \`1..\*\` Roles; un Rol puede estar asociado a \`0..\*\` Usuarios.  

• La creación exige seleccionar al menos un Rol; UC-19 no permite quitar el último Rol sin sustituirlo por otro en la misma operación.  

• Catálogo funcional documentado: Administrador, Vendedor, Responsable de Producción, Repartidor y \`PROVEEDOR\`.  

• Un Usuario con Rol \`PROVEEDOR\` representa exactamente a un Proveedor y no combina Roles internos. Un Proveedor puede conservar \`0..\*\` cuentas históricas, con \*\*como máximo una cuenta habilitada a la vez\*\*.  

• El Administrador establece la credencial inicial. Para la cuenta de Proveedor se utiliza contraseña temporal y se exige su cambio antes de responder cotizaciones. La revocación deshabilita la cuenta e invalida sesiones activas sin borrar historial.

\*\*Estabilidad\*\*

Alta para la cardinalidad mínima de Roles y las reglas de cuenta de Proveedor; los detalles operativos de bloqueo, recuperación y catálogo exacto de permisos siguen sujetos a diseño/validación.

\*\*Comentarios\*\*

Se reemplaza la regla anterior que permitía \`0..\*\` Roles por Usuario. El Proveedor comercial y su Usuario de acceso son conceptos distintos. La recuperación de una cuenta de Proveedor se realiza con intervención del Administrador y nueva credencial temporal, preservando trazabilidad.

\---

\#\#\# IRQ-03 — Productos, Catálogo y Unidades

\*\*Origen:\*\* DOCX consolidado, ficha 24 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Objetivos Asociados\*\*

• OBJ-01 — Centralizar y coordinar la gestión de pedidos entre las áreas operativas

• OBJ-02 — Sistematizar la gestión de productos, insumos y abastecimiento

• OBJ-03 — Gestionar cobros, cuenta corriente y operación financiera del negocio

• OBJ-04 — Habilitar la venta directa a clientes mediante un canal online

\*\*Requisitos Asociados\*\*

Requisitos funcionales: RF-01, RF-04, RF-05, RF-07, RF-09, RF-11, RF-12, RF-14, RF-16, RF-20

Casos de uso: UC-03, UC-08, UC-10, UC-20, UC-22, UC-25, UC-31, UC-36, UC-43

\*\*Descripción\*\*

El sistema deberá almacenar y permitir consultar la información correspondiente a productos, catálogo y unidades, preservando las relaciones y referencias necesarias para los procesos asociados.

\*\*Datos Específicos\*\*

• nombre, descripción, tipo, unidad de venta, activo, info de catálogo, unidades admitidas.

• Conservar referencias que permiten bloquear modificaciones de tipo y unidad de venta si existe historial dependiente; inactivación no elimina referencias históricas.

\*\*Estabilidad\*\*

Alta (estimación de análisis).

\*\*Comentarios\*\*

Datos originales conservados de A\_Requisitos.md. Ampliación aprobada: DEC-P2-003. Las relaciones de CU y objetivos incluyen vínculos de auditoría documental por ratificar; no añaden nuevos campos a esta ficha.

\---

\#\#\# IRQ-04 — Precios e historial

\*\*Origen:\*\* DOCX consolidado, ficha 25 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Objetivos Asociados\*\*

• OBJ-01 — Centralizar y coordinar la gestión de pedidos entre las áreas operativas

• OBJ-02 — Sistematizar la gestión de productos, insumos y abastecimiento

• OBJ-03 — Gestionar cobros, cuenta corriente y operación financiera del negocio

• OBJ-04 — Habilitar la venta directa a clientes mediante un canal online

\*\*Requisitos Asociados\*\*

Requisitos funcionales: RF-01, RF-02, RF-04, RF-06, RF-09, RF-12, RF-13, RF-14, RF-16, RF-19, RF-20

Casos de uso: UC-03, UC-05, UC-17, UC-20, UC-21, UC-22

\*\*Descripción\*\*

El sistema deberá almacenar y permitir consultar la información correspondiente a precios e historial, preservando las relaciones y referencias necesarias para los procesos asociados.

\*\*Datos Específicos\*\*

• Producto, precio base, vigencia desde/hasta, estado, historial.

• Mantener importes positivos y versiones de precio base con intervalos de vigencia no superpuestos, inmediatos o futuros, sin modificación retroactiva; conservar las acciones sobre programaciones futuras para auditoría.

\*\*Estabilidad\*\*

Media (estimación de análisis).

\*\*Comentarios\*\*

Datos originales conservados de A\_Requisitos.md. Ampliación aprobada: DEC-P2-009. Las relaciones de CU y objetivos incluyen vínculos de auditoría documental por ratificar; no añaden nuevos campos a esta ficha.

\---

\#\#\# IRQ-05 — Pedidos y Detalles. Pedido

\*\*Origen:\*\* ficha consolidada; actualización por decisiones de la conversación 11/10–19/10/2026.

\*\*Objetivos Asociados\*\*

• OBJ-01 — Centralizar y coordinar la gestión de pedidos entre las áreas operativas  

• OBJ-02 — Sistematizar la gestión de productos, insumos y abastecimiento  

• OBJ-03 — Gestionar cobros, cuenta corriente y operación financiera del negocio  

• OBJ-04 — Habilitar la venta directa a clientes mediante un canal online

\*\*Requisitos Asociados\*\*

Requisitos funcionales: RF-01, RF-02, RF-03, RF-04, RF-05, RF-06, RF-09, RF-12, RF-13, RF-14, RF-15, RF-16, RF-17, RF-18, RF-19, RF-20, RF-21  

Casos de uso: UC-03, UC-04, UC-05, UC-06, UC-07, UC-16, UC-17, UC-22, UC-26, UC-27, UC-28, UC-29, UC-35, UC-44

\*\*Descripción\*\*

El sistema deberá almacenar y permitir consultar la información correspondiente a Pedidos y sus Detalles, preservando las relaciones y referencias necesarias para los procesos asociados.

\*\*Datos Específicos\*\*

• \`id\`, Cliente, fecha/hora de carga, fecha de reparto, \`canalOrigen\` (\`INTERNO | ONLINE\`), estado, tipo y porcentaje de ajuste, total.  

• Detalle: Producto, cantidad solicitada, cantidad entregada, unidad, precio unitario histórico, promoción congelada cuando corresponda y subtotal.  

• Registrar un único Repartidor vigente como máximo por Pedido y conservar el historial mediante \`AsignacionReparto\`, con fecha/hora, Vendedor responsable, Repartidor anterior, Repartidor nuevo y motivo de reasignación.  

• El estado comercial continúa \`PENDIENTE | ENTREGADO | CANCELADO\`; una asignación no agrega un nuevo estado.

\*\*Estabilidad\*\*

Alta para la sustitución semántica \`origen → canalOrigen\` y las reglas de asignación.

\*\*Comentarios\*\*

\`canalOrigen\` evita confundir el canal por el que nació el Pedido con otros campos denominados “origen” presentes en Cobros o Movimientos. No altera el comportamiento de los Pedidos INTERNO u ONLINE.


**ACTUALIZACIÓN DEL 20/10/2026 · IRQ-05.** PED-01 a PED-05; EXC-05: registrar totalOriginal inmutable, incrementos comerciales por reasignaciones confirmadas y totalVigente derivado; el precio/ajuste de origen se conserva. RutaSugerida aprobada como clase histórica. No presupone correcciones automáticas de prepago ONLINE.



ENMIENDA APROBADA 21/10 — EXC-05 / EXC-DET-01: Pedido.totalOriginal conserva la confirmación y totalVigente = original + incrementos confirmados. La cantidad originalmente solicitada se conserva para distinguir promociones de incrementos posteriores; no se impone nueva fórmula de cantidadVigente. El Cobro ONLINE no se modifica por aceptar Excedente; UC-05 registra venta efectiva.
\---

\#\#\# IRQ-06 — Insumos e Inventario. Insumo

\*\*Origen:\*\* ficha consolidada; actualización por decisiones de la conversación 11/10–19/10/2026.

\*\*Objetivos Asociados\*\*

• OBJ-01 — Centralizar y coordinar la gestión de pedidos entre las áreas operativas  

• OBJ-02 — Sistematizar la gestión de productos, insumos y abastecimiento  

• OBJ-03 — Gestionar cobros, cuenta corriente y operación financiera del negocio

\*\*Requisitos Asociados\*\*

Requisitos funcionales: RF-02, RF-04, RF-05, RF-06, RF-11, RF-13, RF-19, RF-21  

Casos de uso: UC-05, UC-08, UC-09, UC-28, UC-29, UC-32, UC-37, UC-43, UC-45

\*\*Descripción\*\*

El sistema deberá almacenar y permitir consultar Insumos, parámetros de reposición, existencias y movimientos, conservando trazabilidad del consumo, compras, ajustes y costos históricos.

\*\*Datos Específicos\*\*

• Insumo: \`id\`, nombre, unidad, stockActual, umbralMinimo, nivelObjetivoReposicion, automatizacionCompraActiva, activo.  

• \`MovimientoInsumo\`: Insumo, tipo (\`INGRESO\_COMPRA\`, \`CONSUMO\_PRODUCCION\`, \`AJUSTE\_POSITIVO\`, \`AJUSTE\_NEGATIVO\`), cantidad, fecha/hora, origen/referencia, observación y datos históricos de costo cuando correspondan.  

• El consumo producido por una \`Preparacion\` se representa mediante \`MovimientoInsumo\` asociado a dicha Preparación; no se crea una clase conceptual adicional \`ConsumoPreparacion\`.  

• Para Producto de REVENTA, las existencias y el costo promedio vigente se tratan conceptualmente como propiedades del Producto; \`MovimientoStockReventa\` conserva el historial.  

• \`RecepcionCompra\` registra la recepción física —incluidas recepciones parciales— y \`CostoInsumoHistorico\` preserva la valoración temporal del Insumo.

\*\*Estabilidad\*\*

Alta para las decisiones conceptuales aprobadas; la representación física en base de datos queda para el Modelo de Datos.

\*\*Comentarios\*\*

UC-14 ya no es un caso de uso vigente. La lógica de reposición se distribuye entre parámetros (UC-32), comportamiento automático de primera ronda, evaluación y resolución de compra (UC-12), respuesta del Proveedor (UC-13) y rondas manuales (UC-45).


**ACTUALIZACIÓN DEL 20/10/2026 · IRQ-06.** INV-01 a INV-03, INV-05/06: RecepcionCompra puede no referir Orden; corresponde a un solo Insumo o Producto REVENTA (exclusión mutua), y genera movimiento del inventario apropiado. CostoInsumoHistorico se origina en valoración real, no por emitir Orden.



ENMIENDA APROBADA 21/10 — INV-04 / REC-PROV-01: las recepciones acumulan cantidades físicas contra una Orden cuando exista. Solo el circuito UC-12 emite Orden de Insumo; REVENTA por UC-08 puede entrar sin Orden. Sin Orden, Proveedor registrado 0..1 o referencia comercial cuando no esté identificado.
\---

\#\#\# IRQ-07 — Recetas y Preparación. Receta

\*\*Origen:\*\* DOCX consolidado, ficha 28 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Objetivos Asociados\*\*

• OBJ-01 — Centralizar y coordinar la gestión de pedidos entre las áreas operativas

• OBJ-02 — Sistematizar la gestión de productos, insumos y abastecimiento

• OBJ-03 — Gestionar cobros, cuenta corriente y operación financiera del negocio

\*\*Requisitos Asociados\*\*

Requisitos funcionales: RF-03, RF-04, RF-05, RF-11, RF-13, RF-18, RF-19, RF-21

Casos de uso: UC-06, UC-07, UC-10, UC-12, UC-28, UC-29, UC-37

\*\*Descripción\*\*

El sistema deberá almacenar y permitir consultar la información correspondiente a recetas y preparación. receta, preservando las relaciones y referencias necesarias para los procesos asociados.

\*\*Datos Específicos\*\*

• Producto elaborado, versión, vigencias, Insumos, cantidades. Preparación: Pedido, Producto, cantidad preparada, fecha/hora, cantidad acumulada, consumos.

• Conservar rendimiento base, versión/vigencias de Receta y cantidades por DetalleReceta, y cantidades acumuladas de Preparación, consumos y costos históricos pertinentes para reproducir la producción.

\*\*Estabilidad\*\*

Media (estimación de análisis).

\*\*Comentarios\*\*

Datos originales conservados de A\_Requisitos.md. Ampliación aprobada: DEC-P2-001; DEC-P2-005. Las relaciones de CU y objetivos incluyen vínculos de auditoría documental por ratificar; no añaden nuevos campos a esta ficha.


**ACTUALIZACIÓN DEL 20/10/2026 · IRQ-07.** PROD-01 a PROD-05: Receta/DetalleReceta/Preparacion son conceptos independientes. Conservan versión, rendimiento, cantidades y consumo por MovimientoInsumo. Preparacion corresponde a exactamente un DetallePedido.



CONTROL DE COHERENCIA 21/10 — EXC-DET-01: conservar fuente histórica de cantidad propia y cantidad reasignada; verificar que las cotas de UC-29 no permitan preparar por segunda vez lo ya producido, sin aprobar automáticamente fórmula nueva sobre cantidad original.
\---

\#\#\# IRQ-08 — Proveedores, Cotizaciones y Decisiones de Compra

\*\*Origen:\*\* ficha consolidada; actualización por decisiones de la conversación 11/10–19/10/2026.

\*\*Objetivos Asociados\*\*

• OBJ-02 — Sistematizar la gestión de productos, insumos y abastecimiento

\*\*Requisitos Asociados\*\*

Requisitos funcionales: RF-04, RF-05, RF-08, RF-11  

Casos de uso vigentes: UC-08, UC-11, UC-12, UC-13, UC-18, UC-19, UC-32, UC-38, UC-40, UC-41, UC-45

\*\*Descripción\*\*

El sistema deberá almacenar Proveedores, sus asociaciones con Insumos, Solicitudes y Respuestas de Cotización, invitaciones, políticas y resultados de evaluación, decisiones administrativas y Órdenes de Compra, preservando la evolución histórica de cada ronda.

\*\*Datos Específicos\*\*

• \`Proveedor\`, \`ProveedorInsumo\` con vigencia; \`SolicitudCotizacion\` con Insumo, cantidad congelada al emitir, fecha, plazo, forma de inicio y relación con una solicitud antecedente cuando corresponda; \`RespuestaCotizacion\` con precio, disponibilidad/cantidad, plazo de entrega y Usuario del Proveedor que la registró.  

• Invitaciones: los destinatarios se determinan y congelan al emitir. Para ser invitable, el Proveedor debe estar \`ACTIVO\`, poseer \`ProveedorInsumo\` vigente para el Insumo y contar con un Usuario habilitado vinculado. Los antecedentes de cumplimiento no filtran la invitación; intervienen en la evaluación.  

• Ronda automática: invita a todos los invitables. Ronda manual: el Administrador elige un subconjunto no vacío entre los invitables; quienes carezcan de cuenta habilitada se muestran como “no invitable: sin acceso al portal”.  

• Toda respuesta procede del portal, de un Proveedor invitado, y existe como máximo una respuesta definitiva e inmutable por Proveedor y Solicitud. El sistema rechaza la confirmación y registro de nuevas RespuestasCotizacion después del vencimiento de su Solicitud: no se admite crear una respuesta extemporánea.  

• \`PoliticaCompra\` documenta criterios de evaluación; \`DecisionCompra\` conserva la resolución administrativa; \`DetalleDecision\` conserva valores/puntajes por alternativa; \`OrdenCompra\` registra la compra confirmada. \*\*Ninguna OrdenCompra se emite sin confirmación expresa del Administrador.\*\*  

• Cierre mixto: \`SIN\_RESPUESTAS\` y \`SIN\_OFERTAS\_ELEGIBLES\` producen cierre automático sin compra; si existen ofertas elegibles, la Solicitud espera decisión del Administrador, quien puede comprar o cerrar sin compra con justificación.  

• Una Orden cancelada no borra la decisión histórica. Una nueva ronda dentro del mismo episodio requiere UC-45. Una Orden completamente recibida tampoco obliga a cerrar el episodio si el stock continúa bajo.

\*\*Estabilidad\*\*

Alta para las reglas funcionales aprobadas; los valores numéricos de \`PoliticaCompra\`, estados internos exactos y detalles físicos continúan pendientes cuando no consten aprobados.

\*\*Comentarios\*\*

UC-14 se conserva únicamente como antecedente histórico. La cadena de Solicitudes permite sucesión de rondas dentro de un mismo episodio; \`Episodio de faltante\` es por ahora una regla transversal y no una clase conceptual aprobada.


**ACTUALIZACIÓN DEL 20/10/2026 · IRQ-08.** COT-17 a COT-20 y P09–P16: rechazo estricto del registro posterior a vencimiento; Respuesta inmutable al confirmar; invitación histórica a Proveedor, Usuario registrador, unicidad por par; elegibilidad exige cobertura completa; congelamiento de cantidad, destinatarios y modalidad de inicio; cadena de Solicitudes lineal. Solicitud registra estado comercial, motivoCierre (tres causales de no compra) y fecha/hora de cierre automático. DecisionCompra tiene resultado COMPRA/SIN_COMPRA, fecha/hora, decisor, justificación obligatoria, versión de PoliticaCompra y 1..* DetalleDecision cuando hay resolución administrativa. Compra → 1 Respuesta evaluada elegible y 1 Orden; SIN_COMPRA → ninguna. Tercer nombre literal de motivoCierre sujeto a normalización.



ENMIENDA APROBADA 21/10 — COT-MOT-01 / INV-04: cuatro estados de SolicitudCotizacion y motivoCierre SIN_RESPUESTAS|SIN_OFERTAS_ELEGIBLES|DECISION_ADMINISTRATIVA_SIN_COMPRA, relacionado bicondicionalmente con estado y DecisionCompra.resultado. Cierre automático por reevaluación desde PENDIENTE_DECISION sin ofertas elegibles. OrdenCompra cuatro estados y cancelación trazable desde PENDIENTE/PARCIALMENTE_RECIBIDA. Versión de política inmutable en la decisión.
\---

\#\#\# IRQ-09 — Cuenta Corriente

\*\*Origen:\*\* DOCX consolidado, ficha 30 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Objetivos Asociados\*\*

• OBJ-01 — Centralizar y coordinar la gestión de pedidos entre las áreas operativas

• OBJ-03 — Gestionar cobros, cuenta corriente y operación financiera del negocio

\*\*Requisitos Asociados\*\*

Requisitos funcionales: RF-01, RF-02, RF-03, RF-04, RF-06, RF-12, RF-13, RF-14, RF-15, RF-18, RF-19, RF-20

Casos de uso: UC-05, UC-06, UC-15, UC-16, UC-17, UC-27, UC-30

\*\*Descripción\*\*

El sistema deberá almacenar y permitir consultar la información correspondiente a cuenta corriente, preservando las relaciones y referencias necesarias para los procesos asociados.

\*\*Datos Específicos\*\*

• Cliente, fecha/hora, tipo, importe, Pedido opcional, saldo resultante, observación, antigüedad.

• Mantener saldo actual e historial de movimientos consultable por período, sin alterar el saldo cuando se filtra. Un saldo a favor puede surgir de prepago ONLINE mayor que la venta efectiva.

\*\*Estabilidad\*\*

Alta (estimación de análisis).

\*\*Comentarios\*\*

Datos originales conservados de A\_Requisitos.md. Ampliación aprobada: DEC-P2-005; DEC-P2-011. Las relaciones de CU y objetivos incluyen vínculos de auditoría documental por ratificar; no añaden nuevos campos a esta ficha.


**ACTUALIZACIÓN DEL 20/10/2026 · IRQ-09.** FIN-01 a FIN-04: mantener movimientos históricos efectivos de cobros y reembolsos, sin revertir anticipadamente importes PENDIENTE/RECHAZADO.

\---

\#\#\# IRQ-10 — Cobros, Caja y Reembolsos. Cobro

\*\*Origen:\*\* DOCX consolidado, ficha 31 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Objetivos Asociados\*\*

• OBJ-01 — Centralizar y coordinar la gestión de pedidos entre las áreas operativas

• OBJ-03 — Gestionar cobros, cuenta corriente y operación financiera del negocio

• OBJ-04 — Habilitar la venta directa a clientes mediante un canal online

\*\*Requisitos Asociados\*\*

Requisitos funcionales: RF-03, RF-06, RF-12, RF-13, RF-14, RF-15, RF-16, RF-18, RF-20

Casos de uso: UC-06, UC-22, UC-23, UC-24, UC-27, UC-30

\*\*Descripción\*\*

El sistema deberá almacenar y permitir consultar la información correspondiente a cobros, caja y reembolsos. cobro, preservando las relaciones y referencias necesarias para los procesos asociados.

\*\*Datos Específicos\*\*

• Cliente, fecha/hora, importe, medio, origen, referencia, estado. MovimientoCaja: tipo, importe, fecha/hora, concepto, origen, referencia. Reembolso: Cobro original, importe, fecha/hora, motivo, estado, referencia.

• MovimientoCaja manual: concepto obligatorio, observación opcional. Mantener origen, referencia y fecha/hora para ingresos y egresos; un Reembolso rechazado o pendiente no produce egreso efectivo y no deshace la Cancelación.

\*\*Estabilidad\*\*

Alta (estimación de análisis).

\*\*Comentarios\*\*

Datos originales conservados de A\_Requisitos.md. Ampliación aprobada: DEC-P2-011; DEC-P2-006. Las relaciones de CU y objetivos incluyen vínculos de auditoría documental por ratificar; no añaden nuevos campos a esta ficha.


**ACTUALIZACIÓN DEL 20/10/2026 · IRQ-10.** FIN-03/FIN-04: no existen reembolsos parciales; historia de intentos y como máximo una devolución completa efectiva de un Cobro. Idempotencia técnica de Reembolso en conflicto explícito con RF-18/RNF-04, no eliminada.



ENMIENDA APROBADA 21/10 — FIN-03/04: Cobro electrónico 0..1 Reembolso lógico; Reembolso 1 Cobro, devolución completa, estados PENDIENTE/RECHAZADO/PROCESADO, reintentos en la misma instancia, referencia e historial. La suma de importes de reembolsos PENDIENTES y PROCESADOS no supera el Cobro original; solo PROCESADO genera efectos financieros una vez.
\---

\#\#\# IRQ-11 — Excedentes y Reasignaciones

\*\*Origen:\*\* DOCX consolidado, ficha 32 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Objetivos Asociados\*\*

• OBJ-01 — Centralizar y coordinar la gestión de pedidos entre las áreas operativas

• OBJ-02 — Sistematizar la gestión de productos, insumos y abastecimiento

• OBJ-03 — Gestionar cobros, cuenta corriente y operación financiera del negocio

\*\*Requisitos Asociados\*\*

Requisitos funcionales: RF-02, RF-03, RF-04, RF-06, RF-13, RF-18, RF-19

Casos de uso: UC-05, UC-06, UC-07, UC-42

\*\*Descripción\*\*

El sistema deberá almacenar y permitir consultar la información correspondiente a excedentes y reasignaciones, preservando las relaciones y referencias necesarias para los procesos asociados.

\*\*Datos Específicos\*\*

• Producto, Pedido origen, cantidad inicial y disponible, fecha, estado, candidatos, Pedido receptor, cantidad y fecha reasignada.

• Conservar costos históricos y cantidades inicial/disponible de Excedente; movimientos de reasignación y descarte, con cantidad positiva no superior al saldo disponible, motivo obligatorio al descartar y estado de agotamiento.

\*\*Estabilidad\*\*

Media (estimación de análisis).

\*\*Comentarios\*\*

Datos originales conservados de A\_Requisitos.md. Ampliación aprobada: DEC-P2-005; DEC-P2-006; DEC-P2-010. Las relaciones de CU y objetivos incluyen vínculos de auditoría documental por ratificar; no añaden nuevos campos a esta ficha.


**ACTUALIZACIÓN DEL 20/10/2026 · IRQ-11.** EXC-01 a EXC-05: movimientos por reasignación/descarte, costo histórico proporcional; el Pedido receptor tiene totalOriginal inmutable e incrementos comerciales que componen totalVigente.



ENMIENDA APROBADA 21/10 — EXC-OFER-01 / EXC-CC-01: Oferta registra importe informado, cantidad y respuesta; si cambia cantidad antes de confirmar, recalcular y obtener nueva aceptación, sin imponer creación de una clase/versionado adicional. MovimientoExcedente REASIGNACION conserva valor económico confirmado y costo. UC-07 no registra cargo de Cuenta Corriente.
\---

\#\#\# IRQ-12 — Promociones y Comunicaciones

\*\*Origen:\*\* DOCX consolidado, ficha 33 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Objetivos Asociados\*\*

• OBJ-03 — Gestionar cobros, cuenta corriente y operación financiera del negocio

• OBJ-04 — Habilitar la venta directa a clientes mediante un canal online

\*\*Requisitos Asociados\*\*

Requisitos funcionales: RF-12, RF-14, RF-16, RF-20

Casos de uso: UC-22, UC-25

\*\*Descripción\*\*

El sistema deberá almacenar y permitir consultar la información correspondiente a promociones y comunicaciones, preservando las relaciones y referencias necesarias para los procesos asociados.

\*\*Datos Específicos\*\*

• Promoción, Producto, condición, vigencia, estado, destinatarios, fecha de envío, resultado por destinatario, acceso/canal online.

• Registrar descuento porcentual, vigencia, Productos, destinatarios, fecha y estado de cada comunicación, con control de reintentos que no dupliquen envíos confirmados.

\*\*Estabilidad\*\*

Media (estimación de análisis).

\*\*Comentarios\*\*

Datos originales conservados de A\_Requisitos.md. Ampliación aprobada: DEC-P2-002. Las relaciones de CU y objetivos incluyen vínculos de auditoría documental por ratificar; no añaden nuevos campos a esta ficha.


**ACTUALIZACIÓN DEL 20/10/2026 · IRQ-12.** COM-01 a COM-04: una única promoción por DetallePedido; productos, destinatarios e intentos históricos de comunicación con no duplicación de confirmados.

\---

\#\#\# IRQ-13 — Ruteo y Reparto

\*\*Origen:\*\* DOCX consolidado, ficha 34 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Objetivos Asociados\*\*

• OBJ-01 — Centralizar y coordinar la gestión de pedidos entre las áreas operativas

\*\*Requisitos Asociados\*\*

Requisitos funcionales: RF-01, RF-17

Casos de uso: UC-04, UC-26, UC-44

\*\*Descripción\*\*

El sistema deberá almacenar y permitir consultar la información correspondiente a ruteo y reparto, preservando las relaciones y referencias necesarias para los procesos asociados.

\*\*Datos Específicos\*\*

• Pedido, Cliente, dirección, fecha, estado, referencia geográfica, secuencia sugerida, fecha/hora de generación.

• Conservar fecha, Repartidor, lista de asignaciones consideradas, secuencia sugerida y fecha/hora de generación, más información para detectar obsolescencia por reasignación.

\*\*Estabilidad\*\*

Media (estimación de análisis).

\*\*Comentarios\*\*

Datos originales conservados de A\_Requisitos.md. Ampliación aprobada: DEC-P2-008. Las relaciones de CU y objetivos incluyen vínculos de auditoría documental por ratificar; no añaden nuevos campos a esta ficha.


**ACTUALIZACIÓN DEL 20/10/2026 · IRQ-13.** PED-04: RutaSugerida es clase conceptual, con secuencia, Repartidor, fecha/hora y asignaciones consideradas; no reescribir rutas históricas si se vuelven obsoletas.



NOTA DE COHERENCIA 21/10 — RutaSugerida ratificada como clase conceptual, vinculada al Repartidor, fecha, secuencia y conjunto de asignaciones; MDALE todavía no la muestra.
\---

\#\#\# IRQ-14 — Histórico para Margen

\*\*Origen:\*\* DOCX consolidado, ficha 35 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Objetivos Asociados\*\*

• OBJ-03 — Gestionar cobros, cuenta corriente y operación financiera del negocio

\*\*Requisitos Asociados\*\*

Requisitos funcionales: RF-19

Casos de uso: UC-28

\*\*Descripción\*\*

El sistema deberá almacenar y permitir consultar la información correspondiente a histórico para margen, preservando las relaciones y referencias necesarias para los procesos asociados.

\*\*Datos Específicos\*\*

• cantidades vendidas, precio histórico, ajuste, consumos de Insumos, costo histórico de Insumos, costo de adquisición de REVENTA, fecha, fuente del costo.

• Conservar las cantidades efectivamente vendidas, los importes y ajustes congelados y los costos históricos atribuibles a ELABORADO/REVENTA, separando descarte de costo de ventas.

\*\*Estabilidad\*\*

Media (estimación de análisis).

\*\*Comentarios\*\*

Datos originales conservados de A\_Requisitos.md. Ampliación aprobada: DEC-P2-005; DEC-P2-010. Las relaciones de CU y objetivos incluyen vínculos de auditoría documental por ratificar; no añaden nuevos campos a esta ficha.

\---

\#\# Requisitos No Funcionales

\#\#\# RNF-01 — Control de acceso por roles

\*\*Origen:\*\* DOCX consolidado, ficha 36 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Objetivos Asociados\*\*

• OBJ-01 — Centralizar y coordinar la gestión de pedidos entre las áreas operativas

• OBJ-02 — Sistematizar la gestión de productos, insumos y abastecimiento

• OBJ-03 — Gestionar cobros, cuenta corriente y operación financiera del negocio

• OBJ-04 — Habilitar la venta directa a clientes mediante un canal online

\*\*Requisitos Asociados\*\*

RF relacionados: RF-01, RF-02, RF-03, RF-04, RF-05, RF-06, RF-07, RF-08, RF-09, RF-10, RF-11, RF-12, RF-13, RF-14, RF-15, RF-16, RF-17, RF-18, RF-19, RF-20, RF-21

\*\*Descripción\*\*

El sistema deberá rechazar el 100 % de los accesos no autorizados, verificando permisos también en el backend y no únicamente en la interfaz.

\*\*Comentarios\*\*

Se conserva el valor indicado por la línea base. La aplicabilidad a otros requisitos procede de la matriz de auditoría.

\---

\#\#\# RNF-02 — Credenciales

\*\*Origen:\*\* DOCX consolidado, ficha 37 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Objetivos Asociados\*\*

• OBJ-01 — Centralizar y coordinar la gestión de pedidos entre las áreas operativas

• OBJ-03 — Gestionar cobros, cuenta corriente y operación financiera del negocio

• OBJ-04 — Habilitar la venta directa a clientes mediante un canal online

\*\*Requisitos Asociados\*\*

RF relacionados: RF-08, RF-10, RF-12, RF-14, RF-16, RF-20

\*\*Descripción\*\*

El sistema deberá proteger las credenciales mediante hash adaptativo con sal y nunca almacenarlas en texto plano; la autenticación deberá utilizar HTTPS.

\*\*Comentarios\*\*

Se conserva el valor indicado por la línea base. La aplicabilidad a otros requisitos procede de la matriz de auditoría.

\---

\#\#\# RNF-03 — Offline para Ventas

\*\*Origen:\*\* DOCX consolidado, ficha 38 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Objetivos Asociados\*\*

• OBJ-01 — Centralizar y coordinar la gestión de pedidos entre las áreas operativas

• OBJ-02 — Sistematizar la gestión de productos, insumos y abastecimiento

• OBJ-03 — Gestionar cobros, cuenta corriente y operación financiera del negocio

\*\*Requisitos Asociados\*\*

RF relacionados: RF-01, RF-04, RF-09, RF-10, RF-12

\*\*Descripción\*\*

El sistema deberá permitir que Ventas continúe las operaciones previstas sin conectividad cuando sea técnicamente posible y señalar cuándo las consultas muestran la última información sincronizada.

\*\*Comentarios\*\*

Se conserva el valor indicado por la línea base. La aplicabilidad a otros requisitos procede de la matriz de auditoría.

\---

\#\#\# RNF-04 — Sincronización idempotente

\*\*Origen:\*\* DOCX consolidado, ficha 39 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Objetivos Asociados\*\*

• OBJ-01 — Centralizar y coordinar la gestión de pedidos entre las áreas operativas

• OBJ-02 — Sistematizar la gestión de productos, insumos y abastecimiento

• OBJ-03 — Gestionar cobros, cuenta corriente y operación financiera del negocio

• OBJ-04 — Habilitar la venta directa a clientes mediante un canal online

\*\*Requisitos Asociados\*\*

RF relacionados: RF-01, RF-05, RF-06, RF-09, RF-11, RF-12, RF-14, RF-15, RF-16, RF-18, RF-20

\*\*Descripción\*\*

La repetición o reenvío de una misma operación no deberá duplicar Pedidos ni efectos de Cobros, pagos ONLINE o Reembolsos; las operaciones de sincronización deberán ser idempotentes.

\*\*Comentarios\*\*

Se conserva el valor indicado por la línea base. La aplicabilidad a otros requisitos procede de la matriz de auditoría.


**REGISTRO HISTÓRICO 20/10 — RNF-04.** La aparente contradicción «sin idempotencia» quedó RESUELTA el 21/10: el requisito de idempotencia permanece; solo las claves, tokens y algoritmos técnicos no forman parte del Modelo de Dominio.



ACLARACIÓN APROBADA 21/10 — FIN-03/04: RNF-04 conserva plenamente su exigencia de idempotencia de reenvíos y de aplicación de efectos una sola vez; el Modelo de Dominio representa ese efecto como invariante y no mediante tokens ni algoritmos técnicos.
\---

\#\#\# RNF-05 — Integridad transaccional

\*\*Origen:\*\* DOCX consolidado, ficha 40 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Objetivos Asociados\*\*

• OBJ-01 — Centralizar y coordinar la gestión de pedidos entre las áreas operativas

• OBJ-02 — Sistematizar la gestión de productos, insumos y abastecimiento

• OBJ-03 — Gestionar cobros, cuenta corriente y operación financiera del negocio

• OBJ-04 — Habilitar la venta directa a clientes mediante un canal online

\*\*Requisitos Asociados\*\*

RF relacionados: RF-01, RF-02, RF-03, RF-04, RF-05, RF-06, RF-11, RF-12, RF-13, RF-14, RF-15, RF-16, RF-17, RF-18, RF-19, RF-20, RF-21

\*\*Descripción\*\*

Las operaciones que afecten simultáneamente registros relacionados deberán mantener integridad transaccional, de modo que Cobros, Reembolsos y Preparaciones confirmen todos sus efectos o ninguno.

\*\*Comentarios\*\*

Se conserva el valor indicado por la línea base. La aplicabilidad a otros requisitos procede de la matriz de auditoría.

\---

\#\#\# RNF-06 — Trazabilidad de operaciones críticas

\*\*Origen:\*\* DOCX consolidado, ficha 41 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Objetivos Asociados\*\*

• OBJ-01 — Centralizar y coordinar la gestión de pedidos entre las áreas operativas

• OBJ-02 — Sistematizar la gestión de productos, insumos y abastecimiento

• OBJ-03 — Gestionar cobros, cuenta corriente y operación financiera del negocio

• OBJ-04 — Habilitar la venta directa a clientes mediante un canal online

\*\*Requisitos Asociados\*\*

RF relacionados: RF-01, RF-02, RF-03, RF-04, RF-05, RF-06, RF-07, RF-08, RF-09, RF-10, RF-11, RF-12, RF-13, RF-14, RF-15, RF-16, RF-17, RF-18, RF-19, RF-20, RF-21

\*\*Descripción\*\*

El sistema deberá conservar trazabilidad de las operaciones críticas mediante fecha y hora, tipo de operación, referencia e identificación de Usuario o proceso automático responsable.

\*\*Comentarios\*\*

Se conserva el valor indicado por la línea base. La aplicabilidad a otros requisitos procede de la matriz de auditoría.

\---

\#\#\# RNF-07 — Tolerancia a fallos externos

\*\*Origen:\*\* DOCX consolidado, ficha 42 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Objetivos Asociados\*\*

• OBJ-01 — Centralizar y coordinar la gestión de pedidos entre las áreas operativas

• OBJ-02 — Sistematizar la gestión de productos, insumos y abastecimiento

• OBJ-03 — Gestionar cobros, cuenta corriente y operación financiera del negocio

• OBJ-04 — Habilitar la venta directa a clientes mediante un canal online

\*\*Requisitos Asociados\*\*

RF relacionados: RF-03, RF-05, RF-06, RF-11, RF-12, RF-13, RF-14, RF-15, RF-16, RF-17, RF-18, RF-20

\*\*Descripción\*\*

El sistema deberá tolerar fallas de los servicios externos de pagos, mensajería y ruteo sin corromper datos internos, permitiendo degradación controlada y reintentos cuando corresponda.

\*\*Comentarios\*\*

Se conserva el valor indicado por la línea base. La aplicabilidad a otros requisitos procede de la matriz de auditoría.

\---

\#\#\# RNF-08 — Tiempo de respuesta (provisorio)

\*\*Origen:\*\* DOCX consolidado, ficha 43 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Objetivos Asociados\*\*

• OBJ-01 — Centralizar y coordinar la gestión de pedidos entre las áreas operativas

• OBJ-02 — Sistematizar la gestión de productos, insumos y abastecimiento

• OBJ-03 — Gestionar cobros, cuenta corriente y operación financiera del negocio

• OBJ-04 — Habilitar la venta directa a clientes mediante un canal online

\*\*Requisitos Asociados\*\*

RF relacionados: RF-01, RF-02, RF-03, RF-04, RF-05, RF-06, RF-07, RF-08, RF-09, RF-10, RF-11, RF-12, RF-13, RF-14, RF-15, RF-16, RF-17, RF-18, RF-19, RF-20, RF-21

\*\*Descripción\*\*

Como objetivo provisional, al menos el 95 % de las operaciones habituales deberán responder en tres segundos o menos, sin contar el tiempo atribuible a servicios externos. El valor requiere validación académica.

\*\*Comentarios\*\*

Se conserva el valor indicado por la línea base. La aplicabilidad a otros requisitos procede de la matriz de auditoría. Parámetro provisional: requiere validar su factibilidad; no constituye una medición.

\---

\#\#\# RNF-09 — Sincronización (provisorio)

\*\*Origen:\*\* DOCX consolidado, ficha 44 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Objetivos Asociados\*\*

• OBJ-01 — Centralizar y coordinar la gestión de pedidos entre las áreas operativas

• OBJ-03 — Gestionar cobros, cuenta corriente y operación financiera del negocio

\*\*Requisitos Asociados\*\*

RF relacionados: RF-01, RF-09, RF-12

\*\*Descripción\*\*

Como objetivo provisional, el sistema deberá sincronizar hasta 50 operaciones pendientes en 60 segundos o menos cuando disponga de una conexión estable.

\*\*Comentarios\*\*

Se conserva el valor indicado por la línea base. La aplicabilidad a otros requisitos procede de la matriz de auditoría. Parámetro provisional: requiere validar su factibilidad; no constituye una medición.

\---

\#\#\# RNF-10 — Respaldo

\*\*Origen:\*\* DOCX consolidado, ficha 45 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Objetivos Asociados\*\*

No consta un vínculo verificable.

\*\*Requisitos Asociados\*\*

RF relacionados: No consta

\*\*Descripción\*\*

El sistema deberá realizar respaldos automáticos diarios y respaldos completos quincenales, almacenados en una ubicación diferente de la principal.

\*\*Comentarios\*\*

Se conserva el valor indicado por la línea base. La aplicabilidad a otros requisitos procede de la matriz de auditoría.

\---

\#\#\# RNF-11 — Recuperación (provisorio)

\*\*Origen:\*\* DOCX consolidado, ficha 46 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Objetivos Asociados\*\*

No consta un vínculo verificable.

\*\*Requisitos Asociados\*\*

RF relacionados: No consta

\*\*Descripción\*\*

Como objetivo provisional, el plan de recuperación deberá contemplar un RPO de 24 horas o menos y un RTO de cuatro horas o menos.

\*\*Comentarios\*\*

Se conserva el valor indicado por la línea base. La aplicabilidad a otros requisitos procede de la matriz de auditoría. Parámetro provisional: requiere validar su factibilidad; no constituye una medición.

\---

\#\#\# RNF-12 — Android gama baja/media

\*\*Origen:\*\* DOCX consolidado, ficha 47 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Objetivos Asociados\*\*

• OBJ-01 — Centralizar y coordinar la gestión de pedidos entre las áreas operativas

• OBJ-02 — Sistematizar la gestión de productos, insumos y abastecimiento

• OBJ-03 — Gestionar cobros, cuenta corriente y operación financiera del negocio

\*\*Requisitos Asociados\*\*

RF relacionados: RF-01, RF-02, RF-04, RF-05, RF-06, RF-09, RF-12, RF-13, RF-15, RF-17, RF-19, RF-20, RF-21

\*\*Descripción\*\*

La aplicación Android deberá diseñarse y probarse para dispositivos de gama baja o media, tomando provisionalmente como referencia Android 10 o superior y 3 GB de memoria RAM; Samsung Galaxy A13 es una referencia de prueba, no un equipo exclusivo.

\*\*Comentarios\*\*

Se conserva el valor indicado por la línea base. La aplicabilidad a otros requisitos procede de la matriz de auditoría.

\---

\#\#\# RNF-13 — Web

\*\*Origen:\*\* DOCX consolidado, ficha 48 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Objetivos Asociados\*\*

• OBJ-01 — Centralizar y coordinar la gestión de pedidos entre las áreas operativas

• OBJ-03 — Gestionar cobros, cuenta corriente y operación financiera del negocio

• OBJ-04 — Habilitar la venta directa a clientes mediante un canal online

\*\*Requisitos Asociados\*\*

RF relacionados: RF-08, RF-10, RF-12, RF-14, RF-16, RF-20

\*\*Descripción\*\*

La aplicación web deberá verificarse en las dos versiones estables más recientes de Google Chrome y Microsoft Edge.

\*\*Comentarios\*\*

Se conserva el valor indicado por la línea base. La aplicabilidad a otros requisitos procede de la matriz de auditoría.

\---

\#\#\# RNF-14 — Usabilidad (provisorio)

\*\*Origen:\*\* DOCX consolidado, ficha 49 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Objetivos Asociados\*\*

• OBJ-01 — Centralizar y coordinar la gestión de pedidos entre las áreas operativas

• OBJ-03 — Gestionar cobros, cuenta corriente y operación financiera del negocio

\*\*Requisitos Asociados\*\*

RF relacionados: RF-01, RF-06, RF-09, RF-12

\*\*Descripción\*\*

Como objetivo provisional de usabilidad, al menos el 90 % de las tareas principales deberán completarse sin asistencia después de una explicación inicial de hasta 30 minutos.

\*\*Comentarios\*\*

Se conserva el valor indicado por la línea base. La aplicabilidad a otros requisitos procede de la matriz de auditoría. Parámetro provisional: requiere validar su factibilidad; no constituye una medición.

\---

\#\#\# RNF-15 — Crecimiento (provisorio)

\*\*Origen:\*\* DOCX consolidado, ficha 50 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Objetivos Asociados\*\*

No consta un vínculo verificable.

\*\*Requisitos Asociados\*\*

RF relacionados: No consta

\*\*Descripción\*\*

Como objetivo provisional de capacidad, el sistema deberá mantener el rendimiento de RNF-08 con al menos 20 Usuarios concurrentes.

\*\*Comentarios\*\*

Se conserva el valor indicado por la línea base. La aplicabilidad a otros requisitos procede de la matriz de auditoría. Parámetro provisional: requiere validar su factibilidad; no constituye una medición.

\---

\#\#\# RNF-16 — Configurabilidad

\*\*Origen:\*\* DOCX consolidado, ficha 51 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Objetivos Asociados\*\*

• OBJ-02 — Sistematizar la gestión de productos, insumos y abastecimiento

• OBJ-03 — Gestionar cobros, cuenta corriente y operación financiera del negocio

• OBJ-04 — Habilitar la venta directa a clientes mediante un canal online

\*\*Requisitos Asociados\*\*

RF relacionados: RF-01, RF-05, RF-06, RF-07, RF-09, RF-11, RF-12, RF-14, RF-16

\*\*Descripción\*\*

El sistema deberá permitir configurar catálogo, unidades de medida, precios, Recetas, umbrales, Proveedores y parámetros comerciales, evitando valores fijos incrustados en el código.

\*\*Comentarios\*\*

Se conserva el valor indicado por la línea base. La aplicabilidad a otros requisitos procede de la matriz de auditoría.

\---

\#\#\# RNF-17 — Adaptabilidad

\*\*Origen:\*\* DOCX consolidado, ficha 52 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Objetivos Asociados\*\*

• OBJ-01 — Centralizar y coordinar la gestión de pedidos entre las áreas operativas

• OBJ-02 — Sistematizar la gestión de productos, insumos y abastecimiento

\*\*Requisitos Asociados\*\*

RF relacionados: RF-05, RF-07, RF-11, RF-17

\*\*Descripción\*\*

El sistema deberá evitar dependencias rígidas de la denominación Ale Milanesas, el producto milanesa, una unidad en kilogramos o días de reparto concretos, y permitir su adaptación mediante configuración y datos, sin imponer alcance multiempresa o SaaS.

\*\*Comentarios\*\*

Se conserva el valor indicado por la línea base. La aplicabilidad a otros requisitos procede de la matriz de auditoría.

\---

\#\# Requisitos Funcionales

\#\#\# RF-01 — Gestionar Pedidos

\*\*Origen:\*\* ficha consolidada; actualización por decisiones de la conversación 11/10–19/10/2026.

\*\*Objetivos Asociados\*\*

• OBJE-01 — Unificar la gestión de Pedidos  

• OBJE-02 — Permitir la operación de Ventas ante ausencia de conectividad

\*\*Requisitos Asociados\*\*

Casos de uso:  

• UC-03 — Cargar Pedido  

• UC-04 — Consultar Pedidos Asignados  

• UC-17 — Aplicar Ajuste Comercial según Categoría  

• UC-35 — Buscar Pedido  

• UC-44 — Asignar y Reasignar Pedidos a Repartidores  

Información vinculada: IRQ-05, IRQ-13

\*\*Descripción\*\*

El sistema deberá registrar, consultar y gestionar Pedidos con uno o más Productos y sus Detalles, conservando cantidades, precios unitarios históricos, \`canalOrigen\`, fecha de reparto, estado y ajustes comerciales. Deberá admitir operación de Ventas sin conexión y sincronización posterior sin duplicados. El Vendedor asignará o reasignará a un único Repartidor vigente los Pedidos \`PENDIENTE\` con \`canalOrigen\` \`INTERNO\` u \`ONLINE\`; conservará el historial mediante \`AsignacionReparto\`, con fecha/hora, responsable, Repartidor anterior, Repartidor nuevo y motivo de reasignación. Asignar no constituye un nuevo estado del Pedido.

\*\*Comentarios\*\*

La denominación \`canalOrigen\` reemplaza al atributo ambiguo \`origen\` exclusivamente para Pedido.


**ACTUALIZACIÓN DEL 20/10/2026 · RF-01.** EXC-05 / PED-01 a PED-05: Pedido conserva totalOriginal confirmado y totalVigente derivado como totalOriginal más incrementos comerciales trazables de reasignaciones aceptadas (UC-07). Los demás precios, descuentos y ajustes congelados no se reescriben. El historial de AsignacionReparto y RutaSugerida aprobada permanece por Pedido, Repartidor y fecha. Se mantienen pendientes los efectos precisos sobre prepago ONLINE y promociones en incrementos.



ENMIENDA APROBADA 21/10 — EXC-05 / EXC-DET-01: conservar total original y registrar incrementos confirmados por reasignación con importes históricos; distinguir cantidad originalmente acordada de incorporaciones posteriores sin exigir un atributo técnico cantidadVigente nuevo. La imputación comercial de una entrega parcial prioriza cantidad original.
\---

\#\#\# RF-02 — Registrar Entregas

\*\*Origen:\*\* DOCX consolidado, ficha 54 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Objetivos Asociados\*\*

• OBJE-01 — Unificar la gestión de Pedidos

• OBJE-10 — Registrar Cobros y mantener la Cuenta Corriente de los Clientes

\*\*Requisitos Asociados\*\*

Casos de uso:

• UC-05 — Registrar Entrega

Información vinculada: IRQ-05, IRQ-06, IRQ-09

\*\*Descripción\*\*

El sistema deberá registrar las cantidades entregadas por DetallePedido sin superar las solicitadas, determinar la venta efectiva a precios históricos, generar el cargo en Cuenta Corriente y descontar exclusivamente las existencias de Productos de REVENTA; la Entrega no consume Insumos. Se registrará una sola Entrega definitiva por Pedido, con cantidades efectivamente entregadas por Detalle. La venta efectiva aplicará el precio histórico, la Promoción porcentual congelada por Detalle y el ajuste comercial global congelado; generará solo el cargo correspondiente. En entregas parciales de Pedidos ONLINE prepagados, la diferencia permanecerá como saldo a favor y no provocará por sí sola un Reembolso. Validará la asignación vigente del Repartidor.

\*\*Comentarios\*\*

Actualización respaldada por DEC-P2-005; DEC-P2-008. La distribución entre CU y las asociaciones de IRQ proceden de la matriz de auditoría; ratificar en la línea base global.


**ACTUALIZACIÓN DEL 20/10/2026 · RF-02.** PED-02 / INV-03: una Entrega definitiva como máximo por Pedido; movimientos de inventario REVENTA solo al entregar; Insumos se consumen en Preparacion. El total comercial vigente incorpora únicamente incrementos aceptados conforme a EXC-05, sin modificar el total original.



ENMIENDA APROBADA 21/10 — EXC-CC-01 / EXC-DET-01: UC-05 origina el CARGO_POR_VENTA únicamente por cantidad efectivamente entregada, distinguiendo las originalmente promocionadas de las añadidas por Excedente. La fórmula/promoción en entregas parciales requiere armonización expresa con UC-05; no generar cargos al aceptar una reasignación.
\---

\#\#\# RF-03 — Cancelar Pedidos

\*\*Origen:\*\* DOCX consolidado, ficha 55 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Objetivos Asociados\*\*

• OBJE-01 — Unificar la gestión de Pedidos

• OBJE-05 — Facilitar la redistribución de excedentes de producción

• OBJE-17 — Gestionar Reembolsos de Cobros electrónicos

\*\*Requisitos Asociados\*\*

Casos de uso:

• UC-06 — Cancelar Pedido

Información vinculada: IRQ-05, IRQ-10, IRQ-11

\*\*Descripción\*\*

El sistema deberá permitir cancelar Pedidos no entregados con motivo y trazabilidad, identificar Elaborados preparados sin destino y determinar si corresponde solicitar un Reembolso electrónico; no se revertirán consumos de Insumos ya realizados. Solo podrá cancelarse un Pedido PENDIENTE, registrando motivo. La cancelación conservará Preparaciones y consumos, registrará Excedente disponible con costo histórico y podrá solicitar un Reembolso de Cobro electrónico elegible sin depender de su resultado; UC de reasignación o descarte se ejecutarán posteriormente.

\*\*Comentarios\*\*

Actualización respaldada por DEC-P2-006. La distribución entre CU y las asociaciones de IRQ proceden de la matriz de auditoría; ratificar en la línea base global.



ENMIENDA APROBADA 21/10 — EXC-CANC-01: cuando se cancela Pedido receptor, los ELABORADOS reasignados aún disponibles se conservan como un Excedente nuevo, con origen en ese Pedido y costo histórico sin duplicación de consumos. No reabrir el Excedente anterior.
\---

\#\#\# RF-04 — Gestionar Inventario

\*\*Origen:\*\* DOCX consolidado, ficha 56 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Objetivos Asociados\*\*

• OBJE-07 — Sistematizar la preparación de Productos elaborados y el control de Insumos

\*\*Requisitos Asociados\*\*

Casos de uso:

• UC-05 — Registrar Entrega

• UC-08 — Registrar Ingreso de Stock por Compra

• UC-09 — Consultar Stock

• UC-29 — Registrar Preparación de Pedido

• UC-37 — Buscar Insumo

• UC-43 — Registrar Ajuste de Inventario

Información vinculada: IRQ-06

\*\*Descripción\*\*

El sistema deberá gestionar separadamente los inventarios de Insumos y Productos de REVENTA, manteniendo existencias y movimientos trazables de ingresos, consumos y ajustes. Los Productos ELABORADOS no se administrarán como stock general terminado. Los ingresos por compra, consumos de producción y ajustes físicos tendrán movimientos diferenciados. Los Insumos inactivos no dispararán compras automáticas. La consulta mostrará separadamente Insumos y Productos de REVENTA.

\*\*Comentarios\*\*

Actualización respaldada por DEC-P2-001. La distribución entre CU y las asociaciones de IRQ proceden de la matriz de auditoría; ratificar en la línea base global.



ENMIENDA APROBADA 21/10 — INV-04 / REC-PROV-01: distinguir la recepción física del acto de emitir Orden, acumular recepciones parciales sin superar cantidad ordenada; compras sin Orden preservan Proveedor registrado cuando se conozca o referencia comercial de origen.
\---

\#\#\# RF-05 — Gestionar Recetas, Umbrales y Reposición

\*\*Origen:\*\* ficha consolidada; actualización por decisiones de la conversación 11/10–19/10/2026.

\*\*Objetivos Asociados\*\*

• OBJE-07 — Sistematizar la preparación de Productos elaborados y el control de Insumos  

• OBJE-09 — Gestionar cotizaciones y asistir la decisión de compra a Proveedores

\*\*Requisitos Asociados\*\*

Casos de uso:  

• UC-10 — Configurar Receta de Producto  

• UC-29 — Registrar Preparación de Pedido  

• UC-32 — Configurar Parámetros de Reposición de Insumo  

• UC-37 — Buscar Insumo  

• UC-43 — Registrar Ajuste de Inventario  

• UC-45 — Iniciar Ronda Manual de Cotización  

Información vinculada: IRQ-06, IRQ-07, IRQ-08

\*\*Descripción\*\*

El sistema deberá gestionar Recetas versionadas de Productos \`ELABORADO\` y parámetros configurables de reposición de Insumos. \`umbralMinimo\`, \`nivelObjetivoReposicion\` y \`automatizacionCompraActiva\` pertenecen al Insumo y no a la Receta; \`nivelObjetivoReposicion\` debe ser mayor que \`umbralMinimo\`.

Cuando un movimiento de stock produce el flanco \`stockActual \>= umbralMinimo\` → \`stockActual \< umbralMinimo\`, con automatización activa, Insumo activo y al menos un Proveedor invitable, el sistema podrá emitir \*\*como máximo una primera ronda automática por episodio de faltante\*\*. La cantidad se calcula con el stock vigente (\`nivelObjetivoReposicion \- stockActual\`) y queda congelada al emitir. Si no existen destinatarios invitables, no se crea una Solicitud ficticia ni se consume la oportunidad automática; se genera una alerta para intervención administrativa.

Los cambios de configuración rigen hacia adelante: subir el umbral, activar la automatización con stock ya bajo o habilitar posteriormente un Proveedor no dispara una solicitud retroactiva; cambiar el nivel objetivo no modifica solicitudes ya emitidas. Mientras persista el mismo episodio, toda nueva ronda es manual mediante UC-45. El episodio solo se considera cerrado cuando el stock se recupera hasta el umbral y no quedan Solicitudes en curso ni Órdenes pendientes de recepción asociadas.

\*\*Comentarios\*\*

\`Episodio de faltante\` y la alerta son reglas/información de control; no se incorporan por sí mismas como clases conceptuales. La generación de una ronda de cotización no equivale a generar una Orden de Compra.


**ACTUALIZACIÓN DEL 20/10/2026 · RF-05.** COT-17 a COT-20, PROD-01 a PROD-05: versionado de Recetas y cantidad de Solicitud congelada; la primera ronda automática no autoriza compra. Solicitud fuera de plazo rechaza nuevas respuestas; sin cancelación anticipada en el alcance actual. La cadena es lineal, sin ramificaciones, y conserva un mismo Insumo.

\---

\#\#\# RF-06 — Gestionar Cuenta Corriente

\*\*Origen:\*\* DOCX consolidado, ficha 58 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Objetivos Asociados\*\*

• OBJE-10 — Registrar Cobros y mantener la Cuenta Corriente de los Clientes

\*\*Requisitos Asociados\*\*

Casos de uso:

• UC-05 — Registrar Entrega

• UC-15 — Consultar Cuenta Corriente

• UC-16 — Evaluar y Actualizar Categoría Comercial

• UC-27 — Procesar Reembolso Electrónico

• UC-50 — Registrar Resultado de Reembolso Electrónico

• UC-30 — Registrar Cobro

Información vinculada: IRQ-09

\*\*Descripción\*\*

El sistema deberá registrar y consultar los movimientos de Cuenta Corriente por Cliente, incluidos CARGO\_POR\_VENTA, PAGO, AJUSTE\_DEBITO y AJUSTE\_CREDITO; determinará el saldo deudor o a favor, el saldo resultante y la antigüedad de la deuda cuando corresponda. Se permitirá consultar el saldo actual de Cliente y filtrar su historial por período, sin alterar ni reemplazar el saldo actual mostrado.

\*\*Comentarios\*\*

Actualización respaldada por DEC-P2-011. La distribución entre CU y las asociaciones de IRQ proceden de la matriz de auditoría; ratificar en la línea base global.


**ACTUALIZACIÓN DEL 20/10/2026 · RF-06.** FIN-01 a FIN-04: MovimientoCuenta sigue siendo fuente histórica; Reembolso completo PROCESADO produce efectos financieros, PENDIENTE/RECHAZADO no los produce. La no duplicación de efectos permanece obligatoria aunque la exclusión de idempotencia requiere resolución documental en RF-18/RNF-04.

\---

\#\#\# RF-07 — Gestionar Catálogo de Productos

\*\*Origen:\*\* DOCX consolidado, ficha 59 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Objetivos Asociados\*\*

• OBJE-08 — Gestionar un catálogo de Productos

\*\*Requisitos Asociados\*\*

Casos de uso:

• UC-31 — Registrar Producto

• UC-48 — Modificar Producto

• UC-49 — Cambiar Estado de Producto

• UC-36 — Buscar Producto

Información vinculada: IRQ-03

\*\*Descripción\*\*

El sistema deberá administrar el catálogo de Productos, diferenciando ELABORADO y REVENTA, con nombre, unidad de venta, información comercial y estado activo/inactivo. El tipo de Producto y la unidad de venta solo podrán corregirse cuando no haya referencias dependientes; con historial quedarán bloqueados y se requerirá un Producto nuevo para operar con otra identidad. La desactivación conserva registros históricos, stock y Pedidos pendientes.

\*\*Comentarios\*\*

Actualización respaldada por DEC-P2-003. La distribución entre CU y las asociaciones de IRQ proceden de la matriz de auditoría; ratificar en la línea base global.

\---

\#\#\# RF-08 — Gestionar Usuarios y Roles

\*\*Origen:\*\* ficha consolidada; actualización por decisiones de la conversación 11/10–19/10/2026.

\*\*Objetivos Asociados\*\*

• OBJE-03 — Definir un esquema de Usuarios, roles y permisos

\*\*Requisitos Asociados\*\*

Casos de uso:  

• UC-01 — Iniciar sesión  

• UC-18 — Crear Usuario  

• UC-19 — Gestionar Asignaciones de Roles  

Información vinculada: IRQ-02, IRQ-08

\*\*Descripción\*\*

El sistema deberá registrar Usuarios, autenticar sus credenciales y controlar el acceso a funciones protegidas conforme a los Roles asignados. \*\*Todo Usuario debe poseer al menos un Rol.\*\* Al crear una cuenta, UC-18 incluye obligatoriamente UC-19 para seleccionar uno o más Roles en la misma operación; al modificar asignaciones no podrá dejar al Usuario sin Roles, aunque podrá sustituirlos en una única operación.

El catálogo incorpora el Rol \`PROVEEDOR\`. Una cuenta con ese Rol representa exactamente a un Proveedor, no combina Roles internos y solo accede a las Solicitudes de Cotización para las que su Proveedor fue invitado y a la registración de su propia respuesta. Un Proveedor puede tener cuentas históricas, pero como máximo una habilitada a la vez. Para estas cuentas se utiliza credencial temporal inicial, cambio obligatorio antes de responder, recuperación asistida por Administrador y revocación con invalidación de sesiones, sin borrar la trazabilidad.

\*\*Comentarios\*\*

Queda reemplazada la regla anterior que permitía autenticar Usuarios sin Roles. Los detalles de bloqueo de intentos, sesión y mecanismos criptográficos se rigen por RNF-01/RNF-02 y decisiones de diseño posteriores.

\---

\#\#\# RF-09 — Gestionar Precios

\*\*Origen:\*\* DOCX consolidado, ficha 61 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Objetivos Asociados\*\*

• OBJE-12 — Gestionar precios vigentes e historial de precios

\*\*Requisitos Asociados\*\*

Casos de uso:

• UC-03 — Cargar Pedido

• UC-20 — Actualizar Precio Vigente

• UC-21 — Consultar Historial de Precios

Información vinculada: IRQ-04

\*\*Descripción\*\*

El sistema deberá gestionar precios base de Productos mediante registros históricos de vigencia y determinar el precio aplicable en una fecha; el importe utilizado en cada venta se conservará en DetallePedido.precioUnitario. Los precios base se registran como versiones con vigencia inmediata o futura; no se permiten vigencias retroactivas ni superpuestas y el importe base nuevo debe ser positivo. La programación futura puede modificarse o cancelarse antes de su inicio, conservando auditoría; el precio de Pedidos ya registrados permanece congelado.

\*\*Comentarios\*\*

Actualización respaldada por DEC-P2-009. La distribución entre CU y las asociaciones de IRQ proceden de la matriz de auditoría; ratificar en la línea base global.

\---

\#\#\# RF-10 — Gestionar Clientes

\*\*Origen:\*\* DOCX consolidado, ficha 62 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Objetivos Asociados\*\*

• OBJE-01 — Unificar la gestión de Pedidos

\*\*Requisitos Asociados\*\*

Casos de uso:

• UC-02 — Registrar Cliente

• UC-33 — Modificar Cliente

• UC-34 — Buscar Cliente

• UC-39 — Cambiar Estado de Cliente

Información vinculada: IRQ-01

\*\*Descripción\*\*

El sistema deberá registrar, identificar, modificar y cambiar el estado de Clientes, manteniendo sus datos de contacto, dirección, zona y día habitual de reparto. Modificar datos del Cliente es distinto de cambiar su estado. La combinación normalizada nombre y teléfono evita duplicados, excepto el mismo registro. La desactivación requiere motivo, impide nuevos Pedidos, promociones y ofertas de Excedente, pero no elimina pendientes ni impide Cobros para regularizar la Cuenta Corriente.

\*\*Comentarios\*\*

Actualización respaldada por DEC-P2-004. La distribución entre CU y las asociaciones de IRQ proceden de la matriz de auditoría; ratificar en la línea base global.

\---

\#\#\# RF-11 — Gestionar Proveedores, Cotizaciones y Compras

\*\*Origen:\*\* ficha consolidada; actualización por decisiones de la conversación 11/10–19/10/2026.

\*\*Objetivos Asociados\*\*

• OBJE-09 — Gestionar cotizaciones y asistir la decisión de compra a Proveedores

\*\*Requisitos Asociados\*\*

Casos de uso vigentes:  

• UC-08 — Registrar Ingreso de Stock por Compra  

• UC-11 — Registrar Proveedor  

• UC-46 — Modificar Proveedor  

• UC-47 — Cambiar Estado de Proveedor  

• UC-12 — Evaluar Cotizaciones y Resolver Compra  

• UC-13 — Responder Solicitud de Cotización  

• UC-32 — Configurar Parámetros de Reposición de Insumo  

• UC-37 — Buscar Insumo  

• UC-38 — Buscar Proveedor  

• UC-40 — Cancelar Orden de Compra  

• UC-41 — Buscar Orden de Compra  

• UC-45 — Iniciar Ronda Manual de Cotización  

Información vinculada: IRQ-02, IRQ-06, IRQ-08

\*\*Descripción\*\*

El sistema deberá administrar Proveedores y sus asociaciones vigentes con Insumos, emitir y conservar Solicitudes de Cotización e invitaciones, permitir al Proveedor invitado registrar una única respuesta definitiva mediante el portal, evaluar alternativas con una \`PoliticaCompra\` configurable y asistir al Administrador en la resolución de la compra.

La selección y emisión de una \`OrdenCompra\` \*\*no es automática\*\*: UC-12 presenta las ofertas elegibles y su evaluación; el Administrador selecciona una alternativa, registra la justificación y confirma expresamente la compra. También puede cerrar una Solicitud con ofertas elegibles sin comprar, justificando la decisión. Si al finalizar la recepción no existen respuestas o ninguna oferta es elegible, el sistema cierra automáticamente la Solicitud con \`SIN\_RESPUESTAS\` o \`SIN\_OFERTAS\_ELEGIBLES\`, respectivamente, sin ejecutar UC-12.

La invitabilidad se evalúa al emitir y queda congelada: Proveedor \`ACTIVO\`, \`ProveedorInsumo\` vigente y Usuario habilitado vinculado. En rondas automáticas se invita a todos los invitables; en rondas manuales el Administrador selecciona un subconjunto no vacío. Los cambios posteriores no borran la invitación histórica; una cuenta deshabilitada no puede responder y una oferta de un Proveedor que ya no esté \`ACTIVO\` al decidir no es elegible para compra.

La primera ronda automática puede producirse una sola vez por episodio de faltante. Las rondas posteriores, incluidas las motivadas por cierre sin compra, cancelación de Orden o recepción insuficiente con stock aún bajo, requieren intervención del Administrador mediante UC-45.

\*\*Comentarios\*\*

UC-14 — Gestionar Excepción de Compra Automática queda \*\*HISTÓRICO / NO VIGENTE\*\* y su código no se reutiliza. Los antecedentes de cumplimiento afectan la evaluación de la oferta, no la invitación. Los pesos y fórmulas concretas de la política siguen pendientes si no fueron aprobados expresamente.


**ACTUALIZACIÓN DEL 20/10/2026 · RF-11.** AUD-COT-08 a AUD-COT-16 + COT-17 a COT-20: RespuestaCotizacion solo puede confirmarse hasta el vencimiento; después, el sistema rechaza registrarla. Debe provenir de Proveedor invitado y Usuario asociado, con unicidad definitiva por par (Solicitud,Proveedor). Oferta de cantidad inferior a cantidadSolicitada queda histórica pero inelegible; compra selecciona una oferta evaluada y elegible, por la cantidadSolicitada congelada. PoliticaCompra inmutable por versión; DecisionCompra resultado COMPRA/SIN_COMPRA, justificación obligatoria, máximo una por Solicitud; si COMPRA, exactamente una Orden y una Respuesta seleccionada; si SIN_COMPRA, ninguna. El cierre automático sin ofertas no crea DecisionCompra. Cancelación anticipada de Solicitud fuera del alcance actual.



ENMIENDA APROBADA 21/10 — COT-MOT-01: el cierre SIN_RESPUESTAS o SIN_OFERTAS_ELEGIBLES es automático, sin DecisionCompra; este último también puede producirse desde PENDIENTE_DECISION si la reevaluación deja cero ofertas elegibles. El cierre administrativo exige DecisionCompra.resultado SIN_COMPRA. INV-04: OrdenCompra.estado PENDIENTE|PARCIALMENTE_RECIBIDA|RECIBIDA|CANCELADA; cancelar solo desde los dos primeros, preservar recepciones y no disparar ronda automática. COT-17 sigue rechazando respuesta pasada el vencimiento.
\---

\#\#\# RF-12 — Gestionar Categoría Comercial y Precio Diferenciado

\*\*Origen:\*\* DOCX consolidado, ficha 64 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Objetivos Asociados\*\*

• OBJE-11 — Aplicar políticas comerciales según el historial de pago del Cliente

\*\*Requisitos Asociados\*\*

Casos de uso:

• UC-03 — Cargar Pedido

• UC-16 — Evaluar y Actualizar Categoría Comercial

• UC-17 — Aplicar Ajuste Comercial según Categoría

• UC-22 — Realizar Pedido Online

Información vinculada: IRQ-01, IRQ-05, IRQ-09

\*\*Descripción\*\*

El sistema deberá determinar categorías comerciales CUMPLIDOR o EN\_MORA a partir de saldo, historial y antigüedad de deuda del Cliente, y aplicar ajustes globales de descuento o recargo sobre nuevos Pedidos sin alterar precios base. Los ajustes comerciales se mantienen diferenciados del precio base y deben conservar tipo y porcentaje en el Pedido. Las categorías se reevaluarán según políticas y temporalidad configurables, sin fijar umbrales arbitrarios.

\*\*Comentarios\*\*

Actualización respaldada por DEC-P2-011. La distribución entre CU y las asociaciones de IRQ proceden de la matriz de auditoría; ratificar en la línea base global.

\---

\#\#\# RF-13 — Gestionar Excedentes de Producción

\*\*Origen:\*\* DOCX consolidado, ficha 65 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Objetivos Asociados\*\*

• OBJE-05 — Facilitar la redistribución de excedentes de producción

\*\*Requisitos Asociados\*\*

Casos de uso:

• UC-05 — Registrar Entrega

• UC-06 — Cancelar Pedido

• UC-07 — Ofrecer y Reasignar Excedente

• UC-42 — Registrar Descarte de Excedente

Información vinculada: IRQ-11

\*\*Descripción\*\*

El sistema deberá identificar Excedentes de Productos ELABORADOS preparados y disponibles, proponer Clientes candidatos y registrar reasignaciones totales o parciales, incluso distribuidas entre varios Clientes. Los Excedentes conservarán cantidad disponible y costo histórico, podrán redistribuirse parcialmente entre Clientes y descartarse registrando motivo y movimiento trazable. La cancelación identifica Excedentes; la oferta, reasignación y descarte se realizan en operaciones posteriores.

\*\*Comentarios\*\*

Actualización respaldada por DEC-P2-005; DEC-P2-006; DEC-P2-010. La distribución entre CU y las asociaciones de IRQ proceden de la matriz de auditoría; ratificar en la línea base global.


**ACTUALIZACIÓN DEL 20/10/2026 · RF-13.** EXC-01 a EXC-05: oferta no reduce Excedente; solo reasignación confirmada o descarte lo hace; conservar costo histórico. En Pedido receptor: totalVigente = totalOriginal + suma de incrementos comerciales aceptados. Precio y ajuste históricos originales inalterados. P-001 resuelto en su regla principal; detalles de promociones/prepago permanecen en revisión.



ENMIENDA APROBADA 21/10 — EXC-CANC/OFER/CC/DET: nuevo Excedente al cancelar Pedido receptor con elaborado reasignado aún disponible; OfertaExcedente conserva cantidad, importe informado, momento y respuesta; al cambiar cantidad ofrecida se recalcula el importe y se requiere nueva aceptación; MovimientoExcedente guarda incremento comercial y costo transferido. UC-07 no genera MovimientoCuenta.
\---

\#\#\# RF-14 — Gestionar Pedidos Online

\*\*Origen:\*\* DOCX consolidado, ficha 66 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Objetivos Asociados\*\*

• OBJE-15 — Permitir que los Clientes realicen Pedidos y pagos en línea

\*\*Requisitos Asociados\*\*

Casos de uso:

• UC-17 — Aplicar Ajuste Comercial según Categoría

• UC-22 — Realizar Pedido Online

Información vinculada: IRQ-05, IRQ-10

\*\*Descripción\*\*

El sistema deberá permitir a Clientes crear Pedidos ONLINE de múltiples Productos, efectuar pagos electrónicos y seguir el mismo ciclo de Pedido utilizado internamente, con confirmaciones idempotentes. El registro online no descuenta inventario. La creación de un Pedido ONLINE no descuenta stock; sus cantidades e importes históricos quedan congelados. La asignación posterior a un Repartidor corresponde al Vendedor; el prepago mayor que la venta efectivamente entregada deja saldo a favor sin Reembolso automático por esa diferencia.

\*\*Comentarios\*\*

Actualización respaldada por DEC-P2-005; DEC-P2-008. La distribución entre CU y las asociaciones de IRQ proceden de la matriz de auditoría; ratificar en la línea base global.


**ACTUALIZACIÓN DEL 20/10/2026 · RF-14.** COM-01 a COM-05 y EXC-05: Cliente ONLINE distinto de Usuario; mecanismo de autenticación pendiente. Un DetallePedido tiene como máximo una Promocion aplicada. Reasignaciones posteriores de Excedentes pueden aumentar el totalVigente del Pedido sin reescribir el totalOriginal; tratamiento de diferencias ante prepago pendiente.

\---

\#\#\# RF-15 — Gestionar Caja y Libro Diario

\*\*Origen:\*\* DOCX consolidado, ficha 67 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Objetivos Asociados\*\*

• OBJE-13 — Registrar la operación monetaria diaria del negocio

\*\*Requisitos Asociados\*\*

Casos de uso:

• UC-23 — Registrar Movimiento de Caja

• UC-24 — Consultar Libro Diario

• UC-27 — Procesar Reembolso Electrónico

• UC-50 — Registrar Resultado de Reembolso Electrónico

• UC-30 — Registrar Cobro

Información vinculada: IRQ-10

\*\*Descripción\*\*

El sistema deberá registrar Movimientos de Caja manuales y automáticos de tipo INGRESO o EGRESO y consultar un Libro Diario por período con origen, referencia y totales monetarios. Los movimientos manuales de Caja exigirán concepto y admitirán observación opcional; los movimientos automáticos de Cobros y Reembolsos efectivos no se duplicarán manualmente. El Libro Diario mostrará los movimientos del período y el resultado monetario como ingresos menos egresos, sin confundirlo con utilidad neta o saldo acumulado.

\*\*Comentarios\*\*

Actualización respaldada por DEC-P2-011. La distribución entre CU y las asociaciones de IRQ proceden de la matriz de auditoría; ratificar en la línea base global.


**ACTUALIZACIÓN DEL 20/10/2026 · RF-15.** FIN-01 a FIN-04: Movimientos de Caja y LibroDiario deben reflejar solamente efectos efectivos; Reembolso PENDIENTE o RECHAZADO no produce EGRESO ni ajuste financiero de reintegro. No se permiten dos efectos para el mismo reembolso procesado.

\---

\#\#\# RF-16 — Gestionar Promociones

\*\*Origen:\*\* DOCX consolidado, ficha 68 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Objetivos Asociados\*\*

• OBJE-16 — Gestionar y comunicar Promociones a los Clientes

\*\*Requisitos Asociados\*\*

Casos de uso:

• UC-22 — Realizar Pedido Online

• UC-25 — Crear y Comunicar Promoción

Información vinculada: IRQ-12

\*\*Descripción\*\*

El sistema deberá permitir crear Promociones con Productos, condiciones, vigencia, destinatarios y canal de comunicación, vinculándolas al canal de Pedidos ONLINE. El Administrador será el actor principal de la creación y comunicación de Promociones porcentuales para el canal ONLINE, con vigencia, al menos un Producto activo y al menos un Cliente destinatario; sin destinatarios no se confirma la Promoción. Un fallo de comunicación no elimina la Promoción; se registra el resultado por destinatario y se reintenta sin duplicar comunicaciones confirmadas.

\*\*Comentarios\*\*

Actualización respaldada por DEC-P2-002. La distribución entre CU y las asociaciones de IRQ proceden de la matriz de auditoría; ratificar en la línea base global.


**ACTUALIZACIÓN DEL 20/10/2026 · RF-16.** COM-01 a COM-04: Promocion–Producto de 1..* productos por Promocion; DestinatarioPromocion conserva vínculo con Cliente y evita duplicación por Promoción; IntentoComunicacion registra 0..* intentos por Destinatario sin reenvíos confirmados duplicados; un DetallePedido aplica como máximo una Promocion.

\---

\#\#\# RF-17 — Optimizar Ruta de Reparto

\*\*Origen:\*\* DOCX consolidado, ficha 69 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Objetivos Asociados\*\*

• OBJE-06 — Generar una secuencia optimizada de reparto

\*\*Requisitos Asociados\*\*

Casos de uso:

• UC-26 — Generar Ruta Sugerida de Reparto

• UC-44 — Asignar y Reasignar Pedidos a Repartidores

Información vinculada: IRQ-13

\*\*Descripción\*\*

El sistema deberá generar una secuencia sugerida de reparto a partir de las direcciones de los Pedidos utilizando un servicio de ruteo, sin garantizar la obtención del óptimo matemático global. La ruta sugerida se calculará únicamente para los Pedidos PENDIENTE asignados al Repartidor en la fecha indicada; una reasignación invalidará la sugerencia anterior y exigirá regeneración antes de utilizarla como vigente.

\*\*Comentarios\*\*

Actualización respaldada por DEC-P2-008. La distribución entre CU y las asociaciones de IRQ proceden de la matriz de auditoría; ratificar en la línea base global.


**ACTUALIZACIÓN DEL 20/10/2026 · RF-17.** PED-04: RutaSugerida es CLASE CONCEPTUAL aprobada, con fecha/hora, Repartidor, secuencia y asignaciones de Pedidos consideradas; una reasignación la vuelve obsoleta, sin convertir el servicio de ruteo en clase de dominio.

\---

\#\#\# RF-18 — Gestionar Reembolsos Electrónicos

\*\*Origen:\*\* DOCX consolidado, ficha 70 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Objetivos Asociados\*\*

• OBJE-17 — Gestionar Reembolsos de Cobros electrónicos

\*\*Requisitos Asociados\*\*

Casos de uso:

• UC-06 — Cancelar Pedido

• UC-27 — Procesar Reembolso Electrónico

• UC-50 — Registrar Resultado de Reembolso Electrónico

Información vinculada: IRQ-09, IRQ-10

\*\*Descripción\*\*

El sistema deberá gestionar Reembolsos de Cobros electrónicos vinculados con su transacción original, registrar estado y referencia externa y reflejar los efectos en Caja y Cuenta Corriente de forma idempotente. El Reembolso de un Cobro electrónico elegible será idempotente y conservará su estado; si permanece pendiente o rechazado no revierte una Cancelación ya registrada. Un egreso monetario se reconoce solo al procesarse efectivamente el Reembolso. Los resultados recibidos posteriormente desde MercadoPago se formalizan por UC-50, interacción externa distinta de la solicitud UC-27.

\*\*Comentarios\*\*

Actualización respaldada por DEC-P2-006. La distribución entre CU y las asociaciones de IRQ proceden de la matriz de auditoría; ratificar en la línea base global.


**ACTUALIZACIÓN DEL 20/10/2026 · RF-18.** FIN-03 y FIN-04: se excluyen los reembolsos parciales; registrar historia de intentos PENDIENTE/RECHAZADO y una única devolución completa efectiva por Cobro cuando proceda; solo PROCESADO genera efectos en Caja/Cuenta Corriente. ANTECEDENTE DOCUMENTAL RESUELTO 21/10: la idempotencia sigue siendo un requisito de negocio (RF-18/RNF-04). No se incorporan mecanismos técnicos de deduplicación al diagrama conceptual.



ACLARACIÓN APROBADA 21/10 — B4: no se modifica este RF. Cada Cobro electrónico admite 0..1 Reembolso lógico por devolución completa; cada Reembolso vincula exactamente un Cobro. Reintentos tras RECHAZADO reutilizan la instancia con historial; PENDIENTE no equivale a fallo definitivo; solo PROCESADO genera una vez MovimientoCaja EGRESO y MovimientoCuenta AJUSTE_DEBITO. Claves/tokens de idempotencia son decisiones de diseño, no clases conceptuales.
\---

\#\#\# RF-19 — Calcular Margen Bruto

\*\*Origen:\*\* DOCX consolidado, ficha 71 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Objetivos Asociados\*\*

• OBJE-14 — Calcular el margen bruto del negocio

\*\*Requisitos Asociados\*\*

Casos de uso:

• UC-05 — Registrar Entrega

• UC-28 — Consultar Margen Bruto

Información vinculada: IRQ-14

\*\*Descripción\*\*

El sistema deberá calcular el margen bruto utilizando ventas efectivas con precios y ajustes históricos, costos de Insumos consumidos en ELABORADOS y costos históricos de adquisición en REVENTA, excluyendo gastos operativos generales. El margen bruto utilizará ventas efectivas, importes y ajustes históricos, y costos directos atribuibles a lo entregado; REVENTA utilizará el costo de adquisición histórico. Los descartes no se imputarán automáticamente como costo de venta y no se incorporarán gastos operativos generales.

\*\*Comentarios\*\*

Actualización respaldada por DEC-P2-005; DEC-P2-010. La distribución entre CU y las asociaciones de IRQ proceden de la matriz de auditoría; ratificar en la línea base global.

\---

\#\#\# RF-20 — Registrar Cobros

\*\*Origen:\*\* DOCX consolidado, ficha 72 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Objetivos Asociados\*\*

• OBJE-10 — Registrar Cobros y mantener la Cuenta Corriente de los Clientes

\*\*Requisitos Asociados\*\*

Casos de uso:

• UC-22 — Realizar Pedido Online

• UC-30 — Registrar Cobro

Información vinculada: IRQ-09, IRQ-10

\*\*Descripción\*\*

El sistema deberá registrar Cobros por Cliente con importe, medio, origen, referencia externa y estado, generando los movimientos correspondientes de Cuenta Corriente y Caja sin requerir un Pedido asociado. Un Cobro puede ser parcial, exacto, anticipado o superior a la deuda, y no requiere asociación obligatoria a un Pedido; los efectos sobre Cuenta Corriente y Caja serán consistentes y transaccionales.

\*\*Comentarios\*\*

Actualización respaldada por DEC-P2-011. La distribución entre CU y las asociaciones de IRQ proceden de la matriz de auditoría; ratificar en la línea base global.

\---

\#\#\# RF-21 — Registrar Preparación de Pedidos

\*\*Origen:\*\* DOCX consolidado, ficha 73 de 73; archivo \`A\_Requisitos.md\` original; decisiones P01–P11 cuando figuren.

\*\*Objetivos Asociados\*\*

• OBJE-07 — Sistematizar la preparación de Productos elaborados y el control de Insumos

\*\*Requisitos Asociados\*\*

Casos de uso:

• UC-29 — Registrar Preparación de Pedido

Información vinculada: IRQ-06, IRQ-07

\*\*Descripción\*\*

El sistema deberá registrar Preparaciones parciales o totales de Pedidos con Productos ELABORADOS, calcular Insumos según Receta válida, verificar existencias y registrar los consumos y movimientos de inventario al confirmar la Preparación. La Preparación ELABORADO exige Receta válida, puede ser parcial y acumulativa sin superar la cantidad solicitada, consume Insumos al confirmarse y conserva las versiones y costos históricos necesarios; la Entrega no realiza el consumo de esos Insumos.

\*\*Comentarios\*\*

Actualización respaldada por DEC-P2-001; DEC-P2-005. La distribución entre CU y las asociaciones de IRQ proceden de la matriz de auditoría; ratificar en la línea base global.


**ACTUALIZACIÓN DEL 20/10/2026 · RF-21.** PROD-01 a PROD-05: cada Preparacion de un DetallePedido ELABORADO conserva la versión de Receta usada; el consumo crea MovimientoInsumo por Insumo y no una clase ConsumoPreparacion. Preparación acumulada propia + reasignaciones recibidas no excede la cantidad solicitada.



CONTROL DE COHERENCIA 21/10 — PROD-03 y EXC-DET-01: Preparacion continúa ligada a DetallePedido, pero UC-29 debe revisar su cota de cantidad ante incrementos por Excedente; no se adopta aquí una fórmula nueva ni se repite consumo por elaboración ya reasignada.
\---
