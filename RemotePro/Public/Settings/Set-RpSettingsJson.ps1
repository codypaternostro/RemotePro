function Set-RpSettingsJson {
    <#
    .SYNOPSIS
    Sets the RemotePro settings from a JSON file.

    .DESCRIPTION
    The Set-RpSettingsJson function initializes the RemotePro settings from a JSON
    file. If the RemotePro object is not initialized, it throws an error. If the
    settings are not a hashtable, it initializes them as an empty hashtable. It
    imports the settings from the specified JSON file or from the default appdata
    path if no file path is provided. The settings are then attached to the
    RemotePro object with a custom type.

    .COMPONENT
    Settings

    .PARAMETER SettingsFilePath
    The path to the JSON file containing the settings. If not provided, the default
    appdata path is used.

    .EXAMPLE
    Set-RpSettingsJson -SettingsFilePath "C:\path\to\settings.json"
    This command sets the RemotePro settings from the specified JSON file.

    .INPUTS
    [string] The path to the settings JSON file where the default settings will be applied.

    .NOTES
    Ensure that the RemotePro object is initialized by running New-RpControllerObject
    before calling this function.
    #>
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
            $script:RemotePro.Settings = Import-RpSettingsFromJson -SettingsFilePath $SettingsFilePath

            # Attach a custom type to Settings
            $script:RemotePro.Settings.PSTypeNames.Insert(0, 'RemotePro.Settings')

            Write-Host "Settings have been successfully added to RemotePro.Settings."
        }
        catch {
            Write-Error "Error occured while setting json to RemoteProController object: $($_.Exception.Message)"
        }
    }
    end {}
}
