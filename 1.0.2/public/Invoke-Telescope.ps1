function Invoke-Telescope {
  param (
    [Parameter(Mandatory)]
    [Object]
    $Object
    ,
    [Parameter(Mandatory)]
    [string[]]
    $SearchProperties
  )
  
  $Data = Invoke-FZFDisplayService -Object $Object -SearchProperties $SearchProperties
  
  $FZFPickerArgs = @{
    "TempFolder" = $Data["TempFolderPath"]
    "WorkFolder" = $PWD
    "HeaderText" = "Please pick item"
    "ListToPick" = $Data["PickerList"]
  }

  return (Invoke-FZFPickerService @FZFPickerArgs)
}
