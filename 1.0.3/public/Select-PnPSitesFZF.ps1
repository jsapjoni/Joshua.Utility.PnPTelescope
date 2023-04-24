function Select-PnPSitesFZF {
  param (
    [Parameter(Mandatory)]
    [string]
    $SiteURL
  )
  Connect-PnPOnline -Url $SiteURL -Interactive
  $Sites = Invoke-GetPNPSitesService
  $Properties = ($Sites | Get-Member -MemberType Properties).Name
  $TempFolder = Invoke-RandTempFolderGeneration -GenerateTempFolder
  $DataHT = [hashtable]::new()
  
  foreach ($Site in $Sites) {
    $PropsHT = [hashtable]::new()
    
    try {
      $Filename = "{3}/{4}" -f $Site.Url.Split("/")
      $Filename = $Filename.Replace("/", "-").Replace("\", "-").Replace(":", "-")
    }
    catch {
      $Filename = $site.Url
      $Filename = $Filename.Replace("/", "-").Replace("\", "-").Replace(":", "-")
    }
    
    $ItemURL = "$TempFolder\$($Filename)___.json"
    
    foreach ($Property in $Properties) {
      $PropsHT.Add($Property, $Site.$Property)
    }
    
    $DataHT.Add($Filename, $PropsHT)
    $DataHT["$Filename"] | ConvertTo-Json | jq . >> $ItemURL
    $PropsHT.Clear()
  }
  
  $FZFPickerServiceArgs = @{
    "TempFolder" = $TempFolder
    "WorkFolder" = $PWD
    "HeaderText" = "Please choose sharepoint site"
    "ListToPick" = $DataHT.Keys
    "ReturnProperty" = "Url"
  }
  
  $SelectedItem = Invoke-FZFPickerService @FZFPickerServiceArgs
  return $SelectedItem
}
