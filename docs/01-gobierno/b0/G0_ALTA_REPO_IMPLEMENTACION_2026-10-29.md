# G0 — Registro de alta del repositorio de implementación y acceso

**Fecha:** 29/10/2026. **Estado:** ALTA CONFIRMADA; HANDOFF TÉCNICO AÚN BLOQUEADO POR G0 Y PERMISOS DEL CONECTOR.

## Repositorios
- **Documentación y especificaciones:** [`leandrito369/ale-milanesas`](https://github.com/leandrito369/ale-milanesas), fuente de autoridad de Fase4, DSS/DS/contratos, RD/RP/CR/ADR, MR5/MR6 y G0.
- **Implementación y documentación operativa:** [`leandrito369/ale-milanesas-app`](https://github.com/leandrito369/ale-milanesas-app), creado por el responsable. GitHub informa `default_branch=main`, visibilidad `public`, commit inicial `7c7dfaec31f91bf5d9e312668f0f403f0fb30adf` y un `README.md` de presentación. A la inspección **no hay backend, Android, frontend, migraciones ni tests de aplicación**.

## Acceso GitHub del agente
El conector puede **leer** el repositorio público nuevo. La instalación GitHub App **#175453350** utiliza repositorios **seleccionados**, actualmente solo reconoce `leandrito369/ale-milanesas`. Al intentar abrir una rama de documentación en `ale-milanesas-app`, GitHub respondió **403 `Resource not accessible by integration`**. La conexión OAuth visible como usuario con permisos administrativos **no significa que el GitHub App haya recibido acceso al repo nuevo**.

**Acción del responsable:** abrir [configuración de la instalación GitHub](https://github.com/settings/installations/175453350), entrar en su configuración, agregar `leandrito369/ale-milanesas-app` a los repositorios permitidos y guardar. No publicar tokens ni contraseñas. Después, comprobar permisos creando una rama y una PR (no escribir directamente en `main`).

## Reglas de activación
1. Repo nuevo **creado** (cumplido).
2. Acceso de escritura del conector al repo nuevo **pendiente de ampliación**.
3. Fuente/commit canónico tras G0 **pendiente**; el manifiesto G0 actual es **preparación**, no `source-lock` ratificado.
4. **G0 aprobado** **pendiente**; por tanto **NO implementar** B1, no scaffold, no migraciones, no pagos.
5. Una vez G0 aprobado y permisos habilitados: PR en repo nuevo con `AGENTS.md`, `README`, `docs/traceability/source-lock.md`; código B1 en PR posterior según backlog ratificado.

## Preservación
Este registro reemplaza únicamente el estado histórico «repo nuevo aún no existe» en la RD de separación; no cambia el resto de las restricciones de esa decisión. Mantener toda la especificación académica en `ale-milanesas`, referenciada por commit inmutable desde el código. No copiar contenido privado de Drive a GitHub público.
