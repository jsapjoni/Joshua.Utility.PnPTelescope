function SelectFZFPNPSite {
  param (
    [Parameter()]
    [string]
    $SiteURL
  )
  
  if (($PSBoundParameters["SiteUrl"]) -is [System.Object]) {
    return (Connect-PnPOnline -Url $SiteURL -Interactive)
  }
  
  try {
    $url = (Get-PnPContext).Url
    return (Connect-PnPOnline -Url $url -Interactive)
  }
  catch {
    Write-Host "You are not connected to site" 
    Write-Host "Enabling site picker service via: " -NoNewline
    Write-Host "SharePoint Online Management Service" -ForegroundColor Green
  }
  
  if ($url -isnot [System.Object]) {
    try {
      Connect-SPOService -URL "https://arkivverket-admin.sharepoint.com" -ModernAuth $true
      $Site = (Get-SPOSite -Limit ALL -IncludePersonalSite $true) | ForEach-Object {
        $_.Title, $_.URL -join "|"
      } | Invoke-Fzf
      $url = $Site.Split("|")[-1]      
      Write-Host "Attempting to connect to site: " -NoNewline
      Write-Host "$url " -ForegroundColor Green -NoNewline
      Write-Host "via " -NoNewline
      Write-Host "PNP Management Shell Service" -ForegroundColor Green
      Write-Host "Please complete the authentication workflow"
    }
    catch {
      throw "Could not connect to sharepoint site"
    }   
  }
  return (Connect-PnPOnline -Url $url -Interactive)
}
