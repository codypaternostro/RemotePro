function Show-RpItemPicker {
    <#
    .SYNOPSIS
        Displays an item picker dialog and allows selection of items based on specified
        types such as Camera, Hardware, or Server.

    .DESCRIPTION
        The Show-RpItemPicker function opens a window with a customizable item picker
        control. Users can select items categorized as Camera, Hardware, or Server.
        The function supports configuration for displaying only camera items and checks
        the connection to the VMS system before proceeding.

    .PARAMETERS
        -Title
            Specifies the title of the item picker window. Default is "Select Item(s)".

        -Kind
            Defines the types of items to be displayed in the picker. Accepts multiple
            values from 'Camera', 'Hardware', 'Server'.

        -ConfigItemsCamsOnly
            When specified, filters the results to return only camera items.

        -CheckConnection
            Checks the VMS connection before showing the item picker. If the connection
            fails, the function will not proceed.

    .COMPONENT
    CustomVMSCmdlets

    .EXAMPLE
        Show-RpItemPicker -Title "Select Cameras" -Kind 'Camera'
        # Opens the item picker with the title "Select Cameras" displaying only camera items.

    .EXAMPLE
        Show-RpItemPicker -Title "Hardware Selection" -Kind 'Hardware' -CheckConnection
        # Checks the connection first, then shows a picker for selecting hardware items.

    .NOTES
        This function relies on the VideoOS.Platform.UI module for UI elements and
        VideoOS.Platform.SDK to interact with the VMS system. Proper error handling
        is implemented to manage any exceptions during the operation, ensuring the
        application remains stable even if an error occurs.

    .LINK
        Further documentation on ItemPickerWpfUserControl item management can be found at the
        official documentation portal.
        https://doc.developer.milestonesys.com/html/index.html

    #>
    [CmdletBinding(DefaultParameterSetName='VideoOS.Platform.SDK.Platform')]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Title = "Select Item(s)",

        [Parameter(Mandatory=$true)]
        [ValidateSet("Camera", "Hardware", "Server")]
        [string[]]$Kind,

        [Parameter(Mandatory=$false)]
        [switch]$ConfigItemsCamsOnly,

        [Parameter(Mandatory=$false)]
        [switch]$CheckConnection
    )

    begin {
        # ToDo: Remove this line when the module is imported in the script
        # replace with correct reference to the module
        Import-Module -Name RemotePro
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
        # Define the XAML with the button included
        $xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:materialDesign="http://materialdesigninxaml.net/winfx/xaml/themes"
        xmlns:mdControls="clr-namespace:MaterialDesignThemes.Wpf;assembly=MaterialDesignThemes.Wpf"
        Title="Milestone Item Picker" Height="600" Width="800"
        Background="{DynamicResource MaterialDesignPaper}">

    <Window.Resources>
        <ResourceDictionary>
            <ResourceDictionary.MergedDictionaries>
                <ResourceDictionary Source="pack://application:,,,/MaterialDesignThemes.Wpf;component/Themes/MaterialDesign2.Defaults.xaml" />
                <materialDesign:BundledTheme BaseTheme="Light" PrimaryColor="Grey" SecondaryColor="Lime" />
            </ResourceDictionary.MergedDictionaries>
        </ResourceDictionary>
    </Window.Resources>

    <Grid x:Name="mainGrid" Margin="10">
        <Grid.RowDefinitions>
            <RowDefinition Height="*" />
            <RowDefinition Height="Auto" />
        </Grid.RowDefinitions>

        <!-- Content Control for item picker -->
        <ContentControl x:Name="itemPickerHost" Grid.Row="0" Margin="5" />

        <!-- Material Design styled button matching previous color scheme -->
        <Button Content="Get Selected Items" Grid.Row="1" HorizontalAlignment="Center" VerticalAlignment="Center"
                Margin="10" Padding="10,5"
                Style="{StaticResource MaterialDesignRaisedButton}"
                Background="{DynamicResource PrimaryHueMidBrush}"
                Foreground="{DynamicResource PrimaryHueLightForegroundBrush}"
                BorderBrush="{DynamicResource PrimaryHueDarkBrush}" />
    </Grid>
</Window>
"@

        # Convert the XAML string to XML
        $reader = [System.Xml.XmlNodeReader]::new([xml]$xaml)

        # Load the XAML
        $window = [System.Windows.Markup.XamlReader]::Load($reader)

        # Create an instance of the ItemPickerWpfUserControl
        $itemPickerControl = New-Object VideoOS.Platform.UI.ItemPickerWpfUserControl

        # Set properties to customize the behavior of the control
        $itemPickerControl.AllowGroupSelection = $true
        $itemPickerControl.AutoExpand = $true
        $itemPickerControl.EmptyListOverlayText = "No items selected"
        $itemPickerControl.IsMultiSelection = $true
        $itemPickerControl.SearchEnabled = $true
        $itemPickerControl.SearchPlaceholderText = "Search for items..."
        $itemPickerControl.TableHeader = "Selected Items"

        # Initialize the items list
        $itemsList = New-Object 'System.Collections.Generic.List[VideoOS.Platform.Item]'

        function Get-KindGuid {
            param ($kindName)
            switch ($kindName) {
                "Camera" { return [VideoOS.Platform.Kind]::Camera }
                "Hardware" { return [VideoOS.Platform.Kind]::Hardware }
                "Server" { return [VideoOS.Platform.Kind]::Server }
                default { throw "Unknown kind: $kindName" }
            }
        }

        # Retrieve items from the server based on Kind
        if ($Kind -and $Kind.Count -gt 0) {
            foreach ($kindName in $Kind) {
                $kindGuid = Get-KindGuid -kindName $kindName
                $items = Get-VmsVideoOSItem -Kind $kindGuid -ItemHierarchy 'SystemDefined' -FolderType 'SystemDefined'
                if ($items) {
                    foreach ($item in $items) {
                        if ($item -is [VideoOS.Platform.Item]) {
                            $itemsList.Add($item)
                        }
                    }
                }
            }
        } else {
            $items = Get-VmsVideoOSItem -ItemHierarchy 'SystemDefined' -FolderType 'SystemDefined' -Verbose
            foreach ($item in $items) {
                if ($item -is [VideoOS.Platform.Item]) {
                    $itemsList.Add($item)
                }
            }
        }

        if ($itemsList.Count -gt 0) {
            # Set the Items property directly
            $itemPickerControl.Items = $itemsList
        } else {
            Write-Verbose "No items retrieved from the server"
        }

        $script:selectedItemDetails = @()

        try {
            # Event handler for the button click
            $button = $window.FindName("mainGrid").Children | Where-Object { $_ -is [System.Windows.Controls.Button] }
            $button.Add_Click({
                $script:selectedItemDetails = $itemPickerControl.SelectedItems | ForEach-Object {
                    @{
                        Name = $_.Name
                        Id = $_.FQID.ObjectId
                        FQID = $_.FQID
                    }
                }
                Write-Verbose "Number of selected items: $($script:selectedItemDetails.Count)"
                foreach ($item in $script:selectedItemDetails) {
                    Write-Verbose "Selected item: Name=$($item.Name), Id=$($item.Id), FQID=$($item.FQID)"
                }
                $null = $window.DialogResult = $true
                $window.Close()
            })

            # Add the ItemPickerWpfUserControl to the ContentControl
            $itemPickerHost = $window.FindName("itemPickerHost")
            $itemPickerHost.Content = $itemPickerControl

            # Show the WPF window
            $null = $window.ShowDialog()

            # Filter the original items based on the selected item IDs
            $script:selectedItems = $itemPickerControl.SelectedItems | Where-Object { $script:selectedItemDetails.Id -contains $_.FQID.ObjectId }

            # Debug output to check what is being returned
            Write-Verbose "`nReturning $($script:selectedItems.Count)items:"
            foreach ($item in $script:selectedItems) {
                Write-Verbose "Returning item: Name=$($item.Name), Id=$($item.FQID.ObjectId), FQID=$($item.FQID)"
            }

            # Switch and logic for return items of type VideoOS.Platform.ConfigurationItems.Camera
            if ($ConfigItemsCamsOnly){
                # Final type = VideoOS.Platform.ConfigurationItems.Camera
                $cameras = [System.Collections.Generic.List[VideoOS.Platform.ConfigurationItems.Camera]]::new()


                foreach ($item in $script:selectedItems){
                    switch ($item.GetType().FullName) { #Switches ensures selected object types get handled correctly.
                        #region Camera Items
                        "VideoOS.Platform.SDK.Platform.CameraItem" {
                            # Convert Camera objects from type Platform.SDK to Configuration
                            $camera = Get-VmsCamera -Id $item.FQID.ObjectId
                            $cameras.Add($camera)
                        }
                        #endregion

                        #region Hardware Items
                        "VideoOS.Platform.SDK.Platform.HardwareItem" {
                            # Convert Hardware objects from type Platform to Configruation
                            $configItemCam = Get-VmsHardware -id $item.FQID.ObjectId.ToString() | Get-VmsCamera
                            $cameras.Add($configItemCam)
                        }
                        #endregion

                        #region All Hardware folders
                        "VideoOS.Platform.SDK.Platform.HardwareFolderItem" {
                            # VideoOS.Platform.SDK.Platform.HardwareFolderItem
                            $hwFolder = $item.GetChildren()

                            # VideoOS.Platform.ConfigurationItems.Hardware
                            $hwItems = $hwFolder.Values | Get-VmsHardware

                            # Final Conversion: Completed type to VideoOS.Platform.SDK.Platform.CameraItem
                            foreach ($hw in $hwItems) {
                                $configItemCam = $hw | Get-VmsCamera
                                $cameras.Add($configItemCam)
                            }
                        }
                        #endregion

                        #region All Camera folders
                        "VideoOS.Platform.SDK.Platform.AllRSFolderItem" {
                            # VideoOS.Platform.SDK.Platform.AllRSFolderItem
                            $camFolder = $item.GetChildren()

                            # Final Conversion: Completed type to VideoOS.Platform.SDK.Platform.CameraItem
                            foreach ($cam in $camFolder) {
                                $camera = Get-VmsCamera -Id $cam.FQID.ObjectId
                                $cameras.Add($camera)
                            }
                        }
                        #endregion

                        #region Recording Server Folders
                        "VideoOS.Platform.SDK.Platform.ServerFolderByTypeItem" {
                            # Unnroll recording servers
                            $srvFolderChildren = $item.GetChildren()

                            # (plural) VideoOS.Platform.SDK.Platform.RecorderFolderByTypeItem to VideoOS.Platform.ConfigurationItems.RecordingServer
                            $recServers = $srvFolderChildren | Get-RecordingServer


                            # Final Conversion: Completed type to VideoOS.Platform.SDK.Platform.CameraItem
                            foreach ($server in $recServers) {
                                $server | Get-VmsHardware | Get-VmsCamera | ForEach-Object { $cameras.Add($_) }
                            }
                        }
                        #endregion

                        #region Recording Servers
                        "VideoOS.Platform.SDK.Platform.ServerFolderByTypeItem" {
                            # (single) VideoOS.Platform.SDK.Platform.RecorderFolderByTypeItem to VideoOS.Platform.ConfigurationItems.RecordingServer
                            $recServer = $item | Get-RecordingServer

                            # Final Conversion: Completed type to VideoOS.Platform.SDK.Platform.CameraItem
                            $recServer | Get-VmsHardware | Get-VmsCamera | ForEach-Object { $cameras.Add($_) }
                        }
                        #endregion
                    }
                }

                return $cameras # VideoOS.Platform.ConfigurationItems.Camera
            } else {
                return $script:selectedItems # VideoOS.Platform.SDK.Platform
            }
        }
        catch {
            Write-Error "An error occurred: $_"
        }
        finally {
            # Properly dispose of the window and control
            if ($null -ne $itemPickerControl) {
                $itemPickerControl.Dispose()
            }
            if ($null -ne $window) {
                $window.Close()
            }
        }
    }
}

    # Clear variables
<#
    Remove-Variable $xaml
    Remove-Variable $reader
    Remove-Variable $window
    Remove-Variable $itemPickerControl
    Remove-Variable $itemsList
    Remove-Variable $selectedItemDetails
    Remove-Variable $button
#>
