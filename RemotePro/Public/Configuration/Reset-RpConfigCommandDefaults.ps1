
function Reset-RpConfigCommandDefaults {
    <#
    .SYNOPSIS
        Resets the RemotePro configuration to default values.

    .DESCRIPTION
        This function removes existing configuration files and creates new default configuration files for RemotePro.

    .EXAMPLE
        Reset-RpConfigCommandDefaults

    #>
    [CmdletBinding()]
    param()

    process {
        try {
            # Remove the configuration files
            if (Test-Path -Path (Get-RpConfigPath)){
                Remove-Item -Path (Get-RpConfigPath)
            }

            if (Test-Path -Path (Get-RpConfigPath -DefaultIds)){
                Remove-Item -Path (Get-RpConfigPath -DefaultIds)
            }

            if (-not (Test-Path -Path $(Get-RpConfigPath))){
                New-RpConfigCommandJson -Type DefaultJson
            }

            Set-RpConfigCommands    #Populate ConfigCommands

        }
        catch {
            Write-Error $_.Exception.Message
        }
    }
    end {}
}
