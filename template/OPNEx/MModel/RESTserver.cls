Class OPNEx.MModel.RESTserver Extends %CSP.REST
{

Parameter CHARSET = "iso-8859-1";

Parameter CONTENTTYPE = "application/json";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/registro/:desc/:cif" Method="PUT" Call="Registro" Cors="true"/>
<Route Url="/registro/:desc/:cif/:ciudad" Method="PUT" Call="Registro" Cors="true"/>
<Route Url="/registro/:desc/:cif/:ciudad/:codpostal" Method="PUT" Call="Registro" Cors="true"/>
<Route Url="/registro/:desc/:cif/:ciudad/:codpostal/:pais" Method="PUT" Call="Registro" Cors="true"/>
<Route Url="/registro" Method="POST" Call="RegistroJSON" Cors="true"/>
<Route Url="/modifica" Method="PATCH" Call="ModificaJSON" Cors="true"/>
<Route Url="/busca/id/:id" Method="GET" Call="BuscaID" Cors="true"/>
<Route Url="/elimina/id/:id" Method="DELETE" Call="EliminaID" Cors="true"/>
<Route Url="/echo" Method="GET" Call="GetEcho" Cors="true"/>
<!--
	<Map Prefix="/docserver" Forward="%Api.v1.DocServer"/>
-->
</Routes>
}

/// Registra un nuevo proveedor según datos recibidos en la URL REST
ClassMethod Registro(pDesc As %String = "", pCIF As %String = "", pCiudad As %String = "", pCodPostal As %String = "", pPais As %String = "") As %Status
{
	// Utiliza los datos recibidos en la URL REST para llamar al método Registro de Proveedor y crear un proveedor nuevo
	// TBD
	
	// Devuelve el ID del nuevo proveedor - Retornado por Registro()
	// TBD  write...
	
	return $$$OK
}

/// Recibe los datos del nuevo proveedor recibido como documento JSON (para llamadas POST)
ClassMethod RegistroJSON() As %Status
{
	// Lee el documento JSON incluido en el body de la peticion REST
	#dim tBulkJSON as %String = %request.Content.Read()	
	// Genera el %DynamicObject con tBulkJSON
	// TBD  #dim tDatos...

	// Llama al método RegistroJSON de Proveedor para insertar el nuevo proveedor
	// TBD  #dim tID... 
	
	// Devuelve el ID del nuevo proveedor - Retornado por RegistroJSON()
	// TBD  write...

	return $$$OK
}

ClassMethod ModificaJSON() As %Status
{
	#dim tSC as %Status = 0

	// Lee el documento JSON incluido en el body de la peticion REST
	#dim tBulkJSON as %String = %request.Content.Read()	
	// Genera el %DynamicObject con tBulkJSON
	#dim tDatos as %DynamicObject = {}.%FromJSON(tBulkJSON)

	if $IsObject(tDatos)&&(tDatos.Codigo>1)
	{
		// Llama al método ModificaJSON de Proveedor para modificar el proveedor
		set tSC = ##class(OPNEx.MModel.Proveedor).ActualizaJSON(tDatos)
		// Devuelve el código de estado devuelto y el ID del proveedor 
		write {"ESTADO":(tSC),"ID":(tDatos.Codigo)}.%ToJSON()
	}
	else
	{
		// Devuelve el código de estado 0  
		write {"ESTADO":(tSC),"ID":"","DESC":"Algo ha ido mal"}.%ToJSON()
	}
	return $$$OK
}

/// Busca por ID
ClassMethod BuscaID(pID As %Integer = "") As %Status
{
	// Abre el proveedor cuyo ID nos han pasado por parámetro
	// TBD  set tProv ...

	// Si existe, devuelve sus datos en formato JSON, si no, un JSON con info del error
	if $IsObject(tProv)
	{
		// TBD  write... 
	}
	else
	{
		write {"ESTADO":"ERROR - ID indicado no existe"}.%ToJSON()
	}

	return $$$OK
}

/// Elimina por ID
ClassMethod EliminaID(pID As %Integer = "") As %Status
{
	// Elimina el proveedor cuyo ID nos han pasado por parámetro
	// TBD  set tSC ...

	// Devuelve el resultado del %DeleteId y el ID que le hayan pasado
	write {"ESTADO":(tSC),"ID":(pID)}.%ToJSON()

	return $$$OK
}

/// Metodo de test
ClassMethod GetEcho() As %Status
{
	write "Echotest"
	quit $$$OK
}

}
