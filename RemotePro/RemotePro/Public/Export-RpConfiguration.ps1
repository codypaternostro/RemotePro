<#
Goal of this command to be able to provide the user with a configuration
file that will be used in combination with runspace button clicks.

This will allow the user to be able to customize and save preference on the
paramterts use within a tab on the RemotePro GUI.

So far... this function builds a base config file dynamically for public
exported functions. So, It will be ideal to make calls to commands using
the parameters for each command from the configuration file.

Should the config scan for just RemotePro while it theoretically can also
scan MilestonePSTools?
How will the user ineteract with the configuration file?

If both module's commands are available in the config file, the config
file will only be used for runspace, buton-click, commands to make things
clear to the user. If a seperate config is desired, there will need to
be a seperate file.

Duplicate 'Get-Metadata' commands between Configuration and MilestonePSTools
can cause issues so, it may be a good idea to call the command from a wrapped
function call to avoid any undesired errors...


function Get-MetadataFromConfiguration {
    Configuration\Get-Metadata @PSBoundParameters
}

EXAMPLE.
Export-RpConfiguration -ModuleName 'RemotePro' -ConfigFilePath $(Get-RPConfigurationPath)

#>

function Export-RpConfiguration {
    [CmdletBinding()]
    param (
        [string]$ModuleName,
        [string]$ConfigFilePath
    )

    # Get all the commands from the module
    $commands = Get-Command -Module $ModuleName

    # Create a hashtable to store the config structure
    $config = @{}

    # Loop through each command
    foreach ($command in $commands) {
        # Get the parameters of the command
        $parameters = $command.Parameters

        # Create a hashtable for the command's parameters
        $paramConfig = @{}
        foreach ($param in $parameters.Keys) {
            # Add parameter metadata like default value, type, mandatory, etc.
            $paramDetails = @{
                'Type' = $parameters[$param].ParameterType.FullName
                'Mandatory' = $parameters[$param].Attributes.Mandatory
            }
            $paramConfig[$param] = $paramDetails
        }

        # Add this command and its parameters to the config hashtable
        $config[$command.Name] = $paramConfig
    }

    # Convert the hashtable to JSON
    $jsonConfig = $config | ConvertTo-Json -Depth 3

    # Save the JSON configuration file
    Set-Content -Path $ConfigFilePath -Value $jsonConfig

    Write-Host "Configuration saved to $ConfigFilePath"
}

# Example usage: Export parameters of a module (e.g., 'YourModuleName')
#Export-RpRunspaceConfig -ModuleName 'RemotePro'
