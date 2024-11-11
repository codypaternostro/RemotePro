# Helper function to format connection profiles for textbox
function Format-RpConnectionProfiles {
    $profiles = Get-RpConnectionProfile -All
    $formattedProfiles = @()
    foreach ($profile in $profiles) {
        $formattedText = "Name: $($profile.Name)`r`n"
        $formattedText += "Server Address: $($profile.ServerAddress)`r`n"
        $formattedText += "Credential: $(if ($profile.Credential) { $profile.Credential.UserName } else { 'N/A' })`r`n"
        $formattedText += "Basic User: $($profile.BasicUser)`r`n"
        $formattedText += "Secure Only: $($profile.SecureOnly)`r`n"
        $formattedText += "Include Child Sites: $($profile.IncludeChildSites)`r`n"
        $formattedText += "Accept EULA: $($profile.AcceptEula)`r`n`r`n"
        $formattedProfiles += [pscustomobject]@{
            Name = $profile.Name
            ServerAddress = $profile.ServerAddress
            Credential = if ($profile.Credential) { $profile.Credential.UserName } else { 'N/A' }
            FullDetails = $formattedText
        }
    }
    return $formattedProfiles
}
