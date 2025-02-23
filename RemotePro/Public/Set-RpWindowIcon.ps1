function Set-RpWindowIcon {
    <#
    .SYNOPSIS
    Sets the icon for a specified WPF window and its taskbar item.

    .DESCRIPTION
    This function sets the icon for a WPF window using either a file path or a memory stream.
    It prioritizes the provided MemoryStream and falls back to IconPath if needed.
    If both are missing, it attempts to use a module-scoped MemoryStream @ $script:RpIconStream.

    .PARAMETER Window
    The WPF window object for which the icon will be set.

    .PARAMETER MemoryStream
    The memory stream containing the icon image.

    .PARAMETER IconPath
    The file path to the icon image.

    .EXAMPLE
    Set-RpWindowIcon -window $mainWindow -IconPath (Get-RpIconPath)

    Uses the provided icon file path.

    .EXAMPLE
    Set-RpWindowIcon -window $mainWindow -MemoryStream $iconStream

    Uses the provided memory stream.

    .EXAMPLE
    Set-RpWindowIcon -window $mainWindow

    Uses the default module-scoped memory stream $script:RpIconStream.

    .LINK
    https://www.remotepro.dev/en-US/Set-RpWindowIcon
    #>
    param (
        [Parameter(Mandatory = $true)]
        [System.Windows.Window]$Window,

        [Parameter()]
        [System.IO.MemoryStream]$MemoryStream,

        [Parameter()]
        [string]$IconPath
    )

    process {
        try {
            # If no memory stream is provided, attempt to use IconPath
            if (-not $MemoryStream) {
                if (-not $IconPath) {
                    Write-Verbose "No MemoryStream or IconPath provided. Using default icon path from Get-RpIconPath."
                    $IconPath = Get-RpIconPath
                }

                if (-not (Test-Path $IconPath)) {
                    Write-Verbose "Icon file not found at '$IconPath'. Icon will not be set."
                    return
                }

                # Load the icon into the module-scoped memory stream
                Write-Verbose "Loading icon from file: $IconPath"
                [System.IO.File]::OpenRead($IconPath).CopyTo($script:RpIconStream)
                $MemoryStream = $script:RpIconStream
            }

            # Ensure the memory stream has valid data
            if (-not $MemoryStream -or $MemoryStream.Length -eq 0) {
                Write-Warning "MemoryStream is empty. Icon will not be set."
                return
            }

            # Reset memory stream position before reading
            $MemoryStream.Position = 0

            # Load the bitmap from memory
            $bitmap = New-Object System.Windows.Media.Imaging.BitmapImage
            $bitmap.BeginInit()
            $bitmap.StreamSource = $MemoryStream # Defaults to module scope object in RemotePro.psm1
            $bitmap.CacheOption = [System.Windows.Media.Imaging.BitmapCacheOption]::OnLoad
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
}
