---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version:
schema: 2.0.0
---

# Find-RpSettingsJson

## SYNOPSIS
Retrieves settings from the RemotePro Settings JSON file.

## SYNTAX

### All (Default)
```
Find-RpSettingsJson [-SettingsFilePath <String>] [-All] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### ByName
```
Find-RpSettingsJson [-SettingsFilePath <String>] -Name <String> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Find-RpSettingsJson function retrieves specific settings or all settings
from the RemotePro Settings JSON file.
If no file path is provided, it uses
the default path from Get-RpSettingsJsonPath.

## EXAMPLES

### EXAMPLE 1
```
Find-RpSettingsJson -SettingsFilePath "C:\path\to\settings.json" -Name "SettingName"
```

Retrieves the specified setting from the provided JSON file path.

### EXAMPLE 2
```
Find-RpSettingsJson -All
```

Retrieves all settings from the default JSON file path.

## PARAMETERS

### -SettingsFilePath
The path to the RemotePro Settings JSON file.
If not provided, the default
path is used.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
The name of the setting to retrieve from the JSON file.

```yaml
Type: String
Parameter Sets: ByName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -All
Switch to retrieve all settings from the JSON file.

```yaml
Type: SwitchParameter
Parameter Sets: All
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
