function Invoke-GetPNPSitesService {
  try 
  {
    $Sites = Get-PnPTenantSite -Detailed -IncludeOneDriveSites
    return $Sites
  }
  catch 
  {
    Write-Host "Could not gather sites info from tenant using " -NoNewline
    Write-Host "$((Get-Command -Name "Get-PnPTenantSite").Source)" -ForegroundColor Red 
    Write-Host "Attempting to use SPO management module to gather sites info"
  }
  
  try 
  {
    $AdminURL = (Get-PnPContext).Url | Invoke-SPOAdminURLConverter
    Connect-SPOService -Url $AdminURL -ModernAuth $true
    $Sites = Get-SPOSite -Limit ALL -IncludePersonalSite $true
    return $Sites
  }
  catch 
  {
    Write-Host "Could not gather sites info from tenant using " -NoNewline
    Write-Host "$((Get-Command -Name "Connect-SPOService").Source)" -ForegroundColor Red 
    Write-Host "Aborting function call..." -ForegroundColor Red
    throw 
  }
}
