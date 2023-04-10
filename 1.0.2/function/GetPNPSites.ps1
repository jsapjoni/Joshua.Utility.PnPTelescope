
function GetPNPSites {
  try 
  {
    $Sites = Get-PnPTenantSite -Detailed -IncludeOneDriveSites
  }
  catch 
  {
    throw "Could not gather sites info from tenant using PnP module"
  }
  return $Sites
}
