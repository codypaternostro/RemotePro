function Get-RpRunspaceEvents {
    <#
    .SYNOPSIS
    Retrieves runspace events for the RemotePro connection profile UI.

    .DESCRIPTION
    The Get-RpRunspaceEvents cmdlet returns the code for various event handlers
    associated with the RemotePro connection profile UI. It retrieves handlers
    stored in the RemotePro.RunspaceEvents object.

    .PARAMETER Name
    Retrieves a specific runspace event by its name.

    .PARAMETER All
    Returns all runspace events as a custom object with a specific type.

    .EXAMPLE
    Get-RpRunspaceEvents

    This example returns all the runspace events as a custom object.

    .EXAMPLE
    Get-RpRunspaceEvents -Name "Hardware_Click"

    This example retrieves the runspace event associated with the "Hardware_Click" button click event.
    #>

    [CmdletBinding(DefaultParameterSetName = 'default')]
    param (
        [Parameter(Position = 0, ParameterSetName = 'ByName', Mandatory = $true)]
        [string]$Name,

        [Parameter(ParameterSetName = 'AllEvents', Mandatory = $true)]
        [switch]$All
    )

    # Ensure RemotePro object is initialized
    if (-not $script:RemotePro -or -not $script:RemotePro.RunspaceEvents) {
        Write-Error "RemotePro Controller Object or RunspaceEvents are not initialized. Run New-RpControllerObject and Set-RpRunspaceEvents first."
        return
    }

    # Fetch the RunspaceEvents from the controller object
    $runspaceEvents = $script:RemotePro.RunspaceEvents

    if ($PSCmdlet.ParameterSetName -eq 'ByName') {
        # Return a specific event by name
        if ($runspaceEvents.ContainsKey($Name)) {
            return $runspaceEvents[$Name]
        } else {
            Write-Error "No runspace event found with the name '$Name'."
        }
    } elseif ($PSCmdlet.ParameterSetName -eq 'AllHandlers') {
        # Return the entire RunspaceEvents object
        return $runspaceEvents
    } else {
        # Default to returning the full RunspaceEvents object
        return $runspaceEvents
    }
}
