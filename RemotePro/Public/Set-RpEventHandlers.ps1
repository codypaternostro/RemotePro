function Set-RpEventHandlers {
    <#
    .SYNOPSIS
    Initializes and populates the EventHandlers property of the RemotePro object
    with predefined event handler scripts.

    .DESCRIPTION
    The Set-RpEventHandlers cmdlet sets up predefined event handlers for various
    operations in the RemotePro environment. These handlers are stored in the
    EventHandlers property, which is a hashtable that allows quick lookup and
    execution of event-specific scripts.

    Each handler is linked to an event (such as button clicks, text changes, or
    UI interactions) and defines the actions to be triggered when the event occurs.
    If the EventHandlers property does not exist or is not a hashtable, it is
    initialized as an empty hashtable. Each event handler is added to this hashtable
    as a key-value pair, where the key is the event name and the value is the scriptblock.

    Additionally, the EventHandlers hashtable is assigned a custom type
    'RemotePro.EventHandlers' for easy identification and future use.

    .COMPONENT
    EventHandlers

    .PARAMETER None
    This cmdlet does not accept parameters. It simply initializes and populates
    the EventHandlers property with predefined event handlers.

    .EXAMPLE
    Set-RpEventHandlers

    This example initializes the EventHandlers hashtable and populates it with
    predefined event handlers. Each event is associated with a specific scriptblock
    to handle UI actions.

    .EXAMPLE
    Set-RpEventHandlers
    $handlers = $script:RemotePro.EventHandlers
    $handlers["OpenFile_Click"]

    This example sets up the EventHandlers property, retrieves all event handlers,
    and fetches the handler for the "OpenFile_Click" event.

    .EXAMPLE
    Set-RpEventHandlers
    $handler = $script:RemotePro.EventHandlers["NewConnectionFile_Click"]
    & $handler

    This example sets up the event handlers, retrieves the scriptblock for
    "NewConnectionFile_Click", and executes the scriptblock.

    .NOTES
    - The EventHandlers property is part of the RemotePro object and should be
    initialized with New-RpControllerObject before running this cmdlet.
    - This cmdlet does not return output unless errors occur during initialization
    or event handler assignment.
    - Event handlers are stored as scriptblocks in the EventHandlers hashtable
    and can be invoked based on user interactions.
    - See **New-RpControllerObject** and **Get-RpEventHandlers**

    .LINK
    https://www.remotepro.dev/en-US/Set-RpEventHandlers
    #>

    # Ensure RemotePro object is initialized
    if (-not $script:RemotePro) {
        Write-Error "RemotePro object is not initialized. Run New-RpControllerObject first."
        return
    }

    # If EventHandlers is null or not a hashtable, initialize it as an empty hashtable
    if ($null -eq $script:RemotePro.EventHandlers -or -not ($script:RemotePro.EventHandlers -is [hashtable])) {
        $script:RemotePro.EventHandlers = @{}

        Write-Host "Initialized EventHandlers as a hashtable."
    }

    # Define event handlers
    # ToDo: 02/09/2025 Cleanup output to console. Consider Wite-Verbose.
    $handlers = @{
        NewConnectionFile_Click = {
            [System.Windows.Input.Mouse]::OverrideCursor = [System.Windows.Input.Cursors]::Wait
            try {
                Set-RpConnectionProfile -CreateTemplate -ExcelFilePath $(Join-Path -Path (New-RpAppDataPath) -ChildPath 'ConnectionFileTemplate.xlsx')

                $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
                $openFileDialog.InitialDirectory = New-RpAppDataPath
                $openFileDialog.Filter = "Excel Sheet (*.xlsx)|*.xlsx|All files (*.*)|*.*"
                $openFileDialog.ShowDialog()

                $openFileDialog = $null
            } finally {
                [System.Windows.Input.Mouse]::OverrideCursor = $null  # Reset the cursor
            }
        }

        OpenFile_Click = {
            [System.Windows.Input.Mouse]::OverrideCursor = [System.Windows.Input.Cursors]::Wait
            try {
                $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
                $openFileDialog.InitialDirectory = New-RpAppDataPath
                $openFileDialog.Filter = "Excel Sheet (*.xlsx)|*.xlsx|All files (*.*)|*.*"
                $result = $openFileDialog.ShowDialog()

                if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
                    $selectedFile = $openFileDialog.FileName
                    [System.Windows.MessageBox]::Show("Selected file: $selectedFile")

                    Get-RemoteProConnections -ConnectionFilePath $selectedFile
                }

                $openFileDialog = $null
                $selectedFile = $null
            } finally {
                [System.Windows.Input.Mouse]::OverrideCursor = $null  # Reset the cursor
            }
        }

        ConnectionsComboBox_SelectionChanged = {
            param($sender, $e)

            # Get the current selected item
            $script:selectedProfileName = $sender.SelectedItem
        }

        ExecuteCommand_Click = {
            [System.Windows.Input.Mouse]::OverrideCursor = [System.Windows.Input.Cursors]::Wait
            try {
                $command = $CommandInput.Text
                try {
                    # Execute the command entered in the TextBox
                    $output = Invoke-Expression $command
                    # Optionally, display the output or handle it as needed
                    [System.Windows.MessageBox]::Show("Command executed. Output: `n$output")
                } catch {
                    # Error handling
                    [System.Windows.MessageBox]::Show("Error executing command: `n$($_.Exception.Message)")
                }
            } finally {
                [System.Windows.Input.Mouse]::OverrideCursor = $null  # Reset the cursor
            }
        }

        Connect_Click = {
            [System.Windows.Input.Mouse]::OverrideCursor = [System.Windows.Input.Cursors]::Wait
            try {
                $queuedConnection = Get-RpConnectionProfile -name $script:selectedProfileName
                Connect-Vms -ServerAddress $queuedConnection.ServerAddress -Name $queuedConnection.Name -Credential $queuedConnection.Credential
                Clear-VmsCache
                $queuedConnection = $null

                # Helper function for updating textbox
                Set-RpLoadingMessageTextBox
            } finally {
                [System.Windows.Input.Mouse]::OverrideCursor = $null  # Reset the cursor
            }
        }

        Terminate_Click = {
            [System.Windows.Input.Mouse]::OverrideCursor = [System.Windows.Input.Cursors]::Wait
            try {
                Clear-VmsCache
                $script:Connection_Status_Box.Clear()
                #$Connection_Status_Box.Text = Get-Site | Format-List
                Disconnect-Vms
                Disconnect-ManagementServer

                Set-RpDefaultConnectionBox
            } finally {
                [System.Windows.Input.Mouse]::OverrideCursor = $null  # Reset the cursor
            }
        }

        RunspaceMutexLog_TextChanged = {
            # Subscribe to Log tab TextChanged event (for logs)
            $script:runspace_mutex_log.ScrollToEnd()
        }

        CSB_TextChanged = {
            $textBox = $args[0]
            if ($textBox.Text -eq "Loading connection properties...") {
                $serverInfo = Get-RpConnectionsOverview
                # Update the TextBox content
                $script:Connection_Status_Box.Text = $serverInfo.Trim()
            }
        }

        ConnectionProfileListBox_SelectionChanged = {
            param($sender, $e)

            # Ensure that the event is only processed when there are selected profiles
            $selectedProfiles = $script:ConnectionProfileListBox.SelectedItems

            if ($selectedProfiles -and $selectedProfiles.Count -gt 0) {
                Write-Host "Selected profiles:"
                $script:selectedProfileDetails = @()  # Clear the existing array
                foreach ($profile in $selectedProfiles) {
                    $script:selectedProfileDetails += $profile  # Add each selected profile to the array
                    Write-Host " - $($profile.Name)"
                    Write-Host "Full Details: `n$($profile.FullDetails)"
                }
            } else {
                # Only show "No profiles selected" if there was a previous selection and now there is none
                if ($script:selectedProfileDetails.Count -gt 0) {
                    Write-Host "No profiles selected."
                }
                # Clear the selected profiles array
                $script:selectedProfileDetails = @()
            }
        }

        PopOutButton_Click = {
            if ($script:selectedProfileDetails.Count -gt 0) {
                foreach ($profile in $script:selectedProfileDetails) {
                    Write-Host "Attempting to show profile details..."
                    if ($profile.FullDetails) {
                        Write-Host "FullDetails found, showing details..."
                        [System.Windows.MessageBox]::Show($profile.FullDetails, "Profile Details", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
                    } else {
                        Write-Host "FullDetails is null or empty."
                    }
                }

                # Refresh drop down connections.
                Get-RemoteProConnections
            } else {
                Write-Host "No profile selected."
            }
        }

        Connection_Profile_Refresh_Button_Click = {
            # Handle the Refresh button click
            Get-RpConnectionProfileRefresh
        }

        DeleteProfileButton_Click = {
            if ($script:selectedProfileDetails.Count -gt 0) {
                $confirmationResult = [System.Windows.MessageBox]::Show(
                    "Are you sure you want to delete the selected profiles?",
                    "Confirm Deletion",
                    [System.Windows.MessageBoxButton]::YesNo,
                    [System.Windows.MessageBoxImage]::Warning
                )

                if ($confirmationResult -eq [System.Windows.MessageBoxResult]::Yes) {
                    # Get the current collection bound to the ListBox
                    $profilesCollection = [System.Collections.ObjectModel.ObservableCollection[object]]$script:ConnectionProfileListBox.ItemsSource

                    # Remove selected profiles from the collection
                    foreach ($profile in $script:selectedProfileDetails) {
                        Write-Host "Deleting profile: $($profile.Name)"

                        # Remove the profile using the appropriate command
                        Remove-VmsConnectionProfile -Name $profile.Name

                        # Remove the profile from the collection
                        $profilesCollection.Remove($profile)
                    }

                    # Clear the selected profiles after deletion
                    $script:selectedProfileDetails = @()

                    # Refresh the ListBox ItemsSource
                    $script:ConnectionProfileListBox.ItemsSource = $profilesCollection

                    # Refresh drop down connections.
                    Get-RemoteProConnections
                } else {
                    Write-Host "Deletion canceled by user."
                }
            } else {
                Write-Host "No profile selected."
            }
        }

        AddProfileButton_Click = {
            # Logic to add a new profile
            Write-Host "Add Profile button clicked."

            # Clear existing items from the ComboBox
            $script:Connections_Combo_Box.Items.Clear()

            # Open dialog box to add connection profile
            Show-RpProfileEntryDialog
            [System.Windows.Input.Mouse]::OverrideCursor = [System.Windows.Input.Cursors]::Wait
            try {
                # Refresh connections box and connection profile list
                Get-RemoteProConnections
            } finally {
                [System.Windows.Input.Mouse]::OverrideCursor = $null  # Reset the cursor
            }
        }

        EditProfileButton_Click = {
            # Ensure that the event is only processed when there are selected profiles
            $selectedProfiles = $script:ConnectionProfileListBox.SelectedItems

            if ($selectedProfiles -and $selectedProfiles.Count -gt 0) {
                # Logic to add a new profile
                Write-Host "Edit Profile button clicked."

                # Open dialog box to add connection profile
                Show-RpProfileEntryDialog -Edit -SelectedProfile $script:selectedProfileDetails

                [System.Windows.Input.Mouse]::OverrideCursor = [System.Windows.Input.Cursors]::Wait
                try {
                    # Refresh connections box and connection profile list
                    Get-RemoteProConnections
                } finally {
                    [System.Windows.Input.Mouse]::OverrideCursor = $null  # Reset the cursor
                }
            } else {
                Write-Host "No profiles selected."
            }
        }

        GithubRepositoryButton_Click = {
            Write-Host "Opening Remotepro GitHub repository webpage..."
            Start-Process "https://github.com/codypaternostro/RemotePro"
        }

        PowerShellGalleryButton_Click = {
            Write-Host "Opening RemotePro package PowerShell Gallery webpage."
            Start-Process "https://www.powershellgallery.com/packages/RemotePro"
        }

        DocsSiteButton_Click = {
            Write-Host "Opening DocsSite home webpage."
            Start-Process "https://www.remotepro.dev"
        }

        FlowDirectionToggleButton_Click = {
            Write-Host "Toggling flow direction..."

            if ($Window.FlowDirection -eq [System.Windows.FlowDirection]::LeftToRight) {
                $Window.FlowDirection = [System.Windows.FlowDirection]::RightToLeft
                Write-Host "Switched to Right-To-Left layout."
            } else {
                $Window.FlowDirection = [System.Windows.FlowDirection]::LeftToRight
                Write-Host "Switched to Left-To-Right layout."
            }
        }

        ReportIssueButton_Click = {
            Write-Host "Opening GitHub Issues webpage."
            Start-Process "https://github.com/codypaternostro/RemotePro/issues"
        }

        LicenseInformationButton_Click = {
            Write-Host "Opening GitHub License webpage."
            Start-Process "https://github.com/codypaternostro/RemotePro/blob/main/LICENSE"
        }

        Window_AddClosed_Click = {
            try {
                #[System.Windows.Application]::Current.Shutdown()  # Ensure the application is shut down properly
                # Dispose and close runspaces that are closed by monitor-runspaces (intentional)
                $script:RpOpenRunspaces | % {
                    $runspaceId = $script:RpOpenRunspaces.Jobs.RunspaceId
                    $runspace = Get-Runspace -InstanceId $runspaceId
                    $runspace.Dispose()
                    $runspace.Close()
                }

                $script:RpOpenRunspaces = $null

                # Dispose and close runspaces that may have been hung up (thorough cleanup)
                Get-Runspace | ? Id -NotLike 1 | % {
                    $_.Dispose()
                    $_.Close()
                }

                #Start-Sleep 5 -Seconds # wait for last tick
                # Stop and discard timer using Monitor-Runspace
                $script:RunspaceCleanupTimer.Stop()
                $script:RunspaceCleanupTimer = $null

                # Generate a log entry for job removal
                $logAddJobText = "Runspace timer stopped and additional runspaces removed successfully."
                $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
                $logAddJobMessage = "$timestamp - INFO  - $logAddJobText."

                # UI and Log message update
                Set-RpMutexLogAndUI -logPath $logPath -message $logAddJobMessage -uiElement $script:Runspace_Mutex_Log

                Write-Host = $logAddJobMessage

                $script:xmlreader = $null
                $script:window.Close()
                $script:window = $null

            } catch {
                # Generate a log entry for job removal
                $logAddJobErrorText = "Error closing main window: $_"
                $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
                $logAddJobMessage = "$timestamp - ERROR - $logAddJobErrorText."

                # UI and Log message update
                Set-RpMutexLogAndUI -logPath $logPath -message $logAddJobMessage -uiElement $script:Runspace_Mutex_Log

                Write-Host = $logAddJobErrorMessage
            }
        }
    }

    # Add the event handler to the EventHandlers hashtable
    foreach ($key in $handlers.Keys) {
        # Add each handler to the hashtable, overwriting if it already exists
        $script:RemotePro.EventHandlers[$key] = $handlers[$key]
    }

    # Attach a custom type to EventHandlers
    $script:RemotePro.EventHandlers.PSTypeNames.Insert(0, 'RemotePro.EventHandlers')

    Write-Host "Event Handlers have been successfully added to RemotePro.EventHandlers."
}
