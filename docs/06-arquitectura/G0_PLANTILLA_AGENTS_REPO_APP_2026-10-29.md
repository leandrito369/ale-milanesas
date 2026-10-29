# Plantilla AGENTS.md para ale-milanesas-app — NO PUBLICADA EN APP

**Estado:** plantilla preparada en repositorio documental. **NO copiar en `main` ni considerarla instrucción vigente de `ale-milanesas-app` hasta G0 aprobado y acceso GitHub App concedido.**

## Regla fuente
El proyecto implementa los CU y operaciones del repositorio **`https://github.com/leandrito369/ale-milanesas`**. Antes de cualquier Issue de código debe existir un `docs/traceability/source-lock.md` **G0 APROBADO** que ancle commit inmutable, CU, operación, fuente contractual y RD.

## Lectura obligatoria
1. `docs/traceability/source-lock.md` de este repo, aprobado y con SHA.
2. `AGENTS.md`, `docs/ESTADO_ACTUAL.md`, plan rector B0–B10 y acta G0 en `ale-milanesas` al commit bloqueado.
3. Ficha Alto/Extendido/Real, DSS, DS, contrato preferente del manifiesto G0; revisar físicamente pestaña/mensajes, no inferir de nombre de archivo.
4. Matriz RBAC 67 con 0 P, 15 proyecciones BC07, RD-B0-BC01/02/03/05/07 y regla BC09; tabla MR5/MR6 y constraints solo en alcance de su prueba.
5. ADR-B1-01/02/03/04/06 ratificadas, ADR-B1-05 **pendiente** y CR-B0-F04-001; ninguna migración F04 nueva sin CR aprobada.

## Arquitectura y control de cambios
- **Siete módulos lógicos** en monolito modular Java/Spring Boot; web Thymeleaf, Android Kotlin/Room, PostgreSQL, adaptadores de Mercado Pago/WhatsApp/OSRM. Versiones concretas de build/infra se deciden por ADR de implementación; no inventarlas como autoridad.
- No cambiar RF, CU, DSS/DS, contratos, precios históricos, Cobro, aprobación de compras, rol ni esquema sin RD/CR en repo documental.
- Inicio humano autenticado, interno, Cliente OTP, webhook externo y reintento Admin son canales **distintos**. No crear endpoint público de operaciones internas UC15/16.
- Precios/ajustes de Pedido congelados; preparación solo original; extras aceptados sin recompras de Insumo; entrega definitiva; efectivo en tránsito no es Cobro; reembolso efecto solo PROCESADO exactamente una vez.
- Rama y PR por tarea, sin push/merge directo a `main`, sin pago ni comunicación real, sin credenciales/datos personales reales.
- Evidence de PR: `CU+operación → fuente de diseño → clases/servicios → tabla/columnas → endpoint/UI → test real (comando y salida)`. Cuando falte implementación, marcar `NO EJECUTADO`.

## Puerta
Si G0 no está aprobado o `source-lock` no existe: **NO GENERAR CÓDIGO NI MIGRACIONES DE APLICACIÓN**. Crear solo documentación de planificación.
