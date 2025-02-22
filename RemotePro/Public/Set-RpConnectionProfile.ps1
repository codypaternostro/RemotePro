function Set-RpConnectionProfile {
    <#
    .SYNOPSIS
    Sets RemotePro connection profiles based on Excel file input.

    .DESCRIPTION
    The Set-RpConnectionProfile function manages RemotePro connection profiles.
    It can process profiles from an Excel file or create a blank template for
    profiles. It uses different parameter sets to handle these tasks.
    See link for MilestonePSTool's explanation of AppData usage.

    .COMPONENT
    ConnectionProfiles

    .PARAMETER ExcelFilePath
    Path to the Excel file. This file contains connection profiles or is the
    location where a new template will be created. Mandatory in both
    'ProcessProfiles' and 'CreateTemplate' parameter sets.

    .PARAMETER CreateTemplate
    Switch to create a blank Excel template. Includes columns necessary for
    defining connection profiles. Mandatory in 'CreateTemplate' parameter set.

    .EXAMPLE
    Set-RpConnectionProfile -ExcelFilePath "path\to\file.xlsx"
    # Processes connection profiles from the specified Excel file.

    .EXAMPLE
    Set-RpConnectionProfile -ExcelFilePath "path\to\template.xlsx" -CreateTemplate
    # Creates a blank template at the specified path for entering connection
    # profiles.

    .NOTES
    - Ensure the Excel file ends with .xlsx when creating a new template.
    - Profiles are validated and saved into the system upon processing.
    - Errors during the creation or processing of profiles are outputted as
    PowerShell errors.

    .LINK
    https://www.milestonepstools.com/commands/en-US/Connect-Vms/#description

    .LINK
    https://www.remotepro.dev/en-US/Set-RpConnectionProfile
    #>
    [CmdletBinding(DefaultParameterSetName = 'ProcessProfiles')]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'ProcessProfiles', HelpMessage = "Path to the Excel file containing connection profiles")]
        [Parameter(Mandatory = $true, ParameterSetName = 'CreateTemplate', HelpMessage = "Path to the Excel file to create a template")]
        [string]$ExcelFilePath,

        [Parameter(Mandatory = $true, ParameterSetName = 'CreateTemplate', HelpMessage = "Switch to create a blank Excel template")]
        [switch]$CreateTemplate
    )

    if ($PSCmdlet.ParameterSetName -eq 'CreateTemplate') {
        # Ensure the file path has a .xlsx extension
        if (-not $ExcelFilePath.EndsWith(".xlsx")) {
            $ExcelFilePath += ".xlsx"
        }

        # Create a blank Excel file with the necessary columns
        $blankData = @(
            [PSCustomObject]@{ProfileName = ""; ServerAddress = ""; Username = ""; Password = ""; BasicUser = $false; SecureOnly = $true; AcceptEula = $true; IncludeChildSites = $false; NoProfile = $false}
        )
        $blankData | Export-Excel -Path $ExcelFilePath -WorksheetName "Profiles" -AutoSize

        Write-Output "A blank Excel template has been created at $ExcelFilePath. Please fill it with your connection profile details."
        return
    }

    # Check if the Excel file exists
    if (-not (Test-Path -Path $ExcelFilePath)) {
        Write-Error "The specified Excel file does not exist. Use -CreateTemplate to create a blank template."
        return
    }

    # Import data from Excel
    $excelData = Import-Excel -Path $ExcelFilePath

    foreach ($row in $excelData) {
        [string]$profileName = $row.ProfileName
        [string]$serverAddress = $row.ServerAddress
        [string]$username = $row.Username
        [string]$password = $row.Password
        [bool]$basicUser = [bool][System.Convert]::ToBoolean($row.BasicUser)
        [bool]$secureOnly = [bool][System.Convert]::ToBoolean($row.SecureOnly)
        [bool]$acceptEula = [bool][System.Convert]::ToBoolean($row.AcceptEula)
        [bool]$includeChildSites = [bool][System.Convert]::ToBoolean($row.IncludeChildSites)
        [bool]$noProfile = [bool][System.Convert]::ToBoolean($row.NoProfile)

        # Prepend https:// or http:// to the ServerAddress based on the SecureOnly flag, if not already present
        if (-not $serverAddress.StartsWith("http://") -and -not $serverAddress.StartsWith("https://")) {
            if ($secureOnly) {
                $serverAddress = "https://$serverAddress"
            } else {
                $serverAddress = "http://$serverAddress"
            }
        }

        # Validate ServerAddress as an absolute URI
        if (-not [Uri]::TryCreate($serverAddress, [UriKind]::Absolute, [ref]$null)) {
            Write-Error "ServerAddress '$serverAddress' for profile '$profileName' is not a valid absolute URI."
            continue
        }

        # Convert password to a secure string
        $securePassword = ConvertTo-SecureString $password -AsPlainText -Force
        $credential = New-Object System.Management.Automation.PSCredential ($username, $securePassword)

        try {
            # Create connection profile with the parsed parameters
            $params = @{
                Name = $profileName
                ServerAddress = $serverAddress
                Credential = $credential
                SecureOnly = $secureOnly
                AcceptEula = $acceptEula
            }

            if ($basicUser) {
                $params.Add("BasicUser", $true)
            }

            if ($includeChildSites) {
                $params.Add("IncludeChildSites", $true)
            }

            if ($noProfile) {
                $params.Add("NoProfile", $true)
            }

            Connect-Vms @params

            # Save the connection profile
            Save-VmsConnectionProfile -Name $profileName -Force
            Write-Output "Profile '$profileName' created successfully."
        } catch {
            Write-Error "Failed to create profile '$profileName': $_"
        } finally {
            $securePassword = $null
            $password = $null
            $row.Password = $null
        }
    }
}
