Get-ChildItem -Path "$($MyInvocation.MyCommand.Path | Split-Path)\function" |
  ForEach-Object {. $_.FullName}

