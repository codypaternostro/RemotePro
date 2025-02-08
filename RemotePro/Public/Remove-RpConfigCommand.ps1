function Remove-RpConfigCommand {
    <#
    .SYNOPSIS
    Removes a configuration command from the RemotePro controller object.

    .DESCRIPTION
    The Remove-RpConfigCommand cmdlet removes a specified configuration command
    from the RemotePro controller object.

    .COMPONENT
    ConfigCommands

    .PARAMETER CommandName
    The name of the configuration command to remove. This parameter is mandatory
    and accepts pipeline input by property name.

    .PARAMETER Id
    The unique identifier of the configuration command to remove. This parameter
    is mandatory and accepts pipeline input by property name.

    .PARAMETER Scope
    Specifies the scope of the configuration command to remove. Valid values are
    "ControllerObject" and "ConfigCommand". This parameter is mandatory.

    Please see Get-RpControllerObject and Find-RpConfigCommand to verify
    the source data being modified.

    .PARAMETER ConfigFilePath
    The path to the configuration JSON file. This parameter is optional and
    accepts pipeline input by property name. If not specified, the default
    configuration path is used.

    .EXAMPLE
    Remove-RpConfigCommand -CommandName "TestCommand" -Id "12345" -Scope "Config"

    This command removes the configuration command named "TestCommand" with the
    Id "12345" from the configuration file.

    .INPUTS
    System.String

    .OUTPUTS
    System.Object
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$CommandName,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$Id,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateSet("ControllerObject","ConfigCommand")]
        [string]$Scope,

        # Path to the configuration JSON file
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName = $true)]
        [string]$ConfigFilePath
    )

    begin {
        # Use appdata path if there is not a filepath value.
        if (-not ($ConfigFilePath)){
            $ConfigFilePath = Get-RPConfigPath
        }
    }

    process{
        try {
           switch ($PSBoundParameters['Scope']) {
                "ControllerObject" {
                    try {
                        $controllerObject = Get-RpControllerObject

                        # Iterate each module
                        foreach ($module in $($controllerObject.ConfigCommands.Keys)) {
                            Write-Verbose "Processing module: $module"
                            # Iteratre each command in the module
                            foreach ($command in $($controllerObject.ConfigCommands.$module.Keys)) {
                                Write-Verbose "Processing command: $command"
                                # Remove nested hash table properties per provided Id
                                if ($controllerObject.ConfigCommands.$module.$command.Values.Id -eq $Id) {
                                    Write-Verbose "Removing command values with Id: $Id"
                                    $controllerObject.ConfigCommands.$module.PSObject.BaseObject.Values.Remove("$Id")
                                    Write-Verbose "Removed command values with Id: $Id"

                                    # Remove the command if no values are left
                                    if ($controllerObject.ConfigCommands.$module.$command.PSObject.BaseObject.Values.Count -eq 0) {
                                        Write-Verbose "Removing command: $command"
                                        $controllerObject.ConfigCommands.$module.Remove("$commandName")
                                        Write-Verbose "Removed command: $command"
                                    }

                                }
                            }
                        }

                        try {
                            Write-Verbose "Updated controller object: $controllerObject"
                            # Update the controller object
                            $script:RemotePro = $controllerObject
                            Write-Verbose "Successfully updated RemotePro with the new ControllerObject."
                        }
                        catch {
                            Write-Error "Failed to update RemotePro with the new ControllerObject."
                        }

                    }
                    catch {
                        Write-Error "Failed to remove command: $CommandName $($_.Exception.Message)"
                    }

                }

                "ConfigCommand" {
                    try {
                        $config = Get-Content -Path $configFilePath | ConvertFrom-Json

                        foreach ($module in $config.ConfigCommands.PSObject.Properties) {
                            $moduleName = $module.Name
                            Write-Verbose "Processing module: $moduleName"

                            # Retrieve the command list and check if it's modifiable
                            $commandList = $module.Value

                            if ($commandList -is [System.Array]) {
                                # Convert array to list for easier modification
                                $commandList = [System.Collections.Generic.List[Object]]::new($commandList)
                                $config.ConfigCommands.$moduleName = $commandList
                            }

                            # Create a copy of the command list for safe iteration
                            $commandListCopy = @($commandList)

                            # Iterate over the copied list
                            foreach ($commandObj in $commandListCopy) {
                                $commandName = $commandObj.CommandName
                                Write-Verbose "Processing command: $commandName"

                                # Filter and remove the object with the matching Id
                                if ($commandObj.Id -eq $Id) {
                                    Write-Verbose "Removing command values with Id: $Id"

                                    # Remove the item from the original list
                                    $commandList.Remove($commandObj)

                                    Write-Verbose "Removed command values with Id: $Id"
                                }
                            }
                        }

                        try {
                            Write-Verbose "Updated config object: $config"
                            # Export the updated config back to the same path
                            $config | ConvertTo-Json -Depth 4 | Set-Content -Path $configPath

                            Write-Verbose "Successfully updated Config."
                        }
                        catch {
                            Write-Error "Failed to update Config: $($_.Exception.Message)"
                        }

                    }
                    catch {
                        Write-Error "Failed to remove command: $CommandName $($_.Exception.Message)"
                    }

                }

                default {
                    Write-Error "Invalid scope specified. Please use either 'ControllerObject' or 'Config'. $($_.Exception.Message)"
                }
            }
        }
        catch {
            Write-Error $_.Exception.Message
        }
    }
    end {
        return $script:RemotePro.ConfigCommands
    }
}
