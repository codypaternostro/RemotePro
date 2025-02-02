function Test-RequiresVmsConnection {
    #https://www.milestonepstools.com/commands/en-US/about_Custom_Attributes.help/#requiresvmsconnection
    [CmdletBinding()]
    [MilestonePSTools.RequiresVmsConnection(ConnectionRequired, AutoConnect = $false)]
    param()

    begin {
        try {
            Assert-VmsRequirementsMet -ErrorAction SilentlyContinue
        } catch {
            [System.Windows.MessageBox]::Show("No VMS connection.", "Exit", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning)
            return
        }
    }

    process {
        $true
    }
}
