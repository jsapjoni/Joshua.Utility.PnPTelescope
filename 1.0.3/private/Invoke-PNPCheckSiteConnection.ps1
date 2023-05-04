function Invoke-PNPCheckSiteConnection {
  param (
    [Parameter()]
    [string]
    $SiteURL
  )
  
  try 
  {
    $ConnectedURL = (Get-PnPContext).Url
    Write-Host "$ConnectedURL" -ForegroundColor Green
  }
  
  catch 
  {
    $SiteURL = Select-PnPSitesFZF -SiteURL $SiteURL
    Connect-PnPOnline -Url $SiteUrl -Interactive
  }
}
