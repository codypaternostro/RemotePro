function Reset-RpSettingsJson {
    <#
    .SYNOPSIS
    Resets the RemotePro settings to default values.

    .DESCRIPTION
    This function removes existing settings files and creates a new default
    settings file for RemotePro.

    .COMPONENT
    Settings

    Add-RpSettingsJson is called to populate the RemotePro settings file with
    default settings.

    .COMPONENT
    Settings

    .EXAMPLE
    Reset-RpSettingJson

    .LINK
    https://www.remotepro.dev/en-US/Reset-RpSettingsJson
    #>
    [CmdletBinding()]
    param()

    process {
        try {
            # Remove the settings file
            if (Test-Path -Path (Get-RpSettingsJsonPath)){
                Remove-Item -Path (Get-RpSettingsJsonPath) -ErrorAction SilentlyContinue
            }

            if (-not (Test-Path -Path $(Get-RpSettingsJsonPath))){
                New-RpSettingsJson
                Set-RpSettingsJsonDefaults
            }

        }
        catch {
            Write-Error "An error occured while resetting json file: $($_.Exception.Message)"
        }
    }
    end {}
}
