function SPOAdminURLConverter {
  param(
    [Parameter(Mandatory, Position = 1)]
    [string]
    $SPOURL
  )
  return "{0}-admin.{1}.com" -f $SPOURL.Split(".")
}

