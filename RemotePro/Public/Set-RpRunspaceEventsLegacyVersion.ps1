function Set-RpRunspaceEventsLegacyVersion {
    <#
    .SYNOPSIS
    *
    Legacy version of Set-RpRunspaceEvents.
    Does not use RemoteProParamConfig.json.
    *

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
                Get-VmsCameraReport | Out-HtmlView -EnableScroller -ScrollX -AlphabetSearch -SearchPane
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
                    Import-Module -Name RemotePro

                    #$platformItemcameras | ogv

                    Show-RpCamera -CameraObject $platformItemcameras -SpecifiedDaysForSequences 7 -DiagnosticLevel 3 | Out-Null

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
                    Import-Module -Name RemotePro


                    $configItemCams += Get-VmsCamera -Id $platformItemcameras.FQID.ObjectId
                    Get-RpTicketBlock -Cameras $configItemCams -ShowWindow

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
                    Import-Module -Name RemotePro -ErrorAction Stop



                    Get-RpTicketBlock -Cameras $platformItemcameras -ShowWindow

                    if ($null -eq $result) {
                        Write-Output "No result returned from Get-RpTicketBlock."
                    }

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
                    Import-Module -Name RemotePro

                    Write-Host "$(Get-Location)"

                    $result = Select-VideoOSItem
                    $result | Add-Member -MemberType NoteProperty -Name ObjectID -Value $item.FQID.ObjectId.Guid
                    $result | Select-Object FQID, ObjectId, Name, Enabled, Encrypt, Icon, MapIconKey, HasRelated, Properties, Authorization, ContextMenu  |
                        Out-HtmlView -EnableScroller -ScrollX -AlphabetSearch -SearchPane
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
                    Import-Module -Name RemotePro

                    Write-Host "$(Get-Location)"

                    $result = Get-RpVmsHardwareCustom -CheckConnection
                    if ($null -eq $result) {
                        Write-Output "No result returned from Get-RpVmsHardwareCustom."
                    }
                    return $result | gm
                } catch {
                    Write-Output "Error encountered: $_"
                    return $_.Exception.Message
                }
            } -UseExistingRunspaceState -uiElement $script:Runspace_Mutex_Log -RunspaceJobs $script:RunspaceJobs
        }

        ItemState_Click = {
            Start-RpRunspaceJob -ScriptBlock {
                try {
                    Import-Module -Name RemotePro

                    $result = Get-RpVmsItemStateCustom -CheckConnection | Out-HtmlView -EnableScroller -ScrollX -AlphabetSearch -SearchPane
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
}
