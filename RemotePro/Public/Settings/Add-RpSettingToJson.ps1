function Add-RpSettingToJson {
    <#
    .SYNOPSIS
    Adds a new setting to a JSON settings file.

    .DESCRIPTION
    The Add-RpSettingToJson function adds a new setting to a specified JSON settings
    file. It can be used in two modes: CommandLineInterface and ShowDialog. In
    CommandLineInterface mode, the setting name and value are provided as parameters.
    In ShowDialog mode, a WPF GUI is displayed to input the setting name and value.

    .COMPONENT
    Settings

    .PARAMETER SettingsFilePath
    The path to the JSON settings file. If not provided, the default settings file
    path is used.

    .PARAMETER Name
    The name of the setting to add. This parameter is mandatory in
    CommandLineInterface mode.

    .PARAMETER Value
    The value of the setting to add. This parameter is mandatory in
    CommandLineInterface mode.

    .PARAMETER ShowDialog
    If specified, a WPF GUI is displayed to input the setting name and value.

    .EXAMPLE
    Add-RpSettingToJson -SettingsFilePath "C:\Settings.json" -Name "Theme" -Value
    "Dark"

    Adds a setting named "Theme" with the value "Dark" to the specified settings
    file. Note this is a hypothetical example and the setting may not exist in the
    default settings file.

    .EXAMPLE
    Add-RpSettingToJson -ShowDialog

    Displays a WPF GUI to input the setting name and value, and adds the setting to
    the default settings file.

    .NOTES
    If the settings file does not exist, it will be created. If the setting already
    exists, a message will be displayed indicating that the setting already exists.

    .LINK
    https://www.remotepro.dev/en-US/Add-RpSettingToJson
    #>
    [CmdletBinding(DefaultParameterSetName='CommandLineInterface')]
    param (
        [Parameter(Mandatory=$false, ParameterSetName='CommandLineInterface')]
        [Parameter(Mandatory=$false, ParameterSetName='ShowDialog')]
        [string]$SettingsFilePath,

        [Parameter(Mandatory=$true, ParameterSetName='CommandLineInterface')]
        [string]$Name,

        [Parameter(Mandatory=$true, ParameterSetName='CommandLineInterface')]
        [string]$Value,

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
                # Define XAML layout for WPF GUI
                $xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:materialDesign="http://materialdesigninxaml.net/winfx/xaml/themes"
        xmlns:mdControls="clr-namespace:MaterialDesignThemes.Wpf;assembly=MaterialDesignThemes.Wpf"
        Title="Add Setting"
        Width="300" Height="250"
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
        <TextBlock Text="Setting Name:" Margin="0,0,0,5"/>
        <TextBox Name="NameTextBox" Width="250" Margin="0,0,0,10"/>
        <TextBlock Text="Setting Value:" Margin="0,0,0,5"/>
        <TextBox Name="ValueTextBox" Width="250" Margin="0,0,0,10"/>
        <StackPanel Orientation="Horizontal" HorizontalAlignment="Center">
            <Button Name="SubmitButton" Content="Submit" Width="75" Margin="5" Style="{StaticResource MaterialDesignRaisedButton}"/>
            <Button Name="CancelButton" Content="Cancel" Width="75" Margin="5" Style="{StaticResource MaterialDesignRaisedButton}"/>
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

                # Find WPF Controls
                $nameTextBox = $window.FindName("NameTextBox")
                $valueTextBox = $window.FindName("ValueTextBox")
                $submitButton = $window.FindName("SubmitButton")
                $cancelButton = $window.FindName("CancelButton")

                # Initialize a hashtable to capture results
                $dialogResults = [ordered]@{
                    Name  = $null
                    Value = $null
                }

                # Event Handler for Submit Button
                $submitButton.Add_Click({
                    $dialogResults.Name = $nameTextBox.Text
                    $dialogResults.Value = $valueTextBox.Text
                    $window.DialogResult = $true
                    $window.Close()
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
                $Value = $dialogResults.Value
            }

            # Load the settings file
            if (-not (Test-Path $SettingsFilePath)) {
                Write-Output "Settings file not found. Creating new settings file."
                [PSCustomObject]@{ $Name = $Value } | ConvertTo-Json -Compress | Set-Content $SettingsFilePath
                Write-Output "Setting '$Name' added with value '$Value'."
            } else {
                # Check if the setting already exists
                $settings = Get-Content $SettingsFilePath | ConvertFrom-Json
                if ($settings.PSObject.Properties.Name -contains $Name) {
                    Write-Warning "Setting '$Name' already exists. Use Update-RpSettingJson to update the value."
                } else {
                    # Add the setting to the settings file
                    $settings | Add-Member -MemberType NoteProperty -Name $Name -Value $Value
                    $settings | ConvertTo-Json -Depth 4 | Set-Content $SettingsFilePath
                    Write-Output "Setting '$Name' added with value '$Value'."
                }
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
    end {}
}
