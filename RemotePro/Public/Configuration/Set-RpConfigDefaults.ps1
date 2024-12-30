function Set-RpConfigDefaults {
    # cmdlet to set the default configuration for RemotePro

    # ToDo: 11/28/24 add default configuration command entries with specific syntax
    # ToDo: 11/28/24 need to pass parameters to set-rprunspaceevents scriptblocks
    # ToDo: 11/28/24 add generic out-htmlview command to config file

    # Example
    #Add-RpConfigCommand -ModuleName "RemotePro" -ConfigFilePath "C:\Config.json" `
    #                    -CommandNames "Get-RpEventHandlers", "Set-RpConfig" `
    #                    -Description "Initial configuration export"

    $defaultCommands = [PSCustomObject]@{}

    $RemoteProCmds = ((Add-RpConfigCommand -ModuleName "RemotePro" -ConfigFilePath (Get-RpConfigPath) `
                    -CommandNames "Show-RpCamera", "Get-RpTicketBlock", "Select-VideoOSItem", "Get-RpVmsHardwareCustom", "Get-RpVmsItemStateCustom" `
                    -Description "Initial configuration export"))

    $PSWriteHTMLCmds = ((Add-RpConfigCommand -ModuleName "PSWriteHTML" -ConfigFilePath (Get-RpConfigPath) `
                    -CommandNames "Out-HtmlView" `
                    -Description "Initial configuration export"))

    $MilestonePSToolsCmds = ((Add-RpConfigCommand -ModuleName "MilestonePSTools" -ConfigFilePath (Get-RpConfigPath) `
                    -CommandNames "Get-VmsCameraReport" `
                    -Description "Initial configuration export"))


    $defaultCommands | Add-Member -MemberType NoteProperty -Name "RemotePro" -Value $RemoteProCmds
    $defaultCommands | Add-Member -MemberType NoteProperty -Name "PSWriteHTML" -Value $PSWriteHTMLCmds
    $defaultCommands | Add-Member -MemberType NoteProperty -Name "MilestonePSTools" -Value $MilestonePSToolsCmds

    $params = @{
        "CameraObject" = "`$platformItemcameras"
        "SpecifiedDaysForSequences" = "7"
        "DiagnosticLevel" = "3"
    }

    $defaultCommands.remotepro | Where-Object -FilterScript {$_.commandname -like "Show-RpCamera"} |
        Update-RpConfigCommand -Parameters $params -Verbose

    #Out-HtmlView
        #Out-HtmlView -EnableScroller -ScrollX -AlphabetSearch -SearchPane

    #CamReport_Click
        #Get-VmsCameraReport | Out-HtmlView -EnableScroller -ScrollX -AlphabetSearch -SearchPane

    #ShowCameras_Click
        # command 1
        #Show-RpCamera -CameraObject $platformItemcameras -SpecifiedDaysForSequences 7 -DiagnosticLevel 3 | Out-Null

        # command 2
        #Get-RpTicketBlock -Cameras $configItemCams -ShowWindow

    #TicketBlock_Click
        #Get-RpTicketBlock -Cameras $platformItemcameras -ShowWindow

    #ShowVideoOSItems_Click
        #Select-VideoOSItem
        # might be some more entries to add here for modifiable commands

    #Hardware_Click
        #Get-RpVmsHardwareCustom -CheckConnection

    #ItemState_Click
        #Get-RpVmsItemStateCustom -CheckConnection
}
