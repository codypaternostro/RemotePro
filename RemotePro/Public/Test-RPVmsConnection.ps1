function Test-RpVmsConnection {
    <#
    .SYNOPSIS
        Tests the connection to the VMS management server.

    .DESCRIPTION
        This function tests whether a connection to the VMS management server is
        available. By default, it displays an error dialog if the connection fails.
        The user can optionally suppress the error dialog.

    .PARAMETER ShowErrorDialog
        Determines if an error dialog should be shown when the connection fails.
        Default is $true (the error dialog will be shown).

    .EXAMPLE
        Test-RpVmsConnection

    .EXAMPLE
        Test-RpVmsConnection -ShowErrorDialog $false
    .LINK
    https://www.milestonepstools.com/commands/en-US/about_Custom_Attributes.help/#requiresvmsconnection
    #>
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(ParameterSetName = 'Default')]
        [bool]$ShowErrorDialog = $true
    )

    $connectionChecker = New-Object -TypeName RPVmsConnectionChecker -ArgumentList $ShowErrorDialog
    return $connectionChecker.CheckConnection()
}
