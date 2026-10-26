# Acta de publicación inicial — 26/10/2026

## Objetivo
Habilitar `ale-milanesas` para colaboración entre ChatGPT, Gemini y el usuario mediante documentación versionada.

## Estado antes
Repositorio público con solo `README.md`; rama principal `main`.

## Estado propuesto
Publicación de los textos originales que se pudieron recuperar con fidelidad; README, instrucciones para IAs, índice, estado actual, protocolo, plantillas, SQL y matrices.

## Exclusiones explícitas
- Documento nativo `ALE_MILANESAS_FASE_4_CU_01_A_64_TRES_NIVELES.docx`, que debe subirse sin conversión.
- Diagrama modular de CU rechazado, que **no debe quedar como vigente**.
- ZIP redundantes, capturas temporales, guías de terceros y archivos de laboratorio.
- Contraseñas, credenciales y datos de producción (no se cargan deliberadamente).

## Limitaciones de validación
- Integridad de transporte de Git comprobable por blob SHA en GitHub.
- No hay pruebas PostgreSQL; MR-5 sigue siendo **propuesta NO EJECUTADA**.
- Fuentes del corte del 25/10 y del 23/10 se conservan con sus fechas originales, con aviso de posible obsolescencia.

## Flujo obligatorio
Rama individual, Pull Request, trazabilidad y evidencia de revisión antes de fusionar. Reimportar el repo en Gemini web cuando `main` cambie.
