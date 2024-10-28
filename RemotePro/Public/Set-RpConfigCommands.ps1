function Set-RpConfigCommands {
    [CmdletBinding()]
    param()

    # Ensure RemotePro object is initialized
    if (-not $script:RemotePro) {
        Write-Error "RemotePro object is not initialized. Run New-RpControllerObject first."
        return
    }

    # If ConfigCommands is null or not a hashtable, initialize it as an empty hashtable
    if ($null -eq $script:RemotePro.ConfigCommands -or -not ($script:RemotePro.ConfigCommands -is [hashtable])) {
        $script:RemotePro.ConfigCommands = @{}

        Write-Verbose "Initialized ConfigCommands as a hashtable."
    }

    # Test path for config commands.
    if (-not (Test-Path -Path $(Get-RpConfigPath))){
        Write-Error "Path error: $_"
    }
    else {
        # Define event handlers
        $script:RemotePro.ConfigCommands = Import-RpConfig -ConfigFilePath $(Get-RPConfigPath)

        # Attach a custom type to EventHandlers
        $script:RemotePro.ConfigCommands.PSTypeNames.Insert(0, 'RemotePro.ConfigCommands')

        Write-Host "Config Commands have been successfully added to RemotePro.ConfigCommands."
    }

}
