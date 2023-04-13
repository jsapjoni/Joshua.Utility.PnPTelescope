function Invoke-PropertiesTelescope {
  param (
    [Parameter(ValueFromPipeline)]
    [object]
    $Object
  )
  $Properties = ($Object | Get-Member -MemberType Properties).Name
  $Tempfolder = RandTempFolder -GenerateTempFolder
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
    "HeaderText" = "Please pick properties"
    "ListToPick" = $Properties
  }

  return Invoke-FZFPickerService @FZFPickerServiceArgs
#  Set-Location $Tempfolder
#  $PickedList = $properties | fzf --header 'Select one or more properties' --height=80% --layout=reverse --info=inline --border --margin=1 --padding=1 --preview 'bat --color=always --style=numbers --line-range=:500 {}___.json' --preview-window 70% --multi
#  Set-Location $SetCurrentWorkdir
#  return $PickedList
}
