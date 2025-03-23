---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://gist.github.com/joshooaj/9cf16a92c7e57496b6156928a22f758f
schema: 2.0.0
---

# Show-RpCamera

## SYNOPSIS
Displays a UI for live viewing or playback of camera feeds in a security
system.

## SYNTAX

### RpItemPickerSet (Default)
```
Show-RpCamera [-ShowRpItemPicker] [-DiagnosticLevel <String>] -SpecifiedDaysForSequences <Int32>
 [-CheckConnection] [<CommonParameters>]
```

### CameraObjectSet
```
Show-RpCamera -CameraObject <Object> [-DiagnosticLevel <String>] -SpecifiedDaysForSequences <Int32>
 [-CheckConnection] [<CommonParameters>]
```

### IdSet
```
Show-RpCamera -Id <Guid[]> [-DiagnosticLevel <String>] -SpecifiedDaysForSequences <Int32> [-CheckConnection]
 [<CommonParameters>]
```

### SelectCameraSet
```
Show-RpCamera [-ShowSelectCamera] [-DiagnosticLevel <String>] -SpecifiedDaysForSequences <Int32>
 [-CheckConnection] [<CommonParameters>]
```

## DESCRIPTION
The Show-RpCamera function allows users to interact with camera feeds using
different methods of camera selection.
It supports viewing live feeds,
playback of recorded sequences, and diagnostics overlay on the video feed.
Users can select cameras by ID, through a direct camera object, or via user
interface dialogs.
Please see link for original script from joshooaj who
inspired all of RemotePro from sharing this incredible function.

## EXAMPLES

### EXAMPLE 1
```
Show-RpCamera -ShowSelectCamera
```

This command opens the standard camera selection dialog and displays the
selected camera feed without any diagnostic overlays.

### EXAMPLE 2
```
Show-RpCamera -Id '12345678-9abc-def0-1234-567890abcdef' -SpecifiedDaysForSequences 7
```

This command displays the feed of a camera identified by the specified GUID
with sequence data for the past 7 days.

### EXAMPLE 3
```
Show-RpCamera -ShowRpItemPicker -DiagnosticLevel '3' -SpecifiedDaysForSequences 30
```

This command uses a custom item picker for camera selection and shows the
selected camera feed with a high diagnostic level overlay for the past 30
days.

## PARAMETERS

### -CameraObject
Directly pass a camera object to alleviate object dependency between
threads.
Mandatory in the 'CameraObjectSet' parameter set.

```yaml
Type: Object
Parameter Sets: CameraObjectSet
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Id
Specifies the camera IDs as GUIDs.
When this parameter is used, camera
selection dialogs are bypassed.
Mandatory in the 'IdSet' parameter set.

```yaml
Type: Guid[]
Parameter Sets: IdSet
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ShowRpItemPicker
Displays a custom item picker dialog for camera selection.
Mandatory in the
'RpItemPickerSet' parameter set.

```yaml
Type: SwitchParameter
Parameter Sets: RpItemPickerSet
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ShowSelectCamera
Uses the default camera selection dialog.
Mandatory in the 'SelectCameraSet'
parameter set.

```yaml
Type: SwitchParameter
Parameter Sets: SelectCameraSet
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DiagnosticLevel
Specifies the diagnostic overlay level (0-4) for the video feed.
This is
optional and defaults to '0'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -SpecifiedDaysForSequences
Specifies the number of days for which to generate and display sequence data
from motion-triggered recordings.
This parameter is mandatory.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -CheckConnection
Validates the VMS connection before attempting to show cameras.
If the
connection is invalid, an error dialog is shown.
This parameter is optional.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
- Requires a connection to a VMS (Video Management System).
- Designed for use in environments where monitoring multiple camera feeds is
crucial.
- Flexible camera selection is provided to accommodate different user
preferences and requirements.

## RELATED LINKS

[https://gist.github.com/joshooaj/9cf16a92c7e57496b6156928a22f758f](https://gist.github.com/joshooaj/9cf16a92c7e57496b6156928a22f758f)

[https://www.remotepro.dev/en-US/Show-RpCamera](https://www.remotepro.dev/en-US/Show-RpCamera)

