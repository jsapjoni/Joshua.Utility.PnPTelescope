function SelectFZFPNPTelescope {
  param (
    [Parameter()]
    [string]
    $SiteURL
  )
  
  #Pre-Initializer - Check connection
  $SiteURL = CheckConnection -ConnectURL $SiteURL
  $PickedList = SelectFZFPNPList -SiteURL $SiteURL
  
  #Initializer - var declare
  $Counter = 0
  $TempFolder = Invoke-RandTempFolderGeneration -GenerateTempFolder
  $SetCurrentWorkdir = $PWD
  
  $FieldValues = (Get-PnPList -Identity $PickedList | Get-PnPListItem -PageSize 1000).FieldValues
  $ItemCount = ($FieldValues | Measure-Object).Count
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
