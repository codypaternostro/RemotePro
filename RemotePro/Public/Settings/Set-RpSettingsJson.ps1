function Set-RpSettingsJson {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [string]$SettingsFilePath
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
            # If Settings is null or not a hashtable, initialize it as an empty hashtable
            if ($null -eq $script:RemotePro.Settings -or -not ($script:RemotePro.Settings -is [hashtable])) {
                $script:RemotePro.Settings = @{}

                Write-Verbose "Initialized Settings as a hashtable."
            }

            # Use appdata path if there is not a filepath value.
            if (-not ($SettingsFilePath)){
                $SettingsFilePath = Get-RpSettingsJsonPath
            }

            # Define Settings commands
            $script:RemotePro.Settings = Import-RpSettingsJson -SettingsFilePath $SettingsFilePath

            # Attach a custom type to Settings
            $script:RemotePro.Settings.PSTypeNames.Insert(0, 'RemotePro.Settings')

            Write-Host "Settings have been successfully added to RemotePro.Settings."
        }
        catch {
            Write-Error "Error: $_"
        }
    }
    end {}
}
