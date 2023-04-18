function Invoke-FZFDisplayService {
  [CmdletBinding()]
  param (
    [Parameter()]
    [Object[]]
    $Object
    ,
    [Parameter()]
    [String[]]
    $SearchProperties
  )
  
  $Properties = ($Object[0] | Get-Member -MemberType Properties).Name
  if ($PSBoundParameters["SearchProperties"] -is [System.Object]) {
    $ValidProperties = foreach ($SearchProperty in $SearchProperties) {
      if ($SearchProperty -in $Properties) {
        $SearchProperty  
      }
    }
  }
  else 
  { 
    $ValidProperties = $Object[0] | Invoke-PropertiesTelescope
  }
  
  $TempFolder = Invoke-RandTempFolderGeneration -GenerateTempFolder
  $DataHT = [Hashtable]::new()
  $ReturnHT = [hashtable]::new()
  
  foreach ($ObjectItem in $Object) {
    $List = [System.Collections.ArrayList]::new()
    
    $FileName = foreach ($Vproperties in $ValidProperties) {
      $ObjectItem.$Vproperties
    }
    
    $FileName = $FileName -join ""
    $ItemURL = "$TempFolder\$($FileName)___.json"
    
    foreach ($Property in $Properties) {
      [void] $List.Add(@{$Property = $ObjectItem.$Property}) 
    }
    
    $DataHT.Add($FileName, $List)
    @{$FileName = $DataHT["$FileName"]} | ConvertTo-Json >> $ItemURL
  }
  
  $ReturnHT.Add("TempFolderPath", $TempFolder)
  $ReturnHT.Add("DataHashtable", $DataHT)
  $ReturnHT.Add("PickerList", $DataHT.Keys)
  
  return $ReturnHT
} 
