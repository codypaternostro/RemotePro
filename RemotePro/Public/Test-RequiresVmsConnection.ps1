function Test-RequiresVmsConnection {
    <#
    .SYNOPSIS
    Tests if a VMS connection is required and attempts to assert the connection.

    .DESCRIPTION
    The Test-RequiresVmsConnection function checks if a VMS connection is
    required using the Assert-VmsRequirementsMet cmdlet. If the connection
    requirements are not met, it displays a warning message box and exits.

    .COMPONENT
    VmsConnection

    .EXAMPLE
    Example 1:
    PS C:\> Test-RequiresVmsConnection
    This command checks if a VMS connection is required and asserts the
    connection.

    .NOTES
    For more information, visit:
    https://www.milestonepstools.com/commands/en-US/about_Custom_Attributes.help/#requiresvmsconnection

    #>
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
