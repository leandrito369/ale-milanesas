# G0 — Plan de integración controlada de PR y precedencia canónica

**Fecha:** 29/10/2026. **Estado:** PLAN PARA REVISIÓN, SIN MERGES EJECUTADOS.

## Dos líneas abiertas, sin equivalencia automática

**Línea de diseño:** #9 → #10 → ... → #19; #10–#19 están en **Draft** (no fusionadas). `#19` tiene el corte `64af3c3baa571c2d512242e396267a31f0da3efd` y agrupa DSS, DS y 67 operaciones contractuales. Los `originales/` son evidencia, los `propuestos/` son revisión, no homologación explícita por estar en GitHub.

**Línea de gobierno B0:** #20 → #21 → #22 → #23 → #24 → #25 → presente paquete; `#25` tiene el corte `56a9fb2cff90bad58fca5d91b4a3abbbc339b8e7`. Las RD ratificadas, RBAC y contratos derivados B0 **no** sustituyen los modelos por editar archivos originales.

## Orden de revisión y eventual merge (requiere decisión humana)

1. Comparar fuentes, actas y conflictos por ruta en ambas líneas; inspeccionar `DOCX` Fase 4 y al menos los DS/contratos de operaciones del primer incremento. Evaluar si la revisión de los lotes cumple calidad para retirar Draft; **no** hacerlo por inferencia.
2. En la línea de diseño, revisar #9 y, de aceptarse, integrar de manera controlada; retargetear y revisar cada PR #10–#19 **en orden de dependencia**. Cada cambio de base exige CI y revisión del diff resultante; conservar SHA/acta de la versión evaluada. No hacer un único merge ciego de #19.
3. En la línea de gobierno, revisar e integrar #20–#25 en su orden de dependencia; volver a ejecutar tests documentales. Si el orden de merge es diseño primero, verificar que la trazabilidad y los contratos derivados B0 no sean eclipsados por archivos viejos; si es B0 primero, verificar el efecto inverso.
4. **Resolución de contradicciones:** Fase 4 + RD funcional ratificada posterior prevalece; contrato B0 corrigió BC01/02/03/04/05; DSS/DS no se alteran sin CR/RP. Documentar por archivo y CU toda discrepancia. Los archivos de propuesta original permanecen como historial.
5. Generar un **commit/tag** de línea base canónica en el repo documental solo **después** de revisión, merge y aprobación. Regenerar el manifiesto G0 con el SHA de ese commit, manteniendo manifest histórico de corte `56a9fb2cff90bad58fca5d91b4a3abbbc339b8e7`.
6. Recién entonces se habilita el **source-lock del repo app**, con `source_repo`, `source_commit`, `cu`, `operacion`, contrato, DSS/DS, RD/CR y hashes. No asignar una URL de PR como autoridad más reciente si es Draft.
7. Registrar acta de Gate con decisión y firmas; si quedan discrepancias menores, categorizarlas como riesgos tolerados **solo por decisión expresa del responsable** y no implementarlas hasta resolver su contrato.

## Lista de verificación obligatoria para cada PR crítica

- [ ] Fuentes y commit base exactos; cambios de comportamiento aprobados por RD/CR.
- [ ] CU y operación identificada; DSS/DS, contrato y versión preferente coherentes en entrada, mensaje, validación, excepción y postcondición.
- [ ] RBAC 0 P y proyecciones BC07 ratificadas; separación entre internos/webhooks/online/offline.
- [ ] MR5/MR6 y diferencia física por columna/trigger/índice auditada para operaciones afectadas.
- [ ] CI documental ejecutado; no se atribuyen pruebas de servidor a SQL de MR6.
- [ ] Cualquier referencia histórica superada queda señalada, no borrada.
- [ ] Revisión humana de conflictos y permiso de merge documentado.

**Nota:** este plan **no autoriza** al agente a hacer merge, cerrar PR, levantar Draft, escribir sobre `main` ni desplegar. El responsable del proyecto conserva la decisión final.

---

## Acta de ejecución posterior, 29/10/2026

**PLAN EJECUTADO en su alcance:** se fusionaron individualmente **#9, #10–#19 y #20–#26** en `main`. Se retargetearon a main las PR de cada cadena y se levantaron Draft únicamente tras la **autorización expresa del responsable**, quien declaró haber inspeccionado diagramas/contratos. No se confundió esa declaración con una inspección por parte del asistente ni con validación docente. Último commit de integración `1263ffc17bd0eb7f3c69faaa9ff5ae556cf9de7e`. Evidencia por PR en [bitácora](G0_BITACORA_FUSION_18_PR_2026-10-29.md). El [manifiesto canónico](G0_MANIFIESTO_CANONICO_67_OPERACIONES_2026-10-29.csv) ancla todas las fuentes a ese commit. #7/#8 fuera del alcance; no se cerraron ni fusionaron.
