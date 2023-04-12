function TelescopeProperties {
  param (
    [Parameter()]
    [object]
    $Object
  )
  $jsonbuilder = @{}
  $Properties = ($Object | Get-Member -MemberType Properties).Name
  $Tempfolder = RandTempFolder -GenerateTempFolder
  $SetCurrentWorkdir = $PWD

  foreach ($property in $Properties) {
    [void] (New-Item -Path $ItemURL -Force)
    $ItemURL = "$Tempfolder\$($property)___.json"
    try 
    {
      $item = (@{$property = $Object.$($property)}) | ConvertTo-Json -WarningAction SilentlyContinue
    }
    catch 
    {
      $item = (@{$property = "Error could not get property"}) | ConvertTo-Json -WarningAction SilentlyContinue
    }
    $item >> $ItemURL
  }
  Set-Location $Tempfolder
  $PickedList = fzf --height=80% --layout=reverse --info=inline --border --margin=1 --padding=1 --preview 'bat --color=always --style=numbers --line-range=:500 {}' --preview-window 70% 
  $PickedList = (Get-Content -Path $PickedList | ConvertFrom-Json).Title
  Set-Location $SetCurrentWorkdir
  Remove-Item $TempFolder -Recurse -Force
}
