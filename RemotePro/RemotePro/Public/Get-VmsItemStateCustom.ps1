function Get-VmsItemStateCustom {
    <#
    .SYNOPSIS
    Retrieves and displays the state of VMS items with optional connection validation.

    .DESCRIPTION
    This function retrieves the state of VMS items, specifically cameras, and displays the results in an HTML view.
    It also provides an optional parameter to validate the connection before processing.

    .PARAMETER CheckConnection
    Validates the VMS connection before processing the items.
    If the connection is not valid, the function will display an error message and exit early.

    .EXAMPLE
    Get-VmsItemStateCustom -CheckConnection

    This example validates the VMS connection before retrieving and displaying the state of the items.
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
        try {
            # Create a list to hold the custom objects
            $list = New-Object System.Collections.Generic.List[object]

            # Query and process the cameras
            $items = Get-itemstate -CamerasOnly | Select-Object -Property State, fqid -ExpandProperty fqid
            foreach ($itemData in $items) {
                $item = $itemData.FQID | Get-PlatformItem

                $entry = [PSCustomObject]@{
                    Name        = $item.name
                    ServerId    = $itemData.ServerId.Id
                    ServerUri   = $itemData.ServerId.Uri
                    ParentId    = $itemData.ParentId
                    ObjectId    = $itemData.ObjectId
                    Kind        = $itemData.Kind
                    FolderType  = $itemData.FolderType
                    State       = $itemData.State
                }

                # Add the custom object to the list
                $list.Add($entry)
            }

            # Filtering list before output
            $listFiltered = $list | Select-Object Name, State, ServerId, ServerUri, ParentId, ObjectId, Kind, FolderType
            $listFiltered | Out-HtmlView -EnableScroller -AlphabetSearch -SearchPane
            return $listFiltered

            $list = $null
            $listFiltered = $null
        } catch {
            Write-Error "An error occurred: $_"
        }
    }
}
