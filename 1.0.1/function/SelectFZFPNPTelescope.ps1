function SelectFZFPNPTelescope {
  param (
    [Parameter()]
    [string]
    $SiteURL
    ,
    [Parameter()]
    [switch]
    $SelectAvailableSite
  )
  
  #Initializer - var declare
  $RandString = (Get-Random -Count 8 -Minimum 65 -Maximum 90 | ForEach-Object {[char]$_}) -join ""
  $TimeString = "{0:dd}{0:MM}{0:yyyy}-{0:hh}{0:mm}" -f (Get-Date)
  $TempFolder = "$env:TMP\$TimeString-$RandString"

  [void] (New-Item $TempFolder -ItemType Directory)
  
  if ($PSBoundParameters["SelectAvailableSite"] -eq $true) {
    $List = (SelectFZFPNPList -SiteURL $SiteURL -SelectAvailableSite)
  }
  
  if ($PSBoundParameters["SelectAvailableSite"] -eq $false) {
    $List = (SelectFZFPNPList -SiteURL $SiteURL)
  }
  
  $FieldValues = (Get-PnPList -Identity $List | Get-PnPListItem).FieldValues 
  $ItemCount = ($FieldValues | Measure-Object).Count
  $Counter = 0
  
  $FieldValues | ForEach-Object { 
    [void] (New-Item -Path "$TempFolder\$($_["FileLeafRef"])___.json" -Force)
    $_ | ConvertTo-Json >> "$TempFolder\$($_["FileLeafRef"])___.json" 
    $Counter = $Counter + 1
    $PercentComplete = [int32]($Counter/$ItemCount * 100)
    Write-Progress -Activity "Initializing the meta-data telescope" -Status "Progressing: $PercentComplete %" -PercentComplete $PercentComplete
  }
  
  Set-Location $TempFolder
  $Items = fzf --height=80% --layout=reverse --info=inline --border --margin=1 --padding=1 --preview 'bat --color=always --style=numbers --line-range=:500 {}' --multi --preview-window 80%
  Set-Location $SetCurrentWorkdir
  Remove-Item $TempFolder -Recurse -Force
  return $Items #@{"Items" = $Items ; "NumberOfItems" = $Items.Split(" ").Count}
}
