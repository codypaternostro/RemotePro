function Find-RpSettingsJson {
    <#
    .SYNOPSIS
    Retrieves settings from the RemotePro Settings JSON file.

    .DESCRIPTION
    The Find-RpSettingsJson function retrieves specific settings or all settings
    from the RemotePro Settings JSON file. If no file path is provided, it uses
    the default path from Get-RpSettingsJsonPath.

    .COMPONENT
    Settings
    .PARAMETER SettingsFilePath
    The path to the RemotePro Settings JSON file. If not provided, the default
    path is used.

    .PARAMETER Name
    The name of the setting to retrieve from the JSON file.

    .PARAMETER All
    Switch to retrieve all settings from the JSON file.

    .EXAMPLE
    Find-RpSettingsJson -SettingsFilePath (Get-RpSettingsJsonPath) -Name "SettingName"

    Retrieves the specified setting from the default JSON file path.

    .EXAMPLE
    Find-RpSettingsJson -SettingsFilePath "C:\path\to\settings.json" -Name "SettingName"

    Retrieves the specified setting from the provided JSON file path.

    .EXAMPLE
    Find-RpSettingsJson -All

    Retrieves all settings from the default JSON file path.

    .LINK
    https://www.remotepro.dev/en-US/Find-RpSettingsJson
    #>
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param (
        # Path to the RemotePro Settings JSON file
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'All')]
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'ByName')]
        [string]$SettingsFilePath,

        # The name of the setting to retrieve
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'ByName')]
        [string]$Name,

        # Retrieve all settings
        [Parameter(Mandatory=$false, ParameterSetName = 'All')]
        [switch]$All
    )

    begin {
        # Use appdata path if there is not a filepath value.
        if (-not ($SettingsFilePath)){
            $SettingsFilePath = Get-RpSettingsJsonPath
        }
    }

    process {
        try {
            # Load the configuration
            $settingsContent = Get-Content -Path $SettingsFilePath -Raw
            $settings = $settingsContent | ConvertFrom-Json

            # Retrieve all settings across all modules
            if ($PSCmdlet.ParameterSetName -eq 'All') {
                return $settings
            }

            # Check if the setting exists
            if (-not ($settings.$Name)) {
                Write-Error "Setting '$Name' not found in configuration."
                return
            }

            # Check if the setting exists
            $settingDetails = $settings | Select-Object -Property $Name

            if (-not $settingDetails) {
                Write-Error "Setting '$Name' not found."
                return
            }

            # Return the setting details
            return $settingDetails
        } catch {
            Write-Error $_.Exception.Message
        }
    }
    end {}
}
