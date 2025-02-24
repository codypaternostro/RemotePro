function New-RpConfigCommandJson {
    <#
    .SYNOPSIS
    Creates a new configuration JSON file for RemotePro.

    .DESCRIPTION
    The New-RpConfigCommandJson function creates a new configuration JSON file
    based on the specified type. It supports creating a default JSON configuration
    or an empty JSON configuration. The function also allows specifying a custom
    path for the configuration file, defaulting to the application data location
    if not provided.

    .COMPONENT
    ConfigCommands

    .PARAMETER Type
    Specifies the type of JSON to be created. Valid values are "DefaultJson" and
    "EmptyJson". This parameter is mandatory.

    .PARAMETER ConfigFilePath
    Specifies the path where the configuration file will be saved. If not provided,
    the default application data location is used.

    .EXAMPLE
    New-RpConfigCommandJson -Type "DefaultJson"

    Creates a default JSON configuration file at the default application data
    location.

    .EXAMPLE
    New-RpConfigCommandJson -Type "EmptyJson" -ConfigFilePath (Get-RpConfigPath)

    Creates an empty JSON configuration file at the default application path.
    This is the default path if one is specified using ConfigFilePath parameter.

    .EXAMPLE
    New-RpConfigCommandJson -Type "EmptyJson" -ConfigFilePath "C:\Config\config.json"

    Creates an empty JSON configuration file at the specified path.

    .LINK
    https://www.remotepro.dev/en-US/New-RpConfigCommandJson
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateSet("DefaultJson","EmptyJson")]
        [string]$Type,

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
