function Get-RpSettingsJsonPath {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    process {
        $configDirectory = Join-Path -Path (New-RpAppDataPath) -ChildPath 'Settings'

        if (-not (Test-Path -Path $configDirectory)) {
            New-Item -Path $configDirectory -ItemType Directory | Out-Null
        }

        Join-Path -Path $configDirectory -ChildPath 'RemoteProSettings.json'
    }
}

