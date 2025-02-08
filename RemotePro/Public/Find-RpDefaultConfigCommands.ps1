function Find-RpDefaultConfigCommands {
    <#
    .SYNOPSIS
    Retrieves the default configuration commands from the
    RemoteProParamConfigDefaultIds.json file.

    .DESCRIPTION
    The Find-RpDefaultConfigCommands function is used to retrieve the default
    configuration commands from the RemoteProParamConfigDefaultIds.json file
    using the Get-RPConfigPath -DefaultIds cmdlet. It can retrieve commands
    by name, by Id, or all commands across all modules.

    .COMPONENT
    DefaultConfigCommands

    .PARAMETER CommandName
    The name of the command to retrieve.

    .PARAMETER Id
    The Id of the command to retrieve.

    .PARAMETER ConfigFilePath
    The path to the configuration JSON file. If not specified, the default
    path is used.

    .PARAMETER All
    Switch to retrieve all commands from all modules.

    .EXAMPLE
    Find-RpDefaultConfigCommands -CommandName "ExampleCommand"

    .EXAMPLE
    Find-RpDefaultConfigCommands -Id "12345"

    .EXAMPLE
    Find-RpDefaultConfigCommands -All
    #>
    [CmdletBinding()]
    param (
        # The name of the command to retrieve
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName = $true)]
        [string]$CommandName,

        # The name of the command to retrieve
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName = $true)]
        [string]$Id,

        # Path to the configuration JSON file
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName = $true)]
        [string]$ConfigFilePath,

        # Retrieve all commands from all modules
        [Parameter(Mandatory=$false)]
        [switch]$All

    )

    begin {
        # Use appdata path if there is not a filepath value.
        if (-not ($ConfigFilePath)){
            $ConfigFilePath = Get-RPConfigPath -DefaultIds
        }
    }

    process {
        # Load the configuration
        $configContent = Get-Content -Path $ConfigFilePath -Raw
        $config = $configContent | ConvertFrom-Json

        # Retrieve all commands across all modules
        if ($All) {
            return $config
        }

        # If Id is specified, retrieve the command by Id
        if ($Id){

            # Create a hashtable to store commands by Id
            $commandById = @{}

            # Iterate through each command and store it in the hashtable
            foreach ($command in $config.PSObject.Properties) {
                $result = $command | Where-Object { $_.Value -eq $Id }

                if ($result){
                    $commandById[$result.Name] = $result.Value
                }
            }

            return $commandById
        }

        if ($CommandName) {
            # Check if the command exists
            $commandDetails = $config.PSObject.Properties | Where-Object { $_.Name -eq $CommandName }

            if (-not $commandDetails) {
                Write-Error "Command '$CommandName' not found in RemoteProParamConfigDefaultIds.json."
                return
            }

            # Return the command details
            return ($commandDetails | Select-Object -Property Name, Value)
        }
    }
    end {}
}
