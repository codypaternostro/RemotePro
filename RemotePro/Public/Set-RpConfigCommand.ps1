function Set-RpConfigCommand {
    [CmdletBinding()]
    param (
        [string]$ModuleName,                   # Name of the module where the command exists
        [string]$CommandName,                  # Command name to update parameter values
        [int]$Id,                              # Unique ID for the command version
        [hashtable]$ParameterValues = $null,   # Optional: Parameter values to be updated (key = param name, value = param value)
        [string]$ConfigFilePath,               # Path to the configuration JSON file
        [switch]$ShowDialog                    # Show GUI dialog for parameter editing
    )

    # Load WPF assemblies
    Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

    # Check if the config file exists
    if (-not (Test-Path -Path $ConfigFilePath)) {
        Write-Error "Configuration file not found at $ConfigFilePath"
        return
    }

    # Load the existing configuration
    $configContent = Get-Content -Path $ConfigFilePath -Raw
    $config = $configContent | ConvertFrom-Json

    # Ensure the module exists in the configuration
    if (-not $config.ConfigCommands.PSObject.Properties[$ModuleName]) {
        Write-Error "Module '$ModuleName' not found in the configuration."
        return
    }

    # Find the command with the specified name and ID in the module
    $commandDetails = $config.ConfigCommands.$ModuleName | Where-Object { $_.CommandName -eq $CommandName -and $_.Id -eq $Id }

    if (-not $commandDetails) {
        Write-Error "Command '$CommandName' with ID '$Id' not found in module '$ModuleName'."
        return
    }

    # Function to parse the parameter string (like "@{Type=System.Management.Automation.SwitchParameter; Mandatory=False; Value=}")
    function Convert-StringToHashtable {
        param ([string]$parameterString)
        # Remove the '@{}' and replace ';' with new lines for easier parsing
        $parameterString = $parameterString.TrimStart('@{').TrimEnd('}')
        $parameterString = $parameterString -replace '; ', "`n"
        return $parameterString | ConvertFrom-StringData
    }

    # Function to convert the hashtable back to string format (ensuring key order)
    function Convert-HashtableToString {
        param ([hashtable]$hash)
        # Ensure the keys are ordered: 'Type', 'Mandatory', then 'Value'
        $orderedKeys = @('Type', 'Mandatory', 'Value')
        $string = '@{'
        foreach ($key in $orderedKeys) {
            if ($hash.ContainsKey($key)) {
                $string += "$key=$($hash[$key]); "
            }
        }
        $string.TrimEnd('; ') + '}'
    }

    # Ensure that all parameters are parsed into proper hashtables
    foreach ($paramName in $commandDetails.Parameters.PSObject.Properties.Name) {
        $paramDetails = $commandDetails.Parameters.$paramName

        # If the parameter is stored as a string, convert it to a hashtable
        if ($paramDetails -is [string]) {
            $commandDetails.Parameters.$paramName = Convert-StringToHashtable -parameterString $paramDetails
        }
    }

    # If -ShowDialog is used, open a WPF GUI to edit the parameters
    if ($ShowDialog) {
        Write-Host "Opening WPF GUI to edit parameter values for '$CommandName' (ID: $Id)..."

        # Create the XAML layout for the window dynamically
        $xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Title="Edit Parameters" Height="400" Width="400" WindowStartupLocation="CenterScreen">
    <StackPanel>
        <ScrollViewer VerticalScrollBarVisibility="Auto" Height="300">
            <StackPanel Name="ParameterStack">
            </StackPanel>
        </ScrollViewer>
        <StackPanel Orientation="Horizontal" HorizontalAlignment="Center" Margin="10">
            <Button Name="SubmitButton" Width="75" Margin="10" Content="Submit" />
            <Button Name="CancelButton" Width="75" Margin="10" Content="Cancel" />
        </StackPanel>
    </StackPanel>
</Window>
"@

        # Load the XAML into a WPF Window
        $form = [Windows.Markup.XamlReader]::Parse($xaml)

        # Access controls and the stack panel to add dynamic input fields
        $parameterStack = $form.FindName("ParameterStack")
        $submitButton = $form.FindName("SubmitButton")
        $cancelButton = $form.FindName("CancelButton")

        # Initialize a hashtable to store the textboxes for parameters
        $textBoxes = @{}

        # Loop through parameters and create textboxes for editing
        foreach ($paramName in $commandDetails.Parameters.PSObject.Properties.Name) {
            $paramDetails = $commandDetails.Parameters.$paramName
            $paramValue = if ($paramDetails.PSObject.Properties["Value"]) { $paramDetails.Value } else { "" }

            # Add a label and textbox dynamically for each parameter
            $label = New-Object Windows.Controls.TextBlock
            $label.Text = $paramName
            $label.Margin = "5,5,5,5"
            $parameterStack.Children.Add($label)

            $textBox = New-Object Windows.Controls.TextBox
            $textBox.Text = $paramValue
            $textBox.Margin = "5,5,5,5"
            $parameterStack.Children.Add($textBox)

            # Store the textbox in the hashtable for later retrieval
            $textBoxes[$paramName] = $textBox
        }

        # Define the Submit button click event
        $submitButton.Add_Click({
            foreach ($paramName in $textBoxes.Keys) {
                # Update the Value of the parameter
                $commandDetails.Parameters.$paramName.Value = $textBoxes[$paramName].Text
                Write-Host "Parameter '$paramName' updated with value '$($textBoxes[$paramName].Text)'"
            }
            $form.DialogResult = $true
            $form.Close()
        })

        # Define the Cancel button click event
        $cancelButton.Add_Click({
            Write-Host "User canceled the update."
            $form.DialogResult = $false
            $form.Close()
        })

        # Show the WPF window and wait for the result
        $result = $form.ShowDialog()

        if (-not $result) {
            Write-Host "No changes made."
            return
        }
    }

    # Update the parameters directly if ParameterValues are passed
    elseif ($ParameterValues) {
        foreach ($paramName in $ParameterValues.Keys) {
            if ($commandDetails.Parameters[$paramName]) {
                $commandDetails.Parameters[$paramName].Value = $ParameterValues[$paramName]
                Write-Host "Parameter '$paramName' updated with value '$($ParameterValues[$paramName])'"
            } else {
                Write-Warning "Parameter '$paramName' not found in the command '$CommandName'."
            }
        }
    } else {
        Write-Error "No parameter values were provided or modified. Use either -ShowDialog or provide -ParameterValues."
        return
    }

    # Before saving, convert all parameter hashtables back to string format
    foreach ($paramName in $commandDetails.Parameters.PSObject.Properties.Name) {
        $paramDetails = $commandDetails.Parameters.$paramName
        # If it's a hashtable, convert it back to a string representation
        if ($paramDetails -is [hashtable]) {
            $commandDetails.Parameters.$paramName = Convert-HashtableToString -hash $paramDetails
        }
    }

    # Convert the updated configuration back to JSON
    $jsonConfig = $config | ConvertTo-Json -Depth 4

    # Save the updated configuration to the JSON file
    Set-Content -Path $ConfigFilePath -Value $jsonConfig

    Write-Host "Parameter values for command '$CommandName' updated in module '$ModuleName' and saved to $ConfigFilePath"
}
