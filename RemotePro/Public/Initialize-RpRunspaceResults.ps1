function Initialize-RpRunspaceResults {
    <#
    .SYNOPSIS
    Initializes a synchronized ArrayList to store runspace results.

    .DESCRIPTION
    This cmdlet creates a synchronized ArrayList to store and manage
    results from runspace jobs. The synchronized ArrayList ensures
    thread-safe operations when accessing the results from multiple
    runspaces.

    .COMPONENT
    Runspaces

    .EXAMPLE
    $runspaceResults = Initialize-RpRunspaceResults
    Write-Host "Initialized Runspace Results: $runspaceResults"

    This example initializes the synchronized ArrayList for runspace
    results and assigns it to the module scope runspace results variable,
    $script:RunspaceResults.

    .PARAMETER None
    This cmdlet takes no parameters.

    .LINK
    https://www.remotepro.dev/en-US/Initialize-RpRunspaceResults
    #>
    [CmdletBinding()]
    param ()

    # Initialize a synchronized ArrayList
    $script:RunspaceResults = [System.Collections.ArrayList]::Synchronized((New-Object System.Collections.ArrayList))

    Write-Verbose "Initialized synchronized RunspaceResults ArrayList."

    # Return the RunspaceResults ArrayList
    return $script:RunspaceResults
}
