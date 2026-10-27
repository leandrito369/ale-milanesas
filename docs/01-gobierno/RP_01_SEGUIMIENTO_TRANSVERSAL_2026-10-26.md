# RP-01 — Seguimiento transversal actualizado al 26/10/2026

**Estado:** PROPUESTA DE REGISTRO DE SEGUIMIENTO para revisión. No reemplaza ni altera la RP-01 v1.1 histórica.  
**Base:** [RP-01 v1.1](RP_01_REGISTRO_PENDIENTES_v1.1_2026-10-25.md), RD-F01, RD-F04-001..007, MR-5/MR-6, AGENTS y estado del repositorio.  
**Advertencia:** los estados reflejan evidencia documental, no implementación ni pruebas no efectuadas.

## Resumen de los 34 ítems históricos

| Estado | Cantidad |
|---|---:|
| ABIERTO_SIN_CAMBIO_VERIFICADO | 13 |
| DISENO_PARCIAL_SERVICIO_PENDIENTE | 1 |
| DOCX_MAESTRO_PENDIENTE_IMPORTAR | 1 |
| FISICO_PARCIALMENTE_VALIDADO | 1 |
| FUNCIONAL_RESUELTO_TECNICO_PENDIENTE | 8 |
| IMPLEMENTACION_PENDIENTE | 1 |
| LABORATORIO_VALIDADO_PRODUCCION_PENDIENTE | 1 |
| REGLA_APROBADA_PROPAGACION_PENDIENTE | 1 |
| RELACIONES_APROBADAS_QA_PENDIENTE | 1 |
| SERVICIO_PENDIENTE | 1 |
| SQL_PARCIAL_INTEGRACION_PENDIENTE | 2 |
| SQL_VALIDADO_INTEGRACION_PENDIENTE | 2 |
| MATRIZ_RATIFICADA_IMPLEMENTACION_PENDIENTE | 1 |
| **TOTAL** | **34** |

No se marca automáticamente ningún pendiente como `VERIFICADO` basándose solo en una decisión funcional o en un contrato.

## Matriz de seguimiento

