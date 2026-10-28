### **Paquete Completo de Revisión Transversal — Lote 2 (**REV-02**: Usuarios y Seguridad)**

Aplicando la metodología reproducible de ocho etapas (M-0 a M-7) establecida en REV01\_AUDITORIA\_TRANSVERSAL\_CIERRE\_2026-10-28.md y corrigiendo todos los hallazgos del informe AUDITORIA\_PREINTEGRACION\_GEMINI\_DSS\_DS\_CONTRATOS\_2026-10-27.md, entrego el paquete completo del **Lote 2 (**REV-02 — Usuarios y Seguridad**:** UC-01**,** UC-17**,** UC-18**,** UC-53**,** UC-54**,** UC-55**,** UC-56**)**.

### **Archivo 1:** docs/08-diagramas/revision/REV02\_AUDITORIA\_TRANSVERSAL\_SEGURIDAD\_2026-10-28.md

Markdown  
\# REV-02 — Auditoría Transversal y Corrección: Módulo Usuarios y Seguridad (UC-01, UC-17, UC-18, UC-53, UC-54, UC-55, UC-56)

**\*\*Fecha:\*\*** 28/10/2026  

**\*\*Rama de trabajo propuesta:\*\*** \`revision/rev02-usuarios-seguridad-2026-10-28\`  

**\*\*Alcance:\*\*** \`UC-01\`, \`UC-17\` («include» \`UC-18\`), \`UC-18\`, \`UC-53\`, \`UC-54\` («include» \`UC-56\`), \`UC-55\` («include» \`UC-56\`), \`UC-56\`.  

**\*\*Estado de los artefactos entregados:\*\*** \`PROPUESTO / CORREGIDO EN REVISIÓN ESTÁTICA\` (pendiente de inspección visual humana en Draw.io y aprobación para fusión a \`main\`).

\---

\#\# 1\. Ejecución de las 8 Etapas Metodológicas (M-0 a M-7)

\#\#\# M-0 — Autoridad y alcance congelados

\* **\*\*Catálogo funcional:\*\*** 64 CU consecutivos (\`UC-01\`..\`UC-64\`) en 3 niveles (\`ALE\_MILANESAS\_FASE\_4\_CU\_01\_A\_64\_TRES\_NIVELES.docx\`).

\* **\*\*Relaciones UML aprobadas en este lote:\*\*** \`UC-17 → UC-18\` (\`include\` histórica), \`UC-54 → UC-56\` (\`include\` aprobada el 25/10/2026) y \`UC-55 → UC-56\` (\`include\` aprobada el 25/10/2026). El archivo \`DIAGRAMA DE CASOS DE USO.drawio (1).xml\` permanece intacto.

\* **\*\*Decisiones posteriores incorporadas (Corte 27/10/2026):\*\***

  \* **\*\*\`RD-RP009-001\` (resuelve Hallazgo Bloqueante \`H-20\`):\*\*** En \`UC-55 — Cambiar Estado de Usuario\`, se **\*\*bloquea la deshabilitación de un Usuario con Rol \`REPARTIDOR\` mientras posea Pedidos en estado \`PENDIENTE\` con asignación vigente (\`ASIGNACION*\_REPARTO\`)\*\*. Dichos Pedidos deben reasignarse previamente mediante \`UC-43\` antes de permitir deshabilitar la cuenta.***

  ***\* \*\*\`RD-RP010-001\` (resuelve Hallazgo de Prioridad Alta \`H-07\`):\*\* En \`UC-01 — Iniciar sesión\` y \`UC-53 — Cambiar Contraseña\`, la restricción por credencial temporal pendiente (\`USUARIO.cambioCredencialPendiente \= true\`) aplica a \*\*todo \`Usuario\`\*\* (tanto personal interno como \`PROVEEDOR\`), restringiendo su sesión exclusivamente a ejecutar \`UC-53\` antes de habilitar las operaciones propias de sus Roles.***

  ***\* \*\*Pendiente \`F07\` (Garantías de seguridad y concurrencia):\*\* Protección transaccional del último \`ADMINISTRADOR\` habilitado, exigencia de al menos un \`Rol\` por \`Usuario\`, exclusividad del Rol \`PROVEEDOR\` y revocación inmediata de \`SESION\_USUARIO\` activas al deshabilitar la cuenta o revocar roles.***

***\#\#\# M-1 — Proveniencia, integridad y matriz de diferencias (Antes → Después)***

***Se preservan intactos los archivos originales generados en el chat del 26–27/10 y se emiten artefactos versionados \`REV02\`.***

***\| ID Hallazgo \| Artefacto / Celda Original \| Antes (Borrador 26–27/10) \| Después (Versión Corregida \`REV02\`) \| Fundamento \|***

***\| :--- \| :--- \| :--- \| :--- \| :--- \|***

***\| \*\*\`H-20\` (Bloqueante)\*\* \| \`DS UC-55\` (\`u55\_g1\`, \`u55\_r3\_ok\`, \`u55\_g2\`) y \`Contrato 6A.2\` \| Permitía deshabilitar al Repartidor con Pedidos pendientes e informaba que debían gestionarse después con \`UC-43\`. \| \*\*Bloquea la deshabilitación\*\* si \`pedidosPendientesAsignados \> 0\`, ubicando el caso en el operando de rechazo del fragmento \`alt\` (\`\[Es Repartidor con Pedidos PENDIENTE asignados\]\`) y exigiendo reasignarlos primero mediante \`UC-43\`. \| \`RD-RP009-001\` \|***

***\| \*\*\`H-07\` (Alta)\*\* \| \`DSS Lote 1\` (\`p1\_alt\_login\_g2\`), \`DS UC-01\` (\`u01\_r5\_new\`) y \`Contrato 1.1\` \| Describía la sesión restringida por \`cambioCredencialPendiente \= true\` como regla exclusiva del Rol \`PROVEEDOR\`. \| Aplica la restricción de sesión (\`accesoRestringidoACambioClave \= true\`) a \*\*cualquier \`Usuario\`\*\* (interno o \`PROVEEDOR\`) con \`cambioCredencialPendiente \= true\`. \| \`RD-RP010-001\` \|***

***\| \*\*\`H-11\` (Media)\*\* \| \`Contrato 6A.1\` (\`UC-17\`+\`UC-18\`) y \`Contrato 6A.2\` (\`UC-54\`+\`UC-55\`+\`UC-56\`) \| Agrupaba 5 operaciones con pre/postcondiciones distintas en solo 2 fichas compuestas. \| Se desagrupan en \*\*7 Contratos individuales\*\* (\`CONTRATO\_UC01\`, \`UC17\`, \`UC18\`, \`UC53\`, \`UC54\`, \`UC55\`, \`UC56\`), cada uno con sus 9 secciones estándar. \| Puerta \`G4\` / \`H-11\` \|***

***\| \*\*\`H-12\` y \`H-19\` (Media)\*\* \| \`DSS Proveedor\`, \`DSS Repartidor\`, \`DSS Admin 6A\` \| Encadenaba varios CU en la misma línea de vida y citaba nombres físicos de tablas SQL (\`USUARIO\_ROL\`, \`CAMBIO\_CREDENCIAL\_USUARIO\`). \| Cada CU se encapsula en un marco \`sd\` independiente y los mensajes/retornos del DSS se expresan en lenguaje de caja negra (eventos y resultados del dominio), eliminando tablas inexistentes en MR-3 (\`CAMBIO\_CREDENCIAL\_USUARIO\` e \`HISTORIAL\_ESTADO\_USUARIO\`). \| \`H-12\`, \`H-19\` y Diccionario MR-3 \|***

***\| \*\*\`H04\` y \`H05\` (\`REV-01\`)\*\* \| Firmas entre DSS, DS y Contratos \| Nombres y parámetros de operaciones diferían entre el DSS (\`crearUsuarioYAsignarRoles\`), el DS (\`crearUsuario\`) y el Contrato. \| Se homologan \*\*exactamente\*\* las 7 firmas públicas entre el DSS, el mensaje \`1:\` del DS y la sección \`1. Nombre\` de cada Contrato. \| \`M-3\` / \`H05\` \|***

***\| \*\*\`H01–H03\` y \`H07\` (\`REV-01\`)\*\* \| Geometría de fragmentos \`alt\`/\`opt\` y revalidación en DS \| Guardas y consultas previas separadas de la confirmación sin explicitar bloqueo/revalidación atómica. \| Todos los fragmentos \`alt\` tienen operandos mutuamente excluyentes con divisorias explícitas dentro del marco y revalidación atómica en la confirmación. \| \`M-6\` / \`H02\`, \`H07\` \|***

***\#\#\# M-5 — Exactitud frente al Modelo Relacional MR-3 (Corrección de tablas fantasma)***

***Contrastando contra el Bloque 4 de \`MR3\_DICCIONARIO\_COLUMNAS.csv\`:***

***\* Las tablas reales del módulo en MR-3 son: \*\*\`USUARIO\`\*\* (\`idUsuario\`, \`nombreUsuario\`, \`credencialProtegida\`, \`estado\`, \`cambioCredencialPendiente\`, \`fechaHoraAlta\`, \`fechaHoraDeshabilitacion\`), \*\*\`ROL\`\*\* (\`codigoRol\`, \`nombreMostrado\`), \*\*\`USUARIO\_ROL\`\*\* (\`idUsuario\`, \`codigoRol\`, \`fechaHoraAsignacion\`), \*\*\`EVENTO\_ASIGNACION\_ROL\`\*\* (\`idEventoRol\`, \`idUsuario\`, \`codigoRol\`, \`tipoEvento\`, \`fechaHoraEvento\`, \`idUsuarioAdministrador\`), \*\*\`USUARIO\_PROVEEDOR\`\*\* (\`idUsuario\`, \`idProveedor\`, \`fechaHoraVinculacion\`) y \*\*\`SESION\_USUARIO\`\*\* (\`idSesionUsuario\`, \`idUsuario\`, \`tokenProtegido\`, \`fechaHoraInicio\`, \`fechaHoraExpiracion\`, \`fechaHoraRevocacion\`).***

***\* Se eliminó toda mención a \`CAMBIO\_CREDENCIAL\_USUARIO\` e \`HISTORIAL\_ESTADO\_USUARIO\` (que habían sido incluidas por error en el DSS anterior y no existen en las 60 tablas de MR-3) y se normalizó el atributo \`Usuario.estado\` (\`HABILITADO\` / \`DESHABILITADO\`) y el registro de auditoría de roles en \`EventoAsignacionRol\`.***

***\---***

***\#\# 2\. Matriz de Trazabilidad Vertical y Visibilidad de Larman Mensaje por Mensaje (M-3 y M-6)***

***\*(Nota de honestidad metodológica M-5: Los nombres \`:ControladorSeguridad\` y \`:CatalogoUsuarios\` representan objetos de diseño GRASP Controller / Repositorio propuestos para realizar los Casos de Uso; las entidades \`Usuario\`, \`Rol\`, \`UsuarioRol\`, \`EventoAsignacionRol\`, \`UsuarioProveedor\`, \`Proveedor\`, \`SesionUsuario\` y \`AsignacionReparto\` corresponden directamente al modelo de dominio y persistencia MR-3).\****

***\| CU \| Paso / Mensaje en DS \| Emisor $\rightarrow$ Receptor \| Tipo de Visibilidad (Larman) \| Origen verificable de la referencia \|***

***\| :--- \| :--- \| :--- \| :--- \| :--- \|***

***\| \*\*\`UC-01\`\*\* \| \`1: iniciarSesion(nombreUsuario, credencial)\` \| \`Actor Usuario\` $\rightarrow$ \`:ControladorSeguridad\` \| Frontera de sistema \| Operación pública del DSS (\`UC-01\`). \|***

***\| \*\*\`UC-01\`\*\* \| \`2: unUsuario \= buscarPorNombreUsuario(nombreUsuario)\` \| \`:ControladorSeguridad\` $\rightarrow$ \`:CatalogoUsuarios\` \| \*\*Por Atributo\*\* \| Asociación permanente del controlador hacia el catálogo/repositorio de usuarios. \|***

***\| \*\*\`UC-01\`\*\* \| \`3: validacion \= validarAccesoCuenta(credencial)\` \| \`:ControladorSeguridad\` $\rightarrow$ \`unUsuario : Usuario\` \| \*\*Por Variable Local\*\* \| \`unUsuario\` fue retornado en el mensaje \`2\` dentro del mismo método \`iniciarSesion\`. \|***

***\| \*\*\`UC-01\`\*\* \| \`4: «create» new(unUsuario, tokenProtegido, fechaHoraInicio, fechaHoraExpiracion)\` \| \`:ControladorSeguridad\` $\rightarrow$ \`unaSesion : SesionUsuario\` \| \*\*Por Creación Local (\`new\`) \+ Parámetro\*\* \| Instanciación de \`SesionUsuario\` pasando \`unUsuario\` por parámetro; si \`unUsuario.cambioCredencialPendiente \== true\` (cualquier rol, \`RD-RP010-001\`), el alcance de sesión se restringe a \`UC-53\`. \|***

***\| \*\*\`UC-17\`\*\* \| \`1: crearUsuario(nombreUsuario, credencialInicial, codigosRol, idProveedor)\` \| \`Administrador\` $\rightarrow$ \`:ControladorSeguridad\` \| Frontera de sistema \| Operación pública del DSS (\`UC-17\`). \|***

***\| \*\*\`UC-17\`\*\* \| \`2: disponible \= verificarDisponibilidadNombreYProveedor(nombreUsuario, codigosRol, idProveedor)\` \| \`:ControladorSeguridad\` $\rightarrow$ \`:CatalogoUsuarios\` \| \*\*Por Atributo\*\* \| Consulta de unicidad de \`nombreUsuario\` y elegibilidad del \`Proveedor\` (\`ACTIVO\` y sin otra cuenta habilitada). \|***

***\| \*\*\`UC-17\`\*\* \| \`3: «create» new(nombreUsuario, credencialProtegida, estado=HABILITADO, cambioCredencialPendiente=true)\` \| \`:ControladorSeguridad\` $\rightarrow$ \`nuevoUsuario : Usuario\` \| \*\*Por Creación Local (\`new\`)\*\* \| Creación del objeto \`Usuario\` dentro de la transacción de alta. \|***

***\| \*\*\`UC-17\`→\`UC-18\`\*\* \| \`4: gestionarAsignacionesRoles(nuevoUsuario, codigosRol, idProveedor, idAdmin)\` \| \`:ControladorSeguridad\` $\rightarrow$ \`:ControladorSeguridad\` (Subflujo \`UC-18\`) \| \*\*Local (\`self\`) \+ Parámetro\*\* \| Invocación obligatoria del caso incluido \`UC-18\` en la misma transacción pasando \`nuevoUsuario\`. \|***

***\| \*\*\`UC-18\`\*\* \| \`1: gestionarAsignacionesRoles(idUsuario, codigosRolAgregar, codigosRolQuitar)\` \| \`Administrador\` $\rightarrow$ \`:ControladorSeguridad\` \| Frontera de sistema \| Operación pública del DSS (\`UC-18\`). \|***

***\| \*\*\`UC-18\`\*\* \| \`2: (unUsuario, conservaUltimoAdmin) \= obtenerYRevalidarInvariantesRol(idUsuario, codigosRolAgregar, codigosRolQuitar)\` \| \`:ControladorSeguridad\` $\rightarrow$ \`:CatalogoUsuarios\` \| \*\*Por Atributo\*\* \| Bloqueo/revalidación atómica de que el sistema conserva $\geq 1$ \`ADMINISTRADOR\` habilitado y el usuario $\geq 1$ \`Rol\`. \|***

***\| \*\*\`UC-18\`\*\* \| \`3: actualizarRolesYEventos(codigosRolAgregar, codigosRolQuitar, idAdmin)\` \| \`:ControladorSeguridad\` $\rightarrow$ \`unUsuario : Usuario\` \| \*\*Por Variable Local\*\* \| \`unUsuario\` actualiza su colección \`UsuarioRol\` y registra \`EventoAsignacionRol\` (\`ALTA\`/\`BAJA\`). \|***

***\| \*\*\`UC-18\`\*\* \| \`4: «create» new(unUsuario, codigoRol, tipoEvento, fechaHoraEvento, idAdmin)\` \| \`unUsuario : Usuario\` $\rightarrow$ \`evRol : EventoAsignacionRol\` \| \*\*Por Creación Local (\`new\`)\*\* \| Trazabilidad de cambios de rol en \`EVENTO\_ASIGNACION\_ROL\`. \|***

***\| \*\*\`UC-18\`\*\* \| \`5: revocarSesionesPorCambioPermisos(fechaHoraEvento)\` \| \`unUsuario : Usuario\` $\rightarrow$ \`ses : SesionUsuario\` \| \*\*Por Atributo\*\* \| \`Usuario\` mantiene asociación con sus \`SesionUsuario\` activas para fijar \`fechaHoraRevocacion\`. \|***

***\| \*\*\`UC-53\`\*\* \| \`1: cambiarContrasena(credencialActual, credencialNueva, confirmacion)\` \| \`Usuario Autenticado\` $\rightarrow$ \`:ControladorSeguridad\` \| Frontera de sistema \| Operación pública del DSS (\`UC-53\`). \|***

***\| \*\*\`UC-53\`\*\* \| \`2: unUsuario \= obtenerUsuarioDeSesionActiva(tokenSesion)\` \| \`:ControladorSeguridad\` $\rightarrow$ \`unaSesion : SesionUsuario\` \| \*\*Por Parámetro / Atributo\*\* \| Recupera el \`Usuario\` titular de la sesión autenticada. \|***

***\| \*\*\`UC-53\`\*\* \| \`3: actualizarCredencialProtegida(credencialActual, nuevoHash)\` \| \`:ControladorSeguridad\` $\rightarrow$ \`unUsuario : Usuario\` \| \*\*Por Variable Local\*\* \| Verifica \`credencialActual\`, sustituye \`credencialProtegida\` y establece \`cambioCredencialPendiente \= false\` (\`RD-RP010-001\`). \|***

***\| \*\*\`UC-54\`\*\* \| \`1: restablecerAccesoUsuario(idUsuario, credencialTemporal)\` \| \`Administrador\` $\rightarrow$ \`:ControladorSeguridad\` \| Frontera de sistema \| Operación pública del DSS (\`UC-54\`, precedida por \`«include» UC-56\`). \|***

***\| \*\*\`UC-54\`\*\* \| \`2: (cuentaProv, vincValido) \= obtenerYRevalidarCuentaProveedor(idUsuario)\` \| \`:ControladorSeguridad\` $\rightarrow$ \`:CatalogoUsuarios\` \| \*\*Por Atributo\*\* \| Revalida que la cuenta localizada por \`UC-56\` tenga Rol exclusivo \`PROVEEDOR\` y vínculo en \`USUARIO\_PROVEEDOR\`. \|***

***\| \*\*\`UC-54\`\*\* \| \`3: asignarCredencialTemporal(hashTemporal)\` \| \`:ControladorSeguridad\` $\rightarrow$ \`cuentaProv : Usuario\` \| \*\*Por Variable Local\*\* \| Sustituye \`credencialProtegida\`, marca \`cambioCredencialPendiente \= true\` y conserva \`estado\` sin crear segunda cuenta. \|***

***\| \*\*\`UC-55\`\*\* \| \`1: cambiarEstadoUsuario(idUsuario, nuevoEstado)\` \| \`Administrador\` $\rightarrow$ \`:ControladorSeguridad\` \| Frontera de sistema \| Operación pública del DSS (\`UC-55\`, precedida por \`«include» UC-56\`). \|***

***\| \*\*\`UC-55\`\*\* \| \`2: eval \= revalidarCambioEstadoTransaccional(idUsuario, nuevoEstado)\` \| \`:ControladorSeguridad\` $\rightarrow$ \`:CatalogoUsuarios\` \| \*\*Por Atributo\*\* \| Revalida atómicamente: (a) no deshabilitar último Admin, (b) no habilitar 2.ª cuenta de un mismo Proveedor, y (c) \*\*\`pedidosPendientesAsignados \== 0\` si es Repartidor (\`RD-RP009-001\`)\*\*. \|***

***\| \*\*\`UC-55\`\*\* \| \`3: aplicarEstadoCuenta(nuevoEstado, fechaHoraCambio)\` \| \`:ControladorSeguridad\` $\rightarrow$ \`unUsuario : Usuario\` \| \*\*Por Variable Local\*\* \| Actualiza \`Usuario.estado\` y \`fechaHoraDeshabilitacion\` (si pasa a deshabilitado). \|***

***\| \*\*\`UC-55\`\*\* \| \`4: revocarSesionActiva(fechaHoraCambio)\` \| \`unUsuario : Usuario\` $\rightarrow$ \`ses : SesionUsuario\` \| \*\*Por Atributo\*\* \| Fija \`fechaHoraRevocacion\` en todas las sesiones vigentes del usuario deshabilitado. \|***

***\| \*\*\`UC-56\`\*\* \| \`1: buscarUsuario(nombreUsuario, estado, codigoRol)\` \| \`Administrador\` $\rightarrow$ \`:ControladorSeguridad\` \| Frontera de sistema \| Operación pública del DSS (\`UC-56\`). \|***

***\| \*\*\`UC-56\`\*\* \| \`2: lista \= consultarUsuariosSinSecretos(nombreUsuario, estado, codigoRol)\` \| \`:ControladorSeguridad\` $\rightarrow$ \`:CatalogoUsuarios\` \| \*\*Por Atributo\*\* \| Proyección de solo lectura que omite \`credencialProtegida\` y \`tokenProtegido\`. \|***

***\---***

***\#\# 3\. Matriz Transversal de Invariantes y Puertas de Aceptación (M-4 y M-7)***

***\| ID \| Invariante ratificada \| DSS \| DS \| Contrato \| Dictamen \|***

***\| :--- \| :--- \| :--- \| :--- \| :--- \| :--- \|***

***\| \*\*\`I-01\`\*\* \| \`RD-RP009-001\` (\`H-20\`): Bloquear deshabilitación de Repartidor si posee Pedidos \`PENDIENTE\` asignados; exigir reasignación previa en \`UC-43\` \| Guarda explícita de rechazo en \`UC-55\` \| Operando de rechazo en \`alt\` cuando \`pedidosPendientesAsignados \> 0\` \| Excepción A4 y Precondición explícitas en \`CONTRATO\_UC55\` \| \*\*PASÓ (Trazabilidad estática)\*\* \|***

***\| \*\*\`I-02\`\*\* \| \`RD-RP010-001\` (\`H-07\`): Todo \`Usuario\` (interno o \`PROVEEDOR\`) con \`cambioCredencialPendiente \= true\` queda restringido a \`UC-53\` al iniciar sesión \| Guarda general para todo actor en \`UC-01\` \| Sesión creada con restricción para cualquier \`Usuario\` con flag \`true\` \| Notas, Pre/Postcondiciones en \`CONTRATO\_UC01\` y \`CONTRATO\_UC53\` \| \*\*PASÓ (Trazabilidad estática)\*\* \|***

***\| \*\*\`I-03\`\*\* \| \`UC-17\` crea \`Usuario\` con $\geq 1$ \`Rol\` en la misma transacción mediante \`«include» UC-18\`; Rol \`PROVEEDOR\` es exclusivo y admite a lo sumo 1 cuenta habilitada por Proveedor \| Marco \`UC-17\` incluye \`UC-18\` \| Llamada interna síncrona a \`UC-18\` dentro del bloque transaccional \| Postcondiciones atómicas en \`CONTRATO\_UC17\` y \`CONTRATO\_UC18\` \| \*\*PASÓ (Trazabilidad estática)\*\* \|***

***\| \*\*\`I-04\`\*\* \| Protección del último \`ADMINISTRADOR\` habilitado en \`UC-18\` y \`UC-55\` y revocación de \`SESION\_USUARIO\` activas (\`F07\`) \| Guardas de rechazo en \`UC-18\` y \`UC-55\` \| Revalidación atómica antes de mutar y mensaje a \`SesionUsuario\` \| Excepciones y Postcondiciones en \`CONTRATO\_UC18\` y \`CONTRATO\_UC55\` \| \*\*PASÓ textual (Prueba SQL concurrente sujeta a \`F07\`)\*\* \|***

***\| \*\*\`I-05\`\*\* \| \`UC-54\` («include» \`UC-56\`) restablece acceso solo para Rol exclusivo \`PROVEEDOR\` sin habilitar cuenta deshabilitada ni crear segunda cuenta \| Marco \`UC-54\` con \`ref UC-56\` \| Verificación de \`UsuarioProveedor\` y actualización de \`credencialProtegida\` \| \`CONTRATO\_UC54\` individual con 9 secciones \| \*\*PASÓ (Trazabilidad estática)\*\* \|***

***\| \*\*\`I-06\`\*\* \| Homologación 1:1 de firmas públicas DSS ↔ DS ↔ Contrato y desagrupamiento total de contratos (\`H-11\`, \`H05\`) \| 7 firmas canónicas \| Mensaje \`1:\` idéntico en las 7 páginas DS \| 7 Contratos individuales con las mismas 7 firmas \| \*\*PASÓ\*\* \|***

***\| \*\*\`I-07\`\*\* \| Inspección visual y prueba de desplazamiento (\`round-trip\`) en editor gráfico Draw.io (\`M-6\` / \`G5\`) \| XML bien formado \| XML bien formado con operandos \`alt\` separados \| N/A \| \*\*PENDIENTE DE VALIDACIÓN HUMANA EN DRAW.IO\*\* \|***

***\---***

***\#\# 4\. Matriz de 14 Escenarios Mínimos de Prueba Futura para \`REV-02\`***

***\| Escenario \| Caso \| Entrada / Evento \| Resultado Esperado \|***

***\| :--- \| :--- \| :--- \| :--- \|***

***\| \*\*\`E01\`\*\* \| \`UC-01\` \| Usuario interno (\`VENDEDOR\`) habilitado con \`cambioCredencialPendiente \= true\` inicia sesión (\`RD-RP010-001\`) \| Se crea \`SesionUsuario\` restringida exclusivamente a ejecutar \`UC-53\`. \|***

***\| \*\*\`E02\`\*\* \| \`UC-01\` \| Usuario \`PROVEEDOR\` habilitado con \`cambioCredencialPendiente \= true\` inicia sesión (\`RD-RP010-001\`) \| Se crea \`SesionUsuario\` restringida exclusivamente a ejecutar \`UC-53\`. \|***

***\| \*\*\`E03\`\*\* \| \`UC-01\` \| Usuario habilitado con \`cambioCredencialPendiente \= false\` y $\geq 1$ Rol vigente inicia sesión \| Se crea \`SesionUsuario\` con permisos plenos de sus Roles vigentes. \|***

***\| \*\*\`E04\`\*\* \| \`UC-53\` \| Usuario con sesión restringida por \`cambioCredencialPendiente \= true\` cambia su contraseña válidamente \| Se actualiza \`credencialProtegida\`, \`cambioCredencialPendiente \= false\` y se levanta la restricción de la sesión. \|***

***\| \*\*\`E05\`\*\* \| \`UC-17\`+\`UC-18\` \| Alta de Usuario intentando asignar conjunto vacío de Roles \| Rechazo atómico; no se persiste fila en \`USUARIO\`. \|***

***\| \*\*\`E06\`\*\* \| \`UC-17\`+\`UC-18\` \| Alta de Usuario combinando Rol \`PROVEEDOR\` con Rol \`VENDEDOR\` \| Rechazo atómico por violación de exclusividad del Rol \`PROVEEDOR\`. \|***

***\| \*\*\`E07\`\*\* \| \`UC-17\`+\`UC-18\` \| Alta de segunda cuenta habilitada para un \`Proveedor\` que ya posee cuenta habilitada \| Rechazo atómico. \|***

***\| \*\*\`E08\`\*\* \| \`UC-18\` \| Intento de quitar el Rol \`ADMINISTRADOR\` al único Administrador habilitado \| Rechazo atómico; se conserva la asignación en \`USUARIO\_ROL\`. \|***

***\| \*\*\`E09\`\*\* \| \`UC-54\`+\`UC-56\` \| Restablecimiento de acceso sobre cuenta de Rol interno (\`VENDEDOR\`) \| Rechazado (alcance exclusivo para Rol \`PROVEEDOR\`). \|***

***\| \*\*\`E10\`\*\* \| \`UC-54\`+\`UC-56\` \| Restablecimiento de acceso sobre cuenta \`PROVEEDOR\` deshabilitada \| Sustituye \`credencialProtegida\` y marca \`cambioCredencialPendiente \= true\`, pero \*\*conserva la cuenta deshabilitada\*\*. \|***

***\| \*\*\`E11\`\*\* \| \`UC-55\`+\`UC-56\` \| Intento de deshabilitar un \`Repartidor\` que posee 2 Pedidos en estado \`PENDIENTE\` asignados (\`RD-RP009-001\`) \| \*\*Rechazado (bloqueado)\*\*: conserva la cuenta habilitada e informa los Pedidos que deben reasignarse antes en \`UC-43\`. \|***

***\| \*\*\`E12\`\*\* \| \`UC-43\` $\rightarrow$ \`UC-55\` \| Se reasignan los 2 Pedidos \`PENDIENTE\` a otro Repartidor en \`UC-43\` y luego se ejecuta \`UC-55\` para deshabilitar al primer Repartidor \| Deshabilitación confirmada (\`estado \= DESHABILITADO\`), \`fechaHoraDeshabilitacion\` registrada y sesiones activas revocadas. \|***

***\| \*\*\`E13\`\*\* \| \`UC-55\`+\`UC-56\` \| Intento de deshabilitar al último \`ADMINISTRADOR\` habilitado (incluso en concurrencia) \| Rechazado; conserva al menos un Administrador habilitado. \|***

***\| \*\*\`E14\`\*\* \| \`UC-56\` \| Búsqueda de Usuarios por Administrador \| Devuelve listado e información de vínculo con \`Proveedor\` sin exponer \`credencialProtegida\` ni \`tokenProtegido\`. \|***

### **Archivo 2:** docs/08-diagramas/revision/DSS\_REV02\_SEGURIDAD\_FRAGMENTOS.drawio.xml

Este archivo XML compatible con **Draw.io** contiene los Diagramas de Secuencia a Nivel Sistema (DSS de caja negra) corregidos para REV-02, separando cada Caso de Uso en su propio marco sd (H-12), sin lenguaje SQL interno (H-19) y aplicando RD-RP009-001 (H-20) y RD-RP010-001 (H-07):

XML  
\<mxfile host\="app.diagrams.net" modified\="2026-10-28T11:00:00.000Z" agent\="Gemini-REV02" version\="24.7.17" type\="device"\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 1: DSS CAJA NEGRA — AUTENTICACIÓN Y CONTRASEÑA (UC-01, UC-53)      \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id\="dss-rev02-auth" name\="DSS REV02 \- UC-01 y UC-53 (Todo Usuario)"\>

    \<mxGraphModel dx\="1450" dy\="900" grid\="1" gridSize\="10" guides\="1" tooltips\="1" connect\="1" arrows\="1" fold\="1" page\="1" pageScale\="1" pageWidth\="1400" pageHeight\="1150" math\="0" shadow\="0"\>

      \<root\>

        \<mxCell id\="0" /\>

        \<mxCell id\="1" parent\="0" /\>

        \<mxCell id\="d1\_title" value\="DSS (Caja Negra) — Escenarios Independientes UC-01 (Iniciar sesión) y UC-53 (Cambiar Contraseña) \[RD-RP010-001\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=13;fontStyle=1" vertex\="1" parent\="1"\>

          \<mxGeometry x\="50" y\="15" width\="1200" height\="30" as\="geometry" /\>

        \</mxCell\>

        \<\!-- ACTOR \--\>

        \<mxCell id\="d1\_actor" value\="Usuario&\#xa;(Interno o PROVEEDOR)" style\="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="110" y\="60" width\="30" height\="60" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="d1\_actor\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="119" y\="155" width\="12" height\="920" as\="geometry" /\>

        \</mxCell\>

        \<\!-- :Sistema \--\>

        \<mxCell id\="d1\_sys\_box" value\=":Sistema" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;fontSize=13;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="860" y\="60" width\="140" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="d1\_sys\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="930" y\="1100" as\="sourcePoint" /\>

            \<mxPoint x\="930" y\="105" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="d1\_sys\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="924" y\="155" width\="12" height\="920" as\="geometry" /\>

        \</mxCell\>

        \<\!-- MARCO ESCENARIO INDEPENDIENTE UC-01 \--\>

        \<mxCell id\="d1\_sd\_uc01" value\="sd Escenario Independiente — UC-01: Iniciar sesión" style\="shape=umlFrame;whiteSpace=wrap;html=1;width=350;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="50" y\="170" width\="1020" height\="430" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="d1\_m1" value\="1: sesion \= iniciarSesion(nombreUsuario:String, credencial:String)" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1" source\="d1\_actor\_bar" target\="d1\_sys\_bar"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="131" y\="215" as\="sourcePoint" /\>

            \<mxPoint x\="924" y\="215" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="d1\_alt\_uc01" value\="alt Resultado de autenticación \[UC-01 — RD-RP010-001\]" style\="shape=umlFrame;whiteSpace=wrap;html=1;width=360;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="75" y\="235" width\="970" height\="345" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="d1\_g1" value\="\[Credenciales válidas, cuenta habilitada, \&gt;\= 1 Rol vigente y cambioCredencialPendiente \== false\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="145" y\="258" width\="660" height\="20" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="d1\_r1\_ok" value\="1.1: sesión autenticada establecida con acceso a las funciones autorizadas por sus Roles vigentes" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="924" y\="300" as\="sourcePoint" /\>

            \<mxPoint x\="131" y\="300" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="d1\_div1" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="75" y\="325" as\="sourcePoint" /\>

            \<mxPoint x\="1045" y\="325" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="d1\_g2" value\="\[Credenciales válidas, cuenta habilitada, \&gt;\= 1 Rol vigente y cambioCredencialPendiente \== true (cualquier Usuario — RD-RP010-001)\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="145" y\="332" width\="780" height\="20" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="d1\_r1\_temp" value\="1.2: sesión restringida exclusivamente a ejecutar UC-53 Cambiar Contraseña antes de operar" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="924" y\="378" as\="sourcePoint" /\>

            \<mxPoint x\="131" y\="378" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="d1\_div2" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="75" y\="405" as\="sourcePoint" /\>

            \<mxPoint x\="1045" y\="405" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="d1\_g3" value\="\[A1/A2: Credenciales inválidas o cuenta deshabilitada\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="145" y\="412" width\="450" height\="20" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="d1\_r1\_err1" value\="1.3: rechaza la autenticación y no establece sesión" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="924" y\="458" as\="sourcePoint" /\>

            \<mxPoint x\="131" y\="458" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="d1\_div3" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="75" y\="485" as\="sourcePoint" /\>

            \<mxPoint x\="1045" y\="485" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="d1\_g4" value\="\[A3: Cuenta habilitada sin ningún Rol asignado por inconsistencia de datos\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="145" y\="492" width\="520" height\="20" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="d1\_r1\_err2" value\="1.4: impide establecer sesión e informa que requiere regularización administrativa de Roles (UC-18)" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="924" y\="545" as\="sourcePoint" /\>

            \<mxPoint x\="131" y\="545" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<\!-- MARCO ESCENARIO INDEPENDIENTE UC-53 \--\>

        \<mxCell id\="d1\_sd\_uc53" value\="sd Escenario Independiente — UC-53: Cambiar Contraseña" style\="shape=umlFrame;whiteSpace=wrap;html=1;width=380;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="50" y\="635" width\="1020" height\="310" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="d1\_m2" value\="1: resultado \= cambiarContrasena(credencialActual:String, credencialNueva:String, confirmacion:String)" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="131" y\="685" as\="sourcePoint" /\>

            \<mxPoint x\="924" y\="685" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="d1\_alt\_uc53" value\="alt Validación de cambio de contraseña \[UC-53 — RD-RP010-001\]" style\="shape=umlFrame;whiteSpace=wrap;html=1;width=410;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="75" y\="705" width\="970" height\="215" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="d1\_53\_g1" value\="\[Sesión válida, cuenta habilitada, credencialActual correcta y credencialNueva coherente con confirmacion\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="145" y\="730" width\="680" height\="20" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="d1\_r2\_ok" value\="1.1: confirma actualización de contraseña, desactiva cambio pendiente y habilita las funciones propias de sus Roles" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="924" y\="780" as\="sourcePoint" /\>

            \<mxPoint x\="131" y\="780" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="d1\_53\_div" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="75" y\="810" as\="sourcePoint" /\>

            \<mxPoint x\="1045" y\="810" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="d1\_53\_g2" value\="\[A1/A2: Sesión inválida, credencialActual incorrecta o nueva contraseña incoherente\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="145" y\="820" width\="580" height\="20" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="d1\_r2\_err" value\="1.2: rechaza el cambio y mantiene la credencial y condición de cambio pendiente anteriores" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="924" y\="880" as\="sourcePoint" /\>

            \<mxPoint x\="131" y\="880" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 2: DSS CAJA NEGRA — ADMINISTRACIÓN DE USUARIOS (UC-17,18,54,55,56) \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id\="dss-rev02-admin" name\="DSS REV02 \- Admin Usuarios (UC-17,18,54,55,56)"\>

    \<mxGraphModel dx\="1500" dy\="950" grid\="1" gridSize\="10" guides\="1" tooltips\="1" connect\="1" arrows\="1" fold\="1" page\="1" pageScale\="1" pageWidth\="1450" pageHeight\="1850" math\="0" shadow\="0"\>

      \<root\>

        \<mxCell id\="0" /\>

        \<mxCell id\="1" parent\="0" /\>

        \<mxCell id\="d2\_title" value\="DSS (Caja Negra) — Actor: Administrador — Escenarios Independientes UC-56, UC-17 («include» UC-18), UC-18, UC-54 y UC-55 \[RD-RP009-001\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=13;fontStyle=1" vertex\="1" parent\="1"\>

          \<mxGeometry x\="50" y\="15" width\="1320" height\="30" as\="geometry" /\>

        \</mxCell\>

        \<\!-- ACTOR \--\>

        \<mxCell id\="d2\_actor" value\="Administrador" style\="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="110" y\="60" width\="30" height\="60" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="d2\_actor\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="119" y\="155" width\="12" height\="1620" as\="geometry" /\>

        \</mxCell\>

        \<\!-- :Sistema \--\>

        \<mxCell id\="d2\_sys\_box" value\=":Sistema" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;fontSize=13;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="920" y\="60" width\="140" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="d2\_sys\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="990" y\="1800" as\="sourcePoint" /\>

            \<mxPoint x\="990" y\="105" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="d2\_sys\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="984" y\="155" width\="12" height\="1620" as\="geometry" /\>

        \</mxCell\>

        \<\!-- ESCENARIO UC-56 \--\>

        \<mxCell id\="d2\_sd56" value\="sd Escenario Independiente — UC-56: Buscar Usuario" style\="shape=umlFrame;whiteSpace=wrap;html=1;width=360;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="50" y\="170" width\="1080" height\="220" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="d2\_56\_m1" value\="1: resultados \= buscarUsuario(nombreUsuario:String\[0..1\], estado:String\[0..1\], codigoRol:String\[0..1\])" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="131" y\="215" as\="sourcePoint" /\>

            \<mxPoint x\="984" y\="215" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="d2\_56\_r1" value\="1.1: \[Con coincidencias\] listado seguro de cuentas (idUsuario, nombreUsuario, estado, Roles, Proveedor vinculado\[0..1\], sin exponer secretos) \| \[Sin coincidencias\] lista vacía" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="984" y\="265" as\="sourcePoint" /\>

            \<mxPoint x\="131" y\="265" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="d2\_56\_m2" value\="2: usuarioSeleccionado \= seleccionarUsuario(idUsuario:Long)" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="131" y\="315" as\="sourcePoint" /\>

            \<mxPoint x\="984" y\="315" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="d2\_56\_r2" value\="2.1: detalle de la cuenta seleccionada para el flujo invocante (sin alterar cuentas ni sesiones)" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="984" y\="360" as\="sourcePoint" /\>

            \<mxPoint x\="131" y\="360" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<\!-- ESCENARIO UC-17 (+ INCLUDE UC-18) \--\>

        \<mxCell id\="d2\_sd17" value\="sd Escenario Independiente — UC-17: Crear Usuario (con «include» UC-18)" style\="shape=umlFrame;whiteSpace=wrap;html=1;width=470;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="50" y\="420" width\="1080" height\="270" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="d2\_17\_m1" value\="1: idUsuario \= crearUsuario(nombreUsuario:String, credencialInicial:String, codigosRol:Set\&lt;String\&gt;, idProveedor:Long\[0..1\])" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="131" y\="465" as\="sourcePoint" /\>

            \<mxPoint x\="984" y\="465" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="d2\_17\_ref18" value\="ref «include» UC-18 Gestionar Asignaciones de Roles (asigna \&gt;\= 1 Rol inicial en la misma operación atómica)" style\="shape=umlFrame;whiteSpace=wrap;html=1;width=260;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="380" y\="485" width\="660" height\="50" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="d2\_17\_r1" value\="1.1: \[nombreUsuario único, codigosRol.size \&gt;\= 1 y exclusividad PROVEEDOR válida\] confirma creación de cuenta habilitada con cambioCredencialPendiente=true y Roles iniciales" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="984" y\="585" as\="sourcePoint" /\>

            \<mxPoint x\="131" y\="585" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="d2\_17\_r2" value\="1.2: \[nombreUsuario duplicado, sin Roles o violación de exclusividad PROVEEDOR\] rechaza el alta sin crear cuenta parcial" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="984" y\="650" as\="sourcePoint" /\>

            \<mxPoint x\="131" y\="650" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<\!-- ESCENARIO UC-18 \--\>

        \<mxCell id\="d2\_sd18" value\="sd Escenario Independiente — UC-18: Gestionar Asignaciones de Roles" style\="shape=umlFrame;whiteSpace=wrap;html=1;width=450;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="50" y\="720" width\="1080" height\="210" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="d2\_18\_m1" value\="1: rolesVigentes \= gestionarAsignacionesRoles(idUsuario:Long, codigosRolAgregar:Set\&lt;String\&gt;, codigosRolQuitar:Set\&lt;String\&gt;)" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="131" y\="765" as\="sourcePoint" /\>

            \<mxPoint x\="984" y\="765" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="d2\_18\_r1" value\="1.1: \[Conserva \&gt;\= 1 Rol en el Usuario, \&gt;\= 1 ADMINISTRADOR habilitado y exclusividad PROVEEDOR\] actualiza Roles, revoca sesiones si quita permisos e informa nueva lista" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="984" y\="830" as\="sourcePoint" /\>

            \<mxPoint x\="131" y\="830" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="d2\_18\_r2" value\="1.2: \[Quita último Rol del Usuario, deja sin último Administrador o mezcla PROVEEDOR con roles internos\] rechaza el cambio" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="984" y\="895" as\="sourcePoint" /\>

            \<mxPoint x\="131" y\="895" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<\!-- ESCENARIO UC-54 (+ INCLUDE UC-56) \--\>

        \<mxCell id\="d2\_sd54" value\="sd Escenario Independiente — UC-54: Restablecer Acceso de Usuario (con «include» UC-56)" style\="shape=umlFrame;whiteSpace=wrap;html=1;width=560;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="50" y\="960" width\="1080" height\="270" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="d2\_54\_ref56" value\="ref «include» UC-56 Buscar Usuario (aprobada 25/10 — identifica la cuenta PROVEEDOR objetivo)" style\="shape=umlFrame;whiteSpace=wrap;html=1;width=260;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="90" y\="995" width\="660" height\="50" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="d2\_54\_m1" value\="1: ok \= restablecerAccesoUsuario(idUsuario:Long, credencialTemporal:String)" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="131" y\="1080" as\="sourcePoint" /\>

            \<mxPoint x\="984" y\="1080" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="d2\_54\_r1" value\="1.1: \[Cuenta pertenece al Rol exclusivo PROVEEDOR con vínculo válido\] asigna credencial temporal y marca cambioCredencialPendiente=true (sin habilitar cuenta deshabilitada ni crear segunda cuenta)" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="984" y\="1140" as\="sourcePoint" /\>

            \<mxPoint x\="131" y\="1140" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="d2\_54\_r2" value\="1.2: \[Cuenta no pertenece al Rol exclusivo PROVEEDOR o vínculo inconsistente\] rechaza la operación" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="984" y\="1200" as\="sourcePoint" /\>

            \<mxPoint x\="131" y\="1200" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<\!-- ESCENARIO UC-55 (+ INCLUDE UC-56) CORREGIDO CON RD-RP009-001 \--\>

        \<mxCell id\="d2\_sd55" value\="sd Escenario Independiente — UC-55: Cambiar Estado de Usuario (con «include» UC-56) \[RD-RP009-001\]" style\="shape=umlFrame;whiteSpace=wrap;html=1;width=640;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="50" y\="1260" width\="1080" height\="470" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="d2\_55\_ref56" value\="ref «include» UC-56 Buscar Usuario (aprobada 25/10 — selecciona la cuenta objetivo y expone estado, Roles y Pedidos PENDIENTE asignados)" style\="shape=umlFrame;whiteSpace=wrap;html=1;width=280;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="90" y\="1295" width\="760" height\="50" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="d2\_55\_m1" value\="1: resultado \= cambiarEstadoUsuario(idUsuario:Long, nuevoEstado:String)" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="131" y\="1380" as\="sourcePoint" /\>

            \<mxPoint x\="984" y\="1380" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="d2\_alt55" value\="alt Evaluación de invariantes al habilitar/deshabilitar Usuario \[UC-55 — RD-RP009-001\]" style\="shape=umlFrame;whiteSpace=wrap;html=1;width=540;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="75" y\="1405" width\="1030" height\="305" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="d2\_55\_g1" value\="\[Conserva \&gt;\= 1 ADMINISTRADOR habilitado, unicidad de cuenta PROVEEDOR habilitada y (si se deshabilita Repartidor) 0 Pedidos PENDIENTE asignados\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="145" y\="1430" width\="840" height\="20" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="d2\_55\_r1" value\="1.1: actualiza estado de la cuenta (conservando Roles e historial) y, si pasa a DESHABILITADO, registra fechaHoraDeshabilitacion y revoca sus sesiones activas" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="984" y\="1480" as\="sourcePoint" /\>

            \<mxPoint x\="131" y\="1480" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="d2\_55\_div1" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="75" y\="1515" as\="sourcePoint" /\>

            \<mxPoint x\="1105" y\="1515" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="d2\_55\_g2" value\="\[RD-RP009-001: Intento de deshabilitar un Repartidor que aún posee Pedidos PENDIENTE con asignación vigente\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontStyle=1" vertex\="1" parent\="1"\>

          \<mxGeometry x\="145" y\="1522" width\="760" height\="20" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="d2\_55\_r2" value\="1.2: BLOQUEA la deshabilitación, conserva la cuenta HABILITADO e informa los Pedidos PENDIENTE que deben reasignarse previamente mediante UC-43" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="984" y\="1575" as\="sourcePoint" /\>

            \<mxPoint x\="131" y\="1575" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="d2\_55\_div2" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="75" y\="1610" as\="sourcePoint" /\>

            \<mxPoint x\="1105" y\="1610" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="d2\_55\_g3" value\="\[A3/A4: Intento de deshabilitar al último Administrador habilitado, habilitar 2.ª cuenta de un mismo Proveedor o estado ya coincidente\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="145" y\="1618" width\="800" height\="20" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="d2\_55\_r3" value\="1.3: rechaza la transición y conserva intacto el estado anterior de la cuenta y sus sesiones" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="984" y\="1675" as\="sourcePoint" /\>

            \<mxPoint x\="131" y\="1675" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

\</mxfile\>

### **Archivo 3:** docs/08-diagramas/revision/DS\_REV02\_SEGURIDAD\_UC01\_17\_18\_53\_54\_55\_56.drawio.xml

Este archivo XML de **7 páginas** para **Draw.io** contiene los Diagramas de Secuencia de Diseño (DS de caja blanca) corregidos para UC-01, UC-17, UC-18, UC-53, UC-54, UC-55 y UC-56, con firmas 100% homologadas, operandos alt mutuamente excluyentes, revalidación atómica y aplicación estricta de RD-RP009-001 (H-20), RD-RP010-001 (H-07) y el diccionario MR-3:

XML  
\<mxfile host\="app.diagrams.net" modified\="2026-10-28T11:15:00.000Z" agent\="Gemini-REV02" version\="24.7.17" type\="device"\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 1: DS UC-01 INICIAR SESIÓN (CORREGIDO RD-RP010-001)                \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id\="ds-rev02-uc01" name\="DS UC-01 Iniciar Sesión (REV02)"\>

    \<mxGraphModel dx\="1550" dy\="900" grid\="1" gridSize\="10" guides\="1" tooltips\="1" connect\="1" arrows\="1" fold\="1" page\="1" pageScale\="1" pageWidth\="1500" pageHeight\="1150" math\="0" shadow\="0"\>

      \<root\>

        \<mxCell id\="0" /\>

        \<mxCell id\="1" parent\="0" /\>

        \<mxCell id\="u01\_title" value\="Diagrama de Secuencia de Diseño (DS — REV02) — UC-01: Iniciar sesión \[RD-RP010-001\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex\="1" parent\="1"\>

          \<mxGeometry x\="50" y\="15" width\="950" height\="30" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u01\_actor" value\="Usuario&\#xa;(Interno o PROVEEDOR)" style\="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="90" y\="60" width\="30" height\="60" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u01\_actor\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="99" y\="155" width\="12" height\="920" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u01\_ctrl\_box" value\=":ControladorSeguridad" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="380" y\="60" width\="170" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u01\_ctrl\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="465" y\="1100" as\="sourcePoint" /\>

            \<mxPoint x\="465" y\="105" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u01\_ctrl\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="459" y\="155" width\="12" height\="920" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u01\_cat\_box" value\=":CatalogoUsuarios" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="690" y\="60" width\="160" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u01\_cat\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="770" y\="1100" as\="sourcePoint" /\>

            \<mxPoint x\="770" y\="105" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u01\_cat\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="764" y\="200" width\="12" height\="75" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u01\_usr\_box" value\="unUsuario : Usuario" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="980" y\="60" width\="160" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u01\_usr\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="1060" y\="1100" as\="sourcePoint" /\>

            \<mxPoint x\="1060" y\="105" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u01\_usr\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="1054" y\="310" width\="12" height\="120" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u01\_ses\_box" value\="unaSesion : SesionUsuario" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="1250" y\="510" width\="180" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u01\_ses\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="1340" y\="1100" as\="sourcePoint" /\>

            \<mxPoint x\="1340" y\="555" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u01\_ses\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="1334" y\="555" width\="12" height\="80" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u01\_m1" value\="1: sesion \= iniciarSesion(nombreUsuario:String, credencial:String)" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="111" y\="185" as\="sourcePoint" /\>

            \<mxPoint x\="459" y\="185" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u01\_m2" value\="2: unUsuario \= buscarPorNombreUsuario(nombreUsuario:String) \[Visibilidad por Atributo\]" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="471" y\="215" as\="sourcePoint" /\>

            \<mxPoint x\="764" y\="215" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u01\_r2" value\="2.1: unUsuario : Usuario \[0..1\]" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="764" y\="255" as\="sourcePoint" /\>

            \<mxPoint x\="471" y\="255" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u01\_m3" value\="3: validacion \= validarAccesoCuenta(credencial:String) \[Visibilidad por Variable Local\]" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="471" y\="335" as\="sourcePoint" /\>

            \<mxPoint x\="1054" y\="335" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u01\_r3" value\="3.1: (credOk:Boolean, estado:String, cambioCredencialPendiente:Boolean, rolesVigentes:Set\&lt;UsuarioRol\&gt;)" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="1054" y\="400" as\="sourcePoint" /\>

            \<mxPoint x\="471" y\="400" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u01\_alt" value\="alt Evaluación de credenciales, estado HABILITADO, Roles y cambioCredencialPendiente \[UC-01 — RD-RP010-001\]" style\="shape=umlFrame;whiteSpace=wrap;html=1;width=660;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="50" y\="455" width\="1410" height\="585" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u01\_g1" value\="\[unUsuario \!= null, credOk \== true, estado \== HABILITADO y rolesVigentes.size \&gt;\= 1\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="130" y\="480" width\="580" height\="20" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u01\_m4\_new" value\="4: «create» new(unUsuario:Usuario, tokenProtegido:Byte\[\], fechaHoraInicio, fechaHoraExpiracion) \[Creación Local\]" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="471" y\="532" as\="sourcePoint" /\>

            \<mxPoint x\="1250" y\="532" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u01\_r4\_new" value\="4.1: unaSesion : SesionUsuario (si cambioCredencialPendiente \== true para CUALQUIER Usuario, restringe sesión a UC-53 — RD-RP010-001)" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="1334" y\="605" as\="sourcePoint" /\>

            \<mxPoint x\="471" y\="605" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u01\_r1\_ok" value\="4.2: devuelve sesión autenticada (habilitando permisos de Roles vigentes o exigiendo UC-53 si cambioCredencialPendiente \== true)" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="459" y\="675" as\="sourcePoint" /\>

            \<mxPoint x\="111" y\="675" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u01\_div1" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="50" y\="725" as\="sourcePoint" /\>

            \<mxPoint x\="1460" y\="725" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u01\_g2" value\="\[A1/A2: unUsuario \== null, credOk \== false o estado \!= HABILITADO\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="130" y\="735" width\="520" height\="20" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u01\_r1\_err1" value\="4.3: rechaza autenticación y no crea SesionUsuario" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="459" y\="810" as\="sourcePoint" /\>

            \<mxPoint x\="111" y\="810" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u01\_div2" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="50" y\="865" as\="sourcePoint" /\>

            \<mxPoint x\="1460" y\="865" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u01\_g3" value\="\[A3: Cuenta HABILITADO pero rolesVigentes.isEmpty() por inconsistencia de datos\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="130" y\="875" width\="580" height\="20" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u01\_r1\_err2" value\="4.4: impide establecer sesión y exige regularización administrativa de Roles (UC-18)" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="459" y\="965" as\="sourcePoint" /\>

            \<mxPoint x\="111" y\="965" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 2: DS UC-17 CREAR USUARIO («include» UC-18)                        \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id\="ds-rev02-uc17" name\="DS UC-17 Crear Usuario (REV02)"\>

    \<mxGraphModel dx\="1650" dy\="900" grid\="1" gridSize\="10" guides\="1" tooltips\="1" connect\="1" arrows\="1" fold\="1" page\="1" pageScale\="1" pageWidth\="1600" pageHeight\="1200" math\="0" shadow\="0"\>

      \<root\>

        \<mxCell id\="0" /\>

        \<mxCell id\="1" parent\="0" /\>

        \<mxCell id\="u17\_title" value\="Diagrama de Secuencia de Diseño (DS — REV02) — UC-17: Crear Usuario (con «include» UC-18)" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex\="1" parent\="1"\>

          \<mxGeometry x\="50" y\="15" width\="1050" height\="30" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u17\_actor" value\="Administrador" style\="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="85" y\="60" width\="30" height\="60" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u17\_actor\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="94" y\="155" width\="12" height\="960" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u17\_ctrl\_box" value\=":ControladorSeguridad" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="350" y\="60" width\="170" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u17\_ctrl\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="435" y\="1140" as\="sourcePoint" /\>

            \<mxPoint x\="435" y\="105" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u17\_ctrl\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="429" y\="155" width\="12" height\="960" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u17\_cat\_box" value\=":CatalogoUsuarios" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="680" y\="60" width\="160" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u17\_cat\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="760" y\="1140" as\="sourcePoint" /\>

            \<mxPoint x\="760" y\="105" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u17\_cat\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="754" y\="200" width\="12" height\="680" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u17\_usr\_box" value\="nuevoUsuario : Usuario" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="1020" y\="410" width\="165" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u17\_usr\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="1102" y\="1140" as\="sourcePoint" /\>

            \<mxPoint x\="1102" y\="455" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u17\_usr\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="1096" y\="455" width\="12" height\="320" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u17\_rol\_box" value\="asigRol : UsuarioRol&\#xa;/ evRol : EventoAsignacionRol&\#xa;/ vincProv : UsuarioProveedor" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="1310" y\="560" width\="210" height\="55" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u17\_rol\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="1415" y\="1140" as\="sourcePoint" /\>

            \<mxPoint x\="1415" y\="615" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u17\_rol\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="1409" y\="615" width\="12" height\="110" as\="geometry" /\>

        \</mxCell\>

        \<\!-- FIRMA HOMOLOGADA \--\>

        \<mxCell id\="u17\_m1" value\="1: idUsuario \= crearUsuario(nombreUsuario:String, credencialInicial:String, codigosRol:Set\&lt;String\&gt;, idProveedor:Long\[0..1\])" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="106" y\="185" as\="sourcePoint" /\>

            \<mxPoint x\="429" y\="185" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u17\_m2" value\="2: disp \= verificarDisponibilidadNombreYProveedor(nombreUsuario, codigosRol, idProveedor) \[Visibilidad por Atributo\]" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="441" y\="230" as\="sourcePoint" /\>

            \<mxPoint x\="754" y\="230" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u17\_r2" value\="2.1: (nombreUnico:Boolean, rolesValidos:Boolean, proveedorElegibleSinOtraCuentaHabilitada:Boolean)" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="754" y\="285" as\="sourcePoint" /\>

            \<mxPoint x\="441" y\="285" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u17\_alt" value\="alt Validación atómica de unicidad, \&gt;\= 1 Rol y exclusividad de Rol PROVEEDOR \[UC-17 «include» UC-18\]" style\="shape=umlFrame;whiteSpace=wrap;html=1;width=630;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="45" y\="340" width\="1515" height\="720" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u17\_g1" value\="\[nombreUnico \== true, codigosRol.size \&gt;\= 1 y (si incluye PROVEEDOR: rol exclusivo \+ Proveedor ACTIVO sin otra cuenta habilitada)\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="120" y\="365" width\="820" height\="20" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u17\_m3\_new" value\="3: «create» new(nombreUsuario, credencialProtegida, estado=HABILITADO, cambioCredencialPendiente=true, fechaHoraAlta)" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="441" y\="432" as\="sourcePoint" /\>

            \<mxPoint x\="1020" y\="432" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u17\_frame18" value\="«include» UC-18 Gestionar Asignaciones de Roles (ejecutado en la misma transacción)" style\="shape=umlFrame;whiteSpace=wrap;html=1;width=530;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="380" y\="500" width\="1160" height\="250" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u17\_m4" value\="4: asignarRolesIniciales(codigosRol:Set\&lt;String\&gt;, idProveedor:Long\[0..1\], idAdmin:Long) \[Visibilidad por Variable Local\]" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="441" y\="545" as\="sourcePoint" /\>

            \<mxPoint x\="1096" y\="545" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u17\_m5\_new" value\="5: «create» new(nuevoUsuario, codigoRol, fechaHoraAsignacion) \+ EventoAsignacionRol(ALTA) \+ UsuarioProveedor\[0..1\]" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="1108" y\="590" as\="sourcePoint" /\>

            \<mxPoint x\="1310" y\="590" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u17\_r5" value\="5.1: asociaciones UsuarioRol, EventoAsignacionRol y UsuarioProveedor\[0..1\] creadas" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="1409" y\="690" as\="sourcePoint" /\>

            \<mxPoint x\="1108" y\="690" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u17\_m6" value\="6: guardarUsuarioTransaccional(nuevoUsuario:Usuario)" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="441" y\="810" as\="sourcePoint" /\>

            \<mxPoint x\="754" y\="810" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u17\_r1\_ok" value\="6.1: confirma creación íntegra de Usuario (HABILITADO, cambioCredencialPendiente=true) y Roles iniciales" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="429" y\="885" as\="sourcePoint" /\>

            \<mxPoint x\="106" y\="885" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u17\_div" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="45" y\="935" as\="sourcePoint" /\>

            \<mxPoint x\="1560" y\="935" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u17\_g2" value\="\[A1/A2: nombreUsuario duplicado, codigosRol vacío o violación de exclusividad de Rol PROVEEDOR\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="120" y\="945" width\="700" height\="20" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u17\_r1\_err" value\="6.2: rechaza el alta sin persistir Usuario parcial ni asignaciones de Rol" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="429" y\="1025" as\="sourcePoint" /\>

            \<mxPoint x\="106" y\="1025" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 3: DS UC-18 GESTIONAR ASIGNACIONES DE ROLES                        \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id\="ds-rev02-uc18" name\="DS UC-18 Gestionar Roles (REV02)"\>

    \<mxGraphModel dx\="1550" dy\="900" grid\="1" gridSize\="10" guides\="1" tooltips\="1" connect\="1" arrows\="1" fold\="1" page\="1" pageScale\="1" pageWidth\="1500" pageHeight\="1050" math\="0" shadow\="0"\>

      \<root\>

        \<mxCell id\="0" /\>

        \<mxCell id\="1" parent\="0" /\>

        \<mxCell id\="u18\_title" value\="Diagrama de Secuencia de Diseño (DS — REV02) — UC-18: Gestionar Asignaciones de Roles" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex\="1" parent\="1"\>

          \<mxGeometry x\="50" y\="15" width\="950" height\="30" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u18\_actor" value\="Administrador" style\="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="90" y\="60" width\="30" height\="60" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u18\_actor\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="99" y\="155" width\="12" height\="820" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u18\_ctrl\_box" value\=":ControladorSeguridad" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="360" y\="60" width\="170" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u18\_ctrl\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="445" y\="1000" as\="sourcePoint" /\>

            \<mxPoint x\="445" y\="105" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u18\_ctrl\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="439" y\="155" width\="12" height\="820" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u18\_cat\_box" value\=":CatalogoUsuarios" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="690" y\="60" width\="160" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u18\_cat\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="770" y\="1000" as\="sourcePoint" /\>

            \<mxPoint x\="770" y\="105" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u18\_cat\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="764" y\="200" width\="12" height\="120" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u18\_usr\_box" value\="unUsuario : Usuario" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="990" y\="60" width\="160" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u18\_usr\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="1070" y\="1000" as\="sourcePoint" /\>

            \<mxPoint x\="1070" y\="105" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u18\_usr\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="1064" y\="420" width\="12" height\="260" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u18\_ev\_box" value\="evRol : EventoAsignacionRol&\#xa;/ ses : SesionUsuario" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="1250" y\="480" width\="190" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u18\_ev\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="1345" y\="1000" as\="sourcePoint" /\>

            \<mxPoint x\="1345" y\="525" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u18\_ev\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="1339" y\="525" width\="12" height\="100" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u18\_m1" value\="1: rolesVigentes \= gestionarAsignacionesRoles(idUsuario:Long, codigosRolAgregar:Set\&lt;String\&gt;, codigosRolQuitar:Set\&lt;String\&gt;)" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="111" y\="185" as\="sourcePoint" /\>

            \<mxPoint x\="439" y\="185" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u18\_m2" value\="2: (unUsuario, invOk) \= obtenerYRevalidarInvariantesRol(idUsuario, codigosRolAgregar, codigosRolQuitar) \[Atributo — Pendiente F07\]" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="451" y\="230" as\="sourcePoint" /\>

            \<mxPoint x\="764" y\="230" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u18\_r2" value\="2.1: (unUsuario:Usuario, conservaAlMenosUnRol:Boolean, conservaUltimoAdminHabilitado:Boolean, exclusividadProveedorOk:Boolean)" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="764" y\="285" as\="sourcePoint" /\>

            \<mxPoint x\="451" y\="285" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u18\_alt" value\="alt Revalidación atómica de al menos 1 Rol, último Administrador habilitado y exclusividad PROVEEDOR \[UC-18\]" style\="shape=umlFrame;whiteSpace=wrap;html=1;width=680;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="50" y\="340" width\="1410" height\="580" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u18\_g1" value\="\[conservaAlMenosUnRol \== true, conservaUltimoAdminHabilitado \== true y exclusividadProveedorOk \== true\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="125" y\="365" width\="700" height\="20" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u18\_m3" value\="3: actualizarRolesYEventos(codigosRolAgregar, codigosRolQuitar, idAdmin) \[Visibilidad por Variable Local\]" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="451" y\="445" as\="sourcePoint" /\>

            \<mxPoint x\="1064" y\="445" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u18\_m4\_new" value\="4: «create» new EventoAsignacionRol(ALTA/BAJA) y revocar SesionUsuario si se quitan permisos activos" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="1076" y\="502" as\="sourcePoint" /\>

            \<mxPoint x\="1250" y\="502" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u18\_r3" value\="3.1: colección UsuarioRol actualizada y eventos registrados" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="1064" y\="645" as\="sourcePoint" /\>

            \<mxPoint x\="451" y\="645" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u18\_r1\_ok" value\="3.2: presenta la nueva lista de Roles vigentes del Usuario" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="439" y\="705" as\="sourcePoint" /\>

            \<mxPoint x\="111" y\="705" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u18\_div" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="50" y\="760" as\="sourcePoint" /\>

            \<mxPoint x\="1460" y\="760" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u18\_g2" value\="\[A2: Quitar último Rol del Usuario, pérdida del último Administrador habilitado o mezcla de Rol PROVEEDOR con roles internos\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="125" y\="770" width\="780" height\="20" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u18\_r1\_err" value\="3.3: rechaza la operación y conserva intactas las asignaciones de Rol previas" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="439" y\="865" as\="sourcePoint" /\>

            \<mxPoint x\="111" y\="865" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 4: DS UC-53 CAMBIAR CONTRASEÑA (CORREGIDO RD-RP010-001)            \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id\="ds-rev02-uc53" name\="DS UC-53 Cambiar Contraseña (REV02)"\>

    \<mxGraphModel dx\="1450" dy\="850" grid\="1" gridSize\="10" guides\="1" tooltips\="1" connect\="1" arrows\="1" fold\="1" page\="1" pageScale\="1" pageWidth\="1400" pageHeight\="950" math\="0" shadow\="0"\>

      \<root\>

        \<mxCell id\="0" /\>

        \<mxCell id\="1" parent\="0" /\>

        \<mxCell id\="u53\_title" value\="Diagrama de Secuencia de Diseño (DS — REV02) — UC-53: Cambiar Contraseña \[RD-RP010-001\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex\="1" parent\="1"\>

          \<mxGeometry x\="50" y\="15" width\="950" height\="30" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u53\_actor" value\="Usuario Autenticado&\#xa;(Interno o PROVEEDOR)" style\="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="90" y\="60" width\="30" height\="60" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u53\_actor\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="99" y\="155" width\="12" height\="720" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u53\_ctrl\_box" value\=":ControladorSeguridad" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="380" y\="60" width\="170" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u53\_ctrl\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="465" y\="900" as\="sourcePoint" /\>

            \<mxPoint x\="465" y\="105" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u53\_ctrl\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="459" y\="155" width\="12" height\="720" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u53\_ses\_box" value\="unaSesion : SesionUsuario" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="710" y\="60" width\="175" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u53\_ses\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="797" y\="900" as\="sourcePoint" /\>

            \<mxPoint x\="797" y\="105" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u53\_ses\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="791" y\="200" width\="12" height\="80" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u53\_usr\_box" value\="unUsuario : Usuario" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="1030" y\="60" width\="160" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u53\_usr\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="1110" y\="900" as\="sourcePoint" /\>

            \<mxPoint x\="1110" y\="105" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u53\_usr\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="1104" y\="390" width\="12" height\="170" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u53\_m1" value\="1: resultado \= cambiarContrasena(credencialActual:String, credencialNueva:String, confirmacion:String)" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="111" y\="185" as\="sourcePoint" /\>

            \<mxPoint x\="459" y\="185" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u53\_m2" value\="2: unUsuario \= obtenerUsuarioDeSesionActiva() \[Visibilidad por Parámetro/Sesión\]" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="471" y\="220" as\="sourcePoint" /\>

            \<mxPoint x\="791" y\="220" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u53\_r2" value\="2.1: unUsuario : Usuario (estado \== HABILITADO)" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="791" y\="265" as\="sourcePoint" /\>

            \<mxPoint x\="471" y\="265" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u53\_alt" value\="alt Validación de sesión activa, credencialActual y coherencia de credencialNueva \[UC-53 — RD-RP010-001\]" style\="shape=umlFrame;whiteSpace=wrap;html=1;width=620;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="50" y\="315" width\="1260" height\="510" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u53\_g1" value\="\[Sesión activa, estado \== HABILITADO, credencialActual válida y credencialNueva \== confirmacion\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="125" y\="340" width\="620" height\="20" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u53\_m3" value\="3: actualizarCredencialProtegida(credencialActual, nuevoHash) \[Visibilidad por Variable Local\]" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="471" y\="415" as\="sourcePoint" /\>

            \<mxPoint x\="1104" y\="415" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u53\_r3" value\="3.1: credencialProtegida reemplazada y cambioCredencialPendiente \= false (para cualquier Usuario — RD-RP010-001)" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="1104" y\="490" as\="sourcePoint" /\>

            \<mxPoint x\="471" y\="490" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u53\_r1\_ok" value\="3.2: confirma cambio de contraseña y habilita en la sesión los permisos propios de sus Roles vigentes" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="459" y\="575" as\="sourcePoint" /\>

            \<mxPoint x\="111" y\="575" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u53\_div" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="50" y\="640" as\="sourcePoint" /\>

            \<mxPoint x\="1310" y\="640" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u53\_g2" value\="\[A1/A2: Sesión inválida, cuenta deshabilitada, credencialActual incorrecta o nueva credencial incoherente\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="125" y\="650" width\="660" height\="20" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u53\_r1\_err" value\="3.3: rechaza el cambio y conserva credencialProtegida y cambioCredencialPendiente anteriores" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="459" y\="745" as\="sourcePoint" /\>

            \<mxPoint x\="111" y\="745" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 5: DS UC-54 RESTABLECER ACCESO DE USUARIO («include» UC-56)        \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id\="ds-rev02-uc54" name\="DS UC-54 Restablecer Acceso (REV02)"\>

    \<mxGraphModel dx\="1550" dy\="900" grid\="1" gridSize\="10" guides\="1" tooltips\="1" connect\="1" arrows\="1" fold\="1" page\="1" pageScale\="1" pageWidth\="1500" pageHeight\="1050" math\="0" shadow\="0"\>

      \<root\>

        \<mxCell id\="0" /\>

        \<mxCell id\="1" parent\="0" /\>

        \<mxCell id\="u54\_title" value\="Diagrama de Secuencia de Diseño (DS — REV02) — UC-54: Restablecer Acceso de Usuario (con «include» UC-56)" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex\="1" parent\="1"\>

          \<mxGeometry x\="50" y\="15" width\="1100" height\="30" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u54\_actor" value\="Administrador" style\="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="90" y\="60" width\="30" height\="60" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u54\_actor\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="99" y\="155" width\="12" height\="820" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u54\_ctrl\_box" value\=":ControladorSeguridad" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="360" y\="60" width\="170" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u54\_ctrl\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="445" y\="1000" as\="sourcePoint" /\>

            \<mxPoint x\="445" y\="105" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u54\_ctrl\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="439" y\="155" width\="12" height\="820" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u54\_cat\_box" value\=":CatalogoUsuarios" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="700" y\="60" width\="160" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u54\_cat\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="780" y\="1000" as\="sourcePoint" /\>

            \<mxPoint x\="780" y\="105" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u54\_cat\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="774" y\="300" width\="12" height\="90" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u54\_usr\_box" value\="cuentaProv : Usuario" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="1040" y\="60" width\="160" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u54\_usr\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="1120" y\="1000" as\="sourcePoint" /\>

            \<mxPoint x\="1120" y\="105" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u54\_usr\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="1114" y\="510" width\="12" height\="170" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u54\_ref56" value\="ref «include» UC-56 Buscar Usuario (aprobada 25/10 — localiza y selecciona cuenta objetivo)" style\="shape=umlFrame;whiteSpace=wrap;html=1;width=280;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="65" y\="170" width\="760" height\="60" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u54\_m1" value\="1: ok \= restablecerAccesoUsuario(idUsuario:Long, credencialTemporal:String)" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="111" y\="275" as\="sourcePoint" /\>

            \<mxPoint x\="439" y\="275" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u54\_m2" value\="2: (cuentaProv, vincValido) \= obtenerYRevalidarCuentaProveedor(idUsuario:Long) \[Visibilidad por Atributo\]" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="451" y\="320" as\="sourcePoint" /\>

            \<mxPoint x\="774" y\="320" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u54\_r2" value\="2.1: (cuentaProv:Usuario, esRolProveedorExclusivo:Boolean, idProveedorVinculado:Long\[0..1\])" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="774" y\="370" as\="sourcePoint" /\>

            \<mxPoint x\="451" y\="370" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u54\_alt" value\="alt Validación de alcance exclusivo Rol PROVEEDOR y vínculo UsuarioProveedor \[UC-54\]" style\="shape=umlFrame;whiteSpace=wrap;html=1;width=560;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="50" y\="420" width\="1360" height\="495" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u54\_g1" value\="\[esRolProveedorExclusivo \== true y idProveedorVinculado \!= null\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="125" y\="445" width\="520" height\="20" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u54\_m3" value\="3: asignarCredencialTemporal(hashTemporal:String) \[Visibilidad por Variable Local\]" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="451" y\="535" as\="sourcePoint" /\>

            \<mxPoint x\="1114" y\="535" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u54\_r3" value\="3.1: credencialProtegida reemplazada y cambioCredencialPendiente \= true (conserva estado e identidad sin crear 2.ª cuenta)" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="1114" y\="625" as\="sourcePoint" /\>

            \<mxPoint x\="451" y\="625" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u54\_r1\_ok" value\="3.2: informa restablecimiento exitoso y obligatoriedad de ejecutar UC-53 antes de responder cotizaciones" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="439" y\="700" as\="sourcePoint" /\>

            \<mxPoint x\="111" y\="700" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u54\_div" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="50" y\="755" as\="sourcePoint" /\>

            \<mxPoint x\="1410" y\="755" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u54\_g2" value\="\[A1/A2: La cuenta no pertenece al Rol exclusivo PROVEEDOR o el vínculo UsuarioProveedor es inconsistente\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="125" y\="765" width\="680" height\="20" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u54\_r1\_err" value\="3.3: rechaza la operación y conserva la credencial y condición anteriores" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="439" y\="860" as\="sourcePoint" /\>

            \<mxPoint x\="111" y\="860" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 6: DS UC-55 CAMBIAR ESTADO DE USUARIO (CORREGIDO RD-RP009-001)     \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id\="ds-rev02-uc55" name\="DS UC-55 Cambiar Estado Usuario (REV02)"\>

    \<mxGraphModel dx\="1650" dy\="950" grid\="1" gridSize\="10" guides\="1" tooltips\="1" connect\="1" arrows\="1" fold\="1" page\="1" pageScale\="1" pageWidth\="1600" pageHeight\="1250" math\="0" shadow\="0"\>

      \<root\>

        \<mxCell id\="0" /\>

        \<mxCell id\="1" parent\="0" /\>

        \<mxCell id\="u55\_title" value\="Diagrama de Secuencia de Diseño (DS — REV02) — UC-55: Cambiar Estado de Usuario (con «include» UC-56) \[RD-RP009-001\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex\="1" parent\="1"\>

          \<mxGeometry x\="50" y\="15" width\="1220" height\="30" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u55\_actor" value\="Administrador" style\="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="85" y\="60" width\="30" height\="60" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u55\_actor\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="94" y\="155" width\="12" height\="1020" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u55\_ctrl\_box" value\=":ControladorSeguridad" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="350" y\="60" width\="170" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u55\_ctrl\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="435" y\="1200" as\="sourcePoint" /\>

            \<mxPoint x\="435" y\="105" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u55\_ctrl\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="429" y\="155" width\="12" height\="1020" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u55\_cat\_box" value\=":CatalogoUsuarios" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="680" y\="60" width\="160" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u55\_cat\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="760" y\="1200" as\="sourcePoint" /\>

            \<mxPoint x\="760" y\="105" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u55\_cat\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="754" y\="290" width\="12" height\="110" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u55\_usr\_box" value\="unUsuario : Usuario" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="990" y\="60" width\="160" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u55\_usr\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="1070" y\="1200" as\="sourcePoint" /\>

            \<mxPoint x\="1070" y\="105" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u55\_usr\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="1064" y\="510" width\="12" height\="270" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u55\_ses\_box" value\="ses : SesionUsuario&\#xa;\[0..\*\]" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="1280" y\="60" width\="175" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u55\_ses\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="1367" y\="1200" as\="sourcePoint" /\>

            \<mxPoint x\="1367" y\="105" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u55\_ses\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="1361" y\="620" width\="12" height\="90" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u55\_ref56" value\="ref «include» UC-56 Buscar Usuario (aprobada 25/10 — selecciona Usuario y presenta estado, Roles y Pedidos PENDIENTE asignados)" style\="shape=umlFrame;whiteSpace=wrap;html=1;width=280;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="65" y\="165" width\="760" height\="60" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u55\_m1" value\="1: resultado \= cambiarEstadoUsuario(idUsuario:Long, nuevoEstado:String)" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="106" y\="265" as\="sourcePoint" /\>

            \<mxPoint x\="429" y\="265" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u55\_m2" value\="2: eval \= revalidarCambioEstadoTransaccional(idUsuario, nuevoEstado) \[Atributo — RD-RP009-001 / F07\]" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="441" y\="315" as\="sourcePoint" /\>

            \<mxPoint x\="754" y\="315" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u55\_r2" value\="2.1: (unUsuario, conservaUltimoAdmin:Boolean, unicidadCuentaProvOk:Boolean, pedidosPendientesRepartidor:List\&lt;Long\&gt;)" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="754" y\="375" as\="sourcePoint" /\>

            \<mxPoint x\="441" y\="375" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<\!-- FRAGMENTO ALT CON 3 OPERANDOS MUTUAMENTE EXCLUYENTES \--\>

        \<mxCell id\="u55\_alt" value\="alt Evaluación de invariantes al cambiar estado de Usuario \[UC-55 — RD-RP009-001\]" style\="shape=umlFrame;whiteSpace=wrap;html=1;width=550;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="45" y\="430" width\="1495" height\="710" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u55\_g1" value\="\[conservaUltimoAdmin \== true, unicidadCuentaProvOk \== true, unUsuario.estado \!= nuevoEstado y (nuevoEstado \== HABILITADO \|\| pedidosPendientesRepartidor.isEmpty())\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="120" y\="455" width\="980" height\="20" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u55\_m3" value\="3: aplicarEstadoCuenta(nuevoEstado:String, fechaHoraCambio:Timestamp) \[Visibilidad por Variable Local\]" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="441" y\="535" as\="sourcePoint" /\>

            \<mxPoint x\="1064" y\="535" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u55\_opt\_rev" value\="opt \[nuevoEstado \== DESHABILITADO — Registra fechaHoraDeshabilitacion y revoca sesiones activas\]" style\="shape=umlFrame;whiteSpace=wrap;html=1;width=630;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="960" y\="575" width\="530" height\="155" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u55\_m4" value\="4: revocarSesionActiva(fechaHoraRevocacion=fechaHoraCambio) \[Visibilidad por Atributo\]" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="1076" y\="640" as\="sourcePoint" /\>

            \<mxPoint x\="1361" y\="640" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u55\_r4" value\="4.1: SesionUsuario.fechaHoraRevocacion actualizada" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="1361" y\="695" as\="sourcePoint" /\>

            \<mxPoint x\="1076" y\="695" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u55\_r3" value\="3.1: Usuario.estado actualizado (conservando Usuario y UsuarioRol)" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="1064" y\="760" as\="sourcePoint" /\>

            \<mxPoint x\="441" y\="760" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u55\_r1\_ok" value\="3.2: confirma nuevo estado de la cuenta" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="429" y\="810" as\="sourcePoint" /\>

            \<mxPoint x\="106" y\="810" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<\!-- OPERANDO 2: BLOQUEO RD-RP009-001 \--\>

        \<mxCell id\="u55\_div1" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="45" y\="850" as\="sourcePoint" /\>

            \<mxPoint x\="1540" y\="850" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u55\_g2" value\="\[RD-RP009-001: nuevoEstado \== DESHABILITADO y pedidosPendientesRepartidor.notEmpty()\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontStyle=1" vertex\="1" parent\="1"\>

          \<mxGeometry x\="120" y\="860" width\="680" height\="20" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u55\_r1\_rep" value\="3.3: BLOQUEA la deshabilitación, conserva estado HABILITADO e informa los Pedidos PENDIENTE que deben reasignarse antes en UC-43" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="429" y\="935" as\="sourcePoint" /\>

            \<mxPoint x\="106" y\="935" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<\!-- OPERANDO 3: OTRAS EXCEPCIONES \--\>

        \<mxCell id\="u55\_div2" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="45" y\="985" as\="sourcePoint" /\>

            \<mxPoint x\="1540" y\="985" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u55\_g3" value\="\[A3/A4: Último Administrador habilitado, segunda cuenta habilitada para el mismo Proveedor o estado ya coincidente\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="120" y\="995" width\="760" height\="20" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u55\_r1\_err" value\="3.4: rechaza la transición y conserva el estado anterior de la cuenta y sus sesiones" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="429" y\="1080" as\="sourcePoint" /\>

            \<mxPoint x\="106" y\="1080" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 7: DS UC-56 BUSCAR USUARIO                                         \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id\="ds-rev02-uc56" name\="DS UC-56 Buscar Usuario (REV02)"\>

    \<mxGraphModel dx\="1450" dy\="850" grid\="1" gridSize\="10" guides\="1" tooltips\="1" connect\="1" arrows\="1" fold\="1" page\="1" pageScale\="1" pageWidth\="1400" pageHeight\="900" math\="0" shadow\="0"\>

      \<root\>

        \<mxCell id\="0" /\>

        \<mxCell id\="1" parent\="0" /\>

        \<mxCell id\="u56\_title" value\="Diagrama de Secuencia de Diseño (DS — REV02) — UC-56: Buscar Usuario" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex\="1" parent\="1"\>

          \<mxGeometry x\="50" y\="15" width\="900" height\="30" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u56\_actor" value\="Administrador" style\="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="90" y\="60" width\="30" height\="60" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u56\_actor\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="99" y\="155" width\="12" height\="680" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u56\_ctrl\_box" value\=":ControladorSeguridad" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="400" y\="60" width\="170" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u56\_ctrl\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="485" y\="860" as\="sourcePoint" /\>

            \<mxPoint x\="485" y\="105" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u56\_ctrl\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="479" y\="155" width\="12" height\="680" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u56\_cat\_box" value\=":CatalogoUsuarios" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="760" y\="60" width\="160" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u56\_cat\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="840" y\="860" as\="sourcePoint" /\>

            \<mxPoint x\="840" y\="105" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u56\_cat\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="834" y\="210" width\="12" height\="220" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u56\_usr\_box" value\="u : Usuario" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="1090" y\="60" width\="150" height\="45" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u56\_usr\_line" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="1165" y\="860" as\="sourcePoint" /\>

            \<mxPoint x\="1165" y\="105" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u56\_usr\_bar" value\="" style\="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="1159" y\="280" width\="12" height\="90" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u56\_m1" value\="1: resultados \= buscarUsuario(nombreUsuario:String\[0..1\], estado:String\[0..1\], codigoRol:String\[0..1\])" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="111" y\="190" as\="sourcePoint" /\>

            \<mxPoint x\="479" y\="190" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u56\_m2" value\="2: lista \= consultarUsuariosSinSecretos(nombreUsuario, estado, codigoRol) \[Visibilidad por Atributo\]" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="491" y\="230" as\="sourcePoint" /\>

            \<mxPoint x\="834" y\="230" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u56\_loop" value\="loop \[para cada Usuario coincidente u — Proyección segura sin credencialProtegida ni tokenProtegido\]" style\="shape=umlFrame;whiteSpace=wrap;html=1;width=530;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="780" y\="255" width\="460" height\="130" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u56\_m3" value\="3: resumen \= obtenerResumenSeguroSinSecretos()" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="846" y\="305" as\="sourcePoint" /\>

            \<mxPoint x\="1159" y\="305" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u56\_r3" value\="3.1: (idUsuario, nombreUsuario, estado, Roles, idProveedor\[0..1\])" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="1159" y\="355" as\="sourcePoint" /\>

            \<mxPoint x\="846" y\="355" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u56\_alt" value\="alt Resultado de la búsqueda de Usuarios \[UC-56\]" style\="shape=umlFrame;whiteSpace=wrap;html=1;width=340;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="50" y\="455" width\="1240" height\="330" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u56\_g1" value\="\[Existen cuentas coincidentes\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="125" y\="480" width\="350" height\="20" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u56\_r1\_ok" value\="4.1: presenta cuentas diferenciando usuarios internos y PROVEEDOR (sin credencialProtegida ni tokenProtegido)" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="479" y\="535" as\="sourcePoint" /\>

            \<mxPoint x\="111" y\="535" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u56\_m4" value\="5: usuarioSeleccionado \= seleccionarUsuario(idUsuario:Long)" style\="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="111" y\="595" as\="sourcePoint" /\>

            \<mxPoint x\="479" y\="595" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u56\_r4" value\="5.1: devuelve referencia seleccionada al flujo invocante (UC-54 / UC-55 / UC-18) sin modificar registros" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="479" y\="645" as\="sourcePoint" /\>

            \<mxPoint x\="111" y\="645" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u56\_div" value\="" style\="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="50" y\="685" as\="sourcePoint" /\>

            \<mxPoint x\="1290" y\="685" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id\="u56\_g2" value\="\[A2: Sin coincidencias\]" style\="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex\="1" parent\="1"\>

          \<mxGeometry x\="125" y\="695" width\="300" height\="20" as\="geometry" /\>

        \</mxCell\>

        \<mxCell id\="u56\_r1\_empty" value\="4.2: informa ausencia de coincidencias sin crear ni modificar registros" style\="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge\="1" parent\="1"\>

          \<mxGeometry relative\="1" as\="geometry"\>

            \<mxPoint x\="479" y\="755" as\="sourcePoint" /\>

            \<mxPoint x\="111" y\="755" as\="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

\</mxfile\>

### **Archivo 4:** docs/08-diagramas/revision/CONTRATOS\_REV02\_SEGURIDAD\_7\_OPERACIONES.md

Este archivo resuelve el hallazgo H-11 **(Contratos compuestos)** desagrupando las operaciones del módulo en **7 Contratos individuales** (UC-01, UC-17, UC-18, UC-53, UC-54, UC-55, UC-56), con firmas 100% homologadas respecto de los DSS y DS, **9 secciones estándar** por cada contrato y aplicación estricta de RD-RP009-001 (H-20) y RD-RP010-001 (H-07):

Markdown  
\# Contratos de Operación del Sistema (DSS — REV-02) — Módulo Usuarios y Seguridad (7 Contratos Individuales)

**\*\*Proyecto:\*\*** Sistema de Gestión para Ale Milanesas (UNaM-FCEQyN)  

**\*\*Lote de revisión:\*\*** \`REV-02\` (\`UC-01\`, \`UC-17\`, \`UC-18\`, \`UC-53\`, \`UC-54\`, \`UC-55\`, \`UC-56\`)  

**\*\*Decisiones incorporadas:\*\*** \`RD-RP009-001\` (bloqueo de deshabilitación de Repartidor con Pedidos pendientes), \`RD-RP010-001\` (restricción por credencial temporal pendiente para todo Usuario) y relaciones \`include\` aprobadas el 25/10/2026 (\`UC-54→UC-56\` y \`UC-55→UC-56\`).

\---

\#\# 1\. Contrato de la Operación \`iniciarSesion\` (\`UC-01\`)

1\. **\*\*Nombre:\*\*** \`iniciarSesion(nombreUsuario: String, credencial: String)\`

2\. **\*\*Responsabilidades:\*\*** Autenticar la identidad de un Usuario registrado (personal interno o \`PROVEEDOR\`, excluyendo al \`Cliente ONLINE\`), verificar que su cuenta se encuentre en estado \`HABILITADO\` y posea al menos un \`Rol\` vigente, y establecer una sesión autenticada (restringida exclusivamente a ejecutar \`UC-53\` cuando \`Usuario.cambioCredencialPendiente \= true\`).

3\. **\*\*Tipo:\*\*** \`Sistema\`

4\. **\*\*Referencias cruzadas:\*\*** Caso de Uso \`UC-01 — Iniciar sesión\`; Caso de Uso \`UC-53 — Cambiar Contraseña\`; Decisión \`RD-RP010-001\`; Objetivo \`OBJE-03\`; Requisito \`RF-08\`.

5\. **\*\*Notas:\*\*** Conforme a \`RD-RP010-001\`, el bloqueo operativo cuando \`Usuario.cambioCredencialPendiente \= true\` rige para **\*\*todo \`Usuario\`\*\*** (tanto interno como de Rol \`PROVEEDOR\`). El \`Cliente ONLINE\` no autentica mediante esta operación sino mediante desafíos temporales en \`UC-21\`.

6\. **\*\*Excepciones:\*\***

   \* **\*\*A1 — Credenciales ausentes o inválidas:\*\*** Si \`nombreUsuario\` no existe o \`credencial\` no coincide con \`Usuario.credencialProtegida\`, rechazar la autenticación.

   \* **\*\*A2 — Cuenta no habilitada:\*\*** Si \`Usuario.estado\` es \`DESHABILITADO\`, rechazar el acceso.

   \* **\*\*A3 — Cuenta sin Roles vigentes por inconsistencia de datos:\*\*** Si la cuenta está \`HABILITADO\` pero no posee ninguna asociación en \`UsuarioRol\`, impedir el establecimiento de la sesión e informar que requiere regularización administrativa mediante \`UC-18\`.

   \* **\*\*A4 — Fallo del servicio de autenticación:\*\*** No establecer sesión.

7\. **\*\*Salida:\*\***

   \* En caso normal con \`cambioCredencialPendiente \= false\`: acceso habilitado a las funciones autorizadas por sus \`Rol\` vigentes.

   \* En caso normal con \`cambioCredencialPendiente \= true\`: aviso de sesión restringida exclusivamente a ejecutar \`UC-53 — Cambiar Contraseña\`.

   \* En caso excepcional: mensajes de rechazo provocados por las excepciones A1, A2, A3 o A4.

8\. **\*\*Precondiciones:\*\***

   \* Existen definiciones de \`Rol\` y cuentas de \`Usuario\` registradas en el sistema.

9\. **\*\*Postcondiciones:\*\***

   \* Se creó una instancia \`unaSesion\` de \`SesionUsuario\` con \`fechaHoraInicio\`, \`fechaHoraExpiracion\`, \`tokenProtegido\` y \`fechaHoraRevocacion \= NULL\`.

   \* Se asoció \`unaSesion\` con la instancia autenticada de \`Usuario\`.

   \* Si \`Usuario.cambioCredencialPendiente \= true\` (para cualquier \`Usuario\`, interno o \`PROVEEDOR\`), el alcance de \`unaSesion\` quedó restringido exclusivamente a ejecutar la operación \`cambiarContrasena\` (\`UC-53\`); en caso contrario, quedó asociado a los permisos de sus \`UsuarioRol\` vigentes.

\---

\#\# 2\. Contrato de la Operación \`crearUsuario\` (\`UC-17\` «include» \`UC-18\`)

1\. **\*\*Nombre:\*\*** \`crearUsuario(nombreUsuario: String, credencialInicial: String, codigosRol: Set\<String\>, idProveedor: Long\[0..1\])\`

2\. **\*\*Responsabilidades:\*\*** Registrar una nueva cuenta de \`Usuario\` en estado \`HABILITADO\` con credencial inicial pendiente de cambio y asignarle en la misma operación atómica al menos un \`Rol\` inicial mediante el caso incluido \`UC-18\`.

3\. **\*\*Tipo:\*\*** \`Sistema\`

4\. **\*\*Referencias cruzadas:\*\*** Caso de Uso \`UC-17 — Crear Usuario\`; incluye \`UC-18 — Gestionar Asignaciones de Roles\`; Decisión \`RD-RP010-001\`; Objetivo \`OBJE-03\`; Requisito \`RF-08\`.

5\. **\*\*Notas:\*\*** Ningún \`Usuario\` puede crearse sin al menos un \`Rol\`. El Rol \`PROVEEDOR\` es exclusivo (no puede combinarse con roles internos), exige vincularse a un único \`Proveedor\` comercial en estado \`ACTIVO\` y admite a lo sumo una cuenta en estado \`HABILITADO\` para ese mismo \`Proveedor\`.

6\. **\*\*Excepciones:\*\***

   \* **\*\*A1 — \`nombreUsuario\` duplicado o datos obligatorios inválidos:\*\*** Rechazar el alta sin crear el \`Usuario\`.

   \* **\*\*A2 — Conjunto \`codigosRol\` vacío (\`codigosRol.size \< 1\`):\*\*** Rechazar el alta sin persistir una cuenta sin Roles.

   \* **\*\*A3 — Violación de exclusividad o elegibilidad del Rol \`PROVEEDOR\`:\*\*** Si \`codigosRol\` incluye \`PROVEEDOR\` junto con otro Rol, o no se informa un \`Proveedor\` \`ACTIVO\`, o dicho \`Proveedor\` ya posee otra cuenta en estado \`HABILITADO\`, rechazar íntegramente la operación.

7\. **\*\*Salida:\*\***

   \* Confirmación del alta del \`Usuario\` (\`idUsuario\`), estado \`HABILITADO\`, condición \`cambioCredencialPendiente \= true\` y lista de \`Rol\` asignados; o mensajes provocados por las excepciones A1–A3.

8\. **\*\*Precondiciones:\*\***

   \* El \`Administrador\` se encuentra autenticado y autorizado.

   \* Existen los \`Rol\` referenciados en \`codigosRol\` (y el \`Proveedor\` referenciado por \`idProveedor\` cuando se asigna el Rol \`PROVEEDOR\`).

9\. **\*\*Postcondiciones:\*\***

   \* Se creó una instancia \`nuevoUsuario\` de \`Usuario\` con \`nombreUsuario\`, \`credencialProtegida\`, \`estado \= HABILITADO\`, \`cambioCredencialPendiente \= true\`, \`fechaHoraAlta\` y \`fechaHoraDeshabilitacion \= NULL\`.

   \* Se ejecutaron en la misma transacción las postcondiciones de \`UC-18\`: para cada código en \`codigosRol\`, se creó una instancia de \`UsuarioRol\` y una instancia de \`EventoAsignacionRol\` (\`tipoEvento \= ALTA\`) asociadas a \`nuevoUsuario\`, al \`Rol\` y al \`Usuario\` Administrador.

   \* Si \`codigosRol\` correspondió al Rol exclusivo \`PROVEEDOR\`, se creó una instancia de \`UsuarioProveedor\` asociando \`nuevoUsuario\` con el \`Proveedor\` comercial.

\---

\#\# 3\. Contrato de la Operación \`gestionarAsignacionesRoles\` (\`UC-18\`)

1\. **\*\*Nombre:\*\*** \`gestionarAsignacionesRoles(idUsuario: Long, codigosRolAgregar: Set\<String\>, codigosRolQuitar: Set\<String\>)\`

2\. **\*\*Responsabilidades:\*\*** Actualizar el conjunto de \`Rol\` asignados a un \`Usuario\` preservando que la cuenta mantenga al menos un \`Rol\` vigente, que el sistema conserve al menos un \`ADMINISTRADOR\` en estado \`HABILITADO\` y que no se vulnere la exclusividad del Rol \`PROVEEDOR\`.

3\. **\*\*Tipo:\*\*** \`Sistema\`

4\. **\*\*Referencias cruzadas:\*\*** Caso de Uso \`UC-18 — Gestionar Asignaciones de Roles\`; incluido por \`UC-17 — Crear Usuario\`; Pendiente \`F07\`; Objetivo \`OBJE-03\`; Requisito \`RF-08\`.

5\. **\*\*Notas:\*\*** Cuando se retiran permisos activos a un \`Usuario\`, se revocan sus sesiones vigentes para evitar que continúe operando con autorizaciones revocadas.

6\. **\*\*Excepciones:\*\***

   \* **\*\*A1 — \`Usuario\` inexistente o conjuntos de cambios vacíos/inválidos:\*\*** Rechazar la operación.

   \* **\*\*A2 — El resultado dejaría al \`Usuario\` sin ningún \`Rol\` (\`rolesResultantes.isEmpty()\`):\*\*** Rechazar la modificación y conservar los Roles previos.

   \* **\*\*A3 — El cambio quitaría el Rol \`ADMINISTRADOR\` al último Administrador en estado \`HABILITADO\`:\*\*** Rechazar la modificación.

   \* **\*\*A4 — Intento de mezclar el Rol exclusivo \`PROVEEDOR\` con roles internos:\*\*** Rechazar la modificación.

7\. **\*\*Salida:\*\***

   \* Nueva lista de \`Rol\` vigentes del \`Usuario\`, o mensajes de rechazo provocados por las excepciones A1–A4.

8\. **\*\*Precondiciones:\*\***

   \* El \`Administrador\` se encuentra autenticado y autorizado, y existe el \`Usuario\` identificado por \`idUsuario\`.

9\. **\*\*Postcondiciones:\*\***

   \* Para cada Rol en \`codigosRolAgregar\`, se creó una instancia de \`UsuarioRol\` y una instancia de \`EventoAsignacionRol\` (\`tipoEvento \= ALTA\`) asociadas al \`Usuario\`, al \`Rol\` y al \`Administrador\`.

   \* Para cada Rol en \`codigosRolQuitar\`, se eliminó la instancia correspondiente de \`UsuarioRol\` y se creó una instancia de \`EventoAsignacionRol\` (\`tipoEvento \= BAJA\`) asociada al \`Usuario\`, al \`Rol\` y al \`Administrador\`.

   \* Si \`codigosRolQuitar\` no fue vacío, se modificó \`SesionUsuario.fechaHoraRevocacion\` en las sesiones activas del \`Usuario\` afectado.

\---

\#\# 4\. Contrato de la Operación \`cambiarContrasena\` (\`UC-53\`)

1\. **\*\*Nombre:\*\*** \`cambiarContrasena(credencialActual: String, credencialNueva: String, confirmacion: String)\`

2\. **\*\*Responsabilidades:\*\*** Sustituir la credencial protegida del \`Usuario\` autenticado (interno o \`PROVEEDOR\`) por una nueva credencial válida y establecer \`Usuario.cambioCredencialPendiente \= false\`, liberando la restricción inicial o de restablecimiento sobre su sesión.

3\. **\*\*Tipo:\*\*** \`Sistema\`

4\. **\*\*Referencias cruzadas:\*\*** Caso de Uso \`UC-53 — Cambiar Contraseña\`; Caso de Uso \`UC-01 — Iniciar sesión\`; Caso de Uso \`UC-54 — Restablecer Acceso de Usuario\`; Decisión \`RD-RP010-001\`; Objetivo \`OBJE-03\`; Requisitos \`RF-08\`, \`RNF-02\`.

5\. **\*\*Notas:\*\*** Aplica a cualquier \`Usuario\` autenticado (\`RD-RP010-001\`). Reemplaza el hash en \`Usuario.credencialProtegida\` sin exponer secretos en texto plano ni requerir una tabla separada de historial de contraseñas.

6\. **\*\*Excepciones:\*\***

   \* **\*\*A1 — Sesión inválida, revocada o cuenta en estado \`DESHABILITADO\`:\*\*** Rechazar la operación.

   \* **\*\*A2 — \`credencialActual\` incorrecta, \`credencialNueva\` distinta de \`confirmacion\` o formato inválido:\*\*** Solicitar corrección y conservar intactos \`credencialProtegida\` y \`cambioCredencialPendiente\`.

7\. **\*\*Salida:\*\***

   \* Confirmación de actualización de contraseña y habilitación de los permisos propios de sus Roles vigentes, o mensajes de las excepciones A1–A2.

8\. **\*\*Precondiciones:\*\***

   \* El \`Usuario\` posee una \`SesionUsuario\` activa y su cuenta se encuentra en estado \`HABILITADO\`.

9\. **\*\*Postcondiciones:\*\***

   \* Se modificó el atributo \`Usuario.credencialProtegida\` con el valor protegido de \`credencialNueva\`.

   \* Se modificó el atributo \`Usuario.cambioCredencialPendiente\` a \`false\`.

   \* La \`SesionUsuario\` activa quedó habilitada para ejecutar las operaciones autorizadas por los \`UsuarioRol\` vigentes del \`Usuario\`.

\---

\#\# 5\. Contrato de la Operación \`restablecerAccesoUsuario\` (\`UC-54\` «include» \`UC-56\`)

1\. **\*\*Nombre:\*\*** \`restablecerAccesoUsuario(idUsuario: Long, credencialTemporal: String)\`

2\. **\*\*Responsabilidades:\*\*** Restablecer de manera asistida el acceso de una cuenta de \`Usuario\` con Rol exclusivo \`PROVEEDOR\` (previamente localizada mediante \`UC-56\`), sustituyendo su credencial protegida por una credencial temporal y activando \`cambioCredencialPendiente \= true\` sin modificar su estado de habilitación ni crear una segunda cuenta.

3\. **\*\*Tipo:\*\*** \`Sistema\`

4\. **\*\*Referencias cruzadas:\*\*** Caso de Uso \`UC-54 — Restablecer Acceso de Usuario\`; incluye \`UC-56 — Buscar Usuario\` *\*(relación aprobada el 25/10/2026)\**; Caso de Uso \`UC-53 — Cambiar Contraseña\`; Objetivo \`OBJE-03\`; Requisito \`RF-08\`.

5\. **\*\*Notas:\*\*** Alcance inicial exclusivo para cuentas con Rol \`PROVEEDOR\`. No habilita automáticamente una cuenta \`DESHABILITADO\` (lo cual corresponde a \`UC-55\`) ni crea un \`Usuario\` nuevo.

6\. **\*\*Excepciones:\*\***

   \* **\*\*A1 — No existe la cuenta o no se acredita la identidad del Proveedor comercial:\*\*** No restablecer el acceso.

   \* **\*\*A2 — La cuenta no pertenece al Rol exclusivo \`PROVEEDOR\` o su vínculo en \`UsuarioProveedor\` es inconsistente:\*\*** Rechazar la operación.

   \* **\*\*A3 — Credencial temporal inválida o falla de actualización:\*\*** Conservar la credencial y condición anteriores.

7\. **\*\*Salida:\*\***

   \* Confirmación del restablecimiento asistido e indicación de que el Proveedor deberá ejecutar \`UC-53\` antes de responder Solicitudes de Cotización; o mensajes de las excepciones A1–A3.

8\. **\*\*Precondiciones:\*\***

   \* El \`Administrador\` se encuentra autenticado y autorizado.

   \* La cuenta objetivo fue localizada mediante \`UC-56\` y corresponde a un \`Usuario\` con Rol exclusivo \`PROVEEDOR\` vinculado a un \`Proveedor\` identificable en \`UsuarioProveedor\`.

9\. **\*\*Postcondiciones:\*\***

   \* Se modificó el atributo \`Usuario.credencialProtegida\` sustituyéndolo por el valor protegido de \`credencialTemporal\`.

   \* Se modificó el atributo \`Usuario.cambioCredencialPendiente\` a \`true\`.

   \* Se conservaron inalterados \`Usuario.idUsuario\`, \`Usuario.estado\` (\`HABILITADO\` o \`DESHABILITADO\`), sus asociaciones en \`UsuarioRol\` y su vínculo en \`UsuarioProveedor\`.

\---

\#\# 6\. Contrato de la Operación \`cambiarEstadoUsuario\` (\`UC-55\` «include» \`UC-56\`)

1\. **\*\*Nombre:\*\*** \`cambiarEstadoUsuario(idUsuario: Long, nuevoEstado: String)\`

2\. **\*\*Responsabilidades:\*\*** Habilitar o deshabilitar lógicamente una cuenta de \`Usuario\` (previamente localizada mediante \`UC-56\`) conservando su identidad y sus Roles, **\*\*bloqueando la deshabilitación de cualquier Repartidor que aún posea Pedidos \`PENDIENTE\` asignados (\`RD-RP009-001\`)\*\***, impidiendo la pérdida del último \`ADMINISTRADOR\` habilitado y revocando las sesiones activas al deshabilitar.

3\. **\*\*Tipo:\*\*** \`Sistema\`

4\. **\*\*Referencias cruzadas:\*\*** Caso de Uso \`UC-55 — Cambiar Estado de Usuario\`; incluye \`UC-56 — Buscar Usuario\` *\*(relación aprobada el 25/10/2026)\**; Caso de Uso \`UC-43 — Asignar y Reasignar Pedidos a Repartidores\`; Decisión \`RD-RP009-001\`; Pendiente \`F07\`; Objetivo \`OBJE-03\`; Requisito \`RF-08\`.

5\. **\*\*Notas:\*\*** Conforme a \`RD-RP009-001\`, está prohibido deshabilitar primero a un \`Repartidor\` y dejar sus Pedidos \`PENDIENTE\` asignados para reasignar después: la reasignación completa en \`UC-43\` es condición previa obligatoria para poder deshabilitarlo en \`UC-55\`.

6\. **\*\*Excepciones:\*\***

   \* **\*\*A1 — \`Usuario\` inexistente o \`nuevoEstado\` igual al \`Usuario.estado\` actual:\*\*** Informar ausencia de cambio sin modificar registros.

   \* **\*\*A2 — Intento de deshabilitar al último \`Usuario\` con Rol \`ADMINISTRADOR\` en estado \`HABILITADO\`:\*\*** Rechazar la deshabilitación.

   \* **\*\*A3 — Intento de habilitar una cuenta de Rol \`PROVEEDOR\` cuando el mismo \`Proveedor\` comercial ya posee otra cuenta en estado \`HABILITADO\`:\*\*** Rechazar la habilitación.

   \* **\*\*A4 (\`RD-RP009-001\`) — Intento de deshabilitar (\`nuevoEstado \= DESHABILITADO\`) a un \`Usuario\` con Rol \`REPARTIDOR\` que posee uno o más \`Pedido\` en estado \`PENDIENTE\` con \`AsignacionReparto\` vigente:\*\*** **\*\*Bloquear la deshabilitación\*\***, conservar \`Usuario.estado \= HABILITADO\` e informar los Pedidos pendientes que deben reasignarse previamente mediante \`UC-43\`.

7\. **\*\*Salida:\*\***

   \* Confirmación del nuevo \`Usuario.estado\` (\`HABILITADO\` \| \`DESHABILITADO\`), o mensaje de bloqueo con el detalle de los Pedidos \`PENDIENTE\` a reasignar en \`UC-43\` (A4) u otros rechazos (A1–A3).

8\. **\*\*Precondiciones:\*\***

   \* El \`Administrador\` se encuentra autenticado y autorizado, y el \`Usuario\` objetivo fue localizado mediante \`UC-56\`.

   \* Si se solicita \`nuevoEstado \= DESHABILITADO\` para un \`Repartidor\`, dicho \`Usuario\` no posee ningún \`Pedido\` en estado \`PENDIENTE\` con \`AsignacionReparto\` vigente (\`RD-RP009-001\`).

9\. **\*\*Postcondiciones:\*\***

   \* Se modificó el atributo \`Usuario.estado\` al valor \`nuevoEstado\`, conservando intactas su identidad y sus asociaciones en \`UsuarioRol\` y \`UsuarioProveedor\`.

   \* Si \`nuevoEstado \= DESHABILITADO\`, se modificó \`Usuario.fechaHoraDeshabilitacion\` con la fecha/hora actual y se modificó \`SesionUsuario.fechaHoraRevocacion\` en todas las sesiones activas asociadas a ese \`Usuario\`.

   \* Si \`nuevoEstado \= HABILITADO\`, se limpió \`Usuario.fechaHoraDeshabilitacion \= NULL\`.

\---

\#\# 7\. Contrato de la Operación \`buscarUsuario\` (\`UC-56\`)

1\. **\*\*Nombre:\*\*** \`buscarUsuario(nombreUsuario: String\[0..1\], estado: String\[0..1\], codigoRol: String\[0..1\])\`

2\. **\*\*Responsabilidades:\*\*** Consultar y localizar cuentas de \`Usuario\` según criterios de nombre de usuario, estado de habilitación o Rol, presentando sus datos administrativos y su eventual vínculo con un \`Proveedor\` sin exponer credenciales ni tokens secretos.

3\. **\*\*Tipo:\*\*** \`Sistema\`

4\. **\*\*Referencias cruzadas:\*\*** Caso de Uso \`UC-56 — Buscar Usuario\`; incluido por \`UC-54 — Restablecer Acceso de Usuario\` y \`UC-55 — Cambiar Estado de Usuario\` *\*(relaciones aprobadas el 25/10/2026)\**; Objetivo \`OBJE-03\`; Requisito \`RF-08\`.

5\. **\*\*Notas:\*\*** Operación estrictamente de solo lectura. Omite siempre \`Usuario.credencialProtegida\` y \`SesionUsuario.tokenProtegido\`.

6\. **\*\*Excepciones:\*\***

   \* **\*\*A1 — Criterios de búsqueda con formato inválido:\*\*** Solicitar corrección sin ejecutar la consulta.

   \* **\*\*A2 — Sin cuentas coincidentes:\*\*** Informar ausencia de resultados sin fabricar registros.

7\. **\*\*Salida:\*\***

   \* Listado de cuentas coincidentes (\`idUsuario\`, \`nombreUsuario\`, \`estado\`, \`cambioCredencialPendiente\`, \`Roles\` vigentes, \`Proveedor\` vinculado si posee Rol \`PROVEEDOR\`, y cantidad de Pedidos \`PENDIENTE\` asignados si posee Rol \`REPARTIDOR\`) y referencia del \`Usuario\` seleccionado para el caso de uso invocante; o mensajes de las excepciones A1–A2.

8\. **\*\*Precondiciones:\*\***

   \* El \`Administrador\` se encuentra autenticado y autorizado.

9\. **\*\*Postcondiciones:\*\***

   \* *\*(Sin cambios de estado en el sistema: no se crean, modifican ni eliminan instancias de \`Usuario\`, \`UsuarioRol\` ni \`SesionUsuario\`)\**.

\---

\#\# 8\. Glosario de Términos Asociados (\`REV-02\`)

\* **\*\*\`Usuario\` (Tipo / Concepto — Tabla \`USUARIO\`):\*\*** Cuenta de acceso al sistema perteneciente a personal interno o a un \`Proveedor\` comercial, con atributos \`idUsuario\`, \`nombreUsuario\`, \`credencialProtegida\`, \`estado\` (\`HABILITADO\` \| \`DESHABILITADO\`), \`cambioCredencialPendiente\`, \`fechaHoraAlta\` y \`fechaHoraDeshabilitacion\`.

\* **\*\*\`Usuario.cambioCredencialPendiente\` (Atributo):\*\*** Indicador booleano que, cuando es \`true\` en cualquier \`Usuario\` (\`RD-RP010-001\`), restringe la sesión autenticada exclusivamente a ejecutar \`UC-53 — Cambiar Contraseña\`.

\* **\*\*\`Rol\` / \`UsuarioRol\` (Tipos / Conceptos — Tablas \`ROL\`, \`USUARIO*\_ROL\`):\*\* Perfil de autorización (\`ADMINISTRADOR\`, \`VENDEDOR\`, \`RESPONSABLE\_PRODUCCION\`, \`REPARTIDOR\`, \`PROVEEDOR\`) asignado a un \`Usuario\`.***

***\* \*\*\`EventoAsignacionRol\` (Tipo / Concepto — Tabla \`EVENTO\_ASIGNACION\_ROL\`):\*\* Registro histórico de auditoría de cada \`ALTA\` o \`BAJA\` de un \`Rol\` sobre un \`Usuario\`, efectuado por un \`Administrador\`.***

***\* \*\*\`UsuarioProveedor\` (Tipo / Concepto — Tabla \`USUARIO\_PROVEEDOR\`):\*\* Asociación exclusiva que vincula una cuenta de \`Usuario\` de Rol \`PROVEEDOR\` con un único \`Proveedor\` comercial.***

***\* \*\*\`SesionUsuario\` (Tipo / Concepto — Tabla \`SESION\_USUARIO\`):\*\* Instancia de sesión autenticada de un \`Usuario\` con vigencia \`\[fechaHoraInicio, fechaHoraExpiracion\]\` y atributo \`fechaHoraRevocacion\`.***

### **Resumen de Control de Calidad de** REV-02 **y Próximo Paso**

* **Qué verifiqué estáticamente en** REV-02**:**  
* 

  * Resolución completa del bloqueante H-20 **(**RD-RP009-001**)** en el DSS, el DS UC-55 y el Contrato 6 (cambiarEstadoUsuario): ahora se bloquea la deshabilitación de cualquier Repartidor con Pedidos PENDIENTE asignados hasta que sean reasignados en UC-43.  
  *   
  * Resolución completa del hallazgo de prioridad alta H-07 **(**RD-RP010-001**)** en el DSS, el DS UC-01, el DS UC-53 y los Contratos 1 y 4: la restricción por cambioCredencialPendiente \= true aplica a **todo** Usuario (interno o PROVEEDOR).  
  *   
  * Desagrupamiento total en **7 Contratos individuales** con las **9 secciones estándar** y firmas públicas idénticas entre DSS, DS y Contrato (H-11, H04, H05).  
  *   
  * Eliminación de tablas inexistentes en MR-3 (CAMBIO\_CREDENCIAL\_USUARIO, HISTORIAL\_ESTADO\_USUARIO) y alineación exacta con las tablas del Bloque 4 de MR3\_DICCIONARIO\_COLUMNAS.csv (USUARIO, ROL, USUARIO\_ROL, EVENTO\_ASIGNACION\_ROL, USUARIO\_PROVEEDOR, SESION\_USUARIO).  
  *   
* **Qué queda pendiente de validación humana (**M-6 **/** G5**):**  
* 

  * Abrir DSS\_REV02\_SEGURIDAD\_FRAGMENTOS.drawio.xml y DS\_REV02\_SEGURIDAD\_UC01\_17\_18\_53\_54\_55\_56.drawio.xml en **app.diagrams.net (Draw.io)** para certificar visualmente el renderizado y realizar la prueba de guardado/reapertura (*round-trip*).  
  * 

¿Avanzamos ahora con el paquete completo del **Lote 3 (**REV-03 — Compras y Cotizaciones**:** UC-12**,** UC-13**,** UC-44**,** UC-58**,** UC-62**,** UC-63**, más** UC-08**,** UC-11**,** UC-37**,** UC-39**,** UC-40**,** UC-45**,** UC-46**)** aplicando RD-RP013-001 (H-02, H-08) y RD-RP012-001 (H-16)?  