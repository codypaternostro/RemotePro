function Test-RpVmsConnection {
    <#
    .SYNOPSIS
    Tests the connection to the VMS management server.

    .DESCRIPTION
    This function tests whether a connection to the VMS management server is
    available. By default, it displays an error dialog if the connection fails.
    The user can optionally suppress the error dialog.

    .COMPONENT
    VmsConnection

    .PARAMETER ShowErrorDialog
    Determines if an error dialog should be shown when the connection fails.
    Default is $true (the error dialog will be shown).

    .EXAMPLE
    Test-RpVmsConnection

    Tests the connection to the VMS management server and shows an error dialog
    if the connection fails.

    .EXAMPLE
    Test-RpVmsConnection -ShowErrorDialog $false

    Tests the connection to the VMS management server and suppresses the error
    dialog if the connection fails.

    .LINK
    https://www.milestonepstools.com/commands/en-US/about_Custom_Attributes.help/#requiresvmsconnection

    .LINK
    https://remotepro.dev/en-US/Test-RpVmsConnection
    #>
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(ParameterSetName = 'Default')]
        [bool]$ShowErrorDialog = $true
    )

    $connectionChecker = New-Object -TypeName RpVmsConnectionChecker -ArgumentList $ShowErrorDialog
    return $connectionChecker.CheckConnection()
}