| ID | Área | Prioridad | Asunto | Estado técnico/funcional distinguido | Evidencia o autoridad | Próximo paso |
|---|---|---|---|---|---|---|
| RP-001 | Comercial/ONLINE | ALTA | Fecha exacta de reparto ONLINE | FUNCIONAL_RESUELTO_TECNICO_PENDIENTE | RD-RP001/RP019 (27/10) | Pedido ONLINE UC-21: Cliente elige fecha entre opciones habilitadas; servidor valida antes de confirmar. |
| RP-002 | Reparto | ALTA | Elegibilidad detallada del Repartidor y del Pedido | FUNCIONAL_RESUELTO_TECNICO_PENDIENTE | RD-RP002-001 (27/10) | Seis reglas de UC-43 aprobadas; implementar validación online, unicidad de asignación vigente y carreras con UC-55. |
| RP-003 | Offline | ALTA | Asignación offline y concurrencia | FUNCIONAL_RESUELTO_TECNICO_PENDIENTE | RD-F04-001..007 / PR #5 | UC-43 solo online; UC-03/05 offline. Falta implementación y conflictos. |
| RP-004 | Consultas | MEDIA | Margen por período o por venta individual | ABIERTO_SIN_CAMBIO_VERIFICADO | RP-01 v1.1 25/10 | Se conserva pregunta original; requiere revisión específica sin inferir respuesta. |
| RP-005 | Finanzas | ALTA | Responsable técnico del reintento | FISICO_PARCIALMENTE_VALIDADO | MR-5 / MR-6 | Columna y pruebas SQL de reintentos; servicio webhook pendiente. |
| RP-006 | Caja/Reparto | ALTA | Rendición de efectivo del Repartidor | FUNCIONAL_RESUELTO_TECNICO_PENDIENTE | RD-F04-002..005 / PR #5 | Rendición Admin; diferencias pendientes de conciliación, sin investigación ampliada. API/DDL pendientes. |
| RP-007 | Permisos | MEDIA | Ratificación de matriz Rol × CU | MATRIZ_RATIFICADA_IMPLEMENTACION_PENDIENTE | RD-RP007-001 (26/10); RD-RP007-002 (27/10) | UC-29 y búsquedas UC-33–37/UC-40 ratificadas; definir proyección de campos sensibles por rol y probar RBAC API. |
| RP-008 | Usuarios | ALTA | Último Administrador | SQL_VALIDADO_INTEGRACION_PENDIENTE | MR-5 / MR-6 | Protección último Administrador probada en BD; confirmar procedimiento operativo de contingencia y API. |
| RP-009 | Usuarios/Reparto | ALTA | Cuenta de Repartidor con Pedidos asignados | FUNCIONAL_RESUELTO_TECNICO_PENDIENTE | RD-RP009-001 (27/10) | Bloquear UC-55 si hay Pedidos PENDIENTES vigentes asignados; listar y exigir reasignar UC-43 online; servicio y concurrencia pendientes. |
| RP-010 | Usuarios | MEDIA | Cambio temporal vs relación UML | ABIERTO_SIN_CAMBIO_VERIFICADO | RP-01 v1.1 25/10 | Se conserva pregunta original; requiere revisión específica sin inferir respuesta. |
| RP-011 | Autenticación | MEDIA | Política interna de recuperación | ABIERTO_SIN_CAMBIO_VERIFICADO | RP-01 v1.1 25/10 | Se conserva pregunta original; requiere revisión específica sin inferir respuesta. |
| RP-012 | Reposición | ALTA | Fuente operativa del plazo de respuesta | FUNCIONAL_RESUELTO_TECNICO_PENDIENTE | RD-RP012-001 (27/10) | Plazo de cotización proviene de parámetro del sistema configurable por Administrador; vencimiento por solicitud congelado; sin 48h por defecto. |
| RP-013 | Compras | MEDIA | Algoritmo comparativo y desempates | ABIERTO_SIN_CAMBIO_VERIFICADO | RP-01 v1.1 25/10 | Se conserva pregunta original; requiere revisión específica sin inferir respuesta. |
| RP-014 | Recepción | MEDIA | Reconciliación stock y cierre de episodio | DISENO_PARCIAL_SERVICIO_PENDIENTE | MR-5 S-02 / PRA-01 | Cierre de episodio protegido parcialmente en SQL; automatización y recepción por implementar. |
| RP-015 | Insumos | ALTA | SALDO_INICIAL en modelo físico | SQL_VALIDADO_INTEGRACION_PENDIENTE | MR-3 / MR-5 / MR-6 | Fuente costo SALDO_INICIAL protegida; faltan pruebas del flujo completo de stock/costo en API. |
| RP-016 | Insumos | MEDIA | Stock y parámetros iniciales | ABIERTO_SIN_CAMBIO_VERIFICADO | RP-01 v1.1 25/10 | Se conserva pregunta original; requiere revisión específica sin inferir respuesta. |
| RP-017 | Insumos | MEDIA | Unidad de Medida con historial | ABIERTO_SIN_CAMBIO_VERIFICADO | RP-01 v1.1 25/10 | Se conserva pregunta original; requiere revisión específica sin inferir respuesta. |
| RP-018 | Precios | ALTA | Primer Precio y estado físico | ABIERTO_SIN_CAMBIO_VERIFICADO | RP-01 v1.1 25/10 | Se conserva pregunta original; requiere revisión específica sin inferir respuesta. |
| RP-019 | Pedidos | MEDIA | Fecha de reparto de Pedidos internos | FUNCIONAL_RESUELTO_TECNICO_PENDIENTE | RD-RP001/RP019 (27/10) | Pedido interno UC-03: Usuario autorizado elige fecha; servidor valida antes de confirmar, también tras captura offline. |
| RP-020 | Pedidos | MEDIA | Reprogramación de fecha de reparto | FUNCIONAL_RESUELTO_TECNICO_PENDIENTE | RD-RP020-001 (27/10) | Solo Pedido PENDIENTE; Usuario interno autorizado; validar fecha, invalidar asignación vigente y exigir UC-43 online; auditar historia sin alterar precios. |
| RP-021 | Pedidos | MEDIA | totalVigente conceptual vs persistencia | REGLA_APROBADA_PROPAGACION_PENDIENTE | Contexto maestro / MR-3 | totalVigente derivado; revisar que CU y contratos no lo presenten como columna nueva. |
| RP-022 | Inventario | MEDIA | Costeo y conversiones | ABIERTO_SIN_CAMBIO_VERIFICADO | RP-01 v1.1 25/10 | Se conserva pregunta original; requiere revisión específica sin inferir respuesta. |
| RP-023 | Comercial | MEDIA | Promociones simultáneas y elegibilidad | ABIERTO_SIN_CAMBIO_VERIFICADO | RP-01 v1.1 25/10 | Se conserva pregunta original; requiere revisión específica sin inferir respuesta. |
| RP-024 | Comercial | BAJA | Reintento de comunicaciones fallidas | ABIERTO_SIN_CAMBIO_VERIFICADO | RP-01 v1.1 25/10 | Se conserva pregunta original; requiere revisión específica sin inferir respuesta. |
| RP-025 | Clientes/ONLINE | MEDIA | Teléfono compartido / identificación alternativa | ABIERTO_SIN_CAMBIO_VERIFICADO | RP-01 v1.1 25/10 | Se conserva pregunta original; requiere revisión específica sin inferir respuesta. |
| RP-026 | Clientes/Estados | MEDIA | Bajas lógicas y operaciones en curso | SQL_PARCIAL_INTEGRACION_PENDIENTE | MR-5 S-05 / MR-6 | Controles de inactivos en BD; completar carreras, aplicación y políticas específicas. |
| RP-027 | Finanzas | MEDIA | Contra-asientos auditables | SQL_PARCIAL_INTEGRACION_PENDIENTE | RD-F01 / MR-5 / PR #4 | Contraasientos y anulación integrados parcialmente en SQL; falta servicio y prueba funcional. |
| RP-028 | Finanzas | MEDIA | Diferenciar Libro Diario vs utilidad y saldos | ABIERTO_SIN_CAMBIO_VERIFICADO | RP-01 v1.1 25/10 | Se conserva pregunta original; requiere revisión específica sin inferir respuesta. |
| RP-029 | Integraciones | ALTA | Notificación e idempotencia | SERVICIO_PENDIENTE | MR-5 S-03 / MR-6 | Webhook, OTP y efectos externos exactly-once requieren implementación. |
| RP-030 | Modelo relacional | ALTA | DDL referencial sin ejecutar | LABORATORIO_VALIDADO_PRODUCCION_PENDIENTE | MR-6 / PR #2 | 60 tablas, 453 columnas, 125 FK y migración vacía validados en PostgreSQL 17; no datos reales/producción. |
| RP-031 | UML | MEDIA | Revisión de relaciones «include»/«extend» | RELACIONES_APROBADAS_QA_PENDIENTE | Adenda 7 include / AGENTS.md | 7 relaciones aprobadas; no alterar el diagrama de casos de uso rechazado. |
| RP-032 | Documentación | ALTA | Contaminación editorial y errores formales | DOCX_MAESTRO_PENDIENTE_IMPORTAR | docs/04-casos-uso/README.md | 192 fichas Fase 4 consolidadas fuera de repo; faltan importación nativa y QA semántico. |
| RP-033 | Trazabilidad | MEDIA | Prefijos y redacción de objetivos | ABIERTO_SIN_CAMBIO_VERIFICADO | RP-01 v1.1 25/10 | Se conserva pregunta original; requiere revisión específica sin inferir respuesta. |
| RP-034 | PRA-01 | MEDIA | Trazabilidad e implementación por eventos | IMPLEMENTACION_PENDIENTE | PRA-01 / MR-5 S-02 | Contrato conceptual documentado; eventos y servicio aún no implementados. |

