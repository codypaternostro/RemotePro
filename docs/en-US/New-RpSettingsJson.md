---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.milestonepstools.com/commands/en-US/Connect-Vms/#description
schema: 2.0.0
---

# New-RpSettingsJson

## SYNOPSIS
Creates a new settings JSON file for RemotePro.

## SYNTAX

```
New-RpSettingsJson [[-SettingsFilePath] <String>] [-UseDefaults] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The New-RpSettingsJson function generates a new settings JSON file for
RemotePro.
It can either use a specified file path or determine the path
automatically.
Optionally, it can populate the settings with default values.

## EXAMPLES

### EXAMPLE 1
```
New-RpSettingsJson -SettingsFilePath "C:\path\to\settings.json"
```

Creates a new settings JSON file at the specified path.

### EXAMPLE 2
```
New-RpSettingsJson -UseDefaults
```

Creates a new settings JSON file with default values at the automatically
determined path.

## PARAMETERS

### -SettingsFilePath
Specifies the file path where the settings JSON file will be saved.
If not
provided, the path is determined automatically.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseDefaults
If specified, the settings JSON will be populated with default values.

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
