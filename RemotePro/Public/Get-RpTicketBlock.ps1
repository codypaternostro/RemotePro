function Get-RpTicketBlock {
    <#
    .SYNOPSIS
    Retrieves hardware and stream information for a list of camera configuration items.

    .DESCRIPTION
    This function processes a list of camera configuration items, retrieves relevant
    hardware information such as the recording server, hardware name, stream name,
    serial number, model, IP address, MAC address, username, and password. The data
    is grouped into an array of PSCustomObjects representing each camera's hardware
    details. Optionally, the information can be displayed in a WPF window and/or
    returned as objects to the pipeline.

    .COMPONENT
    CustomVMSCmdlets

    .PARAMETER Cameras
    A list of camera configuration items (VideoOS.Platform.ConfigurationItems.Camera)
    from which the hardware information will be retrieved. This parameter is mandatory
    and accepts input from the pipeline.

    .PARAMETER ShowWindow
    If specified, a WPF window will display the grouped camera hardware information
    in a formatted list. The window allows users to click on an item to copy its details.

    .PARAMETER ReturnObjects
    If specified, the function returns the grouped camera hardware information as
    PSCustomObject items to the pipeline.

    .EXAMPLE
    Get-RpTicketBlock -Cameras $cameraList -showWindow

    Retrieves camera hardware information from the specified camera configuration items
    and displays it in a WPF window.

    .EXAMPLE
    $cameraInfo = Get-RpTicketBlock -Cameras $cameraList -ReturnObjects

    Retrieves camera hardware information from the specified camera configuration items
    and returns the results as objects to the pipeline.

    .EXAMPLE
    $cameraList | Get-RpTicketBlock -showWindow

    Pipes a list of camera configuration items and displays the retrieved hardware
    information in a WPF window.

    .LINK
    https://www.remotepro.dev/en-US/Get-RpTicketBlock
    #>
    [CmdletBinding(DefaultParameterSetName = 'CameraConfigurationItems')]
    param (
        [Parameter(ParameterSetName = 'CameraConfigurationItems', Mandatory = $true, ValueFromPipeline = $true)]
        [System.Collections.Generic.List[VideoOS.Platform.ConfigurationItems.Camera]]$Cameras,

        [Parameter(ParameterSetName = 'CameraConfigurationItems')]
        [Switch]$ShowWindow,

        [Parameter(ParameterSetName = 'CameraConfigurationItems')]
        [Switch]$ReturnObjects
    )

    begin {
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

        $groupedCameras = @()

        foreach($cam in $Cameras){
            $hwConfigItem = Get-ConfigurationItem -Path $cam.ParentItemPath
            $hwProperties = $hwConfigItem.Properties
            $hw = Get-VmsHardware -Id $hwProperties.value[0]
            $hwSettings = $hw | Get-HardwareSetting
            $hwPw = $hw | Get-VmsHardwarePassword

            $url = $hw.Address
            $CleanedIPAddress = $url -replace '^http://|/$', ''

            $inputString = $hwConfigItem.ParentPath
            $bracketPattern = '\[(.*?)\]'
            $match = [regex]::Match($inputString, $bracketPattern)
            $recorderGUID = $match.Groups[1].Value
            $recordingServer = Get-VmsRecordingServer -Id $recorderGUID
            $recordingServerModified = "$($recordingServer.DisplayName) @ $($recordingServer.ServerID.Uri)"

            $SelectedCamHw = [PSCustomObject]@{
                RecordingServer = $recordingServerModified
                HardwareName    = $hw.DisplayName
                StreamName      = $cam.Name
                Serial          = $hwSettings.SerialNumber
                Model           = $hw.Model
                Address         = $CleanedIPAddress
                MacAddress      = $hwSettings.MacAddress
                Username        = $hw.Username
                Password        = $hwPw
            }

            $groupedCameras += $SelectedCamHw
        }

        if ($showWindow) {
            Add-Type -AssemblyName PresentationFramework
            Add-Type -AssemblyName PresentationCore

            $xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:materialDesign="http://materialdesigninxaml.net/winfx/xaml/themes"
        xmlns:mdControls="clr-namespace:MaterialDesignThemes.Wpf;assembly=MaterialDesignThemes.Wpf"
        Title="Camera Hardware Information"
        WindowStartupLocation="CenterScreen"
        SizeToContent="Width"
        MinWidth="800"
        MinHeight="400"
        MaxHeight="600"
        Background="{DynamicResource MaterialDesignPaper}">

    <Window.Resources>
        <ResourceDictionary>
            <ResourceDictionary.MergedDictionaries>
                <materialDesign:BundledTheme x:Key="AppTheme" BaseTheme="Light" PrimaryColor="Grey" SecondaryColor="Lime" />
                <ResourceDictionary Source="pack://application:,,,/MaterialDesignThemes.Wpf;component/Themes/MaterialDesign2.Defaults.xaml" />
            </ResourceDictionary.MergedDictionaries>
        </ResourceDictionary>
    </Window.Resources>

    <Grid Margin="10">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto" />
            <RowDefinition Height="*" />
        </Grid.RowDefinitions>

        <!-- Instruction Label -->
        <TextBlock Grid.Row="0" Text="Click on an item to copy its details"
                   FontSize="14" FontWeight="Bold" Foreground="{DynamicResource PrimaryHueMidBrush}"
                   HorizontalAlignment="Center" Margin="0,0,0,10"/>

        <!-- ScrollViewer with automatic height management -->
        <ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto" HorizontalScrollBarVisibility="Disabled">
            <ListBox Name="CameraList" SelectionMode="Single">
                <ListBox.ItemTemplate>
                    <DataTemplate>
                        <mdControls:Card Margin="10" Padding="15" HorizontalAlignment="Center">
                            <Grid>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="Auto"/>
                                    <RowDefinition Height="Auto"/>
                                    <RowDefinition Height="Auto"/>
                                    <RowDefinition Height="Auto"/>
                                    <RowDefinition Height="Auto"/>
                                    <RowDefinition Height="Auto"/>
                                    <RowDefinition Height="Auto"/>
                                    <RowDefinition Height="Auto"/>
                                    <RowDefinition Height="Auto"/>
                                </Grid.RowDefinitions>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="Auto"/>
                                    <ColumnDefinition Width="*" />
                                </Grid.ColumnDefinitions>

                                <TextBlock Grid.Row="0" Grid.Column="0" Text="Hardware Name:" FontWeight="Bold" FontSize="14" Margin="0,0,5,0"/>
                                <TextBlock Grid.Row="0" Grid.Column="1" Text="{Binding HardwareName}" FontSize="14"/>

                                <TextBlock Grid.Row="1" Grid.Column="0" Text="Recording Server:" FontWeight="Bold" Margin="0,0,5,0"/>
                                <TextBlock Grid.Row="1" Grid.Column="1" Text="{Binding RecordingServer}" />

                                <TextBlock Grid.Row="2" Grid.Column="0" Text="Stream Name:" FontWeight="Bold" Margin="0,0,5,0"/>
                                <TextBlock Grid.Row="2" Grid.Column="1" Text="{Binding StreamName}" />

                                <TextBlock Grid.Row="3" Grid.Column="0" Text="Serial:" FontWeight="Bold" Margin="0,0,5,0"/>
                                <TextBlock Grid.Row="3" Grid.Column="1" Text="{Binding Serial}" />

                                <TextBlock Grid.Row="4" Grid.Column="0" Text="Model:" FontWeight="Bold" Margin="0,0,5,0"/>
                                <TextBlock Grid.Row="4" Grid.Column="1" Text="{Binding Model}" />

                                <TextBlock Grid.Row="5" Grid.Column="0" Text="Address:" FontWeight="Bold" Margin="0,0,5,0"/>
                                <TextBlock Grid.Row="5" Grid.Column="1" Text="{Binding Address}" />

                                <TextBlock Grid.Row="6" Grid.Column="0" Text="MAC Address:" FontWeight="Bold" Margin="0,0,5,0"/>
                                <TextBlock Grid.Row="6" Grid.Column="1" Text="{Binding MacAddress}" />

                                <TextBlock Grid.Row="7" Grid.Column="0" Text="Username:" FontWeight="Bold" Margin="0,0,5,0"/>
                                <TextBlock Grid.Row="7" Grid.Column="1" Text="{Binding Username}" />

                                <TextBlock Grid.Row="8" Grid.Column="0" Text="Password:" FontWeight="Bold" Margin="0,0,5,0"/>
                                <TextBlock Grid.Row="8" Grid.Column="1" Text="{Binding Password}" />
                            </Grid>
                        </mdControls:Card>
                    </DataTemplate>
                </ListBox.ItemTemplate>
            </ListBox>
        </ScrollViewer>
    </Grid>
</Window>
"@

            # Load the XAML and create the window
            $reader = [System.Xml.XmlNodeReader]::new([xml]$xaml)
            $window = [System.Windows.Markup.XamlReader]::Load($reader)

            # Initialize the ListBox control
            $cameraList = $window.FindName("CameraList")
            $cameraList.ItemsSource = $groupedCameras

            # Event handler for clicking on a ListBox item to copy its details
            $cameraList.Add_SelectionChanged({
                param($sender, $e)

                $selectedItem = $cameraList.SelectedItem

                if ($selectedItem) {
                    $selectedText = ""
                    $selectedItem.PSObject.Properties | ForEach-Object {
                        $selectedText += "$($_.Name): $($_.Value)`r`n"
                    }
                    [System.Windows.Clipboard]::SetText($selectedText)
                }
            })

            # Show the WPF window
            $window.ShowDialog() | Out-Null
        }

        if ($ReturnObjects) {
            return $groupedCameras
        }
    }
}
