function Show-RpCamera {
    <#
    .SYNOPSIS
        Displays a UI for live viewing or playback of camera feeds in a security
        system.

    .DESCRIPTION
        The Show-RpCamera function allows users to interact with camera feeds using
        different methods of camera selection. It supports viewing live feeds,
        playback of recorded sequences, and diagnostics overlay on the video feed.
        Users can select cameras by ID, through a direct camera object, or via user
        interface dialogs. Please see link for original script from joshooaj who
        inspired all of RemotePro from sharing this incredible function.

    .PARAMETER CameraObject
        Directly pass a camera object to alleviate object dependency between
        threads. Mandatory in the 'CameraObjectSet' parameter set.

    .PARAMETER Id
        Specifies the camera IDs as GUIDs. When this parameter is used, camera
        selection dialogs are bypassed. Mandatory in the 'IdSet' parameter set.

    .PARAMETER ShowRPItemPicker
        Displays a custom item picker dialog for camera selection. Mandatory in the
        'RPItemPickerSet' parameter set.

    .PARAMETER ShowSelectCamera
        Uses the default camera selection dialog. Mandatory in the 'SelectCameraSet'
        parameter set.

    .PARAMETER DiagnosticLevel
        Specifies the diagnostic overlay level (0-4) for the video feed. This is
        optional and defaults to '0'.

    .PARAMETER SpecifiedDaysForSequences
        Specifies the number of days for which to generate and display sequence data
        from motion-triggered recordings. This parameter is mandatory.

    .PARAMETER CheckConnection
        Validates the VMS connection before attempting to show cameras. If the
        connection is invalid, an error dialog is shown. This parameter is optional.

    .EXAMPLE
        Show-RpCamera -ShowSelectCamera
        # This command opens the standard camera selection dialog and displays the
        # selected camera feed without any diagnostic overlays.

    .EXAMPLE
        Show-RpCamera -Id '12345678-9abc-def0-1234-567890abcdef' -SpecifiedDaysForSequences 7
        # This command displays the feed of a camera identified by the specified GUID
        # with sequence data for the past 7 days.

    .EXAMPLE
        Show-RpCamera -ShowRPItemPicker -DiagnosticLevel '3' -SpecifiedDaysForSequences 30
        # This command uses a custom item picker for camera selection and shows the
        # selected camera feed with a high diagnostic level overlay for the past 30
        # days.

    .NOTES
        - Requires a connection to a VMS (Video Management System).
        - Designed for use in environments where monitoring multiple camera feeds is
        crucial.
        - Flexible camera selection is provided to accommodate different user
        preferences and requirements.
    .LINK
        https://gist.github.com/joshooaj/9cf16a92c7e57496b6156928a22f758f
    #>
    [CmdletBinding(DefaultParameterSetName='RPItemPickerSet')]
    param (
        # Optional to pass in camera object to alleviate object dependency between threads.
        [Parameter(ValueFromPipeline,ParameterSetName='CameraObjectSet', Mandatory=$true)]
        $CameraObject,

        # Specifies the Id of the camera you wish to view. Omit this parameter and you can select a camera from an item selection dialog.
        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName='IdSet', Mandatory=$true)]
        [guid[]]
        $Id,

        # Show RPItemPicker instead of Select-Camera for making selections
        [Parameter(ParameterSetName='RPItemPickerSet', Mandatory=$true)]
        [switch]
        $ShowRPItemPicker,

        # Show Select-Camera instead of Show-RPItemPicker for making selections
        [Parameter(ParameterSetName='SelectCameraSet', Mandatory=$true)]
        [switch]
        $ShowSelectCamera,

        # Specifies the diagnostic overview level to show overlayed onto the image
        [Parameter()]
        [ValidateSet('0','1','2','3','4')]
        [string]
        $DiagnosticLevel = '0',

        # Specifies the amount of Days to generate sequence data from event data for
        # for the given data to create a timespan from the present day.
        [Parameter(Mandatory=$true)]
        [int]
        $SpecifiedDaysForSequences,

        # Validate active connection and display error message window.
        [Parameter(Mandatory=$false)]
        [switch]$CheckConnection
    )

    begin {
        # ToDo: Remove this line when the module is imported in the script
        # replace with correct reference to the module
        import-module C:\RemotePro\RemotePro\RemotePro.psd1
        Add-Type -AssemblyName PresentationFramework
        $connectionValid = $true

        if ($CheckConnection) {
            if (-not (Test-RpVmsConnection -ShowErrorDialog $true)) {
                $connectionValid = $false
            }
        }
    }

    process {
        if (-not $connectionValid) {
            Write-Host "Connection validation failed. No VMS connection available."
            return
        }

        if ($PSCmdlet.ParameterSetName -eq 'CameraObjectSet') {
            $cameraItems = $CameraObject
        }
        elseif ($PSCmdlet.ParameterSetName -eq 'IdSet') {
            $cameraItems = $Id | ForEach-Object { Get-VmsCamera -Id $_ | Get-VmsVideoOSItem -Kind Camera }
        }
        elseif ($PSCmdlet.ParameterSetName -eq 'RPItemPickerSet') {
            $cameraItems = Show-RPItemPicker -Title "Custom Item Picker" -Kind @("Camera") -CheckConnection:$CheckConnection
        }
        elseif ($PSCmdlet.ParameterSetName -eq 'SelectCameraSet') {
            $cameraItems = Select-Camera -Title "Select one or more cameras" -OutputAsItem -AllowFolders -AllowServers -RemoveDuplicates
        }

        if ($null -eq $cameraItems -or $cameraItems.Count -eq 0) {
            Write-Error "No camera(s) selected"
            return
        }

        # TODO Condition for selecting entire camera folder - could be reworked into Show-RPItemPicker.
        if ($cameraItems.GetType().FullName -eq "VideoOS.Platform.SDK.Platform.AllRSFolderItem") {
            $cameraItems = $cameraItems.GetChildren()
        }

        foreach ($item in $cameraItems) {
            # Generate last 7 days of recorded squences from motion iniated recordings, store the last to pass into PlaybackWpfUserControl
            # Use VideoOS.Platform.SDK.Platform.CameraItem.FQID.ObjectId for camera Id.
            $sequenceData = Get-VmsCamera -Id $item.FQID.ObjectId | Get-SequenceData -SequenceType MotionSequence -StartTime ([DateTime]::UtcNow).AddDays(-$SpecifiedDaysForSequences)

            # Store the last EvenSequence
            $lastSequence = $sequenceData | Select-Object -last 1

            # Store the start and end sequence dates from the last EventSequnce from EventData.
            $fromSequenceDate = $lastSequence.EventSequence.StartDateTime
            $toSequenceDate = $lastSequence.EventSequence.EndDateTime

            # Add squence "From" and "To" property to camera object.
            $item | Add-Member -MemberType NoteProperty -Name FromSequenceDate -Value $fromSequenceDate
            $item | Add-Member -MemberType NoteProperty -Name ToSequenceDate -Value $toSequenceDate
        }


        $xaml = [xml]@"
<Window
xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
xmlns:local="clr-namespace:WpfApp1"
xmlns:mip="clr-namespace:VideoOS.Platform.Client;assembly=VideoOS.Platform"
Title="$($MyInvocation.Line)" Height="450" Width="800">
    <TabControl Name="Tabs">
        <TabItem Header="Live" Name="LiveTab">
            <TabItem.Content>
                <UniformGrid Grid.Row="0" Name="LiveGrid" />
            </TabItem.Content>
        </TabItem>
        <TabItem Header="Playback" Name="PlaybackTab">
            <TabItem.Content>
                <Grid>
                    <Grid.RowDefinitions>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="100"/>
                    </Grid.RowDefinitions>
                        <UniformGrid Grid.Row="0" Name="PlaybackGrid" />
                        <mip:PlaybackWpfUserControl Visibility="Visible" Name="PlaybackControl" Grid.Row="2" ShowTallUserControl="True" ShowTimeSpanControl="True" ShowSpeedControl="True" />
                </Grid>
            </TabItem.Content>
        </TabItem>
        <TabItem Header="LastRecording" Name="LastRecordingTab">
            <TabItem.Content>
                <Grid>
                    <Grid.RowDefinitions>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="100"/>
                    </Grid.RowDefinitions>
                        <UniformGrid Grid.Row="0" Name="LastPlaybackGrid" />
                        <mip:PlaybackWpfUserControl Visibility="Visible" Name="PlaybackControl2" Grid.Row="2" ShowTallUserControl="True" ShowTimeSpanControl="True" ShowSpeedControl="True" />
                </Grid>
            </TabItem.Content>
        </TabItem>
    </TabControl>
</Window>

"@
        try {
            $reader = [system.xml.xmlnodereader]::new($xaml)
            $window = [windows.markup.xamlreader]::Load($reader)


            $tabs = [system.windows.controls.tabcontrol]$window.FindName('Tabs')
            $liveGrid = [system.windows.controls.primitives.uniformgrid]$window.FindName('LiveGrid')
            $playbackGrid = [system.windows.controls.primitives.uniformgrid]$window.FindName('PlaybackGrid')
            $LastPlaybackGrid = [system.windows.controls.primitives.uniformgrid]$window.FindName('LastPlaybackGrid')
            $playbackFqid = [VideoOS.Platform.ClientControl]::Instance.GeneratePlaybackController()
            $playbackFqid2 = [VideoOS.Platform.ClientControl]::Instance.GeneratePlaybackController()
            #####$PlaybackControl.SetSequence($lastStartSequenceDate,$lastEndSequenceDate)

            $playbackControl = [videoos.platform.client.PlaybackWpfUserControl]$window.FindName('PlaybackControl')
            $playbackControl2 = [videoos.platform.client.PlaybackWpfUserControl]$window.FindName('PlaybackControl2')


            # https://doc.developer.milestonesys.com/html/MIPhelp/class_video_o_s_1_1_platform_1_1_client_1_1_playback_wpf_user_control.html


            ######$PlaybackControl.SetSequence($StartSequenceDate,$EndSequenceDate)

            $playbackControl.Init($playbackFqid)
            $playbackControl2.Init($playbackFqid2)


            $tabs.Add_SelectionChanged({
                param($source, [system.windows.controls.selectionchangedeventargs]$e)
                if ($e.AddedItems.Count -eq 0 -or $e.RemovedItems.Count -eq 0) {
                    # During startup, this event will be triggered by adding the live/playback tabitems to the tabcontrol.
                    return
                }

                # When user switches from live to playback and back, we disconnect the live/playback view items to minimize bandwidth/resource usage
                $selected = [system.windows.controls.tabitem]$e.AddedItems[0]
                $deselected = [system.windows.controls.tabitem]$e.RemovedItems[0]
                foreach ($viewer in $selected.FindName("$($selected.Header)Grid").Children) {
                    Write-Host "$viewer"
                    $viewer.Connect()
                }
                foreach ($viewer in $deselected.FindName("$($deselected.Header)Grid").Children) {
                    $viewer.Disconnect()
                }
            })


            foreach ($item in $cameraItems) {
                $liveViewer = [videoos.platform.client.imageviewerwpfcontrol]::new()
                $liveViewer.CameraFQID = $item.FQID
                $liveViewer.Initialize()
                $liveViewer.EnableDigitalZoom = $true
                $liveViewer.EnableMouseControlledPtz = $true
                $liveViewer.AdaptiveStreaming = $true
                $liveViewer.Connect()

                # https://doc.developer.milestonesys.com/html/MIPhelp/class_video_o_s_1_1_platform_1_1_client_1_1_playback_wpf_user_control.html#a5871fb628d6ffe678f479573b122dde2
                #$playbackControl.SelectionToTime = $item.ToSequenceDate
                # https://doc.developer.milestonesys.com/html/MIPhelp/class_video_o_s_1_1_platform_1_1_client_1_1_playback_wpf_user_control.html#ab62f27a35d782b25a4608b6b14760d31
                #$playbackControl.SelectionFromTime = $item.FromSequenceDate


                $playbackControl.SetCameras($item.FQID)

                $playbackControl.ShowTallUserControl
                $playbackControl.ShowTimeSpanControl
                $playbackControl.ShowSpeedControl

                #$playbackControl.ShowTallUserControl.IsChecked.Value
                #$playbackControl.ShowTimeSpanControl.IsChecked.Value
                #$playbackControl.ShowSpeedControl.IsChecked.Value
                # https://doc.developer.milestonesys.com/html/MIPhelp/class_video_o_s_1_1_platform_1_1_client_1_1_image_viewer_wpf_control.html
                $playbackViewer = [videoos.platform.client.imageviewerwpfcontrol]::new()



                $playbackViewer.PlaybackControllerFQID = $playbackFqid
                $playbackViewer.CameraFQID = $item.FQID
                $playbackViewer.Initialize()


                $playbackViewer.EnableDigitalZoom = $true
                $playbackViewer.EnableMouseControlledPtz = $true
                $playbackViewer.EnableBrowseMode = $true



                $playbackControl2.SetCameras($item.FQID)

                if ($SpecifiedDaysForSequences) {
                    $playbackControl2.SetSequence($item.FromSequenceDate,$item.ToSequenceDate)
                }

                $playbackControl2.ShowTallUserControl = $true
                $playbackControl2.ShowTimeSpanControl = $true
                $playbackControl2.ShowSpeedControl = $true
                $playbackViewerLastRecording = [videoos.platform.client.imageviewerwpfcontrol]::new()
                $playbackViewerLastRecording.PlaybackControllerFQID = $playbackFqid2
                $playbackViewerLastRecording.CameraFQID = $item.FQID
                $playbackViewerLastRecording.Initialize()

                $playbackViewerLastRecording.EnableDigitalZoom = $true
                $playbackViewerLastRecording.EnableMouseControlledPtz = $true
                $playbackViewerLastRecording.EnableBrowseMode = $true


                $liveGrid.AddChild($liveViewer)
                $playbackGrid.AddChild($playbackViewer)
                $LastPlaybackGrid.AddChild($playbackViewerLastRecording)

            }
            [videoos.platform.environmentmanager]::Instance.EnvironmentOptions.PlayerDiagnosticLevel = $DiagnosticLevel
            [videoos.platform.environmentmanager]::Instance.FireEnvironmentOptionsChangedEvent()
            [videoos.platform.environmentmanager]::Instance.SendMessage([videoos.platform.messaging.message]::new([videoos.platform.messaging.messageid+system]::ModeChangeCommand, [videoos.platform.Mode]::ClientPlayback), $playbackFqid)
            [videoos.platform.environmentmanager]::Instance.SendMessage([videoos.platform.messaging.message]::new([videoos.platform.messaging.messageid+system]::ModeChangeCommand, [videoos.platform.Mode]::ClientPlayback), $playbackFqid2)
            $null = $window.ShowDialog()

        }
        finally {
            foreach ($child in $liveGrid.Children + $playbackGrid.Children + $LastPlaybackGrid.Children) {
                $child.Disconnect()
                $child.Dispose()
            }
            if ($null -ne $playbackControl -or $null -ne $playbackControl2) {

                $playbackControl.Close()
                $playbackControl2.Close()
            }
            if ($window) {
                #ReleasePlaybackController (FQID fqid)
                [VideoOS.Platform.ClientControl]::Instance.ReleasePlaybackController($playbackFqid)
                [VideoOS.Platform.ClientControl]::Instance.ReleasePlaybackController($playbackFqid2)
                #$playbackControl.ReleasePlaybackController($playbackFqid)
                #$playbackControl2.ReleasePlaybackController($playbackFqid2)
                #$playbackControl.ReleasePlaybackController() #added 05/22/24
                #$playbackControl2.ReleasePlaybackController() #added 05/22/24
                $window.Close()

            }
        }
<#
 # {    } else {
        [System.Windows.MessageBox]::Show("No VMS connection.", "Exit", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning)
    }:Enter a comment or description}
#>
    }
}

[System.GC]::Collect()
[System.GC]::WaitForPendingFinalizers()

#Show-RpCamera -SpecifiedDaysForSequences 90 -DiagnosticLevel 3
