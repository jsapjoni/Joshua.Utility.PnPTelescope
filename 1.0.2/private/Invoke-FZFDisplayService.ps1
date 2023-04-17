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
  } 
  else 
  { 
    $ValidProperties = $Properties | Invoke-PropertiesTelescope 
  }
  
  $TempFolder = Invoke-RandTempFolderGeneration -GenerateTempFolder
  Write-Host $TempFolder
  $Hashtable = [Hashtable]::new()
  
  foreach ($ObjectItem in $Object) {
    $List = [System.Collections.ArrayList]::new()
    $FileName = foreach ($Vproperties in $ValidProperties) {
      $ObjectItem.$Vproperties
    }
    $FileName = $FileName -join ""
    $ItemURL = "$TempFolder\$($FileName)___.json"
    foreach ($Property in $Properties) {
      $List.Add(@{$Property = $ObjectItem.$Property})
    }
    $Hashtable.Add($FileName, $List)
    $Hashtable | ConvertTo-Json >> $ItemURL
  }
  
  return $Hashtable
} 
