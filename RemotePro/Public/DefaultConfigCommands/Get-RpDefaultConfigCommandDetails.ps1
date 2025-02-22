function Get-RpDefaultConfigCommandDetails {
    <#
    .SYNOPSIS
    Retrieves the default configuration commands from the RemotePro controller
    object.

    .DESCRIPTION
    The Get-RpDefaultConfigCommands function is used to retrieve the default
    configuration commands from the RemotePro controller object. It utilizes the
    Get-RpControllerObject cmdlet to fetch the property ConfigCommandDefaultIds.

    .COMPONENT
    DefaultConfigCommands

    .EXAMPLE
    Get-RpDefaultConfigCommands

    .LINK
    https://www.remotepro.dev/en-US/Get-RpDefaultConfigCommands
    #>
    [CmdletBinding()]
    param()

    begin {
        Get-RpControllerObject -Property ConfigCommandDefaultIds
    }
}
