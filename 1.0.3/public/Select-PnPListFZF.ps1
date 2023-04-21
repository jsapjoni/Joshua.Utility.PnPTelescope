function Select-PnPListFZF {
  param (
    [Parameter(Mandatory)]
    [String]
    $SiteURL
  )
  
  if ($SiteURL -ne (Get-PnPContext).Url) {
    $SiteURL = Select-PnPSitesFZF -SiteURL $SiteURL
  }
  
  $SiteLists = Get-PnPList -Includes Author, HasUniqueRoleAssignments, RoleAssignments
  $TempFolder = Invoke-RandTempFolderGeneration -GenerateTempFolder
  $DataHT = [hashtable]::New()
  
  foreach ($SiteList in $SiteLists) {
    $ListContents = [System.Collections.ArrayList]::new()
    $Filename = $SiteList.RootFolder.ServerRelativeUrl.Trim("{0}/{1}" -f $SiteList.RootFolder.ServerRelativeUrl.Split("/"))
    $Filename = $Filename.Replace("/", "-").Replace("\", "-").Replace(":", "-")
    $ItemURL = "$TempFolder\$($Filename)___.json"
    
    
    $ListContents.Add( @{"Title" = $SiteList.Title} ) | Out-Null
    
    $ListContents.Add( @{"Author" = @{ 
      "ListAuthor" = $SiteList.Author.Title
      "LoginName" = $SiteList.Author.LoginName
      "Email" = $SiteList.Author.Email 
    }}) | Out-Null
    
    $ListContents.Add( @{"ListPath" = $SiteList.RootFolder.ServerRelativeUrl} ) | Out-Null
    
    $ListContents.Add( @{"ItemCount" = $SiteList.ItemCount} ) | Out-Null
    
    $ListContents.Add( @{"Permissions" = @{
      "HasUniqueRoleAssignments" = $SiteList.HasUniqueRoleAssignments
    }}) | Out-Null
    
    $DataHT.Add($Filename, $ListContents)
    $DataHT["$Filename"] | ConvertTo-Json >> $ItemURL
  }

  $FZFPickerServiceArgs = @{
    "TempFolder" = $TempFolder
    "WorkFolder" = $PWD
    "HeaderText" = "Please choose list from site"
    "ListToPick" = $DataHT.Keys
    "ReturnProperty" = "ListPath"
  }
  $SelectedItem = Invoke-FZFPickerService @FZFPickerServiceArgs
  return $SelectedItem
}
