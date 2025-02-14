
function Add-RpSettingJson {
    <#
    .SYNOPSIS
    Adds a new setting to a JSON settings file.

    .DESCRIPTION
    The Add-RpSettingJson function adds a new setting to a specified JSON settings
    file. If the settings file path is not provided, it retrieves the default path
    using the Get-RpSettingsJsonPath function. If the file does not exist, it
    creates a new settings file. Optionally, a GUI dialog can be shown to input
    the setting name and value.

    .PARAMETER SettingsFilePath
    The path to the JSON settings file. If not provided, the default path is used.

    .PARAMETER Name
    The name of the setting to add. This parameter is mandatory.

    .PARAMETER Value
    The value of the setting to add. This parameter is mandatory.

    .PARAMETER ShowDialog
    If specified, a GUI dialog is shown to input the setting name and value.

    .EXAMPLE
    Add-RpSettingJson -Name "ExampleSetting" -Value "ExampleValue"

    Adds a setting named "ExampleSetting" with the value "ExampleValue" to the
    default JSON settings file.

    .EXAMPLE
    Add-RpSettingJson -SettingsFilePath "C:\Path\To\Settings.json" -Name
    "ExampleSetting" -Value "ExampleValue"

    Adds a setting named "ExampleSetting" with the value "ExampleValue" to the
    specified JSON settings file.

    .EXAMPLE
    Add-RpSettingJson -ShowDialog

    Shows a GUI dialog to input the setting name and value, and adds the setting
    to the default JSON settings file.

    .NOTES
    If the setting already exists in the JSON file, a message is displayed
    indicating that the setting already exists and suggesting to use
    Update-RpSettingJson to update the value.

    #>
    param (
        [Parameter(Mandatory=$false)]
        [string]$SettingsFilePath,

        [Parameter(Mandatory=$true)]
        [string]$Name,

        [Parameter(Mandatory=$true)]
        [string]$Value,

        [Parameter(Mandatory=$false)]
        [switch]$ShowDialog
    )

    begin {
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
    }

    process {
        if ($ShowDialog) {
            # Define XAML layout for WPF GUI
            $xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Add Setting"
        Width="300" Height="200"
        WindowStartupLocation="CenterScreen">
    <StackPanel Margin="10">
        <TextBlock Text="Setting Name:" Margin="0,0,0,5"/>
        <TextBox Name="NameTextBox" Width="250" Margin="0,0,0,10"/>
        <TextBlock Text="Setting Value:" Margin="0,0,0,5"/>
        <TextBox Name="ValueTextBox" Width="250" Margin="0,0,0,10"/>
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

        if (-not (Test-Path $SettingsFilePath)) {
            Write-Output "Settings file not found. Creating new settings file."
            [PSCustomObject]@{ $Name = $Value } | ConvertTo-Json -Compress | Set-Content $SettingsFilePath
            Write-Output "Setting '$Name' added with value '$Value'."
        } else {
            $settings = Get-Content $SettingsFilePath | ConvertFrom-Json
            if ($settings.PSObject.Properties.Name -contains $Name) {
                Write-Output "Setting '$Name' already exists. Use Update-RpSettingJson to update the value."
            } else {
                $settings | Add-Member -MemberType NoteProperty -Name $Name -Value $Value
                $settings | ConvertTo-Json -Compress | Set-Content $SettingsFilePath
                Write-Output "Setting '$Name' added with value '$Value'."
            }
        }
    }
}
