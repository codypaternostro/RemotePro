function Get-RpConfigCommands {
    <#
    .SYNOPSIS
    Retrieves the configuration commands from the RemotePro controller
    object.

    .DESCRIPTION
    The Get-RpDefaultConfigCommands function is used to retrieve the
    configuration commands from the RemotePro controller object. It utilizes the
    Get-RpControllerObject cmdlet to fetch the property ConfigCommands.

    .EXAMPLE
    Get-RpDefaultConfigCommands
    #>
    [CmdletBinding()]
    param()

    begin {
        Get-RpControllerObject -Property ConfigCommands
    }
}
