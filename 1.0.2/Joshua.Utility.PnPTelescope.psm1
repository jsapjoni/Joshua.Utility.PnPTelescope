Get-ChildItem -Path "$($MyInvocation.MyCommand.Path | Split-Path)\function" |
  ForEach-Object {. $_.FullName}

Get-ChildItem -Path "$($MyInvocation.MyCommand.Path | Split-Path)\scopes" |
  ForEach-Object {. $_.FullName}
