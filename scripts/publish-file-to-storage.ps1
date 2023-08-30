param (
    # Storage account name
    [Parameter(Mandatory)] [string] $storageAccountName,
    # Storage account key
    [Parameter(Mandatory)] [string] $storageAccountKey,
    # Storage container
    [Parameter(Mandatory)] [string] $storageContainer,
    # source file to upload
    [Parameter(Mandatory)] [string] $fileToUpload,
    # name of the blob
    [Parameter(Mandatory)] [string] $blobFileName
)
  # Some logging
  Write-Host "Publishing $blobFileName to storage account $storageAccountName, container $storageContainer."

  try {
    # Create context
    $Ctx = New-AzureStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageAccountKey

    # Upload blob
    Write-Host "Uploading $blobFileName..."
    Set-AzureStorageBlobContent -Context $Ctx -Container $storageContainer -File $fileToUpload -Blob $blobFileName -Force
    Write-Host "Publishing of $blobFileName succeeded."
  }
  catch {
    Write-Error "Could not publish blob with name $blobFileName, $_"
  }