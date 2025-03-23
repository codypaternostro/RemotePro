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

        Write-Verbose "Initialized EventHandlers as a hashtable."
    }

    # Define event handlers
    # ToDo: 02/09/2025 Cleanup output to console. Consider Wite-Verbose.
    $handlers = @{
        #region Manage Connections
        NewConnectionFile_Click = {
            [System.Windows.Input.Mouse]::OverrideCursor = [System.Windows.Input.Cursors]::Wait
            try {
                $templatePath = Join-Path -Path (New-RpAppDataPath) -ChildPath 'ConnectionFileTemplate.xlsx'

                if (Test-Path -Path $templatePath) {
                    $confirmationResult = [System.Windows.MessageBox]::Show(
                    "The file 'ConnectionFileTemplate.xlsx' already exists. Do you want to overwrite it?",
                    "Confirm Overwrite",
                    [System.Windows.MessageBoxButton]::YesNo,
                    [System.Windows.MessageBoxImage]::Warning
                    )

                    if ($confirmationResult -ne [System.Windows.MessageBoxResult]::Yes) {
                    Write-Verbose "Operation canceled by user."
                    return
                    }
                }

                # Create a new connection file template
                Set-RpConnectionProfile -CreateTemplate -ExcelFilePath $templatePath

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
                Write-Verbose "Selected profiles:"
                $script:selectedProfileDetails = @()  # Clear the existing array
                foreach ($profile in $selectedProfiles) {
                    $script:selectedProfileDetails += $profile  # Add each selected profile to the array
                    Write-Verbose " - $($profile.Name)"
                    Write-Verbose "Full Details: `n$($profile.FullDetails)"
                }
            } else {
                # Only show "No profiles selected" if there was a previous selection and now there is none
                if ($script:selectedProfileDetails.Count -gt 0) {
                    Write-Verbose "No profiles selected."
                }
                # Clear the selected profiles array
                $script:selectedProfileDetails = @()
            }
        }

        PopOutButton_Click = {
            if ($script:selectedProfileDetails.Count -gt 0) {
                foreach ($profile in $script:selectedProfileDetails) {
                    Write-Verbose "Attempting to show profile details..."
                    if ($profile.FullDetails) {
                        Write-Verbose "FullDetails found, showing details..."
                        [System.Windows.MessageBox]::Show($profile.FullDetails, "Profile Details", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
                    } else {
                        Write-Verbose "FullDetails is null or empty."
                    }
                }

                # Refresh drop down connections.
                Get-RemoteProConnections
            } else {
                Write-Verbose "No profile selected."
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
                        Write-Verbose "Deleting profile: $($profile.Name)"

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
                    Write-Verbose "Deletion canceled by user."
                }
            } else {
                Write-Verbose "No profile selected."
            }
        }

        AddProfileButton_Click = {
            # Logic to add a new profile
            Write-Verbose "Add Profile button clicked."

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
                Write-Verbose "Edit Profile button clicked."

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
                Write-Verbose "No profiles selected."
            }
        }
        #endregion Manage Connections TAB

        #region Runspace TAB
        RunspaceMutexLog_TextChanged = {
            # Subscribe to Log tab TextChanged event (for logs)
            $script:runspace_mutex_log.ScrollToEnd()
        }
        #endregion Runspace TAB

        #region Configuration TAB

        # Configuration TAB > Main Settings
        RefreshSettings_Click = {
            Write-Verbose "Refreshing settings from disk file..."
            [System.Windows.Input.Mouse]::OverrideCursor = [System.Windows.Input.Cursors]::Wait
            try {
                # Logic to refresh settings from disk file
                Set-RpSettingsJson
                Write-Verbose "Settings refreshed from disk."

                # Refresh the ListBox ItemsSource
                Set-RpDefaultSettingsListView
                Write-Verbose "ListBox ItemsSource refreshed."
            } finally {
                [System.Windows.Input.Mouse]::OverrideCursor = $null  # Reset the cursor
            }
        }

        ResetSettings_Click = {
            Write-Verbose "Resetting settings to default values..."
            $confirmationResult = [System.Windows.MessageBox]::Show(
            "Are you sure you want to reset all settings to their default values?",
            "Confirm Reset",
            [System.Windows.MessageBoxButton]::YesNo,
            [System.Windows.MessageBoxImage]::Warning
            )

            if ($confirmationResult -eq [System.Windows.MessageBoxResult]::Yes) {
            [System.Windows.Input.Mouse]::OverrideCursor = [System.Windows.Input.Cursors]::Wait
            try {
                Reset-RpSettingsJson
                Set-RpSettingsJson
                Set-RpDefaultSettingsListView
                Write-Verbose "Settings have been reset to default values."
            } finally {
                [System.Windows.Input.Mouse]::OverrideCursor = $null  # Reset the cursor
            }
            } else {
            Write-Verbose "Reset operation canceled by user."
            }
        }

        DeleteSetting_Click = {
            Write-Verbose "Deleting selected setting..."

            # Get the selected item
            $selectedSetting = $script:Settings.SelectedItem

            if ($selectedSetting) {
                $confirmationResult = [System.Windows.MessageBox]::Show(
                    "Are you sure you want to delete '$($selectedSetting.Name)'?",
                    "Confirm Deletion",
                    [System.Windows.MessageBoxButton]::YesNo,
                    [System.Windows.MessageBoxImage]::Warning
                )

                if ($confirmationResult -eq [System.Windows.MessageBoxResult]::Yes) {
                    Remove-RpSettingFromJson -Name $selectedSetting.Name
                    Set-RpDefaultSettingsListView  # Refresh UI
                    Write-Verbose "Setting deleted: $($selectedSetting.Name)"
                } else {
                    Write-Verbose "Deletion canceled."
                }
            } else {
                Write-Verbose "No setting selected."
            }
        }


        AddSetting_Click = {
            Write-Verbose "Adding a new setting..."
            Add-RpSettingToJson -ShowDialog
            [System.Windows.Input.Mouse]::OverrideCursor = [System.Windows.Input.Cursors]::Wait
            try {
                Set-RpDefaultSettingsListView
            } finally {
                [System.Windows.Input.Mouse]::OverrideCursor = $null  # Reset the cursor
            }
        }

        EditSetting_Click = {
            Write-Verbose "Opening edit dialog..."
            Update-RpSettingsJson  -ShowDialog

            [System.Windows.Input.Mouse]::OverrideCursor = [System.Windows.Input.Cursors]::Wait
            try {
                Set-RpDefaultSettingsListView  # Refresh UI after edit
            } finally {
                [System.Windows.Input.Mouse]::OverrideCursor = $null
            }

        }


        # Configuration TAB > RemotePro Paths TAB
        ConfigurationTabs_SelectionChanged = {
            param($sender, $e)

            # Ensure the event is only processed when a tab is selected
            if ($e.Source -is [System.Windows.Controls.TabControl]) {
            $selectedTab = $sender.SelectedItem

            if ($selectedTab.Name -eq "RemoteProPaths") {
                try {
                Write-Verbose "Loading RemotePro module paths..."
                [System.Windows.Input.Mouse]::OverrideCursor = [System.Windows.Input.Cursors]::Wait
                $paths = @(
                    [pscustomobject]@{ Command = "New-RpAppDataPath"; Path = New-RpAppDataPath },
                    [pscustomobject]@{ Command = "Get-RpSettingsJsonPath"; Path = Get-RpSettingsJsonPath },
                    [pscustomobject]@{ Command = "Get-RpIconPath"; Path = Get-RpIconPath },
                    [pscustomobject]@{ Command = "Get-RpLogPath"; Path = Get-RpLogPath },
                    [pscustomobject]@{ Command = "Get-RpConfigPath"; Path = Get-RpConfigPath },
                    [pscustomobject]@{ Command = "Get-RpConfigPath -DefaultIds"; Path = Get-RpConfigPath -DefaultIds }
                )

                # Clear existing items from the ListBox
                $script:RemoteProPathsListBox.Items.Clear()

                # Add each path to the ListBox
                foreach ($path in $paths) {
                    $script:RemoteProPathsListBox.Items.Add($path)
                }

                Write-Verbose "RemotePro module paths loaded successfully."
                } catch {
                Write-Verbose "Error loading RemotePro module paths: $_"
                } finally {
                [System.Windows.Input.Mouse]::OverrideCursor = $null  # Reset the cursor
                }
            }
            }
        }

        # Configuration TAB > ConfigCommands TAB
        RefreshConfigCommands_Click = {
            Write-Verbose "Refreshing ConfigCommands from disk file..."
            [System.Windows.Input.Mouse]::OverrideCursor = [System.Windows.Input.Cursors]::Wait
            try {
                # Refresh the ConfigCommands from the disk file
                Set-RpConfigCommands
                Write-Verbose "ConfigCommands refreshed from disk."

                # Refresh the DataGrid ItemsSource
                Set-RpDefaultConfigCommandsDataGrid
                Write-Verbose "DataGrid ItemsSource refreshed."
            } finally {
                [System.Windows.Input.Mouse]::OverrideCursor = $null  # Reset the cursor
            }
        }

        ResetConfigCommands_Click = {
            Write-Verbose "Resetting config commands to default settings..."

            $confirmationResult = [System.Windows.MessageBox]::Show(
            "Are you sure you want to reset the config commands to their default settings?",
            "Confirm Reset",
            [System.Windows.MessageBoxButton]::YesNo,
            [System.Windows.MessageBoxImage]::Warning
            )

            if ($confirmationResult -eq [System.Windows.MessageBoxResult]::Yes) {
                [System.Windows.Input.Mouse]::OverrideCursor = [System.Windows.Input.Cursors]::Wait
                try {
                    Reset-RpConfigCommandDefaults
                    Set-RpDefaultConfigCommandsDataGrid
                    Write-Verbose "Config commands have been reset to default settings."
                } finally {
                    [System.Windows.Input.Mouse]::OverrideCursor = $null  # Reset the cursor
                }
            } else {
            Write-Verbose "Reset operation canceled by user."
            }
        }

        DeleteConfigCommands_Click = {
            Write-Verbose "Deleting selected ConfigCommand..."

            $selectedCommands = @($script:Commands | Where-Object { $_.CheckboxSelect -eq $true })
            Write-Verbose "DEBUG: Found $($selectedCommands.Count) selected commands."

            foreach ($command in $selectedCommands) {
                Write-Verbose " - Command: $($command.CommandName), ID: $($command.Id), CheckboxSelect: $($command.CheckboxSelect)"
            }

            if ($selectedCommands.Count -gt 0) {
                $confirmationResult = [System.Windows.MessageBox]::Show(
                "Are you sure you want to delete the selected ConfigCommands?",
                "Confirm Deletion",
                [System.Windows.MessageBoxButton]::YesNo,
                [System.Windows.MessageBoxImage]::Warning
                )

                if ($confirmationResult -eq [System.Windows.MessageBoxResult]::Yes) {
                    foreach ($command in $selectedCommands) {
                        [System.Windows.Input.Mouse]::OverrideCursor = [System.Windows.Input.Cursors]::Wait
                        try {
                            Remove-RpConfigCommand -CommandName $command.CommandName -Id $command.Id -Scope "ConfigCommand"
                        } finally {
                            [System.Windows.Input.Mouse]::OverrideCursor = $null  # Reset the cursor
                        }
                    }

                    # Refresh config commands from disk to controller
                    Set-RpDefaultConfigCommandsDataGrid

                    Write-Verbose "ConfigCommands deleted successfully."
                } else {
                    Write-Verbose "Deletion canceled by user."
                }
            } else {
                Write-Verbose "No ConfigCommand selected."
            }
        }

        AddConfigCommand_Click = {
            Write-Verbose "Adding a new ConfigCommand..."
            [System.Windows.Input.Mouse]::OverrideCursor = [System.Windows.Input.Cursors]::Wait
            try {
                # Logic to add a new ConfigCommand
                Add-RpConfigCommand
                Set-RpDefaultConfigCommandsDataGrid
            } finally {
                [System.Windows.Input.Mouse]::OverrideCursor = $null  # Reset the cursor
            }
        }

        EditConfigCommand_Click = {
            Write-Verbose "Editing selected ConfigCommand(s)..."
            $selectedCommands = @($script:Commands | Where-Object { $_.CheckboxSelect -eq $true })

            if ($selectedCommands.Count -gt 0) {
                [System.Windows.Input.Mouse]::OverrideCursor = [System.Windows.Input.Cursors]::Wait
                try {
                    foreach ($selectedCommand in $selectedCommands) {
                        Update-RpConfigCommand -CommandName $selectedCommand.CommandName -Id $selectedCommand.Id -ShowDialog -ModuleName $selectedCommand.ModuleName
                    }
                } finally {
                    [System.Windows.Input.Mouse]::OverrideCursor = $null  # Reset the cursor
                }

            # Refresh the DataGrid ItemsSource and UI
            [System.Windows.Input.Mouse]::OverrideCursor = [System.Windows.Input.Cursors]::Wait
            try {
                Set-RpDefaultConfigCommandsDataGrid
            } finally {
                [System.Windows.Input.Mouse]::OverrideCursor = $null  # Reset the cursor
            }
            } else {
                Write-Verbose "Please select at least one ConfigCommand to edit."
            }
        }

        Commands_ScrollViewer_PreviewMouseWheel = {
            # Event handler for scrolling horizontally with Shift + Mouse Wheel
            param($sender, $e)

            # Check if Shift key is pressed
            if ([System.Windows.Input.Keyboard]::IsKeyDown([System.Windows.Input.Key]::LeftShift) -or
                [System.Windows.Input.Keyboard]::IsKeyDown([System.Windows.Input.Key]::RightShift)) {

                # Shift is pressed → Scroll Horizontally
                $scrollViewer = $sender
                if ($scrollViewer.HorizontalScrollBarVisibility -ne "Disabled") {
                    $scrollViewer.ScrollToHorizontalOffset($scrollViewer.HorizontalOffset - $e.Delta)
                    $e.Handled = $true  # Prevent default vertical scrolling
                }
            }
        }

        TxtBox_FilterByName_TextChanged = {
            # Event handler for filtering commands by name
            param($sender, $e)

            $filterText = $sender.Text

            # DEBUG: Print filter text to verify filtering works
            Write-Verbose "DEBUG: Filtering with text: $filterText"

            # Apply filter to the Commands collection
            $script:FilteredCommands = @($script:Commands | Where-Object { $_.CommandName -like "*$filterText*" })

            # DEBUG: Print the number of filtered commands
            Write-Verbose "DEBUG: Filtered commands count: $($script:FilteredCommands.Count)"

            # Update ItemsSource instead of modifying .Items
            $script:Commands_DataGrid.ItemsSource = $script:FilteredCommands
        }

        # Event Handler for Header Checkbox Click
        Commands_HeaderChkBox_Click = {
            param($chkBoxSender, $e)

            # Check if the header checkbox is checked or unchecked
            $isChecked = $chkBoxSender.IsChecked

            # Iterate through all rows in the DataGrid and set the checkbox state
            foreach ($item in $script:Commands) {
                if ($item.PSObject.Properties.Match('CheckboxSelect').Count -gt 0) {
                    $item.CheckboxSelect = $isChecked
                    Write-Verbose "Item: $($item.CommandName), CheckboxSelect: $isChecked"
                }
            }

            # Refresh DataGrid to reflect changes
            $script:Commands_DataGrid.Items.Refresh()
            Write-Verbose "Header checkbox state changed to: $isChecked"
        }

        Commands_DataGrid_CheckBox_Click = {
            param($clickedItem)

            # DEBUG: Print what was received as $clickedItem
            Write-Verbose "DEBUG: Clicked item type: $($clickedItem.GetType().FullName)"

            # Ensure clickedItem is valid
            if ($null -eq $clickedItem) {
                Write-Verbose "ERROR: Clicked item's DataContext is null!"
                return
            }

            # Ensure 'CheckboxSelect' property exists
            if ($clickedItem.PSObject.Properties.Match('CheckboxSelect').Count -eq 0) {
                Write-Verbose "WARNING: Adding missing 'CheckboxSelect' property to item: $clickedItem"
                $clickedItem | Add-Member -MemberType NoteProperty -Name 'CheckboxSelect' -Value $false -Force
            }

            # Toggle checkbox state
            $clickedItem.CheckboxSelect = -not $clickedItem.CheckboxSelect

            # DEBUG: Print state of clicked item
            Write-Verbose "DEBUG: Item Updated -> Command: $($clickedItem.CommandName), CheckboxSelect: $($clickedItem.CheckboxSelect)"

            # DEBUG: Verify that $script:Commands contains the expected objects
            Write-Verbose "DEBUG: Checking state of all commands:"
            foreach ($item in $script:Commands) {
                Write-Verbose " - Command: $($item.CommandName), CheckboxSelect: $($item.CheckboxSelect)"
            }

            # Check if all checkboxes are checked
            $script:AllItemsChecked = ($script:Commands | Where-Object { -not $_.CheckboxSelect }).Count -eq 0
            $script:Commands_HeaderChkBox.IsChecked = $script:AllItemsChecked

            # DEBUG: Print final state of header checkbox
            Write-Verbose "DEBUG: Header checkbox updated to: $script:AllItemsChecked"
        }
        #endregion Configuration TAB

        #region Help, About, and Toolbar
        GithubRepositoryButton_Click = {
            Write-Verbose "Opening Remotepro GitHub repository webpage..."
            Start-Process "https://github.com/codypaternostro/RemotePro"
        }

        PowerShellGalleryButton_Click = {
            Write-Verbose "Opening RemotePro package PowerShell Gallery webpage."
            Start-Process "https://www.powershellgallery.com/packages/RemotePro"
        }

        DocsSiteButton_Click = {
            Write-Verbose "Opening DocsSite home webpage."
            Start-Process "https://www.remotepro.dev"
        }

        FlowDirectionToggleButton_Click = {
            Write-Verbose "Toggling flow direction..."

            if ($Window.FlowDirection -eq [System.Windows.FlowDirection]::LeftToRight) {
                $Window.FlowDirection = [System.Windows.FlowDirection]::RightToLeft
                Write-Verbose "Switched to Right-To-Left layout."
            } else {
                $Window.FlowDirection = [System.Windows.FlowDirection]::LeftToRight
                Write-Verbose "Switched to Left-To-Right layout."
            }
        }

        ReportIssueButton_Click = {
            Write-Verbose "Opening GitHub Issues webpage."
            Start-Process "https://github.com/codypaternostro/RemotePro/issues"
        }

        LicenseInformationButton_Click = {
            Write-Verbose "Opening GitHub License webpage."
            Start-Process "https://github.com/codypaternostro/RemotePro/blob/main/LICENSE"
        }

        AboutButton_Click = {
            Write-Verbose "Opening About webpage."
            Start-Process "https://www.remotepro.dev/getting-started/usageguide/"
        }

        #endregion Help, About, and Toolbar

        #region Main Window
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


                # Generate a log entry for job removal
                $logAddJobText = "Runspace timer stopped and additional runspaces removed successfully."
                $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
                $logAddJobMessage = "$timestamp - INFO  - $logAddJobText."

                # UI and Log message update
                Set-RpMutexLogAndUI -logPath $logPath -message $logAddJobMessage -uiElement $script:Runspace_Mutex_Log

                Write-Verbose  "$logAddJobMessage"

            } catch {
                # Generate a log entry for job removal
                $logAddJobErrorText = "Error closing main window: $_"
                $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
                $logAddJobMessage = "$timestamp - ERROR - $logAddJobErrorText."

                # UI and Log message update
                Set-RpMutexLogAndUI -logPath $logPath -message $logAddJobMessage -uiElement $script:Runspace_Mutex_Log

                Write-Verbose "$logAddJobErrorMessage"
            } finally {
                $script:xmlreader = $null
                $script:window.Close()
                $script:window = $null
                #Start-Sleep 5 -Seconds # wait for last tick
                # Stop and discard timer using Monitor-Runspace

                if ($script:RunspaceCleanupTimer -and $script:RunspaceCleanupTimer.Enabled) {
                    $script:RunspaceCleanupTimer.Stop()
                    $script:RunspaceCleanupTimer.Dispose()
                }

                if ($script:KillRemoteProOnExit) {
                    [System.Environment]::Exit(0)
                }

            }
        }
        #endregion Main Window
    }

    # Add the event handler to the EventHandlers hashtable
    foreach ($key in $handlers.Keys) {
        # Add each handler to the hashtable, overwriting if it already exists
        $script:RemotePro.EventHandlers[$key] = $handlers[$key]
    }

    # Attach a custom type to EventHandlers
    $script:RemotePro.EventHandlers.PSTypeNames.Insert(0, 'RemotePro.EventHandlers')

    Write-Verbose "Event Handlers have been successfully added to RemotePro.EventHandlers."
}
