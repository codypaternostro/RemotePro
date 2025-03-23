---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version: https://www.remotepro.dev/en-US/Remove-RpConfigCommand
schema: 2.0.0
---

# Remove-RpConfigCommand

## SYNOPSIS
Removes a configuration command from the RemotePro controller object.

## SYNTAX

```
Remove-RpConfigCommand [-CommandName] <String> [-Id] <String> [-Scope] <String> [[-ConfigFilePath] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Remove-RpConfigCommand cmdlet removes a specified configuration command
from the RemotePro controller object.

## EXAMPLES

### EXAMPLE 1
```
Remove-RpConfigCommand -CommandName "TestCommand" -Id "12345" -Scope "Config"
```

This command removes the configuration command named "TestCommand" with the
Id "12345" from the configuration file.

## PARAMETERS

### -CommandName
The name of the configuration command to remove.
This parameter is mandatory
and accepts pipeline input by property name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Id
The unique identifier of the configuration command to remove.
This parameter
is mandatory and accepts pipeline input by property name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Scope
Specifies the scope of the configuration command to remove.
Valid values are
"ControllerObject" and "ConfigCommand".
This parameter is mandatory.

Please see Get-RpControllerObject and Find-RpConfigCommand to verify
the source data being modified.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ConfigFilePath
The path to the configuration JSON file.
This parameter is optional and
accepts pipeline input by property name.
If not specified, the default
configuration path is used.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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

### System.String
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS

[https://www.remotepro.dev/en-US/Remove-RpConfigCommand](https://www.remotepro.dev/en-US/Remove-RpConfigCommand)

