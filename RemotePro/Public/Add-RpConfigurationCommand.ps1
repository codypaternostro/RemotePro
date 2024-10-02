function Add-RpConfigurationCommand {
    [CmdletBinding()]
    param (
        [string]$ModuleName,                  # Name of the module to export commands from
        [string]$ConfigFilePath,              # Path to save the configuration JSON file
        [string[]]$CommandNames = @(),        # Optional: List of specific commands to export
        [int]$ID,                             # Unique ID for the command version
        [string]$Description = ""             # Optional description for the command
    )

    # Load existing configuration or create a new PSCustomObject if the file does not exist
    if (Test-Path -Path $ConfigFilePath) {
        $configContent = Get-Content -Path $ConfigFilePath -Raw
        $config = $configContent | ConvertFrom-Json
    } else {
        # Create a new configuration if the file doesn't exist
        $config = [pscustomobject]@{ ConfigCommands = @{} }
        Write-Host "No existing configuration found. Creating a new one."
    }

    # Ensure the 'ConfigCommands' section exists
    if (-not $config.PSObject.Properties['ConfigCommands']) {
        $config | Add-Member -MemberType NoteProperty -Name 'ConfigCommands' -Value @{}
    }

    # Ensure the module exists under 'ConfigCommands'
    if (-not $config.ConfigCommands.PSObject.Properties[$ModuleName]) {
        $config.ConfigCommands | Add-Member -MemberType NoteProperty -Name $ModuleName -Value @()
    }

    # Get the list of commands to export: All commands or filtered by CommandNames
    if ($CommandNames) {
        $commands = Get-Command -Module $ModuleName | Where-Object { $CommandNames -contains $_.Name }
    } else {
        $commands = Get-Command -Module $ModuleName
    }

    # Loop through each command to gather parameters and add to the configuration
    foreach ($command in $commands) {
        # Get the parameters of the command
        $parameters = $command.Parameters

        # Initialize a PSCustomObject for the command's parameters
        $paramConfig = [pscustomobject]@{}

        # Loop through each parameter and store its metadata
        foreach ($param in $parameters.Keys) {
            $paramDetails = [pscustomobject]@{
                'Type'      = $parameters[$param].ParameterType.FullName
                'Mandatory' = $parameters[$param].Attributes.Mandatory
            }
            $paramConfig | Add-Member -MemberType NoteProperty -Name $param -Value $paramDetails
        }

        # Create a new command version with a unique ID and add it to the module's array
        $commandDetails = [pscustomobject]@{
            'CommandName' = $command.Name
            'ID'          = $ID  # The ID is provided by the user
            'Description' = if ($Description) { $Description } else { "$command.Name command description" }
            'Parameters'  = $paramConfig
        }

        # Check if a command with the same ID already exists under the module
        $existingCommands = $config.ConfigCommands.$ModuleName
        $existingCommand = $existingCommands | Where-Object { $_.ID -eq $ID }

        if ($null -eq $existingCommand) {
            # Append the new command details to the module's array (without overwriting)
            $config.ConfigCommands.$ModuleName += $commandDetails
        } else {
            Write-Host "Command with ID $ID already exists for module '$ModuleName'. Skipping addition."
        }
    }

    # Convert the updated configuration back to JSON
    $jsonConfig = $config | ConvertTo-Json -Depth 4

    # Save the updated configuration to the JSON file
    Set-Content -Path $ConfigFilePath -Value $jsonConfig

    Write-Host "Configuration for module '$ModuleName' saved to $ConfigFilePath"
}



<#
Add-RpConfigurationCommand -ModuleName 'RemotePro' -ConfigFilePath 'C:\Path\To\Config.json' -CommandNames 'Get-RpEventHandlers' -ID 101 -Description "First version of Get-RpEventHandlers"
Add-RpConfigurationCommand -ModuleName 'RemotePro' -ConfigFilePath 'C:\Path\To\Config.json' -CommandNames 'Get-RpEventHandlers' -ID 102 -Description "Second version of Get-RpEventHandlers"
#>
