function SelectFZFPNPList {
  param (
    [Parameter()]
    [string]
    $SiteURL
  )
  
  try {
    $url = (Get-PnPConnection).Url
    Write-Host "Connected to site: " -NoNewline
    Write-Host "$url" -ForegroundColor Green
  }
  catch {
    SelectFZFPNPSite -SiteURL $SiteURL
  }

  Get-PnPList | ForEach-Object {$_.Title} | fzf --height=80% --layout=reverse --info=inline --border --margin=1 --padding=1 --multi
}
