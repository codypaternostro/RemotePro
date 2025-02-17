function Get-RpSettings {
    <#
    .SYNOPSIS
    Retrieves RemotePro settings.

    .DESCRIPTION
    The Get-RpSettings function retrieves the settings from the RemotePro
    controller object. If the -All switch is specified, it returns all
    settings values; otherwise, it returns the settings object.

    .COMPONENT
    Settings

    .PARAMETER All
    If specified, returns all settings values.

    .EXAMPLE
    Get-RpSettings
    Retrieves the settings object from the RemotePro controller.

    .EXAMPLE
    Get-RpSettings -All
    Retrieves all settings values from the RemotePro controller.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [switch]$All
    )

    process {
        try {
            if ($All){
                (Get-RpControllerObject -Property Settings).Values
            } else {
                Get-RpControllerObject -Property Settings
            }
        }
        catch {
            Write-Error $_.Exception.Message
        }
    }
    end {}
}
