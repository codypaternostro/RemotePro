function Set-RpMutexLogAndUI {
    <#
    .SYNOPSIS
    Logs a message and updates a UI element with the same message.

    .DESCRIPTION
    This function logs a message to a specified log file and updates a
    UI element (TextBox) with the same message. If the UI element is not
    provided, it will only log the message.

    .COMPONENT
    Runspaces

    .PARAMETER MutexName
    The name of the Mutex used to ensure exclusive access. Defaults to a GUID.

    .PARAMETER LogPath
    The path to the log file where the message will be recorded.

    .PARAMETER Message
    The actual text that will be logged and optionally shown in the UI.

    .PARAMETER UiElement
    The TextBox UI element to be updated with the message.

    .EXAMPLE
    Set-RpMutexLogAndUI -logPath "$(Get-RpLogPath)" -message "Task completed." -uiElement $textBoxElement

    This example logs the message "Task completed." to the log file and updates the
    UI element with the same message.

    .EXAMPLE
    Set-RpMutexLogAndUI -logPath "$(Get-RpLogPath)"  -message "Task completed."

    This example logs the message "Task completed." to the log file without updating
    the UI.

    .LINK
    https://www.remotepro.dev/en-US/Set-RpMutexLogAndUI
    #>

    [CmdletBinding(DefaultParameterSetName = 'LogAndUI')]
    param (
        [Parameter(ParameterSetName = 'LogOnly')]
        [Parameter(ParameterSetName = 'LogAndUI')]
        [string]$MutexName = [System.Guid]::NewGuid().ToString(),  # Generate a default GUID

        [Parameter(Mandatory = $true, ParameterSetName = 'LogOnly')]
        [Parameter(Mandatory = $true, ParameterSetName = 'LogAndUI')]
        [string]$LogPath,   # Path to the log file

        [Parameter(Mandatory = $true, ParameterSetName = 'LogOnly')]
        [Parameter(Mandatory = $true, ParameterSetName = 'LogAndUI')]
        [string]$Message,   # The message to log and optionally update UI

        [Parameter(ParameterSetName = 'LogAndUI')]
        [System.Windows.Controls.TextBox]$UiElement  # UI TextBox to update
    )

    # Create or open a named Mutex
    $Mutex = New-Object System.Threading.Mutex($false, $mutexName)

    # Wait for the mutex to be acquired
    if ($Mutex.WaitOne()) {
        try {
            # Log the message to a file
            Add-Content -Path $logPath -Value $message

            # Check if UI element is provided, then update the UI
            if ($null -ne $uiElement) {
                $localMessage = $message  # Assign message to a local variable for closure use

                $uiElement.Dispatcher.Invoke([action]{
                    $uiElement.Text += "$localMessage`r`n"  # Directly use the local variable inside the block
                }, [System.Windows.Threading.DispatcherPriority]::Normal)
            } else {
                Write-Warning "UI element is null. Cannot update the UI."
            }

        } finally {
            # Release the Mutex after execution
            $Mutex.ReleaseMutex()
        }
    }
}
