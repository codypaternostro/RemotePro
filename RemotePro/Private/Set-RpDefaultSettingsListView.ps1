function Set-RpDefaultSettingsListView {
    Write-Verbose "Populating ListView with settings..."

    # Fetch the settings
    $settings = Get-RpSettings  # Ensure this returns a hashtable
    Write-Verbose "Retrieved settings: $($settings | Out-String)"

    if ($null -eq $script:Settings -or $null -eq $script:Settings.GetType().GetProperty('ItemsSource')) {
        Write-Error "ListView 'Settings' not found or does not have an 'ItemsSource' property."
        return
    }

    # Ensure the settings are a valid hashtable
    if ($settings -isnot [hashtable]) {
        Write-Error "Retrieved settings are not a valid hashtable."
        return
    }

    # Convert settings hashtable into proper objects for UI binding
    $processedSettings = @()
    foreach ($key in $settings.Keys) {
        $processedSettings += [PSCustomObject]@{
            Name  = $key
            Value = $settings[$key]
        }
    }
    Write-Verbose "Processed settings: $($processedSettings | Out-String)"

    # Bind the data to the ListView
    $script:Settings.ItemsSource = $processedSettings
    $script:Settings.Items.Refresh()  # Force UI update
    Write-Verbose "ListView updated with new settings."
}
