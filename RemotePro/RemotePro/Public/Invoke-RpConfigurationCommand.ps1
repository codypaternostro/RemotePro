<#
# Example usage:
# Load the parameters from config and override some
$overrideParams = @{
    'Param1' = 'Value1'
    'Param2' = 'Value2'
}

Invoke-RpConfigurationCommand -ConfigFilePath $(Get-RpConfigurationCommand) -CommandName 'Get-RPVmsHardware' -OverrideParams $overrideParams

or

Invoke-RpConfigurationCommand -ConfigFilePath $(Get-RpConfigurationCommand) -CommandName 'Get-RPVmsHardware'
#>
function Invoke-RpConfigurationCommand {
    [CmdletBinding()]
    param (
        [string]$ConfigFilePath,   # Path to the configuration JSON file
        [string]$CommandName,      # Name of the command to invoke
        [hashtable]$OverrideParams # Optional - parameters to override the default ones in the config
    )

    # Check if the config file exists
    if (-not (Test-Path -Path $ConfigFilePath)) {
        Write-Error "Configuration file not found at $ConfigFilePath"
        return
    }

    # Load the config file
    $configContent = Get-Content -Path $ConfigFilePath -Raw
    $config = $configContent | ConvertFrom-Json

    # Check if the command exists in the config
    if (-not $config.PSObject.Properties[$CommandName]) {
        Write-Error "Command '$CommandName' not found in configuration."
        return
    }

    # Get the parameters for the command from the config
    $commandParams = $config.$CommandName

    # Create a hashtable to store the parameters that will be passed to the command
    $paramsToPass = @{}

    foreach ($paramName in $commandParams.Keys) {
        # Check if the parameter is mandatory or has a default value
        $paramInfo = $commandParams[$paramName]

        # Use override parameters if specified, otherwise use the default from the config
        if ($OverrideParams.ContainsKey($paramName)) {
            $paramsToPass[$paramName] = $OverrideParams[$paramName]
        } elseif ($paramInfo.Mandatory) {
            # If the parameter is mandatory and not overridden, prompt the user
            $paramsToPass[$paramName] = Read-Host "Enter value for mandatory parameter '$paramName'"
        }
    }

    # Dynamically invoke the command with the parameters
    try {
        Write-Output "Invoking command '$CommandName' with parameters:"
        $paramsToPass | Format-Table

        & $CommandName @paramsToPass
    }
    catch {
        Write-Error "Error invoking command '$CommandName': $_"
    }
}


