---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.remotepro.dev/en-US/Add-RpSettingToJson
schema: 2.0.0
---

# Add-RpSettingToJson

## SYNOPSIS
Adds a new setting to a JSON settings file.

## SYNTAX

### CommandLineInterface (Default)
```
Add-RpSettingToJson [-SettingsFilePath <String>] -Name <String> -Value <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### ShowDialog
```
Add-RpSettingToJson [-SettingsFilePath <String>] [-ShowDialog] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Add-RpSettingToJson function adds a new setting to a specified JSON settings
file.
It can be used in two modes: CommandLineInterface and ShowDialog.
In
CommandLineInterface mode, the setting name and value are provided as parameters.
In ShowDialog mode, a WPF GUI is displayed to input the setting name and value.

## EXAMPLES

### EXAMPLE 1
```
Add-RpSettingToJson -SettingsFilePath "C:\Settings.json" -Name "Theme" -Value
"Dark"
```

Adds a setting named "Theme" with the value "Dark" to the specified settings
file.
Note this is a hypothetical example and the setting may not exist in the
default settings file.

### EXAMPLE 2
```
Add-RpSettingToJson -ShowDialog
```

Displays a WPF GUI to input the setting name and value, and adds the setting to
the default settings file.

## PARAMETERS

### -SettingsFilePath
The path to the JSON settings file.
If not provided, the default settings file
path is used.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the setting to add.
This parameter is mandatory in
CommandLineInterface mode.

```yaml
Type: String
Parameter Sets: CommandLineInterface
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Value
The value of the setting to add.
This parameter is mandatory in
CommandLineInterface mode.

```yaml
Type: String
Parameter Sets: CommandLineInterface
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ShowDialog
If specified, a WPF GUI is displayed to input the setting name and value.

```yaml
Type: SwitchParameter
Parameter Sets: ShowDialog
Aliases:

Required: True
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
If the settings file does not exist, it will be created.
If the setting already
exists, a message will be displayed indicating that the setting already exists.

## RELATED LINKS

[https://www.remotepro.dev/en-US/Add-RpSettingToJson](https://www.remotepro.dev/en-US/Add-RpSettingToJson)

