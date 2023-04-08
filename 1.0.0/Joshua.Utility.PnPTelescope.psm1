Get-ChildItem -Path "$($MyInvocation.MyCommand.Path | Split-Path)\Private" |
  ForEach-Object {. $_.FullName}

Get-ChildItem -Path "$($MyInvocation.MyCommand.Path | Split-Path)\Public" |
  ForEach-Object {. $_.FullName}
