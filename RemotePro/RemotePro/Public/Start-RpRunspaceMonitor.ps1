function Start-RpRunspaceMonitor {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$LogPath,

        [Parameter(Mandatory=$true)]
        [System.Windows.Controls.TextBox]$uiElement,

        [Parameter(Mandatory=$true)]
        [System.Collections.ArrayList]$RunspaceJobs,

        [Parameter(Mandatory=$true)]
        [System.Collections.ArrayList]$RunspaceResults,

        [Parameter(Mandatory=$false)]
        [psobject]$OpenRunspaces
    )

    # Timer setup
    $RunspaceCleanupTimer = New-Object System.Windows.Forms.Timer
    $RunspaceCleanupTimer.Interval = 2000  # 2 seconds

    # Add Tick event handler for the timer
    $RunspaceCleanupTimer.Add_Tick({
        Watch-RpRunspaces `
            -LogPath $LogPath `
            -uiElement $uiElement `
            -RunspaceJobs $RunspaceJobs `
            -RunspaceResults $RunspaceResults `
            -OpenRunspaces $OpenRunspaces
    })

    # Start the timer
    $RunspaceCleanupTimer.Start()

    Write-Verbose "Runspace monitor started with an interval of 2 seconds."

    # Return the timer object so it can be managed later if needed
    return $RunspaceCleanupTimer
}
