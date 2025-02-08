function Set-RpConfigCommands {
    <#
    .SYNOPSIS
    Sets the configuration commands for the RemotePro object.

    .DESCRIPTION
    The Set-RpConfigCommands function initializes and sets the configuration
    commands for the RemotePro object. If the RemotePro object is not initialized,
    an error is thrown. The function imports configuration commands from a specified
    file path or uses a default path if none is provided.

    .COMPONENT
    ConfigCommands

    .PARAMETER ConfigFilePath
    The file path to the configuration file. If not provided, a default path is used.

    .EXAMPLE
    Set-RpConfigCommands -ConfigFilePath "C:\Path\To\ConfigFile.json"
    This example sets the configuration commands using the specified configuration
    file path.

    .EXAMPLE
    Set-RpConfigCommands
    This example sets the configuration commands using the default configuration
    file path.

    .NOTES
    Ensure that the RemotePro object is initialized by running New-RpControllerObject
    before calling this function.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [string]$ConfigFilePath
    )

    begin {
        # Ensure RemotePro object is initialized
        if (-not $script:RemotePro) {
            Write-Error "RemotePro object is not initialized. Run New-RpControllerObject first."
            return
        }
    }

    process {
        try {
            # If ConfigCommands is null or not a hashtable, initialize it as an empty hashtable
            if ($null -eq $script:RemotePro.ConfigCommands -or -not ($script:RemotePro.ConfigCommands -is [hashtable])) {
                $script:RemotePro.ConfigCommands = @{}

                Write-Verbose "Initialized ConfigCommands as a hashtable."
            }

            # Use appdata path if there is not a filepath value.
            if (-not ($ConfigFilePath)){
                $ConfigFilePath = Get-RPConfigPath
            }

            # Define config commands
            $script:RemotePro.ConfigCommands = Import-RpConfig -ConfigFilePath $ConfigFilePath

            # Attach a custom type to ConfigCommands
            $script:RemotePro.ConfigCommands.PSTypeNames.Insert(0, 'RemotePro.ConfigCommands')

            Write-Host "Config Commands have been successfully added to RemotePro.ConfigCommands."
        }
        catch {
            Write-Error "Error: $_"
        }
    }
    end {}
}
