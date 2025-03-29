---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.remotepro.dev/en-US/New-RpSettingsJson
schema: 2.0.0
---

# New-RpShortcut

## SYNOPSIS
Creates or deletes a RemotePro shortcut that runs Start-RpRemotePro using Windows PowerShell.

## SYNTAX

```
New-RpShortcut [[-ShortcutName] <String>] [[-IconPath] <String>] [[-ShortcutPath] <String>] [-DeleteShortcut]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function creates a shortcut to Start-RpRemotePro using powershell.exe.
It will skip creation if the shortcut already exists.
Use the -DeleteShortcut switch to remove the shortcut instead.

## EXAMPLES

### EXAMPLE 1
```
New-RpShortcut
```

Creates "Remote Pro.lnk" on Desktop if it doesn't already exist.

### EXAMPLE 2
```
New-RpShortcut -DeleteShortcut
```

Deletes "RemotePro.lnk" from Desktop if it exists.

### EXAMPLE 3
```
New-RpShortcut -ShortcutName "MyTool.lnk" -ShortcutPath "C:\Links" -DeleteShortcut
```

Deletes C:\Links\MyTool.lnk

## PARAMETERS

### -ShortcutName
Optional name of the shortcut file.
Defaults to "RemotePro.lnk".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Remote Pro.lnk
Accept pipeline input: False
Accept wildcard characters: False
```

### -IconPath
Optional path to a custom .ico file.
Defaults to Get-RpIconPath.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ShortcutPath
Optional path or folder.
If not specified, defaults to the Desktop.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeleteShortcut
If specified, deletes the shortcut instead of creating it.

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
