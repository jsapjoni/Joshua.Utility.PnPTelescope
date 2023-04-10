function CheckConnection {
  param (
    [Parameter()]
    [string]
    $ConnectURL
    ,
    [Parameter()]
    [ValidateSet("List", "Item")]
    [string[]]
    $Picker
  )
  
  try 
  {
    Write-Host "Checking connection on site..."
    $SiteUrl = (Get-PnPContext).Url
    Write-Host "Connection found on site: " -NoNewline
    Write-Host "$url" -ForegroundColor Green
  }
  
  catch 
  {
    Write-Host "Not connected to a site"
    $SiteUrl = SelectFZFPNPSite -SiteURL $ConnectURL
    Connect-PnPOnline -Url $SiteUrl -Interactive
  }
  return $SiteUrl
}
