function Select-PnPListItem {
  param (
    [Parameter()]
    [string]
    $SiteURL
    ,
    [Parameter()]
    [string]
    $List
  )
  
  Invoke-PnPCheckSiteConnection -SiteURL $SiteURL
  
  if ($PSBoundParameters["List"] -isnot [System.Object]) {
    $PickedList = Select-PnPListFZF -SiteURL $SiteURL
    Write-Host "Pickedlist: " -NoNewline
    Write-Host $PickedList -ForegroundColor Green
  }
}
