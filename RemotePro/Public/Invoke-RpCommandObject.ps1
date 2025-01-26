function Invoke-RpCommandObject {
    <#
    .SYNOPSIS
    Executes a command object using the call operator (&) by default or Invoke-Command
    if specified.

    .DESCRIPTION
    This function accepts a command object (via pipeline or parameter) and executes
    it. You can optionally specify to use Invoke-Command instead of the default
    call operator. The function also validates the command and parameters before
    execution.

    .PARAMETER CommandObject
    The command object containing the CommandName and Parameters properties.

    .PARAMETER UseInvokeCommand
    Switch to use Invoke-Command instead of the default call operator.

    .PARAMETER ComputerName
    If UseInvokeCommand is specified, this parameter defines the remote system(s)
    to run the command on.

    .EXAMPLE
    $commandObject = Format-RpCommandObject -CommandName "Get-RpDataIsFun" `
                     -Parameters @{ Key = "Value" }
    $commandObject | Invoke-RpCommandObject

    This example executes the command using the default call operator.

    .EXAMPLE
    $commandObject | Invoke-RpCommandObject -UseInvokeCommand `
                     -ComputerName "RemoteServer"

    This example executes the command on the specified remote system using
    Invoke-Command.

    .NOTES
    Ensure that the command object includes valid CommandName and Parameters.
    #>

    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline, Mandatory = $true)]
        [PSObject]$CommandObject,

        [Parameter()]
        [switch]$UseInvokeCommand,

        [Parameter()]
        [string[]]$ComputerName
    )

    process {
        # Validate the command object to ensure it has the required properties
        if (-not $CommandObject.CommandName) {
            Write-Error "The command object is missing a 'CommandName' property: $($_.Exception.Message)"
            return
        }
        if (-not ($CommandObject.Parameters -is [hashtable])) {
            Write-Error "The 'Parameters' property in the command object must be a hashtable: $($_.Exception.Message)"
            return
        }

        # Extract properties from the command object for execution
        $commandName = $CommandObject.CommandName
        $parameters = $CommandObject.Parameters

        # Choose the execution method based on the provided switch
        if ($UseInvokeCommand) {
            Write-Verbose "Using Invoke-Command to execute '$commandName'..."
            if (-not $ComputerName) {
                Write-Error "ComputerName must be specified when using Invoke-Command: $($_.Exception.Message)"
                return
            }

            # Execute using Invoke-Command on the specified remote system(s)
            Invoke-Command -ComputerName $ComputerName -ScriptBlock {
                param ($cmdName, $cmdParams)
                Write-Verbose "Running command '$cmdName' with parameters..."
                & $cmdName @cmdParams
            } -ArgumentList $commandName, $parameters
        } else {
            Write-Verbose "Using call operator (&) to execute '$commandName'..."
            # Execute the command locally using the call operator
            try {
                & $commandName @parameters
            } catch {
                Write-Error "Error executing command '$commandName': $($_.Exception.Message)"
            }
        }
    }
}
