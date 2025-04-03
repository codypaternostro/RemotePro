function Start-RpRemotePro {
    <#
    .SYNOPSIS
    Launches the RemotePro WPF GUI for managing remote connections, settings,
    and Milestone VMS tools.

    .DESCRIPTION
    The Start-RpRemotePro function initializes the full RemotePro GUI, including
    theme loading, XAML parsing, event wiring, and PowerShell runspace
    infrastructure. It supports parallel task execution via runspaces, responsive
    UI with Material Design, and integration with modules like MilestonePSTools
    and ImportExcel.

    This function can relaunch itself in a separate terminal session (if not
    already running) and cleanly manages GUI lifecycle, splash screen loading,
    and system tray integration.

    .PARAMETER ShowTerminal
    (Optional) Launches the RemotePro GUI in a PowerShell console window with
    terminal output visible. Use this for debugging or interactive development.

    .COMPONENT
    RemoteProGUI

    .EXAMPLE
    Start-RpRemotePro

    Launches the RemotePro WPF interface in a new hidden PowerShell process. Used
    for standard user execution.

    .EXAMPLE
    Start-RpRemotePro -ShowTerminal

    Starts the RemotePro GUI in a visible PowerShell terminal window. Useful for
    development or logging.

    .EXAMPLE
    Start-RpRemotePro

    Initializes the GUI, splash screen, theme resources, runspace infrastructure,
    and system tray icon. Waits until the window is closed before terminating.

    .NOTES
    - Uses a singleton check to ensure only one instance of the WPF application
    exists per session.
    - Supports dynamic theme loading from XAML resource dictionaries.
    - Parses XAML into WPF elements and binds them to `$script:` variables.
    - Attaches dozens of event handlers from RemotePro.EventHandlers and
    RemotePro.RunspaceEvents.
    - Adds system tray icon with menu support for graceful exit behavior.
    - Manages background runspaces with a dispatcher timer for collecting
    results.
    - Uses dispatcher-safe UI updates and avoids blocking calls on the main
    thread.
    - Cleans up timers, UI windows, and memory during shutdown or exception.

    .LINK
    https://write-verbose.com/2023/03/21/PowerShellWPFPt1/

    .LINK
    https://gist.github.com/proxb/6bc718831422df3392c4

    .LINK
    https://www.milestonepstools.com/

    .LINK
    https://github.com/dfinke/ImportExcel

    .LINK
    https://github.com/EvotecIT/PSWriteHTML/blob/master/Docs/Out-HtmlView.md

    .LINK
    https://www.remotepro.dev/en-US/Start-RpRemotePro
    #>
    [CmdletBinding()]
    param(
        [switch]$ShowTerminal
    )

    begin {
        # Check if we are already in a RemotePro session
        if (-not $env:REMOTE_PRO_SESSION) {
            $env:REMOTE_PRO_SESSION = $true

            $baseCommand = 'if (-not (Get-Module -Name RemotePro)) { Import-Module -Name RemotePro -Force };'

            if ($ShowTerminal) {
            $launchCommand = "$baseCommand Start-RpRemotePro -ShowTerminal"
            Start-Process powershell.exe -ArgumentList "-NoExit", "-Command", "`"$launchCommand`"" -WindowStyle Normal
            } else {
            $killVar       = '$script:KillRemoteProOnExit = $true;'
            $fullCommand   = "$killVar $baseCommand Start-RpRemotePro"
            Start-Process powershell.exe -ArgumentList "-Command", "`"$fullCommand`"" -WindowStyle Hidden
            }

            Stop-Process -Id $PID
            return
        }

        # Show splash screen
        $splashWindow = Show-RpSplashScreen
        $splashWindow.Show()

        # WPF Application Singleton check
        $app = [System.Windows.Application]::Current

        if (-not $app) {
            try {
                $app = [System.Windows.Application]::new()
            } catch {
                if ($_.Exception.Message -like "*Cannot create more than one System.Windows.Application*") {
                    Write-Warning "Detected existing WPF Application. Relaunching in isolated session..."

                    # Fallback: Always show terminal if we hit this (safe default)
                    $launchCommand = 'Import-Module -RemotePro -Force; Start-RpRemotePro -ShowTerminal'
                    Start-Process powershell.exe -ArgumentList "-NoExit", "-Command", $launchCommand -WindowStyle Normal

                    Stop-Process -Id $PID
                    return
                } else {
                    Write-Warning "WPF Application failed to create: $_"
                }
            }
        }
    }

    process {
        try {
            [System.GC]::Collect()

            # Ensure scriptRoot exists
            if (-not $script:scriptRoot) {
                $thisModule = Get-Module RemotePro
                if ($thisModule) {
                    $script:scriptRoot = $thisModule.ModuleBase
                    Write-Verbose "Fallback: Set scriptRoot to $($script:scriptRoot) from ModuleBase"
                } else {
                    throw "scriptRoot is not defined and cannot be resolved."
                }
            }

            # Ensure the RemotePro controller and runspace objects are initialized
            if (-not $script:RemotePro) { $script:RemotePro = New-RpControllerObject }
            if (-not $script:RpOpenRunspaces) { $script:RpOpenRunspaces = Initialize-RpOpenRunspaces }
            if (-not $script:RpRunspaceJobs) { $script:RpRunspaceJobs = Initialize-RpRunspaceJobs }
            if (-not $script:RpRunspaceResults) { $script:RpRunspaceResults = Initialize-RpRunspaceResults }


            # Ensure resources dictionary is initialized
            if ($app -and -not $app.Resources) {
                $app.Resources = New-Object System.Windows.ResourceDictionary
            }
            $appResources = $app.Resources

            # Load default theme safely
            $themeRoot = Join-Path $script:scriptRoot "Themes"
            $defaultsPath = Join-Path $themeRoot "MaterialDesign2.Defaults.xaml"
            if (Test-Path $defaultsPath) {
                $defaultsDict = New-Object System.Windows.ResourceDictionary
                $uri = New-Object System.Uri ((Resolve-Path -Path $defaultsPath).ProviderPath)
                $defaultsDict.Source = $uri
                $appResources.MergedDictionaries.Add($defaultsDict)
                Write-Verbose "Loaded Defaults: $defaultsPath"
            }

            # Load additional themes
            $requiredThemes = @(
                'MaterialDesign2.Defaults.xaml',
                'MaterialDesignTheme.Button.xaml',
                'MaterialDesignTheme.PopupBox.xaml',
                'MaterialDesignTheme.ToolTip.xaml',
                'MaterialDesignTheme.ToggleButton.xaml',
                'MaterialDesignTheme.TextBox.xaml',
                'MaterialDesignTheme.Slider.xaml',
                'MaterialDesignTheme.TabControl.xaml'
            )
            foreach ($fileName in $requiredThemes) {
                $filePath = Join-Path $themeRoot $fileName
                if (Test-Path $filePath) {
                    try {
                        $dict = New-Object System.Windows.ResourceDictionary
                        $uri = New-Object System.Uri("file:///$($filePath -replace '\\','/')")
                        $dict.Source = $uri
                        $app.Resources.MergedDictionaries.Add($dict)
                        Write-Verbose "Loaded theme: $fileName"
                    } catch {
                        Write-Warning "Failed to load theme $fileName - $_"
                    }
                } else {
                    Write-Warning "Theme not found: $fileName"
                }
            }

            # Load and parse XAML
            $xamlPath = Join-Path $script:scriptRoot "Xaml\RemoteProUI.xaml"
            $RemoteProXaml = Get-Content -Path $xamlPath -Raw
            $RemoteProXaml = $RemoteProXaml -replace '^<Window.*', '<Window' -replace 'mc:Ignorable="d"', '' -replace "x:N", "N"
            [xml]$script:xaml = $RemoteProXaml
            $script:xmlreader = New-Object System.Xml.XmlNodeReader $xaml

            try {
                $script:window = [Windows.Markup.XamlReader]::Load($xmlreader)
            } catch {
                Write-Error "XAML Load Failed: $_"
                if ($_.Exception.InnerException) {
                    Write-Error "Inner Exception: $($_.Exception.InnerException.Message)"
                    if ($_.Exception.InnerException.InnerException) {
                        Write-Error "Root Cause: $($_.Exception.InnerException.InnerException.Message)"
                    }
                }
                throw
            } finally {
                $xmlreader.Close()
                $xmlreader.Dispose()
            }

            # Bind named XAML controls to script variables
            $script:xaml.SelectNodes("//*[@Name]") | ForEach-Object {
                $name = $_.Name
                try {
                    $value = $script:window.FindName($name)
                    if ($value) {
                        Set-Variable -Name $name -Value $value -Scope Script
                        Write-Verbose "Bound UI variable: $name"
                    } else {
                        Write-Verbose "No match found for: $name"
                    }
                } catch {
                    Write-Verbose "Failed to bind: $name - $($_.Exception.Message)"
                }
            }

            # Set the window icon
            if ($script:window) {
                Set-RpWindowIcon -window $script:window
            } else {
                Write-Warning "Failed to load window."
            }
            #endregion

            #region vms connection and updating main window.
            Set-RpDefaultConnectionBox          # Helper function for clearing textbox
            Set-DefaultConnectionProfileBox     # Helper function for populating connection profile textbox.
            Get-RemoteProConnections            # Fill Connections_Combo_Box with profile names.
                                                # Refresh "MilestonePSTools Connection Profile Details" tab.
            Get-RpConnectionProfileRefresh      # Helper function to refresh connection profiles
                                                # Refresh profiles by default when the main window loads
            Set-RpDefaultConfigCommandsDataGrid # Helper function for setting the default data grid
            Set-RpDefaultSettingsListView        # Helper function for setting the default settings list box
            #endregion

            #region button-click processing
            # Attach event handlers to UI elements from RemotePro.EventHandlers
            # Syntax: $xamlVariableName.event($script:RemotePro.EventType.EventName)

            # Manage Connections TAB
            $script:New_Connection_File.Add_Click($script:RemotePro.EventHandlers.NewConnectionFile_Click)
            $script:OpenFile.Add_Click($script:RemotePro.EventHandlers.OpenFile_Click)
            $script:Connections_Combo_Box.Add_SelectionChanged($script:RemotePro.EventHandlers.ConnectionsComboBox_SelectionChanged)
            $script:ExecuteCommand.Add_Click($script:RemotePro.EventHandlers.ExecuteCommand_Click)
            $script:Connect.Add_Click($script:RemotePro.EventHandlers.Connect_Click)
            $script:Terminate.Add_Click($script:RemotePro.EventHandlers.Terminate_Click)
            $script:ConnectionProfileListBox.Add_SelectionChanged($script:RemotePro.EventHandlers.ConnectionProfileListBox_SelectionChanged)
            $script:PopOutButton.Add_Click($script:RemotePro.EventHandlers.PopOutButton_Click)
            $script:Connection_Profile_Refresh_Button.Add_Click($script:RemotePro.EventHandlers.Connection_Profile_Refresh_Button_Click)
            $script:Delete_Profile_Button.Add_Click($script:RemotePro.EventHandlers.DeleteProfileButton_Click)
            $script:Edit_Profile_Button.Add_Click($script:RemotePro.EventHandlers.EditProfileButton_Click)
            $script:Add_Profile_Button.Add_Click($script:RemotePro.EventHandlers.AddProfileButton_Click)
            $script:Connection_Status_Box.Add_TextChanged($script:RemotePro.EventHandlers.CSB_TextChanged)

            # Toolbar
            $script:GithubRepositoryCommand.Add_Click($script:RemotePro.EventHandlers.GithubRepositoryButton_Click)
            $script:PowerShellGalleryCommand.Add_Click($script:RemotePro.EventHandlers.PowerShellGalleryButton_Click)
            $script:DocsSiteCommand.Add_Click($script:RemotePro.EventHandlers.DocsSiteButton_Click)
            $script:FlowDirectionToggleButton.Add_Click($script:RemotePro.EventHandlers.FlowDirectionToggleButton_Click)
            $script:ReportIssueCommand.Add_Click($script:RemotePro.EventHandlers.ReportIssueButton_Click)
            $script:LicenseInformationCommand.Add_Click($script:RemotePro.EventHandlers.LicenseInformationButton_Click)
            $script:AboutCommand.Add_Click($script:RemotePro.EventHandlers.AboutButton_Click)
            $script:ExitApplicationCommand.Add_Click($script:RemotePro.EventHandlers.Window_AddClosed_Click)

            # Runspace log TAB
            $script:Runspace_Mutex_Log.Add_TextChanged($script:RemotePro.EventHandlers.RunspaceMutexLog_TextChanged)

            # Configuration > Main Settings TAB
            $script:RefreshSettings.Add_Click($script:RemotePro.EventHandlers.RefreshSettings_Click)
            $script:ResetSettings.Add_Click($script:RemotePro.EventHandlers.ResetSettings_Click)
            $script:DeleteSetting.Add_Click($script:RemotePro.EventHandlers.DeleteSetting_Click)
            $script:AddSetting.Add_Click($script:RemotePro.EventHandlers.AddSetting_Click)
            $script:EditSetting.Add_Click($script:RemotePro.EventHandlers.EditSetting_Click)

            # Configuration > ConfigCommands TAB
            $script:RefreshConfigCommands.Add_Click($script:RemotePro.EventHandlers.RefreshConfigCommands_Click)
            $script:ResetConfigCommands.Add_Click($script:RemotePro.EventHandlers.ResetConfigCommands_Click)
            $script:DeleteConfigCommands.Add_Click($script:RemotePro.EventHandlers.DeleteConfigCommands_Click)
            $script:AddConfigCommand.Add_Click($script:RemotePro.EventHandlers.AddConfigCommand_Click)
            $script:EditConfigCommand.Add_Click($script:RemotePro.EventHandlers.EditConfigCommand_Click)
            $script:TxtBox_FilterByName.Add_TextChanged($script:RemotePro.EventHandlers.TxtBox_FilterByName_TextChanged)
            $script:Commands_HeaderChkBox.Add_Click($script:RemotePro.EventHandlers.Commands_HeaderChkBox_Click)
            $script:Commands_DataGrid.AddHandler(
                [System.Windows.Controls.Primitives.ButtonBase]::ClickEvent,
                [System.Windows.RoutedEventHandler]$script:RemotePro.EventHandlers.Commands_DataGrid_CheckBox_Click
            )
            $script:AllItemsChecked = ($script:Commands | Where-Object { -not $_.CheckboxSelect }).Count -eq 0
            $script:Commands_HeaderChkBox.IsChecked = $script:AllItemsChecked
            $script:Commands_ScrollViewer.Add_PreviewMouseWheel($script:RemotePro.EventHandlers.Commands_ScrollViewer_PreviewMouseWheel)

            # Configuration > ConfigCommands TAB
            $script:ConfigurationTabs.Add_SelectionChanged($script:RemotePro.EventHandlers.ConfigurationTabs_SelectionChanged)

            # Attach runspace events to UI elements from RemotePro.RunspaceEvents
            # Syntax: $xamlVariableName.event($script:RemotePro.EventType.RunspaceEventName)
            $script:CamReport.Add_Click($script:RemotePro.RunspaceEvents.CamReport_Click)
            $script:ShowCameras.Add_Click($script:RemotePro.RunspaceEvents.ShowCameras_Click)
            $script:TicketBlock.Add_Click($script:RemotePro.RunspaceEvents.TicketBlock_Click)
            $script:ShowVideoOSItems.Add_Click($script:RemotePro.RunspaceEvents.ShowVideoOSItems_Click)
            $script:Hardware.Add_Click($script:RemotePro.RunspaceEvents.Hardware_Click)
            $script:ItemState.Add_Click($script:RemotePro.RunspaceEvents.ItemState_Click)
            #endegion

            #region clean up main window environment
            # Handle closing the main window
            $script:window.Add_Closed($script:RemotePro.EventHandlers.Window_AddClosed_Click)

            # Handle closing from the system tray icon
            $script:NotifyIcon = New-Object System.Windows.Forms.NotifyIcon
            $script:NotifyIcon.Icon = [System.Drawing.SystemIcons]::Application
            $script:NotifyIcon.Visible = $true
            $script:NotifyIcon.ContextMenu = New-Object System.Windows.Forms.ContextMenu
            $script:NotifyIcon.ContextMenu.MenuItems.Add("Exit", {
                $script:window.Close()
            })

            $script:window.Add_Closed({
                $script:NotifyIcon.Dispose()
            })
            #endregion

            #region static runspace logic
            $jobsToRun = @(
                @{
                    JobName                = "runspaceJob2"
                    JobDetailsVariableName = "jobDetails2"
                    Description            = "Get VmsCameraReport"
                    ScriptBlock            = {}
                }
            )

            $script:RpOpenRunspaces = Start-RpRunspaceJobStatic -Jobs $jobsToRun -uiElement $script:Runspace_Mutex_Log -OpenRunspaces $script:RpOpenRunspaces -RunspaceJobs $script:RunspaceJobs -Verbose
            #$script:openRunspaces.Jobs | ? Runspace -eq $runspaceJob2 | select Runspace
            #$script:openRunspaces.Jobs | ogv
            #endregion

            #region runspace job timer, collection, and maintenance
            $script:RunspaceTimerParams = @{
                LogPath         = $script:logPath
                uiElement       = $script:Runspace_Mutex_Log
                RunspaceJobs    = $script:RunspaceJobs
                RunspaceResults = $script:RunspaceResults
                OpenRunspaces   = $script:RpOpenRunspaces
            }

            # Initialize the timer
            $script:RunspaceCleanupTimer = New-Object Windows.Threading.DispatcherTimer
            $script:RunspaceCleanupTimer.Interval = [TimeSpan]::FromSeconds(2)
            $script:RunspaceCleanupTimer.Add_Tick({
                Watch-RpRunspaces @script:RunspaceTimerParams
            })

            $script:RunspaceCleanupTimer.Start()
            #endregion

            if ($script:window) {
                if ($splashWindow) {
                    $splashWindow.Close()
                }
                # Show the window modally (blocks until window is closed)
                $script:window.ShowDialog() | Out-Null

            } else {
                Write-Warning "Window is null - cannot display UI."
            }


            if ($script:window){
                # Dispose of the window when closed
                $script:window.Close()
            }
        }
        catch {
            Write-Error "Start-RpRemotePro failed: $_"
        }
    }

    end {
        try {
            if ($script:RunspaceCleanupTimer -and $script:RunspaceCleanupTimer.Enabled) {
                $script:RunspaceCleanupTimer.Stop()
                $script:RunspaceCleanupTimer.Dispose()
            }
            if ($script:window -and $script:window.IsLoaded) {
                $script:window.Close()
            }

            if ($app -and ($app -is [System.Windows.Application])) {
                $app.Shutdown()
            }
        } catch {
            Write-Verbose "Safe shutdown skipped: $($_.Exception.Message)"
        }
    }
}

