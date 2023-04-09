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
  Get-PnPListItem -List $List -PageSize 1000 | ForEach-Object {
    $_.FieldValues["FileRef"]
  } | fzf --height=80% --layout=reverse --info=inline --border --margin=1 --padding=1 --multi
}
