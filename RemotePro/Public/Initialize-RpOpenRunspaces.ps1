function Initialize-RpOpenRunspaces {
    <#
    .SYNOPSIS
    Initializes an object to manage open runspaces using a static
    observable collection.

    .DESCRIPTION
    This cmdlet creates a PSObject with an observable collection to
    track jobs in static runspaces. The open runspaces object is
    initialized once and shared across the session.

    .COMPONENT
    Runspaces

    .EXAMPLE
    $runspaces = Initialize-RpOpenRunspaces
    Write-Host "Initialized Open Runspaces: $runspaces"

    This example initializes the open runspaces object and assigns it
    to the module scope open runspaces variable, $script:OpenRunspaces.

    .PARAMETER None
    This cmdlet takes no parameters.

    .LINK
    https://www.remotepro.dev/en-US/Initialize-RpOpenRunspaces
    #>
    [CmdletBinding()]
    param ()

    # Initialize a PSObject with an ObservableCollection for Jobs
    $script:OpenRunspaces = New-Object PSObject -Property @{
        Jobs = New-Object System.Collections.ObjectModel.ObservableCollection[object]
    }

    Write-Verbose "Initialized OpenRunspaces object with an ObservableCollection for Jobs."

    # Return the openRunspaces object
    return $script:OpenRunspaces
}
