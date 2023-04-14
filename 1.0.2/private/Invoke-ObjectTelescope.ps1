function Invoke-ObjectTelescope {
  param (
    [parameter(ValueFromPipeline)]
    [Object]
    $Object
    ,
    [Parameter()]
    [string[]]
    $SearchStrings
    ,
    [Parameter()]
    [switch]
    $InteractiveProperties
  )
  
  $Properties = ($Object | Get-Member -MemberType Properties).Name
  
  if (!($PSBoundParameters["InteractiveProperties"] -is [System.Object])) {
    $Properties = $Object | Invoke-PropertiesTelescope
    if ($Properties.Count -ge 4){
      throw "Too many properties. Maximum 3 may be chosen"
    }
  } 
  
  $TempFolder = RandTempFolder -GenerateTempFolder
  $SetCurrentWorkdir = $PWD
  
  foreach ($item in $Object) {
    $itemURL = "$TempFolder\$($Properties | ForEach-Object {$item.$_})___.json"
    [void] (New-Item -Path $itemURL -Force)
  }
  
  $FZFPickerServiceArgs = @{
    "TempFolder" = $TempFolder
    "WorkFolder" = $SetCurrentWorkdir
    "HeaderText" = "Select object you want to take action"
    "ListToPick" = $Properties
  }
  
  return Invoke-FZFPickerService @FZFPickerServiceArgs
}
