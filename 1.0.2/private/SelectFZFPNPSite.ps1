function SelectFZFPNPSite {
  param (
    [Parameter(Mandatory)]
    [string]
    $SiteURL
  )
  
  Connect-PnPOnline -Url $SiteURL -Interactive
  
  #Initializer - var declare
  $Sites = Invoke-GetPNPSites
  $SitesList = [System.Collections.ArrayList]::new()


  $TempFolder = Invoke-RandTempFolderGeneration -GenerateTempFolder
  $SetCurrentWorkdir = $PWD
  $hashtable = [hashtable]@{}
  
  #Initializer - setup
  $Sites | ForEach-Object {
    $url = "$($_.url.split("/")[-2])-$($_.Url.Split("/")[-1])"
    $itemmurl = "$TempFolder\$($url)___.json"
    [void] (New-Item -Path $itemmurl -Force) 
    [void] $SitesList.Add("$url")
    
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
  
#  Set-Location $TempFolder
#  $Site = $SitesList | fzf --height=80% --layout=reverse --info=inline --border --margin=1 --padding=1 --preview 'bat --color=always --style=numbers --line-range=:500 {}___.json' --preview-window 70% 
#  $Site = (Get-Content -Path "$($Site)___.json" | ConvertFrom-Json).Url
#  Set-Location $SetCurrentWorkdir
#  Remove-Item $TempFolder -Recurse -Force
  
  $InvokeFZFPickerServiceArgs = @{
    "TempFolder" = $TempFolder
    "WorkFolder" = $SetCurrentWorkdir
    "HeaderText" = "Select object you want to take action"
    "ListToPick" = $SitesList
  } ; $site = Invoke-FZFPickerService @InvokeFZFPickerServiceArgs

  return $Site
}
