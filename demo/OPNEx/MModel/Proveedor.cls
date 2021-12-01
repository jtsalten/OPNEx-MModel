/// Proveedores
/// 
/// TBD: Extender herencia para amplicar funcionalidad:  %Populate, %XML.Adaptor, %JSON.Adaptor
Class OPNEx.MModel.Proveedor Extends %Persistent
{

// Codigo

// Descripcion

// CIF As %String(PATTERN = "1A8N") [ InitialExpression = {"B"_($random(9999)*10000+$random(9999))} ];

// Direccion

// Facturacion As %Integer [ Calculated, SqlComputeCode = {set {*}=..FacturacionGlobal({ID})}, SqlComputed ];

ClassMethod Registro(pDesc As %String = "", pCIF As %String = "", pCiudad As %String = "", pCodPostal As %String = "", pPais As %String = "España") As %Integer
{
	#dim obj as OPNEx.MModel.Proveedor = ..%New() 

	// TBD

	do obj.%Save()
	
	return obj.%Id()
}

ClassMethod RegistroSQL(pDesc As %String = "", pCIF As %String = "", pCiudad As %String = "", pCodPostal As %String = "", pPais As %String = "España") As %Integer
{
	//&SQL()

	// TBD

	if SQLCODE = 0
	{
		&SQL(select LAST_IDENTITY() into :tID from OPNEx_MModel.Proveedor)
	}
	return:SQLCODE=0 tID

	return SQLCODE
}

ClassMethod RegistroJSON(pDatos As %DynamicObject) As %Integer
{
	return:('$IsObject(pDatos)||(pDatos.%ClassName()'="%DynamicObject")) 0

	#dim obj as OPNEx.MModel.Proveedor = ..%New()	

	// TBD - import JSON

	do obj.%Save()
	
	return obj.%Id()
}

ClassMethod ActualizaJSON(pDatos As %DynamicObject) As %Status
{
	return:('$IsObject(pDatos)||(pDatos.%ClassName()'="%DynamicObject")||(pDatos.Codigo<1)) 0

	#dim tSC as %Status = 0
	#dim tProv as OPNEx.MModel.Proveedor = ..%OpenId(pDatos.Codigo)

	if $IsObject(tProv)
	{
		// TBD - import JSON

		//set tSC = tProv.%Save()
	}

	return tSC
}

ClassMethod FacturacionGlobal(pID As %Integer) As %Integer
{
	// Calcularía una información X
	
	// TBD - proyectar como Stored Proc y return random
	return 0
}

Storage Default
{
<Data name="ProveedorDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Descripcion</Value>
</Value>
<Value name="3">
<Value>CIF</Value>
</Value>
<Value name="4">
<Value>Direccion</Value>
</Value>
</Data>
<DataLocation>^OPNEx.MModel.ProveedorD</DataLocation>
<DefaultData>ProveedorDefaultData</DefaultData>
<ExtentSize>8</ExtentSize>
<IdLocation>^OPNEx.MModel.ProveedorD</IdLocation>
<IndexLocation>^OPNEx.MModel.ProveedorI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>2</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="CIF">
<AverageFieldSize>11</AverageFieldSize>
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="Codigo">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="Descripcion">
<AverageFieldSize>21.38</AverageFieldSize>
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="Direccion">
<AverageFieldSize>23.25,Ciudad:9,CodPostal:4.25,Pais:8</AverageFieldSize>
<Selectivity>12.5000%,Ciudad:14.2857%,CodPostal:12.5000%,Pais:100.0000%</Selectivity>
</Property>
<Property name="Facturacion">
<AverageFieldSize>4.88</AverageFieldSize>
<Selectivity>12.5000%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^OPNEx.MModel.ProveedorS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
