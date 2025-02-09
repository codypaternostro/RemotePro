---
external help file: RemotePro-help.xml
Module Name: RemotePro
online version:
schema: 2.0.0
---

# Find-RpDefaultConfigCommands

## SYNOPSIS
Retrieves the default configuration commands from the
RemoteProParamConfigDefaultIds.json file.

## SYNTAX

```
Find-RpDefaultConfigCommands [[-CommandName] <String>] [[-Id] <String>] [[-ConfigFilePath] <String>] [-All]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Find-RpDefaultConfigCommands function is used to retrieve the default
configuration commands from the RemoteProParamConfigDefaultIds.json file
using the Get-RpConfigPath -DefaultIds cmdlet.
It can retrieve commands
by name, by Id, or all commands across all modules.

## EXAMPLES

### EXAMPLE 1
```
Find-RpDefaultConfigCommands -CommandName "ExampleCommand"
```

### EXAMPLE 2
```
Find-RpDefaultConfigCommands -Id "12345"
```

### EXAMPLE 3
```
Find-RpDefaultConfigCommands -All
```

## PARAMETERS

### -CommandName
The name of the command to retrieve.

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

### -Id
The Id of the command to retrieve.

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

### -ConfigFilePath
The path to the configuration JSON file.
If not specified, the default
path is used.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -All
Switch to retrieve all commands from all modules.

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
