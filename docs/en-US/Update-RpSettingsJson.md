---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.remotepro.dev/en-US/Update-RpSettingsJson
schema: 2.0.0
---

# Update-RpSettingsJson

## SYNOPSIS
Updates or adds a setting in the RpSettings JSON file.

## SYNTAX

### CommandLineInterface (Default)
```
Update-RpSettingsJson [[-SettingsFilePath] <String>] [-Name] <String> [-Value] <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### ShowDialog
```
Update-RpSettingsJson [[-SettingsFilePath] <String>] [-ShowDialog] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Update-RpSettingsJson function updates or adds a setting in the RpSettings
JSON file.
It can be used via command line interface or a graphical dialog
interface.

## EXAMPLES

### EXAMPLE 1
```
Update-RpSettingsJson -Name "SettingName" -Value "NewValue"
```

Updates the setting "SettingName" to "NewValue" in the default settings JSON
file.

### EXAMPLE 2
```
Update-RpSettingsJson -SettingsFilePath "C:\Path\To\Settings.json" -Name "SettingName" -Value "NewValue"
```

Updates the setting "SettingName" to "NewValue" in the specified settings JSON
file.

### EXAMPLE 3
```
Update-RpSettingsJson -ShowDialog
Opens a graphical dialog interface to update or add settings in the default
settings JSON file.
```

## PARAMETERS

### -SettingsFilePath
Specifies the path to the settings JSON file.
If not provided, the default
settings file path is used.

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

### -Name
Specifies the name of the setting to update or add.
This parameter is mandatory
when using the command line interface.

```yaml
Type: String
Parameter Sets: CommandLineInterface
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Value
Specifies the value of the setting to update or add.
This parameter is mandatory
when using the command line interface.

```yaml
Type: String
Parameter Sets: CommandLineInterface
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ShowDialog
If specified, a graphical dialog interface is shown to update or add settings.

```yaml
Type: SwitchParameter
Parameter Sets: ShowDialog
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

[https://www.remotepro.dev/en-US/Update-RpSettingsJson](https://www.remotepro.dev/en-US/Update-RpSettingsJson)

