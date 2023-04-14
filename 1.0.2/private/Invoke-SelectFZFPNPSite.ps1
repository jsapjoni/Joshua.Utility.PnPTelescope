function Invoke-SelectFZFPNPSite {
  param (
    [Parameter(Mandatory)]
    [string]
    $SiteURL
  )
  
  Connect-PnPOnline -Url $SiteURL -Interactive
  
  #Initializer - var declare
  $Sites = Invoke-GetPNPSites
  $SiteProperties = ($Sites[0] | Get-Member -MemberType Properties).Name
  $SitesList = [System.Collections.ArrayList]::new()
  $TempFolder = Invoke-RandTempFolderGeneration -GenerateTempFolder
  $SetCurrentWorkdir = $PWD
  $hashtable = [hashtable]@{}
  
  #Initializer - setup
  $Sites | ForEach-Object {
    # Costum filename
    $Filename = "$($_.url.split("/")[-2])-$($_.Url.Split("/")[-1])"
    $itemmurl = "$TempFolder\$($Filename)___.json"
    [void] (New-Item -Path $itemmurl -Force) 
    [void] $SitesList.Add("$Filename")
    foreach ($Property in $SiteProperties) {
      $hashtable.Add($Property, $_.$Property)
    }
    $hashtable | ConvertTo-Json >> $itemmurl
    $hashtable.Clear()
  }
  
  $InvokeFZFPickerServiceArgs = @{
    "TempFolder" = $TempFolder
    "WorkFolder" = $SetCurrentWorkdir
    "HeaderText" = "Select object you want to take action"
    "ListToPick" = $SitesList
  } ; $site = Invoke-FZFPickerService @InvokeFZFPickerServiceArgs

  return $Site
}
