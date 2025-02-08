function Get-RpConfigPath {
    <#
    .SYNOPSIS
    Retrieves the path for RemotePro configuration file by using adapted logic from
    MilestonePSTools.

    .DESCRIPTION
    This function, Get-RPConfigurationPath, calls New-RpAppDataPath to get the
    app data directory and then appends 'RemoteProParamConfig.json'. It
    showcases path handling adaptations from MilestonePSTools, tailored for log
    file retrieval in RemotePro.

    .COMPONENT
    ConfigCommands

    .PARAMETER DefaultIds
    If specified, retrieves the path for the default IDs configuration file.
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter()]
        [switch]$DefaultIds = $false
    )

    process {
        if ($DefaultIds) {
            Join-Path -Path (New-RpAppDataPath) -ChildPath 'RemoteProParamConfigDefaultIds.json'
        } else {
            Join-Path -Path (New-RpAppDataPath) -ChildPath 'RemoteProParamConfig.json'
        }
    }
}
