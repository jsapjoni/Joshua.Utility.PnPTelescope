function SelectFZFPNPItem {
  param (
    [Parameter()]
    [string]
    $SiteURL
  )
  
  try {
    $ListLocalPath = SelectFZFPNPList -SiteURL $SiteURL
    $List = $ListLocalPath.Split("/")[-1]
  }
  catch {
    throw "You are not connected to a site" 
  }
  $Item = Get-PnPListItem -List $List -PageSize 1000 | ForEach-Object {
    $_.FieldValues["FileRef"]
  } | Invoke-Fzf
  return $Item
}
