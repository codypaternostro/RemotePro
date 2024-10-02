# Fill Connections_Combo_Box with profile names.
# Refresh "MilestonePSTools Connection Profile Details" tab.
function Get-RemoteProConnections {
    param(
        [string]$ConnectionFilePath
    )

    [System.Windows.Input.Mouse]::OverrideCursor = [System.Windows.Input.Cursors]::Wait
    try {
        # Clear existing items from the ComboBox
        $script:Connections_Combo_Box.Items.Clear()

        if ($ConnectionFilePath){
            Set-RPConnectionProfile -ExcelFilePath $ConnectionFilePath
        }

        $connectionProfiles = Get-VmsConnectionProfile -All

        foreach ($name in $connectionProfiles) {
            # Pull each profile name for each site.
            $profileName = $name.Name

            # Add the site name to the ComboBox
            if ($null -ne $profileName) {
                $script:Connections_Combo_Box.Items.Add($profileName) | Out-Null
            }
        }

        # Optionally, select the first item by default
        if ($script:Connections_Combo_Box.Items.Count -gt 0) {
            $script:Connections_Combo_Box.SelectedIndex = 0
            $script:selectedProfileName = $script:Connections_Combo_Box.SelectedItem
        }

        # Refresh "MilestonePSTools Connection Profile Details" tab from the start of window being loaded.
        Get-RpConnectionProfileRefresh

        $connectionProfiles = $null
    } finally {
        [System.Windows.Input.Mouse]::OverrideCursor = $null  # Reset the cursor
    }
}
