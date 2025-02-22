function Update-RpSettingsJson {
    <#
    .SYNOPSIS
    Updates or adds a setting in the RpSettings JSON file.

    .DESCRIPTION
    The Update-RpSettingsJson function updates or adds a setting in the RpSettings
    JSON file. It can be used via command line interface or a graphical dialog
    interface.

    .COMPONENT
    Settings

    .PARAMETER SettingsFilePath
    Specifies the path to the settings JSON file. If not provided, the default
    settings file path is used.

    .PARAMETER Name
    Specifies the name of the setting to update or add. This parameter is mandatory
    when using the command line interface.

    .PARAMETER Value
    Specifies the value of the setting to update or add. This parameter is mandatory
    when using the command line interface.

    .PARAMETER ShowDialog
    If specified, a graphical dialog interface is shown to update or add settings.

    .EXAMPLE
    Update-RpSettingsJson -Name "SettingName" -Value "NewValue"

    Updates the setting "SettingName" to "NewValue" in the default settings JSON
    file.

    .EXAMPLE
    Update-RpSettingsJson -SettingsFilePath "C:\Path\To\Settings.json" -Name "SettingName" -Value "NewValue"

    Updates the setting "SettingName" to "NewValue" in the specified settings JSON
    file.

    .EXAMPLE
    Update-RpSettingsJson -ShowDialog
    Opens a graphical dialog interface to update or add settings in the default
    settings JSON file.

    .LINK
    https://www.remotepro.dev/en-US/Update-RpSettingsJson
    #>
    [CmdletBinding(DefaultParameterSetName = 'CommandLineInterface')]
    param (
        [Parameter(Mandatory=$false, Position=0, ParameterSetName='CommandLineInterface')]
        [Parameter(Mandatory=$false, ParameterSetName='ShowDialog')]
        [string]$SettingsFilePath,

        [Parameter(Mandatory=$true, Position=1, ParameterSetName='CommandLineInterface',
        ValueFromPipelineByPropertyName = $true)]
        [ArgumentCompleter({
            param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
            $settingsFilePath = $fakeBoundParameter['SettingsFilePath']
            if (-not $settingsFilePath) {
                $settingsFilePath = Get-RpSettingsJsonPath
            }
            if (Test-Path -Path $settingsFilePath) {
                $settings = Get-Content -Raw $settingsFilePath | ConvertFrom-Json
                $settings.PSObject.Properties.Name | Where-Object { $_ -like "$wordToComplete*" }
            }
        })]
        [string]$Name,

        [Parameter(Mandatory=$true, Position=2, ParameterSetName='CommandLineInterface',
        ValueFromPipelineByPropertyName = $true)]
        [ArgumentCompleter({
            param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
            $settingsFilePath = $fakeBoundParameter['SettingsFilePath']
            if (-not $settingsFilePath) {
                $settingsFilePath = Get-RpSettingsJsonPath
            }
            if (Test-Path -Path $settingsFilePath) {
                $settings = Get-Content -Raw $settingsFilePath | ConvertFrom-Json
                if ($settings.PSObject.Properties[$fakeBoundParameter['Name']]) {
                    $currentValue = $settings.PSObject.Properties[$fakeBoundParameter['Name']].Value
                    if ($currentValue -is [System.Collections.IEnumerable] -and -not ($currentValue -is [string])) {
                        $currentValue | Where-Object { $_ -like "$wordToComplete*" }
                    } else {
                        $currentValue
                    }
                }
            }
        })]
        [string]$Value,

        [Parameter(Mandatory=$false, ParameterSetName='ShowDialog')]
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
            Write-Error "An error occurred during initialization: $($_.Exception.Message)"
            return
        }
    }

    process {
        try {
            $settings = Get-Content -Raw $SettingsFilePath | ConvertFrom-Json

            switch ($PSCmdlet.ParameterSetName) {
                'CommandLineInterface' {
                    if ($settings.PSObject.Properties.GetEnumerator() | Where-Object { $_.Name -eq $Name }) {
                        $settings.$Name = $Value
                        $settings | ConvertTo-Json -Depth 4  | Set-Content $SettingsFilePath
                        Write-Output "Setting '$Name' updated to '$Value'."
                    } else {
                        $settings | Add-Member -MemberType NoteProperty -Name $Name -Value $Value -Force
                        $settings | ConvertTo-Json -Depth 4  | Set-Content $SettingsFilePath
                        Write-Output "Setting '$Name' added with value '$Value'."
                    }
                }

                'ShowDialog' {
                    # Define XAML layout for WPF GUI
                    $xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:materialDesign="http://materialdesigninxaml.net/winfx/xaml/themes"
        xmlns:mdControls="clr-namespace:MaterialDesignThemes.Wpf;assembly=MaterialDesignThemes.Wpf"
        Title="Update Settings"
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
        <ListBox Name="SettingsListBox" Width="350" Height="150" Margin="0,10,0,5"/>
        <TextBlock Text="Setting Value:" Margin="0,10,0,5"/>
        <TextBox Name="ValueTextBox" Width="350" />
        <StackPanel Orientation="Horizontal" HorizontalAlignment="Center" Margin="10">
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
                    $valueTextBox = $window.FindName("ValueTextBox")
                    $submitButton = $window.FindName("SubmitButton")
                    $cancelButton = $window.FindName("CancelButton")

                    # Populate ListBox with settings
                    foreach ($property in $settings.PSObject.Properties) {
                        [void]$settingsListBox.Items.Add($property.Name)
                    }

                    # Event Handler for ListBox Selection
                    $settingsListBox.Add_SelectionChanged({
                        $selectedSetting = $settingsListBox.SelectedItem
                        if ($selectedSetting) {
                            $valueTextBox.Text = $settings.$selectedSetting
                        }
                    })

                    # Event Handler for Submit Button
                    $submitButton.Add_Click({
                        $selectedSetting = $settingsListBox.SelectedItem
                        if (-not $selectedSetting -or [string]::IsNullOrWhiteSpace($valueTextBox.Text)) {
                            [System.Windows.MessageBox]::Show("Please select a setting and provide a value.", "Validation Error",
                                [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error) | Out-Null
                            return
                        }
                        $settings.$selectedSetting = $valueTextBox.Text
                        $settings | ConvertTo-Json -Depth 4 | Set-Content $SettingsFilePath
                        Write-Host "Setting '$selectedSetting' updated to '$($valueTextBox.Text)'."
                        $window.DialogResult = $true
                        if ($null -ne $window) {
                            $window.Close()
                        }
                    })

                    # Event Handler for Cancel Button
                    $cancelButton.Add_Click({
                        $window.DialogResult = $false
                        $window.Close()
                    })

                    # Show the WPF Window
                    $result = $window.ShowDialog()
                    if (-not $result) { Write-Verbose "Operation canceled by user."; return }
                }
            }
        } catch {
            Write-Error "An error occurred during processing: $($_.Exception.Message)"
        }
    }

    end {
        try {
            if ($ShowDialog) {
                $window.Close()
            }
        } catch {
            Write-Error "An error occurred during cleanup: $($_.Exception.Message)"
        }
        finally {
            if ($ShowDialog -and $null -ne $window) {
                $window.Close()
            }

            Set-RpSettingsJson # Refresh the RemoteProController
        }
    }
}
