function New-RpControllerObject {
    <#
    .SYNOPSIS
    Creates a new ControllerObject for RemotePro.

    .DESCRIPTION
    The New-RpControllerObject cmdlet creates a new RemotePro object, which includes
    properties like EventHandlers. This object is typed as `RemotePro` and
    can be used to manage various aspects of the RemotePro environment.

    .EXAMPLE
    $remotePro = New-RpControllerObject

    This example creates a new RemotePro ControllerObject.
    #>

    # Check if $script:RemotePro already exists
    if (-not $script:RemotePro) {
        $script:RemotePro = [PSCustomObject]@{
            EventHandlers   = @{}
            RunspaceEvents  = @{}
            ConfigCommands  = @{}
        }

        # Add the RemotePro type to the object
        $script:RemotePro.PSTypeNames.Insert(0, 'RemotePro')

        Write-Host "New RemotePro ControllerObject created."
    } else {
        Write-Host "RemotePro ControllerObject already exists, skipping creation."
    }

    return $script:RemotePro
}
