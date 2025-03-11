---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.remotepro.dev/en-US/Set-RpSettingsJsonDefaults
schema: 2.0.0
---

# Set-RpSettingsJsonDefaults

## SYNOPSIS
Sets the default settings for RemotePro JSON configuration.

## SYNTAX

```
Set-RpSettingsJsonDefaults [[-SettingsFilePath] <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
This cmdlet sets the default settings values for the RemotePro
application JSON configuration.
It ensures that all necessary settings are initialized
with their default values.

## EXAMPLES

### EXAMPLE 1
```
Set-RpSettingsJsonDefaults -SettingsFilePath (Get-RpSettingsJsonPath)
```

This example sets the default settings values in the default settings JSON file.
This is the default behavior if no settings file path is provided.

### EXAMPLE 2
```
Set-RpSettingsJsonDefaults -SettingsFilePath "C:\Config\RemoteProSettings.json"
```

This example sets the default settings values in the specified settings JSON file.

## PARAMETERS

### -SettingsFilePath
The path to the settings JSON file where the default settings will
be applied.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
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

### None. This cmdlet does not produce any output.
## NOTES

## RELATED LINKS

[https://www.remotepro.dev/en-US/Set-RpSettingsJsonDefaults](https://www.remotepro.dev/en-US/Set-RpSettingsJsonDefaults)

