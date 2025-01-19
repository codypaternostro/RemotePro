function Remove-RpConfigCommand {
    <#
    .SYNOPSIS
    Removes a configuration command from the RemotePro controller object.

    .DESCRIPTION
    The Remove-RpConfigCommand cmdlet removes a specified configuration command
    from the RemotePro controller object.

    .PARAMETER CommandName
    The name of the configuration command to remove. This parameter is mandatory
    and accepts pipeline input by property name.

    .EXAMPLE
    Remove-RpConfigCommand -CommandName "TestCommand"

    This command removes the configuration command named "TestCommand" from the
    RemotePro controller object.

    .INPUTS
    System.String

    .OUTPUTS
    System.Object
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$CommandName
    )

    process{
        # Todo: Add source for controllerObject and one for config
        $controllerObject = Get-RpControllerObject
        $controllerObject.ConfigCommands.Remove($CommandName)

        $script:RemotePro = $controllerObject

        return $script:RemotePro.ConfigCommands
    }
}
