function Get-RpConfigPath {
    <#
    .SYNOPSIS
    Retrieves the path for RemotePro config uration file by using adapted logic from
    MilestonePSTools.

    .DESCRIPTION
    This function, Get-RPConfigurationPath, calls New-RpAppDataPath to get the
    app data directory and then appends 'RemoteProParamConfig.json'. It
    showcases path handling adaptations from MilestonePSTools, tailored for log
    file retrieval in RemotePro.

    .LINK
    https://www.milestonepstools.com/commands/en-US/Connect-Vms/#description
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param()

    process {
        Join-Path -Path (New-RpAppDataPath) -ChildPath 'RemoteProParamConfig.json'
    }
}
