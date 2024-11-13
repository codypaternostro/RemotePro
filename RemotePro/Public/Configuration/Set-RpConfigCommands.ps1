function Set-RpConfigCommands {
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

            # Define event handlers
            $script:RemotePro.ConfigCommands = Import-RpConfig -ConfigFilePath $ConfigFilePath

            # Attach a custom type to EventHandlers
            $script:RemotePro.ConfigCommands.PSTypeNames.Insert(0, 'RemotePro.ConfigCommands')

            Write-Host "Config Commands have been successfully added to RemotePro.ConfigCommands."
        }
        catch {
            Write-Error "Error: $_"
        }
    }
    end {}
}
