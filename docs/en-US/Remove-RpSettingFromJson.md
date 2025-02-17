---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.milestonepstools.com/commands/en-US/Connect-Vms/#description
schema: 2.0.0
---

# Remove-RpSettingFromJson

## SYNOPSIS
Removes a specified setting from a JSON settings file.

## SYNTAX

### ShowDialog
```
Remove-RpSettingFromJson [-SettingsFilePath <String>] [-Name <String>] [-ShowDialog]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### CommandLineInterface
```
Remove-RpSettingFromJson [-SettingsFilePath <String>] -Name <String> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Remove-RpSettingFromJson function removes a specified setting from a JSON
settings file.
The function can be run in two modes: CommandLineInterface and
ShowDialog.
In CommandLineInterface mode, the setting name is provided as a
parameter.
In ShowDialog mode, a WPF dialog is displayed to input the setting
name.

## EXAMPLES

### EXAMPLE 1
```
Remove-RpSettingFromJson -SettingsFilePath "C:\path\to\settings.json" -Name
"SettingName"
```

Removes the setting named "SettingName" from the specified JSON settings file.

### EXAMPLE 2
```
Remove-RpSettingFromJson -ShowDialog
```

Displays a WPF dialog to input the setting name and removes the specified
setting from the default JSON settings file.

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
The name of the setting to be removed.
This parameter is mandatory in
CommandLineInterface mode.

```yaml
Type: String
Parameter Sets: ShowDialog
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

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
If specified, a WPF dialog is displayed to input the setting name.
This
parameter is mandatory in ShowDialog mode.

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

## RELATED LINKS
