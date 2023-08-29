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
    # set to not replace the latest version
    # [switch] $skipLatest
)
  # Some logging
  #Write-Host "Publishing $version to storage account $storageAccountName, container $containerName."

  try {
    # Set metadata
    # $BlobName = "$($blobPrefix)$Version/$fileNameOnBlob"
    # $BlobNameLatest = "$($blobPrefix)latest/$fileNameOnBlob"

    # Create context
    $Ctx = New-AzureStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageAccountKey

    # Upload blob
    Write-Host "Uploading $blobFileName..."
    Set-AzureStorageBlobContent -Context $Ctx -Container $storageContainer -File $fileToUpload -Blob $blobFileName -Force

    # if (!$skipLatest) {
    #   # Upload latest blob
    #   Set-AzureStorageBlobContent -Context $Ctx -Container $containerName -File $fileToUpload -Blob $BlobNameLatest -Metadata $Metadata -Force
    # }
  }
  catch {
    Write-Error "Could not publish blob with name $blobFileName, $_"
  }