# Get and format connection overview data for current connection
function Get-RpConnectionsOverview {
    # Retrieve the site information
    $siteInfo = Get-Site

    # Extract necessary properties
    $ServerAdress    = $siteInfo.Properties.Address
    $ProductName     = $siteInfo.Properties.ProductName
    $ServiceAccount  = $siteInfo.Properties.ServiceAccount

    # Get license information
    $licInfo         = Get-LicenseInfo
    $licOverview     = Get-LicenseOverview
    $licDetails      = Get-LicenseDetails
    $licProducts     = Get-LicensedProducts

    # Create a PSCustomObject to hold all the relevant data
    $managementServerInfo = [PSCustomObject]@{
        Name                    = $siteInfo.Name
        Address                 = $ServerAdress
        Enabled                 = $siteInfo.Enabled
        ServiceAccount          = $ServiceAccount
        ProductName             = $ProductName
        SLC                     = $licInfo.Slc
        Activated               = $licOverview.Activated[0]
        ChangesWithoutActivation = $licDetails.ChangesWithoutActivation[0]
        ExpirationDate          = $licProducts.ExpirationDate
    }

    # Get Recording Server Information
    $recordingServers = Get-VmsRecordingServer | ForEach-Object {
        [PSCustomObject]@{
            Name           = $_.Name
            HostName       = $_.HostName
            Enabled        = $_.Enabled
            LastModified   = $_.LastModified.ToString('MM/dd/yyyy HH:mm:ss')
            TimeZoneName   = $_.TimeZoneName
        }
    }

    # Format the information into a readable string
    $ServerInfo = "$($script:selectedProfileName)'s Management Server`n"
    $ServerInfo += $managementServerInfo | Format-List | Out-String
    $ServerInfo += "`nRecording Server(s)`n"
    $ServerInfo += $recordingServers | Format-List | Out-String

    # Return the server information
    return $ServerInfo
}
