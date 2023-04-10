function SelectFZFPNPList {
  param (
    [Parameter(Mandatory, Position = 1)]
    [string]
    $SiteURL
  )
  
  Write-Host "Starting the list picker service" 
  
  #Pre-Initializer - Check connection
  $Url = CheckConnection -ConnectURL $SiteURL

  #Initializer - var declare
  $TempFolder = RandTempFolder -GenerateTempFolder
  $SetCurrentWorkdir = $PWD
  $hashtable = [hashtable]@{}

  Get-PnPList | ForEach-Object {
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
  Write-Host "$PickedList " -ForegroundColor Green -NoNewline
  Write-Host "from site: " -NoNewline
  Write-Host "$Url" -ForegroundColor Green
  return $PickedList
}
