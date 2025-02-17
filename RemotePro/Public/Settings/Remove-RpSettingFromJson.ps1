function Remove-RpSettingFromJson {
    <#
    .SYNOPSIS
    Removes a specified setting from a JSON settings file.

    .DESCRIPTION
    The Remove-RpSettingFromJson function removes a specified setting from a JSON
    settings file. The function can be run in two modes: CommandLineInterface and
    ShowDialog. In CommandLineInterface mode, the setting name is provided as a
    parameter. In ShowDialog mode, a WPF dialog is displayed to input the setting
    name.

    .COMPONENT
    Settings

    .PARAMETER SettingsFilePath
    The path to the JSON settings file. If not provided, the default settings file
    path is used.

    .PARAMETER Name
    The name of the setting to be removed. This parameter is mandatory in
    CommandLineInterface mode.

    .PARAMETER ShowDialog
    If specified, a WPF dialog is displayed to input the setting name. This
    parameter is mandatory in ShowDialog mode.

    .EXAMPLE
    Remove-RpSettingFromJson -SettingsFilePath "C:\path\to\settings.json" -Name
    "SettingName"

    Removes the setting named "SettingName" from the specified JSON settings file.

    .EXAMPLE
    Remove-RpSettingFromJson -ShowDialog

    Displays a WPF dialog to input the setting name and removes the specified
    setting from the default JSON settings file.
    #>
    param (
        [Parameter(Mandatory=$false, ParameterSetName='CommandLineInterface')]
        [Parameter(Mandatory=$false, ParameterSetName='ShowDialog')]
        [string]$SettingsFilePath,

        [Parameter(Mandatory=$true, ParameterSetName='CommandLineInterface')]
        [Parameter(Mandatory=$false, ParameterSetName='ShowDialog')]
        [string]$Name,

        [Parameter(Mandatory=$true, ParameterSetName='ShowDialog')]
        [switch]$ShowDialog
    )

    begin {
        try {
            if (-not $PSBoundParameters.ContainsKey('SettingsFilePath') -or [string]::IsNullOrWhiteSpace($SettingsFilePath)) {
                $SettingsFilePath = Get-RpSettingsJsonPath
            }

            if (-not (Test-Path -Path $SettingsFilePath)) {
                Write-Output "Settings file not found at path '$SettingsFilePath'."
                return
            }

            if ($ShowDialog) {
                Add-Type -AssemblyName PresentationFramework
            }
        } catch {
            Write-Error "An error occurred during initialization: $_.Exception.Message"
            return
        }
    }

    process {
        try {
            if ($ShowDialog) {
                # Load the settings file
                $settings = Get-Content $SettingsFilePath | ConvertFrom-Json

                # Define XAML layout for WPF GUI
                $xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:materialDesign="http://materialdesigninxaml.net/winfx/xaml/themes"
        xmlns:mdControls="clr-namespace:MaterialDesignThemes.Wpf;assembly=MaterialDesignThemes.Wpf"
        Title="Remove Setting"
        Width="400" Height="300"
        WindowStartupLocation="CenterScreen"
        SizeToContent="WidthAndHeight"
        Background="{DynamicResource MaterialDesignPaper}">

    <Window.Resources>
        <ResourceDictionary>
            <ResourceDictionary.MergedDictionaries>
                <materialDesign:BundledTheme x:Key="AppTheme" BaseTheme="Light" PrimaryColor="Grey" SecondaryColor="Lime" />
                <ResourceDictionary Source="pack://application:,,,/MaterialDesignThemes.Wpf;component/Themes/MaterialDesign2.Defaults.xaml" />
                <ResourceDictionary Source="pack://application:,,,/MaterialDesignThemes.Wpf;component/Themes/MaterialDesignTheme.PopupBox.xaml" />
            </ResourceDictionary.MergedDictionaries>
        </ResourceDictionary>
    </Window.Resources>

    <StackPanel Margin="10">
        <TextBlock Text="Select a Setting to Remove:" Margin="0,0,0,5"/>
        <ListBox Name="SettingsListBox" Width="350" Height="150" Margin="0,0,0,10"/>
        <StackPanel Orientation="Horizontal" HorizontalAlignment="Center">
            <Button Name="SubmitButton" Content="Submit" Width="75" Margin="5"/>
            <Button Name="CancelButton" Content="Cancel" Width="75" Margin="5"/>
        </StackPanel>
    </StackPanel>
</Window>
"@

                # Parse XAML and load WPF elements
                $window = [Windows.Markup.XamlReader]::Parse($xaml)

                # Find WPF Controls
                $settingsListBox = $window.FindName("SettingsListBox")
                $submitButton = $window.FindName("SubmitButton")
                $cancelButton = $window.FindName("CancelButton")

                # Populate ListBox with settings
                foreach ($setting in $settings.PSObject.Properties) {
                    [void]$settingsListBox.Items.Add("$($setting.Name): $($setting.Value)")
                }

                # Initialize a hashtable to capture results
                $dialogResults = [ordered]@{
                    Name = $null
                }

                # Event Handler for Submit Button
                $submitButton.Add_Click({
                    $selectedItem = $settingsListBox.SelectedItem
                    if ($selectedItem) {
                        $dialogResults.Name = $selectedItem.Split(":")[0].Trim()
                        $window.DialogResult = $true
                        $window.Close()
                    } else {
                        [System.Windows.MessageBox]::Show("Please select a setting to remove.")
                    }
                })

                # Event Handler for Cancel Button
                $cancelButton.Add_Click({
                    $window.DialogResult = $false
                    $window.Close()
                })

                # Show the WPF Window
                $result = $window.ShowDialog()
                if (-not $result) { Write-Output "Operation canceled by user."; return }

                # Assign GUI input results to the main function parameters
                $Name = $dialogResults.Name
            }

            # Load the settings file
            $settings = Get-Content $SettingsFilePath | ConvertFrom-Json

            # Check if the setting exists
            if ($settings.PSObject.Properties.Name -contains $Name) {
                # Remove the setting
                $settings.PSObject.Properties.Remove($Name)
                $settings | ConvertTo-Json -Depth 4 | Set-Content $SettingsFilePath
                Write-Output "Setting '$Name' removed."
            } else {
                Write-Warning "Setting '$Name' does not exist."
            }
        } catch {
            Write-Error $_.Exception.Message
        }
        finally {
            if ($ShowDialog -and $null -ne $window) {
                $window.Close()
            }

            Set-RpSettingsJson # Refresh the RemoteProController
        }
    }
}
