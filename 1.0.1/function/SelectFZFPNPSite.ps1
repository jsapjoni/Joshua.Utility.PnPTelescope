function SelectFZFPNPSite {
  param (
    [Parameter(Mandatory, Position = 1)]
    [string]
    $SiteURL
  )
  
  #$SiteURLAdmin = SPOAdminURLConverter -SPOURL $SiteURL
  
  try 
  {
    Connect-PnPOnline $SiteURL -Interactive
  }
  catch
  {
    Write-Host "Could not connect to PNP.Site"
    throw "Aborting script..."
  }
  
  #Initializer - var declare
  $RandString = (Get-Random -Count 8 -Minimum 65 -Maximum 90 | ForEach-Object {[char]$_}) -join ""
  $TimeString = "{0:dd}{0:MM}{0:yyyy}-{0:hh}{0:mm}" -f (Get-Date)
  $TempFolder = "$env:TMP\$TimeString-$RandString"
  $SetCurrentWorkdir = $PWD
  
  #Initializer - setup
  [void] (New-Item $TempFolder -ItemType Directory)
  $hashtable = [hashtable]@{}
  
  PNPSites | ForEach-Object {
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
