# RP-007 — Contraste de permisos de búsqueda UC-33/34/35/36/37/40

**Fecha:** 26/10/2026 · **Estado:** contraste documental y propuesta de ratificación; **NO representa aprobación nueva**.

## Fuentes y precedencia

- `docs/00-contexto/CONTEXTO_MAESTRO_2026-10-25_v1.0.md`, §5 (línea 220): matriz explícita por rol y alcance de acceso.
- `docs/01-gobierno/RD_01_REGISTRO_DECISIONES_v1.1_2026-10-25.md`: RD-006 mínimo privilegio aprobado; RD-018 considera la matriz de búsquedas **propuesta evaluada / no ratificada**.
- `docs/01-gobierno/RP_01_REGISTRO_PENDIENTES_v1.1_2026-10-25.md`: RP-007 exige ratificación formal y análisis de campos sensibles.
- `RD_RP007_001_PERMISOS_UC29_2026-10-26.md`: UC-29 ya ratificada solo Administrador y Vendedor; no implica autorización para búsquedas.
- `AGENTS.md`: no agregar accesos nuevos ni confundir consulta contextual con directa.

## Matriz fuente del contraste

| CU | Administrador | Vendedor | Producción | Repartidor | Proveedor |
|---|---|---|---|---|---|
| UC-33 Buscar Cliente | DIRECTA/CONTEXTUAL | DIRECTA/CONTEXTUAL | NO | NO | NO |
| UC-34 Buscar Pedido | DIRECTA | DIRECTA/CONTEXTUAL | CONTEXTUAL | CONTEXTUAL: únicamente pedidos asignados | NO |
| UC-35 Buscar Producto | DIRECTA/CONTEXTUAL | DIRECTA/CONTEXTUAL | NO | NO | NO |
| UC-36 Buscar Insumo | DIRECTA/CONTEXTUAL | NO | DIRECTA/CONTEXTUAL | NO | NO |
| UC-37 Buscar Proveedor | DIRECTA/CONTEXTUAL | NO | NO | NO | NO |
| UC-40 Buscar Orden de Compra | DIRECTA/CONTEXTUAL | NO | DIRECTA/CONTEXTUAL: solo lectura | NO | NO |

**DIRECTA** significa operación de búsqueda independiente autorizada. **CONTEXTUAL** significa que se consulta solo lo imprescindible en otro CU permitido, sin habilitar una búsqueda general ni un menú propio. **NO** indica que no existe permiso para ejecutar el CU independientemente; si otro CU requiere consultar datos puntuales, debe verificarse ese caso y alcance sin inferir acceso genérico.

## Control de sensibilidad de datos (a especificar)

La matriz de CU no determina por sí sola **campos concretos** retornables ni filtrado de cada interfaz/API. Para implementación, revisar:
1. Cliente: identidad, teléfono, Cuenta Corriente y categoría; mínima información por rol y operación.
2. Pedido: Repartidor únicamente asignados; Producción solo datos necesarios para preparar; evitar visibilidad de saldos o pagos por vínculo contextual.
3. Producto: precios e información pública vs costos y márgenes internos; no asumir que permiso de buscar implica leer todos los atributos.
4. Insumo: Producción solo información operativa autorizada; precios/costos de compra y datos de proveedores separados según función.
5. Proveedor: acceso reservado a Administrador en UC-37; no ampliar desde UC-13 del portal Proveedor.
6. Orden de Compra: Producción **consulta de solo lectura**; no obtiene permisos de crear, aprobar ni cancelar OC por UC-40.

**No se propone aquí una enumeración física de campos o reglas de máscara inventadas.** Para adoptar la matriz operativa completa, el responsable debe ratificar esta distribución y acordar el contrato mínimo de datos por rol/API.

## Dictamen de coherencia

No se detecta conflicto lógico entre la matriz del contexto maestro y el principio de mínimo privilegio RD-006: distingue correctamente operaciones directas y contextuales. Sí existe una **diferencia de estatus** entre el contexto maestro (que presenta alcances como confirmados) y RD-018/RP-007 (que siguen exigiendo ratificación). Por precedencia, este documento conserva la **matriz como propuesta explícita a ratificar**, sin convertirla unilateralmente en decisión aprobada.

**RP-007:** UC-29 aprobada mediante RD-RP007-001; búsquedas UC-33/34/35/36/37/40 y acceso a campos sensibles **pendientes de ratificación y especificación**.

No modificar los 64 CU, el diagrama rechazado, SQL ni repositorios de código por este contraste.

## Ratificación posterior (27/10/2026)

La matriz contrastada fue **ratificada expresamente** por el responsable del proyecto en [RD-RP007-002](RD_RP007_002_PERMISOS_BUSQUEDAS_2026-10-27.md). Por lo tanto, cualquier mención anterior a «pendiente de ratificación» en este documento debe leerse como antecedente histórico. Permanece pendiente definir el acceso a campos sensibles e implementar/probar el control efectivo por rol en la aplicación.
