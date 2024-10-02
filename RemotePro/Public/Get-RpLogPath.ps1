function Get-RPLogPath {
    <#
    .SYNOPSIS
    Retrieves the path for RemotePro log file by using adapted logic from
    MilestonePSTools.

    .DESCRIPTION
    This function, Get-RPLog, calls New-RPDataAppPath to get the app data
    directory and then appends 'RemoteProLog.txt'. It showcases path handling
    adaptations from MilestonePSTools, tailored for log file retrieval in
    RemotePro.

    .LINK
    https://www.milestonepstools.com/commands/en-US/Connect-Vms/#description
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param()

    process {
        Join-Path -Path (New-RPDataAppPath) -ChildPath 'RemoteProLog.txt'
    }
}
