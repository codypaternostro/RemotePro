function Get-RpVmsHardwareCustom {
    <#
    .SYNOPSIS
    Retrieves and displays the hardware settings of VMS items with optional
    connection validation and credentials inclusion.

    .DESCRIPTION
    This function retrieves the hardware settings of VMS items and displays the
    results in an HTML view.
    It also provides optional parameters to validate the connection before
    processing and to include credentials in the output.

    .COMPONENT
    CustomVMSCmdlets

    .PARAMETER CheckConnection
    Validates the VMS connection before processing the items.
    If the connection is not valid, the function will display an error message
    and exit early.

    .PARAMETER IncludeCredentials
    Includes the username and password in the output for each hardware item.

    .EXAMPLE
    Get-RpVmsHardwareCustom -CheckConnection

    This example validates the VMS connection before retrieving and
    displaying the hardware settings of the items.

    .EXAMPLE
    Get-RpVmsHardwareCustom -IncludeCredentials

    This example retrieves and displays the hardware settings of the items,
    including the username and password for each item.

    .LINK
    https://www.remotepro.dev/en-US/Get-RpVmsHardwareCustom
    #>
    [CmdletBinding(DefaultParameterSetName='NoConnectionCheck')]
    param(
        [Parameter(Mandatory=$false, ParameterSetName='ConnectionCheck')]
        [switch]$CheckConnection,

        [Parameter(Mandatory=$false)]
        [switch]$IncludeCredentials
    )

    begin {
        Import-Module -Name RemotePro


        Add-Type -AssemblyName PresentationFramework
        $connectionValid = $true

        if ($CheckConnection) {
            if (-not (Test-RpVmsConnection -ShowErrorDialog $true)) {
                $connectionValid = $false
            }
        }
    }

    process {
        if (-not $connectionValid) {
            Write-Host "Connection validation failed. No VMS connection available."
            return
        }

        $hardwareSettings = @{} # switched from hashtable to array.
        $recordingServer = Get-VmsRecordingServer -Verbose | ForEach-Object {
            $recordingServer = $_
            $recordingServer | Get-VmsHardware -Verbose | ForEach-Object {
                $hardware = $_
                #$hardwareSettings[$hardware.Id] = $hardware | Get-HardwareSetting -Verbose
                $username = $hardware.username
                $password = $hardware | Get-VmsHardwarePassword

                #$name = $(Get-PlatformItem -Id $hardware.Id)  | Select-Object -Property Name -ExpandProperty Name
                $platformItem = $(Get-PlatformItem -Id $hardware.Id)
                $name = $platformItem | Select-Object -Property Name -ExpandProperty Name

                $ip = $Hardware.address -replace '^http://', '' -replace ':8000/$', ''

                #$hardwareSettings[$hardware.RecorderName] = $recordingServer.Name
                $hardwareSettings[$hardware.Id] = $hardware | Get-HardwareSetting -Verbose
                $hardwareSettings[$hardware.Id] | Add-Member -MemberType NoteProperty -Name Id -Value $hardware.Id
                $hardwareSettings[$hardware.Id] | Add-Member -MemberType NoteProperty -Name RecorderName -Value $recordingServer.Name
                $hardwareSettings[$hardware.Id] | Add-Member -MemberType NoteProperty -Name HardwareName -Value $name
                $hardwareSettings[$hardware.Id] | Add-Member -MemberType NoteProperty -Name IpAddress -Value $Ip
                $hardwareSettings[$hardware.Id] | Add-Member -MemberType NoteProperty -Name Name -Value $name

                if ($IncludeCredentials) {
                    $hardwareSettings[$hardware.Id] | Add-Member -MemberType NoteProperty -Name Username -Value $username
                    $hardwareSettings[$hardware.Id] | Add-Member -MemberType NoteProperty -Name Password -Value $password
                }

            }
        }


        #ToDo: Build parameter for selecting properties to display.
        # - Create option for WPF window to select properties to display.
        # - Create option to cache the selected properties for future use.

        return $hardwareSettings.Values
    }
}
