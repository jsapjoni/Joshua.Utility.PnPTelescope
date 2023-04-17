function Invoke-FZFDisplayService {
  param (
    [Parameter()]
    [Object]
    $Object
    ,
    [Parameter()]
    [String[]]
    $SearchProperties
  )
  
  $Properties = ($Object | Get-Member -MemberType Properties).Name
  if ($PSBoundParameters["SearchProperties"] -is [System.Object]) {
    $ValidProperties = foreach ($SearchProperty in $SearchProperties) {
      if ($SearchProperty -in $Properties) {
        $SearchProperty 
      } 
    } 
  } else { $ValidProperties = $Object | Invoke-PropertiesTelescope }
  
  $TempFolder = Invoke-RandTempFolderGeneration -GenerateTempFolder
  
  foreach ($ObjectItem in $Object) {
    
  }
}
