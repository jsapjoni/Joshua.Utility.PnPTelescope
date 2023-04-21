function Invoke-FZFPickerService {
  param (
    [Parameter(Mandatory)]
    [string]
    $TempFolder
    ,
    [Parameter(Mandatory)]
    [string]
    $WorkFolder
    ,
    [Parameter()]
    [string]
    $HeaderText
    ,
    [Parameter(Mandatory)]
    [string[]]
    $ListToPick
    ,
    [Parameter()]
    [switch]
    $Multi
    ,
    [Parameter()]
    [string]
    $ReturnProperty
  )
  
  if ($PSBoundParameters["Multi"] -eq $true) {
    $MultiArgs = "--multi"
  }
  
  Set-Location $TempFolder
  $ReturnList = $ListToPick | & "fzf" @(
    "--header", $HeaderText,
    "--height", "80%",
    "--layout", "reverse",
    "--info", "inline",
    "--border",
    "--margin", 1,
    "--padding", 1,
    "--preview", "bat --color=always --style=numbers --line-range=:500 {}___.json"
    "--preview-window", "70%",
    $MultiArgs
  )

  #Get-Content -Path "$TempFolder\$($ReturnList)___.json"

  if ($PSBoundParameters["ReturnProperty"] -is [System.Object]) {
    $ReturnList = (Get-Content -Path "$TempFolder\$($ReturnList)___.json" | ConvertFrom-Json).$ReturnProperty
  }
  
  Set-Location $WorkFolder
  Remove-Item $TempFolder -Recurse -Force
  
  return $ReturnList
}
