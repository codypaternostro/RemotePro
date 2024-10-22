function Import-RpConfig {
    [CmdletBinding()]
    param (
        [string]$ConfigFilePath    # Path to the configuration JSON file
    )

    # Check if the config file exists
    if (-not (Test-Path -Path $ConfigFilePath)) {
        Write-Error "Configuration file not found at $ConfigFilePath"
        return
    }

    # Load the JSON configuration file into a hashtable
    $configContent = Get-Content -Path $ConfigFilePath -Raw
    $config = $configContent | ConvertFrom-Json

    # Create a custom hashtable to hold modules and commands
    $modules = @{}

    # Iterate over each module in the configuration
    foreach ($moduleName in $config.ConfigCommands.PSObject.Properties.Name) {
        # Create a hashtable to hold the commands in the module
        $moduleCommands = @{}

        # Iterate over each command in the module
        foreach ($commandDetails in $config.ConfigCommands.$moduleName) {
            # Create a command object and add a script method that takes CommandName and Id
            $commandObject = [pscustomobject]@{
                CommandName = $commandDetails.CommandName  # Store the command name for later reference
                Id = $commandDetails.Id
                Description = $commandDetails.Description
                Parameters = $commandDetails.Parameters
            }

            # Add dynamic script method for invoking with a given ID and CommandName
            $commandObject | Add-Member -MemberType ScriptMethod -Name "InvokeWithId" -Force -Value {
                param ($Id)

                # Check if the current command ID matches the input value
                if ($this.Id -eq $Id) {
                    Write-Host "Command '$($this.CommandName)' with ID $Id matched. Invoking now..."

                    # Prepare the parameters to pass to the command dynamically based on config
                    $paramHash = @{}
                    foreach ($paramName in $this.Parameters.PSObject.Properties.Name) {
                        # Extract the actual parameter object from the config
                        $paramConfig = $this.Parameters.$paramName

                        # Extract the Value from the parameter object (if it exists)
                        $paramValue = if ($paramConfig -and $paramConfig.PSObject.Properties["Value"]) {
                            $paramConfig.Value
                        } else {
                            $null  # Handle cases where no value is defined
                        }

                        # Handle SwitchParameter conversions
                        if ($paramConfig.Type -eq "System.Management.Automation.SwitchParameter") {
                            if ($paramValue -eq 'True') {
                                $paramHash[$paramName] = $true  # Only pass if true
                            }
                        } elseif (![string]::IsNullOrEmpty($paramValue)) {
                            # Pass all other parameters only if they are non-empty
                            $paramHash[$paramName] = $paramValue
                        }
                    }

                    # DEBUG: Output the contents of the hashtable
                    Write-Host "Parameters being passed to the command:"
                    $paramHash.GetEnumerator() | ForEach-Object { "$($_.Key) = $($_.Value)" }

                    try {
                        # Check if the command is available
                        if (Get-Command $this.CommandName -ErrorAction SilentlyContinue) {
                            Write-Host "Running command '$($this.CommandName)'..."
                            # Directly invoke the actual command with the parameters and values from config
                            & $this.CommandName @paramHash
                        } else {
                            Write-Error "Command '$($this.CommandName)' is not available in the current session."
                        }
                    } catch {
                        Write-Error "Error invoking command '$($this.CommandName)': $_"
                    }
                } else {
                    Write-Error "Error: Command ID $Id not found."
                }
            }

            # Store the command using both CommandName and Id
            if (-not $moduleCommands.ContainsKey($commandDetails.CommandName)) {
                $moduleCommands[$commandDetails.CommandName] = @{}
            }

            # Use the Id as the key for uniqueness
            $moduleCommands[$commandDetails.CommandName][$commandDetails.Id] = $commandObject
        }

        # Add the module to the modules hashtable
        $modules[$moduleName] = $moduleCommands
    }

    return $modules
}
