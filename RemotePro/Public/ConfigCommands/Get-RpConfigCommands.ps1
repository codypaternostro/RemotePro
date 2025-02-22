function Get-RpConfigCommands {
    <#
    .SYNOPSIS
    Retrieves RemotePro configuration commands.

    .DESCRIPTION
    The Get-RpConfigCommands function retrieves configuration commands from
    the RemotePro controller object. If the -All switch is specified, it
    returns all configuration commands; otherwise, it returns the
    configuration commands as a single object.

    .COMPONENT
    ConfigCommands

    .PARAMETER All
    If specified, retrieves all configuration commands as an hashtable of values.

    .EXAMPLE
    Get-RpConfigCommands
    Retrieves the configuration commands as a single object.

    .EXAMPLE
    Get-RpConfigCommands -All
    Retrieves all configuration commands as an array of values.

    .OUTPUTS
    System.Collections.Hashtable

    .LINK
    https://www.remotepro.dev/en-US/Get-RpConfigCommands
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [switch]$All
    )

    process {
        try {
            if ($All){
                (Get-RpControllerObject -Property ConfigCommands).Values
            } else {
                Get-RpControllerObject -Property ConfigCommands
            }
        }
        catch {
            Write-Error $_.Exception.Message
        }
    }
    end {}
}
