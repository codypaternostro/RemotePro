# Helper function to refresh connection profiles
function Get-RpConnectionProfileRefresh {
    [System.Windows.Input.Mouse]::OverrideCursor = [System.Windows.Input.Cursors]::Wait

    try {
        $profiles = Get-RpConnectionProfile -All
        if ($profiles.Count -eq 0) {
            Set-DefaultConnectionProfileBox
        } else {
            $formattedProfiles = Format-RpConnectionProfiles
            $script:ConnectionProfileListBox.ItemsSource = $formattedProfiles
        }
    } catch {
        Set-DefaultConnectionProfileBox
    } finally {
        [System.Windows.Input.Mouse]::OverrideCursor = $null  # Reset the cursor
    }
}