## Orden de trabajo documental paralelo a Gemini

1. **Gobierno:** revisar PR #7 de estado y PR #8 de Plan Maestro/Gemini, sin fusionar por inferencia; decidir su aceptación y la actualización de `main`.
2. **Fuente académica:** incorporar el Word maestro de 64 CU / 192 fichas y sus referencias; conservar íntegro el documento nativo. No usar el extracto del contexto como sustituto.
3. **Reglas críticas antes del primer servicio:** RP-007 matriz Rol×CU, RP-009 repartidor con pedidos asignados; revisar RP-002 elegibilidad de asignación con las decisiones de F04.
4. **Ventas y pedidos:** RP-001 fecha ONLINE, RP-019 fecha interna, RP-020 reprogramación; no inventar plazos.
5. **PRA-01 compras:** RP-012 fuente del vencimiento y RP-013 normalización/desempates. No asumir 48h ni pesos fijos.
6. **Integración de DSS/DSD Gemini:** recibir fuentes editables y chat; revisar CU/categorías/permisos y publicar PR independiente; generar contratos declarativos después de aprobación del lote.
7. **Desarrollo técnico posterior:** F07/F09; luego circuito comercial, F04 y demás servicios, con CI y verificación.

## Exclusiones

- Ninguna reactivación de PROMOCION se da por aprobada; F08 mantiene prohibida PAUSADA→ACTIVA hasta RD propia.
- No se reabre el caso detallado de faltantes de efectivo: RD-F04-005 termina en **pendiente de conciliación**.
- No se rediseña el diagrama de CU rechazado, ni se renumeran los 64 UC.
- No se equiparan resultados de SQL MR-6 con servicios implementados.

## Protocolo de actualización

Cada cambio de estado en esta matriz debe añadir: identificador RP, motivo, enlace exacto a RD/PR/prueba, fecha y estado residual. Al resolver una pregunta se conserva su antecedente; al implementar se requiere prueba real independiente. La matriz se publicará en `main` solo después de revisión del PR.
