function Invoke-PropertiesTelescopeTest {
  param (
    [Parameter(ValueFromPipeline)]
    [object]
    $Object
  )

  $Properties = ($Object | Get-Member -MemberType Properties).Name
  $Tempfolder = RandTempFolder -GenerateTempFolder
  $SetCurrentWorkdir = $PWD
  
  $Object | 
  ForEach-Object -PipelineVariable ObjectItem {
    $_
    $ItemURL = "$Tempfolder\$($property)___.json"
    [void] (New-Item -Path $ItemURL -Force)
    Write-Host "Processing $($_.Name)"
  } | 
  ForEach-Object -PipelineVariable Property {
    $Properties
    Write-Host "Processing $Properties"
  } | 
  ForEach-Object {
    Write-Host "Processing $_"
    try { @{$Property = $ObjectItem.$Property} | ConvertTo-Json -WarningAction SilentlyContinue >> $ItemURL }
    catch { @{$Property = "Error could not get property"} | ConvertTo-Json -WarningAction SilentlyContinue >> $ItemURL}
  }
  
  Write-Host $Tempfolder
  Set-Location $Tempfolder
  $PickedList = $properties | fzf --header 'Select one or more properties' --height=80% --layout=reverse --info=inline --border --margin=1 --padding=1 --preview 'bat --color=always --style=numbers --line-range=:500 {}___.json' --preview-window 70% --multi
  Set-Location $SetCurrentWorkdir
  return $PickedList
}
