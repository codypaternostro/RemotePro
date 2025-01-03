function New-RpConfigCommandJson {
    [CmdletBinding()]
    param (
        # Specify type of json to be created.
        [Parameter(Mandatory=$true)]
        [ValidateSet("DefaultJson","EmptyJson")]
        [string]$Type,

        # Specify path, default is appdata location.
        [Parameter(Mandatory=$false)]
        [string]$ConfigFilePath
    )

    if (-not ($ConfigFilePath)){
        $ConfigFilePath = Get-RpConfigPath
    }

    # Main object for configcommands.
    $config = [pscustomobject]@{ ConfigCommands = @{} }

    $saveConfig = {
        param([pscustomobject]$config,[string]$ConfigFilePath)
        # Convert updated configuration back to JSON and save
        $jsonConfig = $config | ConvertTo-Json -Depth 4
        if ($configFilePath) {
            Set-Content -Path $ConfigFilePath -Value $jsonConfig
            return Write-Verbose "Configuration for module '$ModuleName' saved to $ConfigFilePath"
        } else {
            return Write-Verbose "Error: ConfigFilePath is empty. Unable to save configuration."
        }
    }

    switch($type){
        "DefaultJson"{
            Invoke-Command $saveConfig -ArgumentList @($config,$configFilePath)

            # Add default command Ids to seperate configuration file
            $configCommandIds = Set-RpConfigDefaults
            Invoke-Command $saveConfig -ArgumentList @($configCommandIds,(Get-RpConfigPath -DefaultIds))

        }
        "EmptyJson" {
            Invoke-Command $saveConfig -ArgumentList @($config,$configFilePath)
        }
    }
}
