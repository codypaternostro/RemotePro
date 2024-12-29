function Set-RpConfigDefaults {
    # cmdlet to set the default configuration for RemotePro

    # ToDo: 11/28/24 add default configuration command entries with specific syntax
    # ToDo: 11/28/24 need to pass parameters to set-rprunspaceevents scriptblocks
    # ToDo: 11/28/24 add generic out-htmlview command to config file

    # Example
    #Add-RpConfigCommand -ModuleName "RemotePro" -ConfigFilePath "C:\Config.json" `
    #                    -CommandNames "Get-RpEventHandlers", "Set-RpConfig" `
    #                    -Description "Initial configuration export"


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
