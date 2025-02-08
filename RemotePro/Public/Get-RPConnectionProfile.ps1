function Get-RpConnectionProfile {
    <#
    .SYNOPSIS
    Retrieves and displays RemotePro connection profiles or the credentials XML.

    .DESCRIPTION
    The Get-RpConnectionProfile function retrieves connection profiles based on
    the provided parameters. It can either show all profiles, a specific profile
    by name, or open the credentials XML file for direct viewing.

    .COMPONENT
    ConnectionProfiles

    .PARAMETER Name
    The name of the connection profile to retrieve. Used when the user wants to
    view a specific profile. Only valid in the 'ViewProfiles' parameter set.

    .PARAMETER All
    A switch that when specified, retrieves and displays all connection profiles.
    Only valid in the 'ViewProfiles' parameter set.

    .PARAMETER ViewXml
    A switch to open the credentials XML file directly. This is the only option
    in the 'ViewXml' parameter set.

    .EXAMPLE
    Get-RpConnectionProfile -All
    # Displays all available RemotePro connection profiles.

    .EXAMPLE
    Get-RpConnectionProfile -Name "ProfileName"
    # Retrieves and displays the connection profile named "ProfileName".

    .EXAMPLE
    Get-RpConnectionProfile -ViewXml
    # Opens the credentials XML file associated with RemotePro connection
    profiles for direct viewing.

    .NOTES
    - This function is part of the RemotePro PowerShell module and interacts
    with video management systems.
    - The credentials.xml file contains sensitive information; handle with care.
    #>
    [CmdletBinding(DefaultParameterSetName = 'ViewProfiles')]
    param (
        [Parameter(ParameterSetName = 'ViewProfiles')]
        [string]$Name,

        [Parameter(ParameterSetName = 'ViewProfiles')]
        [switch]$All,

        [Parameter(ParameterSetName = 'ViewXml')]
        [switch]$ViewXml
    )

    switch ($PSCmdlet.ParameterSetName) {
        'ViewXml' {
            $credentialsPath = Join-Path $env:LOCALAPPDATA "MilestonePSTools\credentials.xml"
            if (-not (Test-Path -Path $credentialsPath)) {
                Write-Error "The credentials.xml file does not exist at $credentialsPath."
                return
            }
            Start-Process $credentialsPath
            return
        }

        'ViewProfiles' {
            if ($Name) {
                # Retrieve and display the specific profile using Get-VmsConnectionProfile
                Get-VmsConnectionProfile  -Name $Name
            } elseif ($All) {
                # Retrieve and display all profiles using Get-VmsConnectionProfile
                Get-VmsConnectionProfile -All
            } else {
                Write-Error "Please specify either -Name or -All to view the profiles."
            }
        }
    }
}

# Example usage
# To view all connection profiles
# Get-RpConnectionProfile -All

# To view a specific profile
# Get-RpConnectionProfile -Name "ProfileName"

# To open the XML file only
# Get-RpConnectionProfile -ViewXml
