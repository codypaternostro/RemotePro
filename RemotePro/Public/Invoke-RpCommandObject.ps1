function Invoke-RpCommandObject {
    <#
    .SYNOPSIS
    Executes a command object using the call operator (&) by default or Invoke-Command if specified.

    .DESCRIPTION
    This function accepts a command object (via pipeline or parameter) and executes
    it. You can optionally specify to use Invoke-Command instead of the default
    call operator. The function also validates the command and parameters before
    execution.

    .COMPONENT
    ConfigCommands

    .PARAMETER CommandObject
    The command object containing the CommandName and Parameters properties.

    .PARAMETER UseInvokeCommand
    Switch to use Invoke-Command instead of the default call operator.

    .PARAMETER ComputerName
    If UseInvokeCommand is specified, this parameter defines the remote system(s)
    to run the command on.

    .PARAMETER PipelineCommandObject
    An optional object that will be piped into the primary command as input.

    .EXAMPLE
    Calling Get-RpVmsItemStateCustom from the default config commands.
    $commandId = (Get-RpDefaultConfigCommandDetails).'Get-RpVmsItemStateCustom'.Id
    $commandObject1 = (Get-RpConfigCommands -All).'Get-RpVmsItemStateCustom' |
                      Format-RpCommandObject -CommandName "Get-RpVmsItemStateCustom" `
                                             -Parameters @{ CommandId = $commandId }

    Calling Out-HtmlView from the default config commands.
    $commandId = (Get-RpDefaultConfigCommandDetails).'Out-HtmlView'.Id
    $outHtmlView = (Get-RpConfigCommands -All).'Out-HtmlView' |
                   Format-RpCommandObject -CommandName "Out-HtmlView" `
                                          -Parameters @{ CommandId = $commandId }

    Invoke default config commands with piped results.
    Invoke-RpCommandObject -CommandObject $commandObject1 -PipelineCommandObject $outHtmlView

    .EXAMPLE
    Format a command object and execute using the call operator.
    $commandObject = Format-RpCommandObject -CommandName "Get-RpDataIsFun" `
                     -Parameters @{ Key = "Value" }

    Pass it via pipeline to invoke.
    $commandObject | Invoke-RpCommandObject

    This example executes the command using the default call operator.

    .EXAMPLE
    Execute the command object on a remote system using Invoke-Command.
    $commandObject = Format-RpCommandObject -CommandName "Get-RpDataIsFun" `
                     -Parameters @{ Key = "RemoteValue" }

    $commandObject | Invoke-RpCommandObject -UseInvokeCommand `
                     -ComputerName "RemoteServer"

    This example executes the command on the specified remote system using Invoke-Command.

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
        [string[]]$ComputerName,

        [Parameter()]
        [PSObject]$PipelineCommandObject
    )

    process {
        # Validate the primary command object
        if (-not $CommandObject.CommandName) {
            Write-Error "The primary command object is missing a 'CommandName' property."
            return
        }
        if (-not ($CommandObject.Parameters -is [hashtable])) {
            Write-Error "The 'Parameters' property in the primary command object must be a hashtable."
            return
        }

        # Validate the PipelineCommandObject (if provided)
        if ($PipelineCommandObject) {
            if (-not $PipelineCommandObject.CommandName) {
                Write-Error "The input pipeline object is missing a 'CommandName' property."
                return
            }
            if (-not ($PipelineCommandObject.Parameters -is [hashtable])) {
                Write-Error "The 'Parameters' property in the input pipeline object must be a hashtable."
                return
            }
        }

        # Extract properties from the primary command object
        $primaryCommandName = $CommandObject.CommandName
        $primaryParameters = $CommandObject.Parameters

        if ($PipelineCommandObject) {
            # Extract properties from the input pipeline object
            $inputPipelineCommandName = $PipelineCommandObject.CommandName
            $inputPipelineParameters = $PipelineCommandObject.Parameters
        }

        # Isolate primary result
        $primaryResult = $null

        # Execution logic
        if ($UseInvokeCommand) {
            Write-Verbose "Using Invoke-Command to execute '$primaryCommandName'..."
            if (-not $ComputerName) {
                Write-Error "ComputerName must be specified when using Invoke-Command."
                return
            }

            # Execute using Invoke-Command
            $primaryResult = Invoke-Command -ComputerName $ComputerName -ScriptBlock {
                param ($cmdName, $cmdParams)
                & $cmdName @cmdParams
            } -ArgumentList $primaryCommandName, $primaryParameters
        } else {
            Write-Verbose "Using call operator (&) to execute '$primaryCommandName'..."
            try {
                $primaryResult = & $primaryCommandName @primaryParameters
            } catch {
                Write-Error "Error executing command '$primaryCommandName': $($_.Exception.Message)"
                return
            }
        }

        # Handle input pipeline object (if provided)
        if ($PipelineCommandObject) {
            Write-Verbose "Piping primary result into '$inputPipelineCommandName'..."
            try {
                # Pipe the primary result into the input pipeline command
                $pipedResult = $primaryResult | & $inputPipelineCommandName @inputPipelineParameters
                return $pipedResult
            } catch {
                Write-Error "Error piping into command '$inputPipelineCommandName': $($_.Exception.Message)"
                return
            }
        } else {
            # Return primary result only
            return $primaryResult
        }
    }
}
