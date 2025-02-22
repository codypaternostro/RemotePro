function Set-RpSettingsJsonDefaults {
    <#
    .SYNOPSIS
    Sets the default settings for RemotePro JSON configuration.

    .DESCRIPTION
    This cmdlet sets the default settings values for the RemotePro
    application JSON configuration. It ensures that all necessary settings are initialized
    with their default values.

    .COMPONENT
    Settings

    .PARAMETER SettingsFilePath
    The path to the settings JSON file where the default settings will
    be applied.

    .EXAMPLE
    Set-RpSettingsJsonDefaults -SettingsFilePath "C:\Config\RemoteProSettings.json"
    This example sets the default settings values in the specified settings JSON file.

    .INPUTS
    [string] The path to the settings JSON file where the default settings will be applied.

    .OUTPUTS
    None. This cmdlet does not produce any output.

    .LINK
    https://www.remotepro.dev/en-US/Set-RpSettingsJsonDefaults
    #>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [string]$SettingsFilePath
    )

    begin {
        if (-not $SettingsFilePath) {
            $SettingsFilePath = Get-RpSettingsJsonPath
            Write-Warning "No settings file path provided. Using $SettingsFilePath"

        }

        $DefaultSettings = @{
            "RemoteProSettingsFilePath" = "$(Get-RpSettingsJsonPath)"
            "Setting2" = "Value2"
            # Add more default settings here
        }
    }

    process {
        try {
            if (-not (Test-Path -Path $SettingsFilePath)) {
                Write-Warning "Settings file not found. Creating a new settings file."
                New-RpSettingsJson
            }

            $jsonContent = Get-Content -Path $SettingsFilePath -Raw | ConvertFrom-Json

            foreach ($key in $DefaultSettings.Keys) {
                $jsonContent | Add-Member -MemberType NoteProperty -Name $Key -Value $DefaultSettings[$Key] -Force
            }

            $jsonContent | ConvertTo-Json -Depth 4 | Set-Content -Path $SettingsFilePath

            Write-Output "Default settings have been applied to $SettingsFilePath"
        }
        catch {
            Write-Error "An error occurred while setting the default settings: $_"
        }
    }
    end {}
}
