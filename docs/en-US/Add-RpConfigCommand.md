---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.remotepro.dev/en-US/Add-RpConfigCommand
schema: 2.0.0
---

# Add-RpConfigCommand

## SYNOPSIS
Exports command configurations from RemotePro to a JSON file.
Allows GUI-based or parameter-based input for command selection.

## SYNTAX

### ShowDialog (Default)
```
Add-RpConfigCommand [-Description <String>] [-ShowDialog] [<CommonParameters>]
```

### ConfigurationItems
```
Add-RpConfigCommand [[-ModuleName] <String>] [[-CommandNames] <String[]>] [[-ConfigFilePath] <String>]
 [-Description <String>] [<CommonParameters>]
```

## DESCRIPTION
The \`Add-RpConfigCommand\` function exports specified commands from a
PowerShell module to a JSON configuration file.
It can gather input
interactively via a GUI dialog or directly through parameters.

If the configuration file does not exist, a new one is created.
Existing
commands can be updated by specifying an ID.
Parameters include a
module name, command names, file path, optional description, and
show dialog.

## EXAMPLES

### EXAMPLE 1
```
Add-RpConfigCommand -ModuleName "RemotePro" -ConfigFilePath "C:\Config.json" `
```

-CommandNames "Get-RpEventHandlers", "Set-RpConfig" \`
                    -Description "Initial configuration export"

Exports "Get-RpEventHandlers" and "Set-RpConfig" commands from the
"RemotePro" module to a JSON file at \`C:\Config.json\`.

### EXAMPLE 2
```
Add-RpConfigCommand -ModuleName "RemotePro" -ShowDialog
```

Opens a GUI dialog for selecting module, commands, configuration path,
and description, then exports the chosen commands to the JSON file.

## PARAMETERS

### -ModuleName
Specifies the name of the PowerShell module from which to export
commands.
Required.

```yaml
Type: String
Parameter Sets: ConfigurationItems
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CommandNames
Specifies a list of specific commands to export from the
module.

```yaml
Type: String[]
Parameter Sets: ConfigurationItems
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ConfigFilePath
Specifies the path where the JSON configuration file is saved.
If the
file does not exist, it will be created.
Default: \`Get-RpConfigPath\`

```yaml
Type: String
Parameter Sets: ConfigurationItems
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
Optional.
A brief description for the command being exported.

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

### -ShowDialog
Optional.
Displays a GUI dialog for input.
If selected, all other
parameters are ignored, and user input is collected via the dialog.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Ensure that the PresentationFramework assembly is available for WPF
support to allow GUI interaction.
A new configuration file will be created
if it doesnâ€™t already exist.

## RELATED LINKS

[https://www.remotepro.dev/en-US/Add-RpConfigCommand](https://www.remotepro.dev/en-US/Add-RpConfigCommand)

