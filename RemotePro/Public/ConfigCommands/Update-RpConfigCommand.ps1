function Update-RpConfigCommand {
    <#
    .SYNOPSIS
    Modifies configuration parameters of a specified command in a PowerShell
    module using a configuration JSON file or an interactive WPF-based GUI.

    .DESCRIPTION
    The `Update-RpConfigCommand` function is used to load and modify parameters for
    a specified command within a PowerShell module. The function retrieves
    configuration information from a JSON file and supports updating parameters
    either by launching a GUI (if `-ShowDialog` is specified) or by directly
    passing a hashtable of parameter values through the `-Parameters`
    parameter. The updated configuration is saved back to the JSON file,
    preserving all previous configurations.

    By default, the function opens a GUI for parameter editing, making it
    user-friendly for interactive scenarios. Advanced users and scripts can also
    bypass the GUI and pass values directly through `-Parameters`.

    .COMPONENT
    ConfigCommands

    .PARAMETER ModuleName
    The name of the module containing the command to be modified. This parameter
    is mandatory and required for identifying the correct module in the
    configuration.

    .PARAMETER CommandName
    The name of the specific command to be modified within the module. This
    parameter is mandatory and helps locate the command configuration within the
    JSON file.

    .PARAMETER Id
    A unique integer ID identifying the command version in the configuration
    file. This ensures that specific versions of the command can be targeted
    and modified.

    .PARAMETER ConfigFilePath
    The path to the configuration JSON file where command configurations are
    stored. This file is required and will be updated with any modified
    parameter values.

    .PARAMETER Parameters
    (Optional) A hashtable containing parameter names as keys and their desired
    values as values. Use this parameter to bypass the GUI and directly update
    the command configuration with the specified values.

    .PARAMETER Description
    (Optional) A string containing the new description for the command. Use this
    parameter to update the command description directly.

    .PARAMETER ShowDialog
    (Optional) Displays a WPF GUI dialog for interactive parameter editing. If
    this switch is specified, any `Parameters` passed directly will be
    ignored, and the GUI will allow users to make adjustments.

    .EXAMPLE
    Update-RpConfigCommand -ModuleName 'MilestonePSTools' -CommandName
    'Get-VmsCameraReport' -Id 18 -ConfigFilePath $(Get-Rpconfigpath) -ShowDialog

    This example loads the configuration for the 'Get-VmsCameraReport' command in
    the 'MilestonePSTools' module and opens a GUI dialog to allow users to
    interactively edit parameter values. Once edited, the configuration is saved
    back to the JSON file.

    .EXAMPLE
    Update-RpConfigCommand -ModuleName 'MilestonePSTools' -CommandName
    'Get-VmsCameraReport' -Id 18 -ConfigFilePath $(Get-Rpconfigpath) -Parameters
    @{ "Verbose" = $true; "Debug" = $false }

    This example directly sets the 'Verbose' and 'Debug' parameters without
    opening the GUI. A hashtable is provided via the `-Parameters`
    parameter, which updates the configuration in the JSON file with these
    values.

    .EXAMPLE
    Update-RpConfigCommand -ModuleName 'MilestonePSTools' -CommandName
    'Get-VmsCameraReport' -Id 18 -ConfigFilePath $(Get-Rpconfigpath) -Description
    "New description for the command"

    This example updates the description of the 'Get-VmsCameraReport' command in
    the 'MilestonePSTools' module without opening the GUI.

    .NOTES
    The configuration file must be in JSON format and already include a structure
    for ConfigCommands and the specified module. Any missing structure will
    cause an error.

    Note: The order of parameters in the GUI may not match the JSON file order
    due to how PowerShell handles JSON deserialization. To ensure a specific
    order, consider using an OrderedDictionary or manually managing parameter
    order.

    Ensure that the PresentationFramework, PresentationCore, and WindowsBase
    assemblies are available for WPF support to allow the GUI dialog to open.

    .LINK
    https://www.remotepro.dev/en-US/Update-RpConfigCommand
    #>
    [CmdletBinding(DefaultParameterSetName = 'ShowDialog')]
    param (
        [Parameter(ParameterSetName = 'ShowDialog', ValueFromPipelineByPropertyName = $true)]
        [Parameter(ParameterSetName = 'ConfigurationItems', ValueFromPipelineByPropertyName = $true)]
        [string]$ModuleName,

        [Parameter(ParameterSetName = 'ShowDialog', ValueFromPipelineByPropertyName = $true)]
        [Parameter(ParameterSetName = 'ConfigurationItems', ValueFromPipelineByPropertyName = $true)]
        [string]$CommandName,

        [Parameter(ParameterSetName = 'ShowDialog', ValueFromPipelineByPropertyName = $true)]
        [Parameter(ParameterSetName = 'ConfigurationItems', ValueFromPipelineByPropertyName = $true)]
        [string]$Id,

        [Parameter(ParameterSetName = 'ConfigurationItems', ValueFromPipelineByPropertyName = $true)]
        [Parameter(ParameterSetName = 'NoDialog', ValueFromPipelineByPropertyName = $true)]
        [hashtable]$Parameters,

        [Parameter(ParameterSetName = 'ConfigurationItems', ValueFromPipelineByPropertyName = $true)]
        [Parameter(ParameterSetName = 'NoDialog', ValueFromPipelineByPropertyName = $true)]
        [string]$Description,

        [Parameter(ParameterSetName = 'ShowDialog')]
        [Parameter(ParameterSetName = 'ConfigurationItems')]
        [string]$ConfigFilePath,

        [Parameter(ParameterSetName = 'ShowDialog')]
        [switch]$ShowDialog
    )

    begin {
        try {
            Add-Type -AssemblyName PresentationFramework
        } catch {
            Write-Error "Failed to load PresentationFramework assembly: $_"
            return

            if (-not $PSBoundParameters.ContainsKey('ConfigFilePath') -or [string]::IsNullOrWhiteSpace($ConfigFilePath)) {
                $ConfigFilePath = Get-RpConfigPath
            }
        }
    }

    process {
        # Use appdata path if there is not a filepath value.
        if (-not ($ConfigFilePath)){
            $ConfigFilePath = Get-RpConfigPath
        }

        # Load configuration JSON
        $configContent = Get-Content -Path $ConfigFilePath -Raw
        $config = $configContent | ConvertFrom-Json

        if (-not $config.ConfigCommands.PSObject.Properties[$ModuleName]) {
            Write-Error "Module '$ModuleName' not found in the configuration."
            return
        }

        $commandDetails = $config.ConfigCommands.$ModuleName | Where-Object { $_.CommandName -eq $CommandName -and $_.Id -eq $Id }
        if (-not $commandDetails) {
            Write-Error "Command '$CommandName' with ID '$Id' not found in module '$ModuleName'."
            return
        }

        function Convert-StringToHashtable {
            param ([string]$parameterstring)
            $parameterstring = $parameterstring.TrimStart('@{').TrimEnd('}')
            $parameterstring = $parameterstring -replace '; ', "`n"
            return $parameterstring | ConvertFrom-StringData
        }

        function Convert-HashtableToString {
            param ([hashtable]$hash)
            $orderedKeys = @('Type', 'Mandatory', 'Value')
            $string = '@{'
            foreach ($key in $orderedKeys) {
                if ($hash.ContainsKey($key)) {
                    $string += "$key=$($hash[$key]); "
                }
            }
            $string.TrimEnd('; ') + '}'
        }

        foreach ($paramName in $commandDetails.Parameters.PSObject.Properties.Name) {
            $paramDetails = $commandDetails.Parameters.$paramName
            if ($paramDetails -is [string]) {
                $commandDetails.Parameters.$paramName = Convert-StringToHashtable -parameterString $paramDetails
            }
        }

        # Load values from config if no Parameters are provided
        if (-not $parameters) {
            $parameters = @{}
            foreach ($paramName in $commandDetails.Parameters.PSObject.Properties.Name) {
                $parameters[$paramName] = $commandDetails.Parameters.$paramName.Value
            }
        }

        # GUI Dialog for Parameter Editing
        if ($ShowDialog) {
            Write-Verbose "Opening WPF GUI to edit parameter values for '$CommandName' (ID: $Id)..."
            $XAML = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:materialDesign="http://materialdesigninxaml.net/winfx/xaml/themes"
        xmlns:mdControls="clr-namespace:MaterialDesignThemes.Wpf;assembly=MaterialDesignThemes.Wpf"
        Title="Edit Parameters"
        MinHeight="600" MinWidth="400"
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

    <StackPanel>
        <Button Name="HelpButton" Width="100" Margin="10" Content="Get Help" Style="{StaticResource MaterialDesignFlatButton}" HorizontalAlignment="Right" />
        <ScrollViewer VerticalScrollBarVisibility="Auto" Height="500">
            <StackPanel Name="ParameterStack">
            </StackPanel>
        </ScrollViewer>
        <StackPanel Orientation="Horizontal" HorizontalAlignment="Center" Margin="10">
            <Button Name="SubmitButton" Width="75" Margin="10" Content="Submit" Style="{StaticResource MaterialDesignFlatButton}" />
            <Button Name="CancelButton" Width="75" Margin="10" Content="Cancel" Style="{StaticResource MaterialDesignFlatButton}" />
        </StackPanel>
    </StackPanel>
</Window>
"@

            $window = [Windows.Markup.XamlReader]::Parse($xaml)

            # Set the window icon
            if ($null -ne $window) {
                Set-RpWindowIcon -window $window
            } else {
                Write-Warning "WPF window failed to load. Cannot set icon."
            }

            $parameterstack = $window.FindName("ParameterStack")
            $submitButton = $window.FindName("SubmitButton")
            $cancelButton = $window.FindName("CancelButton")
            $helpButton = $window.FindName("HelpButton")
            $textBoxes = @{}

            foreach ($paramName in $parameters.Keys) {
                $paramValue = $parameters[$paramName]

                # Label and textbox setup for each parameter
                $label = New-Object Windows.Controls.TextBlock
                $label.Text = $paramName
                $label.Margin = "5,5,5,5"
                $parameterstack.Children.Add($label) | Out-Null

                $textBox = New-Object Windows.Controls.TextBox
                $textBox.Text = $paramValue  # Set textbox text to existing parameter value
                $textBox.Margin = "5,5,5,5"
                $parameterstack.Children.Add($textBox) | Out-Null

                # Store the textbox in a hashtable for later retrieval
                $textBoxes[$paramName] = $textBox
            }

            # Add description box
            $descriptionLabel = New-Object Windows.Controls.TextBlock
            $descriptionLabel.Text = "Description"
            $descriptionLabel.Margin = "5,5,5,5"
            $parameterstack.Children.Add($descriptionLabel) | Out-Null

            $descriptionBox = New-Object Windows.Controls.TextBox
            $descriptionBox.Text = $commandDetails.Description
            $descriptionBox.Margin = "5,5,5,5"
            $parameterstack.Children.Add($descriptionBox) | Out-Null

            $submitButton.Add_Click({
                foreach ($paramName in $textBoxes.Keys) {
                    $commandDetails.Parameters.$paramName.Value = $textBoxes[$paramName].Text
                    Write-Verbose "Parameter '$paramName' updated with value '$($textBoxes[$paramName].Text)'"
                }
                $commandDetails.Description = $descriptionBox.Text
                Write-Verbose "Description updated to '$($descriptionBox.Text)'"
                $window.DialogResult = $true
                $window.Close()
            })

            $cancelButton.Add_Click({
                Write-Verbose "User canceled the update."
                $window.DialogResult = $false
                $window.Close()
            })

            $helpButton.Add_Click({
                try {
                    [System.Windows.Input.Mouse]::OverrideCursor = [System.Windows.Input.Cursors]::Wait
                    try {
                        Get-Help $CommandName -Online
                    } finally {
                        [System.Windows.Input.Mouse]::OverrideCursor = $null  # Reset the cursor
                    }
                } catch {
                    Write-Warning "Failed to open online help for command '$CommandName'."
                    [System.Windows.MessageBox]::Show("Failed to open online help for command '$CommandName'.",
                        "Warning", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning) | Out-Null
                }
            })

            $result = $window.ShowDialog()
            if (-not $result) { Write-Verbose "No changes made."; return }
        }

        # Apply passed Parameters directly if GUI is not used
        else {
            foreach ($paramName in $parameters.Keys) {
                if ($commandDetails.Parameters.$paramName) {
                    $commandDetails.Parameters.$paramName.Value = $parameters[$paramName]
                    Write-Verbose "Parameter '$paramName' updated with value '$($parameters[$paramName])'"
                } else {
                    Write-Warning "Parameter '$paramName' not found in the command '$CommandName'."
                }
            }

            # Update description if provided
            if ($Description) {
                $commandDetails.Description = $Description
                Write-Verbose "Description updated to '$Description'"
            }
        }

        foreach ($paramName in $commandDetails.Parameters.PSObject.Properties.Name) {
            $paramDetails = $commandDetails.Parameters.$paramName
            if ($paramDetails -is [hashtable]) {
                $commandDetails.Parameters.$paramName = Convert-HashtableToString -hash $paramDetails
            }
        }

        $jsonConfig = $config | ConvertTo-Json -Depth 4
        Set-Content -Path $ConfigFilePath -Value $jsonConfig

        Write-Verbose "Parameter values for command '$CommandName' updated in module '$ModuleName' and saved to $ConfigFilePath"
    }
}
