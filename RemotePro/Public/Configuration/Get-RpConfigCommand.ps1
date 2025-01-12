function Get-RpConfigCommand {
 <#
    .SYNOPSIS
    Retrieves details of a specific command or all commands from the config file.

    .DESCRIPTION
    Get-RpConfigCommand retrieves the details of a specific command or all
    commands from the provided configuration JSON file. It can return command
    details for one command, all commands within a module, or all commands
    across all modules using the `-All` and `-ByModule` parameters.

    .PARAMETER ModuleName
    The name of the module where the command is located.

    .PARAMETER CommandName
    The name of the command to retrieve from the module.

    .PARAMETER ConfigFilePath
    The path to the configuration JSON file that stores the command details.

    .PARAMETER All
    Retrieves all commands from all modules in the configuration.

    .PARAMETER ByModule
    Retrieves all commands within the specified module.

    .PARAMETER Id
    Retrieves the command by its unique identifier (Id). Useful for finding a
    command by Id to debug or troubleshoot when the command name has a
    duplicate Id.

    .EXAMPLE
    Get-RpConfigCommand -ModuleName 'RemotePro' -CommandName 'Get-RpLogPath' `
                        -ConfigFilePath $(Get-RPConfigurationPath)
    Retrieves the 'Get-RpLogPath' command details from the 'RemotePro' module
    using the configuration path from Get-RPConfigurationPath.

    .EXAMPLE
    Get-RpConfigCommand -ByModule -ModuleName 'RemotePro' `
                        -ConfigFilePath $(Get-RPConfigurationPath)
    Retrieves all commands within the 'RemotePro' module.

    .EXAMPLE
    Get-RpConfigCommand -All -ConfigFilePath $(Get-RPConfigurationPath)
    Retrieves all commands from all modules in the configuration.

    .EXAMPLE
    Get-RpConfigCommand -Id '12345' -ConfigFilePath $(Get-RPConfigurationPath)
    Retrieves the command with the Id '12345' from the configuration.
    #>
    [CmdletBinding()]
    param (
        # The name of the module to retrieve the command from
        [Parameter(Mandatory=$false, Position=0, ValueFromPipelineByPropertyName = $true)]
        [string]$ModuleName,

        # The name of the command to retrieve
        [Parameter(Mandatory=$false, Position=1, ValueFromPipelineByPropertyName = $true)]
        [string]$CommandName,

        # The name of the command to retrieve
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName = $true)]
        [string]$Id,

        # Path to the configuration JSON file
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName = $true)]
        [string]$ConfigFilePath,

        # Retrieve all commands from all modules
        [switch]$All,

        # Retrieve all commands in a specific module
        [switch]$ByModule
    )

    begin {
        Add-Type -AssemblyName PresentationFramework

        # Use appdata path if there is not a filepath value.
        if (-not ($ConfigFilePath)){
            $ConfigFilePath = Get-RPConfigPath
        }
    }

    process {
        # Load the configuration
        $configContent = Get-Content -Path $ConfigFilePath -Raw
        $config = $configContent | ConvertFrom-Json

        # Retrieve all commands across all modules
        if ($All) {
            return $config.ConfigCommands
        }

        # If Id is specified, retrieve the command by Id
        if ($Id){

            # Create a hashtable to store commands by Id
            $commandById = @{}

            # Iterate through each command and store it in the hashtable
            foreach ($command in $config.ConfigCommands.PSObject.Properties.Value) {
                $result = $command | Where-Object { $_.Id -eq $Id }

                if ($result){
                    $commandById[$result.CommandName] = $result
                }
            }

            # Return the command by Id, useful for finding a command by Id
            # to debug or troubleshoot when the command name is for some
            # reason has a duplicate Id.
            return $commandById.Values
        }

        # Check if the module exists
        if (-not $config.ConfigCommands.PSObject.Properties[$ModuleName]) {
            Write-Error "Module '$ModuleName' not found in configuration."
            return
        }

        # If ByModule is specified, retrieve all commands from the module
        if ($ByModule) {
            return $config.ConfigCommands.$ModuleName
        }

        # Check if the command exists
        $commandDetails = $config.ConfigCommands.$ModuleName | Where-Object { $_.CommandName -eq $CommandName }

        if (-not $commandDetails) {
            Write-Error "Command '$CommandName' not found in module '$ModuleName'."
            return
        }

        # Return the command details
        return $commandDetails
    }
    end {}
}
