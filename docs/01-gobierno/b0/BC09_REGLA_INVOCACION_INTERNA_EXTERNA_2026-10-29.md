# BC-09 — Regla documentada de invocación interna y externa

**Fecha:** 29/10/2026 · **Estado:** regla de seguridad DOCUMENTADA en base a Fase 4, RD-F01/F04, RD-RP007-001/002, BC-03/BC-07 y contratos REV. **No constituye prueba de API ni crea actor UML o Rol nuevo**.

## Principio de invocación

Una operación de Sistema ejecutada *dentro* de un CU autorizado **no** habilita por sí misma una entrada directa para cualquier Rol, Cliente ONLINE o sistema externo. Cada origen requiere su propia prueba de identidad, derecho de invocación, objeto, estado, transacción e idempotencia.

| Clase de invocación | CU/operación | Quién la inicia | Restricción obligatoria |
|---|---|---|---|
| Humano interno autenticado | UC-29 `registrarCobro` | Administrador o Vendedor | Autorización servidor; `Cobro CONFIRMADO`, `MovimientoCuenta PAGO`, `MovimientoCaja INGRESO` atómicos y sin duplicados |
| Humano interno restringido | UC-29 `anularCobroManual` | **Solo Administrador** | Solo Cobro MANUAL CONFIRMADO, motivo, estado ANULADO y contraasientos; Vendedor denegado |
| Interna de aplicación | UC-15 `evaluarYActualizarCategoriaComercial`, UC-16 `aplicarAjusteComercialSegunCategoria` | Servicio que ejecuta CU autorizado | Sin acceso directo autónomo, menú o endpoint general; conserva pre/postcondiciones |
| Automatismo del Sistema | UC-26 `procesarReembolsoElectronico` | Flujo automático tras cancelación elegible | Único Reembolso por Cobro electrónico, efectos solo tras PROCESADO |
| Reintento humano excepcional | UC-26 `procesarReembolsoElectronico` | **Solo Administrador** para Reembolso RECHAZADO | Reusa Reembolso existente; identidad del servidor, no `idUsuarioReintento` del request |
| Sistema externo | UC-49 `registrarResultadoReembolsoElectronico` | Resultado auténtico de Mercado Pago | Verificar autenticidad/correlación/estado; aplicar efectos financieros solo en primera transición PROCESADO, sin doble efecto ante duplicados |
| Confirmación externa en canal online | UC-21/UC-29 | Pago confirmado por proveedor válido para Cliente con OTP verificado | Cliente ONLINE no es Usuario interno, la pasarela no adquiere Rol humano |
| Reparto y captura offline admitida | UC-05 `registrarEntrega` | Repartidor de Pedido asignado vigente | Declaración de efectivo **no** es Cobro definitivo; sincronización validada, pago en tránsito y rendición por Administrador |
| Cliente ONLINE | UC-21 `realizarPedidoOnline` | Cliente ACTIVO con código temporal validado | No usa identidad de Usuario interno ni obtiene sus permisos |

## Aplicación obligatoria para servicios y agentes

1. **Entrada humana**: servidor deriva identidad/Rol actuales y alcance por objeto; ignorar identidades o roles autoproclamados en payload, cabeceras o dispositivo.
2. **Entrada interna**: métodos invocados por servicios autorizados; un `include` no da permiso de menú a otro actor ni crea endpoint público independiente.
3. **Entrada externa**: validar autenticidad criptográfica o mecanismo oficial aprobado de proveedor, correlación de identificador y unicidad; las llamadas duplicadas/concurrentes no deben crear efectos repetidos.
4. **Finanzas**: `UC-05` efectivo declarado → sincronización aceptada → pago en tránsito → rendición y conciliación por Administrador → `UC-29` Cobro definitivo; no registrar Caja antes.
5. **Seguridad de datos**: aplicar 15 proyecciones ratificadas en BC-07; no exponer costos, credenciales o datos de terceros por herencia.
6. **Prueba**: separar autorización, denegación, reintentos, falta de autenticidad y carreras concurrentes en pruebas que usen PostgreSQL real y pasarela sandbox/mock.

## Autoridad y límites

Es una explicitación trazable de los CU y RD ratificados. Los contratos revisados PR #10–#19 permanecen propuestas hasta integración y las reglas de invocación **aún no tienen una implementación verificada**. Casos y estado en [BC06_CASOS_PRUEBA_IMPLEMENTACION_18.csv](BC06_CASOS_PRUEBA_IMPLEMENTACION_18.csv).
