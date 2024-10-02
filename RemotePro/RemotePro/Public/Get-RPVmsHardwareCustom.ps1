function Get-RPVmsHardwareCustom {
    <#
    .SYNOPSIS
    Retrieves and displays the hardware settings of VMS items with optional connection validation.

    .DESCRIPTION
    This function retrieves the hardware settings of VMS items and displays the results in an HTML view.
    It also provides an optional parameter to validate the connection before processing.

    .PARAMETER CheckConnection
    Validates the VMS connection before processing the items.
    If the connection is not valid, the function will display an error message and exit early.

    .EXAMPLE
    Get-RPVmsHardwareCustom -CheckConnection

    This example validates the VMS connection before retrieving and displaying the hardware settings of the items.
    #>
    [CmdletBinding(DefaultParameterSetName='NoConnectionCheck')]
    param(
        [Parameter(Mandatory=$false, ParameterSetName='ConnectionCheck')]
        [switch]$CheckConnection
    )

    begin {
        import-module C:\RemotePro\RemotePro\RemotePro.psd1
        Add-Type -AssemblyName PresentationFramework
        $connectionValid = $true

        if ($CheckConnection) {
            if (-not (Test-RPVmsConnection -ShowErrorDialog $true)) {
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

                $name =     Get-PlatformItem -Id $hardware.Id  | Select-Object -Property Name -ExpandProperty Name


                $ip = $Hardware.address -replace '^http://', '' -replace ':8000/$', ''



                #$hardwareSettings[$hardware.RecorderName] = $recordingServer.Name
                $hardwareSettings[$hardware.Id] = $hardware | Get-HardwareSetting -Verbose
                $hardwareSettings[$hardware.Id] | Add-Member -MemberType NoteProperty -Name Id -Value $hardware.Id
                $hardwareSettings[$hardware.Id] | Add-Member -MemberType NoteProperty -Name RecorderName -Value $recordingServer.Name
                $hardwareSettings[$hardware.Id] | Add-Member -MemberType NoteProperty -Name Username -Value $username
                $hardwareSettings[$hardware.Id] | Add-Member -MemberType NoteProperty -Name Password -Value $password
                $hardwareSettings[$hardware.Id] | Add-Member -MemberType NoteProperty -Name HardwareName -Value $name
                $hardwareSettings[$hardware.Id] | Add-Member -MemberType NoteProperty -Name IpAddress -Value $Ip
                $hardwareSettings[$hardware.Id] | Add-Member -MemberType NoteProperty -Name Name -Value $name

            }
        }
        $hardwareResults= $hardwareSettings.Values

        $hardwareResults | Select-Object RecorderName,DetectedModelName, Name, IpAddress, MacAddress, SerialNumber, Username, Password |  Out-HtmlView -EnableScroller -ScrollX -AlphabetSearch -SearchPane  -Title "HardwareReportRefined $($timestamp)"

        return $hardwareResults
    }
}
