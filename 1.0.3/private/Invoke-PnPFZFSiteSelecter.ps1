function Invoke-PnPFZFSiteSelecter {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [String]
    $SiteURL
    ,
    [Parameter(Mandatory)]
    [string[]]
    $SearchProperties
  )
  
  Connect-PnPOnline -Url $SiteURL -Interactive
  
  #Initializer - var declare
  $Sites = Invoke-GetPNPSitesService
  $ReturnHT = Invoke-FZFDisplayService -Object $Sites -SearchProperties $SearchProperties

  $FZFPickerServiceArgs = @{
    "TempFolder" = $ReturnHT["TempFolderPath"]
    "ListToPick" = $ReturnHT["PickerList"]
    "HeaderText" = "Select one site to manage..."
    "WorkFolder" = $PWD
  } ; $PickedItems = Invoke-FZFPickerService @FZFPickerServiceArgs
  return $PickedItems
}
