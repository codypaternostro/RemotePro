function Import-RpSettingsFromJson {
    <#
    .SYNOPSIS
    Imports settings from a JSON configuration file.

    .DESCRIPTION
    The Import-RpSettingsFromJson function reads a JSON configuration file from the
    specified path and converts it into a hashtable. If no path is provided,
    it uses a default path obtained from Get-RpSettingsJsonPath.

    .COMPONENT
    Settings

    .PARAMETER SettingsFilePath
    The path to the JSON configuration file. If not provided, a default path is used.

    .EXAMPLE
    Import-RpSettingsFromJson -SettingsFilePath "$(Get-RpSettingsJsonPath)"
    This command imports settings from the specified JSON file.

    .EXAMPLE
    Import-RpSettingsFromJson
    This command imports settings from the default JSON file path.

    .LINK
    https://www.remotepro.dev/en-US/Import-RpSettingsFromJson
    #>
    [CmdletBinding()]
    [OutputType([hashtable])]
    param (
        [string]$SettingsFilePath    # Path to the configuration JSON file
    )

    begin {
        # Use appdata path if there is not a filepath value.
        if (-not ($SettingsFilePath)){
            $SettingsFilePath = Get-RpSettingsJsonPath
        }
    }

    process {
        try {
            # Load the JSON configuration file into a string
            $settingsContent = Get-Content -Path $SettingsFilePath -Raw
            Write-Verbose "Config content loaded from file."

            # Convert the JSON string into a PowerShell object
            $settings = $settingsContent | ConvertFrom-Json
            Write-Verbose "Config successfully converted from JSON."

            # Convert the PowerShell object to a hashtable
            $settingsHashtable = @{}
            $settings.PSObject.Properties | ForEach-Object {
                $settingsHashtable[$_.Name] = $_.Value
            }
            Write-Verbose "Config successfully converted to hashtable."

            # Return the final modules hashtable
            return $settingsHashtable
        } catch {
            Write-Error "An error occurred obtaining settings file: $($_.Exception.Message)"
        }
    }
    end {}
}
