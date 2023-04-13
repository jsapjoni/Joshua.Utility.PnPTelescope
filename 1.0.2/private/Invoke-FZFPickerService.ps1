function Invoke-FZFPickerService {
  param (
    [Parameter(Mandatory)]
    [string]
    $TempFolder
    ,
    [Parameter()]
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
  )
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
    "--multi"
  )
  Set-Location $WorkFolder
  return $ReturnList
}
