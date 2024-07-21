# After working with Josh's show-camera for powershell I was able to understand WPF and it's uses with MIPSDK
# https://gist.github.com/joshooaj/9cf16a92c7e57496b6156928a22f758f
# I noticed VideoOS.Platform.UI.ItemPickerWpfUserControl released from the MIPSDK
# https://doc.developer.milestonesys.com/html/index.html
# This still needs to be tested more, but it offers a way to search via text for items available on XProtect VMS of items in WPF window.function Show-RPItemPicker

function Show-RPItemPicker {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$Title = "Select Item(s)",
        [Parameter()]
        [string[]]$Kind
    )

    Add-Type -AssemblyName PresentationFramework
    #Install-Module MilestonePSTools
    Assert-VmsRequirementsMet

    # Define the XAML with the button included
    $xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Milestone Item Picker" Height="600" Width="800">
    <Grid x:Name="mainGrid" Margin="10">
        <Grid.RowDefinitions>
            <RowDefinition Height="*" />
            <RowDefinition Height="Auto" />
        </Grid.RowDefinitions>
        <ContentControl x:Name="itemPickerHost" Grid.Row="0" Margin="5" />
        <Button Content="Get Selected Items" Grid.Row="1" HorizontalAlignment="Center" VerticalAlignment="Center"
                Margin="10" Padding="10,5" Background="#007ACC" Foreground="White" BorderBrush="#005A9E" BorderThickness="1" />
    </Grid>
</Window>
"@

    # Convert the XAML string to XML
    $reader = [System.Xml.XmlNodeReader]::new([xml]$xaml)

    # Load the XAML
    $window = [System.Windows.Markup.XamlReader]::Load($reader)

    # Create an instance of the ItemPickerWpfUserControl using reflection
    $itemPickerType = [VideoOS.Platform.UI.ItemPickerWpfUserControl]
    $itemPickerControl = [Activator]::CreateInstance($itemPickerType)

    # Set properties to customize the behavior of the control
    $itemPickerControl.AllowGroupSelection = $true
    $itemPickerControl.AutoExpand = $true
    $itemPickerControl.EmptyListOverlayText = "No items selected"
    $itemPickerControl.IsMultiSelection = $true
    $itemPickerControl.SearchEnabled = $true
    $itemPickerControl.SearchPlaceholderText = "Search for items..."
    $itemPickerControl.TableHeader = "Selected Items"

    # Retrieve items from the server based on Kind
    $script:items = @()
    if ($Kind -and $Kind.Count -gt 0) {
        foreach ($kindName in $Kind) {
            $script:items += Get-VmsVideoOSItem -Kind ([VideoOS.Platform.Kind]::$kindName) -ItemHierarchy 'SystemDefined' -FolderType 'SystemDefined'
        }
    } else {
        $script:items = Get-VmsVideoOSItem -ItemHierarchy 'SystemDefined' -FolderType 'SystemDefined' -Verbose
    }

    if ($null -ne $script:items -and $script:items.Count -gt 0) {
        # Cast items to the correct type
        $itemPickerControl.Items = [System.Collections.Generic.List[VideoOS.Platform.Item]]$script:items
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
            $window.DialogResult = $true
            $window.Close()
        })

        # Add the ItemPickerWpfUserControl to the ContentControl
        $itemPickerHost = $window.FindName("itemPickerHost")
        $itemPickerHost.Content = $itemPickerControl

        # Show the WPF window
        $window.ShowDialog() | Out-Null
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

    # Filter the original items based on the selected item IDs
    $script:selectedItems = $script:items | Where-Object { $script:selectedItemDetails.Id -contains $_.FQID.ObjectId }

    # Debug output to check what is being returned
    Write-Verbose "Returning items: $($script:selectedItems.Count)"
    foreach ($item in $script:selectedItems) {
        Write-Verbose "Returning item: Name=$($item.Name), Id=$($item.FQID.ObjectId), FQID=$($item.FQID)"
    }

    return $script:selectedItems
}

# Example of using this window with MilestonePSTools active connection in your shell.
$selectedItems = Show-RPItemPicker -Title "Custom Item Picker" -Kind @("Camera", "Hardware") -Verbose
$selectedItems | ForEach-Object { Write-Host "Selected item: Id=$($_.FQID.ObjectId), Name=$($_.Name), FQID=$($_.FQID)" }
