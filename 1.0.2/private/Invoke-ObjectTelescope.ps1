function Invoke-ObjectTelescope {
  param (
    [parameter(ValueFromPipeline)]
    [Object]
    $Object
    ,
    [Parameter()]
    [string[]]
    $SearchStrings
  )
  
  $Properties = ($Object | Get-Member -MemberType Properties).Name
  
  $TempFolder = Invoke-RandTempFolderGeneration -GenerateTempFolder
  $SetCurrentWorkdir = $PWD
  $Hashtable = [hashtable]@{}
  
  foreach ($item in $Object) {
    $itemURL = "$TempFolder\$($Properties | ForEach-Object {$item.$_})___.json"
    [void] (New-Item -Path $itemURL -Force)
    foreach ($Property in $Properties) {
      $Hashtable.Add()
    }
  }
  
  $FZFPickerServiceArgs = @{
    "TempFolder" = $TempFolder
    "WorkFolder" = $SetCurrentWorkdir
    "HeaderText" = "Select object you want to take action"
    "ListToPick" = $Properties
    "Multi" = $true
  } ; $PickedItems = Invoke-FZFPickerService @FZFPickerServiceArgs
  
  return $PickedItems
}
