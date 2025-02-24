function Set-RpDefaultConfigCommandIds {
    <#
    .SYNOPSIS
    Sets the default configuration command IDs for RemotePro.

    .DESCRIPTION
    The Set-RpDefaultConfigCommandIds function initializes and sets the default
    configuration command IDs for the RemotePro object. If the RemotePro object
    is not initialized, an error is thrown. The function can take an optional
    ConfigFilePath parameter to specify the path to the configuration file. If
    the ConfigFilePath is not provided, it uses the default path from
    Get-RpConfigPath.

    .COMPONENT
    DefaultConfigCommands

    .PARAMETER ConfigFilePath
    Optional. Specifies the path to the configuration file. If not provided,
    the default path is used.

    .EXAMPLE
    Set-RpDefaultConfigCommandIds -ConfigFilePath "$(Get-RpConfigPath -DefaultIds)"

    Initializes and sets the default configuration command IDs using the
    specified configuration file.

    .EXAMPLE
    Set-RpDefaultConfigCommandIds

    Initializes and sets the default configuration command IDs using the default
    configuration file path.

    .NOTES
    Ensure that the RemotePro object is initialized by running
    New-RpControllerObject before calling this function.

    .LINK
    https://www.remotepro.dev/en-US/Set-RpDefaultConfigCommandIds
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
            # If ConfigCommandDefaultIds is null or not a hashtable, initialize it as an empty hashtable
            if ($null -eq $script:RemotePro.ConfigCommandDefaultIds -or -not ($script:RemotePro.ConfigCommandDefaultIds -is [hashtable])) {
                $script:RemotePro.ConfigCommandDefaultIds = @{}

                Write-Verbose "Initialized ConfigCommandDefaultIds as a hashtable."
            }

            # Use appdata path if there is not a filepath value.
            if (-not ($ConfigFilePath)){
                $ConfigFilePath = Get-RpConfigPath -DefaultIds
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
