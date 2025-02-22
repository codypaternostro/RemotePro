function Start-RpRunspaceMonitor {
    <#
    .SYNOPSIS
    Experienced issues calling this command. The function is not used in the
    module yet. Starts a monitor for runspaces with a specified interval.

    .DESCRIPTION
    Experienced issues calling this command. The function is not used in the
    module yet.
    The Start-RpRunspaceMonitor function initializes and starts a timer that
    periodically checks the status of runspaces. It uses the Watch-RpRunspaces
    function to perform the monitoring tasks. The timer interval is set to 2
    seconds.

    .PARAMETER LogPath
    Specifies the path to the log file where runspace monitoring information
    will be recorded.

    .PARAMETER uiElement
    Specifies the UI element (TextBox) where runspace monitoring information
    will be displayed.

    .PARAMETER RunspaceJobs
    Specifies the collection of runspace jobs to be monitored.

    .PARAMETER RunspaceResults
    Specifies the collection of runspace results to be monitored.

    .PARAMETER OpenRunspaces
    Specifies the collection of open runspaces. This parameter is optional.

    .EXAMPLE
    $timer = Start-RpRunspaceMonitor -LogPath "C:\Logs\runspace.log" `
        -uiElement $textBox -RunspaceJobs $jobs -RunspaceResults $results

    This example starts the runspace monitor with the specified log path, UI
    element, runspace jobs, and runspace results. The timer object is stored
    in the $timer variable.

    .NOTES
    Experienced issues calling this command. The function is not used in the
    module yet.

    .LINK
    #>
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
