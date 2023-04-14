function Invoke-PropertiesTelescope {
  param (
    [Parameter(ValueFromPipeline)]
    [object]
    $Object
  )
  $Properties = ($Object | Get-Member -MemberType Properties).Name
  $Tempfolder = Invoke-RandTempFolderGeneration -GenerateTempFolder
  $SetCurrentWorkdir = $PWD

  foreach ($property in $Properties) {
    $ItemURL = "$Tempfolder\$($property)___.json"
    [void] (New-Item -Path $ItemURL -Force)
    try 
    {
      $item = (@{$property = $Object.$($property)}) | ConvertTo-Json -WarningAction SilentlyContinue
    }
    catch 
    {
      $item = (@{$property = "Error could not get property"}) | ConvertTo-Json -WarningAction SilentlyContinue
    }
    $item >> $ItemURL
  }
  
  $FZFPickerServiceArgs = @{
    "TempFolder" = $Tempfolder
    "WorkFolder" = $SetCurrentWorkdir
    "HeaderText" = "Please one or more properties"
    "ListToPick" = $Properties
  } ; $PickedItem = Invoke-FZFPickerService @FZFPickerServiceArgs
  
  return $PickedItem
}
