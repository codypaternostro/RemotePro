function Get-RpIconPath {
    <#
    .SYNOPSIS
    Retrieves the path for RemotePro icon file.

    .DESCRIPTION
    This function, Get-RpIconPath, calls New-RpAppDataPath to get the app data
    directory and then appends 'Resources\RpLogo512.ico'.

    .COMPONENT
    RemoteProGUI

    .LINK
    https://www.remotepro.dev/en-US/Get-RpIconPath
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param()

    process {
        Join-Path -Path (New-RpAppDataPath) -ChildPath 'Resources\RpLogo512.ico'
    }
}
