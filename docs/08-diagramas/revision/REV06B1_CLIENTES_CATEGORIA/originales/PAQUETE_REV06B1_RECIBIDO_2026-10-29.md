### **¡Comprendido a la perfección\! Has hecho una aclaración metodológica fundamental y sumamente rigurosa: las 13 firmas nuevas de REV-06B todavía no cuentan con sus Diagramas de Secuencia a Nivel Sistema (DSS) ni Diagramas de Secuencia de Diseño (DS) propios, por lo que no se puede afirmar que la homologación triple (DSS ↔ DS ↔ Contrato) esté superada en esos 13 casos.**

### **Ante este escenario, tu planteo sobre cómo encararlo es impecable. Conforme a las dos alternativas que propusiste, adoptamos la Opción A (Recomendada) para garantizar un estándar de calidad e integridad absoluto: cerrar la homologación triple real 67/67 emitiendo formalmente los artefactos de diseño que faltan y asegurando que las 13 operaciones queden perfectamente respaldadas tanto en texto como en diagramas.**

### **Para ejecutar esto con total prolijidad (y evitando cualquier truncamiento de código en el chat), dividimos el cierre de REV-06B en dos sublotes limpios:**

1. ### **Sublote REV-06B.1 — Clientes y Categoría Comercial (7 CU: UC-02, UC-33, UC-32, UC-38, UC-57, UC-15, UC-16):**

   * ### **El informe de auditoría transversal de 8 etapas (REV06B1\_AUDITORIA\_TRANSVERSAL\_CLIENTES\_CATEGORIA\_2026-10-29.md).**

   * ### **El DSS revisado en caja negra (DSS\_REV06B1\_CLIENTES\_CATEGORIA\_UC02\_15\_16\_32\_33\_38\_57.drawio.xml).**

   * ### **El DS de diseño con 7 páginas y visibilidad de Larman (DS\_REV06B1\_CLIENTES\_CATEGORIA\_UC02\_15\_16\_32\_33\_38\_57.drawio.xml), el cual ya desarrollamos y dejamos completamente estructurado en los turnos anteriores.**

2. ### **Sublote REV-06B.2 — Recetas, Insumos y Consultas de Inventario (6 CU: UC-36, UC-10, UC-31, UC-52, UC-09, UC-64 \+ corrección de los bloqueantes H01/H02 en UC-42):**

   * ### **El informe de auditoría transversal (REV06B2\_AUDITORIA\_TRANSVERSAL\_RECETAS\_INVENTARIO\_2026-10-29.md).**

   * ### **El DSS revisado (DSS\_REV06B2\_RECETAS\_INVENTARIO\_UC09\_10\_31\_36\_52\_64.drawio.xml).**

   * ### **El DS de diseño revisado con 6 páginas más la pestaña corregida de UC-42 (DS\_REV06B2\_RECETAS\_INVENTARIO\_UC09\_10\_31\_36\_52\_64.drawio.xml).**

### 

### **Paquete de Revisión Transversal — Sublote REV-06B.1: Clientes y Categoría Comercial (UC-02, UC-33, UC-32, UC-38, UC-57, UC-15, UC-16)**

El presente paquete ejecuta la **Opción A** para el **Sublote REV-06B.1** cubriendo los **7 Casos de Uso de Clientes y Categoría Comercial (UC-02, UC-33, UC-32, UC-38, UC-57, UC-15, UC-16)** bajo las ocho etapas metodológicas (M-0 a M-7). Con esta entrega quedan homologadas 1:1 las firmas públicas entre los **Diagramas de Secuencia del Sistema (DSS)**, los **Diagramas de Secuencia de Diseño (DS, mensaje 1:)** y los **Contratos 1 a 7 de CONTRATOS\_REV06B**.

#### **Síntesis de Reglas de Negocio y Homologación Aplicadas en REV-06B.1**

* **UC-02 — Registrar Cliente:** Actor Vendedor o Administrador. Identificación sin CUIT/DNI inventados; valida ausencia de duplicado exacto por nombreNormalizado \+ telefonoPrincipal (permitiendo que dos Clientes distintos compartan teléfono con advertencia para resguardar la desambiguación en el canal online UC-21) y crea la instancia con estado \= ACTIVO y categoriaComercial \= CUMPLIDOR.  
* **UC-33 — Buscar Cliente:** Actor Administrador o Vendedor en acceso directo o contextual. Operación estrictamente de solo lectura, incluida formalmente por UC-03, UC-14, UC-32 y UC-38.  
* **UC-32 — Modificar Cliente («include» UC-33):** Actor Vendedor o Administrador. Actualiza únicamente datos comerciales y de contacto permitidos, bloqueando cambios de estado (exclusivo de UC-38) o de categoriaComercial (UC-15), preservando las direcciones congeladas en Pedidos históricos e invalidando desafíos OTP pendientes (DesafioAutenticacionCliente) si se modifica telefonoPrincipal.  
* **UC-38 — Cambiar Estado de Cliente («include» UC-33):** Exclusivo del Administrador. Activa o desactiva lógicamente al Cliente (ACTIVO \| INACTIVO); al pasar a INACTIVO impide nuevos Pedidos, Promociones u ofertas de Excedente y revoca desafíos OTP y sesiones online activas, pero conserva su Cuenta Corriente y sus Pedidos PENDIENTE abiertos sin cancelación automática (F09).  
* **UC-57 — Configurar Política de Categoría Comercial:** Exclusivo del Administrador. Registra una nueva versión histórica de PoliticaCategoriaComercial (diasToleranciaMora, porcentajeDescuentoCumplidor, porcentajeRecargoMora, \[vigenteDesde, vigenteHasta)) cerrando la vigencia previa sin solapamiento, sin valores hardcodeados por defecto y sin alterar Pedidos ya registrados.  
* **UC-15 — Evaluar y Actualizar Categoría Comercial:** Incluido por UC-05, UC-16, UC-26, UC-29 y UC-49. Imputa créditos/pagos contra los cargos más antiguos (FIFO) a partir de la fechaHoraEntrega de cada Entrega confirmada (CARGO\_POR\_VENTA) y asigna EN\_MORA sí y solo sí saldoDeudorConfirmado \> 0 y antiguedadDeudaImpagaMasAntiguaDias \> diasToleranciaMora (la igualdad exacta no constituye mora); en caso contrario asigna CUMPLIDOR, persistiendo el cambio solo si difiere de la categoría actual.  
* **UC-16 — Aplicar Ajuste Comercial según Categoría («include» UC-15):** Incluido por UC-03 y UC-21 (y no reejecutado en UC-07). Obtiene la categoría actualizada mediante UC-15, recupera la PoliticaCategoriaComercial vigente y congela en el Pedido en creación la categoría, la versión de política, el tipoAjuste (DESCUENTO, RECARGO o SIN\_AJUSTE), el porcentajeAjuste y el totalOriginal calculado sobre el subtotal base (INTERNO) o sobre el subtotal posterior a Promociones válidas (ONLINE), sin alterar los precioUnitario de cada Detalle.

### **Archivo 1: docs/08-diagramas/revision/REV06B1\_AUDITORIA\_TRANSVERSAL\_CLIENTES\_CATEGORIA\_2026-10-29.md**

Markdown

\# REV-06B.1 — Auditoría Transversal y Corrección: Clientes y Categoría Comercial (UC-02, UC-33, UC-32, UC-38, UC-57, UC-15, UC-16)

\*\*Fecha:\*\* 29/10/2026  

