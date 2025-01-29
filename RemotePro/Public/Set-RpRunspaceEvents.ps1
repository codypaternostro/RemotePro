function Set-RpRunspaceEvents {
    <#
    .SYNOPSIS
    Initializes and populates the RunspaceEvents property of the RemotePro
    object with predefined event handlers.

    .DESCRIPTION
    The Set-RpRunspaceEvents cmdlet sets up event handlers for specific
    operations in the RemotePro environment. These handlers are stored in
    the RunspaceEvents property, a hashtable allowing fast lookup and
    execution of event-specific scripts.

    Each handler is linked to an event (e.g., button clicks or UI actions)
    and defines the actions triggered by the event. If RunspaceEvents does
    not exist, it is initialized as an empty hashtable. The event handlers
    are then added as key-value pairs where the key is the event name and
    the value is the scriptblock.

    Additionally, the hashtable is assigned a custom type
    'RemotePro.RunspaceEvents' for identification and future use.

    .PARAMETER None
    This cmdlet does not accept parameters. It initializes and sets up
    event handlers for the RemotePro environment.

    .EXAMPLE
    Set-RpRunspaceEvents

    This example initializes the RunspaceEvents hashtable and adds event
    handlers to it, associating each event with its respective scriptblock
    to handle user actions.

    .EXAMPLE
    Set-RpRunspaceEvents
    $events = Get-RpRunspaceEvents -All
    $events["CamReport_Click"]

    This example sets up the event handlers, retrieves all RunspaceEvents,
    and fetches the handler for the "CamReport_Click" event.

    .EXAMPLE
    Set-RpRunspaceEvents
    $handler = Get-RpRunspaceEvents -Name "ShowCameras_Click"
    & $handler

    This example sets up the event handlers, retrieves the scriptblock for
    "ShowCameras_Click", and invokes the scriptblock.

    .NOTES
    - The RunspaceEvents hashtable is part of the RemotePro object and
      should be initialized with New-RpControllerObject before running
      this cmdlet.
    - This cmdlet does not return output unless errors occur during
      initialization or event assignment.
    - Event handlers are defined as scriptblocks and can be invoked
      based on user interactions.
    - See New-RpControllerObject and Get-RpRunspaceEvents

    .LINK
    #>
    try {
        # Ensure RemotePro object is initialized
        if (-not $script:RemotePro) {
            Write-Error "RemotePro object is not initialized. Run New-RpControllerObject first."
            return
        }

        # If RunspaceEvents is null or not a hashtable, initialize it as an empty hashtable
        if ($null -eq $script:RemotePro.RunspaceEvents -or -not ($script:RemotePro.RunspaceEvents -is [hashtable])) {
            $script:RemotePro.RunspaceEvents = @{}

            Write-Host "Initialized RunspaceEvents as a hashtable."
        }

        # Define runspace events
        $handlers = @{
            CamReport_Click = {
                Write-Verbose "Accessing Runspace: $($script:RpOpenRunspaces.Jobs.Runspace.Runspace.InstanceId)"
                # TODO: add a warning or please wait if this runspace is currently running
                $runspaceId = $script:RpOpenRunspaces.Jobs | Where-Object { $_.InstanceId -eq $runspaceJob2 } | Select-Object -ExpandProperty RunspaceId
                #Runspace.Runspace.InstanceId | Where-Object { $_.InstanceId -eq $script:RpOpenRunspaces.Jobs.runspaceJob2.RunspaceId } | Select-Object -ExpandProperty RunspaceId

                # Retrieve the existing runspace
                $runspace = Get-Runspace -InstanceId $runspaceId

                # Create a PowerShell object and attach it to the retrieved runspace
                $ps = [System.Management.Automation.PowerShell]::Create()
                $ps.Runspace = $runspace

                # Define a script block with your commands
                $scriptBlock = {
                    # LegacyCall
                    Get-VmsCameraReport | Out-HtmlView -EnableScroller -ScrollX -AlphabetSearch -SearchPane

                    <#
                    ToDO: 01/28/25 Working in default config commands. Met resistance returning results from
                    the command object. This may be related to underlying functionalilty of using Get-VmsCameraReport
                    with a dedicated, resuable, isolated runspace. This was an issue with previous version of MIPSDK
                    but, may be resolved at this point. Same issue was with present with Show-RpCamera and was resolved
                    after memory leak was addressed. If this is the case, the command object will need to be modified
                    to return results through using a standard runspace. Thus, configuration commands can be called
                    for this report.

                    # Calling Get-RpVmsItemStateCustom from the default config commands.
                    $commandId1 = (Get-RpDefaultConfigCommandDetails).'Get-VmsCameraReport'.Id
                    $commandObject1 = (Get-RpConfigCommands -All).'Get-VmsCameraReport'.$commandId1.FormatCommandObject($commandId1)

                    # Calling Out-HtmlView from the default config commands.
                    $commandId2 = (Get-RpDefaultConfigCommandDetails).'Out-HtmlView'.Id
                    $outHtmlView = (Get-RpConfigCommands -All).'Out-HtmlView'.$commandId2.FormatCommandObject($commandId2)

                    # Invoke default config commands.
                    Invoke-RpCommandObject -CommandObject $commandObject1 -PipelineCommandObject $outHtmlView
                    #>
                }

                # Add the script block to the PowerShell object
                $ps.AddScript($scriptBlock)

                try {
                    # Begin asynchronous invocation
                    $results = $ps.BeginInvoke()

                    # Generate a log entry for job removal
                    $logAddJobText = "Job added successfully."
                    $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
                    $logAddJobMessage = "$timestamp - INFO  - GUID: $runspaceID - $logAddJobText."

                    # UI and Log message update
                    Set-RpMutexLogAndUI -logPath $logPath -message $logAddJobMessage -uiElement $script:Runspace_Mutex_Log

                    Write-Host = $logAddJobMessage

                } catch {
                    # Generate a log entry for job removal
                    $logAddJobErrorText = "Error adding job to global list: $_"
                    $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
                    $logAddJobMessage = "$timestamp - ERROR - GUID: $runspaceID - $logAddJobErrorText."

                    # UI and Log message update
                    Set-RpMutexLogAndUI -logPath $logPath -message $logAddJobMessage -uiElement $script:Runspace_Mutex_Log

                    Write-Host = $logAddJobErrorMessage
                }
            }

            ShowCameras_Click = {
                # TODO: add a warning or please wait if this runspace is currently running
                <#
                    $runspaceId = $script:openRunspaces.Jobs | Where-Object { $_.Runspace -eq $runspaceJob2 } | Select-Object -ExpandProperty RunspaceId
                    # Retrieve the existing runspace
                    $runspace = Get-Runspace -InstanceId $runspaceId
                    # Create a PowerShell object and attach it to the retrieved runspace
                    $ps = [System.Management.Automation.PowerShell]::Create()
                #>
                $platformItemcameras = Show-RPItemPicker -Title "Custom Item Picker" -Kind @("Camera") -CheckConnection
                Start-RpRunspaceJob -ScriptBlock {
                    param (
                        $platformItemcameras
                    )

                    try {
                        # testing
                        import-module C:\RemotePro\RemotePro\RemotePro.psd1

                        #$platformItemcameras | ogv

                        # LegacyCall
                        # Show-RpCamera -CameraObject $platformItemcameras -SpecifiedDaysForSequences 7 -DiagnosticLevel 3 | Out-Null

                        # 01/22/25 Working in default config commands. Met resistance as these commands are still
                        # referencing import of older module added with testing.

                        # 01/25/25 Found that the issue was related to ScriptMethod call not being freindly with
                        # dependency module calls.
                        # -Created Invoke-RpCommandObject to address this.
                        # -Modified InvokeCommand() to return formatted command object.
                        # -Renamed InvokeCommand() to FormatCommandObject()

                        # Calling Show-RpCamera from the default config commands.
                        $commandId = (Get-RpDefaultConfigCommandDetails).'Show-RpCamera'.Id
                        $AdditionalParameters = @{
                            CameraObject = $platformItemcameras
                        }
                        $commandObject = (Get-RpConfigCommands -All).'Show-RpCamera'.$commandId.FormatCommandObject($commandId,$AdditionalParameters)
                        $commandObject | Invoke-RpCommandObject


                        if ($null -eq $result) {
                            Write-Output "`nNo result returned from Show-RpCamera."
                        }
                        #return $result

                        $platformItemcameras = $null
                        $result = $null
                    } catch {
                        Write-Output "Error encountered: $_"
                        return $error[0]

                    }
                } -UseExistingRunspaceState -Argument $platformItemcameras -uiElement $script:Runspace_Mutex_Log -RunspaceJobs $script:RunspaceJobs

                Start-RpRunspaceJob -ScriptBlock {
                    param (
                        $platformItemcameras
                    )

                    try {
                        # testing
                        import-module C:\RemotePro\RemotePro\RemotePro.psd1


                        $configItemCams += Get-VmsCamera -Id $platformItemcameras.FQID.ObjectId
                        # LegacyCall
                        # Get-RpTicketBlock -Cameras $configItemCams -ShowWindow

                        # Calling Get-RpTicketBlock from the default config commands.
                        $commandId = (Get-RpDefaultConfigCommandDetails).'Get-RpTicketBlock'.Id
                        $AdditionalParameters = @{
                            Cameras = $configItemCams
                        }
                        $commandObject = (Get-RpConfigCommands -All).'Get-RpTicketBlock'.$commandId.FormatCommandObject($commandId,$AdditionalParameters)
                        $commandObject | Invoke-RpCommandObject

                        if ($null -eq $result) {
                            Write-Output "`nNo result returned from Get-RpTicketBlock."
                        }
                        #return $result

                        $configItemCams  = $null
                        $platformItemcameras = $null
                        $result = $null
                    } catch {
                        Write-Output "Error encountered: $_"
                        return $error[0]

                    }
                } -UseExistingRunspaceState -Argument $platformItemcameras -uiElement $script:Runspace_Mutex_Log -RunspaceJobs $script:RunspaceJobs

                $platformItemcameras = $null
            }

            TicketBlock_Click = {
                $platformItemcameras =  [System.Collections.Generic.List[VideoOS.Platform.ConfigurationItems.Camera]]::new()
                $platformItemcameras = Show-RPItemPicker -Title "Custom Item Picker" -Kind @("Camera", "Hardware", "Server") -ConfigItemsCamsOnly -CheckConnection
                Start-RpRunspaceJob -ScriptBlock {
                    param (
                        [Parameter()]
                        [System.Collections.Generic.List[VideoOS.Platform.ConfigurationItems.Camera]]
                        $platformItemcameras
                    )

                    try {
                        # testing
                        Import-Module C:\RemotePro\RemotePro\RemotePro.psd1 -ErrorAction Stop


                        # LegacyCall
                        # Get-RpTicketBlock -Cameras $platformItemcameras -ShowWindow

                        # Calling Get-RpTicketBlock from the default config commands.
                        $commandId = (Get-RpDefaultConfigCommandDetails).'Get-RpTicketBlock'.Id
                        $AdditionalParameters = @{
                            Cameras = $platformItemcameras
                        }
                        $commandObject = (Get-RpConfigCommands -All).'Get-RpTicketBlock'.$commandId.FormatCommandObject($commandId,$AdditionalParameters)
                        $commandObject | Invoke-RpCommandObject

                        if ($null -eq $result) {
                            Write-Output "No result returned from Get-RpTicketBlock."
                        }

                        # ToDo: 01/27/25 Add password option to Get-RpTicketBlock
                        $error[0] | Out-GridView
                        #return $result | Get-Member

                        $platformItemcameras = $null
                        $result = $null
                    } catch {
                        Write-Output "Error encountered: $_"
                        return $error[0]

                    }
                } -UseExistingRunspaceState -Argument $platformItemcameras -uiElement $script:Runspace_Mutex_Log -RunspaceJobs $script:RunspaceJobs
            }

            ShowVideoOSItems_Click = {
                Start-RpRunspaceJob -ScriptBlock {
                    try {
                        # testing
                        import-module C:\RemotePro\RemotePro\RemotePro.psd1

                        Write-Host "$(Get-Location)"

                        # LegacyCall
                        # $result = Select-VideoOSItem

                        # Calling Select-VideoOSItem from the default config commands.
                        $commandId1 = (Get-RpDefaultConfigCommandDetails).'Select-VideoOSItem'.Id
                        $commandObject1 = (Get-RpConfigCommands -All).'Select-VideoOSItem'.$commandId1.FormatCommandObject($commandId1)


<#
 # {
                        # Invoke command and filter the results.
                        $filteredResult = $commandObject1 | Invoke-RpCommandObject
                        $filteredResult | Add-Member -MemberType NoteProperty -Name CommandName -Value 'Select-VideoOSItem'
                        $filteredResult | Add-Member -MemberType NoteProperty -Name ObjectID -Value $item.FQID.ObjectId.Guid
                        $filteredResult | Select-Object FQID, ObjectId, Name, Enabled, Encrypt, Icon,
                        MapIconKey, HasRelated, Properties, Authorization, ContextMenu:ToDo: 01/28/25 Will require a command object
                        to be created using Select-Object for filtering... Not neccessary for now.}
#>

                        # Calling Out-HtmlView from the default config commands.
                        $commandId2 = (Get-RpDefaultConfigCommandDetails).'Out-HtmlView'.Id
                        $outHtmlView = (Get-RpConfigCommands -All).'Out-HtmlView'.$commandId2.FormatCommandObject($commandId2)

                        # Invoke default config commands.
                        $result = Invoke-RpCommandObject -CommandObject $commandObject1 -PipelineCommandObject $outHtmlView

                        if ($null -eq $result) {
                            Write-Output "No result returned from Show VideoOSItems."
                        }
                        return $result | gm
                    } catch {
                        Write-Output "Error encountered: $_"
                        return $_.Exception.Message
                    }
                } -UseExistingRunspaceState -uiElement $script:Runspace_Mutex_Log -RunspaceJobs $script:RunspaceJobs
            }

            Hardware_Click = {
                Start-RpRunspaceJob -ScriptBlock {
                    try {
                        # testing
                        import-module C:\RemotePro\RemotePro\RemotePro.psd1

                        #Write-Host "$(Get-Location)"

                        # LegacyCall
                        # $result = Get-RpVmsHardwareCustom -CheckConnection

                        # Calling Get-RpVmsHardwareCustom from the default config commands.
                        $commandId1 = (Get-RpDefaultConfigCommandDetails).'Get-RpVmsHardwareCustom'.Id
                        $commandObject1 = (Get-RpConfigCommands -All).'Get-RpVmsHardwareCustom'.$commandId1.FormatCommandObject($commandId1)

                        # Calling Out-HtmlView from the default config commands.
                        $commandId2 = (Get-RpDefaultConfigCommandDetails).'Out-HtmlView'.Id
                        $outHtmlView = (Get-RpConfigCommands -All).'Out-HtmlView'.$commandId2.FormatCommandObject($commandId2)

                        # Invoke default config commands.
                        Invoke-RpCommandObject -CommandObject $commandObject1 -PipelineCommandObject $outHtmlView

                        # 01/25/25 ToDo: Add results... Need to add password boolean to Get-RpVmsHardwareCustom
                        # replace with "$result = $commandObject | Invoke-RpCommandObject" when completed.

                        if ($null -eq $result) {
                            Write-Output "No result returned from Get-RpVmsHardwareCustom."
                        }
                        return $result | gm # Why GM?
                    } catch {
                        Write-Output "Error encountered: $_"
                        return $_.Exception.Message
                    }
                } -UseExistingRunspaceState -uiElement $script:Runspace_Mutex_Log -RunspaceJobs $script:RunspaceJobs
            }

            ItemState_Click = {
                Start-RpRunspaceJob -ScriptBlock {
                    param ()
                    try {
                        # testing
                        import-module C:\RemotePro\RemotePro\RemotePro.psd1

                        # LegacyCall
                        # $result = Get-RpVmsItemStateCustom -CheckConnection | Out-HtmlView -EnableScroller -ScrollX -AlphabetSearch -SearchPane

                        # Calling Get-RpVmsItemStateCustom from the default config commands.
                        $commandId1 = (Get-RpDefaultConfigCommandDetails).'Get-RpVmsItemStateCustom'.Id
                        $commandObject1 = (Get-RpConfigCommands -All).'Get-RpVmsItemStateCustom'.$commandId1.FormatCommandObject($commandId1)

                        # Calling Out-HtmlView from the default config commands.
                        $commandId2 = (Get-RpDefaultConfigCommandDetails).'Out-HtmlView'.Id
                        $outHtmlView = (Get-RpConfigCommands -All).'Out-HtmlView'.$commandId2.FormatCommandObject($commandId2)

                        # Invoke default config commands.
                        $result = Invoke-RpCommandObject -CommandObject $commandObject1 -PipelineCommandObject $outHtmlView

                        if ($null -eq $result) {
                            Write-Output "No result returned from Get-RpVmsItemStateCustom."
                        }
                        return $result
                    } catch {
                        Write-Output "Error encountered: $_"
                        return $error[0]
                    }
                } -UseExistingRunspaceState -uiElement $script:Runspace_Mutex_Log -RunspaceJobs $script:RunspaceJobs
            }
        }

        # Add the runspace event to the RunspaceEvents hashtable
        foreach ($key in $handlers.Keys) {
            # Add each handler to the hashtable, overwriting if it already exists
            $script:RemotePro.RunspaceEvents[$key] = $handlers[$key]
        }

        # Attach a custom type to RunspaceEvents
        $script:RemotePro.RunspaceEvents.PSTypeNames.Insert(0, 'RemotePro.RunspaceEvents')

        Write-Host "Runspace Events have been successfully added to RemotePro.RunspaceEvents."
    } catch {
        Write-Error "Error occured adding runspace events: $($_.Exception.Message)"
    }

}
