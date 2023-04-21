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
    ,
    [Parameter(Mandatory)]
    [string[]]
    $FilenameCharReplaceArgs
  )
  
  Connect-PnPOnline -Url $SiteURL -Interactive
  
  #Initializer - var declare
  $Sites = Invoke-GetPNPSitesService

  $FZFDisplayServiceArgs = @{
    "Object" = $Sites
    "SearchProperties" = $SearchProperties
    "FilenameCharReplaceArgs" = $FilenameCharReplaceArgs
  }

  $ReturnHT = Invoke-FZFDisplayService @FZFDisplayServiceArgs

  $FZFPickerServiceArgs = @{
    "TempFolder" = $ReturnHT["TempFolderPath"]
    "ListToPick" = $ReturnHT["PickerList"]
    "HeaderText" = "Select one site to manage..."
    "WorkFolder" = $PWD
  } 
  
  $PickedItems = Invoke-FZFPickerService @FZFPickerServiceArgs
  
  return $PickedItems
}
