---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version:
schema: 2.0.0
---

# Set-RpSettingsJson

## SYNOPSIS
Sets the RemotePro settings from a JSON file.

## SYNTAX

```
Set-RpSettingsJson [[-SettingsFilePath] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Set-RpSettingsJson function initializes the RemotePro settings from a JSON
file.
If the RemotePro object is not initialized, it throws an error.
If the
settings are not a hashtable, it initializes them as an empty hashtable.
It
imports the settings from the specified JSON file or from the default appdata
path if no file path is provided.
The settings are then attached to the
RemotePro object with a custom type.

## EXAMPLES

### EXAMPLE 1
```
Set-RpSettingsJson -SettingsFilePath "C:\path\to\settings.json"
This command sets the RemotePro settings from the specified JSON file.
```

## PARAMETERS

### -SettingsFilePath
The path to the JSON file containing the settings.
If not provided, the default
appdata path is used.

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

### [string] The path to the settings JSON file where the default settings will be applied.
## OUTPUTS

## NOTES
Ensure that the RemotePro object is initialized by running New-RpControllerObject
before calling this function.

## RELATED LINKS
