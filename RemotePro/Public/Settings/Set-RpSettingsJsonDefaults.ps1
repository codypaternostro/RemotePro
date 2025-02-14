function Set-RpSettingsJsonDefaults {
    <#
    .SYNOPSIS
        Sets the default settings for RemotePro JSON configuration.

    .DESCRIPTION
        This cmdlet sets the default settings values for the RemotePro
        application JSON configuration. It ensures that all necessary settings are initialized
        with their default values.

    .PARAMETER SettingsFilePath
        The path to the settings JSON file where the default settings will
        be applied.

    .EXAMPLE
        PS C:\> Set-RpSettingsJsonDefaults -SettingsFilePath "C:\Config\RemoteProSettings.json"
        This example sets the default settings values in the specified settings JSON file.

    .INPUTS
        [string] The path to the settings JSON file where the default settings will be applied.

    .OUTPUTS
        None. This cmdlet does not produce any output.

    #>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [string]$SettingsFilePath
    )

    begin {
        if (-not $SettingsFilePath) {
            Write-Error "No settings file path provided."
            return
        }

        $DefaultSettings = @{
            "Setting1" = "Value1"
            "Setting2" = "Value2"
            # Add more default settings here
        }
    }

    process {
        try {
            if (-not (Test-Path -Path $SettingsFilePath)) {
                Write-Warning "Settings file not found. Creating a new settings file."
                $jsonContent = @{}
            } else {
                $jsonContent = Get-Content -Path $SettingsFilePath -Raw | ConvertFrom-Json
            }

            foreach ($key in $DefaultSettings.Keys) {
                $jsonContent[$key] = $DefaultSettings[$key]
            }

            $jsonContent | ConvertTo-Json -Depth 4 | Set-Content -Path $SettingsFilePath

            Write-Output "Default settings have been applied to $SettingsFilePath"
        }
        catch {
            Write-Error "An error occurred while setting the default settings: $($_.exception.message)"
        }
    }
    end {}
}
