function Initialize-RpRunspaceJobs {
    <#
    .SYNOPSIS
    Initializes a synchronized ArrayList to manage runspace jobs.

    .DESCRIPTION
    This cmdlet creates a synchronized ArrayList to store and manage
    runspace jobs safely across multiple threads. It ensures thread-
    safe management of runspace jobs using the Synchronized method.

    .COMPONENT
    Runspaces

    .EXAMPLE
    $runspaceJobs = Initialize-RpRunspaceJobs
    Write-Host "Initialized Runspace Jobs: $runspaceJobs"

    .PARAMETER None
    This cmdlet takes no parameters.

    .LINK
    https://www.remotepro.dev/en-US/Initialize-RpRunspaceJobs
    #>
    [CmdletBinding()]
    param ()

    # Initialize a synchronized ArrayList for RunspaceJobs
    $script:RunspaceJobs = [System.Collections.ArrayList]::Synchronized((New-Object System.Collections.ArrayList))

    Write-Verbose "Initialized synchronized RunspaceJobs ArrayList."

    # Return the RunspaceJobs ArrayList
    return $script:RunspaceJobs
}
