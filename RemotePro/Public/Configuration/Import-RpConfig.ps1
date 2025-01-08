function Import-RpConfig {
    <#
    .SYNOPSIS
    Imports and processes a configuration JSON file for RemotePro.

    .DESCRIPTION
    The Import-RpConfig function reads a JSON configuration file, converts it into
    a PowerShell object, and processes each module and command defined in the
    configuration. It creates a hashtable of modules, each containing a collection
    of commands with their details and parameters. Each command object includes an
    InvokeCommand method to execute the command with its parameters.

    .PARAMETER ConfigFilePath
    Specifies the path to the configuration JSON file. If not provided, the
    function will use a default path obtained from Get-RPConfigPath.

    .EXAMPLE
    Import-RpConfig -ConfigFilePath "C:\Path\To\Config.json"
    Imports and processes the configuration from the specified JSON file.

    .EXAMPLE
    Import-RpConfig
    Imports and processes the configuration using the default path.

    .NOTES
    The function adds custom type names to the objects for better identification
    and processing. It also includes verbose logging for detailed execution
    information.

    The following propeties are added to the command object:
    ModuleName, CommandName, Id, Description, and Parameters.

    The following methods are added to the command object:
    InvokeCommand: A method to execute the command with its parameters.
    #>
    [CmdletBinding()]
    param (
        [string]$ConfigFilePath    # Path to the configuration JSON file
    )

    begin {
        Add-Type -AssemblyName PresentationFramework

        # Use appdata path if there is not a filepath value.
        if (-not ($ConfigFilePath)){
            $ConfigFilePath = Get-RPConfigPath
        }
    }

    process {
        # Load the JSON configuration file into a string
        $configContent = Get-Content -Path $ConfigFilePath -Raw
        Write-Verbose "Config content loaded from file."

        # Convert the JSON string into a PowerShell object
        $config = $configContent | ConvertFrom-Json
        Write-Verbose "Config successfully converted from JSON."

        # Create a hashtable to hold modules and commands
        $modules = @{}

        # Iterate over each module in the configuration
        foreach ($moduleName in $config.ConfigCommands.PSObject.Properties.Name) {
            $moduleName.PSObject.TypeNames.Insert(0,"$moduleName")
            Write-Verbose "Processing module: $moduleName"

            $moduleCommands = @{}  # Each module will have a collection of commands
            $moduleCommands.PSObject.TypeNames.Insert(0,"$moduleName.ConfigCommands")

            # Iterate over each command in the module
            foreach ($commandDetails in $config.ConfigCommands.$moduleName) {
                Write-Verbose "Processing command: $($commandDetails.CommandName) with ID $($commandDetails.Id)"
                $commandDetails.PSObject.TypeNames.Insert(0,"$moduleName.ConfigCommands.$CommandName")

                # Create a custom object to hold the command details
                $commandObject = [pscustomobject]@{
                    ModuleName  = $commandDetails.ModuleName
                    CommandName = $commandDetails.CommandName
                    Id          = $commandDetails.Id
                    Description = $commandDetails.Description
                    Parameters  = $commandDetails.Parameters  # Nested parameters for each command
                }

                $commandObject.PSObject.TypeNames.Insert(0,"$moduleName.ConfigCommands.$(($commandDetails.CommandName))[$(($commandDetails.Id))].ModuleName")
                $commandObject.PSObject.TypeNames.Insert(0,"$moduleName.ConfigCommands.$(($commandDetails.CommandName))[$(($commandDetails.Id))]")
                $commandObject.Id.PSObject.TypeNames.Insert(0,"$moduleName.ConfigCommands.$(($commandDetails.CommandName))[$(($commandDetails.Id))].Id.String")
                $commandObject.Parameters.PSObject.TypeNames.Insert(0,"$moduleName.ConfigCommands.$(($commandDetails.CommandName)).Parameters.PSCustomObject")


                $commandObject | Add-Member -MemberType ScriptMethod -Name "InvokeCommand" -Force -Value {
                    param (
                        [String]$Id  # Allow $Id to be optional
                    )

                    # Default to the CommandObject's ID if none is provided
                    if (-not $Id) {
                        Write-Verbose "No ID provided. Defaulting to CommandObject's ID: $($this.Id)"
                        $Id = $this.Id
                    }

                    Write-Verbose "Checking if command ID matches. Provided: $Id, CommandObject ID: $($this.Id)"
                    if ([String]$this.Id -eq $Id) {
                        Write-Verbose "Command '$($this.CommandName)' with ID $Id matched. Preparing to invoke..."

                        # Construct the parameter hashtable
                        $paramHash = @{}
                        foreach ($paramName in $this.Parameters.PSObject.Properties.Name) {
                            $paramConfig = $this.Parameters.$paramName
                            if ($paramConfig -is [string] -and $paramConfig.StartsWith('@{')) {
                                try {
                                    $paramValue = ($paramConfig -split ';') | ForEach-Object {
                                        if ($_ -match 'Value=(.*)$') { $matches[1].Trim('}') }
                                    }
                                    if ($null -ne $paramValue -and -not [string]::IsNullOrEmpty($paramValue)) {
                                        $paramHash[$paramName] = $paramValue
                                    }
                                } catch {
                                    Write-Warning "Skipping malformed parameter '$paramName'. Error: $_"
                                }
                            } elseif ($null -ne $paramConfig -and $null -ne $paramConfig.Value) {
                                $paramHash[$paramName] = $paramConfig.Value
                            }
                        }

                        Write-Verbose "Parameters for command '$($this.CommandName)': $paramHash"

                        try {
                            # Invoke the command and return the output
                            Write-Verbose "Invoking command: $($this.CommandName)"
                            $results = & $this.CommandName @paramHash
                            Write-Verbose "Command executed successfully. Results: $($results | Out-String)"
                            return $results
                        } catch {
                            Write-Error "Error invoking command '$($this.CommandName)': $_"
                        }
                    } else {
                        Write-Error "Command ID $Id does not match CommandObject ID $($this.Id)."
                    }
                }



                # Store the command object by both CommandName and Id
                if (-not $moduleCommands.ContainsKey($commandDetails.CommandName)) {
                    $moduleCommands[$commandDetails.CommandName] = @{}
                }

                # Store command object keyed by its unique Id
                $moduleCommands[$commandDetails.CommandName][$commandDetails.Id] = $commandObject
            }

            # Add the processed module to the main hashtable
            $modules[$moduleName] = $moduleCommands
        }

        # Return the final modules hashtable
        return $modules
    }
}
<#
Add-RpConfigCommand -ModuleName 'MilestonePSTools' -ConfigFilePath $(Get-RpConfigPath) -CommandNames @('Get-VmsCameraReport') -ID 18

Set-RpConfigCommand -ModuleName 'MilestonePSTools' -CommandName 'Get-VmsCameraReport' -Id 18 -ConfigFilePath $(Get-Rpconfigpath) -ShowDialog

$modules = Import-RpConfig -ConfigFilePath $(Get-RPConfigPath)

$modules.MilestonePSTools.'Get-VmsCameraReport'[18].InvokeCommand(18)
#>
