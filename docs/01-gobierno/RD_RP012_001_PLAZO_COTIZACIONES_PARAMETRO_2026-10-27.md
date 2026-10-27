# RD-RP012-001 — Fuente configurable del plazo de respuesta a cotizaciones

**Fecha:** 27/10/2026. **Estado funcional:** APROBADA expresamente por el responsable del proyecto. **Implementación y pruebas:** PENDIENTES.

## Decisión aprobada — Opción A

El **plazo de respuesta para solicitudes de cotización de PRA-01** se obtiene de un **parámetro configurable del sistema, establecido por el Administrador**.

1. Al crear cada solicitud de cotización se toma el valor del parámetro operativo **vigente en ese momento**.
2. Se fija y conserva la **fecha/hora de vencimiento propia de esa solicitud**. Cambios posteriores del parámetro no alteran vencimientos ya congelados.
3. El parámetro es **independiente de `POLITICA_COMPRA.periodoCalculoDias`**, que conserva su significado.
4. **No se aprueba ninguna duración predeterminada**, en particular no se presume 48 horas.
5. Esta decisión identifica la **fuente del plazo**; no autoriza por sí sola una nueva columna/tabla, fórmula de cómputo, opción de interfaz o migración SQL.

## Compatibilidad y límites

- Se conserva el proceso PRA-01 de primera ronda automática como máximo una por episodio de faltante, sin emitir Orden de Compra sin decisión humana autorizada.
- Para nuevas rondas o solicitudes se deberá aplicar el parámetro vigente al **crear cada solicitud**, salvo que un procedimiento previamente aprobado establezca una excepción explícita.
- El detalle de permisos para editar la configuración y la concurrencia entre actualización del parámetro y creación de solicitudes se deberá verificar técnicamente. La responsabilidad de establecerlo recae en Administrador.
- Reglas concretas de unidad, valores permitidos, cómputo calendario/hábil, zona horaria y ausencia de parámetro vigente permanecen como **especificación técnica o de negocio pendiente**, sin inventar valores.

## Trazabilidad

RP-012; PRA-01; UC-44 y UC-58; RD-019 del registro histórico; `MR5_CONTRATOS_SERVICIOS.md` S-02.

**Resultado:** RP-012 resuelto para elección de fuente del plazo; persisten detalles de validación e implementación sin servicio ejecutado.
