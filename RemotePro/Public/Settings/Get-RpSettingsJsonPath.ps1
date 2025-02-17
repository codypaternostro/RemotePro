function Get-RpSettingsJsonPath {
    <#
    .SYNOPSIS
    Retrieves the file path for the RemotePro settings JSON file.

    .DESCRIPTION
    The Get-RpSettingsJsonPath function constructs and returns the file path for the
    RemoteProSettings.json file located in the 'Settings' directory within the
    application data path. If the 'Settings' directory does not exist, it is created.

    .COMPONENT
    Settings

    .OUTPUTS
    System.String
    The file path to the RemoteProSettings.json file.

    .EXAMPLE
    Get-RpSettingsJsonPath
    C:\Users\<User>\AppData\Local\RemotePro\Settings\RemoteProSettings.json
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param()

    process {
        try {
            $configDirectory = Join-Path -Path (New-RpAppDataPath) -ChildPath 'Settings'

            if (-not (Test-Path -Path $configDirectory)) {
                New-Item -Path $configDirectory -ItemType Directory | Out-Null
            }

            Join-Path -Path $configDirectory -ChildPath 'RemoteProSettings.json'
        }
        catch {
            Write-Error "An error occurred while retrieving the settings JSON path: $($_.Exception.Message)"
        }
    }
    end{}
}
