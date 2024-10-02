function Import-RpConfiguration {
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

    return $config
}




# Example usage:
<#

# Preload parameters into a hashtable
$paramsToPass = @{
    'Name' = 'notepad'
}

# Dynamically invoke the command
& "Get-Process" @paramsToPass


# Example usage:
# Import the configuration and load it into a hashtable
$config = Import-RpConfiguration -ConfigFilePath 'C:\Path\To\Config.json'

# Access a command's parameters using dot notation
$getProcessParams = $config.ConfigCommands.RemotePro.'Get-Process'.Parameters

# Example: Accessing the 'Name' parameter details
$nameParam = $getProcessParams.Name
$nameParam.Type       # Outputs: System.String
$nameParam.Mandatory  # Outputs: False
#>
