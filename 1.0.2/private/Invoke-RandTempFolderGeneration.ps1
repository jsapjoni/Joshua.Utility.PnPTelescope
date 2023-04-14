function Invoke-RandTempFolderGeneration {
  param (
    [parameter()]
    [switch]
    $GenerateTempFolder
  )
  $RandString = (0..8 | ForEach-Object {[char](Get-Random -Minimum 65 -Maximum 90)}) -join ""
  $TimeString = "{0:dd}{0:MM}{0:yyyy}-{0:hh}{0:mm}" -f (Get-Date)
  $TempFolder = "$env:TMP\$TimeString-$RandString" 
  
  if ($PSBoundParameters["GenerateTempFolder"] -eq $true) {
    [void] (New-Item -Path $TempFolder -ItemType Directory -Force)
  }
  
  return $TempFolder
}
