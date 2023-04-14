function Invoke-GetPNPSites {
  try 
  {
    $Sites = Get-PnPTenantSite -Detailed -IncludeOneDriveSites
  }
  catch 
  {
    Write-Host "Could not gather sites info from tenant using PnP module"
    Write-Host "Attempting to use SPO management module to gather sites info"
  }
  
  try 
  {
    $Sites = Get-SPOSite -Limit ALL -IncludePersonalSite $true
  }
  catch 
  {
    throw "Could not gather sites info from both PnP Module and SPO Management Module"
  }
  return $Sites
}
