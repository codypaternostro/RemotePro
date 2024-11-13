function Import-RpConfig {
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


                # Add a script method to dynamically invoke the command
                $commandObject | Add-Member -MemberType ScriptMethod -Name "InvokeWithId" -Force -Value {
                    param ($Id)

                    # Verify if the command ID matches the provided one
                    Write-Verbose "Checking if command ID matches. Expected: $Id, Actual: $($this.Id)"
                    if ($this.Id -eq $Id) {
                        Write-Verbose "Command '$($this.CommandName)' with ID $Id matched. Invoking now..."

                        # Prepare the parameter hashtable
                        $paramHash = @{}  # To store valid parameters

                        # Iterate over each parameter in the command
                        foreach ($paramName in $this.Parameters.PSObject.Properties.Name) {
                            $paramConfig = $this.Parameters.$paramName
                            Write-Verbose "Processing parameter: $paramName"

                            # Extract the 'Value' part from the stringified hashtable
                            if ($paramConfig -is [string] -and $paramConfig.StartsWith('@{')) {
                                try {
                                    # Split and capture the 'Value' field manually
                                    $paramValue = ($paramConfig -split ';') | ForEach-Object {
                                        if ($_ -match 'Value=(.*)$') { $matches[1].Trim('}') }
                                    }

                                    # Check if we successfully extracted the 'Value'
                                    if ($null -ne $paramValue -and -not [string]::IsNullOrEmpty($paramValue)) {
                                        Write-Verbose "Extracted value for parameter '$paramName': $paramValue"

                                        # Handle switch parameters
                                        if ($paramConfig -match 'SwitchParameter') {
                                            if ($paramValue -eq 'True') {
                                                $paramHash[$paramName] = $true
                                            } elseif ($paramValue -eq 'False') {
                                                $paramHash[$paramName] = $false
                                            }
                                        } else {
                                            # For regular parameters, assign the value
                                            $paramHash[$paramName] = $paramValue
                                        }
                                    } else {
                                        Write-Warning "Skipping parameter '$paramName' due to missing or empty 'Value'."
                                    }
                                } catch {
                                    Write-Warning "Skipping malformed parameter: '$paramName'. Error: $_"
                                    continue
                                }
                            } else {
                                # Handle cases where the parameter is not a stringified hashtable
                                if ($null -ne $paramConfig -and $null -ne $paramConfig.Value) {
                                    $paramHash[$paramName] = $paramConfig.Value
                                }
                            }
                        }

                        # Debug: Show the final parameters being passed
                        if ($paramHash.Count -gt 0) {
                            Write-Verbose "Parameters being passed to the command:"
                            foreach ($key in $paramHash.Keys) {
                                Write-Verbose "$key = $($paramHash[$key])"
                            }

                            # Try to invoke the command with splatted parameters
                            try {
                                if (Get-Command $this.CommandName -ErrorAction SilentlyContinue) {
                                    Write-Verbose "Running command '$($this.CommandName)'..."
                                    & $this.CommandName @paramHash  # Splat the hashtable with valid parameters
                                } else {
                                    Write-Error "Command '$($this.CommandName)' not found."
                                }
                            } catch {
                                Write-Error "Error invoking command '$($this.CommandName)': $_"
                            }
                        } else {
                            Write-Verbose "No parameters with valid values are being passed."
                        }
                    } else {
                        Write-Error "Error: Command ID $Id not found."
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

$modules.MilestonePSTools.'Get-VmsCameraReport'[18].InvokeWithId(18)
#>
