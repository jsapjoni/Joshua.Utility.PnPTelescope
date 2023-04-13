function Invoke-TestFunction {
  param (
    [Parameter(ValueFromPipeline)]
    [Object]
    $Object
    ,
    [Parameter()]
    [string[]]
    $SearchString
  )
  
  if ($SearchString -notin ($Object | Get-Member -MemberType Properties).Name){
    throw "Invalid property value in parameter searchstring, please specify a member property part of the passed object"
  }
}
