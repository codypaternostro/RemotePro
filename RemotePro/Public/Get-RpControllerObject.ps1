function Get-RpControllerObject {
    <#
    .SYNOPSIS
    Retrieves and optionally lists properties of the existing RemotePro
    ControllerObject.

    .DESCRIPTION
    The Get-RpControllerObject cmdlet retrieves the existing RemotePro object.
    It can either return the full object, list its properties, or show details
    of a specific property.

    .COMPONENT
    ControllerObject

    .PARAMETER ListProperties
    A switch parameter that, if specified, lists the properties of the
    RemotePro object.

    .PARAMETER Property
    The name of a specific property to display. If provided, the value of that
    property will be returned.

    .EXAMPLE
    Get-RpControllerObject

    This example retrieves the existing RemotePro ControllerObject and returns
    it.

    .EXAMPLE
    Get-RpControllerObject -ListProperties

    This example lists the properties of the existing RemotePro ControllerObject.

    .EXAMPLE
    Get-RpControllerObject -Property EventHandlers

    This example retrieves the value of the 'EventHandlers' property in the
    RemotePro ControllerObject.
    #>
    [CmdletBinding()]
    param (
        [switch]$ListProperties,

        [Parameter()]
        [ValidateSet("EventHandlers","RunspaceEvents","ConfigCommands","ConfigCommandDefaultIds","Settings")]
        [OutputType([PSCustomObject])]
        [string]$Property
    )

    process {
        # Check if $script:RemotePro exists
        if (-not $script:RemotePro) {
            Write-Host "RemotePro ControllerObject does not exist. Please initialize it first using New-RpControllerObject."
            return $null
        }

        # Handle listing properties
        if ($ListProperties) {
            Write-Host "Listing properties of the RemotePro ControllerObject:"
            return $script:RemotePro.PSObject.Properties.Name
        }

        # Handle returning a specific property
        if ($Property) {
            if ($script:RemotePro.PSObject.Properties[$Property]) {
                return $script:RemotePro.$Property
            } else {
                Write-Host "Property '$Property' does not exist in the RemotePro ControllerObject."
                return $null
            }
        }

        # Default: Return the full RemotePro object
        return $script:RemotePro
    }
}
