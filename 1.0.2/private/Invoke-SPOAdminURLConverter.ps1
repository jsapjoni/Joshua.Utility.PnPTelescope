function Invoke-SPOAdminURLConverter {
  param(
    [Parameter(ValueFromPipeline, Mandatory)]
    [string]
    $SPOURL
  )
  return "{0}-admin.{1}.com" -f $SPOURL.Split(".")
}

