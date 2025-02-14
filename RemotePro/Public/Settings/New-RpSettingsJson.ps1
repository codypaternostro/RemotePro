function New-RpSettingsJson {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string]$SettingsFilePath,

        [Parameter(Mandatory=$false)]
        [switch]$UseDefaults
    )

    process {
        if (-not ($SettingsFilePath)){
            $SettingsFilePath = Get-RpSettingsJsonPath
        }

        # Main object for settings.
        $settings = [pscustomobject]@{ Settings = @{} }

        if ($UseDefaults) {
            $settings = Set-RpSettingJsonDefaults
        }

        # Convert the settings object to JSON and save it to the specified file path
        $settingsJson = $settings | ConvertTo-Json -Depth 4
        Set-Content -Path $SettingsFilePath -Value $settingsJson
    }
    end{}
}
