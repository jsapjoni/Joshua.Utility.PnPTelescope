function SelectFZFPNPSite {
  param (
    [Parameter(Mandatory, Position = 1)]
    [string]
    $SiteURL
  )
  
  #$SiteURLAdmin = SPOAdminURLConverter -SPOURL $SiteURL
  
  Write-Host "Starting site picker service"
  
  try 
  {
    Connect-PnPOnline $SiteURL -Interactive
  }
  catch
  {
    Write-Host "Could not connect to sites from SharePoint tenant"
    throw "Aborting site picker service"
  }
  
  #Initializer - var declare
  $TempFolder = Invoke-RandTempFolderGeneration -GenerateTempFolder
  $SetCurrentWorkdir = $PWD
  $hashtable = [hashtable]@{}
  
  #Initializer - setup
  GetPNPSites | ForEach-Object {
    $url = "$($_.url.split("/")[-2])-$($_.Url.Split("/")[-1])"
    $itemmurl = "$TempFolder\$($url)___.json"
    [void] (New-Item -Path $itemmurl -Force) 
    $hashtable.Add("Url", $_.url) 
    $hashtable.Add("IDs", @{"GroupID" = $_.GroupID ; "HubSiteId" = $_.HubSiteID})
    $hashtable.Add("Title", $_.Title)
    $hashtable.Add("IsHubsite", $_.IsHubSite)
    $hashtable.Add("Status", $_.Status)
    $hashtable.Add("SharingCapability", $_.SharingCapability)
    $hashtable.Add("Teams", @{"IsTeamsConnected" = $_.IsTeamsConnected ; "IsTeamsChannelConnected" = $_.IsTeamsChannelConnected ; "TeamsChannelType" = $_.TeamsChannelType})
    $hashtable.Add("Owner", $_.Owner)
    $hashtable.Add("SiteTemplate", $_.Template)
    $hashtable | ConvertTo-Json >> $itemmurl
    $hashtable.Clear()
  }
  
  Set-Location $TempFolder
  $Site = fzf --height=80% --layout=reverse --info=inline --border --margin=1 --padding=1 --preview 'bat --color=always --style=numbers --line-range=:500 {}' --preview-window 70% 
  $Site = (Get-Content -Path $Site | ConvertFrom-Json).Url
  Set-Location $SetCurrentWorkdir
  Remove-Item $TempFolder -Recurse -Force
  
  return $Site
}
