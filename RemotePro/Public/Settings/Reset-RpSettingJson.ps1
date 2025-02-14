function Reset-RpSettingJson {
    <#
    .SYNOPSIS
        Resets the RemotePro settings to default values.

    .DESCRIPTION
        This function removes existing settings files and creates a new default
        settings file for RemotePro.

        `Add-RpSettingJson` is called to populate the RemotePro settings file with
        default settings.

    .COMPONENT
    Settings

    .EXAMPLE
        Reset-RpSettingJson

    #>
    [CmdletBinding()]
    param()

    process {
        try {
            # Remove the settings file
            if (Test-Path -Path (Get-RpSettingsJsonPath)){
                Remove-Item -Path (Get-RpSettingsJsonPath)
            }

            if (-not (Test-Path -Path $(Get-RpSettingsJsonPath))){
                New-RpSettingJson
                Set-RpSettingsDefaults
            }

        }
        catch {
            Write-Error $_.Exception.Message
        }
    }
    end {}
}
