# E02 — Arquitectura candidata (B0.5, NO RATIFICADA)

**Fecha:** 29/10/2026. **Estado:** PROPUESTA TÉCNICA PARA ADR B1, no código implementado ni autorización para migración.

## Origen y criterio

El contexto maestro (25/10), el plan rector (29/10), F04 y MR-5/MR-6 contemplan Android/Kotlin/Room, Java/Spring Boot, web Thymeleaf, PostgreSQL, Mercado Pago, WhatsApp por proveedor por definir y OSRM. **Se propone monolito modular** por el alcance de un desarrollador; no microservicios por CU. El diseño debe materializar DSS/DS/contratos, no imponer las tablas como clases conceptuales.

## Capas y límites propuestos

```text
WEB Thymeleaf                 Android Kotlin/Room (cola local de eventos autorizados)
              \               /
       HTTPS / controladores y DTO/API REST autenticada
                          |
             Servicios de aplicación (transacciones, validación, idempotencia)
                          |
         Dominio (entidades, políticas e invariantes de negocio)
                          |
      Puertos/adaptadores persistencia + integraciones (mocks/sandbox)
                          |
                 PostgreSQL 17 (MR5 + F01 vía migraciones)
            Mercado Pago | WhatsApp | OSRM
```

**Módulos candidatos según lotes y dependencias:**
1. `acceso`: Usuario, Rol, sesiones, Cliente ONLINE OTP, RBAC (REV-02 + F07).
2. `maestros`: Cliente, Proveedor, Producto, Insumo, unidad, precio, búsquedas, estados (REV-01,03,06A,06B).
3. `ventas`: Pedido, Detalle, precio congelado, categoría, promoción, asignación (REV-04A,06A/06B).
4. `produccion_inventario`: Receta/versiones, Preparación, stocks, ajustes, movimientos, Excedente (REV-01/04B/06B2).
5. `abastecimiento`: PRA, cotización, política, decisión, OC y recepción (REV-03).
6. `finanzas`: Entrega/cargo, Cobro, Cuenta, Caja, Libro, margen, reembolso (REV-04B/05).
7. `canales_integraciones`: canal online, Mercado Pago, WhatsApp, OSRM, offline y conciliación; integra servicios anteriores sin duplicar reglas.

Las fronteras son **candidatas**: una misma transacción puede cruzar módulos (por ejemplo Entrega y Cargo); resolver responsabilidad del servicio orquestador y locking **antes de programar**. Las operaciones y clases concretas se derivarán de los DS/contratos ratificados y de la matriz de B0.

## ADR de B1 requeridas, sin completar como hechos

| ADR | Decisión a ratificar | Riesgo si se omite |
|---|---|---|
| ADR-B1-01 | Monolito modular y estructura Maven/Gradle, versiones compatibles JDK/Spring | Dependencias y límites incoherentes |
| ADR-B1-02 | Contrato API/DTO y manejo estándar de errores, roles contextualizados | Romper contratos o exponer información |
| ADR-B1-03 | Flyway candidato para MR-5/F01, entornos efímeros y rollback/backups | SQL histórico alterado, migraciones incompatibles |
| ADR-B1-04 | Estrategia de pruebas Testcontainers/JUnit CI, fixtures y cobertura | Afirmaciones sin prueba reproducible |
| ADR-B1-05 | F04 inbox/cola de sincronización y transiciones de pagos en tránsito, **requiere CR de esquema** | Doble asiento, pérdida de eventos |
| ADR-B1-06 | Adaptadores externos, secretos, observabilidad y mocks/sandbox | Efectos reales o datos expuestos |

**Prohibiciones técnicas en B0:** no mover entidades a tablas nuevas, no inventar interfaces definitivas, no tocar PostgreSQL real, no fijar números/estados/RBAC inexistentes, no sustituir diagramas rechazados, no confundir revisión estática con implementación.
