function Import-RpConfig {
    <#
    .SYNOPSIS
    Imports and processes a configuration JSON file for RemotePro.

    .DESCRIPTION
    This function reads a JSON configuration file, converts it into a PowerShell
    object, and processes each module and command defined in the file. It returns a
    hashtable where each key represents a module, and the value is another hashtable
    containing the module's commands. Each command object includes properties like
    CommandName, Id, Description, and Parameters, as well as a method
    FormatCommandObject` to prepare the command for execution.

    The command object can be accessed using dot notation for easy navigation, and
    the FormatCommandObject method allows you to add or modify parameters before
    execution.

    Using Invoke-RpCommandObject, you can execute the formatted command locally where
    as remotely is experimental...

    .COMPONENT
    ConfigCommands

    .PARAMETER ConfigFilePath
    The path to the configuration JSON file. If not provided, the function uses the
    default path returned by the `Get-RPConfigPath` function.

    .OUTPUTS
    Hashtable
    Returns a hashtable of modules, where each module contains commands as nested
    objects.

    .EXAMPLE
    Import configuration from a specified file
    $modules = Import-RpConfig -ConfigFilePath $(Get-RpConfigPath)

    .EXAMPLE
    Import configuration using the default path
    $modules = Import-RpConfig

    .EXAMPLE
    Access and format a specific command object
    $commandObject = $modules.RemotePro.'Get-RpVmsHardwareCustom'.'1234-5678'

    .EXAMPLE
    Execute the formatted command locally using the call operator
    & $preparedCommand.CommandName @($preparedCommand.Parameters)

    .EXAMPLE
    Calling Get-RpVmsItemStateCustom from the default config commands.
    $commandId = (Get-RpDefaultConfigCommandDetails).'Get-RpVmsItemStateCustom'.Id
    $preparedCommand1 = (Get-RpConfigCommands -All).'Get-RpVmsItemStateCustom'.$commandId.FormatCommandObject($commandId)

    Calling Out-HtmlView from the default config commands.
    $commandId = (Get-RpDefaultConfigCommandDetails).'Out-HtmlView'.Id
    $preparedCommand2 = (Get-RpConfigCommands -All).'Out-HtmlView'.$commandId.FormatCommandObject($commandId)

    Invoke default config commands.
    Invoke-RpCommandObject -CommandObject $preparedCommand1 | Invoke-RpCommandObject  -CommandObject $preparedCommand2

    .EXAMPLE
    Use Invoke-RpCommandObject for execution
    $preparedCommand | Invoke-RpCommandObject

    .EXAMPLE
    Use Invoke-RpCommandObject for remote execution
    $preparedCommand | Invoke-RpCommandObject -UseInvokeCommand -ComputerName "RemoteServer"

    .NOTES
    - Modules and commands are structured as nested hashtables for easy navigation.
    - The FormatCommandObject method dynamically adds or modifies parameters.
    - Ensure the configuration JSON file follows the required schema for modules and
      commands.
    - Use dot notation to navigate the resulting $modules hashtable.
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


                $commandObject | Add-Member -MemberType ScriptMethod -Name "FormatCommandObject" -Force -Value {
                    param (
                        [String]$Id,                          # Optional command ID
                        [Hashtable]$AdditionalParameters = @{} # Additional parameters to merge
                    )

                    # Default to the CommandObject's ID if none is provided
                    if (-not $Id) {
                        Write-Verbose "No ID provided. Defaulting to CommandObject's ID: $($this.Id)"
                        $Id = $this.Id
                    }

                    Write-Verbose "Checking if command ID matches. Provided: $Id, CommandObject ID: $($this.Id)"
                    if ([String]$this.Id -eq $Id) {
                        Write-Verbose "Command '$($this.CommandName)' with ID $Id matched. Preparing the command object..."

                        # Create a static copy of parameters as a plain hashtable
                        $staticParameters = [Hashtable]::new()
                        foreach ($property in $this.Parameters.PSObject.Properties) {
                            $staticParameters[$property.Name] = $property.Value
                        }

                        # Construct the base parameter hashtable
                        $paramHash = @{}
                        foreach ($paramName in $staticParameters.Keys) {
                            $paramConfig = $staticParameters[$paramName]

                            # Handle Boolean string conversion
                            if ($paramConfig -is [string] -and ($paramConfig -eq 'true' -or $paramConfig -eq 'false')) {
                                $paramHash[$paramName] = [bool]::Parse($paramConfig)
                            }
                            # Handle key-value pairs in strings
                            elseif ($paramConfig -is [string] -and $paramConfig.StartsWith('@{')) {
                                try {
                                    # Parse key-value pairs from the string
                                    $paramValue = ($paramConfig -split ';') | ForEach-Object {
                                        if ($_ -match 'Value=(.*)$') { $matches[1].Trim('}') }
                                    }
                                    if ($null -ne $paramValue -and -not [string]::IsNullOrEmpty($paramValue)) {
                                        $paramHash[$paramName] = $paramValue
                                    }
                                } catch {
                                    Write-Warning "Skipping malformed parameter '$paramName'. Error: $_"
                                }
                            }
                            # Handle direct values
                            elseif ($null -ne $paramConfig) {
                                $paramHash[$paramName] = $paramConfig
                            }
                        }

                        Write-Verbose "Base parameters for command '$($this.CommandName)': $($paramHash | Out-String)"

                        # Merge additional parameters
                        if ($AdditionalParameters) {
                            Write-Verbose "Adding additional parameters: $($AdditionalParameters | Out-String)"
                            foreach ($key in $AdditionalParameters.Keys) {
                                $paramHash[$key] = $AdditionalParameters[$key]
                            }
                        }

                        # Convert Boolean-like strings in additional parameters
                        foreach ($key in $($paramHash.Keys)) {
                            if ($paramHash[$key] -is [string] -and ($paramHash[$key] -eq 'true' -or $paramHash[$key] -eq 'false')) {
                                $paramHash[$key] = [bool]::Parse($paramHash[$key])
                            }
                        }

                        Write-Verbose "Final parameters for command '$($this.CommandName)': $($paramHash | Out-String)"

                        # Return a reusable object
                        return [pscustomobject]@{
                            CommandName = $this.CommandName
                            Parameters  = $paramHash
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
