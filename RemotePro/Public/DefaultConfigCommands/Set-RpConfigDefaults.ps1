function Set-RpConfigDefaults {
    <#
    .SYNOPSIS
    Sets the default configuration for RemotePro.

    .DESCRIPTION
    This cmdlet sets the default configuration values for the RemotePro
    application. It ensures that all necessary settings are initialized
    with their default values.

    .COMPONENT
    DefaultConfigCommands

    .PARAMETER ConfigFilePath
    The path to the configuration file where the default settings will
    be applied.

    .EXAMPLE
    Set-RpConfigDefaults -ConfigFilePath "C:\Config\RemoteProConfig.json"
    This example sets the default configuration values in the specified configuration file.

    .INPUTS
    [string] The path to the configuration file where the default settings will be applied.

    .OUTPUTS
    None. This cmdlet does not produce any output.

    .LINK
    https://www.remotepro.dev/en-US/Set-RpConfigDefaults

    #>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [string]$ConfigFilePath
    )

    begin {
        if (-not $ConfigFilePath) {
            if (-not (Test-Path -Path $(Get-RpConfigPath))){
                Write-Warning "No configuration file path provided. Using default configuration path."
                New-RpConfigCommandJson -Type EmptyJson
                $ConfigFilePath = Get-RpConfigPath
            }
        }
    }

    process {
        try {

            # cmdlet to set the default configuration for RemotePro

            # ToDo: 11/28/24 need to pass parameters to set-rprunspaceevents scriptblocks
            # ToDo: 11/28/24 add generic out-htmlview command to config file

            # Example
            #Add-RpConfigCommand -ModuleName "RemotePro" -ConfigFilePath "C:\Config.json" `
            #                    -CommandNames "Get-RpEventHandlers", "Set-RpConfig" `
            #                    -Description "Initial configuration export"

            #region add default commands
            $defaultCommands = [PSCustomObject]@{}
            $defaultCommandIds = [PSCustomObject]@{}

            $RemoteProCmds = ((Add-RpConfigCommand -ModuleName "RemotePro" -ConfigFilePath (Get-RpConfigPath) `
                            -CommandNames "Show-RpCamera", "Get-RpTicketBlock", "Select-VideoOSItem", "Get-RpVmsHardwareCustom", "Get-RpVmsItemStateCustom" `
                            -Description "Initial configuration export"))

            $PSWriteHTMLCmds = ((Add-RpConfigCommand -ModuleName "PSWriteHTML" -ConfigFilePath (Get-RpConfigPath) `
                            -CommandNames "Out-HtmlView" `
                            -Description "Initial configuration export"))

            $MilestonePSToolsCmds = ((Add-RpConfigCommand -ModuleName "MilestonePSTools" -ConfigFilePath (Get-RpConfigPath) `
                            -CommandNames "Get-VmsCameraReport", "Select-VideoOSItem" `
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
                $commandName = "Out-HtmlView"
                $moduleName = "PSWriteHTML"

                $commandId = ($defaultCommands.$moduleName | Where-Object -FilterScript {$_.CommandName -like "$commandName"}).Id
                $defaultCommandIds | Add-Member -MemberType NoteProperty -Name "$commandName" -Value "$commandId"

                $params = @{
                    "EnableScroller" = $true
                    "ScrollX" = $true
                    "AlphabetSearch" = $true
                    "SearchPane" = $true
                }

                $defaultCommands.PSWriteHTML | Where-Object -FilterScript {$_.commandname -like "$commandName"} |
                    Update-RpConfigCommand -Parameters $params -Id $commandId -Verbose
            #endregion

            #region CamReport_Click
                #Get-VmsCameraReport
                $commandName = "Get-VmsCameraReport"
                $moduleName = "MilestonePSTools"

                $commandId = ($defaultCommands.$moduleName | Where-Object -FilterScript {$_.CommandName -like "$commandName"}).Id
                $defaultCommandIds | Add-Member -MemberType NoteProperty -Name "$commandName" -Value $commandId

                $defaultCommands.MilestonePSTools | Where-Object -FilterScript {$_.commandname -like "$commandName"} |
                    Update-RpConfigCommand -Id $commandId -Verbose
            #endregion


            #region ShowCameras_Click
                # command 1
                #Show-RpCamera -CameraObject $platformItemcameras -SpecifiedDaysForSequences 7 -DiagnosticLevel 3
                $commandName = "Show-RpCamera"
                $moduleName = "RemotePro"

                $commandId = ($defaultCommands.$moduleName | Where-Object -FilterScript {$_.CommandName -like "$commandName"}).Id
                $defaultCommandIds | Add-Member -MemberType NoteProperty -Name "$commandName" -Value "$commandId"

                $params = @{
                    "CameraObject" = "`$platformItemcameras"
                    "SpecifiedDaysForSequences" = "7"
                    "DiagnosticLevel" = "3"
                }

                $defaultCommands.RemotePro | Where-Object -FilterScript {$_.commandname -like "$commandName"} |
                    Update-RpConfigCommand -Parameters $params -Id $commandId -Verbose

                # command 2
                #Get-RpTicketBlock -Cameras $configItemCams -ShowWindow

            #region TicketBlock_Click
                #Get-RpTicketBlock -Cameras $platformItemcameras -ShowWindow
                $commandName = "Get-RpTicketBlock"
                $moduleName = "RemotePro"

                $commandId = ($defaultCommands.$moduleName | Where-Object -FilterScript {$_.CommandName -like "$commandName"}).Id
                $defaultCommandIds | Add-Member -MemberType NoteProperty -Name "$commandName" -Value "$commandId"

                $params = @{
                    "Cameras" = "`$configItemCams"
                    "ShowWindow" = $true
                }

                $defaultCommands.RemotePro | Where-Object -FilterScript {$_.commandname -like "$commandName"} |
                    Update-RpConfigCommand -Parameters $params -Id $commandId -Verbose
            #endregion

            #region ShowVideoOSItems_Click
                #Select-VideoOSItem
                # Note: Might be some more entries to add here for modifiable commands
                $commandName = "Select-VideoOSItem"
                $moduleName = "MilestonePSTools"

                $commandId = ($defaultCommands.$moduleName | Where-Object -FilterScript {$_.CommandName -like "$commandName"}).Id
                $defaultCommandIds | Add-Member -MemberType NoteProperty -Name "$commandName" -Value "$commandId"

                $defaultCommands.RemotePro | Where-Object -FilterScript {$_.commandname -like "$commandName"} |
                    Update-RpConfigCommand -Id $commandId -Verbose
            #endregion

            #region Hardware_Click
                #Get-RpVmsHardwareCustom -CheckConnection
                $commandName = "Get-RpVmsHardwareCustom"
                $moduleName = "RemotePro"

                $commandId = ($defaultCommands.$moduleName | Where-Object -FilterScript {$_.CommandName -like "$commandName"}).Id
                $defaultCommandIds | Add-Member -MemberType NoteProperty -Name "$commandName" -Value "$commandId"

                $params = @{
                    "CheckConnection" = $true
                }

                $defaultCommands.RemotePro | Where-Object -FilterScript {$_.commandname -like "$commandName"} |
                    Update-RpConfigCommand -Parameters $params -Id $commandId -Verbose
            #endregion

            #region ItemState_Click
                #Get-RpVmsItemStateCustom -CheckConnection
                $commandName = "Get-RpVmsItemStateCustom"
                $moduleName = "RemotePro"

                $commandId = ($defaultCommands.$moduleName | Where-Object -FilterScript {$_.CommandName -like "$commandName"}).Id
                $defaultCommandIds | Add-Member -MemberType NoteProperty -Name "$commandName" -Value "$commandId"

                $params = @{
                    "CheckConnection" = $true
                }

                $defaultCommands.RemotePro | Where-Object -FilterScript {$_.commandname -like "$commandName"} |
                    Update-RpConfigCommand -Parameters $params -Id $commandId -Verbose
            #endregion

            Set-RpConfigCommands # Update RpControllerObject with added commands.

            return $defaultCommandIds
            #endregion
        }
        catch {
            Write-Error "An error occurred while setting the default configuration: $($_.exception.message)"
        }
    }
    end {}
}
