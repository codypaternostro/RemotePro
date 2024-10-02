function Show-RPProfileEntryDialog {
    <#
    .SYNOPSIS
        Displays a dialog for entering or editing a connection profile's details.

    .DESCRIPTION
        This cmdlet shows a graphical dialog window that allows the user
        to input connection profile details such as Profile Name, Server
        Address, Username, and other settings. The dialog collects the
        necessary parameters to create or edit a connection profile.

    .PARAMETER Edit
        Switch to edit an existing profile. If enabled, it will load the selected profile's details.

    .PARAMETER SelectedProfile
        The selected connection profile to load into the form when in edit mode.
    #>
    param (
        [switch]$Edit,
        [PSCustomObject]$SelectedProfile  # Selected profile passed as a parameter
    )

    Add-Type -AssemblyName PresentationFramework

    # XAML definition for the input dialog
    $xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:materialDesign="http://materialdesigninxaml.net/winfx/xaml/themes"
        Title="Add/Edit Connection Profile"
        MinHeight="400" MinWidth="500"
        MaxHeight="600" MaxWidth="800"
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

    <Grid Margin="20">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto" />
            <RowDefinition Height="Auto" />
            <RowDefinition Height="Auto" />
            <RowDefinition Height="Auto" />
            <RowDefinition Height="Auto" />
            <RowDefinition Height="Auto" />
            <RowDefinition Height="Auto" />
            <RowDefinition Height="Auto" />
            <RowDefinition Height="Auto" />
        </Grid.RowDefinitions>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="Auto" />
            <ColumnDefinition Width="*" />
        </Grid.ColumnDefinitions>

        <!-- Profile Name -->
        <TextBlock Grid.Row="0" Grid.Column="0" Margin="0,5,10,0" VerticalAlignment="Center">Profile Name:</TextBlock>
        <TextBox x:Name="ProfileNameBox" Grid.Row="0" Grid.Column="1" Margin="0,5,0,0" />

        <!-- Server Address -->
        <TextBlock Grid.Row="1" Grid.Column="0" Margin="0,5,10,0" VerticalAlignment="Center">Server Address:</TextBlock>
        <TextBox x:Name="ServerAddressBox" Grid.Row="1" Grid.Column="1" Margin="0,5,0,0" />

        <!-- Username -->
        <TextBlock Grid.Row="2" Grid.Column="0" Margin="0,5,10,0" VerticalAlignment="Center">Username:</TextBlock>
        <TextBox x:Name="UsernameBox" Grid.Row="2" Grid.Column="1" Margin="0,5,0,0" />

        <!-- Password -->
        <TextBlock Grid.Row="3" Grid.Column="0" Margin="0,5,10,0" VerticalAlignment="Center">Password:</TextBlock>
        <PasswordBox x:Name="PasswordBox" Grid.Row="3" Grid.Column="1" Margin="0,5,0,0" />

        <!-- SecureOnly -->
        <TextBlock Grid.Row="4" Grid.Column="0" Margin="0,5,10,0" VerticalAlignment="Center">Secure Only:</TextBlock>
        <CheckBox x:Name="SecureOnlyCheckBox" Grid.Row="4" Grid.Column="1" Margin="0,5,0,0" IsChecked="True" />

        <!-- Accept EULA -->
        <TextBlock Grid.Row="5" Grid.Column="0" Margin="0,5,10,0" VerticalAlignment="Center">Accept EULA:</TextBlock>
        <CheckBox x:Name="AcceptEulaCheckBox" Grid.Row="5" Grid.Column="1" Margin="0,5,0,0" IsChecked="True" />

        <!-- Basic User -->
        <TextBlock Grid.Row="6" Grid.Column="0" Margin="0,5,10,0" VerticalAlignment="Center">Basic User:</TextBlock>
        <CheckBox x:Name="BasicUserCheckBox" Grid.Row="6" Grid.Column="1" Margin="0,5,0,0" />

        <!-- Include Child Sites -->
        <TextBlock Grid.Row="7" Grid.Column="0" Margin="0,5,10,0" VerticalAlignment="Center">Include Child Sites:</TextBlock>
        <CheckBox x:Name="IncludeChildSitesCheckBox" Grid.Row="7" Grid.Column="1" Margin="0,5,0,0" />

        <!-- Buttons -->
        <StackPanel Grid.Row="8" Grid.Column="0" Grid.ColumnSpan="2" Orientation="Horizontal" HorizontalAlignment="Right" Margin="0,20,0,0">
            <Button x:Name="OkButton" Width="80" Margin="5" Style="{StaticResource MaterialDesignRaisedButton}" IsDefault="True">OK</Button>
            <Button x:Name="CancelButton" Width="80" Margin="5" Style="{StaticResource MaterialDesignRaisedButton}" IsCancel="True">Cancel</Button>
        </StackPanel>
    </Grid>
</Window>
"@

    # Load the XAML
    $reader = New-Object System.Xml.XmlNodeReader([xml]$xaml)
    $window = [Windows.Markup.XamlReader]::Load($reader)

    # Assign control references
    $profileNameBox = $window.FindName("ProfileNameBox")
    $serverAddressBox = $window.FindName("ServerAddressBox")
    $usernameBox = $window.FindName("UsernameBox")
    $passwordBox = $window.FindName("PasswordBox")
    $secureOnlyCheckBox = $window.FindName("SecureOnlyCheckBox")
    $acceptEulaCheckBox = $window.FindName("AcceptEulaCheckBox")
    $basicUserCheckBox = $window.FindName("BasicUserCheckBox")
    $includeChildSitesCheckBox = $window.FindName("IncludeChildSitesCheckBox")
    $okButton = $window.FindName("OkButton")
    $cancelButton = $window.FindName("CancelButton")

    # If in Edit mode, load existing profile data into the form
    if ($Edit -and $SelectedProfile) {
        # Pre-fill form fields with profile details
        $profileNameBox.Text = $SelectedProfile.Name
        $serverAddressBox.Text = $SelectedProfile.ServerAddress
        $usernameBox.Text = $SelectedProfile.Credential

        # Explicitly check if the values are true or false and set the checkboxes accordingly
        $checkBoxes = Get-VmsConnectionProfile -Name $SelectedProfile.Name
        $secureOnlyCheckBox.IsChecked = if ($checkBoxes.SecureOnly -eq "true") { $true } else { $false }
        $acceptEulaCheckBox.IsChecked = if ($checkBoxes.AcceptEula -eq "true") { $true } else { $false }
        $basicUserCheckBox.IsChecked = if ($checkBoxes.BasicUser -eq "true") { $true } else { $false }
        $includeChildSitesCheckBox.IsChecked = if ($checkBoxes.IncludeChildSites -eq "true") { $true } else { $false }
    }

    # Handle OK button click
    $okButton.Add_Click({
        $profileName = $profileNameBox.Text
        $serverAddress = $serverAddressBox.Text
        $username = $usernameBox.Text
        $password = $passwordBox.Password
        $secureOnly = $secureOnlyCheckBox.IsChecked -eq $true
        $acceptEula = $acceptEulaCheckBox.IsChecked -eq $true
        $basicUser = $basicUserCheckBox.IsChecked -eq $true
        $includeChildSites = $includeChildSitesCheckBox.IsChecked -eq $true

        # Validate required fields
        if ([string]::IsNullOrWhiteSpace($profileName) -or [string]::IsNullOrWhiteSpace($serverAddress) -or [string]::IsNullOrWhiteSpace($username)) {
            [System.Windows.MessageBox]::Show("Please fill in all required fields.", "Missing Information", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning)
            return
        }

        # Check if the password is empty
        if (-not [string]::IsNullOrWhiteSpace($password)) {
            $securePassword = $password | ConvertTo-SecureString -AsPlainText -Force
            $credential = New-Object System.Management.Automation.PSCredential ($username, $securePassword)
        } else {
            [System.Windows.MessageBox]::Show("Password cannot be empty.", "Missing Password", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning)
            return
        }

        # Prepend https:// or http:// to the ServerAddress based on the SecureOnly flag, if not already present
        if (-not $serverAddress.StartsWith("http://") -and -not $serverAddress.StartsWith("https://")) {
            if ($secureOnly) {
                $serverAddress = "https://$serverAddress"
            } else {
                $serverAddress = "http://$serverAddress"
            }
        }

        try {
            # If editing, delete the old profile
            if ($Edit) {
                [System.Windows.Input.Mouse]::OverrideCursor = [System.Windows.Input.Cursors]::Wait
                try {
                    Remove-VmsConnectionProfile -Name $profileName
                } finally {
                    [System.Windows.Input.Mouse]::OverrideCursor = $null  # Reset the cursor
                }
            }

            # Create connection profile with the parsed parameters
            $params = @{
                Name = $profileName
                ServerAddress = $serverAddress
                Credential = $credential
                SecureOnly = $secureOnly
                AcceptEula = $acceptEula
            }

            if ($basicUser) {
                $params.Add("BasicUser", $true)
            }

            if ($includeChildSites) {
                $params.Add("IncludeChildSites", $true)
            }

            [System.Windows.Input.Mouse]::OverrideCursor = [System.Windows.Input.Cursors]::Wait
            try {
                # Connect using the profile parameters
                Connect-Vms @params
            } finally {
                [System.Windows.Input.Mouse]::OverrideCursor = $null  # Reset the cursor
            }

            # Save the connection profile
            Save-VmsConnectionProfile -Name $profileName -Force
            Write-Output "Profile '$profileName' saved successfully."
        } catch {
            Write-Error "Failed to save profile '$profileName': $_"
        } finally {
            $password = $null       # Clear the plain text password
            $securePassword = $null # Clear securestring
        }

        $window.Close()
    })

    # Handle Cancel button click
    $cancelButton.Add_Click({
        $window.Close()
    })

    # Show the window dialog
    $window.ShowDialog() | Out-Null
}
