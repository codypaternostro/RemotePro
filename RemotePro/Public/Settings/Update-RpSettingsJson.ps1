function Update-RpSettingsJson {
    [CmdletBinding(DefaultParameterSetName = 'UpdateSetting')]
    param (
        [Parameter(Mandatory=$false, Position=0, ParameterSetName='UpdateSetting')]
        [string]$SettingsFilePath,

        [Parameter(Mandatory=$true, Position=1, ParameterSetName='UpdateSetting')]
        [string]$Name,

        [Parameter(Mandatory=$true, Position=2, ParameterSetName='UpdateSetting')]
        [string]$Value,

        [Parameter(Mandatory=$false, ParameterSetName='ShowDialog')]
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
            # Define variables for WPF GUI
            $resultText = @()

            # Define XAML layout for WPF GUI
            $xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Update-RpSettingsJson Dialog"
        Width="400" Height="200"
        WindowStartupLocation="CenterScreen"
        SizeToContent="WidthAndHeight">
    <StackPanel Margin="10">
        <TextBlock Text="Setting Name:" Margin="0,10,0,5"/>
        <TextBox Name="NameTextBox" Width="350" />

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
            $nameTextBox = $window.FindName("NameTextBox")
            $valueTextBox = $window.FindName("ValueTextBox")
            $submitButton = $window.FindName("SubmitButton")
            $cancelButton = $window.FindName("CancelButton")

            # Event Handler for Submit Button
            $submitButton.Add_Click({
                if ([string]::IsNullOrWhiteSpace($nameTextBox.Text) -or [string]::IsNullOrWhiteSpace($valueTextBox.Text)) {
                    [System.Windows.MessageBox]::Show("Both Name and Value fields must be filled out.", "Validation Error",
                        [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error) | Out-Null
                    return
                }
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
            if (-not $result) { Write-Verbose "Operation canceled by user."; return }

            # Update Name and Value from the text boxes
            $Name = $nameTextBox.Text
            $Value = $valueTextBox.Text
        }

        $settings = Get-Content $SettingsFilePath | ConvertFrom-Json
        if ($settings.PSObject.Properties.Name -contains $Name) {
            $settings.$Name = $Value
            $settings | ConvertTo-Json -Compress | Set-Content $SettingsFilePath
            Write-Output "Setting '$Name' updated to '$Value'."
        } else {
            Write-Output "Setting '$Name' not found."
        }
    }

    end {
        if ($ShowDialog) {
            $window.Close()
        }
    }
}
