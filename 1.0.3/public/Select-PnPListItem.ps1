function Select-PnPListItem {
  param (
    [Parameter()]
    [string]
    $SiteURL
    ,
    [Parameter()]
    [string]
    $List
  )
  
  Invoke-PnPCheckSiteConnection -SiteURL $SiteURL | Out-Null
  
  if ($PSBoundParameters["List"] -isnot [System.Object]) {
    $List = Select-PnPListFZF -SiteURL $SiteURL
    Write-Host $List -ForegroundColor Green
  }
  
  $ListItems = Get-PnPListItem -List $List -PageSize 1000
  $TempFolder = Invoke-RandTempFolderGeneration -GenerateTempFolder
  $DataHT = [hashtable]::new()
  
  foreach ($ListItem in $ListItems) {
    $PropsHT = [hashtable]::new()
    $FileName = $ListItem.FieldValues["FileRef"]
    $FileName = $FileName.Replace("/", "").Replace("\", "-").Replace(":", "-")
    $ItemURL = "$TempFolder\$($Filename)___.json"
  
    $PropsHT.Add("FieldValues", $ListItem.FieldValues)
    $DataHT.Add($FileName, $PropsHT)
    $DataHT["$FileName"] | ConvertTo-Json | Out-File -FilePath $ItemURL -Encoding utf8NoBOM
    $PropsHT.Clear()
  }
  
  $FZFPickerServiceArgs = @{
    "TempFolder" = $TempFolder
    "WorkFolder" = $PWD
    "HeaderText" = "Please choose one or multiple list items"
    "ListToPick" = $DataHT.Keys
    "ReturnProperty" = "FieldValues"
    "Multi" = $true
  }
  $SelectedItem = Invoke-FZFPickerService @FZFPickerServiceArgs
  return $SelectedItem
}
