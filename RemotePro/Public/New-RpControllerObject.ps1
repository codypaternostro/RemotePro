function New-RpControllerObject {
    <#
    .SYNOPSIS
    Creates a new ControllerObject for RemotePro.

    .DESCRIPTION
    The New-RpControllerObject cmdlet creates a new RemotePro object, which
    includesproperties like EventHandlers. This object is typed as `RemotePro`
    and can be used to manage various aspects of the RemotePro environment.

    .COMPONENT
    ControllerObject

    .PARAMETER Refresh
    Forces the creation of a new RemotePro ControllerObject even if one already
    exists.

    .EXAMPLE
    $remotePro = New-RpControllerObject

    This example creates a new RemotePro ControllerObject.

    .EXAMPLE
    $remotePro = New-RpControllerObject -Refresh

    This example forces the creation of a new RemotePro ControllerObject even
    if one already exists.

    .LINK
    https://www.remotepro.dev/en-US/New-RpControllerObject
    #>
    param (
        [Parameter()]
        [switch]$Refresh
    )

    # Check if $script:RemotePro already exists
    if (-not $script:RemotePro -or $Refresh) {
        $script:RemotePro = [PSCustomObject]@{
            EventHandlers           = @{}
            RunspaceEvents          = @{}
            ConfigCommands          = @{}
            ConfigCommandDefaultIds = @{}
            Settings                = @{}
        }

        # Add the RemotePro type to the object
        $script:RemotePro.PSTypeNames.Insert(0, 'RemotePro')

        if ($Refresh){
            Set-RpEventHandlers
            Set-RpRunspaceEvents
            Set-RpConfigCommands
            Set-RpDefaultConfigCommandIds
            Set-RpSettingsJson
        }

        Write-Host "New RemotePro ControllerObject created."
    } else {
        Write-Host "RemotePro ControllerObject already exists, skipping creation."
    }

    return $script:RemotePro
}
