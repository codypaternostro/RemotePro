
function Initialize-RpRunspaceResults {
    <#
    .SYNOPSIS
        Initializes a synchronized ArrayList to store runspace results.

    .DESCRIPTION
        This cmdlet creates a synchronized ArrayList to store and manage
        results from runspace jobs. The synchronized ArrayList ensures
        thread-safe operations when accessing the results from multiple
        runspaces.

    .EXAMPLE
        $runspaceResults = Initialize-RpRunspaceResults
        Write-Host "Initialized Runspace Results: $runspaceResults"

    .PARAMETER None
        This cmdlet takes no parameters.
    #>
    [CmdletBinding()]
    param ()

    # Initialize a synchronized ArrayList
    $script:RunspaceResults = [System.Collections.ArrayList]::Synchronized((New-Object System.Collections.ArrayList))

    Write-Verbose "Initialized synchronized RunspaceResults ArrayList."

    # Return the RunspaceResults ArrayList
    return $script:RunspaceResults
}
