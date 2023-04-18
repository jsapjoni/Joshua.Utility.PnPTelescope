Get-ChildItem -Path "$($MyInvocation.MyCommand.Path | Split-Path)\private" |
  ForEach-Object {. $_.FullName}

Get-ChildItem -Path "$($MyInvocation.MyCommand.Path | Split-Path)\public" |
  ForEach-Object {. $_.FullName}
