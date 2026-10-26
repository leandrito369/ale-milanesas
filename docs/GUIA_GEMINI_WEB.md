# Cómo colaborar con Gemini desde la web

**Repositorio:** https://github.com/leandrito369/ale-milanesas

## Consulta
1. Ingresar a Gemini web e importar el repositorio de GitHub desde la opción de carga/importación de código disponible en tu interfaz.
2. Confirmar que se haya importado la **rama principal `main`** y no una copia previa.
3. Pedir a Gemini que comience por `README.md`, `AGENTS.md`, `docs/ESTADO_ACTUAL.md` y el documento maestro.
4. Cuando `main` cambie, **volver a importar**: la copia incorporada a una conversación web puede quedar desactualizada.

## Escritura
**Conectar/importar el repositorio no demuestra permiso de escritura desde Gemini web.** La invitación a tu segunda cuenta GitHub permite escribir en GitHub, pero la herramienta debe disponer además de un mecanismo de modificación autorizado.

Flujo seguro recomendado:
- Gemini prepara propuesta **sin modificar `main`**: archivo final completo o parche, explicación, CU y prueba.
- Abrir una rama con la cuenta colaboradora mediante Git, GitHub Web o un entorno que sí soporte escrituras.
- Subir cambios y abrir un Pull Request a `main`.
- Revisar contra los documentos fuentes y fusionar solo tras verificación.

**No subir** tokens, contraseñas, datos reales, bases de producción, ni diagramas rechazados.

## Prompt sugerido
> Leé AGENTS.md, docs/ESTADO_ACTUAL.md y docs/00-contexto/CONTEXTO_MAESTRO_2026-10-25_v1.0.md. Trabajá solo en el tema que te indique. Respetá decisiones aprobadas y etiquetas de estado. No inventes una ejecución PostgreSQL. Entregá los archivos propuestos y una descripción de Pull Request con trazabilidad CU/RD/RP/MR. No sobrescribas main.
