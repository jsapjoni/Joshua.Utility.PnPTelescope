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

  $list = Get-PnPList | ForEach-Object {
    $_.Title
  } | Invoke-Fzf
  return $list
}
