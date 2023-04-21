function Invoke-StringReplacerService {
  param (
    [Parameter(ValueFromPipeline)]
    [string]
    $String
    ,
    [Parameter()]
    [string[]]
    $Characters
  )
  
  foreach ($chars in $Characters[1..($Characters.Count - 1)]){
    $String = $String.Replace($chars,$Characters[0])
  }
  
  return $String
}
