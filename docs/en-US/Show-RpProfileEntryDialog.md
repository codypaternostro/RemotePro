---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.remotepro.dev/en-US/Show-RpProfileEntryDialog
schema: 2.0.0
---

# Show-RpProfileEntryDialog

## SYNOPSIS
Displays a dialog for entering or editing a connection profile's details.

## SYNTAX

```
Show-RpProfileEntryDialog [-Edit] [[-SelectedProfile] <PSObject>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
This cmdlet shows a graphical dialog window that allows the user
to input connection profile details such as Profile Name, Server
Address, Username, and other settings.
The dialog collects the
necessary parameters to create or edit a connection profile.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Edit
Switch to edit an existing profile.
If enabled, it will load the selected
profile's details.

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

### -SelectedProfile
The selected connection profile to load into the form when in edit mode.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
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

[https://www.remotepro.dev/en-US/Show-RpProfileEntryDialog](https://www.remotepro.dev/en-US/Show-RpProfileEntryDialog)

