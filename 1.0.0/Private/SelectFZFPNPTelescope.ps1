function SelectFZFPNPTelescope {
  param (
    [Parameter()]
    [string]
    $SiteURL
    ,
    [Parameter()]
    [string]
    $MetaData 
  )
  
  $RandomString = (Get-Random -Count 8 -Minimum 65 -Maximum 90 | ForEach-Object {[char]$_}) -join ""
  $TempFolder = "$env:TMP\$RandomString"
  $SetCurrentWorkdir = $pwd
  $MetaDataSelect = "FileLeafRef"

  if ($PSBoundParameters["MetaData"] -is [System.Object]){
    $MetaDataSelect = $MetaData
  }

  [void] (New-Item $TempFolder -ItemType Directory)

  $List = (SelectFZFPNPList -SiteURL $SiteURL)
  
  Write-Host "Selected list: " -NoNewline
  Write-Host "$List" -ForegroundColor Green
  
  
  $FieldValues = (Get-PnPList -Identity "$List" | Get-PnPListItem).FieldValues 
  $ItemCount = ($FieldValues | Measure-Object).Count
  $Counter = 0
  
  $FieldValues | 
    ForEach-Object { [void] (New-Item "$TempFolder\$($_[$MetaDataSelect])___.json" -Force)
      $_ | ConvertTo-Json >> "$TempFolder\$($_[$MetaDataSelect])___.json" 
      $Counter = $Counter + 1
      $PercentComplete = [int32]($Counter/$ItemCount * 100)
      Write-Progress -Activity "Initializing the meta-data telescope" -Status "Progressing: $PercentComplete %" -PercentComplete $PercentComplete
    }

  Set-Location $TempFolder
  fzf --height=80% --layout=reverse --info=inline --border --margin=1 --padding=1 --preview 'bat --color=always --style=numbers --line-range=:500 {}' --multi --preview-window 80%
  Set-Location $SetCurrentWorkdir
  Remove-Item $TempFolder -Recurse -Force
}
