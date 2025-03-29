function New-RpShortcut {
    <#
    .SYNOPSIS
    Creates or deletes a RemotePro shortcut that runs Start-RpRemotePro using Windows PowerShell.

    .DESCRIPTION
    This function creates a shortcut to Start-RpRemotePro using powershell.exe.
    It will skip creation if the shortcut already exists.
    Use the -DeleteShortcut switch to remove the shortcut instead.

    .PARAMETER ShortcutName
    Optional name of the shortcut file. Defaults to "RemotePro.lnk".

    .PARAMETER IconPath
    Optional path to a custom .ico file. Defaults to Get-RpIconPath.

    .PARAMETER ShortcutPath
    Optional path or folder. If not specified, defaults to the Desktop.

    .PARAMETER DeleteShortcut
    If specified, deletes the shortcut instead of creating it.

    .EXAMPLE
    New-RpShortcut

    Creates "Remote Pro.lnk" on Desktop if it doesn’t already exist.

    .EXAMPLE
    New-RpShortcut -DeleteShortcut

    Deletes "RemotePro.lnk" from Desktop if it exists.

    .EXAMPLE
    New-RpShortcut -ShortcutName "MyTool.lnk" -ShortcutPath "C:\Links" -DeleteShortcut

    Deletes C:\Links\MyTool.lnk

    .LINK
    https://www.remotepro.dev/en-US/New-RpShortcut
    #>

    [CmdletBinding()]
    param (
        [string]$ShortcutName = "Remote Pro.lnk",
        [string]$IconPath,
        [string]$ShortcutPath,
        [switch]$DeleteShortcut
    )

    # Determine base location (Desktop if not specified)
    if (-not $ShortcutPath) {
        $ShortcutPath = [Environment]::GetFolderPath("Desktop")
    }

    # Final shortcut full path logic
    if ($ShortcutPath -like '*.lnk') {
        $fullShortcutPath = $ShortcutPath
    } else {
        $fullShortcutPath = Join-Path $ShortcutPath $ShortcutName
    }

    if ($DeleteShortcut) {
        if (Test-Path $fullShortcutPath) {
            Remove-Item $fullShortcutPath -Force
            Write-Warning "Shortcut deleted: $fullShortcutPath"
        } else {
            Write-Verbose "Shortcut does not exist. Nothing to delete."
        }
        return
    }

    # If already exists, do nothing
    if (Test-Path $fullShortcutPath) {
        Write-Verbose "Shortcut already exists: $fullShortcutPath"
        return
    }

    # Resolve icon path
    if (-not $IconPath) {
        try {
            $IconPath = Get-RpIconPath
            Write-Verbose "Using default icon: $IconPath"
        } catch {
            Write-Warning "Could not resolve default icon path. No icon will be set."
            $IconPath = $null
        }
    }

    # Prepare PowerShell execution string
    $command = '-NoExit -Command "Start-RpRemotePro"'

    try {
        $wshell = New-Object -ComObject WScript.Shell
        $shortcut = $wshell.CreateShortcut($fullShortcutPath)

        $shortcut.TargetPath = "powershell.exe"
        $shortcut.Arguments  = $command

        if ($IconPath -and (Test-Path $IconPath)) {
            $shortcut.IconLocation = $IconPath
        }

        $shortcut.Save()
        Write-Warning "Shortcut created: $fullShortcutPath" -ForegroundColor Green
    } catch {
        Write-Error "Failed to create shortcut: $_"
    }
}
