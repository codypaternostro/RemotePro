function Watch-RpRunspaces {
    <#
    .SYNOPSIS
    Monitors and manages runspaces running in the background.

    .DESCRIPTION
    This function iterates through the collection of runspace jobs and checks
    if they have completed. For completed jobs, it collects the results,
    logs the output, updates the UI (if provided), and safely removes the
    job from the global collection.

    .NOTES
    - The function relies on the following module variables and collections:
    - Initialize-RpRunspaceJobs $script:RunspaceJobs: Tracks each runspace dispatched.
    - Initialize-RpRunspaceResults $script:RunspaceResults: Collects results from runspaces.
    - Initialize-RpOpenRunspaces $script:openRunspaces: Static collection of active runspaces.

    - The log path is determined using the Get-RpLogPath cmdlet, which provides
    the path to the RemotePro AppData location.

    - UI updates rely on a TextBox control ($uiElement), where job and status messages
    are displayed. This UI element must be bound to "Runspace_Mutex_Log" for proper updates.

    .PARAMETER LogPath
    The path to the log file where job statuses and results are logged. This is mandatory.

    .PARAMETER uiElement
    The UI TextBox element that displays job statuses and messages. This is optional.

    .PARAMETER RunspaceJobs
    A synchronized ArrayList that tracks runspaces currently running in the background. This is mandatory.

    .PARAMETER RunspaceResults
    A synchronized ArrayList that stores the results from completed runspaces. This is mandatory.

    .PARAMETER OpenRunspaces
    A PSObject that holds static information about open runspaces and their jobs. This is mandatory.

    .EXAMPLE
    Watch-RpRunspaces -LogPath "C:\Logs\RunspaceLog.txt" -uiElement $textBoxElement -RunspaceJobs $script:RunspaceJobs -RunspaceResults $script:RunspaceResults -OpenRunspaces $script:openRunspaces

    .NOTES
    Runspace job collection and maintenance of runspaces running in the background.
    Log relies on .psm1 module manifest definition variable ...
    The cmdlet Get-RpLogPath for providing location to the RemotePro AppData location.
    UI relies on...
    [System.Windows.Controls.TextBox]$uiElement to be set to "Runspace_Mutex_Log" to update the UI
    Jobs indexing relies on...
    $script:RunspaceJobs = [System.Collections.ArrayList]::Synchronized((New-Object System.Collections.ArrayList))
    Results relies on...
    "$script:RunspaceResults = [System.Collections.ArrayList]::Synchronized((New-Object System.Collections.ArrayList))"
    If implemented, static runspaces from "$script:openRunspaces" which relies on...
    "$script:openRunspaces = New-Object PSObject -Property @{ Jobs = New-Object System.Collections.ObjectModel.ObservableCollection[object]}"
    #>

    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$LogPath,

        [Parameter()]
        [System.Windows.Controls.TextBox]$uiElement,

        [Parameter()]
        [System.Collections.ArrayList]$RunspaceJobs,

        [Parameter()]
        [System.Collections.ArrayList]$RunspaceResults,

        [Parameter()]
        [psobject]$OpenRunspaces
    )

    Foreach ($job in $RunspaceJobs.ToArray()) {  # Use ToArray() to avoid collection modification issues
        # Get an array of all RunspaceIds from the jobs stored in $script:openRunspaces.Jobs
        $storedRunspaceIds = $script:RpOpenRunspaces.Jobs | ForEach-Object { $_.RunspaceId }

        $OpenRunspaces.Jobs
        # Check if the job is completed and its runspaceId is NOT in the stored RunspaceIds
        if ($job.AsyncResult.IsCompleted -eq $True -and -not ($storedRunspaceIds -contains $job.runspaceId)) {
            try {
                Write-Host "$($_)"
                # replace GUID with runspace GUID
                #$rsGUID = Get-Runspace -InstanceId $job.RunspaceID
                # Get the output of the PowerShell job
                #$RSOutput = $job.PowerShell.EndInvoke($job.AsyncResult)
                $RunspaceResults.Add($job.PowerShell.EndInvoke($job.AsyncResult))

                # Get the index of the current output
                $currentIndex = $RunspaceResults.Count - 1

                # Display the current result in Out-GridView
                #$RunspaceResults[$currentIndex] | Out-GridView -Title "Runspace Result $currentIndex"

                # Convert the output to a string for logging
                $runspaceOutputString = $RunspaceResults[$currentIndex] | Out-String

                # Dispose of the PowerShell instance and runspace
                $job.PowerShell.Dispose()
                $job.Runspace.Dispose()


                # Generate a unique log identifier
                #$LogGuid = [System.Guid]::NewGuid().ToString()
                $LogGuid = $job.RunspaceID
                $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
                $script:logMessage = "$timestamp - INFO  - GUID: $LogGuid - Runspace output: $runspaceOutputString"
                $jobSuccessful = $true
            } catch {
                $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
                $LogGuid = $job.RunspaceID
                $logMessage = "$timestamp - ERROR - GUID: $LogGuid - Error managing runspace job: $_"
                $jobSuccessful = $false
            }

            # UI and Log message update
            Set-RpMutexLogAndUI -logPath $LogPath -message $logMessage -uiElement $uiElement

            # Critical section to safely remove the job from the global list
            [System.Threading.Monitor]::Enter($RunspaceJobs.SyncRoot)
            try {
                $RunspaceJobs.Remove($job)

                # Generate a log entry for job removal
                $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
                $removalStatus = if ($jobSuccessful) { "Job removed successfully." } else { "Job removed with error." }
                if ($jobSuccessful) {
                    $logRemovalMessage = "$timestamp - INFO  - GUID: $LogGuid - $removalStatus."
                } else {
                    $logRemovalMessage = "$timestamp - ERROR - GUID: $LogGuid - $removalStatus."
                }

                # UI and Log message update
                Set-RpMutexLogAndUI -logPath $LogPath -message $logRemovalMessage -uiElement $uiElement
            } finally {
                [System.Threading.Monitor]::Exit($RunspaceJobs.SyncRoot)
            }

            # Invoke garbage collection manually (ToDo: make this optional)
            [GC]::Collect()
            [GC]::WaitForPendingFinalizers()
        }
    }
}
