# Fix Yarn PnP cache issue by copying local cache to global with renamed files
$globalCache = "C:\.local\share\yarn\berry\cache"
$localCache = ".yarn\cache"

# Create global cache directory
New-Item -ItemType Directory -Force -Path $globalCache | Out-Null

# Copy all cache files, renaming them to the expected format
Get-ChildItem -Path $localCache -Filter "*.zip" | ForEach-Object {
    $name = $_.Name
    # Format: packagename-npm-version-hash1-hash2.zip
    # Replace the last hash (hash2) with "10"
    $newName = $name -replace '-[a-f0-9]+\.zip$', '-10.zip'

    $source = $_.FullName
    $dest = Join-Path $globalCache $newName

    Write-Host "Copying $name -> $newName"
    Copy-Item -Path $source -Destination $dest -Force
}

Write-Host "`nCache fix complete. Try running 'yarn build' now."
