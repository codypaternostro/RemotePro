#region create runspace envionrment
# This function starts a PowerShell job in a runspace and creates identifiers for tracking.
# Relies on "$script:RunspaceJobs = [System.Collections.ArrayList]::Synchronized((New-Object System.Collections.ArrayList))"
function Start-RpRunspaceJob {
    <#
        .SYNOPSIS
            Starts a PowerShell job in a runspace and tracks it.

        .DESCRIPTION
            This function starts a PowerShell job in a runspace and tracks its status.
            By default, it uses the existing session state (environment variables and
            session variables), but you can create a new runspace with specific modules,
            assemblies, and functions loaded.

        .NOTES
            - A timer (`$script:RunspaceCleanupTimer`) is used to periodically invoke
              the `Watch-RpRunspaces` function, which is responsible for cleaning up
              completed runspaces, logging output, and updating the UI.

            - The runspace cleanup relies on:
                - Initialize-RpRunspaceJobs
                  `$script:RunspaceJobs`: Tracks each runspace dispatched.
                - Initialize-RpRunspaceResults
                  `$script:RunspaceResults`: Collects results from runspaces.
                - Initialize-RpOpenRunspaces
                  `$script:openRunspaces`: Static collection of active runspaces.

        .PARAMETER ModulesToLoad
            Modules to load into the runspace environment when not using existing state.

        .PARAMETER AssembliesToLoad
            Assemblies to load into the runspace environment when not using existing state.

        .PARAMETER FunctionsToImport
            Functions to import into the runspace environment when not using existing state.

        .PARAMETER ScriptBlock
            The scriptblock to execute in the runspace.

        .PARAMETER ArgumentList
            List of arguments to pass to the scriptblock.

        .PARAMETER Argument
            Single argument to pass to the scriptblock.

        .PARAMETER UseExistingRunspaceState
            Uses the current session state (variables and environment) in the new runspace.

        .PARAMETER Id
            If specified, returns the runspace job ID.

        .PARAMETER uiElement
            Optional UI TextBox element to update with runspace status.

        .PARAMETER RunspaceJobs
            Collection of runspace jobs for tracking.

        .EXAMPLE
            Start-RpRunspaceJob -ScriptBlock { Get-Process } -RunspaceJobs $global:RunspaceJobs

        .EXAMPLE
            Start-RpRunspaceJob -ScriptBlock { Get-Process } -ModulesToLoad @('MyModule') `
                -AssembliesToLoad @('MyAssembly') -RunspaceJobs $global:RunspaceJobs
    #>

    [CmdletBinding(DefaultParameterSetName = 'UseExistingRunspace')]
    param (
        [Parameter(ParameterSetName = 'NewRunspace')]
        [string[]]$ModulesToLoad = @(),

        [Parameter(ParameterSetName = 'NewRunspace')]
        [string[]]$AssembliesToLoad = @(),

        [Parameter(ParameterSetName = 'NewRunspace')]
        [string[]]$FunctionsToImport = @(),

        [Parameter(Mandatory = $true)]
        [scriptblock]$ScriptBlock,

        [object[]]$ArgumentList = @(),
        [object]$Argument,

        [Parameter(ParameterSetName = 'UseExistingRunspace')]
        [switch]$UseExistingRunspaceState,  # Default parameter set (use current session state)

        [switch]$Id,  # Return job ID

        [System.Windows.Controls.TextBox]$uiElement,  # Optional UI element for updates
        [System.Collections.ArrayList]$RunspaceJobs  # Collection of runspace jobs for tracking
    )

    # Create or configure the initial session state
    $initialSessionState = [initialsessionstate]::CreateDefault()

    if ($UseExistingRunspaceState) { # need to fix logic here on the inverted "use existing runspaces"
        # Replicate environment variables in the initial session state
        $environmentVariables = Get-ChildItem Env: | ForEach-Object { [PSCustomObject]@{ Name = $_.Name; Value = $_.Value } }
        foreach ($var in $environmentVariables) {
            $envEntry = New-Object System.Management.Automation.Runspaces.SessionStateVariableEntry($var.Name, $var.Value, "Environment variable replication")
            $initialSessionState.Variables.Add($envEntry)
        }

        # Replicate all variables from the current session in the initial session state
        $currentVariables = Get-Variable
        foreach ($var in $currentVariables) {
            # Avoid system variables and read-only variables
            if ($var.Options -ne "None" -or $var.Options -ne "ReadOnly") {
                continue
            }
            $varValue = Get-Variable -Name $var.Name -ValueOnly
            $varEntry = New-Object System.Management.Automation.Runspaces.SessionStateVariableEntry($var.Name, $varValue, $var.Description)
            $initialSessionState.Variables.Add($varEntry)
        }

        # Create the runspace
        $runspace = [runspacefactory]::CreateRunspacePool($initialSessionState)
        $runspace.ApartmentState = [System.Threading.ApartmentState]::STA
        $runspace.Open()

        # Configure the PowerShell instance to use the new runspace
        $psInstance = [powershell]::Create()
        $psInstance.RunspacePool = $runspace

    }

    if (!$UseExistingRunspaceState) {
        # Load specified modules, assemblies, and functions into the initial session state
        foreach ($module in $ModulesToLoad) {
            $initialSessionState.ImportPSModule($module)
        }

        foreach ($assembly in $AssembliesToLoad) {
            $assemblyEntry = New-Object System.Management.Automation.Runspaces.SessionStateAssemblyEntry($assembly)
            $initialSessionState.Assemblies.Add($assemblyEntry)
        }

        foreach ($function in $FunctionsToImport) {
            $functionScript = (Get-Item Function:\$function).ScriptBlock
            $initialSessionState.Commands.Add((New-Object System.Management.Automation.Runspaces.SessionStateFunctionEntry($function, $functionScript)))
        }

        # Use an existing runspace (potentially passed in)
        # This assumes that the runspace would be managed externally if this switch is on
        $runspace = [runspacefactory]::CreateRunspace()
        $runspace.ApartmentState = [System.Threading.ApartmentState]::STA
        $runspace.Open()

        # Configure the PowerShell instance to use the new runspace
        $psInstance = [powershell]::Create()
        $psInstance.Runspace = $runspace
    }

    # Set the ScriptRoot in the new runspace's environment
    $psInstance.AddScript("`$script:ScriptRoot = '$script:ScriptRoot'").Invoke()
    $psInstance.AddScript($ScriptBlock)

    if ($ArgumentList){
        foreach ($arg in $ArgumentList) {
            $psInstance.AddArgument($arg)
        }
    }

    if ($Argument) {
        $psInstance.AddArgument($Argument)
    }

    $asyncResult = $psInstance.BeginInvoke()
    $runspaceID = $runspace.InstanceId
    # Ensure all components are valid
    if ($null -eq $psInstance -or $null -eq $runspace -or $null -eq $asyncResult) {
        Write-Host "Failed to initialize one or more components of the job."
    } else {
        # Add the job to a global job tracking list
        try {
            [void]$RunspaceJobs.Add([PSCustomObject]@{
                PowerShell = $psInstance
                Runspace = $runspace
                AsyncResult = $asyncResult
                RunspaceID = $runspaceID
            })
            # Generate a log entry for job removal
            $logAddJobText = "Job added successfully."
            $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
            $logAddJobMessage = "$timestamp - INFO  - GUID: $runspaceID - $logAddJobText."

            # UI and Log message update
            Set-RpMutexLogAndUI -logPath $logPath -message $logAddJobMessage -uiElement $uiElement

            Write-Host = $logAddJobMessage

            # GUID of Runspace
            if ($ReturnID) {
                return $runspaceID
            }

        } catch {
            # Generate a log entry for job removal
            $logAddJobErrorText = "Error adding job to global list: $_"
            $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
            $logAddJobMessage = "$timestamp - ERROR - GUID: $runspaceID - $logAddJobErrorText."

            # UI and Log message update
            Set-RpMutexLogAndUI -logPath $logPath -message $logAddJobMessage -uiElement $uiElement

            Write-Host = $logAddJobErrorMessage
        }
    }
}
#endregion
