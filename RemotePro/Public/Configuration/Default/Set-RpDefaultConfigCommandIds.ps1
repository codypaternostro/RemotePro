function Set-RpDefaultConfigCommandIds {
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
            # If ConfigCommandDefaultIds is null or not a hashtable, initialize it as an empty hashtable
            if ($null -eq $script:RemotePro.ConfigCommandDefaultIds -or -not ($script:RemotePro.ConfigCommandDefaultIds -is [hashtable])) {
                $script:RemotePro.ConfigCommandDefaultIds = @{}

                Write-Verbose "Initialized ConfigCommandDefaultIds as a hashtable."
            }

            # Use appdata path if there is not a filepath value.
            if (-not ($ConfigFilePath)){
                $ConfigFilePath = Get-RPConfigPath -defaultIds
            }

            # Define config command default ids
            $script:RemotePro.ConfigCommandDefaultIds = Import-RpDefaultConfigCommandIds -ConfigFilePath $ConfigFilePath

            # Attach a custom type to ConfigCommandDefaultIds
            $script:RemotePro.ConfigCommandDefaultIds.PSTypeNames.Insert(0, 'RemotePro.ConfigCommandDefaultIds')

            Write-Host "Config Command Default Ids have been successfully added to RemotePro.ConfigCommandDefaultIds."
        }
        catch {
            Write-Error "Error: $_"
        }
    }
    end {}
}
