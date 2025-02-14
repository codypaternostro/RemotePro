function Find-RpSettingsJson {
    [CmdletBinding()]
    param (
        # Path to the RemotePro Settings JSON file
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName = $true)]
        [string]$SettingsFilePath,

        # The name of the setting to retrieve
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName = $true)]
        [string]$Name,

        # Retrieve all settings
        [Parameter(Mandatory=$false)]
        [switch]$All
    )

    begin {
        # Use appdata path if there is not a filepath value.
        if (-not ($SettingsFilePath)){
            $SettingsFilePath = Get-RpSettingsJsonPath
        }
    }

    process {
        # Load the configuration
        $settingsContent = Get-Content -Path $SettingsFilePath -Raw
        $settings = $settingsContent | ConvertFrom-Json

        # Retrieve all settings across all modules
        if ($All) {
            return $settings.Settings
        }

        # Check if the setting exists
        if (-not $setting.Settings) {
            Write-Error "Setting '$name' not found in configuration."
            return
        }

        # Check if the setting exists
        $settingDetails = $config.Settings | Where-Object { $_.Name -eq $name }

        if (-not $settingDetails) {
            Write-Error "setting '$settingName' not found."
            return
        }

        # Return the setting details
        return $settings
    }
    end {}
}
