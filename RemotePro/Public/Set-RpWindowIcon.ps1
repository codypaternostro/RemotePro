function Set-RpWindowIcon {
    <#
    .SYNOPSIS
    Sets the icon for a specified WPF window and its taskbar item.

    .DESCRIPTION
    The Set-RpWindowIcon function sets the icon for a given WPF window and its
    taskbar item using the specified icon file path. It ensures the icon file
    exists, loads the icon, and applies it to both the window and the taskbar
    item. If the TaskbarItemInfo object does not exist, it creates one. If
    icon path is not provided, it uses the default icon path from
    Get-RpIconPath. Additonally, if the icon file is not found, the function
    returns without setting the icon.


    .PARAMETER window
    The WPF window object for which the icon will be set. This parameter is
    mandatory.

    .PARAMETER IconPath
    The file path to the icon image. This parameter is mandatory.

    .EXAMPLE
    Set-RpWindowIcon -window $mainWindow -IconPath "$(Get-RpIconPath)"
    Sets the icon for the $mainWindow to the specified icon file.

    .LINK
    https://www.remotepro.dev/en-US/Set-RpWindowIcon
    #>
    param (
        [Parameter(Mandatory=$true)]
        [System.Windows.Window]$window,

        [Parameter()]
        [string]$IconPath
    )

    if (-not (Test-Path $IconPath)) {
        Write-Warning "Using default icon path form Get-RpIconPath"
        $IconPath = Get-RpIconPath
    }
    else {
        Write-Warning "Icon file not found, icon will not be loaded."
        return
    }

    try {
        # Load icon from file
        Write-Verbose "Loading icon from: $IconPath"
        $bitmap = New-Object System.Windows.Media.Imaging.BitmapImage
        $bitmap.BeginInit()
        $bitmap.UriSource = New-Object System.Uri($IconPath, [System.UriKind]::Absolute)
        $bitmap.EndInit()
        $bitmap.Freeze()

        # Set window icon
        $window.Icon = $bitmap
        Write-Verbose "Window icon set successfully!"

        # Ensure TaskbarItemInfo exists
        if (-not $window.TaskbarItemInfo) {
            $window.TaskbarItemInfo = New-Object System.Windows.Shell.TaskbarItemInfo
            Write-Verbose "Created TaskbarItemInfo object"
        }

        # Set taskbar icon & description
        $window.TaskbarItemInfo.Overlay = $bitmap
        $window.TaskbarItemInfo.Description = $window.Title
        Write-Verbose "Taskbar icon updated!"

    } catch {
        Write-Error "Failed to set window/taskbar icon: $_"
    }
}
