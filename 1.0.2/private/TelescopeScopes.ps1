function TelescopeScopes {
  param (
    [Parameter()]
    [ValidateScript(
      { "$_-Scopes" -in (Get-ChildItem -Path "$($MyInvocation.MyCommand.Path | Split-Path)\Scopes").Name},
      ErrorMessage = "Please specify a valid .scope file"
    )]
    [string]
    $Scope
    ,
    [Parameter()]
    [string[]]
    $SearchValue
    ,
    [Parameter()]
    [string]
    $InputValue
  )
}
