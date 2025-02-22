function Import-RpDefaultConfigCommandIds {
    <#
    .SYNOPSIS
    Imports default configuration command IDs from a specified JSON file.

    .DESCRIPTION
    This function loads a JSON configuration file containing command IDs,
    parses it, and returns a hashtable-like object where each command name
    is a top-level key and contains a nested object with its Id.

    .COMPONENT
    DefaultConfigCommands

    .PARAMETER ConfigFilePath
    The path to the JSON configuration file. If not provided, the function
    attempts to retrieve the default path.

    .RETURNS
    A hashtable-like object where each key is the CommandName and its value
    is a nested object containing an Id.

    .EXAMPLE
    Import-RpDefaultConfigCommandIds -ConfigFilePath $(Get-RpConfigPath -DefaultIds)

    .LINK
    https://www.remotepro.dev/en-US/Import-RpDefaultConfigCommandIds
    #>
    [CmdletBinding()]
    param (
        [string]$ConfigFilePath
    )

    process {
        if (-not ($ConfigFilePath)) {
            Write-Verbose "No ConfigFilePath provided. Attempting to retrieve default path."
            $ConfigFilePath = Get-RpConfigPath -DefaultIds
        }

        if (-not (Test-Path -Path $ConfigFilePath)) {
            throw "The configuration file does not exist at path: $ConfigFilePath"
        }

        Write-Verbose "Loading configuration content from: $ConfigFilePath"

        try {
            $configContent = Get-Content -Path $ConfigFilePath -Raw
            Write-Verbose "Config content successfully loaded."
        } catch {
            throw "Failed to load configuration file. Error: $_"
        }

        try {
            $defaultCommandsWithId = $configContent | ConvertFrom-Json
            Write-Verbose "Config successfully converted from JSON."
        } catch {
            throw "Failed to parse JSON content. Error: $_"
        }

        # Build the final object with command names as top-level properties
        $defaultCommands = @{}
        $defaultCommands.PSObject.TypeNames.Insert(0,"DefaultConfigCommands")
        foreach ($property in $defaultCommandsWithId.PSObject.Properties) {
            $defaultCommands[$property.Name] = [PSCustomObject]@{
                Id = $property.Value
            }
        }

        Write-Verbose "Command list successfully processed."
        return $defaultCommands
    }
}
