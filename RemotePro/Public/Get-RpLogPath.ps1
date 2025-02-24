function Get-RpLogPath {
    <#
    .SYNOPSIS
    Retrieves the path for RemotePro log file by using adapted logic from
    MilestonePSTools.

    .DESCRIPTION
    This function, Get-RpLog, calls New-RpAppDataPath to get the app data
    directory and then appends 'RemoteProLog.txt'. It showcases path handling
    adaptations from MilestonePSTools, tailored for log file retrieval in
    RemotePro.

    .COMPONENT
    Log

    .EXAMPLE
    Get-RpLogPath

    This example retrieves the path for the RemotePro log file.

    .LINK
    https://www.milestonepstools.com/commands/en-US/Connect-Vms/#description

    .LINK
    https://www.remotepro.dev/en-US/Get-RpLogPath
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param()

    process {
        Join-Path -Path (New-RpAppDataPath) -ChildPath 'RemoteProLog.txt'
    }
}
