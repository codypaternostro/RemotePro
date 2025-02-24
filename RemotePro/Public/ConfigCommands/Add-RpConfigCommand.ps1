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

    .COMPONENT
    ConfigCommands

    .PARAMETER ModuleName
    Specifies the name of the PowerShell module from which to export
    commands. Required.

    .PARAMETER CommandNames
    Specifies a list of specific commands to export from the
    module.

    .PARAMETER ConfigFilePath
    Specifies the path where the JSON configuration file is saved. If the
    file does not exist, it will be created. Default: `Get-RpConfigPath`

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
    Ensure that the PresentationFramework assembly is available for WPF
    support to allow GUI interaction. A new configuration file will be created
    if it doesn’t already exist.

    .LINK
    https://www.remotepro.dev/en-US/Add-RpConfigCommand

    #>
    [CmdletBinding(DefaultParameterSetName = 'ShowDialog')]
    param (
        # Name of the module to export commands from
        [Parameter(Mandatory=$false, Position=0, ParameterSetName='ConfigurationItems')]
        [string]$ModuleName,

        # Optional: List of specific commands to export
        [Parameter(Mandatory=$false, Position=1, ParameterSetName='ConfigurationItems')]
        [string[]]$CommandNames,

        # Path to save the configuration JSON file
        [Parameter(Mandatory=$false, Position=2, ParameterSetName='ConfigurationItems')]
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
        if (-not $PSBoundParameters.ContainsKey('ConfigFilePath') -or [string]::IsNullOrWhiteSpace($ConfigFilePath)) {
            $ConfigFilePath = Get-RpConfigPath
        }

        if (-not ($ConfigFilePath)){
            $ConfigFilePath = Get-RpConfigPath
        }


        # Check if the configuration file exists
        if (-not (Test-Path -Path $(Get-RpConfigPath))){
            New-RpConfigCommandJson -Type EmptyJson
        }

        # Initialize variables
        elseif ($ShowDialog) {
            Add-Type -AssemblyName PresentationFramework

            $resultText = @()
        }

        # Check if required parameters are missing when not using the dialog
        if (-not $PSBoundParameters.ContainsKey('ModuleName') -or -not $PSBoundParameters.ContainsKey('CommandNames')) {
            Write-Warning "Required parameters: `"ModuleName`" and `"CommandNames`" are not fully provided. Opening dialog window for input."
            $ShowDialog = $true
        }
    }

    process {
        # Show WPF dialog if -ShowDialog is used
        if ($ShowDialog) {

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

            # Set the window icon
            if ($null -ne $window) {
                Set-RpWindowIcon -window $window
            } else {
                Write-Warning "WPF window failed to load. Cannot set icon."
            }

            # Set the window icon
            if ($null -ne $window) {
                Set-RpWindowIcon -window $window
            } else {
                Write-Warning "WPF window failed to load. Cannot set icon."
            }

            # Find WPF Controls
            $moduleComboBox = $window.FindName("ModuleComboBox")
            $commandListBox = $window.FindName("CommandListBox")
            $submitButton = $window.FindName("SubmitButton")
            $cancelButton = $window.FindName("CancelButton")

            # Create a mapping of DisplayName -> ModuleName
            $moduleMapping = @{}

            foreach ($module in (Get-Module -ListAvailable)) {
                $displayName = "$($module.Name) ($($module.Version))"
                $moduleMapping[$displayName] = $module.Name
                [void]$moduleComboBox.Items.Add($displayName)
            }

            # Set default selection to the first item if available
            if ($moduleComboBox.Items.Count -gt 0) {
                $moduleComboBox.SelectedIndex = 0
            }

            # Handle module selection and extract the actual module name
            $moduleComboBox.add_SelectionChanged({
                [System.Windows.Input.Mouse]::OverrideCursor = [System.Windows.Input.Cursors]::Wait
                try {
                    $commandListBox.Items.Clear()
                    $selectedDisplayName = $moduleComboBox.SelectedItem
                    if ($selectedDisplayName) {
                        $selectedModule = $moduleMapping[$selectedDisplayName]
                        foreach ($command in (Get-Command -Module $selectedModule)) {
                            $commandListBox.Items.Add($command.Name)
                        }
                    }
                } finally {
                    [System.Windows.Input.Mouse]::OverrideCursor = $null
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
                    $dialogResults.ModuleName = $moduleMapping[$moduleComboBox.SelectedItem]
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
                    $dialogResults.ModuleName = $moduleMapping[$moduleComboBox.SelectedItem]
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

        # Use the actual ModuleName (not DisplayName or other variables)
        $actualModuleName = if ($ShowDialog) { $dialogResults.ModuleName } else { $ModuleName }

        # Ensure ConfigCommands and Module sections exist
        if (-not $config.PSObject.Properties['ConfigCommands']) {
            $config | Add-Member -MemberType NoteProperty -Name 'ConfigCommands' -Value @{}
        }
        if (-not $config.ConfigCommands.PSObject.Properties[$actualModuleName]) {
            $config.ConfigCommands | Add-Member -MemberType NoteProperty -Name $actualModuleName -Value @()
        } elseif (-not ($config.ConfigCommands.$actualModuleName -is [System.Collections.IList])) {
            $config.ConfigCommands.$actualModuleName = @($config.ConfigCommands.$actualModuleName)
        }

        # List to store generated commands
        $generatedCommands = @()

        # Add selected commands to the configuration file
        $commands = if ($commandNames) {
            try {
                Get-Command -Module $actualModuleName | Where-Object { $commandNames -contains $_.Name }
            }
            catch {
                Write-Error "Command was not selected: $_"
                return
            }
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
                'ModuleName'  = $actualModuleName  # Use actual module name
                'CommandName' = $command.Name
                'Id'          = [System.Guid]::NewGuid().ToString()
                'Description' = if ($Description) { $Description } else { "$($command.Name) command description" }
                'Parameters'  = $paramConfig
            }

            # Check for existing command and add if unique
            $existingCommands = $config.ConfigCommands.$ModuleName
            if (-not ($existingCommands | Where-Object { $_.ID -eq $Id })) {
                $config.ConfigCommands.$ModuleName += $commandDetails
                $generatedCommands += $commandDetails  # Add to the list of generated commands
            } else {
                Write-Verbose "Command with ID $Id already exists in module '$moduleName'. Skipping addition."
            }

            # Collect the ID for later use
            $collectedIds += $commandDetails.Id

            $resultText += "Assigned ModuleName: $moduleName`n"
            $resultText += "Assigned CommandNames: $commandNames`n"
            $resultText += "Assigned Id: $($commandDetails.Id)`n`n"
            # Debugging output to confirm assignment
            Write-Verbose "$($resultText)"
        }

        # Convert updated configuration back to JSON and save
        $jsonConfig = $config | ConvertTo-Json -Depth 4
        if ($configFilePath) {
            Set-Content -Path $ConfigFilePath -Value $jsonConfig
            Write-Verbose "Configuration for module '$ModuleName' saved to $configFilePath"
        } else {
            Write-Verbose "Error: ConfigFilePath is empty. Unable to save configuration."
        }

        if ($showDialog -and $commands) {
            $window = New-Object System.Windows.Window
            $window.Title = "Information"
            $window.Width = 425
            $window.Height = 220
            $window.WindowStartupLocation = "CenterScreen"
            $window.ResizeMode = "NoResize"
            $window.WindowStyle = "SingleBorderWindow"

            $stackPanel = New-Object System.Windows.Controls.StackPanel
            $stackPanel.Orientation = "Vertical"

            # TextBox for displaying resultText
            $textBox = New-Object System.Windows.Controls.TextBox
            $textBox.Text = $resultText
            $textBox.Margin = "10"
            $textBox.TextWrapping = "Wrap"
            $textBox.VerticalAlignment = "Top"
            $textBox.HorizontalAlignment = "Stretch"
            $textBox.Height = 100  # Restrict height to prevent overflowing
            $textBox.IsReadOnly = $true
            $textBox.VerticalScrollBarVisibility = "Auto"
            $textBox.HorizontalScrollBarVisibility = "Disabled"
            [void]$stackPanel.Children.Add($textBox)

            # Panel for buttons
            $buttonPanel = New-Object System.Windows.Controls.StackPanel
            $buttonPanel.Orientation = "Horizontal"
            $buttonPanel.HorizontalAlignment = "Center"
            $buttonPanel.Margin = "10"

            # Copy Button
            $copyButton = New-Object System.Windows.Controls.Button
            $copyButton.Content = "Copy Id(s)"
            $copyButton.Margin = "5"
            $copyButton.Width = 80
            $copyButton.Add_Click({
                try {
                    # Join the collected IDs into a comma-separated string
                    $idsString = $collectedIds -join ", "

                    if (-not [string]::IsNullOrWhiteSpace($idsString)) {
                        # Copy the IDs to the clipboard
                        [System.Windows.Clipboard]::SetText($idsString)
                        [System.Windows.MessageBox]::Show("Command ID(s) copied to clipboard.", "Copied", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
                    } else {
                        [System.Windows.MessageBox]::Show("No IDs found to copy.", "Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
                    }
                } catch {
                    # Handle any errors gracefully
                    [System.Windows.MessageBox]::Show("An error occurred while copying IDs: $($_.Exception.Message)", "Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
                }
            })

            [void]$buttonPanel.Children.Add($copyButton)

            # OK Button
            $okButton = New-Object System.Windows.Controls.Button
            $okButton.Content = "OK"
            $okButton.Margin = "5"
            $okButton.Width = 80
            $okButton.Add_Click({ $window.Close() })
            [void]$buttonPanel.Children.Add($okButton)

            # Add the button panel to the stack panel
            [void]$stackPanel.Children.Add($buttonPanel)

            # Set the stack panel as the content of the window
            $window.Content = $stackPanel
            [void]$window.ShowDialog()
        }
    }
    end {
        if ($showDialog){
            $window.Close()
        } elseif ($commands) {
            Set-RpConfigCommands # Update RpControllerObject with added commands.
        }
        return $generatedCommands  # Return the list of generated commands
    }
}
