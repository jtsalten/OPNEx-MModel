Class OPNEx.MModel.Direccion Extends (%SerialObject, %Populate, %XML.Adaptor, %JSON.Adaptor)
{

Property Ciudad As %String(POPSPEC = "City()");

Property Pais As %String [ InitialExpression = "España" ];

Property CodPostal As %String(POPSPEC = "USZip()");

Storage Default
{
<Data name="DireccionState">
<Value name="1">
<Value>Ciudad</Value>
</Value>
<Value name="2">
<Value>Pais</Value>
</Value>
<Value name="3">
<Value>CodPostal</Value>
</Value>
</Data>
<State>DireccionState</State>
<StreamLocation>^OPNEx.MModel.DireccionS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
