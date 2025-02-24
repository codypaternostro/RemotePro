function Get-RpIconPath {
    <#
    .SYNOPSIS
    Retrieves the path for RemotePro icon file.

    .DESCRIPTION
    This function, Get-RpIconPath, calls module scope $script:scriptRoot
    path and then appends 'Resources\RpLogo512.ico'.

    .COMPONENT
    RemoteProGUI

    .EXAMPLE
    Get-RpIconPath

    This example retrieves the path for the RemotePro icon file.

    .LINK
    https://www.remotepro.dev/en-US/Get-RpIconPath
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param()

    process {
        Join-Path -Path ($script:scriptRoot) -ChildPath 'Resources\RpLogo512.ico'
    }
}
