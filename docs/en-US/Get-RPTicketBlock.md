---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.milestonepstools.com/commands/en-US/Connect-Vms/#description
schema: 2.0.0
---

# Get-RPTicketBlock

## SYNOPSIS
Retrieves hardware and stream information for a list of camera configuration items.

## SYNTAX

```
Get-RPTicketBlock -Cameras <System.Collections.Generic.List`1[VideoOS.Platform.ConfigurationItems.Camera]>
 [-ShowWindow] [-ReturnObjects] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function processes a list of camera configuration items, retrieves relevant
hardware information such as the recording server, hardware name, stream name,
serial number, model, IP address, MAC address, username, and password.
The data
is grouped into an array of PSCustomObjects representing each camera's hardware
details.
Optionally, the information can be displayed in a WPF window and/or
returned as objects to the pipeline.

## EXAMPLES

### EXAMPLE 1
```
Get-RPTicketBlock -Cameras $cameraList -showWindow
```

Retrieves camera hardware information from the specified camera configuration items
and displays it in a WPF window.

### EXAMPLE 2
```
$cameraInfo = Get-RPTicketBlock -Cameras $cameraList -ReturnObjects
```

Retrieves camera hardware information from the specified camera configuration items
and returns the results as objects to the pipeline.

### EXAMPLE 3
```
$cameraList | Get-RPTicketBlock -showWindow
```

Pipes a list of camera configuration items and displays the retrieved hardware
information in a WPF window.

## PARAMETERS

### -Cameras
A list of camera configuration items (VideoOS.Platform.ConfigurationItems.Camera)
from which the hardware information will be retrieved.
This parameter is mandatory
and accepts input from the pipeline.

```yaml
Type: System.Collections.Generic.List`1[VideoOS.Platform.ConfigurationItems.Camera]
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ShowWindow
If specified, a WPF window will display the grouped camera hardware information
in a formatted list.
The window allows users to click on an item to copy its details.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReturnObjects
If specified, the function returns the grouped camera hardware information as
PSCustomObject items to the pipeline.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
