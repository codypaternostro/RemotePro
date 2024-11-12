function Add-RpConfigCommand {
    <#
    .SYNOPSIS
    Exports command configurations from RemotePro to a JSON file.
    Allows GUI-based or parameter-based input for command selection.

    .DESCRIPTION
    The `Add-RpConfigCommand` function exports specified commands from a
    PowerShell module to a JSON configuration file. It can gather input
    interactively via a GUI dialog or directly through parameters.

    If the configuration file does not exist, a new one is created. Existing
    commands can be updated by specifying an ID. Parameters include a
    module name, command names, file path, optional description, and
    show dialog.

    .PARAMETER ModuleName
    Specifies the name of the PowerShell module from which to export
    commands. Required.

    .PARAMETER CommandNames
    Specifies a list of specific commands to export from the
    module.

    .PARAMETER ConfigFilePath
    Specifies the path where the JSON configuration file is saved. If the
    file does not exist, it will be created. Default: `Get-RPConfigPath`

    .PARAMETER Description
    Optional. A brief description for the command being exported.

    .PARAMETER ShowDialog
    Optional. Displays a GUI dialog for input. If selected, all other
    parameters are ignored, and user input is collected via the dialog.

    .PARAMETER SETS
    ShowDialog: Activates GUI-based input for all parameters.
    ConfigurationItems: Uses parameter-based input directly without GUI.

    .EXAMPLE
    Add-RpConfigCommand -ModuleName "RemotePro" -ConfigFilePath "C:\Config.json" `
                        -CommandNames "Get-RpEventHandlers", "Set-RpConfig" `
                        -Description "Initial configuration export"

    Exports "Get-RpEventHandlers" and "Set-RpConfig" commands from the
    "RemotePro" module to a JSON file at `C:\Config.json`.

    .EXAMPLE
    Add-RpConfigCommand -ModuleName "RemotePro" -ShowDialog

    Opens a GUI dialog for selecting module, commands, configuration path,
    and description, then exports the chosen commands to the JSON file.

    .NOTES
    Ensure that the `PresentationFramework` assembly is available for WPF
    support to allow GUI interaction. A new configuration file will be created
    if it doesn’t already exist.

    #>
    [CmdletBinding(DefaultParameterSetName = 'ShowDialog')]
    param (
        # Name of the module to export commands from
        [Parameter(Mandatory=$true, Position=0, ParameterSetName='ConfigurationItems')]
        [string]$ModuleName,

        # Optional: List of specific commands to export
        [Parameter(Mandatory=$true, Position=1, ParameterSetName='ConfigurationItems')]
        [string[]]$CommandNames,

        # Path to save the configuration JSON file
        [Parameter(Mandatory=$true, Position=2, ParameterSetName='ConfigurationItems')]
        [string]$ConfigFilePath,

        # Optional description for the command
        [Parameter(Mandatory=$false)]
        [string]$Description = "",

        # Optional: Show GUI dialog for input
        [Parameter(Mandatory=$false, ParameterSetName='ShowDialog')]
        [switch]$ShowDialog
    )


    begin {
        # Use appdata path if there is not a filepath value.
        if (-not ($ConfigFilePath)){
            $ConfigFilePath = Get-RPConfigPath
        }
    }

    process {
        # Show WPF dialog if -ShowDialog is used
        if ($ShowDialog) {
            Add-Type -AssemblyName PresentationFramework

            $resultText = @()

        # Define XAML layout for WPF GUI
        $xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:materialDesign="http://materialdesigninxaml.net/winfx/xaml/themes"
        xmlns:mdControls="clr-namespace:MaterialDesignThemes.Wpf;assembly=MaterialDesignThemes.Wpf"
        Title="Add-RpConfigCommand Dialog"
        Width="400" Height="550"
        WindowStartupLocation="CenterScreen"
        SizeToContent="WidthAndHeight"
        Background="{DynamicResource MaterialDesignPaper}">

    <Window.Resources>
        <ResourceDictionary>
            <ResourceDictionary.MergedDictionaries>
                <materialDesign:BundledTheme x:Key="AppTheme" BaseTheme="Light" PrimaryColor="Grey" SecondaryColor="Lime" />
                <ResourceDictionary Source="pack://application:,,,/MaterialDesignThemes.Wpf;component/Themes/MaterialDesign2.Defaults.xaml" />
            </ResourceDictionary.MergedDictionaries>
        </ResourceDictionary>
    </Window.Resources>

    <StackPanel Margin="10">
        <TextBlock Text="Select Module:" Margin="0,10,0,5"/>
        <ComboBox Name="ModuleComboBox" Width="350" />

        <TextBlock Text="Select Commands:" Margin="0,10,0,5"/>
        <ListBox Name="CommandListBox" Width="350" Height="350" SelectionMode="Multiple"/>

        <StackPanel Orientation="Horizontal" HorizontalAlignment="Center" Margin="10">
            <Button Name="SubmitButton" Content="Submit" Width="75" Margin="5" Style="{StaticResource MaterialDesignFlatButton}"/>
            <Button Name="CancelButton" Content="Cancel" Width="75" Margin="5" Style="{StaticResource MaterialDesignFlatButton}"/>
        </StackPanel>
    </StackPanel>
</Window>
"@

            # Parse XAML and load WPF elements
            $window = [Windows.Markup.XamlReader]::Parse($xaml)

            # Find WPF Controls
            $moduleComboBox = $window.FindName("ModuleComboBox")
            $commandListBox = $window.FindName("CommandListBox")
            $submitButton = $window.FindName("SubmitButton")
            $cancelButton = $window.FindName("CancelButton")

            # Populate Module ComboBox with available modules
            foreach ($module in (Get-Module -ListAvailable)) {
                [void]$moduleComboBox.Items.Add($module.Name)
            }

            # Set default selection to the first item if available
            if ($moduleComboBox.Items.Count -gt 0) {
                $moduleComboBox.SelectedIndex = 0
            }

            # Populate Commands ListBox when a module is selected
            $moduleComboBox.add_SelectionChanged({
                [System.Windows.Input.Mouse]::OverrideCursor = [System.Windows.Input.Cursors]::Wait
                try {
                    $commandListBox.Items.Clear()
                    $selectedModule = $moduleComboBox.SelectedItem
                    if ($selectedModule) {
                        foreach ($command in (Get-Command -Module $selectedModule)) {
                            $commandListBox.Items.Add($command.Name)
                        }
                    }
                } finally {
                    [System.Windows.Input.Mouse]::OverrideCursor = $null  # Reset the cursor
                }
            })

            # Initialize a hashtable to capture results
            $dialogResults = [ordered]@{
                ModuleName = $null
                CommandNames = @()
            }

            # Event Handler for Submit Button
            $submitButton.Add_Click({
                [System.Windows.Input.Mouse]::OverrideCursor = [System.Windows.Input.Cursors]::Wait
                try {
                    # Capture GUI input values in the hashtable
                    $dialogResults.ModuleName = $moduleComboBox.SelectedItem
                    $dialogResults.CommandNames = @($commandListBox.SelectedItems | ForEach-Object { $_.ToString() })

                    # Close dialog
                    $window.DialogResult = $true
                    $window.Close()
                } finally {
                    [System.Windows.Input.Mouse]::OverrideCursor = $null  # Reset the cursor
                }
            })
            # Event Handler for Cancel Button
            $cancelButton.Add_Click({
                [System.Windows.Input.Mouse]::OverrideCursor = [System.Windows.Input.Cursors]::Wait
                try {
                    # Capture GUI input values in the hashtable
                    $dialogResults.ModuleName = $moduleComboBox.SelectedItem
                    $dialogResults.CommandNames = @($commandListBox.SelectedItems | ForEach-Object { $_.ToString() })

                    # Close dialog
                    $window.DialogResult = $true
                    $window.Close()
                    $window.DialogResult = $false
                    $window.Close()
                } finally {
                    [System.Windows.Input.Mouse]::OverrideCursor = $null  # Reset the cursor
                }
            })

            # Show the WPF Window
            $result = $window.ShowDialog()
            if (-not $result) { Write-Verbose "Operation canceled by user."; return }

            # Assign GUI input results to the main function parameters
            $ModuleName = $dialogResults.ModuleName
            $CommandNames = $dialogResults.CommandNames

        }

        # Core logic starts here...
        # Load existing configuration or create a new PSCustomObject if the file does not exist
        if (Test-Path -Path $ConfigFilePath) {
            $configContent = Get-Content -Path $ConfigFilePath -Raw
            $config = $configContent | ConvertFrom-Json
        } else {
            # Create a new configuration if the file doesn't exist
            $config = [pscustomobject]@{ ConfigCommands = @{} }
            Write-Verbose "No existing configuration found. Creating a new one."
        }

        # Ensure ConfigCommands and Module sections exist
        if (-not $config.PSObject.Properties['ConfigCommands']) {
            $config | Add-Member -MemberType NoteProperty -Name 'ConfigCommands' -Value @{}
        }
        if (-not $config.ConfigCommands.PSObject.Properties[$ModuleName]) {
            $config.ConfigCommands | Add-Member -MemberType NoteProperty -Name $ModuleName -Value @()
        }

        # Add selected commands to the configuration file
        $commands = if ($CommandNames) {
            Get-Command -Module $ModuleName | Where-Object { $CommandNames -contains $_.Name }
        } else {
            Get-Command -Module $ModuleName
        }

        foreach ($command in $commands) {
            $paramConfig = [pscustomobject]@{}
            foreach ($param in $command.Parameters.Keys) {
                $paramDetails = [pscustomobject]@{
                    'Type'      = $command.Parameters[$param].ParameterType.FullName
                    'Mandatory' = $command.Parameters[$param].Attributes.Mandatory
                    'Value'     = "$null"  # Initialize Value to null
                }
                $paramConfig | Add-Member -MemberType NoteProperty -Name $param -Value $paramDetails
            }

            # Create command details for configuration
            $commandDetails = [pscustomobject]@{
                'CommandName' = $command.Name
                'Id'          = [System.Guid]::NewGuid().ToString()
                'Description' = if ($Description) { $Description } else { "$($command.Name) command description" }
                'Parameters'  = $paramConfig
            }

            # Check for existing command and add if unique
            $existingCommands = $config.ConfigCommands.$ModuleName
            if (-not ($existingCommands | Where-Object { $_.ID -eq $Id })) {
                $config.ConfigCommands.$ModuleName += $commandDetails
            } else {
                Write-Verbose "Command with ID $Id already exists in module '$ModuleName'. Skipping addition."
            }

            $resultText += " Assigned ModuleName: $ModuleName`n"
            $resultText += "Assigned CommandNames: $CommandNames`n"
            $resultText += "Assigned Id: $($commandDetails.Id)`n"
            # Debugging output to confirm assignment
            Write-Verbose "$($resultText)"
        }

        # Convert updated configuration back to JSON and save
        $jsonConfig = $config | ConvertTo-Json -Depth 4
        if ($ConfigFilePath) {
            Set-Content -Path $ConfigFilePath -Value $jsonConfig
            Write-Verbose "Configuration for module '$ModuleName' saved to $ConfigFilePath"
        } else {
            Write-Verbose "Error: ConfigFilePath is empty. Unable to save configuration."
        }

        if ($ShowDialog){
            $window = New-Object System.Windows.Window
            $window.Title = "Information"
            $window.Width = 400
            $window.Height = 220
            $window.WindowStartupLocation = "CenterScreen"
            $window.ResizeMode = "NoResize"
            $window.WindowStyle = "SingleBorderWindow"

            $stackPanel = New-Object System.Windows.Controls.StackPanel
            $stackPanel.Orientation = "Vertical"

            $textBlock = New-Object System.Windows.Controls.TextBlock
            $textBlock.Text = $resultText
            $textBlock.Margin = "10"
            $textBlock.TextWrapping = "Wrap"
            $textBlock.VerticalAlignment = "Center"
            [void]$stackPanel.Children.Add($textBlock)

            $buttonPanel = New-Object System.Windows.Controls.StackPanel
            $buttonPanel.Orientation = "Horizontal"
            $buttonPanel.HorizontalAlignment = "Center"
            $buttonPanel.Margin = "10"
            $copyButton = New-Object System.Windows.Controls.Button
            $copyButton.Content = "Copy"
            $copyButton.Margin = "5"
            $copyButton.Width = 80
            $copyButton.Add_Click({
                [System.Windows.Clipboard]::SetText($resultText)
                [System.Windows.MessageBox]::Show("Text copied to clipboard.", "Copied", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
            })

            $okButton = New-Object System.Windows.Controls.Button
            $okButton.Content = "OK"
            $okButton.Margin = "5"
            $okButton.Width = 80
            $okButton.Add_Click({ $window.Close() })


            [void]$buttonPanel.Children.Add($copyButton)
            [void]$buttonPanel.Children.Add($okButton)
            [void]$stackPanel.Children.Add($buttonPanel)

            $window.Content = $stackPanel
            [void]$window.ShowDialog()
        }
    }
    end {
        if ($ShowDialog){
            $window.Close()
        }
    }
}
