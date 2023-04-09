function SelectFZFPNPList {
  param (
    [Parameter(Mandatory, Position = 1)]
    [string]
    $SiteURL
    ,
    [Parameter()]
    [switch]
    $SelectAvailableSite
  )
  
  if ($PSBoundParameters["SelectAvailableSite"] -eq $true) {
    $Url = SelectFZFPNPSite -SiteURL $SiteURL
    try 
    {
      Connect-PnPOnline -Url $url -Interactive
      Write-Host "Connected to site: " -NoNewline
      Write-Host "$url" -ForegroundColor Green
    }
    catch 
    {
      Write-Host "Could not connect to site: " -NoNewline
      Write-Host "$url" -ForegroundColor Red
    }

  }
  
  #Initializer - var declare
  $Lists = Get-PnPList
  $RandString = (Get-Random -Count 8 -Minimum 65 -Maximum 90 | ForEach-Object {[char]$_}) -join ""
  $TimeString = "{0:dd}{0:MM}{0:yyyy}-{0:hh}{0:mm}" -f (Get-Date)
  $TempFolder = "$env:TMP\$TimeString-$RandString"
  $SetCurrentWorkdir = $PWD
  
  #Initializer - setup
  [void] (New-Item $TempFolder -ItemType Directory)
  $hashtable = [hashtable]@{}

  $Lists | ForEach-Object {
    $ItemUrl = "$TempFolder\$($_.Title)___.json"
    [void] (New-Item -Path $ItemUrl -Force)
    $hashtable.Add("Title", $_.Title)
    $hashtable.Add("Path", $_.Path)
    $hashtable | ConvertTo-Json >> $ItemUrl
    $hashtable.Clear()
  }
  
  Set-Location $TempFolder
  $PickedList = fzf --height=80% --layout=reverse --info=inline --border --margin=1 --padding=1 --preview 'bat --color=always --style=numbers --line-range=:500 {}' --preview-window 70% 
  $PickedList = (Get-Content -Path $PickedList | ConvertFrom-Json).Title
  Set-Location $SetCurrentWorkdir
  Remove-Item $TempFolder -Recurse -Force
  Write-Host "Selected list: " -NoNewline
  Write-Host "$PickedList" -ForegroundColor Green
  return $PickedList
}
