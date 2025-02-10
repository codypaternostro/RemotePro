function Start-RpRunspaceJobStatic {
    <#
    .SYNOPSIS
    Starts static runspace jobs and tracks them in a global collection.

    .DESCRIPTION
    This cmdlet starts multiple static runspace jobs. Each job is defined
    with a JobName and JobDetailsVariableName, ensuring consistent and
    predictable job handling. The job details (including JobName, Runspace
    ID, and Instance ID) are added to a global collection
    ($script:RpOpenRunspaces.Jobs) for tracking.

    .COMPONENT
    Runspaces

    .PARAMETER Jobs
    An array of job definitions. Each job definition is a hashtable with
    the following keys:
    - **JobName**: A string that defines the name of the job.
    - **JobDetailsVariableName**: The variable name for the job details.
    - **Description**: A string describing the job's purpose.
    - **ScriptBlock**: The code that will be executed within the runspace.

    .PARAMETER uiElement
    A `System.Windows.Controls.TextBox` used to pass logs from the runspace job.

    .PARAMETER OpenRunspaces
    A collection (ObservableCollection) that stores the details of all
    runspace jobs.

    .PARAMETER RunspaceJobs
    Optional. An ArrayList that tracks individual runspace jobs.

    .EXAMPLE
    Define the jobs to run
    $jobsToRun = @(
        @{
            JobName                = "VmsCameraReportJob"
            JobDetailsVariableName = "VmsCameraReportJobDetails"
            Description            = "Fetches the VMS Camera Report"
            ScriptBlock            = { Write-Host "Fetching VMS Camera Report..." }
        },
        @{
            JobName                = "ShowCameraJob"
            JobDetailsVariableName = "ShowCameraJobDetails"
            Description            = "Displays the camera feed"
            ScriptBlock            = { Write-Host "Displaying Camera Feed..." }
        }
    )

    Start the runspace jobs
    $script:RpOpenRunspaces = Start-RpRunspaceJobStatic
        -Jobs $jobsToRun
        -uiElement $script:Runspace_Mutex_Log
        -OpenRunspaces $script:RpOpenRunspaces
        -RunspaceJobs $script:RunspaceJobs
        -Verbose

    This will start two jobs: one to fetch a VMS camera report and
    another to display the camera feed. The job details will be stored
    in $script:RpOpenRunspaces.Jobs.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [array]$Jobs,

        [Parameter(Mandatory = $true)]
        [System.Windows.Controls.TextBox]$uiElement,

        [Parameter(Mandatory = $true)]
        [System.Collections.ObjectModel.ObservableCollection[object]]$OpenRunspaces,

        [Parameter(Mandatory = $false)]
        [System.Collections.ArrayList]$RunspaceJobs
    )

    # Loop through each job definition and start runspace jobs
    foreach ($job in $Jobs) {
        if ($job.JobName -and $job.JobDetailsVariableName -and $job.Description) {
            $jobName = $job.JobName
            $jobDetails = $job.JobDetailsVariableName
            Write-Verbose "Starting job: $($job.Description) with name $jobName"

            # Start the runspace job and store the result in a variable
            $runspace = Start-RpRunspaceJob -ScriptBlock $job.ScriptBlock -uiElement $uiElement -RunspaceJobs $RunspaceJobs

            # Create a jobDetails object to track this runspace job's metadata
            $jobDetails = [PSCustomObject] @{
                JobName     = $jobName
                Description = "$($job.Description)"
                Runspace    = $runspace
                ID          = $runspace.runspace.id
                RunspaceId  = $runspace.runspace.instanceId
            }

            # Add the job details object to the global runspace jobs collection
            $script:RpOpenRunspaces.Jobs.Add($jobDetails)
        }
        else {
            Write-Warning "Job name, job details variable name, or description"
            Write-Warning "missing. Skipping job."
        }
    }

    # Return the global runspace jobs collection
    Write-Verbose "Static runspace jobs created"
    return $script:RpOpenRunspaces
}
