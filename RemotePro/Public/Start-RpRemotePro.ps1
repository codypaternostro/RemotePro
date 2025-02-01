function Start-RpRemotePro {
    <#
    .SYNOPSIS
        Initializes and manages the RemotePro application interface.

    .DESCRIPTION
        The Start-RpRemotePro function sets up a GUI for managing remote connections
        and commands. It uses WPF for dynamic display and runspaces for managing
        multiple asynchronous tasks, allowing for responsive interactions during
        complex operations. This function incorporates the MilestonePSTools and
        ImportExcel modules, providing essential tools for operation. It dynamically
        creates UI elements from provided XAML, handles user events, and executes
        commands. Extensive use of runspaces facilitates efficient execution of
        background PowerShell commands, managing long-running tasks, and handling
        concurrent operations to enhance performance.

    .PARAMETERS
        There are no parameters exposed in the function signature. However, the
        function uses internally managed variables and runtime configurations to
        control various features such as connection management, command execution,
        and event handling through the GUI.

    .EXAMPLE
        Start-RpRemotePro
        # Launches the RemotePro GUI, initializes all components, and sets up
        runspaces for asynchronous task management.

    .NOTES
        - Requires that necessary modules and dependencies are installed and
        configured in the running environment.
        - Employs advanced features such as WPF and runspaces to maintain a smooth
        operation flow and responsive user interface during intensive tasks.
        - Runspaces are critical for the application's ability to perform multiple
        operations simultaneously, such as fetching data, updating the UI, and
        executing user commands without freezing or crashing.

    .LINK
        https://write-verbose.com/2023/03/21/PowerShellWPFPt1/
        Guide on integrating PowerShell with WPF for GUI applications.

    .LINK
        https://gist.github.com/proxb/6bc718831422df3392c4
        Example of managing complex PowerShell GUI applications.

    .LINK
        https://www.milestonepstools.com/
        MilestonePSTools website, detailing how it extends Milestone's MIP SDK capabilities
        to PowerShell for rapid VMS configuration and reporting automation.

    #>
    [CmdletBinding()]
    param()

    # Ensure the RemotePro controller and runspace objects are initialized
    if (-not $script:RemotePro) {
        $script:RemotePro = New-RpControllerObject
    }
    if (-not $script:RpOpenRunspaces){
        $script:RpOpenRunspaces = Initialize-RpOpenRunspaces
    }
    if (-not $script:RpRunspaceJobs){
        $script:RpRunspaceJobs = Initialize-RpRunspaceJobs
    }
    if (-not $script:RpRunspaceResults){
        $script:RpRunspaceResults = Initialize-RpRunspaceResults
    }

    #region wpf xaml and reader
    # Modified XAML with an added button for opening the connection file
    $script:RemoteProXaml = $script:RemoteProXaml -replace '^<Window.*', '<Window' -replace 'mc:Ignorable="d"','' -replace "x:N",'N'
    [xml]$script:xaml = $script:RemoteProXaml
    $script:xmlreader=(New-Object System.Xml.XmlNodeReader $xaml)
    $script:window=[Windows.Markup.XamlReader]::Load( $xmlreader )

    # Automatically find and create script-scoped variables for each named XAML element
    $script:xaml.SelectNodes("//*[@Name]") | ForEach-Object -Process {
        $variableName = $_.Name
        $variableValue = $window.FindName($variableName)

        # Note: since variables are set at the script scope "$script:" prefix is not needed but can be used.
        Set-Variable -Name $variableName -Value $variableValue -Scope Script

        # Write the variable name to the host
        Write-Host "Created script-scoped variable: $variableName"
    }
    #endregion

    #region vms connection and updating main window.
    Set-RpDefaultConnectionBox            # Helper function for clearing textbox
    Set-DefaultConnectionProfileBox     # Helper function for populating connection profile textbox.
    Get-RemoteProConnections            # Fill Connections_Combo_Box with profile names.
                                        # Refresh "MilestonePSTools Connection Profile Details" tab.
    Get-RpConnectionProfileRefresh      # Helper function to refresh connection profiles
                                        # Refresh profiles by default when the main window loads
    #endregion

    #region button-click processing
    # Attach event handlers to UI elements from RemotePro.EventHandlers
    # Syntax: $xamlVariableName.event($script:RemotePro.EventType.EventName)
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
    $script:MovePrevCommand.Add_Click($script:RemotePro.EventHandlers.MovePrevButton_Click)
    $script:MoveNextCommand.Add_Click($script:RemotePro.EventHandlers.MoveNextButton_Click)
    $script:HomeCommand.Add_Click($script:RemotePro.EventHandlers.HomeButton_Click)
    $script:DarkModeToggleButton.Add_Click($script:RemotePro.EventHandlers.DarkModeToggleButton_Click)
    $script:ControlsEnabledToggleButton.Add_Click($script:RemotePro.EventHandlers.ControlsEnabledToggleButton_Click)
    $script:FlowDirectionToggleButton.Add_Click($script:RemotePro.EventHandlers.FlowDirectionToggleButton_Click)
    $script:HelloWorldButton.Add_Click($script:RemotePro.EventHandlers.HelloWorldButton_Click)
    $script:NicePopupButton.Add_Click($script:RemotePro.EventHandlers.NicePopupButton_Click)
    $script:GoodbyeButton.Add_Click($script:RemotePro.EventHandlers.GoodbyeButton_Click)
    $script:Runspace_Mutex_Log.Add_TextChanged($script:RemotePro.EventHandlers.RunspaceMutexLog_TextChanged)
    $script:Connection_Status_Box.Add_TextChanged($script:RemotePro.EventHandlers.CSB_TextChanged)

    # Attach runspace events to UI elements from RemotePro.RunspaceEvents
    # Syntax: $xamlVariableName.event($script:RemotePro.EventType.RunspaceEventName)
    $script:CamReport.Add_Click($script:RemotePro.RunspaceEvents.CamReport_Click)
    $script:ShowCameras.Add_Click($script:RemotePro.RunspaceEvents.ShowCameras_Click)
    $script:TicketBlock.Add_Click($script:RemotePro.RunspaceEvents.TicketBlock_Click)
    $script:ShowVideoOSItems.Add_Click($script:RemotePro.RunspaceEvents.ShowVideoOSItems_Click)
    $script:Hardware.Add_Click($script:RemotePro.RunspaceEvents.Hardware_Click)
    $script:itemState.Add_Click($script:RemotePro.RunspaceEvents.ItemState_Click)
    #endegion

    #region clean up main window environment
    $script:window.Add_Closed($script:RemotePro.EventHandlers.Window_AddClosed)
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
    $script:RunspaceCleanupTimer = New-Object System.Windows.Forms.Timer
    $script:RunspaceCleanupTimer.Interval = 2000  # 2 seconds
    $script:RunspaceCleanupTimer.Add_Tick({
        Watch-RpRunspaces @script:RunspaceTimerParams
    })

    $script:RunspaceCleanupTimer.Start()
    #endregion

    $window.ShowDialog() | Out-Null

    # Dispose of the window when closed
    $script:window.Close()
}


