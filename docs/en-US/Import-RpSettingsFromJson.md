---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.remotepro.dev/en-US/Import-RpSettingsFromJson
schema: 2.0.0
---

# Import-RpSettingsFromJson

## SYNOPSIS
Imports settings from a JSON configuration file.

## SYNTAX

```
Import-RpSettingsFromJson [[-SettingsFilePath] <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Import-RpSettingsFromJson function reads a JSON configuration file from the
specified path and converts it into a hashtable.
If no path is provided,
it uses a default path obtained from Get-RpSettingsJsonPath.

## EXAMPLES

### EXAMPLE 1
```
Import-RpSettingsFromJson -SettingsFilePath "$(Get-RpSettingsJsonPath)"
```

This command imports settings from the specified JSON file.

### EXAMPLE 2
```
Import-RpSettingsFromJson
```

This command imports settings from the default JSON file path.

## PARAMETERS

### -SettingsFilePath
The path to the JSON configuration file.
If not provided, a default path is used.

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

### System.Collections.Hashtable
## NOTES

## RELATED LINKS

[https://www.remotepro.dev/en-US/Import-RpSettingsFromJson](https://www.remotepro.dev/en-US/Import-RpSettingsFromJson)

