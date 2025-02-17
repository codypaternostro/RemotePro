function New-RpSettingsJson {
    <#
    .SYNOPSIS
    Creates a new settings JSON file for RemotePro.

    .DESCRIPTION
    The New-RpSettingsJson function generates a new settings JSON file for
    RemotePro. It can either use a specified file path or determine the path
    automatically. Optionally, it can populate the settings with default values.

    .COMPONENT
    Settings

    .PARAMETER SettingsFilePath
    Specifies the file path where the settings JSON file will be saved. If not
    provided, the path is determined automatically.

    .PARAMETER UseDefaults
    If specified, the settings JSON will be populated with default values.

    .EXAMPLE
    New-RpSettingsJson -SettingsFilePath "C:\path\to\settings.json"

    Creates a new settings JSON file at the specified path.

    .EXAMPLE
    New-RpSettingsJson -UseDefaults

    Creates a new settings JSON file with default values at the automatically
    determined path.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string]$SettingsFilePath,

        [Parameter(Mandatory=$false)]
        [switch]$UseDefaults
    )

    process {
        try {
            if (-not ($SettingsFilePath)){
                $SettingsFilePath = Get-RpSettingsJsonPath
            }

            # Main object for settings.
            $settings = [pscustomobject]@{}

            if ($UseDefaults) {
                $settings = Set-RpSettingsJsonDefaults
            }

            # Convert the settings object to JSON and save it to the specified file path
            $settingsJson = $settings | ConvertTo-Json -Depth 4
            Set-Content -Path $SettingsFilePath -Value $settingsJson
        }
        catch {
            Write-Error "An error occurred while creating the settings JSON file: $($_.Exception.Message)"
        }
    }
    end{}
}
