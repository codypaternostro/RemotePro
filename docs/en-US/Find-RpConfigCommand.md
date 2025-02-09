---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version:
schema: 2.0.0
---

# Find-RpConfigCommand

## SYNOPSIS
Retrieves details of a specific command or all commands from the config file.

## SYNTAX

```
Find-RpConfigCommand [[-ModuleName] <String>] [[-CommandName] <String>] [-Id <String>]
 [-ConfigFilePath <String>] [-All] [-ByModule] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Find-RpConfigCommand retrieves the details of a specific command or all
commands from the provided configuration JSON file.
It can return command
details for one command, all commands within a module, or all commands
across all modules using the \`-All\` and \`-ByModule\` parameters.

## EXAMPLES

### EXAMPLE 1
```
Find-RpConfigCommand -ModuleName 'RemotePro' -CommandName 'Get-RpLogPath' -ConfigFilePath $(Get-RpConfigurationPath)
Retrieves the 'Get-RpLogPath' command details from the 'RemotePro' module
using the configuration path from Get-RpConfigurationPath.
```

### EXAMPLE 2
```
Find-RpConfigCommand -ByModule -ModuleName 'RemotePro' -ConfigFilePath $(Get-RpConfigurationPath)
Retrieves all commands within the 'RemotePro' module.
```

### EXAMPLE 3
```
Find-RpConfigCommand -All -ConfigFilePath $(Get-RpConfigurationPath)
Retrieves all commands from all modules in the configuration.
```

### EXAMPLE 4
```
Find-RpConfigCommand -Id '12345' -ConfigFilePath $(Get-RpConfigurationPath)
Retrieves the command with the Id '12345' from the configuration.
```

## PARAMETERS

### -ModuleName
The name of the module where the command is located.

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

### -CommandName
The name of the command to retrieve from the module.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Id
Retrieves the command by its unique identifier (Id).
Useful for finding a
command by Id to debug or troubleshoot when the command name has a
duplicate Id.

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

### -ConfigFilePath
The path to the configuration JSON file that stores the command details.

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

### -All
Retrieves all commands from all modules in the configuration.

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

### -ByModule
Retrieves all commands within the specified module.

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
