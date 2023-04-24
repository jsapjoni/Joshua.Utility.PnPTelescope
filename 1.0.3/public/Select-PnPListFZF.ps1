function Select-PnPListFZF {
  param (
    [Parameter(Mandatory)]
    [String]
    $SiteURL
  )
  
  Invoke-PnPCheckSiteConnection -SiteURL $SiteURL
  $SiteLists = Get-PnPList -Includes Author, HasUniqueRoleAssignments, RoleAssignments
  $TempFolder = Invoke-RandTempFolderGeneration -GenerateTempFolder
  $DataHT = [hashtable]::New()
  
  foreach ($SiteList in $SiteLists) {
    $PropsHT = [hashtable]::new()
    $Filename = $SiteList.RootFolder.ServerRelativeUrl.Trim("{0}/{1}" -f $SiteList.RootFolder.ServerRelativeUrl.Split("/"))
    $Filename = $Filename.Replace("/", "-").Replace("\", "-").Replace(":", "-")
    $ItemURL = "$TempFolder\$($Filename)___.json"
    
    
    $PropsHT.Add("Title", $SiteList.Title)
    
    $PropsHT.Add("Author",@{ 
      "ListAuthor" = $SiteList.Author.Title
      "LoginName" = $SiteList.Author.LoginName
      "Email" = $SiteList.Author.Email 
    })
    
    $PropsHT.Add("ListPath", $SiteList.RootFolder.ServerRelativeUrl)
    
    $PropsHT.Add("ItemCount", $SiteList.ItemCount)
    
    $PropsHT.Add("Permissions", @{
      "HasUniqueRoleAssignments" = $SiteList.HasUniqueRoleAssignments
    })
    
    $DataHT.Add($Filename, $PropsHT)
    $DataHT["$Filename"] | ConvertTo-Json | jq . >> $ItemURL
    $PropsHT.Clear()
  }

  $FZFPickerServiceArgs = @{
    "TempFolder" = $TempFolder
    "WorkFolder" = $PWD
    "HeaderText" = "Please choose list from site"
    "ListToPick" = $DataHT.Keys
    "ReturnProperty" = "Title"
  }
  $SelectedItem = Invoke-FZFPickerService @FZFPickerServiceArgs
  return $SelectedItem
}
