# REV-02 — Matriz de trazabilidad, correcciones y visibilidad de Larman

**Fecha:** 28/10/2026. **Estado:** corrección documental y cotejo dirigido, **no certificación docente ni de software**.  
**Fuente Gemini:** `originales/PAQUETE_GEMINI_REV02_2026-10-28.md` y XML originales independientes.  
**Word maestro consultado:** `main:docs/04-casos-uso/CASOS_DE_USO_64_TRES_NIVELES.docx`, blob SHA `d3fa32360e0b0b8184b1bb1a3eb9ce52bc0fea11` (no presente todavía en las ramas antiguas PR #9/#10).  
**Normativa posterior:** RD-RP010-001 y RP-009/RD-RP009-001 registrados en seguimiento, 27/10; relaciones `UC-17→UC-18`, `UC-54→UC-56`, `UC-55→UC-56`; diccionario MR-5/MR-6 de 60 tablas. **F07 continúa técnicamente pendiente**.

## 1. Métodos aplicados (M-0 a M-7)

M-0. Fijar las fuentes, fecha, versión Word y precedencia RD posterior a Word, sin redefinir negocios.  
M-1. Preservar íntegro el paquete Gemini y sus dos XML originales; proponer cambios solo en nuevos archivos.  
M-2. Validar sintaxis básica XML, cantidad de páginas e IDs `mxCell` **por página**, no globalmente (cada página reutiliza IDs raíz `0` y `1`).  
M-3. Cotejar eventos públicos DSS, primer mensaje DS y Nombre de contrato, con normalización de `&lt;` y `&gt;` de XML.  
M-4. Analizar escenarios encadenados UC-01→UC-53, UC-17→UC-18, UC-54/55→UC-56 y UC-43→UC-55.  
M-5. Cotejar nombres/columnas permitidas en `USUARIO`, `ROL`, `USUARIO_ROL`, `EVENTO_ASIGNACION_ROL`, `USUARIO_PROVEEDOR`, `SESION_USUARIO`, `ASIGNACION_REPARTO`; no inventar columnas.  
M-6. Comprobar semántica de mensajes y visibilidad según Larman; distinguir referencia demostrada por creación/local de asociación **no demostrada**. No confundir geometría textual con revisión visual de diagrams.net.  
M-7. Registrar hallazgos y reservas con dictamen verificable; cierre de trabajo documental **no** equivale a validación final.

## 2. Operaciones públicas y cobertura

| CU | Evento en DSS = mensaje inicial DS = Nombre en contrato | Hallazgo / cotejo Word | Resultado |
|---|---|---|---|
| UC-01 | `iniciarSesion(nombreUsuario:String, credencial:String)` | RP-010 amplía restricción para toda cuenta con `cambioCredencialPendiente=true`; no crear relación `include` automática a UC-53 | Firma **homologada internamente**, regla incorporada |
| UC-17 | `crearUsuario(nombreUsuario:String, credencialInicial:String, codigosRol:Set<String>, idProveedor:Long[0..1])` | Word Real prevé credencial inicial temporal obligatoria para **PROVEEDOR**; Gemini la impuso a todo Usuario | **Corregido**: internos sujetos a política documentada, no valor automático inferido |
| UC-18 | `gestionarAsignacionesRoles(idUsuario:Long, codigosRolAgregar:Set<String>, codigosRolQuitar:Set<String>)` | Rol mínimo, exclusividad PROVEEDOR, historial de eventos; F07 pendiente de prueba | Firma homologada; objeto evento/sesiones **separado** |
| UC-53 | `cambiarContrasena(credencialActual:String, credencialNueva:String, confirmacion:String)` | Word Real explicita nueva credencial y confirmación; **no demuestra exigencia universal** de `credencialActual` en todos los escenarios | Firma **homologada en propuestas**, **pendiente autoridad de política** |
| UC-54 | `restablecerAccesoUsuario(idUsuario:Long, credencialTemporal:String)` | Word Real exige comprobar **identidad comercial** del Proveedor además de Rol/vínculo | **Corregido**: guarda DSS/DS y precondición contractual |
| UC-55 | `cambiarEstadoUsuario(idUsuario:Long, nuevoEstado:String)` | Word anterior permitía informar asignaciones después de deshabilitar; RP-009 posterior **bloquea antes** | **Corregido**: rechazo y necesidad de UC-43 primero |
| UC-56 | `buscarUsuario(nombreUsuario:String[0..1], estado:String[0..1], codigoRol:String[0..1])` | DSS original añadía evento `seleccionarUsuario(idUsuario)` que DS/contrato no trazaban explícitamente | **Corregido** como evento auxiliar en DS y contrato; contrastar literal con Word Real |

**Alcance del conteo:** siete operaciones principales idénticas entre los tres **artefactos propuestos**. No prueba por sí solo que sus DTO, tipos o parámetros constituyan la firma académica original. `seleccionarUsuario` es evento auxiliar adicional, no octavo CU ni relación UML nueva.

## 3. Hallazgos del paquete y estado de corrección

| Hallazgo | Naturaleza | Corrección comprobable | Estado |
|---|---|---|---|
| R2-01 | UC-17 establecía `cambioCredencialPendiente=true` en todas las altas | UC-17 DSS, DS y contrato distinguen PROVEEDOR obligatorio del interno cuya política de emisión debe fijarse | **CORREGIDO**, decisión interna pendiente |
| R2-02 | DS UC-17 agrupaba `UsuarioRol`, `EventoAsignacionRol`, `UsuarioProveedor` en una línea de vida | Tres participantes separados; creaciones ordenadas y `loop` por Roles / `opt` PROVEEDOR | **CORREGIDO estáticamente** |
| R2-03 | DS UC-18 agrupaba `EventoAsignacionRol` y `SesionUsuario` | Dos líneas de vida, `«create»` de evento separada de la revocación opcional y en bucle | **CORREGIDO estáticamente** |
| R2-04 | UC-55 representaba múltiples sesiones sin iteración explícita | `sesionVigente:SesionUsuario` dentro de `loop` condicionado a deshabilitar | **CORREGIDO estáticamente** |
| R2-05 | UC-56 DSS mostraba selección sin mensaje equivalente en DS | Nuevo mensaje auxiliar de selección y retorno DS; aclaración en contrato UC-56 | **CORREGIDO internamente** |
| R2-06 | Visibilidad de catálogo «por atributo» afirmada como certeza | Se rotula como **propuesta no demostrada** en mensajes y se audita en matriz §4 | **CLASIFICADO, NO CERTIFICADO** |
| R2-07 | F07 presentado con garantías atómicas aunque sin pruebas | Contratos/DS explicitan F07 pendiente; no declarar validación concurrente | **CLASIFICADO, NO CERTIFICADO** |
| R2-08 | UC-54 omitía verificación de identidad comercial de ficha Real | Guarda de DS/DSS y precondición de contrato UC-54 | **CORREGIDO**, mecanismo detallado pendiente |
| R2-09 | UC-53 exigía credencial actual en firma propuesta sin evidencia plena en Word | **No se añadió ni se quitó** la exigencia por inferencia; se documentó reserva explícita en contrato | **PENDIENTE DE DECISIÓN/COINCIDENCIA** |
| R2-10 | Word de 64 CU conserva redacción previa a RP-009/RP-010 | Adenda de propagación separada, sin sobrescribir DOCX ni reescribir la historia | **ADENDA EMITIDA** |
| R2-11 | Contratos combinados en un solo archivo | Siete fichas separadas, nueve secciones cada una, con fuente y reservas | **CORREGIDO** |
| R2-12 | Tablas fantasma del corte Gemini anterior | Ningún XML propuesto menciona `CAMBIO_CREDENCIAL_USUARIO` ni `HISTORIAL_ESTADO_USUARIO`; MR-5/MR-6 conserva solo las estructuras citadas | **PASÓ textual** |

## 4. Matriz de visibilidad de Larman: evidencia, no invención

| CU | Mensaje/receptor | Fundamento de referencia | Juicio |
|---|---|---|---|
| 01 | Actor → `:ControladorSeguridad` | Frontera de sistema | **Frontera válida** |
| 01 | Controlador → `:CatalogoUsuarios` | Atributo/asociación **supuestos**, no se exhibe diseño de clases | **NO DEMOSTRADO** |
| 01 | Controlador → `unUsuario:Usuario` | Variable devuelta por catálogo | **Local**, sujeto a obtención real |
| 01 | Controlador → `unaSesion:SesionUsuario` | Creación `«create»` | **Por creación** |
| 17 | Controlador → catálogo; controlador → `nuevoUsuario` | Catálogo **no demostrado**; Usuario **por creación** | **MIXTO** |
| 17 | `nuevoUsuario` → `UsuarioRol` / `EventoAsignacionRol` / `UsuarioProveedor` | Mensajes `«create»` separados, Rol iterado, vínculo condicional | **Creación propuesta**, responsabilidades pendientes |
| 18 | Controlador → catálogo; controlador → `unUsuario` | Catálogo sin asociación demostrada, Usuario devuelto como local | **MIXTO** |
| 18 | Usuario → `EventoAsignacionRol` | Creación explícita | **Por creación** |
| 18 | Usuario → `sesionVigente:SesionUsuario` | Asociación por atributo **afirmada**, no verificada en diseño de clases | **NO DEMOSTRADO** |
| 53 | Controlador → `unaSesion` | Contexto de sesión autenticada, origen exacto de referencia no dibujado | **PARCIAL** |
| 53 | Controlador → `unUsuario` | Usuario devuelto desde sesión | **Local**, sujeto a sesión válida |
| 54 | Controlador → catálogo / `cuentaProv` | Repositorio supuesto; cuenta devuelta como local | **MIXTO** |
| 55 | Controlador → catálogo / `unUsuario` | Catálogo supuesto; Usuario devuelto como local | **MIXTO** |
| 55 | Usuario → `sesionVigente` | `loop` explicita multiplicidad; referencia aún sin fuente estructural | **NO DEMOSTRADO** |
| 56 | Controlador → catálogo → Usuarios | Referencia al catálogo supuesta; proyección segura no demuestra navegabilidad | **NO DEMOSTRADO** |
| 56 | Actor → controlador: `seleccionarUsuario` | Segundo evento público auxiliar, sin estado persistido | **Frontera**, requiere cotejo CU Real |

**Conclusión GRASP/Larman:** mejorar el diagrama no reemplaza un diseño de clases con atributos/asociaciones. Por tanto **no** se declara superada la puerta global de visibilidad.

## 5. Invariantes funcionales comprobadas textualmente

- **RP-010:** cualquier Usuario con credencial pendiente puede autenticarse, pero la API debe bloquear operaciones salvo UC-53; al cambiar correctamente se limpia la condición y se aplican sus roles. **No** existe columna `accesoRestringidoACambioClave` en `SESION_USUARIO`.
- **UC-17/18:** alta atómica con al menos un Rol; PROVEEDOR exclusivo, vinculado a Proveedor ACTIVO y con no más de una cuenta habilitada por Proveedor. F07 garantiza la seguridad funcional solo tras pruebas.
- **UC-54:** recuperación asistida exclusiva de PROVEEDOR, previa verificación comercial, sin habilitar automáticamente cuenta deshabilitada y sin crear segunda cuenta.
- **RP-009/UC-55:** deshabilitación de Repartidor con Pedidos PENDIENTE asignados queda rechazada; UC-43 reasigna previamente. El cambio de estado y revocación de sesiones debe ser atómico, pero **no fue ejecutado**.
- **UC-56:** búsqueda y selección no modifican Usuarios ni exponen `credencialProtegida` o `tokenProtegido`.
- **Cliente ONLINE:** queda fuera de los Usuarios que autentican mediante UC-01.

## 6. Qué falta antes de certificar académicamente

1. **Política UC-17 interno:** valor inicial de `cambioCredencialPendiente` según la emisión de su contraseña; no inventar `true` obligatorio para todo Usuario.
2. **Firma UC-53:** determinar si `credencialActual` es precondición obligatoria también en un primer cambio de clave temporal.
3. **Visibilidad Larman:** adjuntar clase/controlador con su asociación o mecanismo legítimo de referencia a `CatalogoUsuarios` y sesiones; documentar responsabilidades GRASP.
4. **F07:** pruebas reales de concurrencia, último administrador, roles mínimos y revocación completa; no basta con la palabra «atómica» en el XML.
5. **Draw.io:** abrir/edit/guardar/reabrir y verificar fragmentos, separación de operandos, legibilidad y líneas de vida; no se ejecutó GUI.
6. **Word maestro:** propagar adendas posteriores solo cuando se acuerde editar el documento canónico; el archivo hoy en `main` está un commit por delante de las ramas de PR #9/#10, y esa divergencia debe respetarse.
