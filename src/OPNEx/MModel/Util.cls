Class OPNEx.MModel.Util Extends %RegisteredObject
{

ClassMethod Limpia(pAll As %Boolean = 0)
{
	do ##class(OPNEx.MModel.Proveedor).%KillExtent()
	
	if pAll
	{
		&SQL(drop table OPNEx_MModel.Proveedor)
	}

	return
}

ClassMethod ResetDemo(pFile As %String = "c:/_DEMOS/OPNEx-MModel/Template.xml")
{
	do $system.OBJ.Load(pFile,"ck")
}

/// Inserta una fila directamente en el Global ^OPNEx.MModel.ProveedorD e incrementa el número de registros en el nodo raiz
/// La posición de cada propiedad se supone pre-establecida: Descripcion-CIF-Direccion(Ciudad-Pais-CodPostal)
/// Ej. Formato
///      ^OPNEx.MModel.ProveedorD=3
/// 	     ^OPNEx.MModel.ProveedorD(1)=$lb("","proveedor 1",$lb("Albacete","España","02230"))
ClassMethod InsGlb(pDesc As %String = "", pCIF As %String = "", pCiudad As %String = "", pCodPostal As %String = "", pPais As %String = "España") As %Integer
{
	set ^OPNEx.MModel.ProveedorD($Increment(^OPNEx.MModel.ProveedorD)) = $ListBuild("",$get(pDesc),$get(pCIF),$ListBuild($get(pCiudad),$get(pPais),$get(pCodPostal)))
	return ^OPNEx.MModel.ProveedorD
}

/// Lee los datos asociados a un ID - Si se indica una propiedad, devuelve sólo el valor de esa propiedad
/// La posición de cada propiedad está pre-establecida: Descripcion-CIF-Direccion(Ciudad-Pais-CodPostal)
ClassMethod LeeGlb(pID As %Integer = "", pProp As %String = "") As %String
{
	#dim tDatos as %String=$ListBuild()
	#dim tResult as %String = ""
	#dim tPosicion as %Integer = $case(pProp,"Descripcion":2,"CIF":3,"Direccion":4,:0)
	
	set:pID'="" tDatos = $get(^OPNEx.MModel.ProveedorD(pID))
	
	if tPosicion = 0
	{
		set tResult = $ListToString($List(tDatos,1,3))_","_$ListToString($List(tDatos,4))
	}
	elseif tPosicion = 4
	{
		set tResult = $ListToString($List(tDatos,4))
	}
	else
	{
		set tResult = $List(tDatos,tPosicion)
	}
	
	return tResult
}

ClassMethod InsercionMasiva(pNum As %Integer = 10000)
{
	#dim tCiudades as %List = $ListBuild("Albacete","Burgos","Caceres","Cordoba","Huelva","Jerez","Murcia","Cieza","Castellon","Palencia","Bilbao","Santander","Leon","Tarragona","Valencia","Mallorca","Terual","Zaragoza")
	#dim tNumCiudades as %Integer = $ListLength(tCiudades)
	#dim i as %Integer
	#dim tIni as %Integer = $piece($NOW(),",",2)

	write !,"Inicio ==> Ultimo ID: "_$get(^OPNEx.MModel.ProveedorD)

	for i = 1:1:pNum
	{
		set tCIF = "B"_$translate($justify($random(99999999),8)," ",0)
		set tCodPostal = $translate($justify($random(99999),5)," ",0)

		do ..InsGlb("Proveedor "_$random(pNum)_$random(pNum),tCIF,$List(tCiudades,$r(tNumCiudades)+1),tCodPostal)
	}

	write !,"Finalizado ==> Ultimo ID: "_$get(^OPNEx.MModel.ProveedorD)
	write !,"Tiempo: "_($piece($NOW(),",",2)-tIni)
	quit
}

}
