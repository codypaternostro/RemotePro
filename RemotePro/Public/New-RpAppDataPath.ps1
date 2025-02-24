function New-RpAppDataPath {
    <#
    .SYNOPSIS
    Creates a directory for RemotePro app data, adapting logic from
    MilestonePSTools for path handling.

    .DESCRIPTION
    This function, New-RpAppDataPath, combines LOCALAPPDATA with a subdirectory
    specific to RemotePro. It ensures or creates this directory using modified
    item management techniques from MilestonePSTools. Returns the full path.
    See link for MilestonePSTool's explanation of AppData usage.

    .COMPONENT
    AppDataPath

    .EXAMPLE
    New-RpAppDataPath

    This example creates the RemotePro app data directory and returns the full path.

    .LINK
    https://www.milestonepstools.com/commands/en-US/Connect-Vms/#description

    .LINK
    https://www.remotepro.dev/en-US/New-RpAppDataPath
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param()

    process {
        $appDataRoot = Join-Path -Path $env:LOCALAPPDATA -ChildPath 'RemotePro\'
        (New-Item -Path $appDataRoot -ItemType Directory -Force).FullName
    }
}




