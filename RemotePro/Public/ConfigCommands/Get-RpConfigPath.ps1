function Get-RpConfigPath {
    <#
    .SYNOPSIS
    Retrieves the path for RemotePro configuration file by using adapted logic from
    MilestonePSTools.

    .DESCRIPTION
    This function, Get-RpConfigurationPath, calls New-RpAppDataPath to get the
    app data directory and then appends 'RemoteProParamConfig.json'. It
    showcases path handling adaptations from MilestonePSTools, tailored for log
    file retrieval in RemotePro.

    .COMPONENT
    ConfigCommands

    .PARAMETER DefaultIds
    If specified, retrieves the path for the default IDs configuration file.

    .LINK
    https://www.remotepro.dev/en-US/Get-RpConfigPath
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter()]
        [switch]$DefaultIds = $false
    )

    process {
        $configDirectory = Join-Path -Path (New-RpAppDataPath) -ChildPath 'Config'

        if (-not (Test-Path -Path $configDirectory)) {
            New-Item -Path $configDirectory -ItemType Directory | Out-Null
        }

        if ($DefaultIds) {
            Join-Path -Path $configDirectory -ChildPath 'RemoteProParamConfigDefaultIds.json'
        } else {
            Join-Path -Path $configDirectory -ChildPath 'RemoteProParamConfig.json'
        }
    }
}
