function Import-RpSettingsJson {
    [CmdletBinding()]
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
        # Load the JSON configuration file into a string
        $settingsContent = Get-Content -Path $SettingsFilePath -Raw
        Write-Verbose "Config content loaded from file."

        # Convert the JSON string into a PowerShell object
        $settings = $settingsContent | ConvertFrom-Json
        Write-Verbose "Config successfully converted from JSON."

        # Return the final modules hashtable
        return $settings
    }
}
