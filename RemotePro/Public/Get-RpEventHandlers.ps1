function Get-RpEventHandlers {
    <#
    .SYNOPSIS
    Retrieves event handlers for the RemotePro connection profile UI.

    .DESCRIPTION
    The Get-RpEventHandlers cmdlet returns the code for various event
    handlers associated with the RemotePro connection profile UI.
    It retrieves handlers stored in the `RemotePro.EventHandlers` object.

    .COMPONENT
    EventHandlers

    .PARAMETER Name
    The name of the specific event handler to retrieve. This parameter is
    mutually exclusive with the All parameter.

    .PARAMETER All
    A switch parameter that, when specified, returns all event handlers.
    This parameter is mutually exclusive with the Name parameter.

    .EXAMPLE
    Get-RpEventHandlers

    This example returns all the event handlers defined in the script.

    .EXAMPLE
    Get-RpEventHandlers -Name "NewConnectionFile_Click"

    This example retrieves the event handler associated with the
    "New Connection File (.xlsx)" button click event.

    .EXAMPLE
    Get-RpEventHandlers -All

    This example returns all the event handlers defined in the script.

    .LINK
    https://www.remotepro.dev/en-US/Get-RpEventHandlers
    #>
    [CmdletBinding(DefaultParameterSetName = 'default')]
    param (
        [Parameter(Position = 0, ParameterSetName = 'ByName', Mandatory = $true)]
        [string]$Name,

        [Parameter(ParameterSetName = 'AllHandlers', Mandatory = $true)]
        [switch]$All
    )

    # Ensure RemotePro object is initialized
    if (-not $script:RemotePro -or -not $script:RemotePro.EventHandlers) {
        Write-Error "RemotePro Controller Object or EventHandlers are not initialized. Run New-RpControllerObject and Set-RpEventHandlers first."
        return
    }

    # Fetch the EventHandlers from the controller object
    $EventHandlers = $script:RemotePro.EventHandlers

    if ($PSCmdlet.ParameterSetName -eq 'ByName') {
        # Return a specific event by name
        if ($EventHandlers.ContainsKey($Name)) {
            return $EventHandlers[$Name]
        } else {
            Write-Error "No event handler found with the name '$Name'."
        }
    } elseif ($PSCmdlet.ParameterSetName -eq 'AllHandlers') {
        # Return the entire EventHandlers object
        return $EventHandlers
    } else {
        # Default to returning the full EventHandlers object
        return $EventHandlers
    }
}
