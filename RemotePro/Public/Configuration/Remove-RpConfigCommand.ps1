function Remove-RpConfigCommand {
    <#
    .SYNOPSIS
    Removes a configuration command from the RemotePro controller object.

    .DESCRIPTION
    The Remove-RpConfigCommand cmdlet removes a specified configuration command
    from the RemotePro controller object.

    .PARAMETER CommandName
    The name of the configuration command to remove. This parameter is mandatory
    and accepts pipeline input by property name.

    .EXAMPLE
    Remove-RpConfigCommand -CommandName "TestCommand"

    This command removes the configuration command named "TestCommand" from the
    RemotePro controller object.

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

        [Parameter(Mandatory = $true)]
        [ValidateSet("ControllerObject","Config")]
        [string]$Scope
    )

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

                "Config" {
                    try {
                        $configPath = Get-RPConfigPath
                        $config = Get-Content -Path $configPath | ConvertFrom-Json

                        # Iterate each module
                        foreach ($module in $config.ConfigCommands) {
                            Write-Verbose "Processing module: $module"
                            # Iterate each command in the module

                            foreach ($command in $config.ConfigCommands.$module) {
                                Write-Verbose "Processing command: $command"


                                $command | Where-Object { $_.Id -eq $Id } | ForEach-Object {
                                    Write-Verbose "Removing command values with Id: $Id"
                                    $config.ConfigCommands.$module.$command.PSObject.BaseObject.Values.Remove("$Id")
                                    Write-Verbose "Removed command values with Id: $Id"
                                }

<#
 # {                                # Remove nested hash table properties per provided Id
                                if ($config.ConfigCommands.$module.$command.Id -eq $Id) {
                                    Write-Verbose "Removing command values with Id: $Id"
                                    $config.ConfigCommands.$module.PSObject.BaseObject.Values.Remove("$Id")
                                    Write-Verbose "Removed command values with Id: $Id"

                                    # Remove the command if no values are left
                                    if ($config.ConfigCommands.$command.PSObject.BaseObject.Values.Count -eq 0) {
                                        Write-Verbose "Removing command: $command"
                                        $config.ConfigCommands.$module.Remove("$commandName")
                                        Write-Verbose "Removed command: $command"
                                    }

                                }:ToDo: revise this block of code to remove the command from the config object}
#>
                            }
                        }

                        try {
                            Write-Verbose "Updated config object: $config"
                            # Export the updated config back to the same path
                            $config | ConvertTo-Json -Depth 4 | Set-Content -Path $configPath

                            Write-Verbose "Successfully updated Config."
                        }
                        catch {
                            Write-Error "Failed to update Config."
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
        return $script:RemotePro.ConfigCommands
    }
}