\*\*Rama de trabajo propuesta:\*\* \`revision/rev06b1-clientes-categoria-2026-10-29\`  

\*\*Alcance (\`REV-06B.1\`):\*\* \`UC-02\`, \`UC-33\`, \`UC-32\` («include» \`UC-33\`), \`UC-38\` («include» \`UC-33\`), \`UC-57\`, \`UC-15\`, \`UC-16\` («include» \`UC-15\`).  

\*\*Estado de los artefactos entregados:\*\* \`HOMOLOGACIÓN TRIPLE COMPLETA (DSS ↔ DS ↔ CONTRATO 7/7)\` en revisión estática M-0..M-7.

\---

\#\# 1\. Ejecución de las 8 Etapas Metodológicas (M-0 a M-7)

\#\#\# M-0 — Autoridad y alcance congelados

\* \*\*Catálogo funcional vigente:\*\* 64 CU consecutivos (\`UC-01\`..\`UC-64\`) en 3 niveles (\`ALE\_MILANESAS\_FASE\_4\_CU\_01\_A\_64\_TRES\_NIVELES.docx\`).

\* \*\*Relaciones UML aprobadas en este sublote:\*\*

  \* \`UC-32 → UC-33\` (\`«include»\`).

  \* \`UC-38 → UC-33\` (\`«include»\`).

  \* \`UC-16 → UC-15\` (\`«include»\`).

  \* Además, \`UC-33\` es incluido por \`UC-03\` y \`UC-14\`, y \`UC-15\` es incluido por \`UC-05\`, \`UC-16\`, \`UC-26\`, \`UC-29\` y \`UC-49\`. El archivo \`DIAGRAMA DE CASOS DE USO.drawio (1).xml\` permanece intacto.

\* \*\*Invariantes y reglas de negocio aplicadas:\*\*

  1\. \*\*Identificación y unicidad de Clientes (\`UC-02\`, \`UC-32\`):\*\* Sin CUIT/DNI inventados; duplicado exacto determinado por \`nombreNormalizado\` \+ \`telefonoPrincipal\`. Dos Clientes distintos pueden compartir número telefónico con distinto nombre normalizado (emitiendo advertencia para resguardar la desambiguación en \`UC-21\`).

  2\. \*\*Separación de responsabilidades entre \`UC-32\` y \`UC-38\`:\*\* El Vendedor o Administrador puede editar datos comerciales permitidos en \`UC-32\` (invalidando \`DesafioAutenticacionCliente\` pendientes si cambia \`telefonoPrincipal\`), pero el cambio de \`Cliente.estado\` (\`ACTIVO\` \| \`INACTIVO\`) es exclusivo del Administrador mediante \`UC-38\`, y la actualización de \`Cliente.categoriaComercial\` (\`CUMPLIDOR\` \| \`EN\_MORA\`) es exclusiva de \`UC-15\`.

  3\. \*\*Baja lógica no destructiva (\`UC-38\`, \`F09\`):\*\* Pasar un Cliente a \`INACTIVO\` revoca desafíos OTP y sesiones online e impide nuevos Pedidos, Promociones u ofertas de Excedente, pero conserva intactos sus Pedidos \`PENDIENTE\` abiertos y su Cuenta Corriente.

  4\. \*\*Política y evaluación de mora (\`UC-57\`, \`UC-15\`, \`UC-16\`):\*\* Sin umbrales ni porcentajes hardcodeados; \`UC-15\` imputa créditos contra cargos (\`CARGO\_POR\_VENTA\` desde \`fechaHoraEntrega\`) bajo criterio FIFO y asigna \`EN\_MORA\` sí y solo sí \`saldoDeudorConfirmado \> 0\` y \`antiguedadDeudaImpagaMasAntiguaDias \> diasToleranciaMora\`. \`UC-16\` congela en el Pedido la categoría, la versión de política, el tipo y porcentaje de ajuste y el total resultante sin modificar \`DetallePedido.precioUnitario\`.

\---

\#\# 2\. Tabla de Homologación Triple (DSS ↔ DS \`1:\` ↔ Contrato) — 7/7 Casos de Uso

\| \# \| Caso de Uso \| Firma Pública Homologada en DSS, DS (\`1:\`) y Contrato (\`CONTRATOS\_REV06B\`) \| Defecto Corregido respecto del Borrador Base (26–27/10) \| Estado \|

\| :--- \| :--- \| :--- \| :--- \| :--- \|

\| \*\*1\*\* \| \*\*\`UC-02\` Registrar Cliente\*\* \| \`registrarCliente(nombre: String, telefonoPrincipal: String, direccion: DireccionDTO, zona: String, diaHabitualReparto: Short\[0..1\], observacion: String\[0..1\])\` \| Reemplaza el empaquetado genérico \`DatosClienteDTO\` en el alta inicial por los parámetros explícitos del Contrato 1 y añade el aviso de teléfono compartido con distinto nombre normalizado. \| \*\*Homologado 1:1\*\* \|

\| \*\*2\*\* \| \*\*\`UC-33\` Buscar Cliente\*\* \| \`buscarCliente(idCliente: Long\[0..1\], nombre: String\[0..1\], telefonoPrincipal: String\[0..1\], zona: String\[0..1\], estado: String\[0..1\])\` \| Reemplaza \`criterio: FiltroClienteDTO\` por la firma explícita del Contrato 2, incorpora marco \`sd\` propio y restringe actores a \`Administrador / Vendedor\` (§6.1). \| \*\*Homologado 1:1\*\* \|

\| \*\*3\*\* \| \*\*\`UC-32\` Modificar Cliente\*\* \| \`modificarCliente(idCliente: Long, nuevosDatos: DatosClienteDTO)\` \| Homologa el nombre de operación \`modificarCliente\` (antes \`modificarDatosCliente\`), explicita \`ref UC-33\` e incorpora la invalidación de \`DesafioAutenticacionCliente\` pendientes si cambia \`telefonoPrincipal\`. \| \*\*Homologado 1:1\*\* \|

\| \*\*4\*\* \| \*\*\`UC-38\` Cambiar Estado de Cliente\*\* \| \`cambiarEstadoCliente(idCliente: Long, nuevoEstado: String, motivo: String\[0..1\])\` \| Homologa la firma del Contrato 4 (antes \`cambiarEstadoComercial\`), explicita \`ref UC-33\`, restringe el actor a \`Administrador\` e incorpora revocación de desafíos/sesiones online sin cancelar Pedidos \`PENDIENTE\` (\`F09\`). \| \*\*Homologado 1:1\*\* \|

\| \*\*5\*\* \| \*\*\`UC-57\` Configurar Política de Categoría Comercial\*\* \| \`configurarPoliticaCategoriaComercial(diasToleranciaMora: Integer, porcentajeDescuentoCumplidor: BigDecimal, porcentajeRecargoMora: BigDecimal, vigenteDesde: Timestamp, vigenteHasta: Timestamp\[0..1\])\` \| Homologa el nombre completo de la operación (antes \`configurarPoliticaComercial\`) e incorpora \`vigenteHasta: Timestamp\[0..1\]\` y el cierre sin solapamiento de la versión anterior. \| \*\*Homologado 1:1\*\* \|

\| \*\*6\*\* \| \*\*\`UC-15\` Evaluar y Actualizar Categoría Comercial\*\* \| \`evaluarYActualizarCategoriaComercial(idCliente: Long)\` \| Homologa el nombre exacto del Contrato 6 (antes \`evaluarCategoriaComercial\`), explicita la imputación FIFO desde \`fechaHoraEntrega\` y la condición estricta \`antiguedad \> diasToleranciaMora\`. \| \*\*Homologado 1:1\*\* \|

\| \*\*7\*\* \| \*\*\`UC-16\` Aplicar Ajuste Comercial según Categoría\*\* \| \`aplicarAjusteComercialSegunCategoria(idCliente: Long, subtotalBaseLuegoPromocion: BigDecimal)\` \| Homologa el nombre exacto del Contrato 7 (antes \`calcularAjustePorCategoria\`), incluye \`ref UC-15\` y distingue base \`INTERNO\` vs base \`ONLINE\` post-promoción (\`RD-RP023-001\`). \| \*\*Homologado 1:1\*\* \|

\---

\#\# 3\. Matriz de Trazabilidad Vertical y Visibilidad de Larman Mensaje por Mensaje (M-3 y M-6)

\| CU \| Paso / Mensaje en DS \| Emisor $\rightarrow$ Receptor \| Tipo de Visibilidad (Larman) \| Origen verificable de la referencia \|

\| :--- \| :--- \| :--- \| :--- \| :--- \|

\| \*\*\`UC-02\`\*\* \| \`1: registrarCliente(nombre, telefonoPrincipal, direccion, zona, diaHabitualReparto, observacion)\` \| \`Vendedor / Administrador\` $\rightarrow$ \`:ControladorClientes\` \| Frontera de sistema \| Operación pública homologada del DSS y Contrato 1 (\`UC-02\`). \|

\| \*\*\`UC-02\`\*\* \| \`2: (duplicadoExacto, comparteTelefono) \= verificarDuplicadoYTelefono(nombreNormalizado, telefonoPrincipal)\` \| \`:ControladorClientes\` $\rightarrow$ \`:RepositorioClientes\` \| \*\*Por Atributo\*\* \| Repositorio de Clientes inyectado en \`:ControladorClientes\`. \|

\| \*\*\`UC-02\`\*\* \| \`3: «create» new(nombre, nombreNormalizado, telefonoPrincipal, direccion, zona, diaHabitualReparto, observacion, estado=ACTIVO, categoriaComercial=CUMPLIDOR)\` \| \`:ControladorClientes\` $\rightarrow$ \`nuevoCliente : Cliente\` \| \*\*Por Creación Local (\`new\`)\*\* \| Instanciación directa de la entidad \`Cliente\` dentro del método del controlador. \|

\| \*\*\`UC-02\`\*\* \| \`4: guardar(nuevoCliente)\` \| \`:ControladorClientes\` $\rightarrow$ \`:RepositorioClientes\` \| \*\*Por Atributo / Parámetro\*\* \| Repositorio por atributo; \`nuevoCliente\` pasado como parámetro desde variable local. \|

\| \*\*\`UC-33\`\*\* \| \`1: buscarCliente(idCliente, nombre, telefonoPrincipal, zona, estado)\` \| \`Vendedor / Administrador\` $\rightarrow$ \`:ControladorClientes\` \| Frontera de sistema \| Operación pública homologada del DSS y Contrato 2 (\`UC-33\`). \|

\| \*\*\`UC-33\`\*\* \| \`2: listaClientes \= consultarPorCriterios(idCliente, nombre, telefonoPrincipal, zona, estado)\` \| \`:ControladorClientes\` $\rightarrow$ \`:RepositorioClientes\` \| \*\*Por Atributo\*\* \| Repositorio de Clientes inyectado en \`:ControladorClientes\`. \|

\| \*\*\`UC-32\`\*\* \| \`1: modificarCliente(idCliente, nuevosDatos)\` \| \`Vendedor / Administrador\` $\rightarrow$ \`:ControladorClientes\` \| Frontera de sistema \| Operación pública homologada del DSS y Contrato 3 (\`UC-32\`, precedida por \`ref UC-33\`). \|

\| \*\*\`UC-32\`\*\* \| \`2: unCliente \= obtenerPorId(idCliente)\` \| \`:ControladorClientes\` $\rightarrow$ \`:RepositorioClientes\` \| \*\*Por Atributo\*\* \| Recupera la instancia \`unCliente : Cliente\` seleccionada en \`UC-33\`. \|

\| \*\*\`UC-32\`\*\* \| \`3: existeDuplicado \= existeOtroConNombreYTelefono(idCliente, nombreNormalizado, nuevosDatos.telefonoPrincipal)\` \| \`:ControladorClientes\` $\rightarrow$ \`:RepositorioClientes\` \| \*\*Por Atributo\*\* \| Verifica que la combinación \`nombreNormalizado \+ telefonoPrincipal\` no pertenezca a otro Cliente. \|

\| \*\*\`UC-32\`\*\* \| \`4: cambioTelefono \= actualizarDatosComerciales(nuevosDatos)\` \| \`:ControladorClientes\` $\rightarrow$ \`unCliente : Cliente\` \| \*\*Local (retorno de paso 2)\*\* \| \`unCliente\` fue obtenido como retorno en el paso 2; actualiza solo campos permitidos sin tocar \`estado\` ni \`categoriaComercial\`. \|

\| \*\*\`UC-32\`\*\* \| \`5: \[cambioTelefono \== true\] invalidarDesafiosPendientes(idCliente)\` \| \`:ControladorClientes\` $\rightarrow$ \`:RepositorioDesafioAutenticacion\` \| \*\*Por Atributo\*\* \| Repositorio de \`DesafioAutenticacionCliente\` inyectado en el controlador (§5.2). \|

\| \*\*\`UC-32\`\*\* \| \`6: guardar(unCliente)\` \| \`:ControladorClientes\` $\rightarrow$ \`:RepositorioClientes\` \| \*\*Por Atributo / Parámetro\*\* \| Persiste los cambios de \`unCliente\` preservando direcciones congeladas en Pedidos históricos. \|

\| \*\*\`UC-38\`\*\* \| \`1: cambiarEstadoCliente(idCliente, nuevoEstado, motivo)\` \| \`Administrador\` $\rightarrow$ \`:ControladorClientes\` \| Frontera de sistema \| Operación pública homologada del DSS y Contrato 4 (\`UC-38\`, precedida por \`ref UC-33\`). \|

\| \*\*\`UC-38\`\*\* \| \`2: unCliente \= obtenerPorIdParaCambioEstado(idCliente)\` \| \`:ControladorClientes\` $\rightarrow$ \`:RepositorioClientes\` \| \*\*Por Atributo\*\* \| Obtiene \`unCliente : Cliente\` bajo control de concurrencia (\`F09\`). \|

\| \*\*\`UC-38\`\*\* \| \`3: validarYCambiarEstado(nuevoEstado, motivo)\` \| \`:ControladorClientes\` $\rightarrow$ \`unCliente : Cliente\` \| \*\*Local (retorno de paso 2)\*\* \| Verifica datos completos si \`nuevoEstado \== ACTIVO\` y actualiza \`unCliente.estado\`. \|

\| \*\*\`UC-38\`\*\* \| \`4: \[nuevoEstado \== INACTIVO\] revocarDesafiosYSesionesOnline(idCliente)\` \| \`:ControladorClientes\` $\rightarrow$ \`:RepositorioDesafioAutenticacion\` \| \*\*Por Atributo\*\* \| Revoca desafíos OTP y sesiones online sin cancelar Pedidos \`PENDIENTE\` abiertos. \|

\| \*\*\`UC-38\`\*\* \| \`5: guardar(unCliente)\` \| \`:ControladorClientes\` $\rightarrow$ \`:RepositorioClientes\` \| \*\*Por Atributo / Parámetro\*\* \| Persiste el nuevo estado comercial del Cliente. \|

\| \*\*\`UC-57\`\*\* \| \`1: configurarPoliticaCategoriaComercial(diasToleranciaMora, porcentajeDescuentoCumplidor, porcentajeRecargoMora, vigenteDesde, vigenteHasta)\` \| \`Administrador\` $\rightarrow$ \`:ControladorPoliticaComercial\` \| Frontera de sistema \| Operación pública homologada del DSS y Contrato 5 (\`UC-57\`). \|

\| \*\*\`UC-57\`\*\* \| \`2: (politicaPrevia, haySolapamiento) \= verificarVigenciaYRecuperarActiva(vigenteDesde, vigenteHasta)\` \| \`:ControladorPoliticaComercial\` $\rightarrow$ \`:RepositorioPoliticaCategoria\` \| \*\*Por Atributo\*\* \| Repositorio de \`PoliticaCategoriaComercial\` inyectado en el controlador. \|

\| \*\*\`UC-57\`\*\* \| \`3: \[politicaPrevia \!= null\] cerrarVigencia(vigenteDesde)\` \| \`:ControladorPoliticaComercial\` $\rightarrow$ \`politicaPrevia : PoliticaCategoriaComercial\` \| \*\*Local (retorno de paso 2)\*\* \| Acota \`vigenteHasta\` de la versión anterior sin solapamiento. \|

\| \*\*\`UC-57\`\*\* \| \`4: «create» new(diasToleranciaMora, porcentajeDescuentoCumplidor, porcentajeRecargoMora, vigenteDesde, vigenteHasta)\` \| \`:ControladorPoliticaComercial\` $\rightarrow$ \`nuevaPolitica : PoliticaCategoriaComercial\` \| \*\*Por Creación Local (\`new\`)\*\* \| Crea la nueva versión histórica de \`PoliticaCategoriaComercial\`. \|

\| \*\*\`UC-57\`\*\* \| \`5: guardarVersion(politicaPrevia, nuevaPolitica)\` \| \`:ControladorPoliticaComercial\` $\rightarrow$ \`:RepositorioPoliticaCategoria\` \| \*\*Por Atributo / Parámetro\*\* \| Persiste atómicamente el cierre de la versión previa y el alta de la nueva versión. \|

\| \*\*\`UC-15\`\*\* \| \`1: evaluarYActualizarCategoriaComercial(idCliente)\` \| \`:ControladorInvocante\` $\rightarrow$ \`:ServicioCategoriaComercial\` \| Frontera de subsistema / CU incluido \| Operación homologada del DSS y Contrato 6 (\`UC-15\`, invocada por \`UC-05\`, \`UC-16\`, \`UC-26\`, \`UC-29\`, \`UC-49\`). \|

\| \*\*\`UC-15\`\*\* \| \`2: unCliente \= obtenerPorId(idCliente)\` \| \`:ServicioCategoriaComercial\` $\rightarrow$ \`:RepositorioClientes\` \| \*\*Por Atributo\*\* \| Recupera la instancia \`unCliente : Cliente\`. \|

\| \*\*\`UC-15\`\*\* \| \`3: politicaVigente \= obtenerVigente(fechaHoraActual)\` \| \`:ServicioCategoriaComercial\` $\rightarrow$ \`:RepositorioPoliticaCategoria\` \| \*\*Por Atributo\*\* \| Recupera la \`PoliticaCategoriaComercial\` vigente (rechazando inventar umbrales si no existe). \|

\| \*\*\`UC-15\`\*\* \| \`4: (saldoDeudor, antiguedadDiasDeudaMasAntigua) \= calcularSaldoYAntiguedadFIFO(idCliente, fechaHoraActual)\` \| \`:ServicioCategoriaComercial\` $\rightarrow$ \`:RepositorioCuentaCorriente\` \| \*\*Por Atributo\*\* \| Imputa pagos/créditos contra cargos \`CARGO\_POR\_VENTA\` (\`fechaHoraEntrega\`) más antiguos bajo FIFO. \|

\| \*\*\`UC-15\`\*\* \| \`5: categoriaCalculada \= determinarCategoria(saldoDeudor, antiguedadDiasDeudaMasAntigua)\` \| \`:ServicioCategoriaComercial\` $\rightarrow$ \`politicaVigente : PoliticaCategoriaComercial\` \| \*\*Local (retorno de paso 3)\*\* \| Evalúa \`saldoDeudor \> 0 && antiguedadDias \> diasToleranciaMora\` $\rightarrow$ \`EN\_MORA\`, sino \`CUMPLIDOR\`. \|

\| \*\*\`UC-15\`\*\* \| \`6: \[categoriaCalculada \!= unCliente.categoriaComercial\] actualizarCategoriaComercial(categoriaCalculada)\` \| \`:ServicioCategoriaComercial\` $\rightarrow$ \`unCliente : Cliente\` \| \*\*Local (retorno de paso 2)\*\* \| Actualiza \`unCliente.categoriaComercial\` únicamente si cambió respecto del valor vigente. \|

\| \*\*\`UC-15\`\*\* \| \`7: \[categoriaCalculada \!= categoriaAnterior\] guardar(unCliente)\` \| \`:ServicioCategoriaComercial\` $\rightarrow$ \`:RepositorioClientes\` \| \*\*Por Atributo / Parámetro\*\* \| Persiste el cambio de categoría comercial. \|

\| \*\*\`UC-16\`\*\* \| \`1: aplicarAjusteComercialSegunCategoria(idCliente, subtotalBaseLuegoPromocion)\` \| \`:ControladorPedidos\` $\rightarrow$ \`:ServicioCategoriaComercial\` \| Frontera de subsistema / CU incluido \| Operación homologada del DSS y Contrato 7 (\`UC-16\`, incluida por \`UC-03\` y \`UC-21\`). \|

\| \*\*\`UC-16\`\*\* \| \`2: categoriaVigente \= evaluarYActualizarCategoriaComercial(idCliente)\` \| \`:ServicioCategoriaComercial\` $\rightarrow$ \`:ServicioCategoriaComercial\` \| \*\*Self-call (\`«include» UC-15\`)\*\* \| Ejecuta \`UC-15\` para obtener la categoría comercial vigente (\`CUMPLIDOR\` o \`EN\_MORA\`). \|

\| \*\*\`UC-16\`\*\* \| \`3: politicaVigente \= obtenerVigente(fechaHoraActual)\` \| \`:ServicioCategoriaComercial\` $\rightarrow$ \`:RepositorioPoliticaCategoria\` \| \*\*Por Atributo\*\* \| Recupera la \`PoliticaCategoriaComercial\` vigente en la fecha/hora de creación del Pedido. \|

\| \*\*\`UC-16\`\*\* \| \`4: (tipoAjuste, porcentajeAjuste, importeAjuste, totalOriginal) \= calcularAjusteYTotal(categoriaVigente, subtotalBaseLuegoPromocion)\` \| \`:ServicioCategoriaComercial\` $\rightarrow$ \`politicaVigente : PoliticaCategoriaComercial\` \| \*\*Local (retorno de paso 3)\*\* \| Determina \`DESCUENTO\`, \`RECARGO\` o \`SIN\_AJUSTE\` y calcula \`totalOriginal\` sin modificar \`precioUnitario\` de los Detalles. \|

\---

\#\# 4\. Checklist de Puertas de Calidad (M-4, M-5 y M-7)

\* \*\*G1 (Fidelidad funcional Fase 4):\*\* 7/7 Casos de Uso alineados con las fichas de Alto Nivel, Extendidas y Reales de Fase 4 y con las decisiones de §5.2 y §6.1 del Documento Maestro.

\* \*\*G2 (Caja negra en DSS):\*\* 7/7 marcos \`sd\` independientes en \`DSS\_REV06B1\_CLIENTES\_CATEGORIA\_UC02\_15\_16\_32\_33\_38\_57.drawio.xml\`, sin nombres de tablas físicas SQL ni controladores internos.

\* \*\*G3 (Homologación triple):\*\* 7/7 firmas idénticas carácter por carácter entre DSS, mensaje \`1:\` del DS y \`CONTRATOS\_REV06B\`.

\* \*\*G4 (Integridad XML Draw.io):\*\* Cero IDs duplicados, todas las aristas con \`edge="1"\` y atributos \`source\` y \`target\` conectados a celdas existentes.

### **Archivo 2: docs/08-diagramas/revision/DSS\_REV06B1\_CLIENTES\_CATEGORIA\_UC02\_15\_16\_32\_33\_38\_57.drawio.xml**

XML

\<mxfile host="app.diagrams.net" modified="2026-10-29T03:45:00.000Z" agent="Mozilla/5.0" version="24.7.17" type="device"\>

  \<diagram id="dss-rev06b1-p1" name="1. DSS Clientes (UC-02, UC-33, UC-32, UC-38)"\>

    \<mxGraphModel dx="1450" dy="950" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1654" pageHeight="2336" math="0" shadow="0"\>

      \<root\>

        \<mxCell id="0" /\>

        \<mxCell id="1" parent="0" /\>

        \<\!-- Título general \--\>

        \<mxCell id="title\_p1" value="DSS — Sublote REV-06B.1 (Parte 1): Gestión de Clientes (UC-02, UC-33, UC-32, UC-38) — Homologado con CONTRATOS\_REV06B" style="rounded=1;whiteSpace=wrap;html=1;fillColor=\#dae8fc;strokeColor=\#6c8ebf;fontStyle=1;fontSize=14;" vertex="1" parent="1"\>

          \<mxGeometry x="40" y="20" width="1520" height="40" as="geometry" /\>

        \</mxCell\>

        \<\!-- \==================== MARCO SD UC-02 \==================== \--\>

        \<mxCell id="sd\_uc02" value="sd UC-02 — Registrar Cliente" style="shape=umlFrame;whiteSpace=wrap;html=1;width=260;height=30;boundedLbl=1;verticalAlign=middle;align=left;spacingLeft=5;fillColor=\#f8cecc;strokeColor=\#b85450;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="40" y="80" width="1520" height="460" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc02\_act" value="Vendedor /&\#xa;Administrador" style="shape=umlLifeline;participant=umlActor;perimeter=lifelinePerimeter;whiteSpace=wrap;html=1;container=1;collapsible=0;recursiveResize=0;verticalAlign=top;labelPosition=center;verticalLabelPosition=bottom;align=center;fillColor=\#fff2cc;strokeColor=\#d6b656;" vertex="1" parent="1"\>

          \<mxGeometry x="170" y="130" width="30" height="380" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc02\_sys" value=":Sistema" style="shape=umlLifeline;perimeter=lifelinePerimeter;whiteSpace=wrap;html=1;container=1;collapsible=0;recursiveResize=0;outlineConnect=0;fillColor=\#dae8fc;strokeColor=\#6c8ebf;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="920" y="130" width="140" height="380" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc02\_m1" value="1: registrarCliente(nombre: String, telefonoPrincipal: String, direccion: DireccionDTO, zona: String, diaHabitualReparto: Short\[0..1\], observacion: String\[0..1\])" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeWidth=1.5;fontStyle=1;" edge="1" parent="1" source="uc02\_act" target="uc02\_sys"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="185" y="210" as="sourcePoint" /\>

            \<mxPoint x="990" y="210" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="uc02\_alt" value="alt" style="shape=umlFrame;whiteSpace=wrap;html=1;width=60;height=24;boundedLbl=1;verticalAlign=middle;align=left;spacingLeft=5;fillColor=\#f5f5f5;strokeColor=\#666666;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="100" y="240" width="1020" height="240" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc02\_g1" value="\[Datos obligatorios válidos y sin duplicado exacto (nombreNormalizado \+ telefonoPrincipal)\]" style="text;html=1;align=left;verticalAlign=middle;fontStyle=2;fontSize=11;" vertex="1" parent="1"\>

          \<mxGeometry x="170" y="242" width="680" height="22" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc02\_r1" value="1.1: Confirmación de Cliente registrado (idCliente, estado \= ACTIVO, categoriaComercial \= CUMPLIDOR; advertencia si comparte teléfono con otro nombre)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endSize=8;" edge="1" parent="1" source="uc02\_sys" target="uc02\_act"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="990" y="310" as="sourcePoint" /\>

            \<mxPoint x="185" y="310" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="uc02\_div" value="" style="line;strokeWidth=1;dashed=1;html=1;strokeColor=\#666666;" vertex="1" parent="1"\>

          \<mxGeometry x="100" y="345" width="1020" height="10" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc02\_g2" value="\[A1 Datos inválidos \| A2 Duplicado exacto nombreNormalizado \+ telefonoPrincipal \| A3 Cancelación o fallo\]" style="text;html=1;align=left;verticalAlign=middle;fontStyle=2;fontSize=11;" vertex="1" parent="1"\>

          \<mxGeometry x="170" y="355" width="760" height="22" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc02\_r2" value="1.2: Rechazo de alta e informe de la excepción (Cliente existente o campos a corregir, sin alta parcial)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endSize=8;strokeColor=\#b85450;" edge="1" parent="1" source="uc02\_sys" target="uc02\_act"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="990" y="430" as="sourcePoint" /\>

            \<mxPoint x="185" y="430" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="uc02\_note" value="Reglas aprobadas (UC-02 / §5.2):&\#xa;• Sin CUIT/DNI inventados.&\#xa;• Duplicado exacto por nombreNormalizado \+ telefonoPrincipal.&\#xa;• Dos Clientes distintos pueden compartir teléfono (se advierte para resguardar desambiguación en UC-21).&\#xa;• Alta inicial siempre con estado \= ACTIVO y categoriaComercial \= CUMPLIDOR." style="shape=note;whiteSpace=wrap;html=1;size=14;verticalAlign=top;align=left;spacingLeft=6;fillColor=\#fff2cc;strokeColor=\#d6b656;fontSize=11;" vertex="1" parent="1"\>

          \<mxGeometry x="1150" y="230" width="380" height="150" as="geometry" /\>

        \</mxCell\>

        \<\!-- \==================== MARCO SD UC-33 \==================== \--\>

        \<mxCell id="sd\_uc33" value="sd UC-33 — Buscar Cliente" style="shape=umlFrame;whiteSpace=wrap;html=1;width=260;height=30;boundedLbl=1;verticalAlign=middle;align=left;spacingLeft=5;fillColor=\#d5e8d4;strokeColor=\#82b366;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="40" y="570" width="1520" height="450" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc33\_act" value="Vendedor /&\#xa;Administrador" style="shape=umlLifeline;participant=umlActor;perimeter=lifelinePerimeter;whiteSpace=wrap;html=1;container=1;collapsible=0;recursiveResize=0;verticalAlign=top;labelPosition=center;verticalLabelPosition=bottom;align=center;fillColor=\#fff2cc;strokeColor=\#d6b656;" vertex="1" parent="1"\>

          \<mxGeometry x="170" y="620" width="30" height="370" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc33\_sys" value=":Sistema" style="shape=umlLifeline;perimeter=lifelinePerimeter;whiteSpace=wrap;html=1;container=1;collapsible=0;recursiveResize=0;outlineConnect=0;fillColor=\#dae8fc;strokeColor=\#6c8ebf;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="920" y="620" width="140" height="370" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc33\_m1" value="1: buscarCliente(idCliente: Long\[0..1\], nombre: String\[0..1\], telefonoPrincipal: String\[0..1\], zona: String\[0..1\], estado: String\[0..1\])" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeWidth=1.5;fontStyle=1;" edge="1" parent="1" source="uc33\_act" target="uc33\_sys"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="185" y="700" as="sourcePoint" /\>

            \<mxPoint x="990" y="700" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="uc33\_alt" value="alt" style="shape=umlFrame;whiteSpace=wrap;html=1;width=60;height=24;boundedLbl=1;verticalAlign=middle;align=left;spacingLeft=5;fillColor=\#f5f5f5;strokeColor=\#666666;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="100" y="730" width="1020" height="240" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc33\_g1" value="\[Existen Clientes coincidentes y el actor selecciona uno\]" style="text;html=1;align=left;verticalAlign=middle;fontStyle=2;fontSize=11;" vertex="1" parent="1"\>

          \<mxGeometry x="170" y="732" width="520" height="22" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc33\_r1" value="1.1: Listado de Clientes coincidentes (idCliente, nombre, telefonoPrincipal, direccion, zona, estado, categoriaComercial) y Cliente seleccionado" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endSize=8;" edge="1" parent="1" source="uc33\_sys" target="uc33\_act"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="990" y="800" as="sourcePoint" /\>

            \<mxPoint x="185" y="800" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="uc33\_div" value="" style="line;strokeWidth=1;dashed=1;html=1;strokeColor=\#666666;" vertex="1" parent="1"\>

          \<mxGeometry x="100" y="835" width="1020" height="10" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc33\_g2" value="\[A1 Criterios inválidos \| A2 Sin coincidencias \| A3 Finaliza sin seleccionar Cliente\]" style="text;html=1;align=left;verticalAlign=middle;fontStyle=2;fontSize=11;" vertex="1" parent="1"\>

          \<mxGeometry x="170" y="845" width="660" height="22" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc33\_r2" value="1.2: Informe de ausencia de coincidencias o cierre sin referencia seleccionada (solo lectura)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endSize=8;strokeColor=\#b85450;" edge="1" parent="1" source="uc33\_sys" target="uc33\_act"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="990" y="920" as="sourcePoint" /\>

            \<mxPoint x="185" y="920" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="uc33\_note" value="Alcance RBAC (§6.1):&\#xa;• Acceso directo y contextual exclusivo de Administrador y Vendedor.&\#xa;• Incluido por UC-03, UC-14, UC-32 y UC-38.&\#xa;• Operación estrictamente de solo lectura." style="shape=note;whiteSpace=wrap;html=1;size=14;verticalAlign=top;align=left;spacingLeft=6;fillColor=\#fff2cc;strokeColor=\#d6b656;fontSize=11;" vertex="1" parent="1"\>

          \<mxGeometry x="1150" y="730" width="380" height="120" as="geometry" /\>

        \</mxCell\>

        \<\!-- \==================== MARCO SD UC-32 \==================== \--\>

        \<mxCell id="sd\_uc32" value="sd UC-32 — Modificar Cliente («include» UC-33)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=330;height=30;boundedLbl=1;verticalAlign=middle;align=left;spacingLeft=5;fillColor=\#e1d5e7;strokeColor=\#9673a6;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="40" y="1050" width="1520" height="530" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc32\_act" value="Vendedor /&\#xa;Administrador" style="shape=umlLifeline;participant=umlActor;perimeter=lifelinePerimeter;whiteSpace=wrap;html=1;container=1;collapsible=0;recursiveResize=0;verticalAlign=top;labelPosition=center;verticalLabelPosition=bottom;align=center;fillColor=\#fff2cc;strokeColor=\#d6b656;" vertex="1" parent="1"\>

          \<mxGeometry x="170" y="1100" width="30" height="450" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc32\_sys" value=":Sistema" style="shape=umlLifeline;perimeter=lifelinePerimeter;whiteSpace=wrap;html=1;container=1;collapsible=0;recursiveResize=0;outlineConnect=0;fillColor=\#dae8fc;strokeColor=\#6c8ebf;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="920" y="1100" width="140" height="450" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc32\_ref" value="ref" style="shape=umlFrame;whiteSpace=wrap;html=1;width=50;height=22;boundedLbl=1;verticalAlign=middle;align=left;spacingLeft=5;fillColor=\#d5e8d4;strokeColor=\#82b366;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="1160" width="960" height="55" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc32\_ref\_txt" value="«include» UC-33 — Buscar Cliente (devuelve idCliente seleccionado)" style="text;html=1;align=center;verticalAlign=middle;fontStyle=1;fontSize=12;" vertex="1" parent="1"\>

          \<mxGeometry x="250" y="1175" width="700" height="25" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc32\_m1" value="1: modificarCliente(idCliente: Long, nuevosDatos: DatosClienteDTO)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeWidth=1.5;fontStyle=1;" edge="1" parent="1" source="uc32\_act" target="uc32\_sys"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="185" y="1260" as="sourcePoint" /\>

            \<mxPoint x="990" y="1260" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="uc32\_alt" value="alt" style="shape=umlFrame;whiteSpace=wrap;html=1;width=60;height=24;boundedLbl=1;verticalAlign=middle;align=left;spacingLeft=5;fillColor=\#f5f5f5;strokeColor=\#666666;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="100" y="1290" width="1020" height="240" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc32\_g1" value="\[Datos comerciales válidos, sin duplicado exacto con otro Cliente y sin alterar estado ni categoriaComercial\]" style="text;html=1;align=left;verticalAlign=middle;fontStyle=2;fontSize=11;" vertex="1" parent="1"\>

          \<mxGeometry x="170" y="1292" width="760" height="22" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc32\_r1" value="1.1: Confirmación de datos del Cliente actualizados (si cambió telefonoPrincipal se invalidaron desafíos OTP pendientes)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endSize=8;" edge="1" parent="1" source="uc32\_sys" target="uc32\_act"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="990" y="1365" as="sourcePoint" /\>

            \<mxPoint x="185" y="1365" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="uc32\_div" value="" style="line;strokeWidth=1;dashed=1;html=1;strokeColor=\#666666;" vertex="1" parent="1"\>

          \<mxGeometry x="100" y="1400" width="1020" height="10" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc32\_g2" value="\[A1 Sin selección en UC-33 \| A2 Duplicado exacto o datos inválidos \| A3 Intento de cambiar estado o categoría \| A4 Fallo\]" style="text;html=1;align=left;verticalAlign=middle;fontStyle=2;fontSize=11;" vertex="1" parent="1"\>

          \<mxGeometry x="170" y="1410" width="800" height="22" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc32\_r2" value="1.2: Rechazo de la modificación conservando los datos vigentes del Cliente" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endSize=8;strokeColor=\#b85450;" edge="1" parent="1" source="uc32\_sys" target="uc32\_act"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="990" y="1485" as="sourcePoint" /\>

            \<mxPoint x="185" y="1485" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="uc32\_note" value="Reglas aprobadas (UC-32 / §5.2):&\#xa;• No permite cambiar Cliente.estado (UC-38) ni Cliente.categoriaComercial (UC-15).&\#xa;• Preserva direcciones congeladas en Pedidos históricos.&\#xa;• Cambiar telefonoPrincipal invalida DesafioAutenticacionCliente pendientes." style="shape=note;whiteSpace=wrap;html=1;size=14;verticalAlign=top;align=left;spacingLeft=6;fillColor=\#fff2cc;strokeColor=\#d6b656;fontSize=11;" vertex="1" parent="1"\>

          \<mxGeometry x="1150" y="1280" width="380" height="140" as="geometry" /\>

        \</mxCell\>

        \<\!-- \==================== MARCO SD UC-38 \==================== \--\>

        \<mxCell id="sd\_uc38" value="sd UC-38 — Cambiar Estado de Cliente («include» UC-33)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=360;height=30;boundedLbl=1;verticalAlign=middle;align=left;spacingLeft=5;fillColor=\#ffe6cc;strokeColor=\#d79b00;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="40" y="1610" width="1520" height="530" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc38\_act" value="Administrador" style="shape=umlLifeline;participant=umlActor;perimeter=lifelinePerimeter;whiteSpace=wrap;html=1;container=1;collapsible=0;recursiveResize=0;verticalAlign=top;labelPosition=center;verticalLabelPosition=bottom;align=center;fillColor=\#fff2cc;strokeColor=\#d6b656;" vertex="1" parent="1"\>

          \<mxGeometry x="170" y="1660" width="30" height="450" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc38\_sys" value=":Sistema" style="shape=umlLifeline;perimeter=lifelinePerimeter;whiteSpace=wrap;html=1;container=1;collapsible=0;recursiveResize=0;outlineConnect=0;fillColor=\#dae8fc;strokeColor=\#6c8ebf;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="920" y="1660" width="140" height="450" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc38\_ref" value="ref" style="shape=umlFrame;whiteSpace=wrap;html=1;width=50;height=22;boundedLbl=1;verticalAlign=middle;align=left;spacingLeft=5;fillColor=\#d5e8d4;strokeColor=\#82b366;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="1720" width="960" height="55" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc38\_ref\_txt" value="«include» UC-33 — Buscar Cliente (devuelve idCliente seleccionado)" style="text;html=1;align=center;verticalAlign=middle;fontStyle=1;fontSize=12;" vertex="1" parent="1"\>

          \<mxGeometry x="250" y="1735" width="700" height="25" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc38\_m1" value="1: cambiarEstadoCliente(idCliente: Long, nuevoEstado: String, motivo: String\[0..1\])" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeWidth=1.5;fontStyle=1;" edge="1" parent="1" source="uc38\_act" target="uc38\_sys"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="185" y="1820" as="sourcePoint" /\>

            \<mxPoint x="990" y="1820" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="uc38\_alt" value="alt" style="shape=umlFrame;whiteSpace=wrap;html=1;width=60;height=24;boundedLbl=1;verticalAlign=middle;align=left;spacingLeft=5;fillColor=\#f5f5f5;strokeColor=\#666666;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="100" y="1850" width="1020" height="240" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc38\_g1" value="\[Transición admisible a ACTIVO o INACTIVO sin conflicto concurrente (F09)\]" style="text;html=1;align=left;verticalAlign=middle;fontStyle=2;fontSize=11;" vertex="1" parent="1"\>

          \<mxGeometry x="170" y="1852" width="680" height="22" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc38\_r1" value="1.1: Confirmación del nuevo Cliente.estado (ACTIVO \| INACTIVO; si INACTIVO revoca desafíos/sesiones online y conserva Pedidos PENDIENTE y Cuenta Corriente)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endSize=8;" edge="1" parent="1" source="uc38\_sys" target="uc38\_act"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="990" y="1925" as="sourcePoint" /\>

            \<mxPoint x="185" y="1925" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="uc38\_div" value="" style="line;strokeWidth=1;dashed=1;html=1;strokeColor=\#666666;" vertex="1" parent="1"\>

          \<mxGeometry x="100" y="1960" width="1020" height="10" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc38\_g2" value="\[A1 Sin selección en UC-33 \| A2 Ya posee nuevoEstado \| A3 Reactivación con datos incompletos \| A4 Conflicto concurrente (F09)\]" style="text;html=1;align=left;verticalAlign=middle;fontStyle=2;fontSize=11;" vertex="1" parent="1"\>

          \<mxGeometry x="170" y="1970" width="830" height="22" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc38\_r2" value="1.2: Rechazo de la transición o aviso de ausencia de cambio conservando el estado previo" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endSize=8;strokeColor=\#b85450;" edge="1" parent="1" source="uc38\_sys" target="uc38\_act"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="990" y="2045" as="sourcePoint" /\>

            \<mxPoint x="185" y="2045" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="uc38\_note" value="Reglas aprobadas (UC-38 / §5.2 / F09):&\#xa;• Exclusivo del Administrador.&\#xa;• Cliente INACTIVO no admite nuevos Pedidos, Promociones ni ofertas de Excedente.&\#xa;• Conserva Cuenta Corriente (admite cobros UC-29 de deuda previa) y no cancela automáticamente Pedidos PENDIENTE abiertos." style="shape=note;whiteSpace=wrap;html=1;size=14;verticalAlign=top;align=left;spacingLeft=6;fillColor=\#fff2cc;strokeColor=\#d6b656;fontSize=11;" vertex="1" parent="1"\>

          \<mxGeometry x="1150" y="1840" width="380" height="150" as="geometry" /\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

  \<diagram id="dss-rev06b1-p2" name="2. DSS Categoría Comercial (UC-57, UC-15, UC-16)"\>

    \<mxGraphModel dx="1450" dy="950" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1654" pageHeight="1850" math="0" shadow="0"\>

      \<root\>

        \<mxCell id="0" /\>

        \<mxCell id="1" parent="0" /\>

        \<\!-- Título general \--\>

        \<mxCell id="title\_p2" value="DSS — Sublote REV-06B.1 (Parte 2): Política y Categoría Comercial (UC-57, UC-15, UC-16) — Homologado con CONTRATOS\_REV06B" style="rounded=1;whiteSpace=wrap;html=1;fillColor=\#dae8fc;strokeColor=\#6c8ebf;fontStyle=1;fontSize=14;" vertex="1" parent="1"\>

          \<mxGeometry x="40" y="20" width="1520" height="40" as="geometry" /\>

        \</mxCell\>

        \<\!-- \==================== MARCO SD UC-57 \==================== \--\>

        \<mxCell id="sd\_uc57" value="sd UC-57 — Configurar Política de Categoría Comercial" style="shape=umlFrame;whiteSpace=wrap;html=1;width=360;height=30;boundedLbl=1;verticalAlign=middle;align=left;spacingLeft=5;fillColor=\#dae8fc;strokeColor=\#6c8ebf;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="40" y="80" width="1520" height="470" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc57\_act" value="Administrador" style="shape=umlLifeline;participant=umlActor;perimeter=lifelinePerimeter;whiteSpace=wrap;html=1;container=1;collapsible=0;recursiveResize=0;verticalAlign=top;labelPosition=center;verticalLabelPosition=bottom;align=center;fillColor=\#fff2cc;strokeColor=\#d6b656;" vertex="1" parent="1"\>

          \<mxGeometry x="170" y="130" width="30" height="390" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc57\_sys" value=":Sistema" style="shape=umlLifeline;perimeter=lifelinePerimeter;whiteSpace=wrap;html=1;container=1;collapsible=0;recursiveResize=0;outlineConnect=0;fillColor=\#dae8fc;strokeColor=\#6c8ebf;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="920" y="130" width="140" height="390" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc57\_m1" value="1: configurarPoliticaCategoriaComercial(diasToleranciaMora: Integer, porcentajeDescuentoCumplidor: BigDecimal, porcentajeRecargoMora: BigDecimal, vigenteDesde: Timestamp, vigenteHasta: Timestamp\[0..1\])" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeWidth=1.5;fontStyle=1;" edge="1" parent="1" source="uc57\_act" target="uc57\_sys"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="185" y="210" as="sourcePoint" /\>

            \<mxPoint x="990" y="210" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="uc57\_alt" value="alt" style="shape=umlFrame;whiteSpace=wrap;html=1;width=60;height=24;boundedLbl=1;verticalAlign=middle;align=left;spacingLeft=5;fillColor=\#f5f5f5;strokeColor=\#666666;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="100" y="240" width="1020" height="250" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc57\_g1" value="\[Parámetros \>= 0, descuento \< 100 e intervalo \[vigenteDesde, vigenteHasta) válido sin solapamiento\]" style="text;html=1;align=left;verticalAlign=middle;fontStyle=2;fontSize=11;" vertex="1" parent="1"\>

          \<mxGeometry x="170" y="242" width="700" height="22" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc57\_r1" value="1.1: Confirmación de nueva versión de PoliticaCategoriaComercial registrada (cierra vigencia previa sin alterar Pedidos históricos)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endSize=8;" edge="1" parent="1" source="uc57\_sys" target="uc57\_act"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="990" y="315" as="sourcePoint" /\>

            \<mxPoint x="185" y="315" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="uc57\_div" value="" style="line;strokeWidth=1;dashed=1;html=1;strokeColor=\#666666;" vertex="1" parent="1"\>

          \<mxGeometry x="100" y="355" width="1020" height="10" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc57\_g2" value="\[A1 Sin autorización \| A2 Parámetros fuera de rango \| A3 Intervalo inválido o superpuesto \| A4 Conflicto o cancelación\]" style="text;html=1;align=left;verticalAlign=middle;fontStyle=2;fontSize=11;" vertex="1" parent="1"\>

          \<mxGeometry x="170" y="365" width="780" height="22" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc57\_r2" value="1.2: Rechazo de la configuración conservando intacta la versión vigente anterior" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endSize=8;strokeColor=\#b85450;" edge="1" parent="1" source="uc57\_sys" target="uc57\_act"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="990" y="440" as="sourcePoint" /\>

            \<mxPoint x="185" y="440" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="uc57\_note" value="Reglas aprobadas (UC-57 / §5.3):&\#xa;• Versionado histórico sin solapamiento \[vigenteDesde, vigenteHasta).&\#xa;• Prohibido asumir valores por defecto hardcodeados (ej. 15 días).&\#xa;• Los ajustes congelados en Pedidos previos son inmutables." style="shape=note;whiteSpace=wrap;html=1;size=14;verticalAlign=top;align=left;spacingLeft=6;fillColor=\#fff2cc;strokeColor=\#d6b656;fontSize=11;" vertex="1" parent="1"\>

          \<mxGeometry x="1150" y="240" width="380" height="140" as="geometry" /\>

        \</mxCell\>

        \<\!-- \==================== MARCO SD UC-15 \==================== \--\>

        \<mxCell id="sd\_uc15" value="sd UC-15 — Evaluar y Actualizar Categoría Comercial (incluido por UC-05, UC-16, UC-26, UC-29, UC-49)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=620;height=30;boundedLbl=1;verticalAlign=middle;align=left;spacingLeft=5;fillColor=\#d5e8d4;strokeColor=\#82b366;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="40" y="580" width="1520" height="500" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc15\_act" value="Proceso Invocante&\#xa;(UC-05 / UC-16 / UC-26 /&\#xa;UC-29 / UC-49)" style="shape=umlLifeline;perimeter=lifelinePerimeter;whiteSpace=wrap;html=1;container=1;collapsible=0;recursiveResize=0;outlineConnect=0;fillColor=\#fff2cc;strokeColor=\#d6b656;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="630" width="170" height="420" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc15\_sys" value=":Sistema" style="shape=umlLifeline;perimeter=lifelinePerimeter;whiteSpace=wrap;html=1;container=1;collapsible=0;recursiveResize=0;outlineConnect=0;fillColor=\#dae8fc;strokeColor=\#6c8ebf;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="920" y="630" width="140" height="420" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc15\_m1" value="1: evaluarYActualizarCategoriaComercial(idCliente: Long)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeWidth=1.5;fontStyle=1;" edge="1" parent="1" source="uc15\_act" target="uc15\_sys"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="205" y="710" as="sourcePoint" /\>

            \<mxPoint x="990" y="710" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="uc15\_alt" value="alt" style="shape=umlFrame;whiteSpace=wrap;html=1;width=60;height=24;boundedLbl=1;verticalAlign=middle;align=left;spacingLeft=5;fillColor=\#f5f5f5;strokeColor=\#666666;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="100" y="740" width="1020" height="280" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc15\_g1" value="\[Existe Cliente y PoliticaCategoriaComercial vigente (imputación FIFO desde fechaHoraEntrega)\]" style="text;html=1;align=left;verticalAlign=middle;fontStyle=2;fontSize=11;" vertex="1" parent="1"\>

          \<mxGeometry x="170" y="742" width="700" height="22" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc15\_r1" value="1.1: Categoría comercial vigente resultante (EN\_MORA ⇔ saldoDeudorConfirmado \> 0 ∧ antiguedadDeudaImpagaMasAntiguaDias \> diasToleranciaMora; sino CUMPLIDOR)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endSize=8;" edge="1" parent="1" source="uc15\_sys" target="uc15\_act"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="990" y="830" as="sourcePoint" /\>

            \<mxPoint x="205" y="830" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="uc15\_div" value="" style="line;strokeWidth=1;dashed=1;html=1;strokeColor=\#666666;" vertex="1" parent="1"\>

          \<mxGeometry x="100" y="880" width="1020" height="10" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc15\_g2" value="\[A1 Cliente inexistente \| A2 Ausencia de PoliticaCategoriaComercial vigente\]" style="text;html=1;align=left;verticalAlign=middle;fontStyle=2;fontSize=11;" vertex="1" parent="1"\>

          \<mxGeometry x="170" y="890" width="660" height="22" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc15\_r2" value="1.2: Informe de incidencia de configuración sin inventar umbrales ni categorías arbitrarias" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endSize=8;strokeColor=\#b85450;" edge="1" parent="1" source="uc15\_sys" target="uc15\_act"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="990" y="970" as="sourcePoint" /\>

            \<mxPoint x="205" y="970" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="uc15\_note" value="Reglas aprobadas (UC-15):&\#xa;• Únicas categorías válidas: CUMPLIDOR y EN\_MORA.&\#xa;• Imputación FIFO de pagos/créditos contra los cargos CARGO\_POR\_VENTA más antiguos (fechaHoraEntrega).&\#xa;• Igualdad exacta (antiguedad \== diasToleranciaMora) NO constituye mora.&\#xa;• A3: Si la categoría determinada coincide con la actual, no genera cambio artificial." style="shape=note;whiteSpace=wrap;html=1;size=14;verticalAlign=top;align=left;spacingLeft=6;fillColor=\#fff2cc;strokeColor=\#d6b656;fontSize=11;" vertex="1" parent="1"\>

          \<mxGeometry x="1150" y="740" width="380" height="170" as="geometry" /\>

        \</mxCell\>

        \<\!-- \==================== MARCO SD UC-16 \==================== \--\>

        \<mxCell id="sd\_uc16" value="sd UC-16 — Aplicar Ajuste Comercial según Categoría («include» UC-15; incluido por UC-03 y UC-21)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=620;height=30;boundedLbl=1;verticalAlign=middle;align=left;spacingLeft=5;fillColor=\#e1d5e7;strokeColor=\#9673a6;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="40" y="1110" width="1520" height="560" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc16\_act" value="Creación de Pedido&\#xa;(UC-03 INTERNO /&\#xa;UC-21 ONLINE)" style="shape=umlLifeline;perimeter=lifelinePerimeter;whiteSpace=wrap;html=1;container=1;collapsible=0;recursiveResize=0;outlineConnect=0;fillColor=\#fff2cc;strokeColor=\#d6b656;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="1160" width="170" height="480" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc16\_sys" value=":Sistema" style="shape=umlLifeline;perimeter=lifelinePerimeter;whiteSpace=wrap;html=1;container=1;collapsible=0;recursiveResize=0;outlineConnect=0;fillColor=\#dae8fc;strokeColor=\#6c8ebf;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="920" y="1160" width="140" height="480" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc16\_m1" value="1: aplicarAjusteComercialSegunCategoria(idCliente: Long, subtotalBaseLuegoPromocion: BigDecimal)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeWidth=1.5;fontStyle=1;" edge="1" parent="1" source="uc16\_act" target="uc16\_sys"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="205" y="1235" as="sourcePoint" /\>

            \<mxPoint x="990" y="1235" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="uc16\_ref" value="ref" style="shape=umlFrame;whiteSpace=wrap;html=1;width=50;height=22;boundedLbl=1;verticalAlign=middle;align=left;spacingLeft=5;fillColor=\#d5e8d4;strokeColor=\#82b366;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="1265" width="960" height="55" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc16\_ref\_txt" value="«include» UC-15 — Evaluar y Actualizar Categoría Comercial(idCliente)" style="text;html=1;align=center;verticalAlign=middle;fontStyle=1;fontSize=12;" vertex="1" parent="1"\>

          \<mxGeometry x="250" y="1280" width="700" height="25" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc16\_alt" value="alt" style="shape=umlFrame;whiteSpace=wrap;html=1;width=60;height=24;boundedLbl=1;verticalAlign=middle;align=left;spacingLeft=5;fillColor=\#f5f5f5;strokeColor=\#666666;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="100" y="1340" width="1020" height="270" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc16\_g1" value="\[Categoría determinada en UC-15, PoliticaCategoriaComercial vigente válida y subtotalBaseLuegoPromocion \>= 0\]" style="text;html=1;align=left;verticalAlign=middle;fontStyle=2;fontSize=11;" vertex="1" parent="1"\>

          \<mxGeometry x="170" y="1342" width="780" height="22" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc16\_r1" value="1.1: Resumen comercial congelado (categoriaComercialAplicada, versionPolitica, tipoAjuste DESCUENTO\|RECARGO\|SIN\_AJUSTE, porcentajeAjuste, importeAjuste, totalOriginal)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endSize=8;" edge="1" parent="1" source="uc16\_sys" target="uc16\_act"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="990" y="1430" as="sourcePoint" /\>

            \<mxPoint x="205" y="1430" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="uc16\_div" value="" style="line;strokeWidth=1;dashed=1;html=1;strokeColor=\#666666;" vertex="1" parent="1"\>

          \<mxGeometry x="100" y="1475" width="1020" height="10" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc16\_g2" value="\[A1 Sin PoliticaCategoriaComercial vigente o fallo en UC-15 \| A2 subtotalBaseLuegoPromocion \< 0 o porcentaje inválido\]" style="text;html=1;align=left;verticalAlign=middle;fontStyle=2;fontSize=11;" vertex="1" parent="1"\>

          \<mxGeometry x="170" y="1485" width="800" height="22" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="uc16\_r2" value="1.2: Rechazo del cálculo comercial sin inventar porcentajes ni confirmar el Pedido" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endSize=8;strokeColor=\#b85450;" edge="1" parent="1" source="uc16\_sys" target="uc16\_act"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="990" y="1560" as="sourcePoint" /\>

            \<mxPoint x="205" y="1560" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="uc16\_note" value="Reglas aprobadas (UC-16 / RD-RP023-001):&\#xa;• Para INTERNO (UC-03) aplica sobre el subtotal base; para ONLINE (UC-21) aplica sobre el subtotal posterior a la mejor Promoción elegible sin acumulación.&\#xa;• Conserva intactos los precioUnitario de cada Detalle.&\#xa;• No se vuelve a ejecutar en reasignación de excedentes (UC-07)." style="shape=note;whiteSpace=wrap;html=1;size=14;verticalAlign=top;align=left;spacingLeft=6;fillColor=\#fff2cc;strokeColor=\#d6b656;fontSize=11;" vertex="1" parent="1"\>

          \<mxGeometry x="1150" y="1340" width="380" height="170" as="geometry" /\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

\</mxfile\>

A continuación se presenta el desarrollo íntegro y balanceado del **Archivo 3: docs/08-diagramas/revision/DS\_REV06B1\_CLIENTES\_CATEGORIA\_UC02\_15\_16\_32\_33\_38\_57.drawio.xml** correspondiente al sublote **REV-06B.1 — Clientes y Categoría Comercial (UC-02, UC-33, UC-32, UC-38, UC-57, UC-15, UC-16)**.

### **Resumen de Homologación Triple (M-3 / H05) y Visibilidad de Larman (M-6) en el Archivo 3**

1. **Página 1 — DS UC-02: Registrar Cliente:** Homologa el mensaje 1: idCliente \= registrarCliente(nombre: String, telefonoPrincipal: String, direccion: DireccionDTO, zona: String, diaHabitualReparto: Short\[0..1\], observacion: String\[0..1\]), verificando duplicados exactos (nombreNormalizado \+ telefonoPrincipal) sobre clientes activos e inactivos (derivando la reactivación de clientes INACTIVO al Administrador vía UC-38) e instanciando nuevoCliente : Cliente con estado \= ACTIVO y categoriaComercial \= CUMPLIDOR.  
2. **Página 2 — DS UC-33: Buscar Cliente:** Homologa el mensaje 1: clientes \= buscarCliente(idCliente: Long\[0..1\], nombre: String\[0..1\], telefonoPrincipal: String\[0..1\], zona: String\[0..1\], estado: String\[0..1\]) en modo solo lectura para Vendedor / Administrador.  
3. **Página 3 — DS UC-32: Modificar Cliente («include» UC-33):** Homologa el mensaje 1: ok \= modificarCliente(idCliente: Long, nuevosDatos: DatosClienteDTO), incluyendo el marco ref a UC-33, validando duplicados excluyendo al propio cliente e invalidando los desafíos OTP pendientes vinculados al teléfono anterior cuando cambia telefonoPrincipal, sin revocar sesiones ONLINE ya activas ni permitir cambios de estado.  
4. **Página 4 — DS UC-38: Cambiar Estado de Cliente («include» UC-33):** Homologa el mensaje 1: ok \= cambiarEstadoCliente(idCliente: Long, nuevoEstado: String, motivo: String\[0..1\]) exclusivo del Administrador, incluyendo UC-33 y preservando los Pedido en estado PENDIENTE, la deuda y los cobros de regularización cuando el cliente pasa a INACTIVO (F09).  
5. **Página 5 — DS UC-57: Configurar Política de Categoría Comercial:** Homologa el mensaje 1: idPolitica \= configurarPoliticaCategoriaComercial(diasToleranciaMora: Integer, porcentajeDescuentoCumplidor: BigDecimal, porcentajeRecargoMora: BigDecimal, vigenteDesde: Timestamp, vigenteHasta: Timestamp\[0..1\]), validando diasToleranciaMora \>= 0, vigencias sin solapamientos y registrando PoliticaCategoriaComercial junto con sus dos configuraciones de AjustePoliticaCategoria (CUMPLIDOR y EN\_MORA) sin recalcular Pedidos anteriores.  
6. **Página 6 — DS UC-15: Evaluar y Actualizar Categoría Comercial:** Homologa el mensaje 1: categoriaVigente \= evaluarYActualizarCategoriaComercial(idCliente: Long), recuperando la política vigente (sin inventar umbrales hardcodeados), imputando pagos y créditos contra las deudas más antiguas (FIFO) en :LibroCuentaCorriente y asignando EN\_MORA únicamente cuando saldoDeudor \> 0 y antiguedadDeudaMasAntigua \> diasToleranciaMora (la igualdad no constituye mora).  
7. **Página 7 — DS UC-16: Aplicar Ajuste Comercial según Categoría («include» UC-15):** Homologa el mensaje 1: resultadoAjuste \= aplicarAjusteComercialSegunCategoria(idCliente: Long, subtotalBaseLuegoPromocion: BigDecimal), invocando UC-15, aplicando el ajuste (DESCUENTO, RECARGO o SIN\_AJUSTE) sobre la base comercial correspondiente (INTERNO subtotal base; ONLINE subtotal posterior a Promociones válidas) y congelándolo en unPedido : Pedido sin modificar los precioUnitario de cada detalle.

### **Archivo 3: docs/08-diagramas/revision/DS\_REV06B1\_CLIENTES\_CATEGORIA\_UC02\_15\_16\_32\_33\_38\_57.drawio.xml**

XML

\<mxfile host="app.diagrams.net" modified="2026-10-29T04:05:00.000Z" agent="5.0 (Windows)" version="24.7.17" type="device"\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 1: DS UC-02 REGISTRAR CLIENTE                                      \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id="ds-rev06b1-uc02" name="DS UC-02 Registrar Cliente (REV06B1)"\>

    \<mxGraphModel dx="1550" dy="850" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1550" pageHeight="920" math="0" shadow="0"\>

      \<root\>

        \<mxCell id="0" /\>

        \<mxCell id="1" parent="0" /\>

        \<mxCell id="u02\_title" value="Diagrama de Secuencia de Diseño (DS — REV06B1) — UC-02: Registrar Cliente (Homologado con Contrato 1 de REV-06B)" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="45" y="15" width="1150" height="30" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u02\_actor" value="Vendedor /&\#xa;Administrador" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="85" y="60" width="30" height="60" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u02\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="94" y="155" width="12" height="690" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u02\_ctrl\_box" value=":ControladorClientes" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="380" y="60" width="170" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u02\_ctrl\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1" source="u02\_ctrl\_bar" target="u02\_ctrl\_box"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="465" y="870" as="sourcePoint" /\>

            \<mxPoint x="465" y="105" as="targetPoint" /\>

          \</mxGeometry\>
        \</mxCell\>

        \<mxCell id="u02\_ctrl\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="459" y="155" width="12" height="690" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u02\_cat\_box" value=":CatalogoClientes" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="780" y="60" width="170" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u02\_cat\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1" source="u02\_cat\_bar" target="u02\_cat\_box"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="865" y="870" as="sourcePoint" /\>

            \<mxPoint x="865" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u02\_cat\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="859" y="210" width="12" height="390" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u02\_cli\_box" value="nuevoCliente : Cliente" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1180" y="410" width="180" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u02\_cli\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1" source="u02\_cli\_bar" target="u02\_cli\_box"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1270" y="870" as="sourcePoint" /\>

            \<mxPoint x="1270" y="455" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u02\_cli\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1264" y="455" width="12" height="75" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u02\_m1" value="1: idCliente \= registrarCliente(nombre: String, telefonoPrincipal: String, direccion: DireccionDTO, zona: String, diaHabitualReparto: Short\[0..1\], observacion: String\[0..1\])" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1" source="u02\_actor\_bar" target="u02\_ctrl\_bar"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="106" y="185" as="sourcePoint" /\>

            \<mxPoint x="459" y="185" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u02\_m2" value="2: controlDup \= verificarDuplicadosActivosEInactivos(nombreNormalizado, telefonoNormalizado) \[Visibilidad por Atributo\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1" source="u02\_ctrl\_bar" target="u02\_cat\_bar"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="471" y="235" as="sourcePoint" /\>

            \<mxPoint x="859" y="235" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u02\_r2" value="2.1: controlDup (duplicadoExacto: Cliente\[0..1\], coincidenciaParcial: List\&lt;Cliente\&gt;)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1" source="u02\_cat\_bar" target="u02\_ctrl\_bar"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="859" y="290" as="sourcePoint" /\>

            \<mxPoint x="471" y="290" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u02\_alt" value="alt Validación de campos estructurados y control de duplicados en Clientes activos e inactivos \[UC-02\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=660;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="45" y="330" width="1440" height="485" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u02\_g1" value="\[Datos obligatorios válidos y duplicadoExacto \== null (coincidencia parcial solo advierte sin bloquear el alta)\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="355" width="760" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u02\_m3" value="3: «create» new(nombre, nombreNormalizado, telefonoPrincipal, direccion, zona, diaHabitualReparto, observacion, estado=ACTIVO, categoriaComercial=CUMPLIDOR) \[Creación Local\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1" source="u02\_ctrl\_bar" target="u02\_cli\_box"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="471" y="432" as="sourcePoint" /\>

            \<mxPoint x="1180" y="432" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u02\_m4" value="4: guardarNuevoCliente(nuevoCliente: Cliente, fechaHoraAlta) \[Atributo \+ Parámetro\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1" source="u02\_ctrl\_bar" target="u02\_cat\_bar"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="471" y="555" as="sourcePoint" /\>

            \<mxPoint x="859" y="555" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u02\_r1\_ok" value="4.1: confirma Cliente registrado (idCliente, estado=ACTIVO, categoriaComercial=CUMPLIDOR, fechaHoraAlta y advertencia si hubo homonimia/teléfono compartido)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1" source="u02\_ctrl\_bar" target="u02\_actor\_bar"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="459" y="630" as="sourcePoint" /\>

            \<mxPoint x="106" y="630" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u02\_div" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="45" y="680" as="sourcePoint" /\>

            \<mxPoint x="1485" y="680" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u02\_g2" value="\[Datos inválidos o duplicadoExacto \!= null (si el Cliente coincidente está INACTIVO, el Vendedor no reactiva y se deriva al Administrador vía UC-38)\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="690" width="980" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u02\_r1\_err" value="4.2: impide crear identidad duplicada mostrando el Cliente existente (o solicita corregir datos inválidos)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1" source="u02\_ctrl\_bar" target="u02\_actor\_bar"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="459" y="775" as="sourcePoint" /\>

            \<mxPoint x="106" y="775" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 2: DS UC-33 BUSCAR CLIENTE                                         \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id="ds-rev06b1-uc33" name="DS UC-33 Buscar Cliente (REV06B1)"\>

    \<mxGraphModel dx="1450" dy="800" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1400" pageHeight="820" math="0" shadow="0"\>

      \<root\>

        \<mxCell id="0" /\>

        \<mxCell id="1" parent="0" /\>

        \<mxCell id="u33\_title" value="Diagrama de Secuencia de Diseño (DS — REV06B1) — UC-33: Buscar Cliente (Homologado con Contrato 2 de REV-06B)" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="45" y="15" width="1100" height="30" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u33\_actor" value="Vendedor /&\#xa;Administrador" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="85" y="60" width="30" height="60" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u33\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="94" y="155" width="12" height="580" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u33\_ctrl\_box" value=":ControladorClientes" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="380" y="60" width="170" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u33\_ctrl\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1" source="u33\_ctrl\_bar" target="u33\_ctrl\_box"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="465" y="770" as="sourcePoint" /\>

            \<mxPoint x="465" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u33\_ctrl\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="459" y="155" width="12" height="580" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u33\_cat\_box" value=":CatalogoClientes" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="800" y="60" width="170" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u33\_cat\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1" source="u33\_cat\_bar" target="u33\_cat\_box"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="885" y="770" as="sourcePoint" /\>

            \<mxPoint x="885" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u33\_cat\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="879" y="210" width="12" height="140" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u33\_m1" value="1: clientes \= buscarCliente(idCliente: Long\[0..1\], nombre: String\[0..1\], telefonoPrincipal: String\[0..1\], zona: String\[0..1\], estado: String\[0..1\])" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1" source="u33\_actor\_bar" target="u33\_ctrl\_bar"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="106" y="190" as="sourcePoint" /\>

            \<mxPoint x="459" y="190" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u33\_m2" value="2: lista \= consultarClientesPorCriterios(idCliente, nombre, telefonoPrincipal, zona, estado) \[Visibilidad por Atributo\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1" source="u33\_ctrl\_bar" target="u33\_cat\_bar"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="471" y="240" as="sourcePoint" /\>

            \<mxPoint x="879" y="240" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u33\_r2" value="2.1: List\&lt;Cliente\&gt; (idCliente, nombre, telefonoPrincipal, direccion, zona, estado ACTIVO\|INACTIVO, categoriaComercial)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1" source="u33\_cat\_bar" target="u33\_ctrl\_bar"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="879" y="315" as="sourcePoint" /\>

            \<mxPoint x="471" y="315" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u33\_alt" value="alt Resultado de la búsqueda de Clientes en modo solo lectura \[UC-33\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=460;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="45" y="375" width="1240" height="320" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u33\_g1" value="\[Existen Clientes coincidentes con los criterios ingresados\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="400" width="460" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u33\_r1\_ok" value="3.1: presenta coincidencias diferenciables y devuelve el Cliente seleccionado al proceso invocante sin modificar registros" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1" source="u33\_ctrl\_bar" target="u33\_actor\_bar"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="459" y="475" as="sourcePoint" /\>

            \<mxPoint x="106" y="475" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u33\_div" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="45" y="545" as="sourcePoint" /\>

            \<mxPoint x="1285" y="545" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u33\_g2" value="\[Sin coincidencias o criterios inválidos\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="555" width="420" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u33\_r1\_empty" value="3.2: informa ausencia de coincidencias sin alterar datos" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1" source="u33\_ctrl\_bar" target="u33\_actor\_bar"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="459" y="645" as="sourcePoint" /\>

            \<mxPoint x="106" y="645" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 3: DS UC-32 MODIFICAR CLIENTE («include» UC-33)                    \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id="ds-rev06b1-uc32" name="DS UC-32 Modificar Cliente (REV06B1)"\>

    \<mxGraphModel dx="1550" dy="880" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1550" pageHeight="960" math="0" shadow="0"\>

      \<root\>

        \<mxCell id="0" /\>

        \<mxCell id="1" parent="0" /\>

        \<mxCell id="u32\_title" value="Diagrama de Secuencia de Diseño (DS — REV06B1) — UC-32: Modificar Cliente («include» UC-33) (Homologado con Contrato 3 de REV-06B)" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="45" y="15" width="1250" height="30" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u32\_actor" value="Vendedor&\#xa;(Autorizado)" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="85" y="60" width="30" height="60" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u32\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="94" y="155" width="12" height="740" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u32\_ctrl\_box" value=":ControladorClientes" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="380" y="60" width="170" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u32\_ctrl\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1" source="u32\_ctrl\_bar" target="u32\_ctrl\_box"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="465" y="920" as="sourcePoint" /\>

            \<mxPoint x="465" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u32\_ctrl\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="459" y="155" width="12" height="740" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u32\_cat\_box" value=":CatalogoClientes" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="780" y="60" width="170" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u32\_cat\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1" source="u32\_cat\_bar" target="u32\_cat\_box"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="865" y="920" as="sourcePoint" /\>

            \<mxPoint x="865" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u32\_cat\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="859" y="280" width="12" height="390" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u32\_cli\_box" value="unCliente : Cliente" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1160" y="60" width="170" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u32\_cli\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1" source="u32\_cli\_bar" target="u32\_cli\_box"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1245" y="920" as="sourcePoint" /\>

            \<mxPoint x="1245" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u32\_cli\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1239" y="455" width="12" height="90" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u32\_ref33" value="ref «include» UC-33 Buscar Cliente (localiza y selecciona el Cliente cuyos datos vigentes se actualizarán)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=260;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="65" y="165" width="840" height="55" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u32\_m1" value="1: ok \= modificarCliente(idCliente: Long, nuevosDatos: DatosClienteDTO)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1" source="u32\_actor\_bar" target="u32\_ctrl\_bar"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="106" y="260" as="sourcePoint" /\>

            \<mxPoint x="459" y="260" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u32\_m2" value="2: (unCliente, dupExacto) \= obtenerYVerificarDuplicadoExcluyendoPropio(idCliente, nombreNorm, telNorm) \[Atributo\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1" source="u32\_ctrl\_bar" target="u32\_cat\_bar"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="471" y="305" as="sourcePoint" /\>

            \<mxPoint x="859" y="305" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u32\_r2" value="2.1: unCliente : Cliente, dupExacto : Cliente\[0..1\]" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1" source="u32\_cat\_bar" target="u32\_ctrl\_bar"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="859" y="355" as="sourcePoint" /\>

            \<mxPoint x="471" y="355" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u32\_alt" value="alt Validación de datos permitidos (el Vendedor no modifica estado ni categoría) y control de duplicados \[UC-32\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=720;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="45" y="390" width="1440" height="480" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u32\_g1" value="\[Datos válidos, dupExacto \== null y no se intenta alterar estado ni categoriaComercial\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="415" width="660" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u32\_m3" value="3: cambioTelefono \= actualizarDatosPermitidos(nuevosDatos: DatosClienteDTO) \[Visibilidad por Variable Local\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1" source="u32\_ctrl\_bar" target="u32\_cli\_bar"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="471" y="480" as="sourcePoint" /\>

            \<mxPoint x="1239" y="480" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u32\_opt" value="opt \[cambioTelefono \== true (se modificó telefonoPrincipal)\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=380;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="420" y="555" width="640" height="95" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u32\_m4" value="4: invalidarDesafiosOTPPendientes(idCliente, telefonoAnterior) \[Atributo — preserva sesiones ONLINE activas\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1" source="u32\_ctrl\_bar" target="u32\_cat\_bar"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="471" y="615" as="sourcePoint" /\>

            \<mxPoint x="859" y="615" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u32\_r1\_ok" value="4.1: confirma modificación de datos vigentes para futuras operaciones sin alterar registros históricos" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1" source="u32\_ctrl\_bar" target="u32\_actor\_bar"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="459" y="695" as="sourcePoint" /\>

            \<mxPoint x="106" y="695" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u32\_div" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="45" y="740" as="sourcePoint" /\>

            \<mxPoint x="1485" y="740" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u32\_g2" value="\[Sin selección en UC-33, datos inválidos, duplicado exacto con otro Cliente o cancelación/error\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="750" width="680" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u32\_r1\_err" value="4.2: rechaza modificación o solicita corrección conservando íntegramente los datos anteriores" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1" source="u32\_ctrl\_bar" target="u32\_actor\_bar"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="459" y="835" as="sourcePoint" /\>

            \<mxPoint x="106" y="835" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 4: DS UC-38 CAMBIAR ESTADO DE CLIENTE («include» UC-33)            \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id="ds-rev06b1-uc38" name="DS UC-38 Cambiar Estado de Cliente (REV06B1)"\>

    \<mxGraphModel dx="1550" dy="880" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1550" pageHeight="960" math="0" shadow="0"\>

      \<root\>

        \<mxCell id="0" /\>

        \<mxCell id="1" parent="0" /\>

        \<mxCell id="u38\_title" value="Diagrama de Secuencia de Diseño (DS — REV06B1) — UC-38: Cambiar Estado de Cliente («include» UC-33) (Homologado con Contrato 4)" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="45" y="15" width="1280" height="30" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u38\_actor" value="Administrador" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="85" y="60" width="30" height="60" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u38\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="94" y="155" width="12" height="740" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u38\_ctrl\_box" value=":ControladorClientes" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="380" y="60" width="170" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u38\_ctrl\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1" source="u38\_ctrl\_bar" target="u38\_ctrl\_box"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="465" y="920" as="sourcePoint" /\>

            \<mxPoint x="465" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u38\_ctrl\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="459" y="155" width="12" height="740" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u38\_cat\_box" value=":CatalogoClientes" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="780" y="60" width="170" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u38\_cat\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1" source="u38\_cat\_bar" target="u38\_cat\_box"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="865" y="920" as="sourcePoint" /\>

            \<mxPoint x="865" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u38\_cat\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="859" y="280" width="12" height="390" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u38\_cli\_box" value="unCliente : Cliente" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1160" y="60" width="170" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u38\_cli\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1" source="u38\_cli\_bar" target="u38\_cli\_box"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1245" y="920" as="sourcePoint" /\>

            \<mxPoint x="1245" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u38\_cli\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1239" y="455" width="12" height="90" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u38\_ref33" value="ref «include» UC-33 Buscar Cliente (localiza y selecciona al Cliente ACTIVO o INACTIVO)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=260;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="65" y="165" width="840" height="55" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u38\_m1" value="1: ok \= cambiarEstadoCliente(idCliente: Long, nuevoEstado: String, motivo: String\[0..1\])" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1" source="u38\_actor\_bar" target="u38\_ctrl\_bar"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="106" y="260" as="sourcePoint" /\>

            \<mxPoint x="459" y="260" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u38\_m2" value="2: unCliente \= obtenerPorIdParaActualizacion(idCliente: Long) \[Visibilidad por Atributo\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1" source="u38\_ctrl\_bar" target="u38\_cat\_bar"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="471" y="305" as="sourcePoint" /\>

            \<mxPoint x="859" y="305" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u38\_r2" value="2.1: unCliente : Cliente (estado actual ACTIVO \| INACTIVO y consecuencias operativas)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1" source="u38\_cat\_bar" target="u38\_ctrl\_bar"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="859" y="355" as="sourcePoint" /\>

            \<mxPoint x="471" y="355" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u38\_alt" value="alt Verificación de transición de estado admisible y conservación de operaciones previas \[UC-38 — F09\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=690;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="45" y="390" width="1440" height="480" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u38\_g1" value="\[unCliente \!= null y unCliente.estado \!= nuevoEstado (ACTIVO \&lt;-\&gt; INACTIVO)\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="415" width="580" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u38\_m3" value="3: cambiarEstadoComercial(nuevoEstado: String, motivo: String\[0..1\]) \[Visibilidad por Variable Local\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1" source="u38\_ctrl\_bar" target="u38\_cli\_bar"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="471" y="480" as="sourcePoint" /\>

            \<mxPoint x="1239" y="480" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u38\_opt" value="opt \[nuevoEstado \== 'INACTIVO'\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=250;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="420" y="555" width="640" height="95" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u38\_m4" value="4: revocarDesafiosYSesionesOnline(idCliente) \[Impide nuevos Pedidos/Promociones/Excedentes; conserva Pedidos PENDIENTE y deuda\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1" source="u38\_ctrl\_bar" target="u38\_cat\_bar"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="471" y="615" as="sourcePoint" /\>

            \<mxPoint x="859" y="615" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u38\_r1\_ok" value="4.1: confirma nuevo estado y trazabilidad preservando Pedidos previos, Cobros y Cuenta Corriente" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1" source="u38\_ctrl\_bar" target="u38\_actor\_bar"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="459" y="695" as="sourcePoint" /\>

            \<mxPoint x="106" y="695" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u38\_div" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="45" y="740" as="sourcePoint" /\>

            \<mxPoint x="1485" y="740" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u38\_g2" value="\[Sin Cliente seleccionado en UC-33, estado redundante (ya posee nuevoEstado) o cancelación/falla\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="750" width="680" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u38\_r1\_err" value="4.2: evita cambio redundante o conserva el estado anterior sin alterar historial" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1" source="u38\_ctrl\_bar" target="u38\_actor\_bar"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="459" y="835" as="sourcePoint" /\>

            \<mxPoint x="106" y="835" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 5: DS UC-57 CONFIGURAR POLÍTICA DE CATEGORÍA COMERCIAL             \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id="ds-rev06b1-uc57" name="DS UC-57 Configurar Política Categoría (REV06B1)"\>

    \<mxGraphModel dx="1550" dy="850" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1550" pageHeight="920" math="0" shadow="0"\>

      \<root\>

        \<mxCell id="0" /\>

        \<mxCell id="1" parent="0" /\>

        \<mxCell id="u57\_title" value="Diagrama de Secuencia de Diseño (DS — REV06B1) — UC-57: Configurar Política de Categoría Comercial (Homologado con Contrato 5)" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="45" y="15" width="1280" height="30" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u57\_actor" value="Administrador" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="85" y="60" width="30" height="60" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u57\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="94" y="155" width="12" height="690" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u57\_ctrl\_box" value=":ControladorClientes" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="380" y="60" width="170" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u57\_ctrl\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1" source="u57\_ctrl\_bar" target="u57\_ctrl\_box"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="465" y="870" as="sourcePoint" /\>

            \<mxPoint x="465" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u57\_ctrl\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="459" y="155" width="12" height="690" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u57\_repo\_box" value=":RepositorioPoliticaComercial" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="770" y="60" width="190" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u57\_repo\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1" source="u57\_repo\_bar" target="u57\_repo\_box"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="865" y="870" as="sourcePoint" /\>

            \<mxPoint x="865" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u57\_repo\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="859" y="210" width="12" height="390" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u57\_pol\_box" value="nuevaPol : PoliticaCategoriaComercial&\#xa;(+ 2 AjustePoliticaCategoria)" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1160" y="410" width="230" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u57\_pol\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1" source="u57\_pol\_bar" target="u57\_pol\_box"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1275" y="870" as="sourcePoint" /\>

            \<mxPoint x="1275" y="455" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u57\_pol\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1269" y="455" width="12" height="75" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u57\_m1" value="1: idPolitica \= configurarPoliticaCategoriaComercial(diasToleranciaMora: Integer, porcentajeDescuentoCumplidor: BigDecimal, porcentajeRecargoMora: BigDecimal, vigenteDesde: Timestamp, vigenteHasta: Timestamp\[0..1\])" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1" source="u57\_actor\_bar" target="u57\_ctrl\_bar"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="106" y="185" as="sourcePoint" /\>

            \<mxPoint x="459" y="185" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u57\_m2" value="2: sinSolapamiento \= verificarContinuidadTemporalSinSuperposicion(vigenteDesde, vigenteHasta) \[Visibilidad por Atributo\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1" source="u57\_ctrl\_bar" target="u57\_repo\_bar"\>
          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="471" y="235" as="sourcePoint" /\>

            \<mxPoint x="859" y="235" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u57\_r2" value="2.1: sinSolapamiento : Boolean (y referencia a política precedente si requiere cierre prospectivo)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1" source="u57\_repo\_bar" target="u57\_ctrl\_bar"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="859" y="290" as="sourcePoint" /\>

            \<mxPoint x="471" y="290" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u57\_alt" value="alt Validación de diasToleranciaMora \&gt;= 0, ajustes de CUMPLIDOR y EN\_MORA y vigencias sin superposición \[UC-57\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=730;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="45" y="330" width="1440" height="485" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u57\_g1" value="\[diasToleranciaMora \&gt;= 0, ambos ajustes válidos en \[0..100\] (CUMPLIDOR y EN\_MORA) y sinSolapamiento \== true\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="355" width="760" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u57\_m3" value="3: «create» new(diasToleranciaMora, ajusteCumplidor, ajusteEnMora, vigenteDesde, vigenteHasta, idUsuarioRegistro) \[Creación Local\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1" source="u57\_ctrl\_bar" target="u57\_pol\_box"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="471" y="432" as="sourcePoint" /\>

            \<mxPoint x="1160" y="432" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u57\_m4" value="4: registrarPoliticaYAjustesCerrandoVigenciaPrevia(nuevaPol: PoliticaCategoriaComercial) \[Atributo \+ Parámetro\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1" source="u57\_ctrl\_bar" target="u57\_repo\_bar"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="471" y="555" as="sourcePoint" /\>

            \<mxPoint x="859" y="555" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u57\_r1\_ok" value="4.1: informa idPolitica y vigencia resultante (sin recalcular categorías ni importes congelados en Pedidos históricos)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1" source="u57\_ctrl\_bar" target="u57\_actor\_bar"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="459" y="630" as="sourcePoint" /\>

            \<mxPoint x="106" y="630" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u57\_div" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="45" y="680" as="sourcePoint" /\>

            \<mxPoint x="1485" y="680" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u57\_g2" value="\[A1..A6: Sin autorización, diasToleranciaMora \&lt; 0, combinación tipo/porcentaje inválida, conflicto temporal o falla transaccional\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="690" width="840" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u57\_r1\_err" value="4.2: impide el registro y conserva íntegramente las políticas previas" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1" source="u57\_ctrl\_bar" target="u57\_actor\_bar"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="459" y="775" as="sourcePoint" /\>

            \<mxPoint x="106" y="775" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 6: DS UC-15 EVALUAR Y ACTUALIZAR CATEGORÍA COMERCIAL               \--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id="ds-rev06b1-uc15" name="DS UC-15 Evaluar Categoría Comercial (REV06B1)"\>

    \<mxGraphModel dx="1650" dy="900" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1650" pageHeight="980" math="0" shadow="0"\>

      \<root\>

        \<mxCell id="0" /\>

        \<mxCell id="1" parent="0" /\>

        \<mxCell id="u15\_title" value="Diagrama de Secuencia de Diseño (DS — REV06B1) — UC-15: Evaluar y Actualizar Categoría Comercial (Homologado con Contrato 6)" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="45" y="15" width="1280" height="30" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u15\_actor" value="Sistema&\#xa;(UC-05/26/29/49/16)" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="85" y="60" width="30" height="60" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u15\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="94" y="155" width="12" height="750" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u15\_ctrl\_box" value=":ControladorClientes" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="340" y="60" width="170" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u15\_ctrl\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1" source="u15\_ctrl\_bar" target="u15\_ctrl\_box"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="425" y="930" as="sourcePoint" /\>

            \<mxPoint x="425" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u15\_ctrl\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="419" y="155" width="12" height="750" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u15\_repo\_box" value=":RepositorioPoliticaComercial&\#xa;/ polVigente : Politica" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="660" y="60" width="195" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u15\_repo\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1" source="u15\_repo\_bar" target="u15\_repo\_box"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="757" y="930" as="sourcePoint" /\>

            \<mxPoint x="757" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u15\_repo\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="751" y="210" width="12" height="340" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u15\_cc\_box" value=":LibroCuentaCorriente" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="990" y="60" width="175" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u15\_cc\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1" source="u15\_cc\_bar" target="u15\_cc\_box"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1077" y="930" as="sourcePoint" /\>

            \<mxPoint x="1077" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u15\_cc\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1071" y="385" width="12" height="90" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u15\_cli\_box" value="unCliente : Cliente" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1310" y="60" width="170" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u15\_cli\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1" source="u15\_cli\_bar" target="u15\_cli\_box"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1395" y="930" as="sourcePoint" /\>

            \<mxPoint x="1395" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u15\_cli\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1389" y="600" width="12" height="75" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u15\_m1" value="1: categoriaVigente \= evaluarYActualizarCategoriaComercial(idCliente: Long)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1" source="u15\_actor\_bar" target="u15\_ctrl\_bar"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="106" y="185" as="sourcePoint" /\>

            \<mxPoint x="419" y="185" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u15\_m2" value="2: polVigente \= obtenerPoliticaVigente(fechaHoraEvaluacion) \[Visibilidad por Atributo\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1" source="u15\_ctrl\_bar" target="u15\_repo\_bar"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="431" y="235" as="sourcePoint" /\>

            \<mxPoint x="751" y="235" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u15\_r2" value="2.1: polVigente : PoliticaCategoriaComercial\[0..1\] (diasToleranciaMora)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1" source="u15\_repo\_bar" target="u15\_ctrl\_bar"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="751" y="285" as="sourcePoint" /\>

            \<mxPoint x="431" y="285" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u15\_alt" value="alt Evaluación con Política de Categoría Comercial vigente e imputación FIFO de deuda \[UC-15\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=630;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="45" y="325" width="1540" height="555" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u15\_g1" value="\[polVigente \!= null (no se inventan umbrales hardcodeados)\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="350" width="520" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u15\_m3" value="3: (saldoDeudor, antiguedadDias) \= calcularAntiguedadDeudaImpagaMasAntiguaFIFO(idCliente, fechaEval) \[Atributo \+ Parámetro\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1" source="u15\_ctrl\_bar" target="u15\_cc\_bar"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="431" y="405" as="sourcePoint" /\>

            \<mxPoint x="1071" y="405" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u15\_r3" value="3.1: saldoDeudor efectivo y antiguedadDeudaMasAntigua (pagos y créditos imputados primero a deudas más antiguas)" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1" source="u15\_cc\_bar" target="u15\_ctrl\_bar"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1071" y="455" as="sourcePoint" /\>

            \<mxPoint x="431" y="455" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u15\_m4" value="4: categoriaCalculada \= determinarCategoria(saldoDeudor, antiguedadDias) \[saldoDeudor \&gt; 0 \&amp;\&amp; antiguedadDias \&gt; diasToleranciaMora \=\&gt; EN\_MORA; sino CUMPLIDOR\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1" source="u15\_ctrl\_bar" target="u15\_repo\_bar"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="431" y="515" as="sourcePoint" /\>

            \<mxPoint x="751" y="515" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u15\_opt" value="opt \[categoriaCalculada \!= unCliente.categoriaComercial (evita cambio artificial si coinciden)\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=560;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="380" y="570" width="1120" height="115" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u15\_m5" value="5: actualizarCategoriaComercialYTrazabilidad(categoriaCalculada, fechaEval) \[Visibilidad por Variable Local\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1" source="u15\_ctrl\_bar" target="u15\_cli\_bar"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="431" y="635" as="sourcePoint" /\>

            \<mxPoint x="1389" y="635" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u15\_r1\_ok" value="5.1: deja disponible categoriaVigente (CUMPLIDOR \| EN\_MORA) y datos utilizados en la evaluación" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1" source="u15\_ctrl\_bar" target="u15\_actor\_bar"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="419" y="725" as="sourcePoint" /\>

            \<mxPoint x="106" y="725" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u15\_div" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="45" y="765" as="sourcePoint" /\>

            \<mxPoint x="1585" y="765" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u15\_g2" value="\[polVigente \== null y la evaluación requiere sus parámetros\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="775" width="520" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u15\_r1\_err" value="5.2: informa/registra inconsistencia de configuración sin inventar valores ni umbrales hardcodeados" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1" source="u15\_ctrl\_bar" target="u15\_actor\_bar"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="419" y="845" as="sourcePoint" /\>

            \<mxPoint x="106" y="845" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

  \<\!-- \========================================================================= \--\>

  \<\!-- PÁGINA 7: DS UC-16 APLICAR AJUSTE COMERCIAL SEGÚN CATEGORÍA («include» 15)--\>

  \<\!-- \========================================================================= \--\>

  \<diagram id="ds-rev06b1-uc16" name="DS UC-16 Aplicar Ajuste Comercial (REV06B1)"\>

    \<mxGraphModel dx="1550" dy="880" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1550" pageHeight="960" math="0" shadow="0"\>

      \<root\>

        \<mxCell id="0" /\>

        \<mxCell id="1" parent="0" /\>

        \<mxCell id="u16\_title" value="Diagrama de Secuencia de Diseño (DS — REV06B1) — UC-16: Aplicar Ajuste Comercial según Categoría («include» UC-15) (Contrato 7)" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;fontSize=14;fontStyle=1" vertex="1" parent="1"\>

          \<mxGeometry x="45" y="15" width="1300" height="30" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u16\_actor" value="Sistema&\#xa;(UC-03 / UC-21)" style="shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="85" y="60" width="30" height="60" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u16\_actor\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="94" y="155" width="12" height="740" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u16\_ctrl\_box" value=":ControladorClientes" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="380" y="60" width="170" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u16\_ctrl\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1" source="u16\_ctrl\_bar" target="u16\_ctrl\_box"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="465" y="920" as="sourcePoint" /\>

            \<mxPoint x="465" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u16\_ctrl\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="459" y="155" width="12" height="740" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u16\_repo\_box" value=":RepositorioPoliticaComercial&\#xa;/ polVigente : Politica" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="770" y="60" width="195" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u16\_repo\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1" source="u16\_repo\_bar" target="u16\_repo\_box"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="867" y="920" as="sourcePoint" /\>

            \<mxPoint x="867" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u16\_repo\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="861" y="290" width="12" height="240" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u16\_ped\_box" value="unPedido : Pedido" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1170" y="60" width="170" height="45" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u16\_ped\_line" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1" source="u16\_ped\_bar" target="u16\_ped\_box"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="1255" y="920" as="sourcePoint" /\>

            \<mxPoint x="1255" y="105" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u16\_ped\_bar" value="" style="rounded=0;whiteSpace=wrap;html=1;fillColor=\#7FD6FF;strokeColor=\#000000;" vertex="1" parent="1"\>

          \<mxGeometry x="1249" y="555" width="12" height="90" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u16\_m1" value="1: resultadoAjuste \= aplicarAjusteComercialSegunCategoria(idCliente: Long, subtotalBaseLuegoPromocion: BigDecimal)" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1" source="u16\_actor\_bar" target="u16\_ctrl\_bar"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="106" y="180" as="sourcePoint" /\>

            \<mxPoint x="459" y="180" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u16\_ref15" value="ref «include» UC-15 Evaluar y Actualizar Categoría Comercial (obtiene categoriaVigente \= CUMPLIDOR \| EN\_MORA)" style="shape=umlFrame;whiteSpace=wrap;html=1;width=280;height=22;fillColor=\#F5F5F5;strokeColor=\#000000;align=center;verticalAlign=middle;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="380" y="210" width="560" height="55" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u16\_m2" value="2: polVigente \= obtenerPoliticaVigente(fechaHoraCreacionPedido) \[Visibilidad por Atributo\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1" source="u16\_ctrl\_bar" target="u16\_repo\_bar"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="471" y="315" as="sourcePoint" /\>

            \<mxPoint x="861" y="315" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u16\_r2" value="2.1: polVigente : PoliticaCategoriaComercial\[0..1\] y ajuste configurado para categoriaVigente" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1" source="u16\_repo\_bar" target="u16\_ctrl\_bar"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="861" y="365" as="sourcePoint" /\>

            \<mxPoint x="471" y="365" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u16\_alt" value="alt Cálculo y congelamiento del ajuste comercial global sobre la base comercial S \[UC-16\]" style="shape=umlFrame;whiteSpace=wrap;html=1;width=610;height=22;fillColor=none;strokeColor=\#000000;align=left;verticalAlign=top;fontStyle=1;" vertex="1" parent="1"\>

          \<mxGeometry x="45" y="405" width="1440" height="465" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u16\_g1" value="\[categoriaVigente válida, polVigente \!= null y ajuste válido (DESCUENTO: S\*(1-p/100) \| RECARGO: S\*(1+p/100) \| SIN\_AJUSTE: S)\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="430" width="860" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u16\_m3" value="3: (tipoAjuste, porcentajeAjuste, totalResultante) \= calcularAjusteSegunCategoria(categoriaVigente, subtotalBaseLuegoPromocion) \[Variable Local\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1" source="u16\_ctrl\_bar" target="u16\_repo\_bar"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="471" y="495" as="sourcePoint" /\>

            \<mxPoint x="861" y="495" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u16\_m4" value="4: congelarAjusteCategoria(categoriaVigente, polVigente.idPolitica, tipoAjuste, porcentajeAjuste, totalResultante) \[Parámetro — sin alterar precioUnitario de Detalles\]" style="html=1;verticalAlign=bottom;endArrow=block;endFill=1;strokeColor=\#000000;" edge="1" parent="1" source="u16\_ctrl\_bar" target="u16\_ped\_bar"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="471" y="595" as="sourcePoint" /\>

            \<mxPoint x="1249" y="595" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u16\_r1\_ok" value="4.1: retorna categoría aplicada, política/versión, tipoAjuste, porcentajeAjuste y total definitivo congelado en el Pedido" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1" source="u16\_ctrl\_bar" target="u16\_actor\_bar"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="459" y="685" as="sourcePoint" /\>

            \<mxPoint x="106" y="685" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u16\_div" value="" style="endArrow=none;dashed=1;html=1;strokeColor=\#000000;" edge="1" parent="1"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="45" y="735" as="sourcePoint" /\>

            \<mxPoint x="1485" y="735" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

        \<mxCell id="u16\_g2" value="\[UC-15 no pudo determinar categoría, no existe política vigente o el porcentaje configurado es inválido\]" style="text;html=1;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;" vertex="1" parent="1"\>

          \<mxGeometry x="120" y="745" width="760" height="20" as="geometry" /\>

        \</mxCell\>

        \<mxCell id="u16\_r1\_err" value="4.2: informa inconsistencia de configuración sin usar porcentajes hardcodeados ni confirmar el ajuste comercial" style="html=1;verticalAlign=bottom;endArrow=open;dashed=1;endFill=0;strokeColor=\#000000;" edge="1" parent="1" source="u16\_ctrl\_bar" target="u16\_actor\_bar"\>

          \<mxGeometry relative="1" as="geometry"\>

            \<mxPoint x="459" y="830" as="sourcePoint" /\>

            \<mxPoint x="106" y="830" as="targetPoint" /\>

          \</mxGeometry\>

        \</mxCell\>

      \</root\>

    \</mxGraphModel\>

  \</diagram\>

\</mxfile\>
