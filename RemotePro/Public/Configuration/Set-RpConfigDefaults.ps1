function Set-RpConfigDefaults {
    <#
    .SYNOPSIS
        Sets the default configuration for RemotePro.

    .DESCRIPTION
        This cmdlet sets the default configuration values for the RemotePro application. It ensures that all necessary settings are initialized with their default values.

    .PARAMETER ConfigFilePath
        The path to the configuration file where the default settings will be applied.

    .EXAMPLE
        PS C:\> Set-RpConfigDefaults -ConfigFilePath "C:\Config\RemoteProConfig.json"
        This example sets the default configuration values in the specified configuration file.

    .INPUTS
        [string] The path to the configuration file where the default settings will be applied.

    .OUTPUTS
        None. This cmdlet does not produce any output.

    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ConfigFilePath
    )
    # cmdlet to set the default configuration for RemotePro

    # ToDo: 11/28/24 add default configuration command entries with specific syntax
    # ToDo: 11/28/24 need to pass parameters to set-rprunspaceevents scriptblocks
    # ToDo: 11/28/24 add generic out-htmlview command to config file

    # Example
    #Add-RpConfigCommand -ModuleName "RemotePro" -ConfigFilePath "C:\Config.json" `
    #                    -CommandNames "Get-RpEventHandlers", "Set-RpConfig" `
    #                    -Description "Initial configuration export"

    #region add default commands
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
    #endregion

    #region add runspace commands defaults to config file
    # Explanation: The following command will be add to RemoteProParamConfig.json file.
    # Stored in the RemotePro local appdata folder, and can be imported into a working object
    # using the Import-RpConfig function. The module itself using the RemoteProController
    # created using "$script:RemotePro = New-RpControllerObject" in the RemotePro.psm1 file.

    #region Out-HtmlView
        #Out-HtmlView -EnableScroller -ScrollX -AlphabetSearch -SearchPane
        $params = @{
            "EnableScroller" = $true
            "ScrollX" = $true
            "AlphabetSearch" = $true
            "SearchPane" = $true
        }

        $defaultCommands.PSWriteHTML | Where-Object -FilterScript {$_.commandname -like "Out-HtmlView"} |
            Update-RpConfigCommand -Parameters $params -Verbose

    #endregion

    #region CamReport_Click
        #Get-VmsCameraReport
        $params = @{

        }

        $defaultCommands.MilestonePSTools | Where-Object -FilterScript {$_.commandname -like "Get-VmsCameraReport"} |
            Update-RpConfigCommand -Parameters $params -Verbose
    #endregion


    #region ShowCameras_Click
        # command 1
        #Show-RpCamera -CameraObject $platformItemcameras -SpecifiedDaysForSequences 7 -DiagnosticLevel 3
        $params = @{
            "CameraObject" = "`$platformItemcameras"
            "SpecifiedDaysForSequences" = "7"
            "DiagnosticLevel" = "3"
        }

        $defaultCommands.remotepro | Where-Object -FilterScript {$_.commandname -like "Show-RpCamera"} |
            Update-RpConfigCommand -Parameters $params -Verbose

        # command 2
        #Get-RpTicketBlock -Cameras $configItemCams -ShowWindow

    #region TicketBlock_Click
        #Get-RpTicketBlock -Cameras $platformItemcameras -ShowWindow
        $params = @{
            "Cameras" = "`$configItemCams"
            "ShowWindow" = $true
        }

        $defaultCommands.remotepro | Where-Object -FilterScript {$_.commandname -like "Get-RpTicketBlock"} |
            Update-RpConfigCommand -Parameters $params -Verbose
    #endregion

    #region ShowVideoOSItems_Click
        #Select-VideoOSItem
        # Note: Might be some more entries to add here for modifiable commands
        $defaultCommands.remotepro | Where-Object -FilterScript {$_.commandname -like "Select-VideoOSItem"} |
            Update-RpConfigCommand -Verbose
    #endregion

    #region Hardware_Click
        #Get-RpVmsHardwareCustom -CheckConnection
        $params = @{
            "CheckConnection" = $true
        }

        $defaultCommands.remotepro | Where-Object -FilterScript {$_.commandname -like "Get-RpVmsHardwareCustom"} |
            Update-RpConfigCommand -Parameters $params -Verbose
    #endregion

    #region ItemState_Click
        #Get-RpVmsItemStateCustom -CheckConnection
        $params = @{
            "CheckConnection" = $true
        }

        $defaultCommands.remotepro | Where-Object -FilterScript {$_.commandname -like "Get-RpVmsItemStateCustom"} |
            Update-RpConfigCommand -Parameters $params -Verbose
    #endregion
    #endregion
}
