function SelectFZFPNPList {
  param (
    [Parameter(Mandatory, Position = 1)]
    [string]
    $SiteURL
  )
  
  Write-Host "Starting the list picker service" 
  
  #Pre-Initializer - Check connection
  Invoke-PNPCheckSiteConnection -SiteURL $SiteURL

  #Initializer - var declare
  $List = Get-PnPList
  $ListProperties = ($List[0] | Get-Member -MemberType Properties).Name
  $PNPListToPick = $List.Title
  $TempFolder = Invoke-RandTempFolderGeneration -GenerateTempFolder
  $SetCurrentWorkdir = $PWD
  $hashtable = [hashtable]@{}

  $List | ForEach-Object {
    # Standard filename
    $ItemUrl = "$TempFolder\$($_.Title)___.json"
    [void] (New-Item -Path $ItemUrl -Force)
    foreach ($Property in $ListProperties) {
      $hashtable.Add($Property, $_.$Property)
    }
    $hashtable | ConvertTo-Json >> $ItemUrl
    $hashtable.Clear()
  }
  
  $FZFPickerServiceArgs = @{
    "TempFolder" = $TempFolder
    "WorkFolder" = $SetCurrentWorkdir
    "HeaderText" = "Please select list"
    "ListToPick" = $PNPListToPick
  } ; $PickedItem = Invoke-FZFPickerService @FZFPickerServiceArgs

  return $PickedItem
}
