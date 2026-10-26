# MR-3 — Control de validación y límites

**Estado:** análisis estático completado; **NO** se ejecutó PostgreSQL. No hay `psql`/servidor instalado en este entorno de trabajo.

## Verificación automatizada

| Control | Resultado |
|---|---|
| `CREATE TABLE` en SQL consolidado | 60 esperadas / 60 observadas |
| `CREATE TABLE` en migración delta | 1 esperada / 1 observada |
| Columnas diccionario | 453 esperadas / 453 observadas |
| FK proyectadas | 125 (120 antiguas + 5 nuevas) |
| Inicio/fin de transacción delta | BEGIN / COMMIT presentes |
| Paréntesis y bloques SQL reconocibles | Balanceados en ambos SQL (comprobador léxico) |
| Marcadores funcionales | SALDO_INICIAL, ANULACION_COBRO, configuración, responsable reintento y triggers encontrados |
| Ejecución real de PostgreSQL | **NO REALIZADA** |

## Casos MR-4 que deben probarse

1. Ejecutar DDL de 60 tablas en PostgreSQL nuevo y comprobar los 125 vínculos FK de `pg_constraint`.
2. SQL de migración sobre copia de datos con registros de todos los estados antiguos: detectar duplicados y solapamientos; detener si hay conflictos.
3. Registrar un Insumo con stock cero y luego una sola apertura `SALDO_INICIAL` con costo histórico; duplicar apertura debe fallar.
4. Comprobar UNIQUE nombre Insumo y nombre+teléfono Cliente, sin prohibir teléfono compartido.
5. Insertar SolicituteCotización y respuestas: rechazar cerrada/vencida; permitir plazo de entrega omitido y evaluar con puntaje cero.
6. Confirmar exclusión GiST de períodos solapados para Receta, Precio y Políticas.
7. Cambiar PROMOCION desde BORRADOR y probar transiciones válidas e inválidas; conservar descuentos congelados.
8. Desactivar Producto o Proveedor con operaciones anteriores y comprobar que estas subsisten, pero no nuevas operaciones.
9. Anular Cobro manual y comprobar EGRESO de Caja, ANULACION_COBRO en Cuenta, dos referencias a Cobro original, un único efecto y preservación de auditoría.
10. Forzar rollback de procedimiento de anulación a mitad de operación; no deben quedar registros parciales.
11. Intento inicial de Reembolso sin idUsuarioReintento permitido; reintento sin Usuario rechazado; Usuario deshabilitado debe bloquearse en el servicio.
12. Configuración de plazo sin seed da error de precondición de ronda, no solicitudes con plazo inventado; override anterior a la emisión congela vencimiento.
13. Cambios posteriores de categoría/precios no reescriben Pedido/Detalle ya confirmados; operación offline duplicada no duplica Cobro.
14. Confirmar restricciones del último Administrador y operación de cuenta PROVEEDOR sin bypass por inserción directa.
15. Auditoría con `EXPLAIN (ANALYZE,BUFFERS)` antes de añadir índices de rendimiento.

La batería 12-15 requiere también componentes de aplicación / simuladores de eventos. No se afirma que los procedimientos SQL incluidos cubran todas las pruebas.
