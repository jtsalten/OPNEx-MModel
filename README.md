# OPNEx-MModel

Basic Samples - IRIS Multimodel capabilities

Esta demo básica pretende mostrar las capacidades multi-modelo de IRIS. Podremos definir clases y almacenar datos como objetos de dichas clases y ver los datos también desde un punto de vista relacional, desde SQL, tanto en servidor como desde clientes xDBC.

Igualmente mostrará como acceder a esos mismos datos en los globals o sparse arrays que son las estructuras últimas de almacenamiento de IRIS. Particularmente mostraremos como se puede definir, de un modo muy sencillo, un método en ObjectScript para ingestión masiva de información directamente a global.

## Punto de partida

Contaremos con un proyecto "Template", con parte de las clases ya creadas

- OPNex.MModel.Direccion: Clase tipo %SerialObject
- OPNEx.MModel.Proveedor: Clase tipo %Persistent que implementaremos durante la demo
- OPNEx.RESTServer: Clase para publicar servicios REST
- OPNEx.Util: Implementación del acceso directo al global asociado a la clase OPNEx.MModel.Proveedor y algunas utilidades

## Pasos

### Paso 1 - Acceso a Datos

#### Herencia de OPNEx.MModel.Proveedor

Hacemos que la clase herede de: (%Persistent, %Populate, %XML.Adaptor, %JSON.Adaptor)

#### Definimos las propiedades de la clase Proveedor

- Codigo - %Integer - [Identity]
- Descripcion - %String - (POPSPEC = "Company()")
- CIF - %String - (PATTERN="1A8N") - [InitialExpression={"B"_$random(9999)*10000+$random(9999)}]
- Direccion - OPNEx.MModel.Direccion

#### Compilar, Generar datos y mostrar acceso OO.OO, Relacional y Global

- **Desde el terminal:**
  - Generar con ##class(OPNEx.MModel.Proveedor).Populate(10)
  - Abrir un objeto, con:

    ```language=ObjectScript
    set obj = ##class(OPNEx.MModel.Proveedor).%OpenId(1)
    zw obj
    ```

- **Desde DBeaver:**
  - Conectar con NameSpace
  - Ejecutar SQL: select * from OPNEx_MModel.Proveedor
- **Desde Terminal - Acceso a global**
  - Ejecutar:

    ```language=ObjectScript
    zw ^OPNEx.MModel.ProveedorD
    ```

### Paso 2 - Lógica de Negocio

#### Propiedades Calculadas

- **Definir método Facturacion()** como método de clase el cálculo ficticio de facturacion - [ SqlName = FAC_GLOBAL, SqlProc ]
    return $random(999)_$random(999)
- **Definir nueva propiedad calculada** que utilice dicho método:
  - Facturacion - [ Calculated, SqlComputeCode = {set {*}=..FacturacionGlobal({ID})}, SqlComputed ]
- **Compilar y validar en DBeaver** que ya aparece la propiedad, y el procedimiento almacenado

#### Métodos de Registro

- **OO.OO - Clase OPNEx.MModel.Proveedor**
  - *Registro()*: Basicamente recogerá toda la información por parámetro, creará un objeto nuevo y lo salvará
  - *RegistroSQL()*: Misma firma que el anterior, pero hara una inserción con SQL Embebido.
  - *RegistroJSON()*: Recibe un %DynamicObject con los datos del proveedor a crear y utiliza el %JSONImport:

    ```language=ObjectScript
    return:('$IsObject(pDatos)||(pDatos.%ClassName()'="%DynamicObject")) 0
    #dim obj as OPNEx.MModel.Proveedor = ..%New()
    do obj.%JSONImport(pDatos)
    do obj.%Save()
    return obj.%Id()
    ```

  - *ActualizaJSON()*: Recibe un %DynamicObject de un proveedor y lo sobrescribe:

    ```language=ObjectScript
    return:('$IsObject(pDatos)||(pDatos.%ClassName()'="%DynamicObject")||(pDatos.Codigo<1)) 0
    #dim tSC as %Status = 0
    #dim tProv as OPNEx.MModel.Proveedor = ..%OpenId(pDatos.Codigo)
    if $IsObject(tProv)
    {
       do tProv.%JSONImport(pDatos)
       set tSC = tProv.%Save()
    }
    return tSC
    ```

- **Global - Clase OPNEx.MModel.Util**
  - Desde terminal, visualizar global y comentar estructura
  - Comentar métodos *InsGbl()* y *LeeGlb()*

#### Registro via SQL, via OO.OO, via Global

- **Inserción desde DBeaver**:

  ```language=SQL
  insert into OPNEx_MModel.Proveedor (Descripcion, CIF, Direccion_Ciudad, Direccion_CodPostal) values ('Proveedor SQL 001','B11122233','Huesca','48001')
  ```

- **Registro desde método Registro()**
- **Registro desde método RegistroJSON()**
- **Registro desde método InsGbl()**

### Paso 3 - Servicios REST

#### Configuración aplicación web

Previamente debe estar configurada en IRIS la aplicación web ``/multimodel``, con los siguientes criterios:

- **Servidor REST**: OPNEx.MModel.RESTserver
- **Acceso no autenticado**: el usuario será UnknownUser, por lo que:
  - Debemos asegurarnos de que el usuario tiene asignado el role: %ALL (o los permisos necesarios) o,
  - La aplicación web tiene asociado el role: %DB_DEFAULT, %DB_\<NAMESPACE>
- Hacer pruebas básicas haciendo un GET sobre el servicio Echo:

  ```language=HTTP
  GET http://localhost:52780/multimodel/echo
  ```

#### Implementación de Servicios

- **Registro()**
  - Las distintas rutas ya están definidas. Por cómo está definido, un mismo método podrá atender a todas las rutas ya que el que no se indiquen datos no provocará errores de validación.
  - El código es muy sencillo:

    ```language=ObjectScript
    #dim tID as %Integer = ##class(OPNEx.MModel.Proveedor).Registro(pDesc,pCIF,pCiudad,pCodPostal,pPais)
    write {"ID":(tID)}.%ToJSON()
    ```
  
- **RegistroJSON()**
  - Código:

    ```language=ObjectScript
    #dim tBulkJSON as %String = %request.Content.Read()	
    #dim tDatos as %DynamicObject = {}.%FromJSON(tBulkJSON)
    #dim tID as %Integer = ##class(OPNEx.MModel.Proveedor).RegistroJSON(tDatos)
    write {"ID":(tID)}.%ToJSON()
    ```

- **BuscaID()** - Busca el proveedor por ID
  - Código:

    ```language=ObjectScript
    set tProv = ##class(OPNEx.MModel.Proveedor).%OpenId(pID)
    if $IsObject(tProv)
    {
        write tProv.%JSONExport()
    }
    else
    {
        write {"ESTADO":"ERROR - ID indicado no existe"}.%ToJSON()
    }

    ```

- **EliminaID()** - Borrar el proveedor por ID
  - Código:

    ```language=ObjectScript
    set tSC = ##class(OPNEx.MModel.Proveedor).%DeleteId(pID)
    write {"ESTADO":(tSC),"ID":(pID)}.%ToJSON()
    ```
